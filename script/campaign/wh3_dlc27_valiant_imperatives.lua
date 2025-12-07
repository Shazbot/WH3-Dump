valiant_imperatives = {
	faction_string = "wh2_main_hef_eataine",
	culture_string = "wh2_main_hef_high_elves",
	ritual_category = {
		"TYRION_IMPERATIVE_ALLIANCE",	
		"TYRION_IMPERATIVE_HEIR"
	},

	rituals = { -- ritual keys
		region_port_naval_force = "wh3_dlc27_hef_tyrion_imperatives_alliance_5",
		region_everqueen_blessing = "wh3_dlc27_hef_tyrion_imperatives_alliance_6",
		region_restock_garrison = "wh3_dlc27_hef_tyrion_imperatives_general_2",
		region_deploy_militia = "wh3_dlc27_hef_tyrion_imperatives_general_3",
		force_grant_character_xp = "wh3_dlc27_hef_tyrion_imperatives_general_5",
		force_construct_local_buildings = "wh3_dlc27_hef_tyrion_imperatives_general_6",
		force_grant_unit_xp = "wh3_dlc27_hef_tyrion_imperatives_general_7",
		force_loan_and_teleport = "wh3_dlc27_hef_tyrion_imperatives_general_8",
		force_restore_ap = "wh3_dlc27_hef_tyrion_imperatives_general_9"
	},

	rituals_config = {
		unit_ranks_to_grant = 1, -- Number of veterancy ranks to grant units using the experienced leader action
		character_experience_to_grant = 2500, -- amount of xp to grant to characters in force when using the warrior council action
	},

	incidents = {
		performed = "wh3_dlc27_incident_tyrion_action_performed",
		target_force = "wh3_dlc27_incident_tyrion_action_received_force",
		target_region ="wh3_dlc27_incident_tyrion_action_received_region",		
	},

	alliance_faction_set = "wh3_dlc27_hef_playable_except_tyrion",

	alliance_ritual_factions = {
		wh2_main_hef_nagarythe = "wh3_dlc27_hef_tyrion_imperatives_alliance_2", --Alith Anar
		wh2_main_hef_order_of_loremasters = "wh3_dlc27_hef_tyrion_imperatives_alliance_1", --Teclis
		wh2_main_hef_avelorn = "wh3_dlc27_hef_tyrion_imperatives_alliance_6", --Alarielle
		wh2_main_hef_yvresse = "wh3_dlc27_hef_tyrion_imperatives_alliance_3", --Eltharion
		wh3_dlc27_hef_aislinn = "wh3_dlc27_hef_tyrion_imperatives_alliance_5", --Aislinn
		wh2_dlc15_hef_imrik = "wh3_dlc27_hef_tyrion_imperatives_alliance_4" --Imrik
	},
	influence = {
		battle_payout_tyrion = { -- Base values for influence gained when winning a battle
			pyrrhic_victory	 = 5,
			close_victory	 = 10,
			decisive_victory = 15,
			heroic_victory	= 20,
		},
		battle_payout_others = { -- Base values for influence gained when winning a battle
			pyrrhic_victory	 = 3,
			close_victory	 = 3,
			decisive_victory = 7,
			heroic_victory	= 7,
		},
		homeland_bonus = 2 -- multiplier for battles fought on ulthuan
	},

	ulthuan_region_set = "cai_region_hint_area_ulthuan"
	
}

function valiant_imperatives:initialise()

	core:add_listener(
		"valiant_imperatives_BattleCompleted",
		"BattleConflictFinished",
		function(context)
			local pending_battle = context:pending_battle()

			-- ensure it's a finished battle with clear winners
			if not pending_battle:has_been_fought() or
				not pending_battle:has_attacker() or
				not pending_battle:has_defender() or
				pending_battle:is_draw() then
				return false
			end

			-- check whether a High Elf faction participated
			local is_any_attacker_valid_culture = cm:pending_battle_cache_culture_is_attacker(self.culture_string)
			local is_any_defender_valid_culture = cm:pending_battle_cache_culture_is_defender(self.culture_string)
			if not is_any_attacker_valid_culture and not is_any_defender_valid_culture then
				return false
			end

			-- stop if both are High Elves
			if is_any_attacker_valid_culture and is_any_defender_valid_culture then
				return false
			end

			-- check whether the High Elf faction side won
			local did_attackers_win = pending_battle:attacker_won()
			local did_defenders_win = pending_battle:defender_won()
			local valid_winner = (is_any_attacker_valid_culture and did_attackers_win) or (is_any_defender_valid_culture and did_defenders_win)
			if not valid_winner then
				return false
			end
			
			out.design("high elves were involved and won")
			return true
		end,
		function(context)
			-- Tyrion generates additional influence from battle victories, doubled on victories within ulthuan
			local battle = context:pending_battle()

			-- there is at least one High Elf faction among the winners of the
			-- battle - that has been verified in the condition callback
			local winners, _ = cm:get_pending_battle_winners_and_losers(battle)
			if table.is_empty(winners) then
				return
			end

			-- get the battle result from the winner
			local did_attackers_win = battle:attacker_won()
			local battle_result = did_attackers_win and battle:attacker_battle_result() or battle:defender_battle_result()

			local region = battle:region_data():region()
			local is_special_region = region and not region:is_null_interface() and region:is_contained_in_region_group(self.ulthuan_region_set)

			-- give influence to all High Elf winners
			for _, character in dpairs(winners) do
				local faction = character:faction()
				local faction_key = faction:name()
				local is_special_faction = faction_key == self.faction_string
				local payouts = is_special_faction and self.influence.battle_payout_tyrion or self.influence.battle_payout_others
				local payout = payouts[battle_result] or 0
				if is_special_faction and is_special_region then
					payout = payout * self.influence.homeland_bonus
				end

				if payout ~= 0 then
					cm:change_influence(faction_key, payout)
				end
			end
		end,
		true
	)

	if not cm:get_faction(self.faction_string) then return false end

	out("#### Adding Valiant Imperatives Listeners ####") --except the one for Influence, it is now for everyone
	
    core:add_listener(
		"valiant_imperatives_RitualCompletedEvent",
		"RitualCompletedEvent",
		function(context)
			return context:performing_faction():name() == self.faction_string and (context:ritual():ritual_category() == self.ritual_category[1] or context:ritual():ritual_category() == self.ritual_category[2])
		end,
		function(context)
			self:ritual_completed_event(context)
		end,
		true
	)

	core:add_listener(
		"valiant_imperatives_RitualUnlockOnConfederate",
		"FactionJoinsConfederation",
		function(context)
			return context:confederation():name() == self.faction_string and context:faction():is_contained_in_faction_set(self.alliance_faction_set) --confederator is tyrion and confederatee is one of the alliance factions
		end,
		function(context)
			cm:unlock_ritual(cm:get_faction(self.faction_string), self.alliance_ritual_factions[context:faction():name()], 0) --unlock the ritual defined as kv pair to the confederated faction
		end,
		true
	)

	core:add_listener(
		"valiant_imperatives_RitualUnlockOnAlliance",
		"PositiveDiplomaticEvent",
		function(context)
			return context:is_alliance() == true and (context:proposer():name() == self.faction_string or context:recipient():name() == self.faction_string) --Tyrion is involved in an alliance
		end,
		function(context)
			local other_faction

			if context:proposer():name() == self.faction_string then
				other_faction = context:recipient()
			else
				other_faction = context:proposer()
			end
			
			if other_faction:is_contained_in_faction_set(self.alliance_faction_set) then
				cm:unlock_ritual(cm:get_faction(self.faction_string), self.alliance_ritual_factions[other_faction:name()], 0) --unlock the ritual defined as kv pair to the confederated faction
			end
		end,
		true
	)

	core:add_listener(
		"valiant_imperatives_RitualLockOnAllianceBreak",
		"NegativeDiplomaticEvent",
		function(context)
			return context:was_military_alliance() or context:was_defensive_alliance() or context:was_vassalage() == true and (context:proposer():name() == self.faction_string or context:recipient():name() == self.faction_string) --Tyrion's alliance is broken
		end,
		function(context)
			local other_faction

			if context:proposer():name() == self.faction_string then
				other_faction = context:recipient()
			else
				other_faction = context:proposer()
			end
			
			if other_faction:is_contained_in_faction_set(self.alliance_faction_set) then
				cm:lock_ritual(cm:get_faction(self.faction_string), self.alliance_ritual_factions[other_faction:name()], 0) --lock the ritual defined as kv pair to the allied faction
			end
		end,
		true
	)
	
end

-- Unlock rituals with alliance requirements from the start in multiplayer if player is already allied with the required faction
-- (e.g. if the other faction is another player and they're in the same team)
cm:add_first_tick_callback_mp_new(function(context)
	local faction = cm:get_faction(valiant_imperatives.faction_string)

	for faction_key, ritual_key in dpairs(valiant_imperatives.alliance_ritual_factions) do
		local ally_faction = cm:get_faction(faction_key)
		if faction:allied_with(ally_faction) then
			cm:unlock_ritual(faction, ritual_key, 0)
		end
	end
end)

--------------------------------------------------------------
----------------------- Ritual result handling ---------------
--------------------------------------------------------------

function valiant_imperatives:ritual_completed_event(performed)
	local performing_faction = performed:performing_faction()
	local ritual = performed:ritual()
	local ritual_key = ritual:ritual_key()
	local ritual_faction_name = performing_faction:name()
	local faction_cqi = cm:get_faction(ritual_faction_name):command_queue_index()
	local ritual_target = ritual:ritual_target()
	local target_type = ritual_target:target_type()
	local target_force_commander_cqi = 0
	local target_region_cqi = 0

	if target_type == "force" then --alert owner of target force to Tyrion performing an action on it
		local target_faction_cqi = ritual_target:get_target_force():faction():cqi()
		local target_force_commander = ritual_target:get_target_force():general_character()
		target_force_commander_cqi = target_force_commander:cqi()

		if target_force_commander:is_null_interface() == false and target_faction_cqi ~= faction_cqi then
			cm:trigger_incident_with_targets(target_faction_cqi, self.incidents.target_force, 0, 0, target_force_commander_cqi, 0, 0, 0)
		end

	elseif target_type == "region" then --alert owner of target region to Tyrion performing an action on it
		local target_faction_cqi = ritual_target:get_target_region():faction():cqi()
		target_region_cqi = ritual_target:get_target_region():cqi()
		
		if target_faction_cqi ~= faction_cqi then
			cm:trigger_incident_with_targets(target_faction_cqi, self.incidents.target_region, 0, 0, 0, 0, target_region_cqi, 0)
		end
	end

	cm:trigger_incident_with_targets(faction_cqi, self.incidents.performed, 0, 0, target_force_commander_cqi, 0, target_region_cqi, 0) --alert Tyrion that his action has been performed

	if ritual_key == self.rituals.force_grant_unit_xp then
		local target_character = cm:char_lookup_str(ritual_target:get_target_force():general_character())

		cm:add_experience_to_units_commanded_by_character(target_character, self.rituals_config.unit_ranks_to_grant) --grants 1 rank of veterancy to all units in the target force
	end

	if ritual_key == self.rituals.force_grant_character_xp then
		local character_list = ritual_target:get_target_force():character_list()
		local character = 0

		for i=0,character_list:num_items()-1 do
			character = cm:char_lookup_str(character_list:item_at(i))
			cm:add_agent_experience(character, self.rituals_config.character_experience_to_grant) --grants 2500 xp to all characters in the target force
		end

	end

	if ritual_key == self.rituals.force_loan_and_teleport then
		local target_force_commander = ritual_target:get_target_force():general_character() 
		local tyrion = performing_faction:faction_leader()
		if tyrion:has_region() and not tyrion:is_wounded() then -- if tyrion is alive on the map
			local x,y = cm:find_valid_spawn_location_for_character_from_character(ritual_faction_name, cm:char_lookup_str(tyrion), true, 5) -- find a valid spawn location near Tyrion's force
			cm:teleport_military_force_to(target_force_commander:military_force(), x, y)
		end
	end

	
	if ritual_key == self.rituals.region_deploy_militia then
		local target_region = ritual_target:get_target_region():name()
		local target_garrison = cm:get_armed_citizenry_from_garrison(ritual_target:get_target_region():garrison_residence())
		local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(ritual_faction_name, target_region, false, true, 10)

		if not target_garrison:is_null_interface() then
			local garrison_units = target_garrison:unit_list()
			local force_size = garrison_units:num_items() -- the army is the same size as the garrison.

			local ram = random_army_manager;
			ram:remove_force("hef_tyrion_militia");
			ram:new_force("hef_tyrion_militia");

			ram:add_unit("hef_tyrion_militia","wh2_main_hef_inf_spearmen_0",8)
			ram:add_unit("hef_tyrion_militia","wh2_main_hef_inf_archers_1",4)
			ram:add_unit("hef_tyrion_militia","wh2_main_hef_cav_ellyrian_reavers_0",2)
			ram:add_unit("hef_tyrion_militia","wh2_main_hef_cav_ellyrian_reavers_1",2)
			ram:add_unit("hef_tyrion_militia","wh2_main_hef_art_eagle_claw_bolt_thrower",1)

			local unit_list = ram:generate_force("hef_tyrion_militia", force_size, false)

			cm:create_force_with_general(
				self.faction_string,
				unit_list,
				target_region,
				pos_x,
				pos_y,
				"general",
				"wh3_dlc27_noble_militia",
				"",
				"",
				"",
				"",
				false,
				function(cqi)
					cm:apply_effect_bundle_to_characters_force("wh3_dlc27_ritual_hef_temp_army", cqi, 0);
					cm:replenish_action_points(cm:char_lookup_str(cqi))
				end
			)
		end
	end

	if ritual_key == self.rituals.region_restock_garrison then
		local target_region = ritual_target:get_target_region():cqi()

		cm:heal_garrison(target_region)
	end

	if ritual_key == self.rituals.region_everqueen_blessing then
		local target_region = ritual_target:get_target_region()
		local region_key = ritual_target:get_target_region():name()

		cm:apply_effect_bundle_to_region(alarielle.power_of_nature_effect_bundle, region_key, alarielle.power_of_nature_bundle_duration);
		alarielle.power_of_nature_regions[region_key] = alarielle.power_of_nature_bundle_duration; -- pipes the region into the regular power of nature functionality for alarielle so vfx and removal on abandon/non-hef owner happens
		cm:add_garrison_residence_vfx(target_region:garrison_residence():command_queue_index(), alarielle.power_of_nature_vfx.full, false);
		cm:change_corruption_in_province_by(target_region:province_name(), nil, 100, "local_populace")
		core:trigger_event("ScriptEventPowerOfNatureTriggered");
	end
	
	
	if ritual_key == self.rituals.region_port_naval_force then
		local target_region = ritual_target:get_target_region():name()
		local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(ritual_faction_name, target_region, true, false, 10)

		local ram = random_army_manager;
		local unit_list
		local force_commander_subtype
		ram:remove_force("hef_tyrion_sea_patrol");
		ram:new_force("hef_tyrion_sea_patrol");

		if cm:faction_has_dlc_or_is_ai("TW_WH3_TIDES_OF_TORMENT_HEF", ritual_faction_name) then -- if the player owns tides of torment, we can give them all the cool dlc units (sunglasses)
			ram:add_mandatory_unit("hef_tyrion_sea_patrol",	"wh2_main_hef_art_eagle_claw_bolt_thrower",	1);
			ram:add_mandatory_unit("hef_tyrion_sea_patrol",	"wh3_dlc27_hef_veh_skycutter_bolt_thrower",	1);
			ram:add_mandatory_unit("hef_tyrion_sea_patrol",	"wh3_dlc27_hef_inf_ships_company",	3);
			ram:add_mandatory_unit("hef_tyrion_sea_patrol",	"wh2_main_hef_inf_lothern_sea_guard_1",	2);
			
			unit_list = ram:generate_force("hef_tyrion_sea_patrol", 7, false)
			force_commander_subtype = "wh3_dlc27_hef_sea_helm"

		else -- if not, spawn our best approximation with core vanilla units
			ram:add_mandatory_unit("hef_tyrion_sea_patrol","wh2_main_hef_inf_spearmen_0",3)
			ram:add_mandatory_unit("hef_tyrion_sea_patrol","wh2_main_hef_inf_lothern_sea_guard_1",2)
			ram:add_mandatory_unit("hef_tyrion_sea_patrol",	"wh2_main_hef_art_eagle_claw_bolt_thrower",	2);

			unit_list = ram:generate_force("hef_tyrion_sea_patrol", 7, false)
			force_commander_subtype = "wh2_main_hef_prince"
		end

		cm:create_force_with_general(
			self.faction_string,
			unit_list,
			target_region,
			pos_x,
			pos_y,
			"general",
			force_commander_subtype,
			"",
			"",
			"",
			"",
			false,
			function(cqi)
				cm:replenish_action_points(cm:char_lookup_str(cqi))
			end
		)
	end

	if ritual_key == self.rituals.force_restore_ap then
		local target_character = cm:char_lookup_str(ritual_target:get_target_force():general_character())

		cm:replenish_action_points(target_character)
	end
end