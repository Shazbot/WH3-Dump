endgame_pyramid_of_nagash = {
	army_template = {},
	base_army_count = 8, -- Number of armies that spawn when the event fires.
	unit_count = 19	,
	faction_key = "wh2_dlc09_tmb_the_sentinels", -- Default invasion faction
	region_key = "wh3_main_combi_region_black_pyramid_of_nagash",
	early_warning_event = "wh3_main_ie_incident_endgame_black_pyramid_early_warning",
	ai_personality_tomb_kings = "wh3_combi_tombking_endgame",
	ai_personality_vampires = "wh3_combi_vampire_endgame"
}

function endgame_pyramid_of_nagash:trigger()

	local region = cm:get_region(self.region_key)
	local owning_faction

	-- Check to see if AI Vampires or Tomb Kings already own the region
	if not region:is_abandoned() and not region:owning_faction():is_human() then

		owning_faction = region:owning_faction()

		
		if owning_faction:subculture() == "wh2_dlc09_sc_tmb_tomb_kings" then
			self.faction_key = owning_faction:name()
			self.army_template.tomb_kings = true
		elseif owning_faction:subculture() == "wh_main_sc_vmp_vampire_counts" then
			self.faction_key = owning_faction:name()
			self.army_template.vampires = true
		else
			-- Default to Tomb Kings if neither Tomg Kings or Vampires own the region
			self.army_template.tomb_kings = true
		end

	-- If the region is abandoned or controlled by a human we use the default
	else
		self.army_template.tomb_kings = true
	end

	endgame:create_scenario_force(self.faction_key, self.region_key, self.army_template, self.unit_count, true, math.floor(self.base_army_count*endgame.settings.difficulty_mod))

	local incident_key, faction_bundle, region_bundle
	if self.army_template.vampires == true then
		cm:activate_music_trigger("ScriptedEvent_Negative", "wh_main_sc_vmp_vampire_counts")
		incident_key = "wh3_main_ie_incident_endgame_black_pyramid_vampires"
		faction_bundle = "wh3_main_ie_scripted_endgame_black_pyramid_faction_vampires"
		region_bundle = "wh3_main_ie_scripted_endgame_black_pyramid_region_vampires"
		cm:force_change_cai_faction_personality(self.faction_key, self.ai_personality_vampires)
	else
		cm:activate_music_trigger("ScriptedEvent_Negative", "wh2_dlc09_sc_tmb_tomb_kings")
		incident_key = "wh3_main_ie_incident_endgame_black_pyramid_tomb_kings"
		faction_bundle = "wh3_main_ie_scripted_endgame_black_pyramid_faction_tomb_kings"
		region_bundle = "wh3_main_ie_scripted_endgame_black_pyramid_region_tomb_kings"
		cm:force_change_cai_faction_personality(self.faction_key, self.ai_personality_tomb_kings)
	end

	cm:apply_effect_bundle(faction_bundle, self.faction_key, 0)
	cm:apply_effect_bundle_to_region(region_bundle, self.region_key, 0)
	
	endgame:no_peace_no_confederation_only_war(self.faction_key)
	local invasion_faction = cm:get_faction(self.faction_key)
	endgame:declare_war_on_adjacent_region_owners(invasion_faction, region)

	local human_factions = cm:get_human_factions()
	local objectives = {
		{
			type = "DESTROY_FACTION",
			conditions = {
				"faction "..self.faction_key,
				"confederation_valid"
			}
		},
		{
			type = "CONTROL_N_REGIONS_FROM",
			conditions = {
				"total 1",
				"region "..self.region_key
			}
		}
	}
	
	for i = 1, #human_factions do
		endgame:add_victory_condition_listener(human_factions[i], incident_key, objectives)
		cm:trigger_incident_with_targets(
			cm:get_faction(human_factions[i]):command_queue_index(),
			incident_key,
			0,
			0,
			0,
			0,
			cm:get_region(self.region_key):cqi(),
			0
		)
	end

	core:add_listener(
		"endgame_pyramid_of_nagash_ultimate_victory",
		"MissionSucceeded",
		function(context)
			return context:mission():mission_record_key() == "wh_main_ultimate_victory"
		end,
		function()
			cm:remove_effect_bundle_from_region(region_bundle, self.region_key)
			core:remove_listener("endgame_pyramid_of_nagash_spawn_army")
			core:remove_listener("endgame_pyramid_of_nagash_ultimate_victory")
		end,
		true
	)

	core:add_listener(
		"endgame_pyramid_of_nagash_spawn_army",
		"WorldStartRound",
		function()
			return cm:turn_number() % 10 and cm:get_faction(self.faction_key):has_home_region()
		end,
		function()
			endgame:create_scenario_force(self.faction_key, self.region_key, self.army_template, self.unit_count, false, 1)
		end,
		true
	)

end