local m_name_line = "StatName"
local m_stat_line = "StatValue"

local function reset_file_lines()
    m_name_line = "StatName"
    m_stat_line = "StatValue"
end

function Lib.Campaign.Playthrough_Tracker.get_campaign_statistics()
    callback(function()
        --first three lines are getting the session info and adding it to the log lines
        local save_info_names, save_info_stats = Lib.Frontend.Load_Campaign.get_generated_session_info()
        reset_file_lines()
        m_name_line = m_name_line..","..save_info_names
        m_stat_line = m_stat_line..","..save_info_stats 
        Lib.Campaign.Playthrough_Tracker.open_faction_summary()
        Lib.Campaign.Playthrough_Tracker.open_statistics_panel()
        --get the stats and put them into m_name_line and m_stat_line
        Lib.Campaign.Playthrough_Tracker.get_stats()
        --log stat line and name line to csv
        Lib.Campaign.Playthrough_Tracker.log_lines()
        Lib.Campaign.Playthrough_Tracker.close_statistics_panel()
    end)
end

function Lib.Campaign.Playthrough_Tracker.log_lines()
    callback(function() 
        Lib.Campaign.Playthrough_Tracker.record_to_playthrough_tracker(m_name_line)
        Lib.Campaign.Playthrough_Tracker.record_to_playthrough_tracker(m_stat_line)
    end)
end

function Lib.Campaign.Playthrough_Tracker.open_faction_summary()
    callback(function()
        local faction_summary_button = Lib.Components.Campaign.faction_summary_button()
        if(faction_summary_button ~= nil and faction_summary_button:Visible(true) == true) then
            Common_Actions.click_component(faction_summary_button, "Faction Summary (Campaign)", true)
        else
            Lib.Campaign.Playthrough_Tracker.open_faction_summary()
        end
    end)
end

function Lib.Campaign.Playthrough_Tracker.open_statistics_panel()
    callback(function()
        local statistics_button = Lib.Components.Campaign.faction_statistics_button()
        if(statistics_button ~= nil and statistics_button:Visible(true) == true) then
            Common_Actions.click_component(statistics_button, "Statistics (Faction Summary)", true)
        else
            Lib.Campaign.Playthrough_Tracker.open_statistics_panel()
        end
    end)
end

function Lib.Campaign.Playthrough_Tracker.close_statistics_panel()
    callback(function()
        local close_button = Lib.Components.Campaign.faction_summary_close_button()
        if(close_button ~= nil and close_button:Visible(true) == true) then
            Common_Actions.click_component(close_button, "Close Panel (Faction Summary)", true)
        else
            Lib.Campaign.Playthrough_Tracker.close_statistics_panel()
        end
    end)
end

function Lib.Campaign.Playthrough_Tracker.get_stats(loop_count)
    loop_count = loop_count or 0
    callback(function()
        local statistics_parent = Lib.Components.Campaign.faction_statistics_list_parent()
        if(statistics_parent ~= nil) then
            local stat_count, stat_list = Common_Actions.get_visible_child_count(statistics_parent)

            for k,stat_item in pairs(stat_list) do
                if(stat_item:Id() == "item")then
                    local stat_name = stat_item:GetStateText()
                    local stat_value = UIComponent(stat_item:Find("dy_field")):GetStateText()

                    m_name_line = m_name_line..","..tostring(stat_name)
                    m_stat_line = m_stat_line..","..tostring(stat_value)
                end
            end
        else
            if(loop_count < 10)then
                Lib.Campaign.Playthrough_Tracker.get_stats(loop_count+1)
            else
                --if the panel fails to open after 10 attempts we break out of the loop and print and log an error to make it absolutely clear there was an error
                Utilities.print("FAILED! Statistics panel is not loading, component path may have changed or panel may be bugged.")
                m_name_line = m_name_line..",ERROR | STATISTICS PANEL DID NOT OPEN"
                m_stat_line = m_stat_line..",PLEASE CONTACT A MEMBER OF THE AUTOMATION TEAM"
            end
            
        end
    end)
end

function Lib.Campaign.Playthrough_Tracker.set_playthrough_tracker_details()
    Utilities.print("LOGS! "..g_playthrough_tracker_location)
    g_playthrough_tracker_file_name = os.date("playthrough_tracker_%d%m%y_%H%M")
    local result = os.execute("mkdir \""..g_playthrough_tracker_location.."\"")
    Utilities.print("MKDIR RESULT: "..tostring(result))
end

function Lib.Campaign.Playthrough_Tracker.record_to_playthrough_tracker(line_to_write)
    callback(function()
        Utilities.print("Logging a stat to CSV! Loc: "..tostring(g_playthrough_tracker_location).." File name: "..tostring(g_playthrough_tracker_file_name))
        if(g_playthrough_tracker_location ~= nil) then
            Functions.write_to_document(line_to_write, g_playthrough_tracker_location, g_playthrough_tracker_file_name, ".csv", false)
        end
    end)
end

function Lib.Campaign.Playthrough_Tracker.log_info_from_all_sessions()
    callback(function()
        local session_list = Lib.Frontend.Load_Campaign.get_session_list()
        Lib.Campaign.Playthrough_Tracker.log_info_from_session_loop(1, #session_list)
    end)
end

function Lib.Campaign.Playthrough_Tracker.log_info_from_session_loop(session_index, session_count)
    callback(function()
        Lib.Campaign.Playthrough_Tracker.set_playthrough_tracker_details()
        local load_game_panel = Functions.find_component("load_save_game")
        if(load_game_panel == nil or load_game_panel:Visible() == false)then
            Lib.Frontend.Load_Campaign.open_save_panel()
        end
        --get session info
        Lib.Frontend.Load_Campaign.generate_all_session_info(session_index)
        --load save in session
        Lib.Frontend.load_specific_save_in_specific_session(session_index, 1)
        --get campaign info
        Lib.Campaign.Playthrough_Tracker.get_campaign_statistics()

        Lib.Menu.Misc.quit_to_frontend()
        Lib.Frontend.Misc.ensure_frontend_loaded()

        session_index = session_index +1
        if(session_index <= session_count)then
            Lib.Campaign.Playthrough_Tracker.log_info_from_session_loop(session_index, session_count)
        end
    end)
end

--############### stuff and things ########################

function Lib.Campaign.Playthrough_Tracker.load_into_all_quick_saves()
    callback(function()
        local session_list = Lib.Frontend.Load_Campaign.get_session_list()
        Lib.Campaign.Playthrough_Tracker.load_into_quick_save_start_battle_and_time_it_bro(1, #session_list)
    end)
end

function Lib.Campaign.Playthrough_Tracker.load_into_quick_save_start_battle_and_time_it_bro(session_index, session_count)
    callback(function()
        
        local load_game_panel = Functions.find_component("load_campaign_holder")
        if(load_game_panel == nil or load_game_panel:Visible() == false)then
            Lib.Frontend.Load_Campaign.open_save_panel()
        end
        --get save name?
        g_battle_name = "campaign battle "..tostring(session_index)
        local test = Lib.Frontend.Load_Campaign.get_save_name(1)
        if(test ~= nil) then
            g_battle_name = test
        end

        Lib.Campaign.Actions.set_battle_settings(true,false, false, 5, false)
        Lib.Campaign.Actions.listen_for_pre_battle()
        Lib.Campaign.Misc.listen_for_post_battle_results()

        --load save in session
        Lib.Frontend.load_specific_save_in_specific_session(session_index, 1)

        --start the battle, record the battle time then quit

        Lib.Menu.Misc.quit_to_frontend()
        Lib.Frontend.Misc.ensure_frontend_loaded()

        session_index = session_index +1
        if(session_index <= session_count)then
            Lib.Campaign.Playthrough_Tracker.load_into_quick_save_start_battle_and_time_it_bro(session_index, session_count)
        end
    end)
end



--#######################################################

--########################################################################
--##################### ECONOMY TRACKER FUNCTIONS ########################
--### seemed unncessary to make a new file as functionality is similar ###
--########################################################################

--member variables for economy tracker
local m_background_income
local m_num_regions
local m_turn
local m_header_created = false

function Lib.Campaign.Playthrough_Tracker.set_economy_tracker_details()
    Utilities.print("LOGS! "..g_economy_tracker_location)
    g_economy_tracker_file_name = os.date("economy_tracker_%d%m%y_%H%M")
    local result = os.execute("mkdir \""..g_economy_tracker_location.."\"")
    Utilities.print("MKDIR RESULT: "..tostring(result))
end

function Lib.Campaign.Playthrough_Tracker.record_to_economy_tracker(line_to_write)
    callback(function()
        Utilities.print("Logging a stat to CSV! Loc: "..tostring(g_economy_tracker_location).." File name: "..tostring(g_economy_tracker_file_name))
        if(g_economy_tracker_location ~= nil) then
            Functions.write_to_document(line_to_write, g_economy_tracker_location, g_economy_tracker_file_name, ".csv", false)
        end
    end)
end

local function remove_any_icon_text(heading_text) 
    return string.gsub(heading_text, "%[%[(.*)%]%]%[%[/img%]%]", "") --have to use % as escape character for square brackets due to pattern matching
end

local function get_background_income() --currently unused but background income may be required later so have left it in
    callback(function()
        m_background_income = Lib.Components.Campaign.treasury_details_background_income_value():GetStateText()
    end)
end

--loops through all children of the list parent grabbing the data we need
--logs all data and headers (once) to the economy_tracker file
--have kept the print outs of the data to make it easier to see what the script did and find any errors that might occur
local function log_all_economy_data()
    callback(function()
        local _, data_list = Common_Actions.get_visible_child_count(Lib.Components.Campaign.treasury_details_list_parent())
        local header_line = ""
        local data_line = ""

        local value_component_to_use = "dy_value2" --if it's turn 1 we want to use dy_value1, otherwise dy_value2
        if(m_turn == 1)then
            value_component_to_use = "dy_value1"
        end

        --Utilities.print("Background Income: "..tostring(m_background_income)) --background income might be needed later, can simply uncomment if needed
        Utilities.print("Region count: "..tostring(m_num_regions))
        Utilities.print("Turn: "..tostring(m_turn))

        local treasury = Lib.Campaign.Faction_Info.get_treasury()
        local income = Lib.Campaign.Faction_Info.get_income()

        header_line = "Turn,Regions,Gold,Income"
        data_line = tostring(m_turn)..","..tostring(m_num_regions)..","..tostring(treasury)..","..tostring(income)

        for _,list_child in ipairs(data_list) do
            if(string.sub(list_child:Id(), 1,5) == "entry")then --we only want to get data from children with an Id starting "entry"
                local heading_text = UIComponent(list_child:Find("dy_item_name")):GetStateText()
                local data_text = UIComponent(list_child:Find(value_component_to_use)):GetStateText()

                heading_text = remove_any_icon_text(heading_text)

                --add heading and data text to the appropriate lines for logging later
                header_line = header_line..","..tostring(heading_text)
                data_line = data_line..","..tostring(data_text)

                Utilities.print(tostring(heading_text)..": "..tostring(data_text))
            elseif(string.sub(list_child:Id(), 1,5) == "heade" and list_child:ChildCount() > 1)then --there are two bits of data that aren't in "entry" components
                local text_component = list_child:Find("tx_item_name") --deliberately don't cast to a component yet, so we can check if the result is nil
                local data_to_add, header_to_add
                if(text_component ~= nil and UIComponent(text_component):GetStateText() == "Total Income" or UIComponent(text_component):GetStateText() == "Total Expenses")then
                    data_to_add = UIComponent(list_child:Find(value_component_to_use)):GetStateText()
                    header_to_add = UIComponent(text_component):GetStateText()

                    Utilities.print(tostring(header_to_add)..": "..tostring(data_to_add))
                end
                header_line = header_line..","..header_to_add
                data_line = data_line..","..data_to_add
            end 
        end
        
        Utilities.print(header_line)
        Utilities.print(data_line)

        if(not m_header_created)then --we only want to add the header line once per script run
            Lib.Campaign.Playthrough_Tracker.record_to_economy_tracker(header_line)
            m_header_created = true
        end
        Lib.Campaign.Playthrough_Tracker.record_to_economy_tracker(data_line)
    end)
end

local function get_turn_and_region_count()
    callback(function()
        m_num_regions = Lib.Campaign.Faction_Info.get_region_count()
        m_turn = Lib.Campaign.Misc.get_current_turn_number()
    end)
end

function Lib.Campaign.Playthrough_Tracker.log_all_economy_info()
    callback(function()
        Lib.Campaign.Clicks.open_treasury_details_panel()
        --get_background_income() --background income might be needed later, can simply uncomment if needed
        Lib.Campaign.Clicks.open_details_tab()
        get_turn_and_region_count()
        
        log_all_economy_data()
        Lib.Campaign.Clicks.close_treasury_details_panel()

        Lib.Menu.Misc.quit_to_frontend()
        Lib.Frontend.Misc.ensure_frontend_loaded()
    end)
end