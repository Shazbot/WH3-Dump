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
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), "reinforcements_1");
ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(), "reinforcements_2");

boss = ga_ai_boss.sunits:item(1);

-------OBJECTIVES-------
gb:set_objective_with_leader_on_message("destroy", "wh3_dlc23_chd_relic_of_grimnir_00");
gb:complete_objective_on_message("boss_dead", "wh3_dlc23_chd_relic_of_grimnir_00");
gb:set_objective_with_leader_on_message("battle_started", "wh3_dlc23_chd_relic_of_grimnir_01");
gb:complete_objective_on_message("all_dead", "wh3_dlc23_chd_relic_of_grimnir_01");

gb:queue_help_on_message("stir", "wh3_dlc23_chd_relic_of_grimnir_02");
gb:queue_help_on_message("toads_01_in", "wh3_dlc23_chd_relic_of_grimnir_03");
gb:queue_help_on_message("toads_02_in", "wh3_dlc23_chd_relic_of_grimnir_04");

-------ORDERS-------
gb:message_on_time_offset("move", 2000);
gb:message_on_time_offset("destroy", 10000);
gb:message_on_time_offset("stir", 30000);
gb:message_on_time_offset("release_toads_01", 60000);
gb:message_on_time_offset("release_toads_02", 150000);

boss:set_stat_attribute("unbreakable", true);

gb:add_listener(
	"destroy",
	function()
		boss:add_ping_icon(15);
	end
);

ga_ai_boss:attack_on_message("move");

ga_ai_01:rush_on_message("move");

ga_ai_02:reinforce_on_message("release_toads_01");
ga_ai_02:message_on_any_deployed("toads_01_in");
ga_ai_02:rush_on_message("toads_01_in");

ga_ai_03:reinforce_on_message("release_toads_02");
ga_ai_03:message_on_any_deployed("toads_02_in");
ga_ai_03:rush_on_message("toads_02_in");

ga_ai_01:message_on_casualties("01_dead",1);
ga_ai_02:message_on_casualties("02_dead",1);
ga_ai_03:message_on_casualties("03_dead",1);
ga_ai_boss:message_on_casualties("boss_dead",1);

gb:message_on_all_messages_received("all_dead","01_dead","02_dead","03_dead");