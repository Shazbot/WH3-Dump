matters_of_state = {
	faction_string = "wh3_dlc24_cth_the_celestial_court",
	ritual_category = "YUAN_BO_ACTION",
	maximum_tokens = 4,			-- Maximmum amount of tokens that can be stockpiled between the Stone and Steel PRs
	recovery_timer = 5,			-- remaining Turns until a new recovery event
	base_recovery_delay = 5,	-- base amount of turns between recovery
	stone_pending = 0,			-- Pending stone tokens awaiting recovery.
	steel_pending = 0,			-- Pending steel tokens awaiting recovery.
	remaining_capacity_upgrades = 4, -- remaining times the player can increase their maximum tokens.
    stone = "wh3_dlc24_cth_mos_stone",
    steel = "wh3_dlc24_cth_mos_steel",
    default_resource_factor = "wh3_dlc24_cth_mos_per_turn",
	fortress_effect_bundle = "wh3_dlc24_ritual_cth_mos_stone_settlement_type_switch_fortress",
	commercial_effect_bundle = "wh3_dlc24_ritual_cth_mos_steel_settlement_type_switch_commercial",
	agent_success_effect_bundle = "wh3_dlc24_ritual_cth_mos_steel_faction_force_agent_success",
	astromancer_subtype = "wh3_main_cth_astromancer",
	astromancer_type = "wizard",
	experience_payout = 5000, -- amount of experience granted by actions that grant experience.
	short_victory_relay_count = 2, -- the number of astromantic relays to complete a short victory.
	long_victory_relay_count = 4, -- the same but for a long victory.

	doctrines = {
		"wh3_dlc24_ritual_cth_mos_balance_faction_gain_doctrine_peace",
		"wh3_dlc24_ritual_cth_mos_balance_faction_gain_doctrine_progress",
		"wh3_dlc24_ritual_cth_mos_balance_faction_gain_doctrine_prosperity",
		"wh3_dlc24_ritual_cth_mos_balance_faction_gain_doctrine_war"
	},

	rituals = { -- ritual keys
		harmony_building_swap = "wh3_dlc24_ritual_cth_mos_stone_settlement_harmony_swap",
		force_agent_action_success = "wh3_dlc24_ritual_cth_mos_steel_faction_force_agent_success",
		generate_ancillaries = "wh3_dlc24_ritual_cth_mos_steel_faction_ancillary_generation",
		grant_xp_to_character = "wh3_dlc24_ritual_cth_mos_stone_character_xp",
		grant_immunity_to_trespass = "wh3_dlc24_ritual_cth_mos_steel_army_trespassing_immunity",
		reset_corruption_and_control = "wh3_dlc24_ritual_cth_mos_stone_province_control_corruption_reset",
		spawn_elite_astromancer = "wh3_dlc24_ritual_cth_mos_stone_settlement_generate_elite_astromancer",
		add_commercial_effect_bundle = "wh3_dlc24_ritual_cth_mos_steel_settlement_type_switch_commercial",
		add_fortress_effect_bundle = "wh3_dlc24_ritual_cth_mos_stone_settlement_type_switch_fortress",
		deploy_garrison_as_army = "wh3_dlc24_ritual_cth_mos_steel_settlement_generate_temporary_army",
		refresh_ap_of_armies = "wh3_dlc24_ritual_cth_mos_steel_faction_refresh_action_points",
		set_faction_doctrine = "wh3_dlc24_ritual_cth_mos_balance_faction_gain_doctrine"
	},

	incidents = {
		performed = "wh3_dlc24_incident_yuan_bo_action_performed",
		target_force = "wh3_dlc24_incident_yuan_bo_action_received_force",
		target_region ="wh3_dlc24_incident_yuan_bo_action_received_region",		
		relay_failure = "wh3_dlc24_incident_yuan_bo_victory_channel_aborted"
	},

	incursion_variables = {
		escalation_level = { -- determines the threat of each consecutive incursion event
			{army_size = 9, army_power = 4},
			{army_size = 13, army_power = 6},
			{army_size = 16, army_power = 8},
			{army_size = 19, army_power = 10},
		},
		current_escalation = 0,
		army_size_interruption_modifiers = { -- modifier to army size if invasion interrupted before spawning
			["invasion_marker_3"] = -5,
			["invasion_marker_2"] = -3,
			["invasion_marker_1"] = -1
		},
		incursion_duration = 6 -- number of turns an incursion event lasts
	},

	compass_directions = { -- contains the associated victory region and incursion coordinates for each new compass direction
		north = {
			wh3_main_chaos = {
				region = "wh3_main_chaos_region_wei_jin",
				incursion_coordinates = {{974, 688}, {925, 644}, {960, 649}},
			},
			main_warhammer = {
				region = "wh3_main_combi_region_hexoatl",
				incursion_coordinates = {{49, 470}, {88, 470}, {111, 490}}
			},
			compass_action = "wh3_dlc24_compass_advanced_dragon_river"
		},

		east = {
			wh3_main_chaos = {
				region = "wh3_main_chaos_region_tower_of_ashshair",
				incursion_coordinates = {{921, 419}, {919, 484}, {947, 483}},
			},
			main_warhammer = {
				region = "wh3_main_combi_region_the_star_tower",
				incursion_coordinates = {{267, 227}, {263, 215}, {284, 225}}
			},
			compass_action = "wh3_dlc24_compass_advanced_ashshair"
		},

		south = {
			wh3_main_chaos = {
				region = "wh3_main_chaos_region_dragon_fang_mount",
				incursion_coordinates = {{1053, 71}, {1064, 85}, {1046, 82}},
			},
			main_warhammer = {
				region = "wh3_main_combi_region_the_southern_sentinels",
				incursion_coordinates = {{252, 147}, {210, 163}, {261, 123}}
			},
			compass_action = "wh3_dlc24_compass_advanced_broken_lands"
		},

		west = {
			wh3_main_chaos = {
				region = "wh3_main_chaos_region_uzkulak",
				incursion_coordinates = {{761, 236}, {696, 255}, {743, 206}},
			},
			main_warhammer = {
				region = "wh3_main_combi_region_great_turtle_isle",
				incursion_coordinates = {{39, 240}, {63, 257}, {43, 267}}
			},
			compass_action = "wh3_dlc24_compass_advanced_nonchang_basin"
		}
	},
	
	compass_location_vfx_key = "scripted_effect3",
	final_battle_mission = {
		wh3_main_chaos = "wh3_dlc24_cth_yuan_bo_final_battle",
		main_warhammer = "wh3_dlc24_ie_cth_yuan_bo_final_battle"
	}
}

function matters_of_state:initialise()
	if not cm:get_faction(self.faction_string) then return false end

	out("#### Adding Matters of State Listeners ####")

	if cm:is_new_game() and cm:is_faction_human(self.faction_string) then
		for direction, direction_table in pairs(self.compass_directions) do

			local mission_key = "wh3_dlc24_cth_yuan_bo_victory_" .. direction
			local script_key = "yuan_tower_" .. direction
			local victory_region = cm:get_region(direction_table[cm:get_campaign_name()].region)

			local mm = mission_manager:new(self.faction_string, mission_key)
			mm:add_new_objective("SCRIPTED")
			mm:add_condition("script_key " .. script_key)
			mm:add_condition("override_text mission_text_text_wh3_dlc24_victory_missions")
			mm:add_payload("text_display dummy_blank")
			mm:set_should_cancel_before_issuing(false)
			mm:set_show_mission(false);
			mm:trigger()

			cm:set_scripted_mission_entity_completion_states(
				mission_key,
				script_key,
				{{victory_region, false}}
			)
			
			if cm:get_local_faction_name(true) == self.faction_string then
				cm:add_garrison_residence_vfx(victory_region:garrison_residence():command_queue_index(), self.compass_location_vfx_key, true)
			end
		end
	end
	
	core:add_listener(
		"matters_of_state_FactionTurnStart",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == self.faction_string
		end,
		function()
			self:increment_timer()
		end,
		true
	)
	
	core:add_listener(
		"matters_of_state_BattleCompleted",
		"BattleCompleted",
		function()
            return cm:pending_battle_cache_faction_won_battle(self.faction_string) and cm:model():pending_battle():has_been_fought()
		end,
		function() -- Winning a battle pushes your recovery event one turn closer.
			self:increment_timer()
		end,
		true
	)
	
    core:add_listener(
		"matters_of_state_pr_expended",
		"PooledResourceChanged",
		function(context)
			local resource_key = context:resource():key()
			
            return (resource_key == self.steel or resource_key == self.stone) and context:amount() < 0
		end,
		function(context) -- Add expended resources as pending to the opposite type, preparing them to be recovered in the next recovery event.
			local resource_key = context:resource():key()
			local resource_amount = context:amount()
			
			if resource_key == self.steel then
				self.stone_pending = self.stone_pending - resource_amount
				common.set_context_value(self.stone .. "_pending", self.stone_pending)
			elseif resource_key == self.stone then
				self.steel_pending = self.steel_pending - resource_amount
				common.set_context_value(self.steel .. "_pending", self.steel_pending)
			end
		end,
		true
	)
	
	common.set_context_value(self.stone .. "_pending", self.stone_pending)
	common.set_context_value(self.steel .. "_pending", self.steel_pending)
	common.set_context_value("matters_of_state_token_timer", self.recovery_timer)
	self:update_incursion_context_values()
	
    core:add_listener(
		"matters_of_state_RitualCompletedEvent",
		"RitualCompletedEvent",
		function(context)
			return context:performing_faction():name() == self.faction_string and context:ritual():ritual_category() == self.ritual_category
		end,
		function(context)
			self:ritual_completed_event(context:ritual())
		end,
		true
	)
	
	-- remove matters of state hero success effect bundles after actions
	local function mos_hero_action_success(context)
		local faction = context:character():faction()
		if (context:mission_result_critial_success() or context:mission_result_success()) and faction:name() == self.faction_string and faction:has_effect_bundle(self.agent_success_effect_bundle) then
			cm:remove_effect_bundle(self.agent_success_effect_bundle, self.faction_string)
		end
	end
	
	core:add_listener(
		"JadeDragonHeroActionListener",
		"CharacterCharacterTargetAction",
		function(context)
			return context:target_character():faction():name() ~= self.faction_string
		end,
		function(context)
			mos_hero_action_success(context)
		end,
		true
	)

	core:add_listener(
		"JadeDragonHeroActionListenerSettlement",
		"CharacterGarrisonTargetAction", 
		true,
		function(context)
			mos_hero_action_success(context)
		end,
		true
	)
	
	if cm:get_faction(self.faction_string):is_human() then
		if not cm:get_saved_value("yuan_bo_victory_complete") then
			core:add_listener(
				"Yuan_Bo_Completes_Relay",
				"BuildingCompleted",
				function(context)
					return context:building():name() == "wh3_dlc24_cth_special_jade_dragon_astromantic_relay"
				end,
				function(context)
					local garrison_residence = context:garrison_residence()
					local region = garrison_residence:region():name()
					local direction

					for i, direction_table in pairs(self.compass_directions) do --loop through the 4 possible victory locations and get the direction associated with the relay that was built.
						if (region == direction_table[cm:get_campaign_name()].region) then
							direction = i
							break
						end
					end

					if not cm:get_saved_value("yuan_tower_" .. direction) then
						self:start_incursion(direction)
					end
					
					if cm:get_local_faction_name(true) == self.faction_string then
						cm:remove_garrison_residence_vfx(garrison_residence:command_queue_index(), self.compass_location_vfx_key)
					end
				end,
				true
			)
			
			for direction, direction_table in pairs(self.compass_directions) do
				core:add_listener(
					"MattersOfStateIncursionTimer" .. direction,
					"FactionTurnStart",
					function(context)
						return context:faction():name() == self.faction_string and (cm:get_saved_value("yuan_bo_incursion_countdown_" .. direction) or 0) > 0
					end,
					function()
						local countdown = (cm:get_saved_value("yuan_bo_incursion_countdown_" .. direction) or self.incursion_variables.incursion_duration) - 1
						cm:set_saved_value("yuan_bo_incursion_countdown_" .. direction, countdown)
						self:update_incursion_context_values()
						if countdown == 0 then
							self:incursion_complete(direction)
						end
					end,
					true
				)

				core:add_listener(
					"MattersOfStateIncursionFailure" .. direction,
					"CharacterPerformsSettlementOccupationDecision",
					function(context)
						-- We can assume that any occupation decision made to the settlement is the result of a battle that the defender lost, so the ritual is failed
						return (cm:get_saved_value("yuan_bo_incursion_countdown_" .. direction) or 0) > 0 and context:previous_owner() == self.faction_string and context:garrison_residence():region():name() == self.compass_directions[direction][cm:get_campaign_name()].region
					end,
					function(context)
						cm:set_saved_value("yuan_bo_incursion_countdown_" .. direction, 0)
						self:update_incursion_context_values()
						local region_cqi = context:garrison_residence():region():cqi()
						cm:trigger_incident_with_targets(cm:get_faction(self.faction_string):command_queue_index(), self.incidents.relay_failure, 0, 0, 0, 0, region_cqi, 0)

					end,
					true
				)
			end
		end

		-- incursion marker listeners
		core:add_listener(
			"ScriptEventYuanBoIncursionMarkerExpired",
			"ScriptEventYuanBoIncursionMarkerExpired",
			true,
			function(context)
				local marker_ref = context.stored_table.marker_ref
				local instance_ref = context.stored_table.instance_ref
				-- A cheeky trick from the worldroots script, the direction key is part of the marker ref, so we can strip out the standardised marker part to get the direction
				local direction = string.gsub(marker_ref, "_invasion_marker_%d", "")
				-- use the instance ref to grab the x-y-coords so we know where to spawn
				local x, y = Interactive_Marker_Manager:get_coords_from_instance_ref(instance_ref)
				
				matters_of_state:trigger_invasion(x, y, direction)
			end,
			true
		)

		core:add_listener(
			"ScriptEventYuanBoIncursionMarkerInteraction",
			"ScriptEventYuanBoIncursionMarkerInteraction",
			true,
			function(context)
				local area_info = context.stored_table
				local marker_ref = area_info.marker_ref
				local direction_key = string.gsub(marker_ref, "_invasion_marker_%d", "")
				local invasion_faction = "wh3_dlc24_lzd_lizardmen_invasion"
				local escalation = matters_of_state.incursion_variables.current_escalation
				local invasion_power = matters_of_state.incursion_variables.escalation_level[escalation].army_power
				local invasion_size = matters_of_state.incursion_variables.escalation_level[escalation].army_size

				Forced_Battle_Manager:trigger_forced_battle_with_generated_army(
					context:character():military_force():command_queue_index(),
					invasion_faction,
					cm:get_faction(invasion_faction):subculture(),
					invasion_size + matters_of_state.incursion_variables.army_size_interruption_modifiers[string.gsub(marker_ref, direction_key .. "_", "")],
					invasion_power,
					false,
					false,
					true,
					nil,
					nil,
					nil,
					nil,
					nil
				)
			end,
			true
		)
		
		-- final battle completion
		core:add_listener(
			"yuan_bo_final_battle_victory",
			"MissionSucceeded",
			function(context)
				return context:mission():mission_record_key() == self.final_battle_mission[cm:get_campaign_name()]
			end,
			function()
				cm:complete_scripted_mission_objective(self.faction_string, "wh_main_long_victory", "final_battle", true)
				
				core:svr_save_registry_bool("yuan_bo_win", true)
				cm:register_instant_movie("warhammer3/cth/yuan_bo_win")
			end,
			false
		)
	end
end

--------------------------------------------------------------
----------------------- action and resource management -------
--------------------------------------------------------------

function matters_of_state:increment_timer()
    local faction = cm:get_faction(self.faction_string)
    local current_steel = faction:pooled_resource_manager():resource(self.steel):value()
    local current_stone = faction:pooled_resource_manager():resource(self.stone):value()
        
    if current_steel + current_stone < self.maximum_tokens then
        self.recovery_timer = self.recovery_timer - 1
		
        if self.recovery_timer == 0 then -- Recover one unit of each PR with a pending change.
            if self.stone_pending > 0 then
                cm:faction_add_pooled_resource(self.faction_string, self.stone, self.default_resource_factor, 1)
                self.stone_pending = self.stone_pending - 1
				common.set_context_value(self.stone .. "_pending", self.stone_pending)
            end
			
            if self.steel_pending > 0 then
                cm:faction_add_pooled_resource(self.faction_string, self.steel, self.default_resource_factor, 1)
                self.steel_pending = self.steel_pending - 1
				common.set_context_value(self.steel .. "_pending", self.steel_pending)
            end
			
            self.recovery_timer = self.base_recovery_delay
        end
    end
	
	common.set_context_value("matters_of_state_token_timer", self.recovery_timer)
end
function matters_of_state:update_capacity(pr)
	if self.remaining_capacity_upgrades > 0 then
		self.maximum_tokens = self.maximum_tokens + 1
		self.remaining_capacity_upgrades = self.remaining_capacity_upgrades -1
		cm:faction_add_pooled_resource(self.faction_string, pr, self.default_resource_factor, 1)
	end
end

function matters_of_state:ritual_completed_event(ritual)
	local ritual_key = ritual:ritual_key()
	local faction_cqi = cm:get_faction(self.faction_string):command_queue_index()
	local ritual_target = ritual:ritual_target()
	local target_type = ritual_target:target_type()
	local target_force_commander_cqi = 0
	local target_region_cqi = 0

	if target_type == "force" then --alert owner of target force to yuan bo performing an action on it
		local target_faction_cqi = ritual_target:get_target_force():faction():cqi()
		local target_force_commander = ritual_target:get_target_force():general_character()
		target_force_commander_cqi = target_force_commander:cqi()
		if target_force_commander:is_null_interface() == false and target_faction_cqi ~= faction_cqi then
			cm:trigger_incident_with_targets(target_faction_cqi, self.incidents.target_force, 0, 0, target_force_commander_cqi, 0, 0, 0)
		end

	elseif target_type == "region" then --alert owner of target region to yuan bo performing an action on it
		local target_faction_cqi = ritual_target:get_target_region():faction():cqi()
		target_region_cqi = ritual_target:get_target_region():cqi()
		
		if target_faction_cqi ~= faction_cqi then
			cm:trigger_incident_with_targets(target_faction_cqi, self.incidents.target_region, 0, 0, 0, 0, target_region_cqi, 0)
		end
	end

	cm:trigger_incident_with_targets(faction_cqi, self.incidents.performed, 0, 0, target_force_commander_cqi, 0, target_region_cqi, 0) --alert yuan bo that his action has been performed

	if ritual_key == self.rituals.harmony_building_swap then
		local target_slotlist = ritual:ritual_target():get_target_region():slot_list()
		local target_region = ritual:ritual_target():get_target_region():name()
		local campaign_root = cco("CcoCampaignRoot", "")

		for i=0,target_slotlist:num_items()-1 do
			local building = target_slotlist:item_at(i):building()
			local slot = target_slotlist:item_at(i)

			if building:is_null_interface() == false then  -- check if the building in the provided slot has a valid conversion.
				local target_building = building:name()
				local settlement_cco = campaign_root:Call("SettlementList.FirstContext(RegionRecordKey == \"" .. target_region .. "\")")
				local slot_cco = settlement_cco:Call("BuildingSlotList.At(" .. i .. ")")
				local swap_building = slot_cco:Call("PossibleUpgradeOnlyConversionsList(true).FirstContext.Key") -- Technically, this would also work if the structure had a swap, regardless of if it was a harmony building but...

				if swap_building ~= nil then
					cm:instantly_upgrade_building_in_region(slot, swap_building)
				end
			end
		end
	end

	if ritual_key == self.rituals.generate_ancillaries then
		cm:trigger_incident(self.faction_string, "wh3_dlc24_ritual_cth_mos_steel_faction_ancillary_generation", true)
	end

	if ritual_key == self.rituals.grant_xp_to_character then
		local target_character = cm:char_lookup_str(ritual:ritual_target():get_target_force():general_character())
		cm:add_agent_experience(target_character, self.experience_payout)
	end

	if ritual_key == self.rituals.grant_immunity_to_trespass then
		cm:set_character_excluded_from_trespassing(ritual:ritual_target():get_target_force():general_character(), true) --- Might move this to a time limited effect if there's a reasonable way to do that.
	end

	if ritual_key == self.rituals.reset_corruption_and_control then
		local target_region = ritual:ritual_target():get_target_region()

		cm:change_corruption_in_province_by(target_region:province_name(), nil, 100, "local_populace")
		cm:set_public_order_of_province_for_region(target_region:name(), 0)
	end

	if ritual_key == self.rituals.spawn_elite_astromancer then
		local target_region = ritual:ritual_target():get_target_region():name()
		local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(self.faction_string, target_region, false, true, 10)

		local spawned_astromancer = cm:char_lookup_str(cm:create_agent(self.faction_string, self.astromancer_type, self.astromancer_subtype, pos_x, pos_y))

		cm:force_add_trait(spawned_astromancer,  "wh3_dlc24_ritual_cth_mos_stone_settlement_generate_elite_astromancer")
		cm:add_agent_experience(spawned_astromancer, self.experience_payout)
	end

	if ritual_key == self.rituals.add_commercial_effect_bundle then
		local target_region = ritual:ritual_target():get_target_region():name()
		cm:remove_effect_bundle_from_region(self.fortress_effect_bundle, target_region)
		self:update_capacity(self.stone)
	end

	if ritual_key == self.rituals.add_fortress_effect_bundle then
		local target_region = ritual:ritual_target():get_target_region():name()

		cm:remove_effect_bundle_from_region(self.commercial_effect_bundle, target_region)
		self:update_capacity(self.steel)
	end
	
	if ritual_key == self.rituals.deploy_garrison_as_army then
		local target_region = ritual:ritual_target():get_target_region():name()
		local target_garrison = cm:get_armed_citizenry_from_garrison(ritual:ritual_target():get_target_region():garrison_residence())
		local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(self.faction_string, target_region, false, true, 10)
		
		if not target_garrison:is_null_interface() then
		local garrison_units = target_garrison:unit_list()
		local army_units_string = ""
		
		for i=0,garrison_units:num_items()-1 do
			unit = garrison_units:item_at(i)
			if unit:unit_class() ~= "com" then -- We do not include lord and hero units in the deployed army
				cm:set_unit_hp_to_unary_of_maximum(unit, 0.1) --the garrison is out fighting on the campaign map, so we nuke the garrison to represent that!
				army_units_string = army_units_string .. unit:unit_key() .. ","
			end
		end

		cm:create_force_with_general(
			self.faction_string,
			army_units_string,
			target_region,
			pos_x,
			pos_y,
			"general",
			"wh3_dlc24_cth_lord_magistrate_reserves",
			"",
			"",
			"",
			"",
			false,
			function(cqi)
				cm:apply_effect_bundle_to_characters_force("wh3_dlc24_ritual_cth_mos_steel_settlement_generate_temporary_army", cqi, 0);
				cm:replenish_action_points(cm:char_lookup_str(cqi))
			end
		)
		end
	end

	if ritual_key == self.rituals.refresh_ap_of_armies then
		local faction = cm:get_faction(self.faction_string)
		for i = 0, faction:character_list():num_items()-1 do
			local character = faction:character_list():item_at(i)

			if cm:char_is_garrison_commander(character) == false then
				cm:replenish_action_points(cm:char_lookup_str(character:command_queue_index()))
			end
		end
	end

	if ritual_key == self.rituals.set_faction_doctrine then -- The doctrines are mutually exclusive, so we wipe them when the player is about to select a new one
		for i, bundle in pairs(self.doctrines) do
			cm:remove_effect_bundle(bundle, self.faction_string)
		end
	end

end

--------------------------------------------------------------
----------------------- Incursion management ---------------------
--------------------------------------------------------------

function matters_of_state:trigger_invasion(x, y, direction)
	out("triggering invasion for the " .. direction .. " compass direction")
	
	local current_escalation = self.incursion_variables.current_escalation
	
	if current_escalation == 0 then current_escalation = 1 end -- older saves weren't tracking this, always use 1
	
	local invasion_target_region = self.compass_directions[direction][cm:get_campaign_name()].region
	local invasion_target_faction = self.faction_string
	local invasion_faction = "wh3_dlc24_lzd_lizardmen_invasion"
	local invasion_power = self.incursion_variables.escalation_level[current_escalation].army_power
	local invasion_size = self.incursion_variables.escalation_level[current_escalation].army_size
	
	local unit_list = WH_Random_Army_Generator:generate_random_army("yuan_"..direction.."_incursion", "wh2_main_sc_lzd_lizardmen", invasion_size,  invasion_power, true, false)
	if x and y then
		local invasion_key = "compass_" .. direction .. "_invasion_" .. x .. y
		local spawn_location_x, spawn_location_y = cm:find_valid_spawn_location_for_character_from_position(invasion_target_faction, x, y, true)
		local invasion_object = invasion_manager:new_invasion(invasion_key, invasion_faction, unit_list, {spawn_location_x, spawn_location_y})
		invasion_object:apply_effect("wh2_dlc16_bundle_military_upkeep_free_force_immune_to_regionless_attrition", -1)
		invasion_object:set_target("REGION", invasion_target_region,invasion_target_faction)
		invasion_object:add_aggro_radius(25, {invasion_target_faction}, 1)
		invasion_object:start_invasion(true, true, false, false)
	end
end

function matters_of_state:start_incursion(direction) --starts an incursion event for a specific compass direciton
	local countdown = cm:get_saved_value("yuan_bo_incursion_countdown_" .. direction) or 0
	
	if countdown < 1 then
		cm:set_saved_value("yuan_bo_incursion_countdown_" .. direction, self.incursion_variables.incursion_duration)
		self:update_incursion_context_values()
		
		if self.incursion_variables.current_escalation < 4 then
			self.incursion_variables.current_escalation = self.incursion_variables.current_escalation + 1 
		end
		
		-- use the marker manager to spawn a series of invasion markers, with an event that fires when they expire
		local marker_base_key = direction
		
		local countdown_markers = Interactive_Marker_Manager:create_countdown(
			marker_base_key,
			"ScriptEventYuanBoIncursionMarkerInteraction",
			"ScriptEventYuanBoIncursionMarkerExpired",
			{"invasion_marker_3", "invasion_marker_2", "invasion_marker_1"}
		)
		
		local countdown_marker_stage_1 = countdown_markers[1]
		local countdown_marker_stage_2 = countdown_markers[2]
		local countdown_marker_stage_3 = countdown_markers[3]
		
		
		countdown_marker_stage_1:add_spawn_event_feed_event(
			"event_feed_strings_text_wh3_dlc24_event_feed_string_scripted_event_invasion_title_lizardmen",
			"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_mustering_primary_detail",
			"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_mustering_secondary_detail", 
			1333,
			self.faction_string
		)
		
		countdown_marker_stage_3:add_spawn_event_feed_event(
			"event_feed_strings_text_wh3_dlc24_event_feed_string_scripted_event_invasion_title_lizardmen",
			"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_imminent_primary_detail",
			"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_imminent_secondary_detail", 
			1333,
			self.faction_string
		)
		
		countdown_marker_stage_3:add_despawn_event_feed_event(
			"event_feed_strings_text_wh3_dlc24_event_feed_string_scripted_event_invasion_title_lizardmen",
			"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_spawned_primary_detail",
			"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_spawned_secondary_detail", 
			1333,
			self.faction_string
		)
		
		local invasion_coord_list = self.compass_directions[direction][cm:get_campaign_name()].incursion_coordinates
		
		for i = 1, #invasion_coord_list do
			local x = invasion_coord_list[i][1]
			local y = invasion_coord_list[i][2]
			local random_duration = cm:random_number(3, 1)
			
			if random_duration == 3 then 
				countdown_marker_stage_1:spawn_at_location(x, y, false)
			elseif random_duration == 2 then
				countdown_marker_stage_2:spawn_at_location(x, y, false)
			else
				countdown_marker_stage_1:spawn_at_location(x, y, false)
			end
		end
	end
end

function matters_of_state:incursion_complete(direction)
	cm:complete_scripted_mission_objective(self.faction_string, "wh3_dlc24_cth_yuan_bo_victory_" .. direction, "yuan_tower_" .. direction, true)
	cm:set_compass_direction_lock_status(cm:get_faction(self.faction_string), self.compass_directions[direction].compass_action, false)
	cm:trigger_incident(self.faction_string, "wh3_dlc24_story_panel_yuan_bo_compass_" .. direction, true, true)
	cm:set_saved_value("yuan_tower_" .. direction, true)
	
	local relays_built = cm:get_saved_value("yuan_bo_victory_count") or 0
	relays_built = relays_built + 1
	cm:set_saved_value("yuan_bo_victory_count", relays_built)
	
	cm:complete_scripted_mission_objective(self.faction_string, "wh_main_long_victory", "empower_compass_" .. direction, true)
	
	if relays_built >= self.short_victory_relay_count then
		cm:complete_scripted_mission_objective(self.faction_string, "wh_main_short_victory", "empower_compass", true)
	end

	if relays_built >= 4 then
		cm:set_saved_value("yuan_bo_victory_complete", true)
		core:remove_listener("Yuan_Bo_Completes_Relay")
		
		local campaign_name = cm:get_campaign_name()
		local mm = mission_manager:new(self.faction_string, self.final_battle_mission[campaign_name])
		mm:add_new_objective("FIGHT_SET_PIECE_BATTLE")
		mm:add_condition("set_piece_battle wh3_dlc24_cth_yuan_bo_compass")
		if campaign_name == "wh3_main_chaos" then
			mm:add_payload("text_display dummy_wh3_main_survival_forge_of_souls")
		else
			mm:add_payload("text_display dummy_wh3_dlc24_long_campaign_victory")
		end
		mm:trigger()
	end
end

function matters_of_state:update_incursion_context_values()
	for direction, direction_table in pairs(self.compass_directions) do
		common.set_context_value("compass_incursion_active_" .. direction, cm:get_saved_value("yuan_bo_incursion_countdown_" .. direction) or 0)
	end
end



--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("matters_of_state_recovery_timer", matters_of_state.recovery_timer, context)
		cm:save_named_value("matters_of_state_pr_stone_pending", matters_of_state.stone_pending, context)
		cm:save_named_value("matters_of_state_pr_steel_pending", matters_of_state.steel_pending, context)
		cm:save_named_value("matters_of_state_pr_maximum_tokens", matters_of_state.maximum_tokens, context)
		cm:save_named_value("matters_of_state_remaining_capacity_upgrades", matters_of_state.remaining_capacity_upgrades, context)
		cm:save_named_value("matters_of_state_incursion_variables", matters_of_state.incursion_variables, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			matters_of_state.recovery_timer = cm:load_named_value("matters_of_state_recovery_timer", matters_of_state.recovery_timer, context)
			matters_of_state.stone_pending = cm:load_named_value("matters_of_state_pr_stone_pending", matters_of_state.stone_pending, context)
			matters_of_state.steel_pending = cm:load_named_value("matters_of_state_pr_steel_pending", matters_of_state.steel_pending, context)
			matters_of_state.maximum_tokens = cm:load_named_value("matters_of_state_pr_maximum_tokens", matters_of_state.maximum_tokens, context)
			matters_of_state.remaining_capacity_upgrades = cm:load_named_value("matters_of_state_remaining_capacity_upgrades", matters_of_state.remaining_capacity_upgrades, context)
			matters_of_state.incursion_variables = cm:load_named_value("matters_of_state_incursion_variables", matters_of_state.incursion_variables, context)
		end
	end
)