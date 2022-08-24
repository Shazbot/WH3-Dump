load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	true,                                      	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);
--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, play_taunt_at_start, message_on_start)
gc:add_element(nil, nil, "qb_louen_errantry_war_chaos_01", 6000, true, false, false);
gc:add_element("Nor_Throgg_QB_Wintertooth_Crown_pt_01","Nor_Throgg_QB_Wintertooth_Crown_pt_01", nil, 10000, true, false, false);
gc:add_element("Nor_Throgg_QB_Wintertooth_Crown_pt_02","Nor_Throgg_QB_Wintertooth_Crown_pt_02", "qb_louen_errantry_war_chaos_03", 6000, true, false, false);
gc:add_element("Nor_Throgg_QB_Wintertooth_Crown_pt_03","Nor_Throgg_QB_Wintertooth_Crown_pt_03", nil, 11000, true, true, false);
--gc:add_element(nil, nil, "qb_final_position", 3000, false, false, false);
gb:set_cutscene_during_deployment(true);

-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num());	
ga_ai_dwarfs_01 = gb:get_army(gb:get_non_player_alliance_num(), "First");
ga_ai_dwarfs_02 = gb:get_army(gb:get_non_player_alliance_num(), "Second");
ga_ai_dwarfs_03 = gb:get_army(gb:get_non_player_alliance_num(), "Third");
ga_ai_dwarfs_04 = gb:get_army(gb:get_non_player_alliance_num(), "Fourth");
ga_ai_dwarfs_05 = gb:get_army(gb:get_non_player_alliance_num(), "Fifth");

ga_ai_dwarfs_02:get_army():suppress_reinforcement_adc(); 

-------OBJECTIVES-------
gb:queue_help_on_message("battle_started", "wh_dlc08_qb_nor_throgg_wintertooth_crown_01");
gb:queue_help_on_message("rangers_spotted", "wh_dlc08_qb_nor_throgg_wintertooth_crown_02");
gb:queue_help_on_message("slayers_advance", "wh_dlc08_qb_nor_throgg_wintertooth_crown_03");
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_attack_defeat_army");

-------ORDERS-------

-- Dwarfs defend hill
ga_ai_dwarfs_01:defend_on_message("battle_started",138, -87, 70);
ga_ai_dwarfs_01:message_on_proximity_to_enemy("player_approach",100);
ga_ai_dwarfs_01:release_on_message("player_approach");

-- Automatically spawned ranger reinforcements, could appear in a variety of places due to player options
ga_ai_dwarfs_02:reinforce_on_message("battle_started");
ga_ai_dwarfs_02:message_on_any_deployed("rangers_advance"); 
ga_ai_dwarfs_02:attack_on_message("rangers_advance");
ga_ai_dwarfs_02:message_on_seen_by_enemy("rangers_spotted", 5000); 
ga_ai_dwarfs_02:message_on_proximity_to_enemy("rangers_engaged",100);
ga_ai_dwarfs_02:release_on_message("rangers_engaged");

-- Slayer King + Slayers reinforce from behind enemy position as they take damage
ga_ai_dwarfs_01:message_on_casualties("slayers_alerted", 0.1);
ga_ai_dwarfs_03:reinforce_on_message("slayers_alerted");
ga_ai_dwarfs_03:message_on_any_deployed("slayers_advance"); 
ga_ai_dwarfs_03:attack_on_message("slayers_advance");
ga_ai_dwarfs_03:message_on_proximity_to_enemy("slayers_engaged",160);
ga_ai_dwarfs_03:release_on_message("slayers_engaged");

-- Small group of rangers spawn if the player pushes down the northern flank, and will spawn regardless once the main dwarf force is engaged
ga_player_01:message_on_proximity_to_position("north_rangers_alerted", v(-137, 28, 250), 160); 
ga_ai_dwarfs_04:reinforce_on_message("north_rangers_alerted",250);
ga_ai_dwarfs_04:message_on_any_deployed("north_rangers_advance");
ga_ai_dwarfs_04:attack_on_message("north_rangers_advance");
ga_ai_dwarfs_04:message_on_proximity_to_enemy("north_rangers_engaged",100);
ga_ai_dwarfs_04:release_on_message("north_rangers_engaged");
ga_ai_dwarfs_04:reinforce_on_message("slayers_alerted");

-- Small group of rangers spawn if the player pushes down the southern flank, and will spawn regardless once the main dwarf force is engaged
ga_player_01:message_on_proximity_to_position("south_rangers_alerted", v(52, 36, -343), 160); 
ga_ai_dwarfs_05:reinforce_on_message("south_rangers_alerted",250);
ga_ai_dwarfs_05:message_on_any_deployed("south_rangers_advance");
ga_ai_dwarfs_05:attack_on_message("south_rangers_advance");
ga_ai_dwarfs_05:message_on_proximity_to_enemy("south_rangers_engaged",100);
ga_ai_dwarfs_05:release_on_message("south_rangers_engaged");
ga_ai_dwarfs_05:reinforce_on_message("slayers_alerted");