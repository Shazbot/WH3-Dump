-- Member variable for Turn 1 recruit units test
local m_number_of_recruited_units

function Lib.Campaign.Characters.select_random_lord()
    Lib.Campaign.Clicks.lords_tab()
    callback(function()
        local lord_count, lord_list = Common_Actions.get_visible_child_count(Lib.Components.Campaign.lord_select_parent())
        local lord_choice = lord_list[math.random(1, lord_count)]:Id()
        Lib.Campaign.Clicks.lord_select(lord_choice)
    end)
end

function Lib.Campaign.Characters.select_lord_by_cqi(lord_cqi)

end

local function get_available_recruit_slots()
    local recruitment_capacity = Lib.Components.Campaign.recruitment_capacity_parent()
    if(recruitment_capacity) then
        local slot_count, slot_list = Common_Actions.get_visible_child_count(recruitment_capacity)
        local available_slots = 0
        for k, v in pairs(slot_list) do
            local comp_id = v:Id()
            if(comp_id == "global_available_slot") then
                available_slots = available_slots + 1
            end
        end
        return available_slots
    end
    return 0
end

-- a unit type can be parsed in to search and recruit specific unit types from the available recruitable units.
-- If no unit_type is is given, a random unit is selected instead.
local function recruit_unit(unit_type)
    callback(function()
        -- recruits units for the currently selected army
        local available_slots = get_available_recruit_slots()
        local unit_count, unit_list = Common_Actions.get_visible_child_count(Lib.Components.Campaign.recruitable_unit_parent())

        if(unit_count > 0) then
            local can_afford = false
            for k, v in pairs(unit_list) do
                if(v:CurrentState() == "active") then
                    can_afford = true
                    break
                end
            end

            if(available_slots ~= nil and available_slots >= 1 and can_afford == true) then
                -- the army has free recruitment slots and can afford at least one unit.
                local player_funds = Lib.Campaign.Faction_Info.get_treasury()
                local player_income = Lib.Campaign.Faction_Info.get_income()
                local unit_id
                local unit_searches = 0

				if (unit_type ~= nil) then
					Utilities.print("----- INFO: Unit type: "..unit_type.." given. Searching for avaiable units! -----")
					repeat
						-- searches for the given unit_type in the recruitment panel
						local unit_choice
						for _,unit in pairs(unit_list) do
							local unit_record_id = unit:GetContextObjectId("CcoMainUnitRecord")
							local unit_category_key = common.get_context_value("CcoMainUnitRecord", unit_record_id, "UiUnitGroupContext.Key")
							if string.find(unit_category_key, unit_type) then
								unit_choice = unit
								break
							end
						end
						if unit_choice == nil then
							Utilities.print("----- INFO: No units for the given type: "..unit_type.." were avaiable to recruit! -----")
							return false
						end
						unit_id = unit_choice:Id()
						local unit_cost = Lib.Components.Campaign.recruitable_unit_cost(unit_id):GetStateText()
						local unit_upkeep = Lib.Components.Campaign.recruitable_unit_upkeep(unit_id):GetStateText()
						unit_searches = unit_searches + 1
					until unit_searches >= 100 or (tonumber(unit_cost) < player_funds and tonumber(unit_upkeep) < player_income)
				else
					Utilities.print("----- INFO: No specific unit type given. Searching for random avaiable units! -----")
					repeat
						-- randomly select units until one is found which can be afforded
						local unit_choice = math.random(1, unit_count)
						unit_id = unit_list[unit_choice]:Id()
						local unit_cost = Lib.Components.Campaign.recruitable_unit_cost(unit_id):GetStateText()
						local unit_upkeep = Lib.Components.Campaign.recruitable_unit_upkeep(unit_id):GetStateText()
						unit_searches = unit_searches + 1
					until unit_searches >= 100 or (tonumber(unit_cost) < player_funds and tonumber(unit_upkeep) < player_income)
				end

                if(unit_searches >= 100) then
                    Utilities.print("----- INFO: Couldn't find an affordable unit -----")
                    Utilities.print("...")
                else
                    Lib.Campaign.Clicks.recruitable_unit_select(unit_id)
                end
            else
                Utilities.print("----- INFO: No available recruitment slots or units -----")
            end
        else
            Utilities.print("----- INFO: No units to recruit -----")
        end
    end)
end

-- Recruits units to a given army_cqi. The number of units recruited is random based on the number of avaiable recruitment slots for the turn.  
-- It is also possible to parse a Unit Type (e.g. 'sword', 'spear', etc). The given type will be checked against the available recruitable units.
-- + army_cqi should be an int value.
-- + unit_type should be a string value. (Safe to be a nil value)
function Lib.Campaign.Characters.recruit_units_to_army(army_cqi, unit_type)
    callback(function()
        if(army_cqi ~= nil) then
            Lib.Campaign.Characters.select_lord_by_cqi(army_cqi)
        else
            Lib.Campaign.Characters.select_random_lord()
        end
        Lib.Campaign.Clicks.recruit_units()
    end)
    callback(function()
        local available_slots = get_available_recruit_slots()
        if(available_slots >= 1) then
            local recruitment_count = math.random(1, available_slots)
			Utilities.print("----- INFO: The number of units being recruited = "..recruitment_count)
			m_number_of_recruited_units = recruitment_count
            for i = 1, recruitment_count do
                recruit_unit(unit_type)
            end
        end
        Lib.Campaign.Clicks.recruit_units()
    end)
end

local function recruit_random_lord()
    callback(function()
        local lord_count, lord_list = Common_Actions.get_visible_child_count(Lib.Components.Campaign.recruit_lord_parent())
        if(lord_count > 0) then
            local lord_choice = math.random(1, lord_count)
            local lord_id = lord_list[lord_choice]:Id()
            Lib.Campaign.Clicks.recruit_lord_select(lord_id)
            Lib.Campaign.Clicks.raise_selected_army()
        end
    end)
end

function Lib.Campaign.Characters.recruit_new_army(province_choice)
    local settlement_list = Lib.Campaign.Faction_Info.get_settlement_list()
    if(#settlement_list > 0) then
        local player_income = Lib.Campaign.Faction_Info.get_income()
        if(player_income > 1000) then
            -- we make sure the income is above 1000 before starting a new army so that the PC can also afford to add units to the army.
            Lib.Campaign.Settlements.select_province(province_choice)
            Lib.Campaign.Clicks.recruit_lord()
            recruit_random_lord()
            Common_Actions.trigger_shortcut("ESCAPE")
        else
            Utilities.print("----- INFO: Not raising new army, income too low -----")
            Utilities.print("...")
        end
    else
        Utilities.print("----- INFO: No settlements owened, cannot recruit new armies -----")
        Utilities.print("...")
    end
end

-- Checks all unit cards in the visible army units panel and checks to see if any have the "queued" state.
-- The number of "recruiting" units found is compared against the member variable m_number_of_recruited_units, 
-- which is set in the Lib.Campaign.Characters.recruit_units_to_army() function
function Lib.Campaign.Characters.check_units_are_recruiting()
	callback(function() 
		local units_panel = Lib.Components.Campaign.main_units_panel_card_holder()
		if (units_panel ~= nil) then
			local queued_units = 0
			local unit_count, unit_list = Common_Actions.get_visible_child_count(units_panel)
			for _,v in pairs(unit_list) do
				if (v:CurrentState() == "queued") then
					queued_units = queued_units + 1
				end
			end
			if (queued_units == m_number_of_recruited_units) then
				Utilities.status_print("[Test - Turn 1 Recruit Units - Recruitable] ", "pass")
				Utilities.print("----- SUCCESS! - The correct number of units are recruiting")
			else
				Utilities.status_print("[Test - Turn 1 Recruit Units - Recruitable] ", "fail")
				Utilities.print("----- FAILED! - Units recruited in the unit panel do not match the number of units set for recruitment!")
			end
		end
	end)
end