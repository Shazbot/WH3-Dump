--------------------------------------------
--- DLC29 - ARCHAON SUBJUGATION SCRIPT ---
--------------------------------------------

-- Config data
archaon_subjugation_config = {

	archaon_faction_key = "wh_main_chs_chaos",

	-- Major Chaos factions get vassalized as substitute faction, general_subtype_key needed for initial creation of vassal faction to assign faction leader
	culture_key_to_vassal_owner_data_list = {
		["wh3_main_nur_nurgle"] = 	{faction_key = "wh3_dlc29_nurgle_vassal_owner",		general_subtype_key = "wh3_main_nur_herald_of_nurgle_nurgle",},
		["wh3_main_kho_khorne"] = 	{faction_key = "wh3_dlc29_khorne_vassal_owner",		general_subtype_key = "wh3_main_kho_herald_of_khorne",},
		["wh3_main_tze_tzeentch"] = {faction_key = "wh3_dlc29_tzeentch_vassal_owner",	general_subtype_key = "wh3_main_tze_herald_of_tzeentch_tzeentch",},
		["wh3_main_sla_slaanesh"] = {faction_key = "wh3_dlc29_slaanesh_vassal_owner",	general_subtype_key = "wh3_main_sla_herald_of_slaanesh_slaanesh",},
	},

	culture_key_to_subjugation_type_list = {
		["wh_main_chs_chaos"] = "confederate",
		["wh3_main_nur_nurgle"] = "vassalize",
		["wh3_main_kho_khorne"] = "vassalize",
		["wh3_main_tze_tzeentch"] = "vassalize",
		["wh3_main_sla_slaanesh"] = "vassalize",
	},

	faction_key_to_leader_subtype_list = {
		["wh3_dlc20_chs_kholek"]				= { subtype_key = "wh_dlc01_chs_kholek_suneater",},
		["wh3_dlc20_chs_sigvald"]				= { subtype_key = "wh_dlc01_chs_prince_sigvald",},
		["wh3_dlc20_chs_valkia"]				= { subtype_key = "wh3_dlc20_kho_valkia",},
		["wh3_dlc20_chs_festus"]				= { subtype_key = "wh3_dlc20_nur_festus",},
		["wh3_dlc20_chs_azazel"]				= { subtype_key = "wh3_dlc20_sla_azazel",},
		["wh3_dlc20_chs_vilitch"]				= { subtype_key = "wh3_dlc20_tze_vilitch",},
		["wh3_dlc29_chs_host_of_the_triplets"]	= { subtype_key = "wh3_dlc29_chs_glottkin",},
		["wh3_main_chs_shadow_legion"]			= { subtype_key = "wh3_main_dae_belakor",},
		["wh3_main_kho_exiles_of_khorne"]		= { subtype_key = "wh3_main_kho_skarbrand",},
		["wh3_dlc26_kho_skulltaker"]			= { subtype_key = "wh3_dlc26_kho_skulltaker",},
		["wh3_dlc26_kho_arbaal"]				= { subtype_key = "wh3_dlc26_kho_arbaal_the_undefeated",},
		["wh3_main_tze_oracles_of_tzeentch"]	= { subtype_key = "wh3_main_tze_kairos",},
		["wh3_dlc24_tze_the_deceivers"]			= { subtype_key = "wh3_dlc24_tze_the_changeling",},
		["wh3_main_nur_poxmakers_of_nurgle"]	= { subtype_key = "wh3_main_nur_kugath",},
		["wh3_dlc25_nur_tamurkhan"]				= { subtype_key = "wh3_dlc25_nur_tamurkhan",},
		["wh3_dlc25_nur_epidemius"]				= { subtype_key = "wh3_dlc25_nur_epidemius",},
		["wh3_main_sla_seducers_of_slaanesh"]	= { subtype_key = "wh3_main_sla_nkari",},
		["wh3_dlc27_sla_the_tormentors"]		= { subtype_key = "wh3_dlc27_sla_dechala"},
		["wh3_dlc27_sla_masque_of_slaanesh"]	= { subtype_key = "wh3_dlc27_sla_masque_of_slaanesh"},
	},

	battle_setup = {
		-- TODO: (design) set up proper units 
		unit_types = {
			["wh_main_chs_chaos"] = { -- this will currently be used only for belakor
				inf_low = "wh_main_chs_inf_chaos_marauders_0",
				inf_low_special = "wh_dlc01_chs_inf_forsaken_0",
				inf_high = "wh_main_chs_inf_chaos_warriors_0",
				inf_high_special = "wh_dlc01_chs_inf_chosen_2",
				cav_low = "wh_main_chs_cav_marauder_horsemen_1",
				cav_high = "wh_main_chs_cav_chaos_knights_0",
				monster_low = "wh_main_chs_mon_chaos_warhounds_1",
				monster_med = "wh_main_chs_mon_chaos_spawn",
				monster_high = "wh_dlc01_chs_mon_dragon_ogre_shaggoth",
			},
			["wh3_main_kho_khorne"] = {
				inf_low = "wh3_dlc20_chs_inf_chaos_marauders_mkho_dualweapons",
				inf_low_special = "wh3_main_kho_inf_bloodletters_0",
				inf_high = "wh3_main_kho_inf_chaos_warriors_0",
				inf_high_special = "wh3_dlc20_chs_inf_chosen_mkho_dualweapons",
				cav_low = "wh3_dlc20_chs_cav_marauder_horsemen_mkho_throwing_axes",
				cav_high = "wh3_main_kho_cav_bloodcrushers_0",
				monster_low = "wh3_main_kho_inf_flesh_hounds_of_khorne_0",
				monster_med = "wh3_dlc26_kho_mon_bloodbeast_of_khorne",
				monster_high = "wh3_main_kho_mon_bloodthirster_0",
			},
			["wh3_main_nur_nurgle"] = {
				inf_low = "wh3_dlc20_chs_inf_chaos_marauders_mnur_greatweapons",
				inf_low_special = "wh3_main_nur_inf_plaguebearers_0",
				inf_high = "wh3_dlc20_chs_inf_chaos_warriors_mnur",
				inf_high_special = "wh3_dlc20_chs_inf_chosen_mnur_greatweapons",
				cav_low = "wh3_main_nur_cav_pox_riders_of_nurgle_0",
				cav_high = "wh3_main_nur_cav_plague_drones_1",
				monster_low = "wh3_main_nur_mon_beast_of_nurgle_0",
				monster_med = "wh3_dlc25_nur_mon_bile_trolls",
				monster_high = "wh3_main_nur_mon_great_unclean_one_0",
			},
			["wh3_main_sla_slaanesh"] = {
				inf_low = "wh3_dlc20_chs_inf_chaos_marauders_msla_hellscourges",
				inf_low_special = "wh3_main_sla_inf_daemonette_0",
				inf_high = "wh3_dlc20_chs_inf_chaos_warriors_msla",
				inf_high_special = "wh3_dlc20_chs_inf_chosen_msla_hellscourges",
				cav_low = "wh3_main_sla_cav_hellstriders_1",
				cav_high = "wh3_dlc27_sla_cav_pleasureseekers",
				monster_low = "wh3_main_sla_mon_fiends_of_slaanesh_0",
				monster_med = "wh3_dlc27_sla_mon_preyton",
				monster_high = "wh3_main_sla_mon_keeper_of_secrets_0",
			},
			["wh3_main_tze_tzeentch"] = {
				inf_low = "wh3_dlc20_chs_inf_chaos_marauders_mtze_spears",
				inf_low_special = "wh3_main_tze_inf_pink_horrors_0",
				inf_high = "wh3_dlc20_chs_inf_chaos_warriors_mtze",
				inf_high_special = "wh3_dlc20_chs_inf_chosen_mtze_halberds",
				cav_low = "wh3_dlc24_bst_inf_centigors_great_weapons_mtze",
				cav_high = "wh3_main_tze_cav_doom_knights_0",
				monster_low = "wh3_main_tze_mon_screamers_0",
				monster_med = "wh3_main_tze_mon_lord_of_change_0",
				monster_high = "wh3_dlc24_tze_mon_mutalith_vortex_beast",
			},
		},

		unit_weight = {
				-- unit_type		{easy|medium|hard|very hard}
			[1] = {
				-- Infantry - 14
				inf_low =			{8, 7, 6, 5},
				inf_low_special = 	{6, 6, 5, 6},
				inf_high = 			{0, 1, 2, 2},
				inf_high_special = 	{0, 0, 0, 0},
				--Cavalry - 3
				cav_low = 			{3, 3, 3, 2},
				cav_high = 			{0, 0, 0, 1},
				--Monsters - 3
				monster_low = 		{3, 3, 2, 2},
				monster_med = 		{0, 0, 1, 1},
				monster_high = 		{0, 0, 0, 0},
			},
			[2] = {
				-- Infantry - 14
				inf_low =			{6, 6, 6, 5},
				inf_low_special = 	{7, 7, 6, 6},
				inf_high = 			{1, 1, 2, 2},
				inf_high_special = 	{0, 0, 0, 1},
				--Cavalry - 3
				cav_low = 			{3, 3, 2, 2},
				cav_high = 			{0, 0, 1, 1},
				--Monsters - 3
				monster_low = 		{3, 2, 1, 1},
				monster_med = 		{0, 1, 2, 2},
				monster_high = 		{0, 0, 0, 0},
			},
			[3] = {
				-- Infantry - 12
				inf_low =			{4, 3, 2, 0},
				inf_low_special = 	{4, 4, 4, 4},
				inf_high = 			{4, 4, 4, 5},
				inf_high_special = 	{0, 1, 2, 3},
				--Cavalry - 4
				cav_low = 			{3, 2, 2, 1},
				cav_high = 			{1, 2, 2, 3},
				--Monsters - 4
				monster_low = 		{2, 2, 1, 0},
				monster_med = 		{2, 2, 2, 3},
				monster_high = 		{0, 0, 1, 1},
			},
			[4] = {
				-- Infantry - 8
				inf_low =			{0, 0, 0, 0},
				inf_low_special = 	{2, 0, 0, 0},
				inf_high = 			{4, 5, 4, 3},
				inf_high_special = 	{2, 3, 4, 5},
				--Cavalry - 4
				cav_low = 			{2, 1, 0, 0},
				cav_high = 			{2, 3, 4, 4},
				--Monsters - 8
				monster_low = 		{3, 2, 0, 0},
				monster_med = 		{3, 3, 5, 4},
				monster_high = 		{2, 3, 3, 4},
			},
		},

		-- Assign unit_types of specific monogod culture to following WoC factions, otherwise default unit_types["wh_main_chs_chaos"] settings will be used
		woc_factions_unit_types_override = {
			-- faction								culture to override unit types with
			["wh3_dlc20_chs_kholek"]			   = "wh3_main_kho_khorne",
			["wh3_dlc20_chs_sigvald"]			   = "wh3_main_sla_slaanesh",
			["wh3_dlc20_chs_valkia"]			   = "wh3_main_kho_khorne",
			["wh3_dlc20_chs_festus"]			   = "wh3_main_nur_nurgle",
			["wh3_dlc20_chs_azazel"]			   = "wh3_main_sla_slaanesh",
			["wh3_dlc20_chs_vilitch"]			   = "wh3_main_tze_tzeentch",
			["wh3_dlc29_chs_host_of_the_triplets"] = "wh3_main_nur_nurgle",
		  --["wh3_main_chs_shadow_legion"]
		},

		-- Turn number affects enemy army size, army composition and lord rank. Campaign difficulty affects enemy unit ranks
		battle_difficulty_settings = {
			[1] = {
				min_turn_number = 1,
				amount_of_units = 14,
			},
			[2] = {
				min_turn_number = 10,
				amount_of_units = 16,
			},
			[3] = {
				min_turn_number = 25,
				amount_of_units = 19,
			},
			[4] = {
				min_turn_number = 50, 
				amount_of_units = 19,
			},
		},
	},

	dilemma_type_to_key_list = {
		["confederate"] = "wh3_dlc29_chs_archaon_confederate_woc_faction",
		["vassalize"] = "wh3_dlc29_chs_archaon_vassalize_chaos_faction",
		["fight_dead_chaos_faction"] = "wh3_dlc29_chs_archaon_fight_dead_chaos_faction",
	},

	fight_dilemma_payload_data = {
		first_choice = "FIRST",
		second_choice = "SECOND",
		archaon_target = "default",
		enemy_target = "target_military_1",
	},

	event_feed_data = {
		suppressable_events = {
			confederation_event_key = "faction_joins_confederation",
			vassalage_established_event_key = "diplomacy_treaty_negotiated_vassal",
			vassalage_broken_event_key = "diplomacy_treaty_broken_vassal",
			war_declared_event_key = "diplomacy_war_declared",
			faction_destroyed_event_key = "diplomacy_faction_destroyed",
			character_dies_battle_event_key = "character_dies_battle",
		},

		subjugation_incident_key = "wh3_dlc29_archaon_subjugates_major_chaos_faction"

	},

	min_turns_to_trigger_fight_dilemma = 3,
	max_turns_to_trigger_fight_dilemma = 10,
	turns_to_delay_fight_dilemma = 1,
	camera_scroll_time_before_fight_dilemma = 4,

	extra_character_subtypes_to_transfer_on_vassalize = {
		wh3_dlc25_nur_tamurkhan = {
			wh3_dlc25_nur_kayzk_the_befouled = true,
			wh3_dlc25_nur_bray_shaman_wild_chieftain = true,
			wh3_dlc25_nur_castellan_chieftain = true,
			wh3_dlc25_nur_exalted_hero_chieftain = true,
			wh3_dlc25_nur_fimir_balefiend_shadow_chieftain = true,
			wh3_dlc25_nur_skin_wolf_werekin_chieftain = true,
			wh3_main_nur_kugath = true,
			wh3_dlc25_nur_epidemius = true,
		},
		wh3_main_nur_poxmakers_of_nurgle = {
			wh3_dlc25_nur_tamurkhan = true,
			wh3_dlc25_nur_epidemius = true,
			wh3_dlc25_nur_kayzk_the_befouled = true,
			wh3_dlc25_nur_bray_shaman_wild_chieftain = true,
			wh3_dlc25_nur_castellan_chieftain = true,
			wh3_dlc25_nur_exalted_hero_chieftain = true,
			wh3_dlc25_nur_fimir_balefiend_shadow_chieftain = true,
			wh3_dlc25_nur_skin_wolf_werekin_chieftain = true,
		},
		wh3_dlc25_nur_epidemius = {
			wh3_main_nur_kugath = true,
			wh3_dlc25_nur_tamurkhan = true,
			wh3_dlc25_nur_kayzk_the_befouled = true,
			wh3_dlc25_nur_bray_shaman_wild_chieftain = true,
			wh3_dlc25_nur_castellan_chieftain = true,
			wh3_dlc25_nur_exalted_hero_chieftain = true,
			wh3_dlc25_nur_fimir_balefiend_shadow_chieftain = true,
			wh3_dlc25_nur_skin_wolf_werekin_chieftain = true,
		},
		wh3_main_kho_exiles_of_khorne = {
			wh3_dlc26_kho_skulltaker = true,
			wh3_dlc26_kho_arbaal_the_undefeated = true,
		},
		wh3_dlc26_kho_skulltaker = {
			wh3_dlc26_kho_arbaal_the_undefeated = true,
			wh3_main_kho_skarbrand = true,
		},
		wh3_dlc26_kho_arbaal = {
			wh3_main_kho_skarbrand = true,
			wh3_dlc26_kho_skulltaker = true,
		},
		wh3_main_tze_oracles_of_tzeentch = {
			wh3_dlc24_tze_the_changeling = true,
		},
		wh3_dlc24_tze_the_deceivers = {
			wh3_main_tze_kairos = true,
		},
		wh3_main_sla_seducers_of_slaanesh = {
			wh3_dlc27_sla_dechala = true,
			wh3_dlc27_sla_masque_of_slaanesh = true,
		},
		wh3_dlc27_sla_the_tormentors = {
			wh3_dlc27_sla_masque_of_slaanesh = true,
			wh3_main_sla_nkari = true,
		},
		wh3_dlc27_sla_masque_of_slaanesh = {
			wh3_main_sla_nkari = true,
			wh3_dlc27_sla_dechala = true,
		},
	},
}

-- Dynamic data
archaon_subjugation_persistent = {
	enemy_force_cqi = 0,
	battle_difficulty = 1,
	vassals_to_transfer = {},
	suppress_faction_death_event = false,
}

archaon_subjugation = {}
archaon_subjugation.config = archaon_subjugation_config
archaon_subjugation.persistent = archaon_subjugation_persistent

function archaon_subjugation:initialise()

	-- Archaon defeats Chaos faction Legendary Lord to subjugate them
	cm:add_immortal_character_defeated_listener(
		"ArchaonDefeatsChaosCultureLegendaryLord",
		function(context)
			if cm:pending_battle_cache_faction_won_battle(self.config.archaon_faction_key) then
				if cm:pending_battle_cache_faction_is_attacker(self.config.archaon_faction_key) then
					if not cm:pending_battle_cache_human_is_defender() then
						for i = 1, cm:pending_battle_cache_num_defenders() do
							local defender_faction_key = cm:pending_battle_cache_get_defender_faction_name(i)
							if self.config.faction_key_to_leader_subtype_list[defender_faction_key] then
								return true
							end
						end
					end
				elseif cm:pending_battle_cache_faction_is_defender(self.config.archaon_faction_key) then
					if not cm:pending_battle_cache_human_is_attacker() then
						for i = 1, cm:pending_battle_cache_num_attackers() do
							local attacker_faction_key = cm:pending_battle_cache_get_attacker_faction_name(i)
							if self.config.faction_key_to_leader_subtype_list[attacker_faction_key] then
								return true
							end
						end
					end
				end
			end
			return false
		end,
		function(winner_fm, loser_fm)
			local winner_faction_obj = winner_fm:character_details():faction()
			local loser_faction_obj = loser_fm:character_details():faction()
			local loser_character_subtype_key = loser_fm:character():character_subtype_key()
			if self.config.faction_key_to_leader_subtype_list[loser_faction_obj:name()].subtype_key == loser_character_subtype_key then
				self:trigger_archaon_confederation_dilemma(winner_faction_obj, loser_faction_obj)
			end
		end,
		false
	)


	core:add_listener(
		"ChaosFactionDeath", 
		"FactionDeath", 
		function(context)
			if not context:faction():confederation_in_progress() and not self.persistent.suppress_faction_death_event then
				if self.config.faction_key_to_leader_subtype_list[context:faction():name()] then
					return true
				end
			end
			self.persistent.suppress_faction_death_event = false
			return false
		end,
		function(context)
			local winner_faction_obj = context:killer()
			local loser_faction_obj = context:faction()

			-- If faction leader dies simultaneously with faction itself - cm:add_immortal_character_defeated_listener will never fire callback
			-- We check if faction was destroyed simultaneosly with their leader by Archaon and offer him dilemma to confederate in this case
			if winner_faction_obj ~= nil and not winner_faction_obj:is_null_interface() then
				if winner_faction_obj:name() == self.config.archaon_faction_key then
					if cm:pending_battle_cache_faction_is_attacker(self.config.archaon_faction_key) then
						for i = 1, cm:pending_battle_cache_num_defenders() do
							if cm:pending_battle_cache_get_defender_subtype(i) == self.config.faction_key_to_leader_subtype_list[loser_faction_obj:name()].subtype_key then
								self:trigger_archaon_confederation_dilemma(winner_faction_obj, loser_faction_obj)
								return
							end
						end
					elseif cm:pending_battle_cache_faction_is_defender(self.config.archaon_faction_key) then
						for i = 1, cm:pending_battle_cache_num_attackers() do
							if cm:pending_battle_cache_get_attacker_subtype(i) == self.config.faction_key_to_leader_subtype_list[loser_faction_obj:name()].subtype_key then
								self:trigger_archaon_confederation_dilemma(winner_faction_obj, loser_faction_obj)
								return
							end
						end
					end
				end
			end

			-- If faction was killed by some other faction, Archaon will eventually get dilemma to fight dead faction's army to confederate them if he wins
			local turns_to_trigger_dilemma = cm:random_number(self.config.max_turns_to_trigger_fight_dilemma, self.config.min_turns_to_trigger_fight_dilemma)
			cm:add_turn_countdown_event(self.config.archaon_faction_key, turns_to_trigger_dilemma, "ScriptEventFightDeadChaosFactionDilemma", loser_faction_obj:name())
		end,
		true
	)

	core:add_listener(
		"ArchaonDilemmaToFightDeadChaosFaction", 
		"ScriptEventFightDeadChaosFactionDilemma", 
		function(context)
			return cm:get_faction(context.string):is_dead()
		end,
		function(context)
			-- Only human Archaon will get to fight dead chaos faction to subjugate them
			if cm:get_faction(self.config.archaon_faction_key):is_human() then
				self:trigger_archaon_fight_dead_chaos_faction_dilemma(context.string)
			end
		end,
		true
	)

	-- Destroy spawned military force if Archaon lost or avoided the battle
	core:add_listener(
		"CleanupPostBattleArchaonVsDeadChaosFactionArmy",
		"BattleCompleted",
		function(context)
			return self.persistent.enemy_force_cqi > 0
		end,
		function(context)
			self:cleanup_post_battle()
		end,
		true
	)

	-- Collect all vassals of faction before it dies together with their faction leader after being defeated by Archaon to transfer vassalage to Archaon in case he confederates them
	core:add_listener(
		"VassalageBrokenOnFactionDeath", 
		"NegativeDiplomaticEvent", 
		function(context)
			local proposer = context:proposer()
			local proposer_key = proposer:name()
			if self.config.faction_key_to_leader_subtype_list[proposer_key] and context:was_vassalage() then
				if self.config.culture_key_to_subjugation_type_list[proposer:culture()] == "confederate" then
					if cm:pending_battle_cache_faction_won_battle(self.config.archaon_faction_key) then
						if cm:pending_battle_cache_faction_is_attacker(self.config.archaon_faction_key) then
							for i = 1, cm:pending_battle_cache_num_defenders() do
								if cm:pending_battle_cache_get_defender_subtype(i) == self.config.faction_key_to_leader_subtype_list[proposer_key].subtype_key then
									return true
								end
							end
						elseif cm:pending_battle_cache_faction_is_defender(self.config.archaon_faction_key) then
							for i = 1, cm:pending_battle_cache_num_attackers() do
								if cm:pending_battle_cache_get_attacker_subtype(i) == self.config.faction_key_to_leader_subtype_list[proposer_key].subtype_key then
									return true
								end
							end
						end
					end
				end
			end
			return false
		end,
		function(context)
			local proposer = context:proposer()
			local recipient_key = context:recipient():name()
			table.insert(self.persistent.vassals_to_transfer, recipient_key) 

			-- If this vassalage break was not a result of faction dying to Archaon - clear the list of vassals to transfer
			cm:callback(
				function()
					if not proposer:is_dead() then
						self.persistent.vassals_to_transfer = {}
					end
				end,
				2
			)
		end,
		true
	)

end

function archaon_subjugation:trigger_archaon_confederation_dilemma(winner_faction_obj, loser_faction_obj)
	
	if loser_faction_obj ~= nil and loser_faction_obj:is_null_interface() == false then

		local human_factions = cm:get_human_factions()

		-- vassals of player factions are not valid targets
		for i = 1, #human_factions do
			if loser_faction_obj:is_vassal_of(cm:get_faction(human_factions[i])) then
				return
			end
		end

		if winner_faction_obj:is_human() then
			local loser_faction_key = loser_faction_obj:name()
			local winner_faction_key = winner_faction_obj:name()

			if merc_contracts and merc_contracts.active_contracts[winner_faction_key] then
				for _, target_faction in pairs(merc_contracts.active_contracts[winner_faction_key].targets) do
					if target_faction == loser_faction_key then
						-- don't launch subjugation dilemma if losing faction was a contract target
						return
					end
				end
			end

			local dilemma = self.config.dilemma_type_to_key_list[self.config.culture_key_to_subjugation_type_list[loser_faction_obj:culture()]]
			local loser_faction_leader_cqi = loser_faction_obj:faction_leader():command_queue_index()
			
			-- If faction is dead then trigger_dilemma_with_targets will fail on getting character interface from cqi, so we remove him from dilemma setup and use other dilemma which does not specify faction leader
			if loser_faction_obj:is_dead() then
				loser_faction_leader_cqi = 0
				dilemma = self:get_no_leader_dilemma_key(dilemma)
			end

			cm:trigger_dilemma_with_targets(
				winner_faction_obj:command_queue_index(),
				dilemma,
				loser_faction_obj:command_queue_index(),
				0,
				loser_faction_leader_cqi,
				0,
				0,
				0,
				function()
					core:add_listener(
						"ArchaonConfederationDilemmaChoiceMadeEvent",
						"DilemmaChoiceMadeEvent",
						function(context)
							local dilemma = context:dilemma()
							for _ , key in pairs(self.config.dilemma_type_to_key_list) do
								if dilemma == key or dilemma == self:get_no_leader_dilemma_key(key) then
									return true
								end
							end
							return false						
						end,
						function(context)
							-- Autosave on ironman.
							if cm:model():manual_saves_disabled() and not cm:is_multiplayer() then
								cm:callback(function() cm:autosave_at_next_opportunity() end, 0.5)
							end

							if context:choice() == 0 then
								self:subjugate_chaos_faction(loser_faction_obj)
							else
								-- Choice 2 - leave
								self.persistent.vassals_to_transfer = {}
							end
						end,
						false
					)
				end
			)
		else
			-- AI Archaon subjugates faction without dilemma
			self:subjugate_chaos_faction(loser_faction_obj)
		end
	end
end

function archaon_subjugation:trigger_archaon_fight_dead_chaos_faction_dilemma(enemy_faction_key)
	
	local archaon = cm:get_faction(self.config.archaon_faction_key):faction_leader()

	-- Delay dilemma if Archaon is in settlement/besiegeing/wounded/already fighting another revived Chaos faction
	if archaon:in_settlement() or archaon:is_besieging() or archaon:is_wounded() or self.persistent.enemy_force_cqi > 0 then
		cm:add_turn_countdown_event(self.config.archaon_faction_key, self.config.turns_to_delay_fight_dilemma, "ScriptEventFightDeadChaosFactionDilemma", enemy_faction_key)
		return
	end

	local enemy_faction_obj = cm:get_faction(enemy_faction_key)
	if enemy_faction_obj ~= nil and enemy_faction_obj:is_null_interface() == false and enemy_faction_obj:is_dead() then
		
		local dilemma = self.config.dilemma_type_to_key_list.fight_dead_chaos_faction

		local archaon_mf = archaon:military_force()
		local enemy_mf = self:generate_units_for_enemy_mf(enemy_faction_key)

		local dilemma_builder = cm:create_dilemma_builder(dilemma)
		local payload_builder = cm:create_payload()

		payload_builder:text_display("dummy_archaon_fight_dead_chaos_faction_accept")
		dilemma_builder:add_choice_payload(self.config.fight_dilemma_payload_data.first_choice, payload_builder)
		payload_builder:clear()

		payload_builder:text_display("dummy_archaon_fight_dead_chaos_faction_reject")
		payload_builder:text_display("dummy_archaon_fight_dead_chaos_faction_reject_warning")
		dilemma_builder:add_choice_payload(self.config.fight_dilemma_payload_data.second_choice, payload_builder)
		payload_builder:clear()

		dilemma_builder:add_target(self.config.fight_dilemma_payload_data.archaon_target, archaon_mf)

		local enemy_mf_cqi = self:spawn_enemy_mf(enemy_faction_key, enemy_mf, archaon_mf)

		-- Trigger dilemma again later if couldn't spawn MF to fight
		if enemy_mf_cqi == -1 then
			cm:add_turn_countdown_event(self.config.archaon_faction_key, self.config.turns_to_delay_fight_dilemma, "ScriptEventFightDeadChaosFactionDilemma", enemy_faction_key)
			return
		end

		dilemma_builder:add_target(self.config.fight_dilemma_payload_data.enemy_target, cm:get_military_force_by_cqi(enemy_mf_cqi))

		core:add_listener(
			"ArchaonFightDeadChaosFactionDilemmaChoiceMadeEvent",
			"DilemmaChoiceMadeEvent",
			function(context)
				return context:dilemma() == self.config.dilemma_type_to_key_list.fight_dead_chaos_faction
			end,
			function(context)
				if context:choice() == 0 then
					self:create_battle_with_enemy_mf(archaon_mf:command_queue_index(), enemy_mf_cqi)
				else
					self:cleanup_post_battle()
				end
			end,
			false
		)

		cm:scroll_camera_with_cutscene_to_character(self.config.camera_scroll_time_before_fight_dilemma, 
													function()
														cm:launch_custom_dilemma_from_builder(dilemma_builder, cm:get_faction(self.config.archaon_faction_key))
													end, 
													archaon:cqi()
		)

	end
end

function archaon_subjugation:subjugate_chaos_faction(subjugated_faction_obj)

	local enemy_faction_key = subjugated_faction_obj:name()
	local archaon_faction_obj = cm:get_faction(self.config.archaon_faction_key)

	for culture, subjugation_type in dpairs(self.config.culture_key_to_subjugation_type_list) do
		if subjugated_faction_obj:culture() == culture then
			if subjugation_type == "confederate" then
				-- Confederating Warriors of Chaos
				local confederation_payload = cm:create_payload()
				confederation_payload:form_confederation(archaon_faction_obj, subjugated_faction_obj, subjugated_faction_obj:is_dead(), true)

				if subjugated_faction_obj:has_faction_leader() then
					local subjugated_faction_leader_fm = subjugated_faction_obj:faction_leader():family_member()
					if subjugated_faction_obj:faction_leader():is_alive() then
						cm:kill_character(cm:char_lookup_str(subjugated_faction_leader_fm:character():cqi()), true)
					end
					cm:stop_character_convalescing(subjugated_faction_leader_fm:character():cqi())
				end

				self:transfer_vassals_of_defeated_faction(enemy_faction_key)
				cm:apply_payload(confederation_payload, archaon_faction_obj)

				-- Victory Condition
				core:trigger_event("ScriptEventArchaonSubjugatesChaosFaction", enemy_faction_key)

				return
			elseif subjugation_type == "vassalize" then
				-- Vassalizing Nurgle, Khorne, Slaanesh and Tzeentch
				local archaon_faction_cqi = archaon_faction_obj:command_queue_index()
				self.persistent.vassals_to_transfer = {}

				local vassal_faction_key = self.config.culture_key_to_vassal_owner_data_list[culture].faction_key
				local vassal_faction_obj = cm:get_faction(vassal_faction_key)
				local vassal_faction_cqi = vassal_faction_obj:command_queue_index()
					
				local subjugated_faction_cqi = subjugated_faction_obj:command_queue_index()
				local subjugated_faction_leader_fm = 0
				
				-- If subjugated faction is dead we only take their Legendary Lord and don't vassalize them
				if subjugated_faction_obj:is_dead() then
					-- We have to revive subjugated faction with region specified to get Legendary Lord data in order to transfer him to Archaon
					cm:disable_event_feed_events(true, "", "", self.config.event_feed_data.suppressable_events.faction_destroyed_event_key)
					cm:awaken_faction_from_death_with_region(subjugated_faction_obj, archaon_faction_obj:faction_leader():region():name())
					
					local character_to_transfer_cqi = self:resurrect_enemy_faction_legendary_lord(enemy_faction_key)

					if character_to_transfer_cqi ~= -1 then
						cm:reassign_character(character_to_transfer_cqi, archaon_faction_cqi)
						subjugated_faction_leader_fm = cm:get_character_by_cqi(character_to_transfer_cqi):family_member()
					else
						script_error(string.format("ERROR: Could not retrive faction '%s' legendary lord to transfer to Archaon.", enemy_faction_key))
					end

					self.persistent.suppress_faction_death_event = true
					cm:kill_faction(enemy_faction_key)
					cm:callback(
						function()
							cm:disable_event_feed_events(false, "", "", self.config.event_feed_data.suppressable_events.faction_destroyed_event_key)
						end,
						0.5
					)
				else
					cm:disable_event_feed_events(true, "", "", self.config.event_feed_data.suppressable_events.confederation_event_key)
					cm:disable_event_feed_events(true, "", "", self.config.event_feed_data.suppressable_events.vassalage_broken_event_key)
					cm:disable_event_feed_events(true, "", "", self.config.event_feed_data.suppressable_events.vassalage_established_event_key)

					-- Awaken and establish vassal owner faction of Archaon
					if vassal_faction_obj:is_dead() then
						local region_key = ""

						if subjugated_faction_obj:num_regions() > 0 then
							region_key = subjugated_faction_obj:region_list():item_at(0):name()
						elseif subjugated_faction_obj:character_list():num_items() > 0 then
							for i = 0, subjugated_faction_obj:character_list():num_items() - 1 do
								if subjugated_faction_obj:character_list():item_at(i):has_region() then
									region_key = subjugated_faction_obj:character_list():item_at(i):region():name()
									break
								end
							end
						else
							script_error(string.format("ERROR: Faction '%s' has no regions and characters but somehow still alive.", enemy_faction_key))
							region_key = archaon_faction_obj:faction_leader():region():name()
						end
						self:awaken_vassal_faction(vassal_faction_obj, region_key)
					end

					if vassal_faction_obj:master():is_null_interface() or vassal_faction_obj:master() == nil then
						cm:force_make_vassal(self.config.archaon_faction_key, vassal_faction_key, true)
					end

					-- Transfer subjugated faction LL to Archaon faction
					if subjugated_faction_obj:has_faction_leader() then
						subjugated_faction_leader_fm = subjugated_faction_obj:faction_leader():family_member()
						if subjugated_faction_obj:faction_leader():is_alive() then
							cm:kill_character(cm:char_lookup_str(subjugated_faction_leader_fm:character():cqi()), true)
						end
						cm:reassign_character(subjugated_faction_leader_fm:character():cqi(), archaon_faction_cqi)
						cm:stop_character_convalescing(subjugated_faction_leader_fm:character():cqi())
					end

					-- Check for any extra subtypes that need to be transfered
					local family_members_to_reassign = {}
					if archaon_subjugation.config.extra_character_subtypes_to_transfer_on_vassalize[enemy_faction_key] then
						local char_list = subjugated_faction_obj:character_list()
						for j = 0, char_list:num_items() - 1 do
							local curr_char = char_list:item_at(j)
							if archaon_subjugation.config.extra_character_subtypes_to_transfer_on_vassalize[enemy_faction_key][curr_char:character_subtype_key()] then
								table.insert(family_members_to_reassign, curr_char:family_member())
							end
						end
					end
					-- actually transfer, split in a separate loop to avoid calling kill character during a loop over the character list
					for i = 1, #family_members_to_reassign do
						local curr_char_fm = family_members_to_reassign[i]
						local curr_char = curr_char_fm:character()
						if curr_char:is_alive() then
							cm:kill_character(cm:char_lookup_str(curr_char:cqi()), true)
						end
						cm:reassign_character(curr_char_fm:character():cqi(), archaon_faction_cqi)
						cm:stop_character_convalescing(curr_char_fm:character():cqi())
					end

					-- Confederate subjugated faction with vassal owner faction
					local confederation_payload = cm:create_payload()
					confederation_payload:form_confederation(vassal_faction_obj, subjugated_faction_obj, subjugated_faction_obj:is_dead(), true)

					cm:apply_payload(confederation_payload, vassal_faction_obj)

					cm:callback(
						function() 
							cm:disable_event_feed_events(false, "", "", self.config.event_feed_data.suppressable_events.confederation_event_key)
							cm:disable_event_feed_events(false, "", "", self.config.event_feed_data.suppressable_events.vassalage_broken_event_key)
							cm:disable_event_feed_events(false, "", "", self.config.event_feed_data.suppressable_events.vassalage_established_event_key)
						end,
						1
					)
				end

				-- Incident's localised description in Dave:
				-- After {{CcoCampaignEventIncident:FirstTargetName}}'s subjugation [[img:ui/flags/{{CcoCampaignEventIncident:ScriptObjectContext(Format("subjugated_faction_key_%d", PrimaryTargetFactionContext.CQI)).StringValue}}/mon_24.png]][[/img]]{{CcoCampaignEventIncident:ScriptObjectContext(Format("subjugated_faction_%d", PrimaryTargetFactionContext.CQI)).StringValue}}'s followers have joined {{CcoCampaignEventIncident:ScriptObjectContext(Format("vassal_faction_%d", PrimaryTargetFactionContext.CQI)).StringValue}} to follow Archaon's command
				common.set_context_value("subjugated_faction_" .. vassal_faction_cqi, cco("CcoCampaignFaction", subjugated_faction_cqi):Call("Name"))
				common.set_context_value("subjugated_faction_key_" .. vassal_faction_cqi, cco("CcoCampaignFaction", subjugated_faction_cqi):Call("FactionRecordContext.Key"))
				common.set_context_value("vassal_faction_" .. vassal_faction_cqi, cco("CcoCampaignFaction", vassal_faction_cqi):Call("Name"))
				
				if not subjugated_faction_leader_fm:is_null_interface() and subjugated_faction_leader_fm ~= nil and subjugated_faction_leader_fm ~= 0 then
					cm:trigger_incident_with_targets(
						archaon_faction_cqi,
						self.config.event_feed_data.subjugation_incident_key,
						vassal_faction_cqi,
						0,
						subjugated_faction_leader_fm:character():cqi(),
						0,
						0,
						0
					)
				end

				-- Victory Condition
				core:trigger_event("ScriptEventArchaonSubjugatesChaosFaction", enemy_faction_key)

				return
			end
		end
	end
end

function archaon_subjugation:transfer_vassals_of_defeated_faction(defeated_faction_key)
	
	local defeated_faction = cm:get_faction(defeated_faction_key)
	local defeated_faction_vassals = {}

	if defeated_faction:is_dead() then
		defeated_faction_vassals = self.persistent.vassals_to_transfer
		for i = 1, #defeated_faction_vassals do
			cm:force_make_vassal(self.config.archaon_faction_key, defeated_faction_vassals[i], true)
		end
	else
		defeated_faction_vassals = defeated_faction:vassals()
		for i = 0, defeated_faction_vassals:num_items() - 1 do
			cm:force_break_vassalage(defeated_faction_vassals:item_at(i):name())
			cm:force_make_vassal(self.config.archaon_faction_key, defeated_faction_vassals:item_at(i):name(), true)
		end
	end

	self.persistent.vassals_to_transfer = {}
end

function archaon_subjugation:generate_units_for_enemy_mf(faction_key)

	local culture = cm:get_faction(faction_key):culture()
	local ram = random_army_manager
	local ram_name = "chaos_force_against_archaon"..culture
	ram:remove_force(ram_name)
	ram:new_force(ram_name)

	if self.config.battle_setup.woc_factions_unit_types_override[faction_key] then
		culture = self.config.battle_setup.woc_factions_unit_types_override[faction_key]
	end

	local units = self.config.battle_setup.unit_types[culture]
	local difficulty_settings = self.config.battle_setup.battle_difficulty_settings
	local current_difficulty = cm:get_difficulty()
	
	--Legendary and Very Hard share set
	if current_difficulty > 4 then 
		current_difficulty = 4 
	end

	local unit_count = difficulty_settings[current_difficulty].amount_of_units
	local current_turn_set = 1

	for turn_set , settings in dpairs(difficulty_settings) do
		if cm:turn_number() >= settings.min_turn_number then
			unit_count = settings.amount_of_units
			current_turn_set = turn_set
		end
	end

	local units_weight = self.config.battle_setup.unit_weight[current_turn_set]


	ram:add_unit(ram_name, units.inf_low, units_weight.inf_low[current_difficulty])
	ram:add_unit(ram_name, units.inf_low_special, units_weight.inf_low_special[current_difficulty])
	ram:add_unit(ram_name, units.inf_high, units_weight.inf_high[current_difficulty])
	ram:add_unit(ram_name, units.inf_high_special, units_weight.inf_high_special[current_difficulty])
	ram:add_unit(ram_name, units.cav_low, units_weight.cav_low[current_difficulty])
	ram:add_unit(ram_name, units.cav_high, units_weight.cav_high[current_difficulty])
	ram:add_unit(ram_name, units.monster_low, units_weight.monster_low[current_difficulty])
	ram:add_unit(ram_name, units.monster_med, units_weight.monster_med[current_difficulty])
	ram:add_unit(ram_name, units.monster_high, units_weight.monster_high[current_difficulty])

	return ram:generate_force(ram_name, unit_count, false)
end

function archaon_subjugation:spawn_enemy_mf(enemy_faction_key, military_force, archaon_mf)
	
	local enemy_force_cqi = 0
	local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_character(self.config.archaon_faction_key, cm:char_lookup_str(archaon_mf:general_character()), true, 1)

	local enemy_general_cqi = self:resurrect_enemy_faction_legendary_lord(enemy_faction_key)

	if pos_x == -1 or enemy_general_cqi == -1 then
		return -1
	end

	local region_name = archaon_mf:general_character():region():name()

	cm:create_force_with_existing_general(
		cm:char_lookup_str(enemy_general_cqi),
		enemy_faction_key, 
		military_force, 
		region_name, 
		pos_x,
		pos_y,
		function(char_cqi,force_cqi)
			if char_cqi ~= nil and force_cqi ~= nil then
				self.persistent.enemy_force_cqi = force_cqi
				cm:disable_event_feed_events(true, "", "", self.config.event_feed_data.suppressable_events.faction_destroyed_event_key)
				cm:disable_event_feed_events(true, "", "", self.config.event_feed_data.suppressable_events.character_dies_battle_event_key)
				cm:disable_event_feed_events(true, "", "", self.config.event_feed_data.suppressable_events.war_declared_event_key)
				cm:force_declare_war(enemy_faction_key, self.config.archaon_faction_key, false, false)
				cm:callback(function() cm:disable_event_feed_events(false, "", "", self.config.event_feed_data.suppressable_events.war_declared_event_key) end, 0.2)
				cm:disable_movement_for_character(cm:char_lookup_str(char_cqi))
				cm:set_force_has_retreated_this_turn(cm:get_military_force_by_cqi(force_cqi))

				self:apply_difficulty_scaling_to_enemy_mf(char_cqi)
			end
		end
	)

	-- Check if cm:create_force_with_general failed
	if self.persistent.enemy_force_cqi == 0 then
		return -1
	else
		return self.persistent.enemy_force_cqi
	end
end

function archaon_subjugation:resurrect_enemy_faction_legendary_lord(enemy_faction_key)

	local enemy_faction_obj = cm:get_faction(enemy_faction_key)
	if enemy_faction_obj ~= nil and not enemy_faction_obj:is_null_interface()  then
		local archaon_faction_obj = cm:get_faction(self.config.archaon_faction_key)

		cm:awaken_faction_from_death_with_region(enemy_faction_obj, archaon_faction_obj:faction_leader():region():name())
		
		if not enemy_faction_obj:character_list():is_empty() then
			local legendary_lord_subtype_key = self.config.faction_key_to_leader_subtype_list[enemy_faction_key].subtype_key
			local characters = enemy_faction_obj:character_list()
			for i = 0, characters:num_items() - 1 do
				if characters:item_at(i):character_subtype(legendary_lord_subtype_key) then
					return characters:item_at(i):cqi()
				end
			end
		end
	end
	return -1
end

function archaon_subjugation:apply_difficulty_scaling_to_enemy_mf(general_cqi)
	
	-- Campaign difficulty scaling (unit ranks)
	if not cm:is_multiplayer() then
		local difficulty = cm:model():difficulty_level()
		
		if difficulty == -1 then
			-- Hard
			cm:add_experience_to_units_commanded_by_character(cm:char_lookup_str(general_cqi), 2)
		elseif difficulty == -2 then
			-- Very Hard
			cm:add_experience_to_units_commanded_by_character(cm:char_lookup_str(general_cqi), 4)
		elseif difficulty == -3 then
			-- Legendary
			cm:add_experience_to_units_commanded_by_character(cm:char_lookup_str(general_cqi), 6)
		end
	end
end

function archaon_subjugation:create_battle_with_enemy_mf(archaon_mf_cqi, chaos_mf_cqi)
	
	cm:get_campaign_ui_manager():override("retreat"):lock()
	cm:force_attack_of_opportunity(
		archaon_mf_cqi,
		chaos_mf_cqi,
		false,
		true,
		true
	)
	
end

function archaon_subjugation:awaken_vassal_faction(vassal_faction_obj, region_key)
	if vassal_faction_obj == nil or vassal_faction_obj:is_null_interface()  then
		return
	end

	cm:awaken_faction_from_death(vassal_faction_obj)

	-- Create faction leader
	local vassal_faction_key = vassal_faction_obj:name()
	local vassal_culture = vassal_faction_obj:culture()
	local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(vassal_faction_key, region_key, false, true)

	if pos_x == -1 then
		return
	end

	cm:create_force_with_general(
		vassal_faction_key,
		nil,
		region_key,
		pos_x,
		pos_y,
		"general",
		self.config.culture_key_to_vassal_owner_data_list[vassal_culture].general_subtype_key,
		"",
		"",
		"",
		"",
		true,
		function(char_cqi)
			if char_cqi ~= nil then
				cm:randomise_character_name(cm:get_character_by_cqi(char_cqi))
			end
		end
	)

end

function archaon_subjugation:cleanup_post_battle()
	self.persistent.suppress_faction_death_event = true

	cm:get_campaign_ui_manager():override("retreat"):unlock()

	if self.persistent.enemy_force_cqi and self.persistent.enemy_force_cqi > 0 then
		local mf = cm:get_military_force_by_cqi(self.persistent.enemy_force_cqi)

		if mf and not mf:faction():is_human() then
			cm:kill_all_armies_for_faction(mf:faction())
		end
	end

	cm:callback(
		function()
			cm:disable_event_feed_events(false, "", "", self.config.event_feed_data.suppressable_events.faction_destroyed_event_key)
			cm:disable_event_feed_events(false, "", "", self.config.event_feed_data.suppressable_events.character_dies_battle_event_key)
		end,
		0.2
	)

	self.persistent.enemy_force_cqi = 0
end

--------------------------------------------------------------
----------------------- UTIL ---------------------------------
--------------------------------------------------------------

function archaon_subjugation:get_no_leader_dilemma_key(dilemma_key)
	return tostring(dilemma_key .. "_no_leader")
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("archaon_subjugation.persistent", archaon_subjugation.persistent, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			archaon_subjugation.persistent = cm:load_named_value("archaon_subjugation.persistent", archaon_subjugation.persistent, context)
		end
	end
)

---- Issues:
-- Reinforcements get in the in battle if standing close to nearby MFs - created code request
-- No failsafe if force_attack_of_opportunity fails
-- Bad subjugation incident setup - needs fixing