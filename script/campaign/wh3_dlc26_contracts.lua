merc_contracts = {
	mercenary_factions = {
		["wh3_dlc26_ogr_golgfag"] = true
	},
	client_exclusion_list = {
		-- cultures or factions within this list won't ever offer contracts (they can still be targets)
		-- keys can be faction keys or subcultures
		"wh3_main_dae_daemons",
		"wh3_main_kho_khorne",
		"wh3_main_nur_nurgle",
		"wh3_main_sla_slaanesh",
		"wh3_main_tze_tzeentch",
		"wh_dlc03_bst_beastmen",
		"wh_main_chs_chaos"
	},
	golgfag_faction_key = "wh3_dlc26_ogr_golgfag",
	previous_client_key = false,

	contract_points = {
		resource = "merc_active_contract_points",
		factors = {
			raiding = "raiding",
			agent_actions = "hero_actions"
		},
		values = {
			raiding = 10,
			agent_actions = 25
		}
	},
	contract_data = {
		description = {
			prefix = "golgfag_mercenary_contract_desc_",
			count = 2 -- ensure there is always this number of descriptions per culture in the DB
		},
		duration = {
			min = 5,
			max = 20
		},
		scaling_point_modifiers = {
			{bracket = 5000, modifier = 0.1},
			{bracket = 2500, modifier = 0.2},
			{bracket = 2000, modifier = 0.25},
			{bracket = 1500, modifier = 0.35},
			{bracket = 1000, modifier = 0.4},
			{bracket = 600, modifier = 0.5},
			{bracket = 0, modifier = 0.6},
		},
		minimum_point_target = 200,
		modifiers = {
			duration = {
				min = 0, max = 3
			}
		},
		secondary_rewards = {
			"effect_bundles",
			"ancillaries",
			"banners"
		},
		secondary_reward_chance = {
			[1] = 45, -- % chance of 1 secondary reward
			[2] = 5, -- % chance of 2 secondary rewards
		},
		rewards = {
			treasury = 10, -- per 1 contract point
			bonus_treasury = 5, -- per 1 contract point earned over the original target.
			meat = 2, -- per 1 contract point
			effect_bundles = {
				prefix = "wh3_dlc26_golgfag_contracts_reward_",
				count = 22 -- the number of bundles in DaVE
			},
			ancillaries = {
				wh_main_brt_bretonnia = {
					"wh3_dlc26_golgfag_contract_anc_arcane_item_sacrament_of_the_lady",
					"wh3_dlc26_golgfag_contract_anc_armour_gilded_cuirass",
					"wh3_dlc26_golgfag_contract_anc_enchanted_item_holy_icon",
					"wh3_dlc26_golgfag_contract_anc_weapon_sword_of_the_ladys_champion",
					"wh3_dlc26_golgfag_contract_anc_weapon_sword_of_the_quest"
				},
				wh3_dlc23_chd_chaos_dwarfs = {
					"wh3_dlc26_golgfag_contract_anc_armour_blackshard_armour",
					"wh3_dlc26_golgfag_contract_anc_talisman_possessed_amulet",
					"wh3_dlc26_golgfag_contract_anc_follower_chd_arms_merchant",
					"wh3_dlc26_golgfag_contract_anc_enchanted_item_daemon_flask_of_ashak"
				},
				wh2_main_def_dark_elves = {
					"wh3_dlc26_golgfag_contract_anc_weapon_venom_sword",
					"wh3_dlc26_golgfag_contract_anc_enchanted_item_whip_of_agony",
					"wh3_dlc26_golgfag_contract_anc_armour_cloak_of_hag_graef",
					"wh3_dlc26_golgfag_contract_anc_follower_def_cultist",
					"wh3_dlc26_golgfag_contract_anc_weapon_deathpiercer"
				},
				wh_main_dwf_dwarfs = {
					"wh3_dlc26_golgfag_contract_anc_follower_dwarfs_brewmaster",
					"wh3_dlc26_golgfag_contract_anc_weapon_miners_pickaxe",
					"wh3_dlc26_golgfag_contract_anc_weapon_slayers_axe",
					"wh3_dlc26_golgfag_contract_anc_talisman_veterans_flask",
					"wh3_dlc26_golgfag_contract_anc_armour_troll_slayers_hide"
				},
				wh_main_emp_empire = {
					"wh3_dlc26_golgfag_contract_anc_follower_empire_burgher",
					"wh3_dlc26_golgfag_contract_anc_follower_empire_camp_follower",
					"wh3_dlc26_golgfag_contract_anc_follower_all_men_fisherman",
					"wh3_dlc26_golgfag_contract_anc_follower_empire_entertainer"
				},
				wh3_main_cth_cathay = {
					"wh3_dlc26_golgfag_contract_anc_weapon_serpent_fang",
					"wh3_dlc26_golgfag_contract_anc_enchanted_item_alchemists_elixir_of_iron_skin",
					"wh3_dlc26_golgfag_contract_anc_enchanted_item_cleansing_water",
					"wh3_dlc26_golgfag_contract_anc_weapon_vermillion_blade",
					"wh3_dlc26_golgfag_contract_anc_follower_cth_mercantilist"
				},
				wh_main_grn_greenskins = {
					"wh3_dlc26_golgfag_contract_anc_follower_greenskins_snotling_scavengers",
					"wh3_dlc26_golgfag_contract_anc_follower_greenskins_shroom_gathera",
					"wh3_dlc26_golgfag_contract_anc_follower_greenskins_pit_boss",
					"wh3_dlc26_golgfag_contract_anc_armour_armour_of_gork",
					"wh3_dlc26_golgfag_contract_anc_arcane_item_lucky_shrunken_head"
				},
				wh2_main_hef_high_elves = {
					"wh3_dlc26_golgfag_contract_anc_follower_hef_minstrel",
					"wh3_dlc26_golgfag_contract_anc_follower_hef_food_taster",
					"wh3_dlc26_golgfag_contract_anc_talisman_amulet_of_fire",
					"wh3_dlc26_golgfag_contract_anc_enchanted_item_talisman_of_loec",
					"wh3_dlc26_golgfag_contract_anc_enchanted_item_cloak_of_beards"
				},
				wh3_main_ksl_kislev = {
					"wh3_dlc26_golgfag_contract_anc_follower_camp_cook",
					"wh3_dlc26_golgfag_contract_anc_follower_quartermaster",
					"wh3_dlc26_golgfag_contract_anc_armour_basic",
					"wh3_dlc26_golgfag_contract_anc_talisman_blood_of_the_motherland",
					"wh3_dlc26_golgfag_contract_anc_talisman_blizzard_broach"
				},
				wh2_main_lzd_lizardmen = {
					"wh3_dlc26_golgfag_contract_anc_weapon_the_piranha_blade",
					"wh3_dlc26_golgfag_contract_anc_armour_hide_of_the_cold_ones",
					"wh3_dlc26_golgfag_contract_anc_enchanted_item_the_horn_of_kygor",
					"wh3_dlc26_golgfag_contract_anc_enchanted_item_the_cloak_of_feathers",
					"wh3_dlc26_golgfag_contract_anc_weapon_sword_of_the_hornet"
				},
				wh_dlc08_nor_norsca = {
					"wh3_dlc26_golgfag_contract_anc_follower_beserker",
					"wh3_dlc26_golgfag_contract_anc_follower_mammoth",
					"wh3_dlc26_golgfag_contract_anc_weapon_fimir_hammer",
					"wh3_dlc26_golgfag_contract_anc_enchanted_item_manticore_horn",
					"wh3_dlc26_golgfag_contract_anc_enchanted_item_vial_of_troll_blood"
				},
				wh3_main_ogr_ogre_kingdoms = {
					"wh3_main_anc_weapon_the_tenderiser",
					"wh3_main_anc_talisman_cathayan_jet",
					"wh3_main_anc_arcane_item_skullmantle",
					"wh3_main_anc_weapon_siegebreaker",
					"wh3_main_anc_enchanted_item_greyback_pelt"
				},
				wh2_main_skv_skaven = {
					"wh3_dlc26_golgfag_contract_anc_follower_def_slave",
					"wh3_dlc26_golgfag_contract_anc_follower_skv_slave_human",
					"wh3_dlc26_golgfag_contract_anc_weapon_weeping_blade",
					"wh3_dlc26_golgfag_contract_anc_weapon_retractable_fistblade",
					"wh3_dlc26_golgfag_contract_anc_talisman_foul_pendant"
				},
				wh2_dlc09_tmb_tomb_kings = {
					"wh3_dlc26_golgfag_contract_anc_enchanted_item_elixir_of_might",
					"wh3_dlc26_golgfag_contract_anc_enchanted_item_cloak_of_the_dunes",
					"wh3_dlc26_golgfag_contract_anc_armour_armour_of_eternity",
					"wh3_dlc26_golgfag_contract_anc_enchanted_item_hieratic_jar",
					"wh3_dlc26_golgfag_contract_anc_weapon_blade_of_antarhak"
				},
				wh2_dlc11_cst_vampire_coast = {
					"wh3_dlc26_golgfag_contract_anc_armour_seadragon_buckler",
					"wh3_dlc26_golgfag_contract_anc_weapon_lucky_levis_hookhand",
					"wh3_dlc26_golgfag_contract_anc_talisman_jellyfish_in_a_jar",
					"wh3_dlc26_golgfag_contract_anc_enchanted_item_black_buckthorns_treasure_map",
					"wh3_dlc26_golgfag_contract_anc_follower_cst_drawn_chef"
				},
				wh_main_vmp_vampire_counts = {
					"wh3_dlc26_golgfag_contract_anc_follower_undead_manservant",
					"wh3_dlc26_golgfag_contract_anc_enchanted_item_rod_of_flaming_death",
					"wh3_dlc26_golgfag_contract_anc_armour_nightshroud",
					"wh3_dlc26_golgfag_contract_anc_follower_undead_corpse_thief",
					"wh3_dlc26_golgfag_contract_anc_follower_undead_flesh_golem"
				},
				wh_dlc05_wef_wood_elves = {
					"wh3_dlc26_golgfag_contract_anc_follower_vauls_anvil_smith",
					"wh3_dlc26_golgfag_contract_anc_weapon_the_bow_of_loren",
					"wh3_dlc26_golgfag_contract_anc_weapon_daiths_reaper",
					"wh3_dlc26_golgfag_contract_anc_follower_young_stag",
					"wh3_dlc26_golgfag_contract_anc_armour_the_helm_of_the_hunt"
				}
			},
			banners = {
				wh_main_brt_bretonnia = {
					"wh3_dlc26_golgfag_contract_anc_banner_blessing_of_the_lady",
					"wh3_dlc26_golgfag_contract_anc_banner_maneater_knights"
				},
				wh3_dlc23_chd_chaos_dwarfs = {
					"wh3_dlc26_golgfag_contract_anc_banner_hellforge_blades",
				 	"wh3_dlc26_golgfag_contract_anc_banner_blast_proof_gutplates",
					"wh3_dlc26_golgfag_contract_anc_banner_undying_will"
				},
				wh2_main_def_dark_elves = {
					"wh3_dlc26_golgfag_contract_anc_banner_murderous_prowess",
					"wh3_dlc26_golgfag_contract_anc_banner_witchbrew",
					"wh3_dlc26_golgfag_contract_anc_banner_black_dragon_egg"	
				},
				wh_main_dwf_dwarfs = {
					"wh3_dlc26_golgfag_contract_anc_banner_worthy_foe",
					"wh3_dlc26_golgfag_contract_anc_banner_slayer",
					"wh3_dlc26_golgfag_contract_anc_banner_runes_of_protection"
				},
				wh_main_emp_empire = {
					"wh3_dlc26_golgfag_contract_anc_banner_blackpowder_discipline",
					"wh3_dlc26_golgfag_contract_anc_banner_pigeon_bomb",
					"wh3_dlc26_golgfag_contract_anc_banner_tools_of_judgement"
				},
				wh3_main_cth_cathay = {
					"wh3_dlc26_golgfag_contract_anc_banner_bulwark_of_the_gate",
					"wh3_dlc26_golgfag_contract_anc_banner_yin",
					"wh3_dlc26_golgfag_contract_anc_banner_yang"
				},
				wh_main_grn_greenskins = {
					"wh3_dlc26_golgfag_contract_anc_banner_waaaagh",
					"wh3_dlc26_golgfag_contract_anc_banner_night_goblin_toxins",
					"wh3_dlc26_golgfag_contract_anc_banner_warpaint",
					"wh3_dlc26_golgfag_contract_anc_banner_overwhelming_odour"
				},
				wh2_main_hef_high_elves = {
					"wh3_dlc26_golgfag_contract_anc_banner_martial_prowess",
					"wh3_dlc26_golgfag_contract_anc_banner_deflection_training",
					"wh3_dlc26_golgfag_contract_anc_banner_lion_cloak"
				},
				wh3_main_ksl_kislev = {
					"wh3_dlc26_golgfag_contract_anc_banner_glorious_charge",
					"wh3_dlc26_golgfag_contract_anc_banner_by_our_blood"
				},
				wh2_main_lzd_lizardmen = {
					"wh3_dlc26_golgfag_contract_anc_banner_primal_instincts",
					"wh3_dlc26_golgfag_contract_anc_banner_predatory_fighter",
					"wh3_dlc26_golgfag_contract_anc_banner_red_crest_toxins"
				},
				wh_dlc08_nor_norsca = {
					"wh3_dlc26_golgfag_contract_anc_banner_rage",
					"wh3_dlc26_golgfag_contract_anc_banner_berserk"
				},
				wh2_main_skv_skaven = {
					"wh3_dlc26_golgfag_contract_anc_banner_ratbag_tactics",
					"wh3_dlc26_golgfag_contract_anc_banner_horned_rat",
					"wh3_dlc26_golgfag_contract_anc_banner_verminous_doom",
					"wh3_dlc26_golgfag_contract_anc_banner_shield_of_distraction"
				},
				wh2_dlc09_tmb_tomb_kings = {
					"wh3_dlc26_golgfag_contract_anc_banner_bone_muncha"
				},
				wh2_dlc11_cst_vampire_coast = {
					"wh3_dlc26_golgfag_contract_anc_banner_black_powder_aplenty",
					"wh3_dlc26_golgfag_contract_anc_banner_bomb_throw",
					"wh3_dlc26_golgfag_contract_anc_banner_rotten_diet",
					"wh3_dlc26_golgfag_contract_anc_banner_taunt"
				},
				wh_main_vmp_vampire_counts = {
					"wh3_dlc26_golgfag_contract_anc_banner_the_hungry",
					"wh3_dlc26_golgfag_contract_anc_banner_dark_benediction",
					"wh3_dlc26_golgfag_contract_anc_banner_brooding_maneaters",
					"wh3_dlc26_golgfag_contract_anc_banner_flag_of_blood_keep"
				},
				wh_dlc05_wef_wood_elves = {
					"wh3_dlc26_golgfag_contract_anc_banner_hawkish_precision",
					"wh3_dlc26_golgfag_contract_anc_banner_maneater_woodsman",
					"wh3_dlc26_golgfag_contract_anc_banner_guardians_of_the_wildwood"
				}
			}
		},
	},
	
	incidents = {
		new = "wh3_dlc26_incident_merc_contract_new",
		failed = "wh3_dlc26_incident_merc_contract_failed",
		success = "wh3_dlc26_incident_merc_contract_success",
		cancelled = "wh3_dlc26_incident_merc_contract_cancelled",
		client_satisfied = "wh3_dlc26_incident_merc_contract_satisfied"
	},

	dilemmas = {
		repair_relations = "wh3_dlc26_ogr_contract_complete"
	},

	available_rewards = {},
	active_contracts = {},
	siege_settlement_level = 1,
	track_character_killed = {},

	stored_target_factions = {}, -- used for temporarily storing target factions after a contract completes for things such as making peace which can happen a few ticks later.
	once_per_contract_teleport_ritual_key = "wh3_dlc26_ogr_ritual_golgfag_teleport",
	default_effect_bundle_reward_duration = 7
}


function merc_contracts:initialise()
	self:track_raiding()
	self:track_agent_actions()

	if cm:is_new_game() then
		self:set_merc_diplomacy_restrictions()
	end

	core:add_listener(
		"MercContractListGenerate",
		"FactionTurnStart",
		function(context)
			return self.mercenary_factions[context:faction():name()]
		end,
		function(context)
			local faction_name = context:faction():name()

			if cm:turn_number() > 1 then
				self:generate_contract_list(faction_name)
			elseif(faction_name == self.golgfag_faction_key) then
				-- Golgfag turn 1 setup.
				self:generate_golgfag_starting_contracts()
			end
		end,
		true
	)

	core:add_listener(
		"MercContractAccepted",
		"WarContractAcceptedEvent",
		true,
		function(context)
			local wc = context:contract()
			local merc_faction = context:hired_faction()
			local merc_faction_name = merc_faction:name()
			local client_faction = wc:client_faction()
			local client_name = client_faction:name()
			local targets = wc:target_factions()
			local target_factions = {}
			local rewards = self.available_rewards[merc_faction_name..client_name]
			local description_choice = cm:random_number(2, 1)
			local incident_key = self.incidents.new.."_"..client_faction:culture().."_"..description_choice
			
			-- Clear other available contracts for this turn.
			cm:remove_all_available_war_contracts(merc_faction_name)

			for i = 0, targets:num_items() - 1 do
				local target_faction = targets:item_at(i):name()
				cm:cai_add_diplomatic_event(target_faction, client_name, "PAST_EVENT_NEGATIVE_MAJOR") -- CHANGE THIS TO A NEW EVENT "Hired Mercenaries"
				table.insert(target_factions, target_faction)
			end

			local contract_details = {
				client = client_name,
				targets = target_factions,
				rewards = rewards
			}

			self.active_contracts[merc_faction_name] = contract_details
			cm:trigger_incident_with_targets(merc_faction:command_queue_index(), incident_key, client_faction:command_queue_index(), 0, 0, 0, 0, 0)

			cm:unlock_ritual(context:hired_faction(), self.once_per_contract_teleport_ritual_key)

			self.previous_client_key = client_name
		end,
		true
	)

	core:add_listener(
		"MercContractSuccess",
		"WarContractSuccessEvent",
		true,
		function(context)
			local merc_faction = context:hired_faction()
			local merc_faction_name = context:hired_faction():name()
			local payload = cm:create_payload()
			local rewards = self.active_contracts[merc_faction_name].rewards

			if rewards.treasury then
				payload:treasury_adjustment(rewards.treasury)
			end

			if rewards.meat then
				payload:faction_pooled_resource_transaction("wh3_dlc26_ogr_meat_hidden", "war_contracts", rewards.meat, false)
			end

			if rewards.effect_bundle then
				local effect_bundle = cm:create_new_custom_effect_bundle(rewards.effect_bundle)
				effect_bundle:set_duration(self.default_effect_bundle_reward_duration)
				payload:effect_bundle_to_faction(effect_bundle)
			end

			if rewards.ancillary then
				payload:faction_ancillary_gain(merc_faction, rewards.ancillary)
			end

			if rewards.banner then
				payload:faction_ancillary_gain(merc_faction, rewards.banner)
			end

			merc_contracts:repair_relation_dilemma(merc_faction_name, context:contract():target_factions())
			
			cm:trigger_custom_incident(merc_faction_name, self.incidents.success, true, payload)

			self.active_contracts[merc_faction_name] = nil
		end,
		true
	)

	core:add_listener(
		"MercContractCancelled",
		"WarContractCancelledEvent",
		true,
		function(context)
			self:fail_contract(context, "cancelled")
		end,
		true
	)

	core:add_listener(
		"MercContractFailed",
		"WarContractFailedEvent",
		true,
		function(context)
			self:fail_contract(context, "failed")
		end,
		true
	)

	core:add_listener(
		"MercContractAdditionalRewards",
		"PooledResourceChanged",
		function(context)
			return context:resource():key() == self.contract_points.resource
		end,
		function(context)
			local faction_key = context:faction():name()
			local gained_cp = context:amount()
			local cp_total = context:resource():value()
			local wc = cm:model():world():war_contracts_system():get_active_war_contract(faction_key)
			local target

			if wc:is_null_interface() == false then
				target = wc:target_points()

				if cp_total > target then
					if cp_total - gained_cp > target then
						-- player was already above the cp target, grant full bonus reward
						cm:treasury_mod(faction_key, gained_cp * self.contract_data.rewards.bonus_treasury)
					else
						-- player only just crossed the cp value, so only grant the remainder bonus reward
						local partial_reward = cp_total - target
						cm:treasury_mod(faction_key, partial_reward * self.contract_data.rewards.bonus_treasury)
						-- launch an incident to let the player know they can now safely end their contract and gain the main rewards.
						cm:trigger_incident(faction_key, self.incidents.client_satisfied, true, true)
					end
				end
			end	
		end,
		true
	)

	core:add_listener(
		"golgfag_teleport_ritual_completed",
		"RitualCompletedEvent",
		function(context)
			return context:ritual():ritual_key() == self.once_per_contract_teleport_ritual_key
		end,
		function(context)
			cm:lock_ritual(context:performing_faction(), self.once_per_contract_teleport_ritual_key)
		end,
		true
	)
end

function merc_contracts:set_merc_diplomacy_restrictions()
	for faction, _ in pairs(self.mercenary_factions) do
		-- Merc Factions can't make alliances or vassals
		cm:force_diplomacy("faction:"..faction, "all", "military alliance", false, false, true)
		cm:force_diplomacy("faction:"..faction, "all", "defensive alliance", false, false, true)
		cm:force_diplomacy("faction:"..faction, "all", "vassal", false, false, true)
	end
end

function merc_contracts:fail_contract(context, type)
	local merc_faction = context:hired_faction():name()
	local wc = context:contract()
	local targets = wc:target_factions()

	cm:trigger_incident(merc_faction, self.incidents[type], true, true)

	self.active_contracts[merc_faction] = nil

	cm:cai_add_diplomatic_event(wc:client_faction():name(), merc_faction, "PAST_EVENT_NEGATIVE_MODERATE") -- CHANGE THIS TO A NEW EVENT "Contract Failed"
	merc_contracts:repair_relation_dilemma(merc_faction, targets)
end

function merc_contracts:repair_relations(merc_faction, targets)
	for i = 0, targets:num_items() - 1 do
		local target_faction = targets:item_at(i):name()
		cm:cai_add_diplomatic_event(target_faction, merc_faction, "PAST_EVENT_POSITIVE_MAJOR") -- CHANGE THIS TO A NEW EVENT "Contract Complete"
	end
end

function merc_contracts:repair_relation_dilemma(merc_faction, targets)
	cm:callback(function()
		local target_survived = false

		for i = 0, targets:num_items() - 1 do
			local target_faction = targets:item_at(i)
			
			if target_faction:is_null_interface() == true or target_faction:is_dead() == false then
				target_survived = true
			end
		end
	
		if target_survived then
			cm:trigger_dilemma(merc_faction, self.dilemmas.repair_relations)
			
			core:add_listener(
				"MercContractDilemmaChoice",
				"DilemmaChoiceMadeEvent",
				function(context)
					return context:dilemma() == self.dilemmas.repair_relations
				end,
				function(context)
					if context:choice() == 0 then
						-- Stay at War
						merc_contracts:repair_relations(merc_faction, targets)
					else
						-- Make Peace
						merc_contracts:repair_relations(merc_faction, targets)
	
						for i = 0, targets:num_items() - 1 do
							local target_faction = targets:item_at(i):name()
							cm:force_make_peace(merc_faction, target_faction)
						end
					end
				end,
				false
			)
		end
	end, 0.1) -- slight delay needed to ensure last faction is killed from final combat.
end

function merc_contracts:generate_contract_list(faction_key)
	local faction = cm:get_faction(faction_key)
	local met_factions = faction:factions_met()
	local potential_contracts = {}

	cm:remove_all_available_war_contracts(faction_key)

	for i = 0, met_factions:num_items() - 1 do 
		local met_faction = met_factions:item_at(i)
		local excluded_faction = false

		for k, v in ipairs(self.client_exclusion_list) do
			if met_faction:name() == v or met_faction:culture() == v then
				excluded_faction = true
			end
		end

		if excluded_faction == false and met_faction:at_war_with(faction) == false and met_faction:is_vassal() == false then
			local team_mates = faction:team_mates()
			local team_target = false

			for i = 0, team_mates:num_items() - 1 do
				local team_mate = team_mates:item_at(i)

				if met_faction:at_war_with(team_mate) then
					team_target = true
				end
			end

			if team_target == false then
				local client_key = met_faction:name()

				if self.active_contracts[faction_key] == nil or client_key ~= self.active_contracts[faction_key].client_name or client_key ~= self.previous_client_key then
					local contract = self:generate_contract(faction_key, met_faction:name())
					
					if contract then
						table.insert(potential_contracts, contract)
					end

					self.previous_client_key = false
				end
			end
		end
	end

	if #potential_contracts > 0 then
		local launch_chance = 120 --%  starting at 120 allows us to guarentee 2 contracts, then the chance of 3+ drops after that.

		potential_contracts = cm:random_sort(potential_contracts)

		for _, contract in ipairs(potential_contracts) do
			local roll = cm:random_number(100)
			
			if roll <= launch_chance then
				local wc = cm:create_war_contract(contract.faction_key, contract.client_key, contract.duration, contract.point_target, self:generate_description(contract.client_key))
				
				if wc:is_null_interface() == false then
					self.available_rewards[contract.faction_key..contract.client_key] = self:generate_rewards(contract.faction_key, contract.client_key, contract.point_target)
				end

				launch_chance = launch_chance - 20
			else
				return
			end
		end
	end
end

function merc_contracts:generate_golgfag_starting_contracts()
	self:generate_contract(self.golgfag_faction_key, "wh_main_emp_ostland", 250, 6, true)
	self:generate_contract(self.golgfag_faction_key, "wh_main_emp_nordland", 250, 6, true)
end

function merc_contracts:generate_contract(faction_key, client_key, target_override, duration_override, launch)
	local faction = cm:get_faction(client_key)
	local war_factions = faction:factions_at_war_with()
	local faction_strengths = {}
	local total_potential_points = 0

	for i = 0, war_factions:num_items() - 1 do 
		local war_faction = war_factions:item_at(i)
		local war_faction_name = war_faction:name()
		local region_list = war_faction:region_list()

		-- get the contract point value of all armies + garrisons for this faction
		faction_strengths[war_faction_name] = cm:model():world():war_contracts_system():combined_contract_points_value_for_faction_forces(war_faction_name)

		for j = 0, region_list:num_items() - 1 do
			local region_value = region_list:item_at(j):gdp() / 4

			faction_strengths[war_faction_name] = faction_strengths[war_faction_name] + region_value
		end
	end

	for _, value in pairs(faction_strengths) do
		total_potential_points = total_potential_points + value
	end

	local point_target = 0
	local duration

	if target_override then
		point_target = target_override
	else
		local points = total_potential_points

		for _, scaling in ipairs(self.contract_data.scaling_point_modifiers) do
			if points > scaling.bracket then
				local points_in_bracket = points - scaling.bracket

				point_target = point_target + (points_in_bracket * scaling.modifier)
				points = scaling.bracket
			end
		end
	end

	if point_target > self.contract_data.minimum_point_target or target_override ~= nil then
		if duration_override then
			duration = duration_override
		else
			duration = self:generate_duration(point_target)
		end

		if launch then
			local wc = cm:create_war_contract(faction_key, client_key, duration, point_target, self:generate_description(client_key))
			
			if wc:is_null_interface() == false then
				self.available_rewards[faction_key..client_key] = self:generate_rewards(faction_key, client_key, point_target)
			end
		else
			local potential_contract = {faction_key = faction_key, client_key = client_key, duration = duration, point_target = point_target}

			return potential_contract
		end
	end
end

function merc_contracts:generate_description(client_key)
	local faction = cm:get_faction(client_key)
	
	if faction then
		local culture = faction:culture()
		local roll = cm:random_number(self.contract_data.description.count, 1)
		
		return self.contract_data.description.prefix..culture.."_"..roll
	end

	return nil
end

function merc_contracts:generate_duration(points)
	local duration_mod = cm:random_number(self.contract_data.modifiers.duration.max, self.contract_data.modifiers.duration.min)
	local duration = math.floor(points / 75) + duration_mod -- 1 turn per 75 points required

	if duration > self.contract_data.duration.max then
		duration = self.contract_data.duration.max
	end

	if duration < self.contract_data.duration.min then
		duration = self.contract_data.duration.min
	end

	return duration
end

function merc_contracts:generate_rewards(faction_key, client_key, point_target)
	local treasury = self:generate_treasury_reward(point_target)
	local meat = self:generate_meat_reward(point_target)
	local rewards_data = {
		treasury = treasury, 
		meat = meat, 
		effect_bundle = nil, 
		ancillary = nil, 
		banner = nil
	}
	local secondary_reward_roll = cm:random_number(100, 1)
	local secondary_reward_count = 0
	local rewards = {effect_bundles = false, ancillary = false, banner = false}
	local secondary_rewards = self.contract_data.secondary_rewards

	if secondary_reward_roll <= self.contract_data.secondary_reward_chance[2] then
		-- Add 2 rewards
		local rewards_table = table.copy(secondary_rewards)
		local reward_choice = cm:random_number(#rewards_table, 1)

		self:set_reward_types(rewards, rewards_table[reward_choice])

		-- Reroll now that 1 option has been chosen/removed to choose 2nd reward type.
		local reward_choice = cm:random_number(#rewards_table, 1)

		self:set_reward_types(rewards, rewards_table[reward_choice])
	elseif secondary_reward_roll <= self.contract_data.secondary_reward_chance[1] then
		-- Add 1 reward
		local roll = cm:random_number(#secondary_rewards, 1)
		local reward_choice = secondary_rewards[roll]

		self:set_reward_types(rewards, reward_choice)
	end

	if rewards.effect_bundles then
		local bundle_reward = self.contract_data.rewards.effect_bundles
		local roll = cm:random_number(bundle_reward.count, 1)
		local effect_bundle = bundle_reward.prefix..tostring(roll)

		secondary_reward_count = secondary_reward_count + 1
		rewards_data.effect_bundle = effect_bundle
		cm:add_war_contract_payload(faction_key, client_key, "payload{effect_bundle {bundle_key "..effect_bundle..";turns " .. self.default_effect_bundle_reward_duration .. ";}}")
	end

	if rewards.ancillary then
		local ancillary = self:generate_ancillary_reward(client_key)


		if ancillary then
			secondary_reward_count = secondary_reward_count + 1
			rewards_data.ancillary = ancillary
			cm:add_war_contract_payload(faction_key, client_key, "payload{add_ancillary_to_faction_pool{ancillary_key " .. ancillary .. ";}}")
		end
	end

	if rewards.banner then
		local banner = self:generate_banner_reward(client_key)

		if banner then
			secondary_reward_count = secondary_reward_count + 1
			rewards_data.banner = banner
			cm:add_war_contract_payload(faction_key, client_key, "payload{add_ancillary_to_faction_pool{ancillary_key " .. banner .. ";}}")
		end
	end

	if secondary_reward_count > 0  then
		-- lower the treasury reward by 10% per additional reward.
		treasury = treasury * ((10 - secondary_reward_count) / 10)
		rewards_data.treasury = treasury
	end

	cm:add_war_contract_payload(faction_key, client_key, "payload{money "..treasury..";}")
	cm:add_war_contract_payload(faction_key, client_key, "payload{faction_pooled_resource_transaction{resource wh3_dlc26_ogr_meat_hidden;factor war_contracts;amount "..meat..";context absolute;}}")

	return rewards_data
end

function merc_contracts:set_reward_types(reward_table, choice)
	if choice == "effect_bundles" then
		reward_table.effect_bundles = true
	elseif choice == "ancillaries" then
		reward_table.ancillary = true
	elseif choice == "banners" then
		reward_table.banner = true
	end
end

function merc_contracts:generate_treasury_reward(point_target)
	local treasury = point_target * self.contract_data.rewards.treasury
	local treasury_reward_mod = cm:random_number(120, 80) -- We apply a +/- % vairence to rewards

	treasury = (treasury_reward_mod / 100) * treasury

	return treasury
end

function merc_contracts:generate_meat_reward(point_target)
	local meat = self.contract_data.rewards.meat * point_target
	local meat_reward_mod = cm:random_number(120, 80) -- We apply a +/- % vairence to rewards

	meat = (meat_reward_mod / 100) * meat

	return meat
end

function merc_contracts:generate_ancillary_reward(client_key)
	local culture = cm:get_faction(client_key):culture()
	local loot_table = self.contract_data.rewards.ancillaries[culture]
	
	if loot_table then
		local loot_choice = cm:random_number(#loot_table, 1)

		return loot_table[loot_choice]
	else
		return false
	end
end

function merc_contracts:generate_banner_reward(client_key)
	local culture = cm:get_faction(client_key):culture()
	local loot_table = self.contract_data.rewards.banners[culture]

	if loot_table then
		local loot_choice = cm:random_number(#loot_table, 1)

		return loot_table[loot_choice]
	else
		return false
	end
end

function merc_contracts:track_raiding()
	core:add_listener(
		"MercRaidingTracker",
		"FactionTurnStart",
		function(context)
			return self.active_contracts[context:faction():name()]
		end,
		function(context)
			local faction = context:faction()
			local faction_name = faction:name()
			local contract =  self.active_contracts[faction_name]
			local mf_list = faction:military_force_list()

			for i = 0, mf_list:num_items() - 1 do
				local mf = mf_list:item_at(i) 
				local stance = mf:active_stance()

				if mf:has_general() and mf:general_character():has_region() then
					if stance == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID" or stance == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_FIXED_CAMP" then
						for _, target_key in ipairs(contract.targets) do
							local region_owner = mf:general_character():region():owning_faction()

							if region_owner:is_null_interface() == false and region_owner:name() == target_key then
								
								cm:faction_add_pooled_resource(faction_name, self.contract_points.resource, self.contract_points.factors.raiding, self.contract_points.values.raiding)
							end
						end
					end
				end
			end
		end,
		true
	)
end

function merc_contracts:track_agent_actions()
	core:add_listener(
		"MercCharacterAgentAction",
		"CharacterCharacterTargetAction",
		function(context)
			return self.active_contracts[context:character():faction():name()] and (context:mission_result_critial_success() or context:mission_result_success())
		end,
		function (context)
			local faction_name = context:character():faction():name()
			local target = context:target_character():faction():name()

			self:add_agent_war_contract_progress(target, faction_name)
		end,
		true
	)

	core:add_listener(
		"MercRegionAgentAction",
		"CharacterGarrisonTargetAction",
		function(context)
			return self.active_contracts[context:character():faction():name()] and (context:mission_result_critial_success() or context:mission_result_success())
		end,
		function(context)
			local faction_name = context:character():faction():name()
			local target = context:garrison_residence():faction():name()

			self:add_agent_war_contract_progress(target, faction_name)
		end,
		true
	)
end

function merc_contracts:add_agent_war_contract_progress(target, faction_name)
	local contract =  self.active_contracts[faction_name]

	for _, target_key in ipairs(contract.targets) do
		if target_key == target then
			cm:faction_add_pooled_resource(faction_name, self.contract_points.resource, self.contract_points.factors.agent_actions, self.contract_points.values.agent_actions)
		end
	end
end


--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("merc_contracts.active_contracts", merc_contracts.active_contracts, context)
		cm:save_named_value("merc_contracts.siege_settlement_level", merc_contracts.siege_settlement_level, context)
		cm:save_named_value("merc_contracts.track_character_killed", merc_contracts.track_character_killed, context)
		cm:save_named_value("merc_contracts.available_rewards", merc_contracts.available_rewards, context)
		cm:save_named_value("merc_contracts.previous_client_key", merc_contracts.previous_client_key, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			merc_contracts.active_contracts = cm:load_named_value("merc_contracts.active_contracts", merc_contracts.active_contracts, context)
			merc_contracts.siege_settlement_level = cm:load_named_value("merc_contracts.siege_settlement_level", merc_contracts.siege_settlement_level, context)
			merc_contracts.track_character_killed = cm:load_named_value("merc_contracts.track_character_killed", merc_contracts.track_character_killed, context)
			merc_contracts.available_rewards = cm:load_named_value("merc_contracts.available_rewards", merc_contracts.available_rewards, context)
			merc_contracts.previous_client_key = cm:load_named_value("merc_contracts.previous_client_key", merc_contracts.previous_client_key, context)
		end
	end
)