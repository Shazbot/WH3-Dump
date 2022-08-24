-- Dragon Encounter, Sun Dragon
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

-------ORDERS-------
gb:message_on_time_offset("dragon_attack", 5000);
ga_dragon_boss:move_to_position(v(-5,403,-92));
gb:message_on_time_offset("dragon_boss_attack", 60000);
ga_dragon_1:attack_on_message("dragon_attack");
ga_dragon_1:attack_on_message("dragon_attack");
ga_dragon_boss:attack_on_message("dragon_boss_attack");


-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh2_dlc15_qb_dragon_encounter_objective");

-------HINTS------------
gb:queue_help_on_message("battle_started", "wh2_dlc15_qb_dragon_encounter_ai_hint_objective");
gb:queue_help_on_message("dragon_boss_attack", "wh2_dlc15_qb_dragon_encounter_dragon_sun_spells");

--------ADVICE----------
gb:get_army(gb:get_player_alliance_num(), 1):message_on_victory("player_wins");
gb:advice_on_message("player_wins", "wh2.battle.advice.final_battle_victory.002");