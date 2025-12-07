hef_intrigue_at_the_court = {
	config = {
		high_elf_culture_key = "wh2_main_hef_high_elves",
		patronage_slots_bonus_value_key = "hef_patronage_slots_available",
		favour_pooled_resource_key = "wh3_dlc27_hef_favour",
		patrons_of_ulthuan_mission_key = "wh3_dlc27_mission_hef_patrons_of_ulthuan",
		patrons_of_ulthuan_mission_key_turn = 5, 
		court_ritual_categories = {
			take_patronage = "HEF_COURT_ACTION_TAKE_PATRONAGE",
			increase_standing = "HEF_COURT_ACTION_INCREASE_STANDING",
			cede_patronage = "HEF_COURT_ACTION_CEDE_PATRONAGE",
			protect_patronage = "HEF_COURT_ACTION_PROTECT_PATRONAGE",
			threaten_patronage = "HEF_COURT_ACTION_THREATEN_PATRONAGE",
			tribute_to_the_court = "HEF_COURT_ACTION_TRIBUTE",
			court_unity = "HEF_COURT_ACTION_COURT_UNITY",
			swap_lord = "HEF_COURT_ACTION_SWAP_LORD",
		},
		positive_diplomatic_relations_change_step_key = "hef_court_positive_diplomatic_relations_change_step",
		favour_per_threshold = 1,
		high_elf_faction_list = {},
		favour_positive_diplomatic_attitude_toward_hef_factions_factor = "diplomacy_favour_hef",
		-- filled in by records from "patronage_slots" dave table in "load_patronage_slots_from_db" and used mostly to know what slots we have and what provinces they are in
		-- slot names correspond to the province they are located in
		patronage_slots = {
		--[[
			["wh3_main_combi_province_avelorn"] = {
				ranks = {
					1: {
						effect_bundle: "wh3_dlc27_hef_court_avelorn_patronage_1",
						key: "wh3_main_combi_province_avelorn1",
						rank: 1 
					},
					2: {
						effect_bundle: "wh3_dlc27_hef_court_avelorn_patronage_2",
						key: "wh3_main_combi_province_avelorn2",
						rank: 2 
					},
					3: {
						effect_bundle: "wh3_dlc27_hef_court_avelorn_patronage_3",
						key: "wh3_main_combi_province_avelorn3",
						rank: 3 
					}
				}	
			}
		]]
		},
		test = {
			take_patronage_ritual_key = "wh3_dlc27_hef_court_take_patronage",
			increase_standing_ritual_key = "wh3_dlc27_hef_court_increase_standing",
			cede_patronage_ritual_key = "wh3_dlc27_hef_court_cede_patronage",
			protect_patronage_ritual_key = "wh3_dlc27_hef_court_protect_patronage",
			threaten_patronage_ritual_key = "wh3_dlc27_hef_court_threaten_patronage",
		},
		favour_loss_config = {
			winning_vs_hef_config = {
				favour_loss_amount = -30,
				incident = "wh3_dlc27_incident_hef_favour_lost_against_hef"

			},
			losing_defensive_battles_config = {
				favour_loss_amount = -10,
				incident = "wh3_dlc27_incident_hef_favour_lost_battle_lost"
			},
			diplomacy_config = {
				subcultures = {
					"wh2_main_sc_def_dark_elves",
					"wh_main_sc_grn_greenskins",
					"wh_main_sc_grn_savage_orcs",
					"wh2_dlc11_sc_cst_vampire_coast",
					"wh2_main_sc_skv_skaven",
					"wh3_dlc23_sc_chd_chaos_dwarfs",
					"wh3_main_pro_sc_kho_khorne",
					"wh3_main_pro_sc_tze_tzeentch",
					"wh3_main_sc_dae_daemons",
					"wh3_main_sc_kho_khorne",
					"wh3_main_sc_nur_nurgle",
					"wh3_main_sc_sla_slaanesh",
					"wh3_main_sc_tze_tzeentch",
					"wh_dlc08_sc_nor_norsca",
					"wh_main_sc_chs_chaos",
				},
				favour_loss_amount = -20,
				incident = "wh3_dlc27_incident_hef_favour_lost_diplomacy",
				favour_positive_diplomacy_actions_toward_rival_subcultures_factor = "diplomacy_favour_rivals"
			},
		},
		max_favour_reduction_config = {
			effect_bundle_key = "wh3_dlc27_effect_bundle_hef_favour_resourse_max_mod",
			total_favour_blocked_effect_key = "wh3_dlc27_effect_hef_favour_resourse_max_mod",
			gate_settlements_favour_blocked_effect_key = "wh3_dlc27_effect_hef_favour_blocked_gate_settlement_dummy",
			major_settlements_favour_blocked_effect_key = "wh3_dlc27_effect_hef_favour_blocked_major_settlement_dummy",
			minor_settlements_favour_blocked_effect_key = "wh3_dlc27_effect_hef_favour_blocked_minor_settlement_dummy",
			major_settlement_reduction_amount = -45,
			minor_settlement_reduction_amount = -15,
			gate_settlement_reduction_amount = -30,
		},
		ulthuan_gate_region_keys = {
			"wh3_main_combi_region_griffon_gate",
			"wh3_main_combi_region_phoenix_gate",
			"wh3_main_combi_region_unicorn_gate",
			"wh3_main_combi_region_eagle_gate",
		},
		-- filled in by records from "patron_faction_to_associated_provinces" dave table in "load_patron_factions_to_associated_provinces"
		patron_faction_to_associated_provinces = {
		--[[
			["wh2_dlc15_hef_imrik"] = {
				associated_provinces = {
					1: 	wh3_main_combi_province_caledor,
					2: wh3_main_combi_province_tiranoc,
				}
			}
		]]
		},
		cai_variables = {
			chance_to_interact_with_court = 15,
			chance_to_steal_slot = 10,
		},
		starting_occupied_slots = {
			-- human factions get no slot except Tyrion, Alarielle and Eltharion
			["wh3_main_combi_province_eataine"] = {
				occupying_character_startpos_id = "1991761668", -- Tyrion
				assign_if_human = true,
			}, 
			["wh3_main_combi_province_northern_yvresse"] = {
				occupying_character_startpos_id = "1556373152", -- Eltharion
				assign_if_human = true, 
			}, 
			["wh3_main_combi_province_avelorn"] = {
				occupying_character_startpos_id = "1432265518", -- Alarielle
				assign_if_human = true,
			}, 
			["wh3_main_combi_province_saphery"] = {
				occupying_character_startpos_id = "1620402507", -- Teclis
			}, 
			["wh3_main_combi_province_caledor"] = {
				occupying_character_startpos_id = "917188678", -- Imrik 
			},
			["wh3_main_combi_province_tiranoc"] = {
				occupying_character_startpos_id = "1667718371", -- Alith Anar
			},
			["wh3_main_combi_province_cothique"] = {
				occupying_character_startpos_id = "2092142160", -- Aislinn
			}, 
			-- wh3_main_combi_province_chrace - empty slot
			-- wh3_main_combi_province_ellyrion - empty slot
		},
		diplomatic_penalty_amount_when_occupying_taken_slot = -2,
		threaten_event = {
			title = "event_feed_strings_text_wh3_dlc27_event_feed_string_patronage_threatened_title",
			primary_detail = "event_feed_strings_text_wh3_dlc27_event_feed_string_patronage_threatened_primary_detail",
			secondary_detail = "event_feed_strings_text_wh3_dlc27_event_feed_string_patronage_threatened_secondary_detail",
			is_persistent = true,
			campaign_group_member_criteria_value = 1951,
		},
		patronage_lost_event = {
			title = "event_feed_strings_text_wh3_dlc27_event_feed_string_patronage_lost_title",
			primary_detail = "event_feed_strings_text_wh3_dlc27_event_feed_string_patronage_lost_primary_detail",
			secondary_detail = "event_feed_strings_text_wh3_dlc27_event_feed_string_patronage_lost_secondary_detail",
			is_persistent = true,
			campaign_group_member_criteria_value = 1952,
		},
		protect_patronage_dilemma_current_target_province_key = "",
		protect_patronage_dilemmas_cooldown = 25,
		protect_patronage_dilemmas = {
			["wh3_dlc27_hef_intrigue_patronage_threatened_01"] = {
				choices = {
					["FIRST"] = {
						slot_action = "protect_patronage",
					},
					["SECOND"] = {
						slot_action = "protect_patronage",
					},
					["THIRD"] = {
						slot_action = "cede_patronage",
					},
				},
			},
			["wh3_dlc27_hef_intrigue_patronage_threatened_02"] = {
				choices = {
					["FIRST"] = {
						slot_action = "protect_patronage",
					},
					["SECOND"] = {
						slot_action = "protect_patronage",
					},
					["THIRD"] = {
						slot_action = "cede_patronage",
					},
				},
			},
			["wh3_dlc27_hef_intrigue_patronage_threatened_03"] = {
				choices = {
					["FIRST"] = {
						slot_action = "protect_patronage",
					},
					["SECOND"] = {
						slot_action = "cede_patronage",
					},
					["THIRD"] = {
						slot_action = "cede_patronage",
					},
				},
			},
			["wh3_dlc27_hef_intrigue_patronage_threatened_04"] = {
				choices = {
					["FIRST"] = {
						slot_action = "protect_patronage",
					},
					["SECOND"] = {
						slot_action = "protect_patronage",
					},
					["THIRD"] = {
						slot_action = "cede_patronage",
					},
				},
			},
			["wh3_dlc27_hef_intrigue_patronage_threatened_05"] = {
				choices = {
					["FIRST"] = {
						slot_action = "protect_patronage",
					},
					["SECOND"] = {
						slot_action = "protect_patronage",
					},
					["THIRD"] = {
						slot_action = "cede_patronage",	
					},
					["FOURTH"] = {
						slot_action = "cede_patronage",
					},
				},
			},
			["wh3_dlc27_hef_intrigue_patronage_threatened_06"] = {
				choices = {
					["FIRST"] = {
						slot_action = "protect_patronage",
					},
					["SECOND"] = {
						slot_action = "cede_patronage",
					},
					["THIRD"] = {
						slot_action = "cede_patronage",
					},
				},
			},
			["wh3_dlc27_hef_intrigue_patronage_threatened_07"] = {
				choices = {
					["FIRST"] = {
						slot_action = "protect_patronage",
					},
					["SECOND"] = {
						slot_action = "protect_patronage",
					},
					["THIRD"] = {
						slot_action = "cede_patronage",
					},
				},
			},
			["wh3_dlc27_hef_intrigue_patronage_threatened_08"] = {
				choices = {
					["FIRST"] = {
						slot_action = "protect_patronage",
					},
					["SECOND"] = {
						slot_action = "cede_patronage",
					},
					["THIRD"] = {
						slot_action = "cede_patronage",
					},
				},
			},
			["wh3_dlc27_hef_intrigue_patronage_threatened_09"] = {
				choices = {
					["FIRST"] = {
						slot_action = "protect_patronage",
					},
					["SECOND"] = {
						slot_action = "cede_patronage",
					},
					["THIRD"] = {
						slot_action = "cede_patronage",
					},
				},
			},
			["wh3_dlc27_hef_intrigue_patronage_threatened_10"] = {
				choices = {
					["FIRST"] = {
						slot_action = "protect_patronage",
					},
					["SECOND"] = {
						slot_action = "protect_patronage",
					},
					["THIRD"] = {
						slot_action = "cede_patronage",	
					},
					["FOURTH"] = {
						slot_action = "cede_patronage",
					},
				},
			},
		},
		confederation_requirements_config = {
			favour_active_effect_keys = {
				"wh3_dlc27_hef_favour_to_patronage_slots_1",
				"wh3_dlc27_hef_favour_to_patronage_slots_2",
				"wh3_dlc27_hef_favour_to_patronage_slots_3",
				"wh3_dlc27_hef_favour_to_patronage_slots_4",
				"wh3_dlc27_hef_favour_to_patronage_slots_5",
				"wh3_dlc27_hef_favour_to_patronage_slots_6",
				"wh3_dlc27_hef_favour_to_patronage_slots_7",
				"wh3_dlc27_hef_favour_to_patronage_slots_8",
				"wh3_dlc27_hef_favour_to_patronage_slots_9",
				"wh3_dlc27_hef_favour_to_patronage_slots_10",
			},
			initial_favour_tier_required_for_confederation = 5,
			favour_tier_increase_per_confederation = 1,
			aislinn_confederation_required_num_of_elven_colonies_campaign_var_key = "aislinn_required_num_elven_colonies_for_confederation",
			elven_colony_resource_key = "res_location_colony",
			aislinn_confederation_ritual_key = "wh3_dlc27_hef_court_unity_wh3_dlc27_hef_aislinn",
		},
		aislinn_faction_key = "wh3_dlc27_hef_aislinn",
		temporary_slot_immunity_duration_campaign_var_key = "hef_court_slot_temporary_immunity_duration",
		feature_unlock_turn = 5,
		feature_unlock_influence_minimum = 40,
		button_ui_override_key = "disable_intrigue_at_the_court_button",
		dev_force_unlock_feature = false,
	},
}

--------------------------------------------------------------
-------------------- INITIALISATION --------------------------
--------------------------------------------------------------

function hef_intrigue_at_the_court:initialise()
	self:load_patronage_slots_from_db()
	self:load_patron_factions_to_associated_provinces()
	self:set_max_rank_for_patronage_slots()
	self:update_favour_resource_maximum()
	self:populate_hef_factions()
	if cm:is_new_game() then
		self:set_locked_slots_at_game_start()
		self:set_starting_occupied_slots()
		self:set_initial_favour_tier_required_for_confederation_for_factions()
		self:setup_aislinn_confederation_requirements()
	end

	-- add listeners for patronage actions
	core:add_listener(
		"IntrigueAtTheCourt_CourtAction",
		"RitualCompletedEvent",
		function(context)
			local is_high_elf_faction = context:performing_faction():culture() == self.config.high_elf_culture_key
			local is_court_ritual_category = table.contains(self.config.court_ritual_categories, context:ritual():ritual_category())
			return is_high_elf_faction and is_court_ritual_category
		end,
		function(context)
			local ritual = context:ritual()
			local ritual_category = ritual:ritual_category()
			local ritual_target = ritual:ritual_target()
			local performing_faction_interface = context:performing_faction()

			local target_region_interface = ritual_target:get_target_region()
			local target_province_interface
			local slot_data

			if target_region_interface:is_null_interface() == false then
				target_province_interface = target_region_interface:province() -- we have one slot per province, so we use them to look up the slots
				slot_data = self.config.patronage_slots[target_province_interface:key()]
			end
			
			local characters_list = ritual:characters_who_performed()
			local performing_character_interface
			if characters_list:is_empty() == false then
				performing_character_interface = characters_list:item_at(0):character()
			end

			if ritual_category == self.config.court_ritual_categories.take_patronage then
				self:take_patronage_slot(performing_character_interface, target_province_interface, slot_data)
				if performing_faction_interface:active_missions(self.config.patrons_of_ulthuan_mission_key) then 
					cm:complete_scripted_mission_objective(performing_faction_interface:name(), self.config.patrons_of_ulthuan_mission_key, self.config.patrons_of_ulthuan_mission_key, true)
				end
			elseif ritual_category == self.config.court_ritual_categories.increase_standing then
				self:increase_slot_standing(performing_character_interface, target_province_interface, slot_data)
			elseif ritual_category == self.config.court_ritual_categories.cede_patronage then
				self:cede_patronage_slot(performing_character_interface, target_province_interface)
			elseif ritual_category == self.config.court_ritual_categories.threaten_patronage then
				self:threaten_patronage_slot(performing_character_interface, target_province_interface, slot_data)
			elseif ritual_category == self.config.court_ritual_categories.protect_patronage then
				if string.find(ritual:ritual_key(), "dilemma") then
					self:trigger_protect_patronage_dilemma(target_province_interface:key(), performing_faction_interface:name() )
				else
					self:protect_patronage_slot(target_province_interface)
				end
			elseif ritual_category == self.config.court_ritual_categories.tribute_to_the_court then
				self:clear_all_threatened_slots_for_faction(context:performing_faction():name())
			elseif ritual_category == self.config.court_ritual_categories.court_unity then
				self:increment_requirement_for_faction_to_perform_confederation(performing_faction_interface)
			elseif ritual_category == self.config.court_ritual_categories.swap_lord then
				self:swap_lord_for_patronage_slot(performing_character_interface, target_province_interface, slot_data)
			end
		end,
		true
	)

	core:add_listener(
		"IntrigueAtTheCourt_FactionTurnStart",
		"FactionTurnStart",
		function(context)
			local faction_interface = context:faction()
			return faction_interface:culture() == self.config.high_elf_culture_key
		end,
		function(context)
			local faction_interface = context:faction()
			self:clear_take_patronage_cooldown_for_faction(faction_interface)
			self:handle_threatened_slots_for_faction(faction_interface:name())
			self:progress_temporary_immunity_duration_for_faction(faction_interface:name())

			if cm:turn_number() == 1 then
				local slot_limit = cm:get_factions_bonus_value(faction_interface, self.config.patronage_slots_bonus_value_key)
				cm:set_script_state(faction_interface, "patronage_slots_occupied_limit", slot_limit)

				cm:override_ui(self.config.button_ui_override_key, true)
			end

			cm:callback(function() self:calculate_start_of_turn_favour_award(faction_interface) end, 0.2)

			self:try_unlock_feature_for_faction(faction_interface)
		end,
		true
	)

	core:add_listener(
		"IntrigueAtTheCourt_FactionTurnStart_CAI",
		"FactionTurnStart",
		function(context)
			local faction_interface = context:faction()
			return faction_interface:culture() == self.config.high_elf_culture_key and not faction_interface:is_human()
		end,
		function(context)
			local faction_interface = context:faction()
			if cm:model():random_percent(self.config.cai_variables.chance_to_interact_with_court) then
				self:cai_take_or_threaten_slot(faction_interface)
			end
		end,
		true
	)

	core:add_listener(
		"IntrigueAtTheCourt_RegionFactionChangeEvent",
		"RegionFactionChangeEvent",
		true,
		function(context)
			local region_interface = context:region()
			-- we don't handle region change event for gate regions cause they do not have associated patronage slots
			local is_patronage_slot_province = self.config.patronage_slots[region_interface:province_name()]
			if is_patronage_slot_province then
				self:handle_region_change_event(region_interface, context:previous_faction())
			end

			local region_key = region_interface:name()
			local is_ulthuan_gate_region = table.contains(self.config.ulthuan_gate_region_keys, region_key)
			if is_patronage_slot_province or is_ulthuan_gate_region then
				self:update_favour_resource_maximum()
			end

			if region_interface:resource_exists(self.config.confederation_requirements_config.elven_colony_resource_key) then
				local required_num_elven_colony_settlements = cm:campaign_var_int_value(self.config.confederation_requirements_config.aislinn_confederation_required_num_of_elven_colonies_campaign_var_key)

				local region_owning_faction_interface = region_interface:owning_faction()
				if region_owning_faction_interface:culture() == self.config.high_elf_culture_key then
					local current_num_of_elven_colony_settlements_for_faction = self:get_num_of_elven_colony_settlements_for_faction(region_owning_faction_interface)
					local incremented_num = current_num_of_elven_colony_settlements_for_faction + 1
					self:set_num_of_elven_colony_settlements_for_faction(region_owning_faction_interface, incremented_num)

					if incremented_num >= required_num_elven_colony_settlements then
						self:try_unlock_aislinn_confederation_ritual_for_faction(region_owning_faction_interface)
					end
				end

				local previous_owning_faction_interface = context:previous_faction()
				if previous_owning_faction_interface:is_null_interface() == false and previous_owning_faction_interface:culture() == self.config.high_elf_culture_key and previous_owning_faction_interface:name() ~= self.config.aislinn_faction_key then
					local current_num_of_elven_colony_settlements_for_faction = self:get_num_of_elven_colony_settlements_for_faction(previous_owning_faction_interface)
					local decremented_num = current_num_of_elven_colony_settlements_for_faction - 1
					self:set_num_of_elven_colony_settlements_for_faction(previous_owning_faction_interface, decremented_num)

					if decremented_num < required_num_elven_colony_settlements then
						self:lock_aislinn_confederation_ritual_for_faction(previous_owning_faction_interface)
					end
				end
			end
		end,
		true
	)

	-- check for characters that have actually died, not just wounded
	core:add_listener(
		"IntrigueAtTheCourt_CharacterConvalescedOrKilled",
		"CharacterConvalescedOrKilled", 
		function(context)
			local character = context:character()
			local is_general = character:character_type_key() == "general"
			local is_high_elf = character:faction():culture() == self.config.high_elf_culture_key
			return is_general and is_high_elf and character:is_alive() == false
		end,
		function(context)
			self:handle_lord_death_event(context:character():family_member():command_queue_index())
		end,
		true
	);

	-- Winning battles against high elves.
	core:add_listener(
		"IntrigueAtTheCourt_BattleConflictFinished",
		"BattleConflictFinished", 
		function(context)
			local pb = context:pending_battle()
			local attacker = pb:attacker()
			local defender = pb:defender()

			return attacker:faction():culture() == self.config.high_elf_culture_key and defender:faction():culture() == self.config.high_elf_culture_key and not pb:is_draw() and not defender:faction():name() == "wh2_main_hef_high_elves_rebels"
		end,
		function(context)
			local pb = context:pending_battle()
			local attacker_faction = pb:attacker():faction()
			local defender_faction = pb:defender():faction()
			local setup = self.config.favour_loss_config

			local winner = pb:attacker_won() and attacker_faction or defender_faction
			local winner_faction_key = winner:name()
			
			if winner:is_human() then
				local incident_payload = cm:create_payload()
				incident_payload:faction_pooled_resource_transaction(self.config.favour_pooled_resource_key, "battles", setup.winning_vs_hef_config.favour_loss_amount, false)

				cm:trigger_custom_incident(winner_faction_key, setup.winning_vs_hef_config.incident, true, incident_payload)
			else
				cm:faction_add_pooled_resource(winner_faction_key, self.config.favour_pooled_resource_key, "battles", setup.winning_vs_hef_config.favour_loss_amount)
			end

		end,
		true
	)

	-- losing defensive battles
	core:add_listener(
		"IntrigueAtTheCourt_BattleConflictFinished_Defender",
		"BattleConflictFinished", 
		function(context)
			local pb = context:pending_battle()
			local defender = pb:defender()

			return defender:faction():culture() == self.config.high_elf_culture_key and not pb:is_draw() and not pb:defender_won()
		end,
		function(context) 
			local defender_faction = context:pending_battle():defender():faction()
			local faction_key = defender_faction:name()
			local setup = self.config.favour_loss_config

			if defender_faction:is_human() then
				local incident_payload = cm:create_payload()
				incident_payload:faction_pooled_resource_transaction(self.config.favour_pooled_resource_key, "battles", setup.losing_defensive_battles_config.favour_loss_amount, false)

				cm:trigger_custom_incident(faction_key, setup.losing_defensive_battles_config.incident, true, incident_payload)
			else
				cm:faction_add_pooled_resource(faction_key, self.config.favour_pooled_resource_key, "battles", setup.losing_defensive_battles_config.favour_loss_amount)
			end

		end,
		true
	)

	core:add_listener(
		"IntrigueAtTheCourt_PositiveDiplomaticEvent",
		"PositiveDiplomaticEvent", 
		function(context)
			local proposer = context:proposer()
			local recipient = context:recipient()
			return proposer:culture() == self.config.high_elf_culture_key or recipient:culture() == self.config.high_elf_culture_key
		end,
		function(context)
			local setup = self.config.favour_loss_config
			local proposer = context:proposer()
			local recipient = context:recipient() 

			local high_elf 
			local other_faction

			if proposer:culture() == self.config.high_elf_culture_key then
				high_elf = proposer
				other_faction = recipient
			else
				high_elf = recipient
				other_faction = proposer
			end

			local found_faction_to_lose_favour_for = false
			for i, subculture in ipairs(setup.diplomacy_config.subcultures) do
				if other_faction:subculture() == subculture then
					found_faction_to_lose_favour_for = true
					break
				end
			end

			if found_faction_to_lose_favour_for then
				local faction_key = high_elf:name()
				if high_elf:is_human() then
					local incident_payload = cm:create_payload()
					incident_payload:faction_pooled_resource_transaction(self.config.favour_pooled_resource_key, setup.diplomacy_config.favour_positive_diplomacy_actions_toward_rival_subcultures_factor, setup.diplomacy_config.favour_loss_amount, false)
	
					cm:trigger_custom_incident(faction_key, setup.diplomacy_config.incident, true, incident_payload)
				else
					cm:faction_add_pooled_resource(faction_key, self.config.favour_pooled_resource_key, setup.diplomacy_config.favour_positive_diplomacy_actions_toward_rival_subcultures_factor, setup.diplomacy_config.favour_loss_amount)
				end
			end
		end,
		true
	)

	core:add_listener(
		"IntrigueAtTheCourt_PatronageSlotLimitChanged",
		"PooledResourceChanged",
		function(context) 
			return context:resource():key() == self.config.favour_pooled_resource_key
		end,
		function(context)
			-- the bonus value changes with pooled resource thresholds so we update the shared state value for it
			-- shared state is used so we can have easy access to this value in the UI
			local faction_interface = context:faction()
			local slot_limit = cm:get_factions_bonus_value(faction_interface, self.config.patronage_slots_bonus_value_key)
			cm:set_script_state(faction_interface, "patronage_slots_occupied_limit", slot_limit)
		end,
		true
	)

	core:add_listener(
		"IntrigueAtTheCourt_CharacterFactionChangeEvent",
		"CharacterFactionChangeEvent",
		true,
		function(context)
			local character = context:character()
			local previous_faction = character:family_member():previous_faction()

			if previous_faction:is_null_interface() or
				character:faction():is_null_interface() or 
				previous_faction:culture() ~= self.config.high_elf_culture_key or
				character:faction():culture() ~= self.config.high_elf_culture_key
			then
				return
			end

			self:handle_character_faction_change_event(character)
		end,
		true
	)

	core:add_listener(
		"IntrigueAtTheCourt_DilemmaChoiceMadeEvent",
		"DilemmaChoiceMadeEvent",
		true,
		function(context)
			local dilemma_key = context:dilemma()
			local choice_key = context:choice_key()

			local dilemma_config = self.config.protect_patronage_dilemmas[dilemma_key]
			if dilemma_config then
				local target_province_interface = cm:get_province(self.config.protect_patronage_dilemma_current_target_province_key)
				local choice_details = dilemma_config.choices[choice_key]
				if choice_details then
					if choice_details.slot_action == "protect_patronage" then
						self:protect_patronage_slot(target_province_interface)
					elseif choice_details.slot_action == "cede_patronage" then
						self:try_replace_character_in_threatened_slot(target_province_interface, self:get_slot_threatened_by_fm_cqi(target_province_interface), false)
					end
				end
			end
			self.config.protect_patronage_dilemma_current_target_province_key = ""
		end,
		true
	)

	core:add_listener(
		"IntrigueAtTheCourt_PooledResourceEffectChangedEvent",
		"PooledResourceEffectChangedEvent",
		function(context) 
			return context:resource():key() == self.config.favour_pooled_resource_key
		end,
		function(context)
			local faction_interface = context:faction()
			local old_effect_index = table.contains(self.config.confederation_requirements_config.favour_active_effect_keys, context:old_effect())
			local new_effect_index = table.contains(self.config.confederation_requirements_config.favour_active_effect_keys, context:new_effect())
			local favour_tier_required = self:get_required_favour_tier_for_faction_to_perform_confederation(faction_interface)
			if old_effect_index < favour_tier_required and new_effect_index >= favour_tier_required then
				self:set_faction_has_required_favour_tier_to_perform_confederation(faction_interface, true)
				self:try_unlock_confederation_rituals_for_faction(faction_interface)
				if faction_interface:name() ~= self.config.aislinn_faction_key then
					self:try_unlock_aislinn_confederation_ritual_for_faction(faction_interface)
				end
			elseif new_effect_index < favour_tier_required and old_effect_index >= favour_tier_required then
				self:set_faction_has_required_favour_tier_to_perform_confederation(faction_interface, false)
				self:lock_confederation_rituals_for_faction(faction_interface)
				if faction_interface:name() ~= self.config.aislinn_faction_key then
					self:lock_aislinn_confederation_ritual_for_faction(faction_interface)
				end
			end
		end,
		true
	)

	core:add_listener(
		"IntrigueAtTheCourt_CheatListener",
		"ContextTriggerEvent",
		true,
		function(context)
			if not context.string:starts_with("court_cheat") then
				return
			end

			local params = context.string:split(":")
			local cheat = params[2]
			if cheat == "grant_immunity" then
				local province_key = params[3]
				local province_interface = cm:get_province(province_key)
				if province_interface and province_interface:is_null_interface() == false then
					local temporary_immunity_duration = cm:campaign_var_int_value(self.config.temporary_slot_immunity_duration_campaign_var_key)
					self:set_temporary_immunity_duration_for_slot(province_interface, temporary_immunity_duration)
				end
			elseif cheat == "force_unlock" then
				self.config.dev_force_unlock_feature = true
				self:try_unlock_feature_for_faction(cm:get_local_faction())
			end
		end,
		true
	)

	core:add_listener(
		"Patrons_of_Ulthuan_Mission",
		"FactionTurnStart",
		function(context)
			local faction_interface = context:faction()
			return faction_interface:culture() == self.config.high_elf_culture_key and faction_interface:is_human()
		end,
		function(context)			
			local turn = cm:model():turn_number();
			local faction_key = context:faction():name()
			if turn == self.config.patrons_of_ulthuan_mission_key_turn then 
				hef_intrigue_at_the_court:patrons_of_ulhuan_mission(faction_key)
			end 
		end,
		true
	)

	core:add_listener(
		"IntrigueAtTheCourt_InfluenceChangedEvent",
		"InfluenceChangedEvent",
		true,
		function(context)
			local amount_changed = context:amount()
			if amount_changed < 0 then
				return
			end

			self:try_unlock_feature_for_faction(context:faction())
		end,
		true
	)
end

function hef_intrigue_at_the_court:populate_hef_factions()
	local faction_list = cm:model():world():faction_list()
	for i = 0, faction_list:num_items() - 1 do
		local current_faction = faction_list:item_at(i)
		if current_faction:culture() == self.config.high_elf_culture_key then
			table.insert(self.config.high_elf_faction_list, current_faction:name())
		end
	end
end

function hef_intrigue_at_the_court:load_patronage_slots_from_db()
	local patronage_slots_list = cco("CcoCampaignRoot", ""):Call("DatabaseRecords(\"CcoPatronageSlotRecord\")")
	
	for i = 1, #patronage_slots_list do
		local slot_record = patronage_slots_list[i]
		local slot_name = slot_record:Call("SlotName")
		local slot_rank = slot_record:Call("Rank")

		if self.config.patronage_slots[slot_name] == nil then
			self.config.patronage_slots[slot_name] = {
				ranks = {}
			}
		end
		
		self.config.patronage_slots[slot_name].ranks[slot_rank] = {
			key = slot_record:Call("Key"),
			rank = slot_rank,
			effect_bundle = slot_record:Call("EffectBundle"):Call("Key"),
		}
	end
end

function hef_intrigue_at_the_court:load_patron_factions_to_associated_provinces()
	local patron_factions_to_provinces = cco("CcoCampaignRoot", ""):Call("DatabaseRecords(\"CcoPatronFactionToAssociatedProvincesRecord\")")

	for i = 1, #patron_factions_to_provinces do
		local slot_record = patron_factions_to_provinces[i]
		local patron_faction = slot_record:Call("PatronFactionKey")
		local associated_province = slot_record:Call("AssociatedProvinceKey")

		if self.config.patron_faction_to_associated_provinces[patron_faction] == nil then
			self.config.patron_faction_to_associated_provinces[patron_faction] = {
				associated_provinces = {}
			}
		end
		
		table.insert(self.config.patron_faction_to_associated_provinces[patron_faction].associated_provinces, associated_province)
	end
end

function hef_intrigue_at_the_court:set_max_rank_for_patronage_slots()
	for province_key, slot_data in dpairs(self.config.patronage_slots) do
		local province_interface = cm:get_province(province_key)
		cm:set_script_state(province_interface, "patronage_slot_max_occupied_rank", #slot_data.ranks)
	end
end

function hef_intrigue_at_the_court:set_locked_slots_at_game_start()
	for province_key, _ in pairs(self.config.patronage_slots) do
		local is_capital_high_elf_owned = true
		local are_all_minor_regions_high_elf_owned = true

		local province_interface = cm:get_province(province_key)
		local province_regions = province_interface:regions()
		for i, region in model_pairs(province_regions) do
			local is_high_elf_owned = region:owning_faction():culture() == self.config.high_elf_culture_key

			if region:is_province_capital() then 
				is_capital_high_elf_owned = is_high_elf_owned
			elseif is_high_elf_owned == false then
				are_all_minor_regions_high_elf_owned = false
			end
		end

		self:set_slot_locked_for_occupation(province_interface, not is_capital_high_elf_owned)
		self:set_slot_locked_for_upgrade(province_interface, not are_all_minor_regions_high_elf_owned)
	end
end

function hef_intrigue_at_the_court:set_starting_occupied_slots()
	local is_starting_setup = true
	for province_key, starting_data in dpairs(self.config.starting_occupied_slots) do
		local character_interface = cm:get_character_by_startpos_id(starting_data.occupying_character_startpos_id)
		local faction_interface = character_interface:faction()
		if not faction_interface:is_human() or starting_data.assign_if_human then
			local province_interface = cm:get_province(province_key)
			local slot_data = self.config.patronage_slots[province_key]
			self:assign_character_to_slot_at_rank(province_interface, slot_data.ranks[1], character_interface, is_starting_setup)
		end
	end
end

function hef_intrigue_at_the_court:set_initial_favour_tier_required_for_confederation_for_factions()
	for i = 1, #self.config.high_elf_faction_list - 1 do
		local current_faction = cm:get_faction(self.config.high_elf_faction_list[i])
		if current_faction then
			self:set_required_favour_tier_for_faction_to_perform_confederation(current_faction, self.config.confederation_requirements_config.initial_favour_tier_required_for_confederation)
		end
	end
end

function hef_intrigue_at_the_court:setup_aislinn_confederation_requirements()
	for i = 1, #self.config.high_elf_faction_list - 1 do
		local current_faction = cm:get_faction(self.config.high_elf_faction_list[i])
		if current_faction then
			self:lock_aislinn_confederation_ritual_for_faction(current_faction)
			local current_faction_starting_num_of_elven_colony_settlements = 0
			-- some high elf faction start off with "elven conoly" type settlements already in their posession so we should update the shared state for that
			local region_list = current_faction:region_list()
			for i = 0, region_list:num_items() -1 do
				local current_region = region_list:item_at(i)
				if current_region:resource_exists(self.config.confederation_requirements_config.elven_colony_resource_key) then
					current_faction_starting_num_of_elven_colony_settlements = current_faction_starting_num_of_elven_colony_settlements + 1
				end
			end
			self:set_num_of_elven_colony_settlements_for_faction(current_faction, current_faction_starting_num_of_elven_colony_settlements)
		end
	end
end

--------------------------------------------------------------
----------------- PATRONAGE SLOT ACTIONS ---------------------
--------------------------------------------------------------

function hef_intrigue_at_the_court:take_patronage_slot(performing_character_interface, province_interface, slot_data)
	if self:can_take_patronage_in_province(province_interface, performing_character_interface, slot_data) == false then
		return
	end

	-- take patronage always means we are occupying the slot at rank 1 if it was empty
	local slot_rank_to_occupy = slot_data.ranks[1]

	local occupying_fm_cqi = self:get_occupying_fm_cqi_for_slot(province_interface)
	if occupying_fm_cqi ~= 0 then
		-- if the slot was occupied then we will take it at that same rank 
		local last_rank_occupied = self:get_current_occupied_rank_for_slot(province_interface)
		slot_rank_to_occupy = slot_data.ranks[last_rank_occupied]

		-- apply diplomatic penalty when we take a slot that is already occupied
		local new_occupying_faction_key = performing_character_interface:faction():name()
		local current_occupying_fm_interface = cm:get_family_member_by_cqi(occupying_fm_cqi)
		local current_occupying_faction_interface = current_occupying_fm_interface:character_details():faction()
		local current_occupying_faction_key = current_occupying_faction_interface:name()

		cm:apply_dilemma_diplomatic_bonus(new_occupying_faction_key, current_occupying_faction_key, self.config.diplomatic_penalty_amount_when_occupying_taken_slot)
		self:remove_character_from_slot(province_interface, true)
	end
	
	self:assign_character_to_slot_at_rank(province_interface, slot_rank_to_occupy, performing_character_interface)
	self:set_character_on_cooldown(performing_character_interface:family_member(), true)
end

function hef_intrigue_at_the_court:increase_slot_standing(performing_character_interface, province_interface, slot_data)
	local occupying_fm_cqi = self:get_occupying_fm_cqi_for_slot(province_interface)

	local current_occupied_rank = self:get_current_occupied_rank_for_slot(province_interface)
	if current_occupied_rank == 0 or 
		current_occupied_rank == #slot_data.ranks or 
		self:is_slot_locked_for_upgrade(province_interface) or
		occupying_fm_cqi ~= performing_character_interface:family_member():command_queue_index() 
	then
		return
	end

	local new_occupied_rank = current_occupied_rank + 1
	self:assign_character_to_slot_at_rank(province_interface, slot_data.ranks[new_occupied_rank], performing_character_interface)

	-- max rank slots cannot be threatened so we should clear any threats this slot might have if we are upgrading it to max
	if new_occupied_rank == #slot_data.ranks then
		self:clear_slot_threat(province_interface)
		self:try_unlock_confederation_rituals_for_faction(performing_character_interface:faction(), province_interface)
	end
end

function hef_intrigue_at_the_court:cede_patronage_slot(performing_character_interface, province_interface)
	local occupying_fm_cqi = self:get_occupying_fm_cqi_for_slot(province_interface)
	local current_rank = self:get_current_occupied_rank_for_slot(province_interface)
	if occupying_fm_cqi == 0 or occupying_fm_cqi ~= performing_character_interface:family_member():command_queue_index() then
		return
	end

	self:clear_slot_threat(province_interface)
	self:remove_character_from_slot(province_interface, false)
	self:set_character_on_cooldown(performing_character_interface:family_member(), true)
	self:clear_temporary_immunity_duration_for_slot(province_interface)
end

function hef_intrigue_at_the_court:threaten_patronage_slot(performing_character_interface, province_interface, slot_data)
	if self:get_occupying_fm_cqi_for_slot(province_interface) == 0 or self:can_slot_be_threatened(province_interface, slot_data) == false then
		return
	end

	local fm_interface = performing_character_interface:family_member()
	self:set_slot_threatened_by(province_interface, fm_interface:command_queue_index())
	self:set_family_member_threatens_any_patronage_slot(fm_interface, true)

	local occupying_fm_cqi = self:get_occupying_fm_cqi_for_slot(province_interface)
	local occupying_fm = cm:get_family_member_by_cqi(occupying_fm_cqi)
	if not occupying_fm or occupying_fm:is_null_interface() then
		return
	end

	local faction = occupying_fm:character_details():faction()

	self:set_any_patronage_slot_threatened(faction, true)

	cm:show_message_event(
		faction:name(),
		self.config.threaten_event.title,
		self.config.threaten_event.primary_detail,
		self.config.threaten_event.secondary_detail,
		self.config.threaten_event.is_persistent,
		self.config.threaten_event.campaign_group_member_criteria_value
	)
end

function hef_intrigue_at_the_court:protect_patronage_slot(province_interface)
	if self:get_occupying_fm_cqi_for_slot(province_interface) == 0 or self:is_slot_currently_threatened(province_interface) == false then
		return
	end

	self:clear_slot_threat(province_interface)

	local temporary_immunity_duration = cm:campaign_var_int_value(self.config.temporary_slot_immunity_duration_campaign_var_key)
	self:set_temporary_immunity_duration_for_slot(province_interface, temporary_immunity_duration)
end

function hef_intrigue_at_the_court:trigger_protect_patronage_dilemma(target_province_key, performing_faction_key)
	-- Since we have a fallback logic where we pick the dilemma whose cooldown ends the soonest, we don't really care if a dilemma is on cooldown or not.
	local current_turn = cm:turn_number()
	local soonest_cooldown_end_turn = current_turn + self.config.protect_patronage_dilemmas_cooldown
	local soonest_cooldown_end_dilemmas = {}
	for dilemma_key, config in dpairs(self.config.protect_patronage_dilemmas) do
		local dilemma_cooldown_end_turn = self:get_protect_patronage_dilemma_cooldown_end_turn_for_faction(performing_faction_key, dilemma_key)
		-- We treat expired cooldowns equally - as if they ended on the current turn.
		dilemma_cooldown_end_turn = math.max(dilemma_cooldown_end_turn, current_turn)
		if dilemma_cooldown_end_turn == soonest_cooldown_end_turn then
			table.insert(soonest_cooldown_end_dilemmas, dilemma_key)
		elseif dilemma_cooldown_end_turn < soonest_cooldown_end_turn then
			soonest_cooldown_end_turn = dilemma_cooldown_end_turn
			soonest_cooldown_end_dilemmas = { dilemma_key }
		end
	end

	-- Choose a random dilemma amongst soonest_cooldown_end_dilemmas and set it on cooldown
	local dilemma_num = cm:random_number(#soonest_cooldown_end_dilemmas, 1)
	local chosen_dilemma_key = soonest_cooldown_end_dilemmas[dilemma_num]

	cm:trigger_dilemma(performing_faction_key, chosen_dilemma_key)
	self.config.protect_patronage_dilemma_current_target_province_key = target_province_key
	local performing_faction_interface = cm:get_faction(performing_faction_key)
	self:set_protect_patronage_dilemma_cooldown_end_turn_for_faction(performing_faction_interface, chosen_dilemma_key, current_turn + self.config.protect_patronage_dilemmas_cooldown)
end

function hef_intrigue_at_the_court:swap_lord_for_patronage_slot(performing_character_interface, province_interface, slot_data)
	local current_occupied_rank = self:get_current_occupied_rank_for_slot(province_interface)
	local current_occupying_fm_cqi = self:get_occupying_fm_cqi_for_slot(province_interface)
	if current_occupied_rank <= 0 or current_occupying_fm_cqi <= 0 then
		return
	end

	local current_occupying_fm_interface = cm:get_family_member_by_cqi(current_occupying_fm_cqi)
	self:set_family_member_occupies_any_patronage_slot(current_occupying_fm_interface, false)
	self:set_character_on_cooldown(current_occupying_fm_interface, true)

	local current_character = cm:get_character_by_fm_cqi(current_occupying_fm_cqi)
	if current_character and current_character:is_null_interface() == false and current_character:is_alive() then
		cm:remove_effect_bundle_from_character(self:get_effect_bundle_for_rank(province_interface, current_occupied_rank), current_character)
	end

	local new_fm_interface = performing_character_interface:family_member()
	self:set_occupying_character_for_slot(province_interface, new_fm_interface:command_queue_index())
	self:set_family_member_occupies_any_patronage_slot(new_fm_interface, true)
	cm:apply_effect_bundle_to_character(slot_data.ranks[current_occupied_rank].effect_bundle, performing_character_interface, 0)
end

--------------------------------------------------------------
-------------------- EVENT HANDLING --------------------------
--------------------------------------------------------------

function hef_intrigue_at_the_court:clear_take_patronage_cooldown_for_faction(faction_interface)
	local character_list = faction_interface:character_list();
	for i = 0, character_list:num_items() - 1 do
		local character = character_list:item_at(i)
		if character:character_type_key() == "general" then
			local current_fm = character:family_member()
			for province_key, _ in pairs(self.config.patronage_slots) do
				local province_interface = cm:get_province(province_key)
				if self:is_character_on_cooldown_for_slot(current_fm) then
					self:set_character_on_cooldown(current_fm, false)
				end
			end
		end
	end
end

function hef_intrigue_at_the_court:handle_threatened_slots_for_faction(faction_key)
	for province_key, province_slot_data in dpairs(self.config.patronage_slots) do
		local province_interface = cm:get_province(province_key)
		local slot_threatened_by_fm_cqi = self:get_slot_threatened_by_fm_cqi(province_interface) 
		if slot_threatened_by_fm_cqi ~= 0 then
			local slot_threatened_by_fm_interface = cm:get_family_member_by_cqi(slot_threatened_by_fm_cqi)
			-- check if the slot was threatened by the faction we have passed
			if slot_threatened_by_fm_interface and slot_threatened_by_fm_interface:is_null_interface() == false and 
				slot_threatened_by_fm_interface:character_details():faction():name() == faction_key 
			then
				self:try_replace_character_in_threatened_slot(province_interface, slot_threatened_by_fm_cqi, true)
			end
		end
	end
end

function hef_intrigue_at_the_court:handle_region_change_event(region, previous_owner)
	local current_owner = region:owning_faction()
	local is_capital_region = region:is_province_capital()
	local province_interface = region:province()
	local hef_culture_key = self.config.high_elf_culture_key
	
	if not previous_owner:is_null_interface() then
		-- if region belonged to high elf faction but now doesnt
		if previous_owner:culture() == hef_culture_key and current_owner:culture() ~= hef_culture_key then
			if is_capital_region then
				self:set_slot_locked_for_occupation(province_interface, true)
				self:clear_slot_threat(province_interface)
				local occupying_fm_cqi = self:get_occupying_fm_cqi_for_slot(province_interface)
				if occupying_fm_cqi ~= 0 then
					self:remove_character_from_slot(province_interface, true)
					self:clear_temporary_immunity_duration_for_slot(province_interface)
				end
			else
				self:set_slot_locked_for_upgrade(province_interface, true)
			end
		-- if region did NOT belong to high elf faction but now does
		elseif previous_owner:culture() ~= hef_culture_key and current_owner:culture() == hef_culture_key then
			if is_capital_region then
				self:set_slot_locked_for_occupation(province_interface, false)
			else
				if self:are_province_minor_settlements_fully_high_elf_owned(province_interface) then
					self:set_slot_locked_for_upgrade(province_interface, false)
				end
			end
		end
	end
end

function hef_intrigue_at_the_court:handle_lord_death_event(family_member_cqi_to_check)
	for province_key, province_data in dpairs(self.config.patronage_slots) do
		local province_interface = cm:get_province(province_key)
		local occupying_fm_cqi = self:get_occupying_fm_cqi_for_slot(province_interface)
		if occupying_fm_cqi == family_member_cqi_to_check then
			self:remove_character_from_slot(province_interface, true)
			self:clear_temporary_immunity_duration_for_slot(province_interface)
		end

		if self:get_slot_threatened_by_fm_cqi(province_interface) == family_member_cqi_to_check then
			self:clear_slot_threat(province_interface)
		end
	end
end

function hef_intrigue_at_the_court:handle_character_faction_change_event(character_interface)
	local previous_faction_interface = character_interface:family_member():previous_faction()
	local current_faction_interface = character_interface:faction()
	local previous_faction_new_occupied_slots_num = self:get_number_of_slots_occupied_by_faction(previous_faction_interface)
	local current_faction_new_occupied_slots_num = self:get_number_of_slots_occupied_by_faction(current_faction_interface)

	local fm_interface = character_interface:family_member()
	for province_key, _ in pairs(self.config.patronage_slots) do
		local province_interface = cm:get_province(province_key)
		if self:get_occupying_fm_cqi_for_slot(province_interface) == fm_interface:command_queue_index() then
			-- this shared state value gets reset when the character changes faction so we have to check via the provinces and set it again
			self:set_family_member_occupies_any_patronage_slot(fm_interface, true)
			-- this character occupies a slot, so we decrement the slots for the previous faction since he is no longer a part of that faction
			previous_faction_new_occupied_slots_num = previous_faction_new_occupied_slots_num - 1
			-- increment the slots for the current faction since this character now holds a slot for that faction
			current_faction_new_occupied_slots_num = current_faction_new_occupied_slots_num + 1			
		end
	end

	self:set_number_of_slots_occupied_by_faction(previous_faction_interface, math.max(0, previous_faction_new_occupied_slots_num))
	self:set_number_of_slots_occupied_by_faction(current_faction_interface, current_faction_new_occupied_slots_num)
end

function hef_intrigue_at_the_court:progress_temporary_immunity_duration_for_faction(faction_key)
	for province_key, _ in dpairs(self.config.patronage_slots) do
		local province_interface = cm:get_province(province_key)
		local occupying_fm_cqi = self:get_occupying_fm_cqi_for_slot(province_interface)
		if occupying_fm_cqi ~= 0 then
			local immunity_duration_for_slot = self:get_temporary_immunity_duration_for_slot(province_interface)
			if immunity_duration_for_slot > 0 then
				local occupying_fm_interface = cm:get_family_member_by_cqi(occupying_fm_cqi)
				if occupying_fm_interface and occupying_fm_interface:is_null_interface() == false and 
				   occupying_fm_interface:character_details():faction():name() == faction_key
				then
					local new_immunity_duration_for_slot = immunity_duration_for_slot - 1
					if new_immunity_duration_for_slot <= 0 then
						self:clear_temporary_immunity_duration_for_slot(province_interface)
					else
						self:set_temporary_immunity_duration_for_slot(province_interface, new_immunity_duration_for_slot)
					end
				end
			end
		end
	end
end

--------------------------------------------------------------
----------------------- UTIL ---------------------------------
--------------------------------------------------------------

function hef_intrigue_at_the_court:get_occupying_fm_cqi_for_slot(province_interface)
	local current_occupying_fm_cqi = cm:model():shared_states_manager():get_state_as_float_value(province_interface, "patronage_slot_occupying_fm_cqi");
	if current_occupying_fm_cqi == nil then
		return 0
	end

	return current_occupying_fm_cqi
end

function hef_intrigue_at_the_court:get_occupying_character_for_slot(province_interface)
	local current_occupying_fm_cqi = self:get_occupying_fm_cqi_for_slot(province_interface)

	local character = cm:get_character_by_fm_cqi(current_occupying_fm_cqi)
	if character and character:is_null_interface() == false and character:is_alive() then
		return character
	end

	return false
end

function hef_intrigue_at_the_court:set_occupying_character_for_slot(province_interface, fm_cqi)
	cm:set_script_state(province_interface, "patronage_slot_occupying_fm_cqi", fm_cqi)
end

function hef_intrigue_at_the_court:get_current_occupied_rank_for_slot(province_interface)
	local current_occupied_rank = cm:model():shared_states_manager():get_state_as_float_value(province_interface, "patronage_slot_current_occupied_rank");
	if current_occupied_rank == nil then
		return 0
	end

	return current_occupied_rank
end

function hef_intrigue_at_the_court:set_current_occupied_rank_for_slot(province_interface, rank)
	cm:set_script_state(province_interface, "patronage_slot_current_occupied_rank", rank)
end

function hef_intrigue_at_the_court:get_number_of_slots_occupied_by_faction(faction_interface)
	local num_slots = cm:model():shared_states_manager():get_state_as_float_value(faction_interface, "patronage_slots_occupied");
	if num_slots == nil then
		return 0
	end

	return num_slots
end

function hef_intrigue_at_the_court:set_number_of_slots_occupied_by_faction(faction_interface, num_slots)
	cm:set_script_state(faction_interface, "patronage_slots_occupied", num_slots)
end

function hef_intrigue_at_the_court:is_character_on_cooldown_for_slot(fm_interface)
	return cm:model():shared_states_manager():get_state_as_bool_value(fm_interface, "on_cooldown_for_patronage_slots");
end

function hef_intrigue_at_the_court:set_character_on_cooldown(fm_interface, is_on_cooldown)
	cm:set_script_state(fm_interface, "on_cooldown_for_patronage_slots", is_on_cooldown)
end

function hef_intrigue_at_the_court:is_slot_locked_for_occupation(province_interface)
	return cm:model():shared_states_manager():get_state_as_bool_value(province_interface, "patronage_slot_locked_for_occupation");
end

function hef_intrigue_at_the_court:set_slot_locked_for_occupation(province_interface, is_locked)
	cm:set_script_state(province_interface, "patronage_slot_locked_for_occupation", is_locked)
end

function hef_intrigue_at_the_court:is_slot_locked_for_upgrade(province_interface)
	return cm:model():shared_states_manager():get_state_as_bool_value(province_interface, "patronage_slot_locked_for_upgrade");
end

function hef_intrigue_at_the_court:set_slot_locked_for_upgrade(province_interface, is_locked)
	cm:set_script_state(province_interface, "patronage_slot_locked_for_upgrade", is_locked)
end

function hef_intrigue_at_the_court:get_slot_threatened_by_fm_cqi(province_interface)
	local threatened_by_fm_cqi = cm:model():shared_states_manager():get_state_as_float_value(province_interface, "patronage_slot_threatened_by");
	if threatened_by_fm_cqi == nil then
		return 0
	end

	return threatened_by_fm_cqi
end

function hef_intrigue_at_the_court:set_slot_threatened_by(province_interface, fm_cqi)
	cm:set_script_state(province_interface, "patronage_slot_threatened_by", fm_cqi)
end

function hef_intrigue_at_the_court:set_family_member_threatens_any_patronage_slot(fm_interface, currently_threatens_any_slot)
	cm:set_script_state(fm_interface, "currently_threatens_any_patronage_slot", currently_threatens_any_slot)
end

function hef_intrigue_at_the_court:is_family_member_threatening_any_patronage_slot(fm_interface)
	return cm:model():shared_states_manager():get_state_as_bool_value(fm_interface, "currently_threatens_any_patronage_slot")
end

function hef_intrigue_at_the_court:set_family_member_occupies_any_patronage_slot(fm_interface, currently_occupies_any_slot)
	cm:set_script_state(fm_interface, "currently_occupies_any_patronage_slot", currently_occupies_any_slot)
end

function hef_intrigue_at_the_court:is_family_member_occupying_any_patronage_slot(fm_interface)
	return cm:model():shared_states_manager():get_state_as_bool_value(fm_interface, "currently_occupies_any_patronage_slot")
end

function hef_intrigue_at_the_court:get_current_patronage_slot_limit_for_faction(faction_interface)
	return cm:get_factions_bonus_value(faction_interface, self.config.patronage_slots_bonus_value_key)
end

function hef_intrigue_at_the_court:get_effect_bundle_for_rank(province_interface, rank)
	return self.config.patronage_slots[province_interface:key()].ranks[rank].effect_bundle
end

function hef_intrigue_at_the_court:set_protect_patronage_dilemma_cooldown_end_turn_for_faction(faction_interface, dilemma_key, cooldown_end_turn)
	cm:set_script_state(faction_interface, "protect_patronage_dilemma_cooldown_end_turn" .. dilemma_key, cooldown_end_turn)
end

function hef_intrigue_at_the_court:get_protect_patronage_dilemma_cooldown_end_turn_for_faction(faction_interface, dilemma_key)
	local dilemma_cooldown_end_turn = cm:model():shared_states_manager():get_state_as_float_value(faction_interface, "protect_patronage_dilemma_cooldown_end_turn" .. dilemma_key)
	if dilemma_cooldown_end_turn == nil then
		return 0
	end
	return dilemma_cooldown_end_turn
end

function hef_intrigue_at_the_court:get_required_favour_tier_for_faction_to_perform_confederation(faction_interface)
	local required_favour_tier = cm:model():shared_states_manager():get_state_as_float_value(faction_interface, "required_favour_tier_for_faction_to_perform_confederation");
	if required_favour_tier == nil then
		return 0
	end

	return required_favour_tier
end

function hef_intrigue_at_the_court:set_required_favour_tier_for_faction_to_perform_confederation(faction_interface, tier_required)
	cm:set_script_state(faction_interface, "required_favour_tier_for_faction_to_perform_confederation", tier_required)
end

function hef_intrigue_at_the_court:faction_has_required_favour_tier_to_perform_confederation(faction_interface)
	local has_required_favour_tier = cm:model():shared_states_manager():get_state_as_bool_value(faction_interface, "has_required_favour_tier_to_perform_confederation");
	if has_required_favour_tier == nil then
		return false
	end

	return has_required_favour_tier
end

function hef_intrigue_at_the_court:set_faction_has_required_favour_tier_to_perform_confederation(faction_interface, has_required_favour_tier)
	cm:set_script_state(faction_interface, "has_required_favour_tier_to_perform_confederation", has_required_favour_tier)
end

function hef_intrigue_at_the_court:get_num_of_elven_colony_settlements_for_faction(faction_interface)
	local num_of_colony_settlements = cm:model():shared_states_manager():get_state_as_float_value(faction_interface, "num_of_elven_colony_settlements_for_faction");
	if num_of_colony_settlements == nil then
		return 0
	end

	return num_of_colony_settlements
end

function hef_intrigue_at_the_court:set_num_of_elven_colony_settlements_for_faction(faction_interface, num_settlements)
	cm:set_script_state(faction_interface, "num_of_elven_colony_settlements_for_faction", num_settlements)
end

function hef_intrigue_at_the_court:get_temporary_immunity_duration_for_slot(province_interface)
	local temporary_immunity_duration_for_slot = cm:model():shared_states_manager():get_state_as_float_value(province_interface, "temporary_immunity_duration_for_slot");
	if temporary_immunity_duration_for_slot == nil then
		return 0
	end

	return temporary_immunity_duration_for_slot
end

function hef_intrigue_at_the_court:set_temporary_immunity_duration_for_slot(province_interface, duration)
	cm:set_script_state(province_interface, "temporary_immunity_duration_for_slot", duration)
end

function hef_intrigue_at_the_court:clear_temporary_immunity_duration_for_slot(province_interface)
	cm:remove_script_state(province_interface, "temporary_immunity_duration_for_slot")
end

function hef_intrigue_at_the_court:is_slot_immune(province_interface)
	if self:get_temporary_immunity_duration_for_slot(province_interface) > 0 or
	   self:get_current_occupied_rank_for_slot(province_interface) == #self.config.patronage_slots[province_interface:key()].ranks
	then
		return true
	end

	return false
end

function hef_intrigue_at_the_court:assign_character_to_slot_at_rank(province_interface, slot_rank_data, character_interface, is_starting_setup)
	local current_occupying_fm_cqi = self:get_occupying_fm_cqi_for_slot(province_interface)
	local current_fm_interface = cm:get_family_member_by_cqi(current_occupying_fm_cqi)
	local is_different_faction = current_fm_interface and current_fm_interface:is_null_interface() == false and current_fm_interface:character_details():faction():name() ~= character_interface:faction():name()
	local max_rank_for_slot = #self.config.patronage_slots[province_interface:key()].ranks
	if not is_starting_setup and 
	   slot_rank_data.rank ~= max_rank_for_slot and 
	   (current_occupying_fm_cqi <= 0 or is_different_faction) 
	then
		-- we are giving the slot to a different faction, set it to be temporarily immune
		local temporary_immunity_duration = cm:campaign_var_int_value(self.config.temporary_slot_immunity_duration_campaign_var_key)
		self:set_temporary_immunity_duration_for_slot(province_interface, temporary_immunity_duration)
	end

	local current_occupied_rank = self:get_current_occupied_rank_for_slot(province_interface)
	if current_occupied_rank > 0 then
		cm:remove_effect_bundle_from_character(self:get_effect_bundle_for_rank(province_interface, current_occupied_rank), character_interface)
	else
		local fm_interface = character_interface:family_member()
		self:set_occupying_character_for_slot(province_interface, fm_interface:command_queue_index())
		self:set_family_member_occupies_any_patronage_slot(fm_interface, true)

		local faction_interface = character_interface:faction()
		local num_slots = self:get_number_of_slots_occupied_by_faction(faction_interface)
		self:set_number_of_slots_occupied_by_faction(faction_interface, num_slots + 1)
	end

	self:set_current_occupied_rank_for_slot(province_interface, slot_rank_data.rank)
	
	cm:apply_effect_bundle_to_character(slot_rank_data.effect_bundle, character_interface, 0)
end

function hef_intrigue_at_the_court:remove_character_from_slot(province_interface, notify_slot_lost)
	local occupying_fm_cqi = self:get_occupying_fm_cqi_for_slot(province_interface)
	local character = cm:get_character_by_fm_cqi(occupying_fm_cqi)
	local current_occupied_rank = self:get_current_occupied_rank_for_slot(province_interface)
	if character and character:is_null_interface() == false and character:is_alive() and current_occupied_rank > 0 then
		cm:remove_effect_bundle_from_character(self:get_effect_bundle_for_rank(province_interface, current_occupied_rank), character)
	end

	local occupying_fm_interface = cm:get_family_member_by_cqi(occupying_fm_cqi)
	self:set_family_member_occupies_any_patronage_slot(occupying_fm_interface, false)
	
	local occupying_faction_interface = occupying_fm_interface:character_details():faction()
	local num_slots = self:get_number_of_slots_occupied_by_faction(occupying_faction_interface)
	self:set_number_of_slots_occupied_by_faction(occupying_faction_interface, num_slots - 1)

	if notify_slot_lost then
		cm:show_message_event(
			occupying_faction_interface:name(),
			self.config.patronage_lost_event.title,
			self.config.patronage_lost_event.primary_detail,
			self.config.patronage_lost_event.secondary_detail,
			self.config.patronage_lost_event.is_persistent,
			self.config.patronage_lost_event.campaign_group_member_criteria_value
		)
	end

	self:set_occupying_character_for_slot(province_interface, 0)
	self:set_current_occupied_rank_for_slot(province_interface, 0)
	self:lock_confederation_ritual_for_province(occupying_faction_interface, province_interface)
end

function hef_intrigue_at_the_court:can_take_patronage_in_province(province_interface, character, slot_data)
	local current_occupying_fm_cqi = self:get_occupying_fm_cqi_for_slot(province_interface)
	local occupying_fm_interface = cm:get_family_member_by_cqi(current_occupying_fm_cqi)
	-- slots occupied by a human faction need to be threatened and cannot be directly taken
	if occupying_fm_interface and occupying_fm_interface:is_null_interface() == false and 
		occupying_fm_interface:character_details():faction():is_human()
	then
		if not self:is_slot_currently_threatened_by_character(province_interface, character) then
			return false
		end
	end

	local is_character_on_cooldown_for_this_turn = self:is_character_on_cooldown_for_slot(character:family_member())

	local current_patronage_slot_limit_for_faction = self:get_current_patronage_slot_limit_for_faction(character:faction())
	local num_of_currently_occupied_slots = self:get_number_of_slots_occupied_by_faction(character:faction())

	if self:is_slot_immune(province_interface) or
		is_character_on_cooldown_for_this_turn or 
		self:is_slot_locked_for_occupation(province_interface) or
		num_of_currently_occupied_slots >= current_patronage_slot_limit_for_faction 
	then
		return false
	end

	return true
end

function hef_intrigue_at_the_court:is_province_fully_high_elf_owned(province_key)
	local province_regions = cm:get_province(province_key):regions()
	for i, region in model_pairs(province_regions) do
		if region:owning_faction():culture() ~= self.config.high_elf_culture_key then 
			return false
		end
	end
	return true
end

function hef_intrigue_at_the_court:are_province_minor_settlements_fully_high_elf_owned(province_interface)
	local province_regions = province_interface:regions()
	for i, region in model_pairs(province_regions) do
		if region:is_province_capital() == false and region:owning_faction():culture() ~= self.config.high_elf_culture_key then 
			return false
		end
	end
	return true
end

function hef_intrigue_at_the_court:can_slot_be_threatened(province_interface, slot_data)
	local current_occupied_rank = self:get_current_occupied_rank_for_slot(province_interface)
	return current_occupied_rank ~= 0 and self:is_slot_immune(province_interface) == false and self:is_slot_currently_threatened(province_interface) == false
end

function hef_intrigue_at_the_court:is_slot_currently_threatened(province_interface)
	return self:get_slot_threatened_by_fm_cqi(province_interface) ~= 0
end

function hef_intrigue_at_the_court:clear_all_threatened_slots_for_faction(faction_key)
	for province_key, _ in pairs(self.config.patronage_slots) do
		local province_interface = cm:get_province(province_key)
		local occupying_fm_cqi = self:get_occupying_fm_cqi_for_slot(province_interface)
		if occupying_fm_cqi ~= 0 then
			local occupying_fm_interface = cm:get_family_member_by_cqi(occupying_fm_cqi)

			if occupying_fm_interface and occupying_fm_interface:is_null_interface() == false and 
				occupying_fm_interface:character_details():faction():name() == faction_key 
			then
				self:clear_slot_threat(province_interface)
			end
		end
	end
end

function hef_intrigue_at_the_court:try_unlock_confederation_rituals_for_faction(faction_interface, province_interface_to_check)
	if self:faction_has_required_favour_tier_to_perform_confederation(faction_interface) == false then
		return
	end

	for patron_faction_key, patron_faction_data in dpairs(self.config.patron_faction_to_associated_provinces) do
		local patron_associated_provinces = patron_faction_data.associated_provinces
		if is_nil(province_interface_to_check) or table.contains(patron_associated_provinces, province_interface_to_check:key()) then
			if self:does_faction_hold_max_rank_slots_for_provinces(faction_interface, patron_associated_provinces) then
				cm:unlock_ritual(faction_interface, "wh3_dlc27_hef_court_unity_" .. patron_faction_key)
			end
		end
	end
end

function hef_intrigue_at_the_court:lock_confederation_rituals_for_faction(faction_interface)
	for patron_faction_key, _ in dpairs(self.config.patron_faction_to_associated_provinces) do
		cm:lock_ritual(faction_interface, "wh3_dlc27_hef_court_unity_" .. patron_faction_key)
	end
end

function hef_intrigue_at_the_court:lock_confederation_ritual_for_province(faction_interface, province_interface)
	for patron_faction_key, patron_faction_data in dpairs(self.config.patron_faction_to_associated_provinces) do
		local patron_associated_provinces = patron_faction_data.associated_provinces
		-- find the patron faction for this province
		if table.contains(patron_associated_provinces, province_interface:key()) then
			cm:lock_ritual(faction_interface, "wh3_dlc27_hef_court_unity_" .. patron_faction_key)
		end
	end
end

function hef_intrigue_at_the_court:try_unlock_aislinn_confederation_ritual_for_faction(faction_interface)
	if self:faction_has_required_favour_tier_to_perform_confederation(faction_interface) == false then
		return
	end

	local required_num_elven_colony_settlements = cm:campaign_var_int_value(self.config.confederation_requirements_config.aislinn_confederation_required_num_of_elven_colonies_campaign_var_key)
	if self:get_num_of_elven_colony_settlements_for_faction(faction_interface) < required_num_elven_colony_settlements then
		return
	end

	cm:unlock_ritual(faction_interface, self.config.confederation_requirements_config.aislinn_confederation_ritual_key)
end

function hef_intrigue_at_the_court:lock_aislinn_confederation_ritual_for_faction(faction_interface)
	cm:lock_ritual(faction_interface, self.config.confederation_requirements_config.aislinn_confederation_ritual_key)
end

function hef_intrigue_at_the_court:does_faction_hold_max_rank_slots_for_provinces(faction_interface, provinces_to_check)
	for idx, province_key in dpairs(provinces_to_check) do
		local province_interface = cm:get_province(province_key)
		local occupying_fm_cqi = self:get_occupying_fm_cqi_for_slot(province_interface)
		if occupying_fm_cqi == 0 then
			return false
		end

		local occupying_fm_interface = cm:get_family_member_by_cqi(occupying_fm_cqi)
		if occupying_fm_interface:is_null_interface() or occupying_fm_interface:character_details():faction():name() ~= faction_interface:name() then
			return false
		end
		
		if self:get_current_occupied_rank_for_slot(province_interface) < #self.config.patronage_slots[province_interface:key()].ranks then
			return false
		end
	end

	return true
end

function hef_intrigue_at_the_court:increment_requirement_for_faction_to_perform_confederation(faction_interface)
	local new_required_confederation_tier = self:get_required_favour_tier_for_faction_to_perform_confederation(faction_interface) + self.config.confederation_requirements_config.favour_tier_increase_per_confederation
	local active_effect_key = faction_interface:pooled_resource_manager():resource(self.config.favour_pooled_resource_key):active_effect(0)
	local active_effect_index = table.contains(self.config.confederation_requirements_config.favour_active_effect_keys, active_effect_key)
	
	self:set_required_favour_tier_for_faction_to_perform_confederation(faction_interface, new_required_confederation_tier)
	self:set_faction_has_required_favour_tier_to_perform_confederation(faction_interface, active_effect_index >= new_required_confederation_tier)
end

function hef_intrigue_at_the_court:calculate_max_favour_blocked_amount()
	local blocked_amount_breakdown = {
		total_blocked = 0,
		gate_settlements_blocked = 0,
		minor_settlements_blocked = 0,
		major_settlements_blocked = 0,
	}

	for province_key, _ in dpairs(self.config.patronage_slots) do
		local province_regions = cm:get_province(province_key):regions()
		for i, region in model_pairs(province_regions) do
			if region:owning_faction():culture() ~= self.config.high_elf_culture_key then
				if region:is_province_capital() then
					blocked_amount_breakdown.major_settlements_blocked = blocked_amount_breakdown.major_settlements_blocked + self.config.max_favour_reduction_config.major_settlement_reduction_amount
				else
					blocked_amount_breakdown.minor_settlements_blocked = blocked_amount_breakdown.minor_settlements_blocked + self.config.max_favour_reduction_config.minor_settlement_reduction_amount
				end
			end
		end
	end

	-- gate regions are handled separately cause they don't have patronage slots attached to them
	for id, gate_region_key in ipairs(self.config.ulthuan_gate_region_keys) do
		if cm:get_region(gate_region_key):owning_faction():culture() ~= self.config.high_elf_culture_key then 
			blocked_amount_breakdown.gate_settlements_blocked = blocked_amount_breakdown.gate_settlements_blocked + self.config.max_favour_reduction_config.gate_settlement_reduction_amount
		end	
	end

	blocked_amount_breakdown.total_blocked = blocked_amount_breakdown.gate_settlements_blocked + blocked_amount_breakdown.major_settlements_blocked + blocked_amount_breakdown.minor_settlements_blocked

	return blocked_amount_breakdown
end

function hef_intrigue_at_the_court:update_favour_resource_maximum()
	local new_blocked_amount_breakdown = self:calculate_max_favour_blocked_amount()
	-- apply to all factions that have the resource
	local bundle_key = self.config.max_favour_reduction_config.effect_bundle_key
	local faction_list = cm:model():world():faction_list()
	for i = 0, faction_list:num_items() - 1 do
		local current_faction = faction_list:item_at(i)
		if current_faction:pooled_resource_manager():resource(self.config.favour_pooled_resource_key):is_null_interface() == false then
			-- if favour is not reduced we don't need the effect bundle
			if new_blocked_amount_breakdown.total_blocked == 0 and current_faction:has_effect_bundle(bundle_key) then
				cm:remove_effect_bundle(bundle_key, current_faction:name())
			else
				local bundle_parameters = {
					faction = current_faction,
					effect_bundle_key = bundle_key,
					effects = {
						[self.config.max_favour_reduction_config.total_favour_blocked_effect_key] = new_blocked_amount_breakdown.total_blocked,
						[self.config.max_favour_reduction_config.gate_settlements_favour_blocked_effect_key] = new_blocked_amount_breakdown.gate_settlements_blocked,
						[self.config.max_favour_reduction_config.major_settlements_favour_blocked_effect_key] = new_blocked_amount_breakdown.major_settlements_blocked,
						[self.config.max_favour_reduction_config.minor_settlements_favour_blocked_effect_key] = new_blocked_amount_breakdown.minor_settlements_blocked,
					}
				}
				cm:build_and_apply_custom_effect_bundle_to_faction(bundle_parameters)
			end
		end
	end
end

function hef_intrigue_at_the_court:is_slot_currently_threatened_by_character(province_interface, checked_character_interface)
	return self:get_slot_threatened_by_fm_cqi(province_interface) == checked_character_interface:family_member():command_queue_index()
end

function hef_intrigue_at_the_court:clear_slot_threat(province_interface)
	local currently_threatening_fm_cqi = self:get_slot_threatened_by_fm_cqi(province_interface)
	if currently_threatening_fm_cqi == 0 then
		return
	end

	local currently_threatening_fm_interface = cm:get_family_member_by_cqi(currently_threatening_fm_cqi)
	self:set_family_member_threatens_any_patronage_slot(currently_threatening_fm_interface, false)
	self:set_slot_threatened_by(province_interface, 0)
	self:check_if_any_slot_threatened_for_faction_of_province_slot_occupier(province_interface)
end

function hef_intrigue_at_the_court:cai_take_or_threaten_slot(faction)
	if faction == nil then
		return
	end
	local current_patronage_slot_limit_for_faction = self:get_current_patronage_slot_limit_for_faction(faction)
	local num_of_currently_occupied_slots = self:get_number_of_slots_occupied_by_faction(faction)
	
	if current_patronage_slot_limit_for_faction == num_of_currently_occupied_slots or num_of_currently_occupied_slots > faction:num_generals() then
		return
	end

	local available_characters = {}

	-- populate the available generals
	local mf_list = faction:military_force_list()
	for i = 0, mf_list:num_items() -1 do
		local curr_mf = mf_list:item_at(i)
		
		if curr_mf:has_general() and not curr_mf:is_armed_citizenry() then
			local gen_character = curr_mf:general_character()
			local fm_interface = gen_character:family_member()
			if not self:is_family_member_occupying_any_patronage_slot(fm_interface) and not self:is_family_member_threatening_any_patronage_slot(fm_interface) then
				table.insert(available_characters, gen_character)
			end
		end
	end

	if next(available_characters) == nil then
		-- we don't have available characters
		return
	end

	local available_slots = {}
	local taken_slots = {}
	
	-- populate the free slots and taken slots.
	for province, slot in dpairs(self.config.patronage_slots) do
		local current_province = cm:get_province(province)
		if not hef_intrigue_at_the_court:is_slot_locked_for_occupation(current_province) then	
			local current_occupying_fm_cqi = self:get_occupying_fm_cqi_for_slot(current_province)
			if current_occupying_fm_cqi == 0 then
				table.insert(available_slots, province)
			else
				local family_member = cm:get_family_member_by_cqi(current_occupying_fm_cqi)
				local character_details_interface = family_member:character_details()
				local occupying_faction = character_details_interface:faction()
				if occupying_faction ~= faction then	
					table.insert(taken_slots, {province_key = province, is_human = occupying_faction:is_human()})
				end
			end
		end
	end

	
	if next(available_slots) ~= nil then
		local province_key = available_slots[cm:random_number(#available_slots, 1)]
		local province = cm:get_province(province_key)
		local slot = self.config.patronage_slots[province_key]
		local character = available_characters[cm:random_number(#available_characters, 1)]

		self:take_patronage_slot(character, province, slot)
		-- we've taken a slot, enough for this turn.
		return 
	end

	if next(taken_slots) ~= nil then
		local random_number = cm:random_number(#taken_slots, 1)
		local province_key = taken_slots[random_number].province_key
		local province = cm:get_province(province_key)
		local slot = self.config.patronage_slots[province_key]
		local character = available_characters[cm:random_number(#available_characters, 1)]

		if taken_slots[random_number].is_human then 
			self:threaten_patronage_slot(character, province, slot)
			-- we've threatened a player's slot, enough for this turn.
			return
		else
			self:take_patronage_slot(character, province, slot)
			-- we've taken a slot, enough for this turn.
			return 
		end
	end
end

function hef_intrigue_at_the_court:calculate_start_of_turn_favour_award(faction)

	local change_step = cm:campaign_var_int_value(self.config.positive_diplomatic_relations_change_step_key);
	local favour_gained = 0

	for i = 1, #self.config.high_elf_faction_list do
		local current_faction = cm:get_faction(self.config.high_elf_faction_list[i])
		if current_faction then
			local both_human = faction:is_human() and current_faction:is_human()
			local is_same_faction = faction == current_faction
			if not both_human and not is_same_faction and not current_faction:is_dead() then
				local current_attitude = current_faction:diplomatic_attitude_towards(faction:name())
				local current_attitude_threshold = math.floor(current_attitude / change_step)
				if current_attitude_threshold > 0 then
					favour_gained = favour_gained + current_attitude_threshold * self.config.favour_per_threshold
				end
			end
		end
	end

	if favour_gained > 0 then
		cm:faction_add_pooled_resource(faction:name(), self.config.favour_pooled_resource_key, self.config.favour_positive_diplomatic_attitude_toward_hef_factions_factor, favour_gained)
	end
end

function hef_intrigue_at_the_court:get_any_patronage_slot_threatened(faction_interface)
	return cm:model():shared_states_manager():get_state_as_bool_value(faction_interface, "any_patronage_slot_threatened")
end

function hef_intrigue_at_the_court:set_any_patronage_slot_threatened(faction_interface, any_slot_threatened)
	cm:set_script_state(faction_interface, "any_patronage_slot_threatened", any_slot_threatened)
end

function hef_intrigue_at_the_court:check_if_any_slot_threatened_for_faction(faction)
	-- go through patronage slots
	for province_key, _ in pairs(self.config.patronage_slots) do
		local province_interface = cm:get_province(province_key)
		-- check if threatened
		if self:is_slot_currently_threatened(province_interface) then
			-- check if occupied
			local occupying_fm_cqi = self:get_occupying_fm_cqi_for_slot(province_interface)
			local occupying_fm = cm:get_family_member_by_cqi(occupying_fm_cqi)
			if occupying_fm and not occupying_fm:is_null_interface() then
				local affected_faction = occupying_fm:character_details():faction()
				if affected_faction == faction then
					self:set_any_patronage_slot_threatened(faction, true)
					return
				end
			end
		end
	end

	self:set_any_patronage_slot_threatened(faction, false)
end

function hef_intrigue_at_the_court:check_if_any_slot_threatened_for_faction_of_province_slot_occupier(province_interface)
	local occupying_fm_cqi = self:get_occupying_fm_cqi_for_slot(province_interface)
	local occupying_fm = cm:get_family_member_by_cqi(occupying_fm_cqi)

	if not occupying_fm or occupying_fm:is_null_interface() then
		return
	end

	local affected_faction = occupying_fm:character_details():faction()
	self:check_if_any_slot_threatened_for_faction(affected_faction)
end

function hef_intrigue_at_the_court:try_replace_character_in_threatened_slot(province_interface, slot_threatened_by_fm_cqi, notify_slot_lost)
	-- only proceed with changing the character in the slot if we have a living character to place in the slot
	local threatening_character_interface = cm:get_character_by_fm_cqi(slot_threatened_by_fm_cqi)
	if threatening_character_interface and threatening_character_interface:is_null_interface() == false and threatening_character_interface:is_alive() then
		self:clear_slot_threat(province_interface)
		local last_rank_occupied = self:get_current_occupied_rank_for_slot(province_interface)
		-- remove the current character in the slot if there is one
		if self:get_occupying_fm_cqi_for_slot(province_interface) ~= 0 then
			self:remove_character_from_slot(province_interface, notify_slot_lost)
		end
		-- and assign the threatening character at the same rank slot was at previously
		self:assign_character_to_slot_at_rank(province_interface, self.config.patronage_slots[province_interface:key()].ranks[last_rank_occupied], threatening_character_interface)
	end
end

function hef_intrigue_at_the_court:patrons_of_ulhuan_mission(faction)
	local mm = mission_manager:new(faction, self.config.patrons_of_ulthuan_mission_key);
	mm:set_mission_issuer("CLAN_ELDERS");
	mm:add_new_objective("SCRIPTED");
	mm:add_condition("script_key " .. "wh3_dlc27_mission_hef_patrons_of_ulthuan")
	mm:add_condition("override_text mission_text_text_wh3_dlc27_mission_hef_patrons_of_ulthuan");
	mm:add_payload("money 1000");
	mm:trigger();
end

function hef_intrigue_at_the_court:try_unlock_feature_for_faction(faction_interface)
	if cm:ui_overriden(self.config.button_ui_override_key) == false then
		return
	end

	local unlock_turn_reached = cm:turn_number() >= self.config.feature_unlock_turn
	local force_unlocked = self.config.dev_force_unlock_feature
	local has_minimum_influence = faction_interface:influence() >= self.config.feature_unlock_influence_minimum

	if unlock_turn_reached or force_unlocked or has_minimum_influence then
		cm:override_ui(self.config.button_ui_override_key, false)
	end
end
--------------------------------------------------------------
----------------------- TEST ---------------------------------
--------------------------------------------------------------

function hef_intrigue_at_the_court:test_hef_court_ritual(ritual_key)
	local aislinn_faction = cm:get_faction("wh3_dlc27_hef_aislinn")
	local ritual_setup = cm:create_new_ritual_setup(aislinn_faction, ritual_key)
	
	-- set target (capital of province whose slot we want to take)
	local ritual_target = ritual_setup:target();
	local target_province = cm:get_province("wh3_main_combi_province_avelorn")
	ritual_target:set_target_region(target_province:capital_region());

	-- set performer (one of our lords, should be passed via UI)
	local required_characters = ritual_setup:performing_characters();
	local faction_leader = aislinn_faction:faction_leader():family_member();
	local performer = required_characters:item_at(0);
	performer:set_performer(ritual_setup, faction_leader)

	cm:perform_ritual_with_setup(ritual_setup)
end