load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);


gc:add_element(nil, nil, "gc_medium_absolute_void_hel_fenn_tower_01_to_absolute_void_hel_fenn_tower_02", 4000, false, false, false);
gc:add_element("Play_wh_dlc04_qb_emp_volkmar_the_grim_jade_griffon_stage_5_pt_01", "wh_dlc04_qb_emp_volkmar_the_grim_jade_griffon_stage_5_pt_01", nil, 11700, false, false, false);
gc:add_element("Play_wh_dlc04_qb_emp_volkmar_the_grim_jade_griffon_stage_5_pt_02", "wh_dlc04_qb_emp_volkmar_the_grim_jade_griffon_stage_5_pt_02", "gc_medium_absolute_void_hel_fenn_pit_01_to_absolute_void_hel_fenn_pit_02", 9700, false, false, false);
gc:add_element(nil, nil, nil, 3000, false, false, false)
gc:add_element("Play_wh_dlc04_qb_emp_volkmar_the_grim_jade_griffon_stage_5_pt_03", "wh_dlc04_qb_emp_volkmar_the_grim_jade_griffon_stage_5_pt_03", "gc_orbit_ccw_90_medium_commander_back_right_extreme_high_01", 8000, false, false, false);
gc:add_element(nil, nil, "gc_orbit_ccw_90_medium_commander_front_close_low_01", 10000, false, false, false);
gc:add_element(nil,nil, nil, 3000, true, true, false);


gb:set_cutscene_during_deployment(true);

---------------------------
----HARD SCRIPT VERSION----
---------------------------
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_attack_defeat_army");
gb:queue_help_on_message("battle_started", "wh_dlc04_qb_emp_volkmar_jade_griffon_hint_objective");
gb:queue_help_on_message("reinforced", "wh_dlc04_qb_emp_volkmar_jade_griffon_hint_reinforcement");


-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);		
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), "defender_1");
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), "defender_2");
ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(), "defender_3");




-------OBJECTIVES-------


-------ORDERS-------

gb:message_on_time_offset("start_ambush", 10000);
ga_ai_01:attack_on_message("start_ambush");
ga_ai_01:message_on_proximity_to_enemy("charge", 200);
ga_ai_01:message_on_under_attack("charge");
ga_ai_01:message_on_casualties("charge",0.90);
ga_ai_02:reinforce_on_message("charge",45000);
ga_ai_03:reinforce_on_message("charge",85000);
ga_ai_02:message_on_any_deployed("reinforced");
ga_ai_03:message_on_any_deployed("reinforced_here_too");

ga_ai_02:attack_on_message("reinforced");
ga_ai_03:attack_on_message("reinforced_here_too");

ga_ai_02:release_on_message("reinforced", 60000);
ga_ai_03:release_on_message("reinforced_here_too", 60000);