college_of_magic = {
	faction_key = "wh2_dlc13_emp_golden_order",
	gelt_name_key = "names_name_2147343922",
	wizard_cap = {
		current_cap = 0,
		amount_to_increase = 1, 
		effect_bundle = "wh3_dlc25_college_of_magic_wizard_cap",
		effect = "wh_main_effect_agent_cap_increase_wizard_empire"
	},
	treasury_transmute_amount = 2000,
	proportion_damage = 0.3,
	rituals = {
		["wh3_dlc25_college_of_magic_wizard_"] = function() college_of_magic:increase_cap(college_of_magic.wizard_cap) end,
		["wh3_dlc25_college_of_magic_jade_heal"] = function(context) college_of_magic:heal_army(context:ritual():ritual_target():get_target_force()) end,
		["wh3_dlc25_college_of_magic_celestial_action_points"] = function(context) college_of_magic:replenish_action_points(context:ritual():ritual_target():get_target_force()) end,
		["wh3_dlc25_college_of_magic_amethyst_damage_enemies"] = function(context) college_of_magic:damage_enemy_forces(context:ritual():ritual_target():get_target_force()) end,
	},
	ritual_locks = {
		["wh3_dlc25_college_of_magic_wizard_amber"] = {
			unlocked = false,
			incident_key = "wh3_dlc25_incident_com_unlocked_amber",
			agent_subtype = "wh_dlc03_emp_amber_wizard",
			"wh3_dlc25_college_of_magic_amber_cata_spell",
			"wh3_dlc25_college_of_magic_amber_costs",
			"wh3_dlc25_college_of_magic_amber_item",
			"wh3_dlc25_college_of_magic_amber_summon",
		},
		["wh3_dlc25_college_of_magic_wizard_amethyst"] = {
			unlocked = false,
			incident_key = "wh3_dlc25_incident_com_unlocked_amethyst",
			agent_subtype = "wh2_pro07_emp_amethyst_wizard",
			"wh3_dlc25_college_of_magic_amethyst_cata_spell",
			"wh3_dlc25_college_of_magic_amethyst_costs",
			"wh3_dlc25_college_of_magic_amethyst_damage_enemies",
			"wh3_dlc25_college_of_magic_amethyst_item",
		},
		["wh3_dlc25_college_of_magic_wizard_bright"] = {
			unlocked = false,
			incident_key = "wh3_dlc25_incident_com_unlocked_bright",
			agent_subtype = "wh_main_emp_bright_wizard",
			"wh3_dlc25_college_of_magic_bright_cata_spell",
			"wh3_dlc25_college_of_magic_bright_costs",
			"wh3_dlc25_college_of_magic_bright_damage_walls",
			"wh3_dlc25_college_of_magic_bright_item",
		},
		["wh3_dlc25_college_of_magic_wizard_celestial"] = {
			unlocked = false,
			incident_key = "wh3_dlc25_incident_com_unlocked_celestial",
			agent_subtype = "wh_main_emp_celestial_wizard",
			"wh3_dlc25_college_of_magic_celestial_action_points",
			"wh3_dlc25_college_of_magic_celestial_cata_spell",
			"wh3_dlc25_college_of_magic_celestial_costs",
			"wh3_dlc25_college_of_magic_celestial_item",
		},
		["wh3_dlc25_college_of_magic_wizard_grey"] = {
			unlocked = false,
			incident_key = "wh3_dlc25_incident_com_unlocked_grey",
			agent_subtype = "wh_dlc05_emp_grey_wizard",
			"wh3_dlc25_college_of_magic_grey_ambush_attack",
			"wh3_dlc25_college_of_magic_grey_cata_spell",
			"wh3_dlc25_college_of_magic_grey_costs",
			"wh3_dlc25_college_of_magic_grey_item",
		},
		["wh3_dlc25_college_of_magic_wizard_jade"] = {
			unlocked = false,
			incident_key = "wh3_dlc25_incident_com_unlocked_jade",
			agent_subtype = "wh_dlc05_emp_jade_wizard",
			"wh3_dlc25_college_of_magic_jade_cata_spell",
			"wh3_dlc25_college_of_magic_jade_costs",
			"wh3_dlc25_college_of_magic_jade_heal",
			"wh3_dlc25_college_of_magic_jade_item",
		},
		["wh3_dlc25_college_of_magic_wizard_light"] = {
			unlocked = false,
			incident_key = "wh3_dlc25_incident_com_unlocked_light",
			agent_subtype = "wh_main_emp_light_wizard",
			"wh3_dlc25_college_of_magic_light_barrier",
			"wh3_dlc25_college_of_magic_light_cata_spell",
			"wh3_dlc25_college_of_magic_light_costs",
			"wh3_dlc25_college_of_magic_light_item",
		}
	},
	sbv_wizards_in_army = "wizards_in_gelts_army",
	disable_pr_effect_bundle = "wh3_dlc25_disable_post_battle_pooled_resource",
	current_mf_cqis = {},
	wizard_spawned = false,
	ai_income = {
		[1] = 50,
		[2] = 50,
		[3] = 75,
		[4] = 100,
		[5] = 100
	}
}

function college_of_magic:initialise()
	core:add_listener(
		"CollegeOfMagicRitual",
		"RitualCompletedEvent",
		function(context)
			local ritual_key = context:ritual():ritual_key()

			return self.rituals[ritual_key] ~= nil or string.starts_with(ritual_key, "wh3_dlc25_college_of_magic_wizard_")
		end,
		function(context)
			local ritual_key = context:ritual():ritual_key()

			if string.starts_with(ritual_key, "wh3_dlc25_college_of_magic_wizard_") then
				ritual_key = "wh3_dlc25_college_of_magic_wizard_"
			end
			
			self.rituals[ritual_key](context)
		end,
		true
	)

	core:add_listener(
		"CollegeOfMagicRitualUnlocks",
		"RitualCompletedEvent",
		function(context)
			local ritual_key = context:ritual():ritual_key()

			return self.ritual_locks[ritual_key] ~= nil and self.ritual_locks[ritual_key].unlocked == false
		end,
		function(context)
			local ritual_key = context:ritual():ritual_key()
			local unlocks_list = self.ritual_locks[ritual_key]

			self:unlock_college_rituals(unlocks_list)
		end,
		true
	)

	core:add_listener(
		"CollegeOfMagicRitualUnlocksRecruitment",
		"CharacterRecruited",
		true,
		function(context)
			local character = context:character()
			for _, unlocks_list in pairs(self.ritual_locks) do
				if unlocks_list.unlocked == false and character:faction():name() == self.faction_key and character:character_subtype_key() == unlocks_list.agent_subtype then
					self:unlock_college_rituals(unlocks_list)
					return
				end
			end
		end,
		true
	)

	core:add_listener(
		"CollegeOfMagicPRGain",
		"PendingBattle",
		function(context)
			-- Find out if gelt's faction is in a battle and save the CQI.
			self.current_mf_cqis = {}
			local gelt_faction_in_battle = false

			local attacker = context:pending_battle():attacker()
			if attacker:faction():name() == self.faction_key then
				table.insert(self.current_mf_cqis, attacker:military_force():command_queue_index())
				gelt_faction_in_battle = true
			end

			local defender = context:pending_battle():defender()
			if defender:faction():name() == self.faction_key then
				table.insert(self.current_mf_cqis, defender:military_force():command_queue_index())
				gelt_faction_in_battle = true
			end

			local attacker_list = context:pending_battle():secondary_attackers()
			for i = 0, attacker_list:num_items() - 1 do
				local attacker = attacker_list:item_at(i)

				if attacker:faction():name() == self.faction_key then
					table.insert(self.current_mf_cqis, attacker:military_force():command_queue_index())
					gelt_faction_in_battle = true
				end
			end

			local defender_list = context:pending_battle():secondary_defenders()
			for i = 0, defender_list:num_items() - 1 do
				local defender = defender_list:item_at(i)

				if defender:faction():name() == self.faction_key then
					table.insert(self.current_mf_cqis, defender:military_force():command_queue_index())
					gelt_faction_in_battle = true
				end
			end

			return gelt_faction_in_battle
		end,
		function()
			for k, mf_cqi in ipairs(self.current_mf_cqis) do
				local mf = cm:get_military_force_by_cqi(mf_cqi)

				if mf:has_effect_bundle(self.disable_pr_effect_bundle) then
					cm:remove_effect_bundle_from_force(self.disable_pr_effect_bundle, mf_cqi)
				end

				if self:get_wizards_in_army_count(mf) == 0 then
					cm:apply_effect_bundle_to_force(self.disable_pr_effect_bundle, mf_cqi, 1)
				end
			end
		end,
		true
	)

	-- remove the debuff once battle is complete
	core:add_listener(
		"CollegeOfMagicRemoveDebuff",
		"BattleCompleted",
		function()
			return cm:pending_battle_cache_faction_is_involved(self.faction_key)
		end,
		function()
			for _, mf in model_pairs(cm:get_faction(self.faction_key):military_force_list()) do
				if mf:has_effect_bundle(self.disable_pr_effect_bundle) then
					cm:remove_effect_bundle_from_force(self.disable_pr_effect_bundle, mf:command_queue_index())
				end
			end
		end,
		true
	)

	core:add_listener(
		"RitualWizardSpawned",
		"RitualStartedEvent",
		function(context)
			local ritual_key = context:ritual():ritual_key()

			return string.starts_with(ritual_key, "wh3_dlc25_college_of_magic_wizard_")
		end,
		function(context)			
			self.wizard_spawned = true
		end,
		true
	)

	core:add_listener(
		"RitualWizardSAP",
		"CharacterCreated",
		function(context)
			return context:character():faction():name() == self.faction_key and self.wizard_spawned
		end,
		function(context)
			local character = context:character()

			cm:callback(
				function()
					cm:replenish_action_points(cm:char_lookup_str(character))
				end,
				0.2
			)
			
			self.wizard_spawned = false
		end,
		true
	)

	core:add_listener(
		"GeltAIIncome",
		"FactionTurnStart",
		function(context)
			local faction = context:faction()
			return faction:name() == self.faction_key and faction:is_human() == false
		end,
		function(context)
			local difficulty = cm:get_difficulty()

			cm:faction_add_pooled_resource(self.faction_key, "wh3_dlc25_emp_arcane_essays", "other", self.ai_income[difficulty])
		end,
		true
	)
end

function college_of_magic:unlock_college_rituals(unlocks_list)
	unlocks_list.unlocked = true

	for _, ritual_key in ipairs(unlocks_list) do
		out.design("Unlocking ritual: "..ritual_key)
		cm:unlock_ritual(cm:get_faction(self.faction_key), ritual_key, 0)
	end

	cm:trigger_incident(self.faction_key, unlocks_list.incident_key, true, true)
end

function college_of_magic:get_wizards_in_army_count(mf)
	local wizard_count = cm:get_forces_bonus_value(mf, self.sbv_wizards_in_army)
	
	if is_number(wizard_count) then
		return wizard_count
	end

	return 0
end

function college_of_magic:increase_cap(cap_table)
	cap_table.current_cap = cap_table.current_cap + cap_table.amount_to_increase

	local effect_bundle = cm:create_new_custom_effect_bundle(cap_table.effect_bundle)

	effect_bundle:set_duration(0)
	effect_bundle:add_effect(cap_table.effect, "faction_to_faction_own", cap_table.current_cap)

	cm:apply_custom_effect_bundle_to_faction(effect_bundle, cm:get_faction(self.faction_key))
end

function college_of_magic:heal_army(force)
	cm:heal_military_force(force)
end

function college_of_magic:replenish_action_points(force)
	local char_mf_general = cm:char_lookup_str(force:general_character())
	cm:replenish_action_points(char_mf_general)
end

function college_of_magic:damage_enemy_forces(force)
	local region = force:general_character():region()
	local enemy_mf_list = self:get_enemy_military_force_list_in_region(region)

	for _, mf in ipairs(enemy_mf_list) do
		local unit_list = mf:unit_list()

		for i = 0, unit_list:num_items() - 1 do
			local unit = unit_list:item_at(i)
			local current_health_proportion = unit:percentage_proportion_of_full_strength() / 100
			local new_health_value = current_health_proportion - self.proportion_damage

			if new_health_value <= 0 then
				cm:set_unit_hp_to_unary_of_maximum(unit, 0)
			else
				cm:set_unit_hp_to_unary_of_maximum(unit, new_health_value)
			end
		end
	end
end

function college_of_magic:get_enemy_military_force_list_in_region(region)
	local faction_list = cm:model():world():faction_list()
	local enemy_force_list = {}
	local player_faction = cm:get_faction(self.faction_key)

	for i = 0, faction_list:num_items() - 1 do
		local faction = faction_list:item_at(i)
		if player_faction:at_war_with(faction) then

			local character_list = faction:character_list()

			for j = 0, character_list:num_items() - 1 do
				local character = character_list:item_at(j)

				if character:has_military_force() and region == character:region() then
					table.insert(enemy_force_list, character:military_force())
				end
			end
		end
	end

	return enemy_force_list
end


------------------------------
---------SAVING/LOADING-------
------------------------------

cm:add_saving_game_callback(
	function(context)		
		cm:save_named_value("college_of_magic.wizard_cap", college_of_magic.wizard_cap, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			college_of_magic.wizard_cap = cm:load_named_value("college_of_magic.wizard_cap", college_of_magic.wizard_cap, context)
		end
	end
)