local m_behaviours_set = false
local m_recruit_armies
local m_recruit_units
local m_upgrade_settlements
local m_research_tech
local m_initiate_diplomacy
local m_fight_battle
local m_fight_start_battle = false

function Lib.Campaign.Behaviours.set_action_weights(army_weight, unit_weight, settlement_weight, tech_weight, diplomacy_weight, fight_battle_weight, fight_start_battle)
    if(army_weight == nil or army_weight == "Random") then army_weight = math.random(1,10) end
    if(unit_weight == nil or unit_weight == "Random") then unit_weight = math.random(1,10) end
    if(settlement_weight == nil or settlement_weight == "Random") then settlement_weight = math.random(1,10) end
    if(tech_weight == nil or tech_weight == "Random") then tech_weight = math.random(1,10) end
    if(diplomacy_weight == nil or diplomacy_weight == "Random") then diplomacy_weight = math.random(1,10) end
    if(fight_battle_weight == nil or fight_battle_weight == "Random") then fight_battle_weight = math.random(1,10) end
    m_fight_start_battle = fight_start_battle or false
    Utilities.print("...")
    Utilities.print("Recruit Army Weight: "..army_weight)
    Utilities.print("Recruit Unit Weight: "..unit_weight)
    Utilities.print("Settlement Upgrade Weight: "..settlement_weight)
    Utilities.print("Research Tech Weight: "..tech_weight)
    Utilities.print("Initiate Diplomacy Weight: "..diplomacy_weight)
    Utilities.print("Attack nearest Target Weight: "..fight_battle_weight)
    Utilities.print("Fight starting battle: "..tostring(m_fight_start_battle))
    Utilities.print("...")

    m_behaviours_set = true
    m_recruit_armies = tonumber(army_weight)
    m_recruit_units = tonumber(unit_weight)
    m_upgrade_settlements = tonumber(settlement_weight)
    m_research_tech = tonumber(tech_weight)
    m_initiate_diplomacy = tonumber(diplomacy_weight)    
    m_fight_battle = tonumber(fight_battle_weight)
end

function Lib.Campaign.Behaviours.player_turn_actions()
    local fighting_start_battle = false
    callback(function()
        if(m_behaviours_set) then
            -- for campaign progression reasons, the starting battle should be fought before doing anything else in the first turn
            if m_fight_start_battle then
                Lib.Campaign.Actions.attack_nearest_target()
                m_fight_start_battle = false
                fighting_start_battle = true
                Lib.Helpers.Misc.wait(10) -- needed to ensure the script deals with the post-battle results properly instead of starting other player actions
            end

            if g_compat_sweep then
                Lib.Campaign.Actions.move_character_to_faction_capital()
            end

            local action_chance = math.random(1,10)
            if(m_recruit_armies >= action_chance) then
                Lib.Campaign.Characters.recruit_new_army()
                Lib.Campaign.Faction_Info.update_faction_info()
            end
            
            local action_chance = math.random(1,10)
            if(m_recruit_units >= action_chance) then
                local army_list = Lib.Campaign.Faction_Info.get_army_list()
                if(#army_list > 0) then
                    Lib.Campaign.Characters.recruit_units_to_army()
                    Lib.Campaign.Faction_Info.update_faction_info()
                end
            end

            local action_chance = math.random(1,10)
            if(m_upgrade_settlements >= action_chance) then
                local settlement_list = Lib.Campaign.Faction_Info.get_settlement_list()
                if(#settlement_list > 0) then
                    Lib.Campaign.Settlements.upgrade_settlement()
                    Lib.Campaign.Faction_Info.update_faction_info()
                end
            end

            local action_chance = math.random(1,10)
            if(m_research_tech >= action_chance) then
                if(Lib.Campaign.Faction_Info.get_tech_available()) then
                    Lib.Campaign.Technology.research_technology()
                    Lib.Campaign.Faction_Info.update_faction_info()
                end
            end
            
            local action_chance = math.random(1,10)
            if(m_initiate_diplomacy >= action_chance) then
                --Lib.Campaign.Diplomacy.propose_diplomatic_action() <- replaced with quick deal for now
                Lib.Campaign.Diplomacy.initiate_quick_deal_diplomacy()
                Lib.Campaign.Faction_Info.update_faction_info()
            end

            local action_chance = math.random(1,10)
            if(m_fight_battle >= action_chance and not fighting_start_battle)then
                Lib.Campaign.Actions.attack_nearest_target()
            end
        end
    end)
end 