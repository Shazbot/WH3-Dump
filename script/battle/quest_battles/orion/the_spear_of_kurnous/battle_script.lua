load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);

gc:add_element(nil, nil, "gc_medium_commander_back_medium_medium_to_close_low_01", 4000, false, false, false);
gc:add_element("wh_dlc05_qb_wef_orion_spear_of_kurnous_pt_01","wh_dlc05_qb_wef_orion_spear_of_kurnous_pt_01", nil, 10500, false, false, false);
gc:add_element(nil,nil, "gc_orbit_ccw_360_slow_ground_offset_south_west_extreme_high_02", 6500, false, false, false);
gc:add_element("wh_dlc05_qb_wef_orion_spear_of_kurnous_pt_02","wh_dlc05_qb_wef_orion_spear_of_kurnous_pt_02", "gc_slow_enemy_army_pan_back_left_to_back_right_far_high_01", 10600, false, false, false);
gc:add_element(nil,nil, "gc_orbit_90_medium_commander_back_left_extreme_high_01", 4000, false, false, false);
gc:add_element("wh_dlc05_qb_wef_orion_spear_of_kurnous_pt_03","wh_dlc05_qb_wef_orion_spear_of_kurnous_pt_03",nil, 9700, false, false, false);
gc:add_element(nil, nil, "gc_medium_commander_front_medium_medium_to_close_low_01", 5700, false, false, false);

gb:set_cutscene_during_deployment(true);
---------------------------
----HARD SCRIPT VERSION----
---------------------------


-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);		
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army");
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_reinforcements_1");
ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_reinforcements_2");





-------OBJECTIVES-------
gb:queue_help_on_message("battle_started", "wh_dlc05_qb_wef_orion_spear_of_kurnous_stage_3_hint_objective");
gb:queue_help_on_message("cavelry_arrived", "wh_dlc05_qb_wef_orion_spear_of_kurnous_stage_3_hint_reinforcement");
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_attack_defeat_army");
-------ORDERS-------

ga_ai_01:message_on_casualties("hurt",0.10);
ga_ai_02:reinforce_on_message("hurt",20000);
ga_ai_03:reinforce_on_message("hurt",20000);
ga_ai_02:message_on_any_deployed("cavelry_arrived");




