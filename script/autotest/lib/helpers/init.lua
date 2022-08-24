function Lib.Helpers.Init.script_name(name)
    Utilities.print(name)
    Lib.Helpers.Test_Cases.setup_test_cases_and_checkpoints(name)
    Lib.Helpers.Misc.check_if_retail()
    callback(function()
        Lib.Helpers.Init.set_autotest_log_file_details()
        Utilities.print("-----------------------------------------------------------------------------------------")
        Utilities.print("-----------------------------------------------------------------------------------------")
        Utilities.print("Game Scripted Autotest (GSAT) - " .. name)
        Utilities.print("Autotest log - " .. g_auotest_log_file_name)
        if g_retail_test then
            Utilities.print("Game config - RETAIL")
        else
            Utilities.print("Game config - NON-RETAIL")
        end
        if(not g_simple_clicks)then
            g_simple_clicks = false
            Utilities.print("Simple Clicks disabled (this is the normal/default type of click)")
        else
            Utilities.print("Simple Clicks enabled (this can be risky if you don't know what you're doing!)")
        end
        Utilities.print("-----------------------------------------------------------------------------------------")
        Utilities.print("-----------------------------------------------------------------------------------------")
        Lib.Helpers.Init.initialize_global_variables()
        Lib.Helpers.Test_Cases.set_test_case("GSAT Finished Successfully", "start", false)
        --Lib.Helpers.Init.check_for_duplicate_script_tags()
    end)
end

function Lib.Helpers.Init.initialize_global_variables()
    battle_settings = {}
end

function Lib.Helpers.Init.set_autotest_log_file_details()
    local appdata = os.getenv("APPDATA")
    g_auotest_log_file_location = appdata.."\\CA_Autotest\\WH3\\autotest_logs"
    g_auotest_log_file_name = os.date("autotest_log_%d%m%y_%H%M")
    os.execute("mkdir \""..g_auotest_log_file_location.."\"")
end

function Lib.Helpers.Init.check_for_duplicate_script_tags()
    callback(function()
        -- When using ScriptTag, if two components are tagged with the same name it causes a game assert. If this triggers, make it a priority to fix the duplication.
        -- If new components files are created, ensure to add them here.
        local file_list = {
            battle = [[T:\branches\warhammer3\dev\warhammer\working_data\script\autotest\lib\components\battle.lua]],
            campaign = [[T:\branches\warhammer3\dev\warhammer\working_data\script\autotest\lib\components\campaign.lua]],
            frontend = [[T:\branches\warhammer3\dev\warhammer\working_data\script\autotest\lib\components\frontend.lua]],
            helpers = [[T:\branches\warhammer3\dev\warhammer\working_data\script\autotest\lib\components\helpers.lua]],
            menu = [[T:\branches\warhammer3\dev\warhammer\working_data\script\autotest\lib\components\menu.lua]]
        }
        
        local component_list = {}

        for k, v in pairs(file_list) do
            local file = io.open(v)
            for line in file:lines() do
                local component = string.match(line, [[find_component(.+)]])
                if(component) then
                    -- we don't care if there is a duplicated component path, so by excluding anything with a : we remove 90% of the component paths.
                    -- May have to re-evaluate in future, but in an ideal world everything will eventually be scriptTagged so that should also solve any potential issues.
                    local component_path = string.match(component, ':')
                    if(component and component_path == nil) then
                        for k, v in ipairs(component_list) do
                            if(component == v) then
                                Utilities.print("----- INFO: duplicated script tag found: "..component.." please change one of the duplications... FAILED! -----")
                                Lib.Helpers.Misc.wait(30)
                                Lib.Frontend.Misc.quit_to_windows()
                            end
                        end
                        table.insert(component_list, component)
                    end
                end
            end
        end
    end) 
end