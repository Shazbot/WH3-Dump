endgame_waaagh = {
	army_template = {
		greenskins = true
	},
	base_army_count = 4, -- Number of armies that spawn when the event fires.
	unit_count = 19,
	early_warning_event = "wh3_main_ie_incident_endgame_waaagh_early_warning",
	ai_personality = "wh3_combi_greenskin_endgame"
}

function endgame_waaagh:trigger()
	cm:activate_music_trigger("ScriptedEvent_Negative", "wh_main_sc_grn_greenskins")
	local potential_greenskins = {
		"wh_main_grn_greenskins",
		"wh_main_grn_orcs_of_the_bloody_hand",
		"wh2_dlc15_grn_broken_axe",
		"wh2_dlc15_grn_bonerattlaz",
		"wh_main_grn_crooked_moon"
	}
	local greenskin_factions = {}
	
	for i = 1, #potential_greenskins do
		local faction_key = potential_greenskins[i]
		local faction = cm:get_faction(faction_key)
		local region_key = nil
		if not faction:is_human() and not faction:is_dead() and not faction:was_confederated() then
			if faction:faction_leader():has_region() then
				region_key = faction:faction_leader():region():name()
			elseif faction:has_home_region() then
				region_key = faction:home_region():name()
			end
			if region_key ~= nil then
				table.insert(greenskin_factions, faction_key)
				endgame:create_scenario_force(faction_key, region_key, self.army_template, self.unit_count, true, math.floor(self.base_army_count*endgame.settings.difficulty_mod))
				cm:apply_effect_bundle("wh3_main_ie_scripted_endgame_waaagh", faction_key, 0)
				endgame:no_peace_no_confederation_only_war(faction_key)
				cm:force_change_cai_faction_personality(faction_key, self.ai_personality)
			end
		end
	end

	-- If #greenskin factions == 0 they're probably all dead, so let's revive someone in Black Crag
	if #greenskin_factions == 0 then
		table.insert(potential_greenskins, "wh_main_grn_necksnappers")
		for i = 1, #potential_greenskins do
			local faction_key = potential_greenskins[i]
			local faction = cm:get_faction(faction_key)
			if not faction:is_human() and not faction:was_confederated() then
				local region_key = "wh3_main_combi_region_black_crag"
				local region_owner = cm:get_region(region_key):owning_faction()
				table.insert(greenskin_factions, faction_key)
				endgame:create_scenario_force(faction_key, region_key, self.army_template, self.unit_count, true, math.floor(self.base_army_count*endgame.settings.difficulty_mod))
				if region_owner:is_null_interface() or (not region_owner:name() == faction_key and not region_owner:is_human()) then
					cm:transfer_region_to_faction(region_key, faction_key)
				end
				cm:apply_effect_bundle("wh3_main_ie_scripted_endgame_waaagh", faction_key, 0)
				endgame:no_peace_no_confederation_only_war(faction_key)
				cm:force_change_cai_faction_personality(faction_key, "wh3_combi_greenskin_endgame")
				break
			end
		end

	end

	local human_factions = cm:get_human_factions()
	local objectives = {
		{
			type = "DESTROY_FACTION",
			conditions = {
				"confederation_valid"
			}
		}
	}
	for i = 1, #greenskin_factions do 
		table.insert(objectives[1].conditions, "faction "..greenskin_factions[i])
	end

	local incident_key = "wh3_main_ie_incident_endgame_waaagh"
	for i = 1, #human_factions do
		endgame:add_victory_condition_listener(human_factions[i], incident_key, objectives)
		cm:trigger_incident_with_targets(
			cm:get_faction(human_factions[i]):command_queue_index(),
			incident_key,
			cm:get_faction(greenskin_factions[1]):command_queue_index(),
			0,
			0,
			0,
			0,
			0
		)
	end

end