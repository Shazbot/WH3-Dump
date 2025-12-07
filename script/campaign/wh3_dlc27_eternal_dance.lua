local function log(data)
	out("<<<|{ #ETERNAL_DANCE# }|>>> " .. data)
end

eternal_dance = {
	faction_key = "wh3_dlc27_sla_masque_of_slaanesh",
	devotees_per_dmg = 2,
	devotees_ritual_gain_factor = "wh3_dlc27_sla_eternal_dance_rituals",
	devotees_resource_key = "wh3_main_sla_devotees",
	pooled_resource_key = "wh3_dlc27_sla_tempo",
	pooled_resource_factor_key_fatigue = "wh3_dlc27_slaanesh_tempo_fatigue",
	pooled_resource_factor_key_penalty = "wh3_dlc27_slaanesh_tempo_penalty",
	pooled_resource_factor_key_battle = "battles_won",
	dissonance_effect_bundle_key = "wh3_dlc27_bundle_sla_dissonance_effect",
	character_replaced_death_type = 8, -- DEATH_TYPE_CONVALESCING
	character_replaced_convalesence_cause = 6, -- CONVALESCENCE_CAUSE_RETIREMENT
	devotees_per_dance_bundle_key = "wh3_dlc27_sla_enthusiastic_devotees",
	devotees_per_dance_effect_key = "wh3_dlc27_effect_sla_masque_devotees_per_active_dance",
	devotees_per_dance_bonus_value_key = "wh3_dlc27_sla_masque_technology_devotees_per_dance",
	transfer_loss_bonus_value_key = "wh3_dlc27_sla_masque_technology_transfer_bonus",
	dissonance_duration_bonus_value_key = "wh3_dlc27_sla_masque_technology_dissonance_duration",
	delay_decay_bonus_value_key = "wh3_dlc27_sla_masque_technology_delay_decay",
	tech_eternal_commitement_key = "wh3_dlc27_tech_sla_eternal_commitement",
	tech_changing_the_feet_key = "wh3_dlc27_tech_sla_changing_the_feet",
	tech_enthusiastic_devotees_key = "wh3_dlc27_tech_sla_enthusiastic_devotees",
	exclusive_set_categories = "eternal_dance_categories",
	masque_of_displacement_max_range = 50,
	masque_of_displacement_starting_max_range = 30,
	masque_of_displacement_starting_min_range = 15,
	masque_of_displacement_range_expansion = 1,
	masque_of_displacement_range_expansion_mult = 2,

	-- the ritual assossiated with the masque_of_attraction will transfer the targeted armies towards this faction
	masque_of_attraction_transfer_faction_key = "wh3_dlc27_rogue_unholy_pageant",
	masque_of_attraction_transfer_genereal_type = "wh3_main_sla_herald_of_slaanesh_slaanesh",

	-- Those effect bundles are awarded when the character reaches the Tempo level thresholds in DaVE. 
	tempo_level_bundles = 
	{
		"wh3_dlc27_bundle_sla_tempo_1",
		"wh3_dlc27_bundle_sla_tempo_2",
		"wh3_dlc27_bundle_sla_tempo_3",
		"wh3_dlc27_bundle_sla_tempo_4",
	},

	final_rituals = {
		masque_of_attraction = "wh3_dlc27_sla_ritual_masque_of_attraction",
		masque_of_attraction_step = "wh3_dlc27_eternal_dance_tempo_4_spin",
		masque_of_destruction = "wh3_dlc27_sla_ritual_masque_of_destruction",
		masque_of_destruction_step = "wh3_dlc27_eternal_dance_tempo_4_turn",
		masque_of_displacement = "wh3_dlc27_sla_ritual_masque_of_displacement",
		masque_of_displacement_step = "wh3_dlc27_eternal_dance_tempo_4_pirouette",
		masque_of_reforging = "wh3_dlc27_sla_ritual_masque_of_reforging",
		masque_of_reforging_step = "wh3_dlc27_eternal_dance_tempo_4_chasse",
		masque_of_reforging_effect_bundle = "wh3_dlc27_bundle_sla_masque_of_reforging",
	},

	dance_data = {
		["ETERNAL_DANCE_OF_GREED_INITIATIVES"] = {
			performed_ritual = "wh3_dlc27_sla_ritual_dance_of_greed_performed",				-- Ritual used when switching dances, it locks the previously used dance. 
			lock_bundle_force = "wh3_dlc27_bundle_sla_dance_of_greed_locking_force",		-- Bundle used to lock the dance, only to be removed after a dance is fully completed
			num_dance_to_complete = 0,														-- Amount of dance to complete before unlocking this one. 			
			tempo_1_initiative_set = "wh3_dlc27_eternal_dance_of_nurgle_tempo_1",
			tempo_2_initiative_set = "wh3_dlc27_eternal_dance_of_nurgle_tempo_2",
			tempo_3_initiative_set = "wh3_dlc27_eternal_dance_of_nurgle_tempo_3",
			tempo_4_initiative_set = "wh3_dlc27_eternal_dance_of_nurgle_tempo_4",
			innate_bundle_key = "wh3_dlc27_bundle_sla_dance_of_greed_innate",				-- Innate bundle are awared when selecting the dance
			completed_dance_bundle_key = "wh3_dlc27_bundle_sla_eternal_dance_repertoire_3",		-- Bundle applied when the dance is completed, it gives a bonus to the faction
		},
		["ETERNAL_DANCE_OF_ENVY_INITIATIVES"] = {
			performed_ritual = "wh3_dlc27_sla_ritual_dance_of_envy_performed",
			lock_bundle_force = "wh3_dlc27_bundle_sla_dance_of_envy_locking_force",
			num_dance_to_complete = 0,
			tempo_1_initiative_set = "wh3_dlc27_eternal_dance_of_elves_tempo_1",
			tempo_2_initiative_set = "wh3_dlc27_eternal_dance_of_elves_tempo_2",
			tempo_3_initiative_set = "wh3_dlc27_eternal_dance_of_elves_tempo_3",
			tempo_4_initiative_set = "wh3_dlc27_eternal_dance_of_elves_tempo_4",
			innate_bundle_key = "wh3_dlc27_bundle_sla_dance_of_envy_innate",
			completed_dance_bundle_key = "wh3_dlc27_bundle_sla_eternal_dance_repertoire_2",
		},
		["ETERNAL_DANCE_OF_EXCESS_INITIATIVES"] = {
			performed_ritual = "wh3_dlc27_sla_ritual_dance_of_excess_performed",	
			lock_bundle_force = "wh3_dlc27_bundle_sla_dance_of_excess_locking_force",
			num_dance_to_complete = 0,												
			tempo_1_initiative_set = "wh3_dlc27_eternal_dance_of_khorne_tempo_1",
			tempo_2_initiative_set = "wh3_dlc27_eternal_dance_of_khorne_tempo_2",
			tempo_3_initiative_set = "wh3_dlc27_eternal_dance_of_khorne_tempo_3",
			tempo_4_initiative_set = "wh3_dlc27_eternal_dance_of_khorne_tempo_4",
			innate_bundle_key = "wh3_dlc27_bundle_sla_dance_of_excess_innate",
			completed_dance_bundle_key = "wh3_dlc27_bundle_sla_eternal_dance_repertoire_1",
		},
		["ETERNAL_DANCE_OF_PRIDE_INITIATIVES"] = {
			performed_ritual = "wh3_dlc27_sla_ritual_dance_of_pride_performed",
			lock_bundle_force = "wh3_dlc27_bundle_sla_dance_of_pride_locking_force",
			num_dance_to_complete = 3,
			tempo_1_initiative_set = "wh3_dlc27_eternal_dance_of_final_battle_tempo_1",
			tempo_2_initiative_set = "wh3_dlc27_eternal_dance_of_final_battle_tempo_2",
			tempo_3_initiative_set = "wh3_dlc27_eternal_dance_of_final_battle_tempo_3",
			tempo_4_initiative_set = "wh3_dlc27_eternal_dance_of_final_battle_tempo_4",
			innate_bundle_key = "wh3_dlc27_bundle_sla_dance_of_pride_innate",
			completed_dance_bundle_key = "wh3_dlc27_bundle_sla_eternal_dance_repertoire_4",
		},
	},

	-- We want stances to provide effects + conditional effects depending on tempo level. 
	stances_data = {
		["MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID"] = {
			bundle_key = "wh3_dlc27_bundle_stance_the_masque_raiding_tempo_4",
		},
		["MILITARY_FORCE_ACTIVE_STANCE_TYPE_DEFAULT"] = {
			bundle_key = "wh3_dlc27_bundle_stance_the_masque_default_tempo_4",
		},
		["MILITARY_FORCE_ACTIVE_STANCE_TYPE_MARCH"] = {
			bundle_key = "wh3_dlc27_bundle_stance_the_masque_march_tempo_4",
		},
	},

	-- list of characters who performed masque_of_reforging ritual.
	characters_reforging = {},

	-- holds the invasion keys for armies which have been 'frenzied'
	-- this means their behavior is entirely scripted
	masque_of_attraction_invasion_keys = {},

	-- Since tempo is per army, we need a table to store the different characters and their current fatigue
	dancing_characters_fatigue_data = {}, 

	-- This table stores the fatigue value we want to apply after 1,2,3,4,5 turns. 
	fatigue_level_matrix = {
		level_1 = {0, 5 , 10, 15 , 20 },
		level_2 = {0, 9 , 18, 37 , 60 },
		level_3 = {0, 11, 22, 50 , 100},
		level_4 = {0, 37, 75, 150, 333},
	},

	-- The penalty we apply to the tempo of the force when switching dance, in percentage 
	dance_switching_penalties = {
		0.90,	-- Tempo Level 1 -> 10% penalty  
		0.70,
		0.50,
		0.30,
	},

	tech_bonuses = {
		delay_decay = 0,
		dissonance_duration = 0,
		transfer_loss_bonus = 0,
	},

	max_fatigue_turns = 5,
	number_of_dances = 4,
	dance_completed_record = {}, 
	CAI_tempo_bonus_bundle = "wh3_dlc27_sla_masque_background_ai_extra_tempo_hidden",
}

--------------------------------------------------------------
------------------- INIT / EVENT LISTENERS -------------------
--------------------------------------------------------------

function eternal_dance:initialise()

	-- Apply bonus effect bundle to CAI Masque
	local masq_faction = cm:get_faction(eternal_dance.faction_key)
	if masq_faction and masq_faction:is_human() == false then
		cm:apply_effect_bundle(eternal_dance.CAI_tempo_bonus_bundle, eternal_dance.faction_key, 0)
	end
	-- Register any general that wouldnt be and calculate fatigue and apply it.
	core:add_listener(
		"EternalDance_CalculateTempoFatigue",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == eternal_dance.faction_key
		end,
		function(context)
			eternal_dance:initialize_faction(context:faction())
			eternal_dance:UpdateGeneralsFatigue()
		end,
		true
	)

	-- Remove any character that would be killed or wounded from the list. 
	core:add_listener(
		"EternalDance_GeneralConvalescedOrKilled",
		"CharacterConvalescedOrKilled",
		function(context)
			return context:character():faction():name() == eternal_dance.faction_key and context:character():character_type_key() == "general" and context:character():character_subtype_key() ~= "wh3_main_sla_herald_of_slaanesh_slaanesh_disciple_army"
		end,
		function(context)
			local char = context:character()
			local force = char:military_force()
			local registered_general = eternal_dance:GetRegisteredGeneral(char)

			if force == nil or registered_general == nil then 
				return
			end

			-- if character wounded, either by replace or death, remove and reset (if in progress) the dance
			cm:remove_initiative_set_category_preset(registered_general.current_dance, char:command_queue_index(), true)

			-- remove innate dance bundle 
			if registered_general.current_dance and force:is_null_interface() == false then
				if force:has_effect_bundle(eternal_dance.dance_data[registered_general.current_dance].innate_bundle_key) then
					cm:remove_effect_bundle_from_force(eternal_dance.dance_data[registered_general.current_dance].innate_bundle_key, force:command_queue_index())
				end
			end

			-- if killed set tempo to 0.
			if registered_general.current_dance ~= nil and
				char:convalesence_cause() ~= eternal_dance.character_replaced_convalesence_cause and
				char:death_type() ~= eternal_dance.character_replaced_death_type
			then
				local resource = char:military_force():pooled_resource_manager():resource(eternal_dance.pooled_resource_key)
				cm:pooled_resource_factor_transaction(resource, eternal_dance.pooled_resource_factor_key_fatigue, -resource:value())
			end

			eternal_dance:UpdateFactionForcesDanceLock(context:character():faction())
			eternal_dance:UpdateTechBonuses()

			-- remove him from the registry
			for index, item in ipairs(eternal_dance.dancing_characters_fatigue_data) do
				if item.general_cqi == char:command_queue_index() then 
					table.remove(eternal_dance.dancing_characters_fatigue_data, index)
				end
			end
		end,
		true
	)

	-- Register any new general recruited. 
	core:add_listener(
		"EternalDance_GeneralReplaced",
		"CharacterRecruited",
		function(context)
			return context:character():faction():name() == eternal_dance.faction_key and context:character():character_type_key() == "general" and context:character():character_subtype_key() ~= "wh3_main_sla_herald_of_slaanesh_slaanesh_disciple_army"
		end,
		function(context)
			local char = context:character()
			if eternal_dance:IsGeneralAlreadyRegistered(char) == false then 
				eternal_dance:RegisterForceWithDance(char)
				eternal_dance:UpdateFactionForcesDanceLock(char:faction())
				if char:faction():is_human() == false then
					eternal_dance:CAI_ChoseDance(char)
				end
			end
			eternal_dance:UpdateTechBonuses()
		end,
		true
	)

	-- Monitor pooled resource changed to trigger scripted event when reaching a dance threshold.
	core:add_listener(
		"EternalDance_PooledResourceChanged",
		"PooledResourceChanged",
		function(context)
			if not context:faction():is_null_interface() then
				return context:faction():name() == eternal_dance.faction_key and context:resource():key() == eternal_dance.pooled_resource_key
			else
				return false
			end
		end,
		function(context)
			local amount = context:amount()
			local general = context:resource():manager():military_force():general_character()
			local registered_general = eternal_dance:GetRegisteredGeneral(general)
			local tempo_level = eternal_dance:GetCurrentTempoLevel(general:military_force())

			if general == nil or registered_general == nil then
				return
			end

			local event_data = 
			{
				general = general,
				tempo_level = tempo_level,
			}

			if tempo_level > registered_general.current_fatigue_level then
				registered_general.current_fatigue_level = eternal_dance:GetCurrentTempoLevel(general:military_force())
				core:trigger_event("EternalDanceTempoThresholdUpgraded", event_data)
			elseif tempo_level < registered_general.current_fatigue_level then
				registered_general.current_fatigue_level = eternal_dance:GetCurrentTempoLevel(general:military_force())
				core:trigger_event("EternalDanceTempoThresholdDowngraded", event_data)
			end

			eternal_dance.UpdateUISharedStates()
		end,
		true
	)

	
	-- panel is opened
	core:add_listener(
		"EternalDance_PanelOpenedCampaign",
		"PanelOpenedCampaign",
		function(context)
			return context.string == "character_details_panel"
		end,
		function(context)
			eternal_dance.UpdateUISharedStates()
		end, 
		true
	)

	-- Eternal dance switched, where we apply a penalty
	core:add_listener(
		"EternalDance_Switched",
		"CharacterInitiativePresetActivatedEvent",
		function(context)
			return string.find(context:category(), "ETERNAL_DANCE") and true or false
		end,
		function(context)
			log("!SELECTED A DANCE!")

			local general = context:character()
			local dance = context:category()
			local finished = context:preset_is_finished()

			log("Dance:> " .. dance .. " finished: " .. tostring(finished))

			local force = context:character():has_military_force() and context:character():military_force()
			if not force then
				script_error("RECEIVED EVENT " .. context.string .. " but the character doesn't have military force. character_cqi: " .. tostring(general:command_queue_index()))
				return
			end
			

			local registered_general, idx = eternal_dance:GetRegisteredGeneral(general)

			-- If our general has already a dance, and the new dance is different it means its switching. So we apply a penalty, and dissonance.
			if registered_general and registered_general.current_dance and registered_general.current_dance ~= dance and registered_general.current_dance ~= "" then
				log("Found Dancing general! Changing dance: " .. registered_general.current_dance .. " -> " .. dance)
				log("Applying tempo penalty, removing old dance effects, setting cooldown and applying dissonance...")

				local force_resource_manager = force:pooled_resource_manager():resource(eternal_dance.pooled_resource_key)
				local tempo_level = eternal_dance:GetCurrentTempoLevel(force)
				local tempo_penalty = eternal_dance.dance_switching_penalties[tempo_level]
				local penalty_amount = (tempo_penalty * force_resource_manager:value())

				-- remove dance bundle
				if force:has_effect_bundle(eternal_dance.dance_data[registered_general.current_dance].innate_bundle_key) then
					cm:remove_effect_bundle_from_force(eternal_dance.dance_data[registered_general.current_dance].innate_bundle_key, force:command_queue_index())
				end

				-- Lose tempo. If the technology is unlocked, reduce by X% the amount of tempo lost 
				if eternal_dance.tech_bonuses.transfer_loss_bonus > 0 then
					penalty_amount = penalty_amount - (penalty_amount * eternal_dance.tech_bonuses.transfer_loss_bonus)
				end

				cm:pooled_resource_factor_transaction(force_resource_manager, eternal_dance.pooled_resource_factor_key_penalty, - penalty_amount)
				
				--Prepare and trigger the dance change ritual. This sets the dance we change from on cooldown 
				local ritual_key = eternal_dance.dance_data[registered_general.current_dance].performed_ritual
				local ritual_setup = cm:create_new_ritual_setup(force:faction(), ritual_key);
				ritual_setup:target():set_target_force(force)

				if ritual_setup:target():valid() then
					cm:perform_ritual_with_setup(ritual_setup);
				end

				--Trigger the dissonance effect 
				eternal_dance.dancing_characters_fatigue_data[idx].is_dissonant = true
				eternal_dance.dancing_characters_fatigue_data[idx].dissonance_duration = tempo_level - eternal_dance.tech_bonuses.dissonance_duration
				eternal_dance.dancing_characters_fatigue_data[idx].current_dissonance_duration = 0
				cm:apply_effect_bundle_to_force(eternal_dance.dissonance_effect_bundle_key, force:command_queue_index(), eternal_dance.dancing_characters_fatigue_data[idx].dissonance_duration)
			end

			-- if we dont have a registered general, register one...
			if registered_general == nil then
				log("General with milforce_cqi " .. tostring(force:command_queue_index()) .. " not registered! This techincally should not happer, or be very rare.")
				registered_general, idx = eternal_dance:RegisterForceWithDance(general, dance)
			else
				-- update dance
				eternal_dance.dancing_characters_fatigue_data[idx].current_dance = dance
				eternal_dance.dancing_characters_fatigue_data[idx].is_dance_finished = finished
			end

			-- update effects
			eternal_dance:UpdateFactionForcesDanceLock(general:faction())
			eternal_dance:UpdateTechBonuses()
			eternal_dance:UpdateStanceBundles(force)
			cm:apply_effect_bundle_to_force(eternal_dance.dance_data[registered_general.current_dance].innate_bundle_key, force:command_queue_index(), 0)
		end, 
		true
	)

	--Dance is finished, unlock new dances / initiatives. 
	core:add_listener(
		"EternalDance_Completed",
		"InitiativePresetFinishedEvent",
		function(context)
			return context:category():starts_with("ETERNAL_DANCE_OF")
		end,
		function(context)

			local category_key = context:category()
			local faction = context:faction()
			local bundle_key = eternal_dance.dance_data[category_key].completed_dance_bundle_key
			if not faction:has_effect_bundle(bundle_key) then
				cm:apply_effect_bundle(bundle_key, faction:name(), 0)
			end

			local dancers_to_update = eternal_dance:GetCharacterWithDance(category_key)
			for _, cqi in ipairs(dancers_to_update) do 
				local data, idx = eternal_dance:GetRegisteredGeneralByCQI(cqi)
				if data then
					eternal_dance.dancing_characters_fatigue_data[idx].is_dance_finished = true
				end
			end

			if eternal_dance:HasThisDanceBeenCompleted(category_key) == false then 
				table.insert(eternal_dance.dance_completed_record, 1, category_key)
			end
			eternal_dance:UpdateFactionForcesDanceLock(faction)
		end,
		true
	)

	--EternalDanceTempoThresholdUpgraded
	core:add_listener(
		"EternalDance_TempoThresholdUpgraded",
		"EternalDanceTempoThresholdUpgraded",
		function(context)
			return true
		end,
		function(context)
			local general = context.stored_table.general
			local tempoLevel = context.stored_table.tempo_level
			local registered_general = eternal_dance:GetRegisteredGeneral(general) 

			-- Reset fatigue counter and delay
			registered_general.current_fatigue_turn = 1
			registered_general.current_fatigue_delay = eternal_dance.tech_bonuses.delay_decay

			if general:faction():is_human() == false and general:character_subtype_key() ~= "wh3_main_sla_herald_of_slaanesh_slaanesh_disciple_army" then
				eternal_dance:CAI_ChoseTempoInitiative(general)
			end

			if context.stored_table.tempo_level >= 4 then 
				local mil_force = general:military_force()
				eternal_dance:UpdateStanceBundles(mil_force)
			end
		end,
		true
	)

	--EternalDanceTempoThresholdDowngraded
	core:add_listener(
		"EternalDance_TempoThresholdDowngraded",
		"EternalDanceTempoThresholdDowngraded",
		function(context)
			return true
		end,
		function(context)
			local general = context.stored_table.general
			local tempoLevel = context.stored_table.tempo_level
			local registered_general = eternal_dance:GetRegisteredGeneral(general) 
			
			-- set the dissonance effect ON. 
			registered_general.is_dissonant = true
			registered_general.dissonance_duration = tempoLevel
			registered_general.current_dissonance_duration = 0
			
			-- Reset fatigue counter and delay
			registered_general.current_fatigue_turn = 1
			registered_general.current_fatigue_delay = eternal_dance.tech_bonuses.delay_decay

			if context.stored_table.tempo_level < 4 then 
				local mil_force = general:military_force()
				eternal_dance:UpdateStanceBundles(mil_force)
			end
		end,
		true
	)

	--ResearchCompleted
	core:add_listener(
		"EternalDance_ResearchCompleted",
		"ResearchCompleted",
		function(context)
			return context:faction():name() == eternal_dance.faction_key
		end,
		function(context)
			eternal_dance:UpdateTechBonuses()
		end,
		true
	)
	
	--RitualCompletedEvent
	core:add_listener(
		"EternalDance_MasqueFinalRitualCompleted",
		"RitualCompletedEvent",
		function(context)
			return context:performing_faction():name() == eternal_dance.faction_key
		end,
		function(context)
			local l_ctx = context
			eternal_dance:perform_ritual_action(l_ctx)
		end,
		true
	)

	-- CharacterCompletedBattle
	core:add_listener(
		"EternalDance_CharacterCompletedBattle_masque_of_reforging",
		"CharacterCompletedBattle",
		function(context)
			return context:character():faction():name() == eternal_dance.faction_key
		end,
		function(context)
			local our_char = context:character()
			for idx, cqi in ipairs(eternal_dance.characters_reforging) do
				if our_char:command_queue_index() == cqi then
					if our_char:has_effect_bundle(eternal_dance.final_rituals.masque_of_reforging_effect_bundle) then
						cm:remove_effect_bundle_from_characters_force(eternal_dance.final_rituals.masque_of_reforging_effect_bundle, our_char:command_queue_index())
						table.remove(eternal_dance.characters_reforging, idx)
						return
					end
				end
			end
		end,
		true
	)

	-- Check if the general of an invasion by the Mark of Attraction was killed
	core:add_listener(
		"EternalDanceInvasionTarget_GeneralConvalescedOrKilled",
		"CharacterConvalescedOrKilled",
		true,
		function(context)
			local killed_character = context:character()
			local killed_general_cqi = killed_character:command_queue_index()
			for i = 1, #eternal_dance.masque_of_attraction_invasion_keys do
				local invasion_key = eternal_dance.masque_of_attraction_invasion_keys[i]
				local invasion_object = invasion_manager:get_invasion(invasion_key)
				local invasion_general_cqi = invasion_object.general_cqi
				if killed_general_cqi == invasion_general_cqi then
					-- the general of the invasion was killed, the invasion is removed
					table.remove(eternal_dance.masque_of_attraction_invasion_keys, i)
					return
				end
			end
		end,
		true
	)

	-- Check if the general or target of an invasion by the Mark of Attraction was killed
	core:add_listener(
		"EternalDance_ScriptEventInvasionNoTarget",
		"ScriptEventInvasionNoTarget",
		true,
		function(context)
			local targetless_invasion_key = context.string
			for i = 1, #eternal_dance.masque_of_attraction_invasion_keys do
				local invasion_key = eternal_dance.masque_of_attraction_invasion_keys[i]
				if invasion_key == targetless_invasion_key then
					local invasion_object = invasion_manager:get_invasion(invasion_key)
					local force_object = cm:force_from_general_cqi(invasion_object.general_cqi);
					local new_target_success = eternal_dance:ChooseTargetForFrenzyArmy(invasion_object, force_object)
					if not new_target_success then
						-- we could not find a new target, removing the invasion
						table.remove(eternal_dance.masque_of_attraction_invasion_keys, i)
					end
					return
				end
			end
		end,
		true
	)

	
	-- the frenzied army owner faction should declare war on everyone they meet - except the maskque itself
	core:add_listener(
		"EternalDance_FactionEncountersOtherFaction",
		"FactionEncountersOtherFaction",
		true,
		function(context)
			local faction_key_1 = context:faction():name() 
			local faction_key_2 = context:other_faction():name()
			if faction_key_1 ~= eternal_dance.masque_of_attraction_transfer_faction_key 
				or faction_key_2 == eternal_dance.faction_key
			then
				return
			end

			cm:force_declare_war(eternal_dance.masque_of_attraction_transfer_faction_key, faction_key_2, false, false)
		end,
		true
	)

	-- Used to update tempo lvl 4 stances bundles. 
	core:add_listener(
		"EternalDance_StanceBundles",
		"ForceAdoptsStance",
		function(context)
			return context:military_force():faction():name() == eternal_dance.faction_key 
			and not context:military_force():general_character():is_null_interface()
			and eternal_dance:IsGeneralAlreadyRegistered(context:military_force():general_character())
		end,
		function(context)
			eternal_dance:UpdateStanceBundles(context:military_force())
		end,
		true
	)

	-- When confederating with other Slaaneshy factions, update the dance lock. 
	core:add_listener(
		"EternalDance_Confederation",
		"FactionJoinsConfederation",
		function(context)
			return context:confederation():name() == eternal_dance.faction_key
		end,
		function(context)
			eternal_dance:initialize_faction(context:confederation())
		end,
		true
	)
end

--------------------------------------------------------------
----------------------- UTILS / FUNCTIONS --------------------
--------------------------------------------------------------

function eternal_dance:initialize_faction(faction)
	local forces = faction:military_force_list() 

	for i = 0, forces:num_items() - 1 do
		local char = forces:item_at(i):general_character()
		if char:character_type_key() == "general" and eternal_dance:IsGeneralAlreadyRegistered(char) == false and char:character_subtype_key() ~= "wh3_main_sla_herald_of_slaanesh_slaanesh_disciple_army" 
			and char:is_alive() and char:is_wounded() == false 
		then
			eternal_dance:RegisterForceWithDance(char)
			eternal_dance:UpdateGeneralDanceLock(char)
			if faction:is_human() == false then 
				eternal_dance:CAI_ChoseDance(char)
			end
		end
	end
end

function eternal_dance:perform_ritual_action(context)
	local ritual = context:ritual()
	local ritual_key = ritual:ritual_key()
	local ritual_target = ritual:ritual_target()

	if ritual_key ~= eternal_dance.final_rituals.masque_of_attraction and ritual_key ~= eternal_dance.final_rituals.masque_of_destruction and
 		ritual_key ~= eternal_dance.final_rituals.masque_of_displacement and ritual_key ~= eternal_dance.final_rituals.masque_of_reforging
	then
		return
	end

	log("Performing ETERNAL DANCE MASQUE RITUAL: " .. ritual_key)
	if ritual_target:valid() == false then
		log("Ritual target is not valid. Dumping data before script error...")
		log("target type: " .. ritual_target:target_type())
		log("target_record_key: " .. ritual_target:target_record_key())
		log("can_target_self: " .. tostring(ritual_target:can_target_self()))
		script_error("Target not valid!")
		return
	end

	if ritual_key == eternal_dance.final_rituals.masque_of_attraction then
		eternal_dance:perform_masque_of_attraction(ritual_target, context:performing_faction())
	elseif ritual_key == eternal_dance.final_rituals.masque_of_destruction then
		eternal_dance:perform_masque_of_destruction(ritual_target, context:performing_faction())
	elseif ritual_key == eternal_dance.final_rituals.masque_of_displacement then
		eternal_dance:perform_masque_of_displacement(ritual_target, context:performing_faction())
	elseif ritual_key == eternal_dance.final_rituals.masque_of_reforging then
		eternal_dance:perform_masque_of_reforging(ritual_target)
	end
end

function eternal_dance:perform_masque_of_attraction(ritual_target, performing_faction)
	-- the performing_faction targets an enemy force - causing it to attack any of its enemies EXCEPT the performing faction
	-- this means the faction loses control of its army until the attack is done

	local targeted_force = ritual_target:get_target_force()
	local new_faction_object = cm:get_faction(eternal_dance.masque_of_attraction_transfer_faction_key)

	-- we move the army to a new faction
	local transfer_payload = cm:create_payload()
	transfer_payload:army_transfer(targeted_force, new_faction_object)
	cm:apply_payload(transfer_payload, new_faction_object)

	if new_faction_object:is_dead() then
		cm:awaken_faction_from_death(new_faction_object)
	end

	local general_object = targeted_force:general_character()
	if general_object:character_type("colonel") then
		cm:replace_general_in_force(targeted_force, eternal_dance.masque_of_attraction_transfer_genereal_type)
	end

	-- we create an invasion object to manage the force from Lua
	local general_character = targeted_force:general_character()
	local invasion_key = "force_" .. targeted_force:command_queue_index() .. "_GONE_MAD"
	local invasion_object = invasion_manager:new_invasion_from_existing_force(invasion_key, targeted_force)

	-- we don't want the army to try and recruit and maintain itself
	invasion_object.maintain_army = false
	-- we don't want it to respawn after death
	invasion_object.respawn = false
	-- we want the army to try and chase other armies it meets on the way
	invasion_object:add_aggro_radius(15)

	-- we try and find a target for the faction
	local target_success = eternal_dance:ChooseTargetForFrenzyArmy(invasion_object, targeted_force)
	if target_success then
		table.insert(eternal_dance.masque_of_attraction_invasion_keys, invasion_key)
	end

	invasion_object:start_invasion(
		nil,	-- callback function
		false, 	-- declare_war
		false, 	-- invite_attacker_allies
		false,	-- invite_defender_allies
		false	-- allow_diplomatic_discovery
	)

	log("MASQUE OF ATTRACTION started invasion: '" .. invasion_key .. "'")

end

function eternal_dance:perform_masque_of_destruction(ritual_target, performing_faction)
	if ritual_target:get_target_region():is_null_interface() then
		script_error("Missing target region for ritual. Aborting...")
		return
	end

	if ritual_target:get_target_region():owning_faction():name() == eternal_dance.faction_key then
		-- do nothing in friendly regions
		out("Attempting to damage friendly region. Doing nothing...")
		return
	end

	local residence = ritual_target:get_target_region():garrison_residence()
	local damage = cm:random_number(80, 50);
	local devotees_gain = damage * eternal_dance.devotees_per_dmg
	log("MASQUE OF DESTRUCTION did " .. damage .. "% damage to garrison residence! Gained Devotees " .. devotees_gain)
	cm:sabotage_garrison_army(residence, damage)
	cm:pooled_resource_factor_transaction(performing_faction:pooled_resource_manager():resource(eternal_dance.devotees_resource_key), eternal_dance.devotees_ritual_gain_factor, devotees_gain)
end

function eternal_dance:perform_masque_of_displacement(ritual_target, performing_faction)
	local char_to_tp = ritual_target:get_target_force():general_character()

	local success = false
	local expand_param = eternal_dance.masque_of_displacement_range_expansion
	local expansion_mult = eternal_dance.masque_of_displacement_range_expansion_mult
	local max_expand = eternal_dance.masque_of_displacement_max_range
	local range = cm:random_number(eternal_dance.masque_of_displacement_starting_max_range, eternal_dance.masque_of_displacement_starting_min_range)
	local lookup = cm:char_lookup_str(char_to_tp:command_queue_index())

	-- try normal spawn
	while (success == false and expand_param <= max_expand) do
		local x, y = cm:find_valid_spawn_location_for_character_from_character(performing_faction:name(), lookup, false, range);
		out("Trying to teleport: " .. lookup .. " to coords: " .. x .. "/" .. y .. " | range expansion: " .. expand_param)
		if x > 0 and y > 0 then
			success = cm:teleport_to(lookup, x + expand_param, y + expand_param);
		end
		expand_param = expand_param * expansion_mult
	end

	-- try tp in same region if we were not able to find any place
	if success == false then
		expand_param = eternal_dance.masque_of_displacement_range_expansion
		while (success == false and expand_param <= max_expand) do
			local x, y = cm:find_valid_spawn_location_for_character_from_character(performing_faction:name(), lookup, true, range);
			out("Trying to teleport: " .. lookup .. " to coords: " .. x .. "/" .. y .. " | range expansion: " .. expand_param)
			if x > 0 and y > 0 then
				success = cm:teleport_to(lookup, x + expand_param, y + expand_param);
			end
			expand_param = expand_param * expansion_mult
		end
	end
end

function eternal_dance:perform_masque_of_reforging(ritual_target)
	--log("MASQUE OF REFORGING! Applying resurect demons for 1 battle...")
	--cm:apply_effect_bundle_to_characters_force(eternal_dance.final_rituals.masque_of_reforging_effect_bundle, ritual_target:get_target_force():general_character():command_queue_index(), 0)
	--table.insert(eternal_dance.characters_reforging, #eternal_dance.characters_reforging + 1, ritual_target:get_target_force():general_character():command_queue_index())
end

function eternal_dance:GetCurrentTempoLevel(mil_force)
	local tempo = mil_force:pooled_resource_manager():resource(eternal_dance.pooled_resource_key)

	-- Pooled resource effect type are : 
	-- 0 -> absolute value 
	-- 1 -> percentage of capacity
	for index, item in ipairs(eternal_dance.tempo_level_bundles) do
		if not tempo:is_null_interface() and tempo:active_effect(0) == item then
			return index
		end
	end

	return 1
end

function eternal_dance:IsGeneralAlreadyRegistered(character)
	return eternal_dance:GetRegisteredGeneral(character) ~= nil
end

function eternal_dance:GetRegisteredGeneral(character)
	for index, item in ipairs(eternal_dance.dancing_characters_fatigue_data) do
		if item.general_cqi == character:command_queue_index() then 
			return item, index
		end
	end

	return nil, nil
end

function eternal_dance:GetRegisteredGeneralByCQI(character_cqi)
	for index, item in ipairs(eternal_dance.dancing_characters_fatigue_data) do
		if item.general_cqi == character_cqi then 
			return item, index
		end
	end

	return nil, nil
end

function eternal_dance:RegisterForceWithDance(character, assigned_dance, should_apply_internal_dance)
	log("Registering new dancing character: " .. character:command_queue_index())

	local register_general, idx = eternal_dance:GetRegisteredGeneral(character)

	-- if no general registered, add one.
	if register_general == nil then
		log("No registered general for this CQI! Registering...")

		register_general = eternal_dance:CreateForceInstance(character)
		idx = #eternal_dance.dancing_characters_fatigue_data + 1
		table.insert(eternal_dance.dancing_characters_fatigue_data, idx, register_general)
	end

	if is_string(assigned_dance) and assigned_dance ~= "" then
		log("Applying dance to registered character: " .. character:command_queue_index() .. " | dance: " .. assigned_dance)

		-- assign/pick the dance cateogry inside the character manager in c++ (pressing the button to pick dance does this, but just in case, we have it here also.)
		if is_boolean(should_apply_internal_dance) and should_apply_internal_dance then
			cm:apply_add_initiative_set_category_preset(assigned_dance, eternal_dance.exclusive_set_categories, character:command_queue_index(), true, false)
		end

		-- apply new dance and bundle
		eternal_dance.dancing_characters_fatigue_data[idx].current_dance = assigned_dance
		cm:apply_effect_bundle_to_force(eternal_dance.dance_data[register_general.current_dance].innate_bundle_key, character:military_force():command_queue_index(), 0)
	end 

	return register_general, idx
end

function eternal_dance:CreateForceInstance(character)
	local dancing_force = {
		general_cqi = character:command_queue_index(),
		current_fatigue_delay = eternal_dance.tech_bonuses.delay_decay,
		current_fatigue_level = eternal_dance:GetCurrentTempoLevel(character:military_force()),
		current_fatigue_turn = 1,
		-- When decreasing in tempo, we pause the fatigue for [tempo_level] duration. Preventing flip-flopping
		is_dissonant = false, 
		dissonance_duration = 0,
		current_dissonance_duration = 0,
		current_dance = nil,
		is_dance_finished = false,
	}

	return dancing_force
end

function eternal_dance:UpdateGeneralsFatigue()
	for index, item in ipairs(eternal_dance.dancing_characters_fatigue_data) do
		local force = cm:get_character_by_cqi(item.general_cqi):military_force()

		if item.is_dissonant == true then
			item.current_dissonance_duration = item.current_dissonance_duration + 1
			-- We keep the fatigue at 0 for the whole duration of the dissonance. 
			item.current_fatigue_turn = 1

			if item.current_dissonance_duration >= item.dissonance_duration then 
				item.is_dissonant = false
				item.dissonance_duration = 0
				item.current_dissonance_duration = 0
				cm:remove_effect_bundle_from_force(eternal_dance.dissonance_effect_bundle_key, force:command_queue_index())
			end

			-- No need to compute the fatigue as its 0 for a duration, so we return
			return
		end

		-- Handle fatigue incrementation
		if cm:turn_number() > 1 then 
			-- Fatigue may be delayed via tech tree bonus
			if item.current_fatigue_delay > 0 and item.current_fatigue_turn <= 1 then 
				item.current_fatigue_delay = item.current_fatigue_delay - 1
				--eternal_dance:ApplyFatigue(force)
				return
			end
			
			--eternal_dance:ApplyFatigue(force)

			-- If we are not delayed or leveld up in tempo, just increase the counter and move on. 
			if item.current_fatigue_turn < eternal_dance.max_fatigue_turns then 
				item.current_fatigue_turn = item.current_fatigue_turn + 1
			end
		end
	end
end

function eternal_dance:ApplyFatigue(force)
	local force_resource_manager = force:pooled_resource_manager():resource(eternal_dance.pooled_resource_key)
	local registered_general = eternal_dance:GetRegisteredGeneral(force:general_character())
	local fatigue_level = eternal_dance.fatigue_level_matrix["level_" .. registered_general.current_fatigue_level]
	local amount = fatigue_level[registered_general.current_fatigue_turn]

	cm:pooled_resource_factor_transaction(force_resource_manager, eternal_dance.pooled_resource_factor_key_fatigue, - amount)
end

function eternal_dance:UpdateFactionForcesDanceLock(faction)
	local forces = faction:military_force_list() 

	for i = 0, forces:num_items() - 1 do
		local general = forces:item_at(i):general_character()
		if general:character_type_key() == "general" and general:character_subtype_key() ~= "wh3_main_sla_herald_of_slaanesh_slaanesh_disciple_army" then
			eternal_dance:UpdateGeneralDanceLock(general)
		end
	end
end

function eternal_dance:UpdateGeneralDanceLock(general)
	-- if we are legit general
	if not general:is_null_interface() and eternal_dance:IsGeneralAlreadyRegistered(general) then
		local our_data, our_idx = eternal_dance:GetRegisteredGeneral(general)

		-- go trough each dance and apply lock.
		for dance_key, dance_data in dpairs(eternal_dance.dance_data) do
			-- check if unlocked dance
			if #eternal_dance.dance_completed_record >= dance_data.num_dance_to_complete then
				-- unlocked
				cm:remove_effect_bundle_from_characters_force(dance_data.lock_bundle_force, general:command_queue_index())
			else
				-- locked dance
				cm:apply_effect_bundle_to_characters_force(dance_data.lock_bundle_force, general:command_queue_index(), 0)
			end
		end
	else
		if general:is_null_interface() then
			script_error("Called UpdateGeneralDanceLock but the provided general was null!")
			return
		end

		if eternal_dance:IsGeneralAlreadyRegistered(general) == false then
			script_error("Called UpdateGeneralDanceLock but the provided general was not registered! cqi: " .. general:command_queue_index())
			return
		end
	end
end

function eternal_dance:GetCharacterWithDance(dance_key, finished_dances)
	local result  = {}
	for idx, data in ipairs(eternal_dance.dancing_characters_fatigue_data) do
		if finished_dances ~= nil and is_boolean(finished_dances) then
			if data.current_dance == dance_key and data.is_dance_finished == finished_dances then
				table.insert(result, data.general_cqi)
			end
		else
			if data.current_dance == dance_key then
				table.insert(result, data.general_cqi)
			end
		end
	end
	return result
end

function eternal_dance:UpdateTechBonuses()
	local faction = cm:get_faction(eternal_dance.faction_key)

	if faction:has_technology(eternal_dance.tech_enthusiastic_devotees_key) then
		local dance_count = 0
		for index, item in ipairs(eternal_dance.dancing_characters_fatigue_data) do
			if item.current_dance then 
				dance_count = dance_count + 1
			end
		end
		if dance_count > 0 then
			local scripted_bonus_value = cm:get_factions_bonus_value(faction, eternal_dance.devotees_per_dance_bonus_value_key)
			local bundle = cm:create_new_custom_effect_bundle(eternal_dance.devotees_per_dance_bundle_key)
			bundle:set_effect_value_by_key(eternal_dance.devotees_per_dance_effect_key, dance_count * scripted_bonus_value)
			cm:apply_custom_effect_bundle_to_faction(bundle, faction)
		elseif faction:has_effect_bundle(eternal_dance.devotees_per_dance_bundle_key) then
			cm:remove_effect_bundle(eternal_dance.devotees_per_dance_bundle_key, eternal_dance.faction_key)
		end
	end

	if faction:has_technology(eternal_dance.tech_changing_the_feet_key) then
		eternal_dance.tech_bonuses.transfer_loss_bonus = cm:get_factions_bonus_value(faction, eternal_dance.transfer_loss_bonus_value_key) / 100
	end

	if faction:has_technology(eternal_dance.tech_eternal_commitement_key) then
		eternal_dance.tech_bonuses.delay_decay = cm:get_factions_bonus_value(faction, eternal_dance.delay_decay_bonus_value_key)
		eternal_dance.tech_bonuses.dissonance_duration = cm:get_factions_bonus_value(faction, eternal_dance.dissonance_duration_bonus_value_key)

		for index, item in ipairs(eternal_dance.dancing_characters_fatigue_data) do
			item.current_fatigue_delay = eternal_dance.tech_bonuses.delay_decay
		end
	end
end

function eternal_dance:GetCharacterInitiativeSet(general, tempo_level)
	local registered_general = eternal_dance:GetRegisteredGeneral(general)
	local initiative_set 
	if tempo_level == 1 then 
		initiative_set = eternal_dance.dance_data[registered_general.current_dance].tempo_1_initiative_set
	elseif tempo_level == 2 then
		initiative_set = eternal_dance.dance_data[registered_general.current_dance].tempo_2_initiative_set
	elseif tempo_level == 3 then
		initiative_set = eternal_dance.dance_data[registered_general.current_dance].tempo_3_initiative_set
	elseif tempo_level == 4 then
		initiative_set = eternal_dance.dance_data[registered_general.current_dance].tempo_4_initiative_set
	end
	return initiative_set
end

function eternal_dance:HasThisDanceBeenCompleted(dance)
	for i, completed_dance in ipairs(eternal_dance.dance_completed_record) do
		if dance == completed_dance then 
			return true
		end
	end

	return false
end

function eternal_dance:ChooseTargetForFrenzyArmy(invasion_object, frenzy_military_force)
	local closest_enemy_military_force = frenzy_military_force:get_nearest_enemy_military_force(true, true)

	if closest_enemy_military_force and (not closest_enemy_military_force:is_null_interface()) then
		local target_general = closest_enemy_military_force:general_character()
		local target_character_cqi = target_general:command_queue_index()
 		invasion_object:set_target("CHARACTER", target_character_cqi)
		return true
	end

	-- we failed in selecting a target
	invasion_object:set_target("NONE", nil)
	return false
end

-- Update the stances effects with extra bundles when reaching tempo lvl 4.  
function eternal_dance:UpdateStanceBundles(mil_force)
	local stance = mil_force:active_stance()
	local registered_general = eternal_dance:GetRegisteredGeneral(mil_force:general_character())

	if registered_general.current_dance == "" or registered_general.current_dance == nil then
		return
	end

	local stance_bundle = eternal_dance.stances_data[stance]

	if stance_bundle == nil or stance_bundle == "" then 
		return
	end

	for key, value in dpairs(eternal_dance.stances_data) do
		if mil_force:has_effect_bundle(value.bundle_key) then
			cm:remove_effect_bundle_from_force(value.bundle_key, mil_force:command_queue_index())
		end
	end

	if eternal_dance:GetCurrentTempoLevel(mil_force) < 4 then
		return
	end

	cm:apply_effect_bundle_to_force(stance_bundle.bundle_key, mil_force:command_queue_index(), 0)
end

-- Update the shared states to be shown by UI
function eternal_dance:UpdateUISharedStates()
	local selected_character_cqi = cuim:get_char_selected_cqi()

	if not selected_character_cqi or selected_character_cqi == 0 then
		return
	end

	local general = cm:get_character_by_cqi(selected_character_cqi)
	local force = general and general:has_military_force() and general:military_force()
	if not force then
		return
	end
	local tempo_level = eternal_dance:GetCurrentTempoLevel(force)
	-- by design, the penalty duration is equal to the new tempo level
	-- but it can be reduced by tech bonuses
	local dissonance_duration = tempo_level - eternal_dance.tech_bonuses.dissonance_duration
	dissonance_duration = math.max(dissonance_duration, 0)
	local dissonance_duration_string = tostring(dissonance_duration)
	cm:set_script_state(general:family_member(), "dissonance_effect_duration_ui_shared_state", dissonance_duration_string)

	local transferred_tempo = 1 - eternal_dance.dance_switching_penalties [tempo_level]
	local transferred_tempo_percentage = math.round(transferred_tempo * 100)
	local transferred_tempo_percentage_string = tostring(transferred_tempo_percentage)
	cm:set_script_state(general:family_member(), "transferred_tempo_percentage_ui_shared_state", transferred_tempo_percentage_string)
end

--------------------------------------------------------------
---------------------------- CAI -----------------------------
--------------------------------------------------------------
function eternal_dance:CAI_ChoseDance(character)
	if not character or character:is_null_interface() then
		return 
	end
	local registered_general = eternal_dance:GetRegisteredGeneral(character)
	if not registered_general.current_dance then
		local available_dances = {}
		for id, dance in dpairs(eternal_dance.dance_data) do
			if #eternal_dance.dance_completed_record >= dance.num_dance_to_complete then
				table.insert(available_dances, #available_dances + 1, id)
			end
		end
		local rand = cm:random_number(#available_dances, 1)
		cm:apply_add_initiative_set_category_preset(available_dances[rand], registered_general.general_cqi, true)
		registered_general.current_dance = available_dances[rand]
	end
	if registered_general.current_fatigue_level > 0 then
		eternal_dance:CAI_ChoseTempoInitiative(character)
	end
end

function eternal_dance:CAI_ChoseTempoInitiative(character)
	if not character or character:is_null_interface() then
		return 
	end
	local registered_general = eternal_dance:GetRegisteredGeneral(character)
	local init_set = character:character_details():lookup_character_initiative_set_by_key(eternal_dance:GetCharacterInitiativeSet(character, registered_general.current_fatigue_level))
	
	if init_set:active_initiatives():num_items() > 0 then
		return
	end
	
	local all_init_in_set = init_set:all_initiatives()
	local selected_init = all_init_in_set:item_at(cm:random_number(all_init_in_set:num_items() - 1, 0))
	cm:toggle_initiative_active(init_set, selected_init:record_key(), true)
	eternal_dance:CAI_UpdateSharedStateValues(character)
end

function eternal_dance:CAI_UpdateSharedStateValues(character)
	local registered_general = eternal_dance:GetRegisteredGeneral(character)
	local init_set = character:character_details():lookup_character_initiative_set_by_key(eternal_dance:GetCharacterInitiativeSet(character, 4))
	
	if init_set:active_initiatives():num_items() <= 0 then
		return
	end

	local masque_of_attraction_unlocked = false 
	local masque_of_destruction_unlocked = false 
	local masque_of_displacement_unlocked = false 
	local masque_of_reforging_unlocked = false 

	for i = 0, init_set:active_initiatives():num_items() - 1 do
		if init_set:active_initiatives():item_at(i):record_key() == eternal_dance.final_rituals.masque_of_attraction_step then
			masque_of_attraction_unlocked = true
		elseif init_set:active_initiatives():item_at(i):record_key() == eternal_dance.final_rituals.masque_of_destruction_step then
			masque_of_destruction_unlocked = true
		elseif init_set:active_initiatives():item_at(i):record_key() == eternal_dance.final_rituals.masque_of_displacement_step then
			masque_of_displacement_unlocked = true
		elseif init_set:active_initiatives():item_at(i):record_key() == eternal_dance.final_rituals.masque_of_reforging_step then
			masque_of_reforging_unlocked = true
		end
	end

	cm:set_script_state("masque_of_attraction_unlocked", masque_of_attraction_unlocked)
	cm:set_script_state("masque_of_destruction_unlocked", masque_of_destruction_unlocked)
	cm:set_script_state("masque_of_displacement_unlocked", masque_of_displacement_unlocked)
	cm:set_script_state("masque_of_reforging_unlocked", masque_of_reforging_unlocked)
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("dancing_characters_fatigue_data", eternal_dance.dancing_characters_fatigue_data, context)
		cm:save_named_value("dance_completed_record", eternal_dance.dance_completed_record, context)
		cm:save_named_value("tech_bonuses", eternal_dance.tech_bonuses, context)
		cm:save_named_value("characters_reforging", eternal_dance.characters_reforging, context)
		cm:save_named_value("masque_of_attraction_invasion_keys", eternal_dance.masque_of_attraction_invasion_keys, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		eternal_dance.dancing_characters_fatigue_data = cm:load_named_value("dancing_characters_fatigue_data", eternal_dance.dancing_characters_fatigue_data, context)
		eternal_dance.dance_completed_record = cm:load_named_value("dance_completed_record", eternal_dance.dance_completed_record, context)
		eternal_dance.tech_bonuses = cm:load_named_value("tech_bonuses", eternal_dance.tech_bonuses, context)
		eternal_dance.characters_reforging = cm:load_named_value("characters_reforging", eternal_dance.characters_reforging, context)
		eternal_dance.masque_of_attraction_invasion_keys = cm:load_named_value("masque_of_attraction_invasion_keys", eternal_dance.masque_of_attraction_invasion_keys, context)
		-- save migration
		eternal_dance.masque_of_attraction_invasion_keys = eternal_dance.masque_of_attraction_invasion_keys or {}
	end
)

--------------------------------------------------------------
--------------------------- DEBUG ----------------------------
--------------------------------------------------------------

function eternal_dance:ModifyForceTempo(amount)
	local selected_char = cuim:get_char_selected_cqi() 
	if selected_char == -1 then
		return
	end
	local mil_force = cm:get_character_by_cqi(selected_char):military_force()
	local resource = mil_force:pooled_resource_manager():resource(eternal_dance.pooled_resource_key)
	if not resource then
		return
	end
	cm:pooled_resource_factor_transaction(resource, eternal_dance.pooled_resource_factor_key_fatigue, amount)
end