load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);

	gc:add_element(nil, nil, "gc_medium_absolute_bonewood_staff_00", 6000, false, false, false);
	gc:add_element("Play_wh_dlc06_qb_grn_wurrzag_da_great_green_prophet_bonewood_staff_stage_4_pt_01", "wh_dlc06_qb_grn_wurrzag_da_great_green_prophet_bonewood_staff_stage_4_pt_01", nil, 6680, false, false, false);
	gc:add_element("Play_wh_dlc06_qb_grn_wurrzag_da_great_green_prophet_bonewood_staff_stage_4_pt_02", "wh_dlc06_qb_grn_wurrzag_da_great_green_prophet_bonewood_staff_stage_4_pt_02", "gc_medium_absolute_bonewood_staff_01", 10330, false, false, false);
	gc:add_element("Play_wh_dlc06_qb_grn_wurrzag_da_great_green_prophet_bonewood_staff_stage_4_pt_03", "wh_dlc06_qb_grn_wurrzag_da_great_green_prophet_bonewood_staff_stage_4_pt_03", "gc_orbit_90_medium_commander_front_left_extreme_high_01", 4140, false, false, false);
	gc:add_element(nil, nil, "gc_orbit_ccw_90_medium_commander_front_close_low_01", 4000, false, false, false);
	gc:add_element(nil,nil, nil, 3000, true, true, false);

gb:set_cutscene_during_deployment(true);

---------------------------
----HARD SCRIPT VERSION----
---------------------------


-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(0), 1);		
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(1), 1);
ga_ai_officer = gb:get_army(gb:get_non_player_alliance_num(1), 1, "officer");
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(1), 2);
--ga_ai_04 = gb:get_army(gb:get_non_player_alliance_num(1), 4);
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_kill_enemy_general");

-------OBJECTIVES-------
gb:queue_help_on_message("engaged", "wh_dlc06_qb_grn_wurrzag_da_great_green_prophet_bonewood_staff_stage_3_hint_objective");
gb:queue_help_on_message("ai_commander_dies_1", "wh_dlc06_qb_grn_wurrzag_da_great_green_prophet_bonewood_staff_stage_3_hint_objective_complete");


-------ORDERS-------

gb:message_on_time_offset("start_ambush", 1000);
ga_ai_01:message_on_proximity_to_enemy("engaged", 200);
--ga_ai_01:attack_on_message("start_ambush");
--ga_ai_02:reinforce_on_message("engaged",20000);
ga_ai_officer:halt();
ga_ai_officer:attack_on_message("engaged",15000);
--ga_ai_01:set_visible_to_all(true);
--ga_player_01:set_visible_to_all(false);
--ga_ai_02:set_visible_to_all(true);
--ga_ai_03:set_visible_to_all(true);
ga_ai_officer:message_on_casualties("ai_commander_dies_1",0.6);
ga_ai_officer:message_on_rout_proportion("ai_commander_dies_1",0.6);
--ga_ai_02:attack_on_message("engaged");
--ga_ai_03:reinforce_on_message("engaged",90000);
--ga_ai_03:attack_on_message("engaged");
--ga_ai_02:deploy_at_random_intervals_on_message("engaged", 3, 3, 100000, 110000);
-- ga_ai_03:deploy_at_random_intervals_on_message("engaged", 3, 3, 100000, 110000);
ga_ai_02:deploy_at_random_intervals_on_message("engaged", 2, 3, 80000, 85000, "ai_commander_dies_1");
--ga_ai_02:deploy_at_random_intervals_on_message("engaged1", 2, 3, 40000, 45000, "ai_commander_dies_1");
--ga_ai_04:reinforce_on_message("engaged",20000); 
--ga_ai_04:attack_on_message("engaged");
ga_ai_02:rout_over_time_on_message("ai_commander_dies_1", 60000); 



