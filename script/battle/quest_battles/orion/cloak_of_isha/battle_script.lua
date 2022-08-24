load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);

gc:add_element(false,false, "gc_orbit_90_medium_commander_front_close_low_01", 8500, false, false, false);
gc:add_element("wh_dlc05_qb_wef_orion_cloak_of_isha_pt_01","wh_dlc05_qb_wef_orion_cloak_of_isha_pt_01", false, 8000, false, false, false);
gc:add_element("wh_dlc05_qb_wef_orion_cloak_of_isha_pt_02","wh_dlc05_qb_wef_orion_cloak_of_isha_pt_02", "gc_orbit_ccw_360_slow_ground_offset_north_east_extreme_high_02", 15000, false, false, false);
gc:add_element("wh_dlc05_qb_wef_orion_cloak_of_isha_pt_03","wh_dlc05_qb_wef_orion_cloak_of_isha_pt_03", "gc_orbit_90_medium_commander_back_right_extreme_high_01", 12500, false, false, false);
gc:add_element("wh_dlc05_qb_wef_orion_cloak_of_isha_pt_04","wh_dlc05_qb_wef_orion_cloak_of_isha_pt_04", "gc_orbit_90_medium_commander_front_close_low_01", 5000, false, false, false);

gb:set_cutscene_during_deployment(true);
---------------------------
----HARD SCRIPT VERSION----
---------------------------


-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(0), 1);		
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(1), 1);
--ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(1), 2);




-------OBJECTIVES-------
gb:queue_help_on_message("battle_started", "wh_dlc05_qb_wef_orion_cloak_of_isha_stage_3_hint_obejctive");
gb:queue_help_on_message("start_ambush", "wh_dlc05_qb_wef_orion_cloak_of_isha_stage_3_hint_unique_mechanism");

-------ORDERS-------

gb:message_on_time_offset("start_ambush", 210000);
--ga_ai_01:attack_on_message("battle_started");
ga_ai_01:defend_on_message("battle_started", 490, -140, 40); 
--ga_ai_02:reinforce_on_message("start_ambush",60000);









