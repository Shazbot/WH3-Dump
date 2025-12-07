sayl_confidence = {
	-- POOLED RESOURCE CONSTANTS
	confidence_resource_key = "wh3_dlc27_nor_confidence",
	confidence_resource_factor_manipulation = "wh3_dlc27_nor_confidence_treachery_trigger",
	confidence_resource_factor_battles = "wh3_dlc27_nor_confidence_treachery_trigger",
	confidence_resource_factor_trigger = "wh3_dlc27_nor_confidence_treachery_trigger",
	confidence_resource_factor_treaties = "wh3_dlc27_nor_confidence_treachery_trigger",
	confidence_resource_factor_other = "wh3_dlc27_nor_confidence_treachery_trigger",


	--- POOLED RESOURCE VALUES
	confidence_on_signing_treaty = 0,			-- immediate amount granted from signing any deal with Slaanesh
	confidence_per_gift = 0,					-- gift amount divided by this value is the immediate amount granted by any gift accepted by Slaanesh
	confidence_per_gift_max = 0,				-- maximum amount of SI granted for a gift
	confidence_per_active_treaty = 0,			-- per turn SI given for having treaties with Slaanesh
	confidence_per_battle = 0,					-- immediate amount granted from any battle with Slaanesh
	confidence_capacity_per_region = 0,		-- amount SI capacity goes up per region owned
	confidence_resistance_per_region = 0,		-- amount SI capacity goes down per turn per region owned
	confidence_per_agent_action = 0,			-- amount SI capacity goes down per turn per region owned
	confidence_per_established_treachery = 5,  -- amount given when establishing foreign slots with faction
	confidence_per_vassal = 0,					-- amount given per vassal

	--RITUAL CONSTANTS
	force_vassal_ritual_category = "FORCE_VASSAL",

	---SUBCULTURE CONSTANTS
	sayl_faction_key = "wh3_dlc27_nor_sayl"
}

function sayl_confidence:initialise() 

	self:setup_faction_turn_start_listeners()
	self:setup_diplomatic_action_listeners()
	self:setup_battle_and_occupation_listeners()
	self:setup_agent_action_listeners()
end

function sayl_confidence:setup_faction_turn_start_listeners()
	cm:add_faction_turn_start_listener_by_name(
		"sayl_faction_turn_start_" .. self.sayl_faction_key,
		self.sayl_faction_key,
		function(context)
			self:apply_regular_diplomatic_confidence(context:faction())
		end,
		true
	);
end

function sayl_confidence:apply_regular_diplomatic_confidence(faction_interface)
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
				if self:faction_has_confidence(faction) then
					cm:faction_add_pooled_resource(faction:name(), self.confidence_resource_key, self.confidence_resource_factor_manipulation, self.confidence_per_active_treaty)
				end
			end
		end
	end
end

function sayl_confidence:setup_diplomatic_action_listeners()
	core:add_listener(
		"sayl_diplomacy_event_positive",
		"PositiveDiplomaticEvent",
		function(context)
			local sayl_involved = context:recipient():name() == self.sayl_faction_key or context:proposer():name() == self.sayl_faction_key
			local confidence_faction_involved = self:faction_has_confidence(context:recipient()) or self:faction_has_confidence(context:proposer())
			return sayl_involved and confidence_faction_involved
		end,
		function(context)
			local confidence_faction = context:recipient()
			if context:recipient():name() == self.sayl_faction_key then
				confidence_faction = context:proposer()
			end

			local resource_change = self.confidence_on_signing_treaty

			if context:is_vassalage() then 
				resource_change = 9999
			end 

			if context:is_state_gift() then
				local gift_amount = context:state_gift_amount()
				
				if gift_amount >= 500 then
					resource_change = math.min(math.round(gift_amount / self.confidence_per_gift), self.confidence_per_gift_max)
				else
					resource_change = 0
				end
			end
			
			if resource_change > 0 then
				cm:faction_add_pooled_resource(confidence_faction:name(), self.confidence_resource_key, self.confidence_resource_factor_manipulation, resource_change)
			end
		end,
		true
	)

	core:add_listener(
		"confidence_below_zero",
		"PooledResourceChanged",
		function(context)
			return context:resource():key() == self.confidence_resource_key
				and context:resource():value() < 0
		end,
		function(context)
			local faction_key = context:faction():name()
			if nor_treacheries.dynamic_data.treaty_treachery_tracker[faction_key] then 
				if nor_treacheries.dynamic_data.treaty_treachery_tracker[faction_key].can_trigger_war then 
					cm:force_declare_war(faction_key, self.sayl_faction_key, false, false)
				end
			end
		end,
		true
	)
end

function sayl_confidence:setup_battle_and_occupation_listeners()
	core:add_listener(
		"sayl_post_battle_confidence",
		"CharacterCompletedBattle",
		function(context)
			return self.sayl_faction_key == context:character():faction():name();
		end,
		function(context)
			local num_attackers = cm:pending_battle_cache_num_attackers()
			local num_defenders =  cm:pending_battle_cache_num_defenders()
			
			for i = 1, num_attackers  do
				local char_cqi, mf_cqi, faction_key = cm:pending_battle_cache_get_attacker(i)
				if cm:get_faction(faction_key) then 
					local faction_interface = cm:get_faction(faction_key)

					if faction_key ~= self.sayl_faction_key then 
						self:update_confidence_of_faction_enemies(faction_interface)
					end
				end
			end

			for i = 1, num_defenders do
				local char_cqi, mf_cqi, faction_key = cm:pending_battle_cache_get_defender(i)
				local faction_interface = cm:get_faction(faction_key)
				if cm:get_faction(faction_key) then 
					if faction_key ~= self.sayl_faction_key then 
						self:update_confidence_of_faction_enemies(faction_interface)
					end
				end
			end
		end,
		true
	)

	core:add_listener(
		"slaanesh_vassal_liberated",
		"FactionBecomesLiberationVassal",
		function(context)
			return context:liberating_character():faction() == self.sayl_faction_key
		end,
		function(context)
			local liberated_faction= context:faction()
		
			if self:faction_has_confidence(liberated_faction) then
				cm:faction_add_pooled_resource(liberated_faction:name(), self.confidence_resource_key, self.confidence_resource_factor_other, self.confidence_per_vassal)
			end
		end,
		true
	);

	-- core:add_listener(
	-- 	"treachery_culture_building_restrictions",
	-- 	"ForeignSlotManagerCreatedEvent",
	-- 	function(context)
	-- 		return context:requesting_faction():name() == self.sayl_faction_key
	-- 	end,
	-- 	function(context)
	-- 		if self:faction_has_confidence(context:slot_owner()) then
	-- 			cm:faction_add_pooled_resource(context:slot_owner():name(), self.confidence_resource_key, self.confidence_resource_factor_other, self.confidence_per_established_treachery)
	-- 		end
	-- 	end,
	-- 	true
	-- )
end

function sayl_confidence:setup_agent_action_listeners() 
	core:add_listener(
		"sayl_agent_successful_action_vs_character",
		"CharacterCharacterTargetAction",
		function(context)
			return context:character():faction():name() == self.sayl_faction_key and context:mission_result_success()
		end,
		function(context)
			local target_faction = context:target_character():faction()

			if self:faction_has_confidence(target_faction) then 
				cm:faction_add_pooled_resource(target_faction:name(), self.confidence_resource_key, self.confidence_resource_factor_other, self.confidence_per_agent_action)
			end
		end,
		true
	)

	core:add_listener(
		"sayl_agent_successful_action_vs_garrison",
		"CharacterGarrisonTargetAction",
		function(context)
			return context:character():faction():name() == self.sayl_faction_key and context:mission_result_success()
		end,
		function(context)
			local target_faction = context:garrison_residence():faction()

			if self:faction_has_confidence(target_faction) then 
				cm:faction_add_pooled_resource(target_faction:name(), self.confidence_resource_key, self.confidence_resource_factor_other, self.confidence_per_agent_action)
			end
		end,
		true
	)
end

function sayl_confidence:faction_has_confidence(faction_interface)
	return is_faction(faction_interface) and not faction_interface:is_null_interface() and not faction_interface:pooled_resource_manager():resource(self.confidence_resource_key):is_null_interface()
end

function sayl_confidence:update_confidence_of_faction_enemies(faction_interface)
	local enemies_list = faction_interface:factions_at_war_with()
	if enemies_list:num_items() > 0 then
		for i=0, enemies_list:num_items() - 1 do
			local enemy_faction = enemies_list:item_at(i)
			if self:faction_has_confidence(enemy_faction) and enemy_faction:name() ~= self.sayl_faction_key then
				cm:faction_add_pooled_resource(enemy_faction:name(), self.confidence_resource_key, self.confidence_resource_factor_manipulation, self.confidence_per_active_treaty)
			end
		end
	end
end