land_of_the_dead = {
	faction_key = "wh3_dlc29_nag_host_of_nagash",
	
	settlement_types = {
		necropolis = "wh3_dlc29_nag_necropolis",
		mausoleum = "wh3_dlc29_nag_mausoleum",
		burial_chambers = "wh3_dlc29_nag_chambers",
		pirate_cove = "wh3_dlc29_nag_cove"
	},
	
	vfx_key = "land_of_the_dead",
	map_event_key = "wh3_dlc29_nag_undead_legions",

	region_group_id = "land_of_the_dead",
	region_group_category_key = "wh3_dlc29_nag_land_of_the_dead",
	pooled_resource_key = "wh3_dlc29_nag_necromantic_energy",

	nagash_final_battle = "wh3_dlc29_nagash_narrative_final_battle",

	necropolis_building_chains = {
		"wh3_dlc29_nag_settlement_necropolis",
		"wh3_dlc29_special_settlement_nagashizzar_nag",
		"wh3_dlc29_special_settlement_pyramid_of_nagash_nag"
	},

	effect_bundles = {
		lotd = "wh3_dlc29_land_of_the_dead",
		devastated = "wh3_dlc29_land_of_the_dead_devastated",
		devastated_hidden = "wh3_dlc29_land_of_the_dead_devastated_capitol_hidden",
		necropolis_above_cap = "wh3_dlc29_necropolis_over_cap"
	},

	devastation_count = "wh3_dlc29_nag_devastation_count",
	necropolis_devastation_requirement = 3,
	necropolis_count_resource = "wh3_dlc29_nag_necropolises_count",
	necropolis_cap_resource = "wh3_dlc29_nag_necropolises_soft_cap",
	necropolis_cap_effects = {
		{
			key = "wh3_dlc29_pooled_resource_necromantic_energy_buildings_post_mod",
			value = -10,
			scope = "faction_to_region_own_regions"
		},
		{
			key = "wh3_dlc29_pooled_resource_necromantic_energy_battle_post_mod",
			value = -10,
			scope = "faction_to_force_own"
		},
		{
			key = "wh_main_effect_economy_gdp_mod_all",
			value = -10,
			scope = "faction_to_region_own_regions"
		}		
	},

	shared_states = {
		-- region key of the region where the necropolis is located
		necropolis_region_key = "land_of_the_dead_necropolis_region_key",

		-- list of all the region key of all the provinces linked to the necropolis, separated with a semicolon (;)
		--
		-- example: "region_key_1;region_key_2;region_key_3"
		region_keys = "land_of_the_dead_region_keys"
	},

	devastation = {
		ritual = "wh3_dlc29_ritual_nag_devastate_province"
	}
}

---@class land_of_the_dead
---@field dynamic_data table<string, table>
land_of_the_dead.dynamic_data = {
	
--	<region key> = {
--  	region_group_id = "<string id of the group>"
-- 		province_keys = { <province key 1>, <province key 2>, ... }
-- 	},
-- 	...
}

land_of_the_dead.devastation_provinces = {
--	<region_key> = true		
}


function land_of_the_dead:initialise()
	self:add_listeners()
end

function land_of_the_dead:add_listeners()
	-- converting a settlement to a necropolis creates land of the dead
	core:add_listener(
		"SettlementTypeConvertedEvent_LoD_Necropolis_Converted",
		"SettlementTypeConvertedEvent",
		function(context)
			local faction = context:settlement():faction()
			local is_valid_faction = faction:name() == self.faction_key

			if not is_valid_faction then
				return false
			end

			local settlement_type_key = context:settlement():settlement_type_key()

			for _, type in pairs(self.settlement_types) do
				if settlement_type_key == type then
					return true
				end
			end
		end,
		function(context)
			local settlement_type_key = context:settlement():settlement_type_key()
			local region = context:settlement():region()

			if settlement_type_key == self.settlement_types.necropolis then
				self:create(region)
			end
		end,
		true
	)

	-- converting a settlement from a necropolis destroys a land of the dead
	core:add_listener(
		"SettlementTypeConvertedEvent_LoD_Necropolis_Destroyed",
		"SettlementTypeConvertedEvent",
		function(context)
			local faction = context:settlement():faction()
			local is_valid_faction = faction:name() == self.faction_key
			if not is_valid_faction then
				return false
			end

			local settlement = context:settlement()
			local settlement_type_key = settlement:settlement_type_key()
			return settlement_type_key ~= self.settlement_types.necropolis and self:is_necropolis_region(settlement:region())
		end,
		function(context)
			local necropolis_region = context:settlement():region()
			local province = necropolis_region:province()

			self:destroy(necropolis_region)

			if province then
				for _, region in model_pairs(province:regions()) do
					self:update_region_effect_bundle(region)
				end
			end
		end,
		true
	)
	
	core:add_listener(
		"RegionFactionChangeEvent_LoD_Necropolis_Destroyed",
		"RegionFactionChangeEvent",
		true,
		function(context)
			local region = context:region()

			if context:previous_faction():name() == self.faction_key then
				--  region was lost
				if self:is_necropolis_region(region) then
					-- Losing a necropolis reshapes land of the dead
					self:destroy(region)
				else
					-- Losing a minor settlement requires VFX to be updated.
					cm:remove_region_vfx(region, self.vfx_key, true, false)
				end
			end

			self:update_region_effect_bundle(region)
		end,
		true
	)

	-- Update the necropolis cap based on the current number of devastated provinces.
	core:add_listener(
		"nagash_necropolis_cap_resource_update",
		"PooledResourceChanged",
		function(context)
			local faction = context:faction()

			return faction and not faction:is_null_interface() and 
				faction:name() == self.faction_key and 
				context:resource():key() == self.devastation_count
		end,
		function(context)
			self:update_necropolis_limit(context:faction())
		end,
		true
	)

	core:add_listener(
		"nagash_necropolis_initiative_state_changed",
		"FactionInitiativeActivationChangedEvent",
		function(context)
			return context:faction():name() == self.faction_key
		end,
		function(context)
			self:update_necropolis_limit(context:faction())
		end,
		true
	)

	core:add_listener(
		"nagash_necropolis_cap_turn_update",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == self.faction_key
		end,
		function(context)
			self:update_necropolis_limit(context:faction())
		end,
		true
	)

	core:add_listener(
		"Second_Stage_Mission",
		"MissionSucceeded",
		function(context)
			return context:mission():mission_record_key() == self.nagash_final_battle
		end,
		function(context)
			local faction = context:faction()

			-- delay required so that update occurs after effect bundle reward is applied.
			cm:callback(
				function()
					self:update_necropolis_limit(faction)
				end,
				0.5
			)
		end,
		true
	)	

	-- Apply negative effect bundle if you're above the Necropolis cap
	core:add_listener(
		"nagash_necropolis_count_resource_update",
		"PooledResourceChanged",
		function(context)
			local faction = context:faction()

			return faction and not faction:is_null_interface() and 
				faction:name() == self.faction_key and 
				(context:resource():key() == self.necropolis_count_resource or context:resource():key() == self.necropolis_cap_resource)
		end,
		function(context)
			local faction = context:faction()
			local necropolis_count_resource = faction:pooled_resource_manager():resource(self.necropolis_count_resource):value()
			local cap_bonus = cm:get_factions_bonus_value(faction, "bonus_necropolis_limit") or 0
			local necropolis_cap = faction:pooled_resource_manager():resource(self.necropolis_cap_resource):value()
			local cap_diff =  necropolis_count_resource - necropolis_cap

			if cap_diff > 0  then 
				local bundle = cm:create_new_custom_effect_bundle(self.effect_bundles.necropolis_above_cap)
				bundle:set_duration(0)

				for i = 1, #self.necropolis_cap_effects do 
					local effect = self.necropolis_cap_effects[i]
					local effect_value = effect.value * cap_diff

					if effect_value < -100 then
						effect_value = -100
					end

					bundle:add_effect(effect.key, effect.scope, effect_value)
				end
				cm:apply_custom_effect_bundle_to_faction(bundle, faction)
			else
				if faction:has_effect_bundle(self.effect_bundles.necropolis_above_cap) then 
					cm:remove_effect_bundle(self.effect_bundles.necropolis_above_cap, self.faction_key)
				end
			end
		end,
		true
	)

	core:add_listener(
		"WorldStartRound_LoD_Update_Devastation", 
		"FactionTurnStart", 
		function()
			return cm:turn_number() ~= 1
		end,
		function()
			self:remove_lotd_devastation()
		end,
		true
	)

	core:add_listener(
		"WorldStartRound_LoD_Update_Campaign_Start", 
		"WorldStartRound", 
		function()
			return cm:turn_number() == 1
		end,
		function()
			local faction = cm:get_faction(self.faction_key)
			local regions = faction:region_list()

			for i = 0, regions:num_items() - 1 do
				local region = regions:item_at(i)
				local settlement_type_key = region:settlement():settlement_type_key()

				if settlement_type_key == self.settlement_types.necropolis then
					self:create(region)
				end
			end
		end,
		false
	)

	core:add_listener(
		"LOTD_RitualCompletedEvent_Devastation",
		"RitualCompletedEvent",
		function(context)
			return self.devastation.ritual == context:ritual():ritual_key()
		end,
		function(context)
			local target_region = context:ritual_target_region()
			local province = target_region:province()
			-- the delay here is added so that the celebration animation that plays when devastating a province
			-- is already underway when we add the vfx, which causes a bit of stutter
			cm:callback(
				function()
					self.devastation_provinces[province:key()] = true
					devastation_manager:devastate_region(target_region:name(), 
						self.map_event_key,
						"land_of_the_dead"
					)
					cm:faction_add_pooled_resource(self.faction_key, self.devastation_count, "other", 1)

					for _, region in model_pairs(province:regions()) do
						self:update_region_effect_bundle(region)
						cm:add_region_vfx(region, self.vfx_key, true, false)
					end
				end,
				4.0
			)
		end,
		true
	)
end

function land_of_the_dead:create(necropolis_region)
	local necropolis_region_key = necropolis_region:name()
	local necropolis_province = necropolis_region:province()

	if self:is_province_free(necropolis_province:key()) == false then
		-- new necropolis is already part of a land of the dead, remove the province so it can form it's own land of the dead.
		self:remove_province_from_necropolis(necropolis_province, self:get_necropolis_region_key_for_province(necropolis_province:key()))
	end

	local affected_provinces = { necropolis_province }
	for _, province in model_pairs(necropolis_province:adjacent_provinces()) do
		local province_key = province:key()
		if self:is_province_free(province_key) then
			table.insert(affected_provinces, province)
		end
	end
	
	local affected_province_keys = {}
	for i = 1, #affected_provinces do
		local affected_province = affected_provinces[i]

		table.insert(affected_province_keys, affected_province:key())
	end

	-- store the provinces for this necropolis
	self.dynamic_data[necropolis_region_key] = {
		region_group_id = self.region_group_id,
		province_keys = affected_province_keys
	}

	self:on_created(necropolis_region, self.region_group_id, affected_provinces)
end

function land_of_the_dead:update_necropolis_limit(faction)
	local devastation_count = faction:pooled_resource_manager():resource(self.devastation_count):value()
	local cap_bonus = cm:get_factions_bonus_value(faction, "bonus_necropolis_limit") or 0
	local current_cap = faction:pooled_resource_manager():resource(self.necropolis_cap_resource):value()
	local new_cap = math.floor(devastation_count / self.necropolis_devastation_requirement) + 1

	cm:faction_add_pooled_resource(self.faction_key, self.necropolis_cap_resource, "wh3_dlc29_necropolis_cap_increase", new_cap - current_cap + cap_bonus)
end

function land_of_the_dead:destroy(necropolis_region)
	local necropolis_region_key = necropolis_region:name()

	local data = self.dynamic_data[necropolis_region_key]
	if data == nil then
		return
	end

	-- clear the data for this necropolis region
	self.dynamic_data[necropolis_region_key] = nil

	local province_keys = data.province_keys
	if province_keys == nil or table.is_empty(province_keys) then
		return
	end

	self:on_destroyed(necropolis_region, data.region_group_id, province_keys)
end

--- Called after a necropolis gets created and after the data for it has
--- been set up in `dynamic_data`
--- @param necropolis_region REGION_SCRIPT_INTERFACE the region where the newly created necropolis is
--- @param region_group_id string the ID for creating a region group for the land of the dead
--- @param provinces table<PROVINCE_SCRIPT_INTERFACE> list of the provinces linked to the necropolis
function land_of_the_dead:on_created(necropolis_region, region_group_id, provinces)
	local necropolis_region_key = necropolis_region:name()

	local regions = {}
	local region_keys = {}
	for i = 1, #provinces do
		local province = provinces[i]
		for _, region in model_pairs(province:regions()) do
			local region_key = region:name()
			self:on_region_added(region, necropolis_region_key)
			
			table.insert(regions, region)
			table.insert(region_keys, region_key)
			self:update_region_effect_bundle(region)
		end
	end

	-- create a region group if needed
	if cm:dynamic_region_group_exists(region_group_id) == false then
		cm:create_dynamic_region_group(region_group_id, self.region_group_category_key)
	end

	-- and a pooled resource manager for it, if needed
	if cm:dynamic_region_group_pooled_resource_manager_exists(region_group_id) == false then
		cm:create_dynamic_region_group_pooled_resource_manager(region_group_id)
	end

	for i = 1, #regions do
		local region = regions[i]
		cm:add_region_to_dynamic_region_group(region_group_id, region)
	end

	cm:faction_add_pooled_resource(self.faction_key, self.necropolis_count_resource, "other", 1)
	self:set_necropolis_region_keys_scripted_state(necropolis_region, region_keys)
end

--- Called after a necropolis gets destroyed and after the data for the affected
--- provinces has been removed from the `dynamic_data`
--- @param old_necropolis_region REGION_SCRIPT_INTERFACE the region that was a necropolis
--- @param region_group_id string the ID of the region group for the destroyed land of the dead
--- @param old_province_keys table<string> list of all provinces that were linked to the necropolis
function land_of_the_dead:on_destroyed(old_necropolis_region, region_group_id, old_province_keys)
	local old_provinces = {}
	
	for i = 1, #old_province_keys do
		local province_key = old_province_keys[i]
		local province = cm:get_province(province_key)
		if province then
			for _, region in model_pairs(province:regions()) do
				cm:remove_region_from_dynamic_region_group(region_group_id, region)
				self:on_region_removed(region)
				self:update_region_effect_bundle(region)
			end

			table.insert(old_provinces, province)
		end
	end
	
	-- remove the region group and its pooled resource manager
	-- only if there are no more necropoli
	if self:any_necropolis_exists() == false then
		cm:remove_dynamic_region_group_pooled_resource_manager(region_group_id)
		cm:remove_dynamic_region_group(region_group_id)
	end

	cm:faction_add_pooled_resource(self.faction_key, self.necropolis_count_resource, "other", -1)
	cm:remove_script_state(old_necropolis_region, self.shared_states.region_keys)

	self:handle_orphaned_provinces(old_provinces)
end

--- Try to attach orphaned provinces (just unlinked from a destroyed necropolis) to another existing necropolis
--- @param provinces table<PROVINCE_SCRIPT_INTERFACE> list of the orphaned provinces
function land_of_the_dead:handle_orphaned_provinces(provinces)
	local updated_necropolis_region_keys = {}

	-- possibly attach some (or all) provinces to another necropolis(es)
	-- also keep track of which necropolises have had new provinces attached
	for i = 1, #provinces do
		local province = provinces[i]
		local new_necropolis_region_key_to_attach_to = self:get_necropolis_region_key_from_adjacent_provinces(province)
		if new_necropolis_region_key_to_attach_to then
			self:attach_province_to_necropolis(province, new_necropolis_region_key_to_attach_to)
			table.add_unique(updated_necropolis_region_keys, new_necropolis_region_key_to_attach_to)
		end
	end

	-- update the shared state
	for i = 1, #updated_necropolis_region_keys do
		local necropolis_region_key = updated_necropolis_region_keys[i]
		local necropolis_region = cm:get_region(necropolis_region_key)
		if necropolis_region then
			local region_keys = self:get_all_region_keys_for_affected_provinces(necropolis_region)
			if table.is_empty(region_keys) then
				cm:remove_script_state(necropolis_region, self.shared_states.region_keys)
			else
				self:set_necropolis_region_keys_scripted_state(necropolis_region, region_keys)
			end
		end
	end
end

--- Gets all the region keys of all provinces affected by the `necropolis_region`
--- @param necropolis_region REGION_SCRIPT_INTERFACE the necropolis region
--- @return table<string>
function land_of_the_dead:get_all_region_keys_for_affected_provinces(necropolis_region)
	local region_keys = {}

	local necropolis_region_key = necropolis_region:name()
	local data = self.dynamic_data[necropolis_region_key]
	if not data then
		return region_keys
	end

	local province_keys = data.province_keys
	for j = 1, #province_keys do
		local province_key = province_keys[j]
		local province = cm:get_province(province_key)
		if province then
			for _, region in model_pairs(province:regions()) do
				table.insert(region_keys, region:name())
			end
		end
	end

	return region_keys
end

function land_of_the_dead:get_necropolis_region_key_from_adjacent_provinces(province)
	--check if any regions in the adjacent provinces of the province we've passed have entries in self.dynamic_data, meaning they are a necropolis
	for _, current_province in model_pairs(province:adjacent_provinces()) do
		for _, region in model_pairs(current_province:regions()) do
			local current_region_key = region:name()
			if self.dynamic_data[current_region_key] ~= nil then
				return current_region_key
			end
		end
	end

	return nil
end

function land_of_the_dead:attach_province_to_necropolis(province, necropolis_region_key)
	local data = self.dynamic_data[necropolis_region_key]
	if data == nil then
		return
	end

	local province_key = province:key()
	table.insert(data.province_keys, province_key)

	local region_group_id = data.region_group_id
	for _, region in model_pairs(province:regions()) do
		self:on_region_added(region, necropolis_region_key)

		cm:add_region_to_dynamic_region_group(region_group_id, region)
	end
end

function land_of_the_dead:remove_province_from_necropolis(province, old_necropolis_region_key)
	local data = self.dynamic_data[old_necropolis_region_key]
	if data == nil then
		return
	end

	for k, v in pairs(data.province_keys) do
		if v == province:key() then
			table.remove(data.province_keys, k)
		end
	end

	local region_group_id = data.region_group_id
	for _, region in model_pairs(province:regions()) do
		self:on_region_removed(region)

		cm:remove_region_from_dynamic_region_group(region_group_id, region)
	end
end

function land_of_the_dead:add_region_vfx(region)
	if region:owning_faction():name() == self.faction_key then
		cm:add_region_vfx(region, self.vfx_key, true, false)
	end
end

function land_of_the_dead:remove_lotd_devastation()
	local faction = cm:get_faction(self.faction_key)

	for province_key, _ in pairs(self.devastation_provinces) do
		local province = cm:get_province(province_key)
		local nagash_region_count = 0
		local region_count = province:regions():num_items()

		for _, region in model_pairs(province:regions()) do
			if region:owning_faction():name() == self.faction_key then
				nagash_region_count = nagash_region_count + 1
			end
		end

		-- If nagash doesn't own OVER half the province, the devastation will be cleansed
		if (region_count / 2) > nagash_region_count then
			devastation_manager:remove_devastation(province:capital_region():name())
			cm:faction_add_pooled_resource(self.faction_key, self.devastation_count, "other", -1)

			self.devastation_provinces[province_key] = nil

			for _, region in model_pairs(province:regions()) do
				self:update_region_effect_bundle(region)
				cm:remove_region_vfx(region, self.vfx_key, true, false)
			end
		end
	end
end

function land_of_the_dead:update_region_effect_bundle(region)
	local region_key = region:name()
	
	local province_key = region:province():key()

	self:remove_all_region_effect_bundles(region_key)
	if self:is_province_affected(province_key) then
		if land_of_the_dead.devastation_provinces[province_key] then
			cm:apply_effect_bundle_to_region(self.effect_bundles.devastated, region_key, -1)

			if region:owning_faction():name() == self.faction_key then
				cm:apply_effect_bundle_to_faction_province(self.effect_bundles.devastated_hidden, region, -1)
			end	
		else
			cm:apply_effect_bundle_to_region(self.effect_bundles.lotd, region_key, -1)
		end
	end
end

function land_of_the_dead:remove_all_region_effect_bundles(region_key)
	cm:remove_effect_bundle_from_region(self.effect_bundles.lotd, region_key)
	cm:remove_effect_bundle_from_region(self.effect_bundles.devastated, region_key)
	cm:remove_effect_bundle_from_faction_province(self.effect_bundles.devastated_hidden, cm:get_region(region_key))
end
--- Called every time when a region (as part of a province) is being
--- linked to a necropolis. This could happen when a new necropolis is created
--- or when one is destroyed and the region is linked to another one close by.
--- 
--- @param region REGION_SCRIPT_INTERFACE the region that is being linked to a necropolis
--- @param necropolis_region_key string the key of the region where the necropolis is located
function land_of_the_dead:on_region_added(region, necropolis_region_key)
	cm:set_script_state(region, self.shared_states.necropolis_region_key, necropolis_region_key)
end

--- Called every time when a region (as part of a province) is being
--- unlinked from a necropolis. This would happen when a necropolis is being destroyed.
--- 
--- @param region REGION_SCRIPT_INTERFACE the region that is being unlinked from a necropolis
function land_of_the_dead:on_region_removed(region)
	cm:remove_script_state(region, self.shared_states.necropolis_region_key)
	cm:remove_region_vfx(region, self.vfx_key, true, false)
end

function land_of_the_dead:set_necropolis_region_keys_scripted_state(necropolis_region, region_keys)
	local region_keys_str = table.concat(region_keys, ";")
	cm:set_script_state(necropolis_region, self.shared_states.region_keys, region_keys_str)
end

--- Find the region key that a province is linked to (if any), or `nil` otherwise
--- @param province_key string the key of the province
--- @return string | nil
function land_of_the_dead:get_necropolis_region_key_for_province(province_key)
	for region_key, data in pairs(self.dynamic_data) do
		if table.find(data.province_keys, province_key) then
			return region_key
		end
	end

	return nil
end

--- Check whether a province is affected by land of the dead (linked to a necropolis)
--- @param province_key string the key of the province
--- @return boolean
function land_of_the_dead:is_province_affected(province_key)
	return self:get_necropolis_region_key_for_province(province_key) ~= nil
end

--- Check whether a province is not linked to any necropolis
--- @param province_key string the key of the province
--- @return boolean
function land_of_the_dead:is_province_free(province_key)
	return self:is_province_affected(province_key) == false
end

--- Check whether a region is a necropolis
--- @param region REGION_SCRIPT_INTERFACE
--- @return boolean
function land_of_the_dead:is_necropolis_region(region)
	local region_key = region:name()
	local has_necropolis = self.dynamic_data[region_key] ~= nil
	return has_necropolis
end

--- Check whether there is any necropolis currently built
--- @return boolean
function land_of_the_dead:any_necropolis_exists()
	return self.dynamic_data and table.is_empty(self.dynamic_data) == false
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_pre_first_tick_callback(
	function ()
		for province_key, _ in pairs(land_of_the_dead.devastation_provinces) do
			local province = cm:get_province(province_key)

			for _, region in model_pairs(province:regions()) do
				cm:add_region_vfx(region, land_of_the_dead.vfx_key, true, false)
			end
		end
	end
)

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("LandOfTheDead", land_of_the_dead.dynamic_data, context)
		cm:save_named_value("LandOfTheDeadDevastation", land_of_the_dead.devastation_provinces, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			land_of_the_dead.dynamic_data = cm:load_named_value("LandOfTheDead", land_of_the_dead.dynamic_data, context)
			land_of_the_dead.devastation_provinces = cm:load_named_value("LandOfTheDeadDevastation", land_of_the_dead.devastation_provinces, context)
		end
	end
)
