if cm:is_multiplayer() then
	cm:trigger_custom_mission_from_string(
		"wh3_main_ksl_the_great_orthodoxy",
		[[mission
			{
				victory_type wh3_main_victory_type_mp;
				key wh3_main_mp_victory;
				issuer CLAN_ELDERS;
				primary_objectives_and_payload
				{
					objective
					{
						override_text mission_text_text_mis_activity_complete_realms_multiplayer;
						type SCRIPTED;
						script_key realms_multiplayer;
					}
					objective
					{
						override_text mission_text_text_mis_activity_win_forge_of_souls_final_battle;
						type SCRIPTED;
						script_key forge_of_souls_battle;
					}
					
					//
					
					payload
					{
						game_victory;
					}
				}
			}]]
	);
else
	cm:trigger_custom_mission_from_string(
		"wh3_main_ksl_the_great_orthodoxy",
		[[mission
			{
				victory_type wh3_main_victory_type_chaos_forge_of_souls;
				key wh_main_long_victory;
				issuer CLAN_ELDERS;
				primary_objectives_and_payload
				{
					objective
					{
						override_text mission_text_text_mis_activity_complete_realm_khorne;
						type SCRIPTED;
						script_key realm_khorne;
					}
					objective
					{
						override_text mission_text_text_mis_activity_complete_realm_nurgle;
						type SCRIPTED;
						script_key realm_nurgle;
					}
					objective
					{
						override_text mission_text_text_mis_activity_complete_realm_slaanesh;
						type SCRIPTED;
						script_key realm_slaanesh;
					}
					objective
					{
						override_text mission_text_text_mis_activity_complete_realm_tzeentch;
						type SCRIPTED;
						script_key realm_tzeentch;
					}
					objective
					{
						override_text mission_text_text_mis_activity_win_forge_of_souls_final_battle;
						type SCRIPTED;
						script_key forge_of_souls_battle;
					}
					
					payload
					{
						game_victory;
					}
				}
			}]]
	);

	cm:trigger_custom_mission_from_string(
		"wh3_main_ksl_the_great_orthodoxy",
		[[mission
			{
				victory_type wh3_main_victory_type_chaos_domination;
				key wh3_main_chaos_domination_victory;
				issuer CLAN_ELDERS;
				primary_objectives_and_payload
				{
					objective
					{
						type DESTROY_FACTION;
						faction wh3_main_kho_exiles_of_khorne;
						faction wh3_main_dae_daemon_prince;
						faction wh3_main_nur_poxmakers_of_nurgle;
						faction wh3_main_ogr_disciples_of_the_maw;
						faction wh3_main_ogr_goldtooth;
						faction wh3_main_sla_seducers_of_slaanesh;
						faction wh3_main_tze_oracles_of_tzeentch;
						faction wh3_main_cth_the_western_provinces;
						faction wh3_main_cth_the_northern_provinces;
						confederation_valid;
					}
					
					objective
					{
						type CONTROL_N_PROVINCES_INCLUDING;							// Capture at least 50 provinces
						total 50;
					}
					
					objective
					{
						type SCRIPTED;
						script_key domination;
					}
					
					//
					
					payload
					{
						game_victory;
					}
				}
			}]]
	);
end;