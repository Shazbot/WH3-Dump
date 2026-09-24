-- this table must be in the same order as the options in the cdir_events_dilemma_choice_details table
verminlords_config = {
	subtype_to_choice_mapping = {
	"wh3_dlc29_skv_verminlord_corruptor",
	"wh3_dlc29_skv_verminlord_deceiver",
	"wh3_dlc29_skv_verminlord_warpseer", 
	"wh3_dlc29_skv_verminlord_warbringer"
	},
	verminlord_on_spawn_setup = { 
		["wh3_dlc29_skv_verminlord_corruptor"] = {

		},
		["wh3_dlc29_skv_verminlord_deceiver"] = {
			ancillary = "wh3_dlc29_anc_weapon_warpstiletto"
		},
		["wh3_dlc29_skv_verminlord_warpseer"] = {
			ancillary = "wh3_dlc29_anc_enchanted_item_scry_orb"
		},
		["wh3_dlc29_skv_verminlord_warbringer"] = {
			ancillary = "wh3_dlc29_anc_weapon_punch_dagger"
		},
	},
	verminlord_names = {
		"1331680621",
		"1361676261",
		"1726557368",
		"1820342110",
		"2081252232",
		"239326550",
		"467538040",
		"495268925",
		"501304911",
		"575323163",
		"592894079"
	},
	empty_family_name = "names_name_2147360514",
	agent_type = "general",
	ritual_key = "wh3_main_ritual_skv_ascendancy_verminlord",
	tech_key = "wh3_dlc29_tech_skv_3_7_1",
	dilemma_key = "wh3_dlc29_ascendancy_summon_verminlord",
	skaven_culture = "wh2_main_skv_skaven",
	verminking_bonus_building = {
		chain = "wh2_dlc12_under_empire_settlement_warren",
		level = "wh2_dlc12_under_empire_settlement_warren_5",
		occupation_decision = "occupation_decision_establish_foreign_slot",
		required_skill = "wh3_dlc29_skill_skv_skreech_verminking_unique_3",
		check = function(self, faction)
			local characters = faction:character_list()
			for i = 0, characters:num_items() - 1 do
				local character = characters:item_at(i)
				if character:has_skill(self.required_skill)
					and character:is_alive()
					and not character:is_wounded()
				then
					return true
				end
			end
			return false
		end
	},
	spawn_plague_priest_on_occupation_decision = {
		check_decision = function(self, decision)
			return decision == "occupation_decision_establish_foreign_slot"
				or decision == "occupation_decision_sack"
				or decision == "occupation_decision_raze_without_occupy"
		end,
		required_general = "wh3_dlc29_skv_verminlord_corruptor",
		required_skill = "wh3_dlc29_skill_skv_verminlord_corruptor_unique_4",
		chance = 100,
		agent_record = "wizard",
		agent_subtype_record = "wh2_main_skv_plague_priest_ritual"
	},

	cai_turn_for_tech_reasearch_limit = 60
}






function add_verminlord_selection_listeners()
	out("#### Adding Verminlord Selection Listeners ####")

	core:add_listener(
		"Verminlord_CAITurnStart",
		"FactionTurnStart",
		function(context)
			local faction = context:faction()
			return not faction:is_human() and faction:culture() == verminlords_config.skaven_culture and cm:turn_number() >= verminlords_config.cai_turn_for_tech_reasearch_limit
		end,
		function(context)
			local faction = context:faction()
			
			if not faction:has_technology(verminlords_config.tech_key) then
				cm:instantly_research_technology(faction:name(), verminlords_config.tech_key, false)
			end
		end,
		true
	)
	
	core:add_listener(
		"Verminlord_RitualCompletedEvent",
		"RitualCompletedEvent",
		function(context)
			return not context:performing_faction():is_human() and context:succeeded() and context:ritual():ritual_key() == verminlords_config.ritual_key
		end,
		function(context)
			verminlord_spawn(context:performing_faction():name(), verminlords_config.subtype_to_choice_mapping[cm:random_number(#verminlords_config.subtype_to_choice_mapping)])
		end,
		true
	)
	
	
	core:add_listener(
		"slann_DilemmaChoiceMadeEvent",
		"DilemmaChoiceMadeEvent",
		function(context)
			return context:dilemma() == "wh3_dlc29_ascendancy_summon_verminlord"
		end,
		function(context)
			if context:choice() < 4 then
				verminlord_spawn(context:faction():name(), verminlords_config.subtype_to_choice_mapping[context:choice() + 1])
			end
		end,
		true
	)

	core:add_listener(
		"verminlords_spawned_on_map",
		"CharacterRecruited",
		function(context)
			local char_subtype = context:character():character_subtype_key()

			return verminlords_config.verminlord_on_spawn_setup[char_subtype]
		end,
		function(context)
			local char = context:character()
			local subtype = char:character_subtype_key()

			local lord_config = verminlords_config.verminlord_on_spawn_setup[subtype]
			if lord_config then 
				if lord_config.ancillary then
					cm:force_add_ancillary(char, lord_config.ancillary, true, false)
				end
			end
		end,
		false
	)
end



function verminlord_spawn(faction_key, subtype_key)
	cm:spawn_character_to_pool(faction_key, "names_name_" .. verminlords_config.verminlord_names[cm:random_number(#verminlords_config.verminlord_names)], verminlords_config.empty_family_name, "", "", 22, true, verminlords_config.agent_type, subtype_key, false, "")
end

function add_verminlord_occupation_listeners()
	--[[
	core:add_listener(
		"BuildUnderempireBonusBuildingAfterOccupationDecision",
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			local faction = context:character():faction()
			if faction:culture() ~= verminlords_config.skaven_culture then
				return false
			end

			local cfg = verminlords_config.verminking_bonus_building
			if context:settlement_option() ~= cfg.occupation_decision then
				return false
			end

			return cfg:check(faction)
		end,
		function(context)
			local faction = context:character():faction()
			local foreign_slot_manager = context:garrison_residence():region():foreign_slot_manager_for_faction(faction:name())
			if foreign_slot_manager == nil or foreign_slot_manager:is_null_interface() then
				script_error("WARNING: Failed to add foreign slot building, no foreign slot manager was found in " .. context:garrison_residence():region():name() .. " for " .. faction:name())
				return
			end

			local slots = foreign_slot_manager:slots()
			for i = 0, slots:num_items() - 1 do
				local slot = slots:item_at(i)
				local cfg = verminlords_config.verminking_bonus_building
				if not slot:has_building() or string.find(slot:building(), cfg.chain) ~= nil then
					cm:foreign_slot_instantly_upgrade_building(slot, cfg.level)
					break
				end
			end
		end,
		true
	)
	]]

	core:add_listener(
		"SpawnPlaguePriestAfterOccupationDecision",
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			local faction = context:character():faction()
			if faction:culture() ~= verminlords_config.skaven_culture then
				return false
			end

			local cfg = verminlords_config.spawn_plague_priest_on_occupation_decision
			if not cfg:check_decision(context:settlement_option()) then
				return false
			end

			local general_details = context:character():character_details()
			if general_details:character_subtype_key() ~= cfg.required_general then
				return false
			end

			if not general_details:has_skill(cfg.required_skill) then
				return false
			end

			return true
		end,
		function(context)
			local cfg = verminlords_config.spawn_plague_priest_on_occupation_decision
			local roll = cm:random_number(100, 1)
			if roll > cfg.chance then
				return
			end

			local faction = context:character():faction()
			local region_key = context:garrison_residence():region():name()
			local x, y = cm:find_valid_spawn_location_for_character_from_settlement(faction:name(), region_key, false, true, 3);
			local agent = cm:spawn_agent_at_position(faction, x, y, cfg.agent_record, cfg.agent_subtype_record)
			if not is_character(agent) then
				script_error("WARNING: skaven_SpawnPlaguePriestAfterOccupationDecision failed to spawn agent " .. cfg.agent_subtype_record);
			end
		end,
		true
	)
end
