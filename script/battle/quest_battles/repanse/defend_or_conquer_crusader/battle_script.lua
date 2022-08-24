-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Repanse
-- Final Battle - Vanquish
-- INSERT ENVIRONMENT NAME
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();
bm = battle_manager:new(empire_battle:new());

bm:camera():fade(true, 0);

gb = generated_battle:new(
	true,                                      		    -- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                      		    -- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
);

--preload stuttering fix
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\vou.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc14_Repanse_de_Lyonese_final_battle_vanquisher_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc14_Repanse_de_Lyonese_final_battle_vanquisher_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc14_Repanse_de_Lyonese_final_battle_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_dlc14_Repanse_de_Lyonese_final_battle_pt_04");
wh2_main_sfx_05 = new_sfx("Play_wh2_dlc14_Repanse_de_Lyonese_final_battle_pt_05");

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_attacker_01 = gb:get_army(gb:get_player_alliance_num(), 1);
ga_ai_ally_errants = gb:get_army(gb:get_player_alliance_num(), "errant_knights");
ga_ai_ally_peasants = gb:get_army(gb:get_player_alliance_num(), "peasants");

ga_ai_tombk_01 = gb:get_army(gb:get_non_player_alliance_num(), "final_tombk_1");
ga_ai_tombk_02 = gb:get_army(gb:get_non_player_alliance_num(), "final_tombk_2");
ga_ai_tombk_03 = gb:get_army(gb:get_non_player_alliance_num(), "final_tombk_3");
ga_ai_tombk_04 = gb:get_army(gb:get_non_player_alliance_num(), "final_tombk_4");

-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------

function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");
	
	--ga_scorpion.sunits:item(1).uc:teleport_to_location(v(372, 33), 50, 25);

end;

-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
	
	-- teleport units into their desired positions
	battle_start_teleport_units();
	--bm:modify_battle_speed(0);
	
	local cam = bm:camera();
	
	-- declare cutscene
	local cutscene_intro = cutscene:new(
		"cutscene_intro", 						-- unique string name for cutscene
		ga_attacker_01.sunits,					-- unitcontroller over player's army
		49000, 									-- duration of cutscene in ms
		function() intro_cutscene_end() end		-- what to call when cutscene is finished
	);
	
	local player_units_hidden = false;
	
	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
		
	cutscene_intro:set_post_cutscene_fade_time(3.0, 3200);
	
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

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\vou.CindySceneManager", 0, 2) end, 490);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_attacker_01:set_enabled(true) 
		end, 
		490
	);	
	
	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc14_Repanse_de_Lyonese_final_battle_vanquisher_pt_01", "subtitle_with_frame", 4, true) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 15000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 15500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc14_Repanse_de_Lyonese_final_battle_vanquisher_pt_02", "subtitle_with_frame", 4, true) end, 15500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 26500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 26500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc14_Repanse_de_Lyonese_final_battle_pt_03", "subtitle_with_frame", 4, true) end, 26500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 35500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 36000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc14_Repanse_de_Lyonese_final_battle_pt_04", "subtitle_with_frame", 4, true) end, 36000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 44000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_05) end, 45500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc14_Repanse_de_Lyonese_final_battle_pt_05", "subtitle_with_frame", 2, true) end, 45500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 49000);

	cutscene_intro:start();
	
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;


-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc14_qb_brt_repanse_defend_or_conquer_crusader_01", 6000, nil, 8000);
gb:queue_help_on_message("peasants_advance", "wh2_dlc14_qb_brt_repanse_defend_or_conquer_crusader_02", 6000, nil, 8000);
gb:queue_help_on_message("tombk_3_advance", "wh2_dlc14_qb_brt_repanse_defend_or_conquer_crusader_03", 6000, nil, 8000);
gb:queue_help_on_message("tombk_4_advance", "wh2_dlc14_qb_brt_repanse_defend_or_conquer_crusader_04", 6000, nil, 8000);


-------------------------------------------------------------------------------------------------
------------------------------------------ ORDERS -------------------------------------------
-------------------------------------------------------------------------------------------------


ga_ai_ally_errants:attack_on_message("battle_started");
ga_ai_tombk_01:attack_on_message("battle_started");
ga_ai_tombk_02:release_on_message("01_intro_cutscene_end");
gb:message_on_time_offset("ally_release", 100000,"01_intro_cutscene_end");
gb:message_on_time_offset("enemy_release", 110000,"01_intro_cutscene_end");
ga_ai_ally_errants:release_on_message("ally_release");
ga_ai_tombk_01:release_on_message("enemy_release");
ga_ai_ally_peasants:reinforce_on_message("battle_started",200000);

ga_ai_tombk_02:message_on_casualties("tombk_2_hurt",0.5);

ga_ai_tombk_03:reinforce_on_message("tombk_2_hurt",50000);
ga_ai_tombk_04:reinforce_on_message("tombk_2_hurt",250000);
ga_ai_tombk_03:reinforce_on_message("battle_started",400000);
ga_ai_tombk_04:reinforce_on_message("battle_started",600000);


ga_ai_ally_peasants:release_on_message("battle_started",210000);
ga_ai_tombk_03:release_on_message("tombk_2_hurt",60000);
ga_ai_tombk_03:release_on_message("battle_started",410000);
ga_ai_tombk_04:release_on_message("tombk_2_hurt",260000);
ga_ai_tombk_04:release_on_message("tombk_2_hurt",6100000);

ga_ai_ally_peasants:message_on_any_deployed("peasants_advance");
ga_ai_tombk_03:message_on_any_deployed("tombk_3_advance");
ga_ai_tombk_04:message_on_any_deployed("tombk_4_advance");


