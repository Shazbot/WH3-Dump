payloads_executor = {

	-- some payloads may need to save and load data
	persistent = {},
	-- payload_table is the config with things that don't change (e.g. units to spawn)
	-- params_table contains holds things that change from game to game (e.g. multiplier due to game difficulty, chosen targets or turn number)
	execute_payload = function(payload_table, params_table)
		if payload_table.payload_type == "spawn_army" then
			payloads_executor.generate_army_payload_handler:execute(payload_table, params_table)
		elseif payload_table.payload_type == "diplomacy" then
			payloads_executor.diplomacy_payload_handler:execute(payload_table, params_table)
		elseif payload_table.payload_type == "dilemma" then
			payloads_executor.dilemma_payload_handler:execute(payload_table, params_table)
		elseif payload_table.payload_type == "incident" then
			payloads_executor.incident_payload_handler:execute(payload_table, params_table)
		elseif payload_table.payload_type == "mission" then
			payloads_executor.mission_payload_handler:execute(payload_table, params_table)
		elseif payload_table.payload_type == "marker" then
			payloads_executor.marker_payload_handler:execute(payload_table, params_table)
		elseif payload_table.payload_type == "corruption" then
			payloads_executor.corruption_payload_handler:execute(payload_table, params_table)
		elseif payload_table.payload_type == "treasury" then
			payloads_executor.treasury_payload_handler:execute(payload_table, params_table)
		elseif payload_table.payload_type == "ancillary" then
			payloads_executor.ancillary_payload_handler:execute(payload_table, params_table)
		elseif payload_table.payload_type == "trait" then
			payloads_executor.trait_payload_handler:execute(payload_table, params_table)
		elseif payload_table.payload_type == "ai_personality_change" then
			payloads_executor.ai_personality_change_payload_handler:execute(payload_table, params_table)
		elseif payload_table.payload_type == "effect_bundle" then
			payloads_executor.effect_bundle_payload_handler:execute(payload_table, params_table)
		elseif payload_table.payload_type == "foreshadow" then 
			payloads_executor.foreshadow_payload_handler:execute(payload_table, params_table)
		elseif payload_table.payload_type == "confederate" then 
			payloads_executor.confederate_handler:execute(payload_table, params_table)
		else 
			script_error("execute_payload called but provided with unhandled payload type: " .. tostring(payload_table.payload_type))
		end
	end,

	generate_army_payload_handler = 
	{
		execute = function(self, payload_table, params_table)
			local region_key = params_table.region_key or payload_table.region_key
			if not region_key then
				local region_keys = table.copy(params_table.target_region_keys or payload_table.target_region_keys)
				if not is_table(region_keys) then
					return false
				end
				if #region_keys <= 0 then
					return false
				end
				local random_index = cm:random_number(#region_keys, 1)
				region_key = region_keys[random_index]
				table.remove(region_keys, random_index)
			end
			local faction_key = params_table.force_owner or payload_table.force_owner
			local army_template = params_table.army_template or payload_table.army_template
			local unit_list = params_table.unit_list or payload_table.unit_list
			local declare_war = params_table.declare_war
			local unit_amount = params_table.max_units or payload_table.max_units
			local total_armies = params_table.total_armies
			self:create_payload_force(faction_key, region_key, army_template, unit_list, unit_amount, total_armies)

			-- here the value from the params_table is taken with higher priority 
			-- it overrides the one from the config because we change it
			local times_to_apply = params_table.times_to_apply or payload_table.times_to_apply or 1
			if times_to_apply > 1 then
				params_table.times_to_apply = times_to_apply - 1
				-- I put the code to execute this multiple times here and not in a more generic method
				-- because this is where we remove target regions (so we don't spawn multiple armies in the same region if others are available)
				self:execute(payload_table, params_table)
			end
		end,


		-- Spawned scenario forces are always given free upkeep so the AI doesn't immediately disband them
		-- Army template is a table containing all desired templates, e.g. {chaos = true, empire = true}
		-- unlike endgame:create_scenario_force will not declare war - use the dedicated payload
		create_payload_force = function(self, faction_key, region_key, army_template, unit_list, unit_amount, total_armies)
			--  if total_armies is invalid we assume we want a single army
			if total_armies == nil or total_armies < 1 then
				total_armies = 1
			end

			total_armies = math.floor(total_armies)

			for i = 1, total_armies do
				local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, region_key, false, true, 10)
				if pos_x > 0 and pos_y > 0 then
					-- TODO: check if we should add max budget
					local generated_unit_list = self:generate_random_army(army_template, unit_list, unit_amount)

					cm:create_force(
						faction_key,
						generated_unit_list,
						region_key,
						pos_x,
						pos_y,
						false,
						function(cqi)
							-- TODO: any post-creation tweaks
						end
					)
				end
			end
		end,

		-- The random army manager generates new random army lists using unit_lists from scenarios
		-- This is setup to only create a new random army if the army_template hasn't been used before
		-- Each scenario should use its own army template key in order to not have conflicts
		generate_random_army = function(self, army_template, unit_list, unit_amount)
			local ram = random_army_manager
			local army_string = "endgame_random_army_" .. army_template
			if ram:get_force_by_key(army_string) == false then
				ram:new_force(army_string)
				for key, value in dpairs(unit_list) do
					ram:add_unit(army_string, key, value)
				end;
			end
			return ram:generate_force(army_string, unit_amount, false)
		end,
	},

	diplomacy_payload_handler = 
	{
		execute = function(self, payload_table, params_table)
			if payload_table.diplomacy_action == "declare_war" then
				local attacker_faction_key = params_table.attacker_faction_key
				local defender_faction_key = params_table.defender_faction_key
				if defender_faction_key == nil and is_string(params_table.region_key) then
					defender_faction_key = cm:get_region(region_key):owning_faction()
				end
				-- TODO: test is_string(attacker_faction_key) and is_string(defender_faction_key)
				self:declare_war(attacker_faction_key, defender_faction_key)
			else
				script_error("execute_payload called but provided with unhandled payload type: " .. tostring(payload_table.payload_type))
			end
		end,

		declare_war = function(attacker_key, defender_key)
			if defender_key == "rebels" then
				return
			end
			local defender_faction = cm:get_faction(defender_key)
			if defender_faction and defender_faction:is_null_interface() == false then
				if defender_faction:is_vassal() then
					defender_faction = defender_faction:master()
					defender_key = defender_faction:name()
				end
				if attacker_key ~= defender_key and cm:get_faction(attacker_key):at_war_with(defender_faction) == false then
					out("ENDGAME: Declaring war between " .. attacker_key .. " and " .. defender_key)
					cm:force_declare_war(attacker_key, defender_key, false, false)
				end
			end
		end
	},

	dilemma_payload_handler = 
	{
		execute = function(self, payload_table, params_table)
			local dilemma_key = params_table.dilemma_key or payload_table.dilemma_key
			local faction_key = params_table.faction_key or payload_table.faction_key
			
			if is_string(faction_key) then
				cm:trigger_dilemma(faction_key, dilemma_key)
			else
				-- this also works in multiplayer
				local human_factions = cm:get_human_factions()
				for i = 1, #human_factions do
					cm:trigger_dilemma(human_factions[i], dilemma_key)
				end
			end
		end,
	},

	incident_payload_handler = 
	{
		execute = function(self, payload_table, params_table)
			local incident_key = params_table.incident_key or payload_table.incident_key
			local faction_key = params_table.faction_key or payload_table.faction_key

			if is_string(faction_key) then
				cm:trigger_incident(faction_key, incident_key, true, true)
			else
				-- this also works in multiplayer
				local human_factions = cm:get_human_factions()
				for i = 1, #human_factions do
					cm:trigger_incident(human_factions[i], incident_key, true, true)
				end
			end
		end,
	},

	mission_payload_handler = 
	{
		execute = function(self, payload_table, params_table)
			local mission_key = params_table.mission_key or payload_table.mission_key
			local faction_key = params_table.faction_key or payload_table.faction_key
			
			if is_string(faction_key) then
				cm:trigger_mission(faction_key, mission_key, true, true)
			else
				-- this also works in multiplayer
				local human_factions = cm:get_human_factions()
				for i = 1, #human_factions do
					cm:trigger_mission(human_factions[i], mission_key, true, true)
				end
			end
		end,
	},

	marker_payload_handler = 
	{
		execute = function(self, payload_table, params_table)
			local marker_key = params_table.marker_key or payload_table.marker_key
			if payload_table.marker_action == "add_marker" then
				self:setup_marker(payload_table, params_table)
			elseif payload_table.marker_action == "remove_marker" then
				local encounter_marker_object = Interactive_Marker_Manager:get_marker(marker_key)
				if encounter_marker_object then
					encounter_marker_object:despawn_all()
				else
					out("ERROR: payloads_executor could not find marker id '"..tostring(marker_key).."'!")
				end
			end
		end,

		setup_marker = function(self, payload_table, params_table)
			local region_key = params_table.region_key or payload_table.region_key
			local marker_key = params_table.marker_key or payload_table.marker_key
			local marker_info = params_table.marker_info or payload_table.marker_info -- "wh3_dlc25_nemesis_crown_battle_marker"
			local spawn_type = params_table.spawn_type or payload_table.spawn_type -- "region" or "character"
			local keep_after_battle = params_table.keep_after_battle or payload_table.keep_after_battle -- true/false
			local marker_faction_key = params_table.marker_faction_key or payload_table.marker_faction_key
			local interaction_event = params_table.interaction_event or payload_table.interaction_event

			local payload_marker = Interactive_Marker_Manager:new_marker_type(marker_key, 
				marker_info,
				nil, -- duration
				1, -- radius
				marker_faction_key
				)

			if interaction_event then
				payload_marker:add_interaction_event(interaction_event)
			end

			if keep_after_battle then
				-- we want to save the marker and remove it manually
				-- in case the player loses, the marker should not be removed
				payload_marker.despawn_settings.should_despawn = false
			end

			-- this means the army does not persist on the map after the fight, win or lose
			payload_marker:is_persistent(false)

			if spawn_type == "region" then
				payload_marker:spawn_at_region(region_key, 
					nil, -- is_despawn
					nil, -- opt_on_sea
					nil, -- opt_same_region
					20, -- opt_prefered_distance, we may send param for this in the future, if need
					marker_faction_key)
			elseif spawn_type == "character" then
				local faction = cm:get_faction(marker_faction_key)
				local character = faction:faction_leader()
				if character:has_region() then
					payload_marker:spawn_at_character(character:command_queue_index(), false, nil, 10)
				else
					payload_marker:spawn_at_region(faction:home_region():name(), 
						nil, -- is_despawn
						nil, -- opt_on_sea
						nil, -- opt_same_region
						20,  -- opt_prefered_distance, we may send param for this in the future, if need
						marker_faction_key)
				end
			end
		end,
	},

	corruption_payload_handler = 
	{
		execute = function(self, payload_table, params_table)
			local marker_key = params_table.marker_key or payload_table.marker_key
			if payload_table.corruption_action == "add_corruption" then
				self:add_corruption(payload_table, params_table)
			elseif payload_table.corruption_action == "remove_corruption" then
				self:remove_corruption(payload_table, params_table)
			else 
				script_error("corruption_payload_handler executed but provided corruption_action was unhandled: " .. tostring(payload_table.corruption_action))
			end
		end,

		-- adds a specified type of corruption to a region
		add_corruption = function(self, payload_table, params_table)
			local region_key = params_table.region_key or payload_table.region_key
			if(region_key) then
				self:add_corruption_to_region(region_key, payload_table, params_table)
			else
				self:add_corruption_to_provinces(payload_table, params_table)
			end
		end,

		add_corruption_to_region = function(self, region_key, payload_table, params_table)
			local region_script_interface = cm:get_region(region_key)
			if (not region_script_interface)
				or region_script_interface:is_null_interface()
			then
				return
			end
			local province_script_interface = region_script_interface:province()
			local corruption_type = params_table.corruption_type or payload_table.corruption_type
			local corruption_amount = params_table.corruption_amount or payload_table.corruption_amount
			local corruption_factor = params_table.corruption_factor or payload_table.corruption_factor
			if not corruption_factor then
				return
			end
			cm:change_corruption_in_province_by(province_script_interface, corruption_type, corruption_amount, corruption_factor)
		end,

		add_corruption_to_provinces = function(self, payload_table, params_table)
			local province_keys = params_table.province_keys or payload_table.province_keys
			for province_key, applied_corruption  in dpairs(province_keys) do
				if applied_corruption == false then
					local province_script_interface = cm:get_province(province_key)
					local corruption_type = params_table.corruption_type or payload_table.corruption_type
					local corruption_amount = params_table.corruption_amount or payload_table.corruption_amount
					local corruption_factor = params_table.corruption_factor or payload_table.corruption_factor
					if corruption_factor then
						cm:change_corruption_in_province_by(province_script_interface, corruption_type, corruption_amount, corruption_factor)
					end
					applied_corruption = true
				end
			end
			
		end,

		-- removes a specified type of corruption from the province of a region
		-- if no corruption type is specified, all of them listed in corruption_types in lib_campaign_manager.lua are removed
		remove_corruption = function(self, payload_table, params_table)
			local region_key = params_table.region_key or payload_table.region_key
			if(region_key) then
				self:remove_corruption_from_region(region_key, payload_table, params_table)
			else
				self:remove_corruption_from_provinces(payload_table, params_table)
			end
		end,

		remove_corruption_from_region = function(self, region_key, payload_table, params_table)
			local region_script_interface = cm:get_region(region_key)
			if (not region_script_interface)
				or region_script_interface:is_null_interface()
			then
				return
			end
			local province_script_interface = region_script_interface:province()
			local corruption_factor = params_table.corruption_factor or payload_table.corruption_factor
			if not corruption_factor then
				return
			end

			local corruption_type = params_table.corruption_type or payload_table.corruption_type
			if corruption_type then
				self:remove_corruption_by_type(province_script_interface, corruption_type, corruption_factor)
			else
				for c = 1, #corruption_types do
					local corruption_type = corruption_types[c]
					self:remove_corruption_by_type(province_script_interface, corruption_type, corruption_factor)
				end
			end
		end,

		remove_corruption_from_provinces = function(self, payload_table, params_table)
			local province_keys = params_table.province_keys or payload_table.province_keys
			for province_key, applied_corruption  in dpairs(province_keys) do
				local province_script_interface = cm:get_province(province_key)
				if applied_corruption == false then
					local corruption_factor = params_table.corruption_factor or payload_table.corruption_factor
					if not corruption_factor then
						return
					end
				
					local corruption_type = params_table.corruption_type or payload_table.corruption_type
					if corruption_type then
						self:remove_corruption_by_type(province_script_interface, corruption_type, corruption_factor)
					else
						for c = 1, #corruption_types do
							local corruption_type = corruption_types[c]
							self:remove_corruption_by_type(province_script_interface, corruption_type, corruption_factor)
						end
					end 
				end
			end
		end,


		-- removes a specified type of corruption from a province
		remove_corruption_by_type = function(self, province_script_interface, corruption_type, corruption_factor)
			if not corruption_type then
				return
			end
			local corruption_amount = cm:get_corruption_value_in_province(province_script_interface, corruption_type)
			if is_number(corruption_amount) and corruption_amount > 0 then
				cm:change_corruption_in_province_by(province_script_interface, corruption_type, -corruption_amount, corruption_factor)
			end
		end
	},

	treasury_payload_handler = 
	{
		execute = function(self, payload_table, params_table)
			local target_faction_key = params_table.target_faction_key or payload_table.target_faction_key
			local amount = params_table.amount or payload_table.amount
			cm:treasury_mod(target_faction_key, amount)
		end,
	},

	ancillary_payload_handler = 
	{
		execute = function(self, payload_table, params_table)
			local target_faction_key = params_table.target_faction_key or payload_table.target_faction_key
			local faction_interface = cm:get_faction(target_faction_key)
			local leader_character = faction_interface:faction_leader()
			local ancillary_key = params_table.ancillary_key or payload_table.ancillary_key
			cm:force_add_ancillary(leader_character, ancillary_key, false, false)
		end,
	},

	trait_payload_handler = 
	{
		execute = function(self, payload_table, params_table)
			local target_faction_key = params_table.target_faction_key or payload_table.target_faction_key
			local faction_interface = cm:get_faction(target_faction_key)
			local leader_character = faction_interface:faction_leader()
			local trait_key = params_table.trait_key or payload_table.trait_key
			cm:force_add_trait("character_cqi:"..leader_character:cqi(), trait_key, true)
		end,
	},

	ai_personality_change_payload_handler =
	{
		execute = function(self, payload_table, params_table)
			local target_faction_keys = params_table.faction_keys or payload_table.faction_keys
			local ai_personality_key = params_table.ai_personality_key or payload_table.ai_personality_key
			self:change_factions_ai_personality(target_faction_keys, ai_personality_key)
		end,

		--- @function change_factions_ai_personality
		--- @desc Takes <code>faction_keys<code> and switches their ai personality to the input one
		--- @p table faction_keys a list of string faction keys
		--- @p string ai_personality_key is the personality to change to
 		change_factions_ai_personality = function(self, faction_keys, ai_personality_key)
			if not is_table(faction_keys) then
				script_error("ERROR: change_factions_ai_personality() called but supplied faction_keys  [" .. tostring(faction_keys) .. "] is not a table")
				return
			end

			if not is_string(ai_personality_key) then
					script_error("ERROR: change_factions_ai_personality() called but supplied ai_personality_key [" .. tostring(ai_personality_key) .. "] is not a string")
				return
			end

			for _, valid_faction_key in ipairs(faction_keys) do
				if not is_string(valid_faction_key) then
					script_error("ERROR: change_factions_ai_personality() called but supplied valid_faction_key [" .. tostring(valid_faction_key) .. "] is not a string")
				else 
					local faction = cm:get_faction(valid_faction_key)
					if faction
						and not faction:is_null_interface()
						and not faction:is_dead()
						and not faction:is_human()
					then
						cm:force_change_cai_faction_personality(valid_faction_key, ai_personality_key)
					end
				end
			end
		end,
	},

	effect_bundle_payload_handler = 
	{
		execute = function(self, payload_table, params_table)
			if payload_table.bundle_action == nil -- if no action is specified, we try to add the bundle
				or payload_table.bundle_action == "add_bundle"
			then
				self:add_bundle(payload_table, params_table)
			elseif payload_table.bundle_action == "remove_bundle" then
				self:remove_bundle(payload_table, params_table)
			else
				out("ERROR: payloads_executor could not find bundle action id '"..tostring(payload_table.bundle_action).."'!")
			end
		end,

		add_bundle = function(self, payload_table, params_table)
			local bundle_key = params_table.bundle_key or payload_table.bundle_key
			if not is_string(bundle_key) then
				out("ERROR: payloads_executor did not receive proper bundle id '"..tostring(bundle_key).."'!")
				return
			end

			-- 0 here means 'indefinitely', which is the default value
			local turns_duration = params_table.turns_duration or payload_table.turns_duration or 0

			local faction_key = params_table.faction_key or payload_table.faction_key
			if is_string(faction_key) then
				cm:apply_effect_bundle(bundle_key, faction_key, turns_duration)
				return
			end

			local faction_keys = params_table.faction_keys or payload_table.faction_keys
			if is_table(faction_keys) then
				for _index, faction_key in ipairs(faction_keys) do
					if is_string(faction_key) then
						cm:apply_effect_bundle(bundle_key, faction_key, turns_duration)
					end
				end
				return
			end

			-- if needed, we can extend this with character identifiers, regions, etc.
			out("ERROR: payloads_executor could not find proper target to add bundle '"..tostring(bundle_key).."'!")
		end,

		remove_bundle = function(payload_table, params_table)
			local bundle_key = params_table.bundle_key or payload_table.bundle_key
			if not is_string(bundle_key) then
				out("ERROR: payloads_executor did not receive proper bundle id '"..tostring(bundle_key).."'!")
				return
			end

			local faction_key = params_table.faction_key or payload_table.faction_key
			if is_string(faction_key) then
				cm:remove_effect_bundle(bundle_key, faction_key)
				return
			end

			local faction_keys = params_table.faction_keys or payload_table.faction_keys
			if is_table(faction_keys) then
				for _index, faction_key in ipairs(faction_keys) do
					if is_string(faction_key) then
						cm:remove_effect_bundle(bundle_key, faction_key)
					end
				end
				return
			end

			out("ERROR: payloads_executor could not find proper target to remove bundle bundle '"..tostring(bundle_key).."'!")
		end,
	},

	foreshadow_payload_handler = {
		execute = function(self, payload_table, params_table)
			local incident_key = params_table.foreshadow_data_key or payload_table.foreshadow_data_key
			local faction_key = params_table.faction_key or payload_table.faction_key

			cm:set_script_state("current_episode_popup", incident_key)
			if incident_key == "" then
				return
			end
			local local_faction_key = cm:get_local_faction_name(true)
			if not is_string(local_faction_key) then
				return
			end
			if is_string(faction_key) and faction_key ~= local_faction_key then
				return
			end

			common.call_context_command("ToggleHUDPanel('dlc29_endgame_crisis_scenarios')")
		end
	},

	confederate_handler = {
		execute = function(self, payload_table, params_table)
			local faction_key = params_table.faction_key or payload_table.faction_key
			local confederated_factions_table = params_table.confederated_factions_table or payload_table.confederated_factions_table

			if not is_string(faction_key) then
				out("ERROR: payloads_executor confederate_handler could not confederate to invalid faction '"..tostring(faction_key).."'!")
				return
			end

			local confederation_leader_faction = cm:get_faction(faction_key)
			if not confederation_leader_faction or confederation_leader_faction:is_null_interface() then
				out("ERROR: payloads_executor confederate_handler could not confederate to invalid faction '"..tostring(faction_key).."'!")
				return
			end

			if confederation_leader_faction:is_dead() then
				-- the faction should be resurrected before this payload is used
				out("ERROR: payloads_executor confederate_handler could not confederate to dead faction '"..tostring(faction_key).."'!")
				return
			end

			local confederated_factions_table = self:get_confederated_factions_from_set(payload_table, params_table)
			if not is_table(confederated_factions_table) then
				confederated_factions_table = self:get_confederated_factions_from_table(payload_table, params_table)
			end

			if not is_table(confederated_factions_table) then
				out("ERROR: payloads_executor confederate_handler could not find the list of factions to confederate, neither set not list was provided!")
				return
			end

			local confederation_chance_percentage = params_table.confederation_chance_percentage or payload_table.confederation_chance_percentage
			for i = 1, #confederated_factions_table do
				local confederated_faction_key = confederated_factions_table[i]
				if is_string(confederated_faction_key) and confederated_faction_key ~= faction_key then
					local confederated_faction = cm:get_faction(confederated_faction_key)
					if confederated_faction and confederated_faction:is_null_interface() == false then
						if confederated_faction:is_human() then
							-- humans don't get confederated, but they get a dilemma to ally
							local human_allied_dilemma = params_table.human_allied_dilemma or payload_table.human_allied_dilemma
							if is_string(human_allied_dilemma) then
								cm:trigger_dilemma(confederated_faction_key, human_allied_dilemma)
							end
						else
							local random_value = cm:random_number(100, 1)
							if not is_number(confederation_chance_percentage) or confederation_chance_percentage >= random_value
							then
								local faction_subculture = confederated_faction:subculture();
								cm:force_diplomacy("faction:" .. faction_key, "subculture:" .. faction_subculture, "form confederation", true, true, true);
								cm:force_confederation(faction_key, confederated_faction_key)
							end
						end
					else
						out("ERROR: payloads_executor confederate_handler could not confederate invalid faction '"..tostring(confederated_faction_key).."'!")
					end
				else
					out("ERROR: payloads_executor confederate_handler could not confederate invalid faction '"..tostring(confederated_faction_key).."'!")
				end
			end
		end,

		get_confederated_factions_from_set = function(self, payload_table, params_table)
			local faction_set_key = params_table.confederated_factions_set_key or payload_table.confederated_factions_set_key
			if not is_string(faction_set_key) then
				return nil
			end
			local world = cm:model():world()
			local confederated_factions = world:lookup_factions_from_faction_set(faction_set_key)
			-- confederated_factions is FACTION_LIST_SCRIPT_INTERFACE, we need to change it to a lua table
			local confederated_factions_table = {}
			for _, faction in model_pairs(confederated_factions) do
				table.insert(confederated_factions_table, faction:name())
			end
			return confederated_factions_table
		end,

		get_confederated_factions_from_table = function(self, payload_table, params_table)
			local confederated_factions_table = params_table.confederated_factions_table or payload_table.confederated_factions_table

			if not is_table(confederated_factions_table) then
				return nil
			end

			return confederated_factions_table
		end,
	},
}