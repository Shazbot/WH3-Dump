load_script_libraries();

local gc = generated_cutscene:new(true);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil,nil, "gc_medium_absolute_stir_river_0", 5000, false, false, false);
gc:add_element("Play_wh_dlc03_qb_bst_malagor_the_dark_omen_the_icons_of_vilification_stage_6_the_stir_river_pt_01","wh_dlc03_qb_bst_malagor_the_dark_omen_the_icons_of_vilification_stage_6_the_stir_river_pt_01", nil, 1000, false, false, false);
gc:add_element(nil, nil, nil, 4000, false, false, false);
gc:add_element("Play_wh_dlc03_qb_bst_malagor_the_dark_omen_the_icons_of_vilification_stage_6_the_stir_river_pt_02", "wh_dlc03_qb_bst_malagor_the_dark_omen_the_icons_of_vilification_stage_6_the_stir_river_pt_02", nil, 8500, false, false, false);
gc:add_element("Play_wh_dlc03_qb_bst_malagor_the_dark_omen_the_icons_of_vilification_stage_6_the_stir_river_pt_03", "wh_dlc03_qb_bst_malagor_the_dark_omen_the_icons_of_vilification_stage_6_the_stir_river_pt_03", "gc_medium_absolute_stir_river_1", 5500, false, false, false);
gc:add_element(nil, nil, "gc_orbit_90_medium_commander_front_left_extreme_high_01", 2500, false, false, false);
gc:add_element("wh_dlc03_qb_bst_malagor_the_dark_omen_the_icons_of_vilification_stage_6_the_stir_river_pt_04", "wh_dlc03_qb_bst_malagor_the_dark_omen_the_icons_of_vilification_stage_6_the_stir_river_pt_04", "gc_orbit_ccw_90_medium_commander_front_left_close_low_01", 5000, false, false, false);
gc:add_element(nil,nil, nil, 2000, true, true, false);
--gc:add_element(nil, nil, "gc_fast_commander_back_medium_medium_to_close_low_01", 400, false, true, false);

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

--ga_ai_02 = gb:get_army(gb:get_non_player_alliance(), 2);
ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(), 2);
ga_ai_04 = gb:get_army(gb:get_non_player_alliance_num(), 3);




-------OBJECTIVES-------

gb:queue_help_on_message("battle_started", "wh_dlc03_qb_bst_malagor_the_dark_omen_icon_of_vilification_stage_5_hint_objective");

-------ORDERS-------

gb:message_on_time_offset("start_ambush", 10000);
gb:message_on_time_offset("reinforce_1", 195000);
ga_ai_01:message_on_casualties("reinforce_1",0.9);
gb:message_on_time_offset("reinforce_2", 300000);
ga_ai_03:message_on_casualties("reinforce_2",0.9);
--gb:message_on_time_offset("cannons_in", 190000);
ga_ai_01:attack_on_message("battle_started");
--ga_ai_01:attack_on_message("start_ambush");
--ga_ai_02:reinforce_on_message("start_ambush",70000);
ga_ai_03:reinforce_on_message("reinforce_1",100);
ga_ai_04:reinforce_on_message("reinforce_2",100);
gb:queue_help_on_message("reinforce_1", "wh_dlc03_qb_bst_malagor_the_dark_omen_icon_of_vilification_stage_5_hint_reinforcements_01");
gb:queue_help_on_message("reinforce_2", "wh_dlc03_qb_bst_malagor_the_dark_omen_icon_of_vilification_stage_5_hint_reinforcements_02");



