endgame_waaagh = {
	army_template = "endgame_waaagh",
	unit_list = {
			--Infantry
		wh_dlc06_grn_inf_nasty_skulkers_0 = 2,
		wh_main_grn_inf_night_goblins = 2,
		wh_main_grn_inf_night_goblin_fanatics = 2,
		wh_main_grn_inf_night_goblin_fanatics_1 = 2,
		wh_main_grn_inf_orc_boyz = 2,
		wh_main_grn_inf_orc_big_uns = 8,
		wh_main_grn_inf_savage_orcs = 3,
		wh_main_grn_inf_savage_orc_big_uns = 8,
		wh_main_grn_inf_black_orcs = 8,
		wh_main_grn_inf_night_goblin_archers = 2,
		wh_main_grn_inf_orc_arrer_boyz = 4,
		wh_main_grn_inf_savage_orc_arrer_boyz = 8,
			
			--Cavalry
		wh_main_grn_cav_goblin_wolf_riders_0 = 2,
		wh_main_grn_cav_goblin_wolf_riders_1 = 4,
		wh_main_grn_cav_goblin_wolf_chariot = 3,
		wh_main_grn_cav_forest_goblin_spider_riders_0 = 2,
		wh_main_grn_cav_forest_goblin_spider_riders_1 = 2,
		wh_dlc06_grn_cav_squig_hoppers_0 = 1,
		wh_main_grn_cav_orc_boar_boyz = 1,
		wh_main_grn_cav_orc_boar_boy_big_uns = 5,
		wh_main_grn_cav_orc_boar_chariot = 1,
		wh_main_grn_cav_savage_orc_boar_boyz = 2,
		wh_main_grn_cav_savage_orc_boar_boy_big_uns = 3,
			
			--Monsters
		wh_dlc06_grn_inf_squig_herd_0 = 2,
		wh_main_grn_mon_trolls = 3,
		wh_main_grn_mon_giant = 2,
		wh_main_grn_mon_arachnarok_spider_0 = 2,
			
			--Artillery
		wh_main_grn_art_goblin_rock_lobber = 2,
		wh_main_grn_art_doom_diver_catapult = 4,
	},
	base_army_count = 4, -- Number of armies that spawn when the event fires.
	early_warning_event = "wh3_main_ie_incident_endgame_waaagh_early_warning",
	ai_personality = "wh3_combi_greenskin_endgame"
}

function endgame_waaagh:trigger()
	local potential_greenskins = {
		"wh_main_grn_greenskins",
		"wh_main_grn_orcs_of_the_bloody_hand",
		"wh2_dlc15_grn_broken_axe",
		"wh2_dlc15_grn_bonerattlaz",
		"wh_main_grn_crooked_moon",
		"wh3_dlc26_grn_gorbad_ironclaw"
	}
	local greenskin_factions = {}
	
	for i = 1, #potential_greenskins do
		local faction_key = potential_greenskins[i]
		local faction = cm:get_faction(faction_key)
		local region_key = nil
		if faction and not faction:is_human() and not faction:is_dead() and not faction:was_confederated() then
			if faction:faction_leader():has_region() then
				region_key = faction:faction_leader():region():name()
			elseif faction:has_home_region() then
				region_key = faction:home_region():name()
			end
			if region_key ~= nil then
				table.insert(greenskin_factions, faction_key)
				endgame:create_scenario_force(faction_key, region_key, self.army_template, self.unit_list, true, math.floor(self.base_army_count*endgame.settings.difficulty_mod))
				cm:instantly_research_all_technologies(faction_key)
				cm:apply_effect_bundle("wh3_main_ie_scripted_endgame_waaagh", faction_key, 0)
				endgame:no_peace_no_confederation_only_war(faction_key)
				cm:force_change_cai_faction_personality(faction_key, self.ai_personality)
				local region = cm:get_region(region_key)
				endgame:declare_war_on_adjacent_region_owners(faction, region)
				table.insert(endgame.revealed_regions, region_key)
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
				local region = cm:get_region(region_key)
				local region_owner = region:owning_faction()
				table.insert(greenskin_factions, faction_key)
				endgame:create_scenario_force(faction_key, region_key, self.army_template, self.unit_list, true, math.floor(self.base_army_count*endgame.settings.difficulty_mod))
				cm:instantly_research_all_technologies(faction_key)
				if region_owner:is_null_interface() or (not region_owner:name() == faction_key and not region_owner:is_human()) then
					cm:transfer_region_to_faction(region_key, faction_key)
				end
				cm:apply_effect_bundle("wh3_main_ie_scripted_endgame_waaagh", faction_key, 0)
				endgame:no_peace_no_confederation_only_war(faction_key)
				cm:force_change_cai_faction_personality(faction_key, "wh3_combi_greenskin_endgame")
				endgame:declare_war_on_adjacent_region_owners(faction, region)
				table.insert(endgame.revealed_regions, region_key)
				break
			end
		end

	end

	local human_factions = cm:get_human_factions()
	local objectives = {
		{
			type = "DESTROY_FACTION",
			conditions = {
				"confederation_valid",
				"vassalization_valid"
			}
		}
	}

	if #greenskin_factions == 0 then
		-- We somehow don't have any targets - silently exit the scenario
		return
	end
	
	for i = 1, #greenskin_factions do 
		table.insert(objectives[1].conditions, "faction "..greenskin_factions[i])
	end

	cm:activate_music_trigger("ScriptedEvent_Negative", "wh_main_sc_grn_greenskins")

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