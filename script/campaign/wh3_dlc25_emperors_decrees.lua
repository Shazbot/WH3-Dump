emperors_decrees = {
	faction_key = "wh_main_emp_empire",
	fealty = {
		key = "emp_loyalty",
		factor = "wh3_dlc25_emperors_decrees"
	},
	upgrade_tech = "wh2_dlc13_tech_emp_elector_counts_1",
	rituals = {
		["wh3_dlc25_emperors_decrees_imperial_commendation"] = function(context) emperors_decrees:commendation(context:performing_faction(), context:ritual():ritual_target():get_target_force()) end,
		["wh3_dlc25_emperors_decrees_open_the_gates"] = function(context) emperors_decrees:open_the_gates(context:performing_faction(), context:ritual():ritual_target():get_target_region()) end,
		["wh3_dlc25_emperors_decrees_inquisition"] = function(context) emperors_decrees:inquisition(context:performing_faction(), context:ritual():ritual_target():get_target_region()) end,
		["wh3_dlc25_emperors_decrees_unify"] = function(context) emperors_decrees:unify(context:performing_faction(), context:ritual_target_faction()) end,
		["wh3_dlc25_emperors_decrees_requisition"] = function(context) emperors_decrees:requisition(context:performing_faction()) end,
		["wh3_dlc25_emperors_decrees_send_aid"] = function(context) emperors_decrees:send_aid(context:performing_faction(), context:ritual():ritual_target():get_target_region()) end,
		["wh3_dlc25_emperors_decrees_casus_belli"] = function(context) emperors_decrees:casus_belli(context:ritual_target_faction()) end
	},
	state_units = {
		"wh2_dlc13_emp_art_mortar_ror_0",
		"wh2_dlc13_emp_cav_empire_knights_ror_0",
		"wh2_dlc13_emp_cav_empire_knights_ror_1",
		"wh2_dlc13_emp_cav_empire_knights_ror_2",
		"wh2_dlc13_emp_cav_outriders_ror_0",
		"wh2_dlc13_emp_cav_pistoliers_ror_0",
		"wh2_dlc13_emp_inf_crossbowmen_ror_0",
		"wh2_dlc13_emp_inf_greatswords_ror_0",
		"wh2_dlc13_emp_inf_halberdiers_ror_0",
		"wh2_dlc13_emp_inf_handgunners_ror_0",
		"wh2_dlc13_emp_inf_spearmen_ror_0",
		"wh2_dlc13_emp_inf_swordsmen_ror_0",
		"wh2_dlc13_emp_veh_steam_tank_ror_0"
	}
}

function emperors_decrees:initialise()
	core:add_listener(
		"EmperorsDecreeRituals",
		"RitualCompletedEvent",
		function(context)
			local ritual_key = string.gsub(context:ritual():ritual_key(), "_upgraded", "")

			return self.rituals[ritual_key]
		end,
		function(context)
			local ritual_key = string.gsub(context:ritual():ritual_key(), "_upgraded", "")

			self.rituals[ritual_key](context)
		end,
		true
	)
end

function emperors_decrees:casus_belli(target_faction)
	-- allow a free war from the wh2_dlc13_empire_politics script
	empire_allow_free_war(self.faction_key)
	cm:force_declare_war(self.faction_key, target_faction:name(), false, false)
end

function emperors_decrees:unify(performing_faction, target_faction)
	local faction_name = target_faction:name()
	
	-- setting cofederation variable in wh2_dlc13_empire_polics to true 
	empire_set_elector_as_confederated(faction_name)
	cm:force_confederation(performing_faction:name(), faction_name)

	if performing_faction:has_technology(self.upgrade_tech) == false then
		empire_modify_all_elector_loyalty(self.fealty.factor, -2)
	end
end

function emperors_decrees:requisition(performing_faction)
	for _, state_troop in ipairs(self.state_units) do
		cm:add_units_to_faction_mercenary_pool(performing_faction:command_queue_index(), state_troop, 1);
	end
end

function emperors_decrees:send_aid(performing_faction, target_region)
	local region_name = target_region:name()
	local faction = target_region:owning_faction()
	local faction_name = faction:name()

	local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(faction_name, region_name, false, true, 10)

	local ram = random_army_manager
	ram:remove_force("emp_summoned_army")
	ram:new_force("emp_summoned_army")

	ram:add_unit("emp_summoned_army","wh_main_emp_inf_swordsmen",5)
	ram:add_unit("emp_summoned_army","wh_main_emp_inf_spearmen_0",4)
	ram:add_unit("emp_summoned_army","wh_main_emp_inf_spearmen_1",3)
	ram:add_unit("emp_summoned_army","wh_main_emp_inf_handgunners",2)
	ram:add_unit("emp_summoned_army","wh_main_emp_inf_crossbowmen",3)
	ram:add_unit("emp_summoned_army","wh_main_emp_cav_empire_knights",2)
	ram:add_unit("emp_summoned_army","wh_main_emp_cav_pistoliers_1",2)
	ram:add_unit("emp_summoned_army","wh_main_emp_art_mortar",2)

	local army_size

	if performing_faction:has_technology(self.upgrade_tech) then
		army_size = cm:random_number(15, 12)
	else
		army_size = cm:random_number(11, 8)
	end

	local unit_list = ram:generate_force("emp_summoned_army", army_size, false);

	cm:create_force_with_general(
		faction_name,
		unit_list,
		region_name,
		pos_x,
		pos_y,
		"general",
		"wh_main_emp_lord_spawned_army",
		"",
		"",
		"",
		"",
		false,
		function(cqi)
			cm:apply_effect_bundle_to_characters_force("wh3_dlc25_ritual_emp_temp_army", cqi, 0)
			cm:replenish_action_points(cm:char_lookup_str(cqi))
		end
	)

	cm:make_region_visible_in_shroud(self.faction_key, region_name)

	if faction:is_null_interface() == false and faction:pooled_resource_manager():resource(self.fealty.key):is_null_interface() == false then
		cm:faction_add_pooled_resource(faction_name, self.fealty.key, self.fealty.factor, 2)
	end
end

function emperors_decrees:commendation(performing_faction, target_force)
	local target_character = target_force:general_character()
	local xp = 2500

	if performing_faction:has_technology(self.upgrade_tech) then
		xp = 5000
	end

	cm:add_agent_experience(cm:char_lookup_str(target_character:command_queue_index()), xp)
end

function emperors_decrees:open_the_gates(performing_faction, target_region)
	local population = 1

	if performing_faction:has_technology(self.upgrade_tech) then
		population = 2
	end

	cm:add_development_points_to_region(target_region:name(), population)
end

function emperors_decrees:inquisition(performing_faction, target_region)
	local corruption_amount = 50

	if performing_faction:has_technology(self.upgrade_tech) then
		corruption_amount = 100
	end

	cm:change_corruption_in_province_by(target_region:province_name(), nil, corruption_amount, "local_populace")
end