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

intro_cinematic_file = "script\\battle\\survival_battles\\belakor_final_battle\\managers\\bfb_sq01_m01.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
reveal_cinematic_file = "script\\battle\\survival_battles\\belakor_final_battle\\managers\\bfb_sq02_m02.CindySceneManager";
bm:cindy_preload(reveal_cinematic_file);
outro_cinematic_file = "script\\battle\\survival_battles\\belakor_final_battle\\managers\\bfb_sq03_m03.CindySceneManager";
bm:cindy_preload(outro_cinematic_file);

belakor_throne = "composite_scene/cutscenes/belakor_fb/sq01_shadows/shot/s010_belakor_ingame_idle_shot_t01.csc";

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

belakor_throne = "composite_scene/cutscenes/belakor_fb/sq01_shadows/shot/s010_belakor_ingame_idle_shot_t01.csc";

-------------------------------------------------------------------------------------------------
------------------------------------------ INTRO VO ---------------------------------------------
-------------------------------------------------------------------------------------------------

wh3_intro_sfx_00 = new_sfx("WH3_Survival_Battle_Forge_Of_Souls_Sweetener_01");

wh3_intro_sfx_01 = new_sfx("Play_wh3_main_qb_belakor_final_battle_01");

-------------------------------------------------------------------------------------------------
------------------------------------------ REVEAL VO --------------------------------------------
-------------------------------------------------------------------------------------------------

wh3_reveal_sfx_00 = new_sfx("WH3_Survival_Battle_Forge_Of_Souls_Sweetener_02");

wh3_reveal_sfx_01 = new_sfx("Play_wh3_main_qb_belakor_final_battle_02");
 
-------------------------------------------------------------------------------------------------
------------------------------------------ OUTRO VO ---------------------------------------------
-------------------------------------------------------------------------------------------------

wh3_outro_sfx_00 = new_sfx("WH3_Survival_Battle_Forge_Of_Souls_Sweetener_03");

wh3_outro_sfx_01 = new_sfx("Play_wh3_main_qb_belakor_final_battle_03");
wh3_outro_sfx_02 = new_sfx("Play_wh3_main_qb_belakor_final_battle_04");

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO CUTSCENE -----------------------------------------
-------------------------------------------------------------------------------------------------

function play_intro_cutscene()
	
	local cam = bm:camera();
	cam_pos_intro = cam:position();
	cam_targ_intro = cam:target();

	bm:start_terrain_composite_scene(belakor_throne, nil, 0)
	bm:stop_terrain_composite_scene(belakor_throne)

	cam:fade(false, 2);
	
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
        0
	);

	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()
			bm:stop_cindy_playback(true);
		end
	);

	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(true, 0.5) end, 22250); --23s

	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();

	--Voiceover and Subtitles --
	cutscene_intro:action(function() cutscene_intro:play_sound(wh3_intro_sfx_00) end, 100);

	-- I sit upon the precipice of godhood, and you have the gall to believe that the bear’s carrion is yours? Come then, try and take it!
	cutscene_intro:add_cinematic_trigger_listener(
		"Play_wh3_main_qb_belakor_final_battle_01", 
			function()
				cutscene_intro:play_sound(new_sfx("Play_wh3_main_qb_belakor_final_battle_01"));
				bm:show_subtitle("wh3_belakor_final_survival_01", false, true);
			end
	);

	cutscene_intro:set_music("Final_Battle_Intro", 0, 0)

	cutscene_intro:start();
end;

function end_intro_cutscene()
	ga_player_01.sunits:set_always_visible_no_hidden_no_leave_battle(true)
	ga_player_01.sunits:release_control()
	gb.sm:trigger_message("intro_cutscene_end")
	cam:move_to(cam_pos_intro, cam_targ_intro, 0.25)
	cam:fade(false, 2)
	bm:start_terrain_composite_scene(belakor_throne, nil, 0)
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

	local reveal_units_hidden = false;
		
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
        0
	);

	-- skip callback
	cutscene_reveal:set_skippable(
		true, 
		function()
			local cam_reveal = bm:camera();
			cam_reveal:fade(true, 0);
			bm:stop_cindy_playback(true);
			
			if reveal_units_hidden then
				ga_player_01.sunits:set_enabled(false)
				end;		
			bm:callback(function() cam:fade(false, 0.5) end, 1000);
		end
	);

	-- set up actions on cutscene
	cutscene_reveal:action(function() cam:fade(true, 0.5) end, 18500); --19s

	cutscene_reveal:action(
		function()
			reveal_units_hidden = true;
			ga_player_01.sunits:set_enabled(false)
		end, 
		100
	);

	--Voiceover and Subtitles --
	cutscene_reveal:action(function() cutscene_reveal:play_sound(wh3_reveal_sfx_00) end, 100);

	--You built an empire to sustain this futile quest – that is the first thing I shatter after my ascension. As I feast on Ursun’s power, my Soul-Grinders shall feed on yours… 
	cutscene_reveal:add_cinematic_trigger_listener(
		"Play_wh3_main_qb_belakor_final_battle_02", 
			function()
				cutscene_reveal:play_sound(new_sfx("Play_wh3_main_qb_belakor_final_battle_02"));
				bm:show_subtitle("wh3_belakor_final_survival_02", false, true);
			end
	);

	cutscene_reveal:set_music("Final_Battle_Mid", 0, 0)

	cutscene_reveal:start();
end;

function end_reveal_cutscene()
	gb.sm:trigger_message("reveal_cutscene_end")
	cam:move_to(cam_pos_reveal, cam_targ_reveal, 0.25)
	ga_player_01.sunits:set_enabled(true)
	cam:fade(false, 2)
	bm:hide_subtitles()
end;

-------------------------------------------------------------------------------------------------
---------------------------------------- OUTRO CUTSCENE -----------------------------------------
-------------------------------------------------------------------------------------------------

function prepare_for_outro_cutscene()
    --fade to black over 1 seconds
    bm:camera():fade(true, 1.0)

	bm:stop_terrain_composite_scene(belakor_throne)

    -- play boss reveal cutscene after 1 second
    bm:callback(function() play_outro_cutscene() end, 1000)
end

function play_outro_cutscene()

	local cam_outro = bm:camera();
	cam_pos_outro = cam:position();
	cam_targ_outro = cam:target();

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
        0
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

	-- set up actions on cutscene
	cutscene_outro:action(function() cam:fade(true, 0.5) end, 14500); --16s

	cutscene_outro:action(
		function()
			outro_units_hidden = true;
			ga_player_01.sunits:set_enabled(false)
		end, 
		100
	);

	--Voiceover and Subtitles --
	cutscene_outro:action(function() cutscene_outro:play_sound(wh3_outro_sfx_00) end, 100);

	-- I may not be a god yet… but you will *suffer*
	cutscene_outro:add_cinematic_trigger_listener(
		"Play_wh3_main_qb_belakor_final_battle_03", 
			function()
				cutscene_outro:play_sound(new_sfx("Play_wh3_main_qb_belakor_final_battle_03"));
				bm:show_subtitle("wh3_belakor_final_survival_03", false, true);
			end
	);

	-- my majesty!
	cutscene_outro:add_cinematic_trigger_listener(
		"Play_wh3_main_qb_belakor_final_battle_04", 
			function()
				cutscene_outro:play_sound(new_sfx("Play_wh3_main_qb_belakor_final_battle_04"));
				bm:show_subtitle("wh3_belakor_final_survival_04", false, true);
			end
	);

	cutscene_outro:set_music("Final_Battle_Outro", 0, 0)

	cutscene_outro:start();
end;

function end_outro_cutscene()
	gb.sm:trigger_message("outro_cutscene_end")
	ga_player_01.sunits:set_enabled(true)
	cam:move_to(cam_pos_outro, cam_targ_outro, 0.25)
	cam:fade(false, 2)
	bm:hide_subtitles()
end;

-------------------------------------------------------------------------------------------------
--------------------------------------------CUTSCENES--------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("play_reveal", 5000, "intro_cutscene_end");
gb.sm:add_listener("play_reveal", function() prepare_for_reveal_cutscene() end);
gb:message_on_time_offset("play_outro", 5000, "reveal_cutscene_end");
gb.sm:add_listener("play_outro", function() prepare_for_outro_cutscene() end);

ga_player_01:release_on_message("outro_cutscene_end");

-------------------------------------------------------------------------------------------------
-------------------------------------------OBJECTIVES--------------------------------------------
-------------------------------------------------------------------------------------------------

core:add_listener(
	"waves_defeated",
	"ScriptEventSurvivalBattleWaveDefeated",
	true,
	function(context)
		local index = context:index();
		if index == 0 then
			gb.sm:trigger_message("wave_01_defeated");
		elseif index == 1 then
			gb.sm:trigger_message("wave_02_defeated");
		elseif index == 2 then
			gb.sm:trigger_message("wave_03_defeated");
		elseif index == 3 then
			gb.sm:trigger_message("wave_04_defeated");
		end;
	end,
	true
);