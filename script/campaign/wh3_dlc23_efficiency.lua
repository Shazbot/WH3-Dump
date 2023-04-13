chaos_dwarf_efficiency = {}

function chaos_dwarf_efficiency:set_efficiency()
	local human_factions = cm:get_human_factions_of_culture("wh3_dlc23_chd_chaos_dwarfs")

	for _, faction_key in ipairs(human_factions) do
		core:add_listener(
			"reset_income_"..faction_key,
			"FactionTurnStart",
			function(context)
				return faction_key == context:faction():name()
			end,
			function(context)
				local faction = cm:get_faction(context:faction():name())
				local faction_provinces_list = faction:provinces()
				local faction_provinces_count = faction_provinces_list:num_items()

				for i = 0, faction_provinces_count - 1 do
					local province = faction_provinces_list:item_at(i)
					local resource_manager = province:pooled_resource_manager()
		
					cm:apply_regular_reset_income(resource_manager)
					cm:callback(function()
						self:update_efficiency(resource_manager)
					end, 0.5)
				end
			end,
			false
		)
	end
	
	core:add_listener(
		"chaos_dwarf_efficiency_pr_changed",
		"PooledResourceChanged",
		true,
		function(context)
			local resource_key = context:resource():key()
			if(resource_key == "wh3_dlc23_chd_labour" or resource_key == "wh3_dlc23_chd_workload") then
				self:update_efficiency(context:resource():manager())
			end
		end,
		true
	)

	core:add_listener(
		"chaos_dwarf_efficiency_regular_income",
		"PooledResourceRegularIncome",
		true,
		function(context)
			local resource_key = context:resource():key()
			if(resource_key == "wh3_dlc23_chd_labour" or resource_key == "wh3_dlc23_chd_workload") then
				self:update_efficiency(context:resource():manager())
			end
		end,
		true
	)
end

function chaos_dwarf_efficiency:update_efficiency(resource_manager)
	local labour = resource_manager:resource("wh3_dlc23_chd_labour")
	local workload = resource_manager:resource("wh3_dlc23_chd_workload")
	local efficiency = resource_manager:resource("wh3_dlc23_chd_efficiency")

	if labour:is_null_interface() == false then
		-- update workload as soon as building complete
		cm:apply_regular_reset_income(resource_manager)

		local workload_value = workload:value()

		if workload_value > 0 then
			local percentage =  100 - math.clamp((math.ceil((labour:value() / workload_value) * 100)), 0, 100)

			cm:pooled_resource_factor_transaction(efficiency, "other", -100)
			cm:pooled_resource_factor_transaction(efficiency, "other", percentage)
		end
	end
end