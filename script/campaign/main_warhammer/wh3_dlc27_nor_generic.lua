nor_generic_config = {
	culture_key = "wh_dlc08_nor_norsca",
	altar_raise_occupation_options_display_overrides = {
		["1963655228"] = "wh_main_settlement_norscaruin_khorne",
		["1292694896"] = "wh_main_settlement_norscaruin_tzeentch",
		["1824195232"] = "wh_main_settlement_norscaruin_slaanesh",
		["1369123792"] = "wh_main_settlement_norscaruin_nurgle"
	},
	province_actions = {
		tribute_ritual = {
			ritual_key = "wh3_dlc27_ritual_nor_marauding_tribute",
			altar_effect_bundles = {
				kho = {
					count = 0,
					duration = 5,
					effect_bundle_key = "wh3_dlc27_ritual_nor_marauding_tribute_kho_effect_bundle",
					effects = {
						{
							key = "wh_main_effect_force_all_campaign_recruitment_cost",
							scope = "province_to_force_own_provincewide",
							increment = -5,
						}
					}
				},
				nur = {
					count = 0,
					duration = 5,
					effect_bundle_key = "wh3_dlc27_ritual_nor_marauding_tribute_nur_effect_bundle",
					effects = {
						{
							key = "wh_main_effect_force_all_campaign_replenishment_rate",
							scope = "region_to_force_own_provincewide",
							increment = 10,
						}
					}
				},
				sla = {
					count = 0,
					duration = 5,
					effect_bundle_key = "wh3_dlc27_ritual_nor_marauding_tribute_sla_effect_bundle",
					effects = {
						{
							key = "wh3_dlc27_effect_public_order_control_level_region_owner_positive",
							scope = "region_to_province_any",
							increment = 5,
						},
						{
							key = "wh3_main_effect_province_growth_level_of_control",
							scope = "province_to_province_own_unseen",
							increment = 20,
						},
					} 
				},
				tze = {
					count = 0,
					duration = 5,
					effect_bundle_key = "wh3_dlc27_ritual_nor_marauding_tribute_tze_effect_bundle",
					effects = {
						{
							key = "wh3_main_effect_winds_of_magic_events",
							scope = "region_to_force_own",
							increment = 5,
						}
					}
				},
			}
		},
		pillage_ritual = {
			ritual_key = "wh3_dlc27_ritual_nor_marauding_pillage",
			increment = 500
		},
		treachery_ritual = {
			active_state = false,
			faction = "wh3_dlc27_nor_sayl",
			ritual_key = "wh3_dlc27_ritual_nor_marauding_treachery_sayl",
			region_key = nil,
			duration = {
				value = nil  -- value taken from the ritual itself
			}, 
			effect_bundle = "wh3_dlc27_ritual_nor_marauding_treachery_sayl_custom_effect_bundle",
			effects_list = {
				["wh3_dlc24_unit_stat_bonus_attack"] = {
					value = nil,
					cap = 16,
					increment = 4,
					scope = "region_to_province_own"
				},
				["wh3_dlc24_unit_stat_bonus_armour"] = {
					value = nil,
					cap = 16,
					increment = 4,
					scope = "region_to_province_own"
				},
				["wh3_main_effect_force_stat_miscast_enemy"] = {
					value = nil,
					cap = 60,
					increment = 15,
					scope = "region_to_force_enemy_provincewide"
				}
			},
			sayl_manipulations_categories = {
				"SAYL_FACTION",
				"SAYL_FORCE",
				"SAYL_REGION",
				"SAYL_SELF"
			}
		}
	},

	chaos_undivided_altar_keys = {
		["wh3_dlc27_settlement_nor_chaos_altar_und"] = {
			conversions = 
			{
				"wh3_dlc27_nor_chaos_altar_kho_major_human_1",
				"wh3_dlc27_nor_chaos_altar_nur_major_human_1",
				"wh3_dlc27_nor_chaos_altar_sla_major_human_1",
				"wh3_dlc27_nor_chaos_altar_tze_major_human_1",
			}
		},
		["wh3_dlc27_settlement_nor_chaos_altar_und_special_gate"] = {
			conversions = 
			{
				"wh3_dlc20_woc_chaos_altar_special_gate_settlement_1",
			}
		},
		["wh3_dlc27_settlement_nor_chaos_altar_und_special_port"] = {
			conversions = 
			{
				"wh3_dlc27_nor_chaos_altar_kho_major_human_port_1",
				"wh3_dlc27_nor_chaos_altar_nur_major_human_port_1",
				"wh3_dlc27_nor_chaos_altar_sla_major_human_port_1",
				"wh3_dlc27_nor_chaos_altar_tze_major_human_port_1",

			}
		},
	},

	god_specific_altar_keys = {
		
		["wh3_dlc27_settlement_nor_chaos_altar_kho"] = {
			key = "wh3_dlc27_nor_chaos_altar_und_major_human_1"
		},
		["wh3_dlc27_settlement_nor_chaos_altar_nur"] = {
			key = "wh3_dlc27_nor_chaos_altar_und_major_human_1"
		},
		["wh3_dlc27_settlement_nor_chaos_altar_sla"] = {
			key = "wh3_dlc27_nor_chaos_altar_und_major_human_1"
		},
		["wh3_dlc27_settlement_nor_chaos_altar_tze"] = {
			key = "wh3_dlc27_nor_chaos_altar_und_major_human_1"		
		},
		["wh3_dlc27_settlement_nor_chaos_altar_kho_special_port"] = {
			key = "wh3_dlc27_nor_chaos_altar_und_major_human_port_1"
		},
		["wh3_dlc27_settlement_nor_chaos_altar_nur_special_port"] = {
			key = "wh3_dlc27_nor_chaos_altar_und_major_human_port_1"
		},
		["wh3_dlc27_settlement_nor_chaos_altar_sla_special_port"] = {
			key = "wh3_dlc27_nor_chaos_altar_und_major_human_port_1"
		},
		["wh3_dlc27_settlement_nor_chaos_altar_tze_special_port"] = {
			key = "wh3_dlc27_nor_chaos_altar_und_major_human_port_1"
		},
		["wh3_dlc27_settlement_nor_chaos_altar_und_special_gate"] = {
			key = "wh3_dlc27_settlement_nor_chaos_altar_und_special_gate_1"
		},
	},

	curse_of_the_old_gods = {
		ancillary_set_key = "wh3_dlc27_ancillary_set_nor_pillaging",
		effect_bundle_key = "wh3_dlc27_bundle_force_old_gods_curse_anc_set",
		effect_bundle_duration = 2,

		-- note: some effects need to be applied together and counted as
		-- one effect - that is why the following is a list of lists of effects,
		-- even when there is just one effect in the sub-list
		effect_lists = {
			{
				{
					key = "wh_main_effect_force_all_campaign_movement_range",
					scope = "character_to_force_own_unseen",
					value = -75,
				},
			},
			{
				{
					key = "wh3_dlc27_effect_force_all_campaign_reinforcement_range_hidden",
					scope = "character_to_character_own",
					value = -200,
				},
				{
					key = "wh3_dlc27_effect_force_disable_reinforcement_range_text_dummy",
					scope = "character_to_force_own_unseen",
					value = 1,
				},
			},
			{
				{
					key = "wh3_dlc27_effect_force_campaign_stance_begin_fatigued_5_very_tired",
					scope = "force_to_force_own",
					value = 5,
				},
			},
			{
				{
					key = "wh_main_effect_force_stat_leadership",
					scope = "character_to_force_own_unseen",
					value = -8,
				},
			},
			{
				{
					key = "wh_main_effect_force_stat_speed",
					scope = "character_to_force_own_unseen",
					value = -20,
				},
			},
			{
				{
					key = "wh_main_effect_campaign_enable_attrition",
					scope = "force_to_force_own",
					value = 10,
				},
			},
		},
		effects_count = 3,

		event_config = {
			popup_last_turn_saved_value_key = "wh3_dlc27_nor_curse_of_the_old_gods_popup_last_turn",
			popup_timeout_turns_count = 2,

			silent = {
				title = "event_feed_strings_text_wh3_dlc27_incident_nor_curse_of_the_old_gods_set_title",
				detail = "event_feed_strings_text_wh3_dlc27_incident_nor_curse_of_the_old_gods_set_detail",
				criteria_value = 887,
			},
			popup = {
				title = "event_feed_strings_text_wh3_dlc27_incident_nor_curse_of_the_old_gods_set_popup_title",
				detail = "event_feed_strings_text_wh3_dlc27_incident_nor_curse_of_the_old_gods_set_popup_detail",
				criteria_value = 889,
			},
		},
	}
}


nor_generic = {}
nor_generic.config = nor_generic_config

function nor_generic:initialise()
	self:setup_generic_listeners()
	self:setup_confederation_listeners()
	self:marauding_manipulations_ritual_listener()
end

-- Altar conversion when confederating for norscan faction targeting sayl
function nor_generic:setup_confederation_listeners()
	core:add_listener(
		"norsca_confederating_sayl",
		"FactionJoinsConfederation",
		function(context)
			return context:confederation():culture() == "wh_dlc08_nor_norsca" and context:faction():name() == "wh3_dlc27_nor_sayl"
		end,
		function(context)
			local target = context:confederation()
			for i = 0, target:region_list():num_items() - 1 do 
				local region = target:region_list():item_at(i)
				local primary_chain = region:settlement():primary_building_chain()
				if self.config.chaos_undivided_altar_keys[primary_chain] then
					local primary_slot = region:slot_list():item_at(0)
					local random_index = cm:random_number(#self.config.chaos_undivided_altar_keys[primary_chain].conversions, 1)
					cm:region_slot_instantly_dismantle_building(primary_slot)
					cm:region_slot_instantly_upgrade_building(primary_slot, self.config.chaos_undivided_altar_keys[primary_chain].conversions[random_index])
				end
			end
		end,
		true
	)


	core:add_listener(
		"sayl_confederating_norsca",
		"FactionJoinsConfederation",
		function(context)
			return context:confederation():name() == "wh3_dlc27_nor_sayl" and context:faction():culture() == "wh_dlc08_nor_norsca"
		end,
		function(context)
			local target = context:confederation()
			for i = 0, target:region_list():num_items() - 1 do 
				local region = target:region_list():item_at(i)
				local primary_chain = region:settlement():primary_building_chain()
				if self.config.god_specific_altar_keys[primary_chain] then
					local primary_slot = region:slot_list():item_at(0)
					cm:region_slot_instantly_dismantle_building(primary_slot)
					cm:region_slot_instantly_upgrade_building(primary_slot, self.config.god_specific_altar_keys[primary_chain].key)
				end
			end
		end,
		true
	)

	-- setup the custom effect bundle properties after the marauding ritual is activate
	core:add_listener(
		"nor_marauding_treachery_ritual_setup",
		"RitualCompletedEvent",
		function(context)
			local ritual_config = self.config.province_actions.treachery_ritual
			return context:ritual():ritual_key() == ritual_config.ritual_key and ritual_config.active_state == false
		end,
		function(context)
			local target_region_key = context:ritual_target_region():name()
			local ritual_cooldown = context:ritual():cooldown_time()
			local ritual_config = self.config.province_actions.treachery_ritual

			ritual_config.active_state = true
			ritual_config.region_key = target_region_key
			ritual_config.duration.value = ritual_cooldown

			-- reset effects
			local effects_list = self.config.province_actions.treachery_ritual.effects_list

			for i, data in dpairs(effects_list) do 
				data.value = 0
			end

		end,
		true
	)

	core:add_listener(
		"nor_marauding_pillage_ritual",
		"RitualCompletedEvent",
		function(context)
			return context:ritual():ritual_key() == self.config.province_actions.pillage_ritual.ritual_key
		end,
		function(context)
			local ritual = context:ritual()
			local province = context:ritual_target_region():province()
			local effect_value = 0

			for i = 0, province:regions():num_items() - 1 do 
				local region = province:regions():item_at(i)
				if region:owning_faction():name() ~= context:performing_faction():name() then
					effect_value = effect_value + self.config.province_actions.pillage_ritual.increment
				end
			end

			cm:treasury_mod(context:performing_faction():name(), effect_value)
		end,
		true
	)

	core:add_listener(
		"nor_marauding_tribute_ritual",
		"RitualCompletedEvent",
		function(context)
			return context:ritual():ritual_key() == self.config.province_actions.tribute_ritual.ritual_key
		end,
		function(context)
			local ritual = context:ritual()
			local province = context:ritual_target_region():province()
			
			for i = 0, province:regions():num_items() - 1 do 
				local region = province:regions():item_at(i)
				local main_building = region:settlement():primary_building_chain()

				if string.find(main_building,"chaos_altar_kho") then 
					self.config.province_actions.tribute_ritual.altar_effect_bundles.kho.count = self.config.province_actions.tribute_ritual.altar_effect_bundles.kho.count + 1
				elseif string.find(main_building,"chaos_altar_nur") then 
					self.config.province_actions.tribute_ritual.altar_effect_bundles.nur.count = self.config.province_actions.tribute_ritual.altar_effect_bundles.nur.count + 1
				elseif string.find(main_building,"chaos_altar_sla") then
					self.config.province_actions.tribute_ritual.altar_effect_bundles.sla.count = self.config.province_actions.tribute_ritual.altar_effect_bundles.sla.count + 1
				elseif string.find(main_building,"chaos_altar_tze") then 
					self.config.province_actions.tribute_ritual.altar_effect_bundles.tze.count = self.config.province_actions.tribute_ritual.altar_effect_bundles.tze.count + 1
				end
			end

			for key, value in dpairs(self.config.province_actions.tribute_ritual.altar_effect_bundles) do 
				nor_generic:add_custom_effect_bundle_for_tribute_ritual(value, context:ritual_target_region(), value.count)
				value.count = 0
			end
		end,
		true
	)

	core:add_listener(
		"nor_raze_gods_altar_visual_override",
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			return self.config.altar_raise_occupation_options_display_overrides[context:occupation_decision()]
		end,
		function(context)
			if context:character() and context:character():faction() and context:character():faction():culture() == self.config.culture_key then
				local region = context:garrison_residence():region()
				local region_key = region:name()
				local display_chain = region:settlement():display_primary_building_chain()
				local override_display = self.config.altar_raise_occupation_options_display_overrides[context:occupation_decision()]

				cm:override_building_chain_display(display_chain, override_display, region_key)
			end
		end,
		true
	)

	core:add_listener(
		"nor_remove_gods_altar_visual_override",
		"RegionFactionChangeEvent",
		function(context)
			return context:previous_faction() and context:previous_faction():culture() == self.config.culture_key
		end,
		function(context)
			local region = context:region()
			local region_key = region:name()
			local display_chain = region:settlement():display_primary_building_chain()
			local display_chain_override = cm:get_override_building_chain_display_for_region(display_chain, region_key)
			if display_chain_override ~= "" and display_chain_override ~= display_chain then
				cm:remove_override_building_chain_display_from_region(display_chain, region_key)
			end
		end,
		true
	)
end

function nor_generic:setup_generic_listeners()
	core:add_listener(
		"nor_curse_of_the_old_gods_battle_conflict_finished",
		"BattleConflictFinished",
		function(context)
			local pb = context:pending_battle()
			if pb:naval_battle() or pb:is_draw() then
				return false
			end

			local winners, losers = cm:get_pending_battle_winners_and_losers(pb)

			-- the winner must be a norsca faction
			if not self:is_any_character_nor(winners) then
				return false
			end

			-- there must be a general among the losers
			if not self:is_any_character_general(losers) then
				return false
			end

			-- a character from the winners side must have the ancillary set
			if not self:does_any_character_have_ancillary_set(winners) then
				return false
			end

			return true
		end,
		function(context)
			local pb = context:pending_battle()
			local winners, _ = cm:get_pending_battle_winners_and_losers(pb)
			if table.is_empty(winners) then
				return
			end

			-- must be valid as we've checked that it's not a sea battle in the
			-- condition but let's be double sure
			local region = pb:region_data():region()
			if not region or region:is_null_interface() then
				return
			end

			local winner = winners[1]
			local faction = winner:faction()
			local province = region:province()
			local enemy_force = self:find_random_enemy_force_in_province_for_faction(province, faction)
			if enemy_force == nil then
				return
			end

			local effect_bundle = self:create_custom_effect_bundle_for_curse_of_the_old_gods()
			if effect_bundle == nil then
				return
			end

			cm:apply_custom_effect_bundle_to_force(effect_bundle, enemy_force)

			self:show_event_message_for_curse_of_the_old_gods(faction, enemy_force)
		end,
		true
	)
end

function nor_generic:add_custom_effect_bundle_for_tribute_ritual(config, region, altar_count)
	if altar_count <= 0 then 
		return
	end


	local effect_bundle = cm:create_new_custom_effect_bundle(config.effect_bundle_key)
	for i = 1, #config.effects do 
		local effect_value = config.effects[i].increment * altar_count
		effect_bundle:add_effect(config.effects[i].key, config.effects[i].scope, effect_value);
	end

	effect_bundle:set_duration(config.duration);
	cm:apply_custom_effect_bundle_to_faction_province(effect_bundle, region)
end

function nor_generic:is_any_character_nor(characters)
	return table.find(
		characters,
		function (char) return char:faction():culture() == self.config.culture_key end)
end

function nor_generic:is_any_character_general(characters)
	return table.find(
		characters,
		function (char) return cm:char_is_general(char) end)
end

function nor_generic:does_any_character_have_ancillary_set(characters)
	local key = nor_generic_config.curse_of_the_old_gods.ancillary_set_key
	return table.find(
		characters,
		function (char) return char:has_ancillary_set(key) end)
end

function nor_generic:add_enemy_forces_in_region(forces, faction, region)
	local characters = region:characters_in_region()
	for i = 0, characters:num_items() - 1 do
		local character = characters:item_at(i)
		local current_faction = character:faction()

		if (not current_faction:is_rebel()) and faction:at_war_with(current_faction) then
			local force = character:military_force()
			table.add_unique(forces, force)
		end
	end
end

function nor_generic:find_random_enemy_force_in_province_for_faction(province, faction)
	local enemy_forces = {}

	local regions = province:regions()
	for i = 0, regions:num_items() - 1 do
		local region = regions:item_at(i)
		self:add_enemy_forces_in_region(enemy_forces, faction, region)
	end

	if table.is_empty(enemy_forces) then
		return nil
	end

	local index = cm:random_number(#enemy_forces)
	return enemy_forces[index]
end

function nor_generic:create_custom_effect_bundle_for_curse_of_the_old_gods()
	local effect_bundle = cm:create_new_custom_effect_bundle(self.config.curse_of_the_old_gods.effect_bundle_key)
	if effect_bundle == nil or effect_bundle:is_null_interface() then
		return nil
	end

	local effect_lists = self.config.curse_of_the_old_gods.effect_lists
	
	-- get the table's indieces and shuffle them
	local indices = table.indices(effect_lists)
	cm:shuffle_table(indices)

	local max_effects_count = self.config.curse_of_the_old_gods.effects_count
	local count = math.min(#indices, max_effects_count)
	for i = 1, count do 
		local index = indices[i]
		local effect_list = effect_lists[index]
		for j = 1, #effect_list do
			local effect = effect_list[j]
			effect_bundle:add_effect(effect.key, effect.scope, effect.value)
		end
	end

	effect_bundle:set_duration(self.config.curse_of_the_old_gods.effect_bundle_duration)
	return effect_bundle
end

function nor_generic:show_event_message_for_curse_of_the_old_gods(faction, enemy_force)
	local event_config = self.config.curse_of_the_old_gods.event_config

	local turns_value_key = event_config.popup_last_turn_saved_value_key
	local turns_timeout = event_config.popup_timeout_turns_count
	local last_turn = cm:get_saved_value(turns_value_key) or -turns_timeout
	local current_turn = cm:turn_number()
	local should_popup = last_turn + turns_timeout < current_turn

	local faction_key = faction:name()
	local primary_detail = "factions_screen_name_" .. faction_key
	local parameters = should_popup and event_config.popup or event_config.silent
	local x, y = cm:get_force_logical_position(enemy_force)
	cm:show_message_event_located(
		faction_key,
		parameters.title,
		primary_detail,
		parameters.detail,
		x,
		y,
		true,
		parameters.criteria_value
	)

	if should_popup then
		cm:set_saved_value(turns_value_key, current_turn)
	end
end

function nor_generic:marauding_manipulations_ritual_listener()

	core:add_listener(
		"marauding_manipulations_ritual_listener_countdown",
		"FactionTurnStart",
		function(context)
			local ritual_config = self.config.province_actions.treachery_ritual
			return context:faction():name() == ritual_config.faction and ritual_config.active_state == true
		end,
		function(context)
			local ritual_config = self.config.province_actions.treachery_ritual
			ritual_config.duration.value = ritual_config.duration.value - 1
			
			if ritual_config.duration.value == 0 then
				ritual_config.active_state = false
			end
		end,
		true
	)
	
	core:add_listener(
		"marauding_manipulations_ritual_listener",
		"RitualCompletedEvent",
		function(context)
			local ritual_category = context:ritual():ritual_category()
			local ritual_config = self.config.province_actions.treachery_ritual
			local expected_category = ritual_config.sayl_manipulations_categories

			for i = 1, #expected_category do
				if ritual_category == expected_category[i] and ritual_config.active_state then
					return true
				end
			end

			return false
		end,
		function(context)
			local ritual_config = self.config.province_actions.treachery_ritual
			local effect_bundle = cm:create_new_custom_effect_bundle(ritual_config.effect_bundle)
			local effects_list = ritual_config.effects_list

			for effect, effect_data in dpairs(effects_list) do 
				local increment = effect_data.increment
				local cap = effect_data.cap
				local scope = effect_data.scope

				if (effect_data.value < cap and increment > 0) or (effect_data.value > cap and increment < 0) then
					effect_data.value = effect_data.value + increment
				end
				effect_bundle:add_effect(effect, scope, effect_data.value)
			end
		
			effect_bundle:set_duration(ritual_config.duration.value);
			cm:apply_custom_effect_bundle_to_faction_province(effect_bundle, cm:get_region(ritual_config.region_key))

		end,
		true
	)

end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("MaraudingSubterfugeData", nor_generic_config.province_actions.treachery_ritual, context)
	end
)
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			nor_generic_config.province_actions.treachery_ritual = cm:load_named_value("MaraudingSubterfugeData", nor_generic_config.province_actions.treachery_ritual, context)
		end
	end
)