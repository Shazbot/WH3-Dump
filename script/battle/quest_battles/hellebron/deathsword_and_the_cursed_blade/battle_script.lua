-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Hellebron
-- Deathsword and the Cursed Blade
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
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\scenes\\dcb_s01.CindyScene";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc10_DEF_Hellebron_QB_Deathsword_and_CursedBlade_001");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc10_DEF_Hellebron_QB_Deathsword_and_CursedBlade_002");
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
				ga_defender_01:set_enabled(true)
			end;
						
			bm:callback(function() cam:fade(false, 0.5) end, 500);
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\scenes\\dcb_s01.CindyScene", true) end, 200);
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
		30000
	);	
	
	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 3000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc10_qb_def_hellebron_deathsword_and_the_cursed_blade_stage_4_intro_01", "subtitle_with_frame", 0.1) end, 3500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 16500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 18500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc10_qb_def_hellebron_deathsword_and_the_cursed_blade_stage_4_intro_02", "subtitle_with_frame", 0.1) end, 19000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 29500);
	
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
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------
gb:message_on_time_offset("battle_started_1", 100000);
gb:message_on_time_offset("battle_started_2", 20000);
gb:message_on_time_offset("battle_started_1", 100000);

ga_attacker_01:attack_on_message("battle_started_2");
ga_attacker_01:message_on_proximity_to_enemy("beastmen_engaged",50);
ga_attacker_01:release_on_message("beastmen_engaged");

ga_ally_01:advance_on_message("battle_started_1", 225, 271, 70);
ga_ally_01:message_on_proximity_to_enemy("artillery_01_engaged",200);
ga_ally_01:release_on_message("artillery_01_engaged");

ga_ally_02:advance_on_message("battle_started_1", 237, 241, 70);
ga_ally_02:message_on_proximity_to_enemy("artillery_01_engaged",200);
ga_ally_02:release_on_message("artillery_01_engaged");
-- ga_attacker_01:goto_location_offset_on_message("battle_started", 0, 50, false);
-- ga_defender_01:goto_location_offset_on_message("battle_started", 0, 55, false);
-- ga_attacker_01:set_always_visible_on_message("battle_started", true, false);

-- ga_attacker_01:message_on_casualties("retreat_a_bit", 0.05);
-- ga_attacker_01:message_on_proximity_to_enemy("retreat_a_bit", 350);
-- ga_attacker_01:goto_location_offset_on_message("retreat_a_bit", 0, -150, false);


-- ga_attacker_01:message_on_proximity_to_enemy("attack", 150);
-- ga_attacker_01:message_on_casualties("attack", 0.1);
-- ga_attacker_01:release_on_message("attack");


-- ga_attacker_01:message_on_proximity_to_enemy("reinforcements_1", 25);
-- ga_attacker_01:message_on_proximity_to_enemy("reinforcements_2", 50);


-- ga_ally_01:reinforce_on_message("reinforcements_1", 31000);
-- ga_ally_02:reinforce_on_message("reinforcements_2", 1000);


-- ga_ally_01:defend_on_message("reinforcements_1",-270, -270, 60);
-- ga_ally_02:defend_on_message("reinforcements_1",-130, 180, 60);

-- ga_ally_01:message_on_proximity_to_enemy("reinforcements_3", 400);
-- ga_ally_02:message_on_proximity_to_enemy("reinforcements_3", 380);
-- ga_ally_01:release_on_message("reinforcements_3");
-- ga_ally_02:release_on_message("reinforcements_3");


-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

--ga_attacker_01:add_ping_icon_on_message("01_intro_cutscene_end", 15, 1, 5000);
gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc10_hef_hellebron_deathsword_and_the_cursed_blade_stage_4_hints_main_objective"); 

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc10_hef_hellebron_deathsword_and_the_cursed_blade_stage_4_hints_start_battle");
gb:queue_help_on_message("battle_started_1", "wh2_dlc10_hef_hellebron_deathsword_and_the_cursed_blade_stage_4_hints_artillery_advances");

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------


-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY ----------------------------------------------
-------------------------------------------------------------------------------------------------