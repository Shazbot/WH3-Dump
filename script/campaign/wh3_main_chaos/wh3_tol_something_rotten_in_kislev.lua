-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	TOL - SOMETHING ROTTEN IN KISLEV
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

local starting_leader_level = 10;

cm:add_first_tick_callback_new(
	function()
		if cm:tol_campaign_key() == "wh3_main_tol_something_rotten_in_kislev" then
			tol_shared_setup();
			
			-- Katarin
			local ice_court_faction = cm:get_faction("wh3_main_ksl_the_ice_court");
			cm:treasury_mod("wh3_main_ksl_the_ice_court", 10000);
			cm:faction_add_pooled_resource("wh3_main_ksl_the_ice_court", "wh3_main_ksl_devotion", "events", 200);
			
			cm:add_building_to_settlement("wh3_main_chaos_region_kislev", "wh3_main_ksl_kislev_city_4");
			cm:add_building_to_settlement("wh3_main_chaos_region_kislev", "wh3_main_ksl_city_gold_4");
			cm:heal_garrison(cm:get_region("wh3_main_chaos_region_kislev"):cqi());
			
			cm:spawn_agent_at_position(
				ice_court_faction,
				408,
				121,
				"wizard",
				"wh3_main_ksl_frost_maiden_ice"
			);
				
			local kat = cm:char_lookup_str(ice_court_faction:faction_leader());
			
			cm:grant_unit_to_character(kat, "wh3_main_ksl_inf_armoured_kossars_1");
			cm:grant_unit_to_character(kat, "wh3_main_ksl_cav_gryphon_legion_0");
			cm:grant_unit_to_character(kat, "wh3_main_ksl_inf_streltsi_0");
			
			-- Kostaltyn
			local great_orthodoxy_faction = cm:get_faction("wh3_main_ksl_the_great_orthodoxy");
			cm:treasury_mod("wh3_main_ksl_the_great_orthodoxy", 15000);
			cm:apply_effect_bundle("wh3_main_background_income_mod_50", "wh3_main_ksl_the_great_orthodoxy", 0);
			cm:faction_add_pooled_resource("wh3_main_ksl_the_great_orthodoxy", "wh3_main_ksl_devotion", "events", 200);
			
			
			region_change(
				"wh3_main_chaos_region_erengrad",
				"wh3_main_ksl_the_great_orthodoxy",
				{
					"wh3_main_ksl_erengrad_city_4",
					"wh3_main_ksl_city_gold_4",
					"wh3_main_special_ksl_erengrad_3_4"
				}
			);
			
			cm:spawn_agent_at_position(
				great_orthodoxy_faction,
				265,
				145,
				"dignitary",
				"wh3_main_ksl_patriarch"
			);
			
			teleport_character_faction_leader("wh3_main_ksl_the_great_orthodoxy", 266, 135);
			teleport_character_by_forename("wh3_main_ksl_the_great_orthodoxy", "names_name_2147356081", 270, 144);
			
			cm:grant_unit_to_character(cm:char_lookup_str(great_orthodoxy_faction:faction_leader()), "wh3_main_ksl_inf_armoured_kossars_1");
			
			cm:create_force(
				"wh3_main_ksl_the_great_orthodoxy",
				"wh3_main_ksl_inf_kossars_1,wh3_main_ksl_cav_horse_archers_0,wh3_main_ksl_cav_horse_archers_0,wh3_main_ksl_cav_horse_raiders_0,wh3_main_ksl_inf_kossars_1,wh3_main_ksl_inf_kossars_0,wh3_main_ksl_inf_kossars_0,wh3_main_ksl_inf_kossars_0,wh3_main_ksl_inf_kossars_1,wh3_main_ksl_inf_kossars_1,wh3_main_ksl_inf_kossars_1,wh3_main_ksl_inf_kossars_1,wh3_main_ksl_inf_kossars_0,wh3_main_ksl_inf_kossars_0",
				"wh3_main_chaos_region_kislev",
				265,
				140,
				false
			);
			
			-- Boris
			local ursun_revivalists_faction = cm:get_faction("wh3_main_ksl_ursun_revivalists");
			cm:treasury_mod("wh3_main_ksl_ursun_revivalists", 10000);
			cm:faction_add_pooled_resource("wh3_main_ksl_ursun_revivalists", "wh3_main_ksl_devotion", "events", 200);
			
			region_change(
				"wh3_main_chaos_region_praag",
				"wh3_main_ksl_ursun_revivalists",
				{
					"wh3_main_ksl_praag_city_4",
					"wh3_main_ksl_city_gold_4"
				}
			);
			
			cm:spawn_agent_at_position(
				ursun_revivalists_faction,
				403,
				169,
				"wizard",
				"wh3_main_ksl_frost_maiden_tempest"
			);
			
			region_change("wh3_main_chaos_region_fort_dorznye_vort", "wh3_main_grn_dark_land_orcs");
			
			teleport_character_faction_leader("wh3_main_ksl_ursun_revivalists", 410, 172);
			
			local boris = cm:char_lookup_str(ursun_revivalists_faction:faction_leader());
			cm:grant_unit_to_character(boris, "wh3_main_ksl_inf_armoured_kossars_1");
			cm:grant_unit_to_character(boris, "wh3_main_ksl_cav_gryphon_legion_0");
			cm:grant_unit_to_character(boris, "wh3_main_ksl_inf_streltsi_0");
			
			cm:force_make_peace("wh3_main_ksl_ursun_revivalists", "wh3_main_grn_dark_land_orcs");
			
			-- Player faction Diplomacy
			cm:force_make_trade_agreement("wh3_main_ksl_the_ice_court", "wh3_main_ksl_the_great_orthodoxy")
			cm:force_make_trade_agreement("wh3_main_ksl_the_ice_court", "wh3_main_ksl_ursun_revivalists")
			cm:force_make_trade_agreement("wh3_main_ksl_the_great_orthodoxy", "wh3_main_ksl_ursun_revivalists")
			
			cm:force_diplomacy("culture:wh3_main_ksl_kislev", "all", "trade agreement", false, false, true);
			cm:force_diplomacy("culture:wh3_main_ksl_kislev", "all", "regions", false, false, true);
			
			cm:force_diplomacy("faction:wh3_main_ksl_the_ice_court", "faction:wh3_main_ksl_the_great_orthodoxy", "regions", true, true, true);
			cm:force_diplomacy("faction:wh3_main_ksl_the_ice_court", "faction:wh3_main_ksl_ursun_revivalists", "regions", true, true, true);
			
			-- Khorne
			cm:treasury_mod("wh3_main_kho_crimson_skull", 10000);
			
			cm:apply_effect_bundle("wh3_main_background_income_mod_1000", "wh3_main_kho_crimson_skull", 0)
			
			region_change_faction_to_faction("wh3_main_kho_crimson_skull", "wh3_main_sla_seducers_of_slaanesh");
			
			region_change(
				"wh3_main_chaos_region_castle_alexandronov",
				"wh3_main_kho_crimson_skull",
				{
					"wh3_main_kho_settlement_minor_3",
					"wh3_main_kho_walls_minor_2"
				}
			);
			
			region_change(
				"wh3_main_chaos_region_dhazhyn",
				"wh3_main_kho_crimson_skull",
				{
					"wh3_main_kho_settlement_minor_3",
					"wh3_main_kho_walls_minor_2"
				}
			);
			
			region_change(
				"wh3_main_chaos_region_fort_straghov",
				"wh3_main_kho_crimson_skull",
				{
					"wh3_main_kho_settlement_minor_3",
					"wh3_main_kho_walls_minor_2",
					"wh3_main_kho_warriors_1"
				}
			);
			
			region_change(
				"wh3_main_chaos_region_leblya",
				"wh3_main_kho_crimson_skull",
				{
					"wh3_main_kho_settlement_minor_3",
					"wh3_main_kho_walls_minor_2",
					"wh3_main_kho_bloodletters_1"
				}
			);
			
			teleport_character_faction_leader("wh3_main_kho_crimson_skull", 238, 199);
			
			cm:force_declare_war("wh3_main_kho_crimson_skull", "wh3_main_ksl_the_great_orthodoxy", false, false);
			cm:force_declare_war("wh3_main_kho_crimson_skull", "wh3_main_ksl_ursun_revivalists", false, false);
			cm:force_declare_war("wh3_main_kho_crimson_skull", "wh3_main_ksl_the_ice_court", false, false);
			
			local kho_inv_1 = invasion_manager:new_invasion(
				"kho_inv_1",
				"wh3_main_kho_crimson_skull",
				"wh3_main_kho_inf_bloodletters_0,wh3_main_kho_inf_bloodletters_0,wh3_main_kho_inf_bloodletters_0,wh3_main_kho_inf_chaos_warriors_0,wh3_main_kho_inf_chaos_warhounds_0",
				{254, 174}
			);
			
			kho_inv_1:set_target("PATROL", {{x = 254, y = 174}, {x = 254, y = 174}});
			kho_inv_1:add_aggro_radius(100);
			kho_inv_1:apply_effect("wh_main_bundle_military_upkeep_free_force", -1);
			kho_inv_1:start_invasion();
			
			local kho_inv_2 = invasion_manager:new_invasion(
				"kho_inv_2",
				"wh3_main_kho_crimson_skull",
				"wh3_main_kho_inf_bloodletters_0,wh3_main_kho_inf_bloodletters_0,wh3_main_kho_inf_bloodletters_0,wh3_main_kho_inf_chaos_warriors_0,wh3_main_kho_inf_chaos_warhounds_0",
				{290, 212}
			);
			
			kho_inv_2:set_target("PATROL", {{x = 290, y = 212}, {x = 290, y = 212}});
			kho_inv_2:add_aggro_radius(100);
			kho_inv_2:apply_effect("wh_main_bundle_military_upkeep_free_force", -1);
			kho_inv_2:start_invasion();
			
			local khorne_settlements = {
				{230, 195}, -- castle alexandronov
				{280, 204}, -- leblya
				{313, 214}, -- dhazyn
				{315, 236} -- fort straghov
			};
			
			for i = 1, #khorne_settlements do
				cm:create_force(
					"wh3_main_kho_crimson_skull",
					"wh3_main_kho_cav_bloodcrushers_0,wh3_main_kho_cav_bloodcrushers_0,wh3_main_kho_cav_gorebeast_chariot,wh3_main_kho_cav_skullcrushers_0,wh3_main_kho_cav_skullcrushers_0,wh3_main_kho_inf_bloodletters_1,wh3_main_kho_inf_bloodletters_1,wh3_main_kho_inf_chaos_warhounds_0,wh3_main_kho_inf_chaos_warriors_1,wh3_main_kho_inf_chaos_warriors_2,wh3_main_kho_inf_chaos_warriors_2,wh3_main_kho_mon_bloodthirster_0,wh3_main_kho_mon_khornataurs_0,wh3_main_kho_mon_khornataurs_1,wh3_main_kho_mon_soul_grinder_0,wh3_main_kho_mon_spawn_of_khorne_0,wh3_main_kho_mon_spawn_of_khorne_0,wh3_main_kho_veh_blood_shrine_0,wh3_main_kho_veh_skullcannon_0",
					"wh3_main_chaos_region_kislev",
					khorne_settlements[i][1],
					khorne_settlements[i][2],
					false,
					function(cqi)
						cm:cai_disable_movement_for_character(cm:char_lookup_str(cqi));
						cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force", cqi, 0);
					end
				);
			end;
			
			local khorne_free_armies = {
				{265, 228}, -- 1
				{253, 227}, -- 2
				{280, 231}, -- 3
				{237, 213}, -- 4
				{235, 215}, -- 5
			};
			
			local tol_difficulty = cm:get_difficulty()
			local locked_armies_khorne = {};
			local temp_cqi = 0;
			
			for i = 1, tol_difficulty do
				cm:create_force(
					"wh3_main_kho_crimson_skull",
					"wh3_main_kho_cav_bloodcrushers_0,wh3_main_kho_cav_bloodcrushers_0,wh3_main_kho_cav_gorebeast_chariot,wh3_main_kho_cav_skullcrushers_0,wh3_main_kho_cav_skullcrushers_0,wh3_main_kho_inf_bloodletters_1,wh3_main_kho_inf_bloodletters_1,wh3_main_kho_inf_chaos_warhounds_0,wh3_main_kho_inf_chaos_warriors_1,wh3_main_kho_inf_chaos_warriors_2,wh3_main_kho_inf_chaos_warriors_2,wh3_main_kho_mon_bloodthirster_0,wh3_main_kho_mon_khornataurs_0,wh3_main_kho_mon_khornataurs_1,wh3_main_kho_mon_soul_grinder_0,wh3_main_kho_mon_spawn_of_khorne_0,wh3_main_kho_mon_spawn_of_khorne_0,wh3_main_kho_veh_blood_shrine_0,wh3_main_kho_veh_skullcannon_0",
					"wh3_main_chaos_region_kislev",
					khorne_free_armies[i][1],
					khorne_free_armies[i][2],
					false,
					function(cqi)
						temp_cqi = cqi;
						cm:cai_disable_movement_for_character(cm:char_lookup_str(cqi));
						cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force", cqi, 0);
					end
				);
				locked_armies_khorne[i]=temp_cqi;
			end;
			
			local khorne_leader = cm:get_closest_character_to_position_from_faction(
					cm:get_faction("wh3_main_kho_crimson_skull"),
					238,
					199,
					true,
					false,
					false,
					false
					)
			
			cm:cai_disable_movement_for_character(cm:char_lookup_str(khorne_leader:command_queue_index()));
			table.insert(locked_armies_khorne, khorne_leader:command_queue_index())
			
			cm:set_saved_value("locked_armies_khorne", locked_armies_khorne);
			
			-- Nurgle
			cm:treasury_mod("wh3_main_nur_septic_claw", 10000);
			
			cm:apply_effect_bundle("wh3_main_background_income_mod_1000", "wh3_main_nur_septic_claw", 0)
			
			region_change_faction_to_faction("wh3_main_nur_septic_claw", "wh3_main_sla_subtle_torture");
			
			region_change(
				"wh3_main_chaos_region_bolgasgrad",
				"wh3_main_nur_septic_claw",
				{
					"wh3_main_nur_settlement_minor_3"
				}
			);
			
			region_change(
				"wh3_main_chaos_region_dushyka",
				"wh3_main_nur_septic_claw",
				{
					"wh3_main_nur_settlement_minor_3"
				}
			);
			
			region_change(
				"wh3_main_chaos_region_fort_ostrosk",
				"wh3_main_nur_septic_claw",
				{
					"wh3_main_nur_settlement_minor_3"
				}
			);
			
			region_change(
				"wh3_main_chaos_region_zoishenk",
				"wh3_main_nur_septic_claw",
				{
					"wh3_main_nur_settlement_minor_3"
				}
			);
			
			teleport_character_faction_leader("wh3_main_nur_septic_claw", 335, 178);
			
			cm:force_declare_war("wh3_main_nur_septic_claw", "wh3_main_ksl_the_great_orthodoxy", false, false);
			cm:force_declare_war("wh3_main_nur_septic_claw", "wh3_main_ksl_ursun_revivalists", false, false);
			cm:force_declare_war("wh3_main_nur_septic_claw", "wh3_main_ksl_the_ice_court", false, false);
			
			local nur_inv_1 = invasion_manager:new_invasion(
				"nur_inv_1",
				"wh3_main_nur_septic_claw",
				"wh3_main_nur_mon_plague_toads_0,wh3_main_nur_inf_nurglings_0,wh3_main_nur_inf_plaguebearers_0,wh3_main_nur_inf_plaguebearers_0,wh3_main_nur_inf_plaguebearers_0",
				{386, 129}
			);
			
			nur_inv_1:set_target("PATROL", {{x = 386, y = 212}, {x = 386, y = 129}});
			nur_inv_1:add_aggro_radius(100);
			nur_inv_1:apply_effect("wh_main_bundle_military_upkeep_free_force", -1);
			nur_inv_1:start_invasion();
			
			local nur_inv_2 = invasion_manager:new_invasion(
				"nur_inv_2",
				"wh3_main_nur_septic_claw",
				"wh3_main_nur_mon_plague_toads_0,wh3_main_nur_inf_nurglings_0,wh3_main_nur_inf_plaguebearers_0,wh3_main_nur_inf_plaguebearers_0,wh3_main_nur_inf_plaguebearers_0",
				{271, 160}
			);
			
			nur_inv_2:set_target("PATROL", {{x = 271, y = 160}, {x = 271, y = 160}});
			nur_inv_2:add_aggro_radius(100);
			nur_inv_2:apply_effect("wh_main_bundle_military_upkeep_free_force", -1);
			nur_inv_2:start_invasion();
			
			local nurgle_settlements = {
				{281, 171}, -- zoishenk
				{324, 184}, -- fort ostrosk
				{360, 170}, -- dushyka
				{378, 146} -- bolgasgrad
			};
			
			for i = 1, #nurgle_settlements do
				cm:create_force(
					"wh3_main_nur_septic_claw",
					random_army_manager:generate_force("nurgle_early", 20, false),
					"wh3_main_chaos_region_kislev",
					nurgle_settlements[i][1],
					nurgle_settlements[i][2],
					false,
					function(cqi)
						cm:cai_disable_movement_for_character(cm:char_lookup_str(cqi));
						cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force", cqi, 0);
					end
				);
			end;
			
			local nurgle_free_armies = {
				{349, 172}, --1
				{362, 177}, --2
				{286, 176}, --3 
				{329, 189}, --4
				{384, 152}  --5
			};
			for i = 1, tol_difficulty do
				cm:create_force(
					"wh3_main_nur_septic_claw",
					random_army_manager:generate_force("nurgle_late", 20, false),
					"wh3_main_chaos_region_kislev",
					nurgle_free_armies[i][1],
					nurgle_free_armies[i][2],
					false,
					function(cqi)
						cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force", cqi, 0);
					end
				);
			end;
			
			
			-- Slaanesh
			cm:treasury_mod("wh3_main_sla_exquisite_pain", 10000);
			
			cm:apply_effect_bundle("wh3_main_background_income_mod_1000", "wh3_main_sla_exquisite_pain", 0)
			
			region_change_faction_to_faction("wh3_main_sla_exquisite_pain", "wh3_main_kho_bloody_sword");
			
			region_change(
				"wh3_main_chaos_region_fort_jakova",
				"wh3_main_sla_exquisite_pain",
				{
					"wh3_main_sla_settlement_minor_3",
					"wh3_main_sla_walls_minor_2",
					"wh3_main_sla_marauders_2",
				}
			);
			
			region_change(
				"wh3_main_chaos_region_gerslev",
				"wh3_main_sla_exquisite_pain",
				{
					"wh3_main_sla_settlement_minor_3",
					"wh3_main_sla_walls_minor_2"
				}
			);
			
			region_change(
				"wh3_main_chaos_region_igerov",
				"wh3_main_sla_exquisite_pain",
				{
					"wh3_main_sla_settlement_minor_3",
					"wh3_main_sla_walls_minor_2"
				}
			);
			
			region_change(
				"wh3_main_chaos_region_volksgrad",
				"wh3_main_sla_exquisite_pain",
				{
					"wh3_main_sla_settlement_minor_3",
					"wh3_main_sla_walls_minor_2",
					"wh3_main_sla_cav_2",
				}
			);
			
			teleport_character_faction_leader("wh3_main_sla_exquisite_pain", 491, 139);
			
			cm:force_declare_war("wh3_main_sla_exquisite_pain", "wh3_main_ksl_the_great_orthodoxy", false, false);
			cm:force_declare_war("wh3_main_sla_exquisite_pain", "wh3_main_ksl_ursun_revivalists", false, false);
			cm:force_declare_war("wh3_main_sla_exquisite_pain", "wh3_main_ksl_the_ice_court", false, false);
			
			local sla_inv_1 = invasion_manager:new_invasion(
				"sla_inv_1",
				"wh3_main_sla_exquisite_pain",
				"wh3_main_sla_cav_hellstriders_0,wh3_main_sla_inf_daemonette_0,wh3_main_sla_inf_daemonette_0,wh3_main_sla_inf_daemonette_0,wh3_main_sla_inf_marauders_0,wh3_main_sla_inf_marauders_1",
				{447, 121}
			);
			
			sla_inv_1:set_target("PATROL", {{x = 447, y = 121}, {x = 447, y = 121}});
			sla_inv_1:add_aggro_radius(100);
			sla_inv_1:apply_effect("wh_main_bundle_military_upkeep_free_force", -1);
			sla_inv_1:start_invasion();
			
			local sla_inv_2 = invasion_manager:new_invasion(
				"sla_inv_2",
				"wh3_main_sla_exquisite_pain",
				"wh3_main_sla_cav_hellstriders_0,wh3_main_sla_inf_daemonette_0,wh3_main_sla_inf_daemonette_0,wh3_main_sla_inf_daemonette_0,wh3_main_sla_inf_marauders_0,wh3_main_sla_inf_marauders_1",
				{454, 158}
			);
			
			sla_inv_2:set_target("PATROL", {{x = 454, y = 158}, {x = 454, y = 158}});
			sla_inv_2:add_aggro_radius(100);
			sla_inv_2:apply_effect("wh_main_bundle_military_upkeep_free_force", -1);
			sla_inv_2:start_invasion();
			
			local slaanesh_settlements = {
				{462, 125}, -- gerslev
				{493, 135}, -- leblya
				{531, 128}, -- fort jakova
				{472, 167} -- volksgrad
			};
			
			for i = 1, #slaanesh_settlements do
				cm:create_force(
					"wh3_main_sla_exquisite_pain",
					"wh3_main_sla_cav_heartseekers_of_slaanesh_0,wh3_main_sla_cav_heartseekers_of_slaanesh_0,wh3_main_sla_cav_hellstriders_0,wh3_main_sla_cav_hellstriders_1,wh3_main_sla_cav_hellstriders_1,wh3_main_sla_cav_seekers_of_slaanesh_0,wh3_main_sla_inf_daemonette_0,wh3_main_sla_inf_daemonette_1,wh3_main_sla_inf_daemonette_1,wh3_main_sla_inf_marauders_2,wh3_main_sla_inf_marauders_2,wh3_main_sla_mon_fiends_of_slaanesh_0,wh3_main_sla_mon_keeper_of_secrets_0,wh3_main_sla_mon_soul_grinder_0,wh3_main_sla_mon_spawn_of_slaanesh_0,wh3_main_sla_veh_exalted_seeker_chariot_0,wh3_main_sla_veh_hellflayer_0,wh3_main_sla_veh_hellflayer_0,wh3_main_sla_veh_seeker_chariot_0",
					"wh3_main_chaos_region_kislev",
					slaanesh_settlements[i][1],
					slaanesh_settlements[i][2],
					false,
					function(cqi)
						cm:cai_disable_movement_for_character(cm:char_lookup_str(cqi));
						cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force", cqi, 0);
					end
				);
			end;
			
			local slaanesh_free_armies = {
				{498, 114}, --1
				{510, 118}, --2
				{523, 120}, --3
				{534, 140}, --4
				{536, 143}, --5
				{488, 155}, --6
				{468, 160}, --7
				{501, 126}, --8
			};
			
			local locked_armies_slaanesh = {};
			local temp_cqi = 0;
			
			for i = 1, tol_difficulty + 3 do
				cm:create_force(
					"wh3_main_sla_exquisite_pain",
					"wh3_main_sla_cav_heartseekers_of_slaanesh_0,wh3_main_sla_cav_heartseekers_of_slaanesh_0,wh3_main_sla_cav_hellstriders_0,wh3_main_sla_cav_hellstriders_1,wh3_main_sla_cav_hellstriders_1,wh3_main_sla_cav_seekers_of_slaanesh_0,wh3_main_sla_inf_daemonette_0,wh3_main_sla_inf_daemonette_1,wh3_main_sla_inf_daemonette_1,wh3_main_sla_inf_marauders_2,wh3_main_sla_inf_marauders_2,wh3_main_sla_mon_fiends_of_slaanesh_0,wh3_main_sla_mon_keeper_of_secrets_0,wh3_main_sla_mon_soul_grinder_0,wh3_main_sla_mon_spawn_of_slaanesh_0,wh3_main_sla_veh_exalted_seeker_chariot_0,wh3_main_sla_veh_hellflayer_0,wh3_main_sla_veh_hellflayer_0,wh3_main_sla_veh_seeker_chariot_0",
					"wh3_main_chaos_region_kislev",
					slaanesh_free_armies[i][1],
					slaanesh_free_armies[i][2],
					false,
					function(cqi)
						temp_cqi = cqi;
						cm:cai_disable_movement_for_character(cm:char_lookup_str(cqi));
						cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force", cqi, 0);
					end
				);
				locked_armies_slaanesh[i]=temp_cqi;
			end;
			cm:set_saved_value("locked_armies_slaanesh", locked_armies_slaanesh);
			
			
			-- Tzeentch
			cm:treasury_mod("wh3_main_tze_flaming_scribes", 10000);
			
			cm:apply_effect_bundle("wh3_main_background_income_mod_1000", "wh3_main_tze_flaming_scribes", 0)
			
			region_change_faction_to_faction("wh3_main_tze_flaming_scribes", "wh3_main_nur_poxmakers_of_nurgle");
			
			region_change(
				"wh3_main_chaos_region_novchozy",
				"wh3_main_tze_flaming_scribes",
				{
					"wh3_main_tze_settlement_minor_3",
					"wh3_main_tze_horror_barracks_2",
					"wh3_main_tze_walls_minor_2"
				}
			);
			
			region_change(
				"wh3_main_chaos_region_plesk",
				"wh3_main_tze_flaming_scribes",
				{
					"wh3_main_tze_settlement_minor_3",
					"wh3_main_tze_monster_barracks_2",
					"wh3_main_tze_walls_minor_2"
				}
			);
			
			region_change(
				"wh3_main_chaos_region_sepukzy",
				"wh3_main_tze_flaming_scribes",
				{
					"wh3_main_tze_settlement_minor_3",
					"wh3_main_tze_walls_minor_2"
				}
			);
			
			region_change(
				"wh3_main_chaos_region_yetchitch",
				"wh3_main_tze_flaming_scribes",
				{
					"wh3_main_tze_settlement_minor_3",
					"wh3_main_tze_walls_minor_2"
				}
			);
			
			teleport_character_faction_leader("wh3_main_tze_flaming_scribes", 531, 207);
			
			cm:force_declare_war("wh3_main_tze_flaming_scribes", "wh3_main_ksl_the_great_orthodoxy", false, false);
			cm:force_declare_war("wh3_main_tze_flaming_scribes", "wh3_main_ksl_ursun_revivalists", false, false);
			cm:force_declare_war("wh3_main_tze_flaming_scribes", "wh3_main_ksl_the_ice_court", false, false);
			
			local tze_inv_1 = invasion_manager:new_invasion(
				"tze_inv_1",
				"wh3_main_tze_flaming_scribes",
				"wh3_main_tze_inf_blue_horrors_0,wh3_main_tze_mon_screamers_0,wh3_main_tze_mon_screamers_0,wh3_main_tze_inf_chaos_furies_0,wh3_main_tze_inf_blue_horrors_0,wh3_main_tze_inf_blue_horrors_0",
				{450, 199}
			);
			
			tze_inv_1:set_target("PATROL", {{x = 450, y = 199}, {x = 450, y = 199}});
			tze_inv_1:add_aggro_radius(100);
			tze_inv_1:apply_effect("wh_main_bundle_military_upkeep_free_force", -1);
			tze_inv_1:start_invasion();
			
			local tze_inv_2 = invasion_manager:new_invasion(
				"tze_inv_2",
				"wh3_main_tze_flaming_scribes",
				"wh3_main_tze_inf_blue_horrors_0,wh3_main_tze_mon_screamers_0,wh3_main_tze_mon_screamers_0,wh3_main_tze_inf_chaos_furies_0,wh3_main_tze_inf_blue_horrors_0,wh3_main_tze_inf_blue_horrors_0",
				{500, 184}
			);
			
			tze_inv_2:set_target("PATROL", {{x = 500, y = 184}, {x = 500, y = 184}});
			tze_inv_2:add_aggro_radius(100);
			tze_inv_2:apply_effect("wh_main_bundle_military_upkeep_free_force", -1);
			tze_inv_2:start_invasion();
			
			local tzeentch_settlements = {
				{456, 209}, -- gerslev
				{500, 211}, -- sepukzy
				{535, 211}, -- novchozy
				{525, 178} -- plesk
			};
			
			for i = 1, #tzeentch_settlements do
				cm:create_force(
					"wh3_main_tze_flaming_scribes",
					"wh3_main_tze_cav_chaos_knights_0,wh3_main_tze_cav_doom_knights_0,wh3_main_tze_cav_doom_knights_0,wh3_main_tze_inf_chaos_furies_0,wh3_main_tze_inf_forsaken_0,wh3_main_tze_inf_forsaken_0,wh3_main_tze_inf_pink_horrors_0,wh3_main_tze_inf_pink_horrors_0,wh3_main_tze_inf_pink_horrors_1,wh3_main_tze_inf_pink_horrors_1,wh3_main_tze_inf_pink_horrors_1,wh3_main_tze_mon_exalted_flamer_0,wh3_main_tze_mon_flamers_0,wh3_main_tze_mon_flamers_0,wh3_main_tze_mon_lord_of_change_0,wh3_main_tze_mon_screamers_0,wh3_main_tze_mon_soul_grinder_0,wh3_main_tze_mon_spawn_of_tzeentch_0,wh3_main_tze_veh_burning_chariot_0",
					"wh3_main_chaos_region_kislev",
					tzeentch_settlements[i][1],
					tzeentch_settlements[i][2],
					false,
					function(cqi)
						cm:cai_disable_movement_for_character(cm:char_lookup_str(cqi));
						cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force", cqi, 0);
					end
				);
			end;
			
			local tzeentch_free_armies = {
				{523, 215}, --1
				{523, 218}, --2
				{525, 214}, --3
				{514, 207}, --4
				{512, 211}, --5
				{467, 199}, --6
				{515, 191}, --7
				{538, 160}, --8
			};
			
			local locked_armies_tzeentch = {};
			temp_cqi = 0;
			
			for i = 1, tol_difficulty+3 do
				cm:create_force(
					"wh3_main_tze_flaming_scribes",
					"wh3_main_tze_cav_chaos_knights_0,wh3_main_tze_cav_doom_knights_0,wh3_main_tze_cav_doom_knights_0,wh3_main_tze_inf_chaos_furies_0,wh3_main_tze_inf_forsaken_0,wh3_main_tze_inf_forsaken_0,wh3_main_tze_inf_pink_horrors_0,wh3_main_tze_inf_pink_horrors_0,wh3_main_tze_inf_pink_horrors_1,wh3_main_tze_inf_pink_horrors_1,wh3_main_tze_inf_pink_horrors_1,wh3_main_tze_mon_exalted_flamer_0,wh3_main_tze_mon_flamers_0,wh3_main_tze_mon_flamers_0,wh3_main_tze_mon_lord_of_change_0,wh3_main_tze_mon_screamers_0,wh3_main_tze_mon_soul_grinder_0,wh3_main_tze_mon_spawn_of_tzeentch_0,wh3_main_tze_veh_burning_chariot_0",
					"wh3_main_chaos_region_kislev",
					tzeentch_free_armies[i][1],
					tzeentch_free_armies[i][2],
					false,
					function(cqi)
						temp_cqi = cqi
						cm:cai_disable_movement_for_character(cm:char_lookup_str(cqi));
						cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force", cqi, 0);
					end
				);
				locked_armies_tzeentch[i] = temp_cqi;
			end;
			
			cm:set_saved_value("locked_armies_tzeentch", locked_armies_tzeentch);
			
			-- misc
			cm:add_building_to_settlement("wh3_main_chaos_region_hell_pit", "wh2_main_special_settlement_hellpit_5");
			cm:add_building_to_settlement("wh3_main_chaos_region_hell_pit", "wh2_main_skv_defence_major_3");
			cm:add_building_to_settlement("wh3_main_chaos_region_hell_pit", "wh2_main_skv_resource_animals_3");
			cm:add_building_to_settlement("wh3_main_chaos_region_hell_pit", "wh2_main_skv_clanrats_3");
			cm:add_building_to_settlement("wh3_main_chaos_region_hell_pit", "wh2_main_skv_assassins_3");
			cm:add_building_to_settlement("wh3_main_chaos_region_hell_pit", "wh2_main_skv_weaponteams_2");
			cm:add_building_to_settlement("wh3_main_chaos_region_hell_pit", "wh2_main_skv_engineers_3");
			cm:add_building_to_settlement("wh3_main_chaos_region_hell_pit", "wh2_main_skv_plagues_3");
			cm:add_building_to_settlement("wh3_main_chaos_region_hell_pit", "wh2_main_skv_monsters_4");
			
			
			kill_faction("wh3_dlc20_nor_dolgan");
			kill_faction("wh3_dlc24_tze_the_deceivers");
			kill_faction("wh3_main_ksl_druzhina_enclave");
			kill_faction("wh3_main_ksl_ropsmenn_clan");
			kill_faction("wh3_main_ksl_ungol_kindred");
			kill_faction("wh3_main_ksl_brotherhood_of_the_bear");
			
			cm:force_diplomacy("faction:wh3_main_ksl_the_ice_court", "faction:wh3_main_ksl_the_great_orthodoxy", "break alliance", false, false, true);
			cm:force_diplomacy("faction:wh3_main_ksl_the_ice_court", "faction:wh3_main_ksl_ursun_revivalists", "break alliance", false, false, true);
			cm:force_diplomacy("faction:wh3_main_ksl_ursun_revivalists", "faction:wh3_main_ksl_the_great_orthodoxy", "break alliance", false, false, true);

			cm:force_diplomacy("faction:wh3_main_ksl_ursun_revivalists", "faction:wh3_main_ksl_the_great_orthodoxy", "war", false, false, true);
			cm:force_diplomacy("faction:wh3_main_ksl_the_ice_court", "faction:wh3_main_ksl_ursun_revivalists", "war", false, false, true);
			cm:force_diplomacy("faction:wh3_main_ksl_the_ice_court", "faction:wh3_main_ksl_the_great_orthodoxy", "war", false, false, true);
			
			cm:callback(
				function()
					cm:position_camera_at_primary_military_force(cm:get_local_faction_name(true));
					cm:reset_shroud();
					cm:force_alliance("wh3_main_ksl_the_ice_court", "wh3_main_ksl_the_great_orthodoxy", true);
					cm:force_alliance("wh3_main_ksl_the_ice_court", "wh3_main_ksl_ursun_revivalists", true);
					cm:force_alliance("wh3_main_ksl_the_great_orthodoxy", "wh3_main_ksl_ursun_revivalists", true);
					
					cm:pooled_resource_factor_transaction(cm:get_province("wh3_main_chaos_province_eastern_oblast"):pooled_resource_manager():resource("wh3_main_corruption_chaos"), "local_populace", -100);
					add_starting_corruption();
				end,
				0.5
			);
			
			local human_factions = cm:get_human_factions();
			local mission_duration = 16;
			
			if #human_factions < 3 then
				mission_duration = 26;
			end;
			
			for i = 1, #human_factions do
				cm:disable_event_feed_events(true, "", "", "faction_event_mission_issued")
				
				cm:trigger_custom_mission_from_string(
					human_factions[i],
					[[mission
						{
							victory_type wh3_main_victory_type_mp_tol;
							key wh3_main_mp_victory_tol_kislev;
							issuer CLAN_ELDERS;
							primary_objectives_and_payload
							{
								objective
								{
									type CONTROL_N_PROVINCES_INCLUDING;
									total 4;
									province wh3_main_chaos_province_dukhlys_forest;
									province wh3_main_chaos_province_eastern_oblast;
									province wh3_main_chaos_province_northern_oblast;
									province wh3_main_chaos_province_troll_country;
								}
								
								objective
								{
									type SCRIPTED;
									script_key tol;
								}
								
								//
								
								payload
								{
									text_display dummy_wh3_main_survival_forge_of_souls;
									game_victory;
								}
							}
						}]]
				);
				
				cm:disable_event_feed_events(false, "", "", "faction_event_mission_issued")
				
				cm:complete_scripted_mission_objective(human_factions[i], "wh3_main_mp_victory_tol_kislev", "tol", true);
				
				local mm = mission_manager:new(human_factions[i], "wh3_main_mp_tol_kislev_intro");
				mm:add_new_objective("CONTROL_N_REGIONS_INCLUDING");
				mm:add_condition("total 4");
				mm:add_condition("region wh3_main_chaos_region_bolgasgrad");
				mm:add_condition("region wh3_main_chaos_region_dushyka");
				mm:add_condition("region wh3_main_chaos_region_fort_ostrosk");
				mm:add_condition("region wh3_main_chaos_region_zoishenk");
				mm:set_turn_limit(mission_duration);
				mm:add_payload("money 10000");
				mm:add_payload("text_display dummy_wh3_mission_fail");
				mm:trigger();
				
				cm:apply_effect_bundle("wh3_main_time_of_legends_kislev_buffs", human_factions[i], 0);
			end;
			
			local playable_factions = {
				"wh3_main_ksl_the_ice_court",
				"wh3_main_ksl_the_great_orthodoxy",
				"wh3_main_ksl_ursun_revivalists"
			};
			
			for i = 1, #playable_factions do
				cm:add_agent_experience(cm:char_lookup_str(cm:get_faction(playable_factions[i]):faction_leader():command_queue_index()), starting_leader_level, true);
			end;
			
			-- skip AI factions
			local factions = {
				"wh3_main_ksl_the_ice_court",
				"wh3_main_ksl_the_great_orthodoxy",
				"wh3_main_ksl_ursun_revivalists",
				"wh3_main_kho_crimson_skull",
				"wh3_main_nur_septic_claw",
				"wh3_main_sla_exquisite_pain",
				"wh3_main_tze_flaming_scribes",
			};
			
			local faction_list = cm:model():world():faction_list();
			for i = 0, faction_list:num_items() - 1 do
				local current_faction = faction_list:item_at(i);
				
				if not current_faction:is_human() and not current_faction:is_dead() then
					local current_faction_name = current_faction:name();
					local current_faction_factions_met = current_faction:factions_met();
					local skip = true;
					
					for j = 1, #factions do
						if current_faction_name == factions[j] then
							skip = false;
							break;
						end;
					end;
					
					for j = 0, current_faction_factions_met:num_items() - 1 do
						if current_faction_factions_met:item_at(j):is_human() then
							skip = false
							break;
						end;
					end;
					
					if skip then
						cm:set_skip_faction_turn(current_faction, true);
					end;
				end;
			end;
			
			
			
			CampaignUI.ClearSelection();
		end;
	end
);

cm:add_first_tick_callback(
	function()
		if cm:tol_campaign_key() == "wh3_main_tol_something_rotten_in_kislev" then
			
			--Disable the outpost reminder
			common.call_context_command("CcoCampaignPendingActionNotificationQueue", "", "ToggleSupressNotificationType('ALLIED_BUILDINGS_CONSTRUCTION_AVAILABLE', true)")
		
			core:add_listener(
				"release_sla_tze",
				"WorldStartRound",
				function(context)
					if context:world():model():turn_number() >= 16 then
						return true
					end
					--[[
					local exquisite_pain_faction = cm:get_faction("wh3_main_sla_exquisite_pain")
					local exquisite_pain_regions = exquisite_pain_faction:region_list()
					if exquisite_pain_regions:is_null_interface() == false then
						return exquisite_pain_regions:num_items() >= 4
					end
					
					local flaming_scribes_faction = cm:get_faction("wh3_main_tze_flaming_scribes")
					local flaming_scribes_regions = flaming_scribes_faction:region_list()
					if flaming_scribes_regions:is_null_interface() == false then
						return flaming_scribes_regions:num_items() >= 4
					end
					local crimson_skull_faction = cm:get_faction("wh3_main_kho_crimson_skull")
					local crimson_skull_faction_regions = crimson_skull_faction:region_list()
					if crimson_skull_faction_regions:is_null_interface() == false then
						return crimson_skull_faction_regions:num_items() >= 4
					end
					]]
				end,
				function()
					local locked_armies_tzeentch = cm:get_saved_value("locked_armies_tzeentch")
					local locked_armies_slaanesh = cm:get_saved_value("locked_armies_slaanesh")
					
					out.design("Unlock armies")
					
					for i = 1, #locked_armies_tzeentch do
						out.design("Unlock Tze army")
						cm:cai_enable_movement_for_character(cm:char_lookup_str(locked_armies_tzeentch[i]))
					end;
					for i = 1, #locked_armies_slaanesh do
						out.design("Unlock Sla army")
						cm:cai_enable_movement_for_character(cm:char_lookup_str(locked_armies_slaanesh[i]))
					end;					
				end,
				false
			);
			
			core:add_listener(
				"release_kho",
				"MissionSucceeded",
				function(context)
					return context:mission():mission_record_key() == "wh3_main_mp_tol_kislev_intro";
				end,
				function()
					local locked_armies_khorne   = cm:get_saved_value("locked_armies_khorne")
					
					out.design("Unlock armies")
										
					for i = 1, #locked_armies_khorne do
						out.design("Unlock Kho army")
						cm:cai_enable_movement_for_character(cm:char_lookup_str(locked_armies_khorne[i]))
					end;
				end,
				true
			);
			
			core:add_listener(
				"reset_ai_turn",
				"FactionEncountersOtherFaction",
				function(context)
					return context:faction():is_human();
				end,
				function(context)
					cm:set_skip_faction_turn(context:other_faction(), false);
				end,
				true
			);

			core:add_listener(
				"fail_tol_campaign",
				"MissionFailed",
				function(context)
					return context:mission():mission_record_key() == "wh3_main_mp_tol_kislev_intro";
				end,
				function()
					local human_factions = cm:get_human_factions();
					
					for i = 1, #human_factions do
						cm:complete_scripted_mission_objective(human_factions[i], "wh3_main_mp_victory_tol_kislev", "tol", false);
					end;
				end,
				true
			);
			
			core:add_listener(
				"trigger_nurgle_boss",
				"CharacterPerformsSettlementOccupationDecision",
				function(context) 
					if context:previous_owner() == "wh3_main_nur_septic_claw" then
						local septic_claw_faction = cm:get_faction("wh3_main_nur_septic_claw")
						local regions = septic_claw_faction:region_list()
						
						if regions:is_empty() then
							return false
						elseif regions:num_items() == 1 then
							return true
						else
							return false
						end
					end
				end,
				function()
					out.design("Trigger Nurgle Boss")
					local septic_claw_faction = cm:get_faction("wh3_main_nur_septic_claw")
					local regions = septic_claw_faction:region_list()
					
					if regions:is_empty() then
						return false
					elseif regions:num_items() == 1 then
						local region = regions:item_at(0);
						spawn_boss(region,"wh3_main_nur_septic_claw")
					end
				end,
				false
			);
			
			core:add_listener(
				"trigger_tze_boss",
				"CharacterPerformsSettlementOccupationDecision",
				function(context) 
					if context:previous_owner() == "wh3_main_tze_flaming_scribes" then
						local septic_claw_faction = cm:get_faction("wh3_main_tze_flaming_scribes")
						local regions = septic_claw_faction:region_list()
						
						if regions:is_empty() then
							return false
						elseif regions:num_items() == 1 then
							return true
						else
							return false
						end
					end
				end,
				function()
					out.design("Trigger Nurgle Boss")
					local septic_claw_faction = cm:get_faction("wh3_main_tze_flaming_scribes")
					local regions = septic_claw_faction:region_list()
					
					if regions:is_empty() then
						return false
					elseif regions:num_items() == 1 then
						local region = regions:item_at(0);
						spawn_boss(region,"wh3_main_tze_flaming_scribes")
					end
				end,
				false
			);

			core:add_listener(
				"trigger_sla_boss",
				"CharacterPerformsSettlementOccupationDecision",
				function(context) 
					if context:previous_owner() == "wh3_main_sla_exquisite_pain" then
						local septic_claw_faction = cm:get_faction("wh3_main_sla_exquisite_pain")
						local regions = septic_claw_faction:region_list()
						
						if regions:is_empty() then
							return false
						elseif regions:num_items() == 1 then
							return true
						else
							return false
						end
					end
				end,
				function()
					out.design("Trigger Nurgle Boss")
					local septic_claw_faction = cm:get_faction("wh3_main_sla_exquisite_pain")
					local regions = septic_claw_faction:region_list()
					
					if regions:is_empty() then
						return false
					elseif regions:num_items() == 1 then
						local region = regions:item_at(0);
						spawn_boss(region,"wh3_main_sla_exquisite_pain")
					end
				end,
				false
			);
			
		end;
	end
);

function spawn_boss(region, enemy_faction_key)
	
	local SRiK_force_mapping = {
		["wh3_main_nur_septic_claw"]="nurgle_late",
		["wh3_main_tze_flaming_scribes"]="tzeentch_late",
		["wh3_main_sla_exquisite_pain"]="slaanesh_late",
		["wh3_main_kho_crimson_skull"]="khorne_late"
		};
	
	local septic_claw_faction = cm:get_faction(enemy_faction_key)
	local tol_difficulty = cm:get_difficulty()
	
	if septic_claw_faction:is_null_interface() then
		return false
	end
	
	local x,y;
	for i = 1, tol_difficulty do
		x,y = cm:find_valid_spawn_location_for_character_from_settlement(
			enemy_faction_key,
			region:name(),
			false,
			true,
			i
		);
		
		cm:create_force(
			enemy_faction_key,		
			random_army_manager:generate_force(SRiK_force_mapping[enemy_faction_key], 20, false),
			"wh3_main_chaos_region_kislev",
			x,
			y,
			false,
			function(cqi)
				cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force", cqi, 0);
			end
		);
	end;
end

random_army_manager:new_force("nurgle_early");
random_army_manager:add_mandatory_unit("nurgle_early", "wh3_main_nur_inf_plaguebearers_0", 4);
random_army_manager:add_mandatory_unit("nurgle_early", "wh3_main_nur_inf_forsaken_0", 4);
random_army_manager:add_mandatory_unit("nurgle_early", "wh3_main_nur_inf_nurglings_0", 2);
random_army_manager:add_mandatory_unit("nurgle_early", "wh3_main_nur_mon_spawn_of_nurgle_0", 2);
random_army_manager:add_mandatory_unit("nurgle_early", "wh3_main_nur_mon_rot_flies_0", 1);
random_army_manager:add_mandatory_unit("nurgle_early", "wh3_main_nur_mon_soul_grinder_0", 1);
random_army_manager:add_unit("nurgle_early", "wh3_main_nur_mon_beast_of_nurgle_0", 1);
random_army_manager:add_unit("nurgle_early", "wh3_main_nur_mon_plague_toads_0", 1);
random_army_manager:add_unit("nurgle_early", "wh3_main_nur_cav_plague_drones_0", 1);

random_army_manager:new_force("nurgle_late");
random_army_manager:add_mandatory_unit("nurgle_late", "wh3_main_nur_inf_plaguebearers_1", 4);
random_army_manager:add_mandatory_unit("nurgle_late", "wh3_main_nur_cav_pox_riders_of_nurgle_0", 4);
random_army_manager:add_mandatory_unit("nurgle_late", "wh3_main_nur_inf_forsaken_0", 2);
random_army_manager:add_mandatory_unit("nurgle_late", "wh3_main_nur_cav_plague_drones_1", 2);
random_army_manager:add_mandatory_unit("nurgle_late", "wh3_main_nur_mon_great_unclean_one_0", 1);
random_army_manager:add_mandatory_unit("nurgle_late", "wh3_main_nur_mon_soul_grinder_0", 1);
random_army_manager:add_unit("nurgle_late", "wh3_main_nur_mon_beast_of_nurgle_0", 2);
random_army_manager:add_unit("nurgle_late", "wh3_main_nur_inf_plaguebearers_0", 2);
random_army_manager:add_unit("nurgle_late", "wh3_main_nur_mon_spawn_of_nurgle_0", 1);
random_army_manager:add_unit("nurgle_late", "wh3_main_nur_cav_plague_drones_0", 1);

random_army_manager:new_force("tzeentch_late");
random_army_manager:add_mandatory_unit("tzeentch_late", "wh3_main_tze_cav_chaos_knights_0", 1);
random_army_manager:add_mandatory_unit("tzeentch_late", "wh3_main_tze_cav_doom_knights_0", 2);
random_army_manager:add_mandatory_unit("tzeentch_late", "wh3_main_tze_inf_chaos_furies_0", 1);
random_army_manager:add_mandatory_unit("tzeentch_late", "wh3_main_tze_inf_forsaken_0", 2);
random_army_manager:add_mandatory_unit("tzeentch_late", "wh3_main_tze_inf_pink_horrors_0", 2);
random_army_manager:add_mandatory_unit("tzeentch_late", "wh3_main_tze_inf_pink_horrors_1", 3);
random_army_manager:add_mandatory_unit("tzeentch_late", "wh3_main_tze_mon_exalted_flamer_0", 1);
random_army_manager:add_mandatory_unit("tzeentch_late", "wh3_main_tze_mon_flamers_0", 2);
random_army_manager:add_mandatory_unit("tzeentch_late", "wh3_main_tze_mon_lord_of_change_0", 1);
random_army_manager:add_mandatory_unit("tzeentch_late", "wh3_main_tze_mon_screamers_0", 1);
random_army_manager:add_mandatory_unit("tzeentch_late", "wh3_main_tze_mon_soul_grinder_0", 1);
random_army_manager:add_mandatory_unit("tzeentch_late", "wh3_main_tze_mon_spawn_of_tzeentch_0", 1);
random_army_manager:add_mandatory_unit("tzeentch_late", "wh3_main_tze_veh_burning_chariot_0", 1);

random_army_manager:new_force("slaanesh_late");
random_army_manager:add_mandatory_unit("slaanesh_late", "wh3_main_sla_cav_heartseekers_of_slaanesh_0", 2);
random_army_manager:add_mandatory_unit("slaanesh_late", "wh3_main_sla_cav_hellstriders_0", 1);
random_army_manager:add_mandatory_unit("slaanesh_late", "wh3_main_sla_cav_hellstriders_1", 2);
random_army_manager:add_mandatory_unit("slaanesh_late", "wh3_main_sla_cav_seekers_of_slaanesh_0", 1);
random_army_manager:add_mandatory_unit("slaanesh_late", "wh3_main_sla_inf_daemonette_0", 1);
random_army_manager:add_mandatory_unit("slaanesh_late", "wh3_main_sla_inf_daemonette_1", 2);
random_army_manager:add_mandatory_unit("slaanesh_late", "wh3_main_sla_inf_marauders_2", 2);
random_army_manager:add_mandatory_unit("slaanesh_late", "wh3_main_sla_mon_fiends_of_slaanesh_0", 1);
random_army_manager:add_mandatory_unit("slaanesh_late", "wh3_main_sla_mon_keeper_of_secrets_0", 1);
random_army_manager:add_mandatory_unit("slaanesh_late", "wh3_main_sla_mon_soul_grinder_0", 1);
random_army_manager:add_mandatory_unit("slaanesh_late", "wh3_main_sla_mon_spawn_of_slaanesh_0", 1);
random_army_manager:add_mandatory_unit("slaanesh_late", "wh3_main_sla_veh_exalted_seeker_chariot_0", 1);
random_army_manager:add_mandatory_unit("slaanesh_late", "wh3_main_sla_veh_hellflayer_0", 2);
random_army_manager:add_mandatory_unit("slaanesh_late", "wh3_main_sla_veh_seeker_chariot_0", 1);
					

