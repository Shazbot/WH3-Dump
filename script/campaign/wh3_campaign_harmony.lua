
------------------
------HARMONY=----
------------------
harmony = {}
function harmony:initialise()
	core:add_listener(
		"harmony_character_on_map",
		"CharacterRecruited",
		function(context)
			local faction = context:character():faction();
			return faction:is_human() and faction:subculture() == "wh3_main_sc_cth_cathay"
		end,
		function(context)
			out.design("Recalc harmony - spawned");
			local faction_pooled_resource = context:character():faction():pooled_resource_manager();
			cm:apply_regular_reset_income(faction_pooled_resource);
		end,
		true
	);

	core:add_listener(
		"harmony_character_dead",
		"CharacterConvalescedOrKilled",
		function(context)
			local faction = context:character():faction();
			return faction:is_human() and faction:subculture() == "wh3_main_sc_cth_cathay"
		end,
		function(context)
			out.design("Recalc harmony - dead");
			local faction_pooled_resource = context:character():faction():pooled_resource_manager();
			cm:apply_regular_reset_income(faction_pooled_resource);
		end,
		true
	);

	core:add_listener(
		"settlement_captured",
		"RegionFactionChangeEvent",
		function(context)
			local old_owner = context:previous_faction()
			local new_owner = context:region():owning_faction()
			
			return (old_owner:is_human() and old_owner:subculture() == "wh3_main_sc_cth_cathay") or (new_owner:is_human() and new_owner:subculture() == "wh3_main_sc_cth_cathay")
		end,
		function(context)
			out.design("Recalc harmony - region change");
			local old_owner = context:previous_faction()
			local new_owner = context:region():owning_faction()
			
			cm:apply_regular_reset_income(old_owner:pooled_resource_manager())
			cm:apply_regular_reset_income(new_owner:pooled_resource_manager())
		end,
		true
	);
end