-- Grombrindal,Rune Helm of Zhufbar, Attacker
load_script_libraries();

local gc = generated_cutscene:new(true, true);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "gc_slow_absolute_thundering_falls_waterfalls_01_to_absolute_thundering_falls_waterfalls_02", 4000, false, false, false);
gc:add_element("wh_pro01_DWF_Grom_Qbattle_Quest_for_Rune_Helm_Zhufbar_pt_01", "wh_pro01_qb_dwf_grombrindal_rune_helm_of_zhufbar_pt_01", nil, 4000, true, false, false);
gc:add_element("wh_pro01_DWF_Grom_Qbattle_Quest_for_Rune_Helm_Zhufbar_pt_02", "wh_pro01_qb_dwf_grombrindal_rune_helm_of_zhufbar_pt_02", "gc_medium_army_pan_front_right_to_front_left_far_high_01", 4000, true, false, false);
gc:add_element("wh_pro01_DWF_Grom_Qbattle_Quest_for_Rune_Helm_Zhufbar_pt_03", "wh_pro01_qb_dwf_grombrindal_rune_helm_of_zhufbar_pt_03", "gc_orbit_360_slow_commander_front_left_close_low_01", 4000, true, false, false);
gc:add_element("wh_pro01_DWF_Grom_Qbattle_Quest_for_Rune_Helm_Zhufbar_pt_04", "wh_pro01_qb_dwf_grombrindal_rune_helm_of_zhufbar_pt_04", "qb_final_position_sub", 4000, true, false, false);

gb = generated_battle:new(
	false,                                      		-- screen starts black
	false,                                      		-- prevent deployment for player
	false,                                      		-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      			-- debug mode
);

gb:set_cutscene_during_deployment(true);

-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(0), 1);		
ga_ally_01 = gb:get_army(gb:get_player_alliance_num(0), 2);	
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(1), 1);
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(1), 2);
ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(1), 3);
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_defend_defeat_army");
gb:queue_help_on_message("battle_start","wh_pro01_qb_dwf_grombrindal_rune_helm_of_zhufbar_stage_4_hint_objective");
gb:queue_help_on_message("wave_arrive","wh_pro01_qb_dwf_grombrindal_rune_helm_of_zhufbar_stage_4_hint_reinforcement");


-------OBJECTIVES-------



-------ORDERS-------
gb:message_on_time_offset("battle_start", 1000);

gb:message_on_time_offset("start_ambush", 60000);
ga_ally_01:halt();
ga_ally_01:attack_on_message("battle_start");
ga_ai_03:reinforce_on_message("battle_start",120000);
ga_ai_01:message_on_casualties("reinforce",0.8);
ga_ai_02:message_on_casualties("reinforce",0.8);
ga_ai_03:reinforce_on_message("reinforce",1000);
ga_ai_03:message_on_deployed("wave_arrive"); 
-- ga_ai_01:message_on_under_attack("discovered1");
-- ga_ai_01:release_on_message("discovered1");
-- ga_ai_02:attack_on_message("battle_start");
ga_ai_02:reinforce_on_message("battle_start",1000);
-- ga_ai_03:attack_on_message("start_ambush",290000);
-- ga_ai_04:attack_on_message("start_ambush",250000);




