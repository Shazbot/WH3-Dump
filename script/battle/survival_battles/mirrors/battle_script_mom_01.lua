load_script_libraries();

bm = battle_manager:new(empire_battle:new());

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	true,                                     	-- prevent deployment for ai
	function() play_intro_cutscene() end,      	-- intro cutscene function
	false                                      	-- debug mode
);

---------------------------
----HARD SCRIPT VERSION----
---------------------------

bm:notify_survival_started();
bm:force_cant_chase_down_routers();

local sm = get_messager();
survival_mode = {};

intro_cinematic_file = "script\\battle\\survival_battles\\_cutscene\\managers\\mom_trial01_m01.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);

gb:set_cutscene_during_deployment(true);

-------------------------------------------------------------------------------------------------
-------------------------------------------ARMY SETUP--------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);

ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(), "start");

ga_ai_flow_01 = gb:get_army(gb:get_non_player_alliance_num(), "army_01");
ga_ai_flow_02 = gb:get_army(gb:get_non_player_alliance_num(), "army_02");
ga_ai_flow_03 = gb:get_army(gb:get_non_player_alliance_num(), "army_03");
ga_ai_flow_04 = gb:get_army(gb:get_non_player_alliance_num(), "army_04");
ga_ai_flow_05 = gb:get_army(gb:get_non_player_alliance_num(), "army_05");

ga_ai_flow_hero = gb:get_army(gb:get_non_player_alliance_num(), "hero");

player_lord = ga_player_01.sunits:item(1);
player_hero = ga_player_01.sunits:item(2);

enemy_lord = ga_ai_01.sunits:item(1);

ga_ai_flow_01:get_army():suppress_reinforcement_adc(1);
ga_ai_flow_02:get_army():suppress_reinforcement_adc(1);
ga_ai_flow_03:get_army():suppress_reinforcement_adc(1);
ga_ai_flow_04:get_army():suppress_reinforcement_adc(1);
ga_ai_flow_05:get_army():suppress_reinforcement_adc(1);

-------------------------------------------------------------------------------------------------
------------------------------------------ INTRO VO ---------------------------------------------
-------------------------------------------------------------------------------------------------

wh3_intro_sfx_00 = new_sfx("Play_Movie_WH3_DLC23_MOM_QB01_Black_Fire_Pass_Sweetener");

wh3_intro_sfx_01 = new_sfx("Play_wh3_MirrorsOfMadness_Narrator_Black_Fire_Pass_01");
wh3_intro_sfx_02 = new_sfx("Play_wh3_MirrorsOfMadness_Narrator_Black_Fire_Pass_02");
wh3_intro_sfx_03 = new_sfx("Play_wh3_MirrorsOfMadness_Narrator_Black_Fire_Pass_03");
wh3_intro_sfx_04 = new_sfx("Play_wh3_MirrorsOfMadness_Narrator_Black_Fire_Pass_04");

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO CUTSCENE -----------------------------------------
-------------------------------------------------------------------------------------------------

function play_intro_cutscene()
	
	local cam = bm:camera();

	cam:fade(false, 3);
	
	local cutscene_intro = cutscene:new_from_cindyscene(
        "cutscene_intro",
        ga_player_01.sunits,
        function() end_intro_cutscene() end,
        intro_cinematic_file,
        0,
        1
	);

	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()
			bm:stop_cindy_playback(true);
		end
	);

	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();

	cutscene_intro:action(
		function() 
			player_lord:set_enabled(false);
			player_hero:set_enabled(false);
		end, 
		10
	);

	cutscene_intro:action(
		function() 
			player_lord:set_enabled(true);
			player_hero:set_enabled(true);
		end, 
		15000
	);

	--Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh3_intro_sfx_00) end, 100);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_MirrorsOfMadness_Narrator_Black_Fire_Pass_01", 
			function()
				cutscene_intro:play_sound(wh3_intro_sfx_01);
				bm:show_subtitle("wh3_mom_intro_black_fire_pass_01", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_MirrorsOfMadness_Narrator_Black_Fire_Pass_02", 
			function()
				cutscene_intro:play_sound(wh3_intro_sfx_02);
				bm:show_subtitle("wh3_mom_intro_black_fire_pass_02", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_MirrorsOfMadness_Narrator_Black_Fire_Pass_03", 
			function()
				cutscene_intro:play_sound(wh3_intro_sfx_03);
				bm:show_subtitle("wh3_mom_intro_black_fire_pass_03", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_MirrorsOfMadness_Narrator_Black_Fire_Pass_04", 
			function()
				cutscene_intro:play_sound(wh3_intro_sfx_04);
				bm:show_subtitle("wh3_mom_intro_black_fire_pass_04", false, true);
			end
	);

	cutscene_intro:start();
end;

function end_intro_cutscene()
	player_lord:set_enabled(true);
	player_hero:set_enabled(true);
	ga_player_01.sunits:release_control()
	bm:hide_subtitles()
end;

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

--Defend the Shard of Tzeentch against the enemy!
gb:set_objective_on_message("start", "wh3_pro10_mom_qb_01_black_fire_pass_hints_main_objective");

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
ga_ai_flow_hero:assign_to_spawn_zone_from_collection_on_message("ai_wave_06", spawn_zone_all, false);
ga_ai_flow_hero:message_on_number_deployed("flow_06_deployed", true, 1);
ga_ai_flow_hero:assign_to_spawn_zone_from_collection_on_message("flow_06_deployed", spawn_zone_all, false);

---------------
-----SETUP-----
---------------

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("move", 500);
gb:message_on_time_offset("ai_wave_01", 10000);
gb:message_on_time_offset("ai_wave_02", 20000);
gb:message_on_time_offset("ai_wave_03", 30000);
gb:message_on_time_offset("ai_wave_04", 40000);
gb:message_on_time_offset("ai_wave_05", 50000);
gb:message_on_time_offset("ai_wave_06", 60000);

local perpetual = true;
local shattered_only = false;
local permit_rampaging = true;

local speed_01 = 7500;
local speed_02 = 10000;
local speed_03 = 12500;
local speed_04 = 15000;
local speed_05 = 20000;
local speed_06 = 90000;

ga_player_01.sunits:set_always_visible_no_hidden_no_leave_battle(true);
ga_player_01.sunits:release_control();

-------DEFENDER 1-------

ga_ai_01.sunits:set_always_visible_no_leave_battle(true);
enemy_lord:add_ping_icon(12);

ga_ai_01:rush_on_message("move");

--------------------
-----FLOW WAVES-----
--------------------

ga_ai_flow_01:deploy_at_random_intervals_on_message(
	"ai_wave_01", 				-- message
	1, 							-- min units
	1, 							-- max units
	speed_01, 					-- min period
	speed_01, 					-- max period
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
	speed_02, 					-- min period
	speed_02, 					-- max period
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
	speed_03, 					-- min period
	speed_03, 					-- max period
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
	speed_04, 					-- min period
	speed_04, 					-- max period
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
	speed_05, 					-- min period
	speed_05, 					-- max period
	nil, 						-- cancel message
	nil,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_flow_05:message_on_any_deployed("flow_05_in");
ga_ai_flow_05:rush_on_message("flow_05_in");

----------------------
------VISIBILITY------
----------------------

gb:add_listener(
	"flow_01_in",
	function()
		ga_ai_flow_01.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end,
	true
);

gb:add_listener(
	"flow_02_in",
	function()
		ga_ai_flow_02.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end,
	true
);

gb:add_listener(
	"flow_03_in",
	function()
		ga_ai_flow_03.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end,
	true
);

gb:add_listener(
	"flow_04_in",
	function()
		ga_ai_flow_04.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end,
	true
);

gb:add_listener(
	"flow_05_in",
	function()
		ga_ai_flow_05.sunits:set_always_visible_no_hidden_no_leave_battle(true);
	end,
	true
);

---------------------
-----ELITE UNITS-----
---------------------

ga_ai_flow_hero:deploy_at_random_intervals_on_message(
	"ai_wave_06", 				-- message
	1, 							-- min units
	1, 							-- max units
	speed_06, 					-- min period
	speed_06, 					-- max period
	nil, 						-- cancel message
	nil,						-- spawn first wave immediately
	true,						-- allow respawning
	nil,						-- survival battle wave index
	nil,						-- is final survival wave
	false						-- show debug output
);

ga_ai_flow_hero:message_on_any_deployed("flow_06_in");
ga_ai_flow_hero:rush_on_message("flow_06_in");

gb:add_listener(
	"flow_06_deployed",
	function()
		bm:callback(
			function() 
				if ga_ai_flow_hero.sunits:are_any_active_on_battlefield() == true then
					bm:out("I'm trying to add the icon to a hero");
					ga_ai_flow_hero.sunits:set_always_visible_no_leave_battle(true);
					ga_ai_flow_hero.sunits:add_ping_icon(12);
				end;
			end, 
			1000
		);
	end,
	true
);