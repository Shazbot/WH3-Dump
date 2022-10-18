-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Lokhir Fellheart
-- Helm of the Kraken
-- Black Ark
-- Defender

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
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\rak_m01.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------
wh2_main_sfx_01 = new_sfx("Play_wh2_twa03_rakarth_qb_whip_of_agony_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_twa03_rakarth_qb_whip_of_agony_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_twa03_rakarth_qb_whip_of_agony_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_twa03_rakarth_qb_whip_of_agony_pt_04");
wh2_main_sfx_05 = new_sfx("Play_wh2_twa03_rakarth_qb_whip_of_agony_pt_05");
wh2_main_sfx_start = new_sfx("Play_Movie_WH2_TWA03_Rakarth_Quest_Battle_Intro_Sweetener");

-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

function end_deployment_phase()
bm:out("\tend_deployment_phase() called");
	
	-- teleport units into their desired positions
	--battle_start_teleport_units();
	--bm:modify_battle_speed(0);
	
	local cam = bm:camera();
	
	-- declare cutscene
	local cutscene_intro = cutscene:new(
		"cutscene_intro", 						-- unique string name for cutscene
		ga_player.sunits,					-- unitcontroller over player's army
		44000, 									-- duration of cutscene in ms
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
				ga_player:set_enabled(true)
			end;
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\rak_m01.CindySceneManager", 0, 2) end, 200);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_player:set_enabled(true) 
		end, 
		200
	);		
	
	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_start) end, 0);
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 1000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_twa03_Rakarth_QB_Whip_Of_Agony_pt_01", "subtitle_with_frame", 0.1) end, 1500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 10500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 10750);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_twa03_Rakarth_QB_Whip_Of_Agony_pt_02", "subtitle_with_frame", 0.1) end, 11250);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 19000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 19250);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_twa03_Rakarth_QB_Whip_Of_Agony_pt_03", "subtitle_with_frame", 0.1) end, 19750);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 24000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 24500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_twa03_Rakarth_QB_Whip_Of_Agony_pt_04", "subtitle_with_frame", 0.1) end, 25000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 31000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_05) end, 31500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_twa03_Rakarth_QB_Whip_Of_Agony_pt_05", "subtitle_with_frame", 0.1) end, 32500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 41000);
	
	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player = gb:get_army(gb:get_player_alliance_num(), 1, "");
player_ally_1 = gb:get_army(gb:get_player_alliance_num(),"player_ally_1");
player_ally_2 = gb:get_army(gb:get_player_alliance_num(),"player_ally_2");

enemy_nakai = gb:get_army(gb:get_non_player_alliance_num(),"enemy_nakai");
enemy_priest_beasts = gb:get_army(gb:get_non_player_alliance_num(),"enemy_priest_beasts");
enemy_priest_heavens = gb:get_army(gb:get_non_player_alliance_num(),"enemy_priest_heavens");

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

--Stopping player from firing until the cutscene is done
ga_player:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
player_ally_1:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
player_ally_2:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
enemy_nakai:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);

ga_player:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
player_ally_1:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
player_ally_2:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
player_ally_1:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
player_ally_2:change_behaviour_active_on_message("01_intro_cutscene_end", "skirmish", false, false);
enemy_nakai:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

--Forcing AI allies to attack then release once they engage enemy
player_ally_1:attack_on_message("01_intro_cutscene_end", 10);
player_ally_2:attack_on_message("01_intro_cutscene_end", 10);
player_ally_1:message_on_proximity_to_enemy("player_ally_1_engaged", 50);
player_ally_2:message_on_proximity_to_enemy("player_ally_2_engaged", 50);
player_ally_1:release_on_message("player_ally_1_engaged", 10);
player_ally_2:release_on_message("player_ally_2_engaged", 10);

--Releasing core AI army and forcing Nakai and his defenders to defend their poisition
enemy_nakai:release_on_message("01_intro_cutscene_end", 10);

------------------------------------------------------------------------
------------------------- ENEMY REINFORCEMENTS -------------------------
------------------------------------------------------------------------

--reinforcement messages after allotted time since 01_intro_cutscene_end message received
gb:message_on_time_offset("reinforcements_heavens", 100000, "01_intro_cutscene_end")
gb:message_on_time_offset("reinforcements_beasts", 145000, "01_intro_cutscene_end")

--enemy_priest_beasts reinforce after receiving messages
enemy_priest_beasts:reinforce_on_message("reinforcements_beasts", 1000);
enemy_priest_beasts:release_on_message("reinforcements_beasts", 1000);

--enemy_priest_heavens reinforce after receiving messages
enemy_priest_heavens:reinforce_on_message("reinforcements_heavens", 1000);
enemy_priest_heavens:release_on_message("reinforcements_heavens", 1000);

------------------------------------------------------------------------
------------------------------- OBJECTIVES -----------------------------
------------------------------------------------------------------------

objective = "wh2_twa03_qb_def_rakarth_whip_of_agony";

gb:set_objective_on_message("01_intro_cutscene_end", objective);

gb:complete_objective_on_message("defenders_defeated", objective);

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------
--Setting up Victory/Defeat conditions
ga_player:message_on_rout_proportion("player_defeated", 0.95);
enemy_nakai:message_on_rout_proportion("enemy_nakai_defeated", 0.9);

--Listening for Victory/Defeat Conditions
ga_player:force_victory_on_message("enemy_nakai_defeated", 5000);
enemy_nakai:force_victory_on_message("player_defeated", 5000);
