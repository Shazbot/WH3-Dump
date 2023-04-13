require "data.script.autotest.lib.all"

Lib.Helpers.Init.script_name("WH3 DLC Mask Testing Script")
Lib.Frontend.Misc.ensure_frontend_loaded()
 
local factions_to_check = {}
local debug_mode = false

callback(function()
--#region Local Functions
    local function check_faction_unlocked(faction_object)
        local is_unlocked = false
        local dlc_requirements_list_size = faction_object:Call("OwnershipProductRequirementList.Size")
        
        if debug_mode then local name = faction_object:Call("Name") print("Faction: "..name.." List size is: "..tostring(dlc_requirements_list_size)) end

        if dlc_requirements_list_size == 0 then
            --if the dlc size is 0 then it should be a base game faction, we always want to test these
            --this will also catch AI base game factions but those should get filtered out later on.
            return true
        end

        --go through each record of the dlc requirements list (each record contains another list of the required DLC as objects)
        for i=0, dlc_requirements_list_size-1 do
            local dlc_records_list_size = faction_object:Call(string.format("OwnershipProductRequirementList.At(%d).OwnershipProductRecordList.Size", i))
            local all_owned = true

            --for each DLC object in this record, check if the IsOwned flag is true/false
            --if all the DLC objects have IsOwned = true then the user owns all DLC required for this faction
            for n=0, dlc_records_list_size-1 do
                local is_owned = faction_object:Call(string.format("OwnershipProductRequirementList.At(%d).OwnershipProductRecordList.At(%d).IsOwned", i,n))
                if(is_owned == false) then
                    all_owned = false
                end
            end

            --all_owned is only true if all the dlc objects in this list have IsOwned = true
            if(all_owned == true) then
                --if all_owned is true then we dont need to check the rest of the records, we've established the player has unlocked this faction
                is_unlocked = true
                break                
            end
        end 

        return is_unlocked
    end
--#endregion

    -- script "starts" here
    local faction_list_size = common.get_context_value("DatabaseRecords(\"CcoFactionRecord\").Size")

    for i=0, faction_list_size-1 do
        local faction_object = common.get_context_value(string.format("DatabaseRecords(\"CcoFactionRecord\").At(%d)", i))
        local is_owned = check_faction_unlocked(faction_object)

        if is_owned then
            local is_playable = faction_object:Call("MechanicList.Size") > 0 --any playable faction has a MechanicList, if its size is 0, its an AI faction
            if(is_playable) then
                local name = faction_object:Call("Name")
                local key = faction_object:Call("Key")
                if debug_mode then print(string.format("%d) The faction %s is unlocked? %s, Key: %s", i, name, tostring(is_owned), key)) end
    
                table.insert(factions_to_check, faction_object)
            else
                local name = faction_object:Call("Name")
                if debug_mode then print("Faction is not playable, skipping: "..tostring(name)) end
            end
        end
    end

    print("There are this many factions in the table: "..tostring(#factions_to_check).." will get the unit list for each one.")

    local path = os.getenv("APPDATA").."\\CA_Autotest\\WH3\\dlc_mask_testing"
    os.execute("rd /s/q "..path) --delete the folder and anything in it (if it exists), files might linger from a previous botched run and this can cause issues with the python tool
    os.execute("mkdir "..path) --make the directory if it doesnt exist (either we deleted it in the line above or this script has never run on this machine)
    
    --go through all the factions to check and get the unit list from the subculture
    for _,faction in ipairs(factions_to_check)do
        local faction_key = faction:Call("Key")

        if debug_mode then print("Testing faction: "..tostring(faction_key)) end

        local unit_list_size = faction:Call("SubcultureContext.Culture.UnitList.Size")

        local csv_string = "Subculture,Unit_Key,Unit_Name\n"
        local subculture = faction:Call("SubcultureContext.Key")

        if debug_mode then print("Checking units: "..tostring(unit_list_size)) end

        --go through the unit list, if the unit is owned, add it to the csv
        for i=0, unit_list_size-1 do
            local unit_owned = faction:Call(string.format("SubcultureContext.Culture.UnitList.At(%d).UnitContext.IsOwned", i))
            if(unit_owned) then
                local unit_key = faction:Call(string.format("SubcultureContext.Culture.UnitList.At(%d).UnitContext.Key", i))
                local unit_name = faction:Call(string.format("SubcultureContext.Culture.UnitList.At(%d).UnitContext.Name", i))
                local unit_name_fixed = string.format("%q", unit_name)
                csv_string = csv_string..subculture..","..unit_key..","..unit_name_fixed.."\n"
                subculture = "" --we only want to write the subculture to the csv once, so we just set subcluture to blank after the first time
            end
        end 
        
        local filename = "dlc_mask_"..faction_key
        if(faction_key ~= "wh3_prologue_kislev_expedition") then
            --the prologue faction causes issues because its unit list is empty as it's not a proper campaign faction, so we ignore it
            Functions.write_to_document(csv_string, path, filename, ".csv", false, false, true)
        end
    end
end)

Lib.Frontend.Misc.quit_to_windows()