devastation_manager = {
	persistent = 
	{
		--[[
			[region_key] = 
			{
				devastation_culture = [xyz],
				climate_change_key = [xyz],
				devastation_region_bundle = [xyz],
			}
		--]]
	},
	event_area_activation_queue = {},
	event_area_activation_queue_callback_scheduled = false,
	event_area_activation_queue_restrictions_active = false,
}

function devastation_manager:devastate_region(
		region_key, 
		devastation_culture_key,
		climate_change_key,
		region_bundle_key
	)
	if not self:can_region_be_devastated(region_key) then
		return false
	end

	local region_obj = cm:get_region(region_key)
	local event_area_key = region_obj:event_area_name()
	devastation_manager:queue_event_area_activation(event_area_key, devastation_culture_key)

	local region_list = region_obj:regions_in_same_event_area()
	if region_list and not region_list:is_null_interface() then
		for i = 0, region_list:num_items() - 1 do
			local current_region = region_list:item_at(i)
			devastation_manager:devastate_region_internal(current_region, devastation_culture_key, climate_change_key, region_bundle_key)
		end
	else
		devastation_manager:devastate_region_internal(region_obj, devastation_culture_key, climate_change_key, region_bundle_key)
	end
	return true
end

function devastation_manager:can_region_be_devastated(region_key)
	if devastation_manager:is_region_devastated(region_key) then
		-- region is already devastated
		return false
	end

	local region_obj = cm:get_region(region_key)
	if not is_region(region_obj) then
		return false
	end

	return true
end

function devastation_manager:remove_devastation(region_key)
	local devastation_table = self.persistent[region_key]
	if not is_table(devastation_table) then
		-- region is not devastated
		return false
	end

	local region_obj = cm:get_region(region_key)
	if region_obj == nil or region_obj:is_null_interface() then
		return false
	end
	local event_area_key = region_obj:event_area_name()
	cm:deactivate_campaign_map_event_area(event_area_key)

	local region_list = region_obj:regions_in_same_event_area()
	if region_list and not region_list:is_null_interface() then
		for i = 0, region_list:num_items() - 1 do
			local current_region = region_list:item_at(i)
			devastation_manager:remove_devastation_internal(current_region)
		end
	else
		devastation_manager:remove_devastation_internal(region_obj)
	end
	return true
end

function devastation_manager:is_region_devastated(region_key)
	return is_table(self.persistent[region_key])
end

function devastation_manager:get_region_devastation_culture(region_key)
	if not is_table(self.persistent[region_key]) then
		return nil
	end
	return self.persistent[region_key].devastation_culture
end


---------------------------------------------------------------------------------------------------------------
----------------------- INTERNAL FUNCTIONS, MEANT TO BE CALLED FROM INSIDE THIS FILE ONLY ---------------------
---------------------------------------------------------------------------------------------------------------
local EVENT_AREA_ACTIVATION_QUEUE_CALLBACK_NAME = "devastation_manager_event_area_activation_queue"

function devastation_manager:queue_event_area_activation(event_area_key, devastation_culture_key)
	table.insert(
		self.event_area_activation_queue,
		{
			event_area_key = event_area_key,
			devastation_culture_key = devastation_culture_key,
		}
	)

	if #self.event_area_activation_queue == 1 then
		self:set_event_area_activation_queue_restrictions(true)
	end

	self:process_event_area_activation_queue()
end

function devastation_manager:set_event_area_activation_queue_restrictions(is_active)
	if is_active then
		if self.event_area_activation_queue_restrictions_active then
			return
		end

		local uim = cm:get_campaign_ui_manager()
		uim:override("saving"):lock()
		uim:override("end_turn"):lock()
		self.event_area_activation_queue_restrictions_active = true
		cm:start_mass_activate_areas()
	else
		if not self.event_area_activation_queue_restrictions_active then
			return
		end

		local uim = cm:get_campaign_ui_manager()
		uim:override("saving"):unlock()
		uim:override("end_turn"):unlock()
		self.event_area_activation_queue_restrictions_active = false
		cm:end_mass_activate_areas()
	end
end

function devastation_manager:process_event_area_activation_queue()
	if self.event_area_activation_queue_callback_scheduled or #self.event_area_activation_queue == 0 then
		return
	end

	self.event_area_activation_queue_callback_scheduled = true

	cm:callback(
		function()
			self.event_area_activation_queue_callback_scheduled = false

			local queue_item = table.remove(self.event_area_activation_queue, 1)
			if is_table(queue_item) then
				cm:activate_campaign_map_event_area(queue_item.event_area_key, queue_item.devastation_culture_key)
			end

			if #self.event_area_activation_queue > 0 then
				self:process_event_area_activation_queue()
			else
				self:set_event_area_activation_queue_restrictions(false)
			end
		end,
		0.1,
		EVENT_AREA_ACTIVATION_QUEUE_CALLBACK_NAME
	)
end

function devastation_manager:devastate_region_internal(
	region_obj,
	devastation_culture_key,
	climate_change_key,
	region_bundle_key
)
	local region_key = region_obj:name()
	self.persistent[region_key] = {}
	self.persistent[region_key].devastation_culture = devastation_culture_key
	if is_string(climate_change_key) then
		climate_change:add_climate_override(region_obj, climate_change_key)
		self.persistent[region_key].climate_change_key = climate_change_key
	end

	if is_string(region_bundle_key) then
		cm:apply_effect_bundle_to_region(region_bundle_key, region_key, 0)
		self.persistent[region_key].devastation_region_bundle = region_bundle_key
	end

	core:trigger_custom_event("ScriptedEventRegionDevastated", {region_obj})
end

function devastation_manager:remove_devastation_internal(region_obj)
	local region_key = region_obj:name()

	-- we remove the devastation region bundle, if any
	if is_string(self.persistent[region_key].devastation_region_bundle) then
		cm:remove_effect_bundle_from_region(self.persistent[region_key].devastation_region_bundle, region_key)
	end

	-- we remove the climate override, if any
	if is_string(self.persistent[region_key].climate_change_key) then
		climate_change:remove_climate_override(region_obj, self.persistent[region_key].climate_change_key)
	end

	-- we remove the table to mark the region as no longer devastated
	self.persistent[region_key] = nil

	core:trigger_custom_event("ScriptedEventRegionDevastationRemoved", {region_obj})
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("devastation_manager", devastation_manager.persistent, context);
	end
);
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			devastation_manager.persistent = cm:load_named_value("devastation_manager", devastation_manager.persistent, context);
		end
	end
);
