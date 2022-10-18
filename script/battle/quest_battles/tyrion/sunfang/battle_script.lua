-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Tyrion
-- Sunfang
-- Tower of Hoeth
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
intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/snf.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_main_qb_hef_tyrion_sunfang_stage_4_tower_of_hoeth_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_main_qb_hef_tyrion_sunfang_stage_4_tower_of_hoeth_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_main_qb_hef_tyrion_sunfang_stage_4_tower_of_hoeth_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_main_qb_hef_tyrion_sunfang_stage_4_tower_of_hoeth_pt_04");

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
		42000, 									-- duration of cutscene in ms
		function() intro_cutscene_end() end		-- what to call when cutscene is finished
	);
	
	local player_units_hidden = false;
	
	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
	
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

	cutscene_intro:action(function() bm:cindy_playback("script/battle/quest_battles/_cutscene/managers/snf.CindySceneManager", true) end, 200);
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
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_hef_tyrion_sunfang_stage_4_tower_of_hoeth_pt_01", "subtitle_with_frame", 0.1) end, 3100);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 12700);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 13200);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_hef_tyrion_sunfang_stage_4_tower_of_hoeth_pt_02", "subtitle_with_frame", 0.1) end, 13300);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 20000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 20500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_hef_tyrion_sunfang_stage_4_tower_of_hoeth_pt_03", "subtitle_with_frame", 0.1) end, 20600);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 30300);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 30800);
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_hef_tyrion_sunfang_stage_4_tower_of_hoeth_pt_04", "subtitle_with_frame", 0.1) end, 30900);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 41900);
	
	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;
-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_attacker_01 = gb:get_army(gb:get_player_alliance_num(), 1);

ga_defender_01 = gb:get_army(gb:get_non_player_alliance_num(), 1,"enemy_army");
ga_ally_01 = gb:get_army(gb:get_non_player_alliance_num(), 2,"enemy_reinforcements_1");
ga_ally_02 = gb:get_army(gb:get_non_player_alliance_num(), 2,"enemy_reinforcements_2");

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

ga_defender_01:message_on_casualties("adjust", 0.02);
ga_defender_01:message_on_proximity_to_enemy("adjust", 360);
ga_defender_01:release_on_message("adjust");

ga_defender_01:message_on_proximity_to_enemy("reinforcements_1", 300);
gb:message_on_time_offset("reinforcements_1", 90000);

ga_defender_01:message_on_proximity_to_enemy("reinforcements_2", 0.2);
gb:message_on_time_offset("reinforcements_2", 150000);

ga_ally_01:reinforce_on_message("reinforcements_1");
ga_ally_02:reinforce_on_message("reinforcements_2");
ga_ally_01:defend_on_message("reinforcements_1", -301, -16, 50);
ga_ally_02:defend_on_message("reinforcements_2", -301, -16, 50);

ga_ally_01:message_on_proximity_to_enemy("tactics_1", 50);
ga_ally_01:message_on_proximity_to_position("tactics_1", v(-301, 95, -13), 30);
ga_ally_01:message_on_casualties("tactics_1", 0.05);
ga_ally_01:attack_on_message("tactics_1");

ga_ally_02:message_on_proximity_to_position("tactics_2", v(-301, 95, -13), 30);
ga_ally_02:message_on_proximity_to_enemy("tactics_2", 50);
ga_ally_02:message_on_casualties("tactics_2", 0.05);
ga_ally_02:attack_on_message("tactics_2");

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------
  
gb:set_locatable_objective_on_message("01_intro_cutscene_end", "wh2_main_qb_hef_tyrion_sunfang_stage_4_tower_of_hoeth_hints_objectives", 100, v(-38, 111, 105), v(-39.3, 113, 265.8), 2);

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh2_main_qb_hef_tyrion_sunfang_stage_4_tower_of_hoeth_hint_main_hint", 6000, nil, 5000);
gb:queue_help_on_message("reinforcements_1", "wh2_main_qb_hef_tyrion_sunfang_stage_4_tower_of_hoeth_hints_reinforcements_1");
gb:queue_help_on_message("reinforcements_2", "wh2_main_qb_hef_tyrion_sunfang_stage_4_tower_of_hoeth_hints_reinforcements_2");

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------