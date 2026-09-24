episode_nagash_sandbox = {
	episode_name = "episode_nagash_sandbox",
	episode_set = "end_times",
	episode_active_shared_state = "episode_nagash_sandbox",
	foreshadow_key_1 = "nagash_introduction_1",
	foreshadow_key_end = "episode_nagash_narrative_active", -- empty key means we hide the side button
	-- TODO: enable the episode when it is working properly
	episode_disabled = true,
	-- things that need to happen for the episode to be available to start
	prerequisites =
	{
		min_turn = 1
	},

	---------------------------------------------------------------------
	-- config stuff that will be linked from different stages/payloads
	nagash_cheap_unit_list = {
		wh2_dlc09_tmb_inf_skeleton_warriors_0 			= 2,
		wh2_dlc09_tmb_inf_skeleton_spearmen_0 			= 2,
		wh2_dlc09_tmb_inf_tomb_guard_0 					= 6,
		wh2_dlc09_tmb_inf_tomb_guard_1 					= 8,
		wh2_dlc09_tmb_inf_nehekhara_warriors_0 			= 8,
		wh2_dlc09_tmb_inf_skeleton_archers_0 			= 4,

		--Cavalry
		wh2_dlc09_tmb_cav_skeleton_horsemen_0 			= 4,
		wh2_dlc09_tmb_cav_nehekhara_horsemen_0 			= 2,
		wh2_dlc09_tmb_veh_skeleton_chariot_0 			= 2,
		wh2_dlc09_tmb_veh_skeleton_archer_chariot_0 	= 3,
		wh2_dlc09_tmb_cav_skeleton_horsemen_archers_0 	= 6,
		wh2_dlc09_tmb_mon_sepulchral_stalkers_0 		= 3,
		wh2_dlc09_tmb_cav_necropolis_knights_0 			= 1,
		wh2_dlc09_tmb_cav_necropolis_knights_1 			= 2,

		--Monsters
		wh2_dlc09_tmb_mon_carrion_0 					= 1,
		wh2_dlc09_tmb_mon_ushabti_0 					= 1,
		wh2_dlc09_tmb_mon_ushabti_1 					= 1,
		wh2_dlc09_tmb_veh_khemrian_warsphinx_0 			= 1,
		wh2_dlc09_tmb_mon_tomb_scorpion_0 				= 1,

		--Artillery
		wh2_dlc09_tmb_art_screaming_skull_catapult_0 	= 1,
		wh2_dlc09_tmb_art_casket_of_souls_0 			= 1,
	},

	nagash_expensive_unit_list = {
		wh2_dlc09_tmb_inf_skeleton_warriors_0 			= 2,
		wh2_dlc09_tmb_inf_skeleton_spearmen_0 			= 2,
		wh2_dlc09_tmb_inf_tomb_guard_0 					= 6,
		wh2_dlc09_tmb_inf_tomb_guard_1 					= 8,
		wh2_dlc09_tmb_inf_nehekhara_warriors_0 			= 8,
		wh2_dlc09_tmb_inf_skeleton_archers_0 			= 4,

		--Cavalry
		wh2_dlc09_tmb_cav_skeleton_horsemen_0 			= 4,
		wh2_dlc09_tmb_cav_nehekhara_horsemen_0 			= 2,
		wh2_dlc09_tmb_veh_skeleton_chariot_0 			= 2,
		wh2_dlc09_tmb_veh_skeleton_archer_chariot_0 	= 3,
		wh2_dlc09_tmb_cav_skeleton_horsemen_archers_0 	= 6,
		wh2_dlc09_tmb_mon_sepulchral_stalkers_0 		= 3,
		wh2_dlc09_tmb_cav_necropolis_knights_0 			= 1,
		wh2_dlc09_tmb_cav_necropolis_knights_1 			= 2,

		--Monsters
		wh2_dlc09_tmb_mon_carrion_0 					= 4,
		wh2_dlc09_tmb_mon_ushabti_0 					= 2,
		wh2_dlc09_tmb_mon_ushabti_1 					= 4,
		wh2_dlc09_tmb_veh_khemrian_warsphinx_0 			= 2,
		wh2_dlc09_tmb_mon_tomb_scorpion_0 				= 4,
		wh2_dlc09_tmb_mon_heirotitan_0 					= 2,
		wh2_dlc09_tmb_mon_necrosphinx_0 				= 2,
		wh2_pro06_tmb_mon_bone_giant_0					= 4,

		--Artillery
		wh2_dlc09_tmb_art_screaming_skull_catapult_0 = 2,
		wh2_dlc09_tmb_art_casket_of_souls_0 = 3,
	},

	nagash_ressurected_unit_list = {
		wh2_dlc09_tmb_inf_skeleton_warriors_0 			= 2,
		wh2_dlc09_tmb_inf_skeleton_spearmen_0 			= 2,
		wh2_dlc09_tmb_inf_tomb_guard_0 					= 6,
		wh2_dlc09_tmb_inf_tomb_guard_1 					= 8,
		wh2_dlc09_tmb_inf_nehekhara_warriors_0 			= 8,
		wh2_dlc09_tmb_inf_skeleton_archers_0 			= 4,

		--Cavalry
		wh2_dlc09_tmb_cav_skeleton_horsemen_0 			= 4,
		wh2_dlc09_tmb_cav_nehekhara_horsemen_0 			= 2,
		wh2_dlc09_tmb_veh_skeleton_chariot_0 			= 2,
		wh2_dlc09_tmb_veh_skeleton_archer_chariot_0 	= 3,
		wh2_dlc09_tmb_cav_skeleton_horsemen_archers_0 	= 6,
		wh2_dlc09_tmb_mon_sepulchral_stalkers_0 		= 3,
		wh2_dlc09_tmb_cav_necropolis_knights_0 			= 1,
		wh2_dlc09_tmb_cav_necropolis_knights_1 			= 2,

		--Monsters
		wh2_dlc09_tmb_mon_carrion_0 					= 4,
		wh2_dlc09_tmb_mon_ushabti_0 					= 2,
		wh2_dlc09_tmb_mon_ushabti_1 					= 4,
		wh2_dlc09_tmb_veh_khemrian_warsphinx_0 			= 2,
		wh2_dlc09_tmb_mon_tomb_scorpion_0 				= 4,
		wh2_dlc09_tmb_mon_heirotitan_0 					= 2,
		wh2_dlc09_tmb_mon_necrosphinx_0 				= 2,
		wh2_pro06_tmb_mon_bone_giant_0					= 4,

		--Artillery
		wh2_dlc09_tmb_art_screaming_skull_catapult_0 = 2,
		wh2_dlc09_tmb_art_casket_of_souls_0 = 3,
	},


	list_of_region_groups =
	{
		location_1 =
		{
			regions_to_pick = 2,
			region_group = "cai_region_hint_sub_area_eastern_empire",
		},
		location_2 =
		{
			regions_to_pick = 2,
			region_group = "cai_region_hint_sub_area_northern_empire",
		},
		location_3 =
		{
			regions_to_pick = 2,
			region_group = "cai_region_hint_sub_area_southern_empire",
		},
		location_all =
		{
			regions_to_pick = 2,
			region_group = "cai_chaos_region_hint_area_empire",
		},
	},

	nagash_faction_key = "wh3_dlc29_nag_host_of_nagash",
	armies_owner_faction_key = "wh2_dlc09_tmb_the_sentinels",
	army_template = "endgame_pyramid_of_nagash",
	dilemma_support_nagash = "wh3_dlc29_episode_nagash_support",
	dilemma_support_nagash_support_choice = 0,

	-- if the players win against Nagash, the faction resurrection is delayed by this amount of turns
	-- anything below 1 means no resurrection
	resurrection_delay_turns = 30,

	-- culmination setup
	culmination_marker_key = "NagashCulminationMarker",

	-- coding setup
	culmination_marker_interaction_event = "ScriptEventNagashEncounterMarkerBattleTriggered",
	-------------------------------------------------------------------------------

	persistent =
	{
		-- 'current_stage_index' is MANDATORY for all active episodes
		-- current_stage_index = [number]

		-- maps the stage data by stage index
		-- the data includes
		--{
		--	turn_started = [number],
		--}
		stages_persistent_data =
		{
			-- stage_persistent_data_table,
		},

		---------------------
		-- persistent data specific to this episode

		-- if the faction supports Nagash (true) or opposes him (false)
		faction_nagash_relations =
		{
			-- [faction_key] = true/false
		},
		-- when the episode starts we pick a few regions from each group to apply effects
		picked_regions =
		{
			-- [region_list_name] = {"region_name", ... }
		},
		is_nagash_defeated = false,
		nagash_original_region_key = "",
		nagash_culmination_region_key = "",
		nagash_family_member_cqi = -1,

		-- if the players win, Nagash will be resurrected on this turn, at the original region
		nagash_delayed_resurrection_turn = -1,
	},
}

episode_nagash_sandbox.stages =
{
	-- episode_nagash_sandbox_stage_1
	-- spawns some armies
	{
		stage_key = "episode_nagash_sandbox_stage_1",
		-- generic properties of the episode
		min_duration = 1,
		max_duration = 2,

		stage_budget = 100000, -- this is used up
		payloads =
		{
			---------------------------------------------------------------
			-- Trigger foreshadowing popup
			{
				payload_type = "foreshadow",
				foreshadow_data_key = episode_nagash_sandbox.foreshadow_key_1,
			},
			-- spawn_armies
			{
				payload_type = "spawn_army",
				max_budget = 1000,
				max_units = 10,
				times_to_apply = 3,
				unit_list = episode_nagash_sandbox.nagash_cheap_unit_list,
				target_region_list = "location_1",
				force_owner = episode_nagash_sandbox.armies_owner_faction_key,
			},
			-- spawn_armies 2
			{
				payload_type = "spawn_army",
				max_budget = 2000,
				max_units = 10,
				times_to_apply = 3,
				unit_list = episode_nagash_sandbox.nagash_cheap_unit_list,
				target_region_list = "location_2",
				force_owner = episode_nagash_sandbox.armies_owner_faction_key,
			},
			--...
			-- spawn_armies all
			{
				payload_type = "spawn_army",
				max_budget = 2000,
				max_units = 10,
				times_to_apply = 2,
				unit_list = episode_nagash_sandbox.nagash_cheap_unit_list,
				target_region_list = "location_3",
				force_owner = episode_nagash_sandbox.armies_owner_faction_key,
			},
			---------------------------------------------------------------
			-- add/remove corruption

			-- removes all corruption from the chosen region in location_1
			{
				payload_type = "corruption",
				corruption_action = "remove_corruption",
				target_region_list = "location_1",
				corruption_factor = "events",
			},

			-- removes all corruption from the chosen region in location_2
			{
				payload_type = "corruption",
				corruption_action = "remove_corruption",
				target_region_list = "location_2",
				corruption_factor = "events",
			},

			-- removes all corruption from the chosen region in location_3
			{
				payload_type = "corruption",
				corruption_action = "remove_corruption",
				target_region_list = "location_3",
				corruption_factor = "events",
			},

			---------------------------------------------------------------
			-- -- diplomacy - declare_war
			-- {
			-- 	payload_type = "diplomacy",
			-- 	diplomacy_action = "declare_war",
			-- 	-- TODO: set attacker_faction_key to start working
			-- 	-- TODO: set defender_faction_key to start working
			-- },
		},

		get_next_stage_index = function()
			local human_factions = cm:get_human_factions()
			local is_single_player = (#human_factions == 1)
			if is_single_player then
				local sp_stage_index = episodes_manager:get_episode_stage_index_by_name(episode_nagash_sandbox, "episode_nagash_sandbox_stage_2_SP")
				return sp_stage_index
			end

			local mp_stage_index = episodes_manager:get_episode_stage_index_by_name(episode_nagash_sandbox, "episode_nagash_sandbox_stage_2_MP")
			return mp_stage_index
		end,
	},
	-- episode_nagash_sandbox_stage_2_SP
	-- spawn more armies, trigger dilemma for or against nagash
	{
		stage_key = "episode_nagash_sandbox_stage_2_SP",
		-- generic properties of the episode
		min_duration = 1,
		max_duration = 2,

		payloads =
		{
			-- spawn_armies
			{
				payload_type = "spawn_army",
				max_budget = 2000,
				max_units = 19,
				times_to_apply = 1,
				unit_list = episode_nagash_sandbox.nagash_cheap_unit_list,
				target_region_list = "location_1",
				force_owner = episode_nagash_sandbox.armies_owner_faction_key,
			},
			-- spawn_armies 2
			{
				payload_type = "spawn_army",
				max_budget = 4000,
				max_units = 19,
				times_to_apply = 3,
				unit_list = episode_nagash_sandbox.nagash_cheap_unit_list,
				target_region_list = "location_all",
				force_owner = episode_nagash_sandbox.armies_owner_faction_key,
			},
			-- dilemma support nagash
			{
				payload_type = "dilemma",
				dilemma_key = episode_nagash_sandbox.dilemma_support_nagash,
			},
		},

		get_next_stage_index = function()
			local next_stage_index = episodes_manager:get_episode_stage_index_by_name(episode_nagash_sandbox, "episode_nagash_sandbox_stage_3")
			return next_stage_index
		end,
	},
	-- episode_nagash_sandbox_stage_2_MP
	-- spawn more armies,
	-- no dilemma for or against nagash - for MP sessions where players need to be on the same side, so opposing Nagash, with just an event popup
	{
		stage_key = "episode_nagash_sandbox_stage_2_MP",
		-- generic properties of the episode
		min_duration = 1,
		max_duration = 2,

		on_started = function(self)
			-- in multiplayer all human factions fight against Nagash
			local nagash_support = episode_nagash_sandbox.persistent.faction_nagash_relations
			if not is_table(nagash_support) then
				episode_nagash_sandbox.persistent.faction_nagash_relations = {}
				nagash_support = episode_nagash_sandbox.persistent.faction_nagash_relations
			end

			local human_factions = cm:get_human_factions()
			for i = 1, #human_factions do
				nagash_support[human_factions[i]] = false
			end
		end,
		payloads =
		{
			-- spawn_armies
			{
				payload_type = "spawn_army",
				max_budget = 2000,
				max_units = 19,
				times_to_apply = 1,
				unit_list = episode_nagash_sandbox.nagash_cheap_unit_list,
				target_region_list = "location_1",
				force_owner = episode_nagash_sandbox.armies_owner_faction_key,
			},
			-- spawn_armies 2
			{
				payload_type = "spawn_army",
				max_budget = 4000,
				max_units = 19,
				times_to_apply = 3,
				unit_list = episode_nagash_sandbox.nagash_cheap_unit_list,
				target_region_list = "location_all",
				force_owner = episode_nagash_sandbox.armies_owner_faction_key,
			},
		},

		get_next_stage_index = function()
			local next_stage_index = episodes_manager:get_episode_stage_index_by_name(episode_nagash_sandbox, "episode_nagash_sandbox_stage_3")
			return next_stage_index
		end,
	},
	-- episode_nagash_sandbox_stage_3
	-- spawn the battle marker to fight for or against Nagash
	{
		stage_key = "episode_nagash_sandbox_stage_3",
		-- generic properties of the episode
		min_duration = 1,
		max_duration = 2,
		payloads =
		{
			-- spawn the battle marker to fight for or against Nagash
			{
				payload_type = "marker",
				region_key = "wh3_main_combi_region_middenheim",
				marker_action = "add_marker",
				marker_key = episode_nagash_sandbox.culmination_marker_key,
				spawn_type = "region",
				keep_after_battle = true,
				interaction_event = episode_nagash_sandbox.culmination_marker_interaction_event,
				marker_info = "wh3_dlc25_malakai_adventures_battle_high_elves",
			},
		},

		get_next_stage_index = function()
			local is_nagash_defeated = episode_nagash_sandbox.persistent.is_nagash_defeated
			if is_nagash_defeated then
				local next_stage_index = episodes_manager:get_episode_stage_index_by_name(episode_nagash_sandbox, "episode_nagash_sandbox_stage_4_nagash_stopped")
				return next_stage_index
			end

			local next_stage_index = episodes_manager:get_episode_stage_index_by_name(episode_nagash_sandbox, "episode_nagash_sandbox_stage_4_nagash_resurrected")
			return next_stage_index
		end,
	},
	-- episode_nagash_sandbox_stage_4_nagash_resurrected
	-- nagash was victorious - reward all factions fighting for Nagash
	-- either the players supporting Nagash won the battle, or the timer ran out
	{
		-- this is only used for debug purposes
		stage_key = "episode_nagash_sandbox_stage_4_nagash_resurrected",
		-- generic properties of the episode
		min_duration = 1,
		max_duration = 2,

		payloads =
		{
			-- despawn the battle marker to fight for or against Nagash
			{
				payload_type = "marker",
				marker_action = "remove_marker",
				marker_key = episode_nagash_sandbox.culmination_marker_key,
			},
			-- we remove the foreshadowing hud element
			{
				payload_type = "foreshadow",
				foreshadow_data_key = episode_nagash_sandbox.foreshadow_key_end,
			},
		},

		-- these rewards don't use the payloads, because they need to be given to the factions who won the episode
		victory_payloads =
		{
			{
				payload_type = "treasury",
				amount = 100000,
			},
			{
				payload_type = "ancillary",
				ancillary_key = "wh2_dlc09_anc_armour_armour_of_the_ages"
			},
			{
				payload_type = "ancillary",
				ancillary_key = "wh2_dlc09_anc_weapon_the_tomb_blade_of_arkhan"
			},
			{
				payload_type = "trait",
				trait_key = "wh2_dlc15_trait_defeated_eltharion"
			},
			{
				payload_type = "trait",
				trait_key = "wh2_dlc15_trait_defeated_imrik"
			},
		},

		on_started = function(self)
			episode_nagash_sandbox:resurrect_nagash_faction(episode_nagash_sandbox.persistent.nagash_culmination_region_key)
		end,

		get_next_stage_index = function()
			-- this is an end stage, it ends the episode
			return -1
		end,
	},
	-- episode_nagash_sandbox_stage_4_nagash_stopped
	-- nagash was defeated - reward all factions fighting for Nagash
	-- the players opposing Nagash won their battle in time
	{
		-- this is only used for debug purposes
		stage_key = "episode_nagash_sandbox_stage_4_nagash_stopped",
		-- generic properties of the episode
		min_duration = 1,
		max_duration = 2,

		payloads =
		{
			-- we remove the foreshadowing hud element
			{
				payload_type = "foreshadow",
				foreshadow_data_key = episode_nagash_sandbox.foreshadow_key_end,
			},
		},

		-- these rewards don't use the payloads, because they need to be given to the factions who won the episode
		victory_payloads =
		{
			{
				payload_type = "treasury",
				amount = 100000,
			},
			{
				payload_type = "ancillary",
				ancillary_key = "wh2_dlc09_anc_armour_armour_of_the_ages"
			},
			{
				payload_type = "ancillary",
				ancillary_key = "wh2_dlc09_anc_weapon_the_tomb_blade_of_arkhan"
			},
			{
				payload_type = "trait",
				trait_key = "wh2_dlc15_trait_defeated_eltharion"
			},
			{
				payload_type = "trait",
				trait_key = "wh2_dlc15_trait_defeated_imrik"
			},
		},

		on_started = function(self)
			episode_nagash_sandbox.persistent.delayed_resurrection_turn = cm:turn_number() + episode_nagash_sandbox.resurrection_delay_turns
			core:add_listener(
				"episode_nagash_sandbox_delayedResurrection",
				"WorldStartRound",
				true,
				function(context)
					local current_turn = cm:turn_number()
					if current_turn ~= episode_nagash_sandbox.persistent.delayed_resurrection_turn then
						return
					end

					core:remove_listener("episode_nagash_sandbox_delayedResurrection")
					episode_nagash_sandbox:resurrect_nagash_faction(episode_nagash_sandbox.persistent.nagash_original_region_key)
				end,
				true
			)
		end,

		get_next_stage_index = function()
			-- this is an end stage, it ends the episode
			return -1
		end,
	},
}

episode_nagash_sandbox.persistent =
{
	-- 'current_stage_index' is MANDATORY for all active episodes
	-- current_stage_index = [number]

	-- maps the stage data by stage index
	-- the data includes
	--{
	--	turn_started = [number],
	--}
	stages_persistent_data =
	{
		-- stage_persistent_data_table,
	},
	--
	-- picked regions
}
--------------------------
-- FUNCTIONS

-- function is optional. if missing, the episode is available by default
episode_nagash_sandbox.is_available_this_game = function(self)
	return false
end

-- episode_nagash_sandbox.can_start = function(self)
-- 	-- if no special checks - remove this and can_start_episode/are_turn_conditions_met will do

-- 	-- if special checks - check are_turn_conditions_met as well
-- 	return true
-- end

episode_nagash_sandbox.start_episode = function(self)
	cm:set_script_state(episode_nagash_sandbox.episode_active_shared_state, true)
	episode_nagash_sandbox:pick_regions()
	episodes_manager:start_stage(self, 1)
end

episode_nagash_sandbox.pick_regions = function(self)
	if not episode_nagash_sandbox.persistent.picked_regions then
		episode_nagash_sandbox.persistent.picked_regions = {}
	end

	for location_name, location_config in dpairs(self.list_of_region_groups) do
		local regions_list = cm:model():world():lookup_regions_from_region_group(location_config.region_group)
		local picked_regions_list = self:pick_regions_from_list(location_config.regions_to_pick, regions_list)
		self.persistent.picked_regions[location_name] = picked_regions_list
	end
end

episode_nagash_sandbox.pick_regions_from_list = function(self, number_of_regions_to_pick, regions_list)
	-- we need to copy the list so we can remove items from it and not change the original config
	local regions_list_copy = unique_table:region_list_to_unique_table(regions_list):to_table()
	-- if we need to provide more or as many regions as we have, we just return the list
	if #regions_list_copy <= number_of_regions_to_pick then
		return regions_list_copy
	end

	local picked_regions = {}
	for i = 1, number_of_regions_to_pick do
		local random_index = cm:random_number(#regions_list_copy, 1)
		local random_region = regions_list_copy[random_index]
		table.insert(picked_regions, random_region)
		table.remove(regions_list_copy, random_index)
	end
	return picked_regions
end

episode_nagash_sandbox.execute_stage_payloads = function(self, stage_index)
	local stage_table = episode_nagash_sandbox.stages[stage_index]
	if not stage_table then
		return
	end

	local current_execution_chosen_regions = {}
	for location_key, region_keys in dpairs(self.persistent.picked_regions) do
		if #region_keys > 0 then
			local random_index = cm:random_number(#region_keys, 1)
			current_execution_chosen_regions[location_key] = region_keys[random_index]
		end
	end

	local payloads = stage_table.payloads
	for i = 1, #stage_table.payloads do
		local payload = stage_table.payloads[i]
		local location_name = payload.target_region_list
		-- these are the names of the regions picked for this region list for this episode execution
		local params_table = {}
		params_table.force_owner = episode_nagash_sandbox.armies_owner_faction_key
		params_table.army_template = episode_nagash_sandbox.army_template
		if is_string(current_execution_chosen_regions[location_name]) then
			params_table.region_key = current_execution_chosen_regions[location_name]
		end
		payloads_executor.execute_payload(payload, params_table)

		if payload.payload_type == "marker" then
			episode_nagash_sandbox.persistent.nagash_culmination_region_key = payload.region_key
		end
	end
end

episode_nagash_sandbox.get_winning_factions = function(self)
	local did_nagash_win = not episode_nagash_sandbox.persistent.is_nagash_defeated
	local winning_factions = {}
	local nagash_support = episode_nagash_sandbox.persistent.faction_nagash_relations
	for faction_key, supported_nagash in dpairs(nagash_support) do
		-- if Nagash won, the factions that supported him are winning
		-- if Nagash lost, the factions that opposed him are winning
		if did_nagash_win == supported_nagash then
			table.insert(winning_factions, faction_key)
		end
	end
	return winning_factions
end

-- here 'available' means the episode is not active and not finished
episode_nagash_sandbox.is_in_available_state = function(self)
	if (episodes_manager.persistent.finished_episodes[episode_nagash_sandbox.episode_name]) then
		return false
	end

	for _episodes_set, episodes_of_set in pairs(episodes_manager.persistent.active_episodes) do
		for _, episode_name in ipairs(episodes_of_set) do
			return false
		end
	end

	return true
end

episode_nagash_sandbox.resurrect_nagash_faction = function(self, region_key)
	local region_interface = cm:get_region(region_key)
	if (not region_interface) or region_interface:is_null_interface() then
		return
	end
	local x_pos, y_pos = cm:find_valid_spawn_location_for_character_from_settlement(episode_nagash_sandbox.nagash_faction_key,
	region_key, false, true, 20)

	if x_pos < 1 then
		return
	end

	local unit_amount = 16
	local unit_list = episode_nagash_sandbox.nagash_ressurected_unit_list
	local generated_unit_list = payloads_executor.generate_army_payload_handler:generate_random_army(episode_nagash_sandbox.army_template, unit_list, unit_amount)

	local resurrected_character = cm:resurrect_family_member(episode_nagash_sandbox.persistent.nagash_family_member_cqi, episode_nagash_sandbox.nagash_faction_key)
	if not is_character(resurrected_character) then
		return
	end

	cm:create_force_with_existing_general(
		cm:char_lookup_str(resurrected_character),
		episode_nagash_sandbox.nagash_faction_key,
		generated_unit_list,
		region_key,
		x_pos,
		y_pos
	);
end

core:add_listener(
	"episode_nagash_sandbox_DilemmaChoiceMadeEvent",
	"DilemmaChoiceMadeEvent",
	function(context)
		return episode_nagash_sandbox.dilemma_support_nagash == context:dilemma();
	end,
	function(context)
		local target_faction = context:faction()
		local faction_name = target_faction:name()
		local choice = context:choice()

		local nagash_support = episode_nagash_sandbox.persistent.faction_nagash_relations
		if not is_table(nagash_support) then
			episode_nagash_sandbox.persistent.faction_nagash_relations = {}
			nagash_support = episode_nagash_sandbox.persistent.faction_nagash_relations
		end
		if choice == episode_nagash_sandbox.dilemma_support_nagash_support_choice then
			-- the faction supports Nagash
			nagash_support[faction_name] = true
		else
			-- the faction opposes Nagash
			nagash_support[faction_name] = false
		end
	end,
	true
)

core:add_listener(
	"NagashCulmination_ScriptEventNagashEncounterMarkerBattleTriggered",
	"ScriptEventNagashEncounterMarkerBattleTriggered",
	true,
	function(context)
		local character = context:character()

		-- this may be a set battle
		-- TODO: handle event of battle ended and remove the marker if player won the battle
		Forced_Battle_Manager:trigger_forced_battle_with_generated_army(
			character:military_force():command_queue_index(),
			episode_nagash_sandbox.armies_owner_faction_key,
			"wh2_dlc09_sc_tmb_tomb_kings", -- full list is in WH_Random_Army_Generator:generate_random_army
			19,
			math.clamp(math.round(cm:turn_number() / 10), 1, 10), --increases army strength based on turn number
			false,
			false,
			true,
			nil,
			nil,
			nil,
			math.clamp(math.round(cm:turn_number() / 10), 1, 10), --increases general level based on turn number
			nil
		)

		core:add_listener(
		"NagashCulmination_CharacterCompletedBattle",
		"CharacterCompletedBattle",
		true,
		function(context)
			local pending_battle = cm:model():pending_battle()
			if not pending_battle:attacker():won_battle() then
				return
			end
			local attacker_faction_key = pending_battle:attacker():faction():name()
			local nagash_support = episode_nagash_sandbox.persistent.faction_nagash_relations
			local is_attacker_supporting_nagash = nagash_support[attacker_faction_key]
			episode_nagash_sandbox.persistent.is_nagash_defeated = not is_attacker_supporting_nagash
			--add_marker
			local encounter_marker_object = Interactive_Marker_Manager:get_marker(episode_nagash_sandbox.culmination_marker_key)
			if encounter_marker_object then
				encounter_marker_object:despawn_all()
			else
				out("ERROR: payloads_executor could not find marker id '"..tostring(episode_nagash_sandbox.culmination_marker_key).."'!")
			end
		end,
		false
	)
	end,
	true
)

--------------
-- SELF REGISTER

cm:add_first_tick_callback(
	function()
		-- this check can't be called before add_first_tick_callback, as it needs the world ready and initialized
		if not episode_nagash_sandbox:is_available_this_game() then
			return
		end
		episodes_manager:add_available_episode(episode_nagash_sandbox)

		-- we kill the Nagash faction on the first turn, so we can resurrect him later
		local current_turn = cm:turn_number()
		if current_turn == 1 and episode_nagash_sandbox:is_in_available_state() and not episode_nagash_sandbox.episode_disabled then
			local nagash_faction_interface = cm:get_faction(episode_nagash_sandbox.nagash_faction_key)
			if not nagash_faction_interface:is_dead() then
				local home_region_interface = nagash_faction_interface:home_region()
				-- we save up the Nagash family member so we can ressurect Nagash later
				episode_nagash_sandbox.persistent.nagash_family_member_cqi = nagash_faction_interface:faction_leader():family_member():command_queue_index()
				-- we save up the original region so we can ressurect Nagash there later
				episode_nagash_sandbox.persistent.nagash_original_region_key = home_region_interface:name()

				cm:kill_faction(episode_nagash_sandbox.nagash_faction_key)
			end
		end
	end
)