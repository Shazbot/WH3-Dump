load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
                false,                                      -- screen starts black
                false,                                      -- prevent deployment for player
                true,                                       -- prevent deployment for ai
				nil,      									-- intro cutscene function
                false                                       -- debug mode
);

gb:set_cutscene_during_deployment(true);
---------------------------
----HARD SCRIPT VERSION----
---------------------------


-------ARMY SETUP-------
ga_player = gb:get_army(gb:get_player_alliance_num(0), 1);

ga_ai_enemy = gb:get_army(gb:get_non_player_alliance_num(1), 1, "boss");

-- ga_ai_02 = gb:get_army(gb:get_non_player_alliance_num(1), 2);
-- ga_ai_03 = gb:get_army(gb:get_non_player_alliance_num(1), 3);





-------OBJECTIVES-------
gb:queue_help_on_message("battle_started", "wh3_dlc27_qb_monster_hunt_19_hint_objective");
gb:queue_help_on_message("hurt", "wh_dlc27_qb_monster_hunt_19_hint_boss_gone");
gb:set_objective_on_message("deployment_started", "wh_dlc08_qb_monster_hunt_objective");
--gb:set_objective_on_message("deployment_started", "wh3_dlc27_qb_monster_hunt_objective_25");

-------ORDERS-------

gb:message_on_time_offset("start_attack", 5000);
gb:message_on_time_offset("release_boss", 15000);
ga_ai_enemy:halt();
ga_ai_enemy:attack_on_message("start_attack");
ga_ai_enemy:halt();
ga_ai_enemy:attack_on_message("release_boss");
ga_ai_enemy:message_on_under_attack("under_attack");
ga_ai_enemy:attack_on_message("under_attack");
ga_ai_enemy:message_on_casualties("hurt",0.95);
-- ga_ai_01:message_on_casualties("hurt",0.10);
-- ga_ai_02:reinforce_on_message("hurt",20000);
-- ga_ai_02:message_on_any_deployed("cavelry_arrived");




