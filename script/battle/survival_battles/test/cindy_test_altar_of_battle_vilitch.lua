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

intro_cinematic_file = "script\\battle\\survival_battles\\_cutscene\\managers\\coc_altar_vilitch_phase_one.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
reveal_cinematic_file = "script\\battle\\survival_battles\\_cutscene\\managers\\coc_altar_final_phase_two.CindySceneManager";
bm:cindy_preload(reveal_cinematic_file);

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
-------------------------------------- COMPOSITE SCENES -----------------------------------------
-------------------------------------------------------------------------------------------------

altar_capture = "composite_scene/wh3_dlc20_enviro_altar_of_battle_lightning_event_final.csc";

bm:start_terrain_composite_scene(altar_capture, nil, 0);

-------------------------------------------------------------------------------------------------
------------------------------------------ INTRO VO ---------------------------------------------
-------------------------------------------------------------------------------------------------

wh3_intro_sfx_00 = new_sfx("WH3_DLC20_QB_Altar_Of_Battle_Sweetener_01");	

wh3_intro_sfx_01 = new_sfx("play_wh3_dlc20_qb_vilitch_altar_of_battle_intro_001");
wh3_intro_sfx_02 = new_sfx("play_wh3_dlc20_qb_vilitch_altar_of_battle_intro_002");
wh3_intro_sfx_03 = new_sfx("play_wh3_dlc20_qb_vilitch_altar_of_battle_intro_003");
wh3_intro_sfx_04 = new_sfx("play_wh3_dlc20_qb_vilitch_altar_of_battle_intro_004");
wh3_intro_sfx_05 = new_sfx("play_wh3_dlc20_qb_vilitch_altar_of_battle_intro_005");
wh3_intro_sfx_06 = new_sfx("play_wh3_dlc20_qb_vilitch_altar_of_battle_intro_006");

-------------------------------------------------------------------------------------------------
------------------------------------------ WAVE VO ----------------------------------------------
-------------------------------------------------------------------------------------------------

wh3_wave_sfx_01 = new_sfx("play_wh3_dlc20_qb_vilitch_altar_of_battle_phase2a_001");
wh3_wave_sfx_02 = new_sfx("play_wh3_dlc20_qb_vilitch_altar_of_battle_phase2b_001");
wh3_wave_sfx_03 = new_sfx("play_wh3_dlc20_qb_vilitch_altar_of_battle_phase2c_001");		-- altar accessable line

-------------------------------------------------------------------------------------------------
------------------------------------------ REVEAL VO --------------------------------------------
-------------------------------------------------------------------------------------------------

wh3_reveal_sfx_00 = new_sfx("WH3_DLC20_QB_Altar_Of_Battle_Sweetener_02");	

wh3_reveal_sfx_01 = new_sfx("play_wh3_dlc20_final_battle_narrator_07");
wh3_reveal_sfx_02 = new_sfx("play_wh3_dlc20_final_battle_narrator_08");
wh3_reveal_sfx_03 = new_sfx("play_Chaos_Arc_Sel_Gen_06");
wh3_reveal_sfx_04 = new_sfx("play_wh3_dlc20_qb_vilitch_altar_of_battle_phase3_001");

-- OUTRO --
wh3_outro_sfx_00 = new_sfx("WH3_DLC20_QB_Altar_Of_Battle_Sweetener_03");

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO CUTSCENE -----------------------------------------
-------------------------------------------------------------------------------------------------

function play_intro_cutscene()
	
	local cam = bm:camera();

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
	cutscene_intro:action(function() cam:fade(true, 0.5) end, 50300); --50s

	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();

	--Voiceover and Subtitles --
	cutscene_intro:action(function() cutscene_intro:play_sound(wh3_intro_sfx_00) end, 100);

	-- See, brother! This has all happened according to our design. [grunts-growl] 
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc20_qb_vilitch_altar_of_battle_intro_01", 
			function()
				cutscene_intro:play_sound(wh3_intro_sfx_01);
				bm:show_subtitle("wh3_dlc20_qb_vilitch_altar_of_battle_intro_01", false, true);
			end
	);

	-- That power is mine! And all those that have mocked us shall suffer!
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc20_qb_vilitch_altar_of_battle_intro_02", 
			function()
				cutscene_intro:play_sound(wh3_intro_sfx_02);
				bm:show_subtitle("wh3_dlc20_qb_vilitch_altar_of_battle_intro_02", false, true);
			end
	);

	-- [grunts-growl-grunts] No, fool! The Altar remains locked for now. But I know the way to access it.
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc20_qb_vilitch_altar_of_battle_intro_03", 
			function()
				cutscene_intro:play_sound(wh3_intro_sfx_03);
				bm:show_subtitle("wh3_dlc20_qb_vilitch_altar_of_battle_intro_03", false, true);
			end
	);

	-- Get us those Marks of Power - do not disappoint me - they are the key to breaking opening the Altar’s seal!
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc20_qb_vilitch_altar_of_battle_intro_04", 
			function()
				cutscene_intro:play_sound(wh3_intro_sfx_04);
				bm:show_subtitle("wh3_dlc20_qb_vilitch_altar_of_battle_intro_04", false, true);
			end
	);

	-- Does the Urfather send his slaves against us? We shall deal with them - time to clean up! [laughing, growls]
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc20_qb_vilitch_altar_of_battle_intro_05", 
			function()
				cutscene_intro:play_sound(wh3_intro_sfx_05);
				bm:show_subtitle("wh3_dlc20_qb_vilitch_altar_of_battle_intro_05", false, true);
			end
	);

	-- None shall stop us, brother! I have foreseen it! [angry growls!]
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc20_qb_vilitch_altar_of_battle_intro_06", 
			function()
				cutscene_intro:play_sound(wh3_intro_sfx_06);
				bm:show_subtitle("wh3_dlc20_qb_vilitch_altar_of_battle_intro_06", false, true);
			end
	);

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
    
	gb.sm:trigger_message("teleport_archaon")
	
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
        0
	);

	-- skip callback
	cutscene_reveal:set_skippable(
		true, 
		function()
			local cam_reveal = bm:camera();
			cam_reveal:fade(true, 0);
			bm:stop_cindy_playback(true);
			bm:callback(function() cam:fade(false, 0.5) end, 1000);
		end
	);

-- set up actions on cutscene
cutscene_reveal:action(function() cam:fade(true, 0.5) end, 24500); --25s

--Voiceover and Subtitles --
cutscene_reveal:action(function() cutscene_reveal:play_sound(wh3_reveal_sfx_00) end, 100);

-- For Chaos to achieve total destruction of the mortal realm, one God cannot dominate the others.  
cutscene_reveal:add_cinematic_trigger_listener(
 	"wh3_dlc20_qb_all_altar_of_battle_reveal_01", 
 		function()
 			cutscene_reveal:play_sound(wh3_reveal_sfx_01);
 			bm:show_subtitle("wh3_dlc20_qb_all_altar_of_battle_reveal_01", false, true);
 		end
);

-- The Everchosen comes to stop the final ritual! 
cutscene_reveal:add_cinematic_trigger_listener(
 	"wh3_dlc20_qb_all_altar_of_battle_reveal_02", 
 		function()
 			cutscene_reveal:play_sound(wh3_reveal_sfx_02);
			bm:show_subtitle("wh3_dlc20_qb_all_altar_of_battle_reveal_02", false, true);
 		end
);

-- Do not meddle in my destiny! 
cutscene_reveal:add_cinematic_trigger_listener(
 	"wh3_dlc20_qb_all_altar_of_battle_reveal_03", 
 		function()
 			cutscene_reveal:play_sound(wh3_reveal_sfx_03);
 			bm:show_subtitle("wh3_dlc20_qb_all_altar_of_battle_reveal_03", false, true);
 		end
);

cutscene_reveal:set_music("Altar_Of_Battle_Archaon_Reveal", 0, 0)

cutscene_reveal:start();
end;

function end_reveal_cutscene()
	gb.sm:trigger_message("reveal_cutscene_end")
	cam:move_to(cam_pos_reveal, cam_targ_reveal, 0.25)
	cam:fade(false, 2)
	bm:hide_subtitles()
end;

-- We have bested you before, Everchosen, and will again. Ask Jharkill!
gb:play_sound_on_message("reveal_cutscene_end", wh3_reveal_sfx_04, nil, 4000, nil, 500)


-------------------------------------------------------------------------------------------------
---------------------------------------- OUTRO CUTSCENE -----------------------------------------	-- kept here as PH for now, to give a short final overview shot before battle end
-------------------------------------------------------------------------------------------------

function prepare_for_outro_cutscene()
    --fade to black over 1 seconds
    bm:camera():fade(true, 1.0)

    -- play outro cutscene after 1 second
    bm:callback(function() play_outro_cutscene() end, 1000)
end

function play_outro_cutscene()

	local cam_outro = bm:camera();
	cam_pos_outro = cam:position();
	cam_targ_outro = cam:target();

	cam:move_to(v(0.55, 2500, -283.68), v(1.46, 2593, -67), 3);

	cam_outro:fade(false, 2);
		
	local cutscene_outro = cutscene:new(
		"cutscene_outro", 						-- unique string name for cutscene
		ga_player_01.sunits,					-- unitcontroller over player's army
		6000, 									-- duration of cutscene in ms
		function() end_outro_cutscene() end		-- what to call when cutscene is finished
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
	cutscene_outro:action(function() cam:fade(true, 0.5) end, 6000); --6s

	cutscene_outro:action(function() cutscene_outro:play_sound(wh3_outro_sfx_00) end, 100);

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

gb:stop_terrain_composite_scene_on_message("reveal_cutscene_end", altar_capture, 1000);
gb:start_terrain_composite_scene_on_message("play_outro", altar_capture, 3500);