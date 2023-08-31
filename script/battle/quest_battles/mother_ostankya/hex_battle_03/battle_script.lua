-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Mother Ostankya
-- Hex 03 - Bewitching Allure
-- Map - wh3_main_macro_ogr_haunted_forest_01
-- Defender (Ambush)

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
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), "start");
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_bst");
ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_skv");
ga_ai_hag_01 = gb:get_army(gb:get_non_player_alliance_num(), "boss_01");
ga_ai_hag_02 = gb:get_army(gb:get_non_player_alliance_num(), "boss_02");
ga_ai_hag_03 = gb:get_army(gb:get_non_player_alliance_num(), "boss_03");

boss_01 = ga_ai_hag_01.sunits:item(1);
boss_02 = ga_ai_hag_02.sunits:item(1);
boss_03 = ga_ai_hag_03.sunits:item(1);

-------------------------------------------------------------------------------------------------
---------------------------------------- REINFORCEMENTS -----------------------------------------
-------------------------------------------------------------------------------------------------

-- unused

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("spirits_start", 1000);

gb:message_on_time_offset("objective_01", 7500);
gb:add_listener(
	"objective_01",
	function()
		boss_01:add_ping_icon(15);
	end
);

gb:add_listener(
	"second_hag",
	function()
		boss_02:add_ping_icon(15);
	end
);

gb:add_listener(
	"third_hag",
	function()
		boss_03:add_ping_icon(15);
	end
);

ga_ai_01:rush_on_message("spirits_start");
ga_ai_hag_01:rush_on_message("spirits_start");
ga_ai_hag_01:message_on_rout_proportion("hag_weak_01",0.40);
ga_ai_hag_01:message_on_rout_proportion("hag_death_close_01",0.70);
ga_ai_hag_01:message_on_rout_proportion("hag_dead_01",0.99);

ga_ai_hag_02:message_on_rout_proportion("hag_dead_02",0.99);

ga_ai_01:rush_on_message("spirits_start");

ga_ai_02:deploy_at_random_intervals_on_message(
	"hag_weak_01", 				-- message
	1, 							-- min units
	2, 							-- max units
	1500, 						-- min period
	1500, 						-- max period
	nil, 						-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_hag_02:reinforce_on_message("hag_weak_01");
ga_ai_02:message_on_any_deployed("second_hag_forces");
ga_ai_hag_02:message_on_any_deployed("second_hag");
ga_ai_02:rush_on_message("second_hag_forces");
ga_ai_hag_02:rush_on_message("second_hag");

ga_ai_03:reinforce_on_message("hag_death_close_01");
ga_ai_hag_03:reinforce_on_message("hag_death_close_01")
ga_ai_03:message_on_any_deployed("third_hag_forces");
ga_ai_hag_03:message_on_any_deployed("third_hag");
ga_ai_03:rush_on_message("third_hag_forces");
ga_ai_hag_03:rush_on_message("third_hag");
ga_ai_hag_03:message_on_rout_proportion("hag_dead_03",0.99);

gb:message_on_all_messages_received("hags_subdued", "hag_dead_01", "hag_dead_02", "hag_dead_03");

gb:add_listener(
	"hags_subdued",
	function()
		if ga_ai_01.sunits:are_any_active_on_battlefield() == true then
			ga_ai_01.sunits:rout_over_time(10000);
		end;
		if ga_ai_02.sunits:are_any_active_on_battlefield() == true then
			ga_ai_02.sunits:rout_over_time(20000);
		end;
		if ga_ai_03.sunits:are_any_active_on_battlefield() == true then
			ga_ai_03.sunits:rout_over_time(30000);
		end;
	end,
	true
);

-------------------------------------------------------------------------------------------------
--------------------------------------- OBJECTIVES & HINTS --------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_with_leader_on_message("objective_01", "wh3_dlc24_ksl_hex_03_objective_01");
gb:complete_objective_on_message("hag_dead_01", "wh3_dlc24_ksl_hex_03_objective_01");

gb:set_objective_with_leader_on_message("second_hag", "wh3_dlc24_ksl_hex_03_objective_02");
gb:complete_objective_on_message("hag_dead_02", "wh3_dlc24_ksl_hex_03_objective_02");

gb:set_objective_with_leader_on_message("third_hag", "wh3_dlc24_ksl_hex_03_objective_03");
gb:complete_objective_on_message("hag_dead_03", "wh3_dlc24_ksl_hex_03_objective_03");

gb:queue_help_on_message("start", "wh3_dlc24_ksl_hex_03_hint_01");
gb:queue_help_on_message("second_hag", "wh3_dlc24_ksl_hex_03_hint_02");
gb:queue_help_on_message("third_hag", "wh3_dlc24_ksl_hex_03_hint_03");
gb:queue_help_on_message("hags_subdued", "wh3_dlc24_ksl_hex_03_hint_04"); 

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------
