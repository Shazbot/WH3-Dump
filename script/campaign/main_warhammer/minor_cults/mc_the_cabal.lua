local minor_cult = {
	key = "",
	slot_key = "wh3_main_slot_set_minor_cult_39",
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
		["wh3_main_sc_nur_nurgle"] = true,
		["wh3_main_sc_sla_slaanesh"] = true,
		--["wh3_main_sc_tze_tzeentch"] = true,
		--["wh_dlc03_sc_bst_beastmen"] = true,
		["wh_dlc08_sc_nor_norsca"] = true,
		["wh_main_sc_chs_chaos"] = true
	},
	force_region = nil,
	valid_provinces = nil,
	valid_from_turn = 40,
	chance_if_valid = 5,
	complete_on_removal = true,
	event_data = {event_chance_per_turn = 100, event_cooldown = 0, event_limit = 999, event_initial_delay = 0, force_trigger = true},
	saved_data = {status = 0, region_key = "", event_cooldown = 0, event_triggers = 0}
};

local cabal_power_key = "minor_cult_cabal_power";
local cabal_power_value = 1;
local cabal_power_requirement_ability_1 = 3;
local cabal_power_requirement_ability_2 = 5;
local cabal_power_requirement_ability_3 = 7;
local cabal_power_requirement_ability_4 = 9;

--minor_cults_cabal_ability_1 -- PROVIDE CONSTRUCTION/RECRUITMENT BONUS
--minor_cults_cabal_ability_2 -- RETURN A SETTLEMENT ON LOSS
--minor_cults_cabal_ability_3 -- TAKE ENTIRE PROVINCE UPON OCCUPY
--minor_cults_cabal_ability_4 -- RANDOM ENEMY FACTION DESTROYED

function minor_cult:creation_event(region_key, turn_number)
	local region = cm:get_region(region_key);
	cm:change_corruption_in_province_by(region:province_name(), "wh3_main_corruption_tzeentch", 10, "events");

	local loaded_value = core:svr_load_registry_string(cabal_power_key);

	if loaded_value ~= nil and loaded_value ~= "" then
		cabal_power_value = tonumber(loaded_value);

		if cabal_power_value > 1 then
			self:update_existing_cult(region, cabal_power_value);

			if cabal_power_value >= cabal_power_requirement_ability_4 then
				cm:apply_effect_bundle_to_region("wh3_main_cabal_power_4", region_key, 0);
			elseif cabal_power_value >= cabal_power_requirement_ability_3 then
				cm:apply_effect_bundle_to_region("wh3_main_cabal_power_3", region_key, 0);
			elseif cabal_power_value >= cabal_power_requirement_ability_2 then
				cm:apply_effect_bundle_to_region("wh3_main_cabal_power_2", region_key, 0);
			elseif cabal_power_value >= cabal_power_requirement_ability_1 then
				cm:apply_effect_bundle_to_region("wh3_main_cabal_power_1", region_key, 0);
			end
		end
	end
end

function minor_cult:custom_listeners()
	local loaded_value = core:svr_load_registry_string(cabal_power_key);

	if loaded_value ~= nil and loaded_value ~= "" then
		cabal_power_value = tonumber(loaded_value);
	end

	core:add_listener(
		"FactionDeath_"..self.key,
		"FactionDeath",
		function(context)
			return self.saved_data.status > 0;
		end,
		function(context)
			local killer = context:killer();

			if killer and killer:is_null_interface() == false and killer:is_human() == true then
				local kill_skill = cm:get_factions_bonus_value(killer, "minor_cults_cabal_ability_1");

				if kill_skill > 0 then
					local region = cm:get_region(self.saved_data.region_key);
					cm:trigger_incident_with_targets(killer:command_queue_index(), "wh3_main_minor_cult_cabal_ability_1", 0, 0, 0, 0, region:cqi(), 0);
				end
			end
		end,
		true
	);
	core:add_listener(
		"CharacterPerformsSettlementOccupationDecision_"..self.key,
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			return self.saved_data.status > 0;
		end,
		function(context)
			local previous_owner_key = context:previous_owner();

			if previous_owner_key == "" then
				return false;
			end

			local previous_owner = cm:get_faction(previous_owner_key);
			local occupying_character = context:character();
			local occupying_faction = occupying_character:faction();
			local region = context:garrison_residence():region();
			local region_cqi = region:cqi();
			local region_key = region:name();

			if previous_owner and previous_owner:is_null_interface() == false and previous_owner:is_human() == true and previous_owner:is_dead() == false then
				local return_chance = cm:get_factions_bonus_value(previous_owner, "minor_cults_cabal_ability_2");

				if return_chance > 0 and cm:model():random_percent(return_chance) then

					if region_key ~= self.saved_data.region_key then
						local occupier_cqi = occupying_character:command_queue_index();
						local previous_owner_cqi = previous_owner:command_queue_index();

						cm:callback(
							function()
								-- Find enemy army and kill it
								cm:kill_character(occupier_cqi, true);
								-- Return the region to the player
								cm:transfer_region_to_faction(region_key, previous_owner_key);
							end,
							0.2
						);
						-- Report this to the player
						cm:trigger_incident_with_targets(previous_owner_cqi, "wh3_main_minor_cult_cabal_ability_2", 0, 0, 0, 0, region_cqi, 0);
					end
				end
			end

			if occupying_faction:is_null_interface() == false and occupying_faction:is_human() == true then
				local take_whole_province = cm:get_factions_bonus_value(occupying_faction, "minor_cults_cabal_ability_3");

				if take_whole_province > 0 and cm:model():random_percent(take_whole_province) then
					local region_list = region:province():regions();
					local occupying_faction_cqi = occupying_faction:command_queue_index();
					local occupying_faction_key = occupying_faction:name();
					local at_least_one_transfered = false;

					for i = 0, region_list:num_items() - 1 do
						local other_region = region_list:item_at(i);

						if other_region:owning_faction():command_queue_index() ~= occupying_faction_cqi then
							cm:transfer_region_to_faction(other_region:name(), occupying_faction_key);
							at_least_one_transfered = true;
						end
					end

					if at_least_one_transfered == true then
						cm:trigger_incident_with_targets(occupying_faction_cqi, "wh3_main_minor_cult_cabal_ability_3", 0, 0, 0, 0, region_cqi, 0);
					end
				end
			end
		end,
		true
	);
	core:add_listener(
		"ScriptEventHumanFactionTurnStart_"..self.key,
		"ScriptEventHumanFactionTurnStart",
		function(context)
			return self.saved_data.status > 0;
		end,
		function(context)
			local faction = context:faction();
			local kill_random_enemy = cm:get_factions_bonus_value(faction, "minor_cults_cabal_ability_4");

			if kill_random_enemy > 0 and cm:model():random_percent(kill_random_enemy) then
				local possible_factions = weighted_list:new();
				local war_factions = faction:factions_at_war_with();

				for i = 0, war_factions:num_items() - 1 do 
					local war_faction = war_factions:item_at(i);
					
					if war_faction:has_home_region() == true then
						possible_factions:add_item(war_faction, 3);
					else
						possible_factions:add_item(war_faction, 1);
					end
				end

				if #possible_factions.items > 0 then
					local target_capital_cqi = 0;
					local selected_faction = possible_factions:weighted_select();

					if selected_faction:has_home_region() == true then
						target_capital_cqi = selected_faction:home_region():cqi();
					end

					self:kill_faction(selected_faction:name());
					cm:trigger_incident_with_targets(faction:command_queue_index(), "wh3_main_minor_cult_cabal_ability_4", 0, 0, 0, 0, target_capital_cqi, 0);
				end
			end
		end,
		true
	);
end

function minor_cult:kill_faction(faction_key)
	local faction = cm:model():world():faction_by_key(faction_key); 
	
	if faction:is_null_interface() == false then
		cm:disable_event_feed_events(true, "wh_event_category_conquest", "", "")
		cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "")
		
		cm:kill_all_armies_for_faction(faction);
		
		local region_list = faction:region_list();
		
		for j = 0, region_list:num_items() - 1 do
			local region = region_list:item_at(j):name();
			cm:set_region_abandoned(region);
		end
		
		cm:callback(
			function() 
				cm:disable_event_feed_events(false, "wh_event_category_conquest", "", "");
				cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "");
			end,
			0.5
		);
	end
end

function minor_cult:custom_event(faction, region, cult_faction)
	local cult_success = false;
	local treasury = faction:treasury();

	if cabal_power_value == 2 and treasury >= 200000 then
		-- HAVE X TREASURY
		cult_success = true;
	elseif cabal_power_value == 4 and treasury >= 300000 then
		cult_success = true;
	elseif cabal_power_value == 6 and treasury >= 500000 then
		cult_success = true;
	elseif cabal_power_value == 8 and treasury >= 1000000 then
		cult_success = true;
	elseif cabal_power_value == 9 and faction:region_list():num_items() >= 200 then
		-- OWN 200 OR MORE REGIONS
		cult_success = true;
	end

	if cult_success == true then
		return self:cult_powers_up(faction, region);
	end
	return false;
end

function minor_cult:character_in_region(character, region, slot_list)
	-- LORD DEFEATED TRAIT REQUIREMENT
	if cabal_power_value == 1 or cabal_power_value == 3 or cabal_power_value == 5 or cabal_power_value == 7 then
		local cabal_trait_count_required = 20;
		local faction = region:owning_faction();

		if character:faction():command_queue_index() ~= faction:command_queue_index() then
			return false;
		end
		if character:number_of_traits() < cabal_trait_count_required then
			return false;
		end

		local defeat_trait_count = 0;

		for lord, trait in pairs(campaign_traits.legendary_lord_defeated_traits) do
			if character:has_trait(trait) == true then
				defeat_trait_count = defeat_trait_count + 1;
			end
		end
		
		if defeat_trait_count >= cabal_trait_count_required then
			return self:cult_powers_up(faction, region);
		end
	end
	return false;
end

function minor_cult:cult_powers_up(faction, region)
	cabal_power_value = cabal_power_value + 1;
	local faction_cqi = faction:command_queue_index();
	local region_cqi = region:cqi();
	local cult_cqi = cm:model():world():faction_by_key("wh3_main_rogue_minor_cults"):command_queue_index();
	cm:remove_faction_foreign_slots_from_region(cult_cqi, region_cqi);

	if cabal_power_value == 10 then
		self:cult_ending(faction, region);
		core:svr_save_registry_string(cabal_power_key, tostring(1));
		cm:trigger_incident_with_targets(faction_cqi, "wh3_main_minor_cult_cabal_plan", 0, 0, 0, 0, region_cqi, 0);
	else
		core:svr_save_registry_string(cabal_power_key, tostring(cabal_power_value));
		cm:trigger_incident_with_targets(faction_cqi, "wh3_main_minor_cult_cabal_removed", 0, 0, 0, 0, region_cqi, 0);
	end
	return true;
end

function minor_cult:update_existing_cult(region, power_level)
	local fsm = region:foreign_slot_manager_for_faction("wh3_main_rogue_minor_cults");

	if fsm:is_null_interface() == false then
		local slots = fsm:slots();
		
		for i = 0, slots:num_items() - 1 do
			local slot = slots:item_at(i);
			
			if slot:is_null_interface() == false and slot:has_building() == true then
				if slot:building():starts_with("wh3_main_minor_cult_the_cabal") then
					cm:foreign_slot_instantly_upgrade_building(slot, "wh3_main_minor_cult_the_cabal_"..power_level);
					cm:foreign_slot_set_reveal_to_faction(region:owning_faction(), fsm);
					break;
				end
			end
		end
	end
end

function minor_cult:cult_ending(faction, region)
	local potential_factions = {
		"wh3_main_tze_oracles_of_tzeentch",
		"wh3_main_tze_sarthoraels_watchers",
		"wh3_dlc20_tze_apostles_of_change",
		"wh3_main_tze_all_seeing_eye",
		"wh3_dlc20_tze_the_sightless",
		"wh3_main_tze_flaming_scribes",
		"wh3_main_tze_broken_wheel",
	};
	local selected_faction = cm:model():world():faction_by_key("wh3_main_tze_sarthoraels_watchers");
	local selected = false;
	
	for i = 1, #potential_factions do
		local tze_faction = cm:model():world():faction_by_key(potential_factions[i]);

		if tze_faction:is_null_interface() == false and tze_faction:is_human() == false and tze_faction:is_dead() == false then
			-- Factions are ordered in priority order, so this is our first choice that meets all criteria
			selected_faction = tze_faction;
			selected = true;
			break;
		end
	end

	if selected == false then
		-- Not found a faction yet, so allow dead factions (not ideal)
		for i = 1, #potential_factions do
			local tze_faction = cm:model():world():faction_by_key(potential_factions[i]);

			if tze_faction:is_null_interface() == false and tze_faction:is_human() == false then
				selected_faction = tze_faction;
				selected = true;
				break;
			end
		end
	end

	local tze_key = selected_faction:name();
	local region_list = cm:model():world():region_manager():region_list();

	for i = 0, region_list:num_items() - 1 do
		local current_region = region_list:item_at(i);
		
		if current_region:is_null_interface() == false and current_region:is_abandoned() == false then
			if current_region:cqi() ~= region:cqi() then
				cm:transfer_region_to_faction(current_region:name(), tze_key);

				if current_region:is_province_capital() == true and current_region:province_name() ~= region:province_name() then
					cm:change_corruption_in_province_by(current_region:province_name(), "wh3_main_corruption_tzeentch", 100, "events");
				end
			end
		end
	end

	local faction_list = cm:model():world():faction_list();
	
	for i = 0, faction_list:num_items() - 1 do
		local other_faction = faction_list:item_at(i);

		if other_faction:is_human() == false and other_faction:command_queue_index() ~= selected_faction:command_queue_index() then
			self:kill_faction(other_faction:name());
		end
	end
	cm:force_declare_war(tze_key, faction:name(), false, false);
end

function debug_reset_cabal()
	core:svr_save_registry_string(cabal_power_key, tostring(1));
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