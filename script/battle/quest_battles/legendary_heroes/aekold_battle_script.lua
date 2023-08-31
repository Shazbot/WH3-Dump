-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Kairos Fateweaver/Changeling
-- A Hero Reborn
-- The Golden Monolith
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();

gb = generated_battle:new(
	false,                                      	    -- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                      		    -- prevent deployment for ai
	nil,									          	-- intro cutscene function
	false                                      			-- debug mode
);

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player_01 = gb:get_army(gb:get_player_alliance_num());

ga_ai_ally = gb:get_army(gb:get_player_alliance_num(), "ally");
ga_ai_aekold = gb:get_army(gb:get_player_alliance_num(), "aekold");

ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), "bst_01");
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), "bst_02");

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("objective_01", 3000);
gb:message_on_time_offset("objective_02", 8000);

ga_ai_ally:rush_on_message("start");
ga_ai_aekold:rush_on_message("start");
ga_ai_aekold:message_on_casualties("aekold_dead",0.99);

ga_ai_01:rush_on_message("start");
ga_ai_01:message_on_casualties("enemy_01_dead",0.99);
ga_ai_02:rush_on_message("start");
ga_ai_02:message_on_casualties("enemy_02_dead",0.99);

gb:message_on_all_messages_received("enemy_defeated", "enemy_01_dead", "enemy_02_dead");

gb:add_listener(
	"aekold_dead",
	function()
		if ga_player_01.sunits:are_any_active_on_battlefield() == true then
			ga_player_01.sunits:rout_over_time(20000);
		end;
		
		if ga_ai_ally.sunits:are_any_active_on_battlefield() == true then
			ga_ai_ally.sunits:rout_over_time(10000);
		end;
	end,
	true
);

-------------------------------------------------------------------------------------------------
--------------------------------------- OBJECTIVES & HINTS --------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_with_leader_on_message("objective_01", "wh3_dlc24_qb_tze_aekold_helbrass_unlock_objective_01");
gb:complete_objective_on_message("enemy_defeated", "wh3_dlc24_qb_tze_aekold_helbrass_unlock_objective_01");

gb:set_objective_with_leader_on_message("objective_02", "wh3_dlc24_qb_tze_aekold_helbrass_unlock_objective_02");
gb:complete_objective_on_message("enemy_defeated", "wh3_dlc24_qb_tze_aekold_helbrass_unlock_objective_02");
gb:fail_objective_on_message("aekold_dead", "wh3_dlc24_qb_tze_aekold_helbrass_unlock_objective_02")

gb:queue_help_on_message("start", "wh3_dlc24_qb_tze_aekold_helbrass_unlock_hint_01");
gb:queue_help_on_message("aekold_dead", "wh3_dlc24_qb_tze_aekold_helbrass_unlock_hint_02");

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------
