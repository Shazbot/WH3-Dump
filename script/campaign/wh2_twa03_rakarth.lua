RakarthBeastHunts = {
	rakarth_faction_key = "wh2_twa03_def_rakarth",
	underway_cultures = {["wh_main_grn_greenskins"] = true,["wh_main_dwf_dwarfs"] = true,["wh2_main_skv_skaven"] = true},
	rakarth_skill_key = "wh2_twa03_skill_def_rakarth_harpyclaw_bolts",
	occupation_do_nothing = "occupation_decision_do_nothing", -- Since even 'doing nothing' on a razed settlement counts as a settlement option, we need to exclude this option when rewarding beasts.
	settlements_beast_raided_this_turn = {},	-- Cache of the keys of all settlements from which beasts have been earned this turn. Used to avoid double-dipping for beasts by sacking and then razing.
	
	----variables
	rakarth_skill_bonus_chance = 15, -- additive modifier applied to all rolls when Rakarth has the skil named above
	bad_luck_modifier_increment = 10,-- bad luck modifier for a specific incident goes up by this value every time an incident is not generated
	bad_luck_modifiers = {["raiding"] = 100, ["settlement_occupation"] = 100 , ["post_battle"] = 100}, --- these are set to 100 so the first time you do each in a campaign it's a guaranteed succss
	bad_luck_modifier_max = 30, -- bad luck modifier cannot exceed this value
	bad_luck_modifier_min = -100, -- bad luck modifier cannot go below this value
	bad_luck_modifier_soft_min = 0, -- bad luck modifier will correct to this value at start of turn if below this
	streak_prevention_value = -75, -- amount the bad luck modifier for a specific incident type goes down to following a successful roll
	chaos_corruption_min_threshold = 20, -- The percentage of corruption at which dice rolls for chaos beasts begin when raiding
	chaos_corruption_max_threshold = 80, -- The percentage of corruption after which only chaos beasts can be obtained via raiding
	chaos_corruption_increased_luck = 25,	-- The increased chance of getting a monster gained when raiding in a fully-chaotic province.
	chaos_corruption_types = {
		"wh3_main_corruption_chaos",
		"wh3_main_corruption_khorne",
		"wh3_main_corruption_nurgle",
		"wh3_main_corruption_slaanesh",
		"wh3_main_corruption_tzeentch",
	},	-- Types of corruption considered to increase the likelihood of chaos monsters (Manticores)
	display_debug = false,
	beast_incidents_for_rite = 5,
	province_capital_modifier = 10, -- for settlement occupation events, apply this bonus to roll if province capital

	-- Missions and Events
	zoo_raid_trigger_faction_set = "non_colonial_empire_factions", -- Who Rakarth has to be at war with to trigger the Zoo Raid mission.
	zoo_raid_mission = "wh3_main_ie_qb_def_rakarth_raid_the_zoo",

	-- Beasthunt dilemma is driven entirely by data, but these are here so that the script's debug function can force-test the dilemma and its outcomes.
	beasthunt_dilemma = "wh2_twa03_dilemma_rakarth_rite",
	beasthunt_indicents = {
		"wh2_twa03_incident_rakarth_dilemma_beast_darklands_common",
		"wh2_twa03_incident_rakarth_dilemma_beast_darklands_rare",
		"wh2_twa03_incident_rakarth_dilemma_beast_market_common",
		"wh2_twa03_incident_rakarth_dilemma_beast_market_rare",
		"wh2_twa03_incident_rakarth_dilemma_lustria_common",
		"wh2_twa03_incident_rakarth_dilemma_lustria_rare",
		"wh2_twa03_incident_rakarth_dilemma_old_world_common",
		"wh2_twa03_incident_rakarth_dilemma_old_world_rare",
		"wh2_twa03_incident_rakarth_dilemma_sorceresses_common",
		"wh2_twa03_incident_rakarth_dilemma_sorceresses_rare",
	},

	rakarth_incidents =
	{
		raiding = {
			climate_mountain =
			{
				{ incident = "wh2_twa03_incident_rakarth_raid_hydra", chance = 20},
				{ incident = "wh2_twa03_incident_rakarth_raid_sabretusks", chance = 30},
			},
			climate_temperate =
			{
				{ incident = "wh2_twa03_incident_rakarth_raid_wolves", chance = 25},
				{ incident = "wh2_twa03_incident_rakarth_raid_bears", chance = 25},
			},
			climate_island =
			{
				{ incident = "wh2_twa03_incident_rakarth_raid_harpies", chance = 50},
			},
			climate_frozen =
			{
				{ incident = "wh2_twa03_incident_rakarth_raid_ice_bears", chance = 35},
			},
			climate_desert =
			{
				{ incident = "wh2_twa03_incident_rakarth_raid_wyvern", chance = 35},
			},
			climate_jungle =
			{
				{ incident = "wh2_twa03_incident_rakarth_raid_stegadon", chance = 20},
				{ incident = "wh2_twa03_incident_rakarth_raid_cold_ones", chance = 30}
			},
			climate_savannah =
			{
				{ incident = "wh2_twa03_incident_rakarth_raid_cold_ones", chance = 50},
			},
			climate_wasteland =
			{
				{ incident = "wh2_twa03_incident_rakarth_raid_squigs", chance = 30},
				{ incident = "wh2_twa03_incident_rakarth_raid_wyvern", chance = 20},
			},
			climate_chaotic =
			{
				{ incident = "wh2_twa03_incident_rakarth_raid_manticore", chance = 50},
			},
			chaos_corrupted =
			{
				{ incident = "wh2_twa03_incident_rakarth_raid_manticore", chance = 30},
			},
			climate_magicforest =
			{
				{ incident = "wh2_twa03_incident_rakarth_raid_spiders", chance = 50},
			},
		},
		settlement_occupation = {
			wh2_main_hef_high_elves =
			{
				{ incident = "wh2_twa03_incident_rakarth_settlement_high_elf_dragon", chance = 10}
			},
			wh2_main_def_dark_elves =
			{
				{ incident = "wh2_twa03_incident_rakarth_settlement_dark_elf_dragon", chance = 10},
				{ incident = "wh2_twa03_incident_rakarth_settlement_dark_elf_medusae", chance = 15, dlc = "TW_WH2_DLC14_SHADOW"}
			},
			wh_main_grn_greenskins =
			{
				{ incident = "wh2_twa03_incident_rakarth_settlement_greenskins_squigs", chance = 10},
				{ incident = "wh2_twa03_incident_rakarth_settlement_greenskins_wyvern", chance = 15}
			},
			wh2_main_lzd_lizardmen =
			{
				{ incident = "wh2_twa03_incident_rakarth_settlement_lizardmen_carnosaur", chance = 15},
				{ incident = "wh2_twa03_incident_rakarth_settlement_lizardmen_stegadon", chance = 10},
			},
			wh_dlc08_nor_norsca =
			{
				{ incident = "wh2_twa03_incident_rakarth_settlement_norsca_mammoth", chance = 15},
				{ incident = "wh2_twa03_incident_rakarth_settlement_norsca_wolves", chance = 10}
			},
			wh3_main_ksl_kislev =
			{
				{ incident = "wh2_twa03_incident_rakarth_settlement_kislev_bears", chance = 10},
				{ incident = "wh2_twa03_incident_rakarth_settlement_kislev_ice_bears", chance = 15}
			},
			wh_dlc05_wef_wood_elves =
			{
				{ incident = "wh2_twa03_incident_rakarth_settlement_wood_elf_spiders", chance = 30},
			},
			wh3_main_ogr_ogre_kingdoms =
			{
				{ incident = "wh2_twa03_incident_rakarth_raid_sabretusks", chance = 30},
			},
			wh_main_chs_chaos =
			{
				{ incident = "wh2_twa03_incident_rakarth_settlement_chaos_manticore", chance = 25},
			}
		},
		post_battle = {
			naval =
			{
				{ incident = "wh2_twa03_incident_rakarth_battle_kharybdiss", chance = 10, dlc = "TW_WH2_DLC10_QUEEN_CRONE"},
				{ incident = "wh2_twa03_incident_rakarth_battle_harpies", chance = 20},
			},
			underway =
			{
				{ incident = "wh2_twa03_incident_rakarth_battle_squigs", chance = 30},
				{ incident = "wh2_twa03_incident_rakarth_battle_spiders", chance = 30},
			},
			land =
			{
				{ incident = "wh2_twa03_incident_rakarth_battle_harpies", chance = 15},
			},
		},
	},

	ai_unit_per_turn_sum_chance = 75,	-- The chance of AI rakarth getting any replenishment each turn. All beast-specific replenishment rates are downscaled or upscaled to match this. Increase it for more beasts for AI Rakarth.
	ai_units ={
		---unit_key, recruitment_source_key, starting amount, replen chance (scaled to sum), max in pool, merc unit group
		{"wh2_main_def_mon_black_dragon", "monster_pen", 			0, 1, 1,		"wh2_twa03_black_dragon"},
		{"wh2_main_lzd_cav_cold_ones_feral_0", "monster_pen", 		2, 15, 3,		"wh2_twa03_cold_ones"},
		{"wh2_twa03_def_mon_wolves_0", "monster_pen", 				2, 15, 3,		"wh2_twa03_def_mon_wolves_0"},
		{"wh2_main_lzd_mon_stegadon_0", "monster_pen", 				0, 3, 2,		"wh2_twa03_feral_stegadon"},
		{"wh2_main_def_inf_harpies", "monster_pen", 				2, 15, 5,		"wh2_twa03_inf_harpies"},
		{"wh2_dlc14_def_mon_bloodwrack_medusa_0", "monster_pen", 	0, 2, 1,		"wh2_twa03_mon_bloodwrack_medusa_0"},
		{"wh2_main_lzd_mon_carnosaur_0", "monster_pen", 			0, 2, 1,		"wh2_twa03_mon_carnosaur_0"},
		{"wh2_dlc10_def_mon_feral_manticore_0", "monster_pen", 		0, 5, 2,		"wh2_twa03_mon_feral_manticore_0"},
		{"wh2_dlc10_def_mon_kharibdyss_0", "monster_pen", 			0, 2, 1,		"wh2_twa03_mon_kharibdyss_0"},
		{"wh2_twa03_def_mon_war_mammoth_0", "monster_pen", 			0, 2, 1,		"wh2_twa03_mon_war_mammoth_0"},
		{"wh2_main_def_mon_war_hydra", "monster_pen", 				0, 3, 1,		"wh2_twa03_mon_war_hydra"},
		{"wh_twa03_def_inf_squig_explosive_0", "monster_pen", 		0, 10, 2,		"wh2_twa03_squig_explosive"},
		{"wh3_main_monster_feral_bears", "monster_pen", 			0, 15, 2,		"wh2_twa03_mon_monster_feral_bear"},
		{"wh3_main_monster_feral_ice_bears", "monster_pen", 		0, 5, 2,		"wh2_twa03_mon_monster_feral_ice_bear"},
		{"wh2_dlc16_wef_mon_giant_spiders_0", "monster_pen", 		0, 10, 2,		"wh2_twa03_mon_monster_giant_spider"},
		{"wh3_main_ogr_mon_sabretusk_pack_0", "monster_pen", 		0, 10, 2,		"wh2_twa03_mon_monster_sabretusk"},
		{"wh2_twa03_grn_mon_wyvern_0", "monster_pen", 				0, 2, 1,		"wh2_twa03_mon_monster_feral_wyvern"},
	},

	incident_count = 0
}
-----------------
----FUNCTIONS----
-----------------

function RakarthBeastHunts:debug_test_incidents()
	local rakarth_faction_cqi = cm:get_faction(self.rakarth_faction_key):command_queue_index()

	out("Attempting to launch Rakarth's beast hunt dilemma:")
	if not cm:trigger_dilemma(self.rakarth_faction_key, self.beasthunt_dilemma) then
		out(string.format("Rakarth's beast hunt dilemma '%s' failed to launch.", self.beasthunt_dilemma))
	end

	local incidents_fired = {}
	local failed_incidents = {}
	out("Attempting to launch all Rakarth's beast hunt incidents:")
	for i = 1, #self.beasthunt_indicents do
		local incident_key = self.beasthunt_indicents[i]
		if cm:trigger_incident_with_targets(rakarth_faction_cqi, incident_key, 0, 0, 0, 0, 0, 0) then
			out(incident_key .. " successfully triggered")
			incidents_fired[incident_key] = true
		else
			failed_incidents[incident_key] = true
		end
	end

	if not is_empty_table(failed_incidents) then
		out("The following Rakarth beast hunt Incidents failed to fire:")
		for key, _ in pairs(failed_incidents) do
			out(key)
		end
	end

	out("Debug firing all Rakarth Beast Incidents:")

	incidents_fired = {}
	failed_incidents = {}
	for _, incident_category in pairs(self.rakarth_incidents) do
		for _, incident_context in pairs(incident_category) do
			for i = 1, #incident_context  do
				local incident_key = incident_context[i].incident
				if incidents_fired[incident_key] == nil then
					if cm:trigger_incident_with_targets(rakarth_faction_cqi, incident_key, 0, 0, 0, 0, 0, 0) then
						out(incident_key .. " successfully triggered")
						incidents_fired[incident_key] = true
					else
						failed_incidents[incident_key] = true
					end
				end
			end
		end
	end

	if not is_empty_table(failed_incidents) then
		out("The following Rakarth Beast Incidents failed to fire:")
		for key, _ in pairs(failed_incidents) do
			out(key)
		end
	end
end

--LISTENER SETUP--

function RakarthBeastHunts:setup_rakarth_listeners()
	local rakarth_interface =  cm:get_faction(self.rakarth_faction_key)
	if rakarth_interface ~= false then 
		if rakarth_interface:is_human() then
			self:setup_clear_raided_settlements_listener()
			self:setup_settlement_occupation_listener()
			self:setup_post_battle_listener()
			self:setup_raiding_listener()
			self:setup_quest_chain_completion_listener()
			self:setup_war_with_old_world_empire_listener()

			cm:add_faction_turn_start_listener_by_name(
				"rakarth_monster_pen_update",
				"wh2_twa03_def_rakarth",
				function()
					for k, v in pairs(self.bad_luck_modifiers) do
						if self.display_debug then
							out.design("Rakarth is starting his turn with a bad luck modifier of "..tostring(v).." in category "..k)
						end
						if v < self.bad_luck_modifier_soft_min then
							if self.display_debug then
								out.design("This is below "..self.bad_luck_modifier_soft_min.." so resetting to "..self.bad_luck_modifier_soft_min)
							end
							self.bad_luck_modifiers[k] = self.bad_luck_modifier_soft_min
						end
					end
				end,
				true)

		elseif cm:is_new_game() then
			self:setup_ai_merc_pool()
		end
	end
end

function RakarthBeastHunts:setup_quest_chain_completion_listener()
	core:add_listener(
		"Rakarth_QuestChainCompleted",
		"MissionSucceeded",
		function(context)
			return context:mission():mission_record_key():find("whip_of_agony_stage_2")
		end,
		function(context)
			--Grant Black Ark reward to pool
			cm:spawn_character_to_pool(self.rakarth_faction_key, "names_name_1602715018", "", "names_name_1270751732", "", 18, true, "general", "wh2_main_def_black_ark", false, "wh2_main_art_set_def_black_ark")
		end,
		true
	)
end

function RakarthBeastHunts:setup_clear_raided_settlements_listener()
	cm:add_faction_turn_start_listener_by_name(
		"RakarthFactionClearRaidedSettlements",
		self.rakarth_faction_key,
		function(context)
			self.settlements_beast_raided_this_turn = {}
		end,
		true
	)
end

function RakarthBeastHunts:setup_settlement_occupation_listener()
	core:add_listener(
		"RakarthFactionCharacterPerformsSettlementOccupationDecision",
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			local settlement_option = context:settlement_option()
			if not self:is_char_rakarth_general_with_army(context:character()) or context:occupation_decision() == self.occupation_do_nothing then
				return false
			end

			local has_already_been_sacked = false

			if has_already_been_sacked then
				return false
			end

			return true
		end,
		function(context)
			local previous_owner_culture = context:previous_owner_culture()

			if previous_owner_culture == nil or self.rakarth_incidents.settlement_occupation[previous_owner_culture] == nil then
				return false
			end

			local event_type = "settlement_occupation"
			local garrison_residence = context:garrison_residence()
			local modifiers = self.bad_luck_modifiers[event_type]
			local character_rank = context:character():rank()

			modifiers = modifiers + character_rank

			if context:character():has_skill(RakarthBeastHunts.rakarth_skill_key) then
				modifiers = modifiers + RakarthBeastHunts.rakarth_skill_bonus_chance
			end

			if RakarthBeastHunts:is_occupied_residence_province_capital(garrison_residence) then
				modifiers = modifiers + RakarthBeastHunts.province_capital_modifier
			end

			if self.display_debug then
				out.design("Rakarth has occupied a settlement belonging to "..previous_owner_culture)
			end

			self:generate_beast_incident(event_type, previous_owner_culture, modifiers, context:character():command_queue_index(), context:garrison_residence():settlement_interface():key())
		end,
		true
	)
end

function RakarthBeastHunts:setup_post_battle_listener()
	core:add_listener(
		"RakarthFactionCharacterCompletedBattle",
		"CharacterCompletedBattle",
		function(context)
			if not context:pending_battle():has_contested_garrison() and self:is_char_rakarth_general_with_army(context:character()) and self:rakarth_faction_won_battle(context:pending_battle()) then
				return true
			end
		end,
		function(context)
			local pending_battle = context:pending_battle()
			local character = context:character()
			local casualty_coefficient = self:get_casualty_coefficient(pending_battle)
			local event_type = "post_battle"
			local beast_incident_generated = false
			local battle_type = "land"
			local character_rank = context:character():rank()

			local modifiers = self.bad_luck_modifiers[event_type] + (casualty_coefficient*50)
			modifiers = modifiers + character_rank
			if character:has_skill(RakarthBeastHunts.rakarth_skill_key) then
				modifiers = modifiers + RakarthBeastHunts.rakarth_skill_bonus_chance
			end

		
			if self:is_character_at_sea(character) then
				battle_type = "naval"
			elseif self:is_underway_battle(pending_battle) then
				battle_type = "underway"
			end
			
			beast_incident_generated = self:generate_beast_incident(event_type, battle_type, modifiers, character:command_queue_index())
		
			---if you didn't get a beast from the first roll, give a bonus roll if you choose to slaughter.
			if not beast_incident_generated then
				if self.display_debug then
					out.design("Beast incident failed, setting up slaughter listener")
				end
				RakarthBeastHunts:setup_slaughter_listener(battle_type, modifiers)
			end

		end,
		true
	)
end

function RakarthBeastHunts:setup_raiding_listener()
	core:add_listener(
		"RakarthFactionCharacterTurnStart",
		"CharacterTurnStart",
		function(context)
			local character = context:character()
			return self:is_char_rakarth_general_with_army(character) and self:character_is_raiding(character)
		end,
		function(context)
			local character = context:character()
			local climate_key = self:get_local_climate_from_character(character)
			local corruption_type, chaos_corruption = cm:get_highest_corruption_in_region(character:region(), self.chaos_corruption_types)
			local event_type = "raiding"
			local modifiers = self.bad_luck_modifiers[event_type]
			local character_rank = context:character():rank()

			modifiers = modifiers + character_rank

			if character:has_skill(RakarthBeastHunts.rakarth_skill_key) then
				modifiers = modifiers + RakarthBeastHunts.rakarth_skill_bonus_chance
			end

			local corrupted_incident = false
			local corruption_factor = 0

			if chaos_corruption > self.chaos_corruption_min_threshold then
				-- There's a level of chaos corruption above which only chaos beasts can be captured in a province.
				corruption_factor = math.min((chaos_corruption - self.chaos_corruption_min_threshold) / (self.chaos_corruption_max_threshold - self.chaos_corruption_min_threshold) * 100, 100)
				corrupted_incident = cm:random_number() < corruption_factor
			end

			if corrupted_incident then
				-- The chance of getting a chaos beast in itself also increases as the level of corruption increases.
				self:generate_beast_incident(event_type, "chaos_corrupted", modifiers + (corruption_factor * self.chaos_corruption_increased_luck / 100), character:command_queue_index())
			elseif self:is_relevant_climate(climate_key) then
				self:generate_beast_incident(event_type, climate_key, modifiers, character:command_queue_index())
			end
		end,
		true
	)
end

function RakarthBeastHunts:setup_war_with_old_world_empire_listener()
	core:add_listener(
		"RakarthFactionNegativeDiplomaticEvent",
		"NegativeDiplomaticEvent",
		function (context)
			if context:is_war() then
				local proposer = context:proposer()
				local recipient = context:recipient()

				local at_war_with = nil

				if proposer:name() == self.rakarth_faction_key then
					at_war_with = recipient
				elseif recipient:name() == self.rakarth_faction_key then
					at_war_with = proposer
				else
					return false
				end

				return at_war_with:is_contained_in_faction_set(self.zoo_raid_trigger_faction_set)
			else
				return false
			end
		end,
		function (context)
			cm:trigger_mission(self.rakarth_faction_key, self.zoo_raid_mission, false)
		end,
		false
	)
end

function RakarthBeastHunts:setup_slaughter_listener(battle_type, luck_modifier)
	core:add_listener(
		"RakarthFactionCharacterPostBattleSlaughter",
		"CharacterPostBattleSlaughter",
		true,
		function(context)
			local event_type = "post_battle"
			self:generate_beast_incident(event_type, battle_type, luck_modifier, context:character():command_queue_index())
			core:remove_listener("RakarthFactionCharacterPostBattleEnslave")
			core:remove_listener("RakarthFactionCharacterPostBattleRelease")
		end,
		false
	)

	--we also need to set up listeners for the other choices so that we can remove the slaughter one if it's not chosen
	core:add_listener(
		"RakarthFactionCharacterPostBattleEnslave",
		"CharacterPostBattleEnslave",
		true,
		function()
			core:remove_listener("RakarthFactionCharacterPostBattleSlaughter")
			core:remove_listener("RakarthFactionCharacterPostBattleRelease")
		end,
		false
	)

	core:add_listener(
		"RakarthFactionCharacterPostBattleRelease",
		"CharacterPostBattleRelease",
		true,
		function()
			core:remove_listener("RakarthFactionCharacterPostBattleEnslave")
			core:remove_listener("RakarthFactionCharacterPostBattleSlaughter")
		end,
		false
	)

end

-- Get a random incident from the given event type and context, usiong the incidents' 'chance' value for weighted randomness.
-- A 'reduce chance of getting nothing' number can be argued. If 100, the chance of getting nothing is reduced by 100%, and you're guaranteed to get an incident.
function RakarthBeastHunts:get_weighted_random_outcome(event_type, event_context, reduce_chance_of_getting_nothing_by)
	local reduce_chance_of_getting_nothing_by = math.min(reduce_chance_of_getting_nothing_by, 100)

	local error_signature = string.format("beast-hunt incident pool ('%s', '%s')", event_type, event_context)
	if self.rakarth_incidents[event_type] == nil or self.rakarth_incidents[event_type][event_context] == nil then
		script_error(string.format("ERROR: Could not get weighted random beast-hunt outcome for '%s'. No such beast-pool with this type or context has been defined.",
			error_signature))
		return nil
	end
	local beast_incident_pool = self.rakarth_incidents[event_type][event_context]

	local sum_chance = 0
	local disallowed_incidents = {}
	for _, value in ipairs(beast_incident_pool) do
		if value.dlc ~= nil and not cm:faction_has_dlc_or_is_ai(value.dlc, self.rakarth_faction_key) then
			disallowed_incidents[value.incident] = true
		else
			sum_chance = sum_chance + value.chance
		end
	end
	if sum_chance > 100 then
		script_error(string.format("ERROR: '%s' has a chance sum greater than 100. The chances of each incident should add up to 100 or less (in which case the remainder is the chance that nothing happens).",
			error_signature))
		return nil
	end

	-- Say we have one option at 40% probability, the next at 40%, and the remaining 20% is 'nothing'.
	-- If you argue 50 as the reduce_chance_of_getting_nothing_by, the chance for 'nothing' is effectively reduced from 20 to 10.
	-- If you argue 100 as the reduce_chance_of_getting_nothing_by, the 20% chance to get nothing is removed entirely.
	local chance_of_getting_nothing = math.floor((100 - sum_chance) * (100 - reduce_chance_of_getting_nothing_by) / 100)
	local rand = cm:random_number(sum_chance + chance_of_getting_nothing)

	local cumulative_chance = 0
	local selected_incident = nil
	for _, value in ipairs(beast_incident_pool) do
		if disallowed_incidents[value.incident] == nil then
			cumulative_chance = cumulative_chance + value.chance
			if rand <= cumulative_chance then
				selected_incident = value.incident
				break
			end
		end
	end
	return selected_incident
end

---CORE FUNCTIONS

function RakarthBeastHunts:generate_beast_incident(event_type, event_context, chance_mod, acting_character_cqi, settlement)
	-- Disallow getting beasts from the same settlement twice per turn (helps avoid double-dipping by sacking then razing)
	if settlement ~= nil and self.settlements_beast_raided_this_turn[settlement] then
		return false
	end

	local beast_incident_key = self:get_weighted_random_outcome(event_type, event_context, chance_mod)
	local cqi_for_incident = 0

	if is_number(acting_character_cqi) then
		cqi_for_incident = acting_character_cqi
	end

	if self.display_debug then
		out.design("generate_beast_incident called with event_type: "..event_type.." and event_context "..event_context)
	end

	if beast_incident_key then
		self.incident_count = self.incident_count + 1
		core:trigger_event("ScriptEventRakarthBeastIncidentGenerated", beast_incident_key)

		local rakarth_faction_cqi = cm:get_faction(self.rakarth_faction_key):command_queue_index()
		cm:trigger_incident_with_targets(rakarth_faction_cqi, beast_incident_key,0,0,cqi_for_incident,0,0,0)

		if settlement ~= nil then
			self.settlements_beast_raided_this_turn[settlement] = true
		end

		beast_incident_generated = true
	end

	if beast_incident_key == nil then
		if self.bad_luck_modifiers[event_type] < self.bad_luck_modifier_max then
			self.bad_luck_modifiers[event_type] = self.bad_luck_modifiers[event_type] + self.bad_luck_modifier_increment
		else
			self.bad_luck_modifiers[event_type] = self.bad_luck_modifier_max
		end

		if self.display_debug then
			out.design("No incident generated, increasing bad luck modifier for "..event_type.."to "..tostring(self.bad_luck_modifiers[event_type]))
		end
	else
		if self.bad_luck_modifiers[event_type] >= self.bad_luck_modifier_min then
			if self.bad_luck_modifiers[event_type] > self.bad_luck_modifier_max then 
				self.bad_luck_modifiers[event_type] = self.bad_luck_modifier_max
			end
			self.bad_luck_modifiers[event_type] = self.bad_luck_modifiers[event_type] + self.streak_prevention_value
		else
			self.bad_luck_modifiers[event_type] = self.bad_luck_modifier_min 
		end

		if self.display_debug then
			out.design("Incident generated, decreasing bad luck modifier for "..event_type.." to "..tostring(self.bad_luck_modifiers[event_type]))
		end
	end

	return beast_incident_generated
end

--- for the AI, we simply overwrite the merc pool setup with one that fills up automatically via code

function RakarthBeastHunts:setup_ai_merc_pool()
	local rakarth_interface = cm:get_faction(self.rakarth_faction_key)
	local sum_chances = 0
	for i, v in pairs(self.ai_units) do
		sum_chances = sum_chances + v[4]
	end

	-- If the desired AI replenish rate is 75% chance of getting a beast each turn, but the sum chances are 100, then 100 / 75 = 0.75, so all chances are downscaled by this.
	local ai_chance_scale = sum_chances / self.ai_unit_per_turn_sum_chance

	for i, v in pairs(self.ai_units) do
		cm:add_unit_to_faction_mercenary_pool(
			rakarth_interface,
			v[1], -- key
			v[2], -- recruitment source
			v[3], -- count
			v[4] * ai_chance_scale, --replen chance
			v[5], -- max units
			1, -- max per turn
			"",
			"",
			"",
			false,
			v[6] -- merc unit group
		)
	end	
end

--- QUERY FUNCTIONS

function RakarthBeastHunts:is_char_rakarth_general_with_army(character)
	if character:is_null_interface() then
		script_error("Function RakarthBeastHunts:is_char_rakarth_general_with_army() called without valid character interface")
		return false
	elseif not cm:char_is_mobile_general_with_army(character) then
		return false
	else 
		return character:faction():name() == self.rakarth_faction_key
	end
end

function RakarthBeastHunts:get_local_climate_from_character(character)

	local region_interface

	if character:is_null_interface() then
		script_error("Function RakarthBeastHunts:get_local_climate_from_character() called without valid character interface")
		return false
	elseif not character:has_region() then
		script_error("Function RakarthBeastHunts:get_local_climate_from_character() called for a character without a region")
		return false
	else 
		region_interface = character:region()
	end

	local settlement = region_interface:settlement()

	if not settlement:is_null_interface() then
		return settlement:get_climate()
	else 
		return false
	end
end

function RakarthBeastHunts:is_relevant_climate(climate_key)
	if climate_key == false then
		return false
	elseif not is_string(climate_key) then
		script_error("Function RakarthBeastHunts:is_relevant_climate() is trying to pass a climate key that is not false or a string")
		return false
	end

	local relevant_climates_table = self.rakarth_incidents["raiding"]

	if relevant_climates_table[climate_key] == nil then 
		return false
	else
		return true
	end
end

function RakarthBeastHunts:is_underway_battle(pending_battle)
	if pending_battle:is_null_interface() then
		script_error("Function RakarthBeastHunts:is_underway_battle() called without valid pending battle interface")
		return false
	end

	if not cm:pending_battle_cache_faction_is_attacker(self.rakarth_faction_key) then
		return false
	end

	local num_defenders = cm:pending_battle_cache_num_defenders()

	for i =1, num_defenders do
		local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_defender(i)
		local force_interface = cm:get_military_force_by_cqi(mf_cqi)
		if force_interface:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_TUNNELING" then
			local defender_culture = cm:get_faction(faction_name):culture()
			if self.underway_cultures[defender_culture] then
				return true
			end
		end
	end


	return false
end

function RakarthBeastHunts:is_character_at_sea(character)
	if character:is_null_interface() then
		script_error("Function RakarthBeastHunts:is_character_at_sea() called without valid character")
		return false
	else
		return character:is_at_sea()
	end
end

function RakarthBeastHunts:get_casualty_coefficient(pending_battle)
	if pending_battle:is_null_interface() then
		script_error("Function RakarthBeastHunts:get_casualty_coefficient() called without valid pending battle interrface")
		return false
	end
	local attacker_value = cm:pending_battle_cache_attacker_value()
	local defender_value = cm:pending_battle_cache_defender_value()

	local overall_value = attacker_value + defender_value

	local attacker_ratio = attacker_value/overall_value
	local defender_ratio = 1 - attacker_ratio

	local defender_casualties = pending_battle:percentage_of_defender_killed()
	local attacker_casualties = pending_battle:percentage_of_attacker_killed()

	local weighted_attacker_casualties = attacker_ratio*attacker_casualties
	local weighted_defender_casualties = defender_ratio*defender_casualties

	local total_casualties = weighted_attacker_casualties + weighted_defender_casualties

	return  tonumber(string.format("%." .. 2 .. "f", total_casualties))
end

function RakarthBeastHunts:is_occupied_residence_province_capital(garrison_residence)
	local settlement = garrison_residence:settlement_interface()
	if settlement:is_null_interface() then
		script_error("Function RakarthBeastHunts:is_occupied_residence_province_capital() called without valid settlement")
		return false
	end
	return settlement:region():is_province_capital()

end

function RakarthBeastHunts:character_is_raiding(character)
	if character:is_null_interface() then
		script_error("Function RakarthBeastHunts:character_is_raiding() called without valid character")
		return false

	elseif not character:has_military_force() then
		return false

	elseif character:military_force():active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID" then
		return true

	else 
		return false

	end
end

function RakarthBeastHunts:rakarth_faction_won_battle(pending_battle)
	if pending_battle:is_null_interface() then
		script_error("Function RakarthBeastHunts:rakarth_faction_won_land_battle() called without valid pending battle interrface")
		return false
	end

	local winner_faction_key = ""

	if pending_battle:has_attacker() then
		local attacker_faction_key = pending_battle:attacker():faction():name()
		if pending_battle:attacker():won_battle() then
			winner_faction_key = attacker_faction_key
		end
	end

	if pending_battle:has_defender() then
		local defender_faction_key = pending_battle:defender():faction():name()
		if pending_battle:defender():won_battle() then
			winner_faction_key = defender_faction_key
		end
	end

	if winner_faction_key == self.rakarth_faction_key then
		return true
	else
		return false
	end
end

----save/load

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("RakarthBadLuckModifiers", RakarthBeastHunts.bad_luck_modifiers, context)
		cm:save_named_value("RakarthIncidentCount", RakarthBeastHunts.incident_count, context)
		cm:save_named_value("RakarthSettlementsBeastRaidedThisTurn", RakarthBeastHunts.settlements_beast_raided_this_turn, context)
	end
)
cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			RakarthBeastHunts.bad_luck_modifiers = cm:load_named_value("RakarthBadLuckModifiers", RakarthBeastHunts.bad_luck_modifiers, context)
			RakarthBeastHunts.incident_count = cm:load_named_value("RakarthIncidentCount", RakarthBeastHunts.incident_count, context)
			RakarthBeastHunts.settlements_beast_raided_this_turn = cm:load_named_value("RakarthSettlementsBeastRaidedThisTurn", RakarthBeastHunts.settlements_beast_raided_this_turn, context)
		end
	end
)