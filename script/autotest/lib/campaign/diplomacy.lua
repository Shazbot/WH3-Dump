local m_quick_deal_found = false

-- Member variables for faction load test
local m_target_declare_war_faction
local m_already_warring_factions = {}

function Lib.Campaign.Diplomacy.open_diplomacy()
    callback(function()
        local diplomacy_panel = Lib.Components.Campaign.cancel_diplomacy()
        if(diplomacy_panel == nil or diplomacy_panel:Visible() == false) then
            Lib.Campaign.Clicks.open_diplomacy_panel()
        end
    end)
end

local function get_faction_list()
    local child_count, child_list = Common_Actions.get_visible_child_count(Lib.Components.Campaign.diplomacy_faction_parent())
    local faction_list = {}
    for k, v in pairs(child_list) do
        if(string.find(v:Id(), "faction")) then
            table.insert(faction_list, v:Id())
        end
    end
    return faction_list
end

local function get_faction_attitude(faction_id)
    -- returns a value from 0 -> 6 
    local attitude_comp = Lib.Components.Campaign.diplomacy_faction_attitude(faction_id)
    local attitude_level = attitude_comp:CurrentState()
    return attitude_level
end

local function select_faction_with_best_relation()
    callback(function()
        -- cycles through each faction to log their current attitude value from the side panel (not possible otherwise), then selects the highest
        local faction_list = get_faction_list()
        local best_relation_id
        local best_attitude_value

        Utilities.print(#faction_list)
        for i = 1, #faction_list do
            callback(function()
                Lib.Campaign.Clicks.diplomacy_select_faction(faction_list[i])
                callback(function()
                    local attitude_value = Lib.Components.Campaign.diplomacy_faction_attitude_value():GetStateText()
                    if(best_relation_id == nil or best_attitude_value < attitude_value) then
                        -- checks if current factions attitude has a better attitude than the stored factions
                        best_attitude_value = attitude_value
                        best_relation_id = faction_list[i]
                    end
                end)
            end)
        end

        callback(function()
            Lib.Campaign.Clicks.diplomacy_select_faction(best_relation_id)
        end)
    end)
end

local function select_faction_with_worst_relation()
    callback(function()
        -- cycles through each faction to log their current attitude value from the side panel (not possible otherwise), then selects the lowest
        local faction_list = get_faction_list()
        local worst_relation_id
        local worst_attitude_value

        for i = 1, #faction_list do
            callback(function()
                Lib.Campaign.Clicks.diplomacy_select_faction(faction_list[i])
                callback(function()
                    local attitude_value = Lib.Components.Campaign.diplomacy_faction_attitude_value():GetStateText()
                    if(worst_relation_id == nil or worst_attitude_value > attitude_value) then
                        -- checks if current factions attitude has a worse attitude than the stored factions
                        worst_attitude_value = attitude_value
                        worst_relation_id = faction_list[i]
                    end
                end)
            end)
        end

        callback(function()
            Lib.Campaign.Clicks.diplomacy_select_faction(worst_relation_id)
        end)
    end)
end

local function select_random_faction()
    callback(function()
        local faction_list = get_faction_list()
        local faction_choice = math.random(1, #faction_list)
        Lib.Campaign.Clicks.diplomacy_select_faction(faction_list[faction_choice])
    end)
end

-- Sets the member variable "m_already_warring_factions" with a list of factions the player is already at war with.
function Lib.Campaign.Diplomacy.set_already_warring_factions()
	callback(function ()
		Utilities.print("Setting member variable 'm_already_warring_factions' with list of factions already at war with the player faction")
		local table_test = {}
		local human_faction = Lib.Campaign.Actions.get_human_faction(false)
		local warring_factions = human_faction:factions_at_war_with()
		local num_warring_factions = warring_factions:num_items()
		for i=0, num_warring_factions-1 do
			local warring_faction_name = warring_factions:item_at(i):name()
			table.insert(table_test, warring_faction_name)
		end
	end)
end

-- Gets the faction list from the visible Dipolmacy screen and then removes the already at war factions stored in m_already_warring_factions
-- A random faction from the remaining factions is then selected.
-- + The member variable m_target_declare_war_faction is set to the successfully chosen faction key.
local function select_random_not_warring_faction()
    callback(function()
		local diplomacy_faction_parent = Lib.Components.Campaign.diplomacy_faction_parent()
		if (diplomacy_faction_parent ~= nil) then
			local faction_list = get_faction_list()

			Utilities.print("Removing already at war factions from the faction list")
			for _,warring_faction_name in pairs(m_already_warring_factions) do
				for position_key, faction_name in ipairs(faction_list) do
					if warring_faction_name == faction_name:gsub("faction_row_entry_", "") then
						table.remove(faction_list, position_key)
						break
					end
				end
			end

			local faction_choice = math.random(1, #faction_list)
			m_target_declare_war_faction = faction_list[faction_choice]
			Lib.Campaign.Clicks.diplomacy_select_faction(faction_list[faction_choice])
		end
    end)
end

-- Selects a parsed diplomatic action. Can either be entered as the diplomatic_option key or as the in game display name.
-- Examples of the in game names can be found in the g_diplomatic_actions table.
local function select_diplomatic_action(diplomatic_action)
    callback(function()
		diplomatic_action = diplomatic_action:lower():gsub(" ", "_")
        local action_count, action_list = Common_Actions.get_visible_child_count(Lib.Components.Campaign.diplomatic_action_parent())
        local button_found = false
        for k, v in pairs(action_list) do
            if(string.match(v:Id(), diplomatic_action)) then
				Lib.Campaign.Clicks.select_diplomatic_action(v:Id())
				button_found = true
				break
            end
        end
        if(button_found == false) then
            Utilities.print("INFO: Can't offer intended diplomacy to selected faction")
        end
    end)
end

local function get_random_diplomatic_action()
    local diplomatic_choice = math.random(1, #g_diplomatic_actions)
    local diplomacy_name = g_diplomatic_actions[diplomatic_choice]
    local diplomacy_type = g_diplomatic_actions[diplomacy_name]
    return diplomacy_name, diplomacy_type
end

local function propose_payments()
    callback(function()
        local payments = Lib.Components.Campaign.payments_ok()
        if(payments ~= nil and payments:Visible(true) == true and payments:CurrentState() == "active") then
            local payment_type = math.random(1, 2)
            if(payment_type == 1) then
                Lib.Campaign.Clicks.offer_payment()
            else
                Lib.Campaign.Clicks.demand_payment()
            end
            Lib.Campaign.Clicks.payments_ok()
        end
    end)
end

local function propose_join_war()
    callback(function()
        local request = Lib.Components.Campaign.ok_request()
        if(request ~= nil and request:Visible(true) == true) then
            Lib.Campaign.Clicks.ok_request()
        end
    end)
end

-- If the war_declared confirmation box is on screen, the accept button is clicked.
local function declare_war()
    callback(function()
        local declare_war = Lib.Components.Campaign.accept_declare_war()
        if(declare_war ~= nil and declare_war:Visible(true) == true) then
            Lib.Campaign.Clicks.accept_declare_war()
            Lib.Campaign.Clicks.confirm_declare_war()
        end
    end)
end

local function finish_offer()
    callback(function()
        -- either propose or cancel the offer
        local propose = Lib.Components.Campaign.propose_offer()
        if(propose ~= nil and propose:Visible() == true and propose:CurrentState() == "active") then
            local offer_choice = math.random(1, 5)
            if(offer_choice ~= 1) then
                Lib.Campaign.Clicks.propose_offer()
                Lib.Campaign.Clicks.diplomacy_button_accept()
            end
        end
        Lib.Campaign.Clicks.cancel_offer()
        Lib.Campaign.Clicks.cancel_diplomacy()
    end)
end

local function resolve_diplomacy()
    propose_payments()
    propose_join_war()
    declare_war()
    finish_offer()
end

function Lib.Campaign.Diplomacy.propose_diplomatic_action(faction_id, diplomatic_action)
    Lib.Campaign.Diplomacy.open_diplomacy()   
    Lib.Helpers.Misc.wait(1)
    callback(function()
        -- replace this with something that detects if its a good or bad proposed diplomatic action
        diplomatic_action, diplomacy_type = diplomatic_action or get_random_diplomatic_action()
        if(faction_id == nil) then
            select_random_faction()
        else
            Lib.Campaign.Clicks.diplomacy_select_faction(faction_id)
        end
        callback(function()
            local initiate = Lib.Components.Campaign.initiate_diplomacy()
            if(initiate:CurrentState() == "active") then
                Lib.Campaign.Clicks.initiate_diplomacy()
                Lib.Campaign.Clicks.add_offer_demand() --possibly not needed anymore
                select_diplomatic_action(diplomatic_action)
                Lib.Helpers.Misc.wait(1)
                resolve_diplomacy()
            else
                Utilities.print("----- INFO: Cannot peform diplomacy with selected faction -----")
                Lib.Campaign.Clicks.cancel_diplomacy()
            end
        end)
       
    end)
end

local function select_faction_with_high_chance_and_offer()
    callback(function() 
        local faction_count, faction_list = Common_Actions.get_visible_child_count(Lib.Components.Campaign.diplomacy_quick_deal_factions_list_parent())
        local temp_table = {}
        for _,faction in pairs(faction_list) do
            local success_component = UIComponent(faction:Find("label_quick_deal_success_chance"))
            if(success_component~=nil and success_component:CurrentState() == "high")then
                table.insert(temp_table, faction)
            end
        end
        faction_count = #temp_table
        faction_list = temp_table
        
        if(faction_count > 0)then
            --pick a faction
            local random_faction = faction_list[math.random(1,#faction_list)]
            --click a faction
            callback(function() Common_Actions.click_component(random_faction, "Quick Deal Faction (Diplomacy Panel)", true) end)
            --click initiate
            Lib.Campaign.Clicks.initiate_diplomacy(true)
            --click propose
            Lib.Campaign.Clicks.diplomacy_button_accept(true)
            --handle the response
            Lib.Campaign.Clicks.diplomacy_button_accept(true)
            --click cancel
            Lib.Campaign.Clicks.cancel_offer(true)
            --done
            m_quick_deal_found =  true
        else
            --there are no valid factions in this option so we set this to false so the other function knows to try a different option
            m_quick_deal_found = false
        end
    end)
    
end

local function get_quick_deal_options_list()
    local _, options_list = Common_Actions.get_visible_child_count(Lib.Components.Campaign.diplomacy_quick_deal_options_list_parent())
    for k,v in pairs(options_list) do
        if(v:Id() == "divider")then
            table.remove(options_list, k)
        end
    end
    return options_list
end

local function remove_option_from_list(option_to_remove, option_list)
    for k,v in pairs(option_list) do
        if(v == option_to_remove) then
            table.remove(option_list, k)
            break
        end
    end
end

local function select_random_quick_deal_option(option_list)
    callback(function() 
        option_list = option_list or get_quick_deal_options_list()
        if(#option_list > 0)then
            local random_option = option_list[math.random(1,#option_list)]
            Lib.Campaign.Clicks.diplomacy_quick_deal_option(random_option, true)
            select_faction_with_high_chance_and_offer()
            callback(function()
                if (m_quick_deal_found == false) then
                    Utilities.print("No high success there, getting a different option!")
                    remove_option_from_list(random_option, option_list)
                    select_random_quick_deal_option(option_list)
                else
					Lib.Helpers.Test_Cases.set_test_case("Diplomatic Deal Made", "end", false)
                    Lib.Helpers.Test_Cases.update_checkpoint_file("Made diplomatic deal on turn "..tostring(g_turn_number))
                    Utilities.print("Deal found and completed!")
                end
            end)
        else
            Utilities.print("No quick deal options with a high success chance.")
        end
    end)
    callback(function() 
        if(Functions.check_component_visible(Lib.Components.Campaign.diplomacy_cancel_quick_deal(), false, true))then
            Common_Actions.click_component(Lib.Components.Campaign.diplomacy_cancel_quick_deal(), "Cancel Quick Deal (Diplomacy Panel)", true)
            Lib.Helpers.Misc.wait(2) --this delay stops this click getting repeated loads
        end
    end)
end

function Lib.Campaign.Diplomacy.initiate_quick_deal_diplomacy()
    Utilities.print("Beginning Quick deal diplomacy")
	Lib.Helpers.Test_Cases.set_test_case("Diplomatic Deal Made", "start", false)
    Lib.Helpers.Test_Cases.update_checkpoint_file("Making diplomatic deal on turn "..tostring(g_turn_number))
    Lib.Campaign.Diplomacy.open_diplomacy()   
    Lib.Helpers.Misc.wait(1)
    callback(function() 
        Lib.Campaign.Clicks.diplomacy_quick_deal_button(true)
        select_random_quick_deal_option()
    end)
end

-- Selects a random faction from the list displayed on the Diplomacy screen > 
-- Checks to see if they are already at war with the player > If not then war is declared by the player.
-- + The member variable m_target_declare_war_faction is set during this function.
function Lib.Campaign.Diplomacy.select_random_faction_and_declare_war()
	callback(function()
		Lib.Campaign.Diplomacy.open_diplomacy()
		select_random_not_warring_faction()
		Lib.Campaign.Clicks.initiate_diplomacy()
		Lib.Helpers.Misc.wait(1)
		select_diplomatic_action("Declare War")
		declare_war()
        finish_offer()
	end)
end

-- Using the member variable m_target_declare_war_faction, we check that the faction key now appears in the list returned by the faction_script_interface function
-- factions_at_war_with().
function Lib.Campaign.Diplomacy.confirm_faction_is_now_at_war()
	callback(function()
		local fixed_faction_name = m_target_declare_war_faction:gsub("faction_row_entry_", "")
		local human_faction = Lib.Campaign.Actions.get_human_faction(false)
		local warring_factions = human_faction:factions_at_war_with()
		local num_warring_factions = warring_factions:num_items()
		local faction_found
		for i=0, num_warring_factions-1 do
			if (warring_factions:item_at(i):name() == fixed_faction_name) then
				faction_found = true
				break
			end
		end
		if (faction_found ~= true) then
			Utilities.status_print("[Test - Turn 1 Diplomacy - Declare War] ", "fail")
			Utilities.print("----- FAILED! - Selected faction = "..fixed_faction_name.." is not at war with the player.")
		else
			Utilities.status_print("[Test - Turn 1 Diplomacy - Declare War] ", "pass")
			Utilities.print("----- SUCCESS! - Selected faction = "..fixed_faction_name.." is now at war with the player.")
		end

	end)
end