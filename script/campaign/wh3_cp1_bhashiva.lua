bhashiva_campaign_config = {
	faction_key = "wh3_cp1_cth_tiger_warriors",
	first_enemy_key = "wh3_main_ogr_blood_guzzlers",

	relics = {
		key = "wh3_cp1_cth_relics",
		factor_settlements = "settlements_captured",
		factor_ivory_road = "wh3_cp1_ivory_road",
		factor_gifts = "wh3_cp1_tiger_court",
		factor_settlements_id = "wh3_cp1_cth_bhashiva_relics_settlements",
	},
	relics_region = {
		key = "wh3_cp1_cth_relics_settlements",
		factor_settlements_id = "wh3_cp1_cth_relics_settlements_uncovered",
		factor_other = "wh3_cp1_cth_relics_settlements_other",

	},

	max_usable_relics = 15,
	relics_turn_reminder = 15,

	regions_with_relics_group_starting = "wh3_cp1_relics_regions_starting",
	regions_with_relics_group_mountains = "wh3_cp1_relics_regions_mountains",
	regions_with_relics_group_ivory_roads = "wh3_cp1_relics_regions_ivory_roads",

	regions_with_relics = {
		north = {
			"wh3_main_combi_region_gorger_rock",
			"wh3_main_combi_region_zharr_naggrund",
			"wh3_main_combi_region_titans_notch",
		},
		south = {
			"wh3_main_combi_region_great_hall_of_greasus",
			"wh3_main_combi_region_pigbarter",
		},
	},

	iron_favour = {
		key = "wh3_cp1_cth_iron_favour",
		factor_shang_yang = "shang_yang",
	},

	initial_enemy_mission_key = "wh3_cp1_camp_narrative_ie_bhashiva_defeat_initial_enemy_01",

	mission_data = {
		second = {
			key = "wh3_cp1_camp_narrative_ie_bhashiva_02_improve_tiger_court",
			objective_type = "SCRIPTED",
			objective = "spend_relics",
			condition_script = "improve_tiger_court_wh3_cp1_camp_narrative_ie_bhashiva_02_improve_tiger_court",
			condition_value = 1,
			condition_override_text = "mission_text_text_wh3_cp1_objective_text_improve_tiger_court",
			payloads = {
				payload.money(750),
			},
			narrative_state = 2,
		},
		third = {
			key = "wh3_cp1_camp_narrative_ie_bhashiva_03_capture_x_settlements",
			objective_type = "OWN_N_PROVINCES",
			condition_value = 1,
			payloads = {
				payload.iron_favour(75),
			},
			narrative_state = 3,
		},
		fourth = {
			key = "wh3_cp1_camp_narrative_ie_bhashiva_04_win_x_battles",
			objective_type = "SCRIPTED",
			objective = "win_x_battles",
			condition_script = "win_x_battles_wh3_cp1_camp_narrative_ie_bhashiva_04_win_x_battles",
			condition_value = 4,
			condition_override_text = "mission_text_text_wh3_cp1_camp_narrative_ie_bhashiva_04_win_x_battles",
			payloads = {
				payload.money(750),
				payload.iron_favour(100),
			},
			narrative_state = 4,
			incident_end = "wh3_cp1_cth_khrone_invasion_tigers",
		},
		fifth_marker = {
			key = "wh3_cp1_camp_narrative_ie_bhashiva_05_khorne_marker",
			objective_type = "SCRIPTED",
			objective = "turns_countdown",
			condition_script = "marker_wh3_cp1_camp_narrative_ie_bhashiva_05_khorne_marker",
			condition_value = 4,
			condition_override_text = "mission_text_text_wh3_cp1_camp_narrative_ie_bhashiva_05_khorne_marker",
			payloads = {
				payload.money(1000),
				payload.iron_favour(100),
			},
			narrative_state = 6,
			spawn_marker = true,
			chaos_god = "khorne",
			difficulty = 1,
		},
		fifth_battle = {
			key = "wh3_cp1_camp_narrative_ie_bhashiva_05_khorne_beat",
			objective_type = "ENGAGE_FORCE",
			condition_engage_faction = "wh3_dlc25_kho_khorne_invasion",
			payloads = {
				payload.money(1500),
				payload.iron_favour(125),
			},
			narrative_state = 7,
			chaos_god = "khorne"
		},
		sixth = {
			key = "wh3_cp1_camp_narrative_ie_bhashiva_06_improve_tiger_court",
			objective_type = "SCRIPTED",
			objective = "spend_relics",
			condition_script = "improve_tiger_court_wh3_cp1_camp_narrative_ie_bhashiva_06_improve_tiger_court",
			condition_value = 4,
			condition_override_text = "mission_text_text_wh3_cp1_objective_text_improve_tiger_court",
			payloads = {
				payload.money(1500),
			},
			narrative_state = 8,
			incident_end = "wh3_cp1_cth_nurgle_invasion_tigers",
		},
		seventh_marker = {
			key = "wh3_cp1_camp_narrative_ie_bhashiva_07_nurgle_marker",
			objective_type = "SCRIPTED",
			objective = "turns_countdown",
			condition_script = "marker_wh3_cp1_camp_narrative_ie_bhashiva_07_nurgle_marker",
			condition_value = 4,
			condition_override_text = "mission_text_text_wh3_cp1_camp_narrative_ie_bhashiva_07_nurgle_marker",
			payloads = {
				payload.money(1500),
				payload.iron_favour(200),
			},
			narrative_state = 10,
			spawn_marker = true,
			chaos_god = "nurgle",
			difficulty = 1,
		},
		seventh_battle = {
			key = "wh3_cp1_camp_narrative_ie_bhashiva_07_nurgle_beat",
			objective_type = "ENGAGE_FORCE",
			condition_engage_faction = "wh3_dlc25_nur_nurgle_invasion",
			payloads = {
				payload.money(2000),
				payload.iron_favour(400),
			},
			narrative_state = 11,
			chaos_god = "nurgle",
			incident_end = "wh3_cp1_cth_tzeentch_invasion_tigers",
		},
		eight = {
			key = "wh3_cp1_camp_narrative_ie_bhashiva_08_improve_tiger_court",
			objective_type = "SCRIPTED",
			objective = "spend_relics",
			condition_script = "improve_tiger_court_wh3_cp1_camp_narrative_ie_bhashiva_08_improve_tiger_court",
			condition_value = 4,
			condition_override_text = "mission_text_text_wh3_cp1_objective_text_improve_tiger_court",
			payloads = {
				payload.money(2000),
			},
			narrative_state = 12,
		},
	},

	optional_mission_data = {
		first = {
			key = "wh3_cp1_camp_narrative_ie_bhashiva_01_capture_settlement",
			objective_type = "CAPTURE_REGIONS",
			condition_regions = {"wh3_main_combi_region_bloodpeak"},
			payloads = {
				payload.money(500),
			},
		},
	},

	narrative_dilemmas = {
		zhao_first_support = {
			key = "wh3_cp1_cth_bhashiva_narrative_03_zhao_ming_support",
			dilemma_state = 0
		},
		final = {
			key = "wh3_cp1_cth_bhashiva_narrative_final_zhao_ming_support",
			dilemma_state = 9
		}
	},

	incident_data = {
		narrative_start = "wh3_cp1_incident_cth_narrative_chain_start",
		reveal_relics = "wh3_cp1_incident_cth_narrative_relics_show",
		relics_reminder = "wh3_cp1_cth_incident_relics_found",
		tiger_court_unlock = "wh3_cp1_cth_tiger_court_panel_unlocked",
	},

	marker = {
		key = "wh3_cp1_bhashiva_chaos_narrative_",
		distance = 40,
		radius = 2,
		camera_scroll_speed = 2,
	},

	invasion = {
		faction_keys = {
			["khorne"] = "wh3_dlc25_kho_khorne_invasion",
			["nurgle"] = "wh3_dlc25_nur_nurgle_invasion",
		},
		general = {
			["khorne"] = {
				agent_subtype = "wh3_main_kho_herald_of_khorne",
				forename = "names_name_1562012629",
				clan_name = "",
				family_name = "",
				other_name = "",
				effect_bundle = "wh_main_bundle_military_upkeep_free_force_special_character_unbreakable",
			},
			["nurgle"] = {
				agent_subtype = "wh3_main_nur_herald_of_nurgle_nurgle",
				forename = "names_name_1048634847",
				clan_name = "",
				family_name = "",
				other_name = "",
				effect_bundle = "wh_main_bundle_military_upkeep_free_force_special_character_unbreakable",
			},
		},
		units = {
			["khorne"] = {
				inf_low = "wh3_main_kho_inf_bloodletters_0",
				inf_low_special = "wh3_main_kho_inf_chaos_warriors_2",
				inf_high = "wh3_dlc20_chs_inf_forsaken_mkho",
				inf_high_special = "wh3_main_kho_inf_bloodletters_1",
				cav_low = "wh3_dlc20_chs_cav_marauder_horsemen_mkho_throwing_axes",
				cav_high = "wh3_dlc20_chs_cav_chaos_knights_mkho",
				monster_low = "wh3_main_kho_inf_chaos_furies_0",
				monster_med = "wh3_main_kho_inf_flesh_hounds_of_khorne_0",
				monster_high = "wh3_dlc26_kho_mon_bloodbeast_of_khorne",
			},
			["nurgle"] = {
				inf_low = "wh3_main_nur_inf_plaguebearers_0",
				inf_low_special = "wh3_main_nur_inf_plaguebearers_1",
				inf_high = "wh3_dlc20_chs_inf_chosen_mnur",
				inf_high_special = "wh3_dlc20_chs_inf_chosen_mnur_greatweapons",
				cav_low = "wh3_dlc20_chs_cav_chaos_knights_mnur",
				cav_high = "wh3_dlc20_chs_cav_chaos_knights_mnur_lances",
				monster_low = "wh3_main_nur_cav_pox_riders_of_nurgle_0",
				monster_med = "wh3_dlc25_nur_mon_bile_trolls",
				monster_high = "wh3_main_nur_cav_plague_drones_0",
			},
		},
		distance_min = 4,
		distance_max = 11,
	},

	key_variables = {
		mission_variables = {},
		narrative_state = {
			main = 0,
			dilemma = 0,
		},
		markers_x_y_locations = {},
		incidents_shown = {},
		total_relics_spent = 0,
		total_relics_collected = 0,
		relics_revealed = false,
		ivory_road_regions = {}
	},
}

bhashiva_campaign = {}
bhashiva_campaign.config = bhashiva_campaign_config

function bhashiva_campaign:initialise()
	cm:set_persist_resource_through_rebel_ownership(self.config.relics_region.key, true)

	local faction = self.config.faction_key
	local faction_si = cm:get_faction(faction)
	local relics_settlement_group = self.config.regions_with_relics_group_starting
	local relics_settlement_mountains = self.config.regions_with_relics_group_mountains
	local relics_settlement_factor = self.config.relics_region.factor_settlements_id

	if faction_si then
		if cm:is_new_game() then -- establish starting relic settlements for all
			self:assign_settlement_relics(relics_settlement_group, relics_settlement_factor, 1)

			local world = cm:model():world()
			local ivory_road_region_list = world:lookup_regions_from_region_group(self.config.regions_with_relics_group_ivory_roads)
			self.config.key_variables.ivory_road_regions = unique_table:region_list_to_unique_table(ivory_road_region_list):to_table()

			--setup ivory road relics spawn turns
			local random_second = cm:random_number(40, 30)
			local random_third = cm:random_number(60, 50)
			cm:add_turn_countdown_event(faction, 8, "ScriptedEventDiscoverIvoryRelic");
			cm:add_turn_countdown_event(faction, random_second, "ScriptedEventDiscoverIvoryRelic");
			cm:add_turn_countdown_event(faction, random_third, "ScriptedEventDiscoverIvoryRelic");
			
			if not faction_si:is_human() then -- enable remaining settlement relics for AI
				self:assign_settlement_relics(relics_settlement_mountains, relics_settlement_factor, 1)
			end
		end

		if faction_si:is_human() then
			self:handle_scripted_mission_reissue()
			self:add_listeners()
			self:add_scripted_listeners()

			local mission_data_first = self.config.optional_mission_data.first
			local narrative_state_main = self.config.key_variables.narrative_state.main

			if not cm:mission_has_been_issued_for_faction(faction_si, mission_data_first.key) then 
				core:add_listener(
					"BhashivaNarrativeIncidentStart",
					"BattleConflictFinished",
					function(context)
						local faction_key = self.config.faction_key
						local faction_si = cm:get_faction(faction_key)

						if faction_si and faction_si:is_human() then
							return cm:pending_battle_cache_faction_is_involved(faction_key)
						end
					end,
					function(context)
						local narrative_start = self.config.incident_data.narrative_start
						local faction_key = self.config.faction_key

						if narrative_start then
							if not self.config.key_variables.incidents_shown[narrative_start] then
								cm:trigger_incident(faction_key, narrative_start, true)
								core:remove_listener("BhashivaNarrativeIncidentStart")
				
								if not cm:mission_has_been_issued_for_faction(faction_si, mission_data_first.key) then
									self:trigger_mission(mission_data_first, faction_key)
									core:remove_listener("BhashivaackupNarrativeTriggers")
								end
							end
						end
					end,
					true
				)

				core:add_listener(
					"BhashivaackupNarrativeTriggers",
					"FactionTurnStart",
					function(context)
						local faction_si = cm:get_faction(self.config.faction_key)

						if faction_si and context:faction() == faction_si and faction_si:is_human() then
							return true
						end
					end,
					function(context)
						local faction_key = self.config.faction_key
						local faction_si = cm:get_faction(faction_key)
						local mission_data_first = self.config.optional_mission_data.first

						if cm:turn_number() >= 3 and narrative_state_main == 0 and
							not cm:mission_has_been_issued_for_faction(faction_si, mission_data_first.key) and
							not cm:mission_is_active_for_faction(faction_si, mission_data_first.key) then
								self:trigger_mission(mission_data_first, faction_key)
								core:remove_listener("BhashivaackupNarrativeTriggers")
						end
					end,
					true
				)
			end
		end
	end
end

function bhashiva_campaign:add_listeners()
	
	-- Missions listeners
	core:add_listener(
		"BhashivaNarrativeMissionCompletedListener",
		"MissionSucceeded",
		function(context)
			local faction_si = cm:get_faction(self.config.faction_key)
			
			if faction_si == context:faction() and faction_si:is_human() then
				return true
			else
				return false
			end
		end,
		function(context)
			local main_mission_data = self.config.mission_data
			local optional_mission_data = self.config.optional_mission_data
			local mission_key = context:mission():mission_record_key()
			local faction_key = self.config.faction_key

			local function process_mission(data, trigger_next)
				if not data then
					return false 
				end

				for _, mission in pairs(data) do
					if mission.key == mission_key then
						if mission.incident_end then
							cm:trigger_incident(faction_key, mission.incident_end, true)
						end

						if trigger_next then
							self:trigger_next_mission(mission)
						end

						return true
					end
				end

				return false
			end

			if not process_mission(main_mission_data, true) then
				process_mission(optional_mission_data, false)
			end
		end,
		true
	)

	-- Pooled resource track
	core:add_listener(
		"BhashivaNarrativePooledResourceSpent",
		"PooledResourceChanged",
		function(context)
			local faction_si = cm:get_faction(self.config.faction_key)

			if faction_si and context:faction() == faction_si and faction_si:is_human() then
				return true
			end
		end,
		function(context)
			local narrative_state_dilemma = self.config.key_variables.narrative_state.dilemma
			local value = context:amount()
			local max_relics = self.config.max_usable_relics

			-- record collected relics
			if context:resource():key() == self.config.relics.key and value < 0 then
				self.config.key_variables.total_relics_spent = self.config.key_variables.total_relics_spent + (value * -1)
			elseif context:resource():key() == self.config.relics.key and value > 0 then
				self.config.key_variables.total_relics_collected = self.config.key_variables.total_relics_collected + value
				self.config.key_variables.last_relics_collected_turn = cm:model():turn_number()
				self.config.key_variables.last_relics_collected_reminded = false

				if self.config.key_variables.total_relics_collected >= max_relics then
					self:clean_relic_settlements()
				end
			end

			-- track iron favour
			if context:resource():key() == self.config.iron_favour.key then
				-- shang-yang unlocked support
				local unlocked = cm:model():shared_states_manager():get_state_as_bool_value(context:faction(), tiger_mercenaries_config.feature_unlocked_key)
				local support_dilemma = self.config.narrative_dilemmas.zhao_first_support
				if unlocked and support_dilemma.dilemma_state == narrative_state_dilemma then
					-- self:trigger_dilemma(support_dilemma)
					self.config.key_variables.narrative_state.dilemma = 1
				end
			end
		end,
		true
	)

	-- Settlement actions
	core:add_listener(
		"BhashivaRelicsRegionCaptured",
		"RegionFactionChangeEvent",
		function(context)
			local faction_si = cm:get_faction(self.config.faction_key)
			local owning_faction = context:region():owning_faction()

			if faction_si and faction_si == owning_faction and context:previous_faction() ~= faction_si then
				return true
			end
		end,
		function(context)
			local region_si = context:region()
			local faction_key = self.config.faction_key
			local faction_si = cm:get_faction(faction_key)
			local relics_region_factor_id = self.config.relics_region.factor_settlements_id
			local relics_faction_factor_id = self.config.relics.factor_settlements_id

			-- relics rewards processing
			local region_resource = region_si:pooled_resource_manager():resource("wh3_cp1_cth_relics_settlements")
			if region_resource and region_resource:value() ~= 0 then
				cm:entity_transfer_pooled_resource(region_si, relics_region_factor_id, faction_si, relics_faction_factor_id, 1)

				if self.config.key_variables.narrative_state.main == 0 then -- narrative settlement trackers, check if player captures other relics than the intended ones
					if not cm:mission_is_active_for_faction(faction_si, self.config.mission_data.second.key) then
						self.config.key_variables.narrative_state.main = 1
						self:trigger_next_mission()
					end
				end
			end

			if self.config.key_variables.narrative_state.main == 0 then -- handle cases where the playe diviates from intended settlement without relics
				if not self.config.key_variables.relics_revealed then
					cm:add_turn_countdown_event(faction_key, 1, "ScriptedEventDelayRelicsReveal", faction_key)
					self.config.key_variables.relics_revealed = true
				end
			end
		end,
		true
	)

	-- MarkerInteracted
	core:add_listener(
		"BhashivaNarrativeMarkerInteracted",
		"MarkerInteracted",
		function(context)
			local marker_id = context:marker_id()
			if not string.find(marker_id, "narrative_ie_bhashiva") then
				return false
			end

			local character = context:family_member():character()
			-- Heroes cannot interact with markers, just lords
			if not character:has_military_force() then
				return false
			end

			return true
		end,
		function(context)
			local marker_id = context:marker_id()
			local mission_data = self.config.mission_data
			local faction_key = self.config.faction_key

			for i, mission in pairs(mission_data) do
				if marker_id == "marker_" .. mission.key then
					cm:complete_scripted_mission_objective(faction_key, mission.key, mission.condition_script, true)
				end
			end
		end,
		true
	)

	core:add_listener(
		"BhashivaNarrativeIncidentEvent",
		"IncidentOccuredEvent",
		function(context)
			local faction_si = cm:get_faction(self.config.faction_key)

			if faction_si and context:faction() == faction_si and faction_si:is_human() then
				return true
			end
		end,
		function(context)
			-- reveal relics incident
			if context:dilemma() == self.config.incident_data.reveal_relics then
				core:add_listener(
					"BhashivaNarrativeRelicsIncidentClosed",
					"PanelClosedCampaign",
					true,
					function()
						local local_faction = cm:get_local_faction(true)
						if is_nil(local_faction) or local_faction:is_null_interface() then
							return
						end
						local local_faction_cqi = local_faction:command_queue_index()
						CampaignUI.TriggerCampaignScriptEvent(local_faction_cqi, "reveal_relics_incident_selected")
					end,
					false
				)
			end
		end,
		true
	)

	core:add_listener(
		"BhashivaPersistentTurnStartEvent",
		"FactionTurnStart",
		function(context)
			local faction_si = cm:get_faction(self.config.faction_key)

			if faction_si and context:faction() == faction_si and faction_si:is_human() then
				return true
			else
				return false
			end
		end,
		function(context)
			-- schedule reminder for relic settlements
			local relics_collected_turn = self.config.key_variables.last_relics_collected_turn or 1
			local was_reminded = self.config.key_variables.last_relics_collected_reminded
			local reminder_turns = self.config.relics_turn_reminder
			local max_relics = self.config.max_usable_relics

			if cm:model():turn_number() - relics_collected_turn > reminder_turns and self.config.key_variables.total_relics_collected < max_relics and was_reminded ~= true then
				self:handle_regular_relics_reminder()
				self.config.key_variables.last_relics_collected_reminded = true
			end
		end,
		true
	)
end

function bhashiva_campaign:add_scripted_listeners()
	local faction_key = self.config.faction_key

	core:add_listener(
		"ScriptedEventDelayRelicsRevealBhashiva",
		"ScriptedEventDelayRelicsReveal",
		true,
		function(context)
			cm:trigger_incident(faction_key, self.config.incident_data.reveal_relics, true)
		end,
		false
	)

	core:add_listener(
		"ScriptedEventMarkerDelayKhorneBhashiva",
		"ScriptedEventMarkerDelayKhorne",
		true,
		function(context)
			self:trigger_next_mission()
		end,
		false
	)

	core:add_listener(
		"ScriptedEventMarkerDelayNurgleBhashiva",
		"ScriptedEventMarkerDelayNurgle",
		true,
		function(context)
			self:trigger_next_mission()
		end,
		false
	)

	core:add_listener(
		"ScriptedEventPrepareFinalBattleBhashiva",
		"ScriptedEventPrepareFinalBattle",
		true,
		function(context)
			self:trigger_next_mission()
		end,
		false
	)

	core:add_listener(
		"ScriptedEventDiscoverIvoryRelicBhashiva",
		"ScriptedEventDiscoverIvoryRelic",
		true,
		function(context)
			self:handle_ivory_roads_relics_spawn()
		end,
		true
	)

	core:add_listener(
		"BhashivaNarrativeRelicsIncidentSelected",
		"UITrigger",
		function(context)
			return context:trigger() == "reveal_relics_incident_selected"
		end,
		function(context)
			local is_north = cm:is_region_owned_by_faction("wh3_main_combi_region_bloodpeak", self.config.faction_key)
			local is_south = cm:is_region_owned_by_faction("wh3_main_combi_region_amblepeak", self.config.faction_key) or
								cm:is_region_owned_by_faction("wh3_main_combi_region_the_maw_gate", self.config.faction_key)
			local regions_north = self.config.regions_with_relics.north
			local regions_south = self.config.regions_with_relics.south
			local regions_all = {}
			if is_north then
				self:reveal_regions(regions_north, "reveal_relics_north")
			elseif is_south then
				self:reveal_regions(regions_south, "reveal_relics_south")
			else
				for i=1, #regions_north do regions_all[#regions_all + 1] = regions_north[i] end
				for i=1, #regions_south do regions_all[#regions_all + 1] = regions_south[i] end
				self:reveal_regions(regions_all)
			end

			self:assign_settlement_relics(self.config.regions_with_relics_group_mountains, self.config.relics_region.factor_settlements_id, 1)
		end,
		true
	)

end

function bhashiva_campaign:handle_scripted_mission_reissue()
	local narrative_state_main = self.config.key_variables.narrative_state.main
	local mission_data = self.config.mission_data
	local faction_key = self.config.faction_key
	local faction = cm:get_faction(faction_key)

	local reissue = false

	if self.config.key_variables.narrative_state.main > 0 then
		self.config.key_variables.narrative_state.main = math.max(narrative_state_main - 1, 0)
		self:trigger_next_mission(nil, reissue)
	end
end

function bhashiva_campaign:trigger_next_mission(previous_mission, reissue)
	local faction_key = self.config.faction_key
	local faction_si = cm:get_faction(faction_key)
	local mission_data = self.config.mission_data

	if self.config.key_variables.narrative_state.main == 1 then
		if reissue ~= false then
			if not self.config.key_variables.relics_revealed then
				cm:add_turn_countdown_event(faction_key, 1, "ScriptedEventDelayRelicsReveal", faction_key)
				self.config.key_variables.relics_revealed = true
			end

			cm:trigger_incident(faction_key, self.config.incident_data.tiger_court_unlock, true)
		end

		self:trigger_mission(mission_data.second, faction_key, reissue)
	elseif self.config.key_variables.narrative_state.main == 2 then
		self:trigger_mission(mission_data.third, faction_key, reissue)
	elseif self.config.key_variables.narrative_state.main == 3 then
		self:trigger_mission(mission_data.fourth, faction_key, reissue)
	elseif self.config.key_variables.narrative_state.main == 4 then
		if reissue ~= false then
			cm:add_turn_countdown_event(faction_key, 1, "ScriptedEventMarkerDelayKhorne", faction_key)
		end

		self.config.key_variables.narrative_state.main = 5
	elseif self.config.key_variables.narrative_state.main == 5 then
		self:trigger_mission(mission_data.fifth_marker, faction_key, reissue)
	elseif self.config.key_variables.narrative_state.main == 6 then
		local marker_mission = mission_data.fifth_marker.key

		if reissue ~= false then
			if marker_mission == previous_mission.key then
				self:handle_chaos_invasion_start(previous_mission, faction_key)
			end
		end

		self:trigger_mission(mission_data.fifth_battle, faction_key, reissue)
	elseif self.config.key_variables.narrative_state.main == 7 then
		self:trigger_mission(mission_data.sixth, faction_key, reissue)
	elseif self.config.key_variables.narrative_state.main == 8 then
		if reissue ~= false then
			cm:add_turn_countdown_event(faction_key, 1, "ScriptedEventMarkerDelayNurgle", faction_key)
		end

		self.config.key_variables.narrative_state.main = 9
	elseif self.config.key_variables.narrative_state.main == 9 then
		self:trigger_mission(mission_data.seventh_marker, faction_key, reissue)
	elseif self.config.key_variables.narrative_state.main == 10 then
		local marker_mission = mission_data.seventh_marker.key
		
		if reissue ~= false then
			if marker_mission == previous_mission.key then
				self:handle_chaos_invasion_start(previous_mission, faction_key)
			end
		end

		self:trigger_mission(mission_data.seventh_battle, faction_key, reissue)
	elseif self.config.key_variables.narrative_state.main == 11 then
		self:trigger_mission(mission_data.eight, faction_key, reissue)
	elseif self.config.key_variables.narrative_state.main == 12 then
		if reissue ~= false then
			cm:add_turn_countdown_event(faction_key, 1, "ScriptedEventPrepareFinalBattle", faction_key)
		end

		self.config.key_variables.narrative_state.main = 13
	elseif self.config.key_variables.narrative_state.main == 13 then
		self.config.key_variables.narrative_state.main = 14
		if reissue ~= false then
			self:trigger_final_battle()
		end
	end
end

function bhashiva_campaign:handle_chaos_invasion_start(previous_mission, faction_key)
	cm:remove_interactable_campaign_marker("marker_" .. previous_mission.key)
	self:spawn_chaos_army_from_position(previous_mission, faction_key)
end

function bhashiva_campaign:trigger_mission(mission_data, faction_key, reissue)
	local faction_si = cm:get_faction(faction_key)
	local complete_mission = false -- If scripted condition can't be completed

	local mm = mission_manager:new(self.config.faction_key, mission_data.key)
	mm:set_mission_issuer("CLAN_ELDERS")
	
	-- setup conditions
	-- condition text
	if mission_data.objective_type == "SCRIPTED" and mission_data.objective then
		local objective_key = mission_data.condition_override_text
		local expected_value = mission_data.condition_value

		if mission_data.objective == "spend_relics" then
			if not self.config.key_variables.mission_variables.relics_spent then
				self.config.key_variables.mission_variables.relics_spent = {}
			end

			local objective_value = self.config.key_variables.mission_variables.relics_spent[mission_data.key] or 0
			local total_relics_spent = self.config.key_variables.total_relics_spent
			local max_relics = self.config.max_usable_relics

			mm:add_new_scripted_objective(
				objective_key,
				"PooledResourceChanged",
				function(context)
					local resource_amount = context:amount()
					local resource_key = context:resource():key()

					-- spend relics
					if resource_key == self.config.relics.key and resource_amount < 0 then
						objective_value = objective_value + (resource_amount * -1) -- record most relevant amount
						self.config.key_variables.mission_variables.relics_spent[mission_data.key] = objective_value

						self:updated_scripted_objective_count(mm, objective_key, objective_value, expected_value)

						if objective_value >= expected_value then
							return true
						end		
					end
				end,
				mission_data.condition_script
			)

			if total_relics_spent >= max_relics then
				complete_mission = true
				expected_value = 1
			elseif total_relics_spent + expected_value > max_relics then
				expected_value = max_relics - total_relics_spent
			end

			self:updated_scripted_objective_count(mm, objective_key, objective_value, expected_value, 0.5)
		elseif mission_data.objective == "win_x_battles" then
			if not self.config.key_variables.mission_variables.battles_won then
				self.config.key_variables.mission_variables.battles_won = {}
			end
			
			local objective_value = self.config.key_variables.mission_variables.battles_won[mission_data.key] or 0

			mm:add_new_scripted_objective(
				objective_key,
				"BattleConflictFinished",
				function(context)
					local pb = context:pending_battle()
					local attacker_faction = pb:attacker():faction()
					local defender_faction = pb:defender():faction()

					if attacker_faction:name() == faction_key or defender_faction:name() == faction_key then
						local winner = pb:attacker_won() and attacker_faction or defender_faction
						local defeated = not pb:attacker_won() and attacker_faction or defender_faction
						local winner_faction_key = winner:name()
						local defeated_character = not pb:attacker_won() and pb:attacker() or pb:defender()

						if winner_faction_key == faction_key then
							objective_value = objective_value + 1
							self.config.key_variables.mission_variables.battles_won[mission_data.key] = objective_value

							self:updated_scripted_objective_count(mm, objective_key, objective_value, expected_value, 0.5)

							if objective_value >= mission_data.condition_value then
								cm:set_active_mission_status_for_faction(cm:get_faction(faction_key), mission_data.key, "SUCCEEDED")
							end
						end
					end
				end,
				mission_data.condition_script
			)

			self:updated_scripted_objective_count(mm, objective_key, objective_value, expected_value, 0.5)
		elseif mission_data.objective == "turns_countdown" then
			if not self.config.key_variables.mission_variables.markers_spawned then
				self.config.key_variables.mission_variables.markers_spawned = {}
			end
			
			local objective_value = self.config.key_variables.mission_variables.markers_spawned[mission_data.key] or mission_data.condition_value

			mm:add_new_scripted_objective(
				objective_key,
				"FactionTurnStart",
				function(context)
					local faction_key = self.config.faction_key
					local faction_si = cm:get_faction(faction_key)
					if context:faction():name() == faction_key and cm:mission_is_active_for_faction(faction_si, mission_data.key) then
						objective_value = objective_value - 1
						self.config.key_variables.mission_variables.markers_spawned[mission_data.key] = objective_value

						self:updated_scripted_objective_count(mm, objective_key, objective_value, nil)
						
						if objective_value == 0 then
							cm:set_active_mission_status_for_faction(cm:get_faction(faction_key), mission_data.key, "CANCELLED")
							if mission_data.difficulty then
								mission_data.difficulty = 2
							end
							self:trigger_next_mission(mission_data)
						end
					end
				end,
				mission_data.condition_script
			)

			self:updated_scripted_objective_count(mm, objective_key, objective_value, nil, 0.5)
		end
		
	else
		mm:add_new_objective(mission_data.objective_type)

		if mission_data.condition_value then
			mm:add_condition("total " .. mission_data.condition_value)
		end

		if mission_data.condition_script then
			mm:add_condition("script_key " .. mission_data.condition_script)
		end
		
		if mission_data.condition_override_text then
			mm:add_condition("override_text " .. mission_data.condition_override_text)
		end
	end

	-- condition_engage_faction
	if mission_data.condition_engage_faction then
		mm:add_condition("faction " .. mission_data.condition_engage_faction)
		if mission_data.condition_engage_force then
			mm:add_condition("cqi " .. mission_data.condition_engage_force)
		end
		mm:add_condition("requires_victory")		
	end
		
	-- condition_regions
	if mission_data.condition_regions and next(mission_data.condition_regions) then
		local valid_regions = 0
		for i, region in ipairs(mission_data.condition_regions) do
			local region_si = cm:get_region(region)
			local faction_si = cm:get_faction(faction_key)
			if region_si:owning_faction() ~= faction_si then
				mm:add_condition("region " .. region)
				valid_regions = valid_regions + 1
			end
		end
	
		-- no valid conditions, skip mission
		if valid_regions == 0 then
			self.config.key_variables.narrative_state.main = self.config.key_variables.narrative_state.main + 1
			self:trigger_next_mission(mission_data)
			return
		end
	end

	-- setup payloads
	if mission_data.payloads and next(mission_data.payloads) then
		for i, payload in ipairs(mission_data.payloads) do
			mm:add_payload(payload)
		end
	else
		return -- no valid payload
	end

	if mission_data.spawn_marker and mission_data.chaos_god and reissue ~= false then
		local chaos_god = mission_data.chaos_god
		self:spawn_campaign_marker_from_character(mission_data.key, faction_key, chaos_god)

		local mission_position = self.config.key_variables.markers_x_y_locations[mission_data.key]

		mm:set_position(mission_position.x, mission_position.y)
	end

	if mission_data.narrative_state then
		self.config.key_variables.narrative_state.main = mission_data.narrative_state
	end

	if reissue ~= false then
		mm:trigger()
	else
		return
	end

	if mission_data.incident and reissue ~= false then
		cm:trigger_incident(faction_key, mission_data.incident, true)
	end

	if complete_mission then
		cm:callback(
			function()
				cm:set_active_mission_status_for_faction(cm:get_faction(faction_key), mission_data.key, "SUCCEEDED")
			end,
			2
		)
	end
end

function bhashiva_campaign:trigger_final_battle()
	cm:trigger_mission(self.config.faction_key, "wh3_cp1_qb_cth_bhashiva_final_battle", true);
end

--------------------------------------------------------------
-------------------------- UTILITY ---------------------------
--------------------------------------------------------------

function bhashiva_campaign:reveal_regions(region_set, with_cutscene)
	local faction_key = self.config.faction_key

	if not region_set then
		return
	end

	if with_cutscene and not cm:is_multiplayer() then
		if string.find(with_cutscene, "reveal_relics") then

			local camera_duration = 3
			local cam_x, cam_y, cam_d, cam_b, cam_h = cm:get_camera_position()
			local targ_x, targ_y, targ_d, targ_b, targ_h = cam_x, cam_y, cam_d, cam_b, cam_h
			
			if with_cutscene == "reveal_relics_north" then
				targ_x, targ_y, targ_d, targ_b, targ_h = 651.167297, 501.710754, 7.95152, -0.390983, 65.871941 -- optimal view north
			elseif with_cutscene == "reveal_relics_south" then
				targ_x, targ_y, targ_d, targ_b, targ_h = 678.49054, 364.693604, 7.703466, -0.391012, 63.418625 -- optimal view south
			end

			local targ_b = cam_b - 0.39

			local reveal_regions_with_relics = campaign_cutscene:new(
				"scroll_camera_for_region_reveal_bhashiva", 
				camera_duration + 4,
				function()
					for i, region_key in dpairs(region_set) do
						if region_key then
							cm:make_region_visible_in_shroud(faction_key, region_key)
						end
					end
					cm:set_camera_position(cam_x, cam_y, cam_d, cam_b, cam_h)
					cm:fade_scene(1, 1)
				end
			);
			
			reveal_regions_with_relics:set_skippable(true, {targ_x, targ_y, targ_d, targ_b, targ_h});
			reveal_regions_with_relics:set_dismiss_advice_on_end(false);
			reveal_regions_with_relics:set_use_cinematic_borders(true);
			reveal_regions_with_relics:set_disable_settlement_labels(false);
			reveal_regions_with_relics:set_restore_shroud(false);

			reveal_regions_with_relics:action(
				function()
					
				end,
				0
			)

			reveal_regions_with_relics:action(
				function()
					cm:scroll_camera_from_current(false, camera_duration, {targ_x, targ_y, targ_d, targ_b, targ_h})
				end,
				1
			)

			reveal_regions_with_relics:action(
				function()
					for i, region_key in dpairs(region_set) do
						if region_key then
							cm:make_region_visible_in_shroud(faction_key, region_key)
						end
					end
				end,
				camera_duration + 1
			);

			reveal_regions_with_relics:action(
				function()
					cm:fade_scene(0, 1)
				end,
				camera_duration + 3
			)

			reveal_regions_with_relics:start()
		end
	else
		for i, region_key in dpairs(region_set) do
			if region_key then
				cm:make_region_visible_in_shroud(faction_key, region_key)
			end
		end
	end
end

function bhashiva_campaign:trigger_dilemma(dilemma)
	local faction_key = self.config.faction_key
	
	cm:trigger_dilemma(faction_key, dilemma.key)
end

function bhashiva_campaign:updated_scripted_objective_count(mission_manager, objective_key, objective_value, expected_value, delay)
	local delay = delay or 0
	local objectives_count = objective_value or 0
	cm:callback(
		function()
			mission_manager:update_scripted_objective_text(
				objective_key,
				objectives_count,
				expected_value
			)
		end,
		delay
	)
end

function bhashiva_campaign:spawn_campaign_marker_from_character(mission_key, faction_key, chaos_god)
	local distance = self.config.marker.distance
	local tries = 1
	local max_tries = 5
	local character = self:get_available_character(faction_key)
	local spawn_x, spawn_y

	if character and not character:is_null_interface() then
		spawn_x, spawn_y = cm:find_valid_spawn_location_for_character_from_character(faction_key, cm:char_lookup_str(character:command_queue_index()), false, distance)

		while spawn_x == -1 and tries <= max_tries do
			distance = math.round(distance / 1.25)
			tries = tries + 1
			spawn_x, spawn_y = cm:find_valid_spawn_location_for_character_from_character(faction_key, cm:char_lookup_str(character:command_queue_index()), false, distance)
		end
	else -- backup if all characters are dead
		local settlement = self:get_available_settlement(faction_key)

		if settlement and not settlement:is_null_interface() then
			spawn_x, spawn_y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, settlement:name(), false, true, distance)
			
			while spawn_x == -1 and tries <= max_tries do
				distance = math.round(distance / 1.25)
				tries = tries + 1
				spawn_x, spawn_y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, settlement:name(), false, false, distance)
			end
		end
	end
	
	if spawn_x == -1 then
		return
	end

	cm:add_interactable_campaign_marker("marker_" .. mission_key, self.config.marker.key .. chaos_god, spawn_x, spawn_y, self.config.marker.radius, cm:get_faction(faction_key):name(), "")
	
	local spawn_x_y = {x = spawn_x, y = spawn_y}
	self.config.key_variables.markers_x_y_locations[mission_key] = spawn_x_y -- record coordinates

	if cm:get_local_faction_name(true) == faction_key then
		local display_x, display_y = cm:log_to_dis(spawn_x, spawn_y)
		local cached_x, cached_y, cached_d, cached_b, cached_h = cm:get_camera_position()
		cm:scroll_camera_from_current(false, self.config.marker.camera_scroll_speed, {display_x, display_y, cached_d, 0, cached_h})
	end
end

function bhashiva_campaign:find_army_spawn_location_from_position(invasion_faction_key, pos_x, pos_y, distance_min, distance_max)
	local distance_x = cm:random_number(distance_max, distance_min)
	if cm:random_number(100, 1) > 50 then
		distance_x = distance_x * -1
	end
	pos_x = pos_x + distance_x

	local distance_y = cm:random_number(distance_max, distance_min)
	if cm:random_number(100, 1) > 50 then
		distance_y = distance_y * -1
	end
	pos_y = pos_y + distance_y

	local spawn_x, spawn_y = cm:find_valid_spawn_location_for_army_from_position(invasion_faction_key, pos_x, pos_y, true)

	if spawn_x == -1 then
		spawn_x, spawn_y = cm:find_valid_spawn_location_for_army_from_position(invasion_faction_key, pos_x, pos_y, false)
	end

	return spawn_x, spawn_y
end

function bhashiva_campaign:spawn_chaos_army_from_position(mission_data, faction_key)
	local mission_key = mission_data.key
	local chaos_god = mission_data.chaos_god
	local difficulty = mission_data.difficulty or 1

	if not mission_key or not chaos_god then
		script_error("ERROR: Failed to find proper mission configuration")
		return
	end

	local faction_si = cm:get_faction(faction_key)
	local faction_leader = faction_si:faction_leader()
	local invasion_data = self.config.invasion
	local invasion_faction_key = invasion_data.faction_keys[chaos_god]
	local invasion_key = "cp1_bhashiva_invasion_" .. mission_key

	local distance_min = invasion_data.distance_min
	local distance_max = invasion_data.distance_max
	local marker_x = self.config.key_variables.markers_x_y_locations[mission_key].x
	local marker_y = self.config.key_variables.markers_x_y_locations[mission_key].y
	local spawn_x = -1
	local spawn_y = -1
	local tries = 0
	local max_tries = 10
	while spawn_x == -1 and tries < max_tries do
		spawn_x, spawn_y = self:find_army_spawn_location_from_position(invasion_faction_key, marker_x, marker_y, distance_min, distance_max)
		tries = tries + 1
	end
	if spawn_x == -1 then
		-- Fallback: Since we've pinged the marker, it should be valid...
		spawn_x, spawn_y = self:find_army_spawn_location_from_position(invasion_faction_key, marker_x, marker_y, 0, 0)
		if spawn_x == -1 then
			-- ...but you never know!
			script_error("ERROR: Failed to spawn army for invasion " .. invasion_key)
			return
		end
	end

	local unit_list = self:create_invasion_force(chaos_god, difficulty)
	local spawn_x_y = {spawn_x, spawn_y}	
	local chaos_invasion = invasion_manager:new_invasion(invasion_key, invasion_faction_key, unit_list, spawn_x_y)

	if is_nil(chaos_invasion) then
		return
	end

	if not cm:is_multiplayer() then
		if faction_si:is_null_interface() == false and faction_si:has_faction_leader() == true then
			if faction_leader:is_null_interface() == false and faction_leader:has_military_force() == true then
				local faction_leader_cqi = faction_leader:command_queue_index()
				chaos_invasion:set_target("CHARACTER", faction_leader_cqi, faction_key)
			else
				chaos_invasion:set_target("NONE", nil, faction_key)
			end
		end
		
		-- Add army XP based on difficulty in SP
		local difficulty = cm:model():difficulty_level()
		
		if difficulty == -1 then
			-- Hard
			chaos_invasion:add_unit_experience(2)
		elseif difficulty == -2 then
			-- Very Hard
			chaos_invasion:add_unit_experience(4)
		elseif difficulty == -3 then
			-- Legendary
			chaos_invasion:add_unit_experience(7)
		end
	end
	
	-- Set up the General
	local invasion_general = invasion_data.general
	chaos_invasion:create_general(false,
									invasion_general[chaos_god].agent_subtype,
									invasion_general[chaos_god].forename,
									invasion_general[chaos_god].clan_name,
									invasion_general[chaos_god].family_name,
									invasion_general[chaos_god].other_name
								)
	chaos_invasion:add_character_experience(15, true)
	chaos_invasion:apply_effect(invasion_general[chaos_god].effect_bundle, -1)
	chaos_invasion:add_aggro_radius(25)
	chaos_invasion:start_invasion(true, true, false, false)
end

function bhashiva_campaign:create_invasion_force(chaos_god, difficulty)

	local ram = random_army_manager
	local ram_name = "cp1_bhashiva_invasion_"..chaos_god
	ram:remove_force(ram_name)
	ram:new_force(ram_name)

	local god_units = self.config.invasion.units
	local number_of_units = 19 -- default limit
	local difficulty_value = ((difficulty > 1) and 5 or 0)
	
	if chaos_god == "khorne" then
		number_of_units = 14 + difficulty_value
		ram:add_mandatory_unit(ram_name, "wh3_main_kho_inf_bloodletters_1", 2)	
		ram:add_mandatory_unit(ram_name, "wh3_main_kho_cav_gorebeast_chariot", 1)
		ram:add_mandatory_unit(ram_name, "wh3_main_kho_veh_skullcannon_0", 1)
	elseif chaos_god == "nurgle" then
		number_of_units = 14 + difficulty_value
		ram:add_mandatory_unit(ram_name, "wh3_main_nur_inf_plaguebearers_1", 2)	
		ram:add_mandatory_unit(ram_name, "wh3_dlc25_nur_cav_rot_knights", 1)
		ram:add_mandatory_unit(ram_name, "wh_main_chs_art_hellcannon", 1)
	end

	ram:add_unit(ram_name, god_units[chaos_god].inf_low, 8)
	ram:add_unit(ram_name, god_units[chaos_god].inf_low_special, 8)
	ram:add_unit(ram_name, god_units[chaos_god].inf_high, 6)
	ram:add_unit(ram_name, god_units[chaos_god].inf_high_special, 6)
	ram:add_unit(ram_name, god_units[chaos_god].cav_low, 8)
	ram:add_unit(ram_name, god_units[chaos_god].cav_high, 6)
	ram:add_unit(ram_name, god_units[chaos_god].monster_low, 8)
	ram:add_unit(ram_name, god_units[chaos_god].monster_med, 6)
	ram:add_unit(ram_name, god_units[chaos_god].monster_high, 4)

	return ram:generate_force(ram_name, number_of_units, false)
end

function bhashiva_campaign:get_available_character(faction_key)
	local faction_si = cm:get_faction(faction_key)
	local faction_leader = faction_si:faction_leader()

	if faction_leader 
		and faction_leader:is_null_interface() == false 
		and faction_leader:is_wounded() == false 
		and faction_leader:has_military_force()
		and faction_leader:military_force():unit_list():num_items() > 1 then
			return faction_leader
	end

	local valid_target_chars = {}
	local random_char = false
	local character_list = faction_si:character_list()
	for i, character in model_pairs(character_list) do
		if cm:char_is_general_with_army(character) 
			and not character:military_force():is_armed_citizenry() 
			and character:has_military_force() then
				table.insert(valid_target_chars, character)
		end
	end

	if #valid_target_chars > 0 then
		random_char = valid_target_chars[cm:random_number(#valid_target_chars)]
	else 
		return false
	end

	return random_char
end

function bhashiva_campaign:get_available_settlement(faction_key)
	local faction_si = cm:get_faction(faction_key)
	local faction_leader = faction_si:faction_leader()

	if faction_si:has_home_region() == false then
		return false
	end

	local region_list = faction_si:region_list()
	local region_list_number = region_list:num_items()
	local random_settlement

	if region_list_number > 0 then
		random_settlement = region_list:item_at(cm:random_number(region_list_number))
	else 
		return false
	end

	return random_settlement
end

function bhashiva_campaign:assign_settlement_relics(settlement_list, factor, value)
	local region_list_si = cm:model():world():lookup_regions_from_region_group(settlement_list)
	local faction_si = cm:get_faction(self.config.faction_key)

	if region_list_si then
		for i = 0, region_list_si:num_items() - 1 do
			local region = region_list_si:item_at(i)
			local relics_value = region:pooled_resource_manager():resource("wh3_cp1_cth_relics_settlements"):value()

			if region then
				if region:owning_faction() ~= faction_si then
					if value > 0 then
						cm:entity_add_pooled_resource_transaction(region, factor, value)
					elseif value < 0 and relics_value > 0 then
						cm:entity_add_pooled_resource_transaction(region, factor, value)
					end
				end
			end
		end
	end
end

function bhashiva_campaign:clean_relic_settlements()
	local relics_regions = {
		regions_with_relics_group_starting = self.config.regions_with_relics_group_starting,
		regions_with_relics_group_mountains = self.config.regions_with_relics_group_mountains,
		regions_with_relics_group_ivory_roads = self.config.regions_with_relics_group_ivory_roads,
	}
	
	if cm:turn_number() >= 20 then -- remove after turn 20, so it doesn't distrub debug
		for i, region_set in pairs(relics_regions) do
			self:assign_settlement_relics(region_set, self.config.relics_region.factor_other, -1)
		end
	end
end

function bhashiva_campaign:handle_ivory_roads_relics_spawn()
	local faction_key = self.config.faction_key
	local faction_cqi = cm:get_faction(faction_key):command_queue_index()
	local max_relics = self.config.max_usable_relics
	
	if self.config.key_variables.total_relics_collected >= max_relics then
		return
	end

	if #self.config.key_variables.ivory_road_regions > 0 then
		local random_region = cm:random_number(#self.config.key_variables.ivory_road_regions)
		local region_key = self.config.key_variables.ivory_road_regions[random_region]
		local region_si = cm:get_region(region_key)
		local region_cqi = region_si:cqi()

		table.remove(self.config.key_variables.ivory_road_regions, random_region)

		cm:entity_add_pooled_resource_transaction(region_si, self.config.relics_region.factor_settlements_id, 1)
		cm:trigger_incident_with_targets(faction_cqi, self.config.incident_data.relics_reminder, 0, 0, 0, 0, region_cqi, 0)
	end	
end

function bhashiva_campaign:handle_regular_relics_reminder()
	local faction_key = self.config.faction_key
	local faction_cqi = cm:get_faction(faction_key):command_queue_index()
	local starting_relic_regions = self.config.regions_with_relics_group_starting
	local max_relics = self.config.max_usable_relics

	if self.config.key_variables.total_relics_collected >= max_relics then
		return
	end

	local region_list_si = cm:model():world():lookup_regions_from_region_group(starting_relic_regions)
	local faction_si = cm:get_faction(self.config.faction_key)

	if region_list_si and region_list_si:num_items() > 1 then
		for i = 0, region_list_si:num_items() - 1 do
			local random_roll = cm:random_number(region_list_si:num_items())
			local region_si = region_list_si:item_at(random_roll)
			if region_si then
				local relics_value = region_si:pooled_resource_manager():resource("wh3_cp1_cth_relics_settlements"):value()
				if relics_value > 0 then
					local reveal_region = {region_si:name()}

					cm:trigger_incident_with_targets(faction_cqi, self.config.incident_data.relics_reminder, 0, 0, 0, 0, region_si:cqi(), 0)
					self:reveal_regions(reveal_region)

					return
				end
			end
		end
	end
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("bhashiva_key_variables_save", bhashiva_campaign.config.key_variables, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			bhashiva_campaign.config.key_variables = cm:load_named_value("bhashiva_key_variables_save", bhashiva_campaign.config.key_variables, context)
			bhashiva_campaign.config.key_variables.mission_variables = bhashiva_campaign.config.key_variables.mission_variables or {}
			bhashiva_campaign.config.key_variables.incidents_shown = bhashiva_campaign.config.key_variables.incidents_shown or {}
			bhashiva_campaign.config.key_variables.total_relics_spent = bhashiva_campaign.config.key_variables.total_relics_spent or 0
			bhashiva_campaign.config.key_variables.total_relics_collected = bhashiva_campaign.config.key_variables.total_relics_collected or 0
		end
	end
)