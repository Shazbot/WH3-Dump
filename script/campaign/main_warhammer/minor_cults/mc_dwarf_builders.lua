local minor_cult = {
	key = "",
	slot_key = "wh3_main_slot_set_minor_cult_23",
	intro_incident_key = "wh3_main_minor_cult_intro",
	effect_bundle = "wh3_main_minor_cult_dwarf_builders",
	valid_subcultures = {
		-- Good
		["wh2_main_sc_hef_high_elves"] = true,
		["wh2_main_sc_lzd_lizardmen"] = true,
		["wh3_main_sc_cth_cathay"] = true,
		["wh3_main_sc_ksl_kislev"] = true,
		["wh_dlc05_sc_wef_wood_elves"] = true,
		["wh_main_sc_brt_bretonnia"] = true,
		["wh_main_sc_dwf_dwarfs"] = true,
		["wh_main_sc_emp_empire"] = true
	},
	force_region = nil,
	valid_provinces = nil,
	valid_from_turn = 5,
	chance_if_valid = 5,
	complete_on_removal = true,
	event_data = {event_chance_per_turn = 100, event_cooldown = 0, event_limit = 999, event_initial_delay = 0, force_trigger = true},
	saved_data = {status = 0, region_key = "", event_cooldown = 0, event_triggers = 0}
};

function minor_cult:creation_event(region_key, turn_number)
	cm:set_saved_value("dwarf_builders_last_turn", turn_number);
end

function minor_cult:custom_event(faction, region, cult_faction)
	local last_built = cm:get_saved_value("dwarf_builders_last_turn") or 0;
	local turn_number = cm:turn_number();

	if (turn_number - last_built) >= 5 then
		local region_cqi = region:cqi();
		local cult_cqi = cm:model():world():faction_by_key("wh3_main_rogue_minor_cults"):command_queue_index();

		cm:trigger_dilemma_with_targets(faction:command_queue_index(), "wh3_main_minor_cult_dwarf_builders", 0, 0, 0, 0, region_cqi, 0);
		cm:remove_faction_foreign_slots_from_region(cult_cqi, region_cqi);
		cm:remove_effect_bundle_from_region(self.effect_bundle, region:name());
		self.saved_data.status = -1;
		return true;
	end
	return false;
end

function minor_cult:custom_listeners()
	core:add_listener(
		"BuildingCompleted_"..self.key,
		"BuildingCompleted",
		function(context)
			return self.saved_data.status > 0;
		end,
		function(context)
			local building = context:building();
			
			if building:faction():is_human() and context:garrison_residence():region():name() == self.saved_data.region_key then
				local turn_number = cm:turn_number();
				cm:set_saved_value("dwarf_builders_last_turn", turn_number);
			end
		end,
		true
	);
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