glottkin_nurgle_rains_config = {
	faction_key = "wh3_dlc29_chs_host_of_the_triplets",
	corruption_key = "wh3_main_corruption_nurgle",
	rain_vfx_type = "scripted_effect30",
	rain_vfx_id_suffix = "_rain_vfx",

	technology_rains_of_fecundity_key = "wh3_dlc29_chs_nur_glottkin_rains",
	technology_rains_of_fecundity_scripted_value_key = "wh3_dlc29_glottkin_rain_bonus_duration",
	technology_siegebreaking_corruption = "wh3_dlc29_chs_nur_glottkin_sieges",

	bonus_rain_duration_turns_shared_state_name = "glottkin_bonus_rain_duration",
	rains_ritual_base_key = "wh3_dlc29_ritual_glottkin_rains_no_upgrade",

	rain_data = {
		{
			bundle_key = "wh3_dlc29_rain_glottkin_tier_1_region",
			shared_state_name = "glottkin_nurgle_rain_tier_1_bundle_key",
			duration_campaign_variable = "nurgle_rain_tier_1_duration",
			min_corruption_per_turn_campaign_variable = "nurgle_rain_tier_1_min_corruption",
		},
		{
			bundle_key = "wh3_dlc29_rain_glottkin_tier_2_region",
			shared_state_name = "glottkin_nurgle_rain_tier_2_bundle_key",
			duration_campaign_variable = "nurgle_rain_tier_2_duration",
			min_corruption_per_turn_campaign_variable = "nurgle_rain_tier_2_min_corruption",
		},
	},
}

glottkin_nurgle_rains_persistent = {
	active_rains = {
		--[[
			target = region:cqi()
			target_name = region:name()
			rain_level = int
			turns_remaining = int
		]]
	},
	is_rains_of_fecundity_unlocked = false, 
}

glottkin_nurgle_rains = {} 
glottkin_nurgle_rains.config = glottkin_nurgle_rains_config

function glottkin_nurgle_rains:initialise()
	core:add_listener(
		"glottkin_rains_faction_start",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == glottkin_nurgle_rains_config.faction_key and cm:get_faction(glottkin_nurgle_rains_config.faction_key):is_human() and #glottkin_nurgle_rains_persistent.active_rains > 0
		end,
		function(context)
			for i = #glottkin_nurgle_rains_persistent.active_rains ,1 ,-1 do
				local current_rain = glottkin_nurgle_rains_persistent.active_rains[i]

				current_rain.turns_remaining = current_rain.turns_remaining - 1
				
				if current_rain.turns_remaining <= 0 then
					cm:remove_garrison_residence_vfx(current_rain.target, glottkin_nurgle_rains_config.rain_vfx_type)
					table.remove(glottkin_nurgle_rains_persistent.active_rains, i)
				end
			end
		end,
		true
	)

	core:add_listener(
		"glottkin_rains_technology_researched",
		"ResearchCompleted",
		function(context)
			return context:faction():name() == glottkin_nurgle_rains_config.faction_key and context:technology() == glottkin_nurgle_rains_config.technology_rains_of_fecundity_key
		end,
		function(context)
			for i = 1, #glottkin_nurgle_rains_persistent.active_rains do
				cm:make_region_visible_in_shroud(glottkin_nurgle_rains_config.faction_key, glottkin_nurgle_rains_persistent.active_rains[i].target_name)
			end
			glottkin_nurgle_rains_persistent.is_rains_of_fecundity_unlocked = true
			glottkin_nurgle_rains:update_bonus_duration_shared_state()
		end,
		true
	)

	core:add_listener(
		"glottkin_rains_region_faction_change",
		"RegionFactionChangeEvent",
		function(context)
			for i = 1, #glottkin_nurgle_rains_persistent.active_rains do
				if glottkin_nurgle_rains_persistent.active_rains[i].target == context:region():cqi() then
					return true
				end
			end
			return false
		end,
		function(context)
			local region = context:region()
			local rain_data = nil
			for i = 1, #glottkin_nurgle_rains_persistent.active_rains do
				if glottkin_nurgle_rains_persistent.active_rains[i].target == region:cqi() then
					rain_data = glottkin_nurgle_rains_persistent.active_rains[i]
					break
				end
			end
			cm:apply_effect_bundle_to_region(glottkin_nurgle_rains_config.rain_data[rain_data.rain_level].bundle_key, rain_data.target_name, rain_data.turns_remaining)
			cm:add_garrison_residence_vfx(region:cqi(), glottkin_nurgle_rains_config.rain_vfx_type, false)
		end,
		true
	)

	core:add_listener(
		"glottkin_rains_siegebreakin_technology_effect",
		"BattleCompleted",
		function(context)
			local is_glottkin_involved = cm:pending_battle_cache_faction_is_involved(glottkin_nurgle_rains_config.faction_key)
			if not is_glottkin_involved or not context:model():pending_battle():siege_battle() then
				return false
			end
			local has_tech = cm:get_faction(glottkin_nurgle_rains_config.faction_key):has_technology(glottkin_nurgle_rains_config.technology_siegebreaking_corruption)
			return has_tech
		end,
		function(context)
			local pb = context:model():pending_battle()
			local region_data = pb:region_data()
			if region_data:is_sea() then
				return
			end

			local is_attacker = cm:pending_battle_cache_faction_is_attacker(glottkin_nurgle_rains_config.faction_key)
			if is_attacker and pb:attacker_won() then
				glottkin_nurgle_rains:trigger_rain(region_data:region(), 1)
			elseif not is_attacker and pb:defender_won() then
				glottkin_nurgle_rains:trigger_rain(region_data:region(), 1)
			end
		end,
		true
	)

	for _, rain_data in ipairs(glottkin_nurgle_rains_config.rain_data) do
		cm:set_script_state(rain_data.shared_state_name, rain_data.bundle_key)
	end
end

function glottkin_nurgle_rains:get_rain_bonus_duration()
	local faction_key = glottkin_nurgle_rains_config.faction_key
	local bonus = 0

	if glottkin_nurgle_rains_persistent.is_rains_of_fecundity_unlocked == true then
		bonus = campaign_manager:get_factions_bonus_value(faction_key, glottkin_nurgle_rains_config.technology_rains_of_fecundity_scripted_value_key) or 0
 	end

	local faction = cm:get_faction(faction_key)
	if is_faction(faction) and not faction:is_dead() then
		local upgrades_count = glottkin_rotborne_rituals:get_upgrades_count(faction, self.config.rains_ritual_base_key)
		if upgrades_count > 0 then
			bonus = bonus + 1
		end
	end

	return bonus
end

function glottkin_nurgle_rains:update_bonus_duration_shared_state()
	local bonus_duration = glottkin_nurgle_rains:get_rain_bonus_duration()
	local shared_state = glottkin_nurgle_rains_config.bonus_rain_duration_turns_shared_state_name
	cm:set_script_state(shared_state, bonus_duration)
end

function glottkin_nurgle_rains:trigger_rain(region, rain_tier)
	
	if rain_tier > #glottkin_nurgle_rains_config.rain_data then 
		return
	end

	local event_data = 
	{
		region = nil,
		rain_level = nil,
	}

	-- apply level 1 rain
	local region_name = region:name()
	event_data.region = region

	event_data.rain_level = rain_tier
	local rain_duration = glottkin_nurgle_rains:get_rain_duration(rain_tier)

	-- Whatever happens Remove lvl 1 rain
	if region:has_effect_bundle(glottkin_nurgle_rains_config.rain_data[1].bundle_key) then
		cm:remove_effect_bundle_from_region(glottkin_nurgle_rains_config.rain_data[1].bundle_key, region_name)
	end 

	if rain_tier == 1 then 
		-- If already Lvl 2, return
		if region:has_effect_bundle(glottkin_nurgle_rains_config.rain_data[2].bundle_key) then
			return
		end 
	elseif rain_tier == 2 then 
		-- Remove lvl 2 rain
		if region:has_effect_bundle(glottkin_nurgle_rains_config.rain_data[rain_tier].bundle_key) then
			cm:remove_effect_bundle_from_region(glottkin_nurgle_rains_config.rain_data[rain_tier].bundle_key, region_name)
		end 
	end
	
	-- Apply rain
	local bonus_duration = glottkin_nurgle_rains:get_rain_bonus_duration()

	cm:apply_effect_bundle_to_region(glottkin_nurgle_rains_config.rain_data[rain_tier].bundle_key, region_name, rain_duration + bonus_duration)

	cm:add_garrison_residence_vfx(region:cqi(), glottkin_nurgle_rains_config.rain_vfx_type, false)

	if glottkin_nurgle_rains_persistent.is_rains_of_fecundity_unlocked == true then 
		cm:make_region_visible_in_shroud(glottkin_nurgle_rains_config.faction_key, region:name())
	end
	
	local should_update_active_rain = glottkin_nurgle_rains:is_rain_already_active(region) 
	
	if not should_update_active_rain == false then
		should_update_active_rain.rain_level = rain_tier
		should_update_active_rain.turns_remaining = rain_duration
	else
		local active_rain = {}
		active_rain.target = region:cqi()
		active_rain.target_name = region:name()
		active_rain.rain_level = rain_tier
		active_rain.turns_remaining = rain_duration
		table.insert(glottkin_nurgle_rains_persistent.active_rains, active_rain);
	end 

	core:trigger_event("ScriptEventGlottkinRainOfNurgleTriggered", event_data)
end

function glottkin_nurgle_rains:is_rain_already_active(region)
	for i = 1, #glottkin_nurgle_rains_persistent.active_rains do
		if glottkin_nurgle_rains_persistent.active_rains[i].target == region:cqi() then
			return glottkin_nurgle_rains_persistent.active_rains[i]
		end
	end
	return false
end

function glottkin_nurgle_rains:get_rain_duration(tier)
	local tier_data = glottkin_nurgle_rains_config.rain_data[tier]
	if not is_table(tier_data) then
		script_error("get_rain_duration tried to get tier '" .. tostring(tier) .. "' but no such tier found")
		return nil
	end
	local campaign_variable_name = tier_data.duration_campaign_variable
	local value = cm:campaign_var_int_value(campaign_variable_name)
	return value
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("rains_of_nurgle_persistent_data", glottkin_nurgle_rains_persistent, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			glottkin_nurgle_rains_persistent = cm:load_named_value("rains_of_nurgle_persistent_data", glottkin_nurgle_rains_persistent, context)
		end
	end
)