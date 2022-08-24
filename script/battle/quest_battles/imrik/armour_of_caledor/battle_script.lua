-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Imrik
-- Armour of Caledor
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
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\imr_m01.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc15_HEF_Imrik_Armour_of_Caledor_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc15_HEF_Imrik_Armour_of_Caledor_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc15_HEF_Imrik_Armour_of_Caledor_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_dlc15_HEF_Imrik_Armour_of_Caledor_pt_04");

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player = gb:get_army(gb:get_player_alliance_num(), 1, "");
ga_enemy_blood_dragons = gb:get_army(gb:get_non_player_alliance_num(),"blood_dragons");
ga_enemy_dark_elves = gb:get_army(gb:get_non_player_alliance_num(),"dark_elves");
ga_enemy_zombie_pirates = gb:get_army(gb:get_non_player_alliance_num(),"zombie_pirates");

ga_enemy_blood_dragons:set_visible_to_all(true);
ga_enemy_dark_elves:set_visible_to_all(true);
ga_enemy_zombie_pirates:set_visible_to_all(true);
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
        ga_player.sunits,					-- unitcontroller over player's army
		62000, 									-- duration of cutscene in ms
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
			bm:stop_cindy_playback(true);
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\imr_m01.CindySceneManager", true) end, 200);
	
	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc15_HEF_Imrik_Armour_of_Caledor_pt_01", "subtitle_with_frame", 13, true) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 16500);

	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 17000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc15_HEF_Imrik_Armour_of_Caledor_pt_02", "subtitle_with_frame", 14, true) end, 17000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 33000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 34000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc15_HEF_Imrik_Armour_of_Caledor_pt_03", "subtitle_with_frame", 13, true) end, 34000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 48000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 49000);
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc15_HEF_Imrik_Armour_of_Caledor_pt_04", "subtitle_with_frame", 12, true) end, 49000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 62000);

	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;


-------------------------------------------------------------------------------------------------
------------------------------------------ ORDERS -------------------------------------------
-------------------------------------------------------------------------------------------------

--Stopping armies from firing until the cutscene is done
ga_player:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_player:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

ga_enemy_blood_dragons:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_enemy_blood_dragons:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

ga_enemy_dark_elves:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_enemy_dark_elves:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

ga_enemy_zombie_pirates:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_enemy_zombie_pirates:change_behaviour_active_on_message("begin_bombardment", "fire_at_will", true, true);

gb:message_on_time_offset("dark_elves_weakened", 150000,"01_intro_cutscene_end");
gb:message_on_time_offset("begin_bombardment", 15000,"01_intro_cutscene_end");

ga_enemy_blood_dragons:release_on_message("enemy_release");
ga_enemy_blood_dragons:release_on_message("dark_elves_weakened");
ga_enemy_blood_dragons:defend_on_message("01_intro_cutscene_end", -206, -366, 50)
ga_enemy_blood_dragons:message_on_commander_dead_or_routing("blood_dragon_slain")
ga_enemy_blood_dragons:add_winds_of_magic_on_message("dark_elves_weakened", 100)
ga_enemy_blood_dragons:rout_over_time_on_message("blood_dragon_slain", 120000)

ga_enemy_dark_elves:attack_on_message("01_intro_cutscene_end");
ga_enemy_dark_elves:message_on_casualties("dark_elves_weakened", 0.75)
ga_enemy_dark_elves:rout_over_time_on_message("blood_dragon_slain", 30000)

ga_enemy_zombie_pirates:release_on_message("dark_elves_weakened");
ga_enemy_zombie_pirates:rout_over_time_on_message("blood_dragon_slain", 30000)
ga_enemy_zombie_pirates:defend_on_message("01_intro_cutscene_end", 130, -380, 50, 15000)
-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc15_qb_hef_imrik_armour_of_caledor_objective_01");

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------
gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc15_qb_hef_imrik_armour_of_caledor_help_01", 3000, nil, 5000);
gb:queue_help_on_message("begin_bombardment", "wh2_dlc15_qb_hef_imrik_armour_of_caledor_help_02");
gb:queue_help_on_message("dark_elves_weakened", "wh2_dlc15_qb_hef_imrik_armour_of_caledor_help_03");
gb:queue_help_on_message("blood_dragon_slain", "wh2_dlc15_qb_hef_imrik_armour_of_caledor_help_04");
-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------