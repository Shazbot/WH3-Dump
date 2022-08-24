local effect_key_base = "wh3_main_ie_faction_political_diplomacy_mod_"
local current_faction_control_levels = {}

local function get_theatre_control_bracket(value)
	for k, theatre in pairs(THEATRE_DATA.bracket_ranges) do
		if(value >= theatre.min and value <= theatre.max) then
			return k
		end
	end

	-- value didn't fall under any bracket
	return 0
end

local function create_and_apply_custom_effect_bundle(attitude_group, theatre, faction_key, new_bracket)
	local custom_effect_bundle = cm:create_new_custom_effect_bundle(THEATRE_DATA.attitude_effect_bundle_keys[theatre])
	local faction = cm:get_faction(faction_key)
	local theatre_attitude_group = attitude_group[theatre]

	for name, attitude_shift in pairs(theatre_attitude_group) do
		local effect_key = effect_key_base..name
		local current_faction_key = THEATRE_DATA.faction_keys[theatre][name]

		if(attitude_shift and current_faction_key ~= faction_key) then
			local mod = attitude_shift[1]
			local amount = attitude_shift[2]
			local effect_amount = THEATRE_DATA.attitude_shift_values[mod][new_bracket][amount]
			custom_effect_bundle:set_effect_value_by_key(effect_key, effect_amount)
		else
			custom_effect_bundle:remove_effect_by_key(effect_key)
		end
	end

	cm:apply_custom_effect_bundle_to_faction(custom_effect_bundle, faction)
end

local function apply_theatre_attitudes()
	core:add_listener(
		"theatre_control_bonuses",
		"PooledResourceEffectChangedEvent",
		function(context)
			local pooled_resource = context:resource():key()
			for k, v in pairs(THEATRE_DATA.pooled_resource_keys) do
				if (v == pooled_resource) then
					return true
				end
			end
	
			return false
		end,
		function(context)
			local faction = context:faction()
			local faction_key = faction:name()
			local attitude_group = THEATRE_DATA.attitudes[faction_key]
	
			if(attitude_group == nil) then
				-- faction didn't have an exemption group, default to their culture.
				local culture_key = faction:culture()
				attitude_group = THEATRE_DATA.attitudes[culture_key]
			end
			
			for k, theatre_name in pairs(THEATRE_DATA.names) do
				local theatre_control = faction:pooled_resource_manager():resource(THEATRE_DATA.pooled_resource_keys[theatre_name])
	
				if not (theatre_control:is_null_interface()) then
					local control_value = theatre_control:value()
					local current_faction_level = current_faction_control_levels[faction_key]
	
					if not (current_faction_level) then
						-- faction doesn't have a log for this theatre yet, create one.
						current_faction_control_levels[faction_key] = {}
					end
	
					local current_control_level = current_faction_control_levels[faction_key][theatre_name]
	
					if not (current_control_level) then
						-- theatre hasn't been logged yet for faction, create log and default it to 0
						current_faction_control_levels[faction_key][theatre_name] = 0
						current_control_level = current_faction_control_levels[faction_key][theatre_name]
					end
	
					if(control_value ~= current_control_level) then
						local current_bracket = get_theatre_control_bracket(current_control_level)
						local new_bracket = get_theatre_control_bracket(control_value)
						current_faction_control_levels[faction_key][theatre_name] = control_value
	
						if(current_bracket ~= new_bracket) then
							if(new_bracket == 0) then
								cm:remove_effect_bundle(THEATRE_DATA.attitude_effect_bundle_keys[theatre_name], faction_key)
								return true
							end
	
							create_and_apply_custom_effect_bundle(attitude_group, theatre_name, faction_key, new_bracket)
						end
					end
				else
					out.design("faction: "..faction_key.." does not have pooled resource for theatre control: "..theatre_name)
				end
			end
		end,
		true
	)
end

function add_theatre_attitudes()
    apply_theatre_attitudes()
end