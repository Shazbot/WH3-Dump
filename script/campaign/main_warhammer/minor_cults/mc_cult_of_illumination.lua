local minor_cult = {
	key = "",
	faction_key = "wh3_main_rogue_minor_cults",
	slot_key = "wh3_main_slot_set_minor_cult_8",
	intro_incident_key = "wh3_main_minor_cult_intro",
	effect_bundle = nil,
	valid_subcultures = {
		["wh_main_sc_emp_empire"] = true
	},
	force_region = nil,
	valid_provinces = {
		["wh3_main_combi_province_averland"] = true,
		["wh3_main_combi_province_reikland"] = true,
		["wh3_main_combi_province_hochland"] = true,
		["wh3_main_combi_province_middenland"] = true,
		["wh3_main_combi_province_nordland"] = true,
		["wh3_main_combi_province_ostermark"] = true,
		["wh3_main_combi_province_ostland"] = true,
		["wh3_main_combi_province_stirland"] = true,
		["wh3_main_combi_province_talabecland"] = true,
		["wh3_main_combi_province_wissenland"] = true,
		["wh3_main_combi_province_solland"] = true,
		["wh3_main_combi_province_mootland"] = true,
		["wh3_dlc20_combi_province_middle_mountains"] = true,
		["wh3_main_combi_province_the_misty_hills"] = true,
		["wh3_main_combi_province_the_witchs_wood"] = true,
		["wh3_main_combi_province_gryphon_wood"] = true,
		["wh3_main_combi_province_northern_sylvania"] = true,
		["wh3_main_combi_province_southern_sylvania"] = true,
		["wh3_main_combi_province_the_wasteland"] = true
	},
	valid_from_turn = 5,
	chance_if_valid = 5,
	event_data = nil,
	saved_data = {active = false, region_key = "", event_cooldown = 0, event_triggers = 0}
};

function minor_cult:is_valid(MINOR_CULT_REGIONS)
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

				if owner:is_null_interface() == false and owner:is_human() == true then
					local current_subculture = owner:subculture();

					if self.valid_subcultures[current_subculture] ~= nil then
						valid_region_list:add_item(current_region, 1);
					elseif debug_validity == true then
						out("\tFAIL - FORCED REGION SUBCULTURE - "..current_subculture);
					end
				elseif debug_validity == true then
					out("\tFAIL - FORCED REGION OWNER AI/NULL");
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

				if owner:is_null_interface() == false and owner:is_human() == true then
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
						if owner:name() ~= "wh_main_emp_empire" then
							valid = false;
						end
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