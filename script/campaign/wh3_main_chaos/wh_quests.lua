
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
			{"mission", "wh3_main_anc_weapon_frost_fang", "wh3_main_ie_qb_ksl_katarin_frost_fang", 7},
			{"mission", "wh3_main_anc_armour_the_crystal_cloak", "wh3_main_qb_ksl_katarin_crystal_cloak", 10, nil, "wh3_main_camp_quest_katarin_the_crystal_cloak_001", 245, 291}
		},
		["wh3_main_ksl_kostaltyn"] = {
			{"mission", "wh3_main_anc_weapon_the_burning_brazier", "wh3_main_qb_ksl_kostaltyn_burning_brazier", 10, nil, "wh3_main_camp_quest_kostaltyn_burning_brazier_001", 153, 162}
		},
		["wh3_main_ksl_boris"] = {
			{"mission", "wh3_main_anc_weapon_shard_blade", "wh3_main_ie_qb_ksl_boris_shard_blade", 7},
			{"mission", "wh3_main_anc_armour_armour_of_ursun", "wh3_main_ie_qb_ksl_boris_armour_of_ursun", 10}
		},
		["wh3_main_ogr_greasus_goldtooth"] = {
			{"mission", "wh3_main_anc_weapon_sceptre_of_titans", "wh3_main_ie_qb_ogr_greasus_sceptre_of_titans", 7},
			{"mission", "wh3_main_anc_talisman_overtyrants_crown", "wh3_main_qb_ogr_greasus_overtyrants_crown", 10, nil, "wh3_main_camp_quest_greasus_overtyrants_crown_001", 591, 240}
		},
		["wh3_main_ogr_skrag_the_slaughterer"] = {
			{"mission", "wh3_main_anc_enchanted_item_cauldron_of_the_great_maw", "wh3_main_qb_ogr_skrag_cauldron_of_the_great_maw", 10, nil, "wh3_main_camp_quest_skrag_cauldron_of_the_great_maw_001", 515, 238}
		},
		["wh3_main_kho_skarbrand"] = {
			{"mission", "wh3_main_anc_weapon_slaughter_and_carnage", "wh3_main_qb_kho_skarbrand_slaughter_and_carnage", 10, nil, "wh3_main_camp_quest_skarbrand_slaughter_and_carnage_001", 285, 278}
		},
		["wh3_main_nur_kugath"] = {
			{"mission", "wh3_main_anc_weapon_necrotic_missiles", "wh3_main_qb_nur_kugath_necrotic_missiles", 10, nil, "wh3_main_camp_quest_kugath_necrotic_missiles_001", 465, 256}
		},
		["wh3_main_sla_nkari"] = {
			{"mission", "wh3_main_anc_weapon_witstealer_sword", "wh3_main_qb_sla_nkari_witstealer_sword", 10, nil, "wh3_main_camp_quest_nkari_witstealer_sword_001", 30, 431}
		},
		["wh3_main_tze_kairos"] = {
			{"mission", "wh3_main_anc_arcane_item_staff_of_tomorrow", "wh3_main_qb_tze_kairos_staff_of_tomorrow", 10, nil, "wh3_main_camp_quest_kairos_staff_of_tomorrow_001", 253, 400}
		},
		----------------------
		------ CHAMPIONS -----
		----------------------
		["wh3_dlc20_sla_azazel"] = {
			{"mission", "wh3_dlc20_anc_weapon_daemonblade", "wh3_dlc20_qb_chs_azazel_daemonblade", 15, nil, "wh3_dlc20_azazel_cam_quest_mission_001", 452, 505}
		},
		["wh3_dlc20_nur_festus"] = {
			{"mission", "wh3_dlc20_anc_enchanted_item_pestilent_potions", "wh3_dlc20_qb_chs_festus_pestilent_potions", 15, nil, "wh3_dlc20_festus_cam_quest_mission_001", 375, 396}
		},
		["wh3_dlc20_kho_valkia"] = {
			{"mission", "wh3_dlc20_anc_armour_the_scarlet_armour", "wh3_dlc20_qb_chs_valkia_the_scarlet_armour", 8},
			{"mission", "wh3_dlc20_anc_enchanted_item_daemonshield", "wh3_dlc20_qb_chs_valkia_daemonshield", 12},
			{"mission", "wh3_dlc20_anc_weapon_the_spear_slaupnir", "wh3_dlc20_qb_chs_valkia_the_spear_slaupnir", 15, nil, "wh3_dlc20_valkia_cam_quest_mission_001", 393, 515}
		},
		["wh3_dlc20_tze_vilitch"] = {
			{"mission", "wh3_dlc20_anc_arcane_item_vessel_of_chaos", "wh3_dlc20_qb_chs_vilitch_vessel_of_chaos", 15, nil, "wh3_dlc20_vilitch_cam_quest_mission_001", 237, 513}
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