-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Malus
-- Warpsword of Khaine
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
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\rod_malus.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc14_emp_Malus_Darkblade_final_battle_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc14_emp_Malus_Darkblade_final_battle_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc14_emp_Malus_Darkblade_final_battle_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_dlc14_emp_Malus_Darkblade_final_battle_pt_04");

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_attacker_01 = gb:get_army(gb:get_player_alliance_num(), 1, "");
ga_ally = gb:get_army(gb:get_player_alliance_num(),"ally");
ga_enemy = gb:get_army(gb:get_non_player_alliance_num(),"enemy_army");
ga_enemy_snikch = gb:get_army(gb:get_non_player_alliance_num(),"enemy_reinforcements");
ga_enemy_snikch_split = gb:get_army(gb:get_non_player_alliance_num(),"enemy_reinforcements_split");


-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------

function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");
	
--teleport unit (1) of ga_artillery to [645, -420] with an orientation of 45 degrees and a width of 25m
--ga_enemy_flank.sunits:item(1).uc:teleport_to_location(v(645, -420), 180, 25);
--teleport unit (2) of ga_artillery to [600, -440] with an orientation of 45 degrees and a width of 25m
--ga_enemy_flank.sunits:item(2).uc:teleport_to_location(v(600, -440), 180, 25);
--teleport unit (3) of ga_artillery to [620, -430] with an orientation of 45 degrees and a width of 25m
--ga_enemy_flank.sunits:item(3).uc:teleport_to_location(v(620, -430), 180, 25);
--teleport unit (4) of ga_artillery to [630, -410] with an orientation of 45 degrees and a width of 25m
--ga_enemy_flank.sunits:item(4).uc:teleport_to_location(v(630, -410), 180, 25);
	
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
		ga_attacker_01.sunits,					-- unitcontroller over player's army
		68000, 									-- duration of cutscene in ms
		function() intro_cutscene_end() end		-- what to call when cutscene is finished
	);
	
	local player_units_hidden = false;
	
	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
		
	cutscene_intro:set_post_cutscene_fade_time(3.0, 3000);
	
	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()		
			local cam = bm:camera();
			bm:stop_cindy_playback(true);		
			if player_units_hidden then
				ga_attacker_01:set_enabled(true)
			end;
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 680);
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\rod_malus.CindySceneManager", 0, 2) end, 680);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_attacker_01:set_enabled(true) 
		end, 
		680
	);	
	
	-- Voiceover and Subtitles --\
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc14_emp_Malus_Darkblade_final_battle_pt_01", "subtitle_with_frame", 0.1, true) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 18500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 19500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc14_emp_Malus_Darkblade_final_battle_pt_02", "subtitle_with_frame", 0.1, true) end, 19500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 36000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 36500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc14_emp_Malus_Darkblade_final_battle_pt_03", "subtitle_with_frame", 0.1, true) end, 36500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 52500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 53000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc14_emp_Malus_Darkblade_final_battle_pt_04", "subtitle_with_frame", 0.1, true) end, 53000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 68000);

	cutscene_intro:start();
	
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;


-------------------------------------------------------------------------------------------------
------------------------------------------ ORDERS -------------------------------------------
-------------------------------------------------------------------------------------------------
--Stopping armies from firing until the cutscene is done
ga_attacker_01:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_attacker_01:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

ga_enemy:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_enemy:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

--gb:message_on_time_offset("reinforce", 30000,"01_intro_cutscene_end");
gb:message_on_time_offset("reinforcements_move", 5000,"battle_started");
gb:message_on_time_offset("ally_move", 20000,"battle_started");
gb:message_on_time_offset("reinforcements_defend", 60000,"01_intro_cutscene_end");
gb:message_on_time_offset("release_all", 360000,"01_intro_cutscene_end");
gb:message_on_time_offset("spawn1", 60000,"01_intro_cutscene_end");
gb:message_on_time_offset("spawn2", 130000,"01_intro_cutscene_end");
gb:message_on_time_offset("spawn3", 210000,"01_intro_cutscene_end");
ga_enemy_snikch:message_on_casualties("reinforcements_dying", 0.2);
ga_enemy_snikch_split:message_on_casualties("reinforcements_split_dying", 0.2);
ga_enemy_snikch_split:message_on_proximity_to_enemy("ambush_close", 50);
ga_enemy_snikch:message_on_commander_death("snikch_dead", 1);

gb:message_on_time_offset("enemy_release", 90000,"01_intro_cutscene_end");
ga_enemy:message_on_casualties("enemy_dying", 0.7);
ga_enemy:defend_on_message("battle_started",-110, -16, 100);
ga_enemy:message_on_proximity_to_enemy("close_to_ally", 50);
ga_enemy:attack_on_message("close_to_ally");
ga_enemy:release_on_message("enemy_dying");
ga_enemy:release_on_message("release_all");

gb:message_on_time_offset("ally_release", 100000,"01_intro_cutscene_end");
ga_ally:goto_location_offset_on_message("ally_move", 1, 120, true);
ga_ally:release_on_message("ally_release");

--ga_enemy_snikch:reinforce_on_message("reinforce", 10);
ga_enemy_snikch:goto_location_offset_on_message("reinforcements_move", 10, 500, true);
ga_enemy_snikch:defend_on_message("reinforcements_defend",-300, 30, 200);
ga_enemy_snikch:release_on_message("reinforcements_dying");
ga_enemy_snikch:release_on_message("release_all");

ga_enemy_snikch_split:defend_on_message("battle_started",180, 150, 200);
ga_enemy_snikch_split:defend_on_message("battle_started",180, 150, 200);
ga_enemy_snikch_split:release_on_message("reinforcements_split_dying");
ga_enemy_snikch_split:release_on_message("release_all");

gb:block_message_on_message("snikch_dead", "spawn1", true);
gb:block_message_on_message("snikch_dead", "spawn2", true);
gb:block_message_on_message("snikch_dead", "spawn3", true);
ga_enemy_snikch:use_army_special_ability_on_message("spawn1","wh2_dlc14_final_battle_ability_summon_snikch", v(-160.0, 876.0, 0.0));
--ga_enemy_snikch:use_army_special_ability_on_message("spawn2","wh2_dlc14_final_battle_ability_summon_snikch", v(285.4,880.7,92.0)); 
ga_enemy_snikch:use_army_special_ability_on_message("spawn2","wh2_dlc14_final_battle_ability_summon_snikch", v(-433, 850, 79));	--spawns on blark behind player
ga_enemy_snikch:use_army_special_ability_on_message("spawn3","wh2_dlc14_final_battle_ability_summon_snikch", v(-11.0, 850, -24.0));

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc14_qb_def_malus_final_battle_objective_1");
gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc14_qb_def_malus_final_battle_objective_2");

gb:complete_objective_on_message("snikch_dead", "wh2_dlc14_qb_def_malus_final_battle_objective_2", 5);

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc14_qb_def_malus_final_battle_hint_1", 6000, nil, 5000);
gb:queue_help_on_message("spawn1", "wh2_dlc14_qb_def_malus_final_battle_hint_2", 6000, nil, 5000);
gb:queue_help_on_message("spawn2", "wh2_dlc14_qb_def_malus_final_battle_hint_3", 6000, nil, 5000);
gb:queue_help_on_message("spawn3", "wh2_dlc14_qb_def_malus_final_battle_hint_3", 6000, nil, 5000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------