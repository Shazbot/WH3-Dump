load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);

--gc:add_element(nil,nil, "gc_orbit_360_slow_commander_front_right_close_low_01", 4000, false, false, false);
gc:add_element(nil,nil, "gc_orbit_ccw_90_medium_commander_back_right_extreme_high_01", 5000, false, false, false);
gc:add_element("wh_dlc05_qb_wef_durthu_daiths_sword_stage_3_pt_01","wh_dlc05_qb_wef_durthu_daiths_sword_stage_3_pt_01",nil, 10700, false, false, false);
gc:add_element(nil,nil, "gc_orbit_360_slow_ground_offset_north_east_extreme_high_02", 5700, false, false, false);
gc:add_element(nil,nil, "gc_medium_enemy_army_pan_front_right_to_front_left_far_high_01", 6000, false, false, false);
gc:add_element("wh_dlc05_qb_wef_durthu_daiths_sword_stage_3_pt_02","wh_dlc05_qb_wef_durthu_daiths_sword_stage_3_pt_02",nil, 10800, false, false, false);
gc:add_element(nil,nil, "gc_orbit_90_medium_commander_back_left_extreme_high_01", 4800, false, false, false);
gc:add_element("wh_dlc05_qb_wef_durthu_daiths_sword_stage_3_pt_03", "wh_dlc05_qb_wef_durthu_daiths_sword_stage_3_pt_03", "gc_orbit_90_medium_commander_front_close_low_01", 9100, false, false, false);

gb:set_cutscene_during_deployment(true);
---------------------------
----HARD SCRIPT VERSION----
---------------------------

gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_attack_defeat_army");
-------ARMY SETUP-------

ga_player_01 = gb:get_army(gb:get_player_alliance_num(0), 1);
ga_player_ally = gb:get_army(gb:get_player_alliance_num(0), 2);	
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(1), 1);
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(1), 2);


-------OBJECTIVES-------
gb:queue_help_on_message("battle_started", "wh_dlc05_qb_wef_durthu_daiths_sword_stage_3_hint_objective");
gb:queue_help_on_message("cavelry_arrived", "wh_dlc05_qb_wef_durthu_daiths_sword_stage_3_hint_ally_dead");


-------ORDERS-------

gb:message_on_time_offset("start_ambush", 10000);
ga_ai_01:attack_on_message("start_ambush");
ga_ai_01:message_on_casualties("human_hurt",0.5);
ga_player_ally:message_on_casualties("cavelry_arrived",0.7);
ga_ai_02:reinforce_on_message("cavelry_arrived");
ga_ai_02:reinforce_on_message("human_hurt");




