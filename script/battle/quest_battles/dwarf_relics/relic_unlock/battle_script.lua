load_script_libraries();

bm = battle_manager:new(empire_battle:new());

gb = generated_battle:new(
                false,                          -- screen starts black
                false,                          -- prevent deployment for player
                false,                          -- prevent deployment for ai
                nil,      						-- intro cutscene function
                false                           -- debug mode
);

---------------------------
----HARD SCRIPT VERSION----
---------------------------

-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num());
ga_ai_ally = gb:get_army(gb:get_player_alliance_num(), "ally");
ga_ai_start = gb:get_army(gb:get_non_player_alliance_num(), "start");
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), "miners_1");
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), "miners_2");
ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(), "miners_3");

-------OBJECTIVES-------
gb:set_objective_with_leader_on_message("move", "wh3_dlc23_chd_relic_army_uncovered_00");
gb:complete_objective_on_message("main_force_dead", "wh3_dlc23_chd_relic_army_uncovered_00");
gb:set_objective_with_leader_on_message("miners_1_reinforce", "wh3_dlc23_chd_relic_army_uncovered_01");
gb:complete_objective_on_message("reinforce_dead", "wh3_dlc23_chd_relic_army_uncovered_01");

gb:queue_help_on_message("spawners", "wh3_dlc23_chd_relic_army_uncovered_02");
gb:queue_help_on_message("miners_1_reinforce", "wh3_dlc23_chd_relic_army_uncovered_03");
gb:queue_help_on_message("miners_2_reinforce", "wh3_dlc23_chd_relic_army_uncovered_04");
gb:queue_help_on_message("miners_3_reinforce", "wh3_dlc23_chd_relic_army_uncovered_05");

-------REINFORCEMENTS-------
sz_collection_1 = bm:get_spawn_zone_collection_by_name("spawn_01");
sz_collection_2 = bm:get_spawn_zone_collection_by_name("spawn_02");
sz_collection_3 = bm:get_spawn_zone_collection_by_name("spawn_03");

ga_ai_01:assign_to_spawn_zone_from_collection_on_message("spawners", sz_collection_1, false);
ga_ai_02:assign_to_spawn_zone_from_collection_on_message("spawners", sz_collection_2, false);
ga_ai_03:assign_to_spawn_zone_from_collection_on_message("spawners", sz_collection_3, false);

-------ORDERS-------
gb:message_on_time_offset("move", 500);
gb:message_on_time_offset("spawners", 1000);
gb:message_on_time_offset("miners_1_reinforce", 60000);
gb:message_on_time_offset("miners_2_reinforce", 120000);
gb:message_on_time_offset("miners_3_reinforce", 165000);

ga_ai_ally:rush_on_message("move");
ga_ai_start:rush_on_message("move");

ga_ai_01:reinforce_on_message("miners_1_reinforce");
ga_ai_01:message_on_deployed("miners_1_in");
ga_ai_01:rush_on_message("miners_1_in");

ga_ai_02:reinforce_on_message("miners_2_reinforce");
ga_ai_02:message_on_deployed("miners_2_in");
ga_ai_02:rush_on_message("miners_2_in");

ga_ai_03:reinforce_on_message("miners_3_reinforce");
ga_ai_03:message_on_deployed("miners_3_in");
ga_ai_03:rush_on_message("miners_3_in");

ga_ai_start:message_on_casualties("main_dead",0.95);

ga_ai_01:message_on_casualties("01_dead",0.95);
ga_ai_02:message_on_casualties("02_dead",0.95);
ga_ai_03:message_on_casualties("03_dead",0.95);

ga_ai_01:rout_over_time_on_message("main_force_dead", 30000);
ga_ai_02:rout_over_time_on_message("main_force_dead", 30000);
ga_ai_03:rout_over_time_on_message("main_force_dead", 30000);

gb:message_on_all_messages_received("main_force_dead","main_dead");
gb:message_on_all_messages_received("reinforce_dead","01_dead","02_dead","03_dead");