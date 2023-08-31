require "data.script.autotest.lib.all"

--####################################
--####### Variables and such #########
--####################################

g_commandStillRunning = false --determines if the gsat action succeeded
local appdata = os.getenv("APPDATA")
local commandFilePath = appdata.."\\CA_Autotest\\pasta_data\\gsat_interface\\gsat_command.txt"
local responseFilePath = appdata.."\\CA_Autotest\\pasta_data\\gsat_interface"
local responseFileName = "gsat_response"

--####################################
--#### Functions exposed to Pasta ####
--####################################

--these functions are exposed to Pasta (they are in the commands table below)
--each function here needs to accept a single parameter called parametersTable
--each function is responsible for unpacking that table and putting the right variables in the right place
--each function has a comment above it explaining what parameters it requires and the order
--in Pasta, paramaters must be delimited by a > e.g. parameter1>parameter2>parameter3,this is the same paramater>parameter4

--Parameter 1: Component Path
--Parameter 2: Component Name/Alias (Optional)
--Description: finds and clicks a component
local function ClickComponentPasta(parametersTable)
    callback(function() 
        local alias = "component"
        if(#parametersTable > 1)then
            alias = parametersTable[2]
        end
        Common_Actions.click_component(Functions.find_component(parametersTable[1]), alias, true) 
    end)

    callback(function() 
        g_commandStillRunning = false
    end)
end

--Parameter 1: None
--Description: Exits from the front end, clicking exit button and confirming on the popup
local function ExitFromFrontEndPasta(parametersTable)
    callback(function() 
        Utilities.print("Quitting to windows!")
        Functions.write_to_document("quitting from Front end", responseFilePath, responseFileName, ".txt", true, false, false)
    end)

    callback(function() 
        Lib.Frontend.Misc.quit_to_windows()
    end)

    callback(function() 
        g_commandStillRunning = false
    end)
end

--Parameter 1: Context Command
--Description: Calls the specified context command, e.g FrontendRoot.StartCampaign("wh3_main_chaos","wh3_main_cth_the_western_provinces","")
local function ContextCommandPasta(parametersTable)
    callback(function() 
        common.get_context_value(parametersTable[1])
    end)

    callback(function() 
        g_commandStillRunning = false
    end)
end

--Parameter 1: Console Command
--Description: Calls a console command (the commands that normally go into the game console)
local function ConsoleCommandPasta(parametersTable)
    callback(function() 
        Common_Actions.trigger_console_command(parametersTable[1])
    end)

    callback(function() 
        g_commandStillRunning = false
    end)
end

--Paramter 1: Name of enemy character to teleport to e.g. Durthu
--Description: Teleports faction leader of players faction to named character
local function TeleportFactionLeaderToNamedCharacterPasta(parametersTable)
    callback(function ()
        Lib.Campaign.Actions.TeleportToNamedCharacter(parametersTable[1])
    end)

    callback(function() 
        g_commandStillRunning = false
    end)
end

--Parameter 1: A list of units to add to the character, delimited by a ,
--Parameter 2: (Optional) The name of the character you want to add units to e.g. Durthu, defaults to player faction leader if not specified
--Description: Debug gives units to specified leader, or faction leader
local function GiveUnitsToCharacterPasta(parametersTable)
    callback(function ()
        local characterName = ""
        local unitList = Utilities.split(parametersTable[1], ",")

        if(#parametersTable > 1)then
            characterName = parametersTable[2]
        end
        Lib.Campaign.Actions.GiveUnitsToArmy(unitList, characterName)
    end)

    callback(function() 
        g_commandStillRunning = false
    end)
end

--Parameter 1: A keyboard shortcut e.g. ESCAPE
--Description: Simulates a key press in game, primarily used to press the escape key
local function TriggerShortcutPasta(parametersTable)
    callback(function()
        Common_Actions.trigger_shortcut(parametersTable[1])
    end)

    callback(function() 
        g_commandStillRunning = false
    end)
end

--called by the DetectComponentPasta function below
--created a local version of this function so we have better control over what exactly it does for the Pasta interface
local function waitForComponent(componentPath, counter)
    local component
    callback(function()
        component = Functions.find_component(componentPath)
    end)

    callback(function ()
        if(component ~= nil and component:Visible(true))then
            return true
        else
            callback(function ()
                if(counter >= 10) then --prints out every 10th time
                    Utilities.print("Looking for component: "..tostring(componentPath))
                    counter = 0
                end
                waitForComponent(componentPath, counter+1)
            end)
        end
    end)
end

--Parameter 1: Component Path
--Description: Loops until the specified component is found
local function DetectComponentPasta(parametersTable)
    callback(function()
        Utilities.print("Looking for: "..tostring(parametersTable[1]))
        waitForComponent(parametersTable[1], 10) --pass in 10 to trigger print first time
    end)

    callback(function() 
        g_commandStillRunning = false
    end)
end

--####################################
--####### Table of Functions #########
--####################################

--this is the lookup table of commands exposed to Pasta
--if the function is in this table, it will not get called by pasta
--format: [name to put in pasta that calls this function] = name of the function in this file to be called
local commands = {
    ["clickComponent"] = ClickComponentPasta,
    ["quitToWindowsFE"] = ExitFromFrontEndPasta,
    ["contextCommand"] = ContextCommandPasta,
    ["consoleCommand"] = ConsoleCommandPasta,
    ["teleportToCharacter"] = TeleportFactionLeaderToNamedCharacterPasta,
    ["setupArmy"] = GiveUnitsToCharacterPasta,
    ["triggerShortcut"] = TriggerShortcutPasta,
    ["detectComponent"] = DetectComponentPasta,
}

--####################################
--####### Supporting functions #######
--####################################


--continously checks if the file exists and recursively loops until it does
local function CheckForFileRecursiveLoop(counter)
    callback(function() 
        if(Functions.check_file_exists(commandFilePath) == false) then
            Lib.Helpers.Misc.wait(1, true)
            if(counter >= 10) then --prints out every 10th time (aka every 10 seconds)
                Utilities.print("Waiting for gsat_command.txt file")
                counter = 0
            end
            callback(function() CheckForFileRecursiveLoop(counter+1) end)
        end
    end)
end


--the main loop, will infinitely loop recursively
--once a command file exists it reads in the single line and splits it on the | symbol
--it then looks to see if the parameters are delimted with a > and splits them on that symbol if so
--note: we don't use commas, colons or similar because component paths and context commands can contain them
--it then finds the command in the "commands" table, using the provided command key and calls the function associated with the key
--all parameters are passed into the function as a single table to make the system generic (can technically pass unlimited parameters to a function and the system handles it)
--the parameters table is then used/split out in the individual function
local function PastaExecuteLoop()
    callback(function() 
        --loop until file exists
        callback(function() CheckForFileRecursiveLoop(10) end) --pass in 10 to instantly trigger the print out the first time
        
        callback(function() 
            --read in file
            local lines = Utilities.get_contents(commandFilePath)
            callback(function() os.remove(commandFilePath) end)

            --split line
            local functionParamsSplit = Utilities.split(lines[1], "|")

            local commandKey = tostring(functionParamsSplit[1])
            local commandParams = tostring(functionParamsSplit[2])
            Utilities.print("Executing Command: "..commandKey)
            Utilities.print("With Parameters: "..commandParams)

            --call function via table, passing split params
            --g_commandStillRunning = true --set this to true before we call the command
            commands[commandKey](Utilities.split(commandParams, ">"))
        end)
        
        --check if g_commandStillRunning is false, meaning the command didn't successfully get called
        --write a file that gets picked up by the WaitForGsatResponse Pasta Node
        --note: Currently the contents of the file isn't used by Pasta, so either file will result in the WaitForGsatResponse Node returning true
        callback(function() 
            if (g_commandStillRunning == false) then
                --the function ran proper, write a file of success
                callback(function() Functions.write_to_document("success", responseFilePath, responseFileName, ".txt", true, false, false) end)
            else
                --the function didnt run proper, write a file of failure
                callback(function() Functions.write_to_document("failure", responseFilePath, responseFileName, ".txt", true, false, false) end)
            end
            PastaExecuteLoop()--call this function again, looping infinitely 
        end)
    end) 
end

--####################################
--########## Actual Script ###########
--####################################

Lib.Helpers.Init.script_name("WH3 Pasta Interface")
Lib.Frontend.Misc.ensure_frontend_loaded()
callback(function() PastaExecuteLoop() end)
callback(function() Utilities.print("Script Finished") end) --theoretically this line will never be reached as the PastaExecuteLoop will loop infinitely