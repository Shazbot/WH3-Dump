--The entire Fervour mechanic applies only for Immortal Empires, the factions are not present in Realms of Chaos
fervour_culture_modifier_values = {
    medium = 1.1,
    high = 1.2,
}

fervour = {
	middenland_faction = "wh_main_emp_middenland",
	high_altar_initiative_set = "wh3_dlc29_middenland_the_great_temple_of_ulric_high_altar_of_ulric",
	high_altar_level_3_key = "wh3_dlc29_emp_middenland_the_great_temple_of_ulric_high_altar_of_ulric_level_3",
	high_altar_level_4_key = "wh3_dlc29_emp_middenland_the_great_temple_of_ulric_high_altar_of_ulric_level_4",
	high_altar_level_3_multiplier = 1.1,
	high_altar_level_4_multiplier = 1.2,

	cultures = {
		empire = "wh_main_emp_empire",
		rogue = "wh2_main_rogue",
	},
	
	factors = {
		army_prefix = "wh3_dlc29_emp_rivalry_points_enemy_armies_",
		settlement_prefix = "wh3_dlc29_emp_rivalry_points_enemy_settlements_",
		empire_settlement = "historical_empire",
		faction_actions_vs_empire = "faction_actions_vs_empire",
		acts_of_aggression = "acts_of_aggression",
		rivalry_trespass = "trespassing",
		rivalry_raiding = "raiding",
		settled = "enemy_fervour_settled",
		hero_actions = "hero_actions",
		broken_treaty = "negative_diplomacy",
		war_declaration = "negative_diplomacy",
		positive_diplomacy = "positive_diplomacy",
		peace = "positive_diplomacy",
		fervour_settled ="wh3_dlc29_emp_fervour_settled" -- faction pooled resource
	},
	
	empire_region_group = "wh3_dlc25_imperial_authority_regions_main_warhammer",
	empire_elector_capital_group = "elector_region_capitals",
	
	values = {
		trespassing = 10,
		raiding = 25,
		hero_actions = {
			success = 50,
			failure = 20
		},
		broken_treaty = 50,
		war_declaration = 100,
		positive_diplomacy = -20,
		peace = -60,
		army_casualties_per_1000_cp_value = 2,

		new_army = 20,

		-- occupation
		occupation_per_tier = 40, -- per tier of the settlement
		sack_per_tier = 20, -- per tier of the settlement
		razed_per_tier = 60, -- per tier of the settlement

		-- added ontop of the base occupation value
		empire_settlement = {
			capital = 150,
			region = 100,
		},

		spread_dividing_value = 10, --percentage
	},
	
	empire_regions = {}, --generated at new campaign from a region list in DaVE
	empire_elector_capitals = {}, --generated at new campaign from a region list in DaVE
	
	starting_enemy_rivalry = {
		["wh_dlc03_grn_black_pit"] = 100,
		["wh2_main_skv_clan_gnaw"] = 75,
		["wh3_dlc20_chs_festus"] = 150,
		["wh2_dlc11_vmp_the_barrow_legion"] = 75,
		["wh2_dlc15_grn_broken_axe"] = 100,
		["wh2_dlc15_grn_bonerattlaz"] = 100
	},

	resources = {
		rivalry_army = "wh3_dlc29_emp_fervour_rivalry_enemy_armies",
		rivalry_settlement = "wh3_dlc29_emp_fervour_rivalry_enemy_settlements",
		fervour_faction = "wh3_dlc29_emp_fervour",
	},
	fervour_culture_modifiers = {
		wh2_dlc09_tmb_tomb_kings = fervour_culture_modifier_values.medium,
		wh2_dlc11_cst_vampire_coast =  fervour_culture_modifier_values.medium,
		wh_main_vmp_vampire_counts = fervour_culture_modifier_values.medium,
		wh3_main_dae_daemons = fervour_culture_modifier_values.high,
		wh3_main_kho_khorne = fervour_culture_modifier_values.high,
		wh3_main_nur_nurgle = fervour_culture_modifier_values.high,
		wh3_main_sla_slaanesh = fervour_culture_modifier_values.high,
		wh3_main_tze_tzeentch = fervour_culture_modifier_values.high,
		wh_main_chs_chaos = fervour_culture_modifier_values.high,
		wh_dlc08_nor_norsca = fervour_culture_modifier_values.high,
		wh_dlc03_bst_beastmen = fervour_culture_modifier_values.high,
		wh2_main_skv_skaven = fervour_culture_modifier_values.medium,
		wh3_dlc23_chd_chaos_dwarfs = fervour_culture_modifier_values.high,
		wh_main_grn_greenskins = fervour_culture_modifier_values.medium,
		wh2_main_def_dark_elves = fervour_culture_modifier_values.medium,
		wh2_main_hef_high_elves = fervour_culture_modifier_values.medium,
		wh_dlc05_wef_wood_elves = fervour_culture_modifier_values.medium
	},

	turn_start_rivalry = 2,

	pending_battle = {
		attackers = {},
		defenders = {},
		region = {}
	},
	siege_settlement_level = 1,

}

function fervour:initialise()
	--need to create unique tables before setup 
	local world = cm:model():world()
	local empire_region_list = world:lookup_regions_from_region_group(self.empire_region_group)
	local empire_elector_capitals = world:lookup_regions_from_region_group(self.empire_elector_capital_group)
	self.empire_regions = unique_table:region_list_to_unique_table(empire_region_list):to_table()
	self.empire_elector_capitals = unique_table:region_list_to_unique_table(empire_elector_capitals):to_table()

	if cm:is_new_game() then
		self:setup()
	end
	self:rivalry_to_fervour()
	self:track_trespass_raiding()
	self:track_agent_actions()
	self:track_diplomacy()

	--self:debug_total_fervour()
end

function fervour:setup()
	out("#### Adding Starting Fervour ####");

	-- assign starting Fervour to enemy factions
	for faction_key, value in dpairs(self.starting_enemy_rivalry) do
		local faction = cm:get_faction(faction_key)
		self:assign_rivalry(faction, self.factors.faction_actions_vs_empire, value, false)
	end

	--Add Fervour to all Empire regions owned by non-Empire factions
	for i = 1, #self.empire_regions do
		local region_key = self.empire_regions[i]
		local region = cm:get_region(region_key)
		self:assign_rivalry(region, self.factors.empire_settlement, self.values.empire_settlement.region, false)
	end

	--Add additional Fervour to all Empire Elector State capitals owned by non-empire factions
	for i = 1, #self.empire_elector_capitals do
		local region_key = self.empire_elector_capitals[i]
		local region = cm:get_region(region_key)
		self:assign_rivalry(region, self.factors.empire_settlement, self.values.empire_settlement.capital, false)
	end
end

function fervour:get_characters_in_faction_regions(faction_interface)
	local character_list = {}
	local region_list = faction_interface:region_list()

	for i = 0, region_list:num_items() - 1 do
		local region = region_list:item_at(i)
		local region_chars = region:characters_in_region()
		for j = 0, region_chars:num_items() - 1 do
			local char = region_chars:item_at(j)

			if char:has_military_force() and char:faction():name() ~= faction_interface:name() then
				table.insert(character_list, char)
			end
		end
	end
	
	return character_list
end

function fervour:track_trespass_raiding()
	core:add_listener(
		"RivalryTrespassRaidingTracker",
		"FactionTurnStart",
		function(context)
			local faction = context:faction()
			return faction:culture() == self.cultures.empire
		end,
		function(context)
			local faction = context:faction()
			local char_list = self:get_characters_in_faction_regions(faction)

			for i = 1, #char_list do
				local char = char_list[i]
				local char_faction = char:faction()
				
				if char_faction:culture() ~= self.cultures.empire then
					local mf = char:military_force()
					local stance = mf:active_stance()

					if stance == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID" or stance == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_SET_CAMP_RAIDING" then
						self:assign_rivalry(mf, self.factors.rivalry_raiding, self.values.raiding, true)
					elseif faction:military_access_pact_with(char_faction) == false then
						self:assign_rivalry(mf, self.factors.rivalry_trespass, self.values.trespassing, false)
					end
				end
			end
		end,
		true
	)
end

function fervour:spread_rivalry_between_armies(faction, value, factor)
	local mf_list = faction:military_force_list(true) -- skip garrisons
	if mf_list:num_items() == 0 then
		return
	end
	local amount = value / mf_list:num_items()
	for i = 0, mf_list:num_items() - 1 do
		local current_force = mf_list:item_at(i)
		self:assign_rivalry(current_force, factor, amount, false)
	end
end

function fervour:assign_rivalry_to_leader_army(faction, value, factor)
	local mf = faction:faction_leader():has_military_force() and faction:faction_leader():military_force() or nil
	if mf then
		self:assign_rivalry(mf, factor, value, false)
	else
		self:spread_rivalry_between_armies(faction, value, factor)
	end
end

function fervour:track_diplomacy()
	core:add_listener(
		"RivalryNegativeDiplomacy",
		"NegativeDiplomaticEvent",
		function(context)
			return context:recipient():culture() == self.cultures.empire and context:proposer():culture() ~= self.cultures.empire
			-- only trigger rivalry if the Empire faction was the recipient not the proposer
		end,
		
		function(context)
			local faction = context:proposer()
			local rivalry_type

			if context:is_war() then
				rivalry_type = "war_declaration"
			else
				rivalry_type = "broken_treaty"
			end

			self:assign_rivalry_to_leader_army(faction, self.values[rivalry_type], self.factors[rivalry_type])
		end,
		true
	)

	core:add_listener(
		"RivalryPositiveDiplomacy",
		"PositiveDiplomaticEvent",
		function(context)
			local proposer_culture = context:proposer():culture()
			local recipient_culture = context:recipient():culture()

			return (context:is_state_gift()== false) and ((proposer_culture == self.cultures.empire and recipient_culture ~= self.cultures.empire) or (recipient_culture == self.cultures.empire and proposer_culture ~= self.cultures.empire))
				-- remove Rivalry for positive events when Empire is either proposer or recipient
		end,

		function(context)
			local proposer = context:proposer()
			local recipient = context:recipient()
			local faction
			local rivalry_type

			if proposer:culture() == self.cultures.empire then
				faction = recipient
			else
				faction = proposer
			end

			if context:is_peace_treaty() then
				rivalry_type = "peace"
			else
				rivalry_type = "positive_diplomacy"
			end

			self:assign_rivalry_to_leader_army(faction, self.values[rivalry_type], self.factors[rivalry_type])
		end,
		true
	)
end

function fervour:track_agent_actions()
	
	local grant_rivalry_for_agent_actions = function(context)
		local faction = context:character():faction()
		local value
			
		if context:mission_result_critial_success() or context:mission_result_success() then
			value = self.values.hero_actions.success
		else
			value = self.values.hero_actions.failure
		end

		self:assign_rivalry_to_leader_army(faction, value, self.factors.hero_actions)
	end
	
	core:add_listener(
		"RivalryCharacterAgentAction",
		"CharacterCharacterTargetAction",
		function(context)
			return context:target_character():faction():culture() == self.cultures.empire and context:character():faction():culture() ~= self.cultures.empire
		end,
		function(context)
			grant_rivalry_for_agent_actions(context)
		end,
		true
	)

	core:add_listener(
		"RivalryRegionAgentAction",
		"CharacterGarrisonTargetAction", 
		function(context)
			return context:garrison_residence():faction():culture() == self.cultures.empire and context:character():faction():culture() ~= self.cultures.empire
		end,
		function(context)
			grant_rivalry_for_agent_actions(context)
		end,
		true
	)
end

function fervour:assign_rivalry(target_interface, factor, value, spread)
	local process_rivalry_for_interface = function(target_interface, factor)
  		cm:entity_add_pooled_resource_transaction(target_interface, factor, value)
	end
	local faction
	
	if is_region(target_interface) then
		faction = target_interface:owning_faction()
		factor = self.factors.settlement_prefix..factor
	elseif is_militaryforce(target_interface) then
		faction = target_interface:faction()
		factor = self.factors.army_prefix..factor
	else
		faction = target_interface
	end
	
	local culture = faction:culture() -- don't add Rivalry to Empire culture
	if culture == self.cultures.empire or culture == self.cultures.rogue or faction:is_rebel() then
		return
	end
	
	if not is_faction(target_interface) then
		process_rivalry_for_interface(target_interface, factor)
	else
		faction = target_interface
		local mf_list = faction:military_force_list(true) -- skip garrisons
		local region_list = faction:region_list()

		for i = 0, mf_list:num_items() - 1 do
			local force = mf_list:item_at(i)
			process_rivalry_for_interface(force, self.factors.army_prefix..factor)
		end

		for i = 0, region_list:num_items() - 1 do
			process_rivalry_for_interface(region_list:item_at(i),self.factors.settlement_prefix..factor)
		end
	end

	if spread then
		local mf_list = faction:military_force_list(true) -- skip garrisons
		local region_list = faction:region_list()
		local spread_value = math.floor(value / self.values.spread_dividing_value)
		for i = 0, mf_list:num_items() - 1 do
			if mf_list:item_at(i) ~= target_interface then
				self:assign_rivalry(mf_list:item_at(i), self.factors.faction_actions_vs_empire, spread_value, false)
			end
		end

		for i = 0, region_list:num_items() - 1 do
			if region_list:item_at(i) ~= target_interface then
				self:assign_rivalry(region_list:item_at(i), self.factors.faction_actions_vs_empire, spread_value, false)
			end
		end
	end

end

function fervour:cache_pre_battle_data()
	local pb = cm:model():pending_battle()
	if not pb:is_null_interface() then
		local attacker = pb:attacker()
		local attacker_mf = attacker:military_force()
		local attacker_rivalry = attacker_mf:pooled_resource_manager():resource(self.resources.rivalry_army)
		local defender = pb:defender()
		local defender_faction = defender:faction()
		local defender_mf = defender:military_force()
		local defender_rivalry = defender_mf:pooled_resource_manager():resource(self.resources.rivalry_army)
		local secondary_attackers = pb:secondary_attackers()
		local secondary_defenders = pb:secondary_defenders()
		local siege = pb:siege_battle()

		-- reset the pending battle table
		self.pending_battle = {
			attackers = {},
			defenders = {},
			region = {}
		}
		
		-- Cache the CQI and rivalry values of all parties involved in the battle in-case they are killed later
		if not attacker_rivalry:is_null_interface() then
			table.insert(self.pending_battle.attackers, {mf_cqi = attacker_mf:command_queue_index(), rivalry = attacker_rivalry:value()})
		end
		
		if not defender_rivalry:is_null_interface() then
			table.insert(self.pending_battle.defenders, {mf_cqi = defender_mf:command_queue_index(), rivalry = defender_rivalry:value()})
		end
		
		for i = 0, secondary_attackers:num_items() - 1 do
			local attacker = secondary_attackers:item_at(i)
			local attacker_mf = attacker:military_force()
			local attacker_rivalry = attacker_mf:pooled_resource_manager():resource(self.resources.rivalry_army)

			if not attacker_rivalry:is_null_interface() then
				table.insert(self.pending_battle.attackers, {mf_cqi = attacker_mf:command_queue_index(), rivalry = attacker_rivalry:value()})
			end
		end
		
		for i = 0, secondary_defenders:num_items() - 1 do
			local defender = secondary_defenders:item_at(i)
			local defender_mf = defender:military_force()
			local defender_rivalry = defender_mf:pooled_resource_manager():resource(self.resources.rivalry_army)

			if not defender_rivalry:is_null_interface() then
				table.insert(self.pending_battle.defenders, {mf_cqi = defender_mf:command_queue_index(), rivalry = defender_rivalry:value()})
			end
		end

		if siege and defender:faction():culture() ~= self.cultures.empire and defender_mf:force_type():key() ~= "OGRE_CAMP" and defender_faction:is_rebel() == false then
			local region = pb:region_data():region()
			local resource = region:pooled_resource_manager():resource(self.resources.rivalry_settlement)

			if not resource:is_null_interface() then
				self.pending_battle.region = {region_name = region:name(), rivalry = resource:value()}
			end
		end
	end
end

function fervour:empire_attacker_or_defender(pending_battle) --In the future we can change this to detecting only Boris involvement, depending on pending design decision
	local empire_attacker = false
	local empire_defender = false
	local attacker = pending_battle:attacker()
	local defender = pending_battle:defender()
	local secondary_attackers = pending_battle:secondary_attackers()
	local secondary_defenders = pending_battle:secondary_defenders()

	if attacker:faction():culture() == self.cultures.empire then
		empire_attacker = true
	end

	if defender:faction():culture() == self.cultures.empire then
		empire_defender = true
	end

	for i = 0, secondary_attackers:num_items() - 1 do
		local attacker = secondary_attackers:item_at(i)

		if attacker:faction():culture() == self.cultures.empire then
			empire_attacker = true
		end
	end

	for i = 0, secondary_defenders:num_items() - 1 do
		local defender = secondary_defenders:item_at(i)

		if defender:faction():culture() == self.cultures.empire then
			empire_defender = true
		end
	end
	return empire_attacker, empire_defender
end

function fervour:can_use_fervour(faction_name)
	if (faction_name == self.middenland_faction) then
		return true
	else
		return false
	end
end

function fervour:rivalry_to_fervour()
	core:add_listener(
		"RivalryBattlePending",
        "PendingBattle",
        function(context)
			local empire_attacker, empire_defender = self:empire_attacker_or_defender(context:pending_battle())
			return empire_attacker or empire_defender
        end,
        function(context)
			-- cache armies Rivalry values before battles begin in-case they die during the battle.
			self:cache_pre_battle_data()
        end,
        true
	)

	core:add_listener(
		"SettleRivalryToFervour",
		"BattleConflictFinished",
		function()
			local pb = cm:model():pending_battle()
			return pb:has_been_fought() and (cm:pending_battle_cache_culture_is_defender(self.cultures.empire) and pb:defender_won()) or (cm:pending_battle_cache_culture_is_attacker(self.cultures.empire) and pb:attacker_won())
		end,
		function()
			pb = cm:model():pending_battle()
			local empire_winnners = {}
			local losers = {}
			local rivalry = 0

			if cm:pending_battle_cache_faction_is_defender(self.middenland_faction) and pb:defender_won() then
				for i = 1, cm:pending_battle_cache_num_defenders() do
					local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_defender(i)
					local faction = cm:get_faction(faction_name)

					if faction:culture() == self.cultures.empire and faction:can_be_human() then
						table.insert(empire_winnners, {char_cqi = char_cqi, mf_cqi = mf_cqi, faction_name = faction_name})
					end

					losers = self.pending_battle.attackers
				end
			elseif cm:pending_battle_cache_faction_is_attacker(self.middenland_faction) and pb:attacker_won() then	
				for i = 1, cm:pending_battle_cache_num_attackers() do
					local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_attacker(i)
					local faction = cm:get_faction(faction_name)

					if faction:culture() == self.cultures.empire and faction:can_be_human() then
						table.insert(empire_winnners, {char_cqi = char_cqi, mf_cqi = mf_cqi, faction_name = faction_name})
					end

					losers = self.pending_battle.defenders
				end
			end
			
			if #empire_winnners > 0 then
				for _, loser in ipairs(losers) do
					local mf = cm:get_military_force_by_cqi(loser.mf_cqi)
					
					if mf and not mf:is_null_interface() then
						local faction = mf:faction()

						if faction:is_rebel() == false then
							local value = mf:pooled_resource_manager():resource(self.resources.rivalry_army):value() or loser.rivalry
							rivalry = rivalry + value
							self:assign_rivalry(mf, self.factors.settled, -value, false) --clear rivalry from losers
						end
					else
						-- mf was wiped out, just cache the pending battle saved rivalry
						rivalry = rivalry + loser.rivalry
					end
				end
				local resource_given = false
				for _, winner in ipairs(empire_winnners) do
					local value = rivalry
					local faction_name = winner.faction_name
					local cqi = winner.cqi
					local mf_cqi = winner.mf_cqi

					if fervour:can_use_fervour(faction_name) then
						if not resource_given then
							cm:faction_add_post_battle_looted_resource(faction_name, self.resources.fervour_faction, self.factors.fervour_settled, "FACTION", value)
							resource_given = true
						end
						local faction = cm:get_faction(fervour.middenland_faction)
					end
				end
			end
		end,
		true
	)

	core:add_listener(
		"FervourEmpireBesiegeLevelCheck",
		"CharacterBesiegesSettlement",
		true,
		function(context)
			local settlement_level = context:region():settlement():primary_slot():building():building_level()
			self.siege_settlement_level = settlement_level
		end,
		true
	)

	core:add_listener(
		"FervourEnemySettlementOccupied",
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			return context:character():faction():culture() ~= self.cultures.empire
		end,
		function(context)
			local type = context:occupation_decision_type()
			local fervour_type = false
			local occupied = false
			local sack = false
			local raze = false

			if type == "occupation_decision_sack" then
				fervour_type = "sack_per_tier"
				sack = true
			elseif type == "occupation_decision_raze_without_occupy" then
				fervour_type = "razed_per_tier"
				raze = true
			elseif type == "occupation_decision_occupy" or type == "occupation_decision_gift_to_another_faction" or "occupation_decision_resettle" or type == "occupation_decision_loot" or type == "occupation_decision_colonise" then
				fervour_type = "occupation_per_tier"
				occupied = true
			end

			if occupied or sack or raze then
				local mf = context:character():military_force()
				local region = context:garrison_residence():region()

				if raze or occupied then
					-- remove any fervour that are currently on the region
					local fervour = region:pooled_resource_manager():resource(self.resources.rivalry_settlement)
					if not fervour:is_null_interface() then
						local factors = fervour:factors()

						for i = 0, factors:num_items() - 1 do
							local factor = factors:item_at(i)
							self:assign_rivalry(region, factor:key(), -factor:value(), false)
						end
					end
				end

				if context:previous_owner_culture() == self.cultures.empire then
					local value = self.values[fervour_type] * self.siege_settlement_level * self:high_altar_multiplier()
					self:assign_rivalry(mf, self.factors.acts_of_aggression, value, true)
				end

				if occupied then
					for _, region_key in ipairs(self.empire_regions) do
						if region:name() == region_key then
							self:assign_rivalry(region, self.factors.empire_settlement, self.values.empire_settlement.region, false)
						end
					end
					for _, region_key in ipairs(self.empire_elector_capitals) do
						if region:name() == region_key then
							self:assign_rivalry(region, self.factors.empire_settlement, self.values.empire_settlement.capital, false)
						end
					end
				end
			end
		end,
		true
	)

	core:add_listener(
		"FervourEmpireArmyLosses",
		"BattleCompleted",
		function()
			return cm:pending_battle_cache_culture_is_defender(self.cultures.empire) or cm:pending_battle_cache_culture_is_attacker(self.cultures.empire)
		end,
		function()
			local pb = cm:model():pending_battle()
			local is_attacker_culture_empire = cm:pending_battle_cache_culture_is_attacker(self.cultures.empire)
			local is_defender_culture_empire = cm:pending_battle_cache_culture_is_defender(self.cultures.empire)

			if is_attacker_culture_empire and not is_defender_culture_empire and pb:defender_won() then
				self:assign_rivalry_to_winner(pb:defender_ending_cp_kill_score(), pb:defender())
			elseif is_defender_culture_empire and not is_attacker_culture_empire and pb:attacker_won() then
				self:assign_rivalry_to_winner(pb:attacker_ending_cp_kill_score(), pb:attacker())
			end
		end,
		true
	)

	--Adding additional Fervour for nearly recruited armies of Enemies of Middenland, this way all enemies provide some Fervour
	core:add_listener(
		"FervourEnemyRecruited",
		"CharacterCreated",
		function(context)
			local character = context:character()
			local faction = character:faction()
			if faction:is_rebel() then
				return false
			end
			local war_list = faction:factions_at_war_with()

			if faction:culture() ~= self.cultures.empire and war_list:is_empty() == false and character:has_military_force() == true then
				local is_at_war_with_middenland = false
				for i = 0, war_list:num_items() - 1 do
					local at_war_with_faction = war_list:item_at(i)
					if at_war_with_faction:name() == self.middenland_faction then
						return true
					end
				end
			end

			return false	
		end,
		function(context)
			self:assign_rivalry(context:character():military_force(), self.factors.faction_actions_vs_empire, self.values.new_army, false)
		end,
		true
	)

end

function fervour:assign_rivalry_to_winner(winner_ending_cp_kill_score, winner_character)
	if winner_character == nil or winner_character:is_null_interface() then
		return
	end

	if not winner_character:has_military_force() then
		return
	end

	if winner_character:military_force():is_set_piece_battle_army() then 
		return
	end

	local losses = winner_ending_cp_kill_score / 1000
	local culture_modifier = self:culture_income_multiplier(winner_character:faction():culture())
	local fervour = math.floor(losses * culture_modifier * self:high_altar_multiplier())

	self:assign_rivalry(winner_character:military_force(), self.factors.acts_of_aggression, fervour, true)
end

function fervour:culture_income_multiplier(faction_culture)
    local culture_modifier = self.fervour_culture_modifiers[faction_culture]
    return culture_modifier or 1
end

function fervour:high_altar_multiplier()
	local faction = cm:get_faction(self.middenland_faction)
	local high_altar_initiative_set = faction:lookup_faction_initiative_set_by_key(self.high_altar_initiative_set)

	if high_altar_initiative_set:initiative_status_by_key(self.high_altar_level_4_key):is_active() then
		return self.high_altar_level_4_multiplier
	elseif high_altar_initiative_set:initiative_status_by_key(self.high_altar_level_3_key):is_active() then
		return self.high_altar_level_3_multiplier
	else
		return 1
	end
end

--Loops through all armies and settlements to get total amount of Fervour in the world (used only for balancing info)
function fervour:debug_total_fervour()
	
	core:add_listener(
		"Fervour_DebugtotalFervour",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == self.middenland_faction 
		end,
		function(context)
			local total_fervour_settlement = 0
			local total_fervour_armies = 0
			local all_factions = cm:get_faction_list()

			for i = 0, all_factions:num_items() - 1 do
				local faction = all_factions:item_at(i)
				if faction:is_dead() == false and (faction:has_home_region() == true or faction:military_force_list():is_empty() == false) then
					--Loop through all military forces and get total Fervour factors
					local mf_list = faction:military_force_list(true) -- skip garrisons
					for i = 0, mf_list:num_items() - 1 do
						local mf = mf_list:item_at(i)
						if mf and not mf:is_null_interface() then
							local mf_fervour = mf:pooled_resource_manager():resource(self.resources.rivalry_army)
							if not mf_fervour:is_null_interface() then
								total_fervour_armies = total_fervour_armies + mf_fervour:value()
							end
						end
					end

					--Loop through all regions and get total Fervour factors
					local region_list = faction:region_list()
					for i = 0, region_list:num_items() - 1 do
						local region = region_list:item_at(i)
						local region_fervour = region:pooled_resource_manager():resource(self.resources.rivalry_settlement)
						if not region_fervour:is_null_interface() then
							total_fervour_settlement = total_fervour_settlement + region_fervour:value()
						end
					end
				end
			end

			local total_fervour_combined = total_fervour_armies + total_fervour_settlement
			out.design("\n\nTOTAL FERVOUR:\n\tArmies: " .. total_fervour_armies .. "\n\tSettlements: ".. total_fervour_settlement .. "\n\tCombined: " .. total_fervour_combined)

		end,
		true
	)
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("fervour.pending_battle", fervour.pending_battle, context)
		cm:save_named_value("fervour.siege_settlement_level", fervour.siege_settlement_level, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			fervour.pending_battle = cm:load_named_value("fervour.pending_battle", fervour.pending_battle, context)
			fervour.siege_settlement_level = cm:load_named_value("fervour.siege_settlement_level", fervour.siege_settlement_level, context)
		end
	end
)