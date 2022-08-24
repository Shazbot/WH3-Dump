-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Lord Skrolk
-- Rod of Corruption
-- Isle of the Crimson Skull
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
intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/roc.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_main_qb_skv_skrolk_rod_of_corruption_stage_3_isle_of_the_crimson_skull_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_main_qb_skv_skrolk_rod_of_corruption_stage_3_isle_of_the_crimson_skull_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_main_qb_skv_skrolk_rod_of_corruption_stage_3_isle_of_the_crimson_skull_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_main_qb_skv_skrolk_rod_of_corruption_stage_3_isle_of_the_crimson_skull_pt_04");


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
		31000, 									-- duration of cutscene in ms
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

	cutscene_intro:action(function() bm:cindy_playback("script/battle/quest_battles/_cutscene/managers/roc.CindySceneManager", true) end, 200);
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
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_skv_skrolk_rod_of_corruption_stage_3_isle_of_the_crimson_skull_pt_01", "subtitle_with_frame", 8) end, 2600);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 11300);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 11500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_skv_skrolk_rod_of_corruption_stage_3_isle_of_the_crimson_skull_pt_02", "subtitle_with_frame", 4) end, 12700);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 17800);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 18300);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_skv_skrolk_rod_of_corruption_stage_3_isle_of_the_crimson_skull_pt_03", "subtitle_with_frame", 6.5) end, 20000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 27000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 27500);
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_skv_skrolk_rod_of_corruption_stage_3_isle_of_the_crimson_skull_pt_04", "subtitle_with_frame", 2.5) end, 27600);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 31000);

	
	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;
-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_defender_01 = gb:get_army(gb:get_player_alliance_num(), 1);

ga_attacker_01 = gb:get_army(gb:get_non_player_alliance_num(), 1,"enemy_army");
ga_ally_01 = gb:get_army(gb:get_non_player_alliance_num(), 2,"reinforcements");

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------
ga_attacker_01:set_always_visible_on_message("battle_started", true, false);
-- gb:message_on_time_offset("cutscene_end", 32000);

--gb:message_on_time_offset("reinforcements", 38000);
ga_attacker_01:message_on_proximity_to_enemy("reinforcements", 360);
ga_attacker_01:message_on_proximity_to_enemy("march_forward", 410);
ga_attacker_01:goto_location_offset_on_message("march_forward", 0, 80, false);

ga_ally_01:reinforce_on_message("reinforcements");
--ga_ally_01:release_on_message("reinforcements");
ga_ally_01:attack_on_message("reinforcements"); 

ga_ally_01:message_on_casualties("main_assault", 0.2);
ga_attacker_01:attack_on_message("main_assault");
ga_attacker_01:message_on_proximity_to_enemy("main_assault", 120);
ga_attacker_01:message_on_casualties("main_assault", 0.05);

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

ga_attacker_01:add_ping_icon_on_message("01_intro_cutscene_end", 15, 1, 5000)
gb:set_locatable_objective_on_message("01_intro_cutscene_end", "wh2_main_qb_skv_skrolk_rod_of_corruption_stage_3_isle_of_the_crimson_skull_hint_main_objectives", 500, v(183, 539, -110), v(166, 542, -292), 2); 

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh2_main_qb_skv_skrolk_rod_of_corruption_stage_3_isle_of_the_crimson_skull_hint_main_hint", 6000, nil, 5000);
gb:queue_help_on_message("reinforcements", "wh2_main_qb_skv_skrolk_rod_of_corruption_stage_3_isle_of_the_crimson_skull_hint_reinforcements");

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY ----------------------------------------------
-------------------------------------------------------------------------------------------------
