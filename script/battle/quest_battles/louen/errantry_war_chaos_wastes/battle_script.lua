load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      	-- prevent deployment for ai
	function() 
				gb:start_generated_cutscene(gc) 
				bm:callback(function() bm:out("triggering dlc07.battle.speech.brt.final_battle_chaos.001"); bm:queue_advisor("dlc07.battle.speech.brt.final_battle_chaos.001") end, 6000);				
	end, 	-- intro cutscene function
	false                                      	-- debug mode
);

gc:add_element(nil,nil, "qb_louen_errantry_war_chaos_01", 8000, false, false, false);
gc:add_element(nil,nil, "qb_louen_errantry_war_chaos_02", 7000, false, false, false);
gc:add_element(nil, nil, "qb_louen_errantry_war_chaos_03", 8000, false, false, false);

gb:set_cutscene_during_deployment(true);
---------------------------
----HARD SCRIPT VERSION----
---------------------------
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_attack_defeat_army");

-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);	
ga_ai_ally_peasants = gb:get_army(gb:get_player_alliance_num(), 3);
ga_ai_ally_errants = gb:get_army(gb:get_player_alliance_num(), 2);


if gb:get_army(gb:get_non_player_alliance_num(), 3):are_unit_types_in_army({"wh_dlc01_chs_cha_kholek"}) then
ga_ai_chaos_01 = gb:get_army(gb:get_non_player_alliance_num(), 1);
ga_ai_cannon = gb:get_army(gb:get_non_player_alliance_num(), 1, "cannon");
ga_ai_chaos_02 = gb:get_army(gb:get_non_player_alliance_num(), 2);
ga_ai_chaos_03 = gb:get_army(gb:get_non_player_alliance_num(), 3);
ga_ai_chaos_04 = gb:get_army(gb:get_non_player_alliance_num(), 4);
else
ga_ai_chaos_01 = gb:get_army(gb:get_non_player_alliance_num(), 1);
ga_ai_cannon = gb:get_army(gb:get_non_player_alliance_num(), 1, "cannon");
ga_ai_chaos_02 = gb:get_army(gb:get_non_player_alliance_num(), 2);
ga_ai_chaos_03 = gb:get_army(gb:get_non_player_alliance_num(), 4);
ga_ai_chaos_04 = gb:get_army(gb:get_non_player_alliance_num(), 3);
end





-------OBJECTIVES-------
gb:queue_help_on_message("battle_started", "wh_dlc07_qb_brt_louen_errantry_war_chaos_wastes_01");
gb:queue_help_on_message("peasants_advance", "wh_dlc07_qb_brt_louen_errantry_war_chaos_wastes_02");
gb:queue_help_on_message("kholek_advance", "wh_dlc07_qb_brt_louen_errantry_war_chaos_wastes_03");
gb:queue_help_on_message("lord_of_change_advance", "wh_dlc07_qb_brt_louen_errantry_war_chaos_wastes_04");


-------ORDERS-------


ga_ai_cannon:defend_on_message("battle_started", -350, 370, 40);
ga_ai_ally_errants:attack_on_message("battle_started");

ga_ai_ally_peasants:reinforce_on_message("battle_started",200000);
ga_ai_ally_peasants:message_on_any_deployed("peasants_advance");
ga_ai_cannon:release_on_message("peasants_advance");

ga_ai_chaos_01:message_on_casualties("archaon_hurt",0.5);

ga_ai_chaos_03:reinforce_on_message("archaon_hurt",50000);
ga_ai_chaos_04:reinforce_on_message("archaon_hurt",250000);
ga_ai_chaos_03:reinforce_on_message("battle_started",400000);
ga_ai_chaos_04:reinforce_on_message("battle_started",600000);


ga_ai_ally_peasants:message_on_any_deployed("peasants_advance");
ga_ai_chaos_03:message_on_any_deployed("kholek_advance");
ga_ai_chaos_04:message_on_any_deployed("lord_of_change_advance");





