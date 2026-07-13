tiger_court_config = {
	faction_key = "wh3_cp1_cth_tiger_warriors",
	pooled_resource = "wh3_cp1_cth_relics",
	pooled_resource_settlements = "wh3_cp1_cth_relics_settlements",
	path_pooled_resources = {
		"wh3_cp1_cth_court_military",
		"wh3_cp1_cth_court_bhashiva",
		"wh3_cp1_cth_court_spiritual",
	},
	path_to_ritual_mapping = {
		["wh3_cp1_cth_court_military"] = "wh3_cp1_ritual_cth_court_ritual_military",
		["wh3_cp1_cth_court_bhashiva"] = "wh3_cp1_ritual_cth_court_ritual_bhashiva",
		["wh3_cp1_cth_court_spiritual"] = "wh3_cp1_ritual_cth_court_ritual_spiritual",
	},
	path_to_initiative_set_mapping = {
		["wh3_cp1_cth_court_military"] = "wh3_cp1_cth_initiative_set_court_position_military",
		["wh3_cp1_cth_court_bhashiva"] = "wh3_cp1_cth_initiative_set_court_position_bhashiva",
		["wh3_cp1_cth_court_spiritual"] = "wh3_cp1_cth_initiative_set_court_position_spiritual",
	},
	path_to_ritual_chain_category_for_upgrades_mapping = {
		-- table which maps a path to a ritual category used for the ritual chain
		-- which upon performing/progressing through the chain should increase its pooled resource
		-- so it reaches the higher tier effects
		["wh3_cp1_cth_court_military"] = "CP1_TW_RESOURCES_MILITARY",
		["wh3_cp1_cth_court_bhashiva"] = "CP1_TW_RESOURCES_BHASHIVA",
		["wh3_cp1_cth_court_spiritual"] = "CP1_TW_RESOURCES_SPIRITUAL",
	},

	spiritual_path_key = "wh3_cp1_cth_court_spiritual",
	military_path_key = "wh3_cp1_cth_court_military",
	path_pooled_resources_list_key = "tiger_court_path_list",
	ritual_for_path_key_prefix = "tiger_court_ritual_for_path:",
	initiative_set_for_path_key_prefix = "tiger_court_initiative_set_for_path:",
	path_upgrade_key_prefix = "tiger_court_ritual_category_for_upgrades:",
	court_unlocked_key = "tiger_court_unlocked",
	required_relics_gained_to_unlock_campaign_var_key = "ui_tiger_court_required_relics_gained_to_unlock",
	path_for_default_selection_key = "tiger_court_path_for_default_selection",
	ritual_no_retreat_duration = 2,
	ritual_no_retreat = {},
	relics_vfx_key = "scripted_effect29",
	relics_vfx_id_suffix = "_relic_decal",


	marked_for_pray_bonus_value = "marked_for_prey_duration",
	marked_for_pray_character_bundle = "wh3_cp1_bundle_cth_marked_prey",

	bashiva_bonus_value = "tiger_warrior_reinforcement",
	-- building levels start from 0
	reinforcement_armies = {
		[1] = {
			"wh3_cp1_cth_inf_tiger_warriors_dual_axe",
			"wh3_cp1_cth_inf_stalkers_throwing_disc",
		},
		[2] = {
			"wh3_cp1_cth_inf_tiger_warriors_dual_axe",
			"wh3_cp1_cth_inf_stalkers_throwing_disc",
			"wh3_cp1_cth_inf_tiger_warriors_dual_axe",
		},
		[3] = {
			"wh3_cp1_cth_inf_tiger_warriors_dual_axe",
			"wh3_cp1_cth_inf_stalkers_throwing_disc",
			"wh3_cp1_cth_inf_tiger_warriors_dual_axe",
			"wh3_cp1_cth_inf_tiger_warriors_dual_axe",
		},
		[4] = {
			"wh3_cp1_cth_inf_tiger_warriors_dual_axe",
			"wh3_cp1_cth_inf_stalkers_throwing_disc",
			"wh3_cp1_cth_inf_stalkers_throwing_disc",
		},
		[5] = {
			"wh3_cp1_cth_inf_tiger_warriors_dual_axe",
			"wh3_cp1_cth_inf_stalkers_throwing_disc",
			"wh3_cp1_cth_inf_stalkers_throwing_disc",
			"wh3_cp1_cth_inf_stalkers_throwing_disc",
		},
	},

	reinforcement_building_chain_key = "wh3_cp1_cth_tiger_court_white_tiger",
}

tiger_court = {}
tiger_court.config = tiger_court_config
tiger_court.dynamic_data = {}

function tiger_court:initialise()
	-- if is_empty_table(self.dynamic_data) then
	-- end
	if cm:is_new_game() then
		local faction = cm:get_faction(self.config.faction_key)
		cm:set_script_state(faction, self.config.court_unlocked_key, false)
		cm:set_script_state(faction, self.config.path_for_default_selection_key, self.config.path_pooled_resources[2])
	end
	

	tiger_court:initialise_shared_states()
	tiger_court:add_ritual_listeners()
	tiger_court:add_pooled_resource_listeners()
	tiger_court:add_battle_listeners()
	tiger_court:refresh_relics_vfx()
end

function tiger_court:initialise_shared_states()
	local faction = cm:get_faction(self.config.faction_key)

	-- paths
	local path_list = ""
	for i = 1, #self.config.path_pooled_resources do
		local pr_key = self.config.path_pooled_resources[i]
		path_list = path_list .. pr_key .. ";"
	end
	cm:set_script_state(faction, self.config.path_pooled_resources_list_key, path_list)

	-- rituals for paths
	for path, ritual in dpairs(self.config.path_to_ritual_mapping) do
		cm:set_script_state(faction, self.config.ritual_for_path_key_prefix .. path, ritual)
	end

	-- upgrades for paths
	for path, category in dpairs(self.config.path_to_ritual_chain_category_for_upgrades_mapping) do
		cm:set_script_state(faction, self.config.path_upgrade_key_prefix .. path, category)
	end

	-- initiative sets
	for path, initiative_set in dpairs(self.config.path_to_initiative_set_mapping) do
		cm:set_script_state(faction, self.config.initiative_set_for_path_key_prefix .. path, initiative_set)
	end
end

--------------------------------------------------------------
---------------------------- LISTENERS -----------------------
--------------------------------------------------------------

function tiger_court:add_ritual_listeners()
	core:add_listener(
		"tiger_court_handle_settlement_ritual",
		"RitualCompletedEvent",
		function(context)
			local faction = context:performing_faction()
			if is_nil(faction) or faction:is_null_interface() then
				return false
			end
			
			if faction:name() ~= self.config.faction_key then
				return false
			end

			return true
		end,
		function(context)
			local ritual = context:ritual()
			local ritual_key = ritual:ritual_key()
			if ritual_key == self.config.path_to_ritual_mapping[self.config.military_path_key] then
				local mf = context:ritual():ritual_target():get_target_force()
				if not mf then 
					return
				end
				
				local current_ritual = {
					duration = self.config.ritual_no_retreat_duration,
					mf_cqi = mf:command_queue_index(),
				}
				table.insert(self.config.ritual_no_retreat, current_ritual)
				cm:set_force_has_retreated_this_turn(mf)
			end
		end,
		true
	)

	core:add_listener(
		"tiger_court_kamau_ritual_no_retreat_force_destroyed",
		"MilitaryForceDestroyed",
		function(context)
			return #self.config.ritual_no_retreat > 0
		end,
		function(context)
			local destroyed_force = context:military_force()
			local destroyed_force_cqi = destroyed_force:command_queue_index()
			for i, item in dpairs(self.config.ritual_no_retreat) do
				if destroyed_force_cqi == item.mf_cqi then
					table.remove(self.config.ritual_no_retreat, i);
				end
			end
		end,
		true
	)

	core:add_listener(
		"tiger_court_kamau_update_ritual_no_retreat",
		"FactionTurnStart",
		function(context)
			if #self.config.ritual_no_retreat > 0 then
				if context:faction():name() == self.config.faction_key then 
					for i, item in dpairs(self.config.ritual_no_retreat) do
						local mf = cm:get_military_force_by_cqi(item.mf_cqi)
						if mf and item.duration > 0 then
							return true
						elseif not mf then 
							table.remove(self.config.ritual_no_retreat, i);
						end
					end
				end
			else
				return false
			end
		end,
		function(context)
			local mf
			for i, item in dpairs(self.config.ritual_no_retreat) do
				mf = cm:get_military_force_by_cqi(item.mf_cqi)
				item.duration = item.duration - 1
				if mf and not mf:is_null_interface() then
					cm:set_force_has_retreated_this_turn(mf)
				end

				if item.duration <= 0 then 
					table.remove(self.config.ritual_no_retreat, i);
				end
			end
		end,
		true
	)

	core:add_listener(
		"tiger_court_handle_pillar_devotion",
		"RitualCompletedEvent",
		function(context)
			local faction = context:performing_faction()
			if is_nil(faction) or faction:is_null_interface() then
				return false
			end
			
			if faction:name() ~= self.config.faction_key then
				return false
			end

			local ritual = context:ritual()

			if ritual:is_part_of_chain() == false then
				return false
			end

			local ritual_category = ritual:ritual_category()

			for path, category in dpairs(self.config.path_to_ritual_chain_category_for_upgrades_mapping) do
				if ritual_category == category then
					return true
				end
			end

			return false
		end,
		function(context)
			local faction = context:performing_faction()
			local ritual = context:ritual()
			local ritual_category = ritual:ritual_category()
			for path, category in dpairs(self.config.path_to_ritual_chain_category_for_upgrades_mapping) do
				if ritual_category == category then
					cm:set_script_state(faction, self.config.path_for_default_selection_key, path)
					return
				end
			end
		end,
		true
	)
end

function tiger_court:add_pooled_resource_listeners()
	core:add_listener(
		"tiger_court_feature_unlock_listener",
		"PooledResourceChanged",
		function(context)
			return context:resource():key() == self.config.pooled_resource and context:faction():is_human()
		end,
		function(context)
			local value = context:resource():value()
			local required_relics = cm:campaign_var_int_value(self.config.required_relics_gained_to_unlock_campaign_var_key)
			local unlocked = cm:model():shared_states_manager():get_state_as_bool_value(context:faction(), self.config.court_unlocked_key)
			if not unlocked and value >= required_relics then
				cm:set_script_state(context:faction(), self.config.court_unlocked_key, true)
			end
		end,
		true
	)

	core:add_listener(
		"tiger_court_feature_relics_vfx_listener",
		"PooledResourceChanged",
		function(context)
			local bhashiva_faction = cm:get_faction(self.config.faction_key)
			-- only add relic vfx's when the player is playing bhashiva
			local is_player_bhashiva = is_faction(bhashiva_faction) and bhashiva_faction:is_human()
			return is_player_bhashiva and context:resource():key() == self.config.pooled_resource_settlements
		end,
		function(context)
			local value = context:resource():value()
			local region = context:resource():manager():region()
			if is_null(region) or region:is_null_interface() then 
				return
			end

			if value > 0 then 
				cm:add_garrison_residence_vfx(region:cqi(), self.config.relics_vfx_key, false)
			elseif value <= 0 then 
				cm:remove_garrison_residence_vfx(region:cqi(), self.config.relics_vfx_key)
			end
		end,
		true
	)
end

function tiger_court:add_battle_listeners()
	core:add_listener(
		"tiger_court_CharacterCompletedBattle",
		"BattleCompleted",
		function(context)
			return tiger_court and tiger_court.dynamic_data and is_number(tiger_court.dynamic_data.reinforcing_character_cqi)
		end,
		function(context)
			cm:kill_character_and_commanded_unit(cm:char_lookup_str(tiger_court.dynamic_data.reinforcing_character_cqi), true, true)
			tiger_court.dynamic_data.reinforcing_character_cqi = nil
		end,
		true
	)

	core:add_listener(
		"tiger_court_reinforcements_PendingBattleAboutToBeCreated",
		"PendingBattleAboutToBeCreated",
		function(context)
			local target_garrison = context:target_garrison_residence()
			if target_garrison and not target_garrison:is_null_interface() then
				-- garrison battles do not get reinforces
				return false
			end

			local acting_character = context:character()
			if (not acting_character) or acting_character:is_null_interface() then
				return false
			end

			local target_character = context:target_character()
			if (not target_character) or target_character:is_null_interface() then
				return false
			end

			local attacker_faction_key = acting_character:faction():name()
			local target_faction_key = target_character:faction():name()
			
			if tiger_court_config.faction_key ~= attacker_faction_key and attacker_faction_key ~= target_faction_key then
				return false
			end

			local region_obj = target_character:region()
			if (not region_obj) or region_obj:is_null_interface() then
				return false
			end

			local owning_faction = region_obj:owning_faction()
			if (not owning_faction) or owning_faction:is_null_interface() then
				return false
			end

			if tiger_court_config.faction_key ~= owning_faction:name()then
				return false
			end

			return true
		end,
		function(context)
			local target_character = context:target_character()
			local region_obj = target_character:region()
			local settlement_obj = region_obj:settlement()
			local reinforcement_units = {}

			local total_reinforcement_level = 0

			local region_value = cm:get_regions_bonus_value(region_obj, tiger_court_config.bashiva_bonus_value)
			if is_number(region_value) then
				total_reinforcement_level = total_reinforcement_level + region_value
			end
			local province_value = cm:get_provinces_bonus_value(region_obj:faction_province(), tiger_court_config.bashiva_bonus_value)
			if is_number(province_value) then
				total_reinforcement_level = total_reinforcement_level + province_value
			end
			if total_reinforcement_level > 0 then
				local max_reinforcement_levels = #tiger_court_config.reinforcement_armies
				if total_reinforcement_level < max_reinforcement_levels then
					reinforcement_units = tiger_court_config.reinforcement_armies[total_reinforcement_level]
				else
					-- if we are over the last level, we take the last level
					reinforcement_units = tiger_court_config.reinforcement_armies[max_reinforcement_levels]
				end
			end

			if (not is_table(reinforcement_units)) or #reinforcement_units == 0 then
				return
			end
			local reinforcement_units_string = table.concat(reinforcement_units, ",")
			local target_force_general_cqi = target_character:command_queue_index()
			local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_character(tiger_court_config.faction_key,"character_cqi:"..target_force_general_cqi,true, 4)

			if pos_x > -1 then
				cm:create_force(
						tiger_court_config.faction_key,
						reinforcement_units_string,
						region_obj:name(),
						pos_x,
						pos_y,
						true,
						function(char_cqi, force_cqi)
							-- save the force so we can delete it later
							tiger_court.dynamic_data.reinforcing_character_cqi = char_cqi
						end
					);

			end
		end,
		true
	)
end

core:add_listener(
	"tiger_court_WorldStartTurn",
	"FactionTurnStart",
	true,
	function(context)
		local faction_starting_turn = context:faction()
		local bashiva_faction = cm:get_faction(tiger_court.config.faction_key)
		if (not faction_starting_turn)
			or faction_starting_turn:is_null_interface() 
			or (not bashiva_faction) 
			or bashiva_faction:is_null_interface() 
			or bashiva_faction:is_dead()
			or (not bashiva_faction:is_human())
			or (bashiva_faction:name() == faction_starting_turn:name())
		then
			return
		end
		-- we get the duration from the effect
		local duration = cm:get_factions_bonus_value(bashiva_faction, tiger_court_config.marked_for_pray_bonus_value)
		if duration <= 0 then
			return
		end

		local faction_regions = bashiva_faction:region_list();
		for i = 0, faction_regions:num_items() - 1 do
			local region = faction_regions:item_at(i)
			local region_chars = region:characters_in_region()
			for j = 0, region_chars:num_items() - 1 do
				local character_obj = region_chars:item_at(j)
				local char_faction = character_obj:faction()

				if char_faction:name() == faction_starting_turn:name() 
					and (not char_faction:is_ally_vassal_or_client_state_of(bashiva_faction))
					and (not bashiva_faction:is_ally_vassal_or_client_state_of(char_faction))
					and (character_obj:has_military_force())
				then
					local char_lookup_str = cm:char_lookup_str(character_obj)
					cm:make_character_seen_in_shroud(char_lookup_str, tiger_court.config.faction_key, duration)
					cm:remove_effect_bundle_from_force(tiger_court.config.marked_for_pray_character_bundle, character_obj:military_force():command_queue_index())
					cm:apply_effect_bundle_to_force(tiger_court.config.marked_for_pray_character_bundle, character_obj:military_force():command_queue_index(), duration + 1)
				end
			end
		end
	end,
	true
)

function tiger_court:refresh_relics_vfx()
	local is_player_bhashiva = cm:get_local_faction_name(true) == self.config.faction_key
	if not is_player_bhashiva then
		return
	end

	local relics_regions = {
		regions_with_relics_group_starting = bhashiva_campaign_config.regions_with_relics_group_starting,
		regions_with_relics_group_mountains = bhashiva_campaign_config.regions_with_relics_group_mountains,
		regions_with_relics_group_ivory_roads = bhashiva_campaign_config.regions_with_relics_group_ivory_roads,
	}

	for _, region_set in pairs(relics_regions) do
		local region_list_si = cm:model():world():lookup_regions_from_region_group(region_set)
		if is_regionlist(region_list_si) then
			for i = 0, region_list_si:num_items() - 1 do
				local region = region_list_si:item_at(i)
				local relics_value = bhashiva_campaign:get_relics_resource_value_for_region(region)
				if relics_value then
					if relics_value > 0 then 
						cm:add_garrison_residence_vfx(region:cqi(), self.config.relics_vfx_key, false)
					else
						cm:remove_garrison_residence_vfx(region:cqi(), self.config.relics_vfx_key)
					end
				end
			end
		end
	end
end

--------------------------------------------------------------
---------------------------- UTIL ----------------------------
--------------------------------------------------------------

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("TigerCourtDynamicData", tiger_court.dynamic_data, context)
	end
)
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			tiger_court.dynamic_data = cm:load_named_value("TigerCourtDynamicData", tiger_court.dynamic_data, context)
		end
	end
)