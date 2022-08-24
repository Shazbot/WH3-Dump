load_script_libraries();

local gc = generated_cutscene:new(true);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil,nil, "gc_medium_absolute_isabella_shadow_forest_0", 9000, false, false, false);
gc:add_element("VAMP_Isabella_Von_Carstein_GS_Qbattle_DeadWood_pt_01", "wh_pro02_qb_vmp_isabella_blood_chalice_of_bathori_dead_wood_pt_01", "gc_orbit_ccw_360_slow_commander_back_right_close_low_01", 12000, false, false, false);
gc:add_element("VAMP_Isabella_Von_Carstein_GS_Qbattle_DeadWood_pt_02", "wh_pro02_qb_vmp_isabella_blood_chalice_of_bathori_dead_wood_pt_02", "gc_medium_absolute_isabella_shadow_forest_1", 6700, false, false, false);
gc:add_element("VAMP_Isabella_Von_Carstein_GS_Qbattle_DeadWood_pt_03", "wh_pro02_qb_vmp_isabella_blood_chalice_of_bathori_dead_wood_pt_03", "gc_medium_absolute_isabella_shadow_forest_2", 12000, false, false, false);
gc:add_element("VAMP_Isabella_Von_Carstein_GS_Qbattle_DeadWood_pt_04", "wh_pro02_qb_vmp_isabella_blood_chalice_of_bathori_dead_wood_pt_04", "gc_orbit_ccw_360_slow_commander_back_right_close_low_01", 10000, true, true, false);

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


-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);	
ga_ai_01= gb:get_army(gb:get_non_player_alliance_num(), 1);	






-------OBJECTIVES-------

gb:queue_help_on_message("battle_started", "wh_pro02_qb_vmp_isabella_von_carstein_blood_chalice_of_bathori_stage_3_hint_objective");

-------ORDERS-------

ga_ai_01:attack_on_message("battle_started");




