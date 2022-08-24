thorek = {}
thorek.artifact_parts = {
	--- artifact pooled resource key = region key, bundle key
	dwf_thorek_artifact_part_1a = {region = "wh3_main_combi_region_the_golden_tower", bundle = "wh2_dlc17_effect_bundle_thorek_artifact_part_1a"},
	dwf_thorek_artifact_part_1b = {region = "wh3_main_combi_region_karag_orrud", bundle = "wh2_dlc17_effect_bundle_thorek_artifact_part_1b"},
	dwf_thorek_artifact_part_2a = {region = "wh3_main_combi_region_lahmia", bundle = "wh2_dlc17_effect_bundle_thorek_artifact_part_2a"},
	dwf_thorek_artifact_part_2b = {region = "wh3_main_combi_region_mount_gunbad", bundle = "wh2_dlc17_effect_bundle_thorek_artifact_part_2b"},
	dwf_thorek_artifact_part_3a = {region = "wh3_main_combi_region_misty_mountain", bundle = "wh2_dlc17_effect_bundle_thorek_artifact_part_3a"},
	dwf_thorek_artifact_part_3b = {region = "wh3_main_combi_region_karak_azgal", bundle = "wh2_dlc17_effect_bundle_thorek_artifact_part_3b"},
	dwf_thorek_artifact_part_4a = {region = "wh3_main_combi_region_black_crag", bundle = "wh2_dlc17_effect_bundle_thorek_artifact_part_4a"},
	dwf_thorek_artifact_part_4b = {region = "wh3_main_combi_region_mount_silverspear", bundle = "wh2_dlc17_effect_bundle_thorek_artifact_part_4b"},
	dwf_thorek_artifact_part_5a = {region = "wh3_main_combi_region_silver_pinnacle", bundle = "wh2_dlc17_effect_bundle_thorek_artifact_part_5a"},
	dwf_thorek_artifact_part_5b = {region = "wh3_main_combi_region_karak_azgaraz", bundle = "wh2_dlc17_effect_bundle_thorek_artifact_part_5b"},
	dwf_thorek_artifact_part_6a = {region = "wh3_main_combi_region_vulture_mountain", bundle = "wh2_dlc17_effect_bundle_thorek_artifact_part_6a"},
	dwf_thorek_artifact_part_6b = {region = "wh3_main_combi_region_galbaraz", bundle = "wh2_dlc17_effect_bundle_thorek_artifact_part_6b"},
	dwf_thorek_artifact_part_7a = {region = "wh3_main_combi_region_karag_dromar", bundle = "wh2_dlc17_effect_bundle_thorek_artifact_part_7a"},
	dwf_thorek_artifact_part_7b = {region = "wh3_main_combi_region_valayas_sorrow", bundle = "wh2_dlc17_effect_bundle_thorek_artifact_part_7b"},
	dwf_thorek_artifact_part_8a = {region = "wh3_main_combi_region_kraka_drak", bundle = "wh2_dlc17_effect_bundle_thorek_artifact_part_8a"},
	dwf_thorek_artifact_part_8b = {region = "wh3_main_combi_region_karak_ungor", bundle = "wh2_dlc17_effect_bundle_thorek_artifact_part_8b"}
}
thorek.already_looted = {}
thorek.artifact_piece_vfx_key = "scripted_effect18"
thorek.thorek_faction_key = "wh2_dlc17_dwf_thorek_ironbrow"
thorek.artifact_base_string = "dwf_thorek_artifact_part_*" --- db keys for thorek's artifact part pooled resources need to follow this format
thorek.artifact_resource_factor = "missions"
thorek.rituals_completed = 0
thorek.ritual_prefix = "wh2_dlc17_dwf_ritual_thorek_artifact_" -- any rituals beginning with this prefix will be considered a thorek artifact ritual.
thorek.ghost_thane_ritual = thorek.ritual_prefix .. "2"

-- Various scripted objective configurations relating to 'you need to get x artefacts to tick this box' missions, which are used in a few different places.
thorek.scripted_objectives = {
	{mission_key = "wh_main_short_victory", objective_key = "artefacts_crafted_victory_objective_me_0", artefacts_needed = 5},
	{mission_key = "wh_main_long_victory", objective_key = "artefacts_crafted_victory_objective_me_1", artefacts_needed = 8},
	{mission_key = "wh_main_victory_type_mp_coop", objective_key = "artefacts_crafted_victory_objective_me_2", artefacts_needed = 8}
}

function thorek:initialise()
	local thorek_interface = cm:get_faction(self.thorek_faction_key)
	
	if not thorek_interface or not thorek_interface:is_human() then
		return
	end
	
	out("###Setting up Thorek Listeners###")
	
	if cm:is_new_game() then
		for artifact_key, artifact_part_info in pairs(self.artifact_parts) do
			local region_key = artifact_part_info.region
			
			cm:add_garrison_residence_vfx(cm:get_region(region_key):garrison_residence():command_queue_index(), self.artifact_piece_vfx_key, true)
			-- also applys effect bundle to display artefact part icon on region
			cm:apply_effect_bundle_to_region(artifact_part_info.bundle, region_key, 0)
		end
	end
	
	core:add_listener(
		"CharacterPerformsSettlementOccupationDecisionThorek",
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			return context:character():faction():name() == self.thorek_faction_key and context:occupation_decision() ~= "596"
		end,
		function(context)
			local artifact_part_key = self:get_artifact_part_from_region(context:garrison_residence():region():name())
			
			if artifact_part_key then
				self:award_artifact_part(artifact_part_key, 1)
				
				cm:remove_garrison_residence_vfx(context:garrison_residence():command_queue_index(), self.artifact_piece_vfx_key)
			end
		end,
		true
	)
	
	core:add_listener(
		"ThorekArtifactPieceLClickUp",
		"ComponentLClickUp",
		function(context)
			return string.match(context.string, self.artifact_base_string)
		end,
		function(context)
			local crafting_panel_close = find_uicomponent("mortuary_cult", "button_ok")
			
			if crafting_panel_close then
				crafting_panel_close:SimulateLClick()
			else
				script_error("thorek:setup_resource_click_listener() is trying to close the crafting panel when it's not open, how has this happened?")
			end
			
			local region_interface = cm:get_region(self.artifact_parts[context.string].region)
			
			if region_interface then
				cm:scroll_camera_from_current(true, 3, {region_interface:settlement():display_position_x(), region_interface:settlement():display_position_y(), 10.5, 0.0, 6.8})
			end
			
			if not self.already_looted[context.string] then
				cm:trigger_campaign_vo("Play_wh2_dlc17_dwf_thorek_ironbrow_vault_unfound", "", 0)
			end
		end,
		true
	)
	
	core:add_listener(
		"Thorek_PositiveDiplomaticEvent",
		"PositiveDiplomaticEvent",
		function(context)
			return (context:recipient():name() == self.thorek_faction_key or context:proposer():name() == self.thorek_faction_key) and (context:is_military_alliance() or context:is_vassalage())
		end,
		function(context)
			local other_faction = false
			
			if context:proposer():name() == self.thorek_faction_key then
				other_faction = context:recipient():name()
			else
				other_faction = context:proposer():name()	
			end
			
			-- Nakai specific fix, alliance with Nakai also does a check for their vassal
			local is_nakai = other_faction == "wh2_dlc13_lzd_spirits_of_the_jungle"
			
			for k, v in pairs(self.artifact_parts) do
				if cm:is_region_owned_by_faction(v.region, other_faction) or (is_nakai and cm:is_region_owned_by_faction(v.region, "wh2_dlc13_lzd_defenders_of_the_great_plan")) then
					self:award_artifact_part(k, 1)
					cm:remove_garrison_residence_vfx(cm:get_region(v.region):garrison_residence():command_queue_index(), self.artifact_piece_vfx_key)
				end	
			end
		end,
		true
	)
	
	core:add_listener(
		"Thorek_RegionFactionChangeEvent",
		"RegionFactionChangeEvent",
		true,
		function(context)
			local region = context:region()
			local region_key = region:name()
			local artifact_part_key = self:get_artifact_part_from_region(region_key)
			
			if artifact_part_key then
				local owner = region:owning_faction()
				if owner:name() == self.thorek_faction_key or owner:is_ally_vassal_or_client_state_of(cm:get_faction(self.thorek_faction_key)) then
					self:award_artifact_part(artifact_part_key, 1)
					
					cm:remove_garrison_residence_vfx(region:garrison_residence():command_queue_index(), self.artifact_piece_vfx_key)
				end
				
				if not self.already_looted[artifact_part_key] then
					cm:apply_effect_bundle_to_region(self.artifact_parts[artifact_part_key].bundle, region_key, 0)
				end
			end
		end,
		true
	)
	
	core:add_listener(
		"thorek_crafting_ritual",
		"RitualCompletedEvent",
		function(context)
			local ritual = context:ritual()
			return ritual:ritual_category() == "CRAFTING_RITUAL" and ritual:ritual_key():starts_with(thorek.ritual_prefix)
		end,
		function(context)
			local faction = context:performing_faction()
			
			thorek.rituals_completed = thorek.rituals_completed + 1
			
			for s = 1, #thorek.scripted_objectives do
				scripted_objective = thorek.scripted_objectives[s]
				if thorek.rituals_completed == scripted_objective.artefacts_needed then
					cm:complete_scripted_mission_objective(faction:name(), scripted_objective.mission_key, scripted_objective.objective_key, true)
				end
			end
			
			if context:ritual():ritual_key() == thorek.ghost_thane_ritual then
				cm:spawn_unique_agent(faction:command_queue_index(), "wh2_dlc17_dwf_thane_ghost_artifact", true)
			end
			
			if thorek.rituals_completed == 8 then
				core:trigger_event("ScriptEventArtefactsForgedAll")
			elseif thorek.rituals_completed >= 3 then
				core:trigger_event("ScriptEventArtefactsForgedThree")
			else
				core:trigger_event("ScriptEventArtefactsForgedOne")
			end
		end,
		true
	)
end

function thorek:get_artifact_part_from_region(region_key)
	for artifact_part_key, artifact_part_info in pairs(self.artifact_parts) do
		if artifact_part_info.region == region_key then
			return artifact_part_key
		end
	end
end

function thorek:award_artifact_part(artifact_part_key, amount)
	if not self.already_looted[artifact_part_key] then
		cm:faction_add_pooled_resource(self.thorek_faction_key, artifact_part_key, self.artifact_resource_factor, amount)
		self.already_looted[artifact_part_key] = true
		
		local artifact = self.artifact_parts[artifact_part_key]
		cm:remove_effect_bundle_from_region(artifact.bundle, artifact.region)
		
		cm:show_message_event(
			self.thorek_faction_key,
			"event_feed_strings_text_wh2_dlc17_event_feed_string_thorek_artifact_found_title",
			"pooled_resources_display_name_" .. artifact_part_key,
			"event_feed_strings_text_wh2_dlc17_event_feed_string_thorek_artifact_found_secondary_detail",
			true,
			1701
		)
		
		--trigger event for artefact part being awarded
		core:trigger_event("ScriptEventForgeArtefactPartReceived")
		
		local artifact_part_pair_key = string.sub(artifact_part_key, 1, string.len(artifact_part_key) - 1)
		if self.already_looted[artifact_part_pair_key .. "a"] and self.already_looted[artifact_part_pair_key .. "b"] then
			core:trigger_event("ScriptEventForgeArtefactPair")
		end
	end
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("artifact_objectives", thorek.rituals_completed, context)
		cm:save_named_value("already_looted", thorek.already_looted, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			thorek.rituals_completed = cm:load_named_value("artifact_objectives", thorek.rituals_completed, context)
			thorek.already_looted = cm:load_named_value("already_looted", thorek.already_looted, context)
		end
	end
)