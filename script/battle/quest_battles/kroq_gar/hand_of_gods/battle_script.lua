-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Kroq_gar
-- Hand of Gods
-- Fallen Gates 
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
intro_cinematic_file = "script\\battle\\quest_battles\\kroq_gar\\hand_of_gods\\hog_cin\\managers\\hog_intro.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);

-------------------------------------------------------------------------------------------------
------------------------------------------ INTRO VO ---------------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_main_great_vortex_liz_kroq_gar_hand_of_gods_stage_3_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_main_great_vortex_liz_kroq_gar_hand_of_gods_stage_3_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_main_great_vortex_liz_kroq_gar_hand_of_gods_stage_3_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_main_great_vortex_liz_kroq_gar_hand_of_gods_stage_3_pt_04");
wh2_main_sfx_05 = new_sfx("Play_wh2_main_great_vortex_liz_kroq_gar_hand_of_gods_stage_3_pt_05");

wh2_main_intro_01 = new_sfx("Play_Movie_Warhammer2_Hand_of_God_Intro");
wh2_main_intro_stop_01 = new_sfx("Stop_Movie_Warhammer2_Hand_of_God_Intro");

--wh2_main_sfx_music_stop = new_sfx("music_b_REVEAL_STOP"); 

-------------------------------------------------------------------------------------------------
------------------------------------------- GAME VO ---------------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01_intro_cutscene_end = new_sfx("play_wh2_main_qb_lzd_kroqgar_hand_of_gods_stage_3_fallen_gates_hint_bastiladons");
--wh2_main_sfx_02_player_advances_to_bridge = new_sfx("play_wh2_main_qb_lzd_kroqgar_hand_of_gods_stage_3_fallen_gates_hint_player_reinforcements_projectiles");
wh2_main_sfx_03_player_wins_bridge_objective = new_sfx("play_wh2_main_qb_lzd_kroqgar_hand_of_gods_stage_3_fallen_gates_bridge_victory");
--wh2_main_sfx_03_player_wins_bridge = new_sfx("play_wh2_main_qb_lzd_kroqgar_hand_of_gods_stage_3_fallen_gates_hint_player_reinforcements_melee");
wh2_main_sfx_04_reinforcing_dragon = new_sfx("play_wh2_main_qb_lzd_kroqgar_hand_of_gods_stage_3_fallen_gates_hint_dragon");
wh2_main_sfx_05_player_advances_first_hill = new_sfx("play_wh2_main_qb_lzd_kroqgar_hand_of_gods_stage_3_fallen_gates_hint_artillery");
--wh2_main_sfx_07_guard_release_all_armies = new_sfx("play_wh2_main_qb_lzd_kroqgar_hand_of_gods_stage_3_fallen_gates_hint_ally_reinforcements");
wh2_main_sfx_08_reinforcing_mages = new_sfx("play_wh2_main_qb_lzd_kroqgar_hand_of_gods_stage_3_fallen_gates_hint_reinforcements");
wh2_main_sfx_09_player_wins_mages = new_sfx("play_wh2_main_qb_lzd_kroqgar_hand_of_gods_stage_3_fallen_gates_first_high_elf");
wh2_main_sfx_09_player_wins_mages_objective = new_sfx("play_wh2_main_qb_lzd_kroqgar_hand_of_gods_stage_3_fallen_gates_victory");

-------------------------------------------------------------------------------------------------
--------------------------------------- ENVIRONMENT SETUP ---------------------------------------
-------------------------------------------------------------------------------------------------

beam_stage_1 = "composite_scene/central_temple_beam_stage_1.csc";
beam_stage_2 = "composite_scene/central_temple_beam_stage_2.csc";
beam_stage_3 = "composite_scene/central_temple_beam_stage_3.csc";

ga_lizardmen_01 = gb:get_army(gb:get_player_alliance_num(), 1);

ga_high_elves_01 = gb:get_army(gb:get_non_player_alliance_num(), "high_elf_army");
ga_high_elves_04 = gb:get_army(gb:get_non_player_alliance_num(), "artillery");
ga_high_elves_03 = gb:get_army(gb:get_non_player_alliance_num(), "bridge_defence");
ga_high_elves_05 = gb:get_army(gb:get_non_player_alliance_num(), "high_elf_mages");
ga_high_elves_06 = gb:get_army(gb:get_non_player_alliance_num(), "high_elf_rearguard");

--[[
if gb:get_army(gb:get_non_player_alliance_num(), 1):are_unit_types_in_army("wh2_main_hef_cha_prince_0") then
	ga_high_elves_01 = gb:get_army(gb:get_non_player_alliance_num(), 1,"high_elf_army");
	ga_high_elves_04 = gb:get_army(gb:get_non_player_alliance_num(), 2,"artillery");
	ga_high_elves_03 = gb:get_army(gb:get_non_player_alliance_num(), 3,"bridge_defence");

	ga_high_elves_05 = gb:get_army(gb:get_non_player_alliance_num(), 1,"high_elf_mages");
	ga_high_elves_06 = gb:get_army(gb:get_non_player_alliance_num(), 1,"high_elf_rearguard");
else
	ga_high_elves_01 = gb:get_army(gb:get_non_player_alliance_num(), 3,"high_elf_army");
	ga_high_elves_04 = gb:get_army(gb:get_non_player_alliance_num(), 2,"artillery");
	ga_high_elves_03 = gb:get_army(gb:get_non_player_alliance_num(), 1,"bridge_defence");

	ga_high_elves_05 = gb:get_army(gb:get_non_player_alliance_num(), 3,"high_elf_mages");
	ga_high_elves_06 = gb:get_army(gb:get_non_player_alliance_num(), 3,"high_elf_rearguard");
end
]]

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
		ga_lizardmen_01.sunits,					-- unitcontroller over player's army
		68500, 									-- duration of cutscene in ms
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
				ga_lizardmen_01:set_enabled(true)
			end;						
			bm:callback(function() cam:fade(false, 0.5) end, 500);
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\kroq_gar\\hand_of_gods\\hog_cin\\managers\\hog_intro.CindySceneManager", true) end, 200);
	cutscene_intro:action(
		function()
			player_units_hidden = true;
			ga_lizardmen_01:set_enabled(false) 
		end, 
		200
	);	
	cutscene_intro:action(
		function() 
			player_units_hidden = false;
			ga_lizardmen_01:set_enabled(true) 
		end, 
		25000
	);		
	
	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 20200);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_great_vortex_liz_kroq_gar_hand_of_gods_stage_3_pt_01", "subtitle_with_frame", 2, true) end, 20300);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 23200);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 23400);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_great_vortex_liz_kroq_gar_hand_of_gods_stage_3_pt_02", "subtitle_with_frame", 3, true) end, 23500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 28000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 35500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_great_vortex_liz_kroq_gar_hand_of_gods_stage_3_pt_03", "subtitle_with_frame", 4.5, true) end, 36500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 43000);

	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_05) end, 55000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_great_vortex_liz_kroq_gar_hand_of_gods_stage_3_pt_05", "subtitle_with_frame", 5.5, true) end, 55200);
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 61500);

	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
	ga_lizardmen_01:message_on_alliance_not_active_on_battlefield("10_player_loses");
end;

-------------------------------------------------------------------------------------------------
-------------------------------------------- EVENTS ---------------------------------------------
-------------------------------------------------------------------------------------------------
	gb:play_sound_on_message("battle_started", wh2_main_intro_01, v(0,0), nil, nil, 100);
	gb:stop_sound_on_message("01_intro_cutscene_end", wh2_main_intro_01, 100);
	
--- BATTLE STARTED
	ga_high_elves_03:release_on_message("battle_started"); 
	ga_lizardmen_01:goto_location_offset_on_message("battle_started", 0, 60, false);
	gb:set_locatable_objective_on_message("battle_started", "wh2_main_qb_lzd_kroqgar_hand_of_gods_stage_3_fallen_gates_hint_first_objective", 0, v(3.3, 48.9, -680), v(-7.8, 8.4, -551.3), 2);
	gb:start_terrain_composite_scene_on_message("battle_started", beam_stage_1, 20000);	

--- INTRO CUTSCENE ENDED
	gb:add_ping_icon_on_message("01_intro_cutscene_end", v(2.8, 25, -568), 15, 1900, 10900);
	gb:queue_help_on_message("01_intro_cutscene_end", "wh2_main_qb_lzd_kroqgar_hand_of_gods_stage_3_fallen_gates_hint_bastiladons", 10000, 1000, 1000, nil, "01_intro_cutscene_end_vo");	
	-- gb:play_sound_on_message("01_intro_cutscene_end_vo", wh2_main_sfx_01_intro_cutscene_end, v(0,0), nil, nil, 5000);

--- PLAYER ADVANCES TO BRIDGE
	--ga_lizardmen_01:message_on_proximity_to_enemy("02_player_advances_to_bridge", 30);
	--ga_lizardmen_02:reinforce_on_message("02_player_advances_to_bridge", 30000);
	--gb:queue_help_on_message("02_player_advances_to_bridge", "wh2_main_qb_lzd_kroqgar_hand_of_gods_stage_3_fallen_gates_hint_player_reinforcements_projectiles", 10000, 500, 32500, nil, "02_player_advances_to_bridge_vo");
	--gb:play_sound_on_message("02_player_advances_to_bridge_vo", wh2_main_sfx_02_player_advances_to_bridge, v(0,0), nil, nil, 5000);

--- PLAYER WINS BRIDGE
	ga_high_elves_03:message_on_casualties("03_player_wins_bridge", 0.3);	
	ga_high_elves_03:message_on_rout_proportion("03_player_wins_bridge", 0.4);	
	ga_high_elves_03:rout_over_time_on_message("03_player_wins_bridge", 10000);

	gb:complete_objective_on_message("03_player_wins_bridge", "wh2_main_qb_lzd_kroqgar_hand_of_gods_stage_3_fallen_gates_hint_first_objective", 1000);
	-- gb:play_sound_on_message("03_player_wins_bridge", wh2_main_sfx_03_player_wins_bridge_objective, v(0,0), 1000, nil, 10000);
	gb:remove_objective_on_message("03_player_wins_bridge", "wh2_main_qb_lzd_kroqgar_hand_of_gods_stage_3_fallen_gates_hint_first_objective", 10000);
	gb:set_locatable_objective_on_message("03_player_wins_bridge", "wh2_main_qb_lzd_kroqgar_hand_of_gods_stage_3_fallen_gates_hint_main_objective", 3000, v(-10.6, 129.9, -16.8), v(-0.3, 122.0, 117.6), 2);

	--ga_lizardmen_03:reinforce_on_message("03_player_wins_bridge", 20000);
	--gb:queue_help_on_message("03_player_wins_bridge", "wh2_main_qb_lzd_kroqgar_hand_of_gods_stage_3_fallen_gates_hint_player_reinforcements_melee", 10000, 500, 25000, nil, "03_player_wins_bridge_vo");
	--gb:play_sound_on_message("03_player_wins_bridge_vo", wh2_main_sfx_03_player_wins_bridge, v(0,0), nil, nil, 5000);

--- REINFORCING DRAGON
	ga_high_elves_03:message_on_casualties("04_reinforcing_dragon", 0.3);	
	ga_high_elves_03:message_on_rout_proportion("04_reinforcing_dragon", 0.4);
	
	ga_high_elves_06:reinforce_on_message("04_reinforcing_dragon", 41000);
	ga_high_elves_06:attack_on_message("04_reinforcing_dragon", 42000);
	gb:queue_help_on_message("04_reinforcing_dragon", "wh2_main_qb_lzd_kroqgar_hand_of_gods_stage_3_fallen_gates_hint_dragon", 10000, 500, 42000, nil, "04_reinforcing_dragon_vo");
	-- gb:play_sound_on_message("04_reinforcing_dragon_vo", wh2_main_sfx_04_reinforcing_dragon, v(0,0), nil, nil, 5000);
	gb:start_terrain_composite_scene_on_message("04_reinforcing_dragon", beam_stage_2, 42000)	

--- PLAYER ADVANCES FIRST HILL
	ga_high_elves_04:message_on_proximity_to_enemy("05_player_advances_first_hill", 150);	
	gb:queue_help_on_message("05_player_advances_first_hill", "wh2_main_qb_lzd_kroqgar_hand_of_gods_stage_3_fallen_gates_hint_artillery", 10000, 500, 1000, nil, "05_player_advances_first_hill_vo");
	-- gb:play_sound_on_message("05_player_advances_first_hill_vo", wh2_main_sfx_05_player_advances_first_hill, v(0,0), nil, nil, 5000);

--- RELEASE ARTILLERY & PLAYER ARMIES GUARD
	ga_high_elves_04:message_on_proximity_to_enemy("06_guard_release_artillery", 20);	
	ga_high_elves_04:release_on_message("06_guard_release_artillery"); 	

--- RELEASE ENEMY ARMIES GUARD 
	ga_high_elves_01:release_on_message("07_guard_release_all_armies"); 
	ga_high_elves_05:release_on_message("07_guard_release_all_armies");
	ga_high_elves_06:release_on_message("07_guard_release_all_armies"); 

	ga_lizardmen_01:message_on_proximity_to_position("07_guard_release_all_armies", v(-12, 81, -50), 120); 
	--ga_lizardmen_02:message_on_proximity_to_position("07_guard_release_all_armies", v(-12, 81, -50), 120); 
	--ga_lizardmen_03:message_on_proximity_to_position("07_guard_release_all_armies", v(-12, 81, -50), 120); 
	
	ga_lizardmen_01:message_on_proximity_to_position("07_guard_release_all_armies", v(94, 97, 10), 120); 
	--ga_lizardmen_02:message_on_proximity_to_position("07_guard_release_all_armies", v(94, 97, 10), 120); 
	--ga_lizardmen_03:message_on_proximity_to_position("07_guard_release_all_armies", v(94, 97, 10), 120); 	
	
	ga_lizardmen_01:message_on_proximity_to_position("07_guard_release_all_armies", v(190, 97, 48), 120); 
	--ga_lizardmen_02:message_on_proximity_to_position("07_guard_release_all_armies", v(190, 97, 48), 120); 
	--ga_lizardmen_03:message_on_proximity_to_position("07_guard_release_all_armies", v(190, 97, 48), 120); 

	ga_lizardmen_01:message_on_proximity_to_position("07_guard_release_all_armies", v(-94, 97, 10), 120); 
	--ga_lizardmen_02:message_on_proximity_to_position("07_guard_release_all_armies", v(-94, 97, 10), 120); 
	--ga_lizardmen_03:message_on_proximity_to_position("07_guard_release_all_armies", v(-94, 97, 10), 120); 	
	
	ga_lizardmen_01:message_on_proximity_to_position("07_guard_release_all_armies", v(-190, 97, 48), 120); 
	--ga_lizardmen_02:message_on_proximity_to_position("07_guard_release_all_armies", v(-190, 97, 48), 120); 
	--ga_lizardmen_03:message_on_proximity_to_position("07_guard_release_all_armies", v(-190, 97, 48), 120); 
	
	gb:start_terrain_composite_scene_on_message("07_guard_release_all_armies", beam_stage_3, 1000);	

--- REINFORCING TERRADONS
	--ga_lizardmen_04:reinforce_on_message("07_guard_release_all_armies", 5000);
	--gb:queue_help_on_message("07_guard_release_all_armies", "wh2_main_qb_lzd_kroqgar_hand_of_gods_stage_3_fallen_gates_hint_ally_reinforcements", 10000, 500, 10000, nil, "07_guard_release_all_armies_vo");
	--gb:play_sound_on_message("07_guard_release_all_armies_vo", wh2_main_sfx_07_guard_release_all_armies, v(0,0), nil, nil, 5000);
	
--- REINFORCING MAGES
	ga_high_elves_05:reinforce_on_message("07_guard_release_all_armies", 20000);
	gb:queue_help_on_message("07_guard_release_all_armies", "wh2_main_qb_lzd_kroqgar_hand_of_gods_stage_3_fallen_gates_hint_reinforcements", 10000, 500, 25000, nil, "08_reinforcing_mages_vo");
	-- gb:play_sound_on_message("08_reinforcing_mages_vo", wh2_main_sfx_08_reinforcing_mages, v(0,0), nil, "08_reinforcing_mages_ping", 5000);

	ga_high_elves_05:add_ping_icon_on_message("08_reinforcing_mages_ping", 15, 1)
	ga_high_elves_05:add_ping_icon_on_message("08_reinforcing_mages_ping", 15, 2)
	
	gb:stop_terrain_composite_scene_on_message("07_guard_release_all_armies", beam_stage_1, 25500);
	gb:stop_terrain_composite_scene_on_message("07_guard_release_all_armies", beam_stage_2, 25500);
	gb:stop_terrain_composite_scene_on_message("07_guard_release_all_armies", beam_stage_3, 25500);	
	
--- PLAYER KILLS MAGES	
	ga_high_elves_05:message_on_rout_proportion("09_player_wins_first_mages", 0.5);
	-- gb:play_sound_on_message("09_player_wins_first_mages", wh2_main_sfx_09_player_wins_mages, v(0,0), 500, nil, 5000);
	
	ga_high_elves_05:message_on_rout_proportion("09_player_wins_mages", 1);
	ga_lizardmen_01:force_victory_on_message("09_player_wins_mages"); 	
	-- gb:play_sound_on_message("09_player_wins_mages", wh2_main_sfx_09_player_wins_mages_objective, v(0,0), 500, nil, 10000);
	
-- GUARD AGAINST PLAYER LOSING
	ga_high_elves_01:force_victory_on_message("10_player_loses"); 