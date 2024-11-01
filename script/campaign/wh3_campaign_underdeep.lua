local low_settlement_effect_key = "wh3_main_bundle_dwarf_low_settlement_count_income";
local low_settlement_dummy_key = "wh3_main_bundle_dwarf_low_settlement_count_dummy";
local max_regions_for_bonus = 5;
local bonus_income_per_turn = 5;
local bonus_income_per_region = -5;
local gold_resource_regions = {};
local DEBUG_spawn_unique_blockers = false;

underdeep_possible_blockers = {
	{key = "NOTHING", weight = 130},
	{key = "wh3_main_underdeep_dwf_blocker_gold_1", weight = 3},
	{key = "wh3_main_underdeep_dwf_blocker_beer_1", weight = 2},
	{key = "wh3_main_underdeep_dwf_blocker_doomsphere_1", weight = 2},
	{key = "wh3_main_underdeep_dwf_blocker_lab_1", weight = 3},
	{key = "wh3_main_underdeep_dwf_blocker_machines_1", weight = 2},
	{key = "wh3_main_underdeep_dwf_blocker_warpstone_1", weight = 2}
};
underdeep_eight_peaks_key = "wh3_main_combi_region_karak_eight_peaks";
underdeep_skavenblight_key = "wh3_main_combi_region_skavenblight";
underdeep_zharr_naggrund_key = "wh3_main_combi_region_zharr_naggrund";

function add_underdeep_listeners()
	out("#### Adding Underdeep Listeners ####");
	if cm:is_new_game() == true then
		local faction_list = cm:model():world():faction_list();
		
		for i = 0, faction_list:num_items() - 1 do
			local faction = faction_list:item_at(i);
			
			if faction:culture() == "wh_main_dwf_dwarfs" then
				if faction:name() == "wh_main_dwf_dwarfs" then -- Thorgrim
					cm:faction_add_pooled_resource(faction:name(), "dwf_underdeeps", "underdeep_faction", 2);
				elseif faction:name() == "wh_main_dwf_karak_izor" then -- Belegar
					cm:faction_add_pooled_resource(faction:name(), "dwf_underdeeps", "underdeep_faction", 2);
				else
					cm:faction_add_pooled_resource(faction:name(), "dwf_underdeeps", "underdeep_faction", 1);
				end

				underdeep_update_region_count_dummy(faction);
			end
		end

		local region_list = cm:model():world():region_manager():region_list();

		for i = 0, region_list:num_items() - 1 do
			local region = region_list:item_at(i);
			underdeep_update_region_adjacency_dummy(region, false);
		end
	end

	-- Lock the drinking hall behind technology
	local faction_list = cm:model():world():faction_list();
	
	for i = 0, faction_list:num_items() - 1 do
		local faction = faction_list:item_at(i);
		
		if faction:culture() == "wh_main_dwf_dwarfs" then
			if faction:has_technology("wh_main_tech_dwf_civ_6_2") and faction:has_technology("wh_main_tech_dwf_civ_2_0") and faction:has_technology("wh_main_tech_dwf_mil_1_3") then
				cm:remove_event_restricted_building_record_for_faction("wh3_main_underdeep_dwf_economy_drinking_2", faction:name());
			else
				cm:add_event_restricted_building_record_for_faction("wh3_main_underdeep_dwf_economy_drinking_2", faction:name(), "underdeep_drinking_reason");
			end
		end
	end
	
	-- This function handles creations of the underdeep slots when the above ground building is constructed
	core:add_listener(
		"UnderdeepBuildingCompleted",
		"BuildingCompleted",
		function(context)
			return context:building():name() == "wh3_main_DWARFS_underdeep_1"
		end,
		function(context)
			out("#### Underdeep Created ####");
			local underdeep_key = "wh3_main_slot_set_underdeep_dwarf_major";
			local region = context:garrison_residence():region();
			local faction = context:building():faction();

			if region:is_province_capital() == false then
				underdeep_key = "wh3_main_slot_set_underdeep_dwarf_minor";
			end

			if region:name() == underdeep_eight_peaks_key then
				underdeep_key = "wh3_main_slot_set_underdeep_dwarf_karak_eight_peaks";
			elseif region:name() == underdeep_skavenblight_key then
				underdeep_key = "wh3_main_slot_set_underdeep_dwarf_skavenblight";
			elseif region:name() == underdeep_zharr_naggrund_key or region:name() == "wh3_main_chaos_region_zharr_naggrund" then
				underdeep_key = "wh3_main_slot_set_underdeep_dwarf_zharr_naggrund";
			end
			
			cm:faction_add_pooled_resource(faction:name(), "dwf_underdeeps", "underdeep_buildings_negative", -1);
			cm:add_foreign_slot_set_to_region_for_faction(faction:command_queue_index(), region:cqi(), underdeep_key);
			local slot_list = region:foreign_slot_manager_for_faction(faction:name()):slots();

			if underdeep_key == "wh3_main_slot_set_underdeep_dwarf_major" then
				cm:foreign_slot_instantly_upgrade_building(slot_list:item_at(0), "wh3_main_underdeep_dwf_main_major_1");
			elseif underdeep_key == "wh3_main_slot_set_underdeep_dwarf_minor" then
				cm:foreign_slot_instantly_upgrade_building(slot_list:item_at(0), "wh3_main_underdeep_dwf_main_minor_1");
			elseif underdeep_key == "wh3_main_slot_set_underdeep_dwarf_karak_eight_peaks" then
				cm:foreign_slot_instantly_upgrade_building(slot_list:item_at(0), "wh3_main_underdeep_dwf_main_karak_eight_peaks_1");
			elseif underdeep_key == "wh3_main_slot_set_underdeep_dwarf_skavenblight" then
				cm:foreign_slot_instantly_upgrade_building(slot_list:item_at(0), "wh3_main_underdeep_dwf_main_skavenblight_1");
			elseif underdeep_key == "wh3_main_slot_set_underdeep_dwarf_zharr_naggrund" then
				cm:foreign_slot_instantly_upgrade_building(slot_list:item_at(0), "wh3_main_underdeep_dwf_main_zharr_naggrund_1");
			end

			local has_blocker_removal_tech = faction:has_technology("wh_main_tech_dwf_civ_6_2");

			-- Create the buildings that block slots
			if underdeep_key == "wh3_main_slot_set_underdeep_dwarf_major" then
				underdeep_spawn_blockers(region:name(), slot_list, {1, 2, 4, 5}, 3, has_blocker_removal_tech, faction:is_human());
			elseif underdeep_key == "wh3_main_slot_set_underdeep_dwarf_minor" then
				underdeep_spawn_blockers(region:name(), slot_list, {1, 3}, 2, has_blocker_removal_tech, faction:is_human());
			elseif DEBUG_spawn_unique_blockers == true then
				cm:foreign_slot_instantly_upgrade_building(slot_list:item_at(1), "wh3_main_underdeep_dwf_blocker_beer_1");
				cm:foreign_slot_instantly_upgrade_building(slot_list:item_at(2), "wh3_main_underdeep_dwf_blocker_doomsphere_1");
				cm:foreign_slot_instantly_upgrade_building(slot_list:item_at(3), "wh3_main_underdeep_dwf_blocker_gold_1");
				cm:foreign_slot_instantly_upgrade_building(slot_list:item_at(4), "wh3_main_underdeep_dwf_blocker_lab_1");
				cm:foreign_slot_instantly_upgrade_building(slot_list:item_at(5), "wh3_main_underdeep_dwf_blocker_machines_1");
				cm:foreign_slot_instantly_upgrade_building(slot_list:item_at(6), "wh3_main_underdeep_dwf_blocker_skaven_1");
				cm:foreign_slot_instantly_upgrade_building(slot_list:item_at(7), "wh3_main_underdeep_dwf_blocker_warpstone_1");
			elseif underdeep_key == "wh3_main_slot_set_underdeep_dwarf_karak_eight_peaks" then
				underdeep_spawn_blockers(region:name(), slot_list, {}, 4, true, faction:is_human());
			elseif underdeep_key == "wh3_main_slot_set_underdeep_dwarf_skavenblight" then
				underdeep_spawn_blockers(region:name(), slot_list, {}, 4, true, faction:is_human());
			elseif underdeep_key == "wh3_main_slot_set_underdeep_dwarf_zharr_naggrund" then
				underdeep_spawn_blockers(region:name(), slot_list, {}, 4, true, faction:is_human());
			end
		end,
		true
	);

	core:add_listener(
		"UnderdeepForeignSlotBuildingCompleteEvent",
		"ForeignSlotBuildingCompleteEvent",
		function(context)
			return context:slot_manager():faction():culture() == "wh_main_dwf_dwarfs"
		end,
		function(context)
			local key = context:building();
			local slot_manager = context:slot_manager();
			local region = slot_manager:region();
			local faction = slot_manager:faction();
			local slot_list = slot_manager:slots();
			local climate = region:settlement():get_climate();

			if key == "wh3_main_underdeep_dwf_main_minor_2" then
				cm:faction_add_pooled_resource(faction:name(), "dwf_underdeeps", "underdeep_buildings_positive", 1);
				if climate == "climate_mountain" then
					underdeep_remove_slot_blockers(slot_list, {3});
				end
			elseif key == "wh3_main_underdeep_dwf_main_major_2" then
				cm:faction_add_pooled_resource(faction:name(), "dwf_underdeeps", "underdeep_buildings_positive", 1);
				if climate == "climate_mountain" then
					underdeep_remove_slot_blockers(slot_list, {1, 4});
				end
			elseif key == "wh3_main_underdeep_dwf_main_minor_3" or key == "wh3_main_underdeep_dwf_main_major_3" then
				cm:faction_add_pooled_resource(faction:name(), "dwf_underdeeps", "underdeep_buildings_positive", 1);
				if climate == "climate_mountain" then
					underdeep_remove_slot_blockers(slot_list, {1, 2, 3, 4, 5});
				end
			end

			if key == "wh3_main_underdeep_dwf_grudges_2_a" then
				common.set_context_value("cycle_grudge_target", 0);
				common.set_context_value("cycle_grudge_value", -1);
				grudge_cycle.delayed_factions[faction:name()] = true;

				for i = 0, 5 do
					cm:remove_effect_bundle("wh3_dlc25_grudge_cycle_"..i, faction:name());
				end
				cm:apply_effect_bundle("wh3_dlc25_grudge_cycle_0", faction:name(), 0);
			end

			if key == "wh3_main_underdeep_dwf_main_karak_eight_peaks_3" then
				cm:trigger_dilemma(faction:name(), "wh3_main_dwf_move_capital_eight_peaks");
			end
		end,
		true
	);

	core:add_listener(
		"UnderdeepForeignSlotBuildingDismantledEvent",
		"ForeignSlotBuildingDismantledEvent",
		function(context)
			return context:slot_manager():faction():culture() == "wh_main_dwf_dwarfs"
		end,
		function(context)
			local key = context:building();
			local slot_manager = context:slot_manager();
			local region = slot_manager:region();
			local faction = slot_manager:faction();

			if key == "wh3_main_underdeep_dwf_blocker_doomsphere_1" then
				local nuke_chance = 100;
				local region_chars = region:characters_in_region();

				for i = 0, region_chars:num_items() - 1 do
					local char = region_chars:item_at(i);
					local subtype = char:character_subtype_key();
					
					if (subtype == "wh_main_dwf_master_engineer" or subtype == "wh_dlc06_dwf_master_engineer_ghost") and char:faction():name() == faction:name() then
						nuke_chance = 1;
						break;
					end
				end
				out("Doomsphere chance: "..nuke_chance);

				if cm:model():random_percent(nuke_chance) then
					cm:callback(function() 
						-- Now I am become death, destroyer of... the Dawi?
						under_empire_nuke_region(region, "", "", true);
					end, 0.2);
				end
			elseif key == "wh3_main_underdeep_dwf_blocker_gold_1" then
				cm:faction_add_pooled_resource(faction:name(), "dwf_oathgold", "buildings", 500);
			elseif key == "wh3_main_underdeep_dwf_grudges_2_a" then
				local stop_grudge_bv = cm:get_factions_bonus_value(faction:name(), "dwf_grudge_feature_off");

				if stop_grudge_bv == 0 then
					grudge_cycle.faction_times[faction:name()] = 0;

					for i = 0, 5 do
						cm:remove_effect_bundle("wh3_dlc25_grudge_cycle_"..i, faction:name());
					end
				end
			end
		end,
		true
	);
	
	-- All Dwarf foreign slots are underdeeps and if they are missing certain buildings have to be destroyed
	core:add_listener(
		"UnderdeepFactionTurnStart",
		"FactionTurnStart",
		function(context)
			return context:faction():foreign_slot_managers():is_empty() == false and context:faction():culture() == "wh_main_dwf_dwarfs";
		end,
		function(context)
			local faction = context:faction();
			local fsms = faction:foreign_slot_managers();
			
			for i = 0, fsms:num_items() - 1 do
				local fsm = fsms:item_at(i);
				local current_region = fsm:region();

				if fsm:faction():command_queue_index() == current_region:owning_faction():command_queue_index() then
					if current_region:building_exists("wh3_main_DWARFS_underdeep_1") == false and current_region:building_exists("wh3_main_DWARFS_underdeep_2") == false then
						-- If no above ground building, destroy the foreign slots
						cm:remove_faction_foreign_slots_from_region(faction:command_queue_index(), current_region:cqi());
					else
						local has_underdeep_entrance = 0;
						local slots = fsm:slots();
						
						for j = 0, slots:num_items() - 1 do
							local slot = slots:item_at(j);

							if slot:is_null_interface() == false and slot:has_building() == true then
								local key = slot:building()
								if key == "wh3_main_underdeep_dwf_main_major_3" or
								key == "wh3_main_underdeep_dwf_main_minor_3" or
								key == "wh3_main_underdeep_dwf_main_karak_eight_peaks_3" or
								key == "wh3_main_underdeep_dwf_main_skavenblight_3" or
								key == "wh3_main_underdeep_dwf_main_zharr_naggrund_3" then
									has_underdeep_entrance = 3;
									break;
								elseif key == "wh3_main_underdeep_dwf_main_major_2" or
								key == "wh3_main_underdeep_dwf_main_minor_2" or
								key == "wh3_main_underdeep_dwf_main_karak_eight_peaks_2" or
								key == "wh3_main_underdeep_dwf_main_skavenblight_2" or
								key == "wh3_main_underdeep_dwf_main_zharr_naggrund_2" then
									has_underdeep_entrance = 2;
									break;
								elseif key == "wh3_main_underdeep_dwf_main_major_1" or
								key == "wh3_main_underdeep_dwf_main_minor_1" or
								key == "wh3_main_underdeep_dwf_main_karak_eight_peaks_1" or
								key == "wh3_main_underdeep_dwf_main_skavenblight_1" or
								key == "wh3_main_underdeep_dwf_main_zharr_naggrund_1" then
									has_underdeep_entrance = 1;
									break;
								end
							end
						end

						if has_underdeep_entrance == 0 then
							-- If the underdeep is missing the entrance then destroy it
							cm:remove_faction_foreign_slots_from_region(faction:command_queue_index(), current_region:cqi());

							-- Find and remove the overground entrance too
							local slot_list = current_region:slot_list();

							for j = 0, slot_list:num_items() - 1 do
								local slot = slot_list:item_at(j);
	
								if slot:is_null_interface() == false and slot:has_building() == true then
									if slot:building():name() == "wh3_main_DWARFS_underdeep_1" or slot:building():name() == "wh3_main_DWARFS_underdeep_2" then
										cm:region_slot_instantly_dismantle_building(slot);
										break;
									end
								end
							end
						end
					end
					
					if cm:get_regions_bonus_value(current_region, "engineer_demolish_building") > 0 then
						-- Demolish any warpstone caches
						local slots = fsm:slots();
						
						for j = 0, slots:num_items() - 1 do
							local slot = slots:item_at(j);

							if slot:is_null_interface() == false and slot:has_building() == true then
								local key = slot:building();

								if key == "wh3_main_underdeep_dwf_blocker_warpstone_1" then
									cm:foreign_slot_instantly_dismantle_building(slot);
								end
							end
						end
					end
				end
			end
			underdeep_update_region_count_dummy(faction);
			underdeep_update_region_income_bonus(faction);
		end,
		true
	);

	core:add_listener(
		"UnderdeepRegionFactionChangeEvent",
		"RegionFactionChangeEvent",
		true,
		function(context)
			local region = context:region();
			local owner = region:owning_faction();
			local previous_faction = context:previous_faction();

			-- Dwarf lost a region
			if previous_faction:culture() == "wh_main_dwf_dwarfs" then
				local fsm = region:foreign_slot_manager_for_faction(previous_faction:name());

				if fsm:is_null_interface() == false then
					local slots = fsm:slots();
					
					for i = 0, slots:num_items() - 1 do
						local slot = slots:item_at(i);

						if slot:is_null_interface() == false and slot:has_building() == true then
							if slot:building() == "wh3_main_underdeep_dwf_defence_slayers_1" then
								cm:callback(
									function()
										cm:set_region_abandoned(region:name());
									end,
								0.2);
							end
						end
					end
				end
				cm:remove_effect_bundle_from_region(low_settlement_effect_key, region:name());
				underdeep_update_region_count_dummy(previous_faction);
			end

			-- Dwarf gained region
			if owner:culture() == "wh_main_dwf_dwarfs" then
				cm:remove_effect_bundle_from_region(low_settlement_effect_key, region:name());
				underdeep_update_region_count_dummy(owner);
				
				local slot_list = region:slot_list();

				for j = 0, slot_list:num_items() - 1 do
					local slot = slot_list:item_at(j);

					if slot:is_null_interface() == false and slot:has_building() == true then
						if slot:building():name() == "wh3_main_DWARFS_underdeep_1" or slot:building():name() == "wh3_main_DWARFS_underdeep_2" then
							cm:region_slot_instantly_dismantle_building(slot);
							break;
						end
					end
				end
			end
			underdeep_update_region_adjacency_dummy(region, true);
		end,
		true
	);

	core:add_listener(
		"UnderdeepResearchCompleted",
		"ResearchCompleted",
		function(context)
			return context:faction():culture() == "wh_main_dwf_dwarfs";
		end,
		function(context)
			local faction = context:faction();
			local tech_key = context:technology();

			if tech_key == "wh_main_tech_dwf_civ_6_2" and faction:foreign_slot_managers():is_empty() == false then
				local fsms = faction:foreign_slot_managers();
				
				for i = 0, fsms:num_items() - 1 do
					local fsm = fsms:item_at(i);
					local current_region = fsm:region();

					if fsm:faction():command_queue_index() == current_region:owning_faction():command_queue_index() then
						local slots = fsm:slots();
						
						for j = 0, slots:num_items() - 1 do
							local slot = slots:item_at(j);

							if slot:is_null_interface() == false and slot:has_building() == true and slot:building() == "wh3_main_underdeep_dwf_blocker_1" then
								cm:foreign_slot_instantly_dismantle_building(slot);
							end
						end
					end
				end
			end
			if faction:has_technology("wh_main_tech_dwf_civ_6_2") and faction:has_technology("wh_main_tech_dwf_civ_2_0") and faction:has_technology("wh_main_tech_dwf_mil_1_3") then
				cm:remove_event_restricted_building_record_for_faction("wh3_main_underdeep_dwf_economy_drinking_2", faction:name());
			end

			if tech_key == "wh_main_tech_dwf_civ_6_3" or tech_key == "wh_main_tech_dwf_civ_4_4" or tech_key == "wh_main_tech_dwf_civ_3_4" then
				cm:faction_add_pooled_resource(faction:name(), "dwf_underdeeps", "underdeep_technology", 1);
			end
		end,
		true
	);
	
	core:add_listener(
		"UnderdeepCharacterSkillPointAllocated",
		"CharacterSkillPointAllocated",
		true,
		function(context)
			if context:skill_point_spent_on() == "wh_main_skill_dwf_lord_unique_thorgrim_high_king" then
				cm:faction_add_pooled_resource(context:character():faction():name(), "dwf_underdeeps", "underdeep_faction", 1);
			elseif context:skill_point_spent_on() == "wh_dlc08_skill_dwf_lord_thorgrim_unique_0" then
				cm:faction_add_pooled_resource(context:character():faction():name(), "dwf_underdeeps", "underdeep_faction", 1);
			elseif context:skill_point_spent_on() == "wh3_dlc25_skill_dwf_unique_thorgrim_unique_5" then
				cm:faction_add_pooled_resource(context:character():faction():name(), "dwf_underdeeps", "underdeep_faction", 1);
			end
		end,
		true
	);

	core:add_listener(
		"UnderdeepDilemmaChoiceMadeEvent",
		"DilemmaChoiceMadeEvent",
		function(context)
			return context:dilemma() == "wh3_main_dwf_move_capital_eight_peaks";
		end,
		function(context)
			if context:choice() == 0 then
				local region = cm:get_region(underdeep_eight_peaks_key);
				cm:change_home_region_of_faction(context:faction(), region);
			end
		end,
		true
	);

	local all_regions = cm:model():world():region_manager():region_list();
	
	for i = 0, all_regions:num_items() - 1 do
		local current_region = all_regions:item_at(i);
		
		for j = 0, current_region:slot_list():num_items() - 1 do
			local current_slot = current_region:slot_list():item_at(j);
		
			if current_slot:resource_key() == "res_gold" or current_slot:resource_key() == "res_gold_idols" then
				gold_resource_regions[current_region:name()] = true;
				break;
			end
		end
	end
end

function underdeep_update_region_count_dummy(faction)
	if faction:is_null_interface() == false then
		if faction:region_list():num_items() <= max_regions_for_bonus then
			cm:apply_effect_bundle(low_settlement_dummy_key, faction:name(), 0);
		else
			cm:remove_effect_bundle(low_settlement_dummy_key, faction:name());
		end
	end
end

function underdeep_update_region_adjacency_dummy(region, recursive)
	if region:is_null_interface() == false then
		local adjacent_dwarf = false;
		local region_owner_cqi = region:owning_faction():command_queue_index();
		local adjacent_region_list = region:adjacent_region_list();

		for i = 0, adjacent_region_list:num_items() - 1 do
			local adjacent_region = adjacent_region_list:item_at(i);

			if adjacent_region:is_null_interface() == false then
				if recursive == true then
					underdeep_update_region_adjacency_dummy(adjacent_region, false);
				end
				
				if adjacent_region:is_abandoned() == false then
					local owner = adjacent_region:owning_faction();

					if owner:is_null_interface() == false and owner:command_queue_index() ~= region_owner_cqi and owner:culture() == "wh_main_dwf_dwarfs" then
						adjacent_dwarf = true;
						break;
					end
				end
			end
		end

		if adjacent_dwarf == false and region:has_effect_bundle("wh3_main_adjacent_dwarf_dummy") == true then
			cm:remove_effect_bundle_from_region("wh3_main_adjacent_dwarf_dummy", region:name());
		elseif adjacent_dwarf == true then
			cm:apply_effect_bundle_to_region("wh3_main_adjacent_dwarf_dummy", region:name(), 0);
		end
	end
end

function underdeep_update_region_income_bonus(faction)
	-- Calculate tall effects
	local region_list = faction:region_list();
	
	for i = 0, region_list:num_items() - 1 do
		local region = region_list:item_at(i);
		cm:remove_effect_bundle_from_region(low_settlement_effect_key, region:name());

		local fsm = region:foreign_slot_manager_for_faction(faction:name());

		if fsm:is_null_interface() == false then
			local region_effect = cm:create_new_custom_effect_bundle(low_settlement_effect_key);
			region_effect:set_duration(0);

			local region_income = bonus_income_per_turn * cm:turn_number();
			local negative_from_regions = bonus_income_per_region * faction:region_list():num_items();
			region_income = region_income + negative_from_regions;
			
			region_effect:add_effect("wh_main_effect_economy_gdp_mod_all", "region_to_region_own", region_income);

			local slots = fsm:slots();
			
			for j = 0, slots:num_items() - 1 do
				local slot = slots:item_at(j);

				if slot:is_null_interface() == false and slot:has_building() == true and (slot:building() == "wh3_main_underdeep_dwf_tall_2" or slot:building() == "wh3_main_underdeep_dwf_tall_3") then
					cm:apply_custom_effect_bundle_to_region(region_effect, region);
					break;
				end
			end
		end
	end
end

function underdeep_remove_slot_blockers(slot_list, blockers)
	-- Go through each slot
	for i = 0, slot_list:num_items() - 1 do
		-- Check each item in the blockers list to see if we have a match
		for j = 1, #blockers do
			if i == blockers[j] then
				-- We have a match, we need to remove this blocker if it exists
				local slot = slot_list:item_at(i);

				if slot:is_null_interface() == false and slot:has_building() == true and slot:building() == "wh3_main_underdeep_dwf_blocker_1" then
					cm:foreign_slot_instantly_dismantle_building(slot);
				end
			end
		end
	end
end

function underdeep_spawn_blockers(region_key, slot_list, block_slots, unique_slot, has_blocker_removal_tech, is_human)
	if is_human == true then
		if gold_resource_regions[region_key] == true then
			cm:foreign_slot_instantly_upgrade_building(slot_list:item_at(unique_slot), "wh3_main_underdeep_dwf_blocker_gold_1");
		else
			local possible_blockers = weighted_list:new();

			for i = 1, #underdeep_possible_blockers do
				possible_blockers:add_item(underdeep_possible_blockers[i].key, underdeep_possible_blockers[i].weight);
			end

			local blocker_key, index = possible_blockers:weighted_select();

			if blocker_key ~= "NOTHING" then
				cm:foreign_slot_instantly_upgrade_building(slot_list:item_at(unique_slot), blocker_key);
			end
		end
	end

	if has_blocker_removal_tech == false then
		for i = 1, #block_slots do
			cm:foreign_slot_instantly_upgrade_building(slot_list:item_at(block_slots[i]), "wh3_main_underdeep_dwf_blocker_1");
		end
	end
end