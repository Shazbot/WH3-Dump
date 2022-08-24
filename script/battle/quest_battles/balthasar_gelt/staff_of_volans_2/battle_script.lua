-- Balthasar Gelt, Staff of Volans 3, Defender, Bloodpine Woods
load_script_libraries();

m = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "gc_medium_absolute_bloodpine_road_01_to_absolute_bloodpine_road_02", 4000, false, false, false);
gc:add_element("EMP_Gelt_GS_Qbattle_staff_of_volans2_pt_01", "wh_main_qb_emp_balthasar_gelt_staff_of_volans_stage_3_pt_01", nil, 4000, true, false, false);
gc:add_element("EMP_Gelt_GS_Qbattle_staff_of_volans2_pt_02", "wh_main_qb_emp_balthasar_gelt_staff_of_volans_stage_3_pt_02", "gc_medium_absolute_bloodpine_church_01_to_absolute_bloodpine_church_02", 4000, true, false, false);
gc:add_element("EMP_Gelt_GS_Qbattle_staff_of_volans2_pt_03", "wh_main_qb_emp_balthasar_gelt_staff_of_volans_stage_3_pt_03", nil, 4000, false, false, false);
gc:add_element(nil, nil, "gc_medium_army_pan_front_right_to_front_left_far_high_01", 4000, true, false, false);
gc:add_element("EMP_Gelt_GS_Qbattle_staff_of_volans2_pt_04", "wh_main_qb_emp_balthasar_gelt_staff_of_volans_stage_3_pt_04", false, 4000, true, false, false);
gc:add_element("EMP_Gelt_GS_Qbattle_staff_of_volans2_pt_05", "wh_main_qb_emp_balthasar_gelt_staff_of_volans_stage_3_pt_05", "gc_orbit_90_medium_commander_front_right_close_low_01", 4000, true, true, false);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);

gb:set_cutscene_during_deployment(true);


-------GENERALS SPEECH--------



-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);

ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), 1); -- Orr
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), 2); -- Mercenaries

-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_defend_defeat_army");

-------HINTS-------
gb:queue_help_on_message("battle_started", "wh_main_qb_emp_balthasar_gelt_staff_of_volans_stage_3_hint_objective");
gb:queue_help_on_message("ambush_detected", "wh_main_qb_emp_balthasar_gelt_staff_of_volans_stage_3_hint_reinforcements");

-------ORDERS-------
gb:message_on_time_offset("move", 2000);

ga_ai_01:attack_on_message("move");
ga_ai_01:message_on_casualties("reinforcements_called", 0.35);

ga_ai_02:reinforce_on_message("reinforcements_called");
ga_ai_02:get_army():suppress_reinforcement_adc();
ga_ai_02:message_on_seen_by_enemy("ambush_detected");
ga_ai_02:message_on_any_deployed("ambush_in");
ga_ai_02:rush_on_message("ambush_in");