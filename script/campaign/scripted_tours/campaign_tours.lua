local infotext = get_infotext_manager()

-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-- FUNCTIONS
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

-- Disables the tour controls. If this is called straight away in a section, you will need a wait before setting state.
local function disable_naviable_tour_controls(value, wait_on_set_state)
	local wait_time = 0
	local uic_1 = find_uicomponent("scripted_tour_controls", "scripted_tour_next_button")
	local uic_2 = find_uicomponent("scripted_tour_controls", "scripted_tour_prev_button")
	local uic_3 = find_uicomponent("scripted_tour_controls", "button_close")

	-- Set wait time.
	if wait_on_set_state then wait_time = 0.1 end

	if uic_1 and uic_2 then 
		uic_1:SetDisabled(value)
		uic_2:SetDisabled(value) 
		uic_3:SetDisabled(value)
		
		cm:callback(
			function()
				if value then
					uic_1:SetState("inactive")
					uic_2:SetState("inactive")
					uic_3:SetState("inactive")
				else
					uic_1:SetState("active")
					uic_2:SetState("active")
					uic_3:SetState("active")
				end
			end,
			wait_time
		)

	end

	out("Setting naviable controls to disabled: "..tostring(value))
end

-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-- DEMON PRINCE CUSTOMISATION
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------


-- intervention declaration
in_daemon_prince_customisation = intervention:new(
	"in_daemon_prince_customisation",												-- string name
	20,	 																			-- cost
	function() trigger_in_daemon_prince_customisation() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 													-- show debug output
)
in_daemon_prince_customisation:set_must_trigger()
in_daemon_prince_customisation:set_should_lock_ui()
in_daemon_prince_customisation:add_precondition(function() return not cm:is_multiplayer() and cm:get_local_faction_name() == "wh3_main_dae_daemon_prince" and not in_daemon_prince_customisation:has_ever_triggered() end)
in_daemon_prince_customisation:add_trigger_condition(
"PanelClosedCampaign",
function(context)
	-- Don't trigger on low advice.
	if core:is_advice_level_low() then 
		return
	end

	-- This intervention will trigger when the player closes the correct missions panel.
	if context.string == "events" then
			local uic_quest_details = find_uicomponent("events", "quest_details")
			if uic_quest_details then
				local context = uic_quest_details:GetContextObject("CcoCampaignMission")
				if context and context:Call("MissionRecordContext.Key") == "wh3_main_camp_narrative_daemon_prince_equip_daemonic_gift_01" then
					return true
				end
			end
		end
	end
)
in_daemon_prince_customisation:add_trigger_condition("NavigableToursStarted", function() return cm:get_saved_value(cm:get_local_faction_name() .. "_dp_equip_gift_issued") end)

function trigger_in_daemon_prince_customisation()

	nt_daemon_prince_customisation = navigable_tour:new(
		"daemon_prince_customisation", -- unique name 																
		function() end, -- end callback
		"ui_text_replacements_localised_text_wh3_campaign_daemonic_glory_navigable_tour_title" -- title string
	)

	nt_daemon_prince_customisation:start_action(
		function()
			-- Dismiss advice.
			cm:dismiss_advice()

			infotext:attach_to_advisor(false) -- Unattach infotext to advisor
			nt_daemon_prince_customisation:set_tour_controls_above_infotext(true) -- This must be called after infotext is unattached
			infotext:cache_and_set_detached_infotext_priority(1500, true)
			nt_daemon_prince_customisation:cache_and_set_scripted_tour_controls_priority(1500, true)

			-- Disable escape key and shortcuts.
			cm:steal_escape_key(true)
			common.enable_all_shortcuts(false)
		end,
		0
	)
	nt_daemon_prince_customisation:end_action( -- Called when the tour ends
		function() 
			infotext:attach_to_advisor(true) -- Reattach infotext to advisor
			infotext:restore_detatched_infotext_priority()
			
			-- Clean up escape key steal and shortcuts.
			cm:steal_escape_key(false)
			common.enable_all_shortcuts(true)
			
			nt_daemon_prince_customisation:restore_scripted_tour_controls_priority()
			in_daemon_prince_customisation:complete()
		end,
		0
	)

	-- Disable all ways to leave Daemonic Glory screen
	local function block_exit_daemonic_glory_screen(value, exclude_character_details)
		exclude_character_details = exclude_character_details or false

		local uic_button_info = find_uicomponent("daemonic_progression", "button_info_holder", "button_info")
		local uic_button_ok = find_uicomponent("daemonic_progression", "button_ok_holder", "button_ok")
		local uic_button_character_details = find_uicomponent("daemonic_progression", "button_character_details")
		
		if uic_button_info then uic_button_info:SetDisabled(value) end
		if uic_button_ok then uic_button_ok:SetDisabled(value) end
		if not exclude_character_details and uic_button_character_details then uic_button_character_details:SetDisabled(value) end
	end

	

	-- Create navigable tour section.
	local nts_daemonic_glory_button = navigable_tour_section:new(
		"daemonic_glory_button", -- name of tour section
		false -- activate controls on start
	)

	
	-- Create action of section
	nts_daemonic_glory_button:action(
		function()
			-- If this is still in the next section (the daemonic progression screen), close it.
			if cm:get_campaign_ui_manager():is_panel_open("daemonic_progression") then
				local uic_button_ok_daemonic_progression = find_uicomponent("daemonic_progression", "button_ok_holder", "button_ok")
				if uic_button_ok_daemonic_progression then uic_button_ok_daemonic_progression:SimulateLClick() end

				-- Also check for the character details panel and shut that.
				local uic_button_ok_character_details = find_uicomponent("character_details_panel", "button_ok")
				if uic_button_ok_character_details then uic_button_ok_character_details:SimulateLClick() end
			end

			local uic = find_uicomponent("button_daemonic_progression")

			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"bottom",
				25,
				uic,
				0.5,
				0
			)
			tp:add_component_text("text", "ui_text_replacements_localised_text_wh3_campaign_daemonic_glory_button")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:do_not_release_escape_key(true)
			tp:show()

			core:show_fullscreen_highlight_around_components(5, false, true, uic)

			core:add_listener(
				"ComponentLClickUpDaemonPrinceCustomisation",
				"ComponentLClickUp",
				function(context)
					return context.string == uic:Id() 
				end,
				function() nt_daemon_prince_customisation:start_next_section() end,
				false
			)

			-- Responsible for cleaning up the action after the player moves forward.
			nts_daemonic_glory_button:add_skip_action(
				function()
					core:remove_listener("ComponentLClickUpDaemonPrinceCustomisation")
					tp:hide(true)
					core:hide_fullscreen_highlight()
				end
			)
		end,
		0 -- Interval to start action after section starts.
	)



	-- Create navigable tour section.
	local nts_daemonic_glory_main_panel = navigable_tour_section:new(
		"daemonic_glory_main_panel", -- name of tour section
		false -- activate controls on start
	)

	-- Create action of section
	nts_daemonic_glory_main_panel:action(
		function()

			-- Open panel if shut.
			if cm:get_campaign_ui_manager():is_panel_open("daemonic_progression") == false then
				local uic = find_uicomponent("button_daemonic_progression")
				if uic then uic:SimulateLClick() end
			end

			-- Block player from leaving screen.
			block_exit_daemonic_glory_screen(true)

			local uic_panel = find_uicomponent("daemonic_progression", "panel_frame_wh3")
			core:show_fullscreen_highlight_around_components(0, false, true, uic_panel)

			-- Add text panel
			infotext:add_infotext(
				"wh3_main_st_campaign_daemon_prince_daemonic_glory_title",
				"wh3_main_st_campaign_daemon_prince_daemonic_glory_explanation"
			)
			
			-- Responsible for cleaning up the action after the player moves forward.
			nts_daemonic_glory_main_panel:add_skip_action(
				function()
					core:hide_fullscreen_highlight()
					block_exit_daemonic_glory_screen(false)
					infotext:clear_infotext()
				end
			)
		end,
		0 -- Interval to start action after section starts.
	)


	
	-- Create navigable tour section.
	local nts_daemonic_glory_bar = navigable_tour_section:new(
		"daemonic_glory_bar", -- name of tour section
		false -- activate controls on start
	)

	-- Create action of section
	nts_daemonic_glory_bar:action(
		function()
			block_exit_daemonic_glory_screen(false)

			local uic = find_uicomponent("daemonic_progression", "upgrades_list_view", "list_box")
			local uic_glory_bar = UIComponent(uic:Find(4))
			
			local uic_2 = find_uicomponent("daemonic_progression", "symbols_holder", "list_box")
			local uic_glory_symbol = UIComponent(uic_2:Find(4))
			
			core:show_fullscreen_highlight_around_components(5, false, true, uic_glory_bar, uic_glory_symbol)
			
			-- Add text panel
			infotext:add_infotext(
				"wh3_main_st_campaign_daemon_prince_daemonic_glory_glory_bar_title",
				"wh3_main_st_campaign_daemon_prince_daemonic_glory_glory_bar_explanation_1",
				"wh3_main_st_campaign_daemon_prince_daemonic_glory_glory_bar_explanation_2",
				"wh3_main_st_campaign_daemon_prince_daemonic_glory_glory_bar_explanation_3"
			)

			-- Responsible for cleaning up the action after the player moves forward.
			nts_daemonic_glory_bar:add_skip_action(
				function()
					core:hide_fullscreen_highlight()
					block_exit_daemonic_glory_screen(false)
					infotext:clear_infotext()
				end
			)
		end,
		0 -- Interval to start action after section starts.
	)



	-- Create navigable tour section.
	local nts_unlock_gifts = navigable_tour_section:new(
		"unlock_gifts", -- name of tour section
		false -- activate controls on start
	)

	-- Create action of section
	nts_unlock_gifts:action(
		function()
			block_exit_daemonic_glory_screen(false)

			local uic = find_uicomponent("daemonic_progression", "upgrades_list_view", "list_box")
			local uic_glory_bar = UIComponent(uic:Find(4))
			local uic_daemonic_gifts = find_uicomponent(uic_glory_bar, "tier_list")
			
			
			core:show_fullscreen_highlight_around_components(20, false, true, uic_daemonic_gifts)
			
			-- Add text panel
			infotext:add_infotext(
				"wh3_main_st_campaign_daemon_prince_daemonic_glory_unlock_gifts_title",
				"wh3_main_st_campaign_daemon_prince_daemonic_glory_unlock_gifts_explanation"
			)

			-- Responsible for cleaning up the action after the player moves forward.
			nts_unlock_gifts:add_skip_action(
				function()
					core:hide_fullscreen_highlight()
					block_exit_daemonic_glory_screen(false)
					infotext:clear_infotext()
				end
			)
		end,
		0 -- Interval to start action after section starts.
	)




	-- Create navigable tour section.
	local nts_equipment_screen = navigable_tour_section:new(
		"equipment_screen", -- name of tour section
		false -- activate controls on start
	)

	-- Create action of section
	nts_equipment_screen:action(
		function()

			-- If this is still on the character details screen, click on daemonic progression button.
			if cm:get_campaign_ui_manager():is_panel_open("daemonic_progression") == false then
				local button_daemonic_progression = find_uicomponent("character_details_panel", "button_daemonic_progression")
				if button_daemonic_progression then button_daemonic_progression:SimulateLClick() end
			end

			local uic = find_uicomponent("daemonic_progression", "button_character_details")
						
			block_exit_daemonic_glory_screen(true, true)

			core:show_fullscreen_highlight_around_components(10, false, true, uic)

			uic:Highlight(true, false)
			
			-- Add text panel
			infotext:add_infotext(
				"wh3_main_st_campaign_daemon_prince_daemonic_glory_equipment_screen_title",
				"wh3_main_st_campaign_daemon_prince_daemonic_glory_equipment_screen_explanation"
			)

			-- Add listener for character details button.
			core:add_listener(
				"ComponentLClickUpDaemonPrinceCustomisation",
				"ComponentLClickUp",
				function(context)
					return context.string == "button_character_details"
				end,
				function() nt_daemon_prince_customisation:start_next_section() end,
				false
			)

			-- Responsible for cleaning up the action after the player moves forward.
			nts_equipment_screen:add_skip_action(
				function()
					core:remove_listener("ComponentLClickUpDaemonPrinceCustomisation")
					core:hide_fullscreen_highlight()
					block_exit_daemonic_glory_screen(false)
					infotext:clear_infotext()

					-- Add listener for character details button.
					core:remove_listener("PanelOpenedCampaignDaemonicProgressionStopHighlight")

					core:add_listener(
						"PanelOpenedCampaignDaemonicProgressionStopHighlight",
						"PanelOpenedCampaign",
						function(context) return context.string == "daemonic_progression" end,
						function() 
							local uic = find_uicomponent("daemonic_progression", "button_character_details")
							if uic then 
								uic:Highlight(false, false) 
							end
						end,
						false
					)

					-- Check for character details button and stop highlight. This won't work if player clicks button, so above listenr needed.
					local uic = find_uicomponent("daemonic_progression", "button_character_details")
					if uic then 
						uic:Highlight(false, false) 
					end
				end
			)
		end,
		0 -- Interval to start action after section starts.
	)



	-- Create navigable tour section.
	local nts_equipping_gift = navigable_tour_section:new(
		"equipping_gift", -- name of tour section
		false -- activate controls on start
	)

	-- Create action of section
	nts_equipping_gift:action(
		function()
			-- If this is still on the daemonic progression screen, click on the character details
			if cm:get_campaign_ui_manager():is_panel_open("daemonic_progression") then
				local uic_button_character_details = find_uicomponent("daemonic_progression", "button_character_details")
				if uic_button_character_details then uic_button_character_details:SimulateLClick() end
			end
			
			local uic_button_info = find_uicomponent("character_details_panel", "button_info_holder", "button_info")
			local uic_button_ok = find_uicomponent("character_details_panel", "button_ok")
			local uic_button_ok_daemonic_progression = find_uicomponent("character_details_panel", "button_daemonic_progression")
			local uic_daemon_gifts_holder = find_uicomponent("character_details_panel", "daemon_gifts_holder")
			local uic_replace_lord = find_uicomponent("character_details_panel", "character_context_parent", "bottom_buttons", "button_replace_general")
			local uic_event_feed = find_uicomponent("character_details_panel", "character_context_parent", "bottom_buttons", "button_event_feed")
			local uic_rename = find_uicomponent("character_details_panel", "character_context_parent", "bottom_buttons", "button_rename")
			local uic_save_character = find_uicomponent("character_details_panel", "character_context_parent", "bottom_buttons", "button_save_character")

			if uic_button_info then uic_button_info:SetDisabled(true) end
			if uic_button_ok then uic_button_ok:SetDisabled(true) end
			if uic_button_ok_daemonic_progression then uic_button_ok_daemonic_progression:SetDisabled(true) end
			if uic_replace_lord then uic_replace_lord:SetDisabled(true) end
			if uic_event_feed then uic_event_feed:SetDisabled(true) end
			if uic_rename then uic_rename:SetDisabled(true) end
			if uic_save_character then uic_save_character:SetDisabled(true) end

			core:show_fullscreen_highlight_around_components(50, false, true, uic_daemon_gifts_holder)

			-- Add text panel
			infotext:add_infotext(
				"wh3_main_st_campaign_daemon_prince_daemonic_glory_equipping_gift_title",
				"wh3_main_st_campaign_daemon_prince_daemonic_glory_equipping_gift_explanation"
			)

			-- Responsible for cleaning up the action after the player moves forward.
			nts_equipping_gift:add_skip_action(
				function()
					if uic_button_info then uic_button_info:SetDisabled(false) end
					if uic_button_ok then uic_button_ok:SetDisabled(false) end
					if uic_button_ok_daemonic_progression then uic_button_ok_daemonic_progression:SetDisabled(false) end
					if uic_replace_lord then uic_replace_lord:SetDisabled(false) end
					if uic_event_feed then uic_event_feed:SetDisabled(false) end
					if uic_rename then uic_rename:SetDisabled(false) end
					if uic_save_character then uic_save_character:SetDisabled(false) end

					core:hide_fullscreen_highlight()
					infotext:clear_infotext()
				end
			)
		end,
		0 -- Interval to start action after section starts.
	)



	-- Adding navigable tour sections in order of playback.
	nt_daemon_prince_customisation:add_navigable_section(nts_daemonic_glory_button)
	nt_daemon_prince_customisation:add_navigable_section(nts_daemonic_glory_main_panel)
	nt_daemon_prince_customisation:add_navigable_section(nts_daemonic_glory_bar)
	nt_daemon_prince_customisation:add_navigable_section(nts_unlock_gifts)
	nt_daemon_prince_customisation:add_navigable_section(nts_equipment_screen)
	nt_daemon_prince_customisation:add_navigable_section(nts_equipping_gift)

	nt_daemon_prince_customisation:start()
end



-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-- CHANGING OF THE WAYS
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------


-- intervention declaration
in_changing_of_the_ways = intervention:new(
	"in_changing_of_the_ways",												-- string name
	20,	 																	-- cost
	function() trigger_in_changing_of_the_ways() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
)
in_changing_of_the_ways:set_must_trigger()
in_changing_of_the_ways:set_should_lock_ui()
in_changing_of_the_ways:add_precondition(function() return not cm:is_multiplayer() and cm:get_local_faction_subculture() == "wh3_main_sc_tze_tzeentch" and not in_changing_of_the_ways:has_ever_triggered() end)
in_changing_of_the_ways:add_trigger_condition(
"PanelClosedCampaign",
function(context)
	-- Don't trigger on low advice.
	if core:is_advice_level_low() then 
		return
	end

	-- This intervention will trigger when the player closes the correct missions panel.
	if context.string == "events" then
			local uic_quest_details = find_uicomponent("events", "quest_details")
			if uic_quest_details then
				local context = uic_quest_details:GetContextObject("CcoCampaignMission")
				if context then
					local mission_key = context:Call("MissionRecordContext.Key")
					if string.find(mission_key, "capture_settlement_01") then -- If this is a capture settlement mission for Tzeentch, start tour.
						return true
					end
				end
			end
		end
	end
)

in_changing_of_the_ways:add_trigger_condition(
	"NavigableToursStarted", function() return cm:get_saved_value("tzeentch_capture_settlement_01_issued") and not core:is_advice_level_low() end)

in_changing_of_the_ways:add_trigger_condition(
	"MissionIssued",
	function(context)
		local mission_key = context:mission():mission_record_key()
		if string.find(mission_key, "capture_settlement_01") and not cm:get_saved_value("tzeentch_capture_settlement_01_issued") then
			cm:set_saved_value("tzeentch_capture_settlement_01_issued", true)
		end
	end
)


function trigger_in_changing_of_the_ways()

	local function disable_technology_buttons(should_disable)
		local uic_manipulation_list = find_uicomponent("manipulation_list")

		if uic_manipulation_list then
			for i = 0, uic_manipulation_list:ChildCount() - 1 do
				uic_manipulation_list_child = UIComponent(uic_manipulation_list:Find(i))
				if uic_manipulation_list_child then
					local uic_tech_icon = find_uicomponent(uic_manipulation_list_child, "tech_icon")
					if uic_tech_icon then
						uic_tech_icon:SetDisabled(should_disable)
					end
				end
			end
		end
	end

	nt_changing_of_the_ways = navigable_tour:new(
		"changing_of_the_ways", -- unique name 																
		function() end, -- end callback
		"ui_text_replacements_localised_text_wh3_campaign_changing_of_the_ways_navigable_tour_title" -- title string
	)

	nt_changing_of_the_ways:start_action(
		function()
			-- Dismiss advice.
			cm:dismiss_advice()
			
			infotext:attach_to_advisor(false) -- Unattach infotext to advisor
			nt_changing_of_the_ways:set_tour_controls_above_infotext(true) -- This must be called after infotext is unattached
			infotext:cache_and_set_detached_infotext_priority(1500, true)
			nt_changing_of_the_ways:cache_and_set_scripted_tour_controls_priority(1500, true)

			-- Disable escape key and shortcuts.
			cm:steal_escape_key(true)
			common.enable_all_shortcuts(false)
			cm:steal_user_input(true)
		end,
		0
	)

	nt_changing_of_the_ways:end_action( -- Called when the tour ends
		function() 
			infotext:attach_to_advisor(true) -- Reattach infotext to advisor
			infotext:restore_detatched_infotext_priority()
			
			-- Clean up escape key steal and shortcuts.
			cm:steal_escape_key(false)
			common.enable_all_shortcuts(true)
			cm:steal_user_input(false)
			
			nt_changing_of_the_ways:restore_scripted_tour_controls_priority()
			in_changing_of_the_ways:complete()
		end,
		0
	)



	-- Create navigable tour section.
	local nts_changing_of_the_ways_button = navigable_tour_section:new(
		"changing_of_the_ways_button", -- name of tour section
		false -- activate controls on start
	)

	
	-- Create action of section
	nts_changing_of_the_ways_button:action(
		function()
			-- If this is still in the next section (the changing of the ways screen), close it.
			if cm:get_campaign_ui_manager():is_panel_open("tzeentch_changing_of_ways") then
				local uic_button_ok_tzeentch_changing_of_ways = find_uicomponent("hud_campaign", "hud_center", "small_bar", "button_close_holder", "button_close")
				if uic_button_ok_tzeentch_changing_of_ways then 
					cm:steal_user_input(false)
					uic_button_ok_tzeentch_changing_of_ways:SimulateLClick() 
					cm:steal_user_input(true)
				end
			end

			cm:steal_user_input(false)

			local uic = find_uicomponent("button_changing_of_the_ways")

			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"right",
				40,
				uic,
				0,
				0.5
			)
			tp:add_component_text("text", "ui_text_replacements_localised_text_wh3_campaign_changing_of_the_ways_button")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:do_not_release_escape_key(true)
			tp:show()

			core:show_fullscreen_highlight_around_components(5, false, true, uic)

			core:add_listener(
				"ComponentLClickUpTargetButton",
				"ComponentLClickUp",
				function(context)
					return context.string == uic:Id() 
				end,
				function() nt_changing_of_the_ways:start_next_section() end,
				false
			)

			-- Responsible for cleaning up the action after the player moves forward.
			nts_changing_of_the_ways_button:add_skip_action(
				function()
					core:remove_listener("ComponentLClickUpTargetButton")
					core:hide_fullscreen_highlight()
					tp:hide(true)

					-- Steal input to block actions during transition.
					cm:steal_user_input(true)
				end
			)
		end,
		0 -- Interval to start action after section starts.
	)
	


	-- Create navigable tour section.
	local nts_changing_of_the_ways_main_panel = navigable_tour_section:new(
		"changing_of_the_ways_main_panel", -- name of tour section
		false -- activate controls on start
	)

	-- Create action of section
	nts_changing_of_the_ways_main_panel:action(
		function()
			-- Open panel if shut.
			if cm:get_campaign_ui_manager():is_panel_open("tzeentch_changing_of_ways") == false then
				local uic = find_uicomponent("button_changing_of_the_ways")
				if uic then
					cm:steal_user_input(false)
					uic:SimulateLClick()
					cm:steal_user_input(true)
				end
			end
			
			-- Unlock input
			cm:steal_user_input(false)

			-- Disable Tech buttons
			disable_technology_buttons(true)

			-- Set buttons disabled
			local uic_help_button = find_uicomponent("tzeentch_changing_of_ways", "button_info")
			uic_help_button:SetDisabled(true)
			local uic_button_ok_tzeentch_changing_of_ways = find_uicomponent("hud_campaign", "hud_center", "small_bar", "button_close_holder", "button_close")
			uic_button_ok_tzeentch_changing_of_ways:SetDisabled(true)

			local uic_panel = find_uicomponent("tzeentch_changing_of_ways")
			core:show_fullscreen_highlight_around_components(0, false, true, uic_panel)

			-- Add text panel
			infotext:add_infotext(
				"wh3_main_st_campaign_changing_of_the_ways_panel_title",
				"wh3_main_st_campaign_changing_of_the_ways_panel_explanation_1",
				"wh3_main_st_campaign_changing_of_the_ways_panel_explanation_2"
			)
			
			-- Responsible for cleaning up the action after the player moves forward.
			nts_changing_of_the_ways_main_panel:add_skip_action(
				function()
					-- Enable tech buttons
					disable_technology_buttons(false)

					-- Re-enable buttons.
					uic_help_button:SetDisabled(false)
					uic_button_ok_tzeentch_changing_of_ways:SetDisabled(false)

					core:hide_fullscreen_highlight()
					infotext:clear_infotext()

					-- Steal input to block actions during transition.
					cm:steal_user_input(true)
				end
			)
		end,
		0 -- Interval to start action after section starts.
	)


	
	-- Create navigable tour section.
	local nts_grimoires_icon = navigable_tour_section:new(
		"grimoires_icon", -- name of tour section
		false -- activate controls on start
	)

	-- Create action of section
	nts_grimoires_icon:action(
		function()
			cm:steal_user_input(false)
			
			local uic = find_uicomponent("dy_tzeentch_grimoires");

			local tp = text_pointer:new_from_component(
				"tp_grimoires",
				"top",
				40,
				uic,
				0.5,
				1
			)
			tp:add_component_text("text", "ui_text_replacements_localised_text_hp_campaign_point_1_grimoires")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:do_not_release_escape_key(true)
			tp:show()

			core:show_fullscreen_highlight_around_components(5, false, true, uic)
			
			-- Add text panel
			infotext:add_infotext(
				"wh3_main_st_campaign_changing_of_the_ways_grimoires_title",
				"wh3_main_st_campaign_changing_of_the_ways_grimoires_explanation_1",
				"wh3_main_st_campaign_changing_of_the_ways_grimoires_explanation_2"
			)

			-- Responsible for cleaning up the action after the player moves forward.
			nts_grimoires_icon:add_skip_action(
				function()
					tp:hide(true)
					core:hide_fullscreen_highlight()
					infotext:clear_infotext()

					-- Steal input to block actions during transition.
					cm:steal_user_input(true)
				end
			)
		end,
		0 -- Interval to start action after section starts.
	)



	-- Create navigable tour section.
	local nts_transfer_settlement = navigable_tour_section:new(
		"transfer_settlement", -- name of tour section
		false -- activate controls on start
	)

	-- Create action of section
	nts_transfer_settlement:action(
		function()
			local uic = find_uicomponent("CcoCampaignDiplomacyManipulationInfotransfer_settlement6")
			core:show_fullscreen_highlight_around_components(5, false, true, uic)
			
			-- Add text panel
			infotext:add_infotext(
				"wh3_main_st_campaign_changing_of_the_ways_transfer_settlement_title",
				"wh3_main_st_campaign_changing_of_the_ways_transfer_settlement_explanation_1",
				"wh3_main_st_campaign_changing_of_the_ways_transfer_settlement_explanation_2"
			)

			-- Responsible for cleaning up the action after the player moves forward.
			nts_transfer_settlement:add_skip_action(
				function()
					core:hide_fullscreen_highlight()
					infotext:clear_infotext()

					-- Steal input to block actions during transition.
					cm:steal_user_input(true)
				end
			)
		end,
		0 -- Interval to start action after section starts.
	)



	-- Adding navigable tour sections in order of playback.
	nt_changing_of_the_ways:add_navigable_section(nts_changing_of_the_ways_button)
	nt_changing_of_the_ways:add_navigable_section(nts_changing_of_the_ways_main_panel)
	nt_changing_of_the_ways:add_navigable_section(nts_grimoires_icon)
	nt_changing_of_the_ways:add_navigable_section(nts_transfer_settlement)
	nt_changing_of_the_ways:start()
end



-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-- CARAVANS
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------


-- intervention declaration
in_caravans = intervention:new(
	"in_caravans",												-- string name
	20,	 														-- cost
	function() trigger_in_caravans() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
)
in_caravans:set_must_trigger()
in_caravans:set_should_lock_ui()
in_caravans:add_precondition(function() return not cm:is_multiplayer() and cm:get_local_faction_subculture() == "wh3_main_sc_cth_cathay" and not cm:get_saved_value("caravan_tour_complete") end)
in_caravans:add_trigger_condition("PanelOpenedCampaign", function(context) return context.string == "cathay_caravans" and not core:is_advice_level_low() end)
in_caravans:set_wait_for_fullscreen_panel_dismissed(false)

function trigger_in_caravans()

	-- Cancel tour if panel is not open.
	if not cm:get_campaign_ui_manager():is_panel_open("cathay_caravans") then
		in_caravans:cancel()
		return
	end

	-- Save whether to highlight dispatch button on end.
	local highlight_dispatch_on_end = false

	nt_caravans = navigable_tour:new(
		"caravans", -- unique name 																
		function() cm:set_saved_value("caravan_tour_complete", true) end, -- end callback
		"ui_text_replacements_localised_text_wh3_campaign_caravans_navigable_tour_title" -- title string
	)

	nt_caravans:start_action(
		function()
			-- Removes the listener that disables interventions on closing panel.
			core:remove_listener("PanelClosedCampaignCathayCaravans")

			-- Dismiss advice.
			cm:dismiss_advice()
			
			infotext:attach_to_advisor(false) -- Unattach infotext to advisor
			nt_caravans:set_tour_controls_above_infotext(true) -- This must be called after infotext is unattached
			infotext:cache_and_set_detached_infotext_priority(1500, true)
			nt_caravans:cache_and_set_scripted_tour_controls_priority(1500, true)

			-- Disable escape key and shortcuts.
			cm:steal_escape_key(true)
			common.enable_all_shortcuts(false)
			cm:steal_user_input(true)

			-- Stop dispatch button from being highlighted
			local uic_reserves_list = find_uicomponent("cathay_caravans", "caravans_panel", "reserves_listview", "reserves_list")
			if uic_reserves_list:GetContextObject("CcoCampaignFactionCaravans"):Call("ActiveCaravanList.Size") == 0 then
				highlight_dispatch_on_end = true
				local uic = find_uicomponent("cathay_caravans", "caravans_panel", "dispatch_holder", "button_dispatch")
				if uic then
					uic:StopPulseHighlight()
				end
			end
		end,
		0
	)

	nt_caravans:end_action( -- Called when the tour ends
		function() 
			if highlight_dispatch_on_end then
				local uic = find_uicomponent("cathay_caravans", "caravans_panel", "dispatch_holder", "button_dispatch")
				if uic then
					uic:StartPulseHighlight()
				end
			end

			infotext:attach_to_advisor(true) -- Reattach infotext to advisor
			infotext:restore_detatched_infotext_priority()
			
			-- Clean up escape key steal and shortcuts.
			cm:steal_escape_key(false)
			common.enable_all_shortcuts(true)
			cm:steal_user_input(false)
			
			nt_caravans:restore_scripted_tour_controls_priority()
			in_caravans:complete()
		end,
		0
	)



	-- Create navigable tour section.
	local nts_caravans_panel = navigable_tour_section:new(
		"caravans_panel", -- name of tour section
		false -- activate controls on start
	)

	
	-- Create action of section
	nts_caravans_panel:action(
		function()
			-- Highlight componenets
			local uic = find_uicomponent("cathay_caravans", "caravans_panel")
			core:show_fullscreen_highlight_around_components(5, false, true, uic)

			-- Point at component.
			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"left",
				50,
				uic,
				1,
				0.5
			)
			tp:add_component_text("text", "ui_text_replacements_localised_text_wh3_campaign_caravans_panel")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:do_not_release_escape_key(true)
			tp:show()

			-- Responsible for cleaning up the action after the player moves forward.
			nts_caravans_panel:add_skip_action(
				function()
					tp:hide(true)
					core:hide_fullscreen_highlight()

					-- Steal input to block actions during transition.
					cm:steal_user_input(true)
				end
			)
		end,
		0 -- Interval to start action after section starts.
	)
	


	-- Create navigable tour section.
	local nts_list_of_caravans = navigable_tour_section:new(
		"list_of_caravans", -- name of tour section
		false -- activate controls on start
	)

	-- Create action of section
	nts_list_of_caravans:action(
		function()

			-- Highlight componenets
			local uic = find_uicomponent("cathay_caravans", "reserves_listview")
			local uic_2 = find_uicomponent("cathay_caravans", "caravans_panel")
			local uic_3 = find_child_uicomponent_by_index(uic_2, 2)
			core:show_fullscreen_highlight_around_components(5, false, true, uic, uic_3)

			-- Point at component.
			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"left",
				50,
				uic,
				1,
				0.5
			)
			tp:add_component_text("text", "ui_text_replacements_localised_text_wh3_campaign_list_of_caravans")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:do_not_release_escape_key(true)
			tp:show()
			
			-- Responsible for cleaning up the action after the player moves forward.
			nts_list_of_caravans:add_skip_action(
				function()
					tp:hide(true)
					core:hide_fullscreen_highlight()

					-- Steal input to block actions during transition.
					cm:steal_user_input(true)
				end
			)
		end,
		0 -- Interval to start action after section starts.
	)


	
	-- Create navigable tour section.
	local nts_dispatch_caravan = navigable_tour_section:new(
		"dispatch_caravan", -- name of tour section
		false -- activate controls on start
	)

	-- Create action of section
	nts_dispatch_caravan:action(
		function()
			-- Highlight componenets
			local uic = find_uicomponent("cathay_caravans", "dispatch_holder")
			core:show_fullscreen_highlight_around_components(5, false, true, uic)

			-- Point at component.
			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"left",
				50,
				uic,
				1,
				0.5
			)
			tp:add_component_text("text", "ui_text_replacements_localised_text_wh3_campaign_caravan_cargo")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:do_not_release_escape_key(true)
			tp:show()

			-- Responsible for cleaning up the action after the player moves forward.
			nts_dispatch_caravan:add_skip_action(
				function()
					tp:hide(true)
					core:hide_fullscreen_highlight()

					-- Steal input to block actions during transition.
					cm:steal_user_input(true)
				end
			)
		end,
		0 -- Interval to start action after section starts.
	)



	-- Create navigable tour section.
	local nts_caravan_start = navigable_tour_section:new(
		"caravan_start", -- name of tour section
		false -- activate controls on start
	)

	-- Create action of section
	nts_caravan_start:action(
		function()
			-- Disable tour controls until cam moved.
			disable_naviable_tour_controls(true, true)

			-- Scroll camera to first section.
			cm:scroll_camera_from_current(true, 1.5, {612.5, 367.5, 0.95, 0, 99.8})

			local uic = find_uicomponent("CcoCampaignRouteNode0_14", "round_small_button_toggle")

			cm:callback(
				function() 
					core:show_fullscreen_highlight_around_components(50, false, true, uic)
					disable_naviable_tour_controls(false)
				end, 
				2
			)
			
			-- Add text panel
			infotext:add_infotext(
				"wh3_main_st_campaign_caravans_caravan_start_title",
				"wh3_main_st_campaign_caravans_caravan_start_explanation"
			)

			-- Responsible for cleaning up the action after the player moves forward.
			nts_caravan_start:add_skip_action(
				function()
					core:hide_fullscreen_highlight()
					infotext:clear_infotext()

					-- Steal input to block actions during transition.
					cm:steal_user_input(true)
				end
			)
		end,
		0 -- Interval to start action after section starts.
	)



	-- Create navigable tour section.
	local nts_caravan_route = navigable_tour_section:new(
		"caravan_route", -- name of tour section
		false -- activate controls on start
	)

	-- Create action of section
	nts_caravan_route:action(
		function()
			-- Disable tour controls until cam moved.
			disable_naviable_tour_controls(true, true)

			-- Scroll camera to first section.
			cm:scroll_camera_from_current(true, 1.5, {588.9, 290.2, 0.95, 0, 99.8})

			local uic = find_uicomponent("CcoCampaignRouteNode0_2", "round_small_button_toggle")

			cm:callback(
				function() 
					core:show_fullscreen_highlight_around_components(50, false, true, uic)
					disable_naviable_tour_controls(false)
				end, 
				2
			)
			
			-- Add text panel
			infotext:add_infotext(
				"wh3_main_st_campaign_caravans_caravan_route_start",
				"wh3_main_st_campaign_caravans_caravan_route_explanation"
			)

			-- Responsible for cleaning up the action after the player moves forward.
			nts_caravan_route:add_skip_action(
				function()
					core:hide_fullscreen_highlight()
					infotext:clear_infotext()

					-- Steal input to block actions during transition.
					cm:steal_user_input(true)
				end
			)
		end,
		0 -- Interval to start action after section starts.
	)



	-- Create navigable tour section.
	local nts_caravan_destination = navigable_tour_section:new(
		"caravan_destination", -- name of tour section
		false -- activate controls on start
	)

	-- Create action of section
	nts_caravan_destination:action(
		function()
			-- Disable tour controls until cam moved.
			disable_naviable_tour_controls(true, true)

			-- Scroll camera to first section.
			cm:scroll_camera_from_current(true, 2, {398.5, 210.6, 0.95, 0, 99.8})

			local uic = find_uicomponent("CcoCampaignRouteNode0_17", "round_small_button_toggle")
			cm:callback(
				function() 
					core:show_fullscreen_highlight_around_components(70, false, true, uic)
					disable_naviable_tour_controls(false)
				end, 
				2.5
			)
			
			-- Add text panel
			infotext:add_infotext(
				"wh3_main_st_campaign_caravans_caravan_destination_title",
				"wh3_main_st_campaign_caravans_caravan_destination_explanation"
			)

			-- Responsible for cleaning up the action after the player moves forward.
			nts_caravan_destination:add_skip_action(
				function()
					core:hide_fullscreen_highlight()
					infotext:clear_infotext()

					-- Steal input to block actions during transition.
					cm:steal_user_input(true)
				end
			)
		end,
		0 -- Interval to start action after section starts.
	)



	-- Create navigable tour section.
	local nts_caravan_close = navigable_tour_section:new(
		"caravan_close", -- name of tour section
		false -- activate controls on start
	)

	-- Create action of section
	nts_caravan_close:action(
		function()
			-- Highlight componenets
			local uic = find_uicomponent("cathay_caravans", "caravans_panel", "dispatch_holder", "button_dispatch")
			core:show_fullscreen_highlight_around_components(5, false, true, uic)

			-- Point at component.
			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"left",
				50,
				uic,
				1,
				0.5
			)
			tp:add_component_text("text", "ui_text_replacements_localised_text_wh3_campaign_caravan_close")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:do_not_release_escape_key(true)
			tp:show()

			-- Responsible for cleaning up the action after the player moves forward.
			nts_caravan_close:add_skip_action(
				function()
					tp:hide(true)
					core:hide_fullscreen_highlight()

					-- Steal input to block actions during transition.
					cm:steal_user_input(true)
				end
			)
		end,
		0 -- Interval to start action after section starts.
	)



	-- Adding navigable tour sections in order of playback.
	nt_caravans:add_navigable_section(nts_caravans_panel)
	nt_caravans:add_navigable_section(nts_list_of_caravans)
	nt_caravans:add_navigable_section(nts_dispatch_caravan)
	nt_caravans:add_navigable_section(nts_caravan_start)
	nt_caravans:add_navigable_section(nts_caravan_route)
	nt_caravans:add_navigable_section(nts_caravan_destination)
	nt_caravans:add_navigable_section(nts_caravan_close)
	nt_caravans:start()
end



-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-- END_TURN_CAMERA
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------


-- intervention declaration
in_end_turn_camera = intervention:new(
	"in_end_turn_camera",												-- string name
	20,	 																-- cost
	function() trigger_in_end_turn_camera() end,						-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
)
in_end_turn_camera:add_precondition(function() return not cm:is_multiplayer() and not in_end_turn_camera:has_ever_triggered() end)

if not in_end_turn_camera:has_ever_triggered() then
	-- Value for storing number of factions that have ended turn in sequence. Will reset on player's turn.
	local no_of_start_turn_events = 0

	in_end_turn_camera:add_trigger_condition(
		"FactionTurnStart",
		function(context)  
			-- If advice is minimal, or turn number is less than 15, don't trigger.
			if not core:is_advice_level_high() or cm:turn_number() < 15 or context:faction():is_rebel() then 
				return false
			end
			
			-- Check whether the faction has met the player, which means they won't be a ??? in the camera panel. 
			-- Only check after 10 have happened. This delay is needed to stop the intervention triggering too late.
			local player_faction = cm:get_local_faction()
			local met_faction_list = context:faction():factions_met();
			if context:faction() == player_faction then
				no_of_start_turn_events = 0
			else
				no_of_start_turn_events = no_of_start_turn_events + 1
				if no_of_start_turn_events > 10 then
					for i = 0, met_faction_list:num_items() - 1 do
						if met_faction_list:item_at(i) == player_faction then
							return true
						end
					end
				end
			end
		end
	)
end
in_end_turn_camera:set_player_turn_only(false)
in_end_turn_camera:set_must_trigger(true, true)

function trigger_in_end_turn_camera()

	-- Click the pause button to stop the AI's end turn sequence.
	local uic = find_uicomponent("ai_turns", "main_holder", "bottom_parent", "controls", "button_pause")
	if uic then
		uic:SimulateLClick()
	else
		in_end_turn_camera:cancel()
	end



	nt_end_turn_camera = navigable_tour:new(
		"end_turn_camera", -- unique name 																
		function() end, -- end callback
		"ui_text_replacements_localised_text_wh3_campaign_end_turn_camera_navigable_tour_title" -- title string
	)
	nt_end_turn_camera:set_interval_before_tour_controls_visible(0)

	nt_end_turn_camera:start_action(
		function()
			-- Dismiss advice.
			cm:dismiss_advice()
			
			-- Set-up controls.
			infotext:attach_to_advisor(false) -- Unattach infotext to advisor
			nt_end_turn_camera:set_tour_controls_above_infotext(true) -- This must be called after infotext is unattached
			infotext:cache_and_set_detached_infotext_priority(1500, true)
			nt_end_turn_camera:cache_and_set_scripted_tour_controls_priority(1500, true)
			

			-- Get components
			local uic_scripted_tour_controls = find_uicomponent("under_advisor_docker", "scripted_tour_controls")
			local uic_target = find_uicomponent("ai_turns", "main_holder")

			-- Get positions
			local uic_target_pos_x, uic_target_pos_y = uic_target:Position()

			-- Get dimensions
			local uic_scripted_tour_controls_width, uic_scripted_tour_controls_height = uic_scripted_tour_controls:Dimensions()
			local uic_target_width, uic_target_height = uic_target:Dimensions()


			local uic_target_midpoint = uic_target_pos_y + (uic_target_height / 2)

			-- Move beside target component, half way down.
			uic_scripted_tour_controls:MoveTo((uic_target_pos_x + uic_target_width), uic_target_midpoint - (uic_scripted_tour_controls_height / 2))
		

			-- Disable escape key and shortcuts.
			cm:steal_escape_key(true)
			common.enable_all_shortcuts(false)
			cm:steal_user_input(true)
		end,
		0
	)

	nt_end_turn_camera:end_action( -- Called when the tour ends
		function() 
			infotext:attach_to_advisor(true) -- Reattach infotext to advisor
			infotext:restore_detatched_infotext_priority()
			
			-- Clean up escape key steal and shortcuts.
			cm:steal_escape_key(false)
			common.enable_all_shortcuts(true)
			cm:steal_user_input(false)
			
			nt_end_turn_camera:restore_scripted_tour_controls_priority()
			in_end_turn_camera:complete()
		end,
		0
	)



	-- Create navigable tour section.
	local nts_pause_button = navigable_tour_section:new(
		"pause_button", -- name of tour section
		false -- activate controls on start
	)

	
	-- Create action of section
	nts_pause_button:action(
		function()
			-- Highlight componenets
			local uic = find_uicomponent("ai_turns", "main_holder", "bottom_parent", "controls", "button_pause")
			core:show_fullscreen_highlight_around_components(5, false, true, uic)

			-- Point at component.
			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"top",
				50,
				uic,
				0.5,
				1
			)
			tp:add_component_text("text", "ui_text_replacements_localised_text_wh3_campaign_end_turn_pause")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:do_not_release_escape_key(true)
			tp:show()
			-- Responsible for cleaning up the action after the player moves forward.
			nts_pause_button:add_skip_action(
				function()
					tp:hide(true)
					core:hide_fullscreen_highlight()
				end
			)
		end,
		0 -- Interval to start action after section starts.
	)



	-- Create navigable tour section.
	local nts_camera_settings = navigable_tour_section:new(
		"camera_settings", -- name of tour section
		false -- activate controls on start
	)

	
	-- Create action of section
	nts_camera_settings:action(
		function()
			-- Highlight componenets
			local uic = find_uicomponent("settings_panel", "camera_settings")
			core:show_fullscreen_highlight_around_components(5, false, true, uic)

			-- Point at component.
			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"left",
				50,
				uic,
				1,
				0.5
			)
			tp:add_component_text("text", "ui_text_replacements_localised_text_wh3_campaign_camera_settings")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:do_not_release_escape_key(true)
			tp:show()

			-- Responsible for cleaning up the action after the player moves forward.
			nts_camera_settings:add_skip_action(
				function()
					tp:hide(true)
					core:hide_fullscreen_highlight()
				end
			)
		end,
		0 -- Interval to start action after section starts.
	)



	-- Create navigable tour section.
	local nts_camera_and_animation = navigable_tour_section:new(
		"camera_and_animation", -- name of tour section
		false -- activate controls on start
	)

	
	-- Create action of section
	nts_camera_and_animation:action(
		function()
			local table_of_components = {}
			local number_of_lists = 0

			-- Add relevant components.
			local uic = find_uicomponent("settings_panel", "camera_settings", "dropdowns_list", "armies")
			if uic and uic:Visible() then 
				number_of_lists = number_of_lists + 1

				-- Add uic.
				table.insert(table_of_components, uic)

				-- Check for two children.
				local uic_child_0 = find_child_uicomponent_by_index(uic, 0)
				local uic_child_1 = find_child_uicomponent_by_index(uic, 1)
				if uic_child_0 then table.insert(table_of_components, uic_child_0) end
				if uic_child_1 then table.insert(table_of_components, uic_child_1) end
			 end
			
			local uic_2 = find_uicomponent("settings_panel", "camera_settings", "dropdowns_list", "fleets")
			if uic_2 and uic_2:Visible() then 
				number_of_lists = number_of_lists + 1

				-- Add uic and two children.
				table.insert(table_of_components, uic_2)
				
				-- Check for two children.
				local uic_child_0 = find_child_uicomponent_by_index(uic_2, 0)
				local uic_child_1 = find_child_uicomponent_by_index(uic_2, 1)
				if uic_child_0 then table.insert(table_of_components, uic_child_0) end
				if uic_child_1 then table.insert(table_of_components, uic_child_1) end
			end

			local uic_3 = find_uicomponent("settings_panel", "camera_settings", "dropdowns_list", "heroes")
			if uic_3 and uic_3:Visible() then 
				number_of_lists = number_of_lists + 1

				-- Add uic and two children.
				table.insert(table_of_components, uic_3)
				
				-- Check for two children.
				local uic_child_0 = find_child_uicomponent_by_index(uic_3, 0)
				local uic_child_1 = find_child_uicomponent_by_index(uic_3, 1)
				if uic_child_0 then table.insert(table_of_components, uic_child_0) end
				if uic_child_1 then table.insert(table_of_components, uic_child_1) end
			end
			
			-- If values are in table, unpack it.
			if not table.is_empty(table_of_components) then
				core:show_fullscreen_highlight_around_components(5, false, true, unpack(table_of_components))
			end


			local uic_4 = find_uicomponent("settings_panel", "camera_settings", "dropdowns_list", "fleets", "dropdown_fleets_speed")
			local tp_x_position = 0
			local tp_y_position = 0

			-- If 3 lists, grab middle animation speed box for anchor. If not, use army.
			if number_of_lists == 3 then
				tp_x_position = 1
				tp_y_position = 0.5
			else
				tp_x_position = 1
				tp_y_position = 0
			end
			

			-- Point at component.
			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"left",
				50,
				uic_4,
				tp_x_position,
				tp_y_position
			)
			tp:add_component_text("text", "ui_text_replacements_localised_text_wh3_campaign_camera_and_animation")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:do_not_release_escape_key(true)
			tp:show()

			-- Responsible for cleaning up the action after the player moves forward.
			nts_camera_and_animation:add_skip_action(
				function()
					tp:hide(true)
					core:hide_fullscreen_highlight()
				end
			)
		end,
		0 -- Interval to start action after section starts.
	)



	-- Create navigable tour section.
	local nts_buttons_list = navigable_tour_section:new(
		"buttons_list", -- name of tour section
		false -- activate controls on start
	)


	-- Create action of section
	nts_buttons_list:action(
		function()
			-- Highlight componenets
			local uic = find_uicomponent("settings_panel", "camera_settings", "buttons_list")
			core:show_fullscreen_highlight_around_components(5, false, true, uic)

			-- Point at component.
			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"left",
				50,
				uic,
				1,
				0.5
			)
			tp:add_component_text("text", "ui_text_replacements_localised_text_wh3_campaign_categories")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:do_not_release_escape_key(true)
			tp:show()

			-- Responsible for cleaning up the action after the player moves forward.
			nts_buttons_list:add_skip_action(
				function()
					tp:hide(true)
					core:hide_fullscreen_highlight()
				end
			)
		end,
		0 -- Interval to start action after section starts.
	)



	-- Create navigable tour section.
	local nts_skip_button = navigable_tour_section:new(
		"skip_button", -- name of tour section
		false -- activate controls on start
	)

	-- Create action of section
	nts_skip_button:action(
		function()
			-- Highlight componenets
			local uic = find_uicomponent("ai_turns", "main_holder", "bottom_parent", "controls", "button_skip")
			core:show_fullscreen_highlight_around_components(5, false, true, uic)

			-- Point at component.
			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"top",
				50,
				uic,
				0.5,
				1
			)
			tp:add_component_text("text", "ui_text_replacements_localised_text_wh3_campaign_end_turn_speed")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:do_not_release_escape_key(true)
			tp:show()
			-- Responsible for cleaning up the action after the player moves forward.
			nts_skip_button:add_skip_action(
				function()
					tp:hide(true)
					core:hide_fullscreen_highlight()
				end
			)
		end,
		0 -- Interval to start action after section starts.
	)



	-- Adding navigable tour sections in order of playback.
	nt_end_turn_camera:add_navigable_section(nts_pause_button)
	nt_end_turn_camera:add_navigable_section(nts_camera_settings)
	nt_end_turn_camera:add_navigable_section(nts_camera_and_animation)
	nt_end_turn_camera:add_navigable_section(nts_buttons_list)
	nt_end_turn_camera:add_navigable_section(nts_skip_button)
	nt_end_turn_camera:start()
end



-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-- STARTING TOURS
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

core:add_listener(
	"LoadingScreenDismissedStartNavigableTours",
	"LoadingScreenDismissed",
	true,
	function()
		-- Campaign tours will only start once.
		if not cm:get_saved_value("campaign_tours_started") then
			in_daemon_prince_customisation:start()
			in_changing_of_the_ways:start()
			in_caravans:start()
			in_end_turn_camera:start()

			cm:set_saved_value("campaign_tours_started", true)
		end

		-- Send event for tours to trigger logic from.
		core:trigger_event("NavigableToursStarted")
	end,
	false
)