package.path = package.path .. ";data/script/campaign/main_warhammer/endgame/?.lua"

endgame = {

	-- Auto populated by script. The scenarios that are loaded are contained here.
	scenarios = {},

	-- Auto populated by script.  Settings are all defined by the player in the frontend campaign settings. 
	-- New entries for the frontend can be defined in end_game_settings in the db
	settings = {},

	victory_type = "wh_main_long_victory",
	triggered = false
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
	
	end
)

-- Update the endgame settings with the player-defined customisation options.
function endgame:update_campaign_settings()

	local ssm = cm:model():shared_states_manager()

	self.settings.endgame_enabled = ssm:get_state_as_bool_value("enable_end_game_settings")

	-- Disable the endgame if the player has turned it off or it's an AI only autorun
	if self.settings.endgame_enabled == false or not cm:get_local_faction(true) then
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
		self.settings.difficulty_mod = 1
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
		self.settings.difficulty_mod = ssm:get_state_as_float_value("endgame_difficulty_mod")/100
	end

end

-- Pre-select a scenario and warn the player(s) about it.
function endgame:choose_scenario()
	if #self.scenarios == 0 then
		out("Tried to generate an endgame, but there's no valid endgames loaded!")
		return
	else
		local scenario = self.scenarios[cm:random_number(#self.scenarios)]
		self:trigger_early_warning(scenario)
	end
end

-- Look for an early warning event and delay the scenario if we find one
-- The default delay can be overridden by setting <scenario_name>.delay as a different value in the scenario file
-- e.g. endgame_pyramid_of_nagash.delay = 2 
function endgame:trigger_early_warning(scenario)
	local env = core:get_env()
	local scenario_env = env[scenario]
	-- Only do the early warning event if one actually exists, otherwise fire the scenario immediately
	if scenario_env.early_warning_event then
		local delay = scenario_env.delay or self.settings.delay
		local scenario_data = {
			scenario = scenario, 
			turn = cm:turn_number() + delay
		}
		cm:set_saved_value("endgame_scenario_data", scenario_data)
		local human_factions = cm:get_human_factions()
		self:add_early_warning_listener(scenario_data)
		for i = 1, #human_factions do
			local incident_builder = cm:create_incident_builder(scenario_env.early_warning_event)
			local payload = cm:create_new_custom_effect_bundle("wh3_main_ie_scripted_endgame_early_warning")
			payload:set_duration(delay)
			local payload_builder = cm:create_payload()
			payload_builder:effect_bundle_to_faction(payload)
			incident_builder:set_payload(payload_builder)
			cm:launch_custom_incident_from_builder(incident_builder, cm:get_faction(human_factions[i]))
		end
	else
		endgame:generate_endgame(scenario)
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
			endgame:generate_endgame(scenario_data.scenario)
			cm:set_saved_value("endgame_scenario_data", false)
			core:remove_listener("endgame_early_warning_listener")
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
			endgame:create_victory_condition(faction_key, objectives)
			core:remove_listener("endgame_victory_condition_mission_listener"..faction_key)
		end,
		true
	)
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
-- Objectives ideally shouldn't target human factions so we can support multiplayer
function endgame:create_victory_condition(faction_key, objectives)
	local mm = mission_manager:new(faction_key, "wh_main_ultimate_victory")
	victory_objectives_ie:add_objectives(mm, objectives, faction_key)
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
function endgame:create_scenario_force(faction_key, region_key, army_template, unit_count, declare_war, total_armies)

	-- total_armies shouldn't be nil, but if it is assume we want a single army
	if total_armies == nil then
		total_armies = 1
	end

	for i = 1, total_armies do
		local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, region_key, false, true, 10)
		local unit_list = self:generate_random_army(army_template, unit_count)

		cm:create_force(
			faction_key,
			unit_list,
			region_key,
			pos_x,
			pos_y,
			false,
			function(cqi)
				local character = cm:char_lookup_str(cqi)
				cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force", cqi, 0)
				cm:apply_effect_bundle_to_characters_force("wh3_main_ie_scripted_endgame_force_immune_to_regionless_attrition", cqi, 5)
				cm:add_agent_experience(character, cm:random_number(25, 15), true)
				cm:add_experience_to_units_commanded_by_character(character, cm:random_number(7, 3))
			end
		)
	end

	if declare_war then
		local region_owning_faction = cm:get_region(region_key):owning_faction()
		if region_owning_faction:is_null_interface() == false then
			endgame:declare_war(faction_key, region_owning_faction:name())
		end
	end

end

function endgame:declare_war(attacker_key, defender_key)
	local defender_faction = cm:get_faction(defender_key)
	if defender_faction:is_null_interface() == false then
		if defender_faction:is_vassal() then
			defender_faction = defender_faction:master()
			defender_key = defender_faction:name()
		end
		if defender_key ~= "rebels" and attacker_key ~= defender_key and cm:get_faction(attacker_key):at_war_with(defender_faction) == false then
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

	cm:force_diplomacy("faction:" .. hostile_faction_key, "all", "form confederation", false, false, true)
	cm:force_diplomacy("faction:" .. hostile_faction_key, "all", "peace", false, false, true)
end

function endgame:declare_war_on_adjacent_region_owners(faction, region)
	local adjacent_regions = region:adjacent_region_list()
			
	for i = 0, adjacent_regions:num_items() - 1 do
		local region = adjacent_regions:item_at(i)
		if region:is_abandoned() == false then
			local adjacent_region_owner = region:owning_faction()
			if adjacent_region_owner:is_null_interface() == false then
				endgame:declare_war(faction:name(), adjacent_region_owner:name())
			end
		end
	end
end

-- Note here that unlike other random_army_managers, army_template is a table rather than a string
-- Army templates for the endgame aren't mutually exclusive, therefore we need to independently check each culture here
-- For example, the endgame army generator fully supports spawning an army containing Wood Elves, Empire, *and* Chaos units.
function endgame:generate_random_army(army_template, unit_count)
	local ram = random_army_manager
	ram:remove_force("endgame_army")
	ram:new_force("endgame_army")

	if army_template.vampires then

		--Infantry
		ram:add_unit("endgame_army", "wh_main_vmp_inf_skeleton_warriors_1", 2)
		ram:add_unit("endgame_army", "wh_main_vmp_inf_crypt_ghouls", 4)
		ram:add_unit("endgame_army", "wh_main_vmp_inf_cairn_wraiths", 4)
		ram:add_unit("endgame_army", "wh_main_vmp_inf_grave_guard_0", 8)
		ram:add_unit("endgame_army", "wh_main_vmp_inf_grave_guard_1", 8)

		--Cavalry
		ram:add_unit("endgame_army", "wh_main_vmp_cav_black_knights_3", 2)
		ram:add_unit("endgame_army", "wh_main_vmp_cav_hexwraiths", 1)
		ram:add_unit("endgame_army", "wh_dlc02_vmp_cav_blood_knights_0", 2)

		--Monsters
		ram:add_unit("endgame_army", "wh_main_vmp_mon_fell_bats", 1)
		ram:add_unit("endgame_army", "wh_main_vmp_mon_dire_wolves", 1)
		ram:add_unit("endgame_army", "wh_main_vmp_mon_crypt_horrors", 4)
		ram:add_unit("endgame_army", "wh_main_vmp_mon_vargheists", 4)
		ram:add_unit("endgame_army", "wh_main_vmp_mon_varghulf", 2)
		ram:add_unit("endgame_army", "wh_main_vmp_mon_terrorgheist", 2)

		--Vehicles
		ram:add_unit("endgame_army", "wh_dlc04_vmp_veh_corpse_cart_1", 1)
		ram:add_unit("endgame_army", "wh_dlc04_vmp_veh_corpse_cart_2", 1)
		ram:add_unit("endgame_army", "wh_main_vmp_veh_black_coach", 1)
		ram:add_unit("endgame_army", "wh_dlc04_vmp_veh_mortis_engine_0", 1)

	end
	
	if army_template.greenskins then
	
		--Infantry
		ram:add_unit("endgame_army", "wh_dlc06_grn_inf_nasty_skulkers_0", 2)
		ram:add_unit("endgame_army", "wh_main_grn_inf_night_goblins", 2)
		ram:add_unit("endgame_army", "wh_main_grn_inf_night_goblin_fanatics", 2)
		ram:add_unit("endgame_army", "wh_main_grn_inf_night_goblin_fanatics_1", 2)
		ram:add_unit("endgame_army", "wh_main_grn_inf_orc_boyz", 2)
		ram:add_unit("endgame_army", "wh_main_grn_inf_orc_big_uns", 8)
		ram:add_unit("endgame_army", "wh_main_grn_inf_savage_orcs", 3)
		ram:add_unit("endgame_army", "wh_main_grn_inf_savage_orc_big_uns", 8)
		ram:add_unit("endgame_army", "wh_main_grn_inf_black_orcs", 8)
		ram:add_unit("endgame_army", "wh_main_grn_inf_night_goblin_archers", 2)
		ram:add_unit("endgame_army", "wh_main_grn_inf_orc_arrer_boyz", 4)
		ram:add_unit("endgame_army", "wh_main_grn_inf_savage_orc_arrer_boyz", 8)
		
		--Cavalry
		ram:add_unit("endgame_army", "wh_main_grn_cav_goblin_wolf_riders_0", 2)
		ram:add_unit("endgame_army", "wh_main_grn_cav_goblin_wolf_riders_1", 4)
		ram:add_unit("endgame_army", "wh_main_grn_cav_goblin_wolf_chariot", 3)
		ram:add_unit("endgame_army", "wh_main_grn_cav_forest_goblin_spider_riders_0", 2)
		ram:add_unit("endgame_army", "wh_main_grn_cav_forest_goblin_spider_riders_1", 2)
		ram:add_unit("endgame_army", "wh_dlc06_grn_cav_squig_hoppers_0", 1)
		ram:add_unit("endgame_army", "wh_main_grn_cav_orc_boar_boyz", 1)
		ram:add_unit("endgame_army", "wh_main_grn_cav_orc_boar_boy_big_uns", 5)
		ram:add_unit("endgame_army", "wh_main_grn_cav_orc_boar_chariot", 1)
		ram:add_unit("endgame_army", "wh_main_grn_cav_savage_orc_boar_boyz", 2)
		ram:add_unit("endgame_army", "wh_main_grn_cav_savage_orc_boar_boy_big_uns", 3)
		
		--Monsters
		ram:add_unit("endgame_army", "wh_dlc06_grn_inf_squig_herd_0", 2)
		ram:add_unit("endgame_army", "wh_main_grn_mon_trolls", 3)
		ram:add_unit("endgame_army", "wh_main_grn_mon_giant", 2)
		ram:add_unit("endgame_army", "wh_main_grn_mon_arachnarok_spider_0", 2)
		
		--Artillery
		ram:add_unit("endgame_army", "wh_main_grn_art_goblin_rock_lobber", 2)
		ram:add_unit("endgame_army", "wh_main_grn_art_doom_diver_catapult", 4)

	end

	if army_template.tomb_kings then
		--Infantry
		ram:add_unit("endgame_army", "wh2_dlc09_tmb_inf_skeleton_warriors_0", 2)
		ram:add_unit("endgame_army", "wh2_dlc09_tmb_inf_skeleton_spearmen_0", 2)
		ram:add_unit("endgame_army", "wh2_dlc09_tmb_inf_tomb_guard_0", 6)
		ram:add_unit("endgame_army", "wh2_dlc09_tmb_inf_tomb_guard_1", 8)
		ram:add_unit("endgame_army", "wh2_dlc09_tmb_inf_nehekhara_warriors_0", 8)
		ram:add_unit("endgame_army", "wh2_dlc09_tmb_inf_skeleton_archers_0", 4)
		
		--Cavalry
		ram:add_unit("endgame_army", "wh2_dlc09_tmb_cav_skeleton_horsemen_0", 4)
		ram:add_unit("endgame_army", "wh2_dlc09_tmb_cav_nehekhara_horsemen_0", 2)
		ram:add_unit("endgame_army", "wh2_dlc09_tmb_veh_skeleton_chariot_0", 2)
		ram:add_unit("endgame_army", "wh2_dlc09_tmb_veh_skeleton_archer_chariot_0", 3)
		ram:add_unit("endgame_army", "wh2_dlc09_tmb_cav_skeleton_horsemen_archers_0", 6)
		ram:add_unit("endgame_army", "wh2_dlc09_tmb_mon_sepulchral_stalkers_0", 3)
		ram:add_unit("endgame_army", "wh2_dlc09_tmb_cav_necropolis_knights_0", 1)
		ram:add_unit("endgame_army", "wh2_dlc09_tmb_cav_necropolis_knights_1", 2)
		
		--Monsters
		ram:add_unit("endgame_army", "wh2_dlc09_tmb_mon_carrion_0", 4)
		ram:add_unit("endgame_army", "wh2_dlc09_tmb_mon_ushabti_0", 2)
		ram:add_unit("endgame_army", "wh2_dlc09_tmb_mon_ushabti_1", 4)
		ram:add_unit("endgame_army", "wh2_dlc09_tmb_veh_khemrian_warsphinx_0", 2)
		ram:add_unit("endgame_army", "wh2_dlc09_tmb_mon_tomb_scorpion_0", 4)
		ram:add_unit("endgame_army", "wh2_dlc09_tmb_mon_heirotitan_0", 2)
		ram:add_unit("endgame_army", "wh2_dlc09_tmb_mon_necrosphinx_0", 2)
		ram:add_unit("endgame_army", "wh2_pro06_tmb_mon_bone_giant_0", 4)
		
		--Artillery
		ram:add_unit("endgame_army", "wh2_dlc09_tmb_art_screaming_skull_catapult_0", 2)
		ram:add_unit("endgame_army", "wh2_dlc09_tmb_art_casket_of_souls_0", 3)
	
	end
	
	if army_template.chaos then
		--Infantry
		ram:add_unit("endgame_army", "wh_main_chs_inf_chaos_warriors_1", 2)
		ram:add_unit("endgame_army", "wh_dlc01_chs_inf_chaos_warriors_2", 2)
		ram:add_unit("endgame_army", "wh_dlc01_chs_inf_forsaken_0", 4)
		ram:add_unit("endgame_army", "wh_main_chs_inf_chosen_0", 8)
		ram:add_unit("endgame_army", "wh_main_chs_inf_chosen_1", 6)
		ram:add_unit("endgame_army", "wh_dlc01_chs_inf_chosen_2", 6)
		
		--Cavalry
		ram:add_unit("endgame_army", "wh_dlc06_chs_cav_marauder_horsemasters_0", 2)
		ram:add_unit("endgame_army", "wh_main_chs_cav_chaos_chariot", 2)
		ram:add_unit("endgame_army", "wh_dlc01_chs_cav_gorebeast_chariot", 1)
		ram:add_unit("endgame_army", "wh_main_chs_cav_chaos_knights_0", 1)
		ram:add_unit("endgame_army", "wh_main_chs_cav_chaos_knights_1", 2)
		
		--Monsters
		ram:add_unit("endgame_army", "wh_dlc06_chs_inf_aspiring_champions_0", 2) -- They're not really monsters but they're a low entity unit like monsters
		ram:add_unit("endgame_army", "wh_main_chs_mon_chaos_warhounds_1", 2)
		ram:add_unit("endgame_army", "wh_main_chs_mon_trolls", 3)
		ram:add_unit("endgame_army", "wh_dlc01_chs_mon_trolls_1", 2)
		ram:add_unit("endgame_army", "wh_main_chs_mon_chaos_spawn", 2)
		ram:add_unit("endgame_army", "wh_dlc06_chs_feral_manticore", 2)
		ram:add_unit("endgame_army", "wh_main_chs_mon_giant", 2)
		ram:add_unit("endgame_army", "wh_dlc01_chs_mon_dragon_ogre", 2)
		ram:add_unit("endgame_army", "wh_dlc01_chs_mon_dragon_ogre_shaggoth", 2)
		
		--Artillery
		ram:add_unit("endgame_army", "wh_main_chs_art_hellcannon", 1)

		--Vehicles
		ram:add_unit("endgame_army", "wh3_dlc20_chs_mon_warshrine", 1)
		

	end

	if army_template.empire then

		--Infantry
		ram:add_unit("endgame_army", "wh_main_emp_inf_swordsmen", 5)
		ram:add_unit("endgame_army", "wh_main_emp_inf_halberdiers", 5)
		ram:add_unit("endgame_army", "wh_main_emp_inf_greatswords", 5)
		ram:add_unit("endgame_army", "wh_main_emp_inf_crossbowmen", 2)
		ram:add_unit("endgame_army", "wh_dlc04_emp_inf_free_company_militia_0", 1)
		ram:add_unit("endgame_army", "wh_main_emp_inf_handgunners", 3)
		
		--Cavalry
		ram:add_unit("endgame_army", "wh_main_emp_cav_empire_knights", 4)
		ram:add_unit("endgame_army", "wh_main_emp_cav_reiksguard", 1)
		ram:add_unit("endgame_army", "wh_main_emp_cav_pistoliers_1", 2)
		ram:add_unit("endgame_army", "wh_main_emp_cav_outriders_0", 1)
		ram:add_unit("endgame_army", "wh_main_emp_cav_outriders_1", 2)
		ram:add_unit("endgame_army", "wh_dlc04_emp_cav_knights_blazing_sun_0", 1)
		ram:add_unit("endgame_army", "wh_main_emp_cav_demigryph_knights_0", 2)
		ram:add_unit("endgame_army", "wh_main_emp_cav_demigryph_knights_1", 2)
		
		--Artillery
		ram:add_unit("endgame_army", "wh_main_emp_art_mortar", 1)
		ram:add_unit("endgame_army", "wh_main_emp_art_great_cannon", 1)
		ram:add_unit("endgame_army", "wh_main_emp_art_helblaster_volley_gun", 1)
		ram:add_unit("endgame_army", "wh_main_emp_art_helstorm_rocket_battery", 1)
	
	end

	if army_template.wood_elves then

		--Infantry
		ram:add_unit("endgame_army", "wh_dlc05_wef_inf_eternal_guard_0", 8)
		ram:add_unit("endgame_army", "wh_dlc05_wef_inf_eternal_guard_1", 12)
		ram:add_unit("endgame_army", "wh_dlc05_wef_inf_dryads_0", 4)
		ram:add_unit("endgame_army", "wh_dlc05_wef_inf_wardancers_1", 8)
		ram:add_unit("endgame_army", "wh_dlc05_wef_inf_wildwood_rangers_0", 4)
		ram:add_unit("endgame_army", "wh_dlc05_wef_inf_glade_guard_2", 12)
		ram:add_unit("endgame_army", "wh_dlc05_wef_inf_deepwood_scouts_1", 8)
		ram:add_unit("endgame_army", "wh_dlc05_wef_inf_waywatchers_0", 6)

		--Cavalry
		ram:add_unit("endgame_army", "wh_dlc05_wef_cav_wild_riders_1", 6)
		ram:add_unit("endgame_army", "wh_dlc05_wef_cav_glade_riders_0", 6)
		ram:add_unit("endgame_army", "wh_dlc05_wef_cav_glade_riders_1", 2)
		ram:add_unit("endgame_army", "wh_dlc05_wef_cav_hawk_riders_0", 1)
		ram:add_unit("endgame_army", "wh_dlc05_wef_cav_sisters_thorn_0", 1)

		--Monsters
		ram:add_unit("endgame_army", "wh_dlc05_wef_mon_treekin_0", 4)
		ram:add_unit("endgame_army", "wh_dlc05_wef_mon_treeman_0", 4)
		ram:add_unit("endgame_army", "wh_dlc05_wef_mon_great_eagle_0", 1)
		ram:add_unit("endgame_army", "wh_dlc05_wef_forest_dragon_0", 2)

	end

	if army_template.dwarfs then
		--Infantry
		ram:add_unit("endgame_army", "wh_main_dwf_inf_miners_1", 6)
		ram:add_unit("endgame_army", "wh_main_dwf_inf_hammerers", 8)
		ram:add_unit("endgame_army", "wh_main_dwf_inf_ironbreakers", 8)
		ram:add_unit("endgame_army", "wh_main_dwf_inf_longbeards", 4)
		ram:add_unit("endgame_army", "wh_main_dwf_inf_longbeards_1", 8)
		ram:add_unit("endgame_army", "wh_main_dwf_inf_slayers", 6)
		ram:add_unit("endgame_army", "wh2_dlc10_dwf_inf_giant_slayers", 4)
		ram:add_unit("endgame_army", "wh_main_dwf_inf_thunderers_0", 8)
		ram:add_unit("endgame_army", "wh_main_dwf_inf_irondrakes_0", 4)
		ram:add_unit("endgame_army", "wh_main_dwf_inf_irondrakes_2", 6)
		ram:add_unit("endgame_army", "wh_dlc06_dwf_inf_rangers_0", 2)
		ram:add_unit("endgame_army", "wh_dlc06_dwf_inf_rangers_1", 4)
		ram:add_unit("endgame_army", "wh_dlc06_dwf_inf_bugmans_rangers_0", 2)
		
		--Artillery
		ram:add_unit("endgame_army", "wh_main_dwf_art_grudge_thrower", 1)
		ram:add_unit("endgame_army", "wh_main_dwf_art_cannon", 4)
		ram:add_unit("endgame_army", "wh_main_dwf_art_organ_gun", 4)
		ram:add_unit("endgame_army", "wh_main_dwf_art_flame_cannon", 2)
		
		--Vehicles
		ram:add_unit("endgame_army", "wh_main_dwf_veh_gyrocopter_0", 1)
		ram:add_unit("endgame_army", "wh_main_dwf_veh_gyrocopter_1", 1)
		ram:add_unit("endgame_army", "wh_main_dwf_veh_gyrobomber", 1)
		
	end

	return ram:generate_force("endgame_army", unit_count, false)

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