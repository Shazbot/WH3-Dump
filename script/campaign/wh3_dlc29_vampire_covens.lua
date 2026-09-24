vampire_covens = {
	neferata_faction = "wh3_dlc29_vmp_neferata",
	coven_key = "wh3_dlc29_slot_set_vampire_coven",
	coven_template = "wh3_dlc29_vampire_coven",
	concealment_resource_key = "wh3_dlc29_nef_concealment",
	corpse_resource_key = "wh3_dlc29_vmp_corpses",
	starting_coven_region = "", -- wh3_main_combi_region_silver_pinnacle, wh3_dlc23_combi_region_blasted_expanse, wh3_main_combi_region_khazid_irkulaz
	coven_starting_building = "wh3_dlc29_nef_coven_main_1",
	handmaiden_spawn_buildings = {
		["wh3_dlc29_nef_coven_handmaiden_training_1"] = true,
		["wh3_dlc29_nef_coven_handmaiden_training_2"] = true
	},
	handmaiden_tracker = {}
};

function vampire_covens:initialise()
	self:add_listeners();

	if cm:is_new_game() == true then
		if self.starting_coven_region ~= "" then
			local region = cm:get_region(self.starting_coven_region);
			self:create_coven(region);
		end
	end
end

function vampire_covens:create_coven(region)
	local neferata = cm:get_faction(self.neferata_faction);
	local slot_manager = cm:add_foreign_slot_set_to_region_for_faction(neferata:command_queue_index(), region:cqi(), self.coven_key);

	if slot_manager:is_null_interface() == false then
		local slots = slot_manager:slots();

		for _, slot in model_pairs(slots) do
			if slot:template_key() == "wh3_dlc29_vampire_coven_primary" then
				cm:foreign_slot_instantly_upgrade_building(slot, self.coven_starting_building);
				break;
			end
		end

		self:update_region_owner_effects(region);
		cm:set_script_state(region, "coven_concealment_loss", true);
	end
end

function vampire_covens:update_region_owner_effects(region, has_prevention)
	local region_owner_key = region:owning_faction():name();
	local province = region:province();

	for _, province_region in model_pairs(province:regions()) do
		for _, character in model_pairs(province_region:characters_in_region()) do
			if character:faction():name() == region_owner_key then
				if has_prevention then
					if character:has_effect_bundle("wh3_main_effect_causes_concealment_loss_dummy") then
						cm:remove_effect_bundle_from_character("wh3_main_effect_causes_concealment_loss_dummy", character);
					end
				else
					cm:apply_effect_bundle_to_character("wh3_main_effect_causes_concealment_loss_dummy", character, 1);
				end
			end
		end
	end
end

function vampire_covens:clear_region_concealment_effects(region)
	local province = region:province();

	for _, province_region in model_pairs(province:regions()) do
		for _, character in model_pairs(province_region:characters_in_region()) do
			if character:has_effect_bundle("wh3_main_effect_causes_concealment_loss_dummy") then
				cm:remove_effect_bundle_from_character("wh3_main_effect_causes_concealment_loss_dummy", character);
			end
		end
	end

	cm:set_script_state(region, "coven_concealment_loss", false);
end

function vampire_covens:recruit_handmaiden(faction, region)
	local faction_key = faction:name();
	local region_key = region:name();
	local x, y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, region_key, false, true, 2);

	if x > -1 and y > -1 then
		local incident_key = "wh3_dlc29_vmp_incident_handmaiden_recruited";
		local handmaiden_recruited = "dummy_coven_handmaiden_recruited";
		local handmaiden_status = nil;

		local agent = vampire_handmaidens:spawn_handmaiden(faction, x, y); -- Call to different script
		local character_cqi = agent:command_queue_index();
		local wound_chance = cm:get_regions_bonus_value(region, "coven_wound_handmaiden_chance_recruit") or 0;

		if wound_chance > 0 and cm:model():random_percent(wound_chance) == true then
			cm:wound_character(cm:char_lookup_str(character_cqi), 3);
			handmaiden_status = "dummy_coven_handmaiden_wounded_recruited";
		end

		self:shown_event(faction, agent, region, incident_key, handmaiden_recruited, handmaiden_status);
	end
end

function vampire_covens:coven_removed(faction, region, reason)
	local faction_key = faction:name();
	local region_key = region:name();
	local character_cqi = self.handmaiden_tracker[region_key];
	self.handmaiden_tracker[region_key] = nil;

	if character_cqi == nil then
		script_error("ERROR: Vampire Covens - Handmaiden event fired with no associated Character CQI found - this should be impossible! Contact Mitch");
		return false;
	end

	local character = cm:get_character_by_cqi(character_cqi);

	if not character or character:is_null_interface() then
		script_error("ERROR: Vampire Covens - Handmaiden event fired with a null character - this should be impossible! Contact Mitch");
		return false;
	end

	local x, y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, region_key, false, true, 2);

	if x > -1 and y > -1 then
		local character_str = cm:char_lookup_str(character_cqi);
		cm:leave_limbo(character_str, x, y, true);
		cm:replenish_action_points(character_str);

		local incident_key = "";
		local coven_status = "";
		local handmaiden_status = "";

		if reason == "RAZED" then
			incident_key = "wh3_dlc29_vmp_incident_coven_razed";
			coven_status = "dummy_coven_destroyed";
			handmaiden_status = "dummy_coven_handmaiden_escaped";

			if faction:has_technology("wh3_dlc29_tech_nef_covens_2b") == false then
				local escape_chance = character:bonus_values():scripted_value("handmaiden_escape_chance", "value");

				if escape_chance == 0 or cm:model():random_percent(escape_chance) == false then
					cm:disable_event_feed_events(true, "wh_event_category_character", "", "");
					cm:kill_character(character_cqi, false);
					cm:disable_event_feed_events(false, "wh_event_category_character", "", "");
					handmaiden_status = "dummy_coven_handmaiden_killed";
				end
			end

		elseif reason == "ESCAPE" then
			incident_key = "wh3_dlc29_vmp_incident_coven_escape";
			coven_status = "dummy_coven_abandoned";
			handmaiden_status = "dummy_coven_handmaiden_escaped";

			local wound_chance = cm:get_regions_bonus_value(region, "coven_wound_handmaiden_chance_return") or 0;

			if wound_chance > 0 and cm:model():random_percent(wound_chance) == true then
				cm:wound_character(cm:char_lookup_str(character_cqi), 3);
				handmaiden_status = "dummy_coven_handmaiden_wounded_escaped";
			end
		elseif reason == "OCCUPIED" then
			-- Player occupied the region
			incident_key = "wh3_dlc29_vmp_incident_coven_occupied";
			coven_status = "dummy_coven_abandoned";
			handmaiden_status = "dummy_coven_handmaiden_returned";
		else
			-- Fallback for unknown reason
			incident_key = "wh3_dlc29_vmp_incident_coven_lost";
			coven_status = "dummy_coven_lost";
			handmaiden_status = "dummy_coven_handmaiden_returned";
		end

		self:shown_event(faction, character, region, incident_key, coven_status, handmaiden_status);
	end
end

function vampire_covens:shown_event(faction, character, region, incident_key, payload1, payload2)
	local incident_builder = cm:create_incident_builder(incident_key);
	
	if character and character:is_null_interface() == false then
		incident_builder:add_target("default", character:family_member());
	end
	if region and region:is_null_interface() == false then
		incident_builder:add_target("target_region_1", region);
	end

	if payload1 or payload2 then
		local payload_builder = cm:create_payload();
		if payload1 then
			payload_builder:text_display(payload1);
		end
		if payload2 then
			payload_builder:text_display(payload2);
		end
		incident_builder:set_payload(payload_builder);
		payload_builder:clear();
	end

	cm:launch_custom_incident_from_builder(incident_builder, faction);
end

function vampire_covens:add_listeners()
	core:add_listener(
		"VampireCovensCovenCreated",
		"ForeignSlotManagerCreatedEvent",
		function(context)
			local slot_manager = context:new_slot_manager();
			local first_slot = slot_manager:slots():item_at(0);
			local slot_template = first_slot:template_key();
			return context:requesting_faction():name() == self.neferata_faction and slot_template:starts_with(self.coven_template);
		end,
		function(context)
			local slot_manager = context:new_slot_manager();
			local faction = context:requesting_faction();
			local region = context:region();
			local province = region:province();
			local handmaiden_cqi = self.handmaiden_tracker[region:name()];

			if handmaiden_cqi == nil then
				script_error("ERROR: Vampire Covens - Handmaiden event fired with no associated Character CQI found - this should be impossible! Contact Mitch");
				return false;
			end

			local handmaiden = cm:get_character_by_cqi(handmaiden_cqi);

			if not handmaiden or handmaiden:is_null_interface() then
				script_error("ERROR: Vampire Covens - Handmaiden event fired with a null character - this should be impossible! Contact Mitch");
				return false;
			end

			self:update_region_owner_effects(region);
			cm:set_script_state(region, "coven_concealment_loss", true);

			local pooled_resource_manager = cm:get_or_create_faction_province_persistent_pooled_resource_manager(faction, province);

			if pooled_resource_manager:is_null_interface() == false then
				local concealment_resource = pooled_resource_manager:resource(self.concealment_resource_key);

				if concealment_resource:is_null_interface() == false then
					local base_concealment = cm:get_factions_bonus_value(faction, "concealment_starting_amount");
					base_concealment = math.max(base_concealment, 10); -- Safety net, anything that less than 10 and Covens are in trouble
					
					if handmaiden:has_trait("wh3_trait_dlc29_imentet_2") or handmaiden:has_trait("wh3_trait_dlc29_naaima_2") then
						base_concealment = base_concealment + 30;
					end

					local current_value = concealment_resource:value();

					if current_value < base_concealment then
						-- Bring concealment at least up the base value of new covens
						local added_concealment = -current_value + base_concealment;
						cm:pooled_resource_factor_transaction(concealment_resource, "hidden", added_concealment);
					end
				end
			end

			if slot_manager:is_null_interface() == false then
				local slots = slot_manager:slots();

				for _, slot in model_pairs(slots) do
					if slot:template_key() == "wh3_dlc29_vampire_coven_primary" then
						if handmaiden:has_trait("wh3_trait_dlc29_imentet_2") or handmaiden:has_trait("wh3_trait_dlc29_heterneb_2") then
							cm:foreign_slot_instantly_upgrade_building(slot, "wh3_dlc29_nef_coven_main_extra_1");
						else
							cm:foreign_slot_instantly_upgrade_building(slot, self.coven_starting_building);
						end
						break;
					end
				end
			end
			
			if handmaiden:has_trait("wh3_trait_dlc29_giselle_2") then
				-- Diplomacy boost - each is +30
				local region_owner_key = region:owning_faction():name();
				cm:apply_dilemma_diplomatic_bonus(self.neferata_faction, region_owner_key, 6);
				cm:apply_dilemma_diplomatic_bonus(self.neferata_faction, region_owner_key, 6);
				cm:apply_dilemma_diplomatic_bonus(self.neferata_faction, region_owner_key, 6);
				cm:apply_dilemma_diplomatic_bonus(self.neferata_faction, region_owner_key, 6);
			end
			
			if handmaiden:has_trait("wh3_trait_dlc29_lycindia_2") then
				-- Add Corpses
				if pooled_resource_manager:is_null_interface() == false then
					local corpse_resource = pooled_resource_manager:resource(self.corpse_resource_key);

					if corpse_resource:is_null_interface() == false then
						cm:pooled_resource_factor_transaction(corpse_resource, "hidden", 5000);
					end
				end
			end
			
			if handmaiden:has_trait("wh3_trait_dlc29_bellatash_2") then
				-- Climate change
				cm:apply_effect_bundle_to_region("wh3_main_bundle_region_vampiric_climate", region:name(), 0);
				climate_change:add_climate_override(region, "vampire_corpses");
			end
		end,
		true
	);
	core:add_listener(
		"VampireCovensHandmaidenAction",
		"CharacterGarrisonTargetAction",
		function(context)
			return context:agent_action_key() == "wh3_dlc29_agent_action_engineer_hinder_settlement_establish_coven";
		end,
		function(context)
			local region = context:garrison_residence():region();
			local region_key = region:name();
			local coven = region:foreign_slot_manager_for_faction(self.neferata_faction, self.coven_key);
			local character = context:character();
			local character_cqi = character:command_queue_index();
			local character_str = cm:char_lookup_str(character_cqi);
			cm:enter_limbo(character_str);
			-- Associate this character with this region and track it
			self.handmaiden_tracker[region_key] = character_cqi;
			core:trigger_event("ScriptEventVampireCovenCreated", character, region);
		end,
		true
	);
	core:add_listener(
		"VampireCovensSpawnHandmaiden",
		"ForeignSlotBuildingCompleteEvent",
		function(context)
			local building_key = context:building();
			return self.handmaiden_spawn_buildings[building_key];
		end,
		function(context)
			local slot_manager = context:slot_manager();
			local faction = slot_manager:faction();
			local region = slot_manager:region();
			self:recruit_handmaiden(faction, region);
		end,
		true
	);
	core:add_listener(
		"VampireCovenRazed",
		"ForeignSlotManagerRemovedEvent",
		function(context)
			return context:owner():name() == self.neferata_faction and context:slot_set_key() == self.coven_key;
		end,
		function(context)
			local faction = context:owner();
			local region = context:region();
			local was_razed = context:cause_was_razing();
			local reason = context:reason(); -- allied_slots_added, war_declared, feature_match, script_command, cli_command, faction_destroyed, region_transfer, paid_removal, razed, destroyed, transfer_failed

			self:clear_region_concealment_effects(region);

			if was_razed == true then
				self:coven_removed(faction, region, "RAZED");
			elseif reason == "script_command" then -- Player has built the escape building
				self:coven_removed(faction, region, "ESCAPE");
			elseif reason == "region_transfer" then -- Player has occupied the region
				self:coven_removed(faction, region, "OCCUPIED")
			else
				self:coven_removed(faction, region, "OTHER");
			end
		end,
		true
	);
	core:add_listener(
		"VampireCovensFactionTurnStart",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == self.neferata_faction;
		end,
		function(context)
			-- We wait for turn start and not on the building completion event because inside the building completion event we cannot destroy the foreign slot (else crash)
			local faction = context:faction();
			local foreign_slot_managers = faction:foreign_slot_managers();

			for fsm_index = 0, foreign_slot_managers:num_items() - 1 do
				local fsm = foreign_slot_managers:item_at(fsm_index);
				local region = fsm:region();
				local slot_list = fsm:slots();
				local should_destroy = false;

				for slot_index = 0, slot_list:num_items() - 1 do
					local building_slot = slot_list:item_at(slot_index);

					if building_slot:has_building() == true then
						local building_key = building_slot:building();

						if building_key == "wh3_dlc29_nef_coven_handmaiden_escape_1" then
							should_destroy = true;
							break;
						end
					end
				end

				if should_destroy == true then
					cm:remove_faction_foreign_slots_from_region(faction:command_queue_index(), region:cqi());
				else
					local is_coven = false;
					local has_prevention = false;

					for _, slot in model_pairs(slot_list) do
						if slot:has_building() and slot:building() == "wh3_dlc29_nef_coven_concealment_bonus_1_2b" then
							is_coven = true;
							has_prevention = true;
							out("has prevention")
							break;
						elseif slot:template_key() == "wh3_dlc29_vampire_coven_primary" then
							is_coven = true;
						end
					end

					if is_coven == true then
						self:update_region_owner_effects(region, has_prevention);
					end
					cm:set_script_state(region, "coven_concealment_loss", not has_prevention);
				end
			end
		end,
		true
	);
	core:add_listener(
		"CharacterFinishedMovingEventCovens",
		"CharacterFinishedMovingEvent",
		function(context)
			local character = context:character();
			return character:has_region() and character:has_effect_bundle("wh3_main_effect_causes_concealment_loss_dummy");
		end,
		function(context)
			local character = context:character();
			local region = character:region():province():capital_region();
			local coven = region:foreign_slot_manager_for_faction(self.neferata_faction, self.coven_key);

			if coven:is_null_interface() then
				cm:remove_effect_bundle_from_character("wh3_main_effect_causes_concealment_loss_dummy", character);
			end
		end,
		true
	);
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("vampire_covens_handmaiden_tracker", vampire_covens.handmaiden_tracker, context);
	end
);
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			vampire_covens.handmaiden_tracker = cm:load_named_value("vampire_covens_handmaiden_tracker", vampire_covens.handmaiden_tracker, context);
		end
	end
);