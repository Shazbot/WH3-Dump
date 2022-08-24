champions_narrative = {
	souls_threshold = {10000, 30000, 50000},
	shared_state_zanbaijin = "zanbaijin_bar_active",
	shared_state_sigils = "sigils_count_active",
	call_to_arms_incident_key = "wh3_dlc20_story_panel_call_to_arms_chs",
	epilogue_incident_prefix = "wh3_dlc20_incident_epilogue_chs_",
	souls_victory_condition = "souls_requirement",
	rifts_victory_condition = "rifts_requirement",
	final_battle_victory_condition = "champions_final_battle",
	souls_resource_key = "wh3_dlc20_chs_souls",
	progress_resource_key = "wh3_dlc20_chs_champions_campaign_progress",
	progress_resource_factor_key = "souls_gain",
	rift_network_resource_key = "wh3_dlc20_chs_teleport_network_rift_resource",
	rift_network_resource_factor_key = "rifts",
	neutral_network_template_key = "wh3_dlc20_teleportation_node_template_neutral",
	chaos_network_key = "wh3_dlc20_teleportation_network_chaos",
	required_rifts_for_zanbaijin = 7,
	final_battle_rift_reward = 10,
	rift_incident_key = "wh3_dlc20_incident_champions_progression_",
	zanbaijin_template_key = "wh3_dlc20_teleportation_node_template_zanbaijin",
}

champions_narrative.objectives = {
	wh3_dlc20_chs_azazel  	= {
		mission = "wh3_dlc20_survival_altar_of_battle_wh3_dlc20_chs_azazel",
		mission_activated = false,
		advice_key = "wh3_dlc20_azazel_cam_final_battle_mission_001",
	},
	wh3_dlc20_chs_festus 	= {
		mission = "wh3_dlc20_survival_altar_of_battle_wh3_dlc20_chs_festus",
		mission_activated = false,
		advice_key = "wh3_dlc20_festus_cam_final_battle_mission_001",
	},
	wh3_dlc20_chs_valkia 	= {
		mission = "wh3_dlc20_survival_altar_of_battle_wh3_dlc20_chs_valkia",
		mission_activated = false,
		advice_key = "wh3_dlc20_valkia_cam_final_battle_mission_001",
	},
	wh3_dlc20_chs_vilitch 	= {
		mission = "wh3_dlc20_survival_altar_of_battle_wh3_dlc20_chs_vilitch",
		mission_activated = false,
		advice_key = "wh3_dlc20_vilitch_cam_final_battle_mission_001",
	}, 
}

champions_narrative.counters = {
	current_rifts_opened = 0,
	total_possible_rifts = 0,
	souls_threshold_reached = {false, false, false},
}

champions_narrative.movie = {
	wh3_dlc20_chs_azazel  	= {
		path = "warhammer3/champions/dlc20_azazel_win", 
		unlock_str = "dlc20_azazel_win"
	},
	wh3_dlc20_chs_festus 	= {
		path = "warhammer3/champions/dlc20_festus_win", 
		unlock_str = "dlc20_festus_win"
	},
	wh3_dlc20_chs_valkia 	= {
		path = "warhammer3/champions/dlc20_valkia_win", 
		unlock_str = "dlc20_valkia_win"
	},
	wh3_dlc20_chs_vilitch 	= {
		path = "warhammer3/champions/dlc20_vilitch_win", 
		unlock_str = "dlc20_vilitch_win"
	}, 

}

champions_narrative.factions_to_node_templates = {
	wh3_dlc20_chs_azazel  	= {
		node_template 		= 	"wh3_dlc20_teleportation_node_template_azazel",
		start_node 			= 	"wh3_dlc20_node_azazel_start"
	},
	wh3_dlc20_chs_festus 	= {
		node_template 		= 	"wh3_dlc20_teleportation_node_template_festus",
		start_node 			= 	"wh3_dlc20_node_festus_start"
	},
	wh3_dlc20_chs_valkia 	= {
		node_template 		= 	"wh3_dlc20_teleportation_node_template_valkia",
		start_node 			= 	"wh3_dlc20_node_valkia_start"
	},
	wh3_dlc20_chs_vilitch 	= {
		node_template 		= 	"wh3_dlc20_teleportation_node_template_vilitch",
		start_node 			= 	"wh3_dlc20_node_vilitch_start"
	},
}



---------------------
--------SETUP--------
---------------------

function champions_narrative:initialise()
	-- activate zanbaijin bar and sigil counter
	cm:set_script_state(self.shared_state_zanbaijin, true)
	cm:set_script_state(self.shared_state_sigils, true)

	-- Add listener for a character moving through a teleport network, this is to convert a neutral node to a faction owned node after travel
	core:add_listener(
		"TeleportationNetworkMoveCompletedChampions",
		"TeleportationNetworkMoveCompleted",
		function(context)
			local destination_node_key = context:to_key()
			local network = cm:model():world():teleportation_network_system():lookup_network(self.chaos_network_key)
			local destination_node_template = network:lookup_open_node(destination_node_key):template_key()

			return destination_node_template == self.neutral_network_template_key
		end,
		function(context)

			local destination_node_key = context:to_key()
			local travelling_faction = context:character():character():faction()
			local faction_key = travelling_faction:name()

			local faction_templates = self.factions_to_node_templates[faction_key]
			local new_template = faction_templates.node_template

			local network = cm:model():world():teleportation_network_system():lookup_network(self.chaos_network_key)

			if new_template then

				local destination_node_template = network:lookup_open_node(destination_node_key):template_key()

				if destination_node_template == self.neutral_network_template_key then
					cm:teleportation_network_close_node(destination_node_key)

					cm:callback(
						function()
							cm:teleportation_network_open_node(destination_node_key, new_template)
						end,
					0.5)
				end
			end

			self:champions_network_tracker(faction_key)
		end,
		true
	)

	-- Set listener for a Node being closed by a Champions character, this will convert the node to a faction owned node after closing
	core:add_listener(
		"TeleportationNetworkNodeClosedChampions",
		"TeleportationNetworkNodeClosed",
		function(context)
			local node_key = context:node_key()
			local node_template = context:template_key()
			local closing_character = context:closing_character()

			return node_template == self.neutral_network_template_key and not closing_character:is_null_interface()
		end,
		function(context)
			local node_key = context:node_key()
			local node_template = context:template_key()

			local faction = context:closing_character():character():faction()
			local faction_key = faction:name()

			local faction_templates = self.factions_to_node_templates[faction_key]
			local new_template = faction_templates.node_template

			if new_template then
					cm:callback(
						function()
							cm:teleportation_network_open_node(node_key, new_template)
						end,
					0.5)
			end

			self:champions_network_tracker(faction_key)

		end,
		true
	)

	---echo any Souls gain and apply it to the Path to Zanbaijin
	for faction, objectives in pairs(self.objectives) do
		cm:add_pooled_resource_changed_listener_by_faction(
			"PooledResourceChangedSouls",
			faction,
			function(context)
				local amount = context:amount()
				if context:resource():key() == self.souls_resource_key and amount > 0 then
					cm:faction_add_pooled_resource(context:faction():name(), self.progress_resource_key, self.progress_resource_factor_key, amount)
				end
			end,
			true
		)
	end

	-- Set listener for the progression pooled resource crossing the thresholds set in the script, when a threshold is crossed a Rift resource is granted
	core:add_listener(
		"Souls_Threshold_Reached",
		"PooledResourceChanged",
		function(context)
			local faction = context:faction()	
			if not faction:is_null_interface() then		
				local faction_key = faction:name()		
				local narrative_counters = self.counters	
				if self.objectives[faction_key] then
					local pooled_resource = context:resource()
					local next_threshold = 1
					if narrative_counters.souls_threshold_reached[3] then
						return false
					elseif narrative_counters.souls_threshold_reached[2] then
							next_threshold = 3	
					elseif narrative_counters.souls_threshold_reached[1] then
						next_threshold = 2
					end

					return (pooled_resource:key() == self.progress_resource_key) and faction:is_human() and (pooled_resource:value() >= self.souls_threshold[next_threshold]) 
				end
			end
			return false
		end,
		function(context)
			local faction_key = context:faction():name()
			local pooled_resource = context:resource()
			local faction_templates = self.factions_to_node_templates[faction_key]
			local narrative_counters = self.counters

			--Number of Rift Sigils to grant player (2 is the amount for the first and second threshold)
			local sigil_reward_amount = 2

			-- Check which progression threshold the player just crossed
			local current_threshold = 1
			if narrative_counters.souls_threshold_reached[2] then
				narrative_counters.souls_threshold_reached[3] = true
				current_threshold = 3
				-- Final threshold grants 3 Rift Sigils instead of 2
				sigil_reward_amount = 3
				--Complete Souls threshold victory condition
				cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", self.souls_victory_condition, true)
			elseif narrative_counters.souls_threshold_reached[1] then
				narrative_counters.souls_threshold_reached[2] = true
				current_threshold = 2
			else
				narrative_counters.souls_threshold_reached[1] = true
			end

			-- Grant player a Rift shard so they can open an additional Chaos Rift
			cm:faction_add_pooled_resource(faction_key, self.rift_network_resource_key, self.rift_network_resource_factor_key, sigil_reward_amount)

			-- Increase the total possible Chaos Rifts opened by player by number of new Rift Sigils
			narrative_counters.total_possible_rifts = narrative_counters.total_possible_rifts + sigil_reward_amount

			-- Check if the first threshold has reached to forcibly open the starting province Rift
			if current_threshold == 1 then
				cm:teleportation_network_open_node(faction_templates.start_node, faction_templates.node_template)
			end

			-- Open 20 random neutral nodes and make sure Zanbaijin is closed whenevr a Progress threshold is reached
			cm:teleportation_network_open_random_nodes(self.chaos_network_key, self.neutral_network_template_key, 20)

			cm:trigger_incident(faction_key, self.rift_incident_key .. current_threshold, true)
			
		end,
		true
	)

	-- handle players completing the campaign
	core:add_listener(
		"player_wins_survival_battle",
		"MissionSucceeded",
		function(context)
			local faction_key = context:faction():name()
			if self.objectives[faction_key] then
				local objectives = self.objectives[faction_key]
				return objectives.mission == context:mission():mission_record_key()
			end
			return false
		end,
		function(context)
			local faction_key = context:faction():name()
			local movie = self.movie[faction_key]
			local win_movie = movie.path
			local win_unlock_key = movie.unlock_str
			cm:set_saved_value("campaign_completed", true);
			
			core:svr_save_registry_bool(win_unlock_key, true);
			cm:register_instant_movie(win_movie);

			cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", self.final_battle_victory_condition, true);

			-- Open 50 random neutral nodes for player
			cm:teleportation_network_open_random_nodes(self.chaos_network_key, self.neutral_network_template_key, 50)

			-- Increase possible Rifts by the final battle mission reward amount
			local narrative_counters = self.counters
			narrative_counters.total_possible_rifts = narrative_counters.total_possible_rifts + self.final_battle_rift_reward

			-- remove zanbaijin bar
			cm:set_script_state(self.shared_state_zanbaijin, false)

			-- Epilogue
			cm:add_turn_countdown_event(faction_key, 1, "ScriptEventShowEpilogueEvent_COC", faction_key);
			core:add_listener(
				"epilogue_coc",
				"ScriptEventShowEpilogueEvent_COC",
				true,
				function(context)
					local faction_key = context.string;
					
					cm:trigger_incident(faction_key, self.epilogue_incident_prefix .. faction_key, true);
				end,
				false
			);


		end,
		false
	);

	-- Move camera to character arriving at rift teleport destination
	core:add_listener(
		"coc_army_teleports_to_rift",
		"TeleportationNetworkMoveCompleted",
		function(context)
			return not context:character():character():is_null_interface() and context:success()
		end,
		function(context)
			local to_template_key = context:to_record():template_key()
			local character = context:character():character()
			local faction_name = character:faction():name();

			-- cut camera to character that's come out of the rift
			if cm:get_local_faction_name(true) == faction_name then
				local cached_x, cached_y, cached_d, cached_b, cached_h = cm:get_camera_position();
				cm:scroll_camera_from_current(true, 1, {character:display_position_x(), character:display_position_y(), 13, cached_b, 10});
			end;
		end,
		true
	);


end

function champions_narrative:champions_network_tracker(faction_key)

	local narrative_counters = self.counters

	narrative_counters.current_rifts_opened = narrative_counters.current_rifts_opened + 1

	if narrative_counters.current_rifts_opened == narrative_counters.total_possible_rifts then
		-- close all open neutral rifts if the number of open rifts is equal to the number of total rifts
		cm:teleportation_network_close_all_nodes(self.chaos_network_key, self.neutral_network_template_key)
		
		local objectives = self.objectives[faction_key]

		if narrative_counters.souls_threshold_reached[#narrative_counters.souls_threshold_reached] and narrative_counters.current_rifts_opened >= self.required_rifts_for_zanbaijin and objectives.mission_activated == false then

			--mark the final battle mission as active
			objectives.mission_activated = true
			cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", self.rifts_victory_condition, true);

			cm:teleportation_network_open_node("wh3_dlc20_champions_node_zanbaijin", "wh3_dlc20_teleportation_node_template_zanbaijin")

			--Trigger Call to Arms
			cm:trigger_incident(faction_key, self.call_to_arms_incident_key, true, true)

			cm:callback( 
				function() 
					--Trigger Final Battle Mission
					cm:trigger_mission(faction_key, objectives.mission, true)
				end,
				0.5
			)
		end
	end


end


--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("ChampionsNarrativeMissionObjectives", champions_narrative.objectives, context)
		cm:save_named_value("ChampionsNarrativeCounters", champions_narrative.counters, context)
	end
);
cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			champions_narrative.objectives = cm:load_named_value("ChampionsNarrativeMissionObjectives", champions_narrative.objectives, context)
			champions_narrative.counters = cm:load_named_value("ChampionsNarrativeCounters", champions_narrative.counters, context)
		end
	end
)