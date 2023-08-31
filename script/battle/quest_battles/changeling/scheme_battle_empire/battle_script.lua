-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Changeling
-- Theatre Scheme - Empire
-- Map
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

local sm = get_messager();

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player_01 = gb:get_army(gb:get_player_alliance_num());

ga_ai_franz = gb:get_army(gb:get_non_player_alliance_num(), "franz");
ga_ai_gelt = gb:get_army(gb:get_non_player_alliance_num(), "gelt");
ga_ai_gelt_boss = gb:get_army(gb:get_non_player_alliance_num(), "gelt_boss");
ga_ai_toddy = gb:get_army(gb:get_non_player_alliance_num(), "toddy");
ga_ai_toddy_boss = gb:get_army(gb:get_non_player_alliance_num(), "toddy_boss");
ga_ai_wulfhart = gb:get_army(gb:get_non_player_alliance_num(), "wulfhart");
ga_ai_wulfhart_boss = gb:get_army(gb:get_non_player_alliance_num(), "wulfhart_boss");
ga_ai_volkmar = gb:get_army(gb:get_non_player_alliance_num(), "volkmar");
ga_ai_volkmar_boss = gb:get_army(gb:get_non_player_alliance_num(), "volkmar_boss");

gelt_boss = ga_ai_gelt_boss.sunits:item(1);
toddy_boss = ga_ai_toddy_boss.sunits:item(1);
wulfhart_boss = ga_ai_wulfhart_boss.sunits:item(1);
volkmar_boss = ga_ai_volkmar_boss.sunits:item(1);

-------------------------------------------------------------------------------------------------
---------------------------------------- REINFORCEMENTS -----------------------------------------
-------------------------------------------------------------------------------------------------

local reinforcements = bm:reinforcements();

reinforce_01 = bm:get_spawn_zone_collection_by_name("emp_reinforce");

ga_ai_franz:assign_to_spawn_zone_from_collection_on_message("start", reinforce_01, false);

---------------
-----SETUP-----
---------------

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("hint_01", 1000);
gb:message_on_time_offset("objective_01", 5000);
gb:message_on_time_offset("objective_02", 10000);
gb:message_on_time_offset("franz_time", 180000); 

-------------------------------------------------------------------------------------------------
------------------------------------------ALLY ORDERS--------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
------------------------------------------ENEMY ORDERS-------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_gelt:rush_on_message("start");
ga_ai_gelt:message_on_rout_proportion("gelt_weak",0.5);
ga_ai_gelt:message_on_rout_proportion("gelt_dead",0.99);

ga_ai_gelt_boss:attack_on_message("start");
ga_ai_gelt_boss:message_on_casualties("gelt_boss_weak",0.5);
ga_ai_gelt_boss:message_on_casualties("gelt_boss_dead",0.99);
ga_ai_gelt_boss:message_on_commander_dead_or_shattered("gelt_boss_shattered");

gelt_boss:set_stat_attribute("unbreakable", true);

gb:add_listener(
	"gelt_boss_weak",
	function()
		gelt_boss:set_stat_attribute("unbreakable", false);
		gelt_boss:add_ping_icon(15);
		ga_ai_gelt_boss.sunits:rout_over_time(1000);
	end,
	true
);

ga_ai_toddy:rush_on_message("start");
ga_ai_toddy:message_on_rout_proportion("toddy_weak",0.5);
ga_ai_toddy:message_on_rout_proportion("toddy_dead",0.99);

ga_ai_toddy_boss:attack_on_message("start");
ga_ai_toddy_boss:message_on_casualties("toddy_boss_weak",0.5);
ga_ai_toddy_boss:message_on_casualties("toddy_boss_dead",0.99);
ga_ai_toddy_boss:message_on_commander_dead_or_shattered("toddy_boss_shattered");

toddy_boss:set_stat_attribute("unbreakable", true);

gb:add_listener(
	"toddy_boss_weak",
	function()
		toddy_boss:set_stat_attribute("unbreakable", false);
		toddy_boss:add_ping_icon(15);
		ga_ai_toddy_boss.sunits:rout_over_time(1000);
	end,
	true
);

ga_ai_wulfhart:rush_on_message("start");
ga_ai_wulfhart:message_on_rout_proportion("wulfhart_weak",0.5);
ga_ai_wulfhart:message_on_rout_proportion("wulfhart_dead",0.99);

ga_ai_wulfhart_boss:attack_on_message("start");
ga_ai_wulfhart_boss:message_on_casualties("wulfhart_boss_weak",0.5);
ga_ai_wulfhart_boss:message_on_casualties("wulfhart_boss_dead",0.99);
ga_ai_wulfhart_boss:message_on_commander_dead_or_shattered("wulfhart_boss_shattered");

wulfhart_boss:set_stat_attribute("unbreakable", true);

gb:add_listener(
	"wulfhart_boss_weak",
	function()
		wulfhart_boss:set_stat_attribute("unbreakable", false);
		wulfhart_boss:add_ping_icon(15);
		ga_ai_wulfhart_boss.sunits:rout_over_time(1000);
	end,
	true
);

ga_ai_volkmar:rush_on_message("start");
ga_ai_volkmar:message_on_rout_proportion("volkmar_weak",0.5);
ga_ai_volkmar:message_on_rout_proportion("volkmar_dead",0.99);

ga_ai_volkmar_boss:attack_on_message("start");
ga_ai_volkmar_boss:message_on_casualties("volkmar_boss_weak",0.5);
ga_ai_volkmar_boss:message_on_casualties("volkmar_boss_dead",0.99);
ga_ai_volkmar_boss:message_on_commander_dead_or_shattered("volkmar_boss_shattered");

volkmar_boss:set_stat_attribute("unbreakable", true);

gb:add_listener(
	"volkmar_boss_weak",
	function()
		volkmar_boss:set_stat_attribute("unbreakable", false);
		volkmar_boss:add_ping_icon(15);
		ga_ai_volkmar_boss.sunits:rout_over_time(1000);
	end,
	true
);

ga_ai_franz:reinforce_on_message("franz_time");
ga_ai_franz:message_on_any_deployed("franz_in");
ga_ai_franz:rush_on_message("franz_in");
ga_ai_franz:message_on_rout_proportion("franz_dead",0.99);

gb:message_on_all_messages_received("franz_time", "gelt_weak", "toddy_weak","wulfhart_weak", "volkmar_weak");
gb:message_on_all_messages_received("emp_dead", "franz_dead", "volkmar_dead","wulfhart_dead","toddy_dead","gelt_dead");
gb:message_on_all_messages_received("emp_delegates_routed", "volkmar_boss_shattered","wulfhart_boss_shattered","toddy_boss_shattered","gelt_boss_shattered");
gb:message_on_any_message_received("delegate_routing", "volkmar_boss_weak","wulfhart_boss_weak","toddy_boss_weak","gelt_boss_weak");

-------------------------------------------------------------------------------------------------
--------------------------------------- OBJECTIVES & HINTS --------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_with_leader_on_message("objective_01", "wh3_dlc24_tze_changeling_theatre_scheme_empire_objective_01");
gb:complete_objective_on_message("emp_delegates_routed", "wh3_dlc24_tze_changeling_theatre_scheme_empire_objective_01");
gb:fail_objective_on_message("too_many_delegates_killed", "wh3_dlc24_tze_changeling_theatre_scheme_empire_objective_01")

gb:set_objective_with_leader_on_message("objective_02", "wh3_dlc24_tze_changeling_theatre_scheme_empire_objective_02");
gb:complete_objective_on_message("emp_dead", "wh3_dlc24_tze_changeling_theatre_scheme_empire_objective_02");

gb:queue_help_on_message("hint_01", "wh3_dlc24_tze_changeling_theatre_scheme_empire_hint_01");
gb:queue_help_on_message("delegate_routing", "wh3_dlc24_tze_changeling_theatre_scheme_empire_hint_02");
gb:queue_help_on_message("franz_in", "wh3_dlc24_tze_changeling_theatre_scheme_empire_hint_03");
gb:queue_help_on_message("one_delegate_killed", "wh3_dlc24_tze_changeling_theatre_scheme_empire_hint_04");

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

delegates_killed = 0

gb:add_listener(
    "volkmar_boss_dead",
	function()
		delegates_killed = delegates_killed +1
		check_how_many_killed()
    end,
	true
);

gb:add_listener(
    "wulfhart_boss_dead",
	function()
		delegates_killed = delegates_killed +1
		check_how_many_killed()
    end,
	true
);

gb:add_listener(
    "toddy_boss_dead",
	function()
		delegates_killed = delegates_killed +1
		check_how_many_killed()
    end,
	true
);

gb:add_listener(
    "gelt_boss_dead",
	function()
		delegates_killed = delegates_killed +1
		check_how_many_killed()
    end,
	true
);

function check_how_many_killed()
	if delegates_killed == 1 then
		bm:out("Delegates Killed: "..delegates_killed)
		sm:trigger_message("one_delegate_killed");
	end

	if delegates_killed == 2 then
		bm:out("Delegates Killed: "..delegates_killed)
		sm:trigger_message("too_many_delegates_killed");
	end
end

gb:add_listener(
    "end_this",
	function()
		bm:callback(
			function()
				bm:change_victory_countdown_limit(0)
				bm:end_battle()
			end,
			100
		);
    end,
	true
);

--ga_player_01:teleport_withdraw_over_time_on_message("too_many_delegates_killed",5000);
gb:message_on_time_offset("end_this", 2500, "too_many_delegates_killed");
ga_ai_franz:force_victory_on_message("end_this", 5000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------
