norsca_kinfolk_config = {
	faction_key = "wh_dlc08_nor_wintertooth",
	expansion_resource_key = "wh3_dlc27_nor_troll_expansion",
	kinfolk_resource_key = "wh3_dlc27_nor_kinfolk",
	kinfolk_unit_gain_factor_key = "wh3_dlc27_nor_kinfolk_units",
	kinfolk_unit_gain = 1,
	kinfolk_throgg_multiplier = 2,
	kinfolk_stop_gain_effect_bundle_key = "wh3_dlc27_bundle_nor_throgg_trollkind_troll_call_dummy",
	kinfolk_stop_gain_bonus_value = "stop_kinfolk_gain",
	kinfolk_stop_gain_effect_duration = 10,
	kinfolk_units_unit_set = "wh3_dlc27_nor_kinfolk_units",
	kinfolk_recruitment_dilemma = "wh3_dlc27_nor_throgg_troll_recruitment_dilemma", 
	kinfolk_troll_king_expansion_incident = "wh3_dlc27_troll_king_expansion",
	kinfolk_army_destroyed = "wh3_dlc27_kinfolk_army_destroyed",

	victory_objectives = {
		short_victory = "wh3_dlc27_bundle_nor_troll_expansion_3",
		long_victory = "wh3_dlc27_bundle_nor_troll_expansion_6"
	},

	ritual_to_transported_army_keys = {
		wh3_dlc27_ritual_nor_throgg_units_level_1 = "wh3_dlc27_ritual_nor_throgg_units_level_1_force",
		wh3_dlc27_ritual_nor_throgg_units_level_2 = "wh3_dlc27_ritual_nor_throgg_units_level_2_force",
		wh3_dlc27_ritual_nor_throgg_units_level_3 = "wh3_dlc27_ritual_nor_throgg_units_level_3_force",
		wh3_dlc27_ritual_nor_throgg_units_level_4 = "wh3_dlc27_ritual_nor_throgg_units_level_4_force",
		wh3_dlc27_ritual_nor_throgg_units_level_5 = "wh3_dlc27_ritual_nor_throgg_units_level_5_force",
		wh3_dlc27_ritual_nor_throgg_units_level_6 = "wh3_dlc27_ritual_nor_throgg_units_level_6_force",
	},

	ai_spawn_armies_to_bundles_thresholds_and_cost = {
		wh3_dlc27_bundle_nor_troll_expansion_1 = {
			army_key = "wh3_dlc27_ritual_nor_throgg_units_level_1_force",
			cost = 20,
		},
		wh3_dlc27_bundle_nor_troll_expansion_2 = {
			army_key = "wh3_dlc27_ritual_nor_throgg_units_level_2_force",
			cost = 40,
		},
		wh3_dlc27_bundle_nor_troll_expansion_3 = {
			army_key = "wh3_dlc27_ritual_nor_throgg_units_level_3_force",
			cost = 60,
		},
		wh3_dlc27_bundle_nor_troll_expansion_4 = {
			army_key = "wh3_dlc27_ritual_nor_throgg_units_level_4_force",
			cost = 80,
		},
		wh3_dlc27_bundle_nor_troll_expansion_5 = {
			army_key = "wh3_dlc27_ritual_nor_throgg_units_level_5_force",
			cost = 100,
		},
		wh3_dlc27_bundle_nor_troll_expansion_6 = {
			army_key = "wh3_dlc27_ritual_nor_throgg_units_level_6_force",
			cost = 140,
		},
	},

	call_up_the_trolls_army_size_bonus_value = "wh3_dlc27_nor_throgg_call_up_the_trolls_army_size",

	kinfolk_levels = {
	{threshold = 20},
	{threshold = 40},
	{threshold = 60},
	{threshold = 80},
	{threshold = 115},
	}

}

norsca_kinfolk = {}
norsca_kinfolk.config = norsca_kinfolk_config

norsca_kinfolk.persistent =
{
	kinfolk_recruitment_dilemma_triggered = false,
}

function norsca_kinfolk:initialise()
	-- kinfolk gain 
	core:add_listener(
		"norsca_kinfolk_gain_from_army",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == norsca_kinfolk.config.faction_key
				and context:faction():bonus_values():scripted_value(norsca_kinfolk.config.kinfolk_stop_gain_bonus_value, "value") <= 0
		end,
		function(context)
			local forces = context:faction():military_force_list()
			local faction_kinfolk_change = 0
			for i = 0, forces:num_items() - 1 do
				local force = forces:item_at(i)
				if force and not force:is_null_interface() then
					local force_kinfolk_income = self:calculate_kinfolk_income_by_force(force)
					faction_kinfolk_change = faction_kinfolk_change + force_kinfolk_income
					self:set_force_kinfolk_script_context(force, force_kinfolk_income)
				end
			end
			if faction_kinfolk_change ~= 0 then
				cm:faction_add_pooled_resource(norsca_kinfolk.config.faction_key, norsca_kinfolk.config.kinfolk_resource_key, norsca_kinfolk.config.kinfolk_unit_gain_factor_key, faction_kinfolk_change)
			end
		end,
		true
	)

	-- stop kinfolk gain when we spawn a force
	core:add_listener(
		"norsca_kinfolk_spawn_army_stop_gain_kinfolk",
		"RitualCompletedEvent",
		function(context)
			return context:performing_faction():name() == norsca_kinfolk.config.faction_key and context:succeeded() and context:ritual():ritual_category() == "THROGG_TROLL_RITUAL"
		end,
		function(context)
			cm:apply_effect_bundle(norsca_kinfolk.config.kinfolk_stop_gain_effect_bundle_key, norsca_kinfolk.config.faction_key, norsca_kinfolk.config.kinfolk_stop_gain_effect_duration)

			local ritual_key = context:ritual():ritual_key()
			local transported_army_key = norsca_kinfolk.config.ritual_to_transported_army_keys[ritual_key]
			if transported_army_key == nil then
				return
			end

			norsca_kinfolk:spawn_transported_army(context:ritual_target_force(), transported_army_key, context:performing_faction())
		end,
		true
	)

	core:add_listener(
		"norsca_kinfolk_CharacterRecruited",
		"CharacterRecruited",
		function(context)
			return context:character():has_military_force() and context:character():faction():is_human() and context:character():faction():name() == norsca_kinfolk.config.faction_key
				and context:character():faction():bonus_values():scripted_value(norsca_kinfolk.config.kinfolk_stop_gain_bonus_value, "value") <= 0
		end,
		function(context)
			local force = context:character():military_force()
			if not force or force:is_null_interface() then
				return
			end

			local force_kinfolk_income = self:calculate_kinfolk_income_by_force(force)
			self:set_force_kinfolk_script_context(force, force_kinfolk_income)
		end,
		true
	)

	core:add_listener(
		"norsca_kinfolk_CharacterDestroyed",
		"CharacterDestroyed",
		function(context)
			local character_details = context:family_member():character_details()
			return character_details and not character_details:is_null_interface() and character_details:faction():is_human() and character_details:faction():name() == norsca_kinfolk.config.faction_key
		end,
		function(context)
			local character = context:family_member():character()
			if not character or character:is_null_interface() then
				return
			end

			local force = character:military_force()
			if not force or force:is_null_interface() then
				return
			end

			local force_kinfolk_income = self:calculate_kinfolk_income_by_force(force)
			self:set_force_kinfolk_script_context(force, force_kinfolk_income)
		end,
		true
	)

	core:add_listener(
		"norsca_kinfolk_TransportedMilitaryForceExpired",
		"TransportedMilitaryForceExpired",
		function(context)
			-- applies only when the faction already has this scripted bonus value
			return context:military_force():faction():name() == norsca_kinfolk.config.faction_key
				and context:military_force():faction():bonus_values():scripted_value(norsca_kinfolk.config.kinfolk_stop_gain_bonus_value, "value") > 0
		end,
		function(context)
			local destroyed_force = context:military_force()
			local destroyed_army_key = destroyed_force:get_transported_army_key()
			local destroyed_army_key_cqi = context:military_force():general_character():cqi()
			local faction = destroyed_force:faction()
			cm:trigger_incident_with_targets(faction:command_queue_index(), norsca_kinfolk.config.kinfolk_army_destroyed, 0, 0, destroyed_army_key_cqi, destroyed_army_key_cqi, 0, 0);

			if not table.contains(norsca_kinfolk.config.ritual_to_transported_army_keys, destroyed_army_key) then
				return
			end

			if destroyed_army_key == norsca_kinfolk.config.ai_spawn_armies_to_bundles_thresholds_and_cost.wh3_dlc27_bundle_nor_troll_expansion_6.army_key then
				-- if this is a Call up the Trolls level_6 transported army
				local force_list = destroyed_force:faction():transported_military_force_list()
				for i = 0, force_list:num_items() - 1 do
					local transported_force = force_list:item_at(i)
					if transported_force and not transported_force:is_null_interface() then
						local transported_army_key = transported_force:get_transported_army_key()
						if transported_force ~= destroyed_force and table.contains(norsca_kinfolk.config.ritual_to_transported_army_keys, transported_army_key) then
							-- if there's more Call up the Trolls transported armies currently available on the faction then don't remove the effect bundle
							return
						end
					end
				end
			end
			
			-- since this is a call up the trolls transported army, remove the stop-kinfolk accumulation effect bundle
			cm:remove_effect_bundle(norsca_kinfolk.config.kinfolk_stop_gain_effect_bundle_key, norsca_kinfolk.config.faction_key)
		end,
		true
	);

	core:add_listener(
		"norsca_kinfolk_UnitCreated",
		"UnitCreated",
		function(context)
			return context:unit():faction():is_human() and context:unit():faction():name() == norsca_kinfolk.config.faction_key
				and context:unit():faction():bonus_values():scripted_value(norsca_kinfolk.config.kinfolk_stop_gain_bonus_value, "value") <= 0
		end,
		function(context)
			local force = context:unit():military_force()
			if not force or force:is_null_interface() then
				return
			end

			local force_kinfolk_income = self:calculate_kinfolk_income_by_force(force)
			self:set_force_kinfolk_script_context(force, force_kinfolk_income)
		end,
		true
	)

	core:add_listener(
		"norsca_kinfolk_UnitDisbanded",
		"UnitDisbanded",
		function(context)
			return context:unit():faction():is_human() and context:unit():faction():name() == norsca_kinfolk.config.faction_key
		end,
		function(context)
			local force = context:unit():military_force()
			if not force or force:is_null_interface() then
				return
			end

			local force_kinfolk_income = self:calculate_kinfolk_income_by_force(force)
			self:set_force_kinfolk_script_context(force, force_kinfolk_income)
		end,
		true
	)

	core:add_listener(
		"norsca_kinfolk_dilemma_for_units",
		"MissionSucceeded",
		function(context)
			local mission_name = context:mission():mission_record_key()
			return mission_name == "wh3_dlc27_wintertooth_trollkin_resource_01" and context:faction():is_human() and not norsca_kinfolk.persistent.kinfolk_recruitment_dilemma_triggered
		end,
		function(context)
			local character = norsca_kinfolk:get_available_character(norsca_kinfolk.config.faction_key)
			if not character or character:is_null_interface() then
				return
			end

			local faction = context:faction()
			cm:trigger_dilemma_with_targets(faction:command_queue_index(), norsca_kinfolk.config.kinfolk_recruitment_dilemma, 0, 0, 0, character:military_force():command_queue_index(), 0, 0)
			norsca_kinfolk.persistent.kinfolk_recruitment_dilemma_triggered = true
		end,
		true
	)

	core:add_listener(
		"troll_king_dominion_pool_res",
		"PooledResourceChanged",
		function(context)
			local pr = context:resource()
			local faction = context:faction()
			if pr:key() == norsca_kinfolk.config.expansion_resource_key and faction:is_human() then
				for i = 1, #norsca_kinfolk.config.kinfolk_levels do 
					return pr:value() >= norsca_kinfolk.config.kinfolk_levels[i].threshold and (pr:value() - context:amount()) < norsca_kinfolk.config.kinfolk_levels[i].threshold
				end 
			end
		end,
		function(context)
			cm:trigger_incident(norsca_kinfolk.config.faction_key, norsca_kinfolk.config.kinfolk_troll_king_expansion_incident, true)
		end,
		true
	)
end

function norsca_kinfolk:get_available_character(faction_key)
	local faction_interface = cm:get_faction(faction_key)

	local faction_leader = faction_interface:faction_leader()
	if faction_leader and faction_leader:is_null_interface() == false and faction_leader:is_wounded() == false and faction_leader:has_military_force() and faction_leader:military_force():unit_list():num_items() < 20 then
		return faction_leader
	end

	local valid_target_chars = {}
	local random_char = false
	local character_list = faction_interface:character_list()
	for i, character in model_pairs(character_list) do
		if cm:char_is_general_with_army(character) and not character:military_force():is_armed_citizenry() and character:has_military_force() and character:military_force():unit_list():num_items() < 20 then
			table.insert(valid_target_chars, character)
		end
	end

	if #valid_target_chars > 0 then
		random_char = valid_target_chars[cm:random_number(#valid_target_chars)]
	else 
		return false
	end

	return random_char
end	

--- @p object target_force: the force to spawn the transported army to
--- @p string army_key: the transported army key to use; these keys are specified in transported_military_forces table
function norsca_kinfolk:spawn_transported_army(target_force, army_key, faction)
	local army_size_mod = faction:bonus_values():scripted_value(norsca_kinfolk.config.call_up_the_trolls_army_size_bonus_value, "value")

	if army_key == "wh3_dlc27_ritual_nor_throgg_units_level_6_force" then
		-- last tier ritual, identified by army_key, spawns a transported force in all our forces
		cm:spawn_transported_force_at_all_military_forces(faction:name(), army_key, army_size_mod, nor_pillaging.spawned_army_general_subtype)
	else
		local success = cm:spawn_transported_force_at_military_force(target_force:command_queue_index(), army_key, army_size_mod)
		if not success then
			script_error("ERROR: norsca_kinfolk:spawn_transported_army() - failed to spawn transported force at military force with command queue index " .. target_force:command_queue_index() .. " for faction " .. faction:name() .. " with army key " .. army_key)
			return false
		end
	end
end

function norsca_kinfolk:calculate_kinfolk_income_by_force(force)
	if force:is_armed_citizenry() or not force:has_general() then
		return 0
	end

	local character = force:general_character()
	if not character or character:is_null_interface() then
		return 0
	end

	local force_kinfolk_income = 0
	if character:is_faction_leader() then
		-- Throgg's character awards 1 kinfolk point as per design. And his unit is not in the kinfolk unit list.
		force_kinfolk_income = force_kinfolk_income + norsca_kinfolk.config.kinfolk_unit_gain
	end
	
	for j = 0, force:unit_list():num_items() - 1 do
		local unit = force:unit_list():item_at(j)
		if unit:is_unit_in_set(norsca_kinfolk.config.kinfolk_units_unit_set) then
			if character:is_faction_leader() then
				-- multiplied gain if unit in throgg's army
				force_kinfolk_income = force_kinfolk_income + norsca_kinfolk.config.kinfolk_unit_gain * norsca_kinfolk.config.kinfolk_throgg_multiplier
			else
				-- single gain if normal army
				force_kinfolk_income = force_kinfolk_income + norsca_kinfolk.config.kinfolk_unit_gain
			end
		end
	end

	return force_kinfolk_income
end

function norsca_kinfolk:set_force_kinfolk_script_context(force, force_kinfolk_income)
	if force:is_armed_citizenry() or not force:has_general() then
		return
	end

	local script_object_id = "throgg_call_up_the_trolls_" .. force:command_queue_index()
	common.set_context_value(script_object_id, force_kinfolk_income)
end


cm:add_first_tick_callback(
	function()
		if cm:is_new_game() then
			return
		end

		local faction = cm:get_faction(norsca_kinfolk.config.faction_key)
		if faction and not faction:is_null_interface() and faction:is_human() then
			local forces = faction:military_force_list()
			for i = 0, forces:num_items() - 1 do
				local force = forces:item_at(i)
				if force and not force:is_null_interface() then
					-- calculate force's kinfolk contribution and visualize it on the ui
					local force_kinfolk_income = norsca_kinfolk:calculate_kinfolk_income_by_force(force)
					norsca_kinfolk:set_force_kinfolk_script_context(force, force_kinfolk_income)
				end
			end
		end
	end
)

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("dlc27_nor_kinfolk", norsca_kinfolk.persistent, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		norsca_kinfolk.persistent = cm:load_named_value("dlc27_nor_kinfolk", norsca_kinfolk.persistent or {}, context)
	end
)
