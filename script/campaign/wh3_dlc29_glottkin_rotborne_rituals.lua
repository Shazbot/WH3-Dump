glottkin_rotborne_rituals_config = {
	faction_key = "wh3_dlc29_chs_host_of_the_triplets",
	ritual_group_upgrades = "GLOTTKIN_ROTBORNE_RITUALS_UPGRADES",
	ritual_category_key = "GLOTTKIN_ROTBORNE_RITUALS",
	garden_settlement_type_prefix = "wh3_dlc29_woc_glottkin_garden_of_nurgle",
	souls_pooled_resource_key = "wh3_dlc20_chs_souls",
	souls_rotborne_rituals_factor_key = "wh3_dlc29_woc_glottkin_rotborne_rituals",
	souls_progression_pooled_resource_key = "wh3_dlc29_glott_souls",

	ui_notification_shared_state_name = "glottkin_rituals_of_decay_notification",
	ui_notification_ritual_shared_state_suffix = "_notification",
	enable_category_cooldown_notification = false,

	show_ritual_completed_event = true,
	ritual_completed_event_title = "event_feed_strings_text_wh3_dlc29_event_feed_scripted_glottkin_ritual_completed_title",
	ritual_completed_event_primary_detail = "event_feed_strings_text_wh3_dlc29_event_feed_scripted_glottkin_ritual_completed_description",
	ritual_completed_event_secondary_detail = "event_feed_strings_text_wh3_dlc29_event_feed_scripted_glottkin_ritual_completed_secondary_detail",
	ritual_completed_event_index = 1970,

	garden_cycle_advancement_amount_basic = 1,
	garden_cycle_advancement_amount_advanced = 3,

	rituals = {
		{
			base_key = "wh3_dlc29_ritual_glottkin_xp_no_upgrade",
			cast_keys = {
				"wh3_dlc29_ritual_glottkin_xp_no_upgrade",
				"wh3_dlc29_ritual_glottkin_xp_upgrade_1",
				"wh3_dlc29_ritual_glottkin_xp_upgrade_2",
				"wh3_dlc29_ritual_glottkin_xp_upgrade_3",
			},
			upgrade_keys = {
				"wh3_dlc29_ritual_glottkin_xp_upgrade_1_dummy",
				"wh3_dlc29_ritual_glottkin_xp_upgrade_2_dummy",
				"wh3_dlc29_ritual_glottkin_xp_upgrade_3_dummy",
			},
		},
		{
			base_key = "wh3_dlc29_ritual_glottkin_gifted_unit_no_upgrade",
			cast_keys = {
				"wh3_dlc29_ritual_glottkin_gifted_unit_no_upgrade",
				"wh3_dlc29_ritual_glottkin_gifted_unit_upgrade_1",
				"wh3_dlc29_ritual_glottkin_gifted_unit_upgrade_2",
				"wh3_dlc29_ritual_glottkin_gifted_unit_upgrade_3",
			},
			upgrade_keys = {
				"wh3_dlc29_ritual_glottkin_gifted_unit_upgrade_1_dummy",
				"wh3_dlc29_ritual_glottkin_gifted_unit_upgrade_2_dummy",
				"wh3_dlc29_ritual_glottkin_gifted_unit_upgrade_3_dummy",
			},
		},
		{
			base_key = "wh3_dlc29_ritual_glottkin_rains_no_upgrade",
			cast_keys = {
				"wh3_dlc29_ritual_glottkin_rains_no_upgrade",
				"wh3_dlc29_ritual_glottkin_rains_upgrade_1",
				"wh3_dlc29_ritual_glottkin_rains_upgrade_2",
				"wh3_dlc29_ritual_glottkin_rains_upgrade_3",
			},
			upgrade_keys = {
				"wh3_dlc29_ritual_glottkin_rains_upgrade_1_dummy",
				"wh3_dlc29_ritual_glottkin_rains_upgrade_2_dummy",
				"wh3_dlc29_ritual_glottkin_rains_upgrade_3_dummy",
			},
		},
		{
			base_key = "wh3_dlc29_ritual_glottkin_transported_army_no_upgrade",
			cast_keys = {
				"wh3_dlc29_ritual_glottkin_transported_army_no_upgrade",
				"wh3_dlc29_ritual_glottkin_transported_army_upgrade_1",
				"wh3_dlc29_ritual_glottkin_transported_army_upgrade_2",
				"wh3_dlc29_ritual_glottkin_transported_army_upgrade_3",
			},
			upgrade_keys = {
				"wh3_dlc29_ritual_glottkin_transported_army_upgrade_1_dummy",
				"wh3_dlc29_ritual_glottkin_transported_army_upgrade_2_dummy",
				"wh3_dlc29_ritual_glottkin_transported_army_upgrade_3_dummy",
			},
		},
		{
			base_key = "wh3_dlc29_ritual_glottkin_garden_cycle_no_upgrade",
			cast_keys = {
				"wh3_dlc29_ritual_glottkin_garden_cycle_no_upgrade",
				"wh3_dlc29_ritual_glottkin_garden_cycle_upgrade_1",
				"wh3_dlc29_ritual_glottkin_garden_cycle_upgrade_2",
				"wh3_dlc29_ritual_glottkin_garden_cycle_upgrade_3",
			},
			upgrade_keys = {
				"wh3_dlc29_ritual_glottkin_garden_cycle_upgrade_1_dummy",
				"wh3_dlc29_ritual_glottkin_garden_cycle_upgrade_2_dummy",
				"wh3_dlc29_ritual_glottkin_garden_cycle_upgrade_3_dummy",
			},
		},
	},

	scripted_ritual_config = {
		["wh3_dlc29_ritual_glottkin_xp_no_upgrade"] = {  -- base ritual string
			no_targets_effect_bundle = "wh3_dlc29_bundle_glottkin_rotborne_ritual_xp_no_targets",
			ritual_data = {
				effect_bundle = "wh3_dlc29_ritual_glottkin_xp_upgrade_3_non_scripted_bundle",
				duration = 3
			},
			has_valid_targets = function(faction, ritual_level, ritual_data)
				if ritual_level == 0 then
					return glottkin_rotborne_rituals:has_valid_marked_lords()
				end
				return glottkin_rotborne_rituals:has_valid_marked_characters()
			end,
			callback = function(base_ritual_key, ritual_data)
				local faction = cm:get_faction(glottkin_rotborne_rituals.config.faction_key)
				local ritual_level = glottkin_rotborne_rituals:get_upgrades_count(faction, base_ritual_key)
				local marked_chars, marked_heroes
				local xp_boost = false
				
				if ritual_level == 0 then 
					marked_chars = glottkin_marks_of_nurgle:get_marked_lords()
				elseif ritual_level == 1 then 
					marked_chars = glottkin_marks_of_nurgle:get_marked_characters()
				elseif ritual_level == 2 then 
					marked_chars = glottkin_marks_of_nurgle:get_marked_characters()
				elseif ritual_level == 3 then 
					marked_chars = glottkin_marks_of_nurgle:get_marked_characters()
					xp_boost = true
				end

				for _,char in ipairs(marked_chars) do 
					local char_details = char:character_details()
					cm:add_agent_experience(cm:char_lookup_str(char), 1, true)

					if ritual_level >= 2 then 
						if char:has_military_force() then 
							local unit_list = char:military_force():unit_list()
							for i = 0, unit_list:num_items() - 1 do 
								local unit = unit_list:item_at(i)
								cm:add_experience_to_unit(unit, 1)
							end
						end
					end
				end

				-- apply the XP boost bundle if applicable
				if xp_boost then
					for i = 1, #marked_chars do 
						local hero = marked_chars[i]
						cm:apply_effect_bundle_to_characters_force(ritual_data.effect_bundle, hero:command_queue_index(), ritual_data.duration)
					end
				end
			end
		},
		["wh3_dlc29_ritual_glottkin_transported_army_no_upgrade"] = {
			no_targets_effect_bundle = "wh3_dlc29_bundle_glottkin_rotborne_ritual_transported_army_no_targets",
			ritual_data = {
				-- We used index table with corresponding army key on each index. The appropriate index is ritual_level + 1, as ritual upgrades are indexed from 0 up.
				army_keys = { 
					"wh3_dlc29_ritual_woc_glottkin_level_1",
					"wh3_dlc29_ritual_woc_glottkin_level_2",
					"wh3_dlc29_ritual_woc_glottkin_level_3",
					"wh3_dlc29_ritual_woc_glottkin_level_3",
				},
				unit_pool_keys = {
					"wh3_dlc29_glottkin_transported_army",
					"wh3_dlc29_glottkin_transported_army",
					"wh3_dlc29_glottkin_transported_army_improved",
					"wh3_dlc29_glottkin_transported_army_improved",
				},
				effect_bundle_for_transported_force = "wh3_dlc29_ritual_glottkin_transported_army_upgrade_3_replenishment",
				effect_bundle_duration = 3
			},
			has_valid_targets = function(faction, ritual_level, ritual_data)
				return glottkin_rotborne_rituals:has_valid_marked_lords()
			end,
			callback = function(base_ritual_key, ritual_data)
				local faction = cm:get_faction(glottkin_rotborne_rituals.config.faction_key)
				local ritual_level = glottkin_rotborne_rituals:get_upgrades_count(faction, base_ritual_key)
				local index = math.min(ritual_level + 1, #ritual_data.army_keys)
				local marked_lords = glottkin_marks_of_nurgle:get_marked_lords()
				local army_key = ritual_data.army_keys[index]
				local unit_pool_key = ritual_data.unit_pool_keys[index]

				if not is_string(army_key) then
					script_error("ERROR: glottkin transported army ritual has no army_key for ritual_level " .. tostring(ritual_level) .. " (index " .. tostring(index) .. ")")
					return
				end

				for _,char in ipairs(marked_lords) do
					if char:has_military_force() then 
						local marked_mf = char:military_force()
						local mf_cqi = marked_mf:command_queue_index()
						-- unit_pool_key is optional; never pass nil or C++ param extract fails
						if is_string(unit_pool_key) then
							cm:spawn_transported_force_at_military_force(mf_cqi, army_key, 0, unit_pool_key)
						else
							cm:spawn_transported_force_at_military_force(mf_cqi, army_key, 0)
						end
					end

					if ritual_level >= 3 then
						if char:has_transported_military_force() then 
							local transported_mf = char:transported_military_force()
							cm:apply_effect_bundle_to_force(ritual_data.effect_bundle_for_transported_force, transported_mf:command_queue_index(), 0)
						end
					end
				end
			end
		},
		["wh3_dlc29_ritual_glottkin_rains_no_upgrade"] = {
			no_targets_effect_bundle = "wh3_dlc29_bundle_glottkin_rotborne_ritual_rains_no_targets",
			has_valid_targets = function(faction, ritual_level, ritual_data)
				return glottkin_rotborne_rituals:has_valid_marked_characters_on_land()
			end,
			callback = function(base_ritual_key, ritual_data)
				local faction = cm:get_faction(glottkin_rotborne_rituals.config.faction_key)
				local ritual_level = glottkin_rotborne_rituals:get_upgrades_count(faction, base_ritual_key)
				local marked_chars = glottkin_marks_of_nurgle:get_marked_characters()
				
				for i = 1, #marked_chars do
					if not marked_chars[i]:is_at_sea() then
						if ritual_level < 3 then
							glottkin_nurgle_rains:trigger_rain(marked_chars[i]:region(), 1)
						else
							glottkin_nurgle_rains:trigger_rain(marked_chars[i]:region(), 2)
						end
					end
				end
			end
		},
		
		["wh3_dlc29_ritual_glottkin_gifted_unit_no_upgrade"] = {
			no_targets_effect_bundle = "wh3_dlc29_bundle_glottkin_rotborne_ritual_gifted_unit_no_targets",
			ritual_data = {
				payload_to_upgrade_mapping = {
					[0] = {
						unit_list = {
							"wh3_dlc20_chs_inf_chaos_warriors_mnur_greatweapons",
							"wh3_main_nur_inf_forsaken_0_warriors"
						},
						unit_groups = {
							["wh3_dlc20_chs_inf_chaos_warriors_mnur_greatweapons"] = "wh3_dlc20_chs_inf_chaos_warriors_mnur_greatweapons_province_pool_rotborne_ritual",
							["wh3_main_nur_inf_forsaken_0_warriors"] = "wh_main_nur_inf_forsaken_0_province_pool_rotborne_ritual",
						},
						effect_bundle = ""
					},
					[1] = {
						unit_list = {
							"wh3_dlc20_chs_inf_chaos_warriors_mnur_greatweapons",
							"wh3_main_nur_inf_forsaken_0_warriors"
						},
						unit_groups = {
							["wh3_dlc20_chs_inf_chaos_warriors_mnur_greatweapons"] = "wh3_dlc20_chs_inf_chaos_warriors_mnur_greatweapons_province_pool_rotborne_ritual",
							["wh3_main_nur_inf_forsaken_0_warriors"] = "wh_main_nur_inf_forsaken_0_province_pool_rotborne_ritual",
						},
						effect_bundle = "wh3_dlc29_ritual_glottkin_gifted_units_upgrade_1"
					},
					[2] = {
						unit_list = {
							"wh3_dlc20_chs_cav_chaos_knights_mnur",
							"wh3_main_nur_mon_spawn_of_nurgle_0_warriors",
							"wh3_dlc20_chs_inf_chosen_mnur"
						},
						unit_groups = {
							["wh3_dlc20_chs_cav_chaos_knights_mnur"] = "wh3_dlc20_chs_cav_chaos_knights_mnur_province_pool_rotborne_ritual",
							["wh3_main_nur_mon_spawn_of_nurgle_0_warriors"] = "wh3_main_nur_mon_spawn_of_nurgle_0_province_pool_rotborne_ritual",
							["wh3_dlc20_chs_inf_chosen_mnur"] = "wh3_dlc20_chs_inf_chosen_mnur_province_pool_rotborne_ritual",
						},
						effect_bundle = "wh3_dlc29_ritual_glottkin_gifted_units_upgrade_2"
					},
					[3] = {
						unit_list = {
							"wh3_dlc20_chs_cav_chaos_knights_mnur",
							"wh3_main_nur_mon_spawn_of_nurgle_0_warriors",
							"wh3_dlc20_chs_inf_chosen_mnur"
						},
						unit_groups = {
							["wh3_dlc20_chs_cav_chaos_knights_mnur"] = "wh3_dlc20_chs_cav_chaos_knights_mnur_province_pool_rotborne_ritual",
							["wh3_main_nur_mon_spawn_of_nurgle_0_warriors"] = "wh3_main_nur_mon_spawn_of_nurgle_0_province_pool_rotborne_ritual",
							["wh3_dlc20_chs_inf_chosen_mnur"] = "wh3_dlc20_chs_inf_chosen_mnur_province_pool_rotborne_ritual",
						},
						effect_bundle = "wh3_dlc29_ritual_glottkin_gifted_units_upgrade_3"
					},
				}
			},
			has_valid_targets = function(faction, ritual_level, ritual_data)
				return glottkin_rotborne_rituals:faction_has_garden_of_nurgle(faction)
			end,
			callback = function(base_ritual_key, ritual_data)
				local faction = cm:get_faction(glottkin_rotborne_rituals.config.faction_key)
				local region_list = faction:region_list()
				local ritual_level = glottkin_rotborne_rituals:get_upgrades_count(faction, base_ritual_key)
				local ritual_payload = ritual_data.payload_to_upgrade_mapping[ritual_level]

				for i = 0, region_list:num_items() - 1 do 
					local region = region_list:item_at(i)
					local settlement_type = region:settlement():settlement_type_key() 
					if string.starts_with(settlement_type, glottkin_rotborne_rituals.config.garden_settlement_type_prefix) then 
						if ritual_payload.effect_bundle then
							cm:apply_effect_bundle_to_faction_province(ritual_payload.effect_bundle, region, 10)
						end

						if ritual_payload.unit_list then
							for _, unit in ipairs(ritual_payload.unit_list) do
								glottkin_marks_of_nurgle:add_gifted_units_to_province_mercenary_pool(region, unit, 1)
							end
						end
					end
				end
			end
		},
		["wh3_dlc29_ritual_glottkin_garden_cycle_no_upgrade"] = {
			no_targets_effect_bundle = "wh3_dlc29_bundle_glottkin_rotborne_ritual_garden_cycle_no_targets",
			ritual_data = {
				payload_to_upgrade_mapping = {
					[0] = {
						chain_keys = {
							"wh3_dlc29_bch_woc_nurgle_garden_cyclical_small1",
							"wh3_dlc29_bch_woc_nurgle_garden_cyclical_small2"
						},
						cycles = 1
					},
					[1] = {
						chain_keys = {
							"wh3_dlc29_bch_woc_nurgle_garden_cyclical_small1",
							"wh3_dlc29_bch_woc_nurgle_garden_cyclical_small2",
							"wh3_dlc29_bch_woc_nurgle_garden_cyclical_big1",
							"wh3_dlc29_bch_woc_nurgle_garden_cyclical_big2",
						},
						cycles = 1,
					},
					[2] = {
						chain_keys = {
							"wh3_dlc29_bch_woc_nurgle_garden_cyclical_small1",
							"wh3_dlc29_bch_woc_nurgle_garden_cyclical_small2",
							"wh3_dlc29_bch_woc_nurgle_garden_cyclical_big1",
							"wh3_dlc29_bch_woc_nurgle_garden_cyclical_big2",
						},
						cycles = 1,
						souls_per_cycle = 25
					},
					[3] = {
						chain_keys = {
							"wh3_dlc29_bch_woc_nurgle_garden_cyclical_small1",
							"wh3_dlc29_bch_woc_nurgle_garden_cyclical_small2",
							"wh3_dlc29_bch_woc_nurgle_garden_cyclical_big1",
							"wh3_dlc29_bch_woc_nurgle_garden_cyclical_big2",
						},
						cycles = 2,
						souls_per_cycle = 25
					},
				},
			},
			has_valid_targets = function(faction, ritual_level, ritual_data)
				return glottkin_rotborne_rituals:faction_has_garden_cycle_target(faction, ritual_level, ritual_data)
			end,
			callback = function(base_ritual_key, ritual_data)
				local faction = cm:get_faction(glottkin_rotborne_rituals.config.faction_key)
				local region_list = faction:region_list()
				local ritual_level = glottkin_rotborne_rituals:get_upgrades_count(faction, base_ritual_key)
				local ritual_payload = ritual_data.payload_to_upgrade_mapping[ritual_level]
				local resource_transaction_multiplier = 0

				-- Find all garden regions
				for i = 0, region_list:num_items() - 1 do 
					local region = region_list:item_at(i)
					local settlement = region:settlement() 
					if string.starts_with(settlement:settlement_type_key(), glottkin_rotborne_rituals.config.garden_settlement_type_prefix) then 
						-- go through each building slot
						for j = 0, settlement:slot_list():num_items() - 1 do 
							local building = settlement:slot_list():item_at(j):building()
							if building and not building:is_null_interface() then 
								local chain = building:chain()
								-- check for match with military chain keys
								if table.find(ritual_payload.chain_keys, chain) then
									-- Player gains amount of souls * cycle rushed
									resource_transaction_multiplier = resource_transaction_multiplier + ritual_payload.cycles
										
									-- Rush for each cycle required
									for k = 1, ritual_payload.cycles do 
										cm:force_lifecycle_transition(region:name(), chain)
									end								
								end
							end
						end
					end
				end

				if ritual_payload.souls_per_cycle then
					local transaction_amount = resource_transaction_multiplier * ritual_payload.souls_per_cycle
					if transaction_amount > 0 then
						cm:faction_add_pooled_resource(
							glottkin_rotborne_rituals.config.faction_key,
							glottkin_rotborne_rituals.config.souls_pooled_resource_key,
							glottkin_rotborne_rituals.config.souls_rotborne_rituals_factor_key,
							transaction_amount
						)
					end
				end
			end
		},
	}
}

glottkin_rotborne_rituals = {} 
glottkin_rotborne_rituals.config = glottkin_rotborne_rituals_config
glottkin_rotborne_rituals.currently_unlocked_rituals = {
	-- This table is used for the UI ritual notifications
	--[[
	{
		key = "rotborne_ritual_key_1",
		is_available = false,
	},
	--]]
}


 ---------------------------------------
 --------- UTIL Functions --------------
 ---------------------------------------

function glottkin_rotborne_rituals:get_base_ritual_key(ritual_key) 
	local ritual_data = self:get_ritual_data_by_key(ritual_key) 
	return ritual_data.base_key
end

function glottkin_rotborne_rituals:get_upgrades_count_shared_state_key(base_key)
	return "upgrades_count_" .. base_key
end

function glottkin_rotborne_rituals:get_has_cast_shared_state_key(base_key)
	return "has_cast_" .. base_key
end

function glottkin_rotborne_rituals:get_upgrades_count(faction, base_key)
	return cm:model():shared_states_manager():get_state_as_float_value(faction, self:get_upgrades_count_shared_state_key(base_key)) or 0
end

function glottkin_rotborne_rituals:has_cast_ritual(faction, base_key)
	return not not cm:model():shared_states_manager():get_state_as_bool_value(faction, self:get_has_cast_shared_state_key(base_key))
end

function glottkin_rotborne_rituals:get_ritual_data_by_key(ritual_key)
	for _, ritual_data in ipairs(self.config.rituals) do
		for _, cast_key in ipairs(ritual_data.cast_keys) do
			if cast_key == ritual_key then
				return ritual_data
			end
		end
		for _, upgrade_key in ipairs(ritual_data.upgrade_keys) do
			if upgrade_key == ritual_key then
				return ritual_data
			end
		end
	end
	return nil
end

function glottkin_rotborne_rituals:get_active_cast_key(ritual_data, upgrades_count)
	local cast_index = math.min(math.floor(upgrades_count) + 1, #ritual_data.cast_keys)
	return ritual_data.cast_keys[cast_index]
end

function glottkin_rotborne_rituals:sync_cast_ritual_locks(faction, ritual_data)
	if not is_faction(faction) or faction:is_dead() then
		return
	end

	local upgrades_count = self:get_upgrades_count(faction, ritual_data.base_key)
	if upgrades_count == 0 then
		return
	end

	local active_cast_key = self:get_active_cast_key(ritual_data, upgrades_count)

	for _, cast_key in ipairs(ritual_data.cast_keys) do
		if cast_key == active_cast_key then
			cm:unlock_ritual(faction, cast_key, 0)
		else
			cm:lock_ritual(faction, cast_key)
		end
	end
end

function glottkin_rotborne_rituals:sync_upgrade_dummy_locks(faction, ritual_data)
	if not is_faction(faction) or faction:is_dead() then
		return
	end

	local upgrades_count = math.floor(self:get_upgrades_count(faction, ritual_data.base_key))
	local has_cast = self:has_cast_ritual(faction, ritual_data.base_key)

	for i, upgrade_key in ipairs(ritual_data.upgrade_keys) do
		if upgrades_count >= i then
			cm:unlock_ritual(faction, upgrade_key, 0)
		elseif has_cast and upgrades_count == i - 1 then
			cm:unlock_ritual(faction, upgrade_key, 0)
		else
			cm:lock_ritual(faction, upgrade_key)
		end
	end
end

function glottkin_rotborne_rituals:sync_ritual_line(faction, ritual_data)
	self:sync_cast_ritual_locks(faction, ritual_data)
	self:sync_upgrade_dummy_locks(faction, ritual_data)
end

function glottkin_rotborne_rituals:sync_all_ritual_lines(faction)
	for _, ritual_data in ipairs(self.config.rituals) do
		self:sync_ritual_line(faction, ritual_data)
	end
end

function glottkin_rotborne_rituals:on_first_cast(faction, ritual_key)
	local ritual_data = self:get_ritual_data_by_key(ritual_key)
	if ritual_data == nil then
		return
	end

	if not self:has_cast_ritual(faction, ritual_data.base_key) then
		cm:set_script_state(faction, self:get_has_cast_shared_state_key(ritual_data.base_key), true)
		self:sync_upgrade_dummy_locks(faction, ritual_data)
	end
end

function glottkin_rotborne_rituals:cheat_unlock_upgrade_buttons()
	local faction = cm:get_faction(self.config.faction_key)
	if not is_faction(faction) or faction:is_dead() then
		return
	end

	for _, ritual_data in ipairs(self.config.rituals) do
		if not self:has_cast_ritual(faction, ritual_data.base_key) then
			cm:set_script_state(faction, self:get_has_cast_shared_state_key(ritual_data.base_key), true)
		end
		self:sync_ritual_line(faction, ritual_data)
	end
end

function glottkin_rotborne_rituals:on_upgrade_purchased(faction, upgrade_key)
	local ritual_data = self:get_ritual_data_by_key(upgrade_key)
	if ritual_data == nil then
		return
	end

	local shared_state_key = self:get_upgrades_count_shared_state_key(ritual_data.base_key)
	local upgrades_count = self:get_upgrades_count(faction, ritual_data.base_key)
	local previous_cast_key = self:get_active_cast_key(ritual_data, upgrades_count)
	upgrades_count = math.min(upgrades_count + 1, #ritual_data.upgrade_keys)
	cm:set_script_state(faction, shared_state_key, upgrades_count)

	local new_cast_key = self:get_active_cast_key(ritual_data, upgrades_count)
	self:sync_ritual_line(faction, ritual_data)
	self:transfer_cast_ritual_cooldown(faction, previous_cast_key, new_cast_key)
	self:refresh_no_target_disables(faction)

	if ritual_data.base_key == "wh3_dlc29_ritual_glottkin_rains_no_upgrade" then
		glottkin_nurgle_rains:update_bonus_duration_shared_state()
	end
end

function glottkin_rotborne_rituals:transfer_cast_ritual_cooldown(faction, previous_cast_key, new_cast_key)
	if previous_cast_key == new_cast_key then
		return
	end

	local rituals = faction:rituals()
	if rituals:is_null_interface() then
		return
	end

	local remaining_cooldown = rituals:ritual_cooldown_remaining(previous_cast_key)
	if remaining_cooldown > 0 then
		cm:apply_ritual_cooldown(faction, new_cast_key, remaining_cooldown)
	end
end

function glottkin_rotborne_rituals:faction_has_garden_of_nurgle(faction)
	local regions_list = faction:region_list()
	for i = 0, regions_list:num_items() - 1 do
		local settlement = regions_list:item_at(i):settlement()
		if string.starts_with(settlement:settlement_type_key(), self.config.garden_settlement_type_prefix) then
			return true
		end
	end
	return false
end

function glottkin_rotborne_rituals:has_valid_marked_lords()
	return #glottkin_marks_of_nurgle:get_marked_lords() > 0
end

function glottkin_rotborne_rituals:has_valid_marked_characters()
	return #glottkin_marks_of_nurgle:get_marked_characters() > 0
end

function glottkin_rotborne_rituals:has_valid_marked_characters_on_land()
	local marked_chars = glottkin_marks_of_nurgle:get_marked_characters()
	for _, char in ipairs(marked_chars) do
		if not char:is_at_sea() then
			return true
		end
	end
	return false
end

function glottkin_rotborne_rituals:faction_has_garden_cycle_target(faction, ritual_level, ritual_data)
	local ritual_payload = ritual_data.payload_to_upgrade_mapping[ritual_level]
	if not ritual_payload or not ritual_payload.chain_keys then
		return false
	end

	local regions_list = faction:region_list()
	for i = 0, regions_list:num_items() - 1 do
		local settlement = regions_list:item_at(i):settlement()
		if string.starts_with(settlement:settlement_type_key(), self.config.garden_settlement_type_prefix) then
			local slots = settlement:slot_list()
			for j = 0, slots:num_items() - 1 do
				local building = slots:item_at(j):building()
				if building and not building:is_null_interface() then
					if table.find(ritual_payload.chain_keys, building:chain()) then
						return true
					end
				end
			end
		end
	end
	return false
end

function glottkin_rotborne_rituals:refresh_no_target_disables(faction)
	if not is_faction(faction) or faction:is_dead() then
		return
	end

	for _, ritual_data in ipairs(self.config.rituals) do
		local scripted_ritual = self.config.scripted_ritual_config[ritual_data.base_key]

		if scripted_ritual and scripted_ritual.no_targets_effect_bundle and scripted_ritual.has_valid_targets then
			local ritual_level = self:get_upgrades_count(faction, ritual_data.base_key)
			local has_targets = scripted_ritual.has_valid_targets(faction, ritual_level, scripted_ritual.ritual_data)
			local bundle_key = scripted_ritual.no_targets_effect_bundle

			if has_targets and faction:has_effect_bundle(bundle_key) then
				cm:remove_effect_bundle(bundle_key, faction:name())
			elseif not has_targets and not faction:has_effect_bundle(bundle_key) then
				cm:apply_effect_bundle(bundle_key, faction:name(), 0)
			end
		end
	end
end

function glottkin_rotborne_rituals:is_ritual_available(ritual_key)
	local CcoCampaignRitual = common.get_context_value("PlayersFaction.RitualContextForKey(\"" .. ritual_key .. "\")")

	if CcoCampaignRitual then
		local is_script_locked = CcoCampaignRitual:Call("IsScriptLocked")
		return not is_script_locked
	end

	-- If the ritual is missing then it's not unlocked.
	return false
end

function glottkin_rotborne_rituals:is_rains_cast_key(ritual_key)
	return ritual_key == "wh3_dlc29_ritual_glottkin_rains_no_upgrade"
		or ritual_key == "wh3_dlc29_ritual_glottkin_rains_upgrade_1"
		or ritual_key == "wh3_dlc29_ritual_glottkin_rains_upgrade_2"
		or ritual_key == "wh3_dlc29_ritual_glottkin_rains_upgrade_3"
end

function glottkin_rotborne_rituals:is_garden_cycle_cast_key(ritual_key)
	return ritual_key == "wh3_dlc29_ritual_glottkin_garden_cycle_no_upgrade"
		or ritual_key == "wh3_dlc29_ritual_glottkin_garden_cycle_upgrade_1"
		or ritual_key == "wh3_dlc29_ritual_glottkin_garden_cycle_upgrade_2"
		or ritual_key == "wh3_dlc29_ritual_glottkin_garden_cycle_upgrade_3"
end

function glottkin_rotborne_rituals:get_rain_tier_for_cast_key(ritual_key)
	if ritual_key == "wh3_dlc29_ritual_glottkin_rains_no_upgrade"
		or ritual_key == "wh3_dlc29_ritual_glottkin_rains_upgrade_1"
		or ritual_key == "wh3_dlc29_ritual_glottkin_rains_upgrade_2" then
		return 1
	end
	return 2
end

function glottkin_rotborne_rituals:get_garden_cycle_amount_for_cast_key(ritual_key)
	if ritual_key == "wh3_dlc29_ritual_glottkin_garden_cycle_no_upgrade" then
		return self.config.garden_cycle_advancement_amount_basic
	end
	return self.config.garden_cycle_advancement_amount_advanced
end

 ---------------------------------------
 ------------ Listeners ----------------
 ---------------------------------------

function glottkin_rotborne_rituals:initialise()
	-- make sure none of this gets executed if the glottkin faction does not exist
	local faction = cm:get_faction(self.config.faction_key)
	if not is_faction(faction) then
		return
	end

	for _, ritual_data in ipairs(glottkin_rotborne_rituals_config.rituals) do
		table.insert(glottkin_rotborne_rituals.currently_unlocked_rituals, {
			key = ritual_data.base_key,
			is_available = glottkin_rotborne_rituals:is_ritual_available(ritual_data.base_key),
		})
	end

	core:add_listener(
		"rotborne_upgrades_RitualCompletedEvent",
		"RitualCompletedEvent",
		function(context)
			return context:ritual():ritual_category() == self.config.ritual_group_upgrades and context:succeeded();
		end,
		function(context)
			glottkin_rotborne_rituals:on_upgrade_purchased(context:performing_faction(), context:ritual():ritual_key())
		end,
		true
	)

	core:add_listener(
		"rotborne_dev_button_unlock_upgrades",
		"ContextTriggerEvent",
		function(context)
			return context.string == "dev_button_unlock_glottkin_ritual_upgrades"
		end,
		function(context)
			glottkin_rotborne_rituals:cheat_unlock_upgrade_buttons()
		end,
		true
	)

	core:add_listener(
		"RitualCompletedEvent_Rotborne_Rituals",
		"RitualCompletedEvent",
		function(context)
			return context:ritual():ritual_category() == glottkin_rotborne_rituals_config.ritual_category_key and context:succeeded();
		end,
		function(context)
			local ritual_key = context:ritual():ritual_key()
			local base_key = glottkin_rotborne_rituals:get_base_ritual_key(ritual_key)

			if glottkin_rotborne_rituals.config.scripted_ritual_config[base_key] then
				local scripted_ritual = glottkin_rotborne_rituals.config.scripted_ritual_config[base_key] 
				scripted_ritual.callback(base_key, scripted_ritual.ritual_data)

				if glottkin_rotborne_rituals.config.show_ritual_completed_event then
					cm:show_message_event(
						glottkin_gardens_of_nurgle_config.faction_key,
						glottkin_rotborne_rituals.config.ritual_completed_event_title,
						glottkin_rotborne_rituals.config.ritual_completed_event_primary_detail,
						glottkin_rotborne_rituals.config.ritual_completed_event_secondary_detail,
						false,
						glottkin_rotborne_rituals.config.ritual_completed_event_index
					)
				end
			end

			glottkin_rotborne_rituals:on_first_cast(context:performing_faction(), ritual_key)

--[[		This logic will be covered by the new scripted_ritual implementation. TODO: remove during refactor	
			if glottkin_rotborne_rituals:is_rains_cast_key(ritual_key) then
				glottkin_rotborne_rituals:rite_of_rains(glottkin_rotborne_rituals:get_rain_tier_for_cast_key(ritual_key))
			elseif glottkin_rotborne_rituals:is_garden_cycle_cast_key(ritual_key) then
				glottkin_rotborne_rituals:rite_of_the_fecund_garden(glottkin_rotborne_rituals:get_garden_cycle_amount_for_cast_key(ritual_key))
			end --]]
		end,
		true
	)

	core:add_listener(
		"Glottkin_Rotborne_Notification_Souls_Progression",
		"PooledResourceEffectChangedEvent",
		function(context)
			return context:resource():key() == glottkin_rotborne_rituals_config.souls_progression_pooled_resource_key
		end,
		function(context)
			for _, ritual_availability_data in ipairs(glottkin_rotborne_rituals.currently_unlocked_rituals) do
				if not ritual_availability_data.is_available then
					ritual_availability_data.is_available = glottkin_rotborne_rituals:is_ritual_available(ritual_availability_data.key)
					if ritual_availability_data.is_available then
						local rotborne_tab_button_notification = glottkin_rotborne_rituals_config.ui_notification_shared_state_name
						local rotborne_ritual_notification = ritual_availability_data.key .. glottkin_rotborne_rituals_config.ui_notification_ritual_shared_state_suffix
						cm:set_script_state(rotborne_tab_button_notification, true)
						cm:set_script_state(rotborne_ritual_notification, true)
					end
				end
			end
		end,
		true
	)

	core:add_listener(
		"Glottkin_Rotborne_Notification_Ritual_Cooldown_Over",
		"RitualCooldownOverEvent",
		function(context)
			local ritual_key = context:ritual_key()
			for _, ritual_data in ipairs(glottkin_rotborne_rituals_config.rituals) do
				for _, cast_key in ipairs(ritual_data.cast_keys) do
					if cast_key == ritual_key then
						return true
					end
				end
			end
			return false
		end,
		function(_)
            local rotborne_tab_button_notification = glottkin_rotborne_rituals_config.ui_notification_shared_state_name
			cm:set_script_state(rotborne_tab_button_notification, true)
		end,
		true
	)

	if glottkin_rotborne_rituals_config.enable_category_cooldown_notification then
		core:add_listener(
			"Glottkin_Rotborne_Notification_Ritual_Category_Cooldown_Over",
			"RitualCategoryCooldownOverEvent",
			function(context)
				return context:ritual_category_key() == glottkin_rotborne_rituals_config.ritual_category_key
			end,
			function(_)
				local rotborne_tab_button_notification = glottkin_rotborne_rituals_config.ui_notification_shared_state_name
				cm:set_script_state(rotborne_tab_button_notification, true)
			end,
			true
		)
	end

	core:add_listener(
		"Glottkin_Rotborne_NoTargets_FactionTurnStart",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == self.config.faction_key
		end,
		function(context)
			glottkin_rotborne_rituals:refresh_no_target_disables(context:faction())
		end,
		true
	)

	core:add_listener(
		"Glottkin_Rotborne_NoTargets_CharacterInitiative",
		"CharacterInitiativeActivationChangedEvent",
		function(context)
			return context:character():faction():name() == self.config.faction_key
		end,
		function(_)
			glottkin_rotborne_rituals:refresh_no_target_disables(cm:get_faction(self.config.faction_key))
		end,
		true
	)

	core:add_listener(
		"Glottkin_Rotborne_NoTargets_CharacterKilled",
		"CharacterConvalescedOrKilled",
		function(context)
			return context:character():faction():name() == self.config.faction_key
		end,
		function(_)
			glottkin_rotborne_rituals:refresh_no_target_disables(cm:get_faction(self.config.faction_key))
		end,
		true
	)

	core:add_listener(
		"Glottkin_Rotborne_NoTargets_SettlementTypeConverted",
		"SettlementTypeConvertedEvent",
		function(context)
			return context:settlement():faction():name() == self.config.faction_key
		end,
		function(_)
			glottkin_rotborne_rituals:refresh_no_target_disables(cm:get_faction(self.config.faction_key))
		end,
		true
	)

	core:add_listener(
		"Glottkin_Rotborne_NoTargets_RegionFactionChange",
		"RegionFactionChangeEvent",
		function(context)
			return context:region():owning_faction():name() == self.config.faction_key
				or (context:previous_faction() and not context:previous_faction():is_null_interface()
					and context:previous_faction():name() == self.config.faction_key)
		end,
		function(_)
			glottkin_rotborne_rituals:refresh_no_target_disables(cm:get_faction(self.config.faction_key))
		end,
		true
	)

	core:add_listener(
		"Glottkin_Rotborne_NoTargets_BuildingCompleted",
		"BuildingCompleted",
		function(context)
			return context:building():faction():name() == self.config.faction_key
		end,
		function(_)
			glottkin_rotborne_rituals:refresh_no_target_disables(cm:get_faction(self.config.faction_key))
		end,
		true
	)

	core:add_listener(
		"Glottkin_Rotborne_NoTargets_CharacterFinishedMoving",
		"CharacterFinishedMovingEvent",
		function(context)
			return context:character():faction():name() == self.config.faction_key
		end,
		function(_)
			glottkin_rotborne_rituals:refresh_no_target_disables(cm:get_faction(self.config.faction_key))
		end,
		true
	)

	glottkin_rotborne_rituals:sync_all_ritual_lines(faction)
	glottkin_rotborne_rituals:refresh_no_target_disables(faction)
end

function glottkin_rotborne_rituals:rite_of_rains(rain_tier)
	local glottkin_faction = cm:get_faction(self.config.faction_key)
	if not is_faction(glottkin_faction) or glottkin_faction:is_dead() then
		return
	end

	local glottkin_character = glottkin_faction:faction_leader()
	if glottkin_character:has_region() then
		local region = glottkin_character:region()
		local province = region:province()
		local regions_in_province = province:regions()
		for i = 0, regions_in_province:num_items() - 1 do
			local current_region = regions_in_province:item_at(i)
			glottkin_nurgle_rains:trigger_rain(current_region, rain_tier)
		end
	end

	local regions_list = glottkin_faction:region_list()
	for j = 0, regions_list:num_items() - 1 do
		local current_region = regions_list:item_at(j)
		local current_settlement = current_region:settlement()

		if string.starts_with(current_settlement:settlement_type_key(), self.config.garden_settlement_type_prefix) then
			glottkin_nurgle_rains:trigger_rain(current_region, rain_tier)
		end
	end
end

function glottkin_rotborne_rituals:rite_of_the_fecund_garden(amount_of_cycles)
	local faction = cm:get_faction(self.config.faction_key)
	if not is_faction(faction) or faction:is_dead() then
		return
	end

	local regions_list = faction:region_list()
	for i = 0, regions_list:num_items() - 1 do
		local current_region = regions_list:item_at(i)
		local current_settlement = current_region:settlement()
		local current_region_key = current_region:name()

		if string.starts_with(current_settlement:settlement_type_key(), glottkin_rotborne_rituals_config.garden_settlement_type_prefix) then
			local slot_list = current_settlement:slot_list()
			for j = 0, slot_list:num_items() - 1 do 
				local current_slot = slot_list:item_at(j)
				if current_slot:has_building() then 
					if current_slot:building():has_lifecycle() then 
						for k = 1, amount_of_cycles do
							cm:force_lifecycle_transition(current_region_key, current_slot:building():chain())
						end
					end
				end
			end
		end
	end
end

