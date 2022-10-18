campaign_traits = {
	lords_records = {},
	trait_exclusions = {
		["culture"] = {
			["wh2_main_trait_corrupted_chaos"] = {"wh_main_chs_chaos", "wh_dlc08_nor_norsca", "wh_dlc03_bst_beastmen", "wh2_main_skv_skaven", "wh3_main_dae_daemons", "wh3_main_kho_khorne", "wh3_main_nur_nurgle", "wh3_main_sla_slaanesh", "wh3_main_tze_tzeentch"},
			["wh2_main_trait_corrupted_vampire"] = {"wh_main_vmp_vampire_counts", "wh2_dlc09_tmb_tomb_kings", "wh2_dlc11_cst_vampire_coast"},
			["wh2_main_trait_corrupted_skaven"] = {"wh2_main_skv_skaven", "wh_main_chs_chaos", "wh_dlc08_nor_norsca", "wh_dlc03_bst_beastmen", "wh3_main_dae_daemons", "wh3_main_kho_khorne", "wh3_main_nur_nurgle", "wh3_main_sla_slaanesh", "wh3_main_tze_tzeentch"},
			["wh3_main_trait_corrupted_khorne"] = {"wh_main_chs_chaos", "wh_dlc08_nor_norsca", "wh_dlc03_bst_beastmen", "wh3_main_dae_daemons", "wh3_main_kho_khorne"},
			["wh3_main_trait_corrupted_nurgle"] = {"wh_main_chs_chaos", "wh_dlc08_nor_norsca", "wh_dlc03_bst_beastmen", "wh3_main_dae_daemons", "wh3_main_nur_nurgle"},
			["wh3_main_trait_corrupted_slaanesh"] = {"wh_main_chs_chaos", "wh_dlc08_nor_norsca", "wh_dlc03_bst_beastmen", "wh3_main_dae_daemons", "wh3_main_sla_slaanesh"},
			["wh3_main_trait_corrupted_tzeentch"] = {"wh_main_chs_chaos", "wh_dlc08_nor_norsca", "wh_dlc03_bst_beastmen", "wh3_main_dae_daemons", "wh3_main_tze_tzeentch"},
			["wh2_main_trait_pacifist"] = {"wh_main_chs_chaos", "wh_dlc08_nor_norsca", "wh_dlc03_bst_beastmen", "wh3_main_dae_daemons", "wh3_main_kho_khorne", "wh3_main_nur_nurgle", "wh3_main_sla_slaanesh", "wh3_main_tze_tzeentch"},
			["wh2_main_trait_stance_recruiting"] = {"wh2_dlc09_tmb_tomb_kings", "wh_dlc03_bst_beastmen"},
			["wh2_main_trait_defeats_against_chaos"] = {"wh_main_chs_chaos", "wh_dlc08_nor_norsca", "wh3_main_dae_daemons", "wh3_main_kho_khorne", "wh3_main_nur_nurgle", "wh3_main_sla_slaanesh", "wh3_main_tze_tzeentch"},
			["wh2_main_trait_defeats_against_daemons"] = {"wh_main_chs_chaos", "wh_dlc08_nor_norsca", "wh3_main_dae_daemons", "wh3_main_kho_khorne", "wh3_main_nur_nurgle", "wh3_main_sla_slaanesh", "wh3_main_tze_tzeentch"},
			["wh2_main_trait_agent_actions_against_chaos"] = {"wh_main_chs_chaos", "wh_dlc08_nor_norsca", "wh3_main_dae_daemons", "wh3_main_kho_khorne", "wh3_main_nur_nurgle", "wh3_main_sla_slaanesh", "wh3_main_tze_tzeentch"},
			["wh2_main_trait_agent_actions_against_daemons"] = {"wh_main_chs_chaos", "wh_dlc08_nor_norsca", "wh3_main_dae_daemons", "wh3_main_kho_khorne", "wh3_main_nur_nurgle", "wh3_main_sla_slaanesh", "wh3_main_tze_tzeentch"},
			["wh2_main_trait_wins_against_chaos"] = {"wh_main_chs_chaos", "wh_dlc08_nor_norsca", "wh3_main_dae_daemons", "wh3_main_kho_khorne", "wh3_main_nur_nurgle", "wh3_main_sla_slaanesh", "wh3_main_tze_tzeentch"},
			["wh2_main_trait_wins_against_daemons"] = {"wh_main_chs_chaos", "wh_dlc08_nor_norsca", "wh3_main_dae_daemons", "wh3_main_kho_khorne", "wh3_main_nur_nurgle", "wh3_main_sla_slaanesh", "wh3_main_tze_tzeentch"},
			["wh2_main_trait_slaver"] = {"wh3_main_sla_slaanesh"}
		},
		["subculture"] = {
			["wh2_main_trait_attacking_defeat"] = {"wh_main_sc_brt_bretonnia"},
			["wh2_main_trait_attacking_victory"] = {"wh_main_sc_brt_bretonnia"},
			["wh2_main_trait_builder"] = {"wh_main_sc_brt_bretonnia"},
			["wh2_main_trait_defeats"] = {"wh_main_sc_brt_bretonnia"},
			["wh2_main_trait_defending_defeat"] = {"wh_main_sc_brt_bretonnia"},
			["wh2_main_trait_defending_victory"] = {"wh_main_sc_brt_bretonnia"},
			["wh2_main_trait_far_from_capital"] = {"wh_main_sc_brt_bretonnia"},
			["wh2_main_trait_lazy"] = {"wh_main_sc_brt_bretonnia"},
			["wh2_main_trait_lone_wolf"] = {"wh_main_sc_brt_bretonnia"},
			["wh2_main_trait_post_battle_execute"] = {"wh_main_sc_brt_bretonnia", "wh_main_sc_dwf_dwarfs"},
			["wh2_main_trait_post_battle_ransom"] = {"wh_main_sc_brt_bretonnia"},
			["wh2_main_trait_public_order"] = {"wh_main_sc_brt_bretonnia"},
			["wh2_main_trait_razing"] = {"wh_main_sc_brt_bretonnia"},
			["wh2_main_trait_reinforcing"] = {"wh_main_sc_brt_bretonnia"},
			["wh2_main_trait_routed"] = {"wh_main_sc_brt_bretonnia"},
			["wh2_main_trait_sacking"] = {"wh_main_sc_brt_bretonnia"},
			["wh2_main_trait_siege_defeat"] = {"wh_main_sc_brt_bretonnia"},
			["wh2_main_trait_siege_victory"] = {"wh_main_sc_brt_bretonnia"},
			["wh2_main_trait_stance_raiding"] = {"wh_main_sc_brt_bretonnia"},
			["wh2_main_trait_wins"] = {"wh_main_sc_brt_bretonnia"},
			["wh2_main_trait_wins_against_humans"] = {"wh_main_sc_brt_bretonnia"},
			["wh2_main_trait_defeated_louen_leoncouer"] = {"wh_main_sc_brt_bretonnia"},
		},
		["faction"] = {
			["wh2_main_trait_corrupted_chaos"] = {
				"wh2_main_def_cult_of_pleasure",
				"wh2_main_def_cult_of_pleasure_separatists",
				"wh2_dlc13_lzd_spirits_of_the_jungle",
				"wh2_dlc17_lzd_oxyotl"},
			["wh3_main_trait_corrupted_slaanesh"] = {
				"wh2_main_def_cult_of_pleasure",
				"wh2_main_def_cult_of_pleasure_separatists"
			},
			["wh2_main_trait_sacking"] = {"wh2_dlc13_lzd_spirits_of_the_jungle"}
		}
	},	
	legendary_lord_defeated_traits = {
		--["character key"] (agent_subtypes) =   		"trait key" (character_traits)
		["wh_main_emp_karl_franz"] =				"wh2_main_trait_defeated_karl_franz", 					-- Karl Franz
		["wh_main_emp_balthasar_gelt"] =			"wh2_main_trait_defeated_balthasar_gelt",				-- Balthasar Gelt
		["wh_dlc04_emp_volkmar"] =					"wh2_main_trait_defeated_volkmar_the_grim", 			-- Volkmar the Grim
		["wh_main_dwf_thorgrim_grudgebearer"] =		"wh2_main_trait_defeated_thorgrim_grudgebearer", 		-- Thorgrim Grudgebearer
		["wh_main_dwf_ungrim_ironfist"] =			"wh2_main_trait_defeated_ungrim_ironfist", 				-- Ungrim Ironfist
		["wh_pro01_dwf_grombrindal"] = 				"wh2_main_trait_defeated_grombrindal", 					-- Grombrindal
		["wh_dlc06_dwf_belegar"] =					"wh2_main_trait_defeated_belegar_ironhammer", 			-- Belegar Ironhammer
		["wh_dlc05_wef_orion"] =					"wh2_main_trait_defeated_orion", 						-- Orion
		["wh_dlc05_wef_durthu"] =					"wh2_main_trait_defeated_durthu", 						-- Durthu
		["wh_main_grn_grimgor_ironhide"] =			"wh2_main_trait_defeated_grimgor_ironhide", 			-- Grimgor Ironhide
		["wh_main_grn_azhag_the_slaughterer"] =		"wh2_main_trait_defeated_azhag_the_slaughterer", 		-- Azhag the Slaughterer
		["wh_dlc06_grn_skarsnik"] =					"wh2_main_trait_defeated_skarsnik", 					-- Skarsnik
		["wh_dlc06_grn_wurrzag_da_great_prophet"] =	"wh2_main_trait_defeated_wurzzag", 						-- Wurrzag
		["wh_main_vmp_mannfred_von_carstein"] =		"wh2_main_trait_defeated_mannfred_von_carstein", 		-- Mannfred von Carstein
		["wh_main_vmp_heinrich_kemmler"] =			"wh2_main_trait_defeated_heinrich_kemmler", 			-- Heinrich Kemmler
		["wh_dlc04_vmp_vlad_con_carstein"] =		"wh2_main_trait_defeated_vlad_von_carstein", 			-- Vlad von Carstein
		["wh_dlc04_vmp_helman_ghorst"] =			"wh2_main_trait_defeated_helmen_ghorst", 				-- Helman Ghorst
		["wh_pro02_vmp_isabella_von_carstein"] =	"wh2_main_trait_defeated_isabella_von_carstein", 		-- Isabella von Carstein
		["wh_main_chs_archaon"] =					"wh2_main_trait_defeated_archaon_the_everchosen", 		-- Archaon the Everchosen
		["wh_dlc01_chs_kholek_suneater"] =			"wh2_main_trait_defeated_kholek_suneater", 				-- Kholek Suneater
		["wh_dlc01_chs_prince_sigvald"] =			"wh2_main_trait_defeated_prince_sigvald", 				-- Prince Sigvald
		["wh_dlc03_bst_khazrak"] =					"wh2_main_trait_defeated_khazrak_one_eye", 				-- Khazrak One-Eye
		["wh_dlc03_bst_malagor"] =					"wh2_main_trait_defeated_malagor_the_dark_omen", 		-- Malagor the Dark Omen
		["wh_dlc05_bst_morghur"] =					"wh2_main_trait_defeated_morghur_the_shadowgave", 		-- Morghur the Shadowgave
		["wh_main_brt_louen_leoncouer"] =			"wh2_main_trait_defeated_louen_leoncouer", 				-- Louen Leoncouer
		["wh_dlc07_brt_fay_enchantress"] =			"wh2_main_trait_defeated_fay_enchantress", 				-- Fay Enchantress
		["wh_dlc07_brt_alberic"] =					"wh2_main_trait_defeated_alberic_de_bordeleaux", 		-- Alberic de Bordeleaux
		["wh_dlc08_nor_wulfrik"] =					"wh_dlc08_trait_defeated_wulfrik",						-- Wulfrik the Wanderer
		["wh_dlc08_nor_throgg"] =					"wh_dlc08_trait_defeated_throgg",						-- Throgg
		["wh2_main_hef_tyrion"] =					"wh2_main_trait_defeated_tyrion", 						-- Tyrion
		["wh2_main_hef_teclis"] =					"wh2_main_trait_defeated_teclis", 						-- Teclis
		["wh2_main_lzd_lord_mazdamundi"] =			"wh2_main_trait_defeated_lord_mazdamundi", 				-- Lord Mazdamundi
		["wh2_main_lzd_kroq_gar"] =					"wh2_main_trait_defeated_kroq_gar", 					-- Kroq-Gar
		["wh2_main_def_malekith"] =					"wh2_main_trait_defeated_malekith", 					-- Malekith
		["wh2_main_def_morathi"] =					"wh2_main_trait_defeated_morathi", 						-- Morathi
		["wh2_main_skv_queek_headtaker"] =			"wh2_main_trait_defeated_queen_headtaker", 				-- Queen Headtaker
		["wh2_main_skv_lord_skrolk"] =				"wh2_main_trait_defeated_lord_skrolk", 					-- Lord Skrolk
		["wh2_dlc09_skv_tretch_craventail"] =		"wh2_dlc09_trait_defeated_tretch",						-- Tretch Craventail
		["wh2_dlc09_tmb_settra"] =					"wh2_dlc09_trait_defeated_settra",						-- Settra the Imperishable
		["wh2_dlc09_tmb_arkhan"] =					"wh2_dlc09_trait_defeated_arkhan",						-- Arkhan the Black
		["wh2_dlc09_tmb_khalida"] =					"wh2_dlc09_trait_defeated_khalida",						-- High Queen Khalida
		["wh2_dlc09_tmb_khatep"] =					"wh2_dlc09_trait_defeated_khatep",						-- Grand Hierophant Khatep
		["wh2_dlc10_hef_alarielle"] =				"wh2_dlc10_trait_defeated_alarielle",					-- Alarielle the Radiant
		["wh2_dlc10_hef_alith_anar"] =				"wh2_dlc10_trait_defeated_alith_anar",					-- Alith Anar
		["wh2_dlc10_def_crone_hellebron"] =			"wh2_dlc10_trait_defeated_hellebron",					-- Crone Hellebron
		["wh2_dlc11_cst_harkon"] =					"wh2_dlc11_trait_defeated_luthor_harkon",				-- Luthor Harkon
		["wh2_dlc11_cst_noctilus"] =				"wh2_dlc11_trait_defeated_count_noctilus",				-- Count Noctilus
		["wh2_dlc11_cst_aranessa"] =				"wh2_dlc11_trait_defeated_aranessa_saltspite",			-- Aranessa Saltspite
		["wh2_dlc11_cst_cylostra"] =				"wh2_dlc11_trait_defeated_cylostra_direfin",			-- Cylostra Direfin
		["wh2_dlc11_def_lokhir"] =					"wh2_dlc11_trait_defeated_lokhir_fellheart",			-- Lokhir Fellheart
		["wh2_dlc12_lzd_tehenhauin"] =				"wh2_dlc12_trait_defeated_tehenhauin",					-- Tehenhauin
		["wh2_dlc12_skv_ikit_claw"] =				"wh2_dlc12_trait_defeated_ikit_claw",					-- Ikit Claw
		["wh2_dlc12_lzd_tiktaqto"] =				"wh2_dlc12_trait_defeated_tiktaqto",					-- Tiktaq'to
		["wh2_dlc13_emp_cha_markus_wulfhart"] = 	"wh2_dlc13_trait_defeated_wulfhart",					-- Markus Wulfhart
		["wh2_dlc13_lzd_nakai"] = 					"wh2_dlc13_trait_defeated_nakai",						-- Nakai
		["wh2_dlc13_lzd_gor_rok"] = 				"wh2_dlc13_trait_defeated_gorrok",						-- Gor-Rok
		["wh2_dlc14_brt_repanse"] = 				"wh2_dlc14_trait_defeated_repanse",						-- Repanse de Lyonese
		["wh2_dlc14_def_malus_darkblade"] =			"wh2_dlc14_trait_defeated_malus",						-- Malus Darkblade
		["wh2_dlc14_skv_deathmaster_snikch"] =		"wh2_dlc14_trait_defeated_snikch",						-- Deathmaster Snikch
		["wh2_pro08_neu_gotrek"] =					"wh2_dlc14_trait_defeated_gotrek",						-- Gotrek
		["wh2_dlc15_hef_imrik"] = 					"wh2_dlc15_trait_defeated_imrik",						-- Imrik
		["wh2_dlc15_hef_eltharion"] = 				"wh2_dlc15_trait_defeated_eltharion",					-- Eltharion the Grim
		["wh2_dlc15_grn_grom_the_paunch"] =			"wh2_dlc15_trait_defeated_grom",						-- Grom the Paunch
		["wh2_dlc16_wef_drycha"] = 		            "wh2_main_trait_defeated_drycha",						-- Drycha
		["wh2_dlc16_wef_sisters_of_twilight"] =     "wh2_main_trait_defeated_sisters_of_twilight",			-- Sisters of Twilight
		["wh2_dlc16_skv_throt_the_unclean"] = 		"wh2_main_trait_defeated_throt",						-- Throt the Unclean
		["wh2_twa03_def_rakarth"] = 				"wh2_twa03_trait_defeated_rakarth",						-- Rakarth
		["wh2_dlc17_lzd_oxyotl"] =					"wh2_dlc17_trait_defeated_oxyotl",						-- Oxyotl
		["wh2_dlc17_bst_taurox"] =					"wh2_dlc17_trait_defeated_taurox",						-- Taurox
		["wh2_dlc17_dwf_thorek"] =					"wh2_dlc17_trait_defeated_thorek",						-- Thorek Ironbrow
		["wh3_main_cth_miao_ying"] =				"wh3_main_trait_defeated_miao_ying",					-- Miao Ying
		["wh3_main_cth_zhao_ming"] =				"wh3_main_trait_defeated_zhao_ming",					-- Zhao Ming
		["wh3_main_dae_daemon_prince"] =			"wh3_main_trait_defeated_daemon_prince",				-- Daemon Prince
		["wh3_main_kho_skarbrand"] =				"wh3_main_trait_defeated_skarbrand",					-- Skarbrand the Exiled
		["wh3_main_ksl_boris"] =					"wh3_main_trait_defeated_boris",						-- Boris Ursus
		["wh3_main_ksl_katarin"] =					"wh3_main_trait_defeated_katarin",						-- Tzarina Katarin
		["wh3_main_ksl_kostaltyn"] =				"wh3_main_trait_defeated_kostaltyn",					-- Kostaltyn
		["wh3_main_nur_kugath"] =					"wh3_main_trait_defeated_kugath",						-- Ku'gath Plaguefather
		["wh3_main_ogr_greasus_goldtooth"] =		"wh3_main_trait_defeated_greasus_goldtooth",			-- Greasus Goldtooth
		["wh3_main_ogr_skrag_the_slaughterer"] =	"wh3_main_trait_defeated_skrag_the_slaughterer",		-- Skrag the Slaughterer
		["wh3_main_sla_nkari"] =					"wh3_main_trait_defeated_nkari",						-- N'Kari
		["wh3_main_tze_kairos"] =					"wh3_main_trait_defeated_kairos",						-- Kairos Fateweaver
		["wh3_main_dae_belakor"] =					"wh3_main_trait_defeated_belakor",						-- Be'lakor
		["wh3_dlc20_sla_azazel"] =					"wh3_dlc20_trait_defeated_azazel",						-- Azazel
		["wh3_dlc20_nur_festus"] =					"wh3_dlc20_trait_defeated_festus",						-- Festus
		["wh3_dlc20_kho_valkia"] =					"wh3_dlc20_trait_defeated_valkia",						-- Valkia
		["wh3_dlc20_tze_vilitch"] =					"wh3_dlc20_trait_defeated_vilitch",						-- Vilitch
	},
	subcultures_trait_keys = {
		["wh_main_sc_chs_chaos"] = "chaos",
		["wh_dlc08_sc_nor_norsca"] = "chaos",
		["wh_main_sc_dwf_dwarfs"] = "dwarfs",
		["wh_main_sc_grn_greenskins"] = "greenskins",
		["wh_main_sc_grn_savage_orcs"] = "greenskins",
		["wh_main_sc_emp_empire"] = "humans",
		["wh_main_sc_brt_bretonnia"] = "humans",
		["wh_main_sc_teb_teb"] = "humans",
		["wh_main_sc_vmp_vampire_counts"] = "vampires",
		["wh_dlc03_sc_bst_beastmen"] = "beastmen",
		["wh_dlc05_sc_wef_wood_elves"] = "wood_elves",
		["wh2_main_sc_def_dark_elves"] = "dark_elves",
		["wh2_main_sc_hef_high_elves"] = "high_elves",
		["wh2_main_sc_lzd_lizardmen"] = "lizardmen",
		["wh2_main_sc_skv_skaven"] = "skaven",
		["wh2_dlc09_sc_tmb_tomb_kings"] = "tomb_kings",
		["wh2_dlc11_sc_cst_vampire_coast"] = "vampire_coast",
		["wh3_main_sc_cth_cathay"] = "cathay",
		["wh3_main_sc_dae_daemons"] = "daemons",
		["wh3_main_sc_kho_khorne"] = "khorne",
		["wh3_main_sc_ksl_kislev"] = "kislev",
		["wh3_main_sc_nur_nurgle"] = "nurgle",
		["wh3_main_sc_ogr_ogre_kingdoms"] = "ogre_kingdoms",
		["wh3_main_sc_sla_slaanesh"] = "slaanesh",
		["wh3_main_sc_tze_tzeentch"] = "tzeentch"
	},
	action_key_to_action = {
		["wh2_main_agent_action_champion_hinder_agent_assassinate"] = "Assassinate",
		["wh2_main_agent_action_engineer_hinder_agent_assassinate"] = "Assassinate",
		["wh2_main_agent_action_spy_hinder_agent_assassinate"] = "Assassinate",
		["wh2_main_agent_action_spy_hinder_character_assassinate"] = "Assassinate",
		["wh2_main_agent_action_wizard_hinder_agent_assassinate"] = "Assassinate",
		["wh3_main_agent_action_dignitary_hinder_agent_assassinate"] = "Assassinate",
		["wh2_main_agent_action_champion_hinder_settlement_assault_garrison"] = "Assault Garrison",
		["wh2_main_agent_action_dignitary_hinder_settlement_assault_garrison"] = "Assault Garrison",
		["wh2_main_agent_action_engineer_hinder_settlement_assault_garrison"] = "Assault Garrison",
		["wh2_main_agent_action_spy_hinder_settlement_assault_garrison"] = "Assault Garrison",
		["wh2_main_agent_action_wizard_hinder_settlement_assault_garrison"] = "Assault Garrison",
		["wh2_main_agent_action_champion_hinder_army_assault_units"] = "Assault Units",
		["wh2_main_agent_action_dignitary_hinder_army_assault_units"] = "Assault Units",
		["wh2_main_agent_action_engineer_hinder_army_assault_units"] = "Assault Units",
		["wh2_main_agent_action_spy_hinder_army_assault_units"] = "Assault Units",
		["wh2_main_agent_action_wizard_hinder_army_assault_units"] = "Assault Units",
		["wh2_main_agent_action_wizard_hinder_army_assault_unit"] = "Assault Unit",
		["wh2_main_agent_action_champion_hinder_army_block_army"] = "Block Army",
		["wh2_main_agent_action_engineer_hinder_army_block_army"] = "Block Army",
		["wh2_main_agent_action_spy_hinder_army_block_army"] = "Block Army",
		["wh2_main_agent_action_wizard_hinder_army_block_army"] = "Block Army",
		["wh3_main_agent_action_dignitary_hinder_army_block_army"] = "Block Army",
		["wh2_main_agent_action_champion_hinder_settlement_damage_building"] = "Damage Building",
		["wh2_main_agent_action_dignitary_hinder_settlement_damage_building"] = "Damage Building",
		["wh2_main_agent_action_engineer_hinder_settlement_damage_building"] = "Damage Building",
		["wh2_main_agent_action_wizard_hinder_settlement_damage_building"] = "Damage Building",
		["wh2_main_agent_action_champion_hinder_settlement_damage_walls"] = "Damage Walls",
		["wh2_main_agent_action_dignitary_hinder_settlement_damage_walls"] = "Damage Walls",
		["wh2_main_agent_action_engineer_hinder_settlement_damage_walls"] = "Damage Walls",
		["wh2_main_agent_action_runesmith_hinder_settlement_damage_walls"] = "Damage Walls",
		["wh2_main_agent_action_spy_hinder_settlement_damage_walls"] = "Damage Walls",
		["wh2_main_agent_action_wizard_hinder_settlement_damage_walls"] = "Damage Walls",
		["wh2_main_agent_action_champion_hinder_army_hinder_replenishment"] = "Hinder Replenishment",
		["wh2_main_agent_action_dignitary_hinder_army_hinder_replenishment"] = "Hinder Replenishment",
		["wh2_main_agent_action_engineer_hinder_army_hinder_replenishment"] = "Hinder Replenishment",
		["wh2_main_agent_action_runesmith_hinder_army_hinder_replenishment"] = "Hinder Replenishment",
		["wh2_main_agent_action_spy_hinder_army_hinder_replenishment"] = "Hinder Replenishment",
		["wh2_main_agent_action_wizard_hinder_army_hinder_replenishment"] = "Hinder Replenishment",
		["wh2_main_agent_action_engineer_hinder_settlement_steal_technology"] = "Steal Technology",
		["wh2_main_agent_action_wizard_hinder_settlement_steal_technology"] = "Steal Technology",
		["wh2_main_agent_action_champion_hinder_agent_wound"] = "Wound",
		["wh2_main_agent_action_dignitary_hinder_agent_wound"] = "Wound",
		["wh2_main_agent_action_engineer_hinder_agent_wound"] = "Wound",
		["wh2_main_agent_action_runesmith_hinder_agent_wound"] = "Wound",
		["wh2_main_agent_action_spy_hinder_agent_wound"] = "Wound",
		["wh2_main_agent_action_wizard_hinder_agent_wound"] = "Wound"
	},
	action_to_trait = {
		["Assassinate"] = "wh2_main_trait_agent_action_assassinate",
		["Assault Garrison"] = "wh2_main_trait_agent_action_assault_garrison",
		["Assault Unit"] = "wh2_main_trait_agent_action_assault_unit",
		["Assault Units"] = "wh2_main_trait_agent_action_assault_units",
		["Block Army"] = "wh2_main_trait_agent_action_block_army",
		["Damage Building"] = "wh2_main_trait_agent_action_damage_building",
		["Damage Walls"] = "wh2_main_trait_agent_action_damage_walls",
		["Hinder Replenishment"] = "wh2_main_trait_agent_action_hinder_replenishment",
		["Steal Technology"] = "wh2_main_trait_agent_action_steal_technology",
		["Wound"] = "wh2_main_trait_agent_action_wound"
	}
}

------------------------------------------------------------------------------
---- Function: Gives points in a trait to a Lord, with an optional chance ----
------------------------------------------------------------------------------
function campaign_traits:give_trait(character, trait, _points, _chance)
	local chance = _chance or 100;
	local points = _points or 1;
	
	if character == nil then
		out("TRAIT ERROR: Tried to give trait to a character that was not specified!");
		return false;
	end

	if character:is_null_interface() == true then
		out("TRAIT ERROR: Tried to give trait to a character that was a null interface!");
		return false;
	end
	
	if self:check_exclusion(trait, character) then
		return false;
	end
	
	if cm:model():random_percent(chance) == false then
		return false;
	end
	
	cm:force_add_trait("character_cqi:"..character:cqi(), trait, true, points);
	return true;
end

function campaign_traits:remove_trait(character, trait)
	if character == nil then
		return false;
	end

	if character:is_null_interface() == true then
		return false;
	end

	cm:force_remove_trait("character_cqi:"..character:cqi(), trait);
	return true;
end

function campaign_traits:check_exclusion(trait, character)
	local char_faction = character:faction();
	local char_culture = char_faction:culture();
	local char_subculture = char_faction:subculture();
	local char_faction_name = char_faction:name();

	local culture_exclusions = self.trait_exclusions["culture"][trait];
	local subculture_exclusions = self.trait_exclusions["subculture"][trait];
	local faction_exclusions = self.trait_exclusions["faction"][trait];
	
	if culture_exclusions ~= nil then
		for i = 1, #culture_exclusions do
			if culture_exclusions[i] == char_culture then
				return true;
			end
		end
	end
	if subculture_exclusions ~= nil then
		for i = 1, #subculture_exclusions do
			if subculture_exclusions[i] == char_subculture then
				return true;
			end
		end
	end
	if faction_exclusions ~= nil then
		for i = 1, #faction_exclusions do
			if faction_exclusions[i] == char_faction_name then
				return true;
			end
		end
	end
	if character:character_type("colonel") or character:is_governor() or character:character_subtype("wh3_main_ogr_tyrant_camp") or char_faction:is_quest_battle_faction() then
		return true;
	end
	return false;
end

-------------------------------------------------------------------
---- Function: Retrieves a piece of recorded data about a Lord ----
-------------------------------------------------------------------
function campaign_traits:get_lord_record(character, stat_key)
	if character:is_null_interface() == false then
		local char_cqi = character:cqi();
		local val = self.lords_records[tostring(char_cqi).."_"..stat_key];
		return val;
	end
end

-------------------------------------------------------------------------
---- Function: Records a piece of custom data associated with a Lord ----
-------------------------------------------------------------------------
function campaign_traits:set_lord_record(character, stat_key, value)
	if character:is_null_interface() == false then
		local char_cqi = character:cqi();
		self.lords_records[tostring(char_cqi).."_"..stat_key] = value;
	end
end

-----------------------------------
---- DEFEATING LEGENDARY LORDS ----
-----------------------------------
events.CharacterCompletedBattle[#events.CharacterCompletedBattle+1] =
function (context)
	local character = context:character();

	if cm:char_is_general_with_army(character) and character:won_battle() then
		local LL_enemies = campaign_traits:get_enemy_legendary_lords_in_last_battle(character);
		
		for i = 1, #LL_enemies do
			local LL_trait = campaign_traits.legendary_lord_defeated_traits[LL_enemies[i]];
			
			if LL_trait ~= nil then
				if LL_trait == "wh2_dlc09_trait_defeated_settra" and campaign_traits:is_surtha_ek(character) then
					campaign_traits:give_trait(character, "wh2_dlc09_trait_defeated_settra_as_surtha");
				else
					campaign_traits:give_trait(character, LL_trait);
				end
			elseif LL_enemies[i] == "surtha_ek" and character:character_subtype("wh2_dlc09_tmb_settra") then
				campaign_traits:give_trait(character, "wh2_dlc09_trait_defeated_surtha_as_settra");
			end
		end
	end
end

function campaign_traits:get_enemy_legendary_lords_in_last_battle(character)
	local pb = cm:model():pending_battle();
	local LL_attackers = {};
	local LL_defenders = {};
	local was_attacker = false;

	local num_attackers = cm:pending_battle_cache_num_attackers();
	local num_defenders = cm:pending_battle_cache_num_defenders();

	if pb:night_battle() == true or pb:ambush_battle() == true then
		num_attackers = 1;
		num_defenders = 1;
	end
	
	for i = 1, num_attackers do
		local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_attacker(i);
		local char_subtype = cm:pending_battle_cache_get_attacker_subtype(i);
		
		if this_char_cqi == character:cqi() then
			was_attacker = true;
			break;
		end
		
		if self.legendary_lord_defeated_traits[char_subtype] ~= nil then
			table.insert(LL_attackers, char_subtype);
		else
			local char_obj = cm:model():character_for_command_queue_index(this_char_cqi);

			if char_obj:is_null_interface() == false and self:is_surtha_ek(char_obj) == true then
				table.insert(LL_attackers, "surtha_ek");
			end
		end
	end
	
	if was_attacker == false then
		return LL_attackers;
	end
	
	for i = 1, num_defenders do
		local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_defender(i);
		local char_subtype = cm:pending_battle_cache_get_defender_subtype(i);
		
		if self.legendary_lord_defeated_traits[char_subtype] ~= nil then
			table.insert(LL_defenders, char_subtype);
		else
			local char_obj = cm:model():character_for_command_queue_index(this_char_cqi);

			if char_obj:is_null_interface() == false and self:is_surtha_ek(char_obj) == true then
				table.insert(LL_defenders, "surtha_ek");
			end
		end
	end
	return LL_defenders;
end

function campaign_traits:is_surtha_ek(char_obj)
	return char_obj:forename("names_name_2147345608") and char_obj:surname("names_name_2147345760");
end

-------------------------------------------
---- AGENT ACTIONS AGAINST SUBCULTURES ----
-------------------------------------------
events.CharacterCharacterTargetAction[#events.CharacterCharacterTargetAction+1] =
function (context)
	if context:ability() ~= "assist_army" and (context:mission_result_success() or context:mission_result_critial_success()) then
		local subculture = context:target_character():faction():subculture();
		local own_subculture = context:character():faction():subculture();
		
		if subculture ~= own_subculture and campaign_traits.subcultures_trait_keys[subculture] ~= nil then
			campaign_traits:give_trait(context:character(), "wh2_main_trait_agent_actions_against_"..campaign_traits.subcultures_trait_keys[subculture]);
			
			if campaign_traits.subcultures_trait_keys[subculture] == "skaven" then
				campaign_traits:remove_skaven_from_character_and_force(context:character());
			end
		end
	end
end

events.CharacterGarrisonTargetAction[#events.CharacterGarrisonTargetAction+1] =
function (context)
	if context:mission_result_success() or context:mission_result_critial_success() then
		local subculture = context:garrison_residence():faction():subculture();
		local own_subculture = context:character():faction():subculture();
		
		if subculture ~= own_subculture and campaign_traits.subcultures_trait_keys[subculture] ~= nil then
			campaign_traits:give_trait(context:character(), "wh2_main_trait_agent_actions_against_"..campaign_traits.subcultures_trait_keys[subculture]);
			
			if campaign_traits.subcultures_trait_keys[subculture] == "skaven" then
				campaign_traits:remove_skaven_from_character_and_force(context:character());
			end
		end
	end
end

------------------------
---- BATTLES FOUGHT ----
------------------------
events.CharacterCompletedBattle[#events.CharacterCompletedBattle+1] =
function (context)
	local character = context:character();
	local side = campaign_traits:get_character_side_in_last_battle(character);
	local result = "defeat";
	
	if character:won_battle() == true then
		result = "victory";
	end
	
	if context:pending_battle():siege_battle() == true and context:pending_battle():battle_type() == "settlement_standard" then
		campaign_traits:give_trait(character, "wh2_main_trait_siege_"..result);
	else
		if side == "Attacker" then
			campaign_traits:give_trait(character, "wh2_main_trait_attacking_"..result);
		elseif side == "Defender" then
			campaign_traits:give_trait(character, "wh2_main_trait_defending_"..result);
		end
	end
end

-------------------------------------
---- BATTLES AGAINST SUBCULTURES ----
-------------------------------------
events.CharacterCompletedBattle[#events.CharacterCompletedBattle+1] =
function (context)
	campaign_traits:general_completed_battle(context);
end
events.CharacterParticipatedAsSecondaryGeneralInBattle[#events.CharacterParticipatedAsSecondaryGeneralInBattle+1] =
function (context)
	campaign_traits:general_completed_battle(context);
end

function campaign_traits:general_completed_battle(context)
	local character = context:character();
	local side = self:get_character_side_in_last_battle(character);

	if side == "Attacker" then
		for i = 1, cm:pending_battle_cache_num_defenders() do
			local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_defender(i);
			self:give_traits_for_fighting_subcultures(character, faction_name)
		end
	elseif side == "Defender" then
		for i = 1, cm:pending_battle_cache_num_attackers() do
			local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_attacker(i);
			self:give_traits_for_fighting_subcultures(character, faction_name)
		end
	end;

end

function campaign_traits:give_traits_for_fighting_subcultures(character, faction_name)
	local world = cm:model():world();
	local enemy_culture = "";
	local enemy_subculture = "";

	if world:faction_exists(faction_name) then
		local faction = world:faction_by_key(faction_name);
		enemy_culture = faction:culture();
		enemy_subculture = faction:subculture();	
	end;
	
	if character:faction():subculture() ~= enemy_subculture and self.subcultures_trait_keys[enemy_subculture] ~= nil then
		if character:won_battle() == true then
			self:give_trait(character, "wh2_main_trait_wins_against_"..self.subcultures_trait_keys[enemy_subculture]);
		else
			self:give_trait(character, "wh2_main_trait_defeats_against_"..self.subcultures_trait_keys[enemy_subculture]);
		end
		
		if self.subcultures_trait_keys[enemy_subculture] == "skaven" then
			self:remove_skaven_from_character_and_force(character);
		end
	elseif enemy_culture == "wh2_main_rogue" then
		self:give_trait(character, "wh2_main_trait_wins_against_rogue_armies");
	end
end

function campaign_traits:get_character_side_in_last_battle(character)
	for i = 1, cm:pending_battle_cache_num_attackers() do
		local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_attacker(i);
		
		if char_cqi == character:cqi() then
			return "Attacker";
		end
	end
	for i = 1, cm:pending_battle_cache_num_defenders() do
		local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_defender(i);
		
		if char_cqi == character:cqi() then
			return "Defender";
		end
	end
	return "";
end

------------------------------
---- FOUGHT NAVAL BATTLES ----
------------------------------
events.CharacterCompletedBattle[#events.CharacterCompletedBattle+1] =
function (context)
	local character = context:character();
	
	if character:is_at_sea() == true then
		if character:won_battle() == true then
			campaign_traits:give_trait(character, "wh2_main_trait_wins_at_sea");
		else
			campaign_traits:give_trait(character, "wh2_main_trait_defeats_at_sea");
		end
	end
end

---------------------------------
---- REINFORCING SUBCULTURES ----
---------------------------------
events.CharacterCompletedBattle[#events.CharacterCompletedBattle+1] =
function (context)
	if cm:char_is_general_with_army(context:character()) then
		local primary_attacker_char_cqi, primary_attacker_mf_cqi, primary_attacker_faction_name = cm:pending_battle_cache_get_attacker(1);
		local primary_attacker = cm:model():character_for_command_queue_index(primary_attacker_char_cqi);
		
		if primary_attacker:is_null_interface() == false then
			if primary_attacker:command_queue_index() ~= context:character():command_queue_index() then -- We don't check reinforcement for this battle if this is the primary character
				if cm:pending_battle_cache_num_attackers() > 1 then
					local primary_attacker_subculture = primary_attacker:faction():subculture();
					
					for i = 2, cm:pending_battle_cache_num_attackers() do
						local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_attacker(i);
						local char_obj = cm:model():character_for_command_queue_index(char_cqi);
						
						if char_obj:is_null_interface() == false then
							local char_subculture = char_obj:faction():subculture();
							
							if char_subculture == primary_attacker_subculture then
								-- Reinforced Yourself
								campaign_traits:give_trait(char_obj, "wh2_main_trait_reinforcing");
							elseif campaign_traits.subcultures_trait_keys[primary_attacker_subculture] ~= nil then
								-- Reinforced Others
								local trait = "wh2_main_trait_reinforcing_"..campaign_traits.subcultures_trait_keys[primary_attacker_subculture];
								campaign_traits:give_trait(char_obj, trait);
								
								if campaign_traits.subcultures_trait_keys[primary_attacker_subculture] == "skaven" then
									campaign_traits:remove_skaven_from_character_and_force(char_obj);
								end
							end
						end
					end
				end
			end
		end
		
		local primary_defender_char_cqi, primary_defender_mf_cqi, primary_defender_faction_name = cm:pending_battle_cache_get_defender(1);
		local primary_defender = cm:model():character_for_command_queue_index(primary_defender_char_cqi);
		
		if primary_defender:is_null_interface() == false then
			if primary_defender:command_queue_index() ~= context:character():command_queue_index() then -- We don't check reinforcement for this battle if this is the primary character
				if cm:pending_battle_cache_num_defenders() > 1 then
					local primary_defender_subculture = primary_defender:faction():subculture();
					
					for i = 2, cm:pending_battle_cache_num_defenders() do
						local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_defender(i);
						local char_obj = cm:model():character_for_command_queue_index(char_cqi);
						
						if char_obj:is_null_interface() == false then
							local char_subculture = char_obj:faction():subculture();
							
							if char_subculture == primary_defender_subculture then
								-- Reinforced Yourself
								campaign_traits:give_trait(char_obj, "wh2_main_trait_reinforcing");
							elseif campaign_traits.subcultures_trait_keys[primary_defender_subculture] ~= nil then
								-- Reinforced Others
								local trait = "wh2_main_trait_reinforcing_"..campaign_traits.subcultures_trait_keys[primary_defender_subculture];
								campaign_traits:give_trait(char_obj, trait);
								
								if campaign_traits.subcultures_trait_keys[primary_defender_subculture] == "skaven" then
									campaign_traits:remove_skaven_from_character_and_force(char_obj);
								end
							end
						end
					end
				end
			end
		end
	end
end

--------------------------------
---- TURNS IN ENEMY REGIONS ----
--------------------------------
events.CharacterTurnStart[#events.CharacterTurnStart+1] =
function (context)
	local character = context:character();

	if character:is_null_interface() == false then
		if not character:faction():is_allowed_to_capture_territory() then
			if cm:char_is_general_with_army(character) and character:has_region() and not character:region():is_abandoned() then
				if character:turns_in_enemy_regions() >= 20 then
					if character:trait_points("wh2_main_trait_lone_wolf") == 2 then
						campaign_traits:give_trait(character, "wh2_main_trait_lone_wolf");
					end
				elseif character:turns_in_enemy_regions() >= 15 then
					if character:trait_points("wh2_main_trait_lone_wolf") == 1 then
						campaign_traits:give_trait(character, "wh2_main_trait_lone_wolf");
					end
				elseif character:turns_in_enemy_regions() >= 10 then
					if character:trait_points("wh2_main_trait_lone_wolf") == 0 then
						campaign_traits:give_trait(character, "wh2_main_trait_lone_wolf");
					end
				end
			end
		end
	end
end

----------------------------
---- TURNS SPENT AT SEA ----
----------------------------
events.CharacterTurnStart[#events.CharacterTurnStart+1] =
function (context)
	local character = context:character();

	if character:is_at_sea() and cm:char_is_general_with_army(character) then
		campaign_traits:give_trait(character, "wh2_main_trait_sea_legs");
	end
end

-------------------------
---- TIME IN STANCES ----
-------------------------
events.CharacterTurnEnd[#events.CharacterTurnEnd+1] =
function (context)
	local character = context:character();
	
	if cm:char_is_general_with_army(character) then
		local stance = character:military_force():active_stance();
		local culture = character:faction():culture();
		
		-- RAIDING
		if stance == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID" or stance == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_SET_CAMP_RAIDING" then
			campaign_traits:give_trait(character, "wh2_main_trait_stance_raiding");
		-- AMBUSHING
		elseif stance == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_AMBUSH" then
			campaign_traits:give_trait(character, "wh2_main_trait_stance_ambushing");
		-- TUNNELING
		elseif stance == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_TUNNELING" then
			campaign_traits:give_trait(character, "wh2_main_trait_stance_tunneling");
		-- FORCED MARCH
		elseif stance == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_MARCH" then
			campaign_traits:give_trait(character, "wh2_main_trait_stance_forced_march");
		-- RECRUITING
		elseif stance == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_MUSTER" then
			campaign_traits:give_trait(character, "wh2_main_trait_stance_recruiting");
		-- STALKING
		elseif stance == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_STALKING" and culture == "wh2_main_skv_skaven" then
			campaign_traits:give_trait(character, "wh2_main_trait_stance_stalking");
		-- LILEATH
		elseif stance == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_CHANNELING" and culture == "wh2_main_hef_high_elves" then
			campaign_traits:give_trait(character, "wh2_main_trait_stance_channeling");
		-- ASTROMANCY
		elseif stance == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_ASTROMANCY" and culture == "wh2_main_lzd_lizardmen" then
			campaign_traits:give_trait(character, "wh2_main_trait_stance_astromancy");
		end
	end
end

-----------------------------
---- SACKING SETTLEMENTS ----
-----------------------------
events.CharacterSackedSettlement[#events.CharacterSackedSettlement+1] =
function (context)
	if cm:char_is_general_with_army(context:character()) then
		campaign_traits:give_trait(context:character(), "wh2_main_trait_sacking");
	end
end

-----------------------------
---- RAZING SETTLEMENTS ----
-----------------------------
events.CharacterRazedSettlement[#events.CharacterRazedSettlement+1] =
function (context)
	if cm:char_is_general_with_army(context:character()) then
		campaign_traits:give_trait(context:character(), "wh2_main_trait_razing");
	end
end

--------------------------
---- ROUTED IN BATTLE ----
--------------------------
events.CharacterCompletedBattle[#events.CharacterCompletedBattle+1] =
function (context)
	if cm:char_is_general_with_army(context:character()) then
		if context:character():routed_in_battle() and context:character():won_battle() == false then
			campaign_traits:give_trait(context:character(), "wh2_main_trait_routed");
		elseif context:character():routed_in_battle() == false and context:character():won_battle() == true and context:character():fought_in_battle() then
			campaign_traits:give_trait(context:character(), "wh2_main_trait_fighter");
		end
	end
end

-------------------------------
---- POST-BATTLE RANSOMING ----
-------------------------------
events.CharacterPostBattleCaptureOption[#events.CharacterPostBattleCaptureOption+1] =
function (context)
	if context:get_outcome_key() == "release" and cm:char_is_general_with_army(context:character()) then
		campaign_traits:give_trait(context:character(), "wh2_main_trait_post_battle_ransom");
	end
end

-------------------------------
---- POST-BATTLE EXECUTING ----
-------------------------------
events.CharacterPostBattleCaptureOption[#events.CharacterPostBattleCaptureOption+1] =
function (context)
	if context:get_outcome_key() == "kill" and cm:char_is_general_with_army(context:character()) then
		campaign_traits:give_trait(context:character(), "wh2_main_trait_post_battle_execute");
	end
end

---------------------------------
---- FOUGHT FAR FROM CAPITAL ----
---------------------------------
events.CharacterCompletedBattle[#events.CharacterCompletedBattle+1] =
function (context)
	local character = context:character();
	
	if character:faction():is_allowed_to_capture_territory() then
		if cm:char_is_general_with_army(character) and character:faction():has_home_region() then
			local home = character:faction():home_region():settlement();
			if distance_squared(character:logical_position_x(), character:logical_position_y(), home:logical_position_x(), home:logical_position_y()) >= 100000 then
				campaign_traits:give_trait(character, "wh2_main_trait_far_from_capital");
			end
		end
	end
end

--------------------------------------
---- IN OWNED SETTLEMENT TOO LONG ----
--------------------------------------
events.CharacterTurnStart[#events.CharacterTurnStart+1] =
function (context)
	local character = context:character();
	
	if character:faction():is_human() and character:has_region() and character:faction():is_allowed_to_capture_territory() and cm:char_is_general_with_army(character) and cm:model():campaign_name_key() ~= "wh3_main_prologue" then
		if character:in_settlement() and character:region():public_order() >= 90 and character:military_force():active_stance() ~= "MILITARY_FORCE_ACTIVE_STANCE_TYPE_MUSTER" then
			local char_turns_being_lazy = campaign_traits:get_lord_record(character, "turns_lazy") or 0;
			char_turns_being_lazy = char_turns_being_lazy + 1;
			
			if char_turns_being_lazy >= 20 then
				campaign_traits:give_trait(character, "wh2_main_trait_lazy");
				campaign_traits:set_lord_record(character, "turns_lazy", 0);
			else
				campaign_traits:set_lord_record(character, "turns_lazy", char_turns_being_lazy);
			end
		else
			campaign_traits:set_lord_record(character, "turns_lazy", 0);
		end
	end;
end

---------------------------------------------
---- IN SETTLEMENT WITH LOW PUBLIC ORDER ----
---------------------------------------------
events.CharacterTurnStart[#events.CharacterTurnStart+1] =
function (context)
	local character = context:character();
	
	if character:has_region() and character:in_settlement() == true then
		local region = character:region();
		if region:public_order() <= -20 and region:owning_faction():is_faction(character:faction()) then 
			campaign_traits:give_trait(character, "wh2_main_trait_public_order");
		end
	end;
end

------------------------------------
---- TURNS IN CORRUPTED REGIONS ----
------------------------------------
events.CharacterTurnStart[#events.CharacterTurnStart+1] =
function (context)
	local character = context:character();
	
	if character:has_region() then
		local region = character:region();
		
		local corruption_to_trait = {
			{chaos_corruption_string, "wh2_main_trait_corrupted_chaos"},
			{vampiric_corruption_string, "wh2_main_trait_corrupted_vampire"},
			{khorne_corruption_string, "wh3_main_trait_corrupted_khorne"},
			{nurgle_corruption_string, "wh3_main_trait_corrupted_nurgle"},
			{slaanesh_corruption_string, "wh3_main_trait_corrupted_slaanesh"},
			{tzeentch_corruption_string, "wh3_main_trait_corrupted_tzeentch"},
		}
		
		for i = 1, #corruption_to_trait do
			local current_corruption = cm:get_corruption_value_in_region(region, corruption_to_trait[i][1])
			
			if current_corruption >= 8 then
				campaign_traits:give_trait(character, corruption_to_trait[i][2]);
			elseif current_corruption < 3 and character:trait_points(corruption_to_trait[i][2]) > 0 then
				campaign_traits:give_trait(character, "wh2_main_trait_non_corrupted");
			end
		end
	end
end

--------------------------------------------
---- IN REGION WHEN BUILDINGS ARE BUILT ----
--------------------------------------------
events.BuildingCompleted[#events.BuildingCompleted+1] =
function (context)
	local building = context:building();
	local faction = building:faction()

	if faction:character_list():num_items() > 1 then
		for i = 0, faction:character_list():num_items() - 1 do
			local builder = faction:character_list():item_at(i);
			
			if builder:has_region() and cm:char_is_general_with_army(builder) and builder:region():name() == building:region():name() then
				campaign_traits:give_trait(builder, "wh2_main_trait_builder");
			end
		end
	end
end

------------------------------------------------
---- ARMY SUFFERS HIGH CASUALTIES IN BATTLE ----
------------------------------------------------
events.CharacterCompletedBattle[#events.CharacterCompletedBattle+1] =
function (context)
	local character = context:character();
	
	if cm:char_is_general_with_army(character) then
		local losses = character:percentage_of_own_alliance_killed();
		
		if losses >= 0.6 then
			campaign_traits:give_trait(character, "wh2_main_trait_casualties");
		end
	end
end

-----------------------------------------
---- AGENT ACTIONS AGAINST CHARACTER ----
-----------------------------------------
events.CharacterCharacterTargetAction[#events.CharacterCharacterTargetAction+1] =
function (context)
	local target = context:target_character();
	
	if context:ability() == "assist_army" or context:ability() == "assist_province" or context:ability() == "command_force" or context:ability() == "passive_ability" then
		return false;
	end
	
	if context:mission_result_success() == true or context:mission_result_critial_success() == true then
	
		if target:is_null_interface() == false then
			campaign_traits:give_trait(target, "wh2_main_trait_agent_target_success");
			
			if context:agent_action_key() == "wh2_main_agent_action_champion_hinder_agent_assassinate" or context:agent_action_key() == "wh2_main_agent_action_spy_hinder_agent_assassinate" then
				campaign_traits:give_trait(target, "wh2_main_trait_wounded");
			end
		end
	elseif context:mission_result_opportune_failure() == true or context:mission_result_failure() == true or context:mission_result_critial_failure() == true then
		if target:is_null_interface() == false then
			campaign_traits:give_trait(target, "wh2_main_trait_agent_target_fail");
		end
	end
end

-----------------------
---- DENIES SKAVEN ----
-----------------------
events.CharacterTurnStart[#events.CharacterTurnStart+1] =
function (context)
	local character = context:character();
	local skaven_points = 0;
	skaven_points = skaven_points + character:trait_points("wh2_main_trait_agent_actions_against_skaven");
	skaven_points = skaven_points + character:trait_points("wh2_main_trait_defeats_against_skaven");
	skaven_points = skaven_points + character:trait_points("wh2_main_trait_reinforcing_skaven");
	skaven_points = skaven_points + character:trait_points("wh2_main_trait_wins_against_skaven");
	
	if skaven_points < 1 and character:has_region() and cm:get_corruption_value_in_region(character:region(), skaven_corruption_string) >= 8 then
		campaign_traits:give_trait(character, "wh2_main_trait_corrupted_skaven");
	end
end

function campaign_traits:remove_skaven_from_character_and_force(character)
	self:remove_trait(character, "wh2_main_trait_corrupted_skaven");
	
	if character:has_military_force() == true then
		local force = character:military_force();
		local force_characters = force:character_list();
		
		for i = 0, force_characters:num_items() - 1 do
			local force_character = force_characters:item_at(i);
			self:remove_trait(force_character, "wh2_main_trait_corrupted_skaven");
		end
	end
end

-------------------------------
---- IN REGION WITH SLAVES ----
-------------------------------
events.CharacterTurnStart[#events.CharacterTurnStart+1] =
function (context)
	local character = context:character();
	
	if character:has_region() and character:in_settlement() then 
		local region = character:region();

		if region:has_faction_province_slaves() and region:percentage_faction_province_slaves() > 99 and region:num_faction_province_slaves() >= 300 then
			campaign_traits:give_trait(character, "wh2_main_trait_slaver");
		end
	end
end

-----------------------------
---- AGENT ACTION TRAITS ----
-----------------------------
events.CharacterCharacterTargetAction[#events.CharacterCharacterTargetAction+1] =
function (context)
	if context:mission_result_critial_success() or context:mission_result_success() then
		local trait_key = campaign_traits.action_to_trait[campaign_traits.action_key_to_action[context:agent_action_key()]];
		if trait_key ~= nil then
			campaign_traits:give_trait(context:character(), trait_key);
		end
	end
end

events.CharacterGarrisonTargetAction[#events.CharacterGarrisonTargetAction+1] =
function (context)
	if context:mission_result_critial_success() or context:mission_result_success() then
		local trait_key = campaign_traits.action_to_trait[campaign_traits.action_key_to_action[context:agent_action_key()]];
		if trait_key ~= nil then
			campaign_traits:give_trait(context:character(), trait_key);
		end
	end
end

---------------------------------
---- SETTRA FACTION TREASURY ----
---------------------------------
events.CharacterTurnStart[#events.CharacterTurnStart+1] =
function (context)
	local character = context:character();
	
	if character:character_subtype("wh2_dlc09_tmb_settra") then
		local money = character:faction():treasury();
		
		if character:trait_points("wh2_dlc09_trait_settra_title") == 0 and money >= 50000 then
			campaign_traits:give_trait(character, "wh2_dlc09_trait_settra_title", 2);
		elseif character:trait_points("wh2_dlc09_trait_settra_title") == 1 and money >= 100000 then
			campaign_traits:give_trait(character, "wh2_dlc09_trait_settra_title");
		elseif character:trait_points("wh2_dlc09_trait_settra_title") == 2 and money >= 200000 then
			campaign_traits:give_trait(character, "wh2_dlc09_trait_settra_title");
		end
	end
end

-------------------------------
---- SWORD OF KHAINE CURSE ----
-------------------------------
events.CharacterTurnStart[#events.CharacterTurnStart+1] =
function (context)
	local character = context:character();
	
	if character:has_ancillary("wh2_dlc10_anc_weapon_the_widowmaker_3") then
		if character:faction():has_effect_bundle("wh2_sword_of_khaine_3") then
			campaign_traits:give_trait(character, "wh2_dlc10_trait_sword_of_khaine");
		end
	end
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("TRAIT_LORDS_RECORDS", campaign_traits.lords_records, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		campaign_traits.lords_records = cm:load_named_value("TRAIT_LORDS_RECORDS", {}, context);
	end
);