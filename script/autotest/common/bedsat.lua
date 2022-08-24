--This script is not technically part of the GSAT system, it should not use any GSAT functionality and should be usable in multiple different lua scripts
--Can be moved at a later date but within the "autotest" script folder made sense for now

load_script_libraries(); --required to ensure all the battle manager scripts are loaded correctly, without battle manager this script would be useless!

bm:out("BEDSAT script loaded, will begin once deployment ends.");
--#####################################################
--############### MEMBER VARIABLES ####################
--#####################################################

--most of the member variables are at the top of their respective sections rather than all being at the top of the page
--these member variables are related to file creation
local m_stat_file_path, m_stat_log_file_name, m_stat_log_full_path, m_checks_file_path, m_checks_file_name, m_checks_full_path
local m_abilities_file_path, m_abilities_log_file_name, m_abilities_log_full_path
local m_faction_name = "" --used for file name creation
local m_faction_key = ""
local m_stat_csv_file = {} --used to store all the csv lines for unit stats logging

local m_skip_ability_testing = false --currently debug only but will be used later for optional switches, skips execution of ability test cases
local m_skip_comparison = false --currently debug only but will be used later for optional switches, skips execution of python comparison script

local m_file_writing_disabled = false --[[ used during script writing to enable or disable file writing (to avoid spamming your app data with loads of files as you debug an issue through multiple script runs)..
                                          ..if you're reading this in a review and m_file_writing_disabled is set to true make a comment telling the person to sort it out!]]

--#####################################################
--################ HELPER FUNCTIONS ###################
--#####################################################

--###### GENERAL HELPER FUNCTIONS #########

--stolen from GSAT, just creates a folder and file for stat logging
local function create_stats_log_file()
    local appdata = os.getenv("APPDATA") 
    m_stat_file_path = appdata.."\\CA_Autotest\\WH3\\battle_verification"
    m_stat_log_file_name = os.date("unit_stat_log_"..m_faction_name.."_%d%m%y_%H%M%S")
    m_stat_log_full_path = m_stat_file_path.."\\"..m_stat_log_file_name..".csv"

    local result = os.execute("mkdir \""..m_stat_file_path.."\"")
    bm:out("Unit stats file: "..tostring(result))
end

--stolen from GSAT, just creates a folder and file for ability logging
local function create_ability_log_file()
    local appdata = os.getenv("APPDATA") 
    m_abilities_file_path = appdata.."\\CA_Autotest\\WH3\\battle_verification"
    m_abilities_log_file_name = os.date("unit_abilities_log_"..m_faction_name.."_%d%m%y_%H%M%S")
    m_abilities_log_full_path = m_abilities_file_path.."\\"..m_abilities_log_file_name..".txt"
    
    local result = os.execute("mkdir \""..m_abilities_file_path.."\"")
    bm:out("Ability stats file: "..tostring(result))
end

--stolen from GSAT, just creates a folder and file for ability checks
local function create_checks_output_file()
    local appdata = os.getenv("APPDATA") 
    m_checks_file_path = appdata.."\\CA_Autotest\\WH3\\battle_verification"
    m_checks_file_name = os.date("ability_checks_"..m_faction_name.."_%d%m%y_%H%M%S")
    m_checks_full_path = m_checks_file_path.."\\"..m_checks_file_name..".txt"

    local result = os.execute("mkdir \""..m_checks_file_path.."\"")
    bm:out("Ability checks file: "..tostring(result))
end

--adapted from GSAT, writes to specified file
local function write_to_file(contents, location)
    if(m_file_writing_disabled)then
        return --if file writing is disabled during script writing just return instantly
    end
	local file = io.open(location, "a")
	if(file ~= nil)then
		file:write(contents, "\n")
		file:close()
	else
		bm:out("FAILED! Attempted to write to a file but the file is nil. This could be due to a number of reasons, please contact a member of the automaton team.")
	end
end

--creates a sort of local library to handle our csv files, this was previously required so we could edit csv headers easily as we go
--however I found a slightly more elegant solution in the course of a refactor
--that being said there are some useful functions in here that may be of use later and could be refined and ported to other places (such as GSAT) so I've left them in even if some aren't used at the moment
local csv_file_handler = {}

--adds the contents to the csv table, can optionally specify a line number and whether or not you want to append or overwrite
csv_file_handler["add_line"] = 
function(csv_table, contents, line_number, overwrite) 
    line_number = line_number or nil
    overwrite = overwrite or false
    if(line_number == nil or csv_table[line_number] == nil)then
      table.insert(csv_table, contents)
    elseif(not overwrite)then
      csv_table[line_number] = csv_table[line_number]..","..contents
    else
      csv_table[line_number] = contents
    end
end

--removes the specified line number from the supplied csv table
csv_file_handler["remove_line"] = function(csv_table, line_number) table.remove(csv_table, line_number) end

--used to search whether a specific line in a csv table contains a value
csv_file_handler["line_contains"] = 
function(csv_table, line_number, search_term) 
    if(csv_table[line_number] == nil)then
        return false
    end
    local result = string.find(csv_table[line_number], search_term)
    return result ~= nil
end

--very basic debug print command for printing a csv table
csv_file_handler["print_contents"] = 
function(csv_table) 
    print("\n")
    for k,v in ipairs(csv_table) do
      print(tostring(k))
      print(tostring(v))
    end
end

--simply goes through each line of the csv table and writes it to the supplied file location
csv_file_handler["write_to_file"] = 
function(csv_table, file_location)
    if(m_file_writing_disabled)then --if file writing is disabled during script writing just return instantly
        return
    end
    local file = io.open(file_location, "a")
	if(file ~= nil)then
        for _,csv_line in ipairs(csv_table) do
            file:write(csv_line, "\n")
        end
        file:close()
    else
        bm:out("FAILED! Attempted to write to a file but the file is nil. This could be due to a number of reasons, please contact a member of the automaton team.")
    end 
end

--###### PYTHON CALLING FUNCTIONS ##########

local m_python_file_path

--used to call Python scripts in Lua
local function osExecute(cmd, output)
	if output == true then
		local fileHandle = assert(io.popen(cmd, 'r'))
		local commandOutput = assert(fileHandle:read("*a"))
		return commandOutput
	elseif output ~= true then
		assert(io.popen(cmd, 'r'))
	end
end

local function setup_python_file_path()
    local file_path = common.vfs_working_directory()
    m_python_file_path = file_path.."script\\autotest\\lib\\dave_database\\"
    bm:out("Python Filepath: "..tostring(m_python_file_path))
end

local function initiate_python_module_installation()
    bm:out("Installing python modules (if they aren't installed already).")
    osExecute("python "..m_python_file_path.."python\\module_installs.py", false)
end

--function that calls the comparison Python function, passing in relevant arguments
local function initiate_stat_comparison_python_script(faction_key)
    local faction_key_fixed = string.format("%q", faction_key)
    local results_file_path_fixed = string.format("%q", m_stat_log_full_path)
	local output = osExecute("python "..m_python_file_path.."python\\unit_testing_data.py "..faction_key_fixed.." "..results_file_path_fixed, true)
    bm:out("Python output: \n"..output)
end

--###### IN BATTLE HELPER FUNCTIONS #########

--pretty self explanatory, ends the battle
local function end_battle()
    bm:force_battle_end(0,"none",true,false)
end

--gets the faction of the first army (which is the army we care about)
--then sets m_faction_name to that value, used for file names
local function determine_faction()
    local script_unit = g_script_armies[1][1]
    local unit_num = script_unit.unit:unique_ui_id()
    m_faction_name = string.gsub(cco("CcoBattleUnit", unit_num):Call("ArmyContext.FactionName"), " ", "_") --as its used for file names, change spaces to be underscores
    
    local faction_key_full = cco("CcoBattleUnit", unit_num):Call("ArmyContext.FactionContext.Key") --get the full faction key e.g. wh2_main_hef_high_elves

    m_faction_key = string.sub(string.gsub(faction_key_full, string.match(faction_key_full, "[%w]*_[%w]*_"), ""), 1,3) --trim out the relevant part of the faction key, which is a 3 letter code e.g. hef
    
    bm:out("Faction name: "..tostring(m_faction_name).." Faction Key: "..tostring(m_faction_key))
end

--straight up stolen from unit balance scripts, just sets us up a nice easy to use table for each army in battle
--might be a better/neater way to do this but this works for now and I have yet to encounter any issues with it!
local function setup_armies()
    bm:out("Setting up some armies")
    local alliances = bm:alliances()

    local alliance_01 = alliances:item(1)
    local armies_01 = alliance_01:armies()

    local army_01 = armies_01:item(1)
    local units_01 = army_01:units()

    local alliance_02 = alliances:item(2)
    local armies_02 = alliance_02:armies()

    local army_02 = armies_02:item(1)
    local units_02 = army_02:units()

    local army_1_unit_count = units_01:count()
    local army_2_unit_count = units_02:count()

    g_script_armies = {{},{}}

    for i = 1, army_1_unit_count do
        local unit_1_name = "Unit_1_"..i

    	local unit1 = script_unit:new(units_01:item(i), unit_1_name)
    	bm:out(tostring(unit1))

        table.insert(g_script_armies[1], unit1)
    end

    for i = 1, army_2_unit_count do
        local unit_2_name = "Unit_2_"..i

    	local unit2 = script_unit:new(units_02:item(i), unit_2_name)
    	bm:out(tostring(unit2))

        table.insert(g_script_armies[2], unit2)
    end

    bm:out("Armies set up!")
    bm:out("Army 1 size: "..tostring(#g_script_armies[1]))
    bm:out("Army 2 size: "..tostring(#g_script_armies[2]))
    determine_faction()
end

--###### TEXT EXTRACTION HELPER FUNCTIONS #########

--some text has icons embedded in it, these take the vague form of [[some text]] but can contain symbols and text in the text part, patterns work most of the time
--however there are some that break the pattern, for that reason this method will find where "[["" and ""]]"" are in the text and remove everything between them (including the symbols themselves)
--while being a bit verbose it ensures clean removal of any instance of these pesky things!
local function remove_any_icon_text(heading_text)
    local starting_location = string.find(heading_text, "[[")
    local ending_location = string.find(heading_text, "]]")

    while(starting_location ~= nil and ending_location ~= nil)do

        local preceeding_string = string.sub(heading_text, 1, starting_location-1) --get the string before the "[["
        local succeeding_string = string.sub(heading_text, ending_location+2) --get the string after the "]]"
        local new_string = preceeding_string..succeeding_string --put the two strings together, essentially removing the [[ ]] and anything they contain

        heading_text = new_string
        starting_location = string.find(heading_text, "[[") --check the text for further [[ and ]] to repeat the loop if necessary
        ending_location = string.find(heading_text, "]]")
    end

    if(string.sub(heading_text, 1, 1) == " ")then --in some instances there is a space at the start of the string (usually from tooltips), this removes that space
        heading_text = string.sub(heading_text, 2)
    end
    return heading_text
end

--#################################################################################
--################ END OF HELPER FUNCTIONS ########################################
--#################################################################################


--#################################################################################
--################ UNIT STAT GETTING AND LOGGING ##################################
--#################################################################################

--a nice compact and easily(ish) extensible way to get all stats that arent in the standard list
--simply add a name and simple function to get the stat value using the script unit somehow to the table and it'll be got!
local function get_non_standard_stats(script_unit)
    local unit_id = script_unit.unit:unique_ui_id()
    local cco_battle_unit = cco("CcoBattleUnit",unit_id)
    local temp_stat_table = {}
    local non_standard_stats = {}
    non_standard_stats["cco"] = { --all stats got via cco_battle_unit
        {"Unit Key", function(cco_battle_unit) return cco_battle_unit:Call("UnitRecordContext.Key") end},
        {"Unit Type", function(cco_battle_unit) return cco_battle_unit:Call("UnitRecordContext.CategoryName") end},
        {"Unit Name", function(cco_battle_unit) return cco_battle_unit:Call("Name") end},
        {"Entity Count", function(cco_battle_unit) return cco_battle_unit:Call("UnitDetailsContext.NumEntities") end},
        {"Unit HP", function(cco_battle_unit) return cco_battle_unit:Call("HealthMax") end},
        {"Unit Scale", function(cco_battle_unit) return common.get_context_value("CcoBattleRoot", "", "UnitSize") end} --technically dont need to pass in cco_battle_unit here but prevents an error later
    }
    non_standard_stats["script"] = { --all stats got via script unit interface
        {"Unit Class", function(script_unit) return script_unit.unit:unit_class() end}
    }

    for stat_source, table_of_stats in pairs(non_standard_stats)do
        for index, table_stuff in ipairs(table_of_stats) do
            local object_to_pass_in
            if(stat_source == "script")then
                object_to_pass_in = script_unit
            else
                object_to_pass_in = cco_battle_unit
            end
            local stat_name = table_stuff[1]
            local stat_function = table_stuff[2]
            local stat_value = stat_function(object_to_pass_in)

            temp_stat_table[stat_name] = stat_value
        end
    end
    
    return temp_stat_table
end

--at present some stats are hidden in the tooltip of other stats, this function finds and extracts them
local function extract_stats_from_tooltip(cco_unit_details, stat_name)
    local table_of_stats = {}
    local stat_tooltip_text = remove_any_icon_text(cco_unit_details:Call("StatList.FirstContext(Name.Contains(\""..stat_name.."\")).Tooltip"))
    local newline_location = string.find(stat_tooltip_text, "\n")
    local new_line_skip_count = 0
    local tooltip_text_without_the_fluff = string.sub(stat_tooltip_text, newline_location) --the tooltip has a description of the main stat, then a new line, then all the other stats, this removes the description

    while (string.sub(tooltip_text_without_the_fluff, 1,1) == "\n" or string.sub(tooltip_text_without_the_fluff, 1,1) == " ") do 
        --there are a variable number of spaces and new lines in the left over part, this skips over them
        new_line_skip_count = new_line_skip_count + 1
        tooltip_text_without_the_fluff = string.sub(stat_tooltip_text, newline_location+new_line_skip_count)
    end
    
    local is_there_an_colon = string.find(tooltip_text_without_the_fluff, ":") --all stats in the tooltip have the form stat name: stat value, if we find a colon, we find a stat

    while(is_there_an_colon ~= nil)do
        local stat_name_from_tooltip = string.sub(tooltip_text_without_the_fluff,1,is_there_an_colon-1)
        newline_location = string.find(tooltip_text_without_the_fluff , "\n") or string.len(tooltip_text_without_the_fluff)+1

        --some stats (like reload time) in the tooltip have text in their values, this removes letters and spaces then converts the value to a number
        local stat_value_from_tooltip = string.gsub(string.sub(tooltip_text_without_the_fluff,is_there_an_colon+1,newline_location-1), "[%a%s]", "")
        stat_value_from_tooltip = tonumber(stat_value_from_tooltip) --lua gets upset if you put all of the above in tonumber() so we do it separately 

        if(string.sub(stat_name_from_tooltip,1,1) == " ")then --sometimes there's a space at the start, this removes it
            stat_name_from_tooltip = string.sub(stat_name_from_tooltip, 2)
        end
        table.insert(table_of_stats, {stat_name_from_tooltip, stat_value_from_tooltip})
        tooltip_text_without_the_fluff = string.sub(tooltip_text_without_the_fluff, newline_location+1) --remove the current line
        
        is_there_an_colon = string.find(tooltip_text_without_the_fluff, ":")
    end

    return table_of_stats
end

--gets a specific stat for a specific unit, is set up to handle aggregates
--for most stats it returns a table with a single entry of stat name index and stat value value
--for aggregates this table will contain multiple entries of stat name and stat value
local function get_unit_stat(cco_battle_unit, stat_name, base_value)
    base_value = base_value or false
    --bm:out("Getting unit stat: "..tostring(stat_name))
    local table_of_aggregates = { --some stats are aggregates, and they suck! We need to access the tooltip of these and extract the actual stats contained within, not ideal
        ["Weapon Strength"] = true, --setting the table up like this allows for quick searching
        ["Missile Strength"] = true
    }
    local table_of_hidden_ones = { --if we want to get a specific stat that is hidden inside an aggregate, we need to know that aggregate
        ["Base Weapon Damage"] = "Weapon Strength",
        ["Armour-Piercing Weapon Damage"] = "Weapon Strength",
        ["Bonus vs. Infantry"] = "Weapon Strength",
        ["Bonus vs. Large"] = "Weapon Strength",
        ["Base Missile Damage"] = "Missile Strength",
        ["Armour-Piercing Missile Damage"] = "Missile Strength",
        ["Reload Time"] = "Missile Strength"
    }

    if(table_of_hidden_ones[stat_name] ~= nil)then --if we're looking for a stat hidden in a tooltip we need to know the parent stat
        stat_name = table_of_hidden_ones[stat_name]
    end

    local table_of_stats = {} --we want to put the stat name and value in a table, for single stats this isn't needed but is required for aggregates, keeping the approach consistent makes the code more compact
    
    local cco_unit_details = cco_battle_unit:Call("UnitDetailsContext")
    if(base_value)then
        cco_unit_details = cco_unit_details:Call("UnitRecordContext.UnitDetailsContext")
    end
    local stat_value = cco_unit_details:Call("StatList.FirstContext(Name.Contains(\""..stat_name.."\")).Value")

    if(stat_value == nil)then --earlyish escape
        --no stat here, return an empty table
        return table_of_stats
    end

    if(table_of_aggregates[stat_name])then
        --gotta handle them aggregates!
        table_of_stats = extract_stats_from_tooltip(cco_unit_details, stat_name)
    end

    table.insert(table_of_stats, {stat_name, stat_value}) --after getting the aggregates (if there were any) insert the original stat name and value into the table too

    return table_of_stats
end

--gets all the stats we can for the specified unit
local function get_all_stats_for_specific_unit(script_unit, cco_battle_unit, cco_unit_details, base_value)
    base_value = base_value or false
    --bm:out("Updating stats for "..tostring(cco_battle_unit:Call("Name")))
    --local unit = script_unit

    script_unit.stat_table = {} --because the script unit is just a bunch of tables we can add our own table into it for later use. The result is that every script unit we use later has .stat_table
    local temp_stat_table = {}
    local unit_stat_list_length = cco_battle_unit:Call("UnitDetailsContext.StatList.Size")
    --this function is used to get all the stats we want that arent in the stat list below
    temp_stat_table = get_non_standard_stats(script_unit)

    --this loops through all the stats in the stat list, however that only gets us things like armour
    for i = 0, unit_stat_list_length-1 do
        local stat_name = remove_any_icon_text(cco_unit_details:Call("StatList.At("..tostring(i)..").Name"))
        local table_of_stats = get_unit_stat(cco_battle_unit, stat_name, base_value)
        for _, stat_table in ipairs(table_of_stats) do --most of the time the table_of_stats has a single entry, but aggregates will have multiple entries
            local stat_name_in_table = stat_table[1]
            local stat_value_in_table = stat_table[2]
            --bm:out("Got stat: "..tostring(stat_name_in_table)..": "..tostring(stat_value_in_table))
            temp_stat_table[stat_name_in_table] = stat_value_in_table
        end
    end
    script_unit.stat_table = temp_stat_table --once we have all stats for this unit we insert it into the stat_table of the script unit
end

--logs all the stats we want from each unit in the army using csv_file_handler "library"
local function log_all_stats_in_army(army_number)
    --get the stats for each unit
    for index, unit in pairs(g_script_armies[army_number]) do
        local unit_num = unit.unit:unique_ui_id()
        local cco_battle_unit = cco("CcoBattleUnit", unit_num)
        local cco_unit_details = cco_battle_unit:Call("UnitDetailsContext")
        
        get_all_stats_for_specific_unit(unit, cco_battle_unit, cco_unit_details, true) --get the base stats for the unit, without any modifiers
    end

    --log the stats
    local holder_of_stats = {}
    local unit_count = 0
    local stat_names_in_order = {}
    local header_line = ""
    local stat_line = ""

    --go through all units creating stat buckets and writing stat names to a table so we can use ipairs for a consistent order between units
    for _, unit in pairs(g_script_armies[army_number]) do
        unit_count = unit_count + 1
        for stat_name, stat_value in pairs(unit.stat_table) do
            if(holder_of_stats[stat_name] == nil)then
                --if there is no bucket already we need to make one
                holder_of_stats[stat_name] = {}
                table.insert(stat_names_in_order, stat_name)
            end
        end
    end

    --then, for each unit go through the stat names table and get the value from unit.stats_table, if its nil put 0, store the value in the appropriate bucket in holder_of_stats
    for _, unit in pairs(g_script_armies[army_number]) do
        for _, stat_name in ipairs(stat_names_in_order) do
            local unit_stat_value = unit.stat_table[stat_name]
            if(unit_stat_value == nil)then
                unit_stat_value = 0
            end
            table.insert(holder_of_stats[stat_name], unit_stat_value)
        end
    end

    --create the header line for this csv, containing ALL stat names
    for _, stat_name in ipairs(stat_names_in_order) do
        header_line = header_line..","..stat_name
    end
    header_line = string.sub(header_line, 2) --remove the first character as it'll be a ,
    csv_file_handler.add_line(m_stat_csv_file,header_line)

    --go through each unit and get the stat value from each bucket
    for unit_index = 1, unit_count do
        stat_line = ""
        for _, stat_name in ipairs(stat_names_in_order) do
            local stat_value = string.format("%q", holder_of_stats[stat_name][unit_index]) --surround each value with quotes to prevent any issues with commas in values (mainly names)
            stat_line = stat_line..","..stat_value
        end
        stat_line = string.sub(stat_line, 2) --remove the first character as it'll be a ,
        csv_file_handler.add_line(m_stat_csv_file,stat_line)
    end
end

--#################################################################################
--################ END OF UNIT STAT GETTING AND LOGGING ###########################
--#################################################################################


--#################################################################################
--################ ABILITY EFFECT GETTING AND LOGGING #############################
--#################################################################################

--because some of the tables this script uses can get quite confusing, I created this rough outline of what tables and sub tables there are, might be slightly out of date but is good enough for now!

--[[
    effects table/ability table atlas:
        phases :
            1 :
                effects
                    1 :
                        how : effect_value
                        stat : effect_value
                        value : effect_value
                other_effects
                    effect_name : effect_value
                effect_flags
                    1 : effect_text

        ui_effects :
            1 : ui_effect_text

        vortex_effects :
            1 : vortex_effect_table
                1 : vortex_effect_name 
                2 : vortex_effect_value

        projectile_effects :
            1 : projectile_effect_table
                1 : projectile_effect_name
                2 : projectile_effect_value
]]

--function for debug purposes only, basically traverses the table and prints out the whole thing, sub tables and all
local function recursive_table_print(table_to_print, level)
    level = level or 1
    local indents = ""
    for i = 1, level do
        indents = indents..">"
    end
    for k,v in pairs(table_to_print) do
        bm:out(indents..tostring(k))
        if(type(v) == "table")then
            recursive_table_print(v, level+1)
        else
            bm:out(indents..tostring(v))
        end
    end
end

--another debug printing function, where as the recursive function traverses all sub tables, this one is a bit more hardcoded but easier to read
local function debug_print_ability_effects_table(ability_table)
    --recursive_table_print(ability_table)
    bm:out("PRINTING ABILITY EFFECTS TABLE!")
    for index, phase_table in ipairs(ability_table.phases) do
        bm:out("Phase "..tostring(index).." effects: "..tostring(#ability_table.phases))
        for effect_index, effect_table in ipairs(phase_table.effects) do
            local stat = effect_table.stat
            local how = effect_table.how
            local value = effect_table.value
            bm:out("  >"..tostring(effect_index).." "..stat.." "..how.." "..value)
        end

        bm:out("Phase "..tostring(index).." effect flags: "..tostring(#phase_table.effect_flags))
        for effect_flag_index, effect_flag_text in ipairs(phase_table.effect_flags) do
            bm:out("  >"..tostring(effect_flag_index).." "..tostring(effect_flag_text))
        end

        bm:out("Phase "..tostring(index).." other effects: "..tostring(#phase_table.other_effects))
        for _, other_effect_table in ipairs(phase_table.other_effects) do
            local other_effect, other_effect_value = other_effect_table[1], other_effect_table[2]
            bm:out("  >"..tostring(other_effect).." "..tostring(other_effect_value))
        end
    end

    bm:out("UI Effects:"..tostring(#ability_table.ui_effects))
    for ui_index, ui_effect_text in ipairs(ability_table.ui_effects) do
        bm:out("> "..ui_index..": "..tostring(ui_effect_text))
    end

    bm:out("Vortex Record:"..tostring(#ability_table.vortex_effects))
    for _, vortex_effect_table in ipairs(ability_table.vortex_effects) do
        local vortex_effect, vortex_value = vortex_effect_table[1], vortex_effect_table[2]
        bm:out("> "..tostring(vortex_effect).." "..tostring(vortex_value))
    end

    bm:out("Projectile Record: "..tostring(#ability_table.projectile_effects))
    for _, proj_table in ipairs(ability_table.projectile_effects) do
        local proj_effect, proj_value = proj_table[1], proj_table[2]
        bm:out("> "..tostring(proj_effect).." "..tostring(proj_value))
    end
end

--gets all the "effects" of a projectile, which so far is just different types of damage, if projectiles ever have other effects it should be easy to add them here
local function get_projectile_record_effects(cco_unit_ability)
    local cco_projectile_record = cco_unit_ability:Call("ProjectileRecordContext")
    local table_of_effects = {}

    --bombardments are a bit weird but the damage they deal seems to be through projectiles so we just get the projectile context of the bombardment context
    if(cco_unit_ability:Call("BombardmentRecordContext"))then 
        cco_projectile_record = cco_unit_ability:Call("BombardmentRecordContext.ProjectileContext")
    end

    if(cco_projectile_record == nil)then --early escape
        return table_of_effects
    end

    local table_of_commands = {
        "ApDamageContext",
        "DamageContext",
        "ExplosiveApDamageContext",
        "ExplosiveDamageContext"
    }

    for _, command in ipairs(table_of_commands)do
        local effect_value = cco_projectile_record:Call(command..".Value")
        table.insert(table_of_effects, {command, effect_value})
    end
    
    return table_of_effects
end

--gets all the "effects" of a vortex, which so far is just different types of damage, if vortexs ever have other effects it should be easy to add them here
local function get_vortex_record_effects(cco_unit_ability)
    local cco_battle_vortex_record = cco_unit_ability:Call("VortexRecordContext")
    local table_of_effects = {}

    if(cco_battle_vortex_record == nil)then --early escape
        return table_of_effects
    end

    local table_of_commands = {
        "Damage",
        "DamageAP"
    }

    for _, command in ipairs(table_of_commands)do
        local effect_value = cco_battle_vortex_record:Call(command)
        table.insert(table_of_effects, {command, effect_value})
    end
    
    return table_of_effects
end

--a phase can have other "effects" that aren't in the effect list, things like heal amount, or imbuing fire attacks, this gets them
local function get_other_phase_effects(cco_special_ability_phase_record)
    local table_of_commands = {
        "AbilityRechargeChange",
        "Damage",
        "FatigueChangeRatio",
        "ImbueIgnition",
        "ImbueMagical",
        "MoraleChange",
        "Resurrect",
        "TotalHealPercent"
    }

    local table_of_effects = {}

    for _, command in ipairs(table_of_commands)do
        local effect_value = cco_special_ability_phase_record:Call(command)
        table.insert(table_of_effects, {command, effect_value})
    end

    return table_of_effects
end

--gets all the effects of an ability, not an easy task as they're not all nicely contained!
--also prints the details out to a text file
--fair warning, this function utilises a lot of tables within tables and gets quite confusing, use the atlas above for guidance if confused!
local function get_ability_effects(unit_num, ability_key)
    --for debug purposes, enables a whole bunch of text output
    local text_output_enabled = false

    local cco_battle_unit = cco("CcoBattleUnit", unit_num)
    local cco_unit_ability = cco_battle_unit:Call("AbilityList.FirstContext(RecordKey == \""..ability_key.."\")")
    local ability_table = {}
    ability_table["phases"] = {}
    ability_table["ui_effects"] = {}

    --get the length of ability phase list
    local ability_phase_list_length = cco_unit_ability:Call("AllChannelsPhaseList.Size")

    --for each phase the ability has do:
    for i = 0, ability_phase_list_length-1 do
        local temp_phase_table = {}
        local cco_special_ability_phase_record = cco_unit_ability:Call("AllChannelsPhaseList.At("..i..")")
        local effect_list_length = cco_special_ability_phase_record:Call("AbilityPhaseEffectsList.Size")
        local phase_key = cco_special_ability_phase_record:Call("Key")

        if(text_output_enabled) then bm:out("\n\nPhase: "..tostring(phase_key)) end
        write_to_file(">>>Phase: "..tostring(phase_key), m_abilities_log_full_path)

        local effects_table = {} --will be indexed by ints with each index having a table as a value, the value table will have the stat, how and value of the effect
        --for each effect in this phase do:
        for j = 0, effect_list_length-1 do
            local cco_special_ability_phase_stat_effect_record = cco_special_ability_phase_record:Call("AbilityPhaseEffectsList.At("..j..")")
            local temp_effect = {}
            temp_effect["how"] = cco_special_ability_phase_stat_effect_record:Call("How")
            temp_effect["stat"] = cco_special_ability_phase_stat_effect_record:Call("Stat")
            temp_effect["value"] = cco_special_ability_phase_stat_effect_record:Call("Value")
            table.insert(effects_table, temp_effect) --store the effect stats into the effects table as an entry
            if(text_output_enabled)then 
                bm:out("-----------------")
                bm:out("How: "..tostring(temp_effect["how"]))
                bm:out("Stat: "..tostring(temp_effect["stat"]))
                bm:out("Value: "..tostring(temp_effect["value"]))
                bm:out("-----------------\n")
            end
            for k,v in pairs(temp_effect) do
                write_to_file(">>>>Effect: "..tostring(k)..":"..tostring(v), m_abilities_log_full_path)
            end
        end

        temp_phase_table["effects"] = effects_table --put all the effects into the effects part of the phase table

        local effect_flags = {}
        if(cco_special_ability_phase_record:Call("PhaseEffectFlagList.IsEmpty") == false)then
            --phase effect flag list contains "effects" that are "just" text like "cannot move", presumably they are flags for code elsewhere to disable movement etc
            local flag_list_length = cco_special_ability_phase_record:Call("PhaseEffectFlagList.Size")
            for count = 0, flag_list_length-1 do
                local effect = cco_special_ability_phase_record:Call("PhaseEffectFlagList.At("..count..").StringValue")

                table.insert(effect_flags, effect)

                if(text_output_enabled)then 
                    bm:out("-----------------")
                    bm:out("Effect flag: "..tostring(effect))
                    bm:out("-----------------\n")
                end
                write_to_file(">>>>Effect_Flag: "..tostring(effect), m_abilities_log_full_path)
            end
        end

        temp_phase_table["effect_flags"] = effect_flags --put all the effect_flags into the effect_flags part of the phase table

        temp_phase_table["other_effects"] = get_other_phase_effects(cco_special_ability_phase_record) --a phase can have other "effects" that aren't in the effect list, things like heal amount, or imbuing fire attacks

        table.insert(ability_table["phases"], temp_phase_table) --finally, put the entire temp_phase_table (which contains everything above) into the actual ability_table under the phases section
    end
    
    --in addition to phases an ability can have additional UI effects
    local temp_ui_effects = {}
    if(cco_unit_ability:Call("HasAdditionalUiEffects") == true)then
        --UI effects are "just" text that list an effect such as "increased cooldown"
        local ui_effect_list_length = cco_unit_ability:Call("AdditionalUiEffectList.Size")
        for i = 0, ui_effect_list_length-1 do
            local effect_text = cco_unit_ability:Call("AdditionalUiEffectList.At("..i..").LocalisedText")
            table.insert(temp_ui_effects, effect_text)
            if(text_output_enabled)then 
                bm:out("-----------------")
                bm:out("UI effect: "..tostring(effect_text))
                bm:out("-----------------\n")
            end
            write_to_file(">>>>Ui_Effect: "..tostring(effect_text), m_abilities_log_full_path)
        end
    end
    ability_table["ui_effects"] = temp_ui_effects --add all the ui effects into the ability table

    ability_table["vortex_effects"] = get_vortex_record_effects(cco_unit_ability) --get any vortex effects, so far these are just damage and AP damage
    ability_table["projectile_effects"] = get_projectile_record_effects(cco_unit_ability) --get any projectle effects, mostly this is various damage types

    --as of version 1.0 I've yet to find any abilities that contain phases + vortex and/or projectiles, however if such abilities do exist this function should handle them fine

    return ability_table
end
--#################################################################################
--################ END OF ABILITY EFFECT GETTING AND LOGGING ######################
--#################################################################################


--#################################################################################
--################ REGULAR ABILITY TEST CASE EXECUTION ############################
--#################################################################################

--############# Member variables for regular ability test case execution ################
local m_testing_area, m_holding_area_vector1, m_holding_area_vector2, m_script_units_army_1, m_script_units_army_2, m_enemy_testing_area, m_ally_testing_area, m_ground_target_area

local m_failed_test_case_count, m_passed_test_case_count, m_skipped_test_case_count, m_total_test_case_count = 0,0,0,0

local m_ability_test_index = 1 --represents the ability
local m_test_case_index = 1 --represents the individual test case of an ability
local m_ability_test_case_finished_index
local m_full_ability_test_cases_for_army, m_full_ability_test_case_count

--the function called at the end of all the ability testing
local function ability_testing_finished_move_on()
    bm:out("Ability testing is complete. Moving onto the next part of the script.")

    if(not m_skip_ability_testing) then
        finalise_test_check_results()
        log_checks_to_file()
    end
    
    if(not m_skip_comparison)then
        initiate_stat_comparison_python_script(m_faction_key)
    end

    bm:callback(function()
        end_battle()
    end, 5000)
end

--function that handles moving onto the next ability test case or ending once all test cases are complete
local function increment_test_case()
    local size_of_current_suite = #m_full_ability_test_cases_for_army[m_ability_test_index]
    local size_of_total_table = #m_full_ability_test_cases_for_army
    m_total_test_case_count = m_total_test_case_count + 1
    if(m_test_case_index < size_of_current_suite)then
        bm:out("Incrementing test case index.")
        m_test_case_index = m_test_case_index + 1
    elseif(m_test_case_index >= size_of_current_suite)then
        if(m_ability_test_index < size_of_total_table)then
            bm:out("Incrementing ability test index and resetting test case index.")
            m_test_case_index = 1
            m_ability_test_index = m_ability_test_index + 1
        else
            bm:out("Test cases complete! Have completed "..tostring(m_ability_test_index).." of "..tostring(size_of_total_table).." abilities.")
            bm:out("| Total test cases: "..tostring(m_total_test_case_count).." | Passed: "..tostring(m_passed_test_case_count).." | Failed: "..tostring(m_failed_test_case_count).." | Skipped: "..tostring(m_skipped_test_case_count).." |")
            --these two lines aren't strictly necessary but it causes errors to be thrown if ability testing continues after it should have ended (in the event of some script changes that break it)
            m_ability_test_case_finished_index = m_ability_test_index
            m_ability_test_index = -1
            m_test_case_index = -1
        end
    end
end

--############## FUNCTIONS THAT IMPROVE POSITIONING OF UNITS #################

--debug function that prints out the XYZ of the supplied vector
local function print_vector(magic_vector, pre_text)
    local x = magic_vector:get_x()
    local y = magic_vector:get_y()
    local z = magic_vector:get_z()

    bm:out(pre_text.." X: "..tostring(x).." Y: "..tostring(y).." Z: "..tostring(z))
end

--we want to take the radius of an ability, the current location it will be cast and work out a Ally, enemy and self location that is within the radius
local function get_better_positions_for_ability_test(ability_key, casting_unit, target_vector)
    --step 0) get the context object (really should make this a helper function)
    local unit_num = casting_unit.unit:unique_ui_id()
    local cco_battle_unit = cco("CcoBattleUnit", unit_num)
    local cco_unit_ability = cco_battle_unit:Call("AbilityList.FirstContext(RecordKey == \""..ability_key.."\")")

    --step 1) get the ability's effect range
    local effect_range = tonumber(cco_unit_ability:Call("EffectRange"))
    local bombard = cco_unit_ability:Call("BombardmentRecordContext")
    if(bombard ~= nil)then
        effect_range = tonumber(bombard:Call("RadiusSpread"))
    end

    if(effect_range < 1)then --early escape, if there's no effect range then we don't need better positions!
        return nil, nil
    end

    bm:out("Getting better positions!")

    --this basically ensures the locations are within the effect range
    local ally_test_location = v_offset(target_vector, 0, 0, -(effect_range/2))
    local enemy_test_location = v_offset(target_vector, 0, 0, (effect_range/2))

    return ally_test_location, enemy_test_location
end


--########## END OF FUNCTIONS THAT IMPROVE POSITIONING OF UNITS #############

--take control of all script units (might be unnecessary as teleporting etc takes control by default, but this ensures no units are missed)
--stops the AI from moving units around and doing stuff!
local function assume_direct_control()
    bm:out("I am assuming direct control.")
    for i = 1, 2 do
        for _,script_unit in ipairs(g_script_armies[i]) do
            script_unit:take_control()
            script_unit.uc:fire_at_will(false)
        end
    end
end

--a function that teleports the specified unit, has options to respawn the unit while teleporting, make them wide or thin and some additional information
local function teleport_unit_to_location(script_unit_object, desired_position, respawn_instead, make_unit_wide, additional_info)
    additional_info = additional_info or ""
    make_unit_wide = make_unit_wide or false

    local additional_string = ""
    local current_width, current_bearing
    local team_number = script_unit_object:army():unique_id()

    if(make_unit_wide)then
        current_width = 1000 --forces unit to have 1000 units per rank/line, meaning all units are one long horizontal line
    else
        current_width = 1 --forces unit to have 1 unit per rank/line
    end

    if(additional_info ~= "")then
        additional_string = " Additional Info: "..tostring(additional_info)
    end

    bm:out("Teleporting unit: "..tostring(script_unit_object)..additional_string)
    respawn_instead = respawn_instead or false --technically this isn't needed but it makes it clear to everyone that this defaults to off and is "optional"

    --ensure all units face forward, they can end up with a different bearing if they routed etc in previous tests
    if(team_number == 1)then
        current_bearing = 180
    else
        current_bearing = 0
    end
   
    if(respawn_instead)then
        script_unit_object.unit:respawn(desired_position, current_bearing, current_width) --this will refresh the unit if it's already been used in a previous test
    else
        script_unit_object:teleport_to_location(desired_position, current_bearing, current_width)
    end
end

--simple function that batch teleports all units, note: that isn't a script_unit like most other locations, its a script_unitS object, which is a collection of script_unit objects
local function move_all_units_to_location(script_units_object, desired_position, respawn_instead)
    local unit_count = script_units_object:count()
    for i = 1, unit_count do
        teleport_unit_to_location(script_units_object:item(i), desired_position, respawn_instead)
    end
end

--adds all script_unit objects in the army to a script_unitS object
local function add_all_to_script_units(script_units_object, army_table)
    for _,v in pairs(army_table)do
        script_units_object:add_sunits(v)
    end
end

--prepares the units for testing by setting up various locations and teleporting units
--sets up a testing area where the casting unit will teleport to
--sets up areas for enemy and allies to teleport to
--sets up a specific point where ground abilities will be targetted
--this ensures consistency across all tests, every unit always goes to the same places
--finally sets up two holding areas for each army where units who aren't being used for tests will teleport to to keep them out of the way
local function setup_script_units_and_testing_areas()
    m_script_units_army_1 = script_units:new("army1") --these are script_unitS objects not script_unit objects
    m_script_units_army_2 = script_units:new("army2")
    add_all_to_script_units(m_script_units_army_1, g_script_armies[1])
    add_all_to_script_units(m_script_units_army_2, g_script_armies[2])

    bm:out("Army 1 script_units count: "..tostring(m_script_units_army_1:count()))
    bm:out("Army 2 script_units count: "..tostring(m_script_units_army_2:count()))

    local centremost_army1 = m_script_units_army_1:get_centremost()
    local centremost_army2 = m_script_units_army_2:get_centremost()

    m_testing_area = centremost_army1.unit:position()
    m_enemy_testing_area = centremost_army1:position_offset(-10,0,10)
    m_ally_testing_area = centremost_army1:position_offset(10,0,10)
    m_ground_target_area = centremost_army1:position_offset(0,0,10)
    bm:out("Testing area: "..tostring(m_testing_area))
    m_holding_area_vector1 = centremost_army1:position_offset(0,0,-50) --setup a position that is just behind the centremost unit some way
    --this isn't really necessary (as no tests are anywhere near the enemy army) but for the sake of consistency and maybe needing it in the future we set it up:
    m_holding_area_vector2 = centremost_army2:position_offset(0,0,-50) 
end

--once a test is complete we move all units back to their holding areas
local function move_all_units_out_of_the_way()
    bm:out("Moving all units to holding areas.")
    move_all_units_to_location(m_script_units_army_1, m_holding_area_vector1, true)
    move_all_units_to_location(m_script_units_army_2, m_holding_area_vector2, true)
end

--for now we disable all passive abilities on all units to prevent them interferring with active ability tests
local function disable_passives_and_update_stats_for_army(script_units_object)
    local unit_count = script_units_object:count()
    for i = 1, unit_count do
        local script_unit = script_units_object:item(i)
        local unit_num = script_unit.unit:unique_ui_id()
        local cco_battle_unit = cco("CcoBattleUnit", unit_num)
        local cco_unit_details = cco_battle_unit:Call("UnitDetailsContext")
        script_unit.unit:disable_passive_special_abilities(true)
        get_all_stats_for_specific_unit(script_unit, cco_battle_unit, cco_unit_details, true)
    end
end

--disables passives for each army
local function disable_passives_and_update_stats_for_all_units()
    bm:out("Disabling passives and updating stats for all units")
    disable_passives_and_update_stats_for_army(m_script_units_army_1)
    disable_passives_and_update_stats_for_army(m_script_units_army_2)
end

--gets a random allied or enemy unit for the test
local function get_random_unit(casting_unit, unit_type)
    local random_unit
    local table_index_to_use = 1
    if(unit_type == "Enemy")then
        table_index_to_use = 2
    end

    repeat
        local random_unit_int = math.random(1, #g_script_armies[table_index_to_use])
        random_unit = g_script_armies[table_index_to_use][random_unit_int]
    until(random_unit ~= casting_unit) --we dont want to return the casting unit as that doesnt help us in any way!

    return random_unit
end

--goes through the affected unit types list and gets a random unit matching each type
--also teleports them to the right locations and returns a table containing the specific units gathered (for use with later functions)
local function gather_required_units(casting_unit, affected_unit_types, target_type)
    local all_unit_types_to_gather = {}
    local gathered_units = {}
    gathered_units["target"] = {}
    gathered_units["affects"] = {}
    --print_vector(m_testing_area,"Caster teleport. Teleport location: ")
    teleport_unit_to_location(casting_unit, m_testing_area, false) --teleports the casting unit to the testing area

    for k,v in pairs(affected_unit_types) do --to preserve the initial list we need to make a copy rather than a reference
        if(v == true)then
            all_unit_types_to_gather[k] = v
        end
    end
    all_unit_types_to_gather[target_type] = true --if the target type is one of the affected then this does nothing, otherwise it adds the target type to the list

    for unit_type,_ in pairs(all_unit_types_to_gather) do
        bm:out("Gathering "..tostring(unit_type))
        if(unit_type == "Ally" or unit_type == "Enemy")then
            local vector_to_use
            if(unit_type == "Ally")then
                vector_to_use = m_ally_testing_area
            else
                vector_to_use = m_enemy_testing_area
            end
            --print_vector(vector_to_use,tostring(unit_type).." teleport. Teleport location: ")
            local random_unit = get_random_unit(casting_unit, unit_type)
            teleport_unit_to_location(random_unit, vector_to_use, false)

            if(unit_type == target_type)then
                table.insert(gathered_units.target, {unit_type, random_unit})
            end

            if(affected_unit_types[unit_type] == true)then
                table.insert(gathered_units.affects, {unit_type, random_unit})
            end
        elseif(unit_type == "Self")then
            --dont need to do nothing
           -- bm:out("Self, no teleporting needed")
            if(affected_unit_types[unit_type] == true)then
                table.insert(gathered_units.affects, {unit_type, casting_unit})
            end
        elseif(unit_type == "Ground")then
            --keeping for debug purposes
            --bm:out("Ground, do nothing")
        else
            --something new? panik!
            bm:out("Unhandled type! Type: "..tostring(unit_type))
        end
    end

    return gathered_units
end

--uses active effect list of the unit to check if the ability has affected the unit
--its a very simple check that the ability is applied, does not factor in effect application etc
local function check_if_unit_is_affected_by_ability(unit_num, ability_key)
    local cco_battle_unit = cco("CcoBattleUnit", unit_num)
    local active_effect_list_size = cco_battle_unit:Call("ActiveEffectList.Size")

    if(active_effect_list_size < 1)then --early escape if active effect list is empty
        return false
    end

    local ability_in_list = cco_battle_unit:Call("ActiveEffectList.FirstContext(AbilityContext.RecordKey == \""..ability_key.."\")")

    --if the ability is in the active effect list then this unit is affected by the unit
    if(ability_in_list == nil)then
        return false
    else
        return true 
    end
end

--goes through the table of checks to find the set of checks corresponding to this unit
--we need to find a match so we can set the correct test cases to pass/fail e.g. if the ability affects enemies but not allies correctly we need to show that
local function find_matching_unit_type_in_checks(unit_type, table_of_checks)
    for index, unit_table in ipairs(table_of_checks.affects_all_units.units) do
        if(unit_table.type == unit_type)then
            return index
        end
    end
    return 0
end

--leadership/morale is a pesky stat to test because it has extra modifiers that we can't predict or disable
--to solve this we get all the modifiers listed in the tooltip, ignoring the base value and ones caused by abilities
--then we add all the modifiers together and add it into our calculations
local function get_total_leadership_modifiers(cco_unit_details)
    local leadership_mod_total = 0
    local leadership_mod_list = extract_stats_from_tooltip(cco_unit_details, "Leadership")
    for _, leadership_mod_table in pairs(leadership_mod_list)do
        local leadership_mod_text = leadership_mod_table[1]
        local leadership_mod_value = leadership_mod_table[2]
        local text_contains_ability = string.find(string.lower(leadership_mod_text), "ability")
        if(leadership_mod_text ~= "Base value" and not text_contains_ability)then
            leadership_mod_total = leadership_mod_total + tonumber(leadership_mod_value)
        end
    end

    return leadership_mod_total
end

--simple function that gets a specific unit stat
local function get_specific_unit_stat(cco_battle_unit, stat_name)
    local stat_table = get_unit_stat(cco_battle_unit, stat_name)
    
    --get_unit_stat returns a table of the stat+value because some stats are aggregates, we loop through the table to find the right value, most of the time its just one entry but for aggregates it can be multiple
    for _,stat_details in ipairs(stat_table)do
        if(stat_details[1] == stat_name)then
            --bm:out("Got stat "..tostring(stat_name).." with value: "..tostring(stat_details[2]))
            return stat_details[2]
        end
    end
end

--checks the unary value of the specified unit to see if it has taken damage, used for vortex and projectiles. Direct damage abilities use a different function/system
--also sets any vortex/projectile tests to passed/failed based on the outcome, if there are any checks related to them
local function verify_unit_has_taken_damage(unit_table, table_of_checks)
    --bm:out("Checking if unit has taken damage!")
    local unit_type = unit_table[1]
    local script_unit = unit_table[2]
    local unit_check_index = find_matching_unit_type_in_checks(unit_type, table_of_checks)
    local unary_hitpoints = script_unit:unary_hitpoints()
    local table_we_want = table_of_checks.affects_all_units.units[unit_check_index]
    local result = "failed"
    if(unary_hitpoints < 1)then --if unary_hitpoints is less than 1 then damage has been dealt, assume its by the ability
        --bm:out("Unit HAS taken damage")
        result = "passed"
    end

    local table_of_stuff = {
        "vortex",
        "projectile"
    }

    for _, table_index in ipairs(table_of_stuff) do
        if(table_we_want[table_index].effects ~= nil)then
            for _, effect_table in ipairs(table_we_want[table_index].effects) do
                effect_table.result = result
            end
        end
    end
    
    return result == "passed"
end

--works out whether or not a particular ability effect (e.g. melee attack -20%) has correctly been applied to a unit
--we don't have access to all stats so have to do some shenanigans to know what we can and cant test
--have kept the debug text but commented it out as it helps massively when debugging this function
--returns true if the check passes, false if it doesn't, there are some slight caveats to that inside the function!
local function verify_effect_on_unit(effect_table, script_unit)
    local stat_mapping_table = { --we only have access to a limited number of stats at the moment, this table lets us know which ones we can test and which we cant
        ["stat_damage_reflection"] = "NOPE",
        ["scalar_speed"] = "Speed",
        ["stat_reloading"] = "Reload Time",
        ["stat_resistance_physical"] = "NOPE",
        ["stat_melee_damage_base"] = "Base Weapon Damage",
        ["stat_melee_attack"] = "Melee Attack",
        ["stat_resistance_all"] = "NOPE",
        ["stat_accuracy"] = "NOPE",
        ["stat_morale"] = "Leadership",
        ["stat_melee_damage_ap"] = "Armour-Piercing Weapon Damage",
        ["stat_charge_bonus"] = "Charge Bonus",
        ["scalar_missile_damage_base"] = "Base Missile Damage",
        ["stat_armour"] = "Armour",
        ["scalar_charge_speed"] = "NOPE",
        ["scalar_entity_acceleration_modifier"] = "NOPE",
        ["stat_bonus_vs_infantry"] = "Bonus vs. Infantry",
        ["stat_resistance_missile"] = "NOPE",
        ["stat_melee_defence"] = "Melee Defence",
        ["stat_bonus_vs_large"] = "Bonus vs. Large",
        ["scalar_miscast_chance"] = "NOPE",
        ["damage"] = "DAMAGE"
    }

    local unit_num = script_unit.unit:unique_ui_id()
    local cco_battle_unit = cco("CcoBattleUnit", unit_num)
    local stat = effect_table.stat
    local stat_name = stat_mapping_table[stat] --the stats we get from the UI are named differently to the stats in the ability effects, so we have a hardcoded map between them
    local current_stat_value
    local base_stat_value

    if(stat_name ~= nil and stat_name ~= "NOPE" and stat_name ~= "DAMAGE")then --if the stat is one we have access to and isnt just plain old damage
        current_stat_value = get_specific_unit_stat(cco_battle_unit, stat_name)
        base_stat_value = script_unit.stat_table[stat_name]

        if(current_stat_value == nil or base_stat_value == nil)then
            --this unit does not use this stat (happens when an ability increases ranged stats on a melee unit for example)
            effect_table.result = "N/A"
            return true
        end

        local addition_text = effect_table.how 
        local expected_result
        
        --bm:out("Stat: "..tostring(stat).." Stat name: "..tostring(stat_name))
        if(addition_text == "multiplicative")then
            --bm:out("Performing "..tostring(base_stat_value).." * "..tostring(effect_table.value))
            expected_result = base_stat_value * effect_table.value
        else
            --bm:out("Performing "..tostring(base_stat_value).." + "..tostring(effect_table.value))
            expected_result = base_stat_value + effect_table.value
        end
        
        if(stat_name ~= "Speed")then
            --all game stats are rounded to whole numbers so we need to do the same, except speed for some reason, the game doesn't round that one...
            --bm:out("Expected result pre-round: "..tostring(expected_result))
            expected_result = math.floor(expected_result+0.49) --previously this was +0.5 but in cases where a stat ended in exactly .5 the game would round down and this would round up
        end

        if(stat_name == "Leadership")then
            --leadership is a tricky one to test because there can be a bunch of extra modifiers we can't account for or easily remove
            --to work around this we simply get all the modifiers and add them together, then add that to the expected result, not ideal but it's the best we can do at present
            local mod_amount = get_total_leadership_modifiers(cco_battle_unit:Call("UnitDetailsContext"))
            expected_result = expected_result + mod_amount
        end
        
        if(expected_result == current_stat_value)then
            --great success!
            --bm:out("COMPLEX EFFECT CHECK PASSED!!!! Expected: "..tostring(expected_result).." and got: "..tostring(current_stat_value).." for stat "..tostring(stat))
            effect_table.result = "passed"
            return true
        else
            --bm:out("COMPLEX EFFECT CHECK FAILED! Expected: "..tostring(expected_result).." but got: "..tostring(current_stat_value).." for stat "..tostring(stat))
            effect_table.result = "failed"
            return false
        end

    elseif(stat_name ~= nil and stat_name == "DAMAGE")then 
        --if the stat is DAMAGE then it's a simple direct damage effect, doesn't use the verify_unit_has_taken_damage function as that is mainly for vortex/projectiles and the pass/fail flow is different for them
        --check if the unit has taken any damage
        local unary_hitpoints = script_unit:unary_hitpoints()
        if(unary_hitpoints < 1)then --if unary_hitpoints is less than 1 then damage has been dealt, assume its by the ability
            --bm:out("Unit HAS taken damage")
            effect_table.result = "passed"
            return true
        else
            effect_table.result = "failed"
            return false
        end

    elseif(stat_name == nil)then
        effect_table.result = "UNHANDLED"
        bm:out("NEW STAT! Handle this! "..tostring(stat))
        return false --return false to indicate this check has failed as we can't test it
    else
        --because we can't check this stat at the moment we return true (no fails) and set the result to Not Implemented.
        --this means the check "passes" because we know the ability affected the unit (because it has to have affected it to get to this function) but we cant verify the stats applied correctly
        --in the future this will hopefully be removed entirely once we have access to all unit stats
        bm:out("Supposedly not implemented! "..tostring(stat).." marking check as Not Implemented and returning no fails")
        effect_table.result = "Not Implemented"
        return true
    end
end

--goes through each effect in a phase and checks if it has applied to the unit, returns true if none of the effects failed, otherwise returns false
local function verify_phase_effects_on_unit(unit_type, script_unit, table_of_checks)
    local unit_check_index = find_matching_unit_type_in_checks(unit_type, table_of_checks)
    if(unit_check_index == 0)then --this shouldn't be possible, in theory...
        bm:out("ERROR!!!! VERIFY_PHASE_EFFECT_ON_UNIT() CALLED BUT NO MATCHING UNIT CAN BE FOUND FOR UNIT TYPE: "..tostring(unit_type))
        return false
    end
    
    local fail_count = 0
    local table_we_want = table_of_checks.affects_all_units.units[unit_check_index]
    local no_fails = true
    for _, phase_table in ipairs(table_we_want.phases) do
        for _,effect_table in pairs(phase_table.effects)do
            no_fails = verify_effect_on_unit(effect_table, script_unit) --see if this ability has taken effect
            --bm:out("No fails? "..tostring(no_fails))
            if(not no_fails)then
                fail_count = fail_count+1
            end
        end
    end
    return fail_count == 0
end

--called after an ability that summons a unit passes
--finds the summoned unit
--kills the summoned unit
--function name is a Harry Potter reference, if you're unaware
local function kill_the_spare()
    bm:out("KILL THE SPARE!")
    local first_unit = g_script_armies[1][1] --just need a unit from the first army to work with so use the first unit (could be a random unit but that's unnecessary)
    local army_one = first_unit:army()
    local army_one_unit_count = army_one:units():count()
    local summoned_unit
    for i = 1, army_one_unit_count do
        --go through each unit in the army
        local unit = army_one:units():item(i)
        local unit_id = unit:unique_ui_id()
        local unit_present_in_script_armies = false

        for _, stored_unit in ipairs(g_script_armies[1]) do
            --check if the current unit is in g_script_armies already, if it isnt then its the summoned unit
            local stored_unit_id = stored_unit.unit:unique_ui_id()
            if(stored_unit_id == unit_id)then
                unit_present_in_script_armies = true 
                break
            end
        end
        if(not unit_present_in_script_armies)then
            summoned_unit = unit
            break
        end
    end

    if(summoned_unit ~= nil)then
        bm:out("AVADA KEDAVRA! Unit: "..tostring(summoned_unit:unique_ui_id())) --noooo Cedric! :(
        summoned_unit:reduce_hitpoints_unary(1, true) --true means hide the bodies!
        --at present the UI doesn't update so the unit banner remains in 3D space and on the army panel but the unit is actually dead as far as unit counts etc go
    else
        bm:out("CANNOT FIND SUMMONED UNIT TO REMOVE!")
    end
end

--very simple way to check if the ability has summoned a unit correctly, just gets the army count and compares it to the length of g_script_armies[1]
local function verify_summon_ability(casting_unit)
    bm:out("Verifying summon ability!")
    local original_player_army_unit_count = #g_script_armies[1]
    local current_player_army_unit_count = casting_unit:army():units():count()
    bm:out("Old army count: "..tostring(original_player_army_unit_count))
    bm:out("New army count: "..tostring(current_player_army_unit_count))
    return current_player_army_unit_count > original_player_army_unit_count
end

--at present there are a number of effects we cant check such as ones related to casting time, unable to move, etc
--this function verifies whether the phase we're wanting to test actually has anything we CAN test
local function phase_has_legit_effects(table_of_checks)
    if(#table_of_checks.affects_all_units.units < 1)then --there are no units to check, therefore no effects
        return false
    end
    for _,phase_table in ipairs(table_of_checks.affects_all_units.units[1].phases)do
        for _, _ in ipairs(phase_table.effects)do
            return true --if there are any effects in the effects table return true
        end
    end
    return false
end

--checks if the ability is a summon ability, we could use the ability type but there are some abilities that summon units that arent that ability type
--instead we look for the word "summon" in the ui_effects as most summon abilities use that word
--there are a couple of abilities that don't use the word summon but do summon units, for now those are ignored until a better solution than hardcoding those abilities is found
local function is_summon(effects_list)
    if(effects_list == nil)then
        return false
    end
    if(#effects_list.ui_effects > 0)then
        for _, effect_text in ipairs(effects_list.ui_effects) do
            if(string.find(string.lower(effect_text), "summon") ~= nil)then
                return true
            end
        end
    end
    return false
end

--the main function for checking if an ability has affected everyone it should
--there are different paths it takes depending on the type of ability e.g. vortex, summons units, etc
--there are also two different types of check it can do for abilities that apply effects which I've called simple and complex
--simple will just check that the ability is affecting the unit and not look at any effects etc where as complex will check each individual effect (if it can) and verify it correctly changes the stat etc
--as there are lots of stats we cant access there are many effects we cant test, hence why we use the simple check to confirm the ability works in some capacity
local function check_if_all_targets_are_affected_by_ability(affected_units_table, casting_unit, ability_key, table_of_checks)
    --affected units table is an indexed table of tables, each sub table has the unit type in index 1 and the script unit in index 2

    local unit_count = #affected_units_table
    local units_affected = 0
    local units_affected_simple = 0

    local has_phases = false
    local has_vortex = false
    local has_projectile = false

    if(#table_of_checks.affects_all_units.units > 0)then
        has_phases = #table_of_checks.affects_all_units.units[1].phases > 0
        if(table_of_checks.affects_all_units.units[1].vortex.effects ~= nil)then has_vortex = #table_of_checks.affects_all_units.units[1].vortex.effects > 0 end
        if(table_of_checks.affects_all_units.units[1].projectile.effects ~= nil)then has_projectile = #table_of_checks.affects_all_units.units[1].projectile.effects > 0 end
    end

    local is_summon = table_of_checks.summons_correctly ~= nil

    if(is_summon)then --if the ability is a summon ability then we want to only test that
        local result = verify_summon_ability(casting_unit)
        local result_text = "failed"

        if(result == true)then
            result_text = "passed"
            kill_the_spare()
        end

        table_of_checks.summons_correctly.result = result_text
        return result
    else --if the ability is not a summon, then we want to test as normal
        for _, unit_table in pairs(affected_units_table) do
            local unit_type = unit_table[1]
            local script_unit = unit_table[2]
            local affected_unit_num = script_unit.unit:unique_ui_id()
            if(has_phases and check_if_unit_is_affected_by_ability(affected_unit_num, ability_key) and phase_has_legit_effects(table_of_checks))then
                --if this unit has been affected and there are actual effects we can check we perform a "complex" check
                units_affected_simple = units_affected_simple+1 --simple check that the unit is affected
                local result = verify_phase_effects_on_unit(unit_type, script_unit, table_of_checks)
                if(result)then
                    units_affected = units_affected+1
                end
            elseif(check_if_unit_is_affected_by_ability(affected_unit_num, ability_key))then
                --if there arent any effects we can check we just check if it has affected the unit which is a "simple" check
                --bm:out("SIMPLE CHECK!")
                units_affected_simple = units_affected_simple+1
            end
    
            if(has_projectile or has_vortex)then
                --bm:out("VORTEX OR PROJECTILE!")
                if(verify_unit_has_taken_damage(unit_table, table_of_checks))then
                    units_affected_simple = units_affected_simple + 1
                end
            end
        end
    
        if(units_affected_simple == unit_count)then
            table_of_checks.affects_all_units_simple.result = "passed"
        end
    
        --if there were actual effects to test, return the complex result, otherwise return the simple result
        if(phase_has_legit_effects(table_of_checks) == false)then
            --bm:out("SIMPLE RETURN! Affected: "..tostring(units_affected_simple).." Count: "..tostring(unit_count))
            return units_affected_simple == unit_count
        else
            --bm:out("COMPLEX RETURN Affected: "..tostring(units_affected).." Unit count: "..tostring(unit_count))
            return units_affected == unit_count
        end
    end
end

--currently used as a debug function to help solve problems around targets getting affected
local function get_all_targets_not_affected_by_ability(ability_key, affected_units_table)
    local unaffected_units = {}
    for index, unit_table in pairs(affected_units_table) do
        local unit_type = unit_table[1]
        local script_unit = unit_table[2]
        local unit_num = script_unit.unit:unique_ui_id()

        if(check_if_unit_is_affected_by_ability(unit_num, ability_key) == false)then
            table.insert(unaffected_units, {unit_type, script_unit})
        end

    end
    return unaffected_units
end

--called after each ability test, resets the cool down and number of uses if the ability has one
local function reset_cooldown_and_uses_for_ability_on_unit(script_unit, ability_key)
    local unit_num = script_unit.unit:unique_ui_id()
    local cco_battle_unit = cco("CcoBattleUnit", unit_num)
    local cco_unit_ability = cco_battle_unit:Call("AbilityList.FirstContext(RecordKey == \""..ability_key.."\")")
    local num_uses = cco_unit_ability:Call("NumUses")

    script_unit.uc:reset_ability_cooldown(ability_key)

    if(num_uses > -1)then
        script_unit.uc:reset_ability_number_of_uses(ability_key)
    end
end

--called before each ability test, sets the winds of magic to maximum (game caps at 100 but uses 200 to make sure it always hits the max)
local function replenish_winds_of_magic()
    bm:out("Adding winds of magic.")
    common.execute_cli_command("add_winds_of_magic_current 200")
end

--waits a number of seconds (currently 20) + ability wind up time then fires, if it fires we assume the ability failed to activate correctly and perform the necessary clean up
--contains some debug text commented out, have left it in for future debug use!
local function watch_for_ability_failing_to_take_effect(ability_key, affected_units_table, start_time, casting_unit, wind_up_time)
    local wait_time = 20
    bm:watch(
        function() return os.clock() >= start_time+wait_time+wind_up_time end, --condition
		0, --wait time
		function()
            bm:remove_process(tostring(ability_key).."_ability_watcher") --remove the watcher that is waiting for the ability to work!

            --[[bm:out("Removed ability watcher: "..tostring(bm:remove_process(tostring(ability_key).."_ability_watcher")))
			bm:out("Ability test "..tostring(ability_key).." FAILED! Has not taken effect after "..wait_time.." seconds. (plus wind up time of: "..tostring(wind_up_time)..") Log as a fail and move on.")
            local unaffected_units = get_all_targets_not_affected_by_ability(ability_key, affected_units_table)
            for k,v in ipairs(unaffected_units) do
                bm:out("> Unaffected: "..tostring(v[2]).." which is type: "..tostring(v[1]))
            end]]
            
            finish_up_test_case(false, casting_unit, ability_key)
		end, --function to do when triggered
		tostring(ability_key).."_failed_watcher"	--optional watch name	
	)
end

--creates a watcher that fires once the check_if_all_targets_are_affected_by_ability function returns true
--in other words, waits until the ability works and then moves on
--contains some commented out debug text that I've left in for easier debugging
local function watch_for_ability_to_take_effect(ability_key, affected_units_table, casting_unit, checks_table)
    bm:watch(
        function() return check_if_all_targets_are_affected_by_ability(affected_units_table, casting_unit, ability_key, checks_table) == true end, --condition
		0, --wait time
		function()
            local callback_time = 0
            bm:remove_process(tostring(ability_key).."_failed_watcher")
            --bm:out("Removed ability failed watcher: "..tostring(bm:remove_process(tostring(ability_key).."_failed_watcher")))
			--bm:out("Ability "..tostring(ability_key).." taken effect correctly! ")

            local unit_num = casting_unit.unit:unique_ui_id()
            local cco_battle_unit = cco("CcoBattleUnit", unit_num)
            local cco_unit_ability = cco_battle_unit:Call("AbilityList.FirstContext(RecordKey == \""..ability_key.."\")")

            local bombard = cco_unit_ability:Call("BombardmentRecordContext")
            if(bombard ~= nil)then
                callback_time = tonumber(cco_unit_ability:Call("ActiveTime"))
                bm:out("Waiting for Bombardment to finish. Will take "..tostring(callback_time).." seconds")
            end

            --finish_up_test_case(true, casting_unit, ability_key)
            bm:callback(function() finish_up_test_case(true, casting_unit, ability_key) end, callback_time*1000)
		end, --function to do when triggered
		tostring(ability_key).."_ability_watcher"	--optional watch name	
	)
end

--used by move_targets_to_better_locations
local function get_target_type_default_location(target_type)
    if(target_type == "Self")then
        return m_testing_area
    elseif(target_type == "Ally")then
        return m_ally_testing_area
    elseif(target_type == "Enemy")then
        return m_enemy_testing_area
    else
        return nil
    end
end

--moves units required for this test to a better location
--is only called if better locations are found
local function move_targets_to_better_locations(gathered_affects_table, better_ally_test_position, better_enemy_test_position, target_type)
    for _,unit_table in pairs(gathered_affects_table)do
        local unit_type = unit_table[1]
        local script_unit = unit_table[2]
        local vector_to_tp_to
        if(unit_type == target_type)then
            --bm:out("Dont want to move "..tostring(unit_type).." as they are the target type!")
            vector_to_tp_to = get_target_type_default_location(unit_type) --we dont want to teleport the unit if it is the target, because then the positions will be all messed up! However, we want to reorient them so they dont intersect with others
        elseif(unit_type == "ally")then
            vector_to_tp_to = better_ally_test_position
        elseif(unit_type == "Enemy")then
            vector_to_tp_to = better_enemy_test_position
        else
            vector_to_tp_to = nil --if the affect target is self, this is the caster and we dont want to move them
        end

        if(vector_to_tp_to ~= nil)then
            teleport_unit_to_location(script_unit, vector_to_tp_to, true, true, "BetterMove!")
        end
    end
end

--carries out the actual testing of the ability: 
-- finds if there are better positions and teleports units if there is
-- works out where to cast the ability (if needed) and casts it
-- sets up the necessary watchers to test the ability
local function perform_the_test(test_case, gathered_units)
    --all this variable assigning isn't strictly necessary but it makes the following code a bit cleaner when it uses them
    local casting_unit = test_case.unit_with_ability
    local ability_key = test_case.ability_key
    local target_type = test_case.target_type
    local is_targeted = test_case.is_targeted
    local checks_table = test_case.checks_table
    local wind_up_time = test_case.wind_up_time

    

    --from the gathered units assign out the one we're targetting
    local target = casting_unit.unit
    local gathered_target_table = gathered_units.target
    local gathered_affects_table = gathered_units.affects

    if(ability_key == "wh2_main_spell_ruin_warp_lightning")then
        for _,unit_table in pairs(gathered_affects_table) do
            local unit_type = unit_table[1]
            bm:out("Target type: "..tostring(unit_type))
        end
    end

    if(target_type ~= "Self" and target_type ~= "Ground")then
        target = gathered_target_table[1][2].unit
    end

    --bm:out("Will be testing the ability affects: "..tostring(#gathered_affects_table).." units.")

    local target_vector = m_testing_area
    if(target_type == "Ground")then
        target_vector = m_ground_target_area
    elseif(target_type == "Self") then
        target_vector = m_testing_area
    elseif(target_type == "Enemy") then
        target_vector = m_enemy_testing_area
    elseif(target_type == "Ally") then
        target_vector = m_ally_testing_area
    end

    local better_ally_test_position, better_enemy_test_position = get_better_positions_for_ability_test(ability_key, casting_unit, target_vector)

    if(better_ally_test_position ~= nil)then
        move_targets_to_better_locations(gathered_affects_table, better_ally_test_position, better_enemy_test_position, target_type)
    end
    
    -- setup ability taking effect watcher
    watch_for_ability_to_take_effect(ability_key, gathered_affects_table, casting_unit, checks_table)
    
    --setup n seconds later watcher
    watch_for_ability_failing_to_take_effect(ability_key, gathered_affects_table, os.clock(), casting_unit, wind_up_time)

    if(not is_targeted)then
        bm:out("Activating "..tostring(ability_key).." which is not a targetted ability, will be \"targeting\" "..tostring(target).." (because target isnt optional...)")
        casting_unit.uc:perform_special_ability(ability_key, target)
    else
        if(target_type == "Ground")then
            bm:out("Activating "..tostring(ability_key).." on ground location: "..tostring(m_ground_target_area))
            casting_unit.uc:perform_special_ability_ground(ability_key, m_ground_target_area)
        else
            bm:out("Activating "..tostring(ability_key).." on target: "..tostring(target_type).." ("..tostring(target)..")")
            casting_unit.uc:perform_special_ability(ability_key, target)
        end
    end
end

--performs some initial set up for the ability test
local function setup_for_ability_tests()
    setup_script_units_and_testing_areas()
    disable_passives_and_update_stats_for_all_units()
    move_all_units_out_of_the_way()
    assume_direct_control()
    replenish_winds_of_magic()
end
--#################################################################################
--################ END OF REGULAR ABILITY TEST CASES ##############################
--#################################################################################


--#################################################################################
--### VORTEX TEST CASE SYSTEM (basically a mini version of the test case system)###
--#################################################################################

--basically, vortex abilities are just the worst thing ever for this script
--regular vortex abilities create a randomly moving aoe that lasts for quite a while, we have no way to interact with the moving aoe or know where it goes
--to solve this issue we cast the ability and rapidly teleport each unit type into the initial casting area until they take damage
--this prevents units from accidentally hitting each other creating false positives and happens fast enough that the vortex doesnt move too far away from the original spot

--however, for line and cone (wind and breath in game) vortex abilities this system doesnt work, so we instead work out where to place the units along the line/cone and test them all at once

local m_vortex_tests_completed = 0
local m_vortex_test_case = {}
local m_vortex_affected_units = {}
local m_vortex_unit_cached_location
local m_vortex_units_affected_correctly_count = 0
local m_vortex_cast = false

--waits for some seconds and assumes the ability has failed and moves on
local function watch_for_vortex_ability_failing_to_take_effect(ability_key, affected_unit_table, start_time, single_unit_check, wind_up_time)
    local wait_time = 20
    bm:watch(
        function() return os.clock() >= start_time+wait_time+wind_up_time end, --condition
		0, --wait time
		function()
            bm:remove_process("vortex_"..tostring(ability_key).."_ability_watcher")
            --bm:out("Removed ability watcher: "..tostring(bm:remove_process("vortex_"..tostring(ability_key).."_ability_watcher")))
			--bm:out("VORTEX Ability test "..tostring(ability_key).." FAILED! Has not taken effect after "..wait_time.." seconds (plus wind up time of: "..tostring(wind_up_time).."). Log as a fail and move on.")  
            
            if(single_unit_check)then
                teleport_unit_to_location(affected_unit_table[1][2], m_vortex_unit_cached_location, true, false, "Failed Vortex")
            else
                m_vortex_tests_completed = #affected_unit_table --because this wasnt a single unit check, we checked all units at once, so set the tests completed to reflect that
            end
            
            increment_vortex_unit_test()
		end, --function to do when triggered
		"vortex_"..tostring(ability_key).."_failed_watcher"	--optional watch name	
	)
end

--watches for check_if_all_targets_are_affected_by_ability function returns true and considers the vortex to have passed unless it was a single unit check
local function watch_for_vortex_ability_to_take_effect(ability_key, affected_unit_table, casting_unit, checks_table, single_unit_check)
    bm:watch(
        function() return check_if_all_targets_are_affected_by_ability(affected_unit_table, casting_unit, ability_key, checks_table) == true end, --condition
		0, --wait time
		function()
            bm:remove_process("vortex_"..tostring(ability_key).."_failed_watcher")
            --bm:out("Removed ability failed watcher: "..tostring(bm:remove_process("vortex_"..tostring(ability_key).."_failed_watcher")))
            --bm:out("VORTEX Ability "..tostring(ability_key).." taken effect correctly! ")
            m_vortex_units_affected_correctly_count = m_vortex_units_affected_correctly_count + #affected_unit_table
			
            if(single_unit_check)then
                teleport_unit_to_location(affected_unit_table[1][2], m_vortex_unit_cached_location, true, false, "Success vortex")
            else
                m_vortex_tests_completed = #affected_unit_table --because this wasnt a single unit check, we checked all units at once, so set the tests completed to reflect that
            end
            
            increment_vortex_unit_test()
		end, --function to do when triggered
		"vortex_"..tostring(ability_key).."_ability_watcher"	--optional watch name	
	)
end

--main function for performing the next vortex test
--if the vortex type is a regular vortex it will get one unit, cast the ability and then it will be called again by increment_vortex_unit_test to get the next unit
--if the vortex type is breath or wind it will position all units in a line and then activate the ability, this function will not get called again by increment_vortex_unit_test because all units were tested
local function perform_next_vortex_test()
    local vortex_type = m_vortex_test_case.type_name
    local casting_unit = m_vortex_test_case.unit_with_ability
    local ability_key = m_vortex_test_case.ability_key
    local checks_table = m_vortex_test_case.checks_table
    local wind_up_time = m_vortex_test_case.wind_up_time

    if(vortex_type == "Vortex")then
        local unit_to_test = m_vortex_affected_units[m_vortex_tests_completed][2]
        local unit_type = m_vortex_affected_units[m_vortex_tests_completed][1]
        local affected_unit_table = {} 
        table.insert(affected_unit_table, {unit_type, unit_to_test})--most functions want a table of units, so we just package this single unit into a table

        bm:out("Testing "..tostring(unit_to_test).." of type "..tostring(unit_type).." in the vortex")

        watch_for_vortex_ability_to_take_effect(ability_key, affected_unit_table, casting_unit, checks_table, true)
        watch_for_vortex_ability_failing_to_take_effect(ability_key, affected_unit_table, os.clock(), true, wind_up_time)

        if(m_vortex_cast == false)then --this function will be called multiple times to check each unit type, but we only want to cast the vortex once per full test
            m_vortex_cast = true
            bm:out("Activating "..tostring(ability_key).." on ground location: "..tostring(m_ground_target_area))
            casting_unit.uc:perform_special_ability_ground(ability_key, m_ground_target_area)
        end

        --set up the cached unit location to teleport them back again after the test
        if(unit_type == "Ally")then
            m_vortex_unit_cached_location = m_holding_area_vector1
        elseif(unit_type == "Enemy") then
            m_vortex_unit_cached_location = m_holding_area_vector2
        elseif(unit_type == "Self") then
            m_vortex_unit_cached_location = m_testing_area
        end

        teleport_unit_to_location(unit_to_test, m_ground_target_area, false, false, "Initial vortex")
    else --for line, breath and wind vortexes
        --determine positions for units
        local orientation = 180
        
        for unit_index, unit_table in ipairs(m_vortex_affected_units)do
            --for each unit, position it along the line
            local target_vector = v_offset(m_ground_target_area, 0, 0, -(8*unit_index)) --a vague attempt at positioning units slightly further back each time
            teleport_unit_to_location(unit_table[2], target_vector, true, true, "Line/cone vortex setup")
        end

        watch_for_vortex_ability_to_take_effect(ability_key, m_vortex_affected_units, casting_unit, checks_table, false)
        watch_for_vortex_ability_failing_to_take_effect(ability_key, m_vortex_affected_units, os.clock(), false, wind_up_time)

        casting_unit.uc:perform_special_ability_ground(ability_key, m_ground_target_area, orientation)
    end
end

--get the amount of time the vortex lasts for
local function get_vortex_duration()
    local unit_num = m_vortex_test_case.unit_with_ability.unit:unique_ui_id()
    local ability_key = m_vortex_test_case.ability_key
    local cco_vortex_record = cco("CcoBattleUnit", unit_num):Call("AbilityList.FirstContext(RecordKey == \""..ability_key.."\")"):Call("VortexRecordContext")
    return cco_vortex_record:Call("Duration")
end

--unit test might be a poor choice of name here but this is literally a test involving a unit, not unit testing in a more automated sense
--this is for regular vortex abilities, it instructs the system to teleport the next unit into the vortex area and check that it takes damage
--finish up test case is called in a battle manager callback to happen after the vortex ability has finished, otherwise the vortex might roam around and affect subsequent tests
function increment_vortex_unit_test()
    local vortex_duration = get_vortex_duration()
    if(m_vortex_tests_completed < #m_vortex_affected_units)then
        bm:out("Performing next vortex check, tests_completed: "..tostring(m_vortex_tests_completed).." affected units: "..tostring(#m_vortex_affected_units))
        m_vortex_tests_completed = m_vortex_tests_completed + 1
        perform_next_vortex_test()
    else
        bm:out("Vortex units finished! Finished correctly: "..tostring(m_vortex_units_affected_correctly_count).." total units: "..tostring(#m_vortex_affected_units))
        if(m_vortex_units_affected_correctly_count == #m_vortex_affected_units)then
            bm:callback(function() finish_up_test_case(true, m_vortex_test_case.unit_with_ability, m_vortex_test_case.ability_key) end, vortex_duration*1000)
        else
            bm:callback(function() finish_up_test_case(false, m_vortex_test_case.unit_with_ability, m_vortex_test_case.ability_key) end, vortex_duration*1000)
        end
    end
end

--sets up various member variables for a vortex test and then kicks the whole thing off
local function setup_vortex_test(test_case, gathered_units)
    bm:out("############# VORTEX ABILITY TESTING GO! ##################")
    m_vortex_test_case = test_case

    m_vortex_tests_completed = 1
    m_vortex_units_affected_correctly_count = 0

    m_vortex_affected_units = gathered_units.affects

    m_vortex_cast = false

    perform_next_vortex_test()
end

--#################################################################################
--############# END OF VORTEX TEST CASE SYSTEM ####################################
--#################################################################################


--#################################################################################
--############# ABILITY TEST CASE MANAGER SYSTEM ##################################
--#################################################################################

--returns if the ability being tested is a vortex ability
local function is_vortex(test_case)
    local unit_num = test_case.unit_with_ability.unit:unique_ui_id()
    local cco_vortex_record = cco("CcoBattleUnit", unit_num):Call("AbilityList.FirstContext(RecordKey == \""..test_case.ability_key.."\")"):Call("VortexRecordContext")
    return cco_vortex_record ~= nil
end

--returns if the ability being tested is a transform ability
local function is_transform(test_case)
    local effects_list = test_case.effects_list
    if(effects_list == nil)then
        return false
    end

    if(test_case.type_name == "Transform")then
        return true --if the ability type is "Transform" then return true
    end

    --if the ability type is not transform then its possibly mislabelled (like the cathay lords one atm) so we can check the ui effects for the word transform
    if(#effects_list.ui_effects > 0)then
        for _, effect_text in ipairs(effects_list.ui_effects) do
            if(string.find(string.lower(effect_text), "transform") ~= nil)then
                return true
            end
        end
    end
    return false
end

--works out which ability testing system to use based on the ability type then calls the necessary functions
local function execute_ability_test_cases()
    if(m_test_case_index < 0)then
        bm:out("Testing finished. Moving on.\n\n")
        ability_testing_finished_move_on()
    else
        bm:out("Executing a test in the test case table!\n\n")
        test_case = m_full_ability_test_cases_for_army[m_ability_test_index][m_test_case_index]
    
        local unit_num = test_case.unit_with_ability.unit:unique_ui_id()
        local ability_key = test_case.ability_key

        local unit_name = cco("CcoBattleUnit", unit_num):Call("Name")
        bm:out(m_ability_test_index.."."..m_test_case_index..") "..unit_name.."'s ability "..tostring(ability_key).." being tested")

        --while there's an ability type to skip (transforms atm) this is commented out to prevent unnecessary teleporting of units, instead it is called inside each if/else below
        --local gathered_units = gather_required_units(test_case.unit_with_ability, test_case.affects_list, test_case.target_type) 

        if(is_vortex(test_case))then
            local gathered_units = gather_required_units(test_case.unit_with_ability, test_case.affects_list, test_case.target_type)
            setup_vortex_test(test_case, gathered_units) --vortex testing requires some extra fanciness
        elseif(is_transform(test_case))then
            --we cant properly test transform abilities until battle code complete a request so we skip them for now (its only 3 abilities)
            bm:out(m_ability_test_index.."."..m_test_case_index..") "..unit_name.."'s ability "..tostring(ability_key).." being skipped for now because it's a pesky transform!")
            m_skipped_test_case_count = m_skipped_test_case_count + 1
            increment_test_case()
            execute_ability_test_cases()
        else
            local gathered_units = gather_required_units(test_case.unit_with_ability, test_case.affects_list, test_case.target_type)
            perform_the_test(test_case, gathered_units)
        end
    end
end

--simply checks if the players army has full winds of magic (100)
local function check_winds_of_magic_are_full()
    local maximum_winds_of_magic = 100
    local script_unit = g_script_armies[1][1]
    local unit_num = script_unit.unit:unique_ui_id()
    local player_army_cco = cco("CcoBattleUnit", unit_num):Call("ArmyContext")
    local winds_o_magic_cco = player_army_cco:Call("WindsOfMagicPoolContext")
    local winds_o_magic_number = tonumber(winds_o_magic_cco:Call("CurrentWind"))
    return winds_o_magic_number >= maximum_winds_of_magic
end

--called to verify that we are ready for testing to begin
--initially made to solve an issue where the winds of magic were still replenishing when the script tried to use the first ability
local function start_ability_testing_once_we_are_ready()
    local ready_to_start = false
    ready_to_start = check_winds_of_magic_are_full() --can add further tests as complexity grows
    if(ready_to_start)then
        bm:out("Beginning ability testing!")
        execute_ability_test_cases() --actually kicks off the ability testing, starts with the first test case in m_full_ability_test_cases_for_army and goes through every one until its finished
    else
        bm:callback(function() start_ability_testing_once_we_are_ready() end, 1000)
    end
end

--called once an ability is fully tested, either from the watch for ability pass or watch for ability failed functions
--performs some clean up and then moves onto the next test case
--one of very few functions that aren't local, simply because it was a nightmare trying to place this function as it is called by functions above but also calls functions below them
function finish_up_test_case(passed, casting_unit, ability_key)
    reset_cooldown_and_uses_for_ability_on_unit(casting_unit, ability_key)
    replenish_winds_of_magic()
    
    move_all_units_out_of_the_way() --return units to their original positions
    if(passed)then
        m_passed_test_case_count = m_passed_test_case_count +1
        bm:out("Test case "..m_ability_test_index.."."..m_test_case_index..") PASSED.\n\n")
    else
        m_failed_test_case_count = m_failed_test_case_count +1
        bm:out("Test case "..m_ability_test_index.."."..m_test_case_index..") FAILED!\n\n")
    end
    
    bm:out("Moving onto next test case!")
    increment_test_case()
    bm:callback(function() execute_ability_test_cases() end, 1000)
end

--#################################################################################
--############# END OF ABILITY TEST CASE MANAGER SYSTEM ###########################
--#################################################################################


--#################################################################################
--############# ABILITY TEST CASE GENERATION ######################################
--#################################################################################

--because the checks_table can be quite complex to understand, I created this rough guide to the structure of tables and sub-tables, might be slightly out of date but does the job!

--[[
checks_table atlas:
    result : "pending"/"na"/"pass"/"fail"
    affects_all_units :
        result : "pending"/"na"/"pass"/"fail"
        units :
            1 : 
                type : "Self"/"Enemy"/"Ally"
                result : "pending"/"na"/"pass"/"fail"
                phases :
                    result : "pending"/"na"/"pass"/"fail"
                    1 :
                        result : "pending"/"na"/"pass"/"fail"
                        effects :
                            1 : 
                                result : "pending"/"na"/"pass"/"fail"
                                stat : <stat name>
                                how : "multiplicative"/"additive"
                                value : number
                vortex : 
                    1 : 
                        result : "pending"/"na"/"pass"/"fail"
                        stat : <stat name> e.g. damage
                        value : number
                projectile : 
                    1 : 
                        result : "pending"/"na"/"pass"/"fail"
                        stat : <stat name> e.g. damage
                        value : number
]]

-- uses the TargetType text of the ability and pulls out each target in that text, stores in a table and returns that table
local function extract_target_list(unit_num, ability_key)
    local cco_battle_unit = cco("CcoBattleUnit", unit_num)
    local cco_unit_ability = cco_battle_unit:Call("AbilityList.FirstContext(RecordKey == \""..ability_key.."\")")

    local targets = {}
    local targets_length = 0
    local target_type = remove_any_icon_text(cco_unit_ability:Call("TargetType"))
    local important_bit = string.gsub(target_type, "(%s)", "") --remove any spaces

    for target in string.gmatch(important_bit, '([^,]+)') do --iterate through each thing seperated by commas
        if(target == "Aroundself")then --if the target is around self, we make it self
            target = "Self"
        end
        targets[target] = true
        targets_length = targets_length+1
    end

    return targets, targets_length
end

--gets the value of all three "affects" fields of the ability, stores in a table and returns said table
local function get_target_types_affected_by_ability(unit_num, ability_key)
    local cco_battle_unit = cco("CcoBattleUnit", unit_num)
    local cco_unit_ability = cco_battle_unit:Call("AbilityList.FirstContext(RecordKey == \""..ability_key.."\")")

    local table_of_affect_targets = {}
    table_of_affect_targets["Ally"] = cco_unit_ability:Call("AffectsAllies")
    table_of_affect_targets["Enemy"] = cco_unit_ability:Call("AffectsEnemy")
    table_of_affect_targets["Self"] = cco_unit_ability:Call("AffectsSelf")

    return table_of_affect_targets
end

--goes through each checks table and logs it to a file
--currently it is mostly hard coded to get the nice formatting and naming but in the future I'd like to try and have a slightly more generic function that achieves similar results
local function log_checks_table(checks_table, ability_key, target_type)
    write_to_file("Checks for "..tostring(ability_key).." targetting "..tostring(target_type), m_checks_full_path)
    write_to_file("\tAll checks in this test case have passed successfully? "..tostring(checks_table.result), m_checks_full_path)
    if(checks_table.affects_all_units_simple.result ~= nil)then write_to_file("\tAffects all units simple: "..tostring(checks_table.affects_all_units_simple.result), m_checks_full_path) end
    for _,unit_table in ipairs(checks_table.affects_all_units.units) do --for each unit do
        local type = unit_table.type
        local unit_result = unit_table.result

        write_to_file("\t\tAll parts of this ability affected "..tostring(type).." unit type correctly? "..tostring(unit_result), m_checks_full_path)

        if(#unit_table.phases > 0)then
            for phase_index,phases_table in ipairs(unit_table.phases)do --for each phase of this ability do
                local phase_result = phases_table.result
                write_to_file("\t\t\tAll effects of phase "..tostring(phase_index).." affected unit correctly? "..tostring(phase_result), m_checks_full_path)
                for effect_index, effect_table in ipairs(phases_table.effects) do
                    local how = effect_table.how
                    local stat = effect_table.stat
                    local value = effect_table.value 
                    local effect_result = effect_table.result
                    write_to_file("\t\t\t\t"..effect_index.." "..tostring(stat).." stat of this unit has been affected "..tostring(how).."ly by "..tostring(value).." correctly? "..tostring(effect_result), m_checks_full_path)
                end
            end
        end
        
        if(unit_table.vortex.effects ~= nil and #unit_table.vortex.effects > 0 )then
            write_to_file("\t\t\tAll vortex effects applied correctly? "..tostring(unit_table.vortex.result), m_checks_full_path)
            for _, table_table in ipairs(unit_table.vortex.effects) do
                write_to_file("\t\t\t\tVortex effect "..tostring(table_table.stat).." : "..tostring(table_table.value).." applied correctly? "..tostring(table_table.result), m_checks_full_path)
            end
        end
        
        if(unit_table.projectile.effects ~= nil and #unit_table.projectile.effects > 0)then
            write_to_file("\t\t\tAll projectile effects applied correctly? "..tostring(unit_table.projectile.result), m_checks_full_path)
            for _, table_table in ipairs(unit_table.projectile.effects) do
                write_to_file("\t\t\t\tProjectile effect "..tostring(table_table.stat).." : "..tostring(table_table.value).." applied correctly? "..tostring(table_table.result), m_checks_full_path)
            end
        end
    end

    if(checks_table.summons_correctly ~= nil)then
        write_to_file("\t\tAbility summoned a unit correctly? "..tostring(checks_table.summons_correctly.result), m_checks_full_path)
    end 
    write_to_file("", m_checks_full_path)
end

--simple function to get the size of a table that has non-integer indexes
local function get_table_size(the_table)
    local count = 0
    for _,_ in pairs(the_table)do
        count = count+1
    end
    return count
end


local m_unique_table_count = 0 --this is used to keep track of which level of recursion we are on in debug prints (it gets very VERY confusing otherwise!)
local m_delve_debug_text = false --used to easily enable and disable all the debug outputs in this function, it can get quite confusing quite quickly when it goes wrong so debug outputs are required

--in an effort to make a generic function that can handle any sort of test case now and in the future this function was born
--it will go through and do its best to work out what various checks should be set to based on the sub tables/checks within them
--if a low level check is pending then that means it is a fail (as it didnt get set to pass) and that then trickles up to later checks
--if a check is a pass though it will trickly up as a pass, unless theres another fail in which case the higher checks will be fails too!
--at the most basic level it goes through all values in a table, if it finds another table it calls this function again, using this new table as the table to delve into
--once it finds a table with no sub tables it works out the result and feeds that back up
local function recursive_table_delve_to_set_things(table_to_delve_into, count)

    local count = count or 1 --used for debug prints
    if(m_delve_debug_text)then bm:out(tostring(m_unique_table_count).."."..tostring(count)..") START!") end

    local affects_units_simple = "NO RESULT!"
    if(table_to_delve_into.affects_all_units_simple ~= nil)then
        affects_units_simple = table_to_delve_into.affects_all_units_simple.result --if this is the first table it will have an affects_all_units_simple result, in some cases we want to use this over sub results as they can be a bit whack
    end

    --some debug code to show the entire table before going any further
    if(m_delve_debug_text)then
        bm:out(tostring(m_unique_table_count).."."..tostring(count)..") Here's an atlas of this table!")
        for k,v in pairs(table_to_delve_into)do
            bm:out(tostring(k).." : "..tostring(v))
        end
        bm:out(" ")
    end
    
    local empty_sub_table_count = 0

    local failed_count, passed_count, na_count, not_implemented_count, sub_table_count = 0,0,0,0,0
    local final_result = "NO RESULT!"

    --go through all elements of this table looking for sub tables
    for table_index, table_value in pairs(table_to_delve_into) do
        if(m_delve_debug_text)then bm:out(tostring(m_unique_table_count).."."..tostring(count)..") Searching this table for sub tables! Currently checking: "..tostring(table_index)) end
        if(type(table_value) == "table" and get_table_size(table_value) > 0)then
            sub_table_count = sub_table_count + 1
            if(m_delve_debug_text)then bm:out(tostring(m_unique_table_count).."."..tostring(count)..") Delving into table: "..tostring(table_index)) end
            --if we find a sub table that isn't empty we want to go into it to find the result as this (usually) impacts the current table's result
            local sub_result = recursive_table_delve_to_set_things(table_value, count+1) --count wont quite work with multiple tables

            --because some tables have multiple sub tables with results we want to keep a tally of each sub_result for later
            if(sub_result == "failed" or sub_result == "pending")then
                failed_count = failed_count + 1
            elseif(sub_result == "passed")then
                passed_count = passed_count + 1
            elseif(sub_result == "N/A")then
                na_count = na_count + 1
            elseif(sub_result == "Not Implemented")then
                not_implemented_count = not_implemented_count + 1
            end

        elseif(type(table_value) == "table" and get_table_size(table_value) < 1)then
            --if we find a sub table with 0 size then we ignore it but count how many empty sub tables there were
            sub_table_count = sub_table_count + 1
            if(m_delve_debug_text)then bm:out(tostring(m_unique_table_count).."."..tostring(count)..") empty table found! "..tostring(table_index)) end
            empty_sub_table_count = empty_sub_table_count + 1
        end
    end

    if(sub_table_count > 0)then
        --if there were any sub tables we need to work out what to set this table (and the above table if there is one) to from the multiple results
        if(failed_count > 0)then
            --if ANY of the results were a fail then the parent table (this one) should also be a fail
            if(m_delve_debug_text)then bm:out(tostring(m_unique_table_count).."."..tostring(count).." Failed count over 1") end
            final_result = "failed"
        elseif(passed_count > 0 or na_count > 0)then
            --for now we count N/As as passes
            if(m_delve_debug_text)then bm:out(tostring(m_unique_table_count).."."..tostring(count).." Passed or N/A count over 1") end
            final_result = "passed"
        elseif(not_implemented_count > 0)then
            --if there are no passes or fails then we want to check the Not Implementeds
            if(m_delve_debug_text)then bm:out(tostring(m_unique_table_count).."."..tostring(count).." Not Implemented count over 1") end
            final_result = "Not Implemented"
        elseif(empty_sub_table_count > 0)then
            --finally if there was nothing but empty sub tables we want to ignore the sub tables and it usually means that there aren't any valid checks so we set this table to N/A
            if(m_delve_debug_text)then bm:out(tostring(m_unique_table_count).."."..tostring(count).." Empty sub table count over 1") end
            final_result = "N/A"
        end
    end

    if(final_result == "NO RESULT!")then
        if(m_delve_debug_text)then bm:out(tostring(m_unique_table_count).."."..tostring(count).." Final result is NO RESULT!, having to work this out ourselves!") end
        --there were no sub tables so we have to sort this mess out ourselves!
        local current_result = table_to_delve_into.result
        if(affects_units_simple ~= "NO RESULT!" and affects_units_simple ~= "pending")then
            --if we've reached this point then there were no valid sub tables and there was an affects_all_units_simple which means it's the top level table with no other checks, in which case, we want to use the affects_units_simple result
            if(m_delve_debug_text)then bm:out(tostring(m_unique_table_count).."."..tostring(count)..") SIMPLE CHECK BEING USED: "..tostring(affects_units_simple)) end
            final_result = affects_units_simple
        elseif(current_result == "pending" or current_result == "failed")then
            --if there is a pending result we set it to failed, this is because tests that pass usually set the result to passed, so a pending means the check didnt pass (in some cases we set them to fail when they fail)
            if(m_delve_debug_text)then bm:out(tostring(m_unique_table_count).."."..tostring(count)..") Pending/Failed (Actually: "..tostring(current_result)..")") end
            final_result = "failed"
        elseif(current_result == "passed" or current_result == "N/A")then
            if(m_delve_debug_text)then bm:out(tostring(m_unique_table_count).."."..tostring(count)..") Passed") end
            final_result = "passed"
        elseif(current_result == "Not Implemented")then
            if(m_delve_debug_text)then bm:out(tostring(m_unique_table_count).."."..tostring(count)..") Not Implemented") end
            final_result = "Not Implemented"
        end
    end

    if(table_to_delve_into.result ~= nil and final_result ~= "NO RESULT!")then
        --if this table has a result element and the final_result isnt "NO RESULT" then set the result to final_result
        if(m_delve_debug_text)then bm:out(tostring(m_unique_table_count).."."..tostring(count).." setting this tables result to: "..tostring(final_result)) end
        table_to_delve_into.result = final_result
    end

    if(m_delve_debug_text)then bm:out(tostring(m_unique_table_count).."."..tostring(count)..") Returning: "..tostring(final_result)) end
    return final_result
end

--rather complicated function that generates the table of checks for an ability (i.e. the actual tests that will be run such as "does the ability reduce enemy targets speed stat by 10")
--goes through and works out the checks for each unit based on the type of ability and what effects it has
--currently creates different tables for phases+effects, summons, vortex and projectiles, it is set up in such a way that if an ability has phases+effects and is a vortex it will create all test cases
--however in all my testing I've not found an ability that combines more than one of the above types so it is technically untested if it actually handles such abilities
local function generate_table_of_checks(affects_list, effects_list)
    local affects_list_indexed = {}
    local is_summon = is_summon(effects_list)
    for unit_type,_ in pairs(affects_list) do --the affects_list is structured with a unit type and a boolean value true, this allows for quick and easy searching, but for this we want them indexed
        table.insert(affects_list_indexed, unit_type)
    end

    local has_effects_to_check = false
    local has_vortex_to_check = false
    local has_projectile_to_check = false
    
    --create the initial table of checks and create highest level tests of affects all units and affects all units simple
    local table_of_checks = {}
    table_of_checks["result"] = "pending" --result depends on every check passing (if one fails this is a fail)
    table_of_checks["affects_all_units"] = {
        ["result"] = "pending", --pass/fail for ALL effects in ALL phases, vortex, projectiles on ALL units
        ["units"] = {}
    }
    table_of_checks["affects_all_units_simple"] = {
        ["result"] = "pending" --pass/fail for the ability simply applying correctly to all units i.e. it appears as an active ability affecting them/causes direct damage
    }
    
    --summons are pretty basic for now "did it summon a unit" yes or no
    if(is_summon)then
        table_of_checks["summons_correctly"] = {}
        table_of_checks.summons_correctly["result"] = "pending"
        table_of_checks["affects_all_units_simple"] = {}
    end
    
    for _, unit_type in ipairs(affects_list_indexed) do
        local affected_type_index = #table_of_checks.affects_all_units.units+1
        table_of_checks.affects_all_units.units[affected_type_index] = {}
        table_of_checks.affects_all_units.units[affected_type_index].type = unit_type
        table_of_checks.affects_all_units.units[affected_type_index].result = "pending" --pass/fail for ALL effects in all phases, vortex, projectiles applying

        table_of_checks.affects_all_units.units[affected_type_index].phases = {}
        table_of_checks.affects_all_units.units[affected_type_index].phases.result = "pending" --pass/fail for all effects in all phases applying
        for phase_index, phase_table in ipairs(effects_list.phases) do
            table_of_checks.affects_all_units.units[affected_type_index].phases[phase_index] = {}
            table_of_checks.affects_all_units.units[affected_type_index].phases[phase_index].effects = {}
            table_of_checks.affects_all_units.units[affected_type_index].phases[phase_index].result = "pending" --the pass/fail for all effects in this phase applying
            for _, effect_table in ipairs(phase_table.effects) do
                has_effects_to_check = true
                local temp_table = {}
                local stat = effect_table.stat --stat is the stat this effect targets e.g. speed
                local how = effect_table.how --how is how this effect modifies the stat, either multiplicative or addition
                local value = effect_table.value --value is how much the effect modifies the stat
                --single effect check should include the three bits of effect info and a passed field
                temp_table["stat"] = stat
                temp_table["how"] = how
                temp_table["value"] = value 
                temp_table["result"] = "pending"
                table.insert(table_of_checks.affects_all_units.units[affected_type_index].phases[phase_index].effects, temp_table)
            end

            --by and large we can't test any of the effects from UI effects or other effects, but we CAN test for damage effects so we want to look for and test that
            for _, other_effect_table in ipairs(phase_table.other_effects)do
                local other_effect_name = other_effect_table[1]
                local other_effect_value = other_effect_table[2]
                if(other_effect_name == "Damage" and other_effect_value > 0)then
                    has_effects_to_check = true
                    local temp_table = {}
                    temp_table["result"] = "pending"
                    temp_table["stat"] = "damage"
                    temp_table["how"] = "direct"
                    temp_table["value"] = other_effect_value
                    table.insert(table_of_checks.affects_all_units.units[affected_type_index].phases[phase_index].effects, temp_table)
                    break
                end
            end
        end

        if(has_effects_to_check == false)then
            --no effects we can test in this ability, make the phases table empty (useful later)
            no_checks_for_unit = true
            table_of_checks.affects_all_units.units[affected_type_index].phases = {}
        end

        table_of_checks.affects_all_units.units[affected_type_index].vortex = {}
        table_of_checks.affects_all_units.units[affected_type_index].vortex.effects = {}
        table_of_checks.affects_all_units.units[affected_type_index].vortex.result = "pending" 
        for vortex_index, vortex_effect_table in ipairs(effects_list.vortex_effects)do
            has_vortex_to_check = true
            local vortex_effect = vortex_effect_table[1]
            local vortex_effect_value = vortex_effect_table[2]
            local temp_table = {}
            temp_table["stat"] = vortex_effect
            temp_table["value"] = vortex_effect_value
            temp_table["result"] = "pending"
            table.insert(table_of_checks.affects_all_units.units[affected_type_index].vortex.effects, temp_table)
        end

        if(has_vortex_to_check == false)then
            --no vortex things to check, make the vortex table empty
            table_of_checks.affects_all_units.units[affected_type_index].vortex = {}
        end

        table_of_checks.affects_all_units.units[affected_type_index].projectile = {}
        table_of_checks.affects_all_units.units[affected_type_index].projectile.effects = {}
        table_of_checks.affects_all_units.units[affected_type_index].projectile.result = "pending"
        for _, projectile_effect_table in ipairs(effects_list.projectile_effects)do
            has_projectile_to_check = true
            local projectile_effect = projectile_effect_table[1]
            local projectile_effect_value = projectile_effect_table[2]
            local temp_table = {}
            temp_table["stat"] = projectile_effect
            temp_table["value"] = projectile_effect_value
            temp_table["result"] = "pending"
            table.insert(table_of_checks.affects_all_units.units[affected_type_index].projectile.effects, temp_table)
        end

        if(has_projectile_to_check == false)then
            --no projectie things to check, make the projectile table empty
            table_of_checks.affects_all_units.units[affected_type_index].projectile = {}
        end

        if(has_effects_to_check == false and has_projectile_to_check == false and has_vortex_to_check == false)then
            --this unit has no actual checks, remove the unit from the table entirely (otherwise it causes issues later on when working out pass/fails)
            table_of_checks.affects_all_units.units[affected_type_index] = nil
        end
    end

    return table_of_checks
end

--generates the entire test case for an ability, in this instance a test case includes not only tests/checks (the actual tests to be run) but also all information related to/required for testing this ability
--gets the list of target types then goes through each target creating a test case for each one
--essentially, an ability can target one target type per activation (ground, self, enemy, etc) but can potentially affect multiple target types with its activation
-- so an ability might be able to target enemy or Ally and affect enemy and Ally, 
-- so two test cases would be generated, one targetting enemy and checking the effects apply to enemy and Ally and the second targetting Ally and checking the effects apply to enemy and Ally
-- so to fully test that ability the system would need to get the casting unit, enemy unit and Ally unit together, activate the ability once and target the enemy, check it affects both, reset everything and cast again, targetting the Ally
-- in order for the system to know it needs to do that we create the test cases below with all the information it could need
local function generate_ability_test_cases(script_unit, ability_key)
    local unit_num = script_unit.unit:unique_ui_id()
    local cco_battle_unit = cco("CcoBattleUnit", unit_num)
    local cco_unit_ability = cco_battle_unit:Call("AbilityList.FirstContext(RecordKey == \""..ability_key.."\")")

    local target_list, _ = extract_target_list(unit_num, ability_key)
    local affects_list = get_target_types_affected_by_ability(unit_num, ability_key)
    local test_cases = {}

    --number of test cases == number of targets
    --test case will contain a single target and one or more affect targets
    for target, _ in pairs(target_list) do
        local test_case = {}

        test_case["target_type"] = target 
        test_case["is_targeted"] = cco_unit_ability:Call("IsTargetedAbility")
        test_case["type_name"] = remove_any_icon_text(cco_unit_ability:Call("TypeName"))
        test_case["ability_key"] = ability_key
        test_case["unit_with_ability"] = script_unit
        test_case["wind_up_time"] = cco_unit_ability:Call("WindUpTime")

        local affects = {}
        local affects_only_target = true

        if(cco_unit_ability:Call("EffectRange") > 0 or cco_unit_ability:Call("VortexRecordContext") ~= nil or cco_unit_ability:Call("BombardmentRecordContext") ~= nil)then
            --if effectRange isn't 0 then it affects all target types listed, not just the one targetted by the ability
            affects_only_target = false
        end

        for affect_target, value in pairs(affects_list) do
            if(value == true)then
                --check the effect range
                if(affects_only_target and target == affect_target)then
                    --bm:out("Only affects the target and we've found a match!")
                    affects[affect_target] = true
                    break
                elseif(not affects_only_target)then
                    affects[affect_target] = true
                end
            end
        end

        test_case["affects_list"] = affects 
        test_case["effects_list"] = get_ability_effects(unit_num, ability_key)
        test_case["checks_table"] = generate_table_of_checks(test_case["affects_list"], test_case["effects_list"]) --store the actual checks/tests in the checks_table

        table.insert(test_cases, test_case)
    end

    return test_cases
end

--#################################################################################
--############# END OF ABILITY TEST CASE GENERATION ###############################
--#################################################################################


--#################################################################################
--############# ABILITY STATS GETTING #############################################
--#################################################################################

--a simple function that gets all the useful stats for an ability by iterating through a table of commands to pass into a cco call
--it then logs each stat + value to the ability stats text file for later comparison checks
local function log_ability_stats(unit_num, ability_key)
    local cco_battle_unit = cco("CcoBattleUnit", unit_num)
    local cco_unit_ability = cco_battle_unit:Call("AbilityList.FirstContext(RecordKey == \""..ability_key.."\")")
    --use this function to test getting various things about abilities and doing stuff with them
    local table_of_commands = {
        ["name"] = "Name",
        ["affectsSelf"] = "AffectsSelf",
        ["affectsEnemy"] = "AffectsEnemy",
        ["affectsAlly"] = "AffectsAllies",
        ["hasEnabledIfs"] = "HasEnabledIfFlags",
        ["hasInvalidTargetFlags"] = "HasInvalidTargetFlags",
        ["hasInvalidUsageFlags"] = "HasInvalidUsageFlags",
        ["isTargeted"] = "IsTargetedAbility",
        ["targetType"] = "TargetType",
        ["isPassive"] = "IsPassive",
        ["typeName"] = "TypeName",
        ["hasAdditionalUiEffects"] = "HasAdditionalUiEffects",
        ["duration"] = "ActiveTime",
        ["castRange"] = "CastRange",
        ["effectRange"] = "EffectRange",
        ["manaUsed"] = "ManaUsed",
        ["miscastChance"] = "MiscastChance",
        ["minimumRange"] = "MinimumRange",
        ["numberOfUses"] = "NumUses",
        ["rechargeTime"] = "RechargeTime",
        ["spreadRange"] = "SpreadRange",
        ["targetRange"] = "TargetRange",
        ["windUpTime"] = "WindUpTime"
    }

    for name, command in pairs(table_of_commands) do
        local stat_value = cco_unit_ability:Call(command)
        --bm:out(tostring(name))
        --bm:out(tostring(stat_value))
        write_to_file(">>>Stat:"..tostring(name)..":"..tostring(stat_value), m_abilities_log_full_path)
    end
end

--goes through each test case and calls recursive_table_delve_to_set_things() on the checks_table
--during testing most results are set to pass when the ability test works or left as pending, this then goes through and sets all pendings to fails and works out what the higher up checks will be
--contains some debug text that is enabled with m_delve_debug_text
function finalise_test_check_results()
    if(m_delve_debug_text)then bm:out("Sorting out results of all test cases! Length = "..tostring(#m_full_ability_test_cases_for_army)) end
    for ability_index, ability_table in ipairs(m_full_ability_test_cases_for_army) do
        if(m_delve_debug_text)then  bm:out("Ability "..tostring(ability_index)) end
        for test_case_index, test_case_table in ipairs(ability_table)do
            local checks_table = test_case_table.checks_table
            if(m_delve_debug_text)then  bm:out("Test case "..tostring(test_case_index).." for ability: "..tostring(test_case_table.ability_key)) end
            m_unique_table_count = m_unique_table_count + 1 --used for debugging
            recursive_table_delve_to_set_things(checks_table)
        end
    end
end

function log_checks_to_file()
    bm:out("Logging all test cases!")

    write_to_file("Tested "..tostring(m_ability_test_case_finished_index).." out of "..tostring(#m_full_ability_test_cases_for_army).." abilities successfully.", m_checks_full_path)

    write_to_file("Total test cases: "..tostring(m_total_test_case_count).."\nPassed: "..tostring(m_passed_test_case_count).."\nFailed: "..tostring(m_failed_test_case_count)
    .."\nSkipped: "..tostring(m_skipped_test_case_count).."\n----------------------------------------------------------------------\n\n", m_checks_full_path)

    for _, ability_table in ipairs(m_full_ability_test_cases_for_army) do
        for _, test_case_table in ipairs(ability_table)do
            local checks_table = test_case_table.checks_table
            bm:out("Logging checks for ability "..tostring(test_case_table.ability_key))
            log_checks_table(checks_table, test_case_table.ability_key, test_case_table.target_type)
        end
    end
end

--creates the ability test cases, logs some ability stats and then kicks off the ability testing
local function begin_ability_testing(army_number)
    m_full_ability_test_cases_for_army = {}
    m_full_ability_test_case_count = 0
    for _, unit in pairs(g_script_armies[army_number])do --for each unit in the army
        local unit_num = unit.unit:unique_ui_id() --gets the unit number e.g. 1001
        local cco_battle_unit = cco("CcoBattleUnit", unit_num)
        local unit_name = cco_battle_unit:Call("Name")

        write_to_file("\n\n>Unit: "..tostring(unit_name), m_abilities_log_full_path)--write unit name to file for later

        --local passive_abilities_list = unit.unit:owned_passive_special_abilities() --currently unused but will be used come version 2.0!
        local active_abilities_list = unit.unit:owned_non_passive_special_abilities() --returns a table of ability keys
        --local abilities_list = unit.unit:owned_special_abilities() --currently unused but kept in for future reference
    
        if(active_abilities_list ~= nil and #active_abilities_list > 0)then --if there is at least one ability in the active ability list  
            for _,ability_key in ipairs(active_abilities_list) do
                write_to_file(">>Ability: "..tostring(ability_key), m_abilities_log_full_path)--write this ability to the file for later comparison

                log_ability_stats(unit_num, ability_key) --this function logs all the ability stats to the file

                local temp_test_cases = generate_ability_test_cases(unit, ability_key) --create all the test cases for this ability

                table.insert(m_full_ability_test_cases_for_army, temp_test_cases) --store the test cases in the main table for all test cases
                m_full_ability_test_case_count = m_full_ability_test_case_count + #temp_test_cases
            end
        end
    end

    bm:out("Test cases for active abilities generated, amount of test cases generated: "..tostring(m_full_ability_test_case_count).." across "..tostring(#m_full_ability_test_cases_for_army).." abilities")      
    
    if(m_skip_ability_testing)then
        ability_testing_finished_move_on()
    else
        setup_for_ability_tests() --perform some initial setup before we start testing
        start_ability_testing_once_we_are_ready()  
    end
end

--#################################################################################
--############# END OF ABILITY STATS ##############################################
--#################################################################################


--#################################################################################
--############# FUNCTIONS THAT START IT ALL #######################################
--#################################################################################

--function is called when deployment ends (the battle starts)
--all the actual testing and functionality starts here
local function begin_testing()
    log_all_stats_in_army(1) --get all the stats in army 1, stores them in the m_stat_csv_file table
    csv_file_handler.write_to_file(m_stat_csv_file, m_stat_log_full_path)
    begin_ability_testing(1)
    
    --script "ends" here, that is because within the ability testing we need various delays and waits, which we can only achieve through battle manager callbacks/watches
    --so at this point the script has no further functions to call, but after ability testing normal functionality resumes from the function ability_testing_finished_move_on()
end

--this is the function that gets called when this file is loaded, it starts everything
local function start_bedsat()
    if(not m_skip_comparison)then --if we want to run the python comparison script we need to setup the file path and install the modules if they arent already
        setup_python_file_path()
        initiate_python_module_installation()
    end
    
    bm:out("\nBattle \nEntered \nDo \nSome \nAbility \nTesting \n\nGOOOOOO!!") --Battle Entered, Do Some Ability Testing
    setup_armies() --create and populate script army tables, allows for each access of units
    create_stats_log_file() --setup the log file for the stats
    create_ability_log_file() --setup the log file for abilities
    create_checks_output_file() --setup the file for logging check results
    bm:register_phase_change_callback("Deployed", begin_testing) --we dont want to start testing until the battle enters the Deployed stage (where fighting happens)
end

--#################################################################################
--############# END OF FUNCTIONS THAT START IT ALL ################################
--#################################################################################


--####################################################################################
--############### EVERYTHING HERE IS CALLED WHEN THE SCRIPT LOADS ####################
--####################################################################################

start_bedsat()

--####################################################################################
--############### END OF THINGS THAT ARE CALLED WHEN THE SCRIPT LOADS ################
--####################################################################################