-- Ungrim, Axe of Dargo, Defending, High Pass
load_script_libraries();

m = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, play taunt)
gc:add_element(nil, nil, "gc_orbit_90_medium_ground_offset_north_east_extreme_high_02", 4000, false, false, false);
gc:add_element("DWF_Un_GS_Qbattle_axe_dargo_pt_01", "wh_main_qb_dwf_ungrim_ironfist_axe_of_dargo_stage_4_pt_01", "gc_orbit_90_medium_commander_back_right_close_low_01", 4000, true, false, true);
gc:add_element("DWF_Un_GS_Qbattle_axe_dargo_pt_02", "wh_main_qb_dwf_ungrim_ironfist_axe_of_dargo_stage_4_pt_02", "gc_slow_absolute_high_pass_statues_01_to_absolute_high_pass_statues_02", 4000, true, false, false);
gc:add_element("DWF_Un_GS_Qbattle_axe_dargo_pt_03", "wh_main_qb_dwf_ungrim_ironfist_axe_of_dargo_stage_4_pt_03", nil, 4000, true, false, false);
gc:add_element("DWF_Un_GS_Qbattle_axe_dargo_pt_04", "wh_main_qb_dwf_ungrim_ironfist_axe_of_dargo_stage_4_pt_04", "gc_medium_army_pan_front_right_to_front_left_far_high_01", 4000, true, false, false);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	true,                                      	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);

gb:set_cutscene_during_deployment(true);

-- Ungrim vs invading Chaos
-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);

ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), 1);
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), 2);


-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh_main_qb_dwf_ungrim_ironfist_axe_of_dargo_main_objective");


-------HINTS-------
gb:queue_help_on_message("battle_started", "wh_main_qb_dwf_ungrim_ironfist_axe_of_dargo_hint_objective");

gb:play_sound_on_message("battle_started", new_sfx("Play_DWF_Un_Qbattle_axe_dargo_extra_in_battle"), nil, 260000);
gb:queue_help_on_message("battle_started", "wh_main_qb_dwf_ungrim_ironfist_axe_of_dargo_stage_4_extra", 13000, 2000, 260000);

-------ORDERS-------
ga_ai_01:release_on_message("battle_started");
ga_ai_02:release_on_message("battle_started");
ga_ai_02:reinforce_on_message("battle_started", 260000);