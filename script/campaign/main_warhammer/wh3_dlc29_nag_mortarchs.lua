nag_mortarchs_config = {
	faction_key = "wh3_dlc29_nag_host_of_nagash",
	shared_objective_occupation_key = "scripted_mis_wh3_dlc29_nag_mortarchs_occupation",
	shared_objective_discovery_key = "scripted_mis_faction_met",
	limit_power_objective_amount = 5,
	camera_pan_duration_on_subjugate = 5, -- the time it takes for the camera to pan to the newly subjugated mortarch after the panel closes, in seconds
	-- ensure AI gets an unlock every 40 turns if for some reason the conditions are not being met, this is a fallback to prevent the AI from never unlocking
	ai_unlock_turn_gap_fallback = 40, 

	building_lock_tooltip_prefix = "mortarch_building_lock_tooltip_",
	locked_buildings = {
		-- ritual / building key
		["wh3_dlc29_nag_mortarchs_walach"] = "wh3_dlc29_nag_necropolis_military_cavalry_5",
		["wh3_dlc29_nag_mortarchs_neferata"] = "wh3_dlc29_nag_necropolis_military_melee_5",
	},

	-- data required to perform rituals whose payloads might change based on world state.
	dynamic_ritual_data = {
		["wh3_dlc29_nag_mortarchs_arkhan"] = {agent = "wh2_dlc09_tmb_arkhan", general = true},
		["wh3_dlc29_nag_mortarchs_luthor"] = {agent = "wh2_dlc11_cst_harkon", general = true},
		["wh3_dlc29_nag_mortarchs_mannfred"] = {agent = "wh_main_vmp_mannfred_von_carstein", general = true},
		["wh3_dlc29_nag_mortarchs_neferata"] = {agent = "wh3_dlc29_vmp_neferata", general = true},
		["wh3_dlc29_nag_mortarchs_vlad"] = {agent = "wh_dlc04_vmp_vlad_con_carstein", general = true},
		["wh3_dlc29_nag_mortarchs_dieter"] = {agent = "wh3_dlc29_vmp_dieter_helsnicht", general = false},
		["wh3_dlc29_nag_mortarchs_krell"] = {agent = "wh3_dlc29_vmp_krell", general = false},
		["wh3_dlc29_nag_mortarchs_walach"] = {agent = "wh3_dlc29_vmp_walach_harkon", general = false},
		["wh3_dlc29_nag_mortarchs_nameless"] = {agent = nil, general = false, ancillary = "wh3_dlc29_anc_nag_follower_nameless_mortarch"},
	},

	unique_agent_ancillaries = {
		["wh3_dlc29_vmp_walach_harkon"] = {"wh3_dlc29_anc_enchanted_item_blood_dragon_standard", "wh3_dlc29_anc_weapon_crimson_blade"},
		["wh3_dlc29_vmp_dieter_helsnicht"] = {"wh3_dlc29_anc_arcane_item_staff_of_flaming_death"}
	},

	incidnet_keys = {
		["wh3_dlc29_nag_mortarchs_arkhan"] = "wh3_dlc29_nag_incident_mortarch_subjugated_arkhan",
		["wh3_dlc29_nag_mortarchs_luthor"] = "wh3_dlc29_nag_incident_mortarch_subjugated_luthor",
		["wh3_dlc29_nag_mortarchs_mannfred"] = "wh3_dlc29_nag_incident_mortarch_subjugated_mannfred",
		["wh3_dlc29_nag_mortarchs_neferata"] = "wh3_dlc29_nag_incident_mortarch_subjugated_neferata",
		["wh3_dlc29_nag_mortarchs_vlad"] = "wh3_dlc29_nag_incident_mortarch_subjugated_vlad",
		["wh3_dlc29_nag_mortarchs_dieter"] = "wh3_dlc29_nag_incident_mortarch_subjugated_dieter",
		["wh3_dlc29_nag_mortarchs_krell"] = "wh3_dlc29_nag_incident_mortarch_subjugated_krell",
		["wh3_dlc29_nag_mortarchs_walach"] = "wh3_dlc29_nag_incident_mortarch_subjugated_walach",
		["wh3_dlc29_nag_mortarchs_nameless"] = "wh3_dlc29_nag_incident_mortarch_subjugated_nameless",
	},

	vlad_ritual = {
		ritual = "wh3_dlc29_nag_mortarchs_vlad",
		isabella_agent = "wh_pro02_vmp_isabella_von_carstein_hero"
	},

	initial_missions = {
		["wh3_dlc29_nag_mortarchs_arkhan"] = {
			target_faction = "wh2_dlc09_tmb_followers_of_nagash",
			limit_power_objective = false,
			payload = "text_display dummy_wh3_dlc24_mission_schemes_reveal_shroud_payload",	-- Mandatory there is at least one payload, but it isn't shown in the UI.
			unique_objectives_config = {
				black_pyramid_objective_key = "scripted_mis_wh3_dlc29_nag_mortarchs_pyramid_of_nagash",
				unit_list = "wh3_dlc29_nag_tmb_unit_list",
				unit_threshold = 5,
				text_override = "wh3_dlc29_nag_mis_mortarchs_arkhan_recruit",
				valid_building_keys = {
					"wh3_dlc29_special_settlement_pyramid_of_nagash_nag_2",
					"wh3_dlc29_special_settlement_pyramid_of_nagash_nag_3",
					"wh3_dlc29_special_settlement_pyramid_of_nagash_nag_4",
					"wh3_dlc29_special_settlement_pyramid_of_nagash_nag_5",
				}
			},
			add_unique_objectives = function(faction_key, mm, mission_data, mission_key)

				local tmb_kings_units = cm:get_all_units_from_unit_list(mission_data.unit_list)
				local objectives = {
					generate_RECRUIT_N_UNITS_FROM_objective(tmb_kings_units, mission_data.unit_threshold, true, "mission_text_text_" .. mission_data.text_override)
				}

				-- Black Pyramid has reached T2
				mm:add_new_scripted_objective(
					"mission_text_text_" .. mission_data.black_pyramid_objective_key, 
					"BuildingCompleted", 
					function(context)
						local region = context:building():region()
						if region:owning_faction():name() == faction_key then 
							local building = context:building()
							for i = 1, #mission_data.valid_building_keys do 
								if building:name() == mission_data.valid_building_keys[i] then
									cm:complete_scripted_mission_objective(faction_key, mission_key, mission_data.black_pyramid_objective_key, true)
									return true
								end
							end
						end
						return false
					end,
					mission_data.black_pyramid_objective_key
				)

				nag_mortarchs:add_non_scripted_objectives(faction_key, mm, objectives)
			end,
			ai_unlock_conditions = function(self)
				local all_conditions_met = true
				if self.limit_power_objective then
					all_conditions_met = all_conditions_met and nag_mortarchs:check_for_occupation_mission_completion(cm:get_faction(self.target_faction), nag_mortarchs_config.limit_power_objective_amount)
			end
				-- construct necropolis
				local building_found = false
				local bp_region = cm:get_region("wh3_main_combi_region_black_pyramid_of_nagash")
				if bp_region:owning_faction():name() ~= nag_mortarchs_config.faction_key then
					-- if Nagash doesn't own the region this objective cannot be completed 
					return false
				end
				for i = 1, #self.unique_objectives_config.valid_building_keys do 
					if bp_region:building_exists(self.unique_objectives_config.valid_building_keys[i]) then
						building_found = true
						break
					end
				end
				all_conditions_met = all_conditions_met and building_found
				return all_conditions_met and cm:model():turn_number() > 5 -- precaution against early subjugation
			end
		},
		["wh3_dlc29_nag_mortarchs_luthor"] = {
			target_faction = "wh2_dlc11_cst_vampire_coast",
			limit_power_objective = true,
			payload = "text_display dummy_wh3_dlc24_mission_schemes_reveal_shroud_payload",	-- Mandatory there is at least one payload, but it isn't shown in the UI.
			unique_objectives_config = {
				unit_list = "wh3_dlc29_nag_cst_unit_list",
				unit_threshold = 12,
				text_override = "wh3_dlc29_nag_mis_mortarchs_luthor_recruit",
				region_list = {
					"wh3_main_combi_region_the_awakening"
				},
				region_threshold = 10
			},
			add_unique_objectives = function(faction_key, mm, mission_data, mission_key)
				local cst_units = cm:get_all_units_from_unit_list(mission_data.unit_list)
				local objectives = {
					generate_CONTROL_N_REGIONS_INCLUDING_objective(mission_data.region_list, 1),
					generate_OWN_N_PORTS_INCLUDING_objective({}, mission_data.region_threshold),
					generate_RECRUIT_N_UNITS_FROM_objective(cst_units, mission_data.unit_threshold, true, "mission_text_text_" .. mission_data.text_override),
				}

				nag_mortarchs:add_non_scripted_objectives(faction_key, mm, objectives)
			end,
			ai_unlock_conditions = function(self)
				local all_conditions_met = true
				if self.limit_power_objective then
					all_conditions_met = all_conditions_met and nag_mortarchs:check_for_occupation_mission_completion(cm:get_faction(self.target_faction), nag_mortarchs_config.limit_power_objective_amount)
			end
				-- control the awakenning region
				local awakening_region_owned = cm:get_region("wh3_main_combi_region_the_awakening"):owning_faction():name() == nag_mortarchs_config.faction_key
				if not awakening_region_owned then
					-- if Nagash doesn't own the region this objective cannot be completed 
					return false
				end
				all_conditions_met = all_conditions_met and awakening_region_owned
				-- control ports
				local ports_controlled = 0
				local region_list = cm:get_faction(nag_mortarchs_config.faction_key):region_list()
				for i = 0, region_list:num_items() - 1 do
					local region = region_list:item_at(i)
					if region:settlement():is_port() then
						ports_controlled = ports_controlled + 1
					end
				end
				all_conditions_met = all_conditions_met and ports_controlled >= 10 
				return all_conditions_met and cm:model():turn_number() > 10 -- precaution against early subjugation
			end
		},
		["wh3_dlc29_nag_mortarchs_mannfred"] = {
			target_faction = "wh_main_vmp_vampire_counts",
			limit_power_objective = true,
			payload = "text_display dummy_wh3_dlc24_mission_schemes_reveal_shroud_payload",	-- Mandatory there is at least one payload, but it isn't shown in the UI.
			post_payload_callback = function(self)
				local corresponding_vampire_mission = nag_mortarchs:find_corresponding_bloodlines_mission(self.target_faction)
				nag_mortarchs:cancel_corresponding_bloodlines_mission(corresponding_vampire_mission)
			end,
			unique_objectives_config = {
				books_threshold = 2,
				books_objective_key = "scripted_mis_wh3_dlc29_nag_mortarchs_books_of_nagash",
				objective_save_key = "nag_mortarchs_mannfred_books_objective",
				hidden_vault_key = {
					"wh3_dlc29_special_pyramid_of_nagash_nag_2"
				},
				hidden_vault_objective_key = "mis_construct_n_buidling_black_pyramid_of_nagash"
			},
			add_unique_objectives = function(faction_key, mm, mission_data, mission_key)
				local objective_count = cm:get_saved_value(mission_data.objective_save_key) or 0

				-- Collect X Books of Nagash
				mm:add_new_scripted_objective(
					"mission_text_text_" .. mission_data.books_objective_key,
					"ScriptEventBookOfNagashUpdated",
					function(context)
						if context.faction_data:name() == faction_key then 
							local objective_count = context.number
							cm:set_saved_value(mission_data.objective_save_key, objective_count)
							
							mm:update_scripted_objective_text(
									"mission_text_text_" .. mission_data.books_objective_key,
									objective_count,
									mission_data.books_threshold,
									mission_data.books_objective_key
								)

							if objective_count >= mission_data.books_threshold then 
								cm:complete_scripted_mission_objective(faction_key, mission_key, mission_data.books_objective_key, true)
								
								return true
							end
						end
						return false
					end,
					mission_data.books_objective_key
				)

				-- Callback required because this needs to be called after mm:trigger()
				cm:callback(
					function() 
						mm:update_scripted_objective_text(
							"mission_text_text_" .. mission_data.books_objective_key,
							objective_count,
							mission_data.books_threshold,
							mission_data.books_objective_key
						)
					end, 
					0.5
				)

				local objectives = {
					generate_CONSTRUCT_BUILDINGS_INCLUDING_objective(1, faction_key, mission_data.hidden_vault_key, nil, "mission_text_text_"..mission_data.hidden_vault_objective_key),
				}

				nag_mortarchs:add_non_scripted_objectives(faction_key, mm, objectives)
			end,
			ai_unlock_conditions = function(self)
				local all_conditions_met = true
				if self.limit_power_objective then
					all_conditions_met = all_conditions_met and nag_mortarchs:check_for_occupation_mission_completion(cm:get_faction(self.target_faction), nag_mortarchs_config.limit_power_objective_amount)
			end
				-- construct vault building
				local black_pyramid_region = cm:get_region("wh3_main_combi_region_black_pyramid_of_nagash")
				all_conditions_met = all_conditions_met and black_pyramid_region:owning_faction():name() == nag_mortarchs_config.faction_key and black_pyramid_region:building_exists(self.unique_objectives_config.hidden_vault_key[1])
				return all_conditions_met and cm:model():turn_number() > 10 -- precaution against early subjugation
			end
		},
		["wh3_dlc29_nag_mortarchs_neferata"] = {
			target_faction = "wh3_dlc29_vmp_neferata",
			limit_power_objective = true,
			payload = "text_display dummy_wh3_dlc24_mission_schemes_reveal_shroud_payload",	-- Mandatory there is at least one payload, but it isn't shown in the UI.
			post_payload_callback = function(self)
				local corresponding_vampire_mission = nag_mortarchs:find_corresponding_bloodlines_mission(self.target_faction)
				nag_mortarchs:cancel_corresponding_bloodlines_mission(corresponding_vampire_mission)
			end,
			unique_objectives_config = {
				unit_list = "wh3_dlc29_nag_vmp_unit_list",
				unit_threshold = 12,
				text_override = "wh3_dlc29_nag_mis_mortarchs_neferata_recruit",
				corruption_text_override = "mis_activity_have_at_least_x_pools_of_a_resource_larger_than_y_alt_text_corruption",
				corruption_key = "wh3_main_corruption_vampiric",
				corruption_threshold = 75, -- target corruption to each in each province
				province_threshold = 5, -- target provinces for objective completion. 
				corruption_objective_key = "scripted_mis_wh3_dlc29_nag_mortarchs_corruption",
				region_list = {
					"wh3_main_combi_region_silver_pinnacle",
				},
			},
			add_unique_objectives = function(faction_key, mm, mission_data, mission_key)

				local objectives = {
					generate_CONTROL_N_REGIONS_INCLUDING_objective(mission_data.region_list, 1)
				}
				nag_mortarchs:add_non_scripted_objectives(faction_key, mm, objectives)

				-- Control X provinces with over 75 vampiric corruption
				mm:add_new_objective("HAVE_AT_LEAST_X_POOLS_OF_A_RESOURCE_LARGER_THAN_Y")
				mm:add_condition("total " .. mission_data.province_threshold)
				mm:add_condition("total2 " .. mission_data.corruption_threshold)
				mm:add_condition("pooled_resource " .. mission_data.corruption_key)
				mm:add_condition("override_text mission_text_text_"..mission_data.corruption_text_override)

				-- Recruit X vampiric units
				local vmp_unit_list = cm:get_all_units_from_unit_list(mission_data.unit_list)
				local objectives = {
					generate_RECRUIT_N_UNITS_FROM_objective(vmp_unit_list, mission_data.unit_threshold, true, "mission_text_text_" .. mission_data.text_override),
				}

				nag_mortarchs:add_non_scripted_objectives(faction_key, mm, objectives)
			end,
			ai_unlock_conditions = function(self)
				local all_conditions_met = true
				if self.limit_power_objective then
					all_conditions_met = all_conditions_met and nag_mortarchs:check_for_occupation_mission_completion(cm:get_faction(self.target_faction), nag_mortarchs_config.limit_power_objective_amount)
			end
				-- corruption check, I am not in love with this approach but it is what it is
				local region_list = cm:get_faction(nag_mortarchs_config.faction_key):region_list()
				local seen_provinces = {}
				local num_provinces_meeting_corruption_threshold = 0 
				for i = 0, region_list:num_items() - 1 do
					local current_region = region_list:item_at(i)
					local current_region_province_name = current_region:province_name()
					if not seen_provinces[current_region_province_name] then
						seen_provinces[current_region_province_name] = true
						local corruption_value = cm:get_corruption_value_in_province(current_region:province(), self.unique_objectives_config.corruption_key)
						if corruption_value >= self.unique_objectives_config.corruption_threshold then
							num_provinces_meeting_corruption_threshold = num_provinces_meeting_corruption_threshold + 1
						end
					end
				end
				if num_provinces_meeting_corruption_threshold < self.unique_objectives_config.province_threshold then
					all_conditions_met = false
				end
				return all_conditions_met and cm:model():turn_number() > 20 -- precaution against early subjugation
			end
		},
		["wh3_dlc29_nag_mortarchs_vlad"] = {
			target_faction = "wh_main_vmp_schwartzhafen",
			limit_power_objective = true,
			payload = "text_display dummy_wh3_dlc24_mission_schemes_reveal_shroud_payload",	-- Mandatory there is at least one payload, but it isn't shown in the UI.
			post_payload_callback = function(self)
				local corresponding_vampire_mission = nag_mortarchs:find_corresponding_bloodlines_mission(self.target_faction)
				nag_mortarchs:cancel_corresponding_bloodlines_mission(corresponding_vampire_mission)
			end,
			unique_objectives_config = {
				empire_region_group = "wh3_dlc24_schemes_theatre_ie_the_empire",
				region_threshold = 15,
				empire_regions_objective_key = "scripted_mis_wh3_dlc29_nag_mortarchs_empire_regions",
				objective_save_key = "nag_mortarchs_vlad_empire_region_objective",
				agent_count = 5,
				agent_key = "dignitary",
				region_list = {
					"wh3_main_combi_region_castle_drakenhof",
					"wh3_main_combi_region_altdorf",
					"wh3_main_combi_region_nuln",
					"wh3_main_combi_region_middenheim"
				},
			},
			add_unique_objectives = function(faction_key, mm, mission_data, mission_key)

				local objectives = {
					generate_CONTROL_N_REGIONS_INCLUDING_objective(mission_data.region_list, 4),
					generate_RECRUIT_AGENT_objective(mission_data.agent_count, mission_data.agent_key, nil, nil),
				}
				nag_mortarchs:add_non_scripted_objectives(faction_key, mm, objectives)
			end,
			ai_unlock_conditions = function(self)
				local all_conditions_met = true
				if self.limit_power_objective then
					all_conditions_met = all_conditions_met and nag_mortarchs:check_for_occupation_mission_completion(cm:get_faction(self.target_faction), nag_mortarchs_config.limit_power_objective_amount)
			end
				local nag_faction = cm:get_faction(nag_mortarchs_config.faction_key)
				-- agents objective, not checking the current or historic amount, only cap - this makes more sense with how the AI budgets and recruits agents
				local agent_cap = nag_faction:agent_cap(self.unique_objectives_config.agent_key)
				all_conditions_met = all_conditions_met and (agent_cap >= self.unique_objectives_config.agent_count)
				-- control empire regions, objective is control so it needs to be current
				local region_list = nag_faction:region_list()
				local empire_regions_controlled = 0
				for i = 0, region_list:num_items() - 1 do
					local region = region_list:item_at(i)
					if region:is_contained_in_region_group(self.unique_objectives_config.empire_region_group) then
						empire_regions_controlled = empire_regions_controlled + 1
					end
				end
				-- requiring regions basically guarantees no early subjugaction so no need for a turn check here, unlike some of the other objectives
				all_conditions_met = all_conditions_met and (empire_regions_controlled >= self.unique_objectives_config.region_threshold)
				return all_conditions_met
			end
		},
		["wh3_dlc29_nag_mortarchs_walach"] = {
			payload = "text_display dummy_wh3_dlc24_mission_schemes_reveal_shroud_payload",	-- Mandatory there is at least one payload, but it isn't shown in the UI.
			corresponding_vampire_technology = "wh3_main_tech_vmp_vampires_walach_harkon_1",
			post_payload_callback = function(self)
				nag_mortarchs:toggle_technology_lock(self.corresponding_vampire_technology, true)
			end,
			unique_objectives_config = {
				bloodkeep_objective_key = "mis_construct_n_buidling_nuln",
				knight_recruit_objective_key = "mis_recruit_knight_units",
				unit_set = {
					"wh2_dlc09_tmb_cav_necropolis_knights_0",
					"wh2_dlc09_tmb_cav_necropolis_knights_1",
					"wh2_dlc09_tmb_cav_necropolis_knights_ror",
					"wh3_dlc29_vmp_cav_drakenhof_templars",
					"wh3_main_vmp_blood_knights_sword_shield",
					"wh_dlc02_vmp_cav_blood_knights_0",
					"wh_main_vmp_cav_black_knights_0",
					"wh_main_vmp_cav_black_knights_3"
				},
				threshold = 15,
				bloodkeep_key = {
					"wh3_dlc29_special_blood_keep_nag"
				}
			},
			add_unique_objectives = function(faction_key, mm, mission_data, mission_key) 
				local objectives = {
					generate_RECRUIT_N_UNITS_FROM_objective(mission_data.unit_set, mission_data.threshold, false, "mission_text_text_"..mission_data.knight_recruit_objective_key),
					generate_CONSTRUCT_BUILDINGS_INCLUDING_objective(1, faction_key, mission_data.bloodkeep_key, nil, "mission_text_text_"..mission_data.bloodkeep_objective_key)
				}
				nag_mortarchs:add_non_scripted_objectives(faction_key, mm, objectives)
			end,
			ai_unlock_conditions = function(self)
				-- landmark objective
				local nuln_region = cm:get_region("wh3_main_combi_region_nuln")
				return nuln_region:owning_faction():name() == nag_mortarchs_config.faction_key 
						and nuln_region:building_exists(self.unique_objectives_config.bloodkeep_key[1])
			end
		},
		["wh3_dlc29_nag_mortarchs_dieter"] = {
			payload = "text_display dummy_wh3_dlc24_mission_schemes_reveal_shroud_payload",	-- Mandatory there is at least one payload, but it isn't shown in the UI.
			corresponding_vampire_technology = "wh3_main_tech_vmp_necromancers_dieter_helnisnicht_1",
			post_payload_callback = function(self)
				nag_mortarchs:toggle_technology_lock(self.corresponding_vampire_technology, true)
			end,
			unique_objectives_config = {
				nagashizzar_objective_key = "scripted_mis_wh3_dlc29_nag_mortarchs_nagashizzar",
				tier_5_building_keys = {
					"wh3_dlc29_special_settlement_nagashizzar_nag_5",
				},
				units_threshold = 10,
				morghast_unit_list = {
					"wh3_dlc29_vmp_mon_morghast_archai",
					"wh3_dlc29_vmp_mon_morghast_archai_ror",
					"wh3_dlc29_vmp_mon_morghast_harbingers",
				},
			},
			add_unique_objectives = function(faction_key, mm, mission_data, mission_key) 
				-- Nagashizzar reach T3
				mm:add_new_scripted_objective(
					"mission_text_text_" .. mission_data.nagashizzar_objective_key, 
					"BuildingCompleted", 
					function(context)
						local region = context:building():region()
						if region:owning_faction():name() == faction_key then 
							local building = context:building()
							for i = 1, #mission_data.tier_5_building_keys do 
								if building:name() == mission_data.tier_5_building_keys[i] then 
									cm:complete_scripted_mission_objective(faction_key, mission_key, mission_data.nagashizzar_objective_key, true)
									return true
								end
							end
						end
						return false
					end,
					mission_data.nagashizzar_objective_key
				)

				-- Own X Morghast
				local objectives = {
					generate_OWN_N_UNITS_objective(mission_data.units_threshold, mission_data.morghast_unit_list)
				}
				nag_mortarchs:add_non_scripted_objectives(faction_key, mm, objectives)
			end,
			ai_unlock_conditions = function(self)
				-- construct tier 5 nagashizzar building
				local nagashizzar_region = cm:get_region("wh3_main_combi_region_nagashizzar")
				return nagashizzar_region:owning_faction():name() == nag_mortarchs_config.faction_key 
						and nagashizzar_region:building_exists(self.unique_objectives_config.tier_5_building_keys[1])
			end
		},
		["wh3_dlc29_nag_mortarchs_krell"] = {
			payload = "text_display dummy_wh3_dlc24_mission_schemes_reveal_shroud_payload",	-- Mandatory there is at least one payload, but it isn't shown in the UI.
			unique_objectives_config = {
				province_list = {
					"wh3_main_combi_province_northern_grey_mountains",
					"wh3_main_combi_province_southern_grey_mountains"
				},
				victory_count = 50,
			},
			add_unique_objectives = function(faction_key, mm, mission_data, mission_key) 
				local objectives = {
					generate_CONTROL_N_PROVINCES_INCLUDING_objective(mission_data.province_list, 1),
					generate_DEFEAT_N_ARMIES_OF_FACTION_objective(mission_data.victory_count, nil, nil)
				}

				nag_mortarchs:add_non_scripted_objectives(faction_key, mm, objectives)
				-- win a battle against subculture
			end,
			ai_unlock_conditions = function(self)
				-- specific provinces
				local all_conditions_met = true
				local nag_faction = cm:get_faction(nag_mortarchs_config.faction_key)
				for i=1,  #self.unique_objectives_config.province_list do 
					local province_interface = cm:get_province(self.unique_objectives_config.province_list[i])
					local region_list = province_interface:regions()
					for j = 0, region_list:num_items() - 1 do 
						local region = region_list:item_at(j)
						local owner = region:owning_faction()
						local controlled = (owner == nag_faction) or owner:is_ally_vassal_or_client_state_of(nag_faction)
						if not controlled then
							all_conditions_met = false
							break
						end
					end
			end
				return all_conditions_met and cm:model():turn_number() > 10 -- precaution against early subjugation
			end
		},
		["wh3_dlc29_nag_mortarchs_nameless"] = {
			payload = "text_display dummy_wh3_dlc24_mission_schemes_reveal_shroud_payload",	-- Mandatory there is at least one payload, but it isn't shown in the UI.
			unique_objectives_config = {
				target_level = 20,
				agent_subtype = "wh3_dlc29_nag_nagash",
				start_pos_id = "1767351587",
				sigil_count = 50,
				sigil_category = "DLC29_BLACK_PYRAMID",
				sigil_set_key = "wh3_dlc29_pyramid_initiative_set",
			},
			add_unique_objectives = function(faction_key, mm, mission_data, mission_key)
				local objectives = {
					generate_ACHIEVE_CHARACTER_RANK_objective(1, mission_data.target_level, nil, mission_data.agent_subtype, true, mission_data.start_pos_id)
				}

				nag_mortarchs:add_non_scripted_objectives(faction_key, mm, objectives)

				mm:add_new_objective("HAVE_AT_LEAST_X_ACTIVE_INITIATIVES")
				mm:add_condition("override_text mission_text_text_mis_active_mystic_sigils")
				mm:add_condition("total " .. mission_data.sigil_count)
				mm:add_condition("initiative_set_category "..mission_data.sigil_category)
			end,
			ai_unlock_conditions = function(self)
				local all_conditions_met = true
				local nag_faction = cm:get_faction(nag_mortarchs_config.faction_key)
				local nag_character = nag_faction:faction_leader()
				-- check character level
				all_conditions_met = all_conditions_met and (nag_character:rank() >= self.unique_objectives_config.target_level)
				-- check sigils
				local num_active_initiatives = nag_faction:lookup_faction_initiative_set_by_key(self.unique_objectives_config.sigil_set_key):active_initiatives():num_items()
				all_conditions_met = all_conditions_met and (num_active_initiatives >= self.unique_objectives_config.sigil_count)
				return all_conditions_met and cm:model():turn_number() > 10 -- precaution against early subjugation
			end
		},
	},
	ritual_keys = {
		"wh3_dlc29_nag_mortarchs_arkhan",
		"wh3_dlc29_nag_mortarchs_dieter",
		"wh3_dlc29_nag_mortarchs_krell",
		"wh3_dlc29_nag_mortarchs_luthor",
		"wh3_dlc29_nag_mortarchs_mannfred",
		"wh3_dlc29_nag_mortarchs_nameless",
		"wh3_dlc29_nag_mortarchs_neferata",
		"wh3_dlc29_nag_mortarchs_vlad",
		"wh3_dlc29_nag_mortarchs_walach",
	},

	-- Arkhan recruits zero-upkeep Tomb Kings copies of vampire units. When his faction confederates
	-- into Nagash, convert those fielded units to the normal vampire records (with ordinary upkeep).
	arkhan_faction_key = "wh2_dlc09_tmb_followers_of_nagash",
	arkhan_vampire_unit_conversions = {
		["wh2_dlc09_tmb_cav_hexwraiths"] = "wh_main_vmp_cav_hexwraiths",
		["wh2_dlc09_tmb_inf_cairn_wraiths"] = "wh_main_vmp_inf_cairn_wraiths",
		["wh2_dlc09_tmb_inf_crypt_ghouls"] = "wh_main_vmp_inf_crypt_ghouls",
		["wh2_dlc09_tmb_inf_spirit_host"] = "wh3_dlc29_vmp_inf_spirit_host",
		["wh2_dlc09_tmb_mon_crypt_horrors"] = "wh_main_vmp_mon_crypt_horrors",
		["wh2_dlc09_tmb_mon_dire_wolves"] = "wh_main_vmp_mon_dire_wolves",
		["wh2_dlc09_tmb_mon_fell_bats"] = "wh_main_vmp_mon_fell_bats",
		["wh2_dlc09_tmb_mon_morghast_archai"] = "wh3_dlc29_vmp_mon_morghast_archai",
		["wh2_dlc09_tmb_mon_morghast_harbingers"] = "wh3_dlc29_vmp_mon_morghast_harbingers",
	},

	-- When Nagash acquires a settlement by subjugating its owner, the settlement's main building
	-- is converted to one of Nagash's types depending on its original culture and whether it is a port.
	settlement_conversions = {
		wh_main_sc_vmp_vampire_counts = {
			land = {
				main_building_chain = "wh3_dlc29_nag_settlement_mausoleum",
				settlement_type = "wh3_dlc29_nag_mausoleum",
			},
			port = {
				main_building_chain = "wh3_dlc29_nag_settlement_cove",
				settlement_type = "wh3_dlc29_nag_cove",
			}
		},
		wh2_dlc11_sc_cst_vampire_coast = {
			land = {
				main_building_chain = "wh3_dlc29_nag_settlement_mausoleum",
				settlement_type = "wh3_dlc29_nag_mausoleum",
			},
			port = {
				main_building_chain = "wh3_dlc29_nag_settlement_cove",
				settlement_type = "wh3_dlc29_nag_cove",
			}
		},
		wh2_dlc09_sc_tmb_tomb_kings = {
			land = {
				main_building_chain = "wh3_dlc29_nag_settlement_chambers",
				settlement_type = "wh3_dlc29_nag_chambers",
			},
			port = {
				main_building_chain = "wh3_dlc29_nag_settlement_cove",
				settlement_type = "wh3_dlc29_nag_cove",
			}
		},
	},
}

nag_mortarchs = {}
nag_mortarchs.config = nag_mortarchs_config
nag_mortarchs.persistent = {
	last_ai_unlock_turn = 0,
}

function nag_mortarchs:initialise()
	out("#### Initialising Nagash Mortarch script ####")
	
	local nagash_interface = cm:get_faction(self.config.faction_key)
	if (not nagash_interface) or nagash_interface:is_null_interface() then 
		return
	end

	local nagash_is_human = nagash_interface:is_human()

	if nagash_is_human then 
		self:setup_initial_mortarch_missions()
	else
		for mission_key, data in dpairs(self.config.initial_missions) do
			-- Extra rules for AI:
			-- If the mortarch belongs to a human faction - never unlock.
			if data.target_faction then
				local target_faction_interface = cm:get_faction(data.target_faction)
				if target_faction_interface and not target_faction_interface:is_null_interface() and target_faction_interface:is_human() then
					self.persistent[mission_key] = true
				end
			end
			-- If Neferata is human - never unlock Vlad or Mannfred, otherwise narrative missions cannot be completed
			local neferata_faction_interface = cm:get_faction("wh3_dlc29_vmp_neferata")
			if neferata_faction_interface and not neferata_faction_interface:is_null_interface() and neferata_faction_interface:is_human() then
				if data.target_faction and (data.target_faction == "wh_main_vmp_schwartzhafen" or data.target_faction == "wh_main_vmp_vampire_counts") then
					self.persistent[mission_key] = true
				end
			end
			-- If there's a human Vampire in the game, vampire mortarchs are not allowed!
			local human_vmp_factions = cm:get_human_factions_of_subculture("wh_main_sc_vmp_vampire_counts")
			if not table.is_empty(human_vmp_factions) and (data.target_faction and (data.target_faction == "wh_main_vmp_schwartzhafen" or data.target_faction == "wh_main_vmp_vampire_counts" or data.target_faction == "wh3_dlc29_vmp_neferata")
				or mission_key == "wh3_dlc29_nag_mortarchs_krell" 
				or mission_key == "wh3_dlc29_nag_mortarchs_dieter" 
				or mission_key == "wh3_dlc29_nag_mortarchs_walach") then
				self.persistent[mission_key] = true
			end
		end

		core:add_listener(
			"nagash_mortarchs_ai_turn_start",
			"FactionTurnStart",
			function(context)
				return context:faction():name() == self.config.faction_key
			end,
			function(context)
				self:check_unlocks_for_ai()
			end,
			true
		)
	end

	if cm:is_new_game() then
		for i = 1, #self.config.ritual_keys do
			cm:lock_ritual(nagash_interface, self.config.ritual_keys[i])
		end
	end

	core:add_listener(
		"nagash_arkhan_convert_vampire_units_on_confederation",
		"FactionJoinsConfederation",
		function(context)
			return context:confederation():name() == self.config.faction_key and context:faction():name() == self.config.arkhan_faction_key
		end,
		function(context)
			self:convert_arkhan_vampire_units(context:confederation())
		end,
		true
	)

	core:add_listener(
		"nagash_subjugate_settlement_about_to_be_converted",
		"PreRegionFactionChangeEvent",
		function(context)
			return
				context:new_faction():name() == nag_mortarchs_config.faction_key and
				context:previous_faction():confederation_in_progress() and
				nag_mortarchs_config.settlement_conversions[context:previous_faction():subculture()] ~= nil
		end,
		function(context)
			-- Override the conversion of the main building and the settlement type according to the original culture
			-- of the settlement, and whether it's a port or not. Pass the building chain and settlement type keys via shared states.
			local region = context:region()
			local previous_owner = context:previous_faction()
			local previous_subculture = previous_owner:subculture()
			local is_port = region:settlement():is_port()
			local conversion_settings = is_port and nag_mortarchs_config.settlement_conversions[previous_subculture].port or nag_mortarchs_config.settlement_conversions[previous_subculture].land

			out("Nagash subjugation: converting main building of " .. region:name() .. " to " .. conversion_settings.main_building_chain .. " and setting settlement type to " .. conversion_settings.settlement_type)
			cm:set_script_state(region, "main_building_conversion_override", conversion_settings.main_building_chain)
			cm:set_script_state(region, "settlement_type_override", conversion_settings.settlement_type)
		end,
		true
	)

	core:add_listener(
		"nagash_subjugate_settlement_completed",
		"RegionFactionChangeEvent",
		function(context)
			local region = context:region()
			local new_faction = region:owning_faction()
			local previous_faction = context:previous_faction()
			return new_faction:name() == nag_mortarchs_config.faction_key and previous_faction:confederation_in_progress()
		end,
		function(context)
			local region = context:region()
			cm:remove_script_state(region, "main_building_conversion_override")
			cm:remove_script_state(region, "settlement_type_override")
		end,
		true
	)

	-- Building locks/unlocks
	core:add_listener(
		"GravecallInitialise",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == nag_mortarchs_config.faction_key and context:faction():is_human()
		end,
		function(context)
			for ritual, building in pairs(nag_mortarchs_config.locked_buildings) do
				cm:add_event_restricted_building_record_for_faction(building, nag_mortarchs_config.faction_key, nag_mortarchs_config.building_lock_tooltip_prefix..ritual)
			end
		end,
		false
	)

	core:add_listener(
		"nagash_subjugate_settlement_completed",
		"RitualCompletedEvent",
		function(context)
			return nag_mortarchs_config.locked_buildings[context:ritual():ritual_key()] ~= nil
		end,
		function(context)
			local building_key = nag_mortarchs_config.locked_buildings[context:ritual():ritual_key()]

			if building_key ~= nil then
				cm:remove_event_restricted_building_record_for_faction(building_key, nag_mortarchs_config.faction_key)
			end
		end,
		true
	)

	core:add_listener(
		"nagash_subjugate_ritual_completed",
		"RitualCompletedEvent",
		function(context)
			return nag_mortarchs_config.dynamic_ritual_data[context:ritual():ritual_key()] ~= nil
		end,
		function(context)
			local ritual_key = context:ritual():ritual_key()
			local data = nag_mortarchs_config.dynamic_ritual_data[ritual_key]
			local character_cqi_to_zoom_to = nil

			if data.agent ~= nil then
				cm:disable_event_feed_events(true, "", "wh_event_subcategory_agent_recruited", "")
				cm:callback(function() cm:disable_event_feed_events(false, "", "wh_event_subcategory_agent_recruited", "") end, 1)

				nag_mortarchs:spawn_character(data.agent, data.general)
				-- zoom to character
				character_cqi_to_zoom_to = self:get_character_cqi_to_zoom_to(data.agent, nil)
			elseif data.ancillary ~= nil then
				-- nameless - we have to zoom to the character that has this ancillary equipped
				local faction = context:performing_faction()
				local nagash = faction:faction_leader()

				if nagash:is_null_interface() == false and cm:char_is_mobile_general_with_army(nagash) then
					character_cqi_to_zoom_to = nagash:cqi()

					cm:force_add_ancillary(nagash, data.ancillary, false, false)
				else
					cm:add_ancillary_to_faction(faction, data.ancillary, false)
				end
			end

			cm:callback(
				function()
					-- Delay required as camera would pan to previous location if character is teleported to nagash without it
					if character_cqi_to_zoom_to ~= nil then
						cm:scroll_camera_to_character(nag_mortarchs_config.faction_key, character_cqi_to_zoom_to, nag_mortarchs_config.camera_pan_duration_on_subjugate)
					end

					cm:trigger_incident(self.config.faction_key, nag_mortarchs_config.incidnet_keys[ritual_key], true, false)
				end,
				0.5
			)
		end,
		true
	)

	core:add_listener(
		"nagash_heroes_subjugated",
		"UniqueAgentSpawned",
		function(context)
			local agent = context:unique_agent_details()
			local faction_key = agent:faction():name()
			return nag_mortarchs_config.unique_agent_ancillaries[agent:agent_subtype_key()] and faction_key == self.config.faction_key
		end,
		function(context)
			local agent = context:unique_agent_details()
			local character = agent:character()
			local items = nag_mortarchs_config.unique_agent_ancillaries[agent:agent_subtype_key()]

			for i = 1, #items do
				cm:force_add_ancillary(character, items[i], true, true)
			end
		end,
		true
	)

	core:add_listener(
		"nagash_vlad_subjugated",
		"RitualCompletedEvent",
		function(context)
			return nag_mortarchs_config.vlad_ritual.ritual == context:ritual():ritual_key() and context:succeeded()
		end,
		function(context)
			nag_mortarchs:spawn_character(nag_mortarchs_config.vlad_ritual.isabella_agent, false)
		end,
		true
	)

	-- post payload callback - mostly handles interaction with bloodlines
	core:add_listener(
		"nagash_mortarch_mission_completed",
		"MissionSucceeded",
		function(context)
			return self.config.initial_missions[context:mission():mission_record_key()] ~= nil and context:faction():name() == self.config.faction_key
		end,
		function(context)
			local mission_data = self.config.initial_missions[context:mission():mission_record_key()]
			if mission_data.post_payload_callback and is_function(mission_data.post_payload_callback) then
				mission_data:post_payload_callback()
			end
		end,
		true
	)

	-- Mirrors vampire_bloodlines MissionUpdated ritual lock/unlock listener.
	core:add_listener(
		"nagash_mortarch_mission_updated",
		"MissionUpdated",
		true,
		function(context)
			local mission_key = context:mission():mission_record_key()
			local mission_data = self.config.initial_missions[mission_key]
			if not is_table(mission_data) then
				return
			end

			-- For mortarchs ritual_key matches mission_key, but this is left to match the vampire counts config where there is a separate ritual key.
			local ritual_key = mission_data.ritual_key or mission_key
			local remaining = context:total_primary_objectives() - context:completed_primary_objectives()
			local faction = context:faction()
			if faction:name() ~= self.config.faction_key then	-- This check is pretty much redundant as only Nagash should have access to this mission.
				return
			end

			-- Could gate on ritual_status():script_locked() to avoid redundant lock/unlock calls.
			if remaining <= 1 then
				cm:unlock_ritual(faction, ritual_key)
			else
				cm:lock_ritual(faction, ritual_key)
			end
		end,
		true
	)

	core:add_listener(
		"nagash_died_unlock_vampire_technologies",
		"FactionDeath",
		function(context)
			return context:faction():name() == self.config.faction_key
		end,
		function(context)
			for mission_key, mission_data in dpairs(self.config.initial_missions) do
				if mission_data.corresponding_vampire_technology then
					nag_mortarchs:toggle_technology_lock(mission_data.corresponding_vampire_technology, false)
				end
			end
		end,
		true
	)

	core:add_listener(
		"nagash_missions_cancel_on_vampire_tech_completion",
		"ResearchCompleted",
		true,
		function(context)
			local corresponding_mission = nil
			for mission_key, mission_data in dpairs(self.config.initial_missions) do
				if mission_data.corresponding_vampire_technology and mission_data.corresponding_vampire_technology == context:technology() then
					corresponding_mission = mission_key
				end
			end
			if corresponding_mission then
				cm:set_active_mission_status_for_faction(cm:get_faction(self.config.faction_key), corresponding_mission, "CANCELLED")
			end
		end,
		true
	)
end

function nag_mortarchs:spawn_character(agent, general)
	local has_spawned, faction, cqi = self:is_mortarch_spawned(agent)
	local nagash_faction = cm:get_faction(nag_mortarchs_config.faction_key)
	local nagash_faction_cqi = nagash_faction:command_queue_index()

	if has_spawned then
		if faction:is_null_interface() == false and faction:is_human() == false then
			cm:reassign_character(cqi, nagash_faction_cqi)

			cm:callback(
				function()
					local nagash = nagash_faction:faction_leader()
					local nagash_capital = nagash_faction:home_region()

					if is_character(nagash) and nagash:is_wounded() == false then
						local x, y = cm:find_valid_spawn_location_for_character_from_character(nag_mortarchs_config.faction_key, cm:char_lookup_str(nagash), true, 5)
						local character = cm:get_character_by_cqi(cqi)
						local old_x = character:logical_position_x()
						local old_y = character:logical_position_y()
						local custom_start_char = cm:get_closest_character_to_position_from_faction(nag_mortarchs_config.faction_key, old_x, old_y, general, false)
								
						if x > -1 and custom_start_char then
							cm:teleport_to(cm:char_lookup_str(custom_start_char), x, y)
						end
					elseif is_region(nagash_capital) then
						local x, y = cm:find_valid_spawn_location_for_character_from_settlement(nag_mortarchs_config.faction_key, nagash_capital:name(), false, true, 5)
						local character = cm:get_character_by_cqi(cqi)
						local old_x = character:logical_position_x()
						local old_y = character:logical_position_y()
						local custom_start_char = cm:get_closest_character_to_position_from_faction(nag_mortarchs_config.faction_key, old_x, old_y, general, false)

						if x > -1 and custom_start_char then
							cm:teleport_to(cm:char_lookup_str(custom_start_char), x, y)
						end
					end
					if is_number(episode_nagash_endgame.persistent.current_stage_index)
						and is_table(episode_nagash_endgame.stages[episode_nagash_endgame.persistent.current_stage_index])
					then
						episode_nagash_endgame:on_nagash_taking_mortarch_character(cqi)
					end
				end,
				0.1
			)
		end
	elseif general == false then
		local nagash = nagash_faction:faction_leader()
		local nagash_capital = nagash_faction:home_region()
		local agent_character_cqi = nil

		if is_character(nagash) and nagash:is_wounded() == false then
			agent_character_cqi = cm:spawn_unique_agent_at_character(nagash_faction_cqi, agent, nagash:cqi(), true)	
		elseif is_region(nagash_capital) then
			agent_character_cqi = cm:spawn_unique_agent_at_region(nagash_faction_cqi, agent, nagash_capital:cqi(), true)
		end

		if is_number(agent_character_cqi)
			and is_number(episode_nagash_endgame.persistent.current_stage_index)
			and is_table(episode_nagash_endgame.stages[episode_nagash_endgame.persistent.current_stage_index])
		then
			episode_nagash_endgame:on_nagash_taking_mortarch_character(agent_character_cqi)
		end
	end
end

function nag_mortarchs:is_mortarch_spawned(agent_subtype)
	local factions = cm:model():world():faction_list()

	for i = 0, factions:num_items() - 1 do
		local faction = factions:item_at(i)
		local character_list = faction:character_list()

		for j = 0, character_list:num_items() - 1 do
			local character = character_list:item_at(j)
			if character:character_subtype_key() == agent_subtype then
				local cqi = character:cqi()
				return true, faction, cqi
			end
		end
	end

	return false, nil, nil
end

function nag_mortarchs:get_character_cqi_to_zoom_to(agent_subtype_key, ancillary_key)
	local nagash_faction_interface = cm:get_faction(nag_mortarchs_config.faction_key)
	local character_list = nagash_faction_interface:character_list()
	for j = 0, character_list:num_items() - 1 do
		local character = character_list:item_at(j)
		if agent_subtype_key ~= nil and character:character_subtype_key() == agent_subtype_key then
			return character:cqi()
		elseif ancillary_key ~= nil and character:has_ancillary(ancillary_key) then
			return character:cqi()
		end
	end
	return nil
end

function nag_mortarchs:setup_initial_mortarch_missions()
	for mission_key, mission_data in dpairs(self.config.initial_missions) do 
		local should_issue = false
		local target_faction_interface = mission_data.target_faction and cm:get_faction(mission_data.target_faction) or false
		-- case 1 - we have a target faction - check if human
		if target_faction_interface and not target_faction_interface:is_human() then
			should_issue = true
		end
		-- case 2 - we don't have a target faction, just issue the missions - Krell is handled explicitly in nagash_cancel_krell_conditional
		if not target_faction_interface then
			should_issue = true
		end

		local kemmler_faction = cm:get_faction("wh2_dlc11_vmp_the_barrow_legion")
		if mission_key == "wh3_dlc29_nag_mortarchs_krell" and kemmler_faction and kemmler_faction:is_null_interface() == false and kemmler_faction:is_human() then
			should_issue = false
		end

		if should_issue then

			local mm = mission_manager:new(self.config.faction_key, mission_key)
			mm:set_mission_issuer("CLAN_ELDERS")
			mm:set_all_objectives_are_primary(true)

			if mission_data.discover_objective then 
				nag_mortarchs:setup_discover_faction_objective(mm, mission_data)
			end

			if mission_data.limit_power_objective then
				nag_mortarchs:setup_limit_power_objective(mm, mission_data)
			end

			if mission_data.add_unique_objectives and is_function(mission_data.add_unique_objectives) then 
				mission_data.add_unique_objectives(self.config.faction_key, mm, mission_data.unique_objectives_config, mission_key)
			end

			-- Add mission objective to perform the subjugation ritual.
			local ritual_key = mission_data.ritual_key or mission_key
			nag_mortarchs:add_non_scripted_objectives(
				self.config.faction_key,
				mm,
				{ generate_PERFORM_RITUAL_BY_KEY_LIST_objective({ ritual_key }, 1) }
			)

			if mission_data.payload then
				mm:add_payload(mission_data.payload)
			end

			mm:set_show_mission(false)

			if cm:is_new_game() then
				cm:callback(
					function()
						mm:trigger()
					end,
					0.5
				)
			end
		end
	end
end

function nag_mortarchs:check_for_occupation_mission_completion(faction, threshold)
	if faction:region_list():num_items() < threshold then
		return true
	end

	return false
end

function nag_mortarchs:convert_arkhan_vampire_units(faction)
	local conversions = self.config.arkhan_vampire_unit_conversions
	local units_to_convert = {}
	local military_force_list = faction:military_force_list()

	-- Collect CQIs first: convert_unit deletes the old unit, so iterating the live unit_list while converting is unsafe.
	for i = 0, military_force_list:num_items() - 1 do
		local unit_list = military_force_list:item_at(i):unit_list()
		for j = 0, unit_list:num_items() - 1 do
			local unit = unit_list:item_at(j)
			local target_unit_key = conversions[unit:unit_key()]
			if target_unit_key then
				table.insert(units_to_convert, {
					cqi = unit:command_queue_index(),
					target_unit_key = target_unit_key,
				})
			end
		end
	end

	for _, entry in ipairs(units_to_convert) do
		cm:convert_unit(entry.cqi, entry.target_unit_key)
	end
end

function nag_mortarchs:add_non_scripted_objectives(faction_key, mm, objectives)

	for i = 1, #objectives do
		if objectives[i].type ~= nil then
			mm:add_new_objective(objectives[i].type)
			for j = 1, #objectives[i].conditions do
				mm:add_condition(objectives[i].conditions[j])
			end
		end
	end

end

function nag_mortarchs:setup_discover_faction_objective(mm, mission_data)
	mm:add_new_scripted_objective(
		"mission_text_text_"..self.config.shared_objective_discovery_key.."_"..mission_data.target_faction,
		"FactionEncountersOtherFaction", 
		function(context)
			if context:faction():name() == self.config.faction_key and context:other_faction():name() == mission_data.target_faction then 
				return true
			end
			return false
		end,
		self.config.shared_objective_discovery_key
	)

	mm:add_scripted_objective_success_condition(
		"FactionDeath", 
		function(context)
			if context:faction():name() == mission_data.target_faction then 
				return true
			end
			return false
		end, 
		self.config.shared_objective_discovery_key
	)
end

function nag_mortarchs:setup_limit_power_objective(mm, mission_data)
	mm:add_new_objective("REDUCE_FACTION_TO_N_REGIONS")
	mm:add_condition("faction " .. mission_data.target_faction)
	mm:add_condition("total " .. tonumber(self.config.limit_power_objective_amount))
end

function nag_mortarchs:unlock_rituals_for_ai(mission_key, mission_data)
	local turn_number = cm:model():turn_number()
	local nagash_faction = cm:get_faction(self.config.faction_key)
	cm:unlock_ritual(nagash_faction, mission_data.ritual_key or mission_key)
	self.persistent[mission_key] = true
	self.persistent.last_ai_unlock_turn = turn_number
end

function nag_mortarchs:check_unlocks_for_ai(force_unlock_all)
	local turn_number = cm:model():turn_number()
	for mission_key, data in dpairs(self.config.initial_missions) do
		local conditions_met = not self.persistent[mission_key] and data.ai_unlock_conditions and is_function(data.ai_unlock_conditions) and data:ai_unlock_conditions() or false
		if force_unlock_all or conditions_met then
			self:unlock_rituals_for_ai(mission_key, data)
			if not force_unlock_all then
				return -- one unlock per turn, matches GDS algo that does the ritual casting
			end
		end

	end
	if turn_number > 1 and (turn_number - self.persistent.last_ai_unlock_turn > self.config.ai_unlock_turn_gap_fallback) then
		-- pick random mission that hasn't been completed yet, this is not ideal but we need a fallback
		local available_missions = {}
		for mission_key, data in dpairs(self.config.initial_missions) do
			if not self.persistent[mission_key] then
				table.insert(available_missions, mission_key)
			end
		end
		if #available_missions == 0 then
			return
		end
		local random_mission = available_missions[cm:model():random_int(1, #available_missions)]
		self:unlock_rituals_for_ai(random_mission, self.config.initial_missions[random_mission])
		if not force_unlock_all then
			return -- one unlock per turn, matches GDS algo that does the ritual casting
		end
	end
end

function nag_mortarchs:find_corresponding_bloodlines_mission(target_faction)
	local corresponding_vampire_mission = nil
	for mission_key, data in dpairs(vampire_bloodlines.confederation_missions) do
		if data.target_faction == target_faction then
			corresponding_vampire_mission = mission_key
			break
		end
	end
	return corresponding_vampire_mission
end

function nag_mortarchs:cancel_corresponding_bloodlines_mission(corresponding_vampire_mission)
	if corresponding_vampire_mission then
		local human_vmp_factions = cm:get_human_factions_of_subculture("wh_main_sc_vmp_vampire_counts")
		for i = 1, #human_vmp_factions do
			cm:set_active_mission_status_for_faction(cm:get_faction(human_vmp_factions[i]), corresponding_vampire_mission, "CANCELLED")
		end
	end
end

function nag_mortarchs:toggle_technology_lock(technology_key, is_locked)
	local human_vmp_factions = cm:get_human_factions_of_subculture("wh_main_sc_vmp_vampire_counts")
	for i = 1, #human_vmp_factions do
		if is_locked then
			cm:lock_technology(human_vmp_factions[i], technology_key)
		else
			cm:unlock_technology(human_vmp_factions[i], technology_key)
		end
	end
end
--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("nag_mortarchs_persistent", nag_mortarchs.persistent, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		nag_mortarchs.persistent = cm:load_named_value("nag_mortarchs_persistent", nag_mortarchs.persistent, context)
	end
)