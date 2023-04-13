-- Enable Chaos Dwarf Major relic Quest Battles

chaos_dwarf_relics_ie = {
	faction_set_key = "chaos_dwarf_playable_factions",
	mission_keys = {
		"wh3_dlc23_chd_ancestor_relic_of_grimnir_ie",
		"wh3_dlc23_chd_ancestor_relic_of_grungni_ie",
		"wh3_dlc23_chd_ancestor_relic_of_valaya_ie",
	}
}

function chaos_dwarf_relics_ie:initialise()
	-- Enable Relic Quest Battles on short campaign victory for the Chaos Dwarfs
	core:add_listener(
		"ChaosDwarfIERelicQuestBattles",
		"MissionSucceeded",
		function(context)
			local faction = context:faction()
			return context:mission():mission_record_key() == "wh_main_short_victory" and faction:is_human() and faction:is_contained_in_faction_set(self.faction_set_key)
		end,
		function(context)
			local faction = context:faction()
			for _, v in ipairs(self.mission_keys) do
				cm:trigger_mission(faction:name(), v, true, true)
			end
		end,
		true
	)
end