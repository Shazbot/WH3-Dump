load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);


gc:add_element(nil, nil, "gc_medium_absolute_warpstone_mine_00", 4000, false, false, false);
gc:add_element("Play_wh_dlc04_qb_vmp_vlad_von_carstein_the_carstein_ring_stage_5_pt_01", "wh_dlc04_qb_vmp_vlad_von_carstein_the_carstein_ring_stage_5_pt_01", nil, 11300, false, false, false);
gc:add_element("Play_wh_dlc04_qb_vmp_vlad_von_carstein_the_carstein_ring_stage_5_pt_02", "wh_dlc04_qb_vmp_vlad_von_carstein_the_carstein_ring_stage_5_pt_02", "gc_medium_absolute_warpstone_mine_01", 6700, false, false, false);
gc:add_element("Play_wh_dlc04_qb_vmp_vlad_von_carstein_the_carstein_ring_stage_5_pt_03", "wh_dlc04_qb_vmp_vlad_von_carstein_the_carstein_ring_stage_5_pt_03", nil, 7900, false, false, false);
--gc:add_element(nil, nil, "gc_orbit_90_medium_commander_front_left_extreme_high_01", 3000, false, false, false)
gc:add_element("Play_wh_dlc04_qb_vmp_vlad_von_carstein_the_carstein_ring_stage_5_pt_04", "wh_dlc04_qb_vmp_vlad_von_carstein_the_carstein_ring_stage_5_pt_04", "gc_orbit_ccw_90_medium_commander_front_close_low_01", 5000, false, false, false);
gc:add_element(nil,nil, nil, 3000, true, true, false);


gb:set_cutscene_during_deployment(true);

---------------------------
----HARD SCRIPT VERSION----
---------------------------
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_attack_defeat_army");
gb:queue_help_on_message("battle_started", "wh_dlc04_qb_vmp_vlad_von_carstein_ring_hint_objective");
gb:queue_help_on_message("minions_dead", "wh_dlc04_qb_vmp_vlad_von_carstein_ring_hint_prolonged_combat");


-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(0), 1);		
ga_ai_strigoi = gb:get_army(gb:get_non_player_alliance_num(1), 1,"strigoi");
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(1), 1,"minions");
--ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(1), 3);




-------OBJECTIVES-------



-------ORDERS-------

gb:message_on_time_offset("start_ambush", 1000);
ga_ai_strigoi:halt();
ga_ai_01:halt();
ga_ai_strigoi:message_on_under_attack("charge");
ga_ai_strigoi:message_on_proximity_to_enemy("charge2", 100);
ga_ai_01:message_on_casualties("minions_dead",0.2);
ga_ai_01:message_on_proximity_to_enemy("charge", 400);
ga_ai_01:message_on_under_attack("charge");
ga_ai_01:attack_on_message("charge");
ga_ai_strigoi:attack_on_message("charge2",10000);

