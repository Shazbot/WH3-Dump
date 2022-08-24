--Ungrim, Slayer Crown 4, Attacker, Leitzeger Ford
load_script_libraries();

m = battle_manager:new(empire_battle:new());

local gc = generated_cutscene:new(true);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "gc_medium_absolute_leitzeger_graveyard_01_to_absolute_leitzeger_graveyard_02", 4000, false, false, false);
gc:add_element("DWF_Un_GS_Qbattle_slayer_crown1_pt_01", "wh_main_qb_dwf_ungrim_ironfist_slayer_crown_stage_4_pt_01", nil, 4000, true, false, false);
gc:add_element("DWF_Un_GS_Qbattle_slayer_crown1_pt_02", "wh_main_qb_dwf_ungrim_ironfist_slayer_crown_stage_4_pt_02", "gc_medium_absolute_leitzeger_shrine_01_to_absolute_leitzeger_shrine_02", 4000, true, false, false);
gc:add_element("DWF_Un_GS_Qbattle_slayer_crown1_pt_03", "wh_main_qb_dwf_ungrim_ironfist_slayer_crown_stage_4_pt_03", nil, 4000, true, false, false);
gc:add_element("DWF_Un_GS_Qbattle_slayer_crown1_pt_04", "wh_main_qb_dwf_ungrim_ironfist_slayer_crown_stage_4_pt_04", "gc_orbit_360_slow_commander_front_left_close_low_01", 4000, true, false, false);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);

gb:set_cutscene_during_deployment(true);

---Ungrim vs 3 Vamp armies

-------GENERALS SPEECH--------

-------ARMY SETUP-------
--ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);

ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), 1);

-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh_main_qb_dwf_ungrim_ironfist_slayer_crown_main_objective");

-------HINTS-------
gb:queue_help_on_message("battle_started", "wh_main_qb_dwf_ungrim_ironfist_slayer_crown_stage_4_hint_objective");

-------ORDERS-------

