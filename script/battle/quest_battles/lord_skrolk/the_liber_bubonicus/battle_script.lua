-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Lord Skrolk
-- The Liber Bubonicus
-- Mortuary of Tzulaqua
-- Defender

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------
load_script_libraries();
cam = bm:camera();

gb = generated_battle:new(
	false,                                      		-- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                      		    -- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
);

--preload stuttering fix
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\lbb.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_main_qb_skv_skrolk_the_liber_bubonicus_stage_3_mortuary_of_tzulaqua_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_main_qb_skv_skrolk_the_liber_bubonicus_stage_3_mortuary_of_tzulaqua_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_main_qb_skv_skrolk_the_liber_bubonicus_stage_3_mortuary_of_tzulaqua_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_main_qb_skv_skrolk_the_liber_bubonicus_stage_3_mortuary_of_tzulaqua_pt_04");


-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

--fade_on_intro_cutscene_end = true;

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
	
	cam:fade(false, 1);
		
	-- declare cutscene
	local cutscene_intro = cutscene:new(
		"cutscene_intro", 						-- unique string name for cutscene
		ga_defender_01.sunits,					-- unitcontroller over player's army
		30000, 									-- duration of cutscene in ms
		function() intro_cutscene_end() end		-- what to call when cutscene is finished
	);
	
	local player_units_hidden = true;
	
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
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);	

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\lbb.CindySceneManager", true) end, 0);	
	
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_defender_01:set_enabled(true) 
		end, 
		200
	);
	
	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 3000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_skv_skrolk_the_liber_bubonicus_stage_3_mortuary_of_tzulaqua_pt_01", "subtitle_with_frame", 0.1) end, 3500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 5000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 5500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_skv_skrolk_the_liber_bubonicus_stage_3_mortuary_of_tzulaqua_pt_02", "subtitle_with_frame", 0.1) end, 6000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 11500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 12000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_skv_skrolk_the_liber_bubonicus_stage_3_mortuary_of_tzulaqua_pt_03", "subtitle_with_frame", 0.1) end, 12500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 22500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 23000);
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_skv_skrolk_the_liber_bubonicus_stage_3_mortuary_of_tzulaqua_pt_04", "subtitle_with_frame", 0.1) end, 23500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 29500);
	
	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_defender_01 = gb:get_army(gb:get_player_alliance_num(), 1);

ga_attacker_01 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_north");
ga_zom_south_01 = gb:get_army(gb:get_non_player_alliance_num(), "south_1");
ga_zom_south_02 = gb:get_army(gb:get_non_player_alliance_num(), "south_2");
ga_zom_south_03 = gb:get_army(gb:get_non_player_alliance_num(), "south_3");
ga_zom_west_01 = gb:get_army(gb:get_non_player_alliance_num(), "west_1");
ga_zom_west_02 = gb:get_army(gb:get_non_player_alliance_num(), "west_2");
ga_zom_west_03 = gb:get_army(gb:get_non_player_alliance_num(), "west_3");
ga_zom_west_04 = gb:get_army(gb:get_non_player_alliance_num(), "west_4");
ga_zom_west_05 = gb:get_army(gb:get_non_player_alliance_num(), "west_5");
ga_zom_north_01 = gb:get_army(gb:get_non_player_alliance_num(), "north_1");
ga_zom_north_02 = gb:get_army(gb:get_non_player_alliance_num(), "north_2");

--[[
if gb:get_army(gb:get_non_player_alliance_num(), 3):are_unit_types_in_army("wh_dlc04_vmp_cha_master_necromancer_2") then
	ga_attacker_01 = gb:get_army(gb:get_non_player_alliance_num(), 1,"enemy_army_north");
	ga_zom_south_01 = gb:get_army(gb:get_non_player_alliance_num(), 2,"south_1");
	ga_zom_south_02 = gb:get_army(gb:get_non_player_alliance_num(), 2,"south_2");
	ga_zom_south_03 = gb:get_army(gb:get_non_player_alliance_num(), 2,"south_3");
	ga_zom_west_01 = gb:get_army(gb:get_non_player_alliance_num(), 3,"west_1");
	ga_zom_west_02 = gb:get_army(gb:get_non_player_alliance_num(), 3,"west_2");
	ga_zom_west_03 = gb:get_army(gb:get_non_player_alliance_num(), 3,"west_3");
	ga_zom_west_04 = gb:get_army(gb:get_non_player_alliance_num(), 3,"west_4");
	ga_zom_west_05 = gb:get_army(gb:get_non_player_alliance_num(), 3,"west_5");
	ga_zom_north_01 = gb:get_army(gb:get_non_player_alliance_num(), 1,"north_1");
	ga_zom_north_02 = gb:get_army(gb:get_non_player_alliance_num(), 1,"north_2");
else
	ga_attacker_01 = gb:get_army(gb:get_non_player_alliance_num(), 1,"enemy_army_north");
	ga_zom_south_01 = gb:get_army(gb:get_non_player_alliance_num(), 3,"south_1");
	ga_zom_south_02 = gb:get_army(gb:get_non_player_alliance_num(), 3,"south_2");
	ga_zom_south_03 = gb:get_army(gb:get_non_player_alliance_num(), 3,"south_3");
	ga_zom_west_01 = gb:get_army(gb:get_non_player_alliance_num(), 2,"west_1");
	ga_zom_west_02 = gb:get_army(gb:get_non_player_alliance_num(), 2,"west_2");
	ga_zom_west_03 = gb:get_army(gb:get_non_player_alliance_num(), 2,"west_3");
	ga_zom_west_04 = gb:get_army(gb:get_non_player_alliance_num(), 2,"west_4");
	ga_zom_west_05 = gb:get_army(gb:get_non_player_alliance_num(), 2,"west_5");
	ga_zom_north_01 = gb:get_army(gb:get_non_player_alliance_num(), 1,"north_1");
	ga_zom_north_02 = gb:get_army(gb:get_non_player_alliance_num(), 1,"north_2");
end
]]



-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("cutscene_advance", 30000);

--ga_attacker_01:defend_on_message("cutscene_advance",160, 100, 60);
ga_attacker_01:goto_location_offset_on_message("cutscene_advance", 0, 30, false);
gb:message_on_time_offset("01_intro_cutscene_end", 35000);
ga_attacker_01:attack_on_message("01_intro_cutscene_end");

ga_defender_01:message_on_proximity_to_enemy("zombies", 10);

gb:message_on_time_offset("reinforcements", 30000);

ga_zom_south_01:reinforce_on_message("reinforcements");
ga_zom_south_02:reinforce_on_message("reinforcements", 125000);
ga_zom_south_03:reinforce_on_message("reinforcements", 245000);
ga_zom_south_01:message_on_any_deployed("s_attack_1");
ga_zom_south_01:attack_on_message("s_attack_1");
ga_zom_south_02:message_on_any_deployed("s_attack_2");
ga_zom_south_02:attack_on_message("s_attack_2");
ga_zom_south_03:message_on_any_deployed("s_attack_3");
ga_zom_south_03:attack_on_message("s_attack_3");

ga_zom_west_01:reinforce_on_message("reinforcements");
ga_zom_west_02:reinforce_on_message("reinforcements", 65000);
ga_zom_west_03:reinforce_on_message("reinforcements", 125000);
ga_zom_west_04:reinforce_on_message("reinforcements", 185000);
ga_zom_west_05:reinforce_on_message("reinforcements", 245000);
ga_zom_west_01:message_on_any_deployed("w_attack_1");
ga_zom_west_01:attack_on_message("w_attack_1");
ga_zom_west_02:message_on_any_deployed("w_attack_2");
ga_zom_west_02:attack_on_message("w_attack_2");
ga_zom_west_03:message_on_any_deployed("w_attack_3");
ga_zom_west_03:attack_on_message("w_attack_3");
ga_zom_west_04:message_on_any_deployed("w_attack_4");
ga_zom_west_04:attack_on_message("w_attack_4");
ga_zom_west_05:message_on_any_deployed("w_attack_5");
ga_zom_west_05:attack_on_message("w_attack_5");

ga_zom_north_01:reinforce_on_message("reinforcements", 65000);
ga_zom_north_02:reinforce_on_message("reinforcements", 185000);
ga_zom_north_01:message_on_any_deployed("n_attack_1");
ga_zom_north_01:attack_on_message("n_attack_1");
ga_zom_north_02:message_on_any_deployed("n_attack_2");
ga_zom_north_02:attack_on_message("n_attack_2");

ga_attacker_01:message_on_proximity_to_enemy("att_release_1", 10);
ga_zom_west_01:message_on_proximity_to_enemy("west_release_1", 10);
ga_zom_west_02:message_on_proximity_to_enemy("west_release_2", 10);
ga_zom_west_03:message_on_proximity_to_enemy("west_release_3", 10);
ga_zom_west_04:message_on_proximity_to_enemy("west_release_4", 10);
ga_zom_west_05:message_on_proximity_to_enemy("west_release_5", 10);
ga_zom_north_01:message_on_proximity_to_enemy("north_release_1", 10);
ga_zom_north_02:message_on_proximity_to_enemy("north_release_2", 10);
ga_zom_south_01:message_on_proximity_to_enemy("south_release_1", 10);
ga_zom_south_02:message_on_proximity_to_enemy("south_release_2", 10);
ga_zom_south_03:message_on_proximity_to_enemy("south_release_3", 10);

ga_attacker_01:release_on_message("att_release_1");
ga_zom_west_01:release_on_message("west_release_1");
ga_zom_west_02:release_on_message("west_release_2");
ga_zom_west_03:release_on_message("west_release_3");
ga_zom_west_04:release_on_message("west_release_4");
ga_zom_west_05:release_on_message("west_release_5");
ga_zom_north_01:release_on_message("north_release_1");
ga_zom_north_02:release_on_message("north_release_2");
ga_zom_south_01:release_on_message("south_release_1");
ga_zom_south_02:release_on_message("south_release_2");
ga_zom_south_03:release_on_message("south_release_3");

--ga_zom_south_01:release_on_message("01_intro_cutscene_end");
--ga_zom_south_02:release_on_message("01_intro_cutscene_end");
--ga_zom_south_03:release_on_message("01_intro_cutscene_end");
--ga_zom_west_01:release_on_message("01_intro_cutscene_end");
--ga_zom_west_02:release_on_message("01_intro_cutscene_end");
--ga_zom_west_03:release_on_message("01_intro_cutscene_end");
--ga_zom_west_04:release_on_message("01_intro_cutscene_end");
--ga_zom_west_05:release_on_message("01_intro_cutscene_end");
--ga_zom_north_01:release_on_message("01_intro_cutscene_end");
--ga_zom_north_02:release_on_message("01_intro_cutscene_end");

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------
  
gb:set_objective_on_message("cutscene_advance", "wh2_main_qb_skv_skrolk_the_liber_bubonicus_stage_3_mortuary_of_tzulaqua_hint_main_objectives");

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("zombies", "wh2_main_qb_skv_skrolk_the_liber_bubonicus_stage_3_mortuary_of_tzulaqua_hint_zombies");
gb:queue_help_on_message("cutscene_advance", "wh2_main_qb_skv_skrolk_the_liber_bubonicus_stage_3_mortuary_of_tzulaqua_hint_reinforcements", 3000, nil, 5000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY ----------------------------------------------
-------------------------------------------------------------------------------------------------


