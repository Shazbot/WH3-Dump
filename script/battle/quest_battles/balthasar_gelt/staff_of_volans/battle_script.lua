-- Balthasar Gelt, Staff of Volans 2.2, Attacker, High Pass
load_script_libraries();

m = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "gc_orbit_90_medium_ground_offset_north_west_extreme_high_02", 4000, false, false, false);
gc:add_element("EMP_Gelt_GS_Qbattle_staff_of_volans1_pt_01", "wh_main_qb_emp_balthasar_gelt_staff_of_volans_stage_2_pt_01", "gc_orbit_90_medium_commander_back_right_close_low_01", 4000, true, false, false);
gc:add_element("EMP_Gelt_GS_Qbattle_staff_of_volans1_pt_02", "wh_main_qb_emp_balthasar_gelt_staff_of_volans_stage_2_pt_02", "gc_slow_absolute_high_pass_statues_01_to_absolute_high_pass_statues_02", 4000, true, false, false);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      -- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);

gb:set_cutscene_during_deployment(true);
-- Gelt vs defending Chaos

-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);

ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), 1);

-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh_main_qb_emp_balthasar_gelt_staff_of_volans_main_objective");

-------HINTS-------
gb:queue_help_on_message("battle_started", "wh_main_qb_emp_balthasar_gelt_staff_of_volans_hint_objective", 13000, 2000, 0);

gb:queue_help_on_message("enemy_really_near", "wh_main_qb_emp_balthasar_gelt_staff_of_volans_stage_2_extra", 13000, 2000, 1000);
gb:play_sound_on_message("enemy_really_near", new_sfx("Play_EMP_Gelt_Qbattle_staff_of_volans1_post_ambush"), nil, 1000);

-------ORDERS-------
ga_ai_01:attack_on_message("enemy_near"); 

ga_player_01:message_on_proximity_to_enemy("enemy_near", 80);
ga_player_01:message_on_proximity_to_enemy("enemy_really_near", 60);
