load_script_libraries();

bm:camera():fade(true, 0);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                     	-- prevent deployment for ai
	function() play_intro_cutscene() end,      -- intro cutscene function -- nil, --
	false                                      	-- debug mode
);

---------------------------
----HARD SCRIPT VERSION----
---------------------------

local sm = get_messager();

intro_cinematic_file = "script\\battle\\survival_battles\\_cutscene\\managers\\sla_palace_intro_m01.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
reveal_cinematic_file = "script\\battle\\survival_battles\\_cutscene\\managers\\sla_reveal_m01.CindySceneManager";
bm:cindy_preload(reveal_cinematic_file);
outro_cinematic_file = "script\\battle\\survival_battles\\realm_win\\managers\\realmwin_intro_sla.CindySceneManager";
bm:cindy_preload(outro_cinematic_file);

-------------------------------------------------------------------------------------------------
-------------------------------------------ARMY SETUP--------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player_01 = gb:get_army(gb:get_player_alliance_num());
ga_ai_intro = gb:get_army(gb:get_non_player_alliance_num(), "test_intro");
ga_ai_reveal = gb:get_army(gb:get_non_player_alliance_num(), "test_reveal");
ga_ai_outro = gb:get_army(gb:get_non_player_alliance_num(), "test_outro");

ga_ai_intro.sunits:set_enabled(false);
ga_ai_reveal.sunits:set_enabled(false);
ga_ai_outro.sunits:set_enabled(false);

-------------------------------------------------------------------------------------------------
------------------------------------------ INTRO VO ---------------------------------------------
-------------------------------------------------------------------------------------------------

wh3_intro_sfx_00 = new_sfx("WH3_Survival_Battle_Slaanesh_Sweetener_01");

wh3_intro_sfx_01 = new_sfx("play_wh3_main_camp_narrative_chs_slaanesh_battle_intro_01_1");
wh3_intro_sfx_02 = new_sfx("play_wh3_main_camp_narrative_chs_slaanesh_battle_intro_02_1");
wh3_intro_sfx_03 = new_sfx("play_wh3_main_camp_narrative_chs_slaanesh_battle_intro_03_1");
wh3_intro_sfx_04 = new_sfx("play_wh3_main_camp_narrative_chs_slaanesh_battle_intro_04_1");
wh3_intro_sfx_05 = new_sfx("play_wh3_main_camp_narrative_chs_slaanesh_battle_intro_05_1");

-------------------------------------------------------------------------------------------------
------------------------------------------ REVEAL VO --------------------------------------------
-------------------------------------------------------------------------------------------------

wh3_reveal_sfx_00 = new_sfx("WH3_Survival_Battle_Slaanesh_Sweetener_02");

wh3_reveal_sfx_01 = new_sfx("play_wh3_main_camp_narrative_chs_slaanesh_battle_intro_06_1");

-------------------------------------------------------------------------------------------------
------------------------------------------ OUTRO VO ---------------------------------------------
-------------------------------------------------------------------------------------------------

wh3_outro_sfx_00 = new_sfx("WH3_Survival_Battle_Slaanesh_Sweetener_03");

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO CUTSCENE -----------------------------------------
-------------------------------------------------------------------------------------------------

function play_intro_cutscene()
	
	local cam = bm:camera();

	cam:fade(false, 3);
	
	local cutscene_intro = cutscene:new_from_cindyscene(
        -- unique string name for cutscene
        "cutscene_intro",
        -- unitcontroller or scriptunits collection over player's army
        ga_player_01.sunits,
        -- end callback
        function() end_intro_cutscene() end,
        -- path to cindy scene
        intro_cinematic_file,
        -- optional fade in/fade out durations
        0,
        2
	);

	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()
			bm:stop_cindy_playback(true);
		end
	);

	-- set up actions on cutscene
	--cutscene_intro:action(function() cam:fade(true, 0.5) end, 49800); --56.1s

	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();

	--Voiceover and Subtitles --
	cutscene_intro:action(function() cutscene_intro:play_sound(wh3_intro_sfx_00) end, 100);
	
	-- The Palace of Slaanesh, where resides the Dark Prince's harem. 
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_camp_narrative_chs_slaanesh_battle_intro_01", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_camp_narrative_chs_slaanesh_battle_intro_01_1"));
				bm:show_subtitle("wh3_main_camp_narrative_chs_slaanesh_battle_intro_01", false, true);
			end
	);

	-- A full-on incursion is not desired or warranted – we need only penetrate its outer-defences and the Courtesan shall face us. 
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_camp_narrative_chs_slaanesh_battle_intro_02", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_camp_narrative_chs_slaanesh_battle_intro_02_1"));
				bm:show_subtitle("wh3_main_camp_narrative_chs_slaanesh_battle_intro_02", false, true);
			end
	);

	-- Begin at the Wall of Twisted Flesh. Disperse its defenders and capture the Statue of Perfection. This will give you a foothold and grant us supplies to reinforce for the struggle ahead. 
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_camp_narrative_chs_slaanesh_battle_intro_03", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_camp_narrative_chs_slaanesh_battle_intro_03_1"));
				bm:show_subtitle("wh3_main_camp_narrative_chs_slaanesh_battle_intro_03", false, true);
			end
	);

	-- There are two other statues you will need to capture and so dominate the battle.  
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_camp_narrative_chs_slaanesh_battle_intro_04", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_camp_narrative_chs_slaanesh_battle_intro_04_1"));
				bm:show_subtitle("wh3_main_camp_narrative_chs_slaanesh_battle_intro_04", false, true);
			end
	);

	-- Slaanesh senses your desire to slay His chosen prince. Channel this ambition for you own gain, not His! 
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_camp_narrative_chs_slaanesh_battle_intro_05", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_camp_narrative_chs_slaanesh_battle_intro_05_1"));
				bm:show_subtitle("wh3_main_camp_narrative_chs_slaanesh_battle_intro_05", false, true);
			end
	);

	cutscene_intro:set_music("Slaanesh_Intro", 0, 0)

	cutscene_intro:start();
end;

function end_intro_cutscene()
	gb.sm:trigger_message("intro_cutscene_end")
	bm:cindy_preload(reveal_cinematic_file)
	cam:fade(false, 2)
	bm:hide_subtitles()
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
	cam_pos_reveal = cam:position();
	cam_targ_reveal = cam:target();

	cam_reveal:fade(false, 2);
		
	local cutscene_reveal = cutscene:new_from_cindyscene(
        -- unique string name for cutscene
        "cutscene_reveal",
        -- unitcontroller or scriptunits collection over player's army
        ga_player_01.sunits,
        -- end callback
        function() end_reveal_cutscene() end,
        -- path to cindy scene
        reveal_cinematic_file,
        -- optional fade in/fade out durations
        0,
        2
	);

	-- skip callback
	cutscene_reveal:set_skippable(
		true, 
		function()
			local cam_reveal = bm:camera();
			cam_reveal:fade(true, 2);
			bm:stop_cindy_playback(true);
			bm:callback(function() cam_reveal:fade(false, 0.5) end, 1000);
		end
	);

	-- set up fade actions on cutscene
	cutscene_reveal:action(function() cam:fade(true, 0.5) end, 17800); --20.3s

	--Voiceover and Subtitles --
	cutscene_reveal:action(function() cutscene_reveal:play_sound(wh3_reveal_sfx_00) end, 100);
	
	-- The Courtesan appears! This is the Daemon Prince we must kill, whose soul we need!
	cutscene_reveal:add_cinematic_trigger_listener(
		"wh3_main_camp_narrative_chs_slaanesh_battle_intro_06", 
			function()
				cutscene_reveal:play_sound(new_sfx("play_wh3_main_camp_narrative_chs_slaanesh_battle_intro_06_1"));
				bm:show_subtitle("wh3_main_camp_narrative_chs_slaanesh_battle_intro_06", false, true);
			end
	);

	cutscene_reveal:set_music("Slaanesh_Daemon_Prince", 0, 0)

	cutscene_reveal:start();
end;

function end_reveal_cutscene()
	gb.sm:trigger_message("reveal_cutscene_end")
	cam:move_to(cam_pos_reveal, cam_targ_reveal, 0.25)
	cam:fade(false, 2)
	bm:hide_subtitles()
end;

-------------------------------------------------------------------------------------------------
---------------------------------------- OUTRO CUTSCENE -----------------------------------------
-------------------------------------------------------------------------------------------------

function prepare_for_outro_cutscene()
    --fade to black over 1 seconds
    bm:camera():fade(true, 1.0)

    -- play boss reveal cutscene after 1 second
    bm:callback(function() play_outro_cutscene() end, 1000)
end

function play_outro_cutscene()

	local cam_outro = bm:camera();

	cam_outro:fade(false, 2);

	local outro_units_hidden = false;
		
	local cutscene_outro = cutscene:new_from_cindyscene(
        -- unique string name for cutscene
        "cutscene_outro",
        -- unitcontroller or scriptunits collection over player's army
        ga_player_01.sunits,
        -- end callback
        function() end_outro_cutscene() end,
        -- path to cindy scene
        outro_cinematic_file,
        -- optional fade in/fade out durations
        0,
        2
	);

	-- skip callback
	cutscene_outro:set_skippable(
		true, 
		function()
			local cam_outro = bm:camera();
			cam_outro:fade(true, 0);
			bm:stop_cindy_playback(true);
			
			if outro_units_hidden then
				ga_player_01.sunits:set_enabled(false)
			end;

			bm:callback(function() cam:fade(false, 0.5) end, 1000);
		end
	);

	-- set up fade actions on cutscene
	cutscene_outro:action(function() cam:fade(true, 0.5) end, 45950); --49.7s

	cutscene_outro:action(
		function()
			outro_units_hidden = true;
			ga_player_01.sunits:set_enabled(false)
		end, 
		100
	);

	--Voiceover and Subtitles --
	cutscene_outro:action(function() cutscene_outro:play_sound(wh3_outro_sfx_00) end, 100);
	
	cutscene_outro:set_music("Slaanesh_Realm_Conquered", 0, 0)

	cutscene_outro:start();
end;

function end_outro_cutscene()
	gb.sm:trigger_message("outro_cutscene_end")
	ga_player_01.sunits:set_enabled(true)
	ga_ai_intro.sunits:set_enabled(true)
	cam:fade(false, 2)
	bm:hide_subtitles()
	bm:change_victory_countdown_limit(1000)
	bm:notify_survival_completion()
end;

-------------------------------------------------------------------------------------------------
--------------------------------------------CUTSCENES--------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("play_reveal", 5000, "intro_cutscene_end");
gb.sm:add_listener("play_reveal", function() prepare_for_reveal_cutscene() end);
gb:message_on_time_offset("play_outro", 5000, "reveal_cutscene_end");
gb.sm:add_listener("play_outro", function() prepare_for_outro_cutscene() end);

ga_player_01:release_on_message("outro_cutscene_end");