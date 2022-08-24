-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Cylostra Direfin
-- The Bordeleux Flabellum - High Elf
-- Shifting Isles
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
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\cbb.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc11_cylosta_direfin_qb_bordeleaux_flabellum_alt_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc11_cylosta_direfin_qb_bordeleaux_flabellum_alt_pt_02");

-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
	
	-- teleport units into their desired positions
	--battle_start_teleport_units();
	--bm:modify_battle_speed(0);
	
	local cam = bm:camera();
	
	-- declare cutscene
	local cutscene_intro = cutscene:new(
		"cutscene_intro", 						-- unique string name for cutscene
		ga_attacker_01.sunits,					-- unitcontroller over player's army
		30000, 									-- duration of cutscene in ms
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
				ga_attacker_01:set_enabled(true)
			end;
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\cbb.CindySceneManager", true) end, 200);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_attacker_01:set_enabled(true) 
		end, 
		200
	);		
	
	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 3000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc11_CylostaDirefin_QB_Bordeleaux_Flabellum_alt_pt_01", "subtitle_with_frame", 14) end, 3500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 17500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 18000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc11_CylostaDirefin_QB_Bordeleaux_Flabellum_alt_pt_02", "subtitle_with_frame", 8) end, 18500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 28000);
	
	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_attacker_01 = gb:get_army(gb:get_player_alliance_num(), 1);
ga_defender_01 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army");
ga_reinforcement = gb:get_army(gb:get_non_player_alliance_num(), "reinforcements");
--ga_gate_second = gb:get_army(gb:get_non_player_alliance_num(), 2,"enemy_second");
--ga_gate_third = gb:get_army(gb:get_non_player_alliance_num(), 2,"enemy_third");
--ga_gate_fourth = gb:get_army(gb:get_non_player_alliance_num(), 2,"enemy_fourth");
--ga_gate_fifth = gb:get_army(gb:get_non_player_alliance_num(), 2,"enemy_fifth");


-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------


ga_attacker_01:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_attacker_01:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
ga_defender_01:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_defender_01:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

ga_defender_01:attack_on_message("01_intro_cutscene_end", 5000);

ga_defender_01:message_on_casualties("reinforcements", 0.55);
ga_reinforcement:reinforce_on_message("reinforcements", 100);
ga_reinforcement:release_on_message("reinforcements"); 


if ga_defender_01.sunits:is_in_melee() then
	ga_defender_01.sunits:release_control();
end;



-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------
objective = "wh2_dlc11_qb_cylostra_battle_main_objective_high_elf";

gb:set_objective_on_message("01_intro_cutscene_end", objective);

gb:complete_objective_on_message("defenders_defeated", objective);
--gb:set_locatable_objective_on_message("01_intro_cutscene_end", "wh2_main_qb_def_morathi_heartrender_and_the_darksword_stage_6_arnheim_hints_main_objective", 100, v(173, 356, 39), v(142, 364, 70), 2);    
--gb:add_ping_icon_on_message("01_intro_cutscene_end", v(56, 349, 201), 15, 100, 5000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------
gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc11_qb_cylostra_battle_hint_objective_high_elf", 6000, nil, 5000);
gb:queue_help_on_message("reinforcements", "wh2_dlc11_qb_cylostra_battle_hint_reinforcement_high_elf", 10000, nil, 5000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------
