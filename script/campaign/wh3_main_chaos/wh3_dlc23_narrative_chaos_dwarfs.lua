------------------------------
-------------DATA-------------
------------------------------

chaos_dwarfs_narrative = {
	drill_location_astragoth = {x = 744, y = 227},
	drill_location_zhatan = {x = 784, y = 129},
	drill_location_drazhoath = {x = 931, y = 151},

	sacrifice_incident_key = "wh3_dlc23_story_panel_narrative_sacrifice_chd", 

	epilogue_incident_prefix = "wh3_dlc23_incident_epilogue_chd_", 

	hellshard_structure_victory_condition = "hellshard_structure_requirement",
	hellshard_bound_relics_victory_condition = "hellshard_bound_relics_requirement",
	final_battle_victory_condition = "chaos_dwarf_final_battle",
}

chaos_dwarfs_narrative.updates = {
	player_faction_key = nil,
}

local relic_mission_prefix = "wh3_dlc23_chd_ancestor_relic_of"

chaos_dwarfs_narrative.objectives = {
	relic_of_grimnir = {
		mission = "wh3_dlc23_chd_ancestor_relic_of_grimnir",
		ancillary = "wh3_dlc23_anc_talisman_major_relic_of_grimnir",
		mission_completed = false,
		bound_to_narrative = 0,
	}, 
	relic_of_grungni = {
		mission = "wh3_dlc23_chd_ancestor_relic_of_grungni",
		ancillary = "wh3_dlc23_anc_armour_major_relic_of_grungni",
		mission_completed = false,
		bound_to_narrative = 0,
	}, 
	relic_of_valaya	= {
		mission = "wh3_dlc23_chd_ancestor_relic_of_valaya",
		ancillary = "wh3_dlc23_anc_enchanted_item_major_relic_of_valaya",
		mission_completed = false,
		bound_to_narrative = 0,
	}, 
	relic_of_gazul	= {
		mission = "wh3_dlc23_chd_ancestor_relic_of_gazul",
		ancillary = "wh3_dlc23_anc_weapon_lesser_relic_of_gazul",
		mission_completed = false,
		bound_to_narrative = 0,
	}, 
	relic_of_morgrim	= {
		mission = "wh3_dlc23_chd_ancestor_relic_of_morgrim",
		ancillary = "wh3_dlc23_anc_enchanted_item_lesser_relic_of_morgrim",
		mission_completed = false,
		bound_to_narrative = 0,
	}, 
	relic_of_skavor	= {
		mission = "wh3_dlc23_chd_ancestor_relic_of_skavor",
		ancillary = "wh3_dlc23_anc_armour_lesser_relic_of_skavor",
		mission_completed = false,
		bound_to_narrative = 0,
	}, 
	relic_of_smednir	= {
		mission = "wh3_dlc23_chd_ancestor_relic_of_smednir",
		ancillary = "wh3_dlc23_anc_weapon_lesser_relic_of_smednir",
		mission_completed = false,
		bound_to_narrative = 0,
	}, 
	relic_of_thungni	= {
		mission = "wh3_dlc23_chd_ancestor_relic_of_thungni",
		ancillary = "wh3_dlc23_anc_talisman_lesser_relic_of_thungni",
		mission_completed = false,
		bound_to_narrative = 0,
	}, 
}

chaos_dwarfs_narrative.finale = {
	wh3_dlc23_chd_astragoth	= {
		mission = "wh3_dlc23_chd_final_battle_wh3_dlc23_chd_astragoth",
		mission_completed = false,
	}, 
	wh3_dlc23_chd_legion_of_azgorh	= {
		mission = "wh3_dlc23_chd_final_battle_wh3_dlc23_chd_legion_of_azgorh",
		mission_completed = false,
	}, 
	wh3_dlc23_chd_zhatan	= {
		mission = "wh3_dlc23_chd_final_battle_wh3_dlc23_chd_zhatan",
		mission_completed = false,
	}, 
}

chaos_dwarfs_narrative.counters = {
	current_faction_relics = 0,
	current_narrative_relics = 0,
}

chaos_dwarfs_narrative.relic_assignment = {
	narrative = {nil,nil,nil,nil},
	showoff = {nil,nil,nil,nil},
}

chaos_dwarfs_narrative.relic_armies = {
	morgrim_army = {
		faction_key = "wh3_dlc23_rogue_the_cult_of_morgrim",
		spawn_pos = {
			x = 594,
			y = 52,
		},
		cqi = nil,
		patrol_roc_the_cult_of_morgrim = {{x = 695, y = 20}, {x = 569, y = 42}},
	},
	tepok_army = {
		faction_key = "wh3_dlc23_rogue_sacred_host_of_tepok",
		spawn_pos = {
			x = 1050,
			y = 80,
		},
		cqi = nil,
		patrol_roc_sacred_host_of_tepok = {{x = 949, y = 51}, {x = 1066, y = 159}, {x = 1050, y = 80}},
	},
}

chaos_dwarfs_narrative.movie = {
	wh3_dlc23_chd_astragoth  	= {
		path = "warhammer3/chd/dlc23_astragoth_win", 
		unlock_str = "dlc23_astragoth_win"
	},
	wh3_dlc23_chd_legion_of_azgorh 	= {
		path = "warhammer3/chd/dlc23_drazhoath_win", 
		unlock_str = "dlc23_drazhoath_win"
	},
	wh3_dlc23_chd_zhatan 	= {
		path = "warhammer3/chd/dlc23_zhatan_win", 
		unlock_str = "dlc23_zhatan_win"
	},
}

chaos_dwarfs_narrative.mission_to_ancillary = {
	wh3_dlc23_chd_ancestor_relic_of_gazul = "wh3_dlc23_anc_weapon_lesser_relic_of_gazul",
	wh3_dlc23_chd_ancestor_relic_of_grimnir = "wh3_dlc23_anc_talisman_major_relic_of_grimnir",
	wh3_dlc23_chd_ancestor_relic_of_grungni = "wh3_dlc23_anc_armour_major_relic_of_grungni",
	wh3_dlc23_chd_ancestor_relic_of_morgrim = "wh3_dlc23_anc_enchanted_item_lesser_relic_of_morgrim",
	wh3_dlc23_chd_ancestor_relic_of_skavor = "wh3_dlc23_anc_armour_lesser_relic_of_skavor",
	wh3_dlc23_chd_ancestor_relic_of_smednir = "wh3_dlc23_anc_weapon_lesser_relic_of_smednir",
	wh3_dlc23_chd_ancestor_relic_of_thungni = "wh3_dlc23_anc_talisman_lesser_relic_of_thungni",
	wh3_dlc23_chd_ancestor_relic_of_valaya = "wh3_dlc23_anc_enchanted_item_major_relic_of_valaya"
}

chaos_dwarfs_narrative.conclave_influence_pr_key = "wh3_dlc23_chd_conclave_influence"
chaos_dwarfs_narrative.conclave_influence_factor_key = "wh3_dlc23_chd_conclave_influence_gained_events"

chaos_dwarfs_narrative.mission_to_conclave_reward = {
	wh3_dlc23_chd_ancestor_relic_of_gazul = 75,
	wh3_dlc23_chd_ancestor_relic_of_grimnir = 300,
	wh3_dlc23_chd_ancestor_relic_of_grungni = 300,
	wh3_dlc23_chd_ancestor_relic_of_morgrim = 75,
	wh3_dlc23_chd_ancestor_relic_of_skavor = 75,
	wh3_dlc23_chd_ancestor_relic_of_smednir = 75,
	wh3_dlc23_chd_ancestor_relic_of_thungni = 75,
	wh3_dlc23_chd_ancestor_relic_of_valaya = 300
}

------------------------------
----------INITIALISE----------
------------------------------

function chaos_dwarfs_narrative:initialise()

	human_factions = cm:get_human_factions_of_subculture("wh3_dlc23_sc_chd_chaos_dwarfs")
	for i = 1, #human_factions do		
		common.set_context_value("narrative_drill_location_wh3_dlc23_chd_astragoth", self.drill_location_astragoth);
		common.set_context_value("narrative_drill_location_wh3_dlc23_chd_legion_of_azgorh", self.drill_location_drazhoath);
		common.set_context_value("narrative_drill_location_wh3_dlc23_chd_zhatan", self.drill_location_zhatan);

		local model = cm:model();
		local is_multiplayer_campaign =	model:is_multiplayer();
		local updated_values = self.updates
		updated_values.player_faction_key = human_factions[i];

		if cm:is_new_game() and not is_multiplayer_campaign then
			cm:callback(
				function()
					if updated_values.player_faction_key == "wh3_dlc23_chd_astragoth"  then
						cm:add_scripted_composite_scene_to_logical_position("drill_stage_00", "wh3_dlc23_hellshard_00", self.drill_location_astragoth.x, self.drill_location_astragoth.y, 0, 0, false, true, false);
						cm:trigger_mission("wh3_dlc23_chd_astragoth", "wh3_dlc23_chd_ancestor_hellshard_structure_wh3_dlc23_chd_astragoth", true, true)
					elseif updated_values.player_faction_key == "wh3_dlc23_chd_legion_of_azgorh" then
						cm:add_scripted_composite_scene_to_logical_position("drill_stage_00", "wh3_dlc23_hellshard_00", self.drill_location_drazhoath.x, self.drill_location_drazhoath.y, 0, 0, false, true, false);
						cm:trigger_mission("wh3_dlc23_chd_legion_of_azgorh", "wh3_dlc23_chd_ancestor_hellshard_structure_wh3_dlc23_chd_legion_of_azgorh", true, true)
					elseif updated_values.player_faction_key == "wh3_dlc23_chd_zhatan" then
						cm:add_scripted_composite_scene_to_logical_position("drill_stage_00", "wh3_dlc23_hellshard_00", self.drill_location_zhatan.x, self.drill_location_zhatan.y, 0, 0, false, true, false);
						cm:trigger_mission("wh3_dlc23_chd_zhatan", "wh3_dlc23_chd_ancestor_hellshard_structure_wh3_dlc23_chd_zhatan", true, true)
					end
				end,
				2
			)
		else
			local counters = self.counters
			local assignment = self.relic_assignment
			
			for j = 1, counters.current_narrative_relics do 
				common.set_context_value("narrative_relic_assignments_"..j, assignment.narrative[j]);
			end

			for j = 1, counters.current_faction_relics do 
				common.set_context_value("showoff_relic_assignments_"..j, assignment.showoff[j]);
			end
		end;

		-- Dummy callback to make mission manager persistent, callback is setup for mission cancellation which would never happen
		-- Persistence is required for mission objective updating, Setup is required to happen before 1st tick and thus why its declared here
		---RELIC COUNT TRACKER
		mm_relic_tracker = mission_manager:new(human_factions[i], "wh3_dlc23_chd_ancestor_relics_counter", nil, nil, function() end)
	end

	---LISTEN FOR THE COMPLETION OF STRUCTURE MISSION
	core:add_listener(
		"player_starting_structure_mission",
		"MissionSucceeded",
		function(context)
			local mission_key = context:mission():mission_record_key();
			return mission_key:starts_with("wh3_dlc23_chd_ancestor_hellshard_structure_");
		end,
		function(context)
	 		chaos_dwarfs_narrative:drill_structure_progress(context:faction():name())
		end,
		false
	);

	---LISTEN FOR THE COMPLETION OF THE UNLOCK MISSION
	core:add_listener(
		"player_unlocks_relic_missions",
		"MissionSucceeded",
		function(context)
			local mission_key = context:mission():mission_record_key();
			return mission_key:starts_with("wh3_dlc23_chd_ancestor_relics_unlock_");
		end,
		function(context)
			local faction_key = context:faction():name()
			chaos_dwarfs_narrative:trigger_relic_missions(faction_key)
		end,
		false
	);

	---STOPS THE UI HIGHLIGHT WHEN THE NARRATIVE PANEL IS CLOSED
	core:add_listener(
		"ComponentLClickUpAttackButtonHideHighlight",
		"ComponentLClickUp",
		function(context) 
			return context.string == "button_chd_narrative_panel" 
		end,
		function() 
			highlight_component(false, true, "button_chd_narrative_panel");
		end,
		false
	)

	---LISTEN FOR THE COMPLETION OF A RELIC MISSION
	core:add_listener(
		"dwarf_relics_MissionSucceeded",
		"MissionSucceeded",
		function(context)
			local mission_key = context:mission():mission_record_key()
			return string.find(mission_key, relic_mission_prefix)
		end,
		function(context)
			local mission_key = context:mission():mission_record_key()
			local faction = context:faction()
			local faction_key = faction:name()
			local faction_leader_key = faction:faction_leader()

			if string.find(mission_key, relic_mission_prefix) then
				chaos_dwarfs_narrative:trigger_relic_dilemma(faction_key, faction_leader_key, mission_key);
			end;

			local relic_armies = self.relic_armies
			local morgrim_relic_army = relic_armies.morgrim_army.cqi
			local tepok_relic_army = relic_armies.tepok_army.cqi

			cm:callback(
				function()
					if mission_key == "wh3_dlc23_chd_ancestor_relic_of_gazul" and morgrim_relic_army ~= nil then
						cm:kill_character(morgrim_relic_army, true);
					elseif mission_key == "wh3_dlc23_chd_ancestor_relic_of_skavor" and tepok_relic_army ~= nil then
						cm:kill_character(tepok_relic_army, true);
					end
				end,
				1
			)
		end,
		true
	);

	---LISTEN FOR THE CHOICE DECISION OF A RELIC MISSION
	core:add_listener(
		"dilemma_event_choice_made",
		"DilemmaChoiceMadeEvent",
		function(context)
			for k,v in pairs(self.objectives) do 
				if v.mission == context:dilemma() then
					return true
				end
			end
			return false
		end,
		function(context)
			local faction = context:faction()
			local faction_key = faction:name()
			local dilemma_key = context:dilemma()
			local choice = context:choice();
			local counters = chaos_dwarfs_narrative.counters
			local objective = nil
			local assignment = self.relic_assignment

			for k,v in pairs(self.objectives) do 
				if v.mission == dilemma_key then
					objective = v
					break
				end
			end

			if objective.mission_completed == false and choice == 0 then
				counters.current_narrative_relics = counters.current_narrative_relics +1
				chaos_dwarfs_narrative:story_panels(faction_key, true)
				objective.mission_completed = true
				objective.bound_to_narrative = 1
				assignment.narrative[counters.current_narrative_relics] = dilemma_key
				common.set_context_value("narrative_relic_assignments_"..counters.current_narrative_relics, assignment.narrative[counters.current_narrative_relics]);
				cm:apply_effect_bundle(dilemma_key .."_reward_a", faction_key, 0);
				chaos_dwarfs_narrative:trigger_final_battle(faction_key)
			elseif objective.mission_completed == false and choice == 1 then
				counters.current_faction_relics = counters.current_faction_relics +1
				chaos_dwarfs_narrative:story_panels(faction_key, false)
				objective.mission_completed = true
				objective.bound_to_narrative = 0
				assignment.showoff[counters.current_faction_relics] = dilemma_key
				common.set_context_value("showoff_relic_assignments_"..counters.current_faction_relics, assignment.showoff[counters.current_faction_relics]);
			end;

			local faction_provinces_list = faction:provinces()
			local faction_provinces_count = faction_provinces_list:num_items()

			for i = 0, faction_provinces_count - 1 do
				local province = faction_provinces_list:item_at(i)
				local resource_manager = province:pooled_resource_manager()
	
				cm:apply_regular_reset_income(resource_manager)
			end

			chaos_dwarfs_narrative:trigger_relic_count_update(faction_key)	
		end,
		true
	);

	core:add_listener(
		"player_wins_survival_battle",
		"MissionSucceeded",
		function(context)
			return context:mission():mission_record_key():starts_with("wh3_dlc23_chd_final_battle_")
		end,
		function(context)
			local faction_key = context:faction():name()
			local movie = self.movie[faction_key]
			local win_movie = movie.path
			local win_unlock_key = movie.unlock_str

			cm:set_saved_value("campaign_completed", true);
			
			core:svr_save_registry_bool(win_unlock_key, true);
			cm:register_instant_movie(win_movie);

			-- Epilogue
			local mission_key = context:mission():mission_record_key()

			for k,v in pairs(self.finale) do 
				if v.mission == mission_key then
					v.mission_completed = true
					break
				end
			end

			chaos_dwarfs_narrative:update_daemonsmith_characters(cm:get_faction(faction_key))
			cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", self.final_battle_victory_condition, true);
			
			cm:add_turn_countdown_event(faction_key, 1, "ScriptEventShowEpilogueEvent_CHD", faction_key);
			core:add_listener(
				"epilogue_chd",
				"ScriptEventShowEpilogueEvent_CHD",
				true,
				function(context)
					local faction_key = context.string;
					
					cm:trigger_incident(faction_key, self.epilogue_incident_prefix .. faction_key, true);
					cm:activate_music_trigger("ScriptedEvent_Positive", "wh3_dlc23_sc_chd_chaos_dwarfs")
				end,
				false
			);
		end,
		false
	);

	-- Handle campaign completion assigning daemonsmith skill
	core:add_listener(
		"daemonsmith_sorcerer_recruited",
		"CharacterRecruited",
		function(context)
			return context:character():character_subtype_key():starts_with("wh3_dlc23_chd_daemonsmith_sorcerer_")
		end,
		function(context)
			local character = context:character()
			local faction = character:faction()
			local final_battles = self.finale
			local finale_complete

			for k,v in pairs(self.finale) do 
				if k == faction:name() then
					finale_complete = v.mission_completed
					break
				end
			end

			if finale_complete == true then
				--chaos_dwarfs_narrative:update_daemonsmith_characters(faction)
				local skill = "wh3_dlc23_agent_action_daemonsmith_sorcerer_hashuts_blood"
				cm:add_skill(character, skill, true, true)
			end
		end,
		true
		);

	-- Handle daemonsmith skill blowing up a settlement
	core:add_listener(
		"daemonsmith_sorcerer_settlement_action",
		"CharacterGarrisonTargetAction",
		function(context)
			return context:character():character_subtype_key():starts_with("wh3_dlc23_chd_daemonsmith_sorcerer_") and context:agent_action_key():find("destroy_settlement");
		end,
		function(context)
			local agent_action_key = context:agent_action_key();
			local target_region_interface = context:garrison_residence():settlement_interface();
			local target_region_key = target_region_interface:region():name();
			
			if agent_action_key == "wh3_dlc23_agent_action_wizard_destroy_settlement_daemonsmith_settlement" then
				cm:set_region_abandoned(target_region_key);
			end
		end,
		true
		);

		core:add_listener(
		"player_initiates_final_battle",
		"PendingBattle",
		function(context)
			return context:pending_battle():set_piece_battle_key():starts_with("wh3_dlc23_qb_chd_drill_of_hashut_")
		end,
		function()
			chaos_dwarfs_narrative:get_major_relics_bound()
		end,
		false
	);	
end

------------------------------
-----------FUNCTIONS----------
------------------------------

function chaos_dwarfs_narrative:story_panels(faction_key, is_relic)
	local counters = chaos_dwarfs_narrative.counters
	local incident_key = "wh3_dlc23_story_panel_narrative_"
	if is_relic then
		incident_key = incident_key .. "relic_0".. tostring(counters.current_narrative_relics)
		core:svr_save_registry_bool(incident_key, true)
	else
		incident_key = incident_key .. "petrification_0".. tostring(counters.current_faction_relics)
		core:svr_save_registry_bool(incident_key, true)
	end

	cm:trigger_incident(faction_key, incident_key, true, true)
	cm:activate_music_trigger("ScriptedEvent_Positive", "wh3_dlc23_sc_chd_chaos_dwarfs")
end

function chaos_dwarfs_narrative:drill_structure_progress(faction_key)
	cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", self.hellshard_structure_victory_condition, true);

	chaos_dwarfs_narrative:trigger_relic_unlock_mission(faction_key)

	cm:remove_scripted_composite_scene("drill_stage_00")

	if faction_key == "wh3_dlc23_chd_astragoth" then
		cm:add_scripted_composite_scene_to_logical_position("drill_stage_01", "wh3_dlc23_hellshard_01", self.drill_location_astragoth.x, self.drill_location_astragoth.y, 0, 0, false, true, false);
	elseif faction_key == "wh3_dlc23_chd_legion_of_azgorh" then
		cm:add_scripted_composite_scene_to_logical_position("drill_stage_01", "wh3_dlc23_hellshard_01", self.drill_location_drazhoath.x, self.drill_location_drazhoath.y, 0, 0, false, true, false);
	elseif faction_key == "wh3_dlc23_chd_zhatan" then
		cm:add_scripted_composite_scene_to_logical_position("drill_stage_01", "wh3_dlc23_hellshard_01", self.drill_location_zhatan.x, self.drill_location_zhatan.y, 0, 0, false, true, false);
	end
end

---Relic unlock mission
function chaos_dwarfs_narrative:trigger_relic_unlock_mission(faction_key)	
	local dwarf_battle_faction = "wh3_dlc23_chd_ancestor_relics_unlock_"..faction_key

	cm:trigger_mission(faction_key, dwarf_battle_faction, true, true)
	highlight_component(true, false, "button_chd_narrative_panel");
end

function chaos_dwarfs_narrative:trigger_relic_count_update(faction_key)	
	local counters = self.counters

	if counters.current_narrative_relics == 1 then
		mm_relic_tracker:update_scripted_objective_text("mission_text_text_wh3_dlc23_chd_narrative_relics_counter", 1, 4, "relics_counter");
	elseif counters.current_narrative_relics == 2 then
		mm_relic_tracker:update_scripted_objective_text("mission_text_text_wh3_dlc23_chd_narrative_relics_counter", 2, 4, "relics_counter");
	elseif counters.current_narrative_relics == 3 then
		mm_relic_tracker:update_scripted_objective_text("mission_text_text_wh3_dlc23_chd_narrative_relics_counter", 3, 4, "relics_counter");
	elseif counters.current_narrative_relics == 4 then
		mm_relic_tracker:update_scripted_objective_text("mission_text_text_wh3_dlc23_chd_narrative_relics_counter", 4, 4, "relics_counter");
		cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", self.hellshard_bound_relics_victory_condition, true);
	end;
end

---Unlock the relic missions
function chaos_dwarfs_narrative:trigger_relic_missions(faction_key)	
	--SACRIFICE STORY PANEL
	sacrifice_incident = self.sacrifice_incident_key
	cm:trigger_incident(faction_key, sacrifice_incident, true, true)
	cm:activate_music_trigger("ScriptedEvent_Positive", "wh3_dlc23_sc_chd_chaos_dwarfs")

	core:svr_save_registry_bool(sacrifice_incident, true)

	mm_relic_tracker:set_mission_issuer("CLAN_ELDERS")
	mm_relic_tracker:add_new_objective("SCRIPTED")
	mm_relic_tracker:add_condition("script_key relics_counter")
	mm_relic_tracker:add_condition("override_text mission_text_text_wh3_dlc23_chd_narrative_relics_counter")
	mm_relic_tracker:add_payload("effect_bundle{bundle_key wh3_dlc23_chd_ancestor_relics_counter_reward_dummy;turns 0;}")

	mm_relic_tracker:trigger()
	
	cm:callback(
		function()
			mm_relic_tracker:update_scripted_objective_text("mission_text_text_wh3_dlc23_chd_narrative_relics_counter", 0, 4, "relics_counter");
		end,
		0.5
	)

	chaos_dwarfs_narrative:spawn_relic_armies(faction_key)

	local relic_armies = self.relic_armies
	local morgrim_relic_army = relic_armies.morgrim_army.cqi
	local tepok_relic_army = relic_armies.tepok_army.cqi

	cm:callback(
		function()
			---RELIC OF GRIMNIR
			local mm_relic_of_grimnir = mission_manager:new(faction_key, "wh3_dlc23_chd_ancestor_relic_of_grimnir")
		
			mm_relic_of_grimnir:set_mission_issuer("CLAN_ELDERS")
			mm_relic_of_grimnir:add_new_objective("FIGHT_SET_PIECE_BATTLE")
			mm_relic_of_grimnir:add_condition("set_piece_battle wh3_dlc23_chd_relic_of_grimnir")
			mm_relic_of_grimnir:add_payload("effect_bundle{bundle_key wh3_dlc23_chd_ancestor_relic_of_grimnir_reward_dummy;turns 0;}")
			mm_relic_of_grimnir:trigger()
		
			---RELIC OF GRUNGNI
			local mm_relic_of_grungni = mission_manager:new(faction_key, "wh3_dlc23_chd_ancestor_relic_of_grungni")
		
			mm_relic_of_grungni:set_mission_issuer("CLAN_ELDERS")
			mm_relic_of_grungni:add_new_objective("FIGHT_SET_PIECE_BATTLE")
			mm_relic_of_grungni:add_condition("set_piece_battle wh3_dlc23_chd_relic_of_grungni")
			mm_relic_of_grungni:add_payload("effect_bundle{bundle_key wh3_dlc23_chd_ancestor_relic_of_grungni_reward_dummy;turns 0;}")
			mm_relic_of_grungni:trigger()
		
			---RELIC OF VALAYA
			local mm_relic_of_valaya = mission_manager:new(faction_key, "wh3_dlc23_chd_ancestor_relic_of_valaya")
		
			mm_relic_of_valaya:set_mission_issuer("CLAN_ELDERS")
			mm_relic_of_valaya:add_new_objective("FIGHT_SET_PIECE_BATTLE")
			mm_relic_of_valaya:add_condition("set_piece_battle wh3_dlc23_chd_relic_of_valaya")
			mm_relic_of_valaya:add_payload("effect_bundle{bundle_key wh3_dlc23_chd_ancestor_relic_of_valaya_reward_dummy;turns 0;}")
			mm_relic_of_valaya:trigger()
		
			-- ---RELIC OF GAZUL
			local mm_relic_of_gazul = mission_manager:new(faction_key, "wh3_dlc23_chd_ancestor_relic_of_gazul")
		
			mm_relic_of_gazul:set_mission_issuer("CLAN_ELDERS")
			mm_relic_of_gazul:add_new_objective("CONTROL_N_REGIONS_INCLUDING")
			mm_relic_of_gazul:add_condition("total 1")
			mm_relic_of_gazul:add_condition("region wh3_main_chaos_region_castle_drakenhof")
			mm_relic_of_gazul:add_payload("effect_bundle{bundle_key wh3_dlc23_chd_ancestor_relic_of_gazul_reward_dummy;turns 0;}")
			mm_relic_of_gazul:trigger()
		
			-- ---RELIC OF MORGRIM
			local mm_relic_of_morgrim = mission_manager:new(faction_key, "wh3_dlc23_chd_ancestor_relic_of_morgrim")
		
			mm_relic_of_morgrim:set_mission_issuer("CLAN_ELDERS")
			mm_relic_of_morgrim:add_new_objective("ENGAGE_FORCE")
			mm_relic_of_morgrim:add_condition("cqi " ..morgrim_relic_army)
			mm_relic_of_morgrim:add_condition("requires_victory")
			mm_relic_of_morgrim:add_payload("effect_bundle{bundle_key wh3_dlc23_chd_ancestor_relic_of_morgrim_reward_dummy;turns 0;}")
			mm_relic_of_morgrim:trigger()
		
			-- ---RELIC OF SMEDNIR
			local mm_relic_of_smednir = mission_manager:new(faction_key, "wh3_dlc23_chd_ancestor_relic_of_smednir")
		
			mm_relic_of_smednir:set_mission_issuer("CLAN_ELDERS")
			mm_relic_of_smednir:add_new_objective("CONTROL_N_REGIONS_INCLUDING")
			mm_relic_of_smednir:add_condition("total 1")
			mm_relic_of_smednir:add_condition("region wh3_main_chaos_region_karak_dum")
			mm_relic_of_smednir:add_payload("effect_bundle{bundle_key wh3_dlc23_chd_ancestor_relic_of_smednir_reward_dummy;turns 0;}")
			mm_relic_of_smednir:trigger()
		
			-- ---RELIC OF SKAVOR
			local mm_relic_of_skavor = mission_manager:new(faction_key, "wh3_dlc23_chd_ancestor_relic_of_skavor")
		
			mm_relic_of_skavor:set_mission_issuer("CLAN_ELDERS")
			mm_relic_of_skavor:add_new_objective("ENGAGE_FORCE")
			mm_relic_of_skavor:add_condition("cqi " ..tepok_relic_army)
			mm_relic_of_skavor:add_condition("requires_victory")
			mm_relic_of_skavor:add_payload("effect_bundle{bundle_key wh3_dlc23_chd_ancestor_relic_of_skavor_reward_dummy;turns 0;}")
			mm_relic_of_skavor:trigger()
		
			---RELIC OF THUNGNI
			local mm_relic_of_thungni = mission_manager:new(faction_key, "wh3_dlc23_chd_ancestor_relic_of_thungni")
		
			mm_relic_of_thungni:set_mission_issuer("CLAN_ELDERS")
			mm_relic_of_thungni:add_new_objective("CONTROL_N_REGIONS_INCLUDING")
			mm_relic_of_thungni:add_condition("total 1")
			mm_relic_of_thungni:add_condition("region wh3_main_chaos_region_karak_azorn")
			mm_relic_of_thungni:add_payload("effect_bundle{bundle_key wh3_dlc23_chd_ancestor_relic_of_thungni_reward_dummy;turns 0;}")
			mm_relic_of_thungni:trigger()

		end,
		1
	)
end

---Final Battle mission
function chaos_dwarfs_narrative:trigger_final_battle(faction_key)
	local final_battle_faction = "wh3_dlc23_chd_final_battle_"..faction_key
	local counters = chaos_dwarfs_narrative.counters

	if counters.current_narrative_relics == 4 then
		chaos_dwarfs_narrative:get_major_relics_bound()
		cm:trigger_mission(faction_key, final_battle_faction, true, true)

		cm:remove_scripted_composite_scene("drill_stage_01")

		if faction_key == "wh3_dlc23_chd_astragoth" then
			cm:add_scripted_composite_scene_to_logical_position("drill_stage_02", "wh3_dlc23_hellshard_02", self.drill_location_astragoth.x, self.drill_location_astragoth.y, 0, 0, false, true, false);
		elseif faction_key == "wh3_dlc23_chd_legion_of_azgorh" then
			cm:add_scripted_composite_scene_to_logical_position("drill_stage_02", "wh3_dlc23_hellshard_02", self.drill_location_drazhoath.x, self.drill_location_drazhoath.y, 0, 0, false, true, false);
		elseif faction_key == "wh3_dlc23_chd_zhatan" then
			cm:add_scripted_composite_scene_to_logical_position("drill_stage_02", "wh3_dlc23_hellshard_02", self.drill_location_zhatan.x, self.drill_location_zhatan.y, 0, 0, false, true, false);
		end
	end
end

function chaos_dwarfs_narrative:trigger_relic_dilemma(faction_key, faction_leader_key, mission_key)
	local choice_1 = mission_key.."_reward_a"
	local choice_2 = mission_key.."_reward_b"

	local counters = chaos_dwarfs_narrative.counters
	local objective = nil
	local assignment = self.relic_assignment

	for k,v in pairs(self.objectives) do
		if v.mission == mission_key then
			objective = v
			break
		end
	end

	if counters.current_narrative_relics == 4 then
		counters.current_faction_relics = counters.current_faction_relics +1
		objective.mission_completed = true
		objective.bound_to_narrative = 0
		assignment.showoff[counters.current_faction_relics] = mission_key
		common.set_context_value("showoff_relic_assignments_"..counters.current_faction_relics, assignment.showoff[counters.current_faction_relics])
		local ancillary = self.mission_to_ancillary[mission_key]
		local pooled_resource_amount = self.mission_to_conclave_reward[mission_key] or 0
		
		cm:callback(
			function()
				cm:add_ancillary_to_faction(cm:get_faction(faction_key), ancillary, false)
				cm:faction_add_pooled_resource(faction_key, self.conclave_influence_pr_key, self.conclave_influence_factor_key, pooled_resource_amount)
				chaos_dwarfs_narrative:story_panels(faction_key, false)
			end,
			0.5
		)
		
		cm:callback(
			function()
				cm:trigger_incident(faction_key, choice_2, true, true)
			end,
			3
		)
	elseif counters.current_faction_relics == 4 then
		counters.current_narrative_relics = counters.current_narrative_relics +1
		objective.mission_completed = true
		objective.bound_to_narrative = 1
		assignment.narrative[counters.current_narrative_relics] = mission_key
		common.set_context_value("narrative_relic_assignments_"..counters.current_narrative_relics, assignment.narrative[counters.current_narrative_relics])

		chaos_dwarfs_narrative:trigger_final_battle(faction_key)

		cm:callback(
			function()
				cm:apply_effect_bundle(choice_1, faction_key, 0)
				chaos_dwarfs_narrative:story_panels(faction_key, true)
				chaos_dwarfs_narrative:trigger_relic_count_update(faction_key)
			end,
			0.5
		)

		cm:callback(
			function()
				cm:trigger_incident(faction_key, choice_1, true, true)
			end,
			3
		)
	elseif counters.current_narrative_relics <= 3 and counters.current_faction_relics <= 3 then
		cm:trigger_dilemma_raw(faction_key, mission_key, true, true)
	end;
end

function chaos_dwarfs_narrative:spawn_relic_armies(faction_key)
	local updated_values = self.updates
	local relic_armies = self.relic_armies

	local morgrim_relic_army = relic_armies.morgrim_army
	local morgrim_relic_faction = morgrim_relic_army.faction_key

	cm:spawn_rogue_army(morgrim_relic_army.faction_key, morgrim_relic_army.spawn_pos.x, morgrim_relic_army.spawn_pos.y)
	local morgrim_relic_force = cm:get_faction(morgrim_relic_faction):faction_leader():military_force()
	
	local tepok_relic_army = relic_armies.tepok_army
	local tepok_relic_faction = tepok_relic_army.faction_key

	cm:spawn_rogue_army(tepok_relic_army.faction_key, tepok_relic_army.spawn_pos.x, tepok_relic_army.spawn_pos.y)
	local tepok_relic_force = cm:get_faction(tepok_relic_faction):faction_leader():military_force()

	cm:force_declare_war(updated_values.player_faction_key, morgrim_relic_faction, false, false)
	cm:force_diplomacy("all", "faction:" .. morgrim_relic_faction, "all", false, false, true)
	cm:force_diplomacy("faction:" .. morgrim_relic_faction, "all", "all", false, false, true)

	cm:force_declare_war(updated_values.player_faction_key, tepok_relic_faction, false, false)
	cm:force_diplomacy("all", "faction:" .. tepok_relic_faction, "all", false, false, true)
	cm:force_diplomacy("faction:" .. tepok_relic_faction, "all", "all", false, false, true) 

	-- save force cqi for future use in missions.
	morgrim_relic_army.cqi = morgrim_relic_force:command_queue_index()
	tepok_relic_army.cqi = tepok_relic_force:command_queue_index()

	local tepok_exp_faction = "wh3_dlc23_rogue_sacred_host_of_tepok"

	cm:add_agent_experience("faction:wh3_dlc23_rogue_the_cult_of_morgrim,forename:1195990200", 20, true); 
	cm:add_agent_experience("faction:wh3_dlc23_rogue_sacred_host_of_tepok,forename:2071366402", 20, true);

	local relic_army_morgrim_invasion = invasion_manager:new_invasion_from_existing_force("morgrim_relic_faction", morgrim_relic_force)

	relic_army_morgrim_invasion:set_target("PATROL", morgrim_relic_army.patrol_roc_the_cult_of_morgrim)
	relic_army_morgrim_invasion:add_aggro_radius(50)		
	relic_army_morgrim_invasion:should_maintain_army(true, 50)
	relic_army_morgrim_invasion:apply_effect("wh3_dlc23_bundle_relic_army_morgrim", -1);
	relic_army_morgrim_invasion:start_invasion()

	local relic_army_tepok_invasion = invasion_manager:new_invasion_from_existing_force("tepok_relic_faction", tepok_relic_force)

	relic_army_tepok_invasion:set_target("PATROL", tepok_relic_army.patrol_roc_sacred_host_of_tepok)
	relic_army_tepok_invasion:add_aggro_radius(50)		
	relic_army_tepok_invasion:should_maintain_army(true, 50)
	relic_army_tepok_invasion:apply_effect("wh3_dlc23_bundle_relic_army_tepok", -1);
	relic_army_tepok_invasion:start_invasion()
end

function chaos_dwarfs_narrative:get_major_relics_bound()
	local objectives = self.objectives
	local grimnir_mission = objectives.relic_of_grimnir
	local grungni_mission = objectives.relic_of_grungni
	local valaya_mission = objectives.relic_of_valaya

	if grimnir_mission.mission_completed == true then
		core:svr_save_string("relic_of_grimnir_bound", "0")
	else
		core:svr_save_string("relic_of_grimnir_bound", "1")
	end

	if grungni_mission.mission_completed == true then
		core:svr_save_string("relic_of_grungni_bound", "0")
	else
		core:svr_save_string("relic_of_grungni_bound", "1")
	end

	if valaya_mission.mission_completed == true then
		core:svr_save_string("relic_of_valaya_bound", "0")
	else
		core:svr_save_string("relic_of_valaya_bound", "1")
	end
end;

function chaos_dwarfs_narrative:update_daemonsmith_characters(faction_interface)
	local characters = faction_interface:character_list()
	local skill = "wh3_dlc23_agent_action_daemonsmith_sorcerer_hashuts_blood"

	for i = 0, characters:num_items() -1 do
		local character = characters:item_at(i)
		
		if character:character_subtype_key():starts_with("wh3_dlc23_chd_daemonsmith_sorcerer_") then
			cm:callback(function()
				cm:add_skill(character, skill, true, true)
			end,
			0.2
			);
		end
	end
end;

------------------------------
---------SAVING/LOADING-------
------------------------------

cm:add_saving_game_callback(
	function(context)		
		cm:save_named_value("ChaosDwarfNarrativeUpdatedValues", chaos_dwarfs_narrative.updates, context)
		cm:save_named_value("ChaosDwarfNarrativeMissionObjectives", chaos_dwarfs_narrative.objectives, context)
		cm:save_named_value("ChaosDwarfNarrativeCounters", chaos_dwarfs_narrative.counters, context)
		cm:save_named_value("ChaosDwarfRelicAssignments", chaos_dwarfs_narrative.relic_assignment, context)
	end
);
cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			chaos_dwarfs_narrative:get_major_relics_bound()
			chaos_dwarfs_narrative.updates = cm:load_named_value("ChaosDwarfNarrativeUpdatedValues", chaos_dwarfs_narrative.updates, context)
			chaos_dwarfs_narrative.objectives = cm:load_named_value("ChaosDwarfNarrativeMissionObjectives", chaos_dwarfs_narrative.objectives, context)
			chaos_dwarfs_narrative.counters = cm:load_named_value("ChaosDwarfNarrativeCounters", chaos_dwarfs_narrative.counters, context)
			chaos_dwarfs_narrative.relic_assignment = cm:load_named_value("ChaosDwarfRelicAssignments", chaos_dwarfs_narrative.relic_assignment, context)
		end
	end
);