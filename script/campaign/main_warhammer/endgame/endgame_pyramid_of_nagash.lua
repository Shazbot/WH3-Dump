endgame_pyramid_of_nagash = {
	army_template = "endgame_pyramid_of_nagash",
	base_army_count = 8, -- Number of armies that spawn when the event fires.
	region_key = "wh3_main_combi_region_black_pyramid_of_nagash",
	early_warning_event = "wh3_main_ie_incident_endgame_black_pyramid_early_warning",
	tomb_kings_data = {
		faction_key = "wh2_dlc09_tmb_the_sentinels", -- Default invasion faction, will use another TK faction if they control the pyramid
		incident_key = "wh3_main_ie_incident_endgame_black_pyramid_tomb_kings",
		faction_bundle = "wh3_main_ie_scripted_endgame_black_pyramid_faction_tomb_kings",
		region_bundle = "wh3_main_ie_scripted_endgame_black_pyramid_region_tomb_kings",
		ai_personality = "wh3_combi_tombking_endgame",
		music = "wh_main_sc_vmp_vampire_counts",
		unit_list = {
			wh2_dlc09_tmb_inf_skeleton_warriors_0 = 2,
			wh2_dlc09_tmb_inf_skeleton_spearmen_0 = 2,
			wh2_dlc09_tmb_inf_tomb_guard_0 = 6,
			wh2_dlc09_tmb_inf_tomb_guard_1 = 8,
			wh2_dlc09_tmb_inf_nehekhara_warriors_0 = 8,
			wh2_dlc09_tmb_inf_skeleton_archers_0 = 4,
				
				--Cavalry
			wh2_dlc09_tmb_cav_skeleton_horsemen_0 = 4,
			wh2_dlc09_tmb_cav_nehekhara_horsemen_0 = 2,
			wh2_dlc09_tmb_veh_skeleton_chariot_0 = 2,
			wh2_dlc09_tmb_veh_skeleton_archer_chariot_0 = 3,
			wh2_dlc09_tmb_cav_skeleton_horsemen_archers_0 = 6,
			wh2_dlc09_tmb_mon_sepulchral_stalkers_0 = 3,
			wh2_dlc09_tmb_cav_necropolis_knights_0 = 1,
			wh2_dlc09_tmb_cav_necropolis_knights_1 = 2,
				
				--Monsters
			wh2_dlc09_tmb_mon_carrion_0 = 4,
			wh2_dlc09_tmb_mon_ushabti_0 = 2,
			wh2_dlc09_tmb_mon_ushabti_1 = 4,
			wh2_dlc09_tmb_veh_khemrian_warsphinx_0 = 2,
			wh2_dlc09_tmb_mon_tomb_scorpion_0 = 4,
			wh2_dlc09_tmb_mon_heirotitan_0 = 2,
			wh2_dlc09_tmb_mon_necrosphinx_0 = 2,
			wh2_pro06_tmb_mon_bone_giant_0 = 4,
				
				--Artillery
			wh2_dlc09_tmb_art_screaming_skull_catapult_0 = 2,
			wh2_dlc09_tmb_art_casket_of_souls_0 = 3,
		}		
	},
	vampires_data = {
		faction_key = "",
		incident_key = "wh3_main_ie_incident_endgame_black_pyramid_vampires",
		faction_bundle = "wh3_main_ie_scripted_endgame_black_pyramid_faction_vampires",
		region_bundle = "wh3_main_ie_scripted_endgame_black_pyramid_region_vampires",
		ai_personality = "wh3_combi_vampire_endgame",
		music = "wh_main_sc_vmp_vampire_counts",
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
		}
	}
}

function endgame_pyramid_of_nagash:trigger()

	local region = cm:get_region(self.region_key)
	local data = self.tomb_kings_data

	-- Check to see if AI Vampires or Tomb Kings already own the region
	if not region:is_abandoned() then
		local owning_faction = region:owning_faction()
		if not owning_faction:is_human() then
			if owning_faction:subculture() == "wh2_dlc09_sc_tmb_tomb_kings" then
				data.faction_key = owning_faction:name()
			elseif owning_faction:subculture() == "wh_main_sc_vmp_vampire_counts" then
				data = self.vampires_data
				data.faction_key = owning_faction:name()
			end
		end
	end

	endgame:create_scenario_force(data.faction_key, self.region_key, self.army_template, data.unit_list, true, math.floor(self.base_army_count*endgame.settings.difficulty_mod))
	cm:instantly_research_all_technologies(data.faction_key)
	cm:activate_music_trigger("ScriptedEvent_Negative", data.music)
	cm:apply_effect_bundle(data.faction_bundle, data.faction_key, 0)
	cm:apply_effect_bundle_to_region(data.region_bundle, self.region_key, 0)
	cm:force_change_cai_faction_personality(data.faction_key, data.ai_personality)
	
	endgame:no_peace_no_confederation_only_war(data.faction_key)
	local invasion_faction = cm:get_faction(data.faction_key)
	endgame:declare_war_on_adjacent_region_owners(invasion_faction, region)
	table.insert(endgame.revealed_regions, self.region_key)

	-- Make the Black Pyramid fly!
	cm:override_building_chain_display("wh2_dlc09_special_settlement_pyramid_of_nagash_tmb", "wh2_dlc09_special_settlement_pyramid_of_nagash_floating")

	local human_factions = cm:get_human_factions()
	local objectives = {
		{
			type = "DESTROY_FACTION",
			conditions = {
				"faction "..data.faction_key,
				"confederation_valid",
				"vassalization_valid"
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
		endgame:add_victory_condition_listener(human_factions[i], data.incident_key, objectives)
		cm:trigger_incident_with_targets(
			cm:get_faction(human_factions[i]):command_queue_index(),
			data.incident_key,
			0,
			0,
			0,
			0,
			cm:get_region(self.region_key):cqi(),
			0
		)
	end
	cm:set_saved_value("endgame_pyramid_of_nagash_saved_data", data)
	endgame_pyramid_of_nagash:add_listeners()
end

function endgame_pyramid_of_nagash:add_listeners()
	local data = cm:get_saved_value("endgame_pyramid_of_nagash_saved_data")
	core:add_listener(
		"endgame_pyramid_of_nagash_ultimate_victory",
		"MissionSucceeded",
		function(context)
			return context:mission():mission_record_key() == "wh_main_ultimate_victory"
		end,
		function()
			cm:remove_effect_bundle_from_region(data.region_bundle, self.region_key)
			core:remove_listener("endgame_pyramid_of_nagash_spawn_army")
			core:remove_listener("endgame_pyramid_of_nagash_ultimate_victory")
		end,
		true
	)

	core:add_listener(
		"endgame_pyramid_of_nagash_spawn_army",
		"WorldStartRound",
		function()
			return cm:turn_number() % 10 == 0 and cm:get_faction(data.faction_key):has_home_region()
		end,
		function()
			endgame:create_scenario_force(data.faction_key, self.region_key, self.army_template, data.unit_list, false, 1)
		end,
		true
	)
end

if cm:get_saved_value("endgame_pyramid_of_nagash_saved_data") then
	endgame_pyramid_of_nagash:add_listeners()
end