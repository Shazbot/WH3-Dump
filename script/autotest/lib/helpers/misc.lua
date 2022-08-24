local m_log_file_id = os.date("%d%m%y%H%M%S")
local m_log_location
local m_log_line_number
local m_log_details
local m_details_log_created = false

function Lib.Helpers.Misc.get_log_file_id()
    return m_log_file_id
end

function Lib.Helpers.Misc.create_details_log_file()
    callback(function()
        if(m_details_log_created == false) then
            m_details_log_created = true
            m_log_location  = [[\\casan02\tw\Automation\Results\test]]
            local build_no = common.game_version()
            build_no = string.match(build_no, 'Build (%d+)')

            m_log_details = m_log_file_id..",WH3,Dev,"..build_no..","..os.date("%d/%m/%y")
            m_log_line_number = 1

            os.execute("mkdir \""..m_log_location.."\"")

           Functions.write_to_document("ID,Project,Branch,Build,Date,UI Game Area,UI Panel,UI Result,Turn Number,Turn Complete,Turn Timer,Campaign Type,Campaign Faction,Campaign Load Result,Battle Type,Battle Map,Battle Loaded", m_log_location, m_log_file_id, ".csv", true, true)
        end
    end)
end

function Lib.Helpers.Misc.start_log_results(ui_game_area, ui_panel, ui_result, turn_number, turn_complete, turn_timer, campaign_type, campaign_faction, campaign_load_result, battle_type, battle_map, battle_loaded)
    Lib.Helpers.Misc.create_details_log_file()
    callback(function()
        m_log_line_number = m_log_line_number + 1
       Functions.write_to_document(
                tostring(m_log_details)..","..
                tostring(ui_game_area)..","..
                tostring(ui_panel)..","..
                tostring(ui_result)..","..
                tostring(turn_number)..","..
                tostring(turn_complete)..","..
                tostring(turn_timer)..","..
                tostring(campaign_type)..","..
                tostring(campaign_faction)..","..
                tostring(campaign_load_result)..","..
                tostring(battle_type)..","..
                tostring(battle_map)..","..
                tostring(battle_loaded), m_log_location, m_log_file_id, ".csv", false, true
            )
    end)
end

function Lib.Helpers.Misc.record_log_results(ui_game_area, ui_panel, ui_result, turn_number, turn_complete, turn_timer, campaign_type, campaign_faction, campaign_load_result, battle_type, battle_map, battle_loaded)
    callback(function()
       Functions.remove_lines_from_file(m_log_location, m_log_file_id, ".csv", m_log_line_number, 1)
       Functions.write_to_document(
                tostring(m_log_details)..","..
                tostring(ui_game_area)..","..
                tostring(ui_panel)..","..
                tostring(ui_result)..","..
                tostring(turn_number)..","..
                tostring(turn_complete)..","..
                tostring(turn_timer)..","..
                tostring(campaign_type)..","..
                tostring(campaign_faction)..","..
                tostring(campaign_load_result)..","..
                tostring(battle_type)..","..
                tostring(battle_map)..","..
                tostring(battle_loaded), m_log_location, m_log_file_id, ".csv", false, true
            )
    end)
end

function Lib.Helpers.Misc.escape()
    callback(function()
        Common_Actions.trigger_shortcut("ESCAPE")
    end)
end

function Lib.Helpers.Misc.override_defender_budget_ratio(ratio)
    callback(function()
        if(ratio ~= nil) then
            FrontEnd.override_defender_budget_ratio(ratio)
        end
    end)
end

function Lib.Helpers.Misc.wait(seconds, suppress_printout)
    local wait = seconds * 1000
    callback(function()
        if not suppress_printout then
            Utilities.print("Waiting for "..wait.." ms")
        end
	end, wait)
end

function Lib.Helpers.Misc.skip_movie_if_playing()
	if common.is_any_movie_playing() then
		Utilities.print("Skipping movie")
		common.trigger_shortcut("ESCAPE")
	end;
end;

function Lib.Helpers.Misc.force_quit_game()
    Common_Actions.trigger_console_command("quit")
end

function Lib.Helpers.Misc.create_screenshot_url()
    local appdata = os.getenv("APPDATA")
    local file_location = appdata.."\\CA_Autotest\\WH3\\gsat_logs\\screenshots\\frontend"
    Utilities.print("LOGS! "..file_location)
end

function Lib.Helpers.Misc.confirm_popup()
    callback(function()
        local choice_popup = Lib.Components.Helpers.popup_tick()
        if(choice_popup ~= nil and choice_popup:Visible() == true) then
            Lib.Helpers.Clicks.popup_tick()
        end
    end)
end

local function wait_for_benchmark_summary(benchmark)
    callback(function()
        if benchmark ~= nil then
            if string.find(benchmark, "campaign") then
                wait_for_event("PanelOpenedCampaign")
            else
                wait_for_event("PanelOpenedBattle")
            end
        else
            local benchmark_results = Lib.Components.Helpers.exit_benchmark()
            if not (benchmark_results ~= nil and benchmark_results:Visible(true) == true) then
                Lib.Helpers.Misc.wait(5)
                wait_for_benchmark_summary(benchmark)
            end
        end
    end)
end

function Lib.Helpers.Misc.exit_benchmark_when_finished(benchmark, log_vram)
    log_vram = log_vram or false
    callback(function()
        wait_for_benchmark_summary(benchmark)
        callback(function()
            local frontend_component = Lib.Components.Frontend.campaign_tab()
            if(frontend_component~= nil and frontend_component:Visible(true) == true) then
                Utilities.print("---- INFO: Frontend detected without benchmark results ----")
                Lib.Helpers.Misc.wait(3)
            else
                --if log_vram is enabled, log the vram!
                if(log_vram)then
                    Lib.Compat.Misc.log_vram()
                end
                Lib.Helpers.Misc.wait(3)
                Lib.Helpers.Clicks.exit_benchmark()
                Lib.Helpers.Misc.wait(5)
                Lib.Frontend.Clicks.cancel_benchmark_button()
            end
        end)
    end)
end

function Lib.Helpers.Misc.quit_script()
	callback(function()
		Common_Actions.print("----- INFO: Script blocker reached, quitting game ------")
		Common_Actions.trigger_console_command("quit")
	end)
end

--##### Autotest Pausing functions #####

local function autotest_pause_loop(button, state)
    callback(function()
        local button_x, buttton_y = button:Position()
        local dim_x, dim_y = ATGlobals.ui_root:Dimensions()
        if(button_x ~= dim_x or button_y~= dim_y)then --if the x or y position of the button has moved from the centre of the screen (can happen if you open and close panels)
            --reposition button to be in center of screen
            button:MoveTo(dim_x/2, dim_y/2)
        end 

        local new_state = button:CurrentState()
        if(state~=new_state)then --slightly unncessary but this logs when the button changes state, was useful for debugging when making the function so might be useful later
            Utilities.print("Autotest button state change! State: "..tostring(new_state))
        end
        if(new_state == "down")then --if the button has been clicked it will be in the down state
            Utilities.print("Autotest resumed. Destroying button and restoring listeners.")
            button:Destroy() --remove the button
            resume_all_listeners() --resume the listeners
        else
            autotest_pause_loop(button, new_state)
        end
    end)
end

--Debug function for scripters only. Do not use in actual scripts!
--Call this function to pseduo-pause the autotest script
--Will loop in a callback so that no other callbacks can execute until you resume, also suspends all listeners
--Use this function while making scripts to pause the script and investigate/modify the game state
--When called it creates a button in the middle of the screen, click that button to resume the script
function Lib.Helpers.Misc.pause_autotest()
    callback(function()
        --get the root component
        local root = ATGlobals.ui_root
        local dim_x, dim_y = root:Dimensions()

        local autotest_button = UIComponent(root:CreateComponent("AutotestButton", "ui\\templates\\round_medium_button.twui.xml"))--create the autotest button as a child of the root
        Utilities.print("Autotest paused. Button Created: "..tostring(autotest_button).." Click the button to resume the script.")
        autotest_button:MoveTo(dim_x/2, dim_y/2)--set the position of the button to be directly in the middle of the screen
        autotest_button:RegisterTopMost()--ensure that the button appears over every other UI element so it can always be clicked
        suspend_all_listeners() 
        --the autotest cant easily be paused so we just loop a callback to stop anything else running, however listeners can still fire and register new callbacks
        --this means that once the autotest resumes a bunch of bogus callbacks may have been registered by listeners
        --to fix this we temporarily remove all the listeners and make the list empty
        autotest_pause_loop(autotest_button)
    end)
end

-- the result .csv file will be renamed to oldName_PCName.csv and copied to the specified location
-- the benchmark result will be deleted after the copy/rename
function Lib.Helpers.Misc.copy_benchmark_result_and_rename(location)
    callback(function()
        local appdata = os.getenv("APPDATA")
        local pc_name = os.getenv("COMPUTERNAME")
        local benchmark_results_path = appdata..[[\The Creative Assembly\Warhammer3\benchmarks]]
        local benchmark_results = Functions.get_file_names_in_directory(benchmark_results_path)
        for i = 1, #benchmark_results do
            local file_ext = benchmark_results[i]:match("[^.]+$")
            local file_name = benchmark_results[i]:match("(.+)%..+")
            local file = benchmark_results_path..[[\]]..benchmark_results[i]
            if file_ext =="csv" then
                os.execute("xcopy "..string.format("%q", file).." "..location.."\\"..file_name.."_"..pc_name..".csv* /Y")
                Lib.Helpers.Misc.wait(2)
            end
            os.execute([[del /F /Q ]]..[["]]..file..[["]])
        end
    end)
end

--loads the specified faction (lord) performs some tests, ends turn 3 times and quits
function Lib.Helpers.Misc.perform_load_test_on_faction(lord_name, variables)
    callback(function()
        Utilities.print("Faction load test on lord: "..tostring(lord_name))
        Lib.Frontend.Loaders.load_chaos_campaign(lord_name, variables.campaign_type, variables.database_checking)
        Utilities.set_faction_load_test_lord(lord_name)

        Utilities.status_print("Starting Faction Load Test")
        Lib.Campaign.Misc.ensure_cutscene_ended()
        Lib.Campaign.Actions.starting_army_checks()
        Lib.Campaign.Actions.starting_building_checks()
        Lib.Campaign.Actions.starting_income_checks()
        Lib.Campaign.Actions.starting_player_factions_technology_tree_checks()
        Lib.Campaign.Actions.starting_recruit_unit_checks()
        Lib.Campaign.Actions.starting_declare_war_checks()

        if(variables.fight_starting_battle) then
        	Lib.Campaign.Actions.attack_nearest_target()
        end

        Lib.Helpers.Loops.end_turn_loop(3)

        if(variables.save_load_check) then
        	Lib.Menu.Misc.save_campaign()
        	Lib.Menu.Misc.load_campaign()
        end

        Lib.Menu.Misc.quit_to_frontend()
        Lib.Frontend.Misc.ensure_frontend_loaded()
    end)
end

-- checks if the game is running using a retail or non-retail exe
-- sets up a global variable that can be used later to exclude stuff if running in retail
function Lib.Helpers.Misc.check_if_retail()
    callback(function()
        local check = core:is_debug_config()
        if check then
            g_retail_test = false
        else
            g_retail_test = true
        end
    end)
end