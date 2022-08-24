load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
                false,                                      -- screen starts black
                false,                                      -- prevent deployment for player
                false,                                                 -- prevent deployment for ai
                function() 
                                                                gb:start_generated_cutscene(gc) 
                                                                bm:callback(function() bm:out("triggering dlc08.battle.speech.nor.battle_giant.001"); bm:queue_advisor("dlc08.battle.speech.nor.battle_giant.001") end, 2000); 
																bm:callback(function() bm:out("triggering dlc08.battle.speech.nor.battle_giant.002"); bm:queue_advisor("dlc08.battle.speech.nor.battle_giant.002") end, 9300);
																bm:callback(function() bm:out("triggering dlc08.battle.speech.nor.battle_giant.003"); bm:queue_advisor("dlc08.battle.speech.nor.battle_giant.003") end, 25000);
				end,       -- intro cutscene function
                false                                                  -- debug mode
);

gc:add_element(nil, nil, "gc_medium_absolute_squigly_beast_00", 5000, false, false, false);
gc:add_element(nil, nil, nil, 8570, false, false, false);
gc:add_element(nil, nil, nil, 5880, false, false, false);
gc:add_element(nil, nil, "gc_medium_absolute_squigly_beast_01", 3000, false, false, false);
gc:add_element(nil, nil, nil, 4570, false, false, false);
gc:add_element(nil, nil, "gc_slow_army_pan_front_left_to_front_right_close_medium_01", 8000, true, false, false);
gc:add_element(nil, nil, "gc_orbit_90_medium_commander_front_right_close_low_01", 7000, true, false, false);
gc:add_element(nil, nil, "gc_medium_commander_back_medium_medium_to_close_low_01", 5000, true, true, false);

gb:set_cutscene_during_deployment(true);
---------------------------
----HARD SCRIPT VERSION----
---------------------------


-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(0), 1);		
ga_ai_01 = gb:get_army(gb:get_non_player_alliance_num(1), 1, "minions");
ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(1), 1, "boss");
-- ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(1), 2);
-- ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(1), 3);





-------OBJECTIVES-------
gb:queue_help_on_message("battle_started", "wh_dlc08_qb_monster_hunt_4_hint_objective");
gb:queue_help_on_message("released_for_a_while", "wh_dlc08_qb_monster_hunt_4_hint_boss_ability");
gb:queue_help_on_message("hurt", "wh_dlc08_qb_monster_hunt_4_hint_boss_gone");
-- gb:queue_help_on_message("battle_started", "wh_dlc05_qb_wef_orion_spear_of_kurnous_stage_3_hint_objective");
-- gb:queue_help_on_message("cavelry_arrived", "wh_dlc05_qb_wef_orion_spear_of_kurnous_stage_3_hint_reinforcement");
gb:set_objective_on_message("deployment_started", "wh_dlc08_qb_monster_hunt_objective");
gb:set_objective_on_message("deployment_started", "wh_dlc08_qb_monster_hunt_objective_4_0");
gb:set_objective_on_message("deployment_started", "wh_dlc08_qb_monster_hunt_objective_4_1");
-------ORDERS-------

gb:message_on_time_offset("start_ambush", 5000);
gb:message_on_time_offset("release_boss", 36000);
gb:message_on_time_offset("released_for_a_while", 96000);
ga_ai_01:halt();
ga_ai_01:attack_on_message("start_ambush");
ga_ai_02:halt();
ga_ai_02:attack_on_message("release_boss");
ga_ai_01:message_on_under_attack("under_attack");
ga_ai_02:message_on_under_attack("under_attack");
ga_ai_01:release_on_message("under_attack");
ga_ai_02:release_on_message("under_attack");
ga_ai_02:message_on_casualties("hurt",0.95);
-- ga_ai_01:message_on_casualties("hurt",0.10);
-- ga_ai_02:reinforce_on_message("hurt",20000);
-- ga_ai_03:reinforce_on_message("hurt",20000);
-- ga_ai_02:message_on_any_deployed("cavelry_arrived");




