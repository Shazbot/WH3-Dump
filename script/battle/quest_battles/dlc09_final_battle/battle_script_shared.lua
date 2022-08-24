
out("battle_script_shared.lua loaded");


function declare_armies()
	ga_player = gb:get_army(gb:get_player_alliance_num(), 1);
	if gb:get_army(gb:get_player_alliance_num(), 2):get_script_name() == "left" then
		ga_ally_01 = gb:get_army(gb:get_player_alliance_num(), 2);
		ga_ally_02 = gb:get_army(gb:get_player_alliance_num(), 3);
	else
		ga_ally_01 = gb:get_army(gb:get_player_alliance_num(), 3);
		ga_ally_02 = gb:get_army(gb:get_player_alliance_num(), 2);
	end
	for i = 1, 5, 1 do
		if gb:get_army(gb:get_non_player_alliance_num(), i):get_script_name() == "enemy_left" then
			ga_defender_01 = gb:get_army(gb:get_non_player_alliance_num(), i);
		elseif gb:get_army(gb:get_non_player_alliance_num(), i):get_script_name() == "enemy_right" then
			ga_defender_02 = gb:get_army(gb:get_non_player_alliance_num(), i);
		elseif gb:get_army(gb:get_non_player_alliance_num(), i):get_script_name() == "reinforcement_right" then
			ga_reinforcement_04 = gb:get_army(gb:get_non_player_alliance_num(), i);
		elseif gb:get_army(gb:get_non_player_alliance_num(), i):get_script_name() == "reinforcement_left" then
			ga_reinforcement_05 = gb:get_army(gb:get_non_player_alliance_num(), i);
		else
			ga_arkhan_03 = gb:get_army(gb:get_non_player_alliance_num(), i);
		end
	end;
end

function battle_orders()
	ga_defender_01:halt();
	ga_defender_02:halt();
	
	ga_reinforcement_04:reinforce_on_message("casualty_high_all", 1000);
	ga_reinforcement_05:reinforce_on_message("casualty_high_all", 1000);
	ga_arkhan_03:reinforce_on_message("casualty_high_all");
	ga_reinforcement_04:defend_on_message("casualty_high_all", 250, 560, 10); 
	ga_reinforcement_05:defend_on_message("casualty_high_all",-140, 560, 10); 
	ga_arkhan_03:defend_on_message("casualty_high_all",52, 550, 10); 
	
	ga_defender_01:message_on_casualties("release_01", 0.3);
	ga_defender_02:message_on_casualties("release_02", 0.3);
	ga_defender_01:release_on_message("release_01");
	ga_defender_02:release_on_message("release_02");
	ga_arkhan_03:message_on_casualties("release_03", 0.3);
	ga_arkhan_03:release_on_message("release_03");
	ga_reinforcement_04:message_on_casualties("release_04", 0.3);
	ga_reinforcement_05:message_on_casualties("release_05", 0.3);
	ga_reinforcement_04:release_on_message("release_04");
	ga_reinforcement_05:release_on_message("release_05");
	
	ga_defender_01:defend_on_message("01_intro_cutscene_end", -160, 560, 10); 
	ga_ally_01:defend_on_message("01_intro_cutscene_end", -160, 560, 10); 
	ga_defender_02:defend_on_message("01_intro_cutscene_end", 270, 560, 10); 
	ga_ally_02:defend_on_message("01_intro_cutscene_end", 270, 560, 10); 

	ga_defender_01:message_on_casualties("casualty_high_0", 0.8);
	ga_defender_02:message_on_casualties("casualty_high_1", 0.8);

	gb:message_on_all_messages_received("casualty_high_all", "casualty_high_0", "casualty_high_1");
	gb:message_on_time_offset("unlock_first_ability", 120000);
	gb:message_on_time_offset("unlock_second_ability", 180000);
end;

function battle_message()
	gb:set_objective_on_message("deployment_started", "wh2_dlc09_tmb_qb_final_battle_objective_defeat_first_wave");
	gb:set_objective_on_message("casualty_high_all", "wh2_dlc09_tmb_qb_final_battle_objective_defeat_second_wave");
	gb:queue_help_on_message("01_intro_cutscene_end", "wh2_dlc09_tmb_qb_final_battle_hint_defeat_first_wave",10000,1000);
	gb:queue_help_on_message("casualty_high_all", "wh2_dlc09_tmb_qb_final_battle_hint_defeat_second_wave",10000,1000);
	gb:complete_objective_on_message("casualty_high_all", "wh2_dlc09_tmb_qb_final_battle_objective_defeat_first_wave");
end