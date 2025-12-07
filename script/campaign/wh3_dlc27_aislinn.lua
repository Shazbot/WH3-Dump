aislinn_narrative = {
	faction_key = "wh3_dlc27_hef_aislinn",
	narrative_state = 0,
	dragonship_count = 1,
	confed_faction_key = "wh3_dlc27_hef_aislinn_confederation_owner",
	pirate_faction_key = "wh3_main_cst_dread_rock_privateers",
	black_ark_faction_key = "wh2_dlc11_def_dark_elves_dil",
	black_ark_pos_x = 924,
	black_ark_pos_y = 144,
	final_battle_lords = {
		tyrion = 0,
		alarielle = 0,
		alith_anar = 0,
		teclis = 0,
		eltharion = 0,
		imrik = 0
	},
	trigger_final_battle_turn = 0,
	triggered_sea_lanes = false,
	ai_aislinn_unlock_turn = 9,
	ai_aislinn_unlock_chance = 25,
	ai_aislinn_unlocked = false
};

function aislinn_narrative:initialise()
	local aislinn = cm:get_faction(self.faction_key);

	if aislinn then
		-- Not all listeners are relevant for human Aislinn
		if aislinn:is_human() == true then
			self:add_listeners();
		else
			self:add_ai_listeners();
		end

		if cm:is_new_game() == true then
			if aislinn:is_human() == true then
				narrative_events.callback(
					"aislinn_turn_start_begin_narrative",
					self.faction_key,
					function()
						self:trigger_first_mission();
						self.narrative_state = 1;
					end,
					"StartPostHowTheyPlay"
				)
				cm:faction_add_pooled_resource(self.faction_key, "wh3_dlc27_hef_naval_supplies", "elven_colonies", 400);
				cm:faction_add_pooled_resource(self.faction_key, "wh3_dlc27_hef_aislinn_focus", "aislinn_outposts", 100);

				local teclis_home = cm:get_faction("wh2_main_hef_order_of_loremasters"):home_region():name();
				cm:make_region_seen_in_shroud(self.faction_key, teclis_home);
				local alith_anar_home = cm:get_faction("wh2_dlc15_hef_imrik"):home_region():name();
				cm:make_region_seen_in_shroud(self.faction_key, alith_anar_home);
				cm:make_diplomacy_available(self.faction_key, "wh2_main_hef_order_of_loremasters");
				cm:make_diplomacy_available(self.faction_key, "wh2_dlc15_hef_imrik");

				cm:disable_movement_for_faction(self.pirate_faction_key);
				cm:force_diplomacy("all", "faction:"..self.pirate_faction_key, "all", false, false, true);

				-- Making initial starting province visible
				cm:make_region_visible_in_shroud(self.faction_key, "wh3_main_combi_region_tor_elasor");
				cm:make_region_visible_in_shroud(self.faction_key, "wh3_main_combi_region_tower_of_the_sun");
				cm:make_region_visible_in_shroud(self.faction_key, "wh3_main_combi_region_tower_of_the_stars");
				cm:make_sea_region_visible_in_shroud(self.faction_key, "wh3_main_combi_region_the_eastern_isles");
			else
				-- We do some custom setup if Aislinn is an AI faction
				self:initital_ai_setup(aislinn);
			end
			
			-- Trespass immunity against other High Elves
			local hef_factions = cm:get_factions_by_culture("wh2_main_hef_high_elves");
			local aislinn_cqi = aislinn:command_queue_index();

			for _, faction in ipairs(hef_factions) do
				cm:add_trespass_permission(aislinn_cqi, faction:command_queue_index());
			end
		end
	end
end

function aislinn_narrative:initital_ai_setup(aislinn)
	out("initital_ai_setup")
	cm:disable_event_feed_events(true, "wh_event_category_conquest", "", "");
	cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "");

	-- Add colony capacity for AI
	cm:apply_effect_bundle("wh3_dlc27_victory_aislinn", self.faction_key, 0);
	cm:faction_add_pooled_resource(self.faction_key, "wh3_dlc27_hef_elven_colonies", "missions", 3);
	-- Give some starting resources
	cm:faction_add_pooled_resource(self.faction_key, "wh3_dlc27_hef_naval_supplies", "elven_colonies", 1000);
	cm:faction_add_pooled_resource(self.faction_key, "wh3_dlc27_hef_aislinn_focus", "aislinn_outposts", 500);
	
	-- Know Teclis
	local teclis_home = cm:get_faction("wh2_main_hef_order_of_loremasters"):home_region():name();
	cm:make_region_seen_in_shroud(self.faction_key, teclis_home);
	cm:make_diplomacy_available(self.faction_key, "wh2_main_hef_order_of_loremasters");

	-- Open Aislinns sea lanes
	self.triggered_sea_lanes = true;
	sea_lanes:open_aislinn_nodes();

	-- Gain starting province
	cm:transfer_region_to_faction("wh3_main_combi_region_tower_of_the_sun", self.faction_key);
	cm:transfer_region_to_faction("wh3_main_combi_region_tower_of_the_stars", self.confed_faction_key);
	cm:transfer_region_to_faction("wh3_main_combi_region_tor_elasor", self.confed_faction_key);

	-- Remove corruption
	cm:change_corruption_in_province_by("wh3_main_combi_province_eastern_colonies", nil, 100, "local_populace");

	-- Add outposts
	local outpost_regions = {"wh3_main_combi_region_tower_of_the_stars", "wh3_main_combi_region_tor_elasor"};

	for i = 1, #outpost_regions do
		local region = cm:get_region(outpost_regions[i]);
		cm:add_foreign_slot_set_to_region_for_faction(aislinn:command_queue_index(), region:cqi(), "wh3_dlc27_slot_set_hef_sea_patrol_outpost_focus_outposts");

		local fsm = region:foreign_slot_manager_for_faction(self.faction_key);

		if fsm:is_null_interface() == false then
			local slots = fsm:slots();
			cm:foreign_slot_instantly_upgrade_building(slots:item_at(0), "wh3_dlc27_hef_sea_patrol_outpost_defence_garrison_1");
			cm:foreign_slot_instantly_upgrade_building(slots:item_at(1), "wh3_dlc27_hef_sea_patrol_outpost_income_branch_1");
			cm:foreign_slot_instantly_upgrade_building(slots:item_at(2), "wh3_dlc27_hef_sea_patrol_outpost_focus_1");
		end
	end

	-- Teleport Aislinn
	local aislinn_character = aislinn:faction_leader();
	cm:teleport_to(cm:char_lookup_str(aislinn_character), 928, 132);
	-- Stop him moving
	cm:disable_movement_for_faction(self.faction_key);
	-- Embed Agent
	local character_list = aislinn:character_list();

	for i = 0, character_list:num_items() - 1 do
		local character = character_list:item_at(i);
		
		if character:character_subtype("wh3_dlc27_hef_mist_mage") == true then
			local aislinn_force = aislinn_character:military_force();
			cm:embed_agent_in_force(character, aislinn_force);
			break;
		end
	end
	-- Stop further war
	cm:force_diplomacy("faction:"..self.faction_key, "all", "war", false, true, false);
	
	-- Kill the remaining pirates
	local pirate_faction = cm:get_faction(self.pirate_faction_key);
	cm:kill_all_armies_for_faction(pirate_faction);

	cm:callback(
		function() 
			cm:disable_event_feed_events(false, "wh_event_category_conquest", "", "");
			cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "");
		end,
		0.5
	);
end

function aislinn_narrative:add_ai_listeners()
	-- Turn 10, send Aislinn through a sealane to Lustria
	-- If Aislinn isn't at war with anyone, find a pirate!
	core:add_listener(
		"AislinnAIWars",
		"FactionTurnStart", 
		function(context)
			local faction = context:faction();
			return faction and faction:name() == self.faction_key;
		end,
		function(context)
			local faction = context:faction();
			local turn_number = cm:turn_number();

			if self.ai_aislinn_unlocked == false then
				if turn_number >= self.ai_aislinn_unlock_turn and cm:model():random_percent(self.ai_aislinn_unlock_chance) then
					out("aislinn unlocked via turn - "..turn_number)
					self.ai_aislinn_unlocked = true;
					self.ai_aislinn_unlock_chance = self.ai_aislinn_unlock_chance + 10;
					local aislinn_character = faction:faction_leader();
					local ch_str = cm:char_lookup_str(aislinn_character);
					cm:enable_movement_for_faction(self.faction_key);
					cm:zero_action_points(ch_str);
					cm:teleport_to(ch_str, 295, 243);

					cm:force_declare_war(self.faction_key, "wh2_dlc11_cst_vampire_coast", true, true);
					cm:force_declare_war(self.faction_key, "wh2_main_skv_clan_spittel", true, true);
					cm:force_diplomacy("faction:"..self.faction_key, "all", "war", true, true, false);
				elseif faction:factions_at_war_with():is_empty() == false then
					out("aislinn unlocked via war - "..turn_number)
					self.ai_aislinn_unlocked = true;
					cm:enable_movement_for_faction(self.faction_key);
					cm:force_diplomacy("faction:"..self.faction_key, "all", "war", true, true, false);
				end
			elseif self.ai_aislinn_unlocked == true and faction:factions_at_war_with():is_empty() == true and (turn_number % 8 == 0) then
				local aislinn_character = faction:faction_leader();

				if aislinn_character:has_military_force() == true then
					local aislinn_pos_x = aislinn_character:logical_position_x();
					local aislinn_pos_y = aislinn_character:logical_position_y();
					local closest_pirate = nil;
					local cloests_pirate_dist = 0;
					local pirates = cm:get_factions_by_culture("wh2_dlc11_cst_vampire_coast");

					for i = 1, #pirates do
						local pirate = pirates[i];

						if pirate:is_null_interface() == false and pirate:is_dead() == false and pirate:has_home_region() == true then
							if faction:military_allies_with(pirate) == false and
							faction:defensive_allies_with(pirate) == false and
							faction:non_aggression_pact_with(pirate) == false and
							faction:military_access_pact_with(pirate) == false and
							faction:trade_agreement_with(pirate) == false then

								local home = pirate:home_region():settlement();
								local home_x = home:logical_position_x();
								local home_y = home:logical_position_y();
								local distance = distance_squared(aislinn_pos_x, aislinn_pos_y, home_x, home_y);

								if closest_pirate == nil or distance < cloests_pirate_dist then
									closest_pirate = pirate:name();
									cloests_pirate_dist = distance;
								end
							end
						end
					end

					if closest_pirate ~= nil then
						cm:force_declare_war(self.faction_key, closest_pirate, true, true);
						out("Forcing Aislinn War - "..closest_pirate)
					end
				end
			end
		end,
		true
	);
end

function aislinn_narrative:add_listeners()
	-- Early turns visibility and sea lane backup
	core:add_listener(
		"AislinnSeaLaneBackup",
		"FactionTurnStart", 
		function(context)
			local faction = context:faction();
			return faction and faction:name() == self.faction_key;
		end,
		function(context)
			local faction_key = context:faction():name();
			-- Always allow the player to see the whole province and the sea region for the first few turns
			if cm:turn_number() < 5 then
				cm:make_region_visible_in_shroud(self.faction_key, "wh3_main_combi_region_tor_elasor");
				cm:make_region_visible_in_shroud(self.faction_key, "wh3_main_combi_region_tower_of_the_sun");
				cm:make_region_visible_in_shroud(self.faction_key, "wh3_main_combi_region_tower_of_the_stars");
				cm:make_sea_region_visible_in_shroud(self.faction_key, "wh3_main_combi_region_the_eastern_isles");
			end

			-- If its turn 10 and the player hasn't done the missions they're doing something funky, so give them sea lanes
			if cm:turn_number() == 10 then
				self.triggered_sea_lanes = true;
				sea_lanes:open_aislinn_nodes();
				cm:make_sea_region_visible_in_shroud(self.faction_key, "wh3_main_combi_region_the_eastern_isles");

				cm:callback(
				function()
					if faction_key == cm:get_local_faction_name(true) then
						cm:scroll_camera_from_current(true, 2, {616.385193, 106.869225, 16.707603, 0.0, 13.465406});
					end
				end,
				0.5
				);
			end
		end,
		true
	);

	-- re-enable pirate movement after Aislinn's turn
	core:add_listener(
		"AislinnReenablePirateMovement",
		"FactionTurnEnd",
		function(context)
			return cm:turn_number() == 1 and context:faction():name() == self.faction_key
		end,
		function(context)
			cm:enable_movement_for_faction(self.pirate_faction_key)
		end,
		true
	)

	-- MISSION 1 - ESTABLISH OUTPOST
	core:add_listener(
		"AislinnEstablishOutpost",
		"ForeignSlotManagerCreatedEvent",
		true,
		function(context)
			if self.narrative_state == 1 then
				if context:requesting_faction():name() == self.faction_key then
					cm:set_active_mission_status_for_faction(cm:get_faction(self.faction_key),
						"wh3_dlc27_camp_narrative_hef_aislinn_mission_1", "SUCCEEDED");
						
					local target_region = cm:get_region("wh3_main_combi_region_tower_of_the_sun");
					local x = target_region:settlement():logical_position_x();
					local y = target_region:settlement():logical_position_y();
					
					local mm = mission_manager:new(self.faction_key, "wh3_dlc27_camp_narrative_hef_aislinn_mission_2");
					mm:set_mission_issuer("CLAN_ELDERS");
					mm:add_new_objective("SCRIPTED");
					mm:add_condition("script_key aislinn_establish_colony");
					mm:add_condition("override_text mission_text_text_wh3_dlc27_mission_narrative_hef_aislinn_establish_colony");
					mm:set_position(x, y);
					mm:add_payload("faction_pooled_resource_transaction{resource wh3_dlc27_hef_aislinn_focus;factor missions;amount 400;context absolute;}");
					mm:add_payload("faction_pooled_resource_transaction{resource wh3_dlc27_hef_naval_supplies;factor missions;amount 200;context absolute;}");
					mm:add_payload("faction_pooled_resource_transaction{resource wh3_dlc27_hef_elven_trade;factor missions;amount 100;context absolute;}");
					mm:trigger();
					
					self.narrative_state = 2;
				end
			end
		end,
		true
	);
	-- MISSION 2 - ESTABLISH COLONY
	core:add_listener(
		"AislinnEstablishColony",
		"RegionFactionChangeEvent",
		true,
		function(context)
			if self.narrative_state == 2 then
				if context:region():owning_faction():name() == self.faction_key then
					cm:set_active_mission_status_for_faction(cm:get_faction(self.faction_key),
						"wh3_dlc27_camp_narrative_hef_aislinn_mission_2", "SUCCEEDED");

					self.narrative_state = 3;
					
					local mm = mission_manager:new(self.faction_key, "wh3_dlc27_camp_narrative_hef_aislinn_mission_3");
					mm:set_mission_issuer("CLAN_ELDERS");
					mm:add_new_objective("DESTROY_FACTION");
					mm:add_condition("faction "..self.pirate_faction_key);
					mm:add_payload("faction_pooled_resource_transaction{resource wh3_dlc27_hef_naval_supplies;factor missions;amount 300;context absolute;}");
					mm:add_payload("effect_bundle{bundle_key wh3_dlc27_hef_aislinn_colony_reward;turns 1;}");
					mm:trigger();

					
				end
			end
		end,
		true
	);
	-- MISSION 3 - KILL PIRATES
	core:add_listener(
		"AislinnDestroyPirates",
		"FactionDeath",
		true,
		function(context)
			if self.narrative_state == 3 then
				if context:faction():name() == self.pirate_faction_key then
					cm:set_active_mission_status_for_faction(cm:get_faction(self.faction_key),
						"wh3_dlc27_camp_narrative_hef_aislinn_mission_3", "SUCCEEDED");
				end
			end
		end,
		true
	);

	core:add_listener(
		"AislinnPiratesDestroyedSuccess",
		"MissionSucceeded",
		function(context)
			local pirate_mission_success = context:mission():mission_record_key()
			return pirate_mission_success == "wh3_dlc27_camp_narrative_hef_aislinn_mission_3" and self.narrative_state == 3;
		end,
		function()
			self:spawn_black_ark();
			self.narrative_state = 4;
		end,
		true
	);
	
	-- MISSION 4 - KILL BLACK ARK
	core:add_listener(
		"AislinnDestroyBlackArk",
		"FactionDeath",
		true,
		function(context)
			if self.narrative_state == 4 then
				if context:faction():name() == self.black_ark_faction_key then
					cm:set_active_mission_status_for_faction(cm:get_faction(self.faction_key),
						"wh3_dlc27_camp_narrative_hef_aislinn_mission_4", "SUCCEEDED");

					sea_lanes:open_aislinn_nodes();
					cm:trigger_dilemma(self.faction_key, "wh3_dlc27_hef_aislinn_black_ark");
					self.narrative_state = 5;
				end
			end
		end,
		true
	);
	-- MISSION 5 - GAIN 5 DRAGONSHIPS
	core:add_listener(
		"AislinnGatherDragonshipsCounter",
		"ScriptEventNewDragonShipUnlocked",
		true,
		function(context)
			aislinn_narrative.dragonship_count = aislinn_narrative.dragonship_count + 1;

			if aislinn_narrative.dragonship_count == 2 then
				self:trigger_dragonship_dilemma(1);
			elseif aislinn_narrative.dragonship_count == 3 then
				self:trigger_dragonship_dilemma(2);
			elseif aislinn_narrative.dragonship_count == 4 then
				self:trigger_dragonship_dilemma(3);
			elseif aislinn_narrative.dragonship_count >= 5 then
				if self.narrative_state == 5 then
					cm:set_active_mission_status_for_faction(cm:get_faction(self.faction_key),
						"wh3_dlc27_camp_narrative_hef_aislinn_mission_5", "SUCCEEDED");
					self:trigger_dragonship_dilemma(4);
					self.trigger_final_battle_turn = cm:turn_number() + 3;
					self.narrative_state = 6;
				end
			end
		end,
		true
	);
	-- MISSION 6 - FINAL BATTLE
	core:add_listener(
		"AislinnFinalBattle",
		"FactionTurnStart",
		function(context)
			local faction = context:faction();
			return faction and faction:name() == self.faction_key
		end,
		function(context)
			if self.narrative_state == 6 then
				if cm:turn_number() >= self.trigger_final_battle_turn then
					cm:trigger_dilemma(self.faction_key, "wh3_dlc27_hef_aislinn_invasion_arrived");
					self.narrative_state = 7;
				end
			end
		end,
		true
	);
	-- VICTORY
	core:add_listener(
		"AislinnFinalBattleVictory",
		"MissionSucceeded",
		function(context)
			return context:mission():mission_record_key() == "wh3_dlc27_qb_ie_hef_aislinn_final_battle";
		end,
		function()
			cm:trigger_dilemma(self.faction_key, "wh3_dlc27_hef_aislinn_victory");
		end,
		true
	);
	-- DILEMMAS
	core:add_listener(
		"AislinnDilemmas",
		"DilemmaChoiceMadeEvent",
		true,
		function(context)
			local dilemma = context:dilemma();
			local choice = context:choice();
			
			if dilemma == "wh3_dlc27_hef_aislinn_invasion_arrived" then
				self:trigger_final_battle();
			elseif context:dilemma() == "wh3_dlc27_hef_aislinn_victory" then
				self:campaign_victory();
			elseif context:dilemma() == "wh3_dlc27_hef_aislinn_black_ark" then
				if choice == 0 then
					local target_faction = cm:get_faction("wh2_dlc15_grn_skull_crag");
					local mm = mission_manager:new(self.faction_key, "wh3_dlc27_camp_narrative_hef_aislinn_mission_ulthuan");
					mm:set_mission_issuer("CLAN_ELDERS");
					mm:add_new_objective("DESTROY_FACTION");
					mm:add_condition("faction wh2_dlc15_grn_skull_crag");
					mm:add_condition("faction wh2_main_def_cult_of_excess");
					mm:add_condition("faction wh3_main_sla_seducers_of_slaanesh");
					mm:add_condition("faction wh2_main_def_scourge_of_khaine");
					mm:add_payload("faction_pooled_resource_transaction{resource wh3_dlc27_hef_aislinn_focus;factor missions;amount 500;context absolute;}");
					mm:add_payload("faction_pooled_resource_transaction{resource wh3_dlc27_hef_naval_supplies;factor missions;amount 200;context absolute;}");
					mm:add_payload("faction_pooled_resource_transaction{resource wh3_dlc27_hef_elven_trade;factor missions;amount 200;context absolute;}");
					mm:add_payload("add_ancillary_to_faction_pool{ancillary_key wh3_dlc27_anc_enchanted_item_admirals_spyglass;}");
					mm:trigger();
					cm:make_sea_region_visible_in_shroud(self.faction_key, "wh3_main_combi_region_shifting_isles");
				elseif choice == 1 then
					local mm = mission_manager:new(self.faction_key, "wh3_dlc27_camp_narrative_hef_aislinn_mission_cathay");
					mm:set_mission_issuer("CLAN_ELDERS");
					mm:add_new_objective("DESTROY_FACTION");
					mm:add_condition("faction wh2_dlc11_def_the_blessed_dread");
					mm:add_condition("faction wh3_dlc21_cst_dead_flag_fleet");
					mm:add_condition("faction wh3_main_grn_dimned_sun");
					mm:add_payload("faction_pooled_resource_transaction{resource wh3_dlc27_hef_aislinn_focus;factor missions;amount 500;context absolute;}");
					mm:add_payload("faction_pooled_resource_transaction{resource wh3_dlc27_hef_naval_supplies;factor missions;amount 200;context absolute;}");
					mm:add_payload("faction_pooled_resource_transaction{resource wh3_dlc27_hef_elven_trade;factor missions;amount 200;context absolute;}");
					mm:add_payload("add_ancillary_to_faction_pool{ancillary_key wh3_dlc27_anc_enchanted_item_admirals_spyglass;}");
					mm:trigger();
					cm:make_sea_region_visible_in_shroud(self.faction_key, "wh3_main_combi_region_the_jade_sea");
					cm:make_sea_region_visible_in_shroud(self.faction_key, "wh3_main_combi_region_red_river");
				elseif choice == 2 then
					local mm = mission_manager:new(self.faction_key, "wh3_dlc27_camp_narrative_hef_aislinn_mission_lustria");
					mm:set_mission_issuer("CLAN_ELDERS");
					mm:add_new_objective("DESTROY_FACTION");
					mm:add_condition("faction wh2_dlc11_cst_vampire_coast");
					mm:add_condition("faction wh2_dlc11_cst_vampire_coast_rebels");
					mm:add_condition("faction wh2_main_skv_clan_spittel");
					mm:add_payload("faction_pooled_resource_transaction{resource wh3_dlc27_hef_aislinn_focus;factor missions;amount 500;context absolute;}");
					mm:add_payload("faction_pooled_resource_transaction{resource wh3_dlc27_hef_naval_supplies;factor missions;amount 200;context absolute;}");
					mm:add_payload("faction_pooled_resource_transaction{resource wh3_dlc27_hef_elven_trade;factor missions;amount 200;context absolute;}");
					mm:add_payload("add_ancillary_to_faction_pool{ancillary_key wh3_dlc27_anc_enchanted_item_admirals_spyglass;}");
					mm:trigger();
					cm:make_sea_region_visible_in_shroud(self.faction_key, "wh3_main_combi_region_the_vampire_coast_sea");
				elseif choice == 3 then
					local mm = mission_manager:new(self.faction_key, "wh3_dlc27_camp_narrative_hef_aislinn_mission_southlands");
					mm:set_mission_issuer("CLAN_ELDERS");
					mm:add_new_objective("DESTROY_FACTION");
					mm:add_condition("faction wh3_main_tze_oracles_of_tzeentch");
					mm:add_condition("faction wh3_main_skv_clan_morbidus");
					mm:add_condition("faction wh2_main_lzd_zlatan");
					mm:add_payload("faction_pooled_resource_transaction{resource wh3_dlc27_hef_aislinn_focus;factor missions;amount 500;context absolute;}");
					mm:add_payload("faction_pooled_resource_transaction{resource wh3_dlc27_hef_naval_supplies;factor missions;amount 200;context absolute;}");
					mm:add_payload("faction_pooled_resource_transaction{resource wh3_dlc27_hef_elven_trade;factor missions;amount 200;context absolute;}");
					mm:add_payload("add_ancillary_to_faction_pool{ancillary_key wh3_dlc27_anc_enchanted_item_admirals_spyglass;}");
					mm:trigger();
					cm:make_sea_region_visible_in_shroud(self.faction_key, "wh3_main_combi_region_the_churning_gulf");
				end

				local mm = mission_manager:new(self.faction_key, "wh3_dlc27_camp_narrative_hef_aislinn_mission_5");
				mm:set_mission_issuer("CLAN_ELDERS");
				mm:add_new_objective("SCRIPTED");
				mm:add_condition("script_key aislinn_gather_dragonships");
				mm:add_condition("override_text mission_text_text_wh3_dlc27_mission_narrative_hef_aislinn_gather_dragonships");
				mm:add_payload("text_display dummy_wh3_dlc27_aislinn_final_battle_reveal");
				mm:trigger();
			elseif context:dilemma() == "wh3_dlc27_hef_aislinn_dragonship_1" then
				if choice == 0 then
					self.final_battle_lords.tyrion = 1;
					self:create_outpost_at_capital_for_faction(context:faction(), "wh2_main_hef_eataine"); -- Tyrion
				else
					self.final_battle_lords.alarielle = 1;
					self:create_outpost_at_capital_for_faction(context:faction(), "wh2_main_hef_avelorn"); -- Alarielle
				end
			elseif context:dilemma() == "wh3_dlc27_hef_aislinn_dragonship_2" then
				if choice == 0 then
					self.final_battle_lords.alith_anar = 1;
					self:create_outpost_at_capital_for_faction(context:faction(), "wh2_main_hef_nagarythe"); -- Alith Anar
				else
					self.final_battle_lords.teclis = 1;
					self:create_outpost_at_capital_for_faction(context:faction(), "wh2_main_hef_order_of_loremasters"); -- Teclis
				end
			elseif context:dilemma() == "wh3_dlc27_hef_aislinn_dragonship_3" then
				if choice == 0 then
					self.final_battle_lords.eltharion = 1;
					self:create_outpost_at_capital_for_faction(context:faction(), "wh2_main_hef_yvresse"); -- Eltharion
				else
					self.final_battle_lords.imrik = 1;
					self:create_outpost_at_capital_for_faction(context:faction(), "wh2_dlc15_hef_imrik"); -- Imrik
				end
			end
		end,
		true
	);
end

function aislinn_narrative:trigger_first_mission()
	cm:whitelist_event_feed_event_type("faction_event_mission_issuedevent_feed_target_mission_faction");
	local target_region = cm:get_region("wh3_main_combi_region_tor_elasor");
	local x = target_region:settlement():logical_position_x();
	local y = target_region:settlement():logical_position_y();

	local mm = mission_manager:new(self.faction_key, "wh3_dlc27_camp_narrative_hef_aislinn_mission_1");
	mm:set_mission_issuer("CLAN_ELDERS");
	mm:add_new_objective("SCRIPTED");
	mm:add_condition("script_key aislinn_establish_outpost");
	mm:add_condition("override_text mission_text_text_wh3_dlc27_mission_narrative_hef_aislinn_establish_outpost");
	mm:set_position(x, y);
	mm:add_payload("faction_pooled_resource_transaction{resource wh3_dlc27_hef_elven_colonies;factor missions;amount 1;context absolute;}");
	mm:add_payload("faction_pooled_resource_transaction{resource wh3_dlc27_hef_elven_trade;factor missions;amount 100;context absolute;}");
	mm:add_payload("effect_bundle{bundle_key wh3_dlc27_hef_aislinn_intro_reward;turns 8;}");
	mm:add_payload("effect_bundle{bundle_key wh3_dlc27_hef_aislinn_intro_reward_hidden;turns 0;}");
	mm:trigger();
end

function aislinn_narrative:create_outpost_at_capital_for_faction(aislinn_faction, faction_key)
	local faction = cm:model():world():faction_by_key(faction_key);

	if faction:is_null_interface() == false and faction:has_home_region() == true then
		local home_region = faction:home_region();
		local fsm = home_region:foreign_slot_manager_for_faction(self.faction_key);

		if fsm:is_null_interface() == true then -- Make sure they don't already have a foreign slot here
			if asur_domination.config.foreign_slot_set_key_overrides[home_region:name()] then
				cm:add_foreign_slot_set_to_region_for_faction(aislinn_faction:command_queue_index(), home_region:cqi(), asur_domination.config.foreign_slot_set_key_overrides[home_region:name()])
			else
				cm:add_foreign_slot_set_to_region_for_faction(aislinn_faction:command_queue_index(), home_region:cqi(), "wh3_dlc27_slot_set_hef_sea_patrol_outpost_focus_outposts")
			end
			local new_fsm = home_region:foreign_slot_manager_for_faction(self.faction_key);

			if new_fsm:is_null_interface() == false then
				cm:foreign_slot_instantly_upgrade_building(new_fsm:slots():item_at(0), "wh3_dlc27_hef_sea_patrol_outpost_defence_garrison_1");
				cm:foreign_slot_instantly_upgrade_building(new_fsm:slots():item_at(1), "wh3_dlc27_hef_sea_patrol_outpost_income_branch_1");
				cm:foreign_slot_instantly_upgrade_building(new_fsm:slots():item_at(2), "wh3_dlc27_hef_sea_patrol_outpost_focus_1");

				-- Move camera to capital
				local x = home_region:settlement():display_position_x();
				local y = home_region:settlement():display_position_y();
				cm:set_camera_position(x, y, 11.9, 0, 8.2);
			end
		end
	end
end

function aislinn_narrative:spawn_black_ark()
	cm:create_force_with_general(
		self.black_ark_faction_key,
		"wh2_main_def_inf_bleakswords_0,wh2_main_def_inf_bleakswords_0,wh2_main_def_inf_bleakswords_0,wh2_main_def_inf_bleakswords_0,wh2_main_def_inf_black_ark_corsairs_1,wh2_main_def_inf_black_ark_corsairs_1,wh2_main_def_inf_black_ark_corsairs_1,wh2_main_def_inf_black_ark_corsairs_1,wh2_main_def_inf_dreadspears_0,wh2_main_def_inf_dreadspears_0,wh2_main_def_mon_war_hydra_0,wh2_main_def_inf_harpies,wh2_main_def_inf_harpies,wh2_main_def_inf_harpies",
		"wh3_main_combi_region_tower_of_the_stars",
		self.black_ark_pos_x,
		self.black_ark_pos_y,
		"general",
		"wh2_main_def_black_ark",
		"names_name_2147359867",
		"",
		"names_name_1927453782",
		"",
		true,
		function(cqi)
			cm:force_declare_war(self.black_ark_faction_key, self.faction_key, false, false);
			cm:disable_movement_for_faction(self.black_ark_faction_key);

			local character = cm:get_character_by_cqi(cqi);
			local mf_cqi = character:military_force():command_queue_index();
			
			local mm = mission_manager:new(self.faction_key, "wh3_dlc27_camp_narrative_hef_aislinn_mission_4");
			mm:set_mission_issuer("CLAN_ELDERS");
			mm:add_new_objective("ENGAGE_FORCE");
			mm:add_condition("cqi "..mf_cqi);
			mm:add_condition("requires_victory");
			if self.triggered_sea_lanes == false then
				mm:add_payload("text_display dummy_wh3_dlc27_aislinn_sea_lane_reward");
			end
			mm:trigger();
		end,
		false
	);
end

function aislinn_narrative:trigger_dragonship_dilemma(id)
	cm:trigger_dilemma(self.faction_key, "wh3_dlc27_hef_aislinn_dragonship_"..id);
end

function aislinn_narrative:trigger_final_battle()
	self:set_ally_strings();
	cm:trigger_mission(self.faction_key, "wh3_dlc27_qb_ie_hef_aislinn_final_battle", true);
end

function aislinn_narrative:set_ally_strings()
	core:svr_save_string("dlc27_aislinn_tyrion", tostring(self.final_battle_lords.tyrion));
	core:svr_save_string("dlc27_aislinn_alarielle", tostring(self.final_battle_lords.alarielle));
	core:svr_save_string("dlc27_aislinn_alith_anar", tostring(self.final_battle_lords.alith_anar));
	core:svr_save_string("dlc27_aislinn_teclis", tostring(self.final_battle_lords.teclis));
	core:svr_save_string("dlc27_aislinn_eltharion", tostring(self.final_battle_lords.eltharion));
	core:svr_save_string("dlc27_aislinn_imrik", tostring(self.final_battle_lords.imrik));
end

function aislinn_narrative:campaign_victory()
	-- cm:faction_add_pooled_resource(self.faction_key, "wh3_dlc27_hef_elven_colonies", "missions", 3); -- this reward triggered twice, here and missions
	asur_domination:spawn_dragonship_in_pool("wh3_dlc27_hef_dragonship_captain_05")
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("aislinn_narrative_state", aislinn_narrative.narrative_state, context);
		cm:save_named_value("aislinn_dragonship_count", aislinn_narrative.dragonship_count, context);
		cm:save_named_value("aislinn_final_battle_lords", aislinn_narrative.final_battle_lords, context);
		cm:save_named_value("aislinn_trigger_final_battle_turn", aislinn_narrative.trigger_final_battle_turn, context);
		cm:save_named_value("aislinn_triggered_sea_lanes", aislinn_narrative.triggered_sea_lanes, context);
		cm:save_named_value("aislinn_ai_aislinn_unlocked", aislinn_narrative.ai_aislinn_unlocked, context);
	end
);
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			aislinn_narrative.narrative_state = cm:load_named_value("aislinn_narrative_state", aislinn_narrative.narrative_state, context);
			aislinn_narrative.dragonship_count = cm:load_named_value("aislinn_dragonship_count", aislinn_narrative.dragonship_count, context);
			aislinn_narrative.final_battle_lords = cm:load_named_value("aislinn_final_battle_lords", aislinn_narrative.final_battle_lords, context);
			aislinn_narrative.trigger_final_battle_turn = cm:load_named_value("aislinn_trigger_final_battle_turn", aislinn_narrative.trigger_final_battle_turn, context);
			aislinn_narrative.triggered_sea_lanes = cm:load_named_value("aislinn_triggered_sea_lanes", aislinn_narrative.triggered_sea_lanes, context);
			aislinn_narrative.ai_aislinn_unlocked = cm:load_named_value("aislinn_ai_aislinn_unlocked", aislinn_narrative.ai_aislinn_unlocked, context);

			if aislinn_narrative.narrative_state == 7 then
				aislinn_narrative:set_ally_strings();
			end
		end
	end
);