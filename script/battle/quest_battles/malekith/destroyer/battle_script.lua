-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Malekith
-- Destroyer
-- Vaul's Anvil
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
intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/dst.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_main_qb_def_malekith_destroyer_stage_3_vauls_anvil_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_main_qb_def_malekith_destroyer_stage_3_vauls_anvil_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_main_qb_def_malekith_destroyer_stage_3_vauls_anvil_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_main_qb_def_malekith_destroyer_stage_3_vauls_anvil_pt_04");

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
		ga_attacker_01.sunits,					-- unitcontroller over player's army
		32000, 									-- duration of cutscene in ms
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
				ga_attacker_01:set_enabled(true)
			end;
						
			bm:callback(function() cam:fade(false, 0.5) end, 500);
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	

	cutscene_intro:action(function() bm:cindy_playback("script/battle/quest_battles/_cutscene/managers/dst.CindySceneManager", true) end, 200);
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
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_def_malekith_destroyer_stage_3_vauls_anvil_pt_01", "subtitle_with_frame", 7.5) end, 3100);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 11000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 11500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_def_malekith_destroyer_stage_3_vauls_anvil_pt_02", "subtitle_with_frame", 4.5) end, 11600);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 16800);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 17000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_def_malekith_destroyer_stage_3_vauls_anvil_pt_03", "subtitle_with_frame", 3) end, 17100);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 21800);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 22000);
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_def_malekith_destroyer_stage_3_vauls_anvil_pt_04", "subtitle_with_frame", 8) end, 22000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 31500);

	
	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_attacker_01 = gb:get_army(gb:get_player_alliance_num(), 1);
ga_ally_01 = gb:get_army(gb:get_player_alliance_num(), 2,"player_ally_1");
ga_defender_01 = gb:get_army(gb:get_non_player_alliance_num(), 1,"enemy_tyrion");
ga_defender_02 = gb:get_army(gb:get_non_player_alliance_num(), 2,"enemy_teclis_west");
ga_defender_03 = gb:get_army(gb:get_non_player_alliance_num(), 2,"enemy_teclis_east");

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------
ga_attacker_01:goto_location_offset_on_message("battle_started", 0, 60, false);
ga_ally_01:goto_location_offset_on_message("battle_started", 0, 60, false);


ga_ally_01:release_on_message("01_intro_cutscene_end");

ga_defender_01:message_on_proximity_to_enemy("attack", 75);
ga_defender_01:release_on_message("attack");



ga_defender_01:message_on_casualties("reinforcements", 0.4);
ga_defender_02:reinforce_on_message("reinforcements");
ga_defender_03:reinforce_on_message("reinforcements");
ga_defender_02:release_on_message("reinforcements");
ga_defender_03:release_on_message("reinforcements");


-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

ga_defender_01:add_ping_icon_on_message("01_intro_cutscene_end", 15, 1, 5000)  
gb:set_locatable_objective_on_message("01_intro_cutscene_end", "wh2_main_qb_def_malekith_destroyer_stage_3_vauls_anvil_main_objective", 500, v(-13, 396, -337), v(-11, 430, -517), 2); 
gb:set_objective_on_message("reinforcements", "wh2_main_qb_def_malekith_destroyer_stage_3_vauls_anvil_second_objective");
-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

--gb:play_sound_on_message("reinforcements", Orc_Horn, nil, 3000);
gb:queue_help_on_message("01_intro_cutscene_end", "wh2_main_qb_def_malekith_destroyer_stage_3_vauls_anvil_hints_teclis", 6000, nil, 5000);
gb:queue_help_on_message("reinforcements", "wh2_main_qb_def_malekith_destroyer_stage_3_vauls_anvil_hints_reinforcements");

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------



-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY ----------------------------------------------
-------------------------------------------------------------------------------------------------

