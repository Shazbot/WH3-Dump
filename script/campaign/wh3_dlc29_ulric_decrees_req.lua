out("#### Adding ulric_decrees_initiatives_config ####")
-- unlock_condition = {
-- 	imperial_authority_level = 10,
-- 	faction_leader_level = 2,
-- 	num_characters_at_level = {
-- 		num_character = 4,
-- 		level = 5
-- 	},
-- 	num_buildings_from_chains = {
-- 		building_chains = {
-- 			"<building_chain_key>",
-- 			"<building_chain_key>",
-- 		}
-- 		num_buildings = <number_of_buildings>
-- 	},
-- 	building_exists_in_region = {
-- 		building_key = "<building_key>",
-- 		region_key = "<region_key>",
-- 	},
-- 	num_regions_with_climate = {
-- 		climate_types = {
-- 			"<climate_type>",
-- 			"<climate_type>",
-- 		},
-- 		num_regions = <number_of_regions>
-- 	},
-- }

local resource_key_for_imperial_authority_level = "emp_imperial_authority_new"
local cult_of_ulric_building_chains = {
	"wh3_dlc29_EMPIRE_worship_ulric"
}

local ulric_initiatives_config = {
	temple_of_ulric_prefix = "wh_main_special_great_temple_of_ulric_",
	lock_again_if_condition_fails = true,
	intitiative_sets = {
		["wh3_dlc29_middenland_the_great_temple_of_ulric_high_altar_of_ulric"] = {
			initiatives = {
				{
					key = "wh3_dlc29_emp_middenland_the_great_temple_of_ulric_high_altar_of_ulric_level_1",
					unlock_condition = {
						building_exists_in_region = {
							building_key = "wh_main_special_great_temple_of_ulric_1",
							region_key = "wh3_main_combi_region_middenheim"
						}
					},
				},
				{
					key = "wh3_dlc29_emp_middenland_the_great_temple_of_ulric_high_altar_of_ulric_level_2",
					unlock_condition = {
						building_exists_in_region = {
							building_key = "wh_main_special_great_temple_of_ulric_2",
							region_key = "wh3_main_combi_region_middenheim"
						}
					},
				},
				{
					key = "wh3_dlc29_emp_middenland_the_great_temple_of_ulric_high_altar_of_ulric_level_3",
					unlock_condition = {
						building_exists_in_region = {
							building_key = "wh_main_special_great_temple_of_ulric_3",
							region_key = "wh3_main_combi_region_middenheim"
						}
					},
				},
				{
					key = "wh3_dlc29_emp_middenland_the_great_temple_of_ulric_high_altar_of_ulric_level_4",
					unlock_condition = {
						building_exists_in_region = {
							building_key = "wh_main_special_great_temple_of_ulric_4",
							region_key = "wh3_main_combi_region_middenheim"
						}
					},
				}
			}
		},
		["wh3_dlc29_middenland_the_great_temple_of_ulric_pilgrims_retreat"] = {
			initiatives = {
				{
					key = "wh3_dlc29_emp_middenland_the_great_temple_of_ulric_pilgrims_retreat_level_1",
					unlock_condition = {
						faction_leader_level = 5
					},
				},
				{
					key = "wh3_dlc29_emp_middenland_the_great_temple_of_ulric_pilgrims_retreat_level_2",
					unlock_condition = {
						faction_leader_level = 10
					},
				},
				{
					key = "wh3_dlc29_emp_middenland_the_great_temple_of_ulric_pilgrims_retreat_level_3",
					unlock_condition = {
						faction_leader_level = 20
					},
				},
				{
					key = "wh3_dlc29_emp_middenland_the_great_temple_of_ulric_pilgrims_retreat_level_4",
					unlock_condition = {
						faction_leader_level = 30
					},
				},
				
			}
		},
		["wh3_dlc29_middenland_the_great_temple_of_ulric_statue_of_the_white_wolf"] = {
			initiatives = {
				{
					key = "wh3_dlc29_emp_middenland_the_great_temple_of_ulric_statue_of_the_white_wolf_level_1",
					unlock_condition = {
						num_owned_regions = 5
					}
				},
				{
					key = "wh3_dlc29_emp_middenland_the_great_temple_of_ulric_statue_of_the_white_wolf_level_2",
					unlock_condition = {
						num_owned_regions = 10
					}
				},
				{
					key = "wh3_dlc29_emp_middenland_the_great_temple_of_ulric_statue_of_the_white_wolf_level_3",
					unlock_condition = {
						num_owned_regions = 20
					}
				},
				{
					key = "wh3_dlc29_emp_middenland_the_great_temple_of_ulric_statue_of_the_white_wolf_level_4",
					unlock_condition = {
						num_owned_regions = 30
					}
				}
			}
		},
		["wh3_dlc29_middenland_the_great_temple_of_ulric_hall_of_flame"] = {
			initiatives = {
				{
					key = "wh3_dlc29_emp_middenland_the_great_temple_of_ulric_hall_of_flame_level_1",
					unlock_condition = {
						num_buildings_from_chains = {
							building_chains = cult_of_ulric_building_chains,
							num_buildings = 1
						}
					},
				},
				{
					key = "wh3_dlc29_emp_middenland_the_great_temple_of_ulric_hall_of_flame_level_2",
					unlock_condition = {
						num_buildings_from_chains = {
							building_chains = cult_of_ulric_building_chains,
							num_buildings = 2
						}
					},
				},
				{
					key = "wh3_dlc29_emp_middenland_the_great_temple_of_ulric_hall_of_flame_level_3",
					unlock_condition = {
						num_buildings_from_chains = {
							building_chains = cult_of_ulric_building_chains,
							num_buildings = 4
						}
					},
				},
				{
					key = "wh3_dlc29_emp_middenland_the_great_temple_of_ulric_hall_of_flame_level_4",
					unlock_condition = {
						num_buildings_from_chains = {
							building_chains = cult_of_ulric_building_chains,
							num_buildings = 8
						}
					},
				},
				
			}
		},	
		["wh3_dlc29_middenland_the_great_temple_of_ulric_reliquary_of_fangs"] = {
			initiatives = {
				{
					key = "wh3_dlc29_emp_middenland_the_great_temple_of_ulric_reliquary_of_fangs_level_1",
					unlock_condition = {
						num_ulric_units = 10
					},
				},
				{
					key = "wh3_dlc29_emp_middenland_the_great_temple_of_ulric_reliquary_of_fangs_level_2",
					unlock_condition = {
						num_ulric_units = 20
					},
				},
				{
					key = "wh3_dlc29_emp_middenland_the_great_temple_of_ulric_reliquary_of_fangs_level_3",
					unlock_condition = {
						num_ulric_units = 40
					},
				},
				{
					key = "wh3_dlc29_emp_middenland_the_great_temple_of_ulric_reliquary_of_fangs_level_4",
					unlock_condition = {
						num_ulric_units = 60
					},
				},
				
			}
		},
		["wh3_dlc29_middenland_the_great_temple_of_ulric_teutogen_bastion"] = {
			initiatives = {
				{
					key = "wh3_dlc29_emp_middenland_the_great_temple_of_ulric_teutogen_bastion_level_1",
					unlock_condition = {
						imperial_authority_level = 65
					},
				},
				{
					key = "wh3_dlc29_emp_middenland_the_great_temple_of_ulric_teutogen_bastion_level_2",
					unlock_condition = {
						imperial_authority_level = 75
					},
				},
				{
					key = "wh3_dlc29_emp_middenland_the_great_temple_of_ulric_teutogen_bastion_level_3",
					unlock_condition = {
						imperial_authority_level = 85
					},
				},
				{
					key = "wh3_dlc29_emp_middenland_the_great_temple_of_ulric_teutogen_bastion_level_4",
					unlock_condition = {
						imperial_authority_level = 95
					},
				},
				
			}
		},
	},
	postfix = "_ulric_decrees_initiatives",
}

local function make_param(value, param_type)
	return {
		type = param_type or "string",
		value = value
	}
end

local function int_param(value)
	return make_param(value, "int")
end

local function zoom_to(obj)
	if not obj then
		return ""
	end

	if is_character(obj) then
		return cm:char_lookup_str(obj)
	end

	if is_region(obj) then
		return cm:region_lookup_str(obj)
	end

	if is_string(obj) then 
		return obj
	end

	return ""
end

local function make_description(condition_met, zoom_to_str, key, ...)
	return {
		localisation_key = key,
		localisation_params = {...},
		condition_met = condition_met,
		zoom_to = zoom_to_str
	}
end

local condition_checkers = {
	imperial_authority_level = function(faction, required_value)
		local resource_emp_imperial_authority_new = faction:pooled_resource_manager():resource(resource_key_for_imperial_authority_level):value()
		--local descr = "Ensure Imperial Authority is atleast %1%""
		local condition_met = resource_emp_imperial_authority_new >= required_value
		local descr = make_description(condition_met, zoom_to(nil), "campaign_localised_strings_string_dlc29_ulric_decrees_requirement_imperial_authority_level", int_param(required_value))
		return condition_met, descr
	end,
	faction_leader_level = function(faction, required_value)
		local faction_leader = faction:faction_leader()
		if not is_character(faction_leader) then
			return nil, nil
		end
		local current_level = faction_leader:rank()
		--local descr = "Reach rank %1% with Boris Todbringer (Current amount: %2%)""
		local condition_met = current_level >= required_value
		local zoom_to_item = nil 
		if cm:char_is_mobile_general_with_army(faction_leader) and not faction_leader:is_in_limbo() then
			zoom_to_item = faction_leader
		end
		local descr = make_description(condition_met, zoom_to(zoom_to_item), "campaign_localised_strings_string_dlc29_ulric_decrees_requirement_faction_leader_level", int_param(required_value), int_param(current_level))
		return condition_met, descr
	end,
	num_ulric_units = function(faction, required_value)
		local count_of_ulric_units = 0
		local force_list = faction:military_force_list()
		for i = 0, force_list:num_items() - 1 do
			local force = force_list:item_at(i)
			local unit_list = force:unit_list()
			for j = 0, unit_list:num_items() - 1 do
				local unit = unit_list:item_at(j)
				if unit:is_unit_in_set("wh3_dlc29_ulric_units") then
					count_of_ulric_units = count_of_ulric_units + 1
				end
			end
		end
		--local descr = "Have ..tostring(count_of_ulric_units).. Cult of Ulric units (Current amount: ..tostring(required_value)..)""
		local condition_met = count_of_ulric_units >= required_value
		local descr = make_description(condition_met, zoom_to(nil), "campaign_localised_strings_string_dlc29_ulric_decrees_requirement_num_ulric_units", int_param(required_value), int_param(count_of_ulric_units))
		return condition_met, descr
	end,
	num_buildings_from_chains = function(faction, required_value)
		local count_of_buildings = 0
		local regions_list = faction:region_list()
		for i = 0, regions_list:num_items() - 1 do
			local region = regions_list:item_at(i)
			local garrison = region:garrison_residence()
			for _, chain_key in ipairs(required_value.building_chains) do
				if cm:garrison_contains_building_chain(garrison, chain_key) then
					count_of_buildings = count_of_buildings + 1
				end
			end
		end
		--local descr = "Construct %1% buildings from the Cult of Ulric chain (Current amount: %2%)
		local condition_met = count_of_buildings >= required_value.num_buildings
		local descr = make_description(condition_met, zoom_to(nil), "campaign_localised_strings_string_dlc29_ulric_decrees_requirement_num_buildings_from_chains", int_param(required_value.num_buildings), int_param(count_of_buildings))
		return condition_met, descr
	end,
	building_exists_in_region = function(faction, required_value)
		local region = cm:get_region(required_value.region_key)
		local condition_met = false
		local building_key = required_value.building_key or "wh_main_special_great_temple_of_ulric_1"
		if region and region:owning_faction():name() == faction:name() then
			local garrison = region:garrison_residence()
			if garrison then
				local temple_of_ulric_chain = {
					"wh_main_special_great_temple_of_ulric_1", 
					"wh_main_special_great_temple_of_ulric_2",
					"wh_main_special_great_temple_of_ulric_3",
					"wh_main_special_great_temple_of_ulric_4"
				}
				local required_index = false
				for i = 1, #temple_of_ulric_chain do
					if temple_of_ulric_chain[i] == building_key then
						required_index = i
						break
					end
				end
				if required_index then
					for i = required_index, #temple_of_ulric_chain do
						if cm:garrison_contains_building(garrison, temple_of_ulric_chain[i]) then
							condition_met = true
							break
						end
					end
				end
			end
		end
		--local descr = "Construct building_name landmark building in Middenheim"
		local condition_string = "campaign_localised_strings_string_dlc29_ulric_decrees_requirement_ulric_landmark_building_exists_in_region_" .. string.sub(required_value.building_key, -1)
		local descr = make_description(condition_met, zoom_to("building_level_record_key:" .. required_value.building_key), condition_string)
		return condition_met, descr
	end,
	num_owned_regions = function(faction, required_value)
		local count_of_regions = 0
		local regions_list = faction:region_list()
		for i = 0, regions_list:num_items() - 1 do
			count_of_regions = count_of_regions + 1
		end
		--local descr = "Own %1% regions (Current amount: %2%)""
		local condition_met = count_of_regions >= required_value
		local descr = make_description(condition_met, zoom_to(nil), "campaign_localised_strings_string_dlc29_ulric_decrees_requirement_num_regions", int_param(required_value), int_param(count_of_regions))
		return condition_met, descr
	end,
	unknown_condition = function(faction, required_value)
		local descr = make_description(false, zoom_to(nil), "")
		return false, descr
	end
}

function ulric_decrees:check_initiative_unlock_condition(faction, initiative_def)
	local requirements = {}
	local condition_met = true
	if not initiative_def.unlock_condition then
		return true, requirements
	end

	for condition_type, required_value in pairs(initiative_def.unlock_condition) do
		local checker_function = condition_checkers[condition_type] or condition_checkers.unknown_condition
		local is_condition_met, descr = checker_function(faction, required_value)
		table.insert(requirements, descr)
		if not is_condition_met then
			condition_met = false
		end
	end
	return condition_met, requirements
end

local initiative_lock_state_cache = {}
local function cache_lock_state(faction_key, initiative_key, requirements)
	if not initiative_lock_state_cache[faction_key] then
		initiative_lock_state_cache[faction_key] = {}
	end
	initiative_lock_state_cache[faction_key][initiative_key] = requirements
end

function ulric_decrees:refresh_requrements_for_ui(faction_key)
	if not initiative_lock_state_cache[faction_key] then
		return
	end

	if cm:get_local_faction_name(true) == faction_key then
		common.set_context_value("ulric_decrees_initiatives_" .. faction_key, initiative_lock_state_cache[faction_key])
	end
end

function ulric_decrees:reevaluate_lock_state(faction, event_id)
	--out("ulric_decrees:reevaluate_lock_state")
	local faction_key = faction:name()
	for initiative_set_key, initiative_set_def in pairs(ulric_initiatives_config.intitiative_sets) do
		local initiative_set_script_interface = faction:lookup_faction_initiative_set_by_key(initiative_set_key)
		local index_of_active_initiative = -1
		local initiatives = {}
		for index, initiative_def in ipairs(initiative_set_def.initiatives) do
			local initiative_key = initiative_def.key
			local initiative = initiative_set_script_interface:lookup_initiative_by_key(initiative_key)
			table.insert(initiatives, {initiative = initiative, initiative_def = initiative_def})
			if initiative:is_active() then
				index_of_active_initiative = index
			end
		end

		local prev_initiative = nil
		for index, initiative_tbl in ipairs(initiatives) do
			local initiative = initiative_tbl.initiative
			local initiative_def = initiative_tbl.initiative_def
			local initiative_key = initiative_def.key
			local is_script_locked = initiative:is_script_locked()

			if index > index_of_active_initiative and (is_script_locked or event_id == "init" or ulric_initiatives_config.lock_again_if_condition_fails) then
				local condition_met, locked_reasons = self:check_initiative_unlock_condition(faction, initiative_def)

				if prev_initiative and index > index_of_active_initiative + 1 then
					local descr = make_description(false, zoom_to(nil), "campaign_localised_strings_string_dlc29_ulric_decrees_requirement_previous_initiative_not_unlocked")
					condition_met = false
					table.insert(locked_reasons, descr)
				end
				if not condition_met then					
					cm:lock_initiative(initiative_set_script_interface, initiative_key)
					cm:set_script_state("unlock_flag_" .. initiative_set_script_interface:record_key(), false)
				else
					cm:set_script_state("unlock_flag_" .. initiative_set_script_interface:record_key(), true)
					cm:unlock_initiative(initiative_set_script_interface, initiative_key)
				end
				cache_lock_state(faction_key, initiative_key, locked_reasons)
			end
			prev_initiative = initiative
		end
	end

	--refresh ui context values so that the UI can update the lock icons and tooltip information
	self:refresh_requrements_for_ui(faction_key)
end

function ulric_decrees:add_initiatives_listeners()
	--update on activation
	core:add_listener(
		"FactionInitiativeActivationChangedEvent" .. ulric_initiatives_config.postfix,
		"FactionInitiativeActivationChangedEvent",
		function(context)
			return context:faction():name() == self.config.faction_key and context:active()
		end,
		function(context)
			self:reevaluate_lock_state(context:faction(), "FactionInitiativeActivationChangedEvent")
		end,
		true
	)

	--Pilgrims’ Retreat
	core:add_listener(
		"PooledResourceChanged" .. ulric_initiatives_config.postfix,
		"PooledResourceChanged",
		function(context)
			return context:has_faction()
			and context:faction():name() == self.config.faction_key
			and context:resource():key() == resource_key_for_imperial_authority_level 
		end,
		function(context)
			self:reevaluate_lock_state(context:faction(), "PooledResourceChanged")
		end,
		true
	)

	--Teutogen Bastion
	core:add_listener(
		"CharacterRankUp" .. ulric_initiatives_config.postfix,
		"CharacterRankUp",
		function(context)
			return context:character():faction():name() == self.config.faction_key
		end,
		function(context)
			self:reevaluate_lock_state(context:character():faction(), "CharacterRankUp")
		end,
		true
	)

	--High Altar of Ulric
	--Hall of the Flame
	core:add_listener(
		"BuildingCompleted" .. ulric_initiatives_config.postfix,
		"BuildingCompleted",
		function(context)
			return context:building():faction():name() == self.config.faction_key
		end,
		function(context)
			self:reevaluate_lock_state(context:building():faction(), "BuildingCompleted")
		end,
		true
	)

	--High Altar of Ulric
	--Statue of the White Wolf
	core:add_listener(
		"RegionFactionChangeEvent" .. ulric_initiatives_config.postfix,
		"RegionFactionChangeEvent",
		function(context)
			return context:region():owning_faction():name() == self.config.faction_key
					or (context:previous_faction() and context:previous_faction():name() == self.config.faction_key)
		end,
		function(context)
			self:reevaluate_lock_state(cm:get_faction(self.config.faction_key), "RegionFactionChangeEvent")
		end,
		true
	)

	--Reliquary of Fangs
	core:add_listener(
		"UnitMergedAndDestroyed" .. ulric_initiatives_config.postfix,
		"UnitMergedAndDestroyed",
		function(context)
			return context:unit():faction():name() == self.config.faction_key
		end,
		function(context)
			self:reevaluate_lock_state(cm:get_faction(self.config.faction_key), "UnitMergedAndDestroyed")
		end,
		true
	)

	--Reliquary of Fangs
	core:add_listener(
		"UnitCreated" .. ulric_initiatives_config.postfix,
		"UnitCreated",
		function(context)
			return context:unit():faction():name() == self.config.faction_key
		end,
		function(context)
			self:reevaluate_lock_state(cm:get_faction(self.config.faction_key), "UnitCreated")
		end,
		true
	)

	--Reliquary of Fangs
	core:add_listener(
		"UnitTrained" .. ulric_initiatives_config.postfix,
		"UnitTrained",
		function(context)
			return context:unit():faction():name() == self.config.faction_key
		end,
		function(context)
			self:reevaluate_lock_state(cm:get_faction(self.config.faction_key), "UnitTrained")
		end,
		true
	)

	--Reliquary of Fangs
	core:add_listener(
		"UnitDisbanded" .. ulric_initiatives_config.postfix,
		"UnitDisbanded",
		function(context)
			return context:unit():faction():name() == self.config.faction_key
		end,
		function(context)
			self:reevaluate_lock_state(cm:get_faction(self.config.faction_key), "UnitDisbanded")
		end,
		true
	)

	--FactionTurnStart
	core:add_listener(
		"FactionTurnStart" .. ulric_initiatives_config.postfix,
		"FactionTurnStart",
		function(context)
			return context:faction():name() == self.config.faction_key
		end,
		function(context)
			self:reevaluate_lock_state(context:faction(), "FactionTurnStart")
		end,
		true
	)

	--ui events
	core:add_listener(
		"ContextUITriggerEvent" .. ulric_initiatives_config.postfix,
		"ContextUITriggerEvent",
		function(context)
			return context.string:starts_with("ulric_decrees_initiative_requirements")
		end,
		function(context)
			out("ContextUITriggerEvent: "..context.string)
			if cm:has_local_faction() then
				ulric_decrees:refresh_requrements_for_ui(cm:get_local_faction_name(true))
			end
		end,
		true
	)

	core:add_listener(
		"Temple_of_Ulric_Demolished" .. ulric_initiatives_config.postfix,
		"BuildingDemolished", 
		function(context)
			local faction = context:building():faction()
			return faction:name() == self.config.faction_key and string.find(context:building():name(), ulric_initiatives_config.temple_of_ulric_prefix)
		end,
		function(context)
			local middenland_interface = cm:get_faction("wh_main_emp_middenland")
			self:reevaluate_lock_state(middenland_interface, "BuildingDemolished")
		end,
		true
	)

	core:add_listener(
		"CharacterEntersLimboEvent" .. ulric_initiatives_config.postfix,
		"CharacterEntersLimboEvent", 
		function(context)
			return context:character():character_subtype_key() == self.config.boris_subtype_key
		end,
		function(context)
			local middenland_interface = context:character():faction()
			self:reevaluate_lock_state(middenland_interface, "CharacterEntersLimboEvent")
		end,
		true
	)

	core:add_listener(
		"CharacterExitsLimboEvent" .. ulric_initiatives_config.postfix,
		"CharacterExitsLimboEvent", 
		function(context)
			return context:character():character_subtype_key() == self.config.boris_subtype_key
		end,
		function(context)
			local middenland_interface = context:character():faction()
			self:reevaluate_lock_state(middenland_interface, "CharacterExitsLimboEvent")
		end,
		true
	)

	core:add_listener(
		"CharacterConvalescedOrKilled" .. ulric_initiatives_config.postfix,
		"CharacterConvalescedOrKilled", 
		function(context)
			return context:character():character_subtype_key() == self.config.boris_subtype_key
		end,
		function(context)
			local middenland_interface = context:character():faction()
			self:reevaluate_lock_state(middenland_interface, "CharacterConvalescedOrKilled")
		end,
		true
	)

	core:add_listener(
		"CharacterRecruited" .. ulric_initiatives_config.postfix,
		"CharacterRecruited", 
		function(context)
			return context:character():character_subtype_key() == self.config.boris_subtype_key
		end,
		function(context)
			local middenland_interface = context:character():faction()
			self:reevaluate_lock_state(middenland_interface, "CharacterRecruited")
		end,
		true
	)
end

function ulric_decrees:remove_initiatives_listeners()
	core:remove_listener("FactionInitiativeActivationChangedEvent" .. ulric_initiatives_config.postfix)
	core:remove_listener("PooledResourceChanged" .. ulric_initiatives_config.postfix)
	core:remove_listener("CharacterRankUp" .. ulric_initiatives_config.postfix)
	core:remove_listener("BuildingCompleted" .. ulric_initiatives_config.postfix)
	core:remove_listener("RegionFactionChangeEvent" .. ulric_initiatives_config.postfix)
	core:remove_listener("UnitMergedAndDestroyed" .. ulric_initiatives_config.postfix)
	core:remove_listener("UnitCreated" .. ulric_initiatives_config.postfix)
	core:remove_listener("UnitTrained" .. ulric_initiatives_config.postfix)
	core:remove_listener("UnitDisbanded" .. ulric_initiatives_config.postfix)
	core:remove_listener("FactionTurnStart" .. ulric_initiatives_config.postfix)
	core:remove_listener("ContextUITriggerEvent" .. ulric_initiatives_config.postfix)
	core:remove_listener("Temple_of_Ulric_Demolished" .. ulric_initiatives_config.postfix)
	core:remove_listener("CharacterEntersLimboEvent" .. ulric_initiatives_config.postfix)
	core:remove_listener("CharacterExitsLimboEvent" .. ulric_initiatives_config.postfix)
	core:remove_listener("CharacterConvalescedOrKilled" .. ulric_initiatives_config.postfix)
	core:remove_listener("CharacterRecruited" .. ulric_initiatives_config.postfix)
end

function ulric_decrees:initialize_ulric_initiatives()
	out("ulric_decrees:initialize_initiatives_mechanic")
	local middenland_interface = cm:get_faction(self.config.faction_key)
	if not middenland_interface:is_dead() then  
		self:reevaluate_lock_state(cm:get_faction(self.config.faction_key), cm:is_new_game() and "init" or "init_continue")
		self:add_initiatives_listeners()
	end

	core:add_listener(
		"Middenland_Faction_Death_Handle_Initiatives",
		"FactionDeath",
		function(context)
			return context:faction():name() == self.config.faction_key and not context:is_game_over()
		end,
		function(context)
			self:remove_initiatives_listeners()
		end,
		true
	)

	core:add_listener(
		"Middenland_Faction_Awoken_From_Death_Handle_Initiatives",
		"FactionAwokenFromDeath",
		function(context)
			return context:faction():name() == self.config.faction_key
		end,
		function(context)
			self:reevaluate_lock_state(context:faction(), "awoken_from_death")
			self:add_initiatives_listeners()
		end,
		true
	)
end

return ulric_initiatives_config

