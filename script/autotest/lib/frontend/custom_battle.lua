function Lib.Frontend.Custom_Battle.select_army_setup_tab()
    callback(function()
        local army_setup_button = Lib.Components.Frontend.army_setup_tab()
        if(army_setup_button ~= nil and army_setup_button:CurrentState() == "active") then
            Common_Actions.click_component(army_setup_button, "Army Setup Tab (custom battle)")
        end
    end)
end

function Lib.Frontend.Custom_Battle.select_map_setup_tab()
    callback(function()
        local map_setup_button = Lib.Components.Frontend.map_setup_tab()
        if(map_setup_button ~= nil and map_setup_button:CurrentState() == "active") then
            Common_Actions.click_component(Lib.Components.Frontend.map_setup_tab(), "Map Setup Tab (custom battle)")
        end
    end)
end

function Lib.Frontend.Custom_Battle.set_teams(team_1_target, team_2_target)
    callback(function()
        if(team_1_target == nil or team_1_target == "Random") then
            team_1_target = math.random(1, 4)
        end
        if(team_2_target == nil or team_2_target == "Random") then
            team_2_target = math.random(1, 4)
        end
        local team_1_count, team_2_count = Lib.Frontend.Custom_Battle.get_team_counts()
        local team_1_limit = Lib.Frontend.Custom_Battle.team_limit_check(1)
        local team_2_limit = Lib.Frontend.Custom_Battle.team_limit_check(2)
        if(team_1_count < team_1_target and team_1_limit == false) then
            Lib.Frontend.Custom_Battle.add_player(1)
            Lib.Frontend.Custom_Battle.set_teams(team_1_target, team_2_target)
        elseif(team_1_count > team_1_target) then
            Lib.Frontend.Custom_Battle.remove_players_from_team(1)
            Lib.Frontend.Custom_Battle.set_teams(team_1_target, team_2_target)
        elseif(team_2_count < team_2_target and team_2_limit == false) then
            Lib.Frontend.Custom_Battle.add_player(2)
            Lib.Frontend.Custom_Battle.set_teams(team_1_target, team_2_target)
        elseif(team_2_count > team_2_target) then
            Lib.Frontend.Custom_Battle.remove_players_from_team(2)
            Lib.Frontend.Custom_Battle.set_teams(team_1_target, team_2_target)
        end
    end)
end

function Lib.Frontend.Custom_Battle.team_limit_check(team)
    -- checks to see if the team is at it's current limit based off the map type.
    local add_player = Lib.Components.Frontend.add_player(team)
    if(Functions.check_component_visible(add_player, false, true)) then
        return false
    end
    return true
end

function Lib.Frontend.Custom_Battle.add_player(team)
    callback(function()
        local add_player = Lib.Components.Frontend.add_player(team)
        if(Functions.check_component_visible(add_player, false, true)) then
            Common_Actions.click_component(add_player, "Add Player - Team: "..team.." (custom battle)")
        end
    end)
end

function Lib.Frontend.Custom_Battle.remove_players_from_team(team)
    callback(function()
        for player = 1, 8 do
            --Lib.Frontend.Custom_Battle.open_player_options(team, player)
            Lib.Frontend.Custom_Battle.remove_player(team, player)
        end
    end)
end

function Lib.Frontend.Custom_Battle.open_player_options(team, player)
    callback(function()
        local player_slot_options = Lib.Components.Frontend.player_slot_options(team, player)
        if(Functions.check_component_visible(player_slot_options, false, true)) then
            Common_Actions.click_component(player_slot_options, "Player slot options (custom battle)")
        end
    end)
end

function Lib.Frontend.Custom_Battle.remove_player(team, player)
    callback(function()
        local remove_player = Lib.Components.Frontend.remove_player(team, player)
        if(Functions.check_component_visible(remove_player, false, true)) then
            Common_Actions.click_component(remove_player, "Remove Player (custom battle)")
        end
    end)
end

function Lib.Frontend.Custom_Battle.get_team_counts()
    local team_1_count = 0
    local team_2_count = 0
    local team_1_slots = {}
    local team_2_slots = {}
    for team = 1, 2 do
        for player = 1, 8 do
            -- player numbers are global not per team, so someone could be team1 player 7, while someone else could be team2 player8
            local player_icon = Lib.Components.Frontend.custom_battle_select_player(team, player)
            if(Functions.check_component_visible(player_icon)) then
                if(team == 1) then
                    team_1_count = team_1_count + 1
                    table.insert(team_1_slots, player)
                else
                    team_2_count = team_2_count + 1
                    table.insert(team_2_slots, player)
                end
            end
        end
    end
    return team_1_count, team_2_count, team_1_slots, team_2_slots
end

function Lib.Frontend.Custom_Battle.select_player(team, player)
    Common_Actions.click_component(Lib.Components.Frontend.custom_battle_select_player(team, player), "Player: "..team.."_"..player.." (custom battle)")
end

function Lib.Frontend.Custom_Battle.select_player_callbacked(team, player)
    callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.custom_battle_select_player(team, player), "Player: "..team.."_"..player.." (custom battle)")
    end)
end

function Lib.Frontend.Custom_Battle.select_faction(faction_choice, team, player)
    callback(function()
        Lib.Frontend.Custom_Battle.select_player_callbacked(team, player)
        Lib.Frontend.Custom_Battle.set_dropdown_setting(faction_choice, Lib.Components.Frontend.custom_battle_change_faction(), "Player Faction: Team-"..team.." Player-"..player.."")
    end)
end

function Lib.Frontend.Custom_Battle.set_all_player_factions(team_faction_table)
    team_faction_table = team_faction_table or {{},{}}
    Lib.Frontend.Custom_Battle.select_army_setup_tab()
    callback(function()
        local team_1_count, team_2_count, team_1_slots, team_2_slots = Lib.Frontend.Custom_Battle.get_team_counts()
        if(team_1_count > 0) then
            for i = 1, 4 do
                local player_select = Lib.Components.Frontend.custom_battle_select_player(1, i)
                if(player_select ~= nil and player_select:Visible() == true) then
                    Lib.Frontend.Custom_Battle.select_player(1, i)
                    local faction_choice = team_faction_table[1][i] or "Random"
                    Utilities.print("Team 1 Player "..tostring(i).." Faction Choice: "..tostring(faction_choice))
                    Lib.Frontend.Custom_Battle.select_faction(faction_choice, 1, i)
                end
            end
        end
        if(team_2_count > 0) then
            for i = 1, 4 do
                local player_select = Lib.Components.Frontend.custom_battle_select_player(2, i)
                if(player_select ~= nil and player_select:Visible() == true) then
                    Lib.Frontend.Custom_Battle.select_player(2, i)
                    local faction_choice = team_faction_table[2][i] or "Random"
                    Utilities.print("Team 2 Player "..tostring(i).." Faction Choice: "..tostring(faction_choice))
                    Lib.Frontend.Custom_Battle.select_faction(faction_choice, 2, i)
                end
            end
        end
    end)
end

function Lib.Frontend.Custom_Battle.select_battle_type_and_map(type, map)
    Lib.Frontend.Custom_Battle.select_map_setup_tab()
    Lib.Frontend.Custom_Battle.select_battle_type(type)
    Lib.Frontend.Custom_Battle.select_map(map)
end

function Lib.Frontend.Custom_Battle.select_battle_type(map_type)
    Lib.Frontend.Custom_Battle.select_map_setup_tab()
    callback(function()
        local type_count, type_list = Common_Actions.get_visible_child_count(Lib.Components.Frontend.custom_battle_battle_type_parent())
        local type_choice
        for k, v in pairs(type_list) do
            local type_id = v:Id()
            local type_name_component = Lib.Components.Frontend.custom_battle_battle_type_name(type_id)
            local type_name = type_name_component:GetStateText()
            if(map_type ~= nil and type(map_type) == "string") then
                if(type_name == map_type) then
                    g_battle_settings = g_battle_settings or {}
					g_battle_settings["Map Type"] = type_name
                    Common_Actions.click_component(v, "Map Type: "..type_name.." (custom battle lobby)")
                    Lib.Helpers.Misc.confirm_popup()
                    return
                end
            end
        end
        if(type(map_type) == "number" and map_type <= type_count) then
            type_choice = map_type
        else
            type_choice = math.random(1, type_count)
        end
        local type_name_component = Lib.Components.Frontend.custom_battle_battle_type_name(type_list[type_choice]:Id())
		local type_name = type_name_component:GetStateText()
		g_battle_settings = g_battle_settings or {}
        g_battle_settings["Map Type"] = type_name
        Common_Actions.click_component(type_list[type_choice],  "Map Type: "..type_name.." (custom battle lobby)")
        Lib.Helpers.Misc.confirm_popup()
    end)
end

function Lib.Frontend.Custom_Battle.find_map_in_list_from_name(desired_map_name)
    Utilities.print("Finding map in list from name: "..tostring(desired_map_name))
    local _, map_list = Common_Actions.get_visible_child_count(Lib.Components.Frontend.custom_battle_map_parent())
    for index, map_component in ipairs(map_list)do
        local map_id = map_component:Id()
        local map_name_component = Lib.Components.Frontend.custom_battle_map_name(map_id)
        local map_name = map_name_component:GetStateText()
        if(map_name == desired_map_name)then
            Utilities.print("MAP FOUND! Index: "..tostring(index))
            return index
        end
    end
end

function Lib.Frontend.Custom_Battle.select_map(map)
    Lib.Frontend.Custom_Battle.select_map_setup_tab()
    callback(function()
        if(type(map) == "string")then
            map = Lib.Frontend.Custom_Battle.find_map_in_list_from_name(map)
        end
        local map_count, map_list = Common_Actions.get_visible_child_count(Lib.Components.Frontend.custom_battle_map_parent())
        local map_choice = map or math.random(1, #map_list)
        local map_id = map_list[map_choice]:Id()
        g_battle_settings = g_battle_settings or {}
        g_battle_settings["Map"] = map_id
        local map_name_component = Lib.Components.Frontend.custom_battle_map_name(map_id)
        g_map_name = map_name_component:GetStateText()
        g_current_map = map_id
        Common_Actions.click_component(Lib.Components.Frontend.custom_battle_map(map_id), "Map select: "..map_id.." (custom battle) (map choice: "..tostring(map_choice)..")")
    end)
end

function Lib.Frontend.Custom_Battle.autogenerate_army()
    Lib.Frontend.Custom_Battle.select_army_setup_tab()
    Common_Actions.click_component(Lib.Components.Frontend.custom_battle_autogenerate(), "Autogenerate army (custom battle)")
    local autogenerate_reinforcements = Lib.Components.Frontend.custom_battle_autogenerate_reinforcing_army()
    if(g_battle_settings["Map Type"] == "Survival Battle" and autogenerate_reinforcements:Visible(true) == true) then
        Common_Actions.click_component(Lib.Components.Frontend.custom_battle_autogenerate_reinforcing_army(), "Autogenerate reinforcing army (custom battle)")
    end
end

function Lib.Frontend.Custom_Battle.autogenerate_all_armies()
    callback(function()
        for team = 1, 2 do
            for player = 1, 8 do
                local player_icon = Lib.Components.Frontend.custom_battle_select_player(team, player)
                if(Functions.check_component_visible(player_icon)) then
                    Lib.Frontend.Custom_Battle.select_player(team, player)
                    Lib.Frontend.Custom_Battle.autogenerate_army()
                    Lib.Frontend.Custom_Battle.autogenerate_army()
                    Lib.Frontend.Custom_Battle.autogenerate_army()
                end
            end
        end
    end)
end

function Lib.Frontend.Custom_Battle.set_battle_settings(difficulty, time, funds, tower_level, realism, large_armies, unit_scale)
    callback(function()
        Lib.Frontend.Custom_Battle.select_map_setup_tab()
        Lib.Frontend.Custom_Battle.set_difficulty_setting(difficulty)
        Lib.Frontend.Custom_Battle.set_time_dropdown(time)
        Lib.Frontend.Custom_Battle.set_dropdown_setting(funds, Lib.Components.Frontend.battle_funds(), "Funds")
        Lib.Frontend.Custom_Battle.set_tower_level(tower_level)
        Lib.Frontend.Custom_Battle.set_toggle_setting(Lib.Components.Frontend.battle_realism(), realism, "Realism")
        Lib.Frontend.Custom_Battle.set_toggle_setting(Lib.Components.Frontend.battle_unit_caps(), false, "Unit Caps")
        Lib.Frontend.Custom_Battle.set_large_armies(large_armies)
        Lib.Frontend.Custom_Battle.set_dropdown_setting(unit_scale, Lib.Components.Frontend.unit_scale(), "Unit Scale")
    end)
end

function Lib.Frontend.Custom_Battle.set_difficulty_setting(difficulty)
    callback(function()
        if(g_battle_settings["Map Type"] ~= "Survival Battle") then
            Lib.Frontend.Custom_Battle.set_dropdown_setting(difficulty, Lib.Components.Frontend.battle_difficulty(), "Battle Difficulty")
        end
    end)
end

function Lib.Frontend.Custom_Battle.set_time_dropdown(time)
    callback(function()
        if(g_battle_settings["Map Type"] ~= "Survival Battle") then
            local time_dropdown = Lib.Components.Frontend.battle_time_limit()
            if(time_dropdown ~= nil and time_dropdown:Visible() == true) then
                Lib.Frontend.Custom_Battle.set_dropdown_setting(time, time_dropdown, "Time Limit")
            end
        end
    end)
end

function Lib.Frontend.Custom_Battle.set_battle_weather(weather)
    callback(function()
        if(g_battle_settings["Time of Day"] == "Day") then
            Lib.Frontend.Custom_Battle.set_dropdown_setting(weather, Lib.Components.Frontend.battle_weather(), "Weather")
        end
    end)
end

function Lib.Frontend.Custom_Battle.set_tower_level(tower_level)
    callback(function()
        if(g_battle_settings["Map Type"] == "Siege Battle") then
            Lib.Frontend.Custom_Battle.set_dropdown_setting(tower_level, Lib.Components.Frontend.tower_level(), "Tower Level")
        end
    end)
end



function Lib.Frontend.Custom_Battle.set_large_armies(large_armies)
    callback(function()
        if (g_battle_settings["Map Type"] ~= "Survival Battle") then
            local team_1_count, team_2_count = Lib.Frontend.Custom_Battle.get_team_counts()
            if(team_1_count + team_2_count <= 4) then
                -- large armies can't be selected with more than 4 players
                Lib.Frontend.Custom_Battle.set_toggle_setting(Lib.Components.Frontend.battle_large_armies(), large_armies, "Large Armies")
            end
        end
    end)
end

function Lib.Frontend.Custom_Battle.set_dropdown_setting(setting, dropdown, table_entry)
    Common_Actions.open_dropdown(dropdown)
    Lib.Helpers.Misc.wait(1)
    callback(function()
        g_battle_settings = g_battle_settings or {}
		if(table_entry ~= nil) then
			local option_choice
			if(type(setting) == "string" and setting ~= "Random") then
				Utilities.print("STRING MATCH: ".. setting)
				option_choice = Common_Actions.choose_dropdown_option_from_string(dropdown, setting)
            else
				option_choice = Common_Actions.choose_dropdown_option(dropdown, setting)
            end
			if(option_choice ~= nil and option_choice:Visible() == true) then
				g_battle_settings[table_entry] = Common_Actions.get_dropdown_text(dropdown, option_choice:Id())
				Common_Actions.click_dropdown_option(dropdown, option_choice)
			else
				Utilities.print("dropdown '"..table_entry.."' isn't active... FAILED!")
				Utilities.print("...")
			end
		else
			Utilities.print("table entry not set... FAILED!")
			Utilities.print("...")
		end
	end)
end

function Lib.Frontend.Custom_Battle.set_toggle_setting(setting, turn_on, table_entry)
    callback(function()
        g_battle_settings = g_battle_settings or {}
		-- Turns an option on or off depending on input, if there is no input it just clicks the button.
		local setting_state = setting:CurrentState()
        -- Adds the state of the button to the battle settings array for printouts.
        if(turn_on == nil or turn_on == "Random") then
			checkbox_choice = math.random(1, 2)
			if(checkbox_choice == 1) then
				turn_on = true
			else
				turn_on = false
			end
		end
		if(turn_on == true) then
            g_battle_settings[table_entry] = "On"
            if(setting_state == "active") then
                Common_Actions.toggle_checkbox(setting, true)
            end
		elseif(turn_on == false) then
            g_battle_settings[table_entry] = "Off"
            if(setting_state == "selected") then
                Common_Actions.toggle_checkbox(setting, false)
            end
		end
	end)
end

function Lib.Frontend.Custom_Battle.print_battle_settings()
	callback(function()
		local settings_file_name = os.date("%d%m%y_%H%M_battle_settings")
		local units_file_name = os.date("%d%m%y_%H%M_army_loadouts")
		local team1_count, team2_count = Lib.Frontend.Custom_Battle.get_team_counts()
		g_battle_settings["TEAMS"] = team1_count.." Vs "..team2_count
		Utilities.print("----- INFO: Launching Battle -----")
        Common_Actions.print_table(g_battle_settings)
        Common_Actions.print_table_to_file(g_battle_settings, settings_file_name, true)
		Lib.Frontend.Custom_Battle.print_all_selected_units(units_file_name)
	end)
end

function Lib.Frontend.Custom_Battle.print_all_selected_units(units_file_name)
    Lib.Frontend.Custom_Battle.select_army_setup_tab()
	local army_table = {}
	Common_Actions.print_table_to_file(army_table, units_file_name, true)
	for alliance = 1, 2 do
		for player = 1, 8 do
			callback(function()
				local player_icon = Lib.Components.Frontend.custom_battle_select_player(alliance, player)
				if(player_icon ~= nil and player_icon:Visible() == true) then
                    Common_Actions.click_component(Lib.Components.Frontend.custom_battle_select_player(alliance, player), "Player icon: "..alliance.."_"..player.." (battle lobby)")
                    Lib.Helpers.Misc.wait(1)
				end
			end)
			callback(function()
				local player_icon = Lib.Components.Frontend.custom_battle_select_player(alliance, player)
				if(player_icon ~= nil and player_icon:Visible() == true) then
                    unit_names_table = Lib.Frontend.Custom_Battle.generate_unit_name_table()
                    if(unit_names_table ~= nil and #unit_names_table > 0) then
					    Common_Actions.print_table(unit_names_table, true)
					    Common_Actions.print_table_to_file(unit_names_table, units_file_name, false, "team_"..alliance.."_player_"..player, true)
                    else
                        Utilities.print("----- No Units in selected army... FAILED!  -----")
                    end
                end
			end)
		end
	end
end

function Lib.Frontend.Custom_Battle.generate_unit_name_table()
    -- requires a table of the unit_components.
    local unit_count, unit_table = Common_Actions.get_visible_child_count(Lib.Components.Frontend.custom_battle_unit_parent())
    local unit_tooltip_list = {}
    local unit_tooltip
    if(unit_count > 0) then
        local army_name_table = {}
        for k, v in pairs(unit_table) do
            unit_id = v:Id()
            v:SimulateMouseOn()
            unit_tooltip = v:GetTooltipText()
            unit_name = string.match(unit_tooltip, "(.*)\n(.*)\n(.*)")
			table.insert(army_name_table, unit_name)
			v:SimulateMouseOff()
        end
        return army_name_table
    else
        Utilities.print("----- INFO: No army table found -----")
        return
    end
end

local m_map_name_table = {}
local m_map_count = 0
local function create_and_write_to_map_name_file()
    callback(function()
        local appdata = os.getenv("APPDATA")
        local location = appdata.."\\CA_Autotest\\WH3\\map_name_logs"
        os.execute("mkdir \""..location.."\"")
        local file_name = os.date("map_text_list_%d%m%y_%H%M")
        Functions.write_to_document("MAP COUNT: "..tostring(m_map_count).."\n", location, file_name, ".txt", false, true)
        for k,v in ipairs(m_map_name_table) do
            Functions.write_to_document(v, location, file_name, ".txt", false, true)
        end
        Utilities.print("All map names logged to file!")
    end)
end

function Lib.Frontend.Custom_Battle.generate_map_list(wh3_maps_only, set_dressed_only, map_type_name)
    g_map_type_counts = {}
    Lib.Frontend.Clicks.battles_tab()
    Lib.Frontend.Clicks.custom_battle()
    Lib.Frontend.Custom_Battle.select_map_setup_tab()
    callback(function()
        local type_count, type_list = Common_Actions.get_visible_child_count(Lib.Components.Frontend.custom_battle_battle_type_parent())
        for i = 1, type_count do
            Lib.Frontend.Custom_Battle.select_battle_type(i)
            Lib.Frontend.Custom_Battle.log_map_type_map_count(i, wh3_maps_only, set_dressed_only, map_type_name)
        end
    end)

    if(g_log_map_names_to_text_file)then
        create_and_write_to_map_name_file()
    end

    Lib.Frontend.Clicks.return_to_main_menu()
end

function Lib.Frontend.Custom_Battle.log_map_type_map_count(map_type, wh3_maps_only, set_dressed_only, map_type_name)
    callback(function()
        local type_count, type_list = Common_Actions.get_visible_child_count(Lib.Components.Frontend.custom_battle_battle_type_parent())
        local map_count, map_list = Common_Actions.get_visible_child_count(Lib.Components.Frontend.custom_battle_map_parent())
        local type_text_component = Lib.Components.Frontend.custom_battle_battle_type_name(type_list[map_type]:Id())
        local type_text = type_text_component:GetStateText()
        local filtered_map_list = {}
        
        local log_map = (g_log_map_names_to_text_file and map_type_name == "All" or map_type_name == type_text)

        
        if(log_map)then
            table.insert(m_map_name_table,"\n"..type_text.."\n")
        end
        
        for k, v in pairs(map_list) do
            local add_map = true
            local map_id = v:Id()
        
            if(string.find(map_id, "test") ~= nil) then
                -- Don't add test maps
                add_map = false
            end

            if(wh3_maps_only == true) then
                if(string.find(map_id, "wh3") == nil) then
                    -- this isn't a wh3 map
                    add_map = false
                end
            end

            if(set_dressed_only == true) then
                for k, v in pairs(g_dressed_maps) do
                    add_map = false
                    if(map_id == v) then
                        -- include maps that we've indicated in g_dressed_maps
                        add_map = true
                        break
                    end
                end
            end

            --this logging functionality was primarily requested by audio designers to get the in game map name and audio environment
            --however it can obviously still be used by anyone who needs all in game map names from custom battle
            if(add_map == true) then
                table.insert(filtered_map_list, k)

                if(log_map)then
                    local name_comp = UIComponent(v:Find("label_context_name"))
                    local map_name = name_comp:GetStateText()
                    local id = string.match(v:Id(), "CcoCustomBattleMapbattle_preset_(.*)")
                    local audio_env = common.get_context_value("CcoBattleRecord", id, "EnvironmentAudioType")
                    
                    if(audio_env == nil or audio_env == "")then
                        audio_env = "FIX ME!!" --requested by audio designer
                    end
                    
                    table.insert(m_map_name_table, map_name.." | "..tostring(audio_env))
                    m_map_count = m_map_count+1
                end
            end
        end

		table.insert(g_map_type_counts, {type_text, map_list, filtered_map_list})
    end)
end

function Lib.Frontend.Custom_Battle.start_custom_battle()
    callback(function() 
        start_button = Lib.Components.Frontend.custom_battle_start()
        if(start_button ~= nil and start_button:CurrentState() == "active") then
            -- Lua script are paused during a transition so in order to test alt-tab during a loading screen, we start a python script does that for us.
            -- The script immediately alt-tabs back to the game, then after a set period it alt-tabs out of the game and back in.
            if g_compat_sweep then
                callback(function()
                    io.popen('start cmd /c py -u C:\\compat_sweep\\app_switch.py \"Total War: WARHAMMER 3\"', 'r')
                    Lib.Helpers.Misc.wait(5)
                end)
            end
            g_battle_launched = true
            Lib.Frontend.Clicks.custom_battle_start()
            Lib.Helpers.Timers.start_timer()
        else
            -- unable to start the battle, return to frontend.
            g_battle_launched = false
            Utilities.print("----- Unable to load current battle... FAILED!  -----")
            Lib.Helpers.Misc.wait(3000)
            Lib.Frontend.Clicks.return_to_main_menu()
        end
    end)
end



--------------------------------------------------------
--Battle Ability Testing functions
--------------------------------------------------------
local m_number_of_units_per_battle = 0
local m_lord_count = 0
local m_unit_count = 0

--we need to get the number of lords and the number of non-lord units
--we can then use these numbers to work out how many battles we need to do (one per lord)
--and how many units we need to take in each battle to ensure we cover all units in the number of battles
local function get_lord_and_unit_count()
    local unit_count, lord_count = 0,0
    local _, unit_parent_list = Common_Actions.get_visible_child_count(Lib.Components.Frontend.custom_battle_unit_list_parent())
    for _,unit_parent in pairs(unit_parent_list) do
        local unit_list_component = UIComponent(unit_parent:Find("unit_list"))
        local header_component = UIComponent(unit_parent:Find("row_header"))
        local unit_group_name = UIComponent(header_component:Find("label_group_name")):GetStateText()
        local temp_unit_count, _ = Common_Actions.get_visible_child_count(unit_list_component)
        if(unit_group_name == "Lords")then
            lord_count = lord_count+temp_unit_count
        else
            unit_count = unit_count+temp_unit_count
        end
    end

    m_number_of_units_per_battle = math.ceil(unit_count/lord_count)

    Utilities.print("Lord Count: "..tostring(lord_count))
    Utilities.print("Unit Count: "..tostring(unit_count))
    Utilities.print("Number of units required per lord: "..tostring(m_number_of_units_per_battle))

    if(m_number_of_units_per_battle > 19)then
        --will be properly handled in a future version of this script, as far as I can see this situation is currently impossible
        Utilities.print("Failed! - The amount of units required per lord is over 19 which means not all units will get tested! This is bad!")
    end
    m_lord_count = lord_count
    m_unit_count = unit_count
end

--selects the first army of the first alliance which is always (or should be...) the players army
function Lib.Frontend.Custom_Battle.get_factions_unit_count()
    Lib.Frontend.Clicks.custom_battle_select_player(1, 1)
    callback(function()
        get_lord_and_unit_count()
    end)
end

local m_units_tested = {}

local function select_next_valid_unit()
    callback(function()
        local units_added = 0
        local lord_added = false
        local _, unit_parent_list = Common_Actions.get_visible_child_count(Lib.Components.Frontend.custom_battle_unit_list_parent())
        
        --loop through the unit types
        for _,unit_parent in ipairs(unit_parent_list) do
            if(units_added >= m_number_of_units_per_battle)then
                --early escape
                break
            end
            
            local header_component = UIComponent(unit_parent:Find("row_header"))
            local unit_group_name = UIComponent(header_component:Find("label_group_name")):GetStateText()
            
            local unit_list_component = UIComponent(unit_parent:Find("unit_list"))
            local _, unit_list = Common_Actions.get_visible_child_count(unit_list_component)

            --loop through the units of this unit type
            for _, unit in ipairs(unit_list) do
                local unit_card = UIComponent(unit:Find("unit_card"))
                local unit_key = unit_card:GetContextObjectId("CcoMainUnitRecord")

                if(not m_units_tested[unit_key] and units_added < m_number_of_units_per_battle)then --if this unit hasnt been added before and there are more units to be added
                    local unit_can_be_added = true
                    local increment_amount = 1

                    --we only want one lord to be added each time so as soon as we find one to be added we stop checking/adding others
                    if(unit_group_name == "Lords")then 
                        if(lord_added == false)then
                            lord_added = true
                            increment_amount = 0 --we want to add the lord and add it to the table, but we don't want it to count as one of the units added number as that excludes lords 
                        else
                            unit_can_be_added = false
                        end
                    end

                    --add the unit if it can be added
                    if(unit_can_be_added)then
                        Utilities.print("Adding unit: "..tostring(unit_key))
                        m_units_tested[unit_key] = true
                        units_added = units_added+increment_amount
                        unit_card:SimulateDblLClick()
                    end
                elseif(units_added >= m_number_of_units_per_battle)then
                    --if we are at the required amount of units then break out of this loop (there's another break in the outer loop)
                    break
                end
            end
        end
        Utilities.print("Sufficient Units added! Units added: "..tostring(units_added))
    end)
end

local function activate_bedsat_and_start_battle()
    callback(function()
        Lib.Frontend.Custom_Battle.start_custom_battle()
        --activates console command to overwrite the (empty) lua file that loads when the battle starts to be our BEDSAT script
        Common_Actions.trigger_console_command("lua_help_file \"script/autotest/common/bedsat.lua\"")
        Lib.Battle.Misc.ensure_battle_started()
        Lib.Battle.Misc.concede_battle_when_ended(true) --once the battle starts we just keep waiting for the battle over pop up       
    end)
end

--selects the players army
--selects a lord and appropriate number of units then activates the BEDSAT and starts the battle
--once the battle ends the script returns to the custom battle panel and the next iteration of the loop kicks in
function Lib.Frontend.Custom_Battle.test_all_units_and_lords()
    callback(function()
        Lib.Frontend.Custom_Battle.select_player(1, 1)
    end)
    callback(function()
        for i = 1, m_lord_count do --one battle per lord
            callback(function()
                Lib.Frontend.Clicks.custom_battle_clear_army()
            end)
            callback(function()
                select_next_valid_unit()
            end)
            callback(function()
                Lib.Helpers.Misc.wait(2)
                activate_bedsat_and_start_battle()
            end)
        end
    end)
end

function Lib.Frontend.Custom_Battle.set_enemy_faction_and_units()
    --for now this just uses the games auto generation to get some enemies to test on
    --in the future there could be a hard coded list of units so we ensure we always have suitable test cases (.e.g one flying unit, one single entity unit, etc)
    callback(function()
        Lib.Frontend.Custom_Battle.select_player(2, 1)
    end)
    callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.custom_battle_autogenerate(), "Autogenerate army (custom battle)")
    end)
end

--sets some basic battle settings (funds, map etc)
--sets player and enemy faction
--autogenerates enemy army
--selects appropriate player units and starts the battle
function Lib.Frontend.Custom_Battle.setup_and_start_bedsat_battles(player_faction)
    Lib.Frontend.Loaders.setup_battle_settings_for_bedsat()
    Lib.Frontend.Custom_Battle.select_faction(player_faction, 1, 1)

    Lib.Frontend.Custom_Battle.select_faction("Kislev", 2, 1)
    Lib.Frontend.Custom_Battle.set_enemy_faction_and_units()

    Lib.Frontend.Custom_Battle.get_factions_unit_count()
    Lib.Frontend.Custom_Battle.test_all_units_and_lords()
    Lib.Frontend.Clicks.return_to_main_menu()
end