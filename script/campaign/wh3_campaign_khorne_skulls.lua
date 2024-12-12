local skull_piles = {};
local skull_pile_max_duration = 40
local skull_pile_min_duration = 10
local skull_pile_min_skulls = 50
local skull_pile_max_skulls = 500
local skulls_per_casualty = 0.2
local skull_pile_threshold = 200 -- if combined sum of all modifiers +random roll of 1- skull pile threshold exceeds this, spawn a pile. THis higher this is, the more random the spawns will be
local khorne_corruption_weight = 2 -- multiplier on the value of Khorne corruption in the calculation
local chs_corruption_weight = 1 -- multiplier on the value of generic Chaos corruption in the calculation
local bonus_at_0_piles = 200 -- amount added to roll when there are 0 piles on the map
local modifier_per_active_pile = 10 -- amount to reduce above bonus by per active pile. can go negative.
local vision_bonus = 75 --if battle is visible to any player khorne faction, add this to roll




function setup_khorne_skulls()
	local human_factions = cm:get_human_factions();

	khorne_spawned_armies:setup_listeners()

	core:add_listener(
		"skull_throne_rituals_handler",
		"RitualCompletedEvent",
		true,
		function(context)
			local ritual_key = context:ritual():ritual_key()
			local performing_faction = context:performing_faction()

			local function handle_skull_throne_ritual(payload)
				if performing_faction:has_faction_leader() then
					local faction_leader = performing_faction:faction_leader()

					if faction_leader:has_military_force() then
						if payload == "ap" then
							cm:replenish_action_points(cm:char_lookup_str(faction_leader))
						elseif payload == "hp" then
							for _, unit in model_pairs(faction_leader:military_force():unit_list()) do
								cm:set_unit_hp_to_unary_of_maximum(unit, 1)
							end
						elseif payload == "blood_host" then
							khorne_spawned_armies:spawn_army(faction_leader, false, true)
						end
					end
				end

				cm:remove_effect_bundle(ritual_key, performing_faction:name())
			end

			if ritual_key == "wh3_dlc26_ritual_kho_the_skull_throne_3_1" then -- replenish army ap
				handle_skull_throne_ritual("ap")
			elseif ritual_key == "wh3_dlc26_ritual_kho_the_skull_throne_3_2" then -- replenish army health
				handle_skull_throne_ritual("hp")
			elseif ritual_key == "wh3_dlc26_ritual_kho_the_skull_throne_4_1" then -- spawn blood host
				handle_skull_throne_ritual("blood_host")
			end
		end,
		true
	)

	-- deactivate rituals if faction leader isn't present
	core:add_listener(
		"skull_throne_panel_opened",
		"PanelOpenedCampaign",
		function(context)
			return context.string == "dlc26_skull_throne"
		end,
		function()
			local function set_ritual_inactive(uic)
				if not uic then return end

				for i = 0, uic:ChildCount() - 1 do
					local child = find_child_uicomponent_by_index(uic, i)
					if child and child:CurrentState() == "active" then child:SetState("unaffordable") end
				end
			end
			
			local faction = cm:get_local_faction(true)

			if not faction:faction_leader():has_military_force() then
				set_ritual_inactive(find_uicomponent("dlc26_skull_throne", "t4_rituals_holder"))
				set_ritual_inactive(find_uicomponent("dlc26_skull_throne", "t3_rituals_holder"))
			end

			if faction:has_effect_bundle("wh3_dlc26_ritual_kho_the_skull_throne_1_2") then
				local uic = find_uicomponent("dlc26_skull_throne", "t1_rituals_holder")

				for i = 0, uic:ChildCount() - 1 do
					local child = find_child_uicomponent_by_index(uic, i)
					if child and string.find(child:Id(), "wh3_dlc26_ritual_kho_the_skull_throne_1_2") and child:CurrentState() == "active"  then
						child:SetState("unaffordable")
					end
				end
			end
		end,
		true
	)

	for i = 1, #human_factions do
		if not cm:get_faction(human_factions[i]):pooled_resource_manager():resource("wh3_main_kho_skulls"):is_null_interface() then
			start_khorne_skull_listeners();
			return;
		end;
	end;
end;

function start_khorne_skull_listeners()
	local selected_human_faction
	local human_factions = cm:get_human_factions()

	for i = 1, #human_factions do
		local current_human_faction = cm:get_faction(human_factions[i])

		if current_human_faction:culture() == "wh3_main_kho_khorne" then
			selected_human_faction = human_factions[i]
			break
		end
	end
	
	skull_piles = cm:get_saved_value("skull_piles") or {};
	
	for k, v in pairs(skull_piles) do
		common.set_context_value(k, v);
	end;
	
	core:add_listener(
		"khorne_skull_pile",
		"BattleCompleted",
		function()
			local pb = cm:model():pending_battle();
			local region = cm:get_region(pb:region_data():key());
			if not region then
				return false
			end

			return pb:has_been_fought() and not cm:pending_battle_cache_human_culture_is_involved("wh3_main_kho_khorne")
		end,
		function()
			local pb = cm:model():pending_battle();
			
			local pos_x = nil;
			local pos_y = nil;
			local winner_cqi = nil;
			local winner_interface = nil
			local winner_faction = nil;
			
			if pb:has_attacker() then
				local attacker = pb:attacker();
				
				if attacker:won_battle() then
					pos_x = attacker:logical_position_x();
					pos_y = attacker:logical_position_y();
					winner_interface = attacker
					winner_cqi = attacker:command_queue_index();
					winner_faction = attacker:faction():name();
				end;
			end;
			
			if pb:has_defender() then
				local defender = pb:defender();
				
				if defender:won_battle() then
					pos_x = defender:logical_position_x();
					pos_y = defender:logical_position_y();
					winner_interface = defender
					winner_cqi = defender:command_queue_index();
					winner_faction = defender:faction():name();
				end;
			end;
			
			if not winner_cqi then
				return false;
			end;
			
			local id = "skull_pile_" .. winner_cqi .. "_" .. cm:model():turn_number();
			
			if not skull_piles[id] then
				local distance = 5;
				
				-- ensure the skull pile doesn't spawn inside the settlement's zoc
				if pb:siege_battle() then
					local settlement = pb:region_data():region():settlement();
					
					pos_x = settlement:logical_position_x();
					pos_y = settlement:logical_position_y();
					distance = 10;
				end;
				
				pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_position(winner_faction, pos_x, pos_y, true, distance);
				
				if pos_x > 0 then
					local region = cm:get_region(pb:region_data():key());
					local corruption_mod = cm:get_corruption_value_in_region(region, khorne_corruption_string)*khorne_corruption_weight + cm:get_corruption_value_in_region(region, chaos_corruption_string)*chs_corruption_weight
					local skulls = math.clamp(math.floor((pb:attacker_casulaties() + pb:defender_casulaties())*skulls_per_casualty + 1), skull_pile_min_skulls, skull_pile_max_skulls)
					local active_piles = cm:get_saved_value("active_piles") or 0
					local active_piles_mod = bonus_at_0_piles - modifier_per_active_pile * active_piles
					local vision_mod = 0
					
					if winner_interface:is_visible_to_faction(selected_human_faction) then
						vision_mod = vision_bonus
					end

					if cm:random_number(skull_pile_threshold) + corruption_mod + active_piles_mod + vision_mod < skull_pile_threshold then
						return 
					end

					local char, dist = cm:get_closest_character_from_faction(selected_human_faction, pos_x, pos_y)

					if not dist then return end

				 	cm:add_interactable_campaign_marker(id, "wh3_main_kho_skull_pile", pos_x, pos_y, 2);
										
					local a_cqi, af_cqi, attacker_faction = cm:pending_battle_cache_get_attacker(1);
					local d_cqi, df_cqi, defender_faction = cm:pending_battle_cache_get_defender(1);
					local adjusted_duration = math.clamp(math.round(dist / 1000), skull_pile_min_duration, skull_pile_max_duration)
					
					skull_piles[id] = {
						["kills"] = skulls,
						["turns_remaining"] = adjusted_duration,
						["attacker_faction"] = attacker_faction,
						["defender_faction"] = defender_faction
					};
					
					common.set_context_value(id, skull_piles[id]);
					
					cm:add_turn_countdown_event(cm:get_local_faction_name(true), adjusted_duration, "ScriptEventKhorneSkullPileExpires", id);
					
					cm:set_saved_value("skull_piles", skull_piles);
					cm:set_saved_value ("active_piles", active_piles + 1)

					core:trigger_custom_event("ScriptEventSkullPileCreated", {region = region, pending_battle = pb, logical_position_x = pos_x, logical_position_y = pos_y});
				end;
			end;
		end,
		true
	);
	
	core:add_listener(
		"khorne_skull_piled_collected",
		"AreaEntered",
		function(context)
			local character = context:family_member():character();
			if not character:is_null_interface() then
				local faction = character:faction();
				return skull_piles[context:area_key()] and faction:is_human() and faction:culture() == "wh3_main_kho_khorne";
			end;
		end,
		function(context)
			local character = context:family_member():character();
			if not character:is_null_interface() then

				local id = context:area_key();
				local mod = 1 + (character:bonus_values():scripted_value("skull_piles_modifier", "value") / 100);
				
				cm:trigger_custom_incident_with_targets(character:faction():command_queue_index(), "wh3_main_incident_kho_skull_pile_collected", true, "payload{faction_pooled_resource_transaction{resource wh3_main_kho_skulls;factor collected_from_skull_piles;amount " .. math.round(skull_piles[id]["kills"] * mod) .. ";context absolute;};}", 0, 0, character:command_queue_index(), 0, 0, 0);
				
				remove_skull_pile(id);
			end;
		end,
		true
	);
	
	core:add_listener(
		"khorne_skull_pile_expires",
		"ScriptEventKhorneSkullPileExpires",
		true,
		function(context)
			remove_skull_pile(context.string);
		end,
		true
	);
	
	-- update the context value each turn in order to display the turns remaining in the skull pile tooltips
	core:add_listener(
		"khorne_skull_pile_update_turn_timers",
		"FactionTurnStart",
		function(context)
			local faction = context:faction();
			
			return faction:is_human() and faction:culture() == "wh3_main_kho_khorne";
		end,
		function()
			for id, v in pairs(skull_piles) do
				local turns_remaining, a, e, c = cm:report_turns_until_countdown_event(cm:get_local_faction_name(true), "ScriptEventKhorneSkullPileExpires", id);
				
				if turns_remaining then
					skull_piles[id]["turns_remaining"] = turns_remaining;
					
					common.set_context_value(id, skull_piles[id]);
				end;
			end;
			
			cm:set_saved_value("skull_piles", skull_piles);
		end,
		true
	);

	-- Skull income from channeling stance
	-- calculate the amount of skulls to provide when raiding
	local function calculate_khorne_channeling_skulls (mf)
		local value = 0;
		
		if mf:has_general() then
			local units = mf:unit_list():num_items()

			value = units
		end;
		
		if mf:faction():is_human() and value > 0 then
			common.set_context_value("channeling_skulls_value_" .. mf:command_queue_index(), value);
		end;
		
		return value;
	end;
	
	-- set the amount of skulls to provide when channeling for ui display
	local human_factions = cm:get_human_factions();
	
	for i = 1, #human_factions do
		local current_human_faction = cm:get_faction(human_factions[i]);
		
		if current_human_faction:culture() == "wh3_main_kho_khorne" then
			local mf_list = current_human_faction:military_force_list();
			
			for j = 0, mf_list:num_items() - 1 do
				local current_mf = mf_list:item_at(j);
				
				if current_mf:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_CHANNELING" then
					calculate_khorne_channeling_skulls(current_mf);
				end;
			end;
		end;
	end;
	
	-- set the amonut of skulls to provide when channeling for ui display when an army enters the channeling stance
	core:add_listener(
		"khorne_channeling_calculate_skulls",
		"ForceAdoptsStance",
		function(context)
			local faction = context:military_force():faction();
			
			return faction:is_human() and faction:culture() == "wh3_main_kho_khorne";
		end,
		function(context)
			local mf = context:military_force();
			
			if context:stance_adopted() == 11 then
				calculate_khorne_channeling_skulls(mf);
				core:trigger_custom_event("ScriptEventCombatTrialsStanceAdopted", {military_force = mf});
			else
				common.set_context_value("channeling_skulls_value_" .. mf:command_queue_index(), 0);
			end;
		end,
		true
	);
	
	-- update the amount of skulls if the character moves in channeling stance
	core:add_listener(
		"khorne_channelling_calculate_devotees_post_movement",
		"CharacterFinishedMovingEvent",
		function(context)
			local character = context:character();
			local faction = character:faction();
			
			return faction:is_human() and faction:culture() == "wh3_main_kho_khorne" and cm:char_is_general_with_army(character) and character:military_force():active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_CHANNELING";
		end,
		function(context)
			calculate_khorne_channeling_skulls(context:character():military_force());
		end,
		true
	);

	-- add the skulls for armies channeling
	core:add_listener(
		"khorne_channeling_add_skulls",
		"FactionTurnStart",
		function(context)
			return context:faction():culture() == "wh3_main_kho_khorne";
		end,
		function(context)
			local faction = context:faction();
			local mf_list = faction:military_force_list();
			
			for i = 0, mf_list:num_items() - 1 do
				local current_mf = mf_list:item_at(i);
				
				if current_mf:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_CHANNELING" then
					local skulls_to_add = calculate_khorne_channeling_skulls(current_mf);
					
					if skulls_to_add > 0 then
						cm:faction_add_pooled_resource(faction:name(), "wh3_main_kho_skulls", "combat_trials", skulls_to_add);
					end;
				end;
			end;
		end,
		true
	);
end;

function remove_skull_pile(id)
	cm:remove_interactable_campaign_marker(id);
	
	skull_piles[id] = nil;

	active_piles = cm:get_saved_value("active_piles")
	cm:set_saved_value("active_piles", active_piles -1)
	cm:set_saved_value("skull_piles", skull_piles);
end;



----------------------------------------------------
---------------RAZE-SPAWNED ARMIES------------------
----------------------------------------------------
---below is everything for the armies that spawn from razing

khorne_spawned_armies = {
	occupation_option_id = "1673500944",
	spawned_army_general_subtype = "wh3_main_kho_herald_of_khorne_khorne_spawned_army",
	spawned_army_upgraded_general_subtype = "wh3_dlc26_kho_exalted_bloodthirster_khorne_spawned_army",
	spawned_army_size = 9,
	spawned_army_starting_bundle_key = "wh3_main_bundle_force_khorne_summoned_army",
	spawned_army_post_battle_bundle_key = "wh3_main_bundle_force_khorne_summoned_army_post_battle",
	spawned_army_post_battle_bundle_duration = 2,
	spawned_army_initial_bundle_duration = 4,
	spawned_army_bundle_max_duration = 5 -- needs to match dummy display in the db
};

function khorne_spawned_armies:setup_listeners()
	-- spawn an army on performing a specific occupation dection
	core:add_listener(
		"CharacterPerformsSettlementOccupationDecisionSummonArmy",
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			local occupation_id = context:occupation_decision()
			return occupation_id == self.occupation_option_id
		end,
		function(context)
			self:spawn_army(context:character())
		end,
		true
	);

	core:add_listener(
		"CharacterCompletedBattleKhorneSummonedArmy",
		"CharacterCompletedBattle",
		function(context)
			local subtype = context:character():character_subtype_key()
			return subtype == self.spawned_army_general_subtype or subtype == self.spawned_army_upgraded_general_subtype
		end,
		function(context)
			local character = context:character()
			local char_cqi = character:command_queue_index()
			local bonus_value = cm:get_factions_bonus_value(character:faction(), "kho_spawned_army_post_battle_attrition_immunity_duration_mod")
			
			local current_duration = self:get_effect_bundle_duration_remaining(character:military_force())
			local additional_duration = self.spawned_army_post_battle_bundle_duration + bonus_value
			
			if current_duration + additional_duration >= self.spawned_army_bundle_max_duration then
				additional_duration = self.spawned_army_bundle_max_duration - current_duration
			end
			
			if additional_duration > 0 then
				cm:apply_effect_bundle_to_characters_force(self.spawned_army_post_battle_bundle_key, char_cqi, additional_duration)
			end
		end,
		true
	);
end;

function khorne_spawned_armies:spawn_army(character, spawned_by_bonus_value, spawned_by_skull_throne)
	local faction = character:faction()
	local faction_key = faction:name()
	local distance = 10

	if spawned_by_bonus_value or spawned_by_skull_throne then distance = 5 end

	local x, y = cm:find_valid_spawn_location_for_character_from_character(faction_key, cm:char_lookup_str(character), false, distance)
	
	if x > 0 then
		local bonus_size = cm:get_characters_bonus_value(character, "kho_spawned_army_size_mod")
		local guaranteed_bloodthirsters = cm:get_characters_bonus_value(character, "kho_spawned_army_guaranteed_bloodthirsters")
		local guaranteed_soul_grinders = cm:get_characters_bonus_value(character, "kho_spawned_army_guaranteed_soul_grinders")
		local guaranteed_bloodletters = cm:get_characters_bonus_value(character, "kho_spawned_army_guaranteed_bloodletters")
		local guaranteed_chaos_warriors = cm:get_characters_bonus_value(character, "kho_spawned_army_guaranteed_chaos_warriors")
		local guaranteed_hounds = cm:get_characters_bonus_value(character, "kho_spawned_army_bonus_flesh_hounds")

		local bonus_initial_bundle_duration = cm:get_characters_bonus_value(character, "kho_spawned_army_initial_attrition_immunity_duration_mod")

		local ram = random_army_manager;
		ram:remove_force("kho_summoned_army");
		ram:new_force("kho_summoned_army");
		
		ram:add_mandatory_unit("kho_summoned_army", "wh3_main_kho_inf_flesh_hounds_of_khorne_0", 1)
		ram:add_mandatory_unit("kho_summoned_army", "wh3_main_kho_inf_chaos_furies_0", 1)

		if guaranteed_bloodthirsters > 0 then
			ram:add_mandatory_unit("kho_summoned_army", "wh3_main_kho_mon_bloodthirster_0", guaranteed_bloodthirsters)
			bonus_size = bonus_size + guaranteed_bloodthirsters
		end

		if guaranteed_soul_grinders > 0 then
			ram:add_mandatory_unit("kho_summoned_army", "wh3_main_kho_mon_soul_grinder_0", guaranteed_soul_grinders)
			bonus_size = bonus_size + guaranteed_soul_grinders
		end

		if guaranteed_chaos_warriors > 0 then
			ram:add_mandatory_unit("kho_summoned_army", "wh3_main_kho_inf_chaos_warriors_0", guaranteed_chaos_warriors)
			bonus_size = bonus_size + guaranteed_chaos_warriors
		end

		if guaranteed_hounds > 0 then
			ram:add_mandatory_unit("kho_summoned_army", "wh3_main_kho_inf_flesh_hounds_of_khorne_0", guaranteed_hounds)
			bonus_size = bonus_size + guaranteed_hounds
		end

		if cm:get_factions_bonus_value(faction_key, "kho_spawned_army_bloodletter_upgrade") > 0 then
			ram:add_mandatory_unit("kho_summoned_army", "wh3_main_kho_inf_bloodletters_1", 4 + guaranteed_bloodletters)
		else
			ram:add_mandatory_unit("kho_summoned_army", "wh3_main_kho_inf_bloodletters_0", 4 + guaranteed_bloodletters)
		end

		if guaranteed_bloodletters > 0 then
			bonus_size = bonus_size + guaranteed_bloodletters
		end
		
		if spawned_by_bonus_value then
			local cloak_of_skulls_bonus_size = cm:get_factions_bonus_value(faction_key, "kho_spawned_army_skulltaker_army_size_mod")

			if cloak_of_skulls_bonus_size > 0 then
				bonus_size = bonus_size + cloak_of_skulls_bonus_size
			end
		end

		ram:add_unit("kho_summoned_army", "wh3_main_kho_inf_chaos_furies_0", 10)
		ram:add_unit("kho_summoned_army", "wh3_main_kho_veh_blood_shrine_0", 10)
		ram:add_unit("kho_summoned_army", "wh3_main_kho_inf_flesh_hounds_of_khorne_0", 10)
		ram:add_unit("kho_summoned_army", "wh3_main_kho_inf_bloodletters_1", 5)
		ram:add_unit("kho_summoned_army", "wh3_main_kho_mon_spawn_of_khorne_0", 5)
		ram:add_unit("kho_summoned_army", "wh3_main_kho_veh_skullcannon_0", 5)
		ram:add_unit("kho_summoned_army", "wh3_main_kho_cav_bloodcrushers_0", 2)
		ram:add_unit("kho_summoned_army", "wh3_main_kho_mon_soul_grinder_0", 2)
		ram:add_unit("kho_summoned_army", "wh3_main_kho_mon_bloodthirster_0", 1)

		local army_size = math.clamp(self.spawned_army_size + bonus_size, 1, 19)
		local unit_list = ram:generate_force("kho_summoned_army", army_size, false)
		local subtype = self.spawned_army_general_subtype

		if spawned_by_skull_throne and cm:get_factions_bonus_value(faction_key, "kho_spawned_army_skull_throne_blood_host_bloodthirster") > 0 then
			subtype = self.spawned_army_upgraded_general_subtype
		end

		cm:create_force_with_general(
			faction_key,
			unit_list,
			cm:model():world():region_manager():region_list():item_at(1):name(),
			x,
			y,
			"general",
			subtype,
			"",
			"",
			"",
			"",
			false,
			function(cqi)
				cm:apply_effect_bundle_to_characters_force(self.spawned_army_starting_bundle_key, cqi, 0)
				cm:apply_effect_bundle_to_characters_force(self.spawned_army_post_battle_bundle_key, cqi, self.spawned_army_initial_bundle_duration + bonus_initial_bundle_duration);
			end
		);

		-- remove the skull throne bonus if it's active
		if faction:has_effect_bundle("wh3_dlc26_ritual_kho_the_skull_throne_1_2") then
			cm:remove_effect_bundle("wh3_dlc26_ritual_kho_the_skull_throne_1_2", faction_key)
		end
	end;
end;

function khorne_spawned_armies:get_effect_bundle_duration_remaining(force)
	if not force:has_effect_bundle(self.spawned_army_post_battle_bundle_key) then
		return 0;
	end;

	local bundle_list = force:effect_bundles();

	for i, bundle in model_pairs(bundle_list) do
		if bundle:key() == self.spawned_army_post_battle_bundle_key then
			return bundle:duration();
		end;
	end;
end;