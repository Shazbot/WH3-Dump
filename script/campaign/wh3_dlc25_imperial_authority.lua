imperial_authority = {
	pooled_resource = "emp_imperial_authority_new",
	factor = "empire_settlements_owned",
	ranges = {
		{min = 0, max = 25},
		{min = 26, max = 50},
		{min = 51, max = 75},
		{min = 76, max = 99},
		{min = 100, max = 100}
	},
	factions = {},
	empire_regions = {},
	campaign_factions = {
		["main_warhammer"] = {
			["wh_main_emp_empire"] = {settlement_culture = "wh_main_emp_empire", active = true},
			["wh_main_emp_wissenland"] = {settlement_culture = "wh_main_emp_empire", active = true},
			["wh2_dlc13_emp_golden_order"] = {settlement_culture = "wh_main_emp_empire", active = false},
			["wh2_dlc13_emp_the_huntmarshals_expedition"] = {settlement_culture = "wh_main_emp_empire", active = false},
			["wh3_main_emp_cult_of_sigmar"] = {settlement_culture = "wh_main_emp_empire", active = false}
		},
		["wh3_main_chaos"] = {
			["wh_main_emp_wissenland"] = {settlement_culture = "wh_main_emp_empire", active = true},
		}
	},
	enable_incident = {
		["wh_main_emp_empire"] = "wh3_dlc25_incident_imperial_authority_homecoming"
	},
	authority_effects = {
		-- provincial and region effect rewards per tier from 0->100 shared between all factions who have this system
		-- these numbers should match the dummy effects in DaVE
		province = {
			control = {-4, -2, 1, 2, 3},
			growth = {-20, -10, 5, 10, 20}
		},
		region = {
			income = {-10, 0, 0, 0, 10}
		}
	},
	effect_keys = {
		control = "wh3_dlc25_effect_public_order_imperial_authority",
		growth = "wh3_dlc25_effect_province_growth_imperial_authority",
		income = "wh_main_effect_economy_gdp_mod_all"
	},
	campaign_regions = {
		-- generated in initialise
		["main_warhammer"] = {},
		["wh3_main_chaos"] = {},
	},
	campaign_region_prefix = "wh3_dlc25_imperial_authority_regions_"
}

function imperial_authority:initialise()
	self.campaign_name = cm:get_campaign_name()

	if self.campaign_regions[self.campaign_name] and #self.campaign_regions[self.campaign_name] == 0 then
		local region_group = cm:model():world():lookup_regions_from_region_group(self.campaign_region_prefix..self.campaign_name)
		self.campaign_regions[self.campaign_name] = unique_table:region_list_to_unique_table(region_group):to_table()
	end

	if cm:is_new_game() then
		self.factions = self.campaign_factions[self.campaign_name]
		self.empire_regions = self.campaign_regions[self.campaign_name]

		for faction_key, faction_data in pairs(self.factions) do
			if faction_data.active then
				self:set_empire_visiblity_seen(faction_key)
			end
		end
	end

	self:set_starting_authority()

	core:add_listener(
		"ImpAuthRegionChange",
		"RegionFactionChangeEvent",
		function(context)
			local region_key = context:region():name()

			for _, empire_region_key in ipairs(self.empire_regions) do
				if(region_key == empire_region_key) then
					return true
				end
			end

			return false
		end,
		function(context) 
			local new_owner = context:region():owning_faction():name()

			for faction_key, faction_data in pairs(self.factions) do
				if faction_data.active == true then
					local authority_value = self:get_authority_value(faction_key)

					self:set_authority(faction_key, authority_value)
				elseif faction_data.active == false and new_owner == faction_key then
					local authority_value = self:get_authority_value(faction_key)
					faction_data.active = true

					cm:trigger_incident(faction_key, self.enable_incident[cm:get_faction(faction_key):culture()], true, true)
					self:set_authority(faction_key, authority_value)
				end

				self:apply_faction_effects_to_empire_regions(faction_key)
			end
		end,
		true
	)
end

function imperial_authority:roc_temp_initialise()
	self:set_authority("wh_main_emp_wissenland", -1)
end

function imperial_authority:set_empire_visiblity_seen(faction_key)
	for _, region_key in pairs(self.empire_regions) do
		cm:make_region_seen_in_shroud(faction_key, region_key);
	end
end

function imperial_authority:set_starting_authority()
	for faction_key, faction_data in pairs(self.factions) do

		-- If a faction doesn't have the feature active, we leave their pooled resource at -1 so that they don't gain any pooled resource effects
		-- The top bar UI is also hidden while the pooled resource is -1
		self:set_authority(faction_key, -1)
		
		if faction_data.active then
			self:set_authority(faction_key, self:get_authority_value(faction_key))
		end

		self:apply_faction_effects_to_empire_regions(faction_key)
	end
end

function imperial_authority:set_authority(faction_key, value)
	-- Reset value back to -1 (the min value) before adding intended value
	-- The pooled resource range is -1 to 100, so we reduce it down to -1 first with the first call
	-- The second call then adds the intended value + 1 to counter the fact that we started at -1
	cm:faction_add_pooled_resource(faction_key, self.pooled_resource, self.factor, -110)
	cm:faction_add_pooled_resource(faction_key, self.pooled_resource, self.factor, value + 1)
end

function imperial_authority:get_authority_value(faction_key)
	local correct_culture_count = 0
	local settlement_culture = self.factions[faction_key].settlement_culture

	for _, region_key in ipairs(self.empire_regions) do
		local region = cm:get_region(region_key)
		local region_culture_owner = region:owning_faction():culture()

		if region_culture_owner == settlement_culture then
			correct_culture_count = correct_culture_count + 1
		end
	end

	local authority_value = 0
	if #self.empire_regions > 0 then
		authority_value = math.floor((correct_culture_count / #self.empire_regions) * 100)
	end

	out.design("-------------------------------------------------")
	out.design("Faction: "..faction_key)
	out.design(settlement_culture.." Region Count: "..correct_culture_count)
	out.design("Region Max: "..#self.empire_regions)
	out.design("Authority percentage: "..authority_value)

	for level, range in ipairs(self.ranges) do
		if authority_value >= range.min and authority_value <= range.max then
			return authority_value, level
		end
	end

	-- If the ranges are properly defined, to fully cover the [0, 100] interval, then we should never reach this return.
	script_error("[Imperial Authority] ERROR: Authority value []" .. tostring(authority_value) .. "] does not fall in any authority range!")
	return authority_value, 1	-- Returning level 1, as this is to be used as an array index.
end

function imperial_authority:apply_faction_effects_to_empire_regions(faction_key)
	local regions = self.campaign_regions[self.campaign_name]
	local faction_data = self.campaign_factions[self.campaign_name][faction_key]
	local province_list = {}
	local province_effects = cm:create_new_custom_effect_bundle("wh3_dlc25_imperial_authority_province_effects")
	local region_effects = cm:create_new_custom_effect_bundle("wh3_dlc25_imperial_auhority_region_effects")
	local _, authority_level = self:get_authority_value(faction_key)

	province_effects:set_duration(0)
	
	for k, effects in pairs(self.authority_effects.province) do
		local faction_authority_effects = false
		if faction_data.authority_effects then
			faction_authority_effects = faction_data.authority_effects.province[k]
		end

		-- if a faction has it's own authority_effects, they overwrite the shared ones
		if faction_authority_effects then
			if faction_authority_effects[authority_level] ~= 0 then
				province_effects:add_effect(self.effect_keys[k], "region_to_province_own", faction_authority_effects[authority_level])
			end
		else
			if effects[authority_level] ~= 0 then
				province_effects:add_effect(self.effect_keys[k], "region_to_province_own", effects[authority_level])
			end
		end
	end

	region_effects:set_duration(0)

	for k, effects in pairs(self.authority_effects.region) do
		local faction_authority_effects = false
		if faction_data.authority_effects then
			faction_authority_effects = faction_data.authority_effects.region[k]
		end

		-- if a faction has it's own authority_effects, they overwrite the shared ones
		if faction_authority_effects then
			if faction_authority_effects[authority_level] ~= 0 then
				region_effects:add_effect(self.effect_keys[k], "region_to_region_own", faction_authority_effects[authority_level])
			end
		else
			if effects[authority_level] ~= 0 then
				region_effects:add_effect(self.effect_keys[k], "region_to_region_own", effects[authority_level])
			end
		end
	end

	for _, region_key in ipairs(regions) do
		local region = cm:get_region(region_key)

		if region:owning_faction():name() == faction_key then
			-- Handle province effects
			local province_name = region:province_name()
			if not province_list[province_name] then
				-- Add province name to province_list table so that we only apply the effects to each province once per faction per update.
				province_list[province_name] = true		

				cm:remove_effect_bundle_from_faction_province("wh3_dlc25_imperial_authority_province_effects", region)

				if province_effects:effects():num_items() > 0 then	
					cm:apply_custom_effect_bundle_to_faction_province(province_effects, region)
				end
			end

			cm:remove_effect_bundle_from_region("wh3_dlc25_imperial_auhority_region_effects", region_key)

			--Handle region effects
			if region_effects:effects():num_items() > 0 then
				cm:apply_custom_effect_bundle_to_region(region_effects, region)
			end
		end
	end
end


--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("imperial_authority.factions", imperial_authority.factions, context)
		cm:save_named_value("imperial_authority.empire_regions", imperial_authority.empire_regions, context)
	end
);
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			imperial_authority.factions = cm:load_named_value("imperial_authority.factions", imperial_authority.factions, context)
			imperial_authority.empire_regions = cm:load_named_value("imperial_authority.empire_regions", imperial_authority.empire_regions, context)
		end
	end
);