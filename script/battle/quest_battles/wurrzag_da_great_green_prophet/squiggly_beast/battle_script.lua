load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);

	gc:add_element(nil, nil, "gc_medium_absolute_squigly_beast_00", 5000, false, false, false);
	gc:add_element("Play_wh_dlc06_qb_grn_wurrzag_da_great_green_prophet_squiggly_beast_stage_4_pt_01", "wh_dlc06_qb_grn_wurrzag_da_great_green_prophet_squiggly_beast_stage_4_pt_01", nil, 8570, false, false, false);
	gc:add_element("Play_wh_dlc06_qb_grn_wurrzag_da_great_green_prophet_squiggly_beast_stage_4_pt_02", "wh_dlc06_qb_grn_wurrzag_da_great_green_prophet_squiggly_beast_stage_4_pt_02", nil, 5880, false, false, false);
	gc:add_element(nil, nil, "gc_medium_absolute_squigly_beast_01", 3000, false, false, false);
	gc:add_element("Play_wh_dlc06_qb_grn_wurrzag_da_great_green_prophet_squiggly_beast_stage_4_pt_03", "wh_dlc06_qb_grn_wurrzag_da_great_green_prophet_squiggly_beast_stage_4_pt_03", nil, 4570, false, false, false);
	gc:add_element(nil, nil, "gc_orbit_ccw_90_medium_commander_front_close_low_01", 2000, false, false, false);
	gc:add_element(nil,nil, nil, 3000, true, true, false);

gb:set_cutscene_during_deployment(true);

---------------------------
----HARD SCRIPT VERSION----
---------------------------
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_attack_defeat_army");

-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(0), 1);		
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(1), 1);
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(1), "west");
ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(1), "east");



-------OBJECTIVES-------
gb:queue_help_on_message("battle_started", "wh_dlc06_qb_grn_wurrzag_da_great_green_prophet_squiggly_beast_stage_3_hint_objective");
gb:queue_help_on_message("engaged", "wh_dlc06_qb_grn_wurrzag_da_great_green_prophet_squiggly_beast_stage_3_hint_reinforcement",10000,10000,45000);


-------ORDERS-------

gb:message_on_time_offset("start_ambush", 10000);
ga_ai_01:message_on_proximity_to_enemy("engaged", 600);
ga_ai_01:attack_on_message("start_ambush");
ga_ai_02:deploy_at_random_intervals_on_message("engaged", 3, 3, 45000, 50000);
ga_ai_03:deploy_at_random_intervals_on_message("engaged", 3, 3, 45000, 50000);
ga_ai_02:attack_on_message("engaged");
ga_ai_03:attack_on_message("engaged");
ga_ai_02:message_on_deployed("wave_in");
ga_ai_01:message_on_casualties("main_force_dead",0.8);
ga_ai_02:reinforce_on_message("main_force_dead");
ga_ai_03:reinforce_on_message("main_force_dead");




