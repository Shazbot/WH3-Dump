load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);

	gc:add_element(nil, nil, "gc_medium_absolute_death_pass_00", 12000, false, false, false);
	gc:add_element("Play_wh_dlc06_qb_grn_skarsnik_skarsniks_prodder_stage_3_pt_01", "wh_dlc06_qb_grn_skarsnik_skarsniks_prodder_stage_3_pt_01", nil, 5720, false, false, false);
	gc:add_element("Play_wh_dlc06_qb_grn_skarsnik_skarsniks_prodder_stage_3_pt_02", "wh_dlc06_qb_grn_skarsnik_skarsniks_prodder_stage_3_pt_02", "gc_medium_absolute_death_pass_01", 12280, false, false, false);
	gc:add_element("Play_wh_dlc06_qb_grn_skarsnik_skarsniks_prodder_stage_3_pt_03", "wh_dlc06_qb_grn_skarsnik_skarsniks_prodder_stage_3_pt_03", nil, 2000, false, false, false);
	gc:add_element(nil, nil, "gc_orbit_90_medium_commander_front_left_extreme_high_01", 6400, false, false, false);
	gc:add_element("Play_wh_dlc06_qb_grn_skarsnik_skarsniks_prodder_stage_3_pt_04", "wh_dlc06_qb_grn_skarsnik_skarsniks_prodder_stage_3_pt_04", "gc_orbit_ccw_90_medium_commander_front_close_low_01", 2430, false, false, false);
	gc:add_element(nil,nil, nil, 4000, true, true, false);

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
gb:queue_help_on_message("battle_started", "wh_dlc06_qb_grn_skarsnik_skarsniks_prodder_stage_3_hint_objective");
gb:queue_help_on_message("wave_arrive", "wh_dlc06_qb_grn_skarsnik_skarsniks_prodder_stage_3_hint_reinforcement");


-------ORDERS-------


gb:message_on_time_offset("start_ambush", 1);

ga_ai_01:message_on_casualties("monsters_are_dead", 0.7); 
ga_ai_02:reinforce_on_message("monsters_are_dead",50000);
ga_ai_02:message_on_deployed("wave_arrive"); 





