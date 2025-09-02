local minor_cult = {
	key = "",
	slot_key = "wh3_main_slot_set_minor_cult_14",
	intro_incident_key = "wh3_main_minor_cult_intro",
	effect_bundle = nil,
	valid_subcultures = {
		["wh_main_sc_emp_empire"] = true,
		["wh_main_sc_brt_bretonnia"] = true,
		["wh3_main_sc_ksl_kislev"] = true,
		["wh2_main_sc_hef_high_elves"] = true,
		["wh3_main_sc_cth_cathay"] = true,
		["wh_main_sc_dwf_dwarfs"] = true
	},
	force_region = nil,
	valid_provinces = nil,
	valid_from_turn = 5,
	chance_if_valid = 10,
	complete_on_removal = true,
	event_data = {event_chance_per_turn = 5, event_cooldown = 25, event_limit = 1, event_initial_delay = 5, force_trigger = false},
	saved_data = {status = 0, region_key = "", event_cooldown = 0, event_triggers = 0}
};

function minor_cult:custom_listeners()
	core:add_listener(
		"MinorCults_DilemmaChoiceMadeEvent_"..self.key,
		"DilemmaChoiceMadeEvent",
		true,
		function(context)
			if context:dilemma() == "wh3_main_minor_cult_settlement_sale" then
				if context:choice() == 0 then
					-- Remove the traders
					local region = cm:get_region(self.saved_data.region_key);
					local faction = cm:model():world():faction_by_key("wh3_main_rogue_minor_cults");
					cm:remove_faction_foreign_slots_from_region(faction:command_queue_index(), region:cqi());
					-- Transfer region to Tilea
					cm:transfer_region_to_faction(self.saved_data.region_key, "wh_main_teb_tilea");
					self.saved_data.status = -1;
				end
			end
		end,
		true
	);
end

function minor_cult:custom_event(faction, region, cult_faction)
	local region_cqi = region:cqi();
	local faction_cqi = faction:command_queue_index();
	cm:trigger_dilemma_with_targets(faction_cqi, "wh3_main_minor_cult_settlement_sale", 0, 0, 0, 0, region_cqi, 0);
	return true;
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
						if current_region:settlement():is_port() == false then
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