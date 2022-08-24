function Lib.Helpers.Loops.OLD_end_turn_loop(turn_count)
    for i = 1, turn_count do
        callback(function()
                local current_turn = Lib.Campaign.Misc.get_current_turn_number()
                local display_turn_number = Lib.Campaign.Misc.get_current_turn_number_display()
    
                Utilities.print("----INFO: Actual Turn "..current_turn.." -----")
                Utilities.print("----INFO: Displayed Turn "..display_turn_number.." -----")
                if(tostring(current_turn) ~= tostring(display_turn_number)) then
                    Utilities.print("Displayed turn number doesn't match actual turn number... FAILED!")
                end
                Utilities.print("...")
    
                if(current_turn == 1)then
                    Lib.Campaign.Misc.ensure_cutscene_ended()
                end
    
                --Lib.Campaign.Faction_Info.print_faction_info()
                Lib.Campaign.Behaviours.player_turn_actions()
                Lib.Helpers.Misc.start_log_results(nil, nil, nil, current_turn + 1, 2)
                Lib.Campaign.Misc.end_turn_without_fail()
                Lib.Campaign.Misc.wait_for_player_turn_start()
                Lib.Helpers.Misc.record_log_results(nil, nil, nil, current_turn + 1, 1)
        end)
    end
end

--added a new end turn loop that uses recurrsion rather than a for loop so it's easier to break out if the campaign ends early, kept the old one just in case it's needed
function Lib.Helpers.Loops.end_turn_loop(turn_target, turn_count)
    turn_count = turn_count or 1
        callback(function()
            if(g_force_victory)then
                Utilities.print("Resetting force victory count at start of turn.")
                g_force_victory_count = 0
            end
            local current_turn = Lib.Campaign.Misc.get_current_turn_number()
            local display_turn_number = Lib.Campaign.Misc.get_current_turn_number_display()
            g_turn_number = current_turn
            Utilities.print("----INFO: Actual Turn "..current_turn.." -----")
            Utilities.print("----INFO: Displayed Turn "..display_turn_number.." -----")
            Lib.Helpers.Test_Cases.update_checkpoint_file("Turn started: "..tostring(g_turn_number))
            if(tostring(current_turn) ~= tostring(display_turn_number)) then
                Utilities.print("Displayed turn number doesn't match actual turn number... FAILED!")
            end
            Utilities.print("...")

            if(current_turn == 1)then
                Lib.Campaign.Misc.ensure_cutscene_ended()
            end

            --Lib.Campaign.Faction_Info.print_faction_info()
            Lib.Campaign.Behaviours.player_turn_actions()
            Lib.Helpers.Misc.start_log_results(nil, nil, nil, current_turn + 1, 2)

            if(turn_count < turn_target and g_exit_early == false)then
                Lib.Campaign.Misc.end_turn_without_fail()
                Lib.Campaign.Misc.wait_for_player_turn_start()
                Lib.Helpers.Misc.record_log_results(nil, nil, nil, current_turn + 1, 1)
                Lib.Helpers.Loops.end_turn_loop(turn_target, turn_count+1)
            else
                Utilities.print("----INFO: Target Turn reached or having to exit the run early for some reason -----")
            end
        end)
end

function Lib.Helpers.Loops.map_load_test_loop(map_type, wh3_maps_only, set_dressed_only)
    Lib.Frontend.Custom_Battle.generate_map_list(wh3_maps_only, set_dressed_only, map_type)
    if(not g_log_map_names_to_text_file)then
        callback(function()
            if(map_type == nil or map_type == "All") then
                for i = 1, #g_map_type_counts do
                    for j = g_starting_maps[i][2], #g_map_type_counts[i][3] do
                        Lib.Frontend.Loaders.load_custom_battle(i, g_map_type_counts[i][3][j])
                        callback(function()
                            if(g_battle_launched == true) then
                                Lib.Battle.Misc.concede_battle()
                            end
                        end)
                    end
                end
            else
                local map_type_index
                for k, v in pairs(g_map_type_counts) do
                    if(v[1] == map_type) then
                        map_type_index = k
                        break
                    end
                end
                for i = g_starting_maps[map_type_index][2], #g_map_type_counts[map_type_index][3] do
                    Lib.Frontend.Loaders.load_custom_battle(map_type_index, g_map_type_counts[map_type_index][3][i])
                    callback(function()
                        if(g_battle_launched == true) then
                            Lib.Battle.Misc.concede_battle()
                        end
                    end)
                end
            end
        end)
    end 
end

function Lib.Helpers.Loops.every_setting_combination_sweep(current_setting)
    callback(function()
        -- We decided not to use this as there are several billion combinations of graphics settings that can be chosen so it wouldn't be practical to run.
        -- Put quite a bit of time into getting this working/making it not look terrible so keeping it around in-case we can repurpose the code for something else.
        -- Loading a battle with every possible battle setting combination etc.
        if(current_setting == nil or current_setting > 0) then
            g_game_setting_test_case = g_game_setting_test_case or {}
            current_setting = current_setting or 1
            local current_setting_name = g_setting_sweep_list[current_setting]
            local current_setting_type = g_setting_sweep_list[current_setting_name][1]
            local current_setting_component = g_setting_sweep_list[current_setting_name][2]
            local current_setting_limit = g_setting_sweep_list[current_setting_name][3]
            local current_test_case_entry = g_game_setting_test_case[current_setting]

            local next_setting_name = g_setting_sweep_list[current_setting + 1]
            local next_test_case_entry = g_game_setting_test_case[current_setting + 1]
            local next_setting_limit
            if(g_setting_sweep_list[next_setting_name] ~= nil) then
                next_setting_limit = g_setting_sweep_list[next_setting_name][3]
            end

            if(current_test_case_entry == nil) then
                -- set the initial count for this setting
                g_game_setting_test_case[current_setting] = 1
                current_test_case_entry = 1
            elseif(next_test_case_entry ~= nil and next_test_case_entry > next_setting_limit) then
                -- reset the next setting back to 0 (because it will count back up to 1 in the next loop)
                -- step the current setting up once.
                g_game_setting_test_case[current_setting + 1] = 0
                g_game_setting_test_case[current_setting] = g_game_setting_test_case[current_setting] + 1
                current_test_case_entry = g_game_setting_test_case[current_setting]
                next_test_case_entry = g_game_setting_test_case[current_setting + 1]
            else
                -- step the current setting up one
                g_game_setting_test_case[current_setting] = current_test_case_entry + 1
                current_test_case_entry = g_game_setting_test_case[current_setting]
            end

            if(current_test_case_entry > current_setting_limit) then
                -- current setting now exceeds it's limit, reset and count the previous setting up one.
                Lib.Helpers.Loops.game_setting_sweep(current_setting - 1)
            elseif(current_setting < #g_setting_sweep_list) then
                -- move down the list until we reach the final setting
                Lib.Helpers.Loops.game_setting_sweep(current_setting + 1)
            else 
                -- have set the final setting in the test case, actually set the settings and start the next testcase

                -- call function here to do stuff with the test case

                Lib.Helpers.Loops.game_setting_sweep(current_setting)
            end
        else
            -- current_setting has been reduced to 0, which means all test cases have been completed
            Lib.Frontend.Clicks.return_to_main_menu()
        end
    end)
end

function Lib.Helpers.Loops.graphics_setting_stability_sweep(benchmark, location)
    callback(function()
        Lib.Frontend.Options.record_advanced_graphics_dropdown_counts()
        for i = 1, #g_setting_sweep_list do
            local starting_position = 1
            if(i >= 2) then
                -- everything set to minimum is tested in the first loop, so every other setting can start at its 2nd setting.
                starting_position = 2
            end
            for j = starting_position, g_setting_sweep_list[g_setting_sweep_list[i]][3] do
                Lib.Frontend.Clicks.graphics_advanced()
                for l = 1, #g_setting_sweep_list do
                    if(l ~= i) then
                        if(g_setting_sweep_list[i] == "fog" and g_setting_sweep_list[l] == "shadow detail") then
                            -- fog can't be set unless shadows is turned on, so when its fogs turn, we set shadows to it's lowest "on" setting.
                            Lib.Frontend.Options.set_advanced_graphics_setting(g_setting_sweep_list[l], 2)
                        elseif(g_setting_sweep_list[l] ~= "fog") then
                            -- If it isn't fogs turn, shadows will be set to off, which disables fog, meaning we do all settings BUT fog
                            Lib.Frontend.Options.set_advanced_graphics_setting(g_setting_sweep_list[l], 1)
                        end
                    end
                end
                Lib.Frontend.Options.set_advanced_graphics_setting(g_setting_sweep_list[i], j)
                Lib.Frontend.Clicks.apply_graphics()
                -- after changing some settings there is a popup.
                Lib.Frontend.Clicks.close_popup()

                if(benchmark ~= nil and benchmark ~= "No Benchmark") then
					-- run benchmark in each setting
					Lib.Frontend.Clicks.graphics_advanced()
					Lib.Frontend.Clicks.graphics_benchmark_button()
					Lib.Frontend.Options.select_benchmark(benchmark)
                    Lib.Frontend.Clicks.start_benchmark_button()
                    Lib.Helpers.Misc.wait(5)
                    Lib.Helpers.Misc.exit_benchmark_when_finished(benchmark)
                    Lib.Frontend.Clicks.options_graphics()
                    if (location ~= nil) then
                        Lib.Helpers.Misc.copy_benchmark_result_and_rename(location)
                        Lib.Helpers.Misc.wait(2)
                    end
                end
            end
        end
    end)
end

function Lib.Helpers.Loops.load_all_faction_quest_battles(faction, battle_duration, current_lord, current_battle)
    if(g_quest_battle_list == nil) then
        current_lord = 1
        current_battle = 1
        Lib.Frontend.Quest_Battle.set_faction_id_and_battle_count(faction)
    end
    callback(function()
        if(g_quest_battle_list[current_lord] >= current_battle) then
            Lib.Frontend.Loaders.load_quest_battle(g_quest_battle_faction, current_lord, current_battle)
            Lib.Battle.Misc.concede_battle_after_duration(battle_duration)
            current_battle = current_battle + 1
            Lib.Helpers.Loops.load_all_faction_quest_battles(g_quest_battle_faction, battle_duration, current_lord, current_battle)
        elseif(#g_quest_battle_list > current_lord) then
            current_lord = current_lord + 1
            current_battle = 1
            Lib.Helpers.Loops.load_all_faction_quest_battles(g_quest_battle_faction, battle_duration, current_lord, current_battle)
        else
            -- all quest battles for this faction have been loaded
            return
        end
    end)
end

--go through the relevant lord table and check the first entry in the sub table (which gives their race) and add it to the list if its the right race
local function get_all_lords_in_race(race_choice, campaign_type)
    local table_to_use
    local table_to_return = {}
    local temp_count = 0
    if(campaign_type == "The Realm of Chaos")then
        table_to_use = g_chaos_lord_list
    else
        table_to_use = g_immortal_empires_lord_list
    end
    for lord_name,sub_table in pairs(table_to_use) do
        if(sub_table[1] == race_choice)then
            table_to_return[lord_name] = sub_table
            temp_count = temp_count+1
        end
    end
    Utilities.print("AMOUNT OF LORDS: "..tostring(temp_count))
    return table_to_return
end

--perform the faction load test on one or more factions (lords)
function Lib.Helpers.Loops.faction_load_test_loop(variables)
    callback(function()
        --if there's a single lord choice, put it in a table for consistency later on (results in the "loop" running once)
        local lord_table = {[variables.lord] = "this can be anything as it's not used"} 

        if(variables.race_choice ~= nil and variables.race_choice ~= "None")then --race choice takes precedence over lord choice
            lord_table = get_all_lords_in_race(variables.race_choice, variables.campaign_type)
        elseif(variables.lord == "All")then
            if(variables.campaign_type == "The Realm of Chaos")then
                lord_table = g_chaos_lord_list
            else
                lord_table = g_immortal_empires_lord_list
            end
        end

        for lord_name,_ in pairs(lord_table) do
            Lib.Helpers.Misc.perform_load_test_on_faction(lord_name, variables)
        end
    end)
end
