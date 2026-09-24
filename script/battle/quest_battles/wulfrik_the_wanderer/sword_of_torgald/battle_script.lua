load_script_libraries();

local gc = generated_cutscene:new(true, true);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	true,                                      	-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      	-- debug mode
);
--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, play_taunt_at_start, message_on_start)
gc:add_element(nil, nil, "qb_louen_errantry_war_chaos_01", 6000, true, false, false);
gc:add_element("Nor_Wulfrik_QB_Sword_of_Torgald_pt_01","Nor_Wulfrik_QB_Sword_of_Torgald_pt_01", nil, 6000, false, false, false);
gc:add_element("Nor_Wulfrik_QB_Sword_of_Torgald_pt_02","Nor_Wulfrik_QB_Sword_of_Torgald_pt_02", "qb_louen_errantry_war_chaos_03", 8000, true, false, false);
gc:add_element("Nor_Wulfrik_QB_Sword_of_Torgald_pt_03","Nor_Wulfrik_QB_Sword_of_Torgald_pt_03", nil, 6000, true, false, false);
gc:add_element("Nor_Wulfrik_QB_Sword_of_Torgald_pt_04","Nor_Wulfrik_QB_Sword_of_Torgald_pt_04", nil, 5000, true, false, false);
gc:add_element(nil, nil, "qb_final_position", 3000, false, false, false);

gb:set_cutscene_during_deployment(true);

-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);	
ga_ai_bret_01 = gb:get_army(gb:get_non_player_alliance_num(), 1, "First");
ga_ai_bret_02 = gb:get_army(gb:get_non_player_alliance_num(), 2, "Second");
ga_ai_bret_03 = gb:get_army(gb:get_non_player_alliance_num(), 2, "Third");
ga_ai_bret_04 = gb:get_army(gb:get_non_player_alliance_num(), 3, "Fourth");
ga_ai_bret_05 = gb:get_army(gb:get_non_player_alliance_num(), 3, "Fifth");

-------OBJECTIVES-------
gb:queue_help_on_message("battle_started", "wh_dlc08_qb_nor_wulfrik_sword_of_torgald_01");
gb:queue_help_on_message("archers_advance", "wh_dlc08_qb_nor_wulfrik_sword_of_torgald_02");
gb:queue_help_on_message("militia_advance", "wh_dlc08_qb_nor_wulfrik_sword_of_torgald_03");
gb:queue_help_on_message("knights_advance", "wh_dlc08_qb_nor_wulfrik_sword_of_torgald_04");
gb:queue_help_on_message("green_knight_advance", "wh_dlc08_qb_nor_wulfrik_sword_of_torgald_05");
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_attack_defeat_army");

-------ORDERS-------
ga_player_01:message_on_proximity_to_enemy("archers_alerted",180);
ga_player_01:message_on_proximity_to_enemy("militia_alerted",180);
ga_player_01:message_on_proximity_to_enemy("knights_alerted", 180);
ga_player_01:message_on_proximity_to_enemy("green_knight_alerted", 180);

ga_ai_bret_01:release_on_message("archers_alerted");
ga_ai_bret_01:message_on_proximity_to_enemy("under_attack",30);
ga_ai_bret_01:rush_on_message("under_attack");

ga_ai_bret_02:reinforce_on_message("archers_alerted", 30000);
ga_ai_bret_02:message_on_any_deployed("archers_advance"); 
ga_ai_bret_02:rush_on_message("archers_advance");

ga_ai_bret_03:reinforce_on_message("militia_alerted", 120000);
ga_ai_bret_03:message_on_any_deployed("militia_advance"); 
ga_ai_bret_03:rush_on_message("militia_advance");

ga_ai_bret_04:reinforce_on_message("knights_alerted", 300000);
ga_ai_bret_04:message_on_any_deployed("knights_advance"); 
ga_ai_bret_04:rush_on_message("knights_advance");

ga_ai_bret_05:reinforce_on_message("green_knight_alerted", 360000);
ga_ai_bret_05:message_on_any_deployed("green_knight_advance"); 
ga_ai_bret_05:rush_on_message("green_knight_advance");