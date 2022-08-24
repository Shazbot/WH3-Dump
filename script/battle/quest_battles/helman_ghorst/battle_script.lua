load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);


gc:add_element(nil, nil, "gc_medium_absolute_liber_noctus_00", 7000, false, false, false);
gc:add_element("Play_wh_dlc04_qb_vmp_helman_ghorst_liber_noctus_stage_6_pt_01", "wh_dlc04_qb_vmp_helman_ghorst_liber_noctus_stage_6_pt_01", nil, 8000, false, false, false);
gc:add_element(nil,nil, "gc_medium_absolute_liber_noctus_01", 5000, false, false, false);
gc:add_element("Play_wh_dlc04_qb_vmp_helman_ghorst_liber_noctus_stage_6_pt_02", "wh_dlc04_qb_vmp_helman_ghorst_liber_noctus_stage_6_pt_02", nil, 5500, false, false, false);
gc:add_element("Play_wh_dlc04_qb_vmp_helman_ghorst_liber_noctus_stage_6_pt_03", "wh_dlc04_qb_vmp_helman_ghorst_liber_noctus_stage_6_pt_03", "gc_orbit_90_medium_commander_front_left_extreme_high_01", 6000, false, false, false);
gc:add_element(nil, nil, "gc_orbit_ccw_90_medium_commander_front_close_low_01", 6000, false, false, false);
gc:add_element(nil,nil, nil, 3000, true, true, false);


gb:set_cutscene_during_deployment(true);

---------------------------
----HARD SCRIPT VERSION----
---------------------------
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_attack_defeat_army");
gb:queue_help_on_message("battle_started", "wh_dlc04_qb_vmp_helman_ghorst_liber_noctus_hint_objective");
gb:queue_help_on_message("reinforced", "wh_dlc04_qb_vmp_helman_ghorst_liber_noctus_hint_reinforcements");

-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(0), 1);		
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(1), 1);
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(1), 2);
ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(1), 3);




-------OBJECTIVES-------



-------ORDERS-------

gb:message_on_time_offset("start_ambush", 1000);
ga_ai_01:message_on_proximity_to_enemy("charge", 300);
ga_ai_01:message_on_under_attack("charge");
ga_ai_02:attack_on_message("charge");
ga_ai_02:reinforce_on_message("charge",70000);
ga_ai_03:reinforce_on_message("charge",95000);
ga_ai_01:message_on_casualties("enemy_low",0.8);
ga_ai_02:reinforce_on_message("enemy_low",100);
ga_ai_03:reinforce_on_message("enemy_low",100);
ga_ai_02:message_on_deployed("reinforced");
