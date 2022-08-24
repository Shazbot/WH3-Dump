local Grom_faction = "wh2_dlc15_grn_broken_axe";
local Grom_cqi = 0;

local yvresse_region_key = "wh3_main_combi_region_tor_yvresse"

-- this session is to keep track of food trait with respect to recipe unlock threshold
local food_trait = "wh2_dlc15_grom_food_collector";
local food_trait_threshold = {0, 4, 8, 12, 15};
local cooked_dish = {};
--blacktoof will ask the player to collect this number of ingredients
local blacktoof_required_ingredients_number = 6;
local blacktoof_required_recipe_number = 12;
local dishcookedhag = false;

-- this session defines food/recipe related info
-- ur index for ingredients
local food_index = {
						"wh2_dlc15_boar",
						"wh2_dlc15_goblin",
						"wh2_dlc15_lion",
						"wh2_dlc15_lizard",
						"wh2_dlc15_troll",
						"wh2_dlc15_bat",
						"wh2_dlc15_dragon",
						"wh2_dlc15_eagle",
						"wh2_dlc15_harpy",
						"wh2_dlc15_phoenix",
						"wh2_dlc15_clams",
						"wh2_dlc15_crab",
						"wh2_dlc15_gold_fish",
						"wh2_dlc15_puffer_fish",
						"wh2_dlc15_tentacle",
						"wh2_dlc15_glowing",
						"wh2_dlc15_green",
						"wh2_dlc15_indigo",
						"wh2_dlc15_pepper",
						"wh2_dlc15_stinky",
						"wh2_dlc15_ale",
						"wh2_dlc15_discharge",
						"wh2_dlc15_ectoplasm",
						"wh2_dlc15_milk",
						"wh2_dlc15_yolk"
};

--your index for recipes
local recipe_index = {
						"wh2_dlc15_food_dish_1",
						"wh2_dlc15_food_dish_2",
						"wh2_dlc15_food_dish_3",
						"wh2_dlc15_food_dish_4",
						"wh2_dlc15_food_dish_5",
						"wh2_dlc15_food_dish_6",
						"wh2_dlc15_food_dish_7",
						"wh2_dlc15_food_dish_8",
						"wh2_dlc15_food_dish_9",
						"wh2_dlc15_food_dish_10",
						"wh2_dlc15_food_special_dish_1",
						"wh2_dlc15_food_special_dish_2",
						"wh2_dlc15_food_special_dish_3",
						"wh2_dlc15_food_special_dish_4",
						"wh2_dlc15_food_special_dish_5"
};

--ingredients added into this list can be randomly unlocked from sea encounters
local food_sea_encounter_index = {	"wh2_dlc15_clams",
									"wh2_dlc15_crab",
									"wh2_dlc15_gold_fish",
									"wh2_dlc15_puffer_fish",
									"wh2_dlc15_tentacle"};

--this value defines how much chance it is to unlock from sea encounters
local food_sea_ecnounter_chance = 50;

-- this keeps food category info if it's ever neeeded
local food_cate_index = {	["wh2_dlc15_boar"] = 		"wh2_dlc15_animals",
							["wh2_dlc15_goblin"] =		"wh2_dlc15_animals",
							["wh2_dlc15_lion"] = 		"wh2_dlc15_animals",
							["wh2_dlc15_lizard"] =		"wh2_dlc15_animals",
							["wh2_dlc15_troll"] =		"wh2_dlc15_animals",
							["wh2_dlc15_bat"] = 		"wh2_dlc15_birds",
							["wh2_dlc15_dragon"] = 		"wh2_dlc15_birds",
							["wh2_dlc15_eagle"] = 		"wh2_dlc15_birds",
							["wh2_dlc15_harpy"] = 		"wh2_dlc15_birds",
							["wh2_dlc15_phoenix"] = 	"wh2_dlc15_birds",
							["wh2_dlc15_clams"] = 		"wh2_dlc15_fishes",
							["wh2_dlc15_crab"] = 		"wh2_dlc15_fishes",
							["wh2_dlc15_gold_fish"] = 	"wh2_dlc15_fishes",
							["wh2_dlc15_puffer_fish"] =	"wh2_dlc15_fishes",
							["wh2_dlc15_tentacle"] = 	"wh2_dlc15_fishes",
							["wh2_dlc15_glowing"] = 	"wh2_dlc15_mushrooms",
							["wh2_dlc15_green"] = 		"wh2_dlc15_mushrooms",
							["wh2_dlc15_indigo"] = 		"wh2_dlc15_mushrooms",
							["wh2_dlc15_pepper"] = 		"wh2_dlc15_mushrooms",
							["wh2_dlc15_stinky"] = 		"wh2_dlc15_mushrooms",
							["wh2_dlc15_ale"] = 		"wh2_dlc15_slimes",
							["wh2_dlc15_discharge"] = 	"wh2_dlc15_slimes",
							["wh2_dlc15_ectoplasm"] = 	"wh2_dlc15_slimes",
							["wh2_dlc15_milk"] = 		"wh2_dlc15_slimes",
							["wh2_dlc15_yolk"] = 		"wh2_dlc15_slimes"
};

--this is a list of units record, upon recruiting a unit in corresponding list, the ingrdient will be unlocked, the script requires any one of it when given multiple
local food_recruit_index = {	["wh2_dlc15_boar"] = 	{},
							["wh2_dlc15_goblin"] =		{},
							["wh2_dlc15_lion"] = 		{},
							["wh2_dlc15_lizard"] =		{},
							["wh2_dlc15_troll"] =		{},
							["wh2_dlc15_bat"] = 		{},
							["wh2_dlc15_dragon"] = 		{},
							["wh2_dlc15_eagle"] = 		{},
							["wh2_dlc15_harpy"] = 		{},
							["wh2_dlc15_phoenix"] = 	{},
							["wh2_dlc15_clams"] = 		{},
							["wh2_dlc15_crab"] = 		{},
							["wh2_dlc15_gold_fish"] = 	{},
							["wh2_dlc15_puffer_fish"] =	{},
							["wh2_dlc15_tentacle"] = 	{},
							["wh2_dlc15_glowing"] = 	{},
							["wh2_dlc15_green"] = 		{},
							["wh2_dlc15_indigo"] = 		{},
							["wh2_dlc15_pepper"] = 		{"wh_main_grn_inf_night_goblin_fanatics", "wh_main_grn_inf_night_goblin_fanatics_1"},
							["wh2_dlc15_stinky"] = 		{},
							["wh2_dlc15_ale"] = 		{},
							["wh2_dlc15_discharge"] = 	{"wh2_dlc15_grn_mon_river_trolls_ror_0"},
							["wh2_dlc15_ectoplasm"] = 	{},
							["wh2_dlc15_milk"] = 		{},
							["wh2_dlc15_yolk"] = 		{"wh_main_grn_mon_arachnarok_spider_0", "wh2_dlc15_grn_mon_arachnarok_spider_waaagh_0"}
};

--this is a list of ingredients that can be unlocked thorugh character lvl up, it uses subtype keys 
local food_char_index = {	["wh2_dlc15_boar"] = 		{},
							["wh2_dlc15_goblin"] =		{},
							["wh2_dlc15_lion"] = 		{},
							["wh2_dlc15_lizard"] =		{},
							["wh2_dlc15_troll"] =		{},
							["wh2_dlc15_bat"] = 		{},
							["wh2_dlc15_dragon"] = 		{},
							["wh2_dlc15_eagle"] = 		{},
							["wh2_dlc15_harpy"] = 		{},
							["wh2_dlc15_phoenix"] = 	{},
							["wh2_dlc15_clams"] = 		{},
							["wh2_dlc15_crab"] = 		{},
							["wh2_dlc15_gold_fish"] = 	{},
							["wh2_dlc15_puffer_fish"] =	{},
							["wh2_dlc15_tentacle"] = 	{},
							["wh2_dlc15_glowing"] = 	{"grn_goblin_great_shaman", "grn_night_goblin_shaman", "wh2_dlc15_grn_goblin_great_shaman_raknik"},
							["wh2_dlc15_green"] = 		{},
							["wh2_dlc15_indigo"] = 		{"grn_orc_shaman"},
							["wh2_dlc15_pepper"] = 		{},
							["wh2_dlc15_stinky"] = 		{"wh2_dlc15_grn_river_troll_hag"},
							["wh2_dlc15_ale"] = 		{},
							["wh2_dlc15_discharge"] = 	{},
							["wh2_dlc15_ectoplasm"] = 	{},
							["wh2_dlc15_milk"] = 		{},
							["wh2_dlc15_yolk"] = 		{}
};


--this is a list of ingredients that can be unlocked from sacking settlements of a certain culture
local food_raze_index = {	["wh2_dlc15_boar"] = 		{},
							["wh2_dlc15_goblin"] =		{},
							["wh2_dlc15_lion"] = 		{},
							["wh2_dlc15_lizard"] =		{},
							["wh2_dlc15_troll"] =		{},
							["wh2_dlc15_bat"] = 		{},
							["wh2_dlc15_dragon"] = 		{},
							["wh2_dlc15_eagle"] = 		{},
							["wh2_dlc15_harpy"] = 		{"wh2_main_sc_def_dark_elves"},
							["wh2_dlc15_phoenix"] = 	{},
							["wh2_dlc15_clams"] = 		{"wh_main_sc_brt_bretonnia"},
							["wh2_dlc15_crab"] = 		{"wh2_dlc11_sc_cst_vampire_coast"},
							["wh2_dlc15_gold_fish"] = 	{"wh_main_sc_emp_empire"},
							["wh2_dlc15_puffer_fish"] =	{},
							["wh2_dlc15_tentacle"] = 	{"wh_dlc08_sc_nor_norsca"},
							["wh2_dlc15_glowing"] = 	{},
							["wh2_dlc15_green"] = 		{},
							["wh2_dlc15_indigo"] = 		{},
							["wh2_dlc15_pepper"] = 		{},
							["wh2_dlc15_stinky"] = 		{},
							["wh2_dlc15_ale"] = 		{"wh_main_sc_dwf_dwarfs"},
							["wh2_dlc15_discharge"] = 	{},
							["wh2_dlc15_ectoplasm"] = 	{},
							["wh2_dlc15_milk"] = 		{},
							["wh2_dlc15_yolk"] = 		{}
};

--this is a list of ingredients that can be unlocked by encountering certain enemies in battle and win against it, this takes main unit record
local food_unit_index = {	["wh2_dlc15_boar"] = 		{},
							["wh2_dlc15_goblin"] =		{},
							["wh2_dlc15_lion"] = 		{
														---units
														"wh2_dlc15_hef_mon_war_lions_of_chrace_0",
														"wh2_dlc15_hef_mon_war_lions_of_chrace_ror_0",
														"wh2_dlc15_hef_veh_lion_chariot_of_chrace_0",
														"wh2_main_hef_inf_white_lions_of_chrace_0",
														"wh2_dlc13_emp_cav_demigryph_knights_0_imperial_supply",
														"wh2_dlc13_emp_cav_demigryph_knights_1_imperial_supply",
														"wh_main_emp_cav_demigryph_knights_0",
														"wh_main_emp_cav_demigryph_knights_1",
														"wh2_dlc10_def_mon_feral_manticore_0",
														"wh_dlc03_bst_feral_manticore",
														"wh_dlc06_chs_feral_manticore",
														"wh_dlc08_nor_feral_manticore",
														"wh2_dlc15_hef_cha_alastair_1",
														"wh2_main_hef_cha_alastair_0",
														"wh2_main_hef_cha_alastair_3",
														"wh2_main_hef_cha_alastair_4",
														"wh2_main_hef_cha_alastair_5",
														"wh2_dlc15_hef_inf_mistwalkers_griffon_knights_0",
														"wh_dlc07_brt_cav_royal_hippogryph_knights_0",
														"wh2_dlc16_wef_mon_feral_manticore",
														--mounts
														"wh2_dlc15_hef_cha_eltharion_the_grim_2",
														"wh2_dlc15_hef_cha_prince_6",
														"wh2_dlc15_hef_cha_princess_6",
														"wh_dlc03_emp_cha_boris_todbringer_3",
														"wh_dlc03_emp_cha_wizard_beasts_3",
														"wh_main_emp_cha_general_3",
														"wh_main_emp_cha_karl_franz_1",
														"wh2_dlc10_def_cha_crone_5",
														"wh2_dlc10_def_cha_supreme_sorceress_beasts_4",
														"wh2_dlc10_def_cha_supreme_sorceress_dark_4",
														"wh2_dlc10_def_cha_supreme_sorceress_death_4",
														"wh2_dlc10_def_cha_supreme_sorceress_fire_4",
														"wh2_dlc10_def_cha_supreme_sorceress_shadow_4",
														"wh2_dlc14_def_cha_high_beastmaster_2",
														"wh_dlc01_chs_cha_chaos_lord_10",
														"wh_dlc01_chs_cha_chaos_sorcerer_lord_death_9",
														"wh_dlc01_chs_cha_chaos_sorcerer_lord_fire_9",
														"wh_dlc01_chs_cha_chaos_sorcerer_lord_metal_9",
														"wh_dlc01_chs_cha_chaos_sorcerer_lord_shadows_3",
														"wh_dlc01_chs_cha_chaos_sorcerer_shadows_3",
														"wh_dlc01_chs_cha_exalted_hero_10",
														"wh_main_chs_cha_chaos_sorcerer_death_9",
														"wh_main_chs_cha_chaos_sorcerer_fire_9",
														"wh_main_chs_cha_chaos_sorcerer_metal_9",
														"wh2_dlc14_brt_cha_henri_le_massif_3",
														"wh_dlc07_brt_cha_alberic_bordeleaux_3",
														"wh_main_brt_cha_king_louen_leoncoeur_1",
														"wh_main_brt_cha_lord_2",
														"wh2_twa03_def_cha_rakarth_2"
							},
							["wh2_dlc15_lizard"] =		{
														---Units---
														"wh2_dlc13_lzd_mon_dread_saurian_0",
														"wh2_dlc13_lzd_mon_dread_saurian_1",
														"wh2_dlc13_lzd_mon_dread_saurian_ror_0",
														"wh2_dlc12_lzd_mon_ancient_stegadon_1_nakai",
														"wh2_dlc12_lzd_mon_ancient_stegadon_1",
														"wh2_dlc12_lzd_mon_ancient_stegadon_ror_0",
														"wh2_main_lzd_mon_ancient_stegadon",
														"wh2_main_lzd_mon_stegadon_0",
														"wh2_main_lzd_mon_stegadon_1",
														"wh2_main_lzd_mon_stegadon_blessed_1",
														"wh2_dlc12_lzd_mon_bastiladon_3_nakai",
														"wh2_dlc12_lzd_mon_bastiladon_3",
														"wh2_main_lzd_mon_bastiladon_0",
														"wh2_main_lzd_mon_bastiladon_1",
														"wh2_main_lzd_mon_bastiladon_2",
														"wh2_main_lzd_mon_bastiladon_blessed_2",
														"wh2_main_lzd_mon_carnosaur_0",
														"wh2_main_lzd_mon_carnosaur_blessed_0",
														"wh2_dlc17_dwf_mon_carnosaur_thorek_0",
														"wh2_dlc17_lzd_mon_troglodon_0",
														"wh2_dlc17_lzd_mon_troglodon_ror_0",
														---mounts---
														"wh2_dlc12_lzd_cha_skink_chief_red_crested_3",
														"wh2_dlc12_lzd_cha_skink_priest_beasts_4",
														"wh2_dlc12_lzd_cha_skink_priest_heavens_4",
														"wh2_dlc12_lzd_cha_tehenhauin_3",
														"wh2_main_lzd_cha_kroq_gar_1",
														"wh2_main_lzd_cha_lord_mazdamundi_1",
														"wh2_main_lzd_cha_saurus_old_blood_2",
														"wh2_main_lzd_cha_saurus_scar_veteran_2",
														"wh2_main_lzd_cha_skink_chief_2",
														"wh2_main_lzd_cha_skink_chief_3",
														"wh2_main_lzd_cha_skink_priest_beasts_2",
														"wh2_main_lzd_cha_skink_priest_beasts_3",
														"wh2_main_lzd_cha_skink_priest_heavens_2",
														"wh2_main_lzd_cha_skink_priest_heavens_3",
														"wh2_dlc17_lzd_cha_skink_oracle_troglodon_0"
														},

							["wh2_dlc15_troll"] =		{},
							["wh2_dlc15_bat"] = 		{
														---units
														"wh2_dlc12_lzd_cav_terradon_riders_0_tlaqua",
														"wh2_dlc12_lzd_cav_terradon_riders_1_tlaqua",
														"wh2_dlc12_lzd_cav_terradon_riders_ror_0",
														"wh2_main_lzd_cav_terradon_riders_0",
														"wh2_main_lzd_cav_terradon_riders_1",
														"wh2_main_lzd_cav_terradon_riders_blessed_1",
														"wh2_dlc12_lzd_cav_ripperdactyl_riders_0",
														"wh2_dlc12_lzd_cav_ripperdactyl_riders_ror_0",
														"wh2_dlc15_grn_veh_snotling_pump_wagon_flappas_0",
														"wh2_dlc13_huntmarshall_veh_obsinite_gyrocopter_0",
														"wh_main_dwf_veh_gyrobomber",
														"wh_main_dwf_veh_gyrocopter_0",
														"wh_main_dwf_veh_gyrocopter_1",
														"wh_main_grn_art_doom_diver_catapult",

														---mounts
														"wh2_dlc12_lzd_cha_tiktaqto_1",
														"wh2_main_lzd_cha_skink_chief_1",
														"wh2_main_lzd_cha_skink_priest_beasts_1",
														"wh2_main_lzd_cha_skink_priest_heavens_1",
														"wh2_dlc12_lzd_cha_skink_chief_red_crested_2",
														"wh2_dlc12_lzd_cha_tehenhauin_2",
														"wh_dlc06_grn_cha_wurrzag_1",
														},
							["wh2_dlc15_dragon"] = 		{
														--units
														"wh2_main_hef_mon_moon_dragon",
														"wh2_main_hef_mon_star_dragon",
														"wh2_main_hef_mon_sun_dragon",
														"wh_dlc05_wef_forest_dragon_0",
														"wh2_main_def_mon_black_dragon",
														"wh2_dlc15_grn_mon_wyvern_waaagh_0",
														"wh_dlc08_nor_mon_frost_wyrm_0",
														"wh_dlc08_nor_mon_frost_wyrm_ror_0",
														--mounts
														"wh2_dlc10_def_cha_supreme_sorceress_beasts_5",
														"wh2_dlc10_def_cha_supreme_sorceress_dark_5",
														"wh2_dlc10_def_cha_supreme_sorceress_death_5",
														"wh2_dlc10_def_cha_supreme_sorceress_fire_5",
														"wh2_dlc10_def_cha_supreme_sorceress_shadow_5",
														"wh2_dlc11_def_cha_lokhir_fellheart_1",
														"wh2_dlc11_vmp_cha_bloodline_blood_dragon_lord_1",
														"wh2_dlc11_vmp_cha_bloodline_blood_dragon_lord_3",
														"wh2_dlc11_vmp_cha_bloodline_lahmian_lord_3",
														"wh2_dlc11_vmp_cha_bloodline_necrarch_lord_3",
														"wh2_dlc11_vmp_cha_bloodline_von_carstein_lord_3",
														"wh2_dlc15_hef_cha_imrik_2",
														"wh2_dlc15_hef_cha_mage_fire_3",
														"wh2_main_def_cha_dreadlord_4",
														"wh2_main_def_cha_dreadlord_female_4",
														"wh2_main_def_cha_malekith_3",
														"wh2_main_hef_cha_alastar_4",
														"wh2_main_hef_cha_alastar_5",
														"wh2_main_hef_cha_prince_4",
														"wh2_main_hef_cha_prince_5",
														"wh2_main_hef_cha_princess_4",
														"wh2_main_hef_cha_princess_5",
														"wh_dlc01_chs_cha_chaos_lord_2",
														"wh_dlc01_chs_cha_chaos_sorcerer_lord_death_10",
														"wh_dlc01_chs_cha_chaos_sorcerer_lord_fire_10",
														"wh_dlc01_chs_cha_chaos_sorcerer_lord_metal_10",
														"wh_dlc01_chs_cha_chaos_sorcerer_lord_shadows_4",
														"wh_dlc05_vmp_cha_red_duke_3",
														"wh_dlc05_wef_cha_female_glade_lord_3",
														"wh_dlc05_wef_cha_glade_lord_3",
														"wh_dlc08_chs_cha_chaos_lord_2_qb",
														"wh_dlc08_nor_cha_kihar_0",
														"wh_main_vmp_cha_mannfred_von_carstein_3",
														"wh_main_vmp_cha_vampire_lord_3",
														"wh2_dlc15_hef_cha_archmage_beasts_4",
														"wh2_dlc15_hef_cha_archmage_death_4",
														"wh2_dlc15_hef_cha_archmage_fire_4",
														"wh2_dlc15_hef_cha_archmage_heavens_4",
														"wh2_dlc15_hef_cha_archmage_high_4",
														"wh2_dlc15_hef_cha_archmage_life_4",
														"wh2_dlc15_hef_cha_archmage_light_4",
														"wh2_dlc15_hef_cha_archmage_metal_4",
														"wh2_dlc15_hef_cha_archmage_shadows_4",
														"wh_main_grn_cha_azhag_the_slaughterer_1",
														"wh_main_grn_cha_orc_warboss_1",
														"wh2_dlc16_wef_cha_sisters_of_twilight_1",
														"wh2_twa03_def_cha_rakarth_3"
														},
							["wh2_dlc15_eagle"] = 		{},
							["wh2_dlc15_harpy"] = 		{},
							["wh2_dlc15_phoenix"] = 	{},
							["wh2_dlc15_clams"] = 		{},
							["wh2_dlc15_crab"] = 		{},
							["wh2_dlc15_gold_fish"] = 	{},
							["wh2_dlc15_puffer_fish"] =	{"wh2_dlc11_cst_mon_bloated_corpse_0"},
							["wh2_dlc15_tentacle"] = 	{},
							["wh2_dlc15_glowing"] = 	{},
							["wh2_dlc15_green"] = 		{},
							["wh2_dlc15_indigo"] = 		{},
							["wh2_dlc15_pepper"] = 		{},
							["wh2_dlc15_stinky"] = 		{},
							["wh2_dlc15_ale"] = 		{},
							["wh2_dlc15_discharge"] = 	{},
							["wh2_dlc15_ectoplasm"] = 	{
														---units
														"wh_main_vmp_cha_banshee",
														"wh_main_vmp_inf_cairn_wraiths",
														"wh2_dlc09_tmb_cav_hexwraiths",
														"wh_main_vmp_cav_hexwraiths",
														"wh_dlc04_vmp_cav_chillgheists_0",
														"wh2_dlc11_cst_inf_syreens",
														"wh_dlc04_vmp_veh_mortis_engine_0",
														"wh_dlc04_vmp_veh_claw_of_nagash_0",
														"wh2_dlc09_tmb_art_casket_of_souls_0",
														"wh2_dlc09_tmb_cha_khatep_3",
														"wh2_dlc11_cst_cha_cylostra_direfin_0",
														"wh2_dlc11_cst_cha_cylostra_direfin_1",
														"wh_dlc07_brt_cha_green_knight_0",
														"wh2_dlc11_cst_cha_damned_paladin_0",
														"wh2_dlc11_cst_cha_damned_paladin_1",
														"wh_dlc06_dwf_cha_master_engineer_ghost_0",
														"wh_dlc06_dwf_cha_runesmith_ghost_0",
														"wh_dlc06_dwf_cha_thane_ghost_0",
														"wh_dlc06_dwf_cha_thane_ghost_1",
														"wh2_dlc11_cst_inf_deck_gunners_ror_0",
														"wh2_dlc09_tmb_inf_nehekhara_warriors_ror",
														"wh2_dlc11_cst_cha_mourngul_haunter",
														"wh2_dlc11_cst_mon_mournguls_0",
														"wh2_dlc11_cst_mon_mournguls_ror_0",
														"wh2_dlc17_dwf_cha_thane_ghost_2",
														"wh2_dlc16_wef_cav_great_stag_knights_ror_0"
														},
							["wh2_dlc15_milk"] = 		{
														"wh_dlc03_bst_inf_centigors_0",
														"wh_dlc03_bst_inf_centigors_1",
														"wh_dlc03_bst_inf_centigors_2",
														"wh_pro04_bst_inf_centigors_ror_0",
														"wh_dlc01_chs_mon_dragon_ogre", 
														"wh_dlc01_chs_mon_dragon_ogre_shaggoth",
														"wh_pro04_chs_mon_dragon_ogre_ror_0",
														"wh2_dlc09_tmb_mon_necrosphinx_0",
														"wh2_dlc09_tmb_mon_necrosphinx_ror",
														"wh_dlc03_bst_mon_chaos_spawn_0",
														"wh_main_chs_mon_chaos_spawn",
														"wh_pro04_chs_mon_chaos_spawn_ror_0",
														"wh2_dlc16_wef_mon_zoats",
														"wh2_dlc16_wef_mon_zoats_ror_0",
														"wh2_dlc17_bst_inf_centigors_ror_1"
														},
							["wh2_dlc15_yolk"] = 		{}
};

--this is a counter which adds up when one iongredient related battle listener is set
-- also it has a cache to store predefined post battle listners, so when u load back to campaign after a battle, the listner can be reconstructed
local food_battle_listener_count = 1;
local food_battle_post_listner_cache = { ["wh2_dlc15_boar"] = 		{false, {}},
										["wh2_dlc15_goblin"] =		{false, {}},
										["wh2_dlc15_lion"] = 		{false, {}},
										["wh2_dlc15_lizard"] =		{false, {}},
										["wh2_dlc15_troll"] =		{false, {}},
										["wh2_dlc15_bat"] = 		{false, {}},
										["wh2_dlc15_dragon"] = 		{false, {}},
										["wh2_dlc15_eagle"] = 		{false, {}},
										["wh2_dlc15_harpy"] = 		{false, {}},
										["wh2_dlc15_phoenix"] = 	{false, {}},
										["wh2_dlc15_clams"] = 		{false, {}},
										["wh2_dlc15_crab"] = 		{false, {}},
										["wh2_dlc15_gold_fish"] = 	{false, {}},
										["wh2_dlc15_puffer_fish"] =	{false, {}},
										["wh2_dlc15_tentacle"] = 	{false, {}},
										["wh2_dlc15_glowing"] = 	{false, {}},
										["wh2_dlc15_green"] = 		{false, {}},
										["wh2_dlc15_indigo"] = 		{false, {}},
										["wh2_dlc15_pepper"] = 		{false, {}},
										["wh2_dlc15_stinky"] = 		{false, {}},
										["wh2_dlc15_ale"] = 		{false, {}},
										["wh2_dlc15_discharge"] = 	{false, {}},
										["wh2_dlc15_ectoplasm"] = 	{false, {}},
										["wh2_dlc15_milk"] = 		{false, {}},
										["wh2_dlc15_yolk"] = 		{false, {}}
};


--merchant appearance CD, this is to stop the merchant from being spammable, currently not used
local Merchant_CD_default = 10;
local Merchant_CD = 10; 

--this will queue the merchant to appear after x turns, normally this timer is set when a dish cooked
local Merchant_queued = 10;
local Merchant_queue_range = 1;

--this will decide the interval when AI eats and Grom grows
local AI_eat_period = 15;
local AI_grow_period = 40;
local AI_eat_timer = AI_eat_period;
local AI_grow_timer = AI_grow_period;

--this is a list of all dilemmas, notice that there's one for each ingredients, and when all food ingredients are unlocked, there's one backup
local Merchant_dilemma = {
	["food"]=		{	
					"wh2_dlc15_dilemma_food_merchant_1",
					"wh2_dlc15_dilemma_food_merchant_2",
					"wh2_dlc15_dilemma_food_merchant_3",
					"wh2_dlc15_dilemma_food_merchant_4",
					"wh2_dlc15_dilemma_food_merchant_5",
					"wh2_dlc15_dilemma_food_merchant_6",
					"wh2_dlc15_dilemma_food_merchant_7",
					"wh2_dlc15_dilemma_food_merchant_8",
					"wh2_dlc15_dilemma_food_merchant_9",
					"wh2_dlc15_dilemma_food_merchant_10",
					"wh2_dlc15_dilemma_food_merchant_11",
					"wh2_dlc15_dilemma_food_merchant_12",
					"wh2_dlc15_dilemma_food_merchant_13",
					"wh2_dlc15_dilemma_food_merchant_14",
					"wh2_dlc15_dilemma_food_merchant_15",
					"wh2_dlc15_dilemma_food_merchant_16",
					"wh2_dlc15_dilemma_food_merchant_17",
					"wh2_dlc15_dilemma_food_merchant_18",
					"wh2_dlc15_dilemma_food_merchant_19",
					"wh2_dlc15_dilemma_food_merchant_20",
					"wh2_dlc15_dilemma_food_merchant_21",
					"wh2_dlc15_dilemma_food_merchant_22",
					"wh2_dlc15_dilemma_food_merchant_23",
					"wh2_dlc15_dilemma_food_merchant_24",
					"wh2_dlc15_dilemma_food_merchant_25"
					},					
	["no_food"]=	{"wh2_dlc15_dilemma_food_merchant_all_unlocked"}
};

--this is the list of all available food challenge objectives
local Food_challenge_keys = {
	"wh2_dlc15_obejctive_overriede_grom_food_merchant_1",
	"wh2_dlc15_obejctive_overriede_grom_food_merchant_2",
	"wh2_dlc15_obejctive_overriede_grom_food_merchant_3",
	"wh2_dlc15_obejctive_overriede_grom_food_merchant_4",
	"wh2_dlc15_obejctive_overriede_grom_food_merchant_5",
	"wh2_dlc15_obejctive_overriede_grom_food_merchant_6",
	"wh2_dlc15_obejctive_overriede_grom_food_merchant_7",
	"wh2_dlc15_obejctive_overriede_grom_food_merchant_8",
	"wh2_dlc15_obejctive_overriede_grom_food_merchant_9",
	"wh2_dlc15_obejctive_overriede_grom_food_merchant_10",
	"wh2_dlc15_obejctive_overriede_grom_food_merchant_11",
	"wh2_dlc15_obejctive_overriede_grom_food_merchant_12",
	"wh2_dlc15_obejctive_overriede_grom_food_merchant_13",
	"wh2_dlc15_obejctive_overriede_grom_food_merchant_14",
	"wh2_dlc15_obejctive_overriede_grom_food_merchant_15",
	"wh2_dlc15_obejctive_overriede_grom_food_merchant_16",
	"wh2_dlc15_obejctive_overriede_grom_food_merchant_17",
	"wh2_dlc15_obejctive_overriede_grom_food_merchant_18"
};

--this table defines which objective to trigger based on cauldron slot count, the futhre slot you unlock it becomes increasingly harder
local Food_challenge_details = {{7, 8, 9}, {13,14,15,16,17}, {1,2,3,4}};
--this table defines the reward from the food challenges
local Food_challenge_rewards = {{"effect_bundle{bundle_key wh2_dlc15_grom_increase_cooking_slot_1_dummy;turns 0;}", "money 3000"}, {"effect_bundle{bundle_key wh2_dlc15_grom_increase_cooking_slot_2_dummy;turns 0;}", "money 3000"}, {"faction_pooled_resource_transaction{resource grn_salvage;factor wh2_dlc12_resource_factor_loot;amount 150;}", "money 5000"}};

--these two table defines the condition of the food challenge, if u write{{1,2,3},{7,8}} it means the challenge requires any ingredient in {1,2,3} and any ingredient in {7,8}, same goes with dishes, and both ingredient and dish effects needs to be fulfilled 
local Food_challenge_required_ingredients = {
	["wh2_dlc15_obejctive_overriede_grom_food_merchant_1"] = {{6}},
	["wh2_dlc15_obejctive_overriede_grom_food_merchant_2"] = {{1,3}},
	["wh2_dlc15_obejctive_overriede_grom_food_merchant_3"] = {{19, 20}},
	["wh2_dlc15_obejctive_overriede_grom_food_merchant_4"] = {{11, 13, 15, 24}},
	["wh2_dlc15_obejctive_overriede_grom_food_merchant_5"] = {},
	["wh2_dlc15_obejctive_overriede_grom_food_merchant_6"] = {},
	["wh2_dlc15_obejctive_overriede_grom_food_merchant_7"] = {},
	["wh2_dlc15_obejctive_overriede_grom_food_merchant_8"] = {},
	["wh2_dlc15_obejctive_overriede_grom_food_merchant_9"] = {},
	["wh2_dlc15_obejctive_overriede_grom_food_merchant_10"] = {},
	["wh2_dlc15_obejctive_overriede_grom_food_merchant_11"] = {},
	["wh2_dlc15_obejctive_overriede_grom_food_merchant_12"] = {},
	["wh2_dlc15_obejctive_overriede_grom_food_merchant_13"] = {},
	["wh2_dlc15_obejctive_overriede_grom_food_merchant_14"] = {},
	["wh2_dlc15_obejctive_overriede_grom_food_merchant_15"] = {},
	["wh2_dlc15_obejctive_overriede_grom_food_merchant_16"] = {},
	["wh2_dlc15_obejctive_overriede_grom_food_merchant_17"] = {},
	["wh2_dlc15_obejctive_overriede_grom_food_merchant_18"] = {}
};

local Food_challenge_required_recipes = {
	["wh2_dlc15_obejctive_overriede_grom_food_merchant_1"] = {{1,3}},
	["wh2_dlc15_obejctive_overriede_grom_food_merchant_2"] = {{7}},
	["wh2_dlc15_obejctive_overriede_grom_food_merchant_3"] = {{8}},
	["wh2_dlc15_obejctive_overriede_grom_food_merchant_4"] = {{9}},
	["wh2_dlc15_obejctive_overriede_grom_food_merchant_5"] = {},
	["wh2_dlc15_obejctive_overriede_grom_food_merchant_6"] = {},
	["wh2_dlc15_obejctive_overriede_grom_food_merchant_7"] = {{2, 15}},
	["wh2_dlc15_obejctive_overriede_grom_food_merchant_8"] = {{7, 9}},
	["wh2_dlc15_obejctive_overriede_grom_food_merchant_9"] = {{4, 6, 12, 13}},
	["wh2_dlc15_obejctive_overriede_grom_food_merchant_10"] = {},
	["wh2_dlc15_obejctive_overriede_grom_food_merchant_11"] = {},
	["wh2_dlc15_obejctive_overriede_grom_food_merchant_12"] = {},
	["wh2_dlc15_obejctive_overriede_grom_food_merchant_13"] = {{12, 14}},
	["wh2_dlc15_obejctive_overriede_grom_food_merchant_14"] = {{11, 12, 13, 15}},
	["wh2_dlc15_obejctive_overriede_grom_food_merchant_15"] = {{11, 14}},
	["wh2_dlc15_obejctive_overriede_grom_food_merchant_16"] = {{11, 13, 14, 15}},
	["wh2_dlc15_obejctive_overriede_grom_food_merchant_17"] = {{12, 13, 15}},
	["wh2_dlc15_obejctive_overriede_grom_food_merchant_18"] = {{12, 13, 15}}
};

--this keeps track of the active food challenge, by if it existed, and which one is active
local Food_challenge_info = {false, -1, 1};

function add_grom_food_listeners()
	out("#### Adding Grom Caulrdon Listeners ####");
	--this will steup the listener for food unlock
	local faction_interface = cm:get_faction(Grom_faction);
	
	--without grom's faction, nothing needs to happen
	if not faction_interface or faction_interface:is_dead() then
		return;
	end
	
	--giving Grom his starting trait
	if cm:is_new_game() then
		Grom_cqi = faction_interface:faction_leader():command_queue_index();
		cm:force_add_trait("character_cqi:"..Grom_cqi, food_trait, true);
	else
		Grom_cqi = faction_interface:faction_leader():command_queue_index();
	end
	
	
	
	--setup a random food for grom every AI_eat_period turn, and grow him every AI_grow_period turn
	if not faction_interface:is_human() then
		cm:add_faction_turn_start_listener_by_name(
			"AI_food_eating",
			Grom_faction,
			function(context)
				local faction = context:faction();
				--setup the food cooking
				if AI_eat_timer == 0 then
					out("AI Grom is easting now");
					local random_number = cm:random_number(10);
					cm:force_cook_recipe(faction, recipe_index[random_number], false);
					AI_eat_timer = AI_eat_period;
				else
					AI_eat_timer = AI_eat_timer - 1;
				end
				--setup the Grom trait
				if AI_grow_timer == 0 then
					out("AI Grom is easting now");
					local random_number = cm:random_number(10);
					cm:force_add_trait("character_cqi:"..Grom_cqi, food_trait, true);
					AI_grow_timer = AI_grow_period;
				else
					AI_grow_timer = AI_grow_timer - 1;
				end
			end,
			true
		);

		--note that if Grom is AI will skip the rest of the bespoken listerners for human player
		return;
	end
	
	local un_obtained_food = GetFoodList(false);
	
	--resend the cooked dish to UI
	local component = find_uicomponent(core:get_ui_root(), "grom_goals");
	for i = 1, #cooked_dish do
		if component then
			component:InterfaceFunction("AddCookedRecipe", cooked_dish[i]);
		end
	end
	
	--bespoken unique listners are setup here
	for i = 1, #un_obtained_food do
		SetupFoodListeners(i);
	end
	
	--setup the battle/unit recruit/subculture sacked listerners, these are reusable and defined in corresponding variable list
	SetupFoodBattleListeners();

	check_and_setup_specific_unit_recuirt_in_campaign();
	check_and_setup_specific_subcul_sack_in_campaign();
	check_and_setup_specific_char_lvl_up_in_campaign();
	check_and_setup_specific_sea_encounter_in_campaign();
	
	--unlock ingredient and recipe from blacktoof mission
	core:add_listener(
	"Blacktoof_food_unlock",
	"MissionSucceeded", 
	function(context)
		if context:faction():name() == Grom_faction then
			return true;
		else
			return false;
		end
	end,
	function(context)
		local faction = context:faction();
		local mission = context:mission():mission_record_key();
		if mission == "wh2_dlc15_grn_grom_black_toof_1" then
			out("unlocking a certain ingredient from black toof");
			UnlockFood(food_index[17]);
		elseif mission == "wh2_dlc15_grn_grom_black_toof_3_2" or mission == "wh2_dlc15_grom_blacktoof_prophecy_0"  or mission == "wh2_dlc15_grom_blacktoof_prophecy_1" or mission == "wh2_dlc15_grom_blacktoof_prophecy_2" then
			UnlockSpecialRecipe();
		elseif mission == "wh2_dlc15_main_grn_grom_axe_of_grom_stage_4" or mission == "wh2_dlc15_main_grn_grom_axe_of_grom_stage_4_mpc" or mission == "wh2_dlc15_vortex_grn_grom_axe_of_grom_stage_4_mpc" or mission == "wh2_dlc15_vortex_grn_grom_axe_of_grom_stage_4" then
			UnlockFood(food_index[8]);
		end
	end,
	true
	);
	
	--handles merchant at turn start
	--backup listerner for blacktoof missions/prophecies
	cm:add_faction_turn_start_listener_by_name(
		"Merchant_handler_black_toof_listener",
		Grom_faction,
		function(context)
			local faction = context:faction();
			HandleFoodMerchant();
			--checks how many recipe is eaten
			if #cooked_dish >= blacktoof_required_recipe_number then
				core:trigger_event("GromEatenEnoughRecipes");
			end
			--checks how many ingredients is avaialble
			local list = GetFoodList(true);
			if #list >= blacktoof_required_ingredients_number then
				core:trigger_event("GromHasUnlockedEnoughIngredients");
			end
		end,
		true
	);

	--trait control for grom
	--also controls merchant spawning
	--also dilivers bespoke effects
	core:add_listener(
	"Dish_cooked_listener",
	"FactionCookedDish", 
	function(context)
		out("grom is here!!!!!!!!!!!!!!!!!!!!!");
		out(Grom_cqi);
		if cm:get_faction(Grom_faction) and cm:get_character_by_cqi(Grom_cqi) then
			return true;
		end
	end,
	function(context)
		--controls the trait of Grom
		local char_interface = cm:get_character_by_cqi(Grom_cqi);
		local current_lvl = char_interface:trait_points(food_trait);
		local check_resu = false;
		local dish_key = context:dish():recipe();
		--check and updates the cooked dish list
		out("grom is here!!!!!!!!!!!!!!!!!!!!!");
		for i = 1, #cooked_dish do
			if cooked_dish[i] == dish_key then
				check_resu = true;
			end
		end
		out("grom is here!!!!!!!!!!!!!!!!!!!!!");
		if check_resu == false then
			local component = find_uicomponent(core:get_ui_root(), "grom_goals");
			out("grom is here!!!!!!!!!!!!!!!!!!!!!");
			if component then
				out("grom is here!!!!!!!!!!!!!!!!!!!!!");
				component:InterfaceFunction("AddCookedRecipe", dish_key);
			end
			table.insert(cooked_dish,dish_key);
		end
		--checks how many recipe is eaten
		if #cooked_dish >= blacktoof_required_recipe_number then
			core:trigger_event("GromEatenEnoughRecipes");
		end
		--adjust the trait lvl accordingly
		for i = 1, #food_trait_threshold do
			if #cooked_dish >= food_trait_threshold[i] and current_lvl < i then
				cm:force_add_trait("character_cqi:"..Grom_cqi, food_trait, true);
			end
		end
		current_lvl = char_interface:trait_points(food_trait);
		
		--setup merchant to show up after cooking
		if dishcookedhag == false then
			HandleFoodMerchant(cm:random_number(Merchant_queue_range));
		else
			dishcookedhag = false;
		end
		
		--deliver bespoke effects
		local ingredients = context:dish():ingredients();
		for  i = 1, #ingredients do
			if ingredients[i] == food_index[11] then
				--give gold
				cm:treasury_mod(Grom_faction, 2000);
			elseif ingredients[i] == food_index[12] then
				--give scrap
				cm:faction_add_pooled_resource(Grom_faction, "grn_salvage", "looting", 10);
			elseif ingredients[i] == food_index[14] then
				--give squigs
				cm:add_units_to_faction_mercenary_pool(cm:get_faction(Grom_faction):command_queue_index(), "wh_dlc06_grn_inf_squig_explosive_0", 5);
			elseif ingredients[i] == food_index[17] then
				--give waaagh
				cm:faction_add_pooled_resource(Grom_faction, "grn_waaagh", "other", 5);
			elseif ingredients[i] == food_index[25] then
				--give spider
				cm:add_units_to_faction_mercenary_pool(cm:get_faction(Grom_faction):command_queue_index(),"wh2_dlc15_grn_cav_forest_goblin_spider_riders_waaagh_0",5)
			end
		end
	end,
	true
	);


	
	--listner for food challenge
	setup_food_challenge_listerner();

	--listner for marker triggering
	core:add_listener(
		"area_entered_trigger_food_merchant",
		"AreaEntered",
		function(context)
			return context:area_key() == "food_merchant";
		end,
		function(context)
			local character = context:family_member():character();
			if not character:is_null_interface() then
				out("food merchant being triggered");
				local faction = character:faction();
				local faction_name = faction:name();
				
				if faction_name == Grom_faction then
					TriggerFoodMerchant(context);
					cm:remove_interactable_campaign_marker("food_merchant");
				end;
			end;
		end,
		true
	);

	--listener for food merchant dilemma
	core:add_listener(
	"foodmerchant_dilemma_choice",
	"DilemmaChoiceMadeEvent",
	true,
	function(context)
		local choice = context:choice();
		local dilemma = context:dilemma();
		local index = -1;
		out("checking food dilemma!!");
		for i = 1, #Merchant_dilemma["food"] do
			if dilemma == Merchant_dilemma["food"][i] then
				index = i;
				if choice == 0 then
					--unlock food in index i
					UnlockFood(food_index[i]);
					out("food choice 0");
				elseif choice == 1 then
					--food chellenge
					out("food choice 1");
					SetupFoodChallenge();
				elseif choice == 2 then
					--refresh and add new food effect
					out("food choice 2");
					local cooking_interface = cm:model():world():cooking_system():faction_cooking_info(cm:get_faction(Grom_faction));
					local rand = cm:random_number(9);
					if cooking_interface:active_dish() == recipe_index[rand] then
						rand = rand+1;
					end
					out(recipe_index[rand]);
					dishcookedhag = true;
					cm:force_cook_recipe(cm:get_faction(Grom_faction), recipe_index[rand], false);
					cm:trigger_incident(Grom_faction, "wh2_dlc15_grom_cauldron_food_cooked", true);
				elseif choice == 3 then
					--sell food
					out("food choice 3");
				end
			end
		end
		for i = 1, #Merchant_dilemma["no_food"] do
			if dilemma == Merchant_dilemma["no_food"][i] then
				index = i;
				if choice == 0 then
					--food chellenge
					out("food choice 1");
					SetupFoodChallenge();
				elseif choice == 1 then
					--refresh and add new food effect
					out("food choice 2");
					local cooking_interface = cm:model():world():cooking_system():faction_cooking_info(cm:get_faction(Grom_faction));
					local rand = cm:random_number(9);
					if cooking_interface:active_dish() == recipe_index[rand] then
						rand = rand+1;
					end
					cm:force_cook_recipe(cm:get_faction(Grom_faction), recipe_index[rand], false);
					cm:trigger_incident(Grom_faction, "wh2_dlc15_grom_cauldron_food_cooked", true);
				elseif choice == 2 then
					--sell food
					out("food choice 3");
				end
			end
		end
	end,
	true
	);
	
end

function SetupFoodBattleListeners()
	out("setting up food ingredients in pre battle");
	--reconstruct existing battle listners, this is for loading out of battle, and back to campaign
	for i = 1, #food_index do
		SetupFoodPostBattleListeners(i);
	end
	--add pending battle listeners
	core:add_listener(
			"food_pre_battle",
			"PendingBattle",
			true,
			function(context)
				--check unlock state of food
				for i = 1, #food_index do
					check_and_setup_specific_unit_victories_in_battle(i, context);
				end
			end,
			true
		);
end


function SetupFoodListeners(index)
	local cooking_interface = cm:model():world():cooking_system():faction_cooking_info(cm:get_faction(Grom_faction));
	if cooking_interface:is_ingredient_unlocked(food_index[index]) then
		return;
	end
	if index == 1 then
		--setup each ingredient listener
		core:add_listener(
			"food_"..tostring(index),
			"CharacterAncillaryGained",
			function(context)
				out(context:ancillary());
				local list_anc = {	"wh2_pro09_anc_mount_grn_black_orc_big_boss_war_boar",
									"wh_main_anc_mount_grn_orc_warboss_war_boar",
									"wh_main_anc_mount_grn_wizard_orc_shaman_war_boar"};
				local check_res = false;
				for i = 1, #list_anc do
					if context:character():faction():name() == Grom_faction and context:ancillary() == list_anc[i] then
						check_res = true;
					end
				end
				--check unlock state of food
				return check_res;
			end,
			function(context)
				--check unlock state of food
				UnlockFood(food_index[index]);
			end,
			false
		);
	elseif index == 2 then
		--WIP listen to a waaagh being called and successful
		core:add_listener(
			"food_"..tostring(index),
			"PlayerWaghEndedSuccessful",
			function(context)
				--check unlock state of food
				return true;
			end,
			function(context)
				UnlockFood(food_index[index]);
			end,
			false
		);
	elseif index == 3 then
		
	elseif index == 4 then
		
	elseif index == 5 then
		--this one u start with
		core:add_listener(
			"food_"..tostring(index),
			"FactionTurnStart",
			function(context)
				--check unlock state of food
				return true;
			end,
			function(context)
				UnlockFood(food_index[index]);
			end,
			false
		);
	elseif index == 6 then
		
	elseif index == 7 then
		
	elseif index == 9 then
		
	elseif index == 8 then
		--listen to the personal chain of grom
		core:add_listener(
			"food_"..tostring(index),
			"MissionSucceeded",
			function(context)
				--check unlock state of food
				local faction = context:faction();
				local mission = context:mission():mission_record_key();
				local check = false;
				if faction:name() == Grom_faction then
					local missions_to_check = 	{"wh2_dlc15_main_grn_grom_axe_of_grom_stage_4_mpc",
												"wh2_dlc15_main_grn_grom_axe_of_grom_stage_4",
												"wh2_dlc15_vortex_grn_grom_axe_of_grom_stage_4_mpc",
												"wh2_dlc15_vortex_grn_grom_axe_of_grom_stage_4"};
					for i = 1, #missions_to_check do
						if missions_to_check[i] == mission then
							check = true;
						end
					end
				end
				return check;
			end,
			function(context)
				UnlockFood(food_index[index]);
			end,
			false
		);	
	elseif index == 10 then
		--listen to a waaagh trophy towards HEF
		core:add_listener(
			"food_"..tostring(index),
			"PlayerGainedWaghElfTrophy",
			function(context)
				--check unlock state of food
				return true;
			end,
			function(context)
				UnlockFood(food_index[index]);
			end,
			false
		);	
	elseif index == 11 then
		-- listen to sea encoutners
	elseif index == 12 then
		-- listen to sea encoutners
	elseif index == 13 then
		-- listen to sea encoutners
	elseif index == 14 then
		-- listen to sea encoutners
	elseif index == 15 then
		-- listen to sea encoutners
	elseif index == 16 then
		
	elseif index == 17 then
		---listen for blacktoof quests
	elseif index == 18 then
		
	elseif index == 19 then
		
	elseif index == 20 then
		
	elseif index == 21 then
		
	elseif index == 22 then
	
	elseif index == 23 then

	elseif index == 24 then

	elseif index == 25 then

	end
end

function update_sea_encounter_food_list()
	local food_to_check = {};
	local cooking_interface = cm:model():world():cooking_system():faction_cooking_info(cm:get_faction(Grom_faction));
	for i = 1, #food_sea_encounter_index do
		if cooking_interface:is_ingredient_unlocked(food_sea_encounter_index[i]) == false then
			--return the list of obtained food
			table.insert(food_to_check, food_sea_encounter_index[i]);
		end
	end
	food_sea_encounter_index = food_to_check;
end

function check_and_setup_specific_sea_encounter_in_campaign()
	update_sea_encounter_food_list();
	core:add_listener(
				"food_encounter",
				"ScriptEventSeaEncounterTriggeredByPlayerThatIsPlayingGrom",
				function(context)
					--check unlock state of food
					out("deciding what to do with ingredient at sea");
					if #food_sea_encounter_index ~= 0 then
						return cm:model():random_percent(food_sea_ecnounter_chance);
					else
						return false;
					end
				end,
				function(context)
					local selection = cm:random_number(#food_sea_encounter_index);
					UnlockFood(food_sea_encounter_index[selection]);
					update_sea_encounter_food_list();
				end,
				true
			);
end

function check_and_setup_specific_char_lvl_up_in_campaign()
	for i = 1, #food_index do
		core:add_listener(
				"food_char"..tostring(i),
				"CharacterRankUp",
				function(context)
					--check unlock state of food
					local check_res = false;
					for j = 1, #food_char_index[food_index[i]] do
						if context:character():faction():name() == Grom_faction and context:character():rank() >= 15 and context:character():character_subtype_key() == food_char_index[food_index[i]][j] then
							check_res = true;
						end
					end
					return check_res;
				end,
				function(context)
					UnlockFood(food_index[i]);
				end,
				false
			);
	end
end

function check_and_setup_specific_subcul_sack_in_campaign()
	for i = 1, #food_index do
		if #food_raze_index[food_index[i]] ~= 0 then
			core:add_listener(
			"food_raze"..tostring(i),
			"CharacterSackedSettlement",
			function(context)
				local check_res = false;
				for j = 1, #food_raze_index[food_index[i]] do
					local sulbcul = context:garrison_residence():faction():subculture();
					local sulbcul_to_check = food_raze_index[food_index[i]][j];
					if context:character():faction():name() == Grom_faction and sulbcul == sulbcul_to_check then
						check_res = true;
					end
					if sulbcul_to_check == "wh_main_sc_emp_empire" then
						if context:character():faction():name() == Grom_faction and (sulbcul == "wh_main_sc_teb_teb" or sulbcul == "wh_main_sc_ksl_kislev") then
							check_res = true;
						end
					end
				end
				return check_res;
			end,
			function(context)
				UnlockFood(food_index[i]);
			end,
			false
			);
		end
	end
end


function check_and_setup_specific_unit_recuirt_in_campaign()
	for i = 1, #food_index do
		if #food_recruit_index[food_index[i]] ~= 0 then
			core:add_listener(
			"food_recruit"..tostring(i),
			"UnitTrained",
			function(context)
				--check unlock state of food
				local check_res = false;
				if context:unit():has_force_commander() and context:unit():force_commander():faction():name() == Grom_faction then
					for j = 1, #food_recruit_index[food_index[i]] do
						if context:unit():unit_key() == food_recruit_index[food_index[i]][j] then
							check_res = true;
						end
					end
				end
				return check_res;
			end,
			function(context)
				UnlockFood(food_index[i]);
			end,
			false
		);
		end
	end
end

function check_and_setup_specific_unit_victories_in_battle(index, context)
	local cooking_interface = cm:model():world():cooking_system():faction_cooking_info(cm:get_faction(Grom_faction));
	local unit_list = food_unit_index[food_index[index]];
	if #unit_list == 0 then
		return;
	end
	
	if cooking_interface:is_ingredient_unlocked(food_index[index]) then
		return;
	end
	
	local faction = cm:get_faction(Grom_faction);
	if faction and not faction:is_human() then 
		return;
	end
	--food_index, enemy_cqi, friendly_cqi
	local all_attacker_char_cqi, all_defender_char_cqi, grom_atking, grom_defing, in_yvresse = get_grom_enemies_from_battle();
	local list_to_check = {};
	local grom_to_check = {};
	if grom_atking then
		list_to_check = all_defender_char_cqi;
		grom_to_check = all_attacker_char_cqi
	elseif grom_defing then
		list_to_check = all_attacker_char_cqi;
		grom_to_check = all_defender_char_cqi
	else
		return;
	end
	
	local check_res = false;
	for j = 1, #list_to_check do
		if (not cm:get_character_by_cqi(list_to_check[j]) or cm:get_character_by_cqi(list_to_check[j]):military_force():is_null_interface()) then
			--do nothing --
			out("character is no longer there!!")
		else
			local army_unit_list = cm:get_character_by_cqi(list_to_check[j]):military_force():unit_list();
			for i = 1, #unit_list do
				if army_unit_list:has_unit(unit_list[i]) then
					check_res = true;
				end
			end
		end
	end
	
	if check_res then
		food_battle_post_listner_cache[food_index[index]][1] = true;
		food_battle_post_listner_cache[food_index[index]][2] = grom_to_check;
		SetupFoodPostBattleListeners(index);
	end
end

function SetupFoodPostBattleListeners(index)
	if not food_battle_post_listner_cache[food_index[index]][1] then
		return;
	end
	local grom_to_check = food_battle_post_listner_cache[food_index[index]][2];
	out("add food battle listenrs"..food_index[index])
	core:add_listener(
		"food_after_"..tostring(food_battle_listener_count),
		"BattleCompleted",
		function(context)
			return true;
		end,
		function(context)
			
			local check_resul = false;
			for i = 1, #grom_to_check do
				local fiendly_char = cm:get_character_by_cqi(grom_to_check[i]);
				if  fiendly_char and fiendly_char:won_battle()  then
					check_resul = true;
				end
			end
			if check_resul then
				UnlockFood(food_index[index]);
			else
				out("grom's side lost, no food for him");
			end
			food_battle_post_listner_cache[food_index[index]][1] = false;
		end,
		false
	);
	food_battle_listener_count = food_battle_listener_count+1;
end

function get_grom_enemies_from_battle()
	local all_attacker_char_cqi = {};
	local all_defender_char_cqi = {};
	local grom_atking = false; 
	local grom_defing = false;
	local in_yvresse = false;
	--script_error("testing this time paradox");
	if cm:pending_battle_cache_num_attackers() >= 1 then
		for i = 1, cm:pending_battle_cache_num_attackers() do
			local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_attacker(i);
			
			if current_faction_name == Grom_faction then
				grom_atking = true;
			end;
			--out("id_1"..cm:get_character_by_cqi(this_char_cqi):region():name());
			if cm:get_character_by_cqi(this_char_cqi) and not cm:get_character_by_cqi(this_char_cqi):region():is_null_interface() and cm:get_character_by_cqi(this_char_cqi):region():name() ==  yvresse_region_key then
				in_yvresse = true;
			end
			table.insert(all_attacker_char_cqi, this_char_cqi);
		end;
	end;
	
	if cm:pending_battle_cache_num_defenders() >= 1 then
		for i = 1, cm:pending_battle_cache_num_defenders() do
			local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_defender(i);
			
			if current_faction_name == Grom_faction then
				grom_defing = true;
			end;
			--out("id_2"..cm:get_character_by_cqi(this_char_cqi):region():name());
			if cm:get_character_by_cqi(this_char_cqi) and not cm:get_character_by_cqi(this_char_cqi):region():is_null_interface() and cm:get_character_by_cqi(this_char_cqi):region():name() ==  yvresse_region_key then
				in_yvresse = true;
			end
			table.insert(all_defender_char_cqi, this_char_cqi);
		end;
	end;
	
	return all_attacker_char_cqi, all_defender_char_cqi, grom_atking, grom_defing, in_yvresse;
end;

---unlock food/recipe, take a string as input-----
function UnlockFood(food)
	--check if food already unlocks--
	local cooking_interface = cm:model():world():cooking_system():faction_cooking_info(cm:get_faction(Grom_faction));
	if cooking_interface:is_ingredient_unlocked(food) == false then
		--unlock it if not--
		out("unlocking food for you!"..food);
		cm:unlock_cooking_ingredient(cm:get_faction(Grom_faction), food);
		cm:trigger_incident(Grom_faction, "wh2_dlc15_grom_cauldron_food_ingredient_unlocked", true)
		core:trigger_event("IngredientUnlocked");
	end
	local list = GetFoodList(true);
	if #list >= blacktoof_required_ingredients_number then
		core:trigger_event("GromHasUnlockedEnoughIngredients");
	end
end


function UnlockSpecialRecipe()
	local locked_secret_recipe = {recipe_index[11], recipe_index[12], recipe_index[13], recipe_index[14], recipe_index[15]};
	local cooking_interface = cm:model():world():cooking_system():faction_cooking_info(cm:get_faction(Grom_faction));
	local counter = 0;
	for i = 1,#locked_secret_recipe do
		if cooking_interface:is_recipe_unlocked(locked_secret_recipe[i-counter]) == true then
			table.remove(locked_secret_recipe, i-counter);
			counter = counter + 1;
		end
	end
	if #locked_secret_recipe ~= 0 then
		UnlockRecipe(locked_secret_recipe[cm:random_number(#locked_secret_recipe)]);
	end
end

-- function LockFood(food)
	-- --check if food already unlocks--
	-- local cooking_interface = cm:model():world():cooking_system():faction_cooking_info(cm:get_faction(Grom_faction));
	-- if cooking_interface:is_ingredient_unlocked(food) == true then
		-- --unlock it if not--
		-- out("locking food for you!"..food);
		-- cm:unlock_cooking_ingredient(cm:get_faction(Grom_faction), food);
	-- end
-- end

function UnlockRecipe(recipe)
	--check if recipe already unlocks--
	local cooking_interface = cm:model():world():cooking_system():faction_cooking_info(cm:get_faction(Grom_faction));
	if cooking_interface:is_recipe_unlocked(recipe) == false then
		--unlock it if not--
		out("unlocking recipe for you!"..recipe);
		cm:unlock_cooking_recipe(cm:get_faction(Grom_faction), recipe);
		cm:trigger_incident(Grom_faction, "wh2_dlc15_grom_cauldron_food_recipe_unlocked", true)
	end
end

---check and spawn food merchant----
function HandleFoodMerchant(queue_time)
	if queue_time then
		Merchant_queued = queue_time;
		out("queued food merchant to appear after:"..tostring(queue_time));
		return;
	end
	if Merchant_queued >= 1 then
		Merchant_queued = Merchant_queued -1;
	elseif Merchant_queued == 0 then
		--spawn food merchant
		SpawnFoodMerchant(cm:get_faction(Grom_faction));
		Merchant_queued = Merchant_queued -1;
	end
end

function SpawnFoodMerchant(faction)
	--get an owning settlement--
	--local faction = cm:get_faction(Grom_faction);
	core:trigger_event("ScriptEventFoodMerchantSpawned")
	
	local region = "";
	if not faction:is_null_interface() then
		local regions = faction:region_list();
		
		if regions:num_items() > 0 then
			region = regions:item_at(cm:random_number(regions:num_items())-1):name();
		else
			out("Grom has no settlement!!!!");
			return;
		end
	end

	--spawn the marker near the settlement--
	local loc_x, loc_y = cm:find_valid_spawn_location_for_character_from_settlement(faction:name(), region, false, true, 9);
	out("trying to find loc")
	out(loc_x);
	out(loc_y);
	out(faction:name());
	out(region);
	local region_cqi = cm:get_region(region):cqi()
	if loc_x > -1 then
		cm:add_interactable_campaign_marker("food_merchant", "food_merchant", loc_x, loc_y, 4, faction:name(), "");
		cm:trigger_incident_with_targets(faction:command_queue_index(), "wh2_dlc15_grom_cauldron_food_merchant_visits", 0, 0, 0, 0, region_cqi, 0)
	end
	
	--setup merchant cooldown
	Merchant_CD = Merchant_CD_default;

end

---trigger dilemma when meeting with food merchant
function TriggerFoodMerchant(context)
	local un_obtained_food = GetFoodList(false);
	
	if #un_obtained_food > 0 then
		cm:trigger_dilemma(Grom_faction, Merchant_dilemma["food"][cm:random_number(#un_obtained_food)]);
	else
		cm:trigger_dilemma(Grom_faction, Merchant_dilemma["no_food"][1]);
	end
	core:trigger_event("ScriptEventGromsCauldronGromMeetsTheFoodMerchantress");
	
end

--returns the number of aquired food, if set to false then will return the number of unauired food
function GetFoodList(aquired)
	local food_list = {};
	local cooking_interface = cm:model():world():cooking_system():faction_cooking_info(cm:get_faction(Grom_faction));
	for i = 1, #food_index do
		if cooking_interface:is_ingredient_unlocked(food_index[i]) == aquired then
			--return the list of obtained food
			table.insert(food_list, i);
		end
	end
	return food_list;
end

--setup the food challenge mission and listeners
function SetupFoodChallenge(input_index)
	local cooking_interface = cm:model():world():cooking_system():faction_cooking_info(cm:get_faction(Grom_faction));
	local current_slots = cooking_interface:max_secondary_ingredients();
	local index = 1; 
	local rand = cm:random_number(#Food_challenge_details[current_slots+1])
	if Food_challenge_info[1] then
		out("a food challenge is already active");
		--cm:cancel_custom_mission(Grom_faction, "wh2_dlc15_food_food_challenge" ,true);
		core:remove_listener("food_challenge_listener_"..tostring(Food_challenge_info[3]));
	end
	
	if input_index then
		index = input_index;
	else
		index = rand;
		if Food_challenge_info[1] and Food_challenge_details[current_slots+1][index] ==  Food_challenge_info[2] then
			if rand == #Food_challenge_details[current_slots+1] then
				index = index - 1;
			else
				index = index + 1;
			end			
		end
	end
	
	local Food_challenge_strings = Food_challenge_keys[Food_challenge_details[current_slots+1][index]];
	
	local mm = mission_manager:new(Grom_faction, "wh2_dlc15_food_food_challenge");
	mm:add_new_objective("SCRIPTED");
	mm:add_condition("script_key food_challenge_"..Food_challenge_info[3]);
	mm:add_condition("override_text mission_text_text_"..Food_challenge_strings);

	for i = 1, #Food_challenge_rewards[current_slots+1] do
		mm:add_payload(Food_challenge_rewards[current_slots+1][i]);
	end
	mm:set_should_whitelist(false);
	mm:trigger();
		
	Food_challenge_info[1] = true;
	Food_challenge_info[2] = Food_challenge_details[current_slots+1][index];
	
	--add the listener thing
	setup_food_challenge_listerner();

end

function setup_food_challenge_listerner()
	if not Food_challenge_info[1] then
		return;
	end
	core:add_listener(
		"food_challenge_listener_"..tostring(Food_challenge_info[3]),
		--a script event needed for this listener, triggers when a dish is cooked
		"FactionCookedDish", 
		function(context)
			local check_res_ingredient = false;
			local check_res_recipe = false;
			local ingredients_check_list = Food_challenge_required_ingredients[Food_challenge_keys[Food_challenge_info[2]]];
			local recipe_check_list = Food_challenge_required_recipes[Food_challenge_keys[Food_challenge_info[2]]];
			local dish_interface = context:dish();
			local ingredients_okey = true;
			local recipe_okey = true;
			--checks the ingredients
			out(tostring(Food_challenge_info[1]));
			out(tostring(Food_challenge_info[2]));
			out(tostring(food_index[Food_challenge_info[2]]));
			out(tostring(recipe_index[Food_challenge_info[2]]));
			if ingredients_check_list~={} then
				local ingredients = dish_interface:ingredients();
				local check_result = {};
				for i =1, #ingredients_check_list do
					local check_res = false;
					for j = 1, #ingredients_check_list[i] do
						for k =1, #ingredients do
							out("checking_iongredient:");
							out(food_index[ingredients_check_list[i][j]]);
							out(ingredients[k]);
							if ingredients[k] == food_index[ingredients_check_list[i][j]] then
								check_res = true;
							end
						end
					end
					out("final_result:"..tostring(check_res));
					table.insert(check_result, check_res);

				end
				--ingredients_okey = true;
				for i =1, #check_result do
					
					ingredients_okey = ingredients_okey and check_result[i];
				end
				out("checking resultt_list"..tostring(ingredients_okey));
			end
			--checks the recipe
			if recipe_check_list~={} then
				local recipe = dish_interface:recipe();
				local check_result = {};
				for i =1, #recipe_check_list do
					local check_res = false;
					for j = 1, #recipe_check_list[i] do
						out("checking_iongredient:");
						out(recipe_index[recipe_check_list[i][j]]);
						out(recipe);
						if recipe == recipe_index[recipe_check_list[i][j]] then
							check_res = true;
						end
					end
					out("final_result:"..tostring(check_res));
					table.insert(check_result, check_res);
				end
				--recipe_okey = true;
				for i = 1,#check_result do
					recipe_okey = recipe_okey and check_result[i];
				end
				out("checking resultt_list"..tostring(recipe_okey));
			end
			return ingredients_okey and recipe_okey;
		end,
		function(context)
				--the food is correct
				--finish the challenge mission
				cm:complete_scripted_mission_objective(Grom_faction, "wh2_dlc15_food_food_challenge", "food_challenge_"..Food_challenge_info[3], true);
				--upgrade cauldron
				local cooking_interface = cm:model():world():cooking_system():faction_cooking_info(cm:get_faction(Grom_faction));
				local current_slots = cooking_interface:max_secondary_ingredients();
				out(current_slots);
				if current_slots < 2 then
					cm:set_faction_max_secondary_cooking_ingredients(cm:get_faction(Grom_faction), current_slots+1);
					core:trigger_event("ScriptEventGromHasEnlargementOfCauldronDoneFromFoodMerchantressFoodChallengeSuccess");
					if current_slots == 1 then
						core:trigger_event("GromUnlockedAllTheCauldronSlots");
					end
				end
				out(cooking_interface:max_secondary_ingredients());
				--update the stored info
				
				Food_challenge_info[1] = false;
				Food_challenge_info[3] = Food_challenge_info[3]+1;

		end,
		false
		);
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("food_battle_listener_count", food_battle_listener_count, context);
		cm:save_named_value("Merchant_CD", Merchant_CD, context);
		cm:save_named_value("Food_challenge_info", Food_challenge_info, context);
		cm:save_named_value("Merchant_queued", Merchant_queued, context);
		cm:save_named_value("cooked_dish", cooked_dish, context);
		cm:save_named_value("AI_eat_timer", AI_eat_timer, context);
		cm:save_named_value("AI_grow_timer", AI_grow_timer, context);
		cm:save_named_value("food_battle_post_listner_cache", food_battle_post_listner_cache, context);
		cm:save_named_value("dishcookedhag", dishcookedhag, context);
	end
);
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			food_battle_listener_count = cm:load_named_value("food_battle_listener_count", food_battle_listener_count, context);
			Merchant_CD = cm:load_named_value("Merchant_CD", Merchant_CD, context);
			Food_challenge_info = cm:load_named_value("Food_challenge_info", Food_challenge_info, context);
			Merchant_queued = cm:load_named_value("Merchant_queued", Merchant_queued, context);
			cooked_dish = cm:load_named_value("cooked_dish", cooked_dish, context);
			AI_eat_timer = cm:load_named_value("AI_eat_timer", AI_eat_timer, context);
			AI_grow_timer = cm:load_named_value("AI_grow_timer", AI_grow_timer, context);
			food_battle_post_listner_cache = cm:load_named_value("food_battle_post_listner_cache", food_battle_post_listner_cache, context);
			dishcookedhag = cm:load_named_value("dishcookedhag", dishcookedhag, context);
		end
	end
);