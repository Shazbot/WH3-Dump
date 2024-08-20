local repanse_desert_thirst_bundle = "wh2_dlc14_bundle_desert_supplies"
local bretonnia_culture = "wh_main_brt_bretonnia"

local final_battles = {
	wh_dlc07_qb_brt_louen_errantry_war_badlands_stage_1_the_lost_idol = true,
	wh_dlc07_qb_brt_louen_errantry_war_chaos_wastes_stage_1_cliff_of_beasts = true,
	wh3_main_ie_qb_brt_repanse_defend_or_conquer_crusader = true,
	wh3_main_ie_qb_brt_repanse_defend_or_conquer_guardian = true,
}

local final_battle_dilemma_default = {
		key = "wh_dlc07_brt_final_battle_choice", 
		choice_1 = "wh_dlc07_qb_brt_louen_errantry_war_chaos_wastes_stage_1_cliff_of_beasts", 
		choice_2 = "wh_dlc07_qb_brt_louen_errantry_war_badlands_stage_1_the_lost_idol"
	}

local final_battle_dilemma_overrides = {
	wh2_dlc14_brt_chevaliers_de_lyonesse =	{
			key = "wh2_dlc14_main_brt_repanse_final_battle_choice",
			choice_1 = "wh3_main_ie_qb_brt_repanse_defend_or_conquer_crusader",
			choice_2 = "wh3_main_ie_qb_brt_repanse_defend_or_conquer_guardian"
		}
	}


function Add_Bretonnia_Listeners()
	out("#### Adding Bretonnia Listeners ####")
	
	-- final battle mission
	core:add_listener(
		"Bret_MissionSucceeded",
		"MissionSucceeded",
		function(context)
			return context:faction():culture() == bretonnia_culture
		end,
		function(context)
			local mission_key = context:mission():mission_record_key()
			
			if final_battles[mission_key] then
				cm:complete_scripted_mission_objective(context:faction():name(), "wh_main_long_victory", "win_errantry_war", true)
			end
		end,
		true
	)
	
	core:add_listener(
		"Bret_FactionTurnStart",
		"FactionTurnStart",
		function(context)
			local faction = context:faction()
			
			return faction:is_human() and faction:culture() == bretonnia_culture
		end,
		function(context)
			local faction = context:faction()
			
			Check_Chivalry_Win_Condition(faction)
			
			local faction_key = faction:name()
			local turn_number = cm:model():turn_number()
			
			if faction_key == "wh2_dlc14_brt_chevaliers_de_lyonesse" then
				if turn_number == 1 then
					cm:trigger_mission(faction_key, "wh2_dlc14_brt_repanse_banner_jean", true)
					cm:trigger_mission(faction_key, "wh2_dlc14_brt_repanse_banner_rene", true)
					cm:trigger_mission(faction_key, "wh2_dlc14_brt_repanse_banner_pierre", true)
				elseif turn_number == 2 then
					cm:trigger_incident(faction_key, "wh2_dlc14_incident_brt_desert_supplies", true)
				elseif turn_number == 5 then
					cm:trigger_mission(faction_key, "wh2_dlc14_brt_repanse_capture_arkhan", true)
				elseif turn_number == 10 then
					cm:trigger_mission(faction_key, "wh2_dlc14_brt_repanse_capture_rakaph", true)
				elseif turn_number == 20 then
					cm:trigger_mission(faction_key, "wh2_dlc14_brt_repanse_capture_nagash", true)
				end
			end
		end,
		true
	)
	
	core:add_listener(
		"Bret_FactionTurnEnd",
		"FactionTurnEnd",
		function(context)
			local faction = context:faction()
			
			return faction:is_human() and faction:culture() == bretonnia_culture
		end,
		function(context)
			Check_Chivalry_Win_Condition(context:faction())
		end,
		true
	)
	
	
	local function Bret_RepanseSupplies(character, leaving)
		if character:faction():name() == "wh2_dlc14_brt_chevaliers_de_lyonesse" and (character:in_settlement() or leaving) then
			local character_cqi = character:command_queue_index()
			
			cm:remove_effect_bundle_from_characters_force(repanse_desert_thirst_bundle, character_cqi)
			cm:apply_effect_bundle_to_characters_force(repanse_desert_thirst_bundle, character_cqi, 5)
		end
	end
	
	core:add_listener(
		"Bret_CharacterEntersGarrison",
		"CharacterEntersGarrison",
		true,
		function(context) Bret_RepanseSupplies(context:character(), false) end,
		true
	)
	
	core:add_listener(
		"Bret_CharacterLeavesGarrison",
		"CharacterLeavesGarrison",
		true,
		function(context) Bret_RepanseSupplies(context:character(), true) end,
		true
	)
	
	core:add_listener(
		"Bret_CharacterTurnStart",
		"CharacterTurnStart",
		true,
		function(context) Bret_RepanseSupplies(context:character(), false) end,
		true
	)
end
	
function Check_Chivalry_Win_Condition(faction)
	local faction_key = faction:name()
	local chivalry_amount = faction:pooled_resource_manager():resource("brt_chivalry"):value()
	
	if chivalry_amount >= chivalry.thresholds[4] and not cm:get_saved_value("bretonnia_final_battle_issued_" .. faction_key) then
		cm:set_saved_value("bretonnia_final_battle_issued_" .. faction_key, true)
		local dilemma_details = final_battle_dilemma_overrides[faction_key] or final_battle_dilemma_default
		-- trigger final battle
		cm:trigger_dilemma(
			faction_key, 
			dilemma_details.key,
			function()
				core:trigger_event("ScriptEventErrantryWarDilemma")

				core:add_listener(
					"Bret_DilemmaChoiceMadeEvent",
					"DilemmaChoiceMadeEvent",
					function(context)
						return context:dilemma() == dilemma_details.key
					end,
					function(context)
						local choice = context:choice()
						
						if choice == 0 then
							cm:trigger_mission(faction_key, dilemma_details.choice_1, true)
						else
							cm:trigger_mission(faction_key, dilemma_details.choice_2, true)
						end
					end,
					false
				)
			end
		)
	end
	
	if chivalry_amount >= chivalry.thresholds[5] then
		-- victory condition to attain a certain chivalry level
		cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "max_chivalry", true)
	end
end