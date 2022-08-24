-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Khalida
-- Venom Staff
-- Ash River
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
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\tvs.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc09_qb_tmb_khalida_venom_staff_stage_3_ash_river_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc09_qb_tmb_khalida_venom_staff_stage_3_ash_river_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc09_qb_tmb_khalida_venom_staff_stage_3_ash_river_pt_03");

-------------------------------------------------------------------------------------------------
--------------------------------------- ENVIRONMENT SETUP ---------------------------------------
-------------------------------------------------------------------------------------------------

army_arrival_1 = "composite_scene/wh2_dlc09_army_arrival.csc";

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
		ga_defender_01.sunits,					-- unitcontroller over player's army
		37000, 									-- duration of cutscene in ms
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
				ga_defender_01:set_enabled(true)
			end;
						
			bm:callback(function() cam:fade(false, 0.5) end, 500);
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\tvs.CindySceneManager", true) end, 200);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_defender_01:set_enabled(true) 
		end, 
		200
	);	
	cutscene_intro:action(
		function() 
			player_units_hidden = false;
			ga_defender_01:set_enabled(true) 
		end, 
		25000
	);		
	
	-- Voiceover and Subtitles --	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 3000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc09_qb_tmb_khalida_venom_staff_stage_3_ash_river_pt_01", "subtitle_with_frame", 8) end, 3500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 12000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 12500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc09_qb_tmb_khalida_venom_staff_stage_3_ash_river_pt_02", "subtitle_with_frame", 9.5) end, 13000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 23500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 24000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc09_qb_tmb_khalida_venom_staff_stage_3_ash_river_pt_03", "subtitle_with_frame", 10) end, 24500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 36000);

	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_defender_01 = gb:get_army(gb:get_player_alliance_num(), 1);
ga_vanguard = gb:get_army(gb:get_non_player_alliance_num(), 1,"enemy_vanguard");
ga_zombies = gb:get_army(gb:get_non_player_alliance_num(), 2,"enemy_zombies");
ga_puppies = gb:get_army(gb:get_non_player_alliance_num(), 2,"enemy_puppies");
ga_main = gb:get_army(gb:get_non_player_alliance_num(), 2,"enemy_main");
ga_bats = gb:get_army(gb:get_non_player_alliance_num(), 2,"enemy_bats");

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------
ga_vanguard:set_always_visible_on_message("battle_started", true, false);
--vanguard advance--

ga_vanguard:goto_location_offset_on_message("battle_started", 0, 80, false);
ga_defender_01:goto_location_offset_on_message("battle_started", 0, 80, false);

--timings--
gb:message_on_time_offset("army_arrival_1", 30000);
gb:message_on_time_offset("release_vanguard", 45000);
gb:message_on_time_offset("reinforce_zombies", 60000);
gb:message_on_time_offset("release_zombies", 70000);
gb:message_on_time_offset("reinforce_puppies", 300000);
gb:message_on_time_offset("release_puppies", 310000);
gb:message_on_time_offset("army_arrival_2", 390000);
gb:message_on_time_offset("reinforce_main", 420000);
gb:message_on_time_offset("release_main", 430000);
gb:message_on_time_offset("reinforce_bats", 540000);
gb:message_on_time_offset("release_bats", 550000);

ga_vanguard:attack_on_message("release_vanguard", 1000);

--vfx--
gb:stop_terrain_composite_scene_on_message("battle_started", army_arrival_1, 100);
gb:start_terrain_composite_scene_on_message("army_arrival_1", army_arrival_1, 1000)
gb:stop_terrain_composite_scene_on_message("reinforce_zombies", army_arrival_1, 1000);
gb:start_terrain_composite_scene_on_message("army_arrival_2", army_arrival_1, 1000)	
gb:stop_terrain_composite_scene_on_message("reinforce_main", army_arrival_1, 1000);

--zombies assault--
ga_zombies:reinforce_on_message("reinforce_zombies");
ga_zombies:release_on_message("release_zombies");

--puppies advance--
ga_puppies:reinforce_on_message("reinforce_puppies");
ga_puppies:attack_on_message("release_puppies", 1000);

--main advance--
ga_main:reinforce_on_message("reinforce_main");
ga_main:release_on_message("release_main");

--bats fly over the lines--
ga_bats:reinforce_on_message("reinforce_bats");
ga_bats:attack_on_message("release_bats", 1000);



-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc09_qb_tmb_khalida_venom_staff_stage_x_ash_river_hints_main_objectives");

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc09_qb_tmb_khalida_venom_staff_stage_x_ash_river_hints_main_hint", 6000, nil, 5000);
gb:queue_help_on_message("reinforce_zombies", "wh2_dlc09_qb_tmb_khalida_venom_staff_stage_x_ash_river_hints_main_zombies", 6000, nil, 4000);
gb:queue_help_on_message("reinforce_puppies", "wh2_dlc09_qb_tmb_khalida_venom_staff_stage_x_ash_river_hints_main_outflanked", 6000, nil, 4000);
gb:queue_help_on_message("reinforce_main", "wh2_dlc09_qb_tmb_khalida_venom_staff_stage_x_ash_river_hints_main_reinforcements", 6000, nil, 4000);
gb:queue_help_on_message("reinforce_bats", "wh2_dlc09_qb_tmb_khalida_venom_staff_stage_x_ash_river_hints_main_flyers", 6000, nil, 4000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------
