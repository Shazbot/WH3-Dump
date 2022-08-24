greater_daemons = {
	character_types = {
		wh3_main_kho_herald_of_khorne = {
			agent = "wh3_main_kho_exalted_bloodthirster", 
			dilemma = "wh3_main_dilemma_exalted_greater_daemon_kho",
			incident = "wh3_main_incident_exalted_greater_daemon",
			achievement_suffix = "kho"
		},
		wh3_main_nur_herald_of_nurgle_death	= {
			agent = "wh3_main_nur_exalted_great_unclean_one_death",
			dilemma = "wh3_main_dilemma_exalted_greater_daemon_nur",
			incident = "wh3_main_incident_exalted_greater_daemon",
			achievement_suffix = "nur"
		},
		wh3_main_nur_herald_of_nurgle_nurgle = {
			agent = "wh3_main_nur_exalted_great_unclean_one_nurgle",
			dilemma = "wh3_main_dilemma_exalted_greater_daemon_nur",
			incident = "wh3_main_incident_exalted_greater_daemon",
			achievement_suffix = "nur"
		},
		wh3_main_sla_herald_of_slaanesh_shadow	= {
			agent = "wh3_main_sla_exalted_keeper_of_secrets_shadow",
			dilemma = "wh3_main_dilemma_exalted_greater_daemon_sla",
			incident = "wh3_main_incident_exalted_greater_daemon",
			achievement_suffix = "sla"
		},
		wh3_main_sla_herald_of_slaanesh_slaanesh = {
			agent = "wh3_main_sla_exalted_keeper_of_secrets_slaanesh",
			dilemma = "wh3_main_dilemma_exalted_greater_daemon_sla",
			incident = "wh3_main_incident_exalted_greater_daemon",
			achievement_suffix = "sla"
		},
		wh3_main_tze_herald_of_tzeentch_metal = {
			agent = "wh3_main_tze_exalted_lord_of_change_metal",
			dilemma = "wh3_main_dilemma_exalted_greater_daemon_tze",
			incident = "wh3_main_incident_exalted_greater_daemon",
			achievement_suffix = "tze"
		},
		wh3_main_tze_herald_of_tzeentch_tzeentch = {
			agent = "wh3_main_tze_exalted_lord_of_change_tzeentch",
			dilemma = "wh3_main_dilemma_exalted_greater_daemon_tze",
			incident = "wh3_main_incident_exalted_greater_daemon",
			achievement_suffix = "tze"
		},
		wh3_dlc20_chs_lord_mkho = {
			agent = "wh3_dlc20_chs_daemon_prince_khorne",
			dilemma = "wh3_dlc20_dilemma_daemon_prince_ascension",
			incident = "wh3_dlc20_incident_daemon_prince_ascension"
		},
		wh3_dlc20_chs_lord_msla						= {
			agent = "wh3_dlc20_chs_daemon_prince_slaanesh",
			dilemma = "wh3_dlc20_dilemma_daemon_prince_ascension",
			incident = "wh3_dlc20_incident_daemon_prince_ascension"
		},
		wh3_dlc20_chs_sorcerer_lord_death_mnur			= {
			agent = "wh3_dlc20_chs_daemon_prince_nurgle",
			dilemma = "wh3_dlc20_dilemma_daemon_prince_ascension",
			incident = "wh3_dlc20_incident_daemon_prince_ascension"
		},
		wh3_dlc20_chs_sorcerer_lord_nurgle_mnur			= {
			agent = "wh3_dlc20_chs_daemon_prince_nurgle",
			dilemma = "wh3_dlc20_dilemma_daemon_prince_ascension",
			incident = "wh3_dlc20_incident_daemon_prince_ascension"
		},
		wh3_dlc20_chs_sorcerer_lord_metal_mtze			= {
			agent = "wh3_dlc20_chs_daemon_prince_tzeentch", 
			dilemma = "wh3_dlc20_dilemma_daemon_prince_ascension",
			incident = "wh3_dlc20_incident_daemon_prince_ascension",
		},
		wh3_dlc20_chs_sorcerer_lord_tzeentch_mtze		= {
			agent =  "wh3_dlc20_chs_daemon_prince_tzeentch",
			dilemma = "wh3_dlc20_dilemma_daemon_prince_ascension",
			incident = "wh3_dlc20_incident_daemon_prince_ascension"
		}
	},

	xp_preserved_on_conversion = 0.5,
	required_level_for_dilemma = 15,
	delay_before_new_dilemma = 10,
	ai_upgrade_chance = 25,
	agent_type = "general",

	valid_cultures = {
		wh3_main_dae_daemons = true,
		wh3_main_kho_khorne = true,
		wh3_main_nur_nurgle = true,
		wh3_main_sla_slaanesh = true,
		wh3_main_tze_tzeentch = true,
	},

	valid_dilemmas = {} -- populated automatically on startup
}

function greater_daemons:setup_greater_daemons()
	for k, character in pairs(self.character_types) do
		local dilemma_to_add = character.dilemma
		self.valid_dilemmas[dilemma_to_add] = true
	end

	core:add_listener(
		"greater_daemons_rank_up",
		"FactionTurnStart",
		function(context)
			local culture = context:faction():culture()
			return self.valid_cultures[culture] ~= nil
		end,
		function(context)
			local faction = context:faction()
			local mf_list = faction:military_force_list()

			-- find any valid characters
			for i = 0, mf_list:num_items() - 1 do
				local current_general = mf_list:item_at(i):general_character()
				local current_general_subtype = current_general:character_subtype_key()
				local upgrade_details = self.character_types[current_general_subtype]

				if current_general:rank() >= self.required_level_for_dilemma and upgrade_details and current_general:has_region() and not current_general:is_besieging() and not current_general:is_faction_leader() then
					if faction:is_human() then
						local original_character_cqi = current_general:command_queue_index()
						local character_list = cm:get_saved_value("player_herald_lords_to_ignore_rankup") or {}
						local character_is_valid = true

						-- check if the character has already been ignored by the player
						for j = 1, #character_list do
							if original_character_cqi == character_list[j] then
								character_is_valid = false
							end
						end

						if character_is_valid and upgrade_details.dilemma then
							-- Send successful event with character CQI.
							core:trigger_event("ScriptEventHeraldUpgradeChance", cm:get_character_by_cqi(original_character_cqi))

							local function trigger_upgrade_dilemma()
								cm:trigger_dilemma_with_targets(faction:command_queue_index(), upgrade_details.dilemma, 0, 0, original_character_cqi, 0, 0, 0)

								core:add_listener(
									"wh3_main_dilemma_exalted_greater_daemon_choice",
									"DilemmaChoiceMadeEvent",
									function(context)
										return self.valid_dilemmas[context:dilemma()]
									end,
									function(context)
										local choice = context:choice()
										
										if choice == 0 then
											if upgrade_details.achievement_suffix then 
												core:trigger_custom_event("ScriptEventPlayerReplacesHerald", {race = upgrade_details.achievement_suffix, faction = context:faction()})
											end
											
											cm:callback(function() self:upgrade_herald(current_general) end, 0.4)
										else
											if choice == 1 then
												-- ask again later
												cm:add_turn_countdown_event(context:faction():name(), self.delay_before_new_dilemma, "ScriptEventHeraldUpgradeCooldownExpired", tostring(original_character_cqi))
											end
											
											-- keep track of this cqi to ask again later (or permanently ignore)
											table.insert(character_list, original_character_cqi)
											cm:set_saved_value("player_herald_lords_to_ignore_rankup", character_list)
										end
									end,
									false
								)
							end
							
							if cm:is_multiplayer() then
								trigger_upgrade_dilemma()
							else
								cm:trigger_transient_intervention(
									"herald_upgrade_intervention",
									function(intervention)
										intervention:scroll_camera_for_intervention(
											nil,
											current_general:display_position_x(),
											current_general:display_position_y(),
											"",
											nil,
											nil,
											nil,
											function()
												trigger_upgrade_dilemma()
											end
										)
									end
								)
							end
						
							-- just deal with one character per turn
							break
						end
					-- random roll for the ai
					elseif cm:random_number()<= self.ai_upgrade_chance then
						greater_daemons:upgrade_herald(current_general)
					end
				end
			end
		end,
		true
	)
	
	core:add_listener(
		"remove_herald_cqi",
		"ScriptEventHeraldUpgradeCooldownExpired",
		true,
		function(context)
			local character_list = cm:get_saved_value("player_herald_lords_to_ignore_rankup")
			
			-- remove the character cqi, so we can ask again
			for i = 1, #character_list do
				if tonumber(context.string) == character_list[i] then
					table.remove(character_list, i)
					break
				end
			end
			
			cm:set_saved_value("player_herald_lords_to_ignore_rankup", character_list)
		end,
		true
	)
end

function greater_daemons:upgrade_herald(character)
	
	if not character then
		script_error("ERROR: upgrade_herald() could not find character, have they died? They will not get upgraded")
		return
	end

	local target_subtype = self.character_types[character:character_subtype_key()].agent
	local incident = self.character_types[character:character_subtype_key()].incident

	CUS:convert_character(character, self.agent_type, target_subtype, self.xp_preserved_on_conversion, incident)

end