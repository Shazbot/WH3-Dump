-- Prince Sigvald, Auric Armour, Defender
load_script_libraries();

m = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "gc_medium_absolute_golden_monolith_01_02", 4000, false, false, false);
gc:add_element("CHAOS_Sig_GS_Qbattle_auric_armour_pt_01", "wh_dlc01_qb_chs_prince_sigvald_auric_armour_stage_3_pt_01", nil, 4000, true, false, false);
gc:add_element("CHAOS_Sig_GS_Qbattle_auric_armour_pt_02", "wh_dlc01_qb_chs_prince_sigvald_auric_armour_stage_3_pt_02", "gc_medium_army_pan_front_left_to_right_medium_low_01", 4000, true, false, false);
gc:add_element("CHAOS_Sig_GS_Qbattle_auric_armour_pt_03", "wh_dlc01_qb_chs_prince_sigvald_auric_armour_stage_3_pt_03", "gc_orbit_ccw_90_medium_commander_front_right_close_low_01", 4000, true, false, false);
gc:add_element("CHAOS_Sig_GS_Qbattle_auric_armour_pt_04", "wh_dlc01_qb_chs_prince_sigvald_auric_armour_stage_3_pt_04", "gc_orbit_90_medium_ground_offset_north_west_extreme_high_02", 4000, true, false, false);
gc:add_element("CHAOS_Sig_GS_Qbattle_auric_armour_pt_05", "wh_dlc01_qb_chs_prince_sigvald_auric_armour_stage_3_pt_05", "gc_orbit_ccw_90_medium_commander_back_right_extreme_high_01", 4000, true, false, false);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);

gb:set_cutscene_during_deployment(true);



-------GENERALS SPEECH--------


-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), 1);
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), 2);
ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(), 3);


-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_defend_defeat_army");

-------HINTS-------
gb:queue_help_on_message("battle_started", "wh_dlc01_qb_chs_prince_sigvald_auric_armour_stage_3_hint_objective");

-------ORDERS-------

ga_ai_01:message_on_proximity_to_enemy("oh_heck_he_pretty", 150);
ga_ai_02:reinforce_on_message ("oh_heck_he_pretty", 14000);
ga_ai_03:reinforce_on_message ("oh_heck_he_pretty", 16000);