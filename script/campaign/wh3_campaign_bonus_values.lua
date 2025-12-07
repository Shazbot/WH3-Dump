-- upgrade aislinn units on research
core:add_listener(
	"aislinn_tech_unit_upgrade",
	"ResearchCompleted", 
	function(context)
		return context:technology() == "wh3_dlc27_tech_hef_aislinn_6_11";
	end,
	function(context)
		local faction = context:faction();
		local military_force_list = faction:military_force_list();
			
		for i = 0, military_force_list:num_items() - 1 do
			local mf = military_force_list:item_at(i);

			if mf:is_armed_citizenry() == false then
				local unit_list = mf:unit_list();

				for j = 0, unit_list:num_items() - 1 do
					local unit = unit_list:item_at(j);
					local unit_key = unit:unit_key();

					if unit_key == "wh2_main_hef_inf_lothern_sea_guard_0" then
						cm:convert_unit(unit:command_queue_index(), "wh2_main_hef_inf_lothern_sea_guard_1");
					elseif unit_key == "wh2_main_hef_inf_archers_0" then
						cm:convert_unit(unit:command_queue_index(), "wh2_main_hef_inf_archers_1");
					end
				end
			end
		end
	end,
	true
);

-- chance to kill unit in army
core:add_listener(
	"random_unit_killed_per_turn_chance",
	"CharacterTurnStart",
	true,
	function(context)
		local character = context:character();

		if character:is_null_interface() == false and character:has_military_force() == true and character:character_type("general") == true then
			local force = character:military_force();
			local value = cm:get_forces_bonus_value(force, "random_unit_killed_per_turn_chance");

			if value > 0 and cm:model():random_percent(value) then
				local unit_list = force:unit_list();

				if unit_list:num_items() >= 2 then
					local possible_units = weighted_list:new();

					for i = 1, unit_list:num_items() - 1 do
						local unit = unit_list:item_at(i);
						possible_units:add_item(unit:unit_key(), 1);
					end

					if #possible_units.items > 0 then
						local selected_unit, index = possible_units:weighted_select();
						local general_lookup_str = cm:char_lookup_str(character);
						cm:remove_unit_from_character(general_lookup_str, selected_unit);
					end
				end
			end
		end
	end,
	true
);

-- chance to raze the region if it has no buildings
core:add_listener(
	"raze_region_with_no_buildings_chance",
	"RegionTurnStart",
	true,
	function(context)
		local region = context:region();

		if region:is_abandoned() == false then
			local value = cm:get_regions_bonus_value(region, "raze_region_with_no_buildings_chance");

			if value > 0 and cm:model():random_percent(value) then
				local settlement = region:settlement();
				local slot_list = settlement:active_secondary_slots();

				if slot_list:num_items() >= 1 then
					for i = 0, slot_list:num_items() - 1 do
						local current_slot = slot_list:item_at(i);

						if current_slot:has_building() == true and current_slot:type() ~= "port" then
							return true;
						end
					end
				end
				
				cm:callback(
					function()
						cm:set_region_abandoned(region:name());
					end,
					0.5
				);
			end
		end
	end,
	true
);

-- chance to demolish building in region
core:add_listener(
	"random_building_destroyed_per_turn_chance",
	"RegionTurnStart",
	true,
	function(context)
		local region = context:region();

		if region:is_abandoned() == false then
			local value = cm:get_regions_bonus_value(region, "random_building_destroyed_per_turn_chance");

			if value > 0 and cm:model():random_percent(value) then
				local possible_buildings = weighted_list:new();
				local settlement = region:settlement();
				local slot_list = settlement:active_secondary_slots();

				for i = 0, slot_list:num_items() - 1 do
					local current_slot = slot_list:item_at(i);
					
					if current_slot:type() ~= "port" then
						if current_slot:has_building() == true then
							possible_buildings:add_item(current_slot, 1);
						end
					end
				end
				
				if #possible_buildings.items > 0 then
					local selected_slot, index = possible_buildings:weighted_select();
					cm:instantly_dismantle_building_in_region(selected_slot);
				end
			end
		end
	end,
	true
);

-- chance to spawn Slaanesh cult in your regions
core:add_listener(
	"AncillaryChanceFaction",
	"FactionTurnStart",
	true,
	function(context)
		local faction = context:faction();
		local value = cm:get_factions_bonus_value(faction, "slaanesh_cult_spawned_in_own_territory_chance");

		if value > 0 and cm:model():random_percent(value) then
			local possible_regions = weighted_list:new();
			local region_list = faction:region_list();

			local cult_faction = cm:get_faction("wh3_main_sla_seducers_of_slaanesh");

			if cult_faction == nil or cult_faction:is_null_interface() == true or cult_faction:is_human() == true then
				cult_faction = cm:get_faction("wh3_main_sla_rapturous_excess");
				
				if cult_faction == nil or cult_faction:is_null_interface() == true or cult_faction:is_human() == true then
					cult_faction = cm:get_faction("wh3_main_sla_subtle_torture");

					if cult_faction == nil or cult_faction:is_null_interface() == true or cult_faction:is_human() == true then
						cult_faction = cm:get_faction("wh3_dlc20_sla_keepers_of_bliss");
					end
				end
			end

			for i = 0, region_list:num_items() - 1 do
				local possible_region = region_list:item_at(i);
				local slot_manager = possible_region:foreign_slot_manager_for_faction(cult_faction:name());

				if possible_region:is_abandoned() == false and slot_manager:is_null_interface() == true then
					possible_regions:add_item(possible_region, 1);
				end
			end

			if #possible_regions.items > 0 then
				local selected_region, index = possible_regions:weighted_select();
				cm:add_foreign_slot_set_to_region_for_faction(cult_faction:command_queue_index(), selected_region:cqi(), "wh3_main_slot_set_sla_cult");
			end
		end
	end,
	true
);

-- chance to raze random regions per turn
core:add_listener(
	"raze_region_chance",
	"RegionTurnStart",
	true,
	function(context)
		local region = context:region();
		local region_owner = region:owning_faction();
		local raze_chance = cm:get_regions_bonus_value(region, "raze_region_in_province_chance");

		if raze_chance > 0 and cm:model():random_percent(raze_chance) then
			local possible_regions = weighted_list:new();
			local region_list = region:province():regions();

			for i = 0, region_list:num_items() - 1 do
				local possible_region = region_list:item_at(i);

				if possible_region:is_abandoned() == false and possible_region:cqi() ~= region:cqi() then
					possible_regions:add_item(possible_region, 1);
				end
			end

			if #possible_regions.items > 0 then
				local selected_region, index = possible_regions:weighted_select();
				cm:set_region_abandoned(selected_region:name());
				core:trigger_event("ScriptEventRazedRegionProvinceBonusValue", region_owner, selected_region);
				return true;
			end
		end

		local world_raze_chance = cm:get_regions_bonus_value(region, "raze_region_in_world_chance");

		if world_raze_chance > 0 and cm:model():random_percent(world_raze_chance) then
			local possible_regions = weighted_list:new();
			local region_list = cm:model():world():region_manager():region_list();

			for i = 0, region_list:num_items() - 1 do
				local possible_region = region_list:item_at(i);

				if possible_region:is_abandoned() == false and possible_region:cqi() ~= region:cqi() then
					local possible_region_owner = possible_region:owning_faction();

					if region_owner:at_war_with(possible_region_owner) == false then
						possible_regions:add_item(possible_region, 1);
					end
				end
			end

			if #possible_regions.items > 0 then
				local selected_region, index = possible_regions:weighted_select();
				cm:set_region_abandoned(selected_region:name());
				core:trigger_event("ScriptEventRazedRegionWorldwideBonusValue", region_owner, selected_region);
				return true;
			end
		end
	end,
	true
);

core:add_listener(
	"sea_lanes_character_arrived_bonus",
	"TeleportationNetworkMoveCompleted",
	true,
	function(context)
		if context:character():is_null_interface() == false and context:character():character():is_null_interface() == false then
			local character = context:character():character();
			local value = cm:get_factions_bonus_value(character:faction(), "sea_lane_exit_movement_points");

			if value > 0 then
				local character_cqi = character:command_queue_index();
				local ap = value / 100;
				cm:replenish_action_points(cm:char_lookup_str(character_cqi), ap);
			end
		end
	end,
	true	
);

-- experience_levels_for_ruin_colonization
core:add_listener(
	"experience_levels_for_ruin_colonization",
	"CharacterPerformsSettlementOccupationDecision",
	true,
	function(context)
		local otype = context:occupation_decision_type();

		if otype == "occupation_decision_colonise" then
			local faction = context:character():faction();
			local value = cm:get_factions_bonus_value(faction, "experience_levels_for_ruin_colonization");

			if value > 0 then
				local char = context:character();
				cm:add_experience_to_units_commanded_by_character(cm:char_lookup_str(char), 1);
			end
		end
	end,
	true
);

-- settle_bonus_control_wasteland
core:add_listener(
	"settle_bonus_control_wasteland",
	"RegionFactionChangeEvent",
	true,
	function(context) 
		local faction = context:region():owning_faction();
		local value = cm:get_factions_bonus_value(faction, "settle_bonus_control_wasteland");

		if value > 0 then
			local region = context:region();
			local climate = region:settlement():get_climate();

			if climate == "climate_chaotic" then
				local public_order = region:public_order();
				local new_value = public_order + value;
				cm:set_public_order_of_province_for_region(region:name(), new_value);
			end
		end
	end,
	true
);

-- ruin_colonization_accelerator
core:add_listener(
	"ruin_colonization_accelerator",
	"CharacterPerformsSettlementOccupationDecision",
	true,
	function(context)
		local otype = context:occupation_decision_type();

		if otype == "occupation_decision_colonise" then
			local faction = context:character():faction();
			local value = cm:get_factions_bonus_value(faction, "ruin_colonization_accelerator");

			if value > 0 then
				local region_key = context:garrison_residence():region():name();
				cm:apply_effect_bundle_to_region("wh3_main_ksl_colonization_speedup", region_key, value);
			end
		end
	end,
	true
);

-- post_action_ancillary
core:add_listener(
	"agent_action_ancillary_chance_character",
	"CharacterCharacterTargetAction",
	true,
	function (context)
		local faction = context:character():faction();
		agent_action_ancillary_chance(faction);
	end,
	true
);

core:add_listener(
	"agent_action_ancillary_chance_garrison",
	"CharacterGarrisonTargetAction",
	true,
	function(context)
		local faction = context:character():faction();
		agent_action_ancillary_chance(faction);
	end,
	true
);

function agent_action_ancillary_chance(faction)
	local value = cm:get_factions_bonus_value(faction, "post_action_ancillary");

	if cm:model():random_percent(value) then
		local ancillary_key = get_random_ancillary_key_for_faction(faction:name(), false, false);
		cm:add_ancillary_to_faction(faction, ancillary_key, false);
	end
end

-- ancillary_per_turn_chance
core:add_listener(
	"AncillaryChanceFaction",
	"FactionTurnStart",
	true,
	function(context)
		local faction = context:faction();
		local value = cm:get_factions_bonus_value(faction, "ancillary_per_turn_chance");

		if value > 0 and cm:model():random_percent(value) then
			local ancillary_key = get_random_ancillary_key_for_faction(faction:name(), false, false);
			cm:add_ancillary_to_faction(faction, ancillary_key, false);
		end
	end,
	true
);

-- elector_fealty_per_turn_chance
core:add_listener(
	"ElectorFealtyChanceFaction",
	"FactionTurnStart",
	true,
	function(context)
		local faction = context:faction();
		local value = cm:get_factions_bonus_value(faction, "elector_fealty_per_turn_chance");

		if value > 0 and cm:model():random_percent(value) then 
			local elector_factions = {
				"wh_main_emp_empire",
				"wh_main_emp_averland",
				"wh_main_emp_hochland",
				"wh_main_emp_middenland",
				"wh_main_emp_nordland",
				"wh_main_emp_ostermark",
				"wh_main_emp_ostland",
				"wh_main_emp_stirland",
				"wh_main_emp_talabecland",
				"wh_main_emp_wissenland"
			};
			cm:shuffle_table(elector_factions);
		
			for i = 1, #elector_factions do
				local elector = cm:model():world():faction_by_key(elector_factions[i]);
		
				if elector:is_null_interface() == false and elector:is_human() == false then
					if elector:pooled_resource_manager():resource("emp_loyalty"):is_null_interface() == false then
						cm:faction_add_pooled_resource(elector_factions[i], "emp_loyalty", "buildings", 1);
						break;
					end
				end
			end
		end
	end,
	true
);

core:add_listener(
	"MaadMapCharacterTurnEnd",
	"CharacterTurnEnd",
	function(context)
		return context:character():has_ancillary("wh3_main_anc_enchanted_item_maads_map");
	end,
	function(context)
		if cm:model():random_percent(20) then
			local possible_regions = weighted_list:new();

			local character = context:character();

			-- For now we exclude camps, in future we should add an ancillary blacklist as whitelisting is problematic
			if character:character_subtype("wh3_main_ogr_tyrant_camp") == true then
				return;
			end

			if character:has_region() == true and character:is_at_sea() == false and character:in_settlement() == false and character:is_besieging() == false and character:is_embedded_in_military_force() == false then
				local region = character:region();

				if region:is_null_interface() == false then
					local adj_regions = region:adjacent_region_list();
					
					if adj_regions:is_empty() == false then
						for i = 0, adj_regions:num_items() - 1 do
							local adj_region = adj_regions:item_at(i):name();
							possible_regions:add_item(adj_region, 1);
						end

						if #possible_regions.items > 0 then
							local selected_region, index = possible_regions:weighted_select();
							local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(character:faction():name(), selected_region, false, false, 19);

							if pos_x > -1 and pos_y > -1 then
								cm:teleport_to(cm:char_lookup_str(character), pos_x, pos_y);
							end
						end
					end
				end
			end
		end
	end,
	true
);

core:add_listener(
	"SisterSwordsFactionTurnStart",
	"FactionTurnStart",
	function(context)
		return context:faction():ancillary_exists("wh3_main_anc_weapon_elthraician") and context:faction():ancillary_exists("wh3_main_anc_weapon_cynatcian");
	end,
	function(context)
		local chance_percent_per_ancillary = 5

		local elthraician_character = nil;
		local elthraician_region = -1;
		local cynatcian_character = nil;
		local cynatcian_region = -2;
		local faction = context:faction();
		local char_list = faction:character_list();

		for i = 0, char_list:num_items() - 1 do
			local char = char_list:item_at(i);
			
			if char:has_ancillary("wh3_main_anc_weapon_elthraician") == true then
				if char:has_region() == true then
					elthraician_character = char;
					elthraician_region = char:region():cqi();
				end
			end
			if char:has_ancillary("wh3_main_anc_weapon_cynatcian") == true then
				if char:has_region() == true then
					cynatcian_character = char;
					cynatcian_region = char:region():cqi();
				end
			end
		end

		if elthraician_character == nil or cynatcian_character == nil then
			return
		end

		local is_same_character = elthraician_character == cynatcian_character
		local chance_percent = is_same_character and chance_percent_per_ancillary * 2 or chance_percent_per_ancillary
		if not cm:model():random_percent(chance_percent) then
			return
		end
		
		local trait_id = "wh3_trait_sister_swords"
		if elthraician_character == cynatcian_character then
			campaign_traits:give_trait(elthraician_character, trait_id, 1, 100);
		elseif elthraician_region == cynatcian_region then
			campaign_traits:give_trait(elthraician_character, trait_id, 1, 100);
			campaign_traits:give_trait(cynatcian_character, trait_id, 1, 100);
		end
	end,
	true
);

core:add_listener(
	"DraescaHelmFactionTurnEnd",
	"FactionTurnEnd",
	function(context)
		return context:faction():ancillary_exists("wh3_main_anc_armour_helm_of_draesca");
	end,
	function(context)
		local helm_death_chance = 1;
		local helm_trait_chance = 2;
		local faction = context:faction();
		local char_list = faction:character_list();

		for i = 0, char_list:num_items() - 1 do
			local char = char_list:item_at(i);
			
			if char:has_ancillary("wh3_main_anc_armour_helm_of_draesca") == true then
				if char:has_military_force() == true or char:is_embedded_in_military_force() == true then
					local cqi = char:command_queue_index();

					if cm:model():random_percent(helm_trait_chance) then
						campaign_traits:give_trait(char, "wh3_trait_draesca", 1, 100);
					elseif cm:model():random_percent(helm_death_chance) then
						if char:character_details():is_immortal() == true then
							if char:is_wounded() == false then
								-- Use minimum time of 2 instead of 1 because this happens during end turn; 1 would mean the character is available immediately at the start of the next turn.
								local convalescence_time = math.max(2, char:compute_convalesence_time());
								cm:wound_character("character_cqi:"..cqi, convalescence_time);
							end
						else
							cm:kill_character(cqi, false);
						end
					end
				end
				break; -- We can break out because only one of these items exists
			end
		end
	end,
	true
);

core:add_listener(
	"AldredsCasketCharacterTurnStart",
	"CharacterTurnStart",
	function(context)
		return context:character():has_region() and context:character():has_ancillary("wh3_main_anc_enchanted_item_aldreds_casket");
	end,
	function(context)
		local province = context:character():region():province();
		cm:force_winds_of_magic_change(province:key(), "wom_strength_0");
	end,
	true
);

-- instantly discover under-cities
core:add_listener(
	"SkavenMapCharacterTurnEnd",
	"CharacterTurnEnd",
	function(context)
		return context:character():has_region();
	end,
	function(context)
		local character = context:character();
		local bonus_value = cm:get_characters_bonus_value(character, "under_empire_discovery");
		
		if bonus_value > 0 then
			local current_region = character:region();
			
			if current_region:foreign_slot_managers():is_empty() == false then
				local foreign_slots = current_region:foreign_slot_managers();
					
				for i = 0, foreign_slots:num_items() - 1 do
					local foreign_slot = foreign_slots:item_at(i);
					
					if foreign_slot:is_null_interface() == false then
						local foreign_slot_faction = foreign_slot:faction();
						
						if foreign_slot_faction:culture() == "wh2_main_skv_skaven" then
							cm:foreign_slot_set_reveal_to_faction(character:faction(), foreign_slot);
						end
					end
				end
			end
		end
	end,
	true
);

-- campaign_movement_range_post_battle_win
core:add_listener(
	"campaign_movement_range_post_battle_win",
	"CharacterCompletedBattle",
	function(context)
		return context:character():won_battle();
	end,
	function(context)
		local character = context:character();
		local bonus_value = cm:get_characters_bonus_value(character, "campaign_movement_range_post_battle_win");
		
		if bonus_value > 0 then
			cm:replenish_action_points(cm:char_lookup_str(character), (character:action_points_remaining_percent() + bonus_value) / 100);
		end;
	end,
	true
);

--campaign_movement_range_post_enemy_retreat
core:add_listener(
	"campaign_movement_range_post_enemy_retreat",
	"CharacterWithdrewFromBattle",
	function(context)
		local pb = cm:model():pending_battle()
		local attacker = pb:attacker()
		local attacker_cqi = attacker:command_queue_index() 
		local withdrawer_cqi = context:character():command_queue_index()
		return cm:get_characters_bonus_value(attacker, "campaign_movement_range_post_enemy_retreat") > 0 and attacker_cqi ~= withdrawer_cqi
	end,
	function(context)
		local pb = cm:model():pending_battle()
		local attacker = pb:attacker()
		local movement_to_replenish = cm:get_characters_bonus_value(attacker, "campaign_movement_range_post_enemy_retreat")
		cm:replenish_action_points(cm:char_lookup_str(attacker), (attacker:action_points_remaining_percent() + movement_to_replenish) / 100)
	end,
	true
);

-- extra development point when capturing a settlement
core:add_listener(
	"nurgle_bonus_dev_point_on_capture",
	"GarrisonOccupiedEvent",
	function(context)
		return cm:get_characters_bonus_value(context:character(), "bonus_development_point_on_occupy") > 0;
	end,
	function(context)
		cm:add_development_points_to_region(context:garrison_residence():region():name(), cm:get_characters_bonus_value(context:character(), "bonus_development_point_on_occupy"));
	end,
	true
);

-- Nurgle tech effect - growth in every owned region with climate
core:add_listener(
	"growth_in_climate_turn_start",
	"FactionTurnStart",
	true,
	function(context)
		local faction = context:faction();
		give_climate_growth(faction)
	end,
	true
);

-- Nurgle tech effect - growth in every owned region with climate
core:add_listener(
	"growth_in_climate_region_capture",
	"GarrisonOccupiedEvent",
	true,
	function(context)
		local faction = context:character():faction();
		give_climate_growth(faction)
	end,
	true
);

--- Nurgle Tech effect - generate income when building cycles complete
core:add_listener(
	"income_when_cycle_end",
	"BuildingLifecycleDevelops", 
	function(context)
		local value = cm:get_regions_bonus_value(context:region(), "cycle_building_completion_earn_income")
		return value > 0
	end,
	function(context)
		if context:region():owning_faction():is_human() then
			local faction = context:region():owning_faction():name()
			local value = cm:get_regions_bonus_value(context:region(), "cycle_building_completion_earn_income")
			cm:treasury_mod(faction, value)
		end	
	end,
	true
);

function give_climate_growth(faction)
	local growth_in_climate_chaotic = cm:get_factions_bonus_value(faction, "growth_in_climate_chaotic");
	local growth_in_climate_frozen = cm:get_factions_bonus_value(faction, "growth_in_climate_frozen");
	local growth_in_climate_mountain = cm:get_factions_bonus_value(faction, "growth_in_climate_mountain");
	local growth_in_climate_temperate = cm:get_factions_bonus_value(faction, "growth_in_climate_temperate");
	
	if growth_in_climate_chaotic > 0 or growth_in_climate_frozen > 0 or growth_in_climate_mountain > 0 or growth_in_climate_temperate > 0 then
		local growth_bundle_chaotic = cm:create_new_custom_effect_bundle("wh3_main_climate_growth_chaotic");
		growth_bundle_chaotic:add_effect("wh_main_effect_province_growth_tech", "region_to_province_own", growth_in_climate_chaotic);
		growth_bundle_chaotic:set_duration(0);
		
		local growth_bundle_frozen = cm:create_new_custom_effect_bundle("wh3_main_climate_growth_frozen");
		growth_bundle_frozen:add_effect("wh_main_effect_province_growth_tech", "region_to_province_own", growth_in_climate_frozen);
		growth_bundle_frozen:set_duration(0);
		
		local growth_bundle_mountain = cm:create_new_custom_effect_bundle("wh3_main_climate_growth_mountain");
		growth_bundle_mountain:add_effect("wh_main_effect_province_growth_tech", "region_to_province_own", growth_in_climate_mountain);
		growth_bundle_mountain:set_duration(0);
		
		local growth_bundle_temperate = cm:create_new_custom_effect_bundle("wh3_main_climate_growth_temperate");
		growth_bundle_temperate:add_effect("wh_main_effect_province_growth_tech", "region_to_province_own", growth_in_climate_temperate);
		growth_bundle_temperate:set_duration(0);
		
		local region_list = faction:region_list();
		
		local function apply_custom_climate_growth_effect_bundle(region, region_climate, test_climate, bonus_value, effect_bundle)
			if region_climate == test_climate and bonus_value > 0 then
				local key = effect_bundle:key();
				
				if region:has_effect_bundle(key) then
					cm:remove_effect_bundle_from_region(key, region:name());
				end;
				
				cm:apply_custom_effect_bundle_to_region(
					effect_bundle,
					region
				);
			end;
		end;
		
		for i = 0, region_list:num_items() - 1 do
			local region = region_list:item_at(i);
			local climate = region:settlement():get_climate();
			
			apply_custom_climate_growth_effect_bundle(region, climate, "climate_chaotic", growth_in_climate_chaotic, growth_bundle_chaotic);
			apply_custom_climate_growth_effect_bundle(region, climate, "climate_frozen", growth_in_climate_frozen, growth_bundle_frozen);
			apply_custom_climate_growth_effect_bundle(region, climate, "climate_mountain", growth_in_climate_mountain, growth_bundle_mountain);
			apply_custom_climate_growth_effect_bundle(region, climate, "climate_temperate", growth_in_climate_temperate, growth_bundle_temperate);
		end;
	end;
end;

--Earn Infection Points on Plague Spread
core:add_listener(
	"PlagueInfectionForceInfections",
	"MilitaryForceInfectionEvent",
	function(context)
		return cm:get_forces_bonus_value(context:target_force(), "nurgle_plague_spread_earn_infections") > 0;
	end,
	function(context)
		local plague_interface = context:plague();
		local is_created = context:is_creation();
		
		local plague_owner = context:faction();
		local target_force = context:target_force();
		
		local value = cm:get_forces_bonus_value(context:target_force(), "nurgle_plague_spread_earn_infections");
		cm:faction_add_pooled_resource(plague_owner:name(), "wh3_main_nur_infections", "plague_spread", value);
	end,
	true
);

core:add_listener(
	"PlagueInfectionRegionInfections",
	"RegionInfectionEvent",
	function(context)
		return cm:get_regions_bonus_value(context:target_region(), "nurgle_plague_spread_earn_infections") > 0;
	end,
	function(context)
		local plague_interface = context:plague();
		local is_created = context:is_creation();
		
		local plague_owner = context:faction();
		local target_region = context:target_region();
		
		local value = cm:get_regions_bonus_value(context:target_region(), "nurgle_plague_spread_earn_infections");
		cm:faction_add_pooled_resource(plague_owner:name(), "wh3_main_nur_infections", "plague_spread", value);
	end,
	true
);


--Earn Treasury on Plague Spread
core:add_listener(
	"PlagueInfectionForceFavour",
	"MilitaryForceInfectionEvent",
	function(context)
		return cm:get_forces_bonus_value(context:target_force(), "nurgle_plague_spread_earn_favour") > 0;
	end,
	function(context)
		local plague_interface = context:plague();
		local is_created = context:is_creation();
		
		local plague_owner = context:faction();
		local target_force = context:target_force();
		
		local value = cm:get_forces_bonus_value(context:target_force(), "nurgle_plague_spread_earn_favour");
		cm:treasury_mod(plague_owner:name(), value);
	end,
	true
);

core:add_listener(
	"PlagueInfectionRegionFavour",
	"RegionInfectionEvent",
	function(context)
		return cm:get_regions_bonus_value(context:target_region(), "nurgle_plague_spread_earn_favour") > 0;
	end,
	function(context)
		local plague_interface = context:plague();
		local is_created = context:is_creation();
		
		local plague_owner = context:faction();
		local target_region = context:target_region();
		
		local value = cm:get_regions_bonus_value(context:target_region(), "nurgle_plague_spread_earn_favour");
		cm:treasury_mod(plague_owner:name(), value);
	end,
	true
);

--Earn Nurglings on Plague Spread
core:add_listener(
	"PlagueInfectionForceNurglings",
	"MilitaryForceInfectionEvent",
	function(context)
		return cm:get_forces_bonus_value(context:target_force(), "nurgle_plague_spread_earn_nurglings") > 0;
	end,
	function(context)
		local plague_interface = context:plague();
		local is_created = context:is_creation();
		
		local plague_owner = context:faction();
		local target_force = context:target_force();
		
		local value = cm:get_forces_bonus_value(context:target_force(), "nurgle_plague_spread_earn_nurglings")
		cm:add_units_to_faction_mercenary_pool(plague_owner:command_queue_index(), "wh3_main_nur_inf_nurglings_0", value);
		out.design("Add Nurgling to the pool");
	end,
	true
);

core:add_listener(
	"PlagueInfectionRegionNurglings",
	"RegionInfectionEvent",
	function(context)
		return cm:get_regions_bonus_value(context:target_region(), "nurgle_plague_spread_earn_nurglings") > 0;
	end,
	function(context)
		local plague_interface = context:plague();
		local is_created = context:is_creation();
		
		local plague_owner = context:faction();
		local target_region = context:target_region();
		
		local value = cm:get_regions_bonus_value(context:target_region(), "nurgle_plague_spread_earn_nurglings");
		cm:add_units_to_faction_mercenary_pool(plague_owner:command_queue_index(), "wh3_main_nur_inf_nurglings_0", value);
		out.design("Add Nurgling to the pool");
	end,
	true
);


--give sight on plague spread
core:add_listener(
	"PlagueInfectionRegionSight",
	"RegionInfectionEvent",
	function(context)
		local faction = context:faction();
		
		return faction:is_human() and cm:get_factions_bonus_value(faction, "plague_sight") > 0;
	end,
	function(context)
		cm:make_region_visible_in_shroud(context:faction():name(), context:target_region():name())
	end,
	true
);

core:add_listener(
	"PlagueInfectionRegionSight",
	"MilitaryForceInfectionEvent",
	function(context)
		local faction = context:faction()
		
		return faction:is_human() and cm:get_factions_bonus_value(faction, "plague_sight") > 0
	end,
	function(context)
		local target_general = context:target_force():general_character();
		if target_general:is_null_interface() == false then
			if target_general:has_region() then
				cm:make_region_visible_in_shroud(context:faction():name(), target_general:region():name())
			end
		end
	end,
	true
)

--Earn Souls Points on Plague Spread

local function grant_plague_spread_souls(plague_faction)
	local value = cm:get_factions_bonus_value(plague_faction, "plague_spread_earn_souls")
	cm:faction_add_pooled_resource(plague_faction:name(), "wh3_dlc20_chs_souls", "wh3_dlc20_souls_other", value);
end

core:add_listener(
	"PlagueInfectionForceSouls",
	"MilitaryForceInfectionEvent",
	function(context)
		local plague_owner = context:faction(); 
		return cm:get_factions_bonus_value(plague_owner, "plague_spread_earn_souls") > 0;
	end,
	function(context)
		local plague_owner = context:faction();
		grant_plague_spread_souls(plague_owner)
	end,
	true
);

core:add_listener(
	"PlagueInfectionRegionSouls",
	"RegionInfectionEvent",
	function(context)
		local plague_owner = context:faction(); 
		return cm:get_factions_bonus_value(plague_owner, "plague_spread_earn_souls") > 0;
	end,
	function(context)
		local plague_owner = context:faction();
		grant_plague_spread_souls(plague_owner)
	
	end,
	true
);

-- extra growth for camp in enemy territory, on turn roll
core:add_listener(
	"ogr_camp_growth_enemy_region_turn_start",
	"FactionTurnStart",
	function(context)
		return cm:get_factions_bonus_value(context:faction(), "camp_growth_enemy_territory") > 0;
	end,
	function(context)
		camp_growth_not_owned_territory(context:faction());
	end,
	true
);
-- extra growth for camp in enemy territory, when spawned
core:add_listener(
	"ogr_camp_growth_enemy_region_camp_spawned",
	"CharacterCreated",
	function(context)
		return cm:get_factions_bonus_value(context:character():faction(), "camp_growth_enemy_territory") > 0;
	end,
	function(context)
		camp_growth_not_owned_territory(context:character():faction());
	end,
	true
);
-- extra growth for camp in enemy territory, when settlement captured
core:add_listener(
	"ogr_camp_growth_enemy_region_settlement_cap",
	"GarrisonOccupiedEvent",
	function(context)
		return cm:get_factions_bonus_value(context:character():faction(), "camp_growth_enemy_territory") > 0 
			or cm:get_factions_bonus_value(context:garrison_residence():faction(), "camp_growth_enemy_territory") > 0;
	end,
	function(context)
		if cm:get_factions_bonus_value(context:character():faction(), "camp_growth_enemy_territory") > 0 then
			camp_growth_not_owned_territory(context:character():faction());		
		end;
		if cm:get_factions_bonus_value(context:garrison_residence():faction(), "camp_growth_enemy_territory") > 0 then
			camp_growth_not_owned_territory(context:garrison_residence():faction());
		end;
	end,
	true
);

function camp_growth_not_owned_territory(faction)
	
	local camp_growth_in_enemy_region = cm:get_factions_bonus_value(faction, "camp_growth_enemy_territory");
	local growth_bundle_camps = cm:create_new_custom_effect_bundle("wh3_main_tech_effect_ogr_camp_growth_enemy_region");
	growth_bundle_camps:add_effect("wh_main_effect_hordebuilding_growth_tech", "force_to_force_own", camp_growth_in_enemy_region);
	growth_bundle_camps:set_duration(0);
	
	local force_list = faction:military_force_list();
	for i = 0, force_list:num_items() - 1 do
		
		local force = force_list:item_at(i);
		if force:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_FIXED_CAMP" then
			local character_camp = force:general_character();
			if force:has_effect_bundle(growth_bundle_camps:key()) then
				cm:remove_effect_bundle_from_force(growth_bundle_camps:key(), force:command_queue_index());
			end;
			if not cm:char_in_owned_region(character_camp) then
				cm:apply_custom_effect_bundle_to_force(
					growth_bundle_camps,
					force
				)
			end;
		end;
	end;
end;

-- extra development points for camps
core:add_listener(
	"ogr_camp_development_points_spawned",
	"CharacterCreated",
	function(context)
		return cm:get_factions_bonus_value(context:character():faction(), "development_points_for_camps_on_spawn") > 0 
			and context:character():character_subtype("wh3_main_ogr_tyrant_camp")
	end,
	function(context)
		local num_points = cm:get_factions_bonus_value(context:character():faction(), "development_points_for_camps_on_spawn");
		cm:add_development_points_to_horde(context:character():military_force(), num_points);
	end,
	true
);


-- line_of_sight_armies_in_region_and_adjacent
core:add_listener(
	"line_of_sight_armies_in_region_and_adjacent",
	"ScriptEventHumanFactionTurnStart",
	true,
	function(context)
		local faction = context:faction();
		local scouted_regions = {};
		
		local region_list = faction:region_list();
		
		for i = 0, region_list:num_items() - 1 do
			local region = region_list:item_at(i);
			local bv = cm:get_regions_bonus_value(region, "line_of_sight_armies_in_region_and_adjacent");
			
			if bv > 0 then
				table.insert(scouted_regions, region:name());
				local adjacent_region_list = region:adjacent_region_list();
				
				for j = 0, adjacent_region_list:num_items() - 1 do
					table.insert(scouted_regions, adjacent_region_list:item_at(j):name());
				end;
			end;
		end;
		
		local army_list = faction:military_force_list();
		
		for i = 0, army_list:num_items() - 1 do
			local army = army_list:item_at(i);
			
			if army:has_general() then
				local general = army:general_character();
				
				if army:has_effect_bundle("wh_dlc06_ranger_scouting") then
					cm:remove_effect_bundle_from_characters_force("wh_dlc06_ranger_scouting", general:command_queue_index());
				end;
				
				if general:has_region() then
					for j = 1, #scouted_regions do
						if scouted_regions[j] == general:region():name() then
							cm:apply_effect_bundle_to_characters_force("wh_dlc06_ranger_scouting", general:command_queue_index(), 0);
						end;
					end;
				end;
			end;
		end;
	end,
	true
);

-- under_empire_adjacent_region_expansion_chance
cm:add_faction_turn_start_listener_by_culture(
	"under_empire_adjacent_region_expansion_chance",
	"wh2_main_skv_skaven",
	function(context)
		local faction = context:faction();
		local faction_key = faction:name();
		local under_empires = faction:foreign_slot_managers();
		
		for i = 0, under_empires:num_items() - 1 do
			local under_empire = under_empires:item_at(i);
			local region = under_empire:region();
			local expand_chance = cm:get_regions_bonus_value(region, "under_empire_adjacent_region_expansion_chance");
			out("UnderEmpireBuildingExpansion - "..region:name());
				
			if expand_chance > 0 then
				out("\tChance - "..tostring(expand_chance).."%");
				if cm:model():random_percent(expand_chance) then
					out("\t\tSuccess!");
					local adjacent_region_list = region:adjacent_region_list();
					
					for j = 0, adjacent_region_list:num_items() - 1 do
						local possible_region = adjacent_region_list:item_at(j);
						local region_key = possible_region:name();
						out("\t\tAdjacent Region: "..region_key);
						
						if possible_region:is_abandoned() == false and possible_region:owning_faction():is_null_interface() == false and possible_region:owning_faction():name() ~= faction_key then
							local slot_manager = possible_region:foreign_slot_manager_for_faction(faction_key);
							
							if slot_manager:is_null_interface() == true then
								out("\t\t\tAccepting Region: "..region_key);
								cm:add_foreign_slot_set_to_region_for_faction(faction:command_queue_index(), possible_region:cqi(), "wh2_dlc12_slot_set_underempire");
								cm:make_region_visible_in_shroud(faction_key, region_key);
								
								local settlement_x = possible_region:settlement():logical_position_x();
								local settlement_y = possible_region:settlement():logical_position_y();
								
								cm:show_message_event_located(
									faction_key,
									"event_feed_strings_text_wh2_dlc12_event_feed_string_scripted_event_under_empire_expanded_title",
									"regions_onscreen_"..region_key,
									"event_feed_strings_text_wh2_dlc12_event_feed_string_scripted_event_under_empire_expanded_description",
									settlement_x, settlement_y,
									false,
									123
								);
								
								expand_chance = -1;
								return true;
							end
						end
					end
				end
			end
		end
	end,
	true
);

-- enable win streaks feature for daemon prince faction
core:add_listener(
	"enable_win_streaks_feature",
	"PooledResourceThresholdOperationReached",
	function(context)
		local faction = context:faction();
		return not cm:get_saved_value(faction:name() .. "_enable_win_streaks_feature") and cm:get_factions_bonus_value(faction, "enable_win_streaks_feature") > 0;
	end,
	function(context)
		local faction = context:faction();
		local faction_name = faction:name();
		cm:set_saved_value(faction_name .. "_enable_win_streaks_feature", true);
		cm:add_or_remove_faction_features(faction, {"streaks"}, true);
		
		cm:trigger_incident(faction_name, "wh3_main_incident_dae_feature_khorne", true);
	end,
	true
);

-- enable plagues feature for daemon prince faction
core:add_listener(
	"enable_plagues_feature",
	"PooledResourceThresholdOperationReached",
	function(context)
		local faction = context:faction();
		return not cm:get_saved_value(faction:name() .. "_enable_plagues_feature") and cm:get_factions_bonus_value(faction, "enable_plagues_feature") > 0;
	end,
	function(context)
		local faction = context:faction();
		local faction_name = faction:name();
		cm:set_saved_value(faction_name .. "_enable_plagues_feature", true);
		cm:add_or_remove_faction_features(faction, {"military_force_plagues"}, true);
		
		cm:trigger_incident(faction_name, "wh3_main_incident_dae_feature_nurgle", true);
	end,
	true
);

-- enable bribes feature for daemon prince faction
core:add_listener(
	"enable_bribes_feature",
	"PooledResourceThresholdOperationReached",
	function(context)
		local faction = context:faction();
		return not cm:get_saved_value(faction:name() .. "_enable_bribes_feature") and cm:get_factions_bonus_value(faction, "enable_bribes_feature") > 0;
	end,
	function(context)
		local faction = context:faction();
		local faction_name = faction:name();
		cm:set_saved_value(faction_name .. "_enable_bribes_feature", true);
		cm:add_or_remove_faction_features(faction, {"bribery"}, true);
		
		cm:trigger_incident(faction_name, "wh3_main_incident_dae_feature_slaanesh", true);
	end,
	true
);

-- enable teleport stance features for daemon prince faction
core:add_listener(
	"enable_teleport_stance_feature",
	"PooledResourceThresholdOperationReached",
	function(context)
		local faction = context:faction();
		return not cm:get_saved_value(faction:name() .. "_enable_teleport_stance_feature") and cm:get_factions_bonus_value(faction, "enable_teleport_stance_feature") > 0;
	end,
	function(context)
		local faction = context:faction();
		local faction_name = faction:name();
		cm:set_saved_value(faction_name .. "_enable_teleport_stance_feature", true);
		cm:add_or_remove_faction_features(faction, {"CAN_TUNNEL_ATTACK_CHARACTER", "CAN_TUNNEL_ATTACK_GARRISON", "CAN_TUNNEL_ATTACK_MISSION_MARKER", "TUNNEL_ATTACK_IS_AMBUSH"}, true);
		
		cm:trigger_incident(faction_name, "wh3_main_incident_dae_feature_tzeentch", true);
	end,
	true
);

-- damages walls when character besieges settlement with this bonus value complete
core:add_listener(
	"damage_settlement_wall",
	"CharacterBesiegesSettlement",
	function(context)
		local character = context:region():garrison_residence():besieging_character()
		return cm:get_characters_bonus_value(character, "damage_wall_when_besieging") ~= 0
	end,
	function(context)
		local region = context:region()
		local settlement = region:settlement()
		local character = region:garrison_residence():besieging_character()
		
		if settlement:is_walled_settlement() and settlement:number_of_wall_breaches() < 2 then
			out.design("Character " .. character:get_forename() .. " has besieged " .. context:region():name() .. " damage the walls of this settlement!")	
			cm:set_settlement_wall_health(settlement, 2)
		end
			
	end,
	true
);


-- spawn a disciple army when building with this bonus value is complete
core:add_listener(
	"create_disciple_army_foreign_slot",
	"ForeignSlotBuildingCompleteEvent",
	function(context)
		return cm:get_regions_bonus_value(context:slot_manager():region(), "create_disciple_army") ~= 0;
	end,
	function(context)
		local sm = context:slot_manager()
		local faction_name = sm:faction():name();
		local region_name = sm:region():name();
		local x, y = cm:find_valid_spawn_location_for_character_from_settlement(faction_name, region_name, false, true, 12);
		
		if x > 0 then
			-- spawn the army on the faction's turn start, as foreign slot buildings seem to be created just before, meaning attrition is applied before the army is useable
			core:add_listener(
				"create_disciple_army_foreign_slot_" .. faction_name,
				"FactionTurnStart",
				function(context)
					return context:faction():name() == faction_name;
				end,
				function()
					cm:create_force_with_general(
						faction_name,
						"wh3_main_sla_inf_marauders_0,wh3_main_sla_inf_marauders_0,wh3_main_sla_inf_marauders_0,wh3_main_sla_inf_daemonette_0,wh3_main_sla_inf_daemonette_0",
						region_name,
						x,
						y,
						"general",
						"wh3_main_sla_herald_of_slaanesh_slaanesh_disciple_army",
						"",
						"",
						"",
						"",
						false,
						function(cqi)
							cm:apply_effect_bundle_to_characters_force("wh3_main_bundle_sla_disciple_army", cqi, 0);
						end
					);
				end,
				false
			);
		end;
	end,
	true
);

-- spawn a disciple army when a faction starts their turn with this bonus value. will only work if the army has the effect bundle wh3_main_ritual_sla_gg_4 or wh3_main_ritual_sla_gg_4_upgraded
core:add_listener(
	"create_disciple_army_character",
	"FactionTurnStart",
	function(context)
		return cm:get_factions_bonus_value(context:faction(), "create_disciple_army") ~= 0;
	end,
	function(context)
		local faction = context:faction();
		local faction_name = faction:name();
		local mf_list = faction:military_force_list();
		
		for i = 0, mf_list:num_items() - 1 do
			local current_mf = mf_list:item_at(i);
			local has_effect_bundle = current_mf:has_effect_bundle("wh3_main_ritual_sla_gg_4") or 
										current_mf:has_effect_bundle("wh3_main_ritual_sla_gg_4_upgraded")
			if has_effect_bundle and current_mf:has_general() then
				local character = current_mf:general_character();
				local x, y = cm:find_valid_spawn_location_for_character_from_character(faction_name, cm:char_lookup_str(character:command_queue_index()), true, 4);
				
				if x > 0 then
					local corruption = 0;
					
					if character:has_region() then
						corruption = cm:get_corruption_value_in_region(character:region(), slaanesh_corruption_string);
					end;
					
					local units = "wh3_main_sla_inf_marauders_0,wh3_main_sla_veh_seeker_chariot_0,wh3_main_sla_cav_seekers_of_slaanesh_0";
					
					if corruption >= 66 then
						units = "wh3_main_sla_inf_marauders_2,wh3_main_sla_inf_marauders_1,wh3_main_sla_inf_marauders_1,wh3_main_sla_inf_marauders_1,wh3_main_sla_inf_marauders_1,wh3_main_sla_inf_marauders_1,wh3_main_sla_inf_marauders_0,wh3_main_sla_inf_marauders_0,wh3_main_sla_inf_marauders_0,wh3_main_sla_inf_marauders_0,wh3_main_sla_veh_seeker_chariot_0,wh3_main_sla_veh_seeker_chariot_0,wh3_main_sla_veh_seeker_chariot_0,wh3_main_sla_cav_seekers_of_slaanesh_0,wh3_main_sla_cav_seekers_of_slaanesh_0";
					elseif corruption >= 33 then
						units = "wh3_main_sla_inf_marauders_1,wh3_main_sla_inf_marauders_1,wh3_main_sla_inf_marauders_0,wh3_main_sla_inf_marauders_0,wh3_main_sla_inf_marauders_0,wh3_main_sla_veh_seeker_chariot_0,wh3_main_sla_veh_seeker_chariot_0,wh3_main_sla_cav_seekers_of_slaanesh_0,wh3_main_sla_cav_seekers_of_slaanesh_0";
					end;
					
					cm:create_force_with_general(
						faction_name,
						units,
						character:region_data():key(),
						x,
						y,
						"general",
						"wh3_main_sla_herald_of_slaanesh_slaanesh_disciple_army",
						"",
						"",
						"",
						"",
						false,
						function(cqi)
							cm:apply_effect_bundle_to_characters_force("wh3_main_bundle_sla_disciple_army", cqi, 0);
						end
					);
				end;
			end;
		end;
	end,
	true
);


---summon your faction leader to the settlement when this building completes
core:add_listener(
	"summon_faction_leader",
	"ForeignSlotBuildingCompleteEvent",
	true,
	function(context)
		local sm = context:slot_manager();
		local region = sm:region();

		if cm:get_regions_bonus_value(region, "summon_faction_leader") ~= 0 then
			out("ForeignSlotBuildingCompleteEvent - summon_faction_leader bonus value detected");
			local faction = sm:faction();
			local region_name = region:name();

			if faction:has_faction_leader() == true then
				local faction_leader = faction:faction_leader();
				out("\tLeader found - "..faction_leader:command_queue_index());

				if faction_leader:has_military_force() == true or faction_leader:is_at_sea() == true then
					local x, y = cm:find_valid_spawn_location_for_character_from_settlement(faction:name(), region_name, false, true, 12);
					out("\t"..region_name.."  -  X: "..x.."  /  Y: "..y);

					if x > 0 and faction_leader:has_military_force() == true then
						local result = cm:teleport_military_force_to(faction_leader:military_force(), x, y)
						out("\tTeleporting: "..tostring(result));
					end
				end
			end
		end
	end,
	true
);

-- create a random nurgle plague in the settlement per turn
core:add_listener(
	"create_random_nurgle_plague_per_turn",
	"RegionTurnStart",
	true,
	function(context)
		local region = context:region();

		if region:is_abandoned() == false then
			local plague_chance = cm:get_regions_bonus_value(region, "create_random_nurgle_plague_per_turn");

			if plague_chance > 0 and cm:model():random_percent(plague_chance) then
				local current_plague = region:get_plague_if_infected();

				if current_plague:is_null_interface() then
					local minor_cult = cm:model():world():faction_by_key("wh3_main_rogue_minor_cults"); -- HACK: Plagues need an owner, currently the only place this bonus value is used is from them
					local selected_plague = "wh3_dlc25_nur_random_plague_"..cm:random_number(5);
					cm:spawn_plague_at_settlement(minor_cult, region:settlement(), selected_plague);
				end
			end
		end
	end,
	true
);

-- create a random nurgle plague in the settlement when a building with this bonus value is complete
core:add_listener(
	"create_random_nurgle_plague",
	"ForeignSlotBuildingCompleteEvent",
	function(context)
		return cm:get_regions_bonus_value(context:slot_manager():region(), "create_random_nurgle_plague") ~= 0
	end,
	function(context)
		local sm = context:slot_manager()
		local selected_plague = "wh3_dlc25_nur_random_plague_" .. cm:random_number(5)
		cm:spawn_plague_at_settlement(sm:faction(), sm:region():settlement(), selected_plague)
	end,
	true
);

-- create a random nurgle plague in all adjacent settlements
core:add_listener(
	"create_random_nurgle_plague_adj",
	"ForeignSlotBuildingCompleteEvent",
	function(context)
		return cm:get_regions_bonus_value(context:slot_manager():region(), "create_random_nurgle_plague_adjacent") ~= 0
	end,
	function(context)
		local sm = context:slot_manager();
		local adjacent_region_list = sm:region():adjacent_region_list();

		for i = 0, adjacent_region_list:num_items() - 1 do
			local adj_region = adjacent_region_list:item_at(i);

			if adj_region:is_abandoned() == false then --adj_region:owning_faction():command_queue_index() ~= sm:faction():command_queue_index() then
				local selected_plague = "wh3_dlc25_nur_random_plague_"..cm:random_number(5);
				cm:spawn_plague_at_settlement(sm:faction(), adj_region:settlement(), selected_plague);
			end
		end
	end,
	true
);

-- increases winds of magic to max level in this province and adjacent provinces when a building with this bonus value is complete
core:add_listener(
	"max_winds_of_magic_in_adjacent_provinces",
	"ForeignSlotBuildingCompleteEvent",
	function(context)
		return cm:get_regions_bonus_value(context:slot_manager():region(), "max_winds_of_magic_in_adjacent_provinces") ~= 0;
	end,
	function(context)
		local province = context:slot_manager():region():province();
		
		cm:force_winds_of_magic_change(province:key(), "wom_strength_4");
		
		local adjacent_provinces = province:adjacent_provinces();
		
		for i = 0, adjacent_provinces:num_items() - 1 do
			cm:force_winds_of_magic_change(adjacent_provinces:item_at(i):key(), "wom_strength_4");
		end;
	end,
	true
);

-- apply province winds of magic strength level
core:add_listener(
	"winds_of_magic_level_in_province",
	"WorldStartRound",
	true,
	function(context)
		local province_list = context:world():province_list()
		
		for i = 0, province_list:num_items() - 1 do
			local province = province_list:item_at(i)
			local faction_province = province:capital_region():faction_province()
			local blowing = cm:get_provinces_bonus_value(faction_province, "winds_of_magic_level_blowing_in_province")
			local strong = cm:get_provinces_bonus_value(faction_province,"winds_of_magic_level_strong_in_province")
			local tempestuous = cm:get_provinces_bonus_value(faction_province, "winds_of_magic_level_tempestuous_in_province")
			--make sure that we never lower the wind of magic level in province, check what current level is first
			local current_wind_level = cm:get_winds_of_magic_in_area_for_region(province:capital_region())
			if tempestuous > 0 and current_wind_level < 4 then
				cm:force_winds_of_magic_change(province:key(), "wom_strength_4")
			elseif strong > 0 and current_wind_level < 3 then
				cm:force_winds_of_magic_change(province:key(), "wom_strength_3")
			elseif strong > 0 and current_wind_level < 2 then
				cm:force_winds_of_magic_change(province:key(), "wom_strength_2")
			end
		end
	end,
	true
)


-- add khorne skulls when a battle is fought in this province
core:add_listener(
	"skulls_from_province_battles",
	"BattleCompleted",
	function()
		return cm:model():pending_battle():region_data():region():is_null_interface() == false;
	end,
	function()
		local region = cm:model():pending_battle():region_data():region();
		local province = region:faction_province();
		local bv = cm:get_provinces_bonus_value(province, "skulls_from_province_battles");

		if bv ~= 0 then
			-- This is currently the only faction that could be creating this BV, this might need to change in future
			-- Getting a BV from a province can't differentiate between factions which is an issue
			cm:faction_add_pooled_resource("wh3_main_kho_exiles_of_khorne", "wh3_main_kho_skulls", "buildings", bv);
		end
	end,
	true
);

-- extra income for faction per ogre ally
core:add_listener(
	"ogr_ally_trade_income_turn_start",
	"FactionTurnStart",
	function(context)
		return cm:get_factions_bonus_value(context:faction(), "allied_ogres_trade_income_mod") > 0;
	end,
	function(context)
		local faction = context:faction();
		local num_allies = faction:num_allies();
		local bonus = cm:get_factions_bonus_value(faction, "allied_ogres_trade_income_mod");
		
		local ally_trade = cm:create_new_custom_effect_bundle("wh3_main_tech_effect_ogr_ally_trade_bonus");
		ally_trade:add_effect("wh_main_effect_economy_trade_tariff_mod", "faction_to_faction_own_unseen", num_allies*bonus);
		ally_trade:set_duration(0);

		if faction:has_effect_bundle(ally_trade:key()) then
			cm:remove_effect_bundle(ally_trade:key(), faction:name());
		end;
		cm:apply_custom_effect_bundle_to_faction(ally_trade, faction);
	end,
	true
);

-- character_starting_rank
core:add_listener(
	"character_starting_rank",
	"WorldCreated",
	function()
		return cm:is_new_game();
	end,
	function(context)
		local output_generated = false;
		local faction_list = context:world():faction_list();
		
		for i = 0, faction_list:num_items() - 1 do
			local character_list = faction_list:item_at(i):character_list();
			
			for j = 0, character_list:num_items() - 1 do
				local current_character = character_list:item_at(j);
				local bonus_value = cm:get_characters_bonus_value(current_character, "character_starting_rank");
				
				if bonus_value > 0 then
					if not output_generated then
						out("* Adding agent experience on WorldCreated event:");
						out.inc_tab();
						output_generated = true;
					end;
					cm:add_agent_experience(cm:char_lookup_str(current_character:cqi()), bonus_value, true);
				end;
			end;
		end;

		if output_generated then
			out.dec_tab();
			out("");
		end;
	end,
	false
);

-- add growth points factionwide when a battle is won
core:add_listener(
	"factionwide_growth_from_battle_result",
	"CharacterCompletedBattle",
	function(context)
		return cm:get_characters_bonus_value(context:character(), "factionwide_growth_from_battle_result") > 0;
	end,
	function(context)
		local character = context:character();
		local growth_to_add = cm:get_characters_bonus_value(character, "factionwide_growth_from_battle_result");
		local region_list = character:faction():region_list();
		
		for i = 0, region_list:num_items() - 1 do
			cm:add_growth_points_to_region(region_list:item_at(i):name(), growth_to_add);
		end;
	end,
	true
);

-- apply a corruption reduction to other types when one type is high when round starts
local function set_corruption_reduction_in_province(capital_region)
	local corruption_types = {
		"chaos",
		"skaven",
		"vampiric",
		"khorne",
		"nurgle",
		"slaanesh",
		"tzeentch"
	};
	
	for j = 1, #corruption_types do
		local bv = cm:get_regions_bonus_value(capital_region, "corruption_" .. corruption_types[j] .. "_high_reduction");
		local bundle_name = "wh3_main_bundle_corruption_" .. corruption_types[j] .. "_high_reduction";
		
		if capital_region:has_effect_bundle(bundle_name) then
			cm:remove_effect_bundle_from_region(bundle_name, capital_region:name());
		end;
		
		if bv < 0 then
			local corruption_bundle = cm:create_new_custom_effect_bundle(bundle_name);
			corruption_bundle:add_effect("wh3_main_effect_corruption_" .. corruption_types[j] .. "_high_reduction", "region_to_province_own", bv);
			corruption_bundle:set_duration(0);
			
			cm:apply_custom_effect_bundle_to_region(corruption_bundle, capital_region);
		end;
	end;
end;

core:add_listener(
	"corruption_x_high_reduction",
	"WorldStartRound",
	true,
	function(context)
		local province_list = context:world():province_list();
		
		for i = 0, province_list:num_items() - 1 do
			set_corruption_reduction_in_province(province_list:item_at(i):capital_region());
		end;
	end,
	true
);

-- apply a corruption reduction to other types when one type is high when settlement changes ownership
core:add_listener(
	"corruption_x_high_reduction_settlement_change",
	"GarrisonOccupiedEvent",
	true,
	function(context)
		set_corruption_reduction_in_province(context:garrison_residence():region():province():capital_region());
	end,
	true
);

-- apply local province growth for every army; handles positive and negative
core:add_listener(
	"tech_army_growth_bonus",
	"FactionTurnStart",
	function(context)
		return cm:get_factions_bonus_value(context:faction(), "development_growth_bonus_all_forces") > 0 or 
		cm:get_factions_bonus_value(context:faction(), "development_growth_bonus_all_forces") < 0;
	end,
	function(context)
		local faction = context:faction();
		local m_list = faction:military_force_list();
		
		local bonus = cm:get_factions_bonus_value(faction, "development_growth_bonus_all_forces");
		
		if m_list:is_empty() then
			return 0;
		end
		
		local growth_bonus = cm:create_new_custom_effect_bundle("wh3_main_custom_bundle_stimulate_growth");
		if bonus > 0 then
			growth_bonus:add_effect("wh2_main_effect_agent_action_passive_stimulate_growth_effect_positive", "character_to_province_own", bonus);
		elseif bonus < 0 then
			growth_bonus:add_effect("wh2_main_effect_agent_action_passive_stimulate_growth_effect_negative", "character_to_province_enemy", bonus);
		end
		growth_bonus:set_duration(0);
		
		for i = 0, m_list:num_items() - 1 do
			local character = m_list:item_at(i):general_character();
			
			if character:is_null_interface() == false then
				if character:has_effect_bundle(growth_bonus:key()) then
					cm:remove_effect_bundle_from_character(growth_bonus:key(), character);
				end;
				cm:apply_custom_effect_bundle_to_character(growth_bonus, character)
			end
		end
	end,
	true
);

-- apply local province control for every army; handles positive and negative
core:add_listener(
	"tech_army_control_bonus",
	"FactionTurnStart",
	function(context)
		return cm:get_factions_bonus_value(context:faction(), "public_order_bonus_all_forces") ~= 0;
	end,
	function(context)
		local faction = context:faction();
		local m_list = faction:military_force_list();
		
		local bonus = cm:get_factions_bonus_value(faction, "public_order_bonus_all_forces");
		
		if m_list:is_empty() then
			return;
		else
			local control_bonus = cm:create_new_custom_effect_bundle("wh3_main_bundle_scripted_public_order_bonus_all_forces");
			
			if bonus > 0 then
				control_bonus:add_effect("wh_main_effect_public_order_characters", "character_to_province_own", bonus);
			elseif bonus < 0 then
				control_bonus:add_effect("wh_main_effect_public_order_characters_negative", "character_to_province_enemy", bonus);
			end
			
			control_bonus:set_duration(0);
			
			for i = 0, m_list:num_items() - 1 do
				local force = m_list:item_at(i);
				
				if not force:is_armed_citizenry() then
					if force:has_effect_bundle(control_bonus:key()) then
						cm:remove_effect_bundle_from_force(control_bonus:key(), force:command_queue_index());
					end;
					
					cm:apply_custom_effect_bundle_to_force(control_bonus, force);
				end;
			end;
		end;
	end,
	true
);


-- replenish AP after razing
-- also includes post-battle AP replen as otherwise it gets zeroed out by raze
core:add_listener(
	"campaign_movement_range_post_raze",
	"CharacterRazedSettlement",
	function(context)
		local character = context:character()
		return cm:get_characters_bonus_value(character, "campaign_movement_range_post_battle_win") + cm:get_characters_bonus_value(character, "campaign_movement_range_post_raze") > 0;
	end,
	function(context)
		local character = context:character();
		local movement_to_replenish = cm:get_characters_bonus_value(character, "campaign_movement_range_post_raze") + cm:get_characters_bonus_value(character, "campaign_movement_range_post_battle_win")
		cm:replenish_action_points(cm:char_lookup_str(character), (character:action_points_remaining_percent() + movement_to_replenish) / 100);
	end,
	true
);


-- spread to ruined settlements in the same province at round start
-- underlying bonus values aren't 100% true, as we weight it so that you're unlikely to immediately get the effect after razing and won't have to wait for ages if your luck is bad
core:add_listener(
	"settlement_spread_to_province_ruin_chance",
	"WorldStartRound",
	function(context)
		--- don't fire on new game
 		return not cm:is_new_game()
	end,
	function(context)
		local region_list = context:world():region_manager():region_list()
		for i, start_region in model_pairs(region_list) do	
			if cm:get_regions_bonus_value(start_region, "settlement_spread_to_province_ruin_chance") > 0 and start_region:has_effect_bundle("wh2_dlc17_effect_bundle_defiled_bloodgrounds") == false then
				local owner_key = start_region:owning_faction():name()
				local province_regions = start_region:province():regions()
				local source_spread_chance = cm:get_regions_bonus_value(start_region, "settlement_spread_to_province_ruin_chance") + cm:get_provinces_bonus_value(start_region:faction_province(), "settlement_spread_to_province_ruin_chance")
				local tracker_bundle_key = "wh3_main_bundle_ruin_spread_chance_modifier"

				for i, target_region in model_pairs(province_regions) do
					if target_region:is_abandoned() == true then
						local target_bonus = cm:get_regions_bonus_value(target_region, "settlement_spread_to_province_ruin_chance_target_bonus")
						local spread_chance = target_bonus + source_spread_chance
						local roll = cm:random_number()

						if roll <= spread_chance then
							cm:transfer_region_to_faction(target_region:name(), owner_key)

							cm:trigger_incident_with_targets(
								start_region:owning_faction():command_queue_index(),
								"wh3_main_incident_drawn_to_destruction",
								0,
								0,
								0,
								0,
								target_region:cqi(),
								0
							)
						elseif spread_chance > 0 then
							local ruin_spread_mod_bundle = cm:create_new_custom_effect_bundle(tracker_bundle_key)
							
							if spread_chance > 100 then
								spread_chance = 100
							end

							ruin_spread_mod_bundle:add_effect("wh3_main_effect_region_chance_to_spread_to_ruin_target_dummy", "region_to_region_own", spread_chance)
							ruin_spread_mod_bundle:set_duration(0)
							cm:apply_custom_effect_bundle_to_region(ruin_spread_mod_bundle, target_region)
						end
					end
				end
			end
		end
	end,
	true
);


---force liberated factions into vassalage instead of just a military alliance
core:add_listener(
	"liberated_factions_spawn_as_vassals",
	"FactionBecomesLiberationVassal",
	function(context)
		local liberating_faction = context:liberating_character():faction()
		return cm:get_factions_bonus_value(liberating_faction, "liberated_factions_spawn_as_vassals") >0
	end,
	function(context)
		local liberated_faction_name = context:faction():name()
		local liberating_faction_name = context:liberating_character():faction():name()
	
		cm:callback(
			function()
				cm:force_make_vassal(liberating_faction_name, liberated_faction_name)
			end,
			0.2)
	end,
	true
);


---provide a diplomatic bonus or penalty when a specified foreign slot building is completed
core:add_listener(
	"alter_attitude_on_foreign_slot_completion",
	"ForeignSlotBuildingCompleteEvent",
	function(context)
		return cm:get_regions_bonus_value(context:slot_manager():region(), "alter_attitude_on_foreign_slot_completion") >0
	end,
	function(context)
		local slot_manager = context:slot_manager();
		
		cm:apply_dilemma_diplomatic_bonus(
			slot_manager:faction():name(), 
			slot_manager:region():owning_faction():name(), 
			math.clamp(cm:get_regions_bonus_value(slot_manager:region(), "alter_attitude_on_foreign_slot_completion"), -6, 6)
		);
	end,
	true
);

-- provide a diplomatic bonus every turn whilst a specified foreign slot building is present
core:add_listener(
	"alter_attitude_each_turn_from_foreign_slot",
	"FactionTurnStart",
	function(context)
		return not context:faction():foreign_slot_managers():is_empty()
	end,
	function(context)
		local faction = context:faction()
		local foreign_slot_managers = faction:foreign_slot_managers()
		
		for i = 0, foreign_slot_managers:num_items() - 1 do
			local region = foreign_slot_managers:item_at(i):region()
			local bv = cm:get_regions_bonus_value(region, "alter_attitude_each_turn_from_foreign_slot")
			if bv ~= 0 then
				cm:apply_dilemma_diplomatic_bonus(
					faction:name(), 
					region:owning_faction():name(), 
					math.clamp(bv, -6, 6)
				)
			end
		end
		
	end,
	true
)

--[[
-- surrender region to builder of foreign slot
core:add_listener(
	"surrender_region_to_faction",
	"FactionTurnStart",
	function(context)
		return not context:faction():foreign_slot_managers():is_empty();
	end,
	function(context)
		local faction = context:faction();
		local fsm = faction:foreign_slot_managers();
		
		for i = 0, fsm:num_items() - 1 do
			local current_region = fsm:item_at(i):region();
			
			if cm:get_regions_bonus_value(current_region, "surrender_region_to_faction") ~= 0 then
				cm:transfer_region_to_faction(current_region:name(), faction:name())
			end;
		end;
	end,
	true
);
]]--
--- Spawn a subculture-relevant cultist on building completion

local subcultures_to_cultist_subtypes ={
	wh3_main_sc_kho_khorne = "wh3_main_kho_cultist",
	wh3_main_sc_sla_slaanesh = "wh3_main_sla_cultist",
	wh3_main_sc_tze_tzeentch = "wh3_main_tze_cultist",
	wh3_main_sc_nur_nurgle = "wh3_main_nur_cultist",
}
core:add_listener(
	"spawn_cultist_on_foreign_slot_completion",
	"ForeignSlotBuildingCompleteEvent",
	function(context)
		return cm:get_regions_bonus_value(context:slot_manager():region(), "spawn_cultist_on_foreign_slot_completion") >0
	end,
	function(context)
		local slot_manager = context:slot_manager()
		local building_owner = slot_manager:faction()
		local building_owner_subculture = building_owner:subculture()
		local building_owner_key = building_owner:name()
		local region_key = slot_manager:region():name()
		local spawn_coord_x, spawn_coord_y = cm:find_valid_spawn_location_for_character_from_settlement(building_owner_key, region_key, false, true, 10)
		local agent_subtype = subcultures_to_cultist_subtypes[building_owner_subculture]

		if agent_subtype and spawn_coord_x ~= -1 and building_owner:agent_cap_remaining("dignitary") > 0 then
			cm:spawn_agent_at_position(building_owner, spawn_coord_x, spawn_coord_y, "dignitary", agent_subtype)
		end
	end,
	true
);

core:add_listener(
	"UnbreakableGrudgeBonus_PendingBattle",
	"PendingBattle",
	function(context)
		return pending_battle_bv_check("unbreakable_when_grudges_over_1000", context:pending_battle(), true, false)
	end,
	function(context)
		local pb = context:pending_battle()

		local attackers_with_bonus_value = {}
		local defenders_with_bonus_value = {}
		local attackers_grudges, defenders_grudges = grudges_scripted_bv_handler("unbreakable_when_grudges_over_1000", pb, attackers_with_bonus_value, defenders_with_bonus_value)

		if attackers_grudges >= 1000 then
			for i = 1, #defenders_with_bonus_value do
				cm:apply_effect_bundle_to_force("wh3_dlc25_unbreakable_grudge_scripted_hidden", defenders_with_bonus_value[i], 1)
			end
		end
		if defenders_grudges >= 1000 then
			for i = 1, #attackers_with_bonus_value do
				cm:apply_effect_bundle_to_force("wh3_dlc25_unbreakable_grudge_scripted_hidden", attackers_with_bonus_value[i], 1)	
			end
		end
		
		cm:update_pending_battle()
	end,
	true
)

core:add_listener(
	"UnbreakableGrudgeBonus_BattleCompleted",
	"BattleCompleted",
	function(context)
		return pending_battle_bv_check("unbreakable_when_grudges_over_1000", context:model():pending_battle(), true, false)
	end,
	function(context)	
		local pb = context:model():pending_battle()
		
		local attackers_with_bonus_value = {}
		local defenders_with_bonus_value = {}
		grudges_scripted_bv_handler("unbreakable_when_grudges_over_1000", pb, attackers_with_bonus_value, defenders_with_bonus_value)	
		
		for i = 1, #defenders_with_bonus_value do
			cm:remove_effect_bundle_from_force("wh3_dlc25_unbreakable_grudge_scripted_hidden", defenders_with_bonus_value[i])
		end
		for i = 1, #attackers_with_bonus_value do
			cm:remove_effect_bundle_from_force("wh3_dlc25_unbreakable_grudge_scripted_hidden", attackers_with_bonus_value[i])	
		end
	end,
	true
)

core:add_listener(
	"PerfectVigourGrudgeBonus_PendingBattle",
	"PendingBattle",
	function(context)
		return pending_battle_bv_check("perfect_vigour_when_grudges_over_1000", context:pending_battle(), true, false)
	end,
	function(context)
		local pb = context:pending_battle()

		local attackers_with_bonus_value = {}
		local defenders_with_bonus_value = {}
		local attackers_grudges, defenders_grudges = grudges_scripted_bv_handler("perfect_vigour_when_grudges_over_1000", pb, attackers_with_bonus_value, defenders_with_bonus_value)

		if attackers_grudges >= 1000 then
			for i = 1, #defenders_with_bonus_value do
				cm:apply_effect_bundle_to_force("wh3_dlc25_perfect_vigour_grudge_scripted_hidden", defenders_with_bonus_value[i], 1)
			end
		end
		if defenders_grudges >= 1000 then
			for i = 1, #attackers_with_bonus_value do
				cm:apply_effect_bundle_to_force("wh3_dlc25_perfect_vigour_grudge_scripted_hidden", attackers_with_bonus_value[i], 1)	
			end
		end

		cm:update_pending_battle()
	end,
	true
)

core:add_listener(
	"PerfectVigourGrudgeBonus_BattleCompleted",
	"BattleCompleted",
	function(context)
		return pending_battle_bv_check("perfect_vigour_when_grudges_over_1000", context:model():pending_battle(), true, false)
	end,
	function(context)
		local pb = context:model():pending_battle()
		
		local attackers_with_bonus_value = {}
		local defenders_with_bonus_value = {}
		grudges_scripted_bv_handler("perfect_vigour_when_grudges_over_1000", pb, attackers_with_bonus_value, defenders_with_bonus_value)

		for i = 1, #defenders_with_bonus_value do
			cm:remove_effect_bundle_from_force("wh3_dlc25_perfect_vigour_grudge_scripted_hidden", defenders_with_bonus_value[i])
		end
		for i = 1, #attackers_with_bonus_value do
			cm:remove_effect_bundle_from_force("wh3_dlc25_perfect_vigour_grudge_scripted_hidden", attackers_with_bonus_value[i])	
		end
	end,
	true
)

function pending_battle_bv_check(bonus_value, pending_battle, check_force, check_character) 

	local scripted_bonus_value_present = false

	local attacker = pending_battle:attacker()
	if not attacker:is_null_interface() and (cm:get_forces_bonus_value(attacker:military_force(), bonus_value) > 0 or cm:get_characters_bonus_value(attacker, bonus_value) > 0) then
		scripted_bonus_value_present = true
	end

	local defender = pending_battle:defender()
	if not defender:is_null_interface() and (cm:get_forces_bonus_value(defender:military_force(), bonus_value) > 0 or cm:get_characters_bonus_value(defender, bonus_value) > 0) then
		scripted_bonus_value_present = true
	end

	local attacker_list = pending_battle:secondary_attackers()
	for i = 0, attacker_list:num_items() - 1 do
		local attacker = attacker_list:item_at(i)

		if not attacker:is_null_interface() and (cm:get_forces_bonus_value(attacker:military_force(), bonus_value) > 0 or cm:get_characters_bonus_value(attacker, bonus_value) > 0) then
			scripted_bonus_value_present = true
		end
	end

	local defender_list = pending_battle:secondary_defenders()
	for i = 0, defender_list:num_items() - 1 do
		local defender = defender_list:item_at(i)

		if not defender:is_null_interface() and (cm:get_forces_bonus_value(defender:military_force(), bonus_value) > 0 or cm:get_characters_bonus_value(defender, bonus_value) > 0) then
			scripted_bonus_value_present = true
		end
	end
	
	return scripted_bonus_value_present
end

function grudges_scripted_bv_handler(bonus_value, pending_battle, attackers_with_bonus_value, defenders_with_bonus_value)

	local total_attackers_grudges = 0
	local total_defenders_grudges = 0

	local attacker = pending_battle:attacker()
	if not attacker:is_null_interface() then
		total_attackers_grudges = grudges_scripted_bv_check(attacker:military_force(), bonus_value, attackers_with_bonus_value, total_attackers_grudges) 
	end

	local attacker_list = pending_battle:secondary_attackers()
	for i = 0, attacker_list:num_items() - 1 do
		local attacker = attacker_list:item_at(i)
		if not attacker:is_null_interface() then
			total_attackers_grudges = total_attackers_grudges + grudges_scripted_bv_check(attacker:military_force(), bonus_value, attackers_with_bonus_value, total_attackers_grudges) 
		end
	end

	local defender = pending_battle:defender()
	if not defender:is_null_interface() then
		total_defenders_grudges = grudges_scripted_bv_check(defender:military_force(), bonus_value, defenders_with_bonus_value, total_defenders_grudges) 
	end

	local defender_list = pending_battle:secondary_defenders()
	for i = 0, defender_list:num_items() - 1 do
		local defender = defender_list:item_at(i)

		if not defender:is_null_interface() then
			total_defenders_grudges = total_defenders_grudges + grudges_scripted_bv_check(defender:military_force(), bonus_value, defenders_with_bonus_value, total_defenders_grudges) 
		end
	end

	return total_attackers_grudges, total_defenders_grudges
end

function grudges_scripted_bv_check(military_force, bonus_value, forces_with_bonus_value, total_grudges) 

	-- Check if the attacker has the bonus value
	if cm:get_forces_bonus_value(military_force, bonus_value) > 0 then
		table.insert(forces_with_bonus_value, military_force:command_queue_index())
	
	else -- If they do not have the bonus value check if they have over 1000 Grudges

	-- Check if military force is a garrison
		if military_force:is_armed_citizenry() then
			local region = military_force:garrison_residence():region()
			-- Check if region has Grudge resource and if it does, is it over 1000
			if not region:pooled_resource_manager():is_null_interface() then
				local region_prm = region:pooled_resource_manager()
				if not region_prm:resource("wh3_dlc25_dwf_grudge_points_enemy_settlements"):is_null_interface() then
					total_grudges = total_grudges + region_prm:resource("wh3_dlc25_dwf_grudge_points_enemy_settlements"):value()
				end
			end
		else
			-- Check if force has Grudge resource and if it does, is it over 1000
			if not military_force:pooled_resource_manager():is_null_interface() then
				local mf_prm = military_force:pooled_resource_manager()
				if not mf_prm:resource("wh3_dlc25_dwf_grudge_points_enemy_armies"):is_null_interface() then
					total_grudges = total_grudges + mf_prm:resource("wh3_dlc25_dwf_grudge_points_enemy_armies"):value()
				end
			end
		end
	end
	return total_grudges
end


--[[
core:add_listener(
	"post_battle_loot_to_enemy",
	"PendingBattle",
	function(context)
		local defender = context:pending_battle():defender();
		if not defender:is_null_interface() then
			return cm:get_forces_bonus_value(defender:military_force(), "post_battle_loot_mod_enemy") > 0
		end
	end,
	function(context)
		local attacker = context:pending_battle():attacker();
		
		if not attacker:is_null_interface() then
		
			local bonus = cm:get_forces_bonus_value(context:pending_battle():defender():military_force(), "post_battle_loot_mod_enemy")
			
			local loot_bonus = cm:create_new_custom_effect_bundle("wh3_main_caravan_post_battle_loot_bonus_bundle");
			loot_bonus:add_effect("wh_main_effect_force_all_campaign_post_battle_loot_mod", "force_to_force_own", bonus);
			loot_bonus:set_duration(0);

			if attacker:military_force():has_effect_bundle("wh3_main_caravan_post_battle_loot_bonus_bundle") then
				cm:remove_effect_bundle_from_force("wh3_main_caravan_post_battle_loot_bonus_bundle", attacker:military_force():command_queue_index());
			end;
			
			out.design("Apply post battle loot bonus")
			cm:apply_custom_effect_bundle_to_force(loot_bonus, attacker);
		end
	end,
	true
);

core:add_listener(
	"post_battle_loot_to_enemy_remove",
	"CharacterCompletedBattle",
	true,
	function(context)
		local attacker = context:pending_battle():attacker();
		
		out.design("Remove post battle loot bonus")
		if not attacker:is_null_interface() then
			cm:remove_effect_bundle_from_force("wh3_main_caravan_post_battle_loot_bonus_bundle", attacker:military_force():command_queue_index());
		end
	end,
	true
);
]]

-- add an effect bundle to faction's capital to increase its income
local function update_capital_income(faction)
	if faction:has_home_region() then
		local bv = cm:get_factions_bonus_value(faction, "capital_income")
		
		if bv > 0 then
			local capital_region = faction:home_region()
			local effect_bundle_key = "wh3_main_bundle_scripted_capital_income"
			
			if capital_region:has_effect_bundle(effect_bundle_key) then
				cm:remove_effect_bundle_from_region(effect_bundle_key, capital_region:name())
			end;
			
			local capital_income_bundle = cm:create_new_custom_effect_bundle(effect_bundle_key)
			capital_income_bundle:add_effect("wh_main_effect_economy_gdp_mod_all", "region_to_region_own", bv)
			capital_income_bundle:set_duration(0)
			
			cm:apply_custom_effect_bundle_to_region(capital_income_bundle, capital_region)
		end
	end
end

core:add_listener(
	"capital_income_researched",
	"ResearchCompleted",
	true,
	function(context)
		update_capital_income(context:faction())
	end,
	true
)

core:add_listener(
	"capital_income",
	"FactionTurnStart",
	true,
	function(context)
		update_capital_income(context:faction())
	end,
	true
)

-- Nurgle tech effect - reduce recruitment cost in certain regions
local function determine_forces_to_apply_climate_recruitment_cost(faction, mf)
	if not faction then
		faction = mf:faction();
	end;
	
	local climate_recruitment_cost_bonus_values = {
		climate_mountain = "recruitment_cost_in_climate_mountain",
		climate_frozen = "recruitment_cost_in_climate_frozen",
		climate_temperate = "recruitment_cost_in_climate_temperate",
		climate_chaotic = "recruitment_cost_in_climate_chaotic"
	};
	
	local climate_recruitment_cost_bundle_key = "wh3_main_climate_recruitment_cost";
	
	local function apply_climate_recruitment_cost_to_force(current_mf)
		if current_mf:has_effect_bundle(climate_recruitment_cost_bundle_key) then
			cm:remove_effect_bundle_from_force(climate_recruitment_cost_bundle_key, current_mf:command_queue_index());
		end;
		
		if current_mf:has_general() then
			local general = current_mf:general_character();
			
			if general:has_region() then
				local general_climate = general:region():settlement():get_climate();
				
				if climate_recruitment_cost_bonus_values[general_climate] ~= nil then
					local bv = cm:get_factions_bonus_value(faction, climate_recruitment_cost_bonus_values[general_climate]);
					
					if bv ~= 0 then
						local climate_recruitment_cost_bundle = cm:create_new_custom_effect_bundle(climate_recruitment_cost_bundle_key);
						climate_recruitment_cost_bundle:add_effect("wh3_main_effect_mercenary_cost_mod", "force_to_general_own", bv);
						climate_recruitment_cost_bundle:set_duration(0);
						
						cm:apply_custom_effect_bundle_to_force(climate_recruitment_cost_bundle, current_mf);
					end;
				end;
			end;
		end;
	end;
	
	if mf then
		apply_climate_recruitment_cost_to_force(mf)
	else
		local mf_list = faction:military_force_list();
		
		for i = 0, mf_list:num_items() - 1 do
			local current_mf = mf_list:item_at(i);
			
			if not current_mf:is_armed_citizenry() then
				apply_climate_recruitment_cost_to_force(current_mf);
			end;
		end;
	end;
end;

core:add_listener(
	"recruitment_cost_in_climate_faction_turn_start",
	"FactionTurnStart",
	true,
	function(context)
		determine_forces_to_apply_climate_recruitment_cost(context:faction());
	end,
	true
);

core:add_listener(
	"recruitment_cost_in_climate_research_completed",
	"ResearchCompleted",
	true,
	function(context)
		determine_forces_to_apply_climate_recruitment_cost(context:faction());
	end,
	true
);

core:add_listener(
	"recruitment_cost_in_climate_character_finished_moving",
	"CharacterFinishedMovingEvent",
	function(context)
		return context:character():has_military_force();
	end,
	function(context)
		determine_forces_to_apply_climate_recruitment_cost(false, context:character():military_force());
	end,
	true
);

-- trade_agreement_visibility
core:add_listener(
	"trade_agreement_visibility_turn_start",
	"ScriptEventHumanFactionTurnStart",
	function(context)
		return cm:get_factions_bonus_value(context:faction(), "trade_agreement_visibility") > 0;
	end,
	function(context)
		reveal_shroud_over_trade_partner_territory(context:faction());
	end,
	true
);

-- reveal the shroud when a trade deal is made, if it's the player's turn
core:add_listener(
	"trade_agreement_visibility_trade_established",
	"TradeRouteEstablished",
	function(context)
		local faction = context:faction();
		return faction:is_human() and faction:is_factions_turn() and cm:get_factions_bonus_value(faction, "trade_agreement_visibility") > 0;
	end,
	function(context)
		reveal_shroud_over_trade_partner_territory(context:faction());
	end,
	true
);

function reveal_shroud_over_trade_partner_territory(faction)
	local factions_trading_with = faction:factions_trading_with();
	local faction_name = faction:name();
	
	if factions_trading_with:num_items() > 0 then
		for i = 0, factions_trading_with:num_items() - 1 do
			local current_faction = factions_trading_with:item_at(i);
			local current_faction_regions = current_faction:region_list();
			
			for j = 0, current_faction_regions:num_items() - 1 do
				cm:make_region_visible_in_shroud(faction_name, current_faction_regions:item_at(j):name());
			end;
		end;
	end;
end;

if cm:get_campaign_name() ~= "wh3_main_prologue" then
	-- leech region's gdp to mother ostankya's faction
	core:add_listener(
		"region_gdp_leech_mother_ostankya",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == mother_ostankya_features.ostankya_faction
		end,
		function()
			for _, region in model_pairs(cm:model():world():region_manager():region_list()) do
				local bv = cm:get_regions_bonus_value(region, "region_gdp_leech_mother_ostankya")
				
				if bv > 0 then
					cm:treasury_mod(mother_ostankya_features.ostankya_faction, math.round(region:gdp() * (bv / 100)))
				end
			end
		end,
		true
	)

	-- spawn disciple armies for mother ostankya
	core:add_listener(
		"create_disciple_army_mother_ostankya",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == mother_ostankya_features.ostankya_faction
		end,
		function()
			for _, faction in model_pairs(cm:model():world():faction_list()) do
				local bv = cm:get_factions_bonus_value(faction, "create_disciple_army_mother_ostankya")
				
				if bv > 0 then
					local save_value = faction:name() .. "_create_disciple_army_mother_ostankya"
					
					if cm:get_saved_value(save_value) then
						cm:set_saved_value(save_value, false)
					else
						local region_list = faction:region_list()
						local region_to_spawn_in = region_list:item_at(cm:random_number(region_list:num_items()) - 1):name()
						local x, y = cm:find_valid_spawn_location_for_character_from_settlement(mother_ostankya_features.ostankya_faction, region_to_spawn_in, false, true, 12)
						
						if x > 0 then
							local units = "wh3_dlc24_ksl_mon_the_things_in_the_woods,wh3_dlc24_ksl_mon_the_things_in_the_woods,wh3_dlc24_ksl_mon_incarnate_elemental_of_beasts,wh3_main_ksl_mon_elemental_bear_0"
							
							if bv > 1 then
								units = "wh3_dlc24_ksl_mon_the_things_in_the_woods,wh3_dlc24_ksl_mon_the_things_in_the_woods,wh3_dlc24_ksl_mon_the_things_in_the_woods,wh3_dlc24_ksl_mon_incarnate_elemental_of_beasts,wh3_dlc24_ksl_mon_incarnate_elemental_of_beasts,wh3_main_ksl_mon_elemental_bear_0"
							end
							
							cm:create_force_with_general(
								mother_ostankya_features.ostankya_faction,
								units,
								region_to_spawn_in,
								x,
								y,
								"general",
								"wh3_dlc24_ksl_boyar_summoned",
								"",
								"",
								"",
								"",
								false,
								function(cqi)
									cm:apply_effect_bundle_to_characters_force("wh3_dlc24_bundle_ksl_mother_ostankya_disciple_army", cqi, 0)
									cm:replenish_action_points(cm:char_lookup_str(cqi))
								end
							)
						end
						
						cm:set_saved_value(save_value, true)
					end
				end
			end
		end,
		true
	)
	
	-- leech faction's background income to Jade dragon
	core:add_listener(
		"faction_gdp_leech_yuan_bo",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == matters_of_state.faction_string
		end,
		function(context)
			local income_sum = 0
			local yuan_siphon_bundle = "wh3_dlc24_ritual_cth_mos_stone_faction_steal_background_income_self"
			local yuan_faction = context:faction()

			for _, faction in model_pairs(cm:model():world():faction_list()) do
				local bv = cm:get_factions_bonus_value(faction, "steal_gdp_for_yuan_bo")

				if bv > 0 then
					cm:treasury_mod(matters_of_state.faction_string, bv)
					cm:treasury_mod(faction:name(), -bv)
					income_sum = income_sum + bv
				end
			end

			if yuan_faction:has_effect_bundle(yuan_siphon_bundle) then
				cm:remove_effect_bundle(yuan_siphon_bundle, matters_of_state.faction_string)
			end;
			
			if income_sum > 0 then
				local bundle = cm:create_new_custom_effect_bundle(yuan_siphon_bundle)
		
				bundle:add_effect("wh3_dlc24_ritual_cth_mos_stone_faction_steal_background_income_self", "faction_to_faction_own", income_sum)
				bundle:set_duration(0)
				cm:apply_custom_effect_bundle_to_faction(bundle, yuan_faction)
			end;
		end,
		true
	)
end

-- Support for the blue scribes skill that generates a random cataclysm spell for the attached army
core:add_listener(
	"force_scribes_cataclysm_bundle",
	"CharacterTurnStart",
	function(context)
		return cm:get_characters_bonus_value(context:character(), "scribes_random_cataclysm") == 1
	end,
	function(context)
		local force = context:character():military_force()
		local bundle = cm:create_new_custom_effect_bundle("wh3_dlc24_scripted_scribes_random_cataclysm")
		local roll = cm:random_number(8)
		bundle:add_effect("wh3_dlc24_effect_scribes_random_cataclysm_roll_"..roll, "force_to_force_own", 1)
		cm:apply_custom_effect_bundle_to_force(bundle, force)
	end,
	true
);
core:add_listener(
	"force_scribes_cataclysm_bundle",
	"CharacterLeavesMilitaryForce",
	function(context)
		local mf = context:military_force()
		return mf:has_general() and mf:has_effect_bundle("wh3_dlc24_scripted_scribes_random_cataclysm") and cm:get_characters_bonus_value(mf:general_character(), "scribes_random_cataclysm") == 0
	end,
	function(context)
		cm:remove_effect_bundle_from_force("wh3_dlc24_scripted_scribes_random_cataclysm", context:military_force():command_queue_index())
	end,
	true
);

core:add_listener(
	"skulltaker_post_battle_bundle",
	"CharacterCompletedBattle",
	function(context)
		local character = context:character()
		return cm:get_characters_bonus_value(character, "skulltaker_kills_leave_bundle") > 0 and character:won_battle() == true and character:has_region()
	end,
	function(context)
		local character = context:character()
		cm:apply_effect_bundle_to_region("wh3_dlc26_skulltaker_skill_legacy_of_blood", character:region():name() , cm:get_characters_bonus_value(character, "skulltaker_kills_leave_bundle"))
	end,
true
)

-------------------------------------------------------------------------------------------------------------------
--------------------------- GOLGFAG - EASY, COME, EASY, GO scripted bonus value and data --------------------------
-------------------------------------------------------------------------------------------------------------------
easy_come_easy_go = {
	
	--ancillary and effect keys for abilities gained from weapons
	weapon = {
		{ancillary_key = "wh_dlc03_anc_weapon_the_brass_cleaver", 	effect_key = "wh_dlc03_effect_ability_enable_the_brass_cleaver"},
		{ancillary_key = "wh_main_anc_weapon_sword_of_anti-heroes", effect_key = "wh_main_effect_ability_enable_sword_of_anti-heroes"},
		{ancillary_key = "wh_main_anc_weapon_tormentor_sword", 		effect_key = "wh_main_effect_ability_enable_tormentor_sword"},
		{ancillary_key = "wh_main_anc_weapon_warrior_bane", 		effect_key = "wh_main_effect_ability_enable_warrior_bane"},
		{ancillary_key = "wh3_main_anc_weapon_blood_cleaver", 		effect_key = "wh3_main_effect_ability_enable_blood_cleaver"},
		{ancillary_key = "wh3_main_anc_weapon_siegebreaker", 		effect_key = "wh3_main_effect_ability_enable_bound_siegebreaker_2"},
		{ancillary_key = "wh3_main_anc_weapon_the_tenderiser", 		effect_key = "wh3_main_effect_ability_enable_bound_the_tenderiser_2"},
		{ancillary_key = "wh3_main_anc_weapon_thundermace", 		effect_key = "wh3_main_effect_ability_enable_bound_thundermace_1"},
	},
	--ancillary and effect keys for abilities gained from armour and enchanted_items
	armour_and_enchanted_item = {
	--armour
		{ancillary_key = "wh_main_anc_armour_charmed_shield", 		effect_key = "wh_main_effect_ability_enable_charmed_shield"},
		{ancillary_key = "wh_main_anc_armour_glittering_scales", 	effect_key = "wh_main_effect_ability_enable_glittering_scales"},
		{ancillary_key = "wh_main_anc_armour_helm_of_discord", 		effect_key = "wh_main_effect_ability_enable_helm_of_discord"},
		{ancillary_key = "wh3_main_anc_armour_gut_maw", 			effect_key = "wh3_main_effect_ability_enable_gut_maw"},
	--enchanted_item
		{ancillary_key = "wh_main_anc_talisman_opal_amulet", 				effect_key = "wh_main_effect_ability_enable_master_opal_amulet"},
		{ancillary_key = "wh_main_anc_talisman_pidgeon_plucker_pendant", 	effect_key = "wh_main_effect_ability_enable_pidgeon_plucker_pendant"},
		{ancillary_key = "wh3_main_anc_talisman_gnoblar_thiefstone", 		effect_key = "wh3_main_effect_ability_enable_gnoblar_thiefstone"},
		{ancillary_key = "wh3_main_anc_talisman_greedy_fist", 				effect_key = "wh3_main_effect_ability_enable_greedy_fist"},
	},
	--ancillary and effect keys for abilities gained from talismans
	talisman = {
		{ancillary_key = "wh3_main_anc_enchanted_item_potion_of_farsight", 			effect_key = "wh3_main_effect_ability_enable_potion_of_farsight"},
		{ancillary_key = "wh_main_anc_enchanted_item_crown_of_command", 			effect_key = "wh_main_effect_ability_enable_crown_of_command"},
		{ancillary_key = "wh_main_anc_enchanted_item_featherfoe_torc", 				effect_key = "wh_main_effect_ability_enable_featherfoe_torc"},
		{ancillary_key = "wh_main_anc_enchanted_item_healing_potion", 				effect_key = "wh_main_effect_ability_enable_potion_of_healing"},
		{ancillary_key = "wh_main_anc_enchanted_item_potion_of_foolhardiness", 		effect_key = "wh_main_effect_ability_enable_potion_of_foolhardiness"},
		{ancillary_key = "wh_main_anc_enchanted_item_potion_of_speed", 				effect_key = "wh_main_effect_ability_enable_potion_of_speed"},
		{ancillary_key = "wh_main_anc_enchanted_item_potion_of_strength", 			effect_key = "wh_main_effect_ability_enable_potion_of_strength"},
		{ancillary_key = "wh_main_anc_enchanted_item_potion_of_toughness", 			effect_key = "wh_main_effect_ability_enable_potion_of_toughness"},
		{ancillary_key = "wh_main_anc_enchanted_item_the_other_tricksters_shard", 	effect_key = "wh_main_effect_ability_enable_the_other_tricksters_shard"},
		{ancillary_key = "wh3_main_anc_enchanted_item_brahmir_statue", 				effect_key = "wh3_main_effect_ability_enable_brahmir_statue"},
		{ancillary_key = "wh3_main_anc_enchanted_item_fistful_of_laurels", 			effect_key = "wh3_main_effect_ability_enable_bound_fistful_of_laurels"},
		{ancillary_key = "wh3_main_anc_enchanted_item_jade_lion", 					effect_key = "wh3_main_effect_ability_enable_jade_lion"},
		{ancillary_key = "wh3_main_anc_enchanted_item_rock_eye", 					effect_key = "wh3_main_effect_ability_enable_rock_eye"},
	},
}

function return_which_character_has_scripted_bv(bonus_value, pending_battle)
	
	local character_with_bonus_value = nil

	--loop through all character to find the bonus value
	local attacker = pending_battle:attacker()
	local defender = pending_battle:defender()

	if not attacker:is_null_interface() and cm:get_characters_bonus_value(attacker, bonus_value) > 0 then
		return attacker
	end			
	if not defender:is_null_interface() and cm:get_characters_bonus_value(defender, bonus_value) > 0 then
		return defender
	end

	local attacker_list = pending_battle:secondary_attackers()
	local defender_list = pending_battle:secondary_defenders()

	for i = 0, attacker_list:num_items() - 1 do
		local attacker = attacker_list:item_at(i)
		if not attacker:is_null_interface() and cm:get_characters_bonus_value(attacker, bonus_value) > 0 then
			return attacker
		end
	end				
	for i = 0, defender_list:num_items() - 1 do
		local defender = defender_list:item_at(i)
		if not defender:is_null_interface() and cm:get_characters_bonus_value(defender, bonus_value) > 0 then
			return defender
		end
	end


	return false
end

core:add_listener(
	"EasyComeEasyGo_PendingBattle",
	"PendingBattle",
	function(context)
		return pending_battle_bv_check("easy_come_easy_go", context:pending_battle(), false, true)
	end,
	function(context)
		local pb = context:pending_battle()
		local character_with_bonus_value = return_which_character_has_scripted_bv("easy_come_easy_go", pb)

		--create set of ancillary abilities
		local random_ancillaries = {}

		for anc_type, anc_table in pairs(easy_come_easy_go) do
			local ancillary_added = false
			while(not ancillary_added) do
				local random_number = cm:random_number(#anc_table)
				local ancillary_key = anc_table[random_number].ancillary_key
				local effect_key = anc_table[random_number].effect_key

				if character_with_bonus_value:character_details():has_ancillary(ancillary_key) == false then
					table.insert(random_ancillaries, effect_key)
					ancillary_added = true					
				end
			end
			
		end
		
		--create custom effect bundle with ancillary abilities
		local easy_come_easy_go_bundle = cm:create_new_custom_effect_bundle("wh3_dlc26_easy_come_easy_go_scripted_hidden")

		for i = 1, #random_ancillaries do
			easy_come_easy_go_bundle:add_effect(random_ancillaries[i], "character_to_character_own", 1)
		end
		easy_come_easy_go_bundle:set_duration(1)
		cm:apply_custom_effect_bundle_to_character(easy_come_easy_go_bundle, character_with_bonus_value)
		
		cm:update_pending_battle()
	end,
	true
)

core:add_listener(
	"EasyComeEasyGo_BattleCompleted",
	"BattleCompleted",
	function(context)
		return pending_battle_bv_check("easy_come_easy_go", context:model():pending_battle(), false, true)
	end,
	function(context)
		local pb = context:model():pending_battle()
		local character_with_bonus_value = return_which_character_has_scripted_bv("easy_come_easy_go", pb)
		cm:remove_effect_bundle_from_character("wh3_dlc26_easy_come_easy_go_scripted_hidden", character_with_bonus_value)
	end,
	true
)

core:add_listener(
	"siege_army_abilities_fort_battles",
	"PendingBattle",
	function(context)
		local pb = context:pending_battle()

		if pb:has_attacker() then
			local attacker = pb:attacker()

			if attacker:has_region() then
				local region = attacker:region()

				return region:resource_exists("res_bastion") or region:resource_exists("res_empire_fort") or region:resource_exists("res_fortress")
			end
		end
	end,
	function(context)
		local function apply_army_abilities(mf)
			local mf_cqi = mf:command_queue_index()
			
			if cm:get_forces_bonus_value(mf, "army_ability_enable_shatterstone_scripted") > 0 then
				cm:apply_effect_bundle_to_force("wh2_dlc17_bundle_army_ability_enable_shatterstone_hidden", mf_cqi, 0)	
			end

			if cm:get_forces_bonus_value(mf, "army_ability_enable_vauls_hammer_scripted") > 0 then
				cm:apply_effect_bundle_to_force("wh2_main_bundle_army_ability_enable_vauls_hammer_hidden", mf_cqi, 0)	
			end

			if cm:get_forces_bonus_value(mf, "army_ability_enable_stoneshaker_scripted") > 0 then
				cm:apply_effect_bundle_to_force("wh3_main_bundle_army_ability_enable_stoneshaker_hidden", mf_cqi, 0)	
			end
		end
		
		local pb = context:pending_battle()
		
		apply_army_abilities(pb:attacker():military_force())

		for _, sa in model_pairs(pb:secondary_attackers()) do
			apply_army_abilities(sa:military_force())
		end
		
		cm:update_pending_battle()
	end,
	true
)

core:add_listener(
	"siege_army_abilities_fort_battles_cleanup",
	"BattleCompleted",
	true,
	function(context)
		local function remove_bundles(character)
			if character:has_military_force() then
				local mf = character:military_force()
				local mf_cqi = mf:command_queue_index()

				if mf:has_effect_bundle("wh2_dlc17_bundle_army_ability_enable_shatterstone_hidden") then
					cm:remove_effect_bundle_from_force("wh2_dlc17_bundle_army_ability_enable_shatterstone_hidden", mf_cqi)
				end

				if mf:has_effect_bundle("wh2_main_bundle_army_ability_enable_vauls_hammer_hidden") then
					cm:remove_effect_bundle_from_force("wh2_main_bundle_army_ability_enable_vauls_hammer_hidden", mf_cqi)
				end

				if mf:has_effect_bundle("wh3_main_bundle_army_ability_enable_stoneshaker_hidden") then
					cm:remove_effect_bundle_from_force("wh3_main_bundle_army_ability_enable_stoneshaker_hidden", mf_cqi)
				end
			end
		end

		local pb = cm:model():pending_battle()

		if pb:has_attacker() then
			remove_bundles(pb:attacker())
		end

		for _, character in model_pairs(pb:secondary_attackers()) do
			remove_bundles(character)
		end

		if pb:has_defender() then
			remove_bundles(pb:defender())
		end

		for _, character in model_pairs(pb:secondary_defenders()) do
			remove_bundles(character)
		end
	end,
	true
)

core:add_listener(
	"replenish_force_post_battle_win",
	"CharacterCompletedBattle",
	function(context)
		return context:character():won_battle()
	end,
	function(context)
		local character = context:character()
		local bonus_value = cm:get_characters_bonus_value(character, "replenish_force_post_battle_win")

		if bonus_value > 0 and character:has_military_force() then
			for _, unit in model_pairs(character:military_force():unit_list()) do
				local health_to_set = (unit:percentage_proportion_of_full_strength() + bonus_value) / 100
				cm:set_unit_hp_to_unary_of_maximum(unit, math.min(health_to_set, 1))
			end
		end

	end,
	true
)

core:add_listener(
	"research_bonus_post_battle_win",
	"CharacterCompletedBattle",
	function(context)
		return context:character():won_battle()
	end,
	function(context)
		local character = context:character()
		local immediate_research_points_bonus_value = cm:get_characters_bonus_value(character, "research_bonus_post_battle_win")
		local research_rate_bonus_value = cm:get_characters_bonus_value(character, "research_rate_bonus_post_battle_win")

		if immediate_research_points_bonus_value > 0 then
			cm:grant_research_points(character:faction():name(), immediate_research_points_bonus_value)
		end

		if research_rate_bonus_value > 0 then
			cm:grant_research_rate_points(character:faction():name(), research_rate_bonus_value)
		end
	end,
	true
)

core:add_listener(
	"experience_bonus_post_battle_win",
	"CharacterCompletedBattle",
	function(context)
		return context:character():won_battle()
	end,
	function(context)
		local character = context:character()		
				
		--check if character has a military force
		if character:has_military_force() then
			local character_force = character:military_force()
			local force_bonus_value = cm:get_forces_bonus_value(character_force, "experience_bonus_post_battle_win")

			--check if the bonus value is being applied at force level
			if force_bonus_value > 0 then
				for _, mf_ch in model_pairs(character:military_force():character_list()) do
					cm:add_agent_experience(cm:char_lookup_str(mf_ch:cqi()), force_bonus_value, false)
				end
			end
		end

		local character_bonus_value = cm:get_characters_bonus_value(character, "experience_bonus_post_battle_win")
		--check if bonus value is applied at character level
		if character_bonus_value > 0 then
			cm:add_agent_experience(cm:char_lookup_str(character:cqi()), character_bonus_value, false)
		end
	end,
	true
)

core:add_listener(
	"foreign_slot_damage_settlement_garrison_percentage",
	"FactionTurnStart",
	function(context)
		local fsm = context:faction():foreign_slot_managers()
		return not fsm:is_empty()
	end,
	function(context)
		local faction = context:faction()
		local fsm = faction:foreign_slot_managers()

		for i = 0, fsm:num_items() - 1 do
			local slot_region = fsm:item_at(i):region()

			-- check for garrison damage
			local damage_scripted_value = cm:get_regions_bonus_value(slot_region, "foreign_slot_damage_settlement_garrison_percentage") / 100

			if damage_scripted_value > 0 then
				local garrison_residence = slot_region:garrison_residence()
				cm:sabotage_garrison_army(garrison_residence, damage_scripted_value)
			end
		end
	end,
	true
)