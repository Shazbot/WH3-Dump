tod_narrative = {
	elspeth_faction_key = "wh_main_emp_wissenland",
	elspeth_intro_mission = "wh3_dlc25_elspeth_narrative_intro",
	elspeth_intro_incident = "wh3_dlc25_story_elspeth_intro",
	elspeth_stage_1_mission = "wh3_dlc25_elspeth_narrative_stage_1",
	elspeth_stage_2_mission = "wh3_dlc25_nemesis_crown_markers_defeat_greenskins",
	incident_prefix = "wh3_dlc25_story_panel_nemesis_crown_0",
	warboss_mission_prefix = "wh3_dlc25_nemesis_crown_warboss_",

	nemesis_crown_effect_bundle = "wh3_dlc25_nemesis_crown_effect_bundle_5_emp",

	latest_character_cqi = 0,

	epilogue_key = "wh3_dlc25_incident_epilogue_elspeth",
	final_battle_victory_condition = "tod_final_battle",

	--total number of narrative stages
	narrative_stage_count = 3,
	
	nemesis_crown_faction_key = "wh3_dlc25_rogue_da_mad_howlerz",
	nemesis_crown_enemies = {
		"wh_main_emp_wissenland",
		"wh_main_emp_middenland",
		"wh_main_emp_hochland",
		"wh_main_emp_ostermark",
		"wh_main_emp_empire",
		"wh_main_emp_ostland",
		"wh_main_emp_nordland",
		"wh_main_emp_talabecland",
		"wh_main_emp_marienburg",
		"wh_main_emp_stirland",
		"wh_main_dwf_karak_kadrin",
		"wh3_main_ksl_ropsmenn_clan",
		"wh3_main_ksl_ungol_kindred",
		"wh3_main_ksl_ursun_revivalists",
		"wh3_dlc24_ksl_daughters_of_the_forest",
		"wh3_main_ksl_druzhina_enclave",
		"wh3_main_ksl_the_ice_court",
		"wh3_main_ksl_the_great_orthodoxy",
		"wh3_main_ksl_brotherhood_of_the_bear",
		"wh3_main_wef_laurelorn",
	},

	narrative_stage = {
		stage_1 = {condition_met = false, has_fired = false},
		stage_2 = {condition_met = false, has_fired = false},
		stage_3 = {condition_met = false, has_fired = false},
	},

	final_mission_key = {
		["wh3_dlc25_nur_tamurkhan"] = "wh_main_long_victory",
		["wh3_dlc25_dwf_malakai"] 	= "wh3_dlc25_mis_dwf_malakai_warpstone_bomb_narrative_battle",
		["wh_main_emp_wissenland"] 	= "wh3_dlc25_nemesis_crown_final_battle_elspeth", 
	},

	movie = {
		wh3_dlc25_nur_tamurkhan = {
			path = "warhammer3/nur/tamurkhan_win", 
			unlock_str = "tamurkhan_win"
		},
		wh3_dlc25_dwf_malakai = {
			path = "warhammer3/dwf/malakai_win", 
			unlock_str = "malakai_win"
		},
		wh_main_emp_wissenland = {
			path = "warhammer3/emp/elspeth_win", 
			unlock_str = "elspeth_win"
		}
	
	},

	warboss_data = {
		spiders = {
			force_key = "spiders",
			is_defeated = false, 
			subtype = "wh_main_grn_goblin_great_shaman", 
			forename = "names_name_2147344880", 
			surname = "names_name_618498202", 
			skill_key = "wh3_dlc25_skill_nemesis_crown_spider_lord",
			unit_list = "wh_main_grn_mon_arachnarok_spider_0,wh_main_grn_mon_arachnarok_spider_0,wh_main_grn_mon_arachnarok_spider_0,wh_main_grn_mon_arachnarok_spider_0,wh_main_grn_mon_arachnarok_spider_0,wh2_dlc16_wef_mon_giant_spiders_0,wh2_dlc16_wef_mon_giant_spiders_0,wh2_dlc16_wef_mon_giant_spiders_0,wh2_dlc16_wef_mon_giant_spiders_0,wh2_dlc16_wef_mon_giant_spiders_0,wh2_dlc16_wef_mon_giant_spiders_0,wh2_dlc16_wef_mon_giant_spiders_0,wh_main_grn_cav_forest_goblin_spider_riders_1,wh_main_grn_cav_forest_goblin_spider_riders_1,wh_main_grn_cav_forest_goblin_spider_riders_1,wh_main_grn_cav_forest_goblin_spider_riders_1,wh_main_grn_cav_forest_goblin_spider_riders_1,wh_main_grn_cav_forest_goblin_spider_riders_1,wh_main_grn_cav_forest_goblin_spider_riders_1",
		},
		
		monsters = {
			force_key = "monsters", 
			is_defeated = false, 
			subtype = "wh_main_grn_orc_warboss", 
			forename = "names_name_35713703", 
			surname = "names_name_2147355449", 
			skill_key = "wh3_dlc25_skill_nemesis_crown_monster_lord",
			unit_list = "wh_main_grn_mon_trolls,wh_main_grn_mon_trolls,wh_main_grn_mon_trolls,wh_main_grn_mon_trolls,wh2_dlc15_grn_mon_river_trolls_0,wh2_dlc15_grn_mon_river_trolls_0,wh2_dlc15_grn_mon_river_trolls_0,wh2_dlc15_grn_mon_stone_trolls_0,wh2_dlc15_grn_mon_stone_trolls_0,wh2_dlc15_grn_mon_stone_trolls_0,wh2_dlc15_grn_mon_stone_trolls_0,wh2_dlc15_grn_mon_rogue_idol_0,wh2_dlc15_grn_mon_rogue_idol_0,wh_main_grn_mon_giant,wh_main_grn_mon_giant,wh_main_grn_mon_giant,wh2_twa03_grn_mon_wyvern_0,wh2_twa03_grn_mon_wyvern_0,wh2_twa03_grn_mon_wyvern_0",
		},
		
		night_goblins = {
			force_key = "night_goblins", 
			is_defeated = false, 
			subtype = "wh_dlc06_grn_night_goblin_warboss", 
			forename = "names_name_2147344759", 
			surname = "names_name_2147352338", 
			skill_key = "wh3_dlc25_skill_nemesis_crown_night_goblin_lord",
			unit_list = "wh_main_grn_inf_night_goblin_fanatics,wh_main_grn_inf_night_goblin_fanatics,wh_main_grn_inf_night_goblin_fanatics,wh_main_grn_inf_night_goblin_fanatics,wh_main_grn_inf_night_goblin_fanatics,wh_main_grn_inf_night_goblin_fanatics,wh_main_grn_inf_night_goblin_fanatics,wh_main_grn_inf_night_goblin_fanatics,wh_main_grn_inf_night_goblin_fanatics_1,wh_main_grn_inf_night_goblin_fanatics_1,wh_main_grn_inf_night_goblin_fanatics_1,wh_main_grn_inf_night_goblin_fanatics_1,wh_main_grn_inf_night_goblin_fanatics_1,wh_main_grn_inf_night_goblin_fanatics_1,wh2_dlc15_grn_cav_squig_hoppers_waaagh_0,wh2_dlc15_grn_cav_squig_hoppers_waaagh_0,wh2_dlc15_grn_cav_squig_hoppers_waaagh_0,wh2_dlc15_grn_cav_squig_hoppers_waaagh_0,wh2_dlc15_grn_cav_squig_hoppers_waaagh_0",
		},
	}
}

---------------------
--------SETUP--------
---------------------

function tod_narrative:initialise()

	--Initialise is only called if Tamurkhan, Elspeth, or Malakai are in ROC and playing SP so we can safely assume only one human faction
	local human_factions = cm:get_human_factions()
	local faction = cm:get_faction(human_factions[1])
	local faction_name = faction:name()

	--Handles faction narrative stage triggers
	self:narrative_trigger_setup(faction_name)
	--Handles Warboss spawning and listening for their defeat
	self:warboss_setup(faction_name)
	
	if cm:is_new_game() == false then
		--Loop through all the warbosses and update saved string 
		--Required for awkward bug if player defeats a force than reloads to before fedeating it the saved string still remembers them being defeated
		for _, warboss in pairs(self.warboss_data) do
			if warboss.is_defeated == true then
				core:svr_save_string("nemesis_crown_" .. warboss.force_key .. "_killed", "1")
			else
				core:svr_save_string("nemesis_crown_" .. warboss.force_key .. "_killed", "0")
			end
		end

	end


	-- handle players completing the campaign
	core:add_listener(
		"player_wins_final_battle",
		"MissionSucceeded",
		function(context)
			local faction_key = context:faction():name()
			if self.final_mission_key[faction_key] then
				return (self.final_mission_key[faction_key]) == context:mission():mission_record_key()
			end
			return false
		end,
		function(context)
			local faction_key = context:faction():name()
			local movie = self.movie[faction_key]
			local win_movie = movie.path
			local win_unlock_key = movie.unlock_str
			cm:set_saved_value("campaign_completed", true)
			
			--firing a scripted event for the Nemesis Crown script to listen for, this will give the players the option to keep or seal crown
			--sending faction_script_interface as the context for the event
			core:trigger_event("ScriptEvent_ToDNarrativeVictory", faction)

			core:svr_save_registry_bool(win_unlock_key, true)
			cm:register_instant_movie(win_movie)

			cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", self.final_battle_victory_condition, true)

			--checking if elspeth is the faction
			if faction_key == self.elspeth_faction_key then
				--removing any remaining nemesis crown forces after final battle for elspeth
				local nc_faction = cm:get_faction(self.nemesis_crown_faction_key)
				if nc_faction:is_null_interface() == false then
					cm:disable_event_feed_events(true, "wh_event_category_conquest", "", "")
					cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "")					
					cm:kill_all_armies_for_faction(nc_faction)
					
					local region_list = nc_faction:region_list()					
					for i = 0, region_list:num_items() - 1 do
						local region = region_list:item_at(i):name()
						cm:set_region_abandoned(region)
					end
					
					cm:callback(
						function() 
							cm:disable_event_feed_events(false, "wh_event_category_conquest", "", "")
							cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "")
						end,
						0.5
					)
				end

				--removing dummy effect bundles for the nemesis crown lords
				cm:remove_effect_bundle("wh3_dlc25_nemesis_crown_reward_monsters", self.elspeth_faction_key)
				cm:remove_effect_bundle("wh3_dlc25_nemesis_crown_reward_night_goblins", self.elspeth_faction_key)
				cm:remove_effect_bundle("wh3_dlc25_nemesis_crown_reward_spiders", self.elspeth_faction_key)

				-- Epilogue
				cm:add_turn_countdown_event(faction_key, 1, "ScriptEventShowEpilogueEvent_TOD", faction_key)
				core:add_listener(
					"epilogue_tod",
					"ScriptEventShowEpilogueEvent_TOD",
					true,
					function(context)
						local faction_key = context.string
						cm:trigger_incident(faction_key, self.epilogue_key, true)
					end,
					false
				)
				
				local elspeth_faction = cm:get_faction(self.elspeth_faction_key)
				local elspeth = elspeth_faction:faction_leader()
				
				local dilemma_builder = cm:create_dilemma_builder("wh3_dlc25_elspeth_narrative_completion_dilemma")
				local payload_builder = cm:create_payload()
			
				local nemesis_effect_bundle_sealed = cm:create_new_custom_effect_bundle("wh3_dlc25_bundle_nemesis_crown_sealed")
				nemesis_effect_bundle_sealed:add_effect("wh_main_effect_force_all_campaign_replenishment_rate", "faction_to_force_own", 10)
				nemesis_effect_bundle_sealed:add_effect("wh_main_effect_force_army_campaign_enable_replenishment_in_foreign_territory", "faction_to_force_own", 1)
				nemesis_effect_bundle_sealed:set_duration(10)
			
				payload_builder:effect_bundle_to_character(elspeth, "wh3_dlc25_nemesis_crown_effect_bundle_5")
				dilemma_builder:add_target("default", elspeth:family_member())
				dilemma_builder:add_choice_payload("FIRST", payload_builder)
				payload_builder:clear()
			
				payload_builder:treasury_adjustment(10000)
				payload_builder:effect_bundle_to_faction(nemesis_effect_bundle_sealed)
				dilemma_builder:add_choice_payload("SECOND", payload_builder)
			
				cm:launch_custom_dilemma_from_builder(dilemma_builder, elspeth_faction)
			end

		end,
		false
	)
end

function tod_narrative:narrative_trigger_setup(faction_name)
	
	--Create listeners for Stages 1 and 3 narrative triggers
	if faction_name == "wh_main_emp_wissenland" then
		
		core:add_listener(
			"ToD_NarrativeStage1_Condition",
			"MissionSucceeded",
			function(context)
				return self.elspeth_intro_mission == context:mission():mission_record_key()				
			end,
			function(context)
				local stage = self.narrative_stage["stage_1"]
				stage.condition_met = true			
			end,
			false
		)

		core:add_listener(
			"ToD_NarrativeStage2_Condition",
			"MissionSucceeded",
			function(context)
				return self.elspeth_stage_1_mission == context:mission():mission_record_key()				
			end,
			function(context)
				local stage = self.narrative_stage["stage_2"]
				stage.condition_met = true			
			end,
			false
		)

		--Defeat Greenskins Forces
		core:add_listener(
			"ToD_NarrativeStage3_Condition",
			"MissionSucceeded",
			function(context)
				return self.elspeth_stage_2_mission == context:mission():mission_record_key()				
			end,
			function(context)
				local stage = self.narrative_stage["stage_3"]
				stage.condition_met = true			
			end,
			false
		)

		core:add_listener(
			"ToD_NarrativeStage3_Condition",
			"MissionCancelled",
			function(context)
				return self.elspeth_stage_2_mission == context:mission():mission_record_key()				
			end,
			function(context)
				local stage = self.narrative_stage["stage_3"]
				stage.condition_met = true			
			end,
			false
		)

		--loop for the 3 stages
		for i = 1, self.narrative_stage_count do
			local stage_string = "stage_" .. i
			core:add_listener(
				"ToD_IncidentStage" .. i,
				"FactionTurnStart",
				function(context)					
					local stage = self.narrative_stage[stage_string]
					return faction_name == context:faction():name() and stage.condition_met and cm:turn_number() >= 2 and stage.has_fired == false
				end,
				function(context)
					local stage = self.narrative_stage[stage_string]		
					cm:trigger_incident(faction_name, self.incident_prefix.. i, true)
					stage.has_fired = true

					if context:faction():name() == self.elspeth_faction_key then
						self:elspeth_stage_mission(i)
					end
				end,
				true
			)

		end

		core:add_listener(
			"ToD_ElspethNarrativeStart",
			"FactionTurnStart",
			function(context)					
				return self.elspeth_faction_key == context:faction():name() and cm:turn_number() == 2
			end,
			function(context)	
				self:start_elspeth_narrative()
				cm:trigger_incident(self.elspeth_faction_key, self.elspeth_intro_incident, true)
			end,
			false
		)

		core:add_listener(
			"ToD_ElspethNarrativeNemesisCrownHunt",
			"FactionTurnEnd",
			function(context)		
				local faction = context:faction()	
				local faction_name = faction:name()	
				if self.elspeth_faction_key == faction_name and cm:mission_is_active_for_faction(faction, self.elspeth_stage_1_mission) then
					local brass_keep = cm:get_region("wh3_main_chaos_region_brass_keep")
					local character_list = brass_keep:characters_in_region()
					for i = 0, character_list:num_items() - 1 do
						local character = character_list:item_at(i)

						if cm:character_is_army_commander(character) and character:faction():name() == self.elspeth_faction_key then
							return true
						end
					end
				end
			end,
			function(context)	
				cm:complete_scripted_mission_objective(self.elspeth_faction_key, self.elspeth_stage_1_mission, self.elspeth_stage_1_mission, true)
			end,
			false
		)
	else
		return false
	end

end

function tod_narrative:start_elspeth_narrative()
	local mm = mission_manager:new(self.elspeth_faction_key, self.elspeth_intro_mission)
				
	mm:add_new_objective("DESTROY_FACTION")

	mm:add_condition("faction wh_main_vmp_vampire_counts")
	mm:add_condition("faction wh_main_vmp_waldenhof")
	mm:add_condition("faction wh3_main_ogr_feastmaster")
	mm:add_condition("confederation_valid")

	mm:add_payload("effect_bundle{bundle_key wh3_dlc25_elspeth_narrative_reward_1;turns 5;}");
	mm:add_payload("money 3000");
	mm:add_payload("text_display dummy_wh3_dlc25_elspeth_narrative");

	mm:set_should_whitelist(false);
	mm:set_mission_issuer("CLAN_ELDERS")

	mm:trigger()
end

function tod_narrative:elspeth_stage_mission(stage, warboss)
	if stage == 1 then
		local mm = mission_manager:new(self.elspeth_faction_key, self.elspeth_stage_1_mission)
					
		mm:add_new_objective("SCRIPTED")

		mm:add_condition("script_key "..self.elspeth_stage_1_mission);
		mm:add_condition("override_text mission_text_text_wh3_dlc25_elspeth_narrative_1");

		mm:add_payload("money 3000");
		mm:add_payload("text_display dummy_wh3_dlc25_elspeth_narrative");

		mm:set_should_whitelist(false);
		mm:set_mission_issuer("CLAN_ELDERS")

		mm:trigger()
	elseif stage == 2 then
		local spawn_loc = {x = 285, y = 72}
		self:spawn_nemesis_crown_forces(1, "wh3_main_chaos_region_hergig", spawn_loc, false)

		-- Add slight delay so that the army can spawn before the mission launches
		cm:callback(function()
			local mm = mission_manager:new(self.elspeth_faction_key, self.elspeth_stage_2_mission)
			local mf_cqi = cm:get_character_by_cqi(self.latest_character_cqi):military_force():command_queue_index()

			mm:add_new_objective("ENGAGE_FORCE")
			
			mm:add_condition("cqi "..mf_cqi)
			mm:add_condition("requires_victory")
			
			mm:add_payload("money 3000")
			mm:add_payload("effect_bundle{bundle_key wh3_dlc25_elspeth_narrative_reward_2;turns 5;}");
			mm:add_payload("text_display dummy_wh3_dlc25_elspeth_narrative");
			
			mm:set_should_whitelist(false);
			mm:set_mission_issuer("CLAN_ELDERS")

			mm:trigger()
		end, 0.2)
	elseif stage == 3 then
		if warboss then
			local mission_key = self.warboss_mission_prefix .. warboss.force_key

			--create mission to defeat special warbosses
			local mm = mission_manager:new(self.elspeth_faction_key, mission_key)
		
			mm:add_new_objective("ENGAGE_FORCE")

			mm:add_condition("cqi ".. warboss.mf_cqi)
			mm:add_condition("requires_victory")
			
			mm:add_payload("money 5000")
			mm:add_payload("effect_bundle{bundle_key wh3_dlc25_nemesis_crown_reward_".. warboss.force_key..";turns 0;}")

			mm:set_should_whitelist(false);
			mm:set_mission_issuer("CLAN_ELDERS")

			mm:trigger()
		end
	end
end



-------------------------------------------------------
-------------------- Incursion management -------------
-------------------------------------------------------


function tod_narrative:warboss_setup(faction_name)

	--Spawn Stage 3 Warbosses and trigger final battle mission
	core:add_listener(
		"ToD_Stage3_WarbossSpawn",
		"IncidentOccuredEvent",
		function(context)
			return string.find(context:dilemma(), "wh3_dlc25_story_panel_nemesis_crown_03")			
		end,
		function(context)
			local spawn_loc = {x = 131, y = 194}

			--Spawn Stage 3 Warbosses
			self:spawn_nemesis_crown_forces(3, "wh3_dlc20_chaos_region_black_pit", spawn_loc, true)
			

			--loop through all the warbosses and set saved string to 0 for all warbosses
			for _, warboss in pairs(self.warboss_data) do
				core:svr_save_string("nemesis_crown_" .. warboss.force_key .. "_killed", "0")
			end

			--Trigger final battle mission
			cm:trigger_mission(faction_name, self.final_mission_key[faction_name], true)
		end,
		true
	)

	--Mark Warboss as defeated in campaign - affects final battle script
	core:add_listener(
		"ToD_WarbossKilled",
		"MissionSucceeded",
		function(context)
			return context:faction():name() == faction_name and string.find(context:mission():mission_record_key(), self.warboss_mission_prefix)		
		end,
		function(context)
			local mission_key = context:mission():mission_record_key()
			
			--loop through all the warbosses and find the force keys
			for _, warboss in pairs(self.warboss_data) do
				--if we find the warboss force_key then save a string to acknowledge that the mission was completed 
				--this string is used in the final battle script to edit the strength of the enemy forces
				if string.find(mission_key, warboss.force_key) then
					warboss.is_defeated = true
					core:svr_save_string("nemesis_crown_" .. warboss.force_key .. "_killed", "1")
				end
			end
			
		end,
		true
	)
	
	core:add_listener(
		"ToD_WarbossKilled2",
		"MissionCancelled",
		function(context)
			return context:faction():name() == faction_name and string.find(context:mission():mission_record_key(), self.warboss_mission_prefix)		
		end,
		function(context)
			local mission_key = context:mission():mission_record_key()
			
			--loop through all the warbosses and find the force keys
			for _, warboss in pairs(self.warboss_data) do
				--if we find the warboss force_key then save a string to acknowledge that the mission was completed 
				--this string is used in the final battle script to edit the strength of the enemy forces
				if string.find(mission_key, warboss.force_key) then
					warboss.is_defeated = true
					core:svr_save_string("nemesis_crown_" .. warboss.force_key .. "_killed", "1")
				end
			end
			
		end,
		true
	)
end

--function to spawn forces
function tod_narrative:spawn_nemesis_crown_forces(num_forces, region, spawn_loc, spawn_warboss)

	for i = 1, num_forces do
		local unit_list = self:random_warboss_force(19)
		local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_position(self.nemesis_crown_faction_key, spawn_loc.x, spawn_loc.y, true, 5)
		cm:create_force(self.nemesis_crown_faction_key, unit_list, region, pos_x, pos_y,  true,
			function(cqi)
				self.latest_character_cqi = cqi

				self:remove_attrition_and_upkeep(cqi)
			end
		)
	end

	if spawn_warboss then
		for _, warboss in pairs(self.warboss_data) do
			
			local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_position(self.nemesis_crown_faction_key, spawn_loc.x, spawn_loc.y, true, 5)
			cm:create_force_with_general(self.nemesis_crown_faction_key, warboss.unit_list, region, pos_x, pos_y, "general", warboss.subtype, warboss.forename, "", warboss.surname, "", false, 
				function(cqi) 
					local character = cm:get_character_by_cqi(cqi)					
					local lookup = cm:char_lookup_str(cqi)
					warboss.mf_cqi = character:military_force():command_queue_index()

					cm:add_experience_to_units_commanded_by_character(lookup, 9)
					cm:add_agent_experience(lookup, 97000)
					cm:add_skill(character, warboss.skill_key, true, true)

					self:remove_attrition_and_upkeep(cqi)

					self:elspeth_stage_mission(3, warboss) 
				end, 
			true)
		end
	end

	self:nemesis_crown_diplomacy()

	cm:make_region_visible_in_shroud(self.elspeth_faction_key, region)

	cm:force_alliance(self.nemesis_crown_faction_key, "wh_dlc03_grn_black_pit", true)
	cm:force_diplomacy("faction:"..self.nemesis_crown_faction_key, "faction:wh_dlc03_grn_black_pit", "break alliance", false, false, true)
end

function tod_narrative:random_warboss_force(num_units)

	local ram = random_army_manager
	ram:remove_force("nemesis_crown_random_army")
	ram:new_force("nemesis_crown_random_army")

	ram:add_unit("nemesis_crown_random_army", "wh_main_grn_inf_goblin_spearmen", 4)
	ram:add_unit("nemesis_crown_random_army", "wh_dlc06_grn_inf_nasty_skulkers_0", 4)
	ram:add_unit("nemesis_crown_random_army", "wh_main_grn_inf_night_goblins", 4)
	ram:add_unit("nemesis_crown_random_army", "wh_main_grn_inf_night_goblin_fanatics", 4)
	ram:add_unit("nemesis_crown_random_army", "wh_main_grn_inf_night_goblin_fanatics_1", 6)
	ram:add_unit("nemesis_crown_random_army", "wh_main_grn_inf_orc_boyz", 6)
	ram:add_unit("nemesis_crown_random_army", "wh_main_grn_inf_orc_big_uns", 8)
	ram:add_unit("nemesis_crown_random_army", "wh_main_grn_inf_savage_orcs", 1)
	ram:add_unit("nemesis_crown_random_army", "wh_main_grn_inf_savage_orc_big_uns", 1)
	ram:add_unit("nemesis_crown_random_army", "wh_main_grn_inf_black_orcs", 4)
	ram:add_unit("nemesis_crown_random_army", "wh_main_grn_inf_goblin_archers", 10)
	ram:add_unit("nemesis_crown_random_army", "wh_main_grn_inf_night_goblin_archers", 6)
	ram:add_unit("nemesis_crown_random_army", "wh_main_grn_inf_orc_arrer_boyz", 6)
	ram:add_unit("nemesis_crown_random_army", "wh_main_grn_inf_savage_orc_arrer_boyz", 2)
	
	--Cavalry
	ram:add_unit("nemesis_crown_random_army", "wh_main_grn_cav_goblin_wolf_riders_0", 4)
	ram:add_unit("nemesis_crown_random_army", "wh_main_grn_cav_goblin_wolf_riders_1", 4)
	ram:add_unit("nemesis_crown_random_army", "wh_main_grn_cav_goblin_wolf_chariot", 2)
	ram:add_unit("nemesis_crown_random_army", "wh_main_grn_cav_forest_goblin_spider_riders_0", 2)
	ram:add_unit("nemesis_crown_random_army", "wh_main_grn_cav_forest_goblin_spider_riders_1", 4)
	ram:add_unit("nemesis_crown_random_army", "wh_dlc06_grn_inf_squig_herd_0", 1)
	ram:add_unit("nemesis_crown_random_army", "wh_dlc06_grn_cav_squig_hoppers_0", 1)
	ram:add_unit("nemesis_crown_random_army", "wh_main_grn_cav_orc_boar_boyz", 3)
	ram:add_unit("nemesis_crown_random_army", "wh_main_grn_cav_orc_boar_boy_big_uns", 3)
	ram:add_unit("nemesis_crown_random_army", "wh_main_grn_cav_orc_boar_chariot", 1)
	ram:add_unit("nemesis_crown_random_army", "wh_main_grn_cav_savage_orc_boar_boyz", 4)
	ram:add_unit("nemesis_crown_random_army", "wh_main_grn_cav_savage_orc_boar_boy_big_uns", 2)
	ram:add_unit("nemesis_crown_random_army", "wh2_dlc15_grn_veh_snotling_pump_wagon_0", 2)
	ram:add_unit("nemesis_crown_random_army", "wh2_dlc15_grn_veh_snotling_pump_wagon_flappas_0", 1)
	ram:add_unit("nemesis_crown_random_army", "wh2_dlc15_grn_veh_snotling_pump_wagon_roller_0", 1)
	
	--Monsters
	ram:add_unit("nemesis_crown_random_army", "wh_dlc06_grn_inf_squig_herd_0", 3)
	ram:add_unit("nemesis_crown_random_army", "wh_main_grn_mon_trolls", 3)
	ram:add_unit("nemesis_crown_random_army", "wh2_dlc15_grn_mon_river_trolls_0", 6)
	ram:add_unit("nemesis_crown_random_army", "wh2_dlc15_grn_mon_stone_trolls_0", 6)
	ram:add_unit("nemesis_crown_random_army", "wh_main_grn_mon_giant", 4)
	ram:add_unit("nemesis_crown_random_army", "wh_main_grn_mon_arachnarok_spider_0", 3)
	ram:add_unit("nemesis_crown_random_army", "wh2_dlc15_grn_mon_rogue_idol_0", 2)
	ram:add_unit("nemesis_crown_random_army", "wh2_twa03_grn_mon_wyvern_0", 2)
	
	--Artillery
	ram:add_unit("nemesis_crown_random_army", "wh_main_grn_art_goblin_rock_lobber", 4)
	ram:add_unit("nemesis_crown_random_army", "wh_main_grn_art_doom_diver_catapult", 2)

	return ram:generate_force("nemesis_crown_random_army", num_units, false)

end

function tod_narrative:nemesis_crown_diplomacy()

	local enemy_list = self.nemesis_crown_enemies

	cm:force_diplomacy("faction:" .. self.nemesis_crown_faction_key, "all", "all", false, false, true)
	cm:force_diplomacy("faction:" .. self.nemesis_crown_faction_key, "all", "war", true, true, true)

	for i = 1, #enemy_list do
		local faction_key = enemy_list[i]
		cm:force_declare_war(self.nemesis_crown_faction_key, faction_key, false, true)
	end

end

function tod_narrative:remove_attrition_and_upkeep(cqi)
	cm:callback(function()
		local char = cm:get_character_by_cqi(cqi)	

		if char:has_military_force() then
			cm:apply_effect_bundle_to_characters_force("wh2_dlc16_bundle_military_upkeep_free_force_immune_to_regionless_attrition", cqi, 0)			
		end
	end, 0.5)
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("ToD_NarrativeStage", tod_narrative.narrative_stage, context)
		cm:save_named_value("ToD_WarbossData", tod_narrative.warboss_data, context)
	end
)
cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			tod_narrative.narrative_stage = cm:load_named_value("ToD_NarrativeStage", tod_narrative.narrative_stage, context)
			tod_narrative.warboss_data = cm:load_named_value("ToD_WarbossData", tod_narrative.warboss_data, context)
		end
	end
)