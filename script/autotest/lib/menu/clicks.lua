function Lib.Menu.Clicks.quit_to_frontend(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Menu.quit_to_frontend(), "Quit to frontend (menu)", left_click)
    end)
end

function Lib.Menu.Clicks.popup_confirm(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Menu.popup_confirm(), "Confirm (popup)", left_click)
    end)
end

function Lib.Menu.Clicks.open_save(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Menu.open_save(), "Save (menu)", left_click)
    end)
end

function Lib.Menu.Clicks.open_load(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Menu.open_load(), "Load (menu)", left_click)
    end)
end

function Lib.Menu.Clicks.confirm_load(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Menu.confirm_load(), "Load (load panel)", left_click)
    end)
end

function Lib.Menu.Clicks.confirm_save(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Menu.confirm_save(), "Save (save panel)", left_click)
    end)
end

function Lib.Menu.Clicks.resume_game(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Menu.resume_game(), "Resume (menu)", left_click)
    end)
end

function Lib.Menu.Clicks.concede_battle(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Menu.concede_battle(), "Concede Defeat (menu)", left_click)
    end)
end

function Lib.Menu.Clicks.results_end_battle(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Menu.results_end_battle(), "End Battle (battle results)", left_click)
    end)
end

function Lib.Menu.Clicks.results_continue(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Menu.results_continue(), "Continue (battle results)", left_click)
    end)
end
