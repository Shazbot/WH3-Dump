-- Grombrindal, Axe of Grimnir, Defender
load_script_libraries();

local gc = generated_cutscene:new(true, true);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "gc_medium_absolute_golden_monolith_01_02", 3000, false, false, false);
gc:add_element("wh_pro01_DWF_Grom_Qbattle_Quest_Rune_Axe_pt_01", "wh_pro01_qb_dwf_grombrindal_rune_axe_pt_01", nil, 4000, false, false, false);
gc:add_element("wh_pro01_DWF_Grom_Qbattle_Quest_Rune_Axe_pt_02", "wh_pro01_qb_dwf_grombrindal_rune_axe_pt_02", "gc_orbit_ccw_90_medium_commander_front_right_close_low_01", 4000, false, false, false);
gc:add_element("wh_pro01_DWF_Grom_Qbattle_Quest_Rune_Axe_pt_03", "wh_pro01_qb_dwf_grombrindal_rune_axe_pt_03", nil, 4000, false, false, false);
gc:add_element("wh_pro01_DWF_Grom_Qbattle_Quest_Rune_Axe_pt_04", "wh_pro01_qb_dwf_grombrindal_rune_axe_pt_04", "qb_final_position_short", 4000, true, false, false);
gc:add_element(nil, nil, "gc_orbit_ccw_90_medium_commander_front_close_low_01", 6000, false, false, false);
gc:add_element(nil,nil, nil, 3000, true, true, false);

gb = generated_battle:new(
	false,                                     			-- screen starts black
	false,                                      		-- prevent deployment for player
	false,                                      		-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      			-- debug mode
);

gb:set_cutscene_during_deployment(true);



-------GENERALS SPEECH--------


-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), 1);
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), 2);
ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(), 3);


-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_defend_defeat_army");

-------HINTS-------
gb:queue_help_on_message("battle_started", "wh_pro01_qb_dwf_grombrindal_rune_axe_of_grimnir_stage_3_hint_objective");
gb:queue_help_on_message("wave_arrive", "wh_pro01_qb_dwf_grombrindal_rune_axe_of_grimnir_stage_3_hint_reinforcement");

-------ORDERS-------
ga_player_01:message_on_proximity_to_enemy("summon_wave_01", 20);
ga_ai_01:attack_on_message("battle_started",15000);
ga_ai_02:reinforce_on_message("summon_wave_01", 25000);
ga_ai_03:reinforce_on_message("summon_wave_01", 55000);
ga_ai_02:message_on_deployed("wave_arrive"); 