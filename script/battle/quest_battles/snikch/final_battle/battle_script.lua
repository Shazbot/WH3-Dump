-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Snikch
-- Final Battle
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
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\rod_snikch.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc14_snikch_final_battle_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc14_snikch_final_battle_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc14_snikch_final_battle_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_dlc14_snikch_final_battle_pt_04");
wh2_main_sfx_05 = new_sfx("Play_wh2_dlc14_snikch_final_battle_pt_05");

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_attacker_01 = gb:get_army(gb:get_player_alliance_num(), 1, "");
ga_reinforcements = gb:get_army(gb:get_player_alliance_num(),"reinforcements");
ga_enemy = gb:get_army(gb:get_non_player_alliance_num(),"enemy_army");
ga_enemy_flank = gb:get_army(gb:get_non_player_alliance_num(),"ally");
ga_enemy_reinforcements = gb:get_army(gb:get_non_player_alliance_num(),"enemy_reinforcements");


-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------

function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");
	
--teleport unit (1) of ga_artillery to [645, -420] with an orientation of 45 degrees and a width of 25m
--ga_enemy_flank.sunits:item(1).uc:teleport_to_location(v(645, -420), 180, 25);
--teleport unit (2) of ga_artillery to [600, -440] with an orientation of 45 degrees and a width of 25m
--ga_enemy_flank.sunits:item(2).uc:teleport_to_location(v(600, -440), 180, 25);
--teleport unit (3) of ga_artillery to [620, -430] with an orientation of 45 degrees and a width of 25m
--ga_enemy_flank.sunits:item(3).uc:teleport_to_location(v(620, -430), 180, 25);
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

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\rod_snikch.CindySceneManager", 0, 2) end, 540);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_attacker_01:set_enabled(true) 
		end, 
		540
	);	
	
	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc14_Snikch_final_battle_pt_01", "subtitle_with_frame", 4, true) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 11000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 11500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc14_Snikch_final_battle_pt_02", "subtitle_with_frame", 4, true) end, 11500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 24000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 24500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc14_Snikch_final_battle_pt_03", "subtitle_with_frame", 4, true) end, 24500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 30000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 30500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc14_Snikch_final_battle_pt_04", "subtitle_with_frame", 4, true) end, 30500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 39000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_05) end, 39500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc14_Snikch_final_battle_pt_05", "subtitle_with_frame", 4, true) end, 39500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 49000);

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

gb:message_on_time_offset("attack_flank", 20000,"01_intro_cutscene_end");
gb:message_on_time_offset("release", 30000,"01_intro_cutscene_end");
gb:message_on_time_offset("fight", 10000,"battle_started");
gb:message_on_time_offset("fight_2", 5000,"01_intro_cutscene_end");
gb:message_on_time_offset("enemy_reinforce", 240000,"01_intro_cutscene_end");
gb:message_on_time_offset("reinforcement_release", 250000,"01_intro_cutscene_end");

--gb:block_message_on_message("garrison_dead", "enemy_reinforce", true);

ga_enemy:message_on_commander_death("malus_dead", 1);
ga_reinforcements:message_on_casualties("ally_dying", 0.5);
--ga_enemy_flank:message_on_shattered_proportion("garrison_dead", 1);

ga_enemy_reinforcements:reinforce_on_message("enemy_reinforce");
ga_enemy_flank:defend_on_message("01_intro_cutscene_end",-90, 0, 100);
ga_enemy_flank:release_on_message("release");
ga_enemy:attack_on_message("fight");
ga_enemy:attack_on_message("fight_2");
ga_reinforcements:release_on_message("fight");
ga_reinforcements:release_on_message("fight_2");
ga_enemy_reinforcements:release_on_message("reinforcement_release");

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc14_qb_skv_snikch_final_battle_objective_1");
gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc14_qb_skv_snikch_final_battle_objective_2");

gb:complete_objective_on_message("malus_dead", "wh2_dlc14_qb_skv_snikch_final_battle_objective_2", 5);

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc14_qb_skv_snikch_final_battle_hint_1", 6000, nil, 5000);
gb:queue_help_on_message("ally_dying", "wh2_dlc14_qb_skv_snikch_final_battle_hint_2", 6000, nil, 5000);
gb:queue_help_on_message("enemy_reinforce", "wh2_dlc14_qb_skv_snikch_final_battle_hint_reinforcements", 6000, nil, 5000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------