-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Kroq-Gar
-- Revered Spear of Tlanxla
-- Mosquito Swamps
-- Attacker

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
intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/rst.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_main_qb_lzd_kroqgar_revered_spear_of_tlanxla_stage_3_mosquito_swamps_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_main_qb_lzd_kroqgar_revered_spear_of_tlanxla_stage_3_mosquito_swamps_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_main_qb_lzd_kroqgar_revered_spear_of_tlanxla_stage_3_mosquito_swamps_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_main_qb_lzd_kroqgar_revered_spear_of_tlanxla_stage_3_mosquito_swamps_pt_04");

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
		ga_attacker_01.sunits,					-- unitcontroller over player's army
		30000, 									-- duration of cutscene in ms
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
				ga_attacker_01:set_enabled(true)
			end;
						
			bm:callback(function() cam:fade(false, 0.5) end, 500);
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);

	cutscene_intro:action(function() bm:cindy_playback("script/battle/quest_battles/_cutscene/managers/rst.CindySceneManager", true) end, 200);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_attacker_01:set_enabled(true) 
		end, 
		200
	);	
	cutscene_intro:action(
		function() 
			player_units_hidden = false;
			ga_attacker_01:set_enabled(true) 
		end, 
		25000
	);		
	
	-- Voiceover and Subtitles --
	--cutscene_intro:action(function() cutscene_intro:play_sound(key) end, sfx_timing_ms);	
	--cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_subtitle_key", "subtitle_frame", subtitle_reveal_speed_seconds)	end, subtitle_timing_ms);
	--cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, subtitle_hide_timing_ms);
	
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 3000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_lzd_kroqgar_revered_spear_of_tlanxla_stage_3_mosquito_swamps_pt_01", "subtitle_with_frame", 2, true)	end, 3500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 7000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 7600);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_lzd_kroqgar_revered_spear_of_tlanxla_stage_3_mosquito_swamps_pt_02", "subtitle_with_frame", 3, true)	end, 7700);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 11600);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 12100);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_lzd_kroqgar_revered_spear_of_tlanxla_stage_3_mosquito_swamps_pt_03", "subtitle_with_frame", 3.5, true)	end, 12900);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 18400);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 20000);
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_lzd_kroqgar_revered_spear_of_tlanxla_stage_3_mosquito_swamps_pt_04", "subtitle_with_frame", 5, true)	end, 20100);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 28500);
	

	
	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;


-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_attacker_01 = gb:get_army(gb:get_player_alliance_num(), 1);

ga_defender_01 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_lord");
ga_defender_02 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army");
ga_ally_01 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_ambush_1");
ga_ally_02 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_ambush_2");
ga_ally_03 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_ambush_3");

--[[
if gb:get_army(gb:get_non_player_alliance_num(), 1):are_unit_types_in_army("wh2_main_def_cha_dreadlord_female_0") then
	ga_defender_01 = gb:get_army(gb:get_non_player_alliance_num(), 1,"enemy_lord");
	ga_defender_02 = gb:get_army(gb:get_non_player_alliance_num(), 1,"enemy_army");
	ga_ally_01 = gb:get_army(gb:get_non_player_alliance_num(), 2,"enemy_ambush_1");
	ga_ally_02 = gb:get_army(gb:get_non_player_alliance_num(), 3,"enemy_ambush_2");
	ga_ally_03 = gb:get_army(gb:get_non_player_alliance_num(), 4,"enemy_ambush_3");
else
	ga_ally_03 = gb:get_army(gb:get_non_player_alliance_num(), 1,"enemy_ambush_3");
	ga_ally_01 = gb:get_army(gb:get_non_player_alliance_num(), 2,"enemy_ambush_1");
	ga_ally_02 = gb:get_army(gb:get_non_player_alliance_num(), 3,"enemy_ambush_2");
	ga_defender_01 = gb:get_army(gb:get_non_player_alliance_num(), 4,"enemy_lord");
	ga_defender_02 = gb:get_army(gb:get_non_player_alliance_num(), 4,"enemy_army");
end
]]

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------
ga_defender_01:set_always_visible_on_message("battle_started", true, false);
ga_defender_02:set_always_visible_on_message("battle_started", true, false);

ga_defender_01:release_on_message("01_intro_cutscene_end");
ga_defender_01:defend_on_message("01_intro_cutscene_end", -45, 470, 40); 

ga_defender_02:message_on_proximity_to_enemy("ambush_1", 500);
ga_defender_02:message_on_proximity_to_enemy("ambush_2", 400);
ga_defender_02:message_on_proximity_to_enemy("ambush_3", 300);
ga_ally_01:message_on_proximity_to_enemy("ambush_1", 150);
ga_ally_02:message_on_proximity_to_enemy("ambush_2", 150);
ga_ally_03:message_on_proximity_to_enemy("ambush_3", 150);
ga_ally_01:message_on_casualties("ambush_1", 0.05); -- Backup triggers in case the player cheeses with long range arty
ga_ally_02:message_on_casualties("ambush_2", 0.05);
ga_ally_03:message_on_casualties("ambush_3", 0.05);

ga_ally_01:release_on_message("ambush_1");
ga_ally_02:release_on_message("ambush_2"); 
ga_ally_03:release_on_message("ambush_3");
ga_ally_01:attack_on_message("ambush_1");
ga_ally_02:attack_on_message("ambush_2"); 
ga_ally_03:attack_on_message("ambush_3");

ga_defender_02:message_on_proximity_to_enemy("main_enemy", 150);
ga_defender_02:message_on_casualties("main_enemy", 0.05);  -- Backup trigger in case the player cheeses with long range arty
ga_defender_02:release_on_message("main_enemy");

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_locatable_objective_on_message("01_intro_cutscene_end", "wh2_main_qb_lzd_kroqgar_revered_spear_of_tlanxla_stage_3_mosquito_swamps_hints_main_objective", 100, v(-44, 203, 230), v(-57, 200, 447), 2);   
ga_defender_01:add_ping_icon_on_message("01_intro_cutscene_end", 10000000, 1, 5000)

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh2_main_qb_lzd_kroqgar_revered_spear_of_tlanxla_stage_3_mosquito_swamps_hints_advance", 6000, nil, 5000);
gb:queue_help_on_message("ambush", "wh2_main_qb_lzd_kroqgar_revered_spear_of_tlanxla_stage_3_mosquito_swamps_hints_ambush");
gb:queue_help_on_message("main_enemy", "wh2_main_qb_lzd_kroqgar_revered_spear_of_tlanxla_stage_3_mosquito_swamps_hints_enemy_advance");
gb:queue_help_on_message("lord_dead", "wh2_main_qb_lzd_kroqgar_revered_spear_of_tlanxla_stage_3_mosquito_swamps_hints_enemy_lord_defeated");

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_defender_01:message_on_commander_dead_or_routing("lord_dead");
ga_attacker_01:force_victory_on_message("lord_dead")