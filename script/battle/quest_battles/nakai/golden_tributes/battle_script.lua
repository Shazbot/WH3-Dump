-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Nakai
-- Golden Tributes
-- INSERT ENVIRONMENT NAME
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();
bm = battle_manager:new(empire_battle:new());

bm:camera():fade(true, 0);

gb = generated_battle:new(
	true,                                      		    -- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                      		    -- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
);

--preload stuttering fix
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\gt_nakai_01.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);

--Composite Scenes For Lord Kroak's force field and "teleport flash"
--kroak_cs = "composite_scene/battle_props/lord_kroak_qb.csc";
--flash_cs = "composite_scene/battle_props/lord_kroak_enter_qb_.csc";

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc13_lzd_nakai_QB_golden_tributes_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc13_lzd_nakai_QB_golden_tributes_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc13_lzd_nakai_QB_golden_tributes_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_dlc13_lzd_nakai_QB_golden_tributes_pt_04");
-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player = gb:get_army(gb:get_player_alliance_num(), 1, "");
ally_cinematic = gb:get_army(gb:get_player_alliance_num(),"ally_cinematic");
ally_gor_rok = gb:get_army(gb:get_player_alliance_num(),"ally_gor_rok");

enemy_cinematic = gb:get_army(gb:get_non_player_alliance_num(),"enemy_cinematic");
enemy_skaven_east = gb:get_army(gb:get_non_player_alliance_num(),"enemy_skaven_east");
enemy_vampirates_west = gb:get_army(gb:get_non_player_alliance_num(),"enemy_vampirates_west");
enemy_harkon_boss = gb:get_army(gb:get_non_player_alliance_num(),"enemy_harkon_boss");

-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------

function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");
	
--teleport unit (1) of ga_artillery to [450, 20] with an orientation of 45 degrees and a width of 25m
--ga_artillery.sunits:item(1).uc:teleport_to_location(v(-310, 290), 180, 25);

	
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
		ga_player.sunits,					-- unitcontroller over player's army
		64000, 									-- duration of cutscene in ms
		function() intro_cutscene_end() end		-- what to call when cutscene is finished
	);
	
	local player_units_hidden = false;
	
	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
		
	cutscene_intro:set_post_cutscene_fade_time(3.0, 3200);
	
	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()		
			local cam = bm:camera();
			bm:stop_cindy_playback(true);		
			if player_units_hidden then
				ga_player:set_enabled(true)
			end;
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\gt_nakai_01.CindySceneManager", 0, 0) end, 0);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_player:set_enabled(true) 
		end, 
		200
	);	
	
	-- Voiceover and Subtitles --
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 4000);	

	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 9000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc13_lzd_nakai_QB_golden_tributes_pt_01", "subtitle_with_frame", 2, true) end, 9500);
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 14500);

	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 23000);
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc13_lzd_nakai_QB_golden_tributes_pt_02", "subtitle_with_frame", 2, true) end, 23500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 28000);

	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 43000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc13_lzd_nakai_QB_golden_tributes_pt_03", "subtitle_with_frame", 2, true) end, 43500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 48500);

	cutscene_intro:start();
	
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;


-------------------------------------------------------------------------------------------------
------------------------------------------ ORDERS -------------------------------------------
-------------------------------------------------------------------------------------------------
enemy_vampirates_west:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
enemy_skaven_east:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
enemy_vampirates_west:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
enemy_skaven_east:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

ga_player:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_player:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

ga_player:message_on_rout_proportion("player_loses", 1);

ally_cinematic:message_on_rout_proportion("slann_dead", 1);
ally_gor_rok:message_on_rout_proportion("gorrok_dead", 1);

--reinforcement messages
gb:message_on_time_offset("fight", 12000);
--ga_enemy_reinforcements:message_on_proximity_to_enemy("enemy_reinf_close", 150);
enemy_cinematic:message_on_casualties("zombies_dying", 0.2);
enemy_cinematic:message_on_casualties("zombies_almost_dead", 0.4);
ally_cinematic:message_on_casualties("allies_dying", 0.1);

ally_gor_rok:message_on_proximity_to_enemy("gor_rok_proximity", 100);
enemy_vampirates_west:message_on_proximity_to_enemy("vampirates_west_proximity", 100);

--composite scene timers
--gb:message_on_time_offset("start_cs", 530900);

--reinforcement 2 messages
enemy_skaven_east:message_on_casualties("enemy_skaven_east_dying", 0.5);
enemy_vampirates_west:message_on_casualties("enemy_vampirates_west_dying", 0.5);

--reinforcement boss messages

--toggling composite scenes
--gb:stop_terrain_composite_scene_on_message("stop_cs", kroak_cs);
--gb:start_terrain_composite_scene_on_message("start_cs", flash_cs);

--main orders
enemy_cinematic:release_on_message("fight");
ally_cinematic:attack_on_message("fight");
ally_cinematic:release_on_message("allies_dying");


--reinforcement 1 orders
enemy_skaven_east:release_on_message("zombies_dying", 5);
enemy_vampirates_west:release_on_message("zombies_dying", 5);

--reinforcement boss orders

enemy_harkon_boss:reinforce_on_message("enemy_skaven_east_dying", 10);
enemy_harkon_boss:release_on_message("enemy_skaven_east_dying", 30);

enemy_harkon_boss:reinforce_on_message("enemy_vampirates_west_dying", 10);
enemy_harkon_boss:release_on_message("enemy_vampirates_west_dying", 30);
--ally orders
ally_gor_rok:release_on_message("gor_rok_proximity", 5);

gb:block_message_on_message("enemy_skaven_east_dying", "enemy_vampirates_west_dying", true);
gb:block_message_on_message("enemy_vampirates_west_dying", "enemy_skaven_east_dying", true);
-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------
ga_player:message_on_victory("player_wins");

gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc13_qb_nakai_golden_tributes_main_objective");
gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc13_qb_nakai_golden_tributes_stay_alive_objective");
gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc13_qb_nakai_golden_tributes_gorrok_objective");
gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc13_qb_nakai_golden_tributes_slann_objective");

gb:complete_objective_on_message("player_wins", "wh2_dlc13_qb_nakai_golden_tributes_main_objective", 5000);
gb:complete_objective_on_message("player_wins", "wh2_dlc13_qb_nakai_golden_tributes_stay_alive_objective", 5000);
gb:complete_objective_on_message("player_wins", "wh2_dlc13_qb_nakai_golden_tributes_gorrok_objective", 5000);
gb:complete_objective_on_message("player_wins", "wh2_dlc13_qb_nakai_golden_tributes_slann_objective", 5000);

gb:fail_objective_on_message("player_loses", "wh2_dlc13_qb_nakai_golden_tributes_stay_alive_objective", 5000);
gb:fail_objective_on_message("slann_dead", "wh2_dlc13_qb_nakai_golden_tributes_slann_objective", 5000);
gb:fail_objective_on_message("gorrok_dead", "wh2_dlc13_qb_nakai_golden_tributes_gorrok_objective", 5000);
-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc13_qb_nakai_golden_tributes_advice", 6000, nil, 5000);
gb:queue_help_on_message("enemy_skaven_east_dying", "wh2_dlc13_qb_nakai_golden_tributes_harkon_arrived", 6000, nil, 5000);
gb:queue_help_on_message("enemy_vampirates_west_dying", "wh2_dlc13_qb_nakai_golden_tributes_harkon_arrived", 6000, nil, 5000);
-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------
enemy_cinematic:force_victory_on_message("player_loses", 15000); 
enemy_cinematic:force_victory_on_message("gorrok_dead", 15000); 
enemy_cinematic:force_victory_on_message("slann_dead", 15000); 
gb:queue_help_on_message("player_loses", "wh2_dlc13_qb_nakai_golden_tributes_stay_alive_objective_fail", 6000, nil, 5000);
gb:queue_help_on_message("slann_dead", "wh2_dlc13_qb_nakai_golden_tributes_slann_objective_fail", 6000, nil, 5000);
gb:queue_help_on_message("gorrok_dead", "wh2_dlc13_qb_nakai_golden_tributes_gorrok_objective_fail", 6000, nil, 5000);