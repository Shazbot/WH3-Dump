

------------------------------------------
--------- SCRIPTED TOUR FUNCTIONS --------
------------------------------------------

-- These are necessary for scripted tours that aren't used inside interventions (which have their own saving block method).
function start_scripted_tour_prologue (tour, sequence_name, steal_user_input, steal_escape_key, stop_hotkeys)
	out ("Starting scripted tour!")

	--if dialogue_in_progress == false then 
		cm:trigger_scripted_tour_metrics_start(tour.name);
		cm:disable_saving_game(true)
		if steal_user_input then cm:steal_user_input(true) end
		if steal_escape_key then cm:steal_escape_key(true) end
		if stop_hotkeys then allow_hotkeys(false) end

		tour:start(sequence_name)
	--end
end

function end_scripted_tour_prologue (tour, block_saving, release_user_input, release_escape_key, release_hotkeys)
	out ("Ending scripted tour!")
	if block_saving then
		cm:disable_saving_game(true)
	else
		cm:disable_saving_game(false)
	end
	
	if release_user_input then cm:steal_user_input(false) end
	if release_escape_key then cm:steal_escape_key(false) end
	if release_hotkeys then allow_hotkeys(true) end
	
	tour:complete()
end

function skip_all_scripted_tours()
	if not cm:model():shared_states_manager():get_state_as_bool_value("prologue_tutorial_on") then 
		core:trigger_event("ScriptEventSkipAllScriptedTours");
		core:hide_fullscreen_highlight();
		cm:steal_user_input(false);
		out("TRYING TO SKIP!")
	end 
end

----------------------------
--- SCRIPTED TOURS ---------
---------------------------

function PrologueScriptedTourSkillPoint()
	core:add_listener(
		"skills_panel_button_press",
		"ComponentLClickUp",
		function(context) 
			if not (context.string == "button_info" and uicomponent_descended_from(UIComponent(context.component), "character_details_panel")) then
				return false;
			end;

			local uic_skills = find_uicomponent(core:get_ui_root(), "character_details_panel", "TabGroup", "skills");
			
			if not uic_skills then
				out("details not found")
			end;

			return uic_skills and uic_skills:CurrentState() == "selected";
		end,
		function()		

			local uic_button_help = find_uicomponent(core:get_ui_root(), "character_details_panel", "button_info");
			uic_button_help:SetDisabled(true);

			local uic_button_skills_2 = find_uicomponent(core:get_ui_root(), "character_details_panel", "dy_pts");
			
			local tour_test_2 = scripted_tour:new(
				"tour_skill_point",
				function() uic_button_help:SetDisabled(false); out("FINISHED TOUR 2") end
			);
			
			local uic_listview = find_uicomponent(core:get_ui_root(), "character_details_panel", "character_context_parent", "tab_panels", "skills_subpanel", "listview")
			uic_listview:SetInteractive(false)

			--this isn't working at the moment
			tour_test_2:add_fullscreen_highlight("character_details_panel", "tx_skill");
			tour_test_2:add_fullscreen_highlight("character_details_panel", "dy_pts");
			tour_test_2:set_should_dismiss_advice_on_completion(false);
			tour_test_2:set_show_skip_button(false);
			tour_test_2:add_skip_action(
				function()
					CampaignUI.ClosePanel("character_details_panel");	
				end
			);
					
			tour_test_2:action(
				function() 
					out("STARTING AN ACTION 1 IN TOUR 2") 
					local text_pointer_test_2 = text_pointer:new_from_component(
						"test2_text_pointer",
						"top",
						100,
						uic_button_skills_2,
						0.5,
						0.7
					);
					
					text_pointer_test_2:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_skills_panel_1_1");
					text_pointer_test_2:set_style("semitransparent");
					text_pointer_test_2:set_topmost(true);
					text_pointer_test_2:set_label_offset(-100, 0);
					text_pointer_test_2:set_close_button_callback(function() tour_test_2:start("show_second_text_pointer") end);
					text_pointer_test_2:set_highlight_close_button(2);
					text_pointer_test_2:show();
					pulse_uicomponent(uic_button_skills_2, 2, 6);
					
				end,
				0
			);

			tour_test_2:action(
				function() 
					out("STARTING AN ACTION 2 IN TOUR 2") 
			
					pulse_uicomponent(uic_button_skills_2, false);
					tour_test_2:show_fullscreen_highlight(false);
					core:show_fullscreen_highlight_around_components(0, false, true, uic_listview);

					local text_pointer_test_3 = text_pointer:new_from_component(
						"tp_scripted_tour",
						"right",
						25,
						uic_listview,
						0,
						0.5
					)
					text_pointer_test_3:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_skills_panel_1_2");
					text_pointer_test_3:set_style("semitransparent");
					text_pointer_test_3:set_topmost(true);
					text_pointer_test_3:set_close_button_callback(function() core:hide_fullscreen_highlight(); uic_listview:SetInteractive(true); end_scripted_tour_prologue(tour_test_2); end);
					text_pointer_test_3:set_highlight_close_button(2);
					text_pointer_test_3:show();
					
				end,
				0,
				"show_second_text_pointer"
			);
			start_scripted_tour_prologue(tour_test_2)
		end,
		true		

	);
end


function PrologueScriptedTourSettlementPanel()
	core:add_listener(
		"settlement_panel_button_press",
		"ComponentLClickUp",
		function(context) 
			if cm:is_local_players_turn() then
				return context.string == "button_info" and uicomponent_descended_from(UIComponent(context.component), "settlement_panel"); 
			end 
		end,
		function()

			local overview_panel = true;
			local uic_button_help = find_uicomponent(core:get_ui_root(), "settlement_panel", "button_info");
			uic_button_help:SetDisabled(true);
			
			local uic_settlement_panel = find_uicomponent(core:get_ui_root(), "settlement_panel");
			local uic_overview_button = find_uicomponent(core:get_ui_root(), "hud_campaign", "hud_center_docker", "button_group_settlement", "button_show_province");

			if uic_overview_button then
				if uic_overview_button:CurrentState() ~= "selected" then
					uic_settlement_panel = uic_overview_button;
					overview_panel = false;
				end
			end
		
			local tour_settlement_panel = scripted_tour:new(
				"test_tour_settlement_panel",
				function() uic_button_help:SetDisabled(false); out("FINISHED Settlement panel tour") end
			);
			
			if overview_panel == true then
				tour_settlement_panel:add_fullscreen_highlight("settlement_panel");
				pulse_uicomponent(uic_settlement_panel, 2, 6);
			else
				tour_settlement_panel:add_fullscreen_highlight("hud_campaign", "hud_center_docker", "button_group_settlement", "button_show_province");
			end

			tour_settlement_panel:set_show_skip_button(false);
			tour_settlement_panel:set_should_dismiss_advice_on_completion(false);
					
			tour_settlement_panel:action(
				function() 
					out("STARTING AN ACTION 1 IN TOUR 1") 
					local text_pointer_test_2 = text_pointer:new_from_component(
						"test2_text_pointer",
						"bottom",
						100,
						uic_settlement_panel,
						0.5,
						0
					);
					
					text_pointer_test_2:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_settlement_panel_1_1");
					text_pointer_test_2:set_style("semitransparent");
					text_pointer_test_2:set_topmost(true);
					--text_pointer_test_2:set_label_offset(-100, 0);
					if overview_panel == true then 
						text_pointer_test_2:set_close_button_callback(function() tour_settlement_panel:start("show_second_text_pointer") end);
						text_pointer_test_2:set_highlight_close_button(2);
					else
						text_pointer_test_2:set_show_close_button(false);
						
						-- Allow user input while button is pressed.
						cm:steal_user_input(false)

						core:add_listener(
							"overview_button_listener",
							"ComponentLClickUp",
							function(context) 
								return context.string == "button_show_province" 
							end,
							function()
								cm:steal_user_input(true)
								text_pointer_test_2:hide();
								core:hide_fullscreen_highlight()
								cm:callback(function() tour_settlement_panel:start("show_second_text_pointer") end, 0.5, "overview_button_delay")

								--Clean up if the scripted tour is skipped
								tour_settlement_panel:add_skip_action(
									function()
										cm:remove_callback("overview_button_delay");
										cm:steal_user_input(false);
									end
								);
							end,
							false
						);

						--Clean up if the scripted tour is skipped
						tour_settlement_panel:add_skip_action(
							function()
								core:remove_listener("overview_button_listener");
							end
						);
					end
					text_pointer_test_2:show();			
							
				end,
				0
			);

			tour_settlement_panel:action(
				function() 
					out("STARTING AN ACTION 2 IN TOUR 1") 

					local uic_parent = find_uicomponent("settlement_panel", "settlement_list")
					local uic_child = UIComponent(uic_parent:Find(1))
					local default_slots_list = find_uicomponent(uic_child, "default_slots_list")
					local uic_building_slot = UIComponent(default_slots_list:Find(1))
					
					pulse_uicomponent(uic_settlement_panel, false);
					tour_settlement_panel:show_fullscreen_highlight(false);
					core:show_fullscreen_highlight_around_components(0, false, true, uic_building_slot);

					local text_pointer_test_3 = text_pointer:new_from_component(
						"test3_text_pointer",
						"right",
						100,
						uic_building_slot,
						0,
						0.5
					);

					text_pointer_test_3:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_settlement_panel_1_2");
					text_pointer_test_3:set_style("semitransparent");
					text_pointer_test_3:set_topmost(true);
					text_pointer_test_3:set_close_button_callback(function() tour_settlement_panel:start("show_third_text_pointer") end);
					text_pointer_test_3:set_highlight_close_button(2);
					text_pointer_test_3:show();
							
				end,
				0,
				"show_second_text_pointer"
			);

			tour_settlement_panel:action(
				function() 
					out("STARTING AN ACTION 3 IN TOUR 1") 
					core:hide_fullscreen_highlight();
					
					local uic_parent = find_uicomponent("settlement_panel", "settlement_list")
					local uic_child = UIComponent(uic_parent:Find(1))
					local default_slots_list = find_uicomponent(uic_child, "default_slots_list")
					local uic_building_slot = UIComponent(default_slots_list:Find(2))
	
					core:show_fullscreen_highlight_around_components(0, false, true, uic_building_slot);

					local text_pointer_test_4 = text_pointer:new_from_component(
						"test4_text_pointer",
						"right",
						100,
						uic_building_slot,
						0,
						0.5
					);

					text_pointer_test_4:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_settlement_panel_1_3");
					text_pointer_test_4:set_style("semitransparent");
					text_pointer_test_4:set_topmost(true);
					text_pointer_test_4:set_close_button_callback(function() 
						if prologue_tutorial_passed["province_info_panel"] == true then
							tour_settlement_panel:start("show_fourth_text_pointer"); 
						else 
							core:hide_fullscreen_highlight();
							end_scripted_tour_prologue(tour_settlement_panel, false, true, true, true)
						end
					end);
					text_pointer_test_4:set_highlight_close_button(2);
					text_pointer_test_4:show();
					
				end,
				0,
				"show_third_text_pointer"
			);

			local uic_settlement_info_panel = find_uicomponent(core:get_ui_root(), "hud_campaign", "ProvinceInfoPopup", "panel");
			tour_settlement_panel:action(
				function() 
					out("STARTING AN ACTION 4 IN TOUR 1") 

					if prologue_tutorial_passed["province_info_panel"] == false then
						cm:callback(function() tour_settlement_panel:start("show_fifth_text_pointer") end, 0.5)
					end

					core:hide_fullscreen_highlight();
					
					core:show_fullscreen_highlight_around_components(0, false, true, uic_settlement_info_panel);

					local text_pointer_test_5 = text_pointer:new_from_component(
						"test5_text_pointer",
						"bottom",
						100,
						uic_settlement_info_panel,
						0.5,
						0
					);

					text_pointer_test_5:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_settlement_panel_1_4");
					text_pointer_test_5:set_style("semitransparent");
					text_pointer_test_5:set_topmost(true);
					text_pointer_test_5:set_label_offset(100, 0);
					text_pointer_test_5:set_close_button_callback(function() 
						if prologue_tutorial_passed["settlement_panel_building_browser_with_button_hidden"] == true then
							tour_settlement_panel:start("show_fifth_text_pointer");
						else
							core:hide_fullscreen_highlight();
							end_scripted_tour_prologue(tour_settlement_panel, false, true, true, true)
						end
					end);
					text_pointer_test_5:set_highlight_close_button(2);
					text_pointer_test_5:show();
					
				end,
				0,
				"show_fourth_text_pointer"
			);

			tour_settlement_panel:action(
				function() 
					out("STARTING AN ACTION 5 IN TOUR 1") 
				
					local uic = find_uicomponent(core:get_ui_root(),"hud_center", "small_bar", "button_subpanel", "button_building_browser")
					if uic and uic:Visible(true) then
						out("Continue action")
					else
						cm:callback(function() tour_settlement_panel:start("show_sixth_text_pointer") end, 0.5)
					end

					core:hide_fullscreen_highlight();
					core:show_fullscreen_highlight_around_components(0, false, true, uic);

					local text_pointer_test_6 = text_pointer:new_from_component(
						"test6_text_pointer",
						"bottom",
						100,
						uic,
						0.5,
						0
					);

					text_pointer_test_6:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_settlement_panel_1_5");
					text_pointer_test_6:set_style("semitransparent");
					text_pointer_test_6:set_topmost(true);
					text_pointer_test_6:set_close_button_callback(function() 
						if prologue_tutorial_passed["settlement_panel_lord_recruit_with_button_hidden"] == true then 
							tour_settlement_panel:start("show_sixth_text_pointer")  
						elseif prologue_tutorial_passed["settlement_panel_garrison_with_button_hidden"] == true then 
							tour_settlement_panel:start("show_seventh_text_pointer")  
						else
							core:hide_fullscreen_highlight();
							end_scripted_tour_prologue(tour_settlement_panel, false, true, true, true)
						end
					end);
					text_pointer_test_6:set_highlight_close_button(2);
					text_pointer_test_6:show();
					
				end,
				0,
				"show_fifth_text_pointer"
			);

			tour_settlement_panel:action(
				function() 
					out("STARTING AN ACTION 6 IN TOUR 1") 

					local uic = find_uicomponent(core:get_ui_root(), "hud_campaign", "hud_center_docker", "hud_center", "small_bar", "button_subpanel_parent", "button_subpanel", "button_group_settlement", "button_create_army")
					if uic and uic:Visible(true) then
						out("Continue action")
					else
						cm:callback(function() tour_settlement_panel:start("show_seventh_text_pointer") end, 0.5)
					end

					core:hide_fullscreen_highlight();
					core:show_fullscreen_highlight_around_components(0, false, true, uic);

					local text_pointer_test_5 = text_pointer:new_from_component(
						"test5_text_pointer",
						"bottom",
						100,
						uic,
						0.5,
						0
					);

					text_pointer_test_5:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_settlement_panel_1_6");
					text_pointer_test_5:set_style("semitransparent");
					text_pointer_test_5:set_topmost(true);
					text_pointer_test_5:set_close_button_callback(function() 
						if prologue_tutorial_passed["settlement_panel_garrison_with_button_hidden"] == true then 
							cm:callback(function() tour_settlement_panel:start("show_seventh_text_pointer") end, 0.5)
						else
							core:hide_fullscreen_highlight();
							end_scripted_tour_prologue(tour_settlement_panel, false, true, true, true)
						end 
					end);
					text_pointer_test_5:set_highlight_close_button(2);
					text_pointer_test_5:show();
					
				end,
				0,
				"show_sixth_text_pointer"
			);

			tour_settlement_panel:action(
				function() 
					out("STARTING AN ACTION 7 IN TOUR 1") 

					local uic = find_uicomponent(core:get_ui_root(), "hud_center", "small_bar", "button_subpanel", "button_show_garrison")
					if uic and uic:Visible(true) then
						out("Continue action")
					else
						end_scripted_tour_prologue(tour_settlement_panel, false, true, true, true)
					end

					core:hide_fullscreen_highlight();
					core:show_fullscreen_highlight_around_components(0, false, true, uic);

					local text_pointer_test_7 = text_pointer:new_from_component(
						"test5_text_pointer",
						"bottom",
						100,
						uic,
						0.5,
						0
					);

					text_pointer_test_7:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_settlement_panel_1_7");
					text_pointer_test_7:set_style("semitransparent");
					text_pointer_test_7:set_topmost(true);
					text_pointer_test_7:set_close_button_callback(function() core:hide_fullscreen_highlight(); end_scripted_tour_prologue(tour_settlement_panel, false, true, true, true) end);
					text_pointer_test_7:set_highlight_close_button(2);
					text_pointer_test_7:show();
					
				end,
				0,
				"show_seventh_text_pointer"
			);

		
			start_scripted_tour_prologue(tour_settlement_panel, nil, true, true, true)
		end,
		true
	);
end


function PrologueScriptedTourPreBattleScreen()
	core:add_listener(
		"pre_battle_screen_button_press",
		"ComponentLClickUp",
		function(context) 
			return context.string == "button_info" and uicomponent_descended_from(UIComponent(context.component), "popup_pre_battle");
		end,
		function()
			local uic_autoresolve_bar = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "killometer");
			local uic_button_help = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "button_info");
			uic_button_help:SetDisabled(true);
			
			local uic_pre_battle_screen_allies = find_uicomponent(core:get_ui_root(), "allies_combatants_panel");
			
			local tour_pre_battle_screen = scripted_tour:new(
				"test_tour_pre_battle_screen",
				function() uic_button_help:SetDisabled(false); out("FINISHED Pre Battle screen tour") end
			);		
			
			tour_pre_battle_screen:set_show_skip_button(false);
			tour_pre_battle_screen:set_should_dismiss_advice_on_completion(false);
					
			tour_pre_battle_screen:action(
				function() 
					out("STARTING AN ACTION 1 IN TOUR 1") 

					core:show_fullscreen_highlight_around_components(0, false, true, uic_pre_battle_screen_allies);

					local text_pointer_test_2 = text_pointer:new_from_component(
						"test2_text_pointer",
						"left",
						100,
						uic_pre_battle_screen_allies,
						1,
						0.2
					);
					
					text_pointer_test_2:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_pre_battle_screen_1_1");
					text_pointer_test_2:set_style("semitransparent");
					text_pointer_test_2:set_topmost(true);
					text_pointer_test_2:set_close_button_callback(function() cm:callback(function() tour_pre_battle_screen:start("show_fourth_text_pointer") end, 0.5) end);
					text_pointer_test_2:set_highlight_close_button(2);
					text_pointer_test_2:show();
					
				end,
				0
			);

			local uic_enemy_panel = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "enemy_combatants_panel");
			tour_pre_battle_screen:action(
				function() 
					out("STARTING AN ACTION 4 IN TOUR 1") 

					core:hide_fullscreen_highlight();
					
					core:show_fullscreen_highlight_around_components(0, false, true, uic_enemy_panel);

					local text_pointer_test_5 = text_pointer:new_from_component(
						"test5_text_pointer",
						"right",
						100,
						uic_enemy_panel,
						0,
						0.3
					);

					text_pointer_test_5:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_pre_battle_screen_1_3");
					text_pointer_test_5:set_style("semitransparent");
					text_pointer_test_5:set_topmost(true);
					text_pointer_test_5:set_close_button_callback(function() core:hide_fullscreen_highlight(); cm:callback(function() tour_pre_battle_screen:start("show_seventh_text_pointer") end, 0.5) end)
					text_pointer_test_5:set_highlight_close_button(2);
					text_pointer_test_5:show();
					
				end,
				0,
				"show_fourth_text_pointer"
			);
			
			-- Second action in the tour. This displays, "This shows how many turns you must maintain your siege until the settlement surrenders."
			tour_pre_battle_screen:action(
				function()
					out("STARTING AN ACTION 7 IN TOUR 1")

					-- If this is a siege, start the siege tour. If not, end the tour.
					local uic = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "mid", "battle_deployment", "regular_deployment", "list", "siege_information_panel", "icon_turns", "dy_turns")
					if uic and uic:Visible(true) then
						local uic_border_panel = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "mid", "battle_deployment", "regular_deployment", "list")
						core:show_fullscreen_highlight_around_components(5, false, false, uic_border_panel)
						
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
						text_pointer_test_first_siege:set_close_button_callback(function() cm:callback(function() tour_pre_battle_screen:start("show_eigth_text_pointer") end, 0.5) end)
						text_pointer_test_first_siege:show()
					else
						end_scripted_tour_prologue(tour_pre_battle_screen, false, true, true, true)
					end
				end,
				0,
				"show_seventh_text_pointer"
			)

			-- Third action in the tour. This displays, "This shows how many turns you must maintain your siege until the garrison starts taking damage."
			tour_pre_battle_screen:action(
				function()
					out("STARTING AN ACTION 8 IN TOUR 1")

					local uic = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "mid", "battle_deployment", "regular_deployment", "list", "siege_information_panel", "header", "tl_list", "defender_siege_supplies")
					if uic and uic:Visible(true) then
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
						text_pointer_test_first_siege:set_close_button_callback(function() cm:callback(function() tour_pre_battle_screen:start("show_ninth_text_pointer") end, 0.5) end)
						text_pointer_test_first_siege:show()
					else
						core:hide_fullscreen_highlight()
						end_scripted_tour_prologue(tour_pre_battle_screen, false, true, true, true)
					end
				end,
				0,
				"show_eigth_text_pointer"
			)

			-- Fourth action in the tour. This displays, "This icon shows you are attacking a settlement with walls. Move your cursor over it to view the walls' remaining strength."
			tour_pre_battle_screen:action(
				function()
					out("STARTING AN ACTION 9 IN TOUR 1")

					local uic = find_uicomponent(core:get_ui_root(), "icon_wall_integrity")

					if uic and uic:Visible(true) then
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
						text_pointer_test_first_siege:set_close_button_callback(function() cm:callback(function() tour_pre_battle_screen:start("show_tenth_text_pointer") end, 0.5) end)
						text_pointer_test_first_siege:show()
					else
						core:hide_fullscreen_highlight()
						end_scripted_tour_prologue(tour_pre_battle_screen, false, true, true, true)
					end
				end,
				0,
				"show_ninth_text_pointer"
			)

			-- Fourth action in the tour. This displays, "You can also build siege equipment to make the settlement easier to attack. Each piece of equipment costs Labour to build."
			tour_pre_battle_screen:action(
				function()
					out("STARTING AN ACTION 10 IN TOUR 1")

					local uic = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "mid", "battle_deployment", "regular_deployment", "list", "siege_information_panel", "attacker_recruitment_options", "equipment_frame", "tx_equipment")

					if uic and uic:Visible(true) then
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
						text_pointer_test_first_siege:set_close_button_callback(function() cm:callback(function() tour_pre_battle_screen:start("show_eleventh_text_pointer") end, 0.5) end)
						text_pointer_test_first_siege:show()
					else
						core:hide_fullscreen_highlight()
						end_scripted_tour_prologue(tour_pre_battle_screen, false, true, true, true)
					end
				end,
				0,
				"show_tenth_text_pointer"
			)

			-- Fifth action in the tour. This displays, "You can view your total Labour here and how much you can spend per turn."
			tour_pre_battle_screen:action(
				function()
					out("STARTING AN ACTION 11 IN TOUR 1")

					local uic = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "mid", "battle_deployment", "regular_deployment", "list", "siege_information_panel", "attacker_recruitment_options", "labour_frame")

					if uic and uic:Visible(true) then
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
						text_pointer_test_first_siege:set_close_button_callback(function() cm:callback(function() tour_pre_battle_screen:start("show_twelfth_text_pointer") end, 0.5) end)
						text_pointer_test_first_siege:show()
					else
						core:hide_fullscreen_highlight()
						end_scripted_tour_prologue(tour_pre_battle_screen, false, true, true, true)
					end
				end,
				0,
				"show_eleventh_text_pointer"
			)

			-- Sxith action in the tour. This displays, "Once you've prepared your siege, press this button to begin your attack.."
			tour_pre_battle_screen:action(
				function()
					out("STARTING AN ACTION 12 IN TOUR 1")

					local uic = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "mid", "battle_deployment", "regular_deployment", "button_attack_container")

					if uic and uic:Visible(true) then
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
						text_pointer_test_first_siege:set_close_button_callback(
							function() 
								core:hide_fullscreen_highlight()
								end_scripted_tour_prologue(tour_pre_battle_screen, false, true, true, true)
							end
						)
						text_pointer_test_first_siege:show()
					else
						core:hide_fullscreen_highlight()
						end_scripted_tour_prologue(tour_pre_battle_screen, false, true, true, true)
					end
				end,
				0,
				"show_twelfth_text_pointer"
			)

			start_scripted_tour_prologue(tour_pre_battle_screen, nil, true, true, true)
		end,
		true
	);
end

function PrologueScriptedTourUnitsPanel()
	core:add_listener(
		"units_panel_button_press",
		"ComponentLClickUp",
		function(context) 
			return context.string == "button_info" and uicomponent_descended_from(UIComponent(context.component), "units_panel") and not uicomponent_descended_from(UIComponent(context.component), "recruitment_docker") and not agent_selected;
		end,
		function()

			local uic_button_help = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel", "button_info")
			uic_button_help:SetDisabled(true);
			allow_hotkeys(false) 
			local uic_units_panel = find_uicomponent(core:get_ui_root(), "units_panel");

			local tour_units_panel = scripted_tour:new(
				"test_tour_units_panel",
				function() uic_button_help:SetDisabled(false); out("FINISHED Units panel tour") core:remove_listener("Cancelling_Units_panel_tour") allow_hotkeys(true) ; end
			);

			tour_units_panel:add_fullscreen_highlight("main_units_panel");
			tour_units_panel:set_should_dismiss_advice_on_completion(false);
			tour_units_panel:set_show_skip_button(false);

			core:add_listener(
				"Cancelling_Units_panel_tour",
				"PanelClosedCampaign",
				function(context) 
					return context.string == "units_panel" 
				end,
				function()
					allow_hotkeys(true) 
					skip_all_scripted_tours();
				end,
				false
			);
			
					
			tour_units_panel:action(
				function() 
					out("STARTING AN ACTION 1 IN TOUR 1") 
					local text_pointer_test_2 = text_pointer:new_from_component(
						"test2_text_pointer",
						"bottom",
						100,
						uic_units_panel,
						0.5,
						0
					);
					
					text_pointer_test_2:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_units_panel_1_1");
					text_pointer_test_2:set_style("semitransparent");
					text_pointer_test_2:set_topmost(true);
					--text_pointer_test_2:set_label_offset(-100, 0);
					text_pointer_test_2:set_close_button_callback(function() tour_units_panel:start("show_second_text_pointer") end);
					text_pointer_test_2:set_highlight_close_button(2);
					text_pointer_test_2:show();
					pulse_uicomponent(uic_units_panel, 2, 6);
					
				end,
				0
			);

			local uic_units_panel_upkeep = find_uicomponent(core:get_ui_root(), "units_panel", "dy_upkeep");

			local text_pointer_test_3 = text_pointer:new_from_component(
				"test3_text_pointer",
				"bottom",
				100,
				uic_units_panel_upkeep,
				0.5,
				0
			);

			tour_units_panel:action(
				function() 
					out("STARTING AN ACTION 2 IN TOUR 1") 
			
					pulse_uicomponent(uic_units_panel, false);
					tour_units_panel:show_fullscreen_highlight(false);
					core:show_fullscreen_highlight_around_components(0, false, true, uic_units_panel_upkeep);

					text_pointer_test_3:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_units_panel_1_2");
					text_pointer_test_3:set_style("semitransparent");
					text_pointer_test_3:set_topmost(true);
					text_pointer_test_3:set_close_button_callback(function() tour_units_panel:start("show_fourth_text_pointer") end);
					text_pointer_test_3:set_highlight_close_button(2);
					text_pointer_test_3:show();
					
				end,
				0,
				"show_second_text_pointer"
			);

			tour_units_panel:action(
				function() 
					out("STARTING AN ACTION 4 IN TOUR 1") 
					core:hide_fullscreen_highlight();
					
					local uic_units = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel", "units")
					local uic_replenish_icon_target
					local uic_units_child_target
					if uic_units and uic_units:ChildCount() > 0 then
						for i = 0, uic_units:ChildCount() - 1 do
							local uic_units_child = UIComponent(uic_units:Find(uic_units:ChildCount() - (1 + i)))
							local uic_replenish_icon = find_uicomponent(uic_units_child:Id(), "replenish_icon")
							
							if uic_replenish_icon and uic_replenish_icon:Visible() then
								uic_units_child_target = uic_units_child
								uic_replenish_icon_target = uic_replenish_icon
							end
						end
					end

					if uic_units_child_target and uic_replenish_icon_target then
						core:show_fullscreen_highlight_around_components(0, false, false, find_uicomponent(core:get_ui_root(), "units_panel", uic_units_child_target:Id()));

						local text_pointer_test_5 = text_pointer:new_from_component(
							"test5_text_pointer",
							"bottom",
							130,
							uic_replenish_icon_target,
							0.5,
							0
						);

						text_pointer_test_5:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_units_panel_1_3");
						text_pointer_test_5:set_style("semitransparent");
						text_pointer_test_5:set_topmost(true);
						--text_pointer_test_5:set_label_offset(100, 0);
						text_pointer_test_5:set_close_button_callback(function() core:hide_fullscreen_highlight(); end_scripted_tour_prologue(tour_units_panel, false, true, true, true) end);
						text_pointer_test_5:set_highlight_close_button(2);
						text_pointer_test_5:show();
					else
						end_scripted_tour_prologue(tour_units_panel, false, true, true, true)
					end
				end,
				0,
				"show_fourth_text_pointer"
			);
			start_scripted_tour_prologue(tour_units_panel, nil, true, true, true)
		end,
		true
	);
end


function PrologueScriptedTourUnitRecruitment()
	core:add_listener(
		"unit_recruitment_button_press",
		"ComponentLClickUp",
		function(context) 
			return context.string == "button_info" and uicomponent_descended_from(UIComponent(context.component), "units_panel") and uicomponent_descended_from(UIComponent(context.component), "recruitment_docker");
		end,
		function()
			local uic_first_unit
			local uic_button_help = find_uicomponent(core:get_ui_root(), "recruitment_docker", "button_info")
			uic_button_help:SetDisabled(true);
			
			local uic_unit_recruitment = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel", "recruitment_docker");

			local tour_unit_recruitment = scripted_tour:new(
				"test_tour_unit_recruitment",
				function() uic_button_help:SetDisabled(false); out("FINISHED Units panel tour") end
			);
			
			tour_unit_recruitment:add_fullscreen_highlight("recruitment_options");
			tour_unit_recruitment:set_should_dismiss_advice_on_completion(false);
			tour_unit_recruitment:set_show_skip_button(false);
					
			tour_unit_recruitment:action(
				function() 
					out("STARTING AN ACTION 1 IN TOUR 1") 
					local text_pointer_test_2 = text_pointer:new_from_component(
						"test2_text_pointer",
						"right",
						100,
						uic_unit_recruitment,
						0,
						0.6
					);
					
					text_pointer_test_2:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_recruitment_panel_1_1");
					text_pointer_test_2:set_style("semitransparent");
					text_pointer_test_2:set_topmost(true);
					--text_pointer_test_2:set_label_offset(-100, 0);
					text_pointer_test_2:set_close_button_callback(function() tour_unit_recruitment:start("show_second_text_pointer") end);
					text_pointer_test_2:set_highlight_close_button(2);
					text_pointer_test_2:show();
					pulse_uicomponent(uic_unit_recruitment, 2, 6);
					
				end,
				0
			);

			uic_first_unit = find_uicomponent(core:get_ui_root(), "units_panel", "recruitment_docker", "recruitment_options", "recruitment_listbox", "global", "unit_list", "listview", "list_clip")
			
			tour_unit_recruitment:action(
				function() 
					out("STARTING AN ACTION 2 IN TOUR 1") 
					
					pulse_uicomponent(uic_unit_recruitment, false);
					tour_unit_recruitment:show_fullscreen_highlight(false);

					core:show_fullscreen_highlight_around_components(0, false, true, uic_first_unit);

					local text_pointer_test_3 = text_pointer:new_from_component(
						"test3_text_pointer",
						"right",
						100,
						uic_first_unit,
						0,
						0.5
					);

					text_pointer_test_3:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_recruitment_panel_1_2");
					text_pointer_test_3:set_style("semitransparent");
					text_pointer_test_3:set_topmost(true);
					text_pointer_test_3:set_close_button_callback(function() tour_unit_recruitment:start("show_third_text_pointer") end);
					text_pointer_test_3:set_highlight_close_button(2);
					text_pointer_test_3:show();
					
				end,
				0,
				"show_second_text_pointer"
			);

			tour_unit_recruitment:action(
				function() 
					out("STARTING AN ACTION 3 IN TOUR 1") 
					
					core:hide_fullscreen_highlight();
					--tour_unit_recruitment:add_fullscreen_highlight("units_panel", "wh3_main_ksl_inf_kossars_1_recruitable", "UpkeepCost");
					--tour_unit_recruitment:add_fullscreen_highlight("units_panel", "wh3_main_ksl_inf_kossars_1_recruitable", "RecruitmentCost");
					core:show_fullscreen_highlight_around_components(0, false, true, uic_first_unit);
					--core:show_fullscreen_highlight_around_components(0, false, true, uic_unit_recruitment_cost_2);

					local text_pointer_test_4 = text_pointer:new_from_component(
						"test4_text_pointer",
						"right",
						100,
						uic_first_unit,
						0,
						0.82
					);

					text_pointer_test_4:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_recruitment_panel_1_3");
					text_pointer_test_4:set_style("semitransparent");
					text_pointer_test_4:set_topmost(true);
					text_pointer_test_4:set_close_button_callback(function() tour_unit_recruitment:start("show_fourth_text_pointer") end);
					text_pointer_test_4:set_highlight_close_button(2);
					text_pointer_test_4:show();
					
				end,
				0,
				"show_third_text_pointer"
			);

			tour_unit_recruitment:action(
				function() 
					out("STARTING AN ACTION 4 IN TOUR 1") 
					
					core:hide_fullscreen_highlight();
					--tour_unit_recruitment:add_fullscreen_highlight("units_panel", "wh3_main_ksl_inf_kossars_1_recruitable", "UpkeepCost");
					--tour_unit_recruitment:add_fullscreen_highlight("units_panel", "wh3_main_ksl_inf_kossars_1_recruitable", "RecruitmentCost");
					core:show_fullscreen_highlight_around_components(0, false, true, uic_first_unit);
					--core:show_fullscreen_highlight_around_components(0, false, true, uic_unit_recruitment_cost_2);

					local text_pointer_test_5 = text_pointer:new_from_component(
						"test5_text_pointer",
						"right",
						100,
						uic_first_unit,
						0,
						0.92
					);

					text_pointer_test_5:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_recruitment_panel_1_4");
					text_pointer_test_5:set_style("semitransparent");
					text_pointer_test_5:set_topmost(true);
					text_pointer_test_5:set_close_button_callback(function() tour_unit_recruitment:start("show_fifth_text_pointer") end);
					text_pointer_test_5:set_highlight_close_button(2);
					text_pointer_test_5:show();
					
				end,
				0,
				"show_fourth_text_pointer"
			);

			local uic_unit_recruitment_slots = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel", "recruitment_docker", "recruitment_options", "recruitment_listbox", "global", "recruitment_cap", "capacity_listview")
			tour_unit_recruitment:action(
				function() 
					out("STARTING AN ACTION 5 IN TOUR 1") 
					core:hide_fullscreen_highlight();
					
					core:show_fullscreen_highlight_around_components(0, false, true, uic_unit_recruitment_slots);

					local text_pointer_test_6 = text_pointer:new_from_component(
						"test6_text_pointer",
						"left",
						100,
						uic_unit_recruitment_slots,
						1, 
						0.5
					);

					text_pointer_test_6:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_recruitment_panel_1_5");
					text_pointer_test_6:set_style("semitransparent");
					text_pointer_test_6:set_topmost(true);
					--text_pointer_test_5:set_label_offset(100, 0);
					text_pointer_test_6:set_close_button_callback(function() core:hide_fullscreen_highlight(); end_scripted_tour_prologue(tour_unit_recruitment, false, true, true, true) end);
					text_pointer_test_6:set_highlight_close_button(2);
					text_pointer_test_6:show();
					
				end,
				0,
				"show_fifth_text_pointer"
			);
			
			start_scripted_tour_prologue(tour_unit_recruitment, nil, true, true, true)
		end,
		true
	);
end

function PrologueScriptedTourGeneralDetails()
	core:add_listener(
		"general_details_button_press",
		"ComponentLClickUp",
		function(context) 
			if not (context.string == "button_info" and uicomponent_descended_from(UIComponent(context.component), "character_details_panel")) then
				return false;
			end;
			
			local uic_details = find_uicomponent(core:get_ui_root(), "character_details_panel", "TabGroup", "details");
			
			if not uic_details then
				out("details not found")
			end;

			return uic_details and uic_details:CurrentState() == "selected";
		end,
		function()
			local uic_button_help = find_uicomponent(core:get_ui_root(), "character_details_panel", "character_context_parent", "button_info")
			uic_button_help:SetDisabled(true);
			
			local uic_banners = find_uicomponent(core:get_ui_root(), "character_details_panel", "ancillary_parent", "general_ancillaries_equipped");
			local uic_items = find_uicomponent(core:get_ui_root(), "character_details_panel", "ancillary_parent", "magic_items_equiped");

			local tour_items_banners = scripted_tour:new(
				"test_tour_general_details",
				function() uic_button_help:SetDisabled(false); out("FINISHED General details panel tour") end
			);
			
			
			tour_items_banners:set_show_skip_button(false);
			tour_items_banners:set_should_dismiss_advice_on_completion(false);
			tour_items_banners:add_skip_action(
				function()
					CampaignUI.ClosePanel("character_details_panel");	
				end
			);

			local text_pointer_test_1 = text_pointer:new_from_component(
				"test1_text_pointer",
				"right",
				50,
				uic_items, 
				0, 
				0.5
			);

			tour_items_banners:action(
				function() 
					out("STARTING AN ACTION 2 IN TOUR 1") 
					--text_pointer_test_2:hide();
					
					core:show_fullscreen_highlight_around_components(0, false, true, uic_items);

					text_pointer_test_1:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_general_details_1_1");
					text_pointer_test_1:set_style("semitransparent");
					text_pointer_test_1:set_topmost(true);
					text_pointer_test_1:set_close_button_callback(function() cm:callback(function() tour_items_banners:start("show_first_text_pointer") end, 0.5) end);
					text_pointer_test_1:set_highlight_close_button(2);
					text_pointer_test_1:show();
					pulse_uicomponent(uic_items, 2, 6);
					
				end,
				0
			);
					
			tour_items_banners:action(
				function() 
					out("STARTING AN ACTION 1 IN TOUR 1") 

					core:hide_fullscreen_highlight();
					pulse_uicomponent(uic_items, false);
					core:show_fullscreen_highlight_around_components(0, false, true, uic_banners);

					local text_pointer_test_2 = text_pointer:new_from_component(
						"test2_text_pointer",
						"right",
						50,
						uic_banners,
						0,
						0.5
					);
					
					text_pointer_test_2:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_general_details_1_2");
					text_pointer_test_2:set_style("semitransparent");
					text_pointer_test_2:set_topmost(true);
					text_pointer_test_2:set_close_button_callback(function() cm:callback(function() tour_items_banners:start("show_third_text_pointer") end, 0.5) end);
					text_pointer_test_2:set_highlight_close_button(2);
					text_pointer_test_2:show();

				end,
				0,
				"show_first_text_pointer"
			);

			local uic_effects = find_uicomponent(core:get_ui_root(), "character_details_panel", "stats_effects_holder");
			tour_items_banners:action(
				function() 
					out("STARTING AN ACTION 3 IN TOUR 1") 
					
					core:hide_fullscreen_highlight();
					
					core:show_fullscreen_highlight_around_components(0, false, true, uic_effects);

					local text_pointer_test_4 = text_pointer:new_from_component(
						"test4_text_pointer",
						"left",
						50,
						uic_effects,
						1, 
						0.5
					);

					text_pointer_test_4:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_general_details_1_4");
					text_pointer_test_4:set_style("semitransparent");
					text_pointer_test_4:set_topmost(true);
					text_pointer_test_4:set_close_button_callback(function() core:hide_fullscreen_highlight(); end_scripted_tour_prologue(tour_items_banners, false, true, true, true) end);
					text_pointer_test_4:set_highlight_close_button(2);
					text_pointer_test_4:show();
					
				end,
				0,
				"show_third_text_pointer"
			);
			start_scripted_tour_prologue(tour_items_banners, nil, true, true, true)
		end,
		true
	);
end

function PrologueScriptedTourMissionPanel()
	core:add_listener(
		"mission_panel_button_press",
		"ComponentLClickUp",
		function(context) 
			return context.string == "button_info" and uicomponent_descended_from(UIComponent(context.component), "objectives_screen");
		end,
		function()

			completely_lock_input(true)
			allow_hotkeys(false)
			local skip = false;

			local uic_button_help = find_uicomponent(core:get_ui_root(), "objectives_screen", "button_info")
			uic_button_help:SetDisabled(true);
			pulse_uicomponent(uic_button_help, false, 3, false);
			
			local uic_missions_panel = find_uicomponent(core:get_ui_root(), "objectives_screen");
			
			local tour_missions_panel = scripted_tour:new(
				"test_tour_missions_panel",
				function() 
					local uic_button_close = find_uicomponent(core:get_ui_root(), "hud_campaign", "hud_center_docker", "hud_center", "small_bar", "button_close_holder", "button_close")

					if skip == false then
						uic_button_close:Highlight(true, false, 0)
						pulse_uicomponent(uic_button_help, false, 0, false);
						
						core:add_listener(
							"PanelClosedCampaignStopHighlightCloseButton",
							"PanelClosedCampaign",
							function(context) return context.string == "objectives_screen" end,
							function() uic_button_close:Highlight(false, false, 0); pulse_uicomponent(uic_button_help, false, 3, false); end,
							true
						)

						uic_button_help:SetDisabled(false);
						cm:disable_shortcut("button_missions", "show_objectives", false)

						out("FINISHED mission panel tour") 
					else
						uic_button_help:SetDisabled(false);
						CampaignUI.ClosePanel("objectives_screen");
						pulse_uicomponent(uic_button_help, false, 3, false);
						pulse_uicomponent(uic_missions_panel, false);
						core:remove_listener("PanelClosedCampaignStopHighlightCloseButton");
						cm:steal_user_input(false);
					end
				end
			);
			
			tour_missions_panel:add_fullscreen_highlight("objectives_screen");
			tour_missions_panel:set_allow_fullscreen_highlight_window_interaction(false);
			tour_missions_panel:set_should_dismiss_advice_on_completion(false);
			tour_missions_panel:set_show_skip_button(false);
					
			tour_missions_panel:action(
				function() 
					out("STARTING AN ACTION 1 IN TOUR 1")
					
					cm:disable_shortcut("button_missions", "show_objectives", true)

					local uic_button_close = find_uicomponent(core:get_ui_root(), "hud_campaign", "hud_center_docker", "hud_center", "small_bar", "button_close_holder", "button_close")
					uic_button_close:Highlight(false, false, 0)

					local text_pointer_test_2 = text_pointer:new_from_component(
						"test2_text_pointer",
						"bottom",
						100,
						uic_missions_panel,
						0.5,
						0
					);
					
					text_pointer_test_2:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_missions_panel_1_1");
					text_pointer_test_2:set_style("semitransparent");
					text_pointer_test_2:set_topmost(true);
					text_pointer_test_2:set_close_button_callback(function() 
						if find_uicomponent(core:get_ui_root(), "hud_campaign", "mission_list") then
							tour_missions_panel:start("show_second_text_pointer") 
						else
							core:hide_fullscreen_highlight(); end_scripted_tour_prologue(tour_missions_panel, false, true, true, true);
						end
					end);
					text_pointer_test_2:set_highlight_close_button(2);
					text_pointer_test_2:show();
					pulse_uicomponent(uic_missions_panel, 2, 6);

					tour_missions_panel:add_skip_action(
						function()
							skip = true;
						end
					);
					
				end,
				0
			);

			local uic_missions_panel_pinned = find_uicomponent(core:get_ui_root(), "hud_campaign", "mission_list");

			local text_pointer_test_3 = text_pointer:new_from_component(
				"test3_text_pointer",
				"right",
				100,
				uic_missions_panel_pinned,
				0,
				0.5
			);

			tour_missions_panel:action(
				function() 
					out("STARTING AN ACTION 2 IN TOUR 1") 
					local uic_events_button = find_uicomponent(core:get_ui_root(), "tab_events");

					if uic_events_button and uic_events_button:CurrentState() == "selected" then
						uic_events_button:SimulateLClick();
					end
					
					pulse_uicomponent(uic_missions_panel, false);
					tour_missions_panel:show_fullscreen_highlight(false);

					core:show_fullscreen_highlight_around_components(0, false, true, uic_missions_panel_pinned);

					text_pointer_test_3:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_missions_panel_1_2");
					text_pointer_test_3:set_style("semitransparent");
					text_pointer_test_3:set_topmost(true);
					text_pointer_test_3:set_close_button_callback(function() core:hide_fullscreen_highlight(); end_scripted_tour_prologue(tour_missions_panel, false, true, true, true)  end);
					text_pointer_test_3:set_highlight_close_button(2);
					text_pointer_test_3:show();

					tour_missions_panel:add_skip_action(
						function()
							skip = true;
						end
					);
					
				end,
				0,
				"show_second_text_pointer"
			);

			cm:callback(function() start_scripted_tour_prologue(tour_missions_panel, nil, true, true, true) end, 0.5)
		end,
		true
	);
end

function PrologueScriptedTourLordRecruit()
	core:add_listener(
		"lord_recruit_panel_button_press",
		"ComponentLClickUp",
		function(context) 
			return context.string == "button_info" and uicomponent_descended_from(UIComponent(context.component), "character_panel");
		end,
		function()		

			local uic_button_help = find_uicomponent(core:get_ui_root(), "character_panel", "button_info")
			uic_button_help:SetDisabled(true);
			
			local uic_lord_recruit_panel = find_uicomponent(core:get_ui_root(), "character_panel");
			
			local tour_lord_recruit = scripted_tour:new(
				"tour_lord_recruit",
				function() uic_button_help:SetDisabled(false); out("FINISHED LORD RECRUITMENT TOUR") end
			);
			
			tour_lord_recruit:set_show_skip_button(false);
			tour_lord_recruit:set_should_dismiss_advice_on_completion(false);
			core:show_fullscreen_highlight_around_components(0, false, true, uic_lord_recruit_panel);
					
			tour_lord_recruit:action(
				function() 
					out("STARTING AN ACTION 1 IN TOUR 2") 
					local text_pointer_test_2 = text_pointer:new_from_component(
						"test2_text_pointer",
						"bottom",
						100,
						uic_lord_recruit_panel,
						0.5,
						0
					);
					
					text_pointer_test_2:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_lord_recruitment_panel_1_1");
					text_pointer_test_2:set_style("semitransparent");
					text_pointer_test_2:set_topmost(true);
					text_pointer_test_2:set_close_button_callback(function() tour_lord_recruit:start("show_second_text_pointer") end);
					text_pointer_test_2:set_highlight_close_button(2);
					text_pointer_test_2:show();
					
				end,
				0
			);

			--local uic_upkeep = find_uicomponent(core:get_ui_root(), "character_panel", "general_candidate_0_", "UpKeepCost");
			--local uic_cost = find_uicomponent(core:get_ui_root(), "character_panel", "general_candidate_0_", "RecruitmentCost");
			local uic_general = find_uicomponent(core:get_ui_root(), "character_panel", "listview");

			local text_pointer_test_3 = text_pointer:new_from_component(
				"test3_text_pointer",
				"left",
				100,
				uic_general,
				1,
				0.5
			);

			tour_lord_recruit:action(
				function() 
					out("STARTING AN ACTION 2 IN TOUR 1") 
					core:hide_fullscreen_highlight();
					tour_lord_recruit:show_fullscreen_highlight(false);
					core:show_fullscreen_highlight_around_components(0, false, true, uic_general);

					text_pointer_test_3:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_lord_recruitment_panel_1_2");
					text_pointer_test_3:set_style("semitransparent");
					text_pointer_test_3:set_topmost(true);
					text_pointer_test_3:set_close_button_callback(function() core:hide_fullscreen_highlight(); end_scripted_tour_prologue(tour_lord_recruit, false, true, true, true) end);
					text_pointer_test_3:set_highlight_close_button(2);
					text_pointer_test_3:show();
					
				end,
				0,
				"show_second_text_pointer"
			);

			start_scripted_tour_prologue(tour_lord_recruit, nil, true, true, true)
		end,
		true		

	);
end

function PrologueScriptedTourTechnologyPanel()
	core:add_listener(
		"technology_panel_button_press",
		"ComponentLClickUp",
		function(context) 
			return context.string == "button_info" and uicomponent_descended_from(UIComponent(context.component), "technology_panel");
		end,
		function()
		
			local uic_button_help = find_uicomponent(core:get_ui_root(), "technology_panel", "button_info");
			uic_button_help:SetDisabled(true);

			local uic_technology = find_uicomponent(core:get_ui_root(), "technology_panel", "tree_parent", "wh3_main_tech_ksl_1_1_prologue");
		
			local tour_technology_panel = scripted_tour:new(
				"test_tour_technology_panel",
				function() uic_button_help:SetDisabled(false); out("FINISHED Technology panel tour") end
			);
			
			tour_technology_panel:set_show_skip_button(false);
			tour_technology_panel:set_should_dismiss_advice_on_completion(false);
			tour_technology_panel:add_fullscreen_highlight("technology_panel");
			tour_technology_panel:action(
				function() 
					out("STARTING AN ACTION 2 IN TOUR 1") 
					core:hide_fullscreen_highlight();
					core:show_fullscreen_highlight_around_components(0, false, true, uic_technology);

					local text_pointer_test_3 = text_pointer:new_from_component(
						"test3_text_pointer",
						"top",
						50,
						uic_technology,
						0.7,
						1
					);

					text_pointer_test_3:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_technology_panel_1_2");
					text_pointer_test_3:set_style("semitransparent");
					text_pointer_test_3:set_topmost(true);
					text_pointer_test_3:set_close_button_callback(function() 
						
						local uic_technology_time = find_uicomponent(core:get_ui_root(), "technology_panel", "tree_parent", "wh3_main_tech_ksl_1_1_prologue", "dy_time");
						if uic_technology_time == false then
							tour_technology_panel:start("show_fourth_text_pointer"); 
						else 
							text_pointer_test_3:hide(); 
							tour_technology_panel:start("show_third_text_pointer"); 
						end
					end);
					text_pointer_test_3:set_highlight_close_button(2);
					text_pointer_test_3:set_hide_on_close_button_clicked(false);
					text_pointer_test_3:show();
					
				end,
				0,
				"show_second_text_pointer"
			);

			local uic_technology_time = find_uicomponent(core:get_ui_root(), "technology_panel", "tree_parent", "wh3_main_tech_ksl_1_1_prologue", "dy_time");
			tour_technology_panel:action(
				function() 
					out("STARTING AN ACTION 3 IN TOUR 1") 

					core:hide_fullscreen_highlight();
					
					core:show_fullscreen_highlight_around_components(25, false, true, uic_technology_time);
					

					local text_pointer_test_4 = text_pointer:new_from_component(
						"test4_text_pointer",
						"top",
						50,
						uic_technology_time,
						0.5,
						1
					);

					text_pointer_test_4:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_technology_panel_1_3");
					text_pointer_test_4:set_style("semitransparent");
					text_pointer_test_4:set_topmost(true);
					text_pointer_test_4:set_close_button_callback(function() core:hide_fullscreen_highlight(); end_scripted_tour_prologue(tour_technology_panel, false, true, true, true) end);
					text_pointer_test_4:set_highlight_close_button(2);
					text_pointer_test_4:show();
					
				end,
				0,
				"show_third_text_pointer"
			);

			tour_technology_panel:action(
				function() 
					out("STARTING AN ACTION 4 IN TOUR 1") 
			
					core:hide_fullscreen_highlight();

					local text_pointer_test_5 = text_pointer:new_from_component(
						"test5_text_pointer",
						"bottom",
						0,
						uic_technology,
						0.5,
						0
					);

					text_pointer_test_5:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_settlement_panel_1_4");
					text_pointer_test_5:set_style("semitransparent");
					text_pointer_test_5:set_topmost(true);
					text_pointer_test_5:set_label_offset(100, -150);
					text_pointer_test_5:set_close_button_callback(function() end_scripted_tour_prologue(tour_technology_panel, false, true, true, true) end);
					text_pointer_test_5:set_highlight_close_button(2);
					text_pointer_test_5:show();
					
				end,
				0,
				"show_fourth_text_pointer"
			);
			start_scripted_tour_prologue(tour_technology_panel, "show_second_text_pointer", true, true, true)
			
		end,
		true
	);
end

function PrologueScriptedTourAgents()
	core:add_listener(
		"units_panel_button_press",
		"ComponentLClickUp",
		function(context) 
			return context.string == "button_info" and uicomponent_descended_from(UIComponent(context.component), "units_panel") and not uicomponent_descended_from(UIComponent(context.component), "recruitment_docker") and agent_selected;
		end,
		function()
			completely_lock_input(true)
			allow_hotkeys(false)

			local uic_agent_details
			local uic_targeted_effects
			local uic_embedded_effects
			local tour_agents = scripted_tour:new("tour_agents", function() completely_lock_input(false); allow_hotkeys(true) end)
		
			tour_agents:set_should_dismiss_advice_on_completion(false);

			tour_agents:action(
				function()
					out("STARTING_SCRIPTED_TOUR_I_AGENTS_1")
					core:show_fullscreen_highlight_around_components(0, false, false, uic_agent_details);

					local tp = text_pointer:new_from_component(
						"tp_scripted_tour",
						"left",
						100,
						uic_agent_details,
						1,
						0.5
					)	
					tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_i_agents_1")
					tp:set_style("semitransparent")
					tp:set_topmost(true)
					tp:set_highlight_close_button(0.5)
					tp:set_close_button_callback(function() core:hide_fullscreen_highlight(); cm:callback(function() tour_agents:start("tour_agents_2") end, 0.5) end)
					tp:show()		
				end, 0,
			"tour_agents_1"
			)
		
			tour_agents:action(
				function()
					out("STARTING_SCRIPTED_TOUR_I_AGENTS_2")
					core:show_fullscreen_highlight_around_components(0, false, false, uic_targeted_effects);
		
					local tp = text_pointer:new_from_component(
						"tp_scripted_tour",
						"left",
						100,
						uic_targeted_effects,
						1,
						0.5
					)	
					tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_i_agents_2")
					tp:set_style("semitransparent")
					tp:set_topmost(true)
					tp:set_highlight_close_button(0.5)
					tp:set_close_button_callback(function() core:hide_fullscreen_highlight(); cm:callback(function() tour_agents:start("tour_agents_3") end, 0.5) end)
					tp:show()		
				end, 0,
			"tour_agents_2"
			)
		
			tour_agents:action(
				function()
					out("STARTING_SCRIPTED_TOUR_I_AGENTS_3")
					core:show_fullscreen_highlight_around_components(0, false, false, uic_embedded_effects);
		
					local tp = text_pointer:new_from_component(
						"tp_scripted_tour",
						"bottom",
						100,
						uic_embedded_effects,
						0.5,
						0
					)	
					tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_i_agents_3")
					tp:set_style("semitransparent")
					tp:set_topmost(true)
					tp:set_highlight_close_button(0.5)
					tp:set_close_button_callback(function() core:hide_fullscreen_highlight(); tour_agents:complete() end)
					tp:show()		
				end, 0,
			"tour_agents_3"
			)
		
			cm:callback(
				function ()		
					local tour_started
					local uic_button_info_toggle = find_uicomponent(core:get_ui_root(), "unit_info_panel_holder", "button_holder", "info_toggle_holder", "button_info_toggle")
					local function cancel_agents_scripted_tour ()
						completely_lock_input(false)
						allow_hotkeys(true)
					end
					local function prepare_agents_scripted_tour ()	
						uic_agent_details = find_uicomponent(core:get_ui_root(), "unit_info_panel_holder", "agent_details")
						uic_targeted_effects = find_child_uicomponent_by_index(find_uicomponent(core:get_ui_root(), "unit_info_panel_holder", "agent_details", "action_list"), 1)
						uic_embedded_effects = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel", "units", "AgentUnit 0")
						
						if uic_agent_details and uic_targeted_effects and uic_embedded_effects then
							tour_started = true
						else
							out("COULD NOT FIND UI COMPONENT - PROLOGUE_AGENTS_SCRIPTED_TOUR")
						end
						
						if tour_started then
							tour_agents:set_show_skip_button(false)
							tour_agents:start("tour_agents_1")
						else
							cancel_agents_scripted_tour()
						end
					end
				
					if uic_button_info_toggle and uic_button_info_toggle:Visible(true) then
						if uic_button_info_toggle:CurrentState() ~= "active" then
							cm:steal_user_input(false)
							uic_button_info_toggle:SimulateLClick()
							cm:steal_user_input(true)
							cm:callback(function () prepare_agents_scripted_tour() end, 0.5)
						else
							prepare_agents_scripted_tour()
						end
					else
						out("Could not find 'button_info_toggle'")
						cancel_agents_scripted_tour()
					end
				end,
			0.5)
		end,
		true
	);
end

function PrologueScriptedTourDiplomacy()
	core:add_listener(
		"units_panel_button_press",
		"ComponentLClickUp",
		function(context) 
			return context.string == "button_info" and uicomponent_descended_from(UIComponent(context.component), "diplomacy_dropdown")
		end,
		function()
			completely_lock_input(true)
			allow_hotkeys(false)
			cm:steal_escape_key(true)
			local uic_faction_panel
			local uic_offers_panel
			local st = scripted_tour:new("st", function() completely_lock_input(false); allow_hotkeys(true) end)
			st:set_should_dismiss_advice_on_completion(false);
			st:action(
				function()
					out("STARTING_SCRIPTED_TOUR_I_DIPLOMACY_1")
					core:show_fullscreen_highlight_around_components(10, false, false, uic_faction_panel);

					local tp = text_pointer:new_from_component(
						"tp_scripted_tour",
						"bottom",
						100,
						uic_faction_panel,
						0.5,
						0
					)	
					tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_i_diplomacy_1")
					tp:set_style("semitransparent")
					tp:set_topmost(true)
					tp:set_highlight_close_button(0.5)
					tp:set_close_button_callback(function() core:hide_fullscreen_highlight(); cm:callback(function() st:start("st_2") end, 0.5) end)
					tp:show()		
				end, 0,
			"st_1"
			)

			st:action(
				function()
					out("STARTING_SCRIPTED_TOUR_I_DIPLOMACY_2")
					local uic = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown", "faction_panel", "faction_panel_top", "sortable_list_factions", "list_clip", "list_box")
					core:show_fullscreen_highlight_around_components(10, false, false, uic);

					local tp = text_pointer:new_from_component(
						"tp_scripted_tour",
						"bottom",
						100,
						uic,
						0.5,
						0
					)	
					tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_i_diplomacy_2")
					tp:set_style("semitransparent")
					tp:set_topmost(true)
					tp:set_highlight_close_button(0.5)
					tp:set_close_button_callback(function() core:hide_fullscreen_highlight(); cm:callback(function() st:start("st_3") end, 0.5) end)
					tp:show()		
				end, 0,
			"st_2"
			)

			st:action(
				function()
					out("STARTING_SCRIPTED_TOUR_I_DIPLOMACY_3")
					local uic = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown", "faction_panel", "faction_panel_top", "sortable_list_factions", "list_clip", "list_box")
					local uic_2 = find_child_uicomponent_by_index(uic, 1)
					local uic_3 = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown", "faction_panel", "faction_panel_top", "sortable_list_factions", "list_clip", "list_box", uic_2:Id(), "strength_balance_bar")
					core:show_fullscreen_highlight_around_components(10, false, false, uic_3);

					local tp = text_pointer:new_from_component(
						"tp_scripted_tour",
						"right",
						100,
						uic_3,
						0,
						0.5
					)	
					tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_i_diplomacy_3")
					tp:set_style("semitransparent")
					tp:set_topmost(true)
					tp:set_highlight_close_button(0.5)
					tp:set_close_button_callback(function() core:hide_fullscreen_highlight(); cm:callback(function() st:start("st_4") end, 0.5) end)
					tp:show()		
				end, 0,
			"st_3"
			)

			st:action(
				function()
					out("STARTING_SCRIPTED_TOUR_I_DIPLOMACY_4")
					local uic = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown", "faction_panel", "faction_panel_top", "sortable_list_factions", "list_clip", "list_box")
					local uic_2 = find_child_uicomponent_by_index(uic, 1)
					local uic_3 = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown", "faction_panel", "faction_panel_top", "sortable_list_factions", "list_clip", "list_box", uic_2:Id(), "attitude")
					core:show_fullscreen_highlight_around_components(10, false, false, uic_3);

					local tp = text_pointer:new_from_component(
						"tp_scripted_tour",
						"right",
						100,
						uic_3,
						0,
						0.5
					)	
					tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_i_diplomacy_4")
					tp:set_style("semitransparent")
					tp:set_topmost(true)
					tp:set_highlight_close_button(0.5)
					tp:set_close_button_callback(function() core:hide_fullscreen_highlight(); cm:callback(function() st:start("st_5") end, 0.5) end)
					tp:show()		
				end, 0,
			"st_4"
			)

			st:action(
				function()
					out("STARTING_SCRIPTED_TOUR_I_DIPLOMACY_5")
					local uic = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown", "faction_panel", "faction_panel_bottom", "both_buttongroup", "button_ok")
					core:show_fullscreen_highlight_around_components(10, false, false, uic);

					local tp = text_pointer:new_from_component(
						"tp_scripted_tour",
						"bottom",
						100,
						uic,
						0.5,
						0
					)	
					tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_i_diplomacy_5")
					tp:set_style("semitransparent")
					tp:set_topmost(true)
					tp:set_highlight_close_button(0.5)
					tp:set_close_button_callback(function() core:hide_fullscreen_highlight(); st:complete() end)
					tp:show()		
				end, 0,
			"st_5"
			)

			st:action(
				function()
					out("STARTING_SCRIPTED_TOUR_I_DIPLOMACY_DEALS_1")
					core:show_fullscreen_highlight_around_components(10, false, false, uic_offers_panel);

					local tp = text_pointer:new_from_component(
						"tp_scripted_tour",
						"bottom",
						100,
						uic_offers_panel,
						0.5,
						0
					)	
					tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_i_diplomacy_deals_1")
					tp:set_style("semitransparent")
					tp:set_topmost(true)
					tp:set_highlight_close_button(0.5)
					tp:set_close_button_callback(function() core:hide_fullscreen_highlight(); cm:callback(function() st:start("st_7") end, 0.5) end)
					tp:show()		
				end, 0,
			"st_6"
			)

			st:action(
				function()
					out("STARTING_SCRIPTED_TOUR_I_DIPLOMACY_DEALS_2")
					local uic = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown", "offers_panel", "panel_diplomacy", "offers_list_panel", "list_possible_actions")
					core:show_fullscreen_highlight_around_components(15, false, false, uic);

					local tp = text_pointer:new_from_component(
						"tp_scripted_tour",
						"bottom",
						100,
						uic,
						0.5,
						0
					)	
					tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_i_diplomacy_deals_2")
					tp:set_style("semitransparent")
					tp:set_topmost(true)
					tp:set_highlight_close_button(0.5)
					tp:set_close_button_callback(function() core:hide_fullscreen_highlight(); cm:callback(function() st:start("st_8") end, 0.5) end)
					tp:show()		
				end, 0,
			"st_7"
			)

			st:action(
				function()
					out("STARTING_SCRIPTED_TOUR_I_DIPLOMACY_DEALS_3")
					local uic = find_uicomponent(core:get_ui_root(), "diplomacy_dropdown", "offers_panel", "panel_diplomacy", "offers_list_panel", "button_set_holder")
					core:show_fullscreen_highlight_around_components(10, false, false, uic)

					local tp = text_pointer:new_from_component(
						"tp_scripted_tour",
						"bottom",
						100,
						uic,
						0.5,
						0
					)	
					tp:add_component_text("text", "ui_text_replacements_localised_text_prologue_scripted_tour_i_diplomacy_deals_3")
					tp:set_style("semitransparent")
					tp:set_topmost(true)
					tp:set_highlight_close_button(0.5)
					tp:set_close_button_callback(function() core:hide_fullscreen_highlight(); st:complete() end)
					tp:show()		
				end, 0,
			"st_8"
			)
		
			
			uic_faction_panel = find_uicomponent(core:get_ui_root(), "faction_panel")
			uic_offers_panel = find_uicomponent(core:get_ui_root(), "offers_panel")

			if uic_faction_panel and uic_faction_panel:Visible(true) then
				completely_lock_input(true)
				allow_hotkeys(false)
				st:set_show_skip_button(false)
				st:start("st_1")
			elseif uic_offers_panel and uic_offers_panel:Visible(true) then
				completely_lock_input(true)
				allow_hotkeys(false)
				st:set_show_skip_button(false)
				st:start("st_6")
			end
		end,
		true
	)
end

function ProloguePrepareAllScriptedTours()
	out("ADDING SETTLEMENT PANEL TRIGGER")
	PrologueScriptedTourSettlementPanel();
	PrologueScriptedTourPreBattleScreen();
	PrologueScriptedTourUnitsPanel();
	PrologueScriptedTourUnitRecruitment();
	PrologueScriptedTourGeneralDetails();
	PrologueScriptedTourSkillPoint();
	PrologueScriptedTourMissionPanel();
	PrologueScriptedTourLordRecruit();
	PrologueScriptedTourTechnologyPanel();
	PrologueScriptedTourAgents();
	PrologueScriptedTourDiplomacy()
end


ProloguePrepareAllScriptedTours();