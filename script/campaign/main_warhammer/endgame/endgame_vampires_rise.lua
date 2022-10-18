endgame_vampires_rise = {
	army_template = "endgame_vampires_rise",
	unit_list = {
		wh_main_vmp_inf_skeleton_warriors_1 = 2,
		wh_main_vmp_inf_crypt_ghouls = 4,
		wh_main_vmp_inf_cairn_wraiths = 4,
		wh_main_vmp_inf_grave_guard_0 = 8,
		wh_main_vmp_inf_grave_guard_1 = 8,
		
			--Cavalry
		wh_main_vmp_cav_black_knights_3 = 2,
		wh_main_vmp_cav_hexwraiths = 1,
		wh_dlc02_vmp_cav_blood_knights_0 = 2,
		
			--Monsters
		wh_main_vmp_mon_fell_bats = 1,
		wh_main_vmp_mon_dire_wolves = 1,
		wh_main_vmp_mon_crypt_horrors = 4,
		wh_main_vmp_mon_vargheists = 4,
		wh_main_vmp_mon_varghulf = 2,
		wh_main_vmp_mon_terrorgheist = 2,
		
			--Vehicles
		wh_dlc04_vmp_veh_corpse_cart_1 = 1,
		wh_dlc04_vmp_veh_corpse_cart_2 = 1,
		wh_main_vmp_veh_black_coach = 1,
		wh_dlc04_vmp_veh_mortis_engine_0 = 1
	},
	base_army_count = 4, -- Number of armies that spawn in each vampire homeland when the event fires.
	early_warning_event = "wh3_main_ie_incident_endgame_vampires_rise_early_warning",
	ai_personality = "wh3_combi_vampire_endgame"
}

function endgame_vampires_rise:trigger()
	local potential_vampires = {
		wh_main_vmp_schwartzhafen = "wh3_main_combi_region_castle_drakenhof",
		wh_main_vmp_vampire_counts = "wh3_main_combi_region_ka_sabar",
		wh2_dlc11_vmp_the_barrow_legion = "wh3_main_combi_region_blackstone_post",
		wh3_main_vmp_caravan_of_blue_roses = "wh3_main_combi_region_the_haunted_forest",
		wh_main_vmp_mousillon = "wh3_main_combi_region_mousillon"
	}
	local vampire_factions = {}
	
	for faction_key, region_key in pairs(potential_vampires) do
		local faction = cm:get_faction(faction_key)
		if not faction:is_human() and not faction:was_confederated() then
			table.insert(vampire_factions, faction_key)
			endgame:create_scenario_force(faction_key, region_key, self.army_template, self.unit_list, true, math.floor(self.base_army_count*endgame.settings.difficulty_mod))
			endgame:no_peace_no_confederation_only_war(faction_key)
			cm:apply_effect_bundle("wh3_main_ie_scripted_endgame_vampires_rise", faction_key, 0)
			cm:force_change_cai_faction_personality(faction_key, self.ai_personality)
			local region = cm:get_region(region_key)
			endgame:declare_war_on_adjacent_region_owners(faction, region)
			table.insert(endgame.revealed_regions, region_key)
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

	if #vampire_factions == 0 then
		-- We somehow don't have any targets - silently exit the scenario
		return
	end
	
	cm:activate_music_trigger("ScriptedEvent_Negative", "wh_main_sc_vmp_vampire_counts")
	
	for i = 1, #vampire_factions do 
		table.insert(objectives[1].conditions, "faction "..vampire_factions[i])
	end

	local incident_key = "wh3_main_ie_incident_endgame_vampires_rise"
	for i = 1, #human_factions do
		endgame:add_victory_condition_listener(human_factions[i], incident_key, objectives)
		cm:trigger_incident_with_targets(
			cm:get_faction(human_factions[i]):command_queue_index(),
			incident_key,
			cm:get_faction(vampire_factions[1]):command_queue_index(),
			0,
			0,
			0,
			0,
			0
		)
	end
end