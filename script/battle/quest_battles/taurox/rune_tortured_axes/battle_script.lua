-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Taurox the Brass Bull
-- Rune-Tortured Axes
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
intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/turoxaxes.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc17_bst_taurox_rune_tortured_axes_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc17_bst_taurox_rune_tortured_axes_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc17_bst_taurox_rune_tortured_axes_pt_03");

-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
		
	local cam = bm:camera();
	

	cam:fade(true, 0);
	
	-- declare cutscene
	local cutscene_intro = cutscene:new(
		"cutscene_intro", 						-- unique string name for cutscene
		ga_player.sunits,						-- unitcontroller over player's army
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
	

	cutscene_intro:action(function() bm:cindy_playback("script/battle/quest_battles/_cutscene/managers/turoxaxes.CindySceneManager", true) end, 200);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_player:set_enabled(true) 
		end, 
		200
	);	
	
	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc17_bst_taurox_rune_tortured_axes_pt_01", "subtitle_with_frame", 0.1, true) end, 2250);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 15000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 15500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc17_bst_taurox_rune_tortured_axes_pt_02", "subtitle_with_frame", 0.1, true) end, 15750);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 28000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 28500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc17_bst_taurox_rune_tortured_axes_pt_03", "subtitle_with_frame", 0.1, true) end, 28750);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 43500);
	
	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;
-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_player = gb:get_army(gb:get_player_alliance_num(), 1, "");
player_ally = gb:get_army(gb:get_player_alliance_num(),"player_ally");

enemy_main = gb:get_army(gb:get_non_player_alliance_num(),"enemy_main");
enemy_reinforcements_def = gb:get_army(gb:get_non_player_alliance_num(),"enemy_reinforcements_def");
enemy_reinforcements_nor = gb:get_army(gb:get_non_player_alliance_num(),"enemy_reinforcements_nor");

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

--Stopping player from firing until the cutscene is done
ga_player:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
enemy_main:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);

ga_player:change_behaviour_active_on_message("battle_started", "fire_at_will", true, true);
enemy_main:change_behaviour_active_on_message("battle_started", "fire_at_will", true, true);

--Release enemy_main once cutsene is done
enemy_main:release_on_message("battle_started", 10);

------------------------------------------------------------------------
----------------------  ENEMY REINFORCEMENTS DEF -----------------------
------------------------------------------------------------------------

--enemy_main receives casualties trigger enemy_reinforcements_def message
enemy_main:message_on_rout_proportion("enemy_reinforcements_def_casualties", 0.6);

--5 minute enemy_reinforcements_def countdown starts following battle_started
gb:message_on_time_offset("enemy_reinforcements_def_countdown", 300000, "battle_started")

--enemy_reinforcements_def enter battlefield
enemy_reinforcements_def:reinforce_on_message("enemy_reinforcements_def_casualties", 10);
enemy_reinforcements_def:reinforce_on_message("enemy_reinforcements_def_countdown", 10);
enemy_reinforcements_def:release_on_message("enemy_reinforcements_def_casualties", 2000);
enemy_reinforcements_def:release_on_message("enemy_reinforcements_def_countdown", 2000);

--if reinforcement message heard, block other reinforcement message
gb:block_message_on_message("enemy_reinforcements_def_countdown", "enemy_reinforcements_def_casualties", true);
gb:block_message_on_message("enemy_reinforcements_def_casualties", "enemy_reinforcements_def_countdown", true);

------------------------------------------------------------------------
---------------------  PLAYER ALLY REINFORCEMENTS ----------------------
------------------------------------------------------------------------

--player_ally reinforcements enter battlefield 90 seconds after enemy_reinforcements_def
player_ally:reinforce_on_message("enemy_reinforcements_def_casualties", 90000);
player_ally:reinforce_on_message("enemy_reinforcements_def_countdown", 90000);
player_ally:release_on_message("enemy_reinforcements_def_casualties", 92000);
player_ally:release_on_message("enemy_reinforcements_def_countdown", 92000);

------------------------------------------------------------------------
----------------------  ENEMY REINFORCEMENTS NOR -----------------------
------------------------------------------------------------------------

--enemy_reinforcements_def receives casualties trigger enemy_reinforcements_nor message
enemy_reinforcements_def:message_on_rout_proportion("enemy_reinforcements_nor_casualties", 0.8);

--3 minute enemy_reinforcements_nor countdown starts following enemy_reinforcement_def joining
gb:message_on_time_offset("enemy_reinforcements_nor_countdown", 180000, "enemy_reinforcements_def_casualties")
gb:message_on_time_offset("enemy_reinforcements_nor_countdown", 180000, "enemy_reinforcements_def_countdown")

--enemy_reinforcements_nor enter battlefield
enemy_reinforcements_nor:reinforce_on_message("enemy_reinforcements_nor_casualties", 10);
enemy_reinforcements_nor:reinforce_on_message("enemy_reinforcements_nor_countdown", 10);
enemy_reinforcements_nor:release_on_message("enemy_reinforcements_nor_casualties", 2000);
enemy_reinforcements_nor:release_on_message("enemy_reinforcements_nor_countdown", 2000);

--if reinforcement message heard, block other reinforcement message
gb:block_message_on_message("enemy_reinforcements_nor_countdown", "enemy_reinforcements_nor_casualties", true);
gb:block_message_on_message("enemy_reinforcements_nor_casualties", "enemy_reinforcements_nor_countdown", true);

------------------------------------------------------------------------
------------------------ PLAYER FORCE DEFEATED -------------------------
------------------------------------------------------------------------
ga_player:message_on_rout_proportion("player_defeated", 1);

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc17_bst_taurox_rune_tortured_axes_hints_main_objective");

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc17_bst_taurox_rune_tortured_axes_hints_start_battle", 7000, 2000, 0);
gb:queue_help_on_message("enemy_reinforcements_def_countdown", "wh2_dlc17_bst_taurox_rune_tortured_axes_hints_enemy_reinforcements_def");
gb:queue_help_on_message("enemy_reinforcements_def_casualties", "wh2_dlc17_bst_taurox_rune_tortured_axes_hints_enemy_reinforcements_def");
gb:queue_help_on_message("enemy_reinforcements_def_countdown", "wh2_dlc17_bst_taurox_rune_tortured_axes_hints_player_ally", nil,  nil, 90000);
gb:queue_help_on_message("enemy_reinforcements_def_casualties", "wh2_dlc17_bst_taurox_rune_tortured_axes_hints_player_ally", nil, nil, 90000);
gb:queue_help_on_message("enemy_reinforcements_nor_countdown", "wh2_dlc17_bst_taurox_rune_tortured_axes_hints_enemy_reinforcements_nor");
gb:queue_help_on_message("enemy_reinforcements_nor_casualties", "wh2_dlc17_bst_taurox_rune_tortured_axes_hints_enemy_reinforcements_nor");

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY ----------------------------------------------
-------------------------------------------------------------------------------------------------
enemy_main:force_victory_on_message("player_defeated", 5000);