vampire_bloodlines = {
	ui_unlock_requirement = {
		resource_key = "wh3_dlc29_vmp_power",
		amount = 500,
		culture_key = "wh_main_vmp_vampire_counts",
		shared_state_key = "vmp_bloodlines_unlocked",
	},
	bloodline_effect_bundles = {
		["wh2_dlc11_ritual_bloodlines_blood_dragon"] = "wh3_main_bundle_vmp_bloodline_blood_dragon",
		["wh2_dlc11_ritual_bloodlines_lahmian"] = "wh3_main_bundle_vmp_bloodline_lahmian",
		["wh2_dlc11_ritual_bloodlines_strigoi"] = "wh3_main_bundle_vmp_bloodline_strigoi",
		["wh2_dlc11_ritual_bloodlines_von_carstein"] = "wh3_main_bundle_vmp_bloodline_von_carstein",
		["wh2_dlc11_ritual_bloodlines_necrarch"] = "wh3_main_bundle_vmp_bloodline_necrarch",
	},
	bloodline_ritual_effects = {
		-- Blood Dragon
		{bloodline = "wh2_dlc11_ritual_bloodlines_blood_dragon", effect = "wh3_main_effect_bloodline_level_blood_dragon_dummy", scope = "faction_to_faction_own_unseen", value = 1},
		{bloodline = "wh2_dlc11_ritual_bloodlines_blood_dragon", effect = "wh3_unit_cap_vmp_cav_blood_knights", scope = "faction_to_faction_own_unseen", value = 1},
		{bloodline = "wh2_dlc11_ritual_bloodlines_blood_dragon", effect = "wh3_main_effect_weapon_strength_blood_dragon", scope = "faction_to_character_own_bloodline_blood_dragon", value = 1},
		{bloodline = "wh2_dlc11_ritual_bloodlines_blood_dragon", effect = "wh3_main_effect_hit_points_blood_dragon", scope = "faction_to_character_own_bloodline_blood_dragon", value = 1},
		{bloodline = "wh2_dlc11_ritual_bloodlines_blood_dragon", effect = "wh3_main_effect_melee_attack_blood_dragon", scope = "faction_to_character_own_bloodline_blood_dragon", value = 1},
		-- Lahmian
		{bloodline = "wh2_dlc11_ritual_bloodlines_lahmian", effect = "wh3_main_effect_bloodline_level_lahmian_dummy", scope = "faction_to_faction_own_unseen", value = 1},
		{bloodline = "wh2_dlc11_ritual_bloodlines_lahmian", effect = "wh3_unit_cap_vmp_inf_lahmian_handmaidens", scope = "faction_to_faction_own_unseen", value = 1},
		{bloodline = "wh2_dlc11_ritual_bloodlines_lahmian", effect = "wh_main_effect_agent_recruitment_xp_all_agents", scope = "faction_to_province_own_factionwide", value = 1},
		{bloodline = "wh2_dlc11_ritual_bloodlines_lahmian", effect = "wh3_main_effect_spell_mastery_lahmian", scope = "faction_to_character_own_bloodline_lahmian", value = 1},
		{bloodline = "wh2_dlc11_ritual_bloodlines_lahmian", effect = "wh3_main_effect_melee_defence_lahmian", scope = "faction_to_character_own_bloodline_lahmian", value = 1},
		{bloodline = "wh2_dlc11_ritual_bloodlines_lahmian", effect = "wh3_main_effect_speed_lahmian", scope = "faction_to_character_own_bloodline_lahmian", value = 1},
		-- Strigoi
		{bloodline = "wh2_dlc11_ritual_bloodlines_strigoi", effect = "wh3_main_effect_bloodline_level_strigoi_dummy", scope = "faction_to_faction_own_unseen", value = 1},
		{bloodline = "wh2_dlc11_ritual_bloodlines_strigoi", effect = "wh3_unit_cap_vmp_inf_crypt_ghouls", scope = "faction_to_faction_own_unseen", value = 2},
		{bloodline = "wh2_dlc11_ritual_bloodlines_strigoi", effect = "wh3_unit_cap_vmp_mon_crypt_horrors", scope = "faction_to_faction_own_unseen", value = 1},
		{bloodline = "wh2_dlc11_ritual_bloodlines_strigoi", effect = "wh3_main_effect_weapon_strength_strigoi", scope = "faction_to_character_own_bloodline_strigoi", value = 2},
		{bloodline = "wh2_dlc11_ritual_bloodlines_strigoi", effect = "wh3_main_effect_hit_points_strigoi", scope = "faction_to_character_own_bloodline_strigoi", value = 2},
		-- Von Carstein
		{bloodline = "wh2_dlc11_ritual_bloodlines_von_carstein", effect = "wh3_main_effect_bloodline_level_von_carstein_dummy", scope = "faction_to_faction_own_unseen", value = 1},
		{bloodline = "wh2_dlc11_ritual_bloodlines_von_carstein", effect = "wh3_dlc29_effect_unit_cap_vmp_range_sylvanian_units", scope = "faction_to_faction_own_unseen", value = 1},
		{bloodline = "wh2_dlc11_ritual_bloodlines_von_carstein", effect = "wh3_main_effect_spell_mastery_von_carstein", scope = "faction_to_character_own_bloodline_von_carstein", value = 1},
		{bloodline = "wh2_dlc11_ritual_bloodlines_von_carstein", effect = "wh3_main_effect_weapon_strength_von_carstein", scope = "faction_to_character_own_bloodline_von_carstein", value = 1},
		{bloodline = "wh2_dlc11_ritual_bloodlines_von_carstein", effect = "wh3_main_effect_hit_points_von_carstein", scope = "faction_to_character_own_bloodline_von_carstein", value = 1},
		-- Necrarch
		{bloodline = "wh2_dlc11_ritual_bloodlines_necrarch", effect = "wh3_main_effect_bloodline_level_necrarch_dummy", scope = "faction_to_faction_own_unseen", value = 1},
		{bloodline = "wh2_dlc11_ritual_bloodlines_necrarch", effect = "wh3_unit_cap_vmp_inf_cairn_wraiths", scope = "faction_to_faction_own_unseen", value = 1},
		{bloodline = "wh2_dlc11_ritual_bloodlines_necrarch", effect = "wh3_main_effect_magic_cost_necrarch", scope = "faction_to_character_own_bloodline_necrarch", value = -2},
		{bloodline = "wh2_dlc11_ritual_bloodlines_necrarch", effect = "wh3_main_effect_magic_cooldown_necrarch", scope = "faction_to_character_own_bloodline_necrarch", value = -2},
	},
	bloodline_mechanics = {
		{
			bloodline = "wh2_dlc11_ritual_bloodlines_strigoi",
			mechanics = {replenish_units = 20}
		},
		{
			bloodline = "wh2_dlc11_ritual_bloodlines_von_carstein",
			mechanics = {unit_xp = 1}
		},
		{
			bloodline = "wh2_dlc11_ritual_bloodlines_blood_dragon",
			mechanics = {lord_xp = 1000, hero_xp = 0}
		},
		{
			bloodline = "wh2_dlc11_ritual_bloodlines_lahmian",
			mechanics = {}
		},
		{
			bloodline = "wh2_dlc11_ritual_bloodlines_necrarch",
			mechanics = {research_points = 100}
		}
	},
	limit_power_objective_amount = 5,
	confederation_missions = {
		["wh3_dlc29_vmp_mission_confederate_lord_vlad_isabella"] = {
			target_faction = "wh_main_vmp_schwartzhafen",
			lord_subtype = "wh_dlc04_vmp_vlad_con_carstein",
			ritual_key = "wh3_dlc29_vmp_ritual_confederate_lord_vlad_isabella",
			limit_power_objective = true,
			payload = {
				"text_display dummy_confederate_lord_vlad_isabella"
			},
			post_payload_callback = function(self)
				local corresponding_mortarch_mission = vampire_bloodlines:find_corresponding_mortarch_mission(self.target_faction)
				cm:set_active_mission_status_for_faction(nag_mortarchs.config.faction_key, corresponding_mortarch_mission, "CANCELLED")
			end,
			unique_objectives_config = {
				vassal_count = 2,
				vassal_script_key = "wh3_dlc29_vmp_scripted_vlad_vassalize_factions",
				vassal_override_text = "mission_text_text_wh3_dlc29_vmp_vlad_vassalize_factions",

				technology_count = 7,
				technology_list = {
					"wh3_main_tech_vmp_vampires_final_1",
					"wh3_main_tech_vmp_vampires_final_2",
					"wh3_main_tech_vmp_vampires_final_3",
					"wh3_main_tech_vmp_vampires_final_4",
					"wh3_main_tech_vmp_vampires_final_5",
					"wh3_main_tech_vmp_vampires_lair_1",
					"wh3_main_tech_vmp_vampires_lair_2",
					"wh3_main_tech_vmp_vampires_lair_3",
					"wh3_main_tech_vmp_vampires_lair_4",
					"wh3_main_tech_vmp_vampires_lair_5",
					"wh3_main_tech_vmp_vampires_magic_1",
					"wh3_main_tech_vmp_vampires_magic_2",
					"wh3_main_tech_vmp_vampires_magic_3",
					"wh3_main_tech_vmp_vampires_magic_4",
					"wh3_main_tech_vmp_vampires_magic_5",
					"wh3_main_tech_vmp_vampires_main_1",
					"wh3_main_tech_vmp_vampires_main_2_a",
					"wh3_main_tech_vmp_vampires_main_2_b",
					"wh3_main_tech_vmp_vampires_main_2",
					"wh3_main_tech_vmp_vampires_main_3",
					"wh3_main_tech_vmp_vampires_main_4_a",
					"wh3_main_tech_vmp_vampires_main_4_b",
					"wh3_main_tech_vmp_vampires_main_4",
					"wh3_main_tech_vmp_vampires_main_5_a",
					"wh3_main_tech_vmp_vampires_main_5_b",
					"wh3_main_tech_vmp_vampires_main_5",
					"wh3_main_tech_vmp_vampires_walach_harkon_1",
					"wh3_main_tech_vmp_vampires_red_duke_1",
					"wh3_main_tech_vmp_vampires_unlock_1",
					"wh3_main_tech_vmp_vampires_unlock_2",
					"wh3_main_tech_vmp_vampires_unlock_3",
					"wh3_main_tech_vmp_vampires_unlock_4",
					"wh3_main_tech_vmp_vampires_unlock_5"
				},

				scripted_technology_key = "wh3_dlc29_vmp_scripted_vlad_vampirism_technologies",
				technology_override_text = "mission_text_text_wh3_dlc29_vmp_vlad_research_vampirism_technologies",
			},

			add_unique_objectives = function(faction_key, mm, mission_data, mission_key)
				local objective_data = mission_data.unique_objectives_config
				local faction = cm:get_faction(faction_key)

				local current_technology_count = math.min(
					vampire_bloodlines:count_researched_technologies_from_list(
						faction,
						objective_data.technology_list
					),
					objective_data.technology_count
				)

				local objectives = {
					generate_SCRIPTED_MISSION_objective(
						objective_data.vassal_script_key,
						objective_data.vassal_override_text,
						objective_data.vassal_count,
						0,
						true
					),

					generate_SCRIPTED_MISSION_objective(
						objective_data.scripted_technology_key,
						objective_data.technology_override_text,
						objective_data.technology_count,
						current_technology_count,
						true
					),
				}

				vampire_bloodlines:add_non_scripted_objectives(mm, objectives)
			end
		},
		["wh3_dlc29_vmp_mission_confederate_lord_mannfred"] = {
			target_faction = "wh_main_vmp_vampire_counts",
			lord_subtype = "wh_main_vmp_mannfred_von_carstein",
			ritual_key = "wh3_dlc29_vmp_ritual_confederate_lord_mannfred",
			limit_power_objective = true,
			payload = {
				"text_display dummy_confederate_lord_mannfred"
			},
			post_payload_callback = function(self)
				local corresponding_mortarch_mission = vampire_bloodlines:find_corresponding_mortarch_mission(self.target_faction)
				cm:set_active_mission_status_for_faction(nag_mortarchs.config.faction_key, corresponding_mortarch_mission, "CANCELLED")
			end,
			unique_objectives_config = {
				bloodline_lord_count = 3,
				bloodline_lord_script_key = "wh3_dlc29_vmp_scripted_mannfred_awaken_bloodline_lords",
				bloodline_lord_override_text = "mission_text_text_wh3_dlc29_vmp_mannfred_awaken_bloodline_lords",

				converted_province_count = 2,
				converted_province_script_key = "wh3_dlc29_vmp_scripted_mannfred_convert_provinces_to_vampiric_wasteland",
				converted_province_override_text = "mission_text_text_wh3_dlc29_vmp_mannfred_convert_provinces_to_vampiric_wasteland",
			},

			add_unique_objectives = function(faction_key, mm, mission_data, mission_key)
				local objective_data = mission_data.unique_objectives_config

				local objectives = {
					generate_SCRIPTED_MISSION_objective(
						objective_data.bloodline_lord_script_key,
						objective_data.bloodline_lord_override_text,
						objective_data.bloodline_lord_count,
						0,
						true
					),

					generate_SCRIPTED_MISSION_objective(
						objective_data.converted_province_script_key,
						objective_data.converted_province_override_text,
						objective_data.converted_province_count,
						0,
						true
					),
				}

				vampire_bloodlines:add_non_scripted_objectives(mm, objectives)
			end
		},
		["wh3_dlc29_vmp_mission_confederate_lord_kemmler"] = {
			target_faction = "wh2_dlc11_vmp_the_barrow_legion",
			ritual_key = "wh3_dlc29_vmp_ritual_confederate_lord_kemmler",
			lord_subtype = "wh_main_vmp_heinrich_kemmler",
			limit_power_objective = true,
			payload = {
				"text_display dummy_confederate_lord_kemmler"
			},
			post_payload_callback = function(self)
				-- Kemmler is a bit unique - he starts with Krell, but he is not a mortarch
				local corresponding_mortarch_mission = "wh3_dlc29_nag_mortarchs_krell"
				cm:set_active_mission_status_for_faction(nag_mortarchs.config.faction_key, corresponding_mortarch_mission, "CANCELLED")
			end,
			unique_objectives_config = {
				unit_count = 6,
				unit_rank = 7,
				unit_list = {
					"wh3_dlc29_vmp_inf_spirit_host",
					"wh_main_vmp_inf_cairn_wraiths",
					"wh_main_vmp_cav_hexwraiths",
					"wh2_dlc11_cst_mon_mournguls_0"
				},
				scripted_unit_key = "wh3_dlc29_vmp_scripted_kemmler_ranked_ethereal_units",
				unit_override_text = "mission_text_text_wh3_dlc29_vmp_kemmler_ranked_ethereal_units",

				pact_count = 2,
				scripted_diplomacy_key = "wh3_dlc29_vmp_scripted_kemmler_positive_pacts",
				positive_treaty_override_text = "mission_text_text_wh3_dlc29_vmp_kemmler_positive_pacts",
			},

			add_unique_objectives = function(faction_key, mm, mission_data, mission_key)
				local objective_data = mission_data.unique_objectives_config

				local objectives = {
					generate_SCRIPTED_MISSION_objective(
						objective_data.scripted_unit_key,
						objective_data.unit_override_text,
						objective_data.unit_count,
						0,
						false
					),

					generate_SCRIPTED_MISSION_objective(
						objective_data.scripted_diplomacy_key,
						objective_data.positive_treaty_override_text,
						objective_data.pact_count,
						0,
						false
					),
				}

				vampire_bloodlines:add_non_scripted_objectives(mm, objectives)
			end,

			post_trigger_callback = function(faction_key, mission_data, mission_key)
				vampire_bloodlines:update_kemmler_confederation_objectives(faction_key)
			end
		},
		["wh3_dlc29_vmp_mission_confederate_lord_ghorst"] = {
			target_faction = "wh3_main_vmp_caravan_of_blue_roses",
			lord_subtype = "wh_dlc04_vmp_helman_ghorst",
			ritual_key = "wh3_dlc29_vmp_ritual_confederate_lord_ghorst",
			limit_power_objective = true,
			payload = {
				"text_display dummy_confederate_lord_ghorst"
			},
			unique_objectives_config = {
				unit_count = 6,
				unit_rank = 7,
				unit_list = {
				"wh_main_vmp_inf_zombie",
				"wh_dlc04_vmp_veh_corpse_cart_0",
				"wh_dlc04_vmp_veh_corpse_cart_1",
				"wh_dlc04_vmp_veh_corpse_cart_2",
				"wh_dlc04_vmp_veh_mortis_engine_0"
			},
				scripted_unit_key = "wh3_dlc29_vmp_scripted_ghorst_ranked_corpse_carts",
				unit_override_text = "mission_text_text_wh3_dlc29_vmp_ghorst_ranked_corpse_carts",

				technology_count = 7,
				technology_list = {
					"wh3_main_tech_vmp_necromancers_0",
					"wh3_main_tech_vmp_necromancers_1",
					"wh3_main_tech_vmp_necromancers_2",
					"wh3_main_tech_vmp_necromancers_3",
					"wh3_main_tech_vmp_necromancers_4",
					"wh3_main_tech_vmp_necromancers_corpses_1",
					"wh3_main_tech_vmp_necromancers_corpses_2",
					"wh3_main_tech_vmp_necromancers_deadrise_1a",
					"wh3_main_tech_vmp_necromancers_deadrise_1b",
					"wh3_main_tech_vmp_necromancers_deadrise_2a",
					"wh3_main_tech_vmp_necromancers_deadrise_2b",
					"wh3_main_tech_vmp_necromancers_deadrise_3a",
					"wh3_main_tech_vmp_necromancers_deadrise_3b",
					"wh3_main_tech_vmp_necromancers_dieter_helnisnicht_1",
					"wh3_main_tech_vmp_necromancers_final_1",
					"wh3_main_tech_vmp_necromancers_final_2",
					"wh3_main_tech_vmp_necromancers_final_3",
					"wh3_main_tech_vmp_necromancers_final_4",
					"wh3_main_tech_vmp_necromancers_final_5",
					"wh3_main_tech_vmp_necromancers_misc_1",
					"wh3_main_tech_vmp_necromancers_misc_2",
					"wh3_main_tech_vmp_necromancers_misc_3",
					"wh3_main_tech_vmp_necromancers_misc_4",
					"wh3_main_tech_vmp_necromancers_misc_5",
					"wh3_main_tech_vmp_necromancers_misc_6",
					"wh3_main_tech_vmp_necromancers_misc_7",
					"wh3_main_tech_vmp_necromancers_misc_8",
					"wh3_main_tech_vmp_necromancers_misc_9",
					"wh3_main_tech_vmp_necromancers_misc_10",
					"wh3_main_tech_vmp_necromancers_misc_11"
				},
				scripted_technology_key = "wh3_dlc29_vmp_scripted_ghorst_necromancy_technologies",
				technology_override_text = "mission_text_text_wh3_dlc29_vmp_ghorst_research_necromancy_technologies",
			},

			add_unique_objectives = function(faction_key, mm, mission_data, mission_key)
				local objective_data = mission_data.unique_objectives_config
				local faction = cm:get_faction(faction_key)

				local current_technology_count = math.min(
					vampire_bloodlines:count_researched_technologies_from_list(
						faction,
						objective_data.technology_list
					),
					objective_data.technology_count
				)

				local objectives = {
					generate_SCRIPTED_MISSION_objective(
						objective_data.scripted_unit_key,
						objective_data.unit_override_text,
						objective_data.unit_count,
						0,
						false
					),

					generate_SCRIPTED_MISSION_objective(
						objective_data.scripted_technology_key,
						objective_data.technology_override_text,
						objective_data.technology_count,
						current_technology_count,
						true
					),
				}

				vampire_bloodlines:add_non_scripted_objectives(mm, objectives)
			end,

			post_trigger_callback = function(faction_key, mission_data, mission_key)
				vampire_bloodlines:update_ghorst_confederation_objectives(faction_key)
			end
		},
		["wh3_dlc29_vmp_mission_confederate_lord_neferata"] = {
			target_faction = "wh3_dlc29_vmp_neferata",
			lord_subtype = "wh3_dlc29_vmp_neferata",
			ritual_key = "wh3_dlc29_vmp_ritual_confederate_lord_neferata",
			limit_power_objective = true,
			payload = {
				"text_display dummy_confederate_lord_neferata"
			},
			post_payload_callback = function(self)
				local corresponding_mortarch_mission = vampire_bloodlines:find_corresponding_mortarch_mission(self.target_faction)
				cm:set_active_mission_status_for_faction(nag_mortarchs.config.faction_key, corresponding_mortarch_mission, "CANCELLED")
			end,

			unique_objectives_config = {
				agent_actions_count = 8,

				unit_count = 5,
				unit_rank = 7,
				unit_list = {
					"wh3_dlc29_vmp_inf_lahmian_handmaidens_death",
					"wh3_dlc29_vmp_inf_lahmian_handmaidens_shadow",
					"wh3_dlc29_vmp_veh_coven_throne"
				},
				scripted_unit_key = "wh3_dlc29_vmp_scripted_neferata_ranked_lahmian_units",
				unit_override_text = "mission_text_text_wh3_dlc29_vmp_neferata_ranked_lahmian_units",
			},

			add_unique_objectives = function(faction_key, mm, mission_data, mission_key)
				local objective_data = mission_data.unique_objectives_config

				local objectives = {
					generate_PERFORM_ANY_AGENT_ACTION_objective(
						objective_data.agent_actions_count
					),

					generate_SCRIPTED_MISSION_objective(
						objective_data.scripted_unit_key,
						objective_data.unit_override_text,
						objective_data.unit_count,
						0,
						false
					),
				}

				vampire_bloodlines:add_non_scripted_objectives(mm, objectives)
			end,

			post_trigger_callback = function(faction_key, mission_data, mission_key)
				vampire_bloodlines:update_neferata_confederation_objectives(faction_key)
			end
		},
	},
	confederation_rituals = {
		["wh3_dlc29_vmp_ritual_confederate_lord_ghorst"] = "wh3_main_vmp_caravan_of_blue_roses",
		["wh3_dlc29_vmp_ritual_confederate_lord_kemmler"] = "wh2_dlc11_vmp_the_barrow_legion",
		["wh3_dlc29_vmp_ritual_confederate_lord_mannfred"] = "wh_main_vmp_vampire_counts",
		["wh3_dlc29_vmp_ritual_confederate_lord_neferata"] = "wh3_dlc29_vmp_neferata",
		["wh3_dlc29_vmp_ritual_confederate_lord_vlad_isabella"] = "wh_main_vmp_schwartzhafen"
	},
	confederation_ritual_target_region_holder = "wh3_main_vmp_remnants",
}

function vampire_bloodlines:initialise()
	self:add_listeners()

	local human_vmp_factions = cm:get_human_factions_of_subculture("wh_main_sc_vmp_vampire_counts")

	if cm:is_new_game() == true then
		for faction_index = 1, #human_vmp_factions do
			local faction_key = human_vmp_factions[faction_index]
			out("Starting Vampire confederation missions for  " .. faction_key)
			self:setup_confederation_missions_for_faction(faction_key)
		end
	end
end

function vampire_bloodlines:setup_confederation_missions_for_faction(faction_key)
	for mission_key, mission_data in pairs(self.confederation_missions) do
		local target_faction_interface = cm:get_faction(mission_data.target_faction)
		if faction_key ~= mission_data.target_faction and not target_faction_interface:is_human() then
			local mm = mission_manager:new(faction_key, mission_key)
			mm:set_mission_issuer("CLAN_ELDERS")
			mm:set_all_objectives_are_primary(true)

			if mission_data.limit_power_objective then
				self:setup_limit_power_objective(mm, mission_data)
			end

			if mission_data.add_unique_objectives and is_function(mission_data.add_unique_objectives) then
				mission_data.add_unique_objectives(faction_key, mm, mission_data, mission_key)
			end
			
			-- Add mission objective to perform the confederation ritual.
			vampire_bloodlines:add_non_scripted_objectives(
				mm,
				{ generate_PERFORM_RITUAL_BY_KEY_LIST_objective({ mission_data.ritual_key }, 1) }
			)

			if mission_data.payload then
				for i = 1, #mission_data.payload do
					mm:add_payload(mission_data.payload[i])
				end
			end

			mm:add_condition("override_text mission_text_text_wh3_dlc29_vmp_vlad_confederate")

			mm:set_show_mission(false)
			mm:set_should_whitelist(false)
			mm:trigger()

			if mission_data.post_trigger_callback and is_function(mission_data.post_trigger_callback) then
				mission_data.post_trigger_callback(faction_key, mission_data, mission_key)
			end			
		end
	end
end

function vampire_bloodlines:setup_limit_power_objective(mm, mission_data)
	mm:add_new_objective("REDUCE_FACTION_TO_N_REGIONS")
	mm:add_condition("faction " .. mission_data.target_faction)
	mm:add_condition("total " .. tostring(self.limit_power_objective_amount))
end

function vampire_bloodlines:add_non_scripted_objectives(mm, objectives)
	for i = 1, #objectives do
		if objectives[i] and objectives[i].type ~= nil then
			mm:add_new_objective(objectives[i].type)
			for j = 1, #objectives[i].conditions do
				mm:add_condition(objectives[i].conditions[j])
			end
		end
	end
end

function vampire_bloodlines:count_researched_technologies_from_list(faction, technology_list)
	local count = 0

	for i = 1, #technology_list do
		if faction:has_technology(technology_list[i]) then
			count = count + 1
		end
	end

	return count
end

function vampire_bloodlines:count_units_from_list_with_min_rank(faction, unit_list, required_rank)
	local count = 0
	local military_force_list = faction:military_force_list()

	for i = 0, military_force_list:num_items() - 1 do
		local military_force = military_force_list:item_at(i)

		if military_force:has_general() and military_force:is_armed_citizenry() == false then
			local units = military_force:unit_list()

			for j = 0, units:num_items() - 1 do
				local unit = units:item_at(j)

				if table.contains(unit_list, unit:unit_key())
					and unit:experience_level() >= required_rank
				then
					count = count + 1
				end
			end
		end
	end

	return count
end

function vampire_bloodlines:faction_has_primary_settlement_level(faction, target_level)
	local regions = faction:region_list()
	for i = 0, regions:num_items() - 1 do
		local region = regions:item_at(i)
		local settlement = region:settlement()
		if settlement and settlement:is_null_interface() == false then
			local primary_slot = settlement:primary_slot()
			if primary_slot and primary_slot:is_null_interface() == false and primary_slot:has_building() then
				if primary_slot:building():building_level() >= target_level then
					return true
				end
			end
		end
	end

	return false
end

function vampire_bloodlines:is_kemmler_chaos_diplomacy_target(faction)
	if not faction or faction:is_null_interface() then
		return false
	end

	local chaos_subcultures = {
		["wh3_main_sc_dae_daemons"] = true,
		["wh3_main_sc_kho_khorne"] = true,
		["wh3_main_sc_nur_nurgle"] = true,
		["wh3_main_sc_sla_slaanesh"] = true,
		["wh3_main_sc_tze_tzeentch"] = true,
		["wh_dlc03_sc_bst_beastmen"] = true,
		["wh_dlc08_sc_nor_norsca"] = true,
		["wh_main_sc_chs_chaos"] = true,
	}

	return chaos_subcultures[faction:subculture()] == true
end

function vampire_bloodlines:get_current_positive_chaos_pact_factions(faction)
	local pact_factions = {}
	local factions = cm:model():world():faction_list()

	for i = 0, factions:num_items() - 1 do
		local other_faction = factions:item_at(i)

		if other_faction:is_dead() == false
			and self:is_kemmler_chaos_diplomacy_target(other_faction)
		then
			local is_vassal = other_faction:is_vassal()
				and other_faction:master():name() == faction:name()

			if faction:trade_agreement_with(other_faction)
				or faction:non_aggression_pact_with(other_faction)
				or faction:military_access_pact_with(other_faction)
				or faction:allied_with(other_faction)
				or is_vassal
			then
				table.insert(pact_factions, other_faction:name())
			end
		end
	end

	return pact_factions
end

function vampire_bloodlines:update_kemmler_confederation_objectives(faction_key)
	local mission_key = "wh3_dlc29_vmp_mission_confederate_lord_kemmler"
	local mission_data = self.confederation_missions[mission_key]
	local objective_data = mission_data.unique_objectives_config
	local faction = cm:get_faction(faction_key)

	if faction:is_null_interface() then
		return
	end

	-- Vet units

	local units_completed_saved_value_key = faction_key .. "_kemmler_confederation_ranked_units_completed"
	local units_completed = cm:get_saved_value(units_completed_saved_value_key) or false

	if not units_completed then
		local current_unit_count = math.min(
			self:count_units_from_list_with_min_rank(
				faction,
				objective_data.unit_list,
				objective_data.unit_rank
			),
			objective_data.unit_count
		)

		cm:set_scripted_mission_text(
			mission_key,
			objective_data.scripted_unit_key,
			objective_data.unit_override_text,
			current_unit_count,
			objective_data.unit_count
		)

		if current_unit_count >= objective_data.unit_count then
			cm:complete_scripted_mission_objective(
				faction_key,
				mission_key,
				objective_data.scripted_unit_key,
				true
			)

			cm:set_saved_value(
				units_completed_saved_value_key,
				true
			)
		end
	end

	-- Positive chaos pacts

	local pact_factions_saved_value_key = faction_key .. "_kemmler_confederation_positive_pact_factions"
	local pact_factions = cm:get_saved_value(pact_factions_saved_value_key) or {}

	if #pact_factions < objective_data.pact_count then
		local current_pact_factions = self:get_current_positive_chaos_pact_factions(faction)
		local pact_list_changed = false

		for i = 1, #current_pact_factions do
			local pact_faction_key = current_pact_factions[i]

			if not table.contains(pact_factions, pact_faction_key) then
				table.insert(pact_factions, pact_faction_key)
				pact_list_changed = true
			end
		end

		if pact_list_changed then
			cm:set_saved_value(
				pact_factions_saved_value_key,
				pact_factions
			)
		end

		local current_pact_count = math.min(
			#pact_factions,
			objective_data.pact_count
		)

		cm:set_scripted_mission_text(
			mission_key,
			objective_data.scripted_diplomacy_key,
			objective_data.positive_treaty_override_text,
			current_pact_count,
			objective_data.pact_count
		)

		if current_pact_count >= objective_data.pact_count then
			cm:complete_scripted_mission_objective(
				faction_key,
				mission_key,
				objective_data.scripted_diplomacy_key,
				true
			)
		end
	end
end

function vampire_bloodlines:update_ghorst_confederation_objectives(faction_key)
	local mission_key = "wh3_dlc29_vmp_mission_confederate_lord_ghorst"
	local mission_data = self.confederation_missions[mission_key]
	local objective_data = mission_data.unique_objectives_config
	local faction = cm:get_faction(faction_key)

	if faction:is_null_interface() then
		return
	end

	local units_completed_saved_value_key = faction_key .. "_ghorst_confederation_ranked_units_completed"
	local units_completed = cm:get_saved_value(units_completed_saved_value_key) or false

	if not units_completed then
		local current_unit_count = math.min(
			self:count_units_from_list_with_min_rank(
				faction,
				objective_data.unit_list,
				objective_data.unit_rank
			),
			objective_data.unit_count
		)

		cm:set_scripted_mission_text(
			mission_key,
			objective_data.scripted_unit_key,
			objective_data.unit_override_text,
			current_unit_count,
			objective_data.unit_count
		)

		if current_unit_count >= objective_data.unit_count then
			cm:complete_scripted_mission_objective(
				faction_key,
				mission_key,
				objective_data.scripted_unit_key,
				true
			)

			cm:set_saved_value(
				units_completed_saved_value_key,
				true
			)
		end
	end
end

function vampire_bloodlines:update_neferata_confederation_objectives(faction_key)
	local mission_key = "wh3_dlc29_vmp_mission_confederate_lord_neferata"
	local mission_data = self.confederation_missions[mission_key]
	local objective_data = mission_data.unique_objectives_config
	local faction = cm:get_faction(faction_key)

	if faction:is_null_interface() then
		return
	end

	local units_completed_saved_value_key = faction_key .. "_neferata_confederation_ranked_units_completed"
	local units_completed = cm:get_saved_value(units_completed_saved_value_key) or false

	if not units_completed then
		local current_unit_count = math.min(
			self:count_units_from_list_with_min_rank(
				faction,
				objective_data.unit_list,
				objective_data.unit_rank
			),
			objective_data.unit_count
		)

		cm:set_scripted_mission_text(
			mission_key,
			objective_data.scripted_unit_key,
			objective_data.unit_override_text,
			current_unit_count,
			objective_data.unit_count
		)

		if current_unit_count >= objective_data.unit_count then
			cm:complete_scripted_mission_objective(
				faction_key,
				mission_key,
				objective_data.scripted_unit_key,
				true
			)

			cm:set_saved_value(
				units_completed_saved_value_key,
				true
			)
		end
	end
end

function vampire_bloodlines:add_listeners()

-- Vlad / Isabella - Vassalize X different factions
	core:add_listener(
		"VampireBloodlinesVladVassalizeFaction",
		"FactionBecomesVassal",
		function(context)
			local mission_key = "wh3_dlc29_vmp_mission_confederate_lord_vlad_isabella"
			local mission_data = self.confederation_missions[mission_key]
			local objective_data = mission_data.unique_objectives_config
			local faction = context:vassal():master()
			local target_faction = cm:get_faction(mission_data.target_faction)

			if faction:is_human() == false
				or faction:subculture() ~= "wh_main_sc_vmp_vampire_counts"
				or faction:name() == mission_data.target_faction
				or target_faction:is_human()
			then
				return false
			end

			local saved_value_key = faction:name() .. "_vlad_confederation_vassalized_factions"
			local vassalized_factions = cm:get_saved_value(saved_value_key) or {}
			local vassal_key = context:vassal():name()

			return not table.contains(vassalized_factions, vassal_key)
				and #vassalized_factions < objective_data.vassal_count
		end,
		function(context)
			local mission_key = "wh3_dlc29_vmp_mission_confederate_lord_vlad_isabella"
			local objective_data = self.confederation_missions[mission_key].unique_objectives_config
			local faction = context:vassal():master()
			local vassal_key = context:vassal():name()

			local saved_value_key = faction:name() .. "_vlad_confederation_vassalized_factions"
			local vassalized_factions = cm:get_saved_value(saved_value_key) or {}

			if not table.contains(vassalized_factions, vassal_key) then
				table.insert(vassalized_factions, vassal_key)
				cm:set_saved_value(saved_value_key, vassalized_factions)

				cm:increase_scripted_mission_count(
					mission_key,
					objective_data.vassal_script_key,
					1
				)
			end
		end,
		true
	)
	-- Vlad / Isabella - Research X Vampirism technologies
	core:add_listener(
		"VampireBloodlinesVladResearchVampirismTechnology",
		"ResearchCompleted",
		function(context)
			local mission_key = "wh3_dlc29_vmp_mission_confederate_lord_vlad_isabella"
			local mission_data = self.confederation_missions[mission_key]
			local objective_data = mission_data.unique_objectives_config
			local faction = context:faction()
			local target_faction = cm:get_faction(mission_data.target_faction)

			if faction:is_human() == false
				or faction:subculture() ~= "wh_main_sc_vmp_vampire_counts"
				or faction:name() == mission_data.target_faction
				or target_faction:is_human()
			then
				return false
			end

			if not table.contains(objective_data.technology_list, context:technology()) then
				return false
			end

			local current_count = vampire_bloodlines:count_researched_technologies_from_list(
				faction,
				objective_data.technology_list
			)
			
			--We're deliberately checking with <=, as otherwise we get locked at 6/7
			return current_count <= objective_data.technology_count
		end,
		function(context)
			local mission_key = "wh3_dlc29_vmp_mission_confederate_lord_vlad_isabella"
			local objective_data = self.confederation_missions[mission_key].unique_objectives_config

			cm:increase_scripted_mission_count(
				mission_key,
				objective_data.scripted_technology_key,
				1
			)
		end,
		true
	)
	-- Awaken X Bloodline Lords for Mannfred's confederation
	core:add_listener(
		"VampireBloodlinesMannfredAwakenBloodlineLord",
		"ScriptEventVampireLairAwakened",
		function(context)
			local mission_key = "wh3_dlc29_vmp_mission_confederate_lord_mannfred"
			local mission_data = self.confederation_missions[mission_key]
			local objective_data = mission_data.unique_objectives_config
			local faction = context:faction()
			local target_faction = cm:get_faction(mission_data.target_faction)

			if faction:is_human() == false
				or faction:subculture() ~= "wh_main_sc_vmp_vampire_counts"
				or faction:name() == mission_data.target_faction
				or target_faction:is_human()
			then
				return false
			end

			local saved_value_key = faction:name() .. "_mannfred_confederation_awakened_bloodline_lords"
			local awakened_bloodline_lords = cm:get_saved_value(saved_value_key) or 0

			return awakened_bloodline_lords < objective_data.bloodline_lord_count
		end,
		function(context)
			local mission_key = "wh3_dlc29_vmp_mission_confederate_lord_mannfred"
			local objective_data = self.confederation_missions[mission_key].unique_objectives_config
			local faction_key = context:faction():name()

			local saved_value_key = faction_key .. "_mannfred_confederation_awakened_bloodline_lords"
			local awakened_bloodline_lords = cm:get_saved_value(saved_value_key) or 0

			if awakened_bloodline_lords < objective_data.bloodline_lord_count then
				awakened_bloodline_lords = awakened_bloodline_lords + 1
				cm:set_saved_value(saved_value_key, awakened_bloodline_lords)

				cm:increase_scripted_mission_count(
					mission_key,
					objective_data.bloodline_lord_script_key,
					1
				)
			end
		end,
		true
	)
	-- Convert X unique provinces to Undead Wasteland
	core:add_listener(
		"VampireBloodlinesMannfredConvertProvinceClimate",
		"SettlementClimateChanged",
		function(context)
			local mission_key = "wh3_dlc29_vmp_mission_confederate_lord_mannfred"
			local mission_data = self.confederation_missions[mission_key]
			local objective_data = mission_data.unique_objectives_config
			local garrison = context:garrison_residence()

			if garrison and not garrison:is_null_interface() then
				local faction = garrison:faction()
				local target_faction = cm:get_faction(mission_data.target_faction)

				if faction and not faction:is_null_interface() then
					if faction:is_human() == false
						or faction:subculture() ~= "wh_main_sc_vmp_vampire_counts"
						or faction:name() == mission_data.target_faction
						or target_faction:is_human()
						or context:new_climate_type() ~= "climate_vampiric"
					then
						return false
					end

					local faction_key = faction:name()
					local province_key = garrison:region():province_name()
					local saved_value_key = faction_key .. "_mannfred_confederation_converted_provinces"
					local converted_provinces = cm:get_saved_value(saved_value_key) or {}

					return #converted_provinces < objective_data.converted_province_count
						and not table.contains(converted_provinces, province_key)
				end
			end

			return false
		end,
		function(context)
			local mission_key = "wh3_dlc29_vmp_mission_confederate_lord_mannfred"
			local objective_data = self.confederation_missions[mission_key].unique_objectives_config
			local faction_key = context:garrison_residence():faction():name()
			local province_key = context:garrison_residence():region():province_name()

			local saved_value_key = faction_key .. "_mannfred_confederation_converted_provinces"
			local converted_provinces = cm:get_saved_value(saved_value_key) or {}

			if #converted_provinces < objective_data.converted_province_count
				and not table.contains(converted_provinces, province_key)
			then
				table.insert(converted_provinces, province_key)
				cm:set_saved_value(saved_value_key, converted_provinces)

				cm:increase_scripted_mission_count(
					mission_key,
					objective_data.converted_province_script_key,
					1
				)
			end
		end,
		true
	)
	-- Kemmler - objective helpers
	local function is_valid_kemmler_confederation_faction(faction)
		local mission_key = "wh3_dlc29_vmp_mission_confederate_lord_kemmler"
		local mission_data = self.confederation_missions[mission_key]
		local target_faction = cm:get_faction(mission_data.target_faction)

		return faction
			and not faction:is_null_interface()
			and faction:is_human()
			and faction:subculture() == "wh_main_sc_vmp_vampire_counts"
			and faction:name() ~= mission_data.target_faction
			and target_faction:is_human() == false
	end

	-- Kemmler - Update when a unit gains experience
	core:add_listener(
		"VampireBloodlinesKemmlerRankedUnit",
		"UnitExperienceLevelChanged",
		function(context)
			local mission_key = "wh3_dlc29_vmp_mission_confederate_lord_kemmler"
			local objective_data = self.confederation_missions[mission_key].unique_objectives_config
			local unit = context:unit()

			return is_valid_kemmler_confederation_faction(unit:faction())
				and table.contains(objective_data.unit_list, unit:unit_key())
				and context:previous_level() < objective_data.unit_rank
				and unit:experience_level() >= objective_data.unit_rank
		end,
		function(context)
			self:update_kemmler_confederation_objectives(
				context:unit():faction():name()
			)
		end,
		true
	)

	-- Kemmler - Update when a unit is created
	core:add_listener(
		"VampireBloodlinesKemmlerUnitCreated",
		"UnitCreated",
		function(context)
			local mission_key = "wh3_dlc29_vmp_mission_confederate_lord_kemmler"
			local objective_data = self.confederation_missions[mission_key].unique_objectives_config
			local unit = context:unit()

			return is_valid_kemmler_confederation_faction(unit:faction())
				and table.contains(objective_data.unit_list, unit:unit_key())
				and unit:experience_level() >= objective_data.unit_rank
		end,
		function(context)
			local faction_key = context:unit():faction():name()

			cm:callback(
				function()
					self:update_kemmler_confederation_objectives(faction_key)
				end,
				0.1
			)
		end,
		true
	)

	-- Kemmler - Update after diplomacy changes
	core:add_listener(
		"VampireBloodlinesKemmlerPositiveDiplomacy",
		"PositiveDiplomaticEvent",
		function(context)
			local proposer = context:proposer()
			local recipient = context:recipient()

			if is_valid_kemmler_confederation_faction(proposer) then
				return self:is_kemmler_chaos_diplomacy_target(recipient)
			elseif is_valid_kemmler_confederation_faction(recipient) then
				return self:is_kemmler_chaos_diplomacy_target(proposer)
			end

			return false
		end,
		function(context)
			local faction_key = nil

			if is_valid_kemmler_confederation_faction(context:proposer()) then
				faction_key = context:proposer():name()
			elseif is_valid_kemmler_confederation_faction(context:recipient()) then
				faction_key = context:recipient():name()
			end

			if faction_key then
				cm:callback(
					function()
						self:update_kemmler_confederation_objectives(faction_key)
					end,
					0.1
				)
			end
		end,
		true
	)
	-- Kemmler - Update after vassalizing an eligible faction
	core:add_listener(
		"VampireBloodlinesKemmlerVassalizeFaction",
		"FactionBecomesVassal",
		function(context)
			local master = context:vassal():master()
			local vassal = context:vassal()

			return is_valid_kemmler_confederation_faction(master)
				and self:is_kemmler_chaos_diplomacy_target(vassal)
		end,
		function(context)
			self:update_kemmler_confederation_objectives(
				context:vassal():master():name()
			)
		end,
		true
	)
	-- Kemmler - Fallback/state refresh for units
	core:add_listener(
		"VampireBloodlinesKemmlerTurnStartUpdate",
		"FactionTurnStart",
		function(context)
			return is_valid_kemmler_confederation_faction(context:faction())
		end,
		function(context)
			self:update_kemmler_confederation_objectives(
				context:faction():name()
			)
		end,
		true
	)
	-- Ghorst - objective helpers
	local function is_valid_ghorst_confederation_faction(faction)
		local mission_key = "wh3_dlc29_vmp_mission_confederate_lord_ghorst"
		local mission_data = self.confederation_missions[mission_key]
		local target_faction = cm:get_faction(mission_data.target_faction)

		return faction
			and not faction:is_null_interface()
			and faction:is_human()
			and faction:subculture() == "wh_main_sc_vmp_vampire_counts"
			and faction:name() ~= mission_data.target_faction
			and target_faction:is_human() == false
	end

	-- Ghorst - Update when a unit from his list gains experience
	core:add_listener(
		"VampireBloodlinesGhorstRankedUnit",
		"UnitExperienceLevelChanged",
		function(context)
			local mission_key = "wh3_dlc29_vmp_mission_confederate_lord_ghorst"
			local objective_data = self.confederation_missions[mission_key].unique_objectives_config
			local unit = context:unit()

			return is_valid_ghorst_confederation_faction(unit:faction())
				and table.contains(objective_data.unit_list, unit:unit_key())
				and context:previous_level() < objective_data.unit_rank
				and unit:experience_level() >= objective_data.unit_rank
		end,
		function(context)
			self:update_ghorst_confederation_objectives(
				context:unit():faction():name()
			)
		end,
		true
	)

	-- Ghorst - Update when a unit from his list is created
	core:add_listener(
		"VampireBloodlinesGhorstUnitCreated",
		"UnitCreated",
		function(context)
			local mission_key = "wh3_dlc29_vmp_mission_confederate_lord_ghorst"
			local objective_data = self.confederation_missions[mission_key].unique_objectives_config
			local unit = context:unit()

			return is_valid_ghorst_confederation_faction(unit:faction())
				and table.contains(objective_data.unit_list, unit:unit_key())
				and unit:experience_level() >= objective_data.unit_rank
		end,
		function(context)
			local faction_key = context:unit():faction():name()

			cm:callback(
				function()
					self:update_ghorst_confederation_objectives(faction_key)
				end,
				0.1
			)
		end,
		true
	)
	-- Ghorst - Research X Necromancy technologies
	core:add_listener(
		"VampireBloodlinesGhorstResearchNecromancyTechnology",
		"ResearchCompleted",
		function(context)
			local mission_key = "wh3_dlc29_vmp_mission_confederate_lord_ghorst"
			local mission_data = self.confederation_missions[mission_key]
			local objective_data = mission_data.unique_objectives_config
			local faction = context:faction()
			local target_faction = cm:get_faction(mission_data.target_faction)

			if faction:is_human() == false
				or faction:subculture() ~= "wh_main_sc_vmp_vampire_counts"
				or faction:name() == mission_data.target_faction
				or target_faction:is_human()
			then
				return false
			end

			if not table.contains(objective_data.technology_list, context:technology()) then
				return false
			end

			local current_count = self:count_researched_technologies_from_list(
				faction,
				objective_data.technology_list
			)

			--We're deliberately checking with <=, as otherwise we get locked at 6/7
			return current_count <= objective_data.technology_count
		end,
		function(context)
			local mission_key = "wh3_dlc29_vmp_mission_confederate_lord_ghorst"
			local objective_data = self.confederation_missions[mission_key].unique_objectives_config

			cm:increase_scripted_mission_count(
				mission_key,
				objective_data.scripted_technology_key,
				1
			)
		end,
		true
	)

	-- Ghorst - Fallback/state refresh for units
	core:add_listener(
		"VampireBloodlinesGhorstTurnStartUpdate",
		"FactionTurnStart",
		function(context)
			return is_valid_ghorst_confederation_faction(context:faction())
		end,
		function(context)
			self:update_ghorst_confederation_objectives(
				context:faction():name()
			)
		end,
		true
	)
	-- Neferata - objective helpers
	local function is_valid_neferata_confederation_faction(faction)
		local mission_key = "wh3_dlc29_vmp_mission_confederate_lord_neferata"
		local mission_data = self.confederation_missions[mission_key]
		local target_faction = cm:get_faction(mission_data.target_faction)

		return faction
			and not faction:is_null_interface()
			and faction:is_human()
			and faction:subculture() == "wh_main_sc_vmp_vampire_counts"
			and faction:name() ~= mission_data.target_faction
			and target_faction:is_human() == false
	end

	-- Neferata - Update when a unit from her list gains experience
	core:add_listener(
		"VampireBloodlinesNeferataRankedUnit",
		"UnitExperienceLevelChanged",
		function(context)
			local mission_key = "wh3_dlc29_vmp_mission_confederate_lord_neferata"
			local objective_data = self.confederation_missions[mission_key].unique_objectives_config
			local unit = context:unit()

			return is_valid_neferata_confederation_faction(unit:faction())
				and table.contains(objective_data.unit_list, unit:unit_key())
				and context:previous_level() < objective_data.unit_rank
				and unit:experience_level() >= objective_data.unit_rank
		end,
		function(context)
			self:update_neferata_confederation_objectives(
				context:unit():faction():name()
			)
		end,
		true
	)

	-- Neferata - Update when a unit from her list is created
	core:add_listener(
		"VampireBloodlinesNeferataUnitCreated",
		"UnitCreated",
		function(context)
			local mission_key = "wh3_dlc29_vmp_mission_confederate_lord_neferata"
			local objective_data = self.confederation_missions[mission_key].unique_objectives_config
			local unit = context:unit()

			return is_valid_neferata_confederation_faction(unit:faction())
				and table.contains(objective_data.unit_list, unit:unit_key())
				and unit:experience_level() >= objective_data.unit_rank
		end,
		function(context)
			local faction_key = context:unit():faction():name()

			cm:callback(
				function()
					self:update_neferata_confederation_objectives(faction_key)
				end,
				0.1
			)
		end,
		true
	)

	-- Neferata - Fallback/state refresh for units
	core:add_listener(
		"VampireBloodlinesNeferataTurnStartUpdate",
		"FactionTurnStart",
		function(context)
			return is_valid_neferata_confederation_faction(context:faction())
		end,
		function(context)
			self:update_neferata_confederation_objectives(
				context:faction():name()
			)
		end,
		true
	)
	core:add_listener(
		"RitualCompletedEventBloodlinesEffects",
		"RitualCompletedEvent",
		function(context)
			return context:ritual():ritual_category() == "BLOODLINE_RITUAL"
		end,
		function(context)
			local ritual = context:ritual()
			local ritual_key = ritual:ritual_key()
			local faction = context:performing_faction()

			local bloodline_effect_bundle = self.bloodline_effect_bundles[ritual_key]

			if bloodline_effect_bundle then
				local existing_effect_values = {}

				if faction:has_effect_bundle(bloodline_effect_bundle) then
					local existing_effect_bundle = faction:get_effect_bundle(bloodline_effect_bundle)
					local existing_effects = existing_effect_bundle:effects()

					for i = 0, existing_effects:num_items() - 1 do
						local existing_effect = existing_effects:item_at(i)
						existing_effect_values[existing_effect:key()] = existing_effect:value()
					end
					cm:remove_effect_bundle(bloodline_effect_bundle, faction:name())
				end

				local custom_effect_bundle = cm:create_new_custom_effect_bundle(bloodline_effect_bundle)
				custom_effect_bundle:set_duration(0)

				for _, bloodline_effect in ipairs(self.bloodline_ritual_effects) do
					if bloodline_effect.bloodline == ritual_key then
						local new_value = (existing_effect_values[bloodline_effect.effect] or 0) + bloodline_effect.value

						custom_effect_bundle:add_effect(bloodline_effect.effect, bloodline_effect.scope, new_value)
					end
				end
				cm:apply_custom_effect_bundle_to_faction(custom_effect_bundle, faction)
			end

			-- Custom behaviour that each bloodline does
			for _, bloodlines_mechanic in ipairs(self.bloodline_mechanics) do
				if ritual_key == bloodlines_mechanic.bloodline then
					if bloodlines_mechanic.mechanics.replenish_units then
						self:replenish_faction_units(faction, bloodlines_mechanic.mechanics.replenish_units)
					end
					if bloodlines_mechanic.mechanics.unit_xp then
						self:add_xp_to_all_units(faction, bloodlines_mechanic.mechanics.unit_xp)
					end
					if bloodlines_mechanic.mechanics.lord_xp or bloodlines_mechanic.mechanics.hero_xp then
						self:add_xp_to_all_characters(faction, bloodlines_mechanic.mechanics.lord_xp, bloodlines_mechanic.mechanics.hero_xp)
					end
					if bloodlines_mechanic.mechanics.research_points then
						self:grant_research_points(faction, bloodlines_mechanic.mechanics.research_points)
					end
					break
				end
			end
		end,
		true
	)
	core:add_listener(
		"ScriptEventVampireCovenCreatedBloodlines",
		"ScriptEventVampireCovenCreated",
		true,
		function(context)
			local neferata = context:character():faction()
			local region_cqi = context:region():cqi()
			local owner = context:region():owning_faction()

			if owner:has_home_region() == true and owner:subculture() == "wh_main_sc_vmp_vampire_counts" then
				local owners_capital_cqi = owner:home_region():cqi()

				if owners_capital_cqi == region_cqi then
					-- This is the owners capital, now check if they are the Vampires
					local owner_key = owner:name()

					for mission_key, mission_data in dpairs(self.confederation_missions) do
						if mission_data.target_faction == owner_key then
							cm:set_active_mission_status_for_faction(neferata, mission_key, "SUCCEEDED")
						end
					end
				end
			end
		end,
		true
	)
	core:add_listener(
		"RitualStartedEventBloodlines",
		"RitualStartedEvent",
		true,
		function(context)
			local faction = context:performing_faction()

			if faction:is_human() == true and faction:subculture() == "wh_main_sc_vmp_vampire_counts" then
				local ritual_key = context:ritual():ritual_key()

				if self.confederation_rituals[ritual_key] then
					local faction_key = faction:name()
					local confederated_faction_key = self.confederation_rituals[ritual_key]
					local confederated_faction = cm:model():world():faction_by_key(confederated_faction_key)

					if confederated_faction:is_null_interface() == false and confederated_faction:is_human() == false then
						if confederated_faction:is_dead() == false then
							local region_list = confederated_faction:region_list();
							local check_slot_sets = {vampire_lairs.lair_keys.owned, vampire_lairs.lair_keys.complete_owned}

							if faction_key == vampire_covens.neferata_faction then
								table.insert(check_slot_sets, vampire_covens.coven_key)
							end

							for _, region in model_pairs(region_list) do
								local has_foreign_slot = false
								
								for _, slot_set in ipairs(check_slot_sets) do
									local fsm = region:foreign_slot_manager_for_faction(faction_key, slot_set)

									if fsm:is_null_interface() == false then
										has_foreign_slot = true
										break
									end
								end

								if has_foreign_slot then
									cm:transfer_region_to_faction(region:name(), faction:name())
								end
							end
						end
					end
				end
			end
		end,
		true
	)
	core:add_listener(
		"RitualStartedEventVampireLords",
		"RitualStartedEvent",
		function(context)
			return context:ritual():ritual_category() == "VAMPIRE_RITUAL_LORDS"
		end,
		function(context)
			local ritual_target_faction = self.confederation_rituals[context:ritual():ritual_key()]
			if not ritual_target_faction then
				script_error("ERROR: RitualStartedEventVampireLords - Ritual started for Vampire Lords, but no target faction was found for ritual key [" .. context:ritual():ritual_key() .. "]")
				return
			end

			local from_faction = cm:get_faction(ritual_target_faction)
			local to_faction = context:performing_faction()

			if from_faction then
				local character_list = from_faction:character_list()
				local home_region = to_faction:home_region():name()

				for _, character in model_pairs(character_list) do
					if character:character_subtype("wh3_dlc29_vmp_krell")
					or character:character_subtype("wh_dlc04_vmp_vlad_von_carstein_hero")
					or character:character_subtype("wh_pro02_vmp_isabella_von_carstein_hero") 
					or character:character_subtype("wh3_dlc29_vmp_walach_harkon")
					or character:character_subtype("wh3_dlc29_vmp_dieter_helsnicht") then
						local x, y = cm:find_valid_spawn_location_for_character_from_settlement(to_faction:name(), home_region, false, true, 5)

						if x > 0 and y > 0 then
							local character_cqi = character:command_queue_index()
							cm:teleport_to("character_cqi:"..character_cqi, x, y)
						end
					end
				end
			end
		end,
		true
	)
	core:add_listener(
		"RitualCompletedEventVampireLords",
		"RitualCompletedEvent",
		function(context)
			return context:ritual():ritual_category() == "VAMPIRE_RITUAL_LORDS"
		end,
		function(context)
			local ritual_target_faction = self.confederation_rituals[context:ritual():ritual_key()]
			if not ritual_target_faction then
				script_error("ERROR: RitualCompletedEventVampireLords - Ritual completed for Vampire Lords, but no target faction was found for ritual key [" .. context:ritual():ritual_key() .. "]")
				return
			end

			cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "");
			cm:force_confederation(self.confederation_ritual_target_region_holder, ritual_target_faction)

			cm:callback(function()
				cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "")
			end, 0.2)
		end,
		true
	)
	-- post payload callback - mostly handles interaction with mortarchs
	core:add_listener(
		"nagash_mortarch_mission_completed",
		"MissionSucceeded",
		function(context)
			return self.confederation_missions[context:mission():mission_record_key()] ~= nil
		end,
		function(context)
			local mission_key = context:mission():mission_record_key()
			local mission_data = self.confederation_missions[mission_key]
			if mission_data.post_payload_callback and is_function(mission_data.post_payload_callback) then
				mission_data:post_payload_callback()
			end
			self:cancel_confederation_mission_for_other_human_vampires(mission_key, context:faction():name())
		end,
		true
	)

	-- Mirrors nag_mortarchs MissionUpdated ritual lock/unlock listener.
	core:add_listener(
		"vampire_bloodlines_confederation_mission_updated",
		"MissionUpdated",
		true,
		function(context)
			local mission_key = context:mission():mission_record_key()
			local mission_data = self.confederation_missions[mission_key]
			if not is_table(mission_data) then
				return
			end

			local remaining = context:total_primary_objectives() - context:completed_primary_objectives()
			local faction = context:faction()

			-- Could gate on ritual_status():script_locked() to avoid redundant lock/unlock calls.
			if remaining <= 1 then
				cm:unlock_ritual(faction, mission_data.ritual_key)
			else
				cm:lock_ritual(faction, mission_data.ritual_key)
			end
		end,
		true
	)
end

function vampire_bloodlines:add_xp_to_all_characters(faction, lord_amount, hero_amount)
	if faction:is_null_interface() == false then
		lord_amount = lord_amount or 0
		hero_amount = hero_amount or 0

		if lord_amount == 0 and hero_amount == 0 then
			return false
		end

		local character_list = faction:character_list()

		for i = 0, character_list:num_items() - 1 do
			local character = character_list:item_at(i)
			local char_lookup = cm:char_lookup_str(character)
			
			if lord_amount > 0 and (character:character_type("general") or character:character_type("colonel")) then
				-- Lord
				cm:add_agent_experience(char_lookup, lord_amount, false)
			elseif hero_amount > 0 then
				-- Hero
				cm:add_agent_experience(char_lookup, hero_amount, false)
			end
		end
	end
end

function vampire_bloodlines:add_xp_to_all_units(faction, amount)
	if faction:is_null_interface() == false then
		local military_force_list = faction:military_force_list()
		
		for i = 0, military_force_list:num_items() - 1 do
			local military_force = military_force_list:item_at(i)
			
			if military_force:has_general() == true and military_force:is_armed_citizenry() == false then
				local general = military_force:general_character()
				local char_lookup = cm:char_lookup_str(general)
				cm:add_experience_to_units_commanded_by_character(char_lookup, amount)
			end
		end
	end
end

function vampire_bloodlines:replenish_faction_units(faction, percentage_amount)
	if faction:is_null_interface() == false then
		local military_force_list = faction:military_force_list()
		
		for i = 0, military_force_list:num_items() - 1 do
			local military_force = military_force_list:item_at(i)
			local unit_list = military_force:unit_list()
			
			for j = 0, unit_list:num_items() - 1 do
				local unit = unit_list:item_at(j)
				local old_hp = unit:percentage_proportion_of_full_strength() / 100
				local new_hp = old_hp + (percentage_amount / 100)
				new_hp = math.min(1, new_hp)
				cm:set_unit_hp_to_unary_of_maximum(unit, new_hp)
			end
		end
	end
end

function vampire_bloodlines:grant_research_points(faction, amount)
	if faction:is_null_interface() == false then
		local faction_key = faction:name()
		cm:grant_research_points(faction_key, amount)
	end
end

function vampire_bloodlines:find_corresponding_mortarch_mission(target_faction)
	local corresponding_mortarch_mission = nil
	for mission_key, data in dpairs(nag_mortarchs.config.initial_missions) do
		if data.target_faction == target_faction then
			corresponding_mortarch_mission = mission_key
			break
		end
	end
	return corresponding_mortarch_mission
end

function vampire_bloodlines:cancel_confederation_mission_for_other_human_vampires(mission_key, completing_faction_key)
	local human_vmp_factions = cm:get_human_factions_of_subculture("wh_main_sc_vmp_vampire_counts")
	for i = 1, #human_vmp_factions do
		if human_vmp_factions[i] ~= completing_faction_key then
			cm:set_active_mission_status_for_faction(cm:get_faction(human_vmp_factions[i]), mission_key, "CANCELLED")
		end
	end
end