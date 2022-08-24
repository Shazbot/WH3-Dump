local m_players_turn
local m_end_turn_verification_save_location = [[\\casan02\tw\Automation\Results\End_Turn_Logs]]
local m_end_turn_results = {}
local m_verification_save_file_name
local m_active_siege = false

-- Member variables for Income tests
local m_resource_bar_income_amount
local m_treasury_panel_income_amount
local m_faction_stats_income_amount

-- Member variables for Technology tests
local m_starting_tech_nodes = {}

-- Member variables for Building tests
local m_primary_build_level_requirement
local m_building_key_for_tech
local m_chosen_building
local m_building_turns_for_completion

--## EVENT TEST FUNCTION ##--
-- setting this to true will log every event in the game, useful if you are trying to find a tricky event
-- you can enable or disable spammy events by editing the g_forbidden_events table in lib\frontend\tables.lua
local m_event_test_enabled = false

-- you might need to modify the event_file_path in the event_test() function
local function event_test()
    if(m_event_test_enabled)then
        local event_file_path = "T:\\branches\\warhammer3\\dev\\warhammer\\working_data\\script\\events.lua"
        Utilities.print("EVENT TEST!")
        for line in io.lines(event_file_path) do
            Utilities.print("Event line: "..tostring(line))
            local equals_location = string.find(tostring(line), "=")
            if(equals_location ~= nil)then
                local sub_string = string.sub(line, 1, equals_location-2)
                if(not g_forbidden_events[sub_string])then
                    Utilities.print("Creating Listener for: |"..tostring(sub_string).."|")
                    add_event_listener(
                        sub_string,
                        true,
                        function(context)
                            callback(function()
                                Utilities.print("Event Triggered "..sub_string)
                            end)
                        end,
                        true, true, sub_string
                    )
                end
            end
        end
    else
        Utilities.print("Fancy event tests are disabled.")
    end 
end
--#########################--

function Lib.Campaign.Misc.create_end_turn_verification_file()
    m_verification_save_file_name = Lib.Helpers.Misc.get_log_file_id()

    Lib.Helpers.Misc.create_details_log_file()
    
    callback(function()
        os.execute("mkdir \""..m_end_turn_verification_save_location.."\"")
       Functions.write_to_document("ID,Turn,Turn Complete,Turn Timer", m_end_turn_verification_save_location, m_verification_save_file_name, ".csv", true, true)
    end)
end

function Lib.Campaign.Misc.log_end_turn_verification_start(turn)
    callback(function()
       Functions.write_to_document(m_verification_save_file_name..","..turn..",2", m_end_turn_verification_save_location, m_verification_save_file_name, ".csv", false, true)
    end)
end

function Lib.Campaign.Misc.log_end_turn_verification_result(turn)
    callback(function()
           Functions.remove_lines_from_file(m_end_turn_verification_save_location, m_verification_save_file_name, ".csv", turn, 1)
           Functions.write_to_document(m_verification_save_file_name..","..turn..",1", m_end_turn_verification_save_location, m_verification_save_file_name, ".csv", false, true)
	end)
end

function Lib.Campaign.Misc.ensure_campaign_loaded(faction)
    callback(function()
        wait_for_event("FirstTickAfterWorldCreated")
        event_test()
        callback(function()
            Lib.Campaign.Misc.activate_player_turn_event_watchers()
            Lib.Campaign.Misc.ensure_loading_screen_is_closed()
            Lib.Helpers.Timers.end_timer("Campaign Load Time")
            Lib.Campaign.Misc.ensure_cutscene_ended()
			g_campaign_load_verificaiton = true
            Utilities.print("--------- CAMPAIGN STARTED ----------")
            Lib.Helpers.Misc.wait(3)
            callback(function()
                local close_advice = Lib.Components.Campaign.close_advisor()
                if(close_advice ~= nil and close_advice:Visible() == true) then
                    Lib.Campaign.Clicks.close_advisor()
                end
            end)
        end)
        Lib.Campaign.Faction_Info.update_faction_info()
		Lib.Helpers.Test_Cases.set_test_case("Start Campaign", "end", false)
        Lib.Helpers.Test_Cases.update_checkpoint_file("campaign loaded")
    end)
end

--the loading screen continue button is a weird one
--essentially all scripts pause during the loading screen, then once the campaign has loaded, the loading screen is replaced with a full screen component with a button
--this is why we handle the continue button inside the "campaign" rather than the front end
function Lib.Campaign.Misc.ensure_loading_screen_is_closed()
    callback(function()
        local continue_button = Lib.Components.Campaign.loading_screen_continue_button()
		local ie_continue_button = Lib.Components.Campaign.ie_loading_screen_continue_button()
        local end_turn = Lib.Components.Campaign.end_turn()
        local auto_resolve = Lib.Components.Campaign.auto_resolve()
        if(continue_button ~= nil and continue_button:Visible(true) == true)then
            Lib.Campaign.Clicks.click_loading_screen_continue_button()
        elseif (ie_continue_button ~= nil and ie_continue_button:Visible(true) == true) then
			Lib.Campaign.Clicks.click_ie_loading_screen_continue_button()
		else
            --this pesky button doesn't appear when you load a save, so we check if the end turn button is visible and break out of the loop if it is
            --also need to check for the pre-battle panel in case we load into a quick save before battle
            if(end_turn ~= nil and end_turn:Visible(true) or auto_resolve ~= nil and auto_resolve:Visible(true))then 
                Utilities.print("Loaded!")
            else
                Lib.Campaign.Misc.ensure_loading_screen_is_closed()
            end
        end
    end)
end

function Lib.Campaign.Misc.ensure_cutscene_ended()
    callback(function()
		--Added a short wait here to allow game to properly transition from loading screen to campaign map.
		--Been noted that its possible for the cutscene to not actually be skipped if the game is in said transition state causing the rest of the script to become stuck
		Lib.Helpers.Misc.wait(5, true)
        --check if cinematic bars are present, if they are, skip the cutscenes
        local cinematic_bars = Lib.Components.Campaign.cinematic_bars()
        if(cinematic_bars ~= nil and cinematic_bars:Visible() == true)then
            Utilities.print("----INFO: Skipping cutscene ----")
            Timers_Callbacks.campaign_call(function() cm:skip_all_campaign_cutscenes() end) --seems to have stopped working...
            Lib.Helpers.Misc.wait(1)
            callback(function()
                if(cinematic_bars:Visible() == true)then
                    --a backup option to skip the cutscene as some don't get skipped by the above line but we dont want to randomly press esc after a cutscene that DOES get skipped by it
                    Common_Actions.trigger_shortcut("ESCAPE")
					Lib.Campaign.Misc.ensure_cutscene_ended()
                end
            end)
        else
            Utilities.print("No bars! "..tostring(cinematic_bars))
        end
    end)
end

local function ensure_turn_ended(count, quit_game)
    callback(function() 
        --check for the end turn button, if it's visible then we've failed to end turn so we try again, otherwise we just let the system carry on
        if(Functions.check_component_visible(Lib.Components.Campaign.end_turn(), false, true) == true)then
            Utilities.print("Attempted to end turn but didn't! Trying again. Current count is "..count)
            Lib.Campaign.Misc.end_turn_without_fail(count, quit_game)
        else
            Utilities.print("Ended turn successfully!")
			Lib.Helpers.Test_Cases.set_test_case("Campign Turn Ended", "end")
            if(g_force_victory)then
                Utilities.print("Resetting force victory count at end of turn.")
                g_force_victory_count = 0
            end
            Lib.Campaign.Misc.activate_mid_turn_event_watchers()
            local fast_end_turn_button = Lib.Components.Campaign.menu_bar_end_turn_fast_forward()
            if (fast_end_turn_button:CurrentState() == "active" and g_compat_sweep) then
                Lib.Campaign.Clicks.fast_forward_end_turn()
            end
        end
    end)
end

function Lib.Campaign.Misc.end_turn_without_fail(count, quit_game)
    callback(function()
        Lib.Menu.Misc.ensure_menu_closed()
        quit_game = quit_game or false
        count = count or 0
        if (count < 11) then
            callback(function()
                local end_turn = Lib.Components.Campaign.end_turn()
                local skip_notification = Lib.Components.Campaign.skip_notification()
                if(skip_notification ~= nil and skip_notification:CurrentState() == "active") then
                    Lib.Campaign.Clicks.skip_notification()
                    Lib.Helpers.Misc.wait(1)
                    Lib.Campaign.Misc.end_turn_without_fail(count)
                elseif(end_turn ~= nil and end_turn:CurrentState() == "inactive") then
                    Lib.Helpers.Misc.wait(5)
                    Common_Actions.trigger_shortcut("ESCAPE")
                    count = count + 1
                    Lib.Campaign.Misc.end_turn_without_fail(count, quit_game)
                elseif(end_turn ~= nil and end_turn:CurrentState() == "active") then
                    Lib.Helpers.Test_Cases.set_test_case("Campign Turn Ended", "start")
                    Lib.Helpers.Test_Cases.update_checkpoint_file("Turn ended: "..tostring(g_turn_number))
					m_players_turn = false
                    Lib.Campaign.Clicks.end_turn()
                    Lib.Campaign.Misc.start_turn_time_recording()
                    count = count + 1
                    ensure_turn_ended(count, quit_game)
                else
                    Lib.Helpers.Misc.wait(5)
                    count = count + 1
                    Lib.Campaign.Misc.end_turn_without_fail(count, quit_game)
                end
            end)
        else
            if not quit_game then
                Utilities.print("Tried 10 times, can't end the turn. Now trying to force the ui unlock via campaign UI manager")
                Lib.Campaign.Misc.unlock_ui()
            else
                Lib.Campaign.Misc.unlock_ui(20, true)
            end
        end
    end)
end

function Lib.Campaign.Misc.unlock_ui(count, quit_game)
    callback(function()
        quit_game = quit_game or false
        count = count or 0
        if not quit_game then
            if (count < 21) then
                local uim = campaign_ui_manager:new()
                uim:unlock_ui()
                count = count + 1
                Lib.Helpers.Misc.wait(1, true)
                Utilities.print("Number of times ui_unlock() command has been used is: "..count)
                Lib.Campaign.Misc.unlock_ui(count)
            else
                Utilities.print("Trying one more time to click end turn. If it fails, the game will quit!")
                Lib.Campaign.Misc.end_turn_without_fail(10, true)
            end
        else
            Utilities.print("Failed! I GIVE UP!")
            g_exit_early = true
            Lib.Menu.Misc.quit_to_frontend()
            Lib.Frontend.Misc.quit_to_windows()
        end
    end)
end

function Lib.Campaign.Misc.new_turn_started()
    callback(function()
        Lib.Campaign.Misc.activate_player_turn_event_watchers()
        g_mid_turn_callback_level = nil
        Utilities.print("----------------------------------------------------------")
		Utilities.print("----INFO: New Turn Started ----")
        Lib.Campaign.Misc.record_turn_times()
        Lib.Campaign.Actions.reset_battle_fought()
    end)
    Lib.Campaign.Faction_Info.update_faction_info()
    Lib.Helpers.Misc.wait(3)
    if g_compat_sweep and m_active_siege then
        Lib.Campaign.Actions.deal_with_siege()
    end
end

function Lib.Campaign.Misc.activate_mid_turn_event_watchers()
    callback(function()
        remove_all_listeners()
        Lib.Campaign.Misc.listen_for_diplomacy()
        Lib.Campaign.Misc.listen_for_player_turn()
        Lib.Campaign.Misc.listen_for_unhandled_panels()
        Lib.Campaign.Actions.listen_for_pre_battle() --create the pre battle listener if its not created already
        if g_manual_battles then
            Lib.Campaign.Actions.set_battle_settings(true)
        else
            Lib.Campaign.Actions.set_battle_settings(false)
        end
        Lib.Campaign.Misc.listen_for_post_battle_results()
        Lib.Campaign.Misc.listen_for_enemy_vassal_popup()
        Lib.Campaign.Misc.listen_for_ally_attacked()
        Lib.Campaign.Misc.listen_for_events_popups()
        Lib.Campaign.Misc.listen_for_end_turn_pause()
        Lib.Campaign.Misc.listen_for_campaign_end()
	end)
end

function Lib.Campaign.Misc.activate_player_turn_event_watchers()
    callback(function()
        remove_all_listeners()
        Lib.Campaign.Misc.listen_for_player_settlement_siege()
        Lib.Campaign.Misc.listen_for_unhandled_panels()
        Lib.Campaign.Misc.listen_for_events_popups()
        Lib.Campaign.Misc.listen_for_campaign_end()
	end)
end

function Lib.Campaign.Misc.wait_for_player_turn_start()
    callback(function()
        -- activate a set of watchers for mid turn panels and the new turn
        --Lib.Campaign.Misc.activate_mid_turn_event_watchers()

        -- wait until it's the players turn again
        callback(function()
            Lib.Campaign.Misc.loop_till_players_turn()
        end)

        Lib.Campaign.Misc.new_turn_started()
    end)
end

function Lib.Campaign.Misc.listen_for_player_turn()
    add_event_listener(
        "FactionTurnStart",
        function(context)
            return context:faction():is_human()
        end,
        function()
            m_players_turn = true
        end,
        true, true, "ListenForPlayerTurnStart"
    )
end

function Lib.Campaign.Misc.loop_till_players_turn()
    -- loops at a set callback level so that any new callbacks that get called are done at a higher level to this loop, meaning they will execute and then return to this loop
	g_mid_turn_callback_level = g_mid_turn_callback_level or g_current_callback_level + 1
    callback(function()
        if(m_players_turn ~= true) then
            Lib.Campaign.Misc.loop_till_players_turn()
        end
    end, 300, 0, g_mid_turn_callback_level)
end

function Lib.Campaign.Misc.listen_for_unhandled_panels()
    -- print the name of any unhandled panels.
    add_event_listener(
        "PanelOpenedCampaign",
        true,
        function(context)
            panel = context.string
            callback(function()
                Utilities.print("panel opened: "..panel)
            end)
        end,
        true, true, "ListenForUnhandledPanels"
    )
end

--This listener is "core" so it is never removed, this is to stop situations where diplomacy panel opens up before the listener gets created
--however this causes a problem when the player faction opens diplomacy on their turn
--to solve this, there is the addition of the "and not players turn" part, therefore this listener will only evaluate to true when the panel opens and it is not the players turn
function Lib.Campaign.Misc.listen_for_diplomacy()
    add_event_listener(
        "PanelOpenedCampaign",
        function(context)
            panel = context.string
            if(panel == "diplomacy_dropdown" and not Lib.Campaign.Faction_Info.is_it_players_turn())then 
                return true
            end
        end,
        function(context)
            callback(function()
                Utilities.print("listen_for_diplomacy")
                Lib.Campaign.Misc.listen_for_diplomacy_close()
                g_diplomacy_closed = false
                Lib.Helpers.Misc.wait(2)
                Lib.Campaign.Misc.handle_diplomacy_panel()
            end)
        end,
        true, true, "ListenForDiplomacy"
    )
end

function Lib.Campaign.Misc.listen_for_diplomacy_close()
    add_event_listener(
        "PanelClosedCampaign",
        function(context)
            panel = context.string
            if(panel == "diplomacy_dropdown") then
                return true
            end
        end,
        function(context)
            callback(function()
                g_diplomacy_closed = true
            end)
        end,
        true, false, "ListenForDiplomacyClose"
    )
end

function Lib.Campaign.Misc.handle_diplomacy_panel(diplomacy_choice)
    callback(function()
        local diplomacy_decline = Lib.Components.Campaign.diplomacy_button_decline()
        local war_declared = Lib.Components.Campaign.accept_declare_war()
        Utilities.print("diplomacy_choice: "..tostring(diplomacy_choice))
        if(war_declared ~= nil and war_declared:Visible(true) == true) then
            Lib.Campaign.Clicks.accept_declare_war()
        else
            if(diplomacy_decline ~= nil and diplomacy_decline:Visible(true) == true) then
                diplomacy_choice = diplomacy_choice or math.random(1,2)
            else
                diplomacy_choice = 1
            end
            if(diplomacy_choice == 1) then
                Lib.Campaign.Clicks.diplomacy_button_accept()
            else
                Lib.Campaign.Clicks.diplomacy_button_decline()
            end
            Lib.Helpers.Misc.wait(2)
            Lib.Campaign.Clicks.diplomacy_button_accept()
        end
    end)
    callback(function()
        if(g_diplomacy_closed == false) then
            Lib.Campaign.Misc.handle_diplomacy_panel()
        end
    end)
end

local function select_dilemma()
    Lib.Helpers.Misc.wait(1)
    callback(function()
        local dilemma_count, dilemma_list = Common_Actions.get_visible_child_count(Lib.Components.Campaign.dilemma_option_parent())
        local dilemma_choice = math.random(1, dilemma_count)
        local dilemma_id = dilemma_list[dilemma_choice]:Id()
        local dilemma_button = Lib.Components.Campaign.dilemma_option(dilemma_id)
        if(dilemma_button ~= nil and dilemma_button:CurrentState() == "active") then
            Lib.Campaign.Clicks.dilemma_option(dilemma_id)
        else
            -- selected button is inactive (possibly due to conditions not being met), find another
            select_dilemma()
        end
    end)
end

function Lib.Campaign.Misc.listen_for_enemy_vassal_popup()
    add_event_listener(
        "PanelOpenedCampaign",
        function(context)
            panel = context.string
            if(panel == "enemy_vassal_options") then
                return true
            end
        end,
        function(context)
            callback(function()
                Lib.Helpers.Misc.wait(2)
                Lib.Campaign.Misc.select_enemy_vassal_option()
            end)
        end,
        true, true, "ListenForEnemyVassalPopup"
    )
end

function Lib.Campaign.Misc.listen_for_ally_attacked()
    add_event_listener(
        "PanelOpenedCampaign",
        function(context)
            panel = context.string
            if(panel == "ally_attacked") then
                return true
            end
        end,
        function(context)
            callback(function()
                Lib.Helpers.Misc.wait(2)
                Lib.Campaign.Misc.select_ally_attacked_option()
            end)
        end,
        true, true, "ListenForAllyAttacked"
    )
end

function Lib.Campaign.Misc.listen_for_end_turn_pause()
    add_event_listener(
        "ComponentLClickUp",
        function(context)
            button = context.string
            if button == "button_pause" then
                return true
            end
        end,
        function(context)
            callback(function()
                Lib.Campaign.Misc.handle_end_turn_pause()
            end)
        end,
        true, true, "ListenForEndTurnPause"
    )
end

function Lib.Campaign.Misc.listen_for_lost_general()
    add_event_listener(
        "PanelOpenedCampaign",
        function(context)
            panel = context.string
            if(panel == "appoint_new_general") then
                return true
            end
            return false
        end,
        function(context)
            callback(function()
                Lib.Campaign.Misc.replace_lost_general()
            end)
        end,
        true
    )
end

function Lib.Campaign.Misc.listen_for_post_battle_results()
    add_event_listener(
        "PanelOpenedCampaign",
        function(context)
            panel = context.string
            if(panel == "popup_battle_results") then
                return true
            end
            return false
        end,
        function(context)
            callback(function()
				Lib.Helpers.Test_Cases.set_test_case("Fight Battle", "end", false)
                Lib.Helpers.Test_Cases.update_checkpoint_file("Battle fought on turn "..tostring(g_turn_number))
                Lib.Campaign.Actions.set_battle_fought()
                Lib.Helpers.Misc.wait(3)
                -- for the compat end turn times script, heal the main settlement garrison after each fight to ensure the faction survives
                if g_compat_sweep == true then
                    local player_main_settlement_interface = Lib.Campaign.Faction_Info.get_player_main_settlement_interface()
                    local settlement_cqi = player_main_settlement_interface:cqi()
                    cm:heal_garrison(settlement_cqi)
                end
                Lib.Campaign.Misc.handle_post_battle_panel()
            end)
        end,
        true, true, "ListenForPostBattleResults"
    )
end

function Lib.Campaign.Misc.listen_for_player_settlement_siege()
    add_event_listener(
        "CharacterBesiegesSettlement",
        function(context)
            return context:region():owning_faction():is_human()
        end,
        function(context)
            local besieging_char = context:region():garrison_residence():besieging_character()
            if besieging_char:is_null_interface() then
                Utilities.print("!!! CharacterBesiegesSettlement received, but besieging character is null?")
                return
            end
            Utilities.print("Someone is besieging one of your settlements! The character has cqi "..besieging_char:command_queue_index().." and is of faction "..besieging_char:faction():name())
            m_active_siege = true
        end,
        true, true, "ListenForPlayerSettlementSiege"
    )
end

function Lib.Campaign.Misc.listen_for_campaign_end()
    add_event_listener(
        "PanelOpenedCampaign",
        function(context)
            panel = context.string
            if(panel == "campaign_victory") then
                return true
            end
            return false
        end,
        function(context)
            callback(function()
                if(Functions.check_component_visible(Lib.Components.Campaign.game_over_panel_quit_button())) then
                    Utilities.print("---INFO: Campaign ended early! ---")
                    Lib.Campaign.Clicks.game_over_quit(true)
                    g_exit_early = true
                    Lib.Frontend.Misc.quit_to_windows()
                    remove_all_listeners()
                end
            end)
        end,
        true, true, "ListenForCampaignEnd"
    )
end

local function handle_event_popup()
    --this system is a bit more adaptable for new event types if they require specific behaviour, probably still not perfect though!
    callback(function() 
        Utilities.print("Event popup detected")
        
        if(g_screenshot_events)then
            Common_Actions.take_screenshot(os.date("Event_screenshot_%d%m%y_%H%M%S"))
        end
        
        local event_count, event_children = Common_Actions.get_visible_child_count(Lib.Components.Campaign.event_layout_parent())
        Utilities.print("EVent count: "..tostring(event_count))
        if(g_log_events)then --if event logging enabled
            Lib.Campaign.Misc.get_event_info_and_log_to_csv()
        end

        if(#event_children > 0 and event_children[1]:Id() == "dilemma_active")then
            Utilities.print("Handling Dilemma")
            select_dilemma()
        elseif(#event_children > 0 and event_children[1]:Id() == "dilemma_realm_of_chaos") then
            Utilities.print("Handling Realm of Chaos/Astral Plane dilemma")
            Lib.Campaign.Clicks.enter_ap_realm()
        elseif(#event_children > 0 and event_children[1]:Id() == "incident_large")then
            Lib.Campaign.Clicks.accept_large_incident()
        else
            if(#event_children > 0)then
                Utilities.print("Handling Regular event event id: "..tostring(event_children[1]:Id()))
                Lib.Campaign.Clicks.accept_event()
            else
                Utilities.print("WARNING: Handle event called but there are no events to handle.")
            end
            
        end
    end)
end

function Lib.Campaign.Misc.listen_for_events_popups()
    add_event_listener(
        "PanelOpenedCampaign",
        function(context)
            panel = context.string
            if(panel == "events") then
                return true
            end
            return false
        end,
        function(context)
            callback(function()
                handle_event_popup()
            end)
        end,
        true, true, "ListenForEvents"
    )
end

function Lib.Campaign.Misc.handle_post_battle_panel(loop_count)
    local loop_count = loop_count or 1
    callback(function()
        local but_dismiss = Lib.Components.Campaign.dismiss_battle_panel()
        local option_count, option_list = Common_Actions.get_visible_child_count(Lib.Components.Campaign.captives_option_parent())
        local accept_results = Lib.Components.Campaign.accept_battle_results()
        if(but_dismiss ~= nil and but_dismiss:Visible(true) == true) then
            Lib.Campaign.Clicks.dismiss_battle_panel()
        elseif(accept_results ~= nil and accept_results:Visible(true) == true) then
            Lib.Campaign.Clicks.accept_battle_results()
            Lib.Helpers.Misc.wait(3)
        elseif(option_count > 0) then
            local random_option = math.random(1, option_count)
            local option_choice = option_list[random_option]
            Common_Actions.click_component(option_choice, "Option Choice: "..option_choice:Id().." (captives panel)")
        else
            --rare edge case where the game ends after a battle, which means the results panel never appears so this function gets stuck in a loop
            --this check stops that by capping the loop to 5 (sometimes we need to loop as components can take a little while to appear)
            if(loop_count < 5)then
                Lib.Campaign.Misc.handle_post_battle_panel(loop_count+1)
            else
                Utilities.print("Cannot find post battle panel to close, either the campaign has ended or this is a bug.")
            end
        end
    end, wait.short)
end

function Lib.Campaign.Misc.select_ally_attacked_option()
    callback(function()
        local war_choice = math.random(1,3)
        if(war_choice == 1) then
            local button_def = Lib.Components.Campaign.enter_war_with_ally()
            if (button_def ~= nil and button_def:Visible(true) == true) then
                Lib.Campaign.Clicks.enter_war_with_ally()
            else
                Lib.Campaign.Misc.select_ally_attacked_option()
            end
        elseif (war_choice == 2) then
            Lib.Campaign.Clicks.decline_break_alliance()
        else
            local button_off = Lib.Components.Campaign.join_ally_in_war()
            if (button_off ~= nil and button_off:Visible(true) == true) then
                Lib.Campaign.Clicks.join_ally_in_war()
            else
                Lib.Campaign.Misc.select_ally_attacked_option()
            end
        end
    end)
end

function Lib.Campaign.Misc.select_enemy_vassal_option()
    callback(function()
        local vassal_option = math.random(1,2)
        if(vassal_option == 1) then
            Lib.Campaign.Clicks.declare_war_on_master()
        else
            Lib.Campaign.Clicks.peace_with_vassal()
        end
    end)
end

function Lib.Campaign.Misc.get_current_turn_number_display()
    local turn_number = Lib.Components.Campaign.turn_number()
    return turn_number:GetStateText()
end

function Lib.Campaign.Misc.get_current_turn_number()
    local turn_no
    Timers_Callbacks.campaign_call(function()
        turn_no = common.get_context_value("CcoCampaignRoot", "", "TurnNumber")
    end)
    return turn_no
end

function Lib.Campaign.Misc.create_turn_timer_file()
    g_turn_timer_name = os.date("turn_timers_%d%m%y_%H%M")
    if g_compat_sweep then
        g_turn_timer_location = "c:\\compat_sweep"
        -- these 2 rows are needed for the hardware info function that outputs the data as columns in csv
        Functions.write_to_document("Turn Number,Turn Time (ms)", g_turn_timer_location, g_turn_timer_name, ".csv", false)
        Functions.write_to_document("1, ", g_turn_timer_location, g_turn_timer_name, ".csv", false)
    else
        local appdata = os.getenv("APPDATA")
        g_turn_timer_location = appdata.."\\CA_Autotest\\WH3\\turn_timers"
        os.execute("mkdir \""..g_turn_timer_location.."\"")
    end
    Utilities.print("LOGS! "..g_turn_timer_location)
end

function Lib.Campaign.Misc.start_turn_time_recording()
    callback(function()
        g_turn_timer_start_time = os.clock()
    end)
end

function Lib.Campaign.Misc.record_turn_times()
    local turn_timer_printout
    callback(function()
        local turn_timer = Functions.get_time_difference(g_turn_timer_start_time)
        local turn_count = Lib.Campaign.Misc.get_current_turn_number()
        Utilities.print(tostring("----- INFO: TURN TIME: "..turn_timer.." -----"))
        if g_compat_sweep then
            -- remove the 'Turn' string for the compat end turn times, this makes it easier to average the turn total in powerBI
            turn_timer_printout = tostring(turn_count)..","..tostring(turn_timer)
        else
            turn_timer_printout = "Turn "..tostring(turn_count)..","..tostring(turn_timer)
        end
        if(g_turn_timer_location ~= nil) then
           Functions.write_to_document(turn_timer_printout, g_turn_timer_location, g_turn_timer_name, ".csv", false)
        end
    end)
end

-- Counts the visible unit cards in the starting armies army panel and compares them against the starting army table built from the DAVE database.  
-- + ONLY TO BE USED WHEN STARTING/MAIN ARMY IS SELECTED
function Lib.Campaign.Misc.count_and_confirm_units_in_starting_army()
	callback(function()
		local unit_name
		local context_object
		local unit_cards_holder = Lib.Components.Campaign.main_units_panel_card_holder()
		if (unit_cards_holder ~= nil) then
			-- First check is to make sure the starting armies unit count is correct.
			local unit_count, unit_list = Common_Actions.get_visible_child_count(unit_cards_holder)
			Utilities.print("----- STARTING ARMY BREAKDOWN TEST -----")
			if unit_count == #g_faction_load_context_table["Starting_Army"]["Units"] then
				Utilities.print("	UNIT COUNT = "..unit_count)
				Utilities.status_print("[Test - Starting Army - Unit Count] ", "pass")
				Utilities.print("----- SUCCESS! - STARTING UNIT COUNT IS CORRECT -----")
			else
				local database_unit_count = #g_faction_load_context_table["Starting_Army"]["Units"]
				Utilities.print("----- Ingame unit count = "..unit_count.." // Database unit count = "..database_unit_count.." -----")
				Utilities.status_print("[Test - Starting Army - Unit Count] ", "fail")
				Utilities.print("----- FAILED! - STARTING UNIT COUNT DOES NOT MATCH DATABASE COUNT -----")
			end
			
			-- Second check is to confirm the units in the army match the ones built from the DAVE database.
			for _, unit_info in ipairs(g_faction_load_context_table["Starting_Army"]["Units"]) do
				local foundunit = false
				for unit_key, unit in ipairs(unit_list) do
					Timers_Callbacks.campaign_call(function()
						context_object = unit:GetContextObjectId("CcoCampaignUnit")
						unit_name = common.get_context_value("CcoCampaignUnit", context_object, "Name")
					end)
					if (unit_info["unit_name"] == unit_name) then
						foundunit = true
						Utilities.print("----- SUCCESS! - UNIT FOUND "..unit_name.." -----")
						table.remove(unit_list, unit_key)
						break
					end
				end
				if (foundunit ~= true) then
					Utilities.print("----- FAILED! - "..unit_name.." SHOULD NOT APPEAR IN THE STARTING ARMY -----")
				end
			end
			if (#unit_list ~= 0) then
				for _, unit in ipairs(unit_list) do
					context_object = unit:GetContextObjectId("CcoCampaignUnit")
					unit_name = common.get_context_value("CcoCampaignUnit", context_object, "Name")
					Utilities.print("----- "..unit_name.." APPEARS IN GAME BUT NOT IN THE DATABASE -----")
				end
				Utilities.print("----- FAILED! - ADDITIONAL UNITS WHERE FOUND IN GAME -----")
			end
		else
			Utilities.print("COULDNT FIND THE ARMY PANEL!")
			Utilities.print("----- FAILED TO START ARMY BREAKDOWN TEST -----")
		end
	end)
end

-- Local function apart of the Technology tree test function // Lib.Campaign.Misc.confirm_tech_nodes()
-- + Checks all visible technology nodes in the Technology tree to see if they are tied to the correct faction.
-- + Adds any Researchable nodes to the m_starting_tech_nodes member variable
local function check_tech_node_faction()
	callback(function()
		local found_incorrect_faction_node
		local tech_context_object
		local faction_context_object
		local node_data = {
			faction_name = "",
			faction_key = "",
			tech_node_name = "",
			tech_node_key = "",
			tech_node_cost = 0,
			tech_node_duration = 0,
			tech_node_researchable = false
		}
		Utilities.print("----- STARTING TECH TREE TEST -----")
		local node_parent = Lib.Components.Campaign.tech_parent()
		local _, tech_list = Common_Actions.get_visible_child_count(node_parent)
		for _,node in ipairs(tech_list) do
			Timers_Callbacks.campaign_call(function()
				tech_context_object = node:GetContextObjectId("CcoCampaignTechnology")
				
				node_data["tech_node_name"] = common.get_context_value("CcoCampaignTechnology", tech_context_object, "Name")
				node_data["tech_node_key"] = common.get_context_value("CcoCampaignTechnology", tech_context_object, "NodeKey")
				node_data["tech_node_cost"] = common.get_context_value("CcoCampaignTechnology", tech_context_object, "Cost")
				node_data["tech_node_duration"] = common.get_context_value("CcoCampaignTechnology", tech_context_object, "Duration")
				node_data["tech_node_researchable"] = common.get_context_value("CcoCampaignTechnology", tech_context_object, "CanResearch")
				
				node_data["faction_key"] = common.get_context_value("CcoCampaignTechnology", tech_context_object, "FactionContext.FactionRecordContext.Key");
				faction_context_object = common.get_context_value("CcoCampaignTechnology", tech_context_object, "FactionContext.CQI")
				node_data["faction_name"] = common.get_context_value("CcoCampaignFaction", faction_context_object, "Name")
			end)
			-- If the context table is avaiable we will use the given faction name to confirm if the nodes are apart of the right faction.
			if (g_faction_load_context_table ~= nil) then
				if (node_data["faction_name"] ~= g_faction_load_context_table["Faction_Name"]) then
					found_incorrect_faction_node = true
					Utilities.print("----- TECH NODE - "..node_data["tech_node_name"])
					Utilities.print("----- TECH NODE KEY - "..node_data["tech_node_key"])
				end
			-- If the context table isn't avaiable, we will grab the Human faction name from in game and confirm the nodes faction tie to that.
			else
				local player_faction_interface = Lib.Campaign.Actions.get_human_faction()
				if (node_data["faction_name"] == player_faction_interface:name()) then
					found_incorrect_faction_node = true
					Utilities.print("----- TECH NODE - "..node_data["tech_node_name"])
					Utilities.print("----- TECH NODE KEY - "..node_data["tech_node_key"])
				end
			end
			-- If the tech node is "Researchable" we store it in the member variable m_starting_tech_nodes for later selection.
			if (node_data["tech_node_researchable"] == true) then
				m_starting_tech_nodes[#m_starting_tech_nodes+1] = {
					node_component = node,
					node_faction_name = node_data["faction_name"],
					tech_node_name = node_data["tech_node_name"],
					tech_node_key = node_data["tech_node_key"] ,
					tech_node_cost = node_data["tech_node_cost"],
					tech_node_duration = node_data["tech_node_duration"],
				}
			end
		end
		if (found_incorrect_faction_node == true) then
			Utilities.status_print("[Test - Technology - Faction Nodes] ", "fail")
			Utilities.print("----- FAILED! - FOUND A NODE/NODES THAT DOESNT BELONG TO THIS FACTION")
		else
			Utilities.status_print("[Test - Technology - Faction Nodes] ", "pass")
			Utilities.print("----- SUCCESS! - ALL TECH NODES BELONG TO THE THIS FACTION")
		end
	end)
end

-- Local function apart of the Technology tree test function // Lib.Campaign.Misc.confirm_tech_nodes()
-- + Selects a random Researchable tech node from the m_starting_tech_nodes member variable and attempts to select it for research.
local function select_starting_tech()
	callback(function()
		local tech_context_object
		if (#m_starting_tech_nodes > 0) then
			local is_researching
			local selected_tech_node = m_starting_tech_nodes[math.random(1, #m_starting_tech_nodes)]
			Utilities.print("----- SELECTING "..selected_tech_node["tech_node_name"].." AS STARTING TECH!")
			Lib.Campaign.Clicks.select_tech(selected_tech_node["tech_node_key"])
			Lib.Helpers.Misc.wait(2, true)
			callback(function()
				local chosen_node = selected_tech_node["node_component"]
				if (chosen_node ~= nil)then
					Timers_Callbacks.campaign_call(function()
						tech_context_object = chosen_node:GetContextObjectId("CcoCampaignTechnology")
                        if(tech_context_object ~= nil)then
                            is_researching = common.get_context_value("CcoCampaignTechnology", tech_context_object, "IsResearching")
                        else
                            is_researching = false
                        end
					end)
					if (is_researching == true) then
						Utilities.status_print("[Test - Technology - Research Technology] ", "pass")
						Utilities.print("----- SUCCESS! - RESEARCHING TECH "..selected_tech_node["tech_node_name"])
					else
						Utilities.status_print("[Test - Technology - Research Technology] ", "fail")
					end
				end
			end)
		end
	end)
end

-- + Executes a check on all visible faction nodes on an open Technology Tree to confirm they are apart of the players faction.
-- + Will then select a random tech node that is Researchable.
function Lib.Campaign.Misc.perform_faction_check_and_select_starting_tech()
	callback(function()
		local tech_panel = Lib.Components.Campaign.technology_panel()
		local node_parent = Lib.Components.Campaign.tech_parent()
		if (tech_panel ~= nil and node_parent ~= nil) then
			check_tech_node_faction()
			select_starting_tech()
		end
	end)
end

-- Checks if a building has been built on a given settlement.
-- + if the member variable m_building_key_for_tech is set it will check for the m_chosen_building member variable
function Lib.Campaign.Misc.check_building_completed(settlement_interface)
	callback(function()
		local building_found = false
		local building_key = m_building_key_for_tech or m_chosen_building
		Utilities.print("-----  Checking for if "..building_key.." has completed")
		local settlement_panel = Lib.Components.Campaign.settlement_panel()
		if (settlement_panel ~= nil) then
			local active_slot_lists = settlement_interface:slot_list()
			local active_slot_number = active_slot_lists:num_items()
			for i=0, active_slot_number do
				local slot = active_slot_lists:item_at(i)
				if (slot:building():name() ~= nil and slot:building():name() == building_key) then
					Utilities.status_print("[Test - Turn 1 Building - Tech Building Built] ", "pass")
					Utilities.print("----- SUCCESS! - Upgraded building found = "..slot:building():name())
					building_found = true
					break
				end
			end
			if (building_found ~= true) then
				Utilities.status_print("[Test - Turn 1 Building - Tech Building Built] ", "fail")
				Utilities.print("----- FAILED! - Upgraded building not found after turns completed = "..building_key)
			end
		end
	end)
end

function Lib.Campaign.Misc.check_selected_building_is_building(settlement_interface)
	callback(function()
		local building_key = m_building_key_for_tech or m_chosen_building
		local settlement_panel = Lib.Components.Campaign.settlement_panel()
		if (settlement_panel ~= nil) then

		end
	end)
end

-- Checks the parsed technology node component if there is a building requirement to be able to start research.
-- If there is the building requirement list is returned.
local function check_for_building_requirement(tech_component)
	local tech_component_child_index = common.get_context_value("CcoComponent", tech_component:Id(), "ChildIndex")
	if (tech_component_child_index == 0) then
		local starting_tech_context_object = tech_component:GetContextObjectId("CcoCampaignTechnology")
		local has_building_requirement = common.get_context_value("CcoCampaignTechnology", starting_tech_context_object, "HasBuildingRequirement")
		if (has_building_requirement == true) then
			local building_requirement_list = common.get_context_value("CcoCampaignTechnology", starting_tech_context_object, "RequiredBuildingList.Size")
			if (building_requirement_list > 0) then
				return building_requirement_list
			end
		end
	end
end

-- Checks the technology tree for the first node in the chain to see if it requires
-- any buildings to be built before being able to be researched.
function Lib.Campaign.Misc.check_tech_tree_for_building_requirement()
	callback(function()
		local tech_panel = Lib.Components.Campaign.technology_panel()
		local node_parent = Lib.Components.Campaign.tech_parent()
		if (tech_panel ~= nil and node_parent ~= nil) then
			local node_parent = Lib.Components.Campaign.tech_parent()
			local _, tech_list = Common_Actions.get_visible_child_count(node_parent)
			for _,tech_component in ipairs(tech_list) do
				Timers_Callbacks.campaign_call(function()
					local building_requirement_list = check_for_building_requirement(tech_component)
					if (building_requirement_list ~= nil) then
						Utilities.print("----- Starting tech requires a building before unlocking")
						g_technology_unlocked = false
						local starting_tech_context_object = tech_component:GetContextObjectId("CcoCampaignTechnology")
						for i=1,building_requirement_list,1 do
							local cco_building = common.get_context_value("CcoCampaignTechnology", starting_tech_context_object, "RequiredBuildingList.At("..(i-1)..")")
							m_building_key_for_tech = cco_building:Call("Key")
							m_primary_build_level_requirement = cco_building:Call("PrimarySlotBuildingLevelRequirement")
							Utilities.print("----- Primary building slot needs upgrading to level = "..m_primary_build_level_requirement)
							Utilities.print("----- Building required = "..m_building_key_for_tech)
						end
					end
				end)
				if m_building_key_for_tech ~= nil then
					break
				end
			end
		end
		Lib.Campaign.Clicks.close_tech_panel()
	end)
end

-- Checks if the primary building slot of the main settlement is needing to be upgraded for the tech building to become available, and upgrades it.
-- + main_settlement_interface must be a SETTLEMENT_SCRIPT_INTERFACE
function Lib.Campaign.Misc.upgrade_primary_for_tech_required_buildings(main_settlement_interface)
	callback(function()
		if (m_primary_build_level_requirement ~= nil) then
			local main_settlement_primary_level = main_settlement_interface:primary_slot():building():building_level()
			if (main_settlement_primary_level ~= m_primary_build_level_requirement) then
				local main_settlement_primary_slot = main_settlement_interface:primary_slot()
				local main_settlement_primary_slot_building_name = main_settlement_interface:primary_slot():building():name()
				local upgrade_to_building_key = main_settlement_primary_slot_building_name:gsub("1", m_primary_build_level_requirement)
				Utilities.print("----- Upgrading primary building to level "..m_primary_build_level_requirement.."...")
				Timers_Callbacks.campaign_call(function()
					cm:region_slot_instantly_upgrade_building(main_settlement_primary_slot, upgrade_to_building_key)
				end)
			end
		end
	end)
end

-- Local function that sets the member variable m_building_turns_for_completion to the number of turns needs to be completed
-- for the building to complete.
local function set_building_turns(catagory, chain, building)
	callback(function()
		local building_turns_element = Lib.Components.Campaign.building_build_turns_icon(catagory, chain, building)
		if (building_turns_element ~= nil) then
			local turns = building_turns_element:GetStateText()
			Utilities.print(building.." IS NOW BUILDING!")
			Utilities.print(building.." WILL TAKE = "..turns.." TURNS")
			m_building_turns_for_completion = tonumber(turns)
			if m_building_turns_for_completion ~= nil then
				Utilities.status_print("[Test - Turn 1 Building - Building Set] ", "pass")
			else
				Utilities.status_print("[Test - Turn 1 Building - Building Set] ", "fail")
			end
		end
	end)
end

local function build_and_set_turns(category_id, chain_id, building_id)
	local building_child_button = Lib.Components.Campaign.building_square_build_button(category_id, chain_id, building_id)
	Timers_Callbacks.campaign_call(function()
		Common_Actions.click_component(building_child_button, "Select Building: "..building_id.." (building browser)")
		Lib.Helpers.Misc.wait(1)
		set_building_turns(category_id, chain_id, building_id)
		Lib.Campaign.Clicks.close_building_browser()
	end)
end

-- Sets a tech required building or a random building to be built.
-- + m_building_key_for_tech is set by the function Lib.Campaign.Misc.check_tech_tree_for_building_requirement()
function Lib.Campaign.Misc.find_and_build_tech_required_building_or_random()
	callback(function()
		Utilities.print("----- Building needed to unlock technology for this faction")
		local category_count, category_list = Common_Actions.get_visible_child_count(Lib.Components.Campaign.building_category_parent())
		for _, category_object in pairs(category_list) do
			local chain_count, chain_list = Common_Actions.get_visible_child_count(Lib.Components.Campaign.building_chain_parent(category_object:Id()))
			for _, chain_object in pairs(chain_list) do
				local building_count, building_list = Common_Actions.get_visible_child_count(Lib.Components.Campaign.building_parent(category_object:Id(), chain_object:Id()))
				for _, building_object in pairs(building_list) do
					local building_button = UIComponent(building_object:Find("square_building_button"))
					if (m_building_key_for_tech ~= nil) then
						if(building_object:Id() == m_building_key_for_tech and building_button:CurrentState() == "normal") then
							Utilities.print("----- Building required tech unlock building = "..m_building_key_for_tech)
							build_and_set_turns(category_object:Id(), chain_object:Id(), building_object:Id())
							return
						end
					else
						if(building_button:CurrentState() == "normal") then
							Utilities.print("----- Building available building = "..building_object:Id())
							m_chosen_building = building_object:Id()
							build_and_set_turns(category_object:Id(), chain_object:Id(), building_object:Id())
							return
						end
					end
				end
			end
		end
	end)
end

-- Sets the auto_end_turn_all_but_human command to true and begins ending X 
-- turns where X is the number set in m_building_turns_for_completion.
function Lib.Campaign.Misc.end_turn_till_building_completed()
	callback(function()
		local building_key = m_building_key_for_tech or m_chosen_building
		Utilities.print("----- Ending turns "..building_key.." is completed")
		Common_Actions.trigger_console_command("auto_end_turn_all_but_human")
		Lib.Helpers.Loops.end_turn_loop(m_building_turns_for_completion, 0)
	end)
end

function Lib.Campaign.Misc.replace_lost_general()
    callback(function()
        local replace_panel = Lib.Components.Campaign.button_hire()
        if(replace_panel ~= nil and replace_panel:Visible(true) == true) then
            local general_count, general_list = Common_Actions.get_visible_child_count(Lib.Components.Campaign.new_general_parent())
            local selectable_generals = {}
            for k, v in pairs(general_list) do
                if(v:CurrentState() ~= "inactaive") then
                    table.insert(selectable_generals, v)
                end
            end
            local general_choice = math.random(1, #selectable_generals)
            local general = selectable_generals[general_choice]
            Lib.Campaign.Clicks.new_general_select(general:Id())
            Lib.Campaign.Clicks.button_hire()
        end
    end)
end

local function charge_astral_projection(attempts)
    callback(function()
        local attempts = attempts or 0
        attempts = attempts + 1
        local button = Lib.Components.Campaign.astral_projection_button()
        if(button ~= nil and button:CurrentState() ~= "active" and attempts < 10) then
            Common_Actions.trigger_shortcut("F2")
            --Lib.Campaign.Clicks.charge_astral_projection()
            Utilities.print("Charging AP")
            Lib.Helpers.Misc.wait(1)
            charge_astral_projection(attempts)
        end
    end)
end

local function select_astral_plane(plane)
    callback(function()
        if(plane == "random")then
            plane = math.random(1,4)
        end

        if(plane == 1 or plane == "khorne") then
            Lib.Campaign.Clicks.select_khorne_realm()
        elseif(plane == 2 or plane == "nurgle") then
            Lib.Campaign.Clicks.select_nurgle_realm()
        elseif(plane == 3 or plane == "slaanesh") then
            Lib.Campaign.Clicks.enter_slaanesh_realm()
        elseif(plane == 4 or plane == "tzeentch") then
            Lib.Campaign.Clicks.select_tzeentch_realm()
        else
            Utilities.print("Valid plane not provided, using default")
        end
    end)
end

function Lib.Campaign.Misc.enter_astral_plane(plane)
    callback(function()
        charge_astral_projection()

        Lib.Campaign.Clicks.astral_projection_button()
        Lib.Helpers.Misc.wait(3)

        select_astral_plane(plane)

		Lib.Campaign.Clicks.enter_ap_realm()
		Lib.Helpers.Misc.wait(3)
    end)
end

function Lib.Campaign.Misc.toggle_skip_all_but_human(toggle_end_turn)
    if(toggle_end_turn) then
        add_event_listener(
            "FirstTickAfterWorldCreated",
            true,
            function(context)
                callback(function()
                    Common_Actions.trigger_console_command("auto_end_turn_all_but_human")
                end)
            end,
            false
        )
    end
end

-- Checks if a given faction is currently losing money each turn.
-- + faction_interface is a Faction_Script_Interface object. 
function Lib.Campaign.Misc.faction_income_check(faction_interface)
	callback(function()
		if (faction_interface ~= nil) then
			local losing_money = faction_interface:losing_money()
			if (losing_money == true) then
				Utilities.print("----- FAILED! - Faction "..faction_interface:name().." has a negative starting income")
                Utilities.status_print("[Test - Starting Income - Income is Positive] ", "fail")
			else
				Utilities.print("----- SUCCESS! - Faction "..faction_interface:name().." has a positive starting income")
                Utilities.status_print("[Test - Starting Income - Income is Positive] ", "pass")
			end
		end
	end)
end

-- Grabs and compares the members variables m_treasury_panel_income_amount and m_faction_stats_income_amount
-- against the member variable m_resource_bar_income_amount.
function Lib.Campaign.Misc.confirm_displayed_income_values()
	callback(function() 
		local income_amounts = {}
		income_amounts["Treasury Panel Income"] = m_treasury_panel_income_amount
		income_amounts["Faction Panel Income"] = m_faction_stats_income_amount

		for income_key,income_value in pairs(income_amounts) do
			Utilities.print("------ "..income_key.." displayed value = "..income_value)
			if income_value ~= m_resource_bar_income_amount then
				Utilities.status_print("[Test - Starting Income - "..income_key.."] ", "fail")
				Utilities.print("------ FAILED! - "..income_key.." doesn't match the displayed Resource Bar value")
			else
				Utilities.status_print("[Test - Starting Income - "..income_key.."] ", "pass")
			end
		end
	end)
end

-- Checks the treasury holder in the top resource bar is displaying a positive value.
-- + Returns the income value displayed.
-- + Sets the member variable m_resource_bar_income_amount to displayed income amount
function Lib.Campaign.Misc.resource_bar_income_UI_check()
	callback(function() 
		local income_amount
		local income_component = Lib.Components.Campaign.treasury_income()
		if (income_component ~= nil) then
			Timers_Callbacks.campaign_call(function()	
				income_amount = income_component:GetStateText()
			end)
			income_amount = tonumber(income_amount)
			Utilities.print("----- PLAYERS STARTING INCOME = "..income_amount)
			if (income_amount > 0) then
				Utilities.print("----- SUCCESS! - Resource Bar income is displaying positive")
                Utilities.status_print("[Test - Starting Income - Resource Bar is positive] ", "pass")
			elseif (income_amount < 0) then
				Utilities.print("----- FAILED! - Resource Bar income is displaying negative")
                Utilities.status_print("[Test - Starting Income - Resource Bar is Positive] ", "fail")
			end
			m_resource_bar_income_amount = income_amount
		end
	end)
end

-- Checks the Treasury panel is displaying a positive income value.
-- + Returns the income value displayed.
-- + Sets the member variable m_treasury_panel_income_amount to displayed income amount
function Lib.Campaign.Misc.treasury_panel_income_check()
	callback(function()
		local treasury_button = Lib.Components.Campaign.treasury_button()
		if (treasury_button ~= nil) then
			callback(function()
				Lib.Campaign.Clicks.open_treasury_panel(true)
				Lib.Helpers.Misc.wait(1)
			end)
			callback(function()
				local income_amount
				local treasury_income_component = Lib.Components.Campaign.treasury_finance_projected_income_element()
				if (treasury_income_component ~= nil) then
					Timers_Callbacks.campaign_call(function()	
						income_amount = treasury_income_component:GetStateText()
					end)
					income_amount = tonumber(income_amount)
					if (income_amount > 0) then
						Utilities.print("----- SUCCESS! - Treasury Panel starting income is displaying positive")
                        Utilities.status_print("[Test - Starting Income - Treasury Panel is Positive] ", "pass")
					elseif(income_amount < 0) then
						Utilities.print("----- FAILED! - Treasury Panel starting income is displaying  negative")
                        Utilities.status_print("[Test - Starting Income - Treasury Panel is Positive] ", "fail")
					end
					m_treasury_panel_income_amount = income_amount
				end
			end)
		end
	end)
end

-- Checks the Faction panel is displaying a positive income value.
-- + Returns the income value displayed.
-- + Sets the member variable m_faction_stats_income_amount to displayed income amount
function Lib.Campaign.Misc.faction_panel_income_check()
	callback(function() 
		local income_amount
		local factions_button = Lib.Components.Campaign.faction_summary_button()
		if (factions_button ~= nil) then
			callback(function()
				Lib.Campaign.Clicks.open_factions_summary_panel()
				Lib.Helpers.Misc.wait(1)
			end)
			callback(function()
				local faction_panel_income_amount = Lib.Components.Campaign.faction_details_income_element()
				Timers_Callbacks.campaign_call(function()
					income_amount = faction_panel_income_amount:GetStateText()
				end)
				income_amount = tonumber(income_amount)
				if (income_amount > 0) then
					Utilities.print("----- SUCCESS! - Faction Panel starting income is displaying positive")
                    Utilities.status_print("[Test - Starting Income - Faction Panel is Positive] ", "pass")
				elseif(income_amount < 0) then
					Utilities.print("----- FAILED! - Faction Panel starting income is displaying  negative")
                    Utilities.status_print("[Test - Starting Income - Faction Panel is Positive] ", "fail")
				end
				Lib.Campaign.Clicks.close_factions_summary_panel()
				m_faction_stats_income_amount = income_amount
			end)
		end
	end)
end


--###### EVENT LOGGING FUNCTIONS ######
function Lib.Campaign.Misc.get_all_event_text(parent_component)
    --this function is used to log every single component with text in an events layout
    --its used to quickly get all the text from an event without needing to setup complex logging to get specific parts etc
    callback(function() 
        local parent_print = false
        --get all children of parent
        local child_count, child_list = Common_Actions.get_visible_child_count(parent_component)

        for _,child in pairs(child_list) do
            --check if it has text, if so print out the ID, the text and full path
            if(child:GetStateText() ~= nil and string.match(child:GetStateText(),"%S") ~= nil) then
                --We want to have the parent ID and then all children after it, so we do this only once at the start of the loop but only if there is a child with text
                if(parent_print~=true)then
                    parent_print = true
                    Functions.write_to_document("\n------------\nParent ID: "..tostring(parent_component:Id()), g_event_log_location, g_secondary_event_log_name, ".txt", false, true)
                end
                local full_text = "Child ID: "..tostring(child:Id()).."\nComponent Path: "..tostring(Functions.find_path_from_component(child)).."\nText: "..tostring(child:GetStateText()).."\n"

                Functions.write_to_document(full_text, g_event_log_location, g_secondary_event_log_name, ".txt", false, true)
            end
        end
        --once we've printed out all the children with text, we then go through all the children again
        --if any of them have children we call this function again but on that child component
        --this way we traverse the entire component tree of this even finding all the components with text
        for _,child in pairs(child_list) do
            if(child:ChildCount() > 0)then
                Lib.Campaign.Misc.get_all_event_text(child)
            end
        end
    end)
end

function Lib.Campaign.Misc.create_event_log_file()
    local appdata = os.getenv("APPDATA")
    g_event_log_location = appdata.."\\CA_Autotest\\WH3\\event_logs"
    Utilities.print("LOGS! "..g_event_log_location)
    g_event_log_name = os.date("event_log_%d%m%y_%H%M")
    g_secondary_event_log_name = os.date("secondary_event_log_%d%m%y_%H%M")
    os.execute("mkdir \""..g_event_log_location.."\"")
    --add headers to the csv and a small intro to the text file
    Functions.write_to_document("Turn,EventType,Title,Description/Details,choice1 title/Incident Effects,choice1 effects,choice2 Title,choice2 effects", g_event_log_location, g_event_log_name, ".csv", false, true)
    Functions.write_to_document("###################\nAny component that has text in an events layout is stored here. \nThis can be used to track what events have happened during a campaign. \nAll standard dilemma and incident event details are logged to the csv file instead called "..tostring(g_event_log_name).." for everything else, it's here.\n##############", g_event_log_location, g_secondary_event_log_name, ".txt", false, true)  
end

local function get_payload_info(payload)
    --called for a dilemma choice, each dilemma choice can have multiple effects so this is called on each effect of each choice
    local text_comp = UIComponent(payload:Find("effect_icon"))
    local turn_component = UIComponent(text_comp:Find("turns_display"))
    local text = ""
    if(turn_component:Visible() == true)then
        --some effects have a duration in turns, add it on if so
        text = Utilities.prepare_string_for_csv(text_comp:GetStateText()).." - Duration: "..turn_component:GetStateText()
    else
        text = Utilities.prepare_string_for_csv(text_comp:GetStateText())
    end
    return text
end

local function get_choices_info()
    --called to get all the information about all the dilemma choices
    local choices_count, choices_list = Common_Actions.get_visible_child_count(Lib.Components.Campaign.dilemma_choices_parent())
    local all_choices_info = ""
    --for each choice do the following:
    for _,choice in pairs(choices_list) do
        --get the button and tings
        local choice_info_string = ""
        local choice_button = UIComponent(choice:Find("choice_button"))
        local choice_button_text_comp = UIComponent(choice_button:Find("button_txt"))
        local choice_button_text = Utilities.prepare_string_for_csv(choice_button_text_comp:GetStateText())
        local payload_count, payload_list = Common_Actions.get_visible_child_count(UIComponent(choice:Find("payload_list")))

        local payload_info = ""

        for _,payload in pairs(payload_list) do
            payload_info = payload_info.." | "..get_payload_info(payload) --delimit payloads with | rather than , as we want them all in the same column in CSV
        end

        choice_info_string = choice_button_text..","..payload_info
        all_choices_info = all_choices_info..","..choice_info_string
    end
        --remove the leading , from the string of choices
        if(string.sub(all_choices_info, 1,1) == ",")then
            all_choices_info = string.sub(all_choices_info,2)
        end

    return all_choices_info
end

local function log_dilemma()
    callback(function() 
        Utilities.print("Logging a dilemma!")

        local title_text = Utilities.prepare_string_for_csv(Lib.Components.Campaign.dilemma_title():GetStateText())
        local description_text = Utilities.prepare_string_for_csv(Lib.Components.Campaign.dilemma_description():GetStateText())
        local all_choices_info = get_choices_info()

        local dilemma_full_string = title_text..","..description_text..","..all_choices_info
        local turn_number = Lib.Campaign.Misc.get_current_turn_number()
        dilemma_full_string = tostring(turn_number)..",Dilemma,"..dilemma_full_string --whack the current turn and event type on the front

        Functions.write_to_document(dilemma_full_string, g_event_log_location, g_event_log_name, ".csv", false, true)
    end)
end

local function log_incident()
    callback(function() 
        Utilities.print("Logging an incident!")

        local title = Utilities.prepare_string_for_csv(Lib.Components.Campaign.incident_title():GetStateText())
        local sub_title = Utilities.prepare_string_for_csv(Lib.Components.Campaign.incident_subtitle():GetStateText())
        local details = Utilities.prepare_string_for_csv(Lib.Components.Campaign.incident_details():GetStateText())
        
        local effects_count, effects_list = Common_Actions.get_visible_child_count(Lib.Components.Campaign.incident_effects_parent())
        local effect_text = ""
        local incident_full_string = "title-subtitle, details, effectlist"

        for _,effect in pairs(effects_list) do
            local effect_icon = UIComponent(effect:Find("effect_icon"))
            local turns_display = UIComponent(effect:Find("turns_display"))
            if(turns_display:Visible() == true)then
                effect_text = effect_text.." | "..Utilities.prepare_string_for_csv(effect_icon:GetStateText()).." - Duration: "..turns_display:GetStateText() --delmit effects by | and effect+duration with -
            else
                effect_text = effect_text.." | "..Utilities.prepare_string_for_csv(effect_icon:GetStateText())
            end
        end

        incident_full_string = title.." - "..sub_title..","..details..","..effect_text --combine title and subtitle into one section delimited by -
        local turn_number = Lib.Campaign.Misc.get_current_turn_number()
        incident_full_string = tostring(turn_number)..",Incident,"..incident_full_string --whack the current turn and event type on the front

        Functions.write_to_document(incident_full_string, g_event_log_location, g_event_log_name, ".csv", false, true)
    end)
end

function Lib.Campaign.Misc.get_event_info_and_log_to_csv()
    callback(function() 
        --determine if the event is incident or dilemma
        local event_count, event_children = Common_Actions.get_visible_child_count(Lib.Components.Campaign.event_layout_parent())

        if(#event_children > 0 and event_children[1]:Id() == "dilemma_active")then
            --call the log dilemma function
            log_dilemma()
        elseif(#event_children > 0 and event_children[1]:Id() == "incident") then
            --call the log incident function
            log_incident()
        elseif(#event_children>0)then
            --if its not a dilemma or incident, check if its a weird type of dilemma and log something otherwise do the amazing textfile tings
            Utilities.print("Unhandled event, logging all text to text file! Event type: "..tostring(event_children[1]:Id()))

            local turn_number = Lib.Campaign.Misc.get_current_turn_number()
            Functions.write_to_document("\n############# \nTurn: "..tostring(turn_number).."\nEvent Type: "..tostring(event_children[1]:Id()).." \n###########", g_event_log_location, g_secondary_event_log_name, ".txt", false, true)
            
            Lib.Campaign.Misc.get_all_event_text(event_children[1])
        else
            Utilities.print("Failed! Tried to log an event but there isn't one.")
        end
    end)
end

function Lib.Campaign.Misc.confirm_dlc_is_enabled(dlc_mask_string)
	callback(function()
		local dlc_enabled
		Timers_Callbacks.campaign_call(function() 
			dlc_enabled = cm:is_dlc_flag_enabled(dlc_mask_string)
		end)
		if dlc_enabled == true then
			Utilities.print("DLC Mask "..dlc_mask_string.." is ENABLED")
			table.insert(g_enabled_dlc, dlc_mask_string)
		end
	end)
end

function Lib.Campaign.Misc.handle_end_turn_pause()
    callback(function()
        Utilities.print("End Turn Pause detected")
        local pause_button = Lib.Components.Campaign.menu_bar_end_turn_pause()
        local scripted_tour_window = Lib.Components.Helpers.scripted_tour_window()
        if scripted_tour_window ~= nil and scripted_tour_window:Visible() == true then
            Utilities.print("Scripted tour detected, attempting to close it")
            Lib.Campaign.Misc.handle_scripted_tour()
        else
            Utilities.print("Scripted tour not detected, attempting to unpause the end turn")
        end
        if pause_button ~= nil and pause_button:CurrentState() ~= "active" then
            Lib.Campaign.Clicks.pause_unpause_end_turn()
            Utilities.print("Resuming End Turn")
        end
    end)
end

-- scripted tours are tutorials that stop all UI interactions and direct the user to specific portions of the UI
-- they cannot be skipped by pressing ESC, only by clicking X on the scripted tour window or by going through all the panels
function Lib.Campaign.Misc.handle_scripted_tour(count)
    callback(function()
        count = count or 0
        local scripted_tour_close = Lib.Components.Helpers.scripted_tour_close()
        if scripted_tour_close ~= nil and scripted_tour_close:Visible() == true then
            Common_Actions.click_component(scripted_tour_close, "Scripted Tour Close Button", true)
            Lib.Helpers.Misc.wait(2)
        else
            local scripted_tour_end = Lib.Components.Helpers.scripted_tour_end()
            if scripted_tour_end ~= nil and scripted_tour_end:Visible() == false then
                Utilities.print("No close button detected for the scripted tour. Trying to press Next until it's gone")
                local scripted_tour_next = Lib.Components.Helpers.scripted_tour_next()
                Common_Actions.click_component(scripted_tour_next, "Scripted Tour Next Button", true)
                count = count + 1
                Lib.Campaign.Misc.handle_scripted_tour(count)
            else
                Common_Actions.click_component(scripted_tour_end, "Scripted Tour End Button", true)
            end
        end
    end)
end

function Lib.Campaign.Misc.campaign_loading_times_sweep(variables)
    callback(function()
        Lib.Frontend.Misc.ensure_frontend_loaded()
        Lib.Frontend.Loaders.load_chaos_campaign(variables.lord, variables.campaign_type)
        Lib.Helpers.Timers.write_campaign_timers_to_file("Campaign Menu into Campaign Map")
        Lib.Campaign.Misc.ensure_cutscene_ended()
        Lib.Campaign.Actions.attack_nearest_target(10)
        Lib.Helpers.Timers.write_campaign_timers_to_file("Campaign Battle to Campaign Map")
        Lib.Menu.Misc.quit_to_frontend()
        Lib.Frontend.Misc.ensure_frontend_loaded()
        Lib.Helpers.Timers.end_timer("Return to Frontend Time")
        Lib.Helpers.Timers.write_campaign_timers_to_file("Campaign Map to Front End")
        Lib.Helpers.Timers.write_campaign_details_to_file()
    end)
end