malus_sanity = {
	faction_key = "wh2_main_def_hag_graef",
	rite_key = "wh2_dlc14_ritual_def_warmaster",
	ui_key = "posession_orb",
	potion_button = "malus_potion",
	sanity_key = "def_malus_sanity",
	sanity_per_turn = 1,
	garrison_decline = -1,
	medicine_decline = -10,

	elixir_cost = {
		current = 1,
		base = 1,
		easy = 200,
		normal = 400,
		hard = 500,
		very_hard = 600,
		mod = 0.04
	},

	factors = {
		deterioration = "wh2_dlc14_resource_factor_sanity_deterioration",
		in_settlement = "wh2_dlc14_resource_factor_sanity_in_settlement",
		medication = "wh2_dlc14_resource_factor_sanity_medication",
		ability = "wh2_dlc14_resource_factor_sanity_battle_ability"
	},

	elixir_mission_key = "wh2_dlc14_mortal_empires_elixir_objective",

	abilities = {
		"wh2_dlc14_lord_abilities_tzarkan_spite",
		"wh2_dlc14_lord_abilities_tzarkan"
	},

	effects = {
		ai = "wh2_dlc14_pooled_resource_malus_sanity_ai",
		sanity_7 = "wh2_dlc14_pooled_resource_malus_sanity_7",
		sanity_5 = "wh2_dlc14_pooled_resource_malus_sanity_5",
		sanity_6 = "wh2_dlc14_pooled_resource_malus_sanity_6",
		sanity_1 = "wh2_dlc14_pooled_resource_malus_sanity_1",
		sanity_4_character = "wh2_dlc14_pooled_resource_malus_sanity_4_character",
		sanity_5_character = "wh2_dlc14_pooled_resource_malus_sanity_5_character",
		sanity_6_character = "wh2_dlc14_pooled_resource_malus_sanity_6_character",
		sanity_7_character = "wh2_dlc14_pooled_resource_malus_sanity_7_character"
	},

	ability_cost = 2
}


function malus_sanity:add_malus_sanity_listeners()
	out("#### Adding Malus Sanity Listeners ####");
	if cm:is_new_game() == true then
		local malus_faction = cm:get_faction(self.faction_key);
		local difficulty = cm:get_difficulty()
		local malus_character = malus_faction:faction_leader();

		if difficulty == 1 then
			self.elixir_cost.base = self.elixir_cost.easy
		elseif difficulty == 2 then
			self.elixir_cost.base = self.elixir_cost.normal
		elseif difficulty == 3 then
			self.elixir_cost.base = self.elixir_cost.hard
		else
			self.elixir_cost.base = self.elixir_cost.very_hard
		end

		if malus_faction and malus_faction:is_null_interface() == false and malus_faction:is_human() then
			self:modify_sanity(self.factors.deterioration, 10);
			self:update_ui();
			cm:trigger_mission(self.faction_key,self.elixir_mission_key,true);
		else 
			self:modify_sanity(self.factors.deterioration, 10);
			cm:remove_effect_bundle(self.effects.sanity_7, self.faction_key);
			cm:apply_effect_bundle_to_character(self.effects.ai, malus_character, 0);
		end
	end

	core:add_listener(
		"turn_start_actions",
		"ScriptEventHumanFactionTurnStart",
		function(context)
			local faction = context:faction()

			return faction:name() == self.faction_key and faction:is_human();
		end,
		function(context)
			local faction = cm:get_faction(self.faction_key)
			local malus_character = faction:faction_leader();

			if malus_character:in_settlement() == true then
				self:modify_sanity(self.factors.in_settlement, self.garrison_decline);
			end

			self:modify_sanity(self.factors.deterioration, self.sanity_per_turn);

			self:update_effects(faction);
			self:update_ui();
		end,
		true
	);

	core:add_listener(
		"battle_completed",
		"BattleCompleted",
		true,
		function(context)
			local pending_battle = cm:model():pending_battle()

			if pending_battle:has_been_fought() == true then
				local malus_faction_cqi = 0;

				for i = 1, cm:pending_battle_cache_num_attackers() do
					local attacker_cqi, attacker_force_cqi, attacker_name = cm:pending_battle_cache_get_attacker(i);

					if attacker_name == self.faction_key then
						malus_faction_cqi = attacker_cqi;
						break;
					end
				end

				if malus_faction_cqi == 0 then
					for i = 1, cm:pending_battle_cache_num_defenders() do
						local defender_cqi, defender_force_cqi, defender_name = cm:pending_battle_cache_get_defender(i);

						if defender_name == self.faction_key then
							malus_faction_cqi = defender_cqi;
							break;
						end
					end
				end
				if malus_faction_cqi > 0 then
					local faction = cm:get_faction(self.faction_key);
					local tzarkan_used = 0
					local possession = faction:pooled_resource_manager():resource(self.sanity_key);

					for i = 1, #self.abilities do
						tzarkan_used = tzarkan_used + pending_battle:get_how_many_times_ability_has_been_used_in_battle(faction:command_queue_index(), self.abilities[i])
					end

					if tzarkan_used > 0 then
						self:modify_sanity(self.factors.ability, self.ability_cost)
					end
					
					if possession:value() >= 10 then
						core:trigger_event("ScriptEventMalusPossessedPostBattle");
					end
					if cm:turn_number() <= 2 then
						core:trigger_event("ScriptEventFireElixirEGMission");
					end
				end
			end
		end,
		true
	);

	core:add_listener(
		"sanity_ComponentLClickUp",
		"ComponentLClickUp",
		function(context)
			if context.string == "round_small_button" then
				local component = UIComponent(context.component);
				local parent = UIComponent(component:Parent());

				if parent:Id() == self.potion_button then
					return true;
				end
			end
			return false;
		end,
		function(context)
			local local_faction = cm:get_local_faction_name(true);
			local faction = cm:get_faction(local_faction);
			local faction_cqi = faction:command_queue_index();
			CampaignUI.TriggerCampaignScriptEvent(faction_cqi, "sanity_potion");
			core:trigger_event("ScriptEventElixirButtonClicked");
		end,
		true
	);

	core:add_listener(
		"sanity_UITrigger",
		"UITrigger",
		function(context)
			return context:trigger() == "sanity_potion";
		end,
		function(context)
			local faction = cm:model():faction_for_command_queue_index(context:faction_cqi());

			self:modify_sanity(self.factors.medication, self.medicine_decline);
			self:update_effects(faction);
			self:update_ui();
		end,
		true
	);

	core:add_listener(
		"dust_RitualCompletedEvent",
		"RitualCompletedEvent",
		function(context)
			return context:ritual():ritual_key() == "wh2_dlc14_malus_call_tzarkan";
		end,
		function(context)
			local faction = context:performing_faction();

			self:update_effects(faction);
		end,
		true
	);

	core:add_listener(
		"sanity_RegionFactionChangeEvent",
		"RegionFactionChangeEvent",
		function(context)
			local region = context:region();
			local owner = region:owning_faction():name();
			local previous_faction = context:previous_faction():name();

			return owner == self.faction_key or previous_faction == self.faction_key;
		end,
		function(context)
			self:update_ui();
		end,
		true
	);

	core:add_listener(
		"sanity_MissionSucceeded",
		"MissionSucceeded",
		function(context)
			return context:mission():mission_record_key() == self.elixir_mission_key;
		end,
		function(context)
			self.elixir_cost.base = 0;
			self:update_ui();
		end,
		true
	)

	local current_faction = cm:get_faction(self.faction_key)
	if current_faction and current_faction:is_null_interface() == false and current_faction:is_human() then
		local faction = current_faction
		self:update_effects(faction);
	end

end

function malus_sanity:update_effects(faction)
	local malus_character = faction:faction_leader();
	
	cm:remove_effect_bundle_from_character(self.effects.sanity_4_character, malus_character);
	cm:remove_effect_bundle_from_character(self.effects.sanity_5_character, malus_character);
	cm:remove_effect_bundle_from_character(self.effects.sanity_6_character, malus_character);
	cm:remove_effect_bundle_from_character(self.effects.sanity_7_character, malus_character);

	local active_effect = faction:pooled_resource_manager():resource(self.sanity_key):active_effect(0);

	if active_effect == self.effects.sanity_5 then
		cm:apply_effect_bundle_to_character(self.effects.sanity_5_character, malus_character, 0);
		cm:lock_ritual(faction, self.rite_key);
	elseif active_effect == self.effects.sanity_6 then
		cm:apply_effect_bundle_to_character(self.effects.sanity_6_character, malus_character, 0);
		cm:lock_ritual(faction, self.rite_key);
	elseif active_effect == self.effects.sanity_7 then
		cm:apply_effect_bundle_to_character(self.effects.sanity_7_character, malus_character, 0);
		cm:lock_ritual(faction, self.rite_key);
	elseif active_effect == self.effects.sanity_1 then
		cm:apply_effect_bundle_to_character(self.effects.sanity_4_character, malus_character, 0);
		self:unlock_warmaster();
	else
		cm:apply_effect_bundle_to_character(self.effects.sanity_4_character, malus_character, 0);
		cm:lock_ritual(faction, self.rite_key);
	end

	self:update_ui();
end

function malus_sanity:modify_sanity(factor, amount)
	cm:faction_add_pooled_resource(self.faction_key, self.sanity_key, factor, amount);
end

function malus_sanity:update_ui()
	local turn_number = cm:model():turn_number();
	local malus_faction = cm:get_faction(self.faction_key);
	local ui_root = core:get_ui_root();
	local sanity_ui = find_uicomponent(ui_root, self.ui_key);
	local button_ui = find_uicomponent(ui_root, self.potion_button);

	if self.elixir_cost.base ~= 0 then
		if malus_faction:is_null_interface() == false and malus_faction:is_dead() == false then
			local region_count = malus_faction:region_list():num_items();

			self.elixir_cost.current = self.elixir_cost.base + ((region_count - 1) + (turn_number - 1)) / self.elixir_cost.mod;
			self.elixir_cost.current = math.ceilTo(self.elixir_cost.current, 5);
		else
			self.elixir_cost.current = 999;
		end
	else
		self.elixir_cost.current = 0
	end

	if sanity_ui then
		sanity_ui:InterfaceFunction("UpdateDisplay");
	end
	if button_ui then
		button_ui:InterfaceFunction("UpdateDisplay", self.elixir_cost.current);
	end
end

function malus_sanity:unlock_warmaster()
	cm:unlock_ritual(cm:get_faction(self.faction_key), self.rite_key);
	cm:callback(function()
		cm:show_message_event(
			self.faction_key,
			"event_feed_strings_text_wh2_event_feed_string_scripted_event_rite_unlocked_primary_detail",
			"rituals_display_name_" .. self.rite_key,
			"event_feed_strings_text_wh2_event_feed_string_scripted_event_rite_unlocked_secondary_detail_" .. self.rite_key,
			true,
			811,
			nil,
			nil,
			true
		);
	end, 0.2);
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("malus_sanity", malus_sanity.elixir_cost.base, context);
	end
);
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			malus_sanity.elixir_cost.base = cm:load_named_value("malus_sanity", malus_sanity.elixir_cost.base, context);
		end
	end
);