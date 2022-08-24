-------------------------------------------------------------------------------------------------
------------------------------------------- KEY INFO --------------------------------------------
-------------------------------------------------------------------------------------------------

-- Kostaltyn
-- Boris Campaign Unlock
-- The Frozen Falls
-- Attacker

-------------------------------------------------------------------------------------------------
------------------------------------------- PRELOADS --------------------------------------------
-------------------------------------------------------------------------------------------------

load_script_libraries();

bm:camera():fade(true, 0);

gb = generated_battle:new(
	true,                                      		-- screen starts black
	true,                                      		-- prevent deployment for player
	true,                                      		-- prevent deployment for ai
	function() end_deployment_phase() end,          -- intro cutscene function
	false                                      		-- debug mode
);

--preload stuttering fix
intro_cinematic_file = "script/battle/quest_battles/_cutscene/managers/ubu_kostaltyn.CindySceneManager";
bm:cindy_preload(intro_cinematic_file);

-------------------------------------------------------------------------------------------------
---------------------------------------- INTRO VO & SUBS ----------------------------------------
-------------------------------------------------------------------------------------------------
wh3_main_sfx_01 = new_sfx("play_wh3_main_qb_ksl_kostaltyn_the_frozen_falls_01");

-------------------------------------------------------------------------------------------------
------------------------------------------- CUTSCENE --------------------------------------------
-------------------------------------------------------------------------------------------------
function end_deployment_phase()
	bm:out("\tend_deployment_phase() called");
		
	local cam = bm:camera();
	
	-- REMOVE ME
	cam:fade(true, 0);
	
	-- declare cutscene
	local cutscene_intro = cutscene:new_from_cindyscene(
		"cutscene_intro", 																			-- unique string name for cutscene
		ga_attacker_01.sunits,																		-- unitcontroller over player's army
		function() intro_cutscene_end() end,														-- what to call when cutscene is finished
		"script/battle/quest_battles/_cutscene/managers/ubu_kostaltyn.CindySceneManager",			-- path to cindyscene
		0,																							-- blend in time (s)
		2																							-- blend out time (s)
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
			local cam = bm:camera();
			cam:fade(true, 0);
			bm:stop_cindy_playback(true);
			
			if player_units_hidden then
				ga_attacker_01:set_enabled(true)
			end;
						
			bm:callback(function() cam:fade(false, 0.5) end, 500);
			bm:hide_subtitles();
		end
	);
	

	-- set up actions on cutscene
	cutscene_intro:action(function() cam:fade(false, 1) end, 1000);

	cutscene_intro:action(
		function()
			player_units_hidden = false;
			ga_attacker_01:set_enabled(true) 
		end, 
		200
	);	
	
	-- Voiceover and Subtitles --
	
	-- Ursun's chosen! Boris Ursus! Defiled by the sworn enemies of Father Bear! Sone and daughters of Kislev… GET THEM! Throw your bodies in front of their cursed blades. Do whatever you must to save the Red Tzar!
	cutscene_intro:add_cinematic_trigger_listener(
		"wh3_main_qb_ksl_katarin_the_frozen_falls_01", 
			function()
				cutscene_intro:play_sound(new_sfx("play_wh3_main_qb_ksl_kostaltyn_the_frozen_falls_01"));
				bm:show_subtitle("wh3_main_qb_ksl_kostaltyn_the_frozen_falls_01", false, true);
			end
	)

	-- cutscene_intro:add_cinematic_trigger_listener(
	-- 	"wh3_main_qb_ksl_katarin_the_frozen_falls_02", 
	-- 		function()
	-- 			cutscene_intro:play_sound(new_sfx("play_wh3_main_qb_ksl_kostaltyn_the_frozen_falls_02"));
	-- 			bm:show_subtitle("wh3_main_qb_ksl_kostaltyn_the_frozen_falls_02", false, true);
	-- 		end
	-- )

	cutscene_intro:set_music("The_Frozen_Falls", 0, 0)

	cutscene_intro:start();
end;

function intro_cutscene_end()
	gb.sm:trigger_message("01_intro_cutscene_end")
	cam:fade(true, 0);
	cam:fade(false, 0);
end;


-------------------------------------------------------------------------------------------------
------------------------------------------ ARMY SETUP -------------------------------------------
-------------------------------------------------------------------------------------------------

--Player Armies
ga_attacker_01 = gb:get_army(gb:get_player_alliance_num());

--Enemy Armies

--defender_left
ga_defender_left_lord = gb:get_army(gb:get_non_player_alliance_num(), "defender_lord_left");
ga_defender_left_flamers = gb:get_army(gb:get_non_player_alliance_num(), "defender_left_flamers");
ga_defender_left_forsaken = gb:get_army(gb:get_non_player_alliance_num(), "defender_left_forsaken");
ga_defender_left_pink_horrors = gb:get_army(gb:get_non_player_alliance_num(), "defender_left_pink_horrors");
ga_defender_left_screamers_1 = gb:get_army(gb:get_non_player_alliance_num(), "defender_left_screamers_1");
ga_defender_left_screamers_2 = gb:get_army(gb:get_non_player_alliance_num(), "defender_left_screamers_2");

--defender_centre
ga_defender_centre_lord = gb:get_army(gb:get_non_player_alliance_num(), "defender_lord_centre");
ga_defender_centre_blue_horrors = gb:get_army(gb:get_non_player_alliance_num(), "defender_centre_blue_horrors");
ga_defender_centre_chaos_furies = gb:get_army(gb:get_non_player_alliance_num(), "defender_centre_chaos_furies");
ga_defender_centre_pink_horrors_1 = gb:get_army(gb:get_non_player_alliance_num(), "defender_centre_pink_horrors_1");
ga_defender_centre_pink_horrors_2 = gb:get_army(gb:get_non_player_alliance_num(), "defender_centre_pink_horrors_2");
ga_defender_centre_spawn_of_tzeentch = gb:get_army(gb:get_non_player_alliance_num(), "defender_centre_spawn_of_tzeentch");

--defender_right
ga_defender_right_lord = gb:get_army(gb:get_non_player_alliance_num(), "defender_lord_right");
ga_defender_right_blue_horrors_1 = gb:get_army(gb:get_non_player_alliance_num(), "defender_right_blue_horrors_1");
ga_defender_right_blue_horrors_2 = gb:get_army(gb:get_non_player_alliance_num(), "defender_right_blue_horrors_2");
ga_defender_right_chaos_knights = gb:get_army(gb:get_non_player_alliance_num(), "defender_right_chaos_knights");
ga_defender_right_pink_horrors_1 = gb:get_army(gb:get_non_player_alliance_num(), "defender_right_pink_horrors_1");
ga_defender_right_pink_horrors_2 = gb:get_army(gb:get_non_player_alliance_num(), "defender_right_pink_horrors_2");

--defender_reinforcements
ga_defender_reinforcements_left = gb:get_army(gb:get_non_player_alliance_num(), "defender_reinforcements_left");
ga_defender_reinforcements_centre = gb:get_army(gb:get_non_player_alliance_num(), "defender_reinforcements_centre");
ga_defender_reinforcements_right = gb:get_army(gb:get_non_player_alliance_num(), "defender_reinforcements_right");


-- build spawn zone collections
sz_collection_left = bm:get_spawn_zone_collection_by_name("defender_reinforcements_left");
sz_collection_centre = bm:get_spawn_zone_collection_by_name("defender_reinforcements_centre");
sz_collection_right = bm:get_spawn_zone_collection_by_name("defender_reinforcements_right");

-- assign reinforcement armies to spawn zones
ga_defender_reinforcements_left:assign_to_spawn_zone_from_collection_on_message("battle_started", sz_collection_left, false);
ga_defender_reinforcements_centre:assign_to_spawn_zone_from_collection_on_message("battle_started", sz_collection_centre, false);
ga_defender_reinforcements_right:assign_to_spawn_zone_from_collection_on_message("battle_started", sz_collection_right, false);

--Player army deployment setup
bm:register_phase_change_callback(
        "Deployment", 
        function()
            local v_top_left = v(25, -422);
            local formation_width = 250;
 
            local sunits_player = bm:get_scriptunits_for_local_players_army();
            local uc = sunits_player:get_unitcontroller();
 
			uc:goto_location_angle_width(v_top_left, 0, formation_width);
			uc:change_group_formation("test_melee_forward_simple");

			--Kostaltyn
			ga_attacker_01.sunits:item(1).uc:teleport_to_location(v(50, -415), 0, 1.4);

            uc:release_control();
        end
    );


-------------------------------------------------------------------------------------------------
----------------------------------------- ARMY TELEPORT -----------------------------------------
-------------------------------------------------------------------------------------------------

function battle_start_teleport_units()
	bm:out("\tbattle_start_teleport_units() called");
	
----------------------------------- Enemy Deployment Setup -------------------------------------

--defender_left--

--wh3_main_tze_cha_herald_of_tzeentch_tzeentch_0
ga_defender_left_lord.sunits:item(1).uc:teleport_to_location(v(-223, 242), 206, 1.5);

--wh3_main_tze_inf_forsaken_0
ga_defender_left_forsaken.sunits:item(1).uc:teleport_to_location(v(-248, 204), 216, 41.50);

--wh3_main_tze_inf_pink_horrors_0
ga_defender_left_pink_horrors.sunits:item(1).uc:teleport_to_location(v(-178, -308), 115, 41.90);

--wh3_main_tze_mon_flamers_0
ga_defender_left_flamers.sunits:item(1).uc:teleport_to_location(v(-83, 118), 221, 2.60);

--wh3_main_tze_mon_screamers_0
ga_defender_left_screamers_1.sunits:item(1).uc:teleport_to_location(v(-309, -233), 134, 38);

--wh3_main_tze_mon_screamers_0
ga_defender_left_screamers_2.sunits:item(1).uc:teleport_to_location(v(-356, 57), 174, 38);

--defender_centre--

--wh3_main_tze_cha_herald_of_tzeentch_tzeentch_0
ga_defender_centre_lord.sunits:item(1).uc:teleport_to_location(v(-22, -18), 198, 1.61);

--wh3_main_tze_inf_blue_horrors_0
ga_defender_centre_blue_horrors.sunits:item(1).uc:teleport_to_location(v(-18, -150), 170, 36.30);

--wh3_main_tze_inf_pink_horrors_0
ga_defender_centre_pink_horrors_1.sunits:item(1).uc:teleport_to_location(v(26, -122), 213, 41.90);

--wh3_main_tze_inf_pink_horrors_0
ga_defender_centre_pink_horrors_2.sunits:item(1).uc:teleport_to_location(v(-167, -70), 111, 41.90);

--wh3_main_tze_inf_chaos_furies_0
ga_defender_centre_chaos_furies.sunits:item(1).uc:teleport_to_location(v(166, -156), 167, 39.80);

--wh3_main_tze_mon_spawn_of_tzeentch_0
ga_defender_centre_spawn_of_tzeentch.sunits:item(1).uc:teleport_to_location(v(-42, -71), 178, 35.40);

--defender_right--

--wh3_main_tze_cha_herald_of_tzeentch_tzeentch_0
ga_defender_right_lord.sunits:item(1).uc:teleport_to_location(v(343, 89), 165, 4.05);

--wh3_main_tze_inf_blue_horrors_0
ga_defender_right_blue_horrors_1.sunits:item(1).uc:teleport_to_location(v(315, 170), 242, 41.70);

--wh3_main_tze_inf_blue_horrors_0
ga_defender_right_blue_horrors_2.sunits:item(1).uc:teleport_to_location(v(386, -204), 205, 41.70);

--wh3_main_tze_inf_pink_horrors_0
ga_defender_right_pink_horrors_1.sunits:item(1).uc:teleport_to_location(v(325, -391), 229, 39.20);

--wh3_main_tze_inf_pink_horrors_0
ga_defender_right_pink_horrors_2.sunits:item(1).uc:teleport_to_location(v(334, -165), 156, 41.90);

--wh3_main_tze_cav_chaos_knights_0
ga_defender_right_chaos_knights.sunits:item(1).uc:teleport_to_location(v(420, -33), 175, 31.40);


end;

battle_start_teleport_units();


-------------------------------------------------------------------------------------------------
-------------------------------------------- ORDERS ---------------------------------------------
-------------------------------------------------------------------------------------------------
--Stopping player from firing until the cutscene is done
ga_attacker_01:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_attacker_01:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);

--Stopping enemy from firing until the cutscene is done
ga_defender_centre_blue_horrors:change_behaviour_active_on_message("battle_started", "fire_at_will", false, false);
ga_defender_centre_blue_horrors:change_behaviour_active_on_message("01_intro_cutscene_end", "fire_at_will", true, true);


--Enemy set to defend positions
--Left
ga_defender_left_lord:defend_on_message("01_intro_cutscene_end", -223, 242, 5);
ga_defender_left_lord:message_on_under_attack("defender_left_lord_attack");
ga_defender_left_lord:attack_on_message("defender_left_lord_attack");

ga_defender_left_forsaken:defend_on_message("01_intro_cutscene_end", -248, 204, 60);
ga_defender_left_forsaken:message_on_under_attack("defender_left_forsaken_attack");
ga_defender_left_forsaken:attack_on_message("defender_left_forsaken_attack");
ga_defender_left_forsaken:attack_on_message("defender_left_lord_attack");

ga_defender_left_pink_horrors:defend_on_message("01_intro_cutscene_end", -178, -308, 75);
ga_defender_left_pink_horrors:message_on_under_attack("defender_left_pink_horrors_attack");
ga_defender_left_pink_horrors:attack_on_message("defender_left_pink_horrors_attack");
ga_defender_left_pink_horrors:attack_on_message("defender_left_lord_attack");

ga_defender_left_flamers:defend_on_message("01_intro_cutscene_end", -83, 118, 35);
ga_defender_left_flamers:message_on_under_attack("defender_left_flamers_attack");
ga_defender_left_flamers:attack_on_message("defender_left_flamers_attack");
ga_defender_left_flamers:attack_on_message("defender_left_lord_attack");

ga_defender_left_screamers_1:defend_on_message("01_intro_cutscene_end", -309, -233, 75);
ga_defender_left_screamers_1:message_on_under_attack("defender_left_screamers_1_attack");
ga_defender_left_screamers_1:attack_on_message("defender_left_screamers_1_attack");
ga_defender_left_screamers_1:attack_on_message("defender_left_lord_attack");

ga_defender_left_screamers_2:defend_on_message("01_intro_cutscene_end", -356, 57, 75);
ga_defender_left_screamers_2:message_on_under_attack("defender_left_screamers_2_attack");
ga_defender_left_screamers_2:attack_on_message("defender_left_screamers_2_attack");
ga_defender_left_screamers_2:attack_on_message("defender_left_lord_attack");


--Centre
ga_defender_centre_lord:defend_on_message("01_intro_cutscene_end", -22, -18, 5);
ga_defender_centre_lord:message_on_under_attack("defender_centre_lord_attack");
ga_defender_centre_lord:attack_on_message("defender_centre_lord_attack");

ga_defender_centre_blue_horrors:defend_on_message("01_intro_cutscene_end", -16, -214, 75);
ga_defender_centre_blue_horrors:message_on_under_attack("defender_centre_blue_horrors_attack");
ga_defender_centre_blue_horrors:attack_on_message("defender_centre_blue_horrors_attack");
ga_defender_centre_blue_horrors:attack_on_message("defender_centre_lord_attack");

ga_defender_centre_pink_horrors_1:defend_on_message("01_intro_cutscene_end", 26, -122, 75);
ga_defender_centre_pink_horrors_1:message_on_under_attack("defender_centre_pink_horrors_1_attack");
ga_defender_centre_pink_horrors_1:attack_on_message("defender_centre_pink_horrors_1_attack");
ga_defender_centre_pink_horrors_1:attack_on_message("defender_centre_lord_attack");

ga_defender_centre_pink_horrors_2:defend_on_message("01_intro_cutscene_end", -167, -70, 75);
ga_defender_centre_pink_horrors_2:message_on_under_attack("defender_centre_pink_horrors_2_attack");
ga_defender_centre_pink_horrors_2:attack_on_message("defender_centre_pink_horrors_2_attack");
ga_defender_centre_pink_horrors_2:attack_on_message("defender_centre_lord_attack");

ga_defender_centre_chaos_furies:defend_on_message("01_intro_cutscene_end", 166, -156, 50);
ga_defender_centre_chaos_furies:message_on_under_attack("defender_centre_chaos_furies_attack");
ga_defender_centre_chaos_furies:attack_on_message("defender_centre_chaos_furies_attack");
ga_defender_centre_chaos_furies:attack_on_message("defender_centre_lord_attack");

ga_defender_centre_spawn_of_tzeentch:defend_on_message("01_intro_cutscene_end", -42, -71, 75);
ga_defender_centre_spawn_of_tzeentch:message_on_under_attack("defender_centre_spawn_of_tzeentch_attack");
ga_defender_centre_spawn_of_tzeentch:attack_on_message("defender_centre_spawn_of_tzeentch_attack");
ga_defender_centre_spawn_of_tzeentch:attack_on_message("defender_centre_lord_attack");


--Right
ga_defender_right_lord:defend_on_message("01_intro_cutscene_end", 343, 89, 5);
ga_defender_right_lord:message_on_under_attack("defender_right_lord_attack");
ga_defender_right_lord:attack_on_message("defender_right_lord_attack");

ga_defender_right_blue_horrors_1:defend_on_message("01_intro_cutscene_end", 315, 170, 75);
ga_defender_right_blue_horrors_1:message_on_under_attack("defender_right_blue_horrors_1_attack");
ga_defender_right_blue_horrors_1:attack_on_message("defender_right_blue_horrors_1_attack");
ga_defender_right_blue_horrors_1:attack_on_message("defender_right_lord_attack");

ga_defender_right_blue_horrors_2:defend_on_message("01_intro_cutscene_end", 386, -204, 75);
ga_defender_right_blue_horrors_2:message_on_under_attack("defender_right_blue_horrors_2_attack");
ga_defender_right_blue_horrors_2:attack_on_message("defender_right_blue_horrors_2_attack");
ga_defender_right_blue_horrors_2:attack_on_message("defender_right_lord_attack");

ga_defender_right_pink_horrors_1:defend_on_message("01_intro_cutscene_end", 325, -391, 75);
ga_defender_right_pink_horrors_1:message_on_under_attack("defender_right_pink_horrors_1_attack");
ga_defender_right_pink_horrors_1:attack_on_message("defender_right_pink_horrors_1_attack");
ga_defender_right_pink_horrors_1:attack_on_message("defender_right_lord_attack");

ga_defender_right_pink_horrors_2:defend_on_message("01_intro_cutscene_end", 334, -165, 75);
ga_defender_right_pink_horrors_2:message_on_under_attack("defender_right_pink_horrors_2_attack");
ga_defender_right_pink_horrors_2:attack_on_message("defender_right_pink_horrors_2_attack");
ga_defender_right_pink_horrors_2:attack_on_message("defender_right_lord_attack");

ga_defender_right_chaos_knights:defend_on_message("01_intro_cutscene_end", 420, -33, 60);
ga_defender_right_chaos_knights:message_on_under_attack("defender_right_chaos_knights_attack");
ga_defender_right_chaos_knights:attack_on_message("defender_right_chaos_knights_attack");
ga_defender_right_chaos_knights:attack_on_message("defender_right_lord_attack");


--Trigger reinforcements
ga_defender_left_lord:message_on_under_attack("defender_reinforcements_left");
ga_defender_left_lord:message_on_proximity_to_enemy("defender_reinforcements_left", 100);
ga_defender_centre_lord:message_on_under_attack("defender_reinforcements_centre");
ga_defender_centre_lord:message_on_proximity_to_enemy("defender_reinforcements_centre", 100);
ga_defender_right_lord:message_on_under_attack("defender_reinforcements_right");
ga_defender_right_lord:message_on_proximity_to_enemy("defender_reinforcements_right", 100);

ga_defender_reinforcements_left:reinforce_on_message("defender_reinforcements_left", 3000);
ga_defender_reinforcements_left:message_on_deployed("defender_reinforcements_left_attack");
ga_defender_reinforcements_left:attack_on_message("defender_reinforcements_left_attack");

ga_defender_reinforcements_centre:reinforce_on_message("defender_reinforcements_centre", 3000);
ga_defender_reinforcements_centre:message_on_deployed("defender_reinforcements_centre_attack");
ga_defender_reinforcements_centre:attack_on_message("defender_reinforcements_centre_attack");

ga_defender_reinforcements_right:reinforce_on_message("defender_reinforcements_right", 3000);
ga_defender_reinforcements_right:message_on_deployed("defender_reinforcements_right_attack");
ga_defender_reinforcements_right:attack_on_message("defender_reinforcements_right_attack");

--Lords dead messages--
ga_defender_left_lord:message_on_shattered_proportion("lord_dead_left", 1);
ga_defender_centre_lord:message_on_shattered_proportion("lord_dead_centre", 1);
ga_defender_right_lord:message_on_shattered_proportion("lord_dead_right", 1);


-------------------------------------------------------------------------------------------------
------------------------------------------- OBJECTIVES ------------------------------------------
-------------------------------------------------------------------------------------------------

--Defeat the three sorcerers!
gb:set_objective_on_message("01_intro_cutscene_end", "wh3_main_qb_ksl_katarin_boris_unlock_hints_main_objective_1");
ga_defender_left_lord:add_ping_icon_on_message("01_intro_cutscene_end", 15, 1, 10000);
ga_defender_centre_lord:add_ping_icon_on_message("01_intro_cutscene_end", 15, 1, 10000);
ga_defender_right_lord:add_ping_icon_on_message("01_intro_cutscene_end", 15, 1, 10000);
gb:remove_objective_on_message("first_lord_dead", "wh3_main_qb_ksl_katarin_boris_unlock_hints_main_objective_1");

--Defeat the two remaining sorcerers!
gb:set_objective_on_message("first_lord_dead", "wh3_main_qb_ksl_katarin_boris_unlock_hints_main_objective_2");
ga_defender_left_lord:add_ping_icon_on_message("first_lord_dead", 15, 1, 10000);
ga_defender_centre_lord:add_ping_icon_on_message("first_lord_dead", 15, 1, 10000);
ga_defender_right_lord:add_ping_icon_on_message("first_lord_dead", 15, 1, 10000);
gb:remove_objective_on_message("second_lord_dead", "wh3_main_qb_ksl_katarin_boris_unlock_hints_main_objective_2");

--Defeat the last sorcerer!
gb:set_objective_on_message("second_lord_dead", "wh3_main_qb_ksl_katarin_boris_unlock_hints_main_objective_3");
ga_defender_left_lord:add_ping_icon_on_message("second_lord_dead", 15, 1, 10000);
ga_defender_centre_lord:add_ping_icon_on_message("second_lord_dead", 15, 1, 10000);
ga_defender_right_lord:add_ping_icon_on_message("second_lord_dead", 15, 1, 10000);
gb:remove_objective_on_message("third_lord_dead", "wh3_main_qb_ksl_katarin_boris_unlock_hints_main_objective_3");


-------------------------------------------------------------------------------------------------
--------------------------------------------- HINTS ---------------------------------------------
-------------------------------------------------------------------------------------------------

--Eliminate the three Chaos Sorcerers that seek to wrest Boris from the ice!
gb:queue_help_on_message("01_intro_cutscene_end", "wh3_main_qb_ksl_katarin_boris_unlock_hints_main_hint", 10000, 2000, 3000, false);

--A Sorcerer has been slain, but two others remain.
gb:queue_help_on_message("first_lord_dead", "wh3_main_qb_ksl_katarin_boris_unlock_hints_sorcerer_killed_1", 10000, 2000, 1000, false);

--Another Sorcerer cast into the dirt! One still lives.
gb:queue_help_on_message("second_lord_dead", "wh3_main_qb_ksl_katarin_boris_unlock_hints_sorcerer_killed_2", 10000, 2000, 1000, false);

--At last, Boris is protected. He stirs - there is hope for the Motherland yet.
gb:queue_help_on_message("third_lord_dead", "wh3_main_qb_ksl_katarin_boris_unlock_hints_sorcerer_killed_3", 10000, 2000, 1000, false);


-------------------------------------------------------------------------------------------------
--------------------------------------------- MISC ----------------------------------------------
-------------------------------------------------------------------------------------------------

--making the lords unbreakable to stop them disintegrating
ga_defender_left_lord.sunits:set_stat_attribute("unbreakable", true);
ga_defender_centre_lord.sunits:set_stat_attribute("unbreakable", true);
ga_defender_right_lord.sunits:set_stat_attribute("unbreakable", true);

--Messages on lords dead
gb:message_on_any_message_received("first_lord_dead", "lord_dead_left", "lord_dead_centre", "lord_dead_right");
gb:message_on_all_messages_received("second_lord_dead", "lord_dead_left", "lord_dead_centre");
gb:message_on_all_messages_received("second_lord_dead", "lord_dead_left", "lord_dead_right");
gb:message_on_all_messages_received("second_lord_dead", "lord_dead_centre", "lord_dead_right");
gb:message_on_all_messages_received("third_lord_dead", "lord_dead_left", "lord_dead_centre", "lord_dead_right");

--gb:block_message_on_message("first_lord_dead", "first_lord_dead", true);
--gb:block_message_on_message("second_lord_dead", "second_lord_dead", true);

--rout armies after sustaining X casualties (to speed up the battle)
--ga_defender_west:message_on_casualties("rout_west", 0.7);
--ga_defender_south:message_on_casualties("rout_south", 0.7);
--ga_defender_east:message_on_casualties("rout_east", 0.7);

--ga_defender_west:rout_over_time_on_message("rout_west", 30000);
--ga_defender_south:rout_over_time_on_message("rout_south", 30000);
--ga_defender_east:rout_over_time_on_message("rout_east", 30000);

--rout armies over 1 min after their lord is killed (to speed up the battle)
--ga_defender_west:rout_over_time_on_message("lord_dead_west", 30000);
--ga_defender_south:rout_over_time_on_message("lord_dead_south", 30000);
--ga_defender_east:rout_over_time_on_message("lord_dead_east", 30000);


-------------------------------------------------------------------------------------------------
--------------------------------------------- VICTORY -------------------------------------------
-------------------------------------------------------------------------------------------------

gb:message_on_all_messages_received("victory", "first_lord_dead", "second_lord_dead", "third_lord_dead");
ga_attacker_01:force_victory_on_message("victory", 10000);
