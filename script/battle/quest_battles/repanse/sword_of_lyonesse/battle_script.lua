-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Repanse
-- Sword of Lyonesse
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
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\42_rep_r02.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("PLAY_wh2_dlc14_Repanse_Sword_of_Lyonesse_pt_01");
wh2_main_sfx_02 = new_sfx("PLAY_wh2_dlc14_Repanse_Sword_of_Lyonesse_pt_02");
wh2_main_sfx_03 = new_sfx("PLAY_wh2_dlc14_Repanse_Sword_of_Lyonesse_pt_03");
wh2_main_sfx_04 = new_sfx("PLAY_wh2_dlc14_Repanse_Sword_of_Lyonesse_pt_04");

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_attacker_01 = gb:get_army(gb:get_player_alliance_num(), 1);
ga_dwarf_1 = gb:get_army(gb:get_player_alliance_num(), "dwarf_1");
ga_dwarf_2 = gb:get_army(gb:get_player_alliance_num(), "dwarf_2");
ga_dwarf_3 = gb:get_army(gb:get_player_alliance_num(), "dwarf_3");
ga_tombk_1 = gb:get_army(gb:get_non_player_alliance_num(),"tombk_1");
ga_tombk_2 = gb:get_army(gb:get_non_player_alliance_num(),"tombk_2");
ga_tombk_3 = gb:get_army(gb:get_non_player_alliance_num(),"tombk_3");
ga_tombk_4_reinforce = gb:get_army(gb:get_non_player_alliance_num(),"tombk_4_reinforce");


-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------

function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");
	
	--ga_scorpion.sunits:item(1).uc:teleport_to_location(v(372, 33), 50, 25);

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
		45000, 									-- duration of cutscene in ms
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
				ga_attacker_01:set_enabled(true)
			end;
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\42_rep_r02.CindySceneManager", 0, 2) end, 200);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_attacker_01:set_enabled(true) 
		end, 
		200
	);	
	
	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc14_Repanse_Sword_of_Lyonesse_pt_01", "subtitle_with_frame", 0.1, true) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 11800);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 12500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc14_Repanse_Sword_of_Lyonesse_pt_02", "subtitle_with_frame", 0.1, true) end, 12500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 21600);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 22100);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc14_Repanse_Sword_of_Lyonesse_pt_03", "subtitle_with_frame", 0.1, true) end, 22100);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 33000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 33500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc14_Repanse_Sword_of_Lyonesse_pt_04", "subtitle_with_frame", 0.1, true) end, 33500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 43100);
	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 45000);

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

gb:message_on_time_offset("reinforce", 240000,"01_intro_cutscene_end");	--might be a little quick tbd
--gb:message_on_time_offset("scorpion_ambush", 240000,"01_intro_cutscene_end");

ga_tombk_1:message_on_casualties("tombk_1_dying", 0.6);
--ga_tombk_1:message_on_commander_dead_or_routing("tombk_1_dead", 1);
ga_tombk_2:message_on_casualties("tombk_2_dying", 0.6);
ga_tombk_3:message_on_casualties("tombk_3_dying", 0.6);

ga_dwarf_1:message_on_casualties("dwarf_1_dying", 0.5);
ga_dwarf_2:message_on_casualties("dwarf_2_dying", 0.5);
ga_dwarf_3:message_on_casualties("dwarf_3_dying", 0.5);

ga_dwarf_1:message_on_shattered_proportion("dwarf_1_dead", 1);
ga_dwarf_2:message_on_shattered_proportion("dwarf_2_dead", 1);
ga_dwarf_3:message_on_shattered_proportion("dwarf_3_dead", 1);
ga_attacker_01:message_on_shattered_proportion("player_dead", 1);

--start the fighting
ga_dwarf_1:release_on_message("battle_started");
ga_dwarf_2:release_on_message("battle_started");
ga_dwarf_3:release_on_message("battle_started");
ga_tombk_1:release_on_message("battle_started");
ga_tombk_2:release_on_message("battle_started");
ga_tombk_3:release_on_message("battle_started");


gb:message_on_time_offset("reinforcement_release", 8000,"reinforce");
gb:message_on_time_offset("reinforcement_release_1", 8000,"tombk_1_dying");
gb:message_on_time_offset("reinforcement_release_2", 8000,"tombk_2_dying");
gb:message_on_time_offset("reinforcement_release_3", 8000,"tombk_3_dying");
ga_tombk_4_reinforce:reinforce_on_message("reinforce", 10);
--ga_tombk_4_reinforce:reinforce_on_message("tombk_1_dying" and "tombk_2_dying" or "tombk_3_dying", 10);	--this probably doesn't work, intent is to have reinforcements trigger when any 2 out of the 3 armies are dying
ga_tombk_4_reinforce:reinforce_on_message("tombk_1_dying", 10);
ga_tombk_4_reinforce:reinforce_on_message("tombk_2_dying", 10);
ga_tombk_4_reinforce:reinforce_on_message("tombk_3_dying", 10);
ga_tombk_4_reinforce:release_on_message("reinforcement_release");
ga_tombk_4_reinforce:release_on_message("reinforcement_release_1");
ga_tombk_4_reinforce:release_on_message("reinforcement_release_2");
ga_tombk_4_reinforce:release_on_message("reinforcement_release_3");

ga_tombk_4_reinforce:message_on_alliance_not_active_on_battlefield("tombk_reinforcements_dead", 1);

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc14_qb_brt_repanse_sword_of_lyonesse_objective_01");
gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc14_qb_brt_repanse_sword_of_lyonesse_objective_02");
gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc14_qb_brt_repanse_sword_of_lyonesse_objective_03");
gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc14_qb_brt_repanse_sword_of_lyonesse_objective_04");
gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc14_qb_brt_repanse_sword_of_lyonesse_objective_05");

gb:complete_objective_on_message("tombk_reinforcements_dead", "wh2_dlc14_qb_brt_repanse_sword_of_lyonesse_objective_01", 5);
gb:complete_objective_on_message("tombk_reinforcements_dead", "wh2_dlc14_qb_brt_repanse_sword_of_lyonesse_objective_02", 5);
gb:complete_objective_on_message("tombk_reinforcements_dead", "wh2_dlc14_qb_brt_repanse_sword_of_lyonesse_objective_03", 5);
gb:complete_objective_on_message("tombk_reinforcements_dead", "wh2_dlc14_qb_brt_repanse_sword_of_lyonesse_objective_04", 5);
gb:complete_objective_on_message("tombk_reinforcements_dead", "wh2_dlc14_qb_brt_repanse_sword_of_lyonesse_objective_05", 5);

gb:fail_objective_on_message("dwarf_1_dead", "wh2_dlc14_qb_brt_repanse_sword_of_lyonesse_objective_02", 5);
gb:fail_objective_on_message("dwarf_2_dead", "wh2_dlc14_qb_brt_repanse_sword_of_lyonesse_objective_03", 5);
gb:fail_objective_on_message("dwarf_3_dead", "wh2_dlc14_qb_brt_repanse_sword_of_lyonesse_objective_04", 5);
gb:fail_objective_on_message("player_dead", "wh2_dlc14_qb_brt_repanse_sword_of_lyonesse_objective_05", 5);

ga_tombk_4_reinforce:force_victory_on_message("player_dead", 10000); 
ga_tombk_4_reinforce:force_victory_on_message("dwarf_3_dead", 15000); 
ga_tombk_4_reinforce:force_victory_on_message("dwarf_2_dead", 15000); 
ga_tombk_4_reinforce:force_victory_on_message("dwarf_1_dead", 15000); 

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------
gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc14_qb_brt_repanse_sword_of_lyonesse_help_01", 6000, nil, 5000);
gb:queue_help_on_message("dwarf_1_dying", "wh2_dlc14_qb_brt_repanse_sword_of_lyonesse_help_02", 6000, nil, 5000);
gb:queue_help_on_message("dwarf_2_dying", "wh2_dlc14_qb_brt_repanse_sword_of_lyonesse_help_03", 6000, nil, 5000);
gb:queue_help_on_message("dwarf_3_dying", "wh2_dlc14_qb_brt_repanse_sword_of_lyonesse_help_04", 6000, nil, 5000);

gb:queue_help_on_message("dwarf_1_dead", "wh2_dlc14_qb_brt_repanse_sword_of_lyonesse_help_fail_02", 6000, nil, 5000);
gb:queue_help_on_message("dwarf_2_dead", "wh2_dlc14_qb_brt_repanse_sword_of_lyonesse_help_fail_03", 6000, nil, 5000);
gb:queue_help_on_message("dwarf_3_dead", "wh2_dlc14_qb_brt_repanse_sword_of_lyonesse_help_fail_04", 6000, nil, 5000);
gb:queue_help_on_message("player_dead", "wh2_dlc14_qb_brt_repanse_sword_of_lyonesse_help_fail_05", 6000, nil, 5000);
-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------