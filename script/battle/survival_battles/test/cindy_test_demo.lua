load_script_libraries();

bm = battle_manager:new(empire_battle:new());

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

intro_cinematic_file = "script\\battle\\survival_battles\\demo\\managers\\intro.CindySceneManager";
help_01_cinematic_file = "script\\battle\\survival_battles\\demo\\managers\\foothold01.CindySceneManager";
help_02_cinematic_file = "script\\battle\\survival_battles\\demo\\managers\\foothold02.CindySceneManager";
help_03_cinematic_file = "script\\battle\\survival_battles\\demo\\managers\\foothold03.CindySceneManager";
help_04_cinematic_file = "script\\battle\\survival_battles\\demo\\managers\\foothold04.CindySceneManager";
reveal_cinematic_file = "script\\battle\\survival_battles\\demo\\managers\\reveal.CindySceneManager";
outro_cinematic_file = "script\\battle\\survival_battles\\demo\\managers\\outro.CindySceneManager";

-------------------------------------------------------------------------------------------------
-------------------------------------------ARMY SETUP--------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player_01 = gb:get_army(gb:get_player_alliance_num());
ga_ai_intro = gb:get_army(gb:get_non_player_alliance_num(), "test_intro");
ga_ai_reveal = gb:get_army(gb:get_non_player_alliance_num(), "test_reveal");
ga_ai_outro = gb:get_army(gb:get_non_player_alliance_num(), "test_outro");

-------------------------------------------------------------------------------------------------
------------------------------------------ INTRO VO ---------------------------------------------
-------------------------------------------------------------------------------------------------

wh3_intro_sfx_00 = new_sfx("Play_Movie_wh3_khorne_demo_survival_sweetener_01");
wh3_intro_sfx_01 = new_sfx("Play_wh3_khorne_demo_intro_survival_01");
wh3_intro_sfx_02 = new_sfx("Play_wh3_khorne_demo_intro_survival_02");
wh3_intro_sfx_03 = new_sfx("Play_wh3_khorne_demo_intro_survival_03");
wh3_intro_sfx_04 = new_sfx("Play_wh3_khorne_demo_intro_survival_04");

-------------------------------------------------------------------------------------------------
------------------------------------------ REVEAL VO --------------------------------------------
-------------------------------------------------------------------------------------------------

wh3_reveal_sfx_00 = new_sfx("Play_Movie_wh3_khorne_demo_survival_sweetener_02"); 
wh3_reveal_sfx_01 = new_sfx("Play_wh3_khorne_demo_reveal_survival_01");
wh3_reveal_sfx_02 = new_sfx("Play_wh3_khorne_demo_reveal_survival_02");
wh3_reveal_sfx_03 = new_sfx("Play_wh3_khorne_demo_reveal_survival_03");
wh3_reveal_sfx_04 = new_sfx("Play_wh3_khorne_demo_reveal_survival_04");
wh3_reveal_sfx_05 = new_sfx("Play_wh3_khorne_demo_reveal_survival_05");
wh3_reveal_sfx_06 = new_sfx("Play_wh3_khorne_demo_reveal_survival_06");
wh3_reveal_sfx_07 = new_sfx("Play_wh3_khorne_demo_reveal_survival_07");
wh3_reveal_sfx_08 = new_sfx("Play_wh3_khorne_demo_reveal_survival_08");
wh3_reveal_sfx_09 = new_sfx("Play_wh3_khorne_demo_reveal_survival_09");
wh3_reveal_sfx_10 = new_sfx("Play_wh3_khorne_demo_reveal_survival_10");

-------------------------------------------------------------------------------------------------
------------------------------------------ OUTRO VO ---------------------------------------------
-------------------------------------------------------------------------------------------------

wh3_outro_sfx_00 = new_sfx("Play_Movie_wh3_khorne_demo_survival_sweetener_03");
wh3_outro_sfx_01 = new_sfx("Play_wh3_khorne_demo_outro_survival_01");

-------------------------------------------------------------------------------------------------
------------------------------------------ EXTRA VO ---------------------------------------------
-------------------------------------------------------------------------------------------------

wh3_extra_sfx_00 = new_sfx("Play_Movie_wh3_khorne_demo_survival_sweetener_04");
wh3_extra_sfx_01 = new_sfx("Play_Movie_wh3_khorne_demo_survival_sweetener_05");
wh3_extra_sfx_02 = new_sfx("Play_Movie_wh3_khorne_demo_survival_sweetener_06");
wh3_extra_sfx_03 = new_sfx("Play_Movie_wh3_khorne_demo_survival_sweetener_07");

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO CUTSCENE -----------------------------------------
-------------------------------------------------------------------------------------------------

function play_intro_cutscene()
	
	local cam = bm:camera();

	cam:fade(false, 3);

	local intro_units_hidden = false;
	
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
		--cam:fade(true, 2);
		bm:stop_cindy_playback(true);
		
		if intro_units_hidden then
			ga_player_01.sunits:set_enabled(true, false) 
		end;

		--bm:callback(function() cam:fade(false, 2) end, 2000);
	end
);

cutscene_intro:action(
	function()
		intro_units_hidden = true;
		ga_player_01.sunits:set_enabled(false, false) 
	end, 
	100
);

cutscene_intro:action(
	function()
		intro_units_hidden = false;
		ga_player_01.sunits:set_enabled(true, false) 
	end, 
	30000
);	

-- set up actions on cutscene
cutscene_intro:action(function() cam:fade(false, 2) end, 1000);

-- set up subtitles
local subtitles = cutscene_intro:subtitles();
subtitles:set_alignment("bottom_centre");
subtitles:clear();

--Voiceover and Subtitles --
cutscene_intro:action(function() cutscene_intro:play_sound(wh3_intro_sfx_00) end, 100);

cutscene_intro:action(function() cutscene_intro:play_sound(wh3_intro_sfx_01) end, 100);
cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_intro_survival_01", "subtitle_with_frame", 0.1)	end, 1000);
cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 11000);

cutscene_intro:action(function() cutscene_intro:play_sound(wh3_intro_sfx_02) end, 12000);
cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_intro_survival_02", "subtitle_with_frame", 0.1)	end, 12000);	
cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 23500);

cutscene_intro:action(function() cutscene_intro:play_sound(wh3_intro_sfx_03) end, 24500);
cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_intro_survival_03", "subtitle_with_frame", 0.1)	end, 24500);	
cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 33000);

cutscene_intro:action(function() cutscene_intro:play_sound(wh3_intro_sfx_04) end, 34000);
cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_intro_survival_04", "subtitle_with_frame", 0.1)	end, 34000);	
cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 50500);

cutscene_intro:start()
end;

function end_intro_cutscene()
	gb.sm:trigger_message("intro_cutscene_end")
end;

-------------------------------------------------------------------------------------------------
--------------------------------------- REVEAL CUTSCENE -----------------------------------------
-------------------------------------------------------------------------------------------------

function prepare_for_reveal_cutscene()
    --fade to black over 0.5 seconds
    cam:fade(true, 0.5)

    -- play boss reveal cutscene after 1 second
    bm:callback(function() play_reveal_cutscene() end, 1000)
end

function play_reveal_cutscene()
		
	local cam_reveal = bm:camera();

	cam_reveal:fade(false, 0.5);
		
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

	cutscene_reveal:set_post_cutscene_fade_time(0.5);

	-- skip callback
	cutscene_reveal:set_skippable(
		true, 
		function()
			cam:fade(true, 0);
			bm:stop_cindy_playback(true);
			bm:callback(function() cam:fade(false, 0.5) end, 1000);
		end
	);

	-- Voiceover and Subtitles --
	cutscene_reveal:action(function() cutscene_reveal:play_sound(wh3_reveal_sfx_00) end, 100);	
	
	cutscene_reveal:action(function() cutscene_reveal:play_sound(wh3_reveal_sfx_10) end, 100);	
	cutscene_reveal:action(function() cutscene_reveal:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_reveal_survival_10", "subtitle_with_frame", 3)	end, 100);	
	cutscene_reveal:action(function() cutscene_reveal:hide_custom_cutscene_subtitles() end, 9600);

	cutscene_reveal:start()

end;

function end_reveal_cutscene()
	gb.sm:trigger_message("reveal_cutscene_end")
end;

-------------------------------------------------------------------------------------------------
---------------------------------------- OUTRO CUTSCENE -----------------------------------------
-------------------------------------------------------------------------------------------------

function prepare_for_outro_cutscene()
    --fade to black over 1 seconds
    cam:fade(true, 1.0)

    -- play boss reveal cutscene after 1 second
    bm:callback(function() play_outro_cutscene() end, 1000)
end

function play_outro_cutscene()

	local cam_outro = bm:camera();

	cam_outro:fade(false, 0.5);

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

	cutscene_outro:set_post_cutscene_fade_time(-1);			-- never fade back to picture

	-- skip callback
	cutscene_outro:set_skippable(
		true, 
		function()
			cam:fade(true, 0);
			bm:stop_cindy_playback(true);
			
			if outro_units_hidden then
				ga_player_01.sunits:set_invisible_to_all(true)
			end;

			bm:callback(function() cam:fade(true, 0.5) end, 1000);
		end
	);

	cutscene_outro:action(
		function()
			outro_units_hidden = true;
			ga_player_01.sunits:set_invisible_to_all(true)
			ga_player_01.sunits:change_behaviour_active("fire_at_will", false)
		end, 
		100
	);

	cutscene_outro:action(
		function()
			outro_units_hidden = false;
			ga_player_01.sunits:set_invisible_to_all(false)
		end, 
		20000
	);	

	-- Voiceover and Subtitles --
	cutscene_outro:action(function() cutscene_outro:play_sound(wh3_outro_sfx_00) end, 100);	

	cutscene_outro:action(function() cutscene_outro:play_sound(wh3_outro_sfx_01) end, 100);	
	cutscene_outro:action(function() cutscene_outro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_outro_survival_01", "subtitle_with_frame", 3)	end, 100);	
	cutscene_outro:action(function() cutscene_outro:hide_custom_cutscene_subtitles() end, 20100);

	cutscene_outro:start()
end;

function end_outro_cutscene()
	cam:fade(true, 0.5)
	bm:notify_survival_completion()
end;

-------------------------------------------------------------------------------------------------
--------------------------------------------CUTSCENES--------------------------------------------
-------------------------------------------------------------------------------------------------

gb.sm:add_listener("intro_cutscene_end", function() play_foothold_01_cutscene() end);
gb.sm:add_listener("foothold_01_cutscene_end", function() play_foothold_02_cutscene() end);
gb.sm:add_listener("foothold_02_cutscene_end", function() play_foothold_03_cutscene() end);
gb.sm:add_listener("foothold_03_cutscene_end", function() play_foothold_04_cutscene() end);
gb.sm:add_listener("foothold_04_cutscene_end", function() prepare_for_reveal_cutscene() end);
gb.sm:add_listener("reveal_cutscene_end", function() prepare_for_outro_cutscene() end);

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

-------------------------------------------------------------------------------------------------
----------------------------------------- FOOTHOLD 01 -------------------------------------------
-------------------------------------------------------------------------------------------------

function play_foothold_01_cutscene()
	
	local cam = bm:camera();
	cam_pos_01 = cam:position();
	cam_targ_01 = cam:target();

	local cutscene_foothold_01 = cutscene:new_from_cindyscene(
        -- unique string name for cutscene
        "cutscene_foothold_01",
        -- unitcontroller or scriptunits collection over player's army
        ga_player_01.sunits,
        -- end callback
        function() end_foothold_01_cutscene() end,
        -- path to cindy scene
        help_01_cinematic_file,
        -- optional fade in/fade out durations
        3,
        3
	);

	-- skip callback
	cutscene_foothold_01:set_skippable(
		true, 
		function()
			bm:stop_cindy_playback(true);
		end
	);

	cutscene_foothold_01:action(
		function()
			ga_player_01.sunits:set_invincible(true); 
		end, 
		21000
	);

	-- set up subtitles
	local subtitles = cutscene_foothold_01:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();

	--Voiceover and Subtitles --
	cutscene_foothold_01:action(function() cutscene_foothold_01:play_sound(wh3_extra_sfx_00) end, 100);

	cutscene_foothold_01:action(function() cutscene_foothold_01:play_sound(wh3_reveal_sfx_01) end, 100);	
	cutscene_foothold_01:action(function() cutscene_foothold_01:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_reveal_survival_01", "subtitle_with_frame", 0.1)	end, 100);	
	cutscene_foothold_01:action(function() cutscene_foothold_01:hide_custom_cutscene_subtitles() end, 6100);

	cutscene_foothold_01:action(function() cutscene_foothold_01:play_sound(wh3_reveal_sfx_02) end, 6200);	
	cutscene_foothold_01:action(function() cutscene_foothold_01:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_reveal_survival_02", "subtitle_with_frame", 0.1)	end, 6200);	
	cutscene_foothold_01:action(function() cutscene_foothold_01:hide_custom_cutscene_subtitles() end, 9700);

	cutscene_foothold_01:action(function() cutscene_foothold_01:play_sound(wh3_reveal_sfx_03) end, 12800);	
	cutscene_foothold_01:action(function() cutscene_foothold_01:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_reveal_survival_03", "subtitle_with_frame", 0.1)	end, 12800);	
	cutscene_foothold_01:action(function() cutscene_foothold_01:hide_custom_cutscene_subtitles() end, 15900);

	cutscene_foothold_01:action(function() cutscene_foothold_01:play_sound(wh3_reveal_sfx_04) end, 20000);	
	cutscene_foothold_01:action(function() cutscene_foothold_01:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_reveal_survival_04", "subtitle_with_frame", 0.1)	end, 20000);	
	cutscene_foothold_01:action(function() cutscene_foothold_01:hide_custom_cutscene_subtitles() end, 28000);

	cutscene_foothold_01:start()
end;

function end_foothold_01_cutscene()
	gb.sm:trigger_message("foothold_01_cutscene_end")
	ga_player_01.sunits:set_invincible(false) 
	ga_player_01.sunits:release_control()
end;

-------------------------------------------------------------------------------------------------
----------------------------------------- FOOTHOLD 02 -------------------------------------------
-------------------------------------------------------------------------------------------------

function play_foothold_02_cutscene()
	
	local cam = bm:camera();
	cam_pos_02 = cam:position();
	cam_targ_02 = cam:target();

	local cutscene_foothold_02 = cutscene:new_from_cindyscene(
        -- unique string name for cutscene
        "cutscene_foothold_02",
        -- unitcontroller or scriptunits collection over player's army
        ga_player_01.sunits,
        -- end callback
        function() end_foothold_02_cutscene() end,
        -- path to cindy scene
        help_02_cinematic_file,
        -- optional fade in/fade out durations
        3,
        0
	);

	-- skip callback
	cutscene_foothold_02:set_skippable(
		true, 
		function()
			bm:stop_cindy_playback(true);
		end
	);

	cutscene_foothold_02:action(
		function()
			ga_player_01.sunits:set_invincible(true); 
		end, 
		4100
	);

	-- set up subtitles
	local subtitles = cutscene_foothold_02:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();

	--Voiceover and Subtitles --
	cutscene_foothold_02:action(function() cutscene_foothold_02:play_sound(wh3_extra_sfx_01) end, 100);

	cutscene_foothold_02:action(function() cutscene_foothold_02:play_sound(wh3_reveal_sfx_05) end, 100);	
	cutscene_foothold_02:action(function() cutscene_foothold_02:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_reveal_survival_05", "subtitle_with_frame", 0.1)	end, 100);	
	cutscene_foothold_02:action(function() cutscene_foothold_02:hide_custom_cutscene_subtitles() end, 4100);

	cutscene_foothold_02:start()
end;

function end_foothold_02_cutscene()
	gb.sm:trigger_message("foothold_02_cutscene_end")
	ga_player_01.sunits:set_invincible(false) 
	ga_player_01.sunits:release_control()
end;

-------------------------------------------------------------------------------------------------
----------------------------------------- FOOTHOLD 03 -------------------------------------------
-------------------------------------------------------------------------------------------------

function play_foothold_03_cutscene()
	
	local cam = bm:camera();
	cam_pos_03 = cam:position();
	cam_targ_03 = cam:target();

	local cutscene_foothold_03 = cutscene:new_from_cindyscene(
        -- unique string name for cutscene
        "cutscene_foothold_03",
        -- unitcontroller or scriptunits collection over player's army
        ga_player_01.sunits,
        -- end callback
        function() end_foothold_03_cutscene() end,
        -- path to cindy scene
        help_03_cinematic_file,
        -- optional fade in/fade out durations
        3,
        3
	);

	-- skip callback
	cutscene_foothold_03:set_skippable(
		true, 
		function()
			bm:stop_cindy_playback(true);
		end
	);

	cutscene_foothold_03:action(
		function()
			ga_player_01.sunits:set_invincible(true); 
		end, 
		7100
	);

	-- set up subtitles
	local subtitles = cutscene_foothold_03:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();

	--Voiceover and Subtitles --
	cutscene_foothold_03:action(function() cutscene_foothold_03:play_sound(wh3_extra_sfx_02) end, 100);

	cutscene_foothold_03:action(function() cutscene_foothold_03:play_sound(wh3_reveal_sfx_06) end, 9100);	
	cutscene_foothold_03:action(function() cutscene_foothold_03:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_reveal_survival_06", "subtitle_with_frame", 0.1)	end, 9100);	
	cutscene_foothold_03:action(function() cutscene_foothold_03:hide_custom_cutscene_subtitles() end, 14100);

	cutscene_foothold_03:start()
end;

function end_foothold_03_cutscene()
	gb.sm:trigger_message("foothold_03_cutscene_end")
	ga_player_01.sunits:set_invincible(false) 
	ga_player_01.sunits:release_control()
end;

-------------------------------------------------------------------------------------------------
----------------------------------------- FOOTHOLD 04 -------------------------------------------
-------------------------------------------------------------------------------------------------

function play_foothold_04_cutscene()
	
	local cam = bm:camera();
	cam_pos_04 = cam:position();
	cam_targ_04 = cam:target();

	local cutscene_foothold_04 = cutscene:new_from_cindyscene(
        -- unique string name for cutscene
        "cutscene_foothold_04",
        -- unitcontroller or scriptunits collection over player's army
        ga_player_01.sunits,
        -- end callback
        function() end_foothold_04_cutscene() end,
        -- path to cindy scene
        help_04_cinematic_file,
        -- optional fade in/fade out durations
        3,
        3
	);

-- skip callback
cutscene_foothold_04:set_skippable(
	true, 
	function()
		bm:stop_cindy_playback(true);
	end
);

cutscene_foothold_04:action(
	function()
		ga_player_01.sunits:set_invincible(true); 
	end, 
	11600
);

-- set up subtitles
local subtitles = cutscene_foothold_04:subtitles();
subtitles:set_alignment("bottom_centre");
subtitles:clear();

--Voiceover and Subtitles --
cutscene_foothold_04:action(function() cutscene_foothold_04:play_sound(wh3_extra_sfx_03) end, 100);	

cutscene_foothold_04:action(function() cutscene_foothold_04:play_sound(wh3_reveal_sfx_08) end, 1100);	
cutscene_foothold_04:action(function() cutscene_foothold_04:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh3_khorne_demo_reveal_survival_08", "subtitle_with_frame", 0.1)	end, 1100);	
cutscene_foothold_04:action(function() cutscene_foothold_04:hide_custom_cutscene_subtitles() end, 10500);

cutscene_foothold_04:start()
end;

function end_foothold_04_cutscene()
	gb.sm:trigger_message("foothold_04_cutscene_end")
	ga_player_01.sunits:set_invincible(false) 
	ga_player_01.sunits:release_control()
end;