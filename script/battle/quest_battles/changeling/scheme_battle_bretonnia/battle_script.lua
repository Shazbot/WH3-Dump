-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Changeling
-- Theatre Scheme - Bretonnia
-- Sword of Torgrad
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();

gb = generated_battle:new(
	false,                                      		-- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                	      		-- prevent deployment for ai
	nil,  									          	-- intro cutscene function
	false                                      			-- debug mode
);

local sm = get_messager();

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player_01 = gb:get_army(gb:get_player_alliance_num());

ga_ai_ally_01 = gb:get_army(gb:get_player_alliance_num(), "vmp_01");

ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), "brt_01");
ga_ai_boss = gb:get_army(gb:get_non_player_alliance_num(), "brt_boss");
ga_ai_boss_damned = gb:get_army(gb:get_non_player_alliance_num(), "brt_damned_reinforce");
ga_ai_boss_reinforce = gb:get_army(gb:get_non_player_alliance_num(), "brt_boss_reinforce");

-------------------------------------------------------------------------------------------------
---------------------------------------- REINFORCEMENTS -----------------------------------------
-------------------------------------------------------------------------------------------------

local reinforcements = bm:reinforcements();

reinforce_01 = bm:get_spawn_zone_collection_by_name("brt_reinforce");
reinforce_boss = bm:get_spawn_zone_collection_by_name("brt_boss_reinforce");
reinforce_damned = bm:get_spawn_zone_collection_by_name("brt_damned_reinforce");

ga_ai_boss_reinforce:assign_to_spawn_zone_from_collection_on_message("start", reinforce_01, false);
ga_ai_boss:assign_to_spawn_zone_from_collection_on_message("start", reinforce_boss, false);

ga_ai_boss_damned:assign_to_spawn_zone_from_collection_on_message("start", reinforce_damned, false);
ga_ai_boss_damned:message_on_number_deployed("damned_deployed", true, 1);
ga_ai_boss_damned:assign_to_spawn_zone_from_collection_on_message("damned_deployed", reinforce_damned, false);

for i = 1, reinforcements:defender_reinforcement_lines_count() do
	
	local line = reinforcements:defender_reinforcement_line(i);
	
	if (line:script_id() == "brt_damned_reinforce") then
		line:enable_random_deployment_position();		
	end
end;

---------------
-----SETUP-----
---------------

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("hint_01", 1000);
gb:message_on_time_offset("objective_01", 5000);

ga_ai_01.sunits:set_always_visible_no_hidden_no_leave_battle(true);

gb:add_listener(
	"hint_01",
	function()
		ga_ai_01.sunits:set_always_visible_no_hidden_no_leave_battle(false);
	end,
	true
);

-------------------------------------------------------------------------------------------------
------------------------------------------ALLY ORDERS--------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_ally_01:attack_on_message("start");

-------------------------------------------------------------------------------------------------
------------------------------------------ENEMY ORDERS-------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_01:rush_on_message("start");
ga_ai_01:message_on_rout_proportion("brt_main_weak",0.33);
ga_ai_01:message_on_rout_proportion("brt_main_dead",0.99);

ga_ai_boss_reinforce:reinforce_on_message("boss_in");
ga_ai_boss_reinforce:message_on_any_deployed("brt_reinforce_in");
ga_ai_boss_reinforce:rush_on_message("brt_reinforce_in");

gb:add_listener(
	"brt_reinforce_in",
	function()
		ga_ai_boss_reinforce.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end,
	true
);

ga_ai_boss_damned:deploy_at_random_intervals_on_message(
	"boss_in", 					-- message
	1, 							-- min units
	1, 							-- max units
	2500, 						-- min period
	2500, 						-- max period
	nil, 						-- cancel message
	nil,						-- spawn first wave immediately
	false,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_boss_damned:message_on_any_deployed("damned_in");
ga_ai_boss_damned:rush_on_message("damned_in");
ga_ai_boss_damned:message_on_rout_proportion("damned_dead",0.99);

ga_ai_boss:reinforce_on_message("brt_main_weak", 5000);
ga_ai_boss:message_on_any_deployed("boss_in");
ga_ai_boss:rush_on_message("boss_in");
ga_ai_boss:message_on_rout_proportion("boss_dead",0.99);

gb:add_listener(
	"boss_in",
	function()
		ga_ai_boss.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end,
	true
);

gb:add_listener(
	"damned_in",
	function()
		ga_ai_boss_damned.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end,
	true
);

gb:add_listener(
	"boss_dead",
	function()
		if ga_ai_boss_damned.sunits:are_any_active_on_battlefield() == true then
			ga_ai_boss_damned.sunits:kill_proportion_over_time(1.0, 5000, false);
		end;
	end,
	true
);

gb:message_on_all_messages_received("brt_dead", "boss_dead", "brt_main_dead", "damned_dead");

gb:message_on_time_offset("hint_02", 5000, "boss_in");

-------------------------------------------------------------------------------------------------
--------------------------------------- OBJECTIVES & HINTS --------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_with_leader_on_message("objective_01", "wh3_dlc24_tze_changeling_theatre_scheme_bretonnia_objective_01");
gb:complete_objective_on_message("brt_dead", "wh3_dlc24_tze_changeling_theatre_scheme_bretonnia_objective_01");

gb:set_objective_with_leader_on_message("boss_in", "wh3_dlc24_tze_changeling_theatre_scheme_bretonnia_objective_02");
gb:complete_objective_on_message("boss_dead", "wh3_dlc24_tze_changeling_theatre_scheme_bretonnia_objective_02");

gb:queue_help_on_message("hint_01", "wh3_dlc24_tze_changeling_theatre_scheme_bretonnia_hint_01");
gb:queue_help_on_message("hint_02", "wh3_dlc24_tze_changeling_theatre_scheme_bretonnia_hint_02");

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------
