load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);

	gc:add_element(nil, nil, "gc_medium_absolute_lost_idles_00", 6000, false, false, false);
	gc:add_element("Play_wh_dlc06_qb_grn_wurrzag_da_great_green_prophet_baleful_mask_stage_4_pt_01", "wh_dlc06_qb_grn_wurrzag_da_great_green_prophet_baleful_mask_stage_4_pt_01", nil, 4860, false, false, false);
	gc:add_element(nil, nil, "gc_medium_absolute_lost_idles_01", 10500, false, false, false);
	--gc:add_element(nil, nil, "gc_orbit_90_medium_commander_front_left_extreme_high_01", 3000, false, false, false)
	gc:add_element("Play_wh_dlc06_qb_grn_wurrzag_da_great_green_prophet_baleful_mask_stage_4_pt_02", "wh_dlc06_qb_grn_wurrzag_da_great_green_prophet_baleful_mask_stage_4_pt_02", nil, 6230, false, false, false);
	gc:add_element("Play_wh_dlc06_qb_grn_wurrzag_da_great_green_prophet_baleful_mask_stage_4_pt_03", "wh_dlc06_qb_grn_wurrzag_da_great_green_prophet_baleful_mask_stage_4_pt_03", "gc_orbit_90_medium_commander_back_close_low_01", 3410, false, false, false);
	gc:add_element(nil,nil, nil, 3000, true, true, false);

gb:set_cutscene_during_deployment(true);


---------------------------
----HARD SCRIPT VERSION----
---------------------------


-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(0), 1);		
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(1), 1);
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(1), 2);



-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_attack_defeat_army");

-------HINTS-------
gb:queue_help_on_message("battle_started", "wh_dlc06_qb_grn_wurrzag_da_great_green_prophet_baleful_mask_stage_4_hint_objective");
gb:queue_help_on_message("wave_arrive", "wh_dlc06_qb_grn_wurrzag_da_great_green_prophet_baleful_mask_stage_4_hint_reinforcement");


-------ORDERS-------

gb:message_on_time_offset("start_ambush", 1000);
ga_ai_01:halt();
ga_ai_01:message_on_proximity_to_enemy("engaged", 200);
ga_ai_01:message_on_under_attack("engaged");
ga_ai_01:attack_on_message("engaged");
ga_ai_01:message_on_casualties("main_force_dead",0.8);
ga_ai_02:reinforce_on_message("main_force_dead");
ga_ai_02:reinforce_on_message("engaged",40000);
ga_ai_02:message_on_deployed("wave_arrive");




