-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Arkhan the Black
-- The Staff of Nagash
-- Staff_of_Nagash
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
intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/son.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc09_qb_tmb_arkhan_the_staff_of_nagash_stage_5_staff_of_nagash_part_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc09_qb_tmb_arkhan_the_staff_of_nagash_stage_5_staff_of_nagash_part_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc09_qb_tmb_arkhan_the_staff_of_nagash_stage_5_staff_of_nagash_part_03");

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
		34000, 									-- duration of cutscene in ms
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

	cutscene_intro:action(function() bm:cindy_playback("script/battle/quest_battles/_cutscene/managers/son.CindySceneManager", true) end, 200);
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
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc09_qb_tmb_arkhan_the_staff_of_nagash_stage_5_staff_of_nagash_part_01", "subtitle_with_frame", 0.1)	end, 3500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 12000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 12500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc09_qb_tmb_arkhan_the_staff_of_nagash_stage_5_staff_of_nagash_part_02", "subtitle_with_frame", 0.1)	end, 13000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 21500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 22500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc09_qb_tmb_arkhan_the_staff_of_nagash_stage_5_staff_of_nagash_part_03", "subtitle_with_frame", 0.1)	end, 22500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 33000);
	
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
if gb:get_army(gb:get_non_player_alliance_num(), 3):are_unit_types_in_army("wh2_main_skv_inf_gutter_runners_0") then
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

ga_attacker_01:set_always_visible_on_message("battle_started", true, false);

ga_defender_01:goto_location_offset_on_message("battle_started", 0, 80, false);
ga_attacker_01:goto_location_offset_on_message("battle_started", 0, 80, false);

ga_attacker_01:attack_on_message("01_intro_cutscene_end", 1000);


ga_defender_01:message_on_proximity_to_enemy("zombies", 10);

gb:message_on_time_offset("reinforcements", 60000);

ga_zom_south_01:reinforce_on_message("reinforcements");
ga_zom_south_02:reinforce_on_message("reinforcements", 145000);
ga_zom_south_03:reinforce_on_message("reinforcements", 285000);
ga_zom_south_01:message_on_any_deployed("s_attack_1");
ga_zom_south_01:attack_on_message("s_attack_1");
ga_zom_south_02:message_on_any_deployed("s_attack_2");
ga_zom_south_02:attack_on_message("s_attack_2");
ga_zom_south_03:message_on_any_deployed("s_attack_3");
ga_zom_south_03:attack_on_message("s_attack_3");

ga_zom_west_01:reinforce_on_message("reinforcements");
ga_zom_west_02:reinforce_on_message("reinforcements", 68000);
ga_zom_west_03:reinforce_on_message("reinforcements", 145000);
ga_zom_west_04:reinforce_on_message("reinforcements", 195000);
ga_zom_west_05:reinforce_on_message("reinforcements", 285000);
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

ga_zom_north_01:reinforce_on_message("reinforcements", 68000);
ga_zom_north_02:reinforce_on_message("reinforcements", 195000);
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

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------
  
gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc09_qb_tmb_arkhan_the_staff_of_nagash_stage_5_staff_of_nagash_hint_main_objective");

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------
gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc09_qb_tmb_arkhan_the_staff_of_nagash_stage_5_staff_of_nagash_hint_start_battle", 6000, nil, 5000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------