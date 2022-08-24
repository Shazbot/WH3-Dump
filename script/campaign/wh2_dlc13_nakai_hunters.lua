local hunter_force_cqis = {};

local nakai_faction_key = "wh2_dlc13_lzd_spirits_of_the_jungle";
local wulfhart_faction_key = "wh2_dlc13_emp_the_huntmarshals_expedition";

function add_nakai_hunters_listeners()
	out("#### Adding Nakai Hunters Listeners ####");	
	
	core:add_listener(
		"KillHunterMissionSucceeded",
		"MissionSucceeded",
		function(context)
			return context:mission():mission_record_key():find("wh2_dlc13_nakai_hunters_");
		end,
		function(context)
			KillHunterMissionSucceeded(context:mission():mission_record_key());
		end,
		true
	);

	core:add_listener(
		"KillHunterMissionCancelled",
		"MissionCancelled",
		function(context)
			return context:mission():mission_record_key():find("wh2_dlc13_nakai_hunters_");
		end,
		function(context)
			KillHunterMissionSucceeded(context:mission():mission_record_key());
		end,
		true
	);
	
	core:add_listener(
		"FinalBattleMissionSucceeded",
		"MissionSucceeded",
		function(context)
			return context:mission():mission_record_key() == "wh2_dlc13_qb_lzd_final_battle_nakai";
		end,
		function(context)
			core:svr_save_registry_bool("hunter_nakai_win", true);
			cm:register_instant_movie("warhammer2/hunter/hunter_nakai_win");
			cm:complete_scripted_mission_objective(nakai_faction_key, "wh_main_long_victory", "final_battle_condition", true);
		end,
		true
	);
	core:add_listener(
		"HuntersFactionTurnEnd",
		"FactionTurnEnd",
		true,
		function(context)
			local faction = context:faction();

			if #hunter_force_cqis > 0 and faction:is_human() == true and faction:name() == nakai_faction_key then
				local force_list = faction:military_force_list();

				for i = 0, force_list:num_items() - 1 do
					local military_force = force_list:item_at(i);
					
					if military_force:has_general() == true then
						local nakai_force_leader = military_force:general_character();
						local remove_cqis = {};
						
						for j = 1, #hunter_force_cqis do
							local f_cqi = hunter_force_cqis[j];

							if cm:model():has_military_force_command_queue_index(f_cqi) == true then
								local force = cm:model():military_force_for_command_queue_index(f_cqi);

								if force:is_null_interface() == false and force:has_general() == true then
									local general = force:general_character();

									if general:is_visible_to_faction(nakai_faction_key) == true then
										local hunter_cqi = general:command_queue_index();
										out("Releasing Hunter: "..hunter_cqi);
										cm:cai_enable_movement_for_character("character_cqi:"..hunter_cqi);
										table.insert(remove_cqis, j);
									end
								end
							end
						end
						for j = 1, #remove_cqis do
							table.remove(hunter_force_cqis, remove_cqis[j]);
						end
					end
				end
			end
		end,
		true
	);

	local nakai_faction = cm:get_faction(nakai_faction_key);
	local wulfhart_faction = cm:get_faction(wulfhart_faction_key);
	if nakai_faction and nakai_faction:is_human() and cm:is_new_game() then
		cm:callback(
			function()
				if cm:get_campaign_name() == "wh2_main_great_vortex" and not wulfhart_faction:is_human() then
					nakai_generate_targets();
				end;
			end,
			0.5
		);
	end;
end;

function nakai_generate_targets()
	local target_faction = cm:get_faction(wulfhart_faction_key);
	local target_faction_cqi = target_faction:command_queue_index();
	local target_subtypes = {
		{"wh2_dlc13_emp_hunter_jorek_grimm", 100, 148},
		{"wh2_dlc13_emp_hunter_doctor_hertwig_van_hal", 233, 195},
		{"wh2_dlc13_emp_hunter_rodrik_l_anguille", 171, 319},
		{"wh2_dlc13_emp_hunter_kalara_of_wydrioth", 99, 307}
	};

	-- spawn hunters
	for i = 1, #target_subtypes do
		cm:spawn_unique_agent(target_faction_cqi, target_subtypes[i][1], false);
		
		local char_list = target_faction:character_list();
		
		for j = 0, char_list:num_items() - 1 do			
			if char_list:item_at(j):character_subtype(target_subtypes[i][1]) then
				local agent = char_list:item_at(j);
				
				-- force functions
				local force = cm:get_closest_general_to_position_from_faction(target_faction, target_subtypes[i][2], target_subtypes[i][3], false):military_force();
				local force_cqi = force:command_queue_index();
				local force_leader = force:general_character():command_queue_index();

				table.insert(hunter_force_cqis, force_cqi);
				
				cm:cai_disable_movement_for_character(cm:char_lookup_str(force_leader));
				cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force_special_character", force_leader, -1);
				
				-- agent functions
				cm:embed_agent_in_force(agent, force);
				
				-- trigger mission
				local mm = mission_manager:new(nakai_faction_key, "wh2_dlc13_nakai_hunters_" .. i);
				mm:set_mission_issuer("CLAN_ELDERS");
				mm:add_new_objective("KILL_CHARACTER_BY_ANY_MEANS");
				mm:add_condition("family_member " .. agent:family_member():command_queue_index());
				mm:add_payload("faction_pooled_resource_transaction{resource lzd_old_ones_favour;factor missions;amount 250;context absolute;}");
				mm:set_should_whitelist(false);
				mm:trigger();
			end;
		end;
	end;
	
	local nakai_assasination_holder = find_uicomponent(core:get_ui_root(), "nakai_assasination_holder");
	
	if nakai_assasination_holder then
		nakai_assasination_holder:InterfaceFunction("SetTargets", "wh2_dlc13_nakai_hunters_4", "wh2_dlc13_nakai_hunters_3", "wh2_dlc13_nakai_hunters_2", "wh2_dlc13_nakai_hunters_1");
	end;
end;

function KillHunterMissionSucceeded(mission_key)
	if mission_key == "wh2_dlc13_nakai_hunters_1" then
		core:trigger_event("ScriptEventWarmbloodInvadersHunterKilled");
		cm:set_saved_value("hunter_jorek_killed", true);
	elseif mission_key == "wh2_dlc13_nakai_hunters_2" then
		core:trigger_event("ScriptEventWarmbloodInvadersHunterKilled");
		cm:set_saved_value("hunter_hertwig_killed", true);
	elseif mission_key == "wh2_dlc13_nakai_hunters_3" then
		core:trigger_event("ScriptEventWarmbloodInvadersHunterKilled");
		cm:set_saved_value("hunter_rodrik_killed", true);
	elseif mission_key == "wh2_dlc13_nakai_hunters_4" then
		core:trigger_event("ScriptEventWarmbloodInvadersHunterKilled");
		cm:set_saved_value("hunter_kalara_killed", true);
	end
	
	if cm:get_saved_value("hunter_jorek_killed") and cm:get_saved_value("hunter_hertwig_killed") and cm:get_saved_value("hunter_rodrik_killed") and cm:get_saved_value("hunter_kalara_killed") then
		cm:trigger_mission(nakai_faction_key, "wh2_dlc13_qb_lzd_final_battle_nakai", true);
		core:svr_save_registry_bool("hunter_nakai_call_to_arms", true);
		cm:register_instant_movie("warhammer2/hunter/hunter_nakai_call_to_arms");
		cm:complete_scripted_mission_objective(nakai_faction_key, "wh_main_long_victory", "kill_four_hunters", true);
	end
end

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("hunter_force_cqis", hunter_force_cqis, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		hunter_force_cqis = cm:load_named_value("hunter_force_cqis", hunter_force_cqis, context);
	end
);