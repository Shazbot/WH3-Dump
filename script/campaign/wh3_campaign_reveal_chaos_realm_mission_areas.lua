

---- Reveals the chaos realm a quest battle is located in

chaos_realm_missions = {}

---------------------------------------------------------------
-------------------- Chaos Realm info -------------------------
---------------------------------------------------------------

chaos_realm_missions = {
	realm = {
		khorne = "khorne",
		nurgle = "nurgle",
		slaanesh = "slaanesh",
		tzeentch = "tzeentch",
	},

	khorne = {
		terrain_patch = "wh3_main_patch_area_khorne_realm",
		region_names = {"wh3_main_chaos_region_the_blood_gods_domain"}
	},
	nurgle = {
		terrain_patch = "wh3_main_patch_area_nurgle_realm",
		region_names = {"wh3_main_chaos_region_land_of_the_plaguelord"}
	},
	slaanesh = {
		terrain_patch = "wh3_main_patch_area_slaanesh_realm",
		region_names = {
			"wh3_main_chaos_region_slaanesh_fifth",
			"wh3_main_chaos_region_slaanesh_first",
			"wh3_main_chaos_region_slaanesh_fourth",
			"wh3_main_chaos_region_slaanesh_second",
			"wh3_main_chaos_region_slaanesh_sixth",
			"wh3_main_chaos_region_slaanesh_start_01",
			"wh3_main_chaos_region_slaanesh_start_02",
			"wh3_main_chaos_region_slaanesh_start_03",
			"wh3_main_chaos_region_slaanesh_start_04",
			"wh3_main_chaos_region_slaanesh_start_05",
			"wh3_main_chaos_region_slaanesh_start_06",
			"wh3_main_chaos_region_slaanesh_start_07",
			"wh3_main_chaos_region_slaanesh_start_08",
			"wh3_main_chaos_region_slaanesh_third",
			"wh3_main_chaos_region_the_dark_princes_realm",
		}
	},
	tzeentch = {
		terrain_patch = "wh3_main_patch_area_tzeentch_realm",
		region_names = {
			"wh3_main_chaos_region_realm_of_the_sorcerer_1",
			"wh3_main_chaos_region_realm_of_the_sorcerer_2",
			"wh3_main_chaos_region_realm_of_the_sorcerer_3",
			"wh3_main_chaos_region_realm_of_the_sorcerer_4",
			"wh3_main_chaos_region_realm_of_the_sorcerer_5",
			"wh3_main_chaos_region_realm_of_the_sorcerer_6",
			"wh3_main_chaos_region_realm_of_the_sorcerer_7",
		}
	}
}

chaos_realm_missions.missions = {
		-- quest_battle_key = "realm_mission_is_located_in"

		wh3_dlc20_qb_chs_valkia_the_spear_slaupnir = chaos_realm_missions.realm.khorne,
		wh3_dlc20_qb_chs_festus_pestilent_potions = chaos_realm_missions.realm.nurgle,
		wh3_dlc20_qb_chs_azazel_daemonblade = chaos_realm_missions.realm.slaanesh,
		wh3_dlc20_qb_chs_vilitch_vessel_of_chaos = chaos_realm_missions.realm.tzeentch,
}


-- Setup the listener to reveal specific chaos realms for the listed Quest Battles
function chaos_realm_missions:initialise()
	core:add_listener(
		"chaos_realm_missions_activated",
		"MissionIssued",
		function(context)
			return self.missions[context:mission():mission_record_key()] ~= nil
		end,
		function(context)
			local mission_key = context:mission():mission_record_key()
			local mission_faction = context:faction():name()
			local realm_to_reveal = self.missions[mission_key]

			cm:force_terrain_patch_visible(self[realm_to_reveal].terrain_patch)
			for _, v in pairs(self[realm_to_reveal].region_names) do
				cm:make_region_seen_in_shroud(mission_faction, v)
			end

			self:hide_chaos_realm_terrain_patch(mission_faction, mission_key)
		end,
		true
	)
end

-- Hides chaos realm terrain patch turn after mission is issued
function chaos_realm_missions:hide_chaos_realm_terrain_patch(faction, quest_battle_key)
	local listener_name = "reset_chaos_realm_terrain_patch_visibility"..quest_battle_key
	core:add_listener(
		listener_name,
		"FactionTurnStart",
		function(context)
			return context:faction():name() == faction
		end,
		function(context)
			cm:reset_forced_terrain_patch_visibility()
			core:remove_listener(listener_name)
		end,
		true
	)
end