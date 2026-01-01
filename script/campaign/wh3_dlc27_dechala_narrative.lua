dechala_narrative = {
	faction_key = "wh3_dlc27_sla_the_tormentors",
	mission_keys = {
		["wh3_dlc27_mission_sla_narrative_01"] = true,
		["wh3_dlc27_mission_sla_narrative_02"] = true,
		["wh3_dlc27_mission_sla_narrative_03"] = true,
		["wh3_dlc27_mission_sla_narrative_04"] = true,
		["wh3_dlc27_mission_sla_narrative_05"] = true,
		["wh3_dlc27_mission_sla_narrative_06"] = true,
		["wh3_dlc27_mission_sla_narrative_07"] = true,
		["wh3_dlc27_mission_sla_narrative_08"] = true,
	},

	saved = {
		narrative_state = 0,
		palace_climates = {}
	},

	-- no ocean, as it's the Galeon Graveyard.
	settlement_climates = {
		"climate_chaotic",
		"climate_desert",
		"climate_frozen",
		"climate_island",
		"climate_jungle",
		"climate_magicforest",
		"climate_mountain",
		"climate_savannah",
		"climate_temperate",
		"climate_wasteland",
	},
};

function dechala_narrative:initialise()
	local dechala = cm:get_faction(self.faction_key)
	if dechala and dechala:is_null_interface() == false and dechala:is_human() then
		if self.saved.narrative_state == 0 then
			core:add_listener(
				"DechalaNarrative_StartMissions",
				"FactionTurnStart",
				function(context)
					return context:faction() == dechala and cm:turn_number() >= 2 and self.saved.narrative_state == 0 end,
				function(context)
					cm:whitelist_event_feed_event_type("faction_event_mission_issuedevent_feed_target_mission_faction");
					self:trigger_first_mission()
					self.saved.narrative_state = 1
					core:remove_listener("DechalaNarrative_StartMissions")
				end,
				true
			);
		end
		self:add_listeners();
	end
end

function dechala_narrative:trigger_first_mission()
	local mission_key = "wh3_dlc27_mission_sla_narrative_01"
	
	local mm = mission_manager:new(self.faction_key, mission_key);
	mm:set_mission_issuer("CLAN_ELDERS");
	mm:add_new_objective("SCRIPTED");
	mm:add_condition("script_key dechala_establish_pleasure_palace");
	mm:add_condition("override_text mission_text_text_wh3_dlc27_mission_narrative_sla_dechala_establish_pleasure_palace");
	mm:add_payload("money 1525");
	mm:add_payload("faction_pooled_resource_transaction{resource wh3_dlc27_sla_thralls;factor other;amount 500;context absolute;}");
	mm:trigger();

end

function dechala_narrative:trigger_second_mission()
	local mission_key = "wh3_dlc27_mission_sla_narrative_02"

	local mm = mission_manager:new(self.faction_key, mission_key);
	mm:set_mission_issuer("CLAN_ELDERS");
	mm:add_new_objective("SCRIPTED");
	mm:add_condition("script_key dechala_upgrade_pleasure_palace");
	mm:add_condition("override_text mission_text_text_wh3_dlc27_mission_narrative_sla_dechala_upgrade_pleasure_palace");
	mm:add_payload("money 1525");
	mm:add_payload("faction_pooled_resource_transaction{resource wh3_dlc27_sla_thralls;factor other;amount 500;context absolute;}");
	mm:trigger();

end

function dechala_narrative:trigger_third_mission()
	local mission_key = "wh3_dlc27_mission_sla_narrative_03"

	local mm = mission_manager:new(self.faction_key, mission_key);
	mm:set_mission_issuer("CLAN_ELDERS");
	mm:add_new_objective("SCRIPTED");
	mm:add_condition("script_key dechala_establish_pleasure_palace_new_climate");
	mm:add_condition("override_text mission_text_text_wh3_dlc27_mission_narrative_sla_dechala_establish_pleasure_palace_new_climate");
	mm:add_payload("money 1525");
	mm:add_payload("faction_pooled_resource_transaction{resource wh3_dlc27_sla_thralls;factor other;amount 500;context absolute;}");
	mm:trigger();

end

function dechala_narrative:trigger_fourth_mission()
	local mission_key = "wh3_dlc27_mission_sla_narrative_04"

	local mm = mission_manager:new(self.faction_key, mission_key);
	mm:set_mission_issuer("CLAN_ELDERS");
	mm:add_new_objective("ACHIEVE_CHARACTER_RANK");
	mm:add_condition("total 5");
	mm:add_condition("total2 10");
	mm:add_condition("include_generals")
	mm:add_payload("money 1525");
	mm:add_payload("faction_pooled_resource_transaction{resource wh3_dlc27_sla_thralls;factor other;amount 1000;context absolute;}");
	mm:trigger();

end

function dechala_narrative:trigger_fifth_mission()


	local mission_key = "wh3_dlc27_mission_sla_narrative_05"

	local mm = mission_manager:new(self.faction_key, mission_key);
	mm:set_mission_issuer("CLAN_ELDERS");
	mm:add_new_objective("DEFEAT_N_ARMIES_OF_FACTION");
	mm:add_condition("total 3");
	mm:add_condition("subculture wh3_main_sc_cth_cathay");
	mm:add_payload("money 1525");
	mm:add_payload("faction_pooled_resource_transaction{resource wh3_dlc27_sla_thralls;factor other;amount 1000;context absolute;}");
	mm:trigger();

end

function dechala_narrative:trigger_sixth_mission()
	local mission_key = "wh3_dlc27_mission_sla_narrative_06"
	cm:trigger_mission(self.faction_key, mission_key, true);
end

function dechala_narrative:trigger_seventh_mission()
	local mission_key = "wh3_dlc27_mission_sla_narrative_07"

	local mm = mission_manager:new(self.faction_key, mission_key);
	mm:set_mission_issuer("CLAN_ELDERS");
	mm:add_new_objective("SCRIPTED");
	mm:add_condition("script_key dechala_abandon_settlement");
	mm:add_condition("override_text mission_text_text_wh3_dlc27_mission_narrative_sla_dechala_abandon_settlement");
	mm:add_payload("money 1525");
	mm:add_payload("faction_pooled_resource_transaction{resource wh3_dlc27_sla_thralls;factor other;amount 1500;context absolute;}");
	mm:trigger();

end

function dechala_narrative:trigger_eight_mission()
	local mission_key = "wh3_dlc27_mission_sla_narrative_08"
	cm:trigger_mission(self.faction_key, mission_key, true);

end

function dechala_narrative:any_cathay_factions_alive()
	local cathay_factions = cm:get_factions_by_subculture("wh3_main_sc_cth_cathay")
	for i, faction in ipairs(cathay_factions) do
		if faction and not faction:is_dead() then
			return true
		end
	end
	return false
end

function dechala_narrative:add_listeners()

	core:add_listener(
		"DechalaNarrative_MissionSucceeded",
		"MissionSucceeded",
		function(context) 
			return self.mission_keys[context:mission():mission_record_key()] and context:faction():name() == self.faction_key and context:faction():is_human()
		end,
		function(context)
			if self.saved.narrative_state == 1 then
				self:trigger_second_mission()
				self.saved.narrative_state = 2

				local faction = context:faction()
				local ritual_key_prefix = "wh3_dlc27_dechala_ritual_palace_"
				local bool_all_completed = true
				for i = 1, 6 do
					if not faction:rituals():ritual_status(ritual_key_prefix..i):on_cooldown() then
						bool_all_completed = false
						break
					end
				end

				if bool_all_completed then
					cm:set_active_mission_status_for_faction(faction, "wh3_dlc27_mission_sla_narrative_02", "SUCCEEDED")
					core:remove_listener("DechalaNarrative_RitualCompletedEvent")
				end

			elseif self.saved.narrative_state == 2 then
				self:trigger_third_mission()
				self.saved.narrative_state = 3

				local all_climates_full = true
				for _, climate in ipairs(self.settlement_climates) do 
					if not table.contains(self.saved.palace_climates, climate) then
						all_climates_full = false
						break
					end
				end

				if all_climates_full then
					cm:set_active_mission_status_for_faction(cm:get_faction(self.faction_key), "wh3_dlc27_mission_sla_narrative_03", "SUCCEEDED")
					core:remove_listener("DechalaNarrative_CharacterPerformsSettlementOccupationDecision")
				end
			elseif self.saved.narrative_state == 3 then
				self:trigger_fourth_mission()
				self.saved.narrative_state = 4
			elseif self.saved.narrative_state == 4 then
				if self:any_cathay_factions_alive() then
					self:trigger_fifth_mission()
					self.saved.narrative_state = 5
				else
					self:trigger_sixth_mission()
					self.saved.narrative_state = 6
				end
			elseif self.saved.narrative_state == 5 then
				self:trigger_sixth_mission()
				self.saved.narrative_state = 6
			elseif self.saved.narrative_state == 6 then
				cm:trigger_dilemma(self.faction_key, "wh3_dlc27_sla_dechala_narrative_dilemma")
				self:trigger_seventh_mission()
				self.saved.narrative_state = 7
			elseif self.saved.narrative_state == 7 then
				self:trigger_eight_mission()
				self.saved.narrative_state = 8
			elseif self.saved.narrative_state == 8 then
				cm:trigger_dilemma(self.faction_key, "wh3_dlc27_sla_dechala_narrative_dilemma_finale")
				core:remove_listener("DechalaNarrative_MissionSucceeded")
			end
		end,
		true
	);
	
	core:add_listener(
		"DechalaNarrative_CharacterPerformsSettlementOccupationDecision",
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			return context:character():faction():name() == self.faction_key 
				and context:occupation_decision() == "1041407041" or context:occupation_decision() == "1084419564" end,
		function(context)
			local settlement_climate = context:garrison_residence():settlement_interface():get_climate()
			if self.saved.narrative_state == 1 then
				cm:set_active_mission_status_for_faction(cm:get_faction(self.faction_key), "wh3_dlc27_mission_sla_narrative_01", "SUCCEEDED")
			end
			if self.saved.narrative_state ~= 3 then
				table.insert(self.saved.palace_climates, settlement_climate)
			end
			if self.saved.narrative_state == 3 then
				if not table.contains(self.saved.palace_climates, settlement_climate) then
					cm:set_active_mission_status_for_faction(cm:get_faction(self.faction_key), "wh3_dlc27_mission_sla_narrative_03", "SUCCEEDED")
					core:remove_listener("DechalaNarrative_CharacterPerformsSettlementOccupationDecision")
					core:remove_listener("DechalaNarrative_SettlementTypeConvertedEvent")
				end
			end
		end,
		true
	)

	core:add_listener(
		"DechalaNarrative_SettlementTypeConvertedEvent",
		"SettlementTypeConvertedEvent",
		function(context)
			local settlement = context:settlement()
			return settlement:faction():name() == self.faction_key and settlement:settlement_type_key() == "wh3_dlc27_dechala_pleasure_palace" end,
		function(context)
			local settlement_climate = context:settlement():get_climate()
			if self.saved.narrative_state == 1 then
				cm:set_active_mission_status_for_faction(cm:get_faction(self.faction_key), "wh3_dlc27_mission_sla_narrative_01", "SUCCEEDED")
			end
			if self.saved.narrative_state ~= 3 then
				table.insert(self.saved.palace_climates, settlement_climate)
			end
			if self.saved.narrative_state == 3 then
				if not table.contains(self.saved.palace_climates, settlement_climate) then
					cm:set_active_mission_status_for_faction(cm:get_faction(self.faction_key), "wh3_dlc27_mission_sla_narrative_03", "SUCCEEDED")
					core:remove_listener("DechalaNarrative_CharacterPerformsSettlementOccupationDecision")
					core:remove_listener("DechalaNarrative_SettlementTypeConvertedEvent")
				end
			end
		end,
		true
	)

	
	core:add_listener(
		"DechalaNarrative_RitualCompletedEvent",
		"RitualCompletedEvent",
		function(context)
			local ritual_category = context:ritual():ritual_category()
			return self.saved.narrative_state == 2 and context:performing_faction():name() == self.faction_key and ritual_category == "EXQUISITE_IMPORTS" end,
		function(context)
			cm:set_active_mission_status_for_faction(cm:get_faction(self.faction_key), "wh3_dlc27_mission_sla_narrative_02", "SUCCEEDED")
			core:remove_listener("DechalaNarrative_RitualCompletedEvent")
		end,
		true
	) 

	core:add_listener(
		"DechalaNarrative_RegionAbandoned",
		"RegionFactionChangeEvent",
		function(context) return context:previous_faction():name() == self.faction_key and context:reason() == "abandoned" end,
		function(context)
			if self.saved.narrative_state == 7 then
				cm:set_active_mission_status_for_faction(cm:get_faction(self.faction_key), "wh3_dlc27_mission_sla_narrative_07", "SUCCEEDED")
				core:remove_listener("DechalaNarrative_RegionAbandonedWithBuildingEvent")
			end
		end,
		true
	)
end
--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("dechala_narrative_saved", dechala_narrative.saved, context)
	end
)
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			dechala_narrative.saved = cm:load_named_value("dechala_narrative_saved", dechala_narrative.saved, context)
		end
	end
)