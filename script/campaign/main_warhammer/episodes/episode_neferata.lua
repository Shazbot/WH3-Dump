episode_neferata = {
	episode_name = "episode_neferata",
	episode_set = "neferata_narrative",
	faction_key = "wh3_dlc29_vmp_neferata",
	invasion_spawn_coords = {{808, 659}, {839, 654}, {845, 647}},
	vmp_invastion_faction_key = "wh_main_vmp_vampire_counts_qb1",
	incident_act_1 = "wh3_dlc29_vmp_neferatas_rise",
	incident_act_2 = "wh3_dlc29_vmp_queen_of_vampires",
	incident_act_3 = "wh3_dlc29_vmp_conquest_of_lahmia",
	neferata_narrative_build_web_of_power = "wh3_dlc29_vmp_mission_neferata_narrative_build_web_of_power",
	neferata_narrative_fairest_bloodline = "wh3_dlc29_vmp_mission_neferata_narrative_fairest_bloodline",
	neferata_narrative_united_in_service = "wh3_dlc29_vmp_mission_neferata_narrative_bloodlines",
	neferata_narrative_death_to_the_unworthy = "wh3_dlc29_vmp_mission_neferata_death_to_the_unworthy",
	neferata_narrative_web_of_power_1 = "wh3_dlc29_vmp_mission_neferata_narrative_web_of_power_1",
	neferata_narrative_web_of_power_2 = "wh3_dlc29_vmp_mission_neferata_narrative_web_of_power_2", 
	neferata_narrative_web_of_power_3 = "wh3_dlc29_vmp_mission_neferata_narrative_web_of_power_3",
	neferata_narrative_silver_sisterhood = "wh3_dlc29_vmp_mission_neferata_narrative_silver_sisterhood",
	silver_sisterhood_quest_battle = "wh3_dlc29_qb_vmp_silver_sisterhood",
	confederation_mission_mannfred = "wh3_dlc29_vmp_mission_neferata_narrative_confederate_mannfred",
	confederation_mission_vlad_isabella = "wh3_dlc29_vmp_mission_neferata_narrative_confederate_vlad_isabella",	
	first_mission_pool_res_amount = 150,
	second_mission_pool_res_amount = 500,
	third_mission_pool_res_amount = 1000,
	episode_turn_start = 2,
	final_quest_battle = "wh3_dlc29_qb_vmp_dream_of_lahmia",
	lahmia_region_key =  "wh3_main_combi_region_lahmia",
	pool_res_manipulation = "wh3_dlc29_nef_manipulation",
	faction_trait_effect_bundle = "wh3_dlc29_vmp_neferata_narrative_no_withdraw",
	vampire_coven = "wh3_dlc29_vampire_coven",
	dream_of_lamia_quest_battle_key = "wh3_dlc29_qb_vmp_dream_of_lahmia",
	bloodlines_mission_constructed_lairs = 5,
	vlad_isabella_faction = "wh_main_vmp_schwartzhafen",
	vlad_subtype = "wh_dlc04_vmp_vlad_con_carstein",
	mannfred_faction = "wh_main_vmp_vampire_counts",
	mannfred_subtype = "wh_main_vmp_mannfred_von_carstein",
	-- TODO: enable the episode when it is working properly
	episode_disabled = false,
	
	episode_active_shared_state = "episode_neferata_active",

	mission_override_texts = {
		["wh3_dlc29_vmp_mission_neferata_narrative_build_web_of_power"] = {
			"wh3_dlc29_vmp_mission_neferata_narrative_build_web_of_power_description"
		},
		["wh3_dlc29_vmp_mission_neferata_narrative_web_of_power_1"] = {
			"wh3_dlc29_vmp_mission_neferata_narrative_web_of_power_1_description",
		},
		["wh3_dlc29_vmp_mission_neferata_narrative_fairest_bloodline"] = {
			"wh3_dlc29_vmp_mission_neferata_narrative_fairest_bloodline_description"
		},
		["wh3_dlc29_vmp_mission_neferata_narrative_bloodlines"] = {
			"wh3_dlc29_vmp_mission_neferata_narrative_bloodlines_description"
		},
		["wh3_dlc29_vmp_mission_neferata_narrative_web_of_power_2"] = {
			"wh3_dlc29_vmp_mission_neferata_narrative_web_of_power_2_description"
		},
		["wh3_dlc29_vmp_mission_neferata_narrative_web_of_power_3"] = {
			"wh3_dlc29_vmp_mission_neferata_narrative_web_of_power_3_description"
		},
		["wh3_dlc29_vmp_mission_neferata_narrative_silver_sisterhood"] = {
			"wh3_dlc29_vmp_mission_neferata_narrative_silver_sisterhood_description"
		},
		["wh3_dlc29_vmp_mission_neferata_narrative_confederate_mannfred"] = {
			"wh3_dlc29_vmp_mission_neferata_narrative_mannfred_description"
		},
		["wh3_dlc29_vmp_mission_neferata_narrative_confederate_vlad_isabella"] = {
			"wh3_dlc29_vmp_mission_neferata_narrative_vlad_isabella_description"
		},
	},
	mission_payloads = {
		["wh3_dlc29_vmp_mission_neferata_narrative_build_web_of_power"] = {
			"money 500",
			"faction_pooled_resource_transaction{resource wh3_dlc29_vmp_power;factor events;amount 100;context absolute;}"
		},
		["wh3_dlc29_vmp_mission_neferata_narrative_web_of_power_1"] = {
			"money 500",
			"faction_pooled_resource_transaction{resource wh3_dlc29_vmp_power;factor events;amount 100;context absolute;}"
		},
		["wh3_dlc29_vmp_mission_neferata_narrative_fairest_bloodline"] = {
			"money 1000",
			"faction_pooled_resource_transaction{resource wh3_dlc29_vmp_power;factor events;amount 200;context absolute;}"
		},
		["wh3_dlc29_vmp_mission_neferata_narrative_bloodlines"] = {
			"money 1000",
			"faction_pooled_resource_transaction{resource wh3_dlc29_vmp_power;factor events;amount 200;context absolute;}"
		},
		["wh3_dlc29_vmp_mission_neferata_narrative_web_of_power_2"] = {
			"money 1000",			
			"effect_bundle{bundle_key wh3_dlc29_vmp_effect_bundle_neferata_narrative_diplomacy_mod_vampires_negative;turns 5;}"
		},
		["wh3_dlc29_vmp_mission_neferata_narrative_web_of_power_3"] = {
			"money 1500",
			"faction_pooled_resource_transaction{resource wh3_dlc29_vmp_power;factor events;amount 250;context absolute;}"
		},
		["wh3_dlc29_vmp_mission_neferata_narrative_confederate_mannfred"] = {
			"text_display dummy_wh3_dlc29_vmp_neferata_confederate_mannfred"
		},
		["wh3_dlc29_vmp_mission_neferata_narrative_confederate_vlad_isabella"] = {
			"text_display dummy_wh3_dlc29_vmp_neferata_confederate_vlad_isabela"
		},
		["wh3_dlc29_vmp_mission_neferata_narrative_silver_sisterhood"] = {
			"text_display dummy_wh3_dlc29_vmp_mission_neferata_narrative_silver_sisterhood"
		},
	},

	vampire_lair_buildings = {
		["wh3_dlc29_vmp_lair_primary_2_blood_dragon"] = true,
		["wh3_dlc29_vmp_lair_primary_2_lahmian"] = true,
		["wh3_dlc29_vmp_lair_primary_2_necrarch"] = true,
		["wh3_dlc29_vmp_lair_primary_2_strigoi"] = true,
		["wh3_dlc29_vmp_lair_primary_2_von_carstein"] = true
	},
	
	subtype_to_building = {
		["blood_dragon"] = "wh2_dlc11_vmp_cha_bloodline_blood_dragon_lord",
		["wh2_dlc11_vmp_cha_bloodline_lahmian_lord"]	= "wh3_dlc29_vmp_lair_primary_2_lahmian",
		["wh2_dlc11_vmp_cha_bloodline_necrarch_lord"]	= "wh3_dlc29_vmp_lair_primary_2_necrarch",
		["strigoi"]										= "wh3_dlc29_vmp_lair_primary_2_strigoi",
		["von_carstein"]								= "wh3_dlc29_vmp_lair_primary_2_von_carstein"
	},

	prerequisites =
	{
		min_turn = 2
	},

	persistent =
	{
		-- current_stage_index = [number]

		-- maps the stage data by stage index
		-- the data includes
		--{
		--	turn_started = [number],
		--}
		stages_persistent_data =
		{
			-- stage_persistent_data_table,
		},

		---------------------
		-- persistent data specific to this episode

		-- result from dilemma 1
		dilemma_choices =
		{
			-- [dilemma_key] = [choice_index]
		},
		completed_missions = {
			-- it could be a regular vector of strings, but I think this is easier to check and a bit more performant
			-- [missoion_key] = true,
		},
		final_battle_modifiers = 
		{
			mannfred_final_battle_support = 0,
			vlad_isabella_final_battle_support = 0
		},
	},
}

episode_neferata.stages = 
{
	{
		stage_key = "narrative_neferata_stage_1",
		payloads = {
			{
				payload_type = "incident",
				faction_key = episode_neferata.faction_key,
				incident_key = episode_neferata.incident_act_1,
			},
		},

		on_started = function(self)
			episode_neferata.episode_mission(self, episode_neferata.neferata_narrative_build_web_of_power)
			episode_neferata.episode_mission(self, episode_neferata.neferata_narrative_fairest_bloodline)
		end,

		on_mission_succeeded = function(self, mission_key)
			if mission_key == episode_neferata.neferata_narrative_build_web_of_power then
				episodes_manager.mark_mission_completed(episode_neferata, mission_key)
				episode_neferata.episode_mission(self, episode_neferata.neferata_narrative_web_of_power_1)
			end

			if mission_key == episode_neferata.neferata_narrative_web_of_power_1
				or mission_key == episode_neferata.neferata_narrative_build_web_of_power
				or mission_key == episode_neferata.neferata_narrative_fairest_bloodline
			then
				episodes_manager.mark_mission_completed(episode_neferata, mission_key)
				-- we need three missions completed to advance
				if episodes_manager.is_mission_completed(episode_neferata, episode_neferata.neferata_narrative_web_of_power_1) 
					and episodes_manager.is_mission_completed(episode_neferata, episode_neferata.neferata_narrative_build_web_of_power) 
					and episodes_manager.is_mission_completed(episode_neferata, episode_neferata.neferata_narrative_fairest_bloodline)
				then
					episodes_manager:advance_stage(episode_neferata)
				end
			end

		end
	},
	-- Act 2 Web of Power
	{
		stage_key = "narrative_neferata_stage_2_web_of_power",
		payloads = {
			{
				payload_type = "incident",
				faction_key = episode_neferata.faction_key,
				incident_key = episode_neferata.incident_act_2,
			},
		},

		on_started = function(self)
			episode_neferata.episode_mission(self, episode_neferata.neferata_narrative_web_of_power_2)
			episode_neferata.episode_mission(self, episode_neferata.neferata_narrative_united_in_service)
		end,

		on_mission_succeeded = function(self, mission_key)
			if mission_key == episode_neferata.neferata_narrative_web_of_power_2 then
				episodes_manager.mark_mission_completed(episode_neferata, mission_key)
				episode_neferata:set_up_invastion()
				episode_neferata:death_to_the_unworthy()
			end
			
			if mission_key == episode_neferata.neferata_narrative_united_in_service
				or mission_key == episode_neferata.neferata_narrative_death_to_the_unworthy
			then
				episodes_manager.mark_mission_completed(episode_neferata, mission_key)

				if episodes_manager.is_mission_completed(episode_neferata, episode_neferata.neferata_narrative_united_in_service)
					and episodes_manager.is_mission_completed(episode_neferata, episode_neferata.neferata_narrative_death_to_the_unworthy)
				then
					episodes_manager:advance_stage(episode_neferata)
				end
			end
		end,

	},

	{
		stage_key = "narrative_neferata_mission_3_web_of_power",
		payloads = {
			{
			payload_type = "incident",
			faction_key = episode_neferata.faction_key,
			incident_key = episode_neferata.incident_act_3,
			},
		},

		on_started = function(self)
			episode_neferata.episode_mission(self, episode_neferata.neferata_narrative_web_of_power_3)
			episode_neferata.episode_mission(self, episode_neferata.neferata_narrative_silver_sisterhood)
			episode_neferata.episode_mission(self, episode_neferata.confederation_mission_mannfred)
			episode_neferata.episode_mission(self, episode_neferata.confederation_mission_vlad_isabella)

			if cm:get_saved_value("neferata_silver_sisterhood_completed") then
				cm:callback(
					function()
						local neferata_faction_interface = cm:get_faction(episode_neferata.faction_key)

						if cm:mission_is_active_for_faction(
							neferata_faction_interface,
							episode_neferata.neferata_narrative_silver_sisterhood
						) then
							cm:complete_scripted_mission_objective(
								episode_neferata.faction_key,
								episode_neferata.neferata_narrative_silver_sisterhood,
								episode_neferata.neferata_narrative_silver_sisterhood,
								true
							)
						end
					end,
					0.1
				)
			end
		end,

		on_mission_succeeded = function(self, mission_key)
			if mission_key == episode_neferata.neferata_narrative_web_of_power_3
				or mission_key == episode_neferata.neferata_narrative_silver_sisterhood
			then
				episodes_manager.mark_mission_completed(episode_neferata, mission_key)

				if episodes_manager.is_mission_completed(
					episode_neferata,
					episode_neferata.neferata_narrative_web_of_power_3
				)
					and episodes_manager.is_mission_completed(
						episode_neferata,
						episode_neferata.neferata_narrative_silver_sisterhood
					)
				then
					episodes_manager:advance_stage(episode_neferata)
				end
			end
		end

	},

	{
	stage_key = "narrative_neferata_mission_3_dream_of_lahmia",
		payloads = {},

		on_started = function(self)
			episode_neferata:dream_of_lahmia()
		end,

		on_mission_succeeded = function(self, mission_key)
			if mission_key == episode_neferata.final_quest_battle then
				episodes_manager:advance_stage(episode_neferata)
			end
		end
	},

	-- episode win
	{
		stage_key = "narrative_neferata_win",
		payloads =
		{
		},
	},
}

-------------------
-- REQUIRED -------
-------------------

episode_neferata.is_available_this_game = function(self)
	local faction = cm:get_faction(self.faction_key)

	if (not faction) 
		or faction:is_null_interface() 
		or faction:is_human() == false 
		or cm:is_multiplayer()
	then
		return false
	end
	return true
end

episode_neferata.start_episode = function(self)
	episodes_manager:start_stage(self, 1)
	cm:set_script_state(episode_neferata.episode_active_shared_state, true)
end

episode_neferata.execute_stage_payloads = function(self, stage_index)
	local stage_table = episode_neferata.stages[stage_index]

	if not stage_table then
		return
	end

	for i = 1, #stage_table.payloads do
		local payload = stage_table.payloads[i]
		local params_table = {}

		payloads_executor.execute_payload(payload, params_table)
	end
end

-------------------
-- SELF REGISTER --
-------------------

cm:add_first_tick_callback(
	function()
		-- this check can't be called before add_first_tick_callback, as it needs the world ready and initialized
		if not episode_neferata:is_available_this_game() then
			return
		end

		if not cm:get_faction(episode_neferata.faction_key) then 
			return 
		end
		
		
		if cm:get_faction(episode_neferata.faction_key):is_human() then
			episodes_manager:add_available_episode(episode_neferata)
			
		end
	end	
)

episode_neferata.episode_mission = function(self, mission)	
	local mm = mission_manager:new(episode_neferata.faction_key, mission)				
	mm:add_new_objective("SCRIPTED")
	mm:add_condition("script_key "..mission)
	
	local add_description =  episode_neferata.mission_override_texts[mission]

	if add_description then
		for i = 1, #add_description do
			mm:add_condition("override_text mission_text_text_"..add_description[i])
		end
	end
	
	local payloads = episode_neferata.mission_payloads[mission]

	if payloads then
		for i = 1, #payloads do
			mm:add_payload(payloads[i])
		end
	end
	mm:set_should_whitelist(false);
	mm:set_mission_issuer("CLAN_ELDERS")
	mm:trigger()
end

function episode_neferata:death_to_the_unworthy()
	local mm = mission_manager:new(episode_neferata.faction_key, episode_neferata.neferata_narrative_death_to_the_unworthy)
	mm:add_new_objective("SCRIPTED")
	mm:add_condition("script_key "..episode_neferata.neferata_narrative_death_to_the_unworthy)
	mm:add_condition("override_text mission_text_text_"..episode_neferata.neferata_narrative_death_to_the_unworthy)
	mm:add_payload("effect_bundle{bundle_key wh3_dlc29_vmp_effect_bundle_neferata_narrative_diplomacy_mod_vampires_positive;turns 0;}");
	mm:add_payload("text_display dummy_wh3_dlc29_death_to_the_unworthy");
	mm:add_payload("faction_pooled_resource_transaction{resource wh3_dlc29_vmp_power;factor events;amount 1000;context absolute;}");
	mm:set_mission_issuer("CLAN_ELDERS")
	mm:set_should_cancel_before_issuing(false)
	if not cm:get_saved_value("death_to_the_unworthy_mission") then
		mm:trigger()
	end
end

function episode_neferata:dream_of_lahmia()
	local mm = mission_manager:new(episode_neferata.faction_key, episode_neferata.final_quest_battle)
	mm:add_new_objective("FIGHT_SET_PIECE_BATTLE")
	mm:add_condition("set_piece_battle wh3_dlc29_qb_vmp_dream_of_lahmia")
	mm:add_payload("text_display dummy_wh3_dlc29_mission_dream_of_lahmia")
	mm:trigger()
end

function episode_neferata:set_up_invastion()
	cm:force_declare_war(
		episode_neferata.faction_key,
		episode_neferata.vmp_invastion_faction_key,
		false,
		false
	)

	cm:force_diplomacy(
		"faction:" .. episode_neferata.faction_key,
		"faction:" .. episode_neferata.vmp_invastion_faction_key,
		"all",
		false,
		false,
		true
	)

	-- use the marker manager to spawn a series of invasion markers, with an event that fires when they expire
	local marker_base_key = "vmp_invasion"
	
	local countdown_markers = Interactive_Marker_Manager:create_countdown(
		marker_base_key,
		"ScriptEventVMPInvasionMarkerInteraction",
		"ScriptEventVMPInvasionMarkerExpired",
		{"invasion_marker_3_nef", "invasion_marker_2_nef", "invasion_marker_1_nef"},
		5
	)
	
	local countdown_marker_stage_1 = countdown_markers[1]
	local countdown_marker_stage_2 = countdown_markers[2]
	local countdown_marker_stage_3 = countdown_markers[3]
	
	
	countdown_marker_stage_1:add_spawn_event_feed_event(
		"event_feed_strings_text_wh3_dlc29_event_feed_string_scripted_event_invasion_title_neferata",
		"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_mustering_primary_detail", 
		"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_mustering_secondary_detail", 
		557,
		episode_neferata.faction_key
	)
	
	countdown_marker_stage_3:add_spawn_event_feed_event(
		"event_feed_strings_text_wh3_dlc29_event_feed_string_scripted_event_invasion_title_neferata",
		"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_imminent_primary_detail", 
		"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_imminent_secondary_detail", 
		557,
		episode_neferata.faction_key
	)
	
	countdown_marker_stage_3:add_despawn_event_feed_event(
		"event_feed_strings_text_wh3_dlc29_event_feed_string_scripted_event_invasion_title_neferata", 
		"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_spawned_primary_detail", 
		"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_spawned_secondary_detail", 
		557,
		episode_neferata.faction_key
	)
	
	local invasion_coord_list = episode_neferata.invasion_spawn_coords
	
	for i = 1, #invasion_coord_list do
		local x = invasion_coord_list[i][1]
		local y = invasion_coord_list[i][2]
		countdown_marker_stage_1:spawn_at_location(x, y, false)
	end
end

function episode_neferata:trigger_invasion(x, y)
	local invasion = "vmp_rebels"
	local invasion_key = invasion..x..y
	local invasion_faction = episode_neferata.vmp_invastion_faction_key
	local unit_list = WH_Random_Army_Generator:generate_random_army(episode_neferata.vmp_invastion_faction_key, "wh_main_sc_vmp_vampire_counts", 19, 1, true, false)
	local invasion_object = invasion_manager:new_invasion(invasion_key, invasion_faction,unit_list, {x, y})
	cm:apply_effect_bundle(episode_neferata.faction_trait_effect_bundle, episode_neferata.vmp_invastion_faction_key, 0)
	invasion_object:apply_effect("wh2_dlc16_bundle_military_upkeep_free_force_immune_to_regionless_attrition", -1)
	invasion_object:set_target("REGION", "wh3_main_combi_region_silver_pinnacle", episode_neferata.faction_key)
	invasion_object:add_aggro_radius(25, {episode_neferata.faction_key}, 1)
	invasion_object:start_invasion(true, true, false, false)
end

function episode_neferata:table_size(t)
	local count = 0
	for _ in pairs(t) do
		count = count + 1
	end
	return count
end

function episode_neferata:update_lair_progress()
	local neferata_faction_interface = cm:get_faction(episode_neferata.faction_key)
	local completed_buildings = cm:get_saved_value("vampire_lairs_completed_buildings") or {}

	local count = episode_neferata:table_size(completed_buildings)

	if count >= episode_neferata.bloodlines_mission_constructed_lairs then
		if cm:mission_is_active_for_faction(neferata_faction_interface, episode_neferata.neferata_narrative_united_in_service) then	
			cm:complete_scripted_mission_objective(episode_neferata.faction_key,episode_neferata.neferata_narrative_united_in_service,episode_neferata.neferata_narrative_united_in_service,true)
		end
	end
end

episode_neferata.can_start = function(self)
	return true
end

function episode_neferata:set_final_battle_modifiers_strings()
	for modifier_string, modifier_value in dpairs(episode_neferata.persistent.final_battle_modifiers) do
		core:svr_save_string(modifier_string, tostring(modifier_value))
	end
end

function episode_neferata:web_of_power_mission_is_active(faction_interface, mission_key)
	return faction_interface:name() == episode_neferata.faction_key
		and faction_interface:is_human()
		and cm:mission_is_active_for_faction(faction_interface, mission_key)
end

------------------
--- Listeners ----
------------------
	core:add_listener(
		"Neferata_First_Episode",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == episode_neferata.faction_key and context:faction():is_human()
		end,
		function(context)
			local faction = context:faction()
			local current_turn = cm:turn_number()

			if current_turn == 1 then
				cm:lock_one_technology_node(episode_neferata.faction_key, "wh3_dlc29_tech_nef_imentet_1");
				cm:lock_one_technology_node(episode_neferata.faction_key, "wh3_dlc29_tech_nef_covens_1");
			elseif current_turn == 2 then
				core:add_listener(
					"UniqueAgentSpawnedNeferata",
					"UniqueAgentSpawned",
					function(context)
						return context:unique_agent_details():character():get_forename() == "names_name_585176462";
					end,
					function(context)
						local agent = context:unique_agent_details():character();
						cm:force_add_trait(cm:char_lookup_str(agent:cqi()), "wh3_trait_dlc29_imentet_1");
						cm:replenish_action_points(cm:char_lookup_str(agent));
					end,
					false
				);

				cm:spawn_unique_agent(faction:command_queue_index(), "wh3_dlc29_vmp_handmaiden_imentet", true);
				local character = cm:get_most_recently_created_character_of_type(episode_neferata.faction_key, "engineer", "wh3_dlc29_vmp_handmaiden_imentet");
				cm:unlock_technology(episode_neferata.faction_key, "wh3_dlc29_tech_nef_imentet_1");
				cm:unlock_technology(episode_neferata.faction_key, "wh3_dlc29_tech_nef_covens_1");
				cm:instantly_research_technology(episode_neferata.faction_key, "wh3_dlc29_tech_nef_imentet_1", false);	
			end
		end,
		true
	)

	core:add_listener(
		"VampireCovensMission",
		"ForeignSlotManagerCreatedEvent",
		function(context)
			local new_manager = context:new_slot_manager()
			local slot_list = new_manager:slots();
			if slot_list:num_items() == 0 then
				return false
			end
			local slot = slot_list:item_at(0)
			local template_key = slot:template_key()
			return context:requesting_faction():name() == episode_neferata.faction_key and context:requesting_faction():is_human() and template_key:starts_with(episode_neferata.vampire_coven) 
		end,
		function(context)
			local neferata_faction_interface = cm:get_faction(episode_neferata.faction_key)
			if cm:mission_is_active_for_faction(neferata_faction_interface, episode_neferata.neferata_narrative_build_web_of_power) then
				cm:complete_scripted_mission_objective(episode_neferata.faction_key, episode_neferata.neferata_narrative_build_web_of_power, episode_neferata.neferata_narrative_build_web_of_power, true);
			end
		end,
		true
	)
	
	core:add_listener(
		"Second_Stage_Mission",
		"MissionSucceeded",
		function(context)
			return context:mission():mission_record_key() == episode_neferata.neferata_narrative_death_to_the_unworthy
		end,
		function(context)
			cm:remove_effect_bundle("wh3_dlc29_vmp_effect_bundle_neferata_narrative_diplomacy_mod_vampires_negative", episode_neferata.faction_key)
		end,
		true
	)

	core:add_listener(
		"ScriptEventVMPInvasionMarkerExpired",
		"ScriptEventVMPInvasionMarkerExpired",
		true,
		function(context)
			local marker_ref = context.stored_table.marker_ref
			local instance_ref = context.stored_table.instance_ref
			local x, y = Interactive_Marker_Manager:get_coords_from_instance_ref(instance_ref)
			episode_neferata:trigger_invasion(x, y)
			cm:set_saved_value("death_to_the_unworthy_mission", true)			
		end,
		true
	)

	core:add_listener(
		"Web_of_Power_Mission_1_Completion",
		"PooledResourceChanged",
		function(context)
			return context:resource():key() == episode_neferata.pool_res_manipulation
				and context:amount() < 0
				and context:factor():key() == "neferata_web_of_power"
				and episode_neferata:web_of_power_mission_is_active(context:faction(), episode_neferata.neferata_narrative_web_of_power_1)
		end,
		function(context)
			local neferata_faction_interface = cm:get_faction(episode_neferata.faction_key)
			local first_tier_manipulation_spent = "first_tier_current_manipulation_resource_spent_"
			local amount = context:amount()
			local amount_spent = -amount
			local faction_manipulation_spent = first_tier_manipulation_spent .. context:faction():name()
			local total_spent = cm:get_saved_value(faction_manipulation_spent) or 0
			total_spent = total_spent + amount_spent
			cm:set_saved_value(faction_manipulation_spent, total_spent)
			if total_spent >= episode_neferata.first_mission_pool_res_amount then
				if cm:mission_is_active_for_faction(neferata_faction_interface, episode_neferata.neferata_narrative_web_of_power_1) then	
					cm:complete_scripted_mission_objective(episode_neferata.faction_key, episode_neferata.neferata_narrative_web_of_power_1, episode_neferata.neferata_narrative_web_of_power_1, true);
					core:remove_listener("Web_of_Power_Mission_1_Completion")
				end
			end	
		end,
		true
	)

	core:add_listener(
		"Web_of_Power_Mission_2_Completion",
		"PooledResourceChanged",
		function(context)
			return context:resource():key() == episode_neferata.pool_res_manipulation
				and context:amount() < 0
				and context:factor():key() == "neferata_web_of_power"
				and episode_neferata:web_of_power_mission_is_active(context:faction(), episode_neferata.neferata_narrative_web_of_power_2)
		end,
		function(context)
			local neferata_faction_interface = cm:get_faction(episode_neferata.faction_key)
			local second_tier_manipulation_spent = "second_tier_current_manipulation_resource_spent_"
			local amount = context:amount()
			local amount_spent = -amount
			local faction_manipulation_spent = second_tier_manipulation_spent .. context:faction():name()
			local total_spent = cm:get_saved_value(faction_manipulation_spent) or 0
			total_spent = total_spent + amount_spent
			cm:set_saved_value(faction_manipulation_spent, total_spent)
			if total_spent >= episode_neferata.second_mission_pool_res_amount then	
				if cm:mission_is_active_for_faction(neferata_faction_interface, episode_neferata.neferata_narrative_web_of_power_2) then
					cm:complete_scripted_mission_objective(episode_neferata.faction_key, episode_neferata.neferata_narrative_web_of_power_2, episode_neferata.neferata_narrative_web_of_power_2, true);					
					core:remove_listener("Web_of_Power_Mission_2_Completion")
				end
			end	
		end,
		true
	)

	core:add_listener(
		"Neferata_Silver_Sisterhood_Narrative_Tracking",
		"MissionSucceeded",
		function(context)
			return context:faction():name() == episode_neferata.faction_key
				and context:mission():mission_record_key() == episode_neferata.silver_sisterhood_quest_battle
		end,
		function(context)
			cm:set_saved_value("neferata_silver_sisterhood_completed", true)

			local neferata_faction_interface = context:faction()

			if cm:mission_is_active_for_faction(
				neferata_faction_interface,
				episode_neferata.neferata_narrative_silver_sisterhood
			) then
				cm:complete_scripted_mission_objective(
					episode_neferata.faction_key,
					episode_neferata.neferata_narrative_silver_sisterhood,
					episode_neferata.neferata_narrative_silver_sisterhood,
					true
				)
			end
		end,
		false
	)

	core:add_listener(
		"Web_of_Power_Mission_3_Completion",
		"PooledResourceChanged",
		function(context)
			return context:resource():key() == episode_neferata.pool_res_manipulation
				and context:amount() < 0
				and context:factor():key() == "neferata_web_of_power"
				and episode_neferata:web_of_power_mission_is_active(context:faction(), episode_neferata.neferata_narrative_web_of_power_3)
		end,
		function(context)
			local neferata_faction_interface = cm:get_faction(episode_neferata.faction_key)
			local third_tier_manipulation_spent = "third_tier_current_manipulation_resource_spent_"
			local amount = context:amount()
			local amount_spent = -amount
			local faction_manipulation_spent = third_tier_manipulation_spent .. context:faction():name()
			local total_spent = cm:get_saved_value(faction_manipulation_spent) or 0
			total_spent = total_spent + amount_spent
			cm:set_saved_value(faction_manipulation_spent, total_spent)
			if total_spent >= episode_neferata.third_mission_pool_res_amount then	
				if cm:mission_is_active_for_faction(neferata_faction_interface, episode_neferata.neferata_narrative_web_of_power_3) then
					cm:complete_scripted_mission_objective(episode_neferata.faction_key, episode_neferata.neferata_narrative_web_of_power_3, episode_neferata.neferata_narrative_web_of_power_3, true);
					core:remove_listener("Web_of_Power_Mission_3_Completion")
				end
			end
		end,
		true
	)

	core:add_listener(
		"Conquest_of_Lamia_Succeeded",
		"MissionSucceeded",
		function(context)
			local mission = context:mission():mission_record_key();
			
			return mission == episode_neferata.final_quest_battle
		end,
		function(context)
			local faction = context:faction();
			local faction_name = faction:name();
			cm:transfer_region_to_faction(episode_neferata.lahmia_region_key, episode_neferata.faction_key)
		end,
		true
	)

	core:add_listener(
		"Lahmia_Character_Created",
		"CharacterCreated",
		function(context)
			local character = context:character()
			return not context:has_respawned() and cm:char_is_general(character) and not character:is_wounded() and character:faction():is_human() and character:character_subtype("wh2_dlc11_vmp_bloodline_lahmian")
		end,
		function(context)
			local character = context:character()
			local neferata_faction_interface = character:faction()
			if cm:mission_is_active_for_faction(neferata_faction_interface, episode_neferata.neferata_narrative_fairest_bloodline) then
				cm:complete_scripted_mission_objective(episode_neferata.faction_key, episode_neferata.neferata_narrative_fairest_bloodline, episode_neferata.neferata_narrative_fairest_bloodline, true);
				core:remove_listener("Lahmia_Character_Created")
			end
		end,
		true
	)

	core:add_listener(
		"ScriptEventVMPInvasionMarkerInteraction",
		"ScriptEventVMPInvasionMarkerInteraction",
		true,
		function(context)
			cm:set_saved_value("death_to_the_unworthy_mission", true)

			local marker_ref = context.stored_table.marker_ref
			local marker_stage = tonumber(
				string.match(marker_ref, "invasion_marker_(%d)_nef")
			)

			local army_size = 19
			local army_power = 7

			if marker_stage == 3 then
				army_size = 10
				army_power = 3
			elseif marker_stage == 2 then
				army_size = 14
				army_power = 5
			end

			local forced_battle = Forced_Battle_Manager:trigger_forced_battle_with_generated_army(
				context:character():military_force():command_queue_index(),
				episode_neferata.vmp_invastion_faction_key,
				"wh_main_sc_vmp_vampire_counts",
				army_size,
				army_power,
				false,
				false,
				true,
				nil,
				nil,
				nil,
				army_power,
				"wh2_dlc16_bundle_scripted_wood_elf_encounter"
			)

			if forced_battle and forced_battle.target then
				local target_force = cm:get_military_force_by_cqi(forced_battle.target.cqi)

				if target_force and not target_force:is_null_interface() then
					cm:set_force_has_retreated_this_turn(target_force)
				end
			end
		end,
		true
	)

	core:add_listener(
		"Rebel_Vampire_MilitaryForceDestroyed",
		"MilitaryForceDestroyed",
		function(context)
			return context:military_force():faction():name() == episode_neferata.vmp_invastion_faction_key
		end,
		function(context)
			local neferata_faction_interface = cm:get_faction(episode_neferata.faction_key)
			local defeated_vampire_invasion_armies = cm:get_saved_value("defeated_vampire_invasion_armies_count") or 0
			defeated_vampire_invasion_armies = defeated_vampire_invasion_armies +1
			cm:set_saved_value("defeated_vampire_invasion_armies_count", defeated_vampire_invasion_armies)
			if defeated_vampire_invasion_armies == 3 then
				if cm:mission_is_active_for_faction(neferata_faction_interface, episode_neferata.neferata_narrative_death_to_the_unworthy) then
					cm:complete_scripted_mission_objective(episode_neferata.faction_key, episode_neferata.neferata_narrative_death_to_the_unworthy, episode_neferata.neferata_narrative_death_to_the_unworthy, true);
				end	
			end	
		end,
		true
	)

	core:add_listener(
		"Constructed_Vampire_Lairs",
		"ForeignSlotBuildingCompleteEvent",
		function(context)
			return context:slot_manager():faction():name() == episode_neferata.faction_key
		end,
		function(context)
			local completed_buildings = cm:get_saved_value("vampire_lairs_completed_buildings") or {}

			local building_key = context:building()

			if episode_neferata.vampire_lair_buildings[building_key] then
				if not completed_buildings[building_key] then
					completed_buildings[building_key] = true
					cm:set_saved_value("vampire_lairs_completed_buildings", completed_buildings)
					episode_neferata:update_lair_progress()
				end
			end
		end,
		true
	)

	core:add_listener(
		"Neferata_Confederation",
		"FactionJoinsConfederation",
		function(context)
			return context:confederation():name() == episode_neferata.faction_key
		end,
		function(context)
			local completed_buildings = cm:get_saved_value("vampire_lairs_completed_buildings") or {}
			local confederation = context:confederation()
			local character_list = confederation:character_list()

			for i = 0, character_list:num_items() - 1 do
				local character = character_list:item_at(i)
				local subtype_key = character:character_subtype_key()
				local building_key = nil
		
				for pattern, mapped_building in pairs(episode_neferata.subtype_to_building) do
					if string.find(subtype_key, pattern) then
						building_key = mapped_building
						break
					end
				end

				if building_key and not completed_buildings[building_key] then
					completed_buildings[building_key] = true
				end
			end

			cm:set_saved_value("vampire_lairs_completed_buildings", completed_buildings)
			episode_neferata:update_lair_progress()
		end,
		true
	)
	
	core:add_listener(
		"Mannfred_Confederated",
		"FactionJoinsConfederation",
		function(context)
			local faction_name = context:faction():name();
			local confederting_faction_interface = context:confederation();
			return faction_name == episode_neferata.mannfred_faction and confederting_faction_interface:name() == episode_neferata.faction_key and confederting_faction_interface:is_human()
		end,
		function(context)
			local neferata_faction_interface = context:confederation()
			if cm:mission_is_active_for_faction(neferata_faction_interface, episode_neferata.confederation_mission_mannfred) then
				cm:complete_scripted_mission_objective(episode_neferata.faction_key, episode_neferata.confederation_mission_mannfred, episode_neferata.confederation_mission_mannfred, true);
				episode_neferata.persistent.final_battle_modifiers.mannfred_final_battle_support = 1
			else
				episode_neferata.persistent.final_battle_modifiers.mannfred_final_battle_support = 0
			end
		end,
		true
	)
	
	core:add_listener(
		"Vlad_Isabella_Confederated",
		"FactionJoinsConfederation",
		function(context)
			local faction_name = context:faction():name();
			local confederting_faction_interface = context:confederation();
			return faction_name == episode_neferata.vlad_isabella_faction and confederting_faction_interface:name() == episode_neferata.faction_key and confederting_faction_interface:is_human()
		end,
		function(context)
			local neferata_faction_interface = context:confederation()
			if cm:mission_is_active_for_faction(neferata_faction_interface, episode_neferata.confederation_mission_vlad_isabella) then
				cm:complete_scripted_mission_objective(episode_neferata.faction_key, episode_neferata.confederation_mission_vlad_isabella, episode_neferata.confederation_mission_vlad_isabella, true);
				episode_neferata.persistent.final_battle_modifiers.vlad_isabella_final_battle_support = 1
			else
				episode_neferata.persistent.final_battle_modifiers.vlad_isabella_final_battle_support = 0
			end
		end,
		true
	)

	core:add_listener(
		"Neferata_Final_Battle_Modifiers",
		"PendingBattle",
		function()
			local pb = cm:model():pending_battle();
			return pb:set_piece_battle_key() == episode_neferata.dream_of_lamia_quest_battle_key
		end,
		function()
			episode_neferata:set_final_battle_modifiers_strings()
		end,
		true
	)

	core:add_listener(
		"Neferata_Confederation_Mission_Issued_Check_Completetion", 
		"MissionIssued",
		function(context)
			return context:faction():name() == episode_neferata.faction_key
		end,
		function(context)
			local mission_key = context:mission():mission_record_key()
			local neferata_faction_interface = context:faction()
			local function confederated_or_pulled_via_bloodlines(target_faction_interface, target_subtype)
				if not target_faction_interface or target_faction_interface:is_null_interface() then
					return false
				end
				if target_faction_interface:was_confederated_by_faction(neferata_faction_interface) then
					return true
				end
				local char_list = neferata_faction_interface:character_list()
				for i = 0, char_list:num_items() - 1 do
					local char = char_list:item_at(i)
					if char:character_subtype_key() == target_subtype then
						return true
					end
				end
				return false
			end
			if mission_key == episode_neferata.confederation_mission_mannfred then
				local mannfred_faction_interface = cm:get_faction(episode_neferata.mannfred_faction)
				if confederated_or_pulled_via_bloodlines(mannfred_faction_interface, episode_neferata.mannfred_subtype) then
					cm:set_active_mission_status_for_faction(neferata_faction_interface, episode_neferata.confederation_mission_mannfred, "SUCCEEDED")
					episode_neferata.persistent.final_battle_modifiers.mannfred_final_battle_support = 1
				end
			end
			if mission_key == episode_neferata.confederation_mission_vlad_isabella then
				local vlad_faction_interface = cm:get_faction(episode_neferata.vlad_isabella_faction)
				if confederated_or_pulled_via_bloodlines(vlad_faction_interface, episode_neferata.vlad_subtype) then
					cm:set_active_mission_status_for_faction(neferata_faction_interface, episode_neferata.confederation_mission_vlad_isabella, "SUCCEEDED")
					episode_neferata.persistent.final_battle_modifiers.vlad_isabella_final_battle_support = 1
				end
			end
		end,
		true
	)

	core:add_listener(
		"Vampire_ritual_performed_update_mission_status_and_final_battle_modifiers",
		"RitualCompletedEvent",
		function(context)
			local faction_name = context:performing_faction():name()
			return faction_name == episode_neferata.faction_key and context:ritual():ritual_category() == "VAMPIRE_RITUAL_LORDS"
		end,
		function(context)
			local ritual_key = context:ritual():ritual_key()
			local neferata_faction_interface = context:performing_faction()
			local ritual_target_faction = vampire_bloodlines.confederation_rituals[ritual_key]
			if ritual_target_faction then
				if cm:mission_is_active_for_faction(neferata_faction_interface, episode_neferata.confederation_mission_vlad_isabella) and ritual_target_faction == episode_neferata.vlad_isabella_faction then
					cm:set_active_mission_status_for_faction(neferata_faction_interface, episode_neferata.confederation_mission_vlad_isabella, "SUCCEEDED")
					episode_neferata.persistent.final_battle_modifiers.vlad_isabella_final_battle_support = 1
				end
				if cm:mission_is_active_for_faction(neferata_faction_interface, episode_neferata.confederation_mission_mannfred) and ritual_target_faction == episode_neferata.mannfred_faction then
					cm:set_active_mission_status_for_faction(neferata_faction_interface, episode_neferata.confederation_mission_mannfred, "SUCCEEDED")
					episode_neferata.persistent.final_battle_modifiers.mannfred_final_battle_support = 1
				end
			end
		end,
		true
	)