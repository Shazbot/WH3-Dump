climate_change = {
	priorities = {
		-- Key of table will be the key that manages your climate change
		-- Every climate change NEEDS an entry in this table or we won't allow it to take effect
		-- Discussions can take place about what should have higher priority (use timelapse to determine who made certain changes).
		-- Never use the same priority value more than once, each priority should be unique. Higher Number = Higher Priority.

		temperate = {
			climate_key = "climate_temperate",
			priority = 8
		},
		land_of_the_dead = {
			climate_key = "climate_vampiric",
			priority = 9
		},
		vampire_corpses = {
			climate_key = "climate_vampiric",
			priority = 10
		},
		vermintide_devastation = {
			climate_key = "climate_wasteland",
			priority = 799
		},
		chaos_devastation = {
			climate_key = "climate_chaotic",
			priority = 999
		}
	},

	current_changes = {
		--[[
		<region_key> = {
			-- list of climate changes currently active on a region
			"climate_change_key_1",
			"climate_change_key_2",
			etc
		}
		]]
	}
}

function climate_change:add_climate_override(region, climate_change_key)
	if self.priorities[climate_change_key] ~= nil then
		local region_key = region:name()
		local settlement = region:settlement()
		
		local highest_priority = -1
		local highest_priority_key

		if self.current_changes[region_key] then
			for _, climate_change in ipairs(self.current_changes[region_key]) do
				if climate_change == climate_change_key then
					-- climate change already present on region, do nothing.
					return
				end
			end
		else
			self.current_changes[region_key] = {}
		end

		table.insert(self.current_changes[region_key], climate_change_key)		

		for _, climate_change in ipairs(self.current_changes[region_key]) do
			local priority = self.priorities[climate_change].priority

			if priority > highest_priority then
				highest_priority = priority
				highest_priority_key = climate_change
			end
		end

		if self.priorities[highest_priority_key] ~= nil then
			local climate = self.priorities[highest_priority_key].climate_key
			local current_climate = settlement:get_climate()

			if climate ~= current_climate then
				cm:override_settlement_climate(settlement, self.priorities[highest_priority_key].climate_key)
			end
		end
	else
		script_error("ERROR: add_climate_override called, but supplied climate_change_key cannot be found within the priorities table.");
	end
end

function climate_change:remove_climate_override(region, climate_change_key)
	local region_key = region:name()

	if self.current_changes[region_key] then
		local settlement = region:settlement()
		local current_climate = settlement:get_climate()
		local original_climate = settlement:get_original_climate()

		local table_empty = true
		local highest_priority = -1
		local highest_priority_key

		for pos, climate_change in ipairs(self.current_changes[region_key]) do
			if climate_change == climate_change_key then
				table.remove(self.current_changes[region_key], pos)
				break
			end
		end

		for _, climate_change in ipairs(self.current_changes[region_key]) do
			table_empty = false

			local priority = self.priorities[climate_change_key].priority

			if priority > highest_priority then
				highest_priority = priority
				highest_priority_key = climate_change
			end
		end

		if table_empty then
			if current_climate ~= original_climate then
				cm:reset_settlement_climate(settlement)
			end
		elseif self.priorities[highest_priority_key] ~= nil then
			local climate = self.priorities[highest_priority_key].climate_key
			local current_climate = settlement:get_climate()

			if climate ~= current_climate then
				cm:override_settlement_climate(settlement, self.priorities[highest_priority_key].climate_key)
			end
		end
	end
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("climate_change.current_changes", climate_change.current_changes, context);
	end
);
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			climate_change.current_changes = cm:load_named_value("climate_change.current_changes", climate_change.current_changes, context);
		end
	end
);
