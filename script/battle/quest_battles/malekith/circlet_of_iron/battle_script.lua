-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Malekith
-- Circlet of Iron
-- Altar of Ultimate Darkness
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
intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/coi.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_main_qb_def_malekith_circlet_of_iron_stage_3_altar_of_ultimate_darkness_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_main_qb_def_malekith_circlet_of_iron_stage_3_altar_of_ultimate_darkness_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_main_qb_def_malekith_circlet_of_iron_stage_3_altar_of_ultimate_darkness_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_main_qb_def_malekith_circlet_of_iron_stage_3_altar_of_ultimate_darkness_pt_04");

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
		ga_defender_01.sunits,					-- unitcontroller over player's army
		38000, 									-- duration of cutscene in ms
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
				ga_defender_01:set_enabled(true)
			end;
						
			bm:callback(function() cam:fade(false, 0.5) end, 500);
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	

	cutscene_intro:action(function() bm:cindy_playback("script/battle/quest_battles/_cutscene/managers/coi.CindySceneManager", true) end, 200);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_defender_01:set_enabled(true) 
		end, 
		200
	);	
	cutscene_intro:action(
		function() 
			player_units_hidden = false;
			ga_defender_01:set_enabled(true) 
		end, 
		25000
	);	
	
	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 3000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_def_malekith_circlet_of_iron_stage_3_altar_of_ultimate_darkness_pt_01", "subtitle_with_frame", 11) end, 3100);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 14900);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 15500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_def_malekith_circlet_of_iron_stage_3_altar_of_ultimate_darkness_pt_02", "subtitle_with_frame", 4) end, 15600);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 21200);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 21800);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_def_malekith_circlet_of_iron_stage_3_altar_of_ultimate_darkness_pt_03", "subtitle_with_frame", 5) end, 21900);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 27000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 28000);
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_def_malekith_circlet_of_iron_stage_3_altar_of_ultimate_darkness_pt_04", "subtitle_with_frame", 7) end, 28100);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 37500);

	
	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_defender_01 = gb:get_army(gb:get_player_alliance_num(), 1);

ga_attacker_01 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army");
ga_ally_01 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_reinforcements_1");
ga_ally_02 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_reinforcements_2");

--[[
if gb:get_army(gb:get_non_player_alliance_num(), 1):are_unit_types_in_army("wh_main_chs_cav_chaos_knights_0") then
	ga_attacker_01 = gb:get_army(gb:get_non_player_alliance_num(), 1,"enemy_army");
	ga_ally_01 = gb:get_army(gb:get_non_player_alliance_num(), 2,"enemy_reinforcements_1");
	ga_ally_02 = gb:get_army(gb:get_non_player_alliance_num(), 2,"enemy_reinforcements_2");
else
	ga_attacker_01 = gb:get_army(gb:get_non_player_alliance_num(), 2,"enemy_army");
	ga_ally_01 = gb:get_army(gb:get_non_player_alliance_num(), 1,"enemy_reinforcements_2");
	ga_ally_02 = gb:get_army(gb:get_non_player_alliance_num(), 1,"enemy_reinforcements_1");
end
]]

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

ga_attacker_01:goto_location_offset_on_message("battle_started", 0, 50, false);
ga_defender_01:goto_location_offset_on_message("battle_started", 0, 55, false);
ga_attacker_01:set_always_visible_on_message("battle_started", true, false);

ga_attacker_01:message_on_casualties("retreat_a_bit", 0.05);
ga_attacker_01:message_on_proximity_to_enemy("retreat_a_bit", 350);
ga_attacker_01:goto_location_offset_on_message("retreat_a_bit", 0, -150, false);


ga_attacker_01:message_on_proximity_to_enemy("attack", 150);
ga_attacker_01:message_on_casualties("attack", 0.1);
ga_attacker_01:release_on_message("attack");


ga_attacker_01:message_on_proximity_to_enemy("reinforcements_1", 25);
ga_attacker_01:message_on_proximity_to_enemy("reinforcements_2", 50);


ga_ally_01:reinforce_on_message("reinforcements_1", 31000);
ga_ally_02:reinforce_on_message("reinforcements_2", 1000);


ga_ally_01:defend_on_message("reinforcements_1",-270, -270, 60);
ga_ally_02:defend_on_message("reinforcements_1",-130, 180, 60);

ga_ally_01:message_on_proximity_to_enemy("reinforcements_3", 400);
ga_ally_02:message_on_proximity_to_enemy("reinforcements_3", 380);
ga_ally_01:release_on_message("reinforcements_3");
ga_ally_02:release_on_message("reinforcements_3");


-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

ga_attacker_01:add_ping_icon_on_message("01_intro_cutscene_end", 15, 1, 5000);
gb:set_locatable_objective_on_message("01_intro_cutscene_end", "wh2_main_qb_def_malekith_circlet_of_iron_stage_3_altar_of_ultimate_darkness_hint_main_objective", 100, v(3, 352, -206), v(19, 322, 19), 2); 

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh2_main_qb_def_malekith_circlet_of_iron_stage_3_altar_of_ultimate_darkness_hint_start", 6000, nil, 5000);
gb:queue_help_on_message("retreat_a_bit", "wh2_main_qb_def_malekith_circlet_of_iron_stage_3_altar_of_ultimate_darkness_hint_vanguard", 6000, nil, 5000);
gb:queue_help_on_message("reinforcements_1", "wh2_main_qb_def_malekith_circlet_of_iron_stage_3_altar_of_ultimate_darkness_hint_reinforcements_1");

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY ----------------------------------------------
-------------------------------------------------------------------------------------------------

