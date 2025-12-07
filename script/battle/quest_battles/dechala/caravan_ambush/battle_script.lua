load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
                false,                           -- screen starts black
                false,                           -- prevent deployment for player
                true,                            -- prevent deployment for ai
				nil,     						 -- intro cutscene function
                false                            -- debug mode
);

---------------------------
----HARD SCRIPT VERSION----
---------------------------
-----Caravan Ambush

------------------------------
----------ARMY SETUP----------
------------------------------
ga_player = gb:get_army(gb:get_player_alliance_num());
--Enemy Forces
ga_ai_enemy_main = gb:get_army(gb:get_non_player_alliance_num(), "main_forces");
--Enemy Reinforcements
ga_ai_enemy_main_reinforce = gb:get_army(gb:get_non_player_alliance_num(), "reinforcements");

-------------------------------
----------SPAWN ZONES----------
-------------------------------
local reinforcements = bm:reinforcements();

--Defenders Reinforce
cth_reinforce = bm:get_spawn_zone_collection_by_name("cth_reinforce");

ga_ai_enemy_main_reinforce:assign_to_spawn_zone_from_collection_on_message("start", cth_reinforce, false);

--------------------------------------
----------HINTS & OBJECTIVES----------
--------------------------------------
-----OBJECTIVE 1-----
--Defeat the Cathayan Caravan
gb:set_objective_with_leader_on_message("objective_01", "wh3_dlc27_qb_dechala_caravan_ambush_objective_01");
gb:complete_objective_on_message("cth_caravn_defeated", "wh3_dlc27_qb_dechala_caravan_ambush_objective_01");

gb:queue_help_on_message("hint_01", "wh3_dlc27_qb_dechala_caravan_ambush_hint_01");
gb:queue_help_on_message("reinforcements_in", "wh3_dlc27_qb_dechala_caravan_ambush_hint_02");

----------------------------------
----------SPECIAL ORDERS----------
----------------------------------
gb:message_on_time_offset("start", 200);
gb:message_on_time_offset("objective_01", 2500);
gb:message_on_time_offset("hint_01", 7500);

gb:message_on_all_messages_received("cth_caravn_defeated", "main_force_dead", "reinforcements_dead")

ga_player:force_victory_on_message("cth_caravn_defeated", 5000);

--------------------------------
----------ENEMY ORDERS----------
--------------------------------
ga_ai_enemy_main:message_on_under_attack("fight_back");
ga_ai_enemy_main:rush_on_message("fight_back");
ga_ai_enemy_main:message_on_rout_proportion("main_force_hurt",0.4);
ga_ai_enemy_main:message_on_rout_proportion("main_force_dead",0.99);

ga_ai_enemy_main_reinforce:reinforce_on_message("main_force_hurt");
ga_ai_enemy_main_reinforce:message_on_any_deployed("reinforcements_in");
ga_ai_enemy_main_reinforce:rush_on_message("reinforcements_in");
ga_ai_enemy_main_reinforce:message_on_rout_proportion("reinforcements_dead",0.99);