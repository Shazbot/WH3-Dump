Bastion = {}
Bastion.cathay_subculture = "wh3_main_sc_cth_cathay"
Bastion.invasion_faction = "wh3_main_rogue_kurgan_warband"
Bastion.invasion_duration_threshold = 20 -- number of turns an invasion can last until the threat meter is reset
Bastion.base_threat_per_turn = 6 -- percentage to add to threat meter each turn
Bastion.base_gate_threat_increase = 2 -- percentage to add to threat meter each turn per gate that is razed/not owned by cathay
Bastion.new_game_starting_threat = 10 -- threat meter starting value in a new game
Bastion.destroyed_army_threat_reduction = 20 -- percentage to remove from threat meter each time a kurgan warband army is destroyed. keep in parity with wh3_main_incident_cth_bastion_threat_decreases_kill in campaign_payload_ui_details
Bastion.max_threat_value = 100 -- maximum amount the threat meter can be
Bastion.max_regions_unoccupied_by_cathay = 8 -- how many regions need to be not be occupied by cathay for the threat meter to reset

Bastion.spawn_locations_by_gate = { -- possible locations to spawn new kurgan warband armies
	{
		gate_key = "wh3_main_chaos_region_snake_gate",
		spawn_locations = {
			{848, 579},
			{860, 557},
			{847, 569},
			{852, 582},
			{871, 580},
			{840, 579}
		}
	},
	{
		gate_key = "wh3_main_chaos_region_turtle_gate",
		spawn_locations = {
			{882, 671},
			{885, 639},
			{872, 647},
			{893, 654},
			{884, 675},
			{903, 670}
		}
	},
	{
		gate_key = "wh3_main_chaos_region_dragon_gate",
		spawn_locations = {
			{861, 614},
			{883, 617},
			{868, 620},
			{855, 611},
			{865, 605},
			{879, 600}
		}
	}
}
Bastion.spawn_locations_by_gate_combi = {
	{
		gate_key = "wh3_main_combi_region_snake_gate",
		spawn_locations = {
			{1164, 685},
			{1156, 670},
			{1167, 697},
			{1185, 676},
			{1170, 691}
		}
	},
	{
		gate_key = "wh3_main_combi_region_turtle_gate",
		spawn_locations = {
			{1264, 668},
			{1228, 675},
			{1266, 669},
			{1243, 695},
			{1241, 680},
			{1235, 694}
		}
	},
	{
		gate_key = "wh3_main_combi_region_dragon_gate",
		spawn_locations = {
			{1212, 686},
			{1211, 690},
			{1210, 699},
			{1223, 675},
			{1199, 695},
			{1292, 679}
		}
	}
}

Bastion.cathay_bastion_regions = { -- list of regions close to the bastion, should a number of them not be occupied by cathay or in ruins, then stop the invasions
	"wh3_main_chaos_region_snake_gate",
	"wh3_main_chaos_region_turtle_gate",
	"wh3_main_chaos_region_dragon_gate",
	"wh3_main_chaos_region_nan_gau",
	"wh3_main_chaos_region_mines_of_nan_yang",
	"wh3_main_chaos_region_terracotta_graveyard",
	"wh3_main_chaos_region_po_mei",
	"wh3_main_chaos_region_ming_zhu",
	"wh3_main_chaos_region_city_of_the_shugengan",
	"wh3_main_chaos_region_wei_jin",
	"wh3_main_chaos_region_weng_chang",
}
Bastion.cathay_bastion_regions_combi = {
	"wh3_main_combi_region_snake_gate",
	"wh3_main_combi_region_turtle_gate",
	"wh3_main_combi_region_dragon_gate",
	"wh3_main_combi_region_nan_gau",
	"wh3_main_combi_region_haichai",
	"wh3_main_combi_region_terracotta_graveyard",
	"wh3_main_combi_region_po_mei",
	"wh3_main_combi_region_ming_zhu",
	"wh3_main_combi_region_city_of_the_shugengan",
	"wh3_main_combi_region_wei_jin",
	"wh3_main_combi_region_weng_chang"
}

Bastion.dragon_emperors_wrath_region_list = { -- list of regions to apply dragon emperor's wrath compass ability to
	"wh3_main_chaos_region_snake_gate",
	"wh3_main_chaos_region_turtle_gate",
	"wh3_main_chaos_region_dragon_gate",
	"wh3_main_chaos_region_fortress_of_eyes",
	"wh3_main_chaos_region_iron_storm",
	"wh3_main_chaos_region_dragons_crossroad",
	"wh3_main_chaos_region_red_fortress"
}
Bastion.dragon_emperors_wrath_region_list_combi = {
	"wh3_main_combi_region_snake_gate",
	"wh3_main_combi_region_turtle_gate",
	"wh3_main_combi_region_dragon_gate",
	"wh3_main_combi_region_fortress_of_eyes",
	"wh3_main_combi_region_iron_storm",
	"wh3_main_combi_region_dragons_crossroad",
	"wh3_main_combi_region_red_fortress"
}

Bastion.message_keys = { -- incident mapping
	["begin_attack"] = "wh3_main_incident_cth_bastion_threat_maximum",
	["threat_increasing"] = "wh3_main_incident_cth_bastion_threat_increases",
	["threat_decreasing"] = "wh3_main_incident_cth_bastion_threat_decreases",
	["invasion_successful"] = "wh3_main_incident_cth_bastion_invasion_successful",
	["invader_killed"] = "wh3_main_incident_cth_bastion_threat_decreases_kill"
}

-- turn number thresholds to determine sizes of army spawns
Bastion.army_spawn_at_period_early = 25
Bastion.army_spawn_at_period_mid = 40
Bastion.army_spawn_at_period_late = 60

Bastion.invasion_set_spawn_variables = {
	["early"] = {
		["army_amount"] = 3,
		["army_size"] = 8,
		["invasion_name"] = "chaos_besiegers_1",
		["difficulty_additions"] = {
			["hard"] = {
				["extra_armies"] = 1,
				["extra_army_size"] = 0,
			},
			["very_hard"] = {
				["extra_armies"] = 1,
				["extra_army_size"] = 1,
			},
			["legendary"] = {
				["extra_armies"] = 1,
				["extra_army_size"] = 2,
			}
		}
	},
	["mid"] = {
		["army_amount"] = 4,
		["army_size"] = 15,
		["invasion_name"] = "chaos_besiegers_2",
		["difficulty_additions"] = {
			["very_hard"] = {
				["extra_armies"] = 0,
				["extra_army_size"] = 2,
			},
			["legendary"] = {
				["extra_armies"] = 1,
				["extra_army_size"] = 1,
			}
		}
	},
	["late"] = {
		["army_amount"] = 5,
		["army_size"] = 17,
		["invasion_name"] = "chaos_besiegers_3",
		["difficulty_additions"] = {
			["very_hard"] = {
				["extra_armies"] = 0,
				["extra_army_size"] = 2,
			},
			["legendary"] = {
				["extra_armies"] = 1,
				["extra_army_size"] = 2,
			}
		}
	},
	["end_game"] = {
		["army_amount"] = 5,
		["army_size"] = 19,
		["invasion_name"] = "chaos_besiegers_4",
		["difficulty_additions"] = {
			["very_hard"] = {
				["extra_armies"] = 1,
				["extra_army_size"] = 0,
			},
			["legendary"] = {
				["extra_armies"] = 2,
				["extra_army_size"] = 0,
			}
		}
	}
}

-- army compositions
random_army_manager:new_force("chaos_besiegers_1")
random_army_manager:add_mandatory_unit("chaos_besiegers_1", "wh_main_nor_inf_chaos_marauders_0", 4)
random_army_manager:add_mandatory_unit("chaos_besiegers_1", "wh_dlc08_nor_inf_marauder_hunters_1", 1)
random_army_manager:add_unit("chaos_besiegers_1", "wh_main_nor_inf_chaos_marauders_0", 4)
random_army_manager:add_unit("chaos_besiegers_1", "wh_main_nor_inf_chaos_marauders_1", 2)
random_army_manager:add_unit("chaos_besiegers_1", "wh_dlc08_nor_inf_marauder_berserkers_0", 1)
random_army_manager:add_unit("chaos_besiegers_1", "wh_dlc08_nor_inf_marauder_hunters_0", 1)
random_army_manager:add_unit("chaos_besiegers_1", "wh_dlc08_nor_inf_marauder_hunters_1", 2)
random_army_manager:add_unit("chaos_besiegers_1", "wh_main_chs_cav_marauder_horsemen_0", 3)
random_army_manager:add_unit("chaos_besiegers_1", "wh_main_nor_mon_chaos_warhounds_0", 2)

random_army_manager:new_force("chaos_besiegers_2")
random_army_manager:add_mandatory_unit("chaos_besiegers_2", "wh_main_nor_inf_chaos_marauders_0", 4)
random_army_manager:add_mandatory_unit("chaos_besiegers_2", "wh_dlc08_nor_inf_marauder_hunters_1", 2)
random_army_manager:add_unit("chaos_besiegers_2", "wh_dlc08_nor_inf_marauder_berserkers_0", 2)
random_army_manager:add_unit("chaos_besiegers_2", "wh_main_nor_mon_chaos_trolls", 1)
random_army_manager:add_unit("chaos_besiegers_2", "wh_main_nor_inf_chaos_marauders_0", 6)
random_army_manager:add_unit("chaos_besiegers_2", "wh_main_nor_inf_chaos_marauders_1", 2)
random_army_manager:add_unit("chaos_besiegers_2", "wh_dlc08_nor_inf_marauder_berserkers_0", 2)
random_army_manager:add_unit("chaos_besiegers_2", "wh_dlc08_nor_inf_marauder_hunters_0", 2)
random_army_manager:add_unit("chaos_besiegers_2", "wh_dlc08_nor_inf_marauder_hunters_1", 2)
random_army_manager:add_unit("chaos_besiegers_2", "wh_main_nor_mon_chaos_warhounds_0", 2)
random_army_manager:add_unit("chaos_besiegers_2", "wh_main_chs_cav_marauder_horsemen_0", 3)
random_army_manager:add_unit("chaos_besiegers_2", "wh_main_nor_mon_chaos_trolls", 1)

random_army_manager:new_force("chaos_besiegers_3")
random_army_manager:add_mandatory_unit("chaos_besiegers_3", "wh_main_nor_inf_chaos_marauders_0", 4)
random_army_manager:add_mandatory_unit("chaos_besiegers_3", "wh_dlc08_nor_inf_marauder_champions_0", 2)
random_army_manager:add_mandatory_unit("chaos_besiegers_3", "wh_dlc08_nor_inf_marauder_hunters_1", 2)
random_army_manager:add_unit("chaos_besiegers_3", "wh_dlc08_nor_inf_marauder_hunters_0", 2)
random_army_manager:add_unit("chaos_besiegers_3", "wh_dlc08_nor_inf_marauder_berserkers_0", 2)
random_army_manager:add_unit("chaos_besiegers_3", "wh_main_nor_inf_chaos_marauders_0", 4)
random_army_manager:add_unit("chaos_besiegers_3", "wh_main_nor_inf_chaos_marauders_1", 2)
random_army_manager:add_unit("chaos_besiegers_3", "wh_dlc08_nor_inf_marauder_hunters_0", 6)
random_army_manager:add_unit("chaos_besiegers_3", "wh_dlc08_nor_inf_marauder_champions_1", 2)
random_army_manager:add_unit("chaos_besiegers_3", "wh_main_nor_mon_chaos_warhounds_0", 2)
random_army_manager:add_unit("chaos_besiegers_3", "wh_main_nor_mon_chaos_trolls", 2)
random_army_manager:add_unit("chaos_besiegers_3", "wh_main_chs_cav_marauder_horsemen_0", 3)
random_army_manager:add_unit("chaos_besiegers_3", "wh_dlc08_nor_mon_war_mammoth_0", 1)
random_army_manager:add_unit("chaos_besiegers_3", "wh_dlc08_nor_feral_manticore", 1)

random_army_manager:new_force("chaos_besiegers_4")
random_army_manager:add_mandatory_unit("chaos_besiegers_4", "wh_main_nor_inf_chaos_marauders_0", 2)
random_army_manager:add_mandatory_unit("chaos_besiegers_4", "wh_dlc08_nor_inf_marauder_champions_0", 4)
random_army_manager:add_mandatory_unit("chaos_besiegers_4", "wh_dlc08_nor_inf_marauder_hunters_1", 2)
random_army_manager:add_unit("chaos_besiegers_4", "wh_dlc08_nor_inf_marauder_hunters_1", 2)
random_army_manager:add_unit("chaos_besiegers_4", "wh_main_nor_mon_chaos_trolls", 2)
random_army_manager:add_unit("chaos_besiegers_4", "wh_main_nor_inf_chaos_marauders_0", 4)
random_army_manager:add_unit("chaos_besiegers_4", "wh_main_nor_inf_chaos_marauders_1", 2)
random_army_manager:add_unit("chaos_besiegers_4", "wh_dlc08_nor_inf_marauder_berserkers_0", 4)
random_army_manager:add_unit("chaos_besiegers_4", "wh_dlc08_nor_inf_marauder_champions_0", 2)
random_army_manager:add_unit("chaos_besiegers_4", "wh_dlc08_nor_inf_marauder_hunters_1", 2)
random_army_manager:add_unit("chaos_besiegers_4", "wh_dlc08_nor_inf_marauder_hunters_0", 2)
random_army_manager:add_unit("chaos_besiegers_4", "wh_main_chs_cav_marauder_horsemen_0", 3)
random_army_manager:add_unit("chaos_besiegers_4", "wh_main_nor_mon_chaos_trolls", 2)
random_army_manager:add_unit("chaos_besiegers_4", "wh_dlc08_nor_mon_war_mammoth_0", 1)
random_army_manager:add_unit("chaos_besiegers_4", "wh_dlc08_nor_mon_war_mammoth_1", 1)
random_army_manager:add_unit("chaos_besiegers_4", "wh_dlc08_nor_mon_war_mammoth_2", 1)
random_army_manager:add_unit("chaos_besiegers_4", "wh_dlc08_nor_feral_manticore", 1)

function Bastion:great_bastion_start()
	out.design("*** Great Bastion listeners started ***")
	
	-- set the two values to be shown in the bastion threat bar tooltip
	cm:set_script_state("base_threat_per_turn", self.base_threat_per_turn)
	cm:set_script_state("base_gate_threat_increase", self.base_gate_threat_increase)
	
	local combined_map = cm:get_campaign_name() == "main_warhammer"
	-- Setup event and region data for each campaign
	if combined_map then
		Bastion.gate_key_list = Bastion.gate_key_list_combi
		Bastion.region_list = Bastion.region_list_combi
		Bastion.spawn_locations_by_gate = Bastion.spawn_locations_by_gate_combi
		Bastion.cathay_bastion_regions = Bastion.cathay_bastion_regions_combi
		Bastion.snake_gate = Bastion.snake_gate_combi
		Bastion.invasion_spawn_region = Bastion.invasion_spawn_region_combi
		Bastion.dragon_emperors_wrath_region_list = Bastion.dragon_emperors_wrath_region_list_combi
	end
	
	-- Disable Public Order for the Bastion Gatehouses
	for i = 1, #self.spawn_locations_by_gate do
		cm:set_public_order_disabled_for_province_for_region_for_all_factions_and_set_default(self.spawn_locations_by_gate[i].gate_key, true)
	end
	
	-- for IE, disable further Bastion behaviour if there are no human Cathayans.
	if combined_map and #cm:get_human_factions_of_subculture(self.cathay_subculture) < 1 then
		return
	end
	
	-- reduce the threat each time a kurgan warband army is defeated in battle, or end the active invasion if they die entirely
	core:add_listener(
		"check_bastion_threat_battle",
		"BattleCompleted",
		function()
			return cm:pending_battle_cache_faction_is_involved(self.invasion_faction)
		end,
		function()
			if cm:pending_battle_cache_attacker_victory() and cm:pending_battle_cache_faction_is_defender(self.invasion_faction) and not self:get_saved_invasion_active_value() then
				out.design("Bastion: Kurgan army destroyed in battle, modifying threat by -" .. self.destroyed_army_threat_reduction)
				
				self:trigger_incident(self.message_keys["invader_killed"], true)
				
				local new_threat = math.max(self:get_saved_threat_value() - self.destroyed_army_threat_reduction, 0)
				self:set_saved_threat_value_and_update_ui(new_threat)
			end
			
			if cm:get_faction(self.invasion_faction):is_dead() then
				self:end_bastion_invasion()
			end
		end,
		true
	)

	-- update the threat each round. if the bar fills, trigger a full on invasion
	core:add_listener(
		"respawn_bastion_besiegers",
		"WorldStartRound",
		true,
		function()
			local turn_number = cm:model():turn_number()
			local kurgan_warband = cm:get_faction(self.invasion_faction)
			
			-- recalculate the current threat level
			local new_threat = self:get_saved_threat_value()
			
			if turn_number > 1 then
				new_threat = math.min(new_threat + self:get_threat_increase_value(), self.max_threat_value)
			end
			
			self:set_saved_threat_value_and_update_ui(new_threat)
			
			local invasion_active = self:get_saved_invasion_active_value()
			
			-- if the faction is dead end any active invasion
			if kurgan_warband:is_dead() then
				self:end_bastion_invasion()
			end
			
			-- if there isn't an active invasion, spawn small armies under ai control up to the number of razed gates
			if not invasion_active then
				local num_razed_gates = 0
				
				for i = 1, #self.spawn_locations_by_gate do
					if cm:get_region(self.spawn_locations_by_gate[i].gate_key):is_abandoned() then
						num_razed_gates = num_razed_gates + 1
					end
				end
				
				local armies_to_spawn = num_razed_gates - kurgan_warband:military_force_list():num_items()
				
				if armies_to_spawn > 0 then
					for i = 1, math.min(armies_to_spawn, #self.spawn_locations_by_gate) do
						local gate = self.spawn_locations_by_gate[i]
						local coordinates = gate.spawn_locations[1]
						
						self:spawn_army(7, "chaos_besiegers_1", coordinates)
						out.design("\tBastion: Spawning small army for [" .. gate.gate_key .. "] at position [" .. coordinates[1] .. ", " .. coordinates[2] .. "]")
					end
				end
				
				local mf_list = kurgan_warband:military_force_list()
				
				for i = 0, mf_list:num_items() - 1 do
					self:release_invasion_army_to_ai(mf_list:item_at(i))
				end
			end
			
			-- threat isn't full and an invasion isn't active
			if new_threat < self.max_threat_value and not invasion_active then
				local threat_increase = self:get_threat_increase_value()
				-- threat meter will fill next turn
				if new_threat + threat_increase >= self.max_threat_value then
					-- get the army strength data based on turn number and difficulty, and spawn the armies
					local army_vars = {}
					
					if turn_number > self.army_spawn_at_period_late then
						army_vars = self.invasion_set_spawn_variables.end_game
					elseif turn_number > self.army_spawn_at_period_mid then
						army_vars = self.invasion_set_spawn_variables.late
					elseif turn_number > self.army_spawn_at_period_early then
						army_vars = self.invasion_set_spawn_variables.mid
					else
						army_vars = self.invasion_set_spawn_variables.early
					end
					
					local difficulty = "normal"
					
					local human_factions = cm:get_human_factions(true)
					for i = 1, #human_factions do
						if cm:get_faction(human_factions[i]):subculture() == self.cathay_subculture then
							difficulty = cm:get_difficulty(true)
							break
						end
					end
					
					if army_vars.difficulty_additions[difficulty] then
						if army_vars.difficulty_additions[difficulty].extra_armies then
							army_vars.army_amount = army_vars.army_amount + army_vars.difficulty_additions[difficulty].extra_armies
						end
						
						if army_vars.difficulty_additions[difficulty].extra_army_size then
							army_vars.army_size = army_vars.army_size + army_vars.difficulty_additions[difficulty].extra_army_size
						end
					end
					
					local gate_spawn_list = {}
					
					for i = 1, #self.spawn_locations_by_gate do
						table.insert(gate_spawn_list, self.spawn_locations_by_gate[i].gate_key)
					end
					
					for i = 1, (army_vars.army_amount - #gate_spawn_list) do
						table.insert(gate_spawn_list, cm:get_saved_value("gate_focus"))
					end
					
					for i = 1, (army_vars.army_amount - kurgan_warband:military_force_list():num_items()) do
						local position = self:get_random_position_for_gate(gate_spawn_list[i])
						self:spawn_army(army_vars.army_size, army_vars.invasion_name, position)
					end
					cm:set_saved_value("used_gate_spawns", {})
					
					self:spawn_bastion_agent_if_none()
				-- threat meter will fill in two turns
				elseif new_threat + (2 * threat_increase) >= self.max_threat_value and not invasion_active then
					-- select a random gate to target and warn the player
					local selected_gate = self:get_random_gate()
					cm:set_saved_value("gate_focus", selected_gate)
					self:trigger_incident(self.message_keys["threat_increasing"], false, selected_gate)
					out.design("Bastion: Invasion is near, selecting [" .. selected_gate .. "] as a target")
				end
			-- threat meter has filled
			elseif new_threat >= self.max_threat_value and not invasion_active then
				-- release the armies to the ai
				local mf_list = kurgan_warband:military_force_list()
				
				for i = 0, mf_list:num_items() - 1 do
					self:release_invasion_army_to_ai(mf_list:item_at(i))
				end
				
				self:set_saved_invasion_active_value(true)
				self:trigger_incident(self.message_keys["begin_attack"], true)
				out.design("Bastion: Beginning invasion!")
			else
				-- check if the invasion has lasted the maximum number of turns, if so, end it
				local duration = cm:get_saved_value("invasion_duration") or 1
				
				if duration >= self.invasion_duration_threshold then
					self:end_bastion_invasion()
				else
					duration = duration + 1
					self:set_saved_invasion_duration_value(duration)
				end
			end
			
			-- respawn heroes every 5 turns
			if turn_number % 5 == 0 then
				self:spawn_bastion_agent_if_none()
			end
			
			-- if an invasion is active, count how many regions are not occupied by cathay. if enough have been lost, end the invasion
			local region_unoccupied_count = 0
			
			for i = 1, #self.cathay_bastion_regions do
				local current_bastion_region = cm:get_region(self.cathay_bastion_regions[i])
				if current_bastion_region:is_abandoned() or current_bastion_region:owning_faction():subculture() ~= self.cathay_subculture then
					region_unoccupied_count = region_unoccupied_count + 1
				end
			end
			
			if region_unoccupied_count >= self.max_regions_unoccupied_by_cathay then
				out.design("Bastion: Bastion invasion destroyed too much. Stopping invasion")
				self:end_bastion_invasion(true)
			end
			
			-- ensure kurgan warband and dreaded wo are always allied
			local dreaded_wo = cm:get_faction("wh3_main_chs_dreaded_wo")
			if dreaded_wo and not kurgan_warband:allied_with(dreaded_wo) then
				cm:disable_event_feed_events(true, "", "", "diplomacy_treaty_negotiated_military_alliance")
				cm:force_alliance(self.invasion_faction, "wh3_main_chs_dreaded_wo", true)
				cm:callback(function() cm:disable_event_feed_events(false, "", "", "diplomacy_treaty_negotiated_military_alliance") end, 0.2)
			end
		end,
		true
	)
	
	-- handle the dragon emperors wrath compass ability
	core:add_listener(
		"emperors_wrath_activated",
		"WoMCompassUserActionTriggeredEvent",
		function(context)
			return context:action() == "apply_attrition_to_enemies_in_direction"
		end,
		function()
			for i = 1, #self.dragon_emperors_wrath_region_list do
				cm:apply_effect_bundle_to_region("wh3_region_payload_compass_wrath", self.dragon_emperors_wrath_region_list[i], 3)
			end
			
			if cm:get_local_faction_subculture(true) == self.cathay_subculture then
				CampaignUI.ClosePanel("cathay_compass")
				cuim:start_scripted_sequence()
				
				cm:scroll_camera_with_cutscene_to_settlement(3, function() cuim:stop_scripted_sequence() end, self.dragon_emperors_wrath_region_list[1])
			end
		end,
		true
	)
	
	-- set up custom battle scripts for Miao Ying and Zhao Ming when defending the bastion, it will trigger a unique cutscene in battle
	core:add_listener(
		"player_defends_bastion_battle",
		"BattleBeingFought",
		function()
			cm:remove_custom_battlefield("bastion_battle")
			
			local pb = cm:model():pending_battle()
			
			if pb:has_defender() then
				local defender = pb:defender()
				local subtype = defender:character_subtype_key()
				
				if pb:siege_battle() and (subtype == "wh3_main_cth_miao_ying" or subtype == "wh3_main_cth_zhao_ming") and defender:faction():is_human() then
					local region_key = pb:region_data():key()
					
					for i = 1, #self.spawn_locations_by_gate do
						if region_key == self.spawn_locations_by_gate[i].gate_key then
							return true
						end
					end
				end
			end
		end,
		function()
			local pb = cm:model():pending_battle()
			local script = "script/battle/quest_battles/cathay_bastion/miao_ying/battle_script.lua"
			
			if pb:defender():character_subtype_key() == "wh3_main_cth_zhao_ming" then
				script = "script/battle/quest_battles/cathay_bastion/zhao_ming/battle_script.lua"
			end
			
			local x, y = pb:display_position()
			
			cm:add_custom_battlefield(
				"bastion_battle",		-- string identifier
				x,						-- x co-ord
				y,						-- y co-ord
				9999,					-- radius around position
				false,					-- will campaign be dumped
				"",						-- loading override
				script,					-- script override
				"",						-- entire battle override
				0,						-- human alliance when battle override
				false,					-- launch battle immediately
				true,					-- is land battle (only for launch battle immediately)
				false					-- force application of autoresolver result
			)
		end,
		true
	)
	
	core:add_listener(
		"reload_bastion_threat_UI_compass",
		"WoMCompassUserDirectionSelectedEvent",
		true,
		function()
			self:get_threat_increase_value()
		end,
		true
	)
	
	core:add_listener(
		"reload_bastion_threat_UI_region",
		"RegionFactionChangeEvent",
		true,
		function()
			self:get_threat_increase_value()
		end,
		true
	)
	
	self:get_threat_increase_value()
	self:collect_threat_bonus_values()
end

-- get the current threat increase value, made up of the base threat, bastions not controlled by cathay and any bonus values
function Bastion:get_threat_increase_value()
	local threat_increase = self.base_threat_per_turn
	
	for i = 1, #self.spawn_locations_by_gate do
		local gate_key = self.spawn_locations_by_gate[i].gate_key
		local current_bastion_region = cm:get_region(gate_key)
		
		if current_bastion_region:is_abandoned() or current_bastion_region:owning_faction():subculture() ~= self.cathay_subculture then
			out.design("\tBastion: Bastion [" .. gate_key .. "] is not occupied by Cathay - adding: " .. self.base_gate_threat_increase)
			threat_increase = threat_increase + self.base_gate_threat_increase
		end
	end
	
	local bonus_values = self:collect_threat_bonus_values()
	
	threat_increase = math.max(threat_increase + bonus_values, 1)
	
	out.design("Bastion: Current bastion threat change is: " .. threat_increase .. " (bonus values are " .. bonus_values .. ")")
	
	cm:set_script_state("bastion_threat_change", threat_increase)
	
	return threat_increase
end

-- trigger an incident for all human cathay factions
function Bastion:trigger_incident(incident_key, target_kurgan_warband, region)
	local human_factions = cm:get_human_factions(true)
	
	for i = 1, #human_factions do
		local current_human_faction = cm:get_faction(human_factions[i])
		
		if current_human_faction:culture() == "wh3_main_cth_cathay" then
			if target_kurgan_warband then
				cm:trigger_incident_with_targets(current_human_faction:command_queue_index(), incident_key, cm:get_faction(self.invasion_faction):command_queue_index(), 0, 0, 0, 0, 0)
			elseif region then
				cm:trigger_incident_with_targets(current_human_faction:command_queue_index(), incident_key, 0, 0, 0, 0, cm:get_region(region):cqi(), 0)
			else
				cm:trigger_incident(human_factions[i], incident_key, true)
			end
		end
	end
end

-- spawn a kurgan warband army at a given position
function Bastion:spawn_army(army_size, invasion_name, position_coords)
	local force_list = random_army_manager:generate_force(invasion_name, army_size, false)
	local x, y = cm:find_valid_spawn_location_for_character_from_position(self.invasion_faction, position_coords[1], position_coords[2], false, 5)
	
	cm:create_force_with_general(
		self.invasion_faction,
		force_list,
		cm:model():world():region_manager():region_list():item_at(0):name(),
		x,
		y,
		"general",
		"wh_main_nor_marauder_chieftain",
		"",
		"",
		"",
		"",
		false,
		function(cqi)
			cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force", cqi, 0)
			local general = cm:get_character_by_cqi(cqi)
			local invasion = invasion_manager:get_invasion(cqi)
			
			if not invasion then
				invasion = invasion_manager:new_invasion_from_existing_force(tostring(cqi), general:military_force())
			end
			
			local m_x = general:logical_position_x()
			local m_y = general:logical_position_y()
			
			invasion:apply_effect("wh_main_bundle_military_upkeep_free_force", -1)
			
			local coords = {{x = m_x, y = m_y},{x = m_x, y = m_y}}
			invasion:set_target("PATROL", coords, nil)
			invasion:add_aggro_radius(5)
			if invasion:has_target() then
				out.design("\t\tBastion: Setting invasion with general [" .. common.get_localised_string(general:get_forename()) .. "] to be stationary")
				invasion:start_invasion(nil, true, false, false)
			end
		end
	)
end

-- end the active invasion - resets the threat back to 0
function Bastion:end_bastion_invasion(invasion_successful)
	if not self:get_saved_invasion_active_value() then
		return false
	end
	
	out.design("Bastion: Invasion has finished, resetting threat")
	
	self:set_saved_invasion_active_value(false)
	
	if invasion_successful then
		self:trigger_incident(self.message_keys["invasion_successful"], true)
	else
		self:trigger_incident(self.message_keys["threat_decreasing"], true)
	end
	
	self:set_saved_invasion_duration_value(0)
	self:set_saved_threat_value_and_update_ui(0)
end

-- release script locked invasion armies to ai control
function Bastion:release_invasion_army_to_ai(force)
	local general = force:general_character()
	local invasion = invasion_manager:get_invasion(tostring(general:cqi()))
	
	if invasion then
		out.design("\t\tBastion: Releasing invasion with general [" .. common.get_localised_string(general:get_forename()) .. "] to the AI")
		invasion:release()
	end
	
	cm:cai_enable_movement_for_character(cm:char_lookup_str(general))
end

-- spawn a hero if the kurgan warband faction doesn't have any
function Bastion:spawn_bastion_agent_if_none()
	local faction = cm:get_faction(self.invasion_faction)
	
	if not cm:faction_contains_agents(faction) then
		local position = self:get_random_position_for_gate(self:get_random_gate())
		cm:set_saved_value("used_gate_spawns", {})
		local x, y = cm:find_valid_spawn_location_for_character_from_position(self.invasion_faction, position[1], position[2], false, 5)
		local agent = cm:spawn_agent_at_position(faction, x, y, "wizard")
		if not agent:is_null_interface() then
			out.design("Bastion: Spawned Kurgan Warband hero at [" .. x .. ", " .. y .. "] with name: [" .. common.get_localised_string(agent:get_forename()) .. "]")
		end
	end
end

-- total up all bonus values on the bastion regions that can modify the threat level
function Bastion:collect_threat_bonus_values()
	local bv = 0
	local compass_bv = 0
	
	for i = 1, #self.spawn_locations_by_gate do
		local current_bastion_region = cm:get_region(self.spawn_locations_by_gate[i].gate_key)
		local regions_compass_bv = cm:get_regions_bonus_value(current_bastion_region, "bastion_threat_modifier_compass")
		
		if compass_bv == 0 and regions_compass_bv ~= 0 then
			compass_bv = regions_compass_bv
			cm:set_script_state("base_compass_threat_decrease", compass_bv)
		end
		
		if not current_bastion_region:is_abandoned() and current_bastion_region:owning_faction():subculture() == self.cathay_subculture then
			bv = bv + cm:get_regions_bonus_value(current_bastion_region, "bastion_threat_modifier") or 0
		end
	end
	
	bv = bv + compass_bv
	
	return bv
end

-- save the total threat value and update the ui
function Bastion:set_saved_threat_value_and_update_ui(value)
	out.design("Bastion: Setting threat level to " .. value)
	cm:set_script_state("bastion_threat", math.min(value / 100, 1.0))
	cm:set_saved_value("threat_value", value)
end

-- get the saved total threat value
function Bastion:get_saved_threat_value()
	return cm:get_saved_value("threat_value") or self.new_game_starting_threat
end

-- set the saved invasion active value
function Bastion:set_saved_invasion_active_value(value)
	cm:set_saved_value("invasion_active", value)
end

-- get the saved invasion active value
function Bastion:get_saved_invasion_active_value()
	return cm:get_saved_value("invasion_active") or false
end

-- get a random gate region key
function Bastion:get_random_gate()
	local gates = {}
	
	for i = 1, #self.spawn_locations_by_gate do
		table.insert(gates, self.spawn_locations_by_gate[i].gate_key)
	end
	
	return gates[cm:random_number(#gates)]
end

-- save the invasion duration value
function Bastion:set_saved_invasion_duration_value(value)
	cm:set_saved_value("invasion_duration", value)
end

-- get a random set of coordinates for a given gate region. this will get called multiple times per turn, so keep track of which positions have been used so don't spawn multiple armies in the same spot
function Bastion:get_random_position_for_gate(gate_key)
	local spawn_positions = {}
	
	for i = 1, #self.spawn_locations_by_gate do
		local current_gate = self.spawn_locations_by_gate[i]
		if gate_key == current_gate.gate_key then
			spawn_positions = table.copy(current_gate.spawn_locations)
			break
		end
	end
	
	local found_position = cm:random_number(#spawn_positions)
	local used_positions = cm:get_saved_value("used_gate_spawns") or {}
	found_position = spawn_positions[found_position]
	
	if used_positions[tostring(found_position[1])] then
		if #used_positions >= #spawn_positions then
			cm:set_saved_value("used_gate_spawns", {})
		end
		found_position = self:get_random_position_for_gate(gate_key)
	else
		used_positions[tostring(found_position[1])] = true
		cm:set_saved_value("used_gate_spawns", used_positions)
	end
	
	return found_position
end