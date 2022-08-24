-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Prologue
-- Brazen Altar
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();

package.path = "script/battle/?.lua;"
require("wh3_battle_prologue_values");

--bm:camera():fade(true, 0);

gb = generated_battle:new(
	false,                                      		-- screen starts black
	true,                                      		-- prevent deployment for player
	true,                                      		-- prevent deployment for ai
	nil,          -- intro cutscene function
	false                                      		-- debug mode
);

-- Hide start battle button.
bm:show_start_battle_button(false)

-- Stop camera movement.
bm:enable_camera_movement(false)

--preload stuttering fix
intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/bba.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);
-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------

wh3_main_sfx_01 = new_sfx("play_wh3_main_prologue_qb_brazen_altar_001_1");
wh3_main_sfx_02 = new_sfx("play_wh3_main_prologue_qb_brazen_altar_002_1");
wh3_main_sfx_03 = new_sfx("play_wh3_main_prologue_qb_brazen_altar_003_1");
wh3_main_sfx_04 = new_sfx("play_wh3_main_prologue_qb_brazen_altar_004_1");


-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------
function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
		
	local cam = bm:camera();
	
	-- declare cutscene
	local cutscene_intro = cutscene:new_from_cindyscene(
		"cutscene_intro", 																-- unique string name for cutscene
		ga_attacker_01.sunits,															-- unitcontroller over player's army
		function() cam:fade(false, 1) end,																			-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/bba.CindySceneManager",			-- path to cindyscene
		0,																				-- blend in time (s)
		0																				-- blend out time (s)
	);

	local player_units_hidden = false;
	
	-- set up subtitles
	local subtitles = cutscene_intro:subtitles();
	subtitles:set_alignment("bottom_centre");
	subtitles:clear();
	
	-- skip callback
	cutscene_intro:set_skippable(
		true, 
		function()
			bm:stop_cindy_playback(true);
			
			if player_units_hidden then
				ga_attacker_01:set_enabled(true)
			end;
						
			bm:hide_subtitles();

			bm:show_start_battle_button(true)
		end
	);
	
	--cutscene_intro:set_post_cutscene_fade_time(-0.1)
	-- set up actions on cutscene
	--cutscene_intro:action(function() cam:fade(false, 1) end, 1000);
	cutscene_intro:action(function() cam:fade(true, 1) end, 50594); --52.3s

	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_defender_01:set_enabled(true) 
		end, 
		200
	);	
	
	-- Voiceover and Subtitles --
	-- I need – Ursun needs – that Altar!
	cutscene_intro:add_cinematic_trigger_listener(
		"start_cinematic", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_prologue_qb_brazen_altar_001_1"));
				bm:show_subtitle("wh3_main_prologue_qb_brazen_altar_001", false, true);
			end
	);

	-- But it is defended by one of the Blood God's wretched pets!
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_prologue_qb_brazen_altar_002", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_prologue_qb_brazen_altar_002_1"));
				bm:show_subtitle("wh3_main_prologue_qb_brazen_altar_002", false, true);
			end
	);

	-- You will fight, and some may die, for the Blood God demands blood and we shall gladly give it!
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_prologue_qb_brazen_altar_03", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_prologue_qb_brazen_altar_003_1"));
				bm:show_subtitle("wh3_main_prologue_qb_brazen_altar_003", false, true);
			end
	);

	-- All that matters is reaching the shrine.
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_prologue_qb_brazen_altar_04", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_prologue_qb_brazen_altar_004_1"));
				bm:show_subtitle("wh3_main_prologue_qb_brazen_altar_004", false, true);
			end
	);

	cutscene_intro:start();
end;

bm:register_phase_change_callback(
    "Deployed",
	function()
		local cam = bm:camera();
		cam:fade(false, 1)
		
		gb.sm:trigger_message("01_intro_cutscene_end")
    end
);

-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------
--Player Army
ga_attacker_01 = gb:get_army(gb:get_player_alliance_num(), 1);
--Enemy Armies
ga_defender_01 = gb:get_army(gb:get_non_player_alliance_num(), "defender"); -- Defending the Altar
ga_defender_sim = gb:get_army(gb:get_non_player_alliance_num(), "simaergul"); -- Simaergul's army
ga_defender_scout = gb:get_army(gb:get_non_player_alliance_num(), "scout"); -- Hound scouts

ga_defender_reinforcements_1 = gb:get_army(gb:get_non_player_alliance_num(), "reinforcements_1");
ga_defender_reinforcements_2 = gb:get_army(gb:get_non_player_alliance_num(), "reinforcements_2");
ga_defender_reinforcements_3 = gb:get_army(gb:get_non_player_alliance_num(), "reinforcements_3");
ga_defender_reinforcements_4 = gb:get_army(gb:get_non_player_alliance_num(), "reinforcements_4");
ga_defender_reinforcements_5 = gb:get_army(gb:get_non_player_alliance_num(), "reinforcements_5");
ga_defender_reinforcements_6 = gb:get_army(gb:get_non_player_alliance_num(), "reinforcements_6");

ga_defender_pack_hound_1 = gb:get_army(gb:get_non_player_alliance_num(), "pack_hound_1");
ga_defender_pack_hound_2 = gb:get_army(gb:get_non_player_alliance_num(), "pack_hound_2");
ga_defender_pack_hound_3 = gb:get_army(gb:get_non_player_alliance_num(), "pack_hound_3");

-- build spawn zone collections
sz_collection_1 = bm:get_spawn_zone_collection_by_name("defender_reinforcements_01");
sz_collection_2 = bm:get_spawn_zone_collection_by_name("defender_reinforcements_02");
sz_collection_3 = bm:get_spawn_zone_collection_by_name("defender_reinforcements_03");
sz_collection_4 = bm:get_spawn_zone_collection_by_name("defender_reinforcements_04");
sz_collection_5 = bm:get_spawn_zone_collection_by_name("defender_reinforcements_05");
sz_collection_6 = bm:get_spawn_zone_collection_by_name("defender_reinforcements_06");

-- assign reinforcement armies to spawn zones

ga_defender_pack_hound_1:assign_to_spawn_zone_from_collection_on_message("battle_started", sz_collection_1, false); -- Hound Pack 01 (West)
ga_defender_pack_hound_2:assign_to_spawn_zone_from_collection_on_message("battle_started", sz_collection_2, false); -- Hound Pack 02 (North West)
ga_defender_pack_hound_3:assign_to_spawn_zone_from_collection_on_message("battle_started", sz_collection_4, false); -- Hound Pack 03 (East)
ga_defender_reinforcements_1:assign_to_spawn_zone_from_collection_on_message("battle_started", sz_collection_1, false); 
ga_defender_reinforcements_2:assign_to_spawn_zone_from_collection_on_message("battle_started", sz_collection_2, false); 
ga_defender_reinforcements_3:assign_to_spawn_zone_from_collection_on_message("battle_started", sz_collection_4, false); 
ga_defender_reinforcements_4:assign_to_spawn_zone_from_collection_on_message("battle_started", sz_collection_3, false); -- Reinforcements for Simaergul's army
ga_defender_reinforcements_5:assign_to_spawn_zone_from_collection_on_message("battle_started", sz_collection_5, false); -- Reinforcements appear behind player
ga_defender_reinforcements_6:assign_to_spawn_zone_from_collection_on_message("battle_started", sz_collection_6, false); -- Reinforcements appear behind player


YuriInvulernableWhenRouting() -- Stop Yuri from being wounded.

-- Print slots
bm:print_toggle_slots()

-------Gates-------
ga_attacker_01:enable_map_barrier_on_message("open_map_barrier_1", "map_barrier_1", false);
ga_attacker_01:enable_map_barrier_on_message("open_map_barrier_2", "map_barrier_2", false);
ga_attacker_01:enable_map_barrier_on_message("open_map_barrier_3", "map_barrier_3", false);
ga_attacker_01:enable_map_barrier_on_message("open_map_barrier_4", "map_barrier_4", false);

-- Setup player deployment
bm:register_phase_change_callback(
        "Deployment", 
        function()
			bm:enable_camera_movement(true)
			
            local v_top_left = v(230, 0);
            local formation_width = 400;
 
            local sunits_player = bm:get_scriptunits_for_local_players_army();
            local uc = sunits_player:get_unitcontroller();
 
			uc:goto_location_angle_width(v_top_left, 270, formation_width);
			uc:change_group_formation("test_melee_forward_simple");

			--Yuri Barkov
			ga_attacker_01.sunits:item(1).uc:teleport_to_location(v(220, -4), 270, 1.4);

			--Zorya Solovyov
			if ga_attacker_01:are_unit_types_in_army("wh3_main_pro_ksl_cha_frost_maiden_ice_0") then
				ga_attacker_01.sunits:get_sunit_by_type("wh3_main_pro_ksl_cha_frost_maiden_ice_0").uc:teleport_to_location(v(220, 1), 270, 1.4);
			end

			if ga_attacker_01:are_unit_types_in_army("wh3_main_pro_ksl_cha_frost_maiden_ice_1") then
				ga_attacker_01.sunits:get_sunit_by_type("wh3_main_pro_ksl_cha_frost_maiden_ice_1").uc:teleport_to_location(v(220, 1), 270, 1.4);
			end	
			
			if ga_attacker_01:are_unit_types_in_army("wh3_main_pro_ksl_cha_frost_maiden_ice_2") then
				ga_attacker_01.sunits:get_sunit_by_type("wh3_main_pro_ksl_cha_frost_maiden_ice_2").uc:teleport_to_location(v(220, 1), 270, 1.4);
			end	
            uc:release_control();

			core:progress_on_loading_screen_dismissed(function() end_deployment_phase() end)
        end
    );


-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------
function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");

----------------------------------- Player Deployment Setup -------------------------------------



----------------------------------- Enemy Deployment Setup -------------------------------------

--Defender Army

--Herald of Khorne
ga_defender_01.sunits:item(1).uc:teleport_to_location(v(-188.65, 13.06), 90, 1.6);
--Bloodletters
ga_defender_01.sunits:item(2).uc:teleport_to_location(v(-156.65, 50.06), 90, 35);
--Bloodletters
ga_defender_01.sunits:item(3).uc:teleport_to_location(v(-156.65, 13.06), 90, 35);
--Bloodletters
ga_defender_01.sunits:item(4).uc:teleport_to_location(v(-156.65, -23.94), 90, 35);
--Minotaurs
ga_defender_01.sunits:item(5).uc:teleport_to_location(v(-193.95, -17.93), 90, 31.98);
--Minotaurs
ga_defender_01.sunits:item(6).uc:teleport_to_location(v(-193.95, 43.9), 90, 31.98);


--Simaergul
ga_defender_sim.sunits:item(1).uc:teleport_to_location(v(-356, 294), 135, 1.4);
--ga_defender_sim.sunits:item(1).uc:morale_behavior_fearless();

--ga_defender_reinforcements_4.sunits:item(1).uc:morale_behavior_fearless();
--ga_defender_reinforcements_4.sunits:item(2).uc:morale_behavior_fearless();
--ga_defender_reinforcements_4.sunits:item(3).uc:morale_behavior_fearless();

--Scout Hounds
ga_defender_scout.sunits:item(1).uc:teleport_to_location(v(-118, 58.06), 90, 32);
ga_defender_scout.sunits:item(2).uc:teleport_to_location(v(-118, 13.06), 90, 32);
ga_defender_scout.sunits:item(3).uc:teleport_to_location(v(-118, -32.94), 90, 32);
ga_defender_scout.sunits:item(4).uc:teleport_to_location(v(-118, -77.94), 90, 32);
ga_defender_scout.sunits:item(5).uc:teleport_to_location(v(-118, 103.06), 90, 32);


end;

battle_start_teleport_units();


-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------
--ga_defender_01:release_on_message("01_intro_cutscene_end");

--ga_defender_01 (main army)
ga_defender_01:halt();
ga_defender_01:message_on_under_attack("attack");
ga_defender_01:attack_on_message("attack");
ga_defender_01:message_on_proximity_to_enemy("attack", 175);
ga_defender_01:message_on_casualties("reinforce_rear", 0.1);
ga_defender_01:message_on_casualties("reinforce", 0.5);
ga_defender_01:prevent_rallying_if_routing_on_message("attack");
ga_defender_01:message_on_rout_proportion("defender_01_defeated", 1);
ga_defender_01:rout_over_time_on_message("simaergul_defeated", 2000)

--ga_defender_scout (Hound Scouts)
ga_defender_scout:halt();
ga_defender_scout:rush_on_message("01_intro_cutscene_end");
ga_defender_scout:message_on_shattered_proportion("defender_scout_defeated", 1);
ga_defender_scout:prevent_rallying_if_routing_on_message("01_intro_cutscene_end");
ga_defender_scout:message_on_rout_proportion("defender_scout_defeated", 1);
ga_defender_scout:rout_over_time_on_message("simaergul_defeated", 2000)

--ga_defender_sim
ga_defender_sim:halt();

ga_defender_sim:set_enabled_on_message("01_intro_cutscene_end", false);
ga_defender_sim:set_enabled_on_message("one_hound_defeated", true);

--ga_defender_sim:set_invincible_on_message("01_intro_cutscene_end", true);
--ga_defender_sim:set_invincible_on_message("one_hound_defeated", false);

ga_defender_sim:rush_on_message("one_hound_defeated");
ga_defender_sim:prevent_rallying_if_routing_on_message("one_hound_defeated");
ga_defender_sim:message_on_rout_proportion("simaergul_defeated", 1);
ga_defender_sim.sunits:morale_behavior_fearless()


--Reinforcements

--ga_defender_reinforcements_01
ga_defender_reinforcements_1:reinforce_on_message("defenders_defeated"); 
ga_defender_reinforcements_1:message_on_deployed("reinforcements_01_deployed");
ga_defender_reinforcements_1:attack_on_message("reinforcements_01_deployed");
ga_defender_reinforcements_1:prevent_rallying_if_routing_on_message("reinforcements_01_deployed");
ga_defender_reinforcements_1:message_on_rout_proportion("ga_reinforcements_1_defeated", 1);
ga_defender_reinforcements_1:rout_over_time_on_message("simaergul_defeated", 2000)

--ga_defender_reinforcements_02
ga_defender_reinforcements_2:reinforce_on_message("defenders_defeated"); 
ga_defender_reinforcements_2:message_on_deployed("reinforcements_02_deployed");
ga_defender_reinforcements_2:rush_on_message("reinforcements_02_deployed");
ga_defender_reinforcements_2:prevent_rallying_if_routing_on_message("reinforcements_02_deployed");
ga_defender_reinforcements_2:message_on_rout_proportion("ga_reinforcements_2_defeated", 1);
ga_defender_reinforcements_2:rout_over_time_on_message("simaergul_defeated", 2000)

--ga_defender_reinforcements_03
ga_defender_reinforcements_3:reinforce_on_message("defenders_defeated");
ga_defender_reinforcements_3:message_on_deployed("reinforcements_03_deployed");
ga_defender_reinforcements_3:rush_on_message("reinforcements_03_deployed");
ga_defender_reinforcements_3:prevent_rallying_if_routing_on_message("reinforcements_03_deployed");
ga_defender_reinforcements_3:message_on_rout_proportion("ga_reinforcements_3_defeated", 1);
ga_defender_reinforcements_3:rout_over_time_on_message("simaergul_defeated", 2000)

--ga_defender_reinforcements_04
ga_defender_reinforcements_4:reinforce_on_message("one_hound_defeated");
ga_defender_reinforcements_4:message_on_deployed("reinforcements_04_deployed");
ga_defender_reinforcements_4:rush_on_message("reinforcements_04_deployed");
ga_defender_reinforcements_4:prevent_rallying_if_routing_on_message("reinforcements_04_deployed");
ga_defender_reinforcements_4:message_on_rout_proportion("ga_reinforcements_4_defeated", 1);
ga_defender_reinforcements_4.sunits:morale_behavior_fearless()
ga_defender_reinforcements_4:rout_over_time_on_message("simaergul_defeated", 2000)

--ga_defender_reinforcements_05
ga_defender_reinforcements_5:reinforce_on_message("reinforce_rear");
ga_defender_reinforcements_5:message_on_deployed("reinforcements_05_deployed");
ga_defender_reinforcements_5:rush_on_message("reinforcements_05_deployed");
ga_defender_reinforcements_5:prevent_rallying_if_routing_on_message("reinforcements_05_deployed");
ga_defender_reinforcements_5:message_on_rout_proportion("ga_reinforcements_5_defeated", 1);
ga_defender_reinforcements_5:rout_over_time_on_message("simaergul_defeated", 2000)

--ga_defender_reinforcements_06
ga_defender_reinforcements_6:reinforce_on_message("reinforce_rear");
ga_defender_reinforcements_6:message_on_deployed("reinforcements_06_deployed");
ga_defender_reinforcements_6:rush_on_message("reinforcements_06_deployed");
ga_defender_reinforcements_6:prevent_rallying_if_routing_on_message("reinforcements_06_deployed");
ga_defender_reinforcements_6:message_on_rout_proportion("ga_reinforcements_6_defeated", 1);
ga_defender_reinforcements_6:rout_over_time_on_message("simaergul_defeated", 2000)


--ga_defender_reinforcements_pack_hound_1
ga_defender_pack_hound_1:reinforce_on_message("defenders_defeated"); 
ga_defender_pack_hound_1:message_on_deployed("pack_hound_01_deployed");
ga_defender_pack_hound_1:rush_on_message("pack_hound_01_deployed");
ga_defender_pack_hound_1:prevent_rallying_if_routing_on_message("pack_hound_01_deployed");
ga_defender_pack_hound_1:message_on_rout_proportion("hound_01_defeated", 1);
ga_defender_pack_hound_1:rout_over_time_on_message("simaergul_defeated", 2000)

--ga_defender_reinforcements_pack_hound_2
ga_defender_pack_hound_2:reinforce_on_message("defenders_defeated"); 
ga_defender_pack_hound_2:message_on_deployed("pack_hound_02_deployed");
ga_defender_pack_hound_2:rush_on_message("pack_hound_02_deployed");
ga_defender_pack_hound_2:prevent_rallying_if_routing_on_message("pack_hound_02_deployed");
ga_defender_pack_hound_2:message_on_rout_proportion("hound_02_defeated", 1);
ga_defender_pack_hound_2:rout_over_time_on_message("simaergul_defeated", 2000)

--ga_defender_reinforcements_pack_hound_3
ga_defender_pack_hound_3:reinforce_on_message("defenders_defeated"); 
ga_defender_pack_hound_3:message_on_deployed("pack_hound_03_deployed");
ga_defender_pack_hound_3:rush_on_message("pack_hound_03_deployed");
ga_defender_pack_hound_3:prevent_rallying_if_routing_on_message("pack_hound_03_deployed");
ga_defender_pack_hound_3:message_on_rout_proportion("hound_03_defeated", 1);
ga_defender_pack_hound_3:rout_over_time_on_message("simaergul_defeated", 2000)


------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------
--Defeat the Khorne forces guarding the altar
gb:set_objective_on_message("01_intro_cutscene_end", "wh3_main_qb_prologue_ksl_yuri_brazen_altar_hints_main_objective_1");
ga_defender_01:add_ping_icon_on_message("01_intro_cutscene_end", 15, 1, 10000);

gb:message_on_all_messages_received("defenders_defeated", "defender_01_defeated", "defender_scout_defeated", "ga_reinforcements_5_defeated", "ga_reinforcements_6_defeated");
gb:remove_objective_on_message("defenders_defeated", "wh3_main_qb_prologue_ksl_yuri_brazen_altar_hints_main_objective_1");


--Defeat one of Simaergul's Pack
gb:set_objective_on_message("defenders_defeated", "wh3_main_qb_prologue_ksl_yuri_brazen_altar_hints_main_objective_2_0", 2000);
ga_defender_pack_hound_1:add_ping_icon_on_message("pack_hound_01_deployed", 15, 1, 20000); --Pack Hound 01
ga_defender_pack_hound_2:add_ping_icon_on_message("pack_hound_02_deployed", 15, 1, 20000); --Pack Hound 02
ga_defender_pack_hound_3:add_ping_icon_on_message("pack_hound_03_deployed", 15, 1, 20000); --Pack Hound 03

gb:message_on_any_message_received("one_hound_defeated", "hound_01_defeated", "hound_02_defeated", "hound_03_defeated");

gb:remove_objective_on_message("one_hound_defeated", "wh3_main_qb_prologue_ksl_yuri_brazen_altar_hints_main_objective_2_0");
--gb:set_objective_on_message("one_hound_defeated", "wh3_main_qb_prologue_ksl_yuri_brazen_altar_hints_main_objective_2_1", 2000);

--gb:message_on_any_message_received("two_hounds_defeated", "hound_01_and_02_defeated", "hound_01_and_03_defeated", "hound_02_and_03_defeated");

--gb:message_on_all_messages_received("hound_01_and_02_defeated", "hound_01_defeated", "hound_02_defeated");
--gb:message_on_all_messages_received("hound_01_and_03_defeated", "hound_01_defeated", "hound_03_defeated");
--gb:message_on_all_messages_received("hound_02_and_03_defeated", "hound_01_defeated", "hound_03_defeated");

--gb:remove_objective_on_message("two_hounds_defeated", "wh3_main_qb_prologue_ksl_yuri_brazen_altar_hints_main_objective_2_1");
--gb:set_objective_on_message("two_hounds_defeated", "wh3_main_qb_prologue_ksl_yuri_brazen_altar_hints_main_objective_2_2", 2000);

--gb:message_on_all_messages_received("ga_hounds_defeated", "hound_01_defeated", "hound_02_defeated", "hound_03_defeated");

--gb:remove_objective_on_message("ga_hounds_defeated", "wh3_main_qb_prologue_ksl_yuri_brazen_altar_hints_main_objective_2_2");
--gb:set_objective_on_message("ga_hounds_defeated", "wh3_main_qb_prologue_ksl_yuri_brazen_altar_hints_main_objective_2_3", 2000);
--gb:remove_objective_on_message("ga_hounds_defeated", "wh3_main_qb_prologue_ksl_yuri_brazen_altar_hints_main_objective_2_3", 7000);

--Defeat Simaergul
gb:set_objective_on_message("one_hound_defeated", "wh3_main_qb_prologue_ksl_yuri_brazen_altar_hints_main_objective_3", 10000);
ga_defender_sim:add_ping_icon_on_message("one_hound_defeated", 15, 1, 2000, 10000);
gb:remove_objective_on_message("simaergul_defeated", "wh3_main_qb_prologue_ksl_yuri_brazen_altar_hints_main_objective_3");

-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------
--The Khorne guard the altar... they must be dealt with before we can perform the ritual
gb:queue_help_on_message("01_intro_cutscene_end", "wh3_main_qb_prologue_ksl_yuri_brazen_altar_hints_main_hint", 10000, 2000, 2000, false);

--Slay Simaergul's pack hounds to draw him out!
gb:queue_help_on_message("defenders_defeated", "wh3_main_qb_prologue_ksl_yuri_brazen_altar_hints_reinforcements_1", 10000, 2000, 2000, false);

--Simaergul is unleashed!
gb:queue_help_on_message("one_hound_defeated", "wh3_main_qb_prologue_ksl_yuri_brazen_altar_hints_reinforcements_2", 10000, 2000, 2000, false);

--Their general has been defeated but the true threat remains...
ga_defender_01:message_on_commander_dead_or_shattered("lord_dead");
gb:queue_help_on_message("lord_dead", "wh3_main_qb_prologue_ksl_yuri_brazen_altar_hints_lord_dead", 10000, 2000, 2000, false);

--Khorne reinforcements have entered the battlefield behind us!
gb:queue_help_on_message("reinforcements_05_deployed", "wh3_main_qb_prologue_ksl_yuri_brazen_altar_hints_reinforcements", 10000, 2000, 10000, false);
 
-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------
--Open map barriers
gb:message_on_all_messages_received("open_map_barrier_1", "defenders_defeated");
gb:message_on_all_messages_received("open_map_barrier_2", "defenders_defeated");
gb:message_on_all_messages_received("open_map_barrier_4", "defenders_defeated");

gb:message_on_all_messages_received("open_map_barrier_3", "one_hound_defeated");


-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------

--Set the variable to load the correct campaign script
bm:register_phase_change_callback(
    "Complete",
	function()
		local player_army = bm:get_scriptunits_for_local_players_army();
		local yuri = player_army:get_general_sunit();
		if bm:victorious_alliance() == yuri.alliance_num then
			bm:out("Player has won!");
		   -- set variable
		   core:svr_save_bool("sbool_load_khorne_campaign", true)
	
			common.setup_dynamic_loading_screen("prologue_battle_brazen_altar_outro", "prologue")
		else
			bm:out("Player has lost!");

			-- try and load in the prologue_next_quote value from the prologue campaign
			local prologue_next_quote = tostring(core:svr_load_string("prologue_next_quote"));
			if prologue_next_quote then
				bm:out("prologue_next_quote is " .. tostring(prologue_next_quote));
				common.set_custom_loading_screen_text("wh3_prologue_loading_screen_quote_"..prologue_next_quote);
			else
				bm:out("prologue_next_quote is not set");
			end;
		end;
    end
);

