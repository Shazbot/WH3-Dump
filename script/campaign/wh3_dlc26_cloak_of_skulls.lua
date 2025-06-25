cloak_of_skulls = {
	faction_key = "wh3_dlc26_kho_skulltaker",
	resource_key = "wh3_dlc26_kho_champions_essence",
	faction_resource_key = "wh3_dlc26_kho_champions_essence_faction",
	champions_essence_base_amount = 5,
	champions_essence_lord_type_not_yet_defeated_amount = 10,
	scaling_effects = { -- effect bundle/ritual key, effect key
		wh3_dlc26_kho_cloak_of_skulls_5 = {
			{"wh3_dlc26_kho_cloak_of_skulls_5_1", "wh_main_effect_character_stat_bonus_vs_infantry"},
			{"wh3_dlc26_kho_cloak_of_skulls_5_2", "wh_main_effect_character_stat_melee_attack"},
			{"wh3_dlc26_kho_cloak_of_skulls_5_3", "wh_main_effect_character_stat_weapon_strength"}
		},
		wh3_dlc26_kho_cloak_of_skulls_6 = {
			{"wh3_dlc26_kho_cloak_of_skulls_6_1", "wh_main_effect_character_stat_melee_defence"},
			{"wh3_dlc26_kho_cloak_of_skulls_6_2", "wh_main_effect_character_stat_armour"},
			{"wh3_dlc26_kho_cloak_of_skulls_6_3", "wh_main_effect_character_stat_physical_resistance"}
		}
	},
	stacking_ritual_effect_bundles = { -- perform ritual, remove effect bundle. they need to be removed because the effect stacks (it uses the same effect), and we want the value to appear combined
		wh3_dlc26_kho_cloak_of_skulls_1_3 = {"wh3_dlc26_kho_cloak_of_skulls_1_1", "wh3_dlc26_kho_cloak_of_skulls_1_2"},
		wh3_dlc26_kho_cloak_of_skulls_2_2 = "wh3_dlc26_kho_cloak_of_skulls_2_1",
		wh3_dlc26_kho_cloak_of_skulls_3_2 = "wh3_dlc26_kho_cloak_of_skulls_3_1",
		wh3_dlc26_kho_cloak_of_skulls_3_3 = "wh3_dlc26_kho_cloak_of_skulls_3_2",
		wh3_dlc26_kho_cloak_of_skulls_8_2 = "wh3_dlc26_kho_cloak_of_skulls_8_1",
		wh3_dlc26_kho_cloak_of_skulls_9_2 = "wh3_dlc26_kho_cloak_of_skulls_9_1"
	}
}	
	
function cloak_of_skulls:initialise()
	if not cm:get_faction(self.faction_key) then return end

	if cm:is_new_game() then
		cm:perform_ritual(self.faction_key, "", "wh3_dlc26_kho_cloak_of_skulls_1_1")
	end
	
	if not cm:get_saved_value("cloak_of_skulls_active") and cm:get_faction(self.faction_key):is_human() then
		cm:override_ui("disable_cloak_of_skulls_button", true)

		core:add_listener(
			"cloak_of_skulls_unlock_button",
			"PooledResourceChanged",
			function(context)
				local pr = context:resource()
				return pr:key() == self.faction_resource_key and pr:value() >= 25 and context:faction():is_human()
			end,
			function()
				cm:override_ui("disable_cloak_of_skulls_button", false)
				cm:set_saved_value("cloak_of_skulls_active", true)
			end,
			false
		)
	end
	
	core:add_listener(
		"skulltaker_assign_champions_essence_start_round",
		"WorldStartRound",
		true,
		function()
			self:update_all_military_force_champions_essence()
		end,
		true
	)
	
	core:add_listener(
		"skulltaker_assign_champions_essence_character_created",
		"CharacterCreated",
		function(context)
			return cm:char_is_general_with_army(context:character())
		end,
		function(context)
			self:update_military_forces_champions_essence(context:character():military_force())
		end,
		true
	)

	core:add_listener(
		"skulltaker_cache_champions_essence_pending_battle",
		"PendingBattle",
		function(context)
			local pb = context:pending_battle()

			if (pb:has_attacker() and pb:attacker():faction():name() == self.faction_key) or (pb:has_defender() and pb:defender():faction():name() == self.faction_key) then return true end

			for _, attacker in model_pairs(pb:secondary_attackers()) do
				if attacker:faction():name() == self.faction_key then return true end
			end
			
			for _, defender in model_pairs(pb:secondary_defenders()) do
				if defender:faction():name() == self.faction_key then return true end
			end
		end,
		function()
			if cm:pending_battle_cache_faction_is_defender(self.faction_key) then
				for i = 1, cm:pending_battle_cache_num_attackers() do
					local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_attacker(i)

					self:cache_champions_essence_pending_battle(mf_cqi)
				end
			else
				for i = 1, cm:pending_battle_cache_num_defenders() do
					local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_defender(i)

					self:cache_champions_essence_pending_battle(mf_cqi)
				end
			end
		end,
		true
	)

	core:add_listener(
		"skulltaker_faction_kills_character",
		"BattleCompleted",
		function()
			return cm:pending_battle_cache_faction_is_involved(self.faction_key)
		end,
		function()
			local mf_cqis_defeated = {}
			local skulltaker_character_cqi = 0

			if cm:pending_battle_cache_faction_is_defender(self.faction_key) then
				for i = 1, cm:pending_battle_cache_num_attackers() do
					local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_attacker(i)

					local defeated_mf_cqi = self:add_champions_essence_post_battle(char_cqi, mf_cqi, cm:pending_battle_cache_get_attacker_subtype(i))

					if defeated_mf_cqi then
						table.insert(mf_cqis_defeated, defeated_mf_cqi)
					end
				end

				for i = 1, cm:pending_battle_cache_num_defenders() do
					local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_defender(i)
					if faction_name == self.faction_key then
						skulltaker_character_cqi = char_cqi
						break
					end
				end
			else
				for i = 1, cm:pending_battle_cache_num_defenders() do
					local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_defender(i)

					local defeated_mf_cqi = self:add_champions_essence_post_battle(char_cqi, mf_cqi, cm:pending_battle_cache_get_defender_subtype(i))

					if defeated_mf_cqi then
						table.insert(mf_cqis_defeated, defeated_mf_cqi)
					end
				end

				for i = 1, cm:pending_battle_cache_num_attackers() do
					local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_attacker(i)
					if faction_name == self.faction_key then
						skulltaker_character_cqi = char_cqi
						break
					end
				end
			end

			if #mf_cqis_defeated > 0 then self:defeated_character_apply_bonuses(mf_cqis_defeated, skulltaker_character_cqi) end
		end,
		true
	)

	-- track the number of empowered skulls to add scaled effects
	core:add_listener(
		"skulltaker_cloak_empowered",
		"RitualCompletedEvent",
		function(context)
			return context:ritual():ritual_category() == "CLOAK_OF_SKULLS"
		end,
		function(context)
			local faction = context:performing_faction()
			local faction_name = faction:name()
			local ritual_key = context:ritual():ritual_key()
			local count = cm:get_saved_value("skulltaker_num_skulls_empowered") or 1 -- start at 1 as the first skull is empowered at game start

			count = count + 1

			cm:set_saved_value("skulltaker_num_skulls_empowered", count)

			local rituals = faction:rituals()

			for effect_bundle, data in pairs(self.scaling_effects) do
				if faction:has_effect_bundle(effect_bundle) then
					cm:remove_effect_bundle(effect_bundle, faction_name)
				end

				local scaling_bundle = cm:create_new_custom_effect_bundle(effect_bundle)
				local apply = false

				for i = 1, #data do
					if rituals:ritual_status(data[i][1]):already_completed_in_chain() then
						if faction:has_effect_bundle(data[i][1]) then
							cm:remove_effect_bundle(data[i][1], faction_name)
						end

						scaling_bundle:add_effect(data[i][2], "faction_to_faction_leader", count)
						apply = true
					end
				end

				if apply then cm:apply_custom_effect_bundle_to_faction(scaling_bundle, faction) end
			end

			if self.stacking_ritual_effect_bundles[ritual_key] then
				local bundle = self.stacking_ritual_effect_bundles[ritual_key]

				if is_table(bundle) then
					for i = 1, #bundle do
						cm:remove_effect_bundle(bundle[i], faction_name)
					end
				else
					cm:remove_effect_bundle(bundle, faction_name)
				end
			end
		end,
		true
	)
end

function cloak_of_skulls:add_champions_essence_post_battle(char_cqi, mf_cqi, subtype)
	self:update_military_forces_champions_essence(mf_cqi)

	if cm:get_character_by_cqi(char_cqi) then return false end

	local resource_value = cm:get_saved_value("champions_essence_value_" .. mf_cqi) or 0

	if is_table(resource_value) then resource_value = resource_value[1] end
	
	if resource_value <= 0 then return false end

	if not cm:get_saved_value("skulltaker_defeated_subtype_" .. subtype) then
		cm:set_saved_value("skulltaker_defeated_subtype_" .. subtype, true)

		-- refresh any other subtypes values
		self:update_all_military_force_champions_essence()
	end

	cm:pooled_resource_factor_transaction(cm:get_faction(self.faction_key):pooled_resource_manager():resource(self.faction_resource_key), "lords_defeated", resource_value)

	return mf_cqi
end

function cloak_of_skulls:defeated_character_apply_bonuses(mf_cqis_defeated, skulltaker_character_cqi)
	local faction = cm:get_faction(self.faction_key)

	-- bonuses that require a winning character
	local winning_character = cm:get_character_by_cqi(skulltaker_character_cqi)

	if not winning_character or not winning_character:has_military_force() then return end

	local skulls_bonus = cm:get_characters_bonus_value(winning_character, "cloak_of_skulls_gain_skulls")

	if skulls_bonus > 0 then
		cm:faction_add_pooled_resource(self.faction_key, "wh3_main_kho_skulls", "cloak_of_skulls", skulls_bonus)
	end

	local corruption_bonus = cm:get_characters_bonus_value(winning_character, "cloak_of_skulls_khorne_corruption")

	if corruption_bonus > 0 then
		for _, faction_province in model_pairs(faction:provinces()) do
			cm:pooled_resource_factor_transaction(faction_province:province():pooled_resource_manager():resource("wh3_main_corruption_khorne"), "local_populace", corruption_bonus)
		end
	end

	local replenish_bloodhost_bonus = cm:get_characters_bonus_value(winning_character, "cloak_of_skulls_replenish_bloodhost")

	if replenish_bloodhost_bonus > 0 then
		for _, mf in model_pairs(faction:military_force_list()) do
			if mf:force_type():key() == "DISCIPLE_ARMY" then
				for _, unit in model_pairs(mf:unit_list()) do
					local health_to_set = (unit:percentage_proportion_of_full_strength() + replenish_bloodhost_bonus) / 100
					cm:set_unit_hp_to_unary_of_maximum(unit, math.min(health_to_set, 1))
				end
			end
		end
	end

	if cm:get_characters_bonus_value(winning_character, "cloak_of_skulls_reveal_vision") > 0 then
		for _, region in model_pairs(cm:model():world():region_manager():region_list()) do
			if region:is_abandoned() then
				cm:make_region_visible_in_shroud(self.faction_key, region:name())
			end
		end
	end

	if cm:get_characters_bonus_value(winning_character, "kho_spawned_army_skulltaker") > 0 then
		khorne_spawned_armies:spawn_army(winning_character, true)
	end

	local xp_bonus = cm:get_characters_bonus_value(winning_character, "cloak_of_skulls_gain_defeated_experience")

	if xp_bonus > 0 then
		local total_xp = 0

		for i = 1, #mf_cqis_defeated do
			local current_mf_cqi_saved_data = cm:get_saved_value("champions_essence_value_" .. mf_cqis_defeated[i])
			
			if not current_mf_cqi_saved_data then
				script_error("Cloak of Skulls - could not look up saved data for military force cqi [" .. mf_cqis_defeated[i] .. "] - check the caching behaviour!")
				return false
			end
			
			local current_rank = current_mf_cqi_saved_data[2]
			
			if current_rank > 0 then
				total_xp = total_xp + cm.character_xp_per_level[current_rank]
			end
		end
		
		local xp_to_add = math.round(total_xp * (xp_bonus / 100))

		if xp_to_add > 0 then cm:add_agent_experience(cm:char_lookup_str(winning_character), xp_to_add) end

		local shared_xp_bonus = cm:get_characters_bonus_value(winning_character, "cloak_of_skulls_gain_defeated_experience_spread")
		
		if shared_xp_bonus > 0 then
			xp_to_add = math.round(total_xp * (shared_xp_bonus / 100))
			
			if xp_to_add > 0 then
				for _, force in model_pairs(faction:military_force_list()) do
					if force:has_general() and not force:is_armed_citizenry() then
						local character = force:general_character()

						if not character:is_faction_leader() then
							cm:add_agent_experience(cm:char_lookup_str(character), xp_to_add)
						end
					end
				end
			end
		end
	end

	if cm:get_characters_bonus_value(winning_character, "cloak_of_skulls_colonise_ruins") > 0 and winning_character:has_region() then
		for _, region in model_pairs(winning_character:region():province():regions()) do
			if region:is_abandoned() and start_region:has_effect_bundle("wh3_main_book_of_khorne_block_occupation") == false then
				cm:transfer_region_to_faction(region:name(), faction:name())
			end
		end
	end

	local ap_bonus = cm:get_characters_bonus_value(winning_character, "campaign_movement_range_post_defeat_lord")

	if ap_bonus > 0 then
		cm:replenish_action_points(cm:char_lookup_str(winning_character), (winning_character:action_points_remaining_percent() + ap_bonus) / 100);
	end

	if cm:get_characters_bonus_value(winning_character, "cloak_of_skulls_replenish_army") > 0 then
		for _, unit in model_pairs(winning_character:military_force():unit_list()) do
			cm:set_unit_hp_to_unary_of_maximum(unit, 1)
		end
	end

	if cm:get_characters_bonus_value(winning_character, "cloak_of_skulls_move_skull_piles") > 0 then
		local skull_piles = cm:get_saved_value("skull_piles") or {}
		local indexed_skull_piles = {}

		for k, v in pairs(skull_piles) do
			table.insert(indexed_skull_piles, k)
		end

		table.sort(indexed_skull_piles)

		for i = 1, #indexed_skull_piles do
			cm:remove_interactable_campaign_marker(indexed_skull_piles[i])

			local x, y = cm:find_valid_spawn_location_for_character_from_character(self.faction_key, cm:char_lookup_str(winning_character), false, i * 4)
			cm:add_interactable_campaign_marker(indexed_skull_piles[i], "wh3_main_kho_skull_pile", x, y, 2)
		end
	end
end

function cloak_of_skulls:cache_champions_essence_pending_battle(mf_cqi)
	local mf = cm:get_military_force_by_cqi(mf_cqi)

	if not mf then return end

	self:update_military_forces_champions_essence(mf)

	local resource = mf:pooled_resource_manager():resource(self.resource_key)

	local res_value = 0;

	if resource:is_null_interface() == false then
		res_value = resource:value();
	elseif mf:general_character():character_subtype("wh3_main_ksl_ataman") == true then
		res_value = 5;
	else
		return;
	end
	
	local rank = mf:general_character():rank();

	if rank < 1 then
		rank = 1;
	end

	cm:set_saved_value("champions_essence_value_" .. mf_cqi, {res_value, rank})
end

function cloak_of_skulls:update_all_military_force_champions_essence()
	for _, faction in model_pairs(cm:model():world():faction_list()) do
		for _, mf in model_pairs(faction:military_force_list()) do
			if mf:has_general() then
				self:update_military_forces_champions_essence(mf)
			end
		end
	end
end

function cloak_of_skulls:update_military_forces_champions_essence(mf)
	if is_number(mf) then mf = cm:get_military_force_by_cqi(mf)	end

	if not mf then return end

	local prm = mf:pooled_resource_manager()

	cm:apply_regular_reset_income(prm)

	local resource = prm:resource(self.resource_key)

	if resource:is_null_interface() then return end

	local general_cqi = mf:general_character():command_queue_index()

	cm:callback(
		function()
			local general = cm:get_character_by_cqi(general_cqi)

			if not general then return end

			local defeated_subtype = cm:get_saved_value("skulltaker_defeated_subtype_" .. general:character_subtype_key())

			cm:pooled_resource_factor_transaction(resource, "base_amount", self.champions_essence_base_amount)
			cm:pooled_resource_factor_transaction(resource, "lords_rank", 1 * general:rank())
			if not defeated_subtype then
				cm:pooled_resource_factor_transaction(resource, "lord_type_not_yet_defeated", self.champions_essence_lord_type_not_yet_defeated_amount)
			end
			local battles_won = general:battles_won()
			if battles_won > 0 then
				cm:pooled_resource_factor_transaction(resource, "battles_won_by_this_lord", 1 * battles_won)
			end

			-- apply at the end
			if not defeated_subtype and general:character_details():is_unique() then
				cm:pooled_resource_factor_transaction(resource, "immortal_lord", resource:value())
			end
		end,
		0.2
	)
end