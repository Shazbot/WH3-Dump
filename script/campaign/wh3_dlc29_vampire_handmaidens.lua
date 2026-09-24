vampire_handmaidens = {
	neferata_faction = "wh3_dlc29_vmp_neferata",
	handmaiden_data = {
		type = "engineer",
		subtype = "wh3_dlc29_vmp_handmaiden",
		unique_subtype = "wh3_dlc29_vmp_handmaiden_imentet"
	},
	handmaiden_spawn_techs = {
		["wh3_dlc29_tech_nef_handmaidens_2a"] = {forename = "names_name_28557797", trait = "wh3_trait_dlc29_lycindia_1"},
		["wh3_dlc29_tech_nef_handmaidens_2b"] = {forename = "names_name_882258359", trait = "wh3_trait_dlc29_giselle_1"},
		["wh3_dlc29_tech_nef_handmaidens_2c"] = {forename = "names_name_806142098", trait = "wh3_trait_dlc29_heterneb_1"},
		["wh3_dlc29_tech_nef_handmaidens_2d"] = {forename = "names_name_154796179", trait = "wh3_trait_dlc29_bellatash_1"},
		["wh3_dlc29_tech_nef_handmaidens_2e"] = {forename = "names_name_872953000", trait = "wh3_trait_dlc29_naaima_1"}
	},
	handmaiden_upgrade_techs = {
		["wh3_dlc29_tech_nef_imentet_2"] = {old_trait = "wh3_trait_dlc29_imentet_1", new_trait = "wh3_trait_dlc29_imentet_2", remove_old_trait = false, forename_change = "names_name_380461502"},
		["wh3_dlc29_tech_nef_handmaidens_3a"] = {old_trait = "wh3_trait_dlc29_lycindia_1", new_trait = "wh3_trait_dlc29_lycindia_2", remove_old_trait = false, forename_change = ""},
		["wh3_dlc29_tech_nef_handmaidens_3b"] = {old_trait = "wh3_trait_dlc29_giselle_1", new_trait = "wh3_trait_dlc29_giselle_2", remove_old_trait = false, forename_change = ""},
		["wh3_dlc29_tech_nef_handmaidens_3c"] = {old_trait = "wh3_trait_dlc29_heterneb_1", new_trait = "wh3_trait_dlc29_heterneb_2", remove_old_trait = false, forename_change = ""},
		["wh3_dlc29_tech_nef_handmaidens_3d"] = {old_trait = "wh3_trait_dlc29_bellatash_1", new_trait = "wh3_trait_dlc29_bellatash_2", remove_old_trait = false, forename_change = ""},
		["wh3_dlc29_tech_nef_handmaidens_3e"] = {old_trait = "wh3_trait_dlc29_naaima_1", new_trait = "wh3_trait_dlc29_naaima_2", remove_old_trait = false, forename_change = ""}
	},
	handmaiden_trait_techs = {
		{technology = "wh3_dlc29_tech_nef_covens_2a", trait = "wh3_trait_dlc29_handmaiden_upgrade_1"},
		{technology = "wh3_dlc29_tech_nef_covens_2c", trait = "wh3_trait_dlc29_handmaiden_upgrade_2"},
		{technology = "wh3_dlc29_tech_nef_covens_2d", trait = "wh3_trait_dlc29_handmaiden_upgrade_3"}
	},
	building_locks = {
		--{building = "wh3_dlc29_nef_coven_handmaiden_escape_1", lock_reason = "covens_building_lock_covens_2b"},
		{building = "wh3_dlc29_nef_coven_handmaiden_training_1", lock_reason = "covens_building_lock_covens_1"},
		{building = "wh3_dlc29_nef_coven_handmaiden_training_2", lock_reason = "covens_building_lock_covens_3"}
	},
	building_unlocks = {
		--["wh3_dlc29_tech_nef_covens_2b"] = {building = "wh3_dlc29_nef_coven_handmaiden_escape_1"},
		["wh3_dlc29_tech_nef_covens_1"] = {building = "wh3_dlc29_nef_coven_handmaiden_training_1"},
		["wh3_dlc29_tech_nef_covens_3"] = {building = "wh3_dlc29_nef_coven_handmaiden_training_2"}
	},
	tomb_king_units = {
		building = "wh3_main_vmp_special_lahmia_temple_of_blood",
		reason = "neferata_tomb_king_lock_reason",
		units = {
			"wh2_dlc09_tmb_inf_tomb_guard_0",
			"wh2_dlc09_tmb_inf_tomb_guard_1",
			"wh2_dlc09_tmb_mon_necrosphinx_0",
			"wh2_dlc09_tmb_mon_tomb_scorpion_0",
			"wh2_dlc09_tmb_mon_sepulchral_stalkers_0",
			"wh2_dlc09_tmb_mon_ushabti_0"
		}
	},
	handmaiden_tracker = {}
};

function vampire_handmaidens:initialise()
	self:add_listeners();

	if cm:is_new_game() == true then
		for i = 1, #self.building_locks do
			cm:add_event_restricted_building_record_for_faction(self.building_locks[i].building, self.neferata_faction, self.building_locks[i].lock_reason);
		end
		for _, unit_key in ipairs(self.tomb_king_units.units) do
			cm:add_event_restricted_unit_record_for_faction(unit_key, self.neferata_faction, self.tomb_king_units.reason)
		end

		cm:force_diplomacy("faction:"..self.neferata_faction, "faction:wh2_dlc09_tmb_lybaras", "all", false, false, true);
	end
end

function vampire_handmaidens:spawn_unique_handmaiden(faction, forename, trait)
	if not faction or faction:is_null_interface() then
		return
	end

	local agent = nil;

	if faction:has_faction_leader() == true and faction:faction_leader():has_military_force() == true then
		local force = faction:faction_leader():military_force();
		agent = cm:spawn_agent_at_military_force(faction, force, self.handmaiden_data.type, self.handmaiden_data.subtype);
	elseif faction:has_home_region() == true then
		local home_region = faction:home_region()
		if home_region and home_region:is_null_interface() == false then
			local region_key = home_region:name()
			local x, y = cm:find_valid_spawn_location_for_character_from_settlement(faction:name(), region_key, false, true, 2)
			if x > -1 and y > -1 then
				agent = cm:spawn_agent_at_position(faction, x, y, self.handmaiden_data.type, self.handmaiden_data.subtype)
			end
		end
	else
		agent = cm:spawn_agent_at_position(faction, 850, 640, self.handmaiden_data.type, self.handmaiden_data.subtype);
	end

	if not agent or agent:is_null_interface() then
		return
	end

	local char_lookup = cm:char_lookup_str(agent);
	cm:replenish_action_points(char_lookup);
	cm:change_character_localised_name(agent, forename, "", "", "");
	cm:force_add_trait(char_lookup, trait, false);
	self:give_handmaiden_technology_traits(faction, agent);
end

function vampire_handmaidens:spawn_handmaiden(faction, x, y)
	local agent = cm:spawn_agent_at_position(faction, x, y, self.handmaiden_data.type, self.handmaiden_data.subtype);
	local char_lookup = cm:char_lookup_str(agent);
	cm:replenish_action_points(char_lookup);
	self:give_handmaiden_technology_traits(faction, agent);
	return agent;
end

function vampire_handmaidens:give_handmaiden_technology_traits(faction, agent)
	for i = 1, #self.handmaiden_trait_techs do
		if faction:has_technology(self.handmaiden_trait_techs[i].technology) == true then
			cm:force_add_trait(cm:char_lookup_str(agent), self.handmaiden_trait_techs[i].trait, false);
		end
	end
end

function vampire_handmaidens:give_all_handmaidens_trait(faction, new_trait)
	local character_list = faction:character_list();
	
	for i = 0, character_list:num_items() - 1 do
		local character = character_list:item_at(i);
		
		if character:character_subtype(self.handmaiden_data.subtype) or character:character_subtype(self.handmaiden_data.unique_subtype) then
			cm:force_add_trait(cm:char_lookup_str(character), new_trait, false);
		end
	end
end

function vampire_handmaidens:upgrade_handmaiden(faction, old_trait, new_trait, remove_old_trait, forename_change)
	local character_list = faction:character_list();
	
	for i = 0, character_list:num_items() - 1 do
		local character = character_list:item_at(i);
		
		if character:character_subtype(self.handmaiden_data.subtype) or character:character_subtype(self.handmaiden_data.unique_subtype) then
			if character:has_trait(old_trait) == true then
				if remove_old_trait == true then
					cm:force_remove_trait(cm:char_lookup_str(character), old_trait);
				end

				if new_trait ~= "" then
					cm:force_add_trait(cm:char_lookup_str(character), new_trait, false);
				end

				if forename_change ~= "" then
					cm:change_character_localised_name(character, forename_change, "", "", "");
				end
			end
		end
	end
end

function vampire_handmaidens:unlock_building(building_key)
	cm:remove_event_restricted_building_record_for_faction(building_key, self.neferata_faction);
end

function vampire_handmaidens:add_listeners()
	core:add_listener(
		"VampireHandmaidensTechnologyCompleted",
		"ResearchCompleted",
		function(context)
			return context:faction():name() == self.neferata_faction;
		end,
		function(context)
			local faction = context:faction();
			local tech_key = context:technology();
			
			if self.handmaiden_spawn_techs[tech_key] then
				self:spawn_unique_handmaiden(
					faction,
					self.handmaiden_spawn_techs[tech_key].forename,
					self.handmaiden_spawn_techs[tech_key].trait
				);
			end

			if self.handmaiden_upgrade_techs[tech_key] then
				self:upgrade_handmaiden(
					faction,
					self.handmaiden_upgrade_techs[tech_key].old_trait,
					self.handmaiden_upgrade_techs[tech_key].new_trait,
					self.handmaiden_upgrade_techs[tech_key].remove_old_trait,
					self.handmaiden_upgrade_techs[tech_key].forename_change
				);
			end

			for i = 1, #self.handmaiden_trait_techs do
				if self.handmaiden_trait_techs[i].technology == tech_key then
					self:give_all_handmaidens_trait(
						faction,
						self.handmaiden_trait_techs[i].trait
					);
				end
			end

			if self.building_unlocks[tech_key] then
				self:unlock_building(
					self.building_unlocks[tech_key].building
				);
			end
		end,
		true
	);
	core:add_listener(
		"BuildingCompletedNeferata",
		"BuildingCompleted",
		function(context)
			return context:building():name() == self.tomb_king_units.building;
		end,
		function(context)
			for _, unit_key in ipairs(self.tomb_king_units.units) do
				cm:remove_event_restricted_unit_record_for_faction(unit_key, self.neferata_faction)
			end
		end,
		true
	);
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("vampire_handmaidens_handmaiden_tracker", vampire_handmaidens.handmaiden_tracker, context);
	end
);
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			vampire_handmaidens.handmaiden_tracker = cm:load_named_value("vampire_handmaidens_handmaiden_tracker", vampire_handmaidens.handmaiden_tracker, context);
		end
	end
);