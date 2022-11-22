

-- set to false for release
BOOL_INTERVENTIONS_DEBUG = true;

-- Store whether first siege has played this turn.
local first_siege_just_played = false

--------------------------------------------------------------
----------------------- INTERVENTIONS ------------------------
--------------------------------------------------------------

--------------------------------------------------------------
-------------- VICTORY CONDITION FULFILLED -------------------
--------------------------------------------------------------
prologue_intervention_victory_condition_fulfilled = intervention:new(
	"prologue_victory_condition_fulfilled",
	0,
	function() prologue_victory_condition_fulfilled_intervention() end,
	BOOL_INTERVENTIONS_DEBUG
)

prologue_intervention_victory_condition_fulfilled:add_trigger_condition(
	"ScriptEventVictoryConditionFulfilled",
	true
);

prologue_intervention_victory_condition_fulfilled:set_should_prevent_saving_game()
prologue_intervention_victory_condition_fulfilled:set_wait_for_battle_complete(false)

function prologue_victory_condition_fulfilled_intervention()

	local uic_button_missions
	local uic_subpanel_victory_conditions
	local uic_tab_victory_conditions
	local uic_tx_title

	allow_hotkeys(false)

	local tour_test_victory_condition_fulfilled = scripted_tour:new(
		"tour_test_victory_condition_fulfilled",
		function()
			cm:steal_user_input(false)
			allow_hotkeys(true)
			cm:disable_shortcut("button_missions", "show_objectives", false)
			
			core:add_listener(
				"PanelClosedCampaignVictoryConditions",
				"PanelClosedCampaign",
				function(context) return context.string == "objectives_screen" end,
				function()
					prologue_intervention_victory_condition_fulfilled:complete()
					prologue_advice_leave_dervingard_004();
					--Metric check (step_number, step_name, skippable)
					cm:trigger_prologue_step_metrics_hit(71, "finished_victory_condition_tutorial", true);
				end,
				false
			)
		end
	)

	tour_test_victory_condition_fulfilled:action(
		function()
			out("STARTING_VICTORY_CONDITION_FULFILLED_TOUR_ACTION_1")
			
			cm:disable_shortcut("button_missions", "show_objectives", true)
			
			core:add_listener(
				"PanelOpenedCampaignVictoryConditions",
				"PanelOpenedCampaign",
				function(context) return context.string == "objectives_screen" end,
				function()
					core:hide_fullscreen_highlight(); 
					uic_tab_victory_conditions = find_uicomponent(core:get_ui_root(), "objectives_screen", "TabGroup", "tab_victory_conditions")
					uic_tab_victory_conditions:SimulateLClick()
					cm:steal_user_input(true)
					cm:callback(function() tour_test_victory_condition_fulfilled:start("tour_test_victory_condition_fulfilled_action_2") end, 0.5) 
				end,
				false
			)
		

			core:hide_fullscreen_highlight()
			core:show_fullscreen_highlight_around_components(2, false, true, uic_button_missions)

			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"bottom",
				100,
				uic_button_missions,
				0.5,
				0
			)
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_victory_condition_fulfilled_1")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:show()	
		end, 0,
	"tour_test_victory_condition_fulfilled_action_1"
	)

	tour_test_victory_condition_fulfilled:action(
		function()
			out("STARTING_VICTORY_CONDITION_FULFILLED_TOUR_ACTION_2")

			uic_subpanel_victory_conditions = find_uicomponent(core:get_ui_root(), "objectives_screen", "subpanel_victory_conditions")
			uic_tx_title = find_uicomponent(core:get_ui_root(), "objectives_screen", "subpanel_victory_conditions", "list_holder", "tx_title")

			core:hide_fullscreen_highlight()
			core:show_fullscreen_highlight_around_components(0, false, true, uic_subpanel_victory_conditions, uic_tx_title)

			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"bottom",
				100,
				uic_subpanel_victory_conditions,
				0.5,
				0
			)
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_victory_condition_fulfilled_2")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:set_close_button_callback(function() core:hide_fullscreen_highlight(); tour_test_victory_condition_fulfilled:complete() end)
			tp:show()	
		end, 0,
	"tour_test_victory_condition_fulfilled_action_2"
	)


	uic_button_missions = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_group_management", "button_missions")
	
	if uic_button_missions and uic_button_missions:Visible(true) then
		tour_test_victory_condition_fulfilled:set_show_skip_button(false)
		tour_test_victory_condition_fulfilled:start("tour_test_victory_condition_fulfilled_action_1")
	else
		cm:steal_user_input(false)
		allow_hotkeys(true)
		prologue_intervention_victory_condition_fulfilled:cancel()
		prologue_advice_leave_dervingard_004();
	end
end

--------------------------------------------------------------
-------------- QUEST BATTLE ENEMY STRONGER -------------------
--------------------------------------------------------------
prologue_intervention_quest_battle_enemy_stronger = intervention:new(
	"prologue_quest_battle_enemy_stronger",
	0,
	function() prologue_quest_battle_enemy_stronger_intervention() end,
	BOOL_INTERVENTIONS_DEBUG
)

prologue_intervention_quest_battle_enemy_stronger:add_trigger_condition(
	"ScriptEventQuestBattleEnemyStronger",
	true
);

prologue_intervention_quest_battle_enemy_stronger:set_should_prevent_saving_game()
prologue_intervention_quest_battle_enemy_stronger:set_wait_for_battle_complete(false)
prologue_intervention_quest_battle_enemy_stronger:set_wait_for_fullscreen_panel_dismissed(false)

function prologue_quest_battle_enemy_stronger_intervention()

	local uic_allies_combatants_panels
	local uic_enemy_combatants_panels
	local uic_button_retreat

	cm:steal_user_input(true)
	cm:contextual_vo_enabled(false);

	local tour_test_quest_battle_enemy_stronger = scripted_tour:new(
		"tour_test_quest_battle_enemy_stronger",
		function()
			prologue_check_progression["st_quest_battle_enemy_stronger"] = true
			cm:steal_user_input(false)
			prologue_intervention_quest_battle_enemy_stronger:complete()
			cm:contextual_vo_enabled(true);
		end
	)

	tour_test_quest_battle_enemy_stronger:action(
		function()
			out("STARTING_QUEST_BATTLE_ENEMY_STRONGER_TOUR_ACTION_1")

			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"bottom",
				100,
				uic_enemy_combatants_panels,
				0.5,
				0
			)
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_quest_battle_enemy_stronger_1")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:set_close_button_callback(function() cm:callback(function() tour_test_quest_battle_enemy_stronger:start("tour_test_quest_battle_enemy_stronger_action_2") end, 0.5) end)
			tp:show()	
		end, 0,
	"tour_test_quest_battle_enemy_stronger_action_1"
	)

	tour_test_quest_battle_enemy_stronger:action(
		function()
			out("STARTING_QUEST_BATTLE_ENEMY_STRONGER_TOUR_ACTION_2")

			core:hide_fullscreen_highlight()
			core:show_fullscreen_highlight_around_components(0, false, false, uic_allies_combatants_panels)

			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"bottom",
				100,
				uic_allies_combatants_panels,
				0.5,
				0
			)
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_quest_battle_enemy_stronger_2")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:set_close_button_callback(function() cm:callback(function() tour_test_quest_battle_enemy_stronger:start("tour_test_quest_battle_enemy_stronger_action_3") end, 0.5) end)
			tp:show()	
		end, 0,
	"tour_test_quest_battle_enemy_stronger_action_2"
	)

	tour_test_quest_battle_enemy_stronger:action(
		function()
			out("STARTING_QUEST_BATTLE_ENEMY_STRONGER_TOUR_ACTION_3")

			core:hide_fullscreen_highlight()
			core:show_fullscreen_highlight_around_components(0, false, false, uic_button_retreat)

			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"bottom",
				100,
				uic_button_retreat,
				0.5,
				0
			)
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_quest_battle_enemy_stronger_3")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:set_close_button_callback(function() tour_test_quest_battle_enemy_stronger:complete() end)
			tp:show()	
		end, 0,
	"tour_test_quest_battle_enemy_stronger_action_3"
	)

	cm:callback(
		function()		
			uic_allies_combatants_panels = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "allies_combatants_panel")
			uic_enemy_combatants_panels = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "enemy_combatants_panel")
			uic_button_retreat = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "mid", "battle_deployment", "regular_deployment", "button_set_attack", "button_retreat")
			
			if uic_allies_combatants_panels and uic_allies_combatants_panels:Visible(true) and uic_enemy_combatants_panels and uic_enemy_combatants_panels:Visible(true) and uic_button_retreat and uic_button_retreat:Visible(true) then
				tour_test_quest_battle_enemy_stronger:add_fullscreen_highlight("popup_pre_battle", "enemy_combatants_panel")
				tour_test_quest_battle_enemy_stronger:set_show_skip_button(false)
				tour_test_quest_battle_enemy_stronger:start("tour_test_quest_battle_enemy_stronger_action_1")
			else
				cm:steal_user_input(false)
				prologue_intervention_quest_battle_enemy_stronger:cancel()
			end
		end,
	0.5)
end

--------------------------------------------------------------
-------------------- QUEST BATTLE LOSS -----------------------
--------------------------------------------------------------
prologue_intervention_quest_battle_loss = intervention:new(
	"prologue_quest_battle_loss",
	0,
	function() prologue_quest_battle_loss_intervention() end,
	BOOL_INTERVENTIONS_DEBUG
)

prologue_intervention_quest_battle_loss:add_trigger_condition(
	"ScriptEventQuestBattleLoss",
	true
);

prologue_intervention_quest_battle_loss:set_should_prevent_saving_game()
prologue_intervention_quest_battle_loss:set_should_lock_ui(true)
prologue_intervention_quest_battle_loss:set_wait_for_battle_complete(false)
prologue_intervention_quest_battle_loss:set_wait_for_fullscreen_panel_dismissed(false)

function prologue_quest_battle_loss_intervention()

	local uic_battle_results

	cm:steal_user_input(true)
	cm:contextual_vo_enabled(false);

	local tour_test_quest_battle_loss = scripted_tour:new(
		"tour_test_quest_battle_loss",
		function()
			prologue_check_progression["st_quest_battle_loss"] = true
			cm:steal_user_input(false)
			prologue_intervention_quest_battle_loss:complete()
			cm:contextual_vo_enabled(true);
		end
	)

	tour_test_quest_battle_loss:action(
		function()
			out("STARTING_QUEST_BATTLE_LOSS_TOUR_ACTION_1")

			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"bottom",
				100,
				uic_battle_results,
				0.5,
				0
			)
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_quest_battle_loss")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:set_close_button_callback(function() cm:callback(function() tour_test_quest_battle_loss:complete() end, 0.5) end)
			tp:show()	
		end, 0,
	"tour_test_quest_battle_loss_action_1"
	)

	cm:callback(
		function()		
			uic_battle_results = find_uicomponent(core:get_ui_root(), "popup_battle_results", "battle_results")
			
			if uic_battle_results and uic_battle_results:Visible(true) then
				tour_test_quest_battle_loss:add_fullscreen_highlight("popup_battle_results", "battle_results")
				tour_test_quest_battle_loss:set_show_skip_button(false)
				tour_test_quest_battle_loss:start("tour_test_quest_battle_loss_action_1")
			else
				cm:steal_user_input(false)
				prologue_intervention_quest_battle_loss:cancel()
			end
		end,
	0.5)
end

--------------------------------------------------------------
------------------ SWITCH COMMANDERS ------------------------
--------------------------------------------------------------
prologue_intervention_switch_commanders = intervention:new(
	"prologue_switch_commanders",
	0,
	function() prologue_switch_commanders_intervention() end,
	BOOL_INTERVENTIONS_DEBUG
)

prologue_intervention_switch_commanders:add_trigger_condition(
	"ScriptEventSwitchCommanders",
	true
);

prologue_intervention_switch_commanders:set_should_prevent_saving_game()
prologue_intervention_switch_commanders:set_should_lock_ui(true)
prologue_intervention_switch_commanders:set_wait_for_fullscreen_panel_dismissed(false)


function prologue_switch_commanders_intervention()

	local uic_main_units_panel

	cm:steal_user_input(true)
	cm:contextual_vo_enabled(false);

	local tour_test_switch_commanders = scripted_tour:new(
		"tour_test_switch_commanders",
		function()
			cm:steal_user_input(false)
			prologue_intervention_switch_commanders:complete()
			prologue_check_progression["st_switch_commanders"] = true
			cm:contextual_vo_enabled(true);
		end
	)

	tour_test_switch_commanders:action(
		function()
			out("STARTING_SWITCH_COMMANDERS_TOUR_ACTION_1")

			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"bottom",
				100,
				uic_main_units_panel,
				0.5,
				0
			)	
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_switch_commanders")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:set_close_button_callback(function() cm:callback(function() tour_test_switch_commanders:complete() end, 0.5) end)
			tp:show()	
		end, 0,
	"tour_test_switch_commanders_action_1"
	)

	cm:callback(
		function ()		
			uic_main_units_panel = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel")
			
			if uic_main_units_panel and uic_main_units_panel:Visible(true) then
				tour_test_switch_commanders:add_fullscreen_highlight("units_panel", "main_units_panel")
				tour_test_switch_commanders:set_show_skip_button(false)
				tour_test_switch_commanders:start("tour_test_switch_commanders_action_1")
			else
				cm:steal_user_input(false)
				prologue_intervention_switch_commanders:cancel()
			end
		end,
	0.5)
end

--------------------------------------------------------------
------------------ LORD DEATH COMMANDING ---------------------
--------------------------------------------------------------
prologue_intervention_lord_death_commanding = intervention:new(
	"prologue_lord_death_commanding",
	0,
	function() prologue_lord_death_commanding_intervention() end,
	BOOL_INTERVENTIONS_DEBUG
)

prologue_intervention_lord_death_commanding:add_trigger_condition(
	"ScriptEventLordDeathCommanding",
	true
);

prologue_intervention_lord_death_commanding:set_should_prevent_saving_game()
prologue_intervention_lord_death_commanding:set_should_lock_ui(true)
prologue_intervention_lord_death_commanding:set_must_trigger()
prologue_intervention_lord_death_commanding:set_wait_for_fullscreen_panel_dismissed(false)

function prologue_lord_death_commanding_intervention()
	
	cancel_death_intervention(prologue_intervention_lord_death_commanding)
	
	-- Suppressing all events. This is needed to stop the mission compelte around here from closing the character panel (mission complete and dilemmas are not blocked.)
	CampaignUI.SuppressAllEventTypesInUI(true)

	completely_lock_input(true)
	allow_hotkeys(false)
	cm:contextual_vo_enabled(false);

	local uic_frame
	local uic_general_selection_panel
	-- This must be set to true so the small bar on the settlement panel will appear. If the
	-- intervention is cancelled, it is set to false again.
	prologue_check_progression["lord_death_commanding"] = true

	-- Activates lord recruitment button.
	uim:override("settlement_panel_lord_recruit_with_button_hidden"):set_allowed(true)
	cm:steal_user_input(true)

	local tour_test_lord_death_commanding = scripted_tour:new(
		"tour_test_lord_death_commanding",
		function()
			AddYuriDeathObjective(); allow_hotkeys(true); end_death_intervention(prologue_intervention_lord_death_commanding)
			cm:contextual_vo_enabled(true);
		end
	)

	tour_test_lord_death_commanding:action(
		function()
			out("STARTING_LORD_DEATH_COMMANDING_TOUR_ACTION_1")

			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"top",
				100,
				uic_frame,
				0.5,
				1
			)	
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_lord_death_commanding_1")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:set_close_button_callback(function() cm:callback(function() tour_test_lord_death_commanding:start("tour_test_lord_death_commanding_action_2") end, 0.5) end)
			tp:show()	
		end, 0,
	"tour_test_lord_death_commanding_action_1"
	)

	tour_test_lord_death_commanding:action(
		function()
			out("STARTING_LORD_DEATH_COMMANDING_TOUR_ACTION_2")

			core:hide_fullscreen_highlight()
			core:show_fullscreen_highlight_around_components(0, false, false, uic_general_selection_panel)

			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"top",
				100,
				uic_general_selection_panel,
				0.5,
				1
			)	
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_lord_death_commanding_2")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:set_close_button_callback(function() cm:callback(function() tour_test_lord_death_commanding:start("tour_test_lord_death_commanding_action_3") end, 0.5) end)
			tp:show()	
		end, 0,
	"tour_test_lord_death_commanding_action_2"
	)

	tour_test_lord_death_commanding:action(
		function()
			out("STARTING_LORD_DEATH_COMMANDING_TOUR_ACTION_3")

			cm:steal_user_input(false)
			core:hide_fullscreen_highlight()

			core:add_listener(
				"PanelClosedCampaignWaitForGeneralSelection",
				"PanelClosedCampaign",
				function(context) return context.string == "appoint_new_general" end,
				function()
					cm:steal_user_input(true)
					uim:override("settlement_panel_lord_recruit_with_button_hidden"):set_allowed(true)

					cm:callback(
						function()
							cm:steal_user_input(false)
							common.call_context_command("CcoCampaignSettlement", 1, "SelectAndZoom(false)")
							cm:steal_user_input(true)
							
							cm:callback(
								function() 
									local uic_lord_recruit_button = find_uicomponent(core:get_ui_root(), "hud_campaign", "hud_center_docker", "hud_center", "small_bar", "button_subpanel_parent", "button_subpanel", "button_group_settlement", "button_create_army")
									
									core:show_fullscreen_highlight_around_components(0, false, false, uic_lord_recruit_button)

									local tp = text_pointer:new_from_component(
										"tp_scripted_tour",
										"bottom",
										100,
										uic_lord_recruit_button,
										0.5,
										0
									)	
									tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_lord_death_commanding_3")
									tp:set_style("semitransparent")
									tp:set_topmost(true)
									tp:set_highlight_close_button(0.5)
									tp:set_close_button_callback(function() cm:callback(function() tour_test_lord_death_commanding:complete() end, 0.5) end)
									tp:show()	
								end, 
								1
							)
						end,
						1
					)
				end,
				false
			)
		end, 0,
	"tour_test_lord_death_commanding_action_3"
	)

	cm:callback(
		function ()		
			local tour_started
			uic_frame = find_uicomponent(core:get_ui_root(), "panel_manager", "appoint_new_general", "event_appoint_new_general", "frame")
			uic_general_selection_panel = find_uicomponent(core:get_ui_root(), "panel_manager", "appoint_new_general", "event_appoint_new_general", "general_selection_panel", "frame")
			
			if uic_general_selection_panel and uic_general_selection_panel:Visible(true) and uic_frame and uic_frame:Visible(true) then
				tour_started = true
			end
			
			if tour_started then
				tour_test_lord_death_commanding:add_fullscreen_highlight("panel_manager", "appoint_new_general", "event_appoint_new_general", "frame")
				tour_test_lord_death_commanding:set_show_skip_button(false)
				tour_test_lord_death_commanding:start("tour_test_lord_death_commanding_action_1")
				prologue_tutorial_passed["settlement_panel_lord_recruit_with_button_hidden"] = true
			else
				cm:steal_user_input(false)
				prologue_check_progression["lord_death_commanding"] = false

				if not prologue_tutorial_passed["settlement_panel_lord_recruit_with_button_hidden"] then
					uim:override("settlement_panel_lord_recruit_with_button_hidden"):set_allowed(false);
				end
				completely_lock_input(false)
				allow_hotkeys(true)
				prologue_intervention_lord_death_commanding:cancel()
			end
		end,
	0.5)
end

--------------------------------------------------------------
----------------------------- INCOME ----------------------
--------------------------------------------------------------
prologue_intervention_income = intervention:new(
	"prologue_income",
	0,
	function() prologue_income_intervention() end,
	BOOL_INTERVENTIONS_DEBUG
)

prologue_intervention_income:add_trigger_condition(
	"ScriptEventIncome",
	true
);

prologue_intervention_income:set_should_prevent_saving_game()
prologue_intervention_income:set_should_lock_ui(true)
prologue_intervention_income:set_wait_for_fullscreen_panel_dismissed(false)

function prologue_income_intervention()

	local uic_dy_income
	local uic_tx_b1
	local uic_tx_b2
	local uic_treasury_holder
	local uic_dy_treasury
	local uic_settlement
	local uic_building_slot
	local cqi = cm:model():world():province_by_key("wh3_prologue_province_mountain_pass"):capital_region():cqi()


	cm:model():world():faction_by_key(prologue_player_faction):military_force_list(); 
	common.call_context_command("CcoCampaignSettlement", cqi, "Select(false)");
	cm:steal_user_input(true)

	local tour_test_income = scripted_tour:new(
		"tour_test_income",
		function()
			cm:steal_user_input(false)
			prologue_check_progression["st_income_complete"] = true
			prologue_intervention_income:complete()

			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(19, "finished_income_tutorial", true);

			prologue_advice_fleeing_from_dervingard_incident()
		end
	)
	tour_test_income:set_show_skip_button(false);

	tour_test_income:action(
		function()
			out("STARTING_INCOME_TOUR_ACTION_1")

			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"bottom",
				100,
				uic_building_slot,
				0.5,
				0
			)	
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_income_1")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:set_close_button_callback(function() cm:callback(function() tour_test_income:start("tour_test_income_action_2") end, 0.5) end)
			tp:show()	
		end, 0,
	"tour_test_income_action_1"
	)

	tour_test_income:action(
		function()
			out("STARTING_INCOME_TOUR_ACTION_2")
			
			core:hide_fullscreen_highlight()
			core:show_fullscreen_highlight_around_components(0, false, false, uic_dy_income, uic_tx_b1, uic_tx_b1)

			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"top",
				100,
				uic_dy_income,
				0.5,
				1
			)	
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_income_2")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:set_close_button_callback(function() cm:callback(function() tour_test_income:start("tour_test_income_action_3") end, 0.5) end)
			tp:show()	
		end, 0,
	"tour_test_income_action_2"
	)

	tour_test_income:action(
		function()
			out("STARTING_INCOME_TOUR_ACTION_3")
			
			core:hide_fullscreen_highlight()
			core:show_fullscreen_highlight_around_components(0, false, false, uic_treasury_holder)

			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"top",
				100,
				uic_dy_treasury,
				0.5,
				1
			)	
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_income_3")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:set_close_button_callback(function() tour_test_income:complete() end)
			tp:show()	
		end, 0,
	"tour_test_income_action_3"
	)

	cm:callback(
		function ()
			local tour_started
			local uic_settlement_panel = find_uicomponent("settlement_panel")

			uic_dy_income = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "treasury_holder", "dy_income")
			uic_tx_b1 = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "treasury_holder", "tx_(")
			uic_tx_b2 = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "treasury_holder", "tx_)")
			uic_dy_treasury = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "treasury_holder", "dy_treasury")
			uic_treasury_holder =  find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "treasury_holder")

			if uic_dy_income and uic_treasury_holder and uic_tx_b1 and uic_tx_b2 and uic_dy_treasury and uic_dy_treasury:Visible(true) then
				uic_dy_income:SetVisible(true)
				uic_tx_b1:SetVisible(true)
				uic_tx_b2:SetVisible(true)
				
				if uic_settlement_panel then
					local uic_parent = find_uicomponent("settlement_panel", "settlement_list")
					if uic_parent and uic_parent:ChildCount() > 0 then
						uic_settlement = UIComponent(uic_parent:Find(1))
						if uic_settlement then
							local uic_default_slots_list = find_uicomponent(uic_settlement, "default_slots_list")
	
							if uic_default_slots_list and uic_default_slots_list:ChildCount() > 1 then
								uic_building_slot = UIComponent(uic_default_slots_list:Find(2))
								if uic_building_slot then
									tour_started = true
								end
							end
						end
					end
				end
			end
									
			if tour_started then
				tour_test_income:add_fullscreen_highlight("settlement_panel", "settlement_list", uic_settlement:Id(), uic_building_slot:Id())
				tour_test_income:start("tour_test_income_action_1")
			else
				cm:steal_user_input(false)
				prologue_intervention_income:cancel()
				prologue_advice_fleeing_from_dervingard_incident()
			end
		end,
	1)
end

--------------------------------------------------------------
---------------------------- ITEMS ---------------------------
--------------------------------------------------------------
prologue_intervention_items = intervention:new(
	"prologue_items",
	0,
	function() prologue_items_intervention() end,
	BOOL_INTERVENTIONS_DEBUG
)

prologue_intervention_items:add_trigger_condition(
	"ScriptEventItems",
	true
);
prologue_intervention_items:set_should_prevent_saving_game()
prologue_intervention_items:set_should_lock_ui(true)
prologue_intervention_items:set_wait_for_fullscreen_panel_dismissed(false)

function prologue_items_intervention()
	
	completely_lock_input(true)
	allow_hotkeys(false)
	cm:contextual_vo_enabled(false);

	steal_input_completely_on_event(true, "PanelOpenedCampaign", function(context) return context.string == "character_details_panel" end , 0.01, "PanelOpenedCampaignStealEscItems", "PanelOpenedCampaignStealUserInputItems", prologue_intervention_items)
	uim:override("character_details_with_button_hidden"):set_allowed(true)
	prologue_tutorial_passed["character_details_with_button_hidden"] = true
	common.call_context_command("CcoCampaignCharacter", prologue_player_cqi, "Select(false)")
	cm:add_ancillary_to_faction(prologue_player_faction_interface, "wh3_prologue_anc_armour_basic", true)
	cm:add_ancillary_to_faction(prologue_player_faction_interface, "wh3_prologue_anc_follower_orthodoxy_pastor", true)

	local uic_character_details

	local tour_test_items_5 = scripted_tour:new(
		"tour_test_items_5",
		function()
			completely_lock_input(false)
			allow_hotkeys(true)

			prologue_check_progression["item_scripted_tour"] = true
			UnlockItemGeneration(true)

			-- Need to pre-set these as it's possible to save here.
			if prologue_story_choice == 2 then
				prologue_load_check = "end_item_scripted_tour"
				prologue_current_objective = "wh3_prologue_objective_turn_005_04"
			else
				prologue_load_check = "end_item_scripted_tour"
				prologue_current_objective = "wh3_prologue_objective_turn_005_03"
			end

			local uic_button_ok = find_uicomponent("character_details_panel", "button_ok")
			uic_button_ok:Highlight(true, false)
			
			core:add_listener(
				"PanelClosedCampaignRemoveHighlight",
				"PanelClosedCampaign",
				function(context) 
					return context.string == "character_details_panel" 
				end,
				function()
					local uic_button_ok = find_uicomponent("character_details_panel", "button_ok")
					uic_button_ok:Highlight(false, false)
				end,
				false
			)

			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(25, "finished_equipment_tutorial", true);

			prologue_intervention_items:complete()
			cm:contextual_vo_enabled(true);
			uim:override("disable_help_pages_panel_button"):set_allowed(true);
		end
	)

	local tour_test_items_4 = scripted_tour:new(
		"tour_test_items_4",
		function()
			cm:callback(
				function()
					tour_test_items_5:add_fullscreen_highlight("character_details_panel", "character_context_parent", "tab_panels", "character_details_subpanel", "equipment_holder", "global_pool")
					tour_test_items_5:start("tour_test_items_5_action_1")
				end,
				1
			)
		end
	)

	local tour_test_items_3 = scripted_tour:new(
		"tour_test_items_3",
		function()
			cm:callback(
				function()
					tour_test_items_4:add_fullscreen_highlight("character_details_panel", "character_context_parent", "tab_panels", "character_details_subpanel", "equipment_holder", "global_pool", "buttons", "general_ancillaries_button")
					tour_test_items_4:set_fullscreen_highlight_padding(3)
					tour_test_items_4:start("tour_test_items_4_action_1")
				end,
				1
			)
		end
	)

	local tour_test_items_2 = scripted_tour:new(
		"tour_test_items_2",
		function()
			cm:callback(
				function()
					tour_test_items_3:add_fullscreen_highlight("character_details_panel", "character_context_parent", "tab_panels", "character_details_subpanel", "equipment_holder", "global_pool")
					tour_test_items_3:start("tour_test_items_3_action_1")
				end,
				1
			)
		end
	)

	local tour_test_items_1 = scripted_tour:new(
		"tour_test_items_1",
		function()
			cm:callback(
				function()
					tour_test_items_2:add_fullscreen_highlight("character_details_panel", "character_context_parent", "tab_panels", "character_details_subpanel", "equipment_holder", "ancillary_parent")
					tour_test_items_2:start("tour_test_items_2_action_1")
				end,
				1.5
			)
		end
	)

	tour_test_items_1:action(
		function()
			out("STARTING_items_TOUR_1_ACTION_1")

			cm:steal_user_input(false)

			add_callback_button_press_intervention("button_general", true, function() tour_test_items_1:complete() end)
			
			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"bottom",
				100,
				uic_character_details,
				0.5,
				0
			)	
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_items_1")
			tp:set_label_offset(120, 0)
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:show()	
		end, 0,
	"tour_test_items_1_action_1"
	)

	tour_test_items_2:action(
		function()
			out("STARTING_items_TOUR_2_ACTION_1")
			local uic = find_uicomponent(core:get_ui_root(), "character_details_panel", "character_context_parent", "tab_panels", "character_details_subpanel", "equipment_holder", "ancillary_parent")
			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"right",
				100,
				uic,
				0,
				0.5
			)	
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_items_2")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:set_close_button_callback(function() tour_test_items_2:complete() end)
			tp:show()	
		end, 0,
	"tour_test_items_2_action_1"
	)

	tour_test_items_3:action(
		function()
			out("STARTING_items_TOUR_3_ACTION_1")
			cm:steal_user_input(false)

			local uic = find_uicomponent(core:get_ui_root(), "character_details_panel", "character_context_parent", "tab_panels", "character_details_subpanel", "equipment_holder", "global_pool", "global_ancillaries_listview", "list_clip", "list_box", "magic_items_panel", "CcoCampaignAncillary1")
			local uic_2 = find_uicomponent(core:get_ui_root(), "character_details_panel", "character_context_parent", "tab_panels", "character_details_subpanel", "equipment_holder", "global_pool", "buttons", "general_ancillaries_button")
			uic_2:SetInteractive(false)

			core:add_listener(
				"CharacterAncillaryGainedST",
				"CharacterAncillaryGained",
				true,
				function() 
					uic_2:SetInteractive(true)
					cm:steal_user_input(true)
					tour_test_items_3:complete()
				end,
				false
			)

			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"right",
				100,
				uic,
				0,
				0.5
			)	
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_items_3")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:show()	
		end, 0,
	"tour_test_items_3_action_1"
	)

	tour_test_items_4:action(
		function()
			out("STARTING_items_TOUR_4_ACTION_1")
			add_callback_button_press_intervention("general_ancillaries_button", true, function() tour_test_items_4:complete() end)

			cm:steal_user_input(false)

			local uic = find_uicomponent(core:get_ui_root(), "character_details_panel", "character_context_parent", "tab_panels", "character_details_subpanel", "equipment_holder", "global_pool", "buttons", "general_ancillaries_button")
			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"right",
				100,
				uic,
				0,
				0.5
			)	
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_items_4")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:show()	
		end, 0,
	"tour_test_items_4_action_1"
	)

	tour_test_items_5:action(
		function()
			out("STARTING_items_TOUR_5_ACTION_1")
			cm:steal_user_input(false)

			local uic = find_uicomponent(core:get_ui_root(), "character_details_panel", "character_context_parent", "tab_panels", "character_details_subpanel", "equipment_holder", "global_pool", "global_ancillaries_listview", "list_clip", "list_box", "general_ancillaries_panel", "CcoCampaignAncillary2")
			local uic_2 = find_uicomponent(core:get_ui_root(), "character_details_panel", "character_context_parent", "tab_panels", "character_details_subpanel", "equipment_holder", "global_pool", "buttons", "magic_items_button")
			uic_2:SetInteractive(false)

			core:add_listener(
				"CharacterAncillaryGainedST",
				"CharacterAncillaryGained",
				true,
				function() 
					uic_2:SetInteractive(true)
					cm:steal_user_input(false)
					tour_test_items_5:complete()
				end,
				false
			)

			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"right",
				100,
				uic,
				0,
				0.5
			)	
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_items_5")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:show()	
		end, 0,
	"tour_test_items_5_action_1"
	)

	cm:callback(
		function ()
			uic_character_details = find_uicomponent(core:get_ui_root(), "hud_campaign", "info_panel_holder", "primary_info_panel_holder", "info_button_list", "button_general")
			if uic_character_details and uic_character_details:Visible(true) then
				tour_test_items_1:set_show_skip_button(false)
				tour_test_items_2:set_show_skip_button(false)
				tour_test_items_3:set_show_skip_button(false)
				tour_test_items_4:set_show_skip_button(false)
				tour_test_items_5:set_show_skip_button(false)
				tour_test_items_1:add_fullscreen_highlight("hud_campaign", "info_panel_holder", "primary_info_panel_holder", "info_button_list", "button_general")
				tour_test_items_1:start("tour_test_items_1_action_1")
			else
				completely_lock_input(false)
				allow_hotkeys(true)
				prologue_intervention_items:cancel()
				cm:contextual_vo_enabled(true);
				if prologue_story_choice == 2 then
					prologue_load_check = "end_item_scripted_tour"
					prologue_current_objective = "wh3_prologue_objective_turn_005_04"
				else
					prologue_load_check = "end_item_scripted_tour"
					prologue_current_objective = "wh3_prologue_objective_turn_005_03"
				end
			end
		end,
	1)
end



--------------------------------------------------------------
----------------------- INCOME REMINDER ----------------------
--------------------------------------------------------------
prologue_intervention_income_reminder = intervention:new(
	"prologue_income_reminder",
	0,
	function() prologue_income_reminder_intervention() end,
	BOOL_INTERVENTIONS_DEBUG
)

prologue_intervention_income_reminder:add_trigger_condition(
	"ScriptEventIncomeReminder",
	true
);

prologue_intervention_income_reminder:set_should_prevent_saving_game()
prologue_intervention_income_reminder:set_should_lock_ui(true)

function prologue_income_reminder_intervention()
	
	local uic_dy_income

	cm:contextual_vo_enabled(false);

	tour_test_income_reminder_1 = scripted_tour:new(
		"tour_test_income_reminder_1",
		function()
			cm:steal_user_input(false)
			prologue_check_progression["income_reminder"] = true
			core:remove_listener("FactionTurnStartIncomeReminder")
			prologue_intervention_income_reminder:complete()
			cm:contextual_vo_enabled(true);
		end
	)
	tour_test_income_reminder_1:set_show_skip_button(false);

	tour_test_income_reminder_1:action(
		function()
			out("STARTING_income_reminder_TOUR_1_ACTION_1")

			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"top",
				100,
				uic_dy_income,
				0.5,
				1
			)	
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_income_reminder")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:set_close_button_callback(function() tour_test_income_reminder_1:complete() end)
			tp:show()	
		end, 0,
	"tour_test_income_reminder_1_action_1"
	)

	cm:callback(
		function ()
			uic_dy_income = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar", "treasury_holder", "dy_income")
			if uic_dy_income and uic_dy_income:Visible(true) then
				cm:steal_user_input(true)
				tour_test_income_reminder_1:add_fullscreen_highlight("hud_campaign", "resources_bar_holder", "resources_bar", "treasury_holder", "dy_income")
				tour_test_income_reminder_1:start("tour_test_income_reminder_1_action_1")
			else
				cm:steal_user_input(false)
				prologue_intervention_income_reminder:cancel()
			end
		end,
	1)
end

--------------------------------------------------------------
----------------------- REGIMENTS OF RENOWN ------------------
--------------------------------------------------------------
prologue_intervention_ror = intervention:new(
	"prologue_ror",
	0,
	function() prologue_ror_intervention() end,
	BOOL_INTERVENTIONS_DEBUG
)

prologue_intervention_ror:add_trigger_condition(
	"ScriptEventROR",
	true
);

prologue_intervention_ror:set_should_prevent_saving_game()
prologue_intervention_ror:set_should_lock_ui(true)

function prologue_ror_intervention()
	
	cm:steal_user_input(true)
	cm:contextual_vo_enabled(false);
	
	local uic_button_renown
	local character_list = cm:model():world():faction_by_key(prologue_player_faction):character_list()
	local character_clicked = false

			
	for i = 0, character_list:num_items() -1 do
		if character_list:item_at(i):character_type("general") then
			if character_clicked == false then
				cqi = character_list:item_at(i):cqi()
				common.call_context_command("CcoCampaignCharacter", cqi, "Select(false)");
				character_clicked = true
			end
		end
	end

	if character_clicked == false then
		cm:steal_user_input(false)
		prologue_intervention_ror:cancel()
	end

	tour_test_ror_1 = scripted_tour:new(
		"tour_test_ror_1",
		function()
			cm:callback(function() tour_test_ror_2:start("tour_test_ror_2_action_1") end, 1.5)
		end
	)
	tour_test_ror_1:set_show_skip_button(false);
				
	tour_test_ror_2 = scripted_tour:new(
		"tour_test_ror_2",
		function()
			cm:steal_user_input(false)
			prologue_intervention_ror:complete()
			cm:contextual_vo_enabled(true);
		end
	)
	tour_test_ror_2:set_show_skip_button(false);

	tour_test_ror_1:action(
		function()
			out("STARTING_ROR_TOUR_1_ACTION_1")

			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"bottom",
				100,
				uic_button_renown,
				0.5,
				0
			)	
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_regiments_of_renown_1")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:set_close_button_callback(function() cm:steal_user_input(false); uic_button_renown:SimulateLClick(); cm:steal_user_input(true); tour_test_ror_1:complete() end)
			tp:show()	
		end, 0,
	"tour_test_ror_1_action_1"
	)
	
	tour_test_ror_2:action(
		function()
			
			out("STARTING_ROR_TOUR_2_ACTION_1")
			local uic_recruitment_options = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel", "recruitment_docker", "recruitment_options")
			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"bottom",
				100,
				uic_recruitment_options,
				0.5,
				0
			)	
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_regiments_of_renown_2")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:set_close_button_callback(function() tour_test_ror_2:complete() end)
			tp:show()	
		end, 0,
	"tour_test_ror_2_action_1"
	)

	cm:callback(
		function ()
			uic_button_renown = find_uicomponent(core:get_ui_root(), "hud_center_docker", "hud_center", "button_renown")
			if uic_button_renown and uic_button_renown:Visible(true) and character_clicked then
				tour_test_ror_1:add_fullscreen_highlight("hud_center_docker", "hud_center", "button_renown")
				tour_test_ror_2:add_fullscreen_highlight("units_panel", "main_units_panel", "recruitment_docker", "recruitment_options");
				tour_test_ror_1:start("tour_test_ror_1_action_1")
			else
				cm:steal_user_input(false)
				prologue_intervention_ror:cancel()
				cm:contextual_vo_enabled(true);
			end
		end,
	1)
end

---------------------------------------------------------------------------
----------------------- Quest Battle ---------------------
-----------------------------------------------------------------------------

prologue_intervention_quest_battle = intervention:new(
	"prologue_quest_battle", 									-- string name
	0, 															-- cost
	function() prologue_quest_battle_intervention() end,		-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 								-- show debug output
);

prologue_intervention_quest_battle:add_trigger_condition(
	"ScriptEventPrologueQuestBattle",
	true
);
prologue_intervention_quest_battle:set_should_prevent_saving_game()

prologue_intervention_quest_battle:set_wait_for_battle_complete(false);
prologue_intervention_quest_battle:set_wait_for_fullscreen_panel_dismissed(false);

function prologue_quest_battle_intervention()

	completely_lock_input(true)

	local uic_button_autoresolve
	local tour_test_quest_battle = scripted_tour:new(
		"tour_test_quest_battle",
		function()
			prologue_check_progression["quest_battle_explained"] = true

			if prologue_check_progression["scripted_tour_reinforcements"] == false then
				core:trigger_event("ScriptEventReinforcements");
			else
				completely_lock_input(false)
				cm:contextual_vo_enabled(true);
			end

			prologue_intervention_quest_battle:complete()
		end
	)
	tour_test_quest_battle:set_show_skip_button(false);
				
	tour_test_quest_battle:action(
		function()
			out("STARTING_QUEST_BATTLE_TOUR_ACTION_1")

			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"bottom",
				100,
				uic_button_autoresolve,
				0.5,
				0
			)	
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_text_pointer_quest_battles")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:set_close_button_callback(function() tour_test_quest_battle:complete() end)
			tp:show()	
		end, 0,
	"tour_test_quest_battle_action_1"
	)

	cm:callback(
		function()
			
			local startedTour = false

			uic_button_autoresolve = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "mid", "battle_deployment", "regular_deployment", "button_set_attack", "button_autoresolve")
			if uic_button_autoresolve and uic_button_autoresolve:Visible(true) then
				startedTour = true
			end

			if startedTour then
				tour_test_quest_battle:add_fullscreen_highlight("popup_pre_battle", "mid", "battle_deployment", "regular_deployment", "button_set_attack", "button_autoresolve")
				tour_test_quest_battle:start("tour_test_quest_battle_action_1")
			else
				completely_lock_input(false)
				prologue_intervention_quest_battle:cancel()
			end
		end, 
		1
	)
end

--------------------------------------------------------------
----------------------- STANCES ------------------------------
--------------------------------------------------------------
prologue_intervention_stances = intervention:new(
	"prologue_stances",
	0,
	function() prologue_stances_intervention() end,
	BOOL_INTERVENTIONS_DEBUG
)

prologue_intervention_stances:add_trigger_condition(
	"ScriptEventStances",
	true
);

prologue_intervention_stances:set_should_prevent_saving_game()
prologue_intervention_stances:set_wait_for_fullscreen_panel_dismissed(false)

function prologue_stances_intervention()

	cm:steal_user_input(true);
	cm:contextual_vo_enabled(false);

	local uic_land_stance_button_stack
	local uic_movement_range_bar

	local tour_test_stances_2 = scripted_tour:new("tour_test_stances_2",
		function()

			prologue_tutorial_passed["stances_with_button_hidden"] = true

			uim:override("terrain_tooltips"):set_allowed(true);
			
			core:remove_listener("CharacterSelectedStartStancesTour")
			cm:steal_user_input(false)
			prologue_mission_raid_region:trigger()
			prologue_intervention_stances:complete()
			cm:contextual_vo_enabled(true);
			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(106, "finished_stances_tutorial", true);
		end
	)

	local tour_test_stances = scripted_tour:new("tour_test_stances",
		function() tour_test_stances_2:start("tour_test_stances_2") end
	)

	tour_test_stances:set_show_skip_button(false)
	tour_test_stances_2:set_show_skip_button(false)
	
	tour_test_stances:action(
		function()
			out("STARTING_SCRIPTED_TOUR_STANCES_1")
			tour_test_stances:show_fullscreen_highlight(true)
			
			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"bottom",
				100,
				uic_land_stance_button_stack,
				0.5,
				0
			)	
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_stances")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:set_close_button_callback(function() tour_test_stances:complete() end)
			tp:show()		
		end, 0,
		"tour_test_stances_1"
	)

	tour_test_stances_2:action(
		function()
		out("STARTING_SCRIPTED_TOUR_STANCES_2")
		tour_test_stances_2:show_fullscreen_highlight(true)
		
		local tp = text_pointer:new_from_component(
			"text_pointer_test_recruit_reminder",
			"left",
			100,
			uic_movement_range_bar,
			0.4,
			0.5
		)	
		tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_stances_2")
		tp:set_style("semitransparent")
		tp:set_topmost(true)
		tp:set_highlight_close_button(0.5)
		tp:set_close_button_callback(function() tour_test_stances_2:complete() end)
		tp:show()		
		end, 0,
		"tour_test_stances_2"
	)

	cm:callback(
		function ()
			local tour_started
			uic_land_stance_button_stack = find_uicomponent(core:get_ui_root(), "button_MILITARY_FORCE_ACTIVE_STANCE_TYPE_DEFAULT")
			uic_movement_range_bar = find_uicomponent(core:get_ui_root(), "hud_campaign", "info_panel_holder", "primary_info_panel_holder", "info_panel_background", "CharacterInfoPopup", "character_info_parent", "action_points_parent", "ap_bar")

			if uic_land_stance_button_stack and uic_land_stance_button_stack:Visible(true) and uic_movement_range_bar and uic_movement_range_bar:Visible(true) then
				tour_started = true
			end

			if tour_started then
				tour_test_stances:add_fullscreen_highlight("button_MILITARY_FORCE_ACTIVE_STANCE_TYPE_DEFAULT")
				tour_test_stances_2:add_fullscreen_highlight("hud_campaign", "info_panel_holder", "primary_info_panel_holder", "info_panel_background", "CharacterInfoPopup", "character_info_parent", "action_points_parent", "ap_bar")
				tour_test_stances:start("tour_test_stances_1")
			else
				cm:steal_user_input(false)
				prologue_intervention_stances:cancel()
			end
		end,
	0.5)
end

--------------------------------------------------------------
----------------------- AGENTS ------------------------------
--------------------------------------------------------------
prologue_intervention_agents = intervention:new(
	"prologue_agents",
	0,
	function() prologue_agents_intervention() end,
	BOOL_INTERVENTIONS_DEBUG
)

prologue_intervention_agents:add_trigger_condition(
	"ScriptEventAgents",
	true
);

prologue_intervention_agents:set_should_prevent_saving_game()
prologue_intervention_agents:set_wait_for_fullscreen_panel_dismissed(false)

function prologue_agents_intervention()

	completely_lock_input(true)

	local uic_agent_details
	local uic_targeted_effects
	local uic_embedded_effects

	tour_test_agents_1 = scripted_tour:new("tour_agents_1",
		function() 
			cm:callback(function() tour_test_agents_3:start("tour_test_agents_3") end, 0.5)
		end
	)

	tour_test_agents_3 = scripted_tour:new("tour_agents_3",
		function() 
			cm:callback(function() tour_test_agents_4:start("tour_test_agents_4") end, 0.5)
		end
	)

	tour_test_agents_4 = scripted_tour:new("tour_agents_4",
		function() 
			prologue_check_progression["agent_tutorial_complete"] = true
			core:remove_listener("CharacterSelectedIceMaiden")
			uim:override("character_details"):set_allowed(true);
			prologue_intervention_agents:complete()
			cm:disable_saving_game(true)
			PrologueJournalDilemma()

			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(73, "finished_hero_tutorial", true);
		end
	)

	tour_test_agents_1:action(
		function()
			out("STARTING_SCRIPTED_TOUR_AGENTS_1")
			tour_test_agents_1:show_fullscreen_highlight(true)

			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"left",
				100,
				uic_agent_details,
				1,
				0.5
			)	
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_agents_1")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:set_close_button_callback(function() tour_test_agents_1:complete() end)
			tp:show()		
		end, 0,
	"tour_test_agents_1"
	)

	tour_test_agents_3:action(
		function()
			out("STARTING_SCRIPTED_TOUR_AGENTS_3")
			tour_test_agents_3:show_fullscreen_highlight(true)

			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"left",
				100,
				uic_targeted_effects,
				1,
				0.5
			)	
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_agents_3")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:set_close_button_callback(function() tour_test_agents_3:complete() end)
			tp:show()		
		end, 0,
	"tour_test_agents_3"
	)

	tour_test_agents_4:action(
		function()
			out("STARTING_SCRIPTED_TOUR_AGENTS_4")
			tour_test_agents_4:show_fullscreen_highlight(true)

			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"bottom",
				100,
				uic_embedded_effects,
				0.5,
				0
			)	
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_agents_4")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:set_close_button_callback(function() tour_test_agents_4:complete() end)
			tp:show()		
		end, 0,
	"tour_test_agents_4"
	)

	cm:callback(
		function ()		
			local tour_started
			local uic_button_info_toggle = find_uicomponent(core:get_ui_root(), "hud_campaign", "unit_info_panel_holder_parent", "unit_info_panel_holder", "button_holder", "info_toggle_holder", "button_info_toggle")
			local function cancel_agents_intervention ()
				completely_lock_input(false)
				prologue_intervention_agents:cancel()
				cm:contextual_vo_enabled(true);
			end
			local function prepare_agents_intervention ()	
				uic_agent_details = find_uicomponent(core:get_ui_root(), "hud_campaign", "unit_info_panel_holder", "agent_details")
				uic_targeted_effects = find_uicomponent(core:get_ui_root(), "hud_campaign", "unit_info_panel_holder", "agent_details", "action_list", "wh2_main_agent_action_wizard_hinder_settlement_damage_walls")
				uic_embedded_effects = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel", "units", "AgentUnit 0")
				
				if uic_agent_details and uic_agent_details:Visible(true) and uic_agent_details and uic_agent_details:Visible(true) and 
				uic_targeted_effects and uic_targeted_effects:Visible(true) and uic_embedded_effects and uic_embedded_effects:Visible(true) then
					tour_started = true
				else
					out("COULD NOT FIND UI COMPONENT - PROLOGUE_AGENTS_INTERVENTION")
				end
				
				if tour_started then
					tour_test_agents_1:add_fullscreen_highlight("hud_campaign", "unit_info_panel_holder", "agent_details")
					tour_test_agents_3:add_fullscreen_highlight("hud_campaign", "unit_info_panel_holder", "agent_details", "action_list", "wh2_main_agent_action_wizard_hinder_settlement_damage_walls")
					tour_test_agents_4:add_fullscreen_highlight("units_panel", "main_units_panel", "units", "AgentUnit 0")
					tour_test_agents_1:set_show_skip_button(false)
					tour_test_agents_3:set_show_skip_button(false)
					tour_test_agents_4:set_show_skip_button(false)
					tour_test_agents_1:start("tour_test_agents_1")
				else
					cancel_agents_intervention()
				end
			end
		
			if uic_button_info_toggle and uic_button_info_toggle:Visible(true) then
				if uic_button_info_toggle:CurrentState() ~= "active" then
					cm:steal_user_input(false)
					uic_button_info_toggle:SimulateLClick()
					cm:steal_user_input(true)
					cm:callback(function () prepare_agents_intervention() end, 0.5)
				else
					prepare_agents_intervention()
				end
			else
				out("Could not find 'button_info_toggle'")
				cancel_agents_intervention()
			end
		end,
	1)
end
--
--------------------------------------------------------------
----------------------- Legendary Lord Death -----------------
--------------------------------------------------------------
prologue_intervention_legendary_lord_death = intervention:new(
	"prologue_legendary_lord_death",
	0,
	function() prologue_legendary_lord_death_intervention() end,
	BOOL_INTERVENTIONS_DEBUG
)

prologue_intervention_legendary_lord_death:add_trigger_condition(
	"ScriptEventLegendaryLordDeath",
	true
);
prologue_intervention_legendary_lord_death:set_should_prevent_saving_game()
prologue_intervention_legendary_lord_death:set_must_trigger()

function prologue_legendary_lord_death_intervention()

	cm:contextual_vo_enabled(false);

	cancel_death_intervention(prologue_intervention_legendary_lord_death)

	steal_input_completely_on_event(true, "PanelOpenedCampaign", function(context) return context.string == "settlement_panel" end , 0.01, "PanelOpenedCampaignStealEscLegendaryLordDeath", "PanelOpenedCampaignStealUserInputLegendaryLordDeath", prologue_intervention_legendary_lord_death)

	allow_hotkeys(false)

	local uic_lord_recruit_button
	local uic_list_box
	-- This must be set to true so the small bar on the settlement panel will appear. If the
	-- intervention is cancelled, it is set to false again.
	prologue_check_progression["legendary_lord_death"] = true

	-- Activates lord recruitment button.
	uim:override("settlement_panel_lord_recruit_with_button_hidden"):set_allowed(true);
	common.call_context_command("CcoCampaignSettlement", 1, "SelectAndZoom(false)");
	cm:steal_user_input(true);

	tour_test_legendary_lord_death_1 = scripted_tour:new("tour_legendary_lord_death_1",
		function() 
			cm:callback(
				function ()
					uic_list_box = find_uicomponent(core:get_ui_root(), "character_panel", "general_selection_panel", "character_list_parent", "character_list", "listview", "list_clip", "list_box")

					if uic_list_box and uic_list_box:Visible(true) then
						tour_test_legendary_lord_death_2:add_fullscreen_highlight("character_panel", "general_selection_panel", "character_list_parent", "character_list", "listview", "list_clip", "list_box")
						tour_test_legendary_lord_death_2:set_show_skip_button(false)
						tour_test_legendary_lord_death_2:start("tour_test_legendary_lord_death_2_action_1")
					else
						allow_hotkeys(true)
						end_death_intervention(prologue_intervention_legendary_lord_death)
						AddYuriDeathObjective()
					end
				end,
			1)
		end
	)

	tour_test_legendary_lord_death_2 = scripted_tour:new("tour_legendary_lord_death_1",
		function() 
			allow_hotkeys(true)
			end_death_intervention(prologue_intervention_legendary_lord_death)
			AddYuriDeathObjective()
		end
	)

	tour_test_legendary_lord_death_1:action(
		function()
			out("STARTING_SCRIPTED_TOUR_LEGENDARY_LORD_DEATH_1_ACTION_1")
			
			tour_test_legendary_lord_death_1:show_fullscreen_highlight(true)
			add_callback_button_press_intervention("button_create_army", true, function() tour_test_legendary_lord_death_1:complete() end)

			local tp = text_pointer:new_from_component(
				"text_pointer_test_legendary_lord_death",
				"bottom",
				100,
				uic_lord_recruit_button,
				0.5,
				0
			)	
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_legendary_lord_death_1")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:show()		
		end, 0,
	"tour_test_legendary_lord_death_1_action_1"
	)

	tour_test_legendary_lord_death_2:action(
		function()
			out("STARTING_SCRIPTED_TOUR_LEGENDARY_LORD_DEATH_2_ACTION_1")
			tour_test_legendary_lord_death_2:show_fullscreen_highlight(true)

			local tp = text_pointer:new_from_component(
				"text_pointer_test_legendary_lord_death",
				"bottom",
				100,
				uic_list_box,
				0.5,
				0
			)	
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_legendary_lord_death_2")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:set_close_button_callback(function() tour_test_legendary_lord_death_2:complete() end)
			tp:show()		
		end, 0,
	"tour_test_legendary_lord_death_2_action_1"
	)

	cm:callback(
		function ()		
			local tour_started
			uic_lord_recruit_button = find_uicomponent(core:get_ui_root(), "hud_campaign", "hud_center_docker", "hud_center", "small_bar", "button_subpanel_parent", "button_subpanel", "button_group_settlement", "button_create_army")
			
			if uic_lord_recruit_button and uic_lord_recruit_button:Visible(true) then
				tour_started = true
			end
			
			if tour_started then
				tour_test_legendary_lord_death_1:add_fullscreen_highlight("hud_campaign", "hud_center_docker", "hud_center", "small_bar", "button_subpanel_parent", "button_subpanel", "button_group_settlement", "button_create_army")
				tour_test_legendary_lord_death_1:set_fullscreen_highlight_padding(2)
				tour_test_legendary_lord_death_1:set_show_skip_button(false)
				tour_test_legendary_lord_death_1:start("tour_test_legendary_lord_death_1_action_1")
				prologue_tutorial_passed["settlement_panel_lord_recruit_with_button_hidden"] = true
			else
				cm:steal_user_input(false)
				allow_hotkeys(true)
				prologue_check_progression["legendary_lord_death"] = false

				if not prologue_tutorial_passed["settlement_panel_lord_recruit_with_button_hidden"] then
					uim:override("settlement_panel_lord_recruit_with_button_hidden"):set_allowed(false);
				end
				prologue_intervention_legendary_lord_death:cancel()
			end
		end,
	0.5)
end

--------------------------------------------------------------
----------------------- Lord Death ---------------------------
--------------------------------------------------------------
prologue_intervention_lord_death = intervention:new(
	"prologue_lord_death",
	0,
	function() prologue_lord_death_intervention() end,
	BOOL_INTERVENTIONS_DEBUG
)

prologue_intervention_lord_death:add_trigger_condition(
	"ScriptEventLordDeath",
	true
);
prologue_intervention_lord_death:set_should_prevent_saving_game()

function prologue_lord_death_intervention()

	cm:contextual_vo_enabled(false);

	cancel_death_intervention(prologue_intervention_lord_death)

	local uic_lord_recruit_button

	-- This must be set to true so the small bar on the settlement panel will appear. If the
	-- intervention is cancelled, it is set to false again.
	prologue_check_progression["lord_death"] = true

	-- Activates lord recruitment button.
	uim:override("settlement_panel_lord_recruit_with_button_hidden"):set_allowed(true);
	common.call_context_command("CcoCampaignSettlement", 1, "SelectAndZoom(false)");
	cm:steal_user_input(true);
	allow_hotkeys(false)

	tour_test_lord_death = scripted_tour:new("tour_lord_death",
		function() 
			cm:steal_user_input(false);
			allow_hotkeys(true)
			core:remove_listener("CharacterConvalescedOrKilledLord")
			prologue_check_progression["lord_death"] = true
			prologue_intervention_lord_death:complete()
			cm:contextual_vo_enabled(true);
		end
	)

	tour_test_lord_death:action(
		function()
			out("STARTING_SCRIPTED_TOUR_LORD_DEATH_ACTION_1")
			tour_test_lord_death:show_fullscreen_highlight(true)

			add_callback_button_press_intervention("button_create_army", false, function() tour_test_lord_death:complete() end)

			local tp = text_pointer:new_from_component(
				"text_pointer_test_lord_death",
				"bottom",
				100,
				uic_lord_recruit_button,
				0.5,
				0
			)	
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_lord_death")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:show()		
		end, 0,
	"tour_test_lord_death"
	)

	cm:callback(
		function ()		
			local tour_started
			uic_lord_recruit_button = find_uicomponent(core:get_ui_root(), "hud_campaign", "hud_center_docker", "hud_center", "small_bar", "button_subpanel_parent", "button_subpanel", "button_group_settlement", "button_create_army")
			
			if uic_lord_recruit_button and uic_lord_recruit_button:Visible(true) then
				tour_started = true
			end
			
			if tour_started then
				tour_test_lord_death:add_fullscreen_highlight("hud_campaign", "hud_center_docker", "hud_center", "small_bar", "button_subpanel_parent", "button_subpanel", "button_group_settlement", "button_create_army")
				tour_test_lord_death:set_show_skip_button(false)
				tour_test_lord_death:set_fullscreen_highlight_padding(2)
				tour_test_lord_death:start("tour_test_lord_death")
				prologue_tutorial_passed["settlement_panel_lord_recruit_with_button_hidden"] = true
			else
				cm:steal_user_input(false)
				allow_hotkeys(true)
				prologue_check_progression["lord_death"] = false

				if not prologue_tutorial_passed["settlement_panel_lord_recruit_with_button_hidden"] then
					uim:override("settlement_panel_lord_recruit_with_button_hidden"):set_allowed(false);
				end
				prologue_intervention_lord_death:cancel()
			end
		end,
	0.5)
end

--------------------------------------------------------------
----------------------- MOVEMENT RANGE ---------------------
--------------------------------------------------------------
prologue_intervention_movement_range = intervention:new(
	"prologue_movement_range",
	0,
	function() prologue_movement_range_intervention() end,
	BOOL_INTERVENTIONS_DEBUG
)

prologue_intervention_movement_range:add_trigger_condition(
	"ScriptEventMovementRange",
	true
);
prologue_intervention_movement_range:set_should_prevent_saving_game()
prologue_intervention_movement_range:set_wait_for_fullscreen_panel_dismissed(false)

function prologue_movement_range_intervention()
		
	local uic_movement_range_bar

	cm:contextual_vo_enabled(false);

	tour_test_movement_range = scripted_tour:new("tour_movement_range",
		function() 
			cm:steal_user_input(false);
			PrologueEndOfTurnOne(false)

			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(7, "finished_ap_tutorial", true);
	
			prologue_check_progression["ap_bar"] = true
			prologue_intervention_movement_range:complete()
			cm:contextual_vo_enabled(true);
		end
	)

	-- This displays, "Your opponent is close to another army on the campaign map. When a battle is started, nearby armies on both sides join."
	-- Or, "You have another army close by on the campaign map. When the battle starts, nearby armies on both sides will join."
	tour_test_movement_range:action(
		function()
			out("STARTING_SCRIPTED_TOUR_MOVEMENT_RANGE_ACTION_1")
			tour_test_movement_range:show_fullscreen_highlight(true)

			local text_pointer_test_movement_range = text_pointer:new_from_component(
				"text_pointer_test_recruit_reminder",
				"left",
				100,
				uic_movement_range_bar,
				0.4,
				0.5
			)

			if cm:get_local_faction():faction_leader():action_points_remaining_percent() < 5 then
				text_pointer_test_movement_range:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_movement_range_empty")
			else
				text_pointer_test_movement_range:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_movement_range")
			end
			text_pointer_test_movement_range:set_style("semitransparent")
			text_pointer_test_movement_range:set_topmost(true)
			text_pointer_test_movement_range:set_highlight_close_button(0.5)
			text_pointer_test_movement_range:set_close_button_callback(function() tour_test_movement_range:complete() end)
			text_pointer_test_movement_range:show()		
		end, 0,
	"tour_test_movement_range"
	)

	cm:steal_user_input(true)
	common.call_context_command("CcoCampaignCharacter", prologue_player_cqi, "Select(false)")

	cm:callback(
		function ()		
			local tour_started
			uic_movement_range_bar = find_uicomponent(core:get_ui_root(), "hud_campaign", "info_panel_holder", "primary_info_panel_holder", "info_panel_background", "CharacterInfoPopup", "character_info_parent", "action_points_parent", "ap_bar")
			
			if uic_movement_range_bar and uic_movement_range_bar:Visible(true) and cm:model():is_player_turn() then
				tour_started = true
				tour_test_movement_range:add_fullscreen_highlight("hud_campaign", "info_panel_holder", "primary_info_panel_holder", "info_panel_background", "CharacterInfoPopup", "character_info_parent", "action_points_parent", "ap_bar")				
			end
			
			if tour_started then
				tour_test_movement_range:set_show_skip_button(false)
				tour_test_movement_range:start("tour_test_movement_range")
			else
				cm:steal_user_input(false)
				prologue_intervention_movement_range:cancel()
				PrologueEndOfTurnOne(false)
			end
		end,
	0.25)
end

--------------------------------------------------------------
----------------------- REINFORCEMENTS ---------------------
--------------------------------------------------------------
prologue_intervention_reinforcements = intervention:new(
	"prologue_reinforcements",
	0,
	function() prologue_reinforcements_intervention() end,
	BOOL_INTERVENTIONS_DEBUG
)

prologue_intervention_reinforcements:add_trigger_condition(
	"ScriptEventReinforcements",
	true
);
prologue_intervention_reinforcements:set_should_prevent_saving_game()
prologue_intervention_reinforcements:set_wait_for_battle_complete(false);
prologue_intervention_reinforcements:set_wait_for_fullscreen_panel_dismissed(false);
prologue_intervention_reinforcements:set_player_turn_only(false);

function prologue_reinforcements_intervention()

	cm:contextual_vo_enabled(false);
	
	local uic_combatants_panel
	local uic_commander_header_0
	local uic_commander_header_1
	local tour_started = false
	local friendly_reinforcements

	tour_test_reinforcements_1 = scripted_tour:new("tour_reinforcements_1",
		function() 
			cm:callback(
				function()
					if friendly_reinforcements then 
						tour_test_reinforcements_2:add_fullscreen_highlight("popup_pre_battle", "allies_combatants_panel", "army", "units_and_banners_parent", "units_window", "listview", "list_clip", "list_box", "commander_header_0")
					else
						tour_test_reinforcements_2:add_fullscreen_highlight("popup_pre_battle", "enemy_combatants_panel", "army", "units_and_banners_parent", "units_window", "listview", "list_clip", "list_box", "commander_header_0")
					end
					tour_test_reinforcements_2:start("tour_test_reinforcements_2_action_1")
				end, 
				0.5
			)
		end
	)

	tour_test_reinforcements_2 = scripted_tour:new("tour_reinforcements_2",
		function() 
			cm:callback(
				function()
					if friendly_reinforcements then 
						tour_test_reinforcements_3:add_fullscreen_highlight("popup_pre_battle", "allies_combatants_panel", "army", "units_and_banners_parent", "units_window", "listview", "list_clip", "list_box", "commander_header_1")
					else
						tour_test_reinforcements_3:add_fullscreen_highlight("popup_pre_battle", "enemy_combatants_panel", "army", "units_and_banners_parent", "units_window", "listview", "list_clip", "list_box", "commander_header_1")
					end
					tour_test_reinforcements_3:start("tour_test_reinforcements_3_action_1")
				end, 
				0.5
			)
		end
	)
	
	tour_test_reinforcements_3 = scripted_tour:new("tour_reinforcements_3",
		function() 
			cm:callback(
				function() 
					prologue_check_progression["scripted_tour_reinforcements"] = true
					cm:steal_user_input(false);
					core:remove_listener("PanelOpenedCampaign_popup_pre_battle_reinforcements")
					prologue_intervention_reinforcements:complete()
					cm:contextual_vo_enabled(true);
				end, 
				0.5
			)
		end
	)

	-- This displays, "Your opponent is close to another army on the campaign map. When a battle is started, nearby armies on both sides join."
	-- Or, "You have another army close by on the campaign map. When the battle starts, nearby armies on both sides will join."
	tour_test_reinforcements_1:action(
		function()
			out("STARTING_REINFORCEMENTS_1_ACTION_1")
			tour_test_reinforcements_1:show_fullscreen_highlight(true)

			cm:steal_user_input(false);
			
			local text_pointer_test_reinforcements

			if friendly_reinforcements then
				text_pointer_test_reinforcements = text_pointer:new_from_component(
					"text_pointer_test_recruit_reminder",
					"bottom",
					100,
					uic_combatants_panel,
					0.5,
					0
				)	
				text_pointer_test_reinforcements:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_reinforcements_2")
			else
				text_pointer_test_reinforcements = text_pointer:new_from_component(
					"text_pointer_test_recruit_reminder",
					"bottom",
					100,
					uic_combatants_panel,
					0.5,
					0
				)
				if common.get_context_value("CampaignBattleContext.IsQuestBattle") then
					text_pointer_test_reinforcements:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_reinforcements_1_quest")
				else
					text_pointer_test_reinforcements:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_reinforcements_1")
				end
			end

			text_pointer_test_reinforcements:set_style("semitransparent")
			text_pointer_test_reinforcements:set_topmost(true)
			text_pointer_test_reinforcements:set_highlight_close_button(0.5)
			text_pointer_test_reinforcements:set_close_button_callback(function() tour_test_reinforcements_1:complete() end)
			text_pointer_test_reinforcements:show()		
		end, 0,
	"tour_test_reinforcements_1_action_1"
	)

	-- This displays, "At the start of the battle, only your opponent's main army will be deployed."
	-- Or, "At the start of the battle, only your main army will be deployed."
	tour_test_reinforcements_2:action(
		function()
			out("STARTING_REINFORCEMENTS_2_ACTION_1")
			tour_test_reinforcements_2:show_fullscreen_highlight(true)
			
			local text_pointer_test_reinforcements

			if friendly_reinforcements then
				text_pointer_test_reinforcements = text_pointer:new_from_component(
					"text_pointer_test_recruit_reminder",
					"left",
					100,
					uic_commander_header_0,
					1,
					0.5
				)
				text_pointer_test_reinforcements:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_reinforcements_4")
			else
				text_pointer_test_reinforcements = text_pointer:new_from_component(
					"text_pointer_test_recruit_reminder",
					"right",
					100,
					uic_commander_header_0,
					0,
					0.5
				)
				text_pointer_test_reinforcements:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_reinforcements_3")
			end

			text_pointer_test_reinforcements:set_style("semitransparent")
			text_pointer_test_reinforcements:set_topmost(true)
			text_pointer_test_reinforcements:set_highlight_close_button(0.5)
			text_pointer_test_reinforcements:set_close_button_callback(function() tour_test_reinforcements_2:complete() end)
			text_pointer_test_reinforcements:show()
		end, 0,
	"tour_test_reinforcements_2_action_1"
	)

	-- This displays, "Other armies join the battle after a set time, appearing at the edge of the battlefield. The location of the reinforcements is shown on the mini-map."
	tour_test_reinforcements_3:action(
		function()
			out("STARTING_REINFORCEMENTS_3_ACTION_1")
			tour_test_reinforcements_3:show_fullscreen_highlight(true)
			
			local text_pointer_test_reinforcements

			if friendly_reinforcements then
				text_pointer_test_reinforcements = text_pointer:new_from_component(
					"text_pointer_test_recruit_reminder",
					"left",
					100,
					uic_commander_header_1,
					1,
					0.5
				)	
			else
				text_pointer_test_reinforcements = text_pointer:new_from_component(
					"text_pointer_test_recruit_reminder",
					"right",
					100,
					uic_commander_header_1,
					0,
					0.5
				)
			end

			text_pointer_test_reinforcements:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_reinforcements_5")
			text_pointer_test_reinforcements:set_style("semitransparent")
			text_pointer_test_reinforcements:set_topmost(true)
			text_pointer_test_reinforcements:set_highlight_close_button(0.5)
			text_pointer_test_reinforcements:set_close_button_callback(function() tour_test_reinforcements_3:complete() end)
			text_pointer_test_reinforcements:show()
		end, 0,
	"tour_test_reinforcements_3_action_1"
	)
	
	cm:callback(
		function ()		
			-- Try enemy panel first.
			uic_combatants_panel = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "enemy_combatants_panel")
			if uic_combatants_panel then
				uic_commander_header_0 = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "enemy_combatants_panel", "army", "units_and_banners_parent", "units_window", "listview", "list_clip", "list_box", "commander_header_0")
				uic_commander_header_1 = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "enemy_combatants_panel", "army", "units_and_banners_parent", "units_window", "listview", "list_clip", "list_box", "commander_header_1")
				if uic_commander_header_0 and uic_commander_header_1 and uic_commander_header_1:Visible(true) then
					tour_started = true
					friendly_reinforcements = false
					tour_test_reinforcements_1:add_fullscreen_highlight("popup_pre_battle", "enemy_combatants_panel")
				end					
			end
			
			-- Try friendly panel second.
			if tour_started == false then
				uic_combatants_panel = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "allies_combatants_panel")	
				if uic_combatants_panel then
					uic_commander_header_0 = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "allies_combatants_panel", "army", "units_and_banners_parent", "units_window", "listview", "list_clip", "list_box", "commander_header_0")
					uic_commander_header_1 = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "allies_combatants_panel", "army", "units_and_banners_parent", "units_window", "listview", "list_clip", "list_box", "commander_header_1")
					if uic_commander_header_0 and uic_commander_header_1 and uic_commander_header_1:Visible(true) then
						tour_started = true
						friendly_reinforcements = true
						tour_test_reinforcements_1:add_fullscreen_highlight("popup_pre_battle", "allies_combatants_panel")	
					end					
				end
			end

			if tour_started then
				cm:steal_user_input(true)
				tour_test_reinforcements_1:set_show_skip_button(false)
				tour_test_reinforcements_2:set_show_skip_button(false)
				tour_test_reinforcements_3:set_show_skip_button(false)
				tour_test_reinforcements_1:start("tour_test_reinforcements_1_action_1")
			else
				cm:steal_user_input(false)
				prologue_intervention_reinforcements:cancel()
				cm:contextual_vo_enabled(true);
			end
		end,
	1)
end

--------------------------------------------------------------
----------------------- RECRUIT REMINDER ---------------------
--------------------------------------------------------------
prologue_intervention_recruit_reminder = intervention:new(
	"prologue_recruit_reminder",
	0,
	function() prologue_recruit_reminder_intervention() end,
	BOOL_INTERVENTIONS_DEBUG
)

prologue_intervention_recruit_reminder:add_trigger_condition(
	"ScriptEventRecruitReminder",
	true
);

prologue_intervention_recruit_reminder:set_should_prevent_saving_game()
prologue_intervention_recruit_reminder:set_should_lock_ui(true)

function prologue_recruit_reminder_intervention()

	common.call_context_command("CcoCampaignCharacter", prologue_player_cqi, "Select(false)");
	cm:steal_user_input(true)
	
	tour_test_recruit_reminder = scripted_tour:new("tour_recruit_reminder",
		function() 
			cm:steal_user_input(false);
			prologue_check_progression["recruit_reminder"] = true
			prologue_intervention_recruit_reminder:complete()
			cm:contextual_vo_enabled(true);
		end
	)

	-- This displays, "Your army has space for more units."
	tour_test_recruit_reminder:action(
		function()
			out("STARTING_RECRUIT_REMINDER_ACTION_1")
			tour_test_recruit_reminder:show_fullscreen_highlight(true)
			local uic_text_pointer = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel", "unit_count_frames_holder", "frame", "dy_unit_count")

			local text_pointer_test_recruit_reminder = text_pointer:new_from_component(
				"text_pointer_test_recruit_reminder",
				"bottom",
				100,
				uic_text_pointer,
				0.5,
				0
			)
			text_pointer_test_recruit_reminder:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_recruitment_reminder_1")
			text_pointer_test_recruit_reminder:set_style("semitransparent")
			text_pointer_test_recruit_reminder:set_topmost(true)
			text_pointer_test_recruit_reminder:set_highlight_close_button(0.5)
			text_pointer_test_recruit_reminder:set_close_button_callback(function() cm:callback( function() tour_test_recruit_reminder:start("tour_test_recruit_reminder_action_2") end, 0.5) end)
			text_pointer_test_recruit_reminder:show()		
		end, 0,
	"tour_test_recruit_reminder_action_1"
	)

	-- This displays, "Consider recruiting before you travel further."
	tour_test_recruit_reminder:action(
		function()
			out("STARTING_RECRUIT_REMINDER_TOUR_1_ACTION_2")

			local uic_text_pointer = find_uicomponent(core:get_ui_root(), "hud_campaign", "hud_center_docker", "hud_center", "small_bar", "button_subpanel_parent", "button_subpanel", "button_group_army", "button_recruitment")

			local text_pointer_test_recruit_reminder = text_pointer:new_from_component(
				"text_pointer_test_recruit_reminder",
				"right",
				100,
				uic_text_pointer,
				0,
				0.5
			)
			text_pointer_test_recruit_reminder:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_recruitment_reminder_2")
			text_pointer_test_recruit_reminder:set_style("semitransparent")
			text_pointer_test_recruit_reminder:set_topmost(true)
			text_pointer_test_recruit_reminder:set_label_offset(0, -30)
			text_pointer_test_recruit_reminder:set_highlight_close_button(0.5)
			text_pointer_test_recruit_reminder:set_close_button_callback(function() cm:callback( function () tour_test_recruit_reminder:start("tour_test_recruit_reminder_action_3") end, 0.5) end)
			text_pointer_test_recruit_reminder:show()
		end, 0,
	"tour_test_recruit_reminder_action_2"
	)

	-- This displays, "Be mindful of your army's upkeep. The bigger the army, the more it costs to maintain each turn."
	tour_test_recruit_reminder:action(
		function()
			out("STARTING_RECRUIT_REMINDER_ACTION_3")
			
			local uic_text_pointer = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel", "icon_list", "dy_upkeep")

			local text_pointer_test_recruit_reminder = text_pointer:new_from_component(
				"text_pointer_test_recruit_reminder",
				"bottom",
				100,
				uic_text_pointer,
				0.5,
				0
			)
			text_pointer_test_recruit_reminder:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_recruitment_reminder_3")
			text_pointer_test_recruit_reminder:set_style("semitransparent")
			text_pointer_test_recruit_reminder:set_topmost(true)
			text_pointer_test_recruit_reminder:set_highlight_close_button(0.5)
			text_pointer_test_recruit_reminder:set_close_button_callback(function() tour_test_recruit_reminder:complete() end)
			text_pointer_test_recruit_reminder:show()
		end, 0,
	"tour_test_recruit_reminder_action_3"
	)

	cm:callback(
		function ()
			local uic_main_units_panel = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel")

			if uic_main_units_panel:Visible(true) then
				tour_test_recruit_reminder:set_show_skip_button(false)
				tour_test_recruit_reminder:add_fullscreen_highlight("units_panel", "main_units_panel")
				tour_test_recruit_reminder:start("tour_test_recruit_reminder_action_1")
			else
				cm:steal_user_input(false)
				prologue_intervention_recruit_reminder:cancel()
				cm:contextual_vo_enabled(true);
			end
		end,
	1)
end

--------------------------------------------------------------
----------------------- Upkeep ------------------------------
--------------------------------------------------------------
prologue_intervention_upkeep = intervention:new(
	"prologue_upkeep",
	0,
	function() prologue_upkeep_intervention() end,
	BOOL_INTERVENTIONS_DEBUG
)

prologue_intervention_upkeep:add_trigger_condition(
	"ScriptEventUpkeep",
	true
);

prologue_intervention_upkeep:set_should_prevent_saving_game()
prologue_intervention_upkeep:set_should_lock_ui(true)

function prologue_upkeep_intervention()
	
	common.call_context_command("CcoCampaignCharacter", prologue_player_cqi, "Select(false)");
	cm:steal_user_input(true)
	cm:contextual_vo_enabled(false);

	tour_test_upkeep_1 = scripted_tour:new("tour_upkeep_1",
		function() 
			cm:callback( function () tour_test_upkeep_2:start("tour_test_upkeep_2_action_1") end, 0.5)
		end
	)
	
	tour_test_upkeep_2 = scripted_tour:new("tour_upkeep_2",
		function() 
			cm:steal_user_input(false);
			prologue_check_progression["upkeep_intervention"] = true
			core:remove_listener("FactionTurnStart_PreDervingard")
			prologue_intervention_upkeep:complete()
			cm:contextual_vo_enabled(true);
		end
	)

	-- This displays, "The maximum number of units your army can contain is displayed here."
	tour_test_upkeep_1:action(
		function()
			out("STARTING_UPKEEP_TOUR_1_ACTION_1")
			tour_test_upkeep_1:show_fullscreen_highlight(true)
			local uic_text_pointer = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel", "unit_count_frames_holder", "frame", "dy_unit_count")

			local text_pointer_test_upkeep = text_pointer:new_from_component(
				"text_pointer_test_upgrade_settlement",
				"bottom",
				100,
				uic_text_pointer,
				0.5,
				0
			)
			text_pointer_test_upkeep:add_component_text("text", "ui_text_replacements_localised_text_prologue_text_pointer_upkeep_1")
			text_pointer_test_upkeep:set_style("semitransparent")
			text_pointer_test_upkeep:set_topmost(true)
			text_pointer_test_upkeep:set_highlight_close_button(0.5)
			text_pointer_test_upkeep:set_close_button_callback(function() cm:callback( function() tour_test_upkeep_1:start("tour_test_upkeep_1_action_2") end, 0.5) end)
			text_pointer_test_upkeep:show()		
		end, 0,
	"tour_test_upkeep_1_action_1"
	)

	-- This displays, "Recruit additional units to make your army stronger."
	tour_test_upkeep_1:action(
		function()
			out("STARTING_UPKEEP_TOUR_1_ACTION_2")

			local uic_text_pointer = find_uicomponent(core:get_ui_root(), "hud_campaign", "hud_center_docker", "hud_center", "small_bar", "button_subpanel_parent", "button_subpanel", "button_group_army", "button_recruitment")

			local text_pointer_test_upkeep = text_pointer:new_from_component(
				"text_pointer_test_upgrade_settlement",
				"right",
				100,
				uic_text_pointer,
				0,
				0.5
			)
			text_pointer_test_upkeep:add_component_text("text", "ui_text_replacements_localised_text_prologue_text_pointer_upkeep_2")
			text_pointer_test_upkeep:set_style("semitransparent")
			text_pointer_test_upkeep:set_topmost(true)
			text_pointer_test_upkeep:set_highlight_close_button(0.5)
			text_pointer_test_upkeep:set_close_button_callback(function() cm:callback( function () tour_test_upkeep_1:start("tour_test_upkeep_1_action_3") end, 0.5) end)
			text_pointer_test_upkeep:show()
		end, 0,
	"tour_test_upkeep_1_action_2"
	)

	-- This displays, "Whenever you recruit new units, your army's Upkeep will increase. This represents the amount of income you must pay each turn to support your army. The bigger the army, the more upkeep you must pay."
	tour_test_upkeep_1:action(
		function()
			out("STARTING_UPKEEP_TOUR_1_ACTION_3")
			
			local uic_text_pointer = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel", "icon_list", "dy_upkeep")

			local text_pointer_test_upkeep = text_pointer:new_from_component(
				"text_pointer_test_upgrade_settlement",
				"bottom",
				100,
				uic_text_pointer,
				0.5,
				0
			)
			text_pointer_test_upkeep:add_component_text("text", "ui_text_replacements_localised_text_prologue_text_pointer_upkeep_3")
			text_pointer_test_upkeep:set_style("semitransparent")
			text_pointer_test_upkeep:set_topmost(true)
			text_pointer_test_upkeep:set_highlight_close_button(0.5)
			text_pointer_test_upkeep:set_close_button_callback(function() tour_test_upkeep_1:complete() end)
			text_pointer_test_upkeep:show()
		end, 0,
	"tour_test_upkeep_1_action_3"
	)

	-- This displays, "This displays the amount of income you'll receive next turn. Your army's upkeep is taken from your income. Make sure you're generating enough income each turn to fund all your expenses, not just your army's upkeep. You still need some leftover for building and diplomacy."
	tour_test_upkeep_2:action(
		function()
			out("STARTING_UPKEEP_TOUR_2_ACTION_1")
			tour_test_upkeep_2:show_fullscreen_highlight(true)
			local uic_text_pointer = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar", "treasury_holder", "dy_income")

			local text_pointer_test_upkeep = text_pointer:new_from_component(
				"text_pointer_test_upgrade_settlement",
				"top",
				100,
				uic_text_pointer,
				0.5,
				1
			)
			text_pointer_test_upkeep:add_component_text("text", "ui_text_replacements_localised_text_prologue_text_pointer_upkeep_4")
			text_pointer_test_upkeep:set_style("semitransparent")
			text_pointer_test_upkeep:set_topmost(true)
			text_pointer_test_upkeep:set_highlight_close_button(0.5)
			text_pointer_test_upkeep:set_close_button_callback(function() tour_test_upkeep_2:complete() end)
			text_pointer_test_upkeep:show()
		end, 0,
	"tour_test_upkeep_2_action_1"
	)

	cm:callback(
		function ()
			local uic_main_units_panel = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel")

			if uic_main_units_panel:Visible(true) then
				tour_test_upkeep_1:set_show_skip_button(false)
				tour_test_upkeep_2:set_show_skip_button(false)
				tour_test_upkeep_1:add_fullscreen_highlight("units_panel", "main_units_panel")
				tour_test_upkeep_2:add_fullscreen_highlight("hud_campaign", "resources_bar_holder", "resources_bar")
				tour_test_upkeep_1:start("tour_test_upkeep_1_action_1")
			else
				cm:steal_user_input(false)
				prologue_intervention_upkeep:cancel()
				cm:contextual_vo_enabled(true);
			end
		end,
	1)
end
--------------------------------------------------------------
----------------------- Upgrading Settlements ----------------
--------------------------------------------------------------


prologue_intervention_upgrade_settlement = intervention:new(
	"prologue_upgrade_settlement",
	0,
	function() prologue_upgrade_settlement_intervention() end,
	BOOL_INTERVENTIONS_DEBUG
)

prologue_intervention_upgrade_settlement:add_trigger_condition(
	"ScriptEventUpgradeSettlement",
	true
);

prologue_intervention_upgrade_settlement:set_should_prevent_saving_game()
prologue_intervention_upgrade_settlement:set_should_lock_ui(true)

function prologue_upgrade_settlement_intervention()
	
	common.call_context_command("CcoCampaignSettlement", region_with_upgrade_available, "Select(false)")
	cm:steal_user_input(true)
	cm:contextual_vo_enabled(false);

	-- Store the construction slot of the settlement.
	local uic_slot_entry
	local uic_settlement_first_building_slot_saved
	
	tour_test_upgrade_settlement = scripted_tour:new("tour_upgrade_settlement",
		function() 
			cm:steal_user_input(false);
			prologue_intervention_upgrade_settlement:complete()
			cm:contextual_vo_enabled(true);
		end
	)
	tour_test_upgrade_settlement:set_show_skip_button(true)

	-- This displays, "You have enough population surplus to upgrade a settlement."
	tour_test_upgrade_settlement:action(
		function()
			out("STARTING_UPGRADE_SETTLEMENT_TOUR_ACTION_1")
			
			local text_pointer_test_upgrade_settlement = text_pointer:new_from_component(
				"text_pointer_test_upgrade_settlement",
				"right",
				100,
				uic_slot_entry,
				0,
				0.5
			)
			text_pointer_test_upgrade_settlement:add_component_text("text", "ui_text_replacements_localised_text_prologue_text_pointer_settlement_upgrade_1")
			text_pointer_test_upgrade_settlement:set_style("semitransparent")
			text_pointer_test_upgrade_settlement:set_topmost(true)
			text_pointer_test_upgrade_settlement:set_highlight_close_button(0.5)
			text_pointer_test_upgrade_settlement:set_close_button_callback(function() tour_test_upgrade_settlement:start("tour_test_upgrade_settlement_action_2") end)
			text_pointer_test_upgrade_settlement:show()
			
		end, 0,
	"tour_test_upgrade_settlement_action_1"
	)
	
	-- This displays, "Upgrading a settlement opens additional construction slots, enabling you to purchase more buildings."
	tour_test_upgrade_settlement:action(
		function()
			out("STARTING_UPGRADE_SETTLEMENT_TOUR_ACTION_2")
			uic_slot_entry:SimulateMouseOn();
			cm:callback(function()
				local uic_building_tree_holder = find_uicomponent(uic_settlement_first_building_slot_saved, "building_construction_popup", "popup_holder", "popup_panel", "building_tree_holder")
				local text_pointer_test_upgrade_settlement = text_pointer:new_from_component(
					"text_pointer_test_upgrade_settlement",
					"right",
					100,
					uic_building_tree_holder,
					0,
					0.5
				)
				text_pointer_test_upgrade_settlement:add_component_text("text", "ui_text_replacements_localised_text_prologue_text_pointer_settlement_upgrade_2")
				text_pointer_test_upgrade_settlement:set_style("semitransparent")
				text_pointer_test_upgrade_settlement:set_topmost(true)
				text_pointer_test_upgrade_settlement:set_highlight_close_button(0.5)
				text_pointer_test_upgrade_settlement:set_close_button_callback(function() tour_test_upgrade_settlement:start("tour_test_upgrade_settlement_action_3") end)
				text_pointer_test_upgrade_settlement:show()
			end, 1)
		end, 0,
	"tour_test_upgrade_settlement_action_2"
	)

	-- This displays, "The number of turns until your next population surplus point is displayed here. You'll need these to upgrade your settlement again."
	tour_test_upgrade_settlement:action(
		function()
			out("STARTING_UPGRADE_SETTLEMENT_TOUR_ACTION_3")
			uic_slot_entry:SimulateMouseOn();
			cm:callback(function()
				uic_slot_entry:SimulateMouseOff()
				local uic_surplus_fill_holder = find_uicomponent(core:get_ui_root(), "info_panel_holder", "primary_info_panel_holder", "info_panel_background", "ProvinceInfoPopup", "script_hider_parent", "panel", "frame_growth", "dy_turns")
				local text_pointer_test_upgrade_settlement = text_pointer:new_from_component(
					"text_pointer_test_upgrade_settlement",
					"bottom",
					100,
					uic_surplus_fill_holder,
					0.5,
					0
				)
				text_pointer_test_upgrade_settlement:add_component_text("text", "ui_text_replacements_localised_text_prologue_text_pointer_settlement_upgrade_3")
				text_pointer_test_upgrade_settlement:set_style("semitransparent")
				text_pointer_test_upgrade_settlement:set_topmost(true)
				text_pointer_test_upgrade_settlement:set_highlight_close_button(0.5)
				text_pointer_test_upgrade_settlement:set_close_button_callback(function() tour_test_upgrade_settlement:complete() end)
				text_pointer_test_upgrade_settlement:show()
			end, 1)
		end, 0,
	"tour_test_upgrade_settlement_action_3"
	)

	cm:callback(
		function ()
			-- This block checks to see if the settlement is visible after the province has been selected.
			local uic_settlement_list = find_uicomponent("settlement_panel", "settlement_list")
			tourStarted = false
			out(uic_settlement_list:Id())
			if uic_settlement_list then
				local uic_settlement = UIComponent(uic_settlement_list:Find(1))
				out(uic_settlement:Id())
				if uic_settlement then
					local uic_default_slots_list = find_uicomponent(uic_settlement, "default_slots_list")
					out(uic_default_slots_list:Id())
					if uic_default_slots_list then
						local uic_settlement_first_building_slot = UIComponent(uic_default_slots_list:Find(1))
						out(uic_settlement_first_building_slot:Id())
						if uic_settlement_first_building_slot then
							uic_settlement_first_building_slot_saved = uic_settlement_first_building_slot
							uic_slot_entry = UIComponent(uic_settlement_first_building_slot:Find(0))
							out(uic_slot_entry:Id())
							if uic_slot_entry:Visible(true) then
								tour_test_upgrade_settlement:start("tour_test_upgrade_settlement_action_1")
								tourStarted = true
							end
						end
					end
				end
			end

			if tourStarted == false then
				cm:steal_user_input(false)
				prologue_intervention_upgrade_settlement:cancel()
				cm:contextual_vo_enabled(true);
			end
		end,
	1)
end

--------------------------------------------------------------
----------------------- Demolish ----------------------------
--------------------------------------------------------------

prologue_intervention_demolish = intervention:new(
	"prologue_demolish",
	0,
	function() prologue_demolish_intervention() end,
	BOOL_INTERVENTIONS_DEBUG
)

prologue_intervention_demolish:add_trigger_condition(
	"ScriptEventPrologueDemolish",
	true
);
prologue_intervention_demolish:set_should_prevent_saving_game()

function prologue_demolish_intervention()

	local uic_building_slot_with_demolish
	local uic_settlement_panel
	local building_slot
	local uic_child_selected_settlement

	cm:contextual_vo_enabled(false);

	tour_demolish_1 = scripted_tour:new("tour_demolish_1", 
		function() 
			uic_building_slot_with_demolish:SimulateMouseOn();
			
			cm:callback(
				function()
				tour_demolish_2:add_fullscreen_highlight("settlement_panel", "settlement_list", uic_child_selected_settlement:Id(), "settlement_view", "default_view", "default_slots_list", building_slot:Id(),
				"building_construction_popup", "popup_holder", "popup_panel", "building_tree_holder")
				tour_demolish_2:start("tour_demolish_2_action_1")
				end,
				0.5
			)
		end
	)

	tour_demolish_2 = scripted_tour:new("tour_demolish_2",
		function()
			prologue_tutorial_passed["demolish_with_button_hidden"] = true 
			cm:steal_user_input(false)
			core:remove_listener("enable_demolish_for_player_start")
			uic_building_slot_with_demolish:SimulateMouseOff()
			prologue_intervention_demolish:complete()
			cm:contextual_vo_enabled(true);
		end
	)

	tour_demolish_1:set_show_skip_button(false)
	tour_demolish_2:set_show_skip_button(false)
	
	-- This displays, "Your army is besieging a heavily defended settlement. This panel shows you the progress of the siege."
	tour_demolish_1:action(
		function()
			out("STARTING_DEMOLISH_TOUR_1")

			uim:override("demolish_with_button_hidden"):set_allowed(true);

			local text_pointer_test_demolish = text_pointer:new_from_component(
				"text_pointer_test_demolish",
				"bottom",
				100,
				uic_settlement_panel,
				0.5,
				0
			)
			text_pointer_test_demolish:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_demolish")
			text_pointer_test_demolish:set_style("semitransparent")
			text_pointer_test_demolish:set_topmost(true)
			text_pointer_test_demolish:set_highlight_close_button(0.5)
			text_pointer_test_demolish:set_close_button_callback(function() tour_demolish_1:complete() end)				text_pointer_test_demolish:show()
		end,
		0,
	"tour_demolish_1_action_1"
	)

	tour_demolish_2:action(
		function()
			out("STARTING_DEMOLISH_TOUR_2")

			uic_building_slot_with_demolish:SimulateMouseOn();

			cm:callback(
				function() 
					local uic_demolish_button = find_uicomponent(uic_building_slot_with_demolish, "building_construction_popup", "popup_holder", "popup_panel", "building_tree_holder", "options_parent", "options_buttons", "options_list", "button_raze"); 

					local text_pointer_test_demolish = text_pointer:new_from_component(
						"text_pointer_test_demolish",
						"left",
						100,
						uic_demolish_button,
						1,
						0.5
					)
					text_pointer_test_demolish:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_demolish_2")
					text_pointer_test_demolish:set_style("semitransparent")
					text_pointer_test_demolish:set_topmost(true)
					text_pointer_test_demolish:set_highlight_close_button(0.5)
					text_pointer_test_demolish:set_close_button_callback(function() tour_demolish_2:complete() end)
					text_pointer_test_demolish:show()
				end, 0.5
			)	
		end,
		0,
	"tour_demolish_2_action_1"
	)

	cm:callback(
		function ()
			tourStarted = false
			uic_settlement_panel = find_uicomponent("settlement_panel")
			
			if uic_settlement_panel then
			local uic_parent = find_uicomponent("settlement_panel", "settlement_list")

				if uic_parent and uic_parent:ChildCount() > 0 then
					uic_child_selected_settlement = UIComponent(uic_parent:Find(1))
					if uic_child_selected_settlement then
						local default_slots_list = find_uicomponent(uic_child_selected_settlement, "default_slots_list")

						if default_slots_list and default_slots_list:Visible(true) then
							for i = 0, default_slots_list:ChildCount() - 1 do

								if i > 0 then
									building_slot = UIComponent(default_slots_list:Find(i)) 
									
									if building_slot then
										local building_slot_object_id = building_slot:GetContextObjectId("CcoCampaignBuildingSlot")
										local contextValue = common.get_context_value("CcoCampaignBuildingSlot", building_slot_object_id, "CanDismantle")
									
										if contextValue then
											tour_demolish_1:add_fullscreen_highlight("settlement_panel")
											uic_building_slot_with_demolish = building_slot
											tourStarted = true
											break
										end
									
									end
								end
							
							end
						end
					end
				end	
			end

			if tourStarted then
				cm:steal_user_input(true)
				tour_demolish_1:start("tour_demolish_1_action_1")
			else
				prologue_intervention_demolish:cancel()
				cm:contextual_vo_enabled(true);
			end
		end, 
	0.01)
end


--------------------------------------------------------------
----------------------- Siege Battles ---------------------
--------------------------------------------------------------

prologue_intervention_first_siege = intervention:new(
	"prologue_first_siege",
	0,
	function () prologue_first_siege_intervention() end,
	BOOL_INTERVENTIONS_DEBUG
)

prologue_intervention_first_siege:add_trigger_condition(
	"ScriptEventPrologueFirstSiege",
	true)

prologue_intervention_first_siege:set_should_prevent_saving_game()
prologue_intervention_first_siege:set_wait_for_battle_complete(false);
prologue_intervention_first_siege:set_wait_for_fullscreen_panel_dismissed(false)

function prologue_first_siege_intervention()
	-- Saves whether this is an equipment/no equipment siege.
	local equipment_siege = false
	completely_lock_input(true)
	cm:contextual_vo_enabled(false);

	tour_test_first_siege = scripted_tour:new("tour_first_siege",
	-- Only remove this intervention if the player has seen the full equipment siege. Else, cancel it and keep the listeners alive.
	function ()
		first_siege_just_played = true
		core:add_listener(
			"PanelClosedCampaignPreBattleFirstSiege",
			"PanelClosedCampaign",
			function(context) return context.string == "popup_pre_battle" end,
			function() first_siege_just_played = false
			end,
			false
		)

		if prologue_check_progression["pre_battle_first_siege"] == true then
			prologue_check_progression["pre_battle_first_siege_without_equipment"] = true
			completely_lock_input(false)
			prologue_intervention_first_siege:complete()
			cm:contextual_vo_enabled(true);
		else
			completely_lock_input(false)
			prologue_intervention_first_siege:cancel()
			cm:contextual_vo_enabled(true);
		end
	end)

	tour_test_first_siege:set_show_skip_button(false)

	-- First action in the tour. This displays, "Your army is besieging a heavily defended settlement. This panel shows you the progress of the siege."
	tour_test_first_siege:action(
		function()
			out("STARTING_FIRST_SIEGE_TOUR_ACTION_1")

			-- Stop_user_input
			completely_lock_input(true)

			local uic = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "mid", "battle_deployment", "regular_deployment", "list", "common_ui_parent", "panel_title")

			local text_pointer_test_first_siege = text_pointer:new_from_component(
				"text_pointer_test_first_siege_1",
				"bottom",
				100,
				uic,
				0.5,
				0.2
			)
			text_pointer_test_first_siege:add_component_text("text", "ui_text_replacements_localised_text_prologue_first_siege_1")
			text_pointer_test_first_siege:set_style("semitransparent")
			text_pointer_test_first_siege:set_topmost(true)
			text_pointer_test_first_siege:set_highlight_close_button(0.5)
			text_pointer_test_first_siege:set_close_button_callback( 
				function()
					-- Skip advice if already seen.
					if prologue_check_progression["pre_battle_first_siege_without_equipment"] then
						tour_test_first_siege:start("tour_test_first_siege_action_walls")
					else
						tour_test_first_siege:start("tour_test_first_siege_action_2")
					end
				end
			)
			text_pointer_test_first_siege:show()
		end,
		0,
		"tour_test_first_siege_action_1"
	)

	-- Second action in the tour. This displays, "This shows how many turns you must maintain your siege until the settlement surrenders."
	tour_test_first_siege:action(
		function()
			out("STARTING_FIRST_SIEGE_TOUR_ACTION_2")

			local uic = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "mid", "battle_deployment", "regular_deployment", "list", "siege_information_panel", "icon_turns", "dy_turns")

			local text_pointer_test_first_siege = text_pointer:new_from_component(
				"text_pointer_test_first_siege_2",
				"bottom",
				100,
				uic,
				0.5,
				0.2
			)
			text_pointer_test_first_siege:add_component_text("text", "ui_text_replacements_localised_text_prologue_first_siege_2")
			text_pointer_test_first_siege:set_style("semitransparent")
			text_pointer_test_first_siege:set_topmost(true)
			text_pointer_test_first_siege:set_highlight_close_button(0.5)
			text_pointer_test_first_siege:set_close_button_callback(function() tour_test_first_siege:start("tour_test_first_siege_action_3") end)
			text_pointer_test_first_siege:show()
		end,
		0,
		"tour_test_first_siege_action_2"
	)

	-- Third action in the tour. This displays, "This shows how many turns you must maintain your siege until the garrison starts taking damage."
	tour_test_first_siege:action(
		function()
			out("STARTING_FIRST_SIEGE_TOUR_ACTION_3")

			local uic = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "mid", "battle_deployment", "regular_deployment", "list", "siege_information_panel", "header", "tl_list", "defender_siege_supplies")

			local text_pointer_test_first_siege = text_pointer:new_from_component(
				"text_pointer_test_first_siege_3",
				"bottom",
				100,
				uic,
				0.5,
				0.2
			)
			text_pointer_test_first_siege:add_component_text("text", "ui_text_replacements_localised_text_prologue_first_siege_3")
			text_pointer_test_first_siege:set_style("semitransparent")
			text_pointer_test_first_siege:set_topmost(true)
			text_pointer_test_first_siege:set_highlight_close_button(0.5)
			text_pointer_test_first_siege:set_close_button_callback(
				function()
					-- Check to see if this is a walled siege battle and start appropriate tour.
					if equipment_siege == false then
						prologue_check_progression["pre_battle_first_siege_without_equipment"] = true
						tour_test_first_siege:complete()
						completely_lock_input(false);
					else
						tour_test_first_siege:start("tour_test_first_siege_action_walls")
					end
				end)
			text_pointer_test_first_siege:show()
		end,
		0,
		"tour_test_first_siege_action_3"
	)

	-- Fourth action in the tour. This displays, "This icon shows you are attacking a settlement with walls. Move your cursor over it to view the walls' remaining strength."
	tour_test_first_siege:action(
		function()
			out("STARTING_FIRST_SIEGE_TOUR_ACTION_WALLS")

			local uic = find_uicomponent(core:get_ui_root(), "icon_wall_integrity")

			local text_pointer_test_first_siege = text_pointer:new_from_component(
				"text_pointer_test_first_siege_walls",
				"bottom",
				100,
				uic,
				0.5,
				0
			)
			text_pointer_test_first_siege:add_component_text("text", "ui_text_replacements_localised_text_prologue_first_siege_walls")
			text_pointer_test_first_siege:set_style("semitransparent")
			text_pointer_test_first_siege:set_topmost(true)
			text_pointer_test_first_siege:set_highlight_close_button(0.5)
			text_pointer_test_first_siege:set_close_button_callback(function() tour_test_first_siege:start("tour_test_first_siege_action_4") end)
			text_pointer_test_first_siege:show()
		end,
		0,
		"tour_test_first_siege_action_walls"
	)

	-- Fourth action in the tour. This displays, "You can also build siege equipment to make the settlement easier to attack. Each piece of equipment costs Labour to build."
	tour_test_first_siege:action(
		function()
			out("STARTING_FIRST_SIEGE_TOUR_ACTION_4")

			local uic = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "mid", "battle_deployment", "regular_deployment", "list", "siege_information_panel", "attacker_recruitment_options", "equipment_frame", "tx_equipment")

			local text_pointer_test_first_siege = text_pointer:new_from_component(
				"text_pointer_test_first_siege_4",
				"bottom",
				100,
				uic,
				0.5,
				0.2
			)
			text_pointer_test_first_siege:add_component_text("text", "ui_text_replacements_localised_text_prologue_first_siege_4")
			text_pointer_test_first_siege:set_style("semitransparent")
			text_pointer_test_first_siege:set_topmost(true)
			text_pointer_test_first_siege:set_highlight_close_button(0.5)
			text_pointer_test_first_siege:set_close_button_callback(function() tour_test_first_siege:start("tour_test_first_siege_action_5") end)
			text_pointer_test_first_siege:show()
		end,
		0,
		"tour_test_first_siege_action_4"
	)

	-- Fifth action in the tour. This displays, "You can view your total Labour here and how much you can spend per turn."
	tour_test_first_siege:action(
		function()
			out("STARTING_FIRST_SIEGE_TOUR_ACTION_5")

			local uic = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "mid", "battle_deployment", "regular_deployment", "list", "siege_information_panel", "attacker_recruitment_options", "labour_frame")

			local text_pointer_test_first_siege = text_pointer:new_from_component(
				"text_pointer_test_first_siege_5",
				"bottom",
				100,
				uic,
				0.5,
				0.2
			)
			text_pointer_test_first_siege:add_component_text("text", "ui_text_replacements_localised_text_prologue_first_siege_5")
			text_pointer_test_first_siege:set_style("semitransparent")
			text_pointer_test_first_siege:set_topmost(true)
			text_pointer_test_first_siege:set_highlight_close_button(0.5)
			text_pointer_test_first_siege:set_close_button_callback(function() tour_test_first_siege:start("tour_test_first_siege_action_6") end)
			text_pointer_test_first_siege:show()
		end,
		0,
		"tour_test_first_siege_action_5"
	)

	-- Sxith action in the tour. This displays, "Once you've prepared your siege, press this button to begin your attack.."
	tour_test_first_siege:action(
		function()
			out("STARTING_FIRST_SIEGE_TOUR_ACTION_6")

			local uic = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "mid", "battle_deployment", "regular_deployment", "button_attack_container")

			local text_pointer_test_first_siege = text_pointer:new_from_component(
				"text_pointer_test_first_siege_6",
				"bottom",
				100,
				uic,
				0.5,
				0.2
			)
			text_pointer_test_first_siege:add_component_text("text", "ui_text_replacements_localised_text_prologue_first_siege_6")
			text_pointer_test_first_siege:set_style("semitransparent")
			text_pointer_test_first_siege:set_topmost(true)
			text_pointer_test_first_siege:set_highlight_close_button(0.5)
			text_pointer_test_first_siege:set_close_button_callback(function() 
				prologue_check_progression["pre_battle_first_siege"] = true
				tour_test_first_siege:complete()
				completely_lock_input(false)
			end)
			text_pointer_test_first_siege:show()
		end,
		0,
		"tour_test_first_siege_action_6"
	)

	-- This is the no equipment variant of the tour for a settlement that doesn't have walls.

	cm:callback(function() 
		local uic = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "mid", "battle_deployment", "regular_deployment", "list", "common_ui_parent", "panel_title")

		-- If the component isn't visible, cancel intervention.
		if uic == false then
			completely_lock_input(false)
			prologue_intervention_first_siege:cancel()
			cm:contextual_vo_enabled(true);
		else
			-- Check to see if this is a walled siege battle and start appropriate tour.
			local uic_no_siege_equipment = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "mid", "battle_deployment", "regular_deployment", "list", "siege_information_panel", "no_equipment_label")

			if uic_no_siege_equipment then
				if uic_no_siege_equipment:Visible() == false then
					-- If this is a full siege battle with equipment.
					equipment_siege = true
					tour_test_first_siege:add_fullscreen_highlight("popup_pre_battle", "mid", "battle_deployment", "regular_deployment", "list")
					tour_test_first_siege:start("tour_test_first_siege_action_1")
				elseif prologue_check_progression["pre_battle_first_siege_without_equipment"] then
					-- Cancel the intervention if the no equipment siege tutorial has been seen before.
					completely_lock_input(false)
					prologue_intervention_first_siege:cancel()
					cm:contextual_vo_enabled(true);
				else
					-- Start the tour if the no equipment siege tutorial hasn't been seen before.
					equipment_siege = false
					tour_test_first_siege:add_fullscreen_highlight("popup_pre_battle", "mid", "battle_deployment", "regular_deployment", "list")
					tour_test_first_siege:start("tour_test_first_siege_action_1")
				end
			else
				-- Cancel the intervention if for some reason, the no_siege_equipment_panel cannot be found.
				completely_lock_input(false)
				prologue_intervention_first_siege:cancel()
				cm:contextual_vo_enabled(true);
			end
		end
	end, 1)
end

--------------------------------------------------------------
----------------------- Garrison ----------------------------
--------------------------------------------------------------
prologue_intervention_garrison = intervention:new(
	"prologue_garrison",
	0,
	function () prologue_garrison_intervention() end,
	BOOL_INTERVENTIONS_DEBUG
)

prologue_intervention_garrison:add_trigger_condition(
	"ScriptEventPrologueGarrisonTour",
	true
)
prologue_intervention_garrison:set_should_prevent_saving_game()
prologue_intervention_garrison:set_wait_for_fullscreen_panel_dismissed(false)

function prologue_garrison_intervention ()
	
	cm:steal_user_input(true)
	cm:steal_escape_key(true)
	allow_hotkeys(false)
	cm:contextual_vo_enabled(false);
	
	local uic_button_show_garrison
	local uic_garrison_view
	local tour_test_garrison_2 = scripted_tour:new("tour_garrison_2", function () allow_hotkeys(true); cm:steal_user_input(false); cm:steal_escape_key(false); core:remove_listener("SettlementSelectedGarrisonTour"); prologue_intervention_garrison:complete() end)
	local tour_test_garrison = scripted_tour:new("tour_garrison", 
		function() 
			cm:callback(function() tour_test_garrison_2:start() end, 0.5)
		end
	)	
	tour_test_garrison:action(
		function()
			out("STARTING_GARRISON_TOUR")

			add_callback_button_press_intervention("button_show_garrison", true, function() tour_test_garrison:complete() cm:contextual_vo_enabled(true); end)

			uic_button_show_garrison = find_uicomponent(core:get_ui_root(), "hud_center", "small_bar", "button_subpanel", "button_show_garrison")

			local text_pointer_test_garrison = text_pointer:new_from_component(
				"text_pointer_test_garrison",
				"bottom",
				100,
				uic_button_show_garrison,
				0.5,
				0
			)
			text_pointer_test_garrison:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_garrison")
			text_pointer_test_garrison:set_style("semitransparent")
			text_pointer_test_garrison:set_topmost(true)
			text_pointer_test_garrison:show()
		end,
		1
	)

	tour_test_garrison_2:action(
		function()
			out("STARTING_GARRISON_TOUR_2")

			local text_pointer_test_garrison = text_pointer:new_from_component(
				"text_pointer_test_garrison",
				"bottom",
				100,
				uic_garrison_view,
				0.5,
				0
			)
			text_pointer_test_garrison:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_garrison_2")
			text_pointer_test_garrison:set_style("semitransparent")
			text_pointer_test_garrison:set_topmost(true)
			text_pointer_test_garrison:set_highlight_close_button(2)
			text_pointer_test_garrison:set_close_button_callback(function() tour_test_garrison_2:complete() end)
			text_pointer_test_garrison:show()
		end,
		1
	)

	cm:callback(
		function() 
			local uic_settlement_panel = find_uicomponent(core:get_ui_root(), "settlement_panel")
			local uic_settlement_list = find_uicomponent("settlement_panel", "settlement_list")
			
			if uic_settlement_panel and uic_settlement_panel:Visible(true) and uic_settlement_list and uic_settlement_list:Visible(true) then
				cm:steal_user_input(true)
				uic_garrison_view = find_uicomponent("settlement_panel", "settlement_list", uic_settlement_list:Id())
				cm:override_ui("hide_units_panel_small_bar_buttons", false);	
				uim:override("units_panel_small_bar_buttons"):set_allowed(true);
				uim:override("settlement_panel_garrison_with_button_hidden"):set_allowed(true);
				prologue_tutorial_passed["settlement_panel_garrison_with_button_hidden"] = true;
				cm:callback(
					function() 
						tour_test_garrison:set_show_skip_button(false)
						tour_test_garrison_2:set_show_skip_button(false)
						tour_test_garrison:add_fullscreen_highlight("hud_center", "small_bar", "button_subpanel", "button_group_settlement", "button_show_garrison")
						tour_test_garrison:set_fullscreen_highlight_padding(2)
						tour_test_garrison_2:add_fullscreen_highlight("settlement_panel", "settlement_list", uic_garrison_view:Id())
						tour_test_garrison:start()
					end,
					1
				)
			else
				cm:steal_escape_key(false)
				cm:steal_user_input(false)
				allow_hotkeys(true)
				prologue_intervention_garrison:cancel()
				cm:contextual_vo_enabled(true);
			end
		end, 
		0.5
	)
end

--------------------------------------------------------------
----------------------- Building browser ---------------------
--------------------------------------------------------------

prologue_intervention_building_browser = intervention:new(
	"prologue_building_browser", 														-- string name
	0, 																	-- cost
	function() prologue_building_browser_intervention() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

prologue_intervention_building_browser:add_trigger_condition(
	"ScriptEventPrologueBuildingBrowser",
	true
);
prologue_intervention_building_browser:set_should_prevent_saving_game()

function prologue_building_browser_intervention()
	-- Temporarily stops a users input.
	cm:steal_user_input(true)
	cm:contextual_vo_enabled(false);

	-- Fakes a click on the settlement.
	common.call_context_command("CcoCampaignSettlement", open_settlement_taken, "Select(false)")

	-- Save progress and enable component.
	prologue_tutorial_passed["settlement_panel_building_browser_with_button_hidden"] = true;
	uim:override("settlement_panel_building_browser_with_button_hidden"):set_allowed(true);
	uim:override("units_panel_small_bar_buttons"):set_allowed(true);
	
	-- Store the building browser component and set it active.
	local uic_building_browser = find_uicomponent(core:get_ui_root(),"hud_center", "small_bar", "button_subpanel", "button_building_browser")
	uic_building_browser:SetState("active")

	-- Creates tour with callback to complete intervention.
	tour_test_building_browser_intervention = scripted_tour:new("tour_buiding_browser", function() uim:override("end_turn"):set_allowed(true); core:remove_listener("any_component_click_up_listener"); prologue_intervention_building_browser:complete() cm:contextual_vo_enabled(true); end)
	tour_test_building_browser_intervention:set_show_skip_button(false)
	tour_test_building_browser_intervention:action(
		function()
			out("STARTING BUILDING BROWSER TOUR")

			local text_pointer_test_building_browser_tour = text_pointer:new_from_component(
				"test_text_pointer_building_browser",
				"bottom",
				100,
				uic_building_browser,
				0.5,
				0
			)
			text_pointer_test_building_browser_tour:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_building_browser")
			text_pointer_test_building_browser_tour:set_style("semitransparent")
			text_pointer_test_building_browser_tour:set_topmost(true)
			text_pointer_test_building_browser_tour:set_highlight_close_button(2)
			text_pointer_test_building_browser_tour:set_close_button_callback(function() tour_test_building_browser_intervention:complete() end)

			core:add_listener(
					"any_component_click_up_listener",
					"ComponentLClickUp",
					true,
					function()
						text_pointer_test_building_browser_tour:hide()
						tour_test_building_browser_intervention:complete()
					end,
					false
				);
			text_pointer_test_building_browser_tour:show()
			cm:steal_user_input(false)
		end,
		1
	)
	cm:callback(function() tour_test_building_browser_intervention:add_fullscreen_highlight("hud_center", "small_bar", "button_subpanel", "button_building_browser"); tour_test_building_browser_intervention:start() end, 1)
end

--------------------------------------------------------------
----------------------- Province info panel ---------------------
--------------------------------------------------------------

prologue_intervention_province_info_panel = intervention:new(
	"prologue_province_info",
	0,
	function() prologue_province_info_panel_intervention() end,
	BOOL_INTERVENTIONS_DEBUG
);

prologue_intervention_province_info_panel:add_trigger_condition(
	"ScriptEventPrologueProvinceInfoPanel",
	true
);
prologue_intervention_province_info_panel:set_should_prevent_saving_game()
prologue_intervention_province_info_panel:set_wait_for_battle_complete(false);
prologue_intervention_province_info_panel:set_wait_for_fullscreen_panel_dismissed(false)

function prologue_province_info_panel_intervention()	
	
	common.call_context_command("CcoCampaignSettlement", prologue_captured_settlement_cqi, "Select(false)");
	cm:steal_user_input(true)
	allow_hotkeys(false)
	cm:contextual_vo_enabled(false);

	cm:override_ui("hide_units_panel_small_bar_buttons", false);	
	
	prologue_tutorial_passed["province_info_panel"] = true;
	uim:override("province_info_panel"):set_allowed(true);

	prologue_tutorial_passed["demolish_with_button_hidden"] = true;
	uim:override("demolish_with_button_hidden"):set_allowed(true);

	prologue_tutorial_passed["settlement_panel_building_browser_with_button_hidden"] = true;
	uim:override("settlement_panel_building_browser_with_button_hidden"):set_allowed(true);

	prologue_tutorial_passed["building_browser"] = true;
	uim:override("building_browser"):set_allowed(true)

	-- Stop suppressing settlement growth.
	cm:remove_effect_bundle("wh3_prologue_suppress_growth", cm:get_local_faction_name())

	-- Enable end turn upgrade notifications.
	suppress_end_turn_event("PROVINCES_NO_CONSTRUCTION_PROJECT", false)
	
	steal_input_completely_on_event(true, "PanelOpenedCampaign", function(context) return context.string == "settlement_panel" end , 0.01, "PanelOpenedCampaignStealEscProvinceInfo", "PanelOpenedCampaignStealUserInputProvinceInfo", prologue_intervention_province_info_panel)
	
	local province_info_panel
	local uic_frame_growth
	local uic_growth_rate
	local uic_dy_turns
	local uic_surplus_fill_holder
	local uic_building_browser
	local uic_main_building_chain
	local tour_test_building_browser_3 = scripted_tour:new("tour_buiding_browser_3", function() cm:steal_user_input(false); allow_hotkeys(true); cm:steal_escape_key(false); prologue_mission_building_level:trigger(); prologue_intervention_province_info_panel:complete() cm:contextual_vo_enabled(true); end)

	local tour_test_building_browser_2 = scripted_tour:new("tour_buiding_browser_2", function() cm:callback(function () tour_test_building_browser_3:start("tour_building_browser_3_1") end, 0.5) end)

	local tour_test_building_browser_1 = scripted_tour:new(
		"tour_buiding_browser_1", 
		function() 
			cm:callback(function ()
				
				local uic_category_list = find_uicomponent(core:get_ui_root(), "building_browser", "building_superchains", "list_clip", "list_box", "building_tree", "category_list")
				if uic_category_list then
					for i = 0, uic_category_list:ChildCount() - 1 do
						if i == 1 then
							uic_main_building_chain = UIComponent(uic_category_list:Find(i))
							tour_test_building_browser_2:add_fullscreen_highlight("building_browser", "building_superchains", "list_clip", "list_box", "building_tree", "category_list", uic_main_building_chain:Id())
						elseif i > 1 then
							local building_chain = UIComponent(uic_category_list:Find(i))
							tour_test_building_browser_3:add_fullscreen_highlight("building_browser", "building_superchains", "list_clip", "list_box", "building_tree", "category_list", building_chain:Id())
						end
					end
				end

				tour_test_building_browser_2:start("tour_building_browser_2_1") end, 
				1.5
			)
		end
	)

	local tour_test_province_info = scripted_tour:new("test2_tour_province_info", function() cm:callback(function () tour_test_building_browser_1:start("tour_building_browser_1_1") end, 0.5) end)

	tour_test_province_info:action(
		function() 
			out("STARTING ACTION 1 IN TOUR 1") 
			uic_building_browser:SetState("active")
			
			core:show_fullscreen_highlight_around_components(0, false, false, province_info_panel)

			local text_pointer_test_province_info = text_pointer:new_from_component(
				"test2_text_pointer_province",
				"bottom",
				100,
				province_info_panel,
				0.5,
				0
			);
			
			text_pointer_test_province_info:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_province_info_1");
			text_pointer_test_province_info:set_style("semitransparent");
			text_pointer_test_province_info:set_topmost(true);
			text_pointer_test_province_info:set_label_offset(30, 0)
			text_pointer_test_province_info:set_close_button_callback(function() core:hide_fullscreen_highlight(); cm:callback(function() tour_test_province_info:start("test2_tour_province_info_3") end, 0.5) end);
			text_pointer_test_province_info:set_highlight_close_button(2);
			text_pointer_test_province_info:show();
			
		end,
		0,
		"test2_tour_province_info_1"
	)

	tour_test_province_info:action(
		function() 
			out("STARTING ACTION 3 IN TOUR 1") 
			core:show_fullscreen_highlight_around_components(0, false, false, uic_growth_rate)
	
			local text_pointer_test_province_info_2 = text_pointer:new_from_component(
				"test3_text_pointer",
				"bottom",
				100,
				uic_growth_rate,
				0.5,
				0
			)
			
			pulse_uicomponent(province_info_panel, false, 0, false)

			text_pointer_test_province_info_2:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_province_info_3");
			text_pointer_test_province_info_2:set_style("semitransparent");
			text_pointer_test_province_info_2:set_label_offset(100, 0);
			text_pointer_test_province_info_2:set_topmost(true);
			text_pointer_test_province_info_2:set_close_button_callback(function() core:hide_fullscreen_highlight(); cm:callback(function() tour_test_province_info:start("test2_tour_province_info_5") end, 0.5) end);
			text_pointer_test_province_info_2:set_highlight_close_button(2);
			text_pointer_test_province_info_2:show();
			
		end,
		0,
		"test2_tour_province_info_3"
	)

	tour_test_province_info:action(
		function() 
			out("STARTING ACTION 5 IN TOUR 1") 
			core:show_fullscreen_highlight_around_components(0, false, false, uic_surplus_fill_holder)
	
			local text_pointer_test_province_info_2 = text_pointer:new_from_component(
				"test3_text_pointer",
				"bottom",
				100,
				uic_surplus_fill_holder,
				0.5,
				0
			)
			
			pulse_uicomponent(province_info_panel, false, 0, false)

			text_pointer_test_province_info_2:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_province_info_5");
			text_pointer_test_province_info_2:set_style("semitransparent");
			text_pointer_test_province_info_2:set_topmost(true);
			text_pointer_test_province_info_2:set_close_button_callback(function() core:hide_fullscreen_highlight(); cm:callback(function() tour_test_province_info:start("test2_tour_province_info_6") end, 0.5) end);
			text_pointer_test_province_info_2:set_highlight_close_button(2);
			text_pointer_test_province_info_2:show();
			
		end,
		0,
		"test2_tour_province_info_5"
	)

	tour_test_province_info:action(
		function() 
			out("STARTING ACTION 6 IN TOUR 1") 
			core:show_fullscreen_highlight_around_components(0, false, false, uic_growth_rate)
	
			local text_pointer_test_province_info_2 = text_pointer:new_from_component(
				"test3_text_pointer",
				"bottom",
				100,
				uic_growth_rate,
				0.5,
				0
			)
			
			pulse_uicomponent(province_info_panel, false, 0, false)

			text_pointer_test_province_info_2:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_province_info_6");
			text_pointer_test_province_info_2:set_style("semitransparent");
			text_pointer_test_province_info_2:set_label_offset(100, 0);
			text_pointer_test_province_info_2:set_topmost(true);
			text_pointer_test_province_info_2:set_close_button_callback(function() core:hide_fullscreen_highlight(); tour_test_province_info:complete() end);
			text_pointer_test_province_info_2:set_highlight_close_button(2);
			text_pointer_test_province_info_2:show();
			
		end,
		0,
		"test2_tour_province_info_6"
	)

	tour_test_building_browser_1:action(
		function()
			out("STARTING_BUILDING_BROWSER_TOUR_1")
			tour_test_building_browser_1:show_fullscreen_highlight(true)

			add_callback_button_press_intervention("button_building_browser", true, function() tour_test_building_browser_1:complete() end)
			steal_input_completely_on_event(true, "PanelOpenedCampaign", function(context) return context.string == "building_browser" end , 0.01, "PanelOpenedCampaignStealEscBuildingBrowser", "PanelOpenedCampaignStealUserInputBuildingBrowser", prologue_intervention_province_info_panel)
			
			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"bottom",
				100,
				uic_building_browser,
				0.5,
				0
			)	
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_building_browser")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:show()		
		end, 0,
	"tour_building_browser_1_1"
	)

	tour_test_building_browser_2:action(
		function()
			out("STARTING_BUILDING_BROWSER_TOUR_2")
			tour_test_building_browser_2:show_fullscreen_highlight(true)

			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"left",
				100,
				uic_main_building_chain,
				1,
				0.5
			)	
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_building_browser_2")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:set_close_button_callback(function() tour_test_building_browser_2:complete() end)
			tp:show()		
		end, 0,
	"tour_building_browser_2_1"
	)

	tour_test_building_browser_3:action(
		function()
			local uic_building_tree = find_uicomponent(core:get_ui_root(), "building_browser", "building_superchains", "list_clip", "list_box", "building_tree")

			out("STARTING_BUILDING_BROWSER_TOUR_3")
			tour_test_building_browser_3:show_fullscreen_highlight(true)

			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"top",
				100,
				uic_building_tree,
				0.5,
				1
			)	
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_building_browser_3")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:set_close_button_callback(function() 
				tour_test_building_browser_3:complete() 
				
				core:add_listener(
					"Building_browser_closed",
					"PanelClosedCampaign",
					function(context) 
						return context.string == "building_browser" 
					end,
					function()
						if prologue_trial_mission == "mansion_of_eyes" then
							PrologueMansionOfEyes();
							prologue_trial_mission = "";
						elseif prologue_trial_mission == "tribal" then
							PrologueTribalMission();
							prologue_trial_mission = "";
						else
							cm:contextual_vo_enabled(true);
						end
					end,
					false
				);
				
				
			
			end)
			tp:show()		
		end, 0,
	"tour_building_browser_3_1"
	)

	cm:callback(
		function ()
			province_info_panel = find_uicomponent(core:get_ui_root(), "hud_campaign", "info_panel_holder", "panel");
			uic_building_browser = find_uicomponent(core:get_ui_root(),"hud_center", "small_bar", "button_subpanel", "button_building_browser")
			uic_frame_growth = find_uicomponent(core:get_ui_root(),"hud_campaign", "info_panel_holder", "primary_info_panel_holder", "info_panel_background", "ProvinceInfoPopup", "script_hider_parent", "panel", "frame_growth")
			uic_growth_rate = find_uicomponent(core:get_ui_root(),"hud_campaign", "info_panel_holder", "primary_info_panel_holder", "info_panel_background", "ProvinceInfoPopup", "script_hider_parent", "panel", "frame_growth", "row_holder", "growth_rate")
			uic_dy_turns = find_uicomponent(core:get_ui_root(),"hud_campaign", "info_panel_holder", "primary_info_panel_holder", "info_panel_background", "ProvinceInfoPopup", "script_hider_parent", "panel", "frame_growth", "row_holder", "dy_turns")
			uic_surplus_fill_holder = find_uicomponent(core:get_ui_root(),"hud_campaign", "info_panel_holder", "primary_info_panel_holder", "info_panel_background", "ProvinceInfoPopup", "script_hider_parent", "panel", "frame_growth", "row_holder", "surplus_parent", "surplus_fill_holder")
			
			if province_info_panel and province_info_panel:Visible(true) and uic_building_browser and uic_building_browser:Visible(true) and uic_frame_growth and uic_frame_growth:Visible(true) and uic_growth_rate and uic_growth_rate:Visible(true)
			and uic_dy_turns and uic_dy_turns:Visible(true) and uic_surplus_fill_holder and uic_surplus_fill_holder:Visible(true) then

				CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_industry");
				CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_barracks");
				CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_stables");
				CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_sleds");
				CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_timber");
				CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_attack");
				CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_armour");
				CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_ammunition");
				CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_ice_enclave");
				CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_ksl_building_second_growth");
				CampaignUI.AddBuildingChainToWhitelist("wh3_prologue_building_ksl_special");
	
				tour_test_province_info:set_show_skip_button(false)
				tour_test_building_browser_1:set_show_skip_button(false)
				tour_test_building_browser_1:set_fullscreen_highlight_padding(3)
				tour_test_building_browser_2:set_show_skip_button(false)
				tour_test_building_browser_3:set_show_skip_button(false)
				tour_test_building_browser_1:add_fullscreen_highlight("hud_center", "small_bar", "button_subpanel", "button_building_browser");
				tour_test_province_info:start("test2_tour_province_info_1");  
			else
				cm:steal_user_input(false)
				allow_hotkeys(true)
				prologue_intervention_province_info_panel:cancel()
				cm:contextual_vo_enabled(true);
			end
		end,
	1)
end

--------------------------------------------------------------
----------------------- Resource bar ---------------------
--------------------------------------------------------------

prologue_intervention_resource_bar = intervention:new(
	"prologue_resource_bar", 														-- string name
	0, 																	-- cost
	function() prologue_resource_bar_intervention() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

prologue_intervention_resource_bar:add_trigger_condition(
	"ScriptEventPrologueResourceBar",
	true
);
prologue_intervention_resource_bar:set_should_prevent_saving_game()

function prologue_resource_bar_intervention()

	prologue_show_compass = false;
	
	cm:callback(function()
		local uic_resource_bar = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar");
		local uic_treasury = find_uicomponent(core:get_ui_root(), "resources_bar_holder", "resources_bar", "treasury_holder");
				
		if uic_treasury then
			uic_treasury:SetVisible(true);
		end

		local tour_test_resource_bar = scripted_tour:new(
			"test2_tour_resource_bar",
			function() 
				cm:replenish_action_points("faction:"..prologue_player_faction..",forename:1643960929", 0)
				prologue_intervention_resource_bar:complete()
				cm:contextual_vo_enabled(true);
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(11, "finished_treasury_tutorial", true);

				if prologue_check_progression["first_settlement_revealed"] == true then
					PrologueSettlementMarker();
				else
					PrologueAddTopicLeader("wh3_prologue_objective_turn_001_04", function() uim:override("end_turn"):set_allowed(true); HighlightEndTurnButton() end);
				end
			end
		);
		
		tour_test_resource_bar:set_show_skip_button(false);
		tour_test_resource_bar:add_fullscreen_highlight("hud_campaign", "resources_bar");

		local text_pointer_test_resource_bar = text_pointer:new_from_component(
			"test2_text_pointer_mission",
			"top",
			100,
			uic_resource_bar,
			0.5,
			1
		);

				
		tour_test_resource_bar:action(
			function() 
				out("STARTING AN ACTION 1 IN TOUR 2") 
				
				text_pointer_test_resource_bar:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_resource_bar");
				text_pointer_test_resource_bar:set_style("semitransparent");
				text_pointer_test_resource_bar:set_topmost(true);
				text_pointer_test_resource_bar:set_close_button_callback(function() tour_test_resource_bar:complete(); core:remove_listener("resource_bar_button_listener");  end);
				text_pointer_test_resource_bar:set_highlight_close_button(2);
				text_pointer_test_resource_bar:set_hide_on_close_button_clicked(false);
				text_pointer_test_resource_bar:show();
			
				
			end,
			0
		);

		--[[
		tour_test_resource_bar:action(
			function() 
				out("STARTING AN ACTION 2 IN TOUR 1") 


				local resource_size_x, resource_size_y = uic_resource_bar:Dimensions();
				local resource_pos_x, resource_pos_y = uic_resource_bar:Position();
				
				local text_pointer_test_resource_bar_2 = text_pointer:new(
					"test3_text_pointer",
					"left",
					0,
					resource_pos_x + 350, resource_pos_y + (resource_size_y / 2) + 185
				);

				text_pointer_test_resource_bar_2:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_resource_bar_2");
				text_pointer_test_resource_bar_2:set_style("semitransparent");
				text_pointer_test_resource_bar_2:set_topmost(true);
				text_pointer_test_resource_bar_2:set_close_button_callback(function() text_pointer_test_resource_bar:hide(); tour_test_resource_bar:complete(); core:remove_listener("resource_bar_button_listener"); end);
				text_pointer_test_resource_bar_2:set_highlight_close_button(2);
				text_pointer_test_resource_bar_2:show();
				
			end,
			0,
			"show_second_text_pointer"
		);
		--]]
		core:add_listener(
			"resource_bar_button_listener",
			"ComponentLClickUp",
			function(context) 
				return context.string == "button_finance" 
			end,
			function()
				core:hide_fullscreen_highlight(); 
				tour_test_resource_bar:complete(); 
				core:remove_listener("resource_bar_button_listener");
				text_pointer_test_resource_bar:hide();
			end,
			false
		);

		tour_test_resource_bar:start();  
	 end, 1.5);
	
end

--------------------------------------------------------------
----------------------- Lord recruit ---------------------
--------------------------------------------------------------

prologue_intervention_lord_recruit = intervention:new(
	"prologue_lord_recruit", 														-- string name
	0, 																	-- cost
	function() prologue_lord_recruit_intervention() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

prologue_intervention_lord_recruit:add_trigger_condition(
	"ScriptEventPrologueLordRecruit",
	true
);
prologue_intervention_lord_recruit:set_should_prevent_saving_game()
prologue_intervention_lord_recruit:set_should_lock_ui()

function prologue_lord_recruit_intervention()

	prologue_check_progression["lord_recruitment"] = true
	cm:override_ui("hide_units_panel_small_bar_buttons", false);
	prologue_tutorial_passed["settlement_panel_lord_recruit_with_button_hidden"] = true
	uim:override("settlement_panel_lord_recruit_with_button_hidden"):set_allowed(true);
	allow_hotkeys(false)

	core:add_listener(
		"PanelOpenedCampaignSettlementPanel",
		"PanelOpenedCampaign",
		function(context) return context.string == "settlement_panel" end,
		function()
			cm:callback(function() 
				completely_lock_input(true)
			end, 0.01)
		end,
		false			
	)

	local closest_region = cm:get_closest_settlement_from_faction_to_position(prologue_player_faction, cm:model():world():faction_by_key(prologue_player_faction):faction_leader():logical_position_x(), cm:model():world():faction_by_key(prologue_player_faction):faction_leader():logical_position_y())
	common.call_context_command("CcoCampaignSettlement", closest_region:cqi(), "Select(false)");

	cm:disable_event_feed_events(false, "", "", "character_ready_for_duty_starting_general"); 

	cm:callback(function()
		local uic_recruit_button = find_uicomponent(core:get_ui_root(), "hud_center_docker", "small_bar", "button_create_army");
		
		cm:steal_user_input(false)
		cm:steal_escape_key(true)

		core:remove_listener("FactionTurnStart_Lord_Recruitment_Listener");
		core:remove_listener("PanelOpenedCampaignSettlementPanel")
		
		local tour_test_recruit_button = scripted_tour:new(
			"test2_tour_recruit_button",
			function() 
				allow_hotkeys(true)
				prologue_intervention_lord_recruit:complete()
				cm:contextual_vo_enabled(true); 
				uim:override("end_turn"):set_allowed(true);
			end
		)
		tour_test_recruit_button:set_show_skip_button(false);
		tour_test_recruit_button:add_fullscreen_highlight("hud_center_docker", "small_bar", "button_create_army");
		tour_test_recruit_button:set_fullscreen_highlight_padding(2)

		tour_test_recruit_button:action(
			function() 
				out("STARTING AN ACTION 1 IN TOUR 2") 
				local text_pointer_test_recruit_button = text_pointer:new_from_component(
					"test2_text_pointer_recruit",
					"bottom",
					100,
					uic_recruit_button,
					0.5,
					0
				);
				
				text_pointer_test_recruit_button:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_lord_recruit_button");
				text_pointer_test_recruit_button:set_style("semitransparent");
				text_pointer_test_recruit_button:set_topmost(true);
				text_pointer_test_recruit_button:set_show_close_button(false);
				text_pointer_test_recruit_button:show();

				core:add_listener(
					"lord_button_listener",
					"ComponentLClickUp",
					function(context) return context.string == "button_create_army" end,
					function() tour_test_recruit_button:complete() cm:contextual_vo_enabled(true); end,
					false
				);

			end,
			0
		);
		tour_test_recruit_button:start();  
	 end, 1.5);
end


--------------------------------------------------------------
----------------------- Skills ---------------------
--------------------------------------------------------------

prologue_intervention_skills = intervention:new(
	"prologue_skills", 														-- string name
	0, 																	-- cost
	function() prologue_skills_intervention() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

prologue_intervention_skills:add_trigger_condition(
	"ScriptEventPrologueSkills",
	true
);
prologue_intervention_skills:set_should_prevent_saving_game()

function prologue_skills_intervention()
	local uic_listview

	local selected_skill = false;

	-- Enable character selection. This was started in PrologueAfterSecondBattle in stage_3.
	uim:disable_character_selection_whitelist()

	-- Suppressing all events. This is needed to stop the mission compelte around here from closing the character panel (mission complete and dilemmas are not blocked.)
	CampaignUI.SuppressAllEventTypesInUI(true)

	completely_lock_input(true)
	allow_hotkeys(false)

	core:add_listener(
		"CharacterSkillPointAllocated_Prologue_tour",
		"CharacterSkillPointAllocated", 
		true,
		function(context)
			selected_skill = true;
		end,
		false
	);

	core:add_listener(
		"PanelOpenedCampaignStopScrolling",
		"PanelOpenedCampaign",
		function(context) 
			return context.string == "character_details_panel" 
		end,
		function()	
			uic_listview = find_uicomponent(core:get_ui_root(), "character_details_panel", "character_context_parent", "tab_panels", "skills_subpanel", "listview")
			uic_listview:SetInteractive(false)
		end,
		true
	)
	common.call_context_command("CcoCampaignCharacter", prologue_player_cqi, "Select(false)");
	
	disable_event_type(false, "character_rank_gained")

	cm:callback(function()
		local uic_skill_button = find_uicomponent(core:get_ui_root(), "hud_campaign", "info_panel_holder", "skill_button");

		uim:override("skills_with_button_hidden"):set_allowed(true);
		prologue_tutorial_passed["skills_with_button_hidden"] = true;

		local tour_test_skill_button = scripted_tour:new(
			"test2_tour_skill_button",
			function() 
				uic_listview:SetInteractive(true); 
				core:remove_listener("PanelOpenedCampaignStopScrolling"); 
				
				completely_lock_input(false)
				allow_hotkeys(true)

				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(55, "finished_skills_tutorial", true);

				prologue_intervention_skills:complete(); 
				prologue_load_check = "during_skills"; 
				if selected_skill == false then
					PrologueAddTopicLeader("wh3_prologue_objective_turn_016_01"); 
				end

				core:add_listener(
					"hide_mission_panel",
					"PanelClosedCampaign",
					function(context) 
						return context.string == "character_details_panel" 
					end,
					function()
						prologue_advice_post_battle_move_out_001();
					end,
					false
				);
			end
		);
		
		tour_test_skill_button:set_show_skip_button(false);
		tour_test_skill_button:add_fullscreen_highlight("hud_campaign", "info_panel_holder", "skill_button");
		tour_test_skill_button:set_fullscreen_highlight_padding(0)
				
		tour_test_skill_button:action(
			function() 
				out("starting tour_test_skill_button_action_1") 
				local text_pointer_test_skill_button = text_pointer:new_from_component(
					"test2_text_pointer_skill_button",
					"bottom",
					100,
					uic_skill_button,
					0.5,
					0
				);
				
				text_pointer_test_skill_button:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_skills");
				text_pointer_test_skill_button:set_style("semitransparent");
				text_pointer_test_skill_button:set_topmost(true);
				text_pointer_test_skill_button:set_show_close_button(false);
				text_pointer_test_skill_button:set_label_offset(120, 0);
				text_pointer_test_skill_button:show();
				
				core:add_listener(
					"skill_button_listener",
					"ComponentLClickUp",
					function(context) 
						return context.string == "skill_button" 
					end,
					function()
						text_pointer_test_skill_button:hide();
						completely_lock_input(true)
						core:hide_fullscreen_highlight()
						cm:callback(function() tour_test_skill_button:start("tour_test_skill_button_action_2") end, 2)

						-- Kill enemy army
						local enemy_army_list = cm:model():world():faction_by_key(enemy_faction_name):military_force_list();
						for i = 0, enemy_army_list:num_items() - 1 do
							if enemy_army_list:item_at(i):upkeep() > 0 then
								local enemy_army_cqi = enemy_army_list:item_at(i):general_character():cqi();
								cm:kill_character(enemy_army_cqi, true);
							end
						end

						--local x = cm:model():world():region_manager():region_by_key("wh3_prologue_region_frozen_plains_dervingard"):settlement():logical_position_x();
						--local y = cm:model():world():region_manager():region_by_key("wh3_prologue_region_frozen_plains_dervingard"):settlement():logical_position_y();
						out("CREATING NEW PETRENKO ARMY")
						cm:create_force_with_general(
							enemy_faction_name, 
							"wh_dlc08_nor_inf_marauder_hunters_1,wh_main_nor_mon_chaos_warhounds_0,wh_main_nor_mon_chaos_warhounds_0,wh_main_nor_mon_chaos_warhounds_0,wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_0,wh_dlc08_nor_cav_marauder_horsemasters_0,wh_dlc08_nor_cav_marauder_horsemasters_0,wh_dlc08_nor_inf_marauder_spearman_0,wh_dlc08_nor_inf_marauder_spearman_0,wh_dlc08_nor_inf_marauder_spearman_0,wh_dlc08_nor_inf_marauder_hunters_1",
							"wh3_prologue_region_frozen_plains_dervingard",
							424, 
							242,
							"general",
							"wh3_main_pro_ksl_sergi_0",
							"names_name_1250431856",
							"",
							"names_name_269711447",
							"",
							true,
							function(cqi)
								enemy_army_cqi = cqi;
								out("CREATED ENEMY ARMY")
								PrologueListenerToJoinGarrison();
							end
						);
					end,
					false
				);
				
			end, 0,
			"tour_test_skill_button_action_1"
		)
		
		tour_test_skill_button:action(
			function()
				out("starting tour_test_skill_button_action_2")

				local uic = find_uicomponent(core:get_ui_root(), "character_details_panel", "character_context_parent", "skill_pts_holder", "dy_pts")

				core:hide_fullscreen_highlight()
				core:show_fullscreen_highlight_around_components(0, false, false, uic)

				local tp = text_pointer:new_from_component(
					"tp_scripted_tour",
					"right",
					100,
					uic,
					0,
					0.5
				)	
				tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_skills_2")
				tp:set_style("semitransparent")
				tp:set_topmost(true)
				tp:set_highlight_close_button(0.5)
				tp:set_close_button_callback(function() tour_test_skill_button:start("tour_test_skill_button_action_3") end)
				tp:show()	
			end, 0,
		"tour_test_skill_button_action_2"
		)

		tour_test_skill_button:action(
			function()
				out("starting tour_test_skill_button_action_3")
				local uic = find_uicomponent(core:get_ui_root(), "wh_main_skill_all_lord_battle_inspiring_presence")

				core:hide_fullscreen_highlight();
				core:show_fullscreen_highlight_around_components(0, false, true, uic)
				
				local tp = text_pointer:new_from_component(
					"tp_scripted_tour_2",
					"bottom",
					100,
					uic,
					0.5,
					0
				)	
				tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_skills_3")
				tp:set_style("semitransparent")
				tp:set_topmost(true)
				tp:set_highlight_close_button(0.5)
				tp:set_close_button_callback(function() core:hide_fullscreen_highlight(); tour_test_skill_button:start("tour_test_skill_button_action_4") end)
				tp:show()	
			end, 0,
		"tour_test_skill_button_action_3"
		)

		tour_test_skill_button:action(
			function()
				out("starting tour_test_skill_button_action_4")
				local uic = find_uicomponent(core:get_ui_root(), "module_wh_main_skill_all_lord_battle_inspiring_presence")
				local uic_arrow = find_uicomponent(core:get_ui_root(), "wh_main_skill_all_lord_battle_inspiring_presence", "arrow")

				core:show_fullscreen_highlight_around_components(10, false, true, uic, uic_arrow)

				local tp = text_pointer:new_from_component(
					"tp_scripted_tour_3",
					"bottom",
					100,
					uic,
					0.5,
					0
				)	
				tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_skills_4")
				tp:set_style("semitransparent")
				tp:set_topmost(true)
				tp:set_highlight_close_button(0.5)
				tp:set_close_button_callback(function() core:hide_fullscreen_highlight(); tour_test_skill_button:start("tour_test_skill_button_action_5") end)
				tp:show()	
			end, 0,
		"tour_test_skill_button_action_4"
		)

		tour_test_skill_button:action(
			function()
				out("starting tour_test_skill_button_action_5")
				local uic = find_uicomponent(core:get_ui_root(), "wh3_main_skill_ksl_army_buff_kossars_streltsi")
				local uic_2 = find_uicomponent(core:get_ui_root(), "wh3_main_skill_ksl_army_buff_kossars_streltsi", "level_parent")

				core:show_fullscreen_highlight_around_components(0, false, true, uic)
				
				local tp = text_pointer:new_from_component(
					"tp_scripted_tour_5",
					"top",
					100,
					uic_2,
					0.5,
					1
				)	
				tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_skills_5")
				tp:set_style("semitransparent")
				tp:set_topmost(true)
				tp:set_highlight_close_button(0.5)
				tp:set_close_button_callback(function() core:hide_fullscreen_highlight(); tour_test_skill_button:complete() end)
				tp:show()	
			end, 0,
		"tour_test_skill_button_action_5"
		)
		
		tour_test_skill_button:start("tour_test_skill_button_action_1");  
		cm:callback(function() cm:steal_user_input(false); end, 1);
	 end, 1);

end

--------------------------------------------------------------
----------------------- Technology ---------------------
--------------------------------------------------------------

prologue_intervention_technology = intervention:new(
	"prologue_technology", 														-- string name
	0, 																	-- cost
	function() prologue_technology_intervention() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

prologue_intervention_technology:add_trigger_condition(
	"ScriptEventPrologueTechnology",
	true
);
prologue_intervention_technology:set_should_prevent_saving_game()
prologue_intervention_technology:set_should_lock_ui()

function prologue_technology_intervention()

	cm:steal_user_input(true)
	allow_hotkeys(false)

	-- Unlock technology
	uim:override("technology_with_button_hidden"):set_allowed(true);
	prologue_tutorial_passed["technology_with_button_hidden"] = true;

	cm:whitelist_event_feed_event_type("faction_technology_researchedevent_feed_target_faction");
	
	cm:callback(function()
		-- Allow user input again after stopping it during speech.
		cm:steal_user_input(false)

		local uic_technology_button = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_technology");

		local tour_test_technology = scripted_tour:new(
			"test2_tour_technology",
			function() 
				suppress_end_turn_event("NOT_RESEARCHING_TECH", false)
				PrologueChooseTechnology(false)
				cm:disable_saving_game(false)
				allow_hotkeys(true)
			end
		);
		
		tour_test_technology:set_show_skip_button(false);
		tour_test_technology:add_fullscreen_highlight("hud_campaign", "faction_buttons_docker", "button_technology");
		tour_test_technology:set_fullscreen_highlight_padding(4)
				
		tour_test_technology:action(
			function() 
				out("STARTING AN ACTION 1 IN TOUR 2") 
				local text_pointer_test_technology = text_pointer:new_from_component(
					"test2_text_pointer_technology",
					"bottom",
					100,
					uic_technology_button,
					0.5,
					0
				);
				
				text_pointer_test_technology:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_technology");
				text_pointer_test_technology:set_style("semitransparent");
				text_pointer_test_technology:set_topmost(true);
				text_pointer_test_technology:set_show_close_button(false);
				text_pointer_test_technology:show();

				core:add_listener(
					"technology_button_listener",
					"ComponentLClickUp",
					function(context) 
						return context.string == "button_technology" 
					end,
					function()
						tour_test_technology:complete(); 
						core:remove_listener("technology_button_listener");
						prologue_intervention_technology:complete();
						text_pointer_test_technology:hide();

						core:add_listener(
							"PanelClosedCampaign_TechnologyPanel",
							"PanelClosedCampaign",
							function(context) 
								return context.string == "technology_panel" 
							end,
							function()
								if prologue_trial_mission == "mansion_of_eyes" then
									PrologueMansionOfEyes();
									prologue_trial_mission = "";
								elseif prologue_trial_mission == "tribal" then
									PrologueTribalMission();
									prologue_trial_mission = "";
								else
									cm:contextual_vo_enabled(true);
								end
							end,
							false
						);
					end,
					false
				);

			end,
			0
		);
		tour_test_technology:start();
	end, 0.5);
end

--------------------------------------------------------------
----------------------- Unit recruit ---------------------
--------------------------------------------------------------

prologue_intervention_unit_recruit = intervention:new(
	"prologue_unit_recruit", 														-- string name
	0, 																	-- cost
	function() prologue_unit_recruit_intervention() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

prologue_intervention_unit_recruit:add_trigger_condition(
	"ScriptEventPrologueUnitRecruit",
	true
);
prologue_intervention_unit_recruit:set_should_prevent_saving_game()
prologue_intervention_unit_recruit:set_wait_for_fullscreen_panel_dismissed(false)

function prologue_unit_recruit_intervention()
	
	-- This is needed to prevent soft-lock.
	--CampaignUI.ClearSelection();
	--common.call_context_command("CcoCampaignCharacter", prologue_player_cqi, "Select(false)");
	
	cm:steal_user_input(true);
	allow_hotkeys(false)

	cm:callback(function()

		local uic_button_recruit = find_uicomponent(core:get_ui_root(), "hud_center", "small_bar", "button_group_army", "button_recruitment");

		local wmp_prologue_recruit = windowed_movie_player:new_from_advisor("prologue_test_movie_recruit", "warhammer3/prologue/kislev_tutorial_03", 1);
		
		steal_input_completely_on_event(true, "PanelOpenedCampaign", function(context) return context.string == "units_panel" end , 0.01, "PanelOpenedCampaignStealEscRecruit", "PanelOpenedCampaignStealUserInputRecruit", prologue_intervention_unit_recruit)
		
		tour_test_button_recruit = scripted_tour:new(
			"test2_tour",
			function() 
				cm:steal_user_input(true)
				cm:callback(
					function()
						tour_test_button_recruit_2:add_fullscreen_highlight("units_panel", "main_units_panel", "recruitment_docker", "recruitment_options", "recruitment_listbox", "global", "unit_list", "listview", "list_clip", "list_box", "wh3_main_ksl_inf_kossars_tutorial_1_recruitable");
						tour_test_button_recruit_2:start("tour_test_button_recruit_2_action_1")
					end,
					1.5
				)
			end
		);

		tour_test_button_recruit_2 = scripted_tour:new(
			"test2_tour_2",
			function() 
				cm:callback(
					function()
						tour_test_button_recruit_3:add_fullscreen_highlight("units_panel", "main_units_panel", "recruitment_docker", "recruitment_options", "recruitment_listbox", "recruitment_cap", "capacity_listview");
						tour_test_button_recruit_3:start("tour_test_button_recruit_3_action_1")
					end,
					0.5
				)
			end
		);

		tour_test_button_recruit_3 = scripted_tour:new(
			"test2_tour_3",
			function() 
				completely_lock_input(false)
				allow_hotkeys(true)

				prologue_load_check = "after_recruit_button";
				
				cm:set_objective("wh3_prologue_objective_turn_008_01", 0, 3);

				prologue_check_progression["st_recruitment"] = true

				wmp_prologue_recruit:set_width(300);
				wmp_prologue_recruit:show();

				SetUpRecruitLingeringCallback();

				core:add_listener(
					"End_recruit_movie",
					"FactionTurnEnd",
					true,
					function()
						wmp_prologue_recruit:hide();
					end,
					false
				);

			end
		);
		
		tour_test_button_recruit:set_show_skip_button(false);
		tour_test_button_recruit_2:set_show_skip_button(false);
		tour_test_button_recruit_3:set_show_skip_button(false);
		tour_test_button_recruit:add_fullscreen_highlight("hud_center", "small_bar", "button_group_army", "button_recruitment");
				
		tour_test_button_recruit:action(
			function() 
				out("STARTING AN ACTION 1 IN TOUR 2") 
				local text_pointer_test_button_recruit = text_pointer:new_from_component(
					"test2_text_pointer_button_recruit",
					"bottom",
					100,
					uic_button_recruit,
					0.5,
					0
				);
				
				text_pointer_test_button_recruit:add_component_text("text", "ui_text_replacements_localised_text_prologue_text_pointer_unit_recruitment_1");
				text_pointer_test_button_recruit:set_style("semitransparent");
				text_pointer_test_button_recruit:set_topmost(true);
				text_pointer_test_button_recruit:set_show_close_button(false);
				text_pointer_test_button_recruit:show();
				uic_button_recruit:StartPulseHighlight(6, "active")

				core:add_listener(
					"recruit_button_listener",
					"ComponentLClickUp",
					function(context) 
						return context.string == "button_recruitment" 
					end,
					function() 
						uic_button_recruit:StopPulseHighlight("active")

						tour_test_button_recruit:complete(); 
						core:remove_listener("recruit_button_listener");
						text_pointer_test_button_recruit:hide();
						--Metric check (step_number, step_name, skippable)
						cm:trigger_prologue_step_metrics_hit(44, "finished_recruitment_tutorial", true);
					end,
					false
				);
				
			end,
			0
		);

		tour_test_button_recruit_2:action(
			function() 
				out("STARTING AN ACTION 1 IN tour_test_button_recruit_2") 

				local uic_unit = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel", "recruitment_docker", "recruitment_options", "recruitment_listbox", "global", "unit_list", "listview", "list_clip", "list_box", "wh3_main_ksl_inf_kossars_tutorial_1_recruitable")
				local text_pointer_test_button_recruit = text_pointer:new_from_component(
					"test2_text_pointer_button_recruit",
					"right",
					100,
					uic_unit,
					0,
					0.5
				);
				
				text_pointer_test_button_recruit:add_component_text("text", "ui_text_replacements_localised_text_prologue_text_pointer_unit_recruitment_2");
				text_pointer_test_button_recruit:set_style("semitransparent");
				text_pointer_test_button_recruit:set_topmost(true);
				text_pointer_test_button_recruit:set_show_close_button(true)
				text_pointer_test_button_recruit:show();
				text_pointer_test_button_recruit:set_close_button_callback(function() core:hide_fullscreen_highlight(); cm:callback(function() tour_test_button_recruit_2:start("tour_test_button_recruit_2_action_2") end, 0.5) end)
		
			end,
			0,
			"tour_test_button_recruit_2_action_1"
		);

		tour_test_button_recruit_2:action(
			function() 
				out("STARTING AN ACTION 2 IN tour_test_button_recruit_2")

				local uic_RecruitmentCost = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel", "recruitment_docker", "recruitment_options", "recruitment_listbox", "global", "unit_list", "listview", "list_clip", "list_box", "wh3_main_ksl_inf_kossars_tutorial_1_recruitable", "unit_icon", "RecruitmentCost")
				core:hide_fullscreen_highlight()
				core:show_fullscreen_highlight_around_components(0, false, false, uic_RecruitmentCost)
				local text_pointer_test_button_recruit = text_pointer:new_from_component(
					"test2_text_pointer_button_recruit",
					"left",
					100,
					uic_RecruitmentCost,
					1,
					0.5
				);
				
				text_pointer_test_button_recruit:add_component_text("text", "ui_text_replacements_localised_text_prologue_text_pointer_unit_recruitment_4");
				text_pointer_test_button_recruit:set_style("semitransparent");
				text_pointer_test_button_recruit:set_topmost(true);
				text_pointer_test_button_recruit:set_show_close_button(true);
				text_pointer_test_button_recruit:show();
				text_pointer_test_button_recruit:set_close_button_callback(function() core:hide_fullscreen_highlight(); cm:callback(function() tour_test_button_recruit_2:start("tour_test_button_recruit_2_action_3") end, 0.5) end)
			end,
			0,
			"tour_test_button_recruit_2_action_2"
		);

		tour_test_button_recruit_2:action(
			function() 
				out("STARTING AN ACTION 3 IN tour_test_button_recruit_2") 
				local uic_UpkeepCost = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel", "recruitment_docker", "recruitment_options", "recruitment_listbox", "global", "unit_list", "listview", "list_clip", "list_box", "wh3_main_ksl_inf_kossars_tutorial_1_recruitable", "unit_icon", "UpkeepCost")
				core:hide_fullscreen_highlight()
				core:show_fullscreen_highlight_around_components(0, false, false, uic_UpkeepCost)
				local text_pointer_test_button_recruit = text_pointer:new_from_component(
					"test2_text_pointer_button_recruit",
					"left",
					100,
					uic_UpkeepCost,
					1,
					0.5
				);
				
				text_pointer_test_button_recruit:add_component_text("text", "ui_text_replacements_localised_text_prologue_text_pointer_unit_recruitment_5");
				text_pointer_test_button_recruit:set_style("semitransparent");
				text_pointer_test_button_recruit:set_topmost(true);
				text_pointer_test_button_recruit:set_show_close_button(true);
				text_pointer_test_button_recruit:show();
				text_pointer_test_button_recruit:set_close_button_callback(function() tour_test_button_recruit_2:complete(); end)
		
			end,
			0,
			"tour_test_button_recruit_2_action_3"
		);

		tour_test_button_recruit_3:action(
			function() 
				out("STARTING AN ACTION 1 IN tour_test_button_recruit_3") 
				local recruitment_cap = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel", "recruitment_docker", "recruitment_options", "recruitment_listbox", "recruitment_cap", "capacity_listview")
				local text_pointer_test_button_recruit = text_pointer:new_from_component(
					"test2_text_pointer_button_recruit",
					"bottom",
					100,
					recruitment_cap,
					0.5,
					0
				);
				
				text_pointer_test_button_recruit:add_component_text("text", "ui_text_replacements_localised_text_prologue_text_pointer_unit_recruitment_3");
				text_pointer_test_button_recruit:set_style("semitransparent");
				text_pointer_test_button_recruit:set_topmost(true);
				text_pointer_test_button_recruit:set_show_close_button(true);
				text_pointer_test_button_recruit:show();
				text_pointer_test_button_recruit:set_close_button_callback(function() tour_test_button_recruit_3:complete(); prologue_intervention_unit_recruit:complete(); end)
		
			end,
			0,
			"tour_test_button_recruit_3_action_1"
		);
		tour_test_button_recruit:start();
		cm:callback(function() cm:steal_user_input(false); end, 1);
	end, 1)

end


--------------------------------------------------------------
----------------------- Units panel ---------------------
--------------------------------------------------------------

prologue_intervention_units_panel = intervention:new(
	"prologue_units_panel", 														-- string name
	0, 																	-- cost
	function() prologue_units_panel_intervention() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

prologue_intervention_units_panel:add_trigger_condition(
	"ScriptEventPrologueUnitsPanel",
	true
);
prologue_intervention_units_panel:set_should_prevent_saving_game()

function prologue_units_panel_intervention()

	cm:contextual_vo_enabled(false);

	-- Setup tour
	local tour_test_units_panel = scripted_tour:new(
		"test2_tour",
		function() 
			core:trigger_event("ScriptEventPrologueUnitRecruit"); 

			-- Unlock the bottom bar for the units panel
			uim:override("units_panel_small_bar_buttons"):set_allowed(true);
			prologue_tutorial_passed["units_panel_small_bar_buttons"] = true;
			uim:override("units_panel_recruit_with_button_hidden"):set_allowed(true);
			prologue_tutorial_passed["units_panel_recruit_with_button_hidden"] = true;
			uim:override("units_panel_docker"):set_allowed(true);
			prologue_tutorial_passed["units_panel_docker"] = true;
		end
	);
	tour_test_units_panel:set_show_skip_button(false);

	tour_test_units_panel:action(
		function() 
			local uic_units_panel = find_uicomponent(core:get_ui_root(), "units_panel");
			local uic_units_panel_button = find_uicomponent(core:get_ui_root(), "units_panel", "button_focus");
			local uic_main_units_panel = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel")

			-- Add fullscreen highlight around panel.
			core:show_fullscreen_highlight_around_components(5, false, false, uic_main_units_panel)

			cm:steal_user_input(false);

			out("STARTING AN ACTION 2 IN TOUR 2") 
			local text_pointer_test_units_panel = text_pointer:new_from_component(
				"test2_text_pointer_units_panel",
				"bottom",
				100,
				uic_units_panel_button,
				0.5,
				0
			);
			
			text_pointer_test_units_panel:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_units_panel");
			text_pointer_test_units_panel:set_style("semitransparent");
			text_pointer_test_units_panel:set_topmost(true);
			text_pointer_test_units_panel:set_close_button_callback(
				function() 
					core:hide_fullscreen_highlight()
					tour_test_units_panel:complete()
					prologue_intervention_units_panel:complete()
					cm:disable_saving_game(true)
					cm:remove_objective("wh3_prologue_objective_turn_001_05")
				end
			)
			text_pointer_test_units_panel:set_highlight_close_button(2);
			text_pointer_test_units_panel:show();
			pulse_uicomponent(uic_units_panel, 2, 6);

		end,
		0,
		"st_action_1"
	)

	tour_test_units_panel:start("st_action_1")
end;

--------------------------------------------------------------
----------------------- Objectives - Missions ---------------------
--------------------------------------------------------------


prologue_intervention_missions = intervention:new(
	"prologue_missions", 														-- string name
	0, 																	-- cost
	function() prologue_missions_intervention() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

prologue_intervention_missions:add_trigger_condition(
	"ScriptEventPrologueMissions",
	true
);
prologue_intervention_missions:set_should_prevent_saving_game()
prologue_intervention_missions:set_wait_for_fullscreen_panel_dismissed(false)

function prologue_missions_intervention()

	allow_hotkeys(false)
	cm:contextual_vo_enabled(false);

	cm:disable_shortcut("button_missions", "show_objectives", true)
	prologue_tutorial_passed["missions_with_button_hidden"] = true;
	uim:override("missions_with_button_hidden"):set_allowed(true);

	--Show the pinned mission, this was hidden before to prevent a soft lock so needs to be displayed here again
	local mission_list = find_uicomponent(core:get_ui_root(), "hud_campaign", "mission_list");
	if mission_list then
		mission_list:SetVisible(true);
	end

	steal_input_completely_on_event(true, "PanelOpenedCampaign", function(context) return context.string == "objectives_screen" end , 0.01, "PanelOpenedCampaignStealEscMissions", "PanelOpenedCampaignStealUserInputMissions")

	local uic_button_mission = find_uicomponent(core:get_ui_root(), "faction_buttons_docker");
	local uic_button_mission_highlight = find_uicomponent(core:get_ui_root(), "faction_buttons_docker", "button_missions");
			
	local tour_test_mission_button = scripted_tour:new(
		"test2_tour",
		function() 
			cm:steal_user_input(true); 
			cm:callback(function()  
				core:trigger_event("ScriptEventPrologueHelpButton");
			end, 1
		)

		core:add_listener(
				"PanelClosedCampaign_ObjectivesScreenRemoveHighlight",
				"PanelClosedCampaign",
				function(context) return context.string == "objectives_screen" end,
				function()
					allow_hotkeys(true)

					cm:callback(function()
						uic_button_mission_highlight:StopPulseHighlight()
					end,
					1
				)
				end,
				false
			);

		end
	);
	
	tour_test_mission_button:set_show_skip_button(false);
	tour_test_mission_button:add_fullscreen_highlight("faction_buttons_docker", "button_missions");
			
	tour_test_mission_button:action(
		function() 
			out("STARTING AN ACTION 1 IN TOUR 2") 
			local text_pointer_test_mission_button = text_pointer:new_from_component(
				"test2_text_pointer_mission",
				"right",
				100,
				uic_button_mission,
				0,
				0.7
			);
			
			text_pointer_test_mission_button:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_mission_button");
			text_pointer_test_mission_button:set_style("semitransparent");
			text_pointer_test_mission_button:set_topmost(true);
			text_pointer_test_mission_button:set_show_close_button(false);
			text_pointer_test_mission_button:show();
			uic_button_mission_highlight:StartPulseHighlight(6)
			
			core:add_listener(
				"missions_button_listener",
				"ComponentLClickUp",
				function(context) 
					return context.string == "button_missions" 
				end,
				function()
					tour_test_mission_button:complete(); 
					-- pulse_uicomponent(uic_button_mission_highlight, false, 0, false);
					core:remove_listener("missions_button_listener");
					prologue_intervention_missions:complete();
					cm:disable_saving_game(true)
					text_pointer_test_mission_button:hide();

				end,
				false
			);

		end,
		0
	);
	tour_test_mission_button:start();
	
end

--------------------------------------------------------------
----------------------- Help button ---------------------
--------------------------------------------------------------

prologue_intervention_help_button = intervention:new(
	"prologue_help_button", 														-- string name
	0, 																	-- cost
	function() prologue_help_button_intervention() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

prologue_intervention_help_button:add_trigger_condition(
	"ScriptEventPrologueHelpButton",
	true
);
prologue_intervention_help_button:set_should_prevent_saving_game()
prologue_intervention_help_button:set_wait_for_fullscreen_panel_dismissed(false)

function prologue_help_button_intervention()

	local uic_button_help = find_uicomponent(core:get_ui_root(), "button_info");
			
	local tour_test_help_button = scripted_tour:new(
		"test2_tour",
		function() 
			cm:disable_shortcut("button_missions", "show_objectives", false)

			prologue_load_check = "Turn_2_start"
			
			cm:replenish_action_points("faction:"..prologue_player_faction..",forename:1643960929", 0.6)

			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(9, "finished_missions_tutorial", true);
			
			core:add_listener(
				"prologue_after_mission_unlock",
				"PanelClosedCampaign",
				function(context) return context.string == "objectives_screen" end,
				function()
					cm:disable_saving_game(false)
					prologue_advice_turn_two_show_objective();	
				end,
				false
			);
		end
	);
	
	tour_test_help_button:set_show_skip_button(false);
	tour_test_help_button:add_fullscreen_highlight("objectives_screen", "button_info");
	tour_test_help_button:set_fullscreen_highlight_padding(7)
			
	tour_test_help_button:action(
		function() 
			out("STARTING AN ACTION 1 IN TOUR 2") 
			local text_pointer_test_help_button = text_pointer:new_from_component(
				"test2_text_pointer_help",
				"bottom",
				100,
				uic_button_help,
				0.5,
				0
			);
			
			cm:steal_user_input(false); 
			text_pointer_test_help_button:add_component_text("text", "ui_text_replacements_localised_text_prologue_text_pointer_help_button");
			text_pointer_test_help_button:set_style("semitransparent");
			text_pointer_test_help_button:set_topmost(true);
			text_pointer_test_help_button:set_show_close_button(false);
			text_pointer_test_help_button:show();
			pulse_uicomponent(uic_button_help, true, 2, false)
			
			steal_input_completely_on_event(true, "ComponentLClickUp", function(context) return context.string == "button_info" end , 0.01, "ComponentLClickUpStealEscMissions", "ComponentLClickUpStealUserInputMissions")
			
			core:add_listener(
				"help_button_listener",
				"ComponentLClickUp",
				function(context) 
					return context.string == "button_info" 
				end,
				function() 
					tour_test_help_button:complete(); 
					pulse_uicomponent(uic_button_help, false, 0, false);
					core:remove_listener("help_button_listener");
					prologue_intervention_help_button:complete();
					cm:disable_saving_game(true)
					text_pointer_test_help_button:hide();
				end,
				false
			);

		end,
		0
	);
	

	tour_test_help_button:start();
end


--------------------------------------------------------------
----------------------- Magic Items - sword ability ---------------------
--------------------------------------------------------------

prologue_intervention_sword_ability = intervention:new(
	"prologue_sword_ability", 														-- string name
	0, 																	-- cost
	function() prologue_sword_ability_intervention() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

prologue_intervention_sword_ability:add_trigger_condition(
	"ScriptEventPrologueSwordAbility",
	true
);
prologue_intervention_sword_ability:set_should_prevent_saving_game()

function prologue_sword_ability_intervention()

	common.call_context_command("CcoCampaignCharacter", prologue_player_cqi, "Select(false)");
	completely_lock_input(true)

	cm:callback(function()

		local uic_sword_item = find_uicomponent(core:get_ui_root(), "info_panel_holder", "CharacterInfoPopup", "equipment", "item_1_parent");
				
		local tour_test_sword_ability = scripted_tour:new(
			"test2_tour",
			function() 
				prologue_advice_at_dervingard_001();
				cm:steal_escape_key(false);
				completely_lock_input(false)
				--Metric check (step_number, step_name, skippable)
				cm:trigger_prologue_step_metrics_hit(68, "finished_item_tutorial", true);
			end
		);
		
		tour_test_sword_ability:set_show_skip_button(false);
		tour_test_sword_ability:add_fullscreen_highlight("info_panel_holder", "CharacterInfoPopup", "equipment", "item_1_parent");
				
		tour_test_sword_ability:action(
			function() 
				out("STARTING AN ACTION 1 IN TOUR 2") 
				local text_pointer_test_sword_ability = text_pointer:new_from_component(
					"test2_text_pointer_sword_ability",
					"bottom",
					100,
					uic_sword_item,
					0.5,
					0
				);
				
				text_pointer_test_sword_ability:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_traitors_sword");
				text_pointer_test_sword_ability:set_style("semitransparent");
				text_pointer_test_sword_ability:set_topmost(true);
				text_pointer_test_sword_ability:set_label_offset(50, 0);
				text_pointer_test_sword_ability:set_close_button_callback(function()  
					tour_test_sword_ability:complete(); 
					prologue_intervention_sword_ability:complete(); 
					cm:disable_saving_game(true)
					pulse_uicomponent(uic_sword_item, false, 0, false);
					
				end);
				text_pointer_test_sword_ability:set_highlight_close_button(2);
				text_pointer_test_sword_ability:show();
				pulse_uicomponent(uic_sword_item, 2, 6);
				
			end,
			0
		);
		tour_test_sword_ability:start();
		cm:callback(function() cm:steal_user_input(false); cm:steal_escape_key(true); end, 1);
	end, 1)

end

---------------------------------------------------------------------------
----------------------- Characters button / Lords & Heroes ---------------------
-----------------------------------------------------------------------------

prologue_intervention_characters = intervention:new(
	"prologue_characters", 														-- string name
	0, 																	-- cost
	function() prologue_characters_intervention() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

prologue_intervention_characters:add_trigger_condition(
	"ScriptEventPrologueCharacters",
	true
);
prologue_intervention_characters:set_should_prevent_saving_game()
prologue_intervention_characters:set_should_lock_ui()

function prologue_characters_intervention()

	prologue_tutorial_passed["lords_with_button_hidden"] = true;
	uim:override("lords_with_button_hidden"):set_allowed(true);
	allow_hotkeys(false)
	
	local uic_button_characters = find_uicomponent(core:get_ui_root(), "hud_campaign", "bar_small_top", "tab_units");

	-- Highlight component and add text pointer to it.
	core:show_fullscreen_highlight_around_components(5, false, true, uic_button_characters)

	-- Set events button to not interactive.
	local uic_tab_events = find_uicomponent(core:get_ui_root(), "hud_campaign", "bar_small_top", "tab_events");
	uic_tab_events:SetInteractive(false)

	local text_pointer_test_characters_button = text_pointer:new_from_component(
		"test2_text_pointer_characters",
		"right",
		100,
		uic_button_characters,
		0,
		0.7
	);
			
	text_pointer_test_characters_button:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_characters_button");
	text_pointer_test_characters_button:set_style("semitransparent");
	text_pointer_test_characters_button:set_topmost(true);
	text_pointer_test_characters_button:set_show_close_button(false);
	text_pointer_test_characters_button:set_label_offset(0, 30);
	text_pointer_test_characters_button:show();
	uic_button_characters:StartPulseHighlight(6, "active")

	core:add_listener(
		"characters_button_listener",
		"ComponentLClickUp",
		function(context) return context.string == "tab_units" end,
		function()
			-- Cleanup text pointer and fullscreen highlight.
			text_pointer_test_characters_button:hide();
			core:hide_fullscreen_highlight()

			-- Stop pulse.
			uic_button_characters:StopPulseHighlight("active")

			-- Add removal listener.
			core:add_listener(
				"FactionTurnStart_remove_recruit_listener",
				"FactionTurnStart",
				true,
				function() core:remove_listener("recruitment_issued_prologue_after_lord") end,
				true
			)

			allow_hotkeys(true)
			prologue_intervention_characters:complete();

			uim:override("end_turn"):set_allowed(true);

			cm:contextual_vo_enabled(true);
			
			cm:callback(function() uic_tab_events:SetInteractive(true) end, 0.1)
		end,
		false
	)
end

---------------------------------------------------------------------------
----------------------- Settlements button / Regions ---------------------
-----------------------------------------------------------------------------

prologue_intervention_settlements = intervention:new(
	"prologue_settlements", 														-- string name
	0, 																	-- cost
	function() prologue_settlements_intervention() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

prologue_intervention_settlements:add_trigger_condition(
	"ScriptEventPrologueSettlements",
	true
);
prologue_intervention_settlements:set_should_prevent_saving_game()

function prologue_settlements_intervention()

	prologue_tutorial_passed["regions_with_button_hidden"] = true;
	uim:override("regions_with_button_hidden"):set_allowed(true);

	allow_hotkeys(false)
	cm:contextual_vo_enabled(false);

	local uic_button_settlements = find_uicomponent(core:get_ui_root(), "hud_campaign", "bar_small_top", "tab_regions");
			
	local tour_test_settlements_button = scripted_tour:new(
		"test2_tour_settlements",
		function() 
			allow_hotkeys(true)

			core:add_listener(
				"ComponentLClickUpTabRemoveListenerSettlements",
				"ComponentLClickUp",
				true,
				function(context)
					if context.string == "tab_units" or context.string == "tab_events" or context.string == "tab_factions" or context.string == "tab_regions" then
						cm:callback(function()
							uic_button_settlements:StopPulseHighlight()
						end,
						0.25)
						core:remove_listener("ComponentLClickUpTabRemoveListenerSettlements")
						cm:contextual_vo_enabled(true);
					end
				end,
				true
			);
			core:remove_listener("FactionTurnStart_OpenWorld_settlements")
		end
	);
	
	
	tour_test_settlements_button:set_show_skip_button(false);
	tour_test_settlements_button:add_fullscreen_highlight("hud_campaign", "bar_small_top", "tab_regions");
	tour_test_settlements_button:set_fullscreen_highlight_padding(0)

	tour_test_settlements_button:action(
		function() 
			out("STARTING AN ACTION 1 IN TOUR 2") 
			local text_pointer_test_settlements_button = text_pointer:new_from_component(
				"test2_text_pointer_characters",
				"right",
				100,
				uic_button_settlements,
				0,
				0.7
			);
			
			text_pointer_test_settlements_button:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_regions_button");
			text_pointer_test_settlements_button:set_style("semitransparent");
			text_pointer_test_settlements_button:set_topmost(true);
			text_pointer_test_settlements_button:set_show_close_button(false);
			text_pointer_test_settlements_button:set_label_offset(0, 40);
			text_pointer_test_settlements_button:show();
			uic_button_settlements:StartPulseHighlight(6)
			
			core:add_listener(
				"settlements_button_listener",
				"ComponentLClickUp",
				function(context) 
					return context.string == "tab_regions" 
				end,
				function()
					tour_test_settlements_button:complete(); 
					core:remove_listener("settlements_button_listener");
					prologue_intervention_settlements:complete();
					text_pointer_test_settlements_button:hide();
				end,
				false
			);

		end,
		0
	);
	tour_test_settlements_button:start();
	
end


---------------------------------------------------------------------------
----------------------- Quest battle marker ---------------------
-----------------------------------------------------------------------------

prologue_intervention_quest_marker = intervention:new(
	"prologue_quest_marker", 														-- string name
	0, 																	-- cost
	function() prologue_quest_marker_intervention() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

prologue_intervention_quest_marker:add_trigger_condition(
	"ScriptEventPrologueQuestMarker",
	true
);
prologue_intervention_quest_marker:set_should_prevent_saving_game()

function prologue_quest_marker_intervention()
			

	CampaignUI.ClearSelection();

	cm:make_region_visible_in_shroud(prologue_player_faction, "wh3_prologue_region_temp_3");

	-- Add a cindy scene camera
	local cutscene_quest_marker = campaign_cutscene:new_from_cindyscene(
		"prologue_quest_marker_tutorial",
		function()
			prologue_advice_towards_the_maze_001();
			uim:override("campaign_flags"):set_allowed(true);
			prologue_intervention_quest_marker:complete()
			cm:disable_saving_game(true)
		end,
		"questbattlemarker_01", 
		0, 
		1
	);
		
	cutscene_quest_marker:set_disable_settlement_labels(true);
	cutscene_quest_marker:set_dismiss_advice_on_end(false);
	cutscene_quest_marker:set_restore_shroud(false);
			
	cutscene_quest_marker:action(
		function()
			uim:override("campaign_flags"):set_allowed(false);
			cm:trigger_2d_ui_sound("UI_CAM_PRO_Story_Stinger", 0);
		end,
		0
	);
		
	cutscene_quest_marker:action(
		function()
			
		end,
		1
	);
	
	cutscene_quest_marker:start();
	
end


---------------------------------------------------------------------------
----------------------- Post battle options ---------------------
-----------------------------------------------------------------------------

prologue_intervention_post_battle_options = intervention:new(
	"prologue_post_battle_options", 														-- string name
	0, 																	-- cost
	function() prologue_post_battle_options_intervention() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);


prologue_intervention_post_battle_options:set_wait_for_battle_complete(false);
prologue_intervention_post_battle_options:set_should_prevent_saving_game()

prologue_intervention_post_battle_options:set_wait_for_fullscreen_panel_dismissed(false)
prologue_intervention_post_battle_options:add_trigger_condition(
	"ScriptEventProloguePostBattleOptions",
	true
);

function prologue_post_battle_options_intervention()

	-- Unlock panel
	uim:override("postbattle_middle_panel"):set_allowed(true);
	prologue_tutorial_passed["postbattle_middle_panel"] = true;

	cm:steal_user_input(true);

	cm:callback(function()
		local uic_button_bar = find_uicomponent(core:get_ui_root(), "battle_results", "button_set_win");

		local uic_post_battle_buttons = find_uicomponent(core:get_ui_root(), "battle_results");

		if uic_post_battle_buttons then
			uic_post_battle_buttons:SetVisible(true);
		end

		local tour_test_post_battle_options = scripted_tour:new(
			"test2_tour_post_battle_options",
			function()  
				core:add_listener(
					"BattleCompletedCameraMove_post",
					"BattleCompletedCameraMove",
					true,
					function()
				
						-- check what needs to be done after a battle
						cm:callback(function() PrologueAfterPostBattle(); end, 5);

						--Metric check (step_number, step_name, skippable)
						cm:trigger_prologue_step_metrics_hit(42, "finished_post_battle_tutorial", true);
					end,
					false
				);
	
			end
		);
		
		tour_test_post_battle_options:set_show_skip_button(false);
		tour_test_post_battle_options:add_fullscreen_highlight("battle_results", "button_set_win");
				
		tour_test_post_battle_options:action(
			function() 
				out("STARTING AN ACTION 1 IN TOUR 2") 
				local text_pointer_test_post_battle_options = text_pointer:new_from_component(
					"test2_text_pointer_post_battle_options",
					"bottom",
					100,
					uic_button_bar,
					0.5,
					0
				);
				
				text_pointer_test_post_battle_options:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_post_battle_options");
				text_pointer_test_post_battle_options:set_style("semitransparent");
				text_pointer_test_post_battle_options:set_topmost(true);
				text_pointer_test_post_battle_options:set_show_close_button(false);
				text_pointer_test_post_battle_options:show();

				

				core:add_listener(
					"post_battle_options_listener",
					"ComponentLClickUp",
					function(context) 
					return context.string == "button_captive_option_release" or context.string == "button_captive_option_kill" or context.string == "button_captive_option_enslave" end,
					function()
						core:remove_listener("post_battle_options_listener");
						core:hide_fullscreen_highlight(); 
						tour_test_post_battle_options:complete(); 
						prologue_intervention_post_battle_options:complete(); 
						cm:disable_saving_game(true)
					end,
					false
				);

			end,
			0
		);
		tour_test_post_battle_options:start();  
		cm:callback(function() cm:steal_user_input(false); end, 1);
	 end, 1.5);
end

--------------------------------------------------------------
----------------------- End turn notification ---------------------
--------------------------------------------------------------

prologue_intervention_end_turn_notification = intervention:new(
	"prologue_end_turn_notification", 										-- string name
	0, 																		-- cost
	function() prologue_end_turn_notification_intervention() end,			-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

prologue_intervention_end_turn_notification:add_trigger_condition(
	"ScriptEventPrologueEndTurnNotification",
	true
);
prologue_intervention_end_turn_notification:set_should_prevent_saving_game()
prologue_intervention_end_turn_notification:set_should_lock_ui()

function prologue_end_turn_notification_intervention()

	local uic_button_group_manager
	local uic_button_notification

	cm:contextual_vo_enabled(false);

	cm:steal_user_input(true)
	uim:override("end_turn_notification"):set_allowed(true);
	prologue_tutorial_passed["end_turn_notification"] = true;
	uim:override("end_turn_previous_with_button_hidden"):set_allowed(true);
	prologue_tutorial_passed["end_turn_previous_with_button_hidden"] = true;
	uim:override("end_turn_next_with_button_hidden"):set_allowed(true);
	prologue_tutorial_passed["end_turn_next_with_button_hidden"] = true;
	uim:override("end_turn_skip_with_button_hidden"):set_allowed(true);
	prologue_tutorial_passed["end_turn_skip_with_button_hidden"] = true;
	local uic_notification = find_uicomponent(core:get_ui_root(), "end_turn_docker", "dy_notification");
	set_component_active_with_parent(true, uic_notification, "button_notification");
	uic_notification:SetVisible(true);

	-- Un-suppress end turn warnings.
	suppress_end_turn_event("ECONOMICS_PROJECTED_NEGATIVE", false)
	suppress_end_turn_event("ECONOMICS_PROJECTED_NEGATIVE_WITH_DIPLOMATIC_EXPENDITURE", false)
	suppress_end_turn_event("DAMAGED_BUILDING", false)
	suppress_end_turn_event("ARMY_AP_AVAILABLE", false)
	suppress_end_turn_event("CHARACTER_UPGRADE_AVAILABLE", false)
	suppress_end_turn_event("GARRISONED_ARMY_AP_AVAILABLE", false)
	suppress_end_turn_event("HERO_AP_AVAILABLE", false)
	suppress_end_turn_event("SIEGE_NO_EQUIPMENT", false)


	local tour_test_end_turn_notification_3 = scripted_tour:new("tour_test_end_turn_notification_3",
		function() 
			cm:steal_user_input(false) 
			uim:override("end_turn"):set_allowed(true);
			prologue_intervention_end_turn_notification:complete()
			cm:contextual_vo_enabled(true);
			--Metric check (step_number, step_name, skippable)
			cm:trigger_prologue_step_metrics_hit(79, "finished_end_turn_notification_tutorial", true);
		end
	)

	local tour_test_end_turn_notification_2 = scripted_tour:new("tour_test_end_turn_notification_2",
		function() 
			cm:callback(function() tour_test_end_turn_notification_3:start("tour_test_end_turn_notification_3") end, 0.5)
		end
	)


	tour_test_end_turn_notification_2:action(
		function()
			out("STARTING_SCRIPTED_TOUR_END_TURN_NOTIFICATION_2")

			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"bottom",
				100,
				uic_button_notification,
				0.5,
				0
			)	
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_end_turn_notification_2")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_label_offset(-40, 0)
			tp:set_highlight_close_button(0.5)
			tp:set_close_button_callback(function() tour_test_end_turn_notification_2:complete() end)
			tp:show()		
		end, 0,
	"tour_test_end_turn_notification_2"
	)

	tour_test_end_turn_notification_3:action(
		function()
			out("STARTING_SCRIPTED_TOUR_END_TURN_NOTIFICATION_3")

			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"bottom",
				100,
				uic_button_group_manager,
				0.5,
				-0.2
			)	
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_end_turn_notification_3")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_label_offset(-40, 0)
			tp:set_highlight_close_button(0.5)
			tp:set_close_button_callback(function() tour_test_end_turn_notification_3:complete() end)
			tp:show()		
		end, 0,
	"tour_test_end_turn_notification_3"
	)

	cm:callback(
		function ()		
			local tour_started

			uic_button_group_manager = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_group_management")
			uic_button_notification = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "end_turn_docker", "notification_frame", "dy_notification", "button_notification")
			
			if uic_button_group_manager and uic_button_group_manager:Visible(true) and
			uic_button_notification and uic_button_notification:Visible(true) then
				tour_started = true
			end

			if tour_started then
				tour_test_end_turn_notification_3:add_fullscreen_highlight("hud_campaign", "faction_buttons_docker", "button_group_management")
				tour_test_end_turn_notification_2:add_fullscreen_highlight("hud_campaign", "faction_buttons_docker", "end_turn_docker", "notification_frame", "dy_notification", "button_notification")
				tour_test_end_turn_notification_3:set_show_skip_button(false)
				tour_test_end_turn_notification_2:set_show_skip_button(false)
				tour_test_end_turn_notification_2:start("tour_test_end_turn_notification_2")
			else
				cm:steal_user_input(false)
				prologue_intervention_end_turn_notification:cancel()
			end
		end,
	0.5)
end

--------------------------------------------------------------
----------------------- Diplomacy ---------------------
--------------------------------------------------------------


prologue_intervention_diplomacy = intervention:new(
	"prologue_diplomacy", 														-- string name
	0, 																	-- cost
	function() prologue_diplomacy_intervention() end,								-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 											-- show debug output
);

prologue_intervention_diplomacy:add_trigger_condition(
	"ScriptEventPrologueDiplomacy",
	true
);
prologue_intervention_diplomacy:set_should_prevent_saving_game()
prologue_intervention_diplomacy:set_must_trigger(true)

function prologue_diplomacy_intervention()

	allow_hotkeys(false)
	cm:contextual_vo_enabled(false);

	prologue_tutorial_passed["diplomacy_with_button_hidden"] = true;
	uim:override("diplomacy_with_button_hidden"):set_allowed(true);
	cm:enable_all_diplomacy(true);

	steal_input_completely_on_event(true, "PanelOpenedCampaign", function(context) return context.string == "diplomacy_dropdown" end , 0.1, "PanelOpenedCampaignStealEscDiplomacy", "PanelOpenedCampaignStealUserInputDiplomacy")

	PrologueSetUpDiplomacy();

	local uic_button_diplomacy_highlight = find_uicomponent(core:get_ui_root(), "faction_buttons_docker", "button_diplomacy");
	local uic_wh3_prologue_diplomatic_bonus_tribes = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar", "global_effect_list", "wh3_prologue_diplomatic_bonus_tribes")
			
	local tour_test_diplomacy_button = scripted_tour:new(
		"test2_tour"
	)

	local tour_test_diplomacy_button_2 = scripted_tour:new(
		"test_tour_diplomacy",
		function() 
			cm:callback(function() tour_test_diplomacy_button:start() end, 0.5)
		end
	)
	
	tour_test_diplomacy_button:set_show_skip_button(false);
	tour_test_diplomacy_button:add_fullscreen_highlight("faction_buttons_docker", "button_diplomacy");
	tour_test_diplomacy_button_2:add_fullscreen_highlight("hud_campaign", "resources_bar_holder", "resources_bar", "global_effect_list")
	tour_test_diplomacy_button:set_fullscreen_highlight_padding(3)
	tour_test_diplomacy_button_2:set_show_skip_button(false);

	tour_test_diplomacy_button_2:action(
		function() 
			out("STARTING AN ACTION 1 IN TOUR 2") 

			local text_pointer_test_diplomacy_button = text_pointer:new_from_component(
				"test2_text_pointer_diplomacy",
				"top",
				100,
				uic_wh3_prologue_diplomatic_bonus_tribes,
				0.5,
				1
			);
			
			text_pointer_test_diplomacy_button:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_diplomacy_6");
			text_pointer_test_diplomacy_button:set_style("semitransparent");
			text_pointer_test_diplomacy_button:set_topmost(true);
			text_pointer_test_diplomacy_button:set_show_close_button(false);
			text_pointer_test_diplomacy_button:set_close_button_callback(function() cm:callback(function() tour_test_diplomacy_button_2:complete() end, 0.5) end);
			text_pointer_test_diplomacy_button:show();
			uic_button_diplomacy_highlight:StartPulseHighlight(6)
		end,
		0
	)

	tour_test_diplomacy_button:action(
		function() 
			out("STARTING AN ACTION 2 IN TOUR 2") 

			local text_pointer_test_diplomacy_button = text_pointer:new_from_component(
				"test2_text_pointer_diplomacy",
				"right",
				100,
				uic_button_diplomacy_highlight,
				0,
				0.5
			);
			
			text_pointer_test_diplomacy_button:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_diplomacy");
			text_pointer_test_diplomacy_button:set_style("semitransparent");
			text_pointer_test_diplomacy_button:set_topmost(true);
			text_pointer_test_diplomacy_button:set_show_close_button(false);
			text_pointer_test_diplomacy_button:show();
			uic_button_diplomacy_highlight:StartPulseHighlight(6)
			
			core:add_listener(
				"PanelOpenedCampaign_DiplomacyScreen",
				"PanelOpenedCampaign", 
				function(context) return context.string == "diplomacy_dropdown" end,
				function()
					PrologueSecondDiplomacyPart();

					cm:callback(function() uic_button_diplomacy_highlight:StopPulseHighlight() end, 1)
				end, 
				false

			);
		
			core:add_listener(
				"diplomacy_button_listener",
				"ComponentLClickUp",
				function(context) 
					return context.string == "button_diplomacy" 
				end,
				function()
					tour_test_diplomacy_button:complete(); 
					-- pulse_uicomponent(uic_button_diplomacy_highlight, false, 0, false);
					core:remove_listener("diplomacy_button_listener");
					prologue_intervention_diplomacy:complete();
					text_pointer_test_diplomacy_button:hide();

				end,
				false
			);

		end,
		0
	);

	if uic_wh3_prologue_diplomatic_bonus_tribes then
		tour_test_diplomacy_button_2:start()
	else
		tour_test_diplomacy_button:start()
	end	
end


function PrologueSecondDiplomacyPart()
	local uic_diplomacy_list = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown", "faction_panel", "sortable_list_factions", "list_clip");
		
	local intervention_diplomacy_panel = scripted_tour:new(
		"test_intervention_diplomacy_panel",
		function() 
			cm:steal_user_input(false)
			cm:steal_escape_key(false)
			core:remove_listener("PanelOpenedCampaignStealEscDiplomacy")
			core:remove_listener("PanelOpenedCampaignStealUserInputDiplomacy") 
			prologue_advice_unlock_diplomacy_001()

			cm:cai_enable_movement_for_faction("wh3_prologue_blood_keepers");
			cm:cai_enable_movement_for_faction("wh3_prologue_sarthoraels_watchers");
			cm:cai_enable_movement_for_faction("wh3_prologue_the_tahmaks");
			cm:cai_enable_movement_for_faction("wh3_prologue_the_kvelligs");
			cm:cai_enable_movement_for_faction("wh3_prologue_great_eagle_tribe");
			cm:cai_enable_movement_for_faction("wh3_prologue_tong");
			out("FINISHED diplomacy tour")
		end
	);
	
	intervention_diplomacy_panel:set_show_skip_button(false);
			
	intervention_diplomacy_panel:action(
		function() 
			out("STARTING AN ACTION 1 IN TOUR 1") 
			local uic_list_clip = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown", "faction_panel", "sortable_list_factions", "list_clip")
			core:show_fullscreen_highlight_around_components(0, false, false, uic_list_clip)

			local text_pointer_test_2 = text_pointer:new_from_component(
				"test2_text_pointer",
				"bottom",
				100,
				uic_diplomacy_list,
				0.5,
				0
			);
			
			text_pointer_test_2:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_diplomacy_1");
			text_pointer_test_2:set_style("semitransparent");
			text_pointer_test_2:set_topmost(true);
			text_pointer_test_2:set_close_button_callback(function() core:hide_fullscreen_highlight(); cm:callback(function() intervention_diplomacy_panel:start("show_fifth_text_pointer") end, 1) end);
			text_pointer_test_2:set_highlight_close_button(2);
			text_pointer_test_2:show();
			pulse_uicomponent(uic_diplomacy_list, 2, 6);
			
			
		end,
		0
	);

	local uic_attitude = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown", "faction_right_status_panel", "attitude_frame");
	intervention_diplomacy_panel:action(
		function() 
			out("STARTING AN ACTION 2 IN TOUR 1") 
			--text_pointer_test_2:hide();
			
			intervention_diplomacy_panel:show_fullscreen_highlight(false);
			--tour_test_2:add_fullscreen_highlight("character_details_panel", "skills_subpanel");
			core:show_fullscreen_highlight_around_components(0, false, true, uic_attitude);

			local text_pointer_test_3 = text_pointer:new_from_component(
				"test3_text_pointer",
				"right",
				100,
				uic_attitude,
				0,
				0.5
			);

			text_pointer_test_3:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_diplomacy_2");
			text_pointer_test_3:set_style("semitransparent");
			text_pointer_test_3:set_topmost(true);
			text_pointer_test_3:set_close_button_callback(function() core:hide_fullscreen_highlight(); cm:callback(function() intervention_diplomacy_panel:start("show_third_text_pointer") end, 1) end);
			text_pointer_test_3:set_highlight_close_button(2);
			text_pointer_test_3:show();
			
		end,
		0,
		"show_second_text_pointer"
	)
	
	intervention_diplomacy_panel:action(
		function() 
			out("STARTING AN ACTION 5 IN TOUR 1") 
			--text_pointer_test_2:hide();
			local uic_faction_right_status_panel = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown", "faction_right_status_panel")
			local uic_porthole = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown", "faction_right_status_panel", "porthole")
			intervention_diplomacy_panel:show_fullscreen_highlight(false);
			core:show_fullscreen_highlight_around_components(0, false, true, uic_faction_right_status_panel, uic_porthole)

			local text_pointer_test_3 = text_pointer:new_from_component(
				"test3_text_pointer",
				"bottom",
				100,
				uic_porthole,
				0.5,
				0
			);

			text_pointer_test_3:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_diplomacy_5");
			text_pointer_test_3:set_style("semitransparent");
			text_pointer_test_3:set_topmost(true);
			text_pointer_test_3:set_close_button_callback(function() core:hide_fullscreen_highlight(); cm:callback(function() intervention_diplomacy_panel:start("show_second_text_pointer") end, 1) end);
			text_pointer_test_3:set_highlight_close_button(2);
			text_pointer_test_3:show();
			
		end,
		0,
		"show_fifth_text_pointer"
	)

	local uic_initiate_diplomacy = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown", "faction_panel", "faction_panel_bottom", "both_buttongroup", "button_ok");

	intervention_diplomacy_panel:action(
		function() 
			out("STARTING AN ACTION 3 IN TOUR 1") 
		
			core:hide_fullscreen_highlight();
			
			core:show_fullscreen_highlight_around_components(0, false, true, uic_initiate_diplomacy);

			local text_pointer_test_4 = text_pointer:new_from_component(
				"test4_text_pointer",
				"bottom",
				100,
				uic_initiate_diplomacy,
				0.5,
				0
			);

			text_pointer_test_4:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_diplomacy_3");
			text_pointer_test_4:set_style("semitransparent");
			text_pointer_test_4:set_topmost(true);
			text_pointer_test_4:set_close_button_callback(function() core:hide_fullscreen_highlight(); cm:callback(function() intervention_diplomacy_panel:start("show_fourth_text_pointer") end, 0.5) end)
			text_pointer_test_4:set_highlight_close_button(2);
			text_pointer_test_4:show();
			
		end,
		0,
		"show_third_text_pointer"
	);

	intervention_diplomacy_panel:action(
		function() 
			out("STARTING AN ACTION 4 IN TOUR 1") 
		
			core:hide_fullscreen_highlight();
			
			local uic_button_cancel = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown", "faction_panel", "faction_panel_bottom", "both_buttongroup", "button_cancel")
			
			core:show_fullscreen_highlight_around_components(0, false, true, uic_button_cancel);

			local text_pointer_test_4 = text_pointer:new_from_component(
				"test4_text_pointer",
				"bottom",
				100,
				uic_button_cancel,
				0.5,
				0
			);

			text_pointer_test_4:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_diplomacy_4");
			text_pointer_test_4:set_style("semitransparent");
			text_pointer_test_4:set_topmost(true);
			text_pointer_test_4:set_close_button_callback(function() uim:override("end_turn"):set_allowed(false); allow_hotkeys(true); core:hide_fullscreen_highlight(); end_scripted_tour_prologue(intervention_diplomacy_panel, false) end)
			text_pointer_test_4:set_highlight_close_button(2);
			text_pointer_test_4:show();
			
		end,
		0,
		"show_fourth_text_pointer"
	);
	cm:steal_user_input(true)
	cm:callback(function() start_scripted_tour_prologue(intervention_diplomacy_panel) end, 2)
end



---------------------------------------------------------------------------
----------------------- Autoresolve and Retreat ---------------------
-----------------------------------------------------------------------------

prologue_intervention_autoresolve = intervention:new(
	"prologue_autoresolve_options", 									-- string name
	0, 																	-- cost
	function() prologue_autoresolve_intervention() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

prologue_intervention_autoresolve:add_trigger_condition(
	"ScriptEventPrologueAutoresolve",
	true
);
prologue_intervention_autoresolve:set_should_prevent_saving_game()

prologue_intervention_autoresolve:set_wait_for_battle_complete(false);
prologue_intervention_autoresolve:set_wait_for_fullscreen_panel_dismissed(false)


prologue_intervention_autoresolve:set_player_turn_only(false)

function prologue_autoresolve_intervention()

	local uic_button_set = false
	local uic_button_autoresolve = false
	local uic_button_retreat = false
	local siegeBattle = false
	local uic_save_button = false
	
	completely_lock_input(true)
	cm:contextual_vo_enabled(false);

	local tour_test_autoresolve = scripted_tour:new(
		"tour_test_autoresolve",
		function()
			cm:steal_user_input(false)
			prologue_check_progression["fought_first_open_battle"] = true
			prologue_intervention_autoresolve:complete()
			cm:contextual_vo_enabled(true);
		end
	)
	tour_test_autoresolve:set_show_skip_button(false);
				
	tour_test_autoresolve:action(
		function()
			out("STARTING_AUTORESOLVE_TOUR_ACTION_1")
			
			tour_test_autoresolve:show_fullscreen_highlight(true)

			cm:steal_user_input(false);

			local text_pointer_test_autoresolve = text_pointer:new_from_component(
				"text_pointer_test_autoresolve",
				"bottom",
				100,
				uic_button_autoresolve,
				0.5,
				0
			)
			text_pointer_test_autoresolve:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_autoresolve_1")
			text_pointer_test_autoresolve:set_style("semitransparent")
			text_pointer_test_autoresolve:set_topmost(true)
			text_pointer_test_autoresolve:set_highlight_close_button(0.5)
			text_pointer_test_autoresolve:set_close_button_callback(function() cm:callback( function() tour_test_autoresolve:start("tour_test_autoresolve_action_2") end, 0.5) end)
			text_pointer_test_autoresolve:show()		
		end, 0,
	"tour_test_autoresolve_action_1"
	)

	tour_test_autoresolve:action(
		function()
			out("STARTING_AUTORESOLVE_TOUR_ACTION_2")
			
			tour_test_autoresolve:show_fullscreen_highlight(true)

			local text_pointer_test_autoresolve = text_pointer:new_from_component(
				"text_pointer_test_autoresolve",
				"bottom",
				100,
				uic_button_retreat,
				0.5,
				0
			)
			if siegeBattle == true then
				text_pointer_test_autoresolve:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_autoresolve_3")
			else
				text_pointer_test_autoresolve:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_autoresolve_2")
			end
			text_pointer_test_autoresolve:set_style("semitransparent")
			text_pointer_test_autoresolve:set_topmost(true)
			text_pointer_test_autoresolve:set_highlight_close_button(0.5)
			text_pointer_test_autoresolve:set_close_button_callback(function() cm:callback(function() tour_test_autoresolve:start("tour_test_autoresolve_action_3") end, 0.5) end)
			text_pointer_test_autoresolve:show()		
		end, 0,
	"tour_test_autoresolve_action_2"
	)

	tour_test_autoresolve:action(
		function()
			out("STARTING_AUTORESOLVE_TOUR_ACTION_3")
			
			core:hide_fullscreen_highlight()
			core:show_fullscreen_highlight_around_components(0, false, false, uic_save_button)

			local text_pointer_test_autoresolve = text_pointer:new_from_component(
				"text_pointer_test_autoresolve",
				"bottom",
				100,
				uic_save_button,
				0.5,
				0
			)
			text_pointer_test_autoresolve:add_component_text("text", "ui_text_replacements_localised_text_prologue_unlock_feature_autoresolve_4")
			text_pointer_test_autoresolve:set_style("semitransparent")
			text_pointer_test_autoresolve:set_topmost(true)
			text_pointer_test_autoresolve:set_highlight_close_button(0.5)
			text_pointer_test_autoresolve:set_close_button_callback(function() cm:callback( function() tour_test_autoresolve:complete() end, 0.5) end)
			text_pointer_test_autoresolve:show()		
		end, 0,
	"tour_test_autoresolve_action_3"
	)

	 cm:callback(function()
		
		local startedTour = false

		-- Is this a regular battle?
		uic_button_set = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "mid", "battle_deployment", "regular_deployment", "button_set_attack")
		if uic_button_set and uic_button_set:Visible(true) then
			uic_button_autoresolve = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "mid", "battle_deployment", "regular_deployment", "button_set_attack", "button_autoresolve")
			uic_button_retreat = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "mid", "battle_deployment", "regular_deployment", "button_set_attack", "button_retreat")
			uic_save_button = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "mid", "battle_deployment", "regular_deployment", "button_save")

			if uic_button_autoresolve and uic_button_retreat and uic_save_button and uic_button_autoresolve:Visible(true) and uic_button_retreat:Visible(true) and uic_save_button:Visible(true) then
				startedTour = true
				siegeBattle = false
				tour_test_autoresolve:add_fullscreen_highlight("popup_pre_battle", "mid", "battle_deployment", "regular_deployment", "button_set_attack")
				tour_test_autoresolve:start("tour_test_autoresolve_action_1")
			end
		end

		-- Is this a siege battle?
		if startedTour == false then
			uic_button_set = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "mid", "battle_deployment", "regular_deployment", "button_set_siege")
			if uic_button_set and uic_button_set:Visible(true) then
				uic_button_autoresolve = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "mid", "battle_deployment", "regular_deployment", "button_set_siege", "button_autoresolve")
				uic_button_retreat = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "mid", "battle_deployment", "regular_deployment", "button_set_siege", "button_retreat")
				uic_save_button = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "mid", "battle_deployment", "regular_deployment", "button_save")

				if first_siege_just_played == false and uic_button_autoresolve and uic_button_retreat and uic_save_button and uic_button_autoresolve:Visible(true) and uic_button_retreat:Visible(true) and uic_save_button:Visible(true) then
					startedTour = true
					siegeBattle = true
					tour_test_autoresolve:add_fullscreen_highlight("popup_pre_battle", "mid", "battle_deployment", "regular_deployment", "button_set_siege")
					tour_test_autoresolve:start("tour_test_autoresolve_action_1")
				end
			end
		end

		if startedTour == false then
			completely_lock_input(false)
			prologue_intervention_autoresolve:cancel()
		end
		
	end, 0.5
	)
end

-----------------------------------------------------------------------------
-------------------------------- Allegiance ---------------------------------
-----------------------------------------------------------------------------

prologue_intervention_allegiance = intervention:new(
	"prologue_allegiance",
	0,
	function() prologue_allegiance_intervention() end,
	BOOL_INTERVENTIONS_DEBUG
)

prologue_intervention_allegiance:add_trigger_condition(
	"PanelOpenedCampaign",
	function(context)
		return context.string == "panel_war_coordination"
	end
)

prologue_intervention_allegiance:set_wait_for_fullscreen_panel_dismissed(false)
prologue_intervention_allegiance:set_should_prevent_saving_game()
prologue_intervention_allegiance:set_wait_for_battle_complete(false)

function prologue_allegiance_intervention()

	completely_lock_input(true)
	cm:contextual_vo_enabled(false);

	local uic_panel_war_coordination = false
	local uic_favour_frame = false
	local uic_tab_missions = false
	local uic_tab_set_target = false
	local uic_tab_request_army = false
	local uic_tab_outpost = false

	local tour_test_allegiance = scripted_tour:new(
		"tour_test_allegiance",
		function()
			core:hide_fullscreen_highlight()
			completely_lock_input(false)
			prologue_intervention_allegiance:complete()
			cm:contextual_vo_enabled(true);
		end
	)

	tour_test_allegiance:action(
		function()
			out("STARTING_ALLEGIANCE_TOUR_ACTION_1")

			core:hide_fullscreen_highlight()
			core:show_fullscreen_highlight_around_components(0, false, false, uic_panel_war_coordination)

			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"bottom",
				100,
				uic_favour_frame,
				0.5,
				0
			)
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_allegiance_1")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:set_close_button_callback(function() cm:callback(function() tour_test_allegiance:start("tour_test_allegiance_action_2") end, 0.5) end)
			tp:show()	
		end, 0,
	"tour_test_allegiance_action_1"
	)

	tour_test_allegiance:action(
		function()
			out("STARTING_ALLEGIANCE_TOUR_ACTION_2")

			if uic_tab_missions:IsDisabled() == false then
				completely_lock_input(false)
				uic_tab_missions:SimulateLClick()
				completely_lock_input(true)
			end

			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"bottom",
				100,
				uic_tab_missions,
				0.5,
				0
			)
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_allegiance_2")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:set_close_button_callback(function() cm:callback(function() tour_test_allegiance:start("tour_test_allegiance_action_3") end, 0.5) end)
			tp:show()	
		end, 0,
	"tour_test_allegiance_action_2"
	)

	tour_test_allegiance:action(
		function()
			out("STARTING_ALLEGIANCE_TOUR_ACTION_2")

			if uic_tab_set_target:IsDisabled() == false then
				completely_lock_input(false)
				uic_tab_set_target:SimulateLClick()
				completely_lock_input(true)
			end

			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"bottom",
				100,
				uic_tab_set_target,
				0.5,
				0
			)
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_allegiance_3")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:set_close_button_callback(function() cm:callback(function() tour_test_allegiance:start("tour_test_allegiance_action_4") end, 0.5) end)
			tp:show()	
		end, 0,
	"tour_test_allegiance_action_3"
	)

	tour_test_allegiance:action(
		function()
			out("STARTING_ALLEGIANCE_TOUR_ACTION_2")

			if uic_tab_request_army:IsDisabled() == false then
				completely_lock_input(false)
				uic_tab_request_army:SimulateLClick()
				completely_lock_input(true)
			end

			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"bottom",
				100,
				uic_tab_request_army,
				0.5,
				0
			)
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_allegiance_4")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:set_close_button_callback(function() cm:callback(function() tour_test_allegiance:start("tour_test_allegiance_action_5") end, 0.5) end)
			tp:show()	
		end, 0,
	"tour_test_allegiance_action_4"
	)

	tour_test_allegiance:action(
		function()
			out("STARTING_ALLEGIANCE_TOUR_ACTION_2")

			if uic_tab_outpost:IsDisabled() == false then
				completely_lock_input(false)
				uic_tab_outpost:SimulateLClick()
				completely_lock_input(true)
			end

			local tp = text_pointer:new_from_component(
				"tp_scripted_tour",
				"bottom",
				100,
				uic_tab_outpost,
				0.5,
				0
			)
			tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_allegiance_5")
			tp:set_style("semitransparent")
			tp:set_topmost(true)
			tp:set_highlight_close_button(0.5)
			tp:set_close_button_callback(function() cm:callback(function() tour_test_allegiance:complete() end, 0.5) end)
			tp:show()	
		end, 0,
	"tour_test_allegiance_action_5"
	)

	cm:callback(
		function()
			uic_panel_war_coordination = find_uicomponent("diplomacy_dropdown", "panel_war_coordination") 
			uic_favour_frame = find_uicomponent("diplomacy_dropdown", "panel_war_coordination", "favour_frame", "label_favour_points_value")
			uic_tab_missions = find_uicomponent("diplomacy_dropdown", "panel_war_coordination", "tabgroup", "tab_missions")
			uic_tab_set_target = find_uicomponent("diplomacy_dropdown", "panel_war_coordination", "tabgroup", "tab_set_target")
			uic_tab_request_army = find_uicomponent("diplomacy_dropdown", "panel_war_coordination", "tabgroup", "tab_request_army")
			uic_tab_outpost = find_uicomponent("diplomacy_dropdown", "panel_war_coordination", "tabgroup", "tab_outpost")
			
			if uic_favour_frame and uic_favour_frame:Visible(true) and uic_tab_missions and uic_tab_missions:Visible(true) and uic_tab_set_target and uic_tab_set_target:Visible(true) 
			and uic_tab_request_army and uic_tab_request_army:Visible(true) and uic_tab_outpost and uic_tab_outpost:Visible(true) and uic_panel_war_coordination and uic_panel_war_coordination:Visible(true) then
				tour_test_allegiance:set_show_skip_button(false)
				tour_test_allegiance:start("tour_test_allegiance_action_1")
			else
				completely_lock_input(false)
				prologue_intervention_allegiance:cancel()
				cm:contextual_vo_enabled(true);
			end
		end,
		0.5
	)
end

--------------------------------------------------------------
----------------------- FUNCTIONS -----------------------------
--------------------------------------------------------------

-- This only needs to happen once per campaign.
function first_load_interventions()
	if not prologue_check_progression["first_load_interventions"] then
		prologue_check_progression["first_load_interventions"] = true
		prologue_intervention_agents:start()
		prologue_intervention_legendary_lord_death:start()
		prologue_intervention_lord_death:start()
		prologue_intervention_movement_range:start()
		prologue_intervention_reinforcements:start()
		prologue_intervention_recruit_reminder:start()
		-- prologue_intervention_upkeep:start()
		-- prologue_intervention_upgrade_settlement:start()
		-- prologue_intervention_demolish:start()
		prologue_intervention_first_siege:start()
		prologue_intervention_garrison:start()
		-- prologue_intervention_building_browser:start()
		prologue_intervention_province_info_panel:start()
		prologue_intervention_resource_bar:start()
		prologue_intervention_lord_recruit:start()
		prologue_intervention_skills:start()
		prologue_intervention_technology:start()
		prologue_intervention_unit_recruit:start()
		prologue_intervention_units_panel:start()
		prologue_intervention_missions:start()
		prologue_intervention_help_button:start()
		-- prologue_intervention_hero_recruit:start()
		-- prologue_intervention_unit_merge_disband:start()
		prologue_intervention_sword_ability:start()
		-- prologue_intervention_embed_in_army:start()
		prologue_intervention_characters:start()
		prologue_intervention_settlements:start()
		prologue_intervention_quest_marker:start()
		prologue_intervention_post_battle_options:start()
		prologue_intervention_end_turn_notification:start()
		prologue_intervention_autoresolve:start()
		prologue_intervention_stances:start()
		prologue_intervention_diplomacy:start()
		prologue_intervention_quest_battle:start()
		--prologue_intervention_ror:start()
		prologue_intervention_income_reminder:start()
		prologue_intervention_items:start()
		prologue_intervention_income:start()
		prologue_intervention_lord_death_commanding:start()
		prologue_intervention_switch_commanders:start()
		prologue_intervention_quest_battle_loss:start()
		prologue_intervention_quest_battle_enemy_stronger:start()
		prologue_intervention_victory_condition_fulfilled:start()
		prologue_intervention_allegiance:start()
	end
end
first_load_interventions()

function end_death_intervention(intervention)
	core:remove_listener("CharacterConvalescedOrKilledLord")
	core:remove_listener("CharacterConvalescedOrKilledLegendaryLord")
	core:remove_listener("PanelOpenedCampaignAppointNewGeneral")
	prologue_check_progression["legendary_lord_death"] = true
	prologue_check_progression["lord_death"] = true
	prologue_check_progression["lord_death_commanding"] = true
	cm:steal_user_input(false)
	intervention:complete()
	cm:contextual_vo_enabled(true);
end

function cancel_death_intervention(intervention)
	if prologue_check_progression["legendary_lord_death"] or prologue_check_progression["lord_death_commanding"] then
		intervention:cancel()
		cm:contextual_vo_enabled(true);
	end
end

-- This adds a callback for when the player must press a specific ui component during a scripted tour instead of the regular text-pointer tickbox to progress.
function add_callback_button_press_intervention(button_to_press, steal_input_after_callback, callback_after_button_press, steal_esc_key_after_callback, intervention_to_remove_listeners)
	out("Adding callback for button press:"..button_to_press)
	steal_esc_key_after_callback = steal_esc_key_after_callback or false
	cm:steal_user_input(false)

	core:add_listener(
		"ComponentLClickUp"..button_to_press,
		"ComponentLClickUp",
		function(context) return context.string == button_to_press end,
		function() callback_after_button_press(); cm:steal_user_input(steal_input_after_callback); cm:steal_escape_key(steal_esc_key_after_callback); out("Removing callback for button press:"..button_to_press) end,
		false
	)
	if intervention_to_remove_listeners then intervention_to_remove_listeners:add_cleanup_callback(function() core:remove_listener("ComponentLClickUp"..button_to_press) end) end
end

-- Steals both user input and escape key on an event. Can optionally remove listeners when an intervention is cancelled or completed.
function steal_input_completely_on_event(should_steal, event_name, condition, delay_before_steal, listener_name_escape_key, listener_name_input, intervention_to_remove_listeners)

	cm:steal_escape_key_on_event(should_steal, event_name, condition, delay_before_steal, listener_name_escape_key)
	cm:steal_user_input_on_event(should_steal, event_name, condition, delay_before_steal, listener_name_input)

	if intervention_to_remove_listeners then intervention_to_remove_listeners:add_cleanup_callback(function() core:remove_listener(listener_name_escape_key); core:remove_listener(listener_name_input) end) end
end