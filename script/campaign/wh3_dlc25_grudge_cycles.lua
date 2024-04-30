grudge_modifiers = {
	standard = 1,
	high = 1.15,
	ultra = 1.3
}

grudge_cycle = {
	cycle_time = 10, -- turns
	faction_times = {},

	minimum_world_grudges = 5000,
	minimum_world_grudges_met = true,
	target_grudge_value = {},
	target_grudge_base = 2000,
	target_grudge_percentage = 35,
	cycle_grudges = {},
	previous_reward_modifiers = {
		[0] = 20, -- if previous level is 0 it means they delayed. This value should match the modifier we state in delay dilemma
		[1] = -20,
		[2] = -10,
		[3] = 0,
		[4] = 10,
		[5] = 20
	},

	delayed_factions = {},
	faction_levels = {},

	ranges = {
		{min = 0, max = 24},
		{min = 25, max = 49},
		{min = 50, max = 74},
		{min = 75, max = 99},
		{min = 100, max = 100}
	},

	starting_grudges = {
		["main_warhammer"] = {
			["wh3_main_nur_maggoth_kin"] = 200,
			["wh_dlc08_nor_goromadny_tribe"] = 150,
			["wh_main_nor_aesling"] = 150,
			["wh2_main_skv_clan_moulder"] = 275,
			["wh2_main_grn_arachnos"] = 50,
			["wh_main_vmp_vampire_counts"] = 150,
			["wh3_main_kho_exiles_of_khorne"] = 200,
			["wh2_main_skv_clan_septik"] = 200,
			["wh2_main_def_naggarond"] = 300,
			["wh2_dlc17_bst_taurox"] = 150,
			["wh3_dlc20_chs_valkia"] = 150,
			["wh_main_vmp_schwartzhafen"] = 200,
			["wh_main_vmp_rival_sylvanian_vamps"] = 125,
			["wh2_main_skv_clan_skryre"] = 275,
			["wh3_main_ogr_disciples_of_the_maw"] = 100
		},
		["wh3_main_chaos"] = {
			["wh_dlc08_nor_goromadny_tribe"] = 150,
			["wh_main_nor_aesling"] = 150,
			["wh_main_nor_baersonling"] = 150,
			["wh2_main_skv_clan_moulder"] = 275
		}
	},

	incident_prefix = "wh3_dlc25_incident_grudge_cycle_",
	no_grudge_incident = "wh3_dlc25_incident_grudge_cycle_not_enough_grudges",
	delay_dilemma = "wh3_dlc25_dwf_grudge_cycle_optional_delay",

	settler_units = {
		[1] = {},
		[2] = {
			"wh_main_dwf_inf_quarrellers_1_grudge_reward", 
			"wh_main_dwf_inf_slayers_grudge_reward"
		},
		[3] = {
			"wh_main_dwf_inf_quarrellers_1_grudge_reward", 
			"wh_main_dwf_inf_slayers_grudge_reward",
			"wh3_dlc25_dwf_art_grudge_thrower_grudge_reward",
			"wh_main_dwf_inf_longbeards_1_grudge_reward"
		},
		[4] = {
			"wh_main_dwf_inf_quarrellers_1_grudge_reward", 
			"wh_main_dwf_inf_slayers_grudge_reward",
			"wh3_dlc25_dwf_art_grudge_thrower_grudge_reward",
			"wh_main_dwf_inf_longbeards_1_grudge_reward",
			"wh_main_dwf_inf_irondrakes_0_grudge_reward",
			"wh_main_dwf_inf_hammerers_grudge_reward"
		},
		[5] = {
			"wh_main_dwf_inf_quarrellers_1_grudge_reward", 
			"wh_main_dwf_inf_slayers_grudge_reward",
			"wh3_dlc25_dwf_art_grudge_thrower_grudge_reward",
			"wh_main_dwf_inf_longbeards_1_grudge_reward",
			"wh_main_dwf_inf_irondrakes_0_grudge_reward",
			"wh_main_dwf_inf_hammerers_grudge_reward",
			"wh_main_dwf_veh_gyrocopter_1_grudge_reward",
			"wh_main_dwf_art_flame_cannon_grudge_reward"
		}
	},

	cultures = {
		dwarf = "wh_main_dwf_dwarfs",
		empire = "wh_main_emp_empire",
		bretonnia = "wh_main_brt_bretonnia",
		cathay = "wh3_main_cth_cathay",
		kislev = "wh3_main_ksl_kislev",
		lizardmen = "wh2_main_lzd_lizardmen",
		chaos_dwarf = "wh3_dlc23_chd_chaos_dwarfs",
		skaven = "wh2_main_skv_skaven",
		ogres = "wh3_main_ogr_ogre_kingdoms",
		greenskins = "wh_main_grn_greenskins",
		rogue = "wh2_main_rogue",
		elves = {
			["wh2_main_def_dark_elves"] = true,
			["wh2_main_hef_high_elves"] = true,
			["wh_dlc05_wef_wood_elves"] = true
		},
		doc_cultures = {
			["wh3_main_nur_nurgle"] = true,
			["wh3_main_sla_slaanesh"] = true,
			["wh3_main_kho_khorne"] = true,
			["wh3_main_tze_tzeentch"] = true,
			["wh3_main_dae_daemons"] = true
		},
		moc_cultures = {
			["wh_dlc08_nor_norsca"] = true,
			["wh_main_chs_chaos"] = true,
			["wh_dlc03_bst_beastmen"] = true
		},
		undead = {
			["wh2_dlc09_tmb_tomb_kings"] = true,
			["wh2_dlc11_cst_vampire_coast"] = true,
			["wh_main_vmp_vampire_counts"] = true
		}
	},

	grudge_army_size = {
		base = 14,
		bonus_value = "dwf_grudge_settler_army_unit_count"
	},
	grudge_armies = {},

	pending_battle = {
		attackers = {},
		defenders = {},
		region = {}
	},
	siege_settlement_level = 1,
	
	reward_prefix = "wh3_dlc25_grudge_cycle_",

	resources = {
		grudge_army = "wh3_dlc25_dwf_grudge_points_enemy_armies",
		grudge_settlement = "wh3_dlc25_dwf_grudge_points_enemy_settlements",
		settled_grudges = "wh3_dlc25_dwf_grudge_points",
		cycle_percent = "wh3_dlc25_dwf_grudge_cycle_tracker"
	},
	values = {
		-- Enemy army actions
		trespass = 20,
		raiding = 45,
		dwarf_attacked = 100, -- settlement or army if a non-dwarf is the attacker, regardless of winner
		hero_actions = {
			-- gets applied faction-wide
			success = 55,
			failure = 15
		},
		-- occupation
		occupation_per_tier = 75, -- per tier of the settlement
		sack_per_tier = 50, -- per tier of the settlement
		razed_per_tier = 100, -- per tier of the settlement`
		historical_settlement = {
			-- added ontop of the base occupation value
			legendary = 500,
			holds = 200,
			other = 50
		},
		-- armies attacked
		army_casualties = 3, -- per 1000 cp kill value
		-- diplomacy
		broken_treaty = 75,
		war_declaration = 150,
		positive_diplomacy = -50,
		peace = -100,
		faction_actions = 15, -- percentage
		culture_actions = 5 -- percentage
	},
	factors = {
		army_prefix = "wh3_dlc25_dwf_grudge_points_enemy_armies_",
		settlement_prefix = "wh3_dlc25_dwf_grudge_points_enemy_settlements_",
		trespass = "trespassing",
		raiding = "raiding",
		dwarf_attacked = "acts_of_aggression",
		hero_actions = "hero_actions",
		occupation_per_tier = "acts_of_aggression",
		sack_per_tier = "acts_of_aggression",
		razed_per_tier = "acts_of_aggression",
		historical_settlement = {
			legendary = "historical_dwarf",
			holds = "historical_dwarf",
			other = "historical_dwarf",
		},
		army_casualties = "acts_of_aggression",
		broken_treaty = "negative_diplomacy",
		war_declaration = "negative_diplomacy",
		positive_diplomacy = "positive_diplomacy",
		peace = "positive_diplomacy",
		settled = "settled",
		faction_actions = "faction_actions",
		culture_actions = {
			["wh_main_emp_empire"] = "empire_actions",
			["wh_main_brt_bretonnia"] = "bretonnia_actions",
			["wh3_main_cth_cathay"] = "cathay_actions",
			["wh3_main_ksl_kislev"] = "kislev_actions",
			["wh2_main_lzd_lizardmen"] = "lizardmen_actions",
			["wh3_dlc23_chd_chaos_dwarfs"] = "chaos_dwarf_actions",
			["wh2_main_def_dark_elves"] = "elf_actions",
			["wh2_main_hef_high_elves"] = "elf_actions",
			["wh_dlc05_wef_wood_elves"] = "elf_actions",
			["wh3_main_nur_nurgle"] = "doc_actions",
			["wh3_main_sla_slaanesh"] = "doc_actions",
			["wh3_main_kho_khorne"] = "doc_actions",
			["wh3_main_tze_tzeentch"] = "doc_actions",
			["wh3_main_dae_daemons"] = "doc_actions",
			["wh_dlc08_nor_norsca"] = "moc_actions",
			["wh_main_chs_chaos"] = "moc_actions",
			["wh_dlc03_bst_beastmen"] = "moc_actions",
			["wh2_dlc09_tmb_tomb_kings"] = "undead_actions",
			["wh2_dlc11_cst_vampire_coast"] = "undead_actions",
			["wh_main_vmp_vampire_counts"] = "undead_actions",
			["wh2_main_skv_skaven"] = "skaven_actions",
			["wh3_main_ogr_ogre_kingdoms"] = "ogre_actions",
			["wh_main_grn_greenskins"] = "greenskin_actions"
		}
	},
	cultural_modifiers = {
		["wh_dlc05_wef_wood_elves"] = grudge_modifiers.high, 
		["wh2_main_hef_high_elves"] = grudge_modifiers.high,
		["wh2_main_def_dark_elves"] = grudge_modifiers.high, 
		["wh_dlc08_nor_norsca"] = grudge_modifiers.high,
		["wh_main_vmp_vampire_counts"] = grudge_modifiers.high, 
		["wh2_dlc11_cst_vampire_coast"] = grudge_modifiers.high, 
		
		["wh_main_grn_greenskins"] = grudge_modifiers.ultra, 
		["wh3_dlc23_chd_chaos_dwarfs"] = grudge_modifiers.ultra, 
		["wh2_main_skv_skaven"] = grudge_modifiers.ultra, 
		["wh_dlc03_bst_beastmen"] = grudge_modifiers.ultra, 
		["wh_main_chs_chaos"] = grudge_modifiers.ultra, 
		["wh3_main_tze_tzeentch"] = grudge_modifiers.ultra, 
		["wh3_main_sla_slaanesh"] = grudge_modifiers.ultra, 
		["wh3_main_nur_nurgle"] = grudge_modifiers.ultra, 
		["wh3_main_kho_khorne"] = grudge_modifiers.ultra, 
		["wh3_main_dae_daemons"] = grudge_modifiers.ultra
	},
	historical_region_prefix = "dwarf_historical_", -- Add campaign key onto the end.
	historical_regions = {
		 -- generated at new campaign from the region list in dave.
		legendary = {},
		holds = {},
		other = {}
	},
	dilemma = {
		key_prefix = "wh3_dlc25_dwf_book_of_grudges_dilemma_faction_incurs_grudge_",
		count = 3,
		option_count = 2,
		cooldown = 10,
		current_cooldown = 4, -- Start the timer at 4 so it can't trigger before turn 5
		grudges = {
			low = {
				min = 50,
				max = 100,
			},
			high = {
				min = 200,
				max = 300
			}
		}
	}
}

function grudge_cycle:initialise()
	if cm:is_new_game() then
		self:setup()
	end

	self:track_trespass()
	self:track_raiding()
	self:track_diplomacy()
	self:track_acts_of_aggression()
	self:track_agent_actions()
	self:settle_grudges()
	self:cycle_timer()
	self:launch_dilemma_when_grudges_low()
	self:delay_cycles()

	if self.cycle_grudges[cm:get_local_faction_name(true)] then
		common.set_context_value("cycle_grudge_value", self.cycle_grudges[cm:get_local_faction_name(true)])
	end

	if self.target_grudge_value[cm:get_local_faction_name(true)] then
		common.set_context_value("cycle_grudge_target", self.target_grudge_value[cm:get_local_faction_name(true)])
	end
end

function grudge_cycle:setup()
	local faction_list = cm:get_factions_by_culture(self.cultures.dwarf)
	local world = cm:model():world()
	local campaign_name = cm:get_campaign_name()
	local starting_grudge_level = 0
	local historical_legendary_region_list = world:lookup_regions_from_region_group(self.historical_region_prefix.."legendary_"..campaign_name)
	local historical_holds_region_list = world:lookup_regions_from_region_group(self.historical_region_prefix.."holds_"..campaign_name)
	local historical_other_region_list = world:lookup_regions_from_region_group(self.historical_region_prefix.."other_"..campaign_name)

	self.historical_regions.legendary = unique_table:region_list_to_unique_table(historical_legendary_region_list):to_table()
	self.historical_regions.holds = unique_table:region_list_to_unique_table(historical_holds_region_list):to_table()
	self.historical_regions.other = unique_table:region_list_to_unique_table(historical_other_region_list):to_table()

	-- Grant starting historical region grudges
	for type, region_list in pairs(self.historical_regions) do
		for _, region_key in ipairs(region_list) do
			local region = cm:get_region(region_key)

			if region:owning_faction():culture() ~= self.cultures.dwarf then
				self:assign_grudges(region, self.factors.historical_settlement[type], self.values.historical_settlement[type], true)
			end
		end
	end

	-- assign starting effect_bundle
	for _, faction in ipairs(faction_list) do
		local faction_name = faction:name()
		if faction:can_be_human() then
			self.cycle_grudges[faction_name] = 0

			cm:apply_effect_bundle(self.reward_prefix..starting_grudge_level, faction_name, self.cycle_time + 1)

			if cm:get_local_faction_name(true) == faction_name then
				common.set_context_value("cycle_grudge_value", self.cycle_grudges[faction_name])
			end
		end
	end


	-- throw starting grudges to various targets
	for faction_key, value in pairs(self.starting_grudges[campaign_name]) do
		local faction = cm:get_faction(faction_key)
		self:assign_grudges(faction, self.factors.faction_actions, value, true)
	end

	for _, faction in ipairs(faction_list) do
		self:set_grudge_target(faction)
	end
end

function grudge_cycle:set_grudge_target(faction, previous_level, value_override)
	local faction_name = faction:name()

	if faction:is_human() then
		local world_grudges = self:get_world_grudges()
		local grudges = self:get_met_grudges(faction)
		local value


		if value_override then
			value = value_override
		elseif world_grudges > self.minimum_world_grudges then
			previous_level = previous_level or 3 -- defaulting to 3 means that no modifiers are applied to the target.

			self.minimum_world_grudges_met = true

			value = math.floor((grudges / 100) * (self.target_grudge_percentage + self.previous_reward_modifiers[previous_level])) + self.target_grudge_base
			value = math.floor(value / 100) * 100

			cm:trigger_incident(faction_name, self.incident_prefix..previous_level, true)
		else
			self.minimum_world_grudges_met = false
			value = 0

			if previous_level ~= nil and previous_level > 0 then
				cm:trigger_incident(faction_name, self.incident_prefix..previous_level, true)
			end

			cm:trigger_incident(faction_name, self.no_grudge_incident, true)
		end

		self.target_grudge_value[faction_name] = value

		out.design("----------------------------")
		out.design(faction_name.." Met Faction Grudges: "..grudges)
		out.design("----------------------------")

		out.design("----------------------------")
		out.design(faction_name.." Grudge Target: "..self.target_grudge_value[faction_name])
		out.design("----------------------------")

		if cm:get_local_faction_name(true) == faction_name then
			common.set_context_value("cycle_grudge_target", self.target_grudge_value[faction_name])
		end
	else
		self.cycle_grudges[faction_name] = 0
		self.target_grudge_value[faction_name] = 0
		cm:apply_effect_bundle(self.reward_prefix..0, faction_name, 0)
	end
end

function grudge_cycle:get_met_grudges(faction)
	local met_grudges = 0
	local faction_list = faction:factions_met()

	for i = 0, faction_list:num_items() - 1 do
		local faction_interface = faction_list:item_at(i)
		local mf_list = faction_interface:military_force_list()
		local region_list = faction_interface:region_list()

		for j = 0, mf_list:num_items() - 1 do
			local mf = mf_list:item_at(j)
			local resource = mf:pooled_resource_manager():resource(self.resources.grudge_army)

			if not resource:is_null_interface() then
				met_grudges = met_grudges + resource:value()
			end
		end

		for i = 0, region_list:num_items() - 1 do
			local region = region_list:item_at(i)
			local resource = region:pooled_resource_manager():resource(self.resources.grudge_settlement)
			
			if not resource:is_null_interface() then
				met_grudges = met_grudges + resource:value()
			end
		end
	end

	return met_grudges
end

function grudge_cycle:get_world_grudges()
	local world_grudges = 0

	local world = cm:model():world()
	local region_list = world:region_manager():region_list()
	local faction_list = world:faction_list()

	for i = 0, region_list:num_items() - 1 do
		local region = region_list:item_at(i)
		local resource = region:pooled_resource_manager():resource(self.resources.grudge_settlement)

		if not resource:is_null_interface() then
			world_grudges = world_grudges + resource:value()
		end
	end

	for i = 0, faction_list:num_items() - 1 do
		local faction = faction_list:item_at(i)
		local mf_list = faction:military_force_list()

		for j = 0, mf_list:num_items() - 1 do
			local mf = mf_list:item_at(j)
			local resource = mf:pooled_resource_manager():resource(self.resources.grudge_army)

			if not resource:is_null_interface() then
				world_grudges = world_grudges + resource:value()
			end
		end
	end

	out.design("----------------------------")
	out.design("World Grudges: "..world_grudges)
	out.design("----------------------------")

	return world_grudges
end

function grudge_cycle:update_cycle_tracker(faction_name)
	if self.cycle_grudges[faction_name] then
		local percentage

		if self.target_grudge_value[faction_name] > 0 then
			percentage = math.floor((self.cycle_grudges[faction_name] / self.target_grudge_value[faction_name]) * 100)
		else
			percentage = 0
		end

		out.design(faction_name.." - "..self.cycle_grudges[faction_name].." / "..self.target_grudge_value[faction_name].." - Setting grudge % to: "..percentage)

		-- reset the % to 0 to the min value of 0 before assigning the updated value.
		cm:faction_add_pooled_resource(faction_name, self.resources.cycle_percent, self.factors.settled, -100)
		cm:faction_add_pooled_resource(faction_name, self.resources.cycle_percent, self.factors.settled, percentage)

		if self.cycle_grudges[cm:get_local_faction_name(true)] then
			common.set_context_value("cycle_grudge_value", self.cycle_grudges[cm:get_local_faction_name(true)])
		end
	end
end

function grudge_cycle:track_trespass()
	core:add_listener(
		"GrudgeTrespassTracker",
		"FactionTurnStart",
		function(context)
			local faction = context:faction()

			if faction:culture() == self.cultures.dwarf then
				return true
			end

			return false
		end,
		function(context)
			local faction = context:faction()
			local char_list = self:get_characters_in_faction_regions(faction)

			for i = 1, #char_list do
				local char = char_list[i]
				local char_faction = char:faction()

				if char_faction:culture() ~= self.cultures.dwarf then
					local mf = char:military_force()
					local stance = mf:active_stance()

					if faction:military_access_pact_with(char_faction) == false and stance ~= "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID" and stance ~= "MILITARY_FORCE_ACTIVE_STANCE_TYPE_SET_CAMP_RAIDING" then
						local grudge_type = "trespass"

						self:assign_grudges(mf, self.factors.trespass, self.values[grudge_type], true)
					end
				end
			end
		end,
		true
	)
end

function grudge_cycle:track_raiding()
	core:add_listener(
		"GrudgeRaidingTracker",
		"FactionTurnStart",
		function(context)
			local faction = context:faction()

			if faction:culture() == self.cultures.dwarf then
				return true
			end

			return false
		end,
		function(context)
			local faction = context:faction()
			local char_list = self:get_characters_in_faction_regions(faction)

			for i = 1, #char_list do
				local char = char_list[i]
				local char_faction = char:faction()

				if char_faction:culture() ~= self.cultures.dwarf then
					local mf = char:military_force()
					local stance = mf:active_stance()

					if stance == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID" or stance == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_SET_CAMP_RAIDING" then
						-- give grudge points to this character
						local grudge_type = "raiding"

						self:assign_grudges(mf, self.factors[grudge_type], self.values[grudge_type], true)
					end
				end
			end
		end,
		true
	)
end

function grudge_cycle:track_diplomacy()
	core:add_listener(
		"GrudgeNegativeDiplomacy",
		"NegativeDiplomaticEvent",
		function(context)
			if context:recipient():culture() == self.cultures.dwarf and context:proposer():culture() ~= self.cultures.dwarf then
				-- only trigger grudges if the dwarf was the recipient not the proposer
				return true
			end

			return false
		end,
		function(context)
			local faction = context:proposer()
			local grudge_type

			if context:is_war() then
				grudge_type = "war_declaration"
			else
				grudge_type = "broken_treaty"
			end

			self:assign_grudges(faction, self.factors[grudge_type], self.values[grudge_type], true)
		end,
		true
	)

	core:add_listener(
		"GrudgePositiveDiplomacy",
		"PositiveDiplomaticEvent",
		function(context)
			local proposer_culture = context:proposer():culture()
			local recipient_culture = context:recipient():culture()

			if (proposer_culture == self.cultures.dwarf and recipient_culture ~= self.cultures.dwarf) or (recipient_culture == self.cultures.dwarf and proposer_culture ~= self.cultures.dwarf) then
				-- only trigger grudges if the dwarf was the recipient not the proposer
				return true
			end

			return false
		end,
		function(context)
			local proposer = context:proposer()
			local recipient = context:recipient()
			local faction
			local grudge_type

			if proposer:culture() == self.cultures.dwarf then
				faction = recipient
			else
				faction = proposer
			end

			if context:is_state_gift() then
				return
			elseif context:is_peace_treaty() then
				grudge_type = "peace"
			else
				grudge_type = "positive_diplomacy"
			end

			self:assign_grudges(faction, self.factors[grudge_type], self.values[grudge_type], false)
		end,
		true
	)
end

function grudge_cycle:log_pre_battle_data()
	local pb = cm:model():pending_battle()
	if not pb:is_null_interface() then
		local attacker = pb:attacker()
		local attacker_mf = attacker:military_force()
		local attacker_grudge = attacker_mf:pooled_resource_manager():resource(self.resources.grudge_army)
		local defender = pb:defender()
		local defender_faction = defender:faction()
		local defender_mf = defender:military_force()
		local defender_grudge = defender_mf:pooled_resource_manager():resource(self.resources.grudge_army)
		local secondary_attackers = pb:secondary_attackers()
		local secondary_defenders = pb:secondary_defenders()
		local siege = pb:siege_battle()

		-- reset the pending battle table
		self.pending_battle = {
			attackers = {},
			defenders = {},
			region = {}
		}
		
		-- Log the CQI and grudge values of all parties involved in the battle in-case they are killed later
		if not attacker_grudge:is_null_interface() then
			table.insert(self.pending_battle.attackers, {mf_cqi = attacker_mf:command_queue_index(), grudges = attacker_grudge:value()})
		end
		
		if not defender_grudge:is_null_interface() then
			table.insert(self.pending_battle.defenders, {mf_cqi = defender_mf:command_queue_index(), grudges = defender_grudge:value()})
		end
		
		for i = 0, secondary_attackers:num_items() - 1 do
			local attacker = secondary_attackers:item_at(i)
			local attacker_mf = attacker:military_force()
			local attacker_grudge = attacker_mf:pooled_resource_manager():resource(self.resources.grudge_army)

			if not attacker_grudge:is_null_interface() then
				table.insert(self.pending_battle.attackers, {mf_cqi = attacker_mf:command_queue_index(), grudges = attacker_grudge:value()})
			end
		end
		
		for i = 0, secondary_defenders:num_items() - 1 do
			local defender = secondary_defenders:item_at(i)
			local defender_mf = defender:military_force()
			local defender_grudge = defender_mf:pooled_resource_manager():resource(self.resources.grudge_army)

			if not defender_grudge:is_null_interface() then
				table.insert(self.pending_battle.defenders, {mf_cqi = defender_mf:command_queue_index(), grudges = defender_grudge:value()})
			end
		end

		if siege and defender:faction():culture() ~= self.cultures.dwarf and defender_mf:force_type():key() ~= "OGRE_CAMP" and defender_faction:is_rebel() == false then
			local region = pb:region_data():region()
			local resource = region:pooled_resource_manager():resource(self.resources.grudge_settlement)

			if not resource:is_null_interface() then
				self.pending_battle.region = {region_name = region:name(), grudges = resource:value()}
			end
		end
	end
end

function grudge_cycle:track_acts_of_aggression()
	core:add_listener(
		"GrudgeBattleStarted",
		"BattleBeingFought",
		function(context)
			return cm:pending_battle_cache_culture_is_defender(self.cultures.dwarf) and cm:pending_battle_cache_culture_is_attacker(self.cultures.dwarf) == false
		end,
		function(context)
			local pb = cm:model():pending_battle()
			local attacker_won = pb:attacker_won()

			for i = 1, cm:pending_battle_cache_num_attackers() do
				local grudge_type = "dwarf_attacked"
				local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_attacker(i)
				local mf = cm:get_military_force_by_cqi(mf_cqi)
				
				if not mf:is_null_interface() and not mf:pooled_resource_manager():resource(self.resources.grudge_army):is_null_interface() then
					self:assign_grudges(mf, self.factors[grudge_type], self.values[grudge_type], true)
				end
			end

			self:log_pre_battle_data()
		end,
		true
	)

	core:add_listener(
		"GrudgeBesiegeLevelCheck",
		"CharacterBesiegesSettlement",
		true,
		function(context)
			local settlement_level = context:region():settlement():primary_slot():building():building_level()
			self.siege_settlement_level = settlement_level
		end,
		true
	)

	core:add_listener(
		"GrudgeSettlementOccupied",
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			return context:character():faction():culture() ~= self.cultures.dwarf
		end,
		function(context)
			local type = context:occupation_decision_type()
			local grudge_type = false
			local occupied = false
			local sack = false
			local raze = false

			if type == "occupation_decision_sack" then
				grudge_type = "sack_per_tier"
				sack = true
			elseif type == "occupation_decision_raze_without_occupy" then
				grudge_type = "razed_per_tier"
				raze = true
			elseif type == "occupation_decision_occupy" or type == "occupation_decision_gift_to_another_faction" or "occupation_decision_resettle" or type == "occupation_decision_loot" or type == "occupation_decision_colonise" then
				grudge_type = "occupation_per_tier"
				occupied = true
			end

			if occupied or sack or raze then
				local char = context:character()
				local region = context:garrison_residence():region()

				if raze or occupied then
					-- remove any grudges that are currently on the region
					local grudges = region:pooled_resource_manager():resource(self.resources.grudge_settlement)
					if not grudges:is_null_interface() then
						local factors = grudges:factors()

						for i = 0, factors:num_items() - 1 do
							local factor = factors:item_at(i)

							self:assign_grudges(region, factor:key(), -factor:value())
						end
					end
				end

				if context:previous_owner_culture() == self.cultures.dwarf then
					local mf = char:military_force()
					local value = self.values["occupation_per_tier"] * self.siege_settlement_level

					self:assign_grudges(mf, self.factors["occupation_per_tier"], value, true)

					if grudge_type then
						self:assign_grudges(mf, self.factors[grudge_type], self.values[grudge_type], true)
					end
				end

				if occupied then
					for type, region_list in pairs(self.historical_regions) do
						for _, region_key in ipairs(region_list) do
							if region:name() == region_key then
								self:assign_grudges(region, self.factors.historical_settlement[type], self.values.historical_settlement[type], true)
							end
						end
					end
				end
			end
		end,
		true
	)

	core:add_listener(
		"GrudgeArmyLosses",
		"BattleCompleted",
		function()
			return cm:pending_battle_cache_culture_is_defender(self.cultures.dwarf) or cm:pending_battle_cache_culture_is_attacker(self.cultures.dwarf)
		end,
		function()			
			local pb = cm:model():pending_battle()
			local dwarf_attacker = cm:pending_battle_cache_culture_is_attacker(self.cultures.dwarf)
			local dwarf_defender = cm:pending_battle_cache_culture_is_defender(self.cultures.dwarf)
			local grudge_type = "army_casualties"

			if dwarf_attacker and not dwarf_defender then
				local dwarf_loses =  math.floor(pb:defender_ending_cp_kill_score() / 1000)
				local value = dwarf_loses * self.values[grudge_type]

				local defender = pb:defender()
				if not defender:is_null_interface() and defender:has_military_force() and not defender:military_force():is_set_piece_battle_army() then

					self:assign_grudges(defender:military_force(), self.factors[grudge_type], value, true)
				end
			end

			if dwarf_defender and not dwarf_attacker then
				local dwarf_loses = math.floor( pb:attacker_ending_cp_kill_score() / 1000)
				local value = dwarf_loses * self.values.army_casualties

				local attacker = pb:attacker()
				if not attacker:is_null_interface() and attacker:has_military_force() and not attacker:military_force():is_set_piece_battle_army() then

					self:assign_grudges(attacker:military_force(), self.factors[grudge_type], value, true)
				end
			end
		end,
		true
	)
end

function grudge_cycle:track_agent_actions()
	core:add_listener(
		"GrudgeCharacterAgentAction",
		"CharacterCharacterTargetAction",
		function(context)
			return context:target_character():faction():culture() == self.cultures.dwarf and context:character():faction():culture() ~= self.cultures.dwarf
		end,
		function (context)
			local faction = context:character():faction()
			local value

			if context:mission_result_critial_success() or context:mission_result_success() then
				value = self.values.hero_actions.success
			else
				value = self.values.hero_actions.failure
			end

			self:assign_grudges(faction, self.factors.hero_actions, value, true)
		end,
		true
	)

	core:add_listener(
		"GrudgeRegionAgentAction",
		"CharacterGarrisonTargetAction",
		function(context)
			return context:garrison_residence():faction():culture() == self.cultures.dwarf and context:character():faction():culture() ~= self.cultures.dwarf
		end,
		function(context)
			local faction = context:character():faction()
			local value

			if context:mission_result_critial_success() or context:mission_result_success() then
				value = self.values.hero_actions.success
			else
				value = self.values.hero_actions.failure
			end

			self:assign_grudges(faction, self.factors.hero_actions, value, true)
		end,
		true
	)
end

function grudge_cycle:dwarf_is_attacker_or_defender(pending_battle)
	local dwarf_attacker = false
	local dwarf_defender = false
	local attacker = pending_battle:attacker()
	local defender = pending_battle:defender()
	local secondary_attackers = pending_battle:secondary_attackers()
	local secondary_defenders = pending_battle:secondary_defenders()

	if attacker:faction():culture() == self.cultures.dwarf then
		dwarf_attacker = true
	end

	if defender:faction():culture() == self.cultures.dwarf then
		dwarf_defender = true
	end

	for i = 0, secondary_attackers:num_items() - 1 do
		local attacker = secondary_attackers:item_at(i)

		if attacker:faction():culture() == self.cultures.dwarf then
			dwarf_attacker = true
		end
	end

	for i = 0, secondary_defenders:num_items() - 1 do
		local defender = secondary_defenders:item_at(i)

		if defender:faction():culture() == self.cultures.dwarf then
			dwarf_defender = true
		end
	end

	return dwarf_attacker, dwarf_defender
end

function grudge_cycle:assign_grudges(target_interface, factor, value, spread)
	local faction

	if is_region(target_interface) then
		faction = target_interface:owning_faction()
		culture = faction:culture()
		
		if culture == self.cultures.dwarf or culture == self.cultures.rogue or faction:is_rebel() then
			return
		end

		local modifier = self.cultural_modifiers[culture] or grudge_modifiers.standard

		if value < 0 then
			-- if culture has a modifier, reduce the positive benefits of lowering grudges by the same modifier
			modifier = (1 - modifier) + 1
		end

		value = math.floor(value * modifier)

		cm:entity_add_pooled_resource_transaction(target_interface, self.factors.settlement_prefix..factor, value)
	elseif is_militaryforce(target_interface) then
		faction = target_interface:faction()
		culture = faction:culture()
		
		if culture == self.cultures.dwarf or culture == self.cultures.rogue or faction:is_rebel() then
			return
		end

		local modifier = self.cultural_modifiers[culture] or grudge_modifiers.standard

		if value < 0 then
			-- if culture has a modifier, reduce the positive benefits of lowering grudges by the same modifier
			modifier = (1 - modifier) + 1
		end

		value = math.floor(value * modifier)

		cm:entity_add_pooled_resource_transaction(target_interface, self.factors.army_prefix..factor, value)
	elseif is_faction(target_interface) then
		faction = target_interface
		culture = faction:culture()
		
		if culture == self.cultures.dwarf or culture == self.cultures.rogue or faction:is_rebel() then
			return
		end

		local modifier = self.cultural_modifiers[culture] or grudge_modifiers.standard

		if value < 0 then
			-- if culture has a modifier, reduce the positive benefits of lowering grudges by the same modifier
			modifier = (1 - modifier) + 1
		end

		value = math.floor(value * modifier)

		local mf_list = faction:military_force_list()
		local region_list = faction:region_list()

		for i = 0, mf_list:num_items() - 1 do
			local mf = mf_list:item_at(i)

			-- only spread if not the original target
			if mf ~= target_interface and not mf:pooled_resource_manager():resource(self.resources.grudge_army):is_null_interface() then
				cm:entity_add_pooled_resource_transaction(mf, self.factors.army_prefix..factor, value)
			end
		end

		-- spread to all settlements in faction
		for i = 0, region_list:num_items() - 1 do
			local region = region_list:item_at(i)

			-- only spread if not the original target
			if region ~= target_interface then
				cm:entity_add_pooled_resource_transaction(region, self.factors.settlement_prefix..factor, value)
			end
		end
	end

	if spread and is_faction(faction) then
		local faction_spread = math.floor((value / 100) * self.values.faction_actions)
		local culture_spread = math.floor((value / 100) * self.values.culture_actions)
		local culture = faction:culture()
		local culture_list = cm:get_factions_by_culture(culture)
		local culture_group = false

		if self.cultures.elves[culture] then
			culture_group = self.cultures.elves
		elseif self.cultures.doc_cultures[culture] then
			culture_group = self.cultures.doc_cultures
		elseif self.cultures.moc_cultures[culture] then
			culture_group = self.cultures.moc_cultures
		elseif self.cultures.undead[culture] then
			culture_group = self.cultures.undead
		end

		if culture_group then
			-- Dwarves don't acknowlegde the difference between elves and treat all elves as the same.
			for culture_key, _ in pairs(culture_group) do
				if culture ~= culture_key then
					local new_culture_list = cm:get_factions_by_culture(culture_key)

					for _, new_faction in pairs(new_culture_list) do
						table.insert(culture_list, new_faction)
					end
				end
			end
		end

		for _, faction_interface in ipairs(culture_list) do
			-- don't spread to the faction if the original target was the entire faciton.
			if target_interface ~= faction_interface then
				local mf_list = faction_interface:military_force_list()
				local region_list = faction_interface:region_list()
				local factor
				local spread

				if faction_interface == faction then
					factor = self.factors.faction_actions
					spread = faction_spread
				else
					factor = self.factors.culture_actions[faction_interface:culture()]
					spread = culture_spread
				end

				-- spread to all armies in faction
				for i = 0, mf_list:num_items() - 1 do
					local mf = mf_list:item_at(i)

					-- only spread if not the original target
					if mf ~= target_interface and not mf:pooled_resource_manager():resource(self.resources.grudge_army):is_null_interface() then
						cm:entity_add_pooled_resource_transaction(mf, self.factors.army_prefix..factor, spread)
					end
				end

				-- spread to all settlements in faction
				for i = 0, region_list:num_items() - 1 do
					local region = region_list:item_at(i)

					-- only spread if not the original target
					if region ~= target_interface then
						cm:entity_add_pooled_resource_transaction(region, self.factors.settlement_prefix..factor, spread)
					end
				end
			end
		end
	end
end

function grudge_cycle:settle_grudges()
	core:add_listener(
		"LogGrudgeChanges",
		"PooledResourceChanged",
		function(context)
			return context:resource():key() == self.resources.settled_grudges and self.cycle_grudges[context:faction():name()]
		end,
		function(context)
			local faction_name = context:faction():name()

			self.cycle_grudges[faction_name] = self.cycle_grudges[faction_name] + context:amount()
			self:update_cycle_tracker(faction_name)
		end,
		true
	)

	core:add_listener(
        "GrudgeBattlePending",
        "PendingBattle",
        function(context)
			local dwarf_attacker, dwarf_defender = self:dwarf_is_attacker_or_defender(context:pending_battle())

			return dwarf_attacker or dwarf_defender
        end,
        function(context)
			-- log armies grudge values before battles begin in-case they die during the battle.
			self:log_pre_battle_data()
        end,
        true
	)

	core:add_listener(
		"GrudgeOccupyEvent",
		"CharacterCapturedSettlementUnopposed",
		function(context)
			local garrison_residence = context:garrison_residence()
			local faction = context:character():faction()
			return faction:culture() == self.cultures.dwarf and faction:can_be_human() and not garrison_residence:region():is_abandoned() and garrison_residence:faction():is_rebel() == false
		end,
		function(context)
			local region = context:garrison_residence():region()

			self.pending_battle.region = {region_name = region:name(), grudges = region:pooled_resource_manager():resource(self.resources.grudge_settlement):value()}
		end,
		true
	)

	core:add_listener(
		"GrudgeSettleGrudges",
		"BattleCompleted",
		function()
			local pb = cm:model():pending_battle()
			return (cm:pending_battle_cache_culture_is_defender(self.cultures.dwarf) and pb:defender_won()) or (cm:pending_battle_cache_culture_is_attacker(self.cultures.dwarf) and pb:attacker_won())
		end,
		function()			
			pb = cm:model():pending_battle()
			local dwarf_winnners = {}
			local losers = {}
			local grudges = 0

			if cm:pending_battle_cache_culture_is_defender(self.cultures.dwarf) and pb:defender_won() then
				for i = 1, cm:pending_battle_cache_num_defenders() do
					local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_defender(i)
					local faction = cm:get_faction(faction_name)

					if faction:culture() == self.cultures.dwarf and faction:can_be_human() then
						table.insert(dwarf_winnners, {char_cqi = char_cqi, mf_cqi = mf_cqi, faction_name = faction_name})
					end

					losers = self.pending_battle.attackers
				end
			elseif cm:pending_battle_cache_culture_is_attacker(self.cultures.dwarf) and pb:attacker_won() then
				for i = 1, cm:pending_battle_cache_num_attackers() do
					local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_attacker(i)
					local faction = cm:get_faction(faction_name)

					if faction:culture() == self.cultures.dwarf and faction:can_be_human() then
						table.insert(dwarf_winnners, {char_cqi = char_cqi, mf_cqi = mf_cqi, faction_name = faction_name})
					end

					losers = self.pending_battle.defenders
				end
			end

			if #dwarf_winnners > 0 then
				for _, loser in ipairs(losers) do
					local mf = cm:get_military_force_by_cqi(loser.mf_cqi)
					
					if mf and not mf:is_null_interface() then
						local faction = mf:faction()

						if faction:is_rebel() == false then
							local value = mf:pooled_resource_manager():resource(self.resources.grudge_army):value() or loser.grudges
							grudges = grudges + value

							self:assign_grudges(mf, self.factors.settled, -value, false)
						end
					else
						-- mf was wiped out, just log the pending battle saved grudges
						grudges = grudges + loser.grudges
					end
				end

				for _, winner in ipairs(dwarf_winnners) do
					-- divide the gained grudges between winning dwarves.
					local value = math.floor(grudges / #dwarf_winnners)

					if cm:get_local_faction_name(true) == winner.faction_name then
						common.set_context_value("cycle_grudge_value", self.cycle_grudges[winner.faction_name])
					end

					cm:faction_add_pooled_resource(winner.faction_name, self.resources.settled_grudges, self.factors.settled, value)
					self:update_cycle_tracker(winner.faction_name)
				end
			end
		end,
		true
	)
	
	core:add_listener(
		"GrudgeDwarfSettlementOccupied",
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			local faction = context:character():faction()
			return context:character():faction():culture() == self.cultures.dwarf and faction:can_be_human()
		end,
		function(context)
			if self.pending_battle.region.region_name then
				local region = cm:get_region(self.pending_battle.region.region_name)
				local value = self.pending_battle.region.grudges
				local faction_name = context:character():faction():name()

				if cm:get_local_faction_name(true) == faction_name then
					common.set_context_value("cycle_grudge_value", self.cycle_grudges[faction_name])
				end

				self:assign_grudges(region, self.factors.settled, -value, false)
				cm:faction_add_pooled_resource(faction_name, self.resources.settled_grudges, self.factors.settled, value)
				self:update_cycle_tracker(faction_name)
			end
		end,
		true
	)
end

function grudge_cycle:cycle_timer()
	core:add_listener(
		"GrudgeCycleCounter",
		"FactionTurnStart",
		function(context)
			local faction = context:faction()

			if faction:culture() == self.cultures.dwarf and faction:can_be_human() then
				return true
			end

			return false
		end,
		function(context)
			local faction = context:faction()
			local faction_key = faction:name()

			if faction:is_human() then
				if self.faction_times[faction_key] then
					self.faction_times[faction_key] = self.faction_times[faction_key] - 1

					if self.faction_times[faction_key] <= 0 then
						-- Timer complete, grant rewards and reset cycle
						local level = self:get_current_grudge_level(faction_key)
						local faction = cm:get_faction(faction_key)

						for i = 0, 5 do
							cm:remove_effect_bundle(self.reward_prefix..i, faction_key)
						end

						cm:apply_effect_bundle(self.reward_prefix..level, faction_key, self.cycle_time + 1) -- effect bundle duration comes through as 1 less than the cycle time when applied so adding

						self:set_grudge_target(faction, level)

						if self.delayed_factions[faction_key] then
							self.delayed_factions[faction_key] = false
						end

						if level > 0 and self.minimum_world_grudges_met then
							out.design("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
							out.design("faction: "..faction_key.." reached grudge level: "..level)
							out.design("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")

							for k, unit in ipairs(self.settler_units[level]) do
								cm:add_units_to_faction_mercenary_pool(faction:command_queue_index(), unit, 1)
							end

							if cm:get_faction(faction_key):is_human() then
								self.faction_levels[faction_key] = level
								cm:trigger_dilemma(faction_key, self.delay_dilemma)
							end
						end
						
						if self.grudge_armies[faction_key] then
							-- remove any existing grudge armies
							cm:disable_event_feed_events(true, "", "", "character_dies_in_action")
							cm:kill_character(cm:char_lookup_str(self.grudge_armies[faction_key]), true)
							self.grudge_armies[faction_key] = nil

							cm:callback(function()
								cm:disable_event_feed_events(false, "", "", "character_dies_in_action")
							end, 0.1)
						end

						if level == 5 then
							-- spawn new army if at lvl 5
							self:spawn_grudge_settler_army(faction_key)
						end

						self.faction_times[faction_key] = self.cycle_time
						self.cycle_grudges[faction_key] = 0
					end

					if cm:get_local_faction_name(true) == faction_key then
						common.set_context_value("cycle_grudge_value", self.cycle_grudges[faction_key])
					end

					self:update_cycle_tracker(faction_key)
				else
					-- timer for dwarf faction didn't exist, set a fresh timer.
					self.faction_times[faction_key] = self.cycle_time
				end
			end
		end,
		true
	)
end


function grudge_cycle:delay_cycles()
	core:add_listener(
		"GrudgeDelayDilemma",
		"DilemmaChoiceMadeEvent",
		function(context)
			return context:dilemma() == self.delay_dilemma
		end,
		function(context)
			local target_faction = context:faction()
			local faction_name = target_faction:name()

			if context:choice() == 0 then
				self.delayed_factions[faction_name] = false

				out.design("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
				out.design("NEW AGE BEGINS FOR: "..faction_name)
				out.design("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
			elseif context:choice() == 1 then
				self:set_grudge_target(target_faction, self.faction_levels[faction_key], 0)
				self.delayed_factions[faction_name] = true

				out.design("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
				out.design("NEW AGE DELAYED FOR: "..faction_name)
				out.design("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
			end
		end,
		true
	)
end

function grudge_cycle:get_current_grudge_level(faction_key)
	if not self.delayed_factions[faction_key] and self.minimum_world_grudges_met then
		local faction = cm:get_faction(faction_key)
		local grudge_cycle_value = faction:pooled_resource_manager():resource(self.resources.cycle_percent):value()

		for level, ranges in ipairs(self.ranges) do
			if grudge_cycle_value >= ranges.min and grudge_cycle_value <= ranges.max then
				return level
			end
		end
	end

	return 0
end

function grudge_cycle:get_characters_in_faction_regions(faction_interface)
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

function grudge_cycle:spawn_grudge_settler_army(faction_key)
	local spawn_at_leader = true
	local faction = cm:get_faction(faction_key)
	local faction_leader = faction:faction_leader()
	local home_region = faction:home_region()
	local region_name
	local pos_x, pos_y

	if not faction_leader:is_null_interface() and not faction_leader:is_wounded() and faction_leader:is_deployed() then
		region_name = faction_leader:region():name()
	elseif not home_region:is_null_interface() and not home_region:garrison_residence():is_under_siege() then
		region_name = home_region:name()
		spawn_at_leader = false
	else
		local region_list = faction:region_list()
		local region_found = false

		for i = 0, region_list:num_items() - 1 do
			local region = region_list:item_at(i)

			if not region:garrison_residence():is_under_siege() then
				region_name = region:name()
				region_found = true
				break
			end
		end

		if region_found == false then
			-- if we fail to find a region name then just end the function
			return
		end
	end
	
	if spawn_at_leader then
		pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, region_name, false, true, 10)
	else
		pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, region_name, false, true, 10)
	end

	local ram = random_army_manager
	ram:remove_force("grudge_settler_army")
	ram:new_force("grudge_settler_army")

	ram:add_unit("grudge_settler_army","wh3_dlc25_dwf_art_grudge_thrower_grudge_reward", 2)
	ram:add_unit("grudge_settler_army","wh_main_dwf_art_flame_cannon_grudge_reward", 2)
	ram:add_unit("grudge_settler_army","wh_main_dwf_inf_hammerers_grudge_reward", 5)
	ram:add_unit("grudge_settler_army","wh_main_dwf_inf_irondrakes_0_grudge_reward", 3)
	ram:add_unit("grudge_settler_army","wh_main_dwf_inf_longbeards_1_grudge_reward", 5)
	ram:add_unit("grudge_settler_army","wh_main_dwf_inf_quarrellers_1_grudge_reward", 4)
	ram:add_unit("grudge_settler_army","wh_main_dwf_inf_slayers_grudge_reward", 5)
	ram:add_unit("grudge_settler_army","wh_main_dwf_veh_gyrocopter_1_grudge_reward", 2)

	local army_size = self.grudge_army_size.base + cm:get_factions_bonus_value(faction_key, self.grudge_army_size.bonus_value)
	local unit_list = ram:generate_force("grudge_settler_army", army_size, false)

	cm:create_force_with_general(
		faction_key,
		unit_list,
		region_name,
		pos_x,
		pos_y,
		"general",
		"wh3_dlc25_dwf_daemon_slayer_spawned_army",
		"",
		"",
		"",
		"",
		false,
		function(cqi)
			cm:apply_effect_bundle_to_characters_force("wh3_dlc25_bundle_force_dwarf_grudge_settler_army", cqi, self.cycle_time + 1)
			cm:replenish_action_points(cm:char_lookup_str(cqi))
			self.grudge_armies[faction_key] = cqi
		end
	)
end

function grudge_cycle:launch_dilemma_when_grudges_low()
	core:add_listener(
		"GrudgeLowDilemma",
		"WorldStartRound",
		true,
		function(context)
			if self.dilemma.current_cooldown <= 0 then
				local faction_list = {}

				for faction_key, _ in pairs(self.cycle_grudges) do
					local faction = cm:get_faction(faction_key)
					if faction:can_be_human() then
						local met_grudges = self:get_met_grudges(cm:get_faction(faction_key))

						if met_grudges < self.target_grudge_base then
							table.insert(faction_list, faction_key)
						end
					end
				end

				if #faction_list > 0 then
					for _, faction_key in ipairs(faction_list) do
						local faction = cm:get_faction(faction_key)
						local met_faction_list = faction:factions_met()
						local nuetral_met_faction_list = {}

						for i = 0, met_faction_list:num_items() - 1 do
							local met_faction = met_faction_list:item_at(i)

							if met_faction:at_war_with(faction) == false and met_faction:allied_with(faction) == false and met_faction:culture() ~= self.cultures.dwarf and met_faction:is_human() == false then
								table.insert(nuetral_met_faction_list, met_faction)
							end
						end

						if #nuetral_met_faction_list > 0 then
							local faction_choice = cm:random_number(#nuetral_met_faction_list, 1)
							local target_faction_name = nuetral_met_faction_list[faction_choice]:name()

							self.dilemma.current_cooldown = self.dilemma.cooldown
	
							if faction:is_human() then
								self:spawn_grudge_dilemma(faction_key, target_faction_name)
							else
								local roll = cm:random_number(5, 1)
								local target_faction = nuetral_met_faction_list[faction_choice]

								if roll == 1 then
									local value = cm:random_number(self.dilemma.grudges.high.max, self.dilemma.grudges.high.min)
									self:assign_grudges(target_faction, self.factors.faction_actions, value, true)
									cm:force_declare_war(faction_key, target_faction:name(), false, false)
									out.design("TRIGGERING: "..faction_key.." AGAINST: "..target_faction:name().." AND ADDING: "..value)
								else
									local value = cm:random_number(self.dilemma.grudges.low.max, self.dilemma.grudges.low.min)
									self:assign_grudges(target_faction, self.factors.faction_actions, value, true)
									out.design("TRIGGERING: "..faction_key.." AGAINST: "..target_faction:name().." AND ADDING: "..value)
								end
							end
						end
					end
				end
			else
				self.dilemma.current_cooldown = self.dilemma.current_cooldown - 1
			end
		end,
		true
	)
end

function grudge_cycle:spawn_grudge_dilemma(faction_key, target_faction_key)
	local dilemma_key = self.dilemma.key_prefix..cm:random_number(self.dilemma.count, 1)
	local faction_cqi = cm:get_faction(faction_key):command_queue_index()
	local target_faction_cqi = cm:get_faction(target_faction_key):command_queue_index()
	
	cm:trigger_dilemma_with_targets(faction_cqi, dilemma_key, target_faction_cqi)

	core:add_listener(
		dilemma_key,
		"DilemmaChoiceMadeEvent",
		function(context)
			return context:dilemma():starts_with(self.dilemma.key_prefix)
		end,
		function(context)
			local faction_name = context:faction():name()
			local target_faction = cm:get_faction(target_faction_key)

			if context:choice() == 0 then
				local value = cm:random_number(self.dilemma.grudges.high.max, self.dilemma.grudges.high.min)
				self:assign_grudges(target_faction, self.factors.faction_actions, value, true)
				cm:force_declare_war(faction_name, target_faction:name(), false, false)
			elseif context:choice() == 1 then
				local value = cm:random_number(self.dilemma.grudges.low.max, self.dilemma.grudges.low.min)
				self:assign_grudges(target_faction, self.factors.faction_actions, value, true)
			end
		end,
		false
	)
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("grudge_cycle.target_grudge_value", grudge_cycle.target_grudge_value, context)
		cm:save_named_value("grudge_cycle.cycle_grudges", grudge_cycle.cycle_grudges, context)
		cm:save_named_value("grudge_cycle.pending_battle", grudge_cycle.pending_battle, context)
		cm:save_named_value("grudge_cycle.siege_settlement_level", grudge_cycle.siege_settlement_level, context)
		cm:save_named_value("grudge_cycle.historical_regions", grudge_cycle.historical_regions, context)
		cm:save_named_value("grudge_cycle.faction_times", grudge_cycle.faction_times, context)
		cm:save_named_value("grudge_cycle.grudge_armies", grudge_cycle.grudge_armies, context)
		cm:save_named_value("grudge_cycle.dilemma.current_cooldown", grudge_cycle.dilemma.current_cooldown, context)
		cm:save_named_value("grudge_cycle.delayed_factions", grudge_cycle.delayed_factions, context)
		cm:save_named_value("grudge_cycle.minimum_world_grudges_met", grudge_cycle.minimum_world_grudges_met, context)
		cm:save_named_value("grudge_cycle.faction_levels", grudge_cycle.faction_levels, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			grudge_cycle.target_grudge_value = cm:load_named_value("grudge_cycle.target_grudge_value", grudge_cycle.target_grudge_value, context)
			grudge_cycle.cycle_grudges = cm:load_named_value("grudge_cycle.cycle_grudges", grudge_cycle.cycle_grudges, context)
			grudge_cycle.pending_battle = cm:load_named_value("grudge_cycle.pending_battle", grudge_cycle.pending_battle, context)
			grudge_cycle.siege_settlement_level = cm:load_named_value("grudge_cycle.siege_settlement_level", grudge_cycle.siege_settlement_level, context)
			grudge_cycle.historical_regions = cm:load_named_value("grudge_cycle.historical_regions", grudge_cycle.historical_regions, context)
			grudge_cycle.faction_times = cm:load_named_value("grudge_cycle.faction_times", grudge_cycle.faction_times, context)
			grudge_cycle.grudge_armies = cm:load_named_value("grudge_cycle.grudge_armies", grudge_cycle.grudge_armies, context)
			grudge_cycle.dilemma.current_cooldown = cm:load_named_value("grudge_cycle.dilemma.current_cooldown", grudge_cycle.dilemma.current_cooldown, context)
			grudge_cycle.delayed_factions = cm:load_named_value("grudge_cycle.delayed_factions", grudge_cycle.delayed_factions, context)
			grudge_cycle.minimum_world_grudges_met = cm:load_named_value("grudge_cycle.minimum_world_grudges_met", grudge_cycle.minimum_world_grudges_met, context)
			grudge_cycle.faction_levels = cm:load_named_value("grudge_cycle.faction_levels", grudge_cycle.faction_levels, context)
		end
	end
)