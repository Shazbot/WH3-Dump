load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);

gc:add_element(nil,nil, "gc_orbit_90_medium_commander_front_close_low_01", 4000, false, false, false);
gc:add_element("wh_dlc05_qb_wef_orion_horn_of_the_wild_hunt_pt_01","wh_dlc05_qb_wef_orion_horn_of_the_wild_hunt_pt_01",nil, 8600, false, false, false);
gc:add_element(nil,nil, "gc_medium_enemy_army_pan_front_left_to_front_right_medium_medium_01", 4600, false, false, false);
gc:add_element("wh_dlc05_qb_wef_orion_horn_of_the_wild_hunt_pt_02","wh_dlc05_qb_wef_orion_horn_of_the_wild_hunt_pt_02", "gc_orbit_ccw_360_slow_ground_offset_north_west_extreme_high_02", 8700, false, false, false);
gc:add_element(nil,nil, "gc_orbit_90_medium_commander_back_left_extreme_high_01", 7000, false, false, false);
gc:add_element("wh_dlc05_qb_wef_orion_horn_of_the_wild_hunt_pt_03","wh_dlc05_qb_wef_orion_horn_of_the_wild_hunt_pt_03",nil, 15000, false, false, false);
gc:add_element(nil,nil, "gc_orbit_90_medium_commander_front_close_low_01", 8000, false, false, false);

gb:set_cutscene_during_deployment(true);
---------------------------
----HARD SCRIPT VERSION----
---------------------------

-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_attack_defeat_army");

-------HINTS-------
gb:queue_help_on_message("battle_started", "wh_dlc05_qb_wef_orion_horn_of_the_wild_stage_3_hint_objective");
gb:queue_help_on_message("monsters_are_dead", "wh_dlc05_qb_wef_orion_horn_of_the_wild_stage_3_hint_reinforcement");

gb:queue_help_on_message("1", "wh_dlc05_qb_wef_orion_horn_of_the_wild_stage_3_hint_unique_mechanism_0");
gb:queue_help_on_message("2", "wh_dlc05_qb_wef_orion_horn_of_the_wild_stage_3_hint_unique_mechanism_1");
gb:queue_help_on_message("3", "wh_dlc05_qb_wef_orion_horn_of_the_wild_stage_3_hint_unique_mechanism_2");

gb:queue_help_on_message("4", "wh_dlc05_qb_wef_orion_horn_of_the_wild_stage_3_hint_unique_mechanism_3");
-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(0), 1);		
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(1), 1);
ga_ai_guard = gb:get_army(gb:get_non_player_alliance_num(1), 1,"guardians");
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(1), 2);




-------OBJECTIVES-------



-------ORDERS-------
gb:message_on_time_offset("1", 60000);
gb:message_on_time_offset("2", 300000);
gb:message_on_time_offset("3", 630000);
ga_ai_guard:halt();
ga_ai_guard:message_on_under_attack("charge2");
ga_ai_guard:message_on_proximity_to_enemy("charge2", 100);
ga_ai_guard:attack_on_message("charge2",10000);
ga_ai_01:message_on_casualties("monsters_are_dead", 0.4); 
ga_ai_02:reinforce_on_message("monsters_are_dead",10000);
ga_ai_guard:message_on_commander_dead_or_routing("4");


