-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Settra
-- The Crown of Nehekhara
-- Pack Ice Bay - Ice Tooth Mountain
-- Attacker

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
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\tcn.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc09_tmb_settra_the_crown_of_nehekhara_stage_5_pack_ice_bay_part_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc09_tmb_settra_the_crown_of_nehekhara_stage_5_pack_ice_bay_part_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc09_tmb_settra_the_crown_of_nehekhara_stage_5_pack_ice_bay_part_03");

-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
		
	local cam = bm:camera();
		
	-- declare cutscene
	local cutscene_intro = cutscene:new(
		"cutscene_intro", 						-- unique string name for cutscene
		ga_attacker_01.sunits,					-- unitcontroller over player's army
		37000, 									-- duration of cutscene in ms
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

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\tcn.CindySceneManager", true) end, 200);
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
		25000
	);		
	
	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 3000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc09_tmb_settra_the_crown_of_nehekhara_stage_5_pack_ice_bay_part_01", "subtitle_with_frame", 11.5) end, 3500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 15500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 16000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc09_tmb_settra_the_crown_of_nehekhara_stage_5_pack_ice_bay_part_02", "subtitle_with_frame", 11) end, 16500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 28000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 28500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc09_tmb_settra_the_crown_of_nehekhara_stage_5_pack_ice_bay_part_03", "subtitle_with_frame", 7.5) end, 29000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 37000);
	
	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_attacker_01 = gb:get_army(gb:get_player_alliance_num(), 1, "");
ga_defender_01 = gb:get_army(gb:get_non_player_alliance_num(), 1,"enemy_army_1");
ga_defender_02 = gb:get_army(gb:get_non_player_alliance_num(), 1,"enemy_army_2");
ga_defender_03 = gb:get_army(gb:get_non_player_alliance_num(), 1,"enemy_army_3");
ga_defender_04 = gb:get_army(gb:get_non_player_alliance_num(), 1,"enemy_army_4");
ga_defender_05 = gb:get_army(gb:get_non_player_alliance_num(), 1,"enemy_army_5");

-------------------------------------------------------------------------------------------------
------------------------------------------ UNIT SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------
--ga_defender_02:set_invisible_to_all_on_message("battle_started", true);
--ga_defender_03:set_invisible_to_all_on_message("battle_started", true);
--ga_defender_04:set_invisible_to_all_on_message("battle_started", true);
--ga_defender_05:set_invisible_to_all_on_message("battle_started", true);
--gb:message_on_time_offset("battle_started_plus", 3000);
--ga_defender_02:set_invisible_to_all_on_message("battle_started_plus", false);
--ga_defender_03:set_invisible_to_all_on_message("battle_started_plus", false);
--ga_defender_04:set_invisible_to_all_on_message("battle_started_plus", false);
--ga_defender_05:set_invisible_to_all_on_message("battle_started_plus", false);

ga_defender_02:teleport_to_start_location_offset_on_message("battle_started", -250, 135);
ga_defender_04:teleport_to_start_location_offset_on_message("battle_started", 250, 50);
ga_defender_05:teleport_to_start_location_offset_on_message("battle_started", 350, 0);
ga_attacker_01:goto_location_offset_on_message("battle_started", 0, 60, false);
ga_defender_01:goto_location_offset_on_message("battle_started", 0, -80, true);
gb:message_on_time_offset("hide", 20000);
ga_defender_01:goto_location_offset_on_message("hide", -180, 100, true);

ga_defender_01:set_always_visible_on_message("battle_started", true, false);

ga_defender_03:release_on_message("battle_started");
gb:message_on_time_offset("reform", 100);
ga_defender_03:release_on_message("reform");
ga_defender_03:set_formation_on_message("reform", "Multiple Selection Deployable Drag Out Land", false);
gb:message_on_time_offset("teleport", 200);
ga_defender_03:teleport_to_start_location_offset_on_message("teleport", 150, 340);
gb:message_on_time_offset("defend", 200);
ga_defender_03:defend_on_message("defend", -75, 44, 10);
--ga_defender_01:set_always_visible_on_message("defend", false, false);
--ga_defender_01:goto_location_offset_on_message("defend", -100, 100, false);
ga_defender_02:defend_on_message("defend", 316, -139, 30);
ga_defender_02.sunits:change_behaviour_active("fire_at_will", false);

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------



--ga_defender_01:message_on_proximity_to_enemy("ga_defender_01", 80);
--ga_defender_02:message_on_proximity_to_enemy("ga_defender_02", 80);
--ga_defender_03:message_on_proximity_to_enemy("ga_defender_03", 80);
--ga_defender_04:message_on_proximity_to_enemy("ga_defender_04", 250);
--ga_defender_05:message_on_proximity_to_enemy("ga_defender_05", 80);
ga_attacker_01:message_on_proximity_to_position("ga_defender_01", v(270, 287, 203), 150);
ga_attacker_01:message_on_proximity_to_position("ga_defender_02", v(361, 306, -144), 130);
ga_attacker_01:message_on_proximity_to_position("ga_defender_03", v(-142, 298, 17), 150);
ga_attacker_01:message_on_proximity_to_position("ga_defender_04", v(177, 273, 203), 180);
ga_attacker_01:message_on_proximity_to_position("ga_defender_05", v(-22, 298, 445), 160);


-- Scenario 1
ga_defender_01:attack_on_message("ga_defender_01");
ga_defender_03:attack_on_message("ga_defender_01");
ga_defender_04:attack_on_message("ga_defender_01");
--ga_defender_02:set_fire_at_will_on_message("ga_defender_01", true); 
ga_defender_01:set_always_visible_on_message("ga_defender_01", true, true);
ga_defender_03:set_always_visible_on_message("ga_defender_01", true, true);
ga_defender_04:set_always_visible_on_message("ga_defender_01", true, true);

-- Scenario 2
ga_defender_02:attack_on_message("ga_defender_02");
ga_defender_02:set_always_visible_on_message("ga_defender_02", true, true);
--ga_defender_02:set_fire_at_will_on_message("ga_defender_02", true); 

-- Scenario 3
ga_defender_03:attack_on_message("ga_defender_03");
ga_defender_02:set_always_visible_on_message("ga_defender_03", true, true);
--ga_defender_02:set_fire_at_will_on_message("ga_defender_03", true); 
ga_defender_03:set_always_visible_on_message("ga_defender_03", true, true);

-- Scenario 4
ga_defender_03:attack_on_message("ga_defender_04");
ga_defender_04:attack_on_message("ga_defender_04");
ga_defender_02:set_always_visible_on_message("ga_defender_04", true, true);
--ga_defender_02:set_fire_at_will_on_message("ga_defender_04", true);
ga_defender_03:set_always_visible_on_message("ga_defender_04", true, true);
ga_defender_04:set_always_visible_on_message("ga_defender_04", true, true);

-- Scenario 5
ga_defender_01:attack_on_message("ga_defender_05");
ga_defender_03:attack_on_message("ga_defender_05");
ga_defender_04:attack_on_message("ga_defender_05");
ga_defender_05:attack_on_message("ga_defender_05");
ga_defender_01:set_always_visible_on_message("ga_defender_05", true, true);
--ga_defender_02:set_fire_at_will_on_message("ga_defender_05", true); 
ga_defender_03:set_always_visible_on_message("ga_defender_05", true, true);
ga_defender_04:set_always_visible_on_message("ga_defender_05", true, true);
ga_defender_05:set_always_visible_on_message("ga_defender_05", true, true);

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc09_tmb_settra_the_crown_of_nehekhara_stage_5_pack_ice_hints_main_objective");

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc09_tmb_settra_the_crown_of_nehekhara_stage_5_pack_ice_hints_start_battle", 6000, nil, 5000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------