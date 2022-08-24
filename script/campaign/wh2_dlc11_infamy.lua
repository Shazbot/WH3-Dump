infamy = {
	vampire_coast_culture = "wh2_dlc11_cst_vampire_coast",
	player_shanty_levels = {
		["wh2_dlc11_cst_noctilus"] = 0,
		["wh2_dlc11_cst_pirates_of_sartosa"] = 0,
		["wh2_dlc11_cst_the_drowned"] = 0,
		["wh2_dlc11_cst_vampire_coast"] = 0
	},

	-- we need to declare these so that we can later detect if they have been defeated for mp shanty missions
	playable_pirate_leader_cqis = {},

	player_shanty_missions_active = {
		{
			-- 1
			["wh2_dlc11_cst_noctilus"] = false,
			["wh2_dlc11_cst_pirates_of_sartosa"] = false,
			["wh2_dlc11_cst_the_drowned"] = false,
			["wh2_dlc11_cst_vampire_coast"] = false
		},
		{
			-- 2
			["wh2_dlc11_cst_noctilus"] = false,
			["wh2_dlc11_cst_pirates_of_sartosa"] = false,
			["wh2_dlc11_cst_the_drowned"] = false,
			["wh2_dlc11_cst_vampire_coast"] = false
		},
		{
			-- 3
			["wh2_dlc11_cst_noctilus"] = false,
			["wh2_dlc11_cst_pirates_of_sartosa"] = false,
			["wh2_dlc11_cst_the_drowned"] = false,
			["wh2_dlc11_cst_vampire_coast"] = false
		}
	},

	starting_infamy = {
		["wh2_dlc11_cst_rogue_boyz_of_the_forbidden_coast"] = 1000,
		["wh2_dlc11_cst_rogue_freebooters_of_port_royale"] = 2000,
		["wh2_dlc11_cst_rogue_the_churning_gulf_raiders"] = 3000,
		["wh2_dlc11_cst_shanty_middle_sea_brigands"] = 4000,
		["wh2_dlc11_cst_rogue_bleak_coast_buccaneers"] = 5000,
		["wh2_dlc11_cst_rogue_grey_point_scuttlers"] = 6000,
		["wh2_dlc11_cst_shanty_dragon_spine_privateers"] = 7000,
		["wh2_dlc11_cst_rogue_tyrants_of_the_black_ocean"] = 8000,
		["wh2_dlc11_cst_rogue_terrors_of_the_dark_straights"] = 9000,
		["wh2_dlc11_cst_shanty_shark_straight_seadogs"] = 12000
	},

	starting_infamy_mod = 2,

	kill_income_mod = 0.3,
	kill_income_cap = 500,

	player_shanty_mission_key = "wh2_dlc11_mission_sea_shanty_player_",
	shanty_mission_key = "wh2_dlc11_mission_sea_shanty_",
	shanty_verse_bundle = "wh2_dlc11_bundle_sea_shanty_verse_",
	shanty_incident = "wh2_dlc11_incident_cst_sea_shanty_gained_",
	infamy_pooled_resource = "cst_infamy",
	effect_bundle_sea_shanty = "effect_bundle{bundle_key wh2_dlc11_bundle_sea_shanty_verse_",
	effect_bundle_sea_shanty_complete = "effect_bundle{bundle_key wh2_dlc11_bundle_sea_shanty_complete;turns 0;}",
	shanty_mission_condition_text = "override_text mission_text_text_wh3_main_objective_defeat_faction_leader_or_alliance",

	mp_shanty_steal_chance = 15
}


function infamy:add_infamy_listeners()
	out("#### Adding Infamy Listeners ####")
	
	if cm:are_any_factions_human(nil, self.vampire_coast_culture) then
		self:battle_complete_listener()
		self:mission_success_listeners()
		self:assassination_listener()
		self:shanty_multiplayer_mission_completion_listener()
		
		if(cm:is_new_game()) then
			self:setup_initial_infamy_levels()
			self:log_playable_pirate_leader_cqis()
		end
		
		core:add_listener(
			"reload_infamy",
			"UIReloaded",
			true,
			function()
				self:update_ui()
			end,
			true
		)
		
		self:update_ui()
	end
end

function infamy:log_playable_pirate_leader_cqis()
	local faction_list = cm:model():world():faction_list()
	
	for _, current_faction in model_pairs(faction_list) do
		if self:is_faction_playable_vampire_coast(current_faction) and current_faction:has_faction_leader() then
			self.playable_pirate_leader_cqis[current_faction:name()] = current_faction:faction_leader():command_queue_index()
		end
	end
end

function infamy:setup_initial_infamy_levels()
	local human_vampire_coast = false
	local start_infamy = 200
	
	local faction_list = cm:model():world():faction_list()
	
	for _, current_faction in model_pairs(faction_list) do
		if self:is_faction_playable_vampire_coast(current_faction) then
			if current_faction:is_human() then
				self:modify_infamy(current_faction:name(), "other", 200)
				human_vampire_coast = true
			else
				start_infamy = start_infamy + 200
				self:modify_infamy(current_faction:name(), "other", start_infamy)
			end
		end
	end
	
	for i = 1, #roving_pirates.pirate_details do
		local pirate = roving_pirates.pirate_details[i]

		start_infamy = self.starting_infamy[pirate.faction_key] * self.starting_infamy_mod
		pirate.infamy = start_infamy
		self:modify_infamy(pirate.faction_key, "other", start_infamy)
	end
end


function infamy:launch_shanty_mission(player_faction_key, target, target_is_human, target_shanty_level)
	if (target_is_human == false) then
		-- Trigger the mission for AI target
		local mission_key = self.shanty_mission_key..target_shanty_level

		local mm = mission_manager:new(player_faction_key, mission_key)
		mm:set_mission_issuer("CLAN_ELDERS")
		
		mm:add_new_objective("ENGAGE_FORCE")
		mm:add_condition("cqi "..target.cqi)
		mm:add_condition("requires_victory")
		
		-- this bundle makes it so the army is wiped out after a single defeat
		mm:add_payload(self.effect_bundle_sea_shanty..target_shanty_level..";turns 0;}")

		if(target_shanty_level == 3) then
			mm:add_payload(self.effect_bundle_sea_shanty_complete)
		end

		mm:trigger()

		self.player_shanty_missions_active[target_shanty_level][player_faction_key] = mission_key
	else
		local mission_key = self.player_shanty_mission_key..target_shanty_level
		local script_key = mission_key.."_"..player_faction_key

		if(target_shanty_level > self.player_shanty_levels[player_faction_key] and self.player_shanty_missions_active[target_shanty_level][player_faction_key] == false) then
			-- Trigger the mission for human target
			-- fail any previous human target missions
			cm:complete_scripted_mission_objective(player_faction_key, self.player_shanty_mission_key.."1", self.player_shanty_mission_key.."1_"..player_faction_key, false)
			cm:complete_scripted_mission_objective(player_faction_key, self.player_shanty_mission_key.."2", self.player_shanty_mission_key.."2_"..player_faction_key, false)
			self.player_shanty_missions_active[1][player_faction_key] = false
			self.player_shanty_missions_active[2][player_faction_key] = false
			
			local mm = mission_manager:new(player_faction_key, mission_key)
			mm:set_mission_issuer("CLAN_ELDERS")
			
			mm:add_new_objective("SCRIPTED")
			mm:add_condition("script_key "..script_key)
			mm:add_condition(self.shanty_mission_condition_text)
			
			mm:add_payload(self.effect_bundle_sea_shanty..target_shanty_level..";turns 0;}")
			if(target_shanty_level == 3) then
				mm:add_payload(self.effect_bundle_sea_shanty_complete)
			end
			
			mm:trigger()

			self.player_shanty_missions_active[target_shanty_level][player_faction_key] = mission_key
		end

		if(self.player_shanty_missions_active[target_shanty_level][player_faction_key]) then
			-- player is currently on this mission tier (new or existing). Update the mission targets with latest pirates who already own the verse.
			local faction_list = cm:model():world():faction_list()
			
			for _, current_faction in model_pairs(faction_list) do
				if self:is_faction_playable_vampire_coast(current_faction) then
					local enemy_player_key = current_faction:name()
					if enemy_player_key ~= player_faction_key and self.player_shanty_levels[enemy_player_key] >= target_shanty_level then
						local enemy_faction = cm:get_faction(enemy_player_key)
						
						if not enemy_faction:is_dead() then
							cm:set_scripted_mission_entity_completion_states(mission_key, script_key, {{enemy_faction, false}})
						end
					end
				end
			end
		end
	end
end


function infamy:kill_shanty_faction(shanty_level)
	for _, pirate in ipairs(roving_pirates.pirate_details) do
		if(pirate.shanty_level == shanty_level) then
			cm:callback(function()
				-- this was crashing when trying to kill the army in the same tick as the battle was still ending/the mission was completed. Callback fixes it.
				pirate.shanty_held = false
				invasion_manager:kill_invasion_by_key(pirate.faction_key.."_PIRATE")
			end, 1)

			return
		end
	end
end


function infamy:mission_success_listeners(context)
	core:add_listener(
		"ShantyMissionSucceeded",
		"MissionSucceeded",
		function(context)
			return context:mission():mission_record_key():starts_with(self.shanty_mission_key)
		end,
		function(context) 
			local mission_key = context:mission():mission_record_key()
			local faction = context:faction()
			local faction_name = faction:name()
			local shanty_level

			for i = 3, 1, -1 do
				-- we check missions in reverse order to ensure the player only gets the top level of reward and not every tier of reward if they had a few missions stacked up.
				if(mission_key == self.player_shanty_mission_key..i) then
					-- target was other players
					shanty_level = i
					break
				elseif(mission_key == self.shanty_mission_key..i) then
					-- target was original ai target
					shanty_level = i
					self:kill_shanty_faction(i)
					break
				else
					script_error("ERROR: Mission key :"..mission_key.." does not match expected sea shanty mission key prefix")
				end
			end
			
			self.player_shanty_missions_active[shanty_level][faction_name] = false

			if(self.player_shanty_levels[faction_name] < shanty_level) then
				self:shanty_reward(faction_name, shanty_level)
				self.player_shanty_levels[faction_name] = shanty_level
			end	

			-- a pirate has cleared a shanty level, launch mp shanty mission for that tier for all other player pirates who haven't reached that tier yet
			local faction_list = cm:model():world():faction_list()

			for _, current_faction in model_pairs(faction_list) do
				if self:is_faction_playable_vampire_coast(current_faction) then
					local pirate_key = current_faction:name()
					if faction_name ~= pirate_key and self.player_shanty_levels[faction_name] > self.player_shanty_levels[pirate_key] and current_faction:is_human() then
						self:launch_shanty_mission(pirate_key, nil, true, shanty_level)
					end
				end
			end
		end,
		true
	)
end


function infamy:shanty_multiplayer_mission_completion_listener()
	core:add_listener(
		"ShantyMPMissionBattleObjective",
		"BattleCompleted",
		function(context)
			return cm:model():pending_battle():has_been_fought() 
		end,
		function(context) 
			local pending_battle = cm:model():pending_battle()
			local attacker_list = {}
			local defender_list = {}
			local winner_list, loser_list

			for i = 1, cm:pending_battle_cache_num_attackers() do
				local attacker_cqi, attacker_mf_cqi, attacker_faction_name = cm:pending_battle_cache_get_attacker(i)
				table.insert(attacker_list, attacker_faction_name)
			end

			for i = 1, cm:pending_battle_cache_num_defenders() do
				local defender_cqi, defender_mf_cqi, defender_faction_name = cm:pending_battle_cache_get_defender(i)
				table.insert(defender_list, defender_faction_name)
			end
			
			if(pending_battle:attacker_won()) then
				winner_list = attacker_list
				loser_list = defender_list
			elseif(pending_battle:defender_won()) then
				winner_list = defender_list
				loser_list = attacker_list
			else
				-- battle was a draw, do nothing.
				return false
			end
			
			for i = 1, #winner_list do
				if self:is_faction_playable_vampire_coast(winner_list[i]) then
					-- One of the battle winners is a playable pirate
					for i = 1, 3 do
						local mission_key = self.player_shanty_missions_active[i][winner_list[i]]

						if(is_string(mission_key) and string.find(mission_key, "player")) then
							-- One of the battle winners is on a shanty mission
							local faction_list = cm:model():world():faction_list()

							for _, current_faction in model_pairs(faction_list) do
								if self:is_faction_playable_vampire_coast(current_faction) then
									local loser_pirate = current_faction:name()
									
									if(loser_list[loser_pirate] and self.player_shanty_levels[loser_pirate] > self.player_shanty_levels[winner_list[i]]) then
										if(self.playable_pirate_leader_cqis[loser_pirate] and self.playable_pirate_leader_cqis[loser_pirate] == loser_list[loser_pirate]) then
											-- loser pirate is the faction leader and a higher shanty level, complete the mission.
											local objective_key = mission_key.."_"..winner_list[i]

											cm:complete_scripted_mission_objective(winner_list[i], mission_key, objective_key, true)
										else
											-- battle was against target faction but not faction leader. Use % chance to grant shanty
											local steal_roll = cm:random_number(100, 1)
											local objective_key = mission_key.."_"..winner_list[i]

											if(steal_roll <= self.mp_shanty_steal_chance) then
												cm:complete_scripted_mission_objective(winner_list[i], mission_key, objective_key, true)
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end,
		true
	)

	core:add_listener(
		"ShantyMPMissionAllianceObjective",
		"PositiveDiplomaticEvent",
		function(context)
			return context:is_alliance()
		end,
		function(context) 
			local proposer = context:proposer():name()
			local recipient = context:recipient():name()

			if(self.player_shanty_levels[proposer] and self.player_shanty_levels[recipient]) then
				-- Both factions are pirates
				local faction_list = cm:model():world():faction_list()

				for _, current_faction in model_pairs(faction_list) do
					if self:is_faction_playable_vampire_coast(current_faction) then
						local pirate = current_faction:name()
						
						if((pirate == proposer and self.player_shanty_levels[proposer] < self.player_shanty_levels[recipient]) or (pirate == recipient and self.player_shanty_levels[recipient] < self.player_shanty_levels[proposer])) then
							for i = 1, 3 do 
								local mission_key = self.player_shanty_missions_active[i][pirate]

								if(is_string(mission_key) and string.find(mission_key, "player")) then
									local objective_key = mission_key.."_"..pirate

									cm:complete_scripted_mission_objective(pirate, mission_key, objective_key, true)
								end
							end
						end
					end
				end
			end
		end,
		true
	)
	
	core:add_listener(
		"ShantyMPMissionAllianceTurnStartObjective",
		"FactionTurnStart",
		function(context)
			return self:is_faction_playable_vampire_coast(context:faction())
		end,
		function(context) 
			-- This listener checks if the player is already allied with a valid pirate at the time of recieving the mission.
			local faction = context:faction()
			local faction_name = faction:name()

			for i = 1, 3 do
				local mission_key = self.player_shanty_missions_active[i][faction_name]

				if(is_string(mission_key) and string.find(mission_key, "player")) then
					local faction_list = cm:model():world():faction_list()

					for _, current_faction in model_pairs(faction_list) do
						if self:is_faction_playable_vampire_coast(current_faction) then
							local pirate = current_faction:name()
							
							if(self.player_shanty_levels[faction_name] < self.player_shanty_levels[pirate]) then
								if(faction:allied_with(cm:get_faction(pirate))) then
									local objective_key = mission_key.."_"..faction_name

									cm:complete_scripted_mission_objective(faction_name, mission_key, objective_key, true)
								end
							end
						end
					end
				end
			end
		end, 
		true
	)
end


function infamy:shanty_reward(faction_key, level)
	-- Remove all Shanty Effects
	for i = 1, 3 do
		cm:remove_effect_bundle(self.shanty_verse_bundle..i, faction_key)
	end

	cm:trigger_incident(faction_key, self.shanty_incident..level, true, true)

	self:update_ui()
end


function infamy:update_ui()
	local infamy_holder = find_uicomponent(core:get_ui_root(), "infamy_holder")
	
	if infamy_holder and infamy_holder:Visible() == true then
	
		local is_multiplayer = cm:is_multiplayer()
		
		-- make a local copy of the infamy list (non-player factions at least) so we can work out the player's position within it
		local local_non_player_infamy_list = {}
		
		local function add_to_infamy_list(leader_name, faction_name, icon_folder, infamy_value, has_sea_shanty)
			infamy_holder:InterfaceFunction(
				"AddFakeEntry",
				leader_name,
				faction_name,
				icon_folder,
				infamy_value,
				has_sea_shanty
			)
			
			-- assemble a local infamy list in singleplayer mode (this is done for advice)
			if not is_multiplayer then
				-- insert a record in the correct position in the local infamy list
				for i = 1, #local_non_player_infamy_list do
					if local_non_player_infamy_list[i] < infamy_value then
						table.insert(local_non_player_infamy_list, i, infamy_value)
						return
					end
				end
				
				-- if we're here then we need to insert our infamy value at the end of the table
				table.insert(local_non_player_infamy_list, infamy_value)
			end
		end
		
		-- Add the real faction pirates who have infamy
		local faction_list = cm:model():world():faction_list()
		
		for i = 0, faction_list:num_items() - 1 do
			local faction = faction_list:item_at(i)
			local faction_key = faction:name()
			
			if not faction:pooled_resource_manager():resource(self.infamy_pooled_resource):is_null_interface() then
				local faction_infamy = faction:pooled_resource_manager():resource(self.infamy_pooled_resource)
				
				if faction_infamy:is_null_interface() == false then
					local infamy_value = faction_infamy:value()
					
					if faction:is_human() == false then
						-- Roving Pirates
						for i = 1, #roving_pirates.pirate_details do
							local pirate = roving_pirates.pirate_details[i]
							local show_pirate = true
							
							if pirate.shanty_held == false then
								local pirate_obj = cm:get_faction(pirate.faction_key)
								if pirate_obj:is_dead() == true then
									show_pirate = false
								end
							end
							
							if show_pirate == true and pirate.faction_key == faction_key then
								if infamy_value > 0 then
									add_to_infamy_list(
										faction_key.."_leader",				-- Leaders Name
										faction_key,						-- Faction Name
										faction_key,						-- Icon Folder
										infamy_value,						-- Infamy Amount
										pirate.item_owned == "sea_shanty"	-- Has Sea Shanty
									)
								end
								break
							end
						end
						-- Major Factions
						if self:is_faction_playable_vampire_coast(faction_key) then
							add_to_infamy_list(
								faction_key.."_leader",				-- Leaders Name
								faction_key,						-- Faction Name
								faction_key,						-- Icon Folder
								infamy_value,						-- Infamy Amount
								false								-- Has Sea Shanty
							)
						end
					end
				end
			end
		end

		-- work out the position of the player in the local infamy list in singleplayer mode (for advice)
		if not is_multiplayer then
			-- get the infamy value of the local player
			local local_player_infamy = cm:get_faction(cm:get_local_faction_name(true)):pooled_resource_manager():resource(self.infamy_pooled_resource):value()
			local position_of_local_player_in_infamy_list = false
			
			for i = 1, #local_non_player_infamy_list do
				if local_non_player_infamy_list[i] < local_player_infamy then
					-- local player is at position i in the infamy list
					position_of_local_player_in_infamy_list = i
					break
				end
			end
			
			if not position_of_local_player_in_infamy_list then
				-- no-one on the infamy list had less infamy than the player - the player is bottom of the list
				position_of_local_player_in_infamy_list = #local_non_player_infamy_list
			end
			
			-- if they've gained in position compared to the position previously cached, then attempt to trigger advice
			local cached_player_infamy_list_position = cm:get_saved_value("cached_player_infamy_list_position")
			if cached_player_infamy_list_position and cached_player_infamy_list_position > position_of_local_player_in_infamy_list then
				if cached_player_infamy_list_position == 1 then
					core:trigger_event("ScriptEventPlayerTopsInfamyList")
				else
					core:trigger_event("ScriptEventPlayerClimbsInfamyList")
				end
			end
			
			-- cache their current position in the infamy list
			cm:set_saved_value("cached_player_infamy_list_position", position_of_local_player_in_infamy_list)
		end
	end
end

function infamy:battle_complete_listener(context)
	core:add_listener(
		"InfamyBattleCompleted",
		"BattleCompleted",
		function() 
			return cm:model():pending_battle():has_been_fought() 
		end,
		function(context)
			local attacker_result = cm:model():pending_battle():attacker_battle_result()
			local defender_result = cm:model():pending_battle():defender_battle_result()
			local attacker_won = (attacker_result == "heroic_victory") or (attacker_result == "decisive_victory") or (attacker_result == "close_victory") or (attacker_result == "pyrrhic_victory")
			local defender_won = (defender_result == "heroic_victory") or (defender_result == "decisive_victory") or (defender_result == "close_victory") or (defender_result == "pyrrhic_victory")
			local attacker_value = cm:pending_battle_cache_attacker_value()
			local defender_value = cm:pending_battle_cache_defender_value()
			local already_awarded = {}
			
			-- Give any attackers who won their Infamy
			if attacker_won == true then
				local attacker_multiplier = defender_value / attacker_value
				attacker_multiplier = math.clamp(attacker_multiplier, 0.5, 1.5)
				local attacker_infamy = (defender_value / 10) * attacker_multiplier
				local kill_ratio = cm:model():pending_battle():percentage_of_defender_killed()
				attacker_infamy = attacker_infamy * kill_ratio
				
				for i = 1, cm:pending_battle_cache_num_attackers() do
					local attacker_cqi, attacker_force_cqi, attacker_name = cm:pending_battle_cache_get_attacker(i)
					
					if already_awarded[attacker_name] == nil then
						if self:is_faction_playable_vampire_coast(attacker_name) then
							local infamy_reward = attacker_infamy * self.kill_income_mod
							if infamy_reward > self.kill_income_cap then
								infamy_reward = self.kill_income_cap
							end
							infamy:modify_infamy(attacker_name, "enemy_units_killed", infamy_reward)
							already_awarded[attacker_name] = true
							infamy:print_battle_details(attacker_name, attacker_infamy, attacker_value, defender_value, attacker_multiplier, kill_ratio)
						end
					end
				end
			-- Give any defenders who won their Infamy
			elseif defender_won == true then
				local defender_multiplier = attacker_value / defender_value
				defender_multiplier = math.clamp(defender_multiplier, 0.5, 1.5)
				local defender_infamy = (attacker_value / 10) * defender_multiplier
				local kill_ratio = cm:model():pending_battle():percentage_of_attacker_killed()
				defender_infamy = defender_infamy * kill_ratio
				
				for i = 1, cm:pending_battle_cache_num_defenders() do
					local defender_cqi, defender_force_cqi, defender_name = cm:pending_battle_cache_get_defender(i)
					
					if already_awarded[defender_name] == nil then
						if self:is_faction_playable_vampire_coast(defender_name) then
							local infamy_reward = defender_infamy * self.kill_income_mod
							if infamy_reward > self.kill_income_cap then
								infamy_reward = self.kill_income_cap
							end
							infamy:modify_infamy(defender_name, "enemy_units_killed", infamy_reward)
							already_awarded[defender_name] = true
							infamy:print_battle_details(defender_name, defender_infamy, attacker_value, defender_value, defender_multiplier, kill_ratio)
						end
					end
				end
			end
		end,
		true
	)
end

function infamy:print_battle_details(faction, infamy_amount, aval, dval, bonus_mult, kill_ratio)
	infamy_amount = tonumber(string.format("%.0f", infamy_amount))
	out.design("--------------------------------------------")
	out.design("Infamy Battle Fought")
	out.design("\tWinner: "..faction)
	out.design("\tInfamy: "..infamy_amount)
	out.design("\t\tAttacker Value: "..aval)
	out.design("\t\tDefender Value: "..dval)
	out.design("\t\tStrength Ratio: "..bonus_mult)
	out.design("\t\tKill Ratio: "..kill_ratio)
	out.design("--------------------------------------------")
end

local infamy_assassination_results = {
	["wh2_main_agent_action_champion_hinder_agent_assassinate"] = true,
	["wh2_main_agent_action_spy_hinder_agent_assassinate"] = true,
	["wh2_main_agent_action_champion_hinder_agent_wound"] = true,
	["wh2_main_agent_action_dignitary_hinder_agent_wound"] = true,
	["wh2_main_agent_action_engineer_hinder_agent_wound"] = true,
	["wh2_main_agent_action_runesmith_hinder_agent_wound"] = true,
	["wh2_main_agent_action_wizard_hinder_agent_wound"] = true
}

function infamy:assassination_listener(context)
	core:add_listener(
		"InfamyAssassination",
		"CharacterCharacterTargetAction",
		function(context)
			return (context:mission_result_critial_success() or context:mission_result_success()) and infamy_assassination_results[context:agent_action_key()] and self:is_faction_playable_vampire_coast(context:character():faction())
		end,
		function(context)
			infamy:modify_infamy(context:character():faction():name(), "characters_assassinated", 100)
		end,
		true
	)
	
end

function infamy:modify_infamy(faction_key, factor, amount)
	if faction_key == cm:get_local_faction_name(true) then
		core:trigger_event("ScriptEventPlayerInfamyIncreases")
	end
	amount = math.floor(amount)
	out("Infamy: Adding " .. tostring(amount) .. " infamy to " .. tostring(faction_key) .. ", factor is " .. tostring(factor))
	cm:faction_add_pooled_resource(faction_key, self.infamy_pooled_resource, factor, amount)
end

function infamy:is_faction_playable_vampire_coast(faction)
	if is_string(faction) then
		faction = cm:get_faction(faction)
	end
	
	return faction and faction:culture() == self.vampire_coast_culture and faction:can_be_human()
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("infamy.player_shanty_levels", infamy.player_shanty_levels, context)
		cm:save_named_value("infamy.player_shanty_missions_active", infamy.player_shanty_missions_active, context)
		cm:save_named_value("infamy.playable_pirate_leader_cqis", infamy.playable_pirate_leader_cqis, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			infamy.player_shanty_levels = cm:load_named_value("infamy.player_shanty_levels", infamy.player_shanty_levels, context)
			infamy.player_shanty_missions_active = cm:load_named_value("infamy.player_shanty_missions_active", infamy.player_shanty_missions_active, context)
			infamy.playable_pirate_leader_cqis = cm:load_named_value("infamy.playable_pirate_leader_cqis", infamy.playable_pirate_leader_cqis, context)
		end
	end
)