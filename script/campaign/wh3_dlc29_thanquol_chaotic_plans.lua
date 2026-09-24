out.design("*** Chaotic plans script loaded ***");

thanquol_chaotic_plans_config = {
	faction_key = "wh3_dlc29_skv_clan_scruten",
	panel_name = "dlc29_skv_chaotic_plans",
	starting_tokens = {
		-- use the keys of shop objects from chaotic_plan_shop_category_objects, not the tokens themselves
	},
	economic_plan = {
		db_key = "economic",
		failure_mission_key = "wh3_dlc29_skv_thanquol_economic_plan_recapture",
		failure_mission_turn_limit = 10,
		should_reward_treasury = true,
		can_reward_negative = true,
		resources_to_reward = {
			"skaven_food",
			"wh3_dlc29_skv_warpstone"
		},
		resource_factor_key = "wh3_dlc29_plan"
	},
	military_plan = {
		db_key = "military",
		should_reward_treasury = true,
		can_reward_negative = false,
		resources_to_reward = {
			"skaven_food",
			"wh3_dlc29_skv_warpstone"
		},
		resource_factor_key = "wh3_dlc29_plan"
	},
	magic_plan = {
		db_key = "magic",
		should_reward_treasury = true,
		can_reward_negative = true,
		resources_to_reward = {
			"skaven_food",
			"wh3_dlc29_skv_warpstone"
		},
		resource_factor_key = "wh3_dlc29_plan"
	},
	schemer_xp_per_token = {
		base_value = 250, -- After successful completion of a plan, the Schemer gets base_value * number_of_tokens_in_plan
		token_overrides = { -- Configure any token to have a different value than the base one
			-- ["token_key"] = number,
			["wh3_dlc29_any_action_experience_generated"] = 2000,
			["wh3_dlc29_purple_any_chaos_experience"] = 2000,
			["wh3_dlc29_purple_any_skaven_blackmail"] = 2000
		},
		failed_economic_plan_modifier = 0.5, -- XP to award when an Economic plan has failed
		-- Abandoning a plan doesn't award XP
	},
	cai = {
		general_cooldown = 10,
		min_turns_before_execution = 8, -- let the plan cook for a bit before trying to trigger
		max_concurrent_plans = 3,
		max_region_attempts = 3, 
		plans = { -- We don't want the CAI to use plans from turn 1, so we override the minimum turn for each plan type (keys from the chaotic_plans table)
			-- ["plan_key"] = min_turn,
			-- Economic plans are not worth it for CAI to perform
			--["wh3_dlc29_economic_plan"] = 1,
			["wh3_dlc29_magic_plan"] = 23,
			["wh3_dlc29_military_plan"] = 3,
		},
		magic_plan_tokens = { -- Magic plans require a token that represent the plan sub-type to be created (sub_token from the chaotic_plan_resource_activated_token_groups table)
			-- ["token_key"] = min_turn,
			["wh3_dlc29_magic_create_undercity_1"] = 23,
			--["wh3_dlc29_magic_pull_moon_1"] = 1, disabled, way too powerful for CAI
			["wh3_dlc29_magic_summon_verminlord_corruptor_1"] = 25,
			["wh3_dlc29_magic_summon_verminlord_deceiver_1"] = 25,
			["wh3_dlc29_magic_summon_verminlord_warbringer_1"] = 25,
			["wh3_dlc29_magic_summon_verminlord_warpseer_1"] = 25,
		},
	},
	thanquol_unique_buildings = {
		"wh3_dlc29_skv_special_morskittar_engine_1",
		"wh3_dlc29_skv_special_morskittar_engine_2",
		"wh3_dlc29_skv_special_morskittar_engine_3",
		"wh3_dlc29_skv_special_morskittar_engine_4",
		"wh3_dlc29_skv_special_morskittar_engine_5",
	},
	final_battle_support_tokens = {
		"wh3_dlc29_skv_final_battle_support_eshin",
		"wh3_dlc29_skv_final_battle_support_mors",
		"wh3_dlc29_skv_final_battle_support_moulder",
		"wh3_dlc29_skv_final_battle_support_pestilens",
		"wh3_dlc29_skv_final_battle_support_rictus",
		"wh3_dlc29_skv_final_battle_support_skryre",
	},
	final_battle_mission_key = "wh3_dlc29_qb_skv_thanquol_final_battle",
	masterplans_mission_unlock = "wh3_main_camp_narrative_shared_capture_settlement_01",
	masterplans_unlocked_key = "masterplans_unlocked",
	effect_bundle_to_unit_set_and_rank_up = {
		["wh3_dlc29_skv_underlings_rank_up_weapon_teams_1"] = {
			unit_sets = {
				"skv_weaponteams"
			},
			rank_up = 3
		},
		["wh3_dlc29_skv_underlings_rank_up_weapon_teams_2"] = {
			unit_sets = {
				"skv_weaponteams"
			},
			rank_up = 6
		},
		["wh3_dlc29_skv_underlings_rank_up_weapon_teams_3"] = {
			unit_sets = {
				"skv_weaponteams"
			},
			rank_up = 9
		},
		["wh3_dlc29_skv_underlings_rank_up_artillery_1"] = {
			unit_sets = {
				"skv_artillery_warmachines"
			},
			rank_up = 3
		},
		["wh3_dlc29_skv_underlings_rank_up_artillery_2"] = {
			unit_sets = {
				"skv_artillery_warmachines"
			},
			rank_up = 6
		},
		["wh3_dlc29_skv_underlings_rank_up_artillery_3"] = {
			unit_sets = {
				"skv_artillery_warmachines"
			},
			rank_up = 9
		},
		["wh3_dlc29_skv_underlings_rank_up_melee_infantry_1"] = {
			unit_sets = {
				"infantry_units_melee"
			},
			rank_up = 3
		},
		["wh3_dlc29_skv_underlings_rank_up_melee_infantry_2"] = {
			unit_sets = {
				"infantry_units_melee"
			},
			rank_up = 6
		},
		["wh3_dlc29_skv_underlings_rank_up_melee_infantry_3"] = {
			unit_sets = {
				"infantry_units_melee"
			},
			rank_up = 9
		},
		["wh3_dlc29_skv_underlings_rank_up_monsters_1"] = {
			unit_sets = {
				"infantry_monstrous",
				"monsters"
			},
			rank_up = 3
		},
		["wh3_dlc29_skv_underlings_rank_up_monsters_2"] = {
			unit_sets = {
				"infantry_monstrous",
				"monsters"
			},
			rank_up = 6
		},
		["wh3_dlc29_skv_underlings_rank_up_monsters_3"] = {
			unit_sets = {
				"infantry_monstrous",
				"monsters"
			},
			rank_up = 9
		},
		["wh3_dlc29_skv_underlings_rank_up_missile_infantry_1"] = {
			unit_sets = {
				"skv_gutterrunners",
				"skv_nightrunners"
			},
			rank_up = 3
		},
		["wh3_dlc29_skv_underlings_rank_up_missile_infantry_2"] = {
			unit_sets = {
				"skv_gutterrunners",
				"skv_nightrunners"
			},
			rank_up = 6
		},
		["wh3_dlc29_skv_underlings_rank_up_missile_infantry_3"] = {
			unit_sets = {
				"skv_gutterrunners",
				"skv_nightrunners"
			},
			rank_up = 9
		},
	},
	
}

------------------
------DATA--------
------------------
thanquol_chaotic_plans = {}
thanquol_chaotic_plans.config = thanquol_chaotic_plans_config

thanquol_chaotic_plans.persistent = {
	cai_last_turn_activated = 0,
	-- plans the CAI has created and is waiting on, as {region_key = plan_region, turn_created = round_number}
	cai_tracked_plans = {},
}

------------------
----FUNCTIONS-----
------------------
function thanquol_chaotic_plans:initialise()
	local faction = cm:get_faction(self.config.faction_key)
	if is_faction(faction) == false then
		-- guarding for old saves where there is no thanquol faction
		return
	end

	if cm:is_new_game() then
		for _, token_key in ipairs(self.config.starting_tokens) do
			cm:add_chaotic_plan_shop_object_to_faction_inventory(faction, token_key, 1)
		end

		cm:set_script_state(faction, thanquol_chaotic_plans_config.masterplans_unlocked_key, false)
		self:lock_tokens_until_final_battle_toggle(faction, true)

		if not faction:is_human() then
			cm:set_script_state(faction, thanquol_chaotic_plans_config.masterplans_unlocked_key, true)
			cm:apply_effect_bundle("wh3_dlc29_chaotic_plans_enable_magic", self.config.faction_key, 0)
			for _, magic_plan_subtype_data in dpairs(thanquol_schemers.magic_plan_subtypes) do
				cm:set_script_state(faction, magic_plan_subtype_data.rat_group, true)
			end

			local char_list = faction:character_list()
			for i = 0, char_list:num_items() - 1 do
				local character = char_list:item_at(i)
				local character_subtype_key = character:character_subtype_key()
				if table.find(thanquol_schemers.agent_subtypes, character_subtype_key) ~= nil then
					cm:set_script_state(character:family_member(), thanquol_schemers.character_unlocked_shared_state, true)
				end
			end
		end
	end

	core:add_listener(
		"EconomicPlanApplyPayloads",
		"ChaoticPlanApplyAccumulatedPayloadsEvent",
		true,
		function(context)
			local plan = context:plan()
			if context:was_successful() then
				self:apply_plan_payload(plan, context:pct_received())
				local schemer_character = plan:schemer():character()
				if context:plan():type_key() == self.config.military_plan.db_key
						and not schemer_character:is_null_interface()
						and not schemer_character:military_force():is_null_interface()
						and schemer_character:military_force():unit_list():num_items() > 0 then
					self:add_schemer_passive_unit_rank_up(schemer_character)
				end
			elseif context:plan():type_key() == self.config.economic_plan.db_key then
				self:trigger_economic_plan_failure_mission(plan)
			end
			self:give_schemer_xp_on_plan_completion(plan, context:was_successful())
		end,
		true
	)

	core:add_listener(
		"ChaoticPlansTokenPurchased",
		"ChaoticPlanTokenPurchasedFromShopEvent",
		true,
		function(context)
			local faction = context:faction()
			local token_record_key = context:token_record_key()

			for _, magic_plan_subtype_data in dpairs(thanquol_schemers.magic_plan_subtypes) do
				local unlock_token = magic_plan_subtype_data.shop_unlock_token
				if unlock_token == token_record_key then
					cm:apply_effect_bundle("wh3_dlc29_chaotic_plans_enable_magic", episode_narrative_thanquol.faction_key, 0)
					cm:set_script_state(faction, magic_plan_subtype_data.rat_group, true)
				end
			end
		end,
		true
	)

	core:add_listener(
		"ChaoticPlansPanelOpened",
		"PanelOpenedCampaign",
		function(context)
			return context.string == self.config.panel_name
		end,
		function(context)
			-- Delay a little bit so the UI can close the event rollout if opened
			cm:callback(function() uim:override("events_rollout"):lock() end, 0.1)	
		end,
		true
	)

	core:add_listener(
		"ChaoticPlansPanelClosed",
		"PanelClosedCampaign",
		function(context)
			return context.string == self.config.panel_name
		end,
		function(context)
			uim:override("events_rollout"):unlock()
		end,
		true
	)

	-- cai use of the masterplans.
	if not faction:is_human() then
		core:add_listener(
			"ChaoticPlansCAITurnStart",
			"FactionTurnStart",
			function(context)
				return context:faction() == faction
			end,
			function(context)
				local faction = context:faction()
				local plans_manager = cm:model():chaotic_plans_manager()
				
				if plans_manager:is_null_interface() then
					return
				end

				-- check any active plans and possibly trigger them
				self:cai_check_and_trigger_plan(faction, plans_manager)

				if cm:turn_number() >= (self.persistent.cai_last_turn_activated + self.config.cai.general_cooldown) then
					-- find a region and create a plan.
					self:cai_create_chaotic_plan(faction, plans_manager)
				end
				
			end,
			true
		)
	end

	core:add_listener(
		"thanquol_final_battle_reinforcements_PendingBattle",
		"PendingBattle",
		function(context)
			local pb = context:pending_battle()

			if pb:has_defender() and pb:defender():faction():name() == self.config.faction_key and pb:quest_mission_key() == self.config.final_battle_mission_key then
				return true
			end

			return false
		end,

		function(context)
			self:save_support_token_armies(faction)
		end
	)

	core:add_listener(
		"master_plans_unlock_RegionFactionChangeEvent",
		"RegionFactionChangeEvent",
		function(context)
			return  faction:is_human() and context:region():owning_faction():name() == self.config.faction_key
		end,
		function(context)
			local faction_unlock = context:region():owning_faction()
			cm:set_script_state(faction_unlock, thanquol_chaotic_plans_config.masterplans_unlocked_key, true)
		end,
		true
	)

	core:add_listener(
		"ThanquolScriptedTourChaoticPlansUnlocked_RegionFactionChangeEvent",
		"RegionFactionChangeEvent",
		function(context)
			return faction:is_human() and context:region():owning_faction():name() == self.config.faction_key
		end,
		function(context)
			highlight_component(true, true, "button_chaotic_plans")
			cm:callback(function()
				highlight_component(false, false, "button_chaotic_plans")
			end, 3)
		end,
		false
	)

	core:add_listener(
		"ThanquolMorskitarEngineLandmarkRemovalEvent",
		"RegionFactionChangeEvent",
		function(context)
			return context:previous_faction() and context:previous_faction():name() == self.config.faction_key
		end,
		function(context)
			if context:region() and context:region():slot_list() then
				self:remove_thanquol_special_buildings(context:region():slot_list())
			end
		end,
		true
	)
end

function thanquol_chaotic_plans:remove_thanquol_special_buildings(region_slot_list)
	for i = 1, #self.config.thanquol_unique_buildings do
	--check to see if the building exists in any of the regions
		if region_slot_list:buliding_type_exists(self.config.thanquol_unique_buildings[i]) then
			for j = 0, region_slot_list:num_items() - 1 do
				--find the slot it exists in and remove it
				local slot = region_slot_list:item_at(j)
				if slot:has_building() and slot:building():name() == self.config.thanquol_unique_buildings[i] then
					cm:instantly_dismantle_building_in_region(slot)
				end
			end
		end
	end
end

function thanquol_chaotic_plans:add_schemer_passive_unit_rank_up(schemer)
	local unit_list = schemer:military_force():unit_list()
	for effect_bundle_key, unit_set_and_rank_up in dpairs(self.config.effect_bundle_to_unit_set_and_rank_up) do
		if schemer:has_effect_bundle(effect_bundle_key) then
			for i = 1, unit_list:num_items() - 1 do
				local unit = unit_list:item_at(i)
				for i, unit_set in ipairs(unit_set_and_rank_up.unit_sets) do
					if unit:is_unit_in_set(unit_set) then
						cm:add_experience_to_unit(unit, unit_set_and_rank_up.rank_up)
						break
					end
				end
			end
		end
	end
end

function thanquol_chaotic_plans:lock_tokens_until_final_battle_toggle(faction, toggle)
	for _, token_key in dpairs(self.config.final_battle_support_tokens) do
		cm:set_script_state(faction, "is_locked_until_final_battle_" .. token_key, toggle)
	end
end

function thanquol_chaotic_plans:cai_check_and_trigger_plan(faction, plans_manager)
	local tracked_plans = self.persistent.cai_tracked_plans

	-- iterate backwards so entries can be removed safely
	for i = #tracked_plans, 1, -1 do
		local tracked_plan = tracked_plans[i]
		local region = cm:get_region(tracked_plan.region_key)

		if not region or region:is_null_interface() then
			table.remove(tracked_plans, i)
		else
			local active_plan = plans_manager:get_active_plan_by_region(region, faction)

			if not active_plan or active_plan:is_null_interface() then
				-- the plan is gone by other means, so stop tracking it
				table.remove(tracked_plans, i)
			else
				local turns_since_creation = cm:turn_number() - tracked_plan.turn_created

				if active_plan:can_execute_plan() and turns_since_creation >= self.config.cai.min_turns_before_execution then
					cm:execute_chaotic_plan(region, faction)
					self.persistent.cai_last_turn_activated = cm:turn_number()
					table.remove(tracked_plans, i)
				elseif active_plan:is_alarm_maxed() then
					cm:abandon_chaotic_plan(region, faction)
					self.persistent.cai_last_turn_activated = cm:turn_number()
					table.remove(tracked_plans, i)
				end
			end
		end
	end
end

function thanquol_chaotic_plans:cai_get_available_keys(t)
	local ret = {}
	local curr_turn = cm:turn_number()

	if not t or is_empty_table(t) then
		return false
	end

	for key, min_turn in dpairs(t) do
		if curr_turn >= min_turn then
			table.insert(ret, key)
		end
	end

	if is_empty_table(ret) then
		return false
	end

	return ret
end

function thanquol_chaotic_plans:cai_get_random_available_plan()
	local available_plans = self:cai_get_available_keys(self.config.cai.plans)
	if not available_plans then
		return false
	end

	local available_tokens = self:cai_get_available_keys(self.config.cai.magic_plan_tokens)
	local plan_options = {}
	for _, plan_key in ipairs(available_plans) do
		-- military and economic plans can be created without a token, but magic plans must have one!
		if plan_key ~= "wh3_dlc29_magic_plan" or available_tokens then
			table.insert(plan_options, {
				plan_key = plan_key,
				token_key = ""
			})
		end
	end

	if is_empty_table(plan_options) then
		return false
	end

	local selected_plan = plan_options[cm:random_number(#plan_options, 1)]
	if selected_plan.plan_key == "wh3_dlc29_magic_plan" then
		selected_plan.token_key = available_tokens[cm:random_number(#available_tokens, 1)]
	end

	return selected_plan
end

function thanquol_chaotic_plans:cai_create_chaotic_plan(faction, plans_manager)
	if #self.persistent.cai_tracked_plans >= self.config.cai.max_concurrent_plans then
		return
	end

	local eligible_regions = plans_manager:get_eligible_regions_for_plan_mission(faction)
	if eligible_regions == nil or eligible_regions:num_items() == 0 then
		return
	end

	local eligible_characters = plans_manager:get_available_schemers_for_plans(faction)
	if eligible_characters:is_empty() then
		return
	end
	local selected_char = eligible_characters:item_at(cm:random_number(eligible_characters:num_items() - 1, 0))
	if not selected_char or selected_char:is_null_interface() then
		return
	end
	local selected_family_member = selected_char:family_member()

	local selected_plan = self:cai_get_random_available_plan()
	if not selected_plan then
		return
	end

	local plan_key = selected_plan.plan_key
	local token_key = selected_plan.token_key

	-- walk the eligible regions from a random start so a locked plan doesn't waste the turn
	local num_regions = eligible_regions:num_items()
	local start_index = cm:random_number(num_regions - 1, 0)
	local attempts = math.min(self.config.cai.max_region_attempts, num_regions)
	for i = 0, attempts - 1 do
		local selected_region = eligible_regions:item_at((start_index + i) % num_regions)

		if cm:create_chaotic_plan(selected_region, faction, selected_family_member:command_queue_index(), plan_key, token_key, true) then
			table.insert(self.persistent.cai_tracked_plans, {region_key = selected_region:name(), turn_created = cm:turn_number()})
			self.persistent.cai_last_turn_activated = cm:turn_number()
			return
		end
	end
end

function thanquol_chaotic_plans:apply_plan_payload(plan, pct_received)
	local payloads_manager = plan:payloads_manager()
	local pct_received_modification = pct_received / 10000
	local cfg = self.config[plan:type_key() .. "_plan"]
	if not cfg then
		return
	end

	local treasury_amount = payloads_manager:accumulated_resources():total_treasury_change() * pct_received_modification
	if cfg.should_reward_treasury and treasury_amount ~= 0 and (treasury_amount > 0 or cfg.can_reward_negative) then
		cm:treasury_mod(self.config.faction_key, treasury_amount)
	end

	local resources = payloads_manager:accumulated_resources()
	local factor_key = cfg.resource_factor_key
	for _, resource_key in ipairs(cfg.resources_to_reward) do
		local amount = resources:absolute_resource_change(resource_key) * pct_received_modification
		cm:faction_add_pooled_resource(self.config.faction_key, resource_key, factor_key, amount)
	end

	local schemer_exp = payloads_manager:accumulated_experience()
	if schemer_exp > 0 then
		local schemer = plan:schemer()
		if not schemer:is_null_interface() then
			cm:character_details_add_experience(schemer:character_details(), schemer_exp)
		end
	end
end

function thanquol_chaotic_plans:give_schemer_xp_on_plan_completion(plan, was_successful)
	if not was_successful and plan:type_key() ~= self.config.economic_plan.db_key then 
		script_error("A non-economic plan has failed. This is not supported.")
		return
	end

	local cfg = self.config.schemer_xp_per_token
	local xp = 0
	if is_empty_table(cfg.token_overrides) then
		xp = cfg.base_value * plan:num_of_drawn_tokens()
	else
		local drawn_tokens = plan:drawn_token_keys()
		for _, token_key in ipairs(drawn_tokens) do
			local token_xp = cfg.token_overrides[token_key] or cfg.base_value
			xp = xp + token_xp
		end
	end

	if not was_successful then
		xp = xp * cfg.failed_economic_plan_modifier
	end

	if xp > 0 then
		local schemer = plan:schemer()
		if not schemer:is_null_interface() then
			core:trigger_event("ScriptedChaoticPlanAddExperience", {schemer = schemer, value = xp })
		end
	end
end

function thanquol_chaotic_plans:trigger_economic_plan_failure_mission(plan)
	local region = plan:region()
	if not region or region:is_null_interface() then
		return
	end

	local faction_key = self.config.faction_key
	local mission_key = self.config.economic_plan.failure_mission_key

	local mm = mission_manager:new(faction_key, mission_key)
	mm:add_new_objective("CAPTURE_REGIONS")
	mm:add_condition("region " .. region:name())

	self:add_economic_plan_failure_mission_treasury_payload(plan, mm)
	self:add_economic_plan_failure_mission_resources_payload(plan, mm)
	self:add_economic_plan_failure_mission_experience_payload(plan, mm)

	mm:set_should_cancel_before_issuing(false)
	mm:set_turn_limit(self.config.economic_plan.failure_mission_turn_limit)
	mm:trigger()
end

function thanquol_chaotic_plans:add_economic_plan_failure_mission_treasury_payload(plan, mm)
	if not self.config.economic_plan.should_reward_treasury then
		return
	end
	local cfg = self.config[plan:type_key() .. "_plan"]
	local payloads_manager = plan:payloads_manager()
	
	local treasury_amount = payloads_manager:accumulated_resources():total_treasury_change()
	if cfg.should_reward_treasury and treasury_amount ~= 0 and (treasury_amount > 0 or cfg.can_reward_negative) then
		mm:add_payload(string.format("money %d", treasury_amount))
	end
end

function thanquol_chaotic_plans:add_economic_plan_failure_mission_resources_payload(plan, mm)
	local payloads_manager = plan:payloads_manager()
	local resources = payloads_manager:accumulated_resources()
	local factor_key = self.config.economic_plan.resource_factor_key

	for _, resource_key in ipairs(self.config.economic_plan.resources_to_reward) do
		local amount = resources:absolute_resource_change(resource_key)
		if amount > 0 then
			mm:add_payload(string.format("faction_pooled_resource_transaction{resource %s;factor %s;amount %d;context absolute;}", resource_key, factor_key, amount));
		end
	end
end

function thanquol_chaotic_plans:add_economic_plan_failure_mission_experience_payload(plan, mm)
	local payloads_manager = plan:payloads_manager()

	local schemer_exp = payloads_manager:accumulated_experience()
	if schemer_exp > 0 then
		local schemer = plan:schemer()
		if not schemer:is_null_interface() then
			mm:add_payload(string.format("character_experience_change{fm_cqi %d;amount %d;}", schemer:command_queue_index(), schemer_exp));
		end
	end
end

function thanquol_chaotic_plans:save_support_token_armies(faction)
	local plans_manager = cm:model():chaotic_plans_manager()
				
	if plans_manager:is_null_interface() then
		return
	end

	for _, token_key in dpairs(self.config.final_battle_support_tokens) do
		if plans_manager:has_token_in_inventory(faction, token_key) == true then
			core:svr_save_string(token_key, "1")
		else
			core:svr_save_string(token_key, "0")
		end
	end
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("thanquol_chaotic_plans.persistent", thanquol_chaotic_plans.persistent, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			thanquol_chaotic_plans.persistent = cm:load_named_value("thanquol_chaotic_plans.persistent", thanquol_chaotic_plans.persistent, context)
		end
	end
)