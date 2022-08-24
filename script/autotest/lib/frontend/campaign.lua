function Lib.Frontend.Campaign.select_chaos_campaign_race(race, campaign_type)
    callback(function() 
        local loop_counter = 0
        local race_component
        local race_name_component
        local campaign_name_component
        campaign_type = campaign_type or "The Realm of Chaos"
        Lib.Frontend.Clicks.race_select_button()
        repeat
            -- you can manually select a certain faction with their component ID, such as "troy_main_dan_ithaca"
            race = race or Lib.Frontend.Campaign.get_random_race(campaign_type)

            race_id = g_immortal_empires_race_list[race]

            race_component = Lib.Components.Frontend.campaign_race_select(race_id)
            campaign_name_component = Lib.Components.Frontend.campaign_name()
            g_campaign_name = campaign_name_component:GetStateText()
            g_race_name = race
            
            loop_counter = loop_counter + 1
            if(loop_counter == 100) then                
                Utilities.print("Failed to find selection button for: "..race..".... FAILED!")
                Lib.Frontend.Clicks.return_to_main_menu(true)
                Lib.Frontend.Misc.quit_to_windows()
            end
        until Functions.check_component_visible(race_component) or loop_counter == 100
        Lib.Frontend.Clicks.campaign_race_select(race_id)
    end)
end

function Lib.Frontend.Campaign.get_random_race(campaign_type)
    local race_name
    local random_number
    local table_to_use
    local count = 1

    if(campaign_type ~= "The Realm of Chaos")then
        random_number = math.random(1, Common_Actions.table_length(g_immortal_empires_race_list))
        table_to_use = g_immortal_empires_lord_list
    else
        random_number = math.random(1, Common_Actions.table_length(g_chaos_race_list))
        table_to_use = g_chaos_lord_list
    end
    
    for k,_ in pairs(table_to_use) do
        if(count == random_number)then
            Utilities.print("Random race found!")
            race_name = k
        end
        count = count+1
    end

    return race_name
end

local function set_demon_prince_name()
    callback(function() 
        --a table of possible demon prince names the autotest can pick from, partly for fun but also so that edge cases/specific tests can be checked
        local demon_prince_names = {
            "Bedson The Mighty Prince of Khorne", 
            "Demony McDemonface", 
            os.getenv("USERNAME"),
            "TW Daemon", 
            "1234567890", 
            "Demon #~'[]{} Prince",
            "(•_•)", --to test special characters
            "Censor Bitch Bastard Fuck Test", --to test censoring
            "Matt Daemon",
            "øǢǣǼǽÆ̀æ̀Æ̂æ̂ǢǣÆ̃æ̃ÖÅ",
            "悪魔",
            "ضﷺپ"
        }
        
        Utilities.print("Setting Demon Prince name")

        local random_number = math.random(1, #demon_prince_names)
        Lib.Components.Frontend.demon_prince_name_text_field():SetStateText(demon_prince_names[random_number])

        Utilities.print("Demon Prince name set to random name "..tostring(random_number).." which is: "..demon_prince_names[random_number].." (special characters might appear incorrectly in the log)")
    end)
end

function Lib.Frontend.Campaign.select_chaos_campaign_lord(lord, campaign_type)
    callback(function() 
        local loop_counter = 0
        local lord_component
        local lord_name_component
        local lord_id
        campaign_type = campaign_type or "The Realm of Chaos"
        repeat
            -- you can manually select a certain faction with their component ID, such as "troy_main_dan_ithaca"
            lord = lord or Lib.Frontend.Campaign.get_random_lord(campaign_type)
            if(campaign_type ~= "The Realm of Chaos")then
                lord_id = g_immortal_empires_lord_list[lord][2]
            else
                lord_id = g_chaos_lord_list[lord][2]
            end

            lord_component = Lib.Components.Frontend.campaign_lord_select(lord_id)
            lord_name_component = Lib.Components.Frontend.campaign_lord_select_name()
            g_lord_name = lord_name_component:GetStateText()

            --if the demon prince is selected, we need to set his name before we can start the campaign
            if(Functions.check_component_visible(Lib.Components.Frontend.demon_prince_name_text_field(), false, true)) then
                set_demon_prince_name()
            end
            g_lord = lord
            loop_counter = loop_counter + 1
            if(loop_counter == 100) then                
                Utilities.print("Failed to find selection button for: "..lord..".... FAILED!")
                Lib.Frontend.Misc.quit_to_windows()
            end
        until Functions.check_component_visible(lord_component) or loop_counter == 100
        Lib.Frontend.Campaign.verify_lord_is_available_and_select_it(lord, lord_id, campaign_type)
    end, wait.long)
end

function Lib.Frontend.Campaign.get_random_lord(campaign_type)
    local lord_name
    local random_number
    local table_to_use
    local count = 1
    campaign_type = campaign_type or "The Realm of Chaos"
    if(campaign_type ~= "The Realm of Chaos")then
        Utilities.print("Using Immortals table, campaign type is: "..tostring(campaign_type))
        random_number = math.random(1, Common_Actions.table_length(g_immortal_empires_lord_list))
        table_to_use = g_immortal_empires_lord_list
    else
        Utilities.print("Using Chaos table, campaign type is: "..tostring(campaign_type))
        random_number = math.random(1, Common_Actions.table_length(g_chaos_lord_list))
        table_to_use = g_chaos_lord_list
    end
    
    for k,_ in pairs(table_to_use) do
        if(count == random_number)then
            Utilities.print("Random Lord found! Lord: "..tostring(k))
            lord_name = k
        end
        count = count+1
    end

    return lord_name
end


-- this checks if the lord is available (not hidden behind achievement or dlc mask)
-- if the lord is unavailable, it selects another random one and loops back to select_chaos_campaign_lord
function Lib.Frontend.Campaign.verify_lord_is_available_and_select_it(lord, lord_id, campaign_type)
    callback(function()
        local lord_component = Lib.Components.Frontend.campaign_lord_select(lord_id)
        local missing_content_icon = UIComponent(lord_component:Find("new_content_icon"))
        if (lord_component:CurrentState() ~= "inactive" and missing_content_icon:Visible() == false) then
            Lib.Frontend.Clicks.campaign_lord_select(lord_id)
        else
            Utilities.print("The lord "..lord.." cannot be selected, chosing another random one.")
            lord = Lib.Frontend.Campaign.get_random_lord(campaign_type)
            local race = g_immortal_empires_lord_list[lord][1]
            local race_id = g_immortal_empires_race_list[race]
            Lib.Frontend.Clicks.race_select_button()
            Lib.Helpers.Misc.wait(1)
            Lib.Frontend.Clicks.campaign_race_select(race_id)
            Lib.Helpers.Misc.wait(1)
            Lib.Frontend.Campaign.select_chaos_campaign_lord(lord, campaign_type)
        end
    end)
end