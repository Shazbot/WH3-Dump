-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Noctilus
-- Piece of 8
-- INSERT ENVIRONMENT NAME
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
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\crm.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc11_Count_Noctilus_QB_Roths_Moondial_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc11_Count_Noctilus_QB_Roths_Moondial_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc11_Count_Noctilus_QB_Roths_Moondial_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_dlc11_Count_Noctilus_QB_Roths_Moondial_pt_04");
wh2_main_sfx_05 = new_sfx("Play_wh2_dlc11_Count_Noctilus_QB_Roths_Moondial_pt_05");
-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_attacker_01 = gb:get_army(gb:get_player_alliance_num(), 1, "");
ga_ramp = gb:get_army(gb:get_non_player_alliance_num(),"enemy_ramp");
ga_artillery = gb:get_army(gb:get_non_player_alliance_num(),"enemy_siege");
ga_flank = gb:get_army(gb:get_non_player_alliance_num(),"enemy_flank");


-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------

function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");
	
--teleport unit (1) of ga_artillery to [450, 20] with an orientation of 45 degrees and a width of 25m
ga_artillery.sunits:item(1).uc:teleport_to_location(v(-310, 290), 180, 25);
--	teleport unit (2) of ga_artillery to [410, 35] with an orientation of 45 degrees and a width of 25m
ga_artillery.sunits:item(2).uc:teleport_to_location(v(-300, 280), 180, 25);
--	teleport unit (3) of ga_artillery to [390, 20] with an orientation of 45 degrees and a width of 25m
ga_artillery.sunits:item(3).uc:teleport_to_location(v(-320, 300), 180, 25);
--	teleport unit (4) of ga_artillery to [430, 65] with an orientation of 45 degrees and a width of 25m
ga_artillery.sunits:item(4).uc:teleport_to_location(v(-280, 310), 180, 25);
--	teleport unit (5) of ga_artillery to [430, 65] with an orientation of 45 degrees and a width of 25m
ga_artillery.sunits:item(5).uc:teleport_to_location(v(-280, 280), 180, 25);
--	teleport unit (1) of ga_defender_03 to [360, 60] with an orientation of 45 degrees and a width of 25m
ga_artillery.sunits:item(6).uc:teleport_to_location(v(-290, 290), 180, 25);
--	teleport unit (1) of ga_defender_03 to [360, 60] with an orientation of 45 degrees and a width of 25m
ga_ramp.sunits:item(1).uc:teleport_to_location(v(0, 310), 180, 25);
--	teleport unit (2) of ga_defender_03 to [400, 0] with an orientation of 45 degrees and a width of 25m
ga_ramp.sunits:item(2).uc:teleport_to_location(v(10, 320), 180, 25);
--	teleport unit (3) of ga_defender_03 to [360, 60] with an orientation of 45 degrees and a width of 25m
ga_ramp.sunits:item(3).uc:teleport_to_location(v(20, 330), 180, 25);
--	teleport unit (4) of ga_defender_03 to [400, 0] with an orientation of 45 degrees and a width of 25m
ga_ramp.sunits:item(4).uc:teleport_to_location(v(40, 300), 180, 25);
--	teleport unit (5) of ga_defender_03 to [400, 0] with an orientation of 45 degrees and a width of 25m
ga_ramp.sunits:item(5).uc:teleport_to_location(v(50, 315), 180, 25);
--	teleport unit (6) of ga_defender_03 to [360, 60] with an orientation of 45 degrees and a width of 25m
ga_ramp.sunits:item(6).uc:teleport_to_location(v(10, 330), 180, 25);
--	teleport unit (7) of ga_defender_03 to [400, 0] with an orientation of 45 degrees and a width of 25m
ga_ramp.sunits:item(7).uc:teleport_to_location(v(40, 330), 180, 25);
--	teleport unit (8) of ga_defender_03 to [400, 0] with an orientation of 45 degrees and a width of 25m
ga_ramp.sunits:item(8).uc:teleport_to_location(v(40, 280), 180, 25);
--	teleport unit (9) of ga_defender_03 to [400, 0] with an orientation of 45 degrees and a width of 25m
ga_ramp.sunits:item(9).uc:teleport_to_location(v(10, 280), 180, 25);
--	teleport unit (1) of ga_flank to [560, 70] with an orientation of 45 degrees and a width of 25m
ga_ramp.sunits:item(10).uc:teleport_to_location(v(20, 270), 180, 25);
--	teleport unit (1) of ga_flank to [560, 70] with an orientation of 45 degrees and a width of 25m
ga_flank.sunits:item(1).uc:teleport_to_location(v(320, 170), 90, 25);
--	teleport unit (2) of ga_flank to [560, 70] with an orientation of 45 degrees and a width of 25m
ga_flank.sunits:item(2).uc:teleport_to_location(v(300, 210), 90, 25);
--	teleport unit (3) of ga_flank to [560, 70] with an orientation of 45 degrees and a width of 25m
ga_flank.sunits:item(3).uc:teleport_to_location(v(335, 240), 90, 25);
--	teleport unit (4) of ga_flank to [560, 70] with an orientation of 45 degrees and a width of 25m
ga_flank.sunits:item(4).uc:teleport_to_location(v(340, 170), 90, 25);
	
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
		42000, 									-- duration of cutscene in ms
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

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\crm.CindySceneManager", true) end, 200);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_attacker_01:set_enabled(true) 
		end, 
		200
	);	
	
	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 3000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc11_qb_cst_noctilus_captain_roths_moondial_stage_4_intro_01", "subtitle_with_frame", 4) end, 3500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 8000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 8500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc11_qb_cst_noctilus_captain_roths_moondial_stage_4_intro_02", "subtitle_with_frame", 6) end, 9000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 15500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 16000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc11_qb_cst_noctilus_captain_roths_moondial_stage_4_intro_03", "subtitle_with_frame", 10) end, 16500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 27000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 27500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc11_qb_cst_noctilus_captain_roths_moondial_stage_4_intro_04", "subtitle_with_frame", 6) end, 28000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 34500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_05) end, 35000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc11_qb_cst_noctilus_captain_roths_moondial_stage_4_intro_05", "subtitle_with_frame", 5) end, 35500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 41000);
	
	cutscene_intro:start();
	
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;


-------------------------------------------------------------------------------------------------
------------------------------------------ ORDERS -------------------------------------------
-------------------------------------------------------------------------------------------------
--Stopping player from firing until the cutscene is done
ga_attacker_01:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_attacker_01:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

gb:message_on_time_offset("harass", 10000);
gb:message_on_time_offset("go", 20000);
ga_flank:message_on_casualties("flank_hurt", 0.3);
ga_ramp:message_on_casualties("ramp_hurt", 0.05);
ga_ramp:message_on_casualties("ramp_dying", 0.5);

ga_ramp:message_on_proximity_to_enemy("ramp_approached", 80);

ga_ramp:defend_on_message("01_intro_cutscene_end", 0, 210, 150); 
ga_artillery:defend_on_message("go", -320, 130, 50); 

ga_flank:attack_on_message("harass");
ga_flank:release_on_message("flank_hurt");
ga_ramp:release_on_message("flank_hurt");
ga_artillery:release_on_message("ramp_dying");
ga_ramp:release_on_message("ramp_hurt");


-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc11_cst_noctilus_captain_roths_moondial_stage_5_hints_main_objective");

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc11_cst_noctilus_captain_roths_moondial_stage_5_hints_start_battle", 6000, nil, 5000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------