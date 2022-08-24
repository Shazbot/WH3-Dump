local dust_faction = "wh2_main_skv_clan_eshin";
local dust_actions = {};
local dust_per_turn = 1;
local dust_cap = 1;
local dust_cooldown = 0;
local dust_cooldown_reset = 5;
local dust_xp_gain = 1200;
local dust_default_composite_scene = "global_action_generic";
local dust_composite_scene_overrides = {
	["REGION"] = {
		["wh2_dlc14_eshin_actions_sabotage"] = "global_action_sabotage",
		["wh2_dlc14_eshin_actions_great_fire"] = "global_action_great_fire",
		["wh2_dlc14_eshin_actions_sewer_pestilence"] = "global_action_sewer_pestilence"
	},
	["MILITARY_FORCE"] = {
		["wh2_dlc14_eshin_actions_fleet_bombing"] = "global_action_fleet_bombing"
	}
};
local dust_cutscene_actions = {
	["wh2_dlc14_eshin_actions_decapitation"] = true,
	["wh2_dlc14_eshin_actions_great_fire"] = true,
	["wh2_dlc14_eshin_actions_sewer_pestilence"] = true,
	["wh2_dlc14_eshin_actions_fleet_bombing"] = true
};
local dust_ai_values = {
	cooldown = 20,
	cooldown_min = 20,
	cooldown_max = 30,
	actions = {
		{key = "ambush",		weight = 10,	target = "ARMY",		cooldown_reset = 20,	cooldown = 0,	max_times = -1},
		{key = "assassinate",	weight = 10,	target = "CHARACTER",	cooldown_reset = 50,	cooldown = 0,	max_times = -1},
		{key = "sabotage",		weight = 10,	target = "REGION",		cooldown_reset = 50,	cooldown = 0,	max_times = -1},
		{key = "fleet_bombing",	weight = 1,		target = "NAVY",		cooldown_reset = 90,	cooldown = 0,	max_times = 1},
		{key = "great_fire",	weight = 1,		target = "CAPITAL",		cooldown_reset = 90,	cooldown = 0,	max_times = 1},
		{key = "sewer_plague",	weight = 1,		target = "CAPITAL",		cooldown_reset = 90,	cooldown = 0,	max_times = 1},
		{key = "decapitation",	weight = 1,		target = "FACTION",		cooldown_reset = 90,	cooldown = 0,	max_times = 1}
	}
};
local dust_action_to_event_pic = {
	["default"] = 790,
	["fleet_bombing"] = 791,
	["great_fire"] = 792,
	["sewer_plague"] = 793,
	["decapitation"] = 794
};

function add_shadowy_dealings_listeners()
	out("#### Adding Shadowy Dealings Listeners ####");
	core:add_listener(
		"dust_FactionTurnStart",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == dust_faction;
		end,
		function(context)
			dust_FactionTurnStart(context:faction());
		end,
		true
	);
	core:add_listener(
		"dust_RitualCompletedEvent",
		"RitualCompletedEvent",
		function(context)
			return context:performing_faction():name() == dust_faction;
		end,
		function(context)
			dust_RitualCompletedEvent(context);
		end,
		true
	);
	core:add_listener(
		"dust_RitualsCompletedAndDelayedEvent",
		"RitualsCompletedAndDelayedEvent",
		true,
		function(context)
			dust_RitualsCompletedAndDelayedEvent(context);
		end,
		true
	);

	if cm:is_new_game() == true then
		dust_UpdateCap();
		dust_ai_values.cooldown = cm:random_number(dust_ai_values.cooldown_max, dust_ai_values.cooldown_min);
	end
	dust_UpdateUI();
end

function dust_FactionTurnStart(faction)
	if faction:pooled_resource_manager():resource("skv_dust"):is_null_interface() == false then
		if faction:is_human() == true then
			local dust = faction:pooled_resource_manager():resource("skv_dust");
			local dust_value = dust:value();
			local dust_max = dust:maximum_value();
			
			if dust_value == dust_max then
				dust_cooldown = 0;
			else
				if dust_cooldown == 0 then
					dust_cooldown = dust_cooldown_reset;
				end
				dust_cooldown = dust_cooldown - 1;
				
				if dust_cooldown == 0 then
					cm:faction_add_pooled_resource(dust_faction, "skv_dust", "wh2_dlc14_resource_factor_dust_per_turn", dust_per_turn);

					if (dust_value + dust_per_turn) < dust_max then
						dust_cooldown = dust_cooldown_reset;
					end
				end
			end

			for i = 1, #dust_actions do
				local comp_scene = dust_actions[i];
				cm:remove_scripted_composite_scene(comp_scene);
			end
			dust_actions = {};

			dust_UpdateUI();
		else
			dust_AI_Turn(faction);
		end
	end
end

function dust_AI_Turn(faction)
	if dust_ai_values.cooldown == 0 then
		local turn_number = cm:model():turn_number();
		local possible_actions = weighted_list:new();

		for i = 1, #dust_ai_values.actions do
			if dust_ai_values.actions[i].cooldown > 0 then
				dust_ai_values.actions[i].cooldown = dust_ai_values.actions[i].cooldown - 1;
			else
				if dust_ai_values.actions[i].max_times > 0 or dust_ai_values.actions[i].max_times == -1 then
					possible_actions:add_item(dust_ai_values.actions[i].key, dust_ai_values.actions[i].weight);
				end
			end
		end

		if #possible_actions.items > 0 then
			local action = possible_actions:weighted_select();

			for i = 1, #dust_ai_values.actions do
				if dust_ai_values.actions[i].key == action then
					dust_ai_values.cooldown = cm:random_number(dust_ai_values.cooldown_max, dust_ai_values.cooldown_min);
					dust_ai_values.actions[i].cooldown = dust_ai_values.actions[i].cooldown_reset;

					if dust_ai_values.actions[i].max_times > 0 then
						dust_ai_values.actions[i].max_times = dust_ai_values.actions[i].max_times - 1;
					end
					
					dust_AI_action(faction, dust_ai_values.actions[i]);
					break;
				end
			end
		end
	else
		dust_ai_values.cooldown = dust_ai_values.cooldown - 1;

		for i = 1, #dust_ai_values.actions do
			if dust_ai_values.actions[i].cooldown > 0 then
				dust_ai_values.actions[i].cooldown = dust_ai_values.actions[i].cooldown - 1;
			end
		end
	end
end

function dust_AI_action(faction, action)
	local ritual_key = "";
	local target_faction_key = "";
	local target_pos_x = 0;
	local target_pos_y = 0;

	if action.key == "ambush" then
		ritual_key = "wh2_dlc14_eshin_actions_ambush_camp";
	elseif action.key == "assassinate" then
		ritual_key = "wh2_dlc14_eshin_actions_assassination";
	elseif action.key == "sabotage" then
		ritual_key = "wh2_dlc14_eshin_actions_sabotage";
	elseif action.key == "fleet_bombing" then
		ritual_key = "wh2_dlc14_eshin_actions_fleet_bombing";
	elseif action.key == "great_fire" then
		ritual_key = "wh2_dlc14_eshin_actions_great_fire";
	elseif action.key == "sewer_plague" then
		ritual_key = "wh2_dlc14_eshin_actions_sewer_pestilence";
	elseif action.key == "decapitation" then
		ritual_key = "wh2_dlc14_eshin_actions_decapitation";
	end

	------------------------------------------------------------------------------------
	---- 1) Setup the Ritual
	------------------------------------------------------------------------------------
	out.design("------------------------------------------------");
	out.design("1) Setup the Ritual...");
	out.design("\t"..ritual_key);
	-- MODIFY_RITUAL_SETUP_SCRIPT_INTERFACE
	local ritual_setup = cm:create_new_ritual_setup(faction, ritual_key);
	out.design("\t"..tostring(ritual_setup));
	-- MODIFY_RITUAL_TARGET_SCRIPT_INTERFACE
	local ritual_target = ritual_setup:target();
	out.design("\t"..tostring(ritual_target));

	------------------------------------------------------------------------------------
	---- 2) Set the performing character
	------------------------------------------------------------------------------------
	out.design("------------------------------------------------");
	out.design("2) Set the performing character...");
	-- MODIFY_RITUAL_PERFORMING_CHARACTER_LIST_SCRIPT_INTERFACE
	local required_characters = ritual_setup:performing_characters();
	out.design("\t".."Required Characters - #"..required_characters:num_items());
	-- MODIFY_RITUAL_PERFORMING_CHARACTER_SCRIPT_INTERFACE
	local modify_character = required_characters:item_at(0);

	local faction_leader = faction:faction_leader():family_member();
	-- RITUAL_PERFORMING_CHARACTER_STATUS_SCRIPT_INTERFACE
	local character_status = modify_character:status_with_performer(ritual_setup, faction_leader);

	if character_status:valid() == true then
		modify_character:set_performer(ritual_setup, faction_leader);
	else
		local character_list = faction:character_list();

		for i = 0, character_list:num_items() - 1 do
			local possible_character = character_list:item_at(i):family_member();
			character_status = modify_character:status_with_performer(ritual_setup, possible_character);

			if character_status:valid() == true then
				modify_character:set_performer(ritual_setup, possible_character);
				break;
			end
		end
	end
	
	out.design("\t".."status_with_performer: ");
	out.design("\t".."no_performer_provided - "..tostring(character_status:no_performer_provided()));
	out.design("\t".."dead - "..tostring(character_status:dead()));
	out.design("\t".."wounded - "..tostring(character_status:wounded()));
	out.design("\t".."wrong_agent_type - "..tostring(character_status:wrong_agent_type()));
	out.design("\t".."wrong_agent_subtype - "..tostring(character_status:wrong_agent_subtype()));
	out.design("\t".."level_too_low - "..tostring(character_status:level_too_low()));
	out.design("\t".."duplicate_performer - "..tostring(character_status:duplicate_performer()));

	if ritual_setup:performing_characters_valid() == true then
		------------------------------------------------------------------------------------
		---- 3) Set the target of the ritual
		------------------------------------------------------------------------------------
		out.design("------------------------------------------------");
		out.design("3) Set the target of the ritual...");
		local war_factions = faction:factions_at_war_with();
		out.design("\t".."War Factions - #"..war_factions:num_items());
		out.design("\t".."action.target - "..tostring(action.target));
		local unique_war_factions = unique_table:faction_list_to_unique_table(war_factions);

		if action.target == "FACTION" then
			local valid_factions = ritual_target:get_all_valid_target_factions();
			local unique_valid_factions = unique_table:faction_list_to_unique_table(valid_factions);
			
			local unique_possible_factions = unique_valid_factions * unique_war_factions; -- This returns entires only in both tables
			local possible_factions = unique_possible_factions:to_table();

			if #possible_factions > 0 then
				local rand = cm:random_number(#possible_factions);
				target_faction_key = possible_factions[rand];
				local target_faction = cm:model():world():faction_by_key(target_faction_key);
				ritual_target:set_target_faction(target_faction);
				
				if target_faction:has_home_region() == true then
					local home_region = target_faction:home_region();
					local settlement = home_region:settlement();
					target_pos_x = settlement:logical_position_x();
					target_pos_y = settlement:logical_position_y();
				end
			end
		else
			local possible_factions = unique_war_factions:to_table();

			if #possible_factions > 0 then
				local rand = cm:random_number(#possible_factions);
				target_faction_key = possible_factions[rand];
				local target_faction = cm:model():world():faction_by_key(target_faction_key);

				if action.target == "ARMY" or action.target == "NAVY" or action.target == "CHARACTER" then
					local possible_forces = weighted_list:new();
					local target_forces = target_faction:military_force_list();

					for i = 0, target_forces:num_items() - 1 do
						local force = target_forces:item_at(i);

						if force:is_armed_citizenry() == false then
							if action.target == "ARMY" and force:is_army() == true and ritual_target:is_force_valid_target(force) == true then
								possible_forces:add_item(force, 1);
							elseif action.target == "NAVY" and force:is_navy() == true and ritual_target:is_force_valid_target(force) == true then
								possible_forces:add_item(force, 1);
							elseif action.target == "CHARACTER" and force:has_general() == true and ritual_target:is_force_valid_target(force) == true then
								possible_forces:add_item(force, 1);
							end
						end
					end

					if #possible_forces.items > 0 then
						local target_force = possible_forces:weighted_select();
						ritual_target:set_target_force(target_force);

						if target_force:has_general() == true then
							local general = target_force:general_character();
							target_pos_x = general:logical_position_x();
							target_pos_y = general:logical_position_y();
						end
					end
				elseif action.target == "REGION" then
					local possible_regions = weighted_list:new();
					local target_regions = target_faction:region_list();

					for i = 0, target_regions:num_items() - 1 do
						local region = target_regions:item_at(i);

						if region:is_abandoned() == false and ritual_target:is_region_valid_target(region) == true then
							possible_regions:add_item(region, 1);
						end
					end

					if #possible_regions.items > 0 then
						local target_region = possible_regions:weighted_select();
						ritual_target:set_target_region(target_region);
						
						local settlement = target_region:settlement();
						target_pos_x = settlement:logical_position_x();
						target_pos_y = settlement:logical_position_y();
					end
				elseif action.target == "CAPITAL" then
					if target_faction:has_home_region() == true then
						local home_region = target_faction:home_region();

						if ritual_target:is_region_valid_target(home_region) == true then
							ritual_target:set_target_region(home_region);
						
							local settlement = home_region:settlement();
							target_pos_x = settlement:logical_position_x();
							target_pos_y = settlement:logical_position_y();
						end
					end
				end
			end
		end

		local target_type = ritual_target:target_type();
		out.design("\t".."target_type - "..target_type);

		if target_type == "FACTION" then
			local target_faction_status = ritual_target:target_faction_status();
			out.design("\t".."valid - "..tostring(target_faction_status:valid()));
			out.design("\t".."wrong_type - "..tostring(target_faction_status:wrong_type()));
			out.design("\t".."no_target - "..tostring(target_faction_status:no_target()));
			out.design("\t".."not_own - "..tostring(target_faction_status:not_own()));
			out.design("\t".."is_own - "..tostring(target_faction_status:is_own()));
			out.design("\t".."invalid_for_any_ritual - "..tostring(target_faction_status:invalid_for_any_ritual()));
			out.design("\t".."human - "..tostring(target_faction_status:human()));
			out.design("\t".."not_human - "..tostring(target_faction_status:not_human()));
			out.design("\t".."faction_not_permitted - "..tostring(target_faction_status:faction_not_permitted()));
		elseif target_type == "REGION" then
			local target_region_status = ritual_target:target_region_status();
			out.design("\t".."valid - "..tostring(target_region_status:valid()));
			out.design("\t".."wrong_type - "..tostring(target_region_status:wrong_type()));
			out.design("\t".."no_target - "..tostring(target_region_status:no_target()));
			out.design("\t".."not_own - "..tostring(target_region_status:not_own()));
			out.design("\t".."is_own - "..tostring(target_region_status:is_own()));
			out.design("\t".."invalid_subculture - "..tostring(target_region_status:invalid_subculture()));
			out.design("\t".."foreign_slot_subculture_not_present - "..tostring(target_region_status:foreign_slot_subculture_not_present()));
			out.design("\t".."foreign_slot_set_not_present - "..tostring(target_region_status:foreign_slot_set_not_present()));
			out.design("\t".."is_ruin - "..tostring(target_region_status:is_ruin()));
			out.design("\t".."is_not_ruin - "..tostring(target_region_status:is_not_ruin()));
		elseif target_type == "MILITARY_FORCE" then
			local target_force_status = ritual_target:target_force_status();
			out.design("\t".."valid - "..tostring(target_force_status:valid()));
			out.design("\t".."wrong_type - "..tostring(target_force_status:wrong_type()));
			out.design("\t".."no_target - "..tostring(target_force_status:no_target()));
			out.design("\t".."not_own - "..tostring(target_force_status:not_own()));
			out.design("\t".."is_own - "..tostring(target_force_status:is_own()));
			out.design("\t".."invalid_subculture - "..tostring(target_force_status:invalid_subculture()));
			out.design("\t".."invalid_for_any_ritual - "..tostring(target_force_status:invalid_for_any_ritual()));
			out.design("\t".."not_on_sea - "..tostring(target_force_status:not_on_sea()));
			out.design("\t".."not_on_land - "..tostring(target_force_status:not_on_land()));
		end
	
		------------------------------------------------------------------------------------
		---- 4) Perform the ritual with the setup above
		------------------------------------------------------------------------------------
		if ritual_target:valid() == true then
			cm:perform_ritual_with_setup(ritual_setup);
			local event_pic = dust_action_to_event_pic[action.key] or dust_action_to_event_pic["default"];

			-- Tell the target
			cm:show_message_event_located(
				target_faction_key,
				"event_feed_strings_text_wh2_dlc14_event_feed_string_scripted_event_skv_action_title_"..action.key,
				"event_feed_strings_text_wh2_dlc14_event_feed_string_scripted_event_skv_action_subtitle",
				"event_feed_strings_text_wh2_dlc14_event_feed_string_scripted_event_skv_action_description_"..action.key,
				target_pos_x, target_pos_y,
				true,
				event_pic
			);
		end
	end
end

function dust_RitualsCompletedAndDelayedEvent(context)
	local ritual_list = context:rituals();

	for i = 0, ritual_list:num_items() - 1 do
		local ritual = ritual_list:item_at(i);
		local ritual_key = ritual:ritual_key();
		local ritual_category = ritual:ritual_category();

		if ritual_category == "ESHIN_RITUAL_DELAYED" then
			local faction = ritual:characters_who_performed():item_at(0):character():faction(); -- This is horrific
			local ritual_target = ritual:ritual_target();
			local target_type = ritual_target:target_type();
			local scene_type = dust_default_composite_scene;
			
			if dust_composite_scene_overrides[target_type] ~= nil and dust_composite_scene_overrides[target_type][ritual_key] ~= nil then
				scene_type = dust_composite_scene_overrides[target_type][ritual_key];
			end

			if target_type == "FACTION" then
				-- FACTION
				local target_faction = ritual_target:get_target_faction();

				if target_faction:is_null_interface() == false and target_faction:is_dead() == false then
					if target_faction:has_home_region() == true then
						local region = target_faction:home_region();
						local region_key = region:name();
						local settlement = region:settlement();
						local settlement_key = "settlement:"..region_key;
						local comp_scene = "dust_"..region_key;
						local scene_type = dust_default_composite_scene;
						local log_x = settlement:logical_position_x();
						local log_y = settlement:logical_position_y();
						local dis_x = settlement:display_position_x();
						local dis_y = settlement:display_position_y();
						
						if dust_composite_scene_overrides[target_type] ~= nil and dust_composite_scene_overrides[target_type][ritual_key] ~= nil then
							scene_type = dust_composite_scene_overrides[target_type][ritual_key];
						end
						
						dist_ShowCutscene(comp_scene, faction, ritual, scene_type, log_x, log_y, dis_x, dis_y, region);
						table.insert(dust_actions, comp_scene);
					end
				end
			elseif target_type == "REGION" then
				-- REGION
				local target_region = ritual_target:get_target_region();
				
				if target_region:is_null_interface() == false then
					local region_key = target_region:name();
					local settlement = target_region:settlement();
					local settlement_key = "settlement:"..region_key;
					local comp_scene = "dust_"..region_key;
					local scene_type = dust_default_composite_scene;
					local log_x = settlement:logical_position_x();
					local log_y = settlement:logical_position_y();
					local dis_x = settlement:display_position_x();
					local dis_y = settlement:display_position_y();
					
					if dust_composite_scene_overrides[target_type] ~= nil and dust_composite_scene_overrides[target_type][ritual_key] ~= nil then
						scene_type = dust_composite_scene_overrides[target_type][ritual_key];
					end
					
					dist_ShowCutscene(comp_scene, faction, ritual, scene_type, log_x, log_y, dis_x, dis_y, target_region);
					table.insert(dust_actions, comp_scene);
				end
			elseif target_type == "MILITARY_FORCE" then
				-- FORCE
				local target_force = ritual_target:get_target_force();

				if target_force:is_null_interface() == false and target_force:has_general() == true then
					local general = target_force:general_character();
					local cqi = general:command_queue_index();
					local comp_scene = "dust_"..cqi;
					local scene_type = dust_default_composite_scene;
					local log_x = general:logical_position_x();
					local log_y = general:logical_position_y();
					local dis_x = general:display_position_x();
					local dis_y = general:display_position_y();
						
					if dust_composite_scene_overrides[target_type] ~= nil and dust_composite_scene_overrides[target_type][ritual_key] ~= nil then
						scene_type = dust_composite_scene_overrides[target_type][ritual_key];
					end
					
					dist_ShowCutscene(comp_scene, faction, ritual, scene_type, log_x, log_y, dis_x, dis_y, nil);
					table.insert(dust_actions, comp_scene);
				end
			end
		end
	end
end

function dust_RitualCompletedEvent(context)
	local ritual = context:ritual();
	local ritual_key = ritual:ritual_key();
	local ritual_category = ritual:ritual_category();

	if ritual_category == "ESHIN_VORTEX_RITUAL" then
		core:trigger_event("ScriptEventShadowyDealingsEGMission");
		if ritual_key == "wh2_dlc14_eshin_actions_mortal_empires_mission_1" then
			dust_cap = dust_cap + 1;
			dust_UpdateCap();
		elseif ritual_key == "wh2_dlc14_eshin_actions_mortal_empires_mission_2" then
			dust_cap = dust_cap + 1;
			dust_UpdateCap();
		elseif ritual_key == "wh2_dlc14_eshin_actions_mortal_empires_mission_3" then
			dust_cap = dust_cap + 1;
			dust_UpdateCap();
		elseif ritual_key == "wh2_dlc14_eshin_actions_mortal_empires_mission_4" then
			dust_cap = dust_cap + 1;
			dust_UpdateCap();		
		end
	elseif ritual_category == "ESHIN_RITUAL" or ritual_category == "ESHIN_RITUAL_DELAYED" then
		core:trigger_event("ScriptEventShadowyDealingsEGMission");
		local faction = context:performing_faction();
		local ritual_target = ritual:ritual_target();

		if ritual_key == "wh2_dlc14_eshin_actions_steal_technology" then
			cm:apply_effect_bundle("wh2_dlc14_payload_eshin_actions_steal_technology", dust_faction, 5);
		end

		if ritual_key == "wh2_dlc14_eshin_actions_steal_ancillary" then
			cm:trigger_incident(dust_faction, "wh2_dlc14_incident_skv_eshin_actions_steal_ancillary", true);
		end

		if ritual_category == "ESHIN_RITUAL" then
			local target_type = ritual_target:target_type();

			if target_type == "FACTION" then
				-- FACTION
				local target_faction = ritual_target:get_target_faction();

				if target_faction:is_null_interface() == false and target_faction:is_dead() == false then
					if target_faction:has_home_region() == true then
						local region = target_faction:home_region();
						local region_key = region:name();
						local comp_scene = "dust_"..region_key;
						local scene_type = dust_default_composite_scene;
						
						if dust_composite_scene_overrides[target_type] ~= nil and dust_composite_scene_overrides[target_type][ritual_key] ~= nil then
							scene_type = dust_composite_scene_overrides[target_type][ritual_key];
						end
						
						cm:add_scripted_composite_scene_to_settlement(comp_scene, scene_type, region, 0, 0, true, true, false);
						table.insert(dust_actions, comp_scene);
					end
				end
			elseif target_type == "REGION" then
				-- REGION
				local target_region = ritual_target:get_target_region();
				
				if target_region:is_null_interface() == false then
					local region_key = target_region:name();
					local comp_scene = "dust_"..region_key;
					local scene_type = dust_default_composite_scene;
					
					if dust_composite_scene_overrides[target_type] ~= nil and dust_composite_scene_overrides[target_type][ritual_key] ~= nil then
						scene_type = dust_composite_scene_overrides[target_type][ritual_key];
					end
					
					cm:add_scripted_composite_scene_to_settlement(comp_scene, scene_type, target_region, 0, 0, true, true, false);
					table.insert(dust_actions, comp_scene);
				end
			elseif target_type == "MILITARY_FORCE" then
				-- FORCE
				local target_force = ritual_target:get_target_force();

				if target_force:is_null_interface() == false and target_force:has_general() == true then
					local general = target_force:general_character();
					local cqi = general:command_queue_index();
					local comp_scene = "dust_"..cqi;
					local scene_type = dust_default_composite_scene;
					local x = general:logical_position_x();
					local y = general:logical_position_y();
						
					if dust_composite_scene_overrides[target_type] ~= nil and dust_composite_scene_overrides[target_type][ritual_key] ~= nil then
						scene_type = dust_composite_scene_overrides[target_type][ritual_key];
					end
					
					cm:add_scripted_composite_scene_to_logical_position(comp_scene, scene_type, x, y, 0, 0, true, true, false);
					table.insert(dust_actions, comp_scene);
				end
			end
		end
		
		if faction:pooled_resource_manager():resource("skv_dust"):is_null_interface() == false then
			if dust_cooldown == 0 then
				local dust = faction:pooled_resource_manager():resource("skv_dust");
				local dust_value = dust:value();
				local dust_max = dust:maximum_value();

				if dust_value < dust_max then
					dust_cooldown = dust_cooldown_reset;
				end
			end
		end
		dust_UpdateUI();
	end
	
	local agents = ritual:characters_who_performed();

	for i = 0, agents:num_items() - 1 do
		local agent = agents:item_at(i);
		cm:add_agent_experience_through_family_member(agent, dust_xp_gain);
	end
end

function dist_ShowCutscene(key, faction, ritual, comp_scene, log_x, log_y, dis_x, dis_y, region)
	local cam_x, cam_y, cam_d, cam_b, cam_h = cm:get_camera_position();
	local cam_fade_in_time = 1;
	local cam_fade_out_time = 1;
	local cam_vfx_play_time = 3;
	local cam_pause_after_fade_before_vfx = 1;

	local local_faction = cm:get_local_faction(true);
	local show_cutscene_local = local_faction == faction:name();
	
	
	if show_cutscene_local == true then
		cm:steal_user_input(true);
		cm:fade_scene(0, cam_fade_in_time);
	end
	
	cm:callback(function()
		if show_cutscene_local == true then
			cm:scroll_camera_with_direction(true, cam_vfx_play_time * 2, {dis_x, dis_y, 10.1, 0.0, 7.7}, {dis_x, dis_y + 2, 13.7, 0.0, 10.7});
			CampaignUI.ToggleCinematicBorders(true);
			cm:fade_scene(1, cam_fade_in_time);
			if region then 
				cm:take_shroud_snapshot();
				cm:make_region_visible_in_shroud(local_faction, region:name());
			end
		end
		
		cm:callback(function()
			-- Execture ritual
			cm:apply_active_ritual(faction, ritual);
			
			-- Apply Composite Scene
			if region == nil then
				cm:add_scripted_composite_scene_to_logical_position(key, comp_scene, log_x, log_y, 0, 0, true, true, false);
				out("add_scripted_composite_scene_to_logical_position - "..log_x..", "..log_y);
			else
				cm:add_scripted_composite_scene_to_settlement(key, comp_scene, region, 0, 0, true, true, false);
			end
			
			if show_cutscene_local == true then
				cm:callback(function()
					cm:fade_scene(0, cam_fade_out_time);
					
					cm:callback(function()
						cm:steal_user_input(false);
						cm:set_camera_position(cam_x, cam_y, cam_d, cam_b, cam_h);
						CampaignUI.ToggleCinematicBorders(false);
						cm:fade_scene(1, cam_fade_in_time);
						cm:restore_shroud_from_snapshot();
					end, cam_fade_out_time);
				end, cam_vfx_play_time);
			end
		end, cam_fade_in_time + cam_pause_after_fade_before_vfx);
	end, cam_fade_in_time);
end

function dust_UpdateCap()
	for i = 1, 5 do
		cm:remove_effect_bundle("wh2_dlc14_bundle_dust_cap_"..i, dust_faction);
	end
	cm:apply_effect_bundle("wh2_dlc14_bundle_dust_cap_"..dust_cap, dust_faction, 0);
	dust_UpdateUI();
end

function dust_UpdateUI()
	local ui_root = core:get_ui_root();
	local bar_ui = find_uicomponent(ui_root, "warpstone_dust_bar");
	
	if bar_ui then
		bar_ui:InterfaceFunction("SetTimer", dust_cooldown);
	end
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("dust_cap", dust_cap, context);
		cm:save_named_value("dust_cooldown", dust_cooldown, context);
		cm:save_named_value("dust_actions", dust_actions, context);
		cm:save_named_value("dust_ai_values", dust_ai_values, context);
	end
);
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			dust_cap = cm:load_named_value("dust_cap", dust_cap, context);
			dust_cooldown = cm:load_named_value("dust_cooldown", dust_cooldown, context);
			dust_actions = cm:load_named_value("dust_actions", dust_actions, context);
			--dust_ai_values = cm:load_named_value("dust_ai_values", dust_ai_values, context);
		end
	end
);