chaos_dwarf_labour_move = {
	prefix = "chd_labour_move_confirmed_"
}

function chaos_dwarf_labour_move:setup_listeners()
	core:add_listener(
		"TransferLabourAction",
		"ComponentLClickUp",
		function(context)
			return context.string == "button_accept_labour_changes"
		end,
		function(context)
			local faction_key = UIComponent(context.component):GetProperty("faction_id")
			local treasury_cost = UIComponent(context.component):GetProperty("treasury_cost")

			core:add_listener(
				"TransferLabourAction",
				"ComponentLClickUp",
				function(context)
					return context.string == "button_tick" or context.string == "button_cancel"
				end,
				function(context)
					if context.string == "button_tick" then 
						CampaignUI.TriggerCampaignScriptEvent(cm:get_faction(faction_key):command_queue_index(), self.prefix..treasury_cost)
					end
				end,
				false
			)
		end,
		true
	)

	core:add_listener(
		"TransferLabourActionFunctionality", 
		"UITrigger", 
		function(context)
			return string.find(context:trigger(), self.prefix)
		end, 
		function(context)
			local faction_key = cm:model():faction_for_command_queue_index(context:faction_cqi()):name()
			local treasury_cost = string.gsub(context:trigger(), self.prefix, "")
			treasury_cost = tonumber(treasury_cost)

			if faction_key and treasury_cost then
				cm:treasury_mod(faction_key, -treasury_cost)
			end
		end, 
		true
	)
end