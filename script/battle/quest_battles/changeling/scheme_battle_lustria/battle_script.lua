-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Changeling
-- Theatre Scheme - Lustria
-- Lake Incatol – Lustria Lakes
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();

gb = generated_battle:new(
	false,                                      		-- screen starts black
	false,                                      		-- prevent deployment for player
	false,                                      		-- prevent deployment for ai
	nil,  									          	-- intro cutscene function
	false                                      			-- debug mode
);

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player_01 = gb:get_army(gb:get_player_alliance_num());

ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), "lzd_01");
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), "lzd_02");

-------------------------------------------------------------------------------------------------
---------------------------------------- REINFORCEMENTS -----------------------------------------
-------------------------------------------------------------------------------------------------

local reinforcements = bm:reinforcements();

reinforce_01 = bm:get_spawn_zone_collection_by_name("lzd_defenders");

ga_ai_02:assign_to_spawn_zone_from_collection_on_message("start", reinforce_01, false);

---------------
-----SETUP-----
---------------

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("hint_01", 1000);
gb:message_on_time_offset("objective_01", 5000);

-------------------------------------------------------------------------------------------------
------------------------------------------ALLY ORDERS--------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
------------------------------------------ENEMY ORDERS-------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_01:message_on_under_attack("attack_player");
ga_ai_01:rush_on_message("attack_player");
ga_ai_01:message_on_rout_proportion("lzd_main_weak",0.25);
ga_ai_01:message_on_rout_proportion("lzd_main_weaker",0.5);
ga_ai_01:message_on_rout_proportion("lzd_main_dead",0.99);

ga_ai_02:reinforce_on_message("lzd_main_weaker");
ga_ai_02:message_on_any_deployed("lzd_in");
ga_ai_02:rush_on_message("lzd_in");
ga_ai_02:message_on_rout_proportion("lzd_reinforce_dead",0.99);

gb:message_on_all_messages_received("lzd_dead", "lzd_main_dead", "lzd_reinforce_dead");

-------------------------------------------------------------------------------------------------
--------------------------------------- OBJECTIVES & HINTS --------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_with_leader_on_message("objective_01", "wh3_dlc24_tze_changeling_theatre_scheme_lustria_objective_01");
gb:complete_objective_on_message("lzd_dead", "wh3_dlc24_tze_changeling_theatre_scheme_lustria_objective_01");

gb:queue_help_on_message("hint_01", "wh3_dlc24_tze_changeling_theatre_scheme_lustria_hint_01");
gb:queue_help_on_message("lzd_main_weak", "wh3_dlc24_tze_changeling_theatre_scheme_lustria_hint_02");
gb:queue_help_on_message("lzd_main_weaker", "wh3_dlc24_tze_changeling_theatre_scheme_lustria_hint_03");

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player_01:force_victory_on_message("lzd_dead", 5000);