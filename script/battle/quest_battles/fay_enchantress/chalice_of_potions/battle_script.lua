load_script_libraries();

local gc = generated_cutscene:new(true);


--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, taunt)
gc:add_element(nil, nil, "gc_medium_absolute_reikland_skull_pan_01_to_absolute_reikland_skull_pan_02", 16700, true, false, false);
gc:add_element("wh_dlc07_qb_Bret_Faye_Chalice_of_Potions_PT1", "wh_dlc07_qb_brt_fay_enchantress_chalice_of_potions_pt_01", nil, 16700, false, false, false);
gc:add_element("wh_dlc07_qb_Bret_Faye_Chalice_of_Potions_PT2", "wh_dlc07_qb_brt_fay_enchantress_chalice_of_potions_pt_02", "gc_medium_enemy_army_pan_front_left_to_front_right_medium_medium_02", 7000, false, false, true);
gc:add_element("wh_dlc07_qb_Bret_Faye_Chalice_of_Potions_PT3", "wh_dlc07_qb_brt_fay_enchantress_chalice_of_potions_pt_03", "gc_orbit_ccw_360_slow_commander_front_right_close_low_01", 6000, false, false, false);
gc:add_element(nil, nil, "gc_medium_absolute_reikland_distant_pan_01_to_absolute_reikland_distant_pan_02", 4000, true, false, true);

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
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_defend_defeat_army");

-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);	
ga_ai_01= gb:get_army(gb:get_non_player_alliance_num(), 1);	
ga_ai_02= gb:get_army(gb:get_non_player_alliance_num(), 2);
ga_ai_03= gb:get_army(gb:get_non_player_alliance_num(), 3);






-------OBJECTIVES-------

gb:queue_help_on_message("battle_started", "wh_dlc07_qb_brt_fay_enchantress_chalice_of_potions_01");
gb:queue_help_on_message("second_wave", "wh_dlc07_qb_brt_fay_enchantress_chalice_of_potions_02");
gb:queue_help_on_message("third_wave", "wh_dlc07_qb_brt_fay_enchantress_chalice_of_potions_03");

-------ORDERS-------

ga_ai_02:reinforce_on_message("battle_started",120000);
ga_ai_03:reinforce_on_message("battle_started",240000);
ga_ai_02:message_on_any_deployed("second_wave");
ga_ai_03:message_on_any_deployed("third_wave");






