local minor_cult = {
	key = "",
	slot_key = "wh3_main_slot_set_minor_cult_31",
	intro_incident_key = "wh3_main_minor_cult_intro",
	effect_bundle = nil,
	valid_subcultures = {
		["wh_main_sc_emp_empire"] = true,
		["wh_main_sc_brt_bretonnia"] = true,
		["wh3_main_sc_ksl_kislev"] = true,
		["wh2_main_sc_hef_high_elves"] = true,
		["wh3_main_sc_cth_cathay"] = true,
		["wh_main_sc_dwf_dwarfs"] = true,
		["wh2_dlc11_sc_cst_vampire_coast"] = true,
		["wh2_main_sc_lzd_lizardmen"] = true
	},
	force_region = nil,
	valid_provinces = nil,
	valid_from_turn = 5,
	chance_if_valid = 5,
	complete_on_removal = false,
	event_data = {event_chance_per_turn = 20, event_cooldown = 5, event_limit = 999, event_initial_delay = 5, force_trigger = false},
	saved_data = {status = 0, region_key = "", event_cooldown = 0, event_triggers = 0}
};

function minor_cult:custom_listeners()
	core:add_listener(
		"MinorCults_DilemmaChoiceMadeEvent_"..self.key,
		"DilemmaChoiceMadeEvent",
		true,
		function(context)
			local faction = context:faction();
			local dilemma = context:dilemma();
			local choice = context:choice();

			if dilemma == "wh3_main_minor_cult_peg_street_pawnshop_extra" then
				if choice == 1 then
					cm:force_remove_ancillary_from_faction(faction, "wh3_main_anc_armour_peg_leg");
				end
			elseif dilemma == "wh3_main_minor_cult_peg_street_pawnshop_leaving" then
				if choice == 1 then
					-- Early end of the events
					self.saved_data.status = -1;
				end
			elseif dilemma == "wh3_main_minor_cult_peg_street_pawnshop_2" then
				if choice == 0 then
					cm:apply_effect_bundle_to_region("wh3_main_pawnbroker_sold_out_dummy", self.saved_data.region_key, 0);
				end
			end
		end,
		true
	);
end

function minor_cult:custom_event(faction, region, cult_faction)
	if cm:get_saved_value("pawnbroker_left") then
		-- Check if a character has the item, roll chance for last event
		if faction:ancillary_exists("wh3_main_anc_armour_peg_leg") then
			local character_list = faction:character_list();

			for i = 0, character_list:num_items() - 1 do
				local character = character_list:item_at(i);

				if character:has_ancillary("wh3_main_anc_armour_peg_leg") then
					if cm:model():random_percent(3) then
						local dilemma_builder = cm:create_dilemma_builder("wh3_main_minor_cult_peg_street_pawnshop_extra");
						local payload_builder = cm:create_payload();
						dilemma_builder:add_target("default", character:family_member());
						
						payload_builder:text_display("dummy_peg_leg_keep");
						payload_builder:faction_ancillary_gain(faction, "wh3_main_anc_armour_peg_leg_lucky");
						dilemma_builder:add_choice_payload("FIRST", payload_builder);
						payload_builder:clear();

						payload_builder:text_display("dummy_peg_leg_sell");
						payload_builder:treasury_adjustment(25492);
						dilemma_builder:add_choice_payload("SECOND", payload_builder);
						payload_builder:clear();

						cm:launch_custom_dilemma_from_builder(dilemma_builder, faction);
						self.saved_data.status = -1;
					end
					break;
				end
			end
		end
	else
		local purchased_sword = 0;
		local purchased_armour = 0;
		local purchased_talisman = 0;

		if faction:ancillary_exists("wh3_main_anc_weapon_pirate_sword") then
			purchased_sword = 1;
		end
		if faction:ancillary_exists("wh3_main_anc_armour_pirate_armour") then
			purchased_armour = 1;
		end
		if faction:ancillary_exists("wh3_main_anc_talisman_pirate_talisman") then
			purchased_talisman = 1;
		end
		local count_purchased = purchased_sword + purchased_armour + purchased_talisman;

		if count_purchased == 3 then
			local dilemma_builder = cm:create_dilemma_builder("wh3_main_minor_cult_peg_street_pawnshop_leaving");
			local payload_builder = cm:create_payload();
			
			payload_builder:faction_ancillary_gain(faction, "wh3_main_anc_armour_peg_leg");
			dilemma_builder:add_choice_payload("FIRST", payload_builder);
			payload_builder:clear();
			
			payload_builder:text_display("dummy_do_nothing");
			dilemma_builder:add_choice_payload("SECOND", payload_builder);
			payload_builder:clear();

			cm:launch_custom_dilemma_from_builder(dilemma_builder, faction);

			local cult_cqi = cult_faction:command_queue_index();
			local region_cqi = region:cqi();
			self.saved_data.status = 2;
			cm:remove_faction_foreign_slots_from_region(cult_cqi, region_cqi);
			cm:remove_effect_bundle_from_region("wh3_main_pawnbroker_sold_out_dummy", self.saved_data.region_key);
			cm:set_saved_value("pawnbroker_left", true);
		else
			self:pawnbroker_event(faction, purchased_sword, purchased_armour, purchased_talisman);
		end
	end
end

function minor_cult:pawnbroker_event(faction, purchased_sword, purchased_armour, purchased_talisman)
	local half_price = cm:get_factions_bonus_value(faction, "pawnbroker_half_price");
	local count_purchased = purchased_sword + purchased_armour + purchased_talisman;
	local dilemma_builder = cm:create_dilemma_builder("wh3_main_minor_cult_peg_street_pawnshop_"..count_purchased);
	local payload_builder = cm:create_payload();

	local valid_items = {};
	local valid_choices = {"FIRST", "SECOND", "THIRD", "FOURTH"};

	if purchased_sword == 0 then
		table.insert(valid_items, "wh3_main_anc_weapon_pirate_sword");
	end
	if purchased_armour == 0 then
		table.insert(valid_items, "wh3_main_anc_armour_pirate_armour");
	end
	if purchased_talisman == 0 then
		table.insert(valid_items, "wh3_main_anc_talisman_pirate_talisman");
	end

	local amount_to_sell = 3 - count_purchased;
	
	for i = 1, amount_to_sell do
		local item = valid_items[1];
		table.remove(valid_items, 1);
		local choice = valid_choices[1];
		table.remove(valid_choices, 1);

		if item == "wh3_main_anc_armour_pirate_armour" then
			if half_price == 0 then
				payload_builder:treasury_adjustment(-3999);
			else
				payload_builder:treasury_adjustment(-1999);
				payload_builder:text_display("dummy_pawnbroker_half_price");
			end
		elseif item == "wh3_main_anc_talisman_pirate_talisman" then
			if half_price == 0 then
				payload_builder:treasury_adjustment(-3999);
			else
				payload_builder:treasury_adjustment(-1999);
				payload_builder:text_display("dummy_pawnbroker_half_price");
			end
		elseif item == "wh3_main_anc_weapon_pirate_sword" then
			if half_price == 0 then
				payload_builder:treasury_adjustment(-5999);
			else
				payload_builder:treasury_adjustment(-2999);
				payload_builder:text_display("dummy_pawnbroker_half_price");
			end
		else
			payload_builder:treasury_adjustment(-3999);
		end

		payload_builder:faction_ancillary_gain(faction, item);
		dilemma_builder:add_choice_payload(choice, payload_builder);
		payload_builder:clear();
	end
	
	local choice = valid_choices[1];
	payload_builder:text_display("dummy_do_nothing");
	dilemma_builder:add_choice_payload(choice, payload_builder);
	payload_builder:clear();
	cm:launch_custom_dilemma_from_builder(dilemma_builder, faction);
end

function minor_cult:removal_event(remover, region)
	cm:remove_effect_bundle_from_region("wh3_main_pawnbroker_sold_out_dummy", self.saved_data.region_key);

	if self.saved_data.status ~= 2 then
		self.saved_data.status = -1;
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
							if current_region:settlement():is_port() == false then
								valid_region_list:add_item(current_region, 1);
							else
								valid_region_list:add_item(current_region, 2);
							end
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