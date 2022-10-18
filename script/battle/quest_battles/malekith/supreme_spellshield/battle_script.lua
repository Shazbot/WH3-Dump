-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Malekith
-- Supreme Spellshield
-- Mosquito Swamps
-- Defender

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------
load_script_libraries();
cam = bm:camera();

gb = generated_battle:new(
	false,                                     		    -- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                      		    -- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
);

--preload stuttering fix
intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/sss.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_main_qb_def_malekith_supreme_spellshield_stage_3_mosquito_swamps_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_main_qb_def_malekith_supreme_spellshield_stage_3_mosquito_swamps_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_main_qb_def_malekith_supreme_spellshield_stage_3_mosquito_swamps_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_main_qb_def_malekith_supreme_spellshield_stage_3_mosquito_swamps_pt_04");

-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
	
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
	
	--cutscene_intro:set_is_ambush(true, false);
	--cam:fade(false, 0);

	-- skip callback
	cutscene_intro:set_skippable(
		false, 
		function()
			bm:stop_cindy_playback(true);
			
			if player_units_hidden then
				ga_attacker_01:set_enabled(true)
			end;
		end
	);
	
	-- set up actions on cutscene
	--cutscene_intro:action(function() cam:fade(false, 1) end, 1000);

	cutscene_intro:action(function() bm:cindy_playback("script/battle/quest_battles/_cutscene/managers/sss.CindySceneManager", true) end, 200);
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
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_def_malekith_supreme_spellshield_stage_3_mosquito_swamps_pt_01", "subtitle_with_frame", 0.1) end, 3100);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 11300);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 11500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_def_malekith_supreme_spellshield_stage_3_mosquito_swamps_pt_02", "subtitle_with_frame", 0.1) end, 11600);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 16300);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 16500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_def_malekith_supreme_spellshield_stage_3_mosquito_swamps_pt_03", "subtitle_with_frame", 0.1) end, 16600);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 27300);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 27500);
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_def_malekith_supreme_spellshield_stage_3_mosquito_swamps_pt_04", "subtitle_with_frame", 0.1) end, 27600);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 36500);
	
	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

--[[
if gb:get_army(gb:get_player_alliance_num(), 1):are_unit_types_in_army("wh2_main_def_cha_malekith_0, wh2_main_def_cha_malekith_1, wh2_main_def_cha_malekith_2, wh2_main_def_cha_malekith_3") then
	ga_attacker_01 = gb:get_army(gb:get_player_alliance_num(), 1);
	ga_ally_01 = gb:get_army(gb:get_player_alliance_num(), 2,"player_ally_1");
	ga_ally_02 = gb:get_army(gb:get_player_alliance_num(), 3,"player_ally_2");

else
	ga_attacker_01 = gb:get_army(gb:get_player_alliance_num(), 1);
	ga_ally_01 = gb:get_army(gb:get_player_alliance_num(), 2,"player_ally_1");
	ga_ally_02 = gb:get_army(gb:get_player_alliance_num(), 3,"player_ally_2");
end
]]

ga_attacker_01 = gb:get_army(gb:get_player_alliance_num(), 1);
ga_ally_01 = gb:get_army(gb:get_player_alliance_num(), 2,"player_ally_1");
ga_ally_02 = gb:get_army(gb:get_player_alliance_num(), 3,"player_ally_2");

ga_defender_01 = gb:get_army(gb:get_non_player_alliance_num(),"enemy_army_1");
ga_defender_02 = gb:get_army(gb:get_non_player_alliance_num(),"enemy_army_2");
ga_defender_03 = gb:get_army(gb:get_non_player_alliance_num(),"enemy_reinforcements_1");
ga_defender_04 = gb:get_army(gb:get_non_player_alliance_num(),"enemy_reinforcements_2");

-------------------------------------------------------------------------------------------------
-------------------------------------------- EVENTS ---------------------------------------------
-------------------------------------------------------------------------------------------------
	gb:message_on_time_offset("cutscene_end", 36500);
	--ga_defender_01:goto_location_offset_on_message("cutscene_end", 0, 1, false);	

--- MAIN FORCE ATTACKS
	ga_defender_01:goto_location_offset_on_message("cutscene_end", 0, 120, false);	
	ga_defender_01:message_on_proximity_to_position("attack_01", v(132, 171, 215), 50);
	ga_defender_01:attack_on_message("attack_01");
	ga_defender_01:message_on_casualties("attack_01", 0.05);
	
--- FIRST SKINKS
	ga_defender_02:goto_location_offset_on_message("01_intro_cutscene_end", 0, -60, false);	
	ga_defender_02:message_on_proximity_to_position("attack_02", v(-132, 164, -150), 40);
	ga_defender_02:release_on_message("attack_02");
	ga_defender_02:message_on_casualties("attack_02", 0.05);
	
--- SECOND SKINKS
	ga_attacker_01:message_on_casualties("second_skinks", 0.05);
	ga_defender_03:reinforce_on_message("second_skinks", 1000);
	ga_defender_03:attack_on_message("second_skinks");

--- THIRD SKINKS
	ga_attacker_01:message_on_casualties("third_skinks", 0.1);
	ga_defender_04:reinforce_on_message("third_skinks", 1000);
	ga_defender_04:attack_on_message("third_skinks");

--- PLAYER REINFORCEMENT
	ga_attacker_01:message_on_casualties("reinforcements", 0.30);
	ga_attacker_01:message_on_casualties("attack_3", 0.35);
	ga_ally_01:reinforce_on_message("reinforcements",10000);
	ga_ally_02:reinforce_on_message("reinforcements",10000);
	ga_ally_01:release_on_message("reinforcements");
	ga_ally_02:release_on_message("reinforcements");
	ga_ally_01:attack_on_message("attack_3");
	ga_ally_02:attack_on_message("attack_3");

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------
  
gb:set_objective_on_message("01_intro_cutscene_end", "wh2_main_qb_def_malekith_supreme_spellshield_stage_3_mosquito_swamps_hints_main_objective");

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh2_main_qb_def_malekith_supreme_spellshield_stage_3_mosquito_swamps_hints_survive", 6000, nil, 5000);
gb:queue_help_on_message("reinforcements", "wh2_main_qb_def_malekith_supreme_spellshield_stage_3_mosquito_swamps_hints_reinforcements");

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------