nor_treacheries_config = {
	faction_key = "wh3_dlc27_nor_sayl",
	faction_cqi = 103,
	corruption_key = "wh3_main_corruption_chaos",
	sayl_treachery_per_faction_limit = 3, 			-- Max amount of traps per faction
	sayl_treachery_max_faction_limit = 4, 			-- Max amount of factions we can set traps on
	sayl_unlocked_treachery_per_faction_number = 1, -- Current amount of traps per faction
	sayl_unlocked_target_faction_number = 2, 		-- Current amount of factions on which we can set traps
	diplomatic_treacheries_cooldown = 5,
	treachery_ritual_key = "wh3_dlc27_nor_trap_foreign_slot",
	first_treachery_target = "wh3_dlc23_chd_zhatan",
	treachery_region_at_feature_unlock = "wh3_main_combi_region_fortress_of_eyes", -- to apply treachery to chaos dwarves when the feature is unlocked
	treachery_region_at_feature_unlock_backup = "wh3_main_combi_region_the_volary", -- to apply treachery to chaos dwarves when the feature is unlocked
	spawned_army_general_subtype = "wh3_dlc27_nor_marauder_spawned_army",
	settlement_types = {
		core = "wh3_dlc27_norsca_core_settlement",
		altar = "wh3_dlc27_norsca_altars_und",
	},
	incidents = {
		establish_treachery = "wh3_dlc27_incident_nor_sayl_establish_treachery",
	},
	pre_built_infiltration_building = "wh3_dlc27_nor_trap_core_infiltrate_1",
	sayl_trap_slot_set = "wh3_dlc27_nor_trap",
	sayl_trap_slot_set_template = "wh3_dlc27_nor_trap_1",
	are_slots_expanding = false,
	-- confidence config below
	confidence_resource_key = "wh3_dlc27_nor_confidence",
	confidence_resource_factor_deployed = "wh3_dlc27_nor_confidence_treachery_deployed",
	confidence_resource_factor_trigger = "wh3_dlc27_nor_confidence_treachery_spread",
	confidence_per_established_treachery = 5
}

-- Script logic for each effect activation
treachery_building_activations = {

	-- Treasury building
	["gain_treasury"] = {
		callback = function(region, faction, bonus_value) 
			local treasury_reward = bonus_value * region:settlement():primary_slot():building():building_level() 
			cm:treasury_mod(faction:name(), treasury_reward)
		end
	},
	-- Spoils Building
	["debuff_region_gdp_bundle_1"] = {
		callback = function(region, faction, bonus_value) 
			cm:apply_effect_bundle_to_region("wh3_dlc27_nor_sayl_treachery_core_treasury_bundle_1", region:name(), 3)
		end
	},
	["debuff_region_gdp_bundle_2"] = {
		callback = function(region, faction, bonus_value) 
			cm:apply_effect_bundle_to_region("wh3_dlc27_nor_sayl_treachery_core_treasury_bundle_2", region:name(), 3)
		end
	},
	["debuff_region_gdp_bundle_3"] = {
		callback = function(region, faction, bonus_value) 
			cm:apply_effect_bundle_to_region("wh3_dlc27_nor_sayl_treachery_core_treasury_bundle_3", region:name(), 3)
		end
	},
	-- Chaos Corruption 
	["chaos_corruption_province"] = {
		callback = function(region, faction, bonus_value)
			local corruption_key = "wh3_main_corruption_chaos"
			cm:change_corruption_in_province_by(region:province_name(), corruption_key, bonus_value, "events")
		end
	},
	["chaos_corruption_province_adjacent"] = {
		callback = function(region, faction, bonus_value)
			local corruption_key = "wh3_main_corruption_chaos"
			cm:change_corruption_in_province_by(region:province_name(), corruption_key, bonus_value, "events")
			local adjacent_provinces = region:province():adjacent_provinces()
			for i = 0, adjacent_provinces:num_items() - 1 do
				local province = adjacent_provinces:item_at(i)
					cm:change_corruption_in_province_by(province, corruption_key, bonus_value, "events")
			end
		end
	},
	-- Garrison Infiltration
	["add_units_to_force_chaos_frost_dragon"] = {
		callback = function(region, faction, bonus_value)
			local unit_key = "wh_dlc08_nor_mon_frost_wyrm_0"
			nor_treacheries.infiltrators_invasion_force[unit_key] = bonus_value
			nor_treacheries.dynamic_data.should_spawn_infiltrator_army = true
		end
	},
	["add_units_to_force_ice_trolls"] = {
		callback = function(region, faction, bonus_value)
			local unit_key = "wh_dlc08_nor_mon_norscan_ice_trolls_0"
			nor_treacheries.infiltrators_invasion_force[unit_key] = bonus_value
			nor_treacheries.dynamic_data.should_spawn_infiltrator_army = true
		end
	},
	["add_units_to_force_marauder_berserkers"] = {
		callback = function(region, faction, bonus_value)
			local unit_key = "wh_dlc08_nor_inf_marauder_berserkers_0"
			nor_treacheries.infiltrators_invasion_force[unit_key] = bonus_value
			nor_treacheries.dynamic_data.should_spawn_infiltrator_army = true
		end
	},
	["add_units_to_force_marauder_champions"] = {
		callback = function(region, faction, bonus_value)
			local unit_key = "wh_dlc08_nor_inf_marauder_champions_0"
			nor_treacheries.infiltrators_invasion_force[unit_key] = bonus_value
			nor_treacheries.dynamic_data.should_spawn_infiltrator_army = true
		end
	},
	["add_units_to_force_marauder_champions_great_weapons"] = {
		callback = function(region, faction, bonus_value)
			local unit_key = "wh_dlc08_nor_inf_marauder_champions_0"
			nor_treacheries.infiltrators_invasion_force[unit_key] = bonus_value
			nor_treacheries.dynamic_data.should_spawn_infiltrator_army = true
		end
	},
	["add_units_to_force_marauder_great_weapons"] = {
		callback = function(region, faction, bonus_value)
			local unit_key = "wh_main_nor_inf_chaos_marauders_1"
			nor_treacheries.infiltrators_invasion_force[unit_key] = bonus_value
			nor_treacheries.dynamic_data.should_spawn_infiltrator_army = true
		end
	},
	["add_units_to_force_marauder_horsemasters"] = {
		callback = function(region, faction, bonus_value)
			local unit_key = "wh_dlc06_chs_cav_marauder_horsemasters_0"
			nor_treacheries.infiltrators_invasion_force[unit_key] = bonus_value	
			nor_treacheries.dynamic_data.should_spawn_infiltrator_army = true		
		end
	},
	["add_units_to_force_marauder_horsemen"] = {
		callback = function(region, faction, bonus_value)
			local unit_key = "wh_main_chs_cav_marauder_horsemen_0"
			nor_treacheries.infiltrators_invasion_force[unit_key] = bonus_value
			nor_treacheries.dynamic_data.should_spawn_infiltrator_army = true
		end
	},
	["add_units_to_force_marauder_hunters"] = {
		callback = function(region, faction, bonus_value)
			local unit_key = "wh_dlc08_nor_inf_marauder_hunters_0"
			nor_treacheries.infiltrators_invasion_force[unit_key] = bonus_value
			nor_treacheries.dynamic_data.should_spawn_infiltrator_army = true
		end
	},
	["add_units_to_force_marauders"] = {
		callback = function(region, faction, bonus_value)
			local unit_key = "wh3_main_sla_inf_marauders_0"
			nor_treacheries.infiltrators_invasion_force[unit_key] = bonus_value
			nor_treacheries.dynamic_data.should_spawn_infiltrator_army = true
		end
	},
	["add_units_to_force_norsca_warhounds_poison"] = {
		callback = function(region, faction, bonus_value)
			local unit_key = "wh_main_chs_mon_chaos_warhounds_0"
			nor_treacheries.infiltrators_invasion_force[unit_key] = bonus_value
			nor_treacheries.dynamic_data.should_spawn_infiltrator_army = true
		end
	},
	["add_units_to_force_war_mammoth"] = {
		callback = function(region, faction, bonus_value)
			local unit_key = "wh_dlc08_nor_mon_war_mammoth_0"
			nor_treacheries.infiltrators_invasion_force[unit_key] = bonus_value
			nor_treacheries.dynamic_data.should_spawn_infiltrator_army = true
		end
	},
	-- Sabotage
	["damage_garrison"] = {
		callback = function(region, faction, bonus_value) 
			local adjacent_regions = region:adjacent_region_list()

			for i = 0, adjacent_regions:num_items() - 1 do 
				local current_region = adjacent_regions:item_at(i)
				local region_owner = current_region:owning_faction()

				if region_owner and not region_owner:is_null_interface() then 

					if region_owner:name() ~= faction:name() then 

						local garrison = current_region:garrison_residence()
						if garrison and not garrison:is_null_interface() then 
							local armed_citizenry_mf = cm:get_armed_citizenry_from_garrison(garrison)

							if armed_citizenry_mf and not armed_citizenry_mf:is_null_interface() then 
								-- Damage all units in armed citizenry garrison
								for k = 0, armed_citizenry_mf:unit_list():num_items() - 1 do 
									local unit = armed_citizenry_mf:unit_list():item_at(k) 
									local health_to_set = (unit:percentage_proportion_of_full_strength() - bonus_value) / 100
									cm:set_unit_hp_to_unary_of_maximum(unit, math.min(health_to_set, 1))
								end
							end

							-- Damage resident army if there is one
							if garrison:has_army() then 
								local garrison_force = garrison:army()

								if garrison_force and not garrison_force:is_null_interface() then 
									for k = 0, garrison_force:unit_list():num_items() - 1 do 
										local unit = garrison_force:unit_list():item_at(k) 
										local health_to_set = (unit:percentage_proportion_of_full_strength() - bonus_value) / 100
										cm:set_unit_hp_to_unary_of_maximum(unit, math.min(health_to_set, 1))
									end
								end
							end
						end
					end
				end
			end
		end
	},
	["damage_walls"] = {
		callback = function(region, faction, bonus_value)
			if region:settlement():is_walled_settlement() then 
				cm:damage_settlement_walls(region, bonus_value)
			end
		end
	},
	-- Rites of Ruin (Tzeentch)
	["culture_tze_damage_settlement"] = {
		callback = function(region, faction, bonus_value)
			--cm:instantly_set_settlement_primary_slot_level()
			--cm:instant_set_building_health_percent(region:name(), main_building:name(), health_value)
			local main_building_level = region:settlement():primary_slot():building():building_level()
			cm:instantly_set_settlement_primary_slot_level(region:settlement(), main_building_level - 1)
			
			local slot_list = region:slot_list()
			for i = 0, slot_list:num_items() -1 do
				local slot = slot_list:item_at(i)
				if slot:has_building() then
					local building = slot:building()
					local building_health = building:percent_health() - bonus_value
					cm:instant_set_building_health_percent(region:name(), building:name(), building_health)
				end
			end
		end
	},
	["culture_tze_damage_forces"] = {
		callback = function (region, faction, bonus_value) 
			for i = 0, region:characters_in_region():num_items() - 1 do 
				local character = region:characters_in_region():item_at(i)
				if character:faction():name() == region:owning_faction():name() or character:faction():name() == faction:name() then  
					if character:has_military_force() then 
						local army = character:military_force()
						for j = 0, army:unit_list():num_items() - 1 do 
							local unit = army:unit_list():item_at(j) 
							local health_to_set = (unit:percentage_proportion_of_full_strength() - bonus_value) / 100
							cm:set_unit_hp_to_unary_of_maximum(unit, math.min(health_to_set, 1))
						end
					end
				end
			end
		end
	},
	--Tainted Trade (Chaos Dwarves)
	["culture_chd_debuff_bundle"] = {
		callback = function(region, faction, bonus_value) 
			local bundle_duration = 3
			cm:apply_effect_bundle_to_region("wh3_dlc27_nor_sayl_treachery_culture_chd_debuff_bundle_1", region:name(), bundle_duration)
		end
	},
	["culture_chd_debuff_bundle_upgraded"] = {
		callback = function(region, faction, bonus_value)
			local bundle_duration = 3
			cm:apply_effect_bundle_to_region("wh3_dlc27_nor_sayl_treachery_culture_chd_debuff_bundle_2", region:name(), bundle_duration)
		end
	},
	--Resources
	["treachery_confidence_change"] = {
		callback = function(region, faction, bonus_value, previous_faction)
			local previous_faction_name = previous_faction:name()
			if not previous_faction:pooled_resource_manager():resource(nor_treacheries_config.confidence_resource_key):is_null_interface() then
				cm:faction_add_pooled_resource(previous_faction_name, nor_treacheries_config.confidence_resource_key, nor_treacheries_config.confidence_resource_factor_trigger, bonus_value);
			end
		end
	},
	-- Negative effect bundle for all neutral and enemy armies in local region and adjacent regions - sets fatigue to Very Tired
	["wh3_dlc27_nor_sayl_fatigue_adjacent_regions"] = {
		callback = function(region, faction, bonus_value)
			nor_treacheries:apply_bundle_to_armies_local_adjacent(region, faction, bonus_value, "wh3_dlc27_bundle_nor_sayl_treachery_fatigue")
		end
	},
	-- Negative effect bundle for all neutral and enemy armies in local region and adjacent regions - reduces campaign movement
	["wh3_dlc27_nor_sayl_movement_adjacent_regions"] = {
		callback = function(region, faction, bonus_value)
			nor_treacheries:apply_bundle_to_armies_local_adjacent(region, faction, bonus_value, "wh3_dlc27_bundle_nor_sayl_treachery_movement")
		end
	},
	-- Negative effect bundle for all neutral and enemy armies in local region and adjacent regions - disables replenishment
	["wh3_dlc27_nor_sayl_replenishment_adjacent_regions"] = {
		callback = function(region, faction, bonus_value)
			nor_treacheries:apply_bundle_to_armies_local_adjacent(region, faction, bonus_value, "wh3_dlc27_bundle_nor_sayl_treachery_block_replenishment")
		end
	},
	-- Upgrade Main Building
	["wh3_dlc27_nor_sayl_upgrade_main_building"] = {
		callback = function(region, faction, bonus_value)
			local main_building_level = region:settlement():primary_slot():building():building_level()
			if main_building_level <= bonus_value then
				cm:instantly_set_settlement_primary_slot_level(region:settlement(), bonus_value)
			end
		end
	},

}

nor_treacheries = {}
nor_treacheries.config = nor_treacheries_config
nor_treacheries.dynamic_data = {}
nor_treacheries.dynamic_data.treaty_treachery_tracker = {}
nor_treacheries.activations = treachery_building_activations

nor_treacheries.factions_to_vassalize = {}

-- Use tables for generating invasion armies
nor_treacheries.infiltrators_invasion_force = {}
nor_treacheries.woc_invasion_force = {}

function nor_treacheries:initialise()
	self:add_listeners()
	local faction_interface = cm:get_faction(nor_treacheries_config.faction_key)
	if not is_nil(faction_interface) then
		cm:set_script_state(faction_interface, "sayl_treachery_per_faction_limit", nor_treacheries_config.sayl_treachery_per_faction_limit)
		cm:set_script_state(faction_interface, "sayl_treachery_max_faction_limit", nor_treacheries_config.sayl_treachery_max_faction_limit)
		cm:set_script_state(faction_interface, "sayl_unlocked_treachery_per_faction_number", nor_treacheries_config.sayl_unlocked_treachery_per_faction_number)
		cm:set_script_state(faction_interface, "sayl_unlocked_target_faction_number", nor_treacheries_config.sayl_unlocked_target_faction_number)
	end
end

function nor_treacheries:add_listeners()
	core:add_listener(
		"sayl_treachery_discovered_incidents",
		"ScriptedEventTreacheryIncident",
		function(context)
			return context.stored_table.faction:name() == self.config.faction_key
		end,
		function(context)
			local faction = context.stored_table.faction
			local region_cqi = context.stored_table.region:cqi()
			local region_owner = context.stored_table.region_owner

			-- Tell Sayl
			if faction:is_human() then
				cm:trigger_incident_with_targets(
					faction:command_queue_index(),
					"wh3_dlc27_incident_nor_sayl_treachery_discovered",
					0,
					0,
					0,
					0,
					region_cqi,
					0
				)
			end
			
			-- Tell the region owner
			if region_owner:is_human() then
				cm:trigger_incident_with_targets(
					region_owner:command_queue_index(),
					"wh3_dlc27_incident_nor_sayl_treachery_discovered",
					0,
					0,
					0,
					0,
					region_cqi,
					0
				)
			end
			
		end,
		true
	)

	core:add_listener(
		"treachery_culture_building_restrictions",
		"ForeignSlotManagerCreatedEvent",
		function(context)
			local new_manager = context:new_slot_manager()
			local slot_list = new_manager:slots();
			if slot_list:num_items() == 0 then
				return false
			end
			local slot = slot_list:item_at(0)
			local template_key = slot:template_key()
			return context:requesting_faction():name() == self.config.faction_key and template_key:starts_with(self.config.sayl_trap_slot_set)
		end,
		function(context)
			local faction_player = context:requesting_faction()
			local faction_player_cqi = faction_player:command_queue_index()
			local faction_settlement_owner = context:slot_owner()
			local slot_region = context:region()

			if self.config.are_slots_expanding == false and slot_region and slot_region:foreign_slot_manager_for_faction(self.config.faction_key):is_null_interface() == false then
				local slot_list = slot_region:foreign_slot_manager_for_faction(self.config.faction_key):slots();
				cm:foreign_slot_instantly_upgrade_building(slot_list:item_at(0), self.config.pre_built_infiltration_building);

				if nor_treacheries:faction_has_confidence(faction_settlement_owner) then
					cm:faction_add_pooled_resource(context:slot_owner():name(), self.config.confidence_resource_key, self.config.confidence_resource_factor_deployed, self.config.confidence_per_established_treachery)
				end
			end

			-- reset expansion breaker
			self.config.are_slots_expanding = false

			cm:trigger_incident_with_targets(faction_player_cqi, self.config.incidents.establish_treachery, 0, 0, 0, 0, slot_region:cqi(), 0)

			-- add a table that tracks confidence and diplomatic treaty for the target faction 
			if not nor_treacheries.dynamic_data.treaty_treachery_tracker[faction_settlement_owner:name()] then
				nor_treacheries.dynamic_data.treaty_treachery_tracker[faction_settlement_owner:name()] = {}
				nor_treacheries.dynamic_data.treaty_treachery_tracker[faction_settlement_owner:name()].can_declare_war = true
				nor_treacheries.dynamic_data.treaty_treachery_tracker[faction_settlement_owner:name()].treaty_cooldown = 0
			end

		end,
		true
	)

	core:add_listener(
		"SaylRegionTransferToFaction",
		"ScriptedEventTreacheryRegionTransfer",
		true,
		function(context)
			local region_key = context:region():name()
			if self.dynamic_data.region_transfer_conversion then
				cm:transfer_region_to_faction(region_key, self.config.faction_key, self.config.settlement_types.altar)
			else
				cm:transfer_region_to_faction(region_key, self.config.faction_key, self.config.settlement_types.core)
			end
			self.dynamic_data.region_tranfer_pending = false
			self.dynamic_data.region_transfer_conversion = false
		end,
		true
	)

	core:add_listener(
		"TreacheryRegionFactionChangeEvent",
		"RegionFactionChangeEvent",
		function(context)
			local sayl_faction = cm:get_faction(self.config.faction_key)
			return context:previous_faction() ~= sayl_faction
		end,
		function(context)
			local region = context:region()
			local new_owner = region:owning_faction()
			local previous_faction = context:previous_faction()
			local sayl_faction = cm:get_faction(self.config.faction_key)

			if new_owner:name() == self.config.faction_key then
				local fsm = region:foreign_slot_manager_for_faction(self.config.faction_key)

				if fsm:is_null_interface() == false then
					nor_treacheries:occupied_settlement_spread_treacheries(nor_treacheries.activations, region, sayl_faction, previous_faction)	
				end
			end
		end,
		true
	);

	core:add_listener(
		"ConfidenceChangedForFaction",
		"PooledResourceRegularIncome",
		function(context)
			local treacheries = self.dynamic_data.treaty_treachery_tracker
			local resource = context:resource():key()
			local faction = context:faction()
			
			if not faction:is_null_interface() and treacheries[faction:name()] ~= nil then
					return resource == self.config.confidence_resource_key and faction:name() ~= self.config.faction_key
			end

			return false
		end,
		function(context)
			local resource_si_value = context:resource():value()
			local sayl_faction_key = self.config.faction_key
			local sayl_faction = cm:get_faction(sayl_faction_key)
			local previous_faction = context:faction()

			if resource_si_value == 0 and not previous_faction:is_null_interface() then
				for i = 0, previous_faction:region_list():num_items() - 1 do 
					local region = previous_faction:region_list():item_at(i)
					local fsm = region:foreign_slot_manager_for_faction(sayl_faction_key)
	
					if not fsm:is_null_interface() then 
						if not is_table(nor_treacheries.dynamic_data.regions_to_clear) then
							nor_treacheries.dynamic_data.regions_to_clear = {}
						end

						table.insert(nor_treacheries.dynamic_data.regions_to_clear, region:name())
						nor_treacheries:destroy_foreign_slots()
					end
				end
			end
		end,
		true
	)
end

------------------------------
-- TREACHERY FUNCTIONS
------------------------------
function nor_treacheries:occupied_settlement_spread_treacheries(treacheries, region, sayl_faction, previous_faction)
	local slot_region = region
	local slot_list = slot_region:foreign_slot_manager_for_faction(sayl_faction:name()):slots()
	local sayl_faction_cqi = sayl_faction:command_queue_index()
	local buildings_in_slots = {}

	-- Parse what would be build after the removal of slots
	for i = 0, slot_list:num_items() - 1 do
		local slot = slot_list:item_at(i);
		local slot_building = slot:building()

		if slot:is_null_interface() == false and slot:has_building() == true then
			table.insert(buildings_in_slots, slot_building)
		else
			break
		end
	end

	--trigger completed treacheries
	self:trigger_treachery_activations(nor_treacheries.activations, region, sayl_faction, previous_faction)

	-- transfer buildings to neghbooring regions
	if #buildings_in_slots >= 1 then
		local adjacent_regions_list = region:adjacent_region_list()

		for i = 0, adjacent_regions_list:num_items() - 1 do
			local adj_region = adjacent_regions_list:item_at(i)
			local adj_region_owner = adj_region:owning_faction()
			
			if adj_region_owner:is_null_interface() == false and adj_region_owner:is_rebel() == false then
				local adj_region_owner_name = adj_region_owner:name()
				local foreign_slot_manager = adj_region:foreign_slot_manager_for_faction(self.config.faction_key)

				if adj_region_owner_name == previous_faction:name() and foreign_slot_manager:is_null_interface() == true then
					self.config.are_slots_expanding = true
					cm:add_foreign_slot_set_to_region_for_faction(sayl_faction_cqi, adj_region:cqi(), self.config.sayl_trap_slot_set)
					foreign_slot_manager = adj_region:foreign_slot_manager_for_faction(self.config.faction_key)
				end

				if foreign_slot_manager:is_null_interface() == false then
					local adj_slot_list = foreign_slot_manager:slots()
					for j = 0, adj_slot_list:num_items() - 1 do
						local slot = adj_slot_list:item_at(j);

						local building = buildings_in_slots[j + 1]
						if slot:is_null_interface() == false and slot:has_building() == false and building ~= nil then
							cm:foreign_slot_instantly_upgrade_building(slot, building)
						end
					end
				end
			end
		end
	end
end

function nor_treacheries:perform_treachery_on_region(region_key)
	local sayl_faction = cm:get_faction(nor_treacheries.config.faction_key)
	local ritual_setup = cm:create_new_ritual_setup(sayl_faction, nor_treacheries.config.treachery_ritual_key)
	local region = cm:get_region(region_key)
	ritual_setup:target():set_target_region(region);
	cm:perform_ritual_with_setup(ritual_setup)
end

function nor_treacheries:trigger_treachery_activations(treacheries, region, sayl_faction, previous_faction) 
	for key, data in dpairs(treacheries) do 
		local faction_bundle = cm:create_new_custom_effect_bundle()
		local scripted_bonus_value = cm:get_regions_bonus_value(region:name(), key)
		if scripted_bonus_value ~= 0 then
			if data.callback and is_function(data.callback) then
				if not region:owning_faction():at_war_with(sayl_faction) then
					data.callback(region, sayl_faction, scripted_bonus_value, previous_faction)
				else
					if not data.diplomatic_treaty then 
						data.callback(region, sayl_faction, scripted_bonus_value, previous_faction)
					end
				end
			end
		end
	end

	if not is_table(nor_treacheries.dynamic_data.regions_to_clear) then
		nor_treacheries.dynamic_data.regions_to_clear = {}
	end

	table.insert(nor_treacheries.dynamic_data.regions_to_clear, region:name())
	nor_treacheries.dynamic_data.faction_cqi = sayl_faction:command_queue_index()

	if nor_treacheries.dynamic_data.should_spawn_infiltrator_army then 
		nor_treacheries:spawn_invasion_army(region, nor_treacheries.infiltrators_invasion_force)
		nor_treacheries.dynamic_data.should_spawn_infiltrator_army = false
	end

	nor_treacheries:destroy_foreign_slots()

end

-- Destroy the foreign slot with delay to prevent race conditions
function nor_treacheries:destroy_foreign_slots()
	cm:callback(
		function()
			local last_index = #nor_treacheries.dynamic_data.regions_to_clear
			local region = cm:get_region(nor_treacheries.dynamic_data.regions_to_clear[last_index])
			local enemy_faction = region:owning_faction() 
			local sayl_faction = cm:get_faction(nor_treacheries.config.faction_key)
		
			local scripted_event_context = {
				region = region,
				faction = sayl_faction,
				region_owner = enemy_faction 
			}
			core:trigger_event("ScriptedEventTreacheryIncident", scripted_event_context)
			cm:remove_faction_foreign_slots_from_region(sayl_faction:command_queue_index(), region:cqi())
		
			if nor_treacheries.dynamic_data.region_tranfer_pending then 
				core:trigger_event("ScriptedEventTreacheryRegionTransfer", region)
			end
		
			table.remove(nor_treacheries.dynamic_data.regions_to_clear)
		
			if not enemy_faction:at_war_with(sayl_faction) then
				if nor_treacheries.dynamic_data.should_trigger_war and nor_treacheries.dynamic_data.treaty_treachery_tracker[enemy_faction:name()].can_declare_war then  
					cm:force_declare_war(self.config.faction_key, region:owning_faction():name(), false, false)
					nor_treacheries.dynamic_data.should_trigger_war = false
				end
			end
		end,
		0.2
	)
end

function nor_treacheries:spawn_invasion_army(region, army_list)
	local distance = 10
	local x, y = cm:find_valid_spawn_location_for_character_from_settlement(self.config.faction_key, region:name(), false, true, 10)
	
	if x > 0 then
		--Will use later currently copy+paste from Khorne spawned forces
		local army_size = 0

		local ram = random_army_manager;
		ram:remove_force("nor_treachery_invasion");
		ram:new_force("nor_treachery_invasion");
		
		for unit_key, value in dpairs(army_list) do
			ram:add_mandatory_unit("nor_treachery_invasion", unit_key, value)
			army_size = army_size + value
		end

		local unit_list = ram:generate_force("nor_treachery_invasion", army_size, false)
		local subtype = self.config.spawned_army_general_subtype


		cm:create_force(
			self.config.faction_key,
			unit_list,
			region:name(),
			x,
			y,
			false
		)

		-- Reset unit table 
		for unit_key, value in dpairs(army_list) do
			value = 0
		end
	end
end

function nor_treacheries:faction_has_confidence(faction_interface)
	return is_faction(faction_interface) and not faction_interface:is_null_interface() and not faction_interface:pooled_resource_manager():resource(self.config.confidence_resource_key):is_null_interface()
end

function nor_treacheries:apply_bundle_to_armies_local_adjacent(region, faction, bonus_value, bundle)
	for i = 0, region:characters_in_region():num_items() - 1 do 
		local character = region:characters_in_region():item_at(i)
		if character:has_military_force() and character:military_force():is_armed_citizenry() == false then 
			if character:faction():name() ~= faction:name() and character:faction():allied_with(faction) == false and character:faction():is_vassal_of(faction) == false then
				cm:apply_effect_bundle_to_force(bundle, character:military_force():command_queue_index(), bonus_value)
			end
		end
	end
	local adj_regions = region:adjacent_region_list() 
	for i = 0, adj_regions:num_items() - 1 do 
		local curr_region = adj_regions:item_at(i)
		for j = 0, curr_region:characters_in_region():num_items() - 1 do
			local character = curr_region:characters_in_region():item_at(j)
			if character:has_military_force() and character:military_force():is_armed_citizenry() == false then 
				if character:faction():name() ~= faction:name() and character:faction():allied_with(faction) == false and character:faction():is_vassal_of(faction) == false then
					cm:apply_effect_bundle_to_force(bundle, character:military_force():command_queue_index(), bonus_value)
				end
			end
		end
	end
end

-- To be called to update the shared state value with the scripted bonus value that will be updated through tech, effects and such. 
function nor_treacheries:UpdateSharedStateValues ()
	local faction_interface = cm:get_faction(nor_treacheries_config.faction_key)
	if not is_nil(faction_interface) then
		local sayl_unlocked_treachery_per_faction_number_bonus_value = cm:get_factions_bonus_value(faction_interface, "wh3_dlc27_nor_sayl_unlocked_treachery_per_faction_number")
		cm:set_script_state(faction_interface, "sayl_unlocked_treachery_per_faction_number", nor_treacheries_config.sayl_unlocked_treachery_per_faction_number + sayl_unlocked_treachery_per_faction_number_bonus_value)

		local sayl_unlocked_target_faction_number_bonus_value = cm:get_factions_bonus_value(faction_interface, "wh3_dlc27_nor_sayl_unlocked_target_faction_number")
		cm:set_script_state(faction_interface, "sayl_unlocked_target_faction_number", nor_treacheries_config.sayl_unlocked_target_faction_number + sayl_unlocked_target_faction_number_bonus_value)
	end
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("TreacheryDynamicData", nor_treacheries.dynamic_data, context)
	end
)
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			nor_treacheries.dynamic_data = cm:load_named_value("TreacheryDynamicData", nor_treacheries.dynamic_data, context)
		end
	end
)