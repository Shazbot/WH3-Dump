function Lib.Menu.Misc.open_menu_without_fail()
    callback(function()
        local menu_component = Lib.Components.Menu.resume_game()
        if(menu_component == nil) then
            -- Potential infinite loop here, add some sort of max loop counter?
            Utilities.print("----INFO: Menu wasn't detected-----")
            Common_Actions.trigger_shortcut("ESCAPE")
            Lib.Menu.Misc.open_menu_without_fail()
        else
            Utilities.print("----INFO: Menu detected, waiting 10s to ensure it isn't slow to close -----")
            Lib.Helpers.Misc.wait(10)
            callback(function()
                -- menu detected, double checking its not just closing slowly.
                local menu_component = Lib.Components.Menu.resume_game()
                if(menu_component == nil) then
                    Utilities.print("----INFO: Menu no longer detected -----")
                    Lib.Menu.Misc.open_menu_without_fail()
                end
            end)
        end
    end, wait.long)
end

function Lib.Menu.Misc.close_menu_without_fail()
    callback(function()
        local menu_component = Lib.Components.Menu.resume_game()
        if(menu_component ~= nil) then
            -- Potential infinite loop here, add some sort of max loop counter?
            Lib.Menu.Clicks.resume_game()
            Lib.Menu.Misc.close_menu_without_fail()
        end
    end, wait.long)
end

function Lib.Menu.Misc.quit_to_frontend()
    callback(function()
        Lib.Helpers.Test_Cases.update_checkpoint_file("Quitting to front end")
        Lib.Menu.Misc.open_menu_without_fail()
        Lib.Menu.Clicks.quit_to_frontend()
        Lib.Menu.Clicks.popup_confirm()
        Lib.Helpers.Timers.start_timer()
    end, wait.standard)
end

function Lib.Menu.Misc.concede_battle_return_to_frontend()
    callback(function()
		Lib.Menu.Misc.open_menu_without_fail()
		Lib.Menu.Clicks.concede_battle()
		Lib.Menu.Clicks.popup_confirm()
		Lib.Menu.Misc.handle_results_screen()
    end, wait.long)
end

function Lib.Menu.Misc.handle_results_screen()
	callback(function()
		local battle_results = Lib.Components.Menu.results_continue()
		if(battle_results ~= nil and battle_results:Visible() == true) then
			Lib.Menu.Clicks.results_continue()
		else
			Lib.Menu.Misc.handle_results_screen()
		end
	end, wait.standard)
end

function Lib.Menu.Misc.exit_to_main()
    Lib.Menu.Misc.open_menu_without_fail()
    Lib.Menu.Misc.quit_to_frontend()
    Lib.Helpers.Misc.wait(10)
end

function Lib.Menu.Misc.ensure_menu_closed()
    callback(function()
        local resume_button = Lib.Components.Menu.resume_game()
        if(resume_button ~= nil and resume_button:Visible(true) == true) then
            Lib.Menu.Clicks.resume_game()
            Lib.Menu.Misc.ensure_menu_closed()
        end
    end, 50)
end

local function set_save_name(filename)
    callback(function()
        local filename_textbox = Lib.Components.Menu.save_filename_textbox()
        local current_text = filename_textbox:GetStateText()
        if(current_text ~= filename) then
            Utilities.print("Changing name to: "..filename)
            filename_textbox:SetStateText(filename)
            Lib.Helpers.Misc.wait(1)
            set_save_name(filename)
        end
    end, wait.standard)
end

local function confirm_save()
    callback(function()
        local save_button = Lib.Components.Menu.confirm_save()
        if(save_button ~= nil and save_button:Visible(true) == true) then
            Lib.Menu.Clicks.confirm_save()
            Lib.Helpers.Misc.wait(1)
            confirm_save()
        end
    end, wait.standard)
end

function Lib.Menu.Misc.save_campaign(addtional_save_name)
    callback(function()
        addtional_save_name = addtional_save_name or ""
        local filename = os.date("autotest_%d%m%y%H%M%S")
        -- keeps a global log of the latest save name for use elsewhere
        g_pre_battle_save = filename
        Lib.Menu.Misc.open_menu_without_fail()
        Lib.Menu.Clicks.open_save()
        set_save_name(addtional_save_name..filename)
        confirm_save()
        Lib.Menu.Misc.close_menu_without_fail()
    end)
end

function Lib.Menu.Misc.load_campaign()
    callback(function()
        Lib.Menu.Misc.open_menu_without_fail()
        Lib.Menu.Clicks.open_load()
        Lib.Helpers.Misc.wait(3)
        callback(function()
            Utilities.print(tostring(Lib.Components.Menu.confirm_load()))
            Utilities.print(tostring(Lib.Components.Menu.confirm_load():Visible()))
            Utilities.print(tostring(Lib.Components.Menu.confirm_load():CurrentState()))
        end)
        Lib.Menu.Clicks.confirm_load()
        Lib.Helpers.Clicks.popup_both_tick()
    end)
end