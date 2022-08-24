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

intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/cth_bas_m01.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);

gb:set_cutscene_during_deployment(true);

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh3_intro_sfx_00 = new_sfx("Play_Movie_WH3_Great_Bastion_Miao_Ying");

wh3_intro_sfx_01 = new_sfx("play_cat_miao_ying_great_bastion_speech_01_1");
wh3_intro_sfx_02 = new_sfx("play_cat_miao_ying_great_bastion_speech_02_1");
wh3_intro_sfx_03 = new_sfx("play_cat_miao_ying_great_bastion_speech_03_1");
wh3_intro_sfx_04 = new_sfx("play_cat_miao_ying_great_bastion_speech_04_1");
wh3_intro_sfx_05 = new_sfx("play_cat_miao_ying_great_bastion_speech_05_1");

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
		"script/battle/quest_battles/_cutscene/managers/cth_bas_m01.CindySceneManager",			-- path to cindyscene
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
	-- Once more the Bastion is under attack, once more the honour of its defence falls to me. I will not let you down, father!

	-- VO2
	-- They offer only disharmony and darkness, while I bring order and light. Together we shall defend these walls, sell our lives if we must. Ready your weapons!

	-- VO3
	-- Perhaps one day the Great Bastion will fall, but not this day. No, it is the forces of disharmony that shall fall - to our blades! 

	-- VO4
	-- My father, the Celestial Dragon Emperor, watches us! Defend the bastion under his gaze, and you will find his favour! Strength and honour is yours to take! 

	-- VO5
	-- The Ruinous Powers knock upon our gates, but these guests are not welcome! Send them from our threshold with the steel in your hands and in your hearts!

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
				cutscene_intro:play_sound(new_sfx("play_cat_miao_ying_great_bastion_speech_" .. random_index .. "_1"));
				bm:show_subtitle("cat_miao_ying_bat_speeches_" .. random_index, false, true);
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