local drycha_faction = "wh2_dlc16_wef_drycha";

function add_drycha_coeddil_unchained_listeners()
	out("#### Adding Drycha Coeddil Unchained Listeners ####");

	core:add_listener(
		"Drycha_Quest_Spawn_Empire",
		"MissionIssued",
		function(context)
			return context:mission():mission_record_key():find("wef_drycha_coeddil_unchained_stage_1");
		end,
		function(context)
			local mission_key = context:mission():mission_record_key();
			
			--declaring following 4 variables for use if the correct mission is found
			local quest_faction = "wh2_dlc16_emp_empire_qb8";
			local quest_unit_list = "wh_dlc03_emp_cha_wizard_beasts_3,wh_main_emp_inf_spearmen_1,wh_main_emp_inf_spearmen_1,wh_main_emp_inf_swordsmen,wh_main_emp_inf_swordsmen,wh_main_emp_inf_swordsmen,wh_main_emp_inf_swordsmen,wh_dlc04_emp_inf_free_company_militia_0,wh_dlc04_emp_inf_free_company_militia_0,wh_main_emp_cav_pistoliers_1,wh_main_emp_cav_outriders_1,wh2_dlc13_emp_veh_war_wagon_0";
			local quest_spawn_pos = {x = 0, y = 0};
			local quest_patrol = {{x = 1, y = 1}, {x = 0, y = 0}};
			local mission_check_bool = false;

			--cm:change_localised_faction_name("wh2_dlc16_emp_empire_qb8", "campaign_localised_strings_string_wh2_dlc16_drycha_empire_quest_faction_name")
			
			if (mission_key == "wh2_dlc16_wef_drycha_coeddil_unchained_stage_1") then --checks the campaign and mission then spawn army
				quest_spawn_pos = {x = 481, y = 479};
				quest_patrol = {{x = 481, y = 479}, {x = 499, y = 476}, {x = 509, y = 468}, {x = 491, y = 464}};
				mission_check_bool = true;
			end;
			
			if (mission_check_bool) then
				--create new army for targeting before creating mission
				local quest_inv = invasion_manager:new_invasion("drycha_quest_inv", quest_faction, quest_unit_list, quest_spawn_pos);
				quest_inv:set_target("PATROL", quest_patrol);
				--quest_inv:add_aggro_radius(300, {malus_faction}, 5, 3);
				quest_inv:create_general(false, "wh2_dlc13_emp_cha_huntsmarshal_0", "names_name_2147355226", "", "names_name_2147360722", "");
				quest_inv:start_invasion(nil,false,false,false);
				
				cm:force_diplomacy("all", "faction:"..quest_faction, "all", false, false, true);						--set all factions to not do diplomacy with inv faction
				cm:force_diplomacy("faction:"..quest_faction, "all", "all", false, false, true);						--set inv faction to not do diplomacy with all factions 
			end;
		end,
		true
	);
	core:add_listener(
		"Drycha_Quest_Declare_War_Empire",
		"MissionIssued",
		function(context)
			return context:mission():mission_record_key():find("wef_drycha_coeddil_unchained_stage_2");
		end,
		function(context)
			cm:force_declare_war(drycha_faction, "wh2_dlc16_emp_empire_qb8", true, true);	
		end,
		true
	);	
	core:add_listener(
		"Drycha_Quest_Kill_Empire",
		"MissionSucceeded",
		function(context)
			return context:mission():mission_record_key():find("wef_drycha_coeddil_unchained_stage_2");
		end,
		function(context)
			cm:kill_all_armies_for_faction(cm:get_faction("wh2_dlc16_emp_empire_qb8")); --kill army for faction after mission completed
		end,
		true
	);	
	--Adding catch for beastmen army not existing when attempting to start stage 3
		core:add_listener(
		"Drycha_Quest_Generation_Fallback",
		"MissionGenerationFailed",
		function(context)
			return context:mission():find("wh2_dlc16_wef_drycha_coeddil_unchained_stage_2");
		end,
		function()
			cm:trigger_mission(drycha_faction, "wh2_dlc16_wef_drycha_coeddil_unchained_stage_3", true);
		end,
		true
	);
end