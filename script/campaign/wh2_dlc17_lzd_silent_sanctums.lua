--global function table
Silent_Sanctums = {}

local m_oxyotl_faction_key = "wh2_dlc17_lzd_oxyotl"
local m_oxoytl_forename = "names_name_580695679"

local m_sanctum_button_component = "sanctum_button"

local m_sanctum_slot_set_key = "wh2_dlc17_slot_set_silent_sanctum"
local m_sanctum_ritual_key = "wh2_dlc17_lzd_ritual_unlock_silent_sanctum"
local m_sanctum_new_gems_incident_key = "wh2_dlc17_lzd_oxyotl_silent_sanctums_new_sanctum_point"

m_pooled_resource_sanctum_stone_cap = 8
local m_pooled_resource_sanctum_gems = "lzd_sanctum_gems"
local m_pooled_resource_sanctum_points = "lzd_sanctum_points"
local m_pooled_resource_factor_sanctum_gems = "wh2_dlc17_resource_factor_retrieved"
local m_pooled_resource_factor_sanctum_gems_converted = "wh2_dlc17_resource_factor_gem_sets_completed"
local m_pooled_resource_factor_sanctum_points = "wh2_dlc17_resource_factor_sanctum_sets_gained"

m_vision_building_key = "wh2_dlc17_silent_sanctum_core_1"
m_transport_building_key = "wh2_dlc17_silent_sanctum_transport_0"
m_starting_building_key = "wh2_dlc17_silent_sanctum_upkeep_0"

local m_current_transport_building_region = ""

local m_regions_with_sanctums = {}
local m_region_to_lord_list = {}

m_starting_sanctum_regions = {
	["main_warhammer"] = "wh3_main_combi_region_the_godless_crater"
}

m_sanctum_ambush_config = {
	ambush_min_value = 0,
	ambush_max_value = 100,
	ambush_chance = {
		building_1 = 25,
		building_2 = 33
	},

	ambush_buildings = {
		["wh2_dlc17_silent_sanctum_ambush_0"] = true,
		["wh2_dlc17_silent_sanctum_ambush_1"] = true,
	},
	
	-- Increase success chance of ambushing enemy armies
	ambush_bundle = "wh2_dlc17_bundle_scripted_lizardmen_encounter",

	-- Ambush spawned armies
	army_template = "lzd_sanctum_ambush", -- faction type to use for spawned army
	ambush_current_power_level = 1, -- modfier for calculating composition of spawned armies. Updates as campaign progresses
	ambush_power_cap = 9, -- Max cap the random army power level can reach (max is 10)
	turns_for_ambush_power_upgrade = 20, -- how many turns it taks for the ambush power level to incease
	ambush_force_strength_small = 7, -- how big the small sized force that spawns is
	ambush_force_strength_medium = 13, -- how big the medium sized force that spawns is
	small_army_key = "wh2_dlc17_silent_sanctum_ambush_0",
	med_army_key = "wh2_dlc17_silent_sanctum_ambush_1",
	general_to_use = "wh2_main_lzd_saurus_old_blood", -- Need to use a general or it picks a random one, leading to one a player may not have access to
}

local m_first_sanctum_point_gained = false
local m_first_sanctum_constructed = false

local function get_current_sanctum_stone_amount()
	local faction = cm:get_faction(m_oxyotl_faction_key)
	local stone_amount = faction:pooled_resource_manager():resource(m_pooled_resource_sanctum_gems):value()
	return stone_amount
end

function Silent_Sanctums:add_sanctum_gems(amount)
	local current_gems = get_current_sanctum_stone_amount()
	local total_gems = amount + current_gems
	local gems_remainder = total_gems % m_pooled_resource_sanctum_stone_cap
	local new_points = (total_gems - gems_remainder) / m_pooled_resource_sanctum_stone_cap

	if(new_points > 0) then
		cm:trigger_incident(m_oxyotl_faction_key, m_sanctum_new_gems_incident_key, true)
		cm:faction_add_pooled_resource(m_oxyotl_faction_key, m_pooled_resource_sanctum_points, m_pooled_resource_factor_sanctum_points, new_points)

		if(m_first_sanctum_point_gained == false) then
			m_first_sanctum_point_gained = true
			core:trigger_event("ScriptEventOxyFirstStoneGained")
		end
	end

	-- no need to call anything if new/old gems are the same
	if(gems_remainder > current_gems) then
		local gems_diff = gems_remainder - current_gems
		cm:faction_add_pooled_resource(m_oxyotl_faction_key, m_pooled_resource_sanctum_gems, m_pooled_resource_factor_sanctum_gems, gems_diff)
	elseif(gems_remainder < current_gems) then
		local gems_diff = gems_remainder - current_gems
		cm:faction_add_pooled_resource(m_oxyotl_faction_key, m_pooled_resource_sanctum_gems, m_pooled_resource_factor_sanctum_gems_converted, gems_diff)
	end
end

function Silent_Sanctums:get_sanctum_transport_region()
	return m_current_transport_building_region
end

local function silent_sanctum_constructed_listener()
	core:add_listener(
		"oxy_sanctum_vision",
		"RitualCompletedEvent",
		function(context)
			local ritual_succeeded = context:succeeded()
			
			if(ritual_succeeded == true) then
				local ritual_key = context:ritual():ritual_key()

				if(ritual_key == m_sanctum_ritual_key) then
					return true
				end
			end

			return false
		end,
		function(context)
			-- grants vision of sanctum region upon creation.
			local target_region = context:ritual():ritual_target():get_target_region()
			local region_key = target_region:name()

			cm:make_region_visible_in_shroud(m_oxyotl_faction_key, region_key)

			if(m_first_sanctum_constructed == false) then
				m_first_sanctum_constructed = true
				core:trigger_event("ScriptEventOxyFirstSanctumConstructed")
			end
		end,
		true
	)
end

local function grant_vision_to_all_adjacent_regions(region_interface)
	local adjacent_region_list = region_interface:adjacent_region_list()

	for i = 0, adjacent_region_list:num_items() - 1 do
		local adj_region_key = adjacent_region_list:item_at(i):name()
		cm:make_region_visible_in_shroud(m_oxyotl_faction_key, adj_region_key)
	end
end

local function vision_building_built_listener()
	core:add_listener(
        "oxy_sanctum_vision_building",
        "ForeignSlotBuildingCompleteEvent",
        function(context)
			local building_key = context:building()
			local faction_key = context:slot_manager():faction():name()
            if(faction_key == m_oxyotl_faction_key and building_key == m_vision_building_key) then
                return true
			end
			return false
        end,
		function(context)
			local region = context:slot_manager():region()
			grant_vision_to_all_adjacent_regions(region)
        end,
        true
    )
end

local function transport_building_built_listener()
	core:add_listener(
        "oxy_sanctum_transport_building",
        "ForeignSlotBuildingCompleteEvent",
        function(context)
			local building_key = context:building()
			local faction_key = context:slot_manager():faction():name()
            if(faction_key == m_oxyotl_faction_key and building_key == m_transport_building_key) then
                return true
			end
			return false
        end,
		function(context)
			if(m_current_transport_building_region ~= nil and m_current_transport_building_region ~= "") then
				local slot_list = cm:get_region(m_current_transport_building_region):foreign_slot_manager_for_faction(m_oxyotl_faction_key):slots()
				for i = 0, slot_list:num_items() - 1 do
					local slot = slot_list:item_at(i)
					if(slot:has_building()) then
						local building_key = slot:building()
						if(building_key == m_transport_building_key) then
							cm:foreign_slot_instantly_dismantle_building(slot)
						end
					end
				end
			end

			m_current_transport_building_region = context:slot_manager():region():name()
        end,
        true
    )
end

local function reapply_sanctum_vision_listener()
	-- granted vision only lasts a turn so needs to be reapplied.
	core:add_listener(
        "oxy_sanctum_vision_reapply",
        "FactionTurnStart",
        function(context)
			local faction_name = context:faction():name()
            if(faction_name == m_oxyotl_faction_key) then
                return true
			end
			return false
        end,
		function(context)
			local foreign_slot_list = context:faction():foreign_slot_managers()
			
			for i = 0, foreign_slot_list:num_items() - 1 do
				local foreign_slot = foreign_slot_list:item_at(i)
				local foreign_building_slot_list = foreign_slot:slots()

				for j = 0, foreign_building_slot_list:num_items() - 1 do
					local building_slot = foreign_building_slot_list:item_at(j)

					if(building_slot:has_building() and building_slot:building() == m_vision_building_key) then
						local region_interface = foreign_slot:region()
						grant_vision_to_all_adjacent_regions(region_interface)
					end
				end
			end
        end,
        true
    )
end

local function update_oxyotl_sanctum_regions_with_ambush_buildings()
	m_regions_with_sanctums = {}
	local faction = cm:get_faction(m_oxyotl_faction_key)
	local foreign_slot_list = faction:foreign_slot_managers()
	for i = 0, foreign_slot_list:num_items() - 1 do
		local foreign_slot = foreign_slot_list:item_at(i)
		local foreign_building_slot_list = foreign_slot:slots()
		for j = 0, foreign_building_slot_list:num_items() - 1 do
			local building_slot = foreign_building_slot_list:item_at(j)

			if building_slot:has_building() and m_sanctum_ambush_config.ambush_buildings[building_slot:building()] then
				local region_interface = foreign_slot:region()
				local region_name = region_interface:name()
				local sanctum_ambush = {
					["region_name"] = region_name,
					["building_name"] = building_slot:building()
				}
				table.insert(m_regions_with_sanctums, sanctum_ambush)
			end
		end
	end
end

-- Returns the size the spawned ambush army should be
local function get_ambush_army_size(building_key)
	if building_key == m_sanctum_ambush_config.small_army_key then
		-- Spawn small army to attack lord army
		return m_sanctum_ambush_config.ambush_force_strength_small
	elseif building_key == m_sanctum_ambush_config.med_army_key then
		-- Spawn medium army to attack lord's army
		return m_sanctum_ambush_config.ambush_force_strength_medium
	else
		-- Unhandled Key error
		script_error("ERROR: lzd_silent_sanctums: Trying to use army size not specified for building key "..building_key)
	end
end

local function get_ambush_roll(building_key)
	local ambush_roll = cm:random_number(m_sanctum_ambush_config.ambush_max_value, m_sanctum_ambush_config.ambush_min_value)
	if building_key == m_sanctum_ambush_config.small_army_key then
		-- Spawn small army to attack lord army
		return ambush_roll <= m_sanctum_ambush_config.ambush_chance.building_1
	elseif building_key == m_sanctum_ambush_config.med_army_key then
		-- Spawn medium army to attack lord's army
		return ambush_roll <= m_sanctum_ambush_config.ambush_chance.building_2
	else
		-- Unhandled Key error
		script_error("ERROR: lzd_silent_sanctums: Trying to use ambush roll for building key "..building_key)
	end
end

local function get_invasion_power_by_turn()
	local turn = cm:model():turn_number()
	if turn % m_sanctum_ambush_config.turns_for_ambush_power_upgrade == 0 then
		if m_sanctum_ambush_config.ambush_current_power_level < m_sanctum_ambush_config.ambush_power_cap then
			m_sanctum_ambush_config.ambush_current_power_level = m_sanctum_ambush_config.ambush_current_power_level + 1
		end
	end
	return m_sanctum_ambush_config.ambush_current_power_level
end

local function spawn_ambush_army(enemy_force_cqi, force_size, invasion_power)
	local opt_player_generated_force, is_ambush, is_attacker, destroy_generated_force = true, true, true, true
	local player_vic_incident, player_def_incident, general_level = nil, nil, nil
	local effect_bundle = m_sanctum_ambush_config.ambush_bundle
	Forced_Battle_Manager:trigger_forced_battle_with_generated_army(
		enemy_force_cqi,
		m_oxyotl_faction_key,
		m_sanctum_ambush_config.army_template,
		force_size,
		invasion_power,
		is_attacker,
		destroy_generated_force,
		is_ambush,
		player_vic_incident,
		player_def_incident,
		m_sanctum_ambush_config.general_to_use,
		general_level,
		effect_bundle,
		opt_player_generated_force
	)
end

local function check_and_spawn_ambush_battle()
	local ambush_battle_generated = false
	for _, v in ipairs(m_regions_with_sanctums) do
		local lord_list_at_region = m_region_to_lord_list[v.region_name]
		if lord_list_at_region ~= nil then
			-- Found a lord in a region with the sanctum ambush building
			-- Check if ambush succeeds
			for _,lord in ipairs(lord_list_at_region) do
				if get_ambush_roll(v.building_name) then
					-- Spawn and force army to ambush attack given enemy army
					local enemy_force_cqi = lord.enemy_force:command_queue_index()
					local force_size = get_ambush_army_size(v.building_name)
					local invasion_power = get_invasion_power_by_turn()
					spawn_ambush_army(enemy_force_cqi, force_size, invasion_power)
					ambush_battle_generated = true
				end
				if ambush_battle_generated then
					-- Limit ambush to 1 per faction
					break
				end
			end
		end
		if ambush_battle_generated then
			-- Limit ambush to 1 per faction
			break
		end
	end
end

local function ambush_enemy_armies_listener()
	core:add_listener(
        "oxy_sanctum_ambush",
        "FactionAboutToEndTurn",
        function(context)
			local oxyotl_faction = cm:get_faction(m_oxyotl_faction_key)
           	-- war with Oxyotl?
			return context:faction():at_war_with(oxyotl_faction)
        end,
		function(context)
			m_region_to_lord_list = {}
			-- If faction is at war with oxyotl
			-- Generate list of all characters within that faction with a military force
			local faction_interface = context:faction()
			local forces_list = faction_interface:military_force_list()
			-- Get region of each character in list of forces
			for l = 0, forces_list:num_items() - 1 do
				local enemy_force = forces_list:item_at(l)
				local lord = enemy_force:general_character()
				if lord:is_null_interface() == false and lord:has_region() and not lord:has_garrison_residence() then
					local lord_region_name = lord:region():name()
					local info = {
						["lord"] = lord,
						["enemy_force"] = enemy_force
					}
					if not m_region_to_lord_list[lord_region_name] then m_region_to_lord_list[lord_region_name] = {} end
					table.insert(m_region_to_lord_list[lord_region_name], info)
				end
			end

			update_oxyotl_sanctum_regions_with_ambush_buildings()
			-- Trim list based on each characters location vs Ambush building locations
			check_and_spawn_ambush_battle()
        end,
        true
    )
end

local function sanctum_point_add_listener()
	core:add_listener(
        "oxy_sanctum_gems_per_turn",
        "FactionTurnStart",
		function(context)
			local faction_name = context:faction():name()
			return faction_name == m_oxyotl_faction_key and cm:get_factions_bonus_value(faction_name, "oxyotl_sanctum_gems_per_turn") > 0
        end,
		function(context)
			Silent_Sanctums:add_sanctum_gems(cm:get_factions_bonus_value(context:faction():name(), "oxyotl_sanctum_gems_per_turn"))
        end,
        true
    )
end

local function grant_starting_sanctum()
	core:add_listener(
        "oxy_starting_sanctum",
        "FactionTurnStart",
		function(context)
			local faction_name = context:faction():name()
			if(faction_name == m_oxyotl_faction_key and cm:turn_number() == 1) then
				return true
			end
			return false
        end,
		function(context)
			local campaign = cm:get_campaign_name()
			local faction_cqi = cm:get_faction(m_oxyotl_faction_key):command_queue_index()
			local region_cqi, foreign_slot, slot
			local region = m_starting_sanctum_regions[campaign]

			if(region) then
				region_cqi = cm:get_region(region):cqi()
				foreign_slot = cm:add_foreign_slot_set_to_region_for_faction(faction_cqi, region_cqi, m_sanctum_slot_set_key)
				slot = foreign_slot:slots():item_at(0)

				cm:foreign_slot_instantly_upgrade_building(slot, m_starting_building_key)
			else
				out.design("ERROR: Valid region for starting sanctum not provided")
			end
        end,
        false
    )
end

function add_oxyotl_sanctum_listeners()
	local oxyotl_faction = cm:get_faction(m_oxyotl_faction_key)

	if(oxyotl_faction) then
		local oxyotl_human = oxyotl_faction:is_human()

		if(oxyotl_human == true) then
			-- Player behaviour
			grant_starting_sanctum()
			silent_sanctum_constructed_listener()
			transport_building_built_listener()
			vision_building_built_listener()
			reapply_sanctum_vision_listener()
			ambush_enemy_armies_listener()
			sanctum_point_add_listener()
		else
			-- AI behaviour

		end
	end
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------


cm:add_saving_game_callback(
    function(context)
		cm:save_named_value("oxy_gems_first_gems", m_first_sanctum_point_gained, context)
		cm:save_named_value("oxy_gems_first_sanctum", m_first_sanctum_constructed, context)
		cm:save_named_value("oxy_current_teleport_region", m_current_transport_building_region, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			m_first_sanctum_point_gained = cm:load_named_value("oxy_gems_first_gems", m_first_sanctum_point_gained, context)
			m_first_sanctum_constructed = cm:load_named_value("oxy_gems_first_sanctum", m_first_sanctum_constructed, context)
			m_current_transport_building_region = cm:load_named_value("oxy_current_teleport_region", m_current_transport_building_region, context)
		end
	end
)