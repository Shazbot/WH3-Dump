-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Aranessa
-- Krakens Bane
-- INSERT ENVIRONMENT NAME
-- Defender

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

--players army = player_army
--empire reinforcements = empire_reinforcements
--enemy main army = enemy_main
--enemy vanguard army = enemy_vanguard
--enemy flanking army = enemy_flankers

load_script_libraries();                            -- Load all our script libraries so lua can access our battle logic

bm:camera():fade(true, 0);
     
gb = generated_battle:new(                          	-- Load a generated battle, used for scripted battles.
    true,                                          		-- screen starts black
    false,                                          	-- prevent deployment
	true,                                      			-- prevent deployment for ai
    function() end_deployment_phase() end,              -- intro cutscene function
    false                                           	-- debug mode
);

--preload 
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\krb.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc11_aranessa_saltspite_qb_krakens_bane_pt_01");
wh2_main_sfx_02 = new_sfx("Play_wh2_dlc11_aranessa_saltspite_qb_krakens_bane_pt_02");
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc11_aranessa_saltspite_qb_krakens_bane_pt_03");

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------
ga_player = gb:get_army(gb:get_player_alliance_num(), 1);
ga_defender_1 = gb:get_army(gb:get_player_alliance_num(), 2, "empire_reinforcements");

ga_attacker_1 = gb:get_army(gb:get_non_player_alliance_num(), 1,"enemy_main");
ga_attacker_2 = gb:get_army(gb:get_non_player_alliance_num(), 2,"enemy_vanguard");
ga_attacker_3 = gb:get_army(gb:get_non_player_alliance_num(), 2,"enemy_flankers");



ga_defender_1:reinforce_on_message("player_hurt", 500);		-- Enter as Reinforcements when the following message is received, reinforcements_arrive


-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------

--have to teleport units as it is not possible to hide their deployment zone from the player in prebattle screen

function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");
	
--	teleport unit (1) of ga_attacker_3 to [428, -662] with an orientation of 45 degrees and a width of 25m
	ga_attacker_3.sunits:item(1).uc:teleport_to_location(v(428, -162), 180, 25);
--	teleport unit (2) of ga_attacker_3 to [448, -662] with an orientation of 45 degrees and a width of 25m
	ga_attacker_3.sunits:item(2).uc:teleport_to_location(v(448, -162), 180, 25);
--	teleport unit (3) of ga_attacker_3 to [517, -841] with an orientation of 45 degrees and a width of 25m
	ga_attacker_3.sunits:item(3).uc:teleport_to_location(v(517, -341), 180, 25);
--	teleport unit (4) of ga_attacker_3 to [517, -841] with an orientation of 45 degrees and a width of 25m
	ga_attacker_3.sunits:item(4).uc:teleport_to_location(v(517, -341), 180, 25);

	
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
		ga_player.sunits,					-- unitcontroller over player's army
		35000, 									-- duration of cutscene in ms
		function() intro_cutscene_end() end		-- what to call when cutscene is finished
	);
	
	local player_units_hidden = false;
	
	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
		
	cutscene_intro:set_post_cutscene_fade_time(1.5, 500);
	
	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()		
			local cam = bm:camera();
			bm:stop_cindy_playback(true);		
			if player_units_hidden then
				ga_player:set_enabled(true)
			end;
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\krb.CindySceneManager", true) end, 200);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_attacker_1:set_enabled(true) 
		end, 
		200
	);	
	
	
	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01) end, 3000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc11_Aranessa_Saltspite_QB_Krakens_Bane_pt_01", "subtitle_with_frame", 4) end, 3250);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 12000);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_02) end, 12500);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc11_Aranessa_Saltspite_QB_Krakens_Bane_pt_02", "subtitle_with_frame", 8) end, 13000);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 24500);
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03) end, 26000);	
	cutscene_intro:action(function() cutscene_intro:show_custom_cutscene_subtitle("scripted_subtitles_localised_text_wh2_dlc11_Aranessa_Saltspite_QB_Krakens_Bane_pt_03", "subtitle_with_frame", 3) end, 26500);	
	cutscene_intro:action(function() cutscene_intro:hide_custom_cutscene_subtitles() end, 30000);
	
	cutscene_intro:start();

	
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;


-------------------------------------------------------------------------------------------------
------------------------------------------ ORDERS -------------------------------------------
-------------------------------------------------------------------------------------------------
--Stopping player from firing until the cutscene is done
	ga_player:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
	ga_player:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

--message on player hurt 30%
	ga_player:message_on_casualties("player_hurt", 0.3);	
	
--message 45 seconds after cutscene end
	gb:message_on_time_offset("begin_flank", 45000, "01_intro_cutscene_end");
	
--generate attack message for main army after cutscene finishes	
	ga_attacker_1:attack_on_message("01_intro_cutscene_end", 500);
	ga_attacker_2:attack_on_message("01_intro_cutscene_end", 500);
	
--generate attack message for teleported units after 30 seconds (this will be followed by advice in 5 more seconds)
	ga_attacker_3:move_to_position_on_message("begin_flank", v(236, 294, -785));
	
	ga_attacker_3:release_on_message("begin_flank", 5000);
	
--generate attack message for reinforcements after they arrive
	ga_defender_1:release_on_message("player_hurt", 1500);

if ga_attacker_1.sunits:is_in_melee() then
	ga_attacker_1.sunits:release_control();
end;
if ga_attacker_2.sunits:is_in_melee() then
	ga_attacker_2.sunits:release_control();
end;

-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc11_cst_aranessa_krakens_bane_stage_5_hints_main_objective"); 

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc11_cst_aranessa_krakens_bane_stage_5_hints_start_battle");
gb:queue_help_on_message("begin_flank", "wh2_dlc11_cst_aranessa_krakens_bane_stage_5_hints_flankers");
gb:queue_help_on_message("reinforcements_arrive", "wh2_dlc11_cst_aranessa_krakens_bane_stage_5_hints_reinforcements");

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------