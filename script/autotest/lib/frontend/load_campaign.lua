local m_session_list = {}
local m_save_list = {}
local m_loaded_save_turn_count

local function set_loaded_save_turn_count(loaded_save)
    local turn_component = UIComponent(loaded_save:Find("turn"))
    m_loaded_save_turn_count = turn_component:GetStateText()
end

--get to the saves
function Lib.Frontend.Load_Campaign.open_save_panel()
    callback(function()
        Lib.Frontend.Clicks.campaign_tab()
        Lib.Helpers.Misc.wait(1)
        callback(function()
            if(Functions.check_component_visible(Lib.Components.Frontend.open_save_game_list_button(), false, true))then
                --when loading a network save the button is disabled as it thinks there are no saves so we set it to active manually
                Lib.Components.Frontend.open_save_game_list_button():SetState("active") 
                Lib.Frontend.Clicks.open_save_list(true)
                Lib.Frontend.Load_Campaign.populate_session_list()
                Lib.Frontend.Load_Campaign.populate_save_list()
            end 
        end)
           
    end)
end

--click a specific session
function Lib.Frontend.Load_Campaign.select_specific_session(session_number)
    callback(function() 
        if(session_number <= #m_session_list)then
            if(m_session_list[session_number]:CurrentState() == "selected")then
                Utilities.print("Session is already selected")
            else
                Lib.Frontend.Load_Campaign.select_session(session_number,true)
                Lib.Frontend.Load_Campaign.populate_save_list()
            end
        else
            Utilities.print("Failed!: Asked to click session number: "..tostring(session_number).." but there are only "..tostring(#m_session_list).." sessions in the list.")
        end
    end)
end

--click a specific save
function Lib.Frontend.Load_Campaign.select_specific_save(save_number)
    callback(function() 
        if(save_number <= #m_save_list)then
            if(m_save_list[save_number]:CurrentState() == "selected")then
                Utilities.print("Save is already selected")
            else
                Lib.Frontend.Load_Campaign.select_save(save_number,true)
            end
            set_loaded_save_turn_count(m_save_list[save_number])
        else
            Utilities.print("Failed!: Asked to click save number: "..tostring(save_number).." but there are only "..tostring(#m_save_list).." saves in the list.")
        end
    end)
end

--click a specific save in a specific session
function Lib.Frontend.Load_Campaign.select_specific_save_in_specific_session(session_number, save_number)
    Lib.Frontend.Load_Campaign.select_specific_session(session_number)
    Lib.Frontend.Load_Campaign.select_specific_save(save_number)
end

--get all the sessions
function Lib.Frontend.Load_Campaign.populate_session_list()
    callback(function() 
        _, m_session_list = Common_Actions.get_visible_child_count(Lib.Components.Frontend.session_parent())
    end)
end

--get all the saves
function Lib.Frontend.Load_Campaign.populate_save_list()
    callback(function() 
        _, m_save_list = Common_Actions.get_visible_child_count(Lib.Components.Frontend.save_parent())
    end)
end

--load the latest save
function Lib.Frontend.load_most_recent_save()
    Lib.Frontend.load_specific_save_in_specific_session(1,1)
end

function Lib.Frontend.load_specific_save_in_specific_session(session_choice,save_choice)
    Lib.Frontend.Load_Campaign.open_save_panel()
    Lib.Frontend.Load_Campaign.select_specific_save_in_specific_session(session_choice,save_choice)
    Lib.Frontend.Load_Campaign.load_save(true)
    Lib.Helpers.Timers.start_timer()
    Lib.Campaign.Misc.ensure_campaign_loaded()
    Lib.Helpers.Timers.end_timer("Campaign Load Time")
    g_exit_early = false
end

function Lib.Frontend.Load_Campaign.get_loaded_save_game_turn_count()
    return m_loaded_save_turn_count
end

function Lib.Frontend.Load_Campaign.get_session_list()
    return m_session_list
end

function Lib.Frontend.Load_Campaign.get_save_list()
    return m_save_list
end
function Lib.Frontend.Load_Campaign.select_session(session_number, left_click)
    callback(function()
        Common_Actions.click_component(m_session_list[session_number], "Clicked Session "..tostring(session_number).."(Front end)", left_click)
    end)
end

function Lib.Frontend.Load_Campaign.select_save(save_number, left_click)
    callback(function()
        Common_Actions.click_component(m_save_list[save_number], "Clicked Save"..tostring(save_number).."(Front end)", left_click)
    end)
end

--######## Network Saves ##########

function Lib.Frontend.Load_Campaign.setup_network_save_locations(skip_copy)
    local appdata = os.getenv("APPDATA")
    g_local_file_location = g_local_file_location or appdata.."\\\"The Creative Assembly\"\\Warhammer3\\save_games"
    g_backup_folder_name = os.date("save_games_backup_%d%m%y_%H%M")

    --add a backslash to the end of the network path if there isn't already one
    if(skip_copy == false and string.sub(g_network_save_path, -1) ~= "\\")then
        g_network_save_path = g_network_save_path.."\\"
    end

    --add .save to the end of the save file name if there isn't already one
    if(g_network_save_file_name ~= nil and string.sub(g_network_save_file_name, -5) ~= ".save")then
        g_network_save_file_name = g_network_save_file_name..".save"
    end
    Utilities.print("Local file location: "..tostring(g_local_file_location))
    Utilities.print("Backup folder name: "..tostring(g_backup_folder_name))
    local result_rename = os.execute("rename "..g_local_file_location.." "..g_backup_folder_name)
    local result_make

    if(result_rename ~= 0) then
        Utilities.print("FAILED: Rename function failed, will not continue with loading save, error code: "..tostring(result_rename))
    else
        result_make = os.execute("mkdir "..g_local_file_location)
    end
    
    if(result_make ~= 0) then
        if(result_make ~= nil) then
            Utilities.print("FAILED: Make directory function failed, will not continue with loading save, error code: "..tostring(result_make))
        end
    else
        if(skip_copy == false)then
            Lib.Frontend.Load_Campaign.copy_network_save_to_local()
        end
    end
end

function Lib.Frontend.Load_Campaign.copy_network_save_to_local()
    if(g_network_save_path ~= nil) then
        local network_file_and_folder = "\""..g_network_save_path..g_network_save_file_name.."\""
        local result_copy = os.execute("copy "..network_file_and_folder.." "..g_local_file_location)
        if(result_copy ~= 0) then
            Utilities.print("FAILED: Copy function failed, networked save was not copied, error code: "..tostring(result_copy))
            Utilities.print("File name: "..tostring(network_file_and_folder))
        end
    end
end

function Lib.Frontend.Load_Campaign.copy_all_saves_in_network_folder_to_local()
    if(g_network_save_path ~= nil) then
        local result_copy = os.execute("xcopy "..g_network_save_path.." "..g_local_file_location)
        if(result_copy ~= 0) then
            Utilities.print("FAILED: xCopy function failed, networked saves were not copied, error code: "..tostring(result_copy))
            Utilities.print("Network Folder path: "..tostring(g_network_save_path).." Local Folder path: "..tostring(g_local_file_location))
        end
    end
end

--######## Playthrough Tracker specific functions
local m_stat_names = ""
local m_stat_values = ""

function Lib.Frontend.Load_Campaign.generate_all_session_info(session_choice)
    callback(function() 
        Lib.Frontend.Load_Campaign.select_specific_session(session_choice)
    end)
    callback(function()
        local campaign = Lib.Frontend.Load_Campaign.get_session_campaign(session_choice)
        local faction = Lib.Frontend.Load_Campaign.get_session_faction(session_choice)
        local save_date = Lib.Frontend.Load_Campaign.get_session_save_date(session_choice)
        local save_time = Lib.Frontend.Load_Campaign.get_session_save_time(session_choice)
        --currently hardcoded to run on the first save of the session for this iteraton of the script.
        local difficulty = Lib.Frontend.Load_Campaign.get_save_difficulty(1)
        local save_name = Utilities.prepare_string_for_csv(Lib.Frontend.Load_Campaign.get_save_name(1))

        m_stat_names = "Camapaign Type,Faction,Difficulty,Save Date,Save Time,Save Name"
        m_stat_values = campaign..","..faction..","..difficulty..","..save_date..","..save_time..","..save_name
        Utilities.print(tostring(m_stat_names))
        Utilities.print(tostring(m_stat_values))
    end)
end

function Lib.Frontend.Load_Campaign.get_save_component(save_number)
    if(save_number > 0)then
        if(save_number <= #m_save_list)then
            return m_save_list[save_number]
        else
            Utilities.print("Failed!: Asked to retrieve save number: "..tostring(save_number).." but there are only "..tostring(#m_save_list).." saves in the list. Returning first save.")
            return m_save_list[1]
        end
    end
end

--called in playthrough tracker to add the save/session info to the tracker
function Lib.Frontend.Load_Campaign.get_generated_session_info()
    return m_stat_names, m_stat_values
end

function Lib.Frontend.Load_Campaign.get_session_faction(session_number)
    local session_id = m_session_list[session_number]:Id()
    local session_info_component = Lib.Components.Frontend.session_info_faction(session_id)
    
    return tostring(session_info_component:GetStateText())
end

function Lib.Frontend.Load_Campaign.get_session_campaign(session_number)
    local session_id = m_session_list[session_number]:Id()
    local session_info_component = Lib.Components.Frontend.session_info_campaign(session_id)
    
    return tostring(session_info_component:GetStateText())
end

function Lib.Frontend.Load_Campaign.get_session_save_time(session_number)
    local session_id = m_session_list[session_number]:Id()
    local session_info_component = Lib.Components.Frontend.session_info_save_time(session_id)
    
    return tostring(session_info_component:GetStateText())
end

function Lib.Frontend.Load_Campaign.get_session_save_date(session_number)
    local session_id = m_session_list[session_number]:Id()
    local session_info_component = Lib.Components.Frontend.session_info_save_date(session_id)
    
    return tostring(session_info_component:GetStateText())
end

function Lib.Frontend.Load_Campaign.get_save_difficulty(save_number)
    local save_component = Lib.Frontend.Load_Campaign.get_save_component(save_number)
    local save_difficulty_component = UIComponent(save_component:Find("dy_difficulty"))
    local save_difficulty = save_difficulty_component:GetStateText()
    return save_difficulty
end

function Lib.Frontend.Load_Campaign.get_save_name(save_number)
    local save_component = Lib.Frontend.Load_Campaign.get_save_component(save_number)
    local save_name_component = UIComponent(save_component:Find("name"))
    local save_name = save_name_component:GetStateText()
    return save_name
end

function Lib.Frontend.Load_Campaign.get_save_date_and_time(save_number)
    local save_component = Lib.Frontend.Load_Campaign.get_save_component(save_number)
    local save_date_component = UIComponent(save_component:Find("save_date"))
    local save_date = save_date_component:GetStateText()
    return save_date
end

--###############################
--## economy tracker functions ##
--###############################

local m_current_save_number = 0 --used to track which save we are loading

--recursive function
--works on the latest session in the menu (session 1)
--will go through every single save, in order and load into it to gather economic data
--will only load into saves that have Auto-save in the name as we only target the incremental autosaves
--uses m_current_save_number to load into the next save, however, we want to load into the earliest save first
--to do this we load the save in the list equal to total number of saves - the current save number (starts at 0)
--after we have loaded into the save, logged data and exited, we increment m_current_save_number by 1 and call this function again as long as that number is less than the total number of saves
function Lib.Frontend.Load_Campaign.gather_economy_data_for_all_saves_in_session()
    local log_and_load = false
    --navigate to saves from main menu
    Lib.Frontend.Load_Campaign.open_save_panel()
    
    callback(function()
        local save_name = Lib.Frontend.Load_Campaign.get_save_name(#m_save_list-m_current_save_number)
        if(string.find(tostring(save_name), "Auto-save") ~= nil)then
            log_and_load = true
            Utilities.print("This save IS an autosave, will be clicking! Name: "..tostring(save_name))
        else
            Utilities.print("Name: "..tostring(save_name).." is not an autosave, skipping")
        end
    end)

    callback(function()
        if(log_and_load)then
            Lib.Frontend.load_specific_save_in_specific_session(1, (#m_save_list-m_current_save_number))--start at the last save and work up
            callback(function()
                --call logging function (which exits to main menu)
                Lib.Campaign.Playthrough_Tracker.log_all_economy_info()
            end)
        else
            Utilities.print("Skipping this save, not an auto save!")
        end
    end)
    
    callback(function()
        --increment save number
        m_current_save_number = m_current_save_number+1
        --if save number < #save list call this function again
        if(m_current_save_number < #m_save_list)then
            Lib.Frontend.Load_Campaign.gather_economy_data_for_all_saves_in_session()
        else
            Utilities.print("Finished, no more saves! Current save number: "..m_current_save_number.." Save list length: "..tostring(#m_save_list))
        end
    end)
end
