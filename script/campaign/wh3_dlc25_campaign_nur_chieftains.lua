nur_chieftains = {

	faction = "wh3_dlc25_nur_tamurkhan",
	number_of_nurgle_techs = 50,
	pr_dominance = "wh3_dlc25_chieftain_dominance",
	pr_dominance_factor = "wh3_dlc25_dominance_gain",
	
	disable_panel_button = "disable_chieftains_button",
	dominance_req_to_unlock = 7,
	panel_available_incident = "wh3_dlc25_nur_chieftains_panel_unlocked",
	chieftains_available_incident_1 = "wh3_dlc25_nur_chieftains_new_chieftain",
	chieftains_available_incident_2 = "wh3_dlc25_nur_chieftains_new_chieftain_final",
	
	tamurkhan_trait_start = "wh3_dlc25_trait_chieftain_tamurkhan_antitrait",
	tamurkhan_trait = "wh3_dlc25_trait_chieftain_tamurkhan",
	tamurkhan_trait_incident = "wh3_dlc25_nur_tamurkhan_trait_increase",
	
	ai_unit_ritual_cooldown = 5,

	--chieftain data below
	--note deference now called fealty (player facing)
	chieftain_type = {
		"bray_shaman",
		"castellan",
		"exalted_hero",
		"fimir_balefiend",
		"kazyk",
		"werekin"
	},

	bray_shaman = {
		agent = "wh3_dlc25_nur_bray_shaman_wild_chieftain", 
		forename = "1762690696", 
		anciliary = "wh3_dlc25_anc_talisman_reeking_talisman", 
		trait_start = "wh3_dlc25_trait_chieftain_bray_shaman_antitrait",
		trait = "wh3_dlc25_trait_chieftain_bray_shaman",
		has_spawned = false,
		recruit_ritual = "wh3_dlc25_ritual_nur_bray_shaman_recruit",
		--effect bundles
		t2_ability_bundle = nil,
		t3_ability_bundle = nil,
		t1_bundle = "wh3_dlc25_chieftain_deference_bray_shaman_tier_1",
		t2_bundle = "wh3_dlc25_chieftain_deference_bray_shaman_tier_2",
		t3_bundle = "wh3_dlc25_chieftain_deference_bray_shaman_tier_3",
		t4_bundle = "wh3_dlc25_chieftain_deference_bray_shaman_tier_4",
		--chieftain quest battle
		qb_mission_roc = "wh3_dlc25_qb_nur_tamurkhan_chieftain_battle_bray_shaman",
		qb_mission_ie = "wh3_dlc25_ie_qb_nur_tamurkhan_chieftain_battle_bray_shaman",
		--pooled resource linked data
		pr_deference_key = "wh3_dlc25_chieftain_deference_bray_shaman",
		pr_factor_unique = "wh3_dlc25_chieftain_deference_factor_fimir_balefiend_gained_research",
		pr_factor_battle = "wh3_dlc25_chieftain_deference_factor_bray_shaman_gained_battle",
		pr_target_cultures = "wh3_dlc25_nur_chieftain_battle_cultures_bray_shaman", --based on faction_sets
		--deference level threshold values (MUST BE UPDATED ALONGSIDE NUMERIC RANGES & POOLED RESOURCE MAX VALUES IN DATA & if kayzk's values are changed also NARRATIVE MISSIONS SCRIPT)
		deference_value_tier_1 = nil, --applied when chieftain unlocked
		deference_value_tier_2 = 10,
		deference_value_tier_3 = 30,
		deference_value_tier_4 = nil, --applied when chieftain battle completed
		--events
		incident_unlock = "wh3_dlc25_nur_chieftains_bray_shaman_deference_1",
		incident_deference_t2 = "wh3_dlc25_nur_chieftains_bray_shaman_deference_2", 
		incident_deference_t3 = "wh3_dlc25_nur_chieftains_bray_shaman_deference_3", 
		incident_deference_t4 = "wh3_dlc25_nur_chieftains_bray_shaman_deference_4",
		--unit rituals
		unit_rituals = {
			"wh3_dlc25_ritual_nur_bray_shaman_centigors", 
			"wh3_dlc25_ritual_nur_bray_shaman_cygor", 
			"wh3_dlc25_ritual_nur_bray_shaman_ghorgon"
		}

	}, 
	castellan =	{
		agent = "wh3_dlc25_nur_castellan_chieftain", 
		forename = "1676908529", 
		anciliary = "wh3_dlc25_anc_talisman_cursed_yhetee_jawbone", 
		trait_start = "wh3_dlc25_trait_chieftain_castellan_antitrait",
		trait = "wh3_dlc25_trait_chieftain_castellan",
		has_spawned = false,
		recruit_ritual = "wh3_dlc25_ritual_nur_castellan_recruit",
		--effect bundles
		t2_ability_bundle = "wh3_dlc25_ritual_nur_castellan_tier_2_ability_scripted",
		t3_ability_bundle = nil,
		t1_bundle = "wh3_dlc25_chieftain_deference_castellan_tier_1",
		t2_bundle = "wh3_dlc25_chieftain_deference_castellan_tier_2",
		t3_bundle = "wh3_dlc25_chieftain_deference_castellan_tier_3",
		t4_bundle = "wh3_dlc25_chieftain_deference_castellan_tier_4",
		--chieftain quest battle
		qb_mission_roc = "wh3_dlc25_qb_nur_tamurkhan_chieftain_battle_castellan",
		qb_mission_ie = "wh3_dlc25_ie_qb_nur_tamurkhan_chieftain_battle_castellan",
		--pooled resource linked data
		pr_deference_key = "wh3_dlc25_chieftain_deference_castellan",
		pr_factor_unique = "wh3_dlc25_chieftain_deference_factor_werekin_gained_looting",
		pr_factor_battle = "wh3_dlc25_chieftain_deference_factor_castellan_gained_battle",
		pr_target_cultures = "wh3_dlc25_nur_chieftain_battle_cultures_castellan", --based on faction_sets
		--deference level threshold values (MUST BE UPDATED ALONGSIDE NUMERIC RANGES & POOLED RESOURCE MAX VALUES IN DATA & if kayzk's values are changed also NARRATIVE MISSIONS SCRIPT)
		deference_value_tier_1 = nil, --applied when chieftain unlocked
		deference_value_tier_2 = 10,
		deference_value_tier_3 = 30,
		deference_value_tier_4 = nil, --applied when chieftain battle completed
		--events
		incident_unlock = "wh3_dlc25_nur_chieftains_castellan_deference_1",
		incident_deference_t2 = "wh3_dlc25_nur_chieftains_castellan_deference_2",
		incident_deference_t3 = "wh3_dlc25_nur_chieftains_castellan_deference_3",
		incident_deference_t4 = "wh3_dlc25_nur_chieftains_castellan_deference_4",
		--unit rituals
		unit_rituals = {
			"wh3_dlc25_ritual_nur_castellan_blunderbusses", 
			"wh3_dlc25_ritual_nur_castellan_fireglaives", 
			"wh3_dlc25_ritual_nur_castellan_dreadquake"
		}
	}, 
	exalted_hero = {
		agent = "wh3_dlc25_nur_exalted_hero_chieftain", 
		forename = "1037772035", 
		anciliary = "wh3_dlc25_anc_talisman_virulent_boon", 
		trait_start = "wh3_dlc25_trait_chieftain_exalted_hero_antitrait",
		trait = "wh3_dlc25_trait_chieftain_exalted_hero",
		has_spawned = false,
		recruit_ritual = "wh3_dlc25_ritual_nur_exalted_hero_recruit",
		--effect bundles
		t2_ability_bundle = "wh3_dlc25_ritual_nur_exalted_hero_tier_2_ability_scripted",
		t3_ability_bundle = nil,
		t1_bundle = "wh3_dlc25_chieftain_deference_exalted_hero_tier_1",
		t2_bundle = "wh3_dlc25_chieftain_deference_exalted_hero_tier_2",
		t3_bundle = "wh3_dlc25_chieftain_deference_exalted_hero_tier_3",
		t4_bundle = "wh3_dlc25_chieftain_deference_exalted_hero_tier_4",
		--chieftain quest battle
		qb_mission_roc = "wh3_dlc25_qb_nur_tamurkhan_chieftain_battle_exalted_hero",
		qb_mission_ie = "wh3_dlc25_ie_qb_nur_tamurkhan_chieftain_battle_exalted_hero",
		--pooled resource linked data
		pr_deference_key = "wh3_dlc25_chieftain_deference_exalted_hero",
		pr_factor_unique = "wh3_dlc25_chieftain_deference_factor_exalted_hero_gained_killing",
		pr_factor_battle = "wh3_dlc25_chieftain_deference_factor_exalted_hero_gained_battle", 
		pr_target_cultures = "wh3_dlc25_nur_chieftain_battle_cultures_exalted_hero", --based on faction_sets
		--deference level threshold values (MUST BE UPDATED ALONGSIDE NUMERIC RANGES & POOLED RESOURCE MAX VALUES IN DATA & if kayzk's values are changed also NARRATIVE MISSIONS SCRIPT)
		deference_value_tier_1 = nil, --applied when chieftain unlocked
		deference_value_tier_2 = 10,
		deference_value_tier_3 = 25,
		deference_value_tier_4 = nil, --applied when chieftain battle completed
		--events
		incident_unlock = "wh3_dlc25_nur_chieftains_exalted_hero_deference_1",
		incident_deference_t2 = "wh3_dlc25_nur_chieftains_exalted_hero_deference_2",
		incident_deference_t3 = "wh3_dlc25_nur_chieftains_exalted_hero_deference_3",
		incident_deference_t4 = "wh3_dlc25_nur_chieftains_exalted_hero_deference_4",
		--unit rituals
		unit_rituals = {
			"wh3_dlc25_ritual_nur_exalted_hero_aspiring_champions", 
			"wh3_dlc25_ritual_nur_exalted_hero_hellcannon", 
			"wh3_dlc25_ritual_nur_exalted_hero_dragon_ogre"
		}
	}, 
	fimir_balefiend = {
		agent = "wh3_dlc25_nur_fimir_balefiend_shadow_chieftain", 
		forename = "329867254", 
		anciliary = "wh3_dlc25_anc_talisman_sigil_of_madness", 
		trait_start = "wh3_dlc25_trait_chieftain_fimir_balefiend_antitrait",
		trait = "wh3_dlc25_trait_chieftain_fimir_balefiend",
		has_spawned = false,
		fallback_occurred = false,
		recruit_ritual = "wh3_dlc25_ritual_nur_fimir_balefiend_recruit",
		--effect bundles
		t2_ability_bundle = "wh3_dlc25_ritual_nur_fimir_balefiend_tier_2_ability_scripted",
		t3_ability_bundle = "wh3_dlc25_ritual_nur_fimir_balefiend_tier_3_ability_scripted",
		t1_bundle = "wh3_dlc25_chieftain_deference_fimir_balefiend_tier_1",
		t2_bundle = "wh3_dlc25_chieftain_deference_fimir_balefiend_tier_2",
		t3_bundle = "wh3_dlc25_chieftain_deference_fimir_balefiend_tier_3",
		t4_bundle = "wh3_dlc25_chieftain_deference_fimir_balefiend_tier_4",
		--chieftain quest battle
		qb_mission_roc = "wh3_dlc25_qb_nur_tamurkhan_chieftain_battle_fimir_balefiend",
		qb_mission_ie = "wh3_dlc25_ie_qb_nur_tamurkhan_chieftain_battle_fimir_balefiend",
		--pooled resource linked data
		pr_deference_key = "wh3_dlc25_chieftain_deference_fimir_balefiend",
		pr_factor_unique = "wh3_dlc25_chieftain_deference_factor_castellan_gained_ransom",
		pr_factor_battle = "wh3_dlc25_chieftain_deference_factor_fimir_balefiend_gained_battle",
		pr_target_cultures = "wh3_dlc25_nur_chieftain_battle_cultures_fimir_balefiend", --based on faction_sets
		--deference level threshold values (MUST BE UPDATED ALONGSIDE NUMERIC RANGES & POOLED RESOURCE MAX VALUES IN DATA & if kayzk's values are changed also NARRATIVE MISSIONS SCRIPT)
		deference_value_tier_1 = nil, --applied when chieftain unlocked
		deference_value_tier_2 = 10,
		deference_value_tier_3 = 25,
		deference_value_tier_4 = nil, --applied when chieftain battle completed
		--events
		incident_unlock = "wh3_dlc25_nur_chieftains_fimir_balefiend_deference_1",
		incident_deference_t2 = "wh3_dlc25_nur_chieftains_fimir_balefiend_deference_2",
		incident_deference_t3 = "wh3_dlc25_nur_chieftains_fimir_balefiend_deference_3",
		incident_deference_t4 = "wh3_dlc25_nur_chieftains_fimir_balefiend_deference_4",
		--unit rituals
		unit_rituals = {
			"wh3_dlc25_ritual_nur_fimir_balefiend_fimir_warriors_0", 
			"wh3_dlc25_ritual_nur_fimir_balefiend_fimir_warriors_1", 
			"wh3_dlc25_ritual_nur_fimir_balefiend_frost_wyrm"
		}
	}, 
	kazyk =	{
		agent = "wh3_dlc25_nur_kayzk_the_befouled", 
		forename = "1813524566", 
		anciliary = "wh3_dlc25_anc_talisman_icon_of_decay", 
		trait_start = "wh3_dlc25_trait_chieftain_kazyk_antitrait",
		trait = "wh3_dlc25_trait_chieftain_kazyk", 
		has_spawned = false,
		recruit_ritual = "wh3_dlc25_ritual_nur_kazyk_recruit",
		--effect bundles
		t2_ability_bundle = "wh3_dlc25_ritual_nur_kazyk_tier_2_ability_scripted",
		t3_ability_bundle = "wh3_dlc25_ritual_nur_kazyk_tier_3_ability_scripted",
		t1_bundle = "wh3_dlc25_chieftain_deference_kazyk_tier_1",
		t2_bundle = "wh3_dlc25_chieftain_deference_kazyk_tier_2",
		t3_bundle = "wh3_dlc25_chieftain_deference_kazyk_tier_3",
		t4_bundle = "wh3_dlc25_chieftain_deference_kazyk_tier_4",
		--chieftain quest battle
		qb_mission_roc = "wh3_dlc25_qb_nur_tamurkhan_chieftain_battle_kazyk",
		qb_mission_ie = "wh3_dlc25_ie_qb_nur_tamurkhan_chieftain_battle_kazyk",
		--pooled resource linked data
		pr_deference_key = "wh3_dlc25_chieftain_deference_kazyk", 
		pr_factor_unique = "wh3_dlc25_chieftain_deference_factor_kazyk_gained_plagues",
		pr_factor_battle = "wh3_dlc25_chieftain_deference_factor_kazyk_gained_battle",
		pr_target_cultures = "wh3_dlc25_nur_chieftain_battle_cultures_kazyk", --based on faction_sets
		--deference level threshold values (MUST BE UPDATED ALONGSIDE NUMERIC RANGES & POOLED RESOURCE MAX VALUES IN DATA & if kayzk's values are changed also NARRATIVE MISSIONS SCRIPT)
		deference_value_tier_1 = nil, --applied when chieftain unlocked
		deference_value_tier_2 = 7,
		deference_value_tier_3 = 20,
		deference_value_tier_4 = nil, --applied when chieftain battle completed
		--events
		incident_unlock = "wh3_dlc25_nur_chieftains_kazyk_deference_1",
		incident_deference_t2 = "wh3_dlc25_nur_chieftains_kazyk_deference_2",
		incident_deference_t3 = "wh3_dlc25_nur_chieftains_kazyk_deference_3",
		incident_deference_t4 = "wh3_dlc25_nur_chieftains_kazyk_deference_4",
		--unit rituals
		unit_rituals = {
			"wh3_dlc25_ritual_nur_kazyk_chaos_chariot_mnur", 
			"wh3_dlc25_ritual_nur_kazyk_rot_knights", 
			"wh3_dlc25_ritual_nur_kazyk_toad_dragon"
		}
	}, 
	werekin = {
		agent = "wh3_dlc25_nur_skin_wolf_werekin_chieftain", 
		forename = "1959377886", 
		anciliary = "wh3_dlc25_anc_talisman_unkind_taint",
		trait_start = "wh3_dlc25_trait_chieftain_werekin_antitrait",
		trait = "wh3_dlc25_trait_chieftain_werekin", 	
		has_spawned = false,
		recruit_ritual = "wh3_dlc25_ritual_nur_werekin_recruit",
		--effect bundles
		t2_ability_bundle = nil,
		t3_ability_bundle = nil,
		t1_bundle = "wh3_dlc25_chieftain_deference_werekin_tier_1",
		t2_bundle = "wh3_dlc25_chieftain_deference_werekin_tier_2",
		t3_bundle = "wh3_dlc25_chieftain_deference_werekin_tier_3",
		t4_bundle = "wh3_dlc25_chieftain_deference_werekin_tier_4",
		--chieftain quest battle
		qb_mission_roc = "wh3_dlc25_qb_nur_tamurkhan_chieftain_battle_werekin",
		qb_mission_ie = "wh3_dlc25_ie_qb_nur_tamurkhan_chieftain_battle_werekin",
		--pooled resource linked data
		pr_deference_key = "wh3_dlc25_chieftain_deference_werekin",
		pr_factor_unique = "wh3_dlc25_chieftain_deference_factor_bray_shaman_gained_raiding",
		pr_factor_battle = "wh3_dlc25_chieftain_deference_factor_werekin_gained_battle",
		pr_target_cultures = "wh3_dlc25_nur_chieftain_battle_cultures_werekin", --based on faction_sets
		--deference level threshold values (MUST BE UPDATED ALONGSIDE NUMERIC RANGES & POOLED RESOURCE MAX VALUES IN DATA & if kayzk's values are changed also NARRATIVE MISSIONS SCRIPT)
		deference_value_tier_1 = nil, --applied when chieftain unlocked
		deference_value_tier_2 = 10,
		deference_value_tier_3 = 30,
		deference_value_tier_4 = nil, --applied when chieftain battle completed
		--events
		incident_unlock = "wh3_dlc25_nur_chieftains_werekin_deference_1",
		incident_deference_t2 = "wh3_dlc25_nur_chieftains_werekin_deference_2",
		incident_deference_t3 = "wh3_dlc25_nur_chieftains_werekin_deference_3",
		incident_deference_t4 = "wh3_dlc25_nur_chieftains_werekin_deference_4",
		--unit rituals
		unit_rituals = {
			"wh3_dlc25_ritual_nur_werekin_skin_wolves", 
			"wh3_dlc25_ritual_nur_werekin_feral_mammoth", 
			"wh3_dlc25_ritual_nur_werekin_war_mammoth"
		}
	},
	--Ability ritual function list -  called by ChieftainAbilities listener
	ritual_functions = {
		--chieftain only force stances
		["wh3_dlc25_ritual_nur_special_bray_shaman_tier_2"] = function(context) apply_temp_stance_to_chieftan_force(context, nur_chieftains.bray_shaman.agent, "MILITARY_FORCE_ACTIVE_STANCE_TYPE_TUNNELING") end,
		["wh3_dlc25_ritual_nur_special_werekin_tier_2"] = function(context) apply_temp_stance_to_chieftan_force(context, nur_chieftains.werekin.agent, "MILITARY_FORCE_ACTIVE_STANCE_TYPE_STALKING") end,
		--chieftain force effect bundles
		["wh3_dlc25_ritual_nur_special_castellan_tier_2"] = function(context) apply_effect_bundle_to_chieftain_force(context, nur_chieftains.castellan.agent, nur_chieftains.castellan.t2_ability_bundle) end,
		["wh3_dlc25_ritual_nur_special_exalted_hero_tier_2"] = function(context) apply_effect_bundle_to_chieftain_force(context, nur_chieftains.exalted_hero.agent, nur_chieftains.exalted_hero.t2_ability_bundle) end,
		["wh3_dlc25_ritual_nur_special_kazyk_tier_2"] = function(context) apply_effect_bundle_to_chieftain_force(context, nur_chieftains.kazyk.agent, nur_chieftains.kazyk.t2_ability_bundle) end,
		["wh3_dlc25_ritual_nur_special_fimir_balefiend_tier_2"] = function(context) apply_effect_bundle_to_chieftain_force(context, nur_chieftains.fimir_balefiend.agent, nur_chieftains.fimir_balefiend.t2_ability_bundle) end,
		["wh3_dlc25_ritual_nur_special_fimir_balefiend_tier_3"] = function(context) apply_effect_bundle_to_chieftain_force(context, nur_chieftains.fimir_balefiend.agent, nur_chieftains.fimir_balefiend.t3_ability_bundle) end,
		--factionwide force stances
		["wh3_dlc25_ritual_nur_special_bray_shaman_tier_3"] = function(context) apply_temp_stance_to_force_factionwide(context, "MILITARY_FORCE_ACTIVE_STANCE_TYPE_TUNNELING") end,
		["wh3_dlc25_ritual_nur_special_werekin_tier_3"] = function(context) apply_temp_stance_to_force_factionwide(context, "MILITARY_FORCE_ACTIVE_STANCE_TYPE_STALKING") end,
		--bespoke
		["wh3_dlc25_ritual_nur_special_exalted_hero_tier_3"] = function(context) exalted_hero_t3_ability(context, nur_chieftains.exalted_hero.agent) end,
		["wh3_dlc25_ritual_nur_special_castellan_tier_3"] = function(context) castellan_t3_ability(context, nur_chieftains.castellan.agent) end
	},
	
	--Chieftain dilemmas
	dilemma_deference_min_req = 3, --minimum deference required of both Chieftains in a dilemma for it to fire
	dilemma_chance = 61, --roll equal to or over this %, so the chance is 40%

	--Deference level tracking for unlocking chieftains
	tier_1_reached = false,
	tier_2_reached = false,
	tier_3_reached = false,
	tier_4_reached = false
}

nur_chieftains.chieftain_dilemma = {
	{dilemma_key = "wh3_dlc25_nur_dilemma_chieftains_bray_shaman_exalted_hero", 	chieftain_1 = nur_chieftains.bray_shaman, 		chieftain_2 = nur_chieftains.exalted_hero,		has_launched = false},
	{dilemma_key = "wh3_dlc25_nur_dilemma_chieftains_bray_shaman_werekin", 			chieftain_1 = nur_chieftains.bray_shaman, 		chieftain_2 = nur_chieftains.werekin, 			has_launched = false},
	{dilemma_key = "wh3_dlc25_nur_dilemma_chieftains_castellan_bray_shaman", 		chieftain_1 = nur_chieftains.castellan, 		chieftain_2 = nur_chieftains.bray_shaman, 		has_launched = false},
	{dilemma_key = "wh3_dlc25_nur_dilemma_chieftains_castellan_Kayzk", 				chieftain_1 = nur_chieftains.castellan, 		chieftain_2 = nur_chieftains.kazyk, 			has_launched = false},
	{dilemma_key = "wh3_dlc25_nur_dilemma_chieftains_exalted_hero_castellan", 		chieftain_1 = nur_chieftains.exalted_hero, 		chieftain_2 = nur_chieftains.castellan, 		has_launched = false},
	{dilemma_key = "wh3_dlc25_nur_dilemma_chieftains_exalted_hero_fimir_balefiend", chieftain_1 = nur_chieftains.exalted_hero, 		chieftain_2 = nur_chieftains.fimir_balefiend, 	has_launched = false},
	{dilemma_key = "wh3_dlc25_nur_dilemma_chieftains_fimir_balefiend_castellan", 	chieftain_1 = nur_chieftains.fimir_balefiend, 	chieftain_2 = nur_chieftains.castellan, 		has_launched = false},
	{dilemma_key = "wh3_dlc25_nur_dilemma_chieftains_fimir_balefiend_kayzk", 		chieftain_1 = nur_chieftains.fimir_balefiend,	chieftain_2 = nur_chieftains.kazyk, 			has_launched = false},
	{dilemma_key = "wh3_dlc25_nur_dilemma_chieftains_Kayzk_bray_shaman", 			chieftain_1 = nur_chieftains.kazyk, 			chieftain_2 = nur_chieftains.bray_shaman, 		has_launched = false},
	{dilemma_key = "wh3_dlc25_nur_dilemma_chieftains_Kayzk_werekin", 				chieftain_1 = nur_chieftains.kazyk, 			chieftain_2 = nur_chieftains.werekin, 			has_launched = false},
	{dilemma_key = "wh3_dlc25_nur_dilemma_chieftains_werekin_exalted_hero", 		chieftain_1 = nur_chieftains.werekin, 			chieftain_2 = nur_chieftains.exalted_hero, 		has_launched = false},
	{dilemma_key = "wh3_dlc25_nur_dilemma_chieftains_werekin_fimir_balefiend", 		chieftain_1 = nur_chieftains.werekin, 			chieftain_2 = nur_chieftains.fimir_balefiend,	has_launched = false}
}

function nur_chieftains:initialise()

	--Panel locking--
	if cm:is_new_game() then
		local faction = cm:get_faction(self.faction)
		if faction:is_human() then
			cm:override_ui(self.disable_panel_button, true)
		end
	end

	self:start_dominance_listeners()
	self:start_chieftain_listeners()
	self:start_deference_listeners()
	
	--victory condition checks--
	local tamurkhan_faction = cm:get_faction(self.faction)
	local campaign_name = cm:get_campaign_name()
	if tamurkhan_faction ~= false then
		if tamurkhan_faction:is_human() then
			if tamurkhan_faction and campaign_name == "main_warhammer" then 
				core:add_listener(
					"IEVictoryConditionTamurkhanChieftainMissionListener",
					"MissionSucceeded",
					function(context)
						return context:mission():mission_record_key():starts_with("wh3_dlc25_ie_qb_nur_tamurkhan_chieftain_")
					end,
					function()
						cm:increase_scripted_mission_count("wh_main_short_victory", "chieftain_devoted_short", 1)
						cm:increase_scripted_mission_count("wh_main_long_victory", "chieftain_devoted_long", 1)						
					end,
					true
				)
			elseif tamurkhan_faction and campaign_name == "wh3_main_chaos" then 
				core:add_listener(
					"RoCVictoryConditionTamurkhanChieftainMissionListener",
					"MissionSucceeded",
					function(context)
						return context:mission():mission_record_key():starts_with("wh3_dlc25_qb_nur_tamurkhan_chieftain_")
					end,
					function()
						cm:increase_scripted_mission_count("wh_main_long_victory", "tamurkhan_chieftain_devoted_deference_realms", 1)
					end,
					true
				)
			end
		end
	end
end


function nur_chieftains:start_dominance_listeners()

	core:add_listener(
		"PanelUnlockDominanceChanged",
		"PooledResourceChanged",
		function(context)
			local pooled_resource = context:resource()
			return pooled_resource:key() == self.pr_dominance and pooled_resource:value() >= self.dominance_req_to_unlock and context:faction():is_human()
		end,
		function(context)
			local faction = context:faction():name()
			if nur_chieftains.tier_1_reached == false then
				if faction == self.faction then
					cm:override_ui(self.disable_panel_button, false)
					cm:trigger_incident(faction, self.panel_available_incident, true, true)
					--button highlight
					highlight_component(true, false, "faction_buttons_docker", "button_tamurkhan_chiefs")
					chieftains_button_highlighter()
					nur_chieftains.tier_1_reached = true
				end
			end
		end,
		false
	)
	
	--Dominance gain--
	---Dominance gained in battle
	core:add_listener(
		"DominanceFromBattle",
		"BattleCompleted",
		function(context)
			return cm:pending_battle_cache_faction_won_battle(self.faction)
		end,
		function(context)	
			cm:faction_add_pooled_resource(self.faction, self.pr_dominance, self.pr_dominance_factor, 1)
		end,
		true
	)
	---Dominance gained for AI
	core:add_listener(
		"DominanceForAI",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == self.faction and context:faction():is_human() == false
		end,
		function(context)
			local amount_to_add_per_turn = 1
			cm:faction_add_pooled_resource(self.faction, self.pr_dominance, self.pr_dominance_factor, amount_to_add_per_turn)
		end,
		true
	)


end

function nur_chieftains:start_chieftain_listeners()

	--spawn chieftains on ritual--
	for _, chieftain_type in ipairs(self.chieftain_type) do
		core:add_listener(
			"ChieftainUnlock"..chieftain_type,
			"RitualStartedEvent",
			function(context)
				return context:performing_faction():name() == self.faction and context:ritual():ritual_category() == "TAMURKHAN_CHIEFTAIN_RECRUIT"
			end,
			function(context)
				local ritual_key = context:ritual():ritual_key()
				local faction = context:performing_faction()
				local faction_cqi = faction:command_queue_index()
				local tamurkhan_cqi = faction:faction_leader():command_queue_index()

				if ritual_key == self[chieftain_type].recruit_ritual then
					cm:spawn_unique_agent_at_character(faction_cqi, self[chieftain_type].agent, tamurkhan_cqi, true)
					cm:trigger_incident(self.faction, self.tamurkhan_trait_incident, true)
					--lock the ritual so the AI stops trying to use it
					cm:lock_ritual(faction, self[chieftain_type].recruit_ritual)
					cm:unlock_ritual(faction, self[chieftain_type].unit_rituals[1], 0)
					--Kayzk has reached Deference level 1, update Tamurkhan's initial trait
					if chieftain_type == "kayzk" then
						cm:force_add_trait(cm:char_lookup_str(tamurkhan_cqi), self.tamurkhan_trait_start, 1)
					end
				end
			end,
			true
		)
		
		core:add_listener(
			"ChieftainOnSpawnAttributes"..chieftain_type,
			"UniqueAgentSpawned",
			function(context)
				local unique_agent = context:unique_agent_details()

				return 	unique_agent:faction():name() == self.faction and unique_agent:character():get_forename() == "names_name_"..self[chieftain_type].forename
			end,
			function(context)
				local unique_agent = context:unique_agent_details()
				local chieftain = unique_agent:character()
				local chieftain_cqi = chieftain:command_queue_index()
				local faction = unique_agent:faction()
				local faction_is_human = faction:is_human()
				local spawn_rank = faction:faction_leader():rank()

				--sets up starting character
				if self[chieftain_type].has_spawned == false then
					cm:replenish_action_points(cm:char_lookup_str(chieftain_cqi))
					cm:force_add_ancillary(chieftain, self[chieftain_type].anciliary, true, true)
					cm:trigger_incident(self.faction, self[chieftain_type].incident_unlock, true)
					--sets chieftain rank to 7 unless Tamurkhan is lower, in which case sets to same as Tamurkhan
					if spawn_rank <= 7 then
						cm:add_agent_experience(cm:char_lookup_str(chieftain_cqi), spawn_rank, true)
					else
						cm:add_agent_experience(cm:char_lookup_str(chieftain_cqi), 7, true)
					end

					--applies legendary hero ancillary to Kazyk only
					if self[chieftain_type].agent == self.kazyk.agent then
						cm:force_add_ancillary(chieftain, "wh3_dlc25_anc_weapon_sword_of_filth", true, true)
					end

					--applies first deference level (scaling trait and effect bundle to unlock rituals and add merc pool caps) 
					cm:force_add_trait(cm:char_lookup_str(chieftain_cqi), self[chieftain_type].trait_start, 1)
					cm:apply_effect_bundle(self[chieftain_type].t1_bundle, self.faction, 0)

					--moves the camera to tamurkhan after spawning a chieftain
					if faction_is_human and faction:is_factions_turn() and not cm:model():pending_battle():is_active() and cm:get_local_faction_name(true) == faction:name() then
						local character = faction:faction_leader()
						cm:scroll_camera_from_current(true, 1.5, {character:display_position_x(), character:display_position_y(), 6, 0, 6});
					end

					self[chieftain_type].has_spawned = true
				end
			end,
			true
		)
	end

	--Chieftain Unit Rituals AI Handler--
	core:add_listener(
		"ChieftainUnitRitualsAI",
		"RitualCompletedEvent",
		function(context)
			local faction = context:performing_faction()
			return faction:name() == self.faction and faction:is_human() == false and context:ritual():ritual_category() == "TAMURKHAN_CHIEFTAIN_UNIT_PURCHASE"
		end,
		function(context)
			cm:lock_ritual(context:performing_faction(), context:ritual():ritual_key(), self.ai_unit_ritual_cooldown)
		end,
		true
	)
	
	--Chieftain Abilities Handler--
	core:add_listener(
		"ChieftainAbilities",
		"RitualCompletedEvent",
		function(context)
			return self.ritual_functions[context:ritual():ritual_key()] ~= nil
		end,
		function(context)
			self.ritual_functions[context:ritual():ritual_key()](context)
		end,
		true
	)

	--Chieftain Dilemmas--
	core:add_listener( 
		"ChieftainDilemmas",
		"FactionTurnStart",
		function(context)
			local faction = context:faction() 
			return faction:name() == self.faction and faction:is_human() == true
		end,
		function(context)
			local valid_dilemmas = {}
			local faction = context:faction()

			for _, dilemma_data in ipairs(nur_chieftains.chieftain_dilemma) do
				local chieftain_1 = get_character_by_type_from_faction(faction, dilemma_data.chieftain_1.agent) --getting character type from faction using character_script_interface 
				local chieftain_2 = get_character_by_type_from_faction(faction, dilemma_data.chieftain_2.agent) --getting character type from faction using character_script_interface 
				
				local deference_amount_1 = faction:pooled_resource_manager():resource(dilemma_data.chieftain_1.pr_deference_key):value()
				local deference_amount_2 = faction:pooled_resource_manager():resource(dilemma_data.chieftain_2.pr_deference_key):value()
				
				if dilemma_data.has_launched == false then
					if not chieftain_1 == false and not chieftain_2 == false then
						if chieftain_1:is_wounded() == false and  deference_amount_1 >= self.dilemma_deference_min_req then
							if chieftain_2:is_wounded() == false and  deference_amount_2 >= self.dilemma_deference_min_req then
									
								table.insert(valid_dilemmas, dilemma_data)
							end
						end
					end
				end
			end
		
			if #valid_dilemmas >= 1 then

				local randomised_dilemmas = cm:random_sort_copy(valid_dilemmas)

				for _, valid_option in ipairs(randomised_dilemmas) do
					local dice_roll = cm:random_number(100, 1)

					if dice_roll >= self.dilemma_chance then
						
						valid_option.has_launched = true --so it won't attempt to fire this one again
						cm:trigger_dilemma(self.faction, valid_option.dilemma_key)
					
						return
						
					end
				end
			end
		end,
		true		
	)

end

function nur_chieftains:start_deference_listeners()

	--Deference levels changed via pooled resource--
	for _, chieftain_type in ipairs(self.chieftain_type) do
		core:add_listener(
			"DeferenceLevelsChanged"..chieftain_type,
			"PooledResourceChanged",
			function(context)
				return context:resource():key() == self[chieftain_type].pr_deference_key
			end,
			function(context)
				local faction = context:faction()
				local deference = context:resource()
				local deference_value = deference:value()
				local character_list = faction:character_list()
				local tamurkhan = faction:faction_leader()
				local tamurkhan_cqi = tamurkhan:command_queue_index()
								
				for i = 0, character_list:num_items() - 1 do
					local character = character_list:item_at(i)
					local chieftain_cqi = character:command_queue_index()

					if character:character_subtype_key() == self[chieftain_type].agent then
						local trait_level = character:trait_points(self[chieftain_type].trait)

						--Chieftain has reached Deference level 2
						if deference_value >= self[chieftain_type].deference_value_tier_2 and deference_value < self[chieftain_type].deference_value_tier_3 and trait_level == 0 then
							cm:remove_effect_bundle(self[chieftain_type].t1_bundle, self.faction)
							cm:apply_effect_bundle(self[chieftain_type].t2_bundle, self.faction, 0)
							cm:unlock_ritual(faction, self[chieftain_type].unit_rituals[2], 0)
							--changing chieftain trait from antitrait
							cm:force_add_trait(cm:char_lookup_str(chieftain_cqi), self[chieftain_type].trait, 1)
							cm:force_add_trait(cm:char_lookup_str(chieftain_cqi), self[chieftain_type].trait, 1) --adding twice because setting level to 2 doesn't work when transitioning from antitrait
							cm:trigger_incident(self.faction, self[chieftain_type].incident_deference_t2, true)
							
							--progress feature chieftain unlocks 1/3
							if nur_chieftains.tier_2_reached == false then
								cm:unlock_ritual(faction, self.bray_shaman.recruit_ritual, 0)
								cm:unlock_ritual(faction, self.werekin.recruit_ritual, 0)
								cm:unlock_ritual(faction, self.exalted_hero.recruit_ritual, 0)
								cm:unlock_ritual(faction, self.castellan.recruit_ritual, 0)
								cm:unlock_ritual(faction, self.fimir_balefiend.recruit_ritual, 0)
								cm:trigger_incident(self.faction, self.chieftains_available_incident_1, true, true)
								
								--changing tamurkhan trait from antitrait
								cm:force_add_trait(cm:char_lookup_str(tamurkhan_cqi), self.tamurkhan_trait, 1)
								cm:force_add_trait(cm:char_lookup_str(tamurkhan_cqi), self.tamurkhan_trait, 1) --adding twice because setting level to 2 doesn't work when transitioning from antitrait
								cm:trigger_incident(self.faction, self.tamurkhan_trait_incident, true)
								
								nur_chieftains.tier_2_reached = true
							end
						else						
							--Chieftain has reached Deference level 3
							if deference_value >= self[chieftain_type].deference_value_tier_3 then
								cm:remove_effect_bundle(self[chieftain_type].t1_bundle, self.faction)
								cm:remove_effect_bundle(self[chieftain_type].t2_bundle, self.faction)
								cm:apply_effect_bundle(self[chieftain_type].t3_bundle, self.faction, 0)
								cm:force_add_trait(cm:char_lookup_str(chieftain_cqi), self[chieftain_type].trait, 1)
								cm:trigger_incident(self.faction, self[chieftain_type].incident_deference_t3, true)
								cm:unlock_ritual(faction, self[chieftain_type].unit_rituals[3], 0)
								
								if trait_level == 1 then
									cm:force_add_trait(cm:char_lookup_str(tamurkhan_cqi), self.tamurkhan_trait, 1)
								else
									if trait_level < 1 then
										cm:force_add_trait(cm:char_lookup_str(tamurkhan_cqi), self.tamurkhan_trait, 1)
										cm:force_add_trait(cm:char_lookup_str(tamurkhan_cqi), self.tamurkhan_trait, 1)
										cm:force_add_trait(cm:char_lookup_str(chieftain_cqi), self[chieftain_type].trait, 1)
										cm:force_add_trait(cm:char_lookup_str(chieftain_cqi), self[chieftain_type].trait, 1)
									end
								end

								--launches the Devoted mission which is hidden from the player by the UI
								if cm:get_campaign_name() == "main_warhammer" then
									cm:trigger_mission(self.faction, self[chieftain_type].qb_mission_ie, true)
								else
									cm:trigger_mission(self.faction, self[chieftain_type].qb_mission_roc, true)
								end
								
								--progress feature chieftain unlocks 2/3
								if nur_chieftains.tier_3_reached == false then
									--tamurkhan trait	
									cm:trigger_incident(self.faction, self.tamurkhan_trait_incident, true)

									nur_chieftains.tier_3_reached = true
								end
								
								--cancels the fallback condition for fimir to reach deference t3 if reached normally
								if character:character_subtype_key() == self.fimir_balefiend.agent then
									self.fimir_balefiend.fallback_occurred = true
								end
							end
						end
					end
				end
			end,
			true
		)
	end
	
	--The following occurs when the chieftain has reached the maximum numerical deference value--
	--1.Devote Ritual triggers QB mission - this is handled in the DeferenceLevelsChanged listener
	--2.When QB is completed, removed deference t3 effects and applies deference t4 effect bundle & trait level
	for _, chieftain_type in ipairs(self.chieftain_type) do
		core:add_listener(
			"ChieftainT4Reward"..chieftain_type,
			"MissionSucceeded",
			function(context)
				local mission_key = context:mission():mission_record_key()
				return mission_key == self[chieftain_type].qb_mission_roc or mission_key == self[chieftain_type].qb_mission_ie
			end,
			function(context)
				local faction = context:faction()
				local character_list = faction:character_list()
				local tamurkhan = faction:faction_leader()
				local tamurkhan_cqi = tamurkhan:command_queue_index()
					
				for i = 0, character_list:num_items() - 1 do
					local character = character_list:item_at(i)
					local chieftain_cqi = character:command_queue_index()
					--Chieftain has reached Deference level 4
					if character:character_subtype_key() == self[chieftain_type].agent then
						cm:remove_effect_bundle(self[chieftain_type].t3_bundle, self.faction)
						cm:apply_effect_bundle(self[chieftain_type].t4_bundle, self.faction, 0)
						cm:force_add_trait(cm:char_lookup_str(chieftain_cqi), self[chieftain_type].trait, 1)
						cm:trigger_incident(self.faction, self[chieftain_type].incident_deference_t4, true)	

						--progress feature chieftain unlocks 3/3
						if nur_chieftains.tier_4_reached == false then
							--add final trait level to tamurkhan
							cm:force_add_trait(cm:char_lookup_str(tamurkhan_cqi), self.tamurkhan_trait, 1) 
							cm:trigger_incident(self.faction, self.tamurkhan_trait_incident, true)
							nur_chieftains.tier_4_reached = true
						end
					end
				end
			end,
			true
		)
	end

	--listeners for granting deference and dominance--
	--1. battle deference for all chieftains
	for _, chieftain_type in ipairs(self.chieftain_type) do
		core:add_listener(
			"DeferenceFromBattle"..chieftain_type,
			"BattleCompleted",
			function(context)
				if self[chieftain_type].has_spawned == true then
					return cm:pending_battle_cache_faction_won_battle(self.faction)
				else
					return false
				end
			end,
			function(context)	
				if cm:pending_battle_cache_faction_set_member_is_involved(self[chieftain_type].pr_target_cultures) then	
					self:increase_deference_amount(self[chieftain_type].pr_deference_key, self[chieftain_type].pr_factor_battle, 1)
				end
			end,
			true
		)
	end

	--2. individual listeners for each chieftains unique deference gain condition
	core:add_listener(
		"DeferenceRaiding",
		"FactionTurnStart",
		function(context)
			if self.werekin.has_spawned == true then
				return context:faction():name() == self.faction
			else
				return false
			end
		end,
		function(context)	
			local force_list = context:faction():military_force_list()

			for i = 0, force_list:num_items() -1 do
				local current_force = force_list:item_at(i)
				local stance = current_force:active_stance()
				
				if stance == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID" then
					if current_force:has_general() and not current_force:is_null_interface() then
						self:increase_deference_amount(self.werekin.pr_deference_key, self.werekin.pr_factor_unique, 1)
					end
				end
			end
		end,
		true
	)
	
	core:add_listener(
		"DeferenceFromDominance",
		"RitualCompletedEvent",
		function(context)
			local ritual = context:ritual():ritual_key()
			local ritual_excluded = "wh3_dlc25_ritual_nur_bray_shaman_recruit"
			local ritual_category_list = {
				TAMURKHAN_CHIEFTAIN_RECRUIT = true,
				TAMURKHAN_CHIEFTAIN_UNIT_PURCHASE = true
			}
			if self.bray_shaman.has_spawned == true and ritual ~= ritual_excluded then
				return context:performing_faction():name() == self.faction and ritual_category_list[context:ritual():ritual_category()] 
			else
				return false
			end		
		end,
		function(context)
			self:increase_deference_amount(self.bray_shaman.pr_deference_key, self.bray_shaman.pr_factor_unique, 1)
		end,
		true
	)
	
	core:add_listener(
		"DeferenceRazing",
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			if self.exalted_hero.has_spawned == true then
				return context:character():faction():name() == self.faction and context:occupation_decision() == "1714590130"
			else
				return false
			end
		end,
		function(context)
			self:increase_deference_amount(self.exalted_hero.pr_deference_key, self.exalted_hero.pr_factor_unique, 1)
		end,
		true
	)
	
	core:add_listener(
		"DeferencePlagues",
		"RitualCompletedEvent",
		function(context)
			if self.kazyk.has_spawned == true then
				return context:performing_faction():name() == self.faction and context:ritual():ritual_category() == "NURGLE_RITUAL"
			else
				return false
			end		
		end,
		function(context)
			self:increase_deference_amount(self.kazyk.pr_deference_key, self.kazyk.pr_factor_unique, 1)
		end,
		true
	)

	core:add_listener(
		"DeferenceLooting",
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			if self.castellan.has_spawned == true then
				return context:character():faction():name() == self.faction and context:occupation_decision() == "922680816"
			else
				return false
			end		
		end,
		function()
			self:increase_deference_amount(self.castellan.pr_deference_key, self.castellan.pr_factor_unique, 1)
		end,
		true
	)

	core:add_listener(
		"DeferenceTechs",
		"ResearchCompleted",
		function(context)
			if self.fimir_balefiend.has_spawned == true then
				return context:faction():name() == self.faction	
			else
				return false
			end		
		end,
		function(context)
			if context:faction():num_completed_technologies() < self.number_of_nurgle_techs then
				self:increase_deference_amount(self.fimir_balefiend.pr_deference_key, self.fimir_balefiend.pr_factor_unique, 1)
			else ---fallback condition for fimir deference if all techs researched
				if self.fimir_balefiend.fallback_occurred == false then
					self:increase_deference_amount(self.fimir_balefiend.pr_deference_key, self.fimir_balefiend.pr_factor_unique, self.fimir_balefiend.deference_value_tier_3)
					self.fimir_balefiend.fallback_occurred = true
				end	
			end
		end,
		true
	)
end

--Boosts deference gain for AI
function nur_chieftains:increase_deference_amount(deference_key, pr_factor_key, pr_amount)
	local faction = cm:get_faction(self.faction)
	local deference_amount = pr_amount
	if faction:is_human() == false then
		deference_amount = deference_amount + 1
	end
	cm:faction_add_pooled_resource(self.faction, deference_key, pr_factor_key, deference_amount)
end

--Ability ritual functions called by ChieftainAbilities listener--
--1.Applying effect bundle to force for chieftain t2 abilities
function apply_effect_bundle_to_chieftain_force(context, chieftain, bundle)
	local faction = context:performing_faction()
	local character_list = faction:character_list()
		
	for i = 0, character_list:num_items() - 1 do
		local character = character_list:item_at(i)

		if character:character_subtype(chieftain) then
			if character:is_embedded_in_military_force() then
				local mf_cqi = character:embedded_in_military_force():command_queue_index()
				cm:apply_effect_bundle_to_force(bundle, mf_cqi, 2)
			end
		end
	end
end

--2.Applying temporary stance to force for chieftain t2 abilities
function apply_temp_stance_to_chieftan_force(context, chieftain, stance)
	local faction = context:performing_faction()
	local character_list = faction:character_list()
	
	for i = 0, character_list:num_items() - 1 do
		local character = character_list:item_at(i)
		if character:character_subtype(chieftain) then
			if character:is_embedded_in_military_force() then
				local mf_cqi = character:embedded_in_military_force():command_queue_index()
				cm:military_force_add_temporary_stance(mf_cqi, stance, 2)
			end
		end
	end
end

--3.Applying temporary stance to all forces for chieftain t3 abilities
function apply_temp_stance_to_force_factionwide(context, stance)
	local faction = context:performing_faction()
	local force_list = faction:military_force_list()
		
	for i = 0, force_list:num_items() - 1 do
		local military_force = force_list:item_at(i)
		local mf_cqi = military_force:command_queue_index()

		cm:military_force_add_temporary_stance(mf_cqi, stance, 2)
	end
end

--4.Other scripted chieftain abilities
function exalted_hero_t3_ability(context, chieftain)
	local faction = context:performing_faction()
	local character_list = faction:character_list()
	
	for i = 0, character_list:num_items() - 1 do
		local character = character_list:item_at(i)
		if character:character_subtype(chieftain) then
			if character:is_embedded_in_military_force() then
				local mf_leader = character:embedded_in_military_force():general_character():command_queue_index()
				cm:replenish_action_points(cm:char_lookup_str(mf_leader))
			end
		end
	end
end

function castellan_t3_ability(context, chieftain)
	local faction = context:performing_faction()
	local character_list = faction:character_list()
	
	for i = 0, character_list:num_items() - 1 do
		local character = character_list:item_at(i)
		if character:character_subtype(chieftain) then
			if character:is_embedded_in_military_force() then
				local mf = character:embedded_in_military_force()
				cm:heal_military_force(mf)
			end
		end
	end
end

---Get script interface for characters - used for Dilemmas--
function get_character_by_type_from_faction(faction_interface, agent_key) --getting character type from faction using character_script_interface 
	local character_list = faction_interface:character_list()
	for i = 0, character_list:num_items() - 1 do
		local character = character_list:item_at(i)
		local chieftain = character:character_subtype(agent_key)

		if chieftain then
			return character
		end
	end
	return false
end

function chieftains_button_highlighter()
	-- unhighlights button when player opens panel
	core:add_listener(
		"unhighlight_chieftains_button_used",
		"PanelOpenedCampaign", 
		function(context) 
			return context.string == "dlc25_tamurkhan_chieftains" 
		end,
		function()
			highlight_component(false, false, "faction_buttons_docker", "button_tamurkhan_chiefs")
		end, 
		false
	)
	-- backup unhighlight if player doesnt open panel
	core:add_listener(
		"unhighlight_chieftains_button_next_turn",
		"FactionTurnEnd", 
		function(context)
			return context:faction():name() == nur_chieftains.faction and nur_chieftains.tier_1_reached == true
		end,
		function()
			highlight_component(false, false, "faction_buttons_docker", "button_tamurkhan_chiefs")
		end, 
		false
	)
end

-------------------SAVE/LOAD--------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("bray_shaman.has_spawned", nur_chieftains.bray_shaman.has_spawned, context)
		cm:save_named_value("castellan.has_spawned", nur_chieftains.castellan.has_spawned, context)
		cm:save_named_value("exalted_hero.has_spawned", nur_chieftains.exalted_hero.has_spawned, context)
		cm:save_named_value("fimir_balefiend.has_spawned", nur_chieftains.fimir_balefiend.has_spawned, context)
		cm:save_named_value("kazyk.has_spawned", nur_chieftains.kazyk.has_spawned, context)
		cm:save_named_value("werekin.has_spawned", nur_chieftains.werekin.has_spawned, context)
		cm:save_named_value("tier_1_reached", nur_chieftains.tier_1_reached, context)
		cm:save_named_value("tier_2_reached", nur_chieftains.tier_2_reached, context)
		cm:save_named_value("tier_3_reached", nur_chieftains.tier_3_reached, context)
		cm:save_named_value("tier_4_reached", nur_chieftains.tier_4_reached, context)
		cm:save_named_value("deference_fallback", nur_chieftains.fimir_balefiend.fallback_occurred, context)
	end
)
cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			nur_chieftains.bray_shaman.has_spawned = cm:load_named_value("bray_shaman.has_spawned", nur_chieftains.bray_shaman.has_spawned, context)
			nur_chieftains.castellan.has_spawned = cm:load_named_value("castellan.has_spawned", nur_chieftains.castellan.has_spawned, context)
			nur_chieftains.exalted_hero.has_spawned = cm:load_named_value("exalted_hero.has_spawned", nur_chieftains.exalted_hero.has_spawned, context)
			nur_chieftains.fimir_balefiend.has_spawned = cm:load_named_value("fimir_balefiend.has_spawned", nur_chieftains.fimir_balefiend.has_spawned, context)
			nur_chieftains.kazyk.has_spawned = cm:load_named_value("kazyk.has_spawned", nur_chieftains.kazyk.has_spawned, context)
			nur_chieftains.werekin.has_spawned = cm:load_named_value("werekin.has_spawned", nur_chieftains.werekin.has_spawned, context)
			nur_chieftains.tier_1_reached = cm:load_named_value("tier_1_reached", nur_chieftains.tier_1_reached, context)
			nur_chieftains.tier_2_reached = cm:load_named_value("tier_2_reached", nur_chieftains.tier_2_reached, context)
			nur_chieftains.tier_3_reached = cm:load_named_value("tier_3_reached", nur_chieftains.tier_3_reached, context)
			nur_chieftains.tier_4_reached = cm:load_named_value("tier_4_reached", nur_chieftains.tier_4_reached, context)
			nur_chieftains.fimir_balefiend.fallback_occurred = cm:load_named_value("deference_fallback", nur_chieftains.fimir_balefiend.fallback_occurred, context)
		end
	end
)
	

