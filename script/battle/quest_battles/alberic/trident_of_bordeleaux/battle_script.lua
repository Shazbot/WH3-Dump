load_script_libraries();

local gc = generated_cutscene:new(true);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "wh_dlc07_qb_alberic_trident_of_manann_00", 2500, false, false, false);
gc:add_element("wh_dlc07_qb_Bret_Alberic_Trident_of_Manaan_PT1", "wh_dlc07_qb_brt_alberic_trident_of_manann_pt_01", "wh_dlc07_qb_alberic_trident_of_manann_01", 15000, false, false, false);
gc:add_element("wh_dlc07_qb_Bret_Alberic_Trident_of_Manaan_PT2", "wh_dlc07_qb_brt_alberic_trident_of_manann_pt_02", "wh_dlc07_qb_alberic_trident_of_manann_02", 12000, false, false, false);
gc:add_element("wh_dlc07_qb_Bret_Alberic_Trident_of_Manaan_PT3", "wh_dlc07_qb_brt_alberic_trident_of_manann_pt_03", "wh_dlc07_qb_alberic_trident_of_manann_03", 11000, false, false, false);


gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);


gb:set_cutscene_during_deployment(true);
--ga_ai_01:set_visible_to_all(true);
-- local battle_stage=0;
-- local shape_points={v(45,265),v(45,215),v(-5,215),v(-5,265)};
-- local duel_area=convex_area:new(shape_points);
-- local mountain_line={v(0,0),v(1,1)};
-- local bool_mountain_crossed=false;

---------------------------
----HARD SCRIPT VERSION----
---------------------------
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_attack_defeat_army");

-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);	
ga_ai_01= gb:get_army(gb:get_non_player_alliance_num(), 1);	
ga_ai_02= gb:get_army(gb:get_non_player_alliance_num(), 2);






-------OBJECTIVES-------

gb:queue_help_on_message("battle_started", "wh_dlc07_qb_brt_alberic_trident_of_manann_01");

-------ORDERS-------






