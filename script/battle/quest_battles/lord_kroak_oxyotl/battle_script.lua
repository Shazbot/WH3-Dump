-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Oxyotl
-- Lord Kroak

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
intro_cinematic_file = "script\\battle\\quest_battles\\_cutscene\\managers\\krk.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);

--Composite Scenes For Lord Kroak's force field and "teleport flash"
kroak_cs = "composite_scene/battle_props/lord_kroak_qb.csc";
flash_cs = "composite_scene/battle_props/lord_kroak_enter_qb_.csc";
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh2_main_sfx_01 = new_sfx("Play_wh2_dlc12_lzd_lordkroak_qb_pt_01");
wh2_main_sfx_03 = new_sfx("Play_wh2_dlc12_lzd_lordkroak_qb_pt_03");
wh2_main_sfx_04 = new_sfx("Play_wh2_dlc12_lzd_lordkroak_qb_pt_04");
-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

ga_attacker_01 = gb:get_army(gb:get_player_alliance_num(), 1, "");
ga_player_reinf_01 = gb:get_army(gb:get_player_alliance_num(),"lord_kroak_guardians");
ga_player_reinf_02 = gb:get_army(gb:get_player_alliance_num(),"lord_kroak");
ga_enemy = gb:get_army(gb:get_non_player_alliance_num(),"enemy_army");
ga_enemy_reinforcements = gb:get_army(gb:get_non_player_alliance_num(),"enemy_reinforcements");
ga_enemy_reinforcements_2 = gb:get_army(gb:get_non_player_alliance_num(),"enemy_reinforcements_2");

-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------

function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");
	
--teleport unit (1) of ga_artillery to [450, 20] with an orientation of 45 degrees and a width of 25m
--ga_artillery.sunits:item(1).uc:teleport_to_location(v(-310, 290), 180, 25);

	
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
		ga_attacker_01.sunits,					-- unitcontroller over player's army
		32000, 									-- duration of cutscene in ms
		function() intro_cutscene_end() end		-- what to call when cutscene is finished
	);
	
	local player_units_hidden = false;
	
	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
		
	cutscene_intro:set_post_cutscene_fade_time(3.0, 3200);
	
	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()		
			local cam = bm:camera();
			bm:stop_cindy_playback(true);		
			if player_units_hidden then
				ga_attacker_01:set_enabled(true)
			end;
		end
	);
	
	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	
	-- cutscene_intro:action(function() cam:move_to(v(-781.747, 84.081, 5.09), v(-770.503, 81.635, 21.587), 0, false, 30) end, 0);	

	cutscene_intro:action(function() bm:cindy_playback("script\\battle\\quest_battles\\_cutscene\\managers\\krk.CindySceneManager", 0, 2) end, 680);
	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_attacker_01:set_enabled(true) 
		end, 
		200
	);	
	
	-- Voiceover and Subtitles --
	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_01); bm:queue_advisor("wh2.dlc12.lzd.lordkroak.qb.pt.01"); end, 2500);	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_03); bm:queue_advisor("wh2.dlc12.lzd.lordkroak.qb.pt.03"); end, 14000);	
	cutscene_intro:action(function() cutscene_intro:play_sound(wh2_main_sfx_04); bm:queue_advisor("wh2.dlc12.lzd.lordkroak.qb.pt.04"); end, 23500);	
		
	cutscene_intro:start();
	
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
end;


-------------------------------------------------------------------------------------------------
------------------------------------------ ORDERS -------------------------------------------
-------------------------------------------------------------------------------------------------
ga_attacker_01:message_on_rout_proportion("player_loses", 1);
ga_player_reinf_02:message_on_rout_proportion("kroak_hurt", 1);

--Stopping player from firing until the cutscene is done
ga_attacker_01:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
gb:start_terrain_composite_scene_on_message("battle_started", kroak_cs);
ga_attacker_01:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

--reinforcement 1 messages
gb:message_on_time_offset("reinforce", 180000);
gb:message_on_time_offset("reinforcement_defend", 181000);
gb:message_on_time_offset("reinforcement_release", 400000);
ga_enemy_reinforcements:message_on_proximity_to_enemy("enemy_reinf_close", 150);
ga_enemy_reinforcements:message_on_casualties("reinforcement_dying", 0.05);

--composite scene timers
gb:message_on_time_offset("start_cs", 530900);
gb:message_on_time_offset("stop_cs", 531000);
gb:message_on_time_offset("stop_cs_2", 534000);

--kroak messages

gb:message_on_time_offset("kroak_guardians", 550000);
gb:message_on_time_offset("kroak", 560000);
gb:message_on_time_offset("kroak_guardians_release", 560000);
gb:message_on_time_offset("kroak_release", 570000);

--reinforcement 2 messages
gb:message_on_time_offset("reinforce_2", 400000);
gb:message_on_time_offset("reinforce_2_defend", 405000);
gb:message_on_time_offset("reinforce_2_release", 500000);
ga_enemy_reinforcements_2:message_on_proximity_to_enemy("enemy_reinf_2_close", 150);
ga_enemy_reinforcements:message_on_casualties("reinforcement_2_dying", 0.05);

--main enemy messages
ga_enemy:message_on_proximity_to_enemy("enemy_main_close", 150);
gb:message_on_time_offset("enemy_release", 400000);
ga_enemy:message_on_casualties("enemy_dying", 0.05);

--toggling composite scenes for flash
gb:stop_terrain_composite_scene_on_message("stop_cs", kroak_cs);
gb:start_terrain_composite_scene_on_message("start_cs", flash_cs);
gb:stop_terrain_composite_scene_on_message("stop_cs_2", flash_cs);

--main orders
ga_enemy:defend_on_message("01_intro_cutscene_end", 0, 160, 100); 
ga_enemy:attack_on_message("enemy_main_close");
ga_enemy:release_on_message("enemy_release");
ga_enemy:release_on_message("enemy_dying");

--reinforcement 1 orders
ga_enemy_reinforcements:reinforce_on_message("reinforce", 10);
ga_enemy_reinforcements:release_on_message("reinforcement_release");
ga_enemy_reinforcements:release_on_message("enemy_reinf_close");
ga_enemy_reinforcements:release_on_message("reinforcement_dying");

--reinforcement 2 orders
ga_enemy_reinforcements_2:reinforce_on_message("reinforce_2", 10);
ga_enemy_reinforcements_2:defend_on_message("reinforce_2_defend", -270, 170, 100); 
ga_enemy_reinforcements_2:attack_on_message("enemy_reinf_2_close");
ga_enemy_reinforcements_2:attack_on_message("reinforcement_2_dying");
ga_enemy_reinforcements_2:release_on_message("reinforce_2_release");

--kroak orders
ga_player_reinf_01:reinforce_on_message("kroak_guardians", 10);
ga_player_reinf_02:reinforce_on_message("kroak", 1);
ga_player_reinf_01:release_on_message("kroak_guardians_release");
ga_player_reinf_02:release_on_message("kroak_release");



-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------
ga_attacker_01:message_on_victory("player_wins");


gb:set_objective_on_message("01_intro_cutscene_end", "wh2_dlc12_lord_kroak_first_objective");
gb:set_objective_on_message("kroak", "wh2_dlc12_lord_kroak_dont_lose_kroak_objective");
gb:complete_objective_on_message("start_cs", "wh2_dlc12_lord_kroak_first_objective", 5000);
gb:set_objective_on_message("kroak", "wh2_dlc12_lord_kroak_stayin_alive_objective");

gb:complete_objective_on_message("player_wins", "wh2_dlc12_lord_kroak_dont_lose_kroak_objective", 5000);
gb:complete_objective_on_message("player_wins", "wh2_dlc12_lord_kroak_stayin_alive_objective", 5000);
-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc12_lord_kroak_hint", 6000, nil, 5000);
gb:queue_help_on_message("reinforce", "wh2_dlc12_lord_kroak_reinforce_1_hint", 6000, nil, 5000);
gb:queue_help_on_message("reinforce_2", "wh2_dlc12_lord_kroak_reinforce_2_hint", 6000, nil, 5000);
gb:queue_help_on_message("start_cs", "wh2_dlc12_lord_kroak_reinforce_kroak_hint", 6000, nil, 5000);
-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------


ga_enemy:force_victory_on_message("player_loses", 15000); 
ga_enemy:force_victory_on_message("kroak_hurt", 15000); 
gb:queue_help_on_message("player_loses", "wh2_dlc12_lord_kroak_stayin_alive_fail_hint", 6000, nil, 5000);
gb:queue_help_on_message("kroak_hurt", "wh2_dlc12_lord_kroak_dont_lose_kroak_fail_hint", 6000, nil, 5000);