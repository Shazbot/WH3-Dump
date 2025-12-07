asur_domination =
{
	config =
	{
		restrictions_icon_asur_domination = "ui/skins/default/dlc27_hef_asur_domination/icon_assur_domination_button.png",
		restrictions_redirection_path_asur_domination = "ui/campaign ui/dlc27_hef_asur_domination",
		aislinn_faction_key = "wh3_dlc27_hef_aislinn",
		rituals_category_key = "ASUR_DOMINATION_DILEMMAS",
		occupation_decision = "occupation_decision_gift_to_another_faction",
		dilemma_available_event_config = {
			title = "event_feed_strings_text_wh3_dlc27_event_feed_string_consult_leaders_dilemma_available_title",
			primary_detail = "event_feed_strings_text_wh3_dlc27_event_feed_string_consult_leaders_dilemma_available_primary_detail",
			secondary_detail = "event_feed_strings_text_wh3_dlc27_event_feed_string_consult_leaders_dilemma_available_secondary_detail",
			is_persistent = false,
			campaign_group_member_criteria_value = 1960,
		},
		occupation_option_key_to_resource_factor_and_foreign_slot_building =
		{
			["96128829"] = -- MAJOR
			{
				foreign_slot_set_key = "wh3_dlc27_slot_set_hef_sea_patrol_outpost_focus_outposts",
				outpost_pooled_resource_key = "wh3_dlc27_hef_aislinn_focus",
				foreign_slot_building_to_grant = "wh3_dlc27_hef_sea_patrol_outpost_focus_1",
			},
			["2050244199"] = -- MINOR
			{
				foreign_slot_set_key = "wh3_dlc27_slot_set_hef_sea_patrol_outpost_focus_outposts",
				outpost_pooled_resource_key = "wh3_dlc27_hef_aislinn_focus",
				foreign_slot_building_to_grant = "wh3_dlc27_hef_sea_patrol_outpost_focus_1",
			}
		},
		foreign_slot_set_key_overrides =
		{
			["wh3_main_combi_region_arnheim"] = "wh3_dlc27_slot_set_hef_sea_patrol_outpost_focus_outposts_arnheim",
			["wh3_main_combi_region_citadel_of_dusk"] = "wh3_dlc27_slot_set_hef_sea_patrol_outpost_focus_outposts_citadel_of_dusk",
			["wh3_main_combi_region_fortress_of_dawn"] = "wh3_dlc27_slot_set_hef_sea_patrol_outpost_focus_outposts_fortress_of_dawn",
			["wh3_main_combi_region_great_turtle_isle"] = "wh3_dlc27_slot_set_hef_sea_patrol_outpost_focus_outposts_great_turtle_isle",
			["wh3_main_combi_region_gronti_mingol"] = "wh3_dlc27_slot_set_hef_sea_patrol_outpost_focus_outposts_gronti_mingol",
			["wh3_main_combi_region_the_star_tower"] = "wh3_dlc27_slot_set_hef_sea_patrol_outpost_focus_outposts_the_star_tower",
			["wh3_main_combi_region_tor_elasor"] = "wh3_dlc27_slot_set_hef_sea_patrol_outpost_focus_outposts_tor_elasor",
			["wh3_main_combi_region_tower_of_the_stars"] = "wh3_dlc27_slot_set_hef_sea_patrol_outpost_focus_outposts_tower_of_the_stars",
			["wh3_main_combi_region_tower_of_the_sun"] = "wh3_dlc27_slot_set_hef_sea_patrol_outpost_focus_outposts_tower_of_the_sun"
		},
		sea_patrol_track_resource_amount_per_occupation = 1,
		sea_patrol_track_resource_factor_key = "wh3_dlc27_hef_aislinn_occupation_option",
		giftable_factions =
		{
			"wh2_dlc15_hef_imrik",
			"wh2_main_hef_avelorn",
			"wh2_main_hef_eataine",
			"wh2_main_hef_nagarythe",
			"wh2_main_hef_order_of_loremasters",
			"wh2_main_hef_yvresse",
		},
		diplomatic_bonus =
		{
			effect_key_prefix = "wh3_dlc27_faction_political_diplomacy_mod_aislinn;",
			effect_bundle_key_prefix = "wh3_dlc27_effect_bonus_diplomatic_bonus_aislinn;",
			major_settlement = 5,
			minor_settlement = 3,
			climate_suitability =
			{
				["suitability_good"] = 3,
				["suitability_poor"] = -3,
				["suitability_verypoor"] = -5,
			},
			num_other_owned_settlements_in_same_province =
			{
				[0] = 0,
				[1] = 1,
				[2] = 3,
				[3] = 5,
			},
			num_other_owned_settlements_in_neighbouring_provinces =
			{
				[0] = 0,
				[1] = 3,
			},
		},
		dragonship_admirals_threshold_setup = {
			["wh3_dlc27_hef_aislinn_focus_outposts_2"] = "wh3_dlc27_hef_dragonship_captain_01",
			["wh3_dlc27_hef_aislinn_focus_colonies_2"] = "wh3_dlc27_hef_dragonship_captain_02",
			["wh3_dlc27_hef_aislinn_focus_dragonships_2"] = "wh3_dlc27_hef_dragonship_captain_03"
		},
		dragonship_admirals_initiative_setup = {
			["wh3_dlc27_asur_domination_focus_dragonships_08"] = "wh3_dlc27_hef_dragonship_captain_04"
		},
		elven_colony_threshold_unlocks = {
			["wh3_dlc27_hef_aislinn_focus_colonies_1"] = {resource = "wh3_dlc27_hef_elven_colonies", factor = "aislinn_asur_domination", amount = 1},
			["wh3_dlc27_hef_aislinn_focus_colonies_2"] = {resource = "wh3_dlc27_hef_elven_colonies", factor = "aislinn_asur_domination", amount = 1},
			["wh3_dlc27_hef_aislinn_focus_colonies_3"] = {resource = "wh3_dlc27_hef_elven_colonies", factor = "aislinn_asur_domination", amount = 1},
			["wh3_dlc27_hef_aislinn_focus_dragonships_3"] = {resource = "wh3_dlc27_hef_elven_colonies", factor = "aislinn_asur_domination", amount = 1},
			["wh3_dlc27_hef_aislinn_focus_outposts_3"] = {resource = "wh3_dlc27_hef_elven_colonies", factor = "aislinn_asur_domination", amount = 1}
		},
		elven_colony_initiative_unlocks = {
			{resource = "wh3_dlc27_hef_elven_colonies", factor = "aislinn_asur_domination", amount = 1, unlock = "wh3_dlc27_asur_domination_focus_colonies_04"},
			{resource = "wh3_dlc27_hef_elven_colonies", factor = "aislinn_asur_domination", amount = 1, unlock = "wh3_dlc27_asur_domination_focus_colonies_08"}
		},
		dragonship_building_locks = {
			{building = "wh3_dlc27_hef_dragonship_aoe_3b", lock_reason = "aislinn_lock_reason_dragonship", unlock = "wh3_dlc27_asur_domination_focus_dragonships_01", show_unlock_in_ui = true},
			{building = "wh3_dlc27_hef_dragonship_navigation_3b", lock_reason = "aislinn_lock_reason_dragonship", unlock = "wh3_dlc27_asur_domination_focus_dragonships_02", show_unlock_in_ui = true},
			{building = "wh3_dlc27_hef_dragonship_navigation_4b", lock_reason = "aislinn_lock_reason_dragonship", unlock = "wh3_dlc27_asur_domination_focus_dragonships_02", show_unlock_in_ui = false},
			{building = "wh3_dlc27_hef_dragonship_respite_3b", lock_reason = "aislinn_lock_reason_dragonship", unlock = "wh3_dlc27_asur_domination_focus_dragonships_03", show_unlock_in_ui = true},
			{building = "wh3_dlc27_hef_dragonship_extra_2a", lock_reason = "aislinn_lock_reason_dragonship", unlock = "wh3_dlc27_asur_domination_focus_dragonships_04", show_unlock_in_ui = true},
			{building = "wh3_dlc27_hef_dragonship_extra_2b", lock_reason = "aislinn_lock_reason_dragonship", unlock = "wh3_dlc27_asur_domination_focus_dragonships_04", show_unlock_in_ui = true},
			{building = "wh3_dlc27_hef_dragonship_extra_2c", lock_reason = "aislinn_lock_reason_dragonship", unlock = "wh3_dlc27_asur_domination_focus_dragonships_04", show_unlock_in_ui = true},
			{building = "wh3_dlc27_hef_dragonship_treasury_3b", lock_reason = "aislinn_lock_reason_dragonship", unlock = "wh3_dlc27_asur_domination_focus_dragonships_05", show_unlock_in_ui = true},
			{building = "wh3_dlc27_hef_dragonship_xp_3b", lock_reason = "aislinn_lock_reason_dragonship", unlock = "wh3_dlc27_asur_domination_focus_dragonships_06", show_unlock_in_ui = true}
		},
		outpost_building_locks = {
			{building = "wh3_dlc27_hef_sea_patrol_outpost_defence_garrison_2a", lock_reason = "aislinn_lock_reason_outpost", unlock = "wh3_dlc27_asur_domination_focus_outposts_01", show_unlock_in_ui = true},
			{building = "wh3_dlc27_hef_sea_patrol_outpost_defence_garrison_2c", lock_reason = "aislinn_lock_reason_outpost", unlock = "wh3_dlc27_asur_domination_focus_outposts_01", show_unlock_in_ui = true},
			{building = "wh3_dlc27_hef_sea_patrol_outpost_defence_garrison_3d", lock_reason = "aislinn_lock_reason_outpost", unlock = "wh3_dlc27_asur_domination_focus_outposts_02", show_unlock_in_ui = true},
			{building = "wh3_dlc27_hef_sea_patrol_outpost_defence_garrison_3e", lock_reason = "aislinn_lock_reason_outpost", unlock = "wh3_dlc27_asur_domination_focus_outposts_02", show_unlock_in_ui = true},
			{building = "wh3_dlc27_hef_sea_patrol_outpost_income_branch_2a", lock_reason = "aislinn_lock_reason_outpost", unlock = "wh3_dlc27_asur_domination_focus_outposts_03", show_unlock_in_ui = true},
			{building = "wh3_dlc27_hef_sea_patrol_outpost_income_branch_3a", lock_reason = "aislinn_lock_reason_outpost", unlock = "wh3_dlc27_asur_domination_focus_outposts_03", show_unlock_in_ui = false},
			{building = "wh3_dlc27_hef_sea_patrol_outpost_income_branch_2b", lock_reason = "aislinn_lock_reason_outpost", unlock = "wh3_dlc27_asur_domination_focus_outposts_04", show_unlock_in_ui = true},
			{building = "wh3_dlc27_hef_sea_patrol_outpost_income_branch_3b", lock_reason = "aislinn_lock_reason_outpost", unlock = "wh3_dlc27_asur_domination_focus_outposts_04", show_unlock_in_ui = false},
			{building = "wh3_dlc27_hef_sea_patrol_outpost_income_branch_2d", lock_reason = "aislinn_lock_reason_outpost", unlock = "wh3_dlc27_asur_domination_focus_outposts_05", show_unlock_in_ui = true},
			{building = "wh3_dlc27_hef_sea_patrol_outpost_income_branch_3d", lock_reason = "aislinn_lock_reason_outpost", unlock = "wh3_dlc27_asur_domination_focus_outposts_05", show_unlock_in_ui = false},
			{building = "wh3_dlc27_hef_sea_patrol_outpost_defence_garrison_3a", lock_reason = "aislinn_lock_reason_outpost", unlock = "wh3_dlc27_asur_domination_focus_outposts_06", show_unlock_in_ui = true},
			{building = "wh3_dlc27_hef_sea_patrol_outpost_defence_garrison_3b", lock_reason = "aislinn_lock_reason_outpost", unlock = "wh3_dlc27_asur_domination_focus_outposts_06", show_unlock_in_ui = false},
			{building = "wh3_dlc27_hef_sea_patrol_outpost_income_branch_2e", lock_reason = "aislinn_lock_reason_outpost", unlock = "wh3_dlc27_asur_domination_focus_outposts_07", show_unlock_in_ui = true},
			{building = "wh3_dlc27_hef_sea_patrol_outpost_income_branch_3e", lock_reason = "aislinn_lock_reason_outpost", unlock = "wh3_dlc27_asur_domination_focus_outposts_07", show_unlock_in_ui = false}
		},
		colony_building_locks = {
			{building = "wh3_dlc27_hef_colony_dragonship_supplies_cost_2", lock_reason = "aislinn_lock_reason_colony", unlock = "wh3_dlc27_asur_domination_focus_colonies_01", show_unlock_in_ui = true},
			{building = "wh3_dlc27_hef_colony_dragonship_supplies_cost_3", lock_reason = "aislinn_lock_reason_colony", unlock = "wh3_dlc27_asur_domination_focus_colonies_01", show_unlock_in_ui = false},
			{building = "wh3_dlc27_hef_colony_dragonship_supplies_income_2b", lock_reason = "aislinn_lock_reason_colony", unlock = "wh3_dlc27_asur_domination_focus_colonies_02", show_unlock_in_ui = true},
			{building = "wh3_dlc27_hef_colony_dragonship_supplies_income_3b", lock_reason = "aislinn_lock_reason_colony", unlock = "wh3_dlc27_asur_domination_focus_colonies_02", show_unlock_in_ui = false},
			{building = "wh3_dlc27_hef_colony_economy_market_2", lock_reason = "aislinn_lock_reason_colony", unlock = "wh3_dlc27_asur_domination_focus_colonies_03", show_unlock_in_ui = true},
			{building = "wh3_dlc27_hef_colony_economy_market_3", lock_reason = "aislinn_lock_reason_colony", unlock = "wh3_dlc27_asur_domination_focus_colonies_03", show_unlock_in_ui = false},
			{building = "wh3_dlc27_hef_colony_defence_sea_guard_1", lock_reason = "aislinn_lock_reason_colony", unlock = "wh3_dlc27_asur_domination_focus_colonies_05", show_unlock_in_ui = true},
			{building = "wh3_dlc27_hef_colony_defence_sea_guard_2", lock_reason = "aislinn_lock_reason_colony", unlock = "wh3_dlc27_asur_domination_focus_colonies_05", show_unlock_in_ui = false},
			{building = "wh3_dlc27_hef_colony_defence_sea_guard_3", lock_reason = "aislinn_lock_reason_colony", unlock = "wh3_dlc27_asur_domination_focus_colonies_05", show_unlock_in_ui = false},
			{building = "wh3_dlc27_hef_colony_economy_trade_2", lock_reason = "aislinn_lock_reason_colony", unlock = "wh3_dlc27_asur_domination_focus_colonies_06", show_unlock_in_ui = true},
			{building = "wh3_dlc27_hef_colony_economy_trade_3", lock_reason = "aislinn_lock_reason_colony", unlock = "wh3_dlc27_asur_domination_focus_colonies_06", show_unlock_in_ui = false},
			{building = "wh3_dlc27_hef_colony_recruitment_barracks_4", lock_reason = "aislinn_lock_reason_colony", unlock = "wh3_dlc27_asur_domination_focus_colonies_07", show_unlock_in_ui = true},
			{building = "wh3_dlc27_hef_colony_recruitment_stables_3", lock_reason = "aislinn_lock_reason_colony", unlock = "wh3_dlc27_asur_domination_focus_colonies_07", show_unlock_in_ui = true},
			{building = "wh3_dlc27_hef_colony_recruitment_artillery_3", lock_reason = "aislinn_lock_reason_colony", unlock = "wh3_dlc27_asur_domination_focus_colonies_07", show_unlock_in_ui = true}
		},
		focus_pooled_resource_key = "wh3_dlc27_hef_aislinn_focus",
		feature_unlock_minimum_focus_resource = 500,
		feature_unlock_minimum_settlements_gifted = 2,
		button_ui_override_key = "disable_asur_domination_button",
	},
	saved_data = {
		dragonship_names_setup = {
			forename = {
				"names_name_1819815097",
				"names_name_2147359403",
				"names_name_2147360242",
				"names_name_201846194",
				"names_name_127588805"
			},
			surname = {
				"names_name_509665994",
				"names_name_1018940043",
				"names_name_1109425039",
				"names_name_1677441969",
				"names_name_1742868095"
			},
			char_art = {
				"wh3_dlc27_art_set_hef_dragonship_captain_1",
				"wh3_dlc27_art_set_hef_dragonship_captain_2",
				"wh3_dlc27_art_set_hef_dragonship_captain_3",
				"wh3_dlc27_art_set_hef_dragonship_captain_4",
				"wh3_dlc27_art_set_hef_dragonship_captain_5",
			}
		},

		ritual_category_cooldown_end_turn = -1,
	}
}

function asur_domination:initialise()
	self:add_listeners()
	self:set_aislinn_diplomacy_restrictions()

	if cm:is_new_game() == true then
		local faction = cm:get_faction(self.config.aislinn_faction_key)

		for i = 1, #self.config.dragonship_building_locks do
			if self.config.dragonship_building_locks[i].show_unlock_in_ui == true then
				cm:add_event_restricted_building_record_for_faction(self.config.dragonship_building_locks[i].building,
																	self.config.aislinn_faction_key,
																	self.config.dragonship_building_locks[i].lock_reason,
																	self.config.restrictions_icon_asur_domination,
																	self.config.restrictions_redirection_path_asur_domination);
				self:set_shared_state_building_level_unlocks_for_initiative(self.config.dragonship_building_locks[i].unlock, faction, self.config.dragonship_building_locks);
				cm:set_script_state(faction, self.config.dragonship_building_locks[i].building, self.config.dragonship_building_locks[i].unlock);
			else
				cm:add_event_restricted_building_record_for_faction(self.config.dragonship_building_locks[i].building,
																	self.config.aislinn_faction_key,
																	self.config.dragonship_building_locks[i].lock_reason);
			end
		end
		for i = 1, #self.config.outpost_building_locks do
			if self.config.outpost_building_locks[i].show_unlock_in_ui == true then
				cm:add_event_restricted_building_record_for_faction(self.config.outpost_building_locks[i].building,
																	self.config.aislinn_faction_key,
																	self.config.outpost_building_locks[i].lock_reason,
																	self.config.restrictions_icon_asur_domination,
																	self.config.restrictions_redirection_path_asur_domination);
				self:set_shared_state_building_level_unlocks_for_initiative(self.config.outpost_building_locks[i].unlock, faction, self.config.outpost_building_locks);
				cm:set_script_state(faction, self.config.outpost_building_locks[i].building, self.config.outpost_building_locks[i].unlock);
			else
				cm:add_event_restricted_building_record_for_faction(self.config.outpost_building_locks[i].building,
																	self.config.aislinn_faction_key,
																	self.config.outpost_building_locks[i].lock_reason);
			end
		end
		for i = 1, #self.config.colony_building_locks do
			if self.config.colony_building_locks[i].show_unlock_in_ui == true then
				cm:add_event_restricted_building_record_for_faction(self.config.colony_building_locks[i].building,
																	self.config.aislinn_faction_key,
																	self.config.colony_building_locks[i].lock_reason,
																	self.config.restrictions_icon_asur_domination,
																	self.config.restrictions_redirection_path_asur_domination);
				self:set_shared_state_building_level_unlocks_for_initiative(self.config.colony_building_locks[i].unlock, faction, self.config.colony_building_locks);
				cm:set_script_state(faction, self.config.colony_building_locks[i].building, self.config.colony_building_locks[i].unlock);
			else
				cm:add_event_restricted_building_record_for_faction(self.config.colony_building_locks[i].building,
																	self.config.aislinn_faction_key,
																	self.config.colony_building_locks[i].lock_reason);
			end
		end

		cm:override_ui(self.config.button_ui_override_key, true)
	end
end

function asur_domination:set_shared_state_building_level_unlocks_for_initiative(initiative_key, faction_interface, table)
	if cm:model():shared_states_manager():get_state_as_string_value(faction_interface, initiative_key) == nil then
		local building_level_unlocks_from_initiative = ""
		for i = 1, #table do
			if table[i].unlock == initiative_key and table[i].show_unlock_in_ui then
				if building_level_unlocks_from_initiative ~= "" then
					building_level_unlocks_from_initiative = building_level_unlocks_from_initiative .. "/"
				end
				building_level_unlocks_from_initiative = building_level_unlocks_from_initiative .. table[i].building
			end
		end
		if building_level_unlocks_from_initiative ~= "" then
			-- these shared state values are used in the asur domination panel when hovering over each of the initiatives so that we can see which buildings they unlock
			-- check "tooltip_dlc27_asur_domination_initiative" layout
			cm:set_script_state(faction_interface, initiative_key, building_level_unlocks_from_initiative)
		end
	end
end

function asur_domination:calculate_diplomatic_bonus_towards_faction_by_gifting_region(faction_key, region)
	if not table.contains(self.config.giftable_factions, faction_key) then
		return 0
	end

	local gifted_faction = cm:get_faction(faction_key)

	local total_bonus_value = 0

	local major_settlement_bonus = region:is_province_capital() and self.config.diplomatic_bonus.major_settlement or self.config.diplomatic_bonus.minor_settlement
	total_bonus_value = total_bonus_value + major_settlement_bonus

	local climate_suitability = gifted_faction:get_climate_suitability(region:settlement():get_climate())	-- suitability towards a particular climate depends on the faction
	local climate_suitability_bonus = self.config.diplomatic_bonus.climate_suitability[climate_suitability] or 0
	total_bonus_value = total_bonus_value + climate_suitability_bonus

	local province = region:province()
	local province_regions = province:regions()
	local num_owned_regions_in_province = 0
	for i = 0, province_regions:num_items() - 1 do
		local current_region = province_regions:item_at(i)
		if current_region:owning_faction() == gifted_faction and current_region:name() ~= region:name() then
			num_owned_regions_in_province = num_owned_regions_in_province + 1
		end
	end
	local max_num_settlements_owned_for_bonus = #self.config.diplomatic_bonus.num_other_owned_settlements_in_same_province
	local other_settlements_owned_in_same_province_bonus = num_owned_regions_in_province ~= 0 and self.config.diplomatic_bonus.num_other_owned_settlements_in_same_province[math.round(math.clamp(num_owned_regions_in_province, 0, max_num_settlements_owned_for_bonus))] or 0
	total_bonus_value = total_bonus_value + other_settlements_owned_in_same_province_bonus

	local owns_regions_in_adjacent_provinces = false
	local adjacent_provinces = province:adjacent_provinces()
	for i = 0, adjacent_provinces:num_items() - 1 do
		local adjacent_province_regions = adjacent_provinces:item_at(i):regions()
		for j = 0, adjacent_province_regions:num_items() - 1 do
			if adjacent_province_regions:item_at(j):owning_faction() == gifted_faction then
				owns_regions_in_adjacent_provinces = true
				break
			end
		end

		if owns_regions_in_adjacent_provinces then
			break
		end
	end
	local other_settlements_owned_in_adjacent_provinces_bonus = owns_regions_in_adjacent_provinces and self.config.diplomatic_bonus.num_other_owned_settlements_in_neighbouring_provinces[1] or self.config.diplomatic_bonus.num_other_owned_settlements_in_neighbouring_provinces[0]
	total_bonus_value = total_bonus_value + other_settlements_owned_in_adjacent_provinces_bonus

	local diplomatic_bonus_and_factors = {
		major_settlement_bonus = major_settlement_bonus,
		climate_suitability_bonus = climate_suitability_bonus,
		other_settlements_owned_in_same_province_bonus = other_settlements_owned_in_same_province_bonus,
		other_settlements_owned_in_adjacent_provinces_bonus = other_settlements_owned_in_adjacent_provinces_bonus,
		total_bonus_value = total_bonus_value
	}

	return diplomatic_bonus_and_factors
end

function asur_domination:get_diplomatic_bonus_effect_bundle_key_towards_faction(faction_key)
	return self.config.diplomatic_bonus.effect_bundle_key_prefix .. faction_key
end

function asur_domination:get_diplomatic_bonus_effect_key_towards_faction(faction_key)
	return self.config.diplomatic_bonus.effect_key_prefix .. faction_key
end

function asur_domination:get_diplomatic_bonus_towards_faction(faction_key)
	local faction = cm:get_faction(self.config.aislinn_faction_key)
	local effect_bundle_key = self:get_diplomatic_bonus_effect_bundle_key_towards_faction(faction_key)
	local effect_key = self:get_diplomatic_bonus_effect_key_towards_faction(faction_key)

	local effect_bundle = faction:get_effect_bundle(effect_bundle_key)
	if effect_bundle and not effect_bundle:is_null_interface() then
		for i = 0, effect_bundle:effects():num_items() - 1 do
			local effect = effect_bundle:effects():item_at(i)
			if effect:key() == effect_key then
				return effect:value()
			end
		end
	end

	return 0
end

function asur_domination:apply_diplomatic_bonus_towards_faction(diplomatic_bonus, faction_key)
	-- to apply a diplomatic bonus (diplomatic relations bonus) for a faction A towards a specific faction B, we apply an effect_bundle to faction A, and that effect_bundle is linked with an effect hooked up to the "diplomatic_mod" bonus_value
	local faction = cm:get_faction(self.config.aislinn_faction_key)
	local effect_bundle_key = self:get_diplomatic_bonus_effect_bundle_key_towards_faction(faction_key)
	local effect_key = self:get_diplomatic_bonus_effect_key_towards_faction(faction_key)

	if faction:has_effect_bundle(effect_bundle_key) then
		cm:remove_effect_bundle(effect_bundle_key, faction:name())
	end

	local effect_bundle = cm:create_new_custom_effect_bundle(effect_bundle_key)
	if effect_bundle and not effect_bundle:is_null_interface() then
		local effects = effect_bundle:effects()
		for i = 0, effects:num_items() - 1 do
			local effect = effects:item_at(i)
			if effect:key() == effect_key then
				effect_bundle:set_effect_value(effect, diplomatic_bonus)
			end
		end

		effect_bundle:set_duration(0)
		cm:apply_custom_effect_bundle_to_faction(effect_bundle, faction)
	end
end

function asur_domination:set_diplomatic_bonus_script_objects(pb_region_interface)
	for _, faction_key in ipairs(self.config.giftable_factions) do
		-- calculate and show the diplomatic bonus received by Aislinn towards a faction, upon gifting a settlement
		local script_object_id = "aislinn_diplomatic_bonus_value;" .. faction_key
		local diplomatic_bonus_and_factors = self:calculate_diplomatic_bonus_towards_faction_by_gifting_region(faction_key, pb_region_interface)
		common.set_context_value(script_object_id, diplomatic_bonus_and_factors)
	end
end

function asur_domination:add_listeners()

	core:add_listener(
		"RitualCompletedEventForRitualCooldown_AsurDomination",
		"RitualCompletedEvent",
		true,
		function(context)
			local faction_name = context:performing_faction():name()
			if faction_name ~= self.config.aislinn_faction_key or context:ritual():ritual_category() ~= self.config.rituals_category_key then
				return
			end

			local category_cooldown = context:performing_faction():rituals():ritual_category_cooldown(self.config.rituals_category_key)
			asur_domination.saved_data.ritual_category_cooldown_end_turn = cm:turn_number() + category_cooldown
		end,
		true
	)

	core:add_listener(
		"FactionTurnStartForRitualCooldown_AsurDomination",
		"FactionTurnStart",
		true,
		function(context)
			local faction_name = context:faction():name()
			if faction_name ~= self.config.aislinn_faction_key then
				return
			end

			if asur_domination.saved_data.ritual_category_cooldown_end_turn ~= cm:turn_number() then
				return
			end

			cm:show_message_event(
				faction_name,
				self.config.dilemma_available_event_config.title,
				self.config.dilemma_available_event_config.primary_detail,
				self.config.dilemma_available_event_config.secondary_detail,
				self.config.dilemma_available_event_config.is_persistent,
				self.config.dilemma_available_event_config.campaign_group_member_criteria_value
			)
		end,
		true
	)

	core:add_listener(
		"PendingBattle_AsurDomination",
		"PendingBattle",
		true,
		function(context)
			local pending_battle = context:pending_battle()
			if pending_battle:siege_battle() and pending_battle:has_attacker() and pending_battle:attacker():faction():name() == self.config.aislinn_faction_key then
				local region = pending_battle:region_data():region()
				self:set_diplomatic_bonus_script_objects(region)
			end
		end,
		true
	)

	core:add_listener(
		"CharacterPerformsSettlementOccupationDecision_AsurDomination",
		"CharacterPerformsSettlementOccupationDecision",
		true,
		function(context)
			local faction = context:character():faction()
			if faction:name() ~= self.config.aislinn_faction_key or context:occupation_decision_type() ~= self.config.occupation_decision then
				return
			end

			local region = context:garrison_residence():region()

			-- build appropriate building in foreign slot if we used gift option
			local occupation_decision_id = context:occupation_decision()
			local decision_data = self.config.occupation_option_key_to_resource_factor_and_foreign_slot_building[occupation_decision_id]

			if decision_data then
				local region_key = region:name()
				-- establish foreign slot
				if self.config.foreign_slot_set_key_overrides[region_key] then
					cm:add_foreign_slot_set_to_region_for_faction(faction:command_queue_index(), region:cqi(), self.config.foreign_slot_set_key_overrides[region_key])
				else
					cm:add_foreign_slot_set_to_region_for_faction(faction:command_queue_index(), region:cqi(), decision_data.foreign_slot_set_key)
				end
				cm:foreign_slot_instantly_upgrade_building(region:foreign_slot_manager_for_faction(self.config.aislinn_faction_key):slots():item_at(2), decision_data.foreign_slot_building_to_grant)
			end

			-- grant diplomatic bonus with faction we gifted to
			local gifted_faction_key = region:owning_faction():name()
			if table.contains(self.config.giftable_factions, gifted_faction_key) == false then
				return
			end
			local current_diplomatic_bonus = self:get_diplomatic_bonus_towards_faction(gifted_faction_key)
			local diplomatic_bonus_and_factors = self:calculate_diplomatic_bonus_towards_faction_by_gifting_region(gifted_faction_key, region)
			local new_diplomatic_bonus_towards_faction = current_diplomatic_bonus + diplomatic_bonus_and_factors.total_bonus_value
			self:apply_diplomatic_bonus_towards_faction(new_diplomatic_bonus_towards_faction, gifted_faction_key)
		end,
		true
	)

	core:add_listener(
		"PooledResourceThresholdOperationReached_AsurDomination",
		"PooledResourceThresholdOperationReached",
		true,
		function(context)
			local threshold = context:pooled_threshold_operation_record();

			local subtype = self.config.dragonship_admirals_threshold_setup[threshold];
			asur_domination:spawn_dragonship_in_pool(subtype);

			local colony = self.config.elven_colony_threshold_unlocks[threshold];
			if colony ~= nil then
				cm:faction_add_pooled_resource(self.config.aislinn_faction_key, colony.resource, colony.factor, colony.amount);
			end
		end,
		true
	);
	
	core:add_listener(
		"FactionInitiativeActivationChangedEvent_AsurDomination",
		"FactionInitiativeActivationChangedEvent",
		function(context)
			return context:active() == true;
		end,
		function(context)
			local initiative = context:initiative():record_key();

			for i = 1, #self.config.dragonship_building_locks do
				if self.config.dragonship_building_locks[i].unlock == initiative then
					cm:remove_event_restricted_building_record_for_faction(self.config.dragonship_building_locks[i].building, self.config.aislinn_faction_key);
				end
			end
			for i = 1, #self.config.outpost_building_locks do
				if self.config.outpost_building_locks[i].unlock == initiative then
					cm:remove_event_restricted_building_record_for_faction(self.config.outpost_building_locks[i].building, self.config.aislinn_faction_key);
				end
			end
			for i = 1, #self.config.colony_building_locks do
				if self.config.colony_building_locks[i].unlock == initiative then
					cm:remove_event_restricted_building_record_for_faction(self.config.colony_building_locks[i].building, self.config.aislinn_faction_key);
				end
			end
			
			for i = 1, #self.config.elven_colony_initiative_unlocks do
				if self.config.elven_colony_initiative_unlocks[i].unlock == initiative then
					cm:faction_add_pooled_resource(self.config.aislinn_faction_key, self.config.elven_colony_initiative_unlocks[i].resource, self.config.elven_colony_initiative_unlocks[i].factor, self.config.elven_colony_initiative_unlocks[i].amount);
				end
			end

			local dragonship_lord = self.config.dragonship_admirals_initiative_setup[initiative];
			if dragonship_lord then 
				asur_domination:spawn_dragonship_in_pool(dragonship_lord);
			end
		end,
		true
	);

	core:add_listener(
		"RegionFactionChangeEvent_ElvenColonies",
		"RegionFactionChangeEvent",
		function(context)
			return context:previous_faction():name() == self.config.aislinn_faction_key and (context:region():settlement():primary_building_chain() == "wh3_dlc27_hef_colony_settlement_major" or context:region():settlement():primary_building_chain() == "wh3_dlc27_hef_colony_settlement_minor");			 
		end,
		function(context)
			cm:faction_add_pooled_resource(self.config.aislinn_faction_key,"wh3_dlc27_hef_elven_colonies","elven_colonies_refund",1)
		end,
		true
	);

	core:add_listener(
		"AsurDomination_CheatListener",
		"ContextTriggerEvent",
		true,
		function(context)
			if not context.string:starts_with("asur_domination") then
				return
			end

			local params = context.string:split(":")
			local cheat = params[2]
			if cheat == "force_unlock" then
				self:unlock_feature()
			end
		end,
		true
	)

	core:add_listener(
		"PooledResourceChanged_AsurDomination",
		"PooledResourceChanged",
		true,
		function(context)
			if cm:ui_overriden(self.config.button_ui_override_key) == false then
				return
			end

			local resource_manager = context:resource():manager()
			if resource_manager:has_owning_faction() == false or resource_manager:owning_faction():name() ~= self.config.aislinn_faction_key then
				return
			end

			local resource = context:resource()
			if resource:key() == self.config.focus_pooled_resource_key and resource:value() >= self.config.feature_unlock_minimum_focus_resource then
				self:unlock_feature()
			end

			if string.find(resource:key(), "wh3_dlc27_hef_aislinn_gift_") and resource:value() >= self.config.feature_unlock_minimum_settlements_gifted then
				self:unlock_feature()
			end
		end,
		true
	);
end

function asur_domination:spawn_dragonship_in_pool(subtype)
	if subtype ~= nil then
		local names_table = asur_domination.saved_data.dragonship_names_setup
		local surname_index = cm:random_number(#names_table.surname, 1)
		local surname = names_table.surname[surname_index]
		local forename_index = cm:random_number(#names_table.forename, 1)
		local forename = names_table.forename[forename_index]
		local char_art_index = cm:random_number(#names_table.char_art, 1)
		local char_art = names_table.char_art[char_art_index]

		cm:spawn_character_to_pool(self.config.aislinn_faction_key, forename, surname, "", "", 50, true, "general", subtype, true, char_art)
		core:trigger_event("ScriptEventNewDragonShipUnlocked")

		-- removing the names so they can't be picked up again in this campaign.
		table.remove(names_table.forename, forename_index)
		table.remove(names_table.surname, surname_index)
		table.remove(names_table.char_art, char_art_index)
	end
end

function asur_domination:unlock_feature()
	cm:override_ui(self.config.button_ui_override_key, false)
end

function asur_domination:set_aislinn_diplomacy_restrictions()
	cm:force_diplomacy("faction:"..self.config.aislinn_faction_key, "all", "regions", false, false)
	if cm:has_local_faction() and cm:get_local_faction_name(true) == self.config.aislinn_faction_key then
		-- Region trading is always shown in the UI so that the player can read its tooltip, explaining the rules for it.
		-- However, when script disabled, those do not matter, as the diplomatic action will always be disabled. Hence, hide it.
		uim:override("hide_diplomacy_region_trading"):set_allowed(false)
	end
end

cm:add_first_tick_callback(
	function()
		local pb = cm:model():pending_battle()
		if pb:is_null_interface() == false and 
			pb:siege_battle() and 
			pb:has_attacker() and 
			pb:attacker():faction():name() == asur_domination.config.aislinn_faction_key 
		then
			local region = pb:region_data():region()
			asur_domination:set_diplomatic_bonus_script_objects(region)
		end
	end
)

cm:add_post_first_tick_callback(
	function()
		local aislinn_faction = cm:get_faction(asur_domination.config.aislinn_faction_key)
		if aislinn_faction then
			for threshold, subtype in dpairs(asur_domination.config.dragonship_admirals_threshold_setup) do
				cm:set_script_state(aislinn_faction, threshold, subtype)
				-- we add this to shared state so we can check which threshold is needed to unlock the subtype :/
				cm:set_script_state(aislinn_faction, subtype, threshold)
			end

			for initiative, subtype in dpairs(asur_domination.config.dragonship_admirals_initiative_setup) do
				-- we add this to shared state so we can check which initiative is needed to unlock the subtype :/
				cm:set_script_state(aislinn_faction, subtype, initiative)
			end
		end
	end
)

--------------------- SAVE/LOAD ---------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("asur_domination_saved_data", asur_domination.saved_data, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			asur_domination.saved_data = cm:load_named_value("asur_domination_saved_data", asur_domination.saved_data, context)
		end
	end
)