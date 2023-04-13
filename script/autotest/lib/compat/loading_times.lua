--## TIMER FUNCTIONS ##--

function Lib.Compat.Loading_Times.create_results_folder()
    callback(function()
        g_battle_timer_directory = os.getenv("APPDATA").."\\CA_Autotest\\WH3\\loading_times"
        Utilities.print("LOGS! "..g_battle_timer_directory)
        g_file_name = "loading_times"
        os.execute("mkdir \""..g_battle_timer_directory.."\"")
    end)
end

-- returns the PC ram amount in GB
local function get_ram_amount()
    local pipe = io.popen("wmic computersystem get totalphysicalmemory")
    local out_data = pipe:read("*a")
    pipe:close()
    local ram_amount_bytes = string.match(out_data, "%d+")
    local ram_amount = math.ceil(tonumber(ram_amount_bytes)/1073741824)
    return ram_amount
end

function Lib.Compat.Loading_Times.write_loading_times_results_to_file(test_type, battle_type, map, faction, lord, fresh_start, compat_run)
    callback(function()
        local ram = " " -- non-compat runs don't need RAM amount, but a value is still needed for the write_to_document function
        if compat_run then ram = get_ram_amount() end
        for test_name, result in pairs(g_loading_times_data) do
            local results = test_type..","..battle_type..","..map..","..faction..","..lord..","..test_name..","..result..","..g_build_number..","..g_changelist..","..os.date("%d/%m/%Y")..","..os.date("%H:%M")..","..fresh_start..","..ram
            Functions.write_to_document(results, g_battle_timer_directory, g_file_name, ".csv", false)
        end
    end)
end

-- these headers should be used for all compat timer files so they can all be imported into the same powerBI report
function Lib.Compat.Loading_Times.create_loading_times_file()
    callback(function()
        local results_file = g_battle_timer_directory.."\\"..g_file_name..".csv"
        if not Functions.check_file_exists(results_file) then
            Functions.write_to_document("Test Type,Battle Type,Map,Faction,Lord,Test Case,Time(s),Build,Changelist,Date,Time,Restart,RAM(GB)", g_battle_timer_directory, g_file_name, ".csv", false)
        else
            Utilities.print("File already exists, skipping creating the column headers")
        end
    end)
end

function Lib.Compat.Loading_Times.reset_loading_times_data()
    callback(function()
        g_loading_times_data["Campaign Load Time"] = " "
        g_loading_times_data["Battle Load Time"] = " "
        g_loading_times_data["Return to Campaign Time"] = " "
        g_loading_times_data["Return to Frontend Time"] = " "
    end)
end

--## CAMPAIGN FUNCTIONS ##--
-- we test the loading times twice so we can compare loading times for new game start and for reloading inside the game
function Lib.Compat.Loading_Times.campaign_loading_times_loop(variables)
    callback(function()
        local count = 1
        if variables.custom_compat_variables then
            count = tonumber(core:svr_load_registry_string("compat_campaign_lord_count"))
            if (count == nil or count =='') then count = 1 end --safeguard in case there is no registry string with the value.
        end
        Lib.Compat.Loading_Times.create_results_folder()
        Lib.Compat.Loading_Times.create_loading_times_file()
        if variables.lord == 'Random' then -- if lord is set to random, then the 2 sweeps can run with different lords.
            variables.lord = Lib.Frontend.Campaign.get_random_lord(variables.campaign_type)
        end
        Lib.Compat.Loading_Times.campaign_loading_times_sweep(variables, count, "Yes")
        Lib.Compat.Loading_Times.campaign_loading_times_sweep(variables, count, "No")
        if type(variables.lord) ~= "string" then -- checks if lord is just a string or a table
            if count < Common_Actions.table_length(variables.lord) then
                callback(function() core:svr_save_registry_string("compat_campaign_lord_count", tostring(count + 1)) end)
            else
                callback(function() core:svr_save_registry_string("compat_campaign_lord_count", "1") end)
            end
        else
            callback(function() core:svr_save_registry_string("compat_campaign_lord_count", "1") end)
        end
    end)
end

function Lib.Compat.Loading_Times.campaign_loading_times_sweep(variables, count, fresh_start)
    callback(function()
        local lord
        if type(variables.lord) == "string" then -- if lord is just a string, then just use it as it is
            lord = variables.lord
        else
            lord = variables.lord[count]
        end
        Lib.Frontend.Misc.ensure_frontend_loaded()
        Lib.Frontend.Loaders.load_chaos_campaign(lord, variables.campaign_type)
        Lib.Campaign.Misc.ensure_cutscene_ended()
        Lib.Campaign.Actions.attack_nearest_target(10)
        Lib.Menu.Misc.quit_to_frontend()
        Lib.Frontend.Misc.ensure_frontend_loaded()
        callback(function()
            Lib.Helpers.Timers.end_timer("Return to Frontend Time")
            if lord == '[PH] Daemon Prince' then lord = 'Daemon Prince' end
            Lib.Compat.Loading_Times.write_loading_times_results_to_file("Campaign - "..variables.campaign_type, g_battle_type_names[g_battle_type_from_cco], string.gsub(tostring(g_battle_name_from_cco), "Battle of ", ""), g_race_name, lord, fresh_start, variables.compat_run)
            Lib.Helpers.Misc.wait(5)
            Lib.Compat.Loading_Times.reset_loading_times_data()
            Lib.Campaign.Actions.reset_battle_fought()
        end)
    end)
end

--## CUSTOM BATTLE FUNCTIONS ##--

function Lib.Compat.Loading_Times.custom_battle_loading_times_sweep(variables)
    callback(function()
        
    end)
end

--## BATTLE REPLAYS FUNCTIONS ##--

function Lib.Compat.Loading_Times.replay_loading_times_loop(variables)
    callback(function()
        Lib.Compat.Loading_Times.create_results_folder()
        Lib.Compat.Loading_Times.create_loading_times_file()
        local replays = Functions.get_file_names_in_directory(variables.target_folder)
        for _,replay in ipairs(replays) do
            Lib.Compat.Loading_Times.custom_battle_loading_time_replays_sweep(replay, "Yes")
            Lib.Frontend.Clicks.return_to_main_menu()
            Lib.Compat.Loading_Times.custom_battle_loading_time_replays_sweep(replay, "No")
        end
    end)
end

function Lib.Compat.Loading_Times.custom_battle_loading_time_replays_sweep(replay, fresh_start)
    callback(function()
        local replay_name = string.match(replay, "(.*)%.")
        Lib.Frontend.Loaders.load_replay(replay_name)
        Lib.Battle.Misc.concede_battle_after_duration(30)
        callback(function()
            Lib.Compat.Loading_Times.write_loading_times_results_to_file("Custom Battle", g_battle_type_names[g_battle_type_from_cco], replay_name, g_faction_name_from_cco, " ", fresh_start)
            Lib.Helpers.Misc.wait(5)
            Lib.Compat.Loading_Times.reset_loading_times_data()
        end)
    end)
end

--## CAMPAIGN SAVES FUNCTIONS ##--

--technically this will load into all save types but then immediately quit out of any save that doesn't start in the pre-battle
--the intention is that it will be run on a save repo of only pre-battle quick saves but in case there are some that aren't like that, it handles it
--annoyingly there is no reliable way to determine save type or if it is pre-battle without loading into it
function Lib.Compat.Loading_Times.load_into_all_quick_saves_for_battle_load_times()
    callback(function()
        local session_list = Lib.Frontend.Load_Campaign.get_session_list()
        Lib.Compat.Misc.load_quicksave_and_time_battle_loading(1, #session_list, 1)
    end)
end

--loads into a save (again, technically it will load into any save)
--before loading the save it sets up the battle listeners and instructs it to manually fight the battle
--once the campaign loads the listeners will either fire if theres a pre-battle or it will go straight to quitting the campaign
--if the listeners DO fire they have function calls to start, stop and log the timer for loading into the battle and out
function Lib.Compat.Loading_Times.load_quicksave_and_time_battle_loading(session_index, session_count, save_index)
    callback(function()
        local load_game_panel = Functions.find_component("load_save_game")
        if(load_game_panel == nil or load_game_panel:Visible() == false)then
            Lib.Frontend.Load_Campaign.open_save_panel()
        end
    end)
    callback(function()
        Lib.Frontend.Load_Campaign.select_specific_save_in_specific_session(session_index, save_index)
    end)
    callback(function()
        --get save name?
        
        g_battle_name = "campaign battle "..tostring(session_index)
        local save_name = Lib.Frontend.Load_Campaign.get_save_name(save_index)
        local save_date = Lib.Frontend.Load_Campaign.get_save_date_and_time(save_index)
        save_date = string.gsub(save_date, " ", "_")
        if(save_name ~= nil) then
            g_battle_name = string.format("%q", save_name.."_"..save_date) --most quick saves have similar names so we add the date and time to help distinguish them
            Utilities.print("Battle name is: "..tostring(g_battle_name).." Session: "..tostring(session_index).." Save: "..tostring(save_index))
        end

        Lib.Campaign.Actions.set_battle_settings(true,false, false, 5, false) --set the listener to do manual battles and leave after 5 seconds
        Lib.Campaign.Actions.listen_for_pre_battle()
        Lib.Campaign.Misc.listen_for_post_battle_results()

        --load save in session
        Lib.Frontend.load_specific_save_in_specific_session(session_index, 1)

        --start the battle, record the battle time then quit

        Lib.Menu.Misc.quit_to_frontend()
    end)
    callback(function()
        Lib.Frontend.Misc.ensure_frontend_loaded()
        local save_list = Lib.Frontend.Load_Campaign.get_save_list()
        local save_list_size = #Lib.Frontend.Load_Campaign.get_save_list()
        if(save_index < save_list_size)then
            Utilities.print("There are more saves in this session")
            save_index = save_index + 1
        else
            Utilities.print("There are NO more saves in this session")
            save_index = 1
            session_index = session_index +1
        end
        
        if(session_index <= session_count)then
            Lib.Compat.Loading_Times.load_quicksave_and_time_battle_loading(session_index, session_count, save_index)
        end
    end)
end