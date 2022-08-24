load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);

	gc:add_element(nil, nil, "gc_medium_absolute_lost_vault_01", 6000, false, false, false);
	gc:add_element("Play_wh_dlc06_qb_dwf_belegar_ironhammer_hammer_of_anground_stage_4_pt_01", "wh_dlc06_qb_dwf_belegar_ironhammer_hammer_of_anground_stage_4_pt_01", nil, 1380, false, false, false);
	gc:add_element(nil, nil, "gc_medium_absolute_lost_vault_00", 2000, false, false, false);
	gc:add_element("Play_wh_dlc06_qb_dwf_belegar_ironhammer_hammer_of_anground_stage_4_pt_02", "wh_dlc06_qb_dwf_belegar_ironhammer_hammer_of_anground_stage_4_pt_02", nil, 4030, false, false, false);
	gc:add_element(nil, nil, "gc_medium_absolute_lost_vault_02", 7000, false, false, false);
	gc:add_element("Play_wh_dlc06_qb_dwf_belegar_ironhammer_hammer_of_anground_stage_4_pt_03", "wh_dlc06_qb_dwf_belegar_ironhammer_hammer_of_anground_stage_4_pt_03", "gc_medium_absolute_lost_vault_03", 7530, false, false, false);
	gc:add_element(nil, nil, "gc_orbit_90_medium_commander_front_left_extreme_high_01", 4000, false, false, false);
	gc:add_element(nil,nil, nil, 2000, true, true, false);

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
gb:queue_help_on_message("battle_started", "wh_dlc06_qb_dwf_belegar_ironhammer_hammer_of_angrund_stage_4_hint_objective");
gb:queue_help_on_message("wave_arrive", "wh_dlc06_qb_dwf_belegar_ironhammer_hammer_of_angrund_stage_4_hint_reinforcement");


-------ORDERS-------

ga_ai_01:attack_on_message("battle_started");
--ga_ai_01:message_on_under_attack("start_ambush");
ga_ai_01:message_on_casualties("reinforce_1",0.4);
ga_ai_01:message_on_casualties("reinforce_2",0.2);
ga_ai_02:reinforce_on_message("reinforce_1",15000);
ga_ai_03:reinforce_on_message("reinforce_2",15000);
--ga_ai_02:reinforce_on_message("start_ambush",45000);
--ga_ai_03:reinforce_on_message("start_ambush",15000);
ga_ai_02:message_on_deployed("wave_arrive"); 
