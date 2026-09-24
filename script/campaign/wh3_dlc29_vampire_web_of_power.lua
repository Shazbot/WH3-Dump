web_of_power_ai_config =
{
	-- CAI will act every n-th turn
	turn_delay = 3,
	ritual_ai_priority_weights =
	{
		never = 0,
		low = 1,
		medium = 2,
		high = 3,
	},
}

web_of_power_actions = {
    config = {
        neferata_faction_key = "wh3_dlc29_vmp_neferata",
        vampire_counts_subculture = "wh_main_sc_vmp_vampire_counts"
    },

    rituals = {
		["wh3_dlc29_neferata_actions_t1_assist_coven"] = {
            callback = function (context, performing_character)
				local target_region = context:ritual_target_region();
				local faction = performing_character:faction();
				local province = target_region:province();
		
				local pooled_resource_manager = cm:get_or_create_faction_province_persistent_pooled_resource_manager(faction, province);

				if pooled_resource_manager:is_null_interface() == false then
					local concealment_resource = pooled_resource_manager:resource("wh3_dlc29_nef_concealment");
					
					if concealment_resource:is_null_interface() == false then
						cm:pooled_resource_factor_transaction(concealment_resource, "neferata_web_of_power", 30);
					end
				end
            end,
			xp = 1000,
			ai_priority = web_of_power_ai_config.ritual_ai_priority_weights.high,
			set_ai_performing_character = function(faction, ritual_setup, performing_character_slot)
				local neferata_family_member = faction:faction_leader():family_member()
				local status = performing_character_slot:status_with_performer(ritual_setup, neferata_family_member)
				if status:valid() then
					performing_character_slot:set_performer(ritual_setup, neferata_family_member)
					return true
				else
					return false
				end
			end,
			set_ai_target = function(faction, target_slot)
				local lowest_concealment = 100000
				local lowest_concealment_region = nil

				local foreign_slot_managers = faction:foreign_slot_managers()
	
				for i = 0, foreign_slot_managers:num_items() - 1 do
					local region = foreign_slot_managers:item_at(i):region()
					local province = region:province()
					
					local pooled_resource_manager = cm:get_or_create_faction_province_persistent_pooled_resource_manager(faction, province)
			
					if pooled_resource_manager:is_null_interface() == false then
						local concealment_resource = pooled_resource_manager:resource("wh3_dlc29_nef_concealment")
						
						if concealment_resource:is_null_interface() == false and concealment_resource:value() < lowest_concealment then
							lowest_concealment = concealment_resource:value()
							lowest_concealment_region = region
						end
					end
				end
				if lowest_concealment_region then
					target_slot:set_target_region(lowest_concealment_region)
					return true
				else
					return false
				end
			end,
		},
		["wh3_dlc29_neferata_actions_t1_cause_war"] = {
            callback = function (context, performing_character)
				local performing_faction = performing_character:faction();
				local target_faction = context:ritual_target_faction();
				local target_faction_key = target_faction:name();
				local possible_targets = {};
				local possible_allied_targets = {};
				local region_list = target_faction:region_list();
	
				for _, region in model_pairs(region_list) do
					if region:is_null_interface() == false and region:is_abandoned() == false then
						local adjacent_region_list = region:adjacent_region_list();

						for _, adj_region in model_pairs(adjacent_region_list) do
							if adj_region:is_null_interface() == false and adj_region:is_abandoned() == false then
								local owner = adj_region:owning_faction();

								if owner:is_faction(performing_faction) == false and owner:is_faction(target_faction) == false then
									if owner:at_war_with(target_faction) == false and owner:is_vassal_of(target_faction) == false and target_faction:is_vassal_of(owner) == false then
										if owner:allied_with(target_faction) == true then
											table.insert(possible_allied_targets, owner:name());
										else
											table.insert(possible_targets, owner:name());
										end
									end
								end
							end
						end
					end
				end

				if #possible_targets == 0 then
					local factions_met = target_faction:factions_met();

					for _, faction in model_pairs(factions_met) do
						if faction:is_faction(performing_faction) == false and faction:is_dead() == false and faction:at_war_with(target_faction) == false then
							table.insert(possible_targets, faction:name());
						end
					end
				end

				if #possible_targets > 0 then
					cm:shuffle_table(possible_targets);
					cm:force_declare_war(target_faction_key, possible_targets[1], false, false);
				elseif #possible_allied_targets > 0 then
					cm:shuffle_table(possible_allied_targets);
					cm:force_declare_war(target_faction_key, possible_allied_targets[1], false, false);
				end
            end,
			xp = 1000,
			ai_priority = web_of_power_ai_config.ritual_ai_priority_weights.never
		},
		["wh3_dlc29_neferata_actions_t1_assassination"] = {
			xp = 1000,
			ai_priority = web_of_power_ai_config.ritual_ai_priority_weights.low,
			set_ai_performing_character = function(faction, ritual_setup, performing_character_slot)
				return web_of_power_actions:set_performing_character_highest_not_max_level_vampire(faction, ritual_setup, performing_character_slot)
			end,
			set_ai_target = function(faction, target_slot)
				return web_of_power_actions:target_highest_level_enemy_character(faction, target_slot)
			end,
		},
		["wh3_dlc29_neferata_actions_t1_steal_treasury"] = {
            callback = function (context, performing_character)
				cm:treasury_mod(web_of_power_actions.config.neferata_faction_key, 3000);

				local target_faction = context:ritual_target_faction();
				cm:apply_dilemma_diplomatic_bonus(web_of_power_actions.config.neferata_faction_key, target_faction:name(), -3);
            end,
			xp = 500,
			ai_priority = web_of_power_ai_config.ritual_ai_priority_weights.medium,
			set_ai_performing_character = function(faction, ritual_setup, performing_character_slot)
				return web_of_power_actions:set_performing_character_highest_not_max_level_vampire(faction, ritual_setup, performing_character_slot)
			end,
			set_ai_target = function(faction, target_slot)
				-- Any faction at war → Lowest relations known faction
				local factions_at_war = faction:factions_at_war_with()
				for i = 0, factions_at_war:num_items() - 1 do
					local enemy_faction = factions_at_war:item_at(i)
					if cm:faction_is_alive(enemy_faction) then
						target_slot:set_target_faction(enemy_faction)
						return true
					end
				end

				local lowest_relation = 1000000
				local lowest_relation_faction

				local factions_met = faction:factions_met()
				for i = 0, factions_met:num_items() - 1 do
					local faction_met = factions_met:item_at(i)
					if cm:faction_is_alive(faction_met) then
						local relation = faction:diplomatic_attitude_towards(faction_met:name())
						if relation < lowest_relation then
							lowest_relation = relation
							lowest_relation_faction = faction_met
						end
					end
				end

				if not lowest_relation_faction then
					return false
				end

				target_slot:set_target_faction(lowest_relation_faction)
				return true
			end,
		},
        ["wh3_dlc29_neferata_actions_t1_steal_item"] = {
            callback = function (context, performing_character)
                local target_force = context:ritual_target_force();
                local target_character = target_force:general_character();
                local ancillaries = web_of_power_actions:find_valid_ancillaries(target_character:command_queue_index());
				local performing_faction = performing_character:faction();
                            
                if ancillaries and #ancillaries > 0 then
					local chosen_ancillary = ancillaries[cm:random_number(#ancillaries)];

                    cm:force_remove_ancillary(target_character, chosen_ancillary, false, false);
                    cm:add_ancillary_to_faction(performing_faction, chosen_ancillary, false);
				else
					local ancillary_key = get_random_ancillary_key_for_faction(performing_faction:name(), false, false);
					cm:add_ancillary_to_faction(performing_faction, ancillary_key, false);
                end

				cm:apply_dilemma_diplomatic_bonus(web_of_power_actions.config.neferata_faction_key, target_character:faction():name(), -3);
            end,
			xp = 500,
			ai_priority = web_of_power_ai_config.ritual_ai_priority_weights.low,
			set_ai_performing_character = function(faction, ritual_setup, performing_character_slot)
				return web_of_power_actions:set_performing_character_highest_not_max_level_vampire(faction, ritual_setup, performing_character_slot)
			end,
			set_ai_target = function(faction, target_slot)
				return web_of_power_actions:target_highest_level_enemy_character(faction, target_slot)
			end,
        },
        ["wh3_dlc29_neferata_actions_t1_teleport_neferata"] = {
            callback = function (context, performing_character)
				if performing_character:has_military_force() then
					local target_region = context:ritual_target_region();
					local faction_key = performing_character:faction():name();
					local region_key = target_region:name();

					local x, y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, region_key, false, true, 3);
					local dx, dy = cm:log_to_dis(x, y);
					cm:set_camera_position(dx, dy, 13, 0, 10);

					local char_lookup_str = cm:char_lookup_str(performing_character);
					cm:teleport_to(char_lookup_str, x, y);
				end
            end,
			xp = 1000,
			ai_priority = web_of_power_ai_config.ritual_ai_priority_weights.never
        },
        ["wh3_dlc29_neferata_actions_t1_break_alliances"] = {
            callback = function (context, performing_character)
				local target_faction = context:ritual_target_faction();
				local target_faction_key = target_faction:name();
				local lower_reliability = false;

				local faction_list = target_faction:factions_non_aggression_pact_with();
				for i = 0, faction_list:num_items() - 1 do
					local other_faction = faction_list:item_at(i);
					cm:force_break_non_aggression_pact(target_faction_key, other_faction:name(), not lower_reliability);
				end
				faction_list = target_faction:factions_military_access_pact_with();
				for i = 0, faction_list:num_items() - 1 do
					local other_faction = faction_list:item_at(i);
					cm:force_break_military_access(target_faction_key, other_faction:name(), not lower_reliability, false);
				end
				faction_list = target_faction:factions_allied_with();
				for i = 0, faction_list:num_items() - 1 do
					local other_faction = faction_list:item_at(i);
					cm:force_break_alliance(target_faction_key, other_faction:name());
				end
				faction_list = target_faction:factions_trading_with();
				for i = 0, faction_list:num_items() - 1 do
					local other_faction = faction_list:item_at(i);
					cm:force_break_trade_agreement(target_faction_key, other_faction:name());
				end
            end,
			xp = 1000,
			ai_priority = web_of_power_ai_config.ritual_ai_priority_weights.never
        },
        ["wh3_dlc29_neferata_actions_t1_block_movement"] = {
            callback = function (context, performing_character)
                local target_force = context:ritual_target_force();

				if target_force:has_general() then
					local general = target_force:general_character();
					cm:zero_action_points(general:command_queue_index());
					cm:apply_effect_bundle_to_force("wh3_dlc29_neferata_actions_block_movement", target_force:command_queue_index(), 0);
				end
            end,
			xp = 1000,
			ai_priority = web_of_power_ai_config.ritual_ai_priority_weights.medium,
			set_ai_performing_character = function(faction, ritual_setup, performing_character_slot)
				return web_of_power_actions:set_performing_character_highest_not_max_level_vampire(faction, ritual_setup, performing_character_slot)
			end,
			set_ai_target = function(faction, target_slot)
				-- Strongest force of a random enemy faction (if no enemies → do not perform)
				local factions_at_war = faction:factions_at_war_with()
				if factions_at_war:num_items() - 1 < 1 then
					return false
				end
				local enemy_faction_index = cm:random_number(factions_at_war:num_items() - 1)
				local enemy_faction = factions_at_war:item_at(enemy_faction_index)
				if not cm:faction_is_alive(enemy_faction) then
					return false
				end

				local force = cm:get_strongest_military_force_from_faction(enemy_faction:name(), false)
				if force and not force:is_null_interface() then
					target_slot:set_target_force(force)
					return true
				end

				return false
			end,
        },
		["wh3_dlc29_neferata_actions_t2_incite_rebellion"] = {
			xp = 2000,
			ai_priority = web_of_power_ai_config.ritual_ai_priority_weights.medium,
			set_ai_performing_character = function(faction, ritual_setup, performing_character_slot)
				return web_of_power_actions:set_performing_character_highest_not_max_level_vampire(faction, ritual_setup, performing_character_slot)
			end,
			set_ai_target = function(faction, target_slot)
				--TODO
				return false
			end,
		},
		["wh3_dlc29_neferata_actions_t2_damage_garrison"] = {
			callback = function(context, performing_character)
				local target_region = context:ritual_target_region();

				if target_region == nil or target_region:is_null_interface() then
					return false;
				end
				
				local garrison_residence = target_region:garrison_residence()
				cm:sabotage_garrison_army(garrison_residence, 0.3);
 
				local settlement = target_region:settlement();
				
				if settlement:is_null_interface() == false and settlement:is_walled_settlement() == true then
					local desired = 2;
					local current = settlement:number_of_wall_breaches();

					if desired > current then
						cm:set_settlement_wall_health(settlement, desired);
					end
				end
			end,
			xp = 1000,
			ai_priority = web_of_power_ai_config.ritual_ai_priority_weights.medium,
			set_ai_performing_character = function(faction, ritual_setup, performing_character_slot)
				return web_of_power_actions:set_performing_character_highest_not_max_level_vampire(faction, ritual_setup, performing_character_slot)
			end,
			set_ai_target = function(faction, target_slot)
				-- Enemy region closest to Neferata (if no enemies → do not perform)
				local neferata_character = faction:faction_leader()
				if neferata_character:is_wounded() then
					return false
				end

				local neferata_pos_x = neferata_character:logical_position_x()
				local neferata_pos_y = neferata_character:logical_position_y()
				local closest_distance_squared = 1000000
				local closest_region
				local factions_at_war = faction:factions_at_war_with()
				for i = 0, factions_at_war:num_items() - 1 do
					local enemy_faction = factions_at_war:item_at(i)
					local region_list = enemy_faction:region_list()
					for i = 0, region_list:num_items() - 1 do
						local region = region_list:item_at(i)
						local settlement = region:settlement()
						if settlement and not settlement:is_null_interface() then
							local settlement_pos_x = settlement:logical_position_x()
							local settlement_pos_y = settlement:logical_position_y()
							local distance_squared = math.abs((settlement_pos_x - neferata_pos_x) * (settlement_pos_x - neferata_pos_x))
								+ math.abs((settlement_pos_y - neferata_pos_y) * (settlement_pos_y - neferata_pos_y))
							if distance_squared < closest_distance_squared then
								closest_distance_squared = distance_squared
								closest_region = region
							end
						end
					end
				end

				if not closest_region then
					return false
				end

				target_slot:set_target_region(closest_region)
				return true
			end,
		},
		["wh3_dlc29_neferata_actions_t3_replenish_ap"] = {
			xp = 3000,
			ai_priority = web_of_power_ai_config.ritual_ai_priority_weights.high,
			set_ai_performing_character = function(faction, ritual_setup, performing_character_slot)
				return web_of_power_actions:set_performing_character_highest_not_max_level_vampire(faction, ritual_setup, performing_character_slot)
			end,
			set_ai_target = function(faction, target_slot)
				local neferata_character = faction:faction_leader()
				if not neferata_character:is_wounded() then
					target_slot:set_target_character(neferata_character)
					return true
				end

				local highest_level = -1
				local highest_level_character = nil
				local character_list = faction:character_list()
				local character_count = character_list:num_items() - 1
				for i = 0, character_count do
					local character = character_list:item_at(i)
					if character:rank() > highest_level and not character:is_wounded() then
						highest_level = character:rank()
						highest_level_character = character
					end
				end

				if not highest_level_character then
					return false
				end

				target_slot:set_target_character(highest_level_character)
				return true
			end,
		},
        ["wh3_dlc29_neferata_actions_t3_teleport_enemy"] = {
            callback = function (context, performing_character)
                local target_force = context:ritual_target_force();

				if target_force:has_general() == true then
					local general = target_force:general_character();
					
					if general:has_region() == true then
						local adjacent_provinces = general:region():province():adjacent_provinces();
						local possible_regions = {};

						for _, province in model_pairs(adjacent_provinces) do
							local regions = province:regions();

							for _, region in model_pairs(regions) do
								table.insert(possible_regions, region:name());
							end
						end

						if #possible_regions > 0 then
							cm:shuffle_table(possible_regions);

							local faction_key = general:faction():name();

							for i = 1, #possible_regions do
								local x, y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, possible_regions[i], false, true, 7);

								if x > -1 and y > -1 then
									local char_lookup_str = cm:char_lookup_str(general);
									cm:teleport_to(char_lookup_str, x, y);
									break;
								end
							end
						end
					end
                end
            end,
			xp = 3000,
			ai_priority = web_of_power_ai_config.ritual_ai_priority_weights.never
        },
        ["wh3_dlc29_neferata_actions_t4_convert_climate"] = {
            callback = function (context, performing_character)
				local target_region = context:ritual_target_region();

				cm:change_corruption_in_province_by(target_region:province_name(), "wh3_main_corruption_vampiric", 100, "events");
				cm:apply_effect_bundle_to_region("wh3_main_bundle_region_vampiric_climate", target_region:name(), 0);
				climate_change:add_climate_override(target_region, "vampire_corpses");
            end,
			xp = 4000,
			ai_priority = web_of_power_ai_config.ritual_ai_priority_weights.never
        },
        ["wh3_dlc29_neferata_actions_t5_declare_war"] = {
            callback = function (context, performing_character)
				local performing_faction = performing_character:faction();
				local target_faction_key = context:ritual_target_faction():name();
				local faction_war_list = performing_faction:factions_at_war_with();

				for _, faction in model_pairs(faction_war_list) do
					local faction_key = faction:name();
					cm:force_declare_war(target_faction_key, faction_key, false, false);
				end
            end,
			xp = 5000,
			ai_priority = web_of_power_ai_config.ritual_ai_priority_weights.never
        },
        ["wh3_dlc29_neferata_actions_t5_intercept_diplomacy"] = {
            callback = function (context, performing_character)
				local target_faction = context:ritual_target_faction();
				local target_faction_key = target_faction:name();
				cm:force_diplomacy("faction:"..target_faction_key, "faction:"..web_of_power_actions.config.neferata_faction_key, "all", false, true, false);

				-- Track when to re-enable diplomacy
				web_of_power_actions.track_diplomacy[target_faction_key] = cm:turn_number() + 20;
            end,
			xp = 15000,
			ai_priority = web_of_power_ai_config.ritual_ai_priority_weights.never
		},
        ["wh3_dlc29_neferata_actions_t6_raze_province"] = {
            callback = function (context, performing_character)
				local target_region = context:ritual_target_region();
				local province_regions = target_region:province():regions();

				for _, region in model_pairs(province_regions) do
					local region_key = region:name();
					cm:set_region_abandoned(region_key);
					cm:apply_effect_bundle_to_region("wh3_main_bundle_region_vampiric_climate", region_key, 0);
					climate_change:add_climate_override(region, "vampire_corpses");
				end
            end,
			xp = 7000,
			ai_priority = web_of_power_ai_config.ritual_ai_priority_weights.never
		}
    },
	track_diplomacy = {}
};

function web_of_power_actions:set_performing_character_highest_not_max_level_vampire(faction, ritual_setup, performing_character_slot)
	local max_level_characters = {}
	local not_max_level_characters = {}
	local max_level = 50

	local character_list = faction:character_list()
	local character_count = character_list:num_items() - 1
	for i = 0, character_count do
		local character = character_list:item_at(i)
		if character:character_subtype_key() == "wh3_dlc29_vmp_lahmian_vampire" and not character:is_wounded() then
			if character:rank() < max_level then
				table.insert(not_max_level_characters, character)
			else
				table.insert(max_level_characters, character)
			end
		end
	end

	table.sort(
		not_max_level_characters,
		function(lhs_char, rhs_char)
			return lhs_char:rank() > rhs_char:rank()
		end
	)

	for _, character in ipairs(not_max_level_characters) do
		local family_member = character:family_member()
		local status = performing_character_slot:status_with_performer(ritual_setup, family_member)
		if status:valid() then
			performing_character_slot:set_performer(ritual_setup, family_member)
			return true
		end
	end

	for _, character in ipairs(max_level_characters) do
		local family_member = character:family_member()
		local status = performing_character_slot:status_with_performer(ritual_setup, family_member)
		if status:valid() then
			performing_character_slot:set_performer(ritual_setup, family_member)
			return true
		end
	end
end

function web_of_power_actions:target_highest_level_enemy_character(faction, target_slot)
	local highest_level = -1
	local highest_ranked_character = nil
	local factions_at_war = faction:factions_at_war_with()
	for i = 0, factions_at_war:num_items() - 1 do
		local enemy_faction = factions_at_war:item_at(i)
		if cm:faction_is_alive(enemy_faction) then
			local character_list = enemy_faction:character_list()
			local character_count = character_list:num_items() - 1
			for j = 0, character_count do
				local character = character_list:item_at(j)
				if not character:is_wounded() then
					local rank = character:rank()
					if rank > highest_level then
						highest_level = rank
						highest_ranked_character = character
					end
				end
			end
		end
	end
	if highest_ranked_character then
		target_slot:set_target_character(highest_ranked_character)
		return true
	end

	--Look for highest level character of lowest relations known faction
	highest_level = -1
	highest_ranked_character = nil
	local lowest_relation = 1000000
	local lowest_relation_faction

	local factions_met = faction:factions_met()
	for i = 0, factions_met:num_items() - 1 do
		local faction_met = factions_met:item_at(i)
		if cm:faction_is_alive(faction_met) then
			local relation = faction:diplomatic_attitude_towards(faction_met:name())
			if relation < lowest_relation then
				lowest_relation = relation
				lowest_relation_faction = faction_met
			end
		end
	end

	if not lowest_relation_faction then
		return false
	end

	local character_list = lowest_relation_faction:character_list()
	local character_count = character_list:num_items() - 1
	for i = 0, character_count do
		local character = character_list:item_at(i)
		if not character:is_wounded() then
			local rank = character:rank()
			if rank > highest_level then
				highest_level = rank
				highest_ranked_character = character
			end
		end
	end

	if highest_ranked_character then
		target_slot:set_target_character(highest_ranked_character)
		return true
	end
end

function web_of_power_actions:initialise()
	self:add_listeners();
end

function web_of_power_actions:add_listeners()
	core:add_listener(
		"FactionTurnStartWebOfPower",
		"FactionTurnStart",
		true,
		function(context)
			local faction = context:faction()
			local faction_key = faction:name()
			
			local turn_number = cm:turn_number() + 1
			if web_of_power_actions.track_diplomacy[faction_key]
				and web_of_power_actions.track_diplomacy[faction_key] == turn_number
			then
				web_of_power_actions.track_diplomacy[faction_key] = nil;
				cm:force_diplomacy("faction:"..faction_key, "faction:"..web_of_power_actions.config.neferata_faction_key, "all", true, true, false);
			end

			if turn_number % web_of_power_ai_config.turn_delay == 0
				and  faction_key == web_of_power_actions.config.neferata_faction_key
				and not faction:is_human()
			then
				local possible_rituals = weighted_list:new()
				local ritual_setups = {}
				for ritual_key, ritual_data in dpairs(web_of_power_actions.rituals) do
					local ritual_status = faction:rituals():ritual_status(ritual_key)
					if ritual_status and not ritual_status:is_null_interface()
						and not faction:rituals():ritual_status(ritual_key):cannot_afford_resource_cost()
					then
						local setup = cm:create_new_ritual_setup(faction, ritual_key)
						table.insert(ritual_setups, setup)
						possible_rituals:add_item(ritual_data, ritual_data.ai_priority)
					end
				end

				local ritual_performed = false
				if not possible_rituals:is_empty() then
					local selected_ritual_data, index = possible_rituals:weighted_select()
					local ritual_setup = ritual_setups[index]
					local performing_character_slot = ritual_setup:performing_characters():item_at(0)
					local performing_character_result = selected_ritual_data.set_ai_performing_character(faction, ritual_setup, performing_character_slot)
					if performing_character_result then
						local target_slot = ritual_setup:target()
						local target_result = selected_ritual_data.set_ai_target(faction, target_slot)
						if target_result then
							cm:perform_ritual_with_setup(ritual_setup)
							ritual_performed = true
						end
					end
				end
				if not ritual_performed then
					cm:faction_add_pooled_resource(web_of_power_actions.config.neferata_faction_key, "wh3_dlc29_nef_manipulation", "neferata", turn_number * 10);
				end
			end
		end,
		true
	);
	core:add_listener(
		"RitualCompletedEventWebOfPower",
		"RitualCompletedEvent",
		function(context)
            return context:succeeded() == true and context:ritual():ritual_category() == "NEFERATA_RITUAL";
		end,
		function(context)
            local ritual = context:ritual();
			local ritual_key = ritual:ritual_key();
			local preforming_fm = ritual:characters_who_performed():item_at(0);
			local performing_character = preforming_fm:character();
            local ritual_callback = web_of_power_actions.rituals[ritual_key].callback;
            local ritual_xp = web_of_power_actions.rituals[ritual_key].xp;

            if ritual_callback ~= nil then
                ritual_callback(context, performing_character);
            end
			if ritual_xp ~= nil then
				cm:add_agent_experience_through_family_member(preforming_fm, ritual_xp);
			end
        end,
        true
    );
	core:add_listener(
		"CharacterTurnEndWebOfPower",
		"CharacterTurnEnd",
		true,
		function(context)
			local character = context:character();

			if character:has_military_force() == true then
				local military_force = character:military_force();

				if military_force:has_effect_bundle("wh3_dlc29_neferata_actions_block_movement") then
					cm:remove_effect_bundle_from_force("wh3_dlc29_neferata_actions_block_movement", military_force:command_queue_index());
				end
			end
		end,
		true
	);
	core:add_listener(
		"ContextUITriggerEventDev",
		"ContextUITriggerEvent",
		function(context)
			return context.string == "dev_button_cap";
		end,
		function(context)
			cm:apply_effect_bundle("wh3_main_effect_neferata_manipulation_capacity", web_of_power_actions.config.neferata_faction_key, 0);
			cm:faction_add_pooled_resource(web_of_power_actions.config.neferata_faction_key, "wh3_dlc29_nef_manipulation", "neferata", 10);
		end,
		true
	);
end

function web_of_power_actions:find_valid_ancillaries(cqi)
	local target_cco = cco("CcoCampaignCharacter", cqi);

	if not target_cco then
		return false;
	end

	local char_list = cm:get_faction(web_of_power_actions.config.neferata_faction_key):character_list();

	-- get a list of valid ancillaries
	local available_ancillaries = {};
	local num_ancillaries = target_cco:Call("AncillaryList.Size");

	if not num_ancillaries then
		return false;
	end

	for i = 0, num_ancillaries - 1 do
		local current_ancillary = target_cco:Call("AncillaryList.At(" .. i .. ").AncillaryRecordContext.Key");

		if current_ancillary then
			for _, character in model_pairs(char_list) do
				if character:can_equip_ancillary(current_ancillary) then
					table.insert(available_ancillaries, current_ancillary);
					break;
				end
			end
		end
	end
	return available_ancillaries;
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("web_of_power_actions.track_diplomacy", web_of_power_actions.track_diplomacy, context);
	end
);
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			web_of_power_actions.track_diplomacy = cm:load_named_value("web_of_power_actions.track_diplomacy", web_of_power_actions.track_diplomacy, context);
		end
	end
);