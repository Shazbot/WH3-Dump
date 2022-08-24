-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Queek Headtaker
-- Dwarf Gouger
-- Gouger Gully
-- Defender

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();
cam = bm:camera();

gb = generated_battle:new(
	true,                                    		    -- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                      		    -- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
);

--preload stuttering fix
intro_cinematic_file = "script/battle/quest_battles/_cutscene/scenes/dgg_s01.CindyScene";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_main_qb_skv_queek_headtaker_dwarfgouger_stage_4_gouger_gully_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_main_qb_skv_queek_headtaker_dwarfgouger_stage_4_gouger_gully_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_main_qb_skv_queek_headtaker_dwarfgouger_stage_4_gouger_gully_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_main_qb_skv_queek_headtaker_dwarfgouger_stage_4_gouger_gully_pt_04");


-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
	
	cam:fade(false, 1);
	
	-- declare cutscene
	local cutscene_intro = cutscene:new(
		"cutscene_intro", 						-- unique string name for cutscene
		ga_defender_01.sunits,					-- unitcontroller over player's army
		44000, 									-- duration of cutscene in ms
		function() intro_cutscene_end() end		-- what to call when cutscene is finished
	);
	
	local player_units_hidden = false;
	
	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
	
	--cutscene_intro:set_is_ambush();
	
	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()
			bm:stop_cindy_playback(true);
			
			if player_units_hidden then
				ga_defender_01:set_enabled(true)
			end;
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);

	cutscene_intro:action(function() bm:cindy_playback("script/battle/quest_battles/_cutscene/scenes/dgg_s01.CindyScene", true) end, 0);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_defender_01:set_enabled(true) 
		end, 
		200
	);	
	
	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 3000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_skv_queek_headtaker_dwarfgouger_stage_4_gouger_gully_pt_01", "subtitle_with_frame", 7.5) end, 4000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 12800);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 13300);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_skv_queek_headtaker_dwarfgouger_stage_4_gouger_gully_pt_02", "subtitle_with_frame", 10.5) end, 14300);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 26800);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 27300);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_skv_queek_headtaker_dwarfgouger_stage_4_gouger_gully_pt_03", "subtitle_with_frame", 7.5) end, 28300);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 37000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 37500);
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_skv_queek_headtaker_dwarfgouger_stage_4_gouger_gully_pt_04", "subtitle_with_frame", 3) end, 38500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 43900);
	
	
	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;
-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_defender_01 = gb:get_army(gb:get_player_alliance_num(), 1);

ga_attacker_01 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_1");
ga_attacker_02 = gb:get_army(gb:get_non_player_alliance_num(), "enemy_army_2");
ga_ally_01 = gb:get_army(gb:get_non_player_alliance_num(), "east_reinforcements");
ga_ally_02 = gb:get_army(gb:get_non_player_alliance_num(), "west_reinforcements");

--[[
if gb:get_army(gb:get_non_player_alliance_num(), 2):are_unit_types_in_army("wh_main_dwf_inf_miners_0") then
	ga_attacker_01 = gb:get_army(gb:get_non_player_alliance_num(), 1,"enemy_army_1");
	ga_attacker_02 = gb:get_army(gb:get_non_player_alliance_num(), 2,"enemy_army_2");
	ga_ally_01 = gb:get_army(gb:get_non_player_alliance_num(), 3,"east_reinforcements");
	ga_ally_02 = gb:get_army(gb:get_non_player_alliance_num(), 4,"west_reinforcements");
else
	ga_attacker_01 = gb:get_army(gb:get_non_player_alliance_num(), 1,"enemy_army_1");
	ga_attacker_02 = gb:get_army(gb:get_non_player_alliance_num(), 3,"enemy_army_2");
	ga_ally_01 = gb:get_army(gb:get_non_player_alliance_num(), 4,"east_reinforcements");
	ga_ally_02 = gb:get_army(gb:get_non_player_alliance_num(), 2,"west_reinforcements");
end
]]


-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------
ga_attacker_01:set_always_visible_on_message("01_intro_cutscene_end", true, false);
ga_attacker_02:set_always_visible_on_message("01_intro_cutscene_end", true, false);

gb:message_on_time_offset("move_forward_01", 44000);

ga_attacker_01:release_on_message("move_forward_01");
ga_attacker_02:release_on_message("move_forward_01");
ga_attacker_01:attack_on_message("move_forward_01");
ga_attacker_02:attack_on_message("move_forward_01");
ga_attacker_01:release_on_message("01_intro_cutscene_end");
ga_attacker_02:release_on_message("01_intro_cutscene_end");
ga_attacker_01:attack_on_message("01_intro_cutscene_end");
ga_attacker_02:attack_on_message("01_intro_cutscene_end");
ga_attacker_01:message_on_casualties("reinforcements_1", 0.3);
ga_attacker_02:message_on_casualties("reinforcements_1", 0.3);


ga_ally_01:reinforce_on_message("reinforcements_1", 30000);
ga_ally_02:reinforce_on_message("reinforcements_1", 30000);

ga_ally_01:message_on_any_deployed("reinforcements_2")
ga_ally_02:message_on_any_deployed("reinforcements_2")
ga_ally_01:attack_on_message("reinforcements_2");
ga_ally_02:attack_on_message("reinforcements_2");

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------
  
gb:set_objective_on_message("01_intro_cutscene_end", "wh2_main_qb_skv_queek_headtaker_dwarfgouger_stage_4_gouger_gully_hints_main_objective");

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh2_main_qb_skv_queek_headtaker_dwarfgouger_stage_4_gouger_gully_hints_survive", 3000, nil, 5000);
gb:queue_help_on_message("reinforcements_1", "wh2_main_qb_skv_queek_headtaker_dwarfgouger_stage_4_gouger_gully_hints_reinforcements_approaching");
gb:queue_help_on_message("reinforcements_2", "wh2_main_qb_skv_queek_headtaker_dwarfgouger_stage_4_gouger_gully_hints_reinforcements_arrive");

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY ----------------------------------------------
-------------------------------------------------------------------------------------------------
