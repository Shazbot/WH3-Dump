load_script_libraries();

bm = battle_manager:new(empire_battle:new());

--local cam = bm:camera();
bm:camera():fade(true, 0);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                     	-- prevent deployment for ai
	function() play_intro_cutscene() end,      -- intro cutscene function -- nil, --
	false                                      	-- debug mode
);

--bm.camera():change_height_range(0, 20);

---------------------------
----HARD SCRIPT VERSION----
---------------------------

num_waves_total = 0;
required_waves_kills = 4;

local sm = get_messager();
survival_mode = {};

intro_cinematic_file = "script\\battle\\survival_battles\\demo\\managers\\intro.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);

reveal_cinematic_file = "script\\battle\\survival_battles\\demo\\managers\\reveal.CindySceneManager";
--bm:cindy_preload(reveal_cinematic_file);

outro_cinematic_file = "script\\battle\\survival_battles\\demo\\managers\\outro.CindySceneManager";
--bm:cindy_preload(outro_cinematic_file);

-------------------------------------------------------------------------------------------------
-------------------------------------------ARMY SETUP--------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1, "player_start_01");
ga_player_02 = gb:get_army(gb:get_player_alliance_num(), 1, "player_reinforce_01");

ga_ai_def_01 = gb:get_army(gb:get_non_player_alliance_num(), "ai_def_01");
ga_ai_def_02 = gb:get_army(gb:get_non_player_alliance_num(), "ai_def_02");
ga_ai_def_03 = gb:get_army(gb:get_non_player_alliance_num(), "ai_def_03");

ga_ai_att_01 = gb:get_army(gb:get_non_player_alliance_num(), "ai_wave_01_1");
ga_ai_att_02 = gb:get_army(gb:get_non_player_alliance_num(), "ai_wave_01_2");
ga_ai_att_03 = gb:get_army(gb:get_non_player_alliance_num(), "ai_wave_01_3");

ga_ai_att_04 = gb:get_army(gb:get_non_player_alliance_num(), "ai_wave_02_1");
ga_ai_att_05 = gb:get_army(gb:get_non_player_alliance_num(), "ai_wave_02_2");
ga_ai_att_06 = gb:get_army(gb:get_non_player_alliance_num(), "ai_wave_02_3");

ga_ai_att_07 = gb:get_army(gb:get_non_player_alliance_num(), "ai_wave_03_1");
ga_ai_att_08 = gb:get_army(gb:get_non_player_alliance_num(), "ai_wave_03_2");
ga_ai_att_09 = gb:get_army(gb:get_non_player_alliance_num(), "ai_wave_03_3");

ga_ai_att_11 = gb:get_army(gb:get_non_player_alliance_num(), "ai_boss_1");
ga_ai_att_12 = gb:get_army(gb:get_non_player_alliance_num(), "ai_boss_2");

ga_ai_def_01:set_visible_to_all(true);

-- ga_ai_att_04:set_visible_to_all(true);
-- ga_ai_att_05:set_visible_to_all(true);
-- ga_ai_att_06:set_visible_to_all(true);

-- ga_ai_att_07:set_visible_to_all(true);
-- ga_ai_att_08:set_visible_to_all(true);
-- ga_ai_att_09:set_visible_to_all(true);

-- ga_ai_att_11:set_visible_to_all(true);
-- ga_ai_att_12:set_visible_to_all(true);

-- ga_player_01:set_visible_to_all(true);
-- ga_player_02:set_visible_to_all(true);

-- build spawn zone collections
sz_collection_1 = bm:get_spawn_zone_collection_by_name("attacker_stage_1");
sz_collection_2 = bm:get_spawn_zone_collection_by_name("attacker_stage_1", "attacker_stage_2");
sz_collection_3 = bm:get_spawn_zone_collection_by_name("attacker_stage_1", "attacker_stage_2", "attacker_stage_3");

sz_collection_4 = bm:get_spawn_zone_collection_by_name("attacker_stage_2");
sz_collection_5 = bm:get_spawn_zone_collection_by_name("attacker_stage_3");

-- assign reinforcement armies to spawn zones
bm:assign_army_to_spawn_zone_from_collection(ga_ai_att_01:get_army(), sz_collection_1, ga_ai_att_01.id);
bm:assign_army_to_spawn_zone_from_collection(ga_ai_att_02:get_army(), sz_collection_1, ga_ai_att_02.id);
bm:assign_army_to_spawn_zone_from_collection(ga_ai_att_03:get_army(), sz_collection_1, ga_ai_att_03.id);

bm:assign_army_to_spawn_zone_from_collection(ga_ai_att_04:get_army(), sz_collection_2, ga_ai_att_04.id);
bm:assign_army_to_spawn_zone_from_collection(ga_ai_att_05:get_army(), sz_collection_2, ga_ai_att_05.id);
bm:assign_army_to_spawn_zone_from_collection(ga_ai_att_06:get_army(), sz_collection_2, ga_ai_att_06.id);

bm:assign_army_to_spawn_zone_from_collection(ga_ai_att_07:get_army(), sz_collection_3, ga_ai_att_07.id);
bm:assign_army_to_spawn_zone_from_collection(ga_ai_att_08:get_army(), sz_collection_3, ga_ai_att_08.id);
bm:assign_army_to_spawn_zone_from_collection(ga_ai_att_09:get_army(), sz_collection_3, ga_ai_att_09.id);

bm:assign_army_to_spawn_zone_from_collection(ga_ai_def_02:get_army(), sz_collection_4, ga_ai_def_02.id);
bm:assign_army_to_spawn_zone_from_collection(ga_ai_def_03:get_army(), sz_collection_5, ga_ai_def_03.id);

-- make sure to create a set position for the boss please...

bm:assign_army_to_spawn_zone_from_collection(ga_ai_att_11:get_army(), sz_collection_5, ga_ai_att_11.id);
bm:assign_army_to_spawn_zone_from_collection(ga_ai_att_12:get_army(), sz_collection_3, ga_ai_att_12.id);

-- Example: Set random deployment position in a reinforcement line..

local reinforcements = bm:reinforcements();

for i = 1, reinforcements:attacker_reinforcement_lines_count() do
	
	local line = reinforcements:attacker_reinforcement_line(i);
	
	if (line:script_id() == "attacker_stage_1") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "attacker_stage_2") then
		line:enable_random_deployment_position();		
	end

	if (line:script_id() == "attacker_stage_3") then
		line:enable_random_deployment_position();		
	end
end;

bm:print_toggle_slots()

--ga_ai_def_01.sunits:set_invincible(true);

-------------------------------------------------------------------------------------------------
------------------------------------------ INTRO VO ---------------------------------------------
-------------------------------------------------------------------------------------------------

wh3_intro_sfx_01 = new_sfx("Play_wh3_khorne_demo_intro_survival_01");
wh3_intro_sfx_02 = new_sfx("Play_wh3_khorne_demo_intro_survival_02");
wh3_intro_sfx_03 = new_sfx("Play_wh3_khorne_demo_intro_survival_03");
wh3_intro_sfx_04 = new_sfx("Play_wh3_khorne_demo_intro_survival_04");

-------------------------------------------------------------------------------------------------
------------------------------------------ REVEAL VO --------------------------------------------
-------------------------------------------------------------------------------------------------

wh3_reveal_sfx_01 = new_sfx("Play_wh3_khorne_demo_reveal_survival_01");
wh3_reveal_sfx_02 = new_sfx("Play_wh3_khorne_demo_reveal_survival_02");
wh3_reveal_sfx_03 = new_sfx("Play_wh3_khorne_demo_reveal_survival_03");
wh3_reveal_sfx_04 = new_sfx("Play_wh3_khorne_demo_reveal_survival_04");
wh3_reveal_sfx_05 = new_sfx("Play_wh3_khorne_demo_reveal_survival_05");
wh3_reveal_sfx_06 = new_sfx("Play_wh3_khorne_demo_reveal_survival_06");

-------------------------------------------------------------------------------------------------
------------------------------------------ OUTRO VO ---------------------------------------------
-------------------------------------------------------------------------------------------------

wh3_outro_sfx_01 = new_sfx("Play_wh3_khorne_demo_outro_survival_01");

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO CUTSCENE -----------------------------------------
-------------------------------------------------------------------------------------------------

function play_intro_cutscene()
	
	local cam = bm:camera();

	cam:fade(false, 0);

	local intro_units_hidden = false;
	
	local cutscene_intro = cutscene:new_from_cindyscene(
        -- unique string name for cutscene
        "cutscene_intro",
        -- unitcontroller or scriptunits collection over player's army
        ga_player_01.sunits,
        -- end callback
        function() end_intro_cutscene() end,
        -- path to cindy scene
        "script\\battle\\survival_battles\\demo\\managers\\intro.CindySceneManager",
        -- optional fade in/fade out durations
        0,
        3
	);

	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()
			local cam = bm:camera();
			cam:fade(true, 0);
			bm:stop_cindy_playback(true);
			
			if intro_units_hidden then
				--ga_player_01:set_enabled(true)
				ga_player_01.sunits:set_enabled(true, false) 
				--ga_player_02.sunits:set_enabled(true, false) 
				ga_ai_def_01:set_enabled(true)
			end;

			bm:callback(function() cam:fade(false, 0.5) end, 3000);
		end
	);

	cutscene_intro:action(
		function()
			--bm:out("The script got here!")
			intro_units_hidden = true;
			--ga_player_01:set_enabled(false)
			ga_player_01.sunits:set_enabled(false, false) 
			--ga_player_02.sunits:set_enabled(false, false) 
			ga_ai_def_01:set_enabled(false) 
		end, 
		100
	);	
	cutscene_intro:action(
		function()
			--bm:out("The script got here!")
			intro_units_hidden = false;
			--ga_player_01:set_enabled(true) 
			ga_player_01.sunits:set_enabled(true, false) 
			--ga_player_02.sunits:set_enabled(true, false)
			ga_ai_def_01:set_enabled(true) 
		end, 
		30000
	);	

	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 0.5) end, 1000);

	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();

	--Voiceover and Subtitles --
	-- cutscene_intro:add_cinematic_trigger_listener("intro_VO_01", function()
	-- 	cutscene_intro:play_sound(wh3_intro_sfx_01)
	-- 	cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_intro_survival_01", "subtitle_with_frame", 2)
	-- 	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 5000);
	-- end);
	
	-- cutscene_intro:add_cinematic_trigger_listener("intro_VO_02", function()
	-- 	cutscene_intro:play_sound(wh3_intro_sfx_02)
	-- 	cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_intro_survival_02", "subtitle_with_frame", 2)
	-- 	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 5000);
	-- end);
	
	-- cutscene_intro:add_cinematic_trigger_listener("intro_VO_03", function()
	-- 	cutscene_intro:play_sound(wh3_intro_sfx_03)
	-- 	cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_intro_survival_03", "subtitle_with_frame", 2)
	-- 	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 5000);
	-- end);
	
	-- cutscene_intro:add_cinematic_trigger_listener("intro_VO_04", function()
	-- 	cutscene_intro:play_sound(wh3_intro_sfx_04)
	-- 	cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_intro_survival_04", "subtitle_with_frame", 2)
	-- 	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 5000);
	-- end);

	cutscene_intro:action(function() cutscene_intro:play_sound(wh3_intro_sfx_01) end, 100);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_intro_survival_01", "subtitle_with_frame", 2)	end, 200);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 5000);

	cutscene_intro:action(function() cutscene_intro:play_sound(wh3_intro_sfx_02) end, 5100);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_intro_survival_02", "subtitle_with_frame", 2)	end, 5200);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 10000);

	cutscene_intro:action(function() cutscene_intro:play_sound(wh3_intro_sfx_03) end, 10100);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_intro_survival_03", "subtitle_with_frame", 2)	end, 10200);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 15000);

	cutscene_intro:action(function() cutscene_intro:play_sound(wh3_intro_sfx_04) end, 15100);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_intro_survival_04", "subtitle_with_frame", 2)	end, 15200);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 20000);

	cutscene_intro:start()
end;

function end_intro_cutscene()
	gb.sm:trigger_message("intro_cutscene_end")
	bm:cindy_preload(reveal_cinematic_file);
end;

-------------------------------------------------------------------------------------------------
--------------------------------------- REVEAL CUTSCENE -----------------------------------------
-------------------------------------------------------------------------------------------------

function prepare_for_reveal_cutscene()
    --fade to black over 0.5 seconds
    bm:camera():fade(true, 0.5)

    -- play boss reveal cutscene after 1 second
    bm:callback(function() play_reveal_cutscene() end, 1000)
end

function play_reveal_cutscene()
	
	local cam_reveal = bm:camera();

	cam_reveal:fade(false, 0);

	local reveal_units_hidden = false;
		
	local cutscene_reveal = cutscene:new_from_cindyscene(
        -- unique string name for cutscene
        "cutscene_reveal",
        -- unitcontroller or scriptunits collection over player's army
        ga_player_01.sunits,
        -- end callback
        function() end_reveal_cutscene() end,
        -- path to cindy scene
        "script\\battle\\survival_battles\\demo\\managers\\reveal.CindySceneManager",
        -- optional fade in/fade out durations
        0,
        3
	);

	-- skip callback
	cutscene_reveal:set_skippable(
		true, 
		function()
			local cam_reveal = bm:camera();
			cam_reveal:fade(true, 0);
			bm:stop_cindy_playback(true);
			
			--if reveal_units_hidden then
				--ga_player_01:set_enabled(true)
				--ga_player_01.sunits:set_enabled(true, false) 
				--ga_player_02.sunits:set_enabled(true, false)
				--ga_player_02:set_enabled(true)
			--end;

			bm:callback(function() cam_reveal:fade(false, 0.5) end, 3000);
		end
	);

	cutscene_reveal:action(
		function()
			--bm:out("The script got here!")
			reveal_units_hidden = true;
			--ga_player_01:set_enabled(false) 
			--ga_player_01.sunits:set_enabled(false, false) 
			--ga_player_02.sunits:set_enabled(false, true)
			--ga_player_02:set_enabled(false) 
		end, 
		100
	);	
	cutscene_reveal:action(
		function()
			--bm:out("The script got here!")
			reveal_units_hidden = false;
			--ga_player_01:set_enabled(true) 
			--ga_player_01.sunits:set_enabled(true, false) 
			--ga_player_02.sunits:set_enabled(true, true) 
			--ga_player_02:set_enabled(true) 
		end, 
		20000
	);	

	-- Voiceover and Subtitles --
	cutscene_reveal:action(function() cutscene_reveal:play_sound(wh3_reveal_sfx_01) end, 100);	
	cutscene_reveal:action(function() cutscene_reveal:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_reveal_survival_01", "subtitle_with_frame", 2)	end, 200);	
	cutscene_reveal:action(function() cutscene_reveal:hide_custom_cutscene_subtitles() end, 5000);

	cutscene_reveal:action(function() cutscene_reveal:play_sound(wh3_reveal_sfx_02) end, 5100);	
	cutscene_reveal:action(function() cutscene_reveal:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_reveal_survival_02", "subtitle_with_frame", 2)	end, 5200);	
	cutscene_reveal:action(function() cutscene_reveal:hide_custom_cutscene_subtitles() end, 10000);

	cutscene_reveal:action(function() cutscene_reveal:play_sound(wh3_reveal_sfx_03) end, 10100);	
	cutscene_reveal:action(function() cutscene_reveal:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_reveal_survival_03", "subtitle_with_frame", 2)	end, 10200);	
	cutscene_reveal:action(function() cutscene_reveal:hide_custom_cutscene_subtitles() end, 15000);

	cutscene_reveal:action(function() cutscene_reveal:play_sound(wh3_reveal_sfx_04) end, 15100);	
	cutscene_reveal:action(function() cutscene_reveal:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_reveal_survival_04", "subtitle_with_frame", 2)	end, 15200);	
	cutscene_reveal:action(function() cutscene_reveal:hide_custom_cutscene_subtitles() end, 20000);

	cutscene_reveal:action(function() cutscene_reveal:play_sound(wh3_reveal_sfx_05) end, 20100);	
	cutscene_reveal:action(function() cutscene_reveal:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_reveal_survival_05", "subtitle_with_frame", 2)	end, 10200);	
	cutscene_reveal:action(function() cutscene_reveal:hide_custom_cutscene_subtitles() end, 25000);

	cutscene_reveal:action(function() cutscene_reveal:play_sound(wh3_reveal_sfx_06) end, 25100);	
	cutscene_reveal:action(function() cutscene_reveal:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_reveal_survival_06", "subtitle_with_frame", 2)	end, 15200);	
	cutscene_reveal:action(function() cutscene_reveal:hide_custom_cutscene_subtitles() end, 30000);

	cutscene_reveal:start()
end;

function end_reveal_cutscene()
	gb.sm:trigger_message("reveal_cutscene_end")
	bm:cindy_preload(outro_cinematic_file);
end;

-------------------------------------------------------------------------------------------------
---------------------------------------- OUTRO CUTSCENE -----------------------------------------
-------------------------------------------------------------------------------------------------

function prepare_for_outro_cutscene()
    --fade to black over 0.5 seconds
    bm:camera():fade(true, 0.5)

    -- play boss reveal cutscene after 1 second
    bm:callback(function() play_outro_cutscene() end, 1000)
end

function play_outro_cutscene()
	
	local cam = bm:camera();

	cam:fade(false, 0);

	local outro_units_hidden = false;
		
	local cutscene_outro = cutscene:new_from_cindyscene(
        -- unique string name for cutscene
        "cutscene_outro",
        -- unitcontroller or scriptunits collection over player's army
        ga_player_01.sunits,
        -- end callback
        function() end_outro_cutscene() end,
        -- path to cindy scene
        "script\\battle\\survival_battles\\demo\\managers\\outro.CindySceneManager",
        -- optional fade in/fade out durations
        0,
        3
	);

	-- skip callback
	cutscene_outro:set_skippable(
		true, 
		function()
			local cam = bm:camera();
			cam:fade(true, 0);
			bm:stop_cindy_playback(true);
			
			if outro_units_hidden then
				--ga_player_01:set_enabled(true)
				--ga_player_01.sunits:set_enabled(true, false) 
				--ga_player_02.sunits:set_enabled(true, false)
				--ga_player_02:set_enabled(true)
			end;

			bm:callback(function() cam:fade(false, 0.5) end, 3000);
		end
	);

	cutscene_outro:action(
		function()
			--bm:out("The script got here!")
			outro_units_hidden = true;
			--ga_player_01:set_enabled(false) 
			--ga_player_01.sunits:set_enabled(false, false) 
			--ga_player_02.sunits:set_enabled(false, true) 
			--ga_player_02:set_enabled(false) 
		end, 
		100
	);	
	cutscene_outro:action(
		function()
			--bm:out("The script got here!")
			outro_units_hidden = false;
			--ga_player_01:set_enabled(true) 
			--ga_player_01.sunits:set_enabled(true, false) 
			--ga_player_02.sunits:set_enabled(true, true) 
			--ga_player_02:set_enabled(true) 
		end, 
		20000
	);	

	-- Voiceover and Subtitles --
	cutscene_outro:action(function() cutscene_outro:play_sound(wh3_outro_sfx_01) end, 100);	
	cutscene_outro:action(function() cutscene_outro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_outro_survival_01", "subtitle_with_frame", 2)	end, 200);	
	cutscene_outro:action(function() cutscene_outro:hide_custom_cutscene_subtitles() end, 5000);

	cutscene_outro:start()
end;

function end_outro_cutscene()
	gb.sm:trigger_message("outro_cutscene_end")
	bm:camera():fade(true, 1)
	bm:end_battle();
end;

-------------------------------------------------------------------------------------------------
--------------------------------------------CUTSCENES--------------------------------------------
-------------------------------------------------------------------------------------------------

----- TESTING -----

--gb.sm:add_listener("wave_1_under_attack", function() prepare_for_reveal_cutscene() end)

--gb.sm:add_listener("wave_2_under_attack", function() prepare_for_outro_cutscene() end)

----- ACTUAL -----

gb.sm:add_listener("prepare_boss_reveal", function() prepare_for_reveal_cutscene() end);

gb.sm:add_listener("end_battle", function() prepare_for_outro_cutscene() end);

-------------------------------------------------------------------------------------------------
------------------------------------------ARMY TELEPORT------------------------------------------
-------------------------------------------------------------------------------------------------

function battle_start_teleport_units()
	--Based on Khorne Survival map
	bm:out("\tbattle_start_teleport_units() called");
	
	--Player Starting Units
	--teleport units of ga_player_01- e.g. [x ,z], [orientation of 180 degrees, width of 25m]
	
	ga_player_01.sunits:item(1).uc:teleport_to_location(v(3.61, -582.43), 0.0, 1.4); 
	ga_player_01.sunits:item(2).uc:teleport_to_location(v(3.61, -603.73), 0.0, 2.31);
	
	ga_player_01.sunits:item(3).uc:teleport_to_location(v(-25.11, -614.02), 0.0, 30.30);
	ga_player_01.sunits:item(4).uc:teleport_to_location(v(7.19, -614.02), 0.0, 30.30);
	ga_player_01.sunits:item(5).uc:teleport_to_location(v(39.49, -614.02), 0.0, 30.30);
	
	ga_player_01.sunits:item(6).uc:teleport_to_location(v(-29.73, -631.65), 0.0, 24.20); 
	ga_player_01.sunits:item(7).uc:teleport_to_location(v(-3.54, -631.65), 0.0, 24.20);
	ga_player_01.sunits:item(8).uc:teleport_to_location(v(22.66, -631.65), 0.0, 24.20);
	ga_player_01.sunits:item(9).uc:teleport_to_location(v(48.86, -631.65), 0.0, 24.20);
	
	ga_player_01.sunits:item(10).uc:teleport_to_location(v(-25.37, -581.65), 0.0, 31.31);
	ga_player_01.sunits:item(11).uc:teleport_to_location(v(34.38, -581.65), 0.0, 31.31); 
	
	ga_player_01.sunits:item(12).uc:teleport_to_location(v(-184.03, -587.64), 0.0, 40.40);
	ga_player_01.sunits:item(13).uc:teleport_to_location(v(3.61, -660.01), 0.0, 40.40);
	ga_player_01.sunits:item(14).uc:teleport_to_location(v(187.00, -587.64), 0.0, 40.40);
	
	ga_player_01.sunits:release_control();
	--ga_player_01.sunits:change_behaviour_active("skirmish", false);		
	end;

	gb.sm:add_listener("intro_cutscene_end", function() battle_start_teleport_units() end)

-------------------------------------------------------------------------------------------------
--------------------------------------------DEFENDERS--------------------------------------------
-------------------------------------------------------------------------------------------------

-------DEFENDER 1-------
	ga_ai_def_01.sunits:set_invincible(true);
	ga_ai_def_01:attack_force_on_message("intro_cutscene_end", ga_player_01);
	ga_ai_def_01:message_on_under_attack("def_1_under_attack");

	gb:add_listener(
	"def_1_under_attack",
	function()
		ga_ai_def_01.sunits:set_invincible(false);
		--gb:remove_listener("intro_cutscene_end");
	end,
	true
);

-------DEFENDER 2-------
ga_player_01:enable_map_barrier_on_message("ai_wave_02_1", "map_barrier_1_2", false);

gb:add_listener(
	"ai_wave_02_1",
	function()
		ga_ai_def_02:reinforce_on_message("ai_wave_02_1", 0, false);
		ga_ai_def_02:message_on_deployed("defend_02_in");
		ga_ai_def_02:attack_force_on_message("defend_02_in", ga_player_01);
		gb:remove_listener("ai_wave_02_1");
	end,
	true
);

-------DEFENDER 3-------
ga_player_01:enable_map_barrier_on_message("ai_wave_03_1", "map_barrier_2_3", false);

gb:add_listener(
	"ai_wave_03_1",
	function()
		ga_ai_def_03:reinforce_on_message("ai_wave_03_1", 0, false);
		ga_ai_def_03:message_on_deployed("defend_03_in");
		ga_ai_def_03:attack_force_on_message("defend_03_in", ga_player_01);
		gb:remove_listener("ai_wave_03_1");
	end,
	true
);

--gb:play_sound_on_message("01_intro_cutscene_end_vo", wh2_main_sfx_01_intro_cutscene_end, v(0,0), nil, nil, 5000);

--generated_army:get_casualty_rate()
--generated_army:get_rout_proportion()
--generated_army:get_shattered_proportion()

-------------------------------------------------------------------------------------------------
---------------------------------------------WAVE 1----------------------------------------------
-------------------------------------------------------------------------------------------------

show_attack_closest_unit_debug_output = false;

ga_ai_att_01:add_to_survival_battle_wave_on_message("ai_wave_01_1", 1, true);
ga_ai_att_02:add_to_survival_battle_wave_on_message("ai_wave_01_1", 1, false);
ga_ai_att_03:add_to_survival_battle_wave_on_message("ai_wave_01_1", 1, false);

-------WAVE 1.1-------
ga_ai_att_01:message_on_under_attack("wave_1_under_attack");

ga_ai_def_01:message_on_rout_proportion("ai_wave_01_1", 0.8);
ga_ai_att_01:deploy_at_random_intervals_on_message("ai_wave_01_1", 1, 2, 7500, 10000, nil, false);
gb:add_listener(
	"ai_wave_01_1",
	function()
		ga_ai_att_01.sunits:start_attack_closest_enemy(nil, show_attack_closest_unit_debug_output);
	end
);

-------WAVE 1.2-------
ga_ai_att_01:message_on_rout_proportion("ai_wave_01_2", 0.2);
ga_ai_att_02:deploy_at_random_intervals_on_message("ai_wave_01_2", 1, 1, 10000, 12500, nil, false);
gb:add_listener(
	"ai_wave_01_2",
	function()
		ga_ai_att_02.sunits:start_attack_closest_enemy(nil, show_attack_closest_unit_debug_output);
	end
);

-------WAVE 1.3-------
ga_ai_att_02:message_on_rout_proportion("ai_wave_01_2", 0.2);
ga_ai_att_03:deploy_at_random_intervals_on_message("ai_wave_01_2", 1, 1, 10000, 12500, nil, false);
gb:add_listener(
	"ai_wave_01_2",
	function()
		ga_ai_att_03.sunits:start_attack_closest_enemy(nil, show_attack_closest_unit_debug_output);
	end
);

-------------------------------------------------------------------------------------------------
---------------------------------------------WAVE 2----------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_att_04:add_to_survival_battle_wave_on_message("ai_wave_02_1", 2, true);
ga_ai_att_05:add_to_survival_battle_wave_on_message("ai_wave_02_1", 2, false);
ga_ai_att_06:add_to_survival_battle_wave_on_message("ai_wave_02_1", 2, false);

-------WAVE 2.1-------
ga_ai_att_04:message_on_under_attack("wave_2_under_attack");

ga_ai_att_03:message_on_rout_proportion("ai_wave_02_1", 0.8);
ga_ai_att_04:deploy_at_random_intervals_on_message("ai_wave_02_1", 1, 2, 7500, 10000, nil, false);
gb:add_listener(
	"ai_wave_02_1",
	function()
		ga_ai_att_04.sunits:start_attack_closest_enemy(nil, show_attack_closest_unit_debug_output);
	end
);

-------WAVE 2.2-------
ga_ai_att_04:message_on_rout_proportion("ai_wave_02_2", 0.2); 
ga_ai_att_05:deploy_at_random_intervals_on_message("ai_wave_02_2", 1, 1, 12500, 15000, nil, false);
gb:add_listener(
	"ai_wave_02_2",
	function()
		ga_ai_att_05.sunits:start_attack_closest_enemy(nil, show_attack_closest_unit_debug_output);
	end
);

-------WAVE 2.3-------
ga_ai_att_05:message_on_rout_proportion("ai_wave_02_3", 0.2); 
ga_ai_att_06:deploy_at_random_intervals_on_message("ai_wave_02_3", 1, 1, 12500, 15000, nil, false);
gb:add_listener(
	"ai_wave_02_3",
	function()
		ga_ai_att_06.sunits:start_attack_closest_enemy(nil, show_attack_closest_unit_debug_output);
	end
);

-------------------------------------------------------------------------------------------------
---------------------------------------------WAVE 3----------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_att_07:add_to_survival_battle_wave_on_message("ai_wave_03_1", 3, true);
ga_ai_att_08:add_to_survival_battle_wave_on_message("ai_wave_03_1", 3, false);
ga_ai_att_09:add_to_survival_battle_wave_on_message("ai_wave_03_1", 3, false);

-------WAVE 3.1-------
ga_ai_att_07:message_on_under_attack("wave_3_under_attack");

ga_ai_att_06:message_on_rout_proportion("ai_wave_03_1", 0.8);
ga_ai_att_07:deploy_at_random_intervals_on_message("ai_wave_03_1", 1, 2, 7500, 10000, nil, false);
gb:add_listener(
	"ai_wave_03_1",
	function()
		ga_ai_att_07.sunits:start_attack_closest_enemy(nil, show_attack_closest_unit_debug_output);
	end
);

-------WAVE 3.2-------
ga_ai_att_07:message_on_rout_proportion("ai_wave_03_2", 0.2); 
ga_ai_att_08:deploy_at_random_intervals_on_message("ai_wave_03_2", 1, 1, 12500, 15000, nil, false);
gb:add_listener(
	"ai_wave_03_2",
	function()
		ga_ai_att_08.sunits:start_attack_closest_enemy(nil, show_attack_closest_unit_debug_output);
	end
);

-------WAVE 3.3-------
ga_ai_att_08:message_on_rout_proportion("ai_wave_03_3", 0.2); 
ga_ai_att_09:deploy_at_random_intervals_on_message("ai_wave_03_3", 1, 1, 12500, 15000, nil, false);
gb:add_listener(
	"ai_wave_03_3",
	function()
		ga_ai_att_09.sunits:start_attack_closest_enemy(nil, show_attack_closest_unit_debug_output);
	end
);

-------------------------------------------------------------------------------------------------
-------------------------------------------BOSS WAVES--------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_att_12:add_to_survival_battle_wave_on_message("reveal_cutscene_end", 4, true);
ga_ai_att_11:add_to_survival_battle_wave_on_message("reveal_cutscene_end", 4, false);

-------BOSS 1.1-------
ga_ai_att_09:message_on_rout_proportion("prepare_for_reveal", 0.99);
gb:message_on_time_offset("prepare_boss_reveal", 5000, "prepare_for_reveal");
--gb:message_on_time_offset("prepare_boss_reveal", 5000, "prepare_for_reveal", false);
--gb:message_on_time_offset("ai_wave_boss", 10000, "prepare_boss_reveal");

--ga_ai_att_11:reinforce_on_message("reveal_cutscene_end", 0, false);
ga_ai_att_11:deploy_at_random_intervals_on_message("reveal_cutscene_end", 1, 1, 30000, 35000, nil, false);
gb:add_listener(
	"reveal_cutscene_end",
	function()
		ga_ai_att_11.sunits:start_attack_closest_enemy(nil, show_attack_closest_unit_debug_output);
	end
);
ga_ai_att_11:message_on_under_attack("wave_boss_under_attack");

-------BOSS 1.2-------
--ga_ai_att_12:message_on_under_attack("ai_wave_boss");

--ga_ai_att_12:deploy_at_random_intervals_on_message("reveal_cutscene_end", 1, 1, 7500, 10000, nil, false);
ga_ai_att_12:deploy_at_random_intervals_on_message("reveal_cutscene_end", 1, 2, 7500, 10000, nil, false);
gb:add_listener(
	"reveal_cutscene_end",
	function()
		ga_ai_att_12.sunits:start_attack_closest_enemy(nil, show_attack_closest_unit_debug_output);
	end
);
ga_ai_att_12:remove_on_message("defeated_wave_11");

-------------------------------------------------------------------------------------------------
-------------------------------------------KILL WAVES--------------------------------------------
-------------------------------------------------------------------------------------------------

--1.1
ga_ai_att_01:message_on_rout_proportion("ai_wave_01_rout", 0.95);
ga_ai_att_01:rout_over_time_on_message("ai_wave_01_rout", 5000);
--1.2
ga_ai_att_02:message_on_rout_proportion("ai_wave_02_rout", 0.95);
ga_ai_att_02:rout_over_time_on_message("ai_wave_02_rout", 5000);
--1.3
ga_ai_att_03:message_on_rout_proportion("ai_wave_03_rout", 0.95);
ga_ai_att_03:rout_over_time_on_message("ai_wave_03_rout", 5000);
--2.1
ga_ai_att_04:message_on_rout_proportion("ai_wave_04_rout", 0.95);
ga_ai_att_04:rout_over_time_on_message("ai_wave_04_rout", 5000);
--2.2
ga_ai_att_05:message_on_rout_proportion("ai_wave_05_rout", 0.95);
ga_ai_att_05:rout_over_time_on_message("ai_wave_05_rout", 5000);
--2.3
ga_ai_att_06:message_on_rout_proportion("ai_wave_06_rout", 0.95);
ga_ai_att_06:rout_over_time_on_message("ai_wave_06_rout", 5000);
--3.1
ga_ai_att_07:message_on_rout_proportion("ai_wave_07_rout", 0.95);
ga_ai_att_07:rout_over_time_on_message("ai_wave_07_rout", 5000);
--3.2
ga_ai_att_08:message_on_rout_proportion("ai_wave_08_rout", 0.95);
ga_ai_att_08:rout_over_time_on_message("ai_wave_08_rout", 5000);
--3.3
ga_ai_att_09:message_on_rout_proportion("ai_wave_09_rout", 0.95);
ga_ai_att_09:rout_over_time_on_message("ai_wave_09_rout", 10000);
--boss 1.1
--ga_ai_att_11:message_on_rout_proportion("ai_wave_01_2", 0.05);
--ga_ai_att_11:rout_over_time_on_message("ai_wave_11_rout", 5000);
--boss 1.2
ga_ai_att_11:message_on_rout_proportion("ai_wave_12_rout", 0.99);
ga_ai_att_12:rout_over_time_on_message("ai_wave_12_rout", 3000);

-------------------------------------------------------------------------------------------------
-------------------------------------------OBJECTIVES--------------------------------------------
-------------------------------------------------------------------------------------------------

gb:add_listener(
	"ai_wave_01_1",
	function()
			bm:notify_wave_state_changed(1, "incoming", false)
			gb:remove_listener("ai_wave_01_1");
	end,
	true
);

gb:add_listener(
	"wave_1_under_attack",
	function()
			bm:notify_wave_state_changed(1, "in_progress", false)
			gb:remove_listener("wave_1_under_attack");
	end,
	true
);

gb:add_listener(
	"ai_wave_02_1",
	function()
			bm:notify_wave_state_changed(2, "incoming", false)
			gb:remove_listener("ai_wave_02_1");
	end,
	true
);

gb:add_listener(
	"wave_2_under_attack",
	function()
			bm:notify_wave_state_changed(2, "in_progress", false)
			gb:remove_listener("wave_2_under_attack");
	end,
	true
);

gb:add_listener(
	"ai_wave_03_1",
	function()
			bm:notify_wave_state_changed(3, "incoming", false)
			gb:remove_listener("ai_wave_03_1");
	end,
	true
);

gb:add_listener(
	"wave_3_under_attack",
	function()
			bm:notify_wave_state_changed(3, "in_progress", false)
			gb:remove_listener("wave_3_under_attack");
	end,
	true
);

gb:add_listener(
	"ai_wave_boss",
	function()
			bm:notify_wave_state_changed(4, "incoming", true)
			gb:remove_listener("ai_wave_boss");
	end,
	true
);

gb:add_listener(
	"wave_boss_under_attack",
	function()
			bm:notify_wave_state_changed(4, "in_progress", true)
			gb:remove_listener("wave_boss_under_attack");
	end,
	true
);

-------HINTS-------
gb:queue_help_on_message("wave_1", "wh3_survival_hint_00");
gb:queue_help_on_message("wave_2", "wh3_survival_hint_01");
gb:queue_help_on_message("wave_3", "wh3_survival_hint_01");
gb:queue_help_on_message("wave_4", "wh3_survival_hint_02");

gb:message_on_all_messages_received("wave_01_defeated", "defeated_wave_01", "defeated_wave_02", "defeated_wave_03");
gb:queue_help_on_message("wave_01_defeated", "wh3_survival_wave_01");
gb:message_on_all_messages_received("wave_02_defeated", "defeated_wave_04", "defeated_wave_05", "defeated_wave_06");
gb:queue_help_on_message("wave_02_defeated", "wh3_survival_wave_02");
gb:message_on_all_messages_received("wave_03_defeated", "defeated_wave_07", "defeated_wave_08", "defeated_wave_09");
gb:queue_help_on_message("wave_03_defeated", "wh3_survival_wave_03");

-------VICTORY CONDITIONS-------
ga_ai_att_01:message_on_rout_proportion("defeated_wave_01", 0.99);
ga_ai_att_02:message_on_rout_proportion("defeated_wave_02", 0.99);
ga_ai_att_03:message_on_rout_proportion("defeated_wave_03", 0.99);
gb:message_on_all_messages_received("enemy_wave_defeated", "defeated_wave_01", "defeated_wave_02", "defeated_wave_03");

ga_ai_att_04:message_on_rout_proportion("defeated_wave_04", 0.99);
ga_ai_att_05:message_on_rout_proportion("defeated_wave_05", 0.99);
ga_ai_att_06:message_on_rout_proportion("defeated_wave_06", 0.99);
gb:message_on_all_messages_received("enemy_wave_defeated", "defeated_wave_04", "defeated_wave_05", "defeated_wave_06");

ga_ai_att_07:message_on_rout_proportion("defeated_wave_07", 0.99);
ga_ai_att_08:message_on_rout_proportion("defeated_wave_08", 0.99);
ga_ai_att_09:message_on_rout_proportion("defeated_wave_09", 0.99);
gb:message_on_all_messages_received("enemy_wave_defeated", "defeated_wave_07", "defeated_wave_08", "defeated_wave_09");

ga_ai_att_11:message_on_rout_proportion("defeated_wave_11", 0.99);
ga_ai_att_12:message_on_rout_proportion("defeated_wave_12", 0.99);
gb:message_on_all_messages_received("enemy_wave_defeated", "defeated_wave_11", "defeated_wave_12");

gb:message_on_all_messages_received("end_battle", "defeated_wave_11", "defeated_wave_12");

--gb:set_victory_countdown_on_message("outro_cutscene_end", 1000);
--battle_manager:end_battle()

gb:add_listener(
	"enemy_wave_defeated",
	function()
		num_waves_total = num_waves_total + 1;
		
		print("Wave Killed - Num Waves Killed: " .. num_waves_total);
		
		if num_waves_total == 1 then
			bm:set_objective("wh3_survival_hint_objective", 1, 4);
			bm:notify_wave_state_changed(0, "defeated", false)
		elseif num_waves_total == 2 then
			bm:set_objective("wh3_survival_hint_objective", 2, 4);
			bm:notify_wave_state_changed(1, "defeated", false)
		elseif num_waves_total == 3 then
			bm:set_objective("wh3_survival_hint_objective", 3, 4);
			bm:notify_wave_state_changed(2, "defeated", false)
		elseif num_waves_total == 4 then
			bm:set_objective("wh3_survival_hint_objective", 4, 4);
			bm:notify_wave_state_changed(3, "defeated", true)
			--bm:notify_last_enemy_wave_completed();
			--gb.sm:trigger_message("all_waves_dead");
			gb:remove_listener("enemy_wave_defeated");
		end
	end,
	true
);