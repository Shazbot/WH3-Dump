tyrants_demands = {
	faction_key = "wh3_main_ogr_goldtooth"
}

function tyrants_demands:initialise()
	core:add_listener(
		"tyrants_demands_ritual_completed",
		"RitualCompletedEvent",
		function(context)
			return context:ritual():ritual_category() == "TYRANTS_DEMANDS"
		end,
		function(context)
			local ritual = context:ritual()
			local ritual_key = ritual:ritual_key()
			local faction = context:performing_faction()

			if ritual_key == "wh3_dlc26_ogr_tyrants_demands_bribe" then
				cm:remove_all_units_from_general(ritual:ritual_target():get_target_force():general_character())
			elseif ritual_key == "wh3_dlc26_ogr_tyrants_demands_overtime" then
				cm:replenish_action_points(cm:char_lookup_str(ritual:ritual_target():get_target_force():general_character()))
			elseif ritual_key == "wh3_dlc26_ogr_tyrants_demands_sticky_fingers" then
				local target_character = ritual:ritual_target():get_target_force():general_character()
				local ancillaries = self:find_valid_ancillaries(target_character:command_queue_index())
				
				if ancillaries and #ancillaries > 0 then
					local chosen_ancillary = ancillaries[cm:random_number(#ancillaries)]

					cm:force_remove_ancillary(target_character, chosen_ancillary, false, false)
					cm:add_ancillary_to_faction(faction, chosen_ancillary, false)
				end
			elseif ritual_key == "wh3_dlc26_ogr_tyrants_demands_buyout" then
				cm:transfer_region_to_faction(ritual:ritual_target():get_target_region():name(), faction:name())
			elseif ritual_key == "wh3_dlc26_ogr_tyrants_demands_veteran_wages" then
				cm:add_experience_to_units_commanded_by_character(cm:char_lookup_str(ritual:ritual_target():get_target_force():general_character()), 1)
			end
		end,
		true
	)

	-- hack to grey out perform button if no ancillary is available for sticky fingers
	core:add_listener(
		"tyrants_demands_target_set",
		"ContextTriggerEvent",
		function(context)
			return context.string:starts_with("tyrants_demands_force_target_changed")
		end,
		function(context)
			common.set_context_value("sticky_fingers_target_invalid", 0)

			local cqi = string.sub(context.string, string.find(context.string, "*") + 1)

			if cqi == "" then return end

			local ancillaries = self:find_valid_ancillaries(cqi)
			local uic = find_uicomponent("dlc26_tyrants_demands", "button_perform")

			if uic and (not ancillaries or #ancillaries == 0) then
				common.set_context_value("sticky_fingers_target_invalid", 1)
			end
		end,
		true
	)
end

function tyrants_demands:find_valid_ancillaries(cqi)
	local target_cco = cco("CcoCampaignCharacter", cqi)

	if not target_cco then return end

	local char_list = cm:get_faction(self.faction_key):character_list()

	-- get a list of valid ancillaries
	local available_ancillaries = {}
	local num_ancillaries = target_cco:Call("AncillaryList.Size")

	if not num_ancillaries then return end

	for i = 0, num_ancillaries - 1 do
		local current_ancillary = target_cco:Call("AncillaryList.At(" .. i .. ").AncillaryRecordContext.Key")

		if current_ancillary then
			for _, character in model_pairs(char_list) do
				if character:can_equip_ancillary(current_ancillary) then
					table.insert(available_ancillaries, current_ancillary)
					break
				end
			end
		end
	end
	
	return available_ancillaries
end