-- How to run GSAT Scripts - http://totalwar-confluence:8090/pages/viewpage.action?pageId=16123828
-- How to create GSAT Scripts -  http://totalwar-confluence:8090/pages/viewpage.action?pageId=27541925

require "data.script.autotest.lib.all"

-- variables_file: chaos_campaign_variables.txt

local variables = {}

variables.lord = cv_lord or "Random"
variables.campaign_type = cv_campaign_type
variables.max_turns = cv_max_turns or 20
variables.ai_auto_end_turn = cv_ai_auto_end_turn or false
variables.load_most_recent_save = cv_load_most_recent_save or false
variables.fight_starting_battle = cv_fight_starting_battle or false

variables.screenshot_events = cv_screenshot_events or false
variables.log_events = cv_event_logging or false
variables.network_save_path = cv_network_save_location
variables.network_save_file_name = cv_network_save_name
variables.manual_battles = cv_manual_battles or false
variables.force_victory = cv_force_victory or false

variables.raise_army = cv_raise_army or "Random"
variables.recruit_units = cv_recruit_units or "Random"
variables.upgrade_settlements = cv_upgrade_settlements or "Random"
variables.research_tech = cv_research_tech or "Random" 
variables.initiate_diplomacy = cv_initiate_diplomacy or "Random" 
variables.fight_battles = cv_fight_battles or "Random"
------------------------------------------------

g_screenshot_events = variables.screenshot_events
g_log_events = variables.log_events
g_network_save_path = variables.network_save_path
g_network_save_file_name = variables.network_save_file_name
g_manual_battles = variables.manual_battles
g_force_victory = variables.force_victory

g_test_case_table = g_test_case_holder["campaign_progression_tests"]

Lib.Campaign.Behaviours.set_action_weights(variables.raise_army, variables.recruit_units, variables.upgrade_settlements, variables.research_tech, variables.initiate_diplomacy, variables.fight_battles, variables.fight_starting_battle)

Lib.Campaign.Misc.toggle_skip_all_but_human(variables.ai_auto_end_turn)

-- create the file location to save turn timer files.
Lib.Campaign.Misc.create_turn_timer_file()

if(g_log_events)then
    Lib.Campaign.Misc.create_event_log_file()
end

if(g_network_save_path ~= nil and g_network_save_file_name ~= nil) then
    Lib.Frontend.Load_Campaign.setup_network_save_locations()
    variables.load_most_recent_save = true
end

Lib.Helpers.Init.script_name("WH3 Campaign Progression Test")
Lib.Frontend.Misc.ensure_frontend_loaded()

if(variables.load_most_recent_save)then
    Lib.Frontend.load_most_recent_save()
else
    Lib.Frontend.Loaders.load_chaos_campaign(variables.lord, variables.campaign_type)
end

Lib.Campaign.Misc.create_end_turn_verification_file()

Lib.Helpers.Loops.end_turn_loop(variables.max_turns)
Lib.Menu.Misc.quit_to_frontend()
Lib.Frontend.Misc.quit_to_windows()
