load_script_libraries();

local gc = generated_cutscene:new(true);

--bm:camera():fade(true, 0);

gb = generated_battle:new(
                false,                                      -- screen starts black
                false,                                      -- prevent deployment for player
                true,                                      -- prevent deployment for ai
				function() 
					gb:start_generated_cutscene(gc)      	-- intro cutscene function
					ga_player:set_visible_to_all(true);
					ga_ai_enemy_main_boss:set_visible_to_all(true);
					ga_ai_enemy_main_forces:set_visible_to_all(true);
                end,
				false                                       -- debug mode
);

-----------------------------
----SCRIPTED INTRO CAMERA----
-----------------------------
gc:add_element("Play_dlc27_nor_monstrous_arcanum_battle_carrion_001_1", "dlc27_nor_monstrous_arcanum_battle_carrion_001", "army_pan_front_mid", 8000, true, false, true);
gc:add_element("Play_dlc27_nor_monstrous_arcanum_battle_carrion_002_1", "dlc27_nor_monstrous_arcanum_battle_carrion_002", "gc_orbit_90_medium_commander_front_right_close_low_01", 7000, true, false, false);
gc:add_element(nil, nil, "gc_medium_enemy_army_pan_front_right_to_front_left_far_high_01", 5000, false, false, false);
gc:add_element(nil, nil, "gc_orbit_ccw_90_medium_enemy_commander_front_close_low_01", 5000, false, false, false);
gc:add_element(nil, nil, "gc_medium_commander_back_medium_medium_to_close_low_01", 5000, false, false, false);

gb:set_cutscene_during_deployment(true);

---------------------------
----HARD SCRIPT VERSION----
---------------------------
-----The Carrion Eater

------------------------------
----------ARMY SETUP----------
------------------------------
ga_player = gb:get_army(gb:get_player_alliance_num());
--Enemy Beasts & Boss
ga_ai_enemy_main_boss = gb:get_army(gb:get_non_player_alliance_num(), "boss");
ga_ai_enemy_main_forces = gb:get_army(gb:get_non_player_alliance_num(), "main_force");
--Allied Beasts
ga_ai_ally_reinforce = gb:get_army(gb:get_player_alliance_num(), "ally_reinforcements");

boss = ga_ai_enemy_main_boss.sunits:item(1);

-------------------------------
----------SPAWN ZONES----------
-------------------------------
local reinforcements = bm:reinforcements();

--Attackers Reinforce
--beast_reinforcements = bm:get_spawn_zone_collection_by_name("beast_reinforce_01");

--Beasts from cliffs
--ga_ai_ally_reinforce:assign_to_spawn_zone_from_collection_on_message("start", reinforcements:random_spawn_zone(1), false);

--------------------------------------
----------HINTS & OBJECTIVES----------
--------------------------------------
-----OBJECTIVE 1-----
--???
gb:set_objective_with_leader_on_message("objective_01", "wh3_dlc27_qb_monster_hunt_24_objective_01");
gb:complete_objective_on_message("carrion_boss_dead", "wh3_dlc27_qb_monster_hunt_24_objective_01");
gb:remove_objective_on_message("carrion_boss_dead", "wh3_dlc27_qb_monster_hunt_24_objective_01", 10000);

gb:queue_help_on_message("hint_01", "wh3_dlc27_qb_monster_hunt_24_hint_01");
gb:queue_help_on_message("ally_forces_in", "wh3_dlc27_qb_monster_hunt_24_hint_02");

-----OBJECTIVE 2-----
--Defeat the Enemy Forces
gb:set_objective_on_message("start", "wh3_dlc24_ksl_hex_01_objective_01");
gb:complete_objective_on_message("enemy_forces_dead", "wh3_dlc24_ksl_hex_01_objective_01");

----------------------------------
----------SPECIAL ORDERS----------
----------------------------------
--ga_ai_enemy_main_boss:set_visible_to_all(false);
--ga_ai_enemy_main_forces:set_visible_to_all(false);

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("objective_01", 2500);
gb:message_on_time_offset("hint_01", 7500);

gb:message_on_all_messages_received("enemy_forces_dead", "carrion_boss_dead", "carrion_forces_dead")

ga_player:force_victory_on_message("enemy_forces_dead", 5000);

boss:set_stat_attribute("unbreakable", true);

-------------------------------
----------ALLY ORDERS----------
-------------------------------
ga_ai_ally_reinforce:reinforce_on_message("carrion_forces_weak");
ga_ai_ally_reinforce:message_on_any_deployed("ally_forces_in");
-- ga_ai_ally_reinforce:rush_on_message("ally_forces_in");
ga_ai_ally_reinforce:attack_force_on_message("ally_forces_in", ga_ai_enemy_main_boss)

--------------------------------
----------ENEMY ORDERS----------
--------------------------------*
-- ga_ai_enemy_main_boss.sunits:take_control()
-- ga_ai_enemy_main_forces.sunits:take_control()

ga_ai_enemy_main_boss:rush_on_message("start");
ga_ai_enemy_main_boss:message_on_commander_death("carrion_boss_dead");

ga_ai_enemy_main_forces:rush_on_message("start");
ga_ai_enemy_main_forces:message_on_rout_proportion("carrion_forces_weak",0.4);
ga_ai_enemy_main_forces:message_on_rout_proportion("carrion_forces_dead",0.95);