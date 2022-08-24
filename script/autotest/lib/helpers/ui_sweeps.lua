local m_verification_save_location = [[\\casan02\tw\Automation\Results\UI_Verification]]
local m_verification_save_file_name
local m_ui_sweep_results = {}

function Lib.Helpers.UI_Sweeps.create_ui_verification_file()
	m_verification_save_file_name = Lib.Helpers.Misc.get_log_file_id()

	Lib.Helpers.Misc.create_details_log_file()

	callback(function()
		local build_no = common.game_version()
		build_no = string.match(build_no, 'Build (%d+)')
		os.execute("mkdir \""..m_verification_save_location.."\"")

		Functions.write_to_document("ID,Game Area,UI Panel,Result", m_verification_save_location, m_verification_save_file_name, ".csv", true, true)
	end)
end

local function add_result(game_area, panel_name, result)
	if m_ui_sweep_results[game_area] == nil then		
		m_ui_sweep_results[game_area] = {}
	end
	m_ui_sweep_results[game_area][panel_name] = result
end

-- I assume this function was left over from the last person to work on the UI sweeps.
-- Leaving it here for now as I want to explore the idea.
-- local function verify_panel_from_event(open_function, close_function, verification_listener, alias)
-- 	callback(function()
		
-- 	end)
-- end

local function verify_component(verification_component, game_area, button_name)
	callback(function()
		local result
		Lib.Helpers.Misc.wait(2, true)
		callback(function()
			local component = verification_component()
			if(component ~= nil and component:Visible(true) == true) then
				result = "PASSED"
			else
				result = "FAILED"
			end
			add_result(game_area, button_name, result)
		end)
	end) 
end

local function verify_panel_from_component(open_function, close_function, verification_component, game_area, panel_name, wait_time)
	callback(function()
		local result
		local time_int = nil or wait_time
		open_function()
		Lib.Helpers.Misc.wait(2)
		callback(function()
			local component = verification_component()
			if(component ~= nil and component:Visible(true) == true) then
				result = "PASSED"
			else
				result = "FAILED"
			end
			add_result(game_area, panel_name, result)
		end)
		callback(function()
			if(close_function) then
				close_function()
				if time_int ~= nil then
					Lib.Helpers.Misc.wait(time_int, true)
				end
			end
		end)
	end) 
end

local function verify_click_from_component(open_function, close_function, verification_component, game_area, button_name, wait_time, variable)
	callback(function()
		local result
		local time_int = nil or wait_time
		if variable ~= nil then
			open_function(variable)
		else
			open_function()
		end
		Lib.Helpers.Misc.wait(2, true)
		callback(function()
			local component = verification_component()
			if(component ~= nil and component:CurrentState() == "selected" or component ~= nil and component:Visible(true) == true) then
				result = "PASSED"
			else
				result = "FAILED"
			end
			add_result(game_area, button_name, result)
		end)
		callback(function()
			if(close_function) then
				close_function()
				if time_int ~= nil then
					Lib.Helpers.Misc.wait(time_int, true)
				end
			end
		end)
	end) 
end

function Lib.Helpers.UI_Sweeps.get_sweep_results()
	return m_ui_sweep_results
end

function Lib.Helpers.UI_Sweeps.frontend_campaigns_sweep()
	callback(function()
		local load_camp = Lib.Components.Frontend.load_campaign()

		verify_panel_from_component(Lib.Frontend.Clicks.campaign_tab, nil, Lib.Components.Frontend.new_campaign, "Frontend", "Campaign Tab")
		verify_panel_from_component(Lib.Frontend.Clicks.new_campaign, Lib.Frontend.Misc.return_to_frontend, Lib.Components.Frontend.new_campaign_panel, "Frontend", "New Campaign Panel")
		--verify_panel_from_component(Lib.Frontend.Clicks.campaign_select_continue, Lib.Frontend.Misc.return_to_frontend, Lib.Components.Frontend.lord_select_panel, "Frontend", "Lord Select Panel") -- if adding this again, check the flow as it might not work properly
		verify_panel_from_component(Lib.Frontend.Clicks.multiplayer_campaign, Lib.Frontend.Misc.return_to_frontend, Lib.Components.Frontend.multiplayer_panel, "Frontend", "Multiplayer Campaign Panel")

		if(load_camp ~= nil and load_camp:CurrentState() == "active") then
			verify_panel_from_component(Lib.Frontend.Clicks.load_campaign, Lib.Frontend.Misc.return_to_frontend, Lib.Components.Frontend.load_game_panel, "Frontend", "Load Campaign Panel")
		end
	end)
end

function Lib.Helpers.UI_Sweeps.frontend_battles_sweep()
	callback(function()
		local replays = Lib.Components.Frontend.replays()
		
		verify_panel_from_component(Lib.Frontend.Clicks.battles_tab, nil, Lib.Components.Frontend.custom_battle, "Frontend", "Battles Tab")
		verify_panel_from_component(Lib.Frontend.Clicks.custom_battle, Lib.Frontend.Misc.return_to_frontend, Lib.Components.Frontend.custom_battle_panel, "Frontend", "Custom Battle Panel")
		verify_panel_from_component(Lib.Frontend.Clicks.multiplayer_quick_battle, Lib.Frontend.Misc.return_to_frontend, Lib.Components.Frontend.multiplayer_panel, "Frontend", "Multiplayer Battle Panel")
		verify_panel_from_component(Lib.Frontend.Clicks.quest_battle, Lib.Frontend.Misc.return_to_frontend, Lib.Components.Frontend.quest_battle_panel, "Frontend", "Quest Battle Panel")

		if(replays ~= nil and replays:CurrentState() == "active") then
			verify_panel_from_component(Lib.Frontend.Clicks.replays, Lib.Frontend.Misc.return_to_frontend, Lib.Components.Frontend.battle_replays_panel, "Frontend", "Battle Replays Panel")
		end
	end)
end

function Lib.Helpers.UI_Sweeps.frontend_options_sweep()
	callback(function()
		verify_panel_from_component(Lib.Frontend.Clicks.options_tab, nil, Lib.Components.Frontend.options_graphics, "Frontend", "Options Tab")
		verify_panel_from_component(Lib.Frontend.Clicks.options_graphics, nil, Lib.Components.Frontend.graphics_panel, "Frontend", "Graphics Panel")
		verify_panel_from_component(Lib.Frontend.Clicks.graphics_advanced, nil, Lib.Components.Frontend.advanced_graphics_panel, "Frontend", "Advanced Graphics Panel")
		verify_panel_from_component(Lib.Frontend.Clicks.graphics_benchmark_button, Lib.Frontend.Clicks.cancel_benchmark_button, Lib.Components.Frontend.benchmark_panel, "Frontend", "Benchmark Panel")
		verify_panel_from_component(Lib.Frontend.Clicks.options_sound, Lib.Frontend.Clicks.options_tab, Lib.Components.Frontend.audio_panel, "Frontend", "Sound Panel")
		verify_panel_from_component(Lib.Frontend.Clicks.options_controls, Lib.Frontend.Clicks.options_tab, Lib.Components.Frontend.controls_panel, "Frontend", "Controls Panel")
		verify_panel_from_component(Lib.Frontend.Clicks.options_game_settings, Lib.Frontend.Clicks.options_tab, Lib.Components.Frontend.game_settings_panel, "Frontend", "Game Settings Panel")
		verify_panel_from_component(Lib.Frontend.Clicks.options_credits, Lib.Frontend.Misc.return_to_frontend, Lib.Components.Frontend.credits_panel, "Frontend", "Credits Panel")
	end)
end

local function wait_for_advisor_closed(loop_count)
	local loop_count = loop_count or 1
	callback(function()
		local close_advice = Lib.Components.Campaign.close_advisor()
		if(close_advice ~= nil and close_advice:Visible() == true) then
			Lib.Campaign.Clicks.close_advisor()
		end
		if (loop_count < 100) then
			wait_for_advisor_closed(loop_count+1)
		end
	end)
end

function Lib.Helpers.UI_Sweeps.skip_cutscenes_close_advisor()
	callback(function()
		Lib.Campaign.Misc.ensure_cutscene_ended() --The Realm of Chaos campaign has 2 cutscenes. We need to skip them both.
		wait_for_advisor_closed()
	end)
end

function Lib.Helpers.UI_Sweeps.campaign_main_panel_sweep()
	callback(function()
		verify_panel_from_component(Lib.Campaign.Clicks.open_diplomacy_panel, Lib.Campaign.Clicks.cancel_diplomacy, Lib.Components.Campaign.main_diplomancy_component, "Campaign", "Diplomacy Panel", 1)
		verify_panel_from_component(Lib.Campaign.Clicks.open_tech_panel, Lib.Campaign.Clicks.close_tech_panel, Lib.Components.Campaign.technology_panel, "Campaign", "Technology Panel", 1)
		verify_panel_from_component(Lib.Campaign.Clicks.open_objectives_panel, Lib.Campaign.Clicks.close_objectives_panel, Lib.Components.Campaign.objectives_panel_parent, "Campaign", "Objectives Panel", 1)
	end)
end

function Lib.Helpers.UI_Sweeps.campaign_map_tab_sweep()
	callback(function()
		verify_panel_from_component(Lib.Campaign.Clicks.map_tab_events_button, nil, Lib.Components.Campaign.map_tab_events_dropdown, "Campaign", "Events Map Tab", nil)
		verify_panel_from_component(Lib.Campaign.Clicks.map_tab_lords_heroes_button, nil, Lib.Components.Campaign.map_tab_lords_heroes_dropdown, "Campaign", "Lords Heroes Map Tab", nil)
		verify_panel_from_component(Lib.Campaign.Clicks.map_tab_provinces_button, nil, Lib.Components.Campaign.map_tab_provinces_dropdown, "Campaign", "Provinces Map Tab", nil)
		verify_panel_from_component(Lib.Campaign.Clicks.map_tab_known_factions_button, nil, Lib.Components.Campaign.map_tab_known_factions_dropdown, "Campaign", "Known Factions Map Tab", nil)
	end)
end

function Lib.Helpers.UI_Sweeps.campaign_menu_bar_sweep()
	callback(function()
		verify_panel_from_component(Lib.Campaign.Clicks.open_menu_bar_camera_settings, Lib.Campaign.Clicks.close_menu_bar_camera_settings, Lib.Components.Campaign.menu_bar_camera_settings_button, "Campaign", "Camera Settings Menu Bar", 1)
		verify_panel_from_component(Lib.Campaign.Clicks.open_menu_bar_spell_browser, Lib.Campaign.Clicks.close_spell_browser, Lib.Components.Campaign.spell_browser_parent, "Campaign", "Spell Browser", 1)
		verify_panel_from_component(Lib.Campaign.Clicks.open_menu_bar_help_pages, Lib.Campaign.Clicks.close_help_pages_campaign, Lib.Components.Campaign.menu_bar_help_panel, "Campaign", "Help and Pages" , 1)
		--verify_panel_from_component(Lib.Campaign.Clicks.open_menu_bar_advisor, Lib.Campaign.Clicks.close_advisor, Lib.Components.Campaign.menu_bar_advisor_panel, "Campaign", "Advisor", 1)
	end)
end

function Lib.Helpers.UI_Sweeps.battle_main_ui_sweep()
	callback(function()
		Lib.Helpers.Misc.wait(2, true)
		verify_component(Lib.Components.Battle.start_battle, "Battle", "Main UI Controls")
		verify_component(Lib.Components.Battle.cards_panel, "Battle", "Main UI Card Panel")
		verify_component(Lib.Components.Battle.battle_winds_of_magic, "Battle", "Main UI Winds of Magic")
		verify_component(Lib.Components.Battle.battle_radar, "Battle", "Main UI Radar")
		verify_component(Lib.Components.Battle.battle_bop_frame, "Battle", "Main UI BOP Frame")
	end)
end

function Lib.Helpers.UI_Sweeps.battle_card_panel_sweep()
	callback(function()
		if (Lib.Components.Battle.cards_panel()) then
			local _, card_list = Common_Actions.get_visible_child_count(Lib.Components.Battle.cards_holder())
			for key, card in pairs(card_list) do
				local card_id = card:Id()
				verify_click_from_component(Lib.Battle.Clicks.card_holder_card, nil, Lib.Components.Battle.card_info_panel, "Battle", "Card ID "..tostring(card_id), 1, card_id)
			end
		end
	end)
end

function Lib.Helpers.UI_Sweeps.battle_speed_control_sweep()
	callback(function()
		Lib.Battle.Misc.ensure_battle_started()
		verify_click_from_component(Lib.Battle.Clicks.button_fast_forward_battle, nil, Lib.Components.Battle.battle_fast_forward_battle, "Battle", "Fast Forward Speed Controls", 1)
		verify_click_from_component(Lib.Battle.Clicks.button_forward_battle, nil, Lib.Components.Battle.battle_forward_battle, "Battle", "Forward Speed Controls", 1)
		verify_click_from_component(Lib.Battle.Clicks.button_play_battle, nil, Lib.Components.Battle.battle_play_battle, "Battle", "Play Speed Controls", 1)
		verify_click_from_component(Lib.Battle.Clicks.button_slowmo_battle, nil, Lib.Components.Battle.battle_slowmo_battle, "Battle", "Slowmo Speed Controls", 1)
		verify_click_from_component(Lib.Battle.Clicks.button_pause_battle, nil, Lib.Components.Battle.battle_pause_battle, "Battle", "Pause Controls", 1)
	end)
end

function Lib.Helpers.UI_Sweeps.battle_menu_bar_sweep()
	callback(function()
		verify_panel_from_component(Lib.Campaign.Clicks.open_menu_bar_spell_browser, Lib.Campaign.Clicks.close_spell_browser, Lib.Components.Campaign.spell_browser_parent, "Battle", "Spell Browser", 1)
		verify_panel_from_component(Lib.Campaign.Clicks.open_menu_bar_help_pages, Lib.Battle.Clicks.battle_help_panel_button_close, Lib.Components.Battle.battle_help_panel, "Battle", "Help and Pages" , 1)
	end)
end