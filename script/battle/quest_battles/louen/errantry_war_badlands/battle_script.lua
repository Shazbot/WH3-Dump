load_script_libraries();

local gc = generated_cutscene:new(true);

gb = generated_battle:new(
	false,                                      -- screen starts black
	false,                                      -- prevent deployment for player
	false,                                      	-- prevent deployment for ai
	function() 
				gb:start_generated_cutscene(gc) 
				bm:callback(function() bm:out("triggering dlc07.battle.speech.brt.final_battle_orcs.001"); bm:queue_advisor("dlc07.battle.speech.brt.final_battle_orcs.001") end, 6000);				
	end, 	-- intro cutscene function
	false                                      	-- debug mode
);

gc:add_element(nil,nil, "qb_louen_errantry_war_chaos_01", 8000, false, false, false);
gc:add_element(nil,nil, "qb_louen_errantry_war_chaos_02", 9000, false, false, false);
gc:add_element(nil, nil, "qb_louen_errantry_war_chaos_03", 8000, false, false, false);

gb:set_cutscene_during_deployment(true);
---------------------------
----HARD SCRIPT VERSION----
---------------------------
gb:set_objective_on_message("deployment_started", "wh_main_qb_objective_attack_defeat_army");

-------ARMY SETUP-------
ga_player_01 = gb:get_army(gb:get_player_alliance_num(), 1);	
ga_ai_ally_peasants = gb:get_army(gb:get_player_alliance_num(), 2);
ga_ai_ally_errants = gb:get_army(gb:get_player_alliance_num(), 3);

ga_ai_greenskins_01 = gb:get_army(gb:get_non_player_alliance_num(), 1);
ga_ai_greenskins_02 = gb:get_army(gb:get_non_player_alliance_num(), 3);
ga_ai_greenskins_03 = gb:get_army(gb:get_non_player_alliance_num(), 2);
ga_ai_greenskins_04 = gb:get_army(gb:get_non_player_alliance_num(), 4);

--[[
if gb:get_army(gb:get_non_player_alliance_num(), 3):are_unit_types_in_army("wh_dlc06_grn_cha_wurrzag_1") then
	ga_ai_greenskins_01 = gb:get_army(gb:get_non_player_alliance_num(), 1);
	ga_ai_greenskins_02 = gb:get_army(gb:get_non_player_alliance_num(), 3);
	ga_ai_greenskins_03 = gb:get_army(gb:get_non_player_alliance_num(), 2);
	ga_ai_greenskins_04 = gb:get_army(gb:get_non_player_alliance_num(), 4);
else
	ga_ai_greenskins_01 = gb:get_army(gb:get_non_player_alliance_num(), 1);
	ga_ai_greenskins_02 = gb:get_army(gb:get_non_player_alliance_num(), 2);
	ga_ai_greenskins_03 = gb:get_army(gb:get_non_player_alliance_num(), 3);
	ga_ai_greenskins_04 = gb:get_army(gb:get_non_player_alliance_num(), 4);
end
]]





-------OBJECTIVES-------
gb:queue_help_on_message("battle_started", "wh_dlc07_qb_brt_louen_errantry_war_badlands_01");
gb:queue_help_on_message("azhag_advance", "wh_dlc07_qb_brt_louen_errantry_war_badlands_02");
gb:queue_help_on_message("wurrzag_advance", "wh_dlc07_qb_brt_louen_errantry_war_badlands_03");
gb:queue_help_on_message("errants_advance", "wh_dlc07_qb_brt_louen_errantry_war_badlands_04");
gb:queue_help_on_message("grimgor_appears", "wh_dlc07_qb_brt_louen_errantry_war_badlands_05");


-------ORDERS-------





ga_ai_ally_peasants:attack_on_message("battle_started");
ga_ai_ally_peasants:message_on_proximity_to_enemy("peasants_attack",20);
ga_ai_ally_peasants:release_on_message("peasants_attack");
ga_ai_greenskins_01:defend_on_message("battle_started",-100, 100, 60);
ga_ai_greenskins_01:message_on_proximity_to_enemy("bret_approach",150);
ga_ai_greenskins_01:release_on_message("bret_approach");

ga_ai_greenskins_01:message_on_casualties("skarsnik_hurt",0.35);
ga_ai_greenskins_02:reinforce_on_message("skarsnik_hurt",15000);
ga_ai_greenskins_02:message_on_any_deployed("wurrzag_advance"); 
ga_ai_greenskins_02:message_on_casualties("wurrzag_hurt",0.2);

ga_ai_greenskins_03:reinforce_on_message("wurrzag_hurt",10000);
ga_ai_greenskins_03:message_on_any_deployed("azhag_advance");

ga_player_01:message_on_casualties("player_hurt",0.5)
ga_ai_ally_errants:reinforce_on_message("player_hurt",1000);
ga_ai_ally_errants:reinforce_on_message("azhag_advance",120000);
ga_ai_ally_errants:message_on_any_deployed("errants_advance");

ga_ai_greenskins_03:message_on_casualties("azhag_hurt",0.5);
ga_ai_greenskins_04:reinforce_on_message("azhag_hurt",15000);
ga_ai_greenskins_04:reinforce_on_message("errants_advance",120000);
ga_ai_greenskins_04:message_on_any_deployed("grimgor_appears");






