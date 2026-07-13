tiger_mercenaries_config = {
	faction_key = "wh3_cp1_cth_tiger_warriors",
	pooled_resource = "wh3_cp1_cth_iron_favour",
	mercenary_category_groups = 
	{
		"wh3_cp1_tw_group_1",
		"wh3_cp1_tw_group_2",
		"wh3_cp1_tw_group_3",
	},

	initiatives_to_activate = {
		["wh3_cp1_feature_initiatives_cth_buildings_jade"] = {
			buildings = {
				"wh3_cp1_cth_armoury_tigers_2",
			},
			restriction_text = "cp1_jade_building_chain_locked_reason",
			initiative_set = "wh3_cp1_cth_initiative_set_aosy_military_buildings",
		},
		["wh3_cp1_feature_initiatives_cth_buildings_gun"] = {
			buildings = {
				"wh3_cp1_cth_gunpowder_tigers_3",
			},
			restriction_text = "cp1_gunpowder_building_chain_locked_reason",
			initiative_set = "wh3_cp1_cth_initiative_set_aosy_military_buildings",
		},
		["wh3_cp1_feature_initiatives_cth_buildings_celestial"] = {
			buildings = {
				"wh3_cp1_cth_living_forge_tigers_3",
			},
			restriction_text = "cp1_celestial_building_chain_locked_reason",
			initiative_set = "wh3_cp1_cth_initiative_set_aosy_military_buildings",
		},
		["wh3_cp1_feature_initiatives_cth_buildings_machines"] = {
			buildings = {
				"wh3_cp1_cth_alchemist_tigers_3",
			},
			restriction_text = "cp1_machines_building_chain_locked_reason",
			initiative_set = "wh3_cp1_cth_initiative_set_aosy_military_buildings",
		},
		["wh3_cp1_feature_initiatives_cth_ancillaries_talisman"] = {
			ancillaries = {
				"wh3_cp1_anc_talisman_cth_tzeentchbane_teeth",
			},
			initiative_set = "wh3_cp1_cth_initiative_set_aosy_ancillaries",
		},
		["wh3_cp1_feature_initiatives_cth_ancillaries_armours"] = {
			ancillaries = {
				"wh3_cp1_anc_armour_cth_claw_plate",
			},
			initiative_set = "wh3_cp1_cth_initiative_set_aosy_ancillaries",
		},
		["wh3_cp1_feature_initiatives_cth_ancillaries_weapons"] = {
			ancillaries = {
				"wh3_cp1_anc_weapon_cth_desert_sun_claw",
			},
			initiative_set = "wh3_cp1_cth_initiative_set_aosy_ancillaries",
		},
	},

	progression_unlocks = {
		{
			-- tier 1
			mission_keys = {
				"wh3_cp1_camp_cth_bhashiva_mercenary_1_1",
			},
			rituals = {
				"wh3_cp1_cth_aosy_g1_jade_infantry_1",
				"wh3_cp1_cth_aosy_g1_jade_infantry_2",
				"wh3_cp1_cth_aosy_g1_jade_cross_1",
				"wh3_cp1_cth_aosy_g1_jade_cross_2",
			},
			units = {
				"wh3_main_cth_inf_jade_warriors_0",
				"wh3_main_cth_inf_jade_warriors_1",
				"wh3_main_cth_inf_jade_warrior_crossbowmen_0",
				"wh3_main_cth_inf_jade_warrior_crossbowmen_1",
				"wh3_main_cth_cav_jade_lancers_0",
				"wh3_main_cth_inf_iron_hail_gunners_0",
				"wh3_main_cth_inf_crane_gunners_0",
				"wh3_main_cth_art_grand_cannon_0",
				"wh3_dlc24_cth_mon_celestial_lion",
				"wh3_dlc24_cth_mon_great_moon_bird",
				"wh3_main_cth_cav_jade_longma_riders_0",
				"wh3_main_cth_mon_terracotta_sentinel_0",
				"wh3_main_cth_veh_sky_lantern_0",
				"wh3_main_cth_veh_sky_junk_0",
			},
			building_upgrades_initiative_sets = {
			},
		},
		{
			-- tier 2
			mission_keys = {
				"wh3_cp1_camp_cth_bhashiva_mercenary_2_own_n_units",
				"wh3_cp1_camp_cth_bhashiva_mercenary_2_make_upgrades",
				"wh3_cp1_camp_cth_bhashiva_mercenary_2_complete_zhaos_goals",
			},
			rituals = {
				"wh3_cp1_cth_aosy_g1_jade_cav_1",
				"wh3_cp1_cth_aosy_g1_jade_cav_2",
				"wh3_cp1_cth_aosy_g2_gun_infantry_1",
				"wh3_cp1_cth_aosy_g2_gun_infantry_2",
				"wh3_cp1_cth_aosy_g2_artillery_1",
				"wh3_cp1_cth_aosy_g2_artillery_2",
			},
			initiatives = {
				"wh3_cp1_feature_initiatives_cth_buildings_jade",
			},
			building_upgrades_initiative_sets = {
			},
		},
		{
			-- tier 3
			mission_keys = {
				"wh3_cp1_camp_cth_bhashiva_mercenary_3_own_n_units",
				"wh3_cp1_camp_cth_bhashiva_mercenary_3_make_upgrades",
				"wh3_cp1_camp_cth_bhashiva_mercenary_3_fight_chaos",
			},
			rituals = {
				"wh3_cp1_cth_aosy_g3_celestial_beasts_1",
				"wh3_cp1_cth_aosy_g3_celestial_beasts_2",
				"wh3_cp1_cth_aosy_g3_special_cav_1",
				"wh3_cp1_cth_aosy_g3_special_cav_2",

				"wh3_cp1_cth_aosy_g1_jade_infantry_3",
				"wh3_cp1_cth_aosy_g1_jade_cross_3",
			},
			initiatives = {
				"wh3_cp1_feature_initiatives_cth_buildings_gun",
				"wh3_cp1_feature_initiatives_cth_ancillaries_talisman",
			},
			building_upgrades_initiative_sets = {
			},
		},
		{
			-- tier 4
			mission_keys = {
				"wh3_cp1_camp_cth_bhashiva_mercenary_4_own_n_units",
				"wh3_cp1_camp_cth_bhashiva_mercenary_4_complete_zhaos_goals",
				"wh3_cp1_camp_cth_bhashiva_mercenary_4_kill_with_shang_yang",
			},
			rituals = {
				"wh3_cp1_cth_aosy_g3_celestial_machines_1",
				"wh3_cp1_cth_aosy_g3_celestial_machines_2",

				"wh3_cp1_cth_aosy_g1_jade_cav_3",
				"wh3_cp1_cth_aosy_g2_gun_infantry_3",
				"wh3_cp1_cth_aosy_g2_artillery_3",
			},
			initiatives = {
				"wh3_cp1_feature_initiatives_cth_buildings_celestial",
				"wh3_cp1_feature_initiatives_cth_ancillaries_armours",
			},
			building_upgrades_initiative_sets = {
			},
		},
		{
			-- tier 5
			mission_keys = {
				"wh3_cp1_camp_cth_bhashiva_mercenary_5_get_captives",
				"wh3_cp1_camp_cth_bhashiva_mercenary_5_make_upgrades",
				"wh3_cp1_camp_cth_bhashiva_mercenary_5_occupy_settlements",
			},
			rituals = {
				"wh3_cp1_cth_aosy_g3_flying_1",
				"wh3_cp1_cth_aosy_g3_flying_2",
				"wh3_cp1_cth_aosy_g3_flying_3",

				"wh3_cp1_cth_aosy_g3_celestial_beasts_3",
				"wh3_cp1_cth_aosy_g3_special_cav_3",
				"wh3_cp1_cth_aosy_g3_celestial_machines_3",
			},
			initiatives = {
				"wh3_cp1_feature_initiatives_cth_buildings_machines",
				"wh3_cp1_feature_initiatives_cth_ancillaries_weapons",
			},
			building_upgrades_initiative_sets = {
			},
		},
	},
	ritual_category_mapping = {
		["CP1_TW_GROUP_1_UNITS_JADE_INFANTRY"] = {
			"wh3_cp1_cth_aosy_g1_jade_infantry_1",
			"wh3_cp1_cth_aosy_g1_jade_infantry_2",
			"wh3_cp1_cth_aosy_g1_jade_infantry_3",
		},

		["CP1_TW_GROUP_1_UNITS_JADE_ARCHERS"] = {
			"wh3_cp1_cth_aosy_g1_jade_cross_1",
			"wh3_cp1_cth_aosy_g1_jade_cross_2",
			"wh3_cp1_cth_aosy_g1_jade_cross_3",
		},

		["CP1_TW_GROUP_1_UNITS_JADE_CAVALRY"] = {
			"wh3_cp1_cth_aosy_g1_jade_cav_1",
			"wh3_cp1_cth_aosy_g1_jade_cav_2",
			"wh3_cp1_cth_aosy_g1_jade_cav_3",
		},

		["CP1_TW_GROUP_2_UNITS_GUNPOWDER_INFANTRY"] = {
			"wh3_cp1_cth_aosy_g2_gun_infantry_1",
			"wh3_cp1_cth_aosy_g2_gun_infantry_2",
			"wh3_cp1_cth_aosy_g2_gun_infantry_3",
		},
		
		["CP1_TW_GROUP_2_UNITS_ARTILLERY"] = {
			"wh3_cp1_cth_aosy_g2_artillery_1",
			"wh3_cp1_cth_aosy_g2_artillery_2",
			"wh3_cp1_cth_aosy_g2_artillery_3",
		},

		["CP1_TW_GROUP_3_UNITS_CELESTIAL_BEASTS"] = {
			"wh3_cp1_cth_aosy_g3_celestial_beasts_1",
			"wh3_cp1_cth_aosy_g3_celestial_beasts_2",
			"wh3_cp1_cth_aosy_g3_celestial_beasts_3",
		},

		["CP1_TW_GROUP_3_UNITS_CELESTIAL_MACHINES"] = {
			"wh3_cp1_cth_aosy_g3_celestial_machines_1",
			"wh3_cp1_cth_aosy_g3_celestial_machines_2",
			"wh3_cp1_cth_aosy_g3_celestial_machines_3",
		},

		["CP1_TW_GROUP_3_UNITS_SPECIALIST_CAVALRY"] = {
			"wh3_cp1_cth_aosy_g3_special_cav_1",
			"wh3_cp1_cth_aosy_g3_special_cav_2",
			"wh3_cp1_cth_aosy_g3_special_cav_3",
		},

		["CP1_TW_GROUP_4_UNITS_FLYING_MACHINES"] = {
			"wh3_cp1_cth_aosy_g3_flying_1",
			"wh3_cp1_cth_aosy_g3_flying_2",
			"wh3_cp1_cth_aosy_g3_flying_3",
		},
	},
	category_to_units_and_upgrades_mapping =
	{
		-- In the current design units can be upgraded through initiatives which are stored in a set
		["CP1_TW_GROUP_1_UNITS_JADE_INFANTRY"] = { 
			units = {
				"wh3_main_cth_inf_jade_warriors_0",
				"wh3_main_cth_inf_jade_warriors_1",
			},
			unit_capacity_upgrade_for_category = "wh3_cp1_ritual_cth_group_1_jade_infantry_capacity",
		},
		["CP1_TW_GROUP_1_UNITS_JADE_ARCHERS"] = { 
			units = {
				"wh3_main_cth_inf_jade_warrior_crossbowmen_0",
				"wh3_main_cth_inf_jade_warrior_crossbowmen_1",
			},
			unit_capacity_upgrade_for_category = "wh3_cp1_ritual_cth_group_1_jade_archers_capacity",
		},
		["CP1_TW_GROUP_1_UNITS_JADE_CAVALRY"] = { 
			units = {
				"wh3_main_cth_cav_jade_lancers_0",
			},
			unit_capacity_upgrade_for_category = "wh3_cp1_ritual_cth_group_1_jade_cavalry_capacity",
		},
		["CP1_TW_GROUP_2_UNITS_GUNPOWDER_INFANTRY"] = { 
			units = {
				"wh3_main_cth_inf_iron_hail_gunners_0",
				"wh3_main_cth_inf_crane_gunners_0",
			},
			unit_capacity_upgrade_for_category = "wh3_cp1_ritual_cth_group_2_gunpowder_infantry_capacity",
		},
		["CP1_TW_GROUP_2_UNITS_ARTILLERY"] = { 
			units = {
				"wh3_main_cth_art_grand_cannon_0",
			},
			unit_capacity_upgrade_for_category = "wh3_cp1_ritual_cth_group_2_artillery_capacity",
		},
		["CP1_TW_GROUP_3_UNITS_SPECIALIST_CAVALRY"] = { 
			units = {
				"wh3_main_cth_cav_jade_longma_riders_0",
			},
			unit_capacity_upgrade_for_category = "wh3_cp1_ritual_cth_group_3_specialist_cavalry_capacity",
		},
		["CP1_TW_GROUP_3_UNITS_CELESTIAL_BEASTS"] = { 
			units = {
				"wh3_dlc24_cth_mon_celestial_lion",
				"wh3_dlc24_cth_mon_great_moon_bird",
			},
			unit_capacity_upgrade_for_category = "wh3_cp1_ritual_cth_group_3_celestial_beasts_capacity",
		},
		["CP1_TW_GROUP_3_UNITS_CELESTIAL_MACHINES"] = { 
			units = {
				"wh3_main_cth_mon_terracotta_sentinel_0",
			},
			unit_capacity_upgrade_for_category = "wh3_cp1_ritual_cth_group_3_celestial_machines_capacity",
		},
		["CP1_TW_GROUP_4_UNITS_FLYING_MACHINES"] = { 
			units = {
				"wh3_main_cth_veh_sky_junk_0",
				"wh3_main_cth_veh_sky_lantern_0",
			},
			unit_capacity_upgrade_for_category = "wh3_cp1_ritual_cth_group_4_flying_machines_capacity",
		},
	},
	
	mercenary_groups_list_key = "tiger_merc_groups_list",
	units_for_category_key_prefix = "units_for_category:",
	unit_capacity_upgrade_for_category_key_prefix = "unit_capacity_upgrade_for_category:",
	required_tier_unlock_for_category_key_prefix = "tiger_merc_get_required_tier_for_category:",
	required_tier_for_ritual_key_prefix = "tiger_merc_required_tier_for_ritual:",
	should_show_ui_notification_for_hud_key = "tiger_merc_should_show_ui_notification_for_hud",
	should_show_ui_notification_for_upgrade_key_prefix = "tiger_merc_should_show_notification_for_upgrade:",
	should_show_ui_notification_for_category_prefix = "tiger_merc_should_show_notification_for_category:",
	feature_unlocked_key = "tiger_merc_unlocked",
	required_resource_gained_to_unlock_campaign_var_key = "ui_armies_of_shang_yang_required_resource_gained_to_unlock",
	army_capacity_ritual_key = "wh3_cp1_ritual_cth_aosy_army_capacity",
	army_capacity_effect_bundle_key = "wh3_cp1_ritual_cth_army_capacity_bundle",
	army_capacity_effect_key = "wh2_dlc09_effect_increase_army_capacity",
	redirection_target_key = "tiger_merc_redirection_target",
	armies_of_shang_yang_unlocked_incident_key = "wh3_cp1_cth_armies_of_shang_yang_panel_unlocked",

	mission_issuer = "CLAN_ELDERS",
	scripted_missions_setup = {
		wh3_cp1_camp_cth_bhashiva_mercenary_2_make_upgrades = {
			type = "upgrade_units",
			objective_text = "cp1_scripted_mis_upgrade_units",
			objective_ritual_categories = {
				"CP1_TW_GROUP_1_UNITS_JADE_INFANTRY",
				"CP1_TW_GROUP_1_UNITS_JADE_ARCHERS",
				"CP1_TW_GROUP_1_UNITS_JADE_CAVALRY",
				"CP1_TW_GROUP_2_UNITS_GUNPOWDER_INFANTRY",
				"CP1_TW_GROUP_2_UNITS_ARTILLERY",
				"CP1_TW_GROUP_3_UNITS_CELESTIAL_BEASTS",
				"CP1_TW_GROUP_3_UNITS_CELESTIAL_MACHINES",
				"CP1_TW_GROUP_3_UNITS_SPECIALIST_CAVALRY",
				"CP1_TW_GROUP_4_UNITS_FLYING_MACHINES",				
			},
			objective_required_amount = 1,
			objective_save_key = "cp1_make_upgrades_save_2",
			treasury_payload = 1500,
		},
		wh3_cp1_camp_cth_bhashiva_mercenary_2_complete_zhaos_goals = {
			type = "complete_missions",
			objective_text = "cp1_scripted_complete_zhao_goals",
			objective_mission_keys = {
				"wh3_cp1_camp_cth_enemies_of_cathay_1",
				"wh3_cp1_camp_cth_enemies_of_cathay_2",
				"wh3_cp1_camp_cth_enemies_of_cathay_3",
			},
			objective_required_amount = 1,
			objective_save_key = "cp1_complete_zhaos_goals_2",
			pooled_resource_payload = {
				key = "wh3_cp1_cth_iron_favour",
				factor = "missions",
				amount = 80
			},
		},
		wh3_cp1_camp_cth_bhashiva_mercenary_3_fight_chaos = {
			type = "fight_cultures",
			objective_text = "cp1_scripted_fight_battles_against_culture",
			objective_cultures = {
				"wh3_main_tze_tzeentch",
				"wh3_main_kho_khorne",
				"wh3_main_sla_slaanesh",
				"wh3_main_nur_nurgle",
				"wh3_dlc23_chd_chaos_dwarfs",
				"wh_main_chs_chaos",
				"wh2_main_skv_skaven",
			},
			objective_required_amount = 6,
			objective_save_key = "cp1_fight_against_cultures_save",
			pooled_resource_payload = {
				key = "wh3_cp1_cth_iron_favour",
				factor = "missions",
				amount = 400
			},
		},
		wh3_cp1_camp_cth_bhashiva_mercenary_3_make_upgrades = {
			type = "upgrade_units",
			objective_text = "cp1_scripted_mis_upgrade_units",
			objective_ritual_categories = {
				"CP1_TW_GROUP_1_UNITS_JADE_INFANTRY",
				"CP1_TW_GROUP_1_UNITS_JADE_ARCHERS",
				"CP1_TW_GROUP_1_UNITS_JADE_CAVALRY",
				"CP1_TW_GROUP_2_UNITS_GUNPOWDER_INFANTRY",
				"CP1_TW_GROUP_2_UNITS_ARTILLERY",
				"CP1_TW_GROUP_3_UNITS_CELESTIAL_BEASTS",
				"CP1_TW_GROUP_3_UNITS_CELESTIAL_MACHINES",
				"CP1_TW_GROUP_3_UNITS_SPECIALIST_CAVALRY",
				"CP1_TW_GROUP_4_UNITS_FLYING_MACHINES",				
			},
			objective_required_amount = 6,
			objective_save_key = "cp1_make_upgrades_save_3",
			treasury_payload = 1500,
		},
		wh3_cp1_camp_cth_bhashiva_mercenary_4_complete_zhaos_goals = {
			type = "complete_missions",
			objective_text = "cp1_scripted_complete_zhao_goals",
			objective_mission_keys = {
				"wh3_cp1_camp_cth_enemies_of_cathay_1",
				"wh3_cp1_camp_cth_enemies_of_cathay_2",
				"wh3_cp1_camp_cth_enemies_of_cathay_3",
			},
			objective_required_amount = 5,
			objective_save_key = "cp1_complete_zhaos_goals_4",
			treasury_payload = 2000,
		},
		wh3_cp1_camp_cth_bhashiva_mercenary_5_make_upgrades = {
			type = "upgrade_units",
			objective_text = "cp1_scripted_mis_upgrade_units",
			objective_ritual_categories = {
				"CP1_TW_GROUP_1_UNITS_TIGER_WARRIORS",
				"CP1_TW_GROUP_1_UNITS_JADE_INFANTRY",
				"CP1_TW_GROUP_1_UNITS_JADE_ARCHERS",
				"CP1_TW_GROUP_1_UNITS_JADE_CAVALRY",
				"CP1_TW_GROUP_2_UNITS_GUNPOWDER_INFANTRY",
				"CP1_TW_GROUP_2_UNITS_ARTILLERY",
				"CP1_TW_GROUP_3_UNITS_CELESTIAL_BEASTS",
				"CP1_TW_GROUP_3_UNITS_CELESTIAL_MACHINES",
				"CP1_TW_GROUP_3_UNITS_SPECIALIST_CAVALRY",
				"CP1_TW_GROUP_4_UNITS_FLYING_MACHINES",
			},
			objective_required_amount = 14,
			objective_save_key = "cp1_make_upgrades_save_5",
			treasury_payload = 2000,
		},
	},
	cai_max_turn_to_unlock_next_tier = 30,
}

tiger_mercenaries = {}
tiger_mercenaries.config = tiger_mercenaries_config
tiger_mercenaries.dynamic_data = {}

function tiger_mercenaries:initialise()
	if is_empty_table(self.dynamic_data) then
		self.dynamic_data.current_tier = 1
		self.dynamic_data.cai_turn_to_unlock_next_tier = 1
	end

	if cm:is_new_game() then
		for i, setup in dpairs(self.config.initiatives_to_activate) do
			if setup.buildings then
				for k, building_key in ipairs(setup.buildings) do
					cm:add_event_restricted_building_record_for_faction(
						building_key,
						self.config.faction_key,
						setup.restriction_text
					)
				end
			end
		end
		tiger_mercenaries:lock_all_building_upgrades()
		local faction = cm:get_faction(self.config.faction_key)
		cm:set_script_state(faction, self.config.feature_unlocked_key, false)
		tiger_mercenaries:issue_initial_missions()
		tiger_mercenaries:lock_unit_upgrades()
	end

	tiger_mercenaries:initialise_shared_states()
	tiger_mercenaries:add_mission_listeners()
	tiger_mercenaries:add_initiative_activated_listeners()
	tiger_mercenaries:add_ritual_listeners()
	tiger_mercenaries:add_panel_listeners()
	tiger_mercenaries:add_pooled_resource_listeners()
	tiger_mercenaries:add_ui_trigger_listeners()
	tiger_mercenaries:lock_units_restricted_by_tier_progress() -- unit lock
	tiger_mercenaries:handle_scripted_mission_reissue()
	tiger_mercenaries:handle_ai_listeners()
	tiger_mercenaries:add_unit_purchase_effect_listeners()
end

function tiger_mercenaries:initialise_shared_states()
	local faction = cm:get_faction(self.config.faction_key)

	-- groups
	local groups_list = table.concat(self.config.mercenary_category_groups, ";")
	cm:set_script_state(faction, self.config.mercenary_groups_list_key, groups_list)

	local unit_to_category = {}
	-- unit and initiative set per category
	for category, data in dpairs(self.config.category_to_units_and_upgrades_mapping) do
		for i = 1, #data.units do
			local unit = data.units[i]
			unit_to_category[unit] = category
		end
		local units_list = table.concat(data.units, ";")
		cm:set_script_state(faction, self.config.units_for_category_key_prefix .. category, units_list)
		cm:set_script_state(faction, self.config.unit_capacity_upgrade_for_category_key_prefix .. category, data.unit_capacity_upgrade_for_category)
	end

	for tier = 1, #self.config.progression_unlocks do
		local tier_data = self.config.progression_unlocks[tier]

		if tier_data.units and not is_empty_table(tier_data.units) then
			for unit_index = 1, #tier_data.units do
				local category = unit_to_category[tier_data.units[unit_index]]
				cm:set_script_state(faction, self.config.required_tier_unlock_for_category_key_prefix .. category, tier)
			end
		end

		for ritual_index = 1, #tier_data.rituals do
			cm:set_script_state(faction, self.config.required_tier_for_ritual_key_prefix .. tier_data.rituals[ritual_index], tier)
		end
	end

	local starting_unlocked_rituals = self.config.progression_unlocks[1].rituals_unlocked_by_default
	if starting_unlocked_rituals then
		for ritual_index = 1, #starting_unlocked_rituals do
			cm:set_script_state(faction, self.config.required_tier_for_ritual_key_prefix .. starting_unlocked_rituals[ritual_index], 0)
		end
	end
end

function tiger_mercenaries:lock_unit_upgrades()
	local faction_si = cm:get_faction(self.config.faction_key)
	if faction_si:is_human() then
		local rituals = self.config.ritual_category_mapping
		for category, rituals_for_category in dpairs(rituals) do
			for i = 1, #rituals_for_category do
				local ritual = rituals_for_category[i]
				cm:faction_set_unit_purchasable_effect_lock_state(faction_si, ritual .. "_upgrade", ritual .. "_reason", true)
			end
		end
	end
end

function tiger_mercenaries:issue_initial_missions()
	local faction = cm:get_faction(self.config.faction_key)
	if faction:is_human() == false then
		return -- don't trigger when it's played by AI 
	end
	local first_missions = self.config.progression_unlocks[1].mission_keys
	for i = 1, #first_missions do
		local curr_mission_key = first_missions[i]
		if not cm:mission_has_been_issued_for_faction(faction, curr_mission_key) then
			if self.config.scripted_missions_setup[curr_mission_key] then
				self:handle_scripted_mission_trigger(self.config.scripted_missions_setup[curr_mission_key], curr_mission_key, true)
			else
				cm:trigger_mission(self.config.faction_key, curr_mission_key, true)
			end
		end
	end
end

function tiger_mercenaries:handle_scripted_mission_reissue()
	local faction = cm:get_faction(self.config.faction_key)
	for mission_key, mission_data in dpairs(self.config.scripted_missions_setup) do
		if cm:mission_has_been_issued_for_faction(faction, mission_key) then
			self:handle_scripted_mission_trigger(mission_data, mission_key, false)
		end
	end
end

function tiger_mercenaries:handle_scripted_mission_trigger(mission_data, mission_key, should_trigger)
	if mission_data.type == "fight_cultures" then
		self:setup_fight_battles_against_culture(mission_data, mission_key, should_trigger)
	elseif mission_data.type == "max_replenishment" then
		self:setup_reach_max_replenishment(mission_data, mission_key, should_trigger)
	elseif mission_data.type == "upgrade_units" then
		self:setup_perform_ritual(mission_data, mission_key, should_trigger)
	elseif mission_data.type == "complete_missions" then
		self:setup_complete_zhao_missions(mission_data, mission_key, should_trigger)
	end
end

function tiger_mercenaries:setup_fight_battles_against_culture(mission_setup_data, mission_key, should_trigger)
	local mm = mission_manager:new(self.config.faction_key, mission_key)
	local objective_key = "mission_text_text_" .. mission_setup_data.objective_text
	
	mm:set_mission_issuer(self.config.mission_issuer)
	mm:add_new_scripted_objective(
		objective_key,
		"BattleCompleted",
		function(context)
			-- Check if battle is won against target cultures and the required amount of times
			if cm:pending_battle_cache_faction_won_battle_against_culture(self.config.faction_key, mission_setup_data.objective_cultures) then
				if self:update_and_check_required_number_for_objective(mission_setup_data, mm, objective_key) then
					return true
				end
			end
			return false
		end
	)

	self:updated_scripted_objective_count(mm, objective_key, mission_setup_data.objective_save_key, mission_setup_data.objective_required_amount)

	self:setup_mission_payload(mm, mission_setup_data)
	
	if should_trigger then mm:trigger() end
end

function tiger_mercenaries:setup_perform_ritual(mission_setup_data, mission_key, should_trigger)
	local mm = mission_manager:new(self.config.faction_key, mission_key)
	local objective_key = "mission_text_text_" .. mission_setup_data.objective_text
	
	mm:set_mission_issuer(self.config.mission_issuer)
	mm:add_new_scripted_objective(
		objective_key,
		"RitualCompletedEvent",
		function(context)
			local ritual_faction = context:performing_faction()
			local ritual = context:ritual()
			if ritual_faction:name() == self.config.faction_key and  table.find(mission_setup_data.objective_ritual_categories, ritual:ritual_category()) then
				local trigger_delay = 0
				if self:update_and_check_required_number_for_objective(mission_setup_data, mm, objective_key, trigger_delay) then
					return true
				end
			end
			return false
		end
	)

	self:updated_scripted_objective_count(mm, objective_key, mission_setup_data.objective_save_key, mission_setup_data.objective_required_amount)

	self:setup_mission_payload(mm, mission_setup_data)
	
	if should_trigger then mm:trigger() end
end

function tiger_mercenaries:setup_complete_zhao_missions(mission_setup_data, mission_key, should_trigger)
	local mm = mission_manager:new(self.config.faction_key, mission_key)
	local objective_key = "mission_text_text_" .. mission_setup_data.objective_text
	
	mm:set_mission_issuer(self.config.mission_issuer)
	mm:add_new_scripted_objective(
		objective_key,
		"MissionSucceeded",
		function(context)
			local faction_key = context:faction():name()
			local mission_key = context:mission():mission_record_key()
			if faction_key == self.config.faction_key and self:is_zhao_mission(mission_setup_data, mission_key) then
				if self:update_and_check_required_number_for_objective(mission_setup_data, mm, objective_key) then
					return true
				end
			end
			return false
		end
	)

	self:updated_scripted_objective_count(mm, objective_key, mission_setup_data.objective_save_key, mission_setup_data.objective_required_amount)

	self:setup_mission_payload(mm, mission_setup_data)
	
	if should_trigger then mm:trigger() end
end

function tiger_mercenaries:setup_reach_max_replenishment(mission_setup_data, mission_key, should_trigger)
	local mm = mission_manager:new(self.config.faction_key, mission_key)
	local objective_key = "mission_text_text_" .. mission_setup_data.objective_text
	
	mm:set_mission_issuer(self.config.mission_issuer)
	mm:add_new_scripted_objective(
		objective_key,
		"FactionInitiativeActivationChangedEvent",
		function(context)
			local is_active = context:active()
			local initiative_key = context:initiative():record_key()
			local faction = context:faction()

			return faction:name() == self.config.faction_key and is_active
				and string.find(initiative_key, mission_setup_data.objective_initiative_prefix)
				and string.find(initiative_key, mission_setup_data.objective_initiative_sufix)
		end
	)

	self:updated_scripted_objective_count(mm, objective_key, mission_setup_data.objective_save_key, mission_setup_data.objective_required_amount)

	self:setup_mission_payload(mm, mission_setup_data)
	
	if should_trigger then mm:trigger() end
end

function tiger_mercenaries:update_and_check_required_number_for_objective(mission_setup_data, mission_manager, objective_key, delay)
	local objective_count = cm:get_saved_value(mission_setup_data.objective_save_key) or 0
	objective_count = objective_count + 1
	cm:set_saved_value(mission_setup_data.objective_save_key, objective_count)
	self:updated_scripted_objective_count(mission_manager, objective_key, mission_setup_data.objective_save_key, mission_setup_data.objective_required_amount, delay)
	if objective_count >= mission_setup_data.objective_required_amount then
		return true
	end
	return false
end

function tiger_mercenaries:updated_scripted_objective_count(mission_manager, objective_key, objective_save_key, required_amount, delay)
	local objectives_count = cm:get_saved_value(objective_save_key) or 0
	local delay = delay or 0.5
	cm:callback(
		function()
			mission_manager:update_scripted_objective_text(
				objective_key,
				objectives_count,
				required_amount
			)
		end,
		delay
	)
end

function tiger_mercenaries:lock_units_restricted_by_tier_progress()
	if self.dynamic_data.current_tier then
		for tier = self.dynamic_data.current_tier, #self.config.progression_unlocks do
			local tier_data = self.config.progression_unlocks[tier]
			if tier_data.units and not is_empty_table(tier_data.units) then
				for unit_index = 1, #tier_data.units do
					cm:add_event_restricted_unit_record_for_faction(tier_data.units[unit_index], self.config.faction_key, "cp1_units_aosy_locked_reason")
				end
			end
		end
	end
end


function tiger_mercenaries:lock_all_building_upgrades()
	for tier = 1, #self.config.progression_unlocks do
		local tier_data = self.config.progression_unlocks[tier]
		tiger_mercenaries:set_initiative_sets_lock_state(tier_data.building_upgrades_initiative_sets, true)
	end
end

function tiger_mercenaries:setup_mission_payload(mission_manager, mission_data)
	if mission_data.effect_bundle_payload ~= nil then
		mission_manager:add_payload("effect_bundle{bundle_key " .. mission_data.effect_bundle_payload .. ";turns 0;}")
	end

	if mission_data.treasury_payload ~= nil then
		mission_manager:add_payload("money " .. mission_data.treasury_payload)
	end

	if mission_data.pooled_resource_payload ~= nil then
		mission_manager:add_payload(self:generate_pooled_resource_payload_string(mission_data.pooled_resource_payload))
	end
end

function tiger_mercenaries:generate_pooled_resource_payload_string(pooled_resource_payload)
	local key = pooled_resource_payload.key
	local factor = pooled_resource_payload.factor
	local amount = pooled_resource_payload.amount

	return "faction_pooled_resource_transaction{resource "..key..";factor "..factor..";amount "..amount..";context absolute;}"
end

function tiger_mercenaries:add_mission_listeners()
	core:add_listener(
		"tiger_mercenaries_handle_mission_complete",
		"MissionSucceeded",
		function(context)
			local faction = context:faction()
			if faction:name() ~= self.config.faction_key or not faction:is_human() then
				return false
			end

			local current_tier_data = self.config.progression_unlocks[self.dynamic_data.current_tier]
			
			if not current_tier_data then
				return false
			end

			for i = 1, #current_tier_data.mission_keys do
				if cm:mission_is_active_for_faction(faction, current_tier_data.mission_keys[i])  then
					-- there's other missions in this tier that aren't complete. Don't unlock the rewards yet
					return false
				end
			end
			
			return true
		end,
		function(context)
			local tier = self.dynamic_data.current_tier
			local new_tier_data = self.config.progression_unlocks[tier]
			tiger_mercenaries:handle_ritual_unlock(new_tier_data.rituals, context:faction())
			tiger_mercenaries:handle_units_unlock(new_tier_data.units) -- unit lock
			tiger_mercenaries:handle_initiatives_activation(new_tier_data.initiatives)
			tiger_mercenaries:set_initiative_sets_lock_state(new_tier_data.building_upgrades_initiative_sets, false)
			tiger_mercenaries:handle_tier_unlock()
			if tier == 1 then
				-- When the armies of shang yang panel is unlocked we must trigger this incident
				cm:trigger_incident(self.config.faction_key, self.config.armies_of_shang_yang_unlocked_incident_key, true)
			end
			cm:set_script_state(context:faction(), self.config.should_show_ui_notification_for_hud_key, true)
		end,
		true
	)
end

function tiger_mercenaries:add_initiative_activated_listeners()
	core:add_listener(
		"tiger_mercenaries_on_initiative_activated",
		"FactionInitiativeActivationChangedEvent",
		function(context)
			local faction = context:faction()

			if faction:name() ~= self.config.faction_key or not faction:is_human() then
				return false
			end

			return true
		end,
		function(context)
			local initiative_key = context:initiative():record_key()
			local initiative_set = context:initiative_set():record_key()
			local faction = cm:get_faction(self.config.faction_key)
			local initiative_data = self.config.initiatives_to_activate[initiative_key]
 
			if initiative_data then
				if initiative_data.buildings then
					for k, building_key in pairs(initiative_data.buildings) do
						cm:remove_event_restricted_building_record_for_faction(
							building_key,
							self.config.faction_key
						)
					end
				end
 
				if initiative_data.ancillaries then
					for i, ancillary_key in pairs(initiative_data.ancillaries) do
						cm:add_ancillary_to_faction(faction, ancillary_key, false)
					end
				end
			end	
		end,
		true
	)
end

function tiger_mercenaries:add_ritual_listeners()
	core:add_listener(
		"UnitEquipmentUnlockRitual",
		"RitualCompletedEvent",
		function(context)
			local faction_si = context:ritual_target_faction()
			local ritual_category = context:ritual():ritual_category()

			if faction_si:is_human() and faction_si:name() == self.config.faction_key then
				return self.config.ritual_category_mapping[ritual_category]
			end
		end,
		function(context)
			local faction = self.config.faction_key
			local ritual = context:ritual():ritual_key()

			if not self.dynamic_data.unlocked_ugrades then
				self.dynamic_data.unlocked_ugrades = {}
			end

			if not table.find(self.dynamic_data.unlocked_ugrades, ritual) then
				cm:faction_set_unit_purchasable_effect_lock_state(context:ritual_target_faction(), ritual .. "_upgrade", ritual .. "_reason", false)
				table.insert(self.dynamic_data.unlocked_ugrades, ritual)
			end

			cm:faction_add_pooled_resource(faction, ritual .. "_resource", "other", 1)
		end,
		true
	);

	core:add_listener(
		"ArmyCapacityUpgraded",
		"RitualCompletedEvent",
		function(context)
			local faction = context:performing_faction()
			if faction:name() ~= self.config.faction_key then
				return false
			end
			return context:ritual():ritual_key() == self.config.army_capacity_ritual_key
		end,
		function(context)
			local faction = context:performing_faction()
			local ritual = context:ritual():ritual_key()
			local num_uses = faction:rituals():get_tracked_cost_uses(ritual)
			if num_uses < 2 then
				return
			end
			local bundle = self:get_faction_bundle_by_key(faction, self.config.army_capacity_effect_bundle_key)
			local bundle_copy = bundle:clone_and_create_custom_effect_bundle(cm:model())
			local success = bundle_copy:set_effect_value_by_key(self.config.army_capacity_effect_key, num_uses)
			if success then
				cm:apply_custom_effect_bundle_to_faction(bundle_copy, faction)
			end
		end,
		true
	);
end

function tiger_mercenaries:add_panel_listeners()
	-- panel is closed
	core:add_listener(
		"tiger_merc_PanelClosedCampaign",
		"PanelClosedCampaign",
		function(context)
			return context.string == "cp1_cth_shang_yang"
		end,
		function(context)
			-- Remove notification icon when going back from the panel
			local faction = cm:get_faction(self.config.faction_key)
			cm:set_script_state(faction, self.config.should_show_ui_notification_for_hud_key, false)
			for tier = 1, #self.config.progression_unlocks do
				local tier_data = self.config.progression_unlocks[tier]
				if not is_nil(tier_data.rituals) and not is_empty_table(tier_data.rituals) then
					for i = 1, #tier_data.rituals do
						local ritual_key = tier_data.rituals[i]
						local category_key = tiger_mercenaries:get_category_for_ritual(ritual_key)
						cm:set_script_state(faction, self.config.should_show_ui_notification_for_upgrade_key_prefix .. ritual_key, false)
						if not is_nil(category_key) then
							cm:set_script_state(faction, self.config.should_show_ui_notification_for_category_prefix .. category_key, false)
						end
					end
				end
			end
		end, 
		true
	)
end

function tiger_mercenaries:add_pooled_resource_listeners()
	core:add_listener(
		"tiger_merc_feature_unlock_listener",
		"PooledResourceChanged",
		function(context)
			return context:resource():key() == self.config.pooled_resource
		end,
		function(context)
			local faction = context:faction()
			local value = context:resource():value()
			local required_resource = cm:campaign_var_int_value(self.config.required_resource_gained_to_unlock_campaign_var_key)
			local unlocked = cm:model():shared_states_manager():get_state_as_bool_value(faction, self.config.feature_unlocked_key)
			if not unlocked and value >= required_resource then
				cm:set_script_state(context:faction(), self.config.feature_unlocked_key, true)
				core:trigger_event("ScriptEventTigerMercenariesUnlocked", faction)
				if not faction:is_human() then
					self:handle_ai_tier_unlock(faction)
				end
			end
		end,
		true
	)
end

function tiger_mercenaries:add_ui_trigger_listeners()
	core:add_listener(
		"tiger_merc_unit_upgrade_redirection_select",
		"ContextTriggerEvent",
		function(context)
			return context.string:starts_with("tiger_merc_redirect_to_upgrade")
		end,
		function(context)
			local bundle_key = context.string:split(":")[2]
			local ritual_key = string.gsub(bundle_key, "_bundle", "")
			local faction = cm:get_faction(self.config.faction_key)
			cm:set_script_state(faction, self.config.redirection_target_key, ritual_key)
		end,
		true
	);

	core:add_listener(
		"tiger_merc_unit_upgrade_redirection_clear",
		"ContextTriggerEvent",
		function(context)
			return context.string:starts_with("tiger_merc_redirect_clear")
		end,
		function(context)
			local faction = cm:get_faction(self.config.faction_key)
			cm:set_script_state(faction, self.config.redirection_target_key, "")
		end,
		true
	);
end


function tiger_mercenaries:add_unit_purchase_effect_listeners()
	core:add_listener(
		"UnitEquipmentUnlockRitual",
		"UnitEffectUnpurchased",
		function(context)
			local effect = context:effect():record_key()

			if string.find(effect, "wh3_cp1_cth_aosy_g") then
				return true
			end

			return false
		end,
		function(context)
			local effect = context:effect():record_key()
			local resource = string.gsub(effect, "_upgrade", "_resource")
			local faction = self.config.faction_key

			cm:faction_add_pooled_resource(faction, resource, "other", 1)
		end,
		true
	)

	core:add_listener(
		"tiger_merc_refund_unit_upgrade_when_destroyed_from_merge",
		"UnitMergedAndDestroyed",
		function(context)
			local faction = context:unit():faction()
			return faction:name() == self.config.faction_key and faction:is_human()
		end,
		function(context)
			tiger_mercenaries:handle_unit_purchased_effect_lost(context:unit())
		end,
		true
	)

	core:add_listener(
		"tiger_merc_refund_unit_upgrade_when_destroyed_from_disband",
		"UnitDisbanded",
		function(context)
			local faction = context:unit():faction()
			return faction:name() == self.config.faction_key and faction:is_human()
		end,
		function(context)
			tiger_mercenaries:handle_unit_purchased_effect_lost(context:unit())
		end,
		true
	)

	core:add_listener(
		"tiger_merc_refund_unit_upgrade_when_destroyed",
		"UnitAboutToBeDestroyedByBattle",
		function(context)
			local faction = context:unit():faction()
			return faction:name() == self.config.faction_key and faction:is_human()
		end,
		function(context)
			tiger_mercenaries:handle_unit_purchased_effect_lost(context:unit())
		end,
		true
	)
end

function tiger_mercenaries:handle_ai_tier_unlock(faction)
	local new_tier_data = self.config.progression_unlocks[self.dynamic_data.current_tier]
	if not new_tier_data then
		return
	end
	tiger_mercenaries:handle_ritual_unlock(new_tier_data.rituals, faction)
	tiger_mercenaries:handle_units_unlock(new_tier_data.units) -- unit lock
	tiger_mercenaries:handle_initiatives_activation(new_tier_data.initiatives)
	tiger_mercenaries:set_initiative_sets_lock_state(new_tier_data.building_upgrades_initiative_sets, false)
	
	local next_tier = self.dynamic_data.current_tier + 1
	if next_tier > #self.config.progression_unlocks then
		return
	end
	self.dynamic_data.current_tier = next_tier
	self.dynamic_data.cai_turn_to_unlock_next_tier = cm:turn_number() + cm:random_number(self.config.cai_max_turn_to_unlock_next_tier)
end

function tiger_mercenaries:handle_ai_listeners()
	core:add_listener(
		"tiger_merc_CAI_listener",
		"FactionTurnStart",
		function(context)
			local faction = context:faction()
			return faction:name() == self.config.faction_key and not faction:is_human()
		end,
		function(context)
			local faction = context:faction()
			local turn = cm:turn_number()
			local unlocked = cm:model():shared_states_manager():get_state_as_bool_value(faction, self.config.feature_unlocked_key)
			if unlocked and turn >= self.dynamic_data.cai_turn_to_unlock_next_tier then
				self:handle_ai_tier_unlock(faction)
			end
		end,
		true
	)
end

--------------------------------------------------------------
---------------------------- UTIL ----------------------------
--------------------------------------------------------------

function tiger_mercenaries:handle_unit_purchased_effect_lost(unit)
	local purchased_effects = unit:get_unit_purchased_effects()
	for i = 0, purchased_effects:num_items() - 1 do
		local purchased_effect = purchased_effects:item_at(i)
		local record_key = purchased_effect:record_key()
		local resource = string.gsub(record_key, "_upgrade", "_resource")
		cm:faction_add_pooled_resource(self.config.faction_key, resource, "other", 1)
	end
end

function tiger_mercenaries:get_faction_bundle_by_key(faction_interface, bundle_key)
	local effect_bundle_list = faction_interface:effect_bundles()

	for i = 0, effect_bundle_list:num_items() - 1 do
		local effect_bundle = effect_bundle_list:item_at(i)

		if effect_bundle:key() == bundle_key then
			return effect_bundle
		end
	end
end

function tiger_mercenaries:get_initiative_set_interface(initiative_set_key, faction)
	for _, initiative_set_model in model_pairs(faction:faction_initiative_sets()) do
		if initiative_set_model:record_key() == initiative_set_key then
			return initiative_set_model
		end
	end
	return nil
end

function tiger_mercenaries:handle_ritual_unlock(ritual_list_to_unlock, faction)
	if is_empty_table(ritual_list_to_unlock) then
		out.design("A tier has been defined without any rituals to unlock! Check progression_unlocks to ensure all defined tiers have rituals to unlock")
		return
	end

	for i = 1, #ritual_list_to_unlock do
		local ritual_key = ritual_list_to_unlock[i]
		local category_key = tiger_mercenaries:get_category_for_ritual(ritual_key)
		cm:unlock_ritual(faction, ritual_key)
		cm:set_script_state(faction, self.config.should_show_ui_notification_for_upgrade_key_prefix .. ritual_key, true)
		if not is_nil(category_key) then
			cm:set_script_state(faction, self.config.should_show_ui_notification_for_category_prefix .. category_key, true)
		end
	end
end

function tiger_mercenaries:any_ritual_completed(rituals, faction)
	for i = 1, #rituals do
		local ritual_key = rituals[i]
		if cco("CcoCampaignFaction", faction:name()):Call("RitualManagerContext.AvailableRitualList.FirstContext(RitualContext.Key == \"" .. ritual_key .. "\").IsComplete") then
			return true
		end
	end
	return false
end

function tiger_mercenaries:get_category_for_ritual(ritual_key)
	for category, rituals_by_tier in pairs(self.config.ritual_category_mapping) do
		if table.find(rituals_by_tier, ritual_key) ~= nil then
			return category
		end
	end
end

function tiger_mercenaries:handle_tier_unlock()
	local next_tier = self.dynamic_data.current_tier + 1
	if next_tier > #self.config.progression_unlocks then
		return
	end
	self.dynamic_data.current_tier = next_tier
	local next_tier_data = self.config.progression_unlocks[self.dynamic_data.current_tier]
	if next_tier_data then
		for i = 1, #next_tier_data.mission_keys do
			local next_mission_key = next_tier_data.mission_keys[i]
			if self.config.scripted_missions_setup[next_mission_key] then
				self:handle_scripted_mission_trigger(self.config.scripted_missions_setup[next_mission_key], next_mission_key, true)
			else
				cm:trigger_mission(self.config.faction_key, next_mission_key, true)
			end
		end
	end
end

function tiger_mercenaries:handle_units_unlock(unit_list_to_unlock)
	if is_nil(unit_list_to_unlock) or is_empty_table(unit_list_to_unlock) then
		return
	end

	for i = 1, #unit_list_to_unlock do
		local unit_key = unit_list_to_unlock[i]
		cm:remove_event_restricted_unit_record_for_faction(unit_key, self.config.faction_key)
	end
end

function tiger_mercenaries:handle_initiatives_activation(initiatives_list_to_enable)
	if not initiatives_list_to_enable or is_empty_table(initiatives_list_to_enable) then
		return
	end

	local faction = cm:get_faction(self.config.faction_key)

	for i = 1, #initiatives_list_to_enable do
		local initiative_key = initiatives_list_to_enable[i]
		local initiative_set = faction:lookup_faction_initiative_set_by_key(self.config.initiatives_to_activate[initiative_key].initiative_set)
		
		cm:toggle_initiative_active(initiative_set, initiative_key, true)
	end
end

function tiger_mercenaries:set_initiative_sets_lock_state(initiatives_sets, locked)
	if not initiatives_sets or is_empty_table(initiatives_sets) then
		return
	end

	local faction = cm:get_faction(self.config.faction_key)

	for i = 1, #initiatives_sets do
		local initiative_set = faction:lookup_faction_initiative_set_by_key(initiatives_sets[i])
		local initiatives_within_set = initiative_set:all_initiatives()
		for j = 0, initiatives_within_set:num_items() - 1 do
			local initiative = initiatives_within_set:item_at(j)
			cm:toggle_initiative_script_locked(initiative_set, initiative:record_key(), locked)
		end
	end
end

function tiger_mercenaries:is_zhao_mission(mission_setup_data, current_mission)
	local expected_missions = mission_setup_data.objective_mission_keys

	for i = 1, #expected_missions do
		if string.find(current_mission, expected_missions[i]) then
			return true
		end
	end

	return false
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("TigerMercenariesDynamicData", tiger_mercenaries.dynamic_data, context)
	end
)
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			tiger_mercenaries.dynamic_data = cm:load_named_value("TigerMercenariesDynamicData", tiger_mercenaries.dynamic_data, context)
			tiger_mercenaries.dynamic_data.current_tier = tiger_mercenaries.dynamic_data.current_tier or 1
			tiger_mercenaries.dynamic_data.cai_turn_to_unlock_next_tier = tiger_mercenaries.dynamic_data.cai_turn_to_unlock_next_tier or 1
		end
	end
)