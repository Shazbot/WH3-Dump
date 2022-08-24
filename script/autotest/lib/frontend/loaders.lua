function Lib.Frontend.Loaders.load_chaos_campaign(lord, campaign_type, database_checking)
	callback(function()
        campaign_type = campaign_type or "The Realm of Chaos"
        if(lord ~= nil and string.lower(lord) == "random") then
            lord = nil
        end
        lord = lord or Lib.Frontend.Campaign.get_random_lord(campaign_type)
		database_checking = database_checking or false
        Lib.Frontend.Clicks.campaign_tab()
        Lib.Frontend.Clicks.new_campaign()
        Lib.Frontend.Clicks.select_campaign_type(campaign_type, true)
        --Lib.Frontend.Clicks.campaign_select_continue()
        --scripter only function, used to generate race and lord tables
        --Lib.Frontend.Loaders.generate_tables()

        local race_table = g_chaos_lord_list[lord] or g_immortal_empires_lord_list[lord]
        local race = race_table[1]
        Lib.Frontend.Campaign.select_chaos_campaign_race(race)
        Lib.Frontend.Campaign.select_chaos_campaign_lord(lord, campaign_type)
        callback(function()
            Lib.Helpers.Misc.start_log_results(nil, nil, nil, nil, nil, nil, campaign_type, g_lord, 2)
            -- At this point after the lord and campaign type are set, we generate a context table for the given lord from the DAVE database
		    -- and require it into the lua environment.
		    if (database_checking ~= false) then
			    g_context_table_lua_path = Lib.DAVE_Database.Misc.create_lord_context_table(g_lord, campaign_type)
			    Lib.DAVE_Database.Misc.get_lord_context_table(g_context_table_lua_path)
		    end
            -- Lua script are paused during a transition so in order to test alt-tab during a loading screen, we start a python script does that for us.
            -- The script immediately alt-tabs back to the game, then after a set period it alt-tabs out of the game and back in.
            if g_compat_sweep then
                callback(function()
                    io.popen('start cmd /c py -u C:\\compat_sweep\\app_switch.py \"Total War: WARHAMMER 3\"', 'r')
                    Lib.Helpers.Misc.wait(5)
                end)
            end
            Lib.Helpers.Timers.start_timer()
            Lib.Frontend.Clicks.start_campaign()
		    Lib.Helpers.Test_Cases.set_test_case("Start Campaign", "start")
            Lib.Helpers.Test_Cases.update_checkpoint_file("campaign started "..tostring(g_lord))
            Lib.Campaign.Misc.ensure_campaign_loaded()
            Lib.Helpers.Misc.record_log_results(nil, nil, nil, nil, nil, nil, campaign_type, g_lord, 1)
            g_exit_early = false --when loading a new campaign we set this global variable so the loop knows if the campaign finishes early
        end)
    end, wait.medium)
end

function Lib.Frontend.Loaders.load_custom_battle(battle_type, map_preset, difficulty, time, funds, tower_level, realism, large_armies, unit_scale, team_1_size, team_2_size, team_faction_table, auto_start)
    callback(function()
        Lib.Frontend.Clicks.battles_tab()
        Lib.Frontend.Clicks.custom_battle()
        Lib.Frontend.Custom_Battle.select_battle_type_and_map(battle_type, map_preset)
        Lib.Frontend.Custom_Battle.set_battle_settings(difficulty, time, funds, tower_level, realism, large_armies, unit_scale)
        Lib.Frontend.Custom_Battle.set_teams(team_1_size, team_2_size)
        Lib.Frontend.Custom_Battle.set_all_player_factions(team_faction_table)
        Lib.Frontend.Custom_Battle.autogenerate_all_armies()
        Lib.Frontend.Custom_Battle.print_battle_settings()
        callback(function()
            Lib.Helpers.Misc.start_log_results(nil, nil, nil, nil, nil, nil, nil, nil, nil, g_battle_settings["Map Type"], g_battle_settings["Map"], 2)
            Lib.Frontend.Custom_Battle.start_custom_battle()
			if (auto_start == false) then
				Lib.Battle.Misc.ensure_battle_loaded()
			else
				Lib.Battle.Misc.ensure_battle_started()
			end
            Lib.Helpers.Timers.end_timer("Battle Load Time")
            Lib.Helpers.Misc.record_log_results(nil, nil, nil, nil, nil, nil, nil, nil, nil, g_battle_settings["Map Type"], g_battle_settings["Map"], 1)
        end)
    end, wait.long)
end

function Lib.Frontend.Loaders.setup_battle_settings_for_bedsat() --should be called at start of the script and then thats it, subsequent battles just change factions/units
    callback(function()
        Lib.Frontend.Clicks.battles_tab()
        Lib.Frontend.Clicks.custom_battle()
        Lib.Frontend.Custom_Battle.select_battle_type_and_map("Land Battle", "AAAA Flat Map") --whenever possible, select the AAAA flat map in Land Battles
        Lib.Frontend.Custom_Battle.set_battle_settings("Easy", "Unlimited Time", "Custom Funds", nil, false, false, "Random")
        Lib.Frontend.Custom_Battle.set_teams(1, 1)
    end)
    Lib.Frontend.Custom_Battle.select_army_setup_tab()
end

--if called with quality left as nil it won't change the quality
function Lib.Frontend.Loaders.load_benchmark(quality, benchmark)
    callback(function() 
        Lib.Frontend.Clicks.options_tab()
        Lib.Frontend.Clicks.options_graphics()
        Lib.Frontend.Options.select_graphics_quality(quality)
        Lib.Frontend.Clicks.graphics_advanced()
        Lib.Frontend.Clicks.graphics_benchmark_button()
        Lib.Frontend.Options.select_benchmark(benchmark)
        Lib.Frontend.Clicks.start_benchmark_button()
        Lib.Helpers.Misc.wait(5)
        Lib.Helpers.Misc.wait(5)
    end, wait.long)
end

function Lib.Frontend.Loaders.load_quest_battle(faction, lord, battle)
    callback(function()
        Lib.Frontend.Clicks.battles_tab()
        Lib.Frontend.Clicks.quest_battle()
        Lib.Frontend.Quest_Battle.select_faction(faction)
        Lib.Frontend.Quest_Battle.select_lord(lord)
        Lib.Frontend.Quest_Battle.select_quest_battle(battle)
        Lib.Frontend.Clicks.custom_battle_start()
        Lib.Helpers.Misc.wait(5)
        Lib.Helpers.Misc.wait(5)
    end)
end

function Lib.Frontend.Loaders.navigate_to_quest_battle()
	callback(function()
		Lib.Frontend.Clicks.battles_tab()
        Lib.Frontend.Clicks.quest_battle()
		Lib.Helpers.Misc.wait(5)
	end)
end

function Lib.Frontend.Loaders.quest_battle_setup(faction_choice, lord_choice)
	callback(function()
		Lib.Frontend.Quest_Battle.select_faction(faction_choice)
		Lib.Frontend.Quest_Battle.select_lord(lord_choice)
		Lib.Helpers.Misc.wait(2)
	end)
end

-- by default, the function will load the replay as a normal battle (fight battle option);
function Lib.Frontend.Loaders.load_replay(replay, watch_replay)
    callback(function()
        watch_replay = watch_replay or false
        Lib.Frontend.Clicks.battles_tab()
        Lib.Frontend.Clicks.replays()
        Lib.Helpers.Misc.wait(5) -- the replay list can take a few seconds to populate
        callback(function()
            Lib.Frontend.Misc.select_replay(replay)
            Lib.Helpers.Misc.wait(2) -- takes a bit to load the armies in the replay preview
            callback(function()
                if (watch_replay) then
                    Common_Actions.click_component(Lib.Components.Frontend.watch_replay(), "Watch Replay selected for replay: "..g_replay_name)
                else
                    Common_Actions.click_component(Lib.Components.Frontend.fight_replay(), "Fight Battle selected for replay: "..g_replay_name)
                end
                Lib.Helpers.Timers.start_timer()
                Lib.Battle.Misc.ensure_battle_started()
                Lib.Helpers.Timers.end_timer("Battle Load Time")
            end)
        end)
    end)
end

--#### debug functions used to generate race and lord lists ###

local m_race_list = {}
local m_lord_list = {}
local m_faction_list={}
local m_faction_names = {}

--all these functions use print() instead of Utilities.print() so that the output doesnt have Autotest: in front of it, makes copy and pasting the results easier
local function print_race_table()
    callback(function()
        print("")
        print("g_immortal_empires_race_list = {}") 
        for k,v in pairs(m_race_list) do
            print("g_immortal_empires_race_list[\""..tostring(k).."\"] = \""..tostring(v).."\"")  
        end
    end)    
end

local function print_lords_table()
    callback(function() 
        print("")
        print("g_immortal_empires_lord_list  = {}") 
        for _,faction in ipairs(m_faction_names) do --we use ipairs and m_faction_names to make sure we print out lords of the same race together, otherwise its a random jumble
            for lord,lord_info_table in pairs(m_lord_list) do
                if(lord_info_table[1] == faction)then --if this lord is from the faction we're currently on we want to print their info!
                    local v_string = ""
                    for _,inner_value in ipairs(lord_info_table) do
                        v_string = v_string.."\""..inner_value.."\", "
                    end
                    v_string = string.sub(v_string, 1, #v_string-2) --remove the last two lines as they'll be a comma and a space
                    print("g_immortal_empires_lord_list[\""..tostring(lord).."\"] = {"..tostring(v_string).."}")
                end
            end
        end

        --this part just prints out all the lord names in quotation marks, this is for the GSAT custom variables file and ensures they exactly match the keys in the tables
        print("")
        print("For the variables File: ")
        local lord_line = "\"Random\","
        for _, faction in ipairs(m_faction_names) do
            for lord,lord_info_table in pairs(m_lord_list) do
                if(lord_info_table[1] == faction)then
                    lord_line = lord_line.."\""..tostring(lord).."\","
                end
            end
        end
        print(lord_line)
    end)
end

-- factions/races are stored in tables with the name as the key and the component id as the value
local function add_faction_to_race_list(faction)
    callback(function() 
        local button = UIComponent(faction:Find("race_button"))
        local name = UIComponent(button:Find("dy_race"))
        local faction_name = Utilities.prepare_string_for_csv(name:GetStateText())
        m_race_list[faction_name] = faction:Id()
    end)
end

--we need to loop through all the factions then loop through all the lords for that faction and store the correct info
--this function uses recurrsion to trawl through the faction list in order
local function populate_lord_list(list_entry_index)
    callback(function() 
        --click the faction
        local faction = m_faction_list[list_entry_index]
        Lib.Frontend.Clicks.race_select_button(true)
        Lib.Frontend.Clicks.faction_button(faction, true)
        
        --get the lord list
        callback(function() 
            local lord_count, lord_list = Common_Actions.get_visible_child_count(Lib.Components.Frontend.lord_list_parent())

            for _, lord in ipairs(lord_list) do
                local button = UIComponent(lord:Find("lord_button"))
                button:SimulateLClick()
                local lord_name = Utilities.prepare_string_for_csv(Lib.Components.Frontend.lord_name_component():GetStateText())
                local lord_race = Utilities.prepare_string_for_csv(Lib.Components.Frontend.race_name_component():GetStateText())
                local lord_id = lord:Id()
                m_lord_list[lord_name] = {lord_race,lord_id}
            end
        end)
        callback(function() 
            if(list_entry_index<#m_faction_list)then
                populate_lord_list(list_entry_index+1)
            else
                Utilities.print("All factions done")
                Lib.Frontend.Clicks.race_select_back_button(true)
            end
        end)
    end)
end

local function faction_setup()
    callback(function() 
        --click continue button
        Lib.Frontend.Clicks.race_select_continue_button(true)
        --open the race list dropdown by clicking it
        Lib.Frontend.Clicks.race_select_button(true)
        --get the race list and store in m_faction_list
        callback(function() 
            local race_count, temp_table = Common_Actions.get_visible_child_count(Lib.Components.Frontend.race_list_parent())
            m_faction_list = temp_table

            for k,v in pairs(m_faction_list) do
                --we use the faction names table to print out the faction lords table in order later
                local faction_name_comp = UIComponent(v:Find("label_context_name"))
                local faction_name = faction_name_comp:GetStateText()
                table.insert(m_faction_names,faction_name)
            end

            populate_lord_list(1) --this 1 is telling the function to start on the first entry of the table
        end)    
    end)
end

function Lib.Frontend.Loaders.generate_tables()
    callback(function()                 
        local faction_count, faction_list = Common_Actions.get_visible_child_count(Lib.Components.Frontend.playable_races_list_parent())

        for _, faction in pairs(faction_list) do
            add_faction_to_race_list(faction)
        end
        faction_setup()

        print_race_table()
        print_lords_table()
    end)
end