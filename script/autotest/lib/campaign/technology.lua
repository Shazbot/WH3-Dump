function Lib.Campaign.Technology.open_technology()
    callback(function()
        local tech_panel = Lib.Components.Campaign.technology_panel()
        if(tech_panel == nil or tech_panel:Visible() == false) then
            Lib.Campaign.Clicks.open_tech_panel()
        end
    end)
end

local function get_random_technology_id()
    local tech_count, tech_list = Common_Actions.get_visible_child_count(Lib.Components.Campaign.tech_parent())
    local available_tech = {}
    for k, v in pairs(tech_list) do
        local tech = Lib.Components.Campaign.select_tech(v:Id())
        if(tech ~= nil and tech:CurrentState() == "available") then
            table.insert(available_tech, v:Id())
        end
    end

    local tech_choice = available_tech[math.random(1, #available_tech)]
    return tech_choice
end

function Lib.Campaign.Technology.research_technology(tech_choice)
    callback(function()
        local tech_available = Lib.Campaign.Faction_Info.get_tech_available()
        if(tech_available == true) then
			Lib.Helpers.Test_Cases.set_test_case("Research Technology", "start", false)
            Lib.Campaign.Technology.open_technology()
            callback(function()
                tech_choice = tech_choice or get_random_technology_id()
                Lib.Campaign.Clicks.select_tech(tech_choice) --eventually add a way to detect that tech research was actually started rather than assuming it worked
				Lib.Helpers.Test_Cases.set_test_case("Research Technology", "end", false)
                Lib.Helpers.Test_Cases.update_checkpoint_file("Tech researched on turn "..tostring(g_turn_number))
                Lib.Campaign.Clicks.close_tech_panel()
            end)
        end
    end)
end