-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Throt
-- Whip of Domination
-- Hell Pit Blockade
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();
bm = battle_manager:new(empire_battle:new());

bm:camera():fade(true, 0);

gb = generated_battle:new(
	false,                                      		    -- screen starts black
	false,                                      		-- prevent deployment for player
	true,                                      		    -- prevent deployment for ai
	function() end_deployment_phase() end,          	-- intro cutscene function
	false                                      			-- debug mode
);

--preload stuttering fix
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\whip.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc16_Throt_Whip_of_Domination_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc16_Throt_Whip_of_Domination_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc16_Throt_Whip_of_Domination_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_dlc16_Throt_Whip_of_Domination_pt_04");
wh2_main_sfx_05 = new_sfx("Play_wh2_dlc16_Throt_Whip_of_Domination_pt_05");

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_throt_player = gb:get_army(gb:get_player_alliance_num(), 1, "");
ga_ally_ghoritch = gb:get_army(gb:get_player_alliance_num(),"ghoritch_vanguard");
ga_enemy_chaos_blockade = gb:get_army(gb:get_non_player_alliance_num(),"chaos_blockade");

-- ga_enemy_chaos_blockade:set_visible_to_all(true);

-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------

function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");
	
    --teleport unit (1) of ga_artillery to [645, -420] with an orientation of 45 degrees and a width of 25m
	ga_enemy_chaos_blockade.sunits:item(15).uc:teleport_to_location(v(165, -262), 270, 25);		--chaos spawn
	ga_enemy_chaos_blockade.sunits:item(16).uc:teleport_to_location(v(-176, -264), 90, 25);
	ga_enemy_chaos_blockade.sunits:item(17).uc:teleport_to_location(v(-354, -280), 180, 25);	--hounds
	ga_enemy_chaos_blockade.sunits:item(18).uc:teleport_to_location(v(370, -308), 180, 25);
end;

-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------

function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
	
	-- teleport units into their desired positions
	battle_start_teleport_units();
	--bm:modify_battle_speed(0);
	
	local cam = bm:camera();
	
	-- declare cutscene
	local cutscene_intro = cutscene:new(
		"cutscene_intro", 						-- unique string name for cutscene
		ga_throt_player.sunits,					-- unitcontroller over player's army
		78500, 									-- duration of cutscene in ms
		function() intro_cutscene_end() end		-- what to call when cutscene is finished
	);
	
	local player_units_hidden = false;
	
	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
		
	cutscene_intro:set_post_cutscene_fade_time(3.0, 3000);
	
	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()		
			local cam = bm:camera();
			bm:stop_cindy_playback(true);		
			if player_units_hidden then
				ga_throt_player:set_enabled(true)
			end;
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 680);
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\whip.CindySceneManager", 0, 2) end, 680);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_throt_player:set_enabled(true) 
		end, 
		680
	);	
	
	-- Voiceover and Subtitles --\
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc16_Throt_Whip_of_Domination_pt_01", "subtitle_with_frame", 3, true) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 11500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 12000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc16_Throt_Whip_of_Domination_pt_02", "subtitle_with_frame", 3, true) end, 12000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 22000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 22500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc16_Throt_Whip_of_Domination_pt_03", "subtitle_with_frame", 3, true) end, 22500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 33500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 34000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc16_Throt_Whip_of_Domination_pt_04", "subtitle_with_frame", 3, true) end, 34000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 57000);

	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_05) end, 57500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc16_Throt_Whip_of_Domination_pt_05", "subtitle_with_frame", 3, true) end, 57500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 78500);

	cutscene_intro:start();
	
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;


-------------------------------------------------------------------------------------------------
------------------------------------------ ORDERS -------------------------------------------
-------------------------------------------------------------------------------------------------
--Stopping armies from firing until the cutscene is done
ga_throt_player:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_throt_player:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
--[[ga_ally_ghoritch:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_ally_ghoritch:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
ga_enemy_chaos_blockade:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_enemy_chaos_blockade:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
]]

-- time offsets
gb:message_on_time_offset("begin_attack", 1000,"battle_started");
gb:message_on_time_offset("release_all", 60000,"01_intro_cutscene_end");
gb:message_on_time_offset("ghoritch_no_longer_invincible", 20000,"01_intro_cutscene_end");

-- battle start conditions
ga_enemy_chaos_blockade:set_invincible_on_message("battle_started", true);
ga_ally_ghoritch:set_invincible_on_message("battle_started", true);
ga_enemy_chaos_blockade:set_invincible_on_message("01_intro_cutscene_end", false);
ga_ally_ghoritch:set_invincible_on_message("ghoritch_no_longer_invincible", false);

ga_ally_ghoritch:attack_on_message("begin_attack");
ga_enemy_chaos_blockade:attack_on_message("begin_attack");
ga_enemy_chaos_blockade:add_winds_of_magic_on_message("01_intro_cutscene_end", 20)

ga_throt_player:message_on_proximity_to_enemy("chaos_control", 100);
--ga_enemy_chaos_blockade:message_on_under_attack("chaos_control");
--ga_ally_ghoritch:message_on_proximity_to_enemy("ghoritch_unleashed", 10);

-- objective listeners
ga_enemy_chaos_blockade:message_on_casualties("purged_the_heretic", 1);

ga_throt_player:message_on_rout_proportion("dont_cheese_it", 0.2);
ga_throt_player:message_on_commander_dead_or_routing("throts_cheesing_it", 1);

ga_ally_ghoritch:message_on_casualties("staying_alive", 0.6);
ga_ally_ghoritch:set_invincible_on_message("staying_alive", true);
gb:message_on_time_offset("ghoritch_last_stand", 20000,"staying_alive");
ga_ally_ghoritch:set_invincible_on_message("ghoritch_last_stand", false);
ga_ally_ghoritch:message_on_commander_death("ghoritch_dead");
gb:message_on_time_offset("well_heck_it", 1000, "ghoritch_dead");
ga_ally_ghoritch:rout_over_time_on_message("well_heck_it", 9000);

-- releases
ga_ally_ghoritch:release_on_message("release_all");
ga_ally_ghoritch:release_on_message("ghoritch_unleashed");
ga_enemy_chaos_blockade:release_on_message("release_all");
ga_enemy_chaos_blockade:release_on_message("chaos_control");


-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc16_qb_skv_throt_whip_of_domination_objective_01");
gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc16_qb_skv_throt_whip_of_domination_objective_02");
gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc16_qb_skv_throt_whip_of_domination_objective_03");

gb:complete_objective_on_message("purged_the_heretic", "wh2_dlc16_qb_skv_throt_whip_of_domination_objective_01", 5);

gb:fail_objective_on_message("ghoritch_dead", "wh2_dlc16_qb_skv_throt_whip_of_domination_objective_02", 5);
gb:fail_objective_on_message("throts_cheesing_it", "wh2_dlc16_qb_skv_throt_whip_of_domination_objective_03", 5);

ga_enemy_chaos_blockade:force_victory_on_message("ghoritch_dead", 10000);
ga_enemy_chaos_blockade:force_victory_on_message("throts_cheesing_it", 10000);
-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("staying_alive", "wh2_dlc16_qb_skv_throt_whip_of_domination_hint_01", 6000, nil, 1000);
ga_ally_ghoritch:add_ping_icon_on_message("staying_alive", 8, 1, 8000)
gb:queue_help_on_message("dont_cheese_it", "wh2_dlc16_qb_skv_throt_whip_of_domination_hint_02", 6000, nil, 1000);
ga_throt_player:add_ping_icon_on_message("dont_cheese_it", 8, 1, 8000)

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------