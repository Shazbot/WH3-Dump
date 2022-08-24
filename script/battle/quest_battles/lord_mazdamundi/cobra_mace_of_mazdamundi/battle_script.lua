-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Lord Mazdamundi
-- Cobra Mace of Mazdamundi
-- Isle of the Crimson Skull
-- Attacker

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
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\cmm.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_main_qb_lzd_mazdamundi_cobra_mace_of_mazdamundi_stage_3_isle_of_the_crimson_skull_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_main_qb_lzd_mazdamundi_cobra_mace_of_mazdamundi_stage_3_isle_of_the_crimson_skull_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_main_qb_lzd_mazdamundi_cobra_mace_of_mazdamundi_stage_3_isle_of_the_crimson_skull_pt_03");



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
		ga_attacker_01.sunits,					-- unitcontroller over player's army
		33000, 									-- duration of cutscene in ms
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
				ga_attacker_01:set_enabled(true)
			end;
						
			bm:callback(function() cam:fade(false, 0.5) end, 500);
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\cmm.CindySceneManager", true) end, 200);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_attacker_01:set_enabled(true) 
		end, 
		200
	);	
	cutscene_intro:action(
		function() 
			player_units_hidden = false;
			ga_attacker_01:set_enabled(true) 
		end, 
		25000
	);		
	
	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 3000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_lzd_mazdamundi_cobra_mace_of_mazdamundi_stage_3_isle_of_the_crimson_skull_pt_01", "subtitle_with_frame", 5.5, true)	end, 4500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 11300);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 11800);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_lzd_mazdamundi_cobra_mace_of_mazdamundi_stage_3_isle_of_the_crimson_skull_pt_02", "subtitle_with_frame", 11, true)	end, 13300);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 25800);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 26300);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_lzd_mazdamundi_cobra_mace_of_mazdamundi_stage_3_isle_of_the_crimson_skull_pt_03", "subtitle_with_frame", 5, true)	end, 27300);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 33000);
	

	
	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_attacker_01 = gb:get_army(gb:get_player_alliance_num(), 1);
ga_defender_01 = gb:get_army(gb:get_non_player_alliance_num(), 1,"enemy_army");
ga_defender_02 = gb:get_army(gb:get_non_player_alliance_num(), 1,"enemy_sacrifice");
ga_ambush_01 = gb:get_army(gb:get_non_player_alliance_num(), 2,"enemy_reinforcements_1");

ga_ambush_01:get_army():suppress_reinforcement_adc();


-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

ga_defender_01:goto_location_offset_on_message("battle_started", 0, 50, false);	
ga_defender_02:goto_location_offset_on_message("battle_started", 0, 50, false);	
ga_attacker_01:goto_location_offset_on_message("battle_started", 0, 50, false);	

ga_ambush_01:release_on_message("battle_started");
--ga_defender_02:defend_on_message("battle_started",100, 200, 60);

ga_defender_01:message_on_proximity_to_enemy("release", 250);
ga_defender_01:release_on_message("release");
ga_defender_02:release_on_message("release");


--ga_defender_02:message_on_proximity_to_enemy("attack", 300);
--ga_defender_02:attack_on_message("release");


ga_defender_01:message_on_proximity_to_enemy("ambush_1", 5);


ga_ambush_01:reinforce_on_message("ambush_1");
ga_ambush_01:attack_on_message("ambush_1");
ga_ambush_01:message_on_seen_by_enemy("ambush_spotted");

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_locatable_objective_on_message("01_intro_cutscene_end", "wh2_main_qb_lzd_mazdamundi_cobra_mace_of_mazdamundi_stage_3_isle_of_the_crimson_skull_hint_main_objective", 100, v(116.9, 548.9, 31.8), v(110.5, 527.4, 248.1), 15);        
gb:add_ping_icon_on_message("01_intro_cutscene_end", v(99, 525, 187), 15, 3000, 7000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh2_main_qb_lzd_mazdamundi_cobra_mace_of_mazdamundi_stage_3_isle_of_the_crimson_skull_hint_main_hint", 6000, nil, 5000);
gb:queue_help_on_message("ambush_spotted", "wh2_main_qb_lzd_mazdamundi_cobra_mace_of_mazdamundi_stage_3_isle_of_the_crimson_skull_hint_reinforcements");


-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------
