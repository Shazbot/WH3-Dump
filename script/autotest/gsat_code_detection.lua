-- How to run GSAT Scripts - http://totalwar-confluence:8090/pages/viewpage.action?pageId=16123828
-- How to create GSAT Scripts -  http://totalwar-confluence:8090/pages/viewpage.action?pageId=27541925

require "data.script.autotest.lib.all"

Lib.Helpers.Init.script_name("Code Detection")
Lib.Frontend.Misc.ensure_frontend_loaded()

add_event_listener(
    "FirstTickAfterWorldCreated",
    true,
    function(context)
        character_select_listener()
        settlement_selected_listener()
    end,
    true
)
 
function character_select_listener()
    add_event_listener(
        "CharacterSelected",
        true,
        function(context)
            Utilities.print('Character - ' .. context:character():get_forename() .. ' selected, Faction : ' .. context:character():faction():name())
        end,
        true
    )
end

function settlement_selected_listener()
    add_event_listener(
        "SettlementSelected",
        true,
        function(context)
            Utilities.print('Region - ' .. context:garrison_residence():region():name()..' selected, Faction : ' .. context:garrison_residence():faction():name())
        end,
        true
    )
end