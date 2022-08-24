




function st_deployment_add_unit_card_actions(st_deployment, unit_status_section_name, unit_status_tp_timing, next_section_to_trigger)

	local unit_card_with_status_icon = false;

	st_deployment:action(
		function()

			local uic = false;
			local text_pointer_horizontal_offset = 120;
			uic, unit_card_with_status_icon = st_deployment_get_unit_card_status_uicomponent();

			if not uic then
				st_deployment:start("st_deployment_unit_card_health");
				return;
			end;

			-- if we're pointing at the first or card then offset the label to the left to make room for other labels
			if unit_card_with_status_icon == 0 then
				text_pointer_horizontal_offset = -120;
			end;

			-- show text pointer for unit status icon
			st_deployment_show_unit_card_status_text_pointer(
				uic,
				text_pointer_horizontal_offset,
				function()
					st_deployment:start("st_deployment_unit_card_health_transition");
				end
			);
		end,
		unit_status_tp_timing,
		unit_status_section_name
	);

	st_deployment:action(
		function()
			st_deployment:start("st_deployment_unit_card_health");
		end,
		200,
		"st_deployment_unit_card_health_transition"
	);

	st_deployment:action(
		function()
			-- show text pointer for health bar

			-- work out a horizontal offset based on where the status icon pointer went
			local text_pointer_horizontal_offset = -105;

			-- if the status icon pointer has already bagged the first unit card, then point at the last
			-- (for unit_card_with_status_icon to be 0 there must be more than one unit card)
			local find_first = true;
			if unit_card_with_status_icon == 0 then
				text_pointer_horizontal_offset = 105;
				find_first = false;
			end;

			local uic = st_deployment_get_unit_card_health_uicomponent(find_first);
			if not uic then
				st_deployment:start("st_deployment_unit_card_xp");
				return;
			end;

			st_deployment_show_unit_card_health_text_pointer(
				uic,
				text_pointer_horizontal_offset,
				find_first,
				function()
					st_deployment:start("st_deployment_unit_card_xp_transition");
				end
			);
		end,
		0,
		"st_deployment_unit_card_health"
	);

	st_deployment:action(
		function()
			st_deployment:start("st_deployment_unit_card_xp");
		end,
		200,
		"st_deployment_unit_card_xp_transition"
	);

	st_deployment:action(
		function()
			-- show text pointer for xp icon

			local uic = st_deployment_get_unit_card_xp_uicomponent();
			if not uic then
				st_deployment:start("st_deployment_unit_card_ammo");
				return;
			end;

			st_deployment_show_unit_card_xp_text_pointer(
				uic,
				function()
					st_deployment:start("st_deployment_unit_card_ammo_transition");
				end
			);
		end,
		0,
		"st_deployment_unit_card_xp"
	);

	st_deployment:action(
		function()
			st_deployment:start("st_deployment_unit_card_ammo");
		end,
		200,
		"st_deployment_unit_card_ammo_transition"
	);

	st_deployment:action(
		function()
			-- show text pointer for ammo bar

			local uic, unit_card_num, text_pointer_line_length = st_deployment_get_unit_card_ammo_uicomponent();
			if not uic then
				st_deployment:start("st_deployment_unit_card_morale");
				return;
			end;

			st_deployment_show_unit_card_ammo_text_pointer(
				uic,
				unit_card_num, 
				text_pointer_line_length,
				function()
					st_deployment:start("st_deployment_unit_card_morale_transition");
				end
			);
		end,
		0,
		"st_deployment_unit_card_ammo"
	);

	st_deployment:action(
		function()
			st_deployment:start("st_deployment_unit_card_morale");
		end,
		200,
		"st_deployment_unit_card_morale_transition"
	);

	st_deployment:action(
		function()
			-- hide all text pointers currently being displayed

			core:hide_all_text_pointers();
		end,
		0,
		"st_deployment_unit_card_morale"
	);

	st_deployment:action(
		function()
			-- show morale text pointer (and set up morale/routing unit cards)

			uic_wavering_unit_card, uic_routing_unit_card = st_deployment_get_unit_card_morale_uicomponents();

			if not uic_wavering_unit_card then
				st_deployment:complete_sequence("st_deployment_unit_card_morale");
				st_deployment:start(next_section_to_trigger);
				return;	
			end;

			st_deployment_show_unit_card_morale_text_pointer(
				uic_wavering_unit_card,
				uic_routing_unit_card,
				function()
					bm:callback(function() st_deployment:start(next_section_to_trigger) end, 200);

				end
			);
		end,
		500,
		"st_deployment_unit_card_morale"
	);
end;
















-------------------------------------------------------------------------------
-- unit card status icon
-------------------------------------------------------------------------------

-- returns the last unit card status uicomponent if one is found, otherwise returns false
function st_deployment_get_unit_card_status_uicomponent()
	
	-- get unit card parent
	local uic_unit_card_parent = find_uicomponent(core:get_ui_root(), "battle_orders", "cards_panel", "review_DY");
	if not uic_unit_card_parent then
		return false;
	end;

	-- return false if there's only one unit card
	if uic_unit_card_parent:ChildCount() < 2 then
		return false;
	end;
	
	-- find last unit card with status list component visible
	for i = uic_unit_card_parent:ChildCount() - 1, 0, -1 do
		local uic_current_unit_card = UIComponent(uic_unit_card_parent:Find(i));
		uic_current_status = find_uicomponent(uic_current_unit_card, "battle", "status_list");
		
		if uic_current_status and uic_current_status:Visible(true) then
			return uic_current_status, i;
		end;
	end;
	
	return false;
end;

-- shows the unit card status icon text pointer
function st_deployment_show_unit_card_status_text_pointer(uic, text_pointer_horizontal_offset, end_callback)	
	-- set up text pointer
	local tp_status = text_pointer:new_from_component(
		"status",
		"bottom",
		60,
		uic,
		0.5,
		0
	);
	tp_status:add_component_text("text", "ui_text_replacements_localised_text_wh3_main_st_battle_unit_card_status");
	tp_status:set_style("semitransparent_highlight_dont_close");

	if text_pointer_horizontal_offset ~= 0 then
		tp_status:set_label_offset(text_pointer_horizontal_offset, 0);
	end;
	
	-- set close button behaviour
	tp_status:set_close_button_callback(
		function()
			buim:highlight_unit_cards(
				false, 		-- activate highlight
				nil, 		-- pulse strength override
				true, 		-- force highlight
				false, 		-- highlight health
				false, 		-- highlight ammo
				false, 		-- highlight xp
				true		-- highlight status
			);
			end_callback();
		end
	);

	-- pulse the uicomponent
	buim:highlight_unit_cards(
		true, 		-- activate highlight
		nil, 		-- pulse strength override
		true, 		-- force highlight
		false, 		-- highlight health
		false, 		-- highlight ammo
		false, 		-- highlight xp
		true		-- highlight status
	);
	
	-- display the text pointer
	tp_status:show();
end;







-------------------------------------------------------------------------------
-- unit card health bar
-------------------------------------------------------------------------------

-- returns the health bar of the first or last unit card if visible, false otherwise
function st_deployment_get_unit_card_health_uicomponent(find_first)
	
	-- find unit card parent
	local uic_unit_card_parent = find_uicomponent(core:get_ui_root(), "battle_orders", "cards_panel", "review_DY");
	if not uic_unit_card_parent then
		return false;
	end;

	-- work out if we are getting the first or last unit card
	local unit_card_to_find = 0;
	if not find_first then
		unit_card_to_find = uic_unit_card_parent:ChildCount() - 1;
	end;
	
	-- find unit card
	local uic_unit_card = UIComponent(uic_unit_card_parent:Find(unit_card_to_find));
	if not uic_unit_card then
		return false;
	end;

	-- find health bar
	local uic_health_bar = find_uicomponent(uic_unit_card, "health_frame");
	if not uic_health_bar then
		return false;
	end;
	
	return uic_health_bar;
end;

-- shows the unit card health bar text pointer
function st_deployment_show_unit_card_health_text_pointer(uic, text_pointer_horizontal_offset, is_first_uic, end_callback)

	-- if we're pointing at the left-most card then point to the left side of it, otherwise point to the right-most side of it
	local x_offset = 0.1;
	if not is_first_uic then
		x_offset = 0.9;
	end;

	-- set up text pointer
	local tp_health = text_pointer:new_from_component(
		"tp_health",
		"bottom",
		100,
		uic,
		x_offset,
		0.5
	);
	tp_health:add_component_text("text", "ui_text_replacements_localised_text_wh3_main_st_battle_unit_card_health");
	tp_health:set_style("semitransparent_highlight_dont_close");

	if text_pointer_horizontal_offset ~= 0 then
		tp_health:set_label_offset(text_pointer_horizontal_offset, 0);
	end;
	
	-- set close button behaviour
	tp_health:set_close_button_callback(
		function()
			buim:highlight_unit_cards(
				false, 		-- activate highlight
				nil, 		-- pulse strength override
				true, 		-- force highlight
				true, 		-- highlight health
				false, 		-- highlight ammo
				false, 		-- highlight xp
				false		-- highlight status
			);
			end_callback();
		end
	);

	buim:highlight_unit_cards(
		true, 		-- activate highlight
		nil, 		-- pulse strength override
		true, 		-- force highlight
		true, 		-- highlight health
		false, 		-- highlight ammo
		false, 		-- highlight xp
		false		-- highlight status
	);
	
	-- display the text pointer
	tp_health:show();
end;








-------------------------------------------------------------------------------
-- unit card xp icon
-------------------------------------------------------------------------------

-- returns the first visible xp icon, false otherwise
function st_deployment_get_unit_card_xp_uicomponent()
	
	-- find unit card parent
	local uic_unit_card_parent = find_uicomponent(core:get_ui_root(), "battle_orders", "cards_panel", "review_DY");
	if not uic_unit_card_parent then
		return false;
	end;
	
	for i = 0, uic_unit_card_parent:ChildCount() - 1 do
		local uic_unit_card = UIComponent(uic_unit_card_parent:Find(i));
		local uic_xp = find_uicomponent(uic_unit_card, "experience");
		
		if uic_xp and uic_xp:Visible(true) and uic_xp:CurrentState() ~= "0" then
			return uic_xp, i, i * 60;			-- calculated number is length of line
		end;
	end;
	
	return false;
end;


-- shows the unit card xp bar text pointer
function st_deployment_show_unit_card_xp_text_pointer(uic, end_callback)

	-- set up text pointer
	local tp_xp = text_pointer:new_from_component(
		"xp",
		"right",
		100,
		uic,
		0.25,
		0.5
	);
	tp_xp:add_component_text("text", "ui_text_replacements_localised_text_wh3_main_st_battle_unit_card_xp");
	tp_xp:set_style("semitransparent_highlight_dont_close");
	
	-- set close button behaviour
	tp_xp:set_close_button_callback(
		function()
			buim:highlight_unit_cards(
				false, 		-- activate highlight
				nil, 		-- pulse strength override
				true, 		-- force highlight
				false, 		-- highlight health
				false, 		-- highlight ammo
				true, 		-- highlight xp
				false		-- highlight status
			);
			end_callback();
		end
	);

	buim:highlight_unit_cards(
		true, 		-- activate highlight
		nil, 		-- pulse strength override
		true, 		-- force highlight
		false, 		-- highlight health
		false, 		-- highlight ammo
		true, 		-- highlight xp
		false		-- highlight status
	);
	
	-- display the text pointer
	tp_xp:show();
end;









-------------------------------------------------------------------------------
-- unit card ammo bar
-------------------------------------------------------------------------------

-- returns the ammo bar of the last unit card if visible, as well as the unit card index and length of the text pointer line, or false otherwise
function st_deployment_get_unit_card_ammo_uicomponent()
	
	-- get unit card parent
	local uic_unit_card_parent = find_uicomponent(core:get_ui_root(), "battle_orders", "cards_panel", "review_DY");
	if not uic_unit_card_parent then
		return false;
	end;
	
	-- search backwards
	for i = uic_unit_card_parent:ChildCount() - 1, 0, -1 do
		local uic_ammo_bar = find_uicomponent(UIComponent(uic_unit_card_parent:Find(i)), "AmmoBar");
		
		if uic_ammo_bar and uic_ammo_bar:Visible() then
			return uic_ammo_bar, i, (uic_unit_card_parent:ChildCount() - i) * 60;			-- calculated number is length of line
		end;
	end;
	
	return false;
end;

-- shows the unit card ammo bar text pointer
function st_deployment_show_unit_card_ammo_text_pointer(uic, unit_card_num, text_pointer_line_length, end_callback)
		
	-- set up text pointer
	local tp_ammo = text_pointer:new_from_component(
		"tp_ammo",
		"left",
		60 + text_pointer_line_length,
		uic,
		0.75,
		0.5
	);
	tp_ammo:add_component_text("text", "ui_text_replacements_localised_text_wh3_main_st_battle_unit_card_ammo");
	tp_ammo:set_style("semitransparent_highlight_dont_close");
	
	-- set close button behaviour
	tp_ammo:set_close_button_callback(
		function()
			buim:highlight_unit_cards(
				false, 		-- activate highlight
				nil, 		-- pulse strength override
				true, 		-- force highlight
				false, 		-- highlight health
				true, 		-- highlight ammo
				false, 		-- highlight xp
				false		-- highlight status
			);
			end_callback();
		end
	);

	buim:highlight_unit_cards(
		true, 		-- activate highlight
		nil, 		-- pulse strength override
		true, 		-- force highlight
		false, 		-- highlight health
		true, 		-- highlight ammo
		false, 		-- highlight xp
		false		-- highlight status
	);
	
	-- display the text pointer
	tp_ammo:show();
end;










-------------------------------------------------------------------------------
-- unit card morale
-------------------------------------------------------------------------------

-- returns the last two unit cards if there are at least two on the army panel, or false otherwise
function st_deployment_get_unit_card_morale_uicomponents()
	
	-- get unit card parent
	local uic_unit_card_parent = find_uicomponent(core:get_ui_root(), "battle_orders", "cards_panel", "review_DY");
	if not uic_unit_card_parent then
		return false;
	end;

	if uic_unit_card_parent:ChildCount() < 2 then
		return false;
	end;

	return UIComponent(uic_unit_card_parent:Find(uic_unit_card_parent:ChildCount() - 2)), UIComponent(uic_unit_card_parent:Find(uic_unit_card_parent:ChildCount() - 1));
end;


function st_deployment_show_unit_card_morale_text_pointer(uic_wavering_unit_card, uic_routing_unit_card, end_callback)

	--Set up a metric variable to be used in campaign later
	core:svr_save_bool("sbool_prologue_second_battle_read_unit_cards_tutorial", true);

	core:hide_fullscreen_highlight();

	-- Gerik
	-- Victory in battle depends upon the morale of our soldiers. Unit cards tell you much about the will of our forces to fight.
	bm:queue_advisor("wh3_main_scenario_02_0025");

	-- artificially set unit card states to wavering/routing
	local uic_wavering_unit_card_cached_state = uic_wavering_unit_card:CurrentState();
	local uic_routing_unit_card_cached_state = uic_routing_unit_card:CurrentState();

	-- set up wavering text pointer
	local tp_wavering = text_pointer:new_from_component(
		"tp_wavering",
		"bottom",
		100,
		uic_wavering_unit_card,
		0.5,
		0.1
	);
	tp_wavering:add_component_text("text", "ui_text_replacements_localised_text_wh3_main_st_battle_unit_card_wavering");
	tp_wavering:set_style("semitransparent_highlight_dont_close");

	-- set up routing text pointer
	local tp_routing = text_pointer:new_from_component(
		"tp_routing",
		"left",
		100,
		uic_routing_unit_card,
		0.75,
		0.25
	);
	tp_routing:add_component_text("text", "ui_text_replacements_localised_text_wh3_main_st_battle_unit_card_routing");
	tp_routing:set_style("semitransparent_highlight");
	
	-- set close button behaviour
	tp_routing:set_close_button_callback(
		function()
			-- hide both visible text pointers
			core:hide_all_text_pointers();

			-- restore unit card cached states
			uic_wavering_unit_card:SetState(uic_wavering_unit_card_cached_state);
			uic_wavering_unit_card:SetInteractive(true);
			uic_routing_unit_card:SetState(uic_routing_unit_card_cached_state);
			uic_routing_unit_card:SetInteractive(true);

			bm:stop_advisor_queue(true)
			-- end
			end_callback();
		end
	);

	bm:progress_on_advice_dismissed(
		"st_deployment_wavering",
		function()
			-- display the text pointers
			tp_wavering:show();
							
			uic_wavering_unit_card:SetState("wavering");
			uic_wavering_unit_card:SetInteractive(false);
			uic_routing_unit_card:SetState("routing");
			uic_routing_unit_card:SetInteractive(false);

			-- activate fullscreen highlight
			core:show_fullscreen_highlight_around_components(30, nil, false, find_uicomponent(core:get_ui_root(), "battle_orders", "cards_panel"));

			-- TODO: if the host scripted tour is cancelled then it needs to know to cancel this callback. Refactor this so we don't call callback() here, or add a cancel action
			bm:callback(function() tp_routing:show() end, 500);
		end,
		100,
		true
	);

end;

-------------------------------------------------------------------------------
-- battle speed 
-------------------------------------------------------------------------------

function start_st_battle_speed (end_callback)

	local st_battle_speed = scripted_tour:new(
		"scripted_tour_battle_speed",
		function() if end_callback then end_callback() end end
	);

	st_battle_speed:action(
		function()
			out("Starting 'scripted_tour_battle_speed_action_1'")
				
				bm:disable_shortcut("toggle_pause", false);
				
				st_battle_speed:show_fullscreen_highlight(true)
				
				local speed_controls = find_uicomponent(core:get_ui_root(), "hud_battle", "radar_holder", "speed_controls")	
				local tp_from_component = text_pointer:new_from_component(
						"tp_from_component_speed_controls",
						"top",
						100,
						speed_controls,
						0.5,
						1
					)	
				tp_from_component:add_component_text("text", "ui_text_replacements_localised_text_prologue_text_pointer_battle_speed_modifiers")
				tp_from_component:set_style("semitransparent")
				tp_from_component:set_topmost(true)
				tp_from_component:set_highlight_close_button(0.5)
				tp_from_component:set_close_button_callback(function() core:remove_listener("ComponentLClickUpClickSpeedButton"); st_battle_speed:complete() end)
				tp_from_component:show()		


				core:add_listener(
					"ComponentLClickUpClickSpeedButton",
					"ComponentLClickUp",
					function(context) return context.string == "play" or context.string == "pause" 
						or context.string == "slow_mo" or context.string == "fwd" or context.string == "ffwd"end,
					function()
						tp_from_component:hide()
						st_battle_speed:complete()
					end,
					false
				);
		end,
		1,
		"scripted_tour_battle_speed_action_1"
	)

	st_battle_speed:set_show_skip_button(false)
	st_battle_speed:add_fullscreen_highlight("hud_battle", "radar_holder", "speed_controls")
	st_battle_speed:start("scripted_tour_battle_speed_action_1")
end