endgame_wild_hunt = {
	army_template = "endgame_wild_hunt",
	unit_list = {	
		--Infantry
		wh_dlc05_wef_inf_eternal_guard_0 = 8,
		wh_dlc05_wef_inf_eternal_guard_1 = 12,
		wh_dlc05_wef_inf_dryads_0 = 4,
		wh_dlc05_wef_inf_wardancers_1 = 8,
		wh_dlc05_wef_inf_wildwood_rangers_0 = 4,
		wh_dlc05_wef_inf_glade_guard_2 = 12,
		wh_dlc05_wef_inf_deepwood_scouts_1 = 8,
		wh_dlc05_wef_inf_waywatchers_0 = 6,
		
			--Cavalry
		wh_dlc05_wef_cav_wild_riders_1 = 6,
		wh_dlc05_wef_cav_glade_riders_0 = 6,
		wh_dlc05_wef_cav_glade_riders_1 = 2,
		wh_dlc05_wef_cav_hawk_riders_0 = 1,
		wh_dlc05_wef_cav_sisters_thorn_0 = 1,
		
			--Monsters
		wh_dlc05_wef_mon_treekin_0 = 4,
		wh_dlc05_wef_mon_treeman_0 = 4,
		wh_dlc05_wef_mon_great_eagle_0 = 1,
		wh_dlc05_wef_forest_dragon_0 = 2,
	},
	base_army_count = 4, -- Number of armies that spawn in each forest glade when the event fires.
	early_warning_event = "wh3_main_ie_incident_endgame_wild_hunt_early_warning",
	ai_personality = "wh3_combi_woodelf_endgame"
}

function endgame_wild_hunt:trigger()
	local potential_wood_elves = {
		wh_dlc05_wef_wood_elves = "wh3_main_combi_region_kings_glade",
		wh_dlc05_wef_wydrioth = "wh3_main_combi_region_crag_halls_of_findol",
		wh3_main_wef_laurelorn = "wh3_main_combi_region_laurelorn_forest",
		wh_dlc05_wef_torgovann = "wh3_main_combi_region_vauls_anvil_loren",
		wh2_main_wef_bowmen_of_oreon = "wh3_main_combi_region_oreons_camp",
		wh_dlc05_wef_argwylon = "wh3_main_combi_region_waterfall_palace",
		wh2_dlc16_wef_drycha = "wh3_main_combi_region_gryphon_wood",
		wh2_dlc16_wef_sisters_of_twilight = "wh3_main_combi_region_the_witchwood"
	}

	local forest_regions = {}
	local wood_elf_factions = {}
	
	for faction_key, region_key in pairs(potential_wood_elves) do
		local faction = cm:get_faction(faction_key)
		if not faction:is_human() and not faction:was_confederated() then
			table.insert(forest_regions, region_key)
			table.insert(wood_elf_factions, faction_key)

			endgame:create_scenario_force(faction_key, region_key, self.army_template, self.unit_list, true, 2)
			if faction_key ==  "wh_dlc05_wef_wood_elves" then
				endgame:create_scenario_force(faction_key, "wh3_main_combi_region_the_oak_of_ages", self.army_template, self.unit_list, true, math.floor(self.base_army_count*endgame.settings.difficulty_mod))
			end

			endgame:no_peace_no_confederation_only_war(faction_key)
			
			local region = cm:get_region(region_key)
			local region_owner = region:owning_faction()

			cm:force_change_cai_faction_personality(faction_key, self.ai_personality)

			if region_owner:is_null_interface() or region_owner:name() == "rebels" or (not region_owner:name() == faction_key and not region_owner:is_human()) then
				cm:transfer_region_to_faction(region_key, faction_key)
			end
			
			endgame:declare_war_on_adjacent_region_owners(faction, region)

			cm:apply_effect_bundle("wh3_main_ie_scripted_endgame_wild_hunt", faction_key, 0)
			table.insert(endgame.revealed_regions, region_key)
		end
	end

	local human_factions = cm:get_human_factions()
	local region_count_halved = math.floor((#forest_regions/2) + 0.5)
	local objectives = {
		{
			type = "CONTROL_N_REGIONS_FROM",
			conditions = {
				"total "..region_count_halved,
				"override_text mission_text_text_mis_activity_control_n_regions_satrapy_including_at_least_n"
			}
		},
		{
			type = "DESTROY_FACTION",
			conditions = {
				"confederation_valid"
			}
		}
	}

	for i = 1, #forest_regions do 
		table.insert(objectives[1].conditions, "region "..forest_regions[i])
	end

	for i = 1, #wood_elf_factions do 
		table.insert(objectives[2].conditions, "faction "..wood_elf_factions[i])
	end

	local incident_key = "wh3_main_ie_incident_endgame_wild_hunt"
	if #forest_regions == 0 then
		-- We somehow don't have any targets - silently exit the scenario
		return
	end

	cm:activate_music_trigger("ScriptedEvent_Negative", "wh_dlc05_sc_wef_wood_elves")
	
	for i = 1, #human_factions do
		endgame:add_victory_condition_listener(human_factions[i], incident_key, objectives)
		cm:trigger_incident_with_targets(
			cm:get_faction(human_factions[i]):command_queue_index(),
			incident_key,
			0,
			0,
			0,
			0,
			cm:get_region(forest_regions[1]):cqi(),
			0
		)
	end

end