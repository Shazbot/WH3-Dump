package.path = package.path .. ";data/script/campaign/main_warhammer/endgame/?.lua"

endgame = {

	-- Auto populated by script. The scenarios that are loaded are contained here.
	scenarios = {},

	-- Auto populated by script.  Settings are all defined by the player in the frontend campaign settings. 
	-- New entries for the frontend can be defined in end_game_settings in the db
	settings = {},

	victory_type = "wh_main_long_victory",
	triggered = false,

	-- Used when the endgame triggers to show points of interest that turn. 
	-- Handled by the manager after scenarios finish triggering so we can support multiple scenarios, since each scenarios resets the shroud
	revealed_regions = {},

	-- Used by the ultimate crisis for checking victory and mission triggers
	ultimate_crisis_data = {},

	-- Used by the RAM to save army lists when spawning multiple armies. Purely used for optimising army generation speed.
	random_army_manager = {},

	-- How many turns before the ultimate crisis mission fires. Saved as a global here in case any scenarios trigger later (e.g. vermintide) and need to override it
	ultimate_mission_delay = 1

}

-- Initialise the endgame
cm:add_first_tick_callback(
	function()

		-- Get the user settings from the shared state manager and update the default scripted values
		endgame:update_campaign_settings()

		if endgame.settings.endgame_enabled == false then
			out("Endgame scenarios are disabled - endgame features will NOT be activated in this campaign")
			return
		end

		-- Look for endgame scenario files and load them into the framework
		local endgame_scenario_files = core:get_filepaths_from_folder("/script/campaign/main_warhammer/endgame/", "*.lua")
		out("####################")
		out("Endgame scenarios: Loading the following scenarios from /script/campaign/main_warhammer/endgame/:")
		local scenarios_loaded = {}
		local env = core:get_env()

		for i = 1, #endgame_scenario_files do

			local scenario_filepath = endgame_scenario_files[i]
			local scenario_name = tostring(string.sub(scenario_filepath,40,(string.len(scenario_filepath)-4)))

			-- Make sure the file is loaded correctly, skip its inclusion if not
			local loaded_file, load_error = loadfile(scenario_filepath)
	
			if loaded_file then
				
				-- Set the environment of the Lua chunk to the global environment
				setfenv(loaded_file, env)

				-- Make sure the file is set as loaded
				package.loaded[scenario_filepath] = true

				-- Execute the loaded Lua chunk so the functions within are registered
				local scenario_executed_successfully, execute_error = pcall(loaded_file)
				if not scenario_executed_successfully then
					out("\tFailed to execute loaded scenario file [" .. scenario_name .. "], error is: " .. tostring(execute_error))
				else
					-- Add the scenario to our loaded scenario list, unless it's disabled in the front end
					local scenario_enabled = cm:model():shared_states_manager():get_state_as_bool_value(scenario_name)
					if scenario_enabled == nil or scenario_enabled == true then
						out("\t"..scenario_name.." loaded successfully")
						table.insert(scenarios_loaded, scenario_name)
					end
				end

			else
				-- Scenario was not loaded successfully - print some output
				out("\tFailed to load scenario file [" .. scenario_name .. "], error is: " .. tostring(load_error) .. ". Will attempt to require() this file to generate a more meaningful error message:")

				local require_result, require_error = pcall(require, scenario_filepath)

				if require_result then
					out("\tWARNING: require() seemed to be able to load file [" .. scenario_filepath .. "] with filename [" .. scenario_name .. "], where loadfile failed? Maybe the scenario is loaded, maybe it isn't - proceed with caution!")
				else
					-- strip tab and newline characters from error string
					out("\t\t" .. string.gsub(string.gsub(require_error, "\t", ""), "\n", ""))
				end

			end
		end
		endgame.scenarios = table.copy(scenarios_loaded)
		if #endgame.scenarios > 0 then
			out(#endgame.scenarios.." total scenarios loaded successfully")
			out("####################")
		else
			out("0 scenarios loaded. This shouldn't happen, but might if a player disables all scenarios in the front end. Endgame feature is DISABLED.")
			out("####################")
			return
		end

		-- Endgame scenarios support both a turn timer and a victory condition for triggering
		-- These listeners are removed after the endgame scenario triggers as we only support the endgame firing once
		if endgame.triggered == false then

			core:add_listener(
				"endgame_turn_trigger_listener",
				"WorldStartRound",
				function()
					return endgame.settings.turn_trigger and cm:turn_number() >= cm:random_number(endgame.settings.turn_max, endgame.settings.turn_min) 
				end,
				function()
					if endgame.triggered == false then
						endgame.triggered = true
						endgame:choose_scenario()
						core:remove_listener("endgame_victory_trigger_listener")
						core:remove_listener("endgame_turn_trigger_listener")
					end
				end,
				true
			)

			core:add_listener(
				"endgame_victory_trigger_listener",
				"MissionSucceeded",
				function(context)
					return endgame.settings.victory_trigger and context:mission():mission_record_key() == endgame.victory_type
				end,
				function()
					if endgame.triggered == false then
						endgame.triggered = true
						endgame:choose_scenario()
						core:remove_listener("endgame_turn_trigger_listener")
						core:remove_listener("endgame_victory_trigger_listener")
					end
				end,
				true
			)
			
		end

		if cm:get_saved_value("endgame_scenario_data") then
			endgame:add_early_warning_listener(cm:get_saved_value("endgame_scenario_data"))
		end

		if cm:get_saved_value("endgame_ultimate_crisis_data") then
			endgame:add_ultimate_crisis_victory_listeners()
		end
	
	end
)

-- Update the endgame settings with the player-defined customisation options.
function endgame:update_campaign_settings()

	local ssm = cm:model():shared_states_manager()

	self.settings.endgame_enabled = ssm:get_state_as_bool_value("enable_end_game_settings")

	-- Disable the endgame if the player has turned it off or it's an AI only autorun
	if self.settings.endgame_enabled == false or not cm:has_local_faction() or cm:is_benchmark_mode() then
		return
	end
	
	if self.settings.endgame_enabled == nil then
		-- Endgame settings are missing, so use a generic set of defaults
		-- These only exist to support old/broken save games that are missing data
		self.settings.endgame_enabled = true
		self.settings.turn_trigger = true
		self.settings.turn_min = 100
		self.settings.turn_max = 150
		self.settings.victory_trigger = true
		self.settings.delay = 10
		self.settings.difficulty_mod = 1 -- Make sure this number is /100. E.g. for 200% scaling set this to 2
		self.settings.all_scenarios = false
		self.settings.endgame_diplomacy_enabled = false
	else
		-- Determines whether endgame scenarios will trigger from a player hitting a certain turn (range)
		self.settings.turn_trigger = ssm:get_state_as_bool_value("endgame_turn_trigger")
		self.settings.turn_min = ssm:get_state_as_float_value("endgame_turn_trigger_range_min")
		self.settings.turn_max = ssm:get_state_as_float_value("endgame_turn_trigger_range_max")

		-- Determines whether endgame scenarios will trigger from a player hitting a victory condition or not
		self.settings.victory_trigger = ssm:get_state_as_bool_value("endgame_victory_trigger")
		
		-- Default number of turns between a warning event and the endgame fires, if one exists. Can be overridden by scenario data
		self.settings.delay = ssm:get_state_as_float_value("endgame_early_warning_delay")

		-- Each scenario will choose how to use this scaling difficulty mod independently
		-- Recommended usage: modifying faction potential modifiers or spawned army counts.
		-- This number is 100x higher in the shared state manager as it only supports integers but we want a float
		self.settings.difficulty_mod = (ssm:get_state_as_float_value("endgame_difficulty_mod") or 1) / 100

		-- Tweaker that causes all endgame scenarios to fire at the same time. Why did you do this to yourself?
		self.settings.all_scenarios = ssm:get_state_as_bool_value("endgame_all_scenarios")

		-- When set to true, this allows endgame scenario factions to still do regular diplomacy and make peace
		self.settings.endgame_diplomacy_enabled = ssm:get_state_as_bool_value("endgame_diplomacy_enabled")
	end

end

-- Pre-select a scenario and warn the player(s) about it.
function endgame:choose_scenario()
	if #self.scenarios == 0 then
		out("Tried to generate an endgame, but there's no valid endgames loaded!")
		return
	else
		if self.settings.all_scenarios then
			local no_bundle = false
			for i = 1, #self.scenarios do
				local scenario = self.scenarios[i]
				self:trigger_early_warning(scenario, no_bundle)
				no_bundle = true
			end
			cm:activate_music_trigger("ScriptedEvent_Negative", "wh3_ultimateCrisis")
			if self.settings.delay == 0 then
				self:add_ultimate_crisis_victory_listeners()
			end
		else
			local scenario = self.scenarios[cm:random_number(#self.scenarios)]
			self:trigger_early_warning(scenario)
		end
	end
end

-- Look for an early warning event and delay the scenario if we find one
-- The default delay can be overridden by setting <scenario_name>.delay as a different value in the scenario file
-- e.g. endgame_pyramid_of_nagash.delay = 2 
function endgame:trigger_early_warning(scenario, no_bundle)
	local env = core:get_env()
	local scenario_env = env[scenario]
	-- Only do the early warning event if one actually exists, otherwise fire the scenario immediately
	local delay = scenario_env.delay or self.settings.delay
	if scenario_env.early_warning_event and delay > 0 then		
		if not no_bundle then
			local scenario_data = {
					scenario = scenario, 
					turn = cm:turn_number() + delay
			}
			cm:set_saved_value("endgame_scenario_data", scenario_data)
			self:add_early_warning_listener(scenario_data)
		end
		local human_factions = cm:get_human_factions()
		for i = 1, #human_factions do
			local incident_builder = cm:create_incident_builder(scenario_env.early_warning_event)
			if not no_bundle then
				local payload = cm:create_new_custom_effect_bundle("wh3_main_ie_scripted_endgame_early_warning")
				payload:set_duration(delay)
				local payload_builder = cm:create_payload()
				payload_builder:effect_bundle_to_faction(payload)
				incident_builder:set_payload(payload_builder)
			end
			cm:launch_custom_incident_from_builder(incident_builder, cm:get_faction(human_factions[i]))
		end
	else
		endgame:generate_endgame(scenario)
		self:reveal_regions(self.revealed_regions)
	end
end

function endgame:add_early_warning_listener(scenario_data)
	core:add_listener(
		"endgame_early_warning_listener",
		"WorldStartRound",
		function()
			return cm:turn_number() >= scenario_data.turn
		end,
		function()
			if self.settings.all_scenarios then
				for i = 1, #self.scenarios do
					local scenario = self.scenarios[i]
					self:generate_endgame(scenario)
				end
				cm:activate_music_trigger("ScriptedEvent_Negative", "wh3_ultimateCrisis")
				self:add_ultimate_crisis_victory_listeners()
			else
				self:generate_endgame(scenario_data.scenario)
			end
			cm:set_saved_value("endgame_scenario_data", false)
			core:remove_listener("endgame_early_warning_listener")
			self:reveal_regions(self.revealed_regions)
		end,
		true
	)
end

-- The mission is setup as a listener like this to ensure the events appear in the right order. 
-- We want the player to see the narrative event before they get the mission telling them how to win
function endgame:add_victory_condition_listener(faction_key, incident_key, objectives)
	core:add_listener(
		"endgame_victory_condition_mission_listener_"..faction_key,
		"IncidentOccuredEvent",
		function(context)
			return context:dilemma() == incident_key and context:faction():name() == faction_key
		end,
		function()
			if not self.settings.all_scenarios then
				endgame:create_victory_condition(faction_key, objectives)
			end
			core:remove_listener("endgame_victory_condition_mission_listener"..faction_key)
		end,
		true
	)
end

-- Create new listeners to track the ultimate crisis objective, which is handled entirely by script
-- Since we don't know what scenarios the player will have active, this objective is a generic mission to resolve all current wars
-- The mission triggers the turn after scenarios otherwise it can trigger before the scenarios generate, causing instant victory
function endgame:add_ultimate_crisis_victory_listeners()
	if not cm:get_saved_value("endgame_ultimate_crisis_data") then
		self.ultimate_crisis_data = {
			turn_trigger = cm:turn_number() + self.ultimate_mission_delay,
			pending_mission = true
		}
		cm:set_saved_value("endgame_ultimate_crisis_data", self.ultimate_crisis_data)
	end

	self.ultimate_crisis_data = cm:get_saved_value("endgame_ultimate_crisis_data")
	if self.ultimate_crisis_data.pending_mission then
		core:add_listener(
			"endgame_ultimate_crisis_mission_listener",
			"WorldStartRound",
			function()
				return cm:turn_number() >= self.ultimate_crisis_data.turn_trigger 
			end,
			function()
				local objectives = {
					{
						type = "SCRIPTED",
						conditions = {
							"script_key achieve_ultimate_victory",
							"override_text mission_text_text_endgame_ultimate_crisis_objective_no_wars"
						}
					}
				}
				local human_factions = cm:get_human_factions()
				for i = 1, #human_factions do
					local faction_key = human_factions[i]
					endgame:create_victory_condition(faction_key, objectives)
					self.ultimate_crisis_data[faction_key] = true
				end
				self.ultimate_crisis_data.pending_mission = false
				cm:set_saved_value("endgame_ultimate_crisis_data", self.ultimate_crisis_data)
				core:remove_listener("endgame_ultimate_crisis_mission_listener")
			end,
			true
		)
	end
	core:add_listener(
		"endgame_ultimate_crisis_victory_start_turn_listener",
		"FactionTurnStart",
		function(context)
			local faction = context:faction()
			return not not self.ultimate_crisis_data[faction:name()] and not self:check_at_war(faction)
		end,
		function(context)
			local faction_key = context:faction():name()
			self.ultimate_crisis_data[faction_key] = false
			cm:set_saved_value("endgame_ultimate_crisis_data", self.ultimate_crisis_data)
			cm:complete_scripted_mission_objective(faction_key, "wh_main_ultimate_victory", "achieve_ultimate_victory", true)
		end,
		true
	)
	core:add_listener(
		"endgame_ultimate_crisis_victory_end_turn_listener",
		"FactionTurnEnd",
		function(context)
			local faction = context:faction()
			return not not self.ultimate_crisis_data[faction:name()] and not self:check_at_war(faction)
		end,
		function(context)
			local faction_key = context:faction():name()
			self.ultimate_crisis_data[faction_key] = false
			cm:set_saved_value("endgame_ultimate_crisis_data", self.ultimate_crisis_data)
			cm:complete_scripted_mission_objective(faction_key, "wh_main_ultimate_victory", "achieve_ultimate_victory", true)
		end,
		true
	)
end

-- Returns if a faction is at war or not. Handled this way as rebels are technically at war with the player, and we don't want them to count
function endgame:check_at_war(faction)
	if not faction:at_war() then
		return false
	else
		local faction_war_list = faction:factions_at_war_with()
		for i = 0, faction_war_list:num_items() - 1 do
			local war_faction = faction_war_list:item_at(i)
			if war_faction:is_null_interface() == false and not war_faction:is_dead() and war_faction:name() ~= "rebels" then
				out("We are at war with: "..war_faction:name())
				return true
			end
		end
		return false
	end
end

-- This fires after the delay expires, so this is the moment the scenario actually occurs
function endgame:generate_endgame(chosen_scenario)
	out("")
	out("****************************")
	out("Executing endgame scenario: "..chosen_scenario)

	local env = core:get_env()

	-- Only proceed if filename:trigger() is registered as a function in the chosen scenario's script
	if is_function(env[chosen_scenario]:trigger()) then

		-- call the function
		local ok, result = pcall(env[chosen_scenario]:trigger(), unpack(arg))

		if ok then
			out(chosen_scenario .. ":trigger() executed successfully")
		else
			out("ERROR: " .. chosen_scenario .. ":trigger() failed while executing with error: " .. result)
		end

	else
		out(chosen_scenario .. ":trigger() not found")
	end

	out("****************************")
	out("")
end

-- The endgame creates a new, 'ultimate' victory condition that concludes the intended campaign sandbox narrative
-- The objectives for the Ultimate Victory are determined by the individual scenario scripts
function endgame:create_victory_condition(faction_key, objectives)
	local mm = mission_manager:new(faction_key, "wh_main_ultimate_victory")
	victory_objectives_ie:add_objectives(mm, objectives, faction_key)
	-- In multiplayer with multiple teams we need to ensure objectives for teams are mutually exclusive, so generate objectives to attack the opposing team(s)
	-- Each team also needs to control their own objectives, otherwise they can both win at the same time with a base swap
	if cm:is_multiplayer() then
		local human_factions = cm:get_human_factions()
		local mp_objectives = {}
		local region_objectives = {}
		local faction_objectives = {}
		for i = 1, #human_factions do
			local human_faction_key = human_factions[i]
			local human_faction = cm:get_faction(human_faction_key)
			if human_faction:has_home_region() then
				table.insert(region_objectives, human_faction:home_region():name())
			elseif human_faction_key ~= faction_key and not human_faction:is_team_mate(cm:get_faction(faction_key)) then
				table.insert(faction_objectives, human_faction_key)
			end
		end
		if #region_objectives > 0 then
			local mp_region_objective = {
				type = "CONTROL_N_REGIONS_FROM",
				conditions = {
					"total "..#region_objectives,
					"override_text mission_text_text_mis_activity_control_n_regions_satrapy_including_at_least_n"
				}
			}
			for i = 1, #region_objectives do 
				table.insert(mp_region_objective.conditions, "region "..region_objectives[i])
			end
			table.insert(mp_objectives, mp_region_objective)
		end
		if #faction_objectives > 0 then
			local mp_faction_objective = {
				type = "DESTROY_FACTION",
				conditions = {
					"confederation_valid",
					"vassalization_valid"
				}
			}
			for i = 1, #faction_objectives do 
				table.insert(mp_faction_objective.conditions, "faction "..faction_objectives[i])
			end
			table.insert(mp_objectives, mp_faction_objective)
		end
		if #mp_objectives > 0 then
			victory_objectives_ie:add_objectives(mm, mp_objectives, faction_key)
		end
	end
	mm:add_payload("text_display dummy_wh3_main_survival_forge_of_souls")
	mm:add_payload("game_victory")
	mm:set_victory_type("wh3_combi_victory_type_ultimate")
	mm:set_victory_mission(true)
	mm:set_show_mission(true)
	mm:trigger()
end

-- Spawned scenario forces are always given free upkeep so the AI doesn't immediately disband them
-- Army template is a table containing all desired templates, e.g. {chaos = true, empire = true}
-- declare_war if set to true will declare war on the region owner if it's owned by someone else
function endgame:create_scenario_force(faction_key, region_key, army_template, unit_list, declare_war, total_armies)

	-- total_armies shouldn't be nil, but if it is assume we want a single army
	if total_armies == nil or total_armies < 1 then
		total_armies = 1
	end

	total_armies = math.floor(total_armies)

	for i = 1, total_armies do
		local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, region_key, false, true, 10)
		if pos_x > 0 and pos_y > 0 then
			
			local generated_unit_list = self:generate_random_army(army_template, unit_list)

			cm:create_force(
				faction_key,
				generated_unit_list,
				region_key,
				pos_x,
				pos_y,
				false,
				function(cqi)
					local character = cm:char_lookup_str(cqi)
					if cm:get_faction(faction_key):subculture() ~= "wh2_dlc09_sc_tmb_tomb_kings" then
						cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force_endgame", cqi, 0)
					end
					cm:apply_effect_bundle_to_characters_force("wh3_main_ie_scripted_endgame_force_immune_to_regionless_attrition", cqi, 5)
					cm:add_agent_experience(character, cm:random_number(25, 15), true)
					cm:add_experience_to_units_commanded_by_character(character, cm:random_number(7, 3))
				end
			)
		end
	end

	if declare_war then
		local region_owning_faction = cm:get_region(region_key):owning_faction()
		if region_owning_faction:is_null_interface() == false then
			endgame:declare_war(faction_key, region_owning_faction:name())
		end
	end

end

function endgame:declare_war(attacker_key, defender_key)
	if defender_key == "rebels" then
		return
	end
	local defender_faction = cm:get_faction(defender_key)
	if defender_faction:is_null_interface() == false then
		if defender_faction:is_vassal() then
			defender_faction = defender_faction:master()
			defender_key = defender_faction:name()
		end
		if attacker_key ~= defender_key and cm:get_faction(attacker_key):at_war_with(defender_faction) == false then
			out("ENDGAME: Declaring war between "..attacker_key.." and "..defender_key)
			cm:force_declare_war(attacker_key, defender_key, false, false)
		end
	end
end

-- This function disables peace treaties and confederation with the faction and everyone else.
-- They also declar war on all the human factions
-- We generally always want to do this with endgame scenario factions, but it's defined separately here so it's optional (especially for modding)
function endgame:no_peace_no_confederation_only_war(hostile_faction_key)
		local human_factions = cm:get_human_factions()
		for i = 1, #human_factions do
			endgame:declare_war(hostile_faction_key, cm:get_faction(human_factions[i]):name())
		end
	if self.settings.endgame_diplomacy_enabled == false then
		cm:force_diplomacy("faction:" .. hostile_faction_key, "all", "form confederation", false, false, true)
		cm:force_diplomacy("faction:" .. hostile_faction_key, "all", "peace", false, false, true)
	end
end

-- opt: subculture_to_exclude - Prevent this function from declaring war on a specific subculture, so (for example) we don't turn Athel Loren into a Wood Elf graveyard
function endgame:declare_war_on_adjacent_region_owners(faction, region, subculture_to_exclude)
	if region:is_null_interface() == false then
		local adjacent_regions = region:adjacent_region_list()
				
		for i = 0, adjacent_regions:num_items() - 1 do
			local region = adjacent_regions:item_at(i)
			if region:is_abandoned() == false then
				local adjacent_region_owner = region:owning_faction()
				if subculture_to_exclude == nil then 
					subculture_to_exclude = ""
				end
				if adjacent_region_owner:is_null_interface() == false and adjacent_region_owner:subculture() ~= subculture_to_exclude then
					endgame:declare_war(faction:name(), adjacent_region_owner:name())
				end
			end
		end
	end
end

function endgame:reveal_regions(region_list)
	local human_factions = cm:get_human_factions()
	for i = 1, #human_factions do
		for i2 = 1, #region_list do 
			cm:make_region_visible_in_shroud(human_factions[i], region_list[i2]);
		end 
	end
end

-- A lot of endgame functionality needs AI factions that haven't be confederated
-- can_be_dead is an optional setting, since some behaviour revives the factions (e.g. spawning armies for non-confederated factions)
function endgame:check_faction_is_valid(faction, can_be_dead)
	return faction ~= nil and faction:is_null_interface() == false and faction:is_human() == false and faction:was_confederated() == false and faction:name() ~= "rebels" and (can_be_dead == true or faction:is_dead() == false)
end

-- The random army manager generates new random army lists using unit_lists from scenarios
-- This is setup to only create a new random army if the army_template hasn't been used before
-- Each scenario should use its own army template key in order to not have conflicts
function endgame:generate_random_army(army_template, unit_list)
	local ram = random_army_manager
	local army_string = "endgame_random_army_"..army_template
	if self.random_army_manager[army_string] == nil then
		self.random_army_manager[army_string] = true
		ram:new_force(army_string)
		for key, value in pairs(unit_list) do
			ram:add_unit(army_string, key, value)
		end;
	end

	return ram:generate_force(army_string, 19, false)
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("endgame.triggered", endgame.triggered, context, true)
	end
)
cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			endgame.triggered = cm:load_named_value("endgame.triggered", endgame.triggered, context, true)
		end
	end
)