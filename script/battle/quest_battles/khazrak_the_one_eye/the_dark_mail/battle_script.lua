load_script_libraries();

local gc = generated_cutscene:new(true);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil,nil, "gc_medium_absolute_kelp_and_kodust_town_to_absolute_kelp_and_kodust_town_01", 7000, false, false, false);
gc:add_element("Play_wh_dlc03_qb_bst_khazrak_one_eye_the_dark_mail_stage_5_ashes_of_kelp_and_koldust_pt_01", "wh_dlc03_qb_bst_khazrak_one_eye_the_dark_mail_stage_5_ashes_of_kelp_and_koldust_pt_01", nil, 8000, false, false, false);
gc:add_element("Play_wh_dlc03_qb_bst_khazrak_one_eye_the_dark_mail_stage_5_ashes_of_kelp_and_koldust_pt_02", "wh_dlc03_qb_bst_khazrak_one_eye_the_dark_mail_stage_5_ashes_of_kelp_and_koldust_pt_02", "gc_medium_absolute_kelp_and_kodust_town_01_to_absolute_kelp_and_kodust_town_02", 10000, true, false, false);
gc:add_element("Play_wh_dlc03_qb_bst_khazrak_one_eye_the_dark_mail_stage_5_ashes_of_kelp_and_koldust_pt_03", "wh_dlc03_qb_bst_khazrak_one_eye_the_dark_mail_stage_5_ashes_of_kelp_and_koldust_pt_03", "gc_orbit_ccw_90_medium_commander_front_right_close_low_01", 4000, true, false, false);
gc:add_element(nil,nil, nil, 1000, true, true, false);
--gc:add_element(nil, nil, "gc_fast_commander_back_medium_medium_to_close_low_01", 400, false, true, false);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);

gb:set_cutscene_during_deployment(true);

---------------------------
----HARD SCRIPT VERSION----
---------------------------
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_attack_defeat_army");

-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(0), 1);		
--SUnit_Khazrak=ga_player_01:get_first_scriptunit();
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(1), 1);
--SUnit_graktar = gb:get_army(gb:get_non_player_alliance(1), 1, "graktar");
--SUnit_graktar = script_unit:new_by_reference(ga_ai_01.army, "graktar");
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(1), 2);
ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(1), 3);
--ga_ai_04 = gb:get_army(gb:get_non_player_alliance(1), 4);




-------OBJECTIVES-------

gb:queue_help_on_message("battle_started", "wh_dlc03_qb_bst_khazrak_one_eye_the_dark_mail_stage_5_hint_objective");

-------ORDERS-------

gb:message_on_time_offset("battle_start", 1000);
ga_ai_01:halt();
ga_ai_01:message_on_proximity_to_enemy("discovered1", 200);
ga_ai_01:message_on_under_attack("discovered1");
ga_ai_01:attack_on_message("discovered1");
ga_ai_02:reinforce_on_message("discovered1",30000);
ga_ai_02:message_on_casualties("summon_reinforcements", 0.3);
ga_ai_02:attack_on_message("discovered1");
--ga_ai_03:reinforce_on_message("discovered1",165000);
ga_ai_03:reinforce_on_message("summon_reinforcements");
gb:queue_help_on_message("summon_reinforcements", "wh_dlc03_qb_bst_khazrak_one_eye_the_dark_mail_stage_5_hint_reinforcements_02");
ga_ai_03:message_on_deployed("arrived");
ga_ai_03:attack_on_message("arrived");
ga_ai_02:message_on_commander_dead_or_routing("ai_commander_dies");
gb:queue_help_on_message("ai_commander_dies", "wh_dlc03_qb_bst_khazrak_one_eye_the_dark_mail_stage_5_hint_Graktar_is_dead");




