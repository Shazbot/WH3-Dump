mother_ostankya_features = {
	ostankya_faction = "wh3_dlc24_ksl_daughters_of_the_forest",
	restricted_kislev_buildings = {
		"wh3_main_ksl_barracks_1",
		"wh3_main_ksl_barracks_2",
		"wh3_main_ksl_barracks_3",
		"wh3_main_ksl_cavalry_1",
		"wh3_main_ksl_cavalry_2",
		"wh3_main_ksl_cavalry_3",
		"wh3_main_ksl_stables_1",
		"wh3_main_ksl_stables_2",
		"wh3_main_ksl_ice_guard_1",
		"wh3_main_ksl_ice_guard_2",
		"wh3_main_ksl_artillery_1",
		"wh3_main_ksl_artillery_2",
		"wh3_main_ksl_gold_1",
		"wh3_main_ksl_gold_2",
		"wh3_main_ksl_gold_3"
	},
	regions_to_unlock_buildings = {
		wh3_main_chaos_region_erengrad = true,
		wh3_main_chaos_region_kislev = true,
		wh3_main_chaos_region_praag = true,
		wh3_main_combi_region_erengrad = true,
		wh3_main_combi_region_kislev = true,
		wh3_main_combi_region_praag = true
	},
	low_corruption_bundle_key = "wh3_dlc24_bundle_ostankya_low_corruption",
	corruption_threshold = 20,
	spirit_essence = "wh3_dlc24_ksl_spirit_essence",
	hex_ritual_category = "OSTANKYA_HEX_RITUAL",
	hex_6_key = "wh3_dlc24_ritual_ksl_hex_6",
	hex_6_ie_mission_key = "wh3_dlc24_ie_ksl_mother_ostankya_hex_malediction_of_ruin",
	hex_6_roc_mission_key = "wh3_dlc24_ksl_mother_ostankya_hex_malediction_of_ruin",
	hex_6_story_panel_key = "wh3_dlc24_story_panel_mother_ostankya_hex_6",
	hex_data = {
		purification_chant = {
			mission = {
				wh3_main_chaos = "wh3_dlc24_camp_narrative_chaos_mother_ostankya_defeat_initial_enemy_01",
				main_warhammer = "wh3_dlc24_camp_narrative_ie_mother_ostankya_defeat_initial_enemy_01"
			},
			spirit_essence_requirement = false,
			hex = "wh3_dlc24_ritual_ksl_hex_5",
			story_panel = "wh3_dlc24_story_panel_mother_ostankya_hex_5",
			tech = "wh3_dlc24_tech_ksl_ostankya_witches_hut_hex_upgrade_5",
			incident = "wh3_dlc24_incident_mother_ostankya_hex_5",
			incident_received = false,
			remove_bundle = "wh3_dlc24_ritual_ksl_hex_5",
			script_key = "hexes_victory_5"
		},
		covens_cursemark = {
			hex = "wh3_dlc24_ritual_ksl_hex_1",
			mission = {
				wh3_main_chaos = "wh3_dlc24_ksl_mother_ostankya_hex_covens_cursemark",
				main_warhammer = "wh3_dlc24_ie_ksl_mother_ostankya_hex_covens_cursemark"
			},
			spirit_essence_requirement = 100,
			story_panel = "wh3_dlc24_story_panel_mother_ostankya_hex_1",
			tech = "wh3_dlc24_tech_ksl_ostankya_witches_hut_hex_upgrade_1",
			incident = "wh3_dlc24_incident_mother_ostankya_hex_1",
			incident_received = "wh3_dlc24_incident_mother_ostankya_hex_1_received",
			persistent_vfx_duration = 5,
			script_key = "hexes_victory_1"
		},
		jinxed_land = {
			mission = {
				wh3_main_chaos = "wh3_dlc24_ksl_mother_ostankya_hex_jinxed_land",
				main_warhammer = "wh3_dlc24_ie_ksl_mother_ostankya_hex_jinxed_land"
			},
			hex = {
				-- ie
				"wh3_dlc24_ritual_ksl_hex_2_ie_the_witchwood",
				"wh3_dlc24_ritual_ksl_hex_2_ie_forest_of_gloom",
				"wh3_dlc24_ritual_ksl_hex_2_ie_gaean_vale",
				"wh3_dlc24_ritual_ksl_hex_2_ie_gryphon_wood",
				"wh3_dlc24_ritual_ksl_hex_2_ie_heart_of_the_jungle",
				"wh3_dlc24_ritual_ksl_hex_2_ie_jungles_of_chian",
				"wh3_dlc24_ritual_ksl_hex_2_ie_laurelorn_forest",
				"wh3_dlc24_ritual_ksl_hex_2_ie_oak_of_ages",
				"wh3_dlc24_ritual_ksl_hex_2_ie_the_haunted_forest",
				"wh3_dlc24_ritual_ksl_hex_2_ie_the_sacred_pools",
				-- roc
				"wh3_dlc24_ritual_ksl_hex_2_roc_the_haunted_forest",
				"wh3_dlc24_ritual_ksl_hex_2_roc_laurelorn_forest",
				"wh3_dlc24_ritual_ksl_hex_2_roc_fort_dolganyeir"
			},
			spirit_essence_requirement = 300,
			story_panel = "wh3_dlc24_story_panel_mother_ostankya_hex_2",
			tech = "wh3_dlc24_tech_ksl_ostankya_witches_hut_hex_upgrade_2",
			incident = "wh3_dlc24_incident_mother_ostankya_hex_2",
			incident_received = "wh3_dlc24_incident_mother_ostankya_hex_2_received",
			remove_bundle = "wh3_dlc24_ritual_ksl_hex_2",
			script_key = "hexes_victory_2"
		},
		bewitching_allure = {
			mission = {
				wh3_main_chaos = "wh3_dlc24_ksl_mother_ostankya_hex_bewitching_allure",
				main_warhammer = "wh3_dlc24_ie_ksl_mother_ostankya_hex_bewitching_allure"
			},
			hex = "wh3_dlc24_ritual_ksl_hex_4",
			spirit_essence_requirement = 700,
			story_panel = "wh3_dlc24_story_panel_mother_ostankya_hex_4",
			tech = "wh3_dlc24_tech_ksl_ostankya_witches_hut_hex_upgrade_4",
			incident = "wh3_dlc24_incident_mother_ostankya_hex_4",
			incident_received = "wh3_dlc24_incident_mother_ostankya_hex_4_received",
			persistent_vfx_duration = 5,
			script_key = "hexes_victory_4"
		},
		recreant_spirit = {
			mission = {
				wh3_main_chaos = "wh3_dlc24_ksl_mother_ostankya_hex_recreant_spirit",
				main_warhammer = "wh3_dlc24_ie_ksl_mother_ostankya_hex_recreant_spirit"
			},
			hex = "wh3_dlc24_ritual_ksl_hex_3",
			spirit_essence_requirement = 1500,
			story_panel = "wh3_dlc24_story_panel_mother_ostankya_hex_3",
			tech = "wh3_dlc24_tech_ksl_ostankya_witches_hut_hex_upgrade_3",
			incident = "wh3_dlc24_incident_mother_ostankya_hex_3",
			incident_received = "wh3_dlc24_incident_mother_ostankya_hex_3_received",
			script_key = "hexes_victory_3"
		}
	},
	ingredient_slot_techs = {
		wh3_dlc24_tech_ksl_ostankya_witches_hut_unlock = true,
		wh3_dlc24_tech_ksl_ostankya_witches_hut_unlock_2 = true
	},
	ingredient_unlocks = {
		wh3_dlc24_ingredient_bones_nehekharan_spine = {
			races = {
				"wh2_dlc09_tmb_tomb_kings"
			}
		},
		wh3_dlc24_ingredient_bones_rotting_clavicle = {
			races = {
				"wh_main_vmp_vampire_counts",
				"wh2_dlc11_cst_vampire_coast"
			}
		},
		wh3_dlc24_ingredient_bones_well_gnawed_bone = {
			races = {
				"wh3_main_ogr_ogre_kingdoms"
			}
		},
		wh3_dlc24_ingredient_horns_dawi_zharr_horn = {
			races = {
				"wh3_dlc23_chd_chaos_dwarfs"
			}
		},
		wh3_dlc24_ingredient_horns_gor_horn = {
			races = {
				"wh_dlc03_bst_beastmen"
			}
		},
		wh3_dlc24_ingredient_horns_horned_one_trophy = {
			races = {
				"wh2_main_lzd_lizardmen"
			}
		},
		wh3_dlc24_ingredient_skulls_daemon_skull = {
			races = {
				"wh3_main_dae_daemons",
				"wh3_main_nur_nurgle",
				"wh3_main_sla_slaanesh",
				"wh3_main_tze_tzeentch",
				"wh3_main_kho_khorne"
			}
		},
		wh3_dlc24_ingredient_skulls_elven_skull = {
			races = {
				"wh2_main_hef_high_elves"
			}
		},
		wh3_dlc24_ingredient_skulls_marauder_skull = {
			races = {
				"wh_main_chs_chaos",
				"wh_dlc08_nor_norsca"
			}
		},
		wh3_dlc24_ingredient_stone_brynduraz = {
			races = {
				"wh_main_dwf_dwarfs"
			}
		},
		wh3_dlc24_ingredient_stone_stone_dog_ornament = {
			races = {
				"wh3_main_cth_cathay"
			}
		},
		wh3_dlc24_ingredient_stone_warpstone_fragment = {
			races = {
				"wh2_main_skv_skaven"
			}
		},
		wh3_dlc24_ingredient_teeth_cold_ones_fang = {
			races = {
				"wh2_main_def_dark_elves"
			}
		},
		wh3_dlc24_ingredient_teeth_incisor_of_man = {
			races = {
				"wh_main_emp_empire"
			}
		},
		wh3_dlc24_ingredient_teeth_orc_molar = {
			races = {
				"wh_main_grn_greenskins"
			}
		},
		wh3_dlc24_ingredient_wood_bark_of_ages = {
			races = {
				"wh_dlc05_wef_wood_elves"
			}
		},
		wh3_dlc24_ingredient_wood_branch_of_arden = {
			races = {
				"wh_main_brt_bretonnia"
			}
		},
		wh3_dlc24_ingredient_wood_ursun_totem = {
			start_unlocked = true
		}
	},
	ai_cook_recipe_turns_interval = 4
}

function mother_ostankya_features:initialise()
	local ostankya_faction_obj = cm:get_faction(self.ostankya_faction)
	if not ostankya_faction_obj then return false end
	
	if cm:is_new_game() then
		-- unlock starting ingredients
		for ingredient, data in pairs(self.ingredient_unlocks) do
			if data.start_unlocked then
				self:unlock_ingredient(ingredient, true)
			end
		end
		
		-- unlock recipes
		local faction_cco = cco("CcoCampaignFaction", self.ostankya_faction)
		
		for i = 0, faction_cco:Call("CookingSystem.GetPossibleRecipeRecords.Size") - 1 do
			cm:unlock_cooking_recipe(ostankya_faction_obj, faction_cco:Call("CookingSystem.GetPossibleRecipeRecords.At(" .. i .. ").Key"))
		end
	
		-- tracks the spirit essence pooled resource for the faction
		cm:start_pooled_resource_tracker_for_faction(self.ostankya_faction)

		-- lock buildings
		for i = 1, #self.restricted_kislev_buildings do
			cm:add_event_restricted_building_record_for_faction(self.restricted_kislev_buildings[i], self.ostankya_faction, "ostankya_building_lock");
		end
		
		-- lock techs
		for hex, data in pairs(self.hex_data) do
			cm:lock_technology(self.ostankya_faction, data.tech)
		end
	end
	
	self:update_hex_spirit_essence_requirements()
	
	-- unlock ingredients when races are defeated in battle
	core:add_listener(
		"battle_completed_ingredient_unlock",
		"BattleCompleted",
		function()
			return cm:pending_battle_cache_faction_won_battle(self.ostankya_faction) and (cm:model():pending_battle():battle_type() ~= "land_normal" or cm:turn_number() > 1) -- ignore land battles on turn 1
		end,
		function()
			for ingredient, data in pairs(self.ingredient_unlocks) do
				if data.races then
					for i = 1, #data.races do
						if cm:pending_battle_cache_faction_won_battle_against_culture(self.ostankya_faction, data.races[i]) then
							self:unlock_ingredient(ingredient)
							break
						end
					end
				end
			end
		end,
		true
	)
	
	if ostankya_faction_obj:is_human() then
		-- unlock hex when mission completes
		core:add_listener(
			"hex_unlock_mission",
			"MissionSucceeded",
			function(context)
				return context:faction():name() == self.ostankya_faction
			end,
			function(context)
				local mission_key = context:mission():mission_record_key()
				local unlocked_hex_data = false
				
				-- lookup the respective hex data
				for hex, data in pairs(self.hex_data) do
					if data.mission[cm:get_campaign_name()] == mission_key then
						unlocked_hex_data = data
						break
					end
				end
				
				if unlocked_hex_data then
					local faction = context:faction()
					local faction_name = faction:name()
					local count = cm:get_saved_value("hexes_unlocked_count") or 0
					
					self:unlock_hex(unlocked_hex_data.hex)
					
					cm:unlock_technology(faction_name, unlocked_hex_data.tech)
					
					cm:trigger_incident(faction_name, unlocked_hex_data.story_panel, true, true)
					count = count + 1
					cm:set_saved_value("hexes_unlocked_count", count)
					cm:complete_scripted_mission_objective(self.ostankya_faction, "wh_main_long_victory", unlocked_hex_data.script_key, true)
					
					if count == 3 then -- short victory counter
						cm:complete_scripted_mission_objective("wh3_dlc24_ksl_daughters_of_the_forest", "wh_main_short_victory", "hexes_short_some", true)
					elseif count == 5 then
						cm:callback(function() cm:trigger_incident(faction_name, self.hex_6_story_panel_key, true, true) end, 0.2)
						cm:unlock_ritual(faction, self.hex_6_key)
					end
				end
			end,
			true
		)
		
		-- Final Hex battle long victory listener
		core:add_listener(
			"ostankya_wins_final_battle", 
			"MissionSucceeded",
			function(context)
				local mission_key = context:mission():mission_record_key()
				return context:faction():name() == self.ostankya_faction and (mission_key == self.hex_6_ie_mission_key or mission_key == self.hex_6_roc_mission_key)
			end,
			function()
				core:svr_save_registry_bool("mother_ostankya_win", true)
				cm:register_instant_movie("warhammer3/ksl/mother_ostankya_win")
				
				cm:complete_scripted_mission_objective(self.ostankya_faction, "wh_main_long_victory", "hexes_long_all", true)
				
				local culture = cm:get_saved_value("hex_6_culture")
				
				if culture then
					local faction_list = cm:get_factions_by_culture(culture)
					for i = 1, #faction_list do
						local current_faction = faction_list[i]
						
						if not current_faction:is_dead() then
							cm:apply_effect_bundle(self.hex_6_key, current_faction:name(), -1)
						end
					end
				end
			end,
			true
		)
	else 
		cm:add_turn_countdown_event(self.ostankya_faction, self.ai_cook_recipe_turns_interval, "ScriptEventAIOstankyaCooksRecipe")

		core:add_listener(
			"ai_ostankya_cooks_recipe",
			"ScriptEventAIOstankyaCooksRecipe",
			true,
			function()
				if not ostankya_faction_obj:is_dead() then
					local possible_recipes = {}
					local faction_cco = cco("CcoCampaignFaction", self.ostankya_faction)
					
					for i = 0, faction_cco:Call("CookingSystem.GetPossibleRecipeRecords.Size") - 1 do
						table.insert(possible_recipes, faction_cco:Call("CookingSystem.GetPossibleRecipeRecords.At(" .. i .. ").Key"))
					end
					local recipe = possible_recipes[cm:random_number(#possible_recipes)]
					cm:force_cook_recipe(ostankya_faction_obj, recipe, false, false)
				end
				
				cm:add_turn_countdown_event(self.ostankya_faction, self.ai_cook_recipe_turns_interval, "ScriptEventAIOstankyaCooksRecipe")
			end,
			true
		)
	end
	
	core:add_listener(
		"mother_ostankya_turn_start",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == self.ostankya_faction
		end,
		function(context)
			local faction = context:faction()
			
			-- add spirit essence when a province has low corruption
			for _, province in model_pairs(faction:provinces()) do
				local region = province:regions():item_at(0)
				
				if province:has_effect_bundle(self.low_corruption_bundle_key) then
					cm:remove_effect_bundle_from_faction_province(self.low_corruption_bundle_key, region)
				end
				
				if cm:get_total_corruption_value_in_region(region) < self.corruption_threshold then
					cm:apply_effect_bundle_to_faction_province(self.low_corruption_bundle_key, region, 0)
				end
			end
			
			-- trigger any pending hex battle missions
			if faction:is_human() then
				for hex, data in pairs(self.hex_data) do
					if cm:get_saved_value(hex .. "_mission_triggered") == 1 then
						cm:trigger_mission(self.ostankya_faction, data.mission[cm:get_campaign_name()], true)
						cm:set_saved_value(hex .. "_mission_triggered", 2)
					end
				end
			end
		end,
		true
	)
	
	-- tracks the pooled resource spent
	core:add_listener(
		"spirit_essence_spent",
		"PooledResourceChanged",
		function(context)
			return context:resource():key() == self.spirit_essence
		end,
		function(context)
			self:update_hex_spirit_essence_requirements()
			
			local spirit_essence_value = self:get_total_spirit_essence_consumed()
			
			for hex, data in pairs(self.hex_data) do
				local save_value = cm:get_saved_value(hex .. "_mission_triggered") or 0
				
				if save_value == true then save_value = 2 end -- old saves were set to true instead of a number
				
				if data.spirit_essence_requirement and spirit_essence_value >= data.spirit_essence_requirement and save_value < 1 then
					if cm:get_faction(self.ostankya_faction):is_human() then
						cm:set_saved_value(hex .. "_mission_triggered", 1)
					else
						self:unlock_hex(data.hex)
						cm:set_saved_value(hex .. "_mission_triggered", 2)
					end
				end
			end
		end,
		true
	)
	
	core:add_listener(
		"hex_performed",
		"RitualCompletedEvent",
		function(context)
			return context:ritual():ritual_category() == self.hex_ritual_category
		end,
		function(context)
			-- pan camera to target when ritual completes
			local faction = context:performing_faction()
			local faction_cqi = faction:command_queue_index()
			local is_local_faction = faction:name() == cm:get_local_faction_name(true)
			local ritual = context:ritual()
			local ritual_key = ritual:ritual_key():gsub("_empowered", "") -- ensure the ritual key isn't the empowered version
			local ritual_target = ritual:ritual_target()
			local target_type = ritual_target:target_type()
			local cached_x, cached_y, cached_d, cached_b, cached_h = cm:get_camera_position()
			local target_faction_cqi = 0
			local region_cqi = 0
			local region_name = false
			local character_cqi = 0
			
			if target_type == "REGION" then
				local region = ritual_target:get_target_region()
				local settlement = region:settlement()
				region_cqi = region:cqi()
				region_name = region:name()
				target_faction_cqi = region:owning_faction():command_queue_index()
				
				if is_local_faction then
					cm:scroll_camera_from_current(true, 1, {settlement:display_position_x(), settlement:display_position_y(), cached_d, cached_b, cached_h})
				end
				
				cm:add_scripted_composite_scene_to_settlement("wh3_dlc24_campaign_mother_ostankya_hex", "wh3_dlc24_campaign_mother_ostankya_hex", region, 0, 0, true, true, true)
			elseif target_type == "MILITARY_FORCE" then
				local mf = ritual_target:get_target_force()
				
				if mf:has_general() then
					target_faction_cqi = mf:faction():command_queue_index()
					character_cqi = mf:general_character():command_queue_index()
					
					cm:callback(
						function()
							local character = cm:get_character_by_cqi(character_cqi)
							
							if character then
								if is_local_faction then
									cm:scroll_camera_from_current(true, 1, {character:display_position_x(), character:display_position_y(), cached_d, cached_b, cached_h})
								end
								
								cm:add_scripted_composite_scene_to_logical_position("wh3_dlc24_campaign_mother_ostankya_hex", "wh3_dlc24_campaign_mother_ostankya_hex", character:logical_position_x(), character:logical_position_y(), 0, 0, true, true, true)
							end
						end,
						0.2
					)
				end
			end
			
			local incident = false
			local incident_received = false
			local remove_bundle = false
			local persistent_vfx_duration = false
			
			-- look up the hex data based on the ritual performed
			local function get_performed_hex_data(data)
				local found_remove_bundle = false
				local found_persistent_vfx_duration = false
				
				if data.remove_bundle then
					found_remove_bundle = data.remove_bundle
				end
				if data.persistent_vfx_duration then
					found_persistent_vfx_duration = data.persistent_vfx_duration
				end
				
				return data.incident, data.incident_received, found_remove_bundle, found_persistent_vfx_duration
			end
			for hex, data in pairs(self.hex_data) do
				if is_table(data.hex) then
					for i = 1, #data.hex do
						if data.hex[i] == ritual_key then
							incident, incident_received, remove_bundle, persistent_vfx_duration = get_performed_hex_data(data)
							break
						end
					end
				elseif data.hex == ritual_key then
					incident, incident_received, remove_bundle, persistent_vfx_duration = get_performed_hex_data(data)
					break
				end
			end
			
			-- remove any effect bundles applied by the ritual payload
			if remove_bundle then
				if region_name then
					cm:remove_effect_bundle_from_region(remove_bundle, region_name)
				else
					cm:remove_effect_bundle_from_characters_force(remove_bundle, character_cqi)
				end
			end
			
			if incident then
				cm:trigger_incident_with_targets(faction_cqi, incident, 0, 0, character_cqi, 0, region_cqi, 0)
			end
			
			if incident_received and faction_cqi ~= target_faction_cqi then
				cm:trigger_incident_with_targets(target_faction_cqi, incident_received, 0, 0, character_cqi, 0, region_cqi, 0)
			end
			
			-- trigger the final battle when hex 6 is performed
			if ritual_key == self.hex_6_key then
				local target_faction = ritual_target:get_target_faction()
				
				cm:remove_effect_bundle(self.hex_6_key, target_faction:name())
				
				cm:lock_ritual(faction, self.hex_6_key)
				
				local mission_key = self.hex_6_roc_mission_key
				local campaign_name = cm:get_campaign_name()
				
				if campaign_name == "main_warhammer" then
					mission_key = self.hex_6_ie_mission_key
				end
				
				local mm = mission_manager:new(self.ostankya_faction, mission_key)
				mm:add_new_objective("FIGHT_SET_PIECE_BATTLE")
				mm:add_condition("set_piece_battle " .. self.hex_6_roc_mission_key)
				if campaign_name == "wh3_main_chaos" then
					mm:add_payload("text_display dummy_wh3_main_survival_forge_of_souls")
				else
					mm:add_payload("text_display dummy_wh3_dlc24_long_campaign_victory")
				end
				mm:add_payload("text_display dummy_wh3_dlc24_mother_ostankya_" .. target_faction:culture())
				mm:add_payload("effect_bundle{bundle_key wh3_dlc20_payload_effect_casualty_replenishment;turns 2;}")
				mm:trigger()
				
				cm:set_saved_value("hex_6_culture", context:ritual_target_faction():culture())
			end
			
			-- remove corruption from province when hex 5 is performed
			if ritual_key:starts_with(self.hex_data.purification_chant.hex) then
				local corruption_types = {
					"chaos",
					"skaven",
					"vampiric",
					"khorne",
					"nurgle",
					"slaanesh",
					"tzeentch",
				}
				
				local prm = ritual_target:get_target_region():province():pooled_resource_manager()
				
				for i = 1, #corruption_types do
					cm:pooled_resource_factor_transaction(prm:resource("wh3_main_corruption_" .. corruption_types[i]), "local_populace", -100)
				end
			end
			
			-- add persistent vfx if needed
			if persistent_vfx_duration then
				if character_cqi > 0 then
					cm:add_character_vfx(character_cqi, "scripted_effect27", false)
					cm:add_turn_countdown_event(cm:get_character_by_cqi(character_cqi):faction():name(), persistent_vfx_duration, "ScriptEventOstankyaCharacterVFXExpires", tostring(character_cqi))
				elseif region_name then
					local garrison_residence = cm:get_region(region_name):garrison_residence()
					local garrison_residence_cqi = garrison_residence:command_queue_index()
					cm:add_garrison_residence_vfx(garrison_residence_cqi, "scripted_effect27", false)
					cm:add_turn_countdown_event(garrison_residence:faction():name(), persistent_vfx_duration, "ScriptEventOstankyaRegionVFXExpires", region_name)
				end
			end
		end,
		true
	)
	
	-- remove persistent vfx when it expires
	core:add_listener(
		"ostankya_remove_vfx",
		"ScriptEventOstankyaCharacterVFXExpires",
		true,
		function(context)
			cm:remove_character_vfx(tonumber(context.string), "scripted_effect27")
		end,
		true
	)
	core:add_listener(
		"ostankya_remove_vfx",
		"ScriptEventOstankyaRegionVFXExpires",
		true,
		function(context)
			cm:remove_garrison_residence_vfx(cm:get_region(context.string):garrison_residence():command_queue_index(), "scripted_effect27")
		end,
		true
	)
	
	core:add_listener(
		"ostankya_incantation_created",
		"ResearchCompleted", 
		function(context)
			return context:faction():name() == self.ostankya_faction 
		end,
		function(context)
			local faction = context:faction()
			local technology = context:technology()
			
			-- unlock ingredient slots
			if self.ingredient_slot_techs[technology] then
				cm:set_faction_max_secondary_cooking_ingredients(faction, cm:model():world():cooking_system():faction_cooking_info(faction):max_secondary_ingredients() + 1)
			end
		end,
		true
	)
	
	if not cm:get_saved_value("ostankya_buildings_unlocked") then
		core:add_listener(
			"ostankya_region_changed_building_unlock",
			"RegionFactionChangeEvent",
			function(context)
				local region = context:region()
				
				return not region:is_abandoned() and self.regions_to_unlock_buildings[region:name()] and region:owning_faction():name() == self.ostankya_faction
			end,
			function()
				self:unlock_buildings()
			end,
			false
		)
		
		-- remove restricted buildings if a region is captured that contains one
		core:add_listener(
			"ostankya_destroy_restricted_buildings",
			"CharacterPerformsSettlementOccupationDecision",
			function(context)
				return context:character():faction():name() == self.ostankya_faction and context:garrison_residence():faction():name() == self.ostankya_faction
			end,
			function(context)
				for _, slot in model_pairs(context:garrison_residence():region():slot_list()) do
					if slot:has_building() then
						for i = 1, #self.restricted_kislev_buildings do
							if slot:building():name() == self.restricted_kislev_buildings[i] then
								cm:region_slot_instantly_dismantle_building(slot)
								break
							end
						end
					end
				end
			end,
			true
		)
	end
		
	core:add_listener(
		"ostankya_forms_alliance",
		"PositiveDiplomaticEvent",
		function(context)
			return (context:proposer():name() == self.ostankya_faction or context:recipient():name() == self.ostankya_faction) and (context:is_military_alliance() or context:is_defensive_alliance() or context:is_vassalage())
		end,
		function(context)
			local proposer = context:proposer()
			local proposer_name = proposer:name()
			local recipient = context:recipient()
			local recipient_name = recipient:name()
			local alliance_race = false
			
			if proposer_name == self.ostankya_faction then
				alliance_race = recipient:culture()
			else
				alliance_race = proposer:culture()
			end
			
			-- find the ingredient to unlock
			for ingredient, data in pairs(self.ingredient_unlocks) do
				if data.races then
					for i = 1, #data.races do
						if data.races[i] == alliance_race then
							self:unlock_ingredient(ingredient)
							break
						end
					end
				end
			end
			
			-- unlock the buildings if necessary
			if not cm:get_saved_value("ostankya_buildings_unlocked") then
				-- delay this by a tick as the treaty isn't created until just after this event
				cm:callback(
					function()
						for region_key, _ in pairs(self.regions_to_unlock_buildings) do
							local region = cm:get_region(region_key)
							
							if region and not region:is_abandoned() then
								local owning_faction = region:owning_faction():name()
								
								if owning_faction == proposer_name or owning_faction == recipient_name then
									self:unlock_buildings()
									return
								end
							end
						end
					end,
					0.2
				)
			end
		end,
		true
	)
end

function mother_ostankya_features:unlock_ingredient(ingredient, hide_incident)
	local faction = cm:get_faction(self.ostankya_faction)
	local cooking_interface = cm:model():world():cooking_system():faction_cooking_info(faction)
	
	if not cooking_interface:is_ingredient_unlocked(ingredient) then
		cm:unlock_cooking_ingredient(faction, ingredient)
		if not hide_incident and faction:is_human() then
			cm:trigger_incident(self.ostankya_faction, "wh3_dlc24_incident_mother_ostankya_ingredient_unlocked", true)
		end
	end
end

function mother_ostankya_features:unlock_hex(hex)
	local faction = cm:get_faction(self.ostankya_faction)
	
	if is_table(hex) then
		for i = 1, #hex do
			cm:unlock_ritual(faction, hex[i])
		end
	else
		cm:unlock_ritual(faction, hex)
	end
end

function mother_ostankya_features:update_hex_spirit_essence_requirements()
	if not cm:get_faction(self.ostankya_faction):is_human() then return end
	
	local spirit_essence_value = self:get_total_spirit_essence_consumed()
	
	for hex, data in pairs(self.hex_data) do
		local hex = data.hex
		
		-- find the first available ritual in the list
		if is_table(hex) then
			for i = 1, #hex do
				if not cco("CcoCampaignFaction", self.ostankya_faction):Call("UnlockableRitualList.Filter(RitualContext.Key == \"" .. hex[i] .. "\").IsEmpty") then
					hex = hex[i]
					break
				end
			end
		end
		
		if data.spirit_essence_requirement then
			common.set_context_value(hex .. "_spirit_essence_remaining", math.max(data.spirit_essence_requirement - spirit_essence_value, 0))
		end
	end
end

function mother_ostankya_features:get_total_spirit_essence_consumed()
	return cm:get_total_pooled_resource_spent_for_faction(self.ostankya_faction, self.spirit_essence, "hexes") + cm:get_total_pooled_resource_spent_for_faction(self.ostankya_faction, self.spirit_essence, "witchs_hut_brews")
end

function mother_ostankya_features:unlock_buildings()
	for i = 1, #self.restricted_kislev_buildings do
		cm:remove_event_restricted_building_record_for_faction(self.restricted_kislev_buildings[i], self.ostankya_faction)
	end
	
	core:remove_listener("ostankya_destroy_restricted_buildings")
	
	cm:set_saved_value("ostankya_buildings_unlocked", true)
end