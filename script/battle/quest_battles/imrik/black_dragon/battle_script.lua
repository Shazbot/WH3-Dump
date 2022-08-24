-- Dragon Encounter, Black Dragon
load_script_libraries();

gb = generated_battle:new(
	false,                                      		-- screen starts black
	false,                                     			-- prevent deployment for player
	false,                                     			-- prevent deployment for ai
	nil, 												-- intro cutscene function
	false                                      			-- debug mode
);

-------ARMY SETUP-------

ga_dragon_reinforcements = gb:get_army(gb:get_non_player_alliance_num(),"dragon_army");
ga_dragon_undead = gb:get_army(gb:get_non_player_alliance_num(),"undead_army");

-------ORDERS-------
gb:message_on_time_offset("zombie_attack", 10000);
gb:message_on_time_offset("release_dragon", 120000);
ga_dragon_undead:attack_on_message("zombie_attack");
ga_dragon_reinforcements:reinforce_on_message("release_dragon", 1000);
ga_dragon_reinforcements:message_on_deployed("dragon_attack");
ga_dragon_reinforcements:attack_on_message("dragon_attack");

-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh2_dlc15_qb_dragon_encounter_objective");

-------HINTS------------
gb:queue_help_on_message("battle_started", "wh2_dlc15_qb_dragon_encounter_ai_hint_objective");
gb:queue_help_on_message("dragon_attack", "wh2_dlc15_qb_dragon_encounter_dragon_appears")
gb:queue_help_on_message("zombie_attack", "wh2_dlc15_qb_dragon_encounter_zombie_wave");


--------ADVICE----------
gb:get_army(gb:get_player_alliance_num(), 1):message_on_victory("player_wins");
gb:advice_on_message("player_wins", "wh2.battle.advice.final_battle_victory.002");