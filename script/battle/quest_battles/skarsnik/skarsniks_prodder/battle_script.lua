load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);

	gc:add_element(nil, nil, "gc_medium_absolute_lost_vault_00", 3000, false, false, false);
	gc:add_element("Play_wh_dlc06_qb_grn_skarsnik_skarsniks_prodder_stage_5_pt_01", "wh_dlc06_qb_grn_skarsnik_skarsniks_prodder_stage_5_pt_01", nil, 3690, false, false, false);
	gc:add_element(nil, nil, "gc_medium_absolute_lost_vault_02", 7000, false, false, false);
	gc:add_element("Play_wh_dlc06_qb_grn_skarsnik_skarsniks_prodder_stage_5_pt_02", "wh_dlc06_qb_grn_skarsnik_skarsniks_prodder_stage_5_pt_02", "gc_medium_absolute_lost_vault_03", 8960, false, false, false);
	gc:add_element(nil, nil, "gc_orbit_90_medium_commander_front_left_extreme_high_01", 1000, false, false, false);
	gc:add_element("Play_wh_dlc06_qb_grn_skarsnik_skarsniks_prodder_stage_5_pt_03", "wh_dlc06_qb_grn_skarsnik_skarsniks_prodder_stage_5_pt_03", nil, 3520, false, false, false);
	gc:add_element(nil, nil, "gc_orbit_ccw_90_medium_commander_front_close_low_01", 3500, false, false, false);
	gc:add_element(nil,nil, nil, 3000, true, true, false);

gb:set_cutscene_during_deployment(true);


---------------------------
----HARD SCRIPT VERSION----
---------------------------


-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(0), 1);		
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(1), 1);
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(1), 2);






-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_attack_defeat_army");

-------HINTS-------
gb:queue_help_on_message("battle_started", "wh_dlc06_qb_grn_skarsnik_skarsniks_prodder_stage_5_hint_objective");
gb:queue_help_on_message("wave_arrive", "wh_dlc06_qb_grn_skarsnik_skarsniks_prodder_stage_5_hint_reinforcement");


-------ORDERS-------


gb:message_on_time_offset("start_ambush", 1);

ga_ai_01:message_on_casualties("monsters_are_dead", 0.6); 
ga_player_01:message_on_proximity_to_enemy("player_close", 180);
ga_ai_01:attack_on_message("player_close", 100);

ga_ai_02:reinforce_on_message("monsters_are_dead",15000);
ga_ai_02:message_on_deployed("wave_arrive"); 




