function Lib.Battle.Clicks.start_battle(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Battle.start_battle(), "Start Battle (battle)", left_click)
    end)
end

function Lib.Battle.Clicks.survival_build_point_option_select(build_point, construct, left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Battle.survival_build_point_option_select(build_point, construct), "Build Construct: "..construct.." at point: "..build_point.." (battle)", left_click)
    end)
end

function Lib.Battle.Clicks.battle_results_continue(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Battle.battle_results_continue(), "Continue (battle results)", left_click)
    end)
end

function Lib.Battle.Clicks.start_deployment(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Battle.start_deployment(), "Start Deployment (winds of magic panel)", left_click)
    end)
end

function Lib.Battle.Clicks.button_dismiss_results(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Battle.button_dismiss_results(), "End Battle (in-battle results panel)", left_click)
    end)
end

function Lib.Battle.Clicks.button_pause_battle(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Battle.battle_pause_battle(), "Pause Battle (in-battle battle hub)", left_click)
    end)
end

function Lib.Battle.Clicks.button_slowmo_battle(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Battle.battle_slowmo_battle(), "Slowmo Battle (in-battle battle hub)", left_click)
    end)
end

function Lib.Battle.Clicks.button_play_battle(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Battle.battle_play_battle(), "Play Battle (in-battle battle hub)", left_click)
    end)
end

function Lib.Battle.Clicks.button_forward_battle(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Battle.battle_forward_battle(), "Forward Battle (in-battle battle hub)", left_click)
    end)
end

function Lib.Battle.Clicks.button_fast_forward_battle(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Battle.battle_fast_forward_battle(), "Fast Forward Battle (in-battle battle hub)", left_click)
    end)
end

function Lib.Battle.Clicks.battle_help_panel_button_close(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Battle.battle_help_panel_close(), "Help Panel Battle Close Button (in-battle battle hub)", left_click)
    end)
end

function Lib.Battle.Clicks.card_holder_card(card_id ,left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Battle.cards_holder_card(card_id), "Card ID = "..tostring(card_id), left_click)
    end)
end