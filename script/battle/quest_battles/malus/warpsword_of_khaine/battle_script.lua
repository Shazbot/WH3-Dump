-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Malus
-- Warpsword of Khaine
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
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\40_mal_r02.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc14_emp_Malus_Darkblade_Warpsword_of_Khaine_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc14_emp_Malus_Darkblade_Warpsword_of_Khaine_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc14_emp_Malus_Darkblade_Warpsword_of_Khaine_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_dlc14_emp_Malus_Darkblade_Warpsword_of_Khaine_pt_04");
wh2_main_sfx_05 = new_sfx("Play_wh2_dlc14_emp_Malus_Darkblade_Warpsword_of_Khaine_pt_05");

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_attacker_01 = gb:get_army(gb:get_player_alliance_num(), 1, "");
ga_enemy = gb:get_army(gb:get_non_player_alliance_num(),"enemy_army");
ga_enemy_flank = gb:get_army(gb:get_non_player_alliance_num(),"enemy_flank");
ga_enemy_reinforcements = gb:get_army(gb:get_non_player_alliance_num(),"enemy_reinforcements");


-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------

function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");
	
--teleport unit (1) of ga_artillery to [645, -420] with an orientation of 45 degrees and a width of 25m
ga_enemy_flank.sunits:item(1).uc:teleport_to_location(v(645, -420), 180, 25);
--teleport unit (2) of ga_artillery to [600, -440] with an orientation of 45 degrees and a width of 25m
ga_enemy_flank.sunits:item(2).uc:teleport_to_location(v(600, -440), 180, 25);
--teleport unit (3) of ga_artillery to [620, -430] with an orientation of 45 degrees and a width of 25m
ga_enemy_flank.sunits:item(3).uc:teleport_to_location(v(620, -430), 180, 25);
--teleport unit (4) of ga_artillery to [630, -410] with an orientation of 45 degrees and a width of 25m
--ga_enemy_flank.sunits:item(4).uc:teleport_to_location(v(630, -410), 180, 25);
	
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
		75000, 									-- duration of cutscene in ms
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

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\40_mal_r02.CindySceneManager", 0, 2) end, 200);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_attacker_01:set_enabled(true) 
		end, 
		200
	);	
	
	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc14_emp_Malus_Darkblade_Warpsword_of_Khaine_pt_01", "subtitle_with_frame", 8, true) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 15000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 16000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc14_emp_Malus_Darkblade_Warpsword_of_Khaine_pt_02", "subtitle_with_frame", 8, true) end, 16000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 36000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 37000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc14_emp_Malus_Darkblade_Warpsword_of_Khaine_pt_03", "subtitle_with_frame", 8, true) end, 37000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 46000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 47500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc14_emp_Malus_Darkblade_Warpsword_of_Khaine_pt_04", "subtitle_with_frame", 8, true) end, 47500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 61200);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_05) end, 63500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc14_emp_Malus_Darkblade_Warpsword_of_Khaine_pt_05", "subtitle_with_frame", 8, true) end, 63500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 73500);

	cutscene_intro:start();
	
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;


-------------------------------------------------------------------------------------------------
------------------------------------------ ORDERS -------------------------------------------
-------------------------------------------------------------------------------------------------

--Stopping armies from firing until the cutscene is done
ga_attacker_01:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_attacker_01:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

ga_enemy:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_enemy:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

ga_enemy_flank:defend_on_message("01_intro_cutscene_end", 643, 472, -82);
ga_enemy_flank:message_on_proximity_to_enemy("close_to_player", 40);
gb:message_on_time_offset("flank_attack", 40000,"01_intro_cutscene_end");
gb:message_on_time_offset("flank_release", 180000,"01_intro_cutscene_end");

ga_enemy_flank:attack_on_message("close_to_player");
ga_enemy_flank:attack_on_message("flank_attack");
ga_enemy_flank:release_on_message("flank_release");

gb:message_on_time_offset("reinforce", 180000,"01_intro_cutscene_end");
gb:message_on_time_offset("reinforcement_release", 190000,"01_intro_cutscene_end");

gb:message_on_time_offset("enemy_release", 90000,"01_intro_cutscene_end");
ga_enemy:attack_on_message("01_intro_cutscene_end");
ga_enemy:release_on_message("enemy_release");

ga_enemy_reinforcements:reinforce_on_message("reinforce", 10);
ga_enemy_reinforcements:release_on_message("reinforcement_release");

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc14_qb_def_malus_warpsword_of_khaine_stage_4_objective_1");

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc14_qb_def_malus_warpsword_of_khaine_stage_4_hint_1", 6000, nil, 5000);
gb:queue_help_on_message("reinforce", "wh2_dlc14_qb_def_malus_warpsword_of_khaine_stage_4_hint_2", 6000, nil, 5000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------