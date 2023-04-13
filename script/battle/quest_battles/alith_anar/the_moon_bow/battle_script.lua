-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Alith Anar
-- The Moon Bow
-- INSERT ENVIRONMENT NAME
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
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\scenes\\tmb_s01.CindyScene";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc10_HEF_Alith_Anar_QB_moonbow_pt_1");

-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
	
	-- teleport units into their desired positions
	battle_start_teleport_units();
	local cam = bm:camera();
		
	-- declare cutscene
	local cutscene_intro = cutscene:new(
		"cutscene_intro", 						-- unique string name for cutscene
		ga_attacker_01.sunits,					-- unitcontroller over player's army
		30000, 									-- duration of cutscene in ms
		function() intro_cutscene_end() end		-- what to call when cutscene is finished
	);
	
	local player_units_hidden = false;
	
	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
		
	cutscene_intro:set_post_cutscene_fade_time(2.5, 3200);
	
	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()		
			local cam = bm:camera();
			bm:stop_cindy_playback(true);		
			if player_units_hidden then
				ga_attacker_01:set_enabled(true)
			end;
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\scenes\\tmb_s01.CindyScene", true) end, 200);
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
		30000
	);		
	
	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 3000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc10_qb_hef_alith_anar_the_moon_bow_stage_4_intro_01", "subtitle_with_frame", 0.1) end, 3500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 11500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 12000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc10_qb_hef_alith_anar_the_moon_bow_stage_4_intro_02", "subtitle_with_frame", 0.1) end, 12500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 20500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 21500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc10_qb_hef_alith_anar_the_moon_bow_stage_4_intro_03", "subtitle_with_frame", 0.1) end, 22000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 29500);
	
	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_attacker_01 = gb:get_army(gb:get_player_alliance_num(), 1, "");
ga_player_reinf_01 = gb:get_army(gb:get_player_alliance_num(),"reinforcements");
ga_bait = gb:get_army(gb:get_non_player_alliance_num(),"enemy_army");
ga_flank_1 = gb:get_army(gb:get_non_player_alliance_num(),"flank_1");
ga_flank_2 = gb:get_army(gb:get_non_player_alliance_num(),"flank_2");
ga_enemy_reinf_01 = gb:get_army(gb:get_non_player_alliance_num(),"enemy_reinforcements");

-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------

function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");
	
--teleport unit (1) of ga_defender_03 to [450, 20] with an orientation of 45 degrees and a width of 25m
	ga_flank_1.sunits:item(1).uc:teleport_to_location(v(-500, -50), 180, 25);
--	teleport unit (2) of ga_defender_03 to [410, 35] with an orientation of 45 degrees and a width of 25m
	ga_flank_1.sunits:item(2).uc:teleport_to_location(v(-480, -125), 180, 25);
--	teleport unit (3) of ga_defender_03 to [390, 20] with an orientation of 45 degrees and a width of 25m
	ga_flank_1.sunits:item(3).uc:teleport_to_location(v(-532, -81), 180, 25);
--	teleport unit (4) of ga_defender_03 to [430, 65] with an orientation of 45 degrees and a width of 25m
	ga_flank_1.sunits:item(4).uc:teleport_to_location(v(-521, -220), 180, 25);
--	teleport unit (6) of ga_defender_03 to [400, 0] with an orientation of 45 degrees and a width of 25m
	ga_flank_2.sunits:item(1).uc:teleport_to_location(v(570, -410), 180, 25);
--	teleport unit (6) of ga_defender_03 to [400, 0] with an orientation of 45 degrees and a width of 25m
	ga_flank_2.sunits:item(2).uc:teleport_to_location(v(610, -400), 180, 25);
--	teleport unit (6) of ga_defender_03 to [400, 0] with an orientation of 45 degrees and a width of 25m
	ga_flank_2.sunits:item(3).uc:teleport_to_location(v(585, -380), 180, 25);
--	teleport unit (6) of ga_defender_03 to [400, 0] with an orientation of 45 degrees and a width of 25m
	ga_flank_2.sunits:item(4).uc:teleport_to_location(v(570, -320), 180, 25);
end;

-------------------------------------------------------------------------------------------------
------------------------------------------ ORDERS -------------------------------------------
-------------------------------------------------------------------------------------------------
gb:message_on_time_offset("action1", 60000);

ga_player_reinf_01:release_on_message("action1");

ga_attacker_01:goto_location_offset_on_message("battle_started", 20, 0, false);
ga_flank_1:message_on_proximity_to_enemy("close_to_flank1", 100);
ga_flank_2:message_on_proximity_to_enemy("close_to_flank2", 100);
ga_bait:message_on_proximity_to_enemy("close_to_bait", 100);
ga_flank_1:message_on_casualties("flank_1_dying", 0.15);
ga_flank_2:message_on_casualties("flank_2_dying", 0.15);
ga_attacker_01:message_on_casualties("reinforcements_player", 0.25);
ga_bait:message_on_casualties("close_to_bait", 0.1);
ga_flank_2:message_on_under_attack("flank_2_under_attack");
ga_flank_1:message_on_under_attack("flank_1_under_attack");
ga_bait:message_on_casualties("reinforcements_enemy", 0.35);

ga_bait:defend_on_message("01_intro_cutscene_end", -60, 160, 60); 

--ga_flank_2:defend_on_message("close_to_flank2",-60, 150, 30);
ga_bait:release_on_message("close_to_bait");

ga_flank_1:attack_on_message("close_to_flank1");
ga_flank_2:release_on_message("flank_2_under_attack");
ga_flank_2:release_on_message("close_to_flank2");
ga_bait:release_on_message("flank_1_dying");
ga_flank_1:attack_on_message("flank_1_under_attack");
ga_flank_2:release_on_message("flank_1_dying");
ga_flank_1:release_on_message("flank_1_dying");
ga_flank_1:release_on_message("flank_2_dying");
ga_bait:release_on_message("flank_2_dying");

ga_flank_1:release_on_message("close_to_bait");
ga_flank_2:release_on_message("close_to_bait");

--ga_flank_1:release_on_message("close_to_flank2");

ga_flank_2:release_on_message("flank_arrived");
ga_bait:release_on_message("flank_arrived");
ga_flank_1:release_on_message("flank_arrived");


--ga_player_reinf_01:release_on_message("reinforcements_player"); 
--ga_player_reinf_01:release_on_message("reinforcements_player");

ga_enemy_reinf_01:reinforce_on_message("reinforcements_enemy", 100);
ga_enemy_reinf_01:release_on_message("reinforcements_enemy"); 


-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc10_hef_alith_anar_the_moon_bow_stage_4_hints_main_start_battle");

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc10_hef_alith_anar_the_moon_bow_stage_4_hints_main_objective", 6000, nil, 5000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------