require "script.autotest.lib.all"

--## Global Variables ##--
g_manual_battles = true

--## Local Variables ##--
local variables = {}
variables.campaign_type = "The Realm of Chaos"
variables.max_turns = 5
variables.battle_duration = 300
variables.fight_campaign_battle = true

--## Script Start ##--
Lib.Helpers.Init.script_name("Compat WH3 Denuvo Performance")

--## MULTIPLAYER TESTS ##--
--Soon™

--## SINGLEPLAYER TESTS ##--
Lib.Compat.Misc.campaign_smoke_test(variables.fight_campaign_battle, variables.campaign_type, variables.max_turns, variables.battle_duration)
Lib.Compat.Misc.custom_battle_smoke_test(variables.battle_duration)

Lib.Frontend.Misc.quit_to_windows()