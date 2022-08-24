-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Nakai
-- Final Battle
-- INSERT ENVIRONMENT NAME
-- Defender

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
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\nak.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc13_lzd_nakai_final_battle_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc13_lzd_nakai_final_battle_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc13_lzd_nakai_final_battle_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_dlc13_lzd_nakai_final_battle_pt_04");
wh2_main_sfx_05 = new_sfx("Play_wh2_dlc13_lzd_nakai_final_battle_pt_05");

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
		48000, 									-- duration of cutscene in ms
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

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\nak.CindySceneManager", true) end, 200);
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
		48000
	);		
	
	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 3000);		
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 4500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 8000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc13_lzd_nakai_final_battle_pt_02", "subtitle_with_frame", 0.5, true) end, 8250);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 12500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 16000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc13_lzd_nakai_final_battle_pt_03", "subtitle_with_frame", 0.5, true) end, 16250);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 19500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 26000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc13_lzd_nakai_final_battle_pt_04", "subtitle_with_frame", 0.5, true) end, 26250);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 29750);

	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_05) end, 35250);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc13_lzd_nakai_final_battle_pt_05", "subtitle_with_frame", 0.5, true) end, 35500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 40500);

	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

player_army = gb:get_army(gb:get_player_alliance_num(), 1);
player_reinf = gb:get_army(gb:get_player_alliance_num(), "gorrok");
enemy_wulfhart = gb:get_army(gb:get_non_player_alliance_num(), "wulfhart");
summoner1 = gb:get_army(gb:get_player_alliance_num(), "summoner1");
summoner2 = gb:get_army(gb:get_player_alliance_num(), "summoner2");
enemy_reinf = gb:get_army(gb:get_non_player_alliance_num(), "reinforcements");
emp_harass_1 = gb:get_army(gb:get_non_player_alliance_num(), "emp_harass_1");
emp_harass_2 = gb:get_army(gb:get_non_player_alliance_num(), "emp_harass_2");

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
enemy_wulfhart:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
enemy_wulfhart:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

player_army:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
player_army:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

gb:message_on_time_offset("action1", 40000);
gb:message_on_time_offset("spawn1", 100000);
gb:message_on_time_offset("spawn2", 105000);
gb:message_on_time_offset("spawn3", 220000);
gb:message_on_time_offset("spawn4", 225000);
gb:message_on_time_offset("spawn5", 340000);
gb:message_on_time_offset("spawn6", 345000);

gb:message_on_time_offset("reinforcements_harass_1", 50000);
gb:message_on_time_offset("harass_1_order", 61000);
gb:message_on_time_offset("reinforcements_harass_2", 60000);
gb:message_on_time_offset("harass_2_order", 71000);
gb:message_on_time_offset("reinforcements_enemy", 180000);

enemy_wulfhart:message_on_alliance_not_active_on_battlefield("player_wins");

summoner1:message_on_commander_dead_or_routing("summoner_1_rout", 1);
summoner2:message_on_commander_dead_or_routing("summoner_2_rout", 1);
summoner1:message_on_casualties("release_harass_1", 0.7);
summoner2:message_on_casualties("release_harass_2", 0.7);
--enemy_gorrok_reinf:message_on_proximity_to_enemy("close_to_flank1", 100);
player_army:message_on_casualties("reinforcements_player", 0.30);

summoner1:defend_on_message("01_intro_cutscene_end", 360, 14, 50); 
summoner2:defend_on_message("01_intro_cutscene_end", -360, 12, 50); 
summoner1:release_on_message("spawn5", 5); 
summoner1:release_on_message("summoner_1_rout", 5); 
summoner2:release_on_message("spawn6", 5); 
summoner2:release_on_message("summoner_2_rout", 5); 

enemy_wulfhart:release_on_message("action1");

gb:block_message_on_message("summoner_1_rout", "spawn3", true);
gb:block_message_on_message("summoner_2_rout", "spawn4", true);
gb:block_message_on_message("summoner_1_rout", "spawn5", true);
gb:block_message_on_message("summoner_2_rout", "spawn5", true);

		summoner1:use_army_special_ability_on_message("spawn1","wh2_main_army_abilities_feral_cold_ones_qb_scripted", v(370.0, 220.5, 0.0));
		summoner2:use_army_special_ability_on_message("spawn2","wh2_main_army_abilities_feral_cold_ones_qb_scripted", v(-370.0, 220.5, 0.0));
		summoner1:use_army_special_ability_on_message("spawn3","wh2_main_army_abilities_stegadon_qb_scripted", v(370.0, 220.5, 0.0));
		summoner2:use_army_special_ability_on_message("spawn4","wh2_main_army_abilities_stegadon_qb_scripted", v(-370.0, 220.5, 0.0));
		summoner1:use_army_special_ability_on_message("spawn5","wh2_main_army_abilities_carnosaur_qb_scripted", v(370.0, 220.5, 0.0));
		summoner2:use_army_special_ability_on_message("spawn6","wh2_main_army_abilities_carnosaur_qb_scripted", v(-370.0, 220.5, 0.0));

emp_harass_1:reinforce_on_message("reinforcements_harass_1", 10);
emp_harass_1:defend_on_message("harass_1_order", 360, 14, 50);
emp_harass_1:release_on_message("release_harass_1", 5); 

emp_harass_2:reinforce_on_message("reinforcements_harass_2", 10);
emp_harass_2:defend_on_message("harass_2_order", -360, 12, 50);
emp_harass_1:release_on_message("release_harass_2", 5); 

enemy_reinf:reinforce_on_message("reinforcements_enemy", 10);
enemy_reinf:release_on_message("reinforcements_enemy", 20); 

player_reinf:reinforce_on_message("reinforcements_player", 10);
player_reinf:release_on_message("reinforcements_player", 20); 

emp_harass_1:release_on_message("reinforcements_player", 25); 
emp_harass_2:release_on_message("reinforcements_player", 28); 
-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc13_lzd_final_battle_main_objective");
gb:set_locatable_objective_on_message("battle_started", "wh2_dlc13_lzd_final_battle_protect_summoner_1", 0, v(261, 256, 2), v(1175, 90, 57), 2);
gb:set_locatable_objective_on_message("battle_started", "wh2_dlc13_lzd_final_battle_protect_summoner_2", 0, v(-261, 256, 2), v(-1175, 90, -57), 2);
gb:add_ping_icon_on_message("01_intro_cutscene_end", v(-350, 221, 0), 15, 1900, 12000);
gb:add_ping_icon_on_message("01_intro_cutscene_end", v(360, 221, 0), 15, 1900, 12000);

gb:fail_objective_on_message("summoner_1_rout", "wh2_dlc13_lzd_final_battle_protect_summoner_1", 5);
gb:fail_objective_on_message("summoner_2_rout", "wh2_dlc13_lzd_final_battle_protect_summoner_2", 5);
	

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc13_lzd_final_battle_info_summoners", 10000, nil, 5000);
gb:queue_help_on_message("reinforcements_harass_1", "wh2_dlc13_lzd_final_battle_info_harass", 10000, nil, 5000);
gb:queue_help_on_message("reinforcements_enemy", "wh2_dlc13_lzd_final_battle_info_reinf_enemy", 10000, nil, 5000);
gb:queue_help_on_message("reinforcements_player", "wh2_dlc13_lzd_final_battle_info_reinf_gor_rok", 10000, nil, 5000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------
player_army:force_victory_on_message("player_wins", 10000); 
