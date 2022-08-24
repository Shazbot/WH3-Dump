-- Dragon Encounter, Star Dragon
load_script_libraries();

gb = generated_battle:new(
	false,                                      		-- screen starts black
	false,                                     			-- prevent deployment for player
	false,                                     			-- prevent deployment for ai
	nil, 												-- intro cutscene function
	false                                      			-- debug mode
);

-------ARMY SETUP-------

ga_dragon_1 = gb:get_army(gb:get_non_player_alliance_num(),"dragon_army");
ga_dragon_boss = gb:get_army(gb:get_non_player_alliance_num(),"dragon_army_boss");
ga_dragon_reinforcements = gb:get_army(gb:get_non_player_alliance_num(),"star_reinforcements");

-------ORDERS-------
gb:message_on_time_offset("dragon_attack", 5000);
gb:message_on_time_offset("ground_1", 30000);
gb:message_on_time_offset("dragon_boss_attack", 60000);
gb:message_on_time_offset("ground_2", 90000);
gb:message_on_time_offset("star_rein", 120000);
ga_dragon_1:attack_on_message("dragon_attack");
ga_dragon_boss:attack_on_message("dragon_boss_attack");
ga_dragon_reinforcements:reinforce_on_message("star_rein", 1000);
ga_dragon_reinforcements:message_on_deployed("star_attack");
ga_dragon_reinforcements:attack_on_message("star_attack");

-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh2_dlc15_qb_dragon_encounter_objective");

-------HINTS------------
gb:queue_help_on_message("battle_started", "wh2_dlc15_qb_dragon_encounter_ai_hint_objective");
gb:queue_help_on_message("ground_1", "wh2_dlc15_qb_dragon_encounter_dragon_star_ground_1");
gb:queue_help_on_message("ground_2", "wh2_dlc15_qb_dragon_encounter_dragon_star_ground_2");
gb:queue_help_on_message("star_attack", "wh2_dlc15_qb_dragon_encounter_dragon_star_reinforcements");

--------ADVICE----------
gb:get_army(gb:get_player_alliance_num(), 1):message_on_victory("player_wins");
gb:advice_on_message("player_wins", "wh2.battle.advice.final_battle_victory.002");