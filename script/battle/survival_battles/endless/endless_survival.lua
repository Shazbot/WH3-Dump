load_script_libraries();

bm = battle_manager:new(empire_battle:new());

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                     	-- prevent deployment for ai
	nil,      									-- intro cutscene function
	false                                      	-- debug mode
);

---------------------------
----HARD SCRIPT VERSION----
---------------------------

bm:notify_survival_started();
bm:force_cant_chase_down_routers();
bm:notify_survival_total_waves(4);

local sm = get_messager();
survival_mode = {};

-------------------------------------------------------------------------------------------------
-------------------------------------------ARMY SETUP--------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);

ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), "start");

ga_ai_flow_01 = gb:get_army(gb:get_non_player_alliance_num(), "flow_01");
ga_ai_flow_02 = gb:get_army(gb:get_non_player_alliance_num(), "flow_02");
ga_ai_flow_03 = gb:get_army(gb:get_non_player_alliance_num(), "flow_03");
ga_ai_flow_04 = gb:get_army(gb:get_non_player_alliance_num(), "flow_04");
ga_ai_flow_05 = gb:get_army(gb:get_non_player_alliance_num(), "flow_05");
ga_ai_flow_06 = gb:get_army(gb:get_non_player_alliance_num(), "flow_06");
ga_ai_flow_07 = gb:get_army(gb:get_non_player_alliance_num(), "flow_07");
ga_ai_flow_08 = gb:get_army(gb:get_non_player_alliance_num(), "flow_08");
ga_ai_flow_09 = gb:get_army(gb:get_non_player_alliance_num(), "flow_09");
ga_ai_flow_10 = gb:get_army(gb:get_non_player_alliance_num(), "flow_10");

ga_ai_flow_lords = gb:get_army(gb:get_non_player_alliance_num(), "lords");

ga_ai_flow_01:get_army():suppress_reinforcement_adc(0);
ga_ai_flow_02:get_army():suppress_reinforcement_adc(0);
ga_ai_flow_03:get_army():suppress_reinforcement_adc(0);
ga_ai_flow_04:get_army():suppress_reinforcement_adc(0);
ga_ai_flow_05:get_army():suppress_reinforcement_adc(0);
ga_ai_flow_06:get_army():suppress_reinforcement_adc(0);
ga_ai_flow_07:get_army():suppress_reinforcement_adc(0);
ga_ai_flow_08:get_army():suppress_reinforcement_adc(0);
ga_ai_flow_09:get_army():suppress_reinforcement_adc(0);
ga_ai_flow_10:get_army():suppress_reinforcement_adc(0);

---------------------
-----Spawn Zones-----
---------------------

spawn_zone_1 = bm:get_spawn_zone_collection_by_name("spawn_01");
spawn_zone_2 = bm:get_spawn_zone_collection_by_name("spawn_02");
spawn_zone_3 = bm:get_spawn_zone_collection_by_name("spawn_03");
spawn_zone_4 = bm:get_spawn_zone_collection_by_name("spawn_04");
spawn_zone_all = bm:get_spawn_zone_collection_by_name("spawn_01", "spawn_02", "spawn_03", "spawn_04");

------------------------
-----Reinforcements-----
------------------------

local reinforcements = bm:reinforcements();
local capture_point_01 = bm:capture_location_manager():capture_location_from_script_id("cp_vp");

reinforcements:link_support_units_event_with_capture_point("unlock_support_units_event_cp_1", capture_point_01);
reinforcements:set_cost_based_support_units_event("unlock_support_units_event_cp_1", 0, 999999);
gb:message_on_capture_location_capture_completed("cp_1_owned", "battle_start", "cp_vp", nil, ga_ai_01, ga_player_01);

gb:add_listener(
	"start",
	function()
		reinforcements:unlock_support_units_event("unlock_support_units_event_cp_1");
	end
);

for i = 1, reinforcements:attacker_reinforcement_lines_count() do
	
	local line = reinforcements:attacker_reinforcement_line(i);
	
	if (line:script_id() == "spawn_01") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "spawn_02") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "spawn_03") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "spawn_04") then
		line:enable_random_deployment_position();				
	end
end;

bm:print_toggle_slots()
bm:print_capture_locations()

---------------------------
-----Enemy Spawn Zones-----
---------------------------

------FLOW 01------
ga_ai_flow_01:assign_to_spawn_zone_from_collection_on_message("ai_wave_01", spawn_zone_1, false);
ga_ai_flow_01:message_on_number_deployed("flow_01_deployed", true, 1);
ga_ai_flow_01:assign_to_spawn_zone_from_collection_on_message("flow_01_deployed", spawn_zone_1, false);

------FLOW 02------
ga_ai_flow_02:assign_to_spawn_zone_from_collection_on_message("ai_wave_02", spawn_zone_1, false);
ga_ai_flow_02:message_on_number_deployed("flow_02_deployed", true, 1);
ga_ai_flow_02:assign_to_spawn_zone_from_collection_on_message("flow_02_deployed", spawn_zone_1, false);

------FLOW 03------
ga_ai_flow_03:assign_to_spawn_zone_from_collection_on_message("ai_wave_03", spawn_zone_1, false);
ga_ai_flow_03:message_on_number_deployed("flow_03_deployed", true, 1);
ga_ai_flow_03:assign_to_spawn_zone_from_collection_on_message("flow_03_deployed", spawn_zone_1, false);

------FLOW 04------
ga_ai_flow_04:assign_to_spawn_zone_from_collection_on_message("ai_wave_04", spawn_zone_2, false);
ga_ai_flow_04:message_on_number_deployed("flow_04_deployed", true, 1);
ga_ai_flow_04:assign_to_spawn_zone_from_collection_on_message("flow_04_deployed", spawn_zone_2, false);

------FLOW 05------
ga_ai_flow_05:assign_to_spawn_zone_from_collection_on_message("ai_wave_05", spawn_zone_2, false);
ga_ai_flow_05:message_on_number_deployed("flow_05_deployed", true, 1);
ga_ai_flow_05:assign_to_spawn_zone_from_collection_on_message("flow_05_deployed", spawn_zone_2, false);

------FLOW 06------
ga_ai_flow_06:assign_to_spawn_zone_from_collection_on_message("ai_wave_06", spawn_zone_2, false);
ga_ai_flow_06:message_on_number_deployed("flow_06_deployed", true, 1);
ga_ai_flow_06:assign_to_spawn_zone_from_collection_on_message("flow_06_deployed", spawn_zone_2, false);

------FLOW 07------
ga_ai_flow_07:assign_to_spawn_zone_from_collection_on_message("ai_wave_07", spawn_zone_3, false);
ga_ai_flow_07:message_on_number_deployed("flow_07_deployed", true, 1);
ga_ai_flow_07:assign_to_spawn_zone_from_collection_on_message("flow_07_deployed", spawn_zone_3, false);

------FLOW 08------
ga_ai_flow_08:assign_to_spawn_zone_from_collection_on_message("ai_wave_08", spawn_zone_3, false);
ga_ai_flow_08:message_on_number_deployed("flow_08_deployed", true, 1);
ga_ai_flow_08:assign_to_spawn_zone_from_collection_on_message("flow_08_deployed", spawn_zone_3, false);

------FLOW 09------
ga_ai_flow_09:assign_to_spawn_zone_from_collection_on_message("ai_wave_09", spawn_zone_3, false);
ga_ai_flow_09:message_on_number_deployed("flow_099_deployed", true, 1);
ga_ai_flow_09:assign_to_spawn_zone_from_collection_on_message("flow_09_deployed", spawn_zone_3, false);

------FLOW 10------
ga_ai_flow_10:assign_to_spawn_zone_from_collection_on_message("ai_wave_10", spawn_zone_4, false);
ga_ai_flow_10:message_on_number_deployed("flow_10_deployed", true, 1);
ga_ai_flow_10:assign_to_spawn_zone_from_collection_on_message("flow_10_deployed", spawn_zone_4, false);

-------LORDS-------
ga_ai_flow_lords:assign_to_spawn_zone_from_collection_on_message("ai_wave_lords", spawn_zone_4, false);
ga_ai_flow_lords:message_on_number_deployed("lord_deployed", true, 1);
ga_ai_flow_lords:assign_to_spawn_zone_from_collection_on_message("lord_deployed", spawn_zone_4, false);

---------------
-----SETUP-----
---------------

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("ai_wave_01", 10000);
gb:message_on_time_offset("ai_wave_02", 20000);
gb:message_on_time_offset("ai_wave_03", 30000);
gb:message_on_time_offset("ai_wave_04", 40000);
gb:message_on_time_offset("ai_wave_05", 50000);
gb:message_on_time_offset("ai_wave_06", 60000);
gb:message_on_time_offset("ai_wave_07", 70000);
gb:message_on_time_offset("ai_wave_08", 80000);
gb:message_on_time_offset("ai_wave_09", 90000);
gb:message_on_time_offset("ai_wave_10", 100000);
gb:message_on_time_offset("ai_wave_lords", 120000);


local speed_01 = 40000;
local speed_02 = 60000;
local speed_03 = 80000;
local speed_04 = 110000;
local speed_05 = 130000;
local speed_06 = 150000;
local speed_07 = 180000;
local speed_08 = 200000;
local speed_09 = 220000;
local speed_10 = 240000;
local speed_lords = 300000;

local units_01 = 1;
local units_02 = 1;
local units_03 = 1;
local units_04 = 1;

local perpetual = true;
local shattered_only = true;
local permit_rampaging = true;

-------DEFENDER 1-------
ga_ai_01:rush_on_message("start");

--------------------
-----FLOW WAVES-----
--------------------

gb:message_on_time_offset("battle_started", 1000);
gb:message_on_time_offset("time_loop", 5000, "battle_started");

gb:message_on_time_offset("prevent_rallying", 15000, "time_loop");
gb:message_on_time_offset("time_loop", 15000, "prevent_rallying");

gb:add_listener(
	"prevent_rallying",
	function()
		ga_ai_01.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_flow_01.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_flow_02.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_flow_03.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_flow_04.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_flow_05.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_flow_06.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_flow_07.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_flow_08.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_flow_09.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
		ga_ai_flow_10.sunits:prevent_rallying_if_routing(perpetual,shattered_only,permit_rampaging);
	end
);

function spawn_flow_01()
	ga_ai_flow_01:deploy_at_random_intervals_on_message(
		"ai_wave_01", 				-- message
		units_01, 							-- min units
		units_01, 							-- max units
		speed_01, 						-- min period
		speed_01, 						-- max period
		nil, 						-- cancel message
		nil,						-- spawn first wave immediately
		true,						-- allow respawning
		nil,						-- survival battle wave index
		nil,						-- is final survival wave
		true						-- show debug output
	);
end

ga_ai_flow_01:message_on_any_deployed("flow_01_in");
ga_ai_flow_01:rush_on_message("flow_01_in");

function spawn_flow_02()
	ga_ai_flow_02:deploy_at_random_intervals_on_message(
		"ai_wave_02", 				-- message
		units_01, 							-- min units
		units_01, 							-- max units
		speed_02, 						-- min period
		speed_02, 						-- max period
		nil, 						-- cancel message
		nil,						-- spawn first wave immediately
		true,						-- allow respawning
		nil,						-- survival battle wave index
		nil,						-- is final survival wave
		true						-- show debug output
	);
end

ga_ai_flow_02:message_on_any_deployed("flow_02_in");
ga_ai_flow_02:rush_on_message("flow_02_in");

function spawn_flow_03()
	ga_ai_flow_03:deploy_at_random_intervals_on_message(
		"ai_wave_03", 				-- message
		units_01, 							-- min units
		units_01, 							-- max units
		speed_03, 						-- min period
		speed_03, 						-- max period
		nil, 						-- cancel message
		nil,						-- spawn first wave immediately
		true,						-- allow respawning
		nil,						-- survival battle wave index
		nil,						-- is final survival wave
		true						-- show debug output
	);
end

ga_ai_flow_03:message_on_any_deployed("flow_03_in");
ga_ai_flow_03:rush_on_message("flow_03_in");

function spawn_flow_04()
	ga_ai_flow_04:deploy_at_random_intervals_on_message(
		"ai_wave_04", 				-- message
		units_02, 							-- min units
		units_02, 							-- max units
		speed_04, 						-- min period
		speed_04, 						-- max period
		nil, 						-- cancel message
		nil,						-- spawn first wave immediately
		true,						-- allow respawning
		nil,						-- survival battle wave index
		nil,						-- is final survival wave
		true						-- show debug output
	);
end

ga_ai_flow_04:message_on_any_deployed("flow_04_in");
ga_ai_flow_04:rush_on_message("flow_04_in");

function spawn_flow_05()
	ga_ai_flow_05:deploy_at_random_intervals_on_message(
		"ai_wave_05", 				-- message
		units_02, 							-- min units
		units_02, 							-- max units
		speed_05, 						-- min period
		speed_05, 						-- max period
		nil, 						-- cancel message
		nil,						-- spawn first wave immediately
		true,						-- allow respawning
		nil,						-- survival battle wave index
		nil,						-- is final survival wave
		true						-- show debug output
	);
end

ga_ai_flow_05:message_on_any_deployed("flow_05_in");
ga_ai_flow_05:rush_on_message("flow_05_in");

function spawn_flow_06()
	ga_ai_flow_06:deploy_at_random_intervals_on_message(
		"ai_wave_06", 				-- message
		units_02, 							-- min units
		units_02, 							-- max units
		speed_06, 						-- min period
		speed_06, 						-- max period
		nil, 						-- cancel message
		nil,						-- spawn first wave immediately
		true,						-- allow respawning
		nil,						-- survival battle wave index
		nil,						-- is final survival wave
		true						-- show debug output
	);
end

ga_ai_flow_06:message_on_any_deployed("flow_06_in");
ga_ai_flow_06:rush_on_message("flow_06_in");

function spawn_flow_07()
	ga_ai_flow_07:deploy_at_random_intervals_on_message(
		"ai_wave_07", 				-- message
		units_03, 							-- min units
		units_03, 							-- max units
		speed_07, 						-- min period
		speed_07, 						-- max period
		nil, 						-- cancel message
		nil,						-- spawn first wave immediately
		true,						-- allow respawning
		nil,						-- survival battle wave index
		nil,						-- is final survival wave
		true						-- show debug output
	);
end

ga_ai_flow_07:message_on_any_deployed("flow_07_in");
ga_ai_flow_07:rush_on_message("flow_07_in");

function spawn_flow_08()
	ga_ai_flow_08:deploy_at_random_intervals_on_message(
		"ai_wave_08", 				-- message
		units_03, 							-- min units
		units_03, 							-- max units
		speed_08, 						-- min period
		speed_08, 						-- max period
		nil, 						-- cancel message
		nil,						-- spawn first wave immediately
		true,						-- allow respawning
		nil,						-- survival battle wave index
		nil,						-- is final survival wave
		true						-- show debug output
	);
end

ga_ai_flow_08:message_on_any_deployed("flow_08_in");
ga_ai_flow_08:rush_on_message("flow_08_in");

function spawn_flow_09()
	ga_ai_flow_09:deploy_at_random_intervals_on_message(
		"ai_wave_09", 				-- message
		units_03, 							-- min units
		units_03, 							-- max units
		speed_09, 						-- min period
		speed_09, 						-- max period
		nil, 						-- cancel message
		nil,						-- spawn first wave immediately
		true,						-- allow respawning
		nil,						-- survival battle wave index
		nil,						-- is final survival wave
		true						-- show debug output
	);
end

ga_ai_flow_09:message_on_any_deployed("flow_09_in");
ga_ai_flow_09:rush_on_message("flow_09_in");

function spawn_flow_10()
	ga_ai_flow_10:deploy_at_random_intervals_on_message(
		"ai_wave_10", 				-- message
		units_04, 							-- min units
		units_04, 							-- max units
		speed_10, 						-- min period
		speed_10, 						-- max period
		nil, 						-- cancel message
		nil,						-- spawn first wave immediately
		true,						-- allow respawning
		nil,						-- survival battle wave index
		nil,						-- is final survival wave
		true						-- show debug output
	);
end

ga_ai_flow_10:message_on_any_deployed("flow_10_in");
ga_ai_flow_10:rush_on_message("flow_10_in");

function spawn_flow_lords()
	ga_ai_flow_lords:deploy_at_random_intervals_on_message(
		"ai_wave_lords", 				-- message
		1, 							-- min units
		1, 							-- max units
		speed_lords, 						-- min period
		speed_lords, 						-- max period
		nil, 						-- cancel message
		nil,						-- spawn first wave immediately
		false,						-- allow respawning
		nil,						-- survival battle wave index
		nil,						-- is final survival wave
		true						-- show debug output
	);
end

ga_ai_flow_lords:message_on_any_deployed("lord_in");
ga_ai_flow_lords:rush_on_message("lord_in");

---------------------
-----MULTIPLAYER-----
---------------------

local armies_player = bm:alliances():item(1):armies()

---------------------
----SINGLE PLAYER----
---------------------

function update_reinforcement_rate_1_player()
	spawn_flow_01()
	spawn_flow_02()
	spawn_flow_03()
	spawn_flow_04()
	spawn_flow_05()
	spawn_flow_06()
	spawn_flow_07()
	spawn_flow_08()
	spawn_flow_09()
	spawn_flow_10()
	spawn_flow_lords()

	bm:out("Using 1 player reinforcement rates")
end

if armies_player:count() == 1 then
	bm:out("Number of players in the alliance: " .. armies_player:count())
	bm:out("You are alone!")
	update_reinforcement_rate_1_player()
end

---------------------
------2 PLAYERS------
---------------------

function update_reinforcement_rate_2_player()
	speed_01 = 35000;
	speed_02 = 55000;
	speed_03 = 75000;
	speed_04 = 105000;
	speed_05 = 125000;
	speed_06 = 145000;
	speed_07 = 175000;
	speed_08 = 195000;
	speed_09 = 215000;
	speed_10 = 235000;
	speed_lords = 270000;

	spawn_flow_01()
	spawn_flow_02()
	spawn_flow_03()
	spawn_flow_04()
	spawn_flow_05()
	spawn_flow_06()
	spawn_flow_07()
	spawn_flow_08()
	spawn_flow_09()
	spawn_flow_10()
	spawn_flow_lords()

	bm:out("Using 2 player reinforcement rates")
end

if armies_player:count() == 2 then
	bm:out("Number of players in the alliance: " .. armies_player:count())
	bm:out("We are 2 strong!")
	update_reinforcement_rate_2_player()
end

---------------------
------3 PLAYERS------
---------------------

function update_reinforcement_rate_3_player()
	speed_01 = 30000;
	speed_02 = 50000;
	speed_03 = 70000;
	speed_04 = 95000;
	speed_05 = 115000;
	speed_06 = 135000;
	speed_07 = 165000;
	speed_08 = 180000;
	speed_09 = 200000;
	speed_10 = 220000;
	speed_lords = 240000;

	spawn_flow_01()
	spawn_flow_02()
	spawn_flow_03()
	spawn_flow_04()
	spawn_flow_05()
	spawn_flow_06()
	spawn_flow_07()
	spawn_flow_08()
	spawn_flow_09()
	spawn_flow_10()
	spawn_flow_lords()

	bm:out("Using 3 player reinforcement rates")
end

if armies_player:count() == 3 then
	bm:out("Number of players in the alliance: " .. armies_player:count())
	bm:out("We are 3 strong!")
	update_reinforcement_rate_3_player()
end

---------------------
------4 PLAYERS------
---------------------

function update_reinforcement_rate_4_player()
	speed_01 = 20000;
	speed_02 = 40000;
	speed_03 = 60000;
	speed_04 = 85000;
	speed_05 = 105000;
	speed_06 = 125000;
	speed_07 = 155000;
	speed_08 = 170000;
	speed_09 = 190000;
	speed_10 = 210000;
	speed_lords = 210000;

	spawn_flow_01()
	spawn_flow_02()
	spawn_flow_03()
	spawn_flow_04()
	spawn_flow_05()
	spawn_flow_06()
	spawn_flow_07()
	spawn_flow_08()
	spawn_flow_09()
	spawn_flow_10()
	spawn_flow_lords()

	bm:out("Using 4 player reinforcement rates")
end

if armies_player:count() == 4 then
	bm:out("Number of players in the alliance: " .. armies_player:count())
	bm:out("We are 4 strong!")
	update_reinforcement_rate_4_player()
end

	bm:out("speed 01 is now: " ..speed_01)
	bm:out("speed 02 is now: " ..speed_02)
	bm:out("speed 03 is now: " ..speed_03)
	bm:out("speed 04 is now: " ..speed_04)
	bm:out("speed 05 is now: " ..speed_05)
	bm:out("speed 06 is now: " ..speed_06)
	bm:out("speed 07 is now: " ..speed_07)
	bm:out("speed 08 is now: " ..speed_08)
	bm:out("speed 09 is now: " ..speed_09)
	bm:out("speed 10 is now: " ..speed_10)
	bm:out("speed lords is now: " ..speed_lords)

--------------------------
------MINUTE MARKERS------
--------------------------

gb:message_on_time_offset("minute_marker_05", 300000);
gb:message_on_time_offset("minute_marker_10", 600000);
gb:message_on_time_offset("minute_marker_15", 900000);
gb:message_on_time_offset("minute_marker_20", 1200000);
gb:message_on_time_offset("minute_marker_25", 1500000);
gb:message_on_time_offset("minute_marker_30", 1800000);
gb:message_on_time_offset("minute_marker_35", 2100000);
gb:message_on_time_offset("minute_marker_40", 2400000);

function update_enemy_reinforcement_rate()
	if armies_player:count() == 1 then
		update_reinforcement_rate_1_player()
	elseif
		armies_player:count() == 2 then
		update_reinforcement_rate_2_player()
	elseif
		armies_player:count() == 3 then
		update_reinforcement_rate_3_player()
	elseif
		armies_player:count() == 4 then
		update_reinforcement_rate_4_player()
	end

	bm:out("Armies 1-3 are spawning this many units: " ..units_01)
	bm:out("Armies 4-6 are spawning this many units: " ..units_02)
	bm:out("Armies 7-9 are spawning this many units: " ..units_03)
	bm:out("Army 10 is spawning this many units: " ..units_04)
end

gb:add_listener(
	"minute_marker_05",
	function()
		units_01 = 2;
		units_02 = 2;
		units_03 = 1;
		units_04 = 1;

		update_enemy_reinforcement_rate()
	end,
	true
);

gb:add_listener(
	"minute_marker_10",
	function()
		units_01 = 2;
		units_02 = 2;
		units_03 = 2;
		units_04 = 2;

		update_enemy_reinforcement_rate()
	end,
	true
);

gb:add_listener(
	"minute_marker_15",
	function()
		units_01 = 3;
		units_02 = 3;
		units_03 = 2;
		units_04 = 2;

		update_enemy_reinforcement_rate()
	end,
	true
);

gb:add_listener(
	"minute_marker_20",
	function()
		units_01 = 3;
		units_02 = 3;
		units_03 = 3;
		units_04 = 3;

		update_enemy_reinforcement_rate()
	end,
	true
);

gb:add_listener(
	"minute_marker_25",
	function()
		units_01 = 4;
		units_02 = 4;
		units_03 = 3;
		units_04 = 3;

		update_enemy_reinforcement_rate()
	end,
	true
);

gb:add_listener(
	"minute_marker_30",
	function()
		units_01 = 4;
		units_02 = 4;
		units_03 = 4;
		units_04 = 4;

		update_enemy_reinforcement_rate()
	end,
	true
);

gb:add_listener(
	"minute_marker_35",
	function()
		units_01 = 5;
		units_02 = 5;
		units_03 = 4;
		units_04 = 4;

		update_enemy_reinforcement_rate()
	end,
	true
);

gb:add_listener(
	"minute_marker_40",
	function()
		units_01 = 5;
		units_02 = 5;
		units_03 = 5;
		units_04 = 5;

		update_enemy_reinforcement_rate()
	end,
	true
);