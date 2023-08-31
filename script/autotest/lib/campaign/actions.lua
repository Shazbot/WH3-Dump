
local m_attack_move_complete = true
local m_fighting_battle = false
local m_battle_fought = false
local m_map_name

local m_force_victory, m_log_terrain, m_battle_duration, m_take_screenshots, m_fight_manual_battle = false, false, nil, false, false

function Lib.Campaign.Actions.get_campaign_battle_fought()
    return m_battle_fought
end

local function repeat_attack_action_if_needed(attacker, battle_duration)
    callback(function()
        Utilities.print("Repeat attack action has been called")
        if(m_battle_fought == false) then
            if(m_attack_move_complete and attacker:action_points_remaining_percent() < 100)then
                Utilities.print("Target not reached, breaking out of loop, will wait until next turn!")
            else
                Utilities.print("Target not reached but we can keep going, calling the attacking function again!")
                Lib.Campaign.Actions.attack_nearest_target(battle_duration)
            end
        end
    end)
end

local function declare_character_movement(attacking_character_cqi)
    Timers_Callbacks.campaign_call(function()
        cm:notify_on_character_movement(
            "attack_movement_check",
            attacking_character_cqi,
            function()
                m_attack_move_complete = false
                Timers_Callbacks.campaign_call(function()
                    cm:notify_on_character_halt(attacking_character_cqi,
                        function()
                            m_attack_move_complete = true
                        end
                    )
                end)
            end
        )
    end)
end

local function wait_for_attack_movement()
    -- loops at a set callback level so that any new callbacks that get called are done at a higher level to this loop, meaning they will execute and then return to this loop
    g_attack_wait_level = g_attack_wait_level or g_current_callback_level + 1
    callback(function()
        if(m_attack_move_complete == false and not m_battle_fought) then
            wait_for_attack_movement()
        else
            g_attack_wait_level = nil
        end
    end, 1000, 0, g_attack_wait_level)
end

local function wait_for_battle()
    -- loops at a set callback level so that any new callbacks that get called are done at a higher level to this loop, meaning they will execute and then return to this loop
    g_battle_wait_level = g_battle_wait_level or g_current_callback_level + 1
    callback(function()
        if(m_fighting_battle == true) then
            wait_for_battle()
        else
            g_battle_wait_level = nil
        end
    end, 10000, 0, g_battle_wait_level)
end

local function wait_for_battle_start()
    callback(function()
        local start_battle = Lib.Components.Battle.start_battle()
        local deployment_start = Lib.Components.Battle.start_deployment()
        local bottom_bar = Lib.Components.Battle.bottom_bar()
        if(deployment_start ~= nil and deployment_start:Visible(true) == true) then
            g_battle_start_wait_level = nil
            Lib.Battle.Clicks.start_deployment()
            Lib.Helpers.Misc.wait(3)
            wait_for_battle_start()
        elseif(start_battle ~= nil and start_battle:Visible(true) == true) then
            g_battle_start_wait_level = nil
            Lib.Battle.Clicks.start_battle()
            load_script_libraries()
        elseif(bottom_bar ~= nil and bottom_bar:Visible(true) == true) then
            g_battle_start_wait_level = nil
            load_script_libraries()
        else
            wait_for_battle_start()
        end
    end, 1000)
end

local function get_distance_between_coords(x1, y1, x2, y2)
    local vert_dis = y2 - y1
    local hor_dis = x2 - x1
    local combined_dis
    local result

    vert_dis = vert_dis * vert_dis
    hor_dis = hor_dis * hor_dis

    combined_dis = vert_dis + hor_dis

    distance = math.sqrt(combined_dis)

    return distance
end

function Lib.Campaign.Actions.attack_character(attacker_cqi, defender_cqi)
    callback(function()
        if(not m_battle_fought)then
            local attacker_obj
            local defender_obj

            Timers_Callbacks.campaign_call(function()
                attacker_obj = cm:get_character_by_cqi(attacker_cqi)
                defender_obj = cm:get_character_by_cqi(defender_cqi)
            end)

            if not is_character(attacker_obj) then
                script_error("ERROR: attack_character() called but supplied attacker [".. tostring(attacker_cqi).."] is not a character")
                return false
            end

            if not is_character(defender_obj) then       
                script_error("ERROR: attack_character() called but supplied defender [".. tostring(defender_cqi).."] is not a character Also, m_battle_fought: "..tostring(m_battle_fought))
                return false
            end

            -- this needs to be called before the attack action so that it starts watching as the character starts moving
            declare_character_movement(attacker_cqi)

            Timers_Callbacks.campaign_call(function()
                cm:attack("character_cqi:"..attacker_cqi, "character_cqi:"..defender_cqi, false, true)
            end)
            end 
    end)

    wait_for_attack_movement()
end

function Lib.Campaign.Actions.attack_region(attacker_cqi, settlement_key)
    callback(function()
        if(not m_battle_fought)then
            local attacker_obj
            local region_obj
            
            Timers_Callbacks.campaign_call(function() 
                attacker_obj = cm:get_character_by_cqi(attacker_cqi)
                region_obj = cm:get_region(settlement_key)
            end)
    
            if not is_character(attacker_obj) then
                script_error("ERROR: attack_region() called but supplied attacker [".. tostring(attacker_cqi).."] is not a character")
                return false
            end
    
            if not is_region(region_obj) then
                script_error("ERROR: attack_region() called but supplied region [".. tostring(settlement_key).."] is not a region")
                return false
            end
    
            -- this needs to be called before the attack action so that it starts watching as the character starts moving
            declare_character_movement(attacker_cqi)
    
            Timers_Callbacks.campaign_call(function()
                cm:attack_region("character_cqi:"..attacker_cqi, settlement_key)
            end)
        end
    end)

    wait_for_attack_movement()
end

function Lib.Campaign.Actions.attack_nearest_target(battle_duration)
    local attacker, defender, target_type
    local faction_armies
    callback(function()
		Lib.Helpers.Test_Cases.set_test_case("Attack Someone", "start", false)
        local faction_int = Lib.Campaign.Actions.get_human_faction(false)
        faction_armies = Lib.Campaign.Actions.get_faction_armies(faction_int)
        if(#faction_armies > 0 and not m_battle_fought)then
            Lib.Campaign.Actions.activate_attack_action_watchers(nil, nil, battle_duration)

            local closest_target = Lib.Campaign.Actions.get_closest_target_to_faction(faction_int)
    
            attacker = closest_target[2]
            defender = closest_target[3]
            target_type = closest_target[1]
    
            if(target_type == "settlement") then
                Lib.Campaign.Actions.attack_region(attacker:cqi(), defender:region():name())
            else
                Lib.Campaign.Actions.attack_character(attacker:cqi(), defender:cqi())
            end
        end

        
    end)

    callback(function()
        if (m_battle_fought == false and #faction_armies>0) then
            repeat_attack_action_if_needed(attacker, battle_duration)
        end
    end)
end

function Lib.Campaign.Actions.get_human_faction(ap_faction)
    local faction_list
    Timers_Callbacks.campaign_call(function()
        faction_list = cm:get_human_factions()
    end)
    ap_faction = ap_faction or false

    for i = 1, #faction_list do
        local faction
        Timers_Callbacks.campaign_call(function()
            faction = cm:get_faction(faction_list[i])
        end)

        return faction
    end
    script_error("ERROR: No human faction found in get_human_faction()")
end

function Lib.Campaign.Actions.get_faction_armies(faction_interface)
    local army_list = {}
    local character_list = faction_interface:character_list()
    local character_count = character_list:num_items()
    for i = 1, character_count do
        local character = character_list:item_at(i - 1)
        local is_military = character:has_military_force()
        if(is_military == true) then
            local military_force = character:military_force()
            local is_perm_garrison = military_force:is_armed_citizenry()
            if(is_perm_garrison == false) then
                table.insert(army_list, character)
            end
        end
    end
    return army_list
end

function Lib.Campaign.Actions.get_army_strength(character_interface)
    local army = character_interface:military_force()
    local strength = army:strength()
    return strength
end

function Lib.Campaign.Actions.get_faction_settlements(faction_interface)
    local settlement_list = {}
    local region_list = faction_interface:region_list()
    local region_count = region_list:num_items()
    for i = 1, region_count do
        local region = region_list:item_at(i - 1)
        local settlement = region:settlement()
        table.insert(settlement_list, settlement)
    end
    return settlement_list
end


function Lib.Campaign.Actions.get_faction_list()
    local faction_list
    Timers_Callbacks.campaign_call(function() 
        faction_list = cm:model():world():faction_list()
    end)
    return faction_list
end

function Lib.Campaign.Actions.get_closest_target_to_faction(attacking_faction_interface)
    local closest_target = {}
    local faction_list = Lib.Campaign.Actions.get_faction_list()
    local atk_army_list = Lib.Campaign.Actions.get_faction_armies(attacking_faction_interface)
    for i = 0, (faction_list:num_items() - 1) do
        local defending_faction_interface = faction_list:item_at(i)
        if(defending_faction_interface:name() ~= attacking_faction_interface:name()) then
            local def_army_list = Lib.Campaign.Actions.get_faction_armies(faction_list:item_at(i))
            local def_settlement_list = Lib.Campaign.Actions.get_faction_settlements(faction_list:item_at(i))
            -- attacker key/variable
            for ak, av in pairs(atk_army_list) do
                local atk_army_x = av:logical_position_x()
                local atk_army_y = av:logical_position_y()
                -- defender key/variable
                for dk, dv in pairs(def_settlement_list) do
                    local def_set_x = dv:logical_position_x()
                    local def_set_y = dv:logical_position_y()
                    local distance = get_distance_between_coords(atk_army_x, atk_army_y, def_set_x, def_set_y)
                    if(closest_target[4] == nil or closest_target[4] > distance) then
                        closest_target = {"settlement", av, dv, distance}
                    end
                end
                -- defender key/variable
                for dk, dv in pairs(def_army_list) do
                    local def_atk_x = dv:logical_position_x()
                    local def_atk_y = dv:logical_position_y()
                    local distance = get_distance_between_coords(atk_army_x, atk_army_y, def_atk_x, def_atk_y)
                    if(closest_target[4] == nil or closest_target[4] > distance) then
                        closest_target = {"army", av, dv, distance}
                    end
                end
            end
        end
    end
    return closest_target
end

function Lib.Campaign.Actions.listen_for_pre_battle_and_fight(force_victory, log_terrain, battle_duration, take_screenshot)
    add_event_listener(
        "PanelOpenedCampaign",
        function(context)
            panel = context.string
            if(panel == "popup_pre_battle") then
                return true
            end
            return false
        end,
        function(context)
            callback(function()
                m_attack_move_complete = true
                m_fighting_battle = true
                Lib.Helpers.Misc.wait(3)
                Lib.Campaign.Clicks.fight_battle()
                Lib.Helpers.Timers.start_timer()
                wait_for_battle_start()
 				Lib.Helpers.Timers.end_timer("Battle Load Time")
                Lib.Helpers.Timers.write_campaign_timers_to_file("Campaign Map to Campaign Battle")
                if(take_screenshot) then
                    Lib.Battle.Misc.log_terrain_screenshot(m_map_name)
                end
                if(log_terrain == true) then
                    Lib.Battle.Misc.log_terrain_html(m_map_name)
                end
                if(force_victory) then
                    wait_for_battle()
                    callback(function()
                        Lib.Battle.Scripted_Events.force_player_victory_on_start()
                    end)
                else
                    if(battle_duration ~= nil) then
                        if(g_graphics_presets_test == true) then
                            Lib.Compat.Downgrading.graphics_presets_stability_test()
                        end
                        Lib.Battle.Misc.concede_battle_after_duration(battle_duration)
                    else
                        wait_for_battle()
                    end
                end
            end)
        end,
        true
    )
end

--called by Lib.Campaign.Actions.listen_for_pre_battle() if autoresolve is desired
local function autoresolve_battle()
    callback(function()
        Lib.Helpers.Misc.wait(2)
        if(m_force_victory) then
            force_player_auto_resolve_victory()
        end
        if (m_log_terrain == true) then
            Lib.Campaign.Clicks.scout_battle_map()
            -- takes a few seconds at least for the terrain log to generate, give it a few seconds then check for loading wheel to be off screen
            Lib.Helpers.Misc.wait(5)
            wait_for_map_preview()
            Lib.Battle.Misc.log_pre_battle_save(m_map_name)
            Lib.Battle.Misc.log_terrain_html(m_map_name)
            if(g_pre_battle_save) then
                -- if a save name for this battle exists, copy it to the terrain location.
                
                g_pre_battle_save = nil
            end
        end
        Lib.Campaign.Clicks.auto_resolve()
    end)
end

--called by Lib.Campaign.Actions.listen_for_pre_battle() if a manual battle is desired
local function manually_fight_battle()
    callback(function()
        m_attack_move_complete = true
        m_fighting_battle = true
        Lib.Helpers.Misc.wait(3)
        Lib.Campaign.Clicks.fight_battle()
        Lib.Helpers.Timers.start_timer()
        wait_for_battle_start()
        Lib.Helpers.Timers.end_timer("Battle Load Time")
        if tostring(g_battle_name) == "" then
            Lib.Helpers.Timers.write_campaign_timers_to_file("Campaign Map to Campaign Battle")
        else
            Lib.Helpers.Timers.write_campaign_timers_to_file("Campaign Map to Campaign Battle ("..tostring(g_battle_name)..")")
        end
        if(m_take_screenshot) then
            Lib.Battle.Misc.log_terrain_screenshot(m_map_name)
        end
        if(m_log_terrain == true) then
            Lib.Battle.Misc.log_terrain_html(m_map_name)
        end
        if(m_force_victory) then
            wait_for_battle()
            callback(function()
                Lib.Battle.Scripted_Events.force_player_victory_on_start()
            end)
        else
            if(m_battle_duration ~= nil) then
                if(g_graphics_presets_test == true) then
                    Lib.Helpers.Compat.graphics_presets_stability_test()
                end
                Lib.Battle.Misc.concede_battle_after_duration(m_battle_duration)
            else
                wait_for_battle()
            end
        end
    end)
end

--a more elegant listener than calling listen_for_pre_battle_and_fight or listen_for_pre_battle_and_auto
--instead, you should call Lib.Campaign.Actions.set_battle_settings() and specify if you want to do a manual or auto resolve
--m_fight_manual_battle is set to false by default so if Lib.Campaign.Actions.set_battle_settings() is not called beforehand then this listener will default to autoresolve
function Lib.Campaign.Actions.listen_for_pre_battle()
    add_event_listener(
        "PanelOpenedCampaign",
        function(context)
            panel = context.string
            if(panel == "popup_pre_battle") then
                return true
            end
            return false
        end,
        function(context)
            callback(function()
				Lib.Helpers.Test_Cases.set_test_case("Attack Someone", "end", false)
                Lib.Helpers.Test_Cases.update_checkpoint_file("Attacking someone on turn "..tostring(g_turn_number))
				Lib.Helpers.Test_Cases.set_test_case("Fight Battle", "start", false)
                if(m_fight_manual_battle)then
                    manually_fight_battle()
                else
                    autoresolve_battle()  
                end
            end)
        end,
        true, true, "ListenForPreBattle"
    )
end

local function wait_for_map_preview()
    callback(function()
        local map_image = Lib.Components.Campaign.map_preview()
        if(map_image == nil or map_image:Visible(true) == false) then
            wait_for_map_preview()
        end
    end, wait.standard)
end

local function force_player_auto_resolve_victory()
    if(g_force_victory_count < 5) then 
        --it is possible to get stuck in a loop where this command shifts to a close defeat and the army isn't completely destroyed
        --and then they are attacked over and over constantly just surviving due to this debug command
        --this can result in a seemingly infinite loop so we put a hard cap on it (currently 5) per turn
        --the count is reset at the end of the players turn (so it can be used 5 times in an end turn cycle) and at the start of the players turn
        g_force_victory_count = g_force_victory_count+1
        local player_faciton_cqi = Lib.Campaign.Actions.get_human_faction(false):command_queue_index()
        Utilities.print("Triggering Shortcut: campaign_debug_tree_win_battle_for_faction "..player_faciton_cqi)
        Common_Actions.trigger_console_command("campaign_debug_tree_win_battle_for_faction "..player_faciton_cqi)
    else
        Utilities.print("Force victory called but it has already been called: "..tostring(g_force_victory_count).." times this turn. So it will not be called again")
    end

end

function Lib.Campaign.Actions.listen_for_pre_battle_and_auto(force_victory, log_terrain)
    force_victory = force_victory or g_force_victory
    add_event_listener(
        "PanelOpenedCampaign",
        function(context)
            panel = context.string
            if(panel == "popup_pre_battle") then
                return true
            end
        end,
        function(context)
            callback(function()
                Lib.Helpers.Misc.wait(2)
                if(force_victory) then
                    force_player_auto_resolve_victory()
                end
                if (log_terrain == true) then
                    Lib.Campaign.Clicks.scout_battle_map()
                    -- takes a few seconds at least for the terrain log to generate, give it a few seconds then check for loading wheel to be off screen
                    Lib.Helpers.Misc.wait(5)
                    wait_for_map_preview()
                    Lib.Battle.Misc.log_pre_battle_save(m_map_name)
                    Lib.Battle.Misc.log_terrain_html(m_map_name)
                    if(g_pre_battle_save) then
                        -- if a save name for this battle exists, copy it to the terrain location.
                        
                        g_pre_battle_save = nil
                    end
                end
                Lib.Campaign.Clicks.auto_resolve()
            end)
        end,
        true
    )
end


function Lib.Campaign.Actions.listen_for_captured_settlement()
    add_event_listener(
        "PanelOpenedCampaign",
        function(context)
            panel = context.string
            if(panel == "settlement_captured") then
                return true
            end
            return false
        end,
        function(context)
            Lib.Helpers.Misc.wait(3)
            callback(function()
                m_attack_move_complete = true
                m_fighting_battle = false
                m_battle_fought = true
                local settlement_captured_count, settlement_captured_list = Common_Actions.get_visible_child_count(Lib.Components.Campaign.captured_settlement_option_parent())
                local choice = math.random(1, settlement_captured_count)
                Lib.Campaign.Clicks.captured_settlement_option(settlement_captured_list[choice]:Id())
            end)
        end,
        true
    )
end

function Lib.Campaign.Actions.listen_for_war_declaration()
    add_event_listener(
        "PanelOpenedCampaign",
        function(context)
            panel = context.string
            if(panel == "move_options") then
                return true
            end
            return false
        end,
        function(context)
            callback(function()
                Lib.Campaign.Clicks.declare_war()
                Lib.Helpers.Misc.wait(3)
                Lib.Campaign.Clicks.accept_declare_war()
                Lib.Campaign.Clicks.confirm_declare_war()
            end)
        end,
        true
    )
end

function Lib.Campaign.Actions.activate_attack_action_watchers(force_victory, log_terrain, battle_duration, take_screenshot)
    callback(function()
        remove_all_listeners()
        --auto_resolve = auto_resolve or true
        Lib.Campaign.Misc.listen_for_unhandled_panels()
        Lib.Campaign.Actions.listen_for_war_declaration()
        Lib.Campaign.Actions.listen_for_captured_settlement()

        Lib.Campaign.Actions.listen_for_pre_battle() --setup the prebattle watcher if its not already setup
        if(g_manual_battles == false)then
            Lib.Campaign.Actions.set_battle_settings(false, force_victory, log_terrain, nil, nil)
        else
            Lib.Campaign.Actions.set_battle_settings(true, force_victory, log_terrain, battle_duration, take_screenshot)
        end

        Lib.Campaign.Misc.listen_for_post_battle_results()
        Lib.Campaign.Misc.listen_for_events_popups()
        Lib.Campaign.Misc.listen_for_lost_general()
    end)
end


function Lib.Campaign.Actions.set_battle_settings(fight_manual_battle,force_victory, log_terrain, battle_duration, take_screenshot)
    Utilities.print("Setting battle settings!")
    m_fight_manual_battle = fight_manual_battle or false
    m_force_victory = force_victory or false 
    m_log_terrain = log_terrain or false 
    m_battle_duration = battle_duration or nil 
    m_take_screenshots = take_screenshot or false
end


function Lib.Campaign.Actions.set_battle_fought()
    m_battle_fought = true
    m_fighting_battle = false
end

function Lib.Campaign.Actions.reset_battle_fought()
    m_battle_fought = false
    m_fighting_battle = false
end

function Lib.Campaign.Actions.get_battle_fought()
	return m_fighting_battle
end

local function teleport_army_to_settlement(character_cqi, settlement_key)
    callback(function()
        local character_int
        Timers_Callbacks.campaign_call(function() character_int = cm:get_character_by_cqi(character_cqi) end)
        local faction_key = character_int:faction():name()

        Utilities.print("----- INFO: Teleporting to: "..tostring(settlement_key).." -----")
        Timers_Callbacks.campaign_call(function()
            local x, y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, settlement_key, false, true)
            cm:teleport_to("character_cqi:"..character_cqi, x, y)
        end)
        Utilities.print("...")  

        callback(function()
            Timers_Callbacks.campaign_call(function()
                cm:position_camera_at_primary_military_force(faction_key)
            end)
        end)
    end, 100)
end

local function teleport_army_to_character(army_leader_cqi, target_character_cqi)
    callback(function()
        local character_int, target_int
        Timers_Callbacks.campaign_call(function() character_int = cm:get_character_by_cqi(army_leader_cqi) end)
        Timers_Callbacks.campaign_call(function() target_int = cm:get_character_by_cqi(target_character_cqi) end)

        Utilities.print("----- INFO: Teleporting: "..army_leader_cqi.." to: "..tostring(target_character_cqi).." -----")

        Timers_Callbacks.campaign_call(function()
            local x, y = cm:find_valid_spawn_location_for_character_from_character(character_int:faction():name(), "character_cqi:"..target_character_cqi, true)
            cm:teleport_to("character_cqi:"..army_leader_cqi, x, y)
        end)

        callback(function()
            Timers_Callbacks.campaign_call(function() cm:position_camera_at_primary_military_force(character_int:faction():name()) end)
        end)
    end, 100)
end

function Lib.Campaign.Actions.TeleportToNamedCharacter(characterName)
    callback(function() 
        target_cqi = common.get_context_value("CcoCampaignRoot", "", "CharacterList.FirstContext(Name==\""..characterName.."\").CQI")
        if(target_cqi == nil)then
            --if we dont find an exact name match, look for a name containing the name given
            --e.g. entering Morghur instead of Morghur the Shadowgave will fail, but this line gives us a chance to catch it
            target_cqi = common.get_context_value("CcoCampaignRoot", "", "CharacterList.FirstContext(StringContains(Name,\""..characterName.."\")).CQI")
        end
        player_faction_leader_cqi = Lib.Campaign.Faction_Info.get_faction_leader_cqi()

        teleport_army_to_character(player_faction_leader_cqi, target_cqi)
    end)
end

function Lib.Campaign.Actions.GiveUnitsToArmy(unitList, characterName)
    callback(function()
        local targetCharacter
        if(characterName == "") then
            targetCharacter = Lib.Campaign.Faction_Info.get_faction_leader_cqi()
        else
            targetCharacter = common.get_context_value("CharacterList.FirstContext(Name==\""..characterName.."\").CQI")
        end
        Timers_Callbacks.campaign_call(function() 
            characterLookupString = cm:char_lookup_str(targetCharacter) 
            for _, unitKey in ipairs(unitList) do
                cm:grant_unit_to_character(characterLookupString, unitKey)
            end
        end)
    end)
end

local function teleport_army_to_location(army_leader_cqi, target_x, target_y)
    callback(function()
        local character_int, target_int
        Timers_Callbacks.campaign_call(function() character_int = cm:get_character_by_cqi(army_leader_cqi) end)
        Timers_Callbacks.campaign_call(function() target_int = cm:get_character_by_cqi(target_character_cqi) end)

        Utilities.print("----- INFO: Attempting to teleport: "..army_leader_cqi.." to X:"..tostring(target_x).." Y: "..tostring(target_y).." -----")

        Timers_Callbacks.campaign_call(function()
            local x, y = cm:find_valid_spawn_location_for_character_from_position(character_int:faction():name(), target_x, target_y, true)
            if(x == -1 and y == -1)then
                Utilities.print("----- INFO: No valid locations can be found at this location. -----")
            else
                Utilities.print("----- INFO: Valid Location found, teleporting: "..army_leader_cqi.." to X:"..tostring(x).." Y: "..tostring(y).." -----")
                cm:teleport_to("character_cqi:"..army_leader_cqi, x, y)
            end
        end)

        callback(function()
            Timers_Callbacks.campaign_call(function() cm:position_camera_at_primary_military_force(character_int:faction():name()) end)
        end)
    end, 0)
end

local function get_non_player_settlement_list()
    local player_faciton_int = Lib.Campaign.Actions.get_human_faction(false)
    local faction_list = Lib.Campaign.Actions.get_faction_list()
    local settlement_list = {}

    for i = 0, (faction_list:num_items() - 1) do
        local faction_int = faction_list:item_at(i)
        if(player_faciton_int:name() ~= faction_int:name()) then
            local settlements = Lib.Campaign.Actions.get_faction_settlements(faction_int)
            for k, v in pairs(settlements) do
                table.insert(settlement_list, v:region():name())
            end
        end
    end

    return settlement_list
end

local function add_siege_unit_to_player_force()
    callback(function()
        Utilities.print("----- INFO: Adding siege unit..")
        Timers_Callbacks.campaign_call(function()
            local faction_leader = Lib.Campaign.Actions.get_human_faction(false):faction_leader()
            cm:grant_unit_to_character(cm:char_lookup_str(faction_leader), "wh3_main_ogr_inf_ironguts_0")
        end)
        Utilities.print("...")
    end)
end

local function replenish_faction_leader_ap()
    callback(function()
        Utilities.print("----- INFO: Replenish faction leader ap..")
        Timers_Callbacks.campaign_call(function()
            local faction_leader = Lib.Campaign.Actions.get_human_faction(false):faction_leader()
            cm:replenish_action_points(cm:char_lookup_str(faction_leader))
        end)
        Utilities.print("...")
    end)
end

-- Uses the CcoCampaignCharacter context object to select and move the camera to the parsed armies postion on the campaign map.
-- + variable army_cqi is an int
function Lib.Campaign.Actions.select_and_zoom_to_army(army_cqi)
	callback(function() 
		Timers_Callbacks.campaign_call(function()
			common.call_context_command("CcoCampaignCharacter", army_cqi, "SelectAndZoom")
		end)
	end)
end

-- Uses the CcoCampaignSettlement context object to select and move the camera to the parsed settlements postion on the campaign map.
-- + variable settlement_cqi is an int
function Lib.Campaign.Actions.select_and_zoom_to_main_settlement(settlement_cqi)
	callback(function()
		Timers_Callbacks.campaign_call(function()
			common.call_context_command("CcoCampaignSettlement", settlement_cqi, "SelectAndZoom")
		end)
	end)
end

-- After selecting and moving the camera to the starting armies position, 2 checks are completed:
-- + A unit count check to make sure the correct number of units are in the army compared to the DAVE database
-- + A confirm unit check to make sure the correct units are in the army when compared to the DAVE database
function Lib.Campaign.Actions.starting_army_checks()
	callback(function() 
		if (g_faction_load_context_table ~= nil) then
			Utilities.print("----- INFO: Checking Players starting army..")
			local player_main_army_cqi = Lib.Campaign.Faction_Info.get_player_main_army_cqi()
			if (player_main_army_cqi ~= nil) then
				Utilities.print("----- INFO: Starting main army found. Moving Camera")
				Lib.Campaign.Actions.select_and_zoom_to_army(player_main_army_cqi)
				Lib.Helpers.Misc.wait(5)
				Lib.Campaign.Misc.count_and_confirm_units_in_starting_army()
			else
				Utilities.print("----- INFO: NO STARTING ARMY FOUND?")
			end
		end
	end)
end

-- Checks the starting income of the players faction both visually on the UI and behind the scenes in the Faction_Script_Interface.
-- // We are expecting a positive number.
function Lib.Campaign.Actions.starting_income_checks()
	callback(function()
		local close_advice = Lib.Components.Campaign.close_advisor()
		if(close_advice ~= nil and close_advice:Visible() == true) then
			Lib.Campaign.Clicks.close_advisor()
		end
		Utilities.print("----- INFO: Checking Players starting income..")
		local human_faction = Lib.Campaign.Actions.get_human_faction()

		Lib.Campaign.Misc.faction_income_check(human_faction)
		Lib.Campaign.Misc.resource_bar_income_UI_check()
		Lib.Campaign.Misc.treasury_panel_income_check()
		Lib.Campaign.Misc.faction_panel_income_check()

		Lib.Campaign.Misc.confirm_displayed_income_values()
	end)
end

-- Checks the tech nodes of the players faction to make sure they belong to that faction. Will then select a random, "Researchable" tech to begin researching.
function Lib.Campaign.Actions.starting_player_factions_technology_tree_checks()
	callback(function() 
		Utilities.print("----- INFO: Checking Player factions technology tree..")
		local player_faction_interface = Lib.Campaign.Actions.get_human_faction()
		if (player_faction_interface ~= nil) then
			Utilities.print("----- INFO: Player faction found")
			Utilities.print("----- Player Faction = "..player_faction_interface:name().." -----")
			Lib.Helpers.Misc.wait(5, true)
            local tech_panel_button = Lib.Components.Campaign.open_tech_panel()
            if(tech_panel_button ~= nil and tech_panel_button:Visible(true))then
                Lib.Campaign.Clicks.open_tech_panel()
                Lib.Campaign.Misc.perform_faction_check_and_select_starting_tech()
                Lib.Campaign.Clicks.close_tech_panel()
                Lib.Helpers.Misc.wait(1, true)
            else
                Utilities.print("Tech panel button not visible. Faction appears to not have access to tech panel on turn one.")
            end
		else
			Utilities.print("----- INFO: PLAYER FACTION NOT FOUND?")
		end
	end)
end

-- Initially checks the players tech tree to see if any builds are required to unlock the first tech node. If so it will build that specific building.
-- Otherwise it will choose a random available building and build it.
function Lib.Campaign.Actions.starting_building_checks()
	callback(function()
		Utilities.print("----- INFO: Checking Players building options..")
		local player_main_settlement_cqi = Lib.Campaign.Faction_Info.get_player_main_settlement_cqi()
		if (player_main_settlement_cqi ~= nil) then
			local player_main_settlement_interface = Lib.Campaign.Faction_Info.get_player_main_settlement_interface()
			Utilities.print("----- INFO: Starting main settlement found. Moving Camera")
			Lib.Campaign.Actions.select_and_zoom_to_main_settlement(player_main_settlement_cqi)
			Lib.Campaign.Clicks.open_tech_panel()
			Lib.Campaign.Misc.check_tech_tree_for_building_requirement()
			Lib.Helpers.Misc.wait(3, true)
			Lib.Campaign.Misc.upgrade_primary_for_tech_required_buildings(player_main_settlement_interface)
			Lib.Campaign.Clicks.building_browser()
			Lib.Helpers.Misc.wait(2, true)
			Lib.Campaign.Misc.find_and_build_tech_required_building_or_random()
            Lib.Campaign.Clicks.close_building_browser()
			callback(function()		
				if (g_technology_unlocked == false) then
					Lib.Campaign.Misc.end_turn_till_building_completed()
					Lib.Campaign.Actions.select_and_zoom_to_main_settlement(player_main_settlement_cqi)
					Lib.Campaign.Misc.check_building_completed(player_main_settlement_interface)
				end
			end)
		end
	end)
end

function Lib.Campaign.Actions.starting_recruit_unit_checks()
	callback(function()
		Utilities.print("----- INFO: Checking players recuitable units...")
		local army_cqi = Lib.Campaign.Faction_Info.get_player_main_army_cqi()
		if (army_cqi ~= nil) then
			Lib.Campaign.Actions.select_and_zoom_to_army(army_cqi)
			Lib.Campaign.Characters.recruit_units_to_army(army_cqi)
			Lib.Campaign.Characters.check_units_are_recruiting()
		end
	end)
end

function Lib.Campaign.Actions.starting_declare_war_checks()
	callback(function()
		Utilities.print("----- INFO: Checking player can declare war...")
		Lib.Campaign.Diplomacy.set_already_warring_factions()
		Lib.Campaign.Diplomacy.select_random_faction_and_declare_war()
		Lib.Campaign.Diplomacy.confirm_faction_is_now_at_war()
	end)
end

function Lib.Campaign.Actions.teleport_to_and_siege_settlements(settlement_choice, log_terrain, take_screenshot, save_game)
    callback(function()
        local player_main_army = Lib.Campaign.Faction_Info.get_player_main_army_cqi()
        local settlement_list = get_non_player_settlement_list()
        g_pre_battle_save = nil

        -- we need to force the army to have siege equipment so that it can siege fortified settlements.
        add_siege_unit_to_player_force()
        
        if(settlement_choice ~= nil) then
            -- Teleport to/siege single settlement
            callback(function()
                if(settlement_choice >= 1 and settlement_choice <= #settlement_list) then
                    local settlement = settlement_list[settlement_choice]
                    m_map_name = settlement
                    teleport_army_to_settlement(player_main_army, settlement)
                    if(save_game == true) then
                        Lib.Menu.Misc.save_campaign()
                    end
                    Lib.Campaign.Actions.activate_attack_action_watchers(true, log_terrain, nil, take_screenshot)
                    Lib.Campaign.Actions.attack_region(player_main_army, settlement)
                    Lib.Helpers.Misc.wait(10)
                else
                    Utilities.print("----- INFO: Supplied settlement: "..settlement_choice.." doesn't exist -----")
                end
            end)
        else
            -- Teleport to/siege all settlements
            callback(function()
                for k, v in pairs(settlement_list) do
                    replenish_faction_leader_ap()
                    callback(function()
                        m_map_name = v
                        teleport_army_to_settlement(player_main_army, v)
                        if(g_manual_battles == false) then
                            -- when auto-resolving, the player tends to lose all units apart from their commander, this ensures they gain a siege unit before each new auto resolve.
                            add_siege_unit_to_player_force()
                            Lib.Helpers.Misc.wait(3)
                        end
                        if(save_game) then
                            Lib.Menu.Misc.save_campaign()
                        end
                        Lib.Campaign.Actions.activate_attack_action_watchers(true, log_terrain, nil, take_screenshot)
                        Lib.Campaign.Actions.attack_region(player_main_army, v)
                        Lib.Helpers.Misc.wait(10)
                    end)
                    callback(function()
                        player_main_army = Lib.Campaign.Faction_Info.get_player_main_army_cqi()
                        settlement_list = get_non_player_settlement_list()
                    end)
                end
            end)
        end
    end)
end

function Lib.Campaign.Actions.deal_with_siege()
    callback(function()
        local player_faction_int = Lib.Campaign.Actions.get_human_faction(false)
        local player_settlements = Lib.Campaign.Actions.get_faction_settlements(player_faction_int)
        for i = 1, #player_settlements do
            local settlement = player_settlements[i]
            local garrison = settlement:region():garrison_residence()
            if (garrison:is_under_siege() == true) then
                Utilities.print("Found a settlement under siege - "..settlement:region():name())
                local garrison_cmdr = cm:get_garrison_commander_of_region(settlement:region())
                local besieging_char = garrison:besieging_character()
                Utilities.print("The garrison commander (cqi: "..garrison_cmdr:cqi()..") is about to engage the enemy (cqi: "..besieging_char:cqi()..")!")
                Lib.Campaign.Actions.attack_character(garrison_cmdr:cqi(), besieging_char:cqi())
                Lib.Helpers.Misc.wait(5)
            end
        end
    end, wait.long)
end

--defaults to the faction leader if no character cqi is provided
function Lib.Campaign.Actions.move_character_to_faction_capital(char_cqi)
    callback(function()
        char_cqi = char_cqi or Lib.Campaign.Faction_Info.get_faction_leader_cqi()
        local faction_capital_int = Lib.Campaign.Faction_Info.get_player_main_settlement_interface()
        local set_pos_x = faction_capital_int:logical_position_x()
        local set_pos_y = faction_capital_int:logical_position_y()
        local character = cm:get_character_by_cqi(char_cqi)
        local char_pos_x = character:logical_position_x()
        local char_pos_y = character:logical_position_y()
        local distance = get_distance_between_coords(set_pos_x, set_pos_y, char_pos_x, char_pos_y)
        if (distance > 0) then
            local settlement_key = faction_capital_int:key()
            Utilities.print(settlement_key)
            cm:join_garrison("character_cqi:"..tostring(char_cqi), settlement_key)
        else
            Utilities.print("Character with cqi "..char_cqi.." is already in the faction capital")
        end
    end)
end

local function create_dummy_army(x, y)
    local spawn_x, spawn_y, dummy_cqi
    Timers_Callbacks.campaign_call(function() spawn_x, spawn_y = cm:find_valid_spawn_location_for_character_from_position("wh2_main_bst_blooded_axe", x, y, false) end)
    Timers_Callbacks.campaign_call(function()
        cm:create_force(
            "wh2_main_bst_blooded_axe", 
            "wh_dlc03_bst_inf_minotaurs_1", 
            "wh3_main_chaos_region_the_blighted_grove", 
            spawn_x, 
            spawn_y, 
            false,
            function(cqi) 
                dummy_cqi = cqi 
                -- stop movement so that it can't flee/move from the desired coords when attacked
                cm:disable_movement_for_character("character_cqi:"..dummy_cqi)
            end
        )
    end)

    return dummy_cqi
end

local function ensure_logical_coords(x, y)
    -- this function is 99.99999% accurate, but still has that minor room for error if anyone can ever find a better solution
    -- real/dis coords tend to be a number like 23.41411231 so on the off chance that both the x and y are 23.0000000 this will return the real coordinates rather than the desired logical ones.
    local convert = false
    x = tonumber(x)
    y = tonumber(y)

    if(x ~= nil and y ~= nil) then
        local temp_x = math.floor(x)
        local temp_y = math.floor(y)

        if(temp_x ~= x) then
            convert = true
        end
        if(temp_y ~= y) then
            convert = true
        end

        if(convert == true) then
            Timers_Callbacks.campaign_call(function() x, y = cm:dis_to_log(x, y) end)
        end

        return x, y
    else
        -- not a complete coordinate so set both to nil
        return nil, nil
    end
end

function Lib.Campaign.Actions.teleport_to_and_fight_dummy_army_at_coords(auto_resolve, log_terrain, take_screenshot, save_game)
    callback(function()
        local coord_list = Functions.get_csv_as_nested_table([[\\casan02\tw\Automation\Results\Terrain_logs\WH3\Coord_Lists\DefaultList.csv]])
        g_pre_battle_save = nil

        for k, row in ipairs(coord_list) do
            local dummy_cqi, character_int
            local coords = {
                x = {},
                y = {}
            }
            local group_name = row[1]
            coords.x[1], coords.y[1] = ensure_logical_coords(row[2], row[3])
            coords.x[2], coords.y[2] = ensure_logical_coords(row[4], row[5])
            coords.x[3], coords.y[3] = ensure_logical_coords(row[6], row[7])
            local player_main_army = Lib.Campaign.Faction_Info.get_player_main_army_cqi()

            for i = 1, 3 do
                if(coords.x[i] ~= nil and coords.y[i] ~= nil) then
                    dummy_cqi = create_dummy_army(coords.x[i], coords.y[i])
                    Lib.Helpers.Misc.wait(3)
                    teleport_army_to_character(player_main_army, dummy_cqi)
                    Lib.Helpers.Misc.wait(3)
                    if(save_game == true) then
                        Lib.Menu.Misc.save_campaign()
                    end
                    Lib.Campaign.Actions.activate_attack_action_watchers(true, log_terrain, nil, take_screenshot)
                    Lib.Campaign.Actions.attack_character(player_main_army, dummy_cqi)
                    Lib.Helpers.Misc.wait(5)
                end
            end
        end
    end)
end

------------------- Primary Build Chain sweep functions and member variables --------------------------

local m_playable_factions_combi = {
    "wh2_dlc14_brt_chevaliers_de_lyonesse",
    "wh_dlc05_wef_wood_elves",
    "wh2_dlc17_bst_malagor",
    "wh_dlc08_nor_norsca",
    "wh2_dlc16_wef_sisters_of_twilight",
    "wh2_dlc11_cst_noctilus",
    "wh2_main_def_naggarond",
    "wh3_dlc20_chs_kholek",
    "wh3_dlc20_chs_vilitch",
    "wh_main_dwf_karak_kadrin",
    "wh3_main_dwf_the_ancestral_throng",
    "wh2_dlc13_emp_golden_order",
    "wh_main_grn_crooked_moon",
    "wh2_dlc11_cst_vampire_coast",
    "wh2_main_hef_yvresse",
    "wh2_dlc13_emp_the_huntmarshals_expedition",
    "wh_main_brt_carcassonne",
    "wh_main_dwf_dwarfs",
    "wh2_dlc11_cst_the_drowned",
    "wh2_dlc11_def_the_blessed_dread",
    "wh3_main_ksl_the_ice_court",
    "wh2_main_lzd_tlaqua",
    "wh3_main_ksl_the_great_orthodoxy",
    "wh2_main_def_har_ganeth",
    "wh_dlc05_wef_argwylon",
    "wh_dlc05_bst_morghur_herd",
    "wh2_main_lzd_hexoatl",
    "wh2_dlc17_bst_taurox",
    "wh2_dlc12_lzd_cult_of_sotek",
    "wh_main_vmp_schwartzhafen",
    "wh2_main_hef_eataine",
    "wh2_dlc09_tmb_lybaras",
    "wh2_main_skv_clan_skryre",
    "wh3_main_tze_oracles_of_tzeentch",
    "wh2_dlc09_tmb_exiles_of_nehek",
    "wh3_main_ksl_ursun_revivalists",
    "wh2_main_skv_clan_pestilens",
    "wh2_main_lzd_last_defenders",
    "wh_main_brt_bordeleaux",
    "wh_dlc08_nor_wintertooth",
    "wh3_dlc20_chs_festus",
    "wh2_main_skv_clan_mors",
    "wh2_dlc09_tmb_followers_of_nagash",
    "wh3_main_dae_daemon_prince",
    "wh_main_grn_greenskins",
    "wh2_main_def_hag_graef",
    "wh3_dlc20_chs_valkia",
    "wh_main_emp_empire",
    "wh_main_grn_orcs_of_the_bloody_hand",
    "wh3_dlc20_chs_sigvald",
    "wh2_dlc15_grn_broken_axe",
    "wh2_main_skv_clan_eshin",
    "wh3_main_sla_seducers_of_slaanesh",
    "wh2_main_hef_avelorn",
    "wh2_dlc15_grn_bonerattlaz",
    "wh3_main_chs_shadow_legion",
    "wh2_dlc16_wef_drycha",
    "wh2_dlc09_skv_clan_rictus",
    "wh_main_brt_bretonnia",
    "wh3_main_ogr_disciples_of_the_maw",
    "wh2_dlc17_dwf_thorek_ironbrow",
    "wh3_main_ogr_goldtooth",
    "wh2_dlc15_hef_imrik",
    "wh3_main_vmp_caravan_of_blue_roses",
    "wh_main_chs_chaos",
    "wh2_main_hef_nagarythe",
    "wh3_main_cth_the_western_provinces",
    "wh_dlc03_bst_beastmen",
    --"wh2_dlc13_lzd_spirits_of_the_jungle", --commented out as Nakari's faction cannot own regions so transfer fails, not deleted in case it's ever needed later!
    "wh2_dlc11_vmp_the_barrow_legion",
    "wh_main_vmp_vampire_counts",
    "wh_main_dwf_karak_izor",
    "wh3_main_cth_the_northern_provinces",
    "wh2_dlc17_lzd_oxyotl",
    "wh3_main_kho_exiles_of_khorne",
    "wh2_main_hef_order_of_loremasters",
    "wh2_main_lzd_itza",
    "wh2_twa03_def_rakarth",
    "wh3_dlc20_chs_azazel",
    "wh3_main_nur_poxmakers_of_nurgle",
    "wh2_main_def_cult_of_pleasure",
    "wh2_dlc09_tmb_khemri",
    "wh3_main_emp_cult_of_sigmar",
    "wh2_dlc11_cst_pirates_of_sartosa",
    "wh2_main_skv_clan_moulder"
}
local m_playable_factions_chaos = {
    "wh3_main_ksl_ursun_revivalists",
    "wh3_main_cth_the_western_provinces",
    "wh3_main_ogr_goldtooth",
    "wh3_dlc20_chs_festus",
    "wh3_main_dae_daemon_prince",
    "wh3_main_cth_the_northern_provinces",
    "wh3_main_tze_oracles_of_tzeentch",
    "wh3_main_ksl_the_ice_court",
    "wh3_main_ksl_the_great_orthodoxy",
    "wh3_main_nur_poxmakers_of_nurgle",
    "wh3_main_sla_seducers_of_slaanesh",
    "wh3_main_ogr_disciples_of_the_maw",
    "wh3_dlc20_chs_azazel",
    "wh3_dlc20_chs_vilitch",
    "wh3_dlc20_chs_valkia",
    "wh3_main_kho_exiles_of_khorne"
}

local m_regions_combi = {
    "wh3_main_combi_region_black_pyramid_of_nagash",
    "wh3_main_combi_region_the_haunted_forest",
    "wh3_main_combi_region_karaz_a_karak",
    "wh3_main_combi_region_castle_drakenhof",
    "wh3_main_combi_region_tor_yvresse",
    "wh3_main_combi_region_kislev",
    "wh3_main_combi_region_gryphon_wood",
    "wh3_main_combi_region_the_witchwood",
    "wh3_main_combi_region_jungles_of_chian",
    "wh3_main_combi_region_waterfall_palace",
    "wh3_main_combi_region_crag_halls_of_findol",
    "wh3_main_combi_region_itza",
    "wh3_main_combi_region_vauls_anvil_loren",
    "wh3_main_combi_region_gaean_vale",
    "wh3_main_combi_region_couronne",
    "wh3_main_combi_region_lahmia",
    "wh3_main_combi_region_great_turtle_isle",
    "wh3_main_combi_region_the_awakening",
    "wh3_main_combi_region_forest_of_gloom",
    "wh3_main_combi_region_hexoatl",
    "wh3_main_combi_region_gronti_mingol",
    "wh3_main_combi_region_the_sacred_pools",
    "wh3_main_combi_region_black_crag",
    "wh3_main_combi_region_hell_pit",
    "wh3_main_combi_region_the_star_tower",
    "wh3_main_combi_region_kings_glade",
    "wh3_main_combi_region_laurelorn_forest",
    "wh3_main_combi_region_miragliano",
    "wh3_main_combi_region_arnheim",
    "wh3_main_combi_region_skavenblight",
    "wh3_main_combi_region_sartosa",
    "wh3_main_combi_region_khemri",
    "wh3_main_combi_region_oreons_camp",
    "wh3_main_combi_region_naggarond",
    "wh3_main_combi_region_karak_eight_peaks",
    "wh3_main_combi_region_lothern",
    "wh3_main_combi_region_altdorf",
    "wh3_main_combi_region_the_galleons_graveyard",
    "wh3_main_combi_region_massif_orcal",
    "wh3_main_combi_region_wei_jin"
}
local m_regions_chaos = {
    "wh3_main_chaos_region_castle_drakenhof",
    "wh3_main_chaos_region_laurelorn_forest",
    "wh3_main_chaos_region_kislev",
    "wh3_main_chaos_region_hell_pit"
}

local m_chosen_faction_table = {}
local m_chosen_region_table = {}

local m_file_location = os.getenv("APPDATA").."\\CA_Autotest\\WH3\\primary_building_chain_test"
local m_file_name = ""
local m_campaign_type = ""


local function get_specific_faction_script_object(faction_key)
    local faction_object
    Timers_Callbacks.campaign_call(function()
        faction_object = cm:get_faction(faction_key)
    end)
    return faction_object
end

local function transfer_region_to_faction(region_key, faction_key)
    Timers_Callbacks.campaign_call(function()
        cm:transfer_region_to_faction(region_key, faction_key)
    end)
end

local function get_primary_building_chain_of_region(region_key)
    local region_object
    local building_chain = "region not found!" --if the region cant be found then the log will include this text to indicate that
    Timers_Callbacks.campaign_call(function()
        region_object = cm:get_region(region_key)
        if(region_object == false)then
            return building_chain
        end
        local settlement = region_object:settlement()
        building_chain = settlement:primary_building_chain()
    end)
    return building_chain
end

--function used primarily for debug purposes, unused in normal running of the script
local function verify_region_owned_by_faction(region_key, faction_key)
    local result = false
    Timers_Callbacks.campaign_call(function()
        result = cm:is_region_owned_by_faction(region_key, faction_key)
    end)
    return result
end

function Lib.Campaign.Actions.setup_test_tables(campaign_type)
    m_campaign_type = campaign_type
    if m_campaign_type == "The Realm of Chaos" then
        m_chosen_faction_table = m_playable_factions_chaos
        m_chosen_region_table = m_regions_chaos
    else
        m_chosen_faction_table = m_playable_factions_combi
        m_chosen_region_table = m_regions_combi
    end
end

local function setup_file_things()
    m_file_name = os.date("building_test_"..tostring(m_campaign_type).."_%d%m%y_%H%M")
    local result = os.execute("mkdir \""..m_file_location.."\"")
    Utilities.print("MKDIR RESULT: "..tostring(result))
    local line_to_write = "Faction Key,Region Key,Primary Building Chain"
    Functions.write_to_document(line_to_write, m_file_location, m_file_name, ".csv", false, true, true)
end

--member variables only used by the function below, placed here rather than at the top of this file
local m_faction_index = 1
local m_failed_to_transfer_count = 0

--a recursive function (that calls itself) rather than a for loop so we can perform actions after each iteration, in this case, optionally saving the game
function Lib.Campaign.Actions.primary_building_chain_loop_recursive(create_a_bunch_of_saves)
    callback(function()
        --early escape once we've tested all factions
        if(m_faction_index > #m_chosen_faction_table)then
            Utilities.print("Primary Build Chain testing complete. Time to exit!")
            return
        end

        --get faction
        local faction_key = m_chosen_faction_table[m_faction_index]

        --transfer regions
        Utilities.print(tostring(m_faction_index).."/"..tostring(#m_chosen_faction_table)..") Beginning primary building chain test on faction: "..tostring(faction_key))
        for _,region_key in ipairs(m_chosen_region_table) do --for each region in the list
            transfer_region_to_faction(region_key, faction_key)
            local region_now_owned_by_faction = verify_region_owned_by_faction(region_key, faction_key)
            local primary_building_chain = get_primary_building_chain_of_region(region_key)
            if(not region_now_owned_by_faction)then
                m_failed_to_transfer_count = m_failed_to_transfer_count+1
                Utilities.print("Failed to transfer region "..tostring(region_key).." to faction "..tostring(faction_key))
                primary_building_chain = primary_building_chain.."_REGION_DID_NOT_TRANSFER_CORRECTLY"
            end
            local line_to_write = faction_key..","..region_key..","..primary_building_chain
            --Utilities.print("HEY! Listen! Here's some stuff: "..tostring(line_to_write).." Is this owned by the faction we want it to be owned by? "..tostring(region_now_owned_by_faction))
            Functions.write_to_document(line_to_write, m_file_location, m_file_name, ".csv", false, true, true)
        end

        --optional save
        if(create_a_bunch_of_saves) then
            Utilities.print("Creating a save.")
            Lib.Menu.Misc.save_campaign(tostring(faction_key).."_")
        end

        --increment index
        m_faction_index = m_faction_index+1

        --recur
        Lib.Campaign.Actions.primary_building_chain_loop_recursive(create_a_bunch_of_saves)
    end)
end

function Lib.Campaign.Actions.begin_primary_building_sweep(create_a_bunch_of_saves)
    callback(function() 
        setup_file_things()

        local current_turn = Lib.Campaign.Misc.get_current_turn_number()
        if(current_turn == 1)then
            Lib.Campaign.Misc.ensure_cutscene_ended()
        end

        Lib.Campaign.Actions.primary_building_chain_loop_recursive(create_a_bunch_of_saves)
    end)
end