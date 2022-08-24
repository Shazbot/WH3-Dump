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

gc:add_element(nil, nil, "gc_orbit_90_medium_commander_front_close_low_01", 8000, false, false, false);

-------ARMIES-------
ga_player = gb:get_army(gb:get_player_alliance_num(), 1);

-------ARMY BEHAVIOUR-------
ga_player:grant_infinite_ammo_on_message("battle_started");
ga_player:add_winds_of_magic_reserve_on_message("battle_started", 100);

-------OBJECTIVES-------
gb:set_objective_on_message("deployment_started", "wh2_main_qb_final_battle_main_objective_defeat_grey_seer_clan_reinforcements");

-------HINTS-------
gb:queue_help_on_message("battle_started", "wh2_main_qb_final_battle_hint_objective_defeat_grey_seer_clan_defence");