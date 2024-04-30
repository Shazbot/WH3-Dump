
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
		----------------------
		------- EMPIRE -------
		----------------------	
		["wh_main_emp_karl_franz"] = {			
			{"mission", "wh2_dlc13_anc_weapon_runefang_drakwald", "wh3_main_ie_qb_emp_karl_franz_reikland_runefang", nil, "war.camp.advice.quests.001"},
			{"mission", "wh_main_anc_weapon_ghal_maraz", "wh3_main_ie_qb_emp_karl_franz_ghal_maraz", nil, nil},
			{"mission", "wh_main_anc_talisman_the_silver_seal", "wh3_main_ie_qb_emp_karl_franz_silver_seal", nil, nil},
		},
		["wh_main_emp_balthasar_gelt"] = {			
			{"mission", "wh_main_anc_enchanted_item_cloak_of_molten_metal", "wh3_main_ie_qb_emp_balthasar_gelt_cloak_of_molten_metal", nil, "war.camp.advice.quests.001"},
			{"mission", "wh_main_anc_talisman_amulet_of_sea_gold", "wh3_main_ie_qb_emp_balthasar_gelt_amulet_of_sea_gold", nil, nil},
			{"mission", "wh_main_anc_arcane_item_staff_of_volans", "wh3_main_ie_qb_emp_balthasar_gelt_staff_of_volans", nil, nil},
		},
		["wh_dlc04_emp_volkmar"] = {			
			{"mission", "wh_dlc04_anc_talisman_jade_griffon", "wh3_main_ie_qb_emp_volkmar_the_grim_jade_griffon", nil, "war.camp.advice.quests.001"},
			{"mission", "wh_dlc04_anc_weapon_staff_of_command", "wh3_main_ie_qb_emp_volkmar_the_grim_staff_of_command", nil, nil},
		},
		["wh2_dlc13_emp_cha_markus_wulfhart"] = {			
			{"mission", "wh2_dlc13_anc_weapon_amber_bow", "wh3_main_ie_qb_emp_wulfhart_amber_bow", nil, "war.camp.advice.quests.001"},
		},
		["wh3_dlc25_emp_elspeth_von_draken"] = {			
			{"mission", "wh3_dlc25_anc_talisman_deaths_timekeeper", "wh3_dlc25_ie_qb_emp_elspeth_deaths_timekeeper", nil, "wh3_dlc25_elspeth_cam_quest_mission_001"},
			{"mission", "wh3_dlc25_anc_weapon_the_pale_scythe", "wh3_dlc23_ie_qb_emp_elspeth_the_pale_scythe"},
		},
		
		----------------------
		------- DWARFS -------
		----------------------	
		["wh_dlc06_dwf_belegar"] = {			
			{"mission", "wh_dlc06_anc_weapon_the_hammer_of_angrund", "wh3_main_ie_qb_dwf_belegar_ironhammer_hammer_of_angrund", nil, nil},
			{"mission", "wh_dlc06_anc_armour_shield_of_defiance", "wh3_main_ie_qb_dwf_belegar_ironhammer_shield_of_defiance", nil, "war.camp.advice.quests.001"},
		},
		["wh_pro01_dwf_grombrindal"] = {			
			{"mission", "wh_pro01_anc_armour_armour_of_glimril_scales", "wh3_main_ie_qb_dwf_grombrindal_armour_of_glimril", nil, "war.camp.advice.quests.001"},
			{"mission", "wh_pro01_anc_weapon_the_rune_axe_of_grombrindal", "wh3_main_ie_qb_dwf_grombrindal_rune_axe_of_grombrindal", nil, nil},
			{"mission", "wh_pro01_anc_talisman_cloak_of_valaya", "wh3_main_ie_qb_dwf_grombrindal_rune_cloak_of_valaya", nil, nil},
			{"mission", "wh_pro01_anc_enchanted_item_rune_helm_of_zhufbar", "wh3_main_ie_qb_dwf_grombrindal_rune_helm_of_zhufbar", nil, nil},
		},
		["wh_main_dwf_thorgrim_grudgebearer"] = {			
			{"mission", "wh_main_anc_armour_the_armour_of_skaldour", "wh3_main_ie_qb_dwf_thorgrim_grudgebearer_armour_of_skaldour", nil, nil},
			{"mission", "wh_main_anc_weapon_the_axe_of_grimnir", "wh3_main_ie_qb_dwf_thorgrim_grudgebearer_axe_of_grimnir", nil, "war.camp.advice.quests.001"},
			{"mission", "wh_main_anc_enchanted_item_the_great_book_of_grudges", "wh3_main_ie_qb_dwf_thorgrim_grudgebearer_book_of_grudges", nil, nil},
			{"mission", "wh_main_anc_talisman_the_dragon_crown_of_karaz", "wh3_main_ie_qb_dwf_thorgrim_grudgebearer_dragon_crown_of_karaz", nil, nil},
		},
		["wh_main_dwf_ungrim_ironfist"] = {			
			{"mission", "wh_main_anc_weapon_axe_of_dargo", "wh3_main_ie_qb_dwf_ungrim_ironfist_axe_of_dargo", nil, nil},
			{"mission", "wh_main_anc_talisman_dragon_cloak_of_fyrskar", "wh3_main_ie_qb_dwf_ungrim_ironfist_dragon_cloak_of_fyrskar", nil, nil},
			{"mission", "wh_main_anc_armour_the_slayer_crown", "wh3_main_ie_qb_dwf_ungrim_ironfist_slayer_crown", nil, "war.camp.advice.quests.001"},
		},
		["wh2_dlc17_dwf_thorek"] = {			
			{"mission", "wh2_dlc17_anc_armour_thoreks_rune_armour", "wh3_main_ie_qb_dwf_thorek_rune_armour_quest"},
			{"mission", "wh2_dlc17_anc_weapon_klad_brakak", "wh3_main_ie_qb_dwf_thorek_klad_brakak", nil, "war.camp.advice.quests.001"},
		},
		["wh3_dlc25_dwf_malakai_makaisson"] = {
			{"mission", "wh3_dlc25_anc_enchanted_item_the_eyes_of_grungni", "wh3_dlc25_mis_dwf_malakai_fellow_engineer_ie", nil, nil},
			{"mission", "wh3_dlc25_anc_weapon_makaissons_persuader", "wh3_dlc25_dwf_malakai_makaissons_persuader"}
		},
		----------------------
		----- GREENSKINS -----
		----------------------	
		["wh2_dlc15_grn_grom_the_paunch"] = {			
			{"mission", "wh2_dlc15_anc_weapon_axe_of_grom", "wh3_main_ie_qb_grn_grom_axe_of_grom", nil, "war.camp.advice.quests.001"},
			{"mission", "wh2_dlc15_anc_enchanted_item_lucky_banner", "wh3_main_ie_qb_grn_grom_lucky_banner"},
		},
		["wh_dlc06_grn_skarsnik"] = {			
			{"mission", "wh_dlc06_anc_weapon_skarsniks_prodder", "wh3_main_ie_qb_grn_skarsnik_skarsniks_prodder", nil, "war.camp.advice.quests.001"},
		},
		["wh_dlc06_grn_wurrzag_da_great_prophet"] = {			
			{"mission", "wh_dlc06_anc_enchanted_item_baleful_mask", "wh3_main_ie_qb_grn_wurrzag_da_great_green_prophet_baleful_mask", nil, "war.camp.advice.quests.001"},
			{"mission", "wh_dlc06_anc_arcane_item_squiggly_beast", "wh3_main_ie_qb_grn_wurrzag_da_great_green_prophet_squiggly_beast", nil, nil},
			{"mission", "wh_dlc06_anc_weapon_bonewood_staff", "wh3_main_ie_qb_grn_wurrzag_da_great_green_prophet_bonewood_staff", nil, nil},
		},
		["wh_main_grn_azhag_the_slaughterer"] = {			
			{"mission", "wh_main_anc_enchanted_item_the_crown_of_sorcery", "wh3_main_ie_qb_grn_azhag_the_slaughterer_crown_of_sorcery", nil, "war.camp.advice.quests.001"},
			{"mission", "wh_main_anc_armour_azhags_ard_armour", "wh3_main_ie_qb_grn_azhag_the_slaughterer_azhags_ard_armour", nil, nil},
			{"mission", "wh_main_anc_weapon_slaggas_slashas", "wh3_main_ie_qb_grn_azhag_the_slaughterer_slaggas_slashas", nil, nil},
		},
		["wh_main_grn_grimgor_ironhide"] = {			
			{"mission", "wh_main_anc_armour_blood-forged_armour", "wh3_main_ie_qb_grn_grimgor_ironhide_blood_forged_armour", nil, nil},
			{"mission", "wh_main_anc_weapon_gitsnik", "wh3_main_ie_qb_grn_grimgor_ironhide_gitsnik", nil, "war.camp.advice.quests.001"},
		},

		----------------------
		--- VAMPIRE COUNTS ---
		----------------------	
		["wh_main_vmp_mannfred_von_carstein"] = {			
			{"mission", "wh_main_anc_armour_armour_of_templehof", "wh3_main_ie_qb_vmp_mannfred_von_carstein_armour_of_templehof", nil, nil},
			{"mission", "wh_main_anc_weapon_sword_of_unholy_power", "wh3_main_ie_qb_vmp_mannfred_von_carstein_sword_of_unholy_power", nil, "war.camp.advice.quests.001"},
		},
		["wh_dlc04_vmp_helman_ghorst"] = {			
			{"mission", "wh_dlc04_anc_arcane_item_the_liber_noctus", "wh3_main_ie_qb_vmp_helman_ghorst_liber_noctus", nil, "war.camp.advice.quests.001"},
		},
		["wh_main_vmp_heinrich_kemmler"] = {			
			{"mission", "wh_main_anc_arcane_item_skull_staff", "wh3_main_ie_qb_vmp_heinrich_kemmler_skull_staff", nil, nil},
			{"mission", "wh_main_anc_enchanted_item_cloak_of_mists_and_shadows", "wh3_main_ie_qb_vmp_heinrich_kemmler_cloak_of_mists", nil, nil},
			{"mission", "wh_main_anc_weapon_chaos_tomb_blade", "wh3_main_ie_qb_vmp_heinrich_kemmler_chaos_tomb_blade", nil, "war.camp.advice.quests.001"},
		},
		["wh_dlc04_vmp_vlad_con_carstein"] = {			
			{"mission", "wh_dlc04_anc_talisman_the_carstein_ring", "wh3_main_ie_qb_vmp_vlad_von_carstein_the_carstein_ring", nil, nil},
			{"mission", "wh_dlc04_anc_weapon_blood_drinker", "wh3_main_ie_qb_vmp_vlad_von_carstein_blood_drinker", nil, "war.camp.advice.quests.001"},
		},
		["wh_pro02_vmp_isabella_von_carstein"] = {			
			{"mission", "wh_pro02_anc_enchanted_item_blood_chalice_of_bathori", "wh3_main_ie_qb_vmp_isabella_von_carstein_blood_chalice_of_bathori", nil, "war.camp.advice.quests.001"},
		},
		
		----------------------
		-------- CHAOS -------
		----------------------	
		["wh_main_chs_archaon"] = {			
			{"mission", "wh_main_anc_armour_the_armour_of_morkar", "wh3_main_ie_qb_chs_archaon_armour_of_morkar", nil, nil},
			{"mission", "wh_main_anc_enchanted_item_the_crown_of_domination", "wh3_main_ie_qb_chs_archaon_crown_of_domination", nil, nil},
			{"mission", "wh_main_anc_talisman_the_eye_of_sheerian", "wh3_main_ie_qb_chs_archaon_eye_of_sheerian", nil, nil},
			{"mission", "wh_main_anc_weapon_the_slayer_of_kings", "wh3_main_ie_qb_chs_archaon_slayer_of_kings", nil, "war.camp.advice.quests.001"},
		},
		["wh_dlc01_chs_prince_sigvald"] = {			
			{"mission", "wh_main_anc_armour_auric_armour", "wh3_main_ie_qb_chs_prince_sigvald_auric_armour", nil, nil},
			{"mission", "wh_main_anc_weapon_sliverslash", "wh3_main_ie_qb_chs_prince_sigvald_sliverslash", nil, "war.camp.advice.quests.001"},
		},
		["wh_dlc01_chs_kholek_suneater"] = {			
			{"mission", "wh_main_anc_weapon_starcrusher", "wh3_main_ie_qb_chs_kholek_suneater_starcrusher", nil, "war.camp.advice.quests.001"},
		},
		["wh3_dlc20_sla_azazel"] = {
			{"mission", "wh3_dlc20_anc_weapon_daemonblade", "wh3_dlc20_ie_qb_chs_azazel_daemonblade", nil, "wh3_dlc20_azazel_cam_quest_mission_001"}
		},
		["wh3_dlc20_nur_festus"] = {
			{"mission", "wh3_dlc20_anc_enchanted_item_pestilent_potions", "wh3_dlc20_ie_qb_chs_festus_pestilent_potions", nil, "wh3_dlc20_festus_cam_quest_mission_001"}
		},
		["wh3_dlc20_kho_valkia"] = {
			{"mission", "wh3_dlc20_anc_armour_the_scarlet_armour", "wh3_dlc20_ie_qb_chs_valkia_the_scarlet_armour"},
			{"mission", "wh3_dlc20_anc_enchanted_item_daemonshield", "wh3_dlc20_ie_qb_chs_valkia_daemonshield"},
			{"mission", "wh3_dlc20_anc_weapon_the_spear_slaupnir", "wh3_dlc20_ie_qb_chs_valkia_the_spear_slaupnir", nil, "wh3_dlc20_valkia_cam_quest_mission_001"}
		},
		["wh3_dlc20_tze_vilitch"] = {
			{"mission", "wh3_dlc20_anc_arcane_item_vessel_of_chaos", "wh3_dlc20_ie_qb_chs_vilitch_vessel_of_chaos", nil, "wh3_dlc20_vilitch_cam_quest_mission_001"}
		},
		["wh3_main_dae_belakor"] = {
			{"reward", "wh3_main_anc_weapon_blade_of_shadow", nil}
		},
		----------------------
		------ BEASTMEN ------
		----------------------	
		["wh_dlc03_bst_khazrak"] = {			
			{"mission", "wh_dlc03_anc_armour_the_dark_mail", "wh3_main_ie_qb_bst_khazrak_one_eye_the_dark_mail", nil, nil},
			{"mission", "wh_dlc03_anc_weapon_scourge", "wh3_main_ie_qb_bst_khazrak_one_eye_scourge", nil, "war.camp.advice.quests.001"},
		},
		["wh_dlc03_bst_malagor"] = {			
			{"mission", "wh_dlc03_anc_enchanted_item_icons_of_vilification", "wh3_main_ie_qb_bst_malagor_the_dark_omen_the_icons_of_vilification", nil, "war.camp.advice.quests.001"},
		},
		["wh_dlc05_bst_morghur"] = {			
			{"mission", "wh_main_anc_weapon_stave_of_ruinous_corruption", "wh3_main_ie_qb_bst_morghur_stave_of_ruinous_corruption", nil, "war.camp.advice.quests.001"},
		},
		["wh2_dlc17_bst_taurox"] = {			
			{"mission", "wh2_dlc17_anc_weapon_rune_tortured_axes", "wh3_main_ie_qb_bst_taurox_rune_tortured_axes", nil, "war.camp.advice.quests.001"},
		},
		
		---------------------
		----- WOOD ELVES -----
		----------------------	
		["wh_dlc05_wef_orion"] = {
			{"mission", "wh_dlc05_anc_enchanted_item_horn_of_the_wild_hunt", "wh3_main_ie_qb_wef_orion_the_horn_of_the_wild", nil, "war.camp.advice.quests.001"},
			{"mission", "wh_dlc05_anc_talisman_cloak_of_isha", "wh3_main_ie_qb_wef_orion_the_cloak_of_isha", nil, nil},
			{"mission", "wh_dlc05_anc_weapon_spear_of_kurnous", "wh3_main_ie_qb_wef_orion_the_spear_of_kurnous", nil, nil},
		},
		["wh_dlc05_wef_durthu"] = {
			{"mission", "wh_dlc05_anc_weapon_daiths_sword", "wh3_main_ie_qb_wef_durthu_daiths_sword", nil, "war.camp.advice.quests.001"},
		},
		["wh2_dlc16_wef_sisters_of_twilight"] = {
			{"mission", "wh2_dlc16_anc_mount_wef_cha_sisters_of_twilight_forest_dragon", "wh3_main_ie_qb_wef_sisters_dragon", nil, "war.camp.advice.quests.001"},
		},
		["wh2_dlc16_wef_drycha"] = {
			{"mission", "wh2_dlc16_anc_enchanted_item_fang_of_taalroth", "wh3_main_ie_qb_wef_drycha_coeddil_unchained", nil, "war.camp.advice.quests.001"},
		},

		----------------------
		------ BRETONNIA -----
		----------------------	
		["wh_main_brt_louen_leoncouer"] = {			
			{"mission", "wh_main_anc_weapon_the_sword_of_couronne", "wh3_main_ie_qb_brt_louen_sword_of_couronne", nil, "war.camp.advice.quests.001"},
			{"mission", "wh2_dlc12_anc_armour_brt_armour_of_brilliance", "wh3_main_ie_qb_brt_louen_armour_of_brilliance"},
		},
		["wh_dlc07_brt_fay_enchantress"] = {			
			{"mission", "wh_dlc07_anc_arcane_item_the_chalice_of_potions", "wh3_main_ie_qb_brt_fay_enchantress_chalice_of_potions", nil, "war.camp.advice.quests.001"},
			{"mission", "wh2_dlc12_anc_enchanted_item_brt_morgianas_mirror", "wh3_main_ie_qb_brt_fay_morgianas_mirror"},
		},
		["wh_dlc07_brt_alberic"] = {			
			{"mission", "wh_dlc07_anc_weapon_trident_of_manann", "wh3_main_ie_qb_brt_alberic_trident_of_bordeleaux", nil, "war.camp.advice.quests.001"},
			{"mission", "wh2_dlc12_anc_enchanted_item_brt_braid_of_bordeleaux", "wh3_main_ie_qb_brt_alberic_braid_of_bordeleaux"},
		},
		["wh2_dlc14_brt_repanse"] = {			
			{"mission", "wh2_dlc14_anc_weapon_sword_of_lyonesse", "wh3_main_ie_qb_brt_repanse_sword_of_lyonesse", nil, "war.camp.advice.quests.001"},
		},
		
		----------------------
		------- NORSCA -------
		----------------------
		["wh_dlc08_nor_wulfrik"] = {
			{"mission", "wh_dlc08_anc_weapon_sword_of_torgald", "wh3_main_ie_qb_nor_wulfrik_the_wanderer_sword_of_torgald", nil, "war.camp.advice.quests.001"},
		},
		["wh_dlc08_nor_throgg"] = {
			{"mission", "wh_dlc08_anc_enchanted_item_wintertooth_crown", "wh3_main_ie_qb_nor_throgg_wintertooth_crown", nil, "war.camp.advice.quests.001"},
		},
		
		----------------------
		----- HIGH ELVES -----
		----------------------
		["wh2_main_hef_tyrion"] = {
			{"mission", "wh2_main_anc_armour_dragon_armour_of_aenarion", "wh3_main_ie_qb_hef_tyrion_dragon_armour_of_aenarion", nil, "war.camp.advice.quest.tyrion.dragon_armour_of_aenarion.001"},
			{"mission", "wh2_main_anc_weapon_sunfang", "wh3_main_ie_qb_hef_tyrion_sunfang", nil, "war.camp.advice.quest.tyrion.sunfang.001"},
			{"mission", "wh2_main_anc_enchanted_item_heart_of_avelorn", "wh3_main_ie_qb_hef_tyrion_heart_of_avelorn"},
		},
		["wh2_main_hef_teclis"] = {
			{"mission", "wh2_main_anc_enchanted_item_scroll_of_hoeth", "wh2_main_vortex_narrative_hef_the_lies_of_the_druchii"},
			{"mission", "wh2_main_anc_arcane_item_moon_staff_of_lileath", "wh2_main_vortex_narrative_hef_the_vermin_of_hruddithi"},
			{"mission", "wh2_main_anc_armour_war_crown_of_saphery", "wh3_main_ie_qb_hef_teclis_war_crown_of_saphery", nil, "war.camp.advice.quest.teclis.war_crown_of_saphery.001"},
			{"mission", "wh2_main_anc_weapon_sword_of_teclis", "wh3_main_ie_qb_hef_teclis_sword_of_teclis", nil, "war.camp.advice.quest.teclis.sword_of_teclis.001"},
		},
		["wh2_dlc10_hef_alarielle"] = {
			{"mission", "wh2_dlc10_anc_talisman_shieldstone_of_isha", "wh3_main_ie_qb_hef_alarielle_shieldstone_of_isha"},
			{"mission", "wh2_dlc10_anc_enchanted_item_star_of_avelorn", "wh3_main_ie_qb_hef_alarielle_star_of_avelorn", nil, "war.camp.advice.quests.001"},
		},
		["wh2_dlc10_hef_alith_anar"] = {
			{"mission", "wh2_dlc10_anc_enchanted_item_the_shadow_crown", "wh3_main_ie_qb_hef_alith_anar_the_shadow_crown"},
			{"mission", "wh2_dlc10_anc_weapon_moonbow", "wh3_main_ie_qb_hef_alith_anar_the_moonbow", nil, "war.camp.advice.quests.001"},
		},
		["wh2_dlc15_hef_eltharion"] = {
			{"mission", "wh2_dlc15_anc_talisman_talisman_of_hoeth", "wh3_main_ie_qb_hef_eltharion_talisman_of_hoeth", nil, "war.camp.advice.quests.001"},
			{"mission", "wh2_dlc15_anc_armour_helm_of_yvresse", "wh3_main_ie_qb_hef_eltharion_helm_of_yvresse"},
			{"mission", "wh2_dlc15_anc_weapon_fangsword_of_eltharion", "wh3_main_ie_qb_hef_eltharion_fangsword_of_eltharion"},
		},
		["wh2_dlc15_hef_imrik"] = {
			{"mission", "wh2_dlc15_anc_armour_armour_of_caledor", "wh3_main_ie_qb_hef_imrik_armour_of_caledor", nil, "war.camp.advice.quests.001"},
		},
		
		----------------------
		----- DARK ELVES -----
		----------------------	
		["wh2_main_def_malekith"] = {
			{"mission", "wh2_main_anc_arcane_item_circlet_of_iron", "wh3_main_ie_qb_def_malekith_circlet_of_iron", nil, "war.camp.advice.quest.malekith.circlet_of_iron.001"},
			{"mission", "wh2_main_anc_weapon_destroyer", "wh3_main_ie_qb_def_malekith_destroyer", nil, "war.camp.advice.quest.malekith.destroyer.001"},
			{"mission", "wh2_main_anc_enchanted_item_supreme_spellshield", "wh3_main_ie_qb_def_malekith_supreme_spellshield", nil, "war.camp.advice.quest.malekith.supreme_spellshield.001"},
			{"mission", "wh2_main_anc_armour_armour_of_midnight", "wh3_main_ie_qb_def_malekith_armour_of_midnight"},
		},
		["wh2_main_def_morathi"] = {
			{"mission", "wh2_main_anc_weapon_heartrender_and_the_darksword", "wh3_main_ie_qb_def_morathi_heartrender_and_the_darksword", nil, "war.camp.advice.quest.morathi.heartrender_and_the_darksword.001"},
			{"mission", "wh2_main_anc_arcane_item_wand_of_the_kharaidon", "wh3_main_ie_qb_def_morathi_wand_of_kharaidon"},
			{"mission", "wh2_main_anc_talisman_amber_amulet", "wh3_main_ie_qb_def_morathi_amber_amulet"},
		},
		["wh2_dlc10_def_crone_hellebron"] = {
			{"mission", "wh2_dlc10_anc_weapon_deathsword_and_the_cursed_blade", "wh3_main_ie_qb_def_hellebron_deathsword_and_the_cursed_blade", nil, "war.camp.advice.quests.001"},
			{"mission", "wh2_dlc10_anc_talisman_amulet_of_dark_fire", "wh3_main_ie_qb_def_hellebron_amulet_of_dark_fire"},
		},
		["wh2_dlc11_def_lokhir"] = {
			{"mission", "wh2_main_anc_armour_helm_of_the_kraken", "wh3_main_ie_qb_lokhir_helm_of_the_kraken", nil, "wh2_dlc11.camp.advice.quest.lokhir.001"},
			{"mission", "wh2_dlc11_anc_weapon_red_blades", "wh3_main_ie_qb_def_lokhir_red_blades"},
		},
		["wh2_dlc14_def_malus_darkblade"] = {
			{"mission", "wh2_dlc14_anc_weapon_warpsword_of_khaine", "wh3_main_ie_qb_def_malus_warpsword_of_khaine", nil, "war.camp.advice.quests.001"},
		},
		["wh2_twa03_def_rakarth"] = {
			{"mission", "wh2_twa03_anc_weapon_whip_of_agony", "wh3_main_ie_qb_def_rakarth_whip_of_agony", nil, "war.camp.advice.quests.001"},
		},

		----------------------
		------ LIZARDMEN -----
		----------------------	
		["wh2_main_lzd_lord_mazdamundi"] = {
			{"mission", "wh2_main_anc_weapon_cobra_mace_of_mazdamundi", "wh3_main_ie_qb_lzd_mazdamundi_cobra_mace_of_mazdamundi", nil, "war.camp.advice.quest.mazdamundi.cobra_mace_of_mazdamundi.001"},
			{"mission", "wh2_main_anc_magic_standard_sunburst_standard_of_hexoatl", "wh3_main_ie_qb_lzd_mazdamundi_sunburst_standard_of_hexoatl", nil, "war.camp.advice.quest.mazdamundi.sunburst_standard_of_hexoatl.001"},
		},
		["wh2_main_lzd_kroq_gar"] = {
			{"mission", "wh2_main_anc_enchanted_item_hand_of_gods", "wh3_main_ie_qb_liz_kroq_gar_hand_of_gods", nil, "war.camp.advice.quest.kroqgar.hand_of_gods.001"},
			{"mission", "wh2_main_anc_weapon_revered_spear_of_tlanxla", "wh3_main_ie_qb_liz_kroq_gar_revered_spear_of_tlanxla", nil, "war.camp.advice.quest.kroqgar.revered_spear_of_tlanxla.001"},
		},
		["wh2_dlc12_lzd_tehenhauin"] = {
			{"mission", "wh2_dlc12_anc_enchanted_item_plaque_of_sotek", "wh3_main_ie_qb_lzd_tehenhauin_plaque_of_sotek", nil, "war.camp.advice.quests.001"},
		},
		["wh2_dlc12_lzd_tiktaqto"] = {
			{"mission", "wh2_dlc12_anc_enchanted_item_mask_of_heavens", "wh3_main_ie_qb_lzd_tiktaqto_mask_of_heavens", nil, "war.camp.advice.quests.001"},
		},
		["wh2_dlc13_lzd_nakai"] = {
			{"mission", "wh2_dlc13_anc_enchanted_item_golden_tributes", "wh3_main_ie_qb_lzd_nakai_golden_tributes", nil, "war.camp.advice.quests.001"},
			{"mission", "wh2_dlc13_talisman_the_ogham_shard", "wh3_main_ie_qb_lzd_nakai_the_ogham_shard", nil, nil},
		},
		["wh2_dlc13_lzd_gor_rok"] = {
			{"mission", "wh2_dlc13_anc_armour_the_shield_of_aeons", "wh3_main_ie_qb_lzd_gorrok_the_shield_of_aeons", nil, "war.camp.advice.quests.001"},
			{"mission", "wh2_dlc13_anc_weapon_mace_of_ulumak", "wh3_main_ie_qb_lzd_the_mace_of_ulumak"}
		},
		["wh2_dlc17_lzd_oxyotl"] = {
			{"mission", "wh2_dlc17_anc_weapon_the_golden_blowpipe_of_ptoohee", "wh3_main_ie_qb_lzd_oxyotl_the_golden_blowpipe_of_ptoohee", nil, "war.camp.advice.quests.001"},
		},
		
		----------------------
		------- SKAVEN -------
		----------------------	
		["wh2_main_skv_queek_headtaker"] = {
			{"mission", "wh2_main_anc_armour_warp_shard_armour", "wh3_main_ie_qb_skv_queek_headtaker_warp_shard_armour", nil, "war.camp.advice.quest.queek.warp_shard_armour.001"},
			{"mission", "wh2_main_anc_weapon_dwarf_gouger", "wh3_main_ie_qb_skv_queek_headtaker_dwarfgouger", nil, "war.camp.advice.quest.queek.dwarfgouger.001"},
		},
		["wh2_main_skv_lord_skrolk"] = {
			{"mission", "wh2_main_anc_arcane_item_the_liber_bubonicus", "wh3_main_ie_qb_skv_skrolk_liber_bubonicus", nil, "war.camp.advice.quest.skrolk.liber_bubonicus.001"},
			{"mission", "wh2_main_anc_weapon_rod_of_corruption", "wh3_main_ie_qb_skv_skrolk_rod_of_corruption", nil, "war.camp.advice.quest.skrolk.rod_of_corruption.001"},
		},
		["wh2_dlc09_skv_tretch_craventail"] = {
			{"mission", "wh2_dlc09_anc_enchanted_item_lucky_skullhelm", "wh3_main_ie_qb_skv_tretch_lucky_skullhelm", nil, "dlc09.camp.advice.quest.tretch.lucky_skullhelm.001"},
		},
		["wh2_dlc12_skv_ikit_claw"] = {
			{"mission", "wh2_dlc12_anc_weapon_storm_daemon", "wh3_main_ie_qb_ikit_claw_storm_daemon", nil, "war.camp.advice.quests.001"},
		},
		["wh2_dlc14_skv_deathmaster_snikch"] = {
			{"mission", "wh2_dlc14_anc_armour_the_cloak_of_shadows", "wh3_main_ie_qb_skv_snikch_the_cloak_of_shadows", nil, "war.camp.advice.quests.001"},
			{"mission", "wh2_dlc14_anc_weapon_whirl_of_weeping_blades", "wh3_main_ie_qb_skv_snikch_whirl_of_weeping_blades"},
		},
		["wh2_dlc16_skv_throt_the_unclean"] = {
			{"mission", "wh2_dlc16_anc_enchanted_item_whip_of_domination", "wh3_main_ie_qb_skv_throt_main_whip_of_domination", nil, "war.camp.advice.quests.001"},
			{"mission", "wh2_dlc16_anc_weapon_creature_killer", "wh3_main_ie_qb_skv_throt_main_creature_killer"},
		},

		----------------------
		----- TOMB KINGS -----
		----------------------	
		["wh2_dlc09_tmb_settra"] = {
			{"mission", "wh2_dlc09_anc_enchanted_item_the_crown_of_nehekhara", "wh3_main_ie_qb_tmb_settra_the_crown_of_nehekhara", nil, "dlc09.camp.advice.quest.settra.the_crown_of_nehekhara.001"},
			{"mission", "wh2_dlc09_anc_weapon_the_blessed_blade_of_ptra", "wh3_main_ie_qb_tmb_settra_the_blessed_blade_of_ptra", nil, "dlc09.camp.advice.quest.settra.the_blessed_blade_of_ptra.001"},
		},
		["wh2_dlc09_tmb_arkhan"] = {
			{"mission", "wh2_dlc09_anc_weapon_the_tomb_blade_of_arkhan", "wh3_main_ie_qb_tmb_arkhan_the_tomb_blade_of_arkhan", nil, "dlc09.camp.advice.quest.arkhan.the_tomb_blade_of_arkhan.001"},
			{"mission", "wh2_dlc09_anc_arcane_item_staff_of_nagash", "wh3_main_ie_qb_tmb_arkhan_the_staff_of_nagash", nil, "dlc09.camp.advice.quest.arkhan.the_staff_of_nagash.001"},
		},
		["wh2_dlc09_tmb_khatep"] = {
			{"mission", "wh2_dlc09_anc_arcane_item_the_liche_staff", "wh3_main_ie_qb_tmb_khatep_the_liche_staff", nil, "dlc09.camp.advice.quest.khatep.the_liche_staff.001"},
		},
		["wh2_dlc09_tmb_khalida"] = {
			{"mission", "wh2_dlc09_anc_weapon_the_venom_staff", "wh3_main_ie_qb_tmb_khalida_venom_staff", nil, "dlc09.camp.advice.quest.khalida.venom_staff.001"},
		},
		
		----------------------
		---- VAMPIRE COAST ---
		----------------------	
		["wh2_dlc11_cst_harkon"] = {
			{"mission", "wh2_dlc11_anc_enchanted_item_slann_gold", "wh3_main_ie_qb_cst_harkon_quest_for_slann_gold", nil, "wh2_dlc11.camp.advice.quest.harkon.001"},
		},
		["wh2_dlc11_cst_noctilus"] = {
			{"mission", "wh2_dlc11_anc_enchanted_item_captain_roths_moondial", "wh3_main_ie_qb_cst_noctilus_captain_roths_moondial", nil, "wh2_dlc11.camp.advice.quest.noctilus.001"},
		},
		["wh2_dlc11_cst_aranessa"] = {
			{"mission", "wh2_dlc11_anc_weapon_krakens_bane", "wh3_main_ie_qb_cst_aranessa_krakens_bane", nil, "wh2_dlc11.camp.advice.quest.aranessa.001"},
		},
		["wh2_dlc11_cst_cylostra"] = {
			{"mission", "wh2_dlc11_anc_arcane_item_the_bordeleaux_flabellum", "wh3_main_ie_qb_cst_cylostra_the_bordeleaux_flabellum", nil, "wh2_dlc11.camp.advice.quest.cylostra.001"},
		},
		
		----------------------
		------- KISLEV -------
		----------------------	
		["wh3_main_ksl_katarin"] = {
			{"mission", "wh3_main_anc_weapon_frost_fang", "wh3_main_ie_qb_ksl_katarin_frost_fang"},
			{"mission", "wh3_main_anc_armour_the_crystal_cloak", "wh3_main_ie_qb_ksl_katarin_crystal_cloak", nil, "wh3_main_camp_quest_katarin_the_crystal_cloak_001"}
		},
		["wh3_main_ksl_kostaltyn"] = {
			{"mission", "wh3_main_anc_weapon_the_burning_brazier", "wh3_main_ie_qb_ksl_kostaltyn_burning_brazier", nil, "wh3_main_camp_quest_kostaltyn_burning_brazier_001"}
		},
		["wh3_main_ksl_boris"] = {
			{"mission", "wh3_main_anc_weapon_shard_blade", "wh3_main_ie_qb_ksl_boris_shard_blade"},
			{"mission", "wh3_main_anc_armour_armour_of_ursun", "wh3_main_ie_qb_ksl_boris_armour_of_ursun"}
		},
		["wh3_dlc24_ksl_mother_ostankya"] = {
			{"mission", "wh3_dlc24_anc_enchanted_item_cauldron_of_power", "wh3_dlc24_qb_ksl_mother_ostankya_cauldron_of_power"},
			{"mission", "wh3_dlc24_anc_arcane_item_crown_of_claws", "wh3_dlc24_ie_qb_ksl_mother_ostankya_crown_of_claws", nil, "wh3_dlc24_mother_ostankya_cam_quest_mission.001"}
		},
		
		----------------------
		------- CATHAY -------
		----------------------	
		["wh3_main_cth_miao_ying"] = {
			{"mission", "wh3_dlc24_anc_armour_storm_wind_coronal", "wh3_dlc24_ie_qb_cth_miao_ying_storm_wind_coronal"},
			{"mission", "wh3_dlc24_anc_enchanted_item_vambraces_of_yin", "wh3_dlc24_qb_cth_miao_ying_vambraces_of_yin"}
		},
		["wh3_main_cth_zhao_ming"] = {
			{"mission", "wh3_dlc24_anc_armour_horns_of_shang_yang", "wh3_dlc24_ie_qb_cth_zhao_ming_horns_of_shang_yang"},
			{"mission", "wh3_dlc24_anc_enchanted_item_the_burning_vambraces", "wh3_dlc24_qb_cth_zhao_ming_the_burning_vambraces"}
		},
		["wh3_dlc24_cth_yuan_bo"] = {
			{"mission", "wh3_dlc24_anc_armour_armour_of_the_dragons_gaze", "wh3_dlc24_qb_cth_yuan_bo_armour_of_the_dragons_gaze"},
			{"mission", "wh3_dlc24_anc_weapon_the_dragons_fang", "wh3_dlc24_ie_qb_cth_yuan_bo_dragons_fang", nil, "wh3_dlc24_yuan_bo_cam_quest_mission.001"}
		},

		----------------------
		---- OGRE KINGDOMS ---
		----------------------	
		["wh3_main_ogr_greasus_goldtooth"] = {
			{"mission", "wh3_main_anc_weapon_sceptre_of_titans", "wh3_main_ie_qb_ogr_greasus_sceptre_of_titans"},
			{"mission", "wh3_main_anc_talisman_overtyrants_crown", "wh3_main_ie_qb_ogr_greasus_overtyrants_crown", nil, "wh3_main_camp_quest_greasus_overtyrants_crown_001"}
		},
		["wh3_main_ogr_skrag_the_slaughterer"] = {
			{"mission", "wh3_main_anc_enchanted_item_cauldron_of_the_great_maw", "wh3_main_ie_qb_ogr_skrag_cauldron_of_the_great_maw", nil, "wh3_main_camp_quest_skrag_cauldron_of_the_great_maw_001"}
		},
		
		----------------------
		-------- KHORNE ------
		----------------------	
		["wh3_main_kho_skarbrand"] = {
			{"mission", "wh3_main_anc_weapon_slaughter_and_carnage", "wh3_main_ie_qb_kho_skarbrand_slaughter_and_carnage", nil, "wh3_main_camp_quest_skarbrand_slaughter_and_carnage_001"}
		},

		----------------------
		-------- NURGLE ------
		----------------------
		["wh3_main_nur_kugath"] = {
			{"mission", "wh3_main_anc_weapon_necrotic_missiles", "wh3_main_ie_qb_nur_kugath_necrotic_missiles", nil, "wh3_main_camp_quest_kugath_necrotic_missiles_001"}
		},
		["wh3_dlc25_nur_tamurkhan"] = {
			{"mission", "wh3_dlc25_anc_weapon_the_black_cleaver", "wh3_dlc25_qb_ie_nur_tamurkhan_gates_of_nuln", nil, "wh3_dlc25_tamurkhan_cam_quest_mission_001"}
		},
		["wh3_dlc25_nur_epidemius"] = {
			{"mission", "wh3_dlc25_anc_weapon_epidemius_sword", "wh3_dlc25_ie_qb_nur_epidemius_purveyor_of_mortality"},
			{"mission", "wh3_dlc25_anc_enchanted_item_epidemius_hourglass", "wh3_dlc25_ie_qb_nur_epidemius_sands_of_sickness"}
		},

		----------------------
		------- SLAANESH -----
		----------------------
		["wh3_main_sla_nkari"] = {
			{"mission", "wh3_main_anc_weapon_witstealer_sword", "wh3_main_ie_qb_sla_nkari_witstealer_sword", nil, "wh3_main_camp_quest_nkari_witstealer_sword_001"}
		},

		----------------------
		------- TZEENCH ------
		----------------------
		["wh3_main_tze_kairos"] = {
			{"mission", "wh3_main_anc_arcane_item_staff_of_tomorrow", "wh3_main_ie_qb_tze_kairos_staff_of_tomorrow", nil, "wh3_main_camp_quest_kairos_staff_of_tomorrow_001"}
		},
		["wh3_dlc24_tze_the_changeling"] = {
			{"mission", "wh3_dlc24_anc_arcane_item_the_tricksters_staff", "wh3_dlc24_ie_qb_tze_the_changeling_the_tricksters_staff", nil, "wh3_dlc24_the_changeling_cam_quest_mission.001"}
		},

		----------------------
		---- CHAOS DWARFS ----
		----------------------
		["wh3_dlc23_chd_drazhoath"] = {
			{"mission", "wh3_dlc23_anc_weapon_the_graven_sceptre", "wh3_dlc23_ie_chd_drazhoath_the_graven_sceptre"},
			{"mission", "wh3_dlc23_anc_arcane_item_daemonspite_crucible", "wh3_dlc23_ie_chd_drazhoath_daemonspite_crucible"},
			{"mission", "wh3_dlc23_anc_talisman_hellshard_amulet", "wh3_dlc23_ie_chd_drazhoath_hellshard_amulet", nil, "wh3_dlc23_drazhoath_cam_quest_mission_001"}
		},
		["wh3_dlc23_chd_zhatan"] = {
			{"mission", "wh3_dlc23_anc_armour_chd_armour_of_gazrakh", "wh3_dlc23_ie_qb_chd_zhatan_armour_of_gazrakh"},
			{"mission", "wh3_dlc23_anc_weapon_chd_the_obsidian_axe", "wh3_dlc23_ie_qb_chd_zhatan_the_obsidian_axe"},
			{"mission", "wh3_dlc23_anc_enchanted_item_chd_chaos_runeshield", "wh3_dlc23_ie_qb_chd_zhatan_chaos_runeshield", nil, "wh3_dlc23_zhatan_cam_quest_mission_001"}
		},
		["wh3_dlc23_chd_astragoth"] = {
			{"mission", "wh3_dlc23_anc_talisman_stone_mantle", "wh3_dlc23_ie_chd_astragoth_stone_mantle"},
			{"mission", "wh3_dlc23_anc_weapon_black_hammer_of_hashut", "wh3_dlc23_ie_qb_chd_astragoth_black_hammer_of_hashut", nil, "wh3_dlc23_astragoth_cam_quest_mission_001"}
		}
	}
	
	-- assemble infotext about quests
	local infotext = {
		"wh2.camp.advice.quests.info_001",
		"wh2.camp.advice.quests.info_002",
		"wh2.camp.advice.quests.info_003"
	};
	
	-- establish the listeners
	for k, v in pairs(quests) do
		set_up_rank_up_listener(v, k, infotext);
	end;
end;
