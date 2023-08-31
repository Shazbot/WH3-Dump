-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Changeling
-- Theatre Scheme - Darklands
-- Plains of Zharr
-- Attacker

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

ga_ally_01 = gb:get_army(gb:get_player_alliance_num(), "labour_01");
ga_ally_02 = gb:get_army(gb:get_player_alliance_num(), "labour_02");
ga_ally_reinforce = gb:get_army(gb:get_player_alliance_num(), "labour_reinforce");

ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), "chd_start_01");
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(), "chd_start_02");

boss_01 = ga_ally_01.sunits:item(1);
boss_02 = ga_ally_02.sunits:item(1);

-------------------------------------------------------------------------------------------------
---------------------------------------- REINFORCEMENTS -----------------------------------------
-------------------------------------------------------------------------------------------------

local reinforcements = bm:reinforcements();

reinforce_01 = bm:get_spawn_zone_collection_by_name("labour_reinforce");

ga_ally_reinforce:assign_to_spawn_zone_from_collection_on_message("start", reinforce_01, false);
ga_ally_reinforce:message_on_number_deployed("labour_reinforce_deployed", true, 1);
ga_ally_reinforce:assign_to_spawn_zone_from_collection_on_message("labour_reinforce_deployed", reinforce_01, false);

for i = 1, reinforcements:attacker_reinforcement_lines_count() do
	
	local line = reinforcements:attacker_reinforcement_line(i);
	
	if (line:script_id() == "labour_reinforce") then
		line:enable_random_deployment_position();		
	end
end;

---------------
-----SETUP-----
---------------

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("labourers", 1000);

gb:message_on_time_offset("hint_01", 2500);
gb:message_on_time_offset("objective_01", 7500);
gb:message_on_time_offset("objective_02", 12500);

local speed_01 = 20000;
local unit_count = 1;

local perpetual = true;
local shattered_only = true;
local permit_rampaging = true;

ga_ai_01.sunits:set_always_visible_no_leave_battle(true);
ga_ai_02.sunits:set_always_visible_no_leave_battle(true);

-------------------------------------------------------------------------------------------------
------------------------------------------ALLY ORDERS--------------------------------------------
-------------------------------------------------------------------------------------------------

gb:add_listener(
	"objective_01",
	function()
		boss_01:add_ping_icon(15);
		boss_02:add_ping_icon(15);
	end,
	true
);

ga_ally_01:rush_on_message("labourers");
ga_ally_01:message_on_rout_proportion("ally_01_weakened",0.35);
ga_ally_01:message_on_rout_proportion("ally_01_weaker",0.7);
ga_ally_01:message_on_rout_proportion("ally_01_dead",0.99);

ga_ally_02:rush_on_message("labourers");
ga_ally_02:message_on_rout_proportion("ally_02_weakened",0.35);
ga_ally_02:message_on_rout_proportion("ally_02_weaker",0.7);
ga_ally_02:message_on_rout_proportion("ally_02_dead",0.99);

gb:message_on_all_messages_received("allies_weakened", "ally_01_weakened", "ally_02_weakened");
gb:message_on_all_messages_received("allies_weaker", "ally_01_weaker", "ally_02_weaker");

function spawn_labourers()
	ga_ally_reinforce:deploy_at_random_intervals_on_message(
		"labourers", 				-- message
		unit_count, 				-- min units
		unit_count, 				-- max units
		speed_01, 					-- min period
		speed_01, 					-- max period
		"allies_weaker", 			-- cancel message
		nil,						-- spawn first wave immediately
		true,						-- allow respawning
		nil,						-- survival battle wave index
		nil,						-- is final survival wave
		true						-- show debug output
	);
end

spawn_labourers()

ga_ally_reinforce:message_on_any_deployed("master_01_beasts_in");
ga_ally_reinforce:rush_on_message("master_01_beasts_in");

ga_ally_01:message_on_commander_death("ally_01_leader_dead");
ga_ally_02:message_on_commander_death("ally_02_leader_dead");

gb:message_on_all_messages_received("ally_leaders_dead", "ally_01_dead", "ally_02_dead");

gb:add_listener(
	"ally_leaders_dead",
	function()
		if ga_ally_01.sunits:are_any_active_on_battlefield() == true then
			ga_ally_01.sunits:rout_over_time(30000);
		end;

		if ga_ally_02.sunits:are_any_active_on_battlefield() == true then
			ga_ally_02.sunits:rout_over_time(30000);
		end;
		
		if ga_ally_reinforce.sunits:are_any_active_on_battlefield() == true then
			ga_ally_reinforce.sunits:rout_over_time(30000);
		end;
	end,
	true
);

-------------------------------------------------------------------------------------------------
------------------------------------------ENEMY ORDERS-------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_01:rush_on_message("start");
ga_ai_01:message_on_rout_proportion("chd_01_weakened",0.45);
ga_ai_01:message_on_rout_proportion("chd_01_dead",0.95);
ga_ai_01:rush_on_message("chd_01_weakened");

ga_ai_02:rush_on_message("start");
ga_ai_02:message_on_rout_proportion("chd_02_weakened",0.45);
ga_ai_02:message_on_rout_proportion("chd_02_dead",0.95);
ga_ai_02:rush_on_message("chd_02_weakened");

gb:message_on_all_messages_received("chd_dead", "chd_01_dead", "chd_02_dead");

-------------------------------------------------------------------------------------------------
--------------------------------------- OBJECTIVES & HINTS --------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_with_leader_on_message("objective_01", "wh3_dlc24_tze_changeling_theatre_scheme_darklands_objective_01");
gb:complete_objective_on_message("chd_dead", "wh3_dlc24_tze_changeling_theatre_scheme_darklands_objective_01");
gb:fail_objective_on_message("ally_leaders_dead", "wh3_dlc246_tze_changeling_theatre_scheme_darklands_objective_01")

gb:set_objective_with_leader_on_message("objective_02", "wh3_dlc24_tze_changeling_theatre_scheme_darklands_objective_02");
gb:complete_objective_on_message("chd_dead", "wh3_dlc24_tze_changeling_theatre_scheme_darklands_objective_02");

gb:queue_help_on_message("hint_01", "wh3_dlc24_tze_changeling_theatre_scheme_darklands_hint_01");
gb:queue_help_on_message("allies_weakened", "wh3_dlc24_tze_changeling_theatre_scheme_darklands_hint_02");
gb:queue_help_on_message("allies_weaker", "wh3_dlc24_tze_changeling_theatre_scheme_darklands_hint_03");
gb:queue_help_on_message("ally_leaders_dead", "wh3_dlc24_tze_changeling_theatre_scheme_darklands_hint_04");

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player_01:message_on_rout_proportion("player_dead",0.99);

gb:add_listener(
	"player_dead",
	function()
		if ga_ally_01.sunits:are_any_active_on_battlefield() == true then
			ga_ally_01.sunits:rout_over_time(5000);
		end;

		if ga_ally_02.sunits:are_any_active_on_battlefield() == true then
			ga_ally_02.sunits:rout_over_time(5000);
		end;
	end,
	true
);

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------

--ga_player_01:force_victory_on_message("end_this", 5000);
ga_ai_01:force_victory_on_message("player_dead", 5000);