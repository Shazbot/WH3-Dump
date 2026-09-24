episode_narrative_thanquol = {
	-- if set to true, the episode will not start on its own, but can start with a cheat
	episode_disabled = false,
	episode_name = "episode_narrative_thanquol",
	episode_set = "narratives",
	faction_key = "wh3_dlc29_skv_clan_scruten",
	episode_active_shared_state = "episode_narrative_thanquol",

	episode_start_region_trigger = "wh3_main_combi_region_oakenhammer",

	mission_1_objective_region_key = "wh3_main_combi_region_zhufbar",
	dilemma_objective_target_morskittar_building_key = "wh3_dlc27_hef_dragonship_main_building_4",

	thanquol_engine_building_levels = {
		"wh3_dlc29_skv_special_morskittar_engine_1",
		"wh3_dlc29_skv_special_morskittar_engine_2",
		"wh3_dlc29_skv_special_morskittar_engine_3",
		"wh3_dlc29_skv_special_morskittar_engine_4",
		"wh3_dlc29_skv_special_morskittar_engine_5",
	},

	-- this can be organized and named in a different way, I used the most similar to the design doc
	missions = {
		-- ACT 1
		["mission_1"] = {
			key = "wh3_dlc29_skv_thanquol_narrative_mission_1",
			override_text = {"scripted_objective_wh3_dlc29_skv_narrative_mission_military_region_target"},
			objective_region = "wh3_main_combi_region_zhufbar",
			objective_plan_key = "military",
			payloads = {
				"money 1000",
				"faction_pooled_resource_transaction{resource wh3_dlc29_skv_warpstone;factor missions;amount 50;context absolute;}",
				"effect_bundle{bundle_key wh3_dlc29_chaotic_plans_enable_economic;turns 0;}",
			},
		},
		["mission_2"] = {
			key = "wh3_dlc29_skv_thanquol_narrative_mission_2",
			override_text = "",
			payloads = {
				--"text_display dummy_wh3_dlc29_skv_thanquol_narrative_mission_2_payload",
			},
			--[[
			scripted_payload = function()
				local faction = cm:get_faction(episode_narrative_thanquol.faction_key)
				local anciliary_key = get_random_ancillary_key_for_faction(episode_narrative_thanquol.faction_key, false, "rare")
				cm:add_ancillary_to_faction(faction, anciliary_key, false)
			end
			]]
		},
		["mission_3_1"] = {
			key = "wh3_dlc29_skv_thanquol_narrative_mission_3_1",
			override_text = {"scripted_objective_wh3_dlc29_skv_narrative_mission_military"},
			objective_plan_key = "military",
			objective_total = 2,
			payloads = {
				"money 1000",			
				"faction_pooled_resource_transaction{resource wh3_dlc29_skv_warpstone;factor missions;amount 50;context absolute;}",
				"effect_bundle{bundle_key wh3_dlc29_skv_thanquol_narrative_mission_3_1_reward_bundle;turns 6;}",
			}
		},
		["mission_3_2"] = {
			key = "wh3_dlc29_skv_thanquol_narrative_mission_3_2",
			override_text = {"scripted_objective_wh3_dlc29_skv_narrative_mission_economic"},
			objective_plan_key = "economic",
			objective_total = 2,
			payloads = {
				"money 1000",			
				"faction_pooled_resource_transaction{resource wh3_dlc29_skv_warpstone;factor missions;amount 50;context absolute;}",
				"effect_bundle{bundle_key wh3_dlc29_skv_thanquol_narrative_mission_3_2_reward_bundle;turns 6;}",
			}
		},
		["mission_4"] = {
			key = "wh3_dlc29_skv_thanquol_narrative_mission_4",
			override_text = {"scripted_objective_wh3_dlc29_skv_narrative_mission_economic_region_target"},
			objective_region = "wh3_main_combi_region_skavenblight",
			objective_plan_key = "economic",
			payloads = {
				"add_ancillary_to_faction_pool{ancillary_key wh3_dlc29_anc_arcane_item_morskittar_notes;}",
				"faction_pooled_resource_transaction{resource wh3_dlc29_skv_warpstone;factor missions;amount 500;context absolute;}"
			},
			incident_setup = {
				["wh3_dlc29_skv_schemer_grey_seer"] = "wh3_dlc29_skv_thanquol_narrative_incident_2_1_grey_seer",
				["wh3_dlc29_skv_schemer_master_assassin"] = "wh3_dlc29_skv_thanquol_narrative_incident_2_2_assassin",
				["wh3_dlc29_skv_schemer_warlord"] = "wh3_dlc29_skv_thanquol_narrative_incident_2_3_warlord",
				["wh3_dlc29_skv_schemer_warlock_master"] = "wh3_dlc29_skv_thanquol_narrative_incident_2_4_warlock",
			},
			scripted_payload = function()
				--[[
				local faction = cm:get_faction(episode_narrative_thanquol.faction_key)
				local anciliary_key = get_random_ancillary_key_for_faction(episode_narrative_thanquol.faction_key, false, "rare")
				cm:add_ancillary_to_faction(faction, anciliary_key, false)
				]]
			end
		},
		-- ACT 2
		["mission_5"] = {
			key = "wh3_dlc29_skv_thanquol_narrative_mission_5",
			objective_mission_key = "wh3_dlc29_qb_skv_thanquol_staff_of_the_horned_rat", -- objective of this mission is this mission to be completed. 
			override_text = {"scripted_objective_wh3_dlc29_skv_narrative_mission_5"},
			payloads = {
				"text_display dummy_wh3_dlc29_skv_thanquol_narrative_unlock_underlings",
				"text_display dummy_wh3_dlc29_skv_thanquol_narrative_unlock_undercity_plan",
				"text_display dummy_wh3_dlc29_skv_thanquol_narrative_mission_4_payload_building",
			},
			scripted_payload = function()
				for _, schemer_agent_subtype_key in ipairs(thanquol_schemers.agent_subtypes) do
					local schemer_family_member = thanquol_schemers.get_schemer_family_member(schemer_agent_subtype_key)
					thanquol_schemers.unlock_schemer(schemer_family_member)
				end

				local faction = cm:get_faction(episode_narrative_thanquol.faction_key)
				cm:apply_effect_bundle("wh3_dlc29_chaotic_plans_enable_magic", episode_narrative_thanquol.faction_key, 0)
				cm:set_script_state(faction, thanquol_schemers.magic_plan_subtypes.undercity.rat_group, true)

				for _, building_keys in ipairs(episode_narrative_thanquol.thanquol_engine_building_levels) do
					cm:remove_event_restricted_building_record_for_faction(building_keys, episode_narrative_thanquol.faction_key)
				end

			end
		},
		["mission_6_1"] = {
			key = "wh3_dlc29_skv_thanquol_narrative_mission_6_1",
		},
		["mission_6_2"] = {
			key = "wh3_dlc29_skv_thanquol_narrative_mission_6_2",
			override_text = {"scripted_objective_wh3_dlc29_skv_narrative_mission_undercity"},
			objective_plan_key = "magic",
			objective_base_token_key = "wh3_dlc29_magic_create_undercity_1",
			objective_total = 3,
			payloads = {
				"effect_bundle{bundle_key wh3_dlc29_skv_thanquol_narrative_mission_reward_6_2;turns 0;}",
				"faction_pooled_resource_transaction{resource wh3_dlc29_skv_warpstone;factor missions;amount 200;context absolute;}",
			}
		},
		-- ACT 3
		["mission_7_1"] = {
			key = "wh3_dlc29_skv_thanquol_narrative_mission_7_1",
		},
		["mission_7_2"] = {
			key = "wh3_dlc29_skv_thanquol_narrative_mission_7_2",
		},
		["mission_7_3"] = {
			key = "wh3_dlc29_skv_thanquol_narrative_mission_7_3",
		},
		["mission_final"] = {
			key = "wh3_dlc29_qb_skv_thanquol_final_battle",
		},
	},
	
	dilemma_1 		= "wh3_dlc29_skv_thanquol_narrative_dilemma_1",
	dilemma_2_1 	= "wh3_dlc29_skv_thanquol_narrative_dilemma_2_1",
	dilemma_2_2 	= "wh3_dlc29_skv_thanquol_narrative_dilemma_2_2",
	dilemma_2_3 	= "wh3_dlc29_skv_thanquol_narrative_dilemma_2_3",
	dilemma_3 		= "wh3_dlc29_skv_thanquol_narrative_dilemma_3",
	incident_1 		= "wh3_dlc29_skv_thanquol_narrative_act_1",
	incident_2 		= "wh3_dlc29_skv_thanquol_narrative_act_2",
	incident_3 		= "wh3_dlc29_skv_thanquol_narrative_act_3",
	incident_4 		= "wh3_dlc29_skv_thanquol_narrative_act_4",

	prerequisites =
	{
		min_turn = 2
	},

	persistent =
	{
		current_stage = 1,
		completed_mission_count = 
		{
			[1] = 0,
			[2] = 0,
			[3] = 0,
  			[4] = 0
		},
		stages_persistent_data =
		{
			-- stage_persistent_data_table,
		},

		---------------------
		-- persistent data specific to this episode

		-- result from dilemmas
		dilemma_choices =
		{
			-- [dilemma_key] = [choice_index]
		},
		completed_missions = 
		{
			-- it could be a regular vector of strings, but I think this is easier to check and a bit more performant
			-- [mission_key] = true,
		},
	},
}

episode_narrative_thanquol.stages = 
{
	-- ACT I mission 1
	{
		stage_key = "narrative_thanquol_act1_mis1",
		payloads = {
			{
				payload_type = "incident",
				faction_key = episode_narrative_thanquol.faction_key,
				incident_key = episode_narrative_thanquol.incident_1,
			},
		},

		on_started = function(self)
			local faction = cm:get_faction(episode_narrative_thanquol.faction_key)
			local target_region = cm:get_region(episode_narrative_thanquol.missions["mission_1"].objective_region)
			episode_narrative_thanquol:episode_mission("mission_1", target_region)

			if target_region:owning_faction():name() == episode_narrative_thanquol.faction_key then
				cm:callback(
					function()
						cm:complete_scripted_mission_objective(
							episode_narrative_thanquol.faction_key ,
							episode_narrative_thanquol.missions["mission_1"].key,
							episode_narrative_thanquol.missions["mission_1"].key,
							true
						)
					end, 
				0.5)
			end
		end,

		on_mission_succeeded = function(self, mission_key)
			episode_narrative_thanquol:on_mission_success_check(mission_key, episode_narrative_thanquol.missions["mission_1"])
		end
	},
	-- ACT I mission 2
	{
		stage_key = "narrative_thanquol_act1_mis2",
		payloads =
		{
			{
				payload_type = "mission",
				mission_key = episode_narrative_thanquol.missions["mission_2"].key,
			},
		},

		on_mission_succeeded = function(self, mission_key)
			episode_narrative_thanquol:on_mission_success_check(mission_key, episode_narrative_thanquol.missions["mission_2"])
		end
	},
	-- ACT I dilemma 1
	{
		stage_key = "narrative_thanquol_act1_dil1",
		payloads =
		{
			{
				payload_type = "dilemma",
				faction_key = episode_narrative_thanquol.faction_key,
				dilemma_key = episode_narrative_thanquol.dilemma_1,
			},
		},

		on_dilemma_choice = function(self, dilemma_key, choice_index)
			if dilemma_key == episode_narrative_thanquol.dilemma_1 then
				episodes_manager.mark_dilemma_choice(episode_narrative_thanquol, dilemma_key, choice_index)
				episodes_manager:advance_stage(episode_narrative_thanquol)
				
				-- choice_index starts from 0 and the first schemer is unlocked at the start
				local schemer_family_member = thanquol_schemers.get_schemer_family_member(thanquol_schemers.agent_subtypes[choice_index + 2])
				thanquol_schemers.unlock_schemer(schemer_family_member)
			end
		end,
	},
	-- ACT I mission 3
	{
		stage_key = "narrative_thanquol_act1_mis3",
		payloads = {},
		on_started = function(self) 
			episode_narrative_thanquol:episode_mission("mission_3_1")
			episode_narrative_thanquol:episode_mission("mission_3_2")

			if not episode_narrative_thanquol.persistent.mission_3_data then 
				episode_narrative_thanquol.persistent.mission_3_data = {}
			end

			episode_narrative_thanquol.persistent.mission_3_data = {
					["mission_3_1"] = "military",
					["mission_3_2"] = "economic"
			}
		end,

		on_mission_succeeded = function(self, mission_key)
			episode_narrative_thanquol:on_mission_success_check(mission_key, episode_narrative_thanquol.missions["mission_3_1"], {episode_narrative_thanquol.missions["mission_3_1"].key, episode_narrative_thanquol.missions["mission_3_2"].key})
			episode_narrative_thanquol:on_mission_success_check(mission_key, episode_narrative_thanquol.missions["mission_3_2"], {episode_narrative_thanquol.missions["mission_3_1"].key, episode_narrative_thanquol.missions["mission_3_2"].key})
		end
	},
	-- ACT I mission 4
	{
		stage_key = "narrative_thanquol_act1_mis4",
		payloads =
		{
			-- reveal skavenblightm here on in on_started
			{
				payload_type = "incident",
				faction_key = episode_narrative_thanquol.faction_key,
				incident_key = episode_narrative_thanquol.incident_2,
			},
		},
		on_started = function(self)
			local skavenblight_region = cm:get_region(episode_narrative_thanquol.missions["mission_4"].objective_region)
			episode_narrative_thanquol:episode_mission("mission_4", skavenblight_region)
			cm:make_region_visible_in_shroud(episode_narrative_thanquol.faction_key, episode_narrative_thanquol.missions["mission_4"].objective_region)
			if skavenblight_region:owning_faction():name() == episode_narrative_thanquol.faction_key or devastation_manager:is_region_devastated(episode_narrative_thanquol.missions["mission_4"].objective_region) then
				cm:callback(
					function()
						cm:complete_scripted_mission_objective(
							episode_narrative_thanquol.faction_key ,
							episode_narrative_thanquol.missions["mission_4"].key,
							episode_narrative_thanquol.missions["mission_4"].key,
							true
						)
					end, 
				0.5)
			end
		end,

		on_mission_succeeded = function(self, mission_key)
			episode_narrative_thanquol:on_mission_success_check(mission_key, episode_narrative_thanquol.missions["mission_4"])
		end
	},

	-- ACT II mis 5
	{
		stage_key = "narrative_thanquol_act2_mis5",
		payloads ={},
		on_started = function(self)
			episode_narrative_thanquol:episode_mission("mission_5")

			if episode_narrative_thanquol.persistent.is_mission_5_objective_mission_complete then
				cm:callback(
					function()
						cm:complete_scripted_mission_objective(
							episode_narrative_thanquol.faction_key ,
							episode_narrative_thanquol.missions["mission_5"].key,
							episode_narrative_thanquol.missions["mission_5"].key,
							true
						)
					end, 
				0.5)
			end
		end,
		on_dilemma_choice = function(self, dilemma_key, choice_index)
			episode_narrative_thanquol:dilemma_3_wrapper(dilemma_key, choice_index)
		end,
		on_mission_succeeded = function(self, mission_key)
			episode_narrative_thanquol:on_mission_success_check(mission_key, episode_narrative_thanquol.missions["mission_5"])
		end
	},
	-- ACT II mis 6
	{
		stage_key = "narrative_thanquol_act2_mis6",
		payloads =
		{
			{
				payload_type = "incident",
				incident_key = episode_narrative_thanquol.incident_3,
			},
			{
				payload_type = "mission",
				mission_key = episode_narrative_thanquol.missions["mission_6_1"].key,
			},
		},

		on_started = function(self)
			episode_narrative_thanquol:episode_mission("mission_6_2")
		end,
		on_dilemma_choice = function(self, dilemma_key, choice_index)
			episode_narrative_thanquol:dilemma_3_wrapper(dilemma_key, choice_index)
		end,
		on_mission_succeeded = function(self, mission_key)
			episode_narrative_thanquol:on_mission_success_check(mission_key, episode_narrative_thanquol.missions["mission_6_1"], {episode_narrative_thanquol.missions["mission_6_1"].key, episode_narrative_thanquol.missions["mission_6_2"].key})
			episode_narrative_thanquol:on_mission_success_check(mission_key, episode_narrative_thanquol.missions["mission_6_2"], {episode_narrative_thanquol.missions["mission_6_1"].key, episode_narrative_thanquol.missions["mission_6_2"].key})
		end,
	},
	-- ACT III final mission
	{
		stage_key = "narrative_thanquol_act3_mission_final",
		payloads =
		{
			{
				payload_type = "mission",
				mission_key = episode_narrative_thanquol.missions["mission_final"].key,
			},
		},
		on_started = function(self)
			local faction = cm:get_faction(episode_narrative_thanquol.faction_key)
			if cm:mission_is_active_for_faction(faction, episode_narrative_thanquol.missions["mission_7_1"].key) then
				cm:cancel_custom_mission(episode_narrative_thanquol.faction_key, episode_narrative_thanquol.missions["mission_7_1"].key)
			end
			if cm:mission_is_active_for_faction(faction, episode_narrative_thanquol.missions["mission_7_2"].key) then
				cm:cancel_custom_mission(episode_narrative_thanquol.faction_key, episode_narrative_thanquol.missions["mission_7_2"].key)
			end
			if cm:mission_is_active_for_faction(faction, episode_narrative_thanquol.missions["mission_7_3"].key) then
				cm:cancel_custom_mission(episode_narrative_thanquol.faction_key, episode_narrative_thanquol.missions["mission_7_3"].key)
			end
			thanquol_chaotic_plans:lock_tokens_until_final_battle_toggle(faction, false)
		end,
		on_mission_succeeded = function(self, mission_key)
			if episode_narrative_thanquol:on_mission_success_check(mission_key, episode_narrative_thanquol.missions["mission_final"]) then
				local faction = cm:get_faction(episode_narrative_thanquol.faction_key)
				cm:set_script_state(faction, thanquol_schemers.magic_plan_subtypes.pull_moon.rat_group, true)
			end
		end,
	},
}

-------------------
---- REQUIRED -----
-------------------

episode_narrative_thanquol.is_available_this_game = function(self)
	local faction = cm:get_faction(self.faction_key)

	if (not faction) 
		or faction:is_null_interface() 
		or faction:is_human() == false 
		or cm:is_multiplayer()
	then
		return false
	end

	return true
end

episode_narrative_thanquol.can_start = function(self)
	return true
end

episode_narrative_thanquol.start_episode = function(self)
	cm:set_script_state(episode_narrative_thanquol.episode_active_shared_state, true)
	episodes_manager:start_stage(self, 1)
end

episode_narrative_thanquol.execute_stage_payloads = function(self, stage_index)
	local stage_table = episode_narrative_thanquol.stages[stage_index]

	if not stage_table then
		return
	end

	for i = 1, #stage_table.payloads do
		local payload = stage_table.payloads[i]
		local params_table = {}

		payloads_executor.execute_payload(payload, params_table)
	end
end

------------------
--- FUNCTIONS ----
------------------

episode_narrative_thanquol.episode_mission = function(self, mission_id, entity)
	local mission_table = episode_narrative_thanquol.missions[mission_id]
	local mm = mission_manager:new(episode_narrative_thanquol.faction_key, mission_table.key)				
	mm:add_new_objective("SCRIPTED")
	mm:add_condition("script_key "..mission_table.key)
	
	local add_description =  mission_table.override_text

	if add_description then
		for i = 1, #add_description do
			mm:add_condition("override_text mission_text_text_"..add_description[i])
		end
	end

	if mission_table.objective_total then 
		mm:add_condition("total " .. mission_table.objective_total)
		mm:add_condition("count 0")
		mm:add_condition("count_completion")
	end
	
	local payloads = mission_table.payloads

	if payloads then
		for i = 1, #payloads do
			mm:add_payload(payloads[i])
		end
	end
	mm:set_should_whitelist(false);
	mm:set_mission_issuer("CLAN_ELDERS")
	mm:trigger()

	if entity then
		cm:set_scripted_mission_entity_completion_states(mission_table.key, mission_table.key, {{entity, false}})
	end

	if mission_table.objective_total then
		for i = 1, #add_description do
			cm:set_scripted_mission_text(mission_table.key, mission_table.key, "mission_text_text_"..add_description[i], 0,  mission_table.objective_total)
		end
	end
end

episode_narrative_thanquol.on_mission_success_check = function(self, mission_key, mission_table, missions_required_to_advance_stage)
	if mission_key == mission_table.key then
		episodes_manager.mark_mission_completed(episode_narrative_thanquol, mission_key)
		
		if is_function(mission_table.scripted_payload) then
			mission_table:scripted_payload()
		end

		if missions_required_to_advance_stage then
			local all_missions_completed = true
			for i, mission_key in ipairs(missions_required_to_advance_stage) do
				if not episodes_manager.is_mission_completed(episode_narrative_thanquol, mission_key) then
					all_missions_completed = false
				end
			end
			if all_missions_completed then
				episodes_manager:advance_stage(episode_narrative_thanquol)
			end
		else		
			episodes_manager:advance_stage(episode_narrative_thanquol)
		end
		return true
	end
	return false
end

function faction_condition(region)
	return not region:is_abandoned() and region:owning_faction():name() ~= episode_narrative_thanquol.faction_key
end

episode_narrative_thanquol.get_neighbouring_region = function(number_of_regions_to_return)
	local candidates = cm:get_regions_adjacent_to_faction(episode_narrative_thanquol.faction_key, faction_condition)
	local regions_to_return = {}

	if #candidates < number_of_regions_to_return then
		out("error: episode_narrative_thanquol.get_neighbouring_region called, but there are not enough neigbouring regions.  " .. number_of_regions_to_return .. " needed, but we have: " .. #candidates)
		return candidates
	end

	for i = 0, number_of_regions_to_return - 1 do 
		local rand_number = cm:random_number(#candidates, 1)
		table.insert(regions_to_return, candidates[rand_number])
		table.remove(candidates, rand_number)
	end
	
	return regions_to_return
end

episode_narrative_thanquol.dilemma_3_wrapper = function(self, dilemma_key, choice_index)
	if dilemma_key == episode_narrative_thanquol.dilemma_3 then
		episodes_manager.mark_dilemma_choice(episode_narrative_thanquol, dilemma_key, choice_index)
		local dilemma_choice = episodes_manager.get_dilemma_choice(episode_narrative_thanquol, episode_narrative_thanquol.dilemma_3)
		if dilemma_choice == 0 then
			cm:trigger_mission(episode_narrative_thanquol.faction_key, episode_narrative_thanquol.missions["mission_7_1"].key, true, true)
		elseif dilemma_choice == 1 then
			cm:trigger_mission(episode_narrative_thanquol.faction_key, episode_narrative_thanquol.missions["mission_7_2"].key, true, true)
		else
			cm:trigger_mission(episode_narrative_thanquol.faction_key, episode_narrative_thanquol.missions["mission_7_3"].key, true, true)
		end
	end
end
---------------
-- LISTENERS --
---------------

core:add_listener(
	"thanquol_narrative_listeners_mission_completed_for_mis_5",
	"MissionSucceeded",
	function(context)
		return context:faction():name() == episode_narrative_thanquol.faction_key and context:mission():mission_record_key() == episode_narrative_thanquol.missions["mission_5"].objective_mission_key
	end,
	function(context)
		episode_narrative_thanquol.persistent.is_mission_5_objective_mission_complete = true

		if cm:mission_is_active_for_faction(context:faction(), episode_narrative_thanquol.missions["mission_5"].key) then
			cm:complete_scripted_mission_objective(
				episode_narrative_thanquol.faction_key ,
				episode_narrative_thanquol.missions["mission_5"].key,
				episode_narrative_thanquol.missions["mission_5"].key,
				true
			)
		end
	end,
	true
)

core:add_listener(
	"thanquol_narrative_listeners_mission_completed_for_mis_3",
	"ChaoticPlanSettlementAttackedEvent",
	function(context)
		local plan_faction = context:plan():faction()
		return plan_faction:name() == episode_narrative_thanquol.faction_key and cm:mission_is_active_for_faction(plan_faction, episode_narrative_thanquol.missions["mission_3_1"].key)
	end,
	function(context)
		local active_plan = context:plan()

		for episode_key, objective_plan_key in dpairs(episode_narrative_thanquol.persistent.mission_3_data) do
			if objective_plan_key == active_plan:type_key() then
				local mission_table = episode_narrative_thanquol.missions[episode_key]
				cm:increase_scripted_mission_count(mission_table.key,  mission_table.key, 1)
			end
		end
	end,
	true
)

core:add_listener(
	"thanquol_narrative_listeners_ChaoticPlanExecutedEvent",
	"ChaoticPlanExecutedEvent",
	function(context)
		local plan_faction = context:plan():faction()
		return plan_faction:name() == episode_narrative_thanquol.faction_key and 
					(cm:mission_is_active_for_faction(plan_faction, episode_narrative_thanquol.missions["mission_3_1"].key)
					or cm:mission_is_active_for_faction(plan_faction, episode_narrative_thanquol.missions["mission_3_2"].key))
	end,
	function(context)
		local plan = context:plan()

		for episode_key, objective_plan_key in dpairs(episode_narrative_thanquol.persistent.mission_3_data) do
			if objective_plan_key == plan:type_key() then
				local mission_table = episode_narrative_thanquol.missions[episode_key]
				cm:increase_scripted_mission_count(mission_table.key,  mission_table.key, 1)
			end
		end
	end,
	true
)

core:add_listener(
	"thanquol_narrative_listeners_ChaoticPlanExecutedEvent_Skavenblight",
	"ChaoticPlanExecutedEvent",
	function(context)
		local plan_faction = context:plan():faction()
		return plan_faction:name() == episode_narrative_thanquol.faction_key and
					(cm:mission_is_active_for_faction(plan_faction, episode_narrative_thanquol.missions["mission_1"].key)
					or cm:mission_is_active_for_faction(plan_faction, episode_narrative_thanquol.missions["mission_4"].key))
	end,
	function(context)
		local plan = context:plan()
		local region = plan:region()
		local region_name = region:name()
		local mission_table = {episode_narrative_thanquol.missions["mission_1"], episode_narrative_thanquol.missions["mission_4"]}
		for i, mission_data in ipairs(mission_table) do
			if mission_data.objective_region == region_name and mission_data.objective_plan_key == plan:type_key() then
				cm:complete_scripted_mission_objective(episode_narrative_thanquol.faction_key, mission_data.key,  mission_data.key, true)

				if mission_data.incident_setup then
					local plan_faction = plan:faction()
					local schemer_character = plan:schemer():character()
					local schemer_cqi = schemer_character:command_queue_index()
					local schemer_subtype = schemer_character:character_subtype_key()
					if mission_data.incident_setup[schemer_subtype] then
						cm:trigger_incident_with_targets(plan_faction:command_queue_index(), mission_data.incident_setup[schemer_subtype], 0, 0, schemer_cqi, 0, 0, 0)
					end
				end
			end
		end
	end,
	true
)

core:add_listener(
	"thanquol_narrative_listeners_mission_completed_for_mis_4",
	"RegionFactionChangeEvent",
	function(context)
		local owning_faction = context:region():owning_faction()
		return owning_faction:name() == episode_narrative_thanquol.faction_key and 
					(cm:mission_is_active_for_faction(owning_faction, episode_narrative_thanquol.missions["mission_1"].key)
					or cm:mission_is_active_for_faction(owning_faction, episode_narrative_thanquol.missions["mission_4"].key))
	end,
	function(context)
		local region = context:region()
		local region_name = region:name()
		local mission_table = {episode_narrative_thanquol.missions["mission_1"], episode_narrative_thanquol.missions["mission_4"]}
		for i, mission_data in ipairs(mission_table) do
			if mission_data.objective_region == region_name then
				cm:complete_scripted_mission_objective(episode_narrative_thanquol.faction_key, mission_data.key,  mission_data.key, true)
			end
		end
	end,
	true
)

core:add_listener(
	"thanquol_narrative_listeners_ChaoticPlanExecutedEvent_Undercity",
	"ChaoticPlanExecutedEvent",
	function(context)
		local plan_faction = context:plan():faction()
		return plan_faction:name() == episode_narrative_thanquol.faction_key and cm:mission_is_active_for_faction(plan_faction, episode_narrative_thanquol.missions["mission_6_2"].key)
	end,
	function(context)
		local plan = context:plan()
		local region = plan:region()
		local region_name = region:name()
		local mission_table = episode_narrative_thanquol.missions["mission_6_2"]
		if mission_table.objective_plan_key == plan:type_key() and mission_table.objective_base_token_key == plan:magic_plan_base_token() then
			cm:increase_scripted_mission_count(mission_table.key, mission_table.key, 1)
		end
	end,
	true
)

core:add_listener(
	"thanquol_narrative_listeners_BuildingCompleted_Engine_4",
	"BuildingCompleted",
	function(context)
		local building = context:building()
		local building_faction = building:faction()
		return building_faction:name() == episode_narrative_thanquol.faction_key and table.find(episode_narrative_thanquol.thanquol_engine_building_levels, building:name())
	end,
	function(context)
		local building = context:building()
		local building_faction = building:faction()

		if string.find(building:name(), "_4") then
			cm:trigger_dilemma(episode_narrative_thanquol.faction_key, episode_narrative_thanquol.dilemma_3)
		end
	end,
	true
)

core:add_listener(
	"thanquol_narrative_listeners_ScriptedEventRegionDevastated",
	"ScriptedEventRegionDevastated",
	function(context)
		local thanquol_faction = cm:get_faction(episode_narrative_thanquol.faction_key)
		return	cm:mission_is_active_for_faction(thanquol_faction, episode_narrative_thanquol.missions["mission_1"].key)
			or cm:mission_is_active_for_faction(thanquol_faction, episode_narrative_thanquol.missions["mission_4"].key)
	end,
	function(context)
		local region = context:region()
		local region_name = region:name()
		local mission_table = {episode_narrative_thanquol.missions["mission_1"], episode_narrative_thanquol.missions["mission_4"]}
		for i, mission_data in ipairs(mission_table) do
			if mission_data.objective_region == region_name then
				cm:complete_scripted_mission_objective(episode_narrative_thanquol.faction_key, mission_data.key,  mission_data.key, true)
			end
		end
	end,
	true
)

core:add_listener(
	"thanquol_narrative_listeners_factionturnstart_devastationfixup",
	"FactionTurnStart",
	function(context)
		local faction = context:faction()
		local thanquol_faction = cm:get_faction(episode_narrative_thanquol.faction_key)
		return faction:name() == episode_narrative_thanquol.faction_key and (cm:mission_is_active_for_faction(thanquol_faction, episode_narrative_thanquol.missions["mission_1"].key)
			or cm:mission_is_active_for_faction(thanquol_faction, episode_narrative_thanquol.missions["mission_4"].key))
	end,
	function(context)
		local mission_table = {episode_narrative_thanquol.missions["mission_1"], episode_narrative_thanquol.missions["mission_4"]}
		for i, mission_data in ipairs(mission_table) do
			if devastation_manager:is_region_devastated(mission_data.objective_region) then
				cm:complete_scripted_mission_objective(episode_narrative_thanquol.faction_key, mission_data.key,  mission_data.key, true)
			end
		end
	end,
	true
)




-------------------
-- SELF REGISTER --
-------------------

cm:add_first_tick_callback(
	function()
		-- this check can't be called before add_first_tick_callback, as it needs the world ready and initialized
		if not episode_narrative_thanquol:is_available_this_game() then
			return
		end
		episodes_manager:add_available_episode(episode_narrative_thanquol)
	end
)