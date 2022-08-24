load_script_libraries();

local gc = generated_cutscene:new(true);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "gc_medium_absolute_grimminghagen_castle_to_absolute_grimminghagen_castle_01", 6000, false, false, false);
gc:add_element("Play_wh_dlc03_qb_bst_khazrak_one_eye_scourge_stage_4_slaughter_at_grimminhagen_pt_01", "wh_dlc03_qb_bst_khazrak_one_eye_scourge_stage_4_slaughter_at_grimminhagen_pt_01", "gc_medium_absolute_grimminghagen_castle_01_to_absolute_grimminghagen_castle_02", 4000, false, false, false);
gc:add_element("Play_wh_dlc03_qb_bst_khazrak_one_eye_scourge_stage_4_slaughter_at_grimminhagen_pt_02", "wh_dlc03_qb_bst_khazrak_one_eye_scourge_stage_4_slaughter_at_grimminhagen_pt_02", nil, 5000, false, false, false);
gc:add_element(nil, nil, "gc_medium_absolute_grimminghagen_ambush_01_to_absolute_grimminghagen_ambush_02", 3000, false, false, false);
gc:add_element("Play_wh_dlc03_qb_bst_khazrak_one_eye_scourge_stage_4_slaughter_at_grimminhagen_pt_03", "wh_dlc03_qb_bst_khazrak_one_eye_scourge_stage_4_slaughter_at_grimminhagen_pt_03", nil, 6000, false, false, false);
gc:add_element(nil, nil, "gc_orbit_ccw_90_medium_commander_front_close_low_01", 2500, false, false, false);
gc:add_element(nil,nil, nil, 4000, true, true, false);
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
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_attack_defeat_army_ambush");

-------ARMY SETUP-------
--ga_player_01 = gb:get_army(gb:get_player_alliance(0), 1);		
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), 1);
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), 2);




-------OBJECTIVES-------
gb:queue_help_on_message("battle_started", "wh_dlc03_qb_bst_khazrak_one_eye_scourge_stage_4_hint_objective");


-------ORDERS-------
ga_ai_01:message_on_casualties("summon_reinforcements",0.4);
ga_ai_02:reinforce_on_message("summon_reinforcements");
ga_ai_02:attack_on_message("summon_reinforcements");



