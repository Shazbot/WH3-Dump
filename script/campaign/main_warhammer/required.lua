-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	REQUIRED FILES
--
--	Add any files that need to be loaded for this campaign here
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

package.path = package.path .. ";data/script/campaign/?.lua"
package.path = package.path .. ";data/script/campaign/main_warhammer/?.lua"

--	general campaign behaviour
force_require("wh_campaign_setup")

-- campaign advice interventions
force_require("wh_campaign_interventions")

--	help pages
force_require("wh_campaign_help_pages")

require("wh3_campaign_payload_remapping")

-- campaign-specific files
require("wh_first_turn")
require("wh_start")
---- game-wide features
require("victory_objectives")
require("wh3_sea_lanes")
require("corruption_swing")
require("wh_quests")
require("wh_horde_reemergence")
require("wh_campaign_ror_recruitment")
require("wh_campaign_faction_start")
require("wh2_campaign_rites")
require("wh2_campaign_traits")
require("wh2_campaign_encounters_at_sea")
require("wh2_intro_ui_highlighting")
require("wh2_campaign_custom_starts")
require("wh2_campaign_quest_battle_helper")
require("wh2_campaign_tech_tree_lords")
require("wh2_campaign_confederation_missions")
require("wh2_campaign_interactive_marker_manager")
require("wh2_campaign_forced_battle_manager")
require("wh2_campaign_random_armies")
require("wh3_campaign_character_initiative_unlocks")
require("wh3_campaign_followers")
require("wh3_campaign_corruption")
require("wh3_campaign_missions")
require("wh2_campaign_generated_constants")
require("wh3_campaign_character_upgrading")
require("wh3_campaign_recruited_unit_health")
require("wh3_campaign_scripted_occupation_options")

---- faction and race features
require("wh_grudges")
require("wh2_campaign_blessed_spawnings")
require("wh2_campaign_names_of_power")
require("wh2_vampire_bloodlines")
require("wh2_slann_selection")
require("wh3_campaign_slaanesh_devotees")
require("wh3_campaign_slaanesh_seductive_influence")
require("wh3_campaign_daemon_cults")
require("wh3_campaign_kislev_ice_court")
require("wh3_campaign_kislev_devotion")
require("wh3_campaign_greater_daemons")
require("wh3_campaign_ogre_contracts")
require("wh3_campaign_khorne_skulls")
require("wh3_campaign_nurgle_plagues")
require("wh3_campaign_great_game")
require("wh3_campaign_ivory_road_events")
require("wh3_campaign_great_bastion")
require("wh3_campaign_belakor")
require("endgames")
require("wh3_main_volkmar_elector_units")
require("wh3_campaign_def_slaves")

-- Intro Logic (Often best to load this after other functionality has been loaded)
require("faction_intro")

-- DLC03 - Beastmen
require("wh_dlc03_beastmen_moon")

-- DLC05 - Wood Elves
require("wh_dlc05_wood_elves")

-- DLC06 - Karak Eight Peaks
require("wh_dlc06_karak_eight_peaks")

-- PRO01 - White Dwarf
require("wh_pro01_grombrindal")

-- DLC07 - Bretonnia
require("wh_dlc07_bretonnia")
require("wh_dlc07_blessing_of_the_lady")
require("wh_dlc07_diplomatic_tech")
require("wh_dlc07_peasant_economy")
require("wh_dlc07_virtues_and_traits")
require("wh_dlc07_the_green_knight")
require("wh_campaign_bretonnia_chivalry")
require("wh_dlc07_vows")

-- PRO02 - Isabella
require("wh_dlc07_schwartzhafen_undying_love")

-- DLC08 - Norsca
require("wh_dlc08_norsca")
require("wh_dlc08_norscan_gods")
require("wh_dlc08_monster_hunt")
require("wh_dlc08_nurgle_plague")

-- DLC09 - Tomb Kings
require("wh2_dlc09_tomb_kings")
require("wh2_dlc09_books_of_nagash")
require("wh2_dlc09_books_of_nagash_effects")
require("wh2_dlc09_books_of_nagash_locations")
require("wh2_dlc09_dynasty_tree")
require("wh2_dlc09_tretch_craventail")

-- DLC10 - The Queen & The Crone
require("wh2_dlc10_alarielle")
require("wh2_dlc10_alith_anar")
require("wh2_dlc10_hellebron")
require("wh2_dlc10_sword_of_khaine")

-- DLC11 - Vampire Coast
require("wh2_dlc11_vampire_coast")
require("wh2_dlc11_infamy")
require("wh2_dlc11_tech_tree")
require("wh2_dlc11_treasure_maps")
require("wh2_dlc11_vampire_coast_loyalty")
require("wh2_dlc11_roving_pirates")
require("wh2_dlc11_lokhir")
require("wh2_dlc11_ship_upgrades")

-- DLC12 - The Prophet & The Warlock
require("wh2_dlc12_under_empire")
require("wh2_dlc12_ikit_workshop")
require("wh2_dlc12_tehenhauin")
require("wh2_dlc12_kroak")

-- DLC13 - The Hunter & The Beast
require("wh2_dlc13_empire_politics")
require("wh2_dlc13_wulfhart_imperial_reinforcement")
require("wh2_dlc13_wulfhart_hunters")
require("wh2_dlc13_nakai_temples")

-- DLC14 - The Shadow & The Beast
require("wh2_dlc14_malus_malekiths_favour")
require("wh2_dlc14_malus_sanity")
require("wh2_dlc14_tzarkans_whispers")
require("wh2_dlc14_snikch_shadowy_dealings")
require("wh2_dlc14_snikch_clan_contracts")
require("wh2_dlc14_repanse_confederation")
require("wh2_dlc14_snikch_revitalizing_rite")

-- PRO08 - Gotrek & Felix
require("wh2_pro08_gotrek_felix")

-- DLC15 - The Warden & The Paunch
require("wh2_dlc15_eltharion_lair")
require("wh2_dlc15_eltharion_mist")
require("wh2_dlc15_eltharion_yvresse_defence")
require("wh3_main_eltharion_yvresse")
require("wh2_dlc15_dragon_encounters")
require("wh2_dlc15_waaagh")
require("wh2_dlc15_salvage")
require("wh2_dlc15_grom_story")
require("wh2_dlc15_grom_cauldron")

-- DLC16 - The Twisted and the Twilight
require("wh2_dlc16_wef_worldroots")
require("wh2_dlc16_wef_sisters_forge")
require("wh2_dlc16_flesh_lab")
require("wh2_dlc16_drycha_coeddil_unchained")
require("wh2_dlc16_throt_ghoritch")

-- TWA03 - Rakarth
require("wh2_twa03_rakarth")

--DLC17 - The Silence and the Fury
require("wh2_dlc17_lzd_silent_sanctums")
require("wh2_dlc17_lzd_chaos_map")
require("wh2_dlc17_thorek")
require("wh2_dlc17_beastmen_tech")
require("wh2_dlc17_bloodgrounds")
require("wh2_dlc17_taurox_rampage")
require("wh2_dlc17_bst_ruination_progression")

-- DLC20 - The Champions of Chaos
require("wh3_dlc20_campaign_norscan_vassal_personality")
require("wh3_dlc20_campaign_chs_vassal_dilemmas")
require("wh3_dlc20_campaign_chs_dark_authority")
require("wh3_dlc20_campaign_chs_eye_of_the_gods")