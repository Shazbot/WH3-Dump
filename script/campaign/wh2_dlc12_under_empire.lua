local skaven_under_empire_initial_amount = 3;
local skaven_under_empire_cooldown = 10;
local skaven_under_empire_ruins = {};
local under_empire_plagues = {};
local skaven_under_empire_spawn_weights = {
	subcultures = {
		["wh_main_sc_dwf_dwarfs"] = 5,
		["wh_main_sc_grn_greenskins"] = 4,
		["wh_main_sc_grn_savage_orcs"] = 3,
		["wh_main_sc_emp_empire"] = 2,
		["wh3_main_sc_cth_cathay"] = 2,
		["wh3_main_sc_ksl_kislev"] = 2,
		["wh3_main_sc_ogr_ogre_kingdoms"] = 1,
		["wh_main_sc_teb_teb"] = 1,
		["wh_main_sc_brt_bretonnia"] = 1,
		["wh2_main_sc_lzd_lizardmen"] = 1,
		["wh2_main_sc_def_dark_elves"] = 1
	},
	climates = {
		["climate_mountain"] = 3,
		["climate_jungle"] = 2,
		["climate_wasteland"] = 1,
		["climate_savannah"] = 1,
		["climate_chaotic"] = 1,
		["climate_desert"] = 1,
		["climate_temperate"] = 1,
		["climate_frozen"] = 1,
		["climate_ocean"] = 0,
		["climate_island"] = 0,
		["climate_magicforest"] = 0
	}
};
local skaven_culture = "wh2_main_skv_skaven";
local nuke_cutscene_camera_start_offset = {24.23, 21.1}; -- distance, heading - from the settlement in the cutscene
local nuke_cutscene_camera_end_offset = {31.78, 41.04};
local nuke_cutscene_camera_height_offset = 4; -- amount to zoom out from the settlement in the cutscene

function add_under_empire_listeners()
	out("#### Adding Under-Empire Listeners ####");
	
	core:add_listener(
		"underempire_CharacterGarrisonTargetAction",
		"CharacterGarrisonTargetAction",
		function(context)
			return (context:mission_result_critial_success() or context:mission_result_success()) and context:agent_action_key():find("expand_underempire");
		end,
		function(context)
			local faction = context:character():faction();
			local faction_key = faction:name();
			
			cm:remove_effect_bundle("wh2_dlc12_bundle_underempire_cooldown", faction_key);
			cm:apply_effect_bundle("wh2_dlc12_bundle_underempire_cooldown", faction_key, skaven_under_empire_cooldown + cm:get_factions_bonus_value(faction, "under_empire_cooldown"));
			core:trigger_event("ScriptEventPlayerUnderEmpireEstablished");
		end,
		true
	);
	
	core:add_listener(
		"underempire_FactionBeginTurnPhaseNormal",
		"FactionBeginTurnPhaseNormal",
		function(context)
			return context:faction():culture() == skaven_culture;
		end,
		function(context)
			local faction = context:faction();
			local faction_key = faction:name();
			local is_under_empire_human = faction:is_human();
			
			local skaven_under_empire_turn_cutscene = true;
			local skaven_under_empire_turn_count = 0;
			local skaven_under_empire_advice = false;
			
			local first_nuke = true;
			local first_nuke_pos_x = 0;
			local first_nuke_pos_y = 0;
			
			local under_empires = faction:foreign_slot_managers();
			
			for i = 0, under_empires:num_items() - 1 do
				local under_empire = under_empires:item_at(i);
			
				local region = under_empire:region();
				local region_key = region:name();
				local region_owner = region:owning_faction();
				local region_owner_key = region_owner:name();
				local is_region_owner_human = region_owner:is_human();
				local settlement = region:settlement();
				local settlement_x = settlement:logical_position_x();
				local settlement_y = settlement:logical_position_y();
				
				for j = 0, under_empire:num_slots() - 1 do
					local slot = under_empire:slots():item_at(j);
					
					if not slot:is_null_interface() and slot:has_building() then
						local building_key = slot:building();
						
						if building_key == "wh2_dlc12_under_empire_annexation_doomsday_2" then
							-- Limit Doomsphere VFX to distance from cutscene
							local show_vfx = false;
							
							if first_nuke then
								first_nuke = false;
								show_vfx = true;
								first_nuke_pos_x = settlement_x;
								first_nuke_pos_y = settlement_y;
							else
								local distance_to_first_nuke = distance_squared(settlement_x, settlement_y, first_nuke_pos_x, first_nuke_pos_y);
								
								if distance_to_first_nuke <= 8000 then
									show_vfx = true;
								end
							end
							
							-- Detonate Doomsphere
							under_empire_detonate_nuke(region, skaven_under_empire_turn_cutscene, show_vfx, skaven_under_empire_turn_count, faction_key, region_owner_key);
							skaven_under_empire_turn_cutscene = false;
							skaven_under_empire_turn_count = skaven_under_empire_turn_count + 1;
							
							-- Doomsphere detonated advice
							if not skaven_under_empire_advice then
								if is_under_empire_human then
									skaven_under_empire_advice = true;
									core:trigger_event("ScriptEventUnderEmpireDoomsphereCompleted", region);
								elseif is_region_owner_human then
									skaven_under_empire_advice = true;
									core:trigger_event("ScriptEventUnderEmpireAIDoomsphereCompleted", region);
								end
							end
							break;
						-- Doomsphere build advice
						elseif building_key == "wh2_dlc12_under_empire_annexation_doomsday_1" and not skaven_under_empire_advice and is_under_empire_human then
							skaven_under_empire_advice = true;
							core:trigger_event("ScriptEventUnderEmpireDoomsphereStarted", region);
						elseif building_key == "wh2_dlc12_under_empire_annexation_war_camp_2" then
							-- Spawn Warcamp army
							under_empire_war_camp_created(region_key, faction);
							
							-- Warcamp Advice
							if not skaven_under_empire_advice then
								if is_under_empire_human then
									skaven_under_empire_advice = true;
									core:trigger_event("ScriptEventUnderEmpirePlayerWarCamp", region);
								elseif is_region_owner_human then
									skaven_under_empire_advice = true;
									core:trigger_event("ScriptEventUnderEmpireAIWarCamp", region);
								end
							end
							break;
						elseif building_key == "wh2_dlc14_under_empire_annexation_plague_cauldron_2" then
							-- Spawn Plague Priest
							under_empire_plague_cauldron_created(faction, region);
						end
					end
				end
			end
		end,
		true
	);
	
	core:add_listener(
		"underempire_GarrisonOccupiedEvent",
		"GarrisonOccupiedEvent",
		function(context)
			return skaven_under_empire_ruins[context:garrison_residence():region():name()] ~= nil and context:character():faction():culture() ~= skaven_culture
		end,
		function(context)
			local region_key = context:garrison_residence():region():name();
			
			cm:override_building_chain_display(skaven_under_empire_ruins[region_key][1], skaven_under_empire_ruins[region_key][1], region_key);
			cm:override_building_chain_display(skaven_under_empire_ruins[region_key][2], skaven_under_empire_ruins[region_key][2], region_key);
			skaven_under_empire_ruins[region_key] = nil;
		end,
		true
	);
	
	core:add_listener(
		"underempire_ForeignSlotManagerDiscoveredEvent",
		"ForeignSlotManagerDiscoveredEvent",
		function(context)
			return context:owner():culture() == skaven_culture;
		end,
		function(context)
			local faction = context:owner();
			local region = context:slot_manager():region();
			local region_key = region:name();
			local settlement_x = region:settlement():logical_position_x();
			local settlement_y = region:settlement():logical_position_y();
			local region_owner = context:discoveree();
			
			-- Tell the Under-City owner
			cm:show_message_event_located(
				faction:name(),
				"event_feed_strings_text_wh2_dlc12_event_feed_string_scripted_event_under_empire_discovered_title",
				"regions_onscreen_" .. region_key,
				"event_feed_strings_text_wh2_dlc12_event_feed_string_scripted_event_under_empire_discovered_description",
				settlement_x,
				settlement_y,
				false,
				122
			);
			
			-- Tell the region owner
			cm:show_message_event_located(
				region_owner:name(),
				"event_feed_strings_text_wh2_dlc12_event_feed_string_scripted_event_under_empire_discovered_title",
				"regions_onscreen_" .. region_key,
				"event_feed_strings_text_wh2_dlc12_event_feed_string_scripted_event_under_empire_discovered_description_target",
				settlement_x,
				settlement_y,
				false,
				122
			);
			
			if faction:is_human() then
				core:trigger_event("ScriptEventUnderEmpirePlayerDiscovered", region);
			end
			
			if region_owner:is_human() then
				core:trigger_event("ScriptEventUnderEmpireAIDiscovered", region);
			end
		end,
		true
	);
	
	core:add_listener(
		"underempire_ForeignSlotManagerRemovedEvent",
		"ForeignSlotManagerRemovedEvent",
		function(context)
			return context:owner():culture() == skaven_culture;
		end,
		function(context)
			local owner_key = context:owner():name();
			local remover = context:remover();
			local region = context:region();
			local region_key = region:name();
			local settlement_x = region:settlement():logical_position_x();
			local settlement_y = region:settlement():logical_position_y();
			local cause_was_razing = context:cause_was_razing();
			
			if cause_was_razing then
				-- Tell the Under-City owner their region was razed
				cm:show_message_event_located(
					owner_key,
					"event_feed_strings_text_wh2_dlc12_event_feed_string_scripted_event_under_empire_destroyed_title",
					"regions_onscreen_" .. region_key,
					"event_feed_strings_text_wh2_dlc12_event_feed_string_scripted_event_under_empire_destroyed_razing_description",
					settlement_x,
					settlement_y,
					false,
					124
				);
			else
				-- Tell the Under-City owner they were removed
				cm:show_message_event_located(
					owner_key,
					"event_feed_strings_text_wh2_dlc12_event_feed_string_scripted_event_under_empire_destroyed_title",
					"regions_onscreen_" .. region_key,
					"event_feed_strings_text_wh2_dlc12_event_feed_string_scripted_event_under_empire_destroyed_description",
					settlement_x,
					settlement_y,
					false,
					124
				);
				
				-- Tell the region owner they removed an Under-City
				cm:show_message_event_located(
					remover:name(),
					"event_feed_strings_text_wh2_dlc12_event_feed_string_scripted_event_under_empire_destroyed_title",
					"regions_onscreen_" .. region_key,
					"event_feed_strings_text_wh2_dlc12_event_feed_string_scripted_event_under_empire_destroyed_remover_description",
					settlement_x,
					settlement_y,
					false,
					124
				);
			end
			
			if remover:is_human() and not cause_was_razing then
				core:trigger_event("ScriptEventUnderEmpireRemovedByPlayer", region);
			end
		end,
		true
	);
	
	core:add_listener(
		"underempire_CharacterTurnStart",
		"CharacterTurnStart",
		function(context)
			local character = context:character();
			
			-- Are they an agent in a region and not in an army?
			if not character:is_embedded_in_military_force() and cm:char_is_agent(character) and character:has_region() then
				local region = character:region();
				local character_faction_name = character:faction():name();
				
				-- Is this region occupied and owned by the agents faction?
				if not region:is_null_interface() and not region:is_abandoned() and region:owning_faction():name() == character_faction_name then
					local foreign_slots = region:foreign_slot_managers();
					
					-- Does it have any foreign slots in it?
					for i = 0, foreign_slots:num_items() - 1 do
						local foreign_slot = foreign_slots:item_at(i);
						
						-- Is this foreign slot still hidden?
						if not foreign_slot:is_null_interface() and not foreign_slot:has_been_discovered(region:owning_faction():command_queue_index()) then
							local foreign_slot_faction = foreign_slot:faction()
							
							-- Does it belong to a human Skaven? Is this agents faction different to the foreign slots faction?
							if foreign_slot_faction:is_human() and foreign_slot_faction:culture() == skaven_culture and foreign_slot_faction:name() ~= character_faction_name then
								return true;
							end
						end
					end
				end
			end
		end,
		function(context)
			core:trigger_event("ScriptEventUnderEmpireAgentInRegion", context:character());
		end,
		false
	);
	
	core:add_listener(
		"underempire_RegionPlagueStateChanged",
		"RegionPlagueStateChanged",
		true,
		function(context)
			if context:is_infected() then
				under_empire_plagues[context:region():name()] = true;
			else
				under_empire_plagues[context:region():name()] = nil;
			end
		end,
		true
	);

	if cm:is_new_game() then
		if cm:get_campaign_name() == "main_warhammer" then
			-- Under-City - Karak Eight Peaks - Clan Mors
			local clan_mors = cm:get_faction("wh2_main_skv_clan_mors");
			
			cm:add_foreign_slot_set_to_region_for_faction(clan_mors:command_queue_index(), cm:get_region("wh3_main_combi_region_karak_eight_peaks"):cqi(), "wh2_dlc12_slot_set_underempire");
			cm:make_region_visible_in_shroud("wh2_main_skv_clan_mors", "wh3_main_combi_region_karak_eight_peaks");
			
			local fsm_clan_mors = clan_mors:foreign_slot_managers();
			
			if fsm_clan_mors:num_items() > 0 then
				local first_fsm_slots = fsm_clan_mors:item_at(0):slots();
				
				if first_fsm_slots:num_items() > 0 then
					if clan_mors:is_human() then
						cm:foreign_slot_instantly_upgrade_building(first_fsm_slots:item_at(0), "wh2_dlc12_under_empire_settlement_warren_5");
					else
						cm:foreign_slot_instantly_upgrade_building(first_fsm_slots:item_at(0), "wh2_dlc12_under_empire_discovery_deeper_tunnels_1");
					end;
				else
					script_error("WARNING: attempting to adjust Clan Mors foreign slots at the start of a new game but first foreign slot manager has no slots");
				end;
			else
				script_error("WARNING: attempting to adjust Clan Mors foreign slots at the start of a new game but no foreign slot managers were found");
			end;
			
			if cm:model():random_percent(35) then
				-- Under-City - Altdorf - Clan Moulder
				local altdorf = cm:get_region("wh3_main_combi_region_altdorf");
				
				if altdorf:owning_faction():is_human() then
					local clan_moulder = cm:get_faction("wh2_main_skv_clan_moulder");

					if not clan_moulder:is_human() then
						cm:add_foreign_slot_set_to_region_for_faction(clan_moulder:command_queue_index(), altdorf:cqi(), "wh2_dlc12_slot_set_underempire");
						cm:make_region_visible_in_shroud("wh2_main_skv_clan_moulder", "wh3_main_combi_region_altdorf");
						cm:foreign_slot_instantly_upgrade_building(clan_moulder:foreign_slot_managers():item_at(0):slots():item_at(0), "wh2_dlc12_under_empire_discovery_deeper_tunnels_1");
					end
				end
			else
				if cm:model():random_percent(20) then
					-- Under-City - Ubersreik - Clan Skyre
					local clan_skryre = cm:get_faction("wh2_main_skv_clan_skryre");
					
					if not clan_skryre:is_human() then
						cm:add_foreign_slot_set_to_region_for_faction(clan_skryre:command_queue_index(), cm:get_region("wh3_main_combi_region_ubersreik"):cqi(), "wh2_dlc12_slot_set_underempire");
						cm:make_region_visible_in_shroud("wh2_main_skv_clan_skryre", "wh3_main_combi_region_ubersreik");
						cm:foreign_slot_instantly_upgrade_building(clan_skryre:foreign_slot_managers():item_at(0):slots():item_at(0), "wh2_dlc12_under_empire_discovery_deeper_tunnels_1");
					end
				end
			end
			
			-- Overwrite Mordheim ruin in ME
			local mordheim = cm:get_region("wh3_main_combi_region_mordheim"):settlement();
			local display_chain = mordheim:display_primary_building_chain();
			local building_chain = mordheim:primary_building_chain();
			
			cm:override_building_chain_display(display_chain, "wh2_dlc12_dummy_nuclear_ruins", "wh3_main_combi_region_mordheim");
			cm:override_building_chain_display(building_chain, "wh2_dlc12_dummy_nuclear_ruins", "wh3_main_combi_region_mordheim");
			skaven_under_empire_ruins["wh3_main_combi_region_mordheim"] = {display_chain, building_chain};
		end
		
		if skaven_under_empire_initial_amount > 0 then
			spawn_random_under_empire(skaven_under_empire_initial_amount);
		end
	end
end

function spawn_random_under_empire(spawn_amount)
	local possible_regions = weighted_list:new();
	local world = cm:model():world();
	local region_list = world:region_manager():region_list();
	
	for i = 0, region_list:num_items() - 1 do
		local current_region = region_list:item_at(i);
		
		if current_region:foreign_slot_managers():is_empty() then
			local subculture_bonus = skaven_under_empire_spawn_weights.subcultures[current_region:owning_faction():subculture()] or 0;
			local climate_bonus = skaven_under_empire_spawn_weights.climates[current_region:settlement():get_climate()] or 0;
			
			-- Not owned by Skaven subculture
			if subculture_bonus > 0 then
				local weight = subculture_bonus + climate_bonus;
				possible_regions:add_item(current_region, weight);
			end
		end
	end
	
	local faction_list = world:faction_list();
	local skaven_ai_factions = {};
	
	for i = 0, faction_list:num_items() - 1 do
		local faction = faction_list:item_at(i);
		
		if not faction:is_human() and faction:culture() == skaven_culture then
			table.insert(skaven_ai_factions, faction);
		end
	end
	
	if #skaven_ai_factions > 0 then
		for i = 1, spawn_amount do
			local region, index = possible_regions:weighted_select();
			local settlement = region:settlement();
			local pos_x = settlement:logical_position_x();
			local pos_y = settlement:logical_position_y();
			local closest_skaven = skaven_ai_factions[1];
			local closest_region = 9999999;
			
			for j = 1, #skaven_ai_factions do
				local faction = skaven_ai_factions[j];
				local region_list = faction:region_list();
				
				for k = 0, region_list:num_items() - 1 do
					local current_settlement = region_list:item_at(k):settlement();
					local reg_pos_x = current_settlement:logical_position_x();
					local reg_pos_y = current_settlement:logical_position_y();
					
					local distance = distance_squared(pos_x, pos_y, reg_pos_x, reg_pos_y);
					
					if distance < closest_region then
						closest_skaven = skaven_ai_factions[j];
						closest_region = distance;
					end
				end
			end
			
			cm:add_foreign_slot_set_to_region_for_faction(closest_skaven:command_queue_index(), region:cqi(), "wh2_dlc12_slot_set_underempire");
			cm:make_region_visible_in_shroud(closest_skaven:name(), region:name());
			possible_regions:remove_item(index);
		end
	end
end

function under_empire_war_camp_created(region_key, faction)
	local faction_key = faction:name();
	local ram = random_army_manager;
	ram:remove_force("skaven_warcamp");
	ram:new_force("skaven_warcamp");
	
	local melee_unit_key = "wh2_main_skv_inf_clanrats_1";
	local spear_unit_key = "wh2_main_skv_inf_clanrat_spearmen_1";
	
	if cm:get_factions_bonus_value(faction, "under_empire_warcamp_upgrade") > 0 then
		melee_unit_key = "wh2_main_skv_inf_stormvermin_1";
		spear_unit_key = "wh2_main_skv_inf_stormvermin_0";
	end
	
	-- Standard Army
	ram:add_mandatory_unit("skaven_warcamp", melee_unit_key, 3);
	ram:add_mandatory_unit("skaven_warcamp", spear_unit_key, 2);
	ram:add_mandatory_unit("skaven_warcamp", "wh2_main_skv_inf_plague_monks", 2);
	ram:add_mandatory_unit("skaven_warcamp", "wh2_main_skv_mon_rat_ogres", 1);
	ram:add_mandatory_unit("skaven_warcamp", "wh2_main_skv_art_plagueclaw_catapult", 1);
	
	local warcamp_bonus_values = {
		under_empire_warcamp_clanrat = melee_unit_key,
		under_empire_warcamp_plague_monk = "wh2_main_skv_inf_plague_monks",
		under_empire_warcamp_hell_pit = "wh2_main_skv_mon_hell_pit_abomination",
		under_empire_warcamp_catapult = "wh2_main_skv_art_plagueclaw_catapult",
		under_empire_warcamp_doomwheel = "wh2_main_skv_veh_doomwheel"
	};
	
	for bonus_value, unit_key in pairs(warcamp_bonus_values) do
		local num_units_to_add = cm:get_factions_bonus_value(faction, bonus_value)
		
		if num_units_to_add > 0 then
			for i = 1, num_units_to_add do
				ram:add_mandatory_unit("skaven_warcamp", unit_key, 1);
			end
		end
	end
	
	local unit_count = random_army_manager:mandatory_unit_count("skaven_warcamp");
	local spawn_units = random_army_manager:generate_force("skaven_warcamp", unit_count, false);
	local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, region_key, false, true, 9);
	
	local region = cm:get_region(region_key);
	local region_owner = region:owning_faction();
	local region_owner_key = region_owner:name();
	
	local settlement_x = region:settlement():logical_position_x();
	local settlement_y = region:settlement():logical_position_y();
	
	if pos_x > -1 then
		cm:create_force(
			faction_key,
			spawn_units,
			region_key,
			pos_x,
			pos_y,
			true,
			function(cqi)
				cm:apply_effect_bundle_to_characters_force("wh2_dlc12_bundle_underempire_army_spawn", cqi, 5);
				cm:add_character_vfx(cqi, "scripted_effect20", false);
			end
		);
		
		-- Declare War (if they are not team mates in MPC)
		if not faction:is_team_mate(region_owner) then
			cm:force_declare_war(faction_key, region_owner_key, false, false);
		end
		
		-- Destroy Under-City
		cm:remove_faction_foreign_slots_from_region(faction:command_queue_index(), region:cqi());
		
		-- Tell the army owner
		cm:show_message_event_located(
			faction_key,
			"event_feed_strings_text_wh2_dlc12_event_feed_string_scripted_event_warcamp_title",
			"regions_onscreen_" .. region_key,
			"event_feed_strings_text_wh2_dlc12_event_feed_string_scripted_event_warcamp_description",
			settlement_x,
			settlement_y,
			true,
			121
		);
		
		-- Tell the region owner
		cm:show_message_event_located(
			region_owner_key,
			"event_feed_strings_text_wh2_dlc12_event_feed_string_scripted_event_warcamp_title",
			"regions_onscreen_" .. region_key,
			"event_feed_strings_text_wh2_dlc12_event_feed_string_scripted_event_warcamp_description_target",
			settlement_x,
			settlement_y,
			true,
			121
		);
	end
end

function under_empire_plague_cauldron_created(faction, region)
	local region_key = region:name();

	if not under_empire_plagues[region_key] then
		local settlement = region:settlement();
		local settlement_x = settlement:logical_position_x();
		local settlement_y = settlement:logical_position_y();

		cm:spawn_plague_at_settlement(faction, settlement, "wh2_main_plague_skaven");
		
		-- Tell the plague owner
		cm:show_message_event_located(
			faction:name(),
			"event_feed_strings_text_wh2_dlc12_event_feed_string_scripted_event_plague_cauldron_title",
			"regions_onscreen_" .. region_key,
			"event_feed_strings_text_wh2_dlc12_event_feed_string_scripted_event_plague_cauldron_description",
			settlement_x,
			settlement_y,
			true,
			125
		);
		
		-- Tell the region owner
		cm:show_message_event_located(
			region:owning_faction():name(),
			"event_feed_strings_text_wh2_dlc12_event_feed_string_scripted_event_plague_cauldron_title",
			"regions_onscreen_" .. region_key,
			"event_feed_strings_text_wh2_dlc12_event_feed_string_scripted_event_plague_cauldron_description_target",
			settlement_x,
			settlement_y,
			true,
			125
		);
	end
end

function under_empire_detonate_nuke(region, show_cutscene, show_vfx, timeout, nuke_owner, region_owner)
	local show_cutscene_local = cm:get_local_faction_name(true) == nuke_owner;
	local settlement = region:settlement();
	local pos_x = settlement:display_position_x();
	local pos_y = settlement:display_position_y();
	
	if not cm:is_multiplayer() then
		local fade_in_time = 1;
		local pause_after_fade_before_vfx = 0.5;
		local vfx_play_time = 4;
		local fade_out_time = 3;
		
		if show_cutscene then
			local x, y, d, b, h = cm:get_camera_position();
			cm:make_region_visible_in_shroud(nuke_owner, region:name());
			
			if show_cutscene_local then
				cm:steal_user_input(true);
				cm:fade_scene(0, fade_in_time);
			end
			
			cm:callback(
				function() -- 1.0s
					if show_cutscene_local then
						cm:scroll_camera_with_direction(true, vfx_play_time * 2, {pos_x, pos_y, nuke_cutscene_camera_start_offset[1], 0, nuke_cutscene_camera_start_offset[2]}, {pos_x, pos_y + nuke_cutscene_camera_height_offset, nuke_cutscene_camera_end_offset[1], 0, nuke_cutscene_camera_end_offset[2]});
						CampaignUI.ToggleCinematicBorders(true);
						cm:fade_scene(1, fade_in_time);
					end
					
					cm:callback(
						function() -- 1.5s
							under_empire_nuke_region(region, nuke_owner, region_owner, show_vfx);
							
							if show_cutscene_local then
								cm:callback(
									function() -- 4.0s
										cm:fade_scene(0, fade_out_time);
										
										cm:callback(
											function() -- 3.0s
												cm:steal_user_input(false);
												cm:set_camera_position(x, y, d, b, h);
												CampaignUI.ToggleCinematicBorders(false);
												cm:fade_scene(1, fade_in_time);
											end,
											fade_out_time
										);
									end,
									vfx_play_time
								);
							end
						end,
						fade_in_time + pause_after_fade_before_vfx
					);
				end,
				fade_in_time
			);
		else
			-- Pause all non-focused nukes so they don't happen before the cutscene one
			cm:callback(
				function()
					under_empire_nuke_region(region, nuke_owner, region_owner, show_vfx);
				end,
				fade_in_time + fade_in_time + pause_after_fade_before_vfx + 0.5 + timeout
			);
		end
	else
		if show_cutscene and show_cutscene_local then
			cm:set_camera_position(pos_x, pos_y, nuke_cutscene_camera_start_offset[1], 0, nuke_cutscene_camera_start_offset[2]);
		end
		
		under_empire_nuke_region(region, nuke_owner, region_owner, show_vfx);
	end
end

function under_empire_nuke_region(region, nuke_owner, region_owner, show_vfx)
	local region_key = region:name();
	local settlement = region:settlement()
	local settlement_x = settlement:logical_position_x();
	local settlement_y = settlement:logical_position_y();
	
	-- Find and kill any army in the settlement
	local garrison_residence = region:garrison_residence();
	
	if not garrison_residence:is_null_interface() and garrison_residence:is_settlement() and garrison_residence:has_army() then
		local force = garrison_residence:army();
		
		if not force:is_armed_citizenry() and force:has_general() then
			cm:kill_character(force:general_character():command_queue_index(), true);
		end
	end
	
	if show_vfx then
		-- Add nuclear composite scene
		cm:add_scripted_composite_scene_to_settlement("doomsphere_" .. tostring(region_key), "under_empire_doomsphere", region, 0, 0, true, true, false);
		
		-- Doomsphere composite scene is one shot but this is just for edge cases where it remains
		cm:callback(function() cm:remove_scripted_composite_scene("doomsphere_" .. tostring(region_key)) end, 10);
	end
	
	-- Destroy Under-City
	cm:remove_faction_foreign_slots_from_region(cm:get_faction(nuke_owner):command_queue_index(), region:cqi());
	
	-- Destroy City
	cm:set_region_abandoned(region_key);
	
	cm:callback(function() cm:apply_effect_bundle_to_region("wh2_dlc12_skaven_doomsphere", region_key, 0) end, 0.5);
	
	local ruin_display = "wh2_dlc12_dummy_nuclear_ruins";
	local display_chain = settlement:display_primary_building_chain();
	local building_chain = settlement:primary_building_chain();
	
	if display_chain:starts_with("wh2_dlc09_special_settlement_pyramid_of_nagash") then
		ruin_display = "wh2_dlc12_dummy_nuclear_ruins_tmb_nagash";
	elseif display_chain:starts_with("wh2_dlc09_special_settlement_khemri") then
		ruin_display = "wh2_dlc12_dummy_nuclear_ruins_tmb_settra";
	elseif string.find(display_chain, "_lzd") then
		ruin_display = "wh2_dlc12_dummy_nuclear_ruins_lzd";
	elseif string.find(display_chain, "_tmb") then
		ruin_display = "wh2_dlc12_dummy_nuclear_ruins_tmb";
	elseif region_key == "wh3_main_combi_region_the_oak_of_ages" then
		ruin_display = "wh2_dlc12_dummy_nuclear_ruins_oak";
	end
	
	cm:override_building_chain_display(display_chain, ruin_display, region_key);
	cm:override_building_chain_display(building_chain, ruin_display, region_key);
	skaven_under_empire_ruins[region_key] = {display_chain, building_chain};
	
	-- Tell the nuke owner
	cm:show_message_event_located(
		nuke_owner,
		"event_feed_strings_text_wh2_dlc12_event_feed_string_scripted_event_doomsphere_title",
		"regions_onscreen_" .. region_key,
		"event_feed_strings_text_wh2_dlc12_event_feed_string_scripted_event_doomsphere_description",
		settlement_x,
		settlement_y,
		true,
		120
	);
	
	-- Tell the region owner
	cm:show_message_event_located(
		region_owner,
		"event_feed_strings_text_wh2_dlc12_event_feed_string_scripted_event_doomsphere_title",
		"regions_onscreen_" .. region_key,
		"event_feed_strings_text_wh2_dlc12_event_feed_string_scripted_event_doomsphere_description_target",
		settlement_x,
		settlement_y,
		true,
		120
	);
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("skaven_under_empire_ruins", skaven_under_empire_ruins, context);
		cm:save_named_value("under_empire_plagues", under_empire_plagues, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			skaven_under_empire_ruins = cm:load_named_value("skaven_under_empire_ruins", {}, context);
			under_empire_plagues = cm:load_named_value("under_empire_plagues", {}, context);
		end
	end
);