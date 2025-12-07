local random_cults_per_daemon = 2;
local faction_to_cult = {
	["wh3_main_kho_exiles_of_khorne"] = {
		cult = "wh3_main_slot_set_kho_cult",
		bonus_value = "khorne_cult_adjacent_region_expansion_chance"
	},
	["wh3_dlc26_kho_arbaal"] = {
		cult = "wh3_main_slot_set_kho_cult",
		bonus_value = "khorne_cult_adjacent_region_expansion_chance"
	},
	["wh3_dlc26_kho_skulltaker"] = {
		cult = "wh3_main_slot_set_kho_cult",
		bonus_value = "khorne_cult_adjacent_region_expansion_chance"
	},
	["wh3_main_tze_oracles_of_tzeentch"] = {
		cult = "wh3_main_slot_set_tze_cult",
		bonus_value = "tzeentch_cult_adjacent_region_expansion_chance"
	},
	["wh3_main_sla_seducers_of_slaanesh"] = {
		cult = "wh3_main_slot_set_sla_cult",
		bonus_value = "slaanesh_cult_adjacent_region_expansion_chance"
	},
	["wh3_main_nur_poxmakers_of_nurgle"] = {
		cult = "wh3_main_slot_set_nur_cult",
		bonus_value = "nurgle_cult_adjacent_region_expansion_chance"
	},
	["wh3_dlc25_nur_epidemius"] = {
		cult = "wh3_main_slot_set_nur_cult",
		bonus_value = "nurgle_cult_adjacent_region_expansion_chance"
	},
	["wh3_dlc25_nur_tamurkhan"] = {
		cult = "wh3_main_slot_set_nur_cult",
		bonus_value = "nurgle_cult_adjacent_region_expansion_chance"
	},
	["wh3_dlc27_sla_the_tormentors"] = {
		cult = "wh3_dlc27_slot_set_sla_cult_dechala",
		bonus_value = "slaanesh_cult_adjacent_region_expansion_chance"
	},
	["wh3_dlc27_sla_masque_of_slaanesh"] = {
		cult = "wh3_main_slot_set_sla_cult",
		bonus_value = "slaanesh_cult_adjacent_region_expansion_chance"
	}

};
local buildings_that_destroy_cult = {
	["wh3_main_kho_cult_4"] = true,
	["wh3_main_kho_cult_special"] = true,
	["wh3_main_kho_cult_teleport"] = true,
	["wh3_main_nur_cult_4"] = true,
	["wh3_main_nur_cult_special"] = true,
	["wh3_main_nur_cult_teleport"] = true,
	["wh3_main_sla_cult_4"] = true,
	["wh3_main_sla_cult_special"] = true,
	["wh3_main_sla_cult_teleport"] = true,
	["wh3_main_tze_cult_4"] = true,
	["wh3_main_tze_cult_special"] = true,
	["wh3_main_tze_cult_teleport"] = true,
	["wh3_dlc27_sla_dechala_cult_teleport"] = true,
	["wh3_dlc27_sla_cult_special_masque"] = true,
	["wh3_dlc27_sla_dechala_cult_special"] = true
};

function setup_daemon_cults()
	out("#### Adding Daemon Cults Listeners ####");
	if cm:is_new_game() == true then
		local kho = cm:get_faction("wh3_main_kho_exiles_of_khorne");
		local tze = cm:get_faction("wh3_main_tze_oracles_of_tzeentch");
		local sla = cm:get_faction("wh3_main_sla_seducers_of_slaanesh");
		local nur = cm:get_faction("wh3_main_nur_poxmakers_of_nurgle");

		-- Spawn a number of Chaos Cults for AI factions
		if kho and kho:is_null_interface() == false and kho:is_human() == false then
			cult_spawn_random_cults(kho, "wh3_main_slot_set_kho_cult", random_cults_per_daemon, true, false);
		end
		if tze and tze:is_null_interface() == false and tze:is_human() == false then
			cult_spawn_random_cults(tze, "wh3_main_slot_set_tze_cult", random_cults_per_daemon, true, false);
		end
		if sla and sla:is_null_interface() == false and sla:is_human() == false then
			cult_spawn_random_cults(sla, "wh3_main_slot_set_sla_cult", random_cults_per_daemon, true, false);
		end
		if nur and nur:is_null_interface() == false and nur:is_human() == false then
			cult_spawn_random_cults(nur, "wh3_main_slot_set_nur_cult", random_cults_per_daemon, true, false);
		end
	end
	
	-- Functionality for Cult buildings upon their construction
	core:add_listener(
		"ChaosCults_ForeignSlotBuildingCompleteEvent",
		"ForeignSlotBuildingCompleteEvent",
		true,
		function(context)
			local building_key = context:building();
			local slot_manager = context:slot_manager();
			local faction = slot_manager:faction();
			local faction_key = faction:name();

			-- KHORNE
			if building_key == "wh3_main_kho_cult_4" then
				cult_replenish_all_units(faction_key);
				cult_declare_random_war(faction_key);

			-- KHORNE MAGUS
			elseif building_key == "wh3_main_kho_cult_special" then
				cm:treasury_mod(faction_key, 5000);
				cm:faction_add_pooled_resource(faction_key, "wh3_main_kho_skulls", "cults", 1000);
				cult_declare_random_war(faction_key);

			-- TZEENTCH
			elseif building_key == "wh3_main_tze_cult_4" then
				cm:faction_add_pooled_resource(faction_key, "wh3_main_tze_grimoires", "cults", 500);

			-- TZEENTCH MAGUS
			elseif building_key == "wh3_main_tze_cult_special" then
				cult_spawn_random_cults(faction, "wh3_main_slot_set_tze_cult", 3, false, true);

			-- SLAANESH MAGUS
			elseif building_key == "wh3_main_sla_cult_special" then
				local region = slot_manager:region();
				local region_owner = region:owning_faction():name();
				cm:treasury_mod(region_owner, 5000);
				cm:faction_add_pooled_resource(region_owner, "wh3_main_sla_seductive_influence", "cults", 200);
			elseif building_key == "wh3_main_cult_magus_trial_2" then
				-- Spawn Cult Magus depending on Culture
				local region_key = slot_manager:region():name();
				local culture = faction:culture();

				local spawn_coord_x, spawn_coord_y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, region_key, false, true, 4);

				if culture == "wh3_main_kho_khorne" then
					cm:spawn_agent_at_position(faction, spawn_coord_x, spawn_coord_y, "runesmith", "wh3_main_kho_cult_magus");
				elseif culture == "wh3_main_nur_nurgle" then
					cm:spawn_agent_at_position(faction, spawn_coord_x, spawn_coord_y, "dignitary", "wh3_main_nur_cult_magus");
				elseif culture == "wh3_main_sla_slaanesh" then
					cm:spawn_agent_at_position(faction, spawn_coord_x, spawn_coord_y, "dignitary", "wh3_main_sla_cult_magus");
				elseif culture == "wh3_main_tze_tzeentch" then
					cm:spawn_agent_at_position(faction, spawn_coord_x, spawn_coord_y, "dignitary", "wh3_main_tze_cult_magus");
				end
				
				-- Destroy the building
				local slot_list = slot_manager:slots();

				for i = 0, slot_list:num_items() - 1 do
					local slot = slot_list:item_at(i);

					if slot:is_null_interface() == false and slot:has_building() == true then
						if slot:building() == "wh3_main_cult_magus_trial_2" then
							cm:foreign_slot_instantly_dismantle_building(slot);
							break;
						end
					end
				end
			end
		end,
		true
	);

	-- This function handles spreading of Cults from building effects based on the presence of bonus values
	core:add_listener(
		"ChaosCults_FactionTurnStart",
		"FactionTurnStart",
		function(context)
			-- If the faction is in this table they have an associated Cult
			return faction_to_cult[context:faction():name()] ~= nil;
		end,
		function(context)
			local faction = context:faction();
			local faction_key = context:faction():name();
			local cults = faction:foreign_slot_managers();

			for cult_index = 0, cults:num_items() - 1 do
				local cult = cults:item_at(cult_index);
				local region = cult:region();
				local region_name = cult:region():name()
				cm:make_region_visible_in_shroud(faction_key, region_name)

				-- Demolish Cult Effect
				local slots = cult:slots();
				local slots_removed = false;

				for j = 0, slots:num_items() - 1 do
					local building_slot = slots:item_at(j);

					if building_slot:has_building() then
						local building_key = building_slot:building();
						
						if buildings_that_destroy_cult[building_key] == true then
							cm:remove_faction_foreign_slots_from_region(faction:command_queue_index(), region:cqi());
							slots_removed = true;
							break;
						end
					end
				end
				
				if slots_removed == false then
					-- Cult Spread Effect
					local bonus_value = faction_to_cult[faction_key].bonus_value;
					local expand_chance = cm:get_regions_bonus_value(region, bonus_value);
						
					if expand_chance > 0 then
						if cm:model():random_percent(expand_chance) then
							local adjacent_region_list = region:adjacent_region_list();
							
							for adjacent_region_index = 0, adjacent_region_list:num_items() - 1 do
								local possible_region = adjacent_region_list:item_at(adjacent_region_index);
								local possible_region_key = possible_region:name();
								
								if possible_region:is_null_interface() == false and possible_region:is_abandoned() == false and possible_region:owning_faction():is_null_interface() == false and possible_region:owning_faction():name() ~= faction_key then
									local slot_manager = possible_region:foreign_slot_manager_for_faction(faction_key);
									
									if slot_manager:is_null_interface() == true then
										local region_cqi = possible_region:cqi()
										cm:add_foreign_slot_set_to_region_for_faction(faction:command_queue_index(), region_cqi, faction_to_cult[faction_key].cult);
										cm:make_region_visible_in_shroud(faction_key, possible_region_key);
										
										-- Tell the Cult owner
										if faction:is_human() then
											cm:trigger_incident_with_targets(faction:command_queue_index(), "wh3_main_incident_cult_created", 0, 0, 0, 0, possible_region:cqi(), possible_region:settlement():cqi());
										end
										break;
									end
								end
							end
						end
					end
				end
			end
		end,
		true
	);
end

function cult_spawn_random_cults(faction, cult_type, spawn_amount, home_adjacent, delay_tick)
	local valid_adjacent = {};
	local possible_regions = weighted_list:new();
	local region_list = cm:model():world():region_manager():region_list();
	local home = faction:home_region();

	if home_adjacent == true then
		local adjacent_regions = home:adjacent_region_list();
		
		for i = 0, adjacent_regions:num_items() - 1 do
			local adj_region = adjacent_regions:item_at(i);
			valid_adjacent[adj_region:name()] = true;

			local secondary_adjacent_regions = adj_region:adjacent_region_list();
				
			for j = 0, secondary_adjacent_regions:num_items() - 1 do
				local secondary_adj_region = secondary_adjacent_regions:item_at(j);
				valid_adjacent[secondary_adj_region:name()] = true;
			end
		end
	end

	for i = 0, region_list:num_items() - 1 do
		local current_region = region_list:item_at(i);
		
		if current_region:is_null_interface() == false and home:is_null_interface() == false and faction:is_null_interface() == false then
			if current_region:is_abandoned() == false and current_region:name() ~= home:name() and current_region:foreign_slot_manager_for_faction(faction:name()):is_null_interface() then
				if current_region:owning_faction():name() ~= faction:name() then
					local weight = 2;

					-- Prefer regions of enemy factions
					if current_region:owning_faction():at_war_with(faction) then
						weight = weight + 3;
					end
					-- Prefer regions with no other foreign slots
					if current_region:foreign_slot_managers():is_empty() then
						weight = weight + 2;
					end
					-- Slight avoidance of regions of allies
					if current_region:owning_faction():allied_with(faction) then
						weight = weight - 1;
					end

					if home_adjacent == true then
						if valid_adjacent[current_region:name()] == true then
							weight = weight + 50;
						else
							weight = 0;
						end
					end

					if weight > 0 then
						possible_regions:add_item(current_region, weight);
					end
				end
			end
		end
	end
	
	if #possible_regions.items > 0 then
		for i = 1, spawn_amount do
			local region, index = possible_regions:weighted_select();

			if delay_tick == true then
				cm:callback(function() 
					cm:add_foreign_slot_set_to_region_for_faction(faction:command_queue_index(), region:cqi(), cult_type);
					cm:trigger_incident_with_targets(faction:command_queue_index(), "wh3_main_incident_cult_created", 0, 0, 0, 0, region:cqi(), region:settlement():cqi());
					out("Created Cult of type "..cult_type.." in "..region:name().." for "..faction:name());
				end, 0.1);
			else
				cm:add_foreign_slot_set_to_region_for_faction(faction:command_queue_index(), region:cqi(), cult_type);
				cm:trigger_incident_with_targets(faction:command_queue_index(), "wh3_main_incident_cult_created", 0, 0, 0, 0, region:cqi(), region:settlement():cqi());
				out("Created Cult of type "..cult_type.." in "..region:name().." for "..faction:name());
			end

			possible_regions:remove_item(index);

			if #possible_regions.items == 0 then
				break;
			end
		end
	end
end

function cult_declare_random_war(faction_key)
	local faction = cm:get_faction(faction_key);

	if faction:is_null_interface() == false then
		local met_factions = faction:factions_met();
		local valid_met_factions = cult_valid_faction_war_table(faction, met_factions);

		if #valid_met_factions > 0 then
			local rand = cm:random_number(#valid_met_factions);
			local pick = valid_met_factions[rand];
			cm:force_declare_war(faction_key, pick, false, false);
		else
			local all_factions = cm:model():world():faction_list();
			local valid_factions = cult_valid_faction_war_table(faction, all_factions);

			if #valid_factions > 0 then
				local rand = cm:random_number(#valid_factions);
				local pick = valid_factions[rand];
				cm:force_declare_war(faction_key, pick, false, false);
			end
		end
	end
end

function cult_valid_faction_war_table(cult_faction, faction_list)
	local return_table = {};

	for i = 0, faction_list:num_items() - 1 do
		local faction = faction_list:item_at(i);
		
		-- Exclude the players own faction and factions with no forces and factions already at war with
		if faction:name() ~= cult_faction:name() and faction:at_war_with(cult_faction) == false and faction:military_force_list():num_items() > 0 then
			table.insert(return_table, faction:name());
		end
	end
	return return_table;
end

function cult_replenish_all_units(faction_key)
	local faction = cm:get_faction(faction_key);

	if faction:is_null_interface() == false then
		local military_force_list = faction:military_force_list();
		
		for i = 0, military_force_list:num_items() - 1 do
			local military_force = military_force_list:item_at(i);
			local unit_list = military_force:unit_list();
			
			for j = 0, unit_list:num_items() - 1 do
				local unit = unit_list:item_at(j);
				cm:set_unit_hp_to_unary_of_maximum(unit, 1);
			end
		end
	end
end