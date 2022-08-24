-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Boris
-- The Shard Blade
-- Ice Caverns of Ymirdrak
-- Defender

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------
load_script_libraries();

--bm:camera():fade(true, 0);

gb = generated_battle:new(
	false,                                      		-- screen starts black
	false,                                      		-- prevent deployment for player
	false,                                      		-- prevent deployment for ai
	function()
	end,          										-- intro cutscene function
	false                                      			-- debug mode
);

--preload stuttering fix
--intro_cinematic_file = "script/battle/quest_battles/_cutscene/scenes/wsa_s01.CindyScene";
--bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

--wh2_main_sfx_01 = new_sfx("Play_wh2_main_qb_skv_queek_headtaker_warp_shard_armour_stage_6_warp_shard_caverns_pt_01");
--wh2_main_sfx_02 = new_sfx("Play_wh2_main_qb_skv_queek_headtaker_warp_shard_armour_stage_6_warp_shard_caverns_pt_02");
--wh2_main_sfx_03 = new_sfx("Play_wh2_main_qb_skv_queek_headtaker_warp_shard_armour_stage_6_warp_shard_caverns_pt_03");

-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

--function end_deployment_phase()
--	bm:out("\tend_deployment_phase() called");
		
--	local cam = bm:camera();
	
	-- REMOVE ME
--	cam:fade(true, 0);
	
	-- declare cutscene
--	local cutscene_intro = cutscene:new(
--		"cutscene_intro", 						-- unique string name for cutscene
--		ga_attacker_01.sunits,					-- unitcontroller over player's army
--		33000, 									-- duration of cutscene in ms
--		function() intro_cutscene_end() end		-- what to call when cutscene is finished
--	);
	
--	local player_units_hidden = false;
	
	-- set up subtitles
--	local subtitles = cutscene_intro:subtitles();
--	subtitles:set_alignment("bottom_centre");
--	subtitles:clear();
	
	-- cutscene_intro:set_post_cutscene_fade_time(0);
	
	-- skip callback
--	cutscene_intro:set_skippable(
--		true, 
--		function()
--			local cam = bm:camera();
--			cam:fade(true, 0);
--			bm:stop_cindy_playback(true);
			
--			if player_units_hidden then
--				ga_attacker_01:set_enabled(true)
--			end;
						
--			bm:callback(function() cam:fade(false, 0.5) end, 500);
--		end
--	);
	
	-- set up actions on cutscene
	--cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	

--	cutscene_intro:action(function() bm:cindy_playback("script/battle/quest_battles/_cutscene/scenes/wsa_s01.CindyScene", true) end, 200);
--	cutscene_intro:action(
--		function()
--			player_units_hidden = false;
--			ga_attacker_01:set_enabled(true) 
--		end, 
--		200
--	);	
--	cutscene_intro:action(
--		function() 
--			player_units_hidden = false;
--			ga_attacker_01:set_enabled(true) 
--		end, 
--		25000
--	);		
	
	-- Voiceover and Subtitles --
	
--	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 3000);	
--	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_skv_queek_headtaker_warp_shard_armour_stage_6_warp_shard_caverns_pt_01", "subtitle_with_frame", 10) end, 3100);	
--	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 15000);
	
--	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 15500);	
--	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_skv_queek_headtaker_warp_shard_armour_stage_6_warp_shard_caverns_pt_02", "subtitle_with_frame", 8) end, 15600);	
--	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 26000);
	
--	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 26500);	
--	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_main_qb_skv_queek_headtaker_warp_shard_armour_stage_6_warp_shard_caverns_pt_03", "subtitle_with_frame", 5) end, 26600);	
--	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 32500);
	
--	cutscene_intro:start();
--end;

--function intro_cutscene_end()
--	gb.sm:trigger_message("01_intro_cutscene_end")
--end;
-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------
--Player Army
ga_defender_01 = gb:get_army(gb:get_player_alliance_num());

--Enemy Armies
ga_attacker_01 = gb:get_army(gb:get_non_player_alliance_num(), "attacker_1");
ga_reinforcements_01 = gb:get_army(gb:get_non_player_alliance_num(), "reinforcements_1");

ga_reinforcements_01:set_enabled(false);	--Frostwyrm is hidden at the start of battle
-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------
--ga_attacker_01 (Enemy Army)
gb:message_on_time_offset("01_intro_cutscene_end", 1000); 
ga_attacker_01:advance_on_message("01_intro_cutscene_end");
ga_attacker_01:message_on_under_attack("under_attack");
ga_attacker_01:attack_on_message("under_attack");
ga_attacker_01:message_on_casualties("reinforce", 0.3);   -- Frostwyrm reinforces

--ga_reinforcements_01 (Frostwyrm)
ga_reinforcements_01:teleport_to_start_location_offset_on_message("01_intro_cutscene_end", -315, 190);
ga_reinforcements_01:set_enabled_on_message("reinforce", true);
gb:message_on_all_messages_received("attack", "reinforce")
ga_reinforcements_01:attack_on_message("attack", 1000);

------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------
--Destroy the Savage Orcs, and deal with any other threats!
gb:set_objective_on_message("01_intro_cutscene_end", "wh3_main_qb_ksl_boris_shardblade_ice_caverns_of_ymirdrak_hints_main_objective");
ga_attacker_01:add_ping_icon_on_message("01_intro_cutscene_end", 15, 1, 15000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------
--Sweep these primitive savages from the face of the world!
gb:queue_help_on_message("01_intro_cutscene_end", "wh3_main_qb_ksl_boris_shardblade_ice_caverns_of_ymirdrak_hints_main_hint", 10000, 2000, 5000, false);

--Ai, Ymirdrak comes! His wrath is as a blizzard unending!
gb:queue_help_on_message("reinforce", "wh3_main_qb_ksl_boris_shardblade_ice_caverns_of_ymirdrak_hints_ambush", 10000, 2000, 1000, false);
ga_reinforcements_01:add_ping_icon_on_message("reinforce", 15, 1, 10000);

--Ha! The Greenskin Warboss is defeated!
ga_attacker_01:message_on_commander_dead_or_shattered("lord_dead");
gb:queue_help_on_message("lord_dead", "wh3_main_qb_ksl_boris_shardblade_ice_caverns_of_ymirdrak_hints_greenskin_lord_dead");

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------

