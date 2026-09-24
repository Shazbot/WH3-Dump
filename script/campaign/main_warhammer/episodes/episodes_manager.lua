episodes_manager =
{
	frontend_shared_state_keys =
	{
		endgame_max_episodes = "endgame_max_scenarios_allowed",
		endgame_turn_range = "endgame_turn_trigger_range",
	},

	-- cached data is stored here for ease of use, but is not saved
	cached_data = 
	{
		-- used for easy access to all episodes by name
		all_episodes_by_name = 
		{
			--[episode_name] == episode_table
		},
		-- filled by add_available_episode()
		-- we test these to see if we should start an episode
		available_episodes = {},

		-- this holds the episodes persistent data between loading the data and them registering on first tick
		episodes_temp_persistent = {},
	},
	-- persistent is saved and loaded
	persistent = 
	{
		-- maps an episode set (a string, e.g. 'end_times') to the active episode
		-- there can be only one episode of a set active at the same time
		-- episodes with no episode set (or 'generic') have no limitation and there is no limit 
		active_episodes = 
		{
			generic = {
				-- active_episode_name, 
				-- ...
			},
			-- end_times = {[active_episode_name]}
		},

		finished_episodes = 
		{
			-- [finished_episode_name] = true,
			-- ..
		},
	},

	-- lower value means more messages get printed
	-- priotity 100 - the print cheat
	-- priority 10 - errors showing something is seriously broken
	-- priority 1 - position character changed (gained or lost their position)
	-- no priority given - everything else, intrigue and relations changes, TODOs, etc.
	min_priority_to_print = 1,

	-- audio
	-- these are the stage types as defined in wwise and used for
	-- the dynamic dialogue event that could be active as conversational
	-- awareness while in a certain stage
	-- stages should use the variables so that if these ever change in
	-- wwise, they can be updated only here
	audio_stage_types =
	{
		foreshadow = "foreshadowing",
		imminent = "imminent",
		main_event = "main_event",
		main_event_01 = "main_event01",
		main_event_02 = "main_event02",
		ended = "ended",
	},

	-- messages only get printed if their priority is at least min_priority_to_print
	-- or if min_priority_to_print is negative
	output = function (self, str, priority)
		if not str then
			return
		end

		if self.min_priority_to_print > 0 then
			if not priority or self.min_priority_to_print > priority then
				return
			end
		end

		print("*** _EPISODES MANAGER_ ***: " .. str)
	end,

	get_episode_table_by_name = function(episode_name)
		return episodes_manager.cached_data.all_episodes_by_name[episode_name]
	end,

	add_available_episode = function(self, episode)
		if not is_string(episode.episode_name) then
			return
		end
		if episodes_manager.cached_data.all_episodes_by_name[episode.episode_name] ~= nil then
			script_error("ERROR: episodes_manager:add_available_episode called for '" .. tostring(episode.episode_name) .. "'  but it was already active!")
			return
		end

		episodes_manager.cached_data.all_episodes_by_name[episode.episode_name] = episode
		table.insert(self.cached_data.available_episodes, episode.episode_name)

		if episodes_manager.cached_data.episodes_temp_persistent[episode.episode_name] ~= nil then
			episode.persistent = episodes_manager.cached_data.episodes_temp_persistent[episode.episode_name]
			if is_function(episode.on_loaded) then
				episode:on_loaded()
			end
			episodes_manager.cached_data.episodes_temp_persistent[episode.episode_name] = nil
		end

		self:on_episode_added_to_available(episode)
	end,

	---------------------------------------
	-- methods related to starting new episodes
	check_start_episodes = function(self)
		local episodes_ready_to_start = {}
		for _index, episode_name in pairs(self.cached_data.available_episodes) do
			local episode = self.get_episode_table_by_name(episode_name)
			local can_start = self:can_start_episode(episode)

			if can_start then
				table.insert(episodes_ready_to_start, episode)
			end
		end

		if #episodes_ready_to_start == 0 then
			return
		end

		local random_index = cm:random_number(#episodes_ready_to_start, 1)
		local random_episode = episodes_ready_to_start[random_index]
		self:start_episode(random_episode)
	end,

	can_start_episode = function(self, episode)
		local game_set_string = self:get_episode_set_string(episode)
		if game_set_string ~= "generic" then
			if self.persistent.active_episodes[episode.episode_set] ~= nil
				and is_table(self.persistent.active_episodes[episode.episode_set])
				and #self.persistent.active_episodes[episode.episode_set] > 0
			then
				return false
			end
		end

		-- end times specific limitations
		if game_set_string == "end_times" then
			if not cm:are_endgame_episodes_allowed() then
				return false
			end

			local max_finished_end_times = self:number_of_allowed_endgames()

			if is_number(max_finished_end_times) == false or max_finished_end_times == 0 then
				return false
			end

			local finished_end_times = 0
			for episode_name, _ in pairs(self.persistent.finished_episodes) do
				local episode_table = self.get_episode_table_by_name(episode_name)
				local episode_sets_table = self:get_episode_set_string(episode_table)
				if episode_sets_table == "end_times" then
					finished_end_times = finished_end_times + 1
				end
			end
			if is_number(max_finished_end_times) and finished_end_times >= max_finished_end_times then
				return false
			end
		end

		if self.persistent.finished_episodes[episode.episode_name] then
			-- episode already finished
			return false
		end

		-- this episode was disabled from the front end
		if not self:is_episode_enabled_from_frontend(episode) then
			return false
		end

		-- this episode was disabled from the script file
		if episode.episode_disabled then
			return false
		end

		-- the episode has some specific conditions and they are preventing it from starting
		if is_function(episode.can_start) then
			local can_start = episode:can_start()
			if can_start == false then
				return false
			end
		end

		local turn_requirements_met = self:are_turn_conditions_met(episode)
		return turn_requirements_met
	end,

	are_turn_conditions_met = function(self, episode_table)
		local required_turn = self:get_episode_start_turn(episode_table)
		if not is_number(required_turn) then
			return false
		end
		local current_turn = cm:turn_number()
		local condition_met = current_turn >= required_turn
		return condition_met
	end,

	start_episode = function(self, episode)
		local episode_set = episode.episode_set
		if episode_set == nil or episode_set == "" then
			episode_set = "generic"
		end
		if self.persistent.active_episodes[episode_set] == nil then
			self.persistent.active_episodes[episode_set] = {}
		end

		table.insert(self.persistent.active_episodes[episode_set], episode.episode_name)

		self:output("starting episode '" .. episode.episode_name .. "'", 1)
		-- some episodes may have custom logic at start
		if is_function(episode.start_episode) then
			episode:start_episode()
			return
		end

		local first_stage = episode.stages[1]
		-- some stages may have custom logic at start
		if is_function(first_stage.start_stage) then
			first_stage:start_stage()
		else
			self:start_stage(episode, 1)
		end
	end,

	end_episode = function(self, episode)
		if is_function(episode.on_episode_end) then
			episode:on_episode_end()
		end
		if self.persistent.finished_episodes == nil then
			self.persistent.finished_episodes = {}
		end
		self.persistent.finished_episodes[episode.episode_name] = true
		episode.persistent.current_stage_index = -1
		local episode_set = episode.episode_set
		if episode_set == nil or episode_set == "" then
			episode_set = "generic"
		end
		if self.persistent.active_episodes[episode_set] == nil then
			-- we should never get here, but just in case
			self.persistent.active_episodes[episode_set] = {}
		end

		-- When an end_times episode ends there is the possiblity another will start depending on frontend settings
		-- We need to reset the valid start turn of all other end times episodes at this point so they can start after a cooldown
		-- As each episode is likely to leave the world in different states we let each episode decide how long the cooldown should be following it
		if episode_set == "end_times" then
			local cooldown = episode.post_episode_cooldown or 10

			for _, episode_name in pairs(self.cached_data.available_episodes) do
				local next_episode = self.get_episode_table_by_name(episode_name)
				
				if next_episode.episode_set == "end_times" then
					local current_turn = cm:turn_number()
					next_episode.persistent.start_turn = current_turn + cooldown
				end
			end
		end

		self:update_audio_awareness(episode, nil)

		for index, episode_name in ipairs(self.persistent.active_episodes[episode_set]) do
			if episode_name == episode.episode_name then
				table.remove(self.persistent.active_episodes[episode_set], index)
				return
			end
		end
		script_error("ERROR: episodes_manager:end_episode called for '".. tostring(episode.episode_name) .. "'  but it was not marked as started!")
	end,

	-- end of methods related to starting new episodes
	---------------------------------------
	-- methods related to progressing through stages of the episodes

	--this MUST be called, either directly or from the stage's dedicated start_stage method
	start_stage = function(self, episode_table, stage_index)
		local active_stage = episode_table.stages[stage_index]

		if is_function(active_stage.start_criteria) then
			local should_start_stage = active_stage:can_start_stage()

			if should_start_stage == false then
				return false
			end
		end

		if not is_table(episode_table.persistent.stages_persistent_data[stage_index]) then
			episode_table.persistent.stages_persistent_data[stage_index] = {}
		end

		local current_turn = cm:turn_number()
		episode_table.persistent.stages_persistent_data[stage_index].turn_started = current_turn

		if is_number(active_stage.duration) then
			episode_table.persistent.stages_persistent_data[stage_index].end_turn = current_turn + active_stage.duration
		elseif is_number(active_stage.max_duration) then
			local min_duration = active_stage.min_duration or 0
			-- for some weird reason, the first param is the MAX, the second is the MIN
			local duration = cm:random_number(active_stage.max_duration, min_duration)
			episode_table.persistent.stages_persistent_data[stage_index].end_turn = current_turn + duration
		end
		episode_table.persistent.current_stage_index = stage_index

		-- some stages may have a special function that needs calling with custom logic
		if is_function(active_stage.on_started) then
			active_stage:on_started()
		end
		if is_function(episode_table.execute_stage_payloads) then
			episode_table:execute_stage_payloads(stage_index)
		else
			for i = 1, #active_stage.payloads do
				local payload = active_stage.payloads[i]
				-- directly executing payloads does not provide parameters
				-- so we give an empty table
				payloads_executor.execute_payload(payload, {})
			end
		end

		if is_table(active_stage.victory_payloads) and is_function(episode_table.get_winning_factions) then
			local winning_factions = episode_table:get_winning_factions()
			if is_table(winning_factions) then
				for i = 1, #active_stage.victory_payloads do
					local payload = active_stage.victory_payloads[i]
					for j = 1, #winning_factions do
						-- victory payloads get the winning faction as parameter
						local params_table = {}
						params_table.target_faction_key = winning_factions[j]
						payloads_executor.execute_payload(payload, params_table)
					end
				end
			end
		end

		-- some stages may have a special function that needs calling with custom logic after the payloads are executed
		if is_function(active_stage.post_payload) then
			active_stage:post_payload()
		end

		self:update_audio_awareness(episode_table, active_stage)

		self:output("starting stage " .. stage_index .. ":'" .. active_stage.stage_key .. "' of episode '" .. episode_table.episode_name .. "'", 1)
	end,

	is_stage_ended = function(self, episode_table, current_stage_index)
		local active_stage = episode_table.stages[current_stage_index]
		if is_function(active_stage.is_ended) then
			local is_ended = active_stage.is_ended()
			return is_ended
		end
		
		local end_turn = episode_table.persistent.stages_persistent_data[current_stage_index].end_turn
		if is_number(end_turn) then
			local current_turn = cm:turn_number()
			return current_turn >= end_turn
		end
		return false
	end,

	advance_stage = function(self, episode_table, current_stage_index)
		if current_stage_index == nil and is_table(episode_table.persistent) then
			current_stage_index = episode_table.persistent.current_stage_index
		end

		if not is_number(current_stage_index) then
			return
		end
		local next_active_stage = current_stage_index + 1
		local active_stage = episode_table.stages[current_stage_index]
		if is_function(active_stage.get_next_stage_index) then
			next_active_stage = active_stage.get_next_stage_index()
		end
		if is_number(next_active_stage)
			and next_active_stage > 0
			and next_active_stage <= #episode_table.stages 
		then
			self:start_stage(episode_table, next_active_stage)
		else
			-- we are over the last stage, remove the episode
			self:end_episode(episode_table)
		end
	end,

	on_episode_added_to_available = function(self, episode)
		local stage = episodes_manager.get_episode_current_stage_table(episode)
		if stage then
			self:update_audio_awareness(episode, stage)
		end
	end,

	---------------------
	-- event handling
	on_round_start = function(self)
		for _episodes_set, episodes_of_set in dpairs(self.persistent.active_episodes) do
			for _, episode_name in ipairs(episodes_of_set) do
				local episode_table = self.get_episode_table_by_name(episode_name)
				if is_table(episode_table) then
					local current_stage_index = episode_table.persistent.current_stage_index
					if self:is_stage_ended(episode_table, current_stage_index) then
						-- the stage ended, go to the next one
						self:advance_stage(episode_table, current_stage_index)
					end
				end
			end
		end

		local current_turn = cm:model():turn_number()
		if current_turn == 1 then
			cm:callback(
				-- Slight delay ensures payloads fire if fired turn 1 after campaign launch
				function() 
					self:check_start_episodes()
				end, 0.5
			)
		else
			self:check_start_episodes()
		end
	end,

	-----------------------
	-- saving/loading
	save_episodes = function(self, context)
		cm:save_named_value("episodes_manager", self.persistent, context)

		for _index, episode_name in pairs(self.cached_data.available_episodes) do
			local episode = self.get_episode_table_by_name(episode_name)
			cm:save_named_value(episode_name, episode.persistent, context)
		end
	end,

	load_episodes = function(self, context)
		self.persistent = cm:load_named_value("episodes_manager", self.persistent, context, true) or self.persistent
		-- save migration
		self.persistent.finished_episodes = self.persistent.finished_episodes or {}

		for _episodes_set, episodes_of_set in dpairs(self.persistent.active_episodes) do
			for _, episode_name in ipairs(episodes_of_set) do
				episodes_manager.cached_data.episodes_temp_persistent[episode_name] = cm:load_named_value(episode_name, {}, context, true) or {}
			end
		end
		self:output("load_episodes complete", 1)
	end,

	-----------------------
	-- utils
	get_episode_stage_index_by_name = function(self, episode_table, stage_name)
		for i = 1, #episode_table.stages do
			local stage_table = episode_table.stages[i]
			if is_string(stage_table.stage_key) and stage_table.stage_key == stage_name then
				return i
			end
		end
		return -1
	end,

	get_episode_set_string = function(self, episode_table)
		if not is_table(episode_table) then
			return nil
		end

		if is_string(episode_table.episode_set) and episode_table.episode_set ~= "" then
			return episode_table.episode_set
		end

		return "generic"
	end,

	get_episode_current_stage_table = function(episode_table)
		if not is_table(episode_table) then
			return nil
		end

		if not is_table(episode_table.persistent) then
			return nil
		end

		if not is_number(episode_table.persistent.current_stage_index) then
			return nil
		end
	
		if episode_table.persistent.current_stage_index < 0 or episode_table.persistent.current_stage_index > #episode_table.stages then
			return nil
		end
	
		return episode_table.stages[episode_table.persistent.current_stage_index]
	end,

	mark_mission_completed = function(episode_table, mission_key)
		if not is_table(episode_table.persistent.completed_missions) then
			episode_table.persistent.completed_missions = {}
		end
	
		episode_table.persistent.completed_missions[mission_key] = true
	end,

	is_mission_completed = function(episode_table, mission_key)
		if not is_table(episode_table.persistent.completed_missions) then
			return false
		end

		return episode_table.persistent.completed_missions[mission_key]
	end,
	
	mark_dilemma_choice = function(episode_table, dilemma_key, dilemma_choice)
		if not is_table(episode_table.persistent.dilemma_choices) then
			episode_table.persistent.dilemma_choices = {}
		end
	
		episode_table.persistent.dilemma_choices[dilemma_key] = dilemma_choice
	end,

	get_dilemma_choice = function(episode_table, dilemma_key)
		if not is_table(episode_table.persistent.dilemma_choices) then
			return -1
		end
	
		return episode_table.persistent.dilemma_choices[dilemma_key]
	end,

	-------------------------------------
	-- frontend shared state utils
	number_of_allowed_endgames = function(self)
		local shared_state_value = cm:model():shared_states_manager():get_state_as_float_value(episodes_manager.frontend_shared_state_keys.endgame_max_episodes)
		return shared_state_value
	end,

	-- episode specific
	is_episode_enabled_from_frontend = function(self, episode_table)
		if not is_table(episode_table) or not is_string(episode_table.episode_name) then
			return nil
		end

		local shared_state_value = nil
		
		if episode_table.episode_frontend_enabled_shared_state_key then
			shared_state_value = cm:model():shared_states_manager():get_state_as_bool_value(episode_table.episode_frontend_enabled_shared_state_key)
		end
			
		if shared_state_value == nil then
			-- if the episode is not disabled by the shared state, it is considered enabled
			return true
		end
		return shared_state_value
	end,

	get_episode_start_turn = function(self, episode_table)
		local game_set_string = self:get_episode_set_string(episode_table)

		-- End times episodes trigger on a turn within the range set by the frontend slider
		-- We generate this random number the first time its needed and then store it
		if game_set_string == "end_times" then
			if episode_table.persistent.start_turn == nil then
				local ssm = cm:model():shared_states_manager()
				local turn_min = ssm:get_state_as_float_value(episodes_manager.frontend_shared_state_keys.endgame_turn_range.."_min")
				local turn_max = ssm:get_state_as_float_value(episodes_manager.frontend_shared_state_keys.endgame_turn_range.."_max")
				local initial_start_turn = cm:random_number(turn_max, turn_min)
				local turn_countdown = initial_start_turn

				-- The frontend setting selects the turn of the main event, so we need to subtract all foreshadowing event lengths to match this
				-- This can be far from perfect if there is a stage before the main event that doesn't have a turn based length but this isn't currently the case for any end_times episodes
				local found_main_event = false
				for i = 1, #episode_table.stages do
					local stage_table = episode_table.stages[i]

					if stage_table.main_event then
						found_main_event = true
						break
					else
						if stage_table.duration then
							turn_countdown = turn_countdown - stage_table.duration
						elseif is_number(stage_table.max_duration) then
							-- This stage has a random duration, but the actual duration is randomized when the stage starts, so this is just an approximation
							local min_duration = stage_table.min_duration or 0
							local duration = math.floor((min_duration + stage_table.max_duration) / 2)
							turn_countdown = turn_countdown - duration
						end
					end
				end
				if found_main_event then
					episode_table.persistent.start_turn = math.max(turn_countdown, 1)
				else
					episode_table.persistent.start_turn = initial_start_turn
				end
			end
			return episode_table.persistent.start_turn
		end

		-- With no specified start turn we fallback to using the prerequisites min_turn
		if is_table(episode_table.prerequisites) and is_number(episode_table.prerequisites.min_turn) then
			return episode_table.prerequisites.min_turn
		else
			-- A prerequisite min_turn is the minimum expectation required of an episode to know its start turn
			-- If an episode doesn't have this we consider it incorrectly configured as we can't know when to trigger it
			script_error("Episodes Manager: No valid start turn for episode - "..episode_table.episode_name)
		end
	end,

	-- audio utils
	update_audio_awareness = function(self, episode_table, current_stage)
		local dynamic_dialogue_event = episode_table.episode_audio_stage_change_dynamic_dialogue_event
		if not dynamic_dialogue_event then
			return
		end

		local audio_stage_type = current_stage and current_stage.audio_stage_type or ""
		cm:set_episode_stage_audio_awareness(dynamic_dialogue_event, audio_stage_type)
	end,
}

cm:add_saving_game_callback(function(context) episodes_manager:save_episodes(context) end)
cm:add_loading_game_callback(function(context) episodes_manager:load_episodes(context) end)


-- episodes_manager_WorldStartRound
-- called at the start of every round
core:add_listener(
	"episodes_manager_WorldStartRound",
	"WorldStartRound",
	true,
	function(context)
		episodes_manager:on_round_start()
	end,
	true
)

core:add_listener(
	"episodes_manager_MissionSucceeded",
	"MissionSucceeded",
	true,
	function(context)
		local misison_key = context:mission():mission_record_key()
		for _episodes_set, episodes_of_set in pairs(episodes_manager.persistent.active_episodes) do
			for _, episode_name in ipairs(episodes_of_set) do
				local episode_table = episodes_manager.get_episode_table_by_name(episode_name)
				if is_table(episode_table) then
					local episode_active_stage = episodes_manager.get_episode_current_stage_table(episode_table)

					if is_table(episode_active_stage) 
						and is_function(episode_active_stage.on_mission_succeeded)
					then
						episode_active_stage:on_mission_succeeded(misison_key)
					end
				end
			end
		end
	end,
	true
)

core:add_listener(
	"episodes_manager_dilemma_DilemmaChoiceMadeEvent",
	"DilemmaChoiceMadeEvent",
	true,
	function(context)
		local dilemma_key = context:dilemma()
		local choice_index = context:choice()

		for _episodes_set, episodes_of_set in pairs(episodes_manager.persistent.active_episodes) do
			for _, episode_name in ipairs(episodes_of_set) do
				local episode_table = episodes_manager.get_episode_table_by_name(episode_name)
				if is_table(episode_table) then
					local episode_active_stage = episodes_manager.get_episode_current_stage_table(episode_table)

					if is_table(episode_active_stage) 
						and is_function(episode_active_stage.on_dilemma_choice)
					then
						episode_active_stage:on_dilemma_choice(dilemma_key, choice_index)
					end
				end
			end
		end
	end,
	true
)

episodes_manager_cheats = 
{
	start_episode = function(episode_name)
		local episode_table = episodes_manager.get_episode_table_by_name(episode_name)
		if not is_table(episode_table) then
			script_error("ERROR: episodes_manager_cheats:start_episode called for '".. tostring(episode_name) .. "'  but no such episode found!")
			return
		end
		episodes_manager:start_episode(episode_table)
	end,

	advance_episode = function(episode_name)
		local episode_table = episodes_manager.get_episode_table_by_name(episode_name)
		if not is_table(episode_table) then
			script_error("ERROR: episodes_manager_cheats:advance_episode called for '".. tostring(episode_name) .. "'  but no such episode found!")
			return
		end
		local current_stage_index = episode_table.persistent.current_stage_index
		episodes_manager:advance_stage(episode_table, current_stage_index)
	end,

	reset_episode = function(episode_name)
		local episode_table = episodes_manager.get_episode_table_by_name(episode_name)
		if not is_table(episode_table) then
			script_error("ERROR: episodes_manager_cheats:reset_episode called for '".. tostring(episode_name) .. "'  but no such episode found!")
			return
		end
		episodes_manager.persistent.finished_episodes[episode_name] = nil
	end,

	populate_cheat_ui = function()
		local ui_root = core:get_ui_root();
		local dev_ui_episodes = find_uicomponent(ui_root, "episodes.twui.xml")

		local all_active_episodes = {}
		local all_active_episodes_by_name = {}
		for _episodes_set, episodes_of_set in pairs(episodes_manager.persistent.active_episodes) do
			for _, episode_name in ipairs(episodes_of_set) do
				local episode_table = episodes_manager.get_episode_table_by_name(episode_name)
				local episode_table_cco = episodes_manager_cheats.get_active_episode_cco(episode_table)
				table.insert(all_active_episodes, episode_table_cco)
				all_active_episodes_by_name[episode_name] = true
			end
		end

		local all_finished_episodes = {}
		for episode_name, is_finished in pairs(episodes_manager.persistent.finished_episodes) do
			if is_finished then
				local episode_table = episodes_manager.get_episode_table_by_name(episode_name)
				local episode_table_cco = episodes_manager_cheats.get_finished_episode_cco(episode_table)
				table.insert(all_finished_episodes, episode_table_cco)
			end
		end

		local all_non_started_episodes = {}
		for _, episode_name in ipairs(episodes_manager.cached_data.available_episodes) do
			if (not episodes_manager.persistent.finished_episodes[episode_name])
				and (not all_active_episodes_by_name[episode_name])
			then
				local episode_table = episodes_manager.get_episode_table_by_name(episode_name)
				local episode_table_cco = episodes_manager_cheats.get_available_episode_cco(episode_table)
				table.insert(all_non_started_episodes, episode_table_cco)
			end
		end

		local available_episodes_cco_name = "CcoAvailableEpisodes"
		common.set_context_value(available_episodes_cco_name, all_non_started_episodes)

		local active_episodes_cco_name = "CcoActiveEpisodes"
		common.set_context_value(active_episodes_cco_name, all_active_episodes)

		local finished_episodes_cco_name = "CcoFinishedEpisodes"
		common.set_context_value(finished_episodes_cco_name, all_finished_episodes)
	end,

	get_active_episode_cco = function(episode_table)
		local episode_cco_table = {}
		episode_cco_table.episode_name = episode_table.episode_name
		local current_stage_index = episode_table.persistent.current_stage_index
		local stage_table = episode_table.stages[current_stage_index]
		episode_cco_table.episode_stage = "Current stage: " .. current_stage_index .. ":'" .. stage_table.stage_key .. "'"

		local stage_persistent_data = episode_table.persistent.stages_persistent_data[current_stage_index]
		if is_table(stage_persistent_data)
			and is_number(stage_persistent_data.end_turn)
		then
			local end_turn = stage_persistent_data.end_turn
			episode_cco_table.episode_stage = episode_cco_table.episode_stage .. "; End turn: " .. tostring(end_turn)
		end
		episode_cco_table.episode_table = episode_table
		episode_cco_table.episode_state = "active"
		return episode_cco_table
	end,

	get_finished_episode_cco = function(episode_table)
		local episode_cco_table = {}
		episode_cco_table.episode_name = episode_table.episode_name
		episode_cco_table.episode_table = episode_table
		episode_cco_table.episode_state = "finished"
		return episode_cco_table
	end,

	get_available_episode_cco = function(episode_table)
		local episode_cco_table = {}
		episode_cco_table.episode_name = episode_table.episode_name
		episode_cco_table.episode_table = episode_table
		episode_cco_table.episode_state = "available"
		return episode_cco_table
	end,

	core:add_listener(
		"episodes_manager_cheats_ContextTriggerEvent",
		"ContextTriggerEvent",
		function(context)
			return context.string:starts_with("episodes_manager_cheats")
		end,
		function(context)
			episodes_manager_cheats.handle_cheat(context.string)
		end,
		true
	);

	handle_cheat = function(context_string)
		local params = context_string:split(":")
		local action_key = params[2]
		local episode_name = params[3]
		if action_key == "start" then
			episodes_manager_cheats.start_episode(episode_name)
			episodes_manager_cheats.populate_cheat_ui()
		elseif action_key == "advance" then
			episodes_manager_cheats.advance_episode(episode_name)
			episodes_manager_cheats.populate_cheat_ui()
		elseif action_key == "reset" then
			episodes_manager_cheats.reset_episode(episode_name)
			episodes_manager_cheats.populate_cheat_ui()
		elseif action_key == "populate" then
			episodes_manager_cheats.populate_cheat_ui()
		else
			episodes_manager:output("unknown cheat command: '" .. tostring(action_key) .. "'", 100)
			return
		end

	end,
}

--- @function get_strongest_faction_from_list
--- @desc Returns <code>faction_key<code> which is the key of the strongest faction found on the campaign from a list of provided faction_keys
--- @p faction_keys is a table of faction keys.
--- @p [opt=false] @boolean include_human_factions
--- @r faction_key of the strongest ranked faction or nil if no valid faction found (false if invalid input)
function episodes_manager:get_strongest_faction_from_list(faction_keys, include_human_factions)
	-- STRONGEST FACTION FROM LIST
	if not is_table(faction_keys) then
		script_error("ERROR: get_strongest_faction_from_list() called but supplied faction_keys  [" .. tostring(faction_keys) .. "] is not a table")
		return false
	end

	local world = cm:model():world()
	local strongest_faction = nil
	local strongest_rank = nil
	
	for _, valid_faction_key in ipairs(faction_keys) do
		if not is_string(valid_faction_key) then
			script_error("ERROR: get_strongest_faction_from_list() called but supplied valid_faction_key [" .. tostring(valid_faction_key) .. "] is not a string")
			return false
		end

		local faction = cm:get_faction(valid_faction_key)

		if faction
			and not faction:is_null_interface()
			and not faction:is_dead()
			and (not faction:is_human() or include_human_factions)
		then
			local rank = world:faction_strength_rank(faction)
			if not strongest_rank or rank < strongest_rank then
				strongest_faction = valid_faction_key
				strongest_rank = rank
			end
		end
	end

	return strongest_faction
end
