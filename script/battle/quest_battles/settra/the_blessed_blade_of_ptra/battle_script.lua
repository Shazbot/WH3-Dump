-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Settra
-- The Blessed Blade of Ptra
-- Charnel Valley
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
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\bbp.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc09_qb_tmb_settra_the_blessed_blade_of_ptra_stage_3_charnel_valley_part_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc09_qb_tmb_settra_the_blessed_blade_of_ptra_stage_3_charnel_valley_part_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc09_qb_tmb_settra_the_blessed_blade_of_ptra_stage_3_charnel_valley_part_03");

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
		40000, 									-- duration of cutscene in ms
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
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\bbp.CindySceneManager", true) end, 200);
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
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 3000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc09_qb_tmb_settra_the_blessed_blade_of_ptra_stage_3_charnel_valley_part_01", "subtitle_with_frame", 9) end, 3500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 13000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 13500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc09_qb_tmb_settra_the_blessed_blade_of_ptra_stage_3_charnel_valley_part_02", "subtitle_with_frame", 12) end, 14000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 26500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 27500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc09_qb_tmb_settra_the_blessed_blade_of_ptra_stage_3_charnel_valley_part_03", "subtitle_with_frame", 10) end, 28000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 40000);
	
	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------


ga_attacker_01 = gb:get_army(gb:get_player_alliance_num(), 1);
ga_defender_01 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_1");
ga_defender_02 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_2");

--[[
if gb:get_army(gb:get_non_player_alliance_num(), 1):are_unit_types_in_army("wh_main_grn_mon_giant") then
	ga_attacker_01 = gb:get_army(gb:get_player_alliance_num(), 1);
	ga_defender_01 = gb:get_army(gb:get_non_player_alliance_num(), 1,"enemy_army_1");
	ga_defender_02 = gb:get_army(gb:get_non_player_alliance_num(), 2,"enemy_army_2");
else
	ga_attacker_01 = gb:get_army(gb:get_player_alliance_num(), 1);
	ga_defender_01 = gb:get_army(gb:get_non_player_alliance_num(), 2,"enemy_army_1");
	ga_defender_02 = gb:get_army(gb:get_non_player_alliance_num(), 1,"enemy_army_2");
end 
]]




-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

ga_defender_01:set_always_visible_on_message("battle_started", true, false);
ga_defender_02:set_always_visible_on_message("battle_started", true, false);

--gb:message_on_time_offset("battle_started_plus", 10000);
ga_attacker_01:goto_location_offset_on_message("battle_started", 0, 100, false);

ga_defender_01:goto_location_offset_on_message("battle_started", 0, 80, false);
ga_defender_02:goto_location_offset_on_message("battle_started", -10, 80, false);

ga_defender_01:goto_location_offset_on_message("01_intro_cutscene_end", 0, 100, false);
ga_defender_02:goto_location_offset_on_message("01_intro_cutscene_end", -10, 30, false);

--Empire defends central area, Dwarves take over ridge choke point
ga_defender_01:message_on_proximity_to_position("close_to_target_so_defend_low", v(70,15), 20);
ga_defender_02:message_on_proximity_to_position("close_to_target_so_attack_high", v(-250,-250), 20);
ga_defender_01:defend_on_message("close_to_target_so_defend_low", 70, 15, 20); 
ga_defender_02:defend_on_message("close_to_target_so_attack_high", -250, -250, 20); 

-- Both armies stop being defensive if player gets close.
ga_defender_01:message_on_proximity_to_enemy("01_player_close_to_low_ground", 150);
ga_defender_01:attack_on_message("01_player_close_to_low_ground");
ga_defender_02:attack_on_message("01_player_close_to_low_ground");

ga_defender_02:message_on_proximity_to_enemy("01_player_close_to_high_ground", 150);
ga_defender_01:attack_on_message("01_player_close_to_high_ground");
ga_defender_02:attack_on_message("01_player_close_to_high_ground");


--The army attacked by the player stops being defensive (E.G. if you fire artillery at AI1, it will attack you). When player is close, both armies release.
ga_defender_01:message_on_under_attack("01_player_attacked_low_ground");
ga_defender_01:attack_on_message("01_player_attacked_low_ground");
ga_defender_01:attack_on_message("01_player_attacked_low_ground");


ga_defender_02:message_on_under_attack("01_player_attacked_high_ground");
ga_defender_02:attack_on_message("01_player_attacked_high_ground");
ga_defender_02:attack_on_message("01_player_attacked_high_ground");

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc09_qb_tmb_settra_the_blessed_blade_of_ptra_stage_3_charnel_valley_hints_main_objective");

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc09_qb_tmb_settra_the_blessed_blade_of_ptra_stage_3_charnel_valley_hints_start_battle", 6000, nil, 5000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------

