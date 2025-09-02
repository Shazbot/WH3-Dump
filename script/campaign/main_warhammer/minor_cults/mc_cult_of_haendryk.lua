local minor_cult = {
	key = "",
	slot_key = "wh3_main_slot_set_minor_cult_7",
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
	force_region = "wh3_main_combi_region_marienburg",
	valid_provinces = nil,
	valid_from_turn = 5,
	chance_if_valid = 15,
	complete_on_removal = true,
	event_data = {event_chance_per_turn = 20, event_cooldown = 20, event_limit = 3, event_initial_delay = 5, force_trigger = false},
	saved_data = {status = 0, region_key = "", event_cooldown = 0, event_triggers = 0}
};

function minor_cult:custom_event(faction, region, cult_faction)
	if faction:net_income() >= 500 then
		-- We're going to ask for half the players gross income over 11 turns as payment
		-- The loan amount given will be 10 turns worth of this rounded up
		local loan_turn_term = 11;
		local loan_turn_worth = 10;
		local loan_round_to_nearest = 100;

		local background_income = 3000;
		local trade_value = faction:trade_value();
		local real_income = faction:income() - trade_value - background_income;
		local loan_amount = loan_round_to_nearest * math.ceil((real_income * loan_turn_worth) / loan_round_to_nearest);

		if loan_amount < 4000 then
			loan_amount = 4000;
		end

		-- CUSTOM DILEMMA
		local dilemma_builder = cm:create_dilemma_builder("wh3_main_minor_cult_loan");
		local payload_builder = cm:create_payload();

		local loan_effect_bundle = cm:create_new_custom_effect_bundle("wh3_main_minor_cult_loan");
		loan_effect_bundle:add_effect("wh_main_effect_economy_gdp_mod_all", "faction_to_region_own", -100);
		loan_effect_bundle:add_effect("wh2_main_effect_agent_action_passive_boost_income_effect_negative", "faction_to_region_own", -1000);
		loan_effect_bundle:add_effect("wh_main_effect_economy_trade_tariff_mod", "faction_to_faction_own", -100);
		loan_effect_bundle:set_duration(loan_turn_term);

		payload_builder:treasury_adjustment(loan_amount);
		payload_builder:effect_bundle_to_faction(loan_effect_bundle);
		dilemma_builder:add_choice_payload("FIRST", payload_builder);
		payload_builder:clear();

		payload_builder:text_display("dummy_do_nothing");
		dilemma_builder:add_choice_payload("SECOND", payload_builder);
		payload_builder:clear();

		cm:launch_custom_dilemma_from_builder(dilemma_builder, faction);
		return true;
	end
	return false;
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