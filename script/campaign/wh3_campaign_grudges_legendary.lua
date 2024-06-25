-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	THE GREAT SCRIPT OF LEGENDARY GRUDGES
--	This script handles the legendary grudge missions
--	The triggering, tracking and completion
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

---------------------------------------------------
---------------------- Data -----------------------
---------------------------------------------------

legendary_grudges = {
	dwarf_culture = "wh_main_dwf_dwarfs",
	mission_issuer = "CLAN_ELDERS",
	completed_missions = {},
	active_missions = {},
	should_spawn_foe_armies = false,
	ancillary_reward_cooldown = 5,

	building_locks = {
		"wh3_dlc25_special_dwf_reclaimed_hold_2",
		"wh3_dlc25_special_oak_of_ages_exploited_dwf",
		"wh3_dlc25_special_hall_of_dragons_dwf"
	},
	invasion_effect_bundles = {
		no_upkeep = "wh_main_bundle_military_upkeep_free_force",
		region_attrition_immune = "wh2_dlc16_bundle_military_upkeep_free_force_immune_to_regionless_attrition",
		immobile = "wh2_dlc17_effect_campaign_movement_immobile"
	},

	playable_dwarf_factions = {},
	unique_lord_name_list = {
		"names_name_291390137",
		"names_name_140354013",
		"names_name_1404293344",
		"names_name_1803885340",
		"names_name_1885587695",
		"names_name_581141606",
	},

	mission_key_list = {
		main_warhammer = {
			"wh3_dlc25_grudge_legendary_karaz_ankor",
			"wh3_dlc25_grudge_legendary_high_elves",
			"wh3_dlc25_grudge_legendary_karak_zorn",
			"wh3_dlc25_grudge_legendary_skaven_blight",
			"wh3_dlc25_grudge_legendary_chaos_dwarfs",
			"wh3_dlc25_grudge_legendary_athel_loren",
			"wh3_dlc25_grudge_legendary_norse_dwarfs",
			"wh3_dlc25_grudge_legendary_malekith_and_friends",
			"wh3_dlc25_grudge_legendary_eight_peaks",
			"wh3_dlc25_grudge_legendary_silver_pinnacle",
		},
		wh3_main_chaos = {
			"wh3_dlc25_grudge_legendary_chaos_dwarfs",			
			"wh3_dlc25_grudge_legendary_norse_dwarfs",			
			"wh3_dlc25_grudge_legendary_skaven_blight",			
			"wh3_dlc25_grudge_legendary_karaz_ankor",			
			"wh3_dlc25_grudge_legendary_silver_pinnacle",			
		},
	},
	mission_key_to_data_key = {
		wh3_dlc25_grudge_legendary_karaz_ankor = "karaz_ankor",
		wh3_dlc25_grudge_legendary_high_elves = "high_elves",
		wh3_dlc25_grudge_legendary_karak_zorn = "karak_zorn",
		wh3_dlc25_grudge_legendary_skaven_blight = "skaven_blight",
		wh3_dlc25_grudge_legendary_athel_loren = "athel_loren",
		wh3_dlc25_grudge_legendary_chaos_dwarfs = "chaos_dwarfs",
		wh3_dlc25_grudge_legendary_norse_dwarfs = "norse_dwarfs",
		wh3_dlc25_grudge_legendary_malekith_and_friends = "malekith",
		wh3_dlc25_grudge_legendary_eight_peaks = "eight_peaks",
		wh3_dlc25_grudge_legendary_silver_pinnacle = "silver_pinnacle",
	},
	missions = {
		karaz_ankor = {
			trigger_function = function(self, faction) legendary_grudges:trigger_karaz_ankor_grudge(faction) end,
			mission_key = "wh3_dlc25_grudge_legendary_karaz_ankor",
			payloads = {
				effect_bundle = "wh3_dlc25_dwf_underway_teleport_enable_dummy",
				pooled_resource = {
					{
						key = "wh3_dlc25_dwf_grudge_points",
						factor = "settled",
						amount = 2500
					},
				},
				teleport_rituals = {
					main_warhammer = {
						"wh3_dlc25_underway_teleport_karak_azgal_ie",
						"wh3_dlc25_underway_teleport_karak_eight_peaks_ie",
						"wh3_dlc25_underway_teleport_karak_izor_ie",
						"wh3_dlc25_underway_teleport_karak_kadrin_ie",
						"wh3_dlc25_underway_teleport_karak_norn_ie",
						"wh3_dlc25_underway_teleport_karak_vlag_ie",
						"wh3_dlc25_underway_teleport_karak_ziflin_ie",
						"wh3_dlc25_underway_teleport_karaz_a_karak_ie",
					},
					wh3_main_chaos = {
						"wh3_dlc25_underway_teleport_karak_kadrin_roc",
						"wh3_dlc25_underway_teleport_karak_vlag_roc",
						"wh3_dlc25_underway_teleport_karak_ziflin_roc",
						"wh3_dlc25_underway_teleport_kraka_drak_roc",
						"wh3_dlc25_underway_teleport_pillars_of_grungni_roc",
						"wh3_dlc25_underway_teleport_zhufbar_roc",
					},
				}
			},			
			target_province_list = {
				main_warhammer = {
					"wh3_main_combi_province_northern_worlds_edge_mountains",
					"wh3_main_combi_province_peak_pass",
					"wh3_main_combi_province_black_water",
					"wh3_main_combi_province_the_silver_road",
					"wh3_main_combi_province_death_pass",
					"wh3_main_combi_province_southern_worlds_edge_mountains",
					"wh3_main_combi_province_blightwater",
					"wh3_main_combi_province_blood_river_valley",
				},
				wh3_main_chaos = {
					"wh3_main_chaos_province_gianthome_mountains",
					"wh3_main_chaos_province_worlds_edge_mountains",
					"wh3_main_chaos_province_peak_pass",
					"wh3_dlc23_chaos_province_silver_road",
					"wh3_main_chaos_province_black_water",
					"wh3_main_chaos_province_the_high_pass",
				}
			},
		},
		chaos_dwarfs = {
			trigger_function = function(self, faction) legendary_grudges:trigger_chaos_dwarfs_grudge(faction) end,
			mission_key = "wh3_dlc25_grudge_legendary_chaos_dwarfs",
			payloads = {
				effect_bundle = "wh3_dlc25_grudge_reward_dwf_chaos_dwarfs_defeated",
				pooled_resource = {
					{
						key = "wh3_dlc25_dwf_grudge_points",
						factor = "settled",
						amount = 2500
					},
				},
				teleport_rituals = {
					main_warhammer = {
						"wh3_dlc25_underway_teleport_karak_azorn_ie",
						"wh3_dlc25_underway_teleport_uzkulak_ie",
					},
					wh3_main_chaos = {
						"wh3_dlc25_underway_teleport_karak_azorn_roc",
						"wh3_dlc25_underway_teleport_uzkulak_roc",
					}
				},
				ancillaries = {
					"wh3_dlc23_anc_armour_lesser_relic_of_skavor",
					"wh3_dlc23_anc_armour_major_relic_of_grungni",
					"wh3_dlc23_anc_enchanted_item_major_relic_of_valaya",
					"wh3_dlc23_anc_talisman_lesser_relic_of_thungni",
					"wh3_dlc23_anc_weapon_lesser_relic_of_smednir",
					"wh3_dlc23_anc_enchanted_item_lesser_relic_of_morgrim",
				},
			},
			target_faction_list = {
				"wh3_dlc23_chd_astragoth",
				"wh3_dlc23_chd_conclave",
				"wh3_dlc23_chd_legion_of_azgorh",
				"wh3_dlc23_chd_minor_faction",
				"wh_main_grn_greenskins",
			},
		},
		silver_pinnacle = {
			trigger_function = function(self, faction) legendary_grudges:trigger_silver_pinnacle_grudge(faction) end,
			mission_key = "wh3_dlc25_grudge_legendary_silver_pinnacle",
			payloads = {
				effect_bundle = "wh3_dlc25_grudge_reward_dwf_silver_pinnacle_landmark",
				pooled_resource = {
					{
						key = "wh3_dlc25_dwf_grudge_points",
						factor = "settled",
						amount = 2500
					},
				},
				building_unlock = "wh3_dlc25_special_dwf_reclaimed_hold_2",
			},
			target_building = "wh3_dlc25_special_dwf_reclaimed_hold_1",
			target_region_list = {
				main_warhammer = {
					"wh3_main_combi_region_silver_pinnacle",
				},
				wh3_main_chaos = {
					"wh3_main_chaos_region_the_silver_pinnacle"
				}
			},
			spawn_region = {
				main_warhammer = "wh3_dlc23_combi_region_blasted_expanse",
				wh3_main_chaos = "wh3_main_chaos_region_the_silver_pinnacle"
			},
			force_data = {
				force_size = 19,
				force_power = 0,
				template_key = "wh_main_sc_vmp_vampire_counts",
				faction_key = "wh3_main_vmp_lahmian_sisterhood",
			},
		},
		eight_peaks = {
			trigger_function = function(self, faction) legendary_grudges:trigger_karak_eight_peaks_grudge(faction) end,
			mission_key = "wh3_dlc25_grudge_legendary_eight_peaks",
			payloads = {
				effect_bundle = "wh3_dlc25_grudge_reward_dwf_eight_peaks_secured",
				pooled_resource = {
					{
						key = "wh3_dlc25_dwf_grudge_points",
						factor = "settled",
						amount = 2500
					},
				},
			},
			target_faction_list = {
				"wh_main_grn_crooked_moon",
				"wh2_main_skv_clan_mors",
			},
			target_region_list = {
				main_warhammer = {
					"wh3_main_combi_region_karak_eight_peaks",
				},
			}
		},
		malekith = {
			trigger_function = function(self, faction) legendary_grudges:trigger_malekith_grudge(faction) end,
			mission_key = "wh3_dlc25_grudge_legendary_malekith_and_friends",
			payloads = {
				effect_bundle = "wh3_dlc25_grudge_reward_dwf_malekith_unique_lord",
				pooled_resource = {
					{
						key = "wh3_dlc25_dwf_grudge_points",
						factor = "settled",
						amount = 2500
					},
				},
			},
			target_faction_list = {
				"wh2_main_def_naggarond",
				"wh2_main_def_cult_of_pleasure",
				"wh2_main_def_har_ganeth",
			},
			target_region_list = {
				main_warhammer = {
					"wh3_main_combi_region_naggarond",
				},
			}
		},
		norse_dwarfs = {
			trigger_function = function(self, faction) legendary_grudges:trigger_norse_dwarf_grudge(faction) end,
			mission_key = "wh3_dlc25_grudge_legendary_norse_dwarfs",
			payloads = {
				effect_bundle = "wh3_dlc25_grudge_reward_dwf_norse_dwarfs_underway_movement",
				pooled_resource = {
					{
						key = "wh3_dlc25_dwf_grudge_points",
						factor = "settled",
						amount = 2500
					},
				},
			},
			target_region = "kraka_drak_region",
			target_region_list = {
				main_warhammer = {
					"wh3_main_combi_region_monolith_of_borkill_the_bloody_handed",
					"wh3_main_combi_region_graeling_moot",
					"wh3_main_combi_region_doomkeep",
					"wh3_main_combi_region_sarl_encampment",
					"wh3_main_combi_region_the_tower_of_khrakk",
					"wh3_main_combi_region_khazid_bordkarag",
					"wh3_main_combi_region_the_forbidden_citadel",
				},
				wh3_main_chaos = {
					"wh3_main_chaos_region_foul_fortress",
					"wh3_main_chaos_region_the_monolith_of_katam",
					"wh3_main_chaos_region_the_forbidden_citadel",
					"wh3_main_chaos_region_the_tower_of_khrakk",
					"wh3_main_chaos_region_winter_pyre",
					"wh3_main_chaos_region_fort_straghov",
				}
			}
		},
		athel_loren = {
			trigger_function = function(self, faction) legendary_grudges:trigger_athel_loren_grudge(faction) end,
			mission_key = "wh3_dlc25_grudge_legendary_athel_loren",
			payloads = {
				building_unlock = "wh3_dlc25_special_oak_of_ages_exploited_dwf",
				effect_bundle = "wh3_dlc25_grudge_reward_dwf_athel_loren_landmark",
				pooled_resource = {
					{
						key = "wh3_dlc25_dwf_grudge_points",
						factor = "settled",
						amount = 2500
					},
				},
			},
			target_faction_list = {
				"wh_dlc05_wef_wood_elves",
				"wh_dlc05_wef_argwylon",
			},
			target_region_list = {
				main_warhammer = {
					"wh3_main_combi_region_the_oak_of_ages",
					"wh3_main_combi_region_waterfall_palace",
					"wh3_main_combi_region_vauls_anvil_loren",
					"wh3_main_combi_region_crag_halls_of_findol",
					"wh3_main_combi_region_kings_glade",
				},
			}
		},
		skaven_blight = {
			trigger_function = function(self, faction) legendary_grudges:trigger_skaven_blight_grudge(faction) end,
			mission_key = "wh3_dlc25_grudge_legendary_skaven_blight",
			payloads = {
				effect_bundle = "wh3_dlc25_legendary_grudge_skaven_reward",
				pooled_resource = {
					{
						key = "wh3_dlc25_dwf_grudge_points",
						factor = "settled",
						amount = 2500
					},
				},
			},
			target_faction_list = {
				main_warhammer = {
					"wh2_main_skv_clan_skryre",
					"wh2_main_skv_clan_moulder",
				},
				wh3_main_chaos = {
					"wh2_main_skv_clan_moulder",
				},
			},
			target_region_list = {
				main_warhammer = {
					"wh3_main_combi_region_skavenblight",
					"wh3_main_combi_region_hell_pit",
				},
				wh3_main_chaos = {
					"wh3_main_chaos_region_hell_pit",
				}
			}
		},
		karak_zorn = {
			trigger_function = function(self, faction) legendary_grudges:trigger_karak_zorn_grudge(faction) end,
			mission_key = "wh3_dlc25_grudge_legendary_karak_zorn",
			payloads = {
				pooled_resource = {
					{
						key = "dwf_oathgold",
						factor = "missions",
						amount = 2500
					},
					{
						key = "wh3_dlc25_dwf_grudge_points",
						factor = "settled",
						amount = 2500
					}
				},
			},
			target_building = "wh3_dlc25_special_ancestors_hall_1",
			target_faction_list = {
				"wh2_main_hef_order_of_loremasters",
				"wh_main_vmp_vampire_counts",
				"wh2_main_lzd_last_defenders",
				"wh2_dlc09_tmb_lybaras",
				"wh3_main_kho_exiles_of_khorne",
			},
		},
		high_elves = {
			trigger_function = function(self, faction) legendary_grudges:trigger_high_elves_grudge(faction) end,
			mission_key = "wh3_dlc25_grudge_legendary_high_elves",
			payloads = {
				effect_bundle = "wh3_dlc25_grudge_reward_dwf_high_elves_defeated",
				pooled_resource = {
					{
						key = "wh3_dlc25_dwf_grudge_points",
						factor = "settled",
						amount = 2500
					},
				},
				ancillaries = {
					"wh2_main_anc_weapon_reaver_bow",
					"wh2_main_anc_armour_crown_of_authority",
					"wh2_main_anc_talisman_amulet_of_foresight",
					"wh2_main_anc_weapon_winged_staff",
					"wh2_main_anc_enchanted_item_enchanted_spyglass",
					"wh2_main_anc_talisman_ruby_guardian_phoenix",
					"wh2_main_anc_armour_helm_of_khaine",
					"wh2_main_anc_enchanted_item_blessed_tome",
					"wh2_main_anc_talisman_sapphire_guardian_phoenix",
					"wh2_main_anc_weapon_blade_of_sea_gold",
					"wh2_main_anc_enchanted_item_chest_of_sustenance",
					"wh2_main_anc_enchanted_item_gilded_horn_of_galon_konook",
					"wh2_main_anc_armour_winged_boots",
					"wh2_main_anc_talisman_diamond_guardian_phoenix",
					"wh2_main_anc_weapon_sea_gold_parrying_blade",
					"wh2_main_anc_talisman_emerald_collar",
					"wh2_main_anc_armour_enchanted_ithilmar_breastplate",
					"wh2_main_anc_enchanted_item_ring_of_hukon"
				},
				building_unlock = "wh3_dlc25_special_hall_of_dragons_dwf",
				landmark_region = "wh3_main_combi_region_vauls_anvil_ulthuan",
			},
			target_faction_list = {
				"wh2_main_hef_avelorn",
				"wh2_main_hef_yvresse",
				"wh2_main_hef_eataine",
			},
			target_region_list = {
				main_warhammer = {
					"wh3_main_combi_region_lothern",
					"wh3_main_combi_region_tor_yvresse",
					"wh3_main_combi_region_gaean_vale",
				},
			},
		},
	},
}


function legendary_grudges:initialise()
	local campaign = cm:get_campaign_name()
	self.playable_dwarf_factions = cm:get_human_factions_of_culture(self.dwarf_culture)

	if #self.playable_dwarf_factions >= 1 then
		for _,faction in ipairs(self.playable_dwarf_factions) do

			for _,mission_key in ipairs(self.mission_key_list[campaign]) do
				local mission_data = self.missions[self.mission_key_to_data_key[mission_key]]
				mission_data:trigger_function(faction)
			end
			
			-- Locking landmark buildings for grudge rewards
			if cm:is_new_game() then
				for _,building in ipairs(self.building_locks) do
					self:lock_buildings(building, faction)
				end
			end
		end
	end

	self:mission_reward_handler()

	if self.should_spawn_foe_armies then
		local target_region = self.missions.silver_pinnacle.target_region_list[campaign][1]
		local faction_owning_region = cm:get_region(target_region):owning_faction():name()

		self:handle_spawning_foe_armies(faction_owning_region, self.missions.silver_pinnacle)
	end

	if self:is_item_in_list(self.missions.high_elves.mission_key, self.completed_missions) then
		local data_set = cm:get_saved_value("completed_high_elf_grudge_data")
		if data_set ~= nil then
			if data_set.is_built then
				self:start_ancillary_rewarding(data_set.faction)
			end
			self:setup_listener_for_ancillary_building_construction()
		end
	end
end


function legendary_grudges:trigger_karaz_ankor_grudge(faction_key)
	local mission_data = self.missions.karaz_ankor
	local mm = mission_manager:new(faction_key, mission_data.mission_key)
	local objective_key = "mission_text_text_scripted_rebuild_karaz_ankor"
	local script_key = mission_data.mission_key.."_"..faction_key

	mm:set_mission_issuer(self.mission_issuer)
	self:setup_occupy_provinces_mission_condition(mm, mission_data, objective_key, script_key)
	self:setup_mission_payload(mm, mission_data.payloads)
	if not self:is_item_in_list(mission_data.mission_key, self.active_missions[faction_key]) then
		mm:trigger()
		self:add_to_active_mission_tracker(faction_key, mission_data.mission_key)
	end
end


function legendary_grudges:trigger_chaos_dwarfs_grudge(faction_key)
	local mission_data = self.missions.chaos_dwarfs
	local mm = mission_manager:new(faction_key, mission_data.mission_key)

	mm:set_mission_issuer(self.mission_issuer)
	self:setup_destroy_factions_mission_condition(mm, mission_data.target_faction_list)

	self:setup_mission_payload(mm, mission_data.payloads)

	if not self:is_item_in_list(mission_data.mission_key, self.active_missions[faction_key]) then
		mm:trigger()
		self:add_to_active_mission_tracker(faction_key, mission_data.mission_key)
	end
end


function legendary_grudges:trigger_silver_pinnacle_grudge(faction_key)
	local mission_data = self.missions.silver_pinnacle
	local mm = mission_manager:new(faction_key, mission_data.mission_key)
	local objective_key = "mission_text_text_scripted_secure_silver_pinnacle"
	local script_key = mission_data.mission_key.."_"..faction_key
	local campaign = cm:get_campaign_name()
	local first_entry = 1
	local target_region = mission_data.target_region_list[campaign][first_entry]

	mm:set_mission_issuer(self.mission_issuer)
	mm:set_victory_mission(true)
	mm:set_victory_type("false")
	self:setup_occupy_regions_mission_condition(mm, mission_data, objective_key, script_key, true)

	self:setup_mission_payload(mm, mission_data.payloads)

	self:setup_construct_building_mission_condition(mm, mission_data.target_building, faction_key, true)

	if not self:is_item_in_list(mission_data.mission_key, self.active_missions[faction_key]) then
		mm:trigger()
		self:add_to_active_mission_tracker(faction_key, mission_data.mission_key)
	end

	cm:callback(
		function()
			cm:set_scripted_mission_entity_completion_states(mission_data.mission_key, script_key, {{cm:get_region(target_region), false}})
		end,
		1.0
	)

	core:add_listener(
		objective_key .. "_construction_completed_spawn_armies",
		"BuildingConstructionIssuedByPlayer",
		function(context)
			return context:garrison_residence():region():name() == target_region and context:building() == mission_data.target_building
		end,
		function()
			self.should_spawn_foe_armies = true
			cm:set_saved_value("spawn_foe_armies" .. mission_data.mission_key, true)
			self:handle_spawning_foe_armies(faction_key, mission_data)
		end,
		true
	)
end


function legendary_grudges:trigger_karak_eight_peaks_grudge(faction_key)
	local mission_data = self.missions.eight_peaks
	local mm = mission_manager:new(faction_key, mission_data.mission_key)
	local objective_key = "mission_text_text_scripted_retake_karak_eight_peaks"
	local script_key = mission_data.mission_key.."_"..faction_key

	mm:set_mission_issuer(self.mission_issuer)
	mm:set_victory_mission(value)
	mm:set_victory_type("false")
	self:setup_destroy_factions_mission_condition(mm, mission_data.target_faction_list, true)

	self:setup_mission_payload(mm, mission_data.payloads)
	self:setup_occupy_regions_mission_condition(mm, mission_data, objective_key, script_key, true)

	if not self:is_item_in_list(mission_data.mission_key, self.active_missions[faction_key]) then
		mm:trigger()
		self:add_to_active_mission_tracker(faction_key, mission_data.mission_key)
	end
end


function legendary_grudges:trigger_malekith_grudge(faction_key)
	local mission_data = self.missions.malekith
	local mm = mission_manager:new(faction_key, mission_data.mission_key)
	local objective_key = "mission_text_text_scripted_destroy_malekith_and_friends"
	local script_key = mission_data.mission_key.."_"..faction_key

	mm:set_mission_issuer(self.mission_issuer)
	mm:set_victory_mission(true)
	mm:set_victory_type("false")
	self:setup_destroy_factions_mission_condition(mm, mission_data.target_faction_list, true)

	self:setup_mission_payload(mm, mission_data.payloads)
	self:setup_occupy_regions_mission_condition(mm, mission_data, objective_key, script_key, true)

	if not self:is_item_in_list(mission_data.mission_key, self.active_missions[faction_key]) then
		mm:trigger()
		self:add_to_active_mission_tracker(faction_key, mission_data.mission_key)
	end
end


function legendary_grudges:trigger_norse_dwarf_grudge(faction_key)
	local mission_data = self.missions.norse_dwarfs
	local mm = mission_manager:new(faction_key, mission_data.mission_key)
	local objective_key = "mission_text_text_scripted_grudge_norse_dwarfs"
	local script_key = mission_data.mission_key.."_"..faction_key

	mm:set_mission_issuer(self.mission_issuer)
	self:setup_occupy_regions_mission_condition(mm, mission_data, objective_key, script_key)
	
	self:setup_mission_payload(mm, mission_data.payloads)

	if not self:is_item_in_list(mission_data.mission_key, self.active_missions[faction_key]) then
		mm:trigger()
		self:add_to_active_mission_tracker(faction_key, mission_data.mission_key)
	end
end


function legendary_grudges:trigger_athel_loren_grudge(faction_key)
	local mission_data = self.missions.athel_loren
	local mm = mission_manager:new(faction_key, mission_data.mission_key)
	local objective_key = "mission_text_text_scripted_grudge_athel_loren"
	local script_key = mission_data.mission_key.."_"..faction_key

	mm:set_mission_issuer(self.mission_issuer)
	mm:set_victory_mission(true)
	mm:set_victory_type("false")
	self:setup_destroy_factions_mission_condition(mm, mission_data.target_faction_list, true)

	self:setup_mission_payload(mm, mission_data.payloads)
	self:setup_occupy_regions_mission_condition(mm, mission_data, objective_key, script_key, true)

	if not self:is_item_in_list(mission_data.mission_key, self.active_missions[faction_key]) then
		mm:trigger()
		self:add_to_active_mission_tracker(faction_key, mission_data.mission_key)
	end
end


function legendary_grudges:trigger_skaven_blight_grudge(faction_key)
	local mission_data = self.missions.skaven_blight
	local mm = mission_manager:new(faction_key, mission_data.mission_key)
	local objective_key = "mission_text_text_scripted_grudge_skaven_blight"
	local script_key = mission_data.mission_key.."_"..faction_key

	mm:set_mission_issuer(self.mission_issuer)
	mm:set_victory_mission(true)
	mm:set_victory_type("false")
	self:setup_destroy_factions_mission_condition(mm, mission_data.target_faction_list[cm:get_campaign_name()], true)

	self:setup_mission_payload(mm, mission_data.payloads)
	self:setup_occupy_regions_mission_condition(mm, mission_data, objective_key, script_key, true)

	if not self:is_item_in_list(mission_data.mission_key, self.active_missions[faction_key]) then
		mm:trigger()
		self:add_to_active_mission_tracker(faction_key, mission_data.mission_key)
	end
end


function legendary_grudges:trigger_karak_zorn_grudge(faction_key)
	local mission_data = self.missions.karak_zorn
	local mm = mission_manager:new(faction_key, mission_data.mission_key)
	local objective_key = "mission_text_text_scripted_grudge_karak_zorn"
	local script_key = mission_data.mission_key.."_"..faction_key

	mm:set_mission_issuer(self.mission_issuer)
	mm:set_victory_mission(true)
	mm:set_victory_type("false")
	self:setup_destroy_factions_mission_condition(mm, mission_data.target_faction_list, true)

	self:setup_mission_payload(mm, mission_data.payloads)
	self:setup_construct_building_mission_condition(mm, mission_data.target_building, faction_key, true)

	if not self:is_item_in_list(mission_data.mission_key, self.active_missions[faction_key]) then
		mm:trigger()
		self:add_to_active_mission_tracker(faction_key, mission_data.mission_key)
	end
end


function legendary_grudges:trigger_high_elves_grudge(faction_key)
	local mission_data = self.missions.high_elves
	local mm = mission_manager:new(faction_key, mission_data.mission_key)
	local objective_key = "mission_text_text_scripted_grudge_high_elves"
	local script_key = mission_data.mission_key.."_"..faction_key

	mm:set_mission_issuer(self.mission_issuer)
	mm:set_victory_mission(true)
	mm:set_victory_type("false")
	self:setup_destroy_factions_mission_condition(mm, mission_data.target_faction_list, true)

	self:setup_mission_payload(mm, mission_data.payloads)
	self:setup_occupy_regions_mission_condition(mm, mission_data, objective_key, script_key, true)

	if not self:is_item_in_list(mission_data.mission_key, self.active_missions[faction_key]) then
		mm:trigger()
		self:add_to_active_mission_tracker(faction_key, mission_data.mission_key)
	end
end

---------------------
-- Mission Setup ----
---------------------

function legendary_grudges:setup_mission_payload(mission_manager, payload_data)
	if payload_data.effect_bundle ~= nil then
		mission_manager:add_payload("effect_bundle{bundle_key " .. payload_data.effect_bundle .. ";turns 0;}")
	end

	if payload_data.treasury ~= nil then
		mission_manager:add_payload("money " .. payload_data.treasury)
	end

	if payload_data.pooled_resource ~= nil then
		for _,payload in ipairs(payload_data.pooled_resource) do
			mission_manager:add_payload(self:generate_pooled_resource_payload_string(payload))
		end
	end
end


function legendary_grudges:setup_destroy_factions_mission_condition(mission_manager, target_faction_list, add_to_primary)
	local add_to_primary = add_to_primary or nil
	mission_manager:add_new_objective("DESTROY_FACTION", add_to_primary)
	for _,v in ipairs(target_faction_list) do
		mission_manager:add_condition("faction " .. v);
	end
	mission_manager:add_condition("confederation_valid");
end


function legendary_grudges:setup_occupy_regions_mission_condition(mission_manager, mission_data, objective_key, script_key, add_to_primary)
	local regions_to_add = {}
	local campaign = cm:get_campaign_name()
	if mission_data.target_region_list[campaign] ~= nil then
		for _,region in pairs(mission_data.target_region_list[campaign]) do
			local region_interface = cm:get_region(region)
			if region_interface:owning_faction():culture() == self.dwarf_culture then
				table.insert(regions_to_add, {region_interface, true})
			else
				table.insert(regions_to_add, {region_interface, false})
			end
		end
	end

	local add_to_primary = add_to_primary or nil
	mission_manager:add_new_objective("SCRIPTED", add_to_primary)
	mission_manager:add_condition("override_text " .. objective_key)
	mission_manager:add_condition("script_key " .. script_key)

	cm:callback(
		function()
			cm:set_scripted_mission_entity_completion_states(mission_data.mission_key, script_key, regions_to_add)
		end,
		1.0
	)

	core:add_listener(
		objective_key,
		"RegionFactionChangeEvent",
		function(context)
			local region = context:region()
			local region_owner = region:owning_faction()
			local previous_faction = context:previous_faction():name()

			if mission_data.target_region_list[campaign] ~= nil then
				if self:is_item_in_list(region:name(), mission_data.target_region_list[campaign]) then
					return previous_faction == self.dwarf_culture or region_owner:culture() == self.dwarf_culture
				end
			end
			return false
		end,
		function(context)
			local region = context:region()
			local region_owner = region:owning_faction()
			local previous_faction = context:previous_faction():culture()

			if region_owner:culture() == self.dwarf_culture then
				cm:set_scripted_mission_entity_completion_states(mission_data.mission_key, script_key, {{region, true}})
			elseif previous_faction == self.dwarf_culture then
				cm:set_scripted_mission_entity_completion_states(mission_data.mission_key, script_key, {{region, false}})
			end
			if self:are_all_target_regions_dwarf_owned(mission_data.target_region_list[campaign]) then
				self:complete_scripted_objective_for_all_human_dwarfs_players(mission_data.mission_key, script_key)
				core:remove_listener(objective_key)
			end
		end,
		true
	)
end


function legendary_grudges:setup_occupy_provinces_mission_condition(mission_manager, mission_data, objective_key, script_key, add_to_primary)
	local provinces_to_add = {}
	local campaign = cm:get_campaign_name()
	for _,province in pairs(mission_data.target_province_list[campaign]) do
		local province_interface = cm:get_province(province)
		if self:is_province_dwarf_owned(province) then
			table.insert(provinces_to_add, {province_interface, true})
		else
			table.insert(provinces_to_add, {province_interface, false})
		end
	end

	local add_to_primary = add_to_primary or nil
	mission_manager:add_new_objective("SCRIPTED", add_to_primary)
	mission_manager:add_condition("override_text " .. objective_key)
	mission_manager:add_condition("script_key " .. script_key)

	cm:callback(
		function()
			cm:set_scripted_mission_entity_completion_states(mission_data.mission_key, script_key, provinces_to_add)
		end,
		1.0
	)

	core:add_listener(
		objective_key,
		"RegionFactionChangeEvent",
		function(context)
			local region = context:region()
			local region_owner = region:owning_faction()
			local previous_faction = context:previous_faction():name()

			if self:is_item_in_list(region:name(), self:get_regions_from_provinces(mission_data.target_province_list[campaign])) then
				return previous_faction == self.dwarf_culture or region_owner:culture() == self.dwarf_culture
			end
			return false
		end,
		function(context)
			local region = context:region()
			local province = region:province()

			if not self:is_province_dwarf_owned(province:key()) then return end

			cm:set_scripted_mission_entity_completion_states(mission_data.mission_key, script_key, {{province, true}})

			if self:are_all_target_provinces_dwarf_owned(mission_data.target_province_list[campaign]) then
				self:complete_scripted_objective_for_all_human_dwarfs_players(mission_data.mission_key, script_key)
				core:remove_listener(objective_key)
			end
		end,
		true
	)
end


function legendary_grudges:setup_construct_building_mission_condition(mission_manager, target_building, faction_key, add_to_primary)
	local add_to_primary = add_to_primary or nil
	mission_manager:add_new_objective("CONSTRUCT_N_BUILDINGS_INCLUDING", add_to_primary)
	mission_manager:add_condition("total 1")
	mission_manager:add_condition("building_level " .. target_building)
	mission_manager:add_condition("faction ".. faction_key)
end

---------------------
-- Functionality ----
---------------------

function legendary_grudges:lock_buildings(building, faction)
	cm:add_event_restricted_building_record_for_faction(building, faction, "legendary_grudge_landmark_building_lock_reason")
end

function legendary_grudges:unlock_building(building, faction)
	cm:remove_event_restricted_building_record_for_faction(building, faction)
end


function legendary_grudges:are_all_target_regions_dwarf_owned(region_list, opt_target_region_count)
	local owned_region_count = 0

	for _,region in ipairs(region_list) do
		local region_interface = cm:get_region(region)
		if region_interface:owning_faction():culture() == self.dwarf_culture then
			owned_region_count = owned_region_count + 1
		end
	end

	local target_count = opt_target_region_count or #region_list
	return owned_region_count >= target_count
end


function legendary_grudges:is_province_dwarf_owned(province)
	local region_list = cm:get_province(province):regions()
	for i = 0, region_list:num_items() - 1 do
		if region_list:item_at(i):owning_faction():culture() ~= self.dwarf_culture then return end
	end
	return true
end


function legendary_grudges:are_all_target_provinces_dwarf_owned(province_list, opt_target_province_count)
	local owned_province_count = 0

	for _,province in ipairs(province_list) do
		if self:is_province_dwarf_owned(province) then
			owned_province_count = owned_province_count + 1
		end
	end

	local target_count = opt_target_province_count or #province_list
	return owned_province_count >= target_count
end


function legendary_grudges:handle_spawning_foe_armies(targetted_faction, mission_data)
	core:add_listener(
		"spawn_foe_army_" .. mission_data.mission_key,
		"FactionTurnStart",
		function(context)
			return context:faction():name() == targetted_faction
		end,
		function()
			local spawner_time = cm:get_saved_value("spawner_countdown" .. mission_data.mission_key) or 9
			local armies_to_spawn_count = 0
			if spawner_time >= 9 then
				armies_to_spawn_count = 2
			elseif spawner_time == 6 then
				armies_to_spawn_count = 4
			elseif spawner_time == 3 then
				armies_to_spawn_count = 6
			end

			for i = 1, armies_to_spawn_count do
				local invasion_key = "grudge_invasion_" .. mission_data.mission_key .. "_" .. i
				self:spawn_ai_army(mission_data.force_data, invasion_key, mission_data.spawn_region, mission_data.target_region_list)
			end

			cm:set_saved_value("spawner_countdown" .. mission_data.mission_key, spawner_time - 1)
		end,
		true
	)
end


function legendary_grudges:stop_spawning_foe_armies(mission_key)
	self.should_spawn_foe_armies = false
	cm:set_saved_value("spawn_foe_armies" .. mission_key, false)
	core:remove_listener("spawn_foe_army_" .. mission_key)
	cm:set_saved_value("spawner_countdown" .. mission_key, nil)
end


function legendary_grudges:spawn_ai_army(spawn_force_data, invasion_key, spawn_region, target_region)
	local campaign = cm:get_campaign_name()
	local spawn_region = spawn_region[campaign]
	local item = 1
	local target_region = target_region[campaign][item]
	local faction_owning_region = cm:get_region(target_region):owning_faction():name()

	local force_size =spawn_force_data.force_size
	local force_power = self:calculate_random_battle_power()

	local x,y = cm:find_valid_spawn_location_for_character_from_settlement(faction_owning_region, spawn_region, false, true, cm:random_number(40, 15))
	local coordinates = {x, y}
	local force_list = WH_Random_Army_Generator:generate_random_army(invasion_key, spawn_force_data.template_key, force_size, force_power, true, false)
	
	local invasion
	if invasion_manager:get_invasion(invasion_key) ~= false then
		invasion = invasion_manager:get_invasion(invasion_key)
	else
		invasion = invasion_manager:new_invasion(invasion_key, spawn_force_data.faction_key, force_list, coordinates)		
		
		local difficulty = cm:get_difficulty(true)
		if difficulty == "hard" then
			invasion:add_character_experience(8, true)
			invasion:add_unit_experience(2);
		elseif difficulty == "very hard" then
			invasion:add_character_experience(16, true)
			invasion:add_unit_experience(4);
		elseif difficulty == "legendary" then
			invasion:add_character_experience(30, true)
			invasion:add_unit_experience(7);
		end
		
		invasion:set_target("REGION", target_region, faction_owning_region)
		invasion:start_invasion()
		
		invasion:apply_effect(self.invasion_effect_bundles.no_upkeep, -1)
		invasion:apply_effect(self.invasion_effect_bundles.region_attrition_immune, -1)
		
		cm:force_diplomacy("faction:" .. spawn_force_data.faction_key, "all", "all", false, false, true)
		cm:force_declare_war(spawn_force_data.faction_key, faction_owning_region, false, false)
	end

	return invasion
end


function legendary_grudges:calculate_random_battle_power()
	local turn_number = cm:turn_number()
	local turn_mod = 0
	local difficulty_mod = 0
	
	if turn_number <= 10 then
		turn_mod = 1
	elseif turn_number <= 20 then
		turn_mod = 2
	elseif turn_number <= 40 then
		turn_mod = 3
	elseif turn_number <= 50 then
		turn_mod = 4
	elseif turn_number <= 75 then
		turn_mod = 5
	elseif turn_number < 100 then
		turn_mod = 6
	else
		turn_mod = 7
	end
	
	if cm:get_difficulty() < 2 then
		difficulty_mod = 2
	elseif cm:get_difficulty() >= 3 then
		difficulty_mod = 4
	else
		difficulty_mod = 3
	end
	
	return turn_mod + difficulty_mod
end


function legendary_grudges:get_regions_from_provinces(province_list)
	local regions_list = {}
	for _,v in ipairs(province_list) do
		local region_list = cm:get_province(v):regions()
		for i = 0, region_list:num_items() - 1 do
			table.insert(regions_list, region_list:item_at(i):name())
		end
	end
	return regions_list
end


function legendary_grudges:complete_scripted_objective_for_all_human_dwarfs_players(mission_key, script_key)
	local human_dwarf_factions = cm:get_human_factions_of_culture(self.dwarf_culture)
	for _,v in ipairs(human_dwarf_factions) do
		cm:complete_scripted_mission_objective(v, mission_key, script_key, true)
	end
end


function legendary_grudges:generate_pooled_resource_payload_string(pooled_resource_payload)
	local key = pooled_resource_payload.key
	local factor =pooled_resource_payload.factor
	local amount = pooled_resource_payload.amount

	return "faction_pooled_resource_transaction{resource "..key..";factor "..factor..";amount "..amount..";context absolute;}"
end


function legendary_grudges:mission_reward_handler()
	core:add_listener(
		"legendary_grudges_reward_handler_listener",
		"MissionSucceeded",
		function(context)
			return self:is_item_in_list(context:mission():mission_record_key(), self.mission_key_list[cm:get_campaign_name()])
		end,
		function(context)
			local mission_key = context:mission():mission_record_key()
			local faction_key = context:faction():name()
			local mission_data = self.missions[self.mission_key_to_data_key[mission_key]]
			local payloads = mission_data.payloads

			table.insert(self.completed_missions, mission_key)

			if payloads.teleport_rituals ~= nil then
				self:unlock_underway_teleport_rituals(payloads.teleport_rituals[cm:get_campaign_name()])
			end

			if payloads.ancillaries ~= nil then
				self:reward_ancillaries_to_factions(payloads.ancillaries)
			end
			
			if payloads.building_unlock ~= nil then
				self:unlock_building(payloads.building_unlock, faction_key)
			end

			-- bespoke functionality
			if mission_key == self.missions.silver_pinnacle.mission_key then
				self:stop_spawning_foe_armies(self.missions.silver_pinnacle.mission_key)
			end

			if mission_key == self.missions.malekith.mission_key then
				self:spawn_unique_lord_for_dwarf_factions()
			end

			if mission_key == self.missions.karak_zorn.mission_key then
				self.playable_dwarf_factions = cm:get_human_factions_of_culture(self.dwarf_culture)
				for _,faction in ipairs(self.playable_dwarf_factions) do
					if not faction == faction_key then
						cm:faction_add_pooled_resource(faction, "dwf_oathgold", "grudges", 2500)
					end
				end
			end

			if mission_key == self.missions.high_elves.mission_key then
				self:setup_listener_for_ancillary_building_construction()
			end
		end,
		true
	)
end

--------------------------------------------
------------ Reward Functions --------------
--------------------------------------------

function legendary_grudges:spawn_unique_lord_for_dwarf_factions()
	-- unique lord data
	unique_lord = {
		age = 18,
		is_male = true,
		agent = "general",
		agent_subtype = "wh3_dlc25_dwf_lord_mikael_leadstrong",
		is_immortal = true
	}

	for _,faction_name in ipairs(self.playable_dwarf_factions) do
		local random_number = cm:random_number(#self.playable_dwarf_factions)
		local lord_name = self.unique_lord_name_list[random_number]
		table.remove(self.unique_lord_name_list, random_number)

		cm:spawn_character_to_pool(
			faction_name,
			lord_name,
			"",
			"",
			"",
			unique_lord.age,
			unique_lord.is_male,
			unique_lord.agent,
			unique_lord.agent_subtype,
			unique_lord.is_immortal,
			""
		)
	end
end


function legendary_grudges:unlock_underway_teleport_rituals(ritual_list)
	local human_dwarf_factions = cm:get_human_factions_of_culture(self.dwarf_culture)
	if #human_dwarf_factions >= 1 then
		for _,faction in ipairs(human_dwarf_factions) do
			for i = 1, #ritual_list do
				cm:unlock_ritual(cm:get_faction(faction), ritual_list[i], -1)
			end
		end
	end
end


function legendary_grudges:reward_ancillaries_to_factions(ancillary_list)
	for _,faction in ipairs(self.playable_dwarf_factions) do
		local random_number = cm:random_number(#ancillary_list)
		cm:add_ancillary_to_faction(cm:get_faction(faction), ancillary_list[random_number], false)
		table.remove(ancillary_list, random_number)
	end
end


function legendary_grudges:setup_listener_for_ancillary_building_construction()
	core:add_listener(
		"LG_add_ancillary_to_faction",
		"BuildingCompleted",
		function(context)
			return context:building():name() == self.missions.high_elves.payloads.building_unlock
		end,
		function(context)
			local faction = context:building():faction():name()
			local data_set = {
				is_built = true,
				faction = faction
			}
			cm:set_saved_value("completed_high_elf_grudge_data", data_set)
			self:start_ancillary_rewarding(faction)
		end,
		true
	)

	core:add_listener(
		"LG_add_ancillary_to_faction_settlement_lost",
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			local region = context:garrison_residence():region():name()
			return region == self.missions.high_elves.payloads.landmark_region and context:previous_owner() == cm:get_saved_value("completed_high_elf_grudge_data").faction
		end,
		function()
			local data_set = {
				is_built = false,
				faction = ""
			}
			cm:set_saved_value("completed_high_elf_grudge_data", data_set)
			core:remove_listener("LG_add_ancillary_to_faction")
		end,
		true
	)
end

function legendary_grudges:start_ancillary_rewarding(target_faction)
	core:add_listener(
		"LG_add_ancillary_to_faction",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == target_faction
		end,
		function(context)
			local counter_tracker = cm:get_saved_value("LG_random_ancillary_rewarding_counter") or self.ancillary_reward_cooldown
			local faction = context:faction():name()
			local ancillary_list = self.missions.high_elves.payloads.ancillaries

			counter_tracker = counter_tracker - 1
			if counter_tracker <= 0 then
				counter_tracker = 5
				local ancillary = ancillary_list[cm:random_number(#ancillary_list)]
				cm:trigger_custom_incident(faction, "wh3_dlc25_dwf_bog_ancillary_items", true, "payload{add_ancillary_to_faction_pool{ancillary_key " .. ancillary .. ";}}")
			end
			cm:set_saved_value("LG_random_ancillary_rewarding_counter", counter_tracker)
		end,
		true
	)
end

--------------------------------------------
------------ Helper Functions --------------
--------------------------------------------

function legendary_grudges:add_to_active_mission_tracker(faction_key, mission_key)
	if self.active_missions[faction_key] == nil then
		self.active_missions[faction_key] = {mission_key}
	else
		table.insert(self.active_missions[faction_key], mission_key)
	end
end

function legendary_grudges:is_item_in_list(item, list)
	if list ~= nil then
		for i = 1, #list do
			if item == list[i] then return true end
		end
	end
	return false
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
    function(context)
		cm:save_named_value("completed_legendary_grudges", legendary_grudges.completed_missions, context)
		cm:save_named_value("active_legendary_grudges", legendary_grudges.active_missions, context)
		cm:save_named_value("spawn_foe_armies", legendary_grudges.should_spawn_foe_armies, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			legendary_grudges.completed_missions = cm:load_named_value("completed_legendary_grudges", legendary_grudges.completed_missions, context)
			legendary_grudges.active_missions = cm:load_named_value("active_legendary_grudges", legendary_grudges.active_missions, context)
			legendary_grudges.should_spawn_foe_armies = cm:load_named_value("spawn_foe_armies", legendary_grudges.should_spawn_foe_armies, context)
		end
	end
)