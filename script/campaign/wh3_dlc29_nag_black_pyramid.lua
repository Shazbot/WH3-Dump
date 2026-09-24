black_pyramid = {
	config = {
		faction_key = "wh3_dlc29_nag_host_of_nagash",
		mystic_sigil_effect_key = "wh3_dlc29_effect_initiative_set_point_increase_black_pyramid",
		mystic_sigil_cheat_effect_bundle_key = "wh3_dlc29_black_pyramid_sigils_cheat_bundle",
		sigils_change_per_cheat_usage = 50,
		initiative_set_key = "wh3_dlc29_pyramid_initiative_set",
		
		rush_construction_lock_key = "wh3_main_bundle_vmp_disable_instant_construction",
		rush_construction_initiative = "wh3_dlc29_black_pyramid_nagash_late_13",

		teleport_nodes_initiative = "wh3_dlc29_black_pyramid_nagash_mid_8",
		teleport_nodes = {
			"wh3_dlc29_nagash_rifts_black_pyramid",
			"wh3_dlc29_nagash_rifts_nagashizzar"
		},
		teleport_template = "wh3_dlc29_teleportation_node_template_nagash",

		devastation_ritual = "wh3_dlc29_ritual_nag_devastate_province",

		transported_army = {
			-- prefix. Needs 1/2/3/4 added to the end depending on how many duration nodes are active
			army_prefix = "wh3_dlc29_nag_pyramid_transported_force_",
			nagash_active = "wh3_dlc29_black_pyramid_nagash_transported_army_1",
			arkhan_active = "wh3_dlc29_black_pyramid_arkhan_3",
			duration = {
				["wh3_dlc29_black_pyramid_nagash_transported_army_4"] = true,
				["wh3_dlc29_black_pyramid_nagash_transported_army_5"] = true,
				["wh3_dlc29_black_pyramid_nagash_transported_army_7"] = true
			},
			default_size = 5,
			size_increase = {
				["wh3_dlc29_black_pyramid_nagash_transported_army_2"] = 1,
				["wh3_dlc29_black_pyramid_nagash_transported_army_3"] = 1,
				["wh3_dlc29_black_pyramid_nagash_transported_army_6"] = 2,
				["wh3_dlc29_black_pyramid_nagash_transported_army_8"] = 2
			}
		},

		necropolis_capacity = {
			-- any initiative key that will modify necropolis cap via scripted bonus value
			["wh3_dlc29_black_pyramid_nagash_mid_5"] = true,
			["wh3_dlc29_black_pyramid_nagash_early_5"] = true
		},

		cata_spell = {
			initiative = "wh3_dlc29_black_pyramid_nagash_late_16",
			effect_bundle = "wh3_dlc29_pyramid_nagash_ashes_and_dust",
			duration = 2
		},

		summoned_army = {
			feature_active = "wh3_dlc29_black_pyramid_nagash_shambling_horde_1",
			effect_bundles = {
				core = "wh3_dlc29_bundle_force_nag_summoned_army",
				attrition_immunity = "wh3_dlc29_bundle_force_nag_summoned_army_attrition_immunity",
				base_attrition_immunity_duration = 5
			},
			size = {
				min = 5,
				max = 8
			},
			strength = 1,
			size_increase = {
				min = {
					["wh3_dlc29_black_pyramid_nagash_shambling_horde_2"] = 1,
					["wh3_dlc29_black_pyramid_nagash_shambling_horde_5"] = 1,
					["wh3_dlc29_black_pyramid_nagash_shambling_horde_7"] = 1
				},
				max = {
					["wh3_dlc29_black_pyramid_nagash_shambling_horde_3"] = 1,
					["wh3_dlc29_black_pyramid_nagash_shambling_horde_5"] = 2,
					["wh3_dlc29_black_pyramid_nagash_shambling_horde_7"] = 2
				}
			},
			immunity_increase = {
				["wh3_dlc29_black_pyramid_nagash_shambling_horde_6"] = 1,
				["wh3_dlc29_black_pyramid_nagash_shambling_horde_8"] = 1
			},
			default_lord = "wh3_dlc29_vmp_master_necromancer_undeath_spawned_army",
			lord_upgrade = {initiative = "wh3_dlc29_black_pyramid_nagash_shambling_horde_4", lord = "wh_dlc04_vmp_strigoi_ghoul_king_spawned_army"}
		},
		black_pyramid_panel_lock_shared_state_key = "black_pyramid_panel_locked"
	},
	gravecall = {
		tooltip_prefix = "nagash_gravecall_lock_tooltip_",
		recruitment_sources = {
			tmb = "wh3_dlc29_nag_raise_dead_tmb_faction_pool",
			cst = "wh3_dlc29_nag_raise_dead_cst_faction_pool",
			vmp = "wh3_dlc29_nag_raise_dead_vmp_faction_pool"
		},
		initiatives = {
			-- The same initiative can unlock units from different cultures, but we need to data split so that we know which cultural merc pool to lock/unlock them from.
			tmb = {
				["wh3_dlc29_black_pyramid_skeleton_2"] = {
					"wh2_dlc09_tmb_inf_skeleton_warriors_0", 
					"wh2_dlc09_tmb_inf_skeleton_spearmen_0", 
					"wh2_dlc09_tmb_inf_skeleton_archers_0",
				},
				["wh3_dlc29_black_pyramid_skeleton_10"] = {
					"wh2_dlc09_tmb_inf_nehekhara_warriors_0", 
				},
				["wh3_dlc29_black_pyramid_beasts_1"] = {
					"wh2_dlc09_tmb_mon_carrion_0", 
				},
				["wh3_dlc29_black_pyramid_archers_1"] = {
					"wh2_dlc09_tmb_cav_skeleton_horsemen_archers_0",
				},
				["wh3_dlc29_black_pyramid_horsemen_1"] = {
					"wh2_dlc09_tmb_cav_skeleton_horsemen_0",
					"wh2_dlc09_tmb_cav_nehekhara_horsemen_0"
				},
				["wh3_dlc29_black_pyramid_guards_4"] = {
					"wh2_dlc09_tmb_inf_tomb_guard_0", 
					"wh2_dlc09_tmb_inf_tomb_guard_1", 
				},
				["wh3_dlc29_black_pyramid_construct_monstrous_1"] = {
					"wh2_dlc09_tmb_mon_tomb_scorpion_0", 
				},
				["wh3_dlc29_black_pyramid_construct_monstrous_7"] = {
					"wh2_dlc09_tmb_mon_sepulchral_stalkers_0", 
				},
				["wh3_dlc29_black_pyramid_construct_monstrous_9"] = {
					"wh2_dlc09_tmb_mon_ushabti_0", 
					"wh2_dlc09_tmb_mon_ushabti_1", 
				},
				["wh3_dlc29_black_pyramid_chariots_1"] = {
					"wh2_dlc09_tmb_veh_skeleton_chariot_0", 
					"wh2_dlc09_tmb_veh_skeleton_archer_chariot_0", 
				},
				["wh3_dlc29_black_pyramid_magic_artillery_1"] = {
					"wh2_dlc09_tmb_art_casket_of_souls_0", 
					"wh2_dlc09_tmb_art_screaming_skull_catapult_0", 
				},
				["wh3_dlc29_black_pyramid_morghasts_1"] = {
					"wh3_dlc29_vmp_mon_morghast_harbingers", 
				},
				["wh3_dlc29_black_pyramid_morghasts_5"] = {
					"wh3_dlc29_vmp_mon_morghast_archai", 
				},
				["wh3_dlc29_black_pyramid_construct_monsters_1"] = {
					"wh2_dlc09_tmb_veh_khemrian_warsphinx_0", 
					"wh2_dlc09_tmb_mon_necrosphinx_0", 
					"wh2_dlc09_tmb_mon_heirotitan_0", 
				},
				["wh3_dlc29_black_pyramid_construct_monsters_9"] = {
					"wh3_dlc29_tmb_mon_khemric_titan", 
				},
				["wh3_dlc29_black_pyramid_missile_artillery_siege_2"] = {
					"wh2_pro06_tmb_mon_bone_giant_0", 
				},
				["wh3_dlc29_black_pyramid_knights_6"] = {
					"wh2_dlc09_tmb_cav_necropolis_knights_0",
					"wh2_dlc09_tmb_cav_necropolis_knights_1", 
				}
			},

			cst = {
				["wh3_dlc29_black_pyramid_zombies_2"] = {
					"wh2_dlc11_cst_inf_zombie_deckhands_mob_0", 
					"wh2_dlc11_cst_inf_zombie_deckhands_mob_1",
					"wh2_dlc11_cst_mon_bloated_corpse_0",
				},
				["wh3_dlc29_black_pyramid_guns_1"] = {
					"wh2_dlc11_cst_inf_zombie_gunnery_mob_0",
					"wh2_dlc11_cst_inf_zombie_gunnery_mob_1", 
					"wh2_dlc11_cst_inf_zombie_gunnery_mob_2", 
					"wh2_dlc11_cst_inf_zombie_gunnery_mob_3", 
				},
				["wh3_dlc29_black_pyramid_zombies_10"] = {
					"wh2_dlc11_cst_mon_animated_hulks_0", 
				},
				["wh3_dlc29_black_pyramid_guns_8"] = {
					"wh2_dlc11_cst_inf_deck_gunners_0", 
				},
				["wh3_dlc29_black_pyramid_deck_droppers_1"] = {
					"wh2_dlc11_cst_cav_deck_droppers_0", 
					"wh2_dlc11_cst_cav_deck_droppers_1", 
					"wh2_dlc11_cst_cav_deck_droppers_2", 
				},
				["wh3_dlc29_black_pyramid_undead_monstrous_4"] = {
					"wh2_dlc11_cst_mon_rotting_prometheans_0", 
					"wh2_dlc11_cst_mon_rotting_prometheans_gunnery_mob_0",
				},
				["wh3_dlc29_black_pyramid_undead_monstrous_5"] = {
					"wh2_dlc11_cst_mon_mournguls_0",
				},
				["wh3_dlc29_black_pyramid_gunpowder_artillery_1"] = {
					"wh2_dlc11_cst_art_mortar", 
					"wh2_dlc11_cst_art_carronade", 
				},
				["wh3_dlc29_black_pyramid_wraith_1"] = {
					"wh2_dlc11_cst_inf_syreens", 
				},
				["wh3_dlc29_black_pyramid_undead_monsters_1"] = {
					"wh2_dlc11_cst_mon_rotting_leviathan_0", 
				},
				["wh3_dlc29_black_pyramid_missile_artillery_siege_1"] = {
					"wh2_dlc11_cst_mon_necrofex_colossus_0", 
				},
				["wh3_dlc29_black_pyramid_vampires_3"] = {
					"wh2_dlc11_cst_inf_depth_guard_0", 
					"wh2_dlc11_cst_inf_depth_guard_1", 
				}
			},
			
			vmp = {
				["wh3_dlc29_black_pyramid_zombies_10"] = {
					"wh_main_vmp_inf_crypt_ghouls", 
				},
				["wh3_dlc29_black_pyramid_skeleton_2"] = {
					"wh_main_vmp_inf_skeleton_warriors_0",
					"wh_main_vmp_inf_skeleton_warriors_1", 
				},
				["wh3_dlc29_black_pyramid_beasts_1"] = {
					"wh_main_vmp_mon_fell_bats", 
				},
				["wh3_dlc29_black_pyramid_beasts_4"] = {
					"wh_main_vmp_mon_dire_wolves",
					"wh3_dlc29_vmp_inf_spirit_host",
				},
				["wh3_dlc29_black_pyramid_horsemen_7"] = {
					"wh_main_vmp_cav_black_knights_0",
					"wh_main_vmp_cav_black_knights_3", 
				},
				["wh3_dlc29_black_pyramid_guards_6"] = {
					"wh_main_vmp_inf_grave_guard_0", 
					"wh_main_vmp_inf_grave_guard_1", 
					"wh3_main_vmp_inf_grave_guard_2", 
				},
				["wh3_dlc29_black_pyramid_undead_monstrous_1"] = {
					"wh_main_vmp_mon_varghulf",
				},
				["wh3_dlc29_black_pyramid_undead_monstrous_5"] = {
					"wh_main_vmp_mon_crypt_horrors", 
					"wh_main_vmp_mon_vargheists",
				},
				["wh3_dlc29_black_pyramid_magic_vehicles_1"] = {
					"wh_dlc04_vmp_veh_corpse_cart_0", 
					"wh_dlc04_vmp_veh_corpse_cart_1", 
					"wh_dlc04_vmp_veh_corpse_cart_2",
					"wh_main_vmp_veh_black_coach"
				},
				["wh3_dlc29_black_pyramid_wraith_1"] = {
					"wh_main_vmp_inf_cairn_wraiths", 
					"wh_main_vmp_cav_hexwraiths",
				},
				["wh3_dlc29_black_pyramid_thrones_1"] = {
					"wh3_dlc29_vmp_veh_coven_throne", 
					"wh_dlc04_vmp_veh_mortis_engine_0", 
				},
				["wh3_dlc29_black_pyramid_undead_monsters_1"] = {
					"wh_main_vmp_mon_terrorgheist",
					"wh3_dlc29_vmp_mon_zombie_dragon"
				},
				["wh3_dlc29_black_pyramid_knights_4"] = {
					"wh3_dlc29_vmp_cav_drakenhof_templars", 
				},
			}
		},
		rituals = {
			["wh3_dlc29_nag_mortarchs_walach"] = {
				"wh3_main_vmp_blood_knights_sword_shield", 
				"wh_dlc02_vmp_cav_blood_knights_0"
			},
			["wh3_dlc29_nag_mortarchs_neferata"] = {
				"wh3_dlc29_vmp_inf_lahmian_handmaidens_death", 
				"wh3_dlc29_vmp_inf_lahmian_handmaidens_shadow"
			},
		},
	},
	necromancy_sigils = {
		state_keys = {
			sigil = "nag_necromancy_sigils",
			value = "nag_necromancy_current_value",
			total = "nag_necromancy_current_target"
		},
		effects = {
			bundle = "wh3_dlc29_necromancy_sigil_gain",
			sigil_effect = "wh3_dlc29_effect_initiative_set_point_increase_black_pyramid",
			scope = "faction_to_faction_own_unseen"
		},
		unit_cap_ritual_prefix = "wh3_dlc29_ritual_nag_unit_capacity_",
		sigils_gained = 0,
		target_growth = 200, -- how much the target grows after each sigil gained this way.
		current_value = 0,
		current_target = 200 -- This default value is the starting target in a new campaign
	}
}


function black_pyramid:initialise()
	if cm:is_new_game() then
		local nagash_faction_interface = cm:get_faction(self.config.faction_key)
		if nagash_faction_interface:is_human() then
			-- Lock Rush Construction feature until initiative is taken
			cm:apply_effect_bundle(self.config.rush_construction_lock_key, self.config.faction_key, 0)
			cm:set_script_state(self.config.black_pyramid_panel_lock_shared_state_key, true)
		end
	end

	core:add_listener(
		"BlackPyramid_CheatListener",
		"ContextTriggerEvent",
		true,
		function(context)
			if not context.string:starts_with("pyramid_cheat") then
				return
			end

			local params = context.string:split(":")
			local cheat = params[2]

			local nagash_faction_interface = cm:get_faction(self.config.faction_key)
			if cheat == "grant_sigils" then
				local current_sigils = self:get_current_mystic_sigil_amount_from_cheat_bundle(nagash_faction_interface)
				cm:remove_effect_bundle(self.config.mystic_sigil_cheat_effect_bundle_key, nagash_faction_interface:name())
				self:apply_mystic_sigil_cheat_bundle(nagash_faction_interface, current_sigils + self.config.sigils_change_per_cheat_usage)
			elseif cheat == "remove_sigils" then
				local current_sigils = self:get_current_mystic_sigil_amount_from_cheat_bundle(nagash_faction_interface)
				cm:remove_effect_bundle(self.config.mystic_sigil_cheat_effect_bundle_key, nagash_faction_interface:name())
				self:apply_mystic_sigil_cheat_bundle(nagash_faction_interface, math.max(0, current_sigils - self.config.sigils_change_per_cheat_usage))
			end
		end,
		true
	)

	core:add_listener(
		"BlackPyramid_FactionInitiativeActivationChangedEvent",
		"FactionInitiativeActivationChangedEvent",
		function(context)
			return context:faction():name() == self.config.faction_key
		end,
		function(context)
			local initiative = context:initiative():record_key()

			-- rush construction
			if initiative == self.config.rush_construction_initiative then
				if context:active() then
					cm:remove_effect_bundle(self.config.rush_construction_lock_key, self.config.faction_key)
				else
					cm:apply_effect_bundle(self.config.rush_construction_lock_key, self.config.faction_key, 0)
				end
			end

			-- Gravecall Locks
			for culture, _ in dpairs(self.gravecall.initiatives) do
				if self.gravecall.initiatives[culture][initiative] then
					if context:active() then
						-- initiative on, unlock unit
						for _, unit in dpairs(self.gravecall.initiatives[culture][initiative]) do
							cm:remove_event_restricted_unit_record_for_faction_and_source(unit, self.config.faction_key, self.gravecall.recruitment_sources[culture])
						end
					else
						-- initiative off, lock unit
						for _, unit in dpairs(self.gravecall.initiatives[culture][initiative]) do
							cm:add_event_restricted_unit_record_for_faction_and_source(unit, self.config.faction_key, self.gravecall.recruitment_sources[culture], self.gravecall.tooltip_prefix..initiative)
						end
					end
				end
			end

			-- Nagash Teleport Nodes
			if initiative == self.config.teleport_nodes_initiative then
				if context:active() then
					for k, node in dpairs(self.config.teleport_nodes) do
						cm:teleportation_network_open_node(node, self.config.teleport_template)
					end
				else
					for k, node in dpairs(self.config.teleport_nodes) do
						cm:teleportation_network_close_node(node)
					end
					
				end
			end
		end,
		true
	)

	core:add_listener(
		"BlackPyramid_FactionInitiativeActivationChangedEvent_Necropolis_Cap",
		"FactionInitiativeActivationChangedEvent",
		function(context)
			return self.config.necropolis_capacity[context:initiative():record_key()]
		end,
		function(context)
			land_of_the_dead:update_necropolis_limit(cm:get_faction(self.config.faction_key))
		end,
		true
	)

	core:add_listener(
		"BlackPyramid_FirstTickAfterNewCampaignStarted_UnitLocks",
		"WorldStartRound",
		function(context)
			if cm:turn_number() == 1 then
				return true
			end
		end,
		function(context)
			for culture, recruit_source in dpairs(self.gravecall.recruitment_sources) do
				for initiative, unit_list in dpairs(self.gravecall.initiatives[culture]) do
					for _, unit in dpairs(unit_list) do
						cm:add_event_restricted_unit_record_for_faction_and_source(unit, self.config.faction_key, recruit_source, self.gravecall.tooltip_prefix..initiative)
					end
				end
			end

			for ritual, unit_list in dpairs(self.gravecall.rituals) do
				for _, unit in dpairs(unit_list) do
					cm:add_event_restricted_unit_record_for_faction_and_source(unit, self.config.faction_key, self.gravecall.recruitment_sources.vmp, self.gravecall.tooltip_prefix..ritual)
				end
			end
		end,
		false
	)

	core:add_listener(
		"BlackPyramid_RitualCompletedEvent_UnitLocks",
		"RitualCompletedEvent",
		function(context)
			return self.gravecall.rituals[context:ritual():ritual_key()]
		end,
		function(context)
			for _, unit in dpairs(self.gravecall.rituals[context:ritual():ritual_key()]) do
				cm:remove_event_restricted_unit_record_for_faction_and_source(unit, self.config.faction_key, self.gravecall.recruitment_sources.vmp)
			end
		end,
		true
	)

	core:add_listener(
		"BlackPyramid_FirstTickAfterNewCampaignStarted_UnitCapSigils",
		"WorldStartRound",
		function(context)
			if cm:turn_number() == 1 then
				return true
			end
		end,
		function(context)
			local faction = cm:get_faction(self.config.faction_key)
			
			cm:set_script_state(faction, self.necromancy_sigils.state_keys.sigil, self.necromancy_sigils.sigils_gained)
			cm:set_script_state(faction, self.necromancy_sigils.state_keys.value, self.necromancy_sigils.current_value)
			cm:set_script_state(faction, self.necromancy_sigils.state_keys.total, self.necromancy_sigils.current_target)
		end,
		false
	)

	core:add_listener(
		"BlackPyramid_RitualCompletedEvent_UnitCapSigils",
		"RitualAboutToStartEvent",
		function(context)
			if string.find(context:ritual():ritual_key(), self.necromancy_sigils.unit_cap_ritual_prefix) then
				return true
			end

			return false
		end,
		function(context)
			local ritual = context:ritual()
			local faction = context:performing_faction()
			
			local ritual_target_expended_resources = ritual:ritual_target():get_target_expended_resources()
			if ritual_target_expended_resources:is_null_interface() == false then
				local ritual_cost = ritual_target_expended_resources:absolute_resource_change("wh3_dlc29_nag_necromantic_energy")
				local current_value = cm:model():shared_states_manager():get_state_as_float_value(faction, self.necromancy_sigils.state_keys.value) or self.necromancy_sigils.current_value
				local current_total = cm:model():shared_states_manager():get_state_as_float_value(faction, self.necromancy_sigils.state_keys.total) or self.necromancy_sigils.current_target
				local current_sigils = cm:model():shared_states_manager():get_state_as_float_value(faction, self.necromancy_sigils.state_keys.sigil) or self.necromancy_sigils.sigils_gained

				current_value = current_value - ritual_cost	-- The ritual cost is negative, so we subtract it to add to the current value.

				if current_value >= current_total then
					current_sigils = current_sigils + 1
					current_value = current_value - current_total
					current_total = current_total + self.necromancy_sigils.target_growth

					cm:set_script_state(faction, self.necromancy_sigils.state_keys.sigil, current_sigils)
					cm:set_script_state(faction, self.necromancy_sigils.state_keys.value, current_value)
					cm:set_script_state(faction, self.necromancy_sigils.state_keys.total, current_total)

					local bundle = cm:create_new_custom_effect_bundle(self.necromancy_sigils.effects.bundle)

					if bundle and not bundle:is_null_interface() then
						bundle:add_effect(self.necromancy_sigils.effects.sigil_effect, self.necromancy_sigils.effects.scope, current_sigils)
						bundle:set_duration(0)

						cm:apply_custom_effect_bundle_to_faction(bundle, faction)
					end
				else
					cm:set_script_state(faction, self.necromancy_sigils.state_keys.value, current_value)
				end
			else
				out.design("FAILED TO FIND RESOURCE COST FOR: "..ritual:ritual_key())
			end
		end,
		true
	)

	core:add_listener(
		"BlackPyramid_RitualCompletedEvent_Devastation",
		"RitualCompletedEvent",
		function(context)
			return self.config.devastation_ritual == context:ritual():ritual_key()
		end,
		function(context)
			local transported_nagash_initiative = self.config.transported_army.nagash_active
			local transported_arkhan_initiative = self.config.transported_army.arkhan_active
			local target_region = context:ritual_target_region()
			local province = target_region:province()
			local faction = cm:get_faction(self.config.faction_key)
			local initiative_set = faction:lookup_faction_initiative_set_by_key(self.config.initiative_set_key)
			local nagash = faction:faction_leader()
			local arkhan = cm:get_most_recently_created_character_of_type(self.config.faction_key, "general", "wh2_dlc09_tmb_arkhan");

			if not target_region or target_region:is_null_interface() then 
				return
			end

			-- Infernal Legion
			if nagash:is_null_interface() == false and nagash:has_military_force() and initiative_set:initiative_status_by_key(transported_nagash_initiative):is_active() then
				local cqi = nagash:military_force():command_queue_index()
				local unit_count = self.config.transported_army.default_size
				local force_record = 1
				
				for initiative, _ in dpairs(self.config.transported_army.duration) do
					if initiative_set:initiative_status_by_key(initiative):is_active() then
						force_record = force_record + 1
					end
				end

				for initiative, size_increase in dpairs(self.config.transported_army.size_increase) do
					if initiative_set:initiative_status_by_key(initiative):is_active() then
						unit_count = unit_count + size_increase
					end
				end

				cm:remove_transported_force_at_military_force(cqi)
				cm:spawn_transported_force_at_military_force(cqi, self.config.transported_army.army_prefix..force_record, unit_count)
			end

			-- Infernal Legion Arkhan
			if arkhan and not arkhan:is_null_interface() and arkhan:has_military_force() and initiative_set:initiative_status_by_key(transported_arkhan_initiative):is_active() then
				local cqi = arkhan:military_force():command_queue_index()
				local unit_count = self.config.transported_army.default_size -- Arkhans transported army is only ever the default size
				local force_record = 1 -- Arkhans transported army is only ever have duration 1

				cm:remove_transported_force_at_military_force(cqi)
				cm:spawn_transported_force_at_military_force(cqi, self.config.transported_army.army_prefix..force_record, unit_count)
			end
			
			-- Shambling Horde
			local shambling_initiative = self.config.summoned_army.feature_active

			if initiative_set:initiative_status_by_key(shambling_initiative):is_active() then
				local active_devastation_forces_incremental = cm:get_saved_value("active_devastation_forces_incremental") or 0
				local size_min = self.config.summoned_army.size.min
				local size_max = self.config.summoned_army.size.max
				local lord_choice = self.config.summoned_army.default_lord
				local attrition_immunity_duration = self.config.summoned_army.effect_bundles.base_attrition_immunity_duration
				local valid_spawn_pos_x, valid_spawn_pos_y = cm:find_valid_spawn_location_for_character_from_settlement(self.config.faction_key, target_region:name(), false, true)

				if valid_spawn_pos_x == -1 or valid_spawn_pos_y == -1 then
					script_error("ERROR: Attempted to spawn Shambling Horde but no valid position found")
					return 
				end

				for initiative, amount in dpairs(self.config.summoned_army.size_increase.min) do
					if initiative_set:initiative_status_by_key(initiative):is_active() then
						size_min = size_min + amount
					end
				end

				for initiative, amount in dpairs(self.config.summoned_army.size_increase.max) do
					if initiative_set:initiative_status_by_key(initiative):is_active() then
						size_max = size_max + amount
					end
				end

				for initiative, amount in dpairs(self.config.summoned_army.immunity_increase) do
					if initiative_set:initiative_status_by_key(initiative):is_active() then
						attrition_immunity_duration = attrition_immunity_duration + amount
					end
				end

				if initiative_set:initiative_status_by_key(self.config.summoned_army.lord_upgrade.initiative):is_active() then
					lord_choice = self.config.summoned_army.lord_upgrade.lord
				end

				local force_size = cm:random_number(size_max, size_min)
				local unit_list = WH_Random_Army_Generator:generate_random_army(
					"nagash_pyramid_devastation_force_" .. active_devastation_forces_incremental, 
					"wh3_dlc29_nag_host_of_nagash", 
					force_size, 
					self.config.summoned_army.strength, 
					true, 
					false
				)
				
				cm:create_force_with_general(
					self.config.faction_key,
					unit_list,
					target_region:name(),
					valid_spawn_pos_x,
					valid_spawn_pos_y,
					"general",
					lord_choice,
					"",
					"",
					"",
					"",
					false,
					function(cqi, created_force_cqi)
						cm:apply_effect_bundle_to_force(self.config.summoned_army.effect_bundles.core, created_force_cqi, 0)
						cm:apply_effect_bundle_to_force(self.config.summoned_army.effect_bundles.attrition_immunity, created_force_cqi, attrition_immunity_duration)

						active_devastation_forces_incremental = active_devastation_forces_incremental + 1

						cm:set_saved_value("active_devastation_forces_incremental", active_devastation_forces_incremental)
					end
				)
			end

			-- Cata Spell
			if initiative_set:initiative_status_by_key(self.config.cata_spell.initiative):is_active() then
				if nagash:is_null_interface() == false and nagash:has_military_force() then
					local cqi = nagash:military_force():command_queue_index()

					cm:apply_effect_bundle_to_force(self.config.cata_spell.effect_bundle, cqi, self.config.cata_spell.duration)
				end
			end
		end,
		true
	)

	core:add_listener(
		"BlackPyramid_EffectsListUpdated",
		"FactionEffectsListUpdatedEvent",
		true,
		function(context)
			local panel_locked_shared_state = cm:model():shared_states_manager():get_state_as_bool_value(self.config.black_pyramid_panel_lock_shared_state_key)
			if panel_locked_shared_state == nil then
				return
			end

			local faction_interface = context:faction()
			if faction_interface:name() ~= self.config.faction_key then
				return
			end

			-- unlock the panel as soon as we get at least 1 sigil to spend
			local points_limit = faction_interface:points_limit_for_faction_initiative_set(self.config.initiative_set_key)
			if points_limit > 0 then
				cm:trigger_incident(self.config.faction_key, "wh3_dlc29_nag_black_pyramid_unlocked", true)
				cm:remove_script_state(self.config.black_pyramid_panel_lock_shared_state_key)
			end
		end,
		true
	)
end

function black_pyramid:get_current_mystic_sigil_amount_from_cheat_bundle(nagash_faction_interface)
	if nagash_faction_interface:has_effect_bundle(self.config.mystic_sigil_cheat_effect_bundle_key) then
		local bundle = nagash_faction_interface:get_effect_bundle(self.config.mystic_sigil_cheat_effect_bundle_key)
		for i = 0, bundle:effects():num_items() - 1 do
			local effect = bundle:effects():item_at(i)
			if effect:key() == self.config.mystic_sigil_effect_key then
				return effect:value()
			end
		end
	end

	return 0
end

function black_pyramid:apply_mystic_sigil_cheat_bundle(nagash_faction_interface, new_sigil_amount)
	local effect_bundle = cm:create_new_custom_effect_bundle(self.config.mystic_sigil_cheat_effect_bundle_key)
	if effect_bundle and not effect_bundle:is_null_interface() then
		local effects = effect_bundle:effects()
		for i = 0, effects:num_items() - 1 do
			local effect = effects:item_at(i)
			if effect:key() == self.config.mystic_sigil_effect_key then
				effect_bundle:set_effect_value(effect, new_sigil_amount)
			end
		end

		effect_bundle:set_duration(0)
		cm:apply_custom_effect_bundle_to_faction(effect_bundle, nagash_faction_interface)
	end
end

function black_pyramid:cheat_add_mystic_sigils(sigil_amount)
	if is_nil(sigil_amount) then
		sigil_amount = self.config.sigils_change_per_cheat_usage
	end

	local nagash_faction_interface = cm:get_faction(self.config.faction_key)
	if not nagash_faction_interface or nagash_faction_interface:is_null_interface() then
		return
	end

	self:apply_mystic_sigil_cheat_bundle(nagash_faction_interface, sigil_amount + self:get_current_mystic_sigil_amount_from_cheat_bundle(nagash_faction_interface))
end