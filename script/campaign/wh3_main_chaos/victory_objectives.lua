victory_objectives = {

	---VICTORY TEMPLATES
	victory_type_templates = {
		roc_mp = {
			campaign_types = {MP_NORMAL = true}, --- can be "any" or a hashset
			factions = "any", --- can be "any" or a hashset
			mission_key = "wh3_main_mp_victory",
			victory_type = "wh3_main_victory_type_mp",
			objectives = {
				{type = "SCRIPTED", conditions = {"script_key realms_multiplayer","override_text mission_text_text_mis_activity_complete_realms_multiplayer"}},
				{type = "SCRIPTED", conditions = {"script_key forge_of_souls_battle","override_text mission_text_text_mis_activity_win_forge_of_souls_final_battle"}}
			}
		},

		roc_sp = {
			campaign_types = {SP_NORMAL = true},
			factions = "any",
			mission_key = "wh_main_long_victory",
			victory_type = "wh3_main_victory_type_chaos_forge_of_souls",
			objectives = {
				{type = "SCRIPTED", conditions = {"script_key realm_khorne", "override_text mission_text_text_mis_activity_complete_realm_khorne"}},
				{type = "SCRIPTED", conditions = {"script_key realm_nurgle", "override_text mission_text_text_mis_activity_complete_realm_nurgle"}},
				{type = "SCRIPTED", conditions = {"script_key realm_tzeentch",	"override_text mission_text_text_mis_activity_complete_realm_tzeentch"}},
				{type = "SCRIPTED", conditions = {"script_key realm_slaanesh",	"override_text mission_text_text_mis_activity_complete_realm_slaanesh"}},
				{type = "SCRIPTED", conditions = {"script_key forge_of_souls_battle",	"override_text mission_text_text_mis_activity_win_forge_of_souls_final_battle"}},
			}
		},

		domination_roc = {
			campaign_types = {SP_NORMAL = true},
			factions = "any",
			mission_key = "wh3_main_chaos_domination_victory",
			victory_type = "wh3_main_victory_type_chaos_domination",
			objectives = {
				{type = "DESTROY_FACTION"}, -- conditions generated automatically
				{type = "CONTROL_N_PROVINCES_INCLUDING"}, -- conditions generated automatically
				{type = "SCRIPTED", conditions = {"script_key domination"}}
			}
		},

		domination_no_roc = {
			campaign_types = {SP_NORMAL_NO_ROC = true},
			factions = "any",
			mission_key = "wh3_main_chaos_domination_victory",
			victory_type = "wh3_main_victory_type_chaos_domination",
			objectives = {
				{type = "DESTROY_FACTION"}, -- conditions generated automatically
				{type = "CONTROL_N_PROVINCES_INCLUDING"}, -- conditions generated automatically
			}
		},

		domination_mp = {
			campaign_types = {MP_NORMAL_NO_ROC = true},
			factions = "any",
			mission_key = "wh3_main_chaos_domination_victory",
			victory_type = "wh3_main_victory_type_chaos_domination",
			objectives = {
				{type = "ALL_PLAYERS_RAZE_OR_OWN_X_SETTLEMENTS"}, -- conditions generated automatically
			}
		},

		zanbaijin = {
			campaign_types = {SP_NORMAL_NO_ROC = true},
			factions = {wh3_dlc20_chs_valkia = true, wh3_dlc20_chs_festus = true, wh3_dlc20_chs_vilitch = true, wh3_dlc20_chs_azazel = true},
			mission_key = "wh_main_long_victory",
			victory_type = "wh_dlc03_victory_type_major",
			objectives = {
				{type = "SCRIPTED", conditions = {"script_key souls_requirement", "override_text mission_text_text_mis_activity_complete_souls_requirement"}},
				{type = "SCRIPTED", conditions = {"script_key rifts_requirement", "override_text mission_text_text_mis_activity_complete_rifts_requirement"}},
				{type = "SCRIPTED", conditions = {"script_key champions_final_battle", "override_text mission_text_text_mis_activity_complete_champions_final_battle"}},
			}
		},

		hellshard_drill = {
			campaign_types = {SP_NORMAL_NO_ROC = true},
			factions = {wh3_dlc23_chd_astragoth = true, wh3_dlc23_chd_legion_of_azgorh = true, wh3_dlc23_chd_zhatan = true},
			mission_key = "wh_main_long_victory",
			victory_type = "wh_dlc03_victory_type_major",
			objectives = {
				{type = "SCRIPTED", conditions = {"script_key hellshard_structure_requirement", "override_text mission_text_text_mis_activity_dlc23_complete_hellshard_structure_requirement"}},
				{type = "SCRIPTED", conditions = {"script_key hellshard_bound_relics_requirement", "override_text mission_text_text_mis_activity_dlc23_complete_hellshard_bound_relics_requirement"}},
				{type = "SCRIPTED", conditions = {"script_key chaos_dwarf_final_battle", "override_text mission_text_text_mis_activity_dlc23_complete_chaos_dwarf_final_battle"}},
			}
		},

		the_changeling_schemes = {
			campaign_types = {SP_NORMAL_NO_ROC = true},
			factions = {wh3_dlc24_tze_the_deceivers = true},
			mission_key = "wh_main_long_victory",
			victory_type = "wh_dlc03_victory_type_major",
			objectives = {
				{type = "SCRIPTED", conditions = {"script_key schemes_grand", "override_text mission_text_text_wh3_dlc24_objective_the_changeling_long_grand_schemes_roc"}},
				{type = "SCRIPTED", conditions = {"script_key schemes", "override_text mission_text_text_wh3_dlc24_objective_the_changeling_long"}},
			}
		},

		jade_dragon_astromantic_relays = {
			campaign_types = {SP_NORMAL_NO_ROC = true},
			factions = {wh3_dlc24_cth_the_celestial_court = true},
			mission_key = "wh_main_long_victory",
			victory_type = "wh_dlc03_victory_type_major",
			objectives = {
				{type = "SCRIPTED", conditions = {"script_key empower_compass_north", "override_text mission_text_text_wh3_dlc24_victory_complete_astromantic_relays_north_roc"}},
				{type = "SCRIPTED", conditions = {"script_key empower_compass_east", "override_text mission_text_text_wh3_dlc24_victory_complete_astromantic_relays_east_roc"}},
				{type = "SCRIPTED", conditions = {"script_key empower_compass_south", "override_text mission_text_text_wh3_dlc24_victory_complete_astromantic_relays_south_roc"}},
				{type = "SCRIPTED", conditions = {"script_key empower_compass_west", "override_text mission_text_text_wh3_dlc24_victory_complete_astromantic_relays_west_roc"}},
				{type = "SCRIPTED", conditions = {"script_key final_battle", "override_text mission_text_text_wh3_dlc24_victory_yuan_bo_final_battle"}}
			}
		},

		mother_ostankya_hexes = {
			campaign_types = {SP_NORMAL_NO_ROC = true},
			factions = {wh3_dlc24_ksl_daughters_of_the_forest = true},
			mission_key = "wh_main_long_victory",
			victory_type = "wh_dlc03_victory_type_major",
			objectives = {
				{type = "SCRIPTED", conditions = {"script_key hexes_victory_5",	"override_text mission_text_text_mis_activity_ostankya_roc_collect_hex_fifth"}},
				{type = "SCRIPTED", conditions = {"script_key hexes_victory_1", "override_text mission_text_text_mis_activity_ostankya_roc_collect_hex_first"}},
				{type = "SCRIPTED", conditions = {"script_key hexes_victory_2", "override_text mission_text_text_mis_activity_ostankya_roc_collect_hex_second"}},
				{type = "SCRIPTED", conditions = {"script_key hexes_victory_3", "override_text mission_text_text_mis_activity_ostankya_roc_collect_hex_third"}},
				{type = "SCRIPTED", conditions = {"script_key hexes_victory_4",	"override_text mission_text_text_mis_activity_ostankya_roc_collect_hex_fourth"}},
				{type = "SCRIPTED", conditions = {"script_key hexes_long_all", "override_text mission_text_text_mis_activity_ostankya_collect_all_hexes"}},
			}
		}
	},

	----DOMINATION VARIABLES----
	-- Domination victory conditions can be auto-generated by using the objective types "DESTROY_FACTION" or "CONTROL_X_PROVINCES_INCLUDING" without any conditions
	-- The script will attempt to populate these conditions using the defaults or the factional overrides specified here
	domination_faction_targets_default = {
		"wh3_main_kho_exiles_of_khorne",
		"wh3_main_ksl_the_great_orthodoxy",
		"wh3_main_ksl_the_ice_court",
		"wh3_main_ksl_ursun_revivalists",
		"wh3_main_nur_poxmakers_of_nurgle",
		"wh3_main_ogr_disciples_of_the_maw",
		"wh3_main_ogr_goldtooth",
		"wh3_main_sla_seducers_of_slaanesh",
		"wh3_main_tze_oracles_of_tzeentch",
		"wh3_main_dae_daemon_prince",
		"wh3_main_cth_the_northern_provinces",
		"wh3_main_cth_the_western_provinces"
	}, 
	domination_faction_targets_overrides = {
		wh3_dlc23_chd_astragoth = {
			"wh3_main_ksl_the_great_orthodoxy",
			"wh3_main_ksl_the_ice_court",
			"wh3_main_ogr_goldtooth",
			"wh3_main_cth_the_northern_provinces",
			"wh3_main_cth_the_western_provinces",
		},
		wh3_dlc23_chd_legion_of_azgorh = {
			"wh3_main_ksl_the_great_orthodoxy",
			"wh3_main_ksl_the_ice_court",
			"wh3_main_ogr_goldtooth",
			"wh3_main_cth_the_northern_provinces",
			"wh3_main_cth_the_western_provinces",
		},
		wh3_dlc23_chd_zhatan = {
			"wh3_main_ksl_the_great_orthodoxy",
			"wh3_main_ksl_the_ice_court",
			"wh3_main_ogr_goldtooth",
			"wh3_main_cth_the_northern_provinces",
			"wh3_main_cth_the_western_provinces",
		},
		wh3_dlc20_chs_valkia = {
			"wh3_main_sla_seducers_of_slaanesh",
			"wh3_main_tze_oracles_of_tzeentch",
			"wh3_main_nur_poxmakers_of_nurgle",
			"wh3_dlc20_chs_vilitch",
			"wh3_dlc20_chs_azazel",
			"wh3_dlc20_chs_festus"
		},
		wh3_dlc20_chs_vilitch = {
			"wh3_main_sla_seducers_of_slaanesh",
			"wh3_main_kho_exiles_of_khorne",
			"wh3_main_nur_poxmakers_of_nurgle",
			"wh3_dlc20_chs_valkia",
			"wh3_dlc20_chs_azazel",
			"wh3_dlc20_chs_festus"
		},
		wh3_dlc20_chs_azazel = {
			"wh3_main_tze_oracles_of_tzeentch",
			"wh3_main_kho_exiles_of_khorne",
			"wh3_main_nur_poxmakers_of_nurgle",
			"wh3_dlc20_chs_valkia",
			"wh3_dlc20_chs_vilitch",
			"wh3_dlc20_chs_festus"
		},
		wh3_dlc20_chs_festus = {
			"wh3_main_tze_oracles_of_tzeentch",
			"wh3_main_kho_exiles_of_khorne",
			"wh3_main_sla_seducers_of_slaanesh",
			"wh3_dlc20_chs_valkia",
			"wh3_dlc20_chs_vilitch",
			"wh3_dlc20_chs_azazel"
		},
		wh3_main_ksl_the_great_orthodoxy = {
			"wh3_main_kho_exiles_of_khorne",
			"wh3_main_nur_poxmakers_of_nurgle",
			"wh3_main_ogr_disciples_of_the_maw",
			"wh3_main_ogr_goldtooth",
			"wh3_main_sla_seducers_of_slaanesh",
			"wh3_main_tze_oracles_of_tzeentch",
			"wh3_main_dae_daemon_prince"
		},
		wh3_main_ksl_the_ice_court = {
			"wh3_main_kho_exiles_of_khorne",
			"wh3_main_nur_poxmakers_of_nurgle",
			"wh3_main_ogr_disciples_of_the_maw",
			"wh3_main_ogr_goldtooth",
			"wh3_main_sla_seducers_of_slaanesh",
			"wh3_main_tze_oracles_of_tzeentch",
			"wh3_main_dae_daemon_prince"
		},
		wh3_main_ksl_ursun_revivalists = {
			"wh3_main_kho_exiles_of_khorne",
			"wh3_main_nur_poxmakers_of_nurgle",
			"wh3_main_ogr_disciples_of_the_maw",
			"wh3_main_ogr_goldtooth",
			"wh3_main_sla_seducers_of_slaanesh",
			"wh3_main_tze_oracles_of_tzeentch",
			"wh3_main_dae_daemon_prince"
		},
		wh3_dlc24_ksl_daughters_of_the_forest = {
			"wh3_main_kho_exiles_of_khorne",
			"wh3_main_nur_poxmakers_of_nurgle",
			"wh3_main_sla_seducers_of_slaanesh",
			"wh3_main_tze_oracles_of_tzeentch",
			"wh3_main_dae_daemon_prince",
			"wh3_dlc23_chd_astragoth",
			"wh3_dlc23_chd_legion_of_azgorh",
			"wh3_dlc23_chd_zhatan"
		},
		wh3_main_cth_the_northern_provinces = {
			"wh3_main_kho_exiles_of_khorne",
			"wh3_main_ksl_the_great_orthodoxy",
			"wh3_main_ksl_the_ice_court",
			"wh3_main_ksl_ursun_revivalists",
			"wh3_main_nur_poxmakers_of_nurgle",
			"wh3_main_ogr_disciples_of_the_maw",
			"wh3_main_ogr_goldtooth",
			"wh3_main_sla_seducers_of_slaanesh",
			"wh3_main_tze_oracles_of_tzeentch",
			"wh3_main_dae_daemon_prince",
		},
		wh3_main_cth_the_western_provinces = {
			"wh3_main_kho_exiles_of_khorne",
			"wh3_main_ksl_the_great_orthodoxy",
			"wh3_main_ksl_the_ice_court",
			"wh3_main_ksl_ursun_revivalists",
			"wh3_main_nur_poxmakers_of_nurgle",
			"wh3_main_ogr_disciples_of_the_maw",
			"wh3_main_ogr_goldtooth",
			"wh3_main_sla_seducers_of_slaanesh",
			"wh3_main_tze_oracles_of_tzeentch",
			"wh3_main_dae_daemon_prince",
		},
		wh3_dlc24_cth_the_celestial_court = {
			"wh3_main_kho_exiles_of_khorne",
			"wh3_main_ksl_the_great_orthodoxy",
			"wh3_main_ksl_the_ice_court",
			"wh3_main_ksl_ursun_revivalists",
			"wh3_main_nur_poxmakers_of_nurgle",
			"wh3_main_ogr_disciples_of_the_maw",
			"wh3_main_ogr_goldtooth",
			"wh3_main_sla_seducers_of_slaanesh",
			"wh3_main_tze_oracles_of_tzeentch",
			"wh3_main_dae_daemon_prince",
		},
		wh3_dlc24_tze_the_deceivers = {
			"wh3_main_kho_exiles_of_khorne",
			"wh3_main_ksl_the_great_orthodoxy",
			"wh3_main_ksl_the_ice_court",
			"wh3_main_ksl_ursun_revivalists",
			"wh3_main_nur_poxmakers_of_nurgle",
			"wh3_main_sla_seducers_of_slaanesh",
			"wh3_main_dae_daemon_prince",
			"wh3_main_cth_the_northern_provinces",
			"wh3_main_cth_the_western_provinces",
			"wh3_dlc24_cth_the_celestial_court",
			"wh3_dlc24_ksl_daughters_of_the_forest" 
		}
	},

	domination_province_target_default = 50,
	domination_province_target_overrides = {
		wh3_dlc20_chs_valkia = 20,
		wh3_dlc20_chs_vilitch = 20,
		wh3_dlc20_chs_azazel = 20,
		wh3_dlc20_chs_festus = 20,
	},

	----RAZING/SACKING VARIABLES----
	--- used to generate mission parameters when using the ALL_PLAYERS_RAZE_OR_OWN_X_SETTLEMENTS or RAZE_OR_OWN_X_SETTLEMENTS without conditions
	mp_team_size_to_target_regions = {
		[1] = 70,
		[2] = 100,
		[3] = 120,
		[4] = 140,
		[5] = 150,
		[6] = 160,
		[7] = 170,
		[8] = 180
	},
}
--------------------
-----FUNCTIONS------
--------------------

function victory_objectives:generate_objectives(faction_key)
	local campaign_type = cm:model():campaign_type()

	for template_key, template in pairs(self.victory_type_templates) do
		local valid_for_campaign = false
		local valid_for_faction = false

		if template.campaign_types == "any" or template.campaign_types[campaign_type] then
			valid_for_campaign = true
		end

		if template.factions == "any" or template.factions[faction_key] then
			valid_for_faction = true
		end

		if valid_for_campaign and valid_for_faction then
			self:generate_objective_from_template(faction_key, template_key)
		end
	end

end

function victory_objectives:generate_objective_from_template(faction_key, template_key)
	local template = self.victory_type_templates[template_key]

	if not template then
		script_error("Victory objectives: trying to generate objective, but no valid template key given")
		return
	end

	local mission = mission_manager:new(
		faction_key,
		template.mission_key
	)

	if not mission then 
		return 
	end

	mission:set_victory_type(template.victory_type)
	mission:set_show_mission(false)
	mission:set_victory_mission(true)

	local team_size = cm:get_faction(faction_key):team_mates():num_items() +1

	for i = 1, #template.objectives do
		local objective = template.objectives[i]

		--- if in a team of one, replace all-players version of raze/occupy with single player version
		if objective.type == "ALL_PLAYERS_RAZE_OR_OWN_X_SETTLEMENTS" and team_size == 1 then
			mission:add_new_objective("RAZE_OR_OWN_X_SETTLEMENTS")
		else
			mission:add_new_objective(objective.type)
		end

		if objective.type == "DESTROY_FACTION" and not objective.conditions then
			local domination_faction_targets = self.domination_faction_targets_overrides[faction_key] or self.domination_faction_targets_default
			for i, target_faction in ipairs(domination_faction_targets) do
				if target_faction ~= faction_key and not cm:get_faction(target_faction):is_human() then
					mission:add_condition("faction "..target_faction)
				end
			end
			mission:add_condition("confederation_valid")

		elseif objective.type == "CONTROL_N_PROVINCES_INCLUDING" and not objective.conditions then
			local domination_province_target = self.domination_province_target_overrides[faction_key] or self.domination_province_target_default
			mission:add_condition("total "..domination_province_target)

		elseif objective.type == "ALL_PLAYERS_RAZE_OR_OWN_X_SETTLEMENTS" or objective.type == "RAZE_OR_OWN_X_SETTLEMENTS" and not objective.conditions then
			local target_regions_number = self.mp_team_size_to_target_regions[team_size]
			mission:add_condition("total "..target_regions_number)

		else
			for j = 1, #objective.conditions do
				mission:add_condition(objective.conditions[j])
			end
		end

	end

	mission:add_payload("game_victory")

	mission:trigger()
end


