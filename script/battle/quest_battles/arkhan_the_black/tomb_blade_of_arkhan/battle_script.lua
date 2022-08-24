-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Arkhan the Black
-- Tomb Blade of Arkhan
-- Mortuary of Tzulaqua
-- Defender

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------
load_script_libraries();

bm:camera():fade(true, 0);

gb = generated_battle:new(
	true,                                      		    -- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                      		    -- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
);

--preload stuttering fix
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\tba.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc09_qb_tmb_arkhan_the_tomb_blade_of_arkhan_stage_4_mortuary_of_tzulaqua_part_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc09_qb_tmb_arkhan_the_tomb_blade_of_arkhan_stage_4_mortuary_of_tzulaqua_part_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc09_qb_tmb_arkhan_the_tomb_blade_of_arkhan_stage_4_mortuary_of_tzulaqua_part_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_dlc09_qb_tmb_arkhan_the_tomb_blade_of_arkhan_stage_4_mortuary_of_tzulaqua_part_04");

-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
		
	local cam = bm:camera();
	
	-- REMOVE ME
	cam:fade(true, 0);
	
	-- declare cutscene
	local cutscene_intro = cutscene:new(
		"cutscene_intro", 						-- unique string name for cutscene
		ga_defender_01.sunits,					-- unitcontroller over player's army
		43000, 									-- duration of cutscene in ms
		function() intro_cutscene_end() end		-- what to call when cutscene is finished
	);
	
	local player_units_hidden = false;
	
	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
	
	-- cutscene_intro:set_post_cutscene_fade_time(0);
	
	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()
			local cam = bm:camera();
			cam:fade(true, 0);
			bm:stop_cindy_playback(true);
			
			if player_units_hidden then
				ga_defender_01:set_enabled(true)
			end;
						
			bm:callback(function() cam:fade(false, 0.5) end, 500);
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\tba.CindySceneManager", true) end, 200);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_defender_01:set_enabled(true) 
		end, 
		200
	);	
	cutscene_intro:action(
		function() 
			player_units_hidden = false;
			ga_defender_01:set_enabled(true) 
		end, 
		25000
	);		
	
	-- Voiceover and Subtitles --
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 3000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc09_qb_tmb_arkhan_the_tomb_blade_of_arkhan_stage_4_mortuary_of_tzulaqua_part_01", "subtitle_with_frame", 5.5) end, 3500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 10000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 10500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc09_qb_tmb_arkhan_the_tomb_blade_of_arkhan_stage_4_mortuary_of_tzulaqua_part_02", "subtitle_with_frame", 8) end, 11000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 20000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 20500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc09_qb_tmb_arkhan_the_tomb_blade_of_arkhan_stage_4_mortuary_of_tzulaqua_part_03", "subtitle_with_frame", 9) end, 21000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 31000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 31500);
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc09_qb_tmb_arkhan_the_tomb_blade_of_arkhan_stage_4_mortuary_of_tzulaqua_part_04", "subtitle_with_frame", 10.5) end, 32000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 43000);

	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_defender_01 = gb:get_army(gb:get_player_alliance_num(), 1);	
ga_ai_lzd_01 = gb:get_army(gb:get_non_player_alliance_num(), 1, "First");
ga_ai_lzd_02 = gb:get_army(gb:get_non_player_alliance_num(), 1, "Second");
ga_ai_lzd_03 = gb:get_army(gb:get_non_player_alliance_num(), 1, "Third");

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------
ga_defender_01:goto_location_offset_on_message("battle_started", 0, 60, false);
ga_ai_lzd_01:goto_location_offset_on_message("battle_started", 0, 60, false);

ga_ai_lzd_01:message_on_proximity_to_enemy("release", 100);
ga_ai_lzd_01:message_on_casualties("release", 0.05)
ga_ai_lzd_01:release_on_message("release");

ga_ai_lzd_01:message_on_proximity_to_enemy("reinforcements_1", 10);
ga_ai_lzd_02:reinforce_on_message("reinforcements_1");
ga_ai_lzd_02:release_on_message("reinforcements_1");

ga_ai_lzd_01:message_on_casualties("reinforcements_2", 0.5)
ga_ai_lzd_02:message_on_casualties("reinforcements_2", 0.5)
ga_ai_lzd_03:reinforce_on_message("reinforcements_2");	
ga_ai_lzd_03:release_on_message("reinforcements_2");

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc09_qb_tmb_arkhan_the_tomb_blade_of_arkhan_stage_4_mortuary_of_tzulaqua_hint_main_objective");

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------
gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc09_qb_tmb_arkhan_the_tomb_blade_of_arkhan_stage_4_mortuary_of_tzulaqua_hint_start_battle", 6000, nil, 5000);
gb:queue_help_on_message("reinforcements_1", "wh2_dlc09_qb_tmb_arkhan_the_tomb_blade_of_arkhan_stage_4_mortuary_of_tzulaqua_hint_reinforcements_01", 6000, nil, 2000);
gb:queue_help_on_message("reinforcements_2", "wh2_dlc09_qb_tmb_arkhan_the_tomb_blade_of_arkhan_stage_4_mortuary_of_tzulaqua_hint_reinforcements_02", 6000, nil, 2000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------