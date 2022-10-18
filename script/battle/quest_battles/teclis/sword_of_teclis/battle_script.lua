-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Teclis
-- Sword of Teclis
-- Vaul's Anvil
-- Attacking

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
intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/sot.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_main_qb_hef_teclis_sword_of_teclis_stage_vauls_anvil_3_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_main_qb_hef_teclis_sword_of_teclis_stage_vauls_anvil_3_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_main_qb_hef_teclis_sword_of_teclis_stage_vauls_anvil_3_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_main_qb_hef_teclis_sword_of_teclis_stage_vauls_anvil_3_pt_04");
wh2_main_sfx_05 = new_sfx("Play_wh2_main_qb_hef_teclis_sword_of_teclis_stage_vauls_anvil_3_pt_05");

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
		35000, 									-- duration of cutscene in ms
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

	cutscene_intro:action(function() bm:cindy_playback("script/battle/quest_battles/_cutscene/managers/sot.CindySceneManager", true) end, 200);
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
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_hef_teclis_sword_of_teclis_stage_vauls_anvil_3_pt_01", "subtitle_with_frame", 0.1) end, 3100);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 8300);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 8800);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_hef_teclis_sword_of_teclis_stage_vauls_anvil_3_pt_02", "subtitle_with_frame", 0.1) end, 8900);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 18800);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 19000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_hef_teclis_sword_of_teclis_stage_vauls_anvil_3_pt_03", "subtitle_with_frame", 0.1) end, 19100);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 22800);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 23300);
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_hef_teclis_sword_of_teclis_stage_vauls_anvil_3_pt_04", "subtitle_with_frame", 0.1) end, 23500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 28800);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_05) end, 29300);
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_hef_teclis_sword_of_teclis_stage_vauls_anvil_3_pt_05", "subtitle_with_frame", 0.1) end, 29400);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 35000);
	
	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;
-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_defender_01 = gb:get_army(gb:get_player_alliance_num(), 1);
ga_defender_02 = gb:get_army(gb:get_player_alliance_num(), 2,"ally_tyrion_west");
ga_defender_03 = gb:get_army(gb:get_player_alliance_num(), 2,"ally_tyrion_east");

ga_attacker_01 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_main_army");
ga_attacker_02 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_expendable");
ga_malekith = gb:get_army(gb:get_non_player_alliance_num(), "enemy_malekith");


--[[
if gb:get_army(gb:get_non_player_alliance_num(), 1):are_unit_types_in_army("wh2_main_def_cha_dreadlord_0") then
	ga_attacker_01 = gb:get_army(gb:get_non_player_alliance_num(), 1,"enemy_main_army");
	ga_attacker_02 = gb:get_army(gb:get_non_player_alliance_num(), 2,"enemy_expendable");
	ga_malekith = gb:get_army(gb:get_non_player_alliance_num(), 3,"enemy_malekith");
else
	ga_attacker_01 = gb:get_army(gb:get_non_player_alliance_num(), 2,"enemy_main_army");
	ga_attacker_02 = gb:get_army(gb:get_non_player_alliance_num(), 1,"enemy_expendable");
	ga_malekith = gb:get_army(gb:get_non_player_alliance_num(), 3,"enemy_malekith");
end
]]

-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------

ga_defender_01:goto_location_offset_on_message("battle_started", 0, 50, false);
ga_attacker_01:goto_location_offset_on_message("battle_started", 0, 50, false);
ga_attacker_02:goto_location_offset_on_message("battle_started", 0, 50, false);

ga_defender_01:set_always_visible_on_message("battle_started", true, false);
ga_defender_02:set_always_visible_on_message("battle_started", true, false);

ga_defender_01:message_on_casualties("reinforcements", 0.3); 
gb:message_on_time_offset("reinforcements", 360000);
ga_defender_02:reinforce_on_message("reinforcements");
ga_defender_02:release_on_message("reinforcements");
ga_defender_03:reinforce_on_message("reinforcements");
ga_defender_03:release_on_message("reinforcements");



ga_attacker_01:halt();
ga_attacker_02:release_on_message("01_intro_cutscene_end");
ga_attacker_02:message_on_casualties("assault", 0.4); 
ga_attacker_01:message_on_casualties("assault", 0.05); --back up if player deals a lot of damage to main army from range.
ga_attacker_01:release_on_message("assault");


ga_attacker_01:message_on_casualties("malekith_advance", 0.25); 
ga_malekith:reinforce_on_message("malekith_advance");
ga_malekith:release_on_message("malekith_advance");


-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_locatable_objective_on_message("01_intro_cutscene_end", "wh2_main_qb_hef_teclis_sword_of_teclis_stage_vauls_anvil_3_hints_main_objective", 100, v(-13, 544, -403), v(-42, 515, -173), 2);      


-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("reinforcements", "wh2_main_qb_hef_teclis_sword_of_teclis_stage_vauls_anvil_3_hints_reinforcements");
gb:queue_help_on_message("01_intro_cutscene_end", "wh2_main_qb_hef_teclis_sword_of_teclis_stage_vauls_anvil_3_hints_tactics", 6000, nil, 5000);
gb:add_ping_icon_on_message("01_intro_cutscene_end", v(-11, 515, -308), 1, 6000, 7000);
gb:queue_help_on_message("malekith_advance", "wh2_main_qb_hef_teclis_sword_of_teclis_stage_vauls_anvil_3_hints_malekith");


-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY ----------------------------------------------
-------------------------------------------------------------------------------------------------

