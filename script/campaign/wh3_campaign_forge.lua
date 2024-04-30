
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	THE FORGE
--	This script locks and unlocks the Forge panel for Dwarfs
--	Unlocking the panel when you earn enough Oathgold to afford the lowest costing ritual
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

---------------------------------------------------
---------------------- Data -----------------------
---------------------------------------------------

ancillary_item_forge = {
	disable_forge_key = "disable_dwarf_forge_button",
	oathgold_pr_key = "dwf_oathgold",
	oathgold_required_to_unlock = 200,
	lock_faction_sets = {
		"anc_set_exclusive_dwarfs"
	},
	forge_unlocked_incident = "wh3_dlc25_dwf_forge_feature_unlocked"
}

---------------------------------------------------
------------------- Functions ---------------------
---------------------------------------------------

function ancillary_item_forge:initialise()
	if cm:is_new_game() then
		local model = cm:model():world()
		for _,v in ipairs(self.lock_faction_sets) do
			lock_factions = model:lookup_factions_from_faction_set(v)
			for _, faction in model_pairs(lock_factions) do
				if not faction:is_null_interface() then
					if faction:is_human() then
						-- lock the Forge button
						cm:override_ui(self.disable_forge_key, true)
						break
					end
				end
			end
		end
	end

	core:add_listener(
		"The_Forge_PooledResourceChanged",
		"PooledResourceChanged",
		function(context)
			local faction = context:faction()
			if not faction:is_null_interface() then
				for _,v in ipairs(self.lock_faction_sets) do
					if faction:is_contained_in_faction_set(v) and faction:is_human() then
						local pr = context:resource()
						return pr:key() == self.oathgold_pr_key and pr:value() >= self.oathgold_required_to_unlock
					end
				end
			end
			return false
		end,
		function(context)
			local local_faction_cqi = cm:get_local_faction(true):command_queue_index()
			if local_faction_cqi == context:faction():command_queue_index() then
				cm:override_ui(self.disable_forge_key, false)
			end
			cm:trigger_incident(context:faction():name(), self.forge_unlocked_incident, true, true)
		end,
		false
	)

	core:add_listener(
		"The_Forge_FactionTurnStart",
		"FactionTurnStart",
		function(context)
			local faction = context:faction()
			if not faction:is_null_interface() then
				for _,v in ipairs(self.lock_faction_sets) do
					if faction:is_contained_in_faction_set(v) and faction:is_human() then
						local pr = faction:pooled_resource_manager():resource(self.oathgold_pr_key)
						if not pr:is_null_interface() then
							return pr:value() >= self.oathgold_required_to_unlock
						end
					end
				end
			end
			return false
		end,
		function(context)
			local local_faction_cqi = cm:get_local_faction(true):command_queue_index()
			if local_faction_cqi == context:faction():command_queue_index() then
				cm:override_ui(self.disable_forge_key, false)
			end
			cm:trigger_incident(context:faction():name(), self.forge_unlocked_incident, true, true)
		end,
		false
	)
end