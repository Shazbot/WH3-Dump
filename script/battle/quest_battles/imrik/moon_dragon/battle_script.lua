-- Dragon Encounter, Moon Dragon
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
ga_dragon_rein_1 = gb:get_army(gb:get_non_player_alliance_num(),"moon_rein_1");
ga_dragon_rein_2 = gb:get_army(gb:get_non_player_alliance_num(),"moon_rein_2");

-------ORDERS-------
gb:message_on_time_offset("dragon_attack", 5000);
ga_dragon_boss:move_to_position(v(165,272,164));
gb:message_on_time_offset("dragon_boss_attack", 60000);
gb:message_on_time_offset("rein_hint", 60000);
gb:message_on_time_offset("rein_arrive", 120000);
ga_dragon_1:attack_on_message("dragon_attack");
ga_dragon_boss:attack_on_message("dragon_boss_attack");
ga_dragon_rein_1:reinforce_on_message("rein_arrive", 1000);
ga_dragon_rein_2:reinforce_on_message("rein_arrive", 1000);
ga_dragon_rein_1:message_on_deployed("rein1_attack");
ga_dragon_rein_2:message_on_deployed("rein2_attack");
ga_dragon_rein_1:attack_on_message("rein1_attack");
ga_dragon_rein_2:attack_on_message("rein2_attack");

-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh2_dlc15_qb_dragon_encounter_objective");

-------HINTS------------
gb:queue_help_on_message("battle_started", "wh2_dlc15_qb_dragon_encounter_ai_hint_objective");
gb:queue_help_on_message("rein_hint", "wh2_dlc15_qb_dragon_encounter_dragon_moon_reinforcements_hint");
gb:queue_help_on_message("rein1_attack", "wh2_dlc15_qb_dragon_encounter_dragon_moon_reinforcements_arrive");


--------ADVICE----------
gb:get_army(gb:get_player_alliance_num(), 1):message_on_victory("player_wins");
gb:advice_on_message("player_wins", "wh2.battle.advice.final_battle_victory.002");