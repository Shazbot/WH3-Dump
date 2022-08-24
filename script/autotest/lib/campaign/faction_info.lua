local m_treasury
local m_income
local m_army_list
local m_settlement_list
local m_tech_available
local m_warring_factions
local m_met_factions
local m_region_count

function Lib.Campaign.Faction_Info.get_treasury()
    return tonumber(m_treasury)
end

function Lib.Campaign.Faction_Info.get_income()
    return tonumber(m_income)
end

function Lib.Campaign.Faction_Info.get_army_list()
    return m_army_list
end

function Lib.Campaign.Faction_Info.get_settlement_list()
    return m_settlement_list
end

function Lib.Campaign.Faction_Info.get_tech_available()
    return m_tech_available
end

function Lib.Campaign.Faction_Info.get_warring_factions()
    return m_warring_factions
end

function Lib.Campaign.Faction_Info.get_met_factions()
    return m_met_factions
end

function Lib.Campaign.Faction_Info.get_region_count()
    return m_region_count
end

local function set_region_count()
    local player_faction = Lib.Campaign.Actions.get_human_faction()
    m_region_count = player_faction:region_list():num_items()
end

local function set_treasury()
    return common.get_context_value("CcoCampaignRoot", "", "PlayersFaction.TreasuryAmount")
end

local function set_income()
    return common.get_context_value("CcoCampaignRoot", "", "PlayersFaction.Income")
end

function Lib.Campaign.Faction_Info.update_faction_info()
    callback(function()
        local human_faction = Lib.Campaign.Actions.get_human_faction(false)

        local khorne_skulls = Lib.Components.Campaign.khorne_skulls()

        m_tech_available = human_faction:research_queue_idle()
        if(khorne_skulls ~= nil) then
            local khorne_skulls = khorne_skulls:GetStateText()
            if(tonumber(khorne_skulls) < 50) then
                -- Khorne techs cost 50 skulls.
                m_tech_available = false
            end
        end

        m_settlement_list = Lib.Campaign.Actions.get_faction_settlements(human_faction)
        m_army_list = Lib.Campaign.Actions.get_faction_armies(human_faction)
        m_income = set_income()
        m_treasury = set_treasury()
        m_warring_factions = human_faction:factions_at_war_with()
        m_met_factions = human_faction:factions_met()
        set_region_count()
    end)
end

function Lib.Campaign.Faction_Info.print_faction_info()
    callback(function()
        -- for debugging
        Utilities.print("money: "..m_treasury)
        Utilities.print("income: "..m_income)
        Utilities.print("num armies: "..#m_army_list)
        Utilities.print("num settlements: "..#m_settlement_list)
        Utilities.print("can I tech: "..tostring(m_tech_available))
        Utilities.print("war count: "..m_warring_factions:num_items())
        Utilities.print("met count: "..m_met_factions:num_items())
    end)
end

function Lib.Campaign.Faction_Info.is_it_players_turn()
    Utilities.print("Someone wants to know if it is the players turn.")
    local player_faction = Lib.Campaign.Actions.get_human_faction()
    local current_faction
    Timers_Callbacks.campaign_call(function()
        current_faction = cm:whose_turn_is_it_single()
    end)
    Utilities.print("Player CQI: "..tostring(player_faction:command_queue_index()).." Current factions CQI: "..tostring(current_faction:command_queue_index()))
    if(player_faction:command_queue_index() == current_faction:command_queue_index())then
        Utilities.print("Ergo, it IS the players turn!")
        return true 
    else
        Utilities.print("Therefore, it is NOT the players turn!")
        return false 
    end
end

function Lib.Campaign.Faction_Info.get_player_main_army_cqi()
    local player_faciton_int = Lib.Campaign.Actions.get_human_faction(false)
    local player_armies = Lib.Campaign.Actions.get_faction_armies(player_faciton_int)
    local player_main_army = player_armies[1]
    return player_main_army:cqi()
end

function Lib.Campaign.Faction_Info.get_player_main_settlement_cqi()
	local player_faciton_int = Lib.Campaign.Actions.get_human_faction(false)
    local player_settlements = Lib.Campaign.Actions.get_faction_settlements(player_faciton_int)
    local player_main_settlement
    if player_settlements ~= nil and #player_settlements > 0 then
        player_main_settlement = player_settlements[1]
        return player_main_settlement:cqi()
    end
    return nil
end

function Lib.Campaign.Faction_Info.get_player_main_settlement_interface()
	local player_faciton_int = Lib.Campaign.Actions.get_human_faction(false)
    local player_settlements = Lib.Campaign.Actions.get_faction_settlements(player_faciton_int)
    local player_main_settlement = player_settlements[1]
    return player_main_settlement
end

function Lib.Campaign.Faction_Info.get_faction_leader_cqi()
    local player_faction_int = Lib.Campaign.Actions.get_human_faction(false)
    local faction_leader_cqi = player_faction_int:faction_leader():cqi()
    return faction_leader_cqi
end