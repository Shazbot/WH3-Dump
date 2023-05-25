hellforge = {}
hellforge = {
	unit_cap_ritual_category = "HELLFORGE_CAPS",
	unit_ritual_cost_mod_increment = 25, 				-- cost increment to a unit cap cost each time it is performed
	warmachine_ritual_cost_mod_increment = 10, 			-- cost increment to a warmachine unit cap cost each time it is performed
	unit_cost_modifiers_bundle_string = "wh3_dlc23_bundle_chd_unit_cap_rituals_cost_mods",
	unit_cap_modifiers_bundle_string = "wh3_dlc23_bundle_chd_unit_cap_rituals",
	cost_mod_effect_suffix = "_cost_mod",
	modification_turned_off_incident = "wh3_dlc23_incident_hellforge_modifications_turned_off",
	incident_triggered_this_turn = false,
	convoy_commander_key = "wh3_dlc23_chd_lord_convoy_overseer",

	-- Armament upkeep cost modification
	culture_key = "wh3_dlc23_chd_chaos_dwarfs",
	faction_set_key = "chaos_dwarf_playable_factions",
	unit_sets = {
		"wh3_dlc23_chd_category_chaos_dwarf_melee_infantry",
		"wh3_dlc23_chd_category_chaos_dwarf_missile_infantry",
		"wh3_dlc23_chd_category_bull_centaurs",
		"wh3_dlc23_chd_category_flying_beasts",
		"wh3_dlc23_chd_category_kdaai",
		"wh3_dlc23_chd_category_warmachines"
	},
	warmachine_keys_to_extra_carriage_count = {
		wh3_dlc23_chd_veh_iron_daemon_1dreadquake = 1,
		wh3_dlc23_chd_veh_skullcracker_1dreadquake = 1,
		wh3_dlc23_chd_veh_iron_daemon_ror_1dreadquake = 1
	},
	upkeep_effect_bundle = "wh3_dlc23_bundle_chd_hellforge_upkeep_cost_mods",
	unit_set_to_effect_key = {
		wh3_dlc23_chd_category_chaos_dwarf_melee_infantry = "wh3_dlc23_chd_hellforge_melee_inf_upkeep_cost_mod",
		wh3_dlc23_chd_category_chaos_dwarf_missile_infantry = "wh3_dlc23_chd_hellforge_missile_inf_upkeep_cost_mod",
		wh3_dlc23_chd_category_bull_centaurs = "wh3_dlc23_chd_hellforge_bull_centaur_upkeep_cost_mod",
		wh3_dlc23_chd_category_flying_beasts = "wh3_dlc23_chd_hellforge_flying_beasts_upkeep_cost_mod",
		wh3_dlc23_chd_category_kdaai = "wh3_dlc23_chd_hellforge_kdaai_upkeep_cost_mod",
		wh3_dlc23_chd_category_warmachines = "wh3_dlc23_chd_hellforge_warmachine_upkeep_cost_mod",
	},
	ai_data = {
		{active_script_context = nil, faction_key = "wh3_dlc23_chd_astragoth"},
		{active_script_context = nil, faction_key = "wh3_dlc23_chd_legion_of_azgorh"},
		{active_script_context = nil, faction_key = "wh3_dlc23_chd_zhatan"}
	},
	faction_unit_count = {
		missile_infantry = {count = 0, required_percentage = 40, script_context_to_apply = "cai_faction_script_context_beta"},
		melee_infantry = {count = 0, required_percentage = 40, script_context_to_apply = "cai_faction_script_context_alpha"},
		warmachines = {count = 0, required_percentage = 15, script_context_to_apply = "cai_faction_script_context_special_2"},
		kdaai = {count = 0, required_percentage = 20, script_context_to_apply = "cai_faction_script_context_special_1"},
		bull_centaurs = {count = 0, required_percentage = 20, script_context_to_apply = "cai_faction_script_context_gamma"},
		flying_beasts = {count = 0, required_percentage = 20, script_context_to_apply = "cai_faction_script_context_delta"}
	},
	ror_cost_exclusion = {
		wh3_dlc23_chd_cav_bull_centaurs_dual_axe_ror = true,
		wh3_dlc23_chd_inf_chaos_dwarf_blunderbusses_ror = true,
		wh3_dlc23_chd_inf_chaos_dwarf_warriors_ror = true,
		wh3_dlc23_chd_inf_infernal_ironsworn_ror = true,
		wh3_dlc23_chd_veh_iron_daemon_ror = true,
		wh3_dlc23_chd_veh_iron_daemon_ror_1dreadquake = true,
		wh_dlc08_nor_art_hellcannon_battery = true,
		wh_pro04_chs_art_hellcannon_ror_0 = true
	},

	warmachine_ritual_keys = {
		wh3_dlc23_chd_ritual_unit_cap_hellcannon = true,
		wh3_dlc23_chd_ritual_unit_cap_warmachines = true
	}
}

function hellforge:setup_listeners()
	
	--Ensure the AI has the correct script context for everything to work properly
	for _,v in ipairs(hellforge.ai_data) do
		local faction = cm:get_faction(v.faction_key)
		if faction ~= false then
			if faction:is_human() == false and v.active_script_context ~= nil then
				cm:cai_set_faction_script_context(v.faction_key, v.active_script_context)
			end
		end
	end

	-- Setup initial cost multipliers
	local human_factions = cm:get_human_factions_of_culture(hellforge.culture_key)
	for _, faction_key in ipairs(human_factions) do
		hellforge:multiply_armament_cost_per_unit(cm:get_faction(faction_key))
	end
	
	--Gives the Servants of the Conclave 10 of every units cap
	if cm:is_new_game() == true then 
		local bundle_to_apply = cm:create_new_custom_effect_bundle(self.unit_cap_modifiers_bundle_string)
		local new_effects = bundle_to_apply:effects()
		local faction_key = "wh3_dlc23_chd_conclave"
	
		for i = 0, new_effects:num_items() - 1 do
			local new_effect = new_effects:item_at(i)	
			bundle_to_apply:set_effect_value(new_effect, 10)
		end

		bundle_to_apply:set_duration(0)
		cm:apply_custom_effect_bundle_to_faction(bundle_to_apply, cm:get_faction(faction_key))

	end

	core:add_listener(
		"hellforge_unit_category_purchase",
		"RitualCompletedEvent",
		function(context)
			return context:ritual():ritual_category():find(self.unit_cap_ritual_category)
		end,
		function(context)
			local ritual_key = context:ritual():ritual_key()
			self:modify_ritual_cap_cost(ritual_key, context:performing_faction(), self.unit_cost_modifiers_bundle_string)
			self:modify_unit_cap(ritual_key, context:performing_faction(), self.unit_cap_modifiers_bundle_string)
		end,
		true
	)

	-- Listeners for whenever the active unit count for a human chaos dwarf faction could change
	-- BattleCompleted, MilitaryForceCreated, UnitTrained, UnitMergedAndDestroyed, UnitDisbanded, FactionJoinsConfederation
	core:add_listener(
		"hellforge_upkeep_modifier_battle_completed",
		"BattleCompleted",
		function(context)
			return cm:pending_battle_cache_human_is_involved() and cm:pending_battle_cache_faction_set_member_is_involved(self.faction_set_key)
		end,
		function(context)
			for i = 1, cm:pending_battle_cache_num_attackers() do
				local _, _, faction_key = cm:pending_battle_cache_get_attacker(i)
				if faction_key and faction_key ~= "rebels" then -- We want to exclude any instances where the faction doesn't have an actual faction_interface
					local faction_interface = cm:get_faction(faction_key)
					if faction_interface ~= false and faction_interface:is_human() and faction_interface:is_contained_in_faction_set(self.faction_set_key) then
						self:multiply_armament_cost_per_unit(faction_interface)
					end
				end
			end

			for i = 1, cm:pending_battle_cache_num_defenders() do
				local _, _, faction_key = cm:pending_battle_cache_get_defender(i)
				if faction_key and faction_key ~= "rebels" then -- We want to exclude any instances where the faction doesn't have an actual faction_interface
					local faction_interface = cm:get_faction(faction_key)
					if faction_interface ~= false and faction_interface:is_human() and faction_interface:is_contained_in_faction_set(self.faction_set_key) then
						self:multiply_armament_cost_per_unit(faction_interface)
					end
				end
			end
		end,
		true
	)

	core:add_listener(
		"hellforge_upkeep_modifier_military_force_created",
		"MilitaryForceCreated",
		function(context)
			local faction = context:military_force_created():faction()
			return faction:is_human() and faction:is_contained_in_faction_set(self.faction_set_key)
		end,
		function(context)
			local faction_interface = context:military_force_created():faction()
			self:multiply_armament_cost_per_unit(faction_interface)
		end,
		true
	)

	core:add_listener(
		"hellforge_upkeep_modifier_unit_trained",
		"UnitTrained",
		function(context)
			local faction = context:unit():faction()
			return faction:is_human() and faction:is_contained_in_faction_set(self.faction_set_key)
		end,
		function(context)
			local faction_interface = context:unit():faction()
			self:multiply_armament_cost_per_unit(faction_interface)
		end,
		true
	)

	core:add_listener(
		"hellforge_upkeep_modifier_unit_merged",
		"UnitMergedAndDestroyed",
		function(context)
			local faction = context:new_unit():faction()
			return faction:is_human() and faction:is_contained_in_faction_set(self.faction_set_key)
		end,
		function(context)
			local faction_interface = context:new_unit():faction()
			cm:callback(
				function()
					self:multiply_armament_cost_per_unit(faction_interface)
				end,
				0.5
			)
		end,
		true
	)

	core:add_listener(
		"hellforge_upkeep_modifier_unit_disbanded",
		"UnitDisbanded",
		function(context)
			local faction = context:unit():faction()
			return faction:is_human() and faction:is_contained_in_faction_set(self.faction_set_key)
		end,
		function(context)
			local faction_interface = context:unit():faction()
			cm:callback(
				function()
					self:multiply_armament_cost_per_unit(faction_interface)
				end,
				0.5
			)
		end,
		true
	)

	core:add_listener(
		"hellforge_upkeep_modifier_unit_disbanded",
		"UnitUpgraded",
		function(context)
			local faction = context:unit():faction()
			return faction:is_human() and faction:is_contained_in_faction_set(self.faction_set_key)
		end,
		function(context)
			local faction_interface = context:unit():faction()
			cm:callback(
				function()
					self:multiply_armament_cost_per_unit(faction_interface)
				end,
				0.5
			)
		end,
		true
	)

	core:add_listener(
		"hellforge_upkeep_modifier_game_start",
		"WorldStartRound",
		true,
		function(context)
			local human_factions = cm:get_human_factions_of_culture(self.culture_key)
			for _, faction_key in ipairs(human_factions) do
				local faction_interface = cm:get_faction(faction_key)
				if faction_interface ~= false then
					self:multiply_armament_cost_per_unit(cm:get_faction(faction_key))
				end
			end
		end,
		false
	)

	core:add_listener( -- only update once per turn for the AI to ensure we don't run into performance problems
		"hellforge_upkeep_modifier_faction_turn_end",
		"FactionTurnEnd",
		function(context)
			local faction = context:faction()
			return faction:is_contained_in_faction_set(self.faction_set_key)
		end,
		function(context)
			local faction_interface = context:faction()
			self:multiply_armament_cost_per_unit(faction_interface)
			self.incident_triggered_this_turn = false
		end,
		true
	)

	core:add_listener(
		"hellforge_upkeep_modifier_confederation",
		"FactionJoinsConfederation",
		function(context)
			local faction = context:confederation()
			return faction:is_human() and faction:is_contained_in_faction_set(self.faction_set_key)
		end,
		function(context)
			local faction_interface = context:confederation()
			self:multiply_armament_cost_per_unit(faction_interface)
		end,
		true
	)

	core:add_listener(
		"ai_update_hellforge_priority_turnstart",
		"FactionTurnStart",
		function(context)
			self.incident_triggered_this_turn = false
			local faction = context:faction()
			if faction:is_contained_in_faction_set(self.faction_set_key) and not faction:is_human() and cm:turn_number() % 10 == 0 then
				return true
			end
		end,
		function(context)
			local faction = context:faction()
			self:update_ai_hellforge(faction)
		end,
		true
	)


	core:add_listener(
		"ai_update_hellforge_priority_initiative_activation",
		"FactionInitiativeActivationChangedEvent",
		function(context)
			if self.incident_triggered_this_turn == false and context:automated() == true then
				local faction = context:faction()
				return faction:is_human() and faction:is_contained_in_faction_set(self.faction_set_key)
			end
		end,
		function(context)
			local faction_key = context:faction():name()
			cm:trigger_incident(faction_key, self.modification_turned_off_incident, true, false)
			self.incident_triggered_this_turn = true
		end,
		true
	)
end


function hellforge:get_available_payloads(payloads_list)
	local available_payloads = {}

	for i = 1, #payloads_list do
		if not payloads_list[i].is_used then
			table.insert(available_payloads, i)
		end
	end
	return available_payloads
end


function hellforge:modify_ritual_cap_cost(ritual_key, faction_interface, bundle_key)
	local current_bundle = self:get_faction_bundle_by_key(faction_interface, bundle_key)
	local effect_to_modify_key = ritual_key..self.cost_mod_effect_suffix
	local effects_to_new_values = {}

	if current_bundle then
		local active_effects = current_bundle:effects()
		for i = 0, active_effects:num_items() - 1 do
			local active_effect = active_effects:item_at(i)
			local old_value = active_effect:value()
			local active_effect_key = active_effect:key()
			if active_effect_key == effect_to_modify_key then
				if active_effect_key == "wh3_dlc23_chd_ritual_unit_cap_warmachines_cost_mod" then
					effects_to_new_values[active_effect_key] = old_value + self.warmachine_ritual_cost_mod_increment
				else
					effects_to_new_values[active_effect_key] = old_value + self.unit_ritual_cost_mod_increment
				end
			else
				effects_to_new_values[active_effect_key] = old_value
			end
		end
	end

	local bundle_to_apply = cm:create_new_custom_effect_bundle(bundle_key)
	local new_effects = bundle_to_apply:effects()

	for i = 0, new_effects:num_items() - 1 do
		local new_effect = new_effects:item_at(i)
		local new_effect_key = new_effect:key()

		if effects_to_new_values[new_effect_key] then
			bundle_to_apply:set_effect_value(new_effect, effects_to_new_values[new_effect_key])
		elseif effect_to_modify_key == new_effect_key then
			if new_effect_key == "wh3_dlc23_chd_ritual_unit_cap_warmachines_cost_mod" then
				bundle_to_apply:set_effect_value(new_effect, self.warmachine_ritual_cost_mod_increment)
			else
				bundle_to_apply:set_effect_value(new_effect, self.unit_ritual_cost_mod_increment)
			end
		else
			bundle_to_apply:set_effect_value(new_effect, 0)
		end
	end

	bundle_to_apply:set_duration(0)

	cm:apply_custom_effect_bundle_to_faction(bundle_to_apply,faction_interface)

end

function hellforge:modify_unit_cap(ritual_key, faction_interface, bundle_key)
	local current_bundle = self:get_faction_bundle_by_key(faction_interface, bundle_key)
	local effect_to_modify_key = ritual_key
	local effects_to_new_values = {}

	if current_bundle then
		local active_effects = current_bundle:effects()
		for i = 0, active_effects:num_items() - 1 do
			local active_effect = active_effects:item_at(i)
			local old_value = active_effect:value()
			local active_effect_key = active_effect:key()
			if active_effect_key == effect_to_modify_key then
				effects_to_new_values[active_effect_key] = old_value + 1
			else
				effects_to_new_values[active_effect_key] = old_value
			end
		end
	end

	local bundle_to_apply = cm:create_new_custom_effect_bundle(bundle_key)
	local new_effects = bundle_to_apply:effects()

	for i = 0, new_effects:num_items() - 1 do
		local new_effect = new_effects:item_at(i)
		local new_effect_key = new_effect:key()

		if effects_to_new_values[new_effect_key] then
			bundle_to_apply:set_effect_value(new_effect, effects_to_new_values[new_effect_key])
		elseif effect_to_modify_key == new_effect_key then
			bundle_to_apply:set_effect_value(new_effect, 1)
		else
			bundle_to_apply:set_effect_value(new_effect, 0)
		end
	end

	bundle_to_apply:set_duration(0)

	cm:apply_custom_effect_bundle_to_faction(bundle_to_apply,faction_interface)

end


function hellforge:get_faction_bundle_by_key(faction_interface, bundle_key)
	local effect_bundle_list = faction_interface:effect_bundles()

	for i = 0, effect_bundle_list:num_items() - 1 do
		local effect_bundle = effect_bundle_list:item_at(i)

		if effect_bundle:key() == bundle_key then
			return effect_bundle
		end
	end
end


function hellforge:multiply_armament_cost_per_unit(faction_interface)
	if faction_interface:has_effect_bundle(self.upkeep_effect_bundle) then
		cm:remove_effect_bundle(self.upkeep_effect_bundle, faction_interface:name())
	end

	local new_effect_bundle = cm:create_new_custom_effect_bundle(self.upkeep_effect_bundle)
	local unit_sets_to_unit_count = self:get_unit_counts_per_set(faction_interface)

	for i = 1, #self.unit_sets do
		local upkeep_modifier = (unit_sets_to_unit_count[self.unit_sets[i]] - 1) * 100
		new_effect_bundle:add_effect(self.unit_set_to_effect_key[self.unit_sets[i]], "faction_to_faction_own_unseen", upkeep_modifier)
	end

	new_effect_bundle:set_duration(0)
	cm:apply_custom_effect_bundle_to_faction(new_effect_bundle, faction_interface)
end


function hellforge:get_unit_counts_per_set(faction_interface)
	local unit_set_to_count = {}
	for i = 1, #self.unit_sets do
		local unit_set = self.unit_sets[i]
		local units_in_set = faction_interface:units_recruited_in_set(unit_set)
		unit_set_to_count[unit_set] = units_in_set:num_items()

		for j = 0, units_in_set:num_items() - 1 do
			local unit = units_in_set:item_at(j)
			local force_commander = unit:force_commander()
			if force_commander then
				local character_type_key = force_commander:character_subtype_key()
				if character_type_key == self.convoy_commander_key then
					unit_set_to_count[unit_set] = unit_set_to_count[unit_set] - 1
				end
			end

			-- Increase Warmachine unit count if the unit has any extra carriages
			if unit_set == "wh3_dlc23_chd_category_warmachines" then
				local unit_key = unit:unit_key()
				if self.warmachine_keys_to_extra_carriage_count[unit_key] ~= nil then
					unit_set_to_count[unit_set] = unit_set_to_count[unit_set] + self.warmachine_keys_to_extra_carriage_count[unit_key]
				end
			end

			-- RoR units excluded from upkeep cost
			if self.ror_cost_exclusion[unit:unit_key()] then
				local unit_key = unit:unit_key()
				unit_set_to_count[unit_set] = unit_set_to_count[unit_set] - 1
			end
		end
	end
	return unit_set_to_count
end


function hellforge:update_ai_hellforge(faction_interface)
	--Remove the existing hellforges effects
	
	faction_key = faction_interface:name()
	
	for _, initiative_set in model_pairs(faction_interface:faction_initiative_sets()) do
		local active_initiatives = initiative_set:active_initiatives()
		if active_initiatives:is_empty() == false then
			for i = 0, active_initiatives:num_items() - 1 do
				cm:toggle_initiative_active(initiative_set, active_initiatives:item_at(i):record_key(), false)
			end
		end
	end

	--Choose which of the new script contexts to apply. 
	local unit_set_counts = self:get_unit_counts_per_set(faction_interface)

	hellforge.faction_unit_count.missile_infantry.count = unit_set_counts["wh3_dlc23_chd_category_chaos_dwarf_missile_infantry"]
	hellforge.faction_unit_count.melee_infantry.count = unit_set_counts["wh3_dlc23_chd_category_chaos_dwarf_melee_infantry"]
	hellforge.faction_unit_count.warmachines.count = unit_set_counts["wh3_dlc23_chd_category_warmachines"]
	hellforge.faction_unit_count.kdaai.count = unit_set_counts["wh3_dlc23_chd_category_kdaai"]
	hellforge.faction_unit_count.bull_centaurs.count = unit_set_counts["wh3_dlc23_chd_category_bull_centaurs"]
	hellforge.faction_unit_count.flying_beasts.count = unit_set_counts["wh3_dlc23_chd_category_flying_beasts"]

	local total_upgradeable_unit_count = 0
	for _, v in pairs(hellforge.faction_unit_count) do
		total_upgradeable_unit_count = total_upgradeable_unit_count + v.count
	end
	local chosen_script_context = nil

	if total_upgradeable_unit_count ~= 0 then
		for _, v in pairs(hellforge.faction_unit_count) do
			if (v.count/total_upgradeable_unit_count)*100 >= v.required_percentage then
				chosen_script_context = v.script_context_to_apply
				break
			end
		end

		if chosen_script_context == nil then --If we don't find any units sets with a high enough percentage to choose to upgrade, we try again, lowering the required percentage by a small amount each time
			for _, v in pairs(hellforge.faction_unit_count) do
				if (v.count/total_upgradeable_unit_count)*100 >= v.required_percentage-5 then
					chosen_script_context = v.script_context_to_apply
					break
				end
			end
		end
	end

	if chosen_script_context == nil then --If we still don't find anything we default to missile infantry
		chosen_script_context = "cai_faction_script_context_beta"
	end

	cm:cai_set_faction_script_context(faction_key, chosen_script_context )
	for _, v in ipairs(hellforge.ai_data) do --Save which script context has been appplied to each faction so we can activate it when we load a save
		if v.faction_key == faction_key then
			v.active_script_context = chosen_script_context
		end
	end
end


function hellforge:get_pooled_resource_value_for_warmachine_progression(faction_key)
	local faction = cm:get_faction(faction_key)
	if faction ~= false then
		local resource_amount = faction:pooled_resource_manager():resource(self.warmachine_resource_key):value()
		return resource_amount
	end
	return false
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
    function(context)
		cm:save_named_value("hellforge_ai_data", hellforge.ai_data, context)
		cm:save_named_value("hellforge_incident_triggered", hellforge.incident_triggered_this_turn, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			hellforge.ai_data = cm:load_named_value("hellforge_ai_data", hellforge.ai_data, context)
			hellforge.incident_triggered_this_turn = cm:load_named_value("hellforge_incident_triggered", hellforge.incident_triggered_this_turn, context)
		end
	end
)
