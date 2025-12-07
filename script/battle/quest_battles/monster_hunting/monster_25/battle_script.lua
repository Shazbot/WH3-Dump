load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
                false,                                      -- screen starts black
                false,                                      -- prevent deployment for player
                true,                                       -- prevent deployment for ai
				function() 
					gb:start_generated_cutscene(gc)      	-- intro cutscene function
					ga_ai_enemy_main_boss:set_visible_to_all(true);
					ga_ai_enemy_main_forces:set_visible_to_all(true);
                end,
				false                                       -- debug mode
);

-----------------------------
----SCRIPTED INTRO CAMERA----
-----------------------------
gc:add_element("Play_dlc27_nor_monstrous_arcanum_battle_celestial_lion_001_1", "dlc27_nor_monstrous_arcanum_battle_celestial_lion_001", "army_pan_front_mid", 8000, true, false, true);
gc:add_element("Play_dlc27_nor_monstrous_arcanum_battle_celestial_lion_002_1", "dlc27_nor_monstrous_arcanum_battle_celestial_lion_002", "gc_orbit_90_medium_commander_front_right_close_low_01", 7000, true, false, false);
gc:add_element("Play_dlc27_nor_monstrous_arcanum_battle_celestial_lion_003_1", "dlc27_nor_monstrous_arcanum_battle_celestial_lion_003", "gc_medium_enemy_army_pan_front_right_to_front_left_far_high_01", 5000, false, false, false);
gc:add_element(nil, nil, "gc_orbit_ccw_90_medium_enemy_commander_front_close_low_01", 5000, false, false, false);
gc:add_element(nil, nil, "gc_medium_commander_back_medium_medium_to_close_low_01", 5000, false, false, false);

gb:set_cutscene_during_deployment(true);

---------------------------
----HARD SCRIPT VERSION----
---------------------------
-----The Wise One

------------------------------
----------ARMY SETUP----------
------------------------------
ga_player = gb:get_army(gb:get_player_alliance_num());
--Enemy Beasts & Boss
ga_ai_enemy_main_boss = gb:get_army(gb:get_non_player_alliance_num(), "boss");
ga_ai_enemy_main_forces = gb:get_army(gb:get_non_player_alliance_num(), "main_force");
--Enemy Reinforcements
ga_ai_enemy_left_flank_reinforce = gb:get_army(gb:get_non_player_alliance_num(), "left_reinforcements");
ga_ai_enemy_right_flank_reinforce = gb:get_army(gb:get_non_player_alliance_num(), "right_reinforcements");
ga_ai_enemy_rear_flank_reinforce = gb:get_army(gb:get_non_player_alliance_num(), "rear_reinforcements");

boss = ga_ai_enemy_main_boss.sunits:item(1);

-------------------------------
----------SPAWN ZONES----------
-------------------------------
local reinforcements = bm:reinforcements();

--Defenders Reinforce
left_reinforce = bm:get_spawn_zone_collection_by_name("left_reinforce");
right_reinforce = bm:get_spawn_zone_collection_by_name("right_reinforce");
rear_reinforce = bm:get_spawn_zone_collection_by_name("rear_reinforce");

--Flanks
ga_ai_enemy_left_flank_reinforce:assign_to_spawn_zone_from_collection_on_message("start", left_reinforce, false);
ga_ai_enemy_right_flank_reinforce:assign_to_spawn_zone_from_collection_on_message("start", right_reinforce, false);
ga_ai_enemy_rear_flank_reinforce:assign_to_spawn_zone_from_collection_on_message("start", rear_reinforce, false);

--------------------------------------
----------HINTS & OBJECTIVES----------
--------------------------------------
-----OBJECTIVE 1-----
--???
gb:set_objective_with_leader_on_message("objective_01", "wh3_dlc27_qb_monster_hunt_25_objective_01");
gb:complete_objective_on_message("wise_one_dead", "wh3_dlc27_qb_monster_hunt_25_objective_01");
gb:remove_objective_on_message("wise_one_dead", "wh3_dlc27_qb_monster_hunt_25_objective_01", 10000);

gb:queue_help_on_message("hint_01", "wh3_dlc27_qb_monster_hunt_25_hint_01");
gb:queue_help_on_message("left_flank_forces_in", "wh3_dlc27_qb_monster_hunt_25_hint_02");
gb:queue_help_on_message("right_flank_forces_in", "wh3_dlc27_qb_monster_hunt_25_hint_03");
gb:queue_help_on_message("rear_flank_forces_in", "wh3_dlc27_qb_monster_hunt_25_hint_04");

-----OBJECTIVE 2-----
--Defeat the Enemy Forces
gb:set_objective_on_message("start", "wh3_dlc24_ksl_hex_01_objective_01");
gb:complete_objective_on_message("enemy_forces_dead", "wh3_dlc24_ksl_hex_01_objective_01");

----------------------------------
----------SPECIAL ORDERS----------
----------------------------------
ga_ai_enemy_main_boss:set_visible_to_all(false);
ga_ai_enemy_main_forces:set_visible_to_all(false);

gb:message_on_time_offset("start", 100);
gb:message_on_time_offset("objective_01", 2500);
gb:message_on_time_offset("hint_01", 7500);

gb:message_on_all_messages_received("enemy_forces_dead", "wise_one_dead", "main_force_dead", "left_force_dead", "right_force_dead", "rear_force_dead")

gb:message_on_time_offset("end_battle", 2500, "enemy_forces_dead");
ga_player:force_victory_on_message("end_battle", 2500);

boss:set_stat_attribute("unbreakable", true);

--------------------------------
----------ENEMY ORDERS----------
--------------------------------
-- ga_ai_enemy_main_boss.sunits:take_control()
-- ga_ai_enemy_main_forces.sunits:take_control()

ga_ai_enemy_main_boss:rush_on_message("start");
ga_ai_enemy_main_boss:message_on_commander_death("wise_one_dead");

ga_ai_enemy_main_forces:attack_on_message("start");
ga_ai_enemy_main_forces:message_on_rout_proportion("reinforce_left_flank",0.05);
ga_ai_enemy_main_forces:message_on_rout_proportion("reinforce_right_flank",0.15);
ga_ai_enemy_main_forces:message_on_rout_proportion("reinforce_rear_flank",0.25);
ga_ai_enemy_main_forces:message_on_rout_proportion("main_force_dead",0.99);

ga_ai_enemy_left_flank_reinforce:reinforce_on_message("reinforce_left_flank");
ga_ai_enemy_left_flank_reinforce:message_on_any_deployed("left_flank_forces_in");
ga_ai_enemy_left_flank_reinforce:rush_on_message("left_flank_forces_in");
ga_ai_enemy_left_flank_reinforce:message_on_rout_proportion("left_force_dead",0.99);

ga_ai_enemy_right_flank_reinforce:reinforce_on_message("reinforce_right_flank");
ga_ai_enemy_right_flank_reinforce:message_on_any_deployed("right_flank_forces_in");
ga_ai_enemy_right_flank_reinforce:rush_on_message("right_flank_forces_in");
ga_ai_enemy_right_flank_reinforce:message_on_rout_proportion("right_force_dead",0.99);

ga_ai_enemy_rear_flank_reinforce:reinforce_on_message("reinforce_rear_flank");
ga_ai_enemy_rear_flank_reinforce:message_on_any_deployed("rear_flank_forces_in");
ga_ai_enemy_rear_flank_reinforce:rush_on_message("rear_flank_forces_in");
ga_ai_enemy_rear_flank_reinforce:message_on_rout_proportion("rear_force_dead",0.99);