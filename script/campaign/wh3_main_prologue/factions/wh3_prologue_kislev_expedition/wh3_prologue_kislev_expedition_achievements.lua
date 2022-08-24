
-- Name: Royal Ranks Ramped 
-- Description: During the Prologue, fill Yuri's army with units.
if prologue_achievements["WH3_ACHIEVEMENT_PROLOGUE_ARMY_CAP"] == false then
	
	core:add_listener(
		"UnitTrainedPrologueAchievement",
		"UnitTrained",
		function(context)
			return context:unit():military_force():faction() == cm:get_local_faction() and context:unit():military_force():general_character():is_faction_leader() and context:unit():military_force():unit_list():num_items() >= 20
		end,
		function()
			unlock_achievement("WH3_ACHIEVEMENT_PROLOGUE_ARMY_CAP")
		end,
		false
	)

end

-- Name: A Mortal Wound Inflicted
-- Description: During the Prologue, win your first battle in the Chaos Wastes.
if prologue_achievements["WH3_ACHIEVEMENT_PROLOGUE_BATTLE_WIN"] == false then
	
	core:add_listener(
		"CharacterCompletedBattlePrologueAchievement",
		"CharacterCompletedBattle",
		function() return cm:pending_battle_cache_human_victory() end,
		function()
			unlock_achievement("WH3_ACHIEVEMENT_PROLOGUE_BATTLE_WIN")
		end,
		false
	)

end

-- Name: Establish & Advance
-- Description: During the Prologue, construct X buildings.
if prologue_achievements["WH3_ACHIEVEMENT_PROLOGUE_BUILDING_CONSTRUCTION"] == false then
	
	local number_of_buildings_required = 5

	core:add_listener(
		"BuildingCompletedPrologueAchievement",
		"BuildingCompleted",
		function(context) 
			if context:garrison_residence():faction() == cm:get_local_faction() then
				prologue_number_of_buildings_constructed = prologue_number_of_buildings_constructed + 1
				return prologue_number_of_buildings_constructed >= number_of_buildings_required
			end
		end,
		function()
			unlock_achievement("WH3_ACHIEVEMENT_PROLOGUE_BUILDING_CONSTRUCTION")
		end,
		false
	)

end


-- Name: Enchanted Arsenal
-- Description: During the Prologue, equip Yuri with every type of magic item.
if prologue_achievements["WH3_ACHIEVEMENT_PROLOGUE_ITEMS"] == false then

	core:add_listener(
		"CharacterAncillaryGainedPrologueAchievement",
		"CharacterAncillaryGained",
		function()
			local equipped_armour = false
			local equipped_talisman = false
			local equipped_enchanted_item = false
			local equipped_weapon = false

			for i = 0, common.get_context_value("CcoCampaignCharacter", cm:get_local_faction():faction_leader():command_queue_index(), "AncillaryList.Size") - 1 do
				local equipped_category = common.get_context_value("CcoCampaignCharacter", cm:get_local_faction():faction_leader():command_queue_index(), "AncillaryList.At("..i..").AncillaryRecordContext.CategoryContext.Key")

				if equipped_category == "armour" then
					equipped_armour = true
				elseif equipped_category == "weapon" then
					equipped_weapon = true
				elseif equipped_category == "talisman" then
					equipped_talisman = true
				elseif equipped_category == "enchanted_item" then
					equipped_enchanted_item = true
				end

			end

			if equipped_armour and equipped_talisman and equipped_enchanted_item and equipped_weapon then return true end
		end,
		function()
			unlock_achievement("WH3_ACHIEVEMENT_PROLOGUE_ITEMS")
		end,
		false
	)

end

-- Name: Two Noble Heads
-- Description: During the Prologue, recruit a second Lord.
if prologue_achievements["WH3_ACHIEVEMENT_PROLOGUE_SECOND_GENERAL"] == false then

	core:add_listener(
		"CharacterCreatedPrologueAchievement",
		"CharacterCreated", 
		function(context) 
			return (context:character():is_faction_leader() == false) and (context:character():faction() == cm:get_local_faction()) and (context:character():character_type_key() == "general")
		 end,
		function() 
			unlock_achievement("WH3_ACHIEVEMENT_PROLOGUE_SECOND_GENERAL")
		end,
		false
	)

end

-- Name: Reverser of Ruin
-- Description: During the Prologue, capture a settlement in the Chaos Wastes.
if prologue_achievements["WH3_ACHIEVEMENT_PROLOGUE_SETTLEMENT_CAPTURE"] == false then
	
	core:add_listener(
		"CharacterPerformsSettlementOccupationDecisionPrologueAchievement",
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			if context:garrison_residence():region():name() == "wh3_prologue_region_ice_canyon_beacon_fort" or
			context:garrison_residence():region():name() == "wh3_prologue_region_mountain_pass_kislev_refuge" or
			context:garrison_residence():region():name() == "wh3_prologue_region_frozen_plains_dervingard" then
				return false
			end
			
			return context:character():faction() == cm:get_local_faction()
		end,
		function()
			unlock_achievement("WH3_ACHIEVEMENT_PROLOGUE_SETTLEMENT_CAPTURE")
		end,
		false
	)

end

-- Name: Spires to the Sky
-- Description: During the Prologue, fully upgrade a settlement.
if prologue_achievements["WH3_ACHIEVEMENT_PROLOGUE_SETTLEMENT_UPGRADE"] == false then

	core:add_listener(
		"BuildingCompletedPrologueAchievement",
		"BuildingCompleted",
		function(context)
			if context:garrison_residence():faction():is_human() then
				local player_region_list = cm:get_local_faction():region_list()
				for i = 0, player_region_list:num_items() - 1 do
					local current_building_level = player_region_list:item_at(i):settlement():primary_slot():building():name()
					if current_building_level then
						local building_level_upgrades = cm:get_building_level_upgrades(current_building_level)
						if is_empty_table(building_level_upgrades) then
							return true
						end
					end
				end
			end
		end,
		function()
			unlock_achievement("WH3_ACHIEVEMENT_PROLOGUE_SETTLEMENT_UPGRADE")
		end,
		false
	)

end

-- Name: Self-Improvement
-- Description: During the Prologue, spend 10 skill points.
if prologue_achievements["WH3_ACHIEVEMENT_PROLOGUE_SKILL_POINTS"] == false then

	local required_skill_points = 10
	
	core:add_listener(
		"CharacterSkillPointAllocatedPrologueAchievement",
		"CharacterSkillPointAllocated",
		function()
			prologue_number_of_skill_points_spent = prologue_number_of_skill_points_spent + 1
			return prologue_number_of_skill_points_spent >= required_skill_points
		end,
		function()
			unlock_achievement("WH3_ACHIEVEMENT_PROLOGUE_SKILL_POINTS")
		end,
		false
	)

end