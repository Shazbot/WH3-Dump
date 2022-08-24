 -------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Teclis
-- War Crown of Saphery
-- Caverns of the Great Bat
-- Defending

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
intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/wcs.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_main_qb_hef_teclis_war_crown_of_saphery_stage_3_caverns_of_the_great_bat_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_main_qb_hef_teclis_war_crown_of_saphery_stage_3_caverns_of_the_great_bat_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_main_qb_hef_teclis_war_crown_of_saphery_stage_3_caverns_of_the_great_bat_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_main_qb_hef_teclis_war_crown_of_saphery_stage_3_caverns_of_the_great_bat_pt_04");


-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
	
	--cam:fade(true, 0);
	
	-- declare cutscene
	local cutscene_intro = cutscene:new(
		"cutscene_intro", 						-- unique string name for cutscene
		ga_defender_01.sunits,					-- unitcontroller over player's army
		43500, 									-- duration of cutscene in ms
		function() intro_cutscene_end() end		-- what to call when cutscene is finished
	);
	
	local player_units_hidden = false;
	
	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
	
	--cutscene_intro:set_is_ambush();
	
	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()
			bm:stop_cindy_playback(true);
			
			if player_units_hidden then
				ga_defender_01:set_enabled(true)
			end;
		end
	);
	
	-- set up actions on cutscene
	--cutscene_intro:action(function() cam:fade(false, 1) end, 1000);

	cutscene_intro:action(function() bm:cindy_playback("script/battle/quest_battles/_cutscene/managers/wcs.CindySceneManager", true) end, 0);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_defender_01:set_enabled(true) 
		end, 
		200
	);	
	
	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 3000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_hef_teclis_war_crown_of_saphery_stage_3_caverns_of_the_great_bat_pt_01", "subtitle_with_frame", 2) end, 3100);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 16300);
	
	cutscene_intro:action(function() cutscene_intro:wait_for_vo() end, 16300);	

	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 16800);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_hef_teclis_war_crown_of_saphery_stage_3_caverns_of_the_great_bat_pt_02", "subtitle_with_frame", 2) end, 16900);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 23800);

	cutscene_intro:action(function() cutscene_intro:wait_for_vo() end, 24100);		
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 24300);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_hef_teclis_war_crown_of_saphery_stage_3_caverns_of_the_great_bat_pt_03", "subtitle_with_frame", 2) end, 24400);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 35000);

	cutscene_intro:action(function() cutscene_intro:wait_for_vo() end, 35300);	
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 35500);
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_hef_teclis_war_crown_of_saphery_stage_3_caverns_of_the_great_bat_pt_04", "subtitle_with_frame", 2) end, 35600);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 43300);

	cutscene_intro:action(function() cutscene_intro:wait_for_vo() end, 43400);	
	
	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_defender_01 = gb:get_army(gb:get_player_alliance_num(), 1);

ga_attacker_01 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army");
ga_ally_01 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_reinforcements_1");
ga_ally_02 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_reinforcements_2");

ga_bat_01 = gb:get_army(gb:get_non_player_alliance_num(), "great_bat_wave_1");
ga_bat_02 = gb:get_army(gb:get_non_player_alliance_num(), "great_bat_wave_2");
ga_bat_03 = gb:get_army(gb:get_non_player_alliance_num(), "great_bat_wave_3");
	
--[[
if gb:get_army(gb:get_non_player_alliance_num(), 3):are_unit_types_in_army("wh_main_vmp_mon_terrorgheist_qb") then
	ga_attacker_01 = gb:get_army(gb:get_non_player_alliance_num(), 1,"enemy_army");
	ga_ally_01 = gb:get_army(gb:get_non_player_alliance_num(), 2,"enemy_reinforcements_1");
	ga_ally_02 = gb:get_army(gb:get_non_player_alliance_num(), 2,"enemy_reinforcements_2");

	ga_bat_01 = gb:get_army(gb:get_non_player_alliance_num(), 3,"great_bat_wave_1");
	ga_bat_02 = gb:get_army(gb:get_non_player_alliance_num(), 3,"great_bat_wave_2");
	ga_bat_03 = gb:get_army(gb:get_non_player_alliance_num(), 3,"great_bat_wave_3");
else
	ga_attacker_01 = gb:get_army(gb:get_non_player_alliance_num(), 1,"enemy_army");
	ga_ally_01 = gb:get_army(gb:get_non_player_alliance_num(), 3,"enemy_reinforcements_1");
	ga_ally_02 = gb:get_army(gb:get_non_player_alliance_num(), 3,"enemy_reinforcements_2");

	ga_bat_01 = gb:get_army(gb:get_non_player_alliance_num(), 2,"great_bat_wave_1");
	ga_bat_02 = gb:get_army(gb:get_non_player_alliance_num(), 2,"great_bat_wave_2");
	ga_bat_03 = gb:get_army(gb:get_non_player_alliance_num(), 2,"great_bat_wave_3");
end
]]

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

--ga_attacker_01:halt();

ga_attacker_01:release_on_message("reinforcements_1", 100);
gb:message_on_time_offset("reinforcements_1", 43500);
ga_attacker_01:message_on_proximity_to_enemy("reinforcements_1", 190); -- Skaven ambush when the player approaches the main army
ga_attacker_01:message_on_casualties("reinforcements_1", 0.1); -- Backup to trigger Skaven reinforcements if the player tries to kill them from long range

ga_ally_01:reinforce_on_message("reinforcements_1");
ga_ally_02:reinforce_on_message("reinforcements_1");
ga_ally_01:attack_on_message("reinforcements_1", 100);
ga_ally_02:attack_on_message("reinforcements_1", 100);



ga_attacker_01:message_on_casualties("bat_1", 0.15); -- Bat wave when the player approaches the main army
ga_attacker_01:message_on_casualties("bat_2", 0.25); -- Bat wave when the player approaches the main army
ga_attacker_01:message_on_casualties("bat_3", 0.35);


ga_bat_01:reinforce_on_message("bat_1");
ga_bat_01:release_on_message("bat_1", 100);
ga_bat_02:reinforce_on_message("bat_2");
ga_bat_02:release_on_message("bat_2", 100);
ga_bat_03:reinforce_on_message("bat_3");
ga_bat_03:release_on_message("bat_3", 100);
-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------
  
gb:set_objective_on_message("01_intro_cutscene_end", "wh2_main_qb_hef_teclis_war_crown_of_saphery_stage_3_caverns_of_the_great_bat_hints_main_objective");

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh2_main_qb_hef_teclis_war_crown_of_saphery_stage_3_caverns_of_the_great_bat_hints_skaven", 3000, nil, 5000);
gb:queue_help_on_message("bat_1", "wh2_main_qb_hef_teclis_war_crown_of_saphery_stage_3_caverns_of_the_great_bat_hints_bat_00");
gb:queue_help_on_message("bat_2", "wh2_main_qb_hef_teclis_war_crown_of_saphery_stage_3_caverns_of_the_great_bat_hints_bat_01");
gb:queue_help_on_message("bat_3", "wh2_main_qb_hef_teclis_war_crown_of_saphery_stage_3_caverns_of_the_great_bat_hints_bat_02");

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY ----------------------------------------------
-------------------------------------------------------------------------------------------------

