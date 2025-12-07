sayl_narrative = {
	faction_key = "wh3_dlc27_nor_sayl",
	requirement_to_unlock = "nor_dark_allegiance_unlock_settlement_requirement",	-- number of settlements
	pooled_resource = "wh3_dlc27_nor_sayl_dark_ritual",
	arcane_power = "wh3_dlc27_nor_sayl_dark_ritual",
	altar_occupation_option_id = "2074767882",
	-- factors
	altars_factor = "wh3_dlc27_altars_change",
	missions_factor = "missions",
	-- change values
	altar_gained = 1,
	altar_lost = -1,
	pr_kill_mod = 0.01,
	pr_caster_bonus = 50,
	chaos_god_hero_level_spawn = 10,
	-- missions setup
	intro_mission = "wh3_dlc27_nor_sayl_intro_mission",
	intro_objective = "wh3_dlc27_nor_sayl_intro_objective",
	intro_incident = "wh3_dlc27_nor_sayl_intro_incident",
	intro_occupation_id = "2074767882",
	-- altar main Building chains
	altar_main_building_chains = {
		"wh3_dlc27_settlement_nor_chaos_altar_kho",
		"wh3_dlc27_settlement_nor_chaos_altar_kho_special_gate",
		"wh3_dlc27_settlement_nor_chaos_altar_kho_special_port",
		"wh3_dlc27_settlement_nor_chaos_altar_nur",
		"wh3_dlc27_settlement_nor_chaos_altar_nur_special_gate",
		"wh3_dlc27_settlement_nor_chaos_altar_nur_special_port",
		"wh3_dlc27_settlement_nor_chaos_altar_sla",
		"wh3_dlc27_settlement_nor_chaos_altar_sla_special_gate",
		"wh3_dlc27_settlement_nor_chaos_altar_sla_special_port",
		"wh3_dlc27_settlement_nor_chaos_altar_tze",
		"wh3_dlc27_settlement_nor_chaos_altar_tze_special_gate",
		"wh3_dlc27_settlement_nor_chaos_altar_tze_special_port",
		"wh3_dlc27_settlement_nor_chaos_altar_und",
		"wh3_dlc27_settlement_nor_chaos_altar_und_special_gate",
		"wh3_dlc27_settlement_nor_chaos_altar_und_special_port",
	},
	mission_prefix = "wh3_dlc27_nor_sayl_narrative_",
	--make sure threshold match data thresholds
	mission_status = {
		["emp"] 	= {
			trigger_amount = 4, 
			has_spawned = false, 
			is_completed = false, 
			set_piece_key = "wh3_dlc27_qb_nor_sayl_winds_of_magic_emp_light_beasts", 
			manipulation_ritual_tier = "tier_1",
			dark_ritual_effect_bundle = "wh3_dlc27_nor_sayl_narrative_t1_battle"
		},
		["hef"]	= {
			trigger_amount = 10, 
			has_spawned = false, 
			is_completed = false,
			prev_mission_requirement = "emp", 
			set_piece_key = "wh3_dlc27_qb_nor_sayl_winds_of_magic_hef_fire_metal", 
			manipulation_ritual_tier = "tier_2",
			dark_ritual_effect_bundle = "wh3_dlc27_nor_sayl_narrative_t2_battle"
		},
		["lzd"]	= {
			trigger_amount = 18, 
			has_spawned = false, 
			is_completed = false,
			prev_mission_requirement = "hef",
			set_piece_key = "wh3_dlc27_qb_nor_sayl_winds_of_magic_lzd_life_death", 
			manipulation_ritual_tier = "tier_3",
			dark_ritual_effect_bundle = "wh3_dlc27_nor_sayl_narrative_t3_battle"
		},
		["final"] 	= {
			trigger_amount = 30, 
			has_spawned = false, 
			is_completed = false,
			single_player_only = true,
			prev_mission_requirement = "lzd",
			set_piece_key = "wh3_dlc27_qb_nor_sayl_final_battle"
		}
	},
	dilemma_status = {
		["wh3_dlc27_nor_sayl_champion_crow_eagle"] = {
			trigger_amount = 10,
			has_spawned = false,
			spawn_on_board = false,
			dilemma_choices = {
				[0] = {
					key="763392727", -- for general champions, use the ID from start_pos_characters 
					type="general", 

				},
				[1] = {
					key="1265315403", -- for general champions, use the ID from start_pos_characters 
					type="general",
				},
			},
		},
		["wh3_dlc27_nor_sayl_champion_hound_serpent"] = {
			trigger_amount = 18,
			has_spawned = false,
			spawn_on_board = true,
			dilemma_choices = {
				[0] = {
					key="wh3_main_ie_nor_killgore_slaymaim",
					type="champion",
				},
				[1] = {
					key="wh_dlc08_nor_kihar",
					type="wizard",
				},
			},
		},
	},

	final_battle_victory_condition = "sayl_final_battle",

	-- Trait awarded to Sayl after winning the final battle
	final_battle_trait_key = "wh3_dlc27_trait_sayl_final",

}

function sayl_narrative:initialise()
	--check Sayl faction exists
	if not cm:get_faction(self.faction_key) then return end

	if cm:is_new_game() then 
		sayl_narrative:setup_champion_locks()
		local sayl_faction = cm:get_faction(self.faction_key)
		local ritual_list = sayl_manipulation.config.ritual_unlock_levels["tier_0"].rituals
		for i = 1, #ritual_list do
			cm:set_script_state(sayl_faction, "unlocked_manipulation_" .. ritual_list[i], true);
		end
	end

	--check Sayl faction is human
	if cm:get_faction(self.faction_key):is_human() then

		--set Narrative feature ui until intror mission completed
		self:set_feature_locked_state()

		self:intro_mission_listeners()
		-- sayl obtains an altar
		core:add_listener(
			"SettlementOccupationAltar",
			"CharacterPerformsSettlementOccupationDecision",
			function(context)
				local sayl_faction_key = self.faction_key
				local previous_owner_key = context:previous_owner()
				
				if previous_owner_key ~= nil then
					return previous_owner_key ~= sayl_faction_key and context:occupation_decision() == self.altar_occupation_option_id
				end
			end,
			function(context)
				self:update_resource(self.altar_gained)
			end,
			true
		)

		core:add_listener(
			"TerritoryGivenDiplomacy",
			"RegionFactionChangeEvent",
			function(context)
				local previous_owner = context:previous_faction()
				local region = context:region()
				local new_owner = region:owning_faction()
				if previous_owner:is_null_interface() == false and new_owner:is_null_interface() == false then
					return previous_owner:name() ~= self.faction_key
							and new_owner:name() == self.faction_key
							and context:reason() == "diplomacy trade"
				end
			end,
			function(context)
				local is_altar = self:settlement_type_post_battle_event_check(context)

				if is_altar then
					self:update_resource(self.altar_gained)
				end
			end,
			true
		)

		-- check if sayl lost a region
		core:add_listener(
			"TreacheryRegionFactionChangeEvent",
			"PreRegionFactionChangeEvent",
			function(context)
				local previous_owner = context:previous_faction()
				local sayl_faction = cm:get_faction(self.faction_key)

				return previous_owner ~= nil and previous_owner == sayl_faction
			end,
			function(context)
				local is_altar = self:settlement_type_post_battle_event_check(context)
				if is_altar then
					self:update_resource(self.altar_lost)
				end
			end,
			true
		)

		--Mission completed check
		core:add_listener(
			"MissionSucceeded_SaylNarrative",
			"MissionSucceeded",
			function(context)
				return string.find(context:mission():mission_record_key(), self.mission_prefix)
			end,
			function(context)	
				local s_length = string.len(self.mission_prefix) + 1
				local indentifier = string.sub(context:mission():mission_record_key(), s_length)
				local mission_data = self.mission_status	
				mission_data[indentifier].is_completed = true
				
				if string.find(context:mission():mission_record_key(), "final") then
					cm:set_saved_value("campaign_completed", true)
					cm:complete_scripted_mission_objective(self.faction_key, "wh_main_long_victory", self.final_battle_victory_condition, true)
				
					-- Award trait to Sayl after the final battle victory
					local faction = cm:get_faction(self.faction_key)
					if faction and faction:is_null_interface() == false then
						local leader = faction:faction_leader()
						if leader and leader:is_null_interface() == false then
							cm:force_add_trait(cm:char_lookup_str(leader:command_queue_index()), self.final_battle_trait_key, true)
						end
					end
				else
					--check if the mission payload unlocked another mission threshold
					self:check_mission_threshold()

					--trigger a dilemma for chaos champion recruitment
					self:check_dilemma_threshold()

					--unlock new manipulation rituals tier 
					sayl_manipulation.dynamic_data.current_tier_unlocked = mission_data[indentifier].manipulation_ritual_tier
					sayl_manipulation:set_rituals_availability_for_level(mission_data[indentifier].manipulation_ritual_tier, true)
					local sayl_faction = cm:get_faction(self.faction_key)
					if sayl_faction then
						local ritual_list = sayl_manipulation.config.ritual_unlock_levels[sayl_manipulation.dynamic_data.current_tier_unlocked].rituals
						for i = 1, #ritual_list do
							cm:set_script_state(sayl_faction, "unlocked_manipulation_" .. ritual_list[i], true);
						end
					end
					if mission_data[indentifier].dark_ritual_effect_bundle then 
						cm:apply_effect_bundle(mission_data[indentifier].dark_ritual_effect_bundle, self.faction_key, 0)
					end
				end
			end,
			true
		)

		core:add_listener(
			"sayl_dilemma_choice_made",
			"DilemmaChoiceMadeEvent",
			function(context)
				return self.dilemma_status[context:dilemma()] 
			end,
			function(context) 
				local choice = context:choice()
				local dilemma = context:dilemma()
				local faction = cm:get_faction(self.faction_key)

				if self.dilemma_status[dilemma].dilemma_choices[choice] then
					local char = self.dilemma_status[dilemma].dilemma_choices[choice].key

					if self.dilemma_status[dilemma].spawn_on_board then
						
						core:add_listener(
							"sayl_chaos_god_spawned_champion",
							"UniqueAgentSpawned",
							true,
							function(context)
								local character_interface = context:unique_agent_details():character()
								local char_lookup_str = cm:char_lookup_str(character_interface)
								local spawn_rank = self.chaos_god_hero_level_spawn or 0

								if character_interface:rank() < spawn_rank then
									cm:add_agent_experience(char_lookup_str, spawn_rank, true)
								end

								cm:replenish_action_points(char_lookup_str)
								CampaignUI.ClearSelection()
							end,
							false
						)
						
						cm:spawn_unique_agent(faction:command_queue_index(), char, false)
					else 
						cm:unlock_starting_character_recruitment(char, self.faction_key)
					end
				end

			end,
			true
		)

		
		core:add_listener(
			"chaos_god_spawned_grant_experience",
			"CharacterCreated",
			function(context)

				if context:character():faction():name() == self.faction_key then 
					local subtype_key = context:character():character_subtype_key()

					for dilemma, data in dpairs(self.dilemma_status) do	
						for dilemma_choice, agent_subtype in dpairs(data.dilemma_choices) do
							if agent_subtype == subtype_key then
								return true
							end
						end
					end
				end
				return false
			end,
			function(context)
				local character = context:character()
				
				cm:add_agent_experience(cm:char_lookup_str(character:command_queue_index()), self.chaos_god_hero_level_spawn, true)
			end,
			true
		)
		
	end
end

function sayl_narrative:settlement_type_post_battle_event_check(context)
	local region = context:region()
	local region_main_slot = region:slot_list():item_at(0)
	local region_building_chain = region_main_slot:building():chain()

	if not region:is_null_interface() then
		for _, listed_building_chain in ipairs(self.altar_main_building_chains) do
			if region_building_chain == listed_building_chain then
				return true
			end
		end
	else
		return false
	end
end


function sayl_narrative:set_feature_locked_state()
	
	local sayl_faction = cm:get_faction(self.faction_key)

	core:add_listener(
		"SaylSettlementNumberTrackUnlock",
		"RegionFactionChangeEvent",
		function(context)
			local region = context:region()
			local previous_faction = context:previous_faction()
			local new_owner = region:owning_faction()
			return sayl_faction:is_null_interface() == false
					and previous_faction ~= sayl_faction
					and new_owner == sayl_faction
		end,
		function(context)
			if sayl_faction:is_null_interface() == false and sayl_faction:num_regions() >= cm:campaign_var_int_value(self.requirement_to_unlock) then
				uim:override("aethyr_winds_progress_bar"):unlock()
				core:remove_listener("SaylSettlementNumberTrackUnlock")
				core:remove_listener("SaylAltarOccupationLock")

				--handle intro mission
				self:intro_mission_trigger()
			end
		end,
		true
	)

	core:add_listener(
		"SaylAltarOccupationLock",
		"PanelOpenedCampaign",
		function(context)
			return context.string == "settlement_captured"
		end,
		function(context)
			if sayl_faction:is_null_interface() == false and 
					sayl_faction:is_dead() == false and
					sayl_faction:is_human() == true and
					sayl_faction:num_regions() < cm:campaign_var_int_value(self.requirement_to_unlock) then
				local altar_occupation_button = find_uicomponent(core:get_ui_root(), "2074767882", "option_button");
				if altar_occupation_button then
					altar_occupation_button:SetState("inactive");
					altar_occupation_button:SetTooltipText("{{tr:ui_text_replacements_localised_text_wh3_dlc27_dark_ritual_altar_occupation_locked}}", "ui_text_replacements_localised_text_wh3_dlc27_dark_ritual_altar_occupation_locked", false)
				end
			end
		end,
		true
	)

	if sayl_faction:is_null_interface() == false and sayl_faction:num_regions() < cm:campaign_var_int_value(self.requirement_to_unlock) then
		uim:override("aethyr_winds_progress_bar"):lock()
	else
		uim:override("aethyr_winds_progress_bar"):unlock()
		core:remove_listener("SaylSettlementNumberTrackUnlock")
		core:remove_listener("SaylAltarOccupationLock")
	end

end

function sayl_narrative:update_resource(amount)
	amount = math.floor(amount)
	cm:faction_add_pooled_resource(self.faction_key, self.arcane_power, self.altars_factor, amount)
	self:check_mission_threshold()
end

function sayl_narrative:check_mission_threshold()
	local sayl_faction = cm:get_faction(self.faction_key)
	local pr = sayl_faction:pooled_resource_manager():resource(self.pooled_resource)
	if not pr:is_null_interface() then
		local mission_data = self.mission_status
		for key, set_piece in dpairs(mission_data) do
			if type(set_piece) == "table" then
			if not set_piece.prev_mission_requirement or mission_data[set_piece.prev_mission_requirement].is_completed then 
				if not set_piece.has_spawned and pr:value() >= set_piece.trigger_amount then
					set_piece.has_spawned = true
					local mission_key = self.mission_prefix .. key
					cm:trigger_mission(self.faction_key, mission_key, true)
					if set_piece.dark_ritual_effect_bundle then
						-- disable effect bundle before battle is won
						cm:remove_effect_bundle(set_piece.dark_ritual_effect_bundle, self.faction_key)
						end
					end
				end
			end
		end
	end
end

function sayl_narrative:check_dilemma_threshold()
	local pr = cm:get_faction(self.faction_key):pooled_resource_manager():resource(self.pooled_resource)
	if not pr:is_null_interface() then
		local dilemma_data = self.dilemma_status
		for key, dilemma in dpairs(dilemma_data) do	
			if (not dilemma.has_spawned) and (pr:value() >= dilemma.trigger_amount) then
				dilemma.has_spawned = true
				cm:trigger_dilemma(sayl_narrative.faction_key, key)
				-- trigger the first dilemma that fulfills the conditions and stop iterating.
				return
			end
		end
	end
end

-- Lock recruitment, and do other startup operations to the generals that you can unlock with Devotion to the Gods.
function sayl_narrative:setup_champion_locks()

	-- When locking the generals, do so in an alphabetically ordered way to avoid desynchs.
	local sorted_general_keys = {}
	for _, reward_table in dpairs(self.dilemma_status) do
		if not reward_table.spawn_on_board then
			for _, champion in dpairs(reward_table.dilemma_choices) do
				table.insert(sorted_general_keys, { key = champion.key })
			end
		end
	end
	table.sort(sorted_general_keys,
		function (general_table_a, general_table_b)
			return general_table_a.key > general_table_b.key
		end
	)

	-- Lock Recruitment
	for g = 1, #sorted_general_keys do
		cm:lock_starting_character_recruitment(sorted_general_keys[g].key, self.faction_key)
	end
end


function sayl_narrative:intro_mission_trigger()

	local mm = mission_manager:new(self.faction_key, self.intro_mission)
	
	mm:add_new_objective("SCRIPTED")
	mm:add_condition("script_key "..self.intro_mission);
	mm:add_condition("override_text mission_text_text_wh3_dlc27_nor_sayl_intro_objective")
	mm:add_payload("money 3000")
	mm:add_payload("add_ancillary_to_faction_pool{ancillary_key wh3_dlc27_anc_arcane_item_schalkains_teeth;}");
	mm:add_payload("text_display dummy_sayl_narrative_intro_reward")
	mm:set_should_whitelist(false)
	mm:set_mission_issuer("CLAN_ELDERS")

	mm:trigger()

	self.mission_status = self.mission_status or {}
	self.mission_status.intro_active = true
	self:intro_mission_listeners()

end

function sayl_narrative:intro_mission_listeners()

	-- ensure registration across loads/new sessions
	core:remove_listener("CharacterPerformsSettlementOccupationDecision_SaylIntro")
	core:remove_listener("MissionSucceeded_SaylIntro")
	--Intro mission scripted objective
	core:add_listener(
		"CharacterPerformsSettlementOccupationDecision_SaylIntro",
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			return (context:occupation_decision() == self.intro_occupation_id) and self.mission_status and self.mission_status.intro_active == true
		end,
		function(context)
			cm:complete_scripted_mission_objective(self.faction_key, self.intro_mission, self.intro_mission, true)
		end,
		true
	)

	--Intro mission completed
	core:add_listener(
		"MissionSucceeded_SaylIntro",
		"MissionSucceeded",
		function(context)
			return (context:mission():mission_record_key() == self.intro_mission) and self.mission_status and self.mission_status.intro_active == true
		end,
		function(context)	
			self.mission_status = self.mission_status or {}
			self.mission_status.intro_active = false
			-- uim:override("aethyr_winds_progress_bar"):unlock()
			cm:trigger_incident(self.faction_key, self.intro_incident, true)
		end,
		true
	)

	core:add_listener(
		"Sayl_PoolResCheck",
		"PooledResourceChanged",
		function(context)
			return context:resource():key() == sayl_narrative.pooled_resource and context:faction():is_human()
		end,
		function(context)
			sayl_narrative:check_mission_threshold()
		end,
		true
	)

end


--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("SaylNarrative_MissionStatus", sayl_narrative.mission_status, context)
		cm:save_named_value("SaylNarrative_DilemmaStatus", sayl_narrative.dilemma_status, context)
	end
)
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			sayl_narrative.mission_status 	= cm:load_named_value("SaylNarrative_MissionStatus", sayl_narrative.mission_status, context)
			sayl_narrative.dilemma_status 	= cm:load_named_value("SaylNarrative_DilemmaStatus", sayl_narrative.dilemma_status, context)
			-- re-register intro listeners after load
			sayl_narrative:intro_mission_listeners()
		end
	end
)