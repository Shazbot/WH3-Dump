-- Mannfred Von Carstein, Armour of Templehof Stage 6, Burial Mound, Attacker
load_script_libraries();

m = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "gc_orbit_90_medium_ground_offset_north_west_extreme_high_02", 4000, false, false, false);
gc:add_element("wh_qbattle_prelude_armour_of_templehof_2_pt_01_rev_15_02", "wh_main_qb_vmp_mannfred_von_carstein_armour_of_templehof_stage_6_pt_01", "gc_orbit_90_medium_commander_back_right_close_low_01", 4000, true, false, false);
gc:add_element("wh_qbattle_prelude_armour_of_templehof_2_pt_02_rev_15_02", "wh_main_qb_vmp_mannfred_von_carstein_armour_of_templehof_stage_6_pt_02", "gc_slow_army_pan_back_left_to_back_right_close_medium_01", 4000, true, false, false);
gc:add_element("wh_qbattle_prelude_armour_of_templehof_2_pt_03_rev_15_02", "wh_main_qb_vmp_mannfred_von_carstein_armour_of_templehof_stage_6_pt_03", "gc_orbit_90_medium_commander_front_right_close_low_01", 4000, true, false, false);

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
gb:queue_help_on_message("battle_started", "wh_main_qb_vmp_mannfred_von_carstein_armour_of_templehof_stage_6_hint_objective");

-------ORDERS-------
ga_ai_02:attack_on_message("battle_started");
ga_ai_03:attack_on_message("battle_started");