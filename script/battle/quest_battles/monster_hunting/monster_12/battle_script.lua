load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
                false,                                      -- screen starts black
                false,                                      -- prevent deployment for player
                true,                                       -- prevent deployment for ai
				function() 
					gb:start_generated_cutscene(gc)      	-- intro cutscene function
					ga_ai_ally_main_boss:set_visible_to_all(true);
					-- ga_ai_ally_main_forces:set_visible_to_all(true);
					ga_ai_enemy_main_forces:set_visible_to_all(true);
                end,
				false                                       -- debug mode
);

-----------------------------
----SCRIPTED INTRO CAMERA----
-----------------------------
gc:add_element("Play_dlc27_nor_monstrous_arcanum_battle_chimera_001_1", "dlc27_nor_monstrous_arcanum_battle_chimera_001", "army_pan_front_mid", 8000, true, false, true);
gc:add_element("Play_dlc27_nor_monstrous_arcanum_battle_chimera_002_1", "dlc27_nor_monstrous_arcanum_battle_chimera_002", "gc_orbit_90_medium_commander_front_right_close_low_01", 7000, true, false, false);
gc:add_element("Play_dlc27_nor_monstrous_arcanum_battle_chimera_003_1", "dlc27_nor_monstrous_arcanum_battle_chimera_003", "gc_medium_enemy_army_pan_front_right_to_front_left_far_high_01", 5000, false, false, false);
gc:add_element(nil, nil, "gc_orbit_ccw_90_medium_enemy_commander_front_close_low_01", 5000, false, false, false);
gc:add_element(nil, nil, "gc_medium_commander_back_medium_medium_to_close_low_01", 5000, false, false, false);

gb:set_cutscene_during_deployment(true);

---------------------------
----HARD SCRIPT VERSION----
---------------------------
-----Chimera, Revesh Kresh'tish

------------------------------
----------ARMY SETUP----------
------------------------------
ga_player = gb:get_army(gb:get_player_alliance_num());

--Ally
ga_ai_ally_main_boss = gb:get_army(gb:get_player_alliance_num(), "boss");
-- ga_ai_ally_main_forces = gb:get_army(gb:get_player_alliance_num(), "ally_force");	-- No such army is setup in the DB

--Enemy Force
ga_ai_enemy_main_forces = gb:get_army(gb:get_non_player_alliance_num(), "main_force");

boss = ga_ai_ally_main_boss.sunits:item(1);

--------------------------------------
----------HINTS & OBJECTIVES----------
--------------------------------------
-----OBJECTIVE 1-----
--Protect Revesh Kresh'tish
gb:set_objective_with_leader_on_message("objective_01", "wh3_dlc27_qb_monster_hunt_12_objective_01");
gb:complete_objective_on_message("main_force_dead", "wh3_dlc27_qb_monster_hunt_12_objective_01");

gb:queue_help_on_message("hint_01", "wh3_dlc27_qb_monster_hunt_12_hint_01");

-----OBJECTIVE 2-----
--Defeat the Enemy Forces
gb:set_objective_on_message("start", "wh3_dlc24_ksl_hex_01_objective_01");
gb:complete_objective_on_message("main_force_dead", "wh3_dlc24_ksl_hex_01_objective_01");

----------------------------------
----------SPECIAL ORDERS----------
----------------------------------
ga_ai_ally_main_boss:set_visible_to_all(false);
-- ga_ai_ally_main_forces:set_visible_to_all(false);
ga_ai_enemy_main_forces:set_visible_to_all(false);

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("objective_01", 2500);
gb:message_on_time_offset("hint_01", 7500);

ga_player:force_victory_on_message("main_force_dead", 5000);
ga_ai_enemy_main_forces:force_victory_on_message("chimera_boss_dead", 5000);

boss:set_stat_attribute("unbreakable", true);

-------------------------------
----------ALLY ORDERS----------
-------------------------------
ga_ai_ally_main_boss:rush_on_message("start");
ga_ai_ally_main_boss:message_on_commander_death("chimera_boss_dead");

-- ga_ai_ally_main_forces:rush_on_message("start");

--------------------------------
----------ENEMY ORDERS----------
--------------------------------
ga_ai_enemy_main_forces.sunits:take_control()

ga_ai_enemy_main_forces:attack_on_message("start");
ga_ai_enemy_main_forces:message_on_rout_proportion("main_force_dead", 0.99);