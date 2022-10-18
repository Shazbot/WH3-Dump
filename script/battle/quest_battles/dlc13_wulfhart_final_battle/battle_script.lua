-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Markus Wulfhart
-- Final Battle
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

--Composite Scenes For Cinematic
--force_field_cs = "composite_scene/wh2_dlc13_slann_shield_army.csc";
--kalara_cs = "composite_scene/wh2_dlc13_kalara_firing.csc";
--explosion_cs = "composite_scene/wh2_dlc13_arrow_kurnous_explosion.csc";
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc13_emp_markus_wulfhart_final_battle_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc13_emp_markus_wulfhart_final_battle_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc13_emp_markus_wulfhart_final_battle_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_dlc13_emp_markus_wulfhart_final_battle_pt_04");

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

player_army = gb:get_army(gb:get_player_alliance_num(), 1);
player_reinf = gb:get_army(gb:get_player_alliance_num(), "reinforcements");
enemy_nakai = gb:get_army(gb:get_non_player_alliance_num(), "nakai");
enemy_summoner1 = gb:get_army(gb:get_non_player_alliance_num(), "summoner1");
enemy_summoner2 = gb:get_army(gb:get_non_player_alliance_num(), "summoner2");
enemy_gorrok_reinf = gb:get_army(gb:get_non_player_alliance_num(), "gorrok");

-------------------------------------------------------------------------------------------------
--------------------------------------- CINEMATIC SETUP -----------------------------------------
-------------------------------------------------------------------------------------------------

kalara_is_present = false;
hertwig_is_present = false;

if player_army.sunits:contains_type("wh2_dlc13_emp_cha_hunter_kalara_of_wydrioth_0") then
	kalara_is_present = true;
	intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\wulf.CindySceneManager";
	bm:out("Kalara is present in the player's army, intro_cinematic_file is " .. intro_cinematic_file);
else
	intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\wulf02.CindySceneManager";
	bm:out("Kalara is not present in the player's army, intro_cinematic_file is " .. intro_cinematic_file);
	enemy_nakai:use_army_special_ability_on_message("01_intro_cutscene_end","wh2_dlc13_final_battle_abilities_shield_of_the_old_ones", v(0.0, 220.0, -216.0));
end;

bm:cindy_preload(intro_cinematic_file);

if player_army.sunits:contains_type("wh2_dlc13_emp_cha_hunter_doctor_hertwig_van_hal_0") then
	hertwig_is_present = true;
	bm:out("hertwig is present in the player's army, sending reinforcement message");
	gb:message_on_time_offset("reinforcements_player", 75000, "01_intro_cutscene_end");
else
	bm:out("hertwig is not present in the player's army, doing nothing");
end;
-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
	
	-- teleport units into their desired positions
	battle_start_teleport_units();
	local cam = bm:camera();
		
	-- declare cutscene
	local cutscene_intro = cutscene:new(
		"cutscene_intro", 						-- unique string name for cutscene
		player_army.sunits,					-- unitcontroller over player's army
		58000, 									-- duration of cutscene in ms
		function() intro_cutscene_end() end		-- what to call when cutscene is finished
	);
	
	local player_units_hidden = false;
	
	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
		
	cutscene_intro:set_post_cutscene_fade_time(2.5, 3200);
	
	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()		
			local cam = bm:camera();
			bm:stop_cindy_playback(true);		
			if player_units_hidden then
				player_army:set_enabled(true)
			end;
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	
	cutscene_intro:action(function() bm:cindy_playback(intro_cinematic_file, 0, 0) end, 0);

	cutscene_intro:action(
		function()
			player_units_hidden = false;
			player_army:set_enabled(true) 
		end, 
		200
	);	
	cutscene_intro:action(
		function() 
			player_units_hidden = false;
			player_army:set_enabled(true) 
		end, 
		30000
	);		
	
	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 3000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc13_emp_markus_wulfhart_final_battle_pt_01", "subtitle_with_frame", 0.1) end, 3500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 16500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 17000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc13_emp_markus_wulfhart_final_battle_pt_02", "subtitle_with_frame", 0.1) end, 17500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 33000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 34000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc13_emp_markus_wulfhart_final_battle_pt_03", "subtitle_with_frame", 0.1) end, 34500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 45000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 46500);
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc13_emp_markus_wulfhart_final_battle_pt_04", "subtitle_with_frame", 0.1) end, 47000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 55500);
	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;

-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------

function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");
	
--teleport unit (1) of ga_defender_03 to [450, 20] with an orientation of 45 degrees and a width of 25m
	--enemy_gorrok_reinf.sunits:item(1).uc:teleport_to_location(v(-500, -50), 180, 25);
--	teleport unit (2) of ga_defender_03 to [410, 35] with an orientation of 45 degrees and a width of 25m
	--enemy_gorrok_reinf.sunits:item(2).uc:teleport_to_location(v(-480, -125), 180, 25);
end;

-------------------------------------------------------------------------------------------------
------------------------------------------ ORDERS -------------------------------------------
-------------------------------------------------------------------------------------------------


enemy_nakai:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
enemy_nakai:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

player_army:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
player_army:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

-- gb:message_on_time_offset("explosion", 40000);
-- gb:message_on_time_offset("explosion_end", 42000);
-- gb:message_on_time_offset("force_field_dead", 41000);

enemy_nakai:message_on_alliance_not_active_on_battlefield("player_wins");

gb:message_on_time_offset("spawn1", 120000, "01_intro_cutscene_end");
gb:message_on_time_offset("spawn2", 125000, "01_intro_cutscene_end");
gb:message_on_time_offset("spawn3", 240000, "01_intro_cutscene_end");
gb:message_on_time_offset("spawn4", 245000, "01_intro_cutscene_end");
gb:message_on_time_offset("spawn5", 360000, "01_intro_cutscene_end");
gb:message_on_time_offset("spawn6", 365000, "01_intro_cutscene_end");

--turning off composite scenes
-- gb:block_message_on_message("explosion", "kalara_is_not_here", true);
-- gb:start_terrain_composite_scene_on_message("battle_started", force_field_cs);
-- gb:start_terrain_composite_scene_on_message("kalara_is_here", kalara_cs);
-- gb:stop_terrain_composite_scene_on_message("kalara_is_not_here", kalara_cs);
-- gb:stop_terrain_composite_scene_on_message("01_intro_cutscene_end", kalara_cs);
-- gb:start_terrain_composite_scene_on_message("explosion", explosion_cs);
-- gb:stop_terrain_composite_scene_on_message("explosion_end", explosion_cs);
-- gb:stop_terrain_composite_scene_on_message("01_intro_cutscene_end", force_field_cs);
-- gb:stop_terrain_composite_scene_on_message("force_field_dead", force_field_cs);

--enemy_summoner1:message_on_commander_dead_or_routing("summoner_1_rout");
--enemy_summoner2:message_on_commander_dead_or_routing("summoner_2_rout");
enemy_nakai:message_on_rout_proportion("nakai_defeated", 1);
enemy_nakai:message_on_commander_dead_or_shattered("nakai_dead");

enemy_gorrok_reinf:message_on_rout_proportion("gor_rok_defeated", 1);
enemy_gorrok_reinf:message_on_commander_dead_or_shattered("gor_rok_dead");
--enemy_gorrok_reinf:message_on_proximity_to_enemy("close_to_flank1", 100);

--player_army:message_on_casualties("reinforcements_player", 0.25);

enemy_nakai:message_on_casualties("reinforcements_enemy", 0.25);

enemy_nakai:release_on_message("01_intro_cutscene_end");
enemy_summoner1:defend_on_message("01_intro_cutscene_end", 360, 14, 50); 
enemy_summoner2:defend_on_message("01_intro_cutscene_end", -360, 12, 50); 

enemy_summoner1:message_on_commander_dead_or_shattered("summoner_1_dead");
enemy_summoner1:release_on_message("summoner_1_dead");
enemy_summoner1:release_on_message("summoner_1_dead");
enemy_summoner2:message_on_commander_dead_or_shattered("summoner_2_dead");
enemy_summoner1:release_on_message("spawn5");
enemy_summoner2:release_on_message("spawn6");

gb:block_message_on_message("summoner_1_dead", "spawn1", true);
gb:block_message_on_message("summoner_2_dead", "spawn2", true);
gb:block_message_on_message("summoner_1_dead", "spawn3", true);
gb:block_message_on_message("summoner_2_dead", "spawn4", true);
gb:block_message_on_message("summoner_1_dead", "spawn5", true);
gb:block_message_on_message("summoner_2_dead", "spawn6", true);
gb:block_message_on_message("summoner_1_dead", "spawn3", true);
gb:block_message_on_message("summoner_2_dead", "spawn4", true);
gb:block_message_on_message("summoner_1_dead", "spawn5", true);
gb:block_message_on_message("summoner_2_dead", "spawn6", true);

		enemy_summoner1:use_army_special_ability_on_message("spawn1","wh2_main_army_abilities_feral_cold_ones_qb_scripted", v(370.0, 220.5, 0.0));
		enemy_summoner2:use_army_special_ability_on_message("spawn2","wh2_main_army_abilities_feral_cold_ones_qb_scripted", v(-370.0, 220.5, 0.0));
		enemy_summoner1:use_army_special_ability_on_message("spawn3","wh2_main_army_abilities_stegadon_qb_scripted", v(370.0, 220.5, 0.0));
		enemy_summoner2:use_army_special_ability_on_message("spawn4","wh2_main_army_abilities_stegadon_qb_scripted", v(-370.0, 220.5, 0.0));
		enemy_summoner1:use_army_special_ability_on_message("spawn5","wh2_main_army_abilities_carnosaur_qb_scripted", v(370.0, 220.5, 0.0));
		enemy_summoner2:use_army_special_ability_on_message("spawn6","wh2_main_army_abilities_carnosaur_qb_scripted", v(-370.0, 220.5, 0.0));


enemy_gorrok_reinf:reinforce_on_message("reinforcements_enemy", 10);
enemy_gorrok_reinf:reinforce_on_message("nakai_dead", 10);

enemy_gorrok_reinf:release_on_message("reinforcements_enemy", 20); 
enemy_gorrok_reinf:release_on_message("nakai_dead", 20); 

player_reinf:reinforce_on_message("reinforcements_player", 10);
player_reinf:release_on_message("reinforcements_player", 20); 

gb:message_on_any_message_received("reinforcements_enemy_help", "reinforcements_enemy", "nakai_dead");

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------
gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc13_emp_final_battle_main_objective");
gb:set_locatable_objective_on_message("battle_started", "wh2_dlc13_emp_final_battle_kill_summoner_1", 0, v(261, 256, 2), v(1175, 90, 57), 2);
gb:set_locatable_objective_on_message("battle_started", "wh2_dlc13_emp_final_battle_kill_summoner_2", 0, v(-261, 256, 2), v(-1175, 90, -57), 2);
gb:add_ping_icon_on_message("01_intro_cutscene_end", v(-350, 221, 0), 15, 1900, 12000);
gb:add_ping_icon_on_message("01_intro_cutscene_end", v(360, 221, 0), 15, 1900, 12000);

gb:complete_objective_on_message("summoner_1_dead", "wh2_dlc13_emp_final_battle_kill_summoner_1", 5);
gb:complete_objective_on_message("summoner_2_dead", "wh2_dlc13_emp_final_battle_kill_summoner_2", 5);

gb:set_objective_on_message("reinforcements_enemy", "wh2_dlc13_emp_final_battle_main_objective_2");
gb:set_objective_on_message("nakai_dead", "wh2_dlc13_emp_final_battle_main_objective_2");
gb:complete_objective_on_message("nakai_defeated", "wh2_dlc13_emp_final_battle_main_objective", 5);
gb:complete_objective_on_message("gor_rok_defeated", "wh2_dlc13_emp_final_battle_main_objective_2", 5);
-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------
gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc13_emp_final_battle_info_summoners", 10000, nil, 5000);
gb:queue_help_on_message("reinforcements_player", "wh2_dlc13_emp_final_battle_info_reinf_player", 10000, nil, 5000);
gb:queue_help_on_message("reinforcements_enemy_help", "wh2_dlc13_emp_final_battle_info_reinf_gor_rok", 10000, nil, 5000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------
player_army:message_on_alliance_not_active_on_battlefield("player_all_dead")		-- in case the player did not have the hero to bring in reinforcements, make sure the battle ends if the players army is defeated
enemy_nakai:force_victory_on_message("player_all_dead"); 
player_army:force_victory_on_message("player_wins"); 
--enemy_nakai:rout_over_time_on_message("nakai_dead",15);
--enemy_gorrok_reinf:rout_over_time_on_message("gor_rok_dead",15);
--enemy_summoner1:rout_over_time_on_message("summoner_1_dead",15);
--enemy_summoner2:rout_over_time_on_message("summoner_2_dead",15);