local start_time = os.time()
local m_clock_timer
local m_clock_timer_start_time
local m_battle_load_timer

function Lib.Helpers.Timers.start_timer()
    callback(function()
        m_clock_timer_start_time = os.clock()
    end)
end

-- if passed a result_name, the name and the result are going to be stored in the g_loading_times_data table also
function Lib.Helpers.Timers.end_timer(result_name)
    callback(function()
        result_name = result_name or nil
        m_clock_timer = Functions.get_time_difference(m_clock_timer_start_time)
        if result_name ~= nil then
            g_loading_times_data[result_name] = tostring(m_clock_timer)
        end
    end)
end

-- create_timers_file will generate the battle file and add the headers (first row) to it before starting to write actual loading times & battle information (needed for custom battle loading times)
function Lib.Helpers.Timers.create_battle_folder(create_timers_file)
    callback(function()
        create_timers_file = create_timers_file or false
        local appdata = os.getenv("APPDATA")
        g_battle_timer_directory = appdata.."\\CA_Autotest\\WH3\\custom_battle_loading_times"
        Utilities.print("LOGS! "..g_battle_timer_directory)
        g_battle_clock = os.date("custom_battle_%d%m%y_%H%M")
        os.execute("mkdir \""..g_battle_timer_directory.."\"")
        if create_timers_file then
            Functions.write_to_document("Battle Type,Map Name,Custom Battle Load Time,Return to Frontend Time", g_battle_timer_directory, g_battle_clock, ".csv", false)
        end
    end)
end

function Lib.Helpers.Timers.create_campaign_folder()
    callback (function()
        local appdata = os.getenv("APPDATA")
        g_campaign_timer_directory = appdata.."\\CA_Autotest\\WH3\\campaign_loading_times"
        Utilities.print("LOGS! "..g_campaign_timer_directory)
        g_campaign_clock = os.date("campaign_%d%m%y_%H%M")
        os.execute("mkdir \""..g_campaign_timer_directory.."\"")
    end)
end

function Lib.Helpers.Timers.write_battle_timers_to_file(log_name)
    callback(function()
        Utilities.print(tostring("Loading Time: "..m_clock_timer))
        local clock_timer_printout = log_name..","..tostring(m_clock_timer)
        if (g_battle_timer_directory ~= nil) then
            Functions.write_to_document(clock_timer_printout, g_battle_timer_directory, g_battle_clock, ".csv", false)
        end
    end)
end

function Lib.Helpers.Timers.write_campaign_timers_to_file(log_name)
    callback(function() 
        Utilities.print(tostring("Loading Time: "..m_clock_timer))
        local clock_timer_printout = log_name..","..tostring(m_clock_timer)
        if(g_campaign_timer_directory ~= nil) then
            Functions.write_to_document(clock_timer_printout, g_campaign_timer_directory, g_campaign_clock, ".csv", false)
        end
    end)
end

function Lib.Helpers.Timers.write_battle_details_to_file()
    callback(function()
        if (g_battle_timer_directory ~= nil) then
            Functions.write_to_document ("Battle Type"..","..g_battle_settings["Map Type"], g_battle_timer_directory, g_battle_clock, ".csv", false)
            Functions.write_to_document ("Map Name"..","..g_map_name, g_battle_timer_directory, g_battle_clock, ".csv", false)
            for team = 1, 2 do 
                for player = 1, 8 do
                    if g_battle_settings["Player Faction: Team-"..team.." Player-"..player..""] ~= nil then
                        Functions.write_to_document ("Team " ..team.." Faction "..player..","..g_battle_settings["Player Faction: Team-"..team.." Player-"..player..""], g_battle_timer_directory, g_battle_clock, ".csv", false)
                    end
                 end
             end
        end
    end)
end

function Lib.Helpers.Timers.write_campaign_details_to_file()
    callback(function()
if (g_campaign_timer_directory ~= nil) then
    Functions.write_to_document ("Campaign Mode"..","..g_campaign_name, g_campaign_timer_directory, g_campaign_clock, ".csv", false)
    Functions.write_to_document ("Lord Name"..","..g_lord_name, g_campaign_timer_directory, g_campaign_clock, ".csv", false)
    Functions.write_to_document ("Faction Name"..","..g_race_name, g_campaign_timer_directory, g_campaign_clock, ".csv", false)
        end
    end)
end

-- this is used in the custom battle loading times script to ensure that timers are outputted on the same row like this: battle type, battle name, load into battle, load out of battle
function Lib.Helpers.Timers.write_both_battle_timers_to_file(log_name)
    callback(function()
        Utilities.print(tostring("Loading Time Into Battle: "..m_battle_load_timer))
        Utilities.print(tostring("Loading Time Out of Battle: "..m_clock_timer))
        local clock_timer_printout = log_name..","..tostring(m_battle_load_timer)..","..tostring(m_clock_timer)
        if (g_battle_timer_directory ~= nil) then
            Functions.write_to_document(clock_timer_printout, g_battle_timer_directory, g_battle_clock, ".csv", false)
        end
    end)
end
