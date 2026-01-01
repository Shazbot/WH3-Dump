sayl_manipulation_config = {
	faction_key = "wh3_dlc27_nor_sayl",
	pooled_resource = "wh3_dlc27_nor_sayl_chaos_god_attention",
	pr_factor = "wh3_dlc27_nor_sayl_chaos_god_attention_manipulations",
	winds_of_magic_force_key = "wh3_main_winds_of_magic",
	winds_of_magic_force_factor = "wh3_main_winds_of_magic_sayl_manipulations",
	winds_of_magic_steal_percent_key = "nor_manipulations_winds_of_magic_steal_percent",
	marauder_unit_set_key = "dlc08_nor_marauders_all",
	garrison_damage_percent = 0.5,
	max_attention_tier = 3,
	attention_thresholds = {
		["level_0"] = {
			value = 0
		},
		["level_1"] = {
			value = 8,
			dilemmas = {
				"wh3_dlc27_sayl_manipulation_attention_1a_kho",
				"wh3_dlc27_sayl_manipulation_attention_1b_kho",
				"wh3_dlc27_sayl_manipulation_attention_1a_nur",
				"wh3_dlc27_sayl_manipulation_attention_1b_nur",
				"wh3_dlc27_sayl_manipulation_attention_1a_tze",
				"wh3_dlc27_sayl_manipulation_attention_1b_tze",
				"wh3_dlc27_sayl_manipulation_attention_1a_sla",
				"wh3_dlc27_sayl_manipulation_attention_1b_sla",
			}
		},
		["level_2"] = {
			value = 16,
			dilemmas = {
				"wh3_dlc27_sayl_manipulation_attention_2a_kho",
				"wh3_dlc27_sayl_manipulation_attention_2a_nur",
				"wh3_dlc27_sayl_manipulation_attention_2a_sla",
				"wh3_dlc27_sayl_manipulation_attention_2a_tze",
				"wh3_dlc27_sayl_manipulation_attention_2b_kho",
				"wh3_dlc27_sayl_manipulation_attention_2b_nur",
				"wh3_dlc27_sayl_manipulation_attention_2b_sla",
				"wh3_dlc27_sayl_manipulation_attention_2b_tze",
			}
		},
		["level_3"] = {
			value = 24,
			dilemmas = {
				"wh3_dlc27_sayl_manipulation_attention_3_kho",
				"wh3_dlc27_sayl_manipulation_attention_3_nur",
				"wh3_dlc27_sayl_manipulation_attention_3_sla",
				"wh3_dlc27_sayl_manipulation_attention_3_tze",
			}
		},
	},
	attention_reset_turn_counter = 8,
	manipulation_daemon_units = {
		"wh3_main_tze_mon_lord_of_change_0",
    	"wh3_main_kho_mon_bloodthirster_0",
    	"wh3_main_sla_mon_keeper_of_secrets_0",
    	"wh3_main_nur_mon_great_unclean_one_0"
	},

	-- Whitelist factions for the war declaration ritual
	manipulation_war_whitelist_targets = {
		["wh2_dlc13_lzd_spirits_of_the_jungle"] = "wh2_dlc13_lzd_defenders_of_the_great_plan",
		["wh3_dlc27_hef_aislinn"] = "wh3_dlc27_hef_aislinn_confederation_owner",
	},

	manipulation_rebel_default_faction = "wh_main_nor_norsca_qb1",
	manipulation_rebel_default_general_subtype = "wh_main_nor_marauder_chieftain",

	manipulation_rebel_faction_subculture_to_rebel_faction = {
		["wh2_dlc09_sc_tmb_tomb_kings"] = "wh2_dlc09_tmb_tombking_qb1",
		["wh2_dlc11_sc_cst_vampire_coast"] = "wh2_dlc11_cst_vampire_coast_qb1",
		["wh2_main_sc_def_dark_elves"] = "wh2_main_def_dark_elves_qb1",
		["wh2_main_sc_hef_high_elves"] = "wh2_main_hef_high_elves_qb1",
		["wh2_main_sc_lzd_lizardmen"] = "wh2_main_lzd_lizardmen_qb1",
		["wh2_main_rogue"] = "wh2_main_rogue_doomseekers_qb1",
		["wh2_main_sc_skv_skaven"] = "wh2_main_skv_skaven_qb1",
		["wh3_dlc23_sc_chd_chaos_dwarfs"] = "wh3_dlc23_chd_chaos_dwarfs_qb1",
		["wh3_main_sc_cth_cathay"] = "wh3_main_cth_cathay_qb1",
		["wh3_main_sc_dae_daemons"] = "wh3_main_dae_daemons_qb1",
		["wh3_main_sc_kho_khorne"] = "wh3_main_kho_khorne_qb1",
		["wh3_main_sc_ksl_kislev"] = "wh3_main_ksl_kislev_qb1",
		["wh3_main_sc_nur_nurgle"] = "wh3_main_nur_nurgle_qb1",
		["wh3_main_sc_ogr_ogre_kingdoms"] = "wh3_main_ogr_ogre_kingdoms_qb1",
		["wh3_main_sc_sla_slaanesh"] = "wh3_main_sla_slaanesh_qb1",
		["wh3_main_sc_tze_tzeentch"] = "wh3_main_tze_tzeentch_qb1",
		["wh_dlc03_sc_bst_beastmen"] = "wh_dlc03_bst_beastmen_qb1",
		["wh_dlc05_sc_wef_wood_elves"] = "wh_dlc05_wef_wood_elves_qb1",
		["wh_main_sc_brt_bretonnia"] = "wh_main_brt_bretonnia_qb1",
		["wh_main_sc_chs_chaos"] = "wh_main_chs_chaos_qb1",
		["wh_main_sc_dwf_dwarfs"] = "wh_main_dwf_dwarfs_qb1",
		["wh_main_sc_emp_empire"] = "wh_main_emp_empire_qb1",
		["wh_main_sc_grn_greenskins"] = "wh_main_grn_greenskins_qb1",
		["wh_dlc08_sc_nor_norsca"] = "wh_main_nor_norsca_qb1",
		["wh_main_sc_vmp_vampire_counts"] = "wh_main_vmp_vampire_counts_qb1",
	},

	manipulation_rebel_faction_culture_to_general_subtype = {
		["wh2_dlc09_tmb_tomb_kings"] = "wh2_dlc09_tmb_tomb_king",
		["wh2_dlc11_cst_vampire_coast"] = "wh2_dlc11_cst_admiral_vampires",
		["wh2_main_def_dark_elves"] = "wh2_main_def_dreadlord",
		["wh2_main_hef_high_elves"] = "wh2_main_hef_prince",
		["wh2_main_lzd_lizardmen"] = "wh2_dlc13_lzd_slann_mage_priest_high",
		["wh2_main_rogue"] = "wh_main_emp_lord",
		["wh2_main_skv_skaven"] = "wh2_main_skv_warlord",
		["wh3_dlc23_chd_chaos_dwarfs"] = "wh3_dlc23_chd_overseer",
		["wh3_main_cth_cathay"] = "wh3_main_cth_lord_magistrate_yin",
		["wh3_main_dae_daemons"] = "wh3_main_kho_herald_of_khorne",
		["wh3_main_kho_khorne"] = "wh3_main_kho_herald_of_khorne",
		["wh3_main_ksl_kislev"] = "wh3_main_ksl_boyar",
		["wh3_main_nur_nurgle"] = "wh3_main_nur_herald_of_nurgle_nurgle",
		["wh3_main_ogr_ogre_kingdoms"] = "wh3_main_ogr_tyrant",
		["wh3_main_sla_slaanesh"] = "wh3_main_sla_herald_of_slaanesh_slaanesh",
		["wh3_main_tze_tzeentch"] = "wh3_main_tze_herald_of_tzeentch_tzeentch",
		["wh_dlc03_bst_beastmen"] = "wh_dlc03_bst_beastlord",
		["wh_dlc05_wef_wood_elves"] = "wh_dlc05_wef_glade_lord",
		["wh_dlc08_nor_norsca"] = "wh_main_chs_lord",
		["wh_main_brt_bretonnia"] = "wh_main_brt_lord",
		["wh_main_chs_chaos"] = "wh_main_chs_lord",
		["wh_main_dwf_dwarfs"] = "wh_main_dwf_lord",
		["wh_main_emp_empire"] = "wh_main_emp_lord",
		["wh_main_grn_greenskins"] = "wh_main_grn_orc_warboss",
		["wh_main_vmp_vampire_counts"] = "wh_main_vmp_lord",
	},

	manipulation_rebel_general_subtypes = {
		"wh3_dlc27_nor_great_shaman_sorcerer_death",
		"wh3_dlc27_nor_great_shaman_sorcerer_fire",
		"wh3_dlc27_nor_great_shaman_sorcerer_metal"
	},
	manipulation_rebel_general_level = 40,
	manipulation_rebel_army_lifespan = 10,
	manipulation_rebel_effect_bundles = {
		"wh_main_bundle_military_upkeep_free_force",
		"wh2_dlc16_bundle_military_upkeep_free_force_immune_to_regionless_attrition",
		"wh3_dlc27_sayl_manipulations_rebels_army_destroy",
		"wh2_dlc11_bundle_immune_all_attrition"
	},
	manipulation_rebel_units_percentage = 0.5,
	manipulation_rebel_min_convalescence_time = 2,
	manipulation_spoils_base_amount = 100,
	
	-- Diplomacy lock turns per ritual
	diplomacy_lock_turns_by_ritual = {
	    wh3_dlc27_sayl_manipulations_faction_treaties = 2, -- 2 turns
	    wh3_dlc27_sayl_manipulations_faction_war      = 5, -- 5 turns
	},

	-- Ancillaries that can be granted by the Region Spoils ritual.
	region_spoils_ancillaries = {
		"wh2_main_anc_weapon_executioners_axe",
		"wh_main_anc_weapon_obsidian_blade",
		"wh_main_anc_arcane_item_book_of_ashur",
		"wh_main_anc_armour_armour_of_destiny",
		"wh_main_anc_armour_tricksters_helm",
		"wh_dlc08_anc_enchanted_item_vial_of_troll_blood",
		"wh_main_anc_enchanted_item_the_other_tricksters_shard",
		"wh_main_anc_talisman_talisman_of_preservation",
		"wh_dlc08_anc_weapon_flaming_axe_of_cormac",
	},

	-- When the self-force ritual spawns a transport army, give that new army one random ability-enabling effect bundle from this list, for the duration below.
	self_force_ability_bundles = {
		"wh3_dlc27_sayl_manipulations_self_force_shaman_death",
		"wh3_dlc27_sayl_manipulations_self_force_shaman_fire",
		"wh3_dlc27_sayl_manipulations_self_force_shaman_metal",
	},
 
	-- How many turns the ability bundle should last on the spawned army
	self_force_ability_duration = 5,

	-- How many breaches to set when the garrison ritual hits a region
	garrison_wall_breaches = 10,

	scripted_rituals = {
		["wh3_dlc27_sayl_manipulations_force_rebel"] = {
			callback = function(context)
				local config = sayl_manipulation_config
				local military_force = context:ritual_target_force()
				local units_list = military_force:unit_list()
				local rebel_units = {}
				for i = 0, units_list:num_items() - 1 do
					local unit = units_list:item_at(i)
					if unit:unit_caste() ~= "hero" and unit:unit_caste() ~= "lord" then
						table.insert(rebel_units, { key = unit:unit_key(), cqi = unit:command_queue_index() })
					else
						local char = cm:get_character_by_cqi(unit:command_queue_index())
						if char then 
							local convalescence_time = math.max(config.manipulation_rebel_min_convalescence_time, char:compute_convalesence_time());
							cm:wound_character(cm:char_lookup_str(char:command_queue_index()), convalescence_time);
						end
					end 
				end
				local total_rebel_units = math.round(#rebel_units * sayl_manipulation_config.manipulation_rebel_units_percentage)
				if total_rebel_units == 0 then
					return
				end

				local unit_list_string = ""
				for _, v in ipairs(rebel_units) do
					unit_list_string = unit_list_string .. v.key .. ","
				end

				local general = military_force:general_character()
				local general_faction = general:faction()
				local faction_subculture = general_faction:subculture()

				local rebel_faction = config.manipulation_rebel_faction_subculture_to_rebel_faction[faction_subculture]
						or config.manipulation_rebel_default_faction

				local new_faction_object = cm:get_faction(rebel_faction)

				local x,y = cm:find_valid_spawn_location_for_character_from_character(general_faction:name(), cm:char_lookup_str(general:command_queue_index()), true, 4)

				if new_faction_object:is_dead() then
					cm:awaken_faction_from_death(new_faction_object)
				end

				cm:force_declare_war(rebel_faction, general_faction:name(), false, false)

				cm:kill_character(cm:char_lookup_str(general:command_queue_index()), true)
				local invasion_key = "force_" .. military_force:command_queue_index() .. "_manipulated"
				local invasion_object = invasion_manager:new_invasion(invasion_key, rebel_faction, unit_list_string, {x,y})

				-- add max level shaman as general
				local general_subtype = config.manipulation_rebel_general_subtypes[cm:random_number(#config.manipulation_rebel_general_subtypes)]
				invasion_object:create_general(false, general_subtype)
				invasion_object:add_character_experience(config.manipulation_rebel_general_level, true)

				-- we don't want the army to try and recruit and maintain itself
				invasion_object.maintain_army = false
				-- we don't want it to respawn after death
				invasion_object.respawn = false
				-- we want the army to try and chase other armies it meets on the way
				invasion_object:add_aggro_radius(15)
				for i = 1, #config.manipulation_rebel_effect_bundles do
					invasion_object:apply_effect(config.manipulation_rebel_effect_bundles[i], -1)
				end

				local success = sayl_manipulation:choose_target_for_manipulated_army(invasion_object, military_force, general_faction)

				invasion_object:start_invasion(
					nil,	-- callback function
					false, 	-- declare_war
					false, 	-- invite_attacker_allies
					false,	-- invite_defender_allies
					false	-- allow_diplomatic_discovery
				)
			end
		},
		["wh3_dlc27_sayl_manipulations_faction_treaties"] = {
			callback = function(context)
				local faction = context:ritual_target_faction()
				local faction_key = faction:name()
				local lower_reliability = false

				local faction_list = faction:factions_non_aggression_pact_with()
				for i = 0, faction_list:num_items() - 1 do
					local other_faction = faction_list:item_at(i)
					cm:force_break_non_aggression_pact(faction_key, other_faction:name(), not lower_reliability)
				end
				faction_list = faction:factions_military_access_pact_with()
				for i = 0, faction_list:num_items() - 1 do
					local other_faction = faction_list:item_at(i)
					cm:force_break_military_access(faction_key, other_faction:name(), not lower_reliability, false)
				end
				faction_list = faction:factions_allied_with()
				for i = 0, faction_list:num_items() - 1 do
					local other_faction = faction_list:item_at(i)
					cm:force_break_alliance(faction_key, other_faction:name())
				end
				faction_list = faction:factions_trading_with()
				for i = 0, faction_list:num_items() - 1 do
					local other_faction = faction_list:item_at(i)
					cm:force_break_trade_agreement(faction_key, other_faction:name())
				end
			

-- Lock diplomacy after treaties ritual
local turns = sayl_manipulation_config.diplomacy_lock_turns_by_ritual["wh3_dlc27_sayl_manipulations_faction_treaties"] or 2
sayl_manipulation:lock_faction_diplomacy(faction_key, turns)
end
		},
		["wh3_dlc27_sayl_manipulations_faction_war"] = {
			callback = function(context)
				local faction = context:ritual_target_faction()
				for i = 0, faction:factions_met():num_items() - 1 do
					local known_faction = faction:factions_met():item_at(i)
					local faction_whitelisted = sayl_manipulation.config.manipulation_war_whitelist_targets[faction:name()] == known_faction:name()
					if not known_faction:is_human() and not faction_whitelisted then
						cm:force_declare_war(faction:name(), known_faction:name(), false, false)
					end
				end
			

-- Lock diplomacy after war ritual
local target_key = faction:name()
local turns = sayl_manipulation_config.diplomacy_lock_turns_by_ritual["wh3_dlc27_sayl_manipulations_faction_war"] or 5
sayl_manipulation:lock_faction_diplomacy(target_key, turns)
end
		},
		["wh3_dlc27_sayl_manipulations_self_daemon"] = {
			callback = function(context)
				-- Step 1: determine weakest unit
				-- this is a self target ritual so the target should be Sayl's own force
				local target_force = context:ritual_target_force()
				-- check the context is valid and the army isn't just Sayl himself
				if is_nil(target_force) or target_force:is_null_interface() or target_force:unit_list():num_items() == 1 then
					return
				end

				local unit_list = target_force:unit_list()
				local weakest_index = nil
				local total_weakest_cp = nil
				for i = 1, unit_list:num_items() - 1 do
					local unit = unit_list:item_at(i)
					-- this only applies to marauder units
					if unit:is_unit_in_set(sayl_manipulation_config.marauder_unit_set_key) then
						local current_missile_cp = unit:unit_record_missile_cp()
						local current_melee_cp = unit:unit_record_melee_cp()
						local current_total_cp = current_missile_cp + current_melee_cp
						if not total_weakest_cp or total_weakest_cp > current_total_cp then
							total_weakest_cp = current_total_cp
							weakest_index = i
						end
					end
				end

				-- this ritual has a military force target criteria that requires a marauder unit to exist in the force ensuring this index is valid
				cm:remove_unit_by_cqi(unit_list:item_at(weakest_index):command_queue_index())

				-- Step 2: add greater daemon to Sayl's army
				local random_daemon_unit_index = cm:random_number(#sayl_manipulation_config.manipulation_daemon_units)
				local random_daemon = sayl_manipulation_config.manipulation_daemon_units[random_daemon_unit_index]
				cm:grant_unit_to_character(cm:char_lookup_str(target_force:general_character()), random_daemon)
			end
		},
		["wh3_dlc27_sayl_manipulations_self_magic"] = {
			callback = function(context)
				-- The target army is a force belonging to the caster (Sayl)
				local target_force = context:ritual_target_force()
				if target_force:has_general() == false then
					return
				end

				local general = target_force:general_character()
				if general:has_region() == false then
					return
				end

				local region = general:region()
				if is_nil(region) or region:is_null_interface() then
					return
				end

				-- The effect is supposed to steal WoM from all other armies in the province
				local province = region:province()
				local regions_in_province = province:regions();
				local target_faction = target_force:faction()

				-- value is percentage -> needs to be divided by 100
				local winds_of_magic_steal_percent = cm:campaign_var_int_value(sayl_manipulation_config.winds_of_magic_steal_percent_key) / 100

				for i = 0, regions_in_province:num_items() - 1 do
					local current_region = regions_in_province:item_at(i)
					local characters_in_region = current_region:characters_in_region()
					for j = 0, characters_in_region:num_items() - 1 do
						local current_character = characters_in_region:item_at(j)
						if current_character:faction() ~= target_faction and current_character:has_military_force() and not current_character:military_force():is_armed_citizenry() then
							local current_force = current_character:military_force()
							local winds_of_magic_resource = current_force:pooled_resource_manager():resource(sayl_manipulation_config.winds_of_magic_force_key)
							if is_nil(winds_of_magic_resource) == false and not winds_of_magic_resource:is_null_interface() then
								local total_winds_of_magic_amount = winds_of_magic_resource:value()
								local steal_amount = total_winds_of_magic_amount * winds_of_magic_steal_percent
								cm:entity_transfer_pooled_resource(
									current_force, sayl_manipulation_config.winds_of_magic_force_factor, -- from
									target_force, sayl_manipulation_config.winds_of_magic_force_factor, -- to
									steal_amount) -- amount
							end
						end
					end
				end
			end
		},
		["wh3_dlc27_sayl_manipulations_self_force"] = {
		  callback = function(context)
			local target_force = context:ritual_target_force()
			if is_nil(target_force) or target_force:is_null_interface() then
			  return
			end
 
			cm:spawn_transported_force_at_military_force(
			  target_force:command_queue_index(),
			  "wh3_dlc27_sayl_manipulations_self_force",
			  0
			)
 
			-- give the TARGETED army one random ability bundle for N turns
			sayl_manipulation:apply_random_self_force_ability_to_force(
			  target_force,
			  sayl_manipulation_config.self_force_ability_duration
			)
		  end
		},
		["wh3_dlc27_sayl_manipulations_region_spoils"] = {
			callback = function(context)
				-- Give 1 random ancillary from config.region_spoils_ancillaries to Sayl's faction
				local config = sayl_manipulation_config
				local faction = cm:get_faction(config.faction_key)
				if not faction or faction:is_null_interface() then
					return
				end
 
				local pool = {}
				if config.region_spoils_ancillaries then
					for i = 1, #config.region_spoils_ancillaries do
						table.insert(pool, config.region_spoils_ancillaries[i])
					end
				end
				if #pool == 0 then
					return
				end
 
				local idx = cm:random_number(#pool, 1)
				local anc_key = pool[idx]
 
				sayl_manipulation:_safe_add_ancillary_to_faction(faction, anc_key, false)
			end
		},
		--[[ --archived functionality of having Spoils amount granted scale with target region's gdp income
		["wh3_dlc27_sayl_manipulations_region_spoils"] = {
			callback = function(context)
				-- gain spoils based on region gdp
				local target_region = context:ritual():ritual_target():get_target_region()
				if not target_region:is_null_interface() then
					local region_gdp = target_region:gdp()
					cm:faction_add_pooled_resource(sayl_manipulation_config.faction_key, "wh3_dlc27_nor_spoils", "wh3_dlc27_treacheries",sayl_manipulation_config.manipulation_spoils_base_amount + region_gdp*0.5)
				end
			end
		},
		]]
		["wh3_dlc27_sayl_manipulations_region_garrison"] = {
			callback = function(context)
				local target_region = context:ritual_target_region()
				if is_nil(target_region) or target_region:is_null_interface() then
					return
				end
 
				-- damage garrison army
				local garrison_residence = target_region:garrison_residence()
				cm:sabotage_garrison_army(
					garrison_residence,
					sayl_manipulation_config.garrison_damage_percent
				)
 
				-- damage walls (configurable number of breaches)
				local settlement = target_region:settlement()
				if settlement
					and not settlement:is_null_interface()
					and settlement:is_walled_settlement()
				then
					local desired = math.max(0, math.floor(sayl_manipulation_config.garrison_wall_breaches or 2))
					local current = settlement:number_of_wall_breaches()
					if desired > current then
						cm:set_settlement_wall_health(settlement, desired)
					end
				end
			end
		},
	},
	ritual_unlock_levels = {
		["tier_0"] = {
			rituals = {
				"wh3_dlc27_sayl_manipulations_faction_vision",
				"wh3_dlc27_sayl_manipulations_force_bundle",
				"wh3_dlc27_sayl_manipulations_region_spoils",
				"wh3_dlc27_sayl_manipulations_self_magic",
			},
			min_cost = 1,
			max_cost = 3,
			ai_region_count = 0,
		},
		["tier_1"] = {
			rituals = {
				"wh3_dlc27_sayl_manipulations_faction_recruitment",
				"wh3_dlc27_sayl_manipulations_force_movement",
				"wh3_dlc27_sayl_manipulations_region_foreign",
				"wh3_dlc27_sayl_manipulations_self_recruit",
			},
			min_cost = 2,
			max_cost = 4,
			ai_region_count = 12,
		},
		["tier_2"] = {
			rituals = {
				"wh3_dlc27_sayl_manipulations_faction_treaties",
				"wh3_dlc27_sayl_manipulations_force_damage",
				"wh3_dlc27_sayl_manipulations_region_garrison",
				"wh3_dlc27_sayl_manipulations_self_daemon",
			},
			min_cost = 3,
			max_cost = 5,
			ai_region_count = 25,
		},
		["tier_3"] = {
			rituals = {
				"wh3_dlc27_sayl_manipulations_faction_war",
				"wh3_dlc27_sayl_manipulations_force_rebel",
				"wh3_dlc27_sayl_manipulations_region_destroy",
				"wh3_dlc27_sayl_manipulations_self_force",
			},
			min_cost = 8,
			max_cost = 8,
			ai_region_count = 50,
		},
	},


	---------------------------------
	-------- INVASION DATA ----------
	---------------------------------
	invasion_effect_bundles = {
		"wh_main_bundle_military_upkeep_free_force",
		"wh2_dlc16_bundle_military_upkeep_free_force_immune_to_regionless_attrition",
		"wh2_dlc11_bundle_immune_all_attrition"
	},

	m_chaos_force_details = {
		{
			template_key = "wh_dlc08_sc_nor_norsca",
			faction_key = "wh_main_nor_norsca_qb1",
			general_subtype = {
				["level_1"] = "wh_main_nor_marauder_chieftain",
				["level_2"] = "wh_main_nor_marauder_chieftain",
				["level_3"] = "wh_main_nor_marauder_chieftain",
 			},
			subculture = "wh_dlc08_sc_nor_norsca",
			can_raid = true
		},
		{
			template_key = "wh3_main_sc_nur_nurgle",
			faction_key = "wh3_main_nur_nurgle_qb1",
			general_subtype = {
				["level_1"] = "wh_main_nor_marauder_chieftain",
				["level_2"] = "wh3_dlc20_chs_sorcerer_lord_nurgle_mnur",
				["level_3"] = "wh3_main_nur_exalted_great_unclean_one_nurgle",
 			},
			subculture = "wh3_main_sc_nur_nurgle",
			can_raid = true
		},
		{
			template_key = "wh3_main_sc_kho_khorne",
			faction_key = "wh3_main_kho_khorne_qb1",
			general_subtype = {
				["level_1"] = "wh_main_nor_marauder_chieftain",
				["level_2"] = "wh3_dlc20_chs_lord_mkho",
				["level_3"] = "wh3_main_kho_exalted_bloodthirster",
 			},
			subculture = "wh3_main_sc_kho_khorne",
			can_raid = true
		},
		{
			template_key = "wh3_main_sc_tze_tzeentch",
			faction_key = "wh3_main_tze_tzeentch_qb1",
			general_subtype = {
				["level_1"] = "wh_main_nor_marauder_chieftain",
				["level_2"] = "wh3_dlc20_chs_sorcerer_lord_tzeentch_mtze",
				["level_3"] = "wh3_main_tze_exalted_lord_of_change_tzeentch",
 			},
			subculture = "wh3_main_sc_tze_tzeentch",
			can_raid = true
		},
		{
			template_key = "wh3_main_sc_sla_slaanesh",
			faction_key = "wh3_main_sla_slaanesh_qb1",
			general_subtype = {
				["level_1"] = "wh_main_nor_marauder_chieftain",
				["level_2"] = "wh3_dlc20_chs_lord_msla",
				["level_3"] = "wh3_main_sla_exalted_keeper_of_secrets_slaanesh",
 			},
			subculture = "wh3_main_sc_sla_slaanesh",
			can_raid = true
		},
	},

	m_force_difficulty_values = {
		["very_easy"] = {strength_min = 300000, strength_max = 1300000, force_size = {min = 3, max = 7}, force_power = {min = 1, max = 2}, can_be_leader = false},
		["easy"] = {strength_min = 500001, strength_max = 1500000, force_size = {min = 7, max = 10}, force_power = {min = 1, max = 3}, can_be_leader = false},
		["medium"] = {strength_min = 1500001, strength_max = 30000000, force_size = {min = 12, max = 16}, force_power = {min = 4, max = 6}, can_be_leader = false},
		["hard"] = {strength_min = 30000001, strength_max = nil, force_size = {min = 18, max = 20}, force_power = {min = 5, max = 10}, can_be_leader = false}
	},

	dilemma_invasion_data = {

		["wh3_dlc27_sayl_manipulation_attention_1a_kho"] = {
			invasion_choice = {
				[0] = {
					choice_data = {
						subculture = {
							"wh_dlc08_sc_nor_norsca"
						},
						difficulty = "easy",
					},
					callback = function(data, dilemma_key)
						sayl_manipulation:spawn_dilemma_invasion(data, dilemma_key)
					end
				},
				[2] = {
					weighted_payload = true,
					scripted_payloads = {
						payload_1 = {
							chance = 50,
							choice_data = {
								subculture = {
									"wh_dlc08_sc_nor_norsca"
								},
								difficulty = "easy",
								damage_percent = 30
							},
							callback = function(data, dilemma_key)
								local spawned_invasions = sayl_manipulation:spawn_dilemma_invasion(data, dilemma_key)
								-- Damage the spawned force
								for i = 1, #spawned_invasions do
									local force = spawned_invasions[i]:get_force()
									if is_nil(force) or force:is_null_interface() then
										return
									end
									sayl_manipulation:damage_military_force_with_percentage(force, data.damage_percent)
								end
							end,
						},
						payload_2 = {
							chance = 50,
							choice_data = {
								subculture = {
									"wh_dlc08_sc_nor_norsca"
								},
								difficulty = "easy",
								units_to_add = {
									"wh_dlc08_nor_mon_war_mammoth_0",
									"wh3_dlc27_nor_mon_cursd_ettin",
									"wh_dlc08_nor_mon_frost_wyrm_0",
								},
							},
							callback = function(data, dilemma_key)
								local spawned_invasions = sayl_manipulation:spawn_dilemma_invasion(data, dilemma_key)
								-- Remove units at random from the spawned army
								for i = 1, #spawned_invasions do
									local force = spawned_invasions[i]:get_force()
									if is_nil(force) or force:is_null_interface() then
										return
									end
									local unit_list = force:unit_list()
									local unit_count_to_remove = #data.units_to_add
									local unit_list_count = unit_list:num_items() - 1
									local unit_indices = {}
									if unit_count_to_remove > unit_list_count then
										--we'll be removing and adding less if the spawned army is small
										unit_count_to_remove = unit_list_count
									end
									-- Get the random units to remove from the force
									for j = 1, unit_list_count do
										table.insert(unit_indices, unit_list:item_at(j):command_queue_index())
									end
									cm:shuffle_table(unit_indices)
									-- remove the random units and add the new ones
									for j = 1, unit_count_to_remove do
										cm:remove_unit_by_cqi(unit_indices[j])
										cm:grant_unit_to_character(cm:char_lookup_str(force:general_character()), data.units_to_add[j])
									end
								end
							end
						},
					}
				},
			},

		},
		["wh3_dlc27_sayl_manipulation_attention_1b_kho"] = {
			invasion_choice = {
				[0] = {
					choice_data = {
						subculture = {
							"wh_dlc08_sc_nor_norsca"
						},
						difficulty = "easy",
					},
					callback = function(data, dilemma_key)
						sayl_manipulation:spawn_dilemma_invasion(data, dilemma_key)
					end
				},
				[2] = {
					weighted_payload = true,
					scripted_payloads = {
						payload_1 = {
							chance = 75,
							choice_data = {
								subculture = {
									"wh_dlc08_sc_nor_norsca"
								},
								difficulty = "medium",
							},
							callback = function(data, dilemma_key)
								-- Spawn enraged enemy force
								-- enraged = increased difficulty data (medium)
								sayl_manipulation:spawn_dilemma_invasion(data, dilemma_key)
							end,
						},
						payload_2 = {
							chance = 25,
							choice_data = {
								agent_subtype = "wh_main_nor_marauder_chieftain",
								agent_type = "general",
								forename_pool = {
									"names_name_1002972665",
									"names_name_1010314968",
									"names_name_1012073581",
									"names_name_1030628873",
									"names_name_1060172250",
									"names_name_1070488151",
									"names_name_1091358184",
								},
								surname_pool = {
									"names_name_1112219668",
									"names_name_1132597213",
									"names_name_1135613655",
									"names_name_1139556517",
									"names_name_1236336990",
									"names_name_1237200181",
									"names_name_1240989680",
									"names_name_1312696341",
								},
								agent_age = 30
							},
							callback = function(data, dilemma_key)
								-- Gain Marauder Chieftain in recruitment pool
								local surname_index = cm:random_number(#data.surname_pool, 1)
								local surname = data.surname_pool[surname_index]
								local forename_index = cm:random_number(#data.forename_pool, 1)
								local forename = data.forename_pool[forename_index]
								cm:spawn_character_to_pool(sayl_manipulation_config.faction_key, forename, surname, "", "", data.agent_age, true, data.agent_type, data.agent_subtype, false, "")
							end
						},
					}
				},
			},
		},
		["wh3_dlc27_sayl_manipulation_attention_1a_nur"] = {
			invasion_choice = {
				[0] = {
					choice_data = {
						subculture = {
							"wh_dlc08_sc_nor_norsca"
						},
						difficulty = "easy",
					},
					callback = function(data, dilemma_key)
						sayl_manipulation:spawn_dilemma_invasion(data, dilemma_key)
					end
				},
				[1] = {
					choice_data = {
						subculture = {
							"wh_dlc08_sc_nor_norsca"
						},
						difficulty = "easy",
						effect_bundle_key = "wh3_dlc27_sayl_manipulation_attention_1_nur_option2",
						effect_bundle_duration = 5,
						chance_to_spawn = 25
					},
					callback = function(data, dilemma_key)
						cm:apply_effect_bundle(data.effect_bundle_key, sayl_manipulation_config.faction_key, data.effect_bundle_duration)
						if cm:random_number() <= data.chance_to_spawn then -- random number between 1 and 100
							sayl_manipulation:spawn_dilemma_invasion(data, dilemma_key)
						end
					end
				},
				[2] = {
					weighted_payload = true,
					scripted_payloads = {
						payload_1 = {
							chance = 50,
							choice_data = {
								effect_bundle_key = "wh3_dlc27_sayl_manipulation_attention_1a_nur_option3_bad",
								effect_bundle_duration = 5,
							},
							callback = function(data, dilemma_key)
								-- Apply bad effect
								cm:apply_effect_bundle(data.effect_bundle_key, sayl_manipulation_config.faction_key, data.effect_bundle_duration)
							end,
						},
						payload_2 = {
							chance = 50,
							choice_data = {
								effect_bundle_key = "wh3_dlc27_sayl_manipulation_attention_1a_nur_option3_good",
								effect_bundle_duration = 5,
							},
							callback = function(data, dilemma_key)
								-- Apply good effect
								cm:apply_effect_bundle(data.effect_bundle_key, sayl_manipulation_config.faction_key, data.effect_bundle_duration)
							end
						},
					}
				},
			}

		},
		["wh3_dlc27_sayl_manipulation_attention_1b_nur"] = {
			invasion_choice = {
				[0] = {
					choice_data = {
						subculture = {
							"wh_dlc08_sc_nor_norsca"
						},
						difficulty = "easy",
					},
					callback = function(data, dilemma_key)
						sayl_manipulation:spawn_dilemma_invasion(data, dilemma_key)
					end
				},
				[1] = {
					choice_data = {
						subculture = {
							"wh_dlc08_sc_nor_norsca"
						},
						difficulty = "easy",
						effect_bundle_key = "wh3_dlc27_sayl_manipulation_attention_1_nur_option2",
						effect_bundle_duration = 5,
						chance_to_spawn = 25
					},
					callback = function(data, dilemma_key)
						cm:apply_effect_bundle(data.effect_bundle_key, sayl_manipulation_config.faction_key, data.effect_bundle_duration)
						if cm:random_number() <= data.chance_to_spawn then -- random number between 1 and 100
							sayl_manipulation:spawn_dilemma_invasion(data, dilemma_key)
						end
					end
				},
				[2] = {
					choice_data = {
						effect_bundle_key = "wh3_dlc27_sayl_manipulation_attention_1b_nur_option3",
						effect_bundle_duration = 5,
						damage_percentage = 10,
						unit_conversion_set = "dlc08_nor_marauders_all",
						unit_conversion_chance = 10,
						unit_conversion_key = "wh3_main_nur_mon_spawn_of_nurgle_0",
					},
					callback = function(data, dilemma_key)
						cm:apply_effect_bundle(data.effect_bundle_key, sayl_manipulation_config.faction_key, data.effect_bundle_duration)
						-- damage all armies by 10% and apply 10% chance for units to transform into chaos spawn of nurgle
						local faction = cm:get_faction(sayl_manipulation_config.faction_key)
						if is_nil(faction)  or faction:is_null_interface() then
							return
						end
						for i = 0, faction:military_force_list():num_items() - 1 do
							local force = faction:military_force_list():item_at(i)
							if force:unit_list() and not force:is_armed_citizenry() then
								sayl_manipulation:damage_military_force_with_percentage(force, data.damage_percentage)
								if force:has_general() then
									-- Convert to chaos spawns
									local units = force:unit_list()
									local units_to_remove = {}

									for k = 1, units:num_items() - 1 do
										local unit = units:item_at(k)
										if unit:is_unit_in_set(data.unit_conversion_set) and cm:random_number() <= data.unit_conversion_chance then
											table.insert(units_to_remove, unit:command_queue_index())
										end
									end

									for k = 1, #units_to_remove do
										cm:remove_unit_by_cqi(units_to_remove[k])
										cm:grant_unit_to_character(cm:char_lookup_str(force:general_character():command_queue_index()), data.unit_conversion_key)
									end
								end
							end
						end
					end
				},
			}

		},
		["wh3_dlc27_sayl_manipulation_attention_1a_tze"] = {
			invasion_choice = {
				[0] = {
					choice_data = {
						subculture = {
							"wh_dlc08_sc_nor_norsca"
						},
						difficulty = "easy",
					},
					callback = function(data, dilemma_key)
						sayl_manipulation:spawn_dilemma_invasion(data, dilemma_key)
					end
				},
				[1] = {
					weighted_payload = true,
					scripted_payloads = {
						payload_1 = {
							chance = 50,
							choice_data = {
								subculture = {
									"wh_dlc08_sc_nor_norsca"
								},
								difficulty = "medium",
							},
							callback = function(data, dilemma_key)
								-- Summon larger force (medium)
								sayl_manipulation:spawn_dilemma_invasion(data, dilemma_key)
							end,
						},
						payload_2 = {
							chance = 50,
							choice_data = {
							},
							callback = function(data, dilemma_key)
								-- no force
							end
						},
					}
				},
				[2] = {
					weighted_payload = true,
					scripted_payloads = {
						payload_1 = {
							chance = 25,
							choice_data = {
							},
							callback = function(data, dilemma_key)
								-- Wound Sayl
								local faction = cm:get_faction(sayl_manipulation_config.faction_key)
								local sayl_char = faction:faction_leader()
								local convalescence_time = math.max(2, sayl_char:compute_convalesence_time());
								cm:wound_character("character_cqi:"..sayl_char:command_queue_index(), convalescence_time);
							end,
						},
						payload_2 = {
							chance = 75,
							choice_data = {
								effect_bundle_key = "wh3_dlc27_sayl_manipulation_attention_1a_tze_option3",
								effect_bundle_duration = 5,
							},
							callback = function(data, dilemma_key)
								cm:apply_effect_bundle(data.effect_bundle_key, sayl_manipulation_config.faction_key, data.effect_bundle_duration)
							end
						},
					}
				},
			}
		},
		["wh3_dlc27_sayl_manipulation_attention_1b_tze"] = {
			invasion_choice = {
				[0] = {
					choice_data = {
						subculture = {
							"wh_dlc08_sc_nor_norsca"
						},
						difficulty = "easy",
					},
					callback = function(data, dilemma_key)
						sayl_manipulation:spawn_dilemma_invasion(data, dilemma_key)
					end
				},
				[2] = {
					weighted_payload = true,
					scripted_payloads = {
						payload_1 = {
							chance = 25,
							choice_data = {
								shaman_units = {
									"wh3_dlc08_nor_shaman_sorcerer_death",
									"wh3_dlc08_nor_shaman_sorcerer_fire",
									"wh3_dlc08_nor_shaman_sorcerer_metal"
								},
							},
							callback = function(data, dilemma_key)
								-- chance cabal defeated (get shaman)
								local random_shaman_unit_index = cm:random_number(#data.shaman_units)
								local random_shaman = data.shaman_units[random_shaman_unit_index]
								local faction = cm:get_faction(sayl_manipulation_config.faction_key)
								local sayl_char = faction:faction_leader()
								local faction_capital_key = faction:home_region():name()
								local spawn_coord_x, spawn_coord_y
								if sayl_char:is_null_interface() == false and sayl_char:has_military_force() == true and sayl_char:has_region() and sayl_char:is_alive() then
									spawn_coord_x, spawn_coord_y = cm:find_valid_spawn_location_for_character_from_character(faction:name(), cm:char_lookup_str(sayl_char), true)
								else
									spawn_coord_x, spawn_coord_y = cm:find_valid_spawn_location_for_character_from_settlement(faction:name(), faction_capital_key, false, true)
								end
								cm:spawn_agent_at_position(faction, spawn_coord_x, spawn_coord_y, "wizard", random_shaman)
							end,
						},
						payload_2 = {
							chance = 75,
							choice_data = {
								subculture = {
									"wh_dlc08_sc_nor_norsca"
								},
								difficulty = "medium",
							},
							callback = function(data, dilemma_key)
								-- bigger tzeentch army (medium)
								sayl_manipulation:spawn_dilemma_invasion(data, dilemma_key)
							end
						},
					}
				},
			},

		},
		["wh3_dlc27_sayl_manipulation_attention_1a_sla"] = {
			invasion_choice = {
				[0] = {
				choice_data = {
						subculture = {
							"wh_dlc08_sc_nor_norsca"
						},
						difficulty = "easy",
					},
					callback = function(data, dilemma_key)
						sayl_manipulation:spawn_dilemma_invasion(data, dilemma_key)
					end
				},
				[1] = {
					choice_data = {
						subculture = {
							"wh_dlc08_sc_nor_norsca"
						},
						difficulty = "easy",
						effect_bundle_key = "wh3_dlc27_sayl_manipulation_attention_1a_sla_option2",
						effect_bundle_duration = 5,
						chance_to_spawn = 25
					},
					callback = function(data, dilemma_key)
						cm:apply_effect_bundle(data.effect_bundle_key, sayl_manipulation_config.faction_key, data.effect_bundle_duration)
						if cm:random_number() <= data.chance_to_spawn then  -- random number between 1 and 100
							sayl_manipulation:spawn_dilemma_invasion(data, dilemma_key)
						end
					end
				},
				[2] = {
					weighted_payload = true,
					scripted_payloads = {
						payload_1 = {
							chance = 25,
							choice_data = {
								treasury_gained = 5000,
								spoils_gained = 500,
								spoils_faction_key = "wh3_dlc27_nor_spoils",
								spoils_factor_key = "wh3_dlc27_nor_spoils_instant_razing"
							},
							callback = function(data, dilemma_key)
								-- Grant resources
								cm:treasury_mod(sayl_manipulation_config.faction_key, data.treasury_gained)
								cm:faction_add_pooled_resource(sayl_manipulation_config.faction_key, data.spoils_faction_key, data.spoils_factor_key, data.spoils_gained)
							end,
						},
						payload_2 = {
							chance = 75,
							choice_data = {
								subculture = {
									"wh_dlc08_sc_nor_norsca"
								},
								difficulty = "medium",
							},
							callback = function(data, dilemma_key)
								-- Spawn more elite force
								-- more elite force = difficulty is set to medium
								sayl_manipulation:spawn_dilemma_invasion(data, dilemma_key)
							end
						},
					}
				},
			},
		},
		["wh3_dlc27_sayl_manipulation_attention_1b_sla"] = {
			invasion_choice = {
				[0] = {
				choice_data = {
						subculture = {
							"wh_dlc08_sc_nor_norsca"
						},
						difficulty = "easy",
					},
					callback = function(data, dilemma_key)
						sayl_manipulation:spawn_dilemma_invasion(data, dilemma_key)
					end
				},
				[2] = {
					weighted_payload = true,
					scripted_payloads = {
						payload_1 = {
							chance = 50,
							choice_data = {
								effect_bundle_key = "wh3_dlc27_sayl_manipulation_attention_1b_sla_option3",
								effect_bundle_duration = 5,
							},
							callback = function(data, dilemma_key)
								-- Defeat without battle
								cm:apply_effect_bundle(data.effect_bundle_key, sayl_manipulation_config.faction_key, data.effect_bundle_duration)
							end,
						},
						payload_2 = {
							chance = 50,
							choice_data = {
								subculture = {
									"wh_dlc08_sc_nor_norsca"
								},
								difficulty = "medium",
							},
							callback = function(data, dilemma_key)
								-- Spawn stronger force (medium)
								sayl_manipulation:spawn_dilemma_invasion(data, dilemma_key)
							end
						},
					}
				},
			},
		},
		["wh3_dlc27_sayl_manipulation_attention_2a_kho"] = {
			invasion_choice = {
				[0] = {
				choice_data = {
						subculture = {
							"wh3_main_sc_kho_khorne"
						},
						difficulty = "medium",
					},
					callback = function(data, dilemma_key)
						sayl_manipulation:spawn_dilemma_invasion(data, dilemma_key)
					end
				},
				[1] = {
					choice_data = {
						subculture = {
							"wh3_main_sc_kho_khorne"
						},
						difficulty = "medium",
						damage_percentage = 30
					},
					callback = function(data, dilemma_key)
						-- movement disabling done through DB

						-- spawn weakened force
						local spawned_invasions = sayl_manipulation:spawn_dilemma_invasion(data, dilemma_key)
						-- Damage the spawned force
						for i = 1, #spawned_invasions do
							local force = spawned_invasions[i]:get_force()
							if is_nil(force) or force:is_null_interface() then
								return
							end
							sayl_manipulation:damage_military_force_with_percentage(force, data.damage_percentage)
						end
					end,
				},
				[2] = {
					choice_data = {
						damage_percentage = 30,
					},
					callback = function(data, dilemma_key)
						-- Control and Corruption are set up through DB

						-- Damage Garrisons
						local faction = cm:get_faction(sayl_manipulation.config.faction_key)
						if is_nil(faction)  or faction:is_null_interface() then
							return
						end

						local region_list = faction:region_list()
						for i = 0, region_list:num_items() - 1 do
							local region = region_list:item_at(i)
							local garrison = region:garrison_residence()
							cm:sabotage_garrison_army(garrison, data.garrison_damage_percent)
						end
						-- Resident armies are NOT being damaged intentionally
					end
				}
			},
		},
		["wh3_dlc27_sayl_manipulation_attention_2a_nur"] = {
			invasion_choice = {
				[0] = {
				choice_data = {
						subculture = {
							"wh3_main_sc_nur_nurgle"
						},
						difficulty = "medium"
					},
					callback = function(data, dilemma_key)
						sayl_manipulation:spawn_dilemma_invasion(data, dilemma_key)
					end
				},
				[1] = {
					choice_data = {
						-- no data to pass
					},
					callback = function(data, dilemma_key)
						local faction = cm:get_faction(sayl_manipulation.config.faction_key)
						if is_nil(faction)  or faction:is_null_interface() then
							return
						end

						local faction_has_agents, faction_agents = cm:faction_contains_agents(faction, true, true)
						if faction_has_agents then
							local random_index = cm:random_number(#faction_agents)
							cm:kill_character(cm:char_lookup_str(faction_agents[random_index]))
						end
					end
				},
				[2] = {
					choice_data = {
						effect_chance = 50,
						plague_spreader_key = "wh3_main_nur_nurgle_qb1",
						plague_keys = {
							"wh3_dlc25_nur_random_plague_1",
							"wh3_dlc25_nur_random_plague_2",
							"wh3_dlc25_nur_random_plague_3",
							"wh3_dlc25_nur_random_plague_4",
							"wh3_dlc25_nur_random_plague_5",
						}
					},
					callback = function(data, dilemma_key)
						local faction = cm:get_faction(sayl_manipulation.config.faction_key)
						local plague_spreader = cm:get_faction(data.plague_spreader_key)
						if is_nil(faction)  or faction:is_null_interface() then
							return
						end

						if cm:random_number(100) <= data.effect_chance then
							local faction_leader = faction:faction_leader()
							local random_index = cm:random_number(#data.plague_keys)

							if faction_leader and not faction_leader:is_null_interface() then
								if faction_leader:has_military_force() then
									cm:spawn_plague_at_military_force(plague_spreader, faction_leader:military_force(), data.plague_keys[random_index])
								end
							else
								if faction:has_home_region() then
									cm:spawn_plague_at_region(plague_spreader, faction:home_region(), data.plague_keys[random_index])
								end
							end
						end
					end
				}
			},
		},
		["wh3_dlc27_sayl_manipulation_attention_2a_sla"] = {
			invasion_choice = {
				[0] = {
				choice_data = {
						subculture = {
							"wh3_main_sc_sla_slaanesh"
						},
						difficulty = "medium",
					},
					callback = function(data, dilemma_key)
						sayl_manipulation:spawn_dilemma_invasion(data, dilemma_key)
					end
				},
			},
		},
		["wh3_dlc27_sayl_manipulation_attention_2a_tze"] = {
			invasion_choice = {
				[0] = {
					choice_data = {
						subculture = {
							"wh3_main_sc_tze_tzeentch"
						},
						difficulty = "medium",
					},
					callback = function(data, dilemma_key)
						sayl_manipulation:spawn_dilemma_invasion(data, dilemma_key)
					end
				},
				[2] = {
					weighted_payload = true,
					scripted_payloads = {
						payload_1 = {
							chance = 25,
							choice_data = {
								-- no config data
							},
							callback = function(data, dilemma_key)
								local faction = cm:get_faction(sayl_manipulation.config.faction_key)

								if is_nil(faction)  or faction:is_null_interface() then
									return
								end
								cm:wound_character(cm:char_lookup_str(faction:faction_leader():command_queue_index()), cm:campaign_var_int_value("character_convalescence_time_base"))
							end,
						},
						payload_2 = {
							chance = 75,
							choice_data = {
								-- no config data
							},
							callback = function(data, dilemma_key)
								local faction = cm:get_faction(sayl_manipulation.config.faction_key)

								if is_nil(faction)  or faction:is_null_interface() then
									return
								end

								local faction_leader = faction:faction_leader()

								if faction_leader():has_military_force() then
									local prm = faction_leader():military_force():pooled_resource_manager()

									local winds_of_magic_resource = prm:resource(sayl_manipulation.config.winds_of_magic_force_key)
										if is_nil(winds_of_magic_resource) == false and not winds_of_magic_resource:is_null_interface() then
											local total_winds_of_magic_amount = winds_of_magic_resource:value()
											cm:pooled_resource_factor_transaction(prm, "wh3_main_winds_of_magic_chaos_gods_attention", -total_winds_of_magic_amount)
										end
									end
								end
						},
					}
				},
			},
		},
		["wh3_dlc27_sayl_manipulation_attention_2b_kho"] = {
			invasion_choice = {
				[0] = {
					choice_data = {
						subculture = {
							"wh3_main_sc_kho_khorne"
						},
						difficulty = "medium",
					},
					callback = function(data, dilemma_key)
						sayl_manipulation:spawn_dilemma_invasion(data, dilemma_key)
					end
				},
				[1] = {
					weighted_payload = true,
					scripted_payloads = {
						payload_1 = {
							chance = 75,
							choice_data = {
								subculture = {
									"wh3_main_sc_kho_khorne"
								},
								difficulty = "hard",
							},
							callback = function(data, dilemma_key)
								sayl_manipulation:spawn_dilemma_invasion(data, dilemma_key)
							end,
						},
					}
				},
				[2] = {
					choice_data = {
						subculture = {
							"wh3_main_sc_kho_khorne"
						},
						difficulty = "medium",
						min_damage = 20,
						max_damage = 60
					},
					callback = function(data, dilemma_key)
						local faction = cm:get_faction(sayl_manipulation.config.faction_key)

						if is_nil(faction)  or faction:is_null_interface() then
							return
						end

						local spawned_invasions = sayl_manipulation:spawn_dilemma_invasion(data, dilemma_key)
						for i = 1, #spawned_invasions do
							local force = spawned_invasions[i]:get_force()
							if is_nil(force) or force:is_null_interface() then
								return
							end
							sayl_manipulation:damage_military_force_with_percentage(force, data.min_damage, data.max_damage)
						end

						if faction:faction_leader():has_military_force() then
							sayl_manipulation:damage_military_force_with_percentage(faction:faction_leader():military_force(), data.min_damage, data.max_damage)
						end
					end
				}
			},

		},
		["wh3_dlc27_sayl_manipulation_attention_2b_nur"] = {
			invasion_choice = {
				[0] = {
					choice_data = {
						subculture = {
							"wh3_main_sc_nur_nurgle"
						},
						difficulty = "medium",
					},
					callback = function(data, dilemma_key)
						sayl_manipulation:spawn_dilemma_invasion(data, dilemma_key)
					end
				},
				[2] = {
					weighted_payload = true,
					scripted_payloads = {
						payload_1 = {
							chance = 50,
							choice_data = {
								subculture = {
									"wh3_main_sc_nur_nurgle"
								},
								difficulty = "medium",
								damage_percent = 30
							},
							callback = function(data, dilemma_key)
								local spawned_invasions = sayl_manipulation:spawn_dilemma_invasion(data, dilemma_key)
								-- Damage the spawned force
								for i = 1, #spawned_invasions do
									local force = spawned_invasions[i]:get_force()
									if is_nil(force) or force:is_null_interface() then
										return
									end
									sayl_manipulation:damage_military_force_with_percentage(force, data.damage_percent)
								end
							end,
						},
						payload_2 = {
							chance = 50,
							choice_data = {
								subculture = {
									"wh3_main_sc_nur_nurgle"
								},
								difficulty = "medium",
								unit_key_to_add = "wh3_main_nur_mon_spawn_of_nurgle_0",
								unit_count_to_add = 3 -- In the current config, a medium force will never go above 16 units. If this number changes, update the spawn count to add appropriately
							},
							callback = function(data, dilemma_key)
								local spawned_invasions = sayl_manipulation:spawn_dilemma_invasion(data, dilemma_key)
								for i = 1, #spawned_invasions do
									local force = spawned_invasions[i]:get_force()
									if is_nil(force) or force:is_null_interface() then
										return
									end

									for i = 1, data.unit_count_to_add do
										cm:grant_unit_to_character(cm:char_lookup_str(force:general_character()), data.unit_key_to_add)
									end
								end
							end
						},
					}
				},
			},

		},
		["wh3_dlc27_sayl_manipulation_attention_2b_sla"] = {
			invasion_choice = {
				[0] = {
					choice_data = {
						subculture = {
							"wh3_main_sc_sla_slaanesh"
						},
						difficulty = "medium",
					},
					callback = function(data, dilemma_key)
						sayl_manipulation:spawn_dilemma_invasion(data, dilemma_key)
					end
				},
			},

		},
		["wh3_dlc27_sayl_manipulation_attention_2b_tze"] = {
			invasion_choice = {
				[0] = {
					choice_data = {
						subculture = {
							"wh3_main_sc_tze_tzeentch"
						},
						difficulty = "medium",
					},
					callback = function(data, dilemma_key)
						sayl_manipulation:spawn_dilemma_invasion(data, dilemma_key)
					end
				},
			},
		},
		["wh3_dlc27_sayl_manipulation_attention_3_kho"] = {
			invasion_choice = {
				[0] = {
					choice_data = {
						subculture = {
							"wh3_main_sc_kho_khorne"
						},
						difficulty = "hard",
						damage_percentage = 90
					},
					callback = function(data, dilemma_key)
						sayl_manipulation:spawn_dilemma_invasion(data, dilemma_key)
						sayl_manipulation:damage_faction_leader(data.damage_percentage)
					end
				},
				[1] = {
					choice_data = {
						damage_percentage_min = 20,
						damage_precentage_max = 80,
						chance_to_damage = 10,
						min_health_for_building = 5
					},
					callback = function(data, dilemma_key)
						local faction = cm:get_faction(sayl_manipulation.config.faction_key)

						if is_nil(faction)  or faction:is_null_interface() then
							return
						end

						for i = 0, faction:region_list():num_items() - 1 do
							local region = faction:region_list():item_at(i)

							for j = 0, region:slot_list():num_items() - 1 do
								local slot = region:slot_list():item_at(j)
								if slot:has_building() then
									if cm:random_number() <= data.chance_to_damage then
										local health_percent = slot:building():percent_health() - cm:random_number(data.damage_percentage_max, data.damage_percentage_min)
										cm:instant_set_building_health_percent(region:name(), slot:building():name(), math.max(health_percent, data.min_health_for_building)) -- Using math.max to ensure we don't completely destroy buildings
									end
								end
							end
						end
					end
				}
			},

		},
		["wh3_dlc27_sayl_manipulation_attention_3_nur"] = {
			invasion_choice = {
				[0] = {
					choice_data = {
						subculture = {
							"wh3_main_sc_nur_nurgle"
						},
						difficulty = "hard",
						damage_percentage = 90
					},
					callback = function(data, dilemma_key)
						sayl_manipulation:spawn_dilemma_invasion(data, dilemma_key)
						sayl_manipulation:damage_faction_leader(data.damage_percentage)
					end
				},
				[2] = {
					choice_data = {
						-- no data needs passing
					},
					callback = function(data, dilemma_key)
						local faction = cm:get_faction(sayl_manipulation.config.faction_key)

						if is_nil(faction)  or faction:is_null_interface() then
							return
						end

						local region_list = faction:region_list()
						for i = 0, region_list:num_items() - 1 do
							local region = region_list:item_at(i)
							local dev_points = region:development_points()

							if dev_points > 0 then
								cm:remove_development_points_from_region(region:name(), dev_points)
							end
						end
					end
				}
			},

		},
		["wh3_dlc27_sayl_manipulation_attention_3_sla"] = {
			invasion_choice = {
				[0] = {
					choice_data = {
						subculture = {
							"wh3_main_sc_sla_slaanesh"
						},
						difficulty = "hard",
						damage_percentage = 90
					},
					callback = function(data, dilemma_key)
						sayl_manipulation:spawn_dilemma_invasion(data, dilemma_key)
						sayl_manipulation:damage_faction_leader(data.damage_percentage)
					end
				},
				[2] = {
					choice_data = {
						cult_owners = {
							"wh3_dlc27_sla_the_tormentors",
							"wh3_dlc27_sla_masque_of_slaanesh",
							"wh3_main_sla_slaanesh",
						},
						faction_to_cult_mapping = {
							["wh3_dlc27_sla_the_tormentors"] = "wh3_dlc27_slot_set_sla_cult_dechala",
							["wh3_dlc27_sla_masque_of_slaanesh"] = "wh3_main_slot_set_sla_cult",
							["wh3_main_sla_slaanesh"] = "wh3_main_slot_set_sla_cult",
						},
						spawn_chance = 10
					},
					callback = function(data, dilemma_key)
						local faction = cm:get_faction(sayl_manipulation.config.faction_key)

						if is_nil(faction)  or faction:is_null_interface() then
							return
						end

						local valid_cult_factions = {}

						-- check for valid cult owners
						for i = 1, #data.cult_owners do
							local cult_faction = cm:get_faction(data.cult_owners[i])

							if cult_faction and not cult_faction:is_null_interface() then
								if not cult_faction:is_human() and not cult_faction:is_dead() then
									table.insert(valid_cult_factions, cult_faction)
								end
							end
						end

						local region_list = faction:region_list()
						for i = 0, region_list:num_items() - 1 do
							local region = region_list:item_at(i)
							local random_index = cm:random_number(#valid_cult_factions, 1)
							local cult_owner = valid_cult_factions[random_index]

							if i == 0 or cm:random_number() <= data.spawn_chance then
								cm:add_foreign_slot_set_to_region_for_faction(cult_owner:command_queue_index(), region:cqi(), data.faction_to_cult_mapping[cult_owner:name()]);
							end

							cm:trigger_incident_with_targets(cult_owner:command_queue_index(), "wh3_main_incident_cult_created", 0, 0, 0, 0, region:cqi(), region:settlement():cqi());
						end
					end
				}
			},

		},
		["wh3_dlc27_sayl_manipulation_attention_3_tze"] = {
			invasion_choice = {
				[0] = {
					choice_data = {
						subculture = {
							"wh3_main_sc_tze_tzeentch"
						},
						difficulty = "hard",
						damage_percentage = 90
					},
					callback = function(data, dilemma_key)
						sayl_manipulation:spawn_dilemma_invasion(data, dilemma_key)
						sayl_manipulation:damage_faction_leader(data.damage_percentage)
					end
				},
				[1] = {
					choice_data = {
						damage_percentage = 40,
						unit_conversion_set = "dlc08_nor_marauders_all",
						unit_conversion_chance = 20,
						unit_conversion_key = "wh3_main_tze_mon_spawn_of_tzeentch_0",
					},
					callback = function(data, dilemma_key)
						local faction = cm:get_faction(sayl_manipulation.config.faction_key)

						if is_nil(faction)  or faction:is_null_interface() then
							return
						end

						local mf_list = faction:military_force_list()
						for i = 0, mf_list:num_items() - 1 do
							local force = mf_list:item_at(i)
							local general = force:general_character()

							if force:unit_list() and not force:is_armed_citizenry() then
								sayl_manipulation:damage_military_force_with_percentage(force, data.damage_percentage)

								if force:has_general() then
									local units = force:unit_list()
									-- Convert to chaos spawns
									local units_to_remove = {}

									for k = 1, units:num_items() - 1 do
										local unit = units:item_at(k)
										if unit:is_unit_in_set(data.unit_conversion_set) and cm:random_number() <= data.unit_conversion_chance then
											table.insert(units_to_remove, unit:command_queue_index())
										end
									end

									for k = 1, #units_to_remove do
										cm:remove_unit_by_cqi(units_to_remove[k])
										cm:grant_unit_to_character(cm:char_lookup_str(force:general_character():command_queue_index()), data.unit_conversion_key)
									end
								end
							end
						end
					end
				},
			},
		},
	},
}

sayl_manipulation = {}
sayl_manipulation.config = sayl_manipulation_config
sayl_manipulation.dynamic_data = {}


-- Diplomacy lock helpers
function sayl_manipulation:lock_faction_diplomacy(faction_key, turns)
	local world = cm:model():world()
	local fl = world:faction_list()
	for i = 0, fl:num_items() - 1 do
		local other = fl:item_at(i)
		if not other:is_dead() then
			local other_key = other:name()
			if other_key ~= faction_key then
				-- Block all diplomacy in both directions to ensure no treaties can be made with/against the target
				cm:force_diplomacy(faction_key, other_key, "all", false, false, true)
				cm:force_diplomacy(other_key, faction_key, "all", false, false, true)
			end
		end
	end
	local expires_on = cm:turn_number() + math.max(1, turns or 1)
	sayl_manipulation.dynamic_data.diplomacy_locks[faction_key] = expires_on
end

function sayl_manipulation:unlock_faction_diplomacy(faction_key)
	local world = cm:model():world()
	local fl = world:faction_list()
	for i = 0, fl:num_items() - 1 do
		local other = fl:item_at(i)
		if not other:is_dead() then
			local other_key = other:name()
			if other_key ~= faction_key then
				cm:force_diplomacy(faction_key, other_key, "all", true, false, true)
				cm:force_diplomacy(other_key, faction_key, "all", true, false, true)
			end
		end
	end
	sayl_manipulation.dynamic_data.diplomacy_locks[faction_key] = nil
end

function sayl_manipulation:choose_target_for_manipulated_army(invasion_object, manipulated_military_force, original_faction)
	if original_faction:has_home_region() then
		local home_region = original_faction:home_region()
		if home_region and not home_region:is_null_interface() then
			local target_region_key = home_region:name()
			invasion_object:set_target("REGION", target_region_key, original_faction:name())
			return true
		end
	end

	-- no home region, we target the faction leader
	local faction_leader = original_faction:faction_leader()
	if faction_leader
		and (not faction_leader:is_null_interface())
		and faction_leader:is_alive() 
	then
		local target_character_cqi = faction_leader:command_queue_index()
		invasion_object:set_target("CHARACTER", target_character_cqi, original_faction:name())
		return true
	end

	local forces_list = original_faction:military_force_list()

	if forces_list:num_items() > 0 then
		local character_object = forces_list:item_at(0):general_character()
		local target_character_cqi = character_object:command_queue_index()
		invasion_object:set_target("CHARACTER", target_character_cqi, original_faction:name())
		return true
	end

	-- we failed in selecting a target
	invasion_object:set_target("NONE", nil)
	return false
end

function sayl_manipulation:initialise()
	if is_empty_table(sayl_manipulation.dynamic_data) then
		sayl_manipulation.dynamic_data.reset_progress = true
		sayl_manipulation.dynamic_data.current_tier_unlocked = "tier_0"
		sayl_manipulation.dynamic_data.max_attention_ritual_lock = false
		sayl_manipulation.dynamic_data.current_level = 1
		sayl_manipulation.dynamic_data.turn_to_reset_attention = self.config.attention_reset_turn_counter
		sayl_manipulation.dynamic_data.diplomacy_locks = {}
	end


	sayl_manipulation:initialise_shared_states()

	--sayl_manipulation:populate_config_from_cco()
	

	-- Expire diplomacy locks at the start of each faction's turn
	core:add_listener(
		"sayl_diplomacy_lock_expiry",
		"FactionTurnStart",
		function(context) return true end,
		function(context)
			local f = context:faction()
			if f and not f:is_null_interface() then
				local key = f:name()
				local locks = sayl_manipulation.dynamic_data and sayl_manipulation.dynamic_data.diplomacy_locks
				local expires_on = locks and locks[key]
				if expires_on and cm:turn_number() >= expires_on then
					sayl_manipulation:unlock_faction_diplomacy(key)
				end
			end
		end,
		true
	)

	-- listener which handles clicking the toggle animation button in the manipulations panel
	core:add_listener(
		"manipulation_panel_hand_animation_toggle_handler",
		"ContextTriggerEvent",
		function(context)
			return context.string:starts_with("SaylManipulation_ToggleHandAnimation")
		end,
		function(context)
			local faction = cm:get_faction(self.config.faction_key)
			if is_nil(faction) or faction:is_null_interface() then
				return
			end
			local new_state = not cm:model():shared_states_manager():get_state_as_bool_value(faction, "sayl_manipulation_hand_animation_disabled");
			cm:set_script_state(faction, "sayl_manipulation_hand_animation_disabled", new_state)
		end,
		true
	)

	sayl_manipulation:add_ritual_listeners()
	sayl_manipulation:add_pooled_resource_listeners()
	sayl_manipulation:add_dilemma_listeners()
	sayl_manipulation:add_debug_listeners()
end

function sayl_manipulation:populate_config_from_cco()
	-- TODO:
	-- populate attention thresholds through CCO
end

function sayl_manipulation:add_ritual_listeners()
	core:add_listener(
		"manipulatian_ritual_additional_cost",
		"RitualCompletedEvent",
		function(context)
			for level, rituals in dpairs(self.config.ritual_unlock_levels) do
				local ritual_list = self.config.ritual_unlock_levels[level].rituals
				for i = 1, #ritual_list do
					if ritual_list[i] == context:ritual():ritual_key() then
						return true
					end
				end
			end
			return false;
		end,
		function(context)
			for level, rituals in dpairs(self.config.ritual_unlock_levels) do
				local ritual_list = self.config.ritual_unlock_levels[level].rituals
				for i = 1, #ritual_list do
					if ritual_list[i] == context:ritual():ritual_key() then
						if self.config.ritual_unlock_levels[level].max_cost then
							local base_cost = self.config.ritual_unlock_levels[level].min_cost
							local max_cost = self.config.ritual_unlock_levels[level].max_cost
							local ritual_cost = cm:random_number(max_cost, base_cost)

							cm:faction_add_pooled_resource(self.config.faction_key, self.config.pooled_resource, self.config.pr_factor, ritual_cost - base_cost)
						end
					end
				end
			end
		end,
		true
	);

	core:add_listener(
		"manipulatian_ritual_completed",
		"RitualCompletedEvent",
		function(context)
			return self.config.scripted_rituals[context:ritual():ritual_key()];
		end,
		function(context)
			local ritual_key = context:ritual():ritual_key()
			local ritual = self.config.scripted_rituals[ritual_key]
			if ritual.callback and is_function(ritual.callback) then
				ritual.callback(context)
			end
		end,
		true
	);

end

function sayl_manipulation:add_pooled_resource_listeners()
	core:add_listener(
		"sayl_attention_level_threshold_check",
		"PooledResourceChanged",
		function(context)
			return context:resource():key() == self.config.pooled_resource and context:faction():is_human()
		end,
		function(context)
			local pr_value = context:resource():value()
			local current_level = "level_" .. self.dynamic_data.current_level
			if self.config.attention_thresholds[current_level].dilemmas then
				if pr_value > 0 then
					local previous_pr_value = pr_value - context:amount()
					local threshold = self.config.attention_thresholds[current_level].value
					if pr_value >= threshold and previous_pr_value < threshold then
						if self.dynamic_data.current_level >= 3 then
							sayl_manipulation:set_rituals_availability_for_level("all", false)
							sayl_manipulation:trigger_dilemma_for_attention_level(current_level)
							sayl_manipulation.dynamic_data.max_attention_ritual_lock = true
							self.dynamic_data.should_reset = true

						else
							sayl_manipulation:trigger_dilemma_for_attention_level(current_level)
							self.dynamic_data.should_reset = false
						end
					end
				end
			end
		end,
		true
	)

	core:add_listener(
		"sayl_attention_reset",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == self.config.faction_key
		end,
		function(context)
			local pooled_resource = context:faction():pooled_resource_manager():resource(self.config.pooled_resource)
			local pr_value = pooled_resource:value()
			local turn_number = cm:turn_number()
			if turn_number >= self.dynamic_data.turn_to_reset_attention then
				if self.dynamic_data.should_reset then -- If we drop a level
					local new_level = self.dynamic_data.current_level - 1
					if new_level < 1 then
						cm:pooled_resource_factor_transaction(pooled_resource, "wh3_dlc27_nor_sayl_chaos_god_attention_reset", -pooled_resource:value())
						self.dynamic_data.current_level = 1
						sayl_manipulation.dynamic_data.max_attention_ritual_lock = false
						sayl_manipulation:set_rituals_availability_for_level(self.dynamic_data.current_tier_unlocked, true)
					else
						local attention_decrease_factor = 0 - (pr_value - self.config.attention_thresholds["level_" .. new_level].value)
						cm:pooled_resource_factor_transaction(pooled_resource, "wh3_dlc27_nor_sayl_chaos_god_attention_reset", attention_decrease_factor)
						self.dynamic_data.current_level = new_level
					end
				else
					self.dynamic_data.should_reset = true
					local attention_decrease_value = self.config.attention_thresholds["level_" .. self.dynamic_data.current_level - 1].value - pr_value
					cm:pooled_resource_factor_transaction(pooled_resource, "wh3_dlc27_nor_sayl_chaos_god_attention_reset", attention_decrease_value)
				end
				-- In case we failed to update the reset attention turn (mostly likely due to a script error), update it now to a multiple of the turn in the config.
				local reset_cycles_passed = math.floor(turn_number / self.config.attention_reset_turn_counter)
				self.dynamic_data.turn_to_reset_attention = self.config.attention_reset_turn_counter * (reset_cycles_passed + 1)	-- +1 for the upcoming reset cycle.
				cm:set_script_state(cm:get_faction(self.config.faction_key), "sayl_attention_reset_next_turn", sayl_manipulation.dynamic_data.turn_to_reset_attention)
			end
		end,
		true
	)
end

function sayl_manipulation:add_dilemma_listeners()
	core:add_listener(
		"sayl_dilemma_choice_made",
		"DilemmaChoiceMadeEvent",
		function(context)
			local current_level = self.dynamic_data.current_level
			if current_level == 0 then 
				return false
			end
			local dilemmas = self.config.attention_thresholds["level_".. current_level].dilemmas
			for i = 1, #dilemmas do
				if context:dilemma() == dilemmas[i] then
					return true
				end
			end
			return false
		end,
		function(context)
			local choice = context:choice()
			local dilemma = context:dilemma()

			if self.config.dilemma_invasion_data[dilemma] then
				if self.config.dilemma_invasion_data[dilemma].invasion_choice[choice] then
					local scripted_dilemma = self.config.dilemma_invasion_data[dilemma].invasion_choice[choice]
					if scripted_dilemma.weighted_payload then
						local key, payload = self:get_weighted_payload(scripted_dilemma.scripted_payloads)
						if payload.callback and is_function(payload.callback) then
							payload.callback(payload.choice_data, dilemma)
						end
					else
						if scripted_dilemma.callback and is_function(scripted_dilemma.callback) then
							scripted_dilemma.callback(scripted_dilemma.choice_data, dilemma)
						end
					end
				end
			end
			-- Increment attention level only after making dilemma choice since this is the last action per tier
			if self.dynamic_data.current_level < self.config.max_attention_tier then
				self.dynamic_data.current_level = self.dynamic_data.current_level + 1
			else
				self.dynamic_data.current_level = 0
			end
		end,
		true
	)
end

function sayl_manipulation:add_debug_listeners()
	core:add_listener(
		"debug_chance_attention_counter",
		"ContextTriggerEvent",
		function(context)
			return context.string:starts_with("DebugResetAttentionCounterValue")
		end,
		function(context)
			local params = context.string:split(":")
			local turn_counter = tonumber(params[2])
			-- turn_counter of zero is considered to be "reset to default value"
			if turn_counter <= 0 then 
				sayl_manipulation.config.attention_reset_turn_counter = sayl_manipulation_config.attention_reset_turn_counter
			else
				sayl_manipulation.config.attention_reset_turn_counter = turn_counter
			end
		end,
		true
	);
end

function sayl_manipulation:initialise_shared_states()

	local faction = cm:get_faction(self.config.faction_key)
	cm:set_script_state(faction, "sayl_attention_reset_next_turn", sayl_manipulation.dynamic_data.turn_to_reset_attention)

	for level, rituals in dpairs(self.config.ritual_unlock_levels) do
		cm:set_script_state(faction, "max_cost_" .. level, self.config.ritual_unlock_levels[level].max_cost)
	end
end
--------------------------------------------------------------
---------------------------- UTIL ----------------------------
--------------------------------------------------------------

function sayl_manipulation:damage_military_force_with_percentage(force, base_damage, max_damage)
	local unit_list = force:unit_list()
	local damage = 0
	for i = 0, unit_list:num_items() - 1 do
		local unit = unit_list:item_at(i)
		if max_damage then
			damage = cm:random_number(max_damage, base_damage)
		else
			damage = base_damage
		end
		local health_to_set = (unit:percentage_proportion_of_full_strength() - damage) / 100
		cm:set_unit_hp_to_unary_of_maximum(unit, math.min(health_to_set, 1))
	end
end

function sayl_manipulation:damage_faction_leader(damage_percentage)
	local faction = cm:get_faction(sayl_manipulation.config.faction_key)
	if is_nil(faction)  or faction:is_null_interface() then
		return
	end

	local general = faction:faction_leader()
	if general:has_military_force() then
		-- general is always at index 0, not ideal way to access him it does what it's supposed to.
		local unit = general:military_force():unit_list():item_at(0)
		local health_to_set = (unit:percentage_proportion_of_full_strength() - damage_percentage) / 100
		cm:set_unit_hp_to_unary_of_maximum(unit, math.min(health_to_set, 1))
	end
end

function sayl_manipulation:_safe_add_ancillary_to_faction(faction_interface, ancillary_key, suppress_event_feed)
	if not faction_interface or faction_interface:is_null_interface() then return end
	local ok = pcall(function()
		cm:add_ancillary_to_faction(faction_interface, ancillary_key, suppress_event_feed == true)
	end)
	if ok then return end
	pcall(function()
		cm:add_ancillary_to_faction(faction_interface:name(), ancillary_key, suppress_event_feed == true)
	end)
end

-- Apply one random bundle from config.self_force_ability_bundles to a military force for N turns
function sayl_manipulation:apply_random_self_force_ability_to_force(force, turns)
  if not force or force:is_null_interface() then return end
  local pool = sayl_manipulation_config.self_force_ability_bundles
  if not pool or #pool == 0 then return end
 
  local idx = cm:random_number(#pool, 1)
  local bundle_key = pool[idx]
  local duration = turns or (sayl_manipulation_config.self_force_ability_duration or 5)
 
  cm:apply_effect_bundle_to_force(bundle_key, force:command_queue_index(), duration)
end

function sayl_manipulation:get_weighted_payload(scripted_payloads)
	local total_weight = 0

	for _, payload in dpairs(scripted_payloads) do
		total_weight = total_weight + (payload.chance or 0)
	end

	local roll = cm:random_number(total_weight, 0)
	local cumulative = 0

	for key, payload in dpairs(scripted_payloads) do
		cumulative = cumulative + (payload.chance or 0)
		if roll <= cumulative then
			return key, payload
		end
	end
end

function sayl_manipulation:set_rituals_availability_for_level(current_level, set_available)
	if not sayl_manipulation.dynamic_data.max_attention_ritual_lock then
		local faction = cm:get_faction(self.config.faction_key)

		for level, rituals in dpairs(self.config.ritual_unlock_levels) do
			if level <= current_level or current_level == "all" then
				local ritual_list = self.config.ritual_unlock_levels[level].rituals
				for i = 1, #ritual_list do
					if set_available then
						cm:unlock_ritual(faction, ritual_list[i], -1)
					else
						cm:lock_ritual(faction, ritual_list[i])
					end
				end
			end
		end
	end
end

function sayl_manipulation:trigger_dilemma_for_attention_level(current_level)
	local random_dilemma_index = cm:random_number(#self.config.attention_thresholds[current_level].dilemmas)
	cm:trigger_dilemma(self.config.faction_key, self.config.attention_thresholds[current_level].dilemmas[random_dilemma_index])
end

function sayl_manipulation:spawn_dilemma_invasion(invasion_data, dilemma_key)

	out("triggering attention invasion for Sayl" )
	local faction = cm:get_faction(self.config.faction_key)
	local sayl_char = faction:faction_leader()
	local invasion_target
	local x, y

	if not sayl_char:is_wounded() and sayl_char:has_military_force() and sayl_char:has_region() then
		invasion_target = sayl_char
		x, y = cm:find_valid_spawn_location_for_character_from_character(self.config.faction_key,"character_cqi:"..invasion_target:command_queue_index(), false, 30)
	else
		local region_list = faction:region_list()
		local random_index = cm:random_number(region_list:num_items() - 1, 0)
		invasion_target = region_list:item_at(random_index)
		x, y = cm:find_valid_spawn_location_for_character_from_settlement(self.config.faction_key, invasion_target:name(), false, true, 30)
	end

	local spawned_invasions = {}

	for i = 1, #invasion_data.subculture do
		local subculture = invasion_data.subculture[i]
		local force_size = cm:random_number(self.config.m_force_difficulty_values[invasion_data.difficulty].force_size.max, self.config.m_force_difficulty_values[invasion_data.difficulty].force_size.min)
		local force_power = cm:random_number(self.config.m_force_difficulty_values[invasion_data.difficulty].force_power.max, self.config.m_force_difficulty_values[invasion_data.difficulty].force_power.min)
		local generate_as_table, faction_leader = false, false
		local use_thresholds, maintain_strength = true, true
		local coordinates = {x, y}
		local faction_key, template_key, general_subtype = sayl_manipulation:get_chaos_faction_force_details(subculture, false)
		local invasion_key = "attention_dilemma_invasion".. subculture .. dilemma_key .. cm:turn_number()

		local force_list = WH_Random_Army_Generator:generate_random_army(invasion_key, template_key, force_size, force_power, use_thresholds, generate_as_table)
		local invasion = invasion_manager:new_invasion(invasion_key, faction_key, force_list, coordinates)

		local invasion_faction = cm:get_faction(faction_key)
		if invasion_faction:is_dead() then
			cm:awaken_faction_from_death(invasion_faction)
		end

		cm:force_declare_war(faction_key, self.config.faction_key, false, false)

		invasion:create_general(faction_leader, general_subtype)
		if not sayl_char:is_wounded() and sayl_char:has_military_force() and sayl_char:has_region() then
			invasion:set_target("CHARACTER", invasion_target:command_queue_index(), self.config.faction_key)
		else
			invasion:set_target("REGION", invasion_target:name(), self.config.faction_key)
		end

		invasion:add_aggro_radius(25, {self.config.faction_key}, 1)

		for i = 1, #self.config.invasion_effect_bundles do
			invasion:apply_effect(self.config.invasion_effect_bundles[i], -1)
		end

		invasion:start_invasion(true, true, false, false, false)
		table.insert(spawned_invasions, invasion)
	end
	return spawned_invasions
end

--------------------------------------------------------------
----------- Invasion generation ----------------
--------------------------------------------------------------

function sayl_manipulation:get_chaos_faction_force_details(subculture, raiding)
	-- get the details neccisary for spawning forces/battles.
	local m_chaos_force_details = self.config.m_chaos_force_details
	for k, v in dpairs(m_chaos_force_details) do
		if subculture == v.subculture then
			local general_subtype = v.general_subtype["level_" .. self.dynamic_data.current_level]
			local force_template_key = v.template_key
			local faction_key = v.faction_key
			subculture = v.subculture
			return faction_key, force_template_key, general_subtype
		end
	end
--	out.design("Provided faction "..faction_key.." didn't match any chaos force details. Reverting to random force details")
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("ManipulationDynamicData", sayl_manipulation.dynamic_data, context)
	end
)
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			sayl_manipulation.dynamic_data = cm:load_named_value("ManipulationDynamicData", sayl_manipulation.dynamic_data, context)
		end
	end
)