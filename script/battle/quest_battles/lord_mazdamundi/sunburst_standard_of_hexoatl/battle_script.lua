-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Lord Mazdamundi
-- Sunburst Standard of Hexoatl
-- Fallen Gates
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
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\ssh.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_main_qb_lzd_mazdamundi_sunburst_standard_of_hexoatl_stage_4_fallen_gates_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_main_qb_lzd_mazdamundi_sunburst_standard_of_hexoatl_stage_4_fallen_gates_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_main_qb_lzd_mazdamundi_sunburst_standard_of_hexoatl_stage_4_fallen_gates_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_main_qb_lzd_mazdamundi_sunburst_standard_of_hexoatl_stage_4_fallen_gates_pt_04");


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
		38000, 									-- duration of cutscene in ms
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

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\ssh.CindySceneManager", true) end, 200);
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
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_lzd_mazdamundi_sunburst_standard_of_hexoatl_stage_4_fallen_gates_pt_01", "subtitle_with_frame", 0.1, true)	end, 3500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 11800);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 12300);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_lzd_mazdamundi_sunburst_standard_of_hexoatl_stage_4_fallen_gates_pt_02", "subtitle_with_frame", 0.1, true)	end, 12800);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 23800);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 24300);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_lzd_mazdamundi_sunburst_standard_of_hexoatl_stage_4_fallen_gates_pt_03", "subtitle_with_frame", 0.1, true)	end, 24800);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 30800);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 31300);
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_lzd_mazdamundi_sunburst_standard_of_hexoatl_stage_4_fallen_gates_pt_04", "subtitle_with_frame", 0.1, true)	end, 31800);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 37500);

	
	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_defender_01 = gb:get_army(gb:get_player_alliance_num(), 1);
ga_defender_02 = gb:get_army(gb:get_player_alliance_num(), 2,"player_ally");

ga_attacker_01 = gb:get_army(gb:get_non_player_alliance_num(), 1,"enemy_army_1");
ga_hellcannon = gb:get_army(gb:get_non_player_alliance_num(), 1,"enemy_cannons");
ga_attacker_02 = gb:get_army(gb:get_non_player_alliance_num(), 2,"enemy_army_2");
ga_attacker_03 = gb:get_army(gb:get_non_player_alliance_num(), 2,"enemy_flyers");

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

ga_defender_02:halt();


ga_attacker_01:release_on_message("01_intro_cutscene_end");
ga_attacker_02:release_on_message("01_intro_cutscene_end");
ga_attacker_03:release_on_message("01_intro_cutscene_end");
ga_hellcannon:release_on_message("01_intro_cutscene_end");
ga_hellcannon:attack_on_message("01_intro_cutscene_end");



ga_defender_02:message_on_proximity_to_enemy("close", 150);
ga_defender_02:release_on_message("close", 2000);
ga_defender_02:message_on_casualties("kroqgar", 0.15);




ga_attacker_01:message_on_casualties("reinforcements", 0.50);
ga_attacker_02:reinforce_on_message("reinforcements");
ga_attacker_01:message_on_casualties("flyers", 0.35);
ga_attacker_03:reinforce_on_message("flyers");


-- gb:message_on_time_offset("reinforcements", 180000); -- This can be added as an fallback/anti-cheese for the reinforcement waves if players camp at the top of the hill and it becomes easy.

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_locatable_objective_on_message("01_intro_cutscene_end", "wh2_main_qb_lzd_mazdamundi_sunburst_standard_of_hexoatl_stage_4_fallen_gates_hints_main_objective", 100, v(8.7, 30.5, -522.4), v(8.3, 29.2, -558.7), 15);          
gb:add_ping_icon_on_message("01_intro_cutscene_end", v(8.7, 30.5, -522.4), 1, 6000, 7000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh2_main_qb_lzd_mazdamundi_sunburst_standard_of_hexoatl_stage_4_fallen_gates_hints_main_hint", 6000, nil, 5000);
gb:queue_help_on_message("kroqgar", "wh2_main_qb_lzd_mazdamundi_sunburst_standard_of_hexoatl_stage_4_fallen_gates_hints_kroqgar");
gb:queue_help_on_message("reinforcements", "wh2_main_qb_lzd_mazdamundi_sunburst_standard_of_hexoatl_stage_4_fallen_gates_hints_reinforcements");
gb:queue_help_on_message("flyers", "wh2_main_qb_lzd_mazdamundi_sunburst_standard_of_hexoatl_stage_4_fallen_gates_hints_flyers");


-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY ----------------------------------------------
-------------------------------------------------------------------------------------------------
