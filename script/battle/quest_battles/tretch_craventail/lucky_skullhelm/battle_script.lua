-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Tretch Craventail
-- Lucky Skullhelm
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();

bm:camera():fade(true, 0);

gb = generated_battle:new(
	true,                                      		    -- screen starts black
	false, 	                                     		-- prevent deployment for player
	true,                                      		    -- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
);

-- preload stuttering fix
-- bm:cindy_preload("script/battle/quest_battles/_cutscene/managers/hds.CindySceneManager");

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player = gb:get_army(gb:get_player_alliance_num(), 1, "");
ga_enemy_main = gb:get_army(gb:get_non_player_alliance_num(), 1, "");
ga_enemy_spoof_reinforcements = gb:get_army(gb:get_non_player_alliance_num(), "spoof_reinforcements");
ga_enemy_reinforcements = gb:get_army(gb:get_non_player_alliance_num(), "greenskin_reinforcements");
ga_enemy_skaven = gb:get_army(gb:get_non_player_alliance_num(), "skaven_reinforcements");


-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

intro_sfx_01 = new_sfx("Play_dlc09_qb_skv_tretch_craventail_lucky_skullhelm_stage_5_intro_01");
intro_sfx_02 = new_sfx("Play_dlc09_qb_skv_tretch_craventail_lucky_skullhelm_stage_5_intro_02");
intro_sfx_03 = new_sfx("Play_dlc09_qb_skv_tretch_craventail_lucky_skullhelm_stage_5_intro_03");

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
		ga_player.sunits,					-- unitcontroller over player's army
		34000, 									-- duration of cutscene in ms
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
				ga_player:set_enabled(true)
			end;
						
			bm:callback(function() cam:fade(false, 0.5) end, 500);
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\lsh.CindySceneManager", true) end, 200);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_player:set_enabled(true) 
		end, 
		200
	);	
	cutscene_intro:action(
		function() 
			player_units_hidden = false;
			ga_player:set_enabled(true) 
		end, 
		25000
	);		
	
	-- Voiceover and Subtitles --

	cutscene_intro:action(function() cutscene_intro:play_sound(intro_sfx_01) end, 3000);
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_dlc09_qb_skv_tretch_craventail_lucky_skullhelm_stage_5_intro_01", "subtitle_with_frame", 7) end, 3500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 11000);

	cutscene_intro:action(function() cutscene_intro:play_sound(intro_sfx_02) end, 12500);		
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_dlc09_qb_skv_tretch_craventail_lucky_skullhelm_stage_5_intro_02", "subtitle_with_frame", 11) end, 13000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 24500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(intro_sfx_03) end, 25000);		
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_dlc09_qb_skv_tretch_craventail_lucky_skullhelm_stage_5_intro_03", "subtitle_with_frame", 7) end, 25500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 33500);

	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------
ga_player:goto_location_offset_on_message("battle_started", 0, 60, false);
ga_enemy_main:goto_location_offset_on_message("battle_started", 0, 60, false);

ga_player:message_on_proximity_to_enemy("enemy_main_move", 300);
ga_player:message_on_casualties("enemy_main_move", 0.05);
ga_enemy_main:attack_on_message("enemy_main_move");

ga_player:message_on_proximity_to_enemy("spoof_reinforcements", 60);
ga_enemy_spoof_reinforcements:reinforce_on_message("spoof_reinforcements", 3000);
ga_enemy_spoof_reinforcements:attack_on_message("spoof_reinforcements");

ga_enemy_main:message_on_casualties("skaven_reinforcements", 0.40);
ga_enemy_skaven:reinforce_on_message("skaven_reinforcements", 3000);
ga_enemy_skaven:attack_on_message("skaven_reinforcements");

ga_enemy_main:message_on_casualties("greenskin_reinforcements", 0.20);
ga_enemy_reinforcements:reinforce_on_message("greenskin_reinforcements", 3000);
ga_enemy_reinforcements:attack_on_message("greenskin_reinforcements");

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc09_qb_skv_tretch_craventail_lucky_skullhelm_start", 7000);    

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc09_qb_skv_tretch_craventail_lucky_skullhelm_start_hint", 5000, nil, 6000);

gb:queue_help_on_message("spoof_reinforcements", "wh2_dlc09_qb_skv_tretch_craventail_lucky_skullhelm_reinforcements_east", 5000, nil, 6000);
gb:queue_help_on_message("skaven_reinforcements", "wh2_dlc09_qb_skv_tretch_craventail_lucky_skullhelm_reinforcements_south", 5000, nil, 6000);
gb:queue_help_on_message("greenskin_reinforcements", "wh2_dlc09_qb_skv_tretch_craventail_lucky_skullhelm_reinforcements_north", 5000, nil, 6000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------