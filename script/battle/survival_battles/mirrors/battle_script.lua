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

ga_ai_flow_01 = gb:get_army(gb:get_non_player_alliance_num(), "army_01_1");
ga_ai_flow_02 = gb:get_army(gb:get_non_player_alliance_num(), "army_01_2");
ga_ai_flow_03 = gb:get_army(gb:get_non_player_alliance_num(), "army_01_3");
ga_ai_flow_04 = gb:get_army(gb:get_non_player_alliance_num(), "army_01_4");
ga_ai_flow_05 = gb:get_army(gb:get_non_player_alliance_num(), "army_01_5");

ga_ai_flow_06 = gb:get_army(gb:get_non_player_alliance_num(), "army_02_1");
ga_ai_flow_07 = gb:get_army(gb:get_non_player_alliance_num(), "army_02_2");
ga_ai_flow_08 = gb:get_army(gb:get_non_player_alliance_num(), "army_02_3");
ga_ai_flow_09 = gb:get_army(gb:get_non_player_alliance_num(), "army_02_4");
ga_ai_flow_10 = gb:get_army(gb:get_non_player_alliance_num(), "army_02_5");

ga_ai_flow_01:get_army():suppress_reinforcement_adc(1);
ga_ai_flow_02:get_army():suppress_reinforcement_adc(1);
ga_ai_flow_03:get_army():suppress_reinforcement_adc(1);
ga_ai_flow_04:get_army():suppress_reinforcement_adc(1);
ga_ai_flow_05:get_army():suppress_reinforcement_adc(1);
ga_ai_flow_06:get_army():suppress_reinforcement_adc(1);
ga_ai_flow_07:get_army():suppress_reinforcement_adc(1);
ga_ai_flow_08:get_army():suppress_reinforcement_adc(1);
ga_ai_flow_09:get_army():suppress_reinforcement_adc(1);
ga_ai_flow_10:get_army():suppress_reinforcement_adc(1);

---------------------
-----Spawn Zones-----
---------------------

spawn_zone_1 = bm:get_spawn_zone_collection_by_name("spawn_01");
spawn_zone_2 = bm:get_spawn_zone_collection_by_name("spawn_02");
spawn_zone_3 = bm:get_spawn_zone_collection_by_name("spawn_03");
spawn_zone_4 = bm:get_spawn_zone_collection_by_name("spawn_04");
spawn_zone_5 = bm:get_spawn_zone_collection_by_name("spawn_05");
spawn_zone_all = bm:get_spawn_zone_collection_by_name("spawn_01", "spawn_02", "spawn_03", "spawn_04", "spawn_05");

------------------------
-----Reinforcements-----
------------------------

local reinforcements = bm:reinforcements();
reinforcements:set_cost_based_support_units_event("unlock_support_units_event_cp_1", 0, 999999);
local capture_point_01 = bm:capture_location_manager():capture_location_from_script_id("cp_vp");
reinforcements:link_support_units_event_with_capture_point("unlock_support_units_event_cp_1", capture_point_01);
gb:message_on_capture_location_capture_completed("cp_1_owned", "battle_start", "cp_vp", nil, ga_ai_def_01, ga_player_01);

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
	
	if (line:script_id() == "spawn_05") then
		line:enable_random_deployment_position();				
	end
end;

bm:print_toggle_slots()
bm:print_capture_locations()

---------------------------
-----Enemy Spawn Zones-----
---------------------------

------FLOW 01------
ga_ai_flow_01:assign_to_spawn_zone_from_collection_on_message("ai_wave_01", spawn_zone_all, false);
ga_ai_flow_01:message_on_number_deployed("flow_01_deployed", true, 1);
ga_ai_flow_01:assign_to_spawn_zone_from_collection_on_message("flow_01_deployed", spawn_zone_all, false);

------FLOW 02------
ga_ai_flow_02:assign_to_spawn_zone_from_collection_on_message("ai_wave_02", spawn_zone_all, false);
ga_ai_flow_02:message_on_number_deployed("flow_02_deployed", true, 1);
ga_ai_flow_02:assign_to_spawn_zone_from_collection_on_message("flow_02_deployed", spawn_zone_all, false);

------FLOW 03------
ga_ai_flow_03:assign_to_spawn_zone_from_collection_on_message("ai_wave_03", spawn_zone_all, false);
ga_ai_flow_03:message_on_number_deployed("flow_03_deployed", true, 1);
ga_ai_flow_03:assign_to_spawn_zone_from_collection_on_message("flow_03_deployed", spawn_zone_all, false);

------FLOW 04------
ga_ai_flow_04:assign_to_spawn_zone_from_collection_on_message("ai_wave_04", spawn_zone_all, false);
ga_ai_flow_04:message_on_number_deployed("flow_04_deployed", true, 1);
ga_ai_flow_04:assign_to_spawn_zone_from_collection_on_message("flow_04_deployed", spawn_zone_all, false);

------FLOW 05------
ga_ai_flow_05:assign_to_spawn_zone_from_collection_on_message("ai_wave_05", spawn_zone_all, false);
ga_ai_flow_05:message_on_number_deployed("flow_05_deployed", true, 1);
ga_ai_flow_05:assign_to_spawn_zone_from_collection_on_message("flow_05_deployed", spawn_zone_all, false);

------FLOW 06------
ga_ai_flow_06:assign_to_spawn_zone_from_collection_on_message("ai_wave_06", spawn_zone_all, false);
ga_ai_flow_06:message_on_number_deployed("flow_06_deployed", true, 1);
ga_ai_flow_06:assign_to_spawn_zone_from_collection_on_message("flow_06_deployed", spawn_zone_all, false);

------FLOW 07------
ga_ai_flow_07:assign_to_spawn_zone_from_collection_on_message("ai_wave_07", spawn_zone_all, false);
ga_ai_flow_07:message_on_number_deployed("flow_07_deployed", true, 1);
ga_ai_flow_07:assign_to_spawn_zone_from_collection_on_message("flow_07_deployed", spawn_zone_all, false);

------FLOW 08------
ga_ai_flow_08:assign_to_spawn_zone_from_collection_on_message("ai_wave_08", spawn_zone_all, false);
ga_ai_flow_08:message_on_number_deployed("flow_08_deployed", true, 1);
ga_ai_flow_08:assign_to_spawn_zone_from_collection_on_message("flow_08_deployed", spawn_zone_all, false);

------FLOW 09------
ga_ai_flow_09:assign_to_spawn_zone_from_collection_on_message("ai_wave_09", spawn_zone_all, false);
ga_ai_flow_09:message_on_number_deployed("flow_099_deployed", true, 1);
ga_ai_flow_09:assign_to_spawn_zone_from_collection_on_message("flow_09_deployed", spawn_zone_all, false);

------FLOW 10------
ga_ai_flow_10:assign_to_spawn_zone_from_collection_on_message("ai_wave_10", spawn_zone_all, false);
ga_ai_flow_10:message_on_number_deployed("flow_10_deployed", true, 1);
ga_ai_flow_10:assign_to_spawn_zone_from_collection_on_message("flow_10_deployed", spawn_zone_all, false);

---------------
-----SETUP-----
---------------

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("move", 500);
gb:message_on_time_offset("ai_wave_01", 1000);
gb:message_on_time_offset("ai_wave_02", 10000);
gb:message_on_time_offset("ai_wave_03", 100000);

local perpetual = true;
local shattered_only = false;
local permit_rampaging = true;

local speed_01 = 20000;
local speed_02 = 30000;
local speed_03 = 40000;
local speed_04 = 50000;
local speed_05 = 60000;

ga_player_01.sunits:set_always_visible_no_hidden_no_leave_battle(true);
ga_player_01.sunits:release_control();

-------DEFENDER 1-------

ga_ai_01:rush_on_message("move");

--------------------
-----FLOW WAVES-----
--------------------

---ARMY 1---

ga_ai_flow_01:deploy_at_random_intervals_on_message(
	"ai_wave_01", 				-- message
	1, 							-- min units
	1, 							-- max units
	speed_01, 						-- min period
	speed_01, 						-- max period
	nil, 						-- cancel message
	nil,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	true						-- show debug output
);

ga_ai_flow_01:message_on_any_deployed("flow_01_in");
ga_ai_flow_01:rush_on_message("flow_01_in");

ga_ai_flow_02:deploy_at_random_intervals_on_message(
	"ai_wave_02", 				-- message
	1, 							-- min units
	1, 							-- max units
	speed_02, 						-- min period
	speed_02, 						-- max period
	nil, 						-- cancel message
	nil,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_flow_02:message_on_any_deployed("flow_02_in");
ga_ai_flow_02:rush_on_message("flow_02_in");

ga_ai_flow_03:deploy_at_random_intervals_on_message(
	"ai_wave_03", 				-- message
	1, 							-- min units
	1, 							-- max units
	speed_03, 						-- min period
	speed_03, 						-- max period
	nil, 						-- cancel message
	nil,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_flow_03:message_on_any_deployed("flow_03_in");
ga_ai_flow_03:rush_on_message("flow_03_in");

ga_ai_flow_04:deploy_at_random_intervals_on_message(
	"ai_wave_04", 				-- message
	1, 							-- min units
	1, 							-- max units
	speed_04, 						-- min period
	speed_04, 						-- max period
	nil, 						-- cancel message
	nil,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_flow_04:message_on_any_deployed("flow_04_in");
ga_ai_flow_04:rush_on_message("flow_04_in");

ga_ai_flow_05:deploy_at_random_intervals_on_message(
	"ai_wave_05", 				-- message
	1, 							-- min units
	1, 							-- max units
	speed_05, 						-- min period
	speed_05, 						-- max period
	nil, 						-- cancel message
	nil,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_flow_05:message_on_any_deployed("flow_05_in");
ga_ai_flow_05:rush_on_message("flow_05_in");

---ARMY 2---

ga_ai_flow_06:deploy_at_random_intervals_on_message(
	"ai_wave_06", 				-- message
	1, 							-- min units
	1, 							-- max units
	speed_01, 						-- min period
	speed_01, 						-- max period
	nil, 						-- cancel message
	nil,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);



ga_ai_flow_06:message_on_any_deployed("flow_06_in");
ga_ai_flow_06:rush_on_message("flow_06_in");

ga_ai_flow_07:deploy_at_random_intervals_on_message(
	"ai_wave_07", 				-- message
	1, 							-- min units
	1, 							-- max units
	speed_02, 						-- min period
	speed_02, 						-- max period
	nil, 						-- cancel message
	nil,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_flow_07:message_on_any_deployed("flow_07_in");
ga_ai_flow_07:rush_on_message("flow_07_in");

ga_ai_flow_08:deploy_at_random_intervals_on_message(
	"ai_wave_08", 				-- message
	1, 							-- min units
	1, 							-- max units
	speed_03, 						-- min period
	speed_03, 						-- max period
	nil, 						-- cancel message
	nil,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_flow_08:message_on_any_deployed("flow_08_in");
ga_ai_flow_08:rush_on_message("flow_08_in");

ga_ai_flow_09:deploy_at_random_intervals_on_message(
	"ai_wave_09", 				-- message
	1, 							-- min units
	1, 							-- max units
	speed_04, 						-- min period
	speed_04, 						-- max period
	nil, 						-- cancel message
	nil,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_flow_09:message_on_any_deployed("flow_09_in");
ga_ai_flow_09:rush_on_message("flow_09_in");

ga_ai_flow_10:deploy_at_random_intervals_on_message(
	"ai_wave_10", 				-- message
	1, 							-- min units
	1, 							-- max units
	speed_05, 						-- min period
	speed_05, 						-- max period
	nil, 						-- cancel message
	nil,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_flow_10:message_on_any_deployed("flow_10_in");
ga_ai_flow_10:rush_on_message("flow_10_in");