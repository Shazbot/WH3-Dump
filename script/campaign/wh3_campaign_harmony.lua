harmony = {
	culture = "wh3_main_cth_cathay"
}

function harmony:initialise()
	core:add_listener(
		"harmony_settlement_captured",
		"RegionFactionChangeEvent",
		function(context)
			local old_owner = context:previous_faction()
			local new_owner = context:region():owning_faction()
			
			return (old_owner:is_human() and old_owner:culture() == self.culture) or (new_owner:is_human() and new_owner:culture() == self.culture)
		end,
		function(context)
			cm:apply_regular_reset_income(context:region():faction_province():pooled_resource_manager())
		end,
		true
	)
	
	core:add_listener(
		"harmony_building_completed",
		"BuildingCompleted",
		function(context)
			local faction = context:building():faction()
			
			return faction:is_human() and faction:culture() == self.culture
		end,
		function(context)
			cm:apply_regular_reset_income(context:building():region():faction_province():pooled_resource_manager())
		end,
		true
	)
end