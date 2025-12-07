nor_pillaging = {
	nor_occupation_option_id = "1922893679",
	sayl_occupation_option_id = "1924306848",
	spawned_army_general_subtype = "wh3_dlc27_nor_marauder_chieftain_spawned_army",
	spawned_army_size = 5,
	spawned_army_starting_bundle_key = "wh3_dlc27_bundle_force_norsca_summoned_army", -- bundle on the spawned force
	spoils_force_key = "wh3_dlc27_nor_spoils_temp",
	spoils_faction_key = "wh3_dlc27_nor_spoils",
	spoils_factor_force_to_force = "wh3_dlc27_nor_spoils_temp_razing",
	spoils_factor_force_to_faction = "wh3_dlc27_nor_spoils_instant_razing",
	pillage_enabled_factions = {
		"wh_dlc08_nor_norsca",
		"wh_dlc08_nor_wintertooth",
		"wh3_dlc27_nor_sayl",
	},
	-- Category chances (percent). If unique pool is exhausted, generic is used instead.
	unique_chance_pct = 25, -- 25% unique / 75% generic

	-- Unique (only drop once)
ancillary_unique = {
	{ key = "wh3_dlc27_anc_arcane_item_azriks_map_star_striding",		weight = 1, limit_once = true },
	{ key = "wh3_dlc27_anc_arcane_item_stone_of_shyish",				weight = 1, limit_once = true },
  	{ key = "wh3_dlc27_anc_armour_armour_of_the_old_gods",				weight = 1, limit_once = true },
  	{ key = "wh3_dlc27_anc_armour_ravagers_chainmail",					weight = 1, limit_once = true },
  	{ key = "wh3_dlc27_anc_enchanted_item_collar_hounds_headsman",		weight = 1, limit_once = true },
	{ key = "wh3_dlc27_anc_enchanted_item_fallen_chieftains_jewel",		weight = 1, limit_once = true },
  	{ key = "wh3_dlc27_anc_follower_nor_indomitable_huskarl_bodyguard",	weight = 1, limit_once = true },
  	{ key = "wh3_dlc27_anc_follower_nor_infamous_reaver",				weight = 1, limit_once = true },
  	{ key = "wh3_dlc27_anc_talisman_charm_of_the_gods",					weight = 1, limit_once = true },
  	{ key = "wh3_dlc27_anc_talisman_eagle_feather_torc",				weight = 1, limit_once = true },
  	{ key = "wh3_dlc27_anc_talisman_icon_of_the_old_gods",				weight = 1, limit_once = true },
  	{ key = "wh3_dlc27_anc_weapon_axe_of_the_pale_serpent",				weight = 1, limit_once = true },
  	{ key = "wh3_dlc27_anc_weapon_blade_of_the_old_gods",				weight = 1, limit_once = true },
  	{ key = "wh3_dlc27_anc_weapon_tenebrous_forge_hammer", 				weight = 1, limit_once = true },
},


	-- Generic (unlimited drop)
ancillary_generic = {
  -- Rare (current weights are ~25% total when generic triggers)
  { key = "wh2_main_anc_weapon_executioners_axe",                 weight = 11, limit_once = false },
  { key = "wh_main_anc_weapon_obsidian_blade",                    weight = 11, limit_once = false },
  { key = "wh_main_anc_arcane_item_book_of_ashur",                weight = 11, limit_once = false },
  { key = "wh_main_anc_armour_armour_of_destiny",                 weight = 11, limit_once = false },
  { key = "wh_main_anc_armour_tricksters_helm",                   weight = 11, limit_once = false },
  { key = "wh_dlc08_anc_enchanted_item_vial_of_troll_blood",      weight = 11, limit_once = false },
  { key = "wh_main_anc_enchanted_item_the_other_tricksters_shard",weight = 11, limit_once = false },
  { key = "wh_main_anc_talisman_talisman_of_preservation",        weight = 11, limit_once = false },
  { key = "wh_dlc08_anc_weapon_flaming_axe_of_cormac",            weight = 11, limit_once = false },

  -- Uncommon (current weights are ~45% total when generic triggers)
  { key = "wh_main_anc_arcane_item_channelling_staff",            weight = 4, limit_once = false },
  { key = "wh_main_anc_arcane_item_forbidden_rod",                weight = 4, limit_once = false },
  { key = "wh_main_anc_enchanted_item_crown_of_command",          weight = 4, limit_once = false },
  { key = "wh_main_anc_enchanted_item_healing_potion",            weight = 4, limit_once = false },
  { key = "wh_dlc08_anc_talisman_slave_chain",                    weight = 4, limit_once = false },
  { key = "wh_main_anc_talisman_talisman_of_endurance",           weight = 4, limit_once = false },
  { key = "wh_dlc08_anc_weapon_fimir_hammer",                     weight = 4, limit_once = false },
  { key = "wh_main_anc_weapon_tormentor_sword",                   weight = 4, limit_once = false },
  { key = "wh_dlc03_anc_weapon_the_brass_cleaver",                weight = 4, limit_once = false },
  { key = "wh_dlc08_anc_armour_huskarl_plates",                   weight = 4, limit_once = false },
  { key = "wh_dlc08_anc_talisman_lootbag_of_marauders",           weight = 4, limit_once = false },
  { key = "wh_main_anc_weapon_fencers_blades",                    weight = 4, limit_once = false },
  { key = "wh_dlc08_anc_talisman_wolf_teeth_amulet",              weight = 4, limit_once = false },
  { key = "wh_main_anc_weapon_ogre_blade",                        weight = 4, limit_once = false },
  { key = "wh_main_anc_weapon_sword_of_bloodshed",                weight = 4, limit_once = false },
  { key = "wh_main_anc_weapon_sword_of_strife",                   weight = 4, limit_once = false },
  { key = "wh2_dlc10_anc_arcane_item_scroll_of_fear_of_aramar",   weight = 4, limit_once = false },
  { key = "wh_dlc08_anc_armour_blood_stained_armour_of_morkar",   weight = 4, limit_once = false },
  { key = "wh_dlc08_anc_armour_helm_of_reavers",                  weight = 4, limit_once = false },
  { key = "wh_dlc08_anc_armour_mammoth_hide_cape",                weight = 4, limit_once = false },
  { key = "wh_main_anc_armour_armour_of_fortune",                 weight = 4, limit_once = false },
  { key = "wh_main_anc_armour_armour_of_silvered_steel",          weight = 4, limit_once = false },
  { key = "wh_main_anc_armour_helm_of_discord",                   weight = 4, limit_once = false },
  { key = "wh_dlc08_anc_enchanted_item_manticore_horn",           weight = 4, limit_once = false },
  { key = "wh_main_anc_talisman_obsidian_amulet",                 weight = 4, limit_once = false },
  { key = "wh_main_anc_talisman_obsidian_lodestone",              weight = 4, limit_once = false },
  { key = "wh_dlc08_anc_weapon_troll_fang_dagger",                weight = 4, limit_once = false },
  { key = "wh_main_anc_weapon_giant_blade",                       weight = 4, limit_once = false },
  { key = "wh_main_anc_weapon_sword_of_anti-heroes",              weight = 4, limit_once = false },
  { key = "wh_main_anc_magic_standard_war_banner",                weight = 5, limit_once = false },
  { key = "wh_main_anc_magic_standard_wailing_banner",            weight = 5, limit_once = false },
  { key = "wh_main_anc_magic_standard_standard_of_discipline",    weight = 5, limit_once = false },
  { key = "wh_main_anc_magic_standard_scarecrow_banner",          weight = 5, limit_once = false },
  { key = "wh_main_anc_magic_standard_razor_standard",            weight = 5, limit_once = false },
  { key = "wh_main_anc_magic_standard_rangers_standard",          weight = 5, limit_once = false },
  { key = "wh_main_anc_magic_standard_rampagers_standard",        weight = 5, limit_once = false },
  { key = "wh_main_anc_magic_standard_lichbone_pennant",          weight = 5, limit_once = false },
  { key = "wh_main_anc_magic_standard_gleaming_pennant",          weight = 5, limit_once = false },
  { key = "wh_main_anc_magic_standard_banner_of_swiftness",       weight = 5, limit_once = false },
  { key = "wh_main_anc_magic_standard_banner_of_eternal_flame",   weight = 5, limit_once = false },
  { key = "wh_dlc08_anc_magic_standard_drake_hunters",            weight = 4, limit_once = false },
  { key = "wh_dlc08_anc_magic_standard_crimson_reapers",          weight = 4, limit_once = false },

  -- Common (Current weights are ~30% total when generic triggers)
  { key = "wh_main_anc_armour_charmed_shield",							weight = 3, limit_once = false },
  { key = "wh_main_anc_armour_dragonhelm",								weight = 3, limit_once = false },
  { key = "wh_main_anc_armour_enchanted_shield",						weight = 3, limit_once = false },
  { key = "wh_main_anc_armour_glittering_scales",						weight = 3, limit_once = false },
  { key = "wh_main_anc_armour_spellshield",								weight = 3, limit_once = false },
  { key = "wh2_dlc10_anc_enchanted_item_extinguished_phoenix_pinion",	weight = 3, limit_once = false },
  { key = "wh_main_anc_talisman_dawnstone",								weight = 3, limit_once = false },
  { key = "wh_main_anc_talisman_luckstone",								weight = 3, limit_once = false },
  { key = "wh_main_anc_talisman_opal_amulet",							weight = 3, limit_once = false },
  { key = "wh_main_anc_talisman_pidgeon_plucker_pendant",				weight = 3, limit_once = false },
  { key = "wh_main_anc_weapon_berserker_sword",							weight = 3, limit_once = false },
  { key = "wh_main_anc_weapon_biting_blade",							weight = 3, limit_once = false },
  { key = "wh_main_anc_weapon_gold_sigil_sword",						weight = 3, limit_once = false },
  { key = "wh_main_anc_weapon_relic_sword",								weight = 3, limit_once = false },
  { key = "wh_main_anc_weapon_shrieking_blade",							weight = 3, limit_once = false },
  { key = "wh_main_anc_weapon_sword_of_battle",							weight = 3, limit_once = false },
  { key = "wh_main_anc_weapon_sword_of_swift_slaying",					weight = 3, limit_once = false },
  { key = "wh_main_anc_weapon_warrior_bane",							weight = 3, limit_once = false },
  { key = "wh_main_anc_arcane_item_sceptre_of_stability",				weight = 3, limit_once = false },
  { key = "wh_main_anc_armour_shield_of_ptolos",						weight = 3, limit_once = false },
  { key = "wh_main_anc_enchanted_item_ironcurse_icon",					weight = 3, limit_once = false },
  { key = "wh_main_anc_weapon_sword_of_striking",						weight = 3, limit_once = false },
  { key = "wh_main_anc_arcane_item_power_scroll",						weight = 3, limit_once = false },
  { key = "wh_main_anc_arcane_item_wand_of_jet",						weight = 3, limit_once = false },
  { key = "wh_main_anc_enchanted_item_potion_of_speed",					weight = 3, limit_once = false },
  { key = "wh_main_anc_enchanted_item_the_terrifying_mask_of_eee",		weight = 3, limit_once = false },
  { key = "wh_main_anc_talisman_dragonbane_gem",						weight = 3, limit_once = false },
  { key = "wh2_dlc10_anc_arcane_item_scroll_of_blast",					weight = 3, limit_once = false },
  { key = "wh_main_anc_arcane_item_earthing_rod",						weight = 3, limit_once = false },
  { key = "wh_main_anc_arcane_item_power_stone",						weight = 3, limit_once = false },
  { key = "wh_main_anc_arcane_item_scroll_of_leeching",					weight = 3, limit_once = false },
  { key = "wh_main_anc_arcane_item_scroll_of_shielding",				weight = 3, limit_once = false },
  { key = "wh_main_anc_enchanted_item_featherfoe_torc",					weight = 3, limit_once = false },
  { key = "wh_main_anc_enchanted_item_potion_of_foolhardiness",			weight = 3, limit_once = false },
  { key = "wh_main_anc_enchanted_item_potion_of_strength",				weight = 3, limit_once = false },
  { key = "wh_main_anc_enchanted_item_potion_of_toughness",				weight = 3, limit_once = false },
  { key = "wh_main_anc_enchanted_item_ruby_ring_of_ruin",				weight = 3, limit_once = false },
  { key = "wh_main_anc_talisman_obsidian_trinket",						weight = 3, limit_once = false },
  { key = "wh_main_anc_talisman_talisman_of_protection",				weight = 3, limit_once = false },
  { key = "wh_main_anc_weapon_sword_of_might",							weight = 3, limit_once = false },
},

	event_spoils_army_details = {
		title = "event_feed_strings_text_wh3_dlc27_scripted_event_spoils_army_sayl_title",
		primary_detail = "event_feed_strings_text_wh3_dlc27_scripted_event_spoils_army_sayl_primary_detail",
		secondary_detail = "event_feed_strings_text_wh3_dlc27_scripted_event_spoils_army_sayl_secondary_detail",
		pic = 1901,
	},
	event_spoils_collect_details = {
		title = "event_feed_strings_text_wh3_dlc27_scripted_event_spoils_collected_sayl_title",
		primary_detail = "event_feed_strings_text_wh3_dlc27_scripted_event_spoils_collected_sayl_primary_detail",
		secondary_detail = "event_feed_strings_text_wh3_dlc27_scripted_event_spoils_collected_sayl_secondary_detail",
		pic = 1902,
	},
	control_to_reduce_by = 50,
	characters_currently_transferring_resource = {},
	_save_prefix = "nor_pillaging_anc_awarded_", -- bump this prefix to invalidate past flags
}

-- Helpers for ancillary awarding
function nor_pillaging:_eligible_from(list, faction_interface)
	local candidates = {}
	local total_weight = 0
	if not list then return candidates, total_weight end
	for _, entry in ipairs(list) do
		if entry and entry.key then
			local w = entry.weight or 1
			if w > 0 then
				local eligible = true
				if entry.limit_once and self:_has_already_awarded(faction_interface, entry.key) then
					eligible = false
				end
				if eligible then
					table.insert(candidates, entry)
					total_weight = total_weight + w
				end
			end
		end
	end
	return candidates, total_weight
end
function nor_pillaging:_weighted_pick(candidates, total_weight)
	if total_weight <= 0 or #candidates == 0 then return nil end
	local roll = cm:random_number(total_weight) -- 1..total_weight
	local cumulative = 0
	for _, c in ipairs(candidates) do
		cumulative = cumulative + (c.weight or 1)
		if roll <= cumulative then
			return c
		end
	end
	return candidates[#candidates]
end

function nor_pillaging:_ancillary_save_key(faction_interface, ancillary_key)
	return self._save_prefix .. faction_interface:name() .. "_" .. ancillary_key
end

function nor_pillaging:_has_already_awarded(faction_interface, ancillary_key)
	return cm:get_saved_value(self:_ancillary_save_key(faction_interface, ancillary_key)) == true
end

function nor_pillaging:_mark_as_awarded(faction_interface, ancillary_key)
	cm:set_saved_value(self:_ancillary_save_key(faction_interface, ancillary_key), true)
end

-- Try to check if faction actually possesses the ancillary
function nor_pillaging:_faction_has_ancillary(faction_interface, ancillary_key)
	-- Try cm:faction_has_ancillary(faction_interface, key)
	local ok, result = pcall(function()
		return cm:faction_has_ancillary(faction_interface, ancillary_key)
	end)
	if ok and type(result) == "boolean" then return result end

	-- Try cm:faction_has_ancillary(faction_name, key)
	local ok2, result2 = pcall(function()
		return cm:faction_has_ancillary(faction_interface:name(), ancillary_key)
	end)
	if ok2 and type(result2) == "boolean" then return result2 end

	-- Fallback: if API isn't available, assume true so we can mark uniques as awarded
	return true
end

-- Weightedd pick with once-per-faction filtering ; triggeer event feed UI
function nor_pillaging:grant_random_ancillary(faction_interface)
	if not (faction_interface and not faction_interface:is_null_interface()) then return end

	-- Build eligible pools
	local unique_pool, unique_weight = self:_eligible_from(self.ancillary_unique, faction_interface)
	local generic_pool, generic_weight = self:_eligible_from(self.ancillary_generic, faction_interface)

	-- If both empty, nothing to award
	if (#unique_pool == 0) and (#generic_pool == 0) then return end

	local pool = nil
	local total = 0

	if #unique_pool == 0 then
		pool = generic_pool; total = generic_weight
	elseif #generic_pool == 0 then
		pool = unique_pool; total = unique_weight
	else
		local pct = math.max(0, math.min(100, self.unique_chance_pct or 0))
		local roll100 = cm:random_number(100) -- 1..100
		if roll100 <= pct then
			pool = unique_pool; total = unique_weight
		else
			pool = generic_pool; total = generic_weight
		end
	end

	if not pool or total <= 0 then return end

	local chosen = self:_weighted_pick(pool, total)
	if chosen and chosen.key then
		cm:add_ancillary_to_faction(faction_interface, chosen.key, false) -- don't suppress event feed

		if chosen.limit_once and self:_faction_has_ancillary(faction_interface, chosen.key) then
			self:_mark_as_awarded(faction_interface, chosen.key)
		end
	end
end


-- Reset all saved "awarded once" flags for this faction (for testing)

function nor_pillaging:reset_ancillary_limits_for_faction(faction_interface)
	if not (faction_interface and not faction_interface:is_null_interface()) then return end
	for _, entry in ipairs(self.ancillary_unique or {}) do
		if entry and entry.key then
			cm:set_saved_value(self:_ancillary_save_key(faction_interface, entry.key), false)
		end
	end
	for _, entry in ipairs(self.ancillary_generic or {}) do
		if entry and entry.key then
			cm:set_saved_value(self:_ancillary_save_key(faction_interface, entry.key), false)
		end
	end
end


-- Reset for ALL factions (for testing cheats)
function nor_pillaging:reset_ancillary_limits_all()
	local factions = cm:model():world():faction_list()
	for i = 0, factions:num_items() - 1 do
		local f = factions:item_at(i)
		self:reset_ancillary_limits_for_faction(f)
	end
end

function nor_pillaging:initialise_shared_states()
	local unique_ancillaries_list = ""
	for _, entry in ipairs(self.ancillary_unique or {}) do
		if entry and entry.key then
			unique_ancillaries_list = unique_ancillaries_list .. entry.key .. ";"
		end
	end

	for i = 1, #self.pillage_enabled_factions do
		local faction = cm:get_faction(self.pillage_enabled_factions[i])
		if faction and not faction:is_null_interface() then
			cm:set_script_state(faction, "pillage_unique_ancillaries", unique_ancillaries_list)
		end
	end
end

-- === Core logic ===

function nor_pillaging:initialise()
	common.set_context_value("control_to_reduce_by", self.control_to_reduce_by)
	self:initialise_shared_states()
	
	core:add_listener(
		"CharacterPerformsSettlementOccupationDecision_PillageArmy",
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			return context:occupation_decision() == self.nor_occupation_option_id
				or context:occupation_decision() == self.sayl_occupation_option_id
		end,
		function(context)
			self:grant_random_ancillary(context:character():faction())
			self:spawn_army(context:character())
			cm:show_message_event(
				context:character():faction():name(),
				self.event_spoils_army_details.title,
				self.event_spoils_army_details.primary_detail,
				self.event_spoils_army_details.secondary_detail,
				true,
				self.event_spoils_army_details.pic
			)
		end,
		true
	)

	core:add_listener(
		"CharacterFinishedMovingEvent_PillageArmy",
		"CharacterEntersGarrison",
		function(context)
			local character = context:character()
			local bonus_value = cm:get_characters_bonus_value(character, "pillaging_valid_location")
			return character:character_subtype(self.spawned_army_general_subtype)
				and bonus_value > 0
				and not table.contains(self.characters_currently_transferring_resource, character:command_queue_index())
		end,
		function(context)
			self:transfer_spoils_to_faction(context:character())
			cm:show_message_event(
				context:character():faction():name(),
				self.event_spoils_collect_details.title,
				self.event_spoils_collect_details.primary_detail,
				self.event_spoils_collect_details.secondary_detail,
				true,
				self.event_spoils_collect_details.pic
			)
		end,
		true
	)

	core:add_listener(
		"CharacterOccupiedSettlement_PillageArmy",
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			local valid_occupation_types = {
				"occupation_decision_occupy"
			}

			local character = context:character()
			local bonus_value = cm:get_characters_bonus_value(character, "pillaging_valid_location")
			return character:character_subtype(self.spawned_army_general_subtype)
				and bonus_value > 0
				and table.contains(valid_occupation_types, context:occupation_decision_type())
				and not table.contains(self.characters_currently_transferring_resource, character:command_queue_index())
		end,
		function(context)
			self:transfer_spoils_to_faction(context:character())
			cm:show_message_event(
				context:character():faction():name(),
				self.event_spoils_collect_details.title,
				self.event_spoils_collect_details.primary_detail,
				self.event_spoils_collect_details.secondary_detail,
				true,
				self.event_spoils_collect_details.pic
			)
		end,
		true
	)

	core:add_listener(
		"norsca_province_ritual_performed",
		"RitualCompletedEvent",
		function(context)
			return context:ritual():ritual_key() == "wh3_dlc27_ritual_nor_marauding_pillage"
		end,
		function(context)
			local region = context:ritual():ritual_target():get_target_region()
			local public_order = region:public_order()
			local new_value = public_order + (0 - self.control_to_reduce_by)
			cm:set_public_order_of_province_for_region(region:name(), new_value)
		end,
		true
	)

	core:add_listener(
		"MilitaryForceCreated_pillaging",
		"MilitaryForceCreated",
		function(context)
			return context:military_force_created():force_type():key() == "ARMY_PILLAGING"
		end,
		function(context)
			local general_cqi = context:military_force_created():general_character():command_queue_index()
			local general_lookup = "character_cqi:" .. general_cqi
			cm:replenish_action_points(general_lookup, 0.5)
		end,
		true
	)
end

-- === Army spawn & transfer ===

function nor_pillaging:spawn_army(character)
	local faction = character:faction()
	local faction_key = faction:name()
	local distance = 10
	local x, y = cm:find_valid_spawn_location_for_character_from_character(faction_key, cm:char_lookup_str(character), false, distance)
	if x > 0 then
		local bonus_size = cm:get_characters_bonus_value(character, "pillaging_force_size_mod")

		local ram = random_army_manager
		ram:remove_force("nor_pillage_army")
		ram:new_force("nor_pillage_army")
		ram:add_mandatory_unit("nor_pillage_army", "wh_main_nor_inf_chaos_marauders_0", 2)
		ram:add_mandatory_unit("nor_pillage_army", "wh_main_nor_cav_marauder_horsemen_0", 1)

		ram:add_unit("nor_pillage_army", "wh_main_nor_inf_chaos_marauders_0", 10)
		ram:add_unit("nor_pillage_army", "wh_main_nor_inf_chaos_marauders_1", 10)
		ram:add_unit("nor_pillage_army", "wh_dlc08_nor_inf_marauder_berserkers_0", 10)
		ram:add_unit("nor_pillage_army", "wh_main_nor_cav_marauder_horsemen_0", 5)

		local army_size = math.clamp(self.spawned_army_size + bonus_size, 1, 19)
		local unit_list = ram:generate_force("nor_pillage_army", army_size, false)
		local subtype = self.spawned_army_general_subtype
		if character:military_force():force_type():key() ~= "ARMY_PILLAGING" then
			cm:create_force_with_general(
				faction_key,
				unit_list,
				cm:model():world():region_manager():region_list():item_at(1):name(),
				x,
				y,
				"general",
				subtype,
				"",
				"",
				"",
				"",
				false,
				function(cqi)
					cm:apply_effect_bundle_to_characters_force(self.spawned_army_starting_bundle_key, cqi, 0)
					self:transfer_spoils_to_force(character, cqi)
				end
			)
		end
	end
end

function nor_pillaging:transfer_spoils_to_force(source_character, cqi)
	if source_character:has_military_force() then
		local pillage_amount = source_character:military_force():pooled_resource_manager():resource(self.spoils_force_key):value()
		local target_character = cm:get_character_by_cqi(cqi)
		cm:entity_transfer_pooled_resource(
			source_character:military_force(), self.spoils_factor_force_to_force,
			target_character:military_force(), self.spoils_factor_force_to_force,
			pillage_amount
		)
	end
end

function nor_pillaging:transfer_spoils_to_faction(character)
	if character:has_military_force() then
		local pillage_amount = character:military_force():pooled_resource_manager():resource(self.spoils_force_key):value()
		cm:faction_add_pooled_resource(character:faction():name(), self.spoils_faction_key, self.spoils_factor_force_to_faction, pillage_amount)
		table.insert(self.characters_currently_transferring_resource, character:command_queue_index())
		cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
		cm:callback(function()
				for position_key, character_cqi in ipairs(self.characters_currently_transferring_resource) do
					if character:command_queue_index() == character_cqi then
						table.remove(self.characters_currently_transferring_resource, position_key)
						break
					end
				end
				cm:kill_character(character:command_queue_index(), true)
				cm:disable_event_feed_events(false, "wh_event_category_character", "", "")
			end,
		0.5)
	end
end