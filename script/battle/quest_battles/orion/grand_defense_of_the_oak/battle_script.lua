load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      	-- prevent deployment for ai
	function() 
				gb:start_generated_cutscene(gc) 
				bm:callback(function() bm:out("triggering dlc05.battle.advice.final.wef.01"); bm:queue_advisor("dlc05.battle.advice.final.wef.01") end, 2000);				
				bm:callback(function() bm:out("triggering dlc05.battle.advice.final.wef.02"); bm:queue_advisor("dlc05.battle.advice.final.wef.02") end, 10000);
				bm:callback(function() bm:out("triggering dlc05.battle.advice.final.wef.03"); bm:queue_advisor("dlc05.battle.advice.final.wef.03") end, 18500);
	end, 	-- intro cutscene function
	false                                      	-- debug mode
);

gc:add_element(nil,nil, "gc_qb_defense_of_the_oak_01", 7000, false, false, false);
gc:add_element(nil,nil, "gc_qb_defense_of_the_oak_02", 9000, false, false, false);
gc:add_element(nil, nil, "gc_orbit_90_medium_commander_front_close_low_01", 8000, false, false, false);

gb:set_cutscene_during_deployment(true);
---------------------------
----HARD SCRIPT VERSION----
---------------------------
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_attack_defeat_army");

-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);	
ga_ai_wef_ally_02 = gb:get_army(gb:get_player_alliance_num(), 2);
ga_ai_bst_ally_01 = gb:get_army(gb:get_non_player_alliance_num(), 1);
ga_ai_bst_ally_02 = gb:get_army(gb:get_non_player_alliance_num(), 2);
ga_ai_bst_ally_03 = gb:get_army(gb:get_non_player_alliance_num(), 3);
ga_ai_morghur = gb:get_army(gb:get_non_player_alliance_num(), 4);


-------OBJECTIVES-------
gb:queue_help_on_message("battle_started", "wh_dlc05_qb_wef_grand_defense_of_the_oak_hint_objective");


-------ORDERS-------

--ga_ai_morghur:halt()
--ga_ai_bst_ally2:halt()
--ga_ai_wef_ally_02:halt()

ga_ai_morghur:attack_on_message("morghur_advance");
ga_ai_bst_ally_01:attack_on_message("battle_started");
--ga_ai_bst_ally_02:attack_on_message("battle_started");
ga_ai_bst_ally_03:attack_on_message("malagor_advance");

ga_ai_bst_ally_01:message_on_casualties("bst_ally_01_hurt",0.35);
ga_ai_bst_ally_02:message_on_casualties("bst_ally_02_hurt",0.50);
ga_ai_bst_ally_03:message_on_casualties("bst_ally_03_hurt",0.55);
ga_player_01:message_on_casualties("ga_player_01_hurt",0.50);

ga_ai_bst_ally_02:reinforce_on_message("bst_ally_01_hurt",15000);
ga_ai_bst_ally_02:reinforce_on_message("battle_started",180000);
ga_ai_bst_ally_03:reinforce_on_message("bst_ally_02_hurt",15000);
ga_ai_bst_ally_03:reinforce_on_message("battle_started",360000);
ga_ai_morghur:reinforce_on_message("bst_ally_03_hurt",15000);
ga_ai_morghur:reinforce_on_message("battle_started",660000);
ga_ai_wef_ally_02:reinforce_on_message("ga_player_01_hurt",15000);
ga_ai_wef_ally_02:reinforce_on_message("battle_started",600000);

ga_ai_bst_ally_02:message_on_any_deployed("khazrak_advance");
ga_ai_bst_ally_03:message_on_any_deployed("malagor_advance");
ga_ai_morghur:message_on_any_deployed("morghur_advance");
ga_ai_wef_ally_02:message_on_any_deployed("defender_reinforce");

gb: queue_help_on_message("malagor_advance", "wh_dlc05_qb_wef_grand_defense_of_the_oak_hint_malagor_advance");
gb: queue_help_on_message("morghur_advance", "wh_dlc05_qb_wef_grand_defense_of_the_oak_hint_morghur_advance");
gb: queue_help_on_message("khazrak_advance", "wh_dlc05_qb_wef_grand_defense_of_the_oak_hint_khazrak_advance");
gb: queue_help_on_message("defender_reinforce", "wh_dlc05_qb_wef_grand_defense_of_the_oak_hint_defender_reinforce");





