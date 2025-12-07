Seductive_Influence = {
	-- POOLED RESOURCE CONSTANTS
	SI_resource_key = "wh3_main_sla_seductive_influence",
	SI_resource_factor_diplomacy = "diplomacy_with_slaanesh",
	SI_resource_factor_battles = "battles_against_slaanesh",
	SI_vassal_unlock_threshold = "wh3_main_bundle_seductive_influence_max", -- gaining this bundle fires the vassalisation available incident

	--- POOLED RESOURCE VALUES
	SI_on_signing_treaty = 20,		-- immediate amount granted from signing any deal with Slaanesh
	SI_per_gift = 100,				-- gift amount divided by this value is the immediate amount granted by any gift accepted by Slaanesh
	SI_per_gift_max = 50,			-- maximum amount of SI granted for a gift
	SI_per_active_treaty = 5,		-- per turn SI given for having treaties with Slaanesh
	SI_per_battle = 10,				-- immediate amount granted from any battle with Slaanesh
	SI_capacity_per_region = 10,	-- amount SI capacity goes up per region owned
	SI_resistance_per_region = -1,	-- amount SI capacity goes down per turn per region owned

	--RITUAL CONSTANTS
	force_vassal_ritual_category = "FORCE_VASSAL",

	---SUBCULTURE CONSTANTS
	seductive_faction_set_key = "wh3_dcl27_seductive_influence", -- DB faction set that contains the factions with access to this feature (some Slaaneshi culture factions plus any others we want (e.g. Azazel, Sigvald))
	seductive_factions = {}, -- populated automatically on startup as a model list
	seducible_factions_set_key = "slaanesh_seducible_factions",
	seducible_factions = {},-- populated automatically on startup as a model list

	-- FACTION KEYS - SI Available factions only
	nkari_faction_key = "wh3_main_sla_seducers_of_slaanesh",

	-- RITUAL KEY
	nkari_convert_lord = {
		ritual_key = "wh3_dlc27_convert_lord",
		percent_army_to_lose = 25,
		incident_key = "wh3_dlc27_incident_nkari_convert_lord",
	},
}

function Seductive_Influence:initialise()
	self.seductive_factions = cm:model():world():lookup_factions_from_faction_set(self.seductive_faction_set_key)
	self.seducible_factions = cm:model():world():lookup_factions_from_faction_set(self.seducible_factions_set_key)

	self:setup_faction_turn_start_listeners()
	self:setup_resource_threshold_listeners()
	self:setup_diplomatic_action_listeners()
	self:setup_vassalise_ritual_listener()
	self:setup_battle_and_occupation_listeners()
end



function Seductive_Influence:setup_faction_turn_start_listeners()

	for k, faction_interface in model_pairs(self.seducible_factions) do
		local faction_key = faction_interface:name()
		cm:add_faction_turn_start_listener_by_name(
			"seducible_faction_turn_start_" .. faction_key,
			faction_key,
			function(context)
				self:apply_bonus_resistance_from_regions(context:faction())
			end,
			true
		);
	end

	for k, faction_interface in model_pairs(self.seductive_factions) do
		local faction_key = faction_interface:name()
		cm:add_faction_turn_start_listener_by_name(
			"seductive_faction_turn_start_" .. faction_key,
			faction_key,
			function(context)
				self:apply_regular_diplomatic_seduction(context:faction())
			end,
			true
		);
	end


end

function Seductive_Influence:setup_resource_threshold_listeners()
	core:add_listener(
		"slaanesh_seductive_influence_threshold_triggers",
		"PooledResourceEffectChangedEvent",
		function(context)
			return context:resource():key() == self.SI_resource_key
		end,
		function(context)
			local faction = context:faction();
			local faction_key = faction:name()
			local new_effect = context:new_effect()

			if new_effect == self.SI_vassal_unlock_threshold and not faction:is_vassal() then
				self:fire_vassal_available_incident(faction_key)
			end
		end,
		true
	)

	core:add_listener(
		"nkari_convert_lord_ritual",
		"RitualCompletedEvent",
		function(context)
			return context:ritual():ritual_key() == self.nkari_convert_lord.ritual_key
		end,
		function(context)
			local tf = context:ritual_target_force()
			local tf_character = tf:general_character()
	
			if not tf_character:is_null_interface() then
				local tf_unit_list = tf:unit_list()
				local tf_units_number = tf_unit_list:num_items()
				local tf_units_to_lose = math.max(0, math.ceil(tf_units_number * (self.nkari_convert_lord.percent_army_to_lose / 100) ) )
				local unit_list = nil

				if tf_units_to_lose ~= 0 then
					local tf_unit_list_cqi = {}

					for i = 1, tf_units_number - 1 do
						local unit = tf_unit_list:item_at(i)
						if unit:unit_caste() ~= "hero" or unit:unit_caste() ~= "lord" then
							table.insert(tf_unit_list_cqi, unit:command_queue_index())
						end
					end

					if #tf_unit_list_cqi ~= 0 then
						cm:shuffle_table(tf_unit_list_cqi)

						for i = 1, math.min(tf_units_to_lose, #tf_unit_list_cqi) do
							cm:remove_unit_by_cqi(tf_unit_list_cqi[i])
						end

						random_army_manager:remove_force("converted_lord_army")
						random_army_manager:new_force("converted_lord_army")
						random_army_manager:add_unit("converted_lord_army", "wh3_main_sla_inf_marauders_0", 10)
						random_army_manager:add_unit("converted_lord_army", "wh3_main_sla_inf_marauders_1", 10)
						random_army_manager:add_unit("converted_lord_army", "wh3_main_sla_inf_marauders_2", 10)
						random_army_manager:add_unit("converted_lord_army", "wh3_dlc20_chs_inf_chaos_warriors_msla_hellscourges", 5)

						unit_list = random_army_manager:generate_force("converted_lord_army", tf_units_to_lose, false)
					end
				end
				
				local nkari_character = context:performing_faction():faction_leader()
				local x, y = cm:find_valid_spawn_location_for_character_from_character(self.nkari_faction_key, cm:char_lookup_str(nkari_character), false, 5)

				if x > 0 then
					cm:create_force_with_general(
						self.nkari_faction_key,
						unit_list,
						cm:model():world():region_manager():region_list():item_at(1):name(),
						x,
						y,
						"general",
						"wh3_dlc20_chs_lord_msla",
						"",
						"",
						"",
						"",
						false,
						function(cqi)
							cm:apply_effect_bundle_to_characters_force("wh3_dlc27_bundle_force_converted_lord_nkari", cqi, 0);
						end
					);
				end

				local tf_character_cqi = tf_character:command_queue_index()
				cm:trigger_incident_with_targets(cm:get_faction(self.nkari_faction_key):command_queue_index(), self.nkari_convert_lord.incident_key, 0, 0, tf_character_cqi, 0, 0, 0)
				cm:kill_character(tf_character_cqi, false)
			end
		end,
		true
	)
end

function Seductive_Influence:setup_diplomatic_action_listeners()
	core:add_listener(
		"slaanesh_diplomacy_event_positive",
		"PositiveDiplomaticEvent",
		function(context)
			local slaanesh_involved = self:faction_is_slaanesh(context:recipient()) or self:faction_is_slaanesh(context:proposer())
			local seducible_faction_involved = self:faction_is_seducible(context:recipient()) or self:faction_is_seducible(context:proposer())
			return slaanesh_involved and seducible_faction_involved
		end,
		function(context)
			local seducible_faction = context:recipient()
			if self:faction_is_slaanesh(context:recipient()) then
				seducible_faction = context:proposer()
			end

			local resource_change = self.SI_on_signing_treaty

			if context:is_vassalage() then 
				resource_change = 9999
			end 

			if context:is_state_gift() then
				local gift_amount = context:state_gift_amount()
				
				if gift_amount >= 500 then
					resource_change = math.min(math.round(gift_amount / self.SI_per_gift), self.SI_per_gift_max)
				else
					resource_change = 0
				end
			end
			
			if resource_change > 0 then
				cm:faction_add_pooled_resource(seducible_faction:name(), self.SI_resource_key, self.SI_resource_factor_diplomacy, resource_change)
			end
		end,
		true
	)
end

function Seductive_Influence:setup_vassalise_ritual_listener()
	core:add_listener(
		"slaanesh_forced_vassal_ritual",
		"RitualCompletedEvent",
		function(context)
			return context:ritual():ritual_category() == self.force_vassal_ritual_category
		end,
		function(context)
			local performing_faction = context:performing_faction()
			local target_faction = context:ritual_target_faction()

			cm:force_diplomacy("faction:"..performing_faction:name(), "faction:"..target_faction:name(), "vassal", true, true, false)

			cm:force_make_vassal(performing_faction:name(), target_faction:name(), true)

			local human_factions = cm:get_human_factions()
			for i = 1, #human_factions do
				local incident_faction = cm:get_faction(human_factions[i])
				cm:trigger_incident_with_targets(
					incident_faction:command_queue_index(), 
					"wh3_main_incident_sla_faction_force_vassalised", 
					target_faction:command_queue_index(),
					0,
					0,
					0,
					0,
					0
				)
			end
		end,
		true
	)
end


function Seductive_Influence:setup_battle_and_occupation_listeners()
	core:add_listener(
		"slaanesh_post_battle_pooled_resource",
		"CharacterCompletedBattle",
		function(context)
			return cm:pending_battle_cache_faction_set_member_is_involved(self.seductive_faction_set_key) 
		end,
		function(context)
			local num_attackers = cm:pending_battle_cache_num_attackers()
			local num_defenders =  cm:pending_battle_cache_num_defenders()
			
			for i = 1, num_attackers  do
				local char_cqi, mf_cqi, faction_key = cm:pending_battle_cache_get_attacker(i)
				local faction_interface = cm:get_faction(faction_key)
				if self:faction_is_seducible(faction_interface) then
					cm:faction_add_pooled_resource(faction_key, self.SI_resource_key, self.SI_resource_factor_battles, self.SI_per_battle)
				end
			end

			for i = 1, num_defenders do
				local char_cqi, mf_cqi, faction_key = cm:pending_battle_cache_get_defender(i)
				local faction_interface = cm:get_faction(faction_key)
				if self:faction_is_seducible(faction_interface) then
					cm:faction_add_pooled_resource(faction_key, self.SI_resource_key, self.SI_resource_factor_battles, self.SI_per_battle)
				end
			end
		end,
		true
	)

	core:add_listener(
		"slaanesh_vassal_liberated",
		"FactionBecomesLiberationVassal",
		function(context)
			return self:faction_is_slaanesh(context:liberating_character():faction())
		end,
		function(context)
			local liberated_faction= context:faction()
		
			if self:faction_is_seducible(liberated_faction) then
				cm:faction_add_pooled_resource(liberated_faction:name(), self.SI_resource_key, "other", 1000)
			end
		end,
		true
	);
end

function Seductive_Influence:faction_is_seducible(faction_interface)
	return is_faction(faction_interface) and not faction_interface:is_null_interface() and not faction_interface:pooled_resource_manager():resource(self.SI_resource_key):is_null_interface()
end

function Seductive_Influence:faction_is_slaanesh(faction_interface)
	return is_faction(faction_interface) and not faction_interface:is_null_interface() and faction_interface:is_contained_in_faction_set(self.seductive_faction_set_key)
end


function Seductive_Influence:apply_bonus_resistance_from_regions(faction_interface)
	local region_count = faction_interface:region_list():num_items()
	local resistance_bundle = cm:create_new_custom_effect_bundle("wh3_main_bundle_seductive_influence_capacity_modifier")

	resistance_bundle:add_effect("wh3_main_effect_pooled_resource_seductive_influence_capacity_mod", "faction_to_faction_own_unseen", region_count*self.SI_capacity_per_region)
	resistance_bundle:add_effect("wh3_main_effect_pooled_resource_seductive_influence_resistance", "faction_to_faction_own_unseen", region_count*self.SI_resistance_per_region)
	
	resistance_bundle:set_duration(0);
	cm:apply_custom_effect_bundle_to_faction(resistance_bundle, faction_interface);
end

function Seductive_Influence:apply_regular_diplomatic_seduction(faction_interface)
	local treaty_partners_lists = {
		faction_interface:factions_non_aggression_pact_with(),
		faction_interface:factions_trading_with(),
		faction_interface:factions_military_allies_with(),
		faction_interface:factions_defensive_allies_with(),
		faction_interface:vassals()
	}

	for index, partners in ipairs(treaty_partners_lists) do
		if partners:num_items() > 0 then
			for i, faction in model_pairs(partners) do
				if self:faction_is_seducible(faction) then
					cm:faction_add_pooled_resource(faction:name(), self.SI_resource_key, self.SI_resource_factor_diplomacy, self.SI_per_active_treaty)
				end
			end
		end
	end
end

function Seductive_Influence:fire_vassal_available_incident(faction_key)
	local human_factions = cm:get_human_factions()

	for i = 1, #human_factions do
		local incident_faction = cm:get_faction(human_factions[i])

		if not self:faction_is_slaanesh(incident_faction) then
			return
		end

		local potential_vassal_cqi = cm:get_faction(faction_key):command_queue_index()

		local factions_met =  incident_faction:factions_met();

		local target_met = false

		for k, met_faction in model_pairs(factions_met) do
			if met_faction:name() == faction_key then
				target_met = true
				break
			end
		end

		if target_met then
			cm:trigger_incident_with_targets(
				incident_faction:command_queue_index(),
				"wh3_main_incident_sla_faction_available_for_vassalisation",
				potential_vassal_cqi,
				0,
				0,
				0,
				0,
				0
			);
		end
	end
end