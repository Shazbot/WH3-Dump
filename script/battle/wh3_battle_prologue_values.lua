

------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------
--
--	WH3 BATTLE PROLOGUE VALUES
--
--	PURPOSE
--  This script is loaded in into all prologue battles, which are of numerous types (regular, quest, scripted), so 
-- 	anything that should affect all prologue battles should be set in here.
--	It also defines values (mainly advice keys) that should be remapped for battles loaded from the wh3 prologue. By
--	remapping values, the prologue battles can lean on scripts such as scripted tours but swap in prologue-specific
--	advice keys.
--
--
--	LOADED
--	This file should be loaded on start of script in any prologue battle.
--	
--	AUTHORS
--	SV, JD, JJ
--
------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

bm:out("wh3_battle_prologue_values.lua loaded");

-- create an advice manager with debug output enabled
__am = advice_manager:new(true);

local function remap_value_for_prologue(value, replacement_value)
	bm:remap_value_for_campaign("wh3_main_prologue", value, replacement_value, true);
end;

-- Stop UI hiding.
bm:enable_ui_hiding(false)

-- Hide help button.
core:add_listener(
	"LoadingScreenDismissedDervingard",
	"LoadingScreenDismissed",
	true,
	function()
		local uic_button_help_panel = find_uicomponent("menu_bar", "button_help_panel")
		if uic_button_help_panel then uic_button_help_panel:SetVisible(false) end
	end,
	false
)

-- Remapping battle advice

remap_value_for_prologue("war.battle.advice.rallying.001", "wh3_prologue_battle_advice_rallying")
remap_value_for_prologue("war.battle.advice.enemy_general.001", "wh3_prologue_battle_advice_lords")
remap_value_for_prologue("war.battle.advice.siege_weapons.002", "wh3_prologue_battle_advice_siege_weapons")
remap_value_for_prologue("war.battle.advice.spells.001", "wh3_prologue_battle_advice_spells")
remap_value_for_prologue("wh2.battle.advice.positioning.001", "wh3_prologue_battle_advice_unit_positioning")
remap_value_for_prologue("war.battle.advice.artillery.002", "wh3_prologue_battle_advice_player_artillery")
remap_value_for_prologue("war.battle.advice.enemy_general.003", "wh3_prologue_battle_advice_enemy_general_routing")
remap_value_for_prologue("war.battle.advice.routing.001", "wh3_prologue_battle_advice_leadership")
remap_value_for_prologue("war.battle.advice.reinforcements.002", "wh3_prologue_battle_advice_enemy_reinforcement")
remap_value_for_prologue("war.battle.advice.victory_points.004", "wh3_prologue_battle_advice_victory_points")
remap_value_for_prologue("war.battle.advice.general.001", "wh3_prologue_battle_advice_player_general_dies")
remap_value_for_prologue("war.battle.advice.routing.002", "wh3_prologue_battle_advice_unit_routing")
remap_value_for_prologue("war.battle.advice.general.002", "wh3_prologue_battle_advice_player_general_wounded")
remap_value_for_prologue("war.battle.advice.cavalry.002", "wh3_prologue_battle_advice_player_cavalry")
remap_value_for_prologue("war.battle.advice.visibility.001", "wh3_prologue_battle_advice_enemy_visibility")
remap_value_for_prologue("war.battle.advice.visibility.002", "wh3_prologue_battle_advice_player_visibility")
remap_value_for_prologue("war.battle.advice.enemy_general.002", "wh3_prologue_battle_advice_enemy_general_wounded")
remap_value_for_prologue("war.battle.advice.forests.001", "wh3_prologue_battle_advice_units_hidden")
remap_value_for_prologue("war.battle.advice.reinforcements.001", "wh3_prologue_battle_advice_player_reinforcement")
remap_value_for_prologue("war.battle.advice.flying_units.001", "wh3_prologue_battle_advice_enemy_flying_units")
remap_value_for_prologue("war.battle.advice.capture_points.002", "wh3_prologue_battle_advice_capture_points")
remap_value_for_prologue("wh3_main_battle_advice_minor_settlement_attack_01", "wh3_prologue_battle_advice_minor_settlement_001")
remap_value_for_prologue("wh3_main_battle_advice_minor_settlement_attack_02", "wh3_prologue_battle_advice_minor_settlement_002")
remap_value_for_prologue("wh3_main_battle_advice_minor_settlement_attack_03", "wh3_prologue_battle_advice_minor_settlement_003")
remap_value_for_prologue("wh3_main_battle_advice_major_settlement_attack_01", "wh3_prologue_battle_advice_siege_battles")

--Revamping based on general
core:add_listener(
	"ScriptEventDeploymentPhaseBeginsAssignGeneralRevamp",
	"ScriptEventDeploymentPhaseBegins",
	true,
	function()
		local uic_review_DY = find_uicomponent(core:get_ui_root(), "hud_battle", "battle_orders", "battle_orders_pane", "card_panel_docker", "cards_panel", "review_DY")
		local revamp_value
		if uic_review_DY then
			for i = 0, uic_review_DY:ChildCount() - 1 do
				
				local uic_unit_panel = UIComponent(uic_review_DY:Find(i))
				if uic_unit_panel then							
									
					local CCOBattleUnitObjectId = uic_unit_panel:GetContextObjectId("CcoBattleUnit")
						if CCOBattleUnitObjectId then
										
						for i = 0, common.get_context_value("CcoBattleUnit", CCOBattleUnitObjectId, "AbilityList.Size") - 1 do
							local AbilityListRecordKey = common.get_context_value("CcoBattleUnit", CCOBattleUnitObjectId, "AbilityList.At("..i..").RecordKey")
											
							if AbilityListRecordKey == "wh3_main_pro_character_abilities_ursuns_roar_1" or AbilityListRecordKey =="wh3_main_pro_character_abilities_ursuns_roar_2" then
								remap_value_for_prologue("war.battle.advice.general.003", "wh3_prologue_battle_advice_player_general_routing_recruited")
								revamp_value = true
							end
						end
					end
				end
			end
		end

		if revamp_value then
			remap_value_for_prologue("war.battle.advice.general.003", "wh3_prologue_battle_advice_player_general_routing")
		else
			remap_value_for_prologue("war.battle.advice.general.003", "wh3_prologue_battle_advice_player_general_routing_recruited")
		end
	end,
	false
)

--Remapping battle infotext
remap_value_for_prologue("war.battle.advice.siege_weapons.info_002", "prologue_battle_infotext_siege_weapons")
remap_value_for_prologue("war.battle.advice.leadership.info_002", "prologue_battle_infotext_leadership_001")
remap_value_for_prologue("war.battle.advice.leadership.info_003", "prologue_battle_infotext_leadership_002")
remap_value_for_prologue("war.battle.advice.victory_locations.info_006", "prologue_battle_infotext_victory_points_001")
remap_value_for_prologue("war.battle.advice.victory_locations.info_009", "prologue_battle_infotext_victory_points_002")
remap_value_for_prologue("war.battle.advice.victory_locations.info_010", "prologue_battle_infotext_victory_points_003")

--Block certain advice from triggering in the prologue
remap_value_for_prologue("block_enemy_giant", true);
remap_value_for_prologue("block_player_giant", true);
remap_value_for_prologue("block_player_flying_units", true);
remap_value_for_prologue("block_enemy_artillery", true);
remap_value_for_prologue("block_enemy_cavalry", true);
remap_value_for_prologue("block_player_fatigue_during_battle", true);
remap_value_for_prologue("block_player_fatigue_battle_start", true);
remap_value_for_prologue("block_tactical_maps", true);
remap_value_for_prologue("block_formations", true);
remap_value_for_prologue("block_fire_at_will", true);
remap_value_for_prologue("block_receiving_missile_fire", true);
remap_value_for_prologue("block_enemy_capture_victory_location", true);
remap_value_for_prologue("block_enemy_capturing_victory_location", true);
remap_value_for_prologue("block_enemy_capturing_gates", true);
remap_value_for_prologue("block_player_approaches_victory_location", true);
remap_value_for_prologue("block_player_has_high_ground", true);
remap_value_for_prologue("block_enemy_has_high_ground", true);
remap_value_for_prologue("block_player_being_flanked", true);
remap_value_for_prologue("block_enemy_units_hidden", true);
remap_value_for_prologue("block_winds_of_magic_blowing", true);
remap_value_for_prologue("block_army_abilities", true);
remap_value_for_prologue("block_murderous_prowess", true);
remap_value_for_prologue("block_rampaging", true);
remap_value_for_prologue("block_realm_of_souls", true);
remap_value_for_prologue("block_vampire_coast_extra_powder", true);
remap_value_for_prologue("block_enemy_flying_units", true);
remap_value_for_prologue("block_DEPLOYMENT_tour", true);
remap_value_for_prologue("block_DEPLOYMENT_fundamentals_tour", true);
remap_value_for_prologue("block_DEPLOYMENT_unit_types_tour", true);
remap_value_for_prologue("block_DEPLOYMENT_major_siege_battle_defence_scripted_tour", true);
remap_value_for_prologue("block_DEPLOYMENT_minor_settlement_battle_defence_scripted_tour", true);
remap_value_for_prologue("block_DEPLOYMENT_major_siege_battle_attacking_scripted_tour", true);
remap_value_for_prologue("block_player_general_routing", true);

--Block certain infotext from appearing in the prologue
remap_value_for_prologue("block_war.battle.advice.rallying.info_004", true);
remap_value_for_prologue("block_war.battle.advice.the_general.info_004", true);
remap_value_for_prologue("block_war.battle.advice.siege_weapons.info_003", true);
remap_value_for_prologue("block_war.battle.advice.spells.info_004", true);
remap_value_for_prologue("block_war.battle.advice.leadership.info_004", true);
remap_value_for_prologue("block_war.battle.advice.victory_locations.info_008", true);
remap_value_for_prologue("block_war.battle.advice.victory_locations.info_011", true);
remap_value_for_prologue("block_war.battle.advice.capture_locations.info_003", true);
remap_value_for_prologue("block_war.battle.advice.artillery.info_003", true);
remap_value_for_prologue("block_war.battle.advice.reinforcements.info_003", true);
remap_value_for_prologue("block_war.battle.advice.visibility.info_003", true);
remap_value_for_prologue("block_war.battle.advice.terrain.info_004", true);
remap_value_for_prologue("block_war.battle.advice.flying_units.001", true);
remap_value_for_prologue("block_war.battle.advice.minor_settlement_battles.info_004", true);
remap_value_for_prologue("block_war.battle.advice.major_siege_battles.info_003", true);

---------------------------------------------------------------
------------------- Prologue Battle Settings ------------------
---------------------------------------------------------------

-- This plays advice if the player has not used their Ice Maiden in battle before.

if common.get_context_value("CcoBattleRoot", "", "QuestKey") == "" then
	local uic_unit_panel_ice_maiden_id
	local uic_unit_panel_ice_maiden

	local am_ice_maiden_abilities = advice_monitor:new(
		"ice_maiden_abilities",
		1000,
		"wh3_prologue_battle_tutorial_ice_maiden"
	)
	am_ice_maiden_abilities:add_ignore_advice_history_tweaker("SCRIPTED_TWEAKER_20")

	am_ice_maiden_abilities:add_trigger_condition(
		function()
			local uic_review_DY = find_uicomponent(core:get_ui_root(), "hud_battle", "battle_orders", "battle_orders_pane", "card_panel_docker", "cards_panel", "review_DY")
			if uic_review_DY then
				for i = 0, uic_review_DY:ChildCount() - 1 do
					
					local uic_unit_panel = UIComponent(uic_review_DY:Find(i))
					if uic_unit_panel then							
										
						local CCOBattleUnitObjectId = uic_unit_panel:GetContextObjectId("CcoBattleUnit")
							if CCOBattleUnitObjectId then
											
							for i = 0, common.get_context_value("CcoBattleUnit", CCOBattleUnitObjectId, "AbilityList.Size") - 1 do
								local AbilityListRecordKey = common.get_context_value("CcoBattleUnit", CCOBattleUnitObjectId, "AbilityList.At("..i..").RecordKey")
												
								if AbilityListRecordKey == "wh3_main_spell_ice_ice_maidens_kiss" then
									uic_unit_panel_ice_maiden = uic_unit_panel
									uic_unit_panel_ice_maiden_id = uic_unit_panel:Id()
									return true
								end
							end
						end
					end
				end
			end
		end,
		"ScriptEventDeploymentPhaseBegins"
	)

	am_ice_maiden_abilities:set_trigger_callback(
		function()

			local st_ice_maiden_abilities_2 = scripted_tour:new(
				"scripted_tour_ice_maiden_abilities_2",
				function() bm:release_escape_key() end
			);
			
			local st_ice_maiden_abilities_1 = scripted_tour:new(
				"scripted_tour_ice_maiden_abilities_1",
				function() 	st_ice_maiden_abilities_2:start("scripted_tour_ice_maiden_abilities_2_1") end
			);

			st_ice_maiden_abilities_1:add_fullscreen_highlight("hud_battle", "battle_orders", "battle_orders_pane", "card_panel_docker", "cards_panel", "review_DY", uic_unit_panel_ice_maiden_id)
			st_ice_maiden_abilities_2:add_fullscreen_highlight("hud_battle", "winds_of_magic", "holder")
			st_ice_maiden_abilities_1:set_show_skip_button(false);
			st_ice_maiden_abilities_2:set_show_skip_button(false);

			st_ice_maiden_abilities_1:action(
				function()
					out("Starting 'scripted_tour_ice_maiden_abilities_1")
						st_ice_maiden_abilities_1:show_fullscreen_highlight(true)
						
						local tp_from_component = text_pointer:new_from_component(
								"tp_ice_maiden_unit_panel",
								"bottom",
								100,
								uic_unit_panel_ice_maiden,
								0.5,
								0
							)	
						tp_from_component:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_ice_maiden_abilities_1")
						tp_from_component:set_style("semitransparent")
						tp_from_component:set_topmost(true)
						tp_from_component:set_highlight_close_button(0.5)
						tp_from_component:set_close_button_callback(function() uic_unit_panel_ice_maiden:SimulateLClick(); st_ice_maiden_abilities_1:complete() end)
						tp_from_component:show()		


					core:add_listener(
						"ComponentLClickUpIceMaidenPanel",
						"ComponentLClickUp",
						function(context) return context.string == uic_unit_panel_ice_maiden_id end,
						function()
							st_ice_maiden_abilities_1:complete()
						end,
						false
					);
				end,
				1,
				"scripted_tour_ice_maiden_abilities_1_1"
			)
			
			st_ice_maiden_abilities_2:action(
				function()
					out("Starting 'scripted_tour_ice_maiden_abilities_2")
					st_ice_maiden_abilities_2:show_fullscreen_highlight(true)

					local uic_holder = find_uicomponent(core:get_ui_root(), "hud_battle", "winds_of_magic", "holder")
						
					if uic_holder and uic_holder:Visible(true) then
						local tp_from_component = text_pointer:new_from_component(
								"tp_ice_maiden_abilities_panel",
								"right",
								100,
								uic_holder,
								0,
								0.5
							)	
						tp_from_component:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_ice_maiden_abilities_2")
						tp_from_component:set_style("semitransparent")
						tp_from_component:set_topmost(true)
						tp_from_component:set_highlight_close_button(0.5)
						tp_from_component:set_close_button_callback(function() st_ice_maiden_abilities_2:complete() end)
						tp_from_component:show()		
					else
						st_ice_maiden_abilities_2:complete()
					end
				end,
				1,
				"scripted_tour_ice_maiden_abilities_2_1"
			)

			bm:steal_escape_key()
			st_ice_maiden_abilities_1:start("scripted_tour_ice_maiden_abilities_1_1")
		end
	)
	am_ice_maiden_abilities:set_delay_before_triggering(0)
	am_ice_maiden_abilities:set_advice_level(0)
	am_ice_maiden_abilities:set_duration(0)
end

-- Hides the spell browser
bm:show_spell_browser_button(false)

function add_pause_reminder()
	-- Shows a reminder how to un-pause time if it's been paused a while.
	local pause_message_played = false
	core:add_listener(
		"ComponentLClickUpCheckForPausedBattle",
		"ComponentLClickUp",
		function() if pause_message_played then return false else return true end end,
		function()
			bm:real_callback(
				function()
					local uic_pause = find_uicomponent(core:get_ui_root(), "speed_controls", "speed_buttons", "pause")
					if uic_pause and uic_pause:Visible() and uic_pause:CurrentState() == "selected" then
						bm:real_callback(
							function()							
								uic_pause = find_uicomponent(core:get_ui_root(), "speed_controls", "speed_buttons", "pause")
								if uic_pause and uic_pause:Visible() and uic_pause:CurrentState() == "selected" then
									local uic_play = find_uicomponent(core:get_ui_root(), "speed_controls", "speed_buttons", "play")
									local uic_esc_menu = find_uicomponent(core:get_ui_root(), "esc_menu")
									if uic_play and uic_play:Visible() and not uic_esc_menu then
										pause_message_played = true
										local stop_loop = false
										local tp = text_pointer:new_from_component(
											"tp_scripted_tour",
											"top",
											100,
											uic_play,
											0.5,
											1
										)	
										tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_text_pointer_battle_speed_modifiers_reminder")
										tp:set_style("semitransparent")
										tp:set_highlight_close_button(0.5)
										tp:set_close_button_callback(function() core:remove_listener("ComponentLClickUpClickSpeedButtonTP"); stop_loop = true end)
										tp:show()	

										core:add_listener(
											"ComponentLClickUpClickSpeedButtonTP",
											"ComponentLClickUp",
											function(context) return context.string == "play" or context.string == "pause" 
												or context.string == "slow_mo" or context.string == "fwd" or context.string == "ffwd" or context.string == "button_menu" end,
											function()
												tp:hide(); stop_loop = true
											end,
											false
										);

										local function LoopUnitUIButtonPress()
											local uic_play = find_uicomponent(core:get_ui_root(), "speed_controls", "speed_buttons", "play")
											local uic_slow_mo = find_uicomponent(core:get_ui_root(), "speed_controls", "speed_buttons", "slow_mo")
											local uic_fwd = find_uicomponent(core:get_ui_root(), "speed_controls", "speed_buttons", "fwd")
											local uic_ffwd = find_uicomponent(core:get_ui_root(), "speed_controls", "speed_buttons", "ffwd")
											
											if uic_play:CurrentState() == "selected" or uic_slow_mo:CurrentState() == "selected" or
											uic_fwd:CurrentState() == "selected" or uic_ffwd:CurrentState() == "selected" then
												tp:hide(); stop_loop = true
											end

											if stop_loop == false then
												bm:callback(function() LoopUnitUIButtonPress() end, 500)
											end
										end
										LoopUnitUIButtonPress()
									end
								end
							end, 5000
						)
					end
				end, 100
			)
		end,
		true
	)
end

function AddRematchListener()
	-- This will enable the rematch button instead of dismiss results (quit to campaign.)
	bm:register_phase_change_callback(
		"VictoryCountdown",
		function()
			local player_army = bm:get_scriptunits_for_local_players_army();
			local player_general = player_army:get_general_sunit();
			if bm:victorious_alliance() ~= player_general.alliance_num then
				core:add_listener(
					"PanelOpenedBattleRematch",
					"PanelOpenedBattle",
					function(context) return context.string == "in_battle_results_popup" end,
					function() 
						local uic_button_rematch = find_uicomponent(core:get_ui_root(), "panel_manager", "in_battle_results_popup", "background", "button_background", "button_parent", "button_rematch")
						if uic_button_rematch then uic_button_rematch:SetVisible(true) end
					end,
					false
				)
			end
		end
	)
end

function HideDismissResults()
	-- This will enable the rematch button instead of dismiss results (quit to campaign.)
	bm:register_phase_change_callback(
		"VictoryCountdown",
		function()
			local player_army = bm:get_scriptunits_for_local_players_army();
			local player_general = player_army:get_general_sunit();
			if bm:victorious_alliance() ~= player_general.alliance_num then
				core:add_listener(
					"PanelOpenedBattleRematch",
					"PanelOpenedBattle",
					function(context) return context.string == "in_battle_results_popup" end,
					function() 
						local uic_dismiss_results = find_uicomponent(core:get_ui_root(), "panel_manager", "in_battle_results_popup", "background", "button_background", "button_parent", "button_dismiss_results")
						if uic_dismiss_results then uic_dismiss_results:SetVisible(false) end
					end,
					false
				)
			end
		end
	)
end

function HideRematchButton()
	-- This will hide the rematch button on victory.
	bm:register_phase_change_callback(
		"VictoryCountdown",
		function()
			local player_army = bm:get_scriptunits_for_local_players_army();
			local player_general = player_army:get_general_sunit();
			if bm:victorious_alliance() == player_general.alliance_num then
				core:add_listener(
					"PanelOpenedBattleRematch",
					"PanelOpenedBattle",
					function(context) return context.string == "in_battle_results_popup" end,
					function() 
						local uic = find_uicomponent(core:get_ui_root(), "panel_manager", "in_battle_results_popup", "background", "button_background", "button_parent", "button_rematch")
						if uic then uic:SetVisible(false) end
					end,
					false
				)
			end
		end
	)
end

function HideReplayButton()
	-- This will hide the replay button on victory.
	bm:register_phase_change_callback(
		"VictoryCountdown",
		function()
			local player_army = bm:get_scriptunits_for_local_players_army();
			local player_general = player_army:get_general_sunit();
			if bm:victorious_alliance() == player_general.alliance_num then
				core:add_listener(
					"PanelOpenedBattleRematch",
					"PanelOpenedBattle",
					function(context) return context.string == "in_battle_results_popup" end,
					function() 
						local uic = find_uicomponent(core:get_ui_root(), "panel_manager", "in_battle_results_popup", "background", "button_background", "button_parent", "button_save_replay")
						if uic then uic:SetVisible(false) end
					end,
					false
				)
			end
		end
	)
end



function HideConcedeButton()
	-- Hides the concede button in the pause menu.
	core:add_listener(
		"PanelOpenedBattleHideConcede",
		"PanelOpenedBattle",
		function(context) return context.string == "esc_menu" end,
		function(context)
			local uic_frame_concede = find_uicomponent(core:get_ui_root(), "esc_menu", "main", "menu_left", "menu_buttons", "holder_resume_concede", "frame_concede")
			if uic_frame_concede then uic_frame_concede:SetVisible(false) end
		end,
		true
	)
end

function YuriInvulernableWhenRouting()
	local yuri = bm:get_scriptunits_for_local_players_army():get_general_sunit()
	yuri:rout_on_casualties(0.2, true)
end

function AddSkipBattleText()
	-- Replaces "Quit Battle" text with "Skip Battle".
	core:add_listener(
		"PanelOpenedBattleHideConcede",
		"PanelOpenedBattle",
		function(context) return context.string == "esc_menu" end,
		function()
			local uic_button_text = find_uicomponent(core:get_ui_root(), "esc_menu", "menu_holder", "menu", "menu_buttons", "holder_resume_concede", "frame_concede", "button_concede", "button_txt")
			if uic_button_text then uic_button_text:SetStateText(common.get_localised_string("campaign_localised_strings_string_skip_battle"), "campaign_localised_strings_string_skip_battle") end
		end,
		true
	)
end



-- Controls the portrait names.
core:add_listener(
	"AdviceNavigatedAdvisorName",
	"AdviceNavigated",
	true,
	function() local uic_cycler_list = find_uicomponent(core:get_ui_root(), "advice_interface", "advisor_portrait_parent", "frame","cycler_list")
		local uic_nameplate = find_uicomponent(core:get_ui_root(), "advice_interface", "advisor_portrait_parent", "frame","cycler_list", "nameplate_holder", "dy_nameplate")
		
		if uic_cycler_list then uic_cycler_list:SetState("nameplate") end end,
	true
)

core:add_listener(
	"AdviceIssuedAdvisorName",
	"AdviceIssued",
	true,
	function() local uic_cycler_list = find_uicomponent(core:get_ui_root(), "advice_interface", "advisor_portrait_parent", "frame","cycler_list")
		local uic_nameplate = find_uicomponent(core:get_ui_root(), "advice_interface", "advisor_portrait_parent", "frame","cycler_list", "nameplate_holder", "dy_nameplate")
		
		if uic_cycler_list then uic_cycler_list:SetState("nameplate") end end,
	true
)



---------------------------------------------------------------
------------------- Skip Button Consequences ------------------
---------------------------------------------------------------

function AddSkipButtonListener(battle_1)
	core:add_listener(
		"ComponentLClickUpSkipConsequences",
		"ComponentLClickUp",
		function(context) return context.string == "button_concede" end,
		function() 
			bm:real_callback(
				function()
					local uic_dialogue_box = find_uicomponent(core:get_ui_root(), "dialogue_box")
					if uic_dialogue_box then
						local tp = text_pointer:new_from_component(
							"tp",
							"top",
							20,
							uic_dialogue_box,
							0.5,
							1
						)
						if battle_1 then
							tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_text_pointer_skip_battle_1")
						else
							tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_text_pointer_skip_battle_2")
						end
						tp:set_style("semitransparent")
						tp:set_topmost(true)
						tp:set_show_pointer_end_without_line(true)
						tp:show()	

						bm:repeat_real_callback(
						function() 
							local uic_dialogue_box_2 = find_uicomponent(core:get_ui_root(), "dialogue_box")
							if uic_dialogue_box_2 == false then 
								tp:hide(); bm:remove_real_callback("WaitForDialogue") 
							end
						end, 
						50, 
						"WaitForDialogue"
					)
					end
				end,
				100
			)	
		end,
		true
	)
end

---------------------------------------------------------------
----------------------- LOADING SCREEN ------------------------
---------------------------------------------------------------
core:add_listener(
	"ComponentLClickUpMainMenuLoadingScreen",
	"ComponentLClickUp",
	function(context) return context.string == "button_quit" end,
	function() common.setup_dynamic_loading_screen("prologue_intro", "prologue") end,
	false
)