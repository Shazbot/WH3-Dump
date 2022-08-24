endgame_vampires_rise = {
	army_template = {
		vampires = true
	},
	base_army_count = 4, -- Number of armies that spawn in each vampire homeland when the event fires.
	unit_count = 19,
	early_warning_event = "wh3_main_ie_incident_endgame_vampires_rise_early_warning",
	ai_personality = "wh3_combi_vampire_endgame"
}

function endgame_vampires_rise:trigger()
	cm:activate_music_trigger("ScriptedEvent_Negative", "wh_main_sc_vmp_vampire_counts")
	local potential_vampires = {
		wh_main_vmp_schwartzhafen = "wh3_main_combi_region_castle_drakenhof",
		wh_main_vmp_vampire_counts = "wh3_main_combi_region_ka_sabar",
		wh2_dlc11_vmp_the_barrow_legion = "wh3_main_combi_region_blackstone_post",
		wh3_main_vmp_caravan_of_blue_roses = "wh3_main_combi_region_the_haunted_forest",
		wh_main_vmp_mousillon = "wh3_main_combi_region_mousillon"
	}
	local vampire_regions = {}
	local vampire_faction = nil
	
	for faction_key, region_key in pairs(potential_vampires) do
		local faction = cm:get_faction(faction_key)
		if not faction:is_human() and not faction:was_confederated() then
			if vampire_faction == nil then
				vampire_faction = faction_key
			end
			table.insert(vampire_regions, region_key)
			endgame:create_scenario_force(faction_key, region_key, self.army_template, self.unit_count, true, math.floor(self.base_army_count*endgame.settings.difficulty_mod))
			endgame:no_peace_no_confederation_only_war(faction_key)
			cm:apply_effect_bundle("wh3_main_ie_scripted_endgame_vampires_rise", faction_key, 0)
			cm:force_change_cai_faction_personality(faction_key, self.ai_personality)
		end
	end

	local human_factions = cm:get_human_factions()
	local objectives = {
		{
			type = "CONTROL_N_REGIONS_FROM",
			conditions = {
				"total "..#vampire_regions,
			}
		}
	}
	for i = 1, #vampire_regions do 
		table.insert(objectives[1].conditions, "region "..vampire_regions[i])
	end

	local incident_key = "wh3_main_ie_incident_endgame_vampires_rise"
	for i = 1, #human_factions do
		endgame:add_victory_condition_listener(human_factions[i], incident_key, objectives)
		cm:trigger_incident_with_targets(
			cm:get_faction(human_factions[i]):command_queue_index(),
			incident_key,
			cm:get_faction(vampire_faction):command_queue_index(),
			0,
			0,
			0,
			0,
			0
		)
	end

end