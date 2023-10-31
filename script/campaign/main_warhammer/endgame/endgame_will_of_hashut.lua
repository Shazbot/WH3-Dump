endgame_will_of_hashut = {
	army_template = "will_of_hashut",
	base_army_count = 4, -- Number of armies that spawn at ZN when the event fires.
	random_army_spawn_count = 1, -- Number of armies spawned at portal regions. Spawns once for each region when event fires & randomly thereafter.
	region_key = "wh3_main_combi_region_zharr_naggrund",
	early_warning_event = "wh3_dlc23_ie_incident_endgame_chaos_dwarfs_hashut_early_warning",
	hashut_data = {
		faction_key = "wh3_dlc23_chd_minor_faction", --invasion faction
		incident_key = "wh3_dlc23_ie_incident_endgame_chaos_dwarfs_hashut",
		faction_bundle = "wh3_dlc23_ie_scripted_endgame_faction_chaos_dwarfs_hashut",
		region_bundle = "wh3_dlc23_ie_scripted_endgame_region_chaos_dwarfs_hashut",
		ai_personality = "wh3_combi_chaos_dwarf_endgame",
		music = "wh3_dlc23_sc_chd_chaos_dwarfs",
		unit_list = {

				--Hobgobs
			wh3_dlc23_chd_inf_hobgoblin_archers = 6,
			wh3_dlc23_chd_inf_hobgoblin_cutthroats = 6,
			wh3_dlc23_chd_inf_hobgoblin_sneaky_gits = 6,
			wh3_dlc23_chd_cav_hobgoblin_wolf_raiders_spears = 5,
			wh3_dlc23_chd_cav_hobgoblin_wolf_raiders_bows = 5,
				
				--Infantry
			wh3_dlc23_chd_inf_chaos_dwarf_warriors = 8,
			wh3_dlc23_chd_inf_chaos_dwarf_warriors_great_weapons = 6,
			wh3_dlc23_chd_inf_chaos_dwarf_blunderbusses = 5,
			wh3_dlc23_chd_inf_infernal_guard = 4,
			wh3_dlc23_chd_inf_infernal_guard_great_weapons = 4,
			wh3_dlc23_chd_inf_infernal_guard_fireglaives = 4,
			wh3_dlc23_chd_inf_infernal_ironsworn = 3,
				
				--Cav & Monsters
			wh3_dlc23_chd_cav_bull_centaurs_axe = 3,
			wh3_dlc23_chd_cav_bull_centaurs_dual_axe = 3,
			wh3_dlc23_chd_cav_bull_centaurs_greatweapons = 3,
			wh3_dlc23_chd_mon_great_taurus = 3,
			wh3_dlc23_chd_mon_bale_taurus = 2,
			wh3_dlc23_chd_mon_lammasu = 2,
			wh3_dlc23_chd_mon_kdaai_fireborn = 3,
			wh3_dlc23_chd_mon_kdaai_destroyer = 2,
				
				--Warmachines
			wh3_dlc23_chd_veh_iron_daemon_1dreadquake = 2,
		},
	}
}

endgame_will_of_hashut.portal_regions = {
	"wh3_main_combi_region_po_mei",
	"wh3_main_combi_region_gorssel",
	"wh3_main_combi_region_circle_of_destruction",
	"wh3_main_combi_region_tlaxtlan",
	"wh3_main_combi_region_antoch",
	"wh3_main_combi_region_zharr_naggrund" --including zharr naggrund
}

endgame_will_of_hashut.objective_regions = {
	"wh3_main_combi_region_zharr_naggrund",
	"wh3_dlc23_combi_region_gash_kadrak",
	"wh3_main_combi_region_the_falls_of_doom"
}


function endgame_will_of_hashut:trigger()

	local region = cm:get_region(self.region_key)
	local data = self.hashut_data
	local portal_regions = self.portal_regions
	local owning_faction = region:owning_faction()
	

	-- Check to see if AI CHD already own the region
	if not region:is_abandoned() then
		if not owning_faction:is_human() then
			if owning_faction:subculture() == "wh3_dlc23_sc_chd_chaos_dwarfs" then
				cm:force_confederation(data.faction_key, owning_faction:name())
			end
		end
	end

	-- Give the Zharr Naggrund to the invader if it isn't owned by them or a human
	if owning_faction:is_null_interface() or (owning_faction:name() ~= faction_key and owning_faction:is_human() == false) then
		cm:transfer_region_to_faction(self.region_key, data.faction_key)
	end

	--Create armies around Zharr Naggrund and at each portal exit
	endgame:create_scenario_force(data.faction_key, self.region_key, self.army_template, data.unit_list, true, math.floor(self.base_army_count*endgame.settings.difficulty_mod))
	for i = 1, #portal_regions do
		local regions = portal_regions[i]
		endgame:create_scenario_force(data.faction_key, regions, self.army_template, data.unit_list, true, 1)
	end
	
	cm:instantly_research_all_technologies(data.faction_key)
	cm:activate_music_trigger("ScriptedEvent_Negative", data.music)
	cm:apply_effect_bundle(data.faction_bundle, data.faction_key, 0)
	cm:apply_effect_bundle_to_region(data.region_bundle, self.region_key, 0)
	cm:force_change_cai_faction_personality(data.faction_key, data.ai_personality)
	
	endgame:no_peace_no_confederation_only_war(data.faction_key)
	local invasion_faction = cm:get_faction(data.faction_key)
	endgame:declare_war_on_adjacent_region_owners(invasion_faction, region)
	table.insert(endgame.revealed_regions, self.region_key)

	local human_factions = cm:get_human_factions()
	local objectives = {
		{
			type = "RAZE_OR_OWN_SETTLEMENTS",
			conditions = {}
		}
	}

	if #self.objective_regions == 0 then
		-- We somehow don't have any targets - silently exit the scenario
		return
	else
		for i = 1, #self.objective_regions do 
			table.insert(objectives[1].conditions, "region "..self.objective_regions[i])
		end
	end
	
	for i = 1, #human_factions do
		endgame:add_victory_condition_listener(human_factions[i], data.incident_key, objectives)
		cm:trigger_incident_with_targets(
			cm:get_faction(human_factions[i]):command_queue_index(),
			data.incident_key,
			0,
			0,
			0,
			0,
			cm:get_region(self.objective_regions[1]):cqi(),
			0
		)
	end
	cm:set_saved_value("endgame_will_of_hashut_saved_data", data)
	endgame_will_of_hashut:add_listeners()
end

function endgame_will_of_hashut:add_listeners()
	local data = cm:get_saved_value("endgame_will_of_hashut_saved_data")
	local portal_regions = self.portal_regions
	
	core:add_listener(
		"endgame_will_of_hashut_ultimate_victory",
		"MissionSucceeded",
		function(context)
			return context:mission():mission_record_key() == "wh_main_ultimate_victory"
		end,
		function()
			cm:remove_effect_bundle_from_region(data.region_bundle, self.region_key)
			core:remove_listener("endgame_will_of_hashut_spawn_army")
			core:remove_listener("endgame_will_of_hashut_ultimate_victory")
			core:remove_listener("endgame_will_of_hashut_force_victory")
		end,
		true
	)

	--picks a random region with a portal in it and spawns an army, if there's not too many armies already
	core:add_listener(
		"endgame_will_of_hashut_spawn_army",
		"WorldStartRound",
		function()
			return cm:turn_number() % 3 == 0 and cm:get_faction(self.hashut_data.faction_key):has_home_region()
		end,
		function()
			if cm:get_faction(self.hashut_data.faction_key):num_generals() <= 24 then
				local spawn_region = portal_regions[cm:random_number(#portal_regions)]
				endgame:create_scenario_force(self.hashut_data.faction_key, spawn_region, self.army_template, data.unit_list, false, 1)
			end
		end,
		true
	)

	cm:teleportation_network_open_node("wh3_dlc23_endgame_chd_cathay", "wh3_dlc23_teleportation_node_template_endgame_chd_cathay")
	cm:teleportation_network_open_node("wh3_dlc23_endgame_chd_cathay_darklands", "wh3_dlc23_teleportation_node_template_endgame_chd_cathay")
	cm:teleportation_network_open_node("wh3_dlc23_endgame_chd_empire", "wh3_dlc23_teleportation_node_template_endgame_chd_empire")
	cm:teleportation_network_open_node("wh3_dlc23_endgame_chd_empire_darklands", "wh3_dlc23_teleportation_node_template_endgame_chd_empire")
	cm:teleportation_network_open_node("wh3_dlc23_endgame_chd_lustria", "wh3_dlc23_teleportation_node_template_endgame_chd_lustria")
	cm:teleportation_network_open_node("wh3_dlc23_endgame_chd_lustria_darklands", "wh3_dlc23_teleportation_node_template_endgame_chd_lustria")
	cm:teleportation_network_open_node("wh3_dlc23_endgame_chd_naggaroth", "wh3_dlc23_teleportation_node_template_endgame_chd_naggaroth")
	cm:teleportation_network_open_node("wh3_dlc23_endgame_chd_naggaroth_darklands", "wh3_dlc23_teleportation_node_template_endgame_chd_naggaroth")
	cm:teleportation_network_open_node("wh3_dlc23_endgame_chd_southlands", "wh3_dlc23_teleportation_node_template_endgame_chd_southlands")
	cm:teleportation_network_open_node("wh3_dlc23_endgame_chd_southlands_darklands", "wh3_dlc23_teleportation_node_template_endgame_chd_southlands")

end

if cm:get_saved_value("endgame_will_of_hashut_saved_data") then
	endgame_will_of_hashut:add_listeners()
end