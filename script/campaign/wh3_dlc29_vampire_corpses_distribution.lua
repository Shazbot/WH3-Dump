vampire_corpses_distribution = {
	--=== CONFIG ===--
    vampire_counts_subculture = "wh_main_sc_vmp_vampire_counts",
	vampire_counts_faction_set = "vampire_counts",
	corpses_resource = "wh3_dlc29_vmp_corpses",
	corpses_factor = "battles", -- "wh3_dlc29_vmp_corpses_battles" in pooled_resource_factor_junctions, but here we need the factor name from pooled_resource_factors.
	corpses_scope = "FACTION_PROVINCE_PERSISTENT",
	corpses_scripted_bonus_value = "corpse_battle_gain",
	corpses_adjacent_scripted_bonus_value = "corpse_battle_gain_adjacent",
	corpses_to_gold_ratio = 1.6,
	global_corpses_drop_modifier = 0.2,

	no_vampires_distribution_factor = 0.1,	-- how many corpses to distribute when there arent vampires on any side
	one_side_winning_distribution_factor = 1, -- when only one side has vampires, how much to give to the winning vampire side, the inverse goes to destroyed corpses
	one_side_losing_distribution_factor = 0.2, -- when only one side has vampires, how much to give to the losing vampire side, the inverse goes to destroyed corpses
	both_sides_winning_distribution_factor = 0.8,	-- when both sides have vampires, how much to give to the winning vampire side, the inverse goes to the losing side
	even_distribution_factor = 0.3,	-- factor for how much of the corpses are distributed among vampires on the winning side irregardless of anything, iverse gets distributed by casualty ratios
}

-- initialization
function vampire_corpses_distribution:initialise()
	self:add_listeners()
end

-- gather attacker and defender into lists of character interfaces, where index 1 is the "main" attacker/defender
function vampire_corpses_distribution:get_attackers_and_defenders(pending_battle)
	local attackers = {}
	if pending_battle:has_attacker() == true then
		local attacker = pending_battle:attacker()
		table.insert(attackers, attacker)

		local secondary_attackers = pending_battle:secondary_attackers()
		for i = 0, secondary_attackers:num_items() - 1 do
			local secondary_attacker = secondary_attackers:item_at(i)
			table.insert(attackers, secondary_attacker)
		end
	end

	local defenders = {}
	if pending_battle:has_defender() == true then
		local defender = pending_battle:defender()
		table.insert(defenders, defender)

		local secondary_defenders = pending_battle:secondary_defenders()
		for i = 0, secondary_defenders:num_items() - 1 do
			local secondary_defender = secondary_defenders:item_at(i)
			table.insert(defenders, secondary_defender)
		end
	end

	return {
		attackers = attackers,
		defenders = defenders
	}
end

function vampire_corpses_distribution:get_units_for_character(character)
	local unit_list = character:military_force():unit_list()

	local units = {}

	for i = 1, unit_list:num_items() - 1 do
		local unit = unit_list:item_at(i)
		local unit_key = unit:unit_key() 

		if unit:uses_hitpoints_in_campaign() then
			if units[unit_key] == nil then
				units[unit_key] = 
				{
					count = 1, 
					uses_hitpoints_in_campaign = true,
					gold_cost = unit:get_unit_custom_battle_cost()
				}
			else
				units[unit_key].count = units[unit_key].count + 1
			end
		else
			if units[unit_key] == nil then
				units[unit_key] = 
				{
					percentage_proportion_of_full_strength = unit:percentage_proportion_of_full_strength(), 
					uses_hitpoints_in_campaign = false,
					gold_cost = unit:get_unit_custom_battle_cost()
				}
			else
				local last_percentage_proportion_of_full_strength = units[unit_key].percentage_proportion_of_full_strength
				local new_percentage_proportion_of_full_strength = last_percentage_proportion_of_full_strength + unit:percentage_proportion_of_full_strength()

				units[unit_key].percentage_proportion_of_full_strength = new_percentage_proportion_of_full_strength
			end
		end
	end

	return units
end

-- calculates a list of changes in unit (either % or count) for all characters
function vampire_corpses_distribution:calculate_unit_deltas(pre_battle_units, post_battle_units)
	local unit_deltas = {}

	for character_cqi, pre_battle_unit_list in pairs(pre_battle_units) do
		local total_strength = 0
		local total_casualties = 0
		local unit_deltas_for_character = {}

		local post_battle_units_for_character = post_battle_units[character_cqi]

		for pre_battle_unit_key, pre_battle_unit_data in pairs(pre_battle_unit_list) do
			local post_battle_unit_data

			if post_battle_units_for_character == nil then
				post_battle_unit_data = nil
			else
				post_battle_unit_data = post_battle_units_for_character[pre_battle_unit_key]
			end

			local unit_delta
			
			if pre_battle_unit_data.uses_hitpoints_in_campaign then
				unit_delta = pre_battle_unit_data.count - (post_battle_unit_data and post_battle_unit_data.count or 0)

				unit_delta = math.max(unit_delta, 0) -- just in case

				total_strength = total_strength + pre_battle_unit_data.count * 100
				total_casualties = total_casualties + unit_delta * 100
			else
				unit_delta = pre_battle_unit_data.percentage_proportion_of_full_strength - (post_battle_unit_data and post_battle_unit_data.percentage_proportion_of_full_strength or 0)

				unit_delta = math.max(unit_delta, 0) -- if something heals above its previous health, so just in case

				total_strength = total_strength + pre_battle_unit_data.percentage_proportion_of_full_strength
				total_casualties = total_casualties + unit_delta
			end

			unit_deltas_for_character[pre_battle_unit_key] = {
				delta = unit_delta, 
				uses_hitpoints_in_campaign = pre_battle_unit_data.uses_hitpoints_in_campaign,
				gold_cost = pre_battle_unit_data.gold_cost
			}
		end

		unit_deltas[character_cqi] = {
			total_strength = total_strength, -- same as the line below, we shall coerce single entity units up to the closest 100
			total_casualties = total_casualties, -- does not reflect partial health losses of single entity units
			unit_deltas = unit_deltas_for_character
		}
	end

	return unit_deltas
end

-- filters and counts the characters from a character list that are of the correct subculture
function vampire_corpses_distribution:filter_vampire_counts_subculure_characters(characters)
	local selected_characters = {}

	for i, character in pairs(characters) do
		local faction = character:faction()

		if faction:culture() ~= nil then
			if faction:subculture() ~= nil and faction:subculture() == self.vampire_counts_subculture then
				selected_characters[character:cqi()] = character
			end
		end
	end

	return selected_characters
end

-- what % of the losses taken on one side belong to a character on that side
function vampire_corpses_distribution:calculate_casualty_ratios_for_side(unit_deltas, characters)
	local casualty_ratios = {}

	local total_casulaties = 0

	for character_cqi, _ in pairs(characters) do
		total_casulaties = total_casulaties + unit_deltas[character_cqi].total_casualties
	end

	for character_cqi, _ in pairs(characters) do
		casualty_ratios[character_cqi] = total_casulaties > 0 and (unit_deltas[character_cqi].total_casualties / total_casulaties) or 0
	end

	return casualty_ratios
end

-- calculates corpses from unit deltas provided
function vampire_corpses_distribution:calculate_corpses(unit_deltas)
	local corpses = {}
	local total_corpses = 0

	for character_cqi, force_delta_data in pairs(unit_deltas) do
		local character_unit_corpses = {}
		local character_total_corpses = 0

		for unit_key, unit_delta_data in pairs(force_delta_data.unit_deltas) do
			local delta = unit_delta_data.delta
			local uses_hitpoints_in_campaign = unit_delta_data.uses_hitpoints_in_campaign
			local gold_cost = unit_delta_data.gold_cost

			local unit_corpses

			if uses_hitpoints_in_campaign then
				unit_corpses = self:unit_corpse_cost(gold_cost) * delta * self.global_corpses_drop_modifier
			else
				unit_corpses = math.round(self:unit_corpse_cost(gold_cost) * (delta / 100) * self.global_corpses_drop_modifier)
			end

			character_total_corpses = character_total_corpses + unit_corpses
			character_unit_corpses[unit_key] = unit_corpses
		end

		corpses[character_cqi] = {
			total_corpses = character_total_corpses,
			unit_corpses = character_unit_corpses,
		}

		total_corpses = total_corpses + character_total_corpses
	end

	return {
		total = total_corpses,
		corpses = corpses
	}
end

function vampire_corpses_distribution:unit_corpse_cost(gold_cost)
	return self:round_to_nearest_10(gold_cost * vampire_corpses_distribution.corpses_to_gold_ratio)
end

function vampire_corpses_distribution:round_to_nearest_10(number)
	return math.round(number / 10) * 10
end

function vampire_corpses_distribution:select_pooled_resource_managers_from_faction_provinces_with_subculture(faction_provinces, subculture)
	local selected = {}

	for i = 0, faction_provinces:num_items() - 1 do
		local pooled_resource_manager = faction_provinces:item_at(i):pooled_resource_manager()

		if pooled_resource_manager:has_owning_faction() then
			local faction = pooled_resource_manager:owning_faction()

    		if faction:subculture() == subculture then
				selected[faction] = pooled_resource_manager
			end
		end
	end

	return selected
end

function vampire_corpses_distribution:split_pooled_resource_managers_by_sides(pooled_resource_managers, attackers, defenders)
	local split_pooled_resource_managers = {
		attackers = {},
		defenders = {}
	}


	for faction, pooled_resource_manager in pairs(pooled_resource_managers) do
		for i, character in pairs(attackers) do
			if faction == character:faction() then
				split_pooled_resource_managers.attackers[character:cqi()] = pooled_resource_manager
			end
		end
		for i, character in pairs(defenders) do
			if faction == character:faction() then
				split_pooled_resource_managers.defenders[character:cqi()] = pooled_resource_manager
			end
		end
	end

	return split_pooled_resource_managers
end

-- faction province distribution
function vampire_corpses_distribution:distribute_corpses_to_side(characters, corpses, casualty_ratios)
	if corpses == 0 then 
		return
	end

	local num_characters = table.size(characters)
	local even_corpses = (corpses * self.even_distribution_factor) / num_characters
	local casualty_ratio_corpses = corpses * (1 - self.even_distribution_factor)

	for character_cqi, character in dpairs(characters) do
		local faction = character:faction()
		local faction_key = faction:name()
		local character_bonus_modifier = cm:get_characters_bonus_value(character, self.corpses_scripted_bonus_value) / 100
		local faction_bonus_modifier = cm:get_factions_bonus_value(faction, self.corpses_scripted_bonus_value) / 100
		local province_bonus_modifier = 0

		if character:has_region() == true then
			local province = character:region():province()
			local current_faction_province = province:faction_province_for_faction(faction)

			if current_faction_province:is_null_interface() == false then
				province_bonus_modifier = cm:get_provinces_bonus_value(current_faction_province, self.corpses_adjacent_scripted_bonus_value) / 100
			end

			if province_bonus_modifier == 0 then
				local adjacent_provinces = province:adjacent_provinces()

				for province_index = 0, adjacent_provinces:num_items() - 1 do
					local adjacent_province = adjacent_provinces:item_at(province_index)
					local faction_province = adjacent_province:faction_province_for_faction(faction)

					if faction_province:is_null_interface() == false then
						province_bonus_modifier = cm:get_provinces_bonus_value(faction_province, self.corpses_adjacent_scripted_bonus_value) / 100
						break;
					end
				end
			end
		end

		local total_bonus_modifier = 1 + character_bonus_modifier + faction_bonus_modifier + province_bonus_modifier
		out("corpse bonus modifiers = "..total_bonus_modifier.." ("..character_bonus_modifier.." | "..faction_bonus_modifier.." | "..province_bonus_modifier..")")
		local casualty_ratio_corpses_for_faction = casualty_ratio_corpses * casualty_ratios[character_cqi]
		local corpses_for_faction = (even_corpses + casualty_ratio_corpses_for_faction) * total_bonus_modifier
		corpses_for_faction = self:round_to_nearest_10(corpses_for_faction)

		out("giving " .. corpses_for_faction .. " corpses to " .. faction_key)

		cm:faction_add_post_battle_looted_resource(faction_key, self.corpses_resource, self.corpses_factor, self.corpses_scope, corpses_for_faction) 
	end
end

function vampire_corpses_distribution:distribute_corpses_evenly(characters, corpses)
	if corpses == 0 then 
		return
	end

	local num_characters = table.size(characters)
	local corpses_for_faction = corpses / num_characters

	for character_cqi, character in dpairs(characters) do
		local faction = character:faction()
		local faction_key = faction:name()
		local character_bonus_modifier = cm:get_characters_bonus_value(character, self.corpses_scripted_bonus_value) / 100
		local faction_bonus_modifier = cm:get_factions_bonus_value(faction, self.corpses_scripted_bonus_value) / 100
		local province_bonus_modifier = 0

		if character:has_region() == true then
			local province = character:region():province()
			local current_faction_province = province:faction_province_for_faction(faction)

			if current_faction_province:is_null_interface() == false then
				province_bonus_modifier = cm:get_provinces_bonus_value(current_faction_province, self.corpses_adjacent_scripted_bonus_value) / 100
			end

			if province_bonus_modifier == 0 then
				local adjacent_provinces = province:adjacent_provinces()

				for province_index = 0, adjacent_provinces:num_items() - 1 do
					local adjacent_province = adjacent_provinces:item_at(province_index)
					local faction_province = adjacent_province:faction_province_for_faction(faction)

					if faction_province:is_null_interface() == false then
						province_bonus_modifier = cm:get_provinces_bonus_value(faction_province, self.corpses_adjacent_scripted_bonus_value) / 100
						break;
					end
				end
			end
		end

		local total_bonus_modifier = 1 + character_bonus_modifier + faction_bonus_modifier + province_bonus_modifier
		out("corpse bonus modifiers = "..total_bonus_modifier.." ("..character_bonus_modifier.." | "..faction_bonus_modifier.." | "..province_bonus_modifier..")")
		corpses_for_faction = self:round_to_nearest_10(corpses_for_faction * total_bonus_modifier)

		out("giving " .. corpses_for_faction .. " corpses to " .. faction_key)

		cm:faction_add_post_battle_looted_resource(faction_key, self.corpses_resource, self.corpses_factor, self.corpses_scope, corpses_for_faction) 
	end
end

function vampire_corpses_distribution:debug_print_units(units)
	out ("---=== units ===---")
	for character_cqi, units in dpairs(units) do
		out ("character_cqi: " .. character_cqi)
		for unit_key, unit_data in dpairs(units) do
			out ("	unit_key: " .. unit_key)
			if unit_data.uses_hitpoints_in_campaign then
				out ("		count: " .. unit_data.count)
			else
				out ("		percentage_proportion_of_full_strength: " .. unit_data.percentage_proportion_of_full_strength)
			end
			out ("		gold_cost: " .. unit_data.gold_cost)
		end
	end
end

function vampire_corpses_distribution:debug_print_unit_deltas(unit_deltas)
	out ("---=== unit deltas ===---")
	for character_cqi, units in dpairs(unit_deltas) do
		out ("character_cqi: " .. character_cqi)
		out ("	total strength: " .. units.total_strength)
		out ("	total casualties: " .. units.total_casualties)
		for unit_key, unit_data in dpairs(units.unit_deltas) do
			out ("	unit_key: " .. unit_key)
			if unit_data.uses_hitpoints_in_campaign then
				out ("		delta (count): " .. unit_data.delta)
			else
				out ("		delta: " .. unit_data.delta)
			end
			out ("		gold_cost: " .. unit_data.gold_cost)
		end
	end
end

function vampire_corpses_distribution:debug_print_corpses(corpses)
	out ("---=== corpses ===---")
	out ("total corpses: " .. corpses.total)
	for character_cqi, corpses_data in dpairs(corpses.corpses) do
		out ("character_cqi: " .. character_cqi)
		out ("	total corpses: " .. corpses_data.total_corpses)
		for unit_key, corpses in dpairs(corpses_data.unit_corpses) do
			out ("	unit_key: " .. unit_key)
			out ("		corpses: " .. corpses)
		end
	end
end

-- add listeners
function vampire_corpses_distribution:add_listeners()
	core:add_listener(
		"battle_started_corpse_distribution",
		"BattleBeingFought",
		function(context)
			local pending_battle = cm:model():pending_battle()

			return pending_battle:is_active() and not pending_battle:has_been_fought()
		end,
		function(context)
			local pending_battle = cm:model():pending_battle()

			local attackers_and_defenders = self:get_attackers_and_defenders(pending_battle)
			local attackers = attackers_and_defenders.attackers
			local defenders = attackers_and_defenders.defenders

			local pre_battle_units = {}

			for _, attacker in pairs(attackers) do
				pre_battle_units[attacker:cqi()] = self:get_units_for_character(attacker)
			end
			for _, defender in pairs(defenders) do
				pre_battle_units[defender:cqi()] = self:get_units_for_character(defender)
			end

			--self:debug_print_units(pre_battle_units)

			cm:set_saved_value("vampire_corpses_distribution_pre_battle_units", pre_battle_units)
		end,
		true
	)
	core:add_listener(
		"battle_completed_corpse_distribution",
		"BattleConflictFinished",
		function(context)
			local pending_battle = context:model():pending_battle()

			return pending_battle:has_been_fought()
		end,
		function(context)
			local pending_battle = context:model():pending_battle()

			-- get attackers and defenders and their units
			local attackers_and_defenders = self:get_attackers_and_defenders(pending_battle)
			local attackers = attackers_and_defenders.attackers
			local defenders = attackers_and_defenders.defenders

			local pre_battle_units = cm:get_saved_value("vampire_corpses_distribution_pre_battle_units")
			local post_battle_units = {}

			for _, attacker in pairs(attackers) do
				post_battle_units[attacker:cqi()] = self:get_units_for_character(attacker)
			end
			for _, defender in pairs(defenders) do
				post_battle_units[defender:cqi()] = self:get_units_for_character(defender)
			end

			--self:debug_print_units(pre_battle_units)
			--self:debug_print_units(post_battle_units)

			local unit_deltas = self:calculate_unit_deltas(pre_battle_units, post_battle_units)

			local vampire_attackers = self:filter_vampire_counts_subculure_characters(attackers)
			local attacker_casualty_ratios = self:calculate_casualty_ratios_for_side(unit_deltas, vampire_attackers)

			local vampire_defenders = self:filter_vampire_counts_subculure_characters(defenders)
			local defender_casualty_ratios = self:calculate_casualty_ratios_for_side(unit_deltas, vampire_defenders)

			--self:debug_print_unit_deltas(unit_deltas)

			local corpses = self:calculate_corpses(unit_deltas)

			--self:debug_print_corpses(corpses)

			-- first, sum up all corpses
			-- second, check which sides the vampires are on and assign fraction of the total corpses to each side based on that and the battle outcome (win/draw/loss):
			--	both sides	-> both sides get corpses based on a winning/losing side split.
			-- 		winning side = both_sides_winning_distribution_factor
			--		losing side  = 1 - both_sides_winning_distribution_factor
			-- 	one side	-> the vampire side gets corpses based on whether they won or lost, the remainder corpses being destroyed
			--		wining side = one_side_winning_distribution_factor
			--		losing side = one_side_losing_distribution_factor
			--  none 		-> no_vampires_distribution_factor, distributed to vampire factions regardless of whether they have region ownership in the province

			local vampires_on_attacking_side = not table.is_empty(vampire_attackers)
			local vampires_on_defending_side = not table.is_empty(vampire_defenders)

			-- No Vampires on either side.
			if not vampires_on_attacking_side and not vampires_on_defending_side then
				local pending_battle_region = pending_battle:region_data()	-- We get the region_data from the pending battle.
				if not pending_battle_region:is_null_interface() then
					pending_battle_region = pending_battle_region:region()	-- We extract the region from the pending battle region data.
				end
				if pending_battle_region:is_null_interface() then
					return
				end
				local pending_battle_province = pending_battle_region:province()		-- We get the province from the pending battle region.
				if pending_battle_province:is_null_interface() then
					return
				end

				local corpses = corpses.total * self.no_vampires_distribution_factor
				local factions = pending_battle:model():world():lookup_factions_from_faction_set(self.vampire_counts_faction_set)
				for _, faction in model_pairs(factions) do
					if not faction:is_null_interface() then
						local pooled_resource_manager = cm:get_or_create_faction_province_persistent_pooled_resource_manager(faction, pending_battle_province)
						if not pooled_resource_manager:is_null_interface() then
							local pooled_resource = pooled_resource_manager:resource(self.corpses_resource)
							if not pooled_resource:is_null_interface() then
								cm:pooled_resource_factor_transaction(pooled_resource, self.corpses_factor, corpses)
							end
						end
					end
				end

			-- Vampires on both sides.
			elseif vampires_on_attacking_side and vampires_on_defending_side then
				local attacker_won = pending_battle:attacker_won()
				local winner_corpses = corpses.total * self.both_sides_winning_distribution_factor
				local loser_corpses = corpses.total * (1 - self.both_sides_winning_distribution_factor)
				self:distribute_corpses_to_side(vampire_attackers, attacker_won and winner_corpses or loser_corpses, attacker_casualty_ratios)
				self:distribute_corpses_to_side(vampire_defenders, attacker_won and loser_corpses or winner_corpses, defender_casualty_ratios)

			-- Vampires only on one side.
			else
				local attacker_won = pending_battle:attacker_won()
				if vampires_on_attacking_side then -- vampires only on attacker side
					local attacker_corpses = corpses.total * (attacker_won and self.one_side_winning_distribution_factor or self.one_side_losing_distribution_factor)
					self:distribute_corpses_to_side(vampire_attackers, attacker_corpses, attacker_casualty_ratios)
				elseif vampires_on_defending_side then  -- vampires only on defender side
					local defender_corpses = corpses.total * (attacker_won and self.one_side_losing_distribution_factor or self.one_side_winning_distribution_factor)
					self:distribute_corpses_to_side(vampire_defenders, defender_corpses, defender_casualty_ratios)
				end
			end
		end,
		true
	)
end