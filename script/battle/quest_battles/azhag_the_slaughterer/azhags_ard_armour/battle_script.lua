--Azhag, Azhag's Ard Armour, Attacker
load_script_libraries();

m = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "gc_orbit_ccw_360_slow_ground_offset_north_west_extreme_high_02", 4000, false, false, false);
gc:add_element("ORC_Azh_GS_Qbattle_Ard_Armour_FULL_REV_17_3", "wh_main_qb_grn_azhag_the_slaughterer_azhags_ard_armour_stage_4_pt_01n", nil, 13600, false, false, false);
gc:add_element(nil, "wh_main_qb_grn_azhag_the_slaughterer_azhags_ard_armour_stage_4_pt_02n", "gc_slow_commander_front_medium_medium_to_close_low_01", 4000, false, false, false);
gc:add_element(nil, "wh_main_qb_grn_azhag_the_slaughterer_azhags_ard_armour_stage_4_pt_03n", "gc_orbit_90_medium_commander_back_left_extreme_high_01", 20200, false, false, false);
gc:add_element(nil, "wh_main_qb_grn_azhag_the_slaughterer_azhags_ard_armour_stage_4_pt_04n", "gc_slow_commander_front_medium_medium_to_close_low_01", 4700, false, false, false);
gc:add_element(nil, "wh_main_qb_grn_azhag_the_slaughterer_azhags_ard_armour_stage_4_pt_05n", nil, 4000, true, false, false);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);
gb:set_cutscene_during_deployment(true);

-------ARMY SETUP-------
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army");
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_reinforcements_1");
ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_reinforcements_2");

-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_attack_defeat_army");

-------HINTS-------
gb:queue_help_on_message("battle_started", "wh_main_qb_grn_azhag_the_slaughterer_azhags_ard_armour_stage_4_hint_objective");

-------ORDERS-------
ga_ai_02:attack_on_message("battle_started");
ga_ai_03:attack_on_message("battle_started");