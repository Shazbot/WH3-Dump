-- KHO - Arbaal - Wrath of Khorne feature
wrath_of_khorne = {
	faction_key = "wh3_dlc26_kho_arbaal",
	pooled_resource_key = "wh3_dlc26_kho_arbaal_wrath_of_khorne_progress",
	arbaal_subtype = "wh3_dlc26_kho_arbaal_the_undefeated",
	defeated_trait = "wh3_dlc26_trait_arbaal_lost_battle",
	bundle = "wh3_dlc26_arbaal_defeated",
	defeat_dilemma = "wh3_dlc26_arbaal_defeated",

	-- mission configuration:
		-- mission primary key
		-- mission titles
		-- mission descriptions
		-- mission strength
		-- mission rewards
		-- mission objective name -> objective = ENGAGE FORCE

	missions_config = {
		-- mission titles
		number_of_missions_per_type = {
			["easy"] = 3,
			["medium"] = 3,
			["hard"] = 2
		},
		primary_key = {
			["easy"] = {
				"wh3_dlc26_arbaal_wrath_of_khorne_mission_weak_1",
				"wh3_dlc26_arbaal_wrath_of_khorne_mission_weak_2",
				"wh3_dlc26_arbaal_wrath_of_khorne_mission_weak_3"
			},
			["medium"] = {
				"wh3_dlc26_arbaal_wrath_of_khorne_mission_medium_1",
				"wh3_dlc26_arbaal_wrath_of_khorne_mission_medium_2",
				"wh3_dlc26_arbaal_wrath_of_khorne_mission_medium_3"
			},
			["hard"] = {
				"wh3_dlc26_arbaal_wrath_of_khorne_mission_strong_1",
				"wh3_dlc26_arbaal_wrath_of_khorne_mission_strong_2",
				"wh3_dlc26_arbaal_wrath_of_khorne_mission_strong_3"
			}
		},

		mission_strength = {
			["easy"] = {strength_delta_min = -500000, strength_delta_max = 250000, force_size = {min = 5, max = 20}, spawned_force_size = 13, spawned_force_power = 5},
			["medium"] = {strength_delta_min = 250001, strength_delta_max = 1000000, force_size = {min = 5, max = 20}, spawned_force_size = 17, spawned_force_power = 7},
			["hard"] = {strength_delta_min = 1000001, strength_delta_max = 999999999, force_size = {min = 5, max = 20}, spawned_force_size = 19, spawned_force_power = 10}
		},
		
		-- mission rewards , these are represented through effect_bundles
		reward = {
			khorne_favour = {
				5, -- easy
				10, -- medium
				15, -- hard
			},
			skulls = {
				200, -- easy
				400, -- medium
				800, -- hard
			},
			effect_bundle = {
				cost_low = "wh3_dlc26_arbaal_wrath_of_khorne_mission_rewards_medium_2", -- gives average unit recruting cost reduction for 5 turns
				cost_high = "wh3_dlc26_arbaal_wrath_of_khorne_mission_rewards_strong_2", -- gives strong unit recruting cost reduction for 5 turns
				loot = "wh3_dlc26_arbaal_wrath_of_khorne_mission_rewards_strong_3", -- amplifies post battle loot by 50% for 5 turns
			},
			money = {
				2000, -- easy
				4000, -- medium
				8000, -- hard
			}
		},

		-- subcultures keys
		subculture_keys = {
			"wh_main_sc_emp_empire",
			"wh2_main_sc_hef_high_elves",
			"wh2_main_sc_lzd_lizardmen",
			"wh2_main_sc_def_dark_elves",
			"wh_main_sc_dwf_dwarfs",
			"wh_dlc05_sc_wef_wood_elves",
			"wh_main_sc_grn_greenskins"
		},
		-- list of cultures that can be used to spawn new armies
		subcultures = {
			["wh_main_sc_emp_empire"] = {faction_key = "wh2_dlc16_emp_empire_invasion", general_subtype = "wh_main_emp_lord", region_key = "wh3_main_combi_region_altdorf"},
			["wh2_main_sc_hef_high_elves"] = {faction_key = "wh3_dlc26_hef_high_elves_invasion", general_subtype = "wh2_main_hef_prince", region_key = "wh3_main_combi_region_lothern"},
			["wh2_main_sc_lzd_lizardmen"] = {faction_key = "wh3_dlc24_lzd_lizardmen_invasion", general_subtype = "wh2_main_lzd_saurus_old_blood", region_key = "wh3_main_combi_region_itza"},
			["wh2_main_sc_def_dark_elves"] = {faction_key = "wh3_dlc26_def_dark_elves_invasion", general_subtype = "wh2_main_def_dreadlord", region_key = "wh3_main_combi_region_naggarond"},
			["wh_main_sc_dwf_dwarfs"] = {faction_key = "wh3_dlc26_dwf_dwarfs_invasion", general_subtype = "wh_main_dwf_lord", region_key = "wh3_main_combi_region_karaz_a_karak"},
			["wh_dlc05_sc_wef_wood_elves"] = {faction_key = "wh3_dlc25_wef_wood_elves_invasion", general_subtype = "wh_dlc05_wef_glade_lord", region_key = "wh3_main_combi_region_the_oak_of_ages"},
			["wh_main_sc_grn_greenskins"] = {faction_key = "wh2_dlc16_grn_savage_invasion", general_subtype = "wh3_dlc26_grn_savage_orc_great_shaman", region_key = "wh3_main_combi_region_ekrund"},
		},
		
		-- mission objective name -> objective = ENGAGE_FORCE
		objective = "ENGAGE_FORCE",
	},

	-- CAI variables
	cai_config = 
	{
		bloodhost_cooldown = 14,
		bloodhost_cooldown_counter = 0,
	}
}

function wrath_of_khorne:initialise()
	if not cm:get_faction(self.faction_key) then return end
	
	if not cm:get_saved_value("wrath_of_khorne_challenges_active") and cm:get_faction(self.faction_key):is_human() then
		cm:override_ui("disable_wrath_of_khorne_button", true)

		core:add_listener(
			"wrath_of_khorne_unlock_button",
			"PooledResourceChanged",
			function(context)
				local pr = context:resource()
				return pr:key() == self.pooled_resource_key and pr:value() >= 5 and context:faction():is_human()
			end,
			function(context)
				cm:override_ui("disable_wrath_of_khorne_button", false)
				cm:set_saved_value("wrath_of_khorne_challenges_active", true)

				self:generate_challenges(context:faction(), false)
			end,
			false
		)
	end

	core:add_listener(
		"wrath_of_khorne_sort_armies",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == self.faction_key
		end,
		function(context)
			local faction = context:faction()

			if faction:is_human() then
				if cm:get_saved_value("wrath_of_khorne_challenges_active") then
					self:generate_challenges(faction, true)
				end
			else
				-- AI behaviour
				out.design("Arbaal is not human, skipping the mission generation")
				if wrath_of_khorne.cai_config.bloodhost_cooldown_counter < wrath_of_khorne.cai_config.bloodhost_cooldown then 
					wrath_of_khorne.cai_config.bloodhost_cooldown_counter = wrath_of_khorne.cai_config.bloodhost_cooldown_counter + 1
				end
			end
		end,
		true
	)

	-- apply factionwide bonuses after a challenge mission is completed
	core:add_listener(
		"wrath_of_khorne_mission_completed",
		"MissionSucceeded",
		function(context)
			local faction = context:faction()
			return faction:name() == self.faction_key and faction:has_faction_leader() and context:mission():mission_record_key():starts_with("wh3_dlc26_arbaal_wrath_of_khorne_mission_")
		end,
		function(context)
			local khorne_favour_bv = cm:get_factions_bonus_value(context:faction(), "arbaal_challenge_khorne_favour")

			if khorne_favour_bv > 0 then
				cm:faction_add_pooled_resource(self.faction_key, self.pooled_resource_key, "challenges", khorne_favour_bv)
			end
		end,
		true
	)

	-- apply bonuses when a battle is initiated
	core:add_listener(
		"wrath_of_khorne_pending_battle",
		"PendingBattle",
		function(context)
			local pb = context:pending_battle()

			return (pb:has_attacker() and pb:has_defender()) and (pb:attacker():faction():name() == self.faction_key or pb:defender():faction():name() == self.faction_key)
		end,
		function(context)
			local pb = context:pending_battle()
			local arbaal = nil
			local enemy = nil

			if pb:defender():faction():name() == self.faction_key then
				arbaal = pb:defender()
				enemy = pb:attacker()
			else
				arbaal = pb:attacker()
				enemy = pb:defender()
			end
			
			if cm:get_factions_bonus_value(self.faction_key, "arbaal_challenge_buff") > 0 then
				if enemy:has_military_force() then
					cm:apply_effect_bundle_to_force("wh3_dlc26_bundle_arbaal_challenge_buff", enemy:military_force():command_queue_index(), 0)
				end
			end

			if cm:get_factions_bonus_value(self.faction_key, "arbaal_challenge_debuff") > 0 then
				if arbaal:has_military_force() then
					cm:apply_effect_bundle_to_force("wh3_dlc26_bundle_arbaal_challenge_debuff", arbaal:military_force():command_queue_index(), 0)
				end
			end

			cm:update_pending_battle()
		end,
		true
	)

	-- apply effects after a battle finishes
	core:add_listener(
		"wrath_of_khorne_cleanup",
		"BattleCompleted",
		function()
			return cm:pending_battle_cache_faction_is_involved(self.faction_key)
		end,
		function()
			local pb = cm:model():pending_battle()

			local function remove_effect_bundles(mf_cqi)
				local mf = cm:get_military_force_by_cqi(mf_cqi)
				if not mf then return end

				if mf:has_effect_bundle("wh3_dlc26_bundle_arbaal_challenge_buff") then
					cm:remove_effect_bundle_from_force("wh3_dlc26_bundle_arbaal_challenge_buff", mf_cqi)
				end

				if mf:has_effect_bundle("wh3_dlc26_bundle_arbaal_challenge_debuff") then
					cm:remove_effect_bundle_from_force("wh3_dlc26_bundle_arbaal_challenge_debuff", mf_cqi)
				end
			end

			for i = 1, cm:pending_battle_cache_num_attackers() do
				local current_char_cqi, current_mf_cqi, current_faction_name = cm:pending_battle_cache_get_attacker(i)
				remove_effect_bundles(current_mf_cqi)
			end

			for i = 1, cm:pending_battle_cache_num_defenders() do
				local current_char_cqi, current_mf_cqi, current_faction_name = cm:pending_battle_cache_get_defender(i)
				remove_effect_bundles(current_mf_cqi)
			end

			local faction = cm:get_faction(self.faction_key)

			if pb:has_been_fought() then
				if cm:pending_battle_cache_faction_won_battle(self.faction_key) then
					local arbaal_target_cqis = cm:get_saved_value("arbaal_target_cqis") or {}
					local arbaal_character_cqi = 0
					local was_challenge_battle = false

					for i = 1, cm:pending_battle_cache_num_attackers() do
						local current_char_cqi, current_mf_cqi, current_faction_name = cm:pending_battle_cache_get_attacker(i)

						if arbaal_character_cqi == 0 and current_faction_name == self.faction_key then
							arbaal_character_cqi = current_char_cqi
						end
						
						for j = 1, #arbaal_target_cqis do
							if arbaal_target_cqis[j] == current_mf_cqi then
								was_challenge_battle = true
								break
							end
						end
					end
					
					if not was_challenge_battle then
						for i = 1, cm:pending_battle_cache_num_defenders() do
							local current_char_cqi, current_mf_cqi, current_faction_name = cm:pending_battle_cache_get_defender(i)

							if arbaal_character_cqi == 0 and current_faction_name == self.faction_key then
								arbaal_character_cqi = current_char_cqi
							end
							
							for j = 1, #arbaal_target_cqis do
								if arbaal_target_cqis[j] == current_mf_cqi then
									was_challenge_battle = true
									break
								end
							end
						end
					end

					local character = cm:get_character_by_cqi(arbaal_character_cqi)

					if character then
						if character:has_military_force() and ((cm:get_factions_bonus_value(faction, "arbaal_challenge_blood_host") > 0 and was_challenge_battle) or cm:model():random_percent(cm:get_factions_bonus_value(faction, "arbaal_battle_blood_host"))) then
							khorne_spawned_armies:spawn_army(character, true)
						end

						if character:has_region() then
							local region = character:region()

							local function apply_bonus_corruption(amount, bundle_key)
								if amount > 0 then
									local corruption_bundle = cm:create_new_custom_effect_bundle(bundle_key)
									corruption_bundle:add_effect("wh3_dlc26_effect_corruption_khorne_wrath_of_khorne", "region_to_province_own", amount)
									corruption_bundle:set_duration(5)
									cm:apply_custom_effect_bundle_to_region(corruption_bundle, region)
								end
							end

							if was_challenge_battle then
								apply_bonus_corruption(cm:get_factions_bonus_value(faction, "arbaal_challenge_corruption"), "wh3_dlc26_bundle_corruption_khorne_arbaal_challenge")
							else
								apply_bonus_corruption(cm:get_factions_bonus_value(faction, "arbaal_battle_corruption"), "wh3_dlc26_bundle_corruption_khorne_arbaal_battle")
							end

							if not region:is_abandoned() and region:owning_faction() ~= faction and region:foreign_slot_manager_for_faction(faction:name()):is_null_interface() and ((was_challenge_battle and cm:get_factions_bonus_value(faction, "arbaal_challenge_cult") > 0) or cm:model():random_percent(cm:get_factions_bonus_value(faction, "arbaal_battle_cult"))) then
								cm:add_foreign_slot_set_to_region_for_faction(faction:command_queue_index(), region:cqi(), "wh3_main_slot_set_kho_cult")
							end
						end
					end
				end

				if not faction:has_faction_leader() then return end

				local faction_leader = faction:faction_leader()
				local faction_leader_fm_cqi = faction_leader:family_member():command_queue_index()

				if cm:pending_battle_cache_faction_lost_battle(self.faction_key) and cm:pending_battle_cache_fm_is_involved(faction_leader_fm_cqi) then
					-- ignore lightning strike battles where arbaal was defending as a secondary character
					if pb:night_battle() then
						for i = 1, cm:pending_battle_cache_num_defenders() do
							if i > 1 and cm:pending_battle_cache_get_defender_fm_cqi(i) == faction_leader_fm_cqi then return end
						end
					end

					if faction:is_human() then
						local dilemma_builder = cm:create_dilemma_builder(self.defeat_dilemma)
						local payload_builder = cm:create_payload()
						
						payload_builder:faction_pooled_resource_transaction(self.pooled_resource_key, "wrath_of_khorne", - faction:pooled_resource_manager():resource(self.pooled_resource_key):value(), false)
						
						if not faction_leader:has_trait(self.defeated_trait) then
							payload_builder:character_trait_change(faction_leader, self.defeated_trait, false)
						end
						
						dilemma_builder:add_choice_payload("FIRST", payload_builder)
						payload_builder:clear()
						
						payload_builder:text_display("dummy_end_campaign")
						dilemma_builder:add_choice_payload("SECOND", payload_builder)

						cm:launch_custom_dilemma_from_builder(dilemma_builder, faction)

						core:add_listener(
							"arbaal_defeat_dilemma",
							"DilemmaChoiceMadeEvent",
							function(context)
								return context:dilemma() == self.defeat_dilemma
							end,
							function(context)
								if context:choice() == 1 then
									custom_starts:kill_faction(self.faction_key)
								end
							end,
							false
						)
					else
						cm:faction_add_pooled_resource(self.faction_key, self.pooled_resource_key, "wrath_of_khorne", - faction:pooled_resource_manager():resource(self.pooled_resource_key):value()) -- remove all current wrath of khorne points
						if not faction_leader:has_trait(self.defeated_trait) then
							cm:force_add_trait(cm:char_lookup_str(faction_leader), self.defeated_trait) -- curse arbaal with a mean trait
						end
					end
				end
			end
		end,
		true
	)

	-- CAI Implementation of the wrath of Khorne 
	-- Since the missions relies on Teleportation and the CAI won't be teleporting, 
	-- We're going to check if the CAI has won a battle. If so, we give the bonus.
	core:add_listener(
		"wrath_of_khorne_CAI_Battle_Completed",
		"CharacterCompletedBattle",
		function(context)
			local pb = context:pending_battle()
			local defender = pb:defender()
			local attacker = pb:attacker()
			local arbaal 

			if defender:faction():name() == self.faction_key then
				arbaal = defender:faction()
			elseif attacker:faction():name() == self.faction_key then
				arbaal = attacker:faction()
			else 
				return false  
			end

			return not arbaal:is_human()
		end,
		function(context)
			local arbaal
			local pb = context:pending_battle()
			local defender = pb:defender()
			local attacker = pb:attacker()

			if defender:faction():name() == self.faction_key and pb:defender_won() then
				arbaal = defender:military_force()
			elseif attacker:faction():name() == self.faction_key and pb:attacker_won() then
				arbaal = attacker:military_force()
			else
				return
			end

			-- Always give some Skulls 
			cm:faction_add_pooled_resource(self.faction_key, "wh3_main_kho_skulls", "other", 200)

			-- Every X turns, spawn a bloodhost army as well 
			if wrath_of_khorne.cai_config.bloodhost_cooldown_counter >= wrath_of_khorne.cai_config.bloodhost_cooldown then
				khorne_spawned_armies:spawn_army(arbaal:general_character(), true)
				wrath_of_khorne.cai_config.bloodhost_cooldown_counter = 0
			end
		end,
		true
	)
end

function wrath_of_khorne:generate_challenges(faction, show_mission_issued_event)
	local mission_types = {"easy", "medium", "hard"}

	for i = 1, #mission_types do
		local num_missions = faction:active_missions("Arbaal_map_" .. mission_types[i]):num_items()

		if num_missions < self.missions_config.number_of_missions_per_type[mission_types[i]] then
			local num_missions_needed = self.missions_config.number_of_missions_per_type[mission_types[i]] - num_missions
			local armies_selected = self:get_valid_armies_for_mission_targets(mission_types[i], num_missions_needed)

			out.design("Issuing " .. num_missions_needed .. " " .. mission_types[i] .. " missions. " .. #armies_selected .. " available armies")

			-- trigger all the easy missions from the selected list
			for j, army in ipairs(armies_selected) do
				local mission_key

				for k = 1, #self.missions_config.primary_key[mission_types[i]] do
					local mission_key_to_test = self.missions_config.primary_key[mission_types[i]][k]
					if not cm:mission_is_active_for_faction(faction, mission_key_to_test) then
						mission_key = mission_key_to_test
						break
					end
				end

				if mission_key then
					self:trigger_mission(mission_key, i, army:command_queue_index(), show_mission_issued_event)
				end
			end
		end
	end

	local arbaal_target_cqis = cm:get_saved_value("arbaal_target_cqis") or {}

	for i = 1, #arbaal_target_cqis do
		local mf = cm:get_military_force_by_cqi(arbaal_target_cqis[i])

		if mf and mf:has_general() then
			local general = mf:general_character()

			if general:has_region() then
				cm:make_region_visible_in_shroud(self.faction_key, mf:general_character():region():name())
			end
		end
	end
end

function wrath_of_khorne:trigger_mission(mission_key, mission_difficulty, mission_target_cqi, show_mission_issued_event)
	-- check if the required parameters are passed
	if not mission_key or not mission_target_cqi then
		script_error("ERROR: trigger_mission() called but missing required parameters - mission_key is [" .. tostring(mission_key) .. "] and mission_target_cqi is [" .. mission_target_cqi .. "]")
		return
	end

	local mission_reward_money = self.missions_config.reward.money[mission_difficulty]
	local mission_reward_khorne_favour = self.missions_config.reward.khorne_favour[mission_difficulty]
	local mission_reward_skulls = self.missions_config.reward.skulls[mission_difficulty]

	-- generate the mission
	local mm = mission_manager:new(wrath_of_khorne.faction_key, mission_key)
	mm:add_new_objective(self.missions_config.objective)

	mm:add_payload("money " ..tostring(mission_reward_money))
	mm:add_payload("faction_pooled_resource_transaction{resource "..self.pooled_resource_key..";factor challenges;amount "..mission_reward_khorne_favour..";context absolute;}")
	
	if mission_difficulty == 1 then
		-- just give skulls
		mm:add_payload("faction_pooled_resource_transaction{resource wh3_main_kho_skulls;factor challenges;amount "..mission_reward_skulls..";context absolute;}")
	elseif mission_difficulty == 2 then
		-- randomize between giving skulls or a unit cost reduction
		local random_number = cm:random_number(2)
		if random_number == 1 then
			mm:add_payload("effect_bundle{bundle_key " ..self.missions_config.reward.effect_bundle.cost_low ..";turns 5;}")
		else
			mm:add_payload("faction_pooled_resource_transaction{resource wh3_main_kho_skulls;factor challenges;amount "..mission_reward_skulls..";context absolute;}")
		end
	elseif mission_difficulty == 3 then
		-- randomize between giving skulls, a unit cost reduction or a post battle loot increase
		local random_number = cm:random_number(3)
		if random_number == 1 then
			mm:add_payload("effect_bundle{bundle_key " ..self.missions_config.reward.effect_bundle.cost_high ..";turns 5;}")
		elseif random_number == 2 then
			mm:add_payload("faction_pooled_resource_transaction{resource wh3_main_kho_skulls;factor challenges;amount "..mission_reward_skulls..";context absolute;}")
		else
			mm:add_payload("effect_bundle{bundle_key " ..self.missions_config.reward.effect_bundle.loot ..";turns 5;}")
		end
	end

	mm:add_condition("cqi " ..tostring(mission_target_cqi))
	mm:add_condition("requires_victory")
	mm:set_show_mission(show_mission_issued_event)

	mm:trigger()

	local arbaal_target_cqis = cm:get_saved_value("arbaal_target_cqis") or {}

	table.insert(arbaal_target_cqis, mission_target_cqi)

	cm:set_saved_value("arbaal_target_cqis", arbaal_target_cqis)
end

-- find armies that suit the mission strength specified
function wrath_of_khorne:get_valid_armies_for_mission_targets(strength, num_missions)
	local faction = cm:get_faction(self.faction_key)
	local faction_leader = faction:faction_leader()
	local arbaal_current_army_strength = 1000 -- default value for when Arbaal is not alive

	-- check if Arbaal is alive and then get his current army strength
	if faction_leader:has_military_force() then
		-- if Arbaal's army strength is lower than 2 milion then set it to 2mil
		-- this is to prevent very easy missions from being generated when Arbaal army has very low strength
		arbaal_current_army_strength = math.max(faction_leader:military_force():strength(), 2000000)
	end

	local sorted_armies = {}
	local mission_strength = self.missions_config.mission_strength[strength]
	local arbaal_target_cqis = cm:get_saved_value("arbaal_target_cqis") or {}

	for _, mf in model_pairs(cm:get_all_forces_sorted_by_strength(self.faction_key)) do
		local character = mf:general_character()
		if not character:is_null_interface() and not character:is_hidden_from_faction_in_garrison(self.faction_key) and not character:faction():is_team_mate(faction) then
			local mf_strength = mf:strength()
			local force_size = mf:unit_list():num_items()

			-- delta between Arbaal and enemy strength
			local strength_delta = mf_strength - arbaal_current_army_strength
			local army_currently_targeted = false

			-- skip armies that have already been targeted
			for i = 1, #arbaal_target_cqis do
				if mf:command_queue_index() == arbaal_target_cqis[i] then
					army_currently_targeted = true
					break
				end
			end

			-- if the strength_delta is negative or 0, then the enemy is weaker than Arbaal, so skip it
			if not army_currently_targeted and strength_delta >= mission_strength.strength_delta_min and strength_delta <= mission_strength.strength_delta_max and force_size >= mission_strength.force_size.min and force_size <= mission_strength.force_size.max then
				table.insert(sorted_armies, mf)
			end
		end
	end
	
	-- spawn new armies if there are not enough armies on the map
	if #sorted_armies < num_missions then
		local num_armies_required_to_spawn = num_missions - #sorted_armies
		out.design("WARNING: Only found [" .. #sorted_armies .. "] missions, when we need [".. num_missions .. "] of mission type [" .. tostring(strength) .. "]  - creating " .. num_armies_required_to_spawn .. " new armies to generate targets for the remaining missions")

		for i = 1, num_armies_required_to_spawn do
			local new_army = self:spawn_army_of_specific_strength(strength, i)
			table.insert(sorted_armies, new_army)
		end
	else
		out.design("No need to create new armies and corresponding missions as enough are already available - number of available [" .. strength .. "] missions: [" .. #sorted_armies .. "]")
	end

	sorted_armies = cm:random_sort(sorted_armies)

	local selected_armies = {}
	
	for i = 1, num_missions do
		local current_army = sorted_armies[i]
		if current_army then
			table.insert(selected_armies, current_army)
		end
	end
	
	return selected_armies
end

-- spawn a new army for the mission
function wrath_of_khorne:spawn_army_of_specific_strength(strength, count)
	local spawned_army_counter = "arbaal_script_spawned_army_" .. strength .. "_".. cm:turn_number() .. "_" .. count
	local subculture = self.missions_config.subculture_keys[cm:random_number(#self.missions_config.subculture_keys)]
	local faction_key = self.missions_config.subcultures[subculture].faction_key
	local region_key = self.missions_config.subcultures[subculture].region_key
	local possible_spawn_regions = {}

	for _, region in model_pairs(cm:model():world():region_manager():region_list()) do
		if not region:is_abandoned() and region:owning_faction():subculture() == subculture then
			table.insert(possible_spawn_regions, region:name())
		end
	end

	if #possible_spawn_regions > 0 then
		region_key = possible_spawn_regions[cm:random_number(#possible_spawn_regions)]
	end

	local x, y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, region_key, false, false, cm:random_number(20, 10))

	if x < 0 then return end

	local force_size = self.missions_config.mission_strength[strength].spawned_force_size
	local force_power = self.missions_config.mission_strength[strength].spawned_force_power
	local new_army = WH_Random_Army_Generator:generate_random_army(spawned_army_counter, subculture, force_size, force_power, true, false)

	out.design("New army spawned around " .. region_key .. " with key " .. spawned_army_counter .. " at coordinates " .. x .. ", " .. y)
	out.design("New army has the template " .. subculture)
	out.design("New army has " .. force_size .. " units and force power of " .. force_power)

	local invasion = invasion_manager:new_invasion(spawned_army_counter, faction_key, new_army, {x, y})
	invasion:create_general(false, self.missions_config.subcultures[subculture].general_subtype)
	invasion:set_target("NONE")
	invasion:start_invasion(true)

	invasion:apply_effect("wh_main_bundle_military_upkeep_free_force", 0)
	-- make new armies immune to attrition due to spawning them all in random places
	invasion:apply_effect("wh2_dlc16_bundle_military_upkeep_free_force_immune_to_regionless_attrition", 0)
	
	cm:force_diplomacy("faction:" .. faction_key, "all", "all", false, false, true)
	cm:force_diplomacy("faction:" .. faction_key, "faction:" .. self.faction_key, "war", true, true, true)

	return invasion:get_force()
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("wrath_of_khorne.cai_config", wrath_of_khorne.cai_config, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			wrath_of_khorne.cai_config = cm:load_named_value("wrath_of_khorne.cai_config", wrath_of_khorne.cai_config, context)
		end
	end
)