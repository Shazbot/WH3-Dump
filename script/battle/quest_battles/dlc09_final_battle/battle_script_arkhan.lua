 -------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Settra
-- Final Battle
-- Black Pyramid
-- Attacking

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();

-- include shared script 
local file_name, file_path = get_file_name_and_path();
package.path = file_path .. "/?.lua;" .. package.path;

require("battle_script_shared");

bm:camera():fade(true, 0);

gb = generated_battle:new(
	true,                                      		    -- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                      		    -- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
);

--preload stuttering fix
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\tbp_arkhan.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
local sm = get_messager();
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc09_tmb_arkhan_qb_final_battle_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc09_tmb_arkhan_qb_final_battle_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc09_tmb_arkhan_qb_final_battle_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_dlc09_tmb_arkhan_qb_final_battle_04");

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
		ga_player.sunits,					-- unitcontroller over player's army
		45000, 									-- duration of cutscene in ms
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
				ga_player:set_enabled(true)
			end;
						
			bm:callback(function() cam:fade(false, 0.5) end, 500);
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\tbp_arkhan.CindySceneManager", true) end, 200);
	-- cutscene_intro:action(
		-- function()
			-- player_units_hidden = false;
			-- ga_player:set_enabled(true) 
		-- end, 
		-- 200
	-- );	
	-- cutscene_intro:action(
		-- function() 
			-- player_units_hidden = false;
			-- ga_player:set_enabled(true) 
		-- end, 
		-- 25000
	-- );		
	
	-- Voiceover and Subtitles --
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 3000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc09_tmb_arkhan_qb_final_battle_01", "subtitle_with_frame", 0.1)	end, 3000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 9700);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 9800);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc09_tmb_arkhan_qb_final_battle_02", "subtitle_with_frame", 0.1)	end, 9800);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 22400);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 22500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc09_tmb_arkhan_qb_final_battle_03", "subtitle_with_frame", 0.1)	end, 22500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 31500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 31600);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc09_tmb_arkhan_qb_final_battle_04", "subtitle_with_frame", 0.1)	end, 31600);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 42700);
	
	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player = gb:get_army(gb:get_player_alliance_num(), 1);
-- ga_khatep_01 = gb:get_army(gb:get_non_player_alliance_num(), 1);
-- ga_khalida_02 = gb:get_army(gb:get_non_player_alliance_num(), 2);
-- ga_settra_03 = gb:get_army(gb:get_non_player_alliance_num(), 3);
ga_ally_01 = gb:get_army(gb:get_player_alliance_num(), 1, "reinforce_1");
ga_ally_02 = gb:get_army(gb:get_player_alliance_num(), 1, "reinforce_2");
for i = 1, 4, 1 do
	if gb:get_army(gb:get_non_player_alliance_num(), i):get_script_name() == "khalida" then
		ga_khalida_02 = gb:get_army(gb:get_non_player_alliance_num(), i, "khalida");
	elseif gb:get_army(gb:get_non_player_alliance_num(), i):get_script_name() == "khalida_alt" then
		ga_khalida_03 = gb:get_army(gb:get_non_player_alliance_num(), i, "khalida_alt");
	elseif gb:get_army(gb:get_non_player_alliance_num(), i):get_script_name() == "khatep" then
		ga_khatep_01 = gb:get_army(gb:get_non_player_alliance_num(), i);
	elseif gb:get_army(gb:get_non_player_alliance_num(), i):get_script_name() == "settra" then
		ga_settra_03 = gb:get_army(gb:get_non_player_alliance_num(), i);
	end
end;

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

--ga_attacker_01:halt();
ga_khalida_02:reinforce_on_message("casualty_low_khatep",1000 );
ga_khalida_03:reinforce_on_message("casualty_low_khatep",1000 );
ga_ally_01:reinforce_on_message("casualty_low_khatep", 10000);
ga_ally_01:reinforce_on_message("player_doing_badly_0", 10000);
ga_settra_03:reinforce_on_message("casualty_high_all", 1000);
ga_ally_02:reinforce_on_message("casualty_high_all", 10000);
ga_ally_02:reinforce_on_message("player_doing_badly_1", 10000);
ga_player:message_on_casualties("player_doing_badly_0", 0.9);
ga_ally_01:message_on_casualties("player_doing_badly_1", 0.9);
ga_ally_01:message_on_any_deployed("reinforcements_arrived_0");
ga_ally_02:message_on_any_deployed("reinforcements_arrived_1");



ga_khalida_02:set_formation_on_message("casualty_low_khatep", "generic_ranged_protected");
ga_khalida_03:set_formation_on_message("casualty_low_khatep", "generic_ranged_protected");
ga_khatep_01:set_formation_on_message("deployment_started", "generic_directfire_attack");
ga_settra_03:set_formation_on_message("deployment_started", "generic_directfire_attack");

ga_khalida_02:message_on_proximity_to_enemy("I_release_you_from_duty_khalida_02", 40);
ga_khalida_02:release_on_message("I_release_you_from_duty_khalida_02");
ga_khalida_03:message_on_proximity_to_enemy("I_release_you_from_duty_khalida_03", 40);
ga_khalida_03:release_on_message("I_release_you_from_duty_khalida_03");
ga_khatep_01:message_on_proximity_to_enemy("I_release_you_from_duty_khatep_01", 40);
ga_khatep_01:release_on_message("I_release_you_from_duty_khatep_01");
ga_settra_03:message_on_proximity_to_enemy("I_release_you_from_duty_settra_03", 40);
ga_settra_03:release_on_message("I_release_you_from_duty_settra_03");

ga_khatep_01:attack_on_message("deployment_started"); 
ga_khalida_02:attack_on_message("casualty_low_khatep");
ga_khalida_03:attack_on_message("casualty_low_khatep");
--ga_khalida_02:defend_on_message("casualty_low_khatep_01", 52, 650, 10); 
ga_settra_03:attack_on_message("casualty_high_all"); 

ga_khatep_01:message_on_casualties("casualty_low_khatep", 0.3);
ga_khalida_02:message_on_casualties("casualty_high_0", 0.4);
ga_khalida_03:message_on_casualties("casualty_high_1", 0.4);
gb:message_on_all_messages_received("casualty_high_all", "casualty_high_0", "casualty_high_1");
-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------
  
gb:set_objective_on_message("deployment_started", "wh2_dlc09_tmb_qb_final_battle_objective_defeat_enemies");

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc09_tmb_qb_final_battle_hint_defeat_khatep",10000,1000);
gb:queue_help_on_message("casualty_low_khatep", "wh2_dlc09_tmb_qb_final_battle_hint_defeat_khalida",10000,1000);
gb:queue_help_on_message("reinforcements_arrived_0", "wh2_dlc09_tmb_qb_final_battle_hint_reinforcement_1",10000,1000,10000);
gb:queue_help_on_message("casualty_high_all", "wh2_dlc09_tmb_qb_final_battle_hint_defeat_settra",10000,1000);
gb:queue_help_on_message("reinforcements_arrived_1", "wh2_dlc09_tmb_qb_final_battle_hint_reinforcement_2",10000,11000);



-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY ----------------------------------------------
-------------------------------------------------------------------------------------------------

