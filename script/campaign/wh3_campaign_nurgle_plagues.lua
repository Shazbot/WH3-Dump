nurgle_plagues = {

	symptoms_list = {		
		"wh3_dlc25_nur_battle_2",
		"wh3_dlc25_nur_settlement_4",
		"wh3_dlc25_nur_force_2",
		"wh3_dlc25_nur_battle_7",
		"wh3_dlc25_nur_battle_6",
		"wh3_dlc25_nur_battle_1",
		"wh3_dlc25_nur_settlement_5",
		"wh3_dlc25_nur_force_3",
		"wh3_dlc25_nur_battle_4",
		"wh3_dlc25_nur_force_1",
		"wh3_dlc25_nur_force_6",
		"wh3_dlc25_nur_settlement_1",
		"wh3_dlc25_nur_settlement_2",
		"wh3_dlc25_nur_battle_5",
		"wh3_dlc25_nur_force_5",
		"wh3_dlc25_nur_settlement_3",
		"wh3_dlc25_nur_force_4",
		"wh3_dlc25_nur_battle_3",		
	},

	kugath_subtype_key = "wh3_main_nur_kugath",
	kugath_faction = "wh3_main_nur_poxmakers_of_nurgle",
	epidemius_faction = "wh3_dlc25_nur_epidemius",
	epidemius_pooled_resource = "nur_epidemius_tally_of_pestilence",
	epidemius_pooled_resource_factor_forces = "plague_tally_forces",
	epidemius_pooled_resource_factor_settlements = "plague_tally_settlements",
	festus_faction = "wh3_dlc20_chs_festus",
	festus_symptom_key_replace = {"wh3_dlc25_nur_force_5", "wh3_dlc25_nur_settlement_3"},
	festus_symptom_key_append = "_festus",

	hidden_force_effect = "wh3_dlc25_nur_base_hidden_epidemius_force",
	hidden_region_effect = "wh3_dlc25_nur_base_hidden_epidemius_region",
	force_bundle_list = {
		"wh3_dlc25_epidemius_plague_bundle_1_scripted",
		"wh3_dlc25_epidemius_plague_bundle_2_scripted",
		"wh3_dlc25_epidemius_plague_bundle_3_scripted",
		"wh3_dlc25_epidemius_plague_bundle_4_scripted",
	},

	
	plague_faction_info = {
		["wh3_main_nur_poxmakers_of_nurgle"] = {max_blessed_symptoms = 2, current_symptoms_list = {}, plague_creation_counter = 3},
		["wh3_dlc25_nur_tamurkhan"] = {max_blessed_symptoms = 1, current_symptoms_list = {}, plague_creation_counter = 3},
		["wh3_dlc25_nur_epidemius"] = {max_blessed_symptoms = 1, current_symptoms_list = {}, plague_creation_counter = 3},
		["wh3_dlc20_chs_festus"] = {max_blessed_symptoms = 1, current_symptoms_list = {}, plague_creation_counter = 3},
	},

	starting_symptom_key = "wh3_dlc25_nur_force_3",
	starting_blessed_symptom_key = "wh3_dlc25_nur_settlement_1",
	kugath_additional_blessed_symptom_key = "wh3_dlc25_nur_force_6",
	blessed_tech = "wh3_main_tech_nur_growth_21",
	plague_creation_base_counter = 3,
	nurgle_plague_faction_set = "plague_effect_set_nurgle_positive",

	plague_button_unlock = {
		["wh3_main_nur_poxmakers_of_nurgle"] = {button_locked = true, infections_gained = 0, infections_end_of_last_turn = 200},
		["wh3_dlc25_nur_tamurkhan"] = {button_locked = true, infections_gained = 0, infections_end_of_last_turn = 200},
		["wh3_dlc25_nur_epidemius"] = {button_locked = true, infections_gained = 0, infections_end_of_last_turn = 200},
		["wh3_dlc20_chs_festus"] = {button_locked = true, infections_gained = 0, infections_end_of_last_turn = 200},
	},

	pr_key = "wh3_main_nur_infections",
	pr_required_to_unlock = 200,
	plagues_unlocked_incident = "wh3_dlc25_nur_plagues_feature_unlocked",
	disable_plagues_key = "disable_nurgle_plagues_button",

}


function nurgle_plagues:initialise()

	local faction_list = cm:model():world():faction_list()
	--if its a new game select the starting plague component to be unlocked
	if cm:is_new_game() then
		for i = 0, faction_list:num_items() - 1 do
			local faction = faction_list:item_at(i)
				
			if faction:is_contained_in_faction_set(self.nurgle_plague_faction_set) then			
				local pfi = self.plague_faction_info	
				local faction_name = faction:name()
				local faction_info = pfi[faction_name]
				if faction_info ~= nil then
					faction_info.current_symptoms_list = self:copy_symptom_table()

					if faction_name == self.festus_faction then
						self:festus_symptom_swap(faction_info)
					end

					if faction:is_human() then
						self:toggle_plagues_button(faction, self.plague_button_unlock[faction:name()], true, false)
					end
					
					common.set_context_value("random_plague_component_list_" .. faction_name, faction_info.current_symptoms_list)
					common.set_context_value("random_plague_creation_count_" .. faction_name, faction_info.plague_creation_counter)
					cm:set_plague_component_state(faction, self.starting_symptom_key, "UNLOCKED", true)
					cm:set_plague_component_state(faction, self.starting_blessed_symptom_key, "BLESSED", true)
					if faction_name == self.kugath_faction then
						cm:set_plague_component_state(faction, self.kugath_additional_blessed_symptom_key, "BLESSED", true)
					end
				end
			end
		end
	else
		for i = 0, faction_list:num_items() - 1 do
			local faction = faction_list:item_at(i)
				
			if faction:is_contained_in_faction_set(self.nurgle_plague_faction_set) then				
				local pfi = self.plague_faction_info
				local pbu = self.plague_button_unlock	
				local faction_name = faction:name()	
				local faction_info = pfi[faction_name]
				local unlock_info = pbu[faction_name]
				if faction_info ~= nil then
					common.set_context_value("random_plague_component_list_" .. faction_name, faction_info.current_symptoms_list)
					common.set_context_value("random_plague_creation_count_" .. faction_name, faction_info.plague_creation_counter)
					common.set_context_value("unlock_plague_button_" .. faction_name, unlock_info.infections_gained)

					-- ensure the plague button is unlocked
					if faction:is_human() and unlock_info.infections_gained >= self.pr_required_to_unlock then
						self:toggle_plagues_button(faction, unlock_info, false, false)
					end
				end
			end
		end
	end

	self:plague_listeners()

end

function nurgle_plagues:plague_listeners()

	-- add ap when plague cultist spawns
	core:add_listener(
		"Plagues_CultistCreated",
		"CharacterCreated",
		function(context)
			return context:character():character_subtype("wh3_main_nur_cultist_plague_ritual")
		end,
		function(context)
			local character = cm:char_lookup_str(context:character():cqi())
			cm:callback(function() cm:replenish_action_points(character) end, 0.2)
		end,
		true
	)

	core:add_listener(
		"Plagues_AchievementListener",
		"FactionTurnStart",
		function(context)
			local faction = context:faction()
			return faction:is_contained_in_faction_set(self.nurgle_plague_faction_set) and faction:is_human()	
		end,
		function(context)
			local all_unlocked = true
			local component_list = context:faction():plagues():plague_component_list()
			--loop through all components to see if any are locked
			for i = 0, component_list:num_items() -1 do
				local symptom = component_list:item_at(i)
				if not symptom:has_state("UNLOCKED") and not string.find(symptom:key(), "mutation") then
					--not all symptoms unlocked yet
					all_unlocked = false
					break
				end
			end
			if all_unlocked then
				core:trigger_event("ScriptEvent_AllPlagueComponentsUnlocked", context)
			end
		end,
		true
	)

	--remove blessed state on any symptoms spawned with a plague cultist
	core:add_listener(
		"Plagues_CultistCreated",
		"AgentPlagueDataCreatedEvent",
		function(context)
			return context:agent():character():character_subtype("wh3_main_nur_cultist_plague_ritual")
		end,
		function(context)
			local plague_components = context:agent():character():try_get_agent_plague_components()
			self:remove_blessed_symptom(plague_components)
		end,
		true
	)

	core:add_listener(
		"Plagues_PlagueCreationCounter",
		"RitualStartedEvent",
		function(context)			
			return context:performing_faction():is_human() and string.find(context:ritual():ritual_key(), "wh3_main_ritual_nur_plague_") 
		end,
		function(context)
			local faction = context:performing_faction()
			local pfi = self.plague_faction_info	
			local faction_info = pfi[faction:name()]

			faction_info.plague_creation_counter = faction_info.plague_creation_counter - 1

			if faction_info.plague_creation_counter <= 0 then
				--adding a callback as RitualStartedEvent triggers before MilitaryForceInfectionEvent or RegionInfectionEvent 
				--this results in blessed symptoms not being granted if its part of the final Plague before reset positions and blessed symptoms		
				cm:callback(function() self:randomise_symptom_location(faction) end, 0.5)
			end

			common.set_context_value("random_plague_creation_count_" .. faction:name(), faction_info.plague_creation_counter)
		end,
		true
	)

	core:add_listener(
		"Plagues_TrackFactionTurnStart",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == self.epidemius_faction
		end,
		function (context)
			self:count_plagues_on_non_nurgle_targets()	
		end,
		true
	)

	core:add_listener(
		"Plagues_AdditionalMaxBlessedCharacterRankUp",
		"CharacterRankUp",
		function(context)
			local character = context:character()
			if character:character_subtype(self.kugath_subtype_key) and character:faction():name() == self.kugath_faction then
				local ranks_gained = context:ranks_gained()
				local rank = character:rank()
				return math.floor(rank / 10) ~= math.floor((rank - ranks_gained) / 10)
			end
		end,
		function()
			local pfi = self.plague_faction_info	
			local faction_info = pfi[self.kugath_faction]
			faction_info.max_blessed_symptoms = faction_info.max_blessed_symptoms + 1
		end,
		true
	)

	core:add_listener(
		"Plagues_TrackBlessedSymptom_Region",
		"RegionInfectionEvent",
		function(context)
			return context:faction():is_human()
		end,
		function(context)
			--check that the plague has just been created and wasnt spread by an agent
			if context:is_creation() and context:spreading_agent() ~= nil then 
				self:remove_blessed_symptom(context:plague():plague_components())	
			else
				core:trigger_custom_event("ScriptEventPlagueSpreading", {faction = context:faction()})
			end	
			if context:plague():creator_faction():name() == self.epidemius_faction then
				self:count_plagues_on_non_nurgle_targets()	
			end			
		end,
		true
	)

	core:add_listener(
		"Plagues_TrackBlessedSymptom_Force",
		"MilitaryForceInfectionEvent",
		function(context)
			return context:faction():is_human()
		end,
		function(context)
			--check that the plague has just been created and wasnt spread by an agent
			if context:is_creation() and context:spreading_agent() ~= nil then 
				self:remove_blessed_symptom(context:plague():plague_components())	
			else
				core:trigger_custom_event("ScriptEventPlagueSpreading", {faction = context:faction()})
			end
			if context:plague():creator_faction():name() == self.epidemius_faction then
				self:count_plagues_on_non_nurgle_targets()	
			end
		end,
		true
	)

	core:add_listener(
		"Plagues_TrackPendingBattle",
		"PendingBattle",
		function()
			return cm:pending_battle_cache_human_is_involved() and cm:pending_battle_cache_faction_is_involved(self.epidemius_faction)
		end,
		function()
			self:count_plagues_on_non_nurgle_targets()	
		end,
		true
	)

	core:add_listener(
		"Plagues_TrackBattleCompleted",
		"BattleCompleted",
		function()
			return cm:model():pending_battle():has_been_fought() and cm:pending_battle_cache_human_is_involved() and cm:pending_battle_cache_faction_is_involved(self.epidemius_faction)
		end,
		function()
			self:count_plagues_on_non_nurgle_targets()	
		end,
		true
	)

	core:add_listener(
		"Plagues_AdditionalMaxBlessedTech",
		"ResearchCompleted",
		function(context)
			local technology = context:technology()
			local faction = context:faction()

			if faction:is_contained_in_faction_set(self.nurgle_plague_faction_set) then	
				return faction:is_human() and technology == self.blessed_tech
			end
			return false
		end,
		function(context)
			local faction = context:faction()
			local pfi = self.plague_faction_info	
			local faction_info = pfi[faction:name()]
			faction_info.max_blessed_symptoms = faction_info.max_blessed_symptoms + 1

		end,
		true
	)

	core:add_listener(
		"Plagues_PooledResourceChanged",
		"PooledResourceChanged",
		function(context)
			local faction = context:faction()
			if not faction:is_null_interface() then
				if faction:is_contained_in_faction_set(self.nurgle_plague_faction_set) and faction:is_human() then	
					local pbu = self.plague_button_unlock	
					local unlock_info = pbu[faction:name()]
					
					return unlock_info.button_locked
				end
			end
			return false
		end,
		function(context)
			local faction = context:faction()
			local pbu = self.plague_button_unlock	
			local unlock_info = pbu[faction:name()]
			local pr_changed = context:resource():key()
			local pr = faction:pooled_resource_manager():resource(self.pr_key)
			local amount = context:amount()
			local factor = context:factor():key()

			if pr_changed == self.pr_key then
				local amount_changed = context:amount()
				if amount_changed > 0 then
					unlock_info.infections_gained = unlock_info.infections_gained + amount_changed
				end
			end
			if unlock_info.infections_gained >= self.pr_required_to_unlock then
				if factor ~= "buildings" and amount == 200 then
					self:toggle_plagues_button(faction, unlock_info, false, true)
				end 				
			end
			common.set_context_value("unlock_plague_button_" .. faction:name(), unlock_info.infections_gained)
		end,
		true
	)

	core:add_listener(
		"Plagues_PooledResourceFactionTurnStart",
		"FactionTurnStart",
		function(context)
			local faction = context:faction()
			if not faction:is_null_interface() then
				if faction:is_contained_in_faction_set(self.nurgle_plague_faction_set) and faction:is_human() then	
					local pbu = self.plague_button_unlock	
					local unlock_info = pbu[faction:name()]
					
					return unlock_info.button_locked
				end
			end
			return false
		end,
		function(context)
			local faction = context:faction()
			local pbu = self.plague_button_unlock	
			local unlock_info = pbu[faction:name()]

			local pr_value = faction:pooled_resource_manager():resource(self.pr_key):value()
			
			if pr_value > unlock_info.infections_end_of_last_turn then
				local amount = pr_value - unlock_info.infections_end_of_last_turn
				unlock_info.infections_gained = unlock_info.infections_gained + amount
			end			
			if unlock_info.infections_gained >= self.pr_required_to_unlock then
				self:toggle_plagues_button(faction, unlock_info, false, true)				
			end
			common.set_context_value("unlock_plague_button_" .. faction:name(), unlock_info.infections_gained)
		end,
		true
	)

	core:add_listener(
		"Plagues_PooledResourceFactionTurnEnd",
		"FactionTurnEnd",
		function(context)
			local faction = context:faction()
			if not faction:is_null_interface() then
				if faction:is_contained_in_faction_set(self.nurgle_plague_faction_set) and faction:is_human() then	
					local pbu = self.plague_button_unlock	
					local unlock_info = pbu[faction:name()]
					
					return unlock_info.button_locked
				end
			end
			return false
		end,
		function(context)
			local faction = context:faction()
			local pbu = self.plague_button_unlock	
			local unlock_info = pbu[faction:name()]

			unlock_info.infections_end_of_last_turn = faction:pooled_resource_manager():resource(self.pr_key):value()
		end,
		true
	)

end

function nurgle_plagues:add_blessed_symptoms(faction)

	local component_list = faction:plagues():plague_component_list()
	local blessed_list = {}
	
	--reset blessed state for all symptoms
	for i = 0, component_list:num_items() -1 do
		local symptom = component_list:item_at(i)
		symptom:set_state("BLESSED", false)
	end

	--create list of symptoms that could be blessed
	for i = 0, component_list:num_items() -1 do
		local symptom = component_list:item_at(i)
		--remove any mutations are these can not be blessed
		if not string.find(symptom:key(), "mutation") then
			--add any valid plague_component key to list
			table.insert(blessed_list, symptom)
		end
	end

	local pfi = self.plague_faction_info	
	local faction_info = pfi[faction:name()]		

	
	--loop for max blessed symptoms
	for i = 1, faction_info.max_blessed_symptoms do
		if #blessed_list > 0 then
			local symptom = blessed_list[cm:random_number(#blessed_list)]
			for i, v in ipairs(blessed_list) do
				if v == symptom then
					table.remove(blessed_list, i)
					break
				end
			end
			symptom:set_state("BLESSED", true)
		end
	end

end

function nurgle_plagues:remove_blessed_symptom(component_list)
	
	for i = 0, component_list:num_items() -1 do
		local symptom = component_list:item_at(i)
		if symptom:has_state("BLESSED") then
			symptom:set_state("BLESSED", false)
		end
	end	
end

function nurgle_plagues:randomise_symptom_location(faction)

	local pfi = self.plague_faction_info	
	local faction_name = faction:name()
	local faction_info = pfi[faction_name]
	local symptom_list = self:copy_symptom_table()

	for i = #symptom_list, 2, -1 do
		local j = cm:random_number(i)
		symptom_list[i], symptom_list[j] = symptom_list[j], symptom_list[i]
	end
	
	faction_info.current_symptoms_list = symptom_list

	if faction_name == self.festus_faction then
		self:festus_symptom_swap(faction_info)
	end
	
	common.set_context_value("random_plague_component_list_" .. faction_name, symptom_list)

	faction_info.plague_creation_counter = self.plague_creation_base_counter
	common.set_context_value("random_plague_creation_count_" .. faction_name, faction_info.plague_creation_counter)
	self:add_blessed_symptoms(faction)
end

function nurgle_plagues:count_plagues_on_non_nurgle_targets()
	
	local plague_count_armies = 0
	local plague_count_settlements = 0
	local non_nurgle_forces_plagued = {}
	
	local faction_list = cm:model():world():faction_list()
	for i = 0, faction_list:num_items() - 1 do
		local force_list = faction_list:item_at(i):military_force_list()
		local region_list = faction_list:item_at(i):region_list()
		if not region_list:is_empty() then 
			for j = 0, region_list:num_items() -1 do
				local region = region_list:item_at(j)
				local region_garrison = region:garrison_residence()
				local plague = region:get_plague_if_infected()
				if not plague:is_null_interface() then
					if region:has_effect_bundle(self.hidden_region_effect) and plague:creator_faction():name() == self.epidemius_faction then
						plague_count_settlements = plague_count_settlements + 1
						table.insert(non_nurgle_forces_plagued, region_garrison:command_queue_index())
					end
				end
			end
		end
		if not force_list:is_empty() then
			for j = 0, force_list:num_items() - 1 do
				local force = force_list:item_at(j)
				local plague = force:get_plague_if_infected()
				if not plague:is_null_interface() then
					if force:has_effect_bundle(self.hidden_force_effect) and plague:creator_faction():name() == self.epidemius_faction then
						plague_count_armies = plague_count_armies + 1
						table.insert(non_nurgle_forces_plagued, force:command_queue_index())
					end
				end
			end
		end
	end
	local combined_plague_count = plague_count_armies + plague_count_settlements

	cm:faction_add_pooled_resource(self.epidemius_faction, self.epidemius_pooled_resource, self.epidemius_pooled_resource_factor_forces, -99999)		
	cm:faction_add_pooled_resource(self.epidemius_faction, self.epidemius_pooled_resource, self.epidemius_pooled_resource_factor_settlements, -99999)		
	self:apply_effect_bundles_to_non_nurgle_targets(combined_plague_count, non_nurgle_forces_plagued)		
	cm:faction_add_pooled_resource(self.epidemius_faction, self.epidemius_pooled_resource, self.epidemius_pooled_resource_factor_forces, plague_count_armies)
	cm:faction_add_pooled_resource(self.epidemius_faction, self.epidemius_pooled_resource, self.epidemius_pooled_resource_factor_settlements, plague_count_settlements)


end

function nurgle_plagues:apply_effect_bundles_to_non_nurgle_targets(plague_count, force_list)

	--pick effect bundle key based on plague_count
	local effect_bundle_threshold = 0
	if plague_count >= 20 then
		effect_bundle_threshold = 4
	elseif plague_count >= 10 then
		effect_bundle_threshold = 3
	elseif plague_count >= 5 then
		effect_bundle_threshold = 2
	elseif plague_count >= 1 then
		effect_bundle_threshold = 1
	end

	for i = 1, #force_list do
		for j = 1, #self.force_bundle_list do
			cm:remove_effect_bundle_from_force(self.force_bundle_list[j], force_list[i])
		end
		if effect_bundle_threshold > 0 then
			cm:apply_effect_bundle_to_force(self.force_bundle_list[effect_bundle_threshold], force_list[i], 1)
		end
	end

end

function nurgle_plagues:festus_symptom_swap(faction_info)

	for i = 1, #faction_info.current_symptoms_list do
		for j = 1, #self.festus_symptom_key_replace do
			if faction_info.current_symptoms_list[i] == self.festus_symptom_key_replace[j] then
				faction_info.current_symptoms_list[i] = self.festus_symptom_key_replace[j]  .. self.festus_symptom_key_append
			end
		end
	end

end

function nurgle_plagues:copy_symptom_table()
	local s_table = {}

	for i=1, #self.symptoms_list do
		table.insert(s_table, self.symptoms_list[i])
	end

	return s_table
end

function nurgle_plagues:toggle_plagues_button(faction, unlock_info, should_lock, show_incident)
	local local_faction_cqi = cm:get_local_faction(true):command_queue_index()
	if local_faction_cqi == faction:command_queue_index() then
		cm:override_ui(self.disable_plagues_key, should_lock)
	end
	unlock_info.button_locked = should_lock

	if show_incident then
		cm:trigger_incident(faction:name(), self.plagues_unlocked_incident, true, true)
	end
end


--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("NurglePlagues_PlagueFactionInfo", nurgle_plagues.plague_faction_info, context)
		cm:save_named_value("NurglePlagues_PlagueButtonInfo", nurgle_plagues.plague_button_unlock, context)
	end
)
cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			nurgle_plagues.plague_faction_info = cm:load_named_value("NurglePlagues_PlagueFactionInfo", nurgle_plagues.plague_faction_info, context)
			nurgle_plagues.plague_button_unlock = cm:load_named_value("NurglePlagues_PlagueButtonInfo", nurgle_plagues.plague_button_unlock, context)
		end
	end
)