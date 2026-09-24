episode_nagash_narrative = {
	episode_name = "episode_nagash_narrative",
	episode_set = "nagash_narrative",
	episode_active_shared_state = "episode_nagash_narrative_active",
	episode_disabled = false,

	stage_2_ancillary_key = "wh3_dlc29_anc_arcane_item_alakanash_the_staff_of_power",
	stage_2_override_text_key = "wh3_dlc29_mission_narrative_sm_nagash_obtain_ancillary",

	nagash_narrative_incidents = {
		["wh3_dlc29_nag_narrative_act_1"] = true,
		["wh3_dlc29_nag_narrative_act_2"] = true,
		["wh3_dlc29_nag_narrative_act_3"] = true,
		["wh3_dlc29_nag_narrative_act_4"] = true
	},

	nagashizzar_key = "wh3_main_combi_region_nagashizzar",
	nagashizar_2_check = {
		"wh3_dlc29_special_settlement_nagashizzar_nag_2",
		"wh3_dlc29_special_settlement_nagashizzar_nag_3",
		"wh3_dlc29_special_settlement_nagashizzar_nag_4",
		"wh3_dlc29_special_settlement_nagashizzar_nag_5"
	},
	nagashizar_5_check = {
		"wh3_dlc29_special_settlement_nagashizzar_nag_5"
	},

	prerequisites =
	{
		min_turn = 1
	},

	persistent = {
		current_stage = 1,
		completed_mission_count = {
			[1] = 0,
			[2] = 0,
			[3] = 0,
			[4] = 0
		},
		stages_persistent_data =
		{
			-- stage_persistent_data_table,
		},
	},

	faction_key = "wh3_dlc29_nag_host_of_nagash",
	incident_keys = {
		[1] = "wh3_dlc29_nag_narrative_act_1",
		[2] = "wh3_dlc29_nag_narrative_act_2",
		[3] = "wh3_dlc29_nag_narrative_act_3",
		[4] = "wh3_dlc29_nag_narrative_act_4",
	},
	mission_keys = {
		-- The missions in this table (ignoring the optional ones) dictate the act completion criteria.
		-- Once all missions are complete, the stage progresses.
		[1] = {
			"wh3_dlc29_nagash_narrative_1_1",
			"wh3_dlc29_nagash_narrative_1_2",
		},
		[2] = {
			"wh3_dlc29_nagash_narrative_2_1",
			"wh3_dlc29_nagash_narrative_2_2",
			"wh3_dlc29_nagash_narrative_2_3",
			"wh3_dlc29_nagash_narrative_2_4",
		},
		[3] = {
			"wh3_dlc29_nagash_narrative_3_1",
			"wh3_dlc29_nagash_narrative_3_2",
		},
		[4] = {
			"wh3_dlc29_nagash_narrative_final_battle",
		},
		optional = {
			-- these missions are launched in act 3 and persist into act 4.
			"wh3_dlc29_nagash_narrative_optional_1",
			"wh3_dlc29_nagash_narrative_optional_2",
			"wh3_dlc29_nagash_narrative_optional_3"
		}
	},
}

episode_nagash_narrative.stages =
{
	{
		stage_key = "episode_nagash_narrative_1",
		stage_budget = 100000, -- this is used up

		payloads =
		{
			{
				payload_type = "incident",
				faction_key = episode_nagash_narrative.faction_key,
				incident_key = episode_nagash_narrative.incident_keys[1],
			},
			{
				payload_type = "mission",
				faction_key = episode_nagash_narrative.faction_key,
				mission_key = episode_nagash_narrative.mission_keys[1][1],
			},
			{
				payload_type = "mission",
				faction_key = episode_nagash_narrative.faction_key,
				mission_key = episode_nagash_narrative.mission_keys[1][2],
			}
		},

		on_started = function(self)	
			local faction = cm:get_faction(episode_nagash_narrative.faction_key)

			cm:set_script_state(faction, "vlad_mortarch", false)
			cm:set_script_state(faction, "luthor_mortarch", false)
			cm:set_script_state(faction, "neferata_mortarch", false)
		end,

		on_mission_succeeded = function(self, mission_key)
			episode_nagash_narrative:mission_succeeded_check(episode_nagash_narrative.mission_keys[1], mission_key)
		end
	},
	{
		stage_key = "episode_nagash_narrative_2",
		stage_budget = 100000, -- this is used up

		payloads =
		{
			{
				payload_type = "incident",
				faction_key = episode_nagash_narrative.faction_key,
				incident_key = episode_nagash_narrative.incident_keys[2],
			},
			{
				payload_type = "mission",
				faction_key = episode_nagash_narrative.faction_key,
				mission_key = episode_nagash_narrative.mission_keys[2][1],
			},
			{
				payload_type = "mission",
				faction_key = episode_nagash_narrative.faction_key,
				mission_key = episode_nagash_narrative.mission_keys[2][3],
			},
			{
				payload_type = "mission",
				faction_key = episode_nagash_narrative.faction_key,
				mission_key = episode_nagash_narrative.mission_keys[2][4],
			},
		},

		on_started = function(self) 
			episode_nagash_narrative:trigger_mission_2_2()	
		end,
		on_mission_succeeded = function(self, mission_key)
			episode_nagash_narrative:mission_succeeded_check(episode_nagash_narrative.mission_keys[2], mission_key)
		end
	},
	{
		stage_key = "episode_nagash_narrative_3",
		stage_budget = 100000, -- this is used up

		payloads =
		{
			{
				payload_type = "incident",
				faction_key = episode_nagash_narrative.faction_key,
				incident_key = episode_nagash_narrative.incident_keys[3],
			},
			{
				payload_type = "mission",
				faction_key = episode_nagash_narrative.faction_key,
				mission_key = episode_nagash_narrative.mission_keys[3][1],
			},
			{
				payload_type = "mission",
				faction_key = episode_nagash_narrative.faction_key,
				mission_key = episode_nagash_narrative.mission_keys[3][2],
			},
			{
				payload_type = "mission",
				faction_key = episode_nagash_narrative.faction_key,
				mission_key = episode_nagash_narrative.mission_keys.optional[1],
			},
			{
				payload_type = "mission",
				faction_key = episode_nagash_narrative.faction_key,
				mission_key = episode_nagash_narrative.mission_keys.optional[2],
			},
			{
				payload_type = "mission",
				faction_key = episode_nagash_narrative.faction_key,
				mission_key = episode_nagash_narrative.mission_keys.optional[3],
			},
		},

		on_started = function(self) end,
		on_mission_succeeded = function(self, mission_key)
			episode_nagash_narrative:mission_succeeded_check(episode_nagash_narrative.mission_keys[3], mission_key)
		end
	},
	{
		stage_key = "episode_nagash_narrative_4",
		stage_budget = 100000, -- this is used up

		payloads =
		{
			{
				payload_type = "incident",
				faction_key = episode_nagash_narrative.faction_key,
				incident_key = episode_nagash_narrative.incident_keys[4],
			},
			{
				payload_type = "mission",
				faction_key = episode_nagash_narrative.faction_key,
				mission_key = episode_nagash_narrative.mission_keys[4][1],
			},
		},

		on_started = function(self) end,
		on_mission_succeeded = function(self, mission_key)
			episode_nagash_narrative:mission_succeeded_check(episode_nagash_narrative.mission_keys[4], mission_key)
		end
	},
}

-------------------
-- REQUIRED -------
-------------------

episode_nagash_narrative.is_available_this_game = function(self)
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

episode_nagash_narrative.can_start = function(self)
	return episode_nagash_narrative.persistent.post_how_they_play == true
end

episode_nagash_narrative.start_episode = function(self)
	episodes_manager:start_stage(self, 1)
end

episode_nagash_narrative.execute_stage_payloads = function(self, stage_index)
	local stage_table = episode_nagash_narrative.stages[stage_index]

	if not stage_table then
		return
	end

	for i = 1, #stage_table.payloads do
		local payload = stage_table.payloads[i]
		local params_table = {}

		payloads_executor.execute_payload(payload, params_table)
	end
end

-------------------
-- SELF REGISTER --
-------------------

cm:add_first_tick_callback(
	function()
		-- this check can't be called before add_first_tick_callback, as it needs the world ready and initialized
		if not episode_nagash_narrative:is_available_this_game() then
			return
		end

		episodes_manager:add_available_episode(episode_nagash_narrative)
	end
)

---------------
-- LISTENERS --
---------------

narrative_events.callback(
	"nagash_begin_narrative",
	episode_nagash_narrative.faction_key,
	function()
		if episode_nagash_narrative:is_available_this_game() then
			episode_nagash_narrative.persistent.post_how_they_play = true
			episodes_manager:start_episode(episode_nagash_narrative)
		end
	end,
	"StartPostHowTheyPlay"
)

core:add_listener(
	"nagash_narrative_get_ancillary_faction",
	"FactionGainedAncillary",
	function(context)
		return context:faction():name() == episode_nagash_narrative.faction_key and context:faction():is_human() and context:ancillary() == episode_nagash_narrative.stage_2_ancillary_key
	end,
	function(context)
		if cm:mission_is_active_for_faction(context:faction(), episode_nagash_narrative.mission_keys[2][2]) then
			cm:complete_scripted_mission_objective(
				episode_nagash_narrative.faction_key ,
				episode_nagash_narrative.mission_keys[2][2],
				episode_nagash_narrative.mission_keys[2][2],
				true
			)
		end
	end,
	true
)

core:add_listener(
	"nagash_narrative_get_ancillary_character",
	"CharacterAncillaryGained",
	function(context)
		return context:character():faction():name() == episode_nagash_narrative.faction_key and context:character():faction():is_human() and context:ancillary() == episode_nagash_narrative.stage_2_ancillary_key 
	end,
	function(context)
		if cm:mission_is_active_for_faction(context:character():faction(), episode_nagash_narrative.mission_keys[2][2]) then
			cm:complete_scripted_mission_objective(
				episode_nagash_narrative.faction_key ,
				episode_nagash_narrative.mission_keys[2][2],
				episode_nagash_narrative.mission_keys[2][2],
				true
			)
		end
	end,
	true
)

core:add_listener(
	"nagash_narrative_get_ancillary_auto_complete_check",
	"MissionIssued",
	function(context)
		return context:faction():name() == episode_nagash_narrative.faction_key and context:mission():mission_record_key() == episode_nagash_narrative.mission_keys[2][2]
	end,
	function(context)
		if context:faction():ancillary_exists(episode_nagash_narrative.stage_2_ancillary_key) then
			cm:callback(
				function()
					cm:complete_scripted_mission_objective(
						episode_nagash_narrative.faction_key ,
						episode_nagash_narrative.mission_keys[2][2],
						episode_nagash_narrative.mission_keys[2][2],
						true
					) 
				end, 
			0.5)
		end
	end,
	true
)

core:add_listener(
	"nagash_narrative_mannfred_auto_complete_check",
	"MissionIssued",
	function(context)
		return context:faction():name() == episode_nagash_narrative.faction_key and context:mission():mission_record_key() == episode_nagash_narrative.mission_keys[2][3]
	end,
	function(context)
		local faction = context:faction()

		if faction:rituals():ritual_status("wh3_dlc29_nag_mortarchs_mannfred"):on_cooldown() then
			cm:callback(
				function()
					cm:set_active_mission_status_for_faction(faction, episode_nagash_narrative.mission_keys[2][3], "SUCCEEDED")
				end, 
			0.5)
		end
	end,
	true
)

core:add_listener(
	"nagash_narrative_krell_auto_complete_check",
	"MissionIssued",
	function(context)
		return context:faction():name() == episode_nagash_narrative.faction_key and context:mission():mission_record_key() == episode_nagash_narrative.mission_keys[2][4]
	end,
	function(context)
		local faction = context:faction()
		
		if faction:rituals():ritual_status("wh3_dlc29_nag_mortarchs_krell"):on_cooldown() then
			cm:callback(
				function()
					cm:set_active_mission_status_for_faction(faction, episode_nagash_narrative.mission_keys[2][4], "SUCCEEDED")
				end, 
			0.5)
		end
	end,
	true
)

core:add_listener(
	"nagash_narrative_vlad_auto_complete_check",
	"MissionIssued",
	function(context)
		return context:faction():name() == episode_nagash_narrative.faction_key and context:mission():mission_record_key() == episode_nagash_narrative.mission_keys.optional[1]
	end,
	function(context)
		local faction = context:faction()
		
		if faction:rituals():ritual_status("wh3_dlc29_nag_mortarchs_vlad"):on_cooldown() then
			cm:callback(
				function()
					cm:set_active_mission_status_for_faction(faction, episode_nagash_narrative.mission_keys.optional[1], "SUCCEEDED")
				end, 
			0.5)
		end
	end,
	true
)

core:add_listener(
	"nagash_narrative_luthor_auto_complete_check",
	"MissionIssued",
	function(context)
		return context:faction():name() == episode_nagash_narrative.faction_key and context:mission():mission_record_key() == episode_nagash_narrative.mission_keys.optional[2]
	end,
	function(context)
		local faction = context:faction()
		
		if faction:rituals():ritual_status("wh3_dlc29_nag_mortarchs_luthor"):on_cooldown() then
			cm:callback(
				function()
					cm:set_active_mission_status_for_faction(faction, episode_nagash_narrative.mission_keys.optional[2], "SUCCEEDED")
				end, 
			0.5)
		end
	end,
	true
)

core:add_listener(
	"nagash_narrative_neferata_auto_complete_check",
	"MissionIssued",
	function(context)
		return context:faction():name() == episode_nagash_narrative.faction_key and context:mission():mission_record_key() == episode_nagash_narrative.mission_keys.optional[3]
	end,
	function(context)
		local faction = context:faction()
		
		if faction:rituals():ritual_status("wh3_dlc29_nag_mortarchs_neferata"):on_cooldown() then
			cm:callback(
				function()
					cm:set_active_mission_status_for_faction(faction, episode_nagash_narrative.mission_keys.optional[3], "SUCCEEDED")
				end, 
			0.5)
		end
	end,
	true
)

core:add_listener(
	"nagash_narrative_nagashizzar_1_auto_complete_check",
	"MissionIssued",
	function(context)
		return context:faction():name() == episode_nagash_narrative.faction_key and context:mission():mission_record_key() == episode_nagash_narrative.mission_keys[2][1]
	end,
	function(context)
		local faction = context:faction()
		local nagashizzar = cm:get_region("wh3_main_combi_region_nagashizzar")
		local objective_passed = false

		for _, key in dpairs(episode_nagash_narrative.nagashizar_2_check) do
			if nagashizzar:building_exists(key) then
				objective_passed = true
			end
		end

		if nagashizzar:owning_faction():name() == episode_nagash_narrative.faction_key and objective_passed then
			cm:callback(
				function()
					cm:set_active_mission_status_for_faction(faction, episode_nagash_narrative.mission_keys[2][1], "SUCCEEDED")
				end, 
			0.5)
		end
	end,
	true
)

core:add_listener(
	"nagash_narrative_nagashizzar_2_auto_complete_check",
	"MissionIssued",
	function(context)
		return context:faction():name() == episode_nagash_narrative.faction_key and context:mission():mission_record_key() == episode_nagash_narrative.mission_keys[3][1]
	end,
	function(context)
		local faction = context:faction()
		local nagashizzar = cm:get_region("wh3_main_combi_region_nagashizzar")

		local objective_passed = false

		for _, key in dpairs(episode_nagash_narrative.nagashizar_5_check) do
			if nagashizzar:building_exists(key) then
				objective_passed = true
			end
		end

		if nagashizzar:owning_faction():name() == episode_nagash_narrative.faction_key and objective_passed then
			cm:callback(
				function()
					cm:set_active_mission_status_for_faction(faction, episode_nagash_narrative.mission_keys[3][1], "SUCCEEDED")
				end, 
			0.5)
		end
	end,
	true
)

core:add_listener(
	"nagash_narrative_sigil_auto_complete_check",
	"MissionIssued",
	function(context)
		return context:faction():name() == episode_nagash_narrative.faction_key and context:mission():mission_record_key() == episode_nagash_narrative.mission_keys[3][2]
	end,
	function(context)
		local faction = context:faction()
		-- We -1 because the start node counts as an active node
		local sigil_count = faction:lookup_faction_initiative_set_by_key("wh3_dlc29_pyramid_initiative_set"):active_initiatives():num_items() - 1

		if sigil_count >= 150 then
			cm:callback(
				function()
					cm:set_active_mission_status_for_faction(faction, episode_nagash_narrative.mission_keys[3][2], "SUCCEEDED")
				end, 
			0.5)
		end
	end,
	true
)

core:add_listener(
	"episode_nagash_endgame_Battle_Modifiers",
	"PendingBattle",
	function(context)
		local pb = cm:model():pending_battle()

		return pb:quest_mission_key() == episode_nagash_narrative.mission_keys[4][1]
	end,
	function(context)
		local state_manager = cm:model():shared_states_manager()
		local faction = cm:get_faction(episode_nagash_narrative.faction_key)

		if state_manager:get_state_as_bool_value(faction, "vlad_mortarch") then
			core:svr_save_bool("vlad_mortarch", true)
		else
			core:svr_save_bool("vlad_mortarch", false)
		end

		if state_manager:get_state_as_bool_value(faction, "luthor_mortarch") then
			core:svr_save_bool("luthor_mortarch", true)
		else
			core:svr_save_bool("luthor_mortarch", false)
		end

		if state_manager:get_state_as_bool_value(faction, "neferata_mortarch") then
			core:svr_save_bool("neferata_mortarch", true)
		else
			core:svr_save_bool("neferata_mortarch", false)
		end
	end,
	true
)

core:add_listener(
	"nagash_narrative_final_battle_variables",
	"MissionSucceeded",
	function(context)
		return context:faction():name() == episode_nagash_narrative.faction_key
	end,
	function(context)
		local faction = context:faction()
		local vlad = episode_nagash_narrative.mission_keys.optional[1]
		local luthor = episode_nagash_narrative.mission_keys.optional[2]
		local neferata = episode_nagash_narrative.mission_keys.optional[3]
		local mission = context:mission():mission_record_key()

		if mission == vlad then
			cm:set_script_state(faction, "vlad_mortarch", true)
		elseif mission == luthor then
			cm:set_script_state(faction, "luthor_mortarch", true)
		elseif mission == neferata then
			cm:set_script_state(faction, "neferata_mortarch", true)
		end
	end,
	true
)

core:add_listener(
	"Nagash_Nagashizzar_Tier_Check",
	"RegionFactionChangeEvent",
	function(context)
		local region = context:region()
		local region_name = region:name()
		local new_owner_name = region:owning_faction():name()

		return region:owning_faction():is_human() and new_owner_name == episode_nagash_narrative.faction_key and region_name == episode_nagash_narrative.nagashizzar_key
	end,
	function(context)
		local region = context:region()
		local faction = region:owning_faction()
		
		if not faction:is_human() then
			-- AI factions don't have missions, so we don't need to check for them
			return
		end

		local missions = faction:active_missions()

		for _, active_mission in model_pairs(missions) do
			local active_mission_key = active_mission:mission_record_key()

			if active_mission_key == episode_nagash_narrative.mission_keys[2][1] then
				for _, key in dpairs(episode_nagash_narrative.nagashizar_2_check) do
					-- delay is required for the building to exist after the faction change
					cm:callback(
						function()
							if region:building_exists(key) then
								cm:set_active_mission_status_for_faction(faction, episode_nagash_narrative.mission_keys[2][1], "SUCCEEDED")
								return
							end
						end, 
					1)
				end
			elseif active_mission_key == episode_nagash_narrative.mission_keys[3][1] then
				for _, key in dpairs(episode_nagash_narrative.nagashizar_5_check) do
					-- delay is required for the building to exist after the faction change
					cm:callback(
						function()
							if region:building_exists(key) then
								cm:set_active_mission_status_for_faction(faction, episode_nagash_narrative.mission_keys[3][1], "SUCCEEDED")
								return
							end
						end, 
					1)
				end
			end
		end
	end,
	true
)

------------------
--- FUNCTIONS ----
------------------

function episode_nagash_narrative:mission_succeeded_check(mission_table, mission_key)
	if table.find(mission_table, mission_key) then
		-- stages that need multiple missions completed need to mark both so they can check both
		episodes_manager.mark_mission_completed(episode_nagash_narrative, mission_key)

		local all_missions_completed = true
		for i, curr_mission in ipairs(mission_table) do
			if not episodes_manager.is_mission_completed(episode_nagash_narrative, curr_mission) then
				all_missions_completed = false
				break
			end
		end
		if all_missions_completed then 
			episodes_manager:advance_stage(episode_nagash_narrative)
		end
	elseif table.find(episode_nagash_narrative.mission_keys.optional, mission_key) then
		episodes_manager.mark_mission_completed(episode_nagash_narrative, mission_key)
	end
end

function episode_nagash_narrative:trigger_mission_2_2()
	local mm = mission_manager:new(episode_nagash_narrative.faction_key, episode_nagash_narrative.mission_keys[2][2])	

	mm:set_mission_issuer("CLAN_ELDERS")
	mm:add_new_objective("SCRIPTED")
	mm:add_condition("script_key " .. episode_nagash_narrative.mission_keys[2][2])
	mm:add_condition("override_text mission_text_text_" .. episode_nagash_narrative.stage_2_override_text_key)
	mm:add_payload("money 1525")
	mm:trigger()
end