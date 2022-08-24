-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Repanse
-- Defend or Conquer: Guardian
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
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\gol.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc14_Repanse_de_Lyonese_final_battle_guardian_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc14_Repanse_de_Lyonese_final_battle_guardian_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc14_Repanse_de_Lyonese_final_battle_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_dlc14_Repanse_de_Lyonese_final_battle_pt_04");
wh2_main_sfx_05 = new_sfx("Play_wh2_dlc14_Repanse_de_Lyonese_final_battle_pt_05");

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_attacker_01 = gb:get_army(gb:get_player_alliance_num(), 1);
ga_ai_ally_peasants = gb:get_army(gb:get_player_alliance_num(), "peasants");
ga_ai_ally_knights = gb:get_army(gb:get_player_alliance_num(), "knights_of_the_realm");

ga_ai_vampirates_1 = gb:get_army(gb:get_non_player_alliance_num(), "vampirates_1");
ga_ai_vampirates_2 = gb:get_army(gb:get_non_player_alliance_num(), "vampirates_2");
ga_ai_vampirates_3 = gb:get_army(gb:get_non_player_alliance_num(), "vampirates_3");
ga_ai_vampirates_4 = gb:get_army(gb:get_non_player_alliance_num(), "vampirates_4");

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
		52000, 									-- duration of cutscene in ms
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

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\gol.CindySceneManager", 0, 2) end, 520);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_attacker_01:set_enabled(true) 
		end, 
		520
	);	
	
	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc14_Repanse_de_Lyonese_final_battle_guardian_pt_01", "subtitle_with_frame", 4, true) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 15000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 15500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc14_Repanse_de_Lyonese_final_battle_guardian_pt_02", "subtitle_with_frame", 4, true) end, 15500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 29000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 29500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc14_Repanse_de_Lyonese_final_battle_pt_03", "subtitle_with_frame", 4, true) end, 29500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 38000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 39000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc14_Repanse_de_Lyonese_final_battle_pt_04", "subtitle_with_frame", 4, true) end, 39000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 48000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_05) end, 48500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc14_Repanse_de_Lyonese_final_battle_pt_05", "subtitle_with_frame", 2, true) end, 48500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 52000);

	cutscene_intro:start();
	
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc14_qb_brt_repanse_defend_or_conquer_guardian_01", 6000, nil, 8000);
gb:queue_help_on_message("vampirates_2_advance", "wh2_dlc14_qb_brt_repanse_defend_or_conquer_guardian_02", 6000, nil, 8000);
gb:queue_help_on_message("vampirates_2_hurt", "wh2_dlc14_qb_brt_repanse_defend_or_conquer_guardian_03", 6000, nil, 8000);
gb:queue_help_on_message("knights_advance", "wh2_dlc14_qb_brt_repanse_defend_or_conquer_guardian_04", 6000, nil, 8000);
gb:queue_help_on_message("vampirates_4_appears", "wh2_dlc14_qb_brt_repanse_defend_or_conquer_guardian_05", 6000, nil, 8000);


-------------------------------------------------------------------------------------------------
------------------------------------------ ORDERS -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_ai_ally_peasants:attack_on_message("battle_started");
ga_ai_ally_peasants:message_on_proximity_to_enemy("peasants_attack",20);
ga_ai_ally_peasants:release_on_message("peasants_attack");
ga_ai_vampirates_1:defend_on_message("battle_started", 79, -62, 60);
ga_ai_vampirates_1:message_on_proximity_to_enemy("bret_approach",130);
ga_ai_vampirates_1:release_on_message("bret_approach");

ga_ai_vampirates_1:message_on_casualties("vampirates_1_hurt",0.35);
ga_ai_vampirates_2:reinforce_on_message("vampirates_1_hurt",15000);
ga_ai_vampirates_2:message_on_any_deployed("vampirates_2_advance");
ga_ai_vampirates_2:message_on_casualties("vampirates_2_hurt",0.2);
ga_ai_vampirates_2:release_on_message("vampirates_1_hurt",25000);

ga_ai_vampirates_3:reinforce_on_message("vampirates_2_hurt",10000);
ga_ai_vampirates_3:release_on_message("vampirates_2_hurt",20000);

ga_attacker_01:message_on_casualties("player_hurt",0.5)
ga_ai_ally_knights:reinforce_on_message("player_hurt",1000);
ga_ai_ally_knights:reinforce_on_message("vampirates_2_hurt",120000);
ga_ai_ally_knights:message_on_any_deployed("knights_advance");
ga_ai_ally_knights:release_on_message("knights_advance", 10000);
ga_ai_ally_knights:release_on_message("vampirates_2_hurt", 130000);

ga_ai_vampirates_3:message_on_casualties("vampirates_3_hurt",0.5);
ga_ai_vampirates_4:reinforce_on_message("vampirates_3_hurt",15000);
ga_ai_vampirates_4:reinforce_on_message("knights_advance",120000);
ga_ai_vampirates_4:message_on_any_deployed("vampirates_4_appears");
ga_ai_vampirates_4:release_on_message("knights_advance", 135000);
ga_ai_vampirates_4:release_on_message("vampirates_3_hurt", 25000);