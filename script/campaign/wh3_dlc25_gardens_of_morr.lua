gardens_of_morr = {
	faction_key = "wh_main_emp_wissenland",
	unlocked_incident = "wh3_dlc25_incident_gom_unlocked",
	constructed = {
		ritual = "wh3_dlc25_emp_ritual_construct_black_tower",
		incident = "wh3_dlc25_incident_gom_constructed"
	},
	destroyed_incident = "wh3_dlc25_incident_gom_destroyed",
	teleport = {
		ritual = "wh3_dlc25_emp_ritual_elspeth_teleport",
		incident = "wh3_dlc25_incident_gom_teleport"
	},
	current_regions = {}
}

function gardens_of_morr:initialise()
	self:setup_panel_unlock_incident()
	self:setup_constructed_incident()
	self:setup_destroyed_incident()
	self:elspeth_teleported()
end

function gardens_of_morr:setup_panel_unlock_incident()
	core:add_listener(
		"GOMUnlock",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == self.faction_key and cm:turn_number() == 5
		end,
		function(context)
			cm:trigger_incident(self.faction_key, self.unlocked_incident, true)	
		end,
		false
	)
end

function gardens_of_morr:setup_constructed_incident()
	core:add_listener(
		"GOMConstructed",
		"RitualCompletedEvent",
		function(context)
			return context:ritual():ritual_key() == self.constructed.ritual
		end,
		function(context)
			local ritual_region = context:ritual():ritual_target():get_target_region()
			local player_cqi = cm:get_faction(self.faction_key):command_queue_index()
			local owner_cqi = ritual_region:owning_faction():command_queue_index()

			table.insert(self.current_regions, {name = ritual_region:name(), owner_cqi = owner_cqi})

			cm:add_trespass_permission(player_cqi, owner_cqi)

			cm:trigger_incident_with_targets(player_cqi, self.constructed.incident, 0, 0, 0, 0, ritual_region:cqi(), 0)
		end,
		true
	)
end

function gardens_of_morr:setup_destroyed_incident()
	-- GOMs can be destroyed via the player being at war with the owner or another culture taking over or destroying the region.
	core:add_listener(
		"GOMDestroyedDiplo",
		"NegativeDiplomaticEvent",
		function(context)
			return context:is_war() == true and (context:proposer():name() == self.faction_key or context:recipient():name() == self.faction_key)
		end,
		function(context)
			self:launch_destroyed_incident()
		end,
		true
	)

	core:add_listener(
		"GOMDestroyedRegionChange",
		"RegionFactionChangeEvent",
		function(context)
			local region_key = context:region():name()

			for k, region in pairs(self.current_regions) do
				if region_key == region.name then
					return true
				end
			end

			return false
		end,
		function(context)
			self:launch_destroyed_incident()
		end,
		true
	)
end

function gardens_of_morr:launch_destroyed_incident()
	-- Check to see if the players foreign slot list varies from our logged foreign slot regions.
	local elspeth = cm:get_faction(self.faction_key)
	local foreign_slot_region_list = elspeth:foreign_slot_managers()
	local player_cqi = elspeth:command_queue_index()
			
	for k, region_data in ipairs(self.current_regions) do
		local region_match = false
		local region = cm:get_region(region_data.name)
		local region_owner = region:owning_faction()
		local previous_owner_cqi = region_data.owner_cqi
		local owner_cqi = region_owner:command_queue_index()
		local remove_trespass = true

		for key, region_check in ipairs(self.current_regions) do
			if k ~= key then
				local check_cqi = cm:get_region(region_check.name):owning_faction():command_queue_index()

				if check_cqi == previous_owner_cqi then
					-- this owner has more than 1 gardens of morr, don't remove trespass immune
					remove_trespass = false
				end
			end
		end

		if remove_trespass then
			cm:remove_trespass_permission(player_cqi, previous_owner_cqi)

			if region:is_abandoned() == false and region_owner:culture() == "wh_main_emp_empire" and region_owner:at_war_with(elspeth) == false then
				-- new owner is a valid gardens owner, transfer trespass immunity
				region_data.owner_cqi = owner_cqi
				cm:add_trespass_permission(player_cqi, owner_cqi)
			end
		end


		for i = 0, foreign_slot_region_list:num_items() - 1 do
			local foreign_slot = foreign_slot_region_list:item_at(i)
			local region_name = foreign_slot:region():name()
			
			if region_data.name == region_name then
				region_match = true
			end
		end

		if region_match == false then			
			-- region not found in the active foreign slot region list, remove it from our table and fire incident.
			table.remove(self.current_regions, k)

			cm:trigger_incident_with_targets(player_cqi, self.destroyed_incident, 0, 0, 0, 0, cm:get_region(region_data.name):cqi(), 0)

			return
		end
	end
end

function gardens_of_morr:elspeth_teleported()
	core:add_listener(
		"GOMTeleported",
		"RitualCompletedEvent",
		function(context)
			return context:ritual():ritual_key() == self.teleport.ritual
		end,
		function(context)
			-- slight callback delay so that the incident targets her new locaiton not her old one.
			cm:callback(function()
				local elspeth = cm:get_faction(self.faction_key):faction_leader()
				cm:zero_action_points(cm:char_lookup_str(elspeth))
				cm:trigger_incident_with_targets(cm:get_faction(self.faction_key):command_queue_index(), self.teleport.incident, 0, 0, elspeth:command_queue_index(), 0, 0, 0)
			end, 0.1)
		end,
		true
	)
end



--------------------- SAVE/LOAD ---------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("gardens_of_morr.current_regions", gardens_of_morr.current_regions, context)
	end
)
cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			gardens_of_morr.current_regions = cm:load_named_value("gardens_of_morr.current_regions", gardens_of_morr.current_regions, context)
		end
	end
)