-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Mother Ostankya
-- Hex 04 - Purification Chant
-- The Underway
-- Defender

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();

gb = generated_battle:new(
	false,                                      		-- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                      			-- prevent deployment for ai
	nil,  									          	-- intro cutscene function
	false                                      			-- debug mode
);

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player_01 = gb:get_army(gb:get_player_alliance_num());
ga_ai_nur_01 = gb:get_army(gb:get_non_player_alliance_num(), "nur_01");
ga_ai_nur_02 = gb:get_army(gb:get_non_player_alliance_num(), "nur_02");
ga_ai_nur_boss = gb:get_army(gb:get_non_player_alliance_num(), "nur_boss");
ga_ai_skv_01 = gb:get_army(gb:get_non_player_alliance_num(), "skv_01");
ga_ai_skv_02 = gb:get_army(gb:get_non_player_alliance_num(), "skv_02");

nur_boss = ga_ai_nur_boss.sunits:item(1);

ga_ai_nur_01:get_army():suppress_reinforcement_adc(1);
ga_ai_nur_02:get_army():suppress_reinforcement_adc(1);

-------------------------------------------------------------------------------------------------
---------------------------------------- REINFORCEMENTS -----------------------------------------
-------------------------------------------------------------------------------------------------

local reinforcements = bm:reinforcements();

reinforce_01 = bm:get_spawn_zone_collection_by_name("nur_01_reinforce");
reinforce_02 = bm:get_spawn_zone_collection_by_name("nur_02_reinforce");

ga_ai_nur_01:assign_to_spawn_zone_from_collection_on_message("assign", reinforce_01, false);
ga_ai_nur_01:message_on_number_deployed("nur_01_deployed", true, 1);
ga_ai_nur_01:assign_to_spawn_zone_from_collection_on_message("nur_01_deployed", reinforce_01, false);

ga_ai_nur_02:assign_to_spawn_zone_from_collection_on_message("assign", reinforce_02, false);
ga_ai_nur_02:message_on_number_deployed("nur_02_deployed", true, 1);
ga_ai_nur_02:assign_to_spawn_zone_from_collection_on_message("nur_02_deployed", reinforce_02, false);

ga_ai_nur_boss:assign_to_spawn_zone_from_collection_on_message("assign", reinforce_01, false);

for i = 1, reinforcements:attacker_reinforcement_lines_count() do
	
	local line = reinforcements:attacker_reinforcement_line(i);
	
	if (line:script_id() == "nur_01_reinforce") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "nur_02_reinforce") then
		line:enable_random_deployment_position();		
	end
end;

---------------
-----SETUP-----
---------------

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("assign", 1000);
gb:message_on_time_offset("objective_01", 5000);

ga_ai_skv_01.sunits:set_always_visible_no_hidden_no_leave_battle(true);
ga_ai_skv_02.sunits:set_always_visible_no_hidden_no_leave_battle(true);

-------------------------------------------------------------------------------------------------
------------------------------------------ALLY ORDERS--------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
------------------------------------------ENEMY ORDERS-------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_skv_01:rush_on_message("start");
ga_ai_skv_01:message_on_rout_proportion("skv_01_weakened",0.25);
ga_ai_skv_01:message_on_rout_proportion("skv_01_defeated",0.95);
ga_ai_skv_01:message_on_proximity_to_enemy("skv_01_threatened", 50);

ga_ai_skv_02:rush_on_message("start");
ga_ai_skv_02:message_on_rout_proportion("skv_02_weakened",0.25);
ga_ai_skv_02:message_on_rout_proportion("skv_02_defeated",0.95);

ga_ai_nur_01:deploy_at_random_intervals_on_message(
	"skv_01_weakened", 			-- message
	1, 							-- min units
	1, 							-- max units
	5000, 						-- min period
	5000, 						-- max period
	"nur_boss_defeated", 		-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_nur_01:message_on_any_deployed("nur_01_in");
ga_ai_nur_01:rush_on_message("nur_01_in");

ga_ai_nur_02:deploy_at_random_intervals_on_message(
	"skv_02_weakened", 			-- message
	1, 							-- min units
	1, 							-- max units
	15000, 						-- min period
	15000, 						-- max period
	"nur_boss_defeated",		-- cancel message
	nil,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_nur_02:message_on_any_deployed("nur_02_in");
ga_ai_nur_02:rush_on_message("nur_02_in");

ga_ai_nur_boss:reinforce_on_message("skv_01_threatened");
ga_ai_nur_boss:message_on_deployed("nur_boss_in");
ga_ai_nur_boss:rush_on_message("nur_boss_in");
ga_ai_nur_boss:message_on_casualties("nur_boss_defeated",0.95);

gb:add_listener(
	"nur_boss_objective",
	function()
		nur_boss:add_ping_icon(15);
	end
);

gb:message_on_time_offset("nur_boss_objective", 5000, "nur_boss_in");

gb:message_on_all_messages_received("skv_defeated", "skv_01_defeated", "skv_02_defeated");

gb:add_listener(
	"nur_boss_defeated",
	function()
		if ga_ai_nur_01.sunits:are_any_active_on_battlefield() == true then
			ga_ai_nur_01.sunits:kill_proportion_over_time(1.0, 10000, false);
		end;
		if ga_ai_nur_02.sunits:are_any_active_on_battlefield() == true then
			ga_ai_nur_02.sunits:kill_proportion_over_time(1.0, 10000, false);
		end;
		if ga_ai_skv_01.sunits:are_any_active_on_battlefield() == true then
			ga_ai_skv_01.sunits:rout_over_time(10000);
		end;
		if ga_ai_skv_02.sunits:are_any_active_on_battlefield() == true then
			ga_ai_skv_02.sunits:rout_over_time(10000);
		end;
	end,
	true
);

gb:message_on_all_messages_received("i_win", "nur_boss_defeated", "skv_defeated");

-------------------------------------------------------------------------------------------------
--------------------------------------- OBJECTIVES & HINTS --------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_with_leader_on_message("objective_01", "wh3_dlc24_ksl_hex_04_objective_01");
gb:complete_objective_on_message("skv_defeated", "wh3_dlc24_ksl_hex_04_objective_01");

gb:set_objective_with_leader_on_message("nur_boss_objective", "wh3_dlc24_ksl_hex_04_objective_02");
gb:complete_objective_on_message("nur_boss_defeated", "wh3_dlc24_ksl_hex_04_objective_02");

gb:queue_help_on_message("start", "wh3_dlc24_ksl_hex_04_hint_01");
gb:queue_help_on_message("nur_boss_in", "wh3_dlc24_ksl_hex_04_hint_02");
gb:queue_help_on_message("nur_01_in", "wh3_dlc24_ksl_hex_04_hint_03");
gb:queue_help_on_message("nur_02_in", "wh3_dlc24_ksl_hex_04_hint_04");

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player_01:force_victory_on_message("i_win", 5000);
