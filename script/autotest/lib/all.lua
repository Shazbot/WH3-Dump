-- this flag is used in all_scripted.lua when remapping outputs
__is_autotest = true;

-- force loading of all_scripted
do
	local filepath = "script.all_scripted"
	package.loaded[filepath] = nil;
	require(filepath);
end;


__game_mode = __lib_type_autotest;


load_script_libraries();


Timers = real_timer;

require "script.autotest.common.backend"

Lib =
{
    Components =
    {
        Frontend = {},
        Campaign = {},
        Battle = {},
        Menu = {},
        Helpers = {}
    },
	DAVE_Database = 
	{
		Misc = {}
	},
	Elastic = 
	{
		Misc = {}
	},
    Frontend =
    {
        Misc = {},
        Campaign = {},
        Loaders = {},
        Tables = {},
        Custom_Battle = {},
        Quest_Battle = {},
        Clicks = {},
        Options = {},
        Load_Campaign = {}
    },

    Campaign = {
        Misc = {},
        Clicks = {},
        Tables = {},
        Actions = {},
        Faction_Info = {},
        Settlements = {},
        Characters = {},
        Technology = {},
        Diplomacy = {},
        Behaviours = {},
        Playthrough_Tracker = {}
    },

    Battle = {
        Misc = {},
        Clicks = {},
        Scripted_Events = {},
        Unit_Controller = {},
        Tables = {}
    },

    Menu = {
        Misc = {},
        Clicks = {}
    },

    Helpers =
    {
        Init = {},
        Misc = {},
        Loops = {},
        Clicks = {},
        UI_Sweeps = {},
        Timers = {},
		Test_Cases = {}
    },

    Compat =
    {
        Downgrading = {},
        Sweep = {},
        Misc = {},
        Loops = {},
        Tables = {},
        Loading_Times = {}
    }

}

-- Components
require "script.autotest.lib.components.frontend"
require "script.autotest.lib.components.campaign"
require "script.autotest.lib.components.battle"
require "script.autotest.lib.components.menu"
require "script.autotest.lib.components.helpers"

-- DAVE_Database
require "script.autotest.lib.dave_database.misc"

-- Elastic
require "script.autotest.lib.elastic.misc"

-- Frontend
require "script.autotest.lib.frontend.misc"
require "script.autotest.lib.frontend.campaign"
require "script.autotest.lib.frontend.loaders"
require "script.autotest.lib.frontend.tables"
require "script.autotest.lib.frontend.custom_battle"
require "script.autotest.lib.frontend.quest_battle"
require "script.autotest.lib.frontend.clicks"
require "script.autotest.lib.frontend.options"
require "script.autotest.lib.frontend.load_campaign"

-- Campaign
require "script.autotest.lib.campaign.misc"
require "script.autotest.lib.campaign.clicks"
require "script.autotest.lib.campaign.tables"
require "script.autotest.lib.campaign.actions"
require "script.autotest.lib.campaign.faction_info"
require "script.autotest.lib.campaign.settlements"
require "script.autotest.lib.campaign.characters"
require "script.autotest.lib.campaign.technology"
require "script.autotest.lib.campaign.diplomacy"
require "script.autotest.lib.campaign.behaviours"
require "script.autotest.lib.campaign.playthrough_tracker"

-- Battle
require "script.autotest.lib.battle.misc"
require "script.autotest.lib.battle.clicks"
require "script.autotest.lib.battle.scripted_events"
require "script.autotest.lib.battle.unit_controller"
require "script.autotest.lib.battle.tables"

-- Menu
require "script.autotest.lib.menu.misc"
require "script.autotest.lib.menu.clicks"

-- Helpers
require "script.autotest.lib.helpers.init"
require "script.autotest.lib.helpers.misc"
require "script.autotest.lib.helpers.loops"
require "script.autotest.lib.helpers.clicks"
require "script.autotest.lib.helpers.ui_sweeps"
require "script.autotest.lib.helpers.timers"
require "script.autotest.lib.helpers.test_cases"

-- Compat
require "script.autotest.lib.compat.downgrading"
require "script.autotest.lib.compat.sweep"
require "script.autotest.lib.compat.misc"
require "script.autotest.lib.compat.loops"
require "script.autotest.lib.compat.tables"
require "script.autotest.lib.compat.loading_times"