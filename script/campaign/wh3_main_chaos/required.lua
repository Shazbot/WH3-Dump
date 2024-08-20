-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	REQUIRED FILES
--
--	Add any files that need to be loaded for this campaign here
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

package.path = package.path .. ";" .. cm:get_campaign_folder() .. "/?.lua";

-- general campaign behaviour
force_require("wh_campaign_setup");

-- campaign advice interventions
force_require("wh_campaign_interventions");

-- help pages
force_require("wh_campaign_help_pages");

-- Scripted Tours
require("scripted_tours/campaign_tours")

require("wh_start");
require("wh2_campaign_traits");
require("wh2_campaign_encounters_at_sea");
require("wh2_campaign_random_armies");
require("wh_quests");
require("wh_campaign_ror_recruitment");
require("wh3_campaign_set_piece_battle_abilities")
require("wh2_campaign_forced_battle_manager")
require("wh2_pro08_gotrek_felix")

-- narrative events
require("wh3_campaign_payload_remapping");
require("wh3_chaos_narrative_events");
require("wh3_dlc25_narrative_tod")

require("wh3_tol_helpers");
require("wh3_tol_darkness_and_disharmony");
require("wh3_tol_something_rotten_in_kislev");


---- faction and race features
require("wh3_campaign_slaanesh_devotees");
require("wh3_campaign_slaanesh_seductive_influence");
require("wh3_campaign_daemon_cults");
require("wh3_campaign_kislev_ice_court");
require("wh3_campaign_kislev_devotion");
require("wh3_campaign_character_initiative_unlocks");
require("wh3_campaign_greater_daemons");
require("wh3_campaign_ogre_contracts");
require("wh3_campaign_khorne_skulls");
require("wh3_campaign_recruited_unit_health");
require("wh3_campaign_nurgle_plagues")
require("wh3_campaign_great_game");
require("wh3_starting_armies");
require("wh2_campaign_generated_constants");
require("wh2_campaign_quest_battle_helper");
require("wh3_boris");
require("wh3_campaign_followers");
require("wh3_campaign_corruption");
require("wh3_campaign_ai");
require("wh3_campaign_great_bastion");
require("wh3_campaign_caravans_core")
require("wh3_campaign_ivory_road_events");
require("wh3_campaign_chd_convoy_events");
require("wh3_campaign_character_upgrading");
require("wh3_dlc20_campaign_chs_dark_authority");
require("wh3_dlc20_narrative_champions");
require("wh3_dlc20_campaign_norscan_vassal_personality")
require("wh3_dlc20_campaign_chs_eye_of_the_gods")
require("wh3_dlc20_campaign_chs_vassal_dilemmas")
require("wh3_campaign_reveal_chaos_realm_mission_areas")
require("wh3_campaign_scripted_occupation_options")
require("wh3_campaign_harmony")
require("wh3_dlc25_emp_techs")
require("wh3_campaign_grudges")
require("wh3_campaign_grudges_starting_missions")
require("wh3_campaign_grudges_legendary")
require("wh3_dlc25_grudge_cycles")
require("wh2_campaign_tech_tree_lords")
require("wh3_campaign_forge")
require("wh3_campaign_underdeep")

-- DLC23 - Chaos Dwarfs
require("wh3_dlc23_narrative_chaos_dwarfs");
require("wh3_dlc23_labour_raid")
require("wh3_dlc23_labour_loss")
require("wh3_dlc23_efficiency")
require("wh3_campaign_faction_initiative_unlocks")
require("wh3_dlc23_campaign_chd_hellforge")
require("wh3_dlc23_campaign_chd_tower_of_zharr")
require("wh3_dlc23_labour_move")

-- DLC24
require("wh3_dlc24_mother_ostankya")
require("wh3_dlc24_matters_of_state")
require("wh3_dlc24_the_changeling")
require("wh2_dlc13_empire_politics")

require("realms/wh3_realm_common");
require("realms/wh3_realm_khorne");
require("realms/wh3_realm_nurgle");
require("realms/wh3_realm_slaanesh");
require("realms/wh3_realm_tzeentch");
require("realms/wh3_realm_tzeentch_data");

-- DLC25
require("wh3_dlc25_campaign_nur_chieftains")
require("wh3_dlc25_malakai_battles")
require("wh3_dlc25_gunnery_school")
require("wh3_dlc25_imperial_authority")
require("wh3_dlc25_spirit_of_grungni")
require("wh3_dlc25_empire_state_troops")
require("wh3_dlc25_imperial_authority")
require("wh3_dlc25_gardens_of_morr")


-- Game systems
require("victory_objectives");
require("corruption_swing");
require("wh3_main_legendary_characters");

require("DEBUG_economy_logging");

require("wh2_campaign_custom_starts");