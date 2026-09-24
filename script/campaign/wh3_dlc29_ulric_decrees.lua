ulric_decrees_config = {
	faction_key = "wh_main_emp_middenland",
	sacred_flame = "wh3_dlc29_emp_middenland_sacred_flame",
	boris_subtype_key = "wh_dlc03_emp_boris_todbringer",

	common_ancillary_list = {
		"wh_main_anc_enchanted_item_the_terrifying_mask_of_eee",
		"wh2_dlc09_anc_enchanted_item_icon_of_rulership",
		"wh_main_anc_armour_spellshield",
		"wh_main_anc_armour_glittering_scales",
		"wh_main_anc_armour_charmed_shield",
		"wh_main_anc_armour_enchanted_shield",
		"wh_main_anc_weapon_sword_of_swift_slaying",
		"wh_main_anc_weapon_sword_of_battle",
		"wh_main_anc_weapon_berserker_sword",
		"wh_main_anc_weapon_biting_blade",
		"wh_main_anc_weapon_relic_sword",
		"wh_main_anc_talisman_luckstone",
		"wh_main_anc_talisman_dawnstone",
		"wh_main_anc_talisman_opal_amulet",
		"wh_main_anc_talisman_pidgeon_plucker_pendant",
		"wh3_dlc29_anc_talisman_standard_of_the_white_wolf",
	},

	uncommon_ancillary_list = {
		"wh2_dlc09_anc_enchanted_item_shroud_of_sokth",
		"wh2_dlc09_anc_enchanted_item_death_mask_of_kharnut",
		"wh_main_anc_armour_armour_of_fortune",
		"wh_main_anc_armour_armour_of_silvered_steel",
		"wh_main_anc_armour_helm_of_discord",
		"wh_main_anc_armour_gamblers_armour",
		"wh_main_anc_weapon_giant_blade",
		"wh_main_anc_weapon_sword_of_anti-heroes",
		"wh_main_anc_weapon_sword_of_strife",
		"wh_main_anc_weapon_ogre_blade",
		"wh_main_anc_weapon_fencers_blades",
		"wh_dlc03_anc_weapon_the_brass_cleaver",
		"wh_main_anc_talisman_obsidian_amulet",
		"wh_main_anc_talisman_obsidian_lodestone",
		"wh2_dlc09_anc_talisman_obsidian_pendant",
		"wh3_dlc29_anc_weapon_storm_hammer",
	},

	rare_ancillary_list = {
		"wh_main_anc_enchanted_item_the_other_tricksters_shard",
		"wh2_dlc09_anc_enchanted_item_ouroboros",
		"wh_main_anc_armour_tricksters_helm",
		"wh_main_anc_armour_armour_of_destiny",
		"wh2_dlc17_anc_armour_mutated_ghorgon_hide",
		"wh2_dlc17_anc_armour_cloak_of_unreality",
		"wh_main_anc_armour_the_armour_of_meteoric_iron",
		"wh_main_anc_weapon_obsidian_blade",
		"wh2_main_anc_weapon_executioners_axe",
		"wh_main_anc_talisman_talisman_of_preservation",
		"wh2_dlc09_anc_talisman_collar_of_shakkara",
	},

	ulric_temple_buildings = {
		"wh3_dlc29_emp_middenland_worship_ulric_1",
		"wh3_dlc29_emp_middenland_worship_ulric_2",
		"wh3_dlc29_emp_middenland_worship_ulric_3",
	},

	priest_foreign_replenishment_bundle = "wh3_dlc29_middenland_priest_foreign_replenishment",

	festival_dilemma_key = "wh3_dlc29_emp_middenland_festival_dilemma",
	dilemma_cooldown = 10,
}

ulric_decrees_config.ancillary_variables = {
	ancillary_counter_current = 0,
	ancillary_counter_max = 10,
	current_ancillary_list = nil,
}

ulric_decrees = {} 
ulric_decrees.config = ulric_decrees_config
ulric_decrees.config.active_missions = {} 
ulric_decrees.completed_missions = {}

require("wh3_dlc29_ulric_decrees_req")

function ulric_decrees:initialise()
	local middenland_interface = cm:get_faction(ulric_decrees_config.faction_key)
	local ancillary_variables = ulric_decrees_config.ancillary_variables

	if middenland_interface then  
		out("#### Adding Ulric Decrees ####")

		ulric_decrees:initialize_ulric_initiatives()

		--Lock all Chosen of Ulric unit
		if cm:is_new_game() then
			cm:add_event_restricted_ui_mercenary_recruitment_info_for_faction("ulric_warband", ulric_decrees_config.faction_key, "wh3_dlc29_chosen_of_ulric_no_sanctuary")
			cm:add_event_restricted_unit_record_for_faction_and_source("wh3_dlc29_emp_inf_hunting_hounds", ulric_decrees_config.faction_key, "wh3_dlc29_emp_warband", "wh3_dlc29_lock_chosen_of_ulric_basic")
			cm:add_event_restricted_unit_record_for_faction_and_source("wh3_dlc29_emp_inf_warriors_of_ulric", ulric_decrees_config.faction_key, "wh3_dlc29_emp_warband", "wh3_dlc29_lock_chosen_of_ulric_basic")
			cm:add_event_restricted_unit_record_for_faction_and_source("wh3_dlc29_emp_inf_wolf_kin", ulric_decrees_config.faction_key, "wh3_dlc29_emp_warband", "wh3_dlc29_lock_chosen_of_ulric_basic")
			cm:add_event_restricted_unit_record_for_faction_and_source("wh3_dlc29_emp_inf_teutogen_guard", ulric_decrees_config.faction_key, "wh3_dlc29_emp_warband", "wh3_dlc29_lock_chosen_of_ulric_elite")
			cm:add_event_restricted_unit_record_for_faction_and_source("wh3_dlc29_emp_cav_knights_of_the_white_wolf", ulric_decrees_config.faction_key, "wh3_dlc29_emp_warband", "wh3_dlc29_lock_chosen_of_ulric_elite")
		end

		core:add_listener(
			"Middenland_Mission_Trigger",
			"FactionTurnStart",
			function(context)
				local faction = context:faction()
				return faction:name() == ulric_decrees_config.faction_key and faction:is_human() and cm:turn_number() == 2
			end,
			function(context)
				local faction = context:faction()
				cm:trigger_mission("wh_main_emp_middenland", "wh3_dlc29_build_temple_of_ulric", true)
			end,
			false
		)

		core:add_listener(
			"GreatTemple_InitiativeActivation",
			"FactionInitiativeActivationChangedEvent",
			function(context)
				return context:active() == true and string.find(context:initiative_set():record_key(), "wh3_dlc29_middenland_the_great_temple_of_ulric_")
			end,
			function(context)
				local initiative_key = context:initiative():record_key()
				if initiative_key == "wh3_dlc29_emp_middenland_the_great_temple_of_ulric_high_altar_of_ulric_level_1" then
					--Trigger the Fervour dilemmas
					cm:set_saved_value("dilemma_countdown", 0)
					cm:set_saved_value("festival_dilemma", true)

				elseif initiative_key == "wh3_dlc29_emp_middenland_the_great_temple_of_ulric_statue_of_the_white_wolf_level_1" then	
					--Unlock the basic Chosen of Ulric units
					cm:remove_event_restricted_ui_mercenary_recruitment_info_for_faction("ulric_warband", ulric_decrees_config.faction_key)
					cm:remove_event_restricted_unit_record_for_faction_and_source("wh3_dlc29_emp_inf_hunting_hounds", ulric_decrees_config.faction_key, "wh3_dlc29_emp_warband")
					cm:remove_event_restricted_unit_record_for_faction_and_source("wh3_dlc29_emp_inf_warriors_of_ulric", ulric_decrees_config.faction_key, "wh3_dlc29_emp_warband")
					cm:remove_event_restricted_unit_record_for_faction_and_source("wh3_dlc29_emp_inf_wolf_kin", ulric_decrees_config.faction_key, "wh3_dlc29_emp_warband")

				elseif initiative_key == "wh3_dlc29_emp_middenland_the_great_temple_of_ulric_pilgrims_retreat_level_1" then	
					--Trigger trespass immunity
					ulric_decrees:enable_trespass_immunity()

				elseif initiative_key == "wh3_dlc29_emp_middenland_the_great_temple_of_ulric_hall_of_flame_level_1" then	
					--Trigger foreign replenishment on Priests of Ulric
					cm:set_saved_value("priest_foreign_replenishment", true)
					ulric_decrees:priest_replenishment_listeners()
					ulric_decrees:update_force_priest_effects()

				elseif initiative_key == "wh3_dlc29_emp_middenland_the_great_temple_of_ulric_teutogen_bastion_level_1" then	
					--Unlock the elite Chosen of Ulric units
					cm:remove_event_restricted_ui_mercenary_recruitment_info_for_faction("ulric_warband", ulric_decrees_config.faction_key)					
					cm:remove_event_restricted_unit_record_for_faction_and_source("wh3_dlc29_emp_inf_teutogen_guard", ulric_decrees_config.faction_key, "wh3_dlc29_emp_warband")
					cm:remove_event_restricted_unit_record_for_faction_and_source("wh3_dlc29_emp_cav_knights_of_the_white_wolf", ulric_decrees_config.faction_key, "wh3_dlc29_emp_warband")

				elseif initiative_key == "wh3_dlc29_emp_middenland_the_great_temple_of_ulric_reliquary_of_fangs_level_2" then	
					--Trigger the periodic item spawning
					cm:set_saved_value("ulric_item_spawning_enabled", true)
					ancillary_variables.current_ancillary_list = ulric_decrees_config.common_ancillary_list

				elseif initiative_key == "wh3_dlc29_emp_middenland_the_great_temple_of_ulric_reliquary_of_fangs_level_3" then	
					--Trigger the periodic item spawning
					ancillary_variables.current_ancillary_list = ulric_decrees_config.uncommon_ancillary_list
					ancillary_variables.ancillary_counter_max = 8

					if ancillary_variables.ancillary_counter_current > ancillary_variables.ancillary_counter_max then
						ancillary_variables.ancillary_counter_current = ancillary_variables.ancillary_counter_max
					end

				elseif initiative_key == "wh3_dlc29_emp_middenland_the_great_temple_of_ulric_reliquary_of_fangs_level_4" then	
					--Trigger the periodic item spawning
					ancillary_variables.current_ancillary_list = ulric_decrees_config.rare_ancillary_list
					ancillary_variables.ancillary_counter_max = 6

					if ancillary_variables.ancillary_counter_current > ancillary_variables.ancillary_counter_max then
						ancillary_variables.ancillary_counter_current = ancillary_variables.ancillary_counter_max
					end

				end			
				
			end,
			true
		)

		core:add_listener(
			"Middenland_Army_Rituals", 
			"RitualCompletedEvent",
			function(context) 
				return context:ritual():ritual_category() == "MIDDENLAND_ARMY_RITUALS" and context:succeeded();
			end,
			function(context)
				local ritual = context:ritual();
				local ritual_key = ritual:ritual_key();
				local target_force = ritual:ritual_target():get_target_force();

				if ritual_key == "wh3_dlc29_middenland_stride_of_the_white_wolf_1" then
					ulric_decrees:replenish_ap(target_force:general_character(), 50)
				elseif ritual_key == "wh3_dlc29_middenland_stride_of_the_white_wolf_2" then	 
					ulric_decrees:replenish_ap(target_force:general_character(), 100)
				elseif ritual_key == "wh3_dlc29_middenland_call_of_the_teutogen_1" then
					cm:spawn_transported_force_at_military_force(target_force:command_queue_index(), "wh3_dlc29_middenland_army_pool_teutogen_only", 0)
				elseif ritual_key == "wh3_dlc29_middenland_call_of_the_teutogen_2" then
					cm:spawn_transported_force_at_military_force(target_force:command_queue_index(), "wh3_dlc29_middenland_army_pool_teutogen_units_improved", 0)
				end
			end,
			true	
		)

		core:add_listener(
			"ReliquaryAncillarySpawning_FactionTurnStart",
			"FactionTurnStart",
			function(context)
				return context:faction():name() == ulric_decrees_config.faction_key and context:faction():is_human() and cm:get_saved_value("ulric_item_spawning_enabled")
			end,
			function(context)
				if ancillary_variables.ancillary_counter_current <= 0 then
					ancillary_variables.ancillary_counter_current = ancillary_variables.ancillary_counter_max

					local ancillary = ancillary_variables.current_ancillary_list[cm:random_number(#ancillary_variables.current_ancillary_list)]
					cm:trigger_custom_incident(context:faction():name(), "wh3_dlc29_emp_middenland_ancilliary_spawning", true, "payload{add_ancillary_to_faction_pool{ancillary_key " .. ancillary .. ";}}")
				end

				ancillary_variables.ancillary_counter_current = ancillary_variables.ancillary_counter_current - 1
			end,
			true
		)	
		
		core:add_listener(
			"FactionTurnStart_FestivalDilemma",
			"FactionTurnStart",
			function(context)
				local faction = context:faction()
				return faction:name() == ulric_decrees_config.faction_key and faction:is_human() and cm:get_saved_value("festival_dilemma")
			end,
			function(context)
				local dilemma_countdown = cm:get_saved_value("dilemma_countdown") or ulric_decrees_config.dilemma_cooldown
				if dilemma_countdown > 0 then
					dilemma_countdown = dilemma_countdown - 1
				end
				cm:set_saved_value("dilemma_countdown", dilemma_countdown)
				if dilemma_countdown == 0 then
					cm:trigger_dilemma(ulric_decrees_config.faction_key, ulric_decrees_config.festival_dilemma_key)
					cm:set_saved_value("dilemma_countdown", ulric_decrees_config.dilemma_cooldown)
				end		
			end,
			true
		)

	end

	if cm:get_saved_value("priest_foreign_replenishment") then
		ulric_decrees:priest_replenishment_listeners()
	end

end     

function ulric_decrees:priest_replenishment_listeners()
	
	core:add_listener(
		"Priest_of_Ulric_Army_Assist",
		"CharacterCharacterTargetAction",
		function(context)
			return context:character():faction():name() == ulric_decrees_config.faction_key and context:ability() == "assist_army"
		end,
		function(context)
			local faction = context:character():faction()
			ulric_decrees:update_force_priest_effects()
		end,
		true
	)
	
	core:add_listener(
		"Priest_of_Ulric_Army_Assist",
		"CharacterLeavesMilitaryForce",
		function(context)
			return context:character():faction():name() == ulric_decrees_config.faction_key
		end,
		function(context)
			local faction = context:character():faction()
			ulric_decrees:update_force_priest_effects()
		end,
		true
	)

	core:add_listener(
		"Priest_Armies_Merge_Completed",
		"CampaignArmiesMergeCompleted",
		true,
		function(context)
		local target_character = context:target_character()
		local has_compatible_target_force = target_character
			and target_character:faction()
			and target_character:faction():name() == ulric_decrees_config.faction_key
			and target_character:military_force()
		if has_compatible_target_force then
			local target_force = target_character:military_force()
			if target_force then
				ulric_decrees:update_force_priest_effects()
			end
		end
		local source_character = context:character()
		local has_compatible_source_force = source_character
			and source_character:faction()
			and source_character:faction():name() == ulric_decrees_config.faction_key
			and source_character:military_force()
			if has_compatible_source_force then
					local source_force = source_character:military_force()
				if source_force then
					ulric_decrees:update_force_priest_effects()
				end
			end
		end,
		true
	)

	core:add_listener(
		"Priest_of_Ulric_Limbo_Event",
		"CharacterEntersLimboEvent",
		function(context)
			return context:character():faction():name() == ulric_decrees_config.faction_key
		end,
		function(context)
			ulric_decrees:update_force_priest_effects()
		end,
		true
	)

	core:add_listener(
		"Priest_of_Ulric_Convalesced_Killed",
		"CharacterConvalescedOrKilled",
		function(context)
			return context:character():faction():name() == ulric_decrees_config.faction_key 
		end,
		function(context)
			ulric_decrees:update_force_priest_effects()
		end,
		true
	);

end

function ulric_decrees:enable_trespass_immunity()
	local emp_factions = cm:get_factions_by_culture("wh_main_emp_empire")
	local middenland_cqi = cm:get_faction(ulric_decrees_config.faction_key):command_queue_index()

	for _, faction in ipairs(emp_factions) do
		cm:add_trespass_permission(middenland_cqi, faction:command_queue_index())
	end
end

function ulric_decrees:replenish_ap(character, value)
	cm:replenish_action_points(cm:char_lookup_str(character), (character:action_points_remaining_percent() + value) / 100)
end

function ulric_decrees:update_force_priest_effects()
    local faction = cm:get_faction(ulric_decrees_config.faction_key)

    if not faction then
        return
    end

    local military_force_list = faction:military_force_list()

    for i = 0, military_force_list:num_items() - 1 do
        local force = military_force_list:item_at(i)

        if force:has_general() then
            local has_priest = false
            local character_list = force:character_list()

            for j = 0, character_list:num_items() - 1 do
                local character = character_list:item_at(j)
                local subtype_key = character:character_subtype_key()

                if subtype_key == "wh3_dlc29_emp_cha_priest_of_ulric"
                or subtype_key == "wh3_dlc29_emp_cha_emil_valgeir" then
                    has_priest = true
                    break
                end
            end

            local mf_cqi = force:command_queue_index()

            if has_priest then
                cm:apply_effect_bundle_to_force(ulric_decrees_config.priest_foreign_replenishment_bundle,mf_cqi,0)
            else
                cm:remove_effect_bundle_from_force(ulric_decrees_config.priest_foreign_replenishment_bundle,mf_cqi)
            end
        end
    end
end

--------------------------------------------------------------
--------------------- ACTIVE MISSION TRACKER -----------------
--------------------------------------------------------------

function ulric_decrees:add_to_active_mission_tracker(faction_key, mission_key)
	if ulric_decrees_config.active_missions[faction_key] == nil then
		ulric_decrees_config.active_missions[faction_key] = {mission_key}
	else
		table.insert(ulric_decrees_config.active_missions[faction_key], mission_key)
	end
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("GreatTemple_AncillaryVariables", ulric_decrees_config.ancillary_variables, context)
	end
)
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			ulric_decrees_config.ancillary_variables = cm:load_named_value("GreatTemple_AncillaryVariables", ulric_decrees_config.ancillary_variables, context)
		end
	end
)
