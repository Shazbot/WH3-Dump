load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
                false,                                      -- screen starts black
                false,                                      -- prevent deployment for player
                false,                                                 -- prevent deployment for ai
                function() 
                                                                gb:start_generated_cutscene(gc) 
                                                                bm:callback(function() bm:out("triggering dlc08.battle.speech.nor.battle_frostwyrm.001"); bm:queue_advisor("dlc08.battle.speech.nor.battle_frostwyrm.001") end, 2000); 
																bm:callback(function() bm:out("triggering dlc08.battle.speech.nor.battle_frostwyrm.002"); bm:queue_advisor("dlc08.battle.speech.nor.battle_frostwyrm.002") end, 10500);
				end,       -- intro cutscene function
                false                                                  -- debug mode
);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil, nil, "gc_orbit_90_medium_ground_offset_north_west_extreme_high_02", 3000, false, false, false);
gc:add_element(nil, nil, "gc_orbit_90_medium_commander_back_close_low_01", 3000, false, false, false);
gc:add_element(nil, nil, "gc_slow_army_pan_front_left_to_front_right_close_medium_01", 3000, false, false, false);
gc:add_element(nil, nil, nil, 3000, false, false, false);
gc:add_element(nil, nil, "gc_slow_enemy_army_pan_front_left_to_front_right_far_high_01", 3000, false, false, false);
gc:add_element(nil, nil, "gc_orbit_90_medium_commander_front_right_close_low_01", 4000, false, false, false);
gc:add_element(nil, nil, "gc_medium_commander_back_medium_medium_to_close_low_01", 4000, true, true, false);



gb:set_cutscene_during_deployment(true);
---------------------------
----HARD SCRIPT VERSION----
---------------------------


-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(0), 1);		
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(1), 1, "minions");
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(1), 1, "boss");
ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(1), 2);
ga_ai_04 = gb:get_army(gb:get_non_player_alliance_num(1), 3);





-------OBJECTIVES-------
gb:queue_help_on_message("battle_started", "wh_dlc08_qb_monster_hunt_0_hint_objective");
gb:queue_help_on_message("released_for_a_while", "wh_dlc08_qb_monster_hunt_0_hint_boss_ability");
gb:queue_help_on_message("hurt", "wh_dlc08_qb_monster_hunt_0_hint_boss_gone");
gb:set_objective_on_message("deployment_started", "wh_dlc08_qb_monster_hunt_objective");
gb:set_objective_on_message("deployment_started", "wh_dlc08_qb_monster_hunt_objective_0_1");
gb:set_objective_on_message("deployment_started", "wh_dlc08_qb_monster_hunt_objective_0_0");
-------ORDERS-------
gb:message_on_time_offset("start_ambush", 5000);
gb:message_on_time_offset("release_boss", 45000);
gb:message_on_time_offset("released_for_a_while", 85000);
ga_ai_01:halt();
ga_ai_01:attack_on_message("start_ambush");
ga_ai_02:halt();
ga_ai_02:attack_on_message("release_boss");
ga_ai_01:message_on_under_attack("under_attack");
ga_ai_02:message_on_under_attack("under_attack");
ga_ai_01:attack_on_message("under_attack");
ga_ai_02:attack_on_message("under_attack");
ga_ai_02:message_on_casualties("hurt",0.95);
ga_ai_03:reinforce_on_message("release_boss",20000);
ga_ai_04:reinforce_on_message("release_boss",20000);
-- ga_ai_02:message_on_any_deployed("cavelry_arrived");




