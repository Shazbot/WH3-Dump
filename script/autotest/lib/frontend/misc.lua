function Lib.Frontend.Misc.verify()
    callback(function() Common_Actions.ensure_component_exists(Lib.Components.Frontend.background_video()) end)
end

function Lib.Frontend.Misc.exit_game()
    -- not gotten this far yet to make this work in wh3
    callback(function() 
        Common_Actions.trigger_shortcut("ESCAPE")
        Common_Actions.trigger_shortcut("ESCAPE")
        Common_Actions.trigger_shortcut("ESCAPE")
        Common_Actions.trigger_shortcut("ESCAPE")
        Lib.Frontend.Misc.quit_to_windows()
    end)
end

function Lib.Frontend.Misc.quit_to_windows()
    callback(function() 
        local frontend = Lib.Components.Frontend.campaign_tab()
        local popup = Lib.Components.Frontend.close_popup()
        if(frontend ~= nil and frontend:Visible(true) == true) then
            Common_Actions.print("GSAT_SCRIPT_FINISHED_")
            Lib.Helpers.Test_Cases.set_test_case("GSAT Finished Successfully", "end", false)
            Lib.Helpers.Test_Cases.delete_checkpoint_file()
            if(popup ~= nil and popup:Visible(true) == true) then
                Lib.Frontend.Clicks.close_popup()
            end
            Lib.Frontend.Clicks.quit_to_windows()
            Lib.Frontend.Clicks.quit_confirmation()
        else
            Lib.Frontend.Misc.quit_to_windows()
        end
    end)
end

function Lib.Frontend.Misc.quit_to_windows_assert_load_test_version()
    --uses less GSAT backend functionality for clicking, to avoid triggering asserts, only used by gsat_assert_load_test
    --calls :SimulateLClick() directly on components to bypass all the extra GSAT things that can fire asserts
    callback(function() 
        local frontend = Lib.Components.Frontend.campaign_tab()
        local popup = Lib.Components.Frontend.close_popup()
        if(frontend ~= nil and frontend:Visible(true) == true) then
            Utilities.print("Exiting game without using GSAT backend, to avoid asserts!")
            Common_Actions.print("GSAT_SCRIPT_FINISHED_")
            if(popup ~= nil and popup:Visible(true) == true) then
                popup:SimulateLClick()
            end
            Lib.Components.Frontend.quit_to_windows():SimulateLClick()
            Lib.Components.Frontend.quit_confirmation():SimulateLClick()
        else
            Lib.Components.Frontend.quit_confirmation():SimulateLClick()
        end
    end)
end

local function check_for_and_handle_first_time_screen()
    callback(function() 
        if(Functions.check_component_visible(Lib.Components.Frontend.first_time_user_parent(), false, true)) then
            Utilities.print("Handling First Time User screen.")
            if(Functions.check_component_visible(Lib.Components.Frontend.first_time_user_main_menu_button())) then
                Lib.Frontend.Clicks.first_time_user_main_menu_button()
            elseif(Functions.check_component_visible(Lib.Components.Frontend.first_time_user_accessibility_button())) then
                Lib.Frontend.Clicks.first_time_user_accessibility_button()
            end
            check_for_and_handle_first_time_screen()
        end
    end)
end

function Lib.Frontend.Misc.ensure_frontend_loaded()
    check_for_and_handle_first_time_screen()
    callback(function()
        local campaign_tab = Lib.Components.Frontend.campaign_tab()
        if (Functions.check_component_visible(campaign_tab)) then
            Lib.Frontend.Misc.clear_dlc_popups()
		else
            Lib.Frontend.Misc.ensure_frontend_loaded()
        end
    end, wait.short)
end

function Lib.Frontend.Misc.ensure_quest_battle_menu_loaded()
	callback(function()
		local quest_battle_list = Lib.Components.Frontend.quest_battle_list()
		if (quest_battle_list ~= nil) then
			Utilities.print("Quest battle has ended and menu has loaded")
		else
			Utilities.print("REPEATING ensure_quest_battle_menu_loaded")
			Lib.Frontend.Misc.ensure_quest_battle_menu_loaded()
		end
	end)
end

function Lib.Frontend.Misc.clear_dlc_popups()
    callback(function() 
        local dlc_close_button = Lib.Components.Frontend.dlc_popup_button_close()
        local dlc_acquired_close_button = Lib.Components.Frontend.close_popup()
        if (Functions.check_component_visible(dlc_close_button)) then
            --the dlc popup is detected, close it and call the function again in case there are multiple popups
            Lib.Frontend.Clicks.close_dlc_popup()
            Lib.Frontend.Misc.clear_dlc_popups()
        elseif (Functions.check_component_visible(dlc_acquired_close_button)) then
            Lib.Frontend.Clicks.close_popup()
            Lib.Frontend.Misc.clear_dlc_popups()
        end
    end, wait.short)
end

function Lib.Frontend.Misc.return_to_frontend()
    callback(function()
        local quit_button = Lib.Components.Frontend.quit_to_windows()
        if(quit_button == nil or quit_button:Visible(true) == false) then
            Lib.Frontend.Clicks.return_to_main_menu()
            Lib.Frontend.Misc.return_to_frontend()
        end
    end)
end

function Lib.Frontend.Misc.find_replay_in_list_from_name(desired_replay_name)
    Utilities.print("Finding replay in list from name: "..tostring(desired_replay_name))
    local _, replay_list = Common_Actions.get_visible_child_count(Lib.Components.Frontend.replays_parent())
    for index, replay_component in ipairs(replay_list) do
        local replay_id = replay_component:Id()
        local replay_name_component = Lib.Components.Frontend.replay_name(replay_id)
        local replay_name = replay_name_component:GetStateText()
        if (replay_name == desired_replay_name) then
            Utilities.print("REPLAY FOUND! Index: "..tostring(index))
            return index
        end
    end
end

function Lib.Frontend.Misc.select_replay(replay)
    callback(function()
        if (type(replay) == "string") then
            replay = Lib.Frontend.Misc.find_replay_in_list_from_name(replay)
        end
        local _, replay_list = Common_Actions.get_visible_child_count(Lib.Components.Frontend.replays_parent())
        local replay_choice = replay or math.random(1, #replay_list)
        local replay_id = replay_list[replay_choice]:Id()
        local replay_name_component = Lib.Components.Frontend.replay_name(replay_id)
        g_replay_name = replay_name_component:GetStateText()
        Common_Actions.click_component(Lib.Components.Frontend.replay(replay_id), "Replay select: "..replay_id.." (replay choice: "..tostring(g_replay_name)..")")
    end)
end

function Lib.Frontend.Misc.replays_load_sweep(target_folder)
    callback(function()
        -- these 3 clicks are needed to ensure the replays button is active after copying the replays to appdata (it's disabled by default as the game starts without any replays in appdata)
        Lib.Frontend.Clicks.battles_tab()
        Lib.Frontend.Clicks.custom_battle()
        Lib.Frontend.Clicks.return_to_main_menu()
        local replays = Functions.get_file_names_in_directory(target_folder)
        for _,replay in ipairs(replays) do
            local replay_name = string.match(replay, "(.*)%.")
            Lib.Frontend.Loaders.load_replay(replay_name)
            Lib.Helpers.Timers.write_battle_timers_to_file("Replay Battle Load Time")
            Lib.Battle.Misc.concede_battle_after_duration(30)
            Lib.Helpers.Timers.write_battle_timers_to_file("End of Battle to Frontend Time")
            Lib.Helpers.Misc.wait(5)
        end
    end)
end