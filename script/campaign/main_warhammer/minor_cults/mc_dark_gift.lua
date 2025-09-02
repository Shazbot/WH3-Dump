local minor_cult = {
	key = "",
	slot_key = "wh3_main_slot_set_minor_cult_35",
	intro_incident_key = "wh3_main_minor_cult_intro",
	effect_bundle = "wh3_main_minor_cult_dark_gift_1",
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
		["wh_dlc03_sc_bst_beastmen"] = true,
		["wh_dlc08_sc_nor_norsca"] = true
	},
	force_region = nil,
	valid_provinces = nil,
	valid_from_turn = 5,
	chance_if_valid = 5,
	complete_on_removal = true,
	event_data = nil,
	saved_data = {status = 0, region_key = "", event_cooldown = 0, event_triggers = 0}
};

local chaos_lord_factions = {
	-- Chaos
	{faction = "wh_main_chs_chaos", weight = 15},
	{faction = "wh3_dlc20_chs_kholek", weight = 10},
	{faction = "wh3_main_chs_shadow_legion", weight = 5},
	{faction = "wh3_dlc20_chs_festus", weight = 5},
	{faction = "wh3_dlc20_chs_valkia", weight = 5},
	{faction = "wh3_dlc20_chs_sigvald", weight = 5},
	{faction = "wh3_dlc20_chs_azazel", weight = 5},
	{faction = "wh3_dlc20_chs_vilitch", weight = 5},
	-- Khorne
	{faction = "wh3_main_kho_exiles_of_khorne", weight = 1},
	{faction = "wh3_dlc26_kho_arbaal", weight = 1},
	{faction = "wh3_dlc26_kho_skulltaker", weight = 1},
	-- Nurgle
	{faction = "wh3_main_nur_poxmakers_of_nurgle", weight = 1},
	{faction = "wh3_dlc25_nur_tamurkhan", weight = 1},
	{faction = "wh3_dlc25_nur_epidemius", weight = 1},
	-- Tzeentch
	{faction = "wh3_main_tze_oracles_of_tzeentch", weight = 1},
	-- Slaanesh
	{faction = "wh3_main_sla_seducers_of_slaanesh", weight = 1}
};

function minor_cult:creation_event(region_key, turn_number)
	local region = cm:get_region(region_key);
	cm:change_corruption_in_province_by(region:province_name(), "wh3_main_corruption_chaos", 10, "events");
end

function minor_cult:custom_listeners()
	core:add_listener(
		"UnitTrained_"..self.key,
		"UnitTrained",
		function(context)
			return self.saved_data.status > 0;
		end,
		function(context)
			local unit = context:unit();

			if unit:has_force_commander() == true and unit:force_commander():has_region() == true then
				local province_recruited = unit:force_commander():region():province_name();
				local cult_region = cm:get_region(self.saved_data.region_key);
				local cult_province = cult_region:province_name();

				if province_recruited == cult_province then
					local faction = unit:force_commander():faction();
					local gift1 = cm:get_factions_bonus_value(faction, "minor_cults_chaos_recruitment_1");
					local gift2 = cm:get_factions_bonus_value(faction, "minor_cults_chaos_recruitment_2");
					local gift3 = cm:get_factions_bonus_value(faction, "minor_cults_chaos_recruitment_3");

					if gift1 == 0 and gift2 == 0 and gift3 == 0 then
						return true;
					end

					local possible_lords = weighted_list:new();

					for i = 1, #chaos_lord_factions do
						local lord_faction = cm:get_faction(chaos_lord_factions[i].faction);

						if lord_faction and lord_faction:is_null_interface() == false and lord_faction:is_dead() == false then
							local faction_leader = lord_faction:faction_leader();

							if faction_leader:has_military_force() == true then
								possible_lords:add_item(faction_leader, chaos_lord_factions[i].weight);
							end
						end
					end
					
					if #possible_lords.items > 0 then
						local selected_lord, index = possible_lords:weighted_select();
						
						-- GIFT 1 - chance a random Chaos-aligned Legendary Lord will gain 10 ranks
						if gift1 > 0 and cm:model():random_percent(gift1) then
							cm:add_agent_experience(cm:char_lookup_str(selected_lord:command_queue_index()), 10, true);
						end

						selected_lord, index = possible_lords:weighted_select();

						-- GIFT 3 - chance a random Chaos-aligned Legendary Lord's army will gain maximum experience for all of its units
						if gift3 > 0 and cm:model():random_percent(gift3) then
							cm:add_experience_to_units_commanded_by_character(cm:char_lookup_str(selected_lord:command_queue_index()), 9);
						end
					end
					
					-- GIFT 2 - Chance a random province will gain 100 Chaos corruption
					if gift2 > 0 and cm:model():random_percent(gift2) then
						local possible_provinces = weighted_list:new();
						local province_list = cm:model():world():province_list();
	
						for i = 0, province_list:num_items() - 1 do
							local current_province = province_list:item_at(i):key();

							if current_province ~= cult_province then
								possible_provinces:add_item(current_province, 1);
							end
						end

						if #possible_provinces.items > 0 then
							local selected_province, index = possible_provinces:weighted_select();
							cm:change_corruption_in_province_by(selected_province, "wh3_main_corruption_chaos", 100, "events");
						end
					end
				end
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