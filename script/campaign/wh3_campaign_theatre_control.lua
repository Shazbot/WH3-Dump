local caps_declared = false
local theatre_region_counts = {}
local current_faction_control_levels = {}
local theatre_factor_key = "wh3_main_ie_adjust_theatre_control"

local function calculate_percentage_x_of_y(x, y)
	local result = (x / y) * 100
	return math.floor(result + 0.5)
end

local function diff_between_x_and_y(x, y)
	local result = x - y
	return result
end

local function update_theatre_control(faction)
	local faction_regions = faction:region_list()
	local regions_owned_per_theatre = {}

	if (#theatre_region_counts == 0) then
		for theatre_name, region_table in pairs(THEATRE_DATA.region_keys) do
			theatre_region_counts[theatre_name] = #region_table
		end
	end

	for _, theatre_name in pairs(THEATRE_DATA.names) do
		regions_owned_per_theatre[theatre_name] = 0
	end

	for theatre_name, region_list in pairs(THEATRE_DATA.region_keys) do
		local theatre_control = faction:pooled_resource_manager():resource(THEATRE_DATA.pooled_resource_keys[theatre_name])

		if(theatre_control:is_null_interface() == false) then
			for _, region_key in pairs(region_list) do
				for i = 0, faction_regions:num_items() - 1 do
					local faction_region_key = faction_regions:item_at(i):name()
					if(region_key == faction_region_key) then
						regions_owned_per_theatre[theatre_name] = regions_owned_per_theatre[theatre_name] + 1
					end
				end
			end

			local new_percentage = calculate_percentage_x_of_y(regions_owned_per_theatre[theatre_name], theatre_region_counts[theatre_name])
			local current_percentage = theatre_control:value()

			if(new_percentage ~= current_percentage) then
				local diff = diff_between_x_and_y(new_percentage, current_percentage)
				local faction_key = faction:name()
				cm:faction_add_pooled_resource(faction_key, THEATRE_DATA.pooled_resource_keys[theatre_name], theatre_factor_key, diff)
			end
		end
	end
end
--[[  this file will most likely be deleteddown the line, just keeping it here in-case we want to steal any of the script for points victory
core:add_listener(
	"theatre_control_turn_start",
	"FactionTurnStart",
	true,
	function(context)
		-- we delay a second to allow for things like abandon region to take effect first.
		local seconds_delay = 1
		local faction_key = context:faction():name()
		cm:callback(function()
			local faction = cm:get_faction(faction_key)
			if(faction) then
				update_theatre_control(faction)
			else
				
			end
		end, seconds_delay)
	end,
	true
)

core:add_listener(
	"theatre_control_occupied_event",
	"GarrisonOccupiedEvent",
	true,
	function(context)
		local faction = context:character():faction()
		if(faction:is_null_interface() == false) then
			update_theatre_control(faction)
		else
			
		end
	end,
	true
)
]]

--[[ Add this back in once we have a way to easily find allies/vassals

core:add_listener(
	"theatre_control_abandon",
	"PositiveDiplomaticEvent",
	function(context)
		if(context:is_vassalage() == true or context:is_alliance() == true) then
			return true
		end

		return false
	end,
	function(context)
		local faction = context:abandoning_faction()
		update_theatre_control(faction)
	end,
	true
)

core:add_listener(
	"theatre_control_abandon",
	"NegativeDiplomaticEvent",
	function(context)
		if(context:was_alliance() == true or context:was_vassalage() == true) then
			return true
		end
		
		return false
	end,
	function(context)
		local faction = context:abandoning_faction()
		update_theatre_control(faction)
	end,
	true
)

]]