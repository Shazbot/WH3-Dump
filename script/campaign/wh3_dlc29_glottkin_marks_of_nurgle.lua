glottkin_marks_of_nurgle_config = {
	faction_key = "wh3_dlc29_chs_host_of_the_triplets",
	scripted_bundle_marks_cap_key = "wh3_dlc29_glottkin_scripted_marks_cap",
	effect_heroes_marks_set_cap = "wh3_dlc29_effect_glottkin_nurgle_marks_set_heroes_capacity_mod",
	effect_lords_marks_set_cap = "wh3_dlc29_effect_glottkin_nurgle_marks_set_lords_capacity_mod",
	effect_hybrid_marks_set_cap = "wh3_dlc29_effect_glottkin_nurgle_marks_set_hybrid_capacity_mod",
	effect_settlements_marks_set_cap = "wh3_dlc29_effect_glottkin_nurgle_marks_set_settlements_capacity_mod",
	current_marks_equipped_shared_state_value_key = "glottkin_current_amount_of_marks",
	current_marks_purchased_shared_state_value_key = "glottkin_amount_of_purchased_marks",
	maximum_marks_shared_state_value_key = "glottkin_max_amount_of_marks",
	mark_requirements_shared_state_suffix = "_requirement",
	pooled_resource_souls_key = "wh3_dlc20_chs_souls",
	pooled_resource_progression_factor_key = "wh3_dlc29_chs_glottkin_marks_progression",
	maximum_mark_level = 3, -- Level 0 to 3
	bloab = "wh3_dlc29_chs_bloab",
	bloab_lord = "wh3_dlc29_chs_bloab_lord",
	gutrot_spume = "wh3_dlc29_chs_gutrot_spume",
	morbidex = "wh3_dlc29_chs_morbidex",
	morbidex_lord = "wh3_dlc29_chs_morbidex_lord",
	orghotts = "wh3_dlc29_chs_orghotts",
	orghotts_lord = "wh3_dlc29_chs_orghotts_lord",
	occupation_decision = "occupation_decision_occupy",
	is_leveling_up_mark = false, -- flag used to bypass InitiativeActivation event when activating / deactivating initatives during level up of the mark.
	-- If mark data is missing "purchase_cost" then we look at this
	-- key from the "resource_costs" table
	default_purchase_cost = "wh3_dlc29_woc_souls_rituals_500",

	--Technologies effects
	tech_blessing_of_the_marked_key = "wh3_dlc29_chs_nur_glottkin_mark_1",
	tech_ascension_of_the_rot_lord_key = "wh3_dlc29_chs_nur_glottkin_last",
	tech_rotten_relics_key = "wh3_dlc29_chs_nur_glottkin_military_1",

	scripted_value_corruption_per_mark = "wh3_dlc29_glottkin_corruption_per_mark",
	scripted_value_healing_cap_per_mark = "wh3_dlc29_glottkin_healing_cap_per_mark",

	scripted_bundle_blessing_of_the_marked_key = "wh3_dlc29_woc_glottkin_blessings_of_the_marked_scripted",
	scripted_effect_blessing_of_the_marked_key = "wh3_main_effect_corruption_nurgle_characters_good",
	scripted_bundle_rotten_relics_key = "wh3_dlc29_woc_glottkin_rotten_relics_scripted",
	scripted_effect_rotten_relics_key = "wh3_dlc29_scripted_effect_initiative_mark_upgrade_all_nur_healing",

    souls_progression_pooled_resource_key = "wh3_dlc29_glott_souls",

	ui_notification_shared_state_name = "glottkin_marks_of_nurgle_notification",
	ui_notification_mark_shared_state_suffix = "_notification",
	province_mercenary_pool_scripted_capacity_source = "wh3_dlc29_glottkin",
	province_mercenary_pool_scripted_capacity_expiry_source = "wh3_dlc29_glottkin_expiry",
	gifted_unit_event_popup_index = 1975,
	gifted_unit_event_list_only_index = 1976,

	narrative_marked_by_nurgle = {
		mission_key = "wh3_dlc29_woc_glottkin_narrative_marked_by_nurgle",
		override_text = "wh3_dlc29_woc_glottkin_narrative_marked_by_nurgle_objective",
		payload = {
			"text_display dummy_wh3_dlc29woc_glottkin_narrative_marked_by_nurgle",			
			"effect_bundle{bundle_key wh3_dlc29_effect_bundle_woc_mark_of_nugle;turns 5;}"
		},
	},

	add_lowest_xp_unit_rank = 1,
	
	marks = {
		-- Obstreperous Lordship a.k.a "The Daemons Mark"
		["wh3_dlc29_marks_of_nurgle_1"] = {
			-- Data necessary to update the progression of the mark.
			mark_data = {
				target_cqi = 0,
				pooled_resource_key = "wh3_dlc29_glott_mark_progression_1",
				upgrade_description_text = "{{tr:ui_text_replacements_localised_text_wh3_dlc29_marks_of_nurgle_1_upgrade_description}}",
				pooled_resource_factor_key = "wh3_dlc29_chs_glottkin_marks_progression",
				pooled_resource_threshold_key = "wh3_dlc29_glottkin_mark_1_progression",
				mark_initiative_key_prefix = "wh3_dlc29_marks_of_nurgle_1_level_",
				mark_current_level_key = "wh3_dlc29_marks_of_nurgle_1_level_0",
				initiative_set_key = "wh3_dlc29_glottkin_marks_set_lords",
				unit_set_key = "nur_daemonic_all",
				points_for_enemy_killed_in_battle_by_daemonic_unit = 1,
				points_for_recruiting_daemonic_unit = 400,
				progression_loss_percentage = {0.15, 0.30, 0.50, 0.60}, -- Progression loss in percentage per level
				purchased = false,
				--purchase_cost = "wh3_dlc20_initiative_souls_kho_t1", -- key from the "resource_costs" table
			},

			mark_effects = {
				general_subtype = "wh3_dlc29_nur_herald_of_nurgle_nurgle_rotborne_host_army",
				spawned_force_leader_cqi = 0,
				spawned_force_bundle_key = "wh3_dlc29_woc_bundle_glottkin_spawned_army",
				spawned_force_max_unit = {5, 6, 6, 8},
				spawned_force_lifespan = {3, 4, 4, 5},
				spawned_force_units = {
					["wh3_main_nur_inf_nurglings_0"] = 				{5 ,0 ,0 ,0},
					["wh3_main_nur_inf_plaguebearers_0"] = 			{30 ,0 ,0 ,0},
					["wh3_main_nur_mon_rot_flies_0"] = 				{15 ,6 ,0 ,0},
					["wh3_main_nur_mon_plague_toads_0"] = 			{15 ,6 ,0 ,0},
					["wh3_main_nur_mon_beast_of_nurgle_0"] = 		{15 ,15 ,0 ,0},
					["wh3_main_nur_inf_chaos_furies_0"] = 			{10 ,6 ,0 ,0},
					["wh3_main_nur_cav_plague_drones_0"] = 			{5 ,15 ,12 ,0},
					["wh3_main_nur_inf_plaguebearers_1"] = 			{5 ,35 ,36 ,34},
					["wh3_main_nur_cav_pox_riders_of_nurgle_0"] = 	{0 ,15 ,12 ,0},
					["wh3_main_nur_cav_plague_drones_1"] = 			{0 ,0 ,10 ,20},
					["wh3_main_nur_mon_great_unclean_one_0"] = 		{0 ,0 ,15 ,23},
					["wh3_main_nur_mon_soul_grinder_0"] = 			{0 ,2 ,15 ,23},
				},
			},

			requirements_ui_strings = {
				["{{tr:ui_text_replacements_localised_text_wh3_dlc29_marks_of_nurgle_1_upgrade_requirement_1}}"] = 1,
				["{{tr:ui_text_replacements_localised_text_wh3_dlc29_marks_of_nurgle_1_upgrade_requirement_2}}"] = 400,
			},

			remove_mark = function(context, mark_data, remove_progress)
				mark_data.target_cqi = 0
				core:remove_listener("wh3_dlc29_marks_of_nurgle_1_character_completed_battle")
				core:remove_listener("wh3_dlc29_marks_of_nurgle_1_unit_trained")
				core:remove_listener("wh3_dlc29_marks_of_nurgle_1_pooled_resource_threshold")
				core:remove_listener("wh3_dlc29_marks_of_nurgle_1_character_razed_settlement_effects")
				if remove_progress then
					glottkin_marks_of_nurgle:remove_progression_from_mark(mark_data)
				end
			end,

			setup_mark_progression = function(context, mark_data, mark_effects)
				-- PROGRESSION LISTENERS
				core:add_listener(
					"wh3_dlc29_marks_of_nurgle_1_character_completed_battle",
					"CharacterCompletedBattle",
					function(context)
						return context:character():cqi() == mark_data.target_cqi
					end,
					function(context)
						local pb = cm:model():pending_battle()
						local is_attacker = false

						if pb:attacker():faction():name() == glottkin_marks_of_nurgle_config.faction_key or glottkin_marks_of_nurgle:is_glottkin_faction_in_character_list(pb:secondary_attackers()) then
							is_attacker = true
						end

						local character = context:character()

						local military_force = character:military_force()
						if not military_force or military_force:is_null_interface() then
							-- nothing to advance, the character is not in a military force (we should not be here, but just in case)
							return
						end

						local cqi = military_force:command_queue_index()
						local points_for_enemy_killed = 0
						if is_attacker then
							points_for_enemy_killed = pb:units_killed_by_attacker_unit_set(cqi, mark_data.unit_set_key) * mark_data.points_for_enemy_killed_in_battle_by_daemonic_unit
						else
							points_for_enemy_killed = pb:units_killed_by_defender_unit_set(cqi, mark_data.unit_set_key) * mark_data.points_for_enemy_killed_in_battle_by_daemonic_unit
						end

						cm:faction_add_pooled_resource(glottkin_marks_of_nurgle_config.faction_key, mark_data.pooled_resource_key, glottkin_marks_of_nurgle_config.pooled_resource_progression_factor_key, points_for_enemy_killed)
					end,
					true
				)

				core:add_listener(
					"wh3_dlc29_marks_of_nurgle_1_unit_trained",
					"UnitTrained",
					function(context)
						local general = context:unit():military_force():general_character()
						if general:is_null_interface() then 
							return false
						else
							return context:unit():is_unit_in_set(mark_data.unit_set_key) and general:cqi() == mark_data.target_cqi
						end
					end,
					function(context)
						cm:faction_add_pooled_resource(glottkin_marks_of_nurgle_config.faction_key, mark_data.pooled_resource_key, glottkin_marks_of_nurgle_config.pooled_resource_progression_factor_key, mark_data.points_for_recruiting_daemonic_unit)
					end,
					true
				)

				core:add_listener(
					"wh3_dlc29_marks_of_nurgle_1_pooled_resource_threshold",
					"PooledResourceThresholdOperationReached",
					function(context)
						return string.find(context:pooled_threshold_operation_record(), mark_data.pooled_resource_threshold_key)
					end,
					function(context)
						glottkin_marks_of_nurgle:apply_initiative_upgrade(mark_data, context:pooled_threshold_operation_record())
					end,
					true
				)

				-- EFFECTS LISTENER
				core:add_listener(
					"wh3_dlc29_marks_of_nurgle_1_character_razed_settlement_effects",
					"CharacterRazedSettlement",
					function(context)
						local mark_level = glottkin_marks_of_nurgle:get_mark_level_from_string(mark_data.mark_current_level_key)
						local is_mil_force_already_there = cm:get_character_by_cqi(mark_effects.spawned_force_leader_cqi)
						return context:character():command_queue_index() == mark_data.target_cqi and mark_level >= 0 and not is_mil_force_already_there
					end,
					function(context)
						local mark_level = glottkin_marks_of_nurgle:get_mark_level_from_string(mark_data.mark_current_level_key)
						local region_name = context:garrison_residence():region():name()
						local x = context:garrison_residence():settlement_interface():logical_position_x()
						local y = context:garrison_residence():settlement_interface():logical_position_y()
						x, y = cm:find_valid_spawn_location_for_character_from_position(glottkin_marks_of_nurgle_config.faction_key, x, y, true, 2)

						local ram = random_army_manager
						ram:remove_force("glottkin_force");
						ram:new_force("glottkin_force");

						for unit, weight in dpairs(mark_effects.spawned_force_units) do
							ram:add_unit("glottkin_force", unit, weight[mark_level + 1])
						end

						local amount_of_units = mark_effects.spawned_force_max_unit[mark_level + 1]
						local spawn_units = random_army_manager:generate_force("glottkin_force", amount_of_units, false);

						cm:create_force_with_general(
							glottkin_marks_of_nurgle_config.faction_key,
							spawn_units,
							region_name,
							x,
							y,
							"general",
							mark_effects.general_subtype,
							"",
							"",
							"",
							"",
							false,
							function(leader_cqi)
								mark_effects.spawned_force_leader_cqi = leader_cqi 
								local general = cm:get_character_by_cqi(leader_cqi)
								local mf = general:military_force()
								local custom_effect_bundle = cm:create_new_custom_effect_bundle(mark_effects.spawned_force_bundle_key)
								custom_effect_bundle:add_effect("wh3_dlc27_effect_campaign_force_limited_lifespan", "force_to_force_own", mark_effects.spawned_force_lifespan[mark_level + 1])
								cm:apply_custom_effect_bundle_to_force(custom_effect_bundle, mf)
								local char_lookup = cm:char_lookup_str(general)
								cm:replenish_action_points(char_lookup)
							end
						)
					end,
					true
				)
			end,
		},
		-- Miasmal Windfall a.k.a "The Mage Mark"
		["wh3_dlc29_marks_of_nurgle_2"] = {
			-- Data necessary to update the progression of the mark.
			mark_data = {
				target_cqi = 0,
				pooled_resource_key = "wh3_dlc29_glott_mark_progression_2",
				upgrade_description_text = "{{tr:ui_text_replacements_localised_text_wh3_dlc29_marks_of_nurgle_2_upgrade_description}}",
				pooled_resource_threshold_key = "wh3_dlc29_glottkin_mark_2_progression",
				mark_initiative_key_prefix = "wh3_dlc29_marks_of_nurgle_2_level_",
				mark_current_level_key = "wh3_dlc29_marks_of_nurgle_2_level_0",
				initiative_set_key = "wh3_dlc29_glottkin_marks_set_hybrid",
				unit_set_key = "nurgle_characters",
				points_for_units_killed = 1,
				points_for_spell_casted = 100,
				progression_loss_percentage = {0.15, 0.30, 0.50, 0.60}, -- Progression loss in percentage per level
				purchased = false,
				--purchase_cost = "wh3_dlc20_initiative_souls_kho_t1", -- key from the "resource_costs" table
			},

			mark_effects = {
				winds_of_magic_resource_key = "wh3_main_winds_of_magic",
				spells = {
					"wh3_main_spell_nurgle_curse_of_the_leper",
					"wh3_main_spell_nurgle_fleshy_abundance",
					"wh3_main_spell_nurgle_miasma_of_pestilence",
					"wh3_main_spell_nurgle_pestilent_pustule",
					"wh3_main_spell_nurgle_rancid_visitations",
					"wh3_main_spell_nurgle_stream_of_corruption",
					"wh3_main_spell_nurgle_curse_of_the_leper_upgraded",
					"wh3_main_spell_nurgle_fleshy_abundance_upgraded",
					"wh3_main_spell_nurgle_miasma_of_pestilence_upgraded",
					"wh3_main_spell_nurgle_pestilent_pustule_upgraded",
					"wh3_main_spell_nurgle_rancid_visitations_upgraded",
					"wh3_main_spell_nurgle_stream_of_corruption_upgraded",
					"wh_main_spell_death_aspect_of_the_dreadknight",
					"wh_main_spell_death_doom_and_darkness",
					"wh_main_spell_death_soulblight",
					"wh_main_spell_death_spirit_leech",
					"wh_main_spell_death_the_fate_of_bjuna",
					"wh_main_spell_death_the_purple_sun_of_xereus",
					"wh_main_spell_death_aspect_of_the_dreadknight_upgraded",
					"wh_main_spell_death_doom_and_darkness_upgraded",
					"wh_main_spell_death_soulblight_upgraded",
					"wh_main_spell_death_spirit_leech_upgraded",
					"wh_main_spell_death_the_purple_sun_of_xereus_upgraded",
				},
			},

			requirements_ui_strings = {
				["{{tr:ui_text_replacements_localised_text_wh3_dlc29_marks_of_nurgle_2_upgrade_requirement_1}}"] = 100,
				["{{tr:ui_text_replacements_localised_text_wh3_dlc29_marks_of_nurgle_2_upgrade_requirement_2}}"] = 1,
			},

			remove_mark = function(context, mark_data, remove_progress)
				mark_data.target_cqi = 0
				core:remove_listener("wh3_dlc29_marks_of_nurgle_2_character_completed_battle")
				core:remove_listener("wh3_dlc29_marks_of_nurgle_2_hero_completed_battle")
				core:remove_listener("wh3_dlc29_marks_of_nurgle_2_pooled_resource_threshold")
				core:remove_listener("wh3_dlc29_marks_of_nurgle_2_faction_turn_end_effects")
				if remove_progress then
					glottkin_marks_of_nurgle:remove_progression_from_mark(mark_data)
				end
			end,

			setup_mark_progression = function(context, mark_data, mark_effects)
				-- PROGRESSION LISTENERS
				core:add_listener(
					"wh3_dlc29_marks_of_nurgle_2_character_completed_battle",
					"CharacterCompletedBattle",
					function(context)
						return context:character():cqi() == mark_data.target_cqi
					end,
					function(context)
						glottkin_marks_of_nurgle_config.marks["wh3_dlc29_marks_of_nurgle_2"].apply_post_battle_progression(context, mark_data, mark_effects)
					end,
					true
				)
				
				core:add_listener(
					"wh3_dlc29_marks_of_nurgle_2_hero_completed_battle",
					"HeroCharacterParticipatedInBattle",
					function(context)
						return context:character():cqi() == mark_data.target_cqi
					end,
					function(context)
						glottkin_marks_of_nurgle_config.marks["wh3_dlc29_marks_of_nurgle_2"].apply_post_battle_progression(context, mark_data, mark_effects)
					end,
					true
				)

				core:add_listener(
					"wh3_dlc29_marks_of_nurgle_2_pooled_resource_threshold",
					"PooledResourceThresholdOperationReached",
					function(context)
						return string.find(context:pooled_threshold_operation_record(), mark_data.pooled_resource_threshold_key)
					end,
					function(context)
						glottkin_marks_of_nurgle:apply_initiative_upgrade(mark_data, context:pooled_threshold_operation_record())
					end,
					true
				)

				-- EFFECTS LISTENERS
				core:add_listener(
					"wh3_dlc29_marks_of_nurgle_2_faction_turn_end_effects",
					"CharacterTurnEnd", 
					function(context)
						return context:character():cqi() == mark_data.target_cqi
					end,
					function(context)
						local mark_level = glottkin_marks_of_nurgle:get_mark_level_from_string(mark_data.mark_current_level_key)
						local current_region = cm:get_character_by_cqi(mark_data.target_cqi):region()
						local is_at_sea = context:character():is_at_sea()
						local current_province = nil

						if is_at_sea == false then
							current_province = current_region:province():key()
						end

						-- Save the province and its original WoM strength
						if is_at_sea == false then
							local province_data = glottkin_marks_of_nurgle_persistent.provinces_winds_of_magic_changed[current_province]
							if not province_data then
								glottkin_marks_of_nurgle_persistent.provinces_winds_of_magic_changed[current_province] = {
									original_wom_strength = cm:get_winds_of_magic_in_area_for_region(current_region)
								}
							end

							if mark_level == 0 or mark_level == 1 then
								cm:force_winds_of_magic_change(current_province, "wom_strength_3")
							elseif mark_level == 2 then
								cm:force_winds_of_magic_change(current_province, "wom_strength_4")
							elseif mark_level == 3 then
								cm:force_winds_of_magic_change(current_province, "wom_strength_5")
							end
						end

						-- Cleanup any provinces we're not in anymore, and restore their original WoM strength
						for key, value in dpairs(glottkin_marks_of_nurgle_persistent.provinces_winds_of_magic_changed) do
							if current_province == nil or key ~= current_province then
								cm:force_winds_of_magic_change(key, "wom_strength_"..value.original_wom_strength)
								glottkin_marks_of_nurgle_persistent.provinces_winds_of_magic_changed[key] = nil
							end
						end
					end,
					true
				)
			end,

			apply_post_battle_progression = function(context, mark_data, mark_effects)
				local pb = cm:model():pending_battle()
				local is_attacker = false

				if pb:attacker():faction():name() == glottkin_marks_of_nurgle_config.faction_key or glottkin_marks_of_nurgle:is_glottkin_faction_in_character_list(pb:secondary_attackers()) then
					is_attacker = true
				end

				local character = context:character()

				local character = context:character()
				local military_force = character:military_force()
				if not military_force or military_force:is_null_interface() and character:is_embedded_in_military_force() then
					military_force = character:embedded_in_military_force()
					if not military_force or military_force:is_null_interface() then
						return
					end
				end

				local cqi = military_force:command_queue_index()
				local points_to_award = 0
				if is_attacker then
					points_to_award = pb:units_killed_by_attacker_character(cqi, mark_data.target_cqi) * mark_data.points_for_units_killed
				else
					points_to_award = pb:units_killed_by_defender_character(cqi, mark_data.target_cqi) * mark_data.points_for_units_killed
				end

				local prm = military_force:pooled_resource_manager()

				if prm then 
					local faction_cqi = cm:get_faction(glottkin_marks_of_nurgle_config.faction_key):command_queue_index()
					local resource = prm:resource(mark_effects.winds_of_magic_resource_key)
					local value = resource:value()
					local total_spell_casted = 0
					if pb:is_auto_resolved() then
						total_spell_casted = (value / 2) / 10
					else
						for i = 1, #mark_effects.spells do
							total_spell_casted = total_spell_casted + pb:get_how_many_times_ability_has_been_used_in_battle(faction_cqi, mark_effects.spells[i])
						end
					end
					points_to_award = total_spell_casted * mark_data.points_for_spell_casted
				end

				cm:faction_add_pooled_resource(glottkin_marks_of_nurgle_config.faction_key, mark_data.pooled_resource_key, glottkin_marks_of_nurgle_config.pooled_resource_progression_factor_key, points_to_award)
			end,
		},
		-- Virulent Insight a.k.a "The Plague Mark"
		["wh3_dlc29_marks_of_nurgle_3"] = {
			-- Data necessary to update the progression of the mark.
			mark_data = {
				target_cqi = 0,
				pooled_resource_key = "wh3_dlc29_glott_mark_progression_3",
				upgrade_description_text = "{{tr:ui_text_replacements_localised_text_wh3_dlc29_marks_of_nurgle_3_upgrade_description}}",
				pooled_resource_threshold_key = "wh3_dlc29_glottkin_mark_3_progression",
				mark_initiative_key_prefix = "wh3_dlc29_marks_of_nurgle_3_level_",
				mark_current_level_key = "wh3_dlc29_marks_of_nurgle_3_level_0",
				initiative_set_key = "wh3_dlc29_glottkin_marks_set_lords",
				points_for_spreading_plague_to_settlements = 80,
				points_for_spreading_plague_to_forces = 120,
				progression_loss_percentage = {0.15, 0.30, 0.50, 0.60}, -- Progression loss in percentage per level
				purchased = false,
				--purchase_cost = "wh3_dlc20_initiative_souls_kho_t1", -- key from the "resource_costs" table
			},

			mark_effects = {
				plague = {
					[0] = "wh3_dlc29_woc_marks_of_nurgle_plague_0",
					[1] = "wh3_dlc29_woc_marks_of_nurgle_plague_1",
					[2] = "wh3_dlc29_woc_marks_of_nurgle_plague_2",
					[3] = "wh3_dlc29_woc_marks_of_nurgle_plague_blessed",
				},
				souls_per_spread_bonus_value_key = "plague_spread_earn_souls",
				apply_plague = function(mark_data, mark_effects)
					local target_character = cm:get_character_by_cqi(mark_data.target_cqi)
					-- target character might not exist, double-check
					if not target_character or target_character:is_null_interface() or not target_character:has_military_force() then
						return
					end

					local target_military_force = target_character:military_force()
					local faction = cm:get_faction(glottkin_marks_of_nurgle_config.faction_key)
					local mark_level = glottkin_marks_of_nurgle:get_mark_level_from_string(mark_data.mark_current_level_key)
					local plague_key = mark_effects.plague[mark_level]
					cm:spawn_plague_at_military_force(faction, target_military_force, plague_key)
				end,
			},

			requirements_ui_strings = {
				["{{tr:ui_text_replacements_localised_text_wh3_dlc29_marks_of_nurgle_3_upgrade_requirement_1}}"] = 80,
				["{{tr:ui_text_replacements_localised_text_wh3_dlc29_marks_of_nurgle_3_upgrade_requirement_2}}"] = 120,
			},

			remove_mark = function(context, mark_data, remove_progress)
				mark_data.target_cqi = 0
				core:remove_listener("wh3_dlc29_marks_of_nurgle_3_mil_force_infected")
				core:remove_listener("wh3_dlc29_marks_of_nurgle_3_region_infected")
				core:remove_listener("wh3_dlc29_marks_of_nurgle_3_pooled_resource_threshold")
				core:remove_listener("wh3_dlc29_marks_of_nurgle_3_mark_level_changed_effects")
				core:remove_listener("wh3_dlc29_marks_of_nurgle_3_force_infected_effects")
				core:remove_listener("wh3_dlc29_marks_of_nurgle_3_region_infected_effects")
				core:remove_listener("wh3_dlc29_marks_of_nurgle_3_faction_turn_start_effects")
				if remove_progress then
					glottkin_marks_of_nurgle:remove_progression_from_mark(mark_data)
				end
			end,

			setup_mark_progression = function(context, mark_data, mark_effects)
				-- PROGRESSION LISTENERS
				core:add_listener(
					"wh3_dlc29_marks_of_nurgle_3_mil_force_infected",
					"MilitaryForceInfectionEvent",
					function(context)
						return context:plague():creator_faction():name() == glottkin_marks_of_nurgle_config.faction_key and not context:is_creation() and not context:is_removed()
					end,
					function(context)
						cm:faction_add_pooled_resource(glottkin_marks_of_nurgle_config.faction_key, mark_data.pooled_resource_key, glottkin_marks_of_nurgle_config.pooled_resource_progression_factor_key, mark_data.points_for_spreading_plague_to_forces)
					end,
					true
				)

				core:add_listener(
					"wh3_dlc29_marks_of_nurgle_3_region_infected",
					"RegionInfectionEvent",
					function(context)
						return context:plague():creator_faction():name() == glottkin_marks_of_nurgle_config.faction_key and not context:is_creation() and not context:is_removed()
					end,
					function(context)
						cm:faction_add_pooled_resource(glottkin_marks_of_nurgle_config.faction_key, mark_data.pooled_resource_key, glottkin_marks_of_nurgle_config.pooled_resource_progression_factor_key, mark_data.points_for_spreading_plague_to_settlements)
					end,
					true
				)

				core:add_listener(
					"wh3_dlc29_marks_of_nurgle_3_pooled_resource_threshold",
					"PooledResourceThresholdOperationReached",
					function(context)
						return string.find(context:pooled_threshold_operation_record(), mark_data.pooled_resource_threshold_key)
					end,
					function(context)
						glottkin_marks_of_nurgle:apply_initiative_upgrade(mark_data, context:pooled_threshold_operation_record())
					end,
					true
				)

				-- EFFECTS LISTENERS
				mark_effects.apply_plague(mark_data, mark_effects)

				core:add_listener(
					"wh3_dlc29_marks_of_nurgle_3_mark_level_changed_effects",
					"GlottkinMarksOfNurgleLevelChanged",
					function(context)
						return true
					end,
					function(context)
						mark_effects.apply_plague(mark_data, mark_effects)
					end,
					true
				)

				core:add_listener(
					"wh3_dlc29_marks_of_nurgle_3_force_infected_effects",
					"MilitaryForceInfectionEvent",
					function(context)
						local plague = context:plague()
						local plague_key = plague:plague_record()
						local is_mark_plague = table.contains(mark_effects.plague, plague_key)

						return plague:creator_faction():name() == glottkin_marks_of_nurgle_config.faction_key and is_mark_plague and not context:is_creation() and not context:is_removed()
					end,
					function(context)
						local bonus_value = cm:get_factions_bonus_value(glottkin_marks_of_nurgle_config.faction_key, mark_effects.souls_per_spread_bonus_value_key)
						cm:faction_add_pooled_resource(glottkin_marks_of_nurgle_config.faction_key, glottkin_marks_of_nurgle_config.pooled_resource_souls_key, "wh3_dlc20_souls_other", bonus_value)
					end,
					true
				)

				core:add_listener(
					"wh3_dlc29_marks_of_nurgle_3_region_infected_effects",
					"RegionInfectionEvent",
					function(context)
						local plague = context:plague()
						local plague_key = plague:plague_record()
						local is_mark_plague = table.contains(mark_effects.plague, plague_key)

						return plague:creator_faction():name() == glottkin_marks_of_nurgle_config.faction_key and is_mark_plague and not context:is_creation() and not context:is_removed()
					end,
					function(context)
						local bonus_value = cm:get_factions_bonus_value(glottkin_marks_of_nurgle_config.faction_key, mark_effects.souls_per_spread_bonus_value_key)
						cm:faction_add_pooled_resource(glottkin_marks_of_nurgle_config.faction_key, glottkin_marks_of_nurgle_config.pooled_resource_souls_key, "wh3_dlc20_souls_other", bonus_value)
					end,
					true
				)

				core:add_listener(
					"wh3_dlc29_marks_of_nurgle_3_faction_turn_start_effects",
					"FactionTurnStart",
					function(context)
						return context:faction():name() == glottkin_marks_of_nurgle_config.faction_key and mark_data.target_cqi ~= 0
					end,
					function(context)
						mark_effects.apply_plague(mark_data, mark_effects)
					end,
					true
				)
			end,
		},
		-- Putrefying Grit a.k.a "The Warband Mark"
		["wh3_dlc29_marks_of_nurgle_4"] = {
			-- Data necessary to update the progression of the mark.
			mark_data = {
				target_cqi = 0,
				pooled_resource_key = "wh3_dlc29_glott_mark_progression_4",
				upgrade_description_text = "{{tr:ui_text_replacements_localised_text_wh3_dlc29_marks_of_nurgle_4_upgrade_description}}",
				pooled_resource_threshold_key = "wh3_dlc29_glottkin_mark_4_progression",
				mark_initiative_key_prefix = "wh3_dlc29_marks_of_nurgle_4_level_",
				mark_current_level_key = "wh3_dlc29_marks_of_nurgle_4_level_0",
				initiative_set_key = "wh3_dlc29_glottkin_marks_set_lords",
				point_for_warband_upgrades = 300,
				points_for_unit_ranking_up = 80,
				progression_loss_percentage = {0.15, 0.30, 0.50, 0.60}, -- Progression loss in percentage per level
				purchased = false,
				--purchase_cost = "wh3_dlc20_initiative_souls_kho_t1", -- key from the "resource_costs" table
			},

			mark_effects = {
				warband_upgrades_chance_percentage = 50,
				levels_to_award = 1,
				amount_of_heath_to_replenish_on_level_up = 0.07, -- 7%
			},

			requirements_ui_strings = {
				["{{tr:ui_text_replacements_localised_text_wh3_dlc29_marks_of_nurgle_4_upgrade_requirement_1}}"] = 80,
				["{{tr:ui_text_replacements_localised_text_wh3_dlc29_marks_of_nurgle_4_upgrade_requirement_2}}"] = 300,
			},

			remove_mark = function(context, mark_data, remove_progress)
				mark_data.target_cqi = 0
				core:remove_listener("wh3_dlc29_marks_of_nurgle_4_unit_upgraded")
				core:remove_listener("wh3_dlc29_marks_of_nurgle_4_unit_experience_changed")
				core:remove_listener("wh3_dlc29_marks_of_nurgle_4_pooled_resource_threshold")
				core:remove_listener("wh3_dlc29_marks_of_nurgle_4_unit_xp_effects")
				core:remove_listener("wh3_dlc29_marks_of_nurgle_4_unit_experience_changed_effects")
				core:remove_listener("wh3_dlc29_marks_of_nurgle_4_unit_upgrade_effects")
				if remove_progress then
					glottkin_marks_of_nurgle:remove_progression_from_mark(mark_data)
				end
			end,

			setup_mark_progression = function(context, mark_data, mark_effects)
				-- PROGRESSION LISTENERS
				core:add_listener(
					"wh3_dlc29_marks_of_nurgle_4_unit_upgraded",
					"UnitUpgraded",
					function(context)
						local upgrade_group_key = context:upgrade_group():key()
						local is_valid_upgrade = not string.ends_with(upgrade_group_key, "to_self") and not string.ends_with(upgrade_group_key, "und_to_nur")
						return context:unit():faction():name() == glottkin_marks_of_nurgle_config.faction_key and context:unit():force_commander():command_queue_index() == mark_data.target_cqi and is_valid_upgrade
					end,
					function(context)
						cm:faction_add_pooled_resource(glottkin_marks_of_nurgle_config.faction_key, mark_data.pooled_resource_key, glottkin_marks_of_nurgle_config.pooled_resource_progression_factor_key, mark_data.point_for_warband_upgrades)
					end,
					true
				)

				core:add_listener(
					"wh3_dlc29_marks_of_nurgle_4_unit_experience_changed",
					"UnitExperienceLevelChanged",
					function(context)
						local previous_level = context:previous_level()
						local current_level = context:unit():experience_level()
						return context:unit():faction():name() == glottkin_marks_of_nurgle_config.faction_key and context:unit():force_commander():command_queue_index() == mark_data.target_cqi and current_level > previous_level
					end,
					function(context)
						cm:faction_add_pooled_resource(glottkin_marks_of_nurgle_config.faction_key, mark_data.pooled_resource_key, glottkin_marks_of_nurgle_config.pooled_resource_progression_factor_key, mark_data.points_for_unit_ranking_up)
					end,
					true
				)

				core:add_listener(
					"wh3_dlc29_marks_of_nurgle_4_pooled_resource_threshold",
					"PooledResourceThresholdOperationReached",
					function(context)
						return string.find(context:pooled_threshold_operation_record(), mark_data.pooled_resource_threshold_key)
					end,
					function(context)
						glottkin_marks_of_nurgle:apply_initiative_upgrade(mark_data, context:pooled_threshold_operation_record())
					end,
					true
				)

				-- EFFECTS LISTENERS
				core:add_listener(
					"wh3_dlc29_marks_of_nurgle_4_unit_xp_effects",
					"BattleCompleted",
					function()
						local mark_level = glottkin_marks_of_nurgle:get_mark_level_from_string(mark_data.mark_current_level_key)
						return cm:model():pending_battle():has_been_fought() and cm:pending_battle_cache_faction_won_battle(glottkin_marks_of_nurgle_config.faction_key) and mark_level >= 0
					end,
					function(context)
						if cm:pending_battle_cache_faction_is_attacker(glottkin_marks_of_nurgle_config.faction_key) then
							for i = 1, cm:pending_battle_cache_num_attackers() do
								local current_char_cqi, current_mf_cqi, current_faction_name = cm:pending_battle_cache_get_attacker(i)
								if mark_data.target_cqi ~= nil then
									if current_faction_name == glottkin_marks_of_nurgle_config.faction_key then
										local mf = cm:get_military_force_by_cqi(current_mf_cqi)
										glottkin_marks_of_nurgle:level_up_random_unit_in_force(mf, mark_effects.levels_to_award)
									end
								end
							end
						elseif cm:pending_battle_cache_faction_is_defender(glottkin_marks_of_nurgle_config.faction_key) then
							for i = 1, cm:pending_battle_cache_num_defenders() do
								local current_char_cqi, current_mf_cqi, current_faction_name = cm:pending_battle_cache_get_defender_fm_cqi(i)
								if mark_data.target_cqi ~= nil then
									if current_faction_name == glottkin_marks_of_nurgle_config.faction_key then
										local mf = cm:get_military_force_by_cqi(current_mf_cqi)
										glottkin_marks_of_nurgle:level_up_random_unit_in_force(mf, mark_effects.levels_to_award)
									end
								end
							end
						end
					end,
					true
				)

				core:add_listener(
					"wh3_dlc29_marks_of_nurgle_4_unit_experience_changed_effects",
					"UnitExperienceLevelChanged",
					function(context)
						local mark_level = glottkin_marks_of_nurgle:get_mark_level_from_string(mark_data.mark_current_level_key)
						return context:unit():faction():name() == glottkin_marks_of_nurgle_config.faction_key and context:unit():force_commander():command_queue_index() == mark_data.target_cqi and mark_level >= 1
					end,
					function(context)
						local unit = context:unit()
						local current_health_proportion = unit:percentage_proportion_of_full_strength() / 100
						local new_health_value = current_health_proportion + mark_effects.amount_of_heath_to_replenish_on_level_up
						cm:set_unit_hp_to_unary_of_maximum(unit, new_health_value)
					end,
					true
				)

				core:add_listener(
					"wh3_dlc29_marks_of_nurgle_4_unit_upgrade_effects",
					"CharacterCompletedBattle",
					function(context)
						local mark_level = glottkin_marks_of_nurgle:get_mark_level_from_string(mark_data.mark_current_level_key)
						local is_allowed_to_upgrade = cm:random_number(100, 0) >= mark_effects.warband_upgrades_chance_percentage
						return cm:model():pending_battle():has_been_fought() and cm:pending_battle_cache_faction_won_battle(glottkin_marks_of_nurgle_config.faction_key) and mark_level >= 3 and is_allowed_to_upgrade and context:character():command_queue_index() == mark_data.target_cqi
					end,
					function(context)
						if cm:pending_battle_cache_faction_is_attacker(glottkin_marks_of_nurgle_config.faction_key) then
							for i = 1, cm:pending_battle_cache_num_attackers() do
								local current_char_cqi, current_mf_cqi, current_faction_name = cm:pending_battle_cache_get_attacker(i)
								if mark_data.target_cqi ~= nil then
									if current_faction_name == glottkin_marks_of_nurgle_config.faction_key then
										glottkin_marks_of_nurgle:award_random_unit_with_warband_upgrade(current_mf_cqi)
									end
								end
							end
						elseif cm:pending_battle_cache_faction_is_defender(glottkin_marks_of_nurgle_config.faction_key) then
							for i = 1, cm:pending_battle_cache_num_defenders() do
								local current_char_cqi, current_mf_cqi, current_faction_name = cm:pending_battle_cache_get_defender_fm_cqi(i)
								if mark_data.target_cqi ~= nil then
									if current_faction_name == glottkin_marks_of_nurgle_config.faction_key then
										glottkin_marks_of_nurgle:award_random_unit_with_warband_upgrade(current_mf_cqi)
									end
								end
							end
						end
					end,
					true
				)
			end,
		},
		-- Fecund Rebirth a.k.a "The Monster Mark"
		["wh3_dlc29_marks_of_nurgle_5"] = {
			-- Data necessary to update the progression of the mark.
			mark_data = {
				target_cqi = 0,
				pooled_resource_key = "wh3_dlc29_glott_mark_progression_5",
				upgrade_description_text = "{{tr:ui_text_replacements_localised_text_wh3_dlc29_marks_of_nurgle_5_upgrade_description}}",
				pooled_resource_threshold_key = "wh3_dlc29_glottkin_mark_5_progression",
				mark_initiative_key_prefix = "wh3_dlc29_marks_of_nurgle_5_level_",
				mark_current_level_key = "wh3_dlc29_marks_of_nurgle_5_level_0",
				initiative_set_key = "wh3_dlc29_glottkin_marks_set_hybrid",
				cached_enemy_characters = {},
				points_for_monster_kills = 4,
				points_for_recruiting_monster = 650,
				unit_set_key = "wh3_dlc29_marks_monsters",
				progression_loss_percentage = {0.15, 0.30, 0.50, 0.60}, -- Progression loss in percentage per level
				purchased = false,
				--purchase_cost = "wh3_dlc20_initiative_souls_kho_t1", -- key from the "resource_costs" table
				were_monsters_present_in_battle = false, 
			},

			mark_effects = {
				monster_pool_1 = {
					"wh3_dlc20_chs_mon_warshrine_mnur",
					"wh3_dlc27_nor_mon_dread_maw_underground",
					"wh3_dlc29_chs_mon_giant_spined_chaos_beast",
					"wh3_main_nur_mon_spawn_of_nurgle_0",
					"wh_dlc01_chs_mon_dragon_ogre",
					"wh_main_chs_mon_giant",
					"wh_main_chs_mon_trolls",
				},
				monster_pool_2 = {
					"wh3_dlc20_chs_mon_warshrine_mnur",
					"wh3_dlc25_nur_inf_plague_ogres",
					"wh3_dlc25_nur_mon_bile_trolls",
					"wh3_dlc25_nur_mon_toad_dragon",
					"wh3_dlc27_nor_mon_dread_maw_underground",
					"wh3_dlc29_chs_mon_basilisk",
					"wh3_dlc29_chs_mon_chaos_siege_giant",
					"wh3_dlc29_chs_mon_giant_spined_chaos_beast",
					"wh3_main_nur_mon_spawn_of_nurgle_0",
					"wh_dlc01_chs_mon_dragon_ogre",
					"wh_dlc01_chs_mon_dragon_ogre_shaggoth",
					"wh_main_chs_mon_giant",
					"wh_main_chs_mon_trolls",
				},
			},

			requirements_ui_strings = {
				["{{tr:ui_text_replacements_localised_text_wh3_dlc29_marks_of_nurgle_5_upgrade_requirement_1}}"] = 650,
				["{{tr:ui_text_replacements_localised_text_wh3_dlc29_marks_of_nurgle_5_upgrade_requirement_2}}"] = 4,
			},

			remove_mark = function(context, mark_data, remove_progress)
				mark_data.target_cqi = 0
				mark_data.cached_enemy_characters = {}
				core:remove_listener("wh3_dlc29_marks_of_nurgle_5_pending_battle")
				core:remove_listener("wh3_dlc29_marks_of_nurgle_5_hero_completed_battle")
				core:remove_listener("wh3_dlc29_marks_of_nurgle_5_character_completed_battle")
				core:remove_listener("wh3_dlc29_marks_of_nurgle_5_unit_trained")
				core:remove_listener("wh3_dlc29_marks_of_nurgle_5_pooled_resource_threshold")
				if remove_progress then
					glottkin_marks_of_nurgle:remove_progression_from_mark(mark_data)
				end
			end,

			setup_mark_progression = function(context, mark_data, mark_effects)
				-- PROGRESSION LISTENERS
				core:add_listener(
					"wh3_dlc29_marks_of_nurgle_5_pending_battle",
					"PendingBattle",
					function(context)
						return true
					end,
					function(context)
						local pb = context:pending_battle()
						local is_attacker = false

						if pb:attacker():faction():name() == glottkin_marks_of_nurgle_config.faction_key or glottkin_marks_of_nurgle:is_glottkin_faction_in_character_list(pb:secondary_attackers()) then
							is_attacker = true
						elseif not pb:defender():faction():name() == glottkin_marks_of_nurgle_config.faction_key or not glottkin_marks_of_nurgle:is_glottkin_faction_in_character_list(pb:secondary_defenders()) then
							return
						end

						-- EFFECTS
						if is_attacker then 
							mark_data.were_monsters_present_in_battle = glottkin_marks_of_nurgle:search_for_unit_set_in_forces(mark_data.unit_set_key, pb:defender(), pb:secondary_defenders())
						else
							mark_data.were_monsters_present_in_battle = glottkin_marks_of_nurgle:search_for_unit_set_in_forces(mark_data.unit_set_key, pb:attacker(), pb:secondary_attackers())
						end
					end,
					true
				)

				core:add_listener(
					"wh3_dlc29_marks_of_nurgle_5_hero_completed_battle",
					"HeroCharacterParticipatedInBattle",
					function(context)
						return context:character():cqi() == mark_data.target_cqi
					end,
					function(context)
						glottkin_marks_of_nurgle_config.marks["wh3_dlc29_marks_of_nurgle_5"].apply_post_battle_progression_and_effects(context, mark_data, mark_effects)
					end,
					true
				)

				core:add_listener(
					"wh3_dlc29_marks_of_nurgle_5_character_completed_battle",
					"CharacterCompletedBattle",
					function(context)
						return context:character():cqi() == mark_data.target_cqi
					end,
					function(context)
						glottkin_marks_of_nurgle_config.marks["wh3_dlc29_marks_of_nurgle_5"].apply_post_battle_progression_and_effects(context, mark_data, mark_effects)
					end,
					true
				)

				core:add_listener(
					"wh3_dlc29_marks_of_nurgle_5_unit_trained",
					"UnitTrained",
					function(context)
						local mf = context:unit():military_force()
						local general = mf:general_character()
						
						if not context:unit():is_unit_in_set(mark_data.unit_set_key) then
							return false
						end
						
						if general:command_queue_index() == mark_data.target_cqi then
							return true
						end
						
						local character_list = mf:character_list()
						for i = 0, character_list:num_items() - 1 do
							if character_list:item_at(i):command_queue_index() == mark_data.target_cqi then
								return true
							end
						end
						return false
					end,
					function(context)
						cm:faction_add_pooled_resource(glottkin_marks_of_nurgle_config.faction_key, mark_data.pooled_resource_key, glottkin_marks_of_nurgle_config.pooled_resource_progression_factor_key, mark_data.points_for_recruiting_monster)
					end,
					true
				)

				core:add_listener(
					"wh3_dlc29_marks_of_nurgle_5_pooled_resource_threshold",
					"PooledResourceThresholdOperationReached",
					function(context)
						return string.find(context:pooled_threshold_operation_record(), mark_data.pooled_resource_threshold_key)
					end,
					function(context)
						glottkin_marks_of_nurgle:apply_initiative_upgrade(mark_data, context:pooled_threshold_operation_record())
					end,
					true
				)
			end,

			apply_post_battle_progression_and_effects = function(context, mark_data, mark_effects)
				local pb = cm:model():pending_battle()
				local is_attacker = false

				if pb:attacker():faction():name() == glottkin_marks_of_nurgle_config.faction_key or glottkin_marks_of_nurgle:is_glottkin_faction_in_character_list(pb:secondary_attackers()) then
					is_attacker = true
				end

				local character = context:character()
				local military_force = character:military_force()
				if not military_force or military_force:is_null_interface() and character:is_embedded_in_military_force() then
					military_force = character:embedded_in_military_force()
					if not military_force or military_force:is_null_interface() then
						mark_data.were_monsters_present_in_battle = false
						return
					end
				end

				-- PROGRESSION 
				local cqi = military_force:command_queue_index()
				local points_for_enemy_killed = 0
				if is_attacker then
					points_for_enemy_killed = pb:units_killed_by_attacker_unit_set(cqi, mark_data.unit_set_key) * mark_data.points_for_monster_kills
				else
					points_for_enemy_killed = pb:units_killed_by_defender_unit_set(cqi, mark_data.unit_set_key) * mark_data.points_for_monster_kills
				end

				cm:faction_add_pooled_resource(glottkin_marks_of_nurgle_config.faction_key, mark_data.pooled_resource_key, glottkin_marks_of_nurgle_config.pooled_resource_progression_factor_key, points_for_enemy_killed)

				local is_winner = (is_attacker and pb:attacker_won()) or (not is_attacker and pb:defender_won())
				if not is_winner or not mark_data.were_monsters_present_in_battle then
					mark_data.were_monsters_present_in_battle = false
					return
				end

				local monster_pool = mark_effects.monster_pool_1
				local mark_level = glottkin_marks_of_nurgle:get_mark_level_from_string(mark_data.mark_current_level_key)

				if mark_level >= 2 then
					monster_pool = mark_effects.monster_pool_2
				end

				local character = context:character()
				if character:has_region() then
					local monster_key = monster_pool[cm:random_number(#monster_pool, 1)]
					glottkin_marks_of_nurgle:add_gifted_units_to_province_mercenary_pool(character:region(), monster_key, 1)
				end

				mark_data.were_monsters_present_in_battle = false
			end,
		},
		-- Acolyte of Pestilence a.k.a "The Hero Action Mark"
		["wh3_dlc29_marks_of_nurgle_6"] = {
			-- Data necessary to update the progression of the mark.
			mark_data = {
				target_cqi = 0,
				pooled_resource_key = "wh3_dlc29_glott_mark_progression_6",
				upgrade_description_text = "{{tr:ui_text_replacements_localised_text_wh3_dlc29_marks_of_nurgle_6_upgrade_description}}",
				pooled_resource_threshold_key = "wh3_dlc29_glottkin_mark_6_progression",
				mark_initiative_key_prefix = "wh3_dlc29_marks_of_nurgle_6_level_",
				mark_current_level_key = "wh3_dlc29_marks_of_nurgle_6_level_0",
				initiative_set_key = "wh3_dlc29_glottkin_marks_set_heroes",
				points_for_successful_hero_action = 1250,
				points_for_hero_kills = 10,
				progression_loss_percentage = {0.15, 0.30, 0.50, 0.60}, -- Progression loss in percentage per level
				purchased = false,
				--purchase_cost = "wh3_dlc20_initiative_souls_kho_t1", -- key from the "resource_costs" table
			},

			requirements_ui_strings = {
				["{{tr:ui_text_replacements_localised_text_wh3_dlc29_marks_of_nurgle_6_upgrade_requirement_1}}"] = 1250,
				["{{tr:ui_text_replacements_localised_text_wh3_dlc29_marks_of_nurgle_6_upgrade_requirement_2}}"] = 10,
			},

			mark_effects = {
				agent_convert_garrison_ability_key_suffix = "_hinder_settlement_convert_garrison_to_nur_mercenary",
				agent_convert_garrison_cooldown = 4,
				agent_hinder_character_ability_key_suffix = "_hinder_agent_wound_convert_to_nur_lord",
				agent_hinder_character_cooldown = 8,
				agent_action_bonus_cooldown = 2,
				warrior_of_chaos_unit_key = "wh3_dlc20_chs_inf_chaos_warriors_mnur",
				amount_of_unit_to_kill_in_garrison_action = 1, -- This hero action already kills 1 unit through DB. 
				amount_of_unit_to_award_after_garrison_action = 2,
				hero_actions_faction_set_key = "human_factions",
				hero_actions_cooldown_reduction_bonus_value = "wh3_dlc29_glottkin_agent_action_convert_garrison_cooldown",
				hero_action_normal_cooldown = 10,
			},

			remove_mark = function(context, mark_data, remove_progress)
				mark_data.target_cqi = 0
				core:remove_listener("wh3_dlc29_marks_of_nurgle_6_character_completed_battle")
				core:remove_listener("wh3_dlc29_marks_of_nurgle_6_character_target_action")
				core:remove_listener("wh3_dlc29_marks_of_nurgle_6_garrison_target_action")
				core:remove_listener("wh3_dlc29_marks_of_nurgle_6_pooled_resource_threshold")
				core:remove_listener("wh3_dlc29_marks_of_nurgle_6_hero_target_settlement_effects")
				core:remove_listener("wh3_dlc29_marks_of_nurgle_6_hero_target_character_effects")
				core:remove_listener("wh3_dlc29_marks_of_nurgle_6_mark_level_changed_effects")
				if remove_progress then
					glottkin_marks_of_nurgle:remove_progression_from_mark(mark_data)
				end
			end,

			setup_mark_progression = function(context, mark_data, mark_effects)
				-- PROGRESSION LISTENERS
				core:add_listener(
					"wh3_dlc29_marks_of_nurgle_6_character_completed_battle",
					"HeroCharacterParticipatedInBattle",
					function(context)
						return context:character():cqi() == mark_data.target_cqi
					end,
					function(context)
						local pb = cm:model():pending_battle()
						local is_attacker = false

						if pb:attacker():faction():name() == glottkin_marks_of_nurgle_config.faction_key or glottkin_marks_of_nurgle:is_glottkin_faction_in_character_list(pb:secondary_attackers()) then
							is_attacker = true
						end

						local character = context:character()
						local military_force = character:military_force()
						if not military_force or military_force:is_null_interface() and character:is_embedded_in_military_force() then
							military_force = character:embedded_in_military_force()
							if not military_force or military_force:is_null_interface() then
								return
							end
						end

						local cqi = military_force:command_queue_index()
						local points_for_enemy_killed = 0
						if is_attacker then
							points_for_enemy_killed = pb:units_killed_by_attacker_character(cqi, mark_data.target_cqi) * mark_data.points_for_hero_kills
						else
							points_for_enemy_killed = pb:units_killed_by_defender_character(cqi, mark_data.target_cqi) * mark_data.points_for_hero_kills
						end

						cm:faction_add_pooled_resource(glottkin_marks_of_nurgle_config.faction_key, mark_data.pooled_resource_key, glottkin_marks_of_nurgle_config.pooled_resource_progression_factor_key, points_for_enemy_killed)
					end,
					true
				)

				core:add_listener(
					"wh3_dlc29_marks_of_nurgle_6_character_target_action",
					"CharacterCharacterTargetAction",
					function(context)
						return (context:mission_result_critial_success() or context:mission_result_success()) and context:character():cqi() == mark_data.target_cqi
					end,
					function(context)
						cm:faction_add_pooled_resource(glottkin_marks_of_nurgle_config.faction_key, mark_data.pooled_resource_key, glottkin_marks_of_nurgle_config.pooled_resource_progression_factor_key, mark_data.points_for_successful_hero_action)
					end,
					true
				)

				core:add_listener(
					"wh3_dlc29_marks_of_nurgle_6_garrison_target_action",
					"CharacterGarrisonTargetAction",
					function(context)
						return (context:mission_result_critial_success() or context:mission_result_success()) and context:character():cqi() == mark_data.target_cqi
					end,
					function(context)
						cm:faction_add_pooled_resource(glottkin_marks_of_nurgle_config.faction_key, mark_data.pooled_resource_key, glottkin_marks_of_nurgle_config.pooled_resource_progression_factor_key, mark_data.points_for_successful_hero_action)
					end,
					true
				)

				core:add_listener(
					"wh3_dlc29_marks_of_nurgle_6_pooled_resource_threshold",
					"PooledResourceThresholdOperationReached",
					function(context)
						return string.find(context:pooled_threshold_operation_record(), mark_data.pooled_resource_threshold_key)
					end,
					function(context)
						glottkin_marks_of_nurgle:apply_initiative_upgrade(mark_data, context:pooled_threshold_operation_record())
					end,
					true
				)

				-- EFFECTS LISTENERS
				-- Action "Convert garrison unit"
				core:add_listener(
					"wh3_dlc29_marks_of_nurgle_6_hero_target_settlement_effects",
					"CharacterGarrisonTargetAction",
					function(context)
						return (context:mission_result_critial_success() or context:mission_result_success()) and context:character():command_queue_index() == mark_data.target_cqi and string.ends_with(context:agent_action_key(), mark_effects.agent_convert_garrison_ability_key_suffix)
					end,
					function(context)
						local garrison_residence = context:garrison_residence()
						local region = garrison_residence:region()
						local garrison_force = garrison_residence:armed_citizenry_army()
						
						if garrison_force and not region:is_null_interface() then 
							local garrison_leader = garrison_force:general_character()
							local char_lookup_str = campaign_manager:char_lookup_str(garrison_leader)
							
							for j = 1, mark_effects.amount_of_unit_to_kill_in_garrison_action do 
								local rand = cm:random_number(garrison_force:unit_list():num_items() - 1, 0)
								local selected_unit_key = garrison_force:unit_list():item_at(rand):unit_key()
								cm:remove_unit_from_character(char_lookup_str, selected_unit_key)
							end
							
							glottkin_marks_of_nurgle:add_gifted_units_to_province_mercenary_pool(region, mark_effects.warrior_of_chaos_unit_key, mark_effects.amount_of_unit_to_award_after_garrison_action)
						end

						local mark_level = glottkin_marks_of_nurgle:get_mark_level_from_string(mark_data.mark_current_level_key)

						if mark_level >= 3 then 
							local character = cm:get_character_by_cqi(mark_data.target_cqi)
							local char_bonus_value = cm:get_characters_bonus_value(character, "wh3_dlc29_glottkin_agent_action_convert_garrison_cooldown")
							cm:remove_effect_bundle_from_character("wh3_dlc29_bundle_agent_action_all_hinder_settlement_success_wound_garrison_unit_target", character)
							cm:apply_effect_bundle_to_character("wh3_dlc29_bundle_agent_action_all_hinder_settlement_success_wound_garrison_unit_target", character, mark_effects.agent_convert_garrison_cooldown - mark_effects.agent_action_bonus_cooldown)
						end
					end,
					true
				)

				-- Action "Convert to Nurgle"
				core:add_listener(
					"wh3_dlc29_marks_of_nurgle_6_hero_target_character_effects",
					"CharacterCharacterTargetAction",
					function(context)
						return context:character():command_queue_index() == mark_data.target_cqi and (context:mission_result_critial_success() or context:mission_result_success()) and string.ends_with(context:agent_action_key(), mark_effects.agent_hinder_character_ability_key_suffix)
					end,
					function(context)
						local target_character = context:target_character()

						if target_character then
							local is_faction_leader = target_character:is_faction_leader()
							local is_general_with_army = cm:char_is_general_with_army(target_character)
							local is_human_faction = target_character:faction():is_contained_in_faction_set(mark_effects.hero_actions_faction_set_key)
							local is_legendary_lord = glottkin_marks_of_nurgle:is_character_legendary_lord(target_character)

							if not target_character:is_null_interface() and is_general_with_army and not is_legendary_lord and not is_faction_leader and is_human_faction then
								local target_character_level = target_character:rank()
								local character_str = cm:char_lookup_str(target_character:command_queue_index())
								cm:callback(
									function()
										cm:kill_character_and_commanded_unit(character_str, false, true)
									end,
									0.1)
								local character_details = cm:spawn_character_to_pool(glottkin_marks_of_nurgle_config.faction_key, "", "", "", "", 21, true, "general", "wh3_dlc25_chs_lord_mnur", false, "")
								cm:character_details_set_rank(character_details, target_character_level, true)
							end
						end

						local mark_level = glottkin_marks_of_nurgle:get_mark_level_from_string(mark_data.mark_current_level_key)

						if mark_level >= 3 then 
							local character = cm:get_character_by_cqi(mark_data.target_cqi)
							cm:remove_effect_bundle_from_character("wh3_dlc29_bundle_agent_action_all_hinder_character_success_convert_to_nurgle_actor", character)
							cm:apply_effect_bundle_to_character("wh3_dlc29_bundle_agent_action_all_hinder_character_success_convert_to_nurgle_actor", character, mark_effects.agent_convert_garrison_cooldown - mark_effects.agent_action_bonus_cooldown)
						end
					end,
					true
				)
			end,
		},
		-- Unbridled Growth Garden a.k.a "The Garden Mark"
		["wh3_dlc29_marks_of_nurgle_7"] = {
			-- Data necessary to update the progression of the mark.
			mark_data = {
				target_name = "",
				pooled_resource_key = "wh3_dlc29_glott_mark_progression_7",
				upgrade_description_text = "{{tr:ui_text_replacements_localised_text_wh3_dlc29_marks_of_nurgle_7_upgrade_description}}",
				pooled_resource_threshold_key = "wh3_dlc29_glottkin_mark_7_progression",
				mark_initiative_key_prefix = "wh3_dlc29_marks_of_nurgle_7_level_",
				mark_current_level_key = "wh3_dlc29_marks_of_nurgle_7_level_0",
				initiative_set_key = "wh3_dlc29_glottkin_marks_set_settlements",
				settlement_type_key = "wh3_dlc29_glottkin_garden_of_nurgle",
				points_for_building_cycle = 300,
				points_for_garden_spawning_plague = 400,
				progression_loss_percentage = {0.15, 0.30, 0.50, 0.60}, -- Progression loss in percentage per level
				purchased = false,
				--purchase_cost = "wh3_dlc20_initiative_souls_kho_t1", -- key from the "resource_costs" table
			},

			requirements_ui_strings = {
				["{{tr:ui_text_replacements_localised_text_wh3_dlc29_marks_of_nurgle_7_upgrade_requirement_1}}"] = 400,
				["{{tr:ui_text_replacements_localised_text_wh3_dlc29_marks_of_nurgle_7_upgrade_requirement_2}}"] = 500,
			},

			mark_effects = {
				development_points = 1,
				settlement_effect_bundle_key = "wh3_dlc29_glottkin_mark_of_crawling_garden_tier_1",
				settlement_effect_bundle_duration = 3,
				bonus_value_plague_cooldown_key = "wh3_dlc29_glottkin_plague_creation_cooldown_reduction",
			},

			remove_mark = function(context, mark_data, remove_progress)
				mark_data.target_name = ""
				core:remove_listener("wh3_dlc29_marks_of_nurgle_7_life_cycle_develops")
				core:remove_listener("wh3_dlc29_marks_of_nurgle_7_garden_spawned_plague")
				core:remove_listener("wh3_dlc29_marks_of_nurgle_7_pooled_resource_threshold")
				core:remove_listener("wh3_dlc29_marks_of_nurgle_7_life_cycle_develops_effects")
				core:remove_listener("wh3_dlc29_marks_of_nurgle_7_mark_level_changed_effects")
				if remove_progress then
					glottkin_marks_of_nurgle:remove_progression_from_mark(mark_data)
				end
			end,

			setup_mark_progression = function(context, mark_data, mark_effects)
				-- PROGRESSION LISTENERS
				core:add_listener(
					"wh3_dlc29_marks_of_nurgle_7_life_cycle_develops",
					"BuildingLifecycleDevelops",
					function(context)
						return context:region():owning_faction():name() == glottkin_marks_of_nurgle_config.faction_key
					end,
					function(context)
						cm:faction_add_pooled_resource(glottkin_marks_of_nurgle_config.faction_key, mark_data.pooled_resource_key, glottkin_marks_of_nurgle_config.pooled_resource_progression_factor_key, mark_data.points_for_building_cycle)
					end,
					true
				)

				core:add_listener(
					"wh3_dlc29_marks_of_nurgle_7_garden_spawned_plague",
					"GlottkinGardenSpawnedPlague",
					function(context)
						return true
					end,
					function(context)
						cm:faction_add_pooled_resource(glottkin_marks_of_nurgle_config.faction_key, mark_data.pooled_resource_key, glottkin_marks_of_nurgle_config.pooled_resource_progression_factor_key, mark_data.points_for_garden_spawning_plague)
					end,
					true
				)

				core:add_listener(
					"wh3_dlc29_marks_of_nurgle_7_pooled_resource_threshold",
					"PooledResourceThresholdOperationReached",
					function(context)
						return string.find(context:pooled_threshold_operation_record(), mark_data.pooled_resource_threshold_key)
					end,
					function(context)
						glottkin_marks_of_nurgle:apply_initiative_upgrade(mark_data, context:pooled_threshold_operation_record())
					end,
					true
				)

				-- EFFECTS LISTENERS
				core:add_listener(
					"wh3_dlc29_marks_of_nurgle_7_life_cycle_develops_effects",
					"BuildingLifecycleDevelops",
					function(context)
						local level_split = string.split(context:current(), "_")
						local current_level = tonumber(level_split[#level_split])
						return context:region():settlement():faction():name() == glottkin_marks_of_nurgle_config.faction_key and context:region():name() == mark_data.target_name and current_level == 1
					end,
					function(context)
						local current_mark_level = glottkin_marks_of_nurgle:get_mark_level_from_string(mark_data.mark_current_level_key)
						local region_name = context:region():name()

						-- Tier 0 : Add growth + Souls once per turn max
						if current_mark_level >= 0 then
							cm:add_development_points_to_region(region_name, mark_effects.development_points)
							cm:apply_effect_bundle_to_region(mark_effects.settlement_effect_bundle_key, mark_data.target_name, mark_effects.settlement_effect_bundle_duration)
						end
					end,
					true
				)

				core:add_listener(
					"wh3_dlc29_marks_of_nurgle_7_mark_level_changed_effects",
					"GlottkinMarksOfNurgleLevelChanged",
					function(context)
						return true
					end,
					function(context)
						local current_mark_level = context.stored_table.current_mark_level
						
						-- A bonus value that decrease the cooldown is applied on this level from initiatives, simply update the shared states to reflect it in the UI.
						if current_mark_level >= 1 then
							local region = cm:get_region(mark_data.target_name)
							glottkin_gardens_of_nurgle:update_cooldown_shared_state(region)
						end
						-- Tier 3 : Unlock plague Spawning in the whole province
						if current_mark_level >= 3 then
							glottkin_gardens_of_nurgle:set_garden_plague_spread_to_province(mark_data.target_name)
						end
					end,
					true
				)
			end,
		},
	},
}

glottkin_marks_of_nurgle_persistent = {
	mark_progression_loss_bonus = 0,
	mark_progression_loss_enabled = true,
	mission_has_been_issued = false,
	provinces_winds_of_magic_changed = {},
	gifted_unit_event_last_popup_turn_by_unit_key = {},
}

glottkin_marks_of_nurgle = {}
glottkin_marks_of_nurgle.config = glottkin_marks_of_nurgle_config

function glottkin_marks_of_nurgle:initialise()

    local faction = cm:get_faction(glottkin_marks_of_nurgle_config.faction_key)
    if not faction then
        return false
    end

	glottkin_marks_of_nurgle:setup_marks_shared_state_values()
	glottkin_marks_of_nurgle:set_current_active_marks_count()
	glottkin_marks_of_nurgle:set_maximum_marks_count()
	glottkin_marks_of_nurgle:setup_marks_progression()
	glottkin_marks_of_nurgle:setup_province_mercenary_pool_scripted_capacity_cleanup()

	core:add_listener(
		"glottkin_marks_of_nurgle_character_initiative",
		"CharacterInitiativeActivationChangedEvent",
		function(context)
			local mark_key = string.split(context:initiative():record_key(), "_level")
			return context:character():faction():name() == glottkin_marks_of_nurgle_config.faction_key and glottkin_marks_of_nurgle_config.marks[mark_key[1]]
		end,
		function(context)
			-- If we are leveling up the mark, set the flag back to false and return.
			local character = context:character()
			local is_active = context:active()

			local mark_key = string.split(context:initiative():record_key(), "_level")
			local mark = glottkin_marks_of_nurgle_config.marks[mark_key[1]]

			if is_active and mark.setup_mark_progression and is_function(mark.setup_mark_progression) then
				if glottkin_marks_of_nurgle_config.is_leveling_up_mark == false then
					mark.mark_data.target_cqi = character:cqi()
					mark.setup_mark_progression(context, mark.mark_data, mark.mark_effects)
				end
			elseif mark.remove_mark and is_function(mark.remove_mark) then
				if glottkin_marks_of_nurgle_config.is_leveling_up_mark == false and character:cqi() == mark.mark_data.target_cqi then
					mark.remove_mark(context, mark.mark_data, true)
					glottkin_marks_of_nurgle:apply_shared_mark_cooldown(mark.mark_data, context:initiative():record_key())
				end
			end

			if glottkin_marks_of_nurgle_config.is_leveling_up_mark == false then
				glottkin_marks_of_nurgle:set_current_active_marks_count()
				glottkin_marks_of_nurgle:apply_initiative_sets_cap_bundle()
			end
		end,
		true
	)

	core:add_listener(
		"glottkin_marks_of_nurgle_character_upgraded",
		"ScriptEventCharacterUpgraded",
		function(context)
			local old_character = context:character()
			return old_character
				and not old_character:is_null_interface()
				and old_character:faction():name() == glottkin_marks_of_nurgle_config.faction_key
		end,
		function(context)
			glottkin_marks_of_nurgle:transfer_mark_to_character(context:character(), context:target_character())
		end,
		true
	)

	core:add_listener(
		"glottkin_marks_of_nurgle_settlement_initiative",
		"RegionInitiativeActivationChangedEvent",
		function(context)
			local mark_key = string.split(context:initiative():record_key(), "_level")
			return glottkin_marks_of_nurgle_config.marks[mark_key[1]]
		end,
		function(context)
			local region = context:region()
			local is_active = context:active()

			local mark_key = string.split(context:initiative():record_key(), "_level")
			local mark = glottkin_marks_of_nurgle_config.marks[mark_key[1]]

			if is_active and mark.setup_mark_progression and is_function(mark.setup_mark_progression) then
				if glottkin_marks_of_nurgle_config.is_leveling_up_mark == false then
					mark.mark_data.target_name = region:name()
					mark.setup_mark_progression(context, mark.mark_data, mark.mark_effects)
				end
			elseif mark.remove_mark and is_function(mark.remove_mark) then
				if glottkin_marks_of_nurgle_config.is_leveling_up_mark == false then
					mark.remove_mark(context, mark.mark_data, true)
					glottkin_marks_of_nurgle:apply_shared_mark_cooldown(mark.mark_data, context:initiative():record_key())
				end
			end

			if glottkin_marks_of_nurgle_config.is_leveling_up_mark == false then
				glottkin_marks_of_nurgle:set_current_active_marks_count()
				glottkin_marks_of_nurgle:apply_initiative_sets_cap_bundle()
			end
		end,
		true
	)

	core:add_listener(
		"glottkin_marks_of_nurgle_character_killed",
		"CharacterConvalescedOrKilled",
		true, -- always true here because characters might have gotten reassigned and no longer be a part of Glottkin's faction
		function(context)
			local character = context:character()
			local remove_progress = not character:is_alive()
			glottkin_marks_of_nurgle:remove_mark_with_cqi_or_name(character:command_queue_index(), nil, remove_progress)
		end,
		true
	)

	core:add_listener(
		"glottkin_marks_of_nurgle_region_faction_changed",
		"RegionFactionChangeEvent",
		function(context)
			return context:previous_faction():name() == glottkin_marks_of_nurgle_config.faction_key
		end,
		function(context)
			local region = context:region()
			glottkin_marks_of_nurgle:remove_mark_with_cqi_or_name(nil, region:name(), true)
		end,
		true
	)

	core:add_listener(
		"maggot_lords_army_assist",
		"CharacterCharacterTargetAction",
		function(context)
			return context:character():faction():name() == glottkin_marks_of_nurgle_config.faction_key and context:ability() == "assist_army"
		end,
		function(context)
			glottkin_marks_of_nurgle:apply_effect_bundle_to_maggot_lords()
		end,
		true
	)

	core:add_listener(
		"maggot_lords_leave_force",
		"CharacterLeavesMilitaryForce",
		function(context)
			return context:character():faction():name() == glottkin_marks_of_nurgle_config.faction_key
		end,
		function(context)
			glottkin_marks_of_nurgle:apply_effect_bundle_to_maggot_lords()
		end,
		true
	)

	core:add_listener(
		"maggot_lords_merge_completed",
		"CampaignArmiesMergeCompleted",
		true,
		function(context)
		local target_character = context:target_character()
		local has_compatible_target_force = target_character
			and target_character:faction()
			and target_character:faction():name() == glottkin_marks_of_nurgle_config.faction_key
			and target_character:has_military_force()
		if has_compatible_target_force then
			local target_force = target_character:has_military_force()
			if target_force then
				glottkin_marks_of_nurgle:apply_effect_bundle_to_maggot_lords()
			end
		end
		local source_character = context:character()
		local has_compatible_source_force = source_character
			and source_character:faction()
			and source_character:faction():name() == glottkin_marks_of_nurgle_config.faction_key
			and source_character:has_military_force()
			if has_compatible_source_force then
					local source_force = source_character:has_military_force()
				if source_force then
					glottkin_marks_of_nurgle:apply_effect_bundle_to_maggot_lords()
				end
			end
		end,
		true
	)

	core:add_listener(
		"glottkin_marks_of_nurgle_purchase_mark",
		"ContextTriggerEvent",
		function(context)
			return context.string:starts_with("glottkin_purchase_mark:")
		end,
		function(context)
			local splits = context.string:split(":")
			local mark_key = splits[2]

			for mark_key_prefix, mark_data in dpairs(glottkin_marks_of_nurgle_config.marks) do
				if mark_key:starts_with(mark_key_prefix) then
					local purchase_cost = mark_data.mark_data.purchase_cost or glottkin_marks_of_nurgle_config.default_purchase_cost
					local faction = cm:get_faction(glottkin_marks_of_nurgle_config.faction_key)
					cm:pooled_resource_transaction(faction:pooled_resource_manager(), purchase_cost)
					mark_data.mark_data.purchased = true
					glottkin_marks_of_nurgle:setup_marks_shared_state_values()
					local state_name = glottkin_marks_of_nurgle_config.current_marks_purchased_shared_state_value_key
					local num_purchased_marks = cm:model():shared_states_manager():get_state_as_float_value(state_name) or 0
					num_purchased_marks = 1 + num_purchased_marks
					cm:set_script_state(state_name, num_purchased_marks)
					break
				end
			end
		end,
		true
	)

	core:add_listener(
		"glottkin_marks_of_nurgle_research_completed",
		"ResearchCompleted",
		function(context)
			return context:faction():name() == glottkin_marks_of_nurgle_config.faction_key
		end,
		function(context)
			local faction = context:faction()
			local current_marks_amount = glottkin_marks_of_nurgle:get_current_active_marks_count()

			if context:technology() == glottkin_marks_of_nurgle_config.tech_blessing_of_the_marked_key then
				glottkin_marks_of_nurgle:updated_blessing_of_the_mark_tech_effect(faction)
			end
			if context:technology() == glottkin_marks_of_nurgle_config.tech_ascension_of_the_rot_lord_key then
				glottkin_marks_of_nurgle_persistent.mark_progression_loss_enabled = false
			end
			if context:technology() == glottkin_marks_of_nurgle_config.tech_rotten_relics_key then
				glottkin_marks_of_nurgle:updated_rotten_relics_tech_effect(faction)
			end
		end,
		true
	)

	core:add_listener(
		"glottkin_marks_of_nurgle_character_recruited",
		"CharacterRecruited",
		function(context)
			return context:character():faction():name() == glottkin_marks_of_nurgle_config.faction_key
		end,
		function(context)
			local character = context:character()
			for _, value in dpairs(glottkin_marks_of_nurgle_config.marks) do
				local mark_data = value.mark_data
				if not string.find(mark_data.initiative_set_key, "settlements") then
					local character_initiative_set = character:character_details():lookup_character_initiative_set_by_key(mark_data.initiative_set_key)
					glottkin_marks_of_nurgle:setup_new_bearer_initiative_set(character_initiative_set, mark_data)
				end
			end
			glottkin_marks_of_nurgle:updated_blessing_of_the_mark_tech_effect(context:character():faction())
		end,
		true
	)

	core:add_listener(
		"glottkin_marks_of_nurgle_garden_settlement_type_converted",
		"SettlementTypeConvertedEvent",
		function(context)
			local settlement = context:settlement()
			local settlement_type_key = settlement:settlement_type_key()
			return (settlement_type_key == glottkin_gardens_of_nurgle_config.major_garden_key or settlement_type_key == glottkin_gardens_of_nurgle_config.minor_garden_key)
				and settlement:faction():name() == glottkin_marks_of_nurgle_config.faction_key
		end,
		function(context)
			local region = context:settlement():region()
			for _, value in dpairs(glottkin_marks_of_nurgle_config.marks) do
				local mark_data = value.mark_data
				if string.find(mark_data.initiative_set_key, "settlements") then
					local region_initiative_set = region:lookup_region_initiative_set_by_key(mark_data.initiative_set_key)
					glottkin_marks_of_nurgle:setup_new_bearer_initiative_set(region_initiative_set, mark_data)
				end
			end
		end,
		true
	)

	core:add_listener(
		"Glottkin_Marks_Notification_Souls_Progression",
		"PooledResourceEffectChangedEvent",
		function(context)
			return context:resource():key() == glottkin_marks_of_nurgle_config.souls_progression_pooled_resource_key
		end,
		function(context)
			cm:set_script_state(glottkin_marks_of_nurgle_config.ui_notification_shared_state_name, true)
		end,
		true
	)

	if not glottkin_marks_of_nurgle_persistent.mission_has_been_issued then
		core:add_listener(
			"wh3_dlc29_marks_of_nurgle_faction_turn_start_mission_listener",
			"FactionTurnStart",
			function(context)
				return context:faction():name() == glottkin_marks_of_nurgle_config.faction_key and cm:turn_number() >= 4
			end,
			function(context)
				glottkin_marks_of_nurgle:trigger_marked_mission()
				glottkin_marks_of_nurgle_persistent.mission_has_been_issued = true
				core:remove_listener("wh3_dlc29_marks_of_nurgle_faction_turn_start_mission_listener")
			end,
			true
		)
	end

	core:add_listener(
		"wh3_dlc29_marks_of_nurgle_marked_mission_listener",
		"GlottkinMarksOfNurgleLevelChanged",
		function(context)
			local glottkin_faction = cm:get_faction(glottkin_marks_of_nurgle_config.faction_key)
			return cm:mission_is_active_for_faction(glottkin_faction, glottkin_marks_of_nurgle_config.narrative_marked_by_nurgle.mission_key)
		end,
		function(context)
			if context.stored_table.current_mark_level >= 2 then
				cm:complete_scripted_mission_objective(episode_glottkin.faction_key, glottkin_marks_of_nurgle_config.narrative_marked_by_nurgle.mission_key, glottkin_marks_of_nurgle_config.narrative_marked_by_nurgle.mission_key, true)
				core:remove_listener("wh3_dlc29_marks_of_nurgle_marked_mission_listener")
			end
		end,
		true
	)

	core:add_listener(
		"Glottkin_Mission",
		"MissionSucceeded",
		function(context)
			return context:mission():mission_record_key() == glottkin_marks_of_nurgle_config.narrative_marked_by_nurgle.mission_key
		end,
		function(context)
			local faction = context:faction() 
			if faction:is_human() then
				cm:add_units_to_faction_mercenary_pool(faction:command_queue_index(), "wh3_main_nur_inf_nurglings_0", 2)
			end
		end,
		true
	)
end

function glottkin_marks_of_nurgle:get_mercenary_pool_unit(region, unit_key)
	if unit_key == "" or not region or region:is_null_interface() then
		return nil
	end

	local mercenary_pool_unit_list = region:province():mercenary_pool():mercenary_pool_units()
	if mercenary_pool_unit_list:is_empty() then
		return nil
	end

	local faction_key = glottkin_marks_of_nurgle_config.faction_key

	for i = 0, mercenary_pool_unit_list:num_items() - 1 do
		local pool_unit = mercenary_pool_unit_list:item_at(i)
		if unit_key == pool_unit:unit_record():key() then
			local restriction_key = pool_unit:faction_restriction_key()
			if restriction_key == faction_key or restriction_key == "" then
				return pool_unit
			end
		end
	end

	return nil
end

-- Move one point of glottkin scripted capacity into the expiry source so total cap is unchanged until next round cleanup.
function glottkin_marks_of_nurgle:defer_province_mercenary_pool_scripted_capacity(pool_unit)
	if not pool_unit or pool_unit:is_null_interface() then
		return
	end

	local source = glottkin_marks_of_nurgle_config.province_mercenary_pool_scripted_capacity_source
	local scripted_bonus = pool_unit:scripted_capacity_bonus_for_source(source)
	if scripted_bonus <= 0 then
		return
	end

	local expiry_source = glottkin_marks_of_nurgle_config.province_mercenary_pool_scripted_capacity_expiry_source
	local expiry_bonus = pool_unit:scripted_capacity_bonus_for_source(expiry_source)
	-- Add to expiry first so current_max never dips mid-call (avoids unit_count clamp).
	cm:set_mercenary_pool_unit_scripted_capacity_bonus(pool_unit, expiry_bonus + 1, expiry_source, cm:model():turn_number() + 1)
	cm:set_mercenary_pool_unit_scripted_capacity_bonus(pool_unit, scripted_bonus - 1, source)
end

function glottkin_marks_of_nurgle:add_gifted_units_to_province_mercenary_pool(region, unit_key, amount)
	if not region or region:is_null_interface() then
		return false
	end

	amount = amount or 1
	local pool_unit = self:get_mercenary_pool_unit(region, unit_key)
	if not pool_unit then
		script_error("ERROR - GLOTTKIN - Unit "..tostring(unit_key).." is missing from the province pool of "..region:name().." - Contact Alex C.")
		return false
	end

	local source = glottkin_marks_of_nurgle_config.province_mercenary_pool_scripted_capacity_source
	cm:set_mercenary_pool_unit_scripted_capacity_bonus(pool_unit, pool_unit:scripted_capacity_bonus_for_source(source) + amount, source)
	cm:add_units_to_province_mercenary_pool_by_region(region:name(), unit_key, amount)

	local settlement = region:settlement()
	if settlement and not settlement:is_null_interface() then
		local last_popup_turns = glottkin_marks_of_nurgle_persistent.gifted_unit_event_last_popup_turn_by_unit_key
		local current_turn = cm:turn_number()

		local should_popup = last_popup_turns[unit_key] ~= current_turn

		local event_index = glottkin_marks_of_nurgle_config.gifted_unit_event_popup_index
		if should_popup then
			last_popup_turns[unit_key] = current_turn
		else
			event_index = glottkin_marks_of_nurgle_config.gifted_unit_event_list_only_index
		end

		cm:show_message_event_located(
			glottkin_marks_of_nurgle_config.faction_key,
			"event_feed_strings_text_wh3_dlc29_event_feed_string_scripted_event_gifted_unit_title",
			"land_units_onscreen_name_" .. pool_unit:unit_record():land_unit(), -- dynamic unit name
			"event_feed_strings_text_wh3_dlc29_event_feed_string_scripted_event_gifted_unit_secondary_detail",
			settlement:logical_position_x(),
			settlement:logical_position_y(),
			true,
			event_index
		)
	end

	return true
end

function glottkin_marks_of_nurgle:setup_province_mercenary_pool_scripted_capacity_cleanup()
	core:add_listener(
		"glottkin_province_mercenary_pool_scripted_capacity_cleanup",
		"UnitTrained",
		function(context)
			local unit = context:unit()
			if unit:faction():name() ~= glottkin_marks_of_nurgle_config.faction_key then
				return false
			end

			local military_force = unit:military_force()
			if not military_force or military_force:is_null_interface() then
				return false
			end

			local general = military_force:general_character()
			if general:is_null_interface() or not general:has_region() then
				return false
			end

			local source = glottkin_marks_of_nurgle_config.province_mercenary_pool_scripted_capacity_source
			local pool_unit = glottkin_marks_of_nurgle:get_mercenary_pool_unit(general:region(), unit:unit_key())
			return pool_unit ~= nil and pool_unit:scripted_capacity_bonus_for_source(source) > 0
		end,
		function(context)
			local unit = context:unit()
			local general = unit:military_force():general_character()

			local pool_unit = glottkin_marks_of_nurgle:get_mercenary_pool_unit(general:region(), unit:unit_key())
			glottkin_marks_of_nurgle:defer_province_mercenary_pool_scripted_capacity(pool_unit)
		end,
		true
	)
end

function glottkin_marks_of_nurgle:remove_mark_with_cqi_or_name (target_cqi, target_name, remove_progress)
	local create_mark_notification = function(mark_key)
		cm:set_script_state(glottkin_marks_of_nurgle_config.ui_notification_shared_state_name, true)
		local mark_shared_state = mark_key .. glottkin_marks_of_nurgle_config.ui_notification_mark_shared_state_suffix
		cm:set_script_state(mark_shared_state, true)
	end

    local unequip_mark = function(mark_data)
        local _, bearer_initiative_set = glottkin_marks_of_nurgle:lookup_mark_bearer_initiative_set(mark_data)
        local threshold_level = glottkin_marks_of_nurgle:get_mark_level_from_string(mark_data.mark_current_level_key)
        if threshold_level >= 0 then
            local initiative_to_deactivate_key = mark_data.mark_initiative_key_prefix .. tostring(threshold_level)
            cm:toggle_initiative_active(bearer_initiative_set, initiative_to_deactivate_key, false)
        end
    end

	for key, value in dpairs(glottkin_marks_of_nurgle_config.marks) do
		if target_cqi ~= nil and value.mark_data.target_cqi ~= nil then
			if target_cqi == value.mark_data.target_cqi and value.remove_mark and is_function(value.remove_mark, remove_progress) then
                unequip_mark(value.mark_data)
				value.remove_mark(nil, value.mark_data)
				if not remove_progress then
					create_mark_notification(key)
				end
			end
		elseif target_name ~= nil and value.mark_data.target_name ~= nil  then
			if target_name == value.mark_data.target_name and value.remove_mark and is_function(value.remove_mark, remove_progress) then
                unequip_mark(value.mark_data)
				value.remove_mark(nil, value.mark_data)
				if not remove_progress then
					create_mark_notification(key)
				end
			end
		end
	end

	glottkin_marks_of_nurgle:set_current_active_marks_count()
	glottkin_marks_of_nurgle:apply_initiative_sets_cap_bundle()
end

function glottkin_marks_of_nurgle:setup_marks_shared_state_values ()
	for key, value in dpairs(glottkin_marks_of_nurgle_config.marks) do
		for i = 0, glottkin_marks_of_nurgle_config.maximum_mark_level do
			cm:set_script_state(key .. "_level_" .. tostring(i), value.mark_data.pooled_resource_key)
			cm:set_script_state(key .. "_level_" .. tostring(i) .. "_upgrade_description", value.mark_data.upgrade_description_text)
			cm:set_script_state(key .. "_level_" .. tostring(i) .. "_purchased", value.mark_data.purchased)
			if value.mark_data.progression_loss_percentage and value.mark_data.progression_loss_percentage[i+1] then
				cm:set_script_state(key .. "_level_" .. tostring(i) .. "_removal_progression_cost", value.mark_data.progression_loss_percentage[i+1])
			end

			if not value.mark_data.purchased then
				local purchase_cost_key = value.mark_data.purchase_cost or glottkin_marks_of_nurgle_config.default_purchase_cost
				cm:set_script_state(key .. "_level_" .. tostring(i) .. "_purchase_resource_cost_key", purchase_cost_key)
			end
		end

		-- Mark level up requirements, needed for UI
		local requirements = ""
		for requirement_text_key, requirement_val in dpairs(value.requirements_ui_strings) do
			if requirements ~= "" then
				requirements = requirements .. ";"
			end

			requirements = requirements .. requirement_text_key .. "-" .. tostring(requirement_val)
		end
		cm:set_script_state(key .. glottkin_marks_of_nurgle_config.mark_requirements_shared_state_suffix, requirements)
	end
end

-- Used when we launch the game, in order to properly set the events listeners of the marks progression
function glottkin_marks_of_nurgle:setup_marks_progression ()
	for key, value in dpairs(glottkin_marks_of_nurgle_config.marks) do
		if (value.mark_data.target_cqi ~= nil and value.mark_data.target_cqi ~= 0) or (value.mark_data.target_name ~= nil and value.mark_data.target_name ~= "") then
			value.setup_mark_progression(nil, value.mark_data, value.mark_effects)
		end
	end
end

function glottkin_marks_of_nurgle:get_maximum_marks_count()
	return cm:model():shared_states_manager():get_state_as_float_value(glottkin_marks_of_nurgle_config.maximum_marks_shared_state_value_key)
end

function glottkin_marks_of_nurgle:get_current_active_marks_count()
	return cm:model():shared_states_manager():get_state_as_float_value(glottkin_marks_of_nurgle_config.current_marks_equipped_shared_state_value_key)
end

function glottkin_marks_of_nurgle:set_maximum_marks_count()
	cm:set_script_state(glottkin_marks_of_nurgle_config.maximum_marks_shared_state_value_key, table.size(glottkin_marks_of_nurgle_config.marks))
end

function glottkin_marks_of_nurgle:set_current_active_marks_count()
	local count = 0
	for key, value in dpairs(glottkin_marks_of_nurgle_config.marks) do
		if value.mark_data.target_cqi ~= nil and value.mark_data.target_cqi ~= 0 then
			count = count + 1
		elseif value.mark_data.target_name ~= nil and value.mark_data.target_name ~= "" then
			count = count + 1
		end
	end

	cm:set_script_state(glottkin_marks_of_nurgle_config.current_marks_equipped_shared_state_value_key, count)
	glottkin_marks_of_nurgle:updated_blessing_of_the_mark_tech_effect(cm:get_faction(glottkin_marks_of_nurgle_config.faction_key))
	glottkin_marks_of_nurgle:updated_rotten_relics_tech_effect(cm:get_faction(glottkin_marks_of_nurgle_config.faction_key))
end

function glottkin_marks_of_nurgle:apply_initiative_sets_cap_bundle_for_count(active_marks_count)
	local custom_effect_bundle = cm:create_new_custom_effect_bundle(glottkin_marks_of_nurgle_config.scripted_bundle_marks_cap_key)
	custom_effect_bundle:add_effect(glottkin_marks_of_nurgle_config.effect_heroes_marks_set_cap, "faction_to_character_own_unseen", -active_marks_count)
	custom_effect_bundle:add_effect(glottkin_marks_of_nurgle_config.effect_lords_marks_set_cap, "faction_to_character_own_unseen", -active_marks_count)
	custom_effect_bundle:add_effect(glottkin_marks_of_nurgle_config.effect_hybrid_marks_set_cap, "faction_to_character_own_unseen", -active_marks_count)
	custom_effect_bundle:add_effect(glottkin_marks_of_nurgle_config.effect_settlements_marks_set_cap, "faction_to_region_own", -active_marks_count)
	cm:apply_custom_effect_bundle_to_faction(custom_effect_bundle, cm:get_faction(glottkin_marks_of_nurgle_config.faction_key))
end

function glottkin_marks_of_nurgle:apply_initiative_sets_cap_bundle()
	glottkin_marks_of_nurgle:apply_initiative_sets_cap_bundle_for_count(glottkin_marks_of_nurgle:get_current_active_marks_count())
end

function glottkin_marks_of_nurgle:get_cached_character(cached_character, character)
	for i = 1, #cached_character do
		if cached_character[i].character_cqi == character:command_queue_index() then
			return cached_character[i]
		end
	end
end

function glottkin_marks_of_nurgle:cache_enemy_characters_before_battle(character_list, force, secondary_forces)
	for i = 0, force:character_list():num_items() - 1 do
		table.add_unique(character_list, force:character_list():item_at(i):command_queue_index())
	end

	if not is_null(secondary_forces) then
		for i = 0, secondary_forces:num_items() - 1 do
			local current_force = secondary_forces:item_at(i)
			local current_force_characters = current_force:military_force():character_list()
			for j = 0, current_force_characters:num_items() - 1 do
				table.add_unique(character_list, current_force_characters:item_at(j):command_queue_index())
			end
		end
	end

	return character_list
end

function glottkin_marks_of_nurgle:lookup_mark_bearer_initiative_set(mark_data)
	local faction = cm:get_faction(glottkin_marks_of_nurgle_config.faction_key)
	local faction_initiative_set = faction:lookup_faction_initiative_set_by_key(mark_data.initiative_set_key)
	local bearer_initiative_set = faction_initiative_set

	if mark_data.target_cqi ~= nil and mark_data.target_cqi ~= 0 then
		bearer_initiative_set = cm:get_character_by_cqi(mark_data.target_cqi):character_details():lookup_character_initiative_set_by_key(mark_data.initiative_set_key)
	elseif mark_data.target_name ~= nil and mark_data.target_name ~= "" then
		local region = cm:get_region(mark_data.target_name)
		if region ~= nil and region:is_null_interface() == false then
			bearer_initiative_set = region:lookup_region_initiative_set_by_key(mark_data.initiative_set_key)
		end
	end

	return faction_initiative_set, bearer_initiative_set
end

function glottkin_marks_of_nurgle:apply_shared_mark_cooldown(mark_data, initiative_key)
	local faction = cm:get_faction(glottkin_marks_of_nurgle_config.faction_key)
	if not faction or faction:is_null_interface() then
		return
	end

	local faction_initiative_set = faction:lookup_faction_initiative_set_by_key(mark_data.initiative_set_key)
	if faction_initiative_set:is_null_interface() == false then
		cm:apply_initiative_cooldown(faction_initiative_set, initiative_key)
	end

	if string.find(mark_data.initiative_set_key, "settlements") then
		local region_list = faction:region_list()
		for i = 0, region_list:num_items() - 1 do
			local region = region_list:item_at(i)
			local region_initiative_set = region:lookup_region_initiative_set_by_key(mark_data.initiative_set_key)
			if region_initiative_set:is_null_interface() == false then
				cm:apply_initiative_cooldown(region_initiative_set, initiative_key)
			end
		end
	else
		local character_list = faction:character_list()
		for i = 0, character_list:num_items() - 1 do
			local character = character_list:item_at(i)
			local char_initiative_set = character:character_details():lookup_character_initiative_set_by_key(mark_data.initiative_set_key)
			if char_initiative_set:is_null_interface() == false then
				cm:apply_initiative_cooldown(char_initiative_set, initiative_key)
			end
		end
	end
end

-- A new bearer's initiative set comes straight from the database, so levels above 0 are still locked on it.
-- Bring it in line with the level the mark has already reached, including any remaining shared cooldown.
function glottkin_marks_of_nurgle:setup_new_bearer_initiative_set(initiative_set, mark_data)
	if initiative_set == nil or initiative_set:is_null_interface() then
		return
	end

	local mark_level = glottkin_marks_of_nurgle:get_mark_level_from_string(mark_data.mark_current_level_key)
	if mark_level == 0 then
		return
	end

	local level_0_key = mark_data.mark_initiative_key_prefix .. "0"
	local current_level = mark_data.mark_initiative_key_prefix .. mark_level
	cm:toggle_initiative_script_locked(initiative_set, level_0_key, true, "", false)
	cm:toggle_initiative_script_locked(initiative_set, current_level, false, "", false)

	local faction = cm:get_faction(glottkin_marks_of_nurgle_config.faction_key)
	if not faction or faction:is_null_interface() then
		return
	end

	local faction_initiative_set = faction:lookup_faction_initiative_set_by_key(mark_data.initiative_set_key)
	if faction_initiative_set:is_null_interface() == false then
		local remaining_cooldown = faction_initiative_set:initiative_cooldown_remaining(current_level)
		if remaining_cooldown > 0 then
			cm:apply_initiative_cooldown(initiative_set, current_level, remaining_cooldown)
		end
	end
end

function glottkin_marks_of_nurgle:apply_initiative_upgrade_script_locks(mark_data, initiative_key, locked, faction_initiative_set, bearer_initiative_set)
	cm:toggle_initiative_script_locked(faction_initiative_set, initiative_key, locked, "", false)

	local faction = cm:get_faction(glottkin_marks_of_nurgle_config.faction_key)
	if not faction or faction:is_null_interface() then
		return
	end

	if string.find(mark_data.initiative_set_key, "settlements") then
		-- Toggle this initiative for every owned region
		local region_list = faction:region_list()
		for i = 0, region_list:num_items() - 1 do
			local region = region_list:item_at(i)
			local region_initiative_set = region:lookup_region_initiative_set_by_key(mark_data.initiative_set_key)
			if region_initiative_set:is_null_interface() == false then
				cm:toggle_initiative_script_locked(region_initiative_set, initiative_key, locked, "", false)
			end
		end
	else
		-- Toggle this initiative for every character
		local character_list = faction:character_list()
		for i = 0, character_list:num_items() - 1 do
			local character = character_list:item_at(i)
			local char_initiative_set = character:character_details():lookup_character_initiative_set_by_key(mark_data.initiative_set_key)
			if char_initiative_set:is_null_interface() == false then
				cm:toggle_initiative_script_locked(char_initiative_set, initiative_key, locked, "", false)
			end
		end
	end
end

-- Transfer an equipped character mark onto a CUS replacement character (e.g. devote to Nurgle).
-- We use is_leveling_up_mark=true so deactivate/activate do not clear the bearer, apply shared cooldown, or wipe progression.
function glottkin_marks_of_nurgle:transfer_mark_to_character(old_character, new_character)
	if not old_character or old_character:is_null_interface() or not new_character or new_character:is_null_interface() then
		return
	end

	local old_cqi = old_character:cqi()
	local mark_data = nil

	for _, value in dpairs(glottkin_marks_of_nurgle_config.marks) do
		if value.mark_data.target_cqi ~= nil and value.mark_data.target_cqi == old_cqi then
			mark_data = value.mark_data
			break
		end
	end

	if mark_data == nil then
		return
	end

	local mark_level = glottkin_marks_of_nurgle:get_mark_level_from_string(mark_data.mark_current_level_key)
	if mark_level < 0 then
		return
	end

	local initiative_key = mark_data.mark_initiative_key_prefix .. tostring(mark_level)
	local level_0_key = mark_data.mark_initiative_key_prefix .. "0"
	local old_initiative_set = old_character:character_details():lookup_character_initiative_set_by_key(mark_data.initiative_set_key)
	local new_initiative_set = new_character:character_details():lookup_character_initiative_set_by_key(mark_data.initiative_set_key)

	if old_initiative_set:is_null_interface() or new_initiative_set:is_null_interface() then
		return
	end

	local initiative_to_activate = new_initiative_set:lookup_initiative_by_key(initiative_key)
	if initiative_to_activate:is_null_interface() then
		return
	end

	local faction = cm:get_faction(glottkin_marks_of_nurgle_config.faction_key)
	local faction_initiative_set = nil
	if faction and not faction:is_null_interface() then
		faction_initiative_set = faction:lookup_faction_initiative_set_by_key(mark_data.initiative_set_key)
	end

	glottkin_marks_of_nurgle_config.is_leveling_up_mark = true

	local equipped_marks_count = glottkin_marks_of_nurgle:get_current_active_marks_count()
	glottkin_marks_of_nurgle:apply_initiative_sets_cap_bundle_for_count(math.max(0, equipped_marks_count - 1))

	cm:toggle_initiative_active(old_initiative_set, initiative_key, false)

	mark_data.target_cqi = new_character:cqi()

	cm:toggle_initiative_script_locked(new_initiative_set, level_0_key, true, "", false)
	cm:toggle_initiative_script_locked(new_initiative_set, initiative_key, false, "", false)
	if faction_initiative_set and faction_initiative_set:is_null_interface() == false then
		cm:toggle_initiative_script_locked(faction_initiative_set, initiative_key, false, "", false)
	end

	cm:toggle_initiative_active(new_initiative_set, initiative_key, true)

	glottkin_marks_of_nurgle:set_current_active_marks_count()
	glottkin_marks_of_nurgle:apply_initiative_sets_cap_bundle()
	glottkin_marks_of_nurgle_config.is_leveling_up_mark = false
end

function glottkin_marks_of_nurgle:apply_initiative_upgrade(mark_data, threshold_key)
	local threshold_current_level = glottkin_marks_of_nurgle:get_mark_level_from_string(threshold_key)
	local threshold_previous_level = glottkin_marks_of_nurgle:get_mark_level_from_string(mark_data.mark_current_level_key)

	if threshold_current_level <= threshold_previous_level then
		return
	end

	mark_data.mark_current_level_key = threshold_key

	-- Make sure we don't go above max level
	if threshold_current_level > glottkin_marks_of_nurgle_config.maximum_mark_level then
		threshold_current_level = glottkin_marks_of_nurgle_config.maximum_mark_level
	end

	local faction_initiative_set, bearer_initiative_set = glottkin_marks_of_nurgle:lookup_mark_bearer_initiative_set(mark_data)

	local initiative_to_activate_key = mark_data.mark_initiative_key_prefix .. threshold_current_level
	local initiative_to_activate = bearer_initiative_set:lookup_initiative_by_key(initiative_to_activate_key)

	local initiative_to_deactivate_key = nil
	if threshold_previous_level >= 0 then
		initiative_to_deactivate_key = mark_data.mark_initiative_key_prefix .. threshold_previous_level
	end

	glottkin_marks_of_nurgle_config.is_leveling_up_mark = true

	if initiative_to_deactivate_key ~= nil then
		-- Bearer loses active-mark +1 when the old level deactivates, but cap still counts this mark as equipped.
		-- Temporarily ease the cap penalty so the bearer keeps a 0/1 slot during the level swap.
		local equipped_marks_count = glottkin_marks_of_nurgle:get_current_active_marks_count()
		glottkin_marks_of_nurgle:apply_initiative_sets_cap_bundle_for_count(math.max(0, equipped_marks_count - 1))

		cm:toggle_initiative_active(bearer_initiative_set, initiative_to_deactivate_key, false)
		glottkin_marks_of_nurgle:apply_initiative_upgrade_script_locks(mark_data, initiative_to_deactivate_key, true, faction_initiative_set, bearer_initiative_set)
	end

	if initiative_to_activate:is_null_interface() == false then
		glottkin_marks_of_nurgle:apply_initiative_upgrade_script_locks(mark_data, initiative_to_activate_key, false, faction_initiative_set, bearer_initiative_set)
		cm:toggle_initiative_active(bearer_initiative_set, initiative_to_activate_key, true)
	else
		script_error("ERROR - MARKS OF NURGLE - No initiative with key : " .. initiative_to_activate_key .. " found. Contact Alex C.");
	end

	glottkin_marks_of_nurgle:set_current_active_marks_count()
	glottkin_marks_of_nurgle:apply_initiative_sets_cap_bundle()
	glottkin_marks_of_nurgle_config.is_leveling_up_mark = false

	local event_data = {
		mark_data = mark_data,
		current_mark_level = threshold_current_level,
	}
	core:trigger_event("GlottkinMarksOfNurgleLevelChanged", event_data)
end

function glottkin_marks_of_nurgle:get_mark_level_from_string (mark_level_string)
	local key_splitted = string.split(mark_level_string, "_")
	return tonumber(key_splitted[#key_splitted])
end

function glottkin_marks_of_nurgle:is_character_legendary_lord(character)
	return campaign_traits.legendary_lord_defeated_traits[character:character_subtype_key()] or false
end

-- character_list is CHARACTER_LIST_SCRIPT_INTERFACE
function glottkin_marks_of_nurgle:is_glottkin_faction_in_character_list(character_list)
	if is_null(character_list) then
		return false
	end

	local character_list_table = {}
	for i = 0, character_list:num_items() - 1 do
		if character_list:item_at(i):faction():name() == glottkin_marks_of_nurgle_config.faction_key then
			return true
		end
	end

	return false
end

function glottkin_marks_of_nurgle:apply_effect_bundle_to_maggot_lords()
	local orghotts_daemonspew_embedded_mf_cqi = glottkin_marks_of_nurgle:orghotts_daemonspew_embedded()
	local morbidex_twiceborn_embedded_mf_cqi = glottkin_marks_of_nurgle:morbidex_twiceborn_embedded()
	local bloab_rotspawned_embedded_mf_cqi = glottkin_marks_of_nurgle:bloab_rotspawned_embedded()
	local gutrot_spume_embedded_mf_cqi = glottkin_marks_of_nurgle:gutrot_spume_embedded()

	local values = {
		orghotts = tonumber(orghotts_daemonspew_embedded_mf_cqi),
		morbidex = tonumber(morbidex_twiceborn_embedded_mf_cqi),
		bloab = tonumber(bloab_rotspawned_embedded_mf_cqi),
		gutrot = tonumber(gutrot_spume_embedded_mf_cqi)
	}

	local groups = {}
	for name, num in pairs(values) do
		if num ~= nil then
			groups[num] = groups[num] or {}
			table.insert(groups[num], name)
		end
	end

	local any_duplicate = false
	for num, holders in pairs(groups) do
		if #holders >= 3 then
			any_duplicate = true
			--Add Effect bundle to force
		end
	end
end

function glottkin_marks_of_nurgle:orghotts_daemonspew_embedded()
	local faction = cm:get_faction(glottkin_marks_of_nurgle_config.faction_key);
	local character_list = faction:character_list()
	for i = 0, character_list:num_items() - 1 do
		local character = character_list:item_at(i)
		local subtype_key = character:character_subtype_key()
		if subtype_key == glottkin_marks_of_nurgle_config.orghotts or subtype_key == glottkin_marks_of_nurgle_config.orghotts_lord then
			if character:is_embedded_in_military_force() then
				local mf_cqi = character:embedded_in_military_force():command_queue_index()
				return mf_cqi
			end
		end
	end
end

function glottkin_marks_of_nurgle:morbidex_twiceborn_embedded()
	local faction = cm:get_faction(glottkin_marks_of_nurgle_config.faction_key);
	local character_list = faction:character_list()
	for i = 0, character_list:num_items() - 1 do
		local character = character_list:item_at(i)
		local subtype_key = character:character_subtype_key()
		if subtype_key == glottkin_marks_of_nurgle_config.morbidex or subtype_key == glottkin_marks_of_nurgle_config.morbidex_lord then
			if character:is_embedded_in_military_force() then
				local mf_cqi = character:embedded_in_military_force():command_queue_index()
				return mf_cqi
			end
		end
	end
end

function glottkin_marks_of_nurgle:bloab_rotspawned_embedded()
	local faction = cm:get_faction(glottkin_marks_of_nurgle_config.faction_key);
	local character_list = faction:character_list()
	for i = 0, character_list:num_items() - 1 do
		local character = character_list:item_at(i)
		local subtype_key = character:character_subtype_key()
		if subtype_key == glottkin_marks_of_nurgle_config.bloab or subtype_key == glottkin_marks_of_nurgle_config.bloab_lord then
			if character:is_embedded_in_military_force() then
				local mf_cqi = character:embedded_in_military_force():command_queue_index()
				return mf_cqi
			end
		end
	end
end

function glottkin_marks_of_nurgle:gutrot_spume_embedded()
	local faction = cm:get_faction(glottkin_marks_of_nurgle_config.faction_key);
	local character_list = faction:character_list()
	for i = 0, character_list:num_items() - 1 do
		local character = character_list:item_at(i)
		local subtype_key = character:character_subtype_key()
		if subtype_key == glottkin_marks_of_nurgle_config.gutrot_spume then
			if character:is_embedded_in_military_force() then
				local mf_cqi = character:embedded_in_military_force():command_queue_index()
				return mf_cqi
			end
		end
	end
end

function glottkin_marks_of_nurgle:level_up_random_unit_in_force(mf, level)
	if not mf:has_general() then
		return
	end

	local unit_list = mf:unit_list()
	local candidates = {}
	local selected_unit = nil

	for i = 0, unit_list:num_items() - 1 do
		local unit = unit_list:item_at(i)
		local is_ror_unit, _ = string.find(unit:unit_key(), "_ror")
		if unit:unit_caste() ~= "hero" and unit:unit_caste() ~= "lord" and not is_ror_unit and unit:experience_level() < 9 then
			table.insert(candidates, unit)
		end
	end

	selected_unit = candidates[cm:random_number(#candidates, 1)] 

	if selected_unit then
		cm:add_experience_to_unit(selected_unit, glottkin_marks_of_nurgle_config.add_lowest_xp_unit_rank)

		local x, y = mf:general_character():logical_position_x(), mf:general_character():logical_position_y()
		cm:show_message_event_located(
			glottkin_marks_of_nurgle_config.faction_key,
			"event_feed_strings_text_wh3_dlc29_event_feed_string_scripted_event_rank_up_unit_title",
			"land_units_onscreen_name_" .. selected_unit:unit_key(), 
			"event_feed_strings_text_wh3_dlc29_event_feed_string_scripted_event_rank_up_unit_secondary_detail",
			x,
			y,
			true,
			1978
		)
	end
end

function glottkin_marks_of_nurgle:provide_random_unit(unit_pool)
	local unit_pool = unit_pool[cm:model():random_int(1, #unit_pool)]
	return unit_pool
end

function glottkin_marks_of_nurgle:award_random_unit_with_warband_upgrade(current_mf_cqi)
	local mf = cm:get_military_force_by_cqi(current_mf_cqi)
	if not mf:has_general() then
		return
	end

	print("  >>>>>>>>>>>> WARBAND UPGRADE <<<<<<<<<<<<")
	local unit_list = mf:unit_list()
	local possible_units = weighted_list:new()
	local castes_to_avoid = {"hero", "lord", "war_beast", "artillery"}
	for i = 0, unit_list:num_items() - 1 do
		local unit = unit_list:item_at(i)
		local caste = unit:unit_caste()
		if unit:can_upgrade_unit() and not table.contains(castes_to_avoid, caste) then
			local unit_upgrades = unit:get_upgrades()
			for j = 0, unit_upgrades:num_items() - 1 do
				local curr_upgrade = unit_upgrades:item_at(j)
				-- Lets filter out the upgrades that are not relevant from a design perspective in the context of a gift to the player as the gain is minimal or nonexistent.
				-- Upgrades that only makes a unit switch ascendency (undivided to nurgle), or switch weapon (unit to unit_great_axes)
				if not string.ends_with(curr_upgrade:key(), "to_self") and not string.ends_with(curr_upgrade:key(), "und_to_nur") and curr_upgrade:can_upgrade() then
					local unit_to_upgrade = {
						unit = unit,
						upgrade = curr_upgrade
					}
					possible_units:add_item(unit_to_upgrade, 1)
				end
			end
		end
	end

	if #possible_units.items <= 0 then
		return
	end

	local selected_unit_data, index = possible_units:weighted_select()
	local chosen_target_unit_list = selected_unit_data.upgrade:target_units()
	local chosen_unit_key = chosen_target_unit_list[cm:random_number(#chosen_target_unit_list, 1)]
	local char_lookup = cm:char_lookup_str(mf:general_character())

	cm:remove_unit_from_character(char_lookup, selected_unit_data.unit:unit_key())
	cm:grant_unit_to_character(char_lookup, chosen_unit_key, true, 1)

	print("  >>>>>>>>>>>> WARBAND UPGRADE <<<<<<<<<<<< "..chosen_unit_key)
	local x, y = mf:general_character():logical_position_x(), mf:general_character():logical_position_y()
	cm:show_message_event_located(
		glottkin_marks_of_nurgle_config.faction_key,
		"event_feed_strings_text_wh3_dlc29_event_feed_string_scripted_event_warband_upgrade_unit_title",
		"land_units_onscreen_name_" .. selected_unit_data.unit:unit_key(), 
		"event_feed_strings_text_wh3_dlc29_event_feed_string_scripted_event_warband_upgrade_unit_secondary_detail",
		x,
		y,
		true,
		1978
	)
	print("  >>>>>>>>>>>> WARBAND UPGRADE <<<<<<<<<<<< x="..x.." - y="..y)
end

function glottkin_marks_of_nurgle:remove_progression_from_mark(mark_data)
	if glottkin_marks_of_nurgle_persistent.mark_progression_loss_enabled == false then
		return
	end
	local progression_pooled_resource = cm:get_faction(glottkin_marks_of_nurgle_config.faction_key):pooled_resource_manager():resource(mark_data.pooled_resource_key)
	local progression_resource_value = progression_pooled_resource:value()
	local mark_level = glottkin_marks_of_nurgle:get_mark_level_from_string(mark_data.mark_current_level_key) + 1 -- Table starts at 1 and level keys starts at 0
	local progression_percentage_value = mark_data.progression_loss_percentage[mark_level]
	local progression_value_to_remove = progression_resource_value * progression_percentage_value
	if glottkin_marks_of_nurgle_persistent.mark_progression_loss_bonus > 0 then
		progression_value_to_remove = progression_value_to_remove - (progression_value_to_remove * glottkin_marks_of_nurgle_persistent.mark_progression_loss_bonus)
	end
	cm:faction_add_pooled_resource(glottkin_marks_of_nurgle_config.faction_key, mark_data.pooled_resource_key, glottkin_marks_of_nurgle_config.pooled_resource_progression_factor_key, - progression_value_to_remove)
end

function glottkin_marks_of_nurgle:updated_blessing_of_the_mark_tech_effect(faction)
	if not faction:has_technology(glottkin_marks_of_nurgle_config.tech_blessing_of_the_marked_key) then
		return
	end

	local force_list = faction:military_force_list()

	for i = 0, force_list:num_items() - 1 do 
		local mf = force_list:item_at(i)
		if not mf:is_armed_citizenry() then
			local current_marks_amount = glottkin_marks_of_nurgle:get_current_active_marks_count()
			local scripted_bonus_value = cm:get_factions_bonus_value(faction, glottkin_marks_of_nurgle_config.scripted_value_corruption_per_mark)
			local bundle = cm:create_new_custom_effect_bundle(glottkin_marks_of_nurgle_config.scripted_bundle_blessing_of_the_marked_key)
			bundle:set_effect_value_by_key(glottkin_marks_of_nurgle_config.scripted_effect_blessing_of_the_marked_key, current_marks_amount * scripted_bonus_value)
			cm:apply_custom_effect_bundle_to_force(bundle, mf)
		end
	end
end

function glottkin_marks_of_nurgle:updated_rotten_relics_tech_effect(faction)
	if not faction:has_technology(glottkin_marks_of_nurgle_config.tech_rotten_relics_key) then
		return
	end

	if faction:has_effect_bundle(glottkin_marks_of_nurgle_config.scripted_bundle_rotten_relics_key) then
		cm:remove_effect_bundle(glottkin_marks_of_nurgle_config.scripted_bundle_rotten_relics_key, glottkin_marks_of_nurgle_config.faction_key)
	end

	local current_marks_amount = glottkin_marks_of_nurgle:get_current_active_marks_count()

	-- battle healing cap +7% per active marks
	local scripted_bonus_value = cm:get_factions_bonus_value(faction, glottkin_marks_of_nurgle_config.scripted_value_healing_cap_per_mark)
	local bundle = cm:create_new_custom_effect_bundle(glottkin_marks_of_nurgle_config.scripted_bundle_rotten_relics_key)
	bundle:set_effect_value_by_key(glottkin_marks_of_nurgle_config.scripted_effect_rotten_relics_key, current_marks_amount * scripted_bonus_value)
	cm:apply_custom_effect_bundle_to_faction(bundle, faction)
end

function glottkin_marks_of_nurgle:get_marked_lords()
 	return glottkin_marks_of_nurgle:get_marked_characters(
		function(character)
			return character:has_military_force()
		end
	)
end

function glottkin_marks_of_nurgle:get_marked_heroes()
	return glottkin_marks_of_nurgle:get_marked_characters(
		function(character)
			return character:has_military_force() == false
		end
	)
end

function glottkin_marks_of_nurgle:get_marked_characters(predicate)
	local chars = {}
	for _, mark in dpairs(glottkin_marks_of_nurgle_config.marks) do
		if mark.mark_data.target_cqi ~= nil  and mark.mark_data.target_cqi ~= 0 then
			local char = cm:get_character_by_cqi(mark.mark_data.target_cqi)
			if char then
				if predicate == nil or predicate(char) then
					table.insert(chars, char)
				end
			end
		end
	end
	return chars
end

function glottkin_marks_of_nurgle:search_for_unit_set_in_forces(unit_set, character, character_list)
	local mil_forces = {}

	table.insert(mil_forces, character:military_force())
	for i = 0, character_list:num_items() - 1 do
		table.insert(mil_forces, character_list:item_at(i):military_force())
	end

	for i = 1, #mil_forces do
		for j = 0, mil_forces[i]:unit_list():num_items() - 1 do
			local curr_unit = mil_forces[i]:unit_list():item_at(j)
			if curr_unit:is_unit_in_set(unit_set) then
				return true
			end
		end
	end

	return false
end

function glottkin_marks_of_nurgle:trigger_marked_mission()

	local function add_configured_objectives(mm, objectives, mission_key, payloads)
		for i = 1, #objectives do
			local objective = objectives[i]

			mm:add_new_objective(objective.type)

			for j = 1, #objective.conditions do
				mm:add_condition(objective.conditions[j])
			end

			if payloads then
				for k = 1, #payloads do
					mm:add_payload(payloads[k])
				end
			end
		end
	end

	local mm = mission_manager:new(glottkin_marks_of_nurgle_config.faction_key, glottkin_marks_of_nurgle_config.narrative_marked_by_nurgle.mission_key)

	add_configured_objectives(
		mm,
		{
			generate_SCRIPTED_MISSION_objective(
				glottkin_marks_of_nurgle_config.narrative_marked_by_nurgle.mission_key, 
				"mission_text_text_" .. glottkin_marks_of_nurgle_config.narrative_marked_by_nurgle.override_text
			),
		},
		glottkin_marks_of_nurgle_config.narrative_marked_by_nurgle.mission_key,
		glottkin_marks_of_nurgle_config.narrative_marked_by_nurgle.payload
	)

	mm:trigger()
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		for key, value in dpairs(glottkin_marks_of_nurgle_config.marks) do
			cm:save_named_value(key .. "_saved", value.mark_data, context)
		end
		cm:save_named_value("glottkin_marks_of_nurgle_persistent", glottkin_marks_of_nurgle_persistent, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			for key, value in dpairs(glottkin_marks_of_nurgle_config.marks) do
				value.mark_data = cm:load_named_value(key .. "_saved", value.mark_data, context)
			end
			glottkin_marks_of_nurgle_persistent = cm:load_named_value("glottkin_marks_of_nurgle_persistent", glottkin_marks_of_nurgle_persistent, context)
			if not glottkin_marks_of_nurgle_persistent.gifted_unit_event_last_popup_turn_by_unit_key then
				glottkin_marks_of_nurgle_persistent.gifted_unit_event_last_popup_turn_by_unit_key = {}
			end
		end
	end
)