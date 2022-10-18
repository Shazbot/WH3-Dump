-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Grom
-- Axe of Grom
-- Swamp of Terror
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
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\grom_axe_m01.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc15_GOB_Grom_Axe_of_Grom_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc15_GOB_Grom_Axe_of_Grom_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc15_GOB_Grom_Axe_of_Grom_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_dlc15_GOB_Grom_Axe_of_Grom_pt_04");
wh2_main_sfx_05 = new_sfx("Play_wh2_dlc15_GOB_Grom_Axe_of_Grom_pt_05");

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_attacker_player = gb:get_army(gb:get_player_alliance_num(), 1, "");
ga_enemy_git_guzzler = gb:get_army(gb:get_non_player_alliance_num(),"git_guzzler_enemy");
ga_enemy_skarsniks_skulkers = gb:get_army(gb:get_non_player_alliance_num(),"skarsniks_skulkers_enemy");
ga_enemy_squig_stampede = gb:get_army(gb:get_player_alliance_num(),"squig_stampede_enemy");

ga_enemy_git_guzzler:set_visible_to_all(true);

-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------

function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");
	
    --teleport unit (1) of ga_artillery to [645, -420] with an orientation of 45 degrees and a width of 25m
    ga_enemy_skarsniks_skulkers.sunits:item(1).uc:teleport_to_location(v(468, 437), 180, 25);
    --teleport unit (2) of ga_artillery to [600, -440] with an orientation of 45 degrees and a width of 25m
    ga_enemy_skarsniks_skulkers.sunits:item(3).uc:teleport_to_location(v(464, 459), 180, 25);
    --teleport unit (3) of ga_artillery to [620, -430] with an orientation of 45 degrees and a width of 25m
    ga_enemy_skarsniks_skulkers.sunits:item(4).uc:teleport_to_location(v(478, 403), 180, 25);
    --teleport unit (4) of ga_artillery to [630, -410] with an orientation of 45 degrees and a width of 25m
    ga_enemy_skarsniks_skulkers.sunits:item(5).uc:teleport_to_location(v(477, 472), 180, 25);
	ga_enemy_skarsniks_skulkers.sunits:item(6).uc:teleport_to_location(v(475, 470), 180, 25);
	ga_enemy_skarsniks_skulkers.sunits:item(7).uc:teleport_to_location(v(325, 25), 180, 25);
	ga_enemy_skarsniks_skulkers.sunits:item(8).uc:teleport_to_location(v(-425, 147), 90, 25);
	ga_enemy_skarsniks_skulkers.sunits:item(9).uc:teleport_to_location(v(-442, 164), 90, 25);
	ga_enemy_skarsniks_skulkers.sunits:item(10).uc:teleport_to_location(v(-239, -415), 20, 25);
	ga_attacker_player.sunits:item(1).uc:teleport_to_location(v(-13, -156), 0, 1);

	
end;
--12 units
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
		ga_attacker_player.sunits,					-- unitcontroller over player's army
		49000, 									-- duration of cutscene in ms
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
				ga_attacker_player:set_enabled(true)
			end;
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 680);
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\grom_axe_m01.CindySceneManager", 0, 2) end, 680);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_attacker_player:set_enabled(true) 
		end, 
		680
	);	
	
	-- Voiceover and Subtitles --\
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 2000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc15_GOB_Grom_Axe_of_Grom_pt_01", "subtitle_with_frame", 0.1, true) end, 2500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 11500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 12500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc15_GOB_Grom_Axe_of_Grom_pt_02", "subtitle_with_frame", 0.1, true) end, 12500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 22000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 23000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc15_GOB_Grom_Axe_of_Grom_pt_03", "subtitle_with_frame", 0.1, true) end, 23000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 30000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04) end, 31000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc15_GOB_Grom_Axe_of_Grom_pt_04", "subtitle_with_frame", 0.1, true) end, 31000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 40000);

	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_05) end, 41000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc15_GOB_Grom_Axe_of_Grom_pt_05", "subtitle_with_frame", 0.1, true) end, 41000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 49000);

	cutscene_intro:start();
	
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;


-------------------------------------------------------------------------------------------------
------------------------------------------ ORDERS -------------------------------------------
-------------------------------------------------------------------------------------------------
--Stopping armies from firing until the cutscene is done
ga_attacker_player:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_attacker_player:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
ga_enemy_git_guzzler:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_enemy_git_guzzler:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);
ga_enemy_skarsniks_skulkers:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_enemy_skarsniks_skulkers:change_behaviour_active_on_message("wev_bin_rumbled_ladz", "fire_at_will", true, true);

-- time offsets
gb:message_on_time_offset("release_all", 420000,"01_intro_cutscene_end");
gb:message_on_time_offset("release_da_squigs", 60000,"chaaarge");
gb:message_on_time_offset("wev_bin_rumbled_ladz", 1000,"time_to_strike");   --so objective and other bits always trigger regardless of discovered or time_to_strike is called

--da meaty bitz
ga_enemy_git_guzzler:message_on_casualties("send_in_da_squigs", 0.5);
ga_enemy_git_guzzler:message_on_casualties("time_to_strike", 0.4);
ga_enemy_skarsniks_skulkers:attack_on_message("time_to_strike");
--ga_enemy_skarsniks_skulkers:attack_force_on_message("time_to_strike", ga_enemy_git_guzzler, 1000) -- can't heckin attack yer own allies so no free for all action :(
ga_enemy_squig_stampede:reinforce_on_message("send_in_da_squigs");
ga_enemy_squig_stampede:message_on_deployed("chaaarge");
ga_enemy_squig_stampede:attack_on_message("chaaarge");

ga_enemy_skarsniks_skulkers:message_on_proximity_to_enemy("wev_bin_rumbled_ladz", 20);
gb:message_on_time_offset("block_wev_bin_rumbled_ladz", 3000,"wev_bin_rumbled_ladz");
gb:block_message_on_message("block_wev_bin_rumbled_ladz", "wev_bin_rumbled_ladz", true)

--ga_enemy_git_guzzler:message_on_casualties("right_whos_next", 0.8);
--ga_enemy_skarsniks_skulkers:attack_on_message("right_whos_next");

ga_enemy_skarsniks_skulkers:message_on_casualties("cheez_it_ladz", 0.8);
ga_enemy_skarsniks_skulkers:rout_over_time_on_message("cheez_it_ladz", 30000)
ga_enemy_skarsniks_skulkers:message_on_rout_proportion("propa_cheezed", 1)
ga_enemy_git_guzzler:message_on_commander_dead_or_shattered("got_da_git", 1);
ga_attacker_player:message_on_commander_death("heck_it_grom", 1);

-- releases
ga_enemy_git_guzzler:release_on_message("release_all");
ga_enemy_skarsniks_skulkers:release_on_message("release_all");
ga_enemy_skarsniks_skulkers:release_on_message("wev_bin_rumbled_ladz");
ga_enemy_squig_stampede:release_on_message("release_all");
ga_enemy_squig_stampede:release_on_message("release_da_squigs");

--skarsnik should be rout early and be invulnerable once doing so
ga_enemy_skarsniks_skulkers:message_on_commander_dead_or_routing("cheez_it_ladz")
--generated_army:set_invincible_on_message(string message)  -- this effects the whole darn army so not really that useful
-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc15_qb_grn_grom_axe_of_grom_objective_01");
gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc15_qb_grn_grom_axe_of_grom_objective_02");
gb:set_objective_on_message("wev_bin_rumbled_ladz", "wh2_dlc15_qb_grn_grom_axe_of_grom_objective_03");

gb:complete_objective_on_message("got_da_git", "wh2_dlc15_qb_grn_grom_axe_of_grom_objective_01", 5);
gb:complete_objective_on_message("propa_cheezed", "wh2_dlc15_qb_grn_grom_axe_of_grom_objective_03", 5);

gb:fail_objective_on_message("heck_it_grom", "wh2_dlc15_qb_grn_grom_axe_of_grom_objective_02", 5);
-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("wev_bin_rumbled_ladz", "wh2_dlc15_qb_grn_grom_axe_of_grom_hint_reinforcements", 6000, nil, 5000);
gb:queue_help_on_message("send_in_da_squigs", "wh2_dlc15_qb_grn_grom_axe_of_grom_hint_squig_stampede", 6000, nil, 5000);

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------