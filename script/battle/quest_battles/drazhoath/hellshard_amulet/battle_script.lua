-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Drazhoath
-- Hellshard Amulet
-- Haunted Forest
-- Defender

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------
load_script_libraries();

bm:camera():fade(true, 0);

gb = generated_battle:new(
	true,                                      		-- screen starts black
	true,                                      		-- prevent deployment for player
	true,                                      		-- prevent deployment for ai
	function() end_deployment_phase() end,          -- intro cutscene function
	false                                      		-- debug mode
);

gb:set_cutscene_during_deployment(true);

--preload stuttering fix
-- intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/chd_qb_drazhoath_m01.CindySceneManager";
-- bm:cindy_preload(intro_cinematic_file);

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------
--Player Army
ga_player = gb:get_army(gb:get_player_alliance_num());

--Enemy Armies
ga_enemy_vampires = gb:get_army(gb:get_non_player_alliance_num(), "enemy_vampires");
ga_enemy_tomb_kings = gb:get_army(gb:get_non_player_alliance_num(), "enemy_tomb_kings");
ga_enemy_vampire_02 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_vampires_02");
ga_enemy_tomb_kings_02 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_tomb_kings_02");

-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------
function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");

----------------------------------- Player Deployment Setup ------------------------------------
--Valkia
ga_player.sunits:item(1).uc:teleport_to_location(v(115, 347), 180, 5);

end;

battle_start_teleport_units();	
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------
wh3_intro_sfx_00 = new_sfx("Play_Movie_WH3_DLC23_QB_Drazhoath_Hellshard_Amulet_Sweetener");

wh3_main_sfx_01 = new_sfx("play_wh3_dlc23_qb_chd_drazhoath_hellshard_amulet_01");
wh3_main_sfx_02 = new_sfx("play_wh3_dlc23_qb_chd_drazhoath_hellshard_amulet_02");
wh3_main_sfx_03 = new_sfx("play_wh3_dlc23_qb_chd_drazhoath_hellshard_amulet_03");



-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------
function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
		
	local cam = bm:camera();
	
	-- REMOVE ME
	cam:fade(true, 0);
	
	-- declare cutscene
	local cutscene_intro = cutscene:new_from_cindyscene(
		"cutscene_intro", 																-- unique string name for cutscene
		ga_player.sunits,																-- unitcontroller over player's army
		function() intro_cutscene_end() end,											-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/chd_qb_drazhoath_m01.CindySceneManager",			-- path to cindyscene
		0,																				-- blend in time (s)
		0																				-- blend out time (s)
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
				ga_player:set_enabled(false)
			end;
						
			bm:callback(function() cam:fade(false, 0.5) end, 500);
			bm:hide_subtitles();
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);

	cutscene_intro:action(
		function()
			player_units_hidden = false;
		end, 
		200
	);	

	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh3_intro_sfx_00) end, 100);
	
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc23_qb_chd_drazhoath_hellshard_amulet_01", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc23_qb_chd_drazhoath_hellshard_amulet_01"));
				bm:show_subtitle("wh3_dlc23_chd_drazhoath_hellshard_amulet_pt_01", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc23_qb_chd_drazhoath_hellshard_amulet_02", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc23_qb_chd_drazhoath_hellshard_amulet_02"));
				bm:show_subtitle("wh3_dlc23_chd_drazhoath_hellshard_amulet_pt_02", false, true);
			end
	);

	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_dlc23_qb_chd_drazhoath_hellshard_amulet_03", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_dlc23_qb_chd_drazhoath_hellshard_amulet_03"));
				bm:show_subtitle("wh3_dlc23_chd_drazhoath_hellshard_amulet_pt_03", false, true);
			end
	);

	cutscene_intro:start();
	gb.sm:trigger_message("cutscene_intro_start")
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------
-- 1st enemy wave setup
ga_enemy_vampires:set_visible_to_all(true);
ga_enemy_vampires:attack();

--enemy_main receives casualties trigger ga_enemy_tomb_kings message
ga_enemy_vampires:message_on_casualties("enemy_reinforcements_tmb_1_casualties", 0.6);

--5 minute ga_enemy_tomb_kings countdown starts following battle_started
gb:message_on_time_offset("enemy_reinforcements_tmb_1_countdown", 200000, "battle_started");

--ga_enemy_tomb_kings enter battlefield
ga_enemy_tomb_kings:reinforce_on_message("enemy_reinforcements_tmb_1_casualties", 10);
ga_enemy_tomb_kings:reinforce_on_message("enemy_reinforcements_tmb_1_countdown", 10);
ga_enemy_tomb_kings:release_on_message("enemy_reinforcements_tmb_1_casualties", 2000);
ga_enemy_tomb_kings:release_on_message("enemy_reinforcements_tmb_1_countdown", 2000);

--if reinforcement message heard, block other reinforcement message
gb:block_message_on_message("enemy_reinforcements_tmb_1_countdown", "enemy_reinforcements_tmb_1_casualties", true);
gb:block_message_on_message("enemy_reinforcements_tmb_1_casualties", "enemy_reinforcements_tmb_1_countdown", true);
gb:message_on_any_message_received("wave_1_released", "enemy_reinforcements_tmb_1_casualties", "enemy_reinforcements_tmb_1_countdown");

--enemy_main receives casualties trigger ga_enemy_tomb_kings message
ga_enemy_tomb_kings:message_on_casualties("enemy_reinforcements_final_wave_casualties", 0.6);

--5 minute ga_enemy_tomb_kings countdown starts following battle_started
gb:message_on_time_offset("enemy_reinforcements_final_countdown", 500000, "battle_started");

--ga_enemy_tomb_kings enter battlefield
ga_enemy_vampire_02:reinforce_on_message("enemy_reinforcements_final_wave_casualties", 10);
ga_enemy_vampire_02:reinforce_on_message("enemy_reinforcements_final_countdown", 10);
ga_enemy_vampire_02:release_on_message("enemy_reinforcements_final_wave_casualties", 2000);
ga_enemy_vampire_02:release_on_message("enemy_reinforcements_final_countdown", 2000);
ga_enemy_tomb_kings_02:reinforce_on_message("enemy_reinforcements_final_wave_casualties", 10);
ga_enemy_tomb_kings_02:reinforce_on_message("enemy_reinforcements_final_countdown", 10);
ga_enemy_tomb_kings_02:release_on_message("enemy_reinforcements_final_wave_casualties", 2000);
ga_enemy_tomb_kings_02:release_on_message("enemy_reinforcements_final_countdown", 2000);

--if reinforcement message heard, block other reinforcement message
gb:block_message_on_message("enemy_reinforcements_final_countdown", "enemy_reinforcements_final_wave_casualties", true);
gb:block_message_on_message("enemy_reinforcements_final_wave_casualties", "enemy_reinforcements_final_countdown", true);
gb:message_on_any_message_received("wave_2_released", "enemy_reinforcements_final_wave_casualties", "enemy_reinforcements_final_countdown");


------------------------------------------------------------------------
------------------------ PLAYER FORCE DEFEATED -------------------------
------------------------------------------------------------------------
ga_player:message_on_rout_proportion("player_defeated", 1);

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_on_message("battle_started", "wh3_dlc23_chd_hellshard_amulet_01");

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("battle_started", "wh3_dlc23_chd_hellshard_amulet_02", 7000, 2000, 0);
gb:queue_help_on_message("wave_1_released", "wh3_dlc23_chd_hellshard_amulet_03", 7000, 2000, 4000);
gb:queue_help_on_message("wave_2_released", "wh3_dlc23_chd_hellshard_amulet_04", 7000, 2000, 0);

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY ----------------------------------------------
-------------------------------------------------------------------------------------------------
ga_enemy_vampire_02:force_victory_on_message("player_defeated", 5000);

