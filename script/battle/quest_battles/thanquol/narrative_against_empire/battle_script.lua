-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Thanquol
-- By Hristo Enev
-- Narrative battle against Empire

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();

bm = battle_manager:new(empire_battle:new());

--bm:camera():fade(true, 0);

gb = generated_battle:new(
                false,                         		 -- screen starts black
                false,                         		 -- prevent deployment for player
                false,                         		 -- prevent deployment for ai
				nil,								 -- intro cutscene function -- nil, --
                false                          		 -- debug mode
);

------------------------------
----------ARMY SETUP----------
------------------------------

ga_player = gb:get_army(gb:get_player_alliance_num());

ga_ai_emp_main = gb:get_army(gb:get_non_player_alliance_num(), "emp_main");

--------------------------------------
----------HINTS & OBJECTIVES----------
--------------------------------------

gb:set_objective_on_message("start", "wh_main_qb_objective_attack_defeat_army", 1000);
gb:fail_objective_on_message("player_lost", "wh_main_qb_objective_attack_defeat_army", 1500);
gb:complete_objective_on_message("player_wins", "wh_main_qb_objective_attack_defeat_army", 500);

--gb:queue_help_on_message("intro_cutscene_end", "wh3_dlc29_qb_skv_thanquol_final_battle_hint_1", 10000, 2000, 15000)

-------------------------------------------------------------------------------------------------
--------------------------------------------- DEFEAT -------------------------------------------
-------------------------------------------------------------------------------------------------
ga_player:message_on_casualties("player_lost", 0.95);
ga_ai_emp_main:force_victory_on_message("player_lost", 2500);

-------------------------------------------------------------------------------------------------
------------------------------------------- VICTORY ---------------------------------------------
-------------------------------------------------------------------------------------------------
ga_ai_emp_main:message_on_casualties("player_wins", 0.95);
ga_player:force_victory_on_message("player_wins", 2500);

----------------------------------
-----------BATTLE SETUP-----------
----------------------------------

gb:message_on_time_offset("start", 100);

-------------------------------
-------------ORDERS------------
-------------------------------
ga_ai_emp_main:message_on_proximity_to_enemy("rush_on_being_attacked", 200);
ga_ai_emp_main:message_on_under_attack("rush_on_being_attacked");
ga_ai_emp_main:rush_on_message("rush_on_being_attacked");
