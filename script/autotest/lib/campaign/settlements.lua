function Lib.Campaign.Settlements.select_province(province_choice)
    Lib.Campaign.Clicks.provinces_tab(left_click)
    callback(function()
        local province_count, province_list = Common_Actions.get_visible_child_count(Lib.Components.Campaign.your_provinces_parent())
        if(province_count > 0) then
            province_choice = province_choice or math.random(1, province_count)
            local province_id = province_list[province_choice]:Id()
            Lib.Campaign.Clicks.your_provinces_select(province_id)
        else
            Utilities.print("----- INFO: No settlementes owned to select -----")
        end
    end)
end

function Lib.Campaign.Settlements.upgrade_settlement(province_choice, building_choice)
    -- build in empty slots or upgrade existing buildings if available.
    callback(function()
        local settlement_list = Lib.Campaign.Faction_Info.get_settlement_list()
        if(#settlement_list > 0) then
            Lib.Campaign.Settlements.select_province(province_choice)
            Lib.Campaign.Clicks.building_browser()
            Lib.Helpers.Misc.wait(1)
            Lib.Campaign.Settlements.select_building_upgrade(building_choice)
            Lib.Campaign.Clicks.close_building_browser()
        else
            Utilities.print("-----INFO: No settlements owned to upgrade -----")
        end
    end)
end

local function get_building_list(upgradable_only)
    local final_building_list = {}
    local catagory_count, catagory_list = Common_Actions.get_visible_child_count(Lib.Components.Campaign.building_category_parent())
    for ck, cv in pairs(catagory_list) do
        local chain_count, chain_list = Common_Actions.get_visible_child_count(Lib.Components.Campaign.building_chain_parent(cv:Id()))
        for chk, chv in pairs(chain_list) do
            local building_count, building_list = Common_Actions.get_visible_child_count(Lib.Components.Campaign.building_parent(cv:Id(), chv:Id()))
            for bk, bv in pairs(building_list) do
                if(upgradable_only) then
                    local under_construction = Lib.Components.Campaign.building_under_construction(bv:Id())
                    if(bv:Id() ~= "template_slot_entry" and bv:CurrentState() == "normal" and under_construction:Visible() ~= true) then
                        table.insert(final_building_list, bv)
                    end
                else
                    table.insert(final_building_list, bv)
                end
            end
        end
    end
    return final_building_list
end

function Lib.Campaign.Settlements.select_building_upgrade(building_choice)
    callback(function()
        local upgradable_building_list = get_building_list(true)

        if(#upgradable_building_list > 0) then
            building_choice = building_choice or math.random(1, #upgradable_building_list)
            Lib.Campaign.Clicks.upgrade_building(upgradable_building_list[building_choice]:Id())
        else
            Utilities.print("----- INFO: Not purchasing any building upgrades, none available or too expensive -----")
            Utilities.print("...")
        end
    end)
end

-- removes all secondary buildings in the player's main settlement
function Lib.Campaign.Settlements.remove_all_main_settlement_buildings()
    callback(function()
        local player_main_settlement_interface = Lib.Campaign.Faction_Info.get_player_main_settlement_interface()
        local active_slot_list = player_main_settlement_interface:slot_list()
        local active_slot_number = active_slot_list:num_items()
        for i = 0, active_slot_number - 1 do
            local slot = active_slot_list:item_at(i)
            if (slot:name() == "secondary" and slot:has_building()) then
                Utilities.print("Building found, instantly dismantling "..slot:building():name())
                cm:instantly_dismantle_building_in_region(slot)
            end
        end
    end)
end