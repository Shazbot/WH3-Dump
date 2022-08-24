-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();

gb = generated_battle:new(
	false,                                      		    -- screen starts black
	false,                                      			-- prevent deployment for player
	false,                                      		    -- prevent deployment for ai
	function() end_deployment_phase() end,          			-- intro cutscene function
	false                                      				-- debug mode
);

intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/cth_bas_m02.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);

gb:set_cutscene_during_deployment(true);

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh3_intro_sfx_00 = new_sfx("Play_Movie_WH3_Great_Bastion_Zhao_Ming");

wh3_intro_sfx_01 = new_sfx("play_cat_zhao_ming_great_bastion_speech_01_1");
wh3_intro_sfx_02 = new_sfx("play_cat_zhao_ming_great_bastion_speech_02_1");
wh3_intro_sfx_03 = new_sfx("play_cat_zhao_ming_great_bastion_speech_03_1");
wh3_intro_sfx_04 = new_sfx("play_cat_zhao_ming_great_bastion_speech_04_1");
wh3_intro_sfx_05 = new_sfx("play_cat_zhao_ming_great_bastion_speech_05_1");

-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
		
	local cam = bm:camera();
		
	-- declare cutscene
	local cutscene_intro = cutscene:new_from_cindyscene(
		"cutscene_intro", 																-- unique string name for cutscene
		ga_player.sunits,															-- unitcontroller over player's army
		function() intro_cutscene_end() end,											-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/cth_bas_m02.CindySceneManager",			-- path to cindyscene
		0,																				-- blend in time (s)
		0																				-- blend out time (s)
	);
	
	local player_units_hidden = false;
	
	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
	
	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()
			local cam = bm:camera();
			cam:fade(true, 0);
			bm:stop_cindy_playback(true);
			
			if player_units_hidden then
				ga_player:set_enabled(true)
			end;
						
			bm:callback(function() cam:fade(false, 0.25) end, 100);
			bm:hide_subtitles();
		end
	);
		
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_player:set_enabled(true) 
		end, 
		200
	);	
	
	
	-- Voiceover and Subtitles --

	cutscene_intro:action(function() cutscene_intro:play_sound(wh3_intro_sfx_00) end, 100);

	-- VO1
	-- If my sister is found delinquent in her duty, then we defend the Bastion, and ensure the invading scum shall not set foot in my parent's domain!

	-- VO2
	-- Mother has forewarned me… Chaos attempts to breach the Bastion, and so I bring the might of the Western Provinces to thwart them! Ready your arms!

	-- VO3
	-- The Dark Powers assault my father's walls, but it is mother who tasks me to clear them of filth! So it shall be, for I am Zhao Ming!

	-- VO4
	-- Ah, the Great Bastion! I should be its master, let me prove to my parents why. Ready your weapons, my followers, purge the walls of Chaos!

	-- VO5
	-- Chaos comes. But we will not be found wanting. Defend this place and earn me honour, for that is your role in this pantomime!

		-- Voiceover and Subtitles --
	cutscene_intro:add_cinematic_trigger_listener(
		"lord_VO_01", 
			function()
				
				local random_vo = {
					"01",
					"02",
					"03",
					"04",
					"05"
				};

				local random_index = random_vo[bm:random_number(1, #random_vo)]
				cutscene_intro:play_sound(new_sfx("play_cat_zhao_ming_great_bastion_speech_" .. random_index .. "_1"));
				bm:show_subtitle("cat_zhao_ming_bat_speeches_" .. random_index, false, true);
			end
	);

	cutscene_intro:set_music("Cathay_Bastion", 0, 0)

	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
	cam:fade(false, 0)
end;

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

--Player Army
ga_player = gb:get_army(gb:get_player_alliance_num());