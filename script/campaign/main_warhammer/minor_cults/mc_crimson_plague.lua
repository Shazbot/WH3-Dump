local minor_cult = {
	key = "",
	slot_key = "wh3_main_slot_set_minor_cult_28",
	intro_incident_key = "wh3_main_minor_cult_intro",
	effect_bundle = nil,
	valid_subcultures = {
		-- Good
		["wh2_main_sc_hef_high_elves"] = true,
		["wh2_main_sc_lzd_lizardmen"] = true,
		["wh3_main_sc_cth_cathay"] = true,
		["wh3_main_sc_ksl_kislev"] = true,
		["wh_dlc05_sc_wef_wood_elves"] = true,
		["wh_main_sc_brt_bretonnia"] = true,
		["wh_main_sc_dwf_dwarfs"] = true,
		["wh_main_sc_emp_empire"] = true,
		-- Neutral
		["wh2_dlc09_sc_tmb_tomb_kings"] = true,
		["wh2_dlc11_sc_cst_vampire_coast"] = true,
		["wh2_main_sc_def_dark_elves"] = true,
		["wh2_main_sc_skv_skaven"] = true,
		["wh3_main_sc_ogr_ogre_kingdoms"] = true,
		["wh_main_sc_grn_greenskins"] = true,
		["wh_main_sc_grn_savage_orcs"] = true,
		["wh_main_sc_vmp_vampire_counts"] = true,
		-- Chaos
		["wh3_dlc23_sc_chd_chaos_dwarfs"] = true,
		["wh3_main_sc_dae_daemons"] = true,
		["wh3_main_sc_kho_khorne"] = true,
		--["wh3_main_sc_nur_nurgle"] = true,
		["wh3_main_sc_sla_slaanesh"] = true,
		["wh3_main_sc_tze_tzeentch"] = true,
		["wh_dlc03_sc_bst_beastmen"] = true,
		["wh_dlc08_sc_nor_norsca"] = true,
		["wh_main_sc_chs_chaos"] = true
	},
	force_region = nil,
	valid_provinces = nil,
	valid_from_turn = 20,
	chance_if_valid = 4,
	complete_on_removal = true,
	event_data = {event_chance_per_turn = 100, event_cooldown = 0, event_limit = 999, event_initial_delay = 0, force_trigger = true},
	saved_data = {status = 0, region_key = "", event_cooldown = 0, event_triggers = 0}
};

local worldwide_plague_spawn_chance = 1; -- This chance is checked twice for worldwide plagues, so this is a 0.01% chance
local worldwide_plague_region_infection_chance = 50;
local faction_plague_spawn_chance = 1;
local faction_plague_region_infection_chance = 50;
local region_plague_spawn_chance = 5;

function minor_cult:creation_event(region_key, turn_number)
	local region = cm:get_region(region_key);
	cm:change_corruption_in_province_by(region:province_name(), "wh3_main_corruption_nurgle", 10, "events");
end

function minor_cult:custom_event(faction, region, cult_faction)
	local owned_regions = faction:region_list():num_items();
	local faction_cqi = faction:command_queue_index();
	local region_cqi = region:cqi();

	if owned_regions >= 3 then
		if cm:model():random_percent(worldwide_plague_spawn_chance) and cm:model():random_percent(worldwide_plague_spawn_chance) then
			-- WORLDWIDE
			self:worldwide_plague(region, cult_faction);
			cm:trigger_incident_with_targets(faction_cqi, "wh3_main_minor_cult_crimson_plague_3", 0, 0, 0, 0, region_cqi, 0);
			return true;
		elseif cm:model():random_percent(faction_plague_spawn_chance) then
			-- FACTION
			self:faction_plague(region, cult_faction);
			cm:trigger_incident_with_targets(faction_cqi, "wh3_main_minor_cult_crimson_plague_2", 0, 0, 0, 0, region_cqi, 0);
			return true;
		elseif cm:model():random_percent(region_plague_spawn_chance) then
			-- REGION
			self:region_plague(region, cult_faction);
			cm:trigger_incident_with_targets(faction_cqi, "wh3_main_minor_cult_crimson_plague_1", 0, 0, 0, 0, region_cqi, 0);
			return true;
		end
	end
	return false;
end

function minor_cult:worldwide_plague(region, cult_faction)
	local region_list = cm:model():world():region_manager():region_list();

	for r = 0, region_list:num_items() - 1 do
		local current_region = region_list:item_at(r);

		if current_region:is_abandoned() == false then
			if cm:model():random_percent(worldwide_plague_region_infection_chance) then
				cm:spawn_plague_at_settlement(cult_faction, current_region:settlement(), "wh3_main_crimson_plague_world");
			end
		end
	end
	out("Spawning Crimson Plague [WORLD]");

	local cult_cqi = cm:model():world():faction_by_key("wh3_main_rogue_minor_cults"):command_queue_index();
	local region_cqi = region:cqi();
	cm:remove_faction_foreign_slots_from_region(cult_cqi, region_cqi);
	self.saved_data.status = -1;
end

function minor_cult:faction_plague(region, cult_faction)
	local region_list = region:owning_faction():region_list();
	local infected_regions = 1;

	cm:spawn_plague_at_settlement(cult_faction, region():settlement(), "wh3_main_crimson_plague_faction");
	out("Spawning Crimson Plague [FACTION]");
	
	for r = 0, region_list:num_items() - 1 do
		local current_region = region_list:item_at(r);
		
		-- Capital is always infected manually
		if current_region:cqi() ~= region:owning_faction():home_region():cqi() then
			if infected_regions == 1 then
				-- Second region is always infected, else its not really a "factionwide" plague
				cm:spawn_plague_at_settlement(cult_faction, current_region:settlement(), "wh3_main_crimson_plague_faction");
				infected_regions = infected_regions + 1;
			elseif infected_regions == 2 then
				-- Third region is always protected so there is somewhere safe
				infected_regions = infected_regions + 1;
			elseif cm:model():random_percent(faction_plague_region_infection_chance) then
				-- Everywhere else we leave up to chance
				cm:spawn_plague_at_settlement(cult_faction, current_region:settlement(), "wh3_main_crimson_plague_faction");
				infected_regions = infected_regions + 1;
			end
		end
	end
end

function minor_cult:region_plague(region, cult_faction)
	cm:spawn_plague_at_settlement(cult_faction, region:settlement(), "wh3_main_crimson_plague_region");
	out("Spawning Crimson Plague [REGION]");
end

function minor_cult:is_valid()
	local debug_validity = true;

	if debug_validity == true then
		out("MINOR CULT - VALIDITY - "..self.key);
	end

	local turn_number = cm:model():turn_number();
	if turn_number < self.valid_from_turn then
		if debug_validity == true then
			out("\tFAIL - VALID TURN - Current:"..turn_number.." / Valid:"..self.valid_from_turn);
		end
		return nil;
	end

	local valid_region_list = weighted_list:new();

	if self.force_region ~= nil then
		if not MINOR_CULT_REGIONS[self.force_region] then
			local current_region = cm:get_region(self.force_region);

			if current_region:is_null_interface() == false and current_region:is_abandoned() == false then
				local owner = current_region:owning_faction();

				if owner:is_null_interface() == false and owner:is_human() == true and owner:is_factions_turn() == true then
					local current_subculture = owner:subculture();

					if self.valid_subcultures[current_subculture] ~= nil then
						valid_region_list:add_item(current_region, 1);
					elseif debug_validity == true then
						out("\tFAIL - FORCED REGION SUBCULTURE - "..current_subculture);
					end
				elseif debug_validity == true then
					out("\tFAIL - FORCED REGION OWNER AI/NOT TURN/NULL");
				end
			elseif debug_validity == true then
				out("\tFAIL - FORCED REGION RAZED/NULL");
			end
		elseif debug_validity == true then
			out("\tFAIL - FORCED REGION FULL - "..MINOR_CULT_REGIONS[self.force_region]);
		end
	else
		local region_list = cm:model():world():region_manager():region_list();

		for i = 0, region_list:num_items() - 1 do
			local current_region = region_list:item_at(i);
			
			if current_region:is_null_interface() == false and current_region:is_abandoned() == false then
				local owner = current_region:owning_faction();

				if owner:is_null_interface() == false and owner:is_human() == true and owner:is_factions_turn() == true then
					if self.valid_subcultures[owner:subculture()] ~= nil then
						local valid = true;

						if self.valid_provinces ~= nil then
							local province_key = current_region:province_name();
							if self.valid_provinces[province_key] == nil then
								valid = false;
							end
						end

						if MINOR_CULT_REGIONS[current_region:name()] then
							valid = false;
						end

						-- CUSTOM REQUIREMENTS START
						-- CUSTOM REQUIREMENTS END

						if valid == true then
							valid_region_list:add_item(current_region, 1);
						end
					end
				end
			end
		end
	end

	if #valid_region_list.items == 0 then
		if debug_validity == true then
			out("\tFAIL - NO REGIONS");
		end
		return nil;
	end

	if cm:model():random_percent(self.chance_if_valid) == false then
		if debug_validity == true then
			out("\tFAIL - CHANCE - Required:"..self.chance_if_valid);
		end
		return nil;
	end
	
	local region, index = valid_region_list:weighted_select();
	return region:name();
end

return minor_cult;