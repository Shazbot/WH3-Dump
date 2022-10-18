endgame_vermintide = {
	army_template = "endgame_vermintide",
	unit_list = {
		--Infantry
		wh2_main_skv_inf_plague_monks = 2,
		wh2_main_skv_inf_plague_monk_censer_bearer = 2,
		wh2_main_skv_inf_stormvermin_0 = 4,
		wh2_main_skv_inf_stormvermin_1 = 4,
			
			--Ranged
		wh2_dlc12_skv_inf_warplock_jezzails_0 = 4,
		wh2_dlc12_skv_inf_ratling_gun_0 = 8,
		wh2_main_skv_inf_death_globe_bombardiers = 2,
		wh2_main_skv_inf_gutter_runner_slingers_1 = 1,
		wh2_main_skv_inf_gutter_runners_1 = 1,
		wh2_main_skv_inf_warpfire_thrower = 1,
		wh2_main_skv_inf_poison_wind_globadiers = 2,
		wh2_dlc14_skv_inf_poison_wind_mortar_0 = 2,
			
			--Monsters
		wh2_main_skv_mon_hell_pit_abomination = 2,
		wh2_dlc16_skv_mon_rat_ogre_mutant = 1,
		wh2_dlc16_skv_mon_brood_horror_0 = 2,
		wh2_main_skv_mon_rat_ogres = 2,
			
			--Artillery
		wh2_main_skv_art_plagueclaw_catapult = 2,
		wh2_main_skv_art_warp_lightning_cannon = 2,
		wh2_dlc12_skv_veh_doom_flayer_0 = 1,
		wh2_main_skv_veh_doomwheel = 1,
	},
	initial_army_count = 2, -- The armies that spawn for the under city expansion events
	base_army_count = 4, -- Number of armies that spawn when the event fires.
	early_warning_event = "wh3_main_ie_incident_endgame_vermintide_early_warning",
	ai_personality = "wh3_combi_skaven_endgame",
	inital_expansion_chance = 39, -- Chance for each region to get an under empire expansion each turn
	repeat_expansion_chance = 13, -- Chance for a region to get an under empire if it didn't get one on the first dice roll
	unique_building_chance = 25, -- Chance for a region to get one of the special faction-unique under empire templates
	expansion_turns = 10, -- How many turns the under empire will expand for before the final invasion occurs
	under_empire_buildings = {
		generic = {
			{
				"wh2_dlc12_under_empire_annexation_war_camp_1",
				"wh2_dlc12_under_empire_money_crafting_2",
				"wh2_dlc12_under_empire_food_kidnappers_2",
				"wh2_dlc12_under_empire_food_raiding_camp_1"
			},
			{
				"wh2_dlc12_under_empire_settlement_stronghold_3",
			},
			{
				"wh2_dlc12_under_empire_settlement_stronghold_4",
				"wh2_dlc12_under_empire_food_raiding_camp_1"
			},
			{
				"wh2_dlc12_under_empire_settlement_stronghold_5",
				"wh2_dlc12_under_empire_food_raiding_camp_1",
				"wh2_dlc12_under_empire_discovery_deeper_tunnels_1"
			},
			{
				"wh2_dlc12_under_empire_settlement_warren_3",
			},
			{
				"wh2_dlc12_under_empire_settlement_warren_4",
				"wh2_dlc12_under_empire_food_raiding_camp_1"
			},
			{
				"wh2_dlc12_under_empire_settlement_warren_5",
				"wh2_dlc12_under_empire_food_raiding_camp_1",
				"wh2_dlc12_under_empire_discovery_deeper_tunnels_1"
			}
		},
		wh2_main_skv_clan_skryre = {
			"wh2_dlc12_under_empire_annexation_doomsday_1",
			"wh2_dlc12_under_empire_money_crafting_2",
			"wh2_dlc12_under_empire_food_kidnappers_2",
			"wh2_dlc12_under_empire_food_raiding_camp_1"
		},
		wh2_main_skv_clan_pestilens = {
			"wh2_dlc14_under_empire_annexation_plague_cauldron_1",
			"wh2_dlc12_under_empire_money_crafting_2",
			"wh2_dlc12_under_empire_food_kidnappers_2",
			"wh2_dlc12_under_empire_food_raiding_camp_1"
		},
	},
	skaven_factions = {
		wh2_main_skv_clan_mors = "wh3_main_combi_region_misty_mountain", -- Queek
		wh2_main_skv_clan_pestilens = "wh3_main_combi_region_oyxl", -- Skrolk
		wh2_dlc09_skv_clan_rictus = "wh3_main_combi_region_crookback_mountain", -- Tretch
		wh2_main_skv_clan_skryre = "wh3_main_combi_region_skavenblight", -- Ikit
		wh2_main_skv_clan_eshin = "wh3_main_combi_region_xing_po", -- Snikch
		wh2_main_skv_clan_moulder = "wh3_main_combi_region_hell_pit", -- Throt
	},
	repeat_regions = {}, -- Populated by script to check which regions are trying to expand the under-empire
	under_empire_regions = {}, -- Populated by script to make sure we don't repeat spreading the under empire to regions that have already removed it
	ultimate_mission_delay = 11 -- How many turns to delay the ultimate crisis victory mission by, if that setting is enabled
}

-- Unlike the first set of scenarios, Vermintide has a buildup event - the main trigger is in the final_invasion() function
function endgame_vermintide:trigger()
	local potential_skaven = {}
	for faction_key, _ in pairs(self.skaven_factions) do
		local faction = cm:get_faction(faction_key)
		if endgame:check_faction_is_valid(faction, true) then
			table.insert(potential_skaven, faction_key)
		end
	end
	if #potential_skaven > 0 then
		for i = 1, #potential_skaven do
			local faction_key = potential_skaven[i]
			local faction = cm:get_faction(faction_key)
			local region_key = self.skaven_factions[faction_key]
			if faction:is_dead() == false then
				if faction:has_home_region() then
					region_key = faction:home_region():name()
				elseif faction:faction_leader():has_region() then
					region_key = faction:faction_leader():region():name()
				end
			end
			endgame:create_scenario_force(faction_key, region_key, self.army_template, self.unit_list, false, math.floor(self.initial_army_count*endgame.settings.difficulty_mod))
			cm:apply_effect_bundle("wh3_main_ie_scripted_endgame_vermintide", faction_key, 0)
			if endgame.settings.endgame_diplomacy_enabled == false then
				cm:force_diplomacy("faction:" .. faction_key, "all", "form confederation", false, false, true)
			end
		end
		local data = {
			last_turn = (cm:turn_number() + self.expansion_turns)
		}
		cm:set_saved_value("endgame_vermintide_under_empire_expanding", data)
		cm:set_saved_value("endgame_vermintide_ubersreik_marker_trigger", cm:turn_number()+2)
		cm:set_saved_value("endgame_vermintide_ubersreik_marker", true);
		cm:set_saved_value("endgame_vermintide_ikit_warpfuel", true);
		self:expand_under_empire()
		self:add_listeners()
		if endgame.ultimate_mission_delay < self.ultimate_mission_delay then
			endgame.ultimate_mission_delay = self.ultimate_mission_delay
		end
		cm:activate_music_trigger("ScriptedEvent_Negative", "wh2_main_sc_skv_skaven")
		local human_factions = cm:get_human_factions()
		for i = 1, #human_factions do
			cm:trigger_incident(human_factions[i], "wh3_main_ie_incident_endgame_vermintide_1", true)
		end
	end
end

-- The actual vermintide. This occurs self.expansion_turns after the intial trigger, and is the final scripted event for this scenario
function endgame_vermintide:final_invasion()
	local skaven_factions = {}
	local potential_skaven = {}
	local region_list = {}
	for faction_key, _ in pairs(self.skaven_factions) do
		local faction = cm:get_faction(faction_key)
		if endgame:check_faction_is_valid(faction, true) then
			table.insert(potential_skaven, faction_key)
		end
	end

	if #potential_skaven > 0 then
		for i = 1, #potential_skaven do
			local faction_key = potential_skaven[i]
			local faction = cm:get_faction(faction_key)
			local region_key = self.skaven_factions[faction_key]
			if faction:is_dead() == false then
				if faction:has_home_region() then
					region_key = faction:home_region():name()
				elseif faction:faction_leader():has_region() then
					region_key = faction:faction_leader():region():name()
				end
			end
			if region_key ~= nil then
				table.insert(skaven_factions, faction_key)
				table.insert(region_list, region_key)
				endgame:create_scenario_force(faction_key, region_key, self.army_template, self.unit_list, true, math.floor(self.base_army_count*endgame.settings.difficulty_mod))
				cm:instantly_research_all_technologies(faction_key)
				if faction:has_effect_bundle("wh3_main_ie_scripted_endgame_vermintide") == false then
					cm:apply_effect_bundle("wh3_main_ie_scripted_endgame_vermintide", faction_key, 0)
				end
				endgame:no_peace_no_confederation_only_war(faction_key)
				cm:force_change_cai_faction_personality(faction_key, self.ai_personality)
				local region = cm:get_region(region_key)
				endgame:declare_war_on_adjacent_region_owners(faction, region)
			end
		end

		local human_factions = cm:get_human_factions()
		local objectives = {
			{
				type = "DESTROY_FACTION",
				conditions = {
					"confederation_valid",
					"vassalization_valid"
				}
			}
		}

		if #skaven_factions == 0 then
			-- We somehow don't have any targets - silently exit the scenario
			return
		end
		
		for i = 1, #skaven_factions do 
			table.insert(objectives[1].conditions, "faction "..skaven_factions[i])
		end

		endgame:reveal_regions(region_list)
		cm:activate_music_trigger("ScriptedEvent_Negative", "wh2_main_sc_skv_skaven")

		local incident_key = "wh3_main_ie_incident_endgame_vermintide_2"
		for i = 1, #human_factions do
			endgame:add_victory_condition_listener(human_factions[i], incident_key, objectives)
			cm:trigger_incident_with_targets(
				cm:get_faction(human_factions[i]):command_queue_index(),
				incident_key,
				cm:get_faction(skaven_factions[1]):command_queue_index(),
				0,
				0,
				0,
				0,
				0
			)
		end
	end
end

function endgame_vermintide:add_listeners()
	local data = cm:get_saved_value("endgame_vermintide_under_empire_expanding")

	if data then
		core:add_listener(
			"endgame_vermintide_under_empire_expanding",
			"WorldStartRound",
			true,
			function()
				if cm:turn_number() >= data.last_turn then
					self:final_invasion()
					endgame_vermintide.repeat_regions = {}
					cm:set_saved_value("endgame_vermintide_repeat_regions", false)
					endgame_vermintide.under_empire_regions = {}
					cm:set_saved_value("endgame_vermintide_under_empire_regions", false)
					cm:set_saved_value("endgame_vermintide_under_empire_expanding", false)
					core:remove_listener("endgame_vermintide_under_empire_expanding")
				else
					self:expand_under_empire()
				end
			end,
			true
		)
	end

	if cm:get_saved_value("endgame_vermintide_ubersreik_marker") then
		core:add_listener(
			"endgame_vermintide_area_entered",
			"AreaEntered",
			function(context)
				return context:area_key() == "endgame_vermintide_marker"
			end,
			function(context)
				local character = context:family_member():character()
				
				if not character:is_null_interface() and character:has_military_force() then
					local faction = character:faction()
					
					if faction:is_human() and (faction:subculture() == "wh_main_sc_emp_empire" or faction:subculture() == "wh_dlc05_sc_wef_wood_elves" or faction:subculture() == "wh_main_sc_dwf_dwarfs") then
						cm:set_saved_value("endgame_vermintide_ubersreik_invasion", true);
						self:generate_ubersreik_battle_force(character)
						endgame_vermintide:ubersreik_battle_cleanup()
					end
				end
			end,
			true
		)
	end

	if cm:get_saved_value("endgame_vermintide_ubersreik_marker_trigger") then
		core:add_listener(
			"endgame_vermintide_add_marker",
			"WorldStartRound",
			function()
				return cm:turn_number() == cm:get_saved_value("endgame_vermintide_ubersreik_marker_trigger")
			end,
			function()
				self:add_marker()
				cm:set_saved_value("endgame_vermintide_ubersreik_marker_trigger", false)
				core:remove_listener("endgame_vermintide_add_marker")
			end,
			true
		)
	end

	if cm:set_saved_value("endgame_vermintide_ikit_warpfuel", true) then
		core:add_listener(
			"endgame_vermintide_ikit_warpfuel",
			"WorldStartRound",
			true,
			function()
				local skryre_faction = cm:get_faction("wh2_main_skv_clan_skryre")
				if skryre_faction:is_dead() == false and skryre_faction:is_human() == false then
					cm:faction_add_pooled_resource(skryre_faction:name(), "skv_reactor_core", "missions", 4)
					if cm:random_number(100) <= 10 then
						cm:faction_add_pooled_resource(skryre_faction:name(), "skv_nuke", "workshop_production", 4)
					end
				end
			end,
			true
		)
	end
	
end

function endgame_vermintide:expand_under_empire()
	local potential_skaven = {}
	for faction_key, _ in pairs(self.skaven_factions) do
		local faction = cm:get_faction(faction_key)
		if endgame:check_faction_is_valid(faction, false) then
			table.insert(potential_skaven, faction_key)
		end
	end
	
	for i = 1, #potential_skaven do
		local checked_regions = {}
		local sneaky_skaven = potential_skaven[i]
		local sneaky_skaven_faction = cm:get_faction(sneaky_skaven)
		if self.repeat_regions[sneaky_skaven] == nil then
			self.repeat_regions[sneaky_skaven] = {}
		end
		if self.under_empire_regions[sneaky_skaven] == nil then
			self.under_empire_regions[sneaky_skaven] = {}
		end
		local foreign_region_list = sneaky_skaven_faction:foreign_slot_managers()
		for i2 = 0, foreign_region_list:num_items() -1 do
			local region = foreign_region_list:item_at(i2):region()
			self:expand_under_empire_adjacent_region_check(sneaky_skaven, region, checked_regions)
		end
		local region_list = sneaky_skaven_faction:region_list()
		for i2 = 0, region_list:num_items() -1 do
			local region = region_list:item_at(i2)
			self:expand_under_empire_adjacent_region_check(sneaky_skaven, region, checked_regions)
		end
		if sneaky_skaven == "wh2_main_skv_clan_skryre" then
			cm:faction_add_pooled_resource(sneaky_skaven, "skv_reactor_core", "missions", 10)
		end
	end
	cm:set_saved_value("endgame_vermintide_repeat_regions", self.repeat_regions)
	cm:set_saved_value("endgame_vermintide_under_empire_regions", self.under_empire_regions)
end

function endgame_vermintide:expand_under_empire_adjacent_region_check(sneaky_skaven, region, checked_regions)
	local adjacent_region_list = region:adjacent_region_list()
	for i = 0, adjacent_region_list:num_items() -1 do
		local adjacent_region = adjacent_region_list:item_at(i)
		local adjacent_region_key = adjacent_region:name()
		if checked_regions[adjacent_region_key] == nil then
			checked_regions[adjacent_region_key] = true
			if self.under_empire_regions[sneaky_skaven][adjacent_region_key] == nil and adjacent_region:is_null_interface() == false then
				local chance = self.repeat_expansion_chance
				if self.repeat_regions[sneaky_skaven][adjacent_region_key] == nil then
					self.repeat_regions[sneaky_skaven][adjacent_region_key] = true
					chance = self.inital_expansion_chance
				end
				local dice_roll = cm:random_number(100, 1)
				if dice_roll <= chance then
					out("Endgame vermintide: Spreading under-empire to "..adjacent_region_key.." for "..sneaky_skaven)
					self.under_empire_regions[sneaky_skaven][adjacent_region_key] = true
					if adjacent_region:is_abandoned() then
						cm:transfer_region_to_faction(adjacent_region_key, sneaky_skaven)
					elseif adjacent_region:owning_faction():name() ~= sneaky_skaven then
						local is_sneaky_skaven_present = false
						local foreign_slot_managers = adjacent_region:foreign_slot_managers()
						for i2 = 0, foreign_slot_managers:num_items() -1 do
							local foreign_slot_manager = foreign_slot_managers:item_at(i2)
							if foreign_slot_manager:faction():name() == sneaky_skaven then
								is_sneaky_skaven_present = true
								break
							end
						end
						if is_sneaky_skaven_present == false then
							local under_empire_buildings
							if self.under_empire_buildings[sneaky_skaven] ~= nil and cm:random_number(100, 1) <= self.unique_building_chance then
								under_empire_buildings = self.under_empire_buildings[sneaky_skaven]
							else
								local random_index = cm:random_number(#self.under_empire_buildings.generic, 1)
								under_empire_buildings = self.under_empire_buildings.generic[random_index]
							end
							region_cqi = adjacent_region:cqi()
							local faction_cqi = cm:get_faction(sneaky_skaven):command_queue_index()
							foreign_slot = cm:add_foreign_slot_set_to_region_for_faction(faction_cqi, region_cqi, "wh2_dlc12_slot_set_underempire")
							for i3 = 1, #under_empire_buildings do
								local building_key = under_empire_buildings[i3]
								slot = foreign_slot:slots():item_at(i3-1)
								cm:foreign_slot_instantly_upgrade_building(slot, building_key)
								out("Added "..building_key.." to "..adjacent_region:name().." for "..sneaky_skaven)
							end
						end
					end
				end
			end
		end
	end
end

function endgame_vermintide:add_marker()
	local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement("wh_main_emp_empire", "wh3_main_combi_region_ubersreik", false, true, 9)
						
	if pos_x > -1 then
	
		local human_factions = cm:get_human_factions()
		local incident_issued = false
		for i = 1, #human_factions do
			local faction = cm:get_faction(human_factions[i])
			if faction:subculture() == "wh_main_sc_emp_empire" or faction:subculture() == "wh_dlc05_sc_wef_wood_elves" or faction:subculture() == "wh_main_sc_dwf_dwarfs" then
				incident_issued = true
				cm:trigger_incident_with_targets(
					faction:command_queue_index(),
					"wh3_main_ie_incident_endgame_vermintide_ubersreik",
					0,
					0,
					0,
					0,
					cm:get_region("wh3_main_combi_region_ubersreik"):cqi(),
					0
				)
			end
		end
	
		if incident_issued == true then
			cm:add_interactable_campaign_marker("endgame_vermintide_marker", "endgame_vermintide_marker", pos_x, pos_y, 2)		
		else
			cm:set_saved_value("endgame_vermintide_ubersreik_marker", false)
			core:remove_listener("endgame_vermintide_area_entered")
		end
	end

end

function endgame_vermintide:generate_ubersreik_battle_force(character)
	local faction = character:faction()
	local faction_name = faction:name()
	
	local units = "wh2_main_skv_inf_stormvermin_0,wh2_main_skv_inf_stormvermin_0,wh2_main_skv_inf_stormvermin_0,wh2_main_skv_inf_stormvermin_1,wh2_main_skv_inf_stormvermin_1,wh2_main_skv_inf_plague_monks,wh2_main_skv_inf_plague_monks,wh2_main_skv_inf_poison_wind_globadiers,wh2_main_skv_inf_poison_wind_globadiers,wh2_dlc12_skv_inf_ratling_gun_0,wh2_dlc12_skv_inf_ratling_gun_0,wh2_dlc12_skv_inf_ratling_gun_0,wh2_dlc12_skv_inf_ratling_gun_0,wh2_main_skv_inf_warpfire_thrower,wh2_main_skv_inf_warpfire_thrower,wh2_main_skv_inf_gutter_runners_1,wh2_main_skv_inf_gutter_runners_1,wh2_main_skv_inf_gutter_runners_1,wh2_main_skv_mon_rat_ogres"
	
	local old_invasion = invasion_manager:get_invasion("endgame_vermintide_ubersreik_invasion")
	
	if old_invasion then
		cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "")
		cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
		old_invasion:kill();
		cm:callback(
			function()
				cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "")
				cm:disable_event_feed_events(false, "wh_event_category_character", "", "")
			end,
			0.2
		)
	end
	
	local invasion = invasion_manager:new_invasion("endgame_vermintide_ubersreik_invasion", "wh2_main_skv_skaven_qb1", units, {character:logical_position_x(), character:logical_position_y()})
	invasion:set_target("CHARACTER", character:command_queue_index(), faction_name)
	invasion:apply_effect("wh_main_bundle_military_upkeep_free_force_endgame", -1)
	invasion:start_invasion(
		function(self)
			core:add_listener(
				"endgame_vermintide_ubersreik_invasion_war_declared",
				"FactionLeaderDeclaresWar",
				function(context)
					return context:character():faction():name() == "wh2_main_skv_skaven_qb1"
				end,
				function()
					cm:force_attack_of_opportunity(self:get_general():military_force():command_queue_index(), character:military_force():command_queue_index(), false)
				end,
				false
			);
			
			cm:force_declare_war("wh2_main_skv_skaven_qb1", faction_name, false, false)
		end,
		false,
		false,
		false
	)
	
	core:add_listener(
		"endgame_vermintide_ubersreik_invasion_battle_end_of_round_cleanup",
		"EndOfRound", 
		true,
		function()
			self:kill_ubersreik_invasion();
			cm:set_saved_value("endgame_vermintide_ubersreik_invasion", false)
		end,
		false
	)
end

function endgame_vermintide:ubersreik_battle_cleanup()
	core:add_listener(
		"endgame_vermintide_ubersreik_invasion_battle_cleanup",
		"BattleCompleted",
		function()
			return cm:get_saved_value("endgame_vermintide_ubersreik_invasion")
		end,
		function()
			cm:set_saved_value("endgame_vermintide_ubersreik_invasion", false)

			self:kill_ubersreik_invasion()

			local pb = cm:model():pending_battle()

			if pb:has_been_fought() and pb:defender_won() and pb:has_defender() then
				local defender_fm_cqi = cm:pending_battle_cache_get_defender_fm_cqi(1)
				local defender_fm = cm:get_family_member_by_cqi(defender_fm_cqi)
				if defender_fm and not defender_fm:character_details():is_null_interface() then
					self:generate_ubersreik_army(defender_fm:character_details():faction():name())
					cm:remove_interactable_campaign_marker("endgame_vermintide_marker")
					cm:set_saved_value("endgame_vermintide_ubersreik_marker", false)
					core:remove_listener("endgame_vermintide_area_entered")
				end
			end
			
			cm:callback(
				function()
					cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "")
					cm:disable_event_feed_events(false, "wh_event_category_character", "", "")
				end,
				0.2
			)
		end,
		false
	)
end

function endgame_vermintide:kill_ubersreik_invasion()
	local invasion = invasion_manager:get_invasion("endgame_vermintide_ubersreik_invasion")
	
	if invasion then
		cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "")
		cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
		invasion:kill()
		cm:callback(
			function()
				cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "")
				cm:disable_event_feed_events(false, "wh_event_category_character", "", "")
			end,
			0.2
		)
	end
end

function endgame_vermintide:generate_ubersreik_army(faction_key)
	local units = "wh_main_dwf_inf_irondrakes_0,wh_main_dwf_inf_irondrakes_0,wh_main_dwf_inf_hammerers,wh_main_dwf_inf_hammerers,wh_dlc05_wef_inf_wildwood_rangers_0,wh_dlc05_wef_inf_wildwood_rangers_0,wh_main_emp_cav_outriders_1,wh_main_emp_cav_outriders_1,wh_main_emp_veh_steam_tank"
	local agents = {
		{type = "champion", subtype = "wh_main_emp_captain", forename = "names_name_2147355016", family_name = "names_name_2147354850"},
		{type = "spy", subtype = "wh_dlc05_wef_waystalker", forename = "names_name_2147359174", family_name = ""},
		{type = "spy", subtype = "wh_main_emp_witch_hunter", forename = "names_name_2147357411", family_name = "names_name_2147344113"},
		{type = "wizard", subtype = "wh_main_emp_bright_wizard", forename = "names_name_2147355023", family_name = "names_name_2147344053"},
		{type = "champion", subtype = "wh_main_dwf_thane", forename = "names_name_2147345808", family_name = "names_name_2147354039"}
	}
	local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, "wh3_main_combi_region_ubersreik", false, true, 10)
	cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
	cm:disable_event_feed_events(true, "wh_event_category_agent", "", "")
	cm:disable_event_feed_events(true, "wh_event_category_traits_ancillaries", "", "")
	local force_cqi = 0
	cm:create_force(
		faction_key,
		units,
		"wh3_main_combi_region_ubersreik",
		pos_x,
		pos_y,
		false,
		function(cqi)
			local force = cm:get_character_by_cqi(cqi):military_force()
			force_cqi = force:command_queue_index() or 0
			cm:add_experience_to_units_commanded_by_character(cm:char_lookup_str(cqi), 7)
			for i = 1, #agents do
				local agent_x, agent_y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, "wh3_main_combi_region_ubersreik", false, true, 10)
				local agent = cm:create_agent(faction_key, agents[i].type, agents[i].subtype, agent_x, agent_y)
				local forename = common:get_localised_string(agents[i].forename)
				local family_name = common:get_localised_string(agents[i].family_name)
				cm:change_character_custom_name(agent, forename, family_name,"","")
				cm:add_agent_experience(cm:char_lookup_str(agent:command_queue_index()), 25, true)
				cm:embed_agent_in_force(agent, force);
			end
		end
	)
	cm:callback(
		function()
			cm:disable_event_feed_events(false, "wh_event_category_character", "", "")
			cm:disable_event_feed_events(false, "wh_event_category_agent", "", "")
			cm:disable_event_feed_events(false, "wh_event_category_traits_ancillaries", "", "")
			cm:trigger_incident_with_targets(
				cm:get_faction(faction_key):command_queue_index(),
				"wh3_main_ie_incident_endgame_vermintide_ubersreik_success",
				0,
				0,
				0,
				force_cqi,
				0,
				0
			)
		end,
		0.2
	)
end

if cm:get_saved_value("endgame_vermintide_ubersreik_invasion") then
	endgame_vermintide:ubersreik_battle_cleanup()
end

if cm:get_saved_value("endgame_vermintide_repeat_regions") then
	endgame_vermintide.repeat_regions = cm:get_saved_value("endgame_vermintide_repeat_regions")
end

if cm:get_saved_value("endgame_vermintide_under_empire_regions") then
	endgame_vermintide.under_empire_regions = cm:get_saved_value("endgame_vermintide_under_empire_regions")
end

endgame_vermintide:add_listeners()