endgame_grudge_too_far = {
	army_template = "endgame_grudge_too_far",
	unit_list = {
		--Infantry
		wh_main_dwf_inf_miners_1 = 6,
		wh_main_dwf_inf_hammerers = 8,
		wh_main_dwf_inf_ironbreakers = 8,
		wh_main_dwf_inf_longbeards = 4,
		wh_main_dwf_inf_longbeards_1 = 8,
		wh_main_dwf_inf_slayers = 6,
		wh2_dlc10_dwf_inf_giant_slayers = 4,
		wh_main_dwf_inf_thunderers_0 = 8,
		wh_main_dwf_inf_irondrakes_0 = 4,
		wh_main_dwf_inf_irondrakes_2 = 6,
		wh_dlc06_dwf_inf_rangers_0 = 2,
		wh_dlc06_dwf_inf_rangers_1 = 4,
		wh_dlc06_dwf_inf_bugmans_rangers_0 = 2,
			
			--Artillery
		wh_main_dwf_art_grudge_thrower = 1,
		wh_main_dwf_art_cannon = 4,
		wh_main_dwf_art_organ_gun = 4,
		wh_main_dwf_art_flame_cannon = 2,
			
			--Vehicles
		wh_main_dwf_veh_gyrocopter_0 = 1,
		wh_main_dwf_veh_gyrocopter_1 = 1,
		wh_main_dwf_veh_gyrobomber = 1,
	},
	major_army_count = 4, -- Number of armies that spawn for the major playables
	minor_army_count = 2, -- Number of armies that spawn for the minor dwarves
	early_warning_event = "wh3_main_ie_incident_endgame_grudge_too_far_early_warning",
	ai_personality = "wh3_combi_dwarf_endgame"
}

function endgame_grudge_too_far:trigger()
	local potential_dwarfs = {
		wh2_dlc17_dwf_thorek_ironbrow = "wh3_main_combi_region_karak_zorn",
		wh_main_dwf_karak_izor = "wh3_main_combi_region_zarakzil",
		wh_main_dwf_karak_kadrin = "wh3_main_combi_region_karak_kadrin",
		wh3_main_dwf_the_ancestral_throng = "wh3_main_combi_region_drackla_spire",
		wh_main_dwf_dwarfs = "wh3_main_combi_region_karaz_a_karak",
		wh_main_dwf_kraka_drak = "wh3_main_combi_region_kraka_drak",
		wh_main_dwf_barak_varr = "wh3_main_combi_region_barak_varr",
		wh_main_dwf_zhufbar = "wh3_main_combi_region_zhufbar",
		wh3_main_dwf_karak_azorn = "wh3_main_combi_region_karak_azorn",
		wh_main_dwf_karak_norn = "wh3_main_combi_region_karak_norn",
		wh_main_dwf_karak_hirn = "wh3_main_combi_region_karak_hirn",
		wh_main_dwf_karak_azul = "wh3_main_combi_region_karak_azul",
		wh_main_dwf_karak_ziflin = "wh3_main_combi_region_karak_ziflin"
	}
	
	local dwarf_regions = {}
	
	for faction_key, region_key in pairs(potential_dwarfs) do
		local invasion_faction = cm:get_faction(faction_key)
		if not invasion_faction:is_human() and not invasion_faction:was_confederated() then
			table.insert(dwarf_regions, region_key)
			local army_count
			local can_be_human = invasion_faction:can_be_human()
			if can_be_human then
				army_count = math.floor(self.major_army_count*endgame.settings.difficulty_mod)
			else
				army_count = math.floor(self.minor_army_count*endgame.settings.difficulty_mod)
			end
			if army_count < 1 then
				army_count = 1
			end
			endgame:create_scenario_force(faction_key, region_key, self.army_template, self.unit_list, true, army_count)
			if faction_key == "wh_main_dwf_karak_izor" then
				if not invasion_faction:is_dead() and cm:get_region("wh3_main_combi_region_karak_eight_peaks"):owning_faction():name() == faction_key then
					endgame:create_scenario_force(faction_key, "wh3_main_combi_region_karak_eight_peaks", self.army_template, self.unit_list, true, army_count)
				end
			end

			cm:force_change_cai_faction_personality(faction_key, self.ai_personality)

			-- Give the invasion region to the invader if it isn't owned by them or a human
			local region = cm:get_region(region_key)
			local region_owner = region:owning_faction()
			if region_owner:is_null_interface() or (region_owner:name() ~= faction_key and region_owner:is_human() == false) then
				cm:transfer_region_to_faction(region_key, faction_key)
			end

			endgame:no_peace_no_confederation_only_war(faction_key)
			endgame:declare_war_on_adjacent_region_owners(invasion_faction, region)

			cm:apply_effect_bundle("wh3_main_ie_scripted_endgame_grudge_too_far", faction_key, 0)
			table.insert(endgame.revealed_regions, region_key)
		end
	end

	local human_factions = cm:get_human_factions()
	local region_count_halved = math.floor((#dwarf_regions/2) + 0.5)
	local objectives = {
		{
			type = "CONTROL_N_REGIONS_FROM",
			conditions = {
				"total "..region_count_halved,
				"override_text mission_text_text_mis_activity_control_n_regions_satrapy_including_at_least_n"
			}
		}
	}

	for i = 1, #dwarf_regions do 
		table.insert(objectives[1].conditions, "region "..dwarf_regions[i])
	end

	local incident_key = "wh3_main_ie_incident_endgame_grudge_too_far"
	if #dwarf_regions == 0 then
		-- We somehow don't have any targets - silently exit the scenario
		return
	end

	cm:activate_music_trigger("ScriptedEvent_Negative", "wh_main_sc_emp_empire")
	
	for i = 1, #human_factions do
		endgame:add_victory_condition_listener(human_factions[i], incident_key, objectives)
		cm:trigger_incident_with_targets(
			cm:get_faction(human_factions[i]):command_queue_index(),
			incident_key,
			0,
			0,
			0,
			0,
			cm:get_region(dwarf_regions[1]):cqi(),
			0
		)
	end

end