-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Khatep
-- The Liche Staff
-- The Pits of Zardok
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();

bm:camera():fade(true, 0);

gb = generated_battle:new(
	true,                                    		    -- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                      		    -- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
);

--preload stuttering fix
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\tls.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc09_qb_tmb_khatep_the_liche_staff_stage_5_pits_of_zardok_part_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc09_qb_tmb_khatep_the_liche_staff_stage_5_pits_of_zardok_part_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc09_qb_tmb_khatep_the_liche_staff_stage_5_pits_of_zardok_part_03");

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
		48000, 									-- duration of cutscene in ms
		function() intro_cutscene_end() end		-- what to call when cutscene is finished
	);
	
	local player_units_hidden = false;
	
	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
	
	--cutscene_intro:set_is_ambush();
	
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

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\tls.CindySceneManager", true) end, 200);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_attacker_01:set_enabled(true) 
		end, 
		200
	);	
	
	-- Voiceover and Subtitles --
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 3000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc09_qb_tmb_khatep_the_liche_staff_stage_5_pits_of_zardok_part_01", "subtitle_with_frame", 16) end, 4000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 20500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 21000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc09_qb_tmb_khatep_the_liche_staff_stage_5_pits_of_zardok_part_02", "subtitle_with_frame", 8)	end, 21500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 30000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 30500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc09_qb_tmb_khatep_the_liche_staff_stage_5_pits_of_zardok_part_03", "subtitle_with_frame", 16) end, 31000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 48000);

	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;
-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_attacker_01 = gb:get_army(gb:get_player_alliance_num(), 1);
ga_defender_01 = gb:get_army(gb:get_non_player_alliance_num(), 1,"enemy_army_1");
ga_defender_02 = gb:get_army(gb:get_non_player_alliance_num(), 2,"enemy_army_2");

if ga_defender_02 then
	ga_defender_03 = gb:get_army(gb:get_non_player_alliance_num(), 3,"enemy_army_3");
else
	ga_defender_02 = gb:get_army(gb:get_non_player_alliance_num(), 3,"enemy_army_2");
	ga_defender_03 = gb:get_army(gb:get_non_player_alliance_num(), 2,"enemy_army_3");
end;

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------
ga_attacker_01:set_always_visible_on_message("battle_started", true, false);
ga_defender_01:set_always_visible_on_message("battle_started", true, false);

--gb:message_on_time_offset("move_forward_01", 20);
ga_attacker_01:goto_location_offset_on_message("battle_started", 0, 90, false);
ga_defender_01:goto_location_offset_on_message("battle_started", 0, 90, false);

ga_defender_01:attack_on_message("01_intro_cutscene_end");

ga_defender_01:message_on_casualties("reinforcements_1", 0.30);
ga_defender_02:message_on_proximity_to_enemy("reinforcements_2", 10);

ga_defender_02:reinforce_on_message("reinforcements_1", 100);
ga_defender_03:reinforce_on_message("reinforcements_2", 100);
ga_defender_02:release_on_message("reinforcements_1"); 
ga_defender_03:release_on_message("reinforcements_2"); 

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------
  
gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc09_qb_tmb_khatep_the_liche_staff_stage_5_pits_of_zardok_hints_main_objective");

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc09_qb_tmb_khatep_the_liche_staff_stage_5_pits_of_zardok_hints_start_battle", 6000, nil, 5000);
gb:queue_help_on_message("reinforcements_1", "wh2_dlc09_qb_tmb_khatep_the_liche_staff_stage_5_pits_of_zardok_hints_reinforcements_01", 6000, nil, 4000);
gb:queue_help_on_message("reinforcements_2", "wh2_dlc09_qb_tmb_khatep_the_liche_staff_stage_5_pits_of_zardok_hints_reinforcements_02", 6000, nil, 4000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------