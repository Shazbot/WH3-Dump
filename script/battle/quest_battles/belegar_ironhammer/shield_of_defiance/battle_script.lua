load_script_libraries();

local gc = generated_cutscene:new(true, true);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);

	gc:add_element(nil, nil, "gc_medium_absolute_ancient_hall_00", 4000, false, false, false);
	gc:add_element("Play_wh_dlc06_qb_dwf_belegar_ironhammer_shield_of_defiance_stage_3_pt_01", "wh_dlc06_qb_dwf_belegar_ironhammer_shield_of_defiance_stage_3_pt_01", nil, 10060, false, false, false);
	gc:add_element("Play_wh_dlc06_qb_dwf_belegar_ironhammer_shield_of_defiance_stage_3_pt_02", "wh_dlc06_qb_dwf_belegar_ironhammer_shield_of_defiance_stage_3_pt_02", "gc_medium_absolute_ancient_hall_01", 5260, false, false, false);
	gc:add_element("Play_wh_dlc06_qb_dwf_belegar_ironhammer_shield_of_defiance_stage_3_pt_03", "wh_dlc06_qb_dwf_belegar_ironhammer_shield_of_defiance_stage_3_pt_03", nil, 6210, false, false, false);
	--gc:add_element(nil, nil, "gc_medium_commander_front_medium_medium_to_close_low_01", 5000, false, false, false);
	gc:add_element(nil, nil, "qb_final_position_short", 5000, true, false, false);

gb:set_cutscene_during_deployment(true);


---------------------------
----HARD SCRIPT VERSION----
---------------------------


-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(0), 1);		
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(1), 1);
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(1), 2);
ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(1), 3);



-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_attack_defeat_army");

-------HINTS-------
gb:queue_help_on_message("battle_started", "wh_dlc06_qb_dwf_belegar_ironhammer_shield_of_defiance_stage_3_hint_objective");


-------ORDERS-------

gb:message_on_time_offset("start_ambush", 1000);
ga_ai_01:message_on_proximity_to_enemy("engaged", 200);
ga_ai_01:message_on_casualties("main_force_dead",0.8);
ga_ai_03:deploy_at_random_intervals_on_message("engaged", 2, 2, 40000, 45000);
ga_ai_02:reinforce_on_message("engaged",240000);
ga_ai_02:reinforce_on_message("main_force_dead",1000);
ga_ai_02:message_on_deployed("wave_arrive"); 




