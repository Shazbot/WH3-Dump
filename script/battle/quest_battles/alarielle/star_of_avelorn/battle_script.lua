-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Alarielle
-- Star of Avelorn
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
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\scenes\\soa_s01.CindyScene";
--bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc10_HEF_Alarielle_QB_Star_of_Averlorn_pt_02");

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_attacker_01 = gb:get_army(gb:get_player_alliance_num(), 1, "");
ga_defender_01 = gb:get_army(gb:get_non_player_alliance_num(),"enemy_army_1");
ga_defender_02 = gb:get_army(gb:get_non_player_alliance_num(),"enemy_army_2");
ga_defender_03 = gb:get_army(gb:get_non_player_alliance_num(),"enemy_army_3");


-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------

function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");
	
--teleport unit (1) of ga_defender_03 to [450, 20] with an orientation of 45 degrees and a width of 25m
	ga_defender_03.sunits:item(1).uc:teleport_to_location(v(450, -20), 180, 25);
--	teleport unit (2) of ga_defender_03 to [410, 35] with an orientation of 45 degrees and a width of 25m
	ga_defender_03.sunits:item(2).uc:teleport_to_location(v(410, -35), 180, 25);
--	teleport unit (3) of ga_defender_03 to [390, 20] with an orientation of 45 degrees and a width of 25m
	ga_defender_03.sunits:item(3).uc:teleport_to_location(v(390, -20), 180, 25);
--	teleport unit (4) of ga_defender_03 to [430, 65] with an orientation of 45 degrees and a width of 25m
	ga_defender_03.sunits:item(4).uc:teleport_to_location(v(430, -65), 180, 25);
--	teleport unit (5) of ga_defender_03 to [360, 60] with an orientation of 45 degrees and a width of 25m
	ga_defender_03.sunits:item(5).uc:teleport_to_location(v(360, -60), 180, 25);
--	teleport unit (6) of ga_defender_03 to [400, 0] with an orientation of 45 degrees and a width of 25m
	ga_defender_03.sunits:item(6).uc:teleport_to_location(v(400, -15), 180, 25);
	
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
		41000, 									-- duration of cutscene in ms
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

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\scenes\\soa_s01.CindyScene", true) end, 200);
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
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc10_qb_hef_alarielle_star_of_avelorn_stage_5_intro_01", "subtitle_with_frame", 0.1) end, 3500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 17000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 17500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc10_qb_hef_alarielle_star_of_avelorn_stage_5_intro_02", "subtitle_with_frame", 0.1) end, 17500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 34000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 29500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc10_qb_hef_alarielle_star_of_avelorn_stage_5_intro_03", "subtitle_with_frame", 0.1) end, 34500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 41000);
	
	cutscene_intro:start();
	
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;


-------------------------------------------------------------------------------------------------
------------------------------------------ ORDERS -------------------------------------------
-------------------------------------------------------------------------------------------------
gb:message_on_time_offset("action1", 20000);
gb:message_on_time_offset("action2", 40000);
gb:message_on_time_offset("action3", 20000);

ga_defender_02:goto_location_offset_on_message("action1", 50, 350, true);
ga_defender_01:defend_on_message("action3", -220, -90, 30); 
ga_defender_02:message_on_proximity_to_position("close_to_position_2", v(0, 100, -50), 30);
ga_defender_02:message_on_proximity_to_enemy("close_to_player_2", 100);
ga_defender_02:release_on_message("close_to_position_2");
ga_defender_02:release_on_message("close_to_player_2");


ga_defender_03:defend_on_message("action2",430, -250, 30);
ga_defender_03:message_on_proximity_to_position("close_to_position_3", v(430, 100, -250), 30);
ga_defender_03:message_on_proximity_to_enemy("close_to_player_3", 40);
ga_defender_03:attack_on_message("close_to_position_3");
ga_defender_03:attack_on_message("close_to_player_3");

ga_defender_01:message_on_proximity_to_enemy("artillery_help", 80);
ga_defender_02:defend_on_message("artillery_help", -220, -90, 30); 
ga_defender_01:message_on_casualties("artillery_go", 0.2);
ga_defender_01:release_on_message("artillery_go");
ga_defender_03:release_on_message("artillery_go");
ga_defender_01:message_on_casualties("artillery_rekt", 0.4);
ga_defender_02:release_on_message("artillery_rekt");
ga_defender_03:release_on_message("artillery_go");


ga_defender_02:message_on_casualties("main_dying", 0.30);
ga_defender_01:release_on_message("main_dying");
ga_defender_02:release_on_message("main_dying");
ga_defender_03:release_on_message("main_dying");


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