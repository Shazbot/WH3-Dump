load_script_libraries();

local gc = generated_cutscene:new(true);

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
ga_ai_boss = gb:get_army(gb:get_non_player_alliance_num(), "boss");		
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), "start");
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), "reinforcements");
ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(), "copters");

boss = ga_ai_boss.sunits:item(1);

-------OBJECTIVES-------
gb:set_objective_with_leader_on_message("destroy", "wh3_dlc23_chd_relic_of_grungni_00");
gb:complete_objective_on_message("boss_dead", "wh3_dlc23_chd_relic_of_grungni_00");
gb:set_objective_with_leader_on_message("battle_started", "wh3_dlc23_chd_relic_of_grungni_01");
gb:complete_objective_on_message("01_dead", "wh3_dlc23_chd_relic_of_grungni_01");

gb:queue_help_on_message("stir", "wh3_dlc23_chd_relic_of_grungni_03");
gb:queue_help_on_message("reinforcements_called_late", "wh3_dlc23_chd_relic_of_grungni_04");
gb:queue_help_on_message("reinforcements_called", "wh3_dlc23_chd_relic_of_grungni_05");

-------REINFORCEMENTS-------
sz_collection_1 = bm:get_spawn_zone_collection_by_name("spawn_01");
sz_collection_2 = bm:get_spawn_zone_collection_by_name("spawn_02");

ga_ai_02:assign_to_spawn_zone_from_collection_on_message("spawns", sz_collection_1, false);
ga_ai_03:assign_to_spawn_zone_from_collection_on_message("spawns", sz_collection_2, false);

-------ORDERS-------
gb:message_on_time_offset("move", 1000);
gb:message_on_time_offset("spawns", 1000);
gb:message_on_time_offset("stir", 5000);
gb:message_on_time_offset("destroy", 10000);

boss:set_stat_attribute("unbreakable", true);

gb:add_listener(
	"destroy",
	function()
		boss:add_ping_icon(15);
	end
);

ga_ai_boss:goto_location_offset_on_message("move", 0, -400, true);
gb:message_on_time_offset("reinforcements_called_late_1", 60000, "reinforcements_called_1");
ga_ai_boss:message_on_proximity_to_position("reinforcements_called_1", v(225, -295), 100);

ga_ai_boss:message_on_casualties("reinforcements_called_2", 0.75);
ga_ai_boss:message_on_casualties("reinforcements_called_late_2", 0.75);

gb:block_message_on_message("reinforcements_called_1", "reinforcements_called_2", true);
gb:block_message_on_message("reinforcements_called_late_1", "reinforcements_called_late_2", true);

gb:block_message_on_message("reinforcements_called_2", "reinforcements_called_1", true);
gb:block_message_on_message("reinforcements_called_late_2", "reinforcements_called_late_1", true);

ga_ai_01:rush_on_message("move");

ga_ai_02:reinforce_on_message("reinforcements_called_1");
ga_ai_02:reinforce_on_message("reinforcements_called_2");
ga_ai_02:message_on_any_deployed("garrison_in");
ga_ai_02:rush_on_message("garrison_in");

ga_ai_03:reinforce_on_message("reinforcements_called_late_1");
ga_ai_03:reinforce_on_message("reinforcements_called_late_2");
ga_ai_03:message_on_any_deployed("copters_in");
ga_ai_03:rush_on_message("copters_in");

ga_ai_01:message_on_casualties("01_dead",1);
ga_ai_02:message_on_casualties("02_dead",1);
ga_ai_03:message_on_casualties("03_dead",1);
ga_ai_boss:message_on_casualties("boss_dead",1);

ga_ai_boss:rush_on_message("copters_in");

gb:message_on_all_messages_received("reinforce_dead","02_dead","03_dead");