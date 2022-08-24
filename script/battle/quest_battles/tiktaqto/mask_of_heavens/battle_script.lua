-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Tiktaq'to	
-- Mask of Heavens
-- wh_tik_taq_to
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();

bm:camera():fade(true, 0);

gb = generated_battle:new(
	true,                                      		    -- screen starts black
	false,                                      		-- prevent deployment for player
	false,                                      		-- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
);

--preload stuttering fix
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\tik.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc12_lzd_tiktaqto_QB_mask_of_heavens_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc12_lzd_tiktaqto_QB_mask_of_heavens_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc12_lzd_tiktaqto_QB_mask_of_heavens_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_dlc12_lzd_tiktaqto_QB_mask_of_heavens_pt_04");
wh2_main_sfx_05 = new_sfx("Play_wh2_dlc12_lzd_tiktaqto_QB_mask_of_heavens_pt_05");
-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player = gb:get_army(gb:get_player_alliance_num(), 1, "");
ga_enemy_main = gb:get_army(gb:get_non_player_alliance_num(),"enemy_main");

ga_enemy_reinforcements_1 = gb:get_army(gb:get_non_player_alliance_num(),"enemy_reinforcements_1");
ga_enemy_reinforcements_2 = gb:get_army(gb:get_non_player_alliance_num(),"enemy_reinforcements_2");
ga_enemy_reinforcements_3 = gb:get_army(gb:get_non_player_alliance_num(),"enemy_reinforcements_3");

-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");

	--bm:modify_battle_speed(0);
	
	local cam = bm:camera();
	
	-- declare cutscene
	local cutscene_intro = cutscene:new(
		"cutscene_intro", 						-- unique string name for cutscene
		ga_player.sunits,						-- unitcontroller over player's army
		40000, 									-- duration of cutscene in ms
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
				ga_player:set_enabled(true)
			end;
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\tik.CindySceneManager", true) end, 200);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_player:set_enabled(true) 
		end, 
		200
	);	
	
	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 2500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc12_lzd_tiktaqto_QB_mask_of_heavens_pt_01", "subtitle_with_frame", 4, true) end, 3000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 11500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 11500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc12_lzd_tiktaqto_QB_mask_of_heavens_pt_02", "subtitle_with_frame", 4, true) end, 12000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 21500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 22000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc12_lzd_tiktaqto_QB_mask_of_heavens_pt_03", "subtitle_with_frame", 1, true) end, 22500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 25000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 25500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc12_lzd_tiktaqto_QB_mask_of_heavens_pt_04", "subtitle_with_frame", 3, true) end, 26000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 32500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_05) end, 33000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc12_lzd_tiktaqto_QB_mask_of_heavens_pt_05", "subtitle_with_frame", 2, true) end, 33500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 39000);
	
	cutscene_intro:start();
	
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;


-------------------------------------------------------------------------------------------------
------------------------------------------ ORDERS -------------------------------------------
-------------------------------------------------------------------------------------------------
--Stopping player from firing until the cutscene is done
ga_player:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_enemy_main:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_player:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
ga_enemy_main:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

ga_enemy_main:message_on_rout_proportion("enemy_reinforcements_wave_1", 0.5);
ga_enemy_reinforcements_1:message_on_under_attack("enemy_reinforcements_wave_2", 150000); --150 seconds after reinforcements are engaged

ga_enemy_reinforcements_1:reinforce_on_message("enemy_reinforcements_wave_1", 5000);
ga_enemy_reinforcements_2:reinforce_on_message("enemy_reinforcements_wave_1", 5000);
ga_enemy_reinforcements_3:reinforce_on_message("enemy_reinforcements_wave_2", 5000);

ga_enemy_reinforcements_1:release_on_message("enemy_reinforcement_release_wave_1");
ga_enemy_reinforcements_2:release_on_message("enemy_reinforcement_release_wave_1");
ga_enemy_reinforcements_3:release_on_message("enemy_reinforcement_release_wave_2");

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc12_lzd_tiktaqto_mask_of_heavens_stage_5_hints_main_objective");

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc12_lzd_tiktaqto_mask_of_heavens_stage_5_hints_start_battle", 6000, nil, 5000);
gb:queue_help_on_message("enemy_reinforcements_wave_1", "wh2_dlc12_lzd_tiktaqto_mask_of_heavens_stage_5_hints_reinforcements", 6000, nil, 10);
gb:queue_help_on_message("enemy_reinforcement_release_wave_2", "wh2_dlc12_lzd_tiktaqto_mask_of_heavens_stage_5_hints_enemy_commander", 6000, nil, 10);

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------