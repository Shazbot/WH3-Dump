-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Tehenhauin	
-- Plaque of Sotek
-- wh_tehenhuain
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();

bm:camera():fade(true, 0);

gb = generated_battle:new(
	true,           	                           		-- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                      		-- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
);

--preload stuttering fix
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\teh.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc12_lzd_tehenhauin_QB_plaque_of_sotek_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc12_lzd_tehenhauin_QB_plaque_of_sotek_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc12_lzd_tehenhauin_QB_plaque_of_sotek_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_dlc12_lzd_tehenhauin_QB_plaque_of_sotek_pt_04");
-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player = gb:get_army(gb:get_player_alliance_num(), 1, "");
ga_player_reinforcements_1 = gb:get_army(gb:get_player_alliance_num(), "player_reinforcements_1");
ga_player_reinforcements_2 = gb:get_army(gb:get_player_alliance_num(), "player_reinforcements_2");

ga_enemy = gb:get_army(gb:get_non_player_alliance_num(),"enemy_army");
ga_enemy_reinforcements_1 = gb:get_army(gb:get_non_player_alliance_num(),"enemy_reinforcements_1");
ga_enemy_reinforcements_2 = gb:get_army(gb:get_non_player_alliance_num(),"enemy_reinforcements_2");

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
		ga_player.sunits,					-- unitcontroller over player's army
		44000, 									-- duration of cutscene in ms
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

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\teh.CindySceneManager", true) end, 200);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_player:set_enabled(true) 
		end, 
		200
	);	
	
	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 2500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc12_lzd_tehenhauin_QB_plaque_of_sotek_pt_01", "subtitle_with_frame", 2, true) end, 3000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 8500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 9000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc12_lzd_tehenhauin_QB_plaque_of_sotek_pt_02", "subtitle_with_frame", 5, true) end, 9500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 20000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 20500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc12_lzd_tehenhauin_QB_plaque_of_sotek_pt_03", "subtitle_with_frame", 5, true) end, 21000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 31500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 32000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc12_lzd_tehenhauin_QB_plaque_of_sotek_pt_04", "subtitle_with_frame", 5, true) end, 32500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 43000);
	
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
ga_enemy:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_player:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
ga_enemy:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

gb:message_on_time_offset("enemy_attack", 9000,"01_intro_cutscene_end");
ga_enemy:attack_on_message("enemy_attack");
ga_enemy:message_on_under_attack("player_engaged","01_intro_cutscene_end");
ga_enemy:release_on_message("player_engaged");

gb:message_on_time_offset("player_reinforcements", 12000,"01_intro_cutscene_end"); 
gb:message_on_time_offset("reinforcements_defend", 23000,"01_intro_cutscene_end"); 

ga_player_reinforcements_1:reinforce_on_message("player_reinforcements", 10);
ga_player_reinforcements_2:reinforce_on_message("player_reinforcements", 10);

ga_enemy_reinforcements_1:move_to_position_on_message("enemy_attack", v(-450,160,50));
ga_enemy_reinforcements_1:attack_on_message("reinforcements_defend");
ga_enemy_reinforcements_2:move_to_position_on_message("enemy_attack", v(420,426,50));
ga_enemy_reinforcements_2:attack_on_message("reinforcements_defend");

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc12_lzd_tehenhauin_plaque_of_sotek_stage_6_hints_main_objective");

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc12_lzd_tehenhauin_plaque_of_sotek_stage_6_hints_start", 6000, nil, 5000);
--gb:queue_help_on_message("enemy_reinforcements_1", "wh2_dlc12_lzd_tehenhauin_plaque_of_sotek_stage_6_hints_enemy_reinforcements_1", 6000, nil, 10);
--gb:queue_help_on_message("player_reinforcements_1", "wh2_dlc12_lzd_tehenhauin_plaque_of_sotek_stage_6_hints_ally_reinforcements_1", 6000, nil, 10);

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------