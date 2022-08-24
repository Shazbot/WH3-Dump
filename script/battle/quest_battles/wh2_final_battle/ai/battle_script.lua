-- Final Battle, AI defending
load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
	false,                                      		-- screen starts black
	false,                                     			-- prevent deployment for player
	false,                                     			-- prevent deployment for ai
	function() gb:start_generated_cutscene(gc) end, 	-- intro cutscene function
	false                                      			-- debug mode
);

gb:set_cutscene_during_deployment(true);

gc:add_element(nil, nil, "wh2_main_qb_final_battle_00", 8000, false, false, false);



-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh2_main_qb_final_battle_ai_main_objective");

-------HINTS-------
gb:queue_help_on_message("battle_started", "wh2_main_qb_final_battle_ai_hint_objective");

--------ADVICE----------
gb:get_army(gb:get_player_alliance_num(), 1):message_on_victory("player_wins");
gb:advice_on_message("player_wins", "wh2.battle.advice.final_battle_victory.002");