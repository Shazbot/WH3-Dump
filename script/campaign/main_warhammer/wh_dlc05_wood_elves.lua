local wild_hunt_next_turn = 10;
local wild_hunt_end_turn = -1;
local wild_hunt_duration = 10;
local wef_ai_personality_duration = 60;
local wef_ai_personality_key_current = "wh3_combi_woodelf_orion";
local wef_ministerial_position_bundles = {
	["faction_leader"] = "wh_dlc05_minister_wef_elf_faction_leader_active_hunt",
	["wh_dlc05_minister_wef_elf_elder_speaker"] = "wh_dlc05_minister_wef_elf_talon_of_kurnous_active_hunt",
	["wh_dlc05_minister_wef_elf_herald_of_the_hunt"] = "wh_dlc05_minister_wef_elf_herald_of_the_hunt_active_hunt",
	["wh_dlc05_minister_wef_elf_protector_of_the_oak"] = "wh_dlc05_minister_wef_elf_spirit_of_the_hunt_active_hunt",
	["wh_dlc05_minister_wef_elf_starlight_craftsman"] = "wh_dlc05_minister_wef_elf_master_of_supplies_active_hunt",
	["wh_dlc05_minister_wef_elf_the_tricksters_masque"] = "wh_dlc05_minister_wef_elf_master_of_drums_active_hunt",
	["wh_dlc05_minister_wef_elf_warden_of_the_wildwood"] = "wh_dlc05_minister_wef_elf_master_of_scouts_active_hunt",

}

function Add_Wood_Elves_Listeners()
	out("#### Adding Wood Elves Listeners ####");
	
	-- A.I Wood Elves cannot declare war on other Wood Elves
	local faction_list = cm:model():world():faction_list();
	
	for i = 0, faction_list:num_items() - 1 do
		local current_faction = faction_list:item_at(i);
		
		if not current_faction:is_human() and current_faction:culture() == "wh_dlc05_wef_wood_elves" then
			cm:force_diplomacy("faction:" .. current_faction:name(), "culture:wh_dlc05_wef_wood_elves", "war", false, false, false);
		end
	end
	
	if cm:is_multiplayer() then
		local human_factions = cm:get_human_factions();
		local switch_ai_personalities = false;
		
		for i = 1, #human_factions do
			if cm:get_faction(human_factions[i]):culture() == "wh_dlc05_wef_wood_elves" then
				switch_ai_personalities = true;
				break;
			end
		end
		
		if switch_ai_personalities then
			for i = 0, faction_list:num_items() - 1 do
				local current_faction = faction_list:item_at(i);
				
				if not current_faction:is_human() and current_faction:culture() == "wh_dlc05_wef_wood_elves" then
					if current_faction:can_be_human() then
						cm:force_change_cai_faction_personality(current_faction:name(), "wh3_combi_woodelf_orion");
					else
						cm:force_change_cai_faction_personality(current_faction:name(), "wh3_combi_woodelf_orion_aggressive");
					end
				end
			end
		end
	else
		core:add_listener(
			"WoodElves_MissionSucceeded",
			"MissionSucceeded",
			function(context)
				return context:mission():mission_record_key() == "wh_dlc05_qb_wef_grand_defense_of_the_oak";
			end,
			function(context)
				-- Kill the remaining Beastmen
				local faction = cm:get_faction("wh_dlc03_bst_beastmen");
				
				if faction then
					local mf_list = faction:military_force_list();
					
					for i = 0, mf_list:num_items() - 1 do
						local current_mf = mf_list:item_at(i);
						
						if not current_mf:is_null_interface() and current_mf:has_general() then
							cm:kill_character(current_mf:general_character():command_queue_index(), true, true);
						end
					end
				end
				
				cm:complete_scripted_mission_objective(context:faction():name(), "wh_main_long_victory", "delay_victory", true);
			end,
			true
		);
	end
	
	-- handle wild hunt and ai behaviour
	core:add_listener(
		"WoodElves_FactionTurnStart",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == "wh_dlc05_wef_wood_elves";
		end,
		function(context)
			local faction = context:faction();
			local faction_name = faction:name();
			
			-- Check if Wild Hunt needs triggering
			local turn_number = cm:model():turn_number();
			
			if turn_number == wild_hunt_end_turn then
				cm:trigger_incident("wh_dlc05_wef_wood_elves", "wh2_dlc16_incident_wef_wild_hunt_ends", true)
				wild_hunt_end_turn = -1;
			-- Enough time passed since the last Wild Hunt?
			elseif turn_number >= wild_hunt_next_turn and faction:faction_leader():has_military_force() then
				local char_list = faction:character_list();
				
				for i = 0, char_list:num_items() - 1 do
					local current_char = char_list:item_at(i);
					
					-- loop through all office-holders and apply the appropriate bundle
					if not current_char:is_null_interface() and is_string(wef_ministerial_position_bundles[current_char:ministerial_position()]) and current_char:has_military_force() then
						cm:apply_effect_bundle_to_character(wef_ministerial_position_bundles[current_char:ministerial_position()], current_char, wild_hunt_duration + 1);
					end
				end
				
				cm:trigger_incident(faction_name, "wh2_dlc16_incident_wef_wild_hunt_begins", true);
				
				wild_hunt_next_turn = turn_number + 20;
				wild_hunt_end_turn = turn_number + wild_hunt_duration;
			end
			
			if not faction:is_human() then
				wef_ai_personality_duration = wef_ai_personality_duration - 1;
				
				if wef_ai_personality_duration < 1 then
					local human_factions = cm:get_human_factions();
					
					if wef_ai_personality_key_current == "wh3_combi_woodelf_orion" then -- DEFENSIVE
						-- Going offensive
						wef_ai_personality_duration = 10;
						wef_ai_personality_key_current = "wh3_combi_woodelf_orion_aggressive";
						
						for i = 1, #human_factions do
							cm:show_message_event(
								human_factions[i],
								"event_feed_strings_text_wh_dlc05_event_feed_string_scripted_event_wild_hunt_start_title",
								"event_feed_strings_text_wh_dlc05_event_feed_string_scripted_event_wild_hunt_start_primary_detail",
								"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_wild_hunt_start_secondary_detail_ai",
								true,
								556
							);
						end
					elseif wef_ai_personality_key_current == "wh3_combi_woodelf_orion_aggressive" then -- OFFENSIVE
						-- Going defensive
						wef_ai_personality_duration = 50;
						wef_ai_personality_key_current = "wh3_combi_woodelf_orion";
						
						for i = 1, #human_factions do
							cm:show_message_event(
								human_factions[i],
								"event_feed_strings_text_wh_dlc05_event_feed_string_scripted_event_wild_hunt_end_title",
								"event_feed_strings_text_wh_dlc05_event_feed_string_scripted_event_wild_hunt_end_primary_detail",
								"event_feed_strings_text_wh_dlc05_event_feed_string_scripted_event_wild_hunt_end_secondary_detail",
								true,
								556
							);
						end
					end
					
					-- Change the personality
					out("Wood Elves AI: Changing Wood Elves personality to " .. wef_ai_personality_key_current .. " for " .. wef_ai_personality_duration .. " turns");
					cm:force_change_cai_faction_personality(faction_name, wef_ai_personality_key_current);
				end
			end
		end,
		true
	);
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("wild_hunt_next_turn", wild_hunt_next_turn, context);
		cm:save_named_value("wild_hunt_end_turn", wild_hunt_end_turn, context);
		cm:save_named_value("wef_ai_personality_duration", wef_ai_personality_duration, context);
		cm:save_named_value("wef_ai_personality_key_current", wef_ai_personality_key_current, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			wild_hunt_next_turn = cm:load_named_value("wild_hunt_next_turn", wild_hunt_next_turn, context);
		end
		wild_hunt_end_turn = cm:load_named_value("wild_hunt_end_turn", -1, context);
		wef_ai_personality_duration = cm:load_named_value("wef_ai_personality_duration", 60, context);
		wef_ai_personality_key_current = cm:load_named_value("wef_ai_personality_key_current", "wh3_combi_woodelf_orion", context);
	end
);