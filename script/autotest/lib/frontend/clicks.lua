function Lib.Frontend.Clicks.campaign_tab(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.campaign_tab(), "Campaign Tab (frontend)", left_click)
    end)
end

function Lib.Frontend.Clicks.new_campaign(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.new_campaign(), "New Campaign (campaign menu)", left_click)
    end)
end

function Lib.Frontend.Clicks.load_campaign(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.load_campaign(), "Load Campaign (campaign menu)", left_click)
    end)
end

function Lib.Frontend.Clicks.multiplayer_campaign(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.multiplayer_campaign(), "Multiplayer Campaign (campaign menu)", left_click)
    end)
end

function Lib.Frontend.Clicks.chaos_campaign(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.chaos_campaign(), "Chaos Campaign (campaign menu)", left_click)
    end)
end

function Lib.Frontend.Clicks.immortal_empires_campaign(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.immortal_empires_campaign(), "Immortal Empires Campaign (campaign menu)", left_click)
    end)
end

function Lib.Frontend.Clicks.campaign_select_continue(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.campaign_select_continue(), "Continue (campaign menu)", left_click)
    end)
end

function Lib.Frontend.Clicks.start_campaign(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.start_campaign(), "Start Campaign (campaign lobby)", left_click)
    end)
end

function Lib.Frontend.Clicks.campaign_race_select(race, left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.campaign_race_select(race), "Select Race: "..race.."", left_click)
    end)
end

function Lib.Frontend.Clicks.campaign_lord_select(lord, left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.campaign_lord_select(lord), "Select Lord: "..lord.."", left_click)
    end)
end

function Lib.Frontend.Clicks.battles_tab(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.battles_tab(), "Battles (menu)", left_click)
    end)
end

function Lib.Frontend.Clicks.custom_battle(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.custom_battle(), "Custom battle (battle menu)", left_click)
    end)
end

function Lib.Frontend.Clicks.multiplayer_quick_battle(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.multiplayer_quick_battle(), "Multiplayer battle (battle menu)", left_click)
    end)
end

function Lib.Frontend.Clicks.multiplayer_ranked_battle(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.multiplayer_ranked_battle(), "Multiplayer battle (battle menu)", left_click)
    end)
end

function Lib.Frontend.Clicks.quest_battle(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.quest_battle(), "Quest battle (battle menu)", left_click)
    end)
end

function Lib.Frontend.Clicks.replays(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.replays(), "Replays (battle menu)", left_click)
    end)
end

function Lib.Frontend.Clicks.add_player(team, player, left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.add_player(team, player), "", left_click)
    end)
end

function Lib.Frontend.Clicks.remove_player(team, player, left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.remove_player(team, player), "", left_click)
    end)
end

function Lib.Frontend.Clicks.custom_battle_select_player(team, player, left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.custom_battle_select_player(team, player), "Player "..tostring(player).." Team "..tostring(team), left_click)
    end)
end

function Lib.Frontend.Clicks.custom_battle_change_faction(team, player, left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.custom_battle_change_faction(team, player), "", left_click)
    end)
end

function Lib.Frontend.Clicks.custom_battle_unit_parent(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.custom_battle_unit_parent(), "", left_click)
    end)
end

function Lib.Frontend.Clicks.custom_battle_autogenerate(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.custom_battle_autogenerate(), "", left_click)
    end)
end

function Lib.Frontend.Clicks.dropdown_custom_battle_battle_type(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.dropdown_custom_battle_battle_type(), "", left_click)
    end)
end

function Lib.Frontend.Clicks.battle_difficulty(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.battle_difficulty(), "", left_click)
    end)
end

function Lib.Frontend.Clicks.battle_time_limit(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.battle_time_limit(), "", left_click)
    end)
end

function Lib.Frontend.Clicks.battle_funds(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.battle_funds(), "", left_click)
    end)
end

function Lib.Frontend.Clicks.tower_level(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.tower_level(), "", left_click)
    end)
end

function Lib.Frontend.Clicks.battle_realism(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.battle_realism(), "", left_click)
    end)
end

function Lib.Frontend.Clicks.battle_large_armies(left_click)
	callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.battle_large_armies(), "", left_click)
    end)
end

function Lib.Frontend.Clicks.options_tab(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.options_tab(), "Options (frontend)", left_click)
    end)
end

function Lib.Frontend.Clicks.options_graphics(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.options_graphics(), "Graphics (options)", left_click)
    end)
end

function Lib.Frontend.Clicks.options_sound(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.options_sound(), "Sound (options)", left_click)
    end)
end

function Lib.Frontend.Clicks.options_controls(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.options_controls(), "Controls (options)", left_click)
    end)
end

function Lib.Frontend.Clicks.options_game_settings(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.options_game_settings(), "Game Settings (options)", left_click)
    end)
end

function Lib.Frontend.Clicks.options_credits(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.options_credits(), "Credits (options)", left_click)
    end)
end

function Lib.Frontend.Clicks.side_tab_options_graphics(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.side_tab_options_graphics(), "Graphics Side Tab (options)", left_click)
    end)
end

function Lib.Frontend.Clicks.side_tab_options_sound(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.side_tab_options_sound(), "Sound Side Tab (options)", left_click)
    end)
end

function Lib.Frontend.Clicks.side_tab_options_controls(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.side_tab_options_controls(), "Controls Side Tab (options)", left_click)
    end)
end

function Lib.Frontend.Clicks.side_tab_options_game_settings(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.side_tab_options_game_settings(), "Game Settings Side Tab (options)", left_click)
    end)
end

function Lib.Frontend.Clicks.side_tab_options_credits(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.side_tab_options_credits(), "Credits Side Tab (options)", left_click)
    end)
end

function Lib.Frontend.Clicks.graphics_quality_dropdown(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.graphics_quality_dropdown(), "Quality Dropdown (graphics)", left_click)
    end)
end

function Lib.Frontend.Clicks.graphics_recommended(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.recommended_graphics(), "Recommended (graphics)", left_click)
    end)
end

function Lib.Frontend.Clicks.apply_graphics(left_click)
	callback(function()
		local apply_button = Lib.Components.Frontend.apply_graphics()
		if(apply_button ~= nil and apply_button:CurrentState() == "active") then
			Common_Actions.click_component(Lib.Components.Frontend.apply_graphics(), "Apply Changes (graphics)", left_click)
		end
    end, wait.standard)
end

function Lib.Frontend.Clicks.graphics_advanced(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.graphics_advanced(), "Advanced (graphics)", left_click)
    end)
end

function Lib.Frontend.Clicks.graphics_apply_ui_scale(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.graphics_apply_ui_scale(), "Apply UI Scale", left_click)
    end)
end

function Lib.Frontend.Clicks.graphics_increase_ui_scale(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.graphics_increase_ui_scale(), "Increase UI Scale", left_click)
    end)
end

function Lib.Frontend.Clicks.graphics_decrease_ui_scale(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.graphics_decrease_ui_scale(), "Decrease UI Scale", left_click)
    end)
end

function Lib.Frontend.Clicks.graphics_benchmark_button(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.graphics_benchmark_button(), "Open Benchmarks (advanced)", left_click)
    end)
end

function Lib.Frontend.Clicks.select_benchmark(benchmark, left_click)
    callback(function()
        benchmark_text = Lib.Components.Frontend.select_benchmark(benchmark):GetStateText()
        Common_Actions.click_component(Lib.Components.Frontend.select_benchmark(benchmark), "Select Benchmark: "..benchmark_text.." (benchmarks)", left_click)
    end)
end

function Lib.Frontend.Clicks.start_benchmark_button(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.start_benchmark(), "Start Benchmark (benchmarks)", left_click)
    end)
end

function Lib.Frontend.Clicks.cancel_benchmark_button(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.cancel_benchmark(), "Cancel Benchmark (benchmarks)", left_click)
    end)
end

function Lib.Frontend.Clicks.cancel_advanced_changes(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.cancel_advanced_changes(), "Cancel Advanced (options)", left_click)
    end)
end

function Lib.Frontend.Clicks.cancel_graphics_changes(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.cancel_graphics_changes(), "Cancel Graphivcs (options)", left_click)
    end)
end

function Lib.Frontend.Clicks.quit_confirmation(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.quit_confirmation(), "Confirm quit (frontend)", left_click)
    end)
end

function Lib.Frontend.Clicks.return_to_main_menu(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.return_to_main_menu(), "Return to Main Menu (frontend)", left_click)
    end)
end

function Lib.Frontend.Clicks.custom_battle_start(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.custom_battle_start(), "Start battle (custom battle)", left_click)
    end)
end

function Lib.Frontend.Clicks.close_dlc_popup(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.dlc_popup_button_close(), "Close Popup (frontend)", left_click)
    end)
end

function Lib.Frontend.Clicks.close_popup(left_click)
    callback(function()
        local popup_component = Lib.Components.Frontend.close_popup()
        if(popup_component ~= nil and popup_component:Visible(true)) then
            Common_Actions.click_component(Lib.Components.Frontend.close_popup(), "Close Popup (frontend)", left_click)
        end
    end)
end

function Lib.Frontend.Clicks.quit_to_windows(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.quit_to_windows(), "Quit to Windows (frontend)", left_click)
    end)
end

function Lib.Frontend.Clicks.quest_battle_select(battle, left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.quest_battle_select(battle), "Select Quest Battle: "..battle.."  (quest battle)", left_click)
    end)
end

function Lib.Frontend.Clicks.quest_battle_lord_select(lord, left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.quest_battle_lord_select(lord), "Select Lord: "..lord.."  (quest battle)", left_click)
    end)
end

function Lib.Frontend.Clicks.quest_battle_change_faction(left_click)
	callback(function()
		Common_Actions.click_component(Lib.Components.Frontend.quest_battle_faction_parent(), "Open Faction Select Box (quest battle)", left_click)
	end)
end

function Lib.Frontend.Clicks.quest_battle_start(left_click)
	callback(function()
		Common_Actions.click_component(Lib.Components.Frontend.quest_battle_start(), "Start Quest Battle (quest battle", left_click)
	end)
end

function Lib.Frontend.Clicks.select_campaign_type(campaign_type, left_click)
    callback(function()
        local parent_component
        if campaign_type == 'The Lost God' then
            parent_component = Lib.Components.Frontend.prologue_campaign_parent()
        else
            parent_component = Lib.Components.Frontend.campaign_selection_parent()
        end
        local campaign_count, campaign_list = Common_Actions.get_visible_child_count(parent_component)
        for _,v in pairs(campaign_list)do 
            local campaign_name_component = UIComponent(v:Find("button_txt"))
            local campaign_name = campaign_name_component:GetStateText()
            if(campaign_name == campaign_type)then
                Common_Actions.click_component(UIComponent(v:Find("button_campaign_entry")), "Select Campaign: "..campaign_type.." (new campaign)", left_click)
                break
            end
        end
    end)
end

function Lib.Frontend.Clicks.race_select_button(left_click)
    callback(function() 
        Common_Actions.click_component(Lib.Components.Frontend.campaign_race_selection_button(), "Race Select", left_click) 
    end)
end

function Lib.Frontend.Clicks.faction_button(faction, left_click)
    callback(function() 
        Common_Actions.click_component(faction, "Factions", left_click) 
    end)
end

function Lib.Frontend.Clicks.race_select_back_button(left_click)
    callback(function() 
        Common_Actions.click_component(Lib.Components.Frontend.race_select_back_button(), "Back (Race Select)", left_click) 
    end)
end

function Lib.Frontend.Clicks.race_select_continue_button(left_click)
    callback(function() 
        Common_Actions.click_component(Lib.Components.Frontend.race_select_continue_button(), "Continue (Race Select)", left_click) 
    end)
end

function Lib.Frontend.Clicks.first_time_user_accessibility_button(left_click)
    callback(function() 
        Common_Actions.click_component(Lib.Components.Frontend.first_time_user_accessibility_button(), "Accessibility Continue (First Time User)", left_click) 
    end)
end

function Lib.Frontend.Clicks.first_time_user_main_menu_button(left_click)
    callback(function() 
        Common_Actions.click_component(Lib.Components.Frontend.first_time_user_main_menu_button(), "Main Menu (First Time User)", left_click) 
    end)
end

function Lib.Frontend.Clicks.open_save_list(left_click)
    callback(function()
        Common_Actions.click_component(Lib.Components.Frontend.open_save_game_list_button(), "Load Campaign (Front end)", left_click)
    end)
end

function Lib.Frontend.Load_Campaign.load_save(left_click)
    callback(function() 
        Common_Actions.click_component(Lib.Components.Frontend.load_save_button(), "Load Save (Front end)", left_click)
    end)
end

function Lib.Frontend.Clicks.custom_battle_clear_army(left_click)
    callback(function() 
        local component = Lib.Components.Frontend.custom_battle_clear_army_button()
        if(component:CurrentState() ~= "inactive")then
            Common_Actions.click_component(component, "Clear Army (Custom Battle)", left_click)
        end
    end)
end