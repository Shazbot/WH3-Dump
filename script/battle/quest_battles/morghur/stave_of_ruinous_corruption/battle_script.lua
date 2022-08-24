load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);

gc:add_element(nil,nil, "gc_orbit_90_medium_commander_front_close_low_01", 4000, false, false, false);
gc:add_element("wh_dlc03_qb_bst_Morghur_battle_spirit_chaos_pt_01","wh_dlc03_qb_bst_Morghur_battle_spirit_chaos_pt_01",nil, 7000, false, false, false);
gc:add_element(nil,nil, "gc_orbit_ccw_360_slow_ground_offset_south_east_extreme_high_02", 3000, false, false, false);
gc:add_element("wh_dlc03_qb_bst_Morghur_battle_spirit_chaos_pt_02","wh_dlc03_qb_bst_Morghur_battle_spirit_chaos_pt_02", "gc_medium_enemy_army_pan_back_left_to_back_right_close_medium_01", 6000, false, false, false);
gc:add_element(nil,nil, "gc_orbit_90_medium_commander_back_left_extreme_high_01", 4000, false, false, false);
gc:add_element("wh_dlc03_qb_bst_Morghur_battle_spirit_chaos_pt_03","wh_dlc03_qb_bst_Morghur_battle_spirit_chaos_pt_03",nil, 7000, false, false, false);
gc:add_element(nil,nil, "gc_medium_army_pan_front_left_to_right_medium_low_01", 3000, false, false, false);
gc:add_element("wh_dlc03_qb_bst_Morghur_battle_spirit_chaos_pt_04","wh_dlc03_qb_bst_Morghur_battle_spirit_chaos_pt_04",nil, 7000, false, false, false);
gc:add_element(nil, nil, "gc_orbit_90_medium_commander_front_close_low_01", 7000, false, false, false);

gb:set_cutscene_during_deployment(true);
---------------------------
----HARD SCRIPT VERSION----
---------------------------

-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_attack_defeat_army");

-------HINTS-------
gb:queue_help_on_message("battle_started", "wh_dlc05_qb_bst_morghur_stave_of_ruinous_chaos_stage_3_hint_objective");
--gb:queue_help_on_message("monsters_are_dead", "wh_dlc05_qb_bst_morghur_stave_of_ruinous_chaos_stage_3_hint_reinforcement");

gb:queue_help_on_message("1", "wh_dlc05_qb_bst_morghur_stave_of_ruinous_chaos_stage_3_hint_unique_mechanism_0");
gb:queue_help_on_message("2", "wh_dlc05_qb_bst_morghur_stave_of_ruinous_chaos_stage_3_hint_unique_mechanism_1");
gb:queue_help_on_message("3", "wh_dlc05_qb_bst_morghur_stave_of_ruinous_chaos_stage_3_hint_unique_mechanism_2");


-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(0), 1);		
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(1), 1);
--ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(1), 2);




-------OBJECTIVES-------



-------ORDERS-------
gb:message_on_time_offset("1", 60000);
gb:message_on_time_offset("2", 300000);
gb:message_on_time_offset("3", 630000);
ga_ai_01:message_on_casualties("monsters_are_dead", 0.4); 
--ga_ai_02:reinforce_on_message("monsters_are_dead",10000);



