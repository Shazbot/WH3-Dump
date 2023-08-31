
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	QUESTS
--	This script kicks off character quests when they rank up to the required level
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function q_setup()
	local quests = {
		["wh3_main_ksl_katarin"] = {
			{"mission", "wh3_main_anc_weapon_frost_fang", "wh3_main_ie_qb_ksl_katarin_frost_fang"},
			{"mission", "wh3_main_anc_armour_the_crystal_cloak", "wh3_main_qb_ksl_katarin_crystal_cloak", nil, "wh3_main_camp_quest_katarin_the_crystal_cloak_001"}
		},
		["wh3_main_ksl_kostaltyn"] = {
			{"mission", "wh3_main_anc_weapon_the_burning_brazier", "wh3_main_qb_ksl_kostaltyn_burning_brazier", nil, "wh3_main_camp_quest_kostaltyn_burning_brazier_001"}
		},
		["wh3_main_ksl_boris"] = {
			{"mission", "wh3_main_anc_weapon_shard_blade", "wh3_main_ie_qb_ksl_boris_shard_blade"},
			{"mission", "wh3_main_anc_armour_armour_of_ursun", "wh3_main_ie_qb_ksl_boris_armour_of_ursun"}
		},
		["wh3_dlc24_ksl_mother_ostankya"] = {
			{"mission", "wh3_dlc24_anc_enchanted_item_cauldron_of_power", "wh3_dlc24_qb_ksl_mother_ostankya_cauldron_of_power"},
			{"mission", "wh3_dlc24_anc_arcane_item_crown_of_claws", "wh3_dlc24_qb_ksl_mother_ostankya_crown_of_claws", nil, "wh3_dlc24_mother_ostankya_cam_quest_mission.001"}
		},
		["wh3_main_ogr_greasus_goldtooth"] = {
			{"mission", "wh3_main_anc_weapon_sceptre_of_titans", "wh3_main_ie_qb_ogr_greasus_sceptre_of_titans"},
			{"mission", "wh3_main_anc_talisman_overtyrants_crown", "wh3_main_qb_ogr_greasus_overtyrants_crown", nil, "wh3_main_camp_quest_greasus_overtyrants_crown_001"}
		},
		["wh3_main_ogr_skrag_the_slaughterer"] = {
			{"mission", "wh3_main_anc_enchanted_item_cauldron_of_the_great_maw", "wh3_main_qb_ogr_skrag_cauldron_of_the_great_maw", nil, "wh3_main_camp_quest_skrag_cauldron_of_the_great_maw_001"}
		},
		["wh3_main_kho_skarbrand"] = {
			{"mission", "wh3_main_anc_weapon_slaughter_and_carnage", "wh3_main_qb_kho_skarbrand_slaughter_and_carnage", nil, "wh3_main_camp_quest_skarbrand_slaughter_and_carnage_001"}
		},
		["wh3_main_nur_kugath"] = {
			{"mission", "wh3_main_anc_weapon_necrotic_missiles", "wh3_main_qb_nur_kugath_necrotic_missiles", nil, "wh3_main_camp_quest_kugath_necrotic_missiles_001"}
		},
		["wh3_main_sla_nkari"] = {
			{"mission", "wh3_main_anc_weapon_witstealer_sword", "wh3_main_qb_sla_nkari_witstealer_sword", nil, "wh3_main_camp_quest_nkari_witstealer_sword_001"}
		},
		["wh3_main_tze_kairos"] = {
			{"mission", "wh3_main_anc_arcane_item_staff_of_tomorrow", "wh3_main_qb_tze_kairos_staff_of_tomorrow", nil, "wh3_main_camp_quest_kairos_staff_of_tomorrow_001"}
		},
		["wh3_dlc24_tze_the_changeling"] = {
			{"mission", "wh3_dlc24_anc_arcane_item_the_tricksters_staff", "wh3_dlc24_qb_tze_the_changeling_the_tricksters_staff", nil, "wh3_dlc24_the_changeling_cam_quest_mission.001"}
		},
		["wh3_main_cth_miao_ying"] = {
			{"mission", "wh3_dlc24_anc_armour_storm_wind_coronal", "wh3_dlc24_qb_cth_miao_ying_storm_wind_coronal"},
			{"mission", "wh3_dlc24_anc_enchanted_item_vambraces_of_yin", "wh3_dlc24_qb_cth_miao_ying_vambraces_of_yin"}
		},
		["wh3_main_cth_zhao_ming"] = {
			{"mission", "wh3_dlc24_anc_armour_horns_of_shang_yang", "wh3_dlc24_qb_cth_zhao_ming_horns_of_shang_yang"},
			{"mission", "wh3_dlc24_anc_enchanted_item_the_burning_vambraces", "wh3_dlc24_qb_cth_zhao_ming_the_burning_vambraces"}
		},
		["wh3_dlc24_cth_yuan_bo"] = {
			{"mission", "wh3_dlc24_anc_armour_armour_of_the_dragons_gaze", "wh3_dlc24_qb_cth_yuan_bo_armour_of_the_dragons_gaze"},
			{"mission", "wh3_dlc24_anc_weapon_the_dragons_fang", "wh3_dlc24_qb_cth_yuan_bo_dragons_fang", nil, "wh3_dlc24_yuan_bo_cam_quest_mission.001"}
		},
		----------------------
		------ CHAMPIONS -----
		----------------------
		["wh3_dlc20_sla_azazel"] = {
			{"mission", "wh3_dlc20_anc_weapon_daemonblade", "wh3_dlc20_qb_chs_azazel_daemonblade", nil, "wh3_dlc20_azazel_cam_quest_mission_001"}
		},
		["wh3_dlc20_nur_festus"] = {
			{"mission", "wh3_dlc20_anc_enchanted_item_pestilent_potions", "wh3_dlc20_qb_chs_festus_pestilent_potions", nil, "wh3_dlc20_festus_cam_quest_mission_001"}
		},
		["wh3_dlc20_kho_valkia"] = {
			{"mission", "wh3_dlc20_anc_armour_the_scarlet_armour", "wh3_dlc20_qb_chs_valkia_the_scarlet_armour"},
			{"mission", "wh3_dlc20_anc_enchanted_item_daemonshield", "wh3_dlc20_qb_chs_valkia_daemonshield"},
			{"mission", "wh3_dlc20_anc_weapon_the_spear_slaupnir", "wh3_dlc20_qb_chs_valkia_the_spear_slaupnir", nil, "wh3_dlc20_valkia_cam_quest_mission_001"}
		},
		["wh3_dlc20_tze_vilitch"] = {
			{"mission", "wh3_dlc20_anc_arcane_item_vessel_of_chaos", "wh3_dlc20_qb_chs_vilitch_vessel_of_chaos", nil, "wh3_dlc20_vilitch_cam_quest_mission_001"}
		},
		----------------------
		---- CHAOS DWARFS ----
		----------------------
		["wh3_dlc23_chd_drazhoath"] = {
			{"mission", "wh3_dlc23_anc_weapon_the_graven_sceptre", "wh3_dlc23_chd_drazhoath_the_graven_sceptre"},
			{"mission", "wh3_dlc23_anc_arcane_item_daemonspite_crucible", "wh3_dlc23_chd_drazhoath_daemonspite_crucible"},
			{"mission", "wh3_dlc23_anc_talisman_hellshard_amulet", "wh3_dlc23_chd_drazhoath_hellshard_amulet", nil, "wh3_dlc23_drazhoath_cam_quest_mission_001"}
		},
		["wh3_dlc23_chd_zhatan"] = {
			{"mission", "wh3_dlc23_anc_armour_chd_armour_of_gazrakh", "wh3_dlc23_qb_chd_zhatan_armour_of_gazrakh"},
			{"mission", "wh3_dlc23_anc_weapon_chd_the_obsidian_axe", "wh3_dlc23_qb_chd_zhatan_the_obsidian_axe"},
			{"mission", "wh3_dlc23_anc_enchanted_item_chd_chaos_runeshield", "wh3_dlc23_qb_chd_zhatan_chaos_runeshield", nil, "wh3_dlc23_zhatan_cam_quest_mission_001"}
		},
		["wh3_dlc23_chd_astragoth"] = {
			{"mission", "wh3_dlc23_anc_talisman_stone_mantle", "wh3_dlc23_roc_chd_astragoth_stone_mantle"},
			{"mission", "wh3_dlc23_anc_weapon_black_hammer_of_hashut", "wh3_dlc23_roc_qb_chd_astragoth_black_hammer_of_hashut", nil, "wh3_dlc23_astragoth_cam_quest_mission_001"}
		}
	}
	-- assemble infotext about quests
	local infotext = {
		"wh2.camp.advice.quests.info_001",
		"wh2.camp.advice.quests.info_002",
		"wh2.camp.advice.quests.info_003"
	};
	
	-- establish the listeners
	if not cm:tol_campaign_key() then
		for k, v in pairs(quests) do
			set_up_rank_up_listener(v, k, infotext);
		end
	end
end;