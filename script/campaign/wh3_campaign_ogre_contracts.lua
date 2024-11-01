ogre_bounties = {
	mission_types = {
		{"KILL_CHARACTER_BY_ANY_MEANS", "wh3_main_mission_ogre_contract_defeat_lord"},
		{"CAPTURE_REGIONS", "wh3_main_mission_ogre_contract_capture_settlement"},
		{"RAZE_OR_SACK_N_DIFFERENT_SETTLEMENTS_INCLUDING", "wh3_main_mission_ogre_contract_raze_settlement"}
	},
	culture_mapping = {
		["wh2_dlc09_tmb_tomb_kings"] = "tomb_kings",
		["wh2_dlc11_cst_vampire_coast"] = "vampire_coast",
		["wh2_main_def_dark_elves"] = "dark_elves",
		["wh2_main_hef_high_elves"] = "high_elves",
		["wh2_main_lzd_lizardmen"] = "lizardmen",
		["wh2_main_skv_skaven"] = "skaven",
		["wh3_main_cth_cathay"] = "cathay",
		["wh3_main_dae_daemons"] = "warriors_of_chaos",
		["wh3_main_kho_khorne"] = "khorne",
		["wh3_main_ksl_kislev"] = "kislev",
		["wh3_main_nur_nurgle"] = "nurgle",
		["wh3_main_ogr_ogre_kingdoms"] = "ogre_kingdoms",
		["wh3_main_sla_slaanesh"] = "slaanesh",
		["wh3_main_tze_tzeentch"] = "tzeentch",
		["wh_dlc03_bst_beastmen"] = "beastmen",
		["wh_dlc05_wef_wood_elves"] = "wood_elves",
		["wh_dlc08_nor_norsca"] = "norsca",
		["wh_main_brt_bretonnia"] = "bretonnia",
		["wh_main_chs_chaos"] = "warriors_of_chaos",
		["wh_main_dwf_dwarfs"] = "dwarfs",
		["wh_main_emp_empire"] = "empire",
		["wh_main_grn_greenskins"] = "greenskins",
		["wh_main_vmp_vampire_counts"] = "vampire_counts"
	},
	military_force_types = {
		DISCIPLE_ARMY = true,
		OGRE_CAMP = true,
		CARAVAN = true,
		CONVOY = true
	},
	ogre_culture = "wh3_main_ogr_ogre_kingdoms",
	num_contracts = 3,
	turn_to_issue_contracts = 3
}

function ogre_bounties:setup_ogre_contracts()
	local human_factions = cm:get_human_factions_of_culture(self.ogre_culture)
	
	if #human_factions < 1 then return end
	
	common.set_context_value("bounties_turn_start", self.turn_to_issue_contracts)

	core:add_listener(
		"issue_contracts",
		"FactionTurnStart",
		function(context)
			local faction = context:faction()
			return cm:model():turn_number() >= self.turn_to_issue_contracts and faction:is_human() and faction:culture() == self.ogre_culture
		end,
		function(context)
			
			local number_of_active_contracts = context:faction():active_missions("OgreContract", true):num_items()
			
			local faction_name = context:faction():name()
			if number_of_active_contracts < self.num_contracts then
				self:attempt_to_issue_ogre_contracts(faction_name, self.num_contracts - number_of_active_contracts)
			end
		end,
		true
	)
end

function ogre_bounties:attempt_to_issue_ogre_contracts(faction_key, num_contracts)
	local faction = cm:get_faction(faction_key)
	local faction_has_home_region = faction:has_home_region()
	local faction_has_faction_leader = faction:has_faction_leader()
	local faction_region_list = faction:region_list()
	
	-- get 3 factions to issue missions
	local factions_met = faction:factions_met()
	
	local factions_met_at_peace = {}
	
	-- only get factions that have capitals near to the player
	local max_distance_between_player_settlement_and_issuer_capital = 50000
	
	for i = 0, factions_met:num_items() - 1 do
		local current_faction = factions_met:item_at(i)

		if not faction:at_war_with(current_faction) and not current_faction:is_dead() and not current_faction:is_human() and current_faction:has_home_region() then
			if faction_has_home_region then
				local current_faction_capital = current_faction:home_region():settlement()
				
				for j = 0, faction_region_list:num_items() - 1 do
					local current_settlement = faction_region_list:item_at(j):settlement()
					
					if distance_squared(current_settlement:logical_position_x(), current_settlement:logical_position_y(), current_faction_capital:logical_position_x(), current_faction_capital:logical_position_y()) < max_distance_between_player_settlement_and_issuer_capital then
						table.insert(factions_met_at_peace, current_faction)
						break
					end
				end
			elseif faction_has_faction_leader then
				table.insert(factions_met_at_peace, current_faction)
			else
				-- player doesn't have a faction leader or a capital somehow, not issuing contracts
				return false
			end
		end
	end
	
	if #factions_met_at_peace < 1 then
		-- found no peaceful factions, not issuing contracts
		return false
	end
	
	factions_met_at_peace = cm:random_sort(factions_met_at_peace)
	
	local used_general_targets = {}
	local used_region_targets = {}
	
	local faction_pos_x = 0
	local faction_pos_y = 0
	
	if faction_has_faction_leader and faction:faction_leader():has_military_force() then
		local faction_leader = faction:faction_leader()
		
		faction_pos_x = faction_leader:logical_position_x()
		faction_pos_y = faction_leader:logical_position_y()
	elseif faction_has_home_region then
		local capital = faction:home_region():settlement()
		
		faction_pos_x = capital:logical_position_x()
		faction_pos_y = capital:logical_position_y()
	else
		-- player doesn't have a faction leader or a capital somehow, not issuing contracts
		return false
	end
	
	for i = 1, num_contracts do
		local selected_issuing_faction = factions_met_at_peace[i]
		
		if not selected_issuing_faction then
			selected_issuing_faction = factions_met_at_peace[1]
		end
		
		local selected_issuing_faction_name = selected_issuing_faction:name()
		
		out.design("Selected issuing faction: " .. selected_issuing_faction_name)
		
		-- select an enemy to target
		local enemies = selected_issuing_faction:factions_at_war_with()
		
		-- filter out any factions that are dead or have no armies
		local filtered_enemies = {}
		
		for j = 0, enemies:num_items() - 1 do
			local current_enemy = enemies:item_at(j)
			
			if not current_enemy:is_dead() and not current_enemy:military_force_list():is_empty() and not current_enemy:has_effect_bundle("wh3_main_bundle_realm_factions") and not current_enemy:has_effect_bundle("wh3_main_bundle_rift_factions") then
				table.insert(filtered_enemies, current_enemy)
			end
		end
		
		local selected_enemy = false
		
		if #filtered_enemies == 0 then
			-- the issuer has no enemies, get the faction with the lowest relations instead
			local lowest_relation = 1000
			
			for j = 0, selected_issuing_faction:factions_met():num_items() - 1 do
				local current_faction_met = selected_issuing_faction:factions_met():item_at(j)
				
				-- filter out any human, dead or vassal/master factions
				if not current_faction_met:is_human() and not current_faction_met:is_dead() and not current_faction_met:has_effect_bundle("wh3_main_bundle_realm_factions") and not current_faction_met:has_effect_bundle("wh3_main_bundle_rift_factions") and not selected_issuing_faction:is_vassal_of(current_faction_met) and not current_faction_met:is_vassal_of(selected_issuing_faction) then
					local current_faction_relation = selected_issuing_faction:diplomatic_attitude_towards(current_faction_met:name())
					
					if current_faction_relation < lowest_relation then
						selected_enemy = current_faction_met
						lowest_relation = current_faction_relation
					end
				end
			end
		else
			-- the issuer has at least one enemy, get a random enemy
			selected_enemy = filtered_enemies[cm:random_number(#filtered_enemies)]
		end
		
		if not selected_enemy then
			script_error("Could not find an enemy to target a contract at. This should not be possible?")
			break
		end
		
		out.design("\tSelected enemy is: " .. selected_enemy:name())
		
		local mission_index = 1
		
		-- if the enemy has regions, allow those missions to be used too
		if not selected_enemy:region_list():is_empty() then
			mission_index = cm:random_number(#self.mission_types)
		end
		
		local selected_mission = self.mission_types[mission_index]
		
		out.design("\tSelected mission is " .. selected_mission[1])
		
		local obj_str = false
		local mission_distance = 0 -- convert the distance into a duration
		
		if selected_mission[1] == "KILL_CHARACTER_BY_ANY_MEANS" then
			-- get the closest general to the player, ensuring the same general is not used by the same issuer more than once
			local mf_list = selected_enemy:military_force_list()
			local valid_generals = {}
			
			-- build a table of valid generals before selecting one
			for j = 0, mf_list:num_items() - 1 do
				local current_mf = mf_list:item_at(j)
				local current_mf_force_type = current_mf:force_type():key()
				
				if not current_mf:is_armed_citizenry() and current_mf:has_general() and not self.military_force_types[current_mf_force_type] then
					local general_character = current_mf:general_character()
					
					if general_character:has_region() then
						local current_mf_general_cqi = general_character:family_member():command_queue_index()
						
						-- check if this general has already been selected by the same issuer
						if not used_general_targets[selected_issuing_faction_name .. current_mf_general_cqi] then
							table.insert(valid_generals, current_mf_general_cqi)
						end
					end
				end
			end
			
			local closest_distance = 500000
			local chosen_general_cqi = false
			
			for j = 1, #valid_generals do
				local current_general_fm = cm:get_family_member_by_cqi(valid_generals[j])
				
				if current_general_fm then
					local current_general = current_general_fm:character()
					
					if not current_general:is_null_interface() then
						local distance = distance_squared(current_general:logical_position_x(), current_general:logical_position_y(), faction_pos_x, faction_pos_y)
						
						if distance < closest_distance then
							chosen_general_cqi = valid_generals[j]
							closest_distance = distance
						end
					end
				end
			end
			
			if chosen_general_cqi then
				used_general_targets[selected_issuing_faction_name .. chosen_general_cqi] = true
				
				obj_str = "family_member " .. chosen_general_cqi

				mission_distance = closest_distance
			end
		else
			-- get the closest region to the player, ensuring the same region is not used by the same issuer more than once
			local closest_distance = 500000
			local region_list = selected_enemy:region_list()
			local chosen_region_key = ""
			
			for j = 0, region_list:num_items() - 1 do
				local current_region = region_list:item_at(j)
				local current_region_key = current_region:name()
				local current_settlement = current_region:settlement()
				
				if not used_region_targets[selected_issuing_faction_name .. current_region_key] then
					local distance = distance_squared(current_settlement:logical_position_x(), current_settlement:logical_position_y(), faction_pos_x, faction_pos_y)
					
					if distance < closest_distance then
						chosen_region_key = current_region_key
						closest_distance = distance
					end
				end
			end
			
			if chosen_region_key ~= "" then
				used_region_targets[selected_issuing_faction_name .. chosen_region_key] = true
				
				obj_str = "region " .. chosen_region_key
				
				if selected_mission[1] == "RAZE_OR_SACK_N_DIFFERENT_SETTLEMENTS_INCLUDING" then
					obj_str = obj_str .. ";total 1"
				end

				mission_distance = closest_distance
			end
		end
		
		if obj_str then
			local mod = 1 + (faction:bonus_values():scripted_value("contracts_treasury_payload_modifier", "value") / 100)
			
			local money = math.max(math.floor(selected_issuing_faction:treasury() / 5), 1500) * mod
			
			local culture = self.culture_mapping[selected_enemy:culture()] or "gen"
			
			local payload = "money " .. money .. ";" ..
							"diplomacy_change{" ..
								"target_faction " .. selected_issuing_faction_name .. ";" ..
								"attitude_adjustement 6;" ..
							"}"
			
			-- add bonus payloads
			local random_payload = cm:random_number(3)
			
			if random_payload == 1 then
				payload = payload .. "effect_bundle {bundle_key wh3_main_bundle_ogre_contract_camp_growth;turns 5;}"
			elseif random_payload == 2 then
				local ancillary_key = get_random_ancillary_key_for_faction(faction_key, nil, "rare")
				
				if ancillary_key then
					payload = payload .. "add_ancillary_to_faction_pool {ancillary_key " .. ancillary_key .. ";}"
				end
			else
				-- find the army with the lowest level of meat
				local mf_list = faction:military_force_list()
				local selected_mf = false
				local selected_mf_meat_value = 500
				
				for j = 0, mf_list:num_items() - 1 do
					local current_mf = mf_list:item_at(j)
					
					if current_mf:has_general() and current_mf:force_type():key() ~= "OGRE_CAMP" and not current_mf:is_armed_citizenry() then
						local current_mf_meat = current_mf:pooled_resource_manager():resource("wh3_main_ogr_meat")
						
						if not current_mf_meat:is_null_interface() then
							local current_mf_meat_value = current_mf_meat:value()
							
							if current_mf_meat_value < selected_mf_meat_value then
								selected_mf_meat_value = current_mf_meat_value
								selected_mf = current_mf
							end
						end
					end
				end
				
				if selected_mf then
					payload = payload .. "military_force_pooled_resource_transaction{general_lookup " .. cm:char_lookup_str(selected_mf:general_character():command_queue_index()) .. ";resource wh3_main_ogr_meat;factor events;amount 25;context absolute;}"
				end
			end

			cm:trigger_custom_mission_from_string(
				faction_key,
				--selected_issuing_faction,
				"mission{" ..
					"key " .. selected_mission[2] .. "_" .. culture .. "; " ..
					"issuer CLAN_ELDERS;" ..
					"turn_limit " .. math.max(math.min(math.round(mission_distance / 1000) * 2, 30), 10) .. ";" ..
					"primary_objectives_and_payload{" ..
						"objective{" ..
							"type " .. selected_mission[1] .. ";" .. obj_str .. ";" ..
						"}" ..
						"payload{" ..
							payload ..
						"}" ..
					"}" ..
				"}"
			)
		end
	end
end