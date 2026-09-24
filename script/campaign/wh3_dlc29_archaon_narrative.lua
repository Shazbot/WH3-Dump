--------------------------------------------
--- DLC29 - ARCHAON NARRATIVE SCRIPT ---
--------------------------------------------

archaon_long_victory_objective_destroy_factions_list = {	
	"wh_main_emp_empire",
	"wh_main_emp_averland",
	"wh_main_emp_hochland",
	"wh_main_emp_middenland",
	"wh_main_emp_marienburg",
	"wh_main_emp_nordland",
	"wh_main_emp_ostland",
	"wh_main_emp_ostermark",
	"wh_main_emp_stirland",
	"wh_main_emp_talabecland",
	"wh_main_emp_wissenland",
}

-- Used in victory_objectives_config.lua to create initial long victory mission. After player reaches short victory - long victory mission is recreated using these objectives and adding new ones
archaon_long_victory_default_objectives_list = {
	generate_SCRIPTED_COMPLETE_SHORT_VICTORY_objective(),
	generate_SCRIPTED_MISSION_objective("wh3_dlc29_main_chs_reach_strength_rank_1_short", "mission_text_text_wh3_dlc29_main_chs_reach_strength_rank_1_short"),
	generate_DESTROY_FACTION_objective(archaon_long_victory_objective_destroy_factions_list, true, true),
	generate_SCRIPTED_MISSION_objective("wh3_dlc29_chs_archaon_goal_of_chosen_path_long", "mission_text_text_wh3_dlc29_chs_archaon_goal_of_chosen_path_long"),
}

archaon_narrative_config = {
	archaon_faction_key = "wh_main_chs_chaos",
	short_victory_dilemma_key = "wh3_dlc29_main_chs_archaon_short_victory_choice",
	
	
	vassal_owner_faction_list = {
		"wh3_dlc29_nurgle_vassal_owner",	
		"wh3_dlc29_khorne_vassal_owner",	
		"wh3_dlc29_tzeentch_vassal_owner",
		"wh3_dlc29_slaanesh_vassal_owner",
	},
	
	mission_data = {

		suppressed_event_feed_event_key = "faction_event_mission_aborted",

		short_victory_mission = {
			mission_key = "wh_main_short_victory",
			script_key = "complete_faction_victory",
		},

		long_victory_mission = {
			mission_key = "wh_main_long_victory",
			victory_type = "wh3_combi_victory_type_subculture",
			main_objective_script_key = "wh3_dlc29_chs_archaon_goal_of_chosen_path_long",

			-- Fired for each path-specific objective completed. Once main_objective_options[option].total_objectives_to_complete of these have fired, the fake objective (long_victory_mission.main_objective_script_key) is marked completed, triggering completion of the Victory Mission
			objective_competed_event_key = "ScriptEventArchaonLongVictoryObjectiveCompleted",
			shared_objectives = archaon_long_victory_default_objectives_list,
		
			main_objective_options = {
				["option_1"] = { key = "option_1", description_text = "mission_text_text_wh3_dlc29_chs_archaon_goal_of_conqueror_long", total_objectives_to_complete = 4 },
				["option_2"] = { key = "option_2", description_text = "mission_text_text_wh3_dlc29_chs_archaon_goal_of_destroyer_long", total_objectives_to_complete = 3 },
			},

			devastation_objective = {
				script_key = "wh3_dlc29_chs_archaon_devastate_n_provinces_long",
				description_text = "mission_text_text_wh3_dlc29_chs_archaon_devastate_n_provinces_long",
				total_provinces_to_devastate = 8,
				devastation_event_key = "ScriptEventArchaonDevastatedProvince",
			},

			strength_rank_objective = {
				script_key = "wh3_dlc29_main_chs_reach_strength_rank_1_short",
			},

			destroy_factions_objective = {
				-- Tracked natively by code rather than as a scripted objective, so it needs an id of its own for progress bookkeeping
				objective_id = "archaon_long_victory_destroy_factions",
				faction_key_list = archaon_long_victory_objective_destroy_factions_list,
			},

			dark_fortress_objective = {
				script_key = "wh3_dlc29_chs_archaon_control_n_dark_fortresses_long",
				description_text = "mission_text_text_wh3_dlc29_main_chs_control_n_dark_fortresses_short",
				total_dark_fortresses_required = 16,
				region_group = "wh3_dlc20_dark_fortress_region_group",
			},

			subjugate_legendary_lords_objective = {
				script_key = "wh3_dlc29_chs_archaon_subjugate_n_legendary_lords_long",
				description_text = "mission_text_text_wh3_dlc29_chs_archaon_subjugate_n_legendary_lords",
				total_legendary_lords_required = 8,
				subjugation_event_key = "ScriptEventArchaonSubjugatesChaosFaction",
			},
		},
	},

	-- TODO: update effect bundles/climates
	devastation_data = {
		climate = "chaos_devastation",

		block_occupation_effect_bundle = "wh3_dlc29_chs_archaon_block_occupation",
		devastation_effect_bundle = "wh3_dlc29_archaon_short_victory_lord_of_the_end_times_devastated_bundle",

		settlement_type = "wh3_dlc29_devastated",
		settlement_state = "devastated",

		-- Bonus to Archaon from devastation
		devastation_bonus_effect_bundle_key = "wh3_dlc29_archaon_short_victory_lord_of_the_end_times",
		devastation_bonus_effect_key_ward = "wh_main_effect_character_stat_ward_save",
		devastation_bonus_effect_key_upkeep = "wh_main_effect_force_all_campaign_upkeep",
		devastation_bonus_effect_key_income = "wh3_dlc27_effect_force_all_campaign_razing_looting_sacking_income",
		devastation_bonus_efect_scope_archaon = "faction_to_force_faction_leader",
		devastation_bonus_efect_scope_faction = "faction_to_force_own_alt_text",
	}
}

archaon_narrative_persistent = {
	devastated_provinces_total = 0,
	long_victory_condition_chosen_option_key = nil,
	completed_long_victory_objectives = 0,
	completed_long_victory_objective_id_list = {},
	devastated_province_key_list = {},
	owned_or_allied_dark_fortress_key_list = {},
	subjugated_legendary_lord_faction_key_list = {},
	destroyed_enemy_faction_key_list = {},
}

archaon_narrative = {}
archaon_narrative.config = archaon_narrative_config
archaon_narrative.persistent = archaon_narrative_persistent

function archaon_narrative:initialise()
	if cm:is_faction_human(self.config.archaon_faction_key) then
		if not cm:is_multiplayer() then
			-- Savegames made before this list existed will not contain it
			self.persistent.completed_long_victory_objective_id_list = self.persistent.completed_long_victory_objective_id_list or {}

			if self.persistent.long_victory_condition_chosen_option_key then
				self:initialise_long_victory_path(self.persistent.long_victory_condition_chosen_option_key, false)
			else
				core:add_listener(
					"ArchaonShortVictoryCompleted",
					"MissionSucceeded", 
					function(context)
						return context:mission():faction():name() == self.config.archaon_faction_key and context:mission():mission_record_key() == self.config.mission_data.short_victory_mission.mission_key
					end, 
					function(context)
						cm:trigger_dilemma(self.config.archaon_faction_key, self.config.short_victory_dilemma_key, self:short_victory_dilemma_callback())
					end,
					true
				)
			end
		else
			self:initialise_long_victory_path(self.config.mission_data.long_victory_mission.main_objective_options.option_1.key, cm:is_new_game())
		end
	end
end

function archaon_narrative:short_victory_dilemma_callback()
	core:add_listener(
		"ArchaonShortVictoryDilemmaChoiceMadeEvent",
		"DilemmaChoiceMadeEvent",
		function(context)
			return context:dilemma() == self.config.short_victory_dilemma_key					
		end,
		function(context)
			-- Autosave on ironman.
			if cm:model():manual_saves_disabled() and not cm:is_multiplayer() then
				cm:callback(function() cm:autosave_at_next_opportunity() end, 0.5)
			end

			if context:choice() == 0 then
				-- Choice 1: The Conqueror
				self.persistent.long_victory_condition_chosen_option_key = self.config.mission_data.long_victory_mission.main_objective_options.option_1.key
			else
				-- Choice 2: The Destroyer
				self.persistent.long_victory_condition_chosen_option_key = self.config.mission_data.long_victory_mission.main_objective_options.option_2.key
			end

			self:initialise_long_victory_path(self.persistent.long_victory_condition_chosen_option_key, true)
		end,
		false
	)
end

function archaon_narrative:initialise_long_victory_path(option_key, create_mission)

	-- Code saves the count and completion state of each scripted objective with the mission, so rebuilding the mission on load would discard all recorded progress
	if create_mission then
		self:update_long_victory_objectives(option_key)
	else
		self:add_victory_objective_listeners(option_key)
		self:resync_long_victory_objective_counts(option_key)
	end

	if option_key == self.config.mission_data.long_victory_mission.main_objective_options.option_2.key then
		
		local uim = cm:get_campaign_ui_manager()
		uim:override("occupy_button"):set_allowed(false)
		uim:override("subjugation_button"):set_allowed(false)
		uim:override("postbattle_gift_button"):set_allowed(false)
		uim:override("resettle"):set_allowed(false)

		self:restrict_vassals_occupation()
		self:apply_devastated_province_bonus()

		core:add_listener(
			"ArchaonAndAlliesRazeSettlement",
			"CharacterRazedSettlement",
			function(context)
				return self:is_archaon_or_archaon_vassal(context:character():faction())
			end,
			function(context)
				local region_obj = context:garrison_residence():region()
				self:devastate_region(region_obj, context:character():faction())
			end,
			true
		)

		-- Vassals gained after the Destroyer path was chosen also need their occupation options restricted
		core:add_listener(
			"ArchaonRefreshesVassalOccupationRestrictions",
			"PositiveDiplomaticEvent",
			function(context)
				if not context:is_vassalage() then
					return false
				end

				if context:proposer():name() == self.config.archaon_faction_key then
					return not context:proposer_is_vassal()
				end

				return context:recipient():name() == self.config.archaon_faction_key and context:proposer_is_vassal()
			end,
			function(context)
				self:restrict_vassals_occupation()
			end,
			true
		)
	end
end

function archaon_narrative:is_archaon_or_archaon_vassal(faction_obj)
	if not faction_obj or faction_obj:is_null_interface() then
		return false
	end
	local faction_name = faction_obj:name()
	local faction_master = faction_obj:master()

	if faction_name == self.config.archaon_faction_key or (faction_master and not faction_master:is_null_interface() and faction_master:name() == self.config.archaon_faction_key) then
		return true
	end

	return false
end

function archaon_narrative:update_long_victory_objectives(option_key)

	local long_victory_mission_data = self.config.mission_data.long_victory_mission

		-- Cancel existing Long Victory mission
		cm:disable_event_feed_events(true, "", "", self.config.mission_data.suppressed_event_feed_event_key)
		cm:complete_scripted_mission_objective(self.config.archaon_faction_key, long_victory_mission_data.mission_key, "", false)
		cm:callback(
			function()
				cm:disable_event_feed_events(false, "", "", self.config.mission_data.suppressed_event_feed_event_key)
			end,
			0.5
		)

	-- Create new Long Victory mission, made up of the shared_objectives plus the objectives specific to the chosen path
	local mm = mission_manager:new(self.config.archaon_faction_key, long_victory_mission_data.mission_key)

	local path_objectives = {}
	for i = 1, #long_victory_mission_data.shared_objectives do
		table.insert(path_objectives, long_victory_mission_data.shared_objectives[i])
	end

	if option_key == long_victory_mission_data.main_objective_options.option_1.key then
		table.insert(
			path_objectives, 
			generate_SCRIPTED_MISSION_objective(
				long_victory_mission_data.dark_fortress_objective.script_key, 
				long_victory_mission_data.dark_fortress_objective.description_text, 
				long_victory_mission_data.dark_fortress_objective.total_dark_fortresses_required, 
				0, 
				true
			)
		)
		table.insert(
			path_objectives, 
			generate_SCRIPTED_MISSION_objective(
				long_victory_mission_data.subjugate_legendary_lords_objective.script_key, 
				long_victory_mission_data.subjugate_legendary_lords_objective.description_text, 
				long_victory_mission_data.subjugate_legendary_lords_objective.total_legendary_lords_required, 
				0,
				true
			)
		)
	else
		table.insert(path_objectives, generate_SCRIPTED_MISSION_objective(long_victory_mission_data.devastation_objective.script_key, long_victory_mission_data.devastation_objective.description_text, long_victory_mission_data.devastation_objective.total_provinces_to_devastate, 0, true))
	end
		
		_victory_objectives_ie:add_objectives(mm, path_objectives)
		_victory_objectives_ie:add_victory_mission_payload(self.config.archaon_faction_key, mm, "long", self.config.archaon_faction_key)

		mm:set_victory_mission(true)
		mm:set_victory_type(long_victory_mission_data.victory_type)
		mm:set_show_mission(false)
		mm:trigger()

	-- Refresh displayed text for any objective seeded with a starting count/total, rather than waiting for its own tracking listener to fire
	for _, objective in ipairs(path_objectives) do
		local script_key, override_text, total, count

		for _, condition in ipairs(objective.conditions) do
			local condition_key, condition_value = condition:match("^(%S+)%s*(.*)$")
			if condition_key == "script_key" then
				script_key = condition_value
			elseif condition_key == "override_text" then
				override_text = condition_value
			elseif condition_key == "total" then
				total = tonumber(condition_value)
			elseif condition_key == "count" then
				count = tonumber(condition_value)
			end
		end

		if script_key and total then
			cm:callback(
				function() 
					cm:set_scripted_mission_text(long_victory_mission_data.mission_key, script_key, override_text, count or 0, total)
				end, 
				0.5
			)
		end
	end

	-- The player may already own dark fortresses and have subjugated legendary lords, so seed those counts after the refresh loop above has run
	if option_key == long_victory_mission_data.main_objective_options.option_1.key then
		cm:callback(
			function()
				self:find_already_subjugated_legendary_lords()
				self:update_owned_or_allied_dark_fortresses_objective()
			end,
			0.6
		)
	end

	-- for MP we setup the mission on new game so we don't want to auto complete this.
	if not cm:is_multiplayer() then
		-- Mark Short Victory completed
		cm:complete_scripted_mission_objective(self.config.archaon_faction_key, long_victory_mission_data.mission_key, self.config.mission_data.short_victory_mission.script_key, true)
	end

	-- Update "Choosen Path" objective text
	cm:set_scripted_mission_text(long_victory_mission_data.mission_key, long_victory_mission_data.main_objective_script_key, long_victory_mission_data.main_objective_options[option_key].description_text)

	-- option 1 has 2 sub objectives, while option 2 has only 1.
	local mission_sublist_index = "4;5;6"
	if option_key == long_victory_mission_data.main_objective_options.option_2.key then
		mission_sublist_index = "4;5"
	end
	cm:set_script_state(cm:get_faction(self.config.archaon_faction_key), "long_victory_mission_sub_objectives_index_list", mission_sublist_index)

	self:add_victory_objective_listeners(option_key)
end

-- Legendary Lords subjugated before the Everchosen path was chosen never fired ScriptEventArchaonSubjugatesChaosFaction into this script, so find them by checking their original faction now
function archaon_narrative:find_already_subjugated_legendary_lords()

	local archaon_faction_obj = cm:get_faction(self.config.archaon_faction_key)

	for enemy_faction_key, _ in dpairs(archaon_subjugation_config.faction_key_to_leader_subtype_list) do
		if not table.contains(self.persistent.subjugated_legendary_lord_faction_key_list, enemy_faction_key) then

			local enemy_faction_obj = cm:get_faction(enemy_faction_key)

			if enemy_faction_obj and not enemy_faction_obj:is_null_interface() then
				local subjugated_by_archaon = enemy_faction_obj:was_confederated_by_faction(archaon_faction_obj) or enemy_faction_obj:is_vassal_of(archaon_faction_obj)

				-- Vassalize-type factions get merged into their god's vassal owner faction rather than into Archaon directly
				if not subjugated_by_archaon then
					for _, vassal_owner_data in dpairs(archaon_subjugation_config.culture_key_to_vassal_owner_data_list) do
						local vassal_owner_faction_obj = cm:get_faction(vassal_owner_data.faction_key)
						if enemy_faction_obj:was_confederated_by_faction(vassal_owner_faction_obj) or enemy_faction_obj:is_vassal_of(vassal_owner_faction_obj) then
							subjugated_by_archaon = true
							break
						end
					end
				end

				if subjugated_by_archaon then
					table.insert(self.persistent.subjugated_legendary_lord_faction_key_list, enemy_faction_key)
				end
			end
		end
	end

	local subjugate_legendary_lords_objective = self.config.mission_data.long_victory_mission.subjugate_legendary_lords_objective
	local subjugated_total = table.size(self.persistent.subjugated_legendary_lord_faction_key_list)

	cm:set_scripted_mission_text(
		self.config.mission_data.long_victory_mission.mission_key,
		subjugate_legendary_lords_objective.script_key,
		subjugate_legendary_lords_objective.description_text,
		subjugated_total,
		subjugate_legendary_lords_objective.total_legendary_lords_required
	)

	if subjugated_total >= subjugate_legendary_lords_objective.total_legendary_lords_required then
		self:complete_long_victory_objective(subjugate_legendary_lords_objective.script_key)
		core:remove_listener("ArchaonTracksSubjugatedLegendaryLords")
	end
end

-- Records an objective of the current Long Victory path as completed. Safe to call more than once for the same objective, as the mission itself survives a save/load and must not be credited twice.
function archaon_narrative:complete_long_victory_objective(objective_id, script_key)
	if table.contains(self.persistent.completed_long_victory_objective_id_list, objective_id) then
		return
	end

	table.insert(self.persistent.completed_long_victory_objective_id_list, objective_id)
	self.persistent.completed_long_victory_objectives = table.size(self.persistent.completed_long_victory_objective_id_list)

	-- The destroy-factions objective is tracked natively by code, so it has no scripted objective to mark
	if script_key ~= false then
		cm:complete_scripted_mission_objective(self.config.archaon_faction_key, self.config.mission_data.long_victory_mission.mission_key, script_key or objective_id, true)
	end

	core:trigger_event(self.config.mission_data.long_victory_mission.objective_competed_event_key)
end

function archaon_narrative:check_long_victory_objectives_completed(option_key)
	local long_victory_mission_data = self.config.mission_data.long_victory_mission

	if self.persistent.completed_long_victory_objectives < long_victory_mission_data.main_objective_options[option_key].total_objectives_to_complete then
		return
	end

	cm:complete_scripted_mission_objective(self.config.archaon_faction_key, long_victory_mission_data.mission_key, long_victory_mission_data.main_objective_script_key, true)
	core:remove_listener("ArchaonCompletesAllLongVictoryObjectives")
end

-- Derived from the model rather than accumulated from events, as targets killed or vassalised before this path was chosen never reached the listeners below
function archaon_narrative:update_destroyed_factions_objective()

	local destroy_factions_objective = self.config.mission_data.long_victory_mission.destroy_factions_objective
	local archaon_faction_obj = cm:get_faction(self.config.archaon_faction_key)
	local destroyed_enemy_faction_key_list = {}

	for i = 1, #destroy_factions_objective.faction_key_list do
		local enemy_faction_key = destroy_factions_objective.faction_key_list[i]
		local enemy_faction_obj = cm:get_faction(enemy_faction_key)

		-- Matches the code-side DESTROY_FACTION objective, which was generated allowing confederation and vassalisation
		if not enemy_faction_obj or enemy_faction_obj:is_null_interface() or enemy_faction_obj:is_dead() or enemy_faction_obj:is_vassal_of(archaon_faction_obj) then
			table.insert(destroyed_enemy_faction_key_list, enemy_faction_key)
		end
	end

	self.persistent.destroyed_enemy_faction_key_list = destroyed_enemy_faction_key_list

	if table.size(destroyed_enemy_faction_key_list) >= table.size(destroy_factions_objective.faction_key_list) then
		self:complete_long_victory_objective(destroy_factions_objective.objective_id, false)
		core:remove_listener("ArchaonTracksDestroyedFactionsLong")
		core:remove_listener("ArchaonTracksVassalisedFactionsLong")
	end
end

-- Recovers savegames written before the mission stopped being rebuilt on load, where the mission's own objective counts had been reset to zero
function archaon_narrative:resync_long_victory_objective_counts(option_key)
	local long_victory_mission_data = self.config.mission_data.long_victory_mission

	cm:callback(
		function()
			-- The chosen path's description is only applied when the mission is built, so restate it in case an older savegame lost it
			cm:set_scripted_mission_text(long_victory_mission_data.mission_key, long_victory_mission_data.main_objective_script_key, long_victory_mission_data.main_objective_options[option_key].description_text)

			self:update_destroyed_factions_objective()

			if option_key == long_victory_mission_data.main_objective_options.option_1.key then
				self:find_already_subjugated_legendary_lords()
				self:update_owned_or_allied_dark_fortresses_objective()
			else
				local devastation_objective = long_victory_mission_data.devastation_objective

				cm:set_scripted_mission_text(
					long_victory_mission_data.mission_key,
					devastation_objective.script_key,
					devastation_objective.description_text,
					self.persistent.devastated_provinces_total,
					devastation_objective.total_provinces_to_devastate
				)

				if self.persistent.devastated_provinces_total >= devastation_objective.total_provinces_to_devastate then
					self:complete_long_victory_objective(devastation_objective.script_key)
					core:remove_listener("ArchaonDevastatesProvince")
				end
			end

			-- Nothing will fire objective_competed_event_key if the path was already finished before this savegame was made
			self:check_long_victory_objectives_completed(option_key)
		end,
		0.5
	)
end

function archaon_narrative:add_victory_objective_listeners(option_key)

	local long_victory_mission_data = self.config.mission_data.long_victory_mission

	if option_key == long_victory_mission_data.main_objective_options.option_1.key then

		-- Tracking progress of "Own/Ally 16 Dark Fortresses" objective - updated when region ownership changes
		core:add_listener(
			"ArchaonTracksOwnedOrAlliedDarkFortresses",
			"RegionFactionChangeEvent",
			function(context)
				return context:region():is_contained_in_region_group(long_victory_mission_data.dark_fortress_objective.region_group)
			end,
			function(context)
				self:update_owned_or_allied_dark_fortresses_objective()
			end,
			true
		)

		-- Tracking progress of "Own/Ally 16 Dark Fortresses" objective - updated when Archaon gains a vassal
		core:add_listener(
			"ArchaonTracksVassalisedDarkFortresses",
			"PositiveDiplomaticEvent",
			function(context)
				if not context:is_vassalage() then
					return false
				end

				if context:proposer():name() == self.config.archaon_faction_key then
					return not context:proposer_is_vassal()
				end

				return context:recipient():name() == self.config.archaon_faction_key and context:proposer_is_vassal()
			end,
			function(context)
				self:update_owned_or_allied_dark_fortresses_objective()
			end,
			true
		)

		-- Tracking progress of "Subjugate 8 Chaos Legendary Lords" objective
		core:add_listener(
			"ArchaonTracksSubjugatedLegendaryLords",
			long_victory_mission_data.subjugate_legendary_lords_objective.subjugation_event_key,
			true,
			function(context)
				local subjugated_faction_key = context.string
				if not table.contains(self.persistent.subjugated_legendary_lord_faction_key_list, subjugated_faction_key) then
					table.insert(self.persistent.subjugated_legendary_lord_faction_key_list, subjugated_faction_key)
					cm:increase_scripted_mission_count(long_victory_mission_data.mission_key, long_victory_mission_data.subjugate_legendary_lords_objective.script_key, 1)

					if table.size(self.persistent.subjugated_legendary_lord_faction_key_list) >= long_victory_mission_data.subjugate_legendary_lords_objective.total_legendary_lords_required then
						self:complete_long_victory_objective(long_victory_mission_data.subjugate_legendary_lords_objective.script_key)
						core:remove_listener("ArchaonTracksSubjugatedLegendaryLords")
					end
				end
			end,
			true
		)

	else
		
		-- Tracking progress of "Devastate 8 provinces" objective
		core:add_listener(
			"ArchaonDevastatesProvince",
			long_victory_mission_data.devastation_objective.devastation_event_key,
			true,
			function(context)
				cm:increase_scripted_mission_count(long_victory_mission_data.mission_key, long_victory_mission_data.devastation_objective.script_key, 1)
				if self.persistent.devastated_provinces_total >= long_victory_mission_data.devastation_objective.total_provinces_to_devastate then
					self:complete_long_victory_objective(long_victory_mission_data.devastation_objective.script_key)
					core:remove_listener("ArchaonDevastatesProvince")
				end
			end,
			true
		)
	end

	-- Tracking progress of shared "Reach Faction Strength Rank 1" objective - re-completed here since the short victory listener only completes it on wh_main_short_victory
	core:add_listener(
		"ArchaonTracksFactionStrengthRankLong",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == self.config.archaon_faction_key
		end,
		function(context)
				if cm:model():world():faction_strength_rank(context:faction()) == 1 then
					self:complete_long_victory_objective(long_victory_mission_data.strength_rank_objective.script_key)
					core:remove_listener("ArchaonTracksFactionStrengthRankLong")
				end
			end,
			true
		)

	-- Tracking progress of shared "Destroy or vassalise the Empire successor factions" objective, which the engine tracks natively - we only need to know when it's done
		core:add_listener(
		"ArchaonTracksDestroyedFactionsLong",
			"FactionDeath",
			function(context)
			return table.contains(long_victory_mission_data.destroy_factions_objective.faction_key_list, context:faction():name())
			end,
			function(context)
				self:update_destroyed_factions_objective()
			end,
			true
		)

	-- Vassalising a target faction also satisfies the objective, and raises no FactionDeath
	core:add_listener(
		"ArchaonTracksVassalisedFactionsLong",
		"PositiveDiplomaticEvent",
		function(context)
			if not context:is_vassalage() then
				return false
			end

			if context:proposer():name() == self.config.archaon_faction_key then
				return not context:proposer_is_vassal()
			end

			return context:recipient():name() == self.config.archaon_faction_key and context:proposer_is_vassal()
		end,
		function(context)
			self:update_destroyed_factions_objective()
		end,
		true
	)

	-- Complete long_victory_mission.main_objective_script_key when this path's objectives are all completed
		core:add_listener(
			"ArchaonCompletesAllLongVictoryObjectives",
		long_victory_mission_data.objective_competed_event_key,
			true,
			function(context)
				self:check_long_victory_objectives_completed(option_key)
			end,
			true
		)
	end

function archaon_narrative:update_owned_or_allied_dark_fortresses_objective()

	local long_victory_mission_data = self.config.mission_data.long_victory_mission
	local dark_fortress_objective = long_victory_mission_data.dark_fortress_objective
	local archaon_faction_obj = cm:get_faction(self.config.archaon_faction_key)
	local owned_or_allied_dark_fortress_key_list = {}

	for i, faction in model_pairs(cm:get_faction_list()) do
		local is_archaon = faction:name() == self.config.archaon_faction_key
		local is_archaon_vassal = not faction:master():is_null_interface() and faction:master():name() == self.config.archaon_faction_key
		local is_archaon_ally = not is_archaon and faction:allied_with(archaon_faction_obj)

		if is_archaon or is_archaon_vassal or is_archaon_ally then
			local region_list = faction:region_list()
			for j = 0, region_list:num_items() - 1 do
				local region_obj = region_list:item_at(j)
				if region_obj:is_contained_in_region_group(dark_fortress_objective.region_group) then
					table.insert(owned_or_allied_dark_fortress_key_list, region_obj:name())
				end
			end
		end
	end

	self.persistent.owned_or_allied_dark_fortress_key_list = owned_or_allied_dark_fortress_key_list
	local controlled_fortresses_total = table.size(owned_or_allied_dark_fortress_key_list)

	cm:set_scripted_mission_text(long_victory_mission_data.mission_key, dark_fortress_objective.script_key, dark_fortress_objective.description_text, controlled_fortresses_total, dark_fortress_objective.total_dark_fortresses_required)

	if controlled_fortresses_total >= dark_fortress_objective.total_dark_fortresses_required then
		self:complete_long_victory_objective(dark_fortress_objective.script_key)
		core:remove_listener("ArchaonTracksOwnedOrAlliedDarkFortresses")
		core:remove_listener("ArchaonTracksVassalisedDarkFortresses")
	end
end

function archaon_narrative:apply_devastated_province_bonus()

	if self.persistent.devastated_provinces_total == 0 then 
		return
	end

	local archaon_faction_obj = cm:get_faction(self.config.archaon_faction_key)
	
	if archaon_faction_obj:has_effect_bundle(self.config.devastation_data.devastation_bonus_effect_bundle_key) then
		cm:remove_effect_bundle(self.config.devastation_data.devastation_bonus_effect_bundle_key, self.config.archaon_faction_key)
	end

	local scaled_bundle = cm:create_new_custom_effect_bundle(self.config.devastation_data.devastation_bonus_effect_bundle_key)
	local scale_bonus = self.persistent.devastated_provinces_total * 2
	scaled_bundle:add_effect(self.config.devastation_data.devastation_bonus_effect_key_ward, 	self.config.devastation_data.devastation_bonus_efect_scope_archaon, scale_bonus)
	scaled_bundle:add_effect(self.config.devastation_data.devastation_bonus_effect_key_upkeep, 	self.config.devastation_data.devastation_bonus_efect_scope_faction, -scale_bonus)
	scaled_bundle:add_effect(self.config.devastation_data.devastation_bonus_effect_key_income, 	self.config.devastation_data.devastation_bonus_efect_scope_faction, scale_bonus)

	cm:apply_custom_effect_bundle_to_faction(scaled_bundle, archaon_faction_obj)

end

function archaon_narrative:restrict_vassals_occupation()	
	local archaon_vassal_obj_list = cm:get_faction(self.config.archaon_faction_key):vassals()
	for i = 0, archaon_vassal_obj_list:num_items() - 1 do
		local vassal_faction_obj = archaon_vassal_obj_list:item_at(i)
		cm:add_or_remove_faction_features(vassal_faction_obj, {"can_be_regionless"}, true)
		cm:add_or_remove_faction_features(vassal_faction_obj, {"can_own_regions"}, false)
	end
end

function archaon_narrative:is_province_devastateable(province_key)
	if table.contains(self.persistent.devastated_province_key_list, province_key) then
		return false
	end

	-- Check for other sources of devastation
	if cm:is_campaign_map_event_area_activated_in_region(cm:get_province(province_key):capital_region():name()) then
		return false
	end

	return true
end

function archaon_narrative:devastate_province(region_obj, faction_obj)
	local event_area_type = region_obj:event_area_type()
	local event_area_key = region_obj:event_area_name()
	local province_key = region_obj:province_name()

	if is_nil(event_area_type) or is_nil(event_area_key) then
		script_error(string.format("ERROR: Devastated region '%s' has no event_area_type or event_area_key specified.", region_obj:name()))
		return
	end

	cm:activate_campaign_map_event_area(event_area_key, faction_obj:culture())

	local region_list = region_obj:regions_in_same_event_area()

	if region_list and not region_list:is_null_interface() then
		for i = 0, region_list:num_items() - 1 do
			local current_region = region_list:item_at(i)
			climate_change:add_climate_override(current_region, self.config.devastation_data.climate)
			cm:apply_effect_bundle_to_region(self.config.devastation_data.devastation_effect_bundle, current_region:name(), 0)
		end
	else
		climate_change:add_climate_override(region_obj, self.config.devastation_data.climate)
		cm:apply_effect_bundle_to_region(self.config.devastation_data.devastation_effect_bundle, region_obj:name(), 0)
	end

	self.persistent.devastated_provinces_total = self.persistent.devastated_provinces_total + 1
	table.insert(self.persistent.devastated_province_key_list, province_key)
	core:trigger_event(self.config.mission_data.long_victory_mission.devastation_objective.devastation_event_key)
	self:apply_devastated_province_bonus()

	-- TODO: update this when possible to include province name, faction who performed devastation and bonus received by Archaon
	cm:show_message_event_located(
		self.config.archaon_faction_key,
		"event_feed_strings_text_" .. "wh3_dlc29_event_feed_string_scripted_event_archaon_devastation_title",
		"provinces_onscreen_" .. province_key,
		"event_feed_strings_text_" .. "wh3_dlc29_event_feed_string_scripted_event_archaon_devastation_secondary_detail",
		region_obj:settlement():logical_position_x(),
		region_obj:settlement():logical_position_y(),
		true,
		667
	)
end

function archaon_narrative:devastate_region(region_obj, faction_obj)
	local region_key = region_obj:name()
	local settlement_obj = region_obj:settlement()
	local event_area_type = region_obj:event_area_type()
	if is_nil(event_area_type) then
		script_error(string.format("ERROR: Devastated region '%s' has no event_area_type specified.", region_key))
		return
	end

	-- Settlements razed by Archaon or his vassals will not be possible to colonise/resettle anymore
	cm:cai_disable_targeting_against_settlement("settlement:"..region_key)
	cm:apply_effect_bundle_to_region(self.config.devastation_data.block_occupation_effect_bundle, region_key, 0)

	cm:reset_settlement_type(settlement_obj, self.config.devastation_data.settlement_type, 1)
	cm:set_settlement_devastated_state(settlement_obj, self.config.devastation_data.settlement_state)

	-- Check if devastating this region will cause devasstation of province
	local province_obj = region_obj:province()
	if self:is_province_devastateable(province_obj:key()) then
		local province_region_obj_list = province_obj:regions()
		local total_regions_in_province = province_region_obj_list:num_items()
		local required_regions_razed_amount_to_devastate = math.modf(total_regions_in_province / 2) + 1
		local abandoned_region_amount_in_province = 0

		for i = 0, total_regions_in_province - 1 do
			if province_region_obj_list:item_at(i):is_abandoned() then
				abandoned_region_amount_in_province = abandoned_region_amount_in_province + 1
			end 
		end

		-- Once enough regions are devastated - whole province becomes visually devastated
		if abandoned_region_amount_in_province >= required_regions_razed_amount_to_devastate then
			self:devastate_province(region_obj, faction_obj)
		end
	end
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("archaon_narrative.persistent", archaon_narrative.persistent, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			archaon_narrative.persistent = cm:load_named_value("archaon_narrative.persistent", archaon_narrative.persistent, context)
		end
	end
)