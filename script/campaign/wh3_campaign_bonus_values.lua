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
		local faction = context:faction();
		
		return faction:is_human() and cm:get_factions_bonus_value(faction, "plague_sight") > 0;
	end,
	function(context)
		local target_general = context:target_force():general_character();
		
		if target_general:has_region() then
			cm:make_region_visible_in_shroud(context:faction():name(), target_general:region():name())
		end;
	end,
	true
);

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

-- destroy the foreign slot a faction starts their turn with this bonus value
core:add_listener(
	"destroy_foreign_slot",
	"FactionTurnStart",
	function(context)
		return not context:faction():foreign_slot_managers():is_empty();
	end,
	function(context)
		local faction = context:faction();
		local fsm = faction:foreign_slot_managers();
		
		for i = 0, fsm:num_items() - 1 do
			local current_region = fsm:item_at(i):region();
			
			if cm:get_regions_bonus_value(current_region, "destroy_foreign_slot") ~= 0 then
				cm:remove_faction_foreign_slots_from_region(faction:command_queue_index(), current_region:cqi());
			end;
		end;
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

-- spawn a disciple army when a faction starts their turn with this bonus value. will only work if the army has the effect bundle wh3_main_ritual_sla_gg_4
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
			
			if current_mf:has_effect_bundle("wh3_main_ritual_sla_gg_4") and current_mf:has_general() then
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
	function(context)
		local sm = context:slot_manager();
		local faction = sm:faction();
		return cm:get_regions_bonus_value(sm:region(), "summon_faction_leader") ~= 0 and faction:has_faction_leader() and faction:faction_leader():has_region();
	end,
	function(context)
		local sm = context:slot_manager()
		local faction = sm:faction()
		local region_name = sm:region():name();
		local x, y = cm:find_valid_spawn_location_for_character_from_settlement(faction:name(), region_name, false, true, 12);
		local faction_leader = faction:faction_leader()

		if x > 0 and faction_leader:has_military_force() then 
			cm:teleport_military_force_to(faction_leader:military_force(), x, y)
		end
	end,
	true
);

-- create a random nurgle plague in the settlement when a building with this bonus value is complete
core:add_listener(
	"create_random_nurgle_plague",
	"ForeignSlotBuildingCompleteEvent",
	function(context)
		return cm:get_regions_bonus_value(context:slot_manager():region(), "create_random_nurgle_plague") ~= 0;
	end,
	function(context)
		local plagues = {
			"wh3_main_nur_base_Ague",
			"wh3_main_nur_base_Buboes",
			"wh3_main_nur_base_Pox",
			"wh3_main_nur_base_Rot",
			"wh3_main_nur_base_Shakes"
		};
		
		local sm = context:slot_manager();
		
		cm:spawn_plague_at_settlement(sm:faction(), sm:region():settlement(), plagues[cm:random_number(#plagues)]);
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

-- add khorne skulls when a battle is fought in this province
core:add_listener(
	"skulls_from_province_battles",
	"BattleCompleted",
	function()
		return not cm:model():pending_battle():region_data():region():is_null_interface();
	end,
	function()
		-- test each region in the province
		local regions = cm:model():pending_battle():region_data():region():province():regions();
		
		for i = 0, regions:num_items() - 1 do
			-- test each foreign slot in the province
			local fsm = regions:item_at(i):foreign_slot_managers();
			
			for j = 0, fsm:num_items() - 1 do
				local faction = fsm:item_at(j):faction();
				local bv = cm:get_factions_bonus_value(faction, "skulls_from_province_battles");
				
				if bv ~= 0 then
					cm:faction_add_pooled_resource(faction:name(), "wh3_main_kho_skulls", "buildings", bv);
				end;
			end;
		end;
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
	true,
	function(context)
		--- don't fire on new game
		if cm:is_new_game() then
			return
		end

		local ruin_spread_start_penalty = -50 -- penalty to spread roll on fresh ruins
		local ruin_spread_fail_mod_mult = 1 -- each time a ruin isn't spread to, increase the chance by this * base chance per turn

		local region_list = context:world():region_manager():region_list()
		for i, start_region in model_pairs(region_list) do	
			if cm:get_regions_bonus_value(start_region, "settlement_spread_to_province_ruin_chance") > 0 then
				local owner_key = start_region:owning_faction():name()
				local province_regions = start_region:province():regions()
				local source_spread_chance = cm:get_regions_bonus_value(start_region, "settlement_spread_to_province_ruin_chance") + cm:get_provinces_bonus_value(start_region:faction_province(), "settlement_spread_to_province_ruin_chance")
				local tracker_bundle_key = "wh3_main_bundle_ruin_spread_chance_modifier"

				for i, target_region in model_pairs(province_regions) do
					if target_region:is_abandoned() then
						local target_bonus = cm:get_regions_bonus_value(target_region, "settlement_spread_to_province_ruin_chance_target_bonus")

						if not target_region:has_effect_bundle(tracker_bundle_key) then
							target_bonus = target_bonus + ruin_spread_start_penalty
						end

						if cm:random_number() <= source_spread_chance + target_bonus then
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
						else
							local ruin_spread_mod_bundle = cm:create_new_custom_effect_bundle(tracker_bundle_key);
							ruin_spread_mod_bundle:add_effect("wh3_main_effect_region_chance_to_spread_to_ruin_target", "region_to_region_own", target_bonus + source_spread_chance*ruin_spread_fail_mod_mult);
							ruin_spread_mod_bundle:set_duration(0)
							cm:apply_custom_effect_bundle_to_region(ruin_spread_mod_bundle,target_region)
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
		
		cm:apply_dilemma_diplomatic_bonus(slot_manager:faction():name(), slot_manager:region():owning_faction():name(), math.clamp(cm:get_regions_bonus_value(slot_manager:region(), "alter_attitude_on_foreign_slot_completion"), -6, 6));
	end,
	true
);
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
