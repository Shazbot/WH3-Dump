load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);


gc:add_element(nil, nil, "gc_medium_absolute_staff_of_command_00", 3000, false, false, false);
gc:add_element("Play_wh_dlc04_qb_emp_volkmar_the_grim_staff_of_command_stage_6_pt_01", "wh_dlc04_qb_emp_volkmar_the_grim_staff_of_command_stage_6_pt_01", nil, 12000, false, false, false);
gc:add_element("Play_wh_dlc04_qb_emp_volkmar_the_grim_staff_of_command_stage_6_pt_02", "wh_dlc04_qb_emp_volkmar_the_grim_staff_of_command_stage_6_pt_02", "gc_medium_absolute_staff_of_command_01", 14700, false, false, false);
gc:add_element("Play_wh_dlc04_qb_emp_volkmar_the_grim_staff_of_command_stage_6_pt_03", "wh_dlc04_qb_emp_volkmar_the_grim_staff_of_command_stage_6_pt_03", "gc_medium_absolute_staff_of_command_02", 17700, false, false, false);
gc:add_element("Play_wh_dlc04_qb_emp_volkmar_the_grim_staff_of_command_stage_6_pt_04", "wh_dlc04_qb_emp_volkmar_the_grim_staff_of_command_stage_6_pt_04", "gc_orbit_90_medium_commander_front_left_extreme_high_01", 6000, false, false, false);
gc:add_element(nil, nil, "gc_orbit_ccw_90_medium_commander_front_close_low_01", 6000, false, false, false);
gc:add_element(nil,nil, nil, 3000, true, true, false);


gb:set_cutscene_during_deployment(true);

---------------------------
----HARD SCRIPT VERSION----
---------------------------
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_kill_enemy_general");

-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(0), 1);		
ga_player_02=gb:get_army(gb:get_player_alliance_num(0), 2);	
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(1), 1);
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(1), 2);
ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(1), 3);




-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_kill_enemy_general");
gb:queue_help_on_message("battle_started", "wh_dlc04_qb_emp_volkmar_staff_of_command_hint_objective");
gb:queue_help_on_message("charge1", "wh_dlc04_qb_emp_volkmar_staff_of_command_hint_reinforcement");
gb:queue_help_on_message("enemy_commander_dies", "wh_dlc04_qb_emp_volkmar_staff_of_command_hint_enemy_general_down");


-------ORDERS-------

gb:message_on_time_offset("battle_start", 5000);
ga_ai_01:message_on_proximity_to_enemy("charge1", 200);
ga_ai_01:message_on_proximity_to_enemy("charge", 500);
ga_ai_01:attack_on_message("battle_start");
ga_ai_01:message_on_casualties("enemy_low",0.20);
ga_player_01:message_on_casualties("player_low",0.80);
ga_player_02:rout_over_time_on_message("player_low",1000); 
ga_ai_02:deploy_at_random_intervals_on_message("charge", 2, 2, 35000, 45000);
ga_ai_03:reinforce_on_message("charge1",100);
ga_ai_03:reinforce_on_message("enemy_low",100);



ga_ai_01:message_on_commander_dead_or_routing("enemy_commander_dies",1000);
ga_player_02:reinforce_on_message("enemy_commander_dies",1000);
ga_ai_02:reinforce_on_message("enemy_commander_dies",1000);

gb:queue_help_on_message("charge", "wh_dlc04_qb_emp_volkmar_staff_of_command_hint_reinforcement");

