load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
                false,                                      -- screen starts black
                false,                                      -- prevent deployment for player
                false,                                                 -- prevent deployment for ai
                function() 
                                                                gb:start_generated_cutscene(gc) 
                                                                bm:callback(function() bm:out("triggering dlc08.battle.speech.nor.battle_cygor.001"); bm:queue_advisor("dlc08.battle.speech.nor.battle_cygor.001") end, 2000); 
																bm:callback(function() bm:out("triggering dlc08.battle.speech.nor.battle_cygor.002"); bm:queue_advisor("dlc08.battle.speech.nor.battle_cygor.002") end, 13400);
																bm:callback(function() bm:out("triggering dlc08.battle.speech.nor.battle_cygor.003"); bm:queue_advisor("dlc08.battle.speech.nor.battle_cygor.003") end, 31700);
				end,       -- intro cutscene function
                false                                                  -- debug mode
);

--generated_cutscene:add_element(sfx_name, subtitle, camera, min_length, wait_for_vo, wait_for_camera, loop_camera)
gc:add_element(nil,nil, "gc_medium_absolute_shadow_forest_0", 4000, false, false, false);
gc:add_element(nil,nil, nil, 5000, false, false, false);
gc:add_element(nil,nil,"gc_medium_absolute_shadow_forest_1", 7000, false, false, false);
gc:add_element(nil,nil,"gc_medium_absolute_shadow_forest_2", 7000, false, false, false);
gc:add_element(nil, nil, "gc_orbit_90_medium_commander_front_right_close_low_01", 8000, true, false, false);
gc:add_element(nil, nil, "gc_slow_army_pan_front_left_to_front_right_close_medium_01", 8000, true, false, false);
gc:add_element(nil, nil, "gc_medium_commander_back_medium_medium_to_close_low_01", 6000, true, true, false);
--gc:add_element(nil, nil, "gc_fast_commander_back_medium_medium_to_close_low_01", 400, false, true, false);


gb:set_cutscene_during_deployment(true);
---------------------------
----HARD SCRIPT VERSION----
---------------------------


-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(0), 1);		
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(1), 1, "minions");
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(1), 1, "boss");
ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(1), 2, "first");
ga_ai_04 = gb:get_army(gb:get_non_player_alliance_num(1), 2, "boss");
ga_ai_05 = gb:get_army(gb:get_non_player_alliance_num(1), 2, "minions");
-- ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(1), 3);





-------OBJECTIVES-------
gb:queue_help_on_message("battle_started", "wh_dlc08_qb_monster_hunt_1_hint_objective");
gb:queue_help_on_message("hurt", "wh_dlc08_qb_monster_hunt_1_hint_boss_gone");
gb:queue_help_on_message("hurt_2", "wh_dlc08_qb_monster_hunt_1_hint_boss_gone_second_one");
gb:set_objective_on_message("deployment_started", "wh_dlc08_qb_monster_hunt_objective_plural");
gb:set_objective_on_message("deployment_started", "wh_dlc08_qb_monster_hunt_objective_1_0");
-------ORDERS-------

gb:message_on_time_offset("start_ambush", 5000);
gb:message_on_time_offset("release_boss", 35000);
ga_ai_01:halt();
ga_ai_01:attack_on_message("start_ambush");
ga_ai_01:message_on_under_attack("under_attack");
ga_ai_02:message_on_under_attack("under_attack");
ga_ai_01:release_on_message("under_attack");
ga_ai_02:release_on_message("under_attack");
ga_ai_02:message_on_casualties("hurt",0.95);
ga_ai_02:message_on_casualties("reinforce",0.6);
ga_ai_03:reinforce_on_message("reinforce",5000);
ga_ai_04:reinforce_on_message("hurt",9000);
ga_ai_04:message_on_casualties("hurt_2",0.95);
ga_ai_05:reinforce_on_message("hurt",9000);
-- ga_ai_01:message_on_casualties("hurt",0.10);
-- ga_ai_02:reinforce_on_message("hurt",20000);
-- ga_ai_03:reinforce_on_message("hurt",20000);
-- ga_ai_02:message_on_any_deployed("cavelry_arrived");




