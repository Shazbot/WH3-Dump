Eltharion_Duo_Start_Dilemma = {
	eltharion_faction = "wh2_main_hef_yvresse",
	eltharion_starting_enemy = "wh2_dlc15_grn_skull_crag",			-- if the player leaves ulthuan, this faction will be made peace with
	yvresse_region = "wh3_main_combi_region_tor_yvresse",
	faction_to_transfer_yvresse_to = "wh2_main_hef_eataine",
	alt_faction_to_transfer_yvresse_to = "wh2_main_hef_cothique",	-- if the above faction is player controlled, use this instead
	dilemma_key = "wh3_main_eltharion_start_dilemma"
}

function Eltharion_Duo_Start_Dilemma:add_yvresse_region_change_listeners()
	out("#### Yvresse Region Change Listeners ####")
	
	local eltharion_interface = cm:get_faction(self.eltharion_faction)
	
	if eltharion_interface and eltharion_interface:is_human() and not cm:get_saved_value("eltharion_dilemma_issued") then
		core:add_listener(
			"Eltharion_trigger_dilemma",
			"CharacterPerformsSettlementOccupationDecision",
			function(context)
				if cm:turn_number() <= 5 and context:character():faction():name() == self.eltharion_faction then
					local occupation_decision_type = context:occupation_decision_type()
					return (occupation_decision_type == "occupation_decision_loot" or occupation_decision_type == "occupation_decision_occupy") and cm:is_region_owned_by_faction(self.yvresse_region, self.eltharion_faction)
				end
			end,
			function()
				cm:trigger_dilemma(self.eltharion_faction, self.dilemma_key)
				
				cm:set_saved_value("eltharion_dilemma_issued", true)
				
				core:add_listener(
					"Eltharion_DilemmaChoiceMadeEvent",
					"DilemmaChoiceMadeEvent",
					function(context)
						return context:dilemma() == self.dilemma_key
					end,
					function(context)
						if context:choice() == 0 then
							cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "")
							cm:force_make_peace(self.eltharion_faction, self.eltharion_starting_enemy)
							cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "")
							
							local transfer_faction_key = self.faction_to_transfer_yvresse_to
							local transfer_faction = cm:get_faction(self.faction_to_transfer_yvresse_to)
							
							if transfer_faction and transfer_faction:is_human() then
								transfer_faction_key = self.alt_faction_to_transfer_yvresse_to
							end
							
							cm:disable_event_feed_events(true, "wh_event_category_conquest", "", "")
							
							cm:transfer_region_to_faction(self.yvresse_region, transfer_faction_key)
							
							cm:callback(
								function()
									cm:heal_garrison(cm:get_region(self.yvresse_region):cqi())
									cm:disable_event_feed_events(false, "wh_event_category_conquest", "", "")
								end,
								0.2
							)
							
							local secondary_army = cm:get_closest_character_to_position_from_faction(self.eltharion_faction, 327, 569, true, false)
							
							if secondary_army:has_region() and secondary_army:region():name() == self.yvresse_region then
								cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
								cm:kill_character(secondary_army:command_queue_index(), true)
								cm:disable_event_feed_events(false, "wh_event_category_character", "", "")
							end
						end
					end,
					false
				)
			end,
			false
		)
	end
end