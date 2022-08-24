-- Grimgor Ironhide,Blood forged armour stage 2, Attacker
load_script_libraries();

m = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true, true);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "gc_medium_absolute_broken_leg", 4000, false, false, false);
gc:add_element("ORC_Grim_GS_Qbattle_blood_forged_armour1_pt_01", "wh_main_qb_grn_grimgor_ironhide_blood_forged_armour_stage_2_pt_01", nil, 4000, true, false, false);
gc:add_element("ORC_Grim_GS_Qbattle_blood_forged_armour1_pt_02", "wh_main_qb_grn_grimgor_ironhide_blood_forged_armour_stage_2_pt_02", "gc_slow_army_pan_front_left_to_front_right_far_high_01", 4000, true, false, false);
gc:add_element("ORC_Grim_GS_Qbattle_blood_forged_armour1_pt_03", "wh_main_qb_grn_grimgor_ironhide_blood_forged_armour_stage_2_pt_03", "qb_final_position", 4000, true, false, false);


gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);

gb:set_cutscene_during_deployment(true);

-- Grimgor vs dwarfen defenders
-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);

ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), 1);
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), 1);

ga_ai_02:get_army():suppress_reinforcement_adc();

ga_ai_01:release_on_message("battle_started");
ga_ai_02:release_on_message("battle_started", 5000);


-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh_main_qb_grn_grimgor_ironhide_blood_forged_armour_stage_2_main_objective", 6000);


-------HINTS-------
gb:queue_help_on_message("battle_started", "wh_main_qb_grn_grimgor_ironhide_blood_forged_armour_stage_2_hint_objective", 6000, 2000, 1000);

-------ORDERS-------