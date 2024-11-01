local books_collected = 0;
local books_collected_list = {};
local books_mission_regions = {};
local books_mission_characters = {};
local books_mission_factions = {};
local books_faction_specific = true;
local books_vfx_key = "scripted_effect3";

book_objective_overrides = {
	["CAPTURE_REGIONS"] = "wh2_dlc09_objective_override_occupy_settlement",
	["ENGAGE_FORCE"] = "wh2_dlc09_objective_override_defeat_rogue_army"
};

local books_mission_prefix = "wh2_dlc09_books_of_nagash_"

nagash_book_participant_cultures = {
	["wh2_dlc09_tmb_tomb_kings"] = true
}

nagash_book_participant_factions = {
	["wh_main_vmp_vampire_counts"] = true,
	["wh3_main_emp_cult_of_sigmar"] = true
}

function does_local_faction_have_books_of_nagash()
	local local_faction = cm:get_local_faction(true)
	
	return nagash_book_participant_factions[local_faction:name()] or nagash_book_participant_cultures[local_faction:culture()]
end

function fail_books_of_nagash_missions_for_other_players(completing_faction, mission_key)
	local human_factions = cm:get_human_factions();

	for i = 1, #human_factions do
		local faction = cm:get_faction(human_factions[i])
		local faction_name = faction:name()
		if nagash_book_participant_cultures[faction:culture()] or nagash_book_participant_factions[faction_name] then
			if completing_faction ~= faction_name then
				cm:fail_custom_mission(faction_name, mission_key)
			end
		end
	end
end

core:add_listener(
	"NagashBooks_MissionSucceeded",
	"MissionSucceeded",
	true,
	function(context)
		local mission_key = context:mission():mission_record_key();
		if string.find(mission_key, books_mission_prefix) then
			local faction = context:faction();
			local faction_name = faction:name();
			remove_book_region_vfx(mission_key);
			remove_book_character_vfx(mission_key);
			fail_books_of_nagash_missions_for_other_players(faction_name, mission_key);
			books_mission_factions[mission_key] = nil;
			
			-- track the faction's number of books for victory conditions etc
			local books_of_nagash_count = cm:get_saved_value("books_of_nagash_count_" .. faction_name) or 0
			books_of_nagash_count = books_of_nagash_count + 1
			core:trigger_event("ScriptEventBookOfNagashGained", faction, books_of_nagash_count);
			cm:set_saved_value("books_of_nagash_count_" .. faction_name, books_of_nagash_count)
		end
	end,
	true
);

function add_nagash_books_listeners()
	out("#### Adding Books of Nagash Listeners ####");
	
	-- Sets lists for Immortal Empires
	book_objective_list = book_objective_list_grand;
	book_objective_list_faction = book_objective_list_faction_grand;
	
	if cm:is_new_game() then
		local human_factions = cm:get_human_factions();
		local should_spawn = true
		
		for i = 1, #human_factions do
			local faction = cm:get_faction(human_factions[i])
			if nagash_book_participant_cultures[faction:culture()] or nagash_book_participant_factions[faction:name()] then
				setup_book_missions(human_factions[i], should_spawn, cm:is_multiplayer());
				should_spawn = false
			end
		end
	end
end

function setup_book_missions(faction_key, spawn_forces, is_mp)
	cm:disable_event_feed_events(true, "", "wh_event_subcategory_faction_missions_objectives", "");
	
	if books_faction_specific and not is_mp then
		-- Switch the books to specific locations for certain factions in singleplayer
		if book_objective_list_faction[faction_key] ~= nil then
			book_objective_list = book_objective_list_faction[faction_key];
		end
	end
	
	-- Create the book objectives
	local book_objective_count = #book_objective_list;
	
	for i = 1, book_objective_count do
		local mm = mission_manager:new(faction_key, books_mission_prefix .. i);
		
		local book_objective_number = cm:random_number(#book_objective_list);
		
		if is_mp then
			book_objective_number = i;
		end
		
		local book_objective = book_objective_list[book_objective_number];
		
		mm:add_new_objective(book_objective.objective);
		mm:set_mission_issuer("BOOK_NAGASH");
		
		if book_objective.objective == "CAPTURE_REGIONS" then
			mm:add_condition("region " .. book_objective.target);
			mm:add_condition("ignore_allies");
			
			books_mission_regions[books_mission_prefix .. i] = book_objective.target;
			
			if does_local_faction_have_books_of_nagash() then
				local region = cm:get_region(book_objective.target);
				
				if region then
					local garrison_residence = region:garrison_residence();
					local garrison_residence_CQI = garrison_residence:command_queue_index();
					cm:add_garrison_residence_vfx(garrison_residence_CQI, books_vfx_key, true);
					out("Adding Books of Nagash scripted VFX to garrison...\n\tGarrison CQI: " .. garrison_residence_CQI .. "\n\tVFX: " .. books_vfx_key);
				else
					script_error("Could not find region with key [" .. book_objective.target .. "] to apply a Books of Nagash scripted VFX to");
					return;
				end
			end
		elseif book_objective.objective == "ENGAGE_FORCE" then
			if spawn_forces then
				cm:spawn_rogue_army(book_objective.target, book_objective.pos.x, book_objective.pos.y);
				cm:force_diplomacy("all", "faction:" .. book_objective.target, "all", false, false, true);
				
				if book_objective.patrol ~= nil then
					out("Setting Books of Nagash rogue army patrol path for " .. book_objective.target);
					local im = invasion_manager;
					local rogue_force = cm:get_faction(book_objective.target):faction_leader():military_force();
					local book_patrol = im:new_invasion_from_existing_force("BOOK_PATROL_" .. book_objective.target, rogue_force);
					book_patrol:set_target("PATROL", book_objective.patrol);
					book_patrol:apply_effect("wh2_dlc09_bundle_book_rogue_army", -1);
					book_patrol:start_invasion();
				end
			end
			
			cm:force_diplomacy("faction:" .. faction_key, "faction:" .. book_objective.target, "war", true, true, false);
			
			local faction_leader = cm:get_faction(book_objective.target):faction_leader()
			local force_cqi = faction_leader:military_force():command_queue_index();
			local leader_cqi = faction_leader:command_queue_index();
			mm:add_condition("cqi " .. force_cqi);
			mm:add_condition("requires_victory");
			
			if does_local_faction_have_books_of_nagash() then
				out("Adding Books of Nagash scripted VFX to character...\n\tCharacter CQI: " .. leader_cqi .. "\n\tVFX: " .. books_vfx_key);
				cm:add_character_vfx(leader_cqi, books_vfx_key, true);
			end
			
			books_mission_characters[books_mission_prefix .. i] = leader_cqi;
			books_mission_factions[books_mission_prefix .. i] = book_objective.target;
		end
		
		if book_objective_overrides[book_objective.objective] ~= nil then
			mm:add_condition("override_text mission_text_text_" .. book_objective_overrides[book_objective.objective]);
		end
		
		if(faction_key == "wh_main_vmp_vampire_counts") then
			mm:add_payload("effect_bundle{bundle_key wh3_main_books_of_nagash_mannfred_reward_" .. i .. ";turns 0;}");
		elseif(faction_key == "wh3_main_emp_cult_of_sigmar") then
			mm:add_payload("effect_bundle{bundle_key wh3_main_books_of_nagash_volkmar_reward_" .. i .. ";turns 0;}");
		else
			mm:add_payload("effect_bundle{bundle_key wh2_dlc09_books_of_nagash_reward_" .. i .. ";turns 0;}");
		end

		mm:set_should_whitelist(false);
		mm:trigger();
		
		if not is_mp then
			table.remove(book_objective_list, book_objective_number);
		end
	end
	
	-- Arkhan's book. Automatically fails for everyone but him.
	local is_arkhan = (faction_key == "wh2_dlc09_tmb_followers_of_nagash");
	local mm2 = mission_manager:new(faction_key, "wh2_dlc09_books_of_nagash_9");
	mm2:add_new_objective("SCRIPTED");
	mm2:add_condition("script_key arkhan_book_mission_" .. faction_key);
	
	if is_arkhan then
		mm2:add_condition("override_text mission_text_text_wh2_dlc09_objective_override_arkhan_book_owned");
	else
		mm2:add_condition("override_text mission_text_text_wh2_dlc09_objective_override_arkhan_book");
	end
	
	mm2:add_payload("effect_bundle{bundle_key wh2_dlc09_books_of_nagash_reward_9;turns 0;}");
	mm2:set_should_whitelist(false);
	mm2:trigger();
	cm:complete_scripted_mission_objective(faction_key, "wh2_dlc09_books_of_nagash_9", "arkhan_book_mission_" .. faction_key, is_arkhan);
	
	cm:callback(function() cm:disable_event_feed_events(false, "", "wh_event_subcategory_faction_missions_objectives", "") end, 1);
end

function remove_book_region_vfx(mission_key)
	if books_mission_regions[mission_key] ~= nil and does_local_faction_have_books_of_nagash() then
		local region_key = books_mission_regions[mission_key];
		local region = cm:model():world():region_manager():region_by_key(region_key);
		local garrison_residence = region:garrison_residence();
		local garrison_residence_CQI = garrison_residence:command_queue_index();
		cm:remove_garrison_residence_vfx(garrison_residence_CQI, books_vfx_key);
	end
end

function remove_book_character_vfx(mission_key)
	if books_mission_characters[mission_key] ~= nil and does_local_faction_have_books_of_nagash() then
		local character_cqi = books_mission_characters[mission_key];
		cm:remove_character_vfx(character_cqi, books_vfx_key);
	end
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("books_collected", books_collected, context);
		cm:save_named_value("books_collected_list", books_collected_list, context);
		cm:save_named_value("books_mission_regions", books_mission_regions, context);
		cm:save_named_value("books_mission_characters", books_mission_characters, context);
		cm:save_named_value("books_mission_factions", books_mission_factions, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		books_collected = cm:load_named_value("books_collected", 0, context);
		books_collected_list = cm:load_named_value("books_collected_list", books_collected_list, context);
		books_mission_regions = cm:load_named_value("books_mission_regions", books_mission_regions, context);
		books_mission_characters = cm:load_named_value("books_mission_characters", books_mission_characters, context);
		books_mission_factions = cm:load_named_value("books_mission_factions", books_mission_factions, context);
	end
);