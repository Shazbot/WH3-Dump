

enable_scripted_tours = not (core:is_tweaker_set("DISABLE_FULL_SCRIPTED_TOURS") or core:is_tweaker_set("DISABLE_PRELUDE_CAMPAIGN_SCRIPTS"));
-- enable_scripted_tours = false;


function start_scripted_tours()
	if enable_scripted_tours then
		out("#### start_scripted_tours() ####");
		character_skill_point_tour:start();
		in_settlement_sieged_tour:start();

		--Starting Flesh Lab Scripted tour in here instead of early_game.lua so it is used in both campaigns
		local throt_interface = cm:get_faction("wh2_main_skv_clan_moulder");
		if throt_interface and throt_interface:is_human() then
			in_flesh_lab_tour:start();
		end

		--Starting Beastmen Panel Scripted tour in here instead of early_game.lua so it is used in both campaigns
		if cm:are_any_factions_human(nil, "wh_dlc03_bst_beastmen") then
			in_beastmen_panel_tour:start();
		end

		if cm:are_any_factions_human(nil, "wh3_dlc23_chd_chaos_dwarfs") then
			in_chd_minor_occupation_tour:start()
			in_chd_major_occupation_tour:start()
			in_chd_toz_tour:start()
			in_chd_industry_tour:start()
			in_chd_hellforge_armoury_tour:start()
			in_chd_hellforge_manufactory_tour:start()
			in_chd_labour_economy_tour:start()
		end
	end
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- Major Settlement Siege Tour
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
in_settlement_sieged_tour = intervention:new(
	"in_settlement_sieged_tour",			 							-- string name
	5, 																	-- cost
	function() trigger_settlement_siege_advice_tour() end,				-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

in_settlement_sieged_tour:set_wait_for_battle_complete(false);

in_settlement_sieged_tour:add_advice_key_precondition("war.camp.advice.siege_weapons.001");



in_settlement_sieged_tour:add_trigger_condition(
	"ScriptEventPreBattlePanelOpenedProvinceCapital",
	true
);

function trigger_settlement_siege_advice_tour()
	out("#### trigger_settlement_siege_advice_tour() ####");
	
	local advice_level = common.get_advice_level();
	out("\tAdvice: "..advice_level);
	
	-- Get a handle to the siege panel. This may fail if the siege advice intervention was queued up
	-- behind something else and the panel was closed before this got called.
	local uic_siege_panel = find_uicomponent(core:get_ui_root(), "siege_information_panel");
	if not uic_siege_panel then
		script_error("WARNING: trigger_settlement_siege_advice_tour() could not find uic_siege_panel, exiting tour prematurely");
		in_settlement_sieged_tour:cancel();
		return;
	end;

	if advice_level == 2 then
		-- Long advice
		cm:show_advice("war.camp.advice.siege_weapons.001");
		cm:add_infotext(1, "war.camp.advice.siege_warfare.info_001", "war.camp.advice.siege_warfare.info_002");
		
		core:progress_on_uicomponent_animation_finished(
			uic_siege_panel,		
			function()
				settlement_sieged_advice_tour(uic_siege_panel)
			end
		);
	else
		-- Short advice
		cm:show_advice("war.camp.advice.siege_weapons.001", true);
		cm:add_infotext(1, "war.camp.advice.siege_warfare.info_001", "war.camp.advice.siege_warfare.info_002", "war.camp.advice.siege_warfare.info_003");
		
		cm:progress_on_advice_dismissed(
			"trigger_settlement_siege_advice_tour",
			function()
				in_settlement_sieged_tour:complete();
			end, 
			0, 
			true
		);
	end
end

function settlement_sieged_advice_tour(uic_siege_panel)
	out("#### settlement_sieged_advice_tour() ####");
	
	local uim = cm:get_campaign_ui_manager();
	uim:override("selection_change"):lock();
	uim:override("esc_menu"):lock();
	
	local uic_size_x, uic_size_y = uic_siege_panel:Dimensions();
	local uic_pos_x, uic_pos_y = uic_siege_panel:Position();
	
	local tp_siege_panel = text_pointer:new("siege_panel", "right", 100, uic_pos_x + 50, uic_pos_y + (uic_size_y / 2));
	tp_siege_panel:set_layout("text_pointer_title_and_text");
	tp_siege_panel:add_component_text("title", "ui_text_replacements_localised_text_hp_campaign_title_siege_panel");
	tp_siege_panel:add_component_text("text", "ui_text_replacements_localised_text_hp_campaign_description_siege_panel");
	tp_siege_panel:set_style("semitransparent_highlight_dont_close");
	tp_siege_panel:set_panel_width(350);
	
	-- Shows the next text pointer when this one is closed
	tp_siege_panel:set_close_button_callback(
		function()
			pulse_uicomponent(uic_siege_panel, false, 3, true)
			start_surrender_timer_advice();
		end
	);
	
	-- Move advice topmost
	core:cache_and_set_advisor_priority(1500, true);
	
	-- Show UI highlight
	cm:steal_user_input(true);
	cm:callback(
		function()
			cm:steal_user_input(false);
			core:show_fullscreen_highlight_around_components(25, false, false, uic_siege_panel);
		end,
		0.5
	);
	
	pulse_uicomponent(uic_siege_panel, true, 3, true);
	
	cm:callback(function() tp_siege_panel:show() end, 2);
end


function start_surrender_timer_advice()
	out("#### start_surrender_timer_advice() ####");
	
	-- get a handle to the siege panel
	local uic_siege_panel = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "mid", "battle_deployment", "regular_deployment");
	if not uic_siege_panel then
		print_all_uicomponent_children(core:get_ui_root());
		script_error("ERROR: start_surrender_timer_advice() can't find uic_siege_panel, how can this be?");
		return;
	end
	local uic_killometer = find_uicomponent(uic_siege_panel, "killometer");
	if not uic_killometer then
		script_error("ERROR: start_surrender_timer_advice() can't find uic_killometer, how can this be?");
		return;
	end
	local uic_turns = find_uicomponent(uic_siege_panel, "icon_turns");
	if not uic_turns then
		script_error("ERROR: start_surrender_timer_advice() can't find uic_turns, how can this be?");
		return;
	end
	local uic_attrition = find_uicomponent(uic_siege_panel, "icon_attrition");
	if not uic_attrition then
		script_error("ERROR: start_surrender_timer_advice() can't find uic_attrition, how can this be?");
		return;
	end
	
	pulse_uicomponent(uic_killometer, false, 3, true);
	pulse_uicomponent(uic_turns, true, 3, true);
	pulse_uicomponent(uic_attrition, true, 3, true);
	
	
	local uic_size_x_attrition, uic_size_y_attrition = uic_attrition:Dimensions();
	local uic_pos_x_attrition, uic_pos_y_attrition = uic_attrition:Position();
	
	local tp_siege_attrition = text_pointer:new("siege_attrition", "bottom", 50, uic_pos_x_attrition + (uic_size_x_attrition / 2), uic_pos_y_attrition);
	tp_siege_attrition:add_component_text("text", "ui_text_replacements_localised_text_wh2_intro_campaign_surrender_1");
	tp_siege_attrition:set_style("semitransparent");
	tp_siege_attrition:set_label_offset(-155, 0);
	tp_siege_attrition:set_panel_width(350);
	
	
	local uic_size_x_surrender, uic_size_y_surrender = uic_turns:Dimensions();
	local uic_pos_x_surrender, uic_pos_y_surrender = uic_turns:Position();
	
	local tp_siege_turns = text_pointer:new("siege_turns", "bottom", 50, uic_pos_x_surrender + (uic_size_x_surrender / 2), uic_pos_y_surrender);
	tp_siege_turns:add_component_text("text", "ui_text_replacements_localised_text_wh2_intro_campaign_surrender_2");
	tp_siege_turns:set_style("semitransparent_highlight_dont_close");
	tp_siege_turns:set_label_offset(155, 0);
	tp_siege_turns:set_panel_width(350);
	
	
	-- Shows the next text pointer when this one is closed
	tp_siege_turns:set_close_button_callback(
		function()
			tp_siege_turns:hide();
			tp_siege_attrition:hide();
			start_manpower_advice();
		end
	);
	
	cm:callback(function() tp_siege_attrition:show() end, 0.5);
	cm:callback(function() tp_siege_turns:show() end, 1);
end

function start_manpower_advice()
	out("#### start_manpower_advice() ####");
	
	-- get a handle to the siege panel
	local uic_siege_panel = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "mid", "battle_deployment", "regular_deployment");
	if not uic_siege_panel then
		script_error("ERROR: start_manpower_advice() can't find uic_siege_panel, how can this be?");
		return;
	end
	local uic_turns = find_uicomponent(uic_siege_panel, "icon_turns");
	if not uic_turns then
		script_error("ERROR: start_manpower_advice() can't find uic_turns, how can this be?");
		return;
	end
	local uic_attrition = find_uicomponent(uic_siege_panel, "icon_attrition");
	if not uic_attrition then
		script_error("ERROR: start_manpower_advice() can't find uic_attrition, how can this be?");
		return;
	end
	
	local uic_labour = find_uicomponent(uic_siege_panel, "dy_construction_strength");
	if not uic_labour then
		script_error("ERROR: start_manpower_advice() can't find uic_labour, how can this be?");
		return;
	end;
	
	local uic_labour_per = find_uicomponent(uic_siege_panel, "dy_construction_effort");
	if not uic_labour_per then
		script_error("ERROR: start_manpower_advice() can't find uic_labour_per, how can this be?");
		return;
	end
	
	pulse_uicomponent(uic_turns, false, 3, true);
	pulse_uicomponent(uic_attrition, false, 3, true);
	
	pulse_uicomponent(uic_labour, true, 3, true);
	pulse_uicomponent(uic_labour_per, true, 3, true);
	
	local uic_size_x, uic_size_y = uic_labour:Dimensions();
	local uic_pos_x, uic_pos_y = uic_labour:Position();
	
	local tp_siege_labour = text_pointer:new("siege", "bottom", 75, uic_pos_x + (uic_size_x / 2), uic_pos_y);
	tp_siege_labour:add_component_text("text", "ui_text_replacements_localised_text_wh2_intro_campaign_manpower_1");
	tp_siege_labour:set_style("semitransparent_highlight_dont_close");
	tp_siege_labour:set_label_offset(0, 0);
	tp_siege_labour:set_panel_width(400);
	
	-- Shows the next text pointer when this one is closed
	tp_siege_labour:set_close_button_callback(
		function() 
			tp_siege_labour:hide();
			start_siege_weapon_advice()
		end
	);
	
	cm:callback(function() tp_siege_labour:show() end, 0.5);
end

function start_siege_weapon_advice()
	out("#### start_siege_weapon_advice() ####");
	
	-- get a handle to the siege panel
	local uic_siege_panel = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "mid", "battle_deployment", "regular_deployment");
	if not uic_siege_panel then
		script_error("ERROR: start_siege_weapon_advice() can't find uic_siege_panel, how can this be?");
		return;
	end
	
	local uic_labour = find_uicomponent(uic_siege_panel, "dy_construction_strength");
	if not uic_labour then
		script_error("ERROR: start_manpower_advice() can't find uic_labour, how can this be?");
		return;
	end
	local uic_labour_per = find_uicomponent(uic_siege_panel, "dy_construction_effort");
	if not uic_labour_per then
		script_error("ERROR: start_manpower_advice() can't find uic_labour_per, how can this be?");
		return;
	end
	
	local uic_siege_list = find_uicomponent(uic_siege_panel, "construction_options");
	if not uic_siege_list then
		script_error("ERROR: start_siege_weapon_advice() can't find uic_siege_list, how can this be?");
		return;
	end
	
	pulse_uicomponent(uic_labour, false, 3, true);
	pulse_uicomponent(uic_labour_per, false, 3, true);
	
	local siege_weapons = {};
	local siege_count = uic_siege_list:ChildCount();
	
	for i = 0, siege_count - 1 do
		local child = UIComponent(uic_siege_list:Find(i));
		out("\tFound child: "..child:Id());
		
		table.insert(siege_weapons, child);
		
		pulse_uicomponent(child, true, 3, true);
	end
	
	local first_siege = siege_weapons[1];
	
	local uic_size_x, uic_size_y = first_siege:Dimensions();
	local uic_pos_x, uic_pos_y = first_siege:Position();
	
	local tp_siege_weapons = text_pointer:new("siege_weapons", "bottom", 150, uic_pos_x + (uic_size_x / 2), uic_pos_y);
	tp_siege_weapons:add_component_text("text", "ui_text_replacements_localised_text_wh2_intro_campaign_siege_weapons_1");
	tp_siege_weapons:set_style("semitransparent_highlight_dont_close");
	tp_siege_weapons:set_panel_width(400);
	
	-- Shows the next text pointer when this one is closed
	tp_siege_weapons:set_close_button_callback(
		function() 
			tp_siege_weapons:hide();
			start_siege_buttons_advice();
		end
	);
	
	cm:callback(function() tp_siege_weapons:show() end, 1);
end


function start_siege_buttons_advice()
	out("#### start_siege_buttons_advice() ####");
	
	core:hide_all_text_pointers();
	
	-- get a handle to the siege panel
	local uic_siege_panel = find_uicomponent(core:get_ui_root(), "popup_pre_battle", "mid", "battle_deployment", "regular_deployment");
	if not uic_siege_panel then
		script_error("ERROR: start_siege_weapon_advice() can't find uic_siege_panel, how can this be?");
		return;
	end
	
	local uic_siege_list = find_uicomponent(uic_siege_panel, "attacker_recruitment_options");
	if not uic_siege_list then
		script_error("ERROR: start_siege_weapon_advice() can't find uic_siege_list, how can this be?");
		return;
	end
	
	local uic_button_attack = find_uicomponent(core:get_ui_root(), "button_attack");
	if not uic_button_attack then
		script_error("ERROR: start_siege_weapon_advice() can't find uic_button_attack, how can this be?");
		return;
	end
	local uic_button_autoresolve = find_uicomponent(core:get_ui_root(), "button_autoresolve");
	if not uic_button_autoresolve then
		script_error("ERROR: start_siege_weapon_advice() can't find uic_button_autoresolve, how can this be?");
		return;
	end
	local uic_button_retreat = find_uicomponent(core:get_ui_root(), "button_retreat");
	if not uic_button_retreat then
		script_error("ERROR: start_siege_weapon_advice() can't find uic_button_retreat, how can this be?");
		return;
	end
	local uic_button_continue_siege = find_uicomponent(core:get_ui_root(), "button_continue_siege");
	if not uic_button_continue_siege then
		script_error("ERROR: start_siege_weapon_advice() can't find uic_button_continue_siege, how can this be?");
		return;
	end
	
	local siege_count = uic_siege_list:ChildCount();
	
	for i = 0, siege_count - 1 do
		local child = UIComponent(uic_siege_list:Find(i));
		pulse_uicomponent(child, false, 3, true);
	end
	
	local siege_buttons = {uic_button_attack, uic_button_autoresolve, uic_button_retreat, uic_button_continue_siege};
	
	pulse_uicomponent(uic_button_attack, true, 3, true);
	pulse_uicomponent(uic_button_autoresolve, true, 3, true);
	pulse_uicomponent(uic_button_retreat, true, 3, true);
	pulse_uicomponent(uic_button_continue_siege, true, 3, true);
	
	core:hide_fullscreen_highlight();
	core:show_fullscreen_highlight_around_components(25, false, false, unpack(siege_buttons));
	
	local uic_size_x_attack, uic_size_y_attack = uic_button_attack:Dimensions();
	local uic_pos_x_attack, uic_pos_y_attack = uic_button_attack:Position();
	
	local tp_siege_attack = text_pointer:new("siege_attack", "bottom", 100, uic_pos_x_attack + (uic_size_x_attack / 2), uic_pos_y_attack);
	tp_siege_attack:add_component_text("text", "ui_text_replacements_localised_text_wh2_intro_campaign_siege_buttons_1");
	tp_siege_attack:set_style("semitransparent");
	tp_siege_attack:set_label_offset(-150, 0);
	tp_siege_attack:set_panel_width(350);
	
	local uic_size_x_retreat, uic_size_y_retreat = uic_button_retreat:Dimensions();
	local uic_pos_x_retreat, uic_pos_y_retreat = uic_button_retreat:Position();
	
	local tp_siege_retreat = text_pointer:new("siege_retreat", "bottom", 100, uic_pos_x_retreat + (uic_size_x_retreat / 2), uic_pos_y_retreat);
	tp_siege_retreat:add_component_text("text", "ui_text_replacements_localised_text_wh2_intro_campaign_siege_buttons_2");
	tp_siege_retreat:set_style("semitransparent");
	tp_siege_retreat:set_label_offset(125, 0);
	tp_siege_retreat:set_panel_width(300);
	
	local uic_size_x_continue, uic_size_y_continue = uic_button_continue_siege:Dimensions();
	local uic_pos_x_continue, uic_pos_y_continue = uic_button_continue_siege:Position();
	
	local tp_siege_continue = text_pointer:new("siege_continue", "left", 100, uic_pos_x_continue + uic_size_x_continue, uic_pos_y_continue + uic_size_y_continue / 2);
	tp_siege_continue:add_component_text("text", "ui_text_replacements_localised_text_wh2_intro_campaign_siege_buttons_3");
	tp_siege_continue:set_style("semitransparent_highlight_dont_close");
	tp_siege_continue:set_label_offset(0, -40);
	tp_siege_continue:set_panel_width(300);
	
	tp_siege_continue:set_close_button_callback(
		function()
			tp_siege_attack:hide();
			tp_siege_retreat:hide();
			tp_siege_continue:hide();
			
			pulse_uicomponent(uic_button_attack, false, 3, true);
			pulse_uicomponent(uic_button_autoresolve, false, 3, true);
			pulse_uicomponent(uic_button_retreat, false, 3, true);
			pulse_uicomponent(uic_button_continue_siege, false, 3, true);
			
			core:hide_fullscreen_highlight();
			
			complete_settlement_siege_tour();
		end
	);
	
	cm:callback(function() tp_siege_attack:show() end, 1);
	cm:callback(function() tp_siege_retreat:show() end, 1.5);
	cm:callback(function() tp_siege_continue:show() end, 2);
end


function complete_settlement_siege_tour()
	out("#### start_siege_buttons_advice() ####");
	
	local uim = cm:get_campaign_ui_manager();
	uim:override("esc_menu"):unlock();
	uim:override("selection_change"):unlock();
	
	cm:modify_advice(true);
	
	in_settlement_sieged_tour:complete();
end





















--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- Character Skill Point Tour
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
character_skill_point_tour = intervention:new(
	"character_skill_point_tour",			 							-- string name
	5, 																	-- cost
	function() trigger_skill_point_advice_tour() end,					-- trigger callback
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

character_skill_point_tour:add_advice_key_precondition("war.camp.advice.character_skills.001");

character_skill_point_tour:add_trigger_condition(
	"CharacterRankUp",
	function(context)
		local character = context:character();
		
		if character:rank() == 2 and character:faction():is_human() and cm:has_intro_cutscene_played() then
			character_skill_point_tour.char_cqi = character:cqi();
			character_skill_point_tour.is_general = character:character_type("general");
			character_skill_point_tour.is_faction_leader = character:is_faction_leader();

			if character:has_military_force() then
				character_skill_point_tour.military_force = character:military_force();
				character_skill_point_tour.has_fixed_camp = character_skill_point_tour.military_force:force_type():has_feature("fixed_camp")
			else
				character_skill_point_tour.military_force = false
				character_skill_point_tour.has_fixed_camp = false
			end

			return true;
		end
	end
);

function trigger_skill_point_advice_tour()
	out("#### trigger_skill_point_advice_tour() ####");
	
	-- clear selection, so that we always have to reselect the character
	CampaignUI.ClearSelection();
	
	local advice_level = common.get_advice_level();
	out("\tAdvice: "..advice_level);
	
	-- we can't trigger for embedded heroes
	local character = cm:get_character_by_cqi(character_skill_point_tour.char_cqi);
	
	if advice_level == 2 and (character_skill_point_tour.is_general or not character:is_embedded_in_military_force()) and not character_skill_point_tour.has_fixed_camp and not character:character_subtype("wh3_main_dae_daemon_prince") then
		-- Long advice
		character_selected_skill_point_advice_tour();
	else
		-- Short advice
		cm:show_advice("war.camp.advice.character_skills.001", true);
		cm:add_infotext(1, "war.camp.advice.character_skills.info_001", "war.camp.advice.character_skills.info_002", "war.camp.advice.character_skills.info_003", "war.camp.advice.character_skills.info_004");
		
		cm:progress_on_advice_dismissed(
			"trigger_skill_point_advice_tour",
			function()
				character_skill_point_tour:complete();
			end, 
			0, 
			true
		);
	end
end


function character_skill_points_tour_lock_ui(value)
	value = not not value;
	
	local overrides_to_lock = {
		"stances",
		"radar_rollout_buttons",
		"recruit_units",
		"disband_unit",
		"diplomacy",
		"technology",
		"rituals",
		"finance",
		"tactical_map",
		"faction_button",
		"missions",
		"intrigue_at_the_court",
		"geomantic_web",
		"slaves",
		"skaven_corruption",
		"esc_menu",
		"help_panel_button",
		"spell_browser",
		"camera_settings",
		"end_turn",
		"end_turn_notification",
		"end_turn_options",
		"province_overview_panel_help_button",
		"mortuary_cult",
		"books_of_nagash",
		"regiments_of_renown",
		"sword_of_khaine"
	};
	
	if value then
		for i = 1, #overrides_to_lock do
			uim:override(overrides_to_lock[i]):lock();
		end;
	else
		for i = 1, #overrides_to_lock do
			uim:override(overrides_to_lock[i]):unlock();
		end;
	end;
end;







function character_selected_skill_point_advice_tour()
	out("#### character_selected_skill_point_advice_tour() ####");
	
	character_skill_points_tour_lock_ui(true);
	
	local objective_key = "wh2.camp.army_selection_advice.001";
	
	if not character_skill_point_tour.is_general then
		objective_key = "wh2.camp.army_selection_advice.002";
	end;
	
	local selected_advice = intro_campaign_select_advice:new(
		character_skill_point_tour.char_cqi,						-- Character CQI
		"war.camp.advice.character_skills.001",						-- Advice Key
		objective_key,												-- Objective Key
		function()													-- Completion Callback
			cm:override_ui("disable_selection_change", true);
			cm:callback(function() start_info_button_advice() end, 0.5);
		end
	);
	
	selected_advice:add_infotext(1, "war.camp.advice.character_skills.info_001", "war.camp.advice.character_skills.info_002", "war.camp.advice.character_skills.info_003");
	
	selected_advice:set_allow_selection_with_objective(true);
	selected_advice:start();
	
	cm:steal_user_input(true);
	
	cm:callback(
		function()
			cm:steal_user_input(false);
			cm:scroll_camera_with_cutscene_to_character(
				2,
				function()
					out("\tScrolling Camera...");
				end, 
				character_skill_point_tour.char_cqi
			);
		end,
		1
	);
end;


function start_info_button_advice()
	out("#### start_info_button_advice() ####");
	
	-- make the character info panel invisible
	find_uicomponent(core:get_ui_root(), "hud_campaign", "secondary_info_panel_holder"):SetVisible(false);
	
	-- get a handle to the character info panel
	local uic_character_info = find_uicomponent(core:get_ui_root(), "info_panel_holder");
	if not uic_character_info then
		script_error("ERROR: start_info_button_advice() can't find uic_character_info, how can this be?");
		return;
	end
	
	-- get a handle to the info button
	local uic_info_button = find_uicomponent(uic_character_info, "button_general");
	if not uic_info_button then
		script_error("ERROR: start_info_button_advice() can't find uic_info_button, how can this be?");
		return;
	end
	
	-- get a handle to the skill button
	local uic_skill_button = find_uicomponent(uic_character_info, "skill_button");
	if not uic_skill_button then
		script_error("ERROR: start_skill_point_advice() can't find uic_skill_button, how can this be?");
		return;
	end
	
	-- disable character details buttons
	uic_info_button:SetDisabled(true);
	uic_skill_button:SetDisabled(true);
	
	local info_size_x, info_size_y = uic_info_button:Dimensions();
	local info_pos_x, info_pos_y = uic_info_button:Position();
	
	local skill_size_x, skill_size_y = uic_skill_button:Dimensions();
	local skill_pos_x, skill_pos_y = uic_skill_button:Position();
	
	local tp_character_details_button = text_pointer:new("character_details_button", "left", 250, info_pos_x + (info_size_x / 2) + 15, (info_pos_y + (info_size_y / 2)) - 10);
	tp_character_details_button:set_layout("text_pointer_text_only");
	tp_character_details_button:add_component_text("text", "ui_text_replacements_localised_text_wh2_intro_campaign_character_details");
	tp_character_details_button:set_style("semitransparent_highlight_dont_close");
	tp_character_details_button:set_label_offset(0, -20);
	tp_character_details_button:set_topmost();
	tp_character_details_button:set_panel_width(400);
	
	local tp_character_skills_button = text_pointer:new("character_skills_button", "bottom", 200, skill_pos_x + (skill_size_x / 2) + 10, skill_pos_y + (skill_size_y / 2));
	tp_character_skills_button:set_layout("text_pointer_text_only");
	tp_character_skills_button:add_component_text("text", "ui_text_replacements_localised_text_wh2_intro_campaign_character_skills");
	tp_character_skills_button:set_style("semitransparent_highlight_dont_close");
	tp_character_skills_button:set_label_offset(180, 0);
	tp_character_skills_button:set_topmost();
	tp_character_skills_button:set_panel_width(400);
	
	-- Shows the next text pointer when this one is closed
	tp_character_details_button:set_close_button_callback(
		function()
			cm:callback(function() tp_character_skills_button:show() end, 0.5);
		end
	);
	
	tp_character_skills_button:set_close_button_callback(
		function()
			-- hide text pointers
			tp_character_details_button:hide();
			tp_character_skills_button:hide();
			
			-- dismiss fullscreen highlight
			core:hide_fullscreen_highlight();
			
			-- enable skill button
			uic_skill_button:SetDisabled(false);
			
			skill_point_advice_closed(uic_info_button);
		end
	);
	
	-- Move advice topmost
	core:cache_and_set_advisor_priority(1500, true);
	-- Show UI highlight
	core:show_fullscreen_highlight_around_components(25, false, false, uic_character_info);
	
	cm:callback(function() tp_character_details_button:show() end, 0.5);
end


function skill_point_advice_closed(uic_info_button)
	out("#### skill_point_advice_closed() ####");
	
	if character_skill_point_tour.is_faction_leader then
		cm:show_advice("wh2.camp.advice.skills.legendary.001", true);
	else
		cm:show_advice("wh2.camp.advice.skills.lord.001", true);
	end
	
	cm:set_objective("wh2.camp.open_character_panel_advice.001");
	
	core:add_listener(
		"skill_point_panel_opened",
		"PanelOpenedCampaign", 
		function(context) return context.string == "character_details_panel" end,
		function(context)
			cm:remove_callback("skill_button_highlight");
			
			-- re-enable the details button at this point
			uic_info_button:SetDisabled(false);
			
			highlight_component(false, false, "info_panel_holder", "skill_button");
			
			skill_point_panel_opened();
		end,
		false
	);
	
	cm:callback(function() highlight_component(true, false, "info_panel_holder", "skill_button") end, 0.5, "skill_button_highlight");
end

function skill_point_panel_opened()
	out("#### skill_point_panel_opened() ####");
		
	cm:complete_objective("wh2.camp.open_character_panel_advice.001");
	
	-- disable certain buttons
	character_skills_tour_enable_character_details_panel_close_button(false);
	character_skills_tour_enable_character_details_panel_details_tab_button(false);
	character_skills_tour_enable_character_details_panel_skills_tab_button(false);
	character_skills_tour_enable_character_details_panel_quests_tab_button(false);
	
	cm:callback(
		function()
			character_skills_tour_enable_character_details_panel_replace_lord_button(false);
			character_skills_tour_enable_character_details_panel_rename_button(false);
			character_skills_tour_enable_character_details_panel_save_button(false);
		end,
		0.1
	);
	
	cm:callback(
		function()
			cm:remove_objective("wh2.camp.open_character_panel_advice.001");
			start_skill_points_advice();
		end, 
		1
	);
end

function start_skill_points_advice()
	out("#### start_skill_points_advice() ####");
	
	-- get a handle to the character info panel
	local uic_character_details_panel = find_uicomponent(core:get_ui_root(), "character_details_panel");
	if not uic_character_details_panel then
		script_error("ERROR: start_skill_point_advice() can't find uic_character_details_panel, how can this be?");
		return;
	end
	-- get a handle to the skill points
	local uic_skill_points = find_uicomponent(uic_character_details_panel, "dy_pts");
	if not uic_skill_points then
		script_error("ERROR: start_skill_points_advice() can't find uic_skill_points, how can this be?");
		return;
	end
	-- get a handle to the skill points text
	local uic_skill_points_txt = find_uicomponent(uic_character_details_panel, "tx_skill");
	if not uic_skill_points_txt then
		script_error("ERROR: start_skill_points_advice() can't find uic_skill_points_txt, how can this be?");
		return;
	end
	
	local skill_size_x, skill_size_y = uic_skill_points:Dimensions();
	local skill_pos_x, skill_pos_y = uic_skill_points:Position();
	
	-- set up text pointers
	local tp_skill_points = text_pointer:new("skill_points", "top", 150, skill_pos_x + (skill_size_x / 2), skill_pos_y + (skill_size_y / 2) + 15);
	tp_skill_points:set_layout("text_pointer_text_only");
	tp_skill_points:add_component_text("text", "ui_text_replacements_localised_text_wh2_intro_campaign_skill_points");
	tp_skill_points:set_style("semitransparent_highlight_dont_close");
	tp_skill_points:set_label_offset(-180, 0);
	tp_skill_points:set_topmost();
	tp_skill_points:set_panel_width(400);
	
	local skill_components = {uic_skill_points, uic_skill_points_txt};
	
	core:show_fullscreen_highlight_around_components(25, false, false, unpack(skill_components));
	
	-- Shows the next text pointer when this one is closed
	tp_skill_points:set_close_button_callback(
		function()
			tp_skill_points:hide();
			start_skill_tree_advice();
		end
	);
	
	cm:callback(
		function()
			tp_skill_points:show();
		end, 
		1
	);
end

function start_skill_tree_advice()
	out("#### start_skill_tree_advice() ####");

	-- get a handle to the character info panel
	local uic_character_details_panel = find_uicomponent(core:get_ui_root(), "character_details_panel");
	if not uic_character_details_panel then
		script_error("ERROR: start_skill_tree_advice() can't find uic_character_details_panel, how can this be?");
		return;
	end
	-- get a handle to the skill tree
	local uic_skill_tree = find_uicomponent(uic_character_details_panel, "skills_subpanel");
	if not uic_skill_tree then
		script_error("ERROR: start_skill_tree_advice() can't find uic_skill_tree, how can this be?");
		return;
	end
	
	core:hide_fullscreen_highlight();
	
	local skill_size_x, skill_size_y = uic_skill_tree:Dimensions();
	local skill_pos_x, skill_pos_y = uic_skill_tree:Position();
	
	-- set up text pointers
	local tp_skill_tree = text_pointer:new("skill_tree", "right", 56, skill_pos_x + 20, skill_pos_y + (skill_size_y / 2) + 150);
	tp_skill_tree:set_layout("text_pointer_text_only");
	tp_skill_tree:add_component_text("text", "ui_text_replacements_localised_text_wh2_intro_campaign_skill_tree");
	tp_skill_tree:set_style("semitransparent_highlight_dont_close");
	tp_skill_tree:set_label_offset(0, -50);
	tp_skill_tree:set_topmost();
	-- tp_skill_tree:set_panel_width(300);
	
	core:show_fullscreen_highlight_around_components(0, false, false, uic_skill_tree);
	
	-- Shows the next text pointer when this one is closed
	tp_skill_tree:set_close_button_callback(
		function()
			tp_skill_tree:hide();
			start_skill_point_task();
		end
	);
	
	cm:callback(
		function()
			tp_skill_tree:show();
		end, 
		1
	);
end


function start_skill_point_task()
	out("#### start_skill_point_task() ####");
	
	core:hide_fullscreen_highlight();
	
	-- get a handle to the character info panel
	local uic_character_details_panel = find_uicomponent(core:get_ui_root(), "character_details_panel");
	if not uic_character_details_panel then
		script_error("ERROR: start_skill_tree_advice() can't find uic_character_details_panel, how can this be?");
		return;
	end
	-- get a handle to the skill tree
	local uic_skill_tree = find_uicomponent(uic_character_details_panel, "skills_subpanel");
	if not uic_skill_tree then
		script_error("ERROR: start_skill_tree_advice() can't find uic_skill_tree, how can this be?");
		return;
	end
	
	-- Use interface function on detail panel to return Lua table of all skill component names
	local uic_table = uic_character_details_panel:InterfaceFunction("GetAllSkillComponents");
	local available_count = 0;
	local available_skills_cards = {};
	
	for i = 1, #uic_table do
		-- For each component name, find the corresponding component 
		local component = find_uicomponent(uic_character_details_panel, uic_table[i]);
		local card = UIComponent(component:Find("card"));
		
		-- Check if it is in the available state
		if card ~= nil then
			if card:CurrentState() == "available" then
				pulse_uicomponent(component, true, 3, true);
				table.insert(available_skills_cards, card);
			end
		end
	end;
	
	-- if there are no available skill points, then complete immediately
	if #available_skills_cards == 0 then
		skill_point_task_complete();
		return;
	end;
	
	cm:set_objective("wh2.camp.spend_skill_point.001");
	
	core:add_listener(
		"skill_point_task",
		"ComponentLClickUp", 
		function(context)
			local uic = UIComponent(context.component);
			output_uicomponent(uic)
			for i = 1, #available_skills_cards do
				if available_skills_cards[i] == uic then
					return true;
				end;
			end;
		end,
		function(context)
			skill_point_task_complete(true);
		end,
		false
	);
end


function character_skills_tour_enable_character_details_panel_close_button(value)
	if value == false then
		set_component_active_with_parent(false, core:get_ui_root(), "character_details_panel", "button_ok");
		cm:override_ui("disable_character_details_panel_closing", true);
	else
		cm:override_ui("disable_character_details_panel_closing", false);
		set_component_active_with_parent(true, core:get_ui_root(), "character_details_panel", "button_ok");
	end;
end;


function character_skills_tour_enable_character_details_panel_details_tab_button(value)
	set_component_active_with_parent(value, core:get_ui_root(), "character_details_panel", "TabGroup", "details");
end;


function character_skills_tour_enable_character_details_panel_skills_tab_button(value)
	set_component_active_with_parent(value, core:get_ui_root(), "character_details_panel", "TabGroup", "skills");
end;


function character_skills_tour_enable_character_details_panel_quests_tab_button(value)
	set_component_active_with_parent(value, core:get_ui_root(), "character_details_panel", "TabGroup", "quests");
end;


function character_skills_tour_enable_character_details_panel_replace_lord_button(value)
	if value == false then
		set_component_active_with_parent(false, core:get_ui_root(), "character_details_panel", "button_replace_general");
		cm:override_ui("disable_replace_general", true);
	else
		cm:override_ui("disable_replace_general", false);
		set_component_active_with_parent(true, core:get_ui_root(), "character_details_panel", "button_replace_general");
	end;
end;


function character_skills_tour_enable_character_details_panel_rename_button(value)
	set_component_active_with_parent(value, core:get_ui_root(), "character_details_panel", "button_rename");
end;


function character_skills_tour_enable_character_details_panel_save_button(value)
	set_component_active_with_parent(value, core:get_ui_root(), "character_details_panel", "button_save_character");
end;


function skill_point_task_complete(objective_was_set)
	out("#### skill_point_task_complete() ####");
	
	if objective_was_set then
		cm:complete_objective("wh2.camp.spend_skill_point.001");
	end;
	
	core:add_listener(
		"details_tab_clicked",
		"ComponentLClickUp",
		function(context)
			if context.string == "details" then
				local parent = UIComponent(context.component):Parent();
				if UIComponent(parent):Id() == "TabGroup" then
					return true;
				end
			end
			return false;
		end,
		function()
			details_tab_clicked();
		end,
		false
	);
	
	cm:callback(
		function()
			if objective_was_set then
				cm:remove_objective("wh2.camp.spend_skill_point.001");
			end;
			
			-- re-enable and highlight panel tab button	
			character_skills_tour_enable_character_details_panel_details_tab_button(true);
			highlight_component(true, true, "character_details_panel", "TabGroup" , "details");
			
			cm:set_objective("wh2.camp.open_details_tab.001");
		end, 
		1
	);
end

function details_tab_clicked()
	out("#### details_tab_clicked() ####");
	
	highlight_component(false, true, "character_details_panel", "TabGroup" , "details");
	
	character_skills_tour_enable_character_details_panel_details_tab_button(false);
	
	cm:complete_objective("wh2.camp.open_details_tab.001");
	
	cm:callback(function()
		cm:remove_objective("wh2.camp.open_details_tab.001");
		
		start_followers_advice();
	end, 1);
end

function start_followers_advice()
	out("#### start_followers_advice() ####");
	
	-- get a handle to the character info panel
	local uic_character_details_panel = find_uicomponent(core:get_ui_root(), "character_details_panel");
	if not uic_character_details_panel then
		script_error("ERROR: start_followers_advice() can't find uic_character_details_panel, how can this be?");
		return;
	end
	-- get a handle to the followers panel
	local uic_followers_panel = find_uicomponent(uic_character_details_panel, "general_ancillaries_equipped");
	if not uic_followers_panel then
		script_error("ERROR: start_followers_advice() can't find uic_followers_panel, how can this be?");
		return;
	end
	
	local uic_followers_parent = find_uicomponent(uic_followers_panel, "listview");
	if not uic_followers_parent then
		script_error("ERROR: start_followers_advice() can't find uic_followers_parent, how can this be?");
		return;
	end
	
	-- get a handle to the first follower
	local uic_first_follower = UIComponent(uic_followers_parent:Find(0));
	
	-- pulse all the followers
	for i = 0, uic_followers_parent:ChildCount() - 1 do		
		pulse_uicomponent(UIComponent(uic_followers_parent:Find(i)), true, 5, true)
	end;
	
	local follower_pos_x, follower_pos_y = uic_first_follower:Position();
		
	-- set up text pointers
	local tp_follower_1 = text_pointer:new("follower1", "bottom", 30, follower_pos_x + 20, follower_pos_y);
	tp_follower_1:set_layout("text_pointer_text_only");
	tp_follower_1:add_component_text("text", "ui_text_replacements_localised_text_wh2_intro_campaign_followers_1");
	tp_follower_1:set_style("semitransparent_highlight_dont_close");
	tp_follower_1:set_label_offset(0, 0);
	tp_follower_1:set_topmost();
	tp_follower_1:set_panel_width(200);
	
	local tp_follower_2 = text_pointer:new_from_position_offset_to_text_pointer("follower2", tp_follower_1, 30, 0);
	tp_follower_2:set_layout("text_pointer_text_only");
	tp_follower_2:add_component_text("text", "ui_text_replacements_localised_text_wh2_intro_campaign_followers_2");
	tp_follower_2:set_style("semitransparent_highlight_dont_close");
	tp_follower_2:set_label_offset(0, 0);
	tp_follower_2:set_topmost();
	tp_follower_2:set_panel_width(200);
	
	local tp_follower_3 = text_pointer:new_from_position_offset_to_text_pointer("follower3", tp_follower_2, 30, 0);
	tp_follower_3:set_layout("text_pointer_text_only");
	tp_follower_3:add_component_text("text", "ui_text_replacements_localised_text_wh2_intro_campaign_followers_3");
	tp_follower_3:set_style("semitransparent_highlight_dont_close");
	tp_follower_3:set_label_offset(0, 0);
	tp_follower_3:set_topmost();
	tp_follower_3:set_panel_width(200);
		
	core:show_fullscreen_highlight_around_components(20, false, false, uic_followers_panel);
		
	-- Shows the next text pointer when this one is closed
	tp_follower_1:set_close_button_callback(
		function() 
			tp_follower_2:show();
		end
	);
	tp_follower_2:set_close_button_callback(
		function() 
			tp_follower_3:show();
		end
	);
	tp_follower_3:set_close_button_callback(
		function() 
			tp_follower_1:hide();
			tp_follower_2:hide();
			tp_follower_3:hide();
			
			for i = 0, uic_followers_parent:ChildCount() - 1 do
				pulse_uicomponent(UIComponent(uic_followers_parent:Find(i)), false, 5, true)
			end;
		
			start_character_items_advice();
		end
	);
	
	cm:callback(
		function()
			tp_follower_1:show();
		end, 
		1
	);
end

function start_character_items_advice()
	out("#### start_character_items_advice() ####");

	core:hide_fullscreen_highlight();
	
	-- get a handle to the character info panel
	local uic_character_details_panel = find_uicomponent(core:get_ui_root(), "character_details_panel");
	if not uic_character_details_panel then
		script_error("ERROR: start_followers_advice() can't find uic_character_details_panel, how can this be?");
		return;
	end
	
	-- get a handle to the followers panel
	local uic_followers_panel = find_uicomponent(uic_character_details_panel, "general_ancillaries_equipped");
	if not uic_followers_panel then
		script_error("ERROR: start_followers_advice() can't find uic_followers_panel, how can this be?");
		return;
	end
	
	-- get a handle to the items panel
	local uic_items_panel = find_uicomponent(uic_character_details_panel, "equiped_items_list");
	if not uic_items_panel then
		script_error("ERROR: start_followers_advice() can't find uic_items_panel, how can this be?");
		return;
	end
	
	core:show_fullscreen_highlight_around_components(20, false, false, uic_items_panel);
	
	for i = 0, uic_items_panel:ChildCount() - 1 do
		pulse_uicomponent(UIComponent(uic_items_panel:Find(i)), true, 3, true)
	end;
	
	local items_panel_size_x, items_panel_size_y = uic_items_panel:Dimensions();
	local items_panel_pos_x, items_panel_pos_y = uic_items_panel:Position();
	
	-- set up text pointers
	local tp_weapon_1 = text_pointer:new("tp_weapon_1", "right", 150, items_panel_pos_x, items_panel_pos_y + (items_panel_size_y / 2));
	tp_weapon_1:set_layout("text_pointer_text_only");
	tp_weapon_1:add_component_text("text", "ui_text_replacements_localised_text_wh2_intro_campaign_items_1");
	tp_weapon_1:set_style("semitransparent_highlight_dont_close");
	tp_weapon_1:set_label_offset(0, 0);
	tp_weapon_1:set_topmost();
	tp_weapon_1:set_panel_width(300);
	
	local tp_weapon_2 = text_pointer:new_from_position_offset_to_text_pointer("tp_weapon_2", tp_weapon_1, 0, 30);
	tp_weapon_2:set_layout("text_pointer_text_only");
	tp_weapon_2:add_component_text("text", "ui_text_replacements_localised_text_wh2_intro_campaign_items_2");
	tp_weapon_2:set_style("semitransparent_highlight_dont_close");
	tp_weapon_2:set_label_offset(0, 0);
	tp_weapon_2:set_topmost();
	tp_weapon_2:set_panel_width(300);
	
	local tp_weapon_3 = text_pointer:new_from_position_offset_to_text_pointer("tp_weapon_3", tp_weapon_2, 0, 30);
	tp_weapon_3:set_layout("text_pointer_text_only");
	tp_weapon_3:add_component_text("text", "ui_text_replacements_localised_text_wh2_intro_campaign_items_3");
	tp_weapon_3:set_style("semitransparent_highlight_dont_close");
	tp_weapon_3:set_label_offset(0, 0);
	tp_weapon_3:set_topmost();
	tp_weapon_3:set_panel_width(300);
	
	tp_weapon_1:set_close_button_callback(
		function()
			tp_weapon_2:show();
		end
	);
	tp_weapon_2:set_close_button_callback(
		function()
			tp_weapon_3:show();
		end
	);
	tp_weapon_3:set_close_button_callback(
		function()
			tp_weapon_1:hide();
			tp_weapon_2:hide();
			tp_weapon_3:hide();
		
			start_trait_advice();
		end
	);
	
	cm:callback(function() tp_weapon_1:show() end, 1);
end

function start_trait_advice()
	out("#### start_trait_advice() ####");

	core:hide_fullscreen_highlight();
	
	-- get a handle to the character info panel
	local uic_character_details_panel = find_uicomponent(core:get_ui_root(), "character_details_panel");
	if not uic_character_details_panel then
		script_error("ERROR: start_followers_advice() can't find uic_character_details_panel, how can this be?");
		return;
	end
	-- get a handle to the items panel
	local uic_items_panel = find_uicomponent(uic_character_details_panel, "equiped_items_list");
	if not uic_items_panel then
		script_error("ERROR: start_followers_advice() can't find uic_items_panel, how can this be?");
		return;
	end
	-- get a handle to the traits panel
	local uic_traits_panel = find_uicomponent(uic_character_details_panel, "traits_subpanel");
	if not uic_traits_panel then
		script_error("ERROR: start_followers_advice() can't find uic_traits_panel, how can this be?");
		return;
	end
	
	for i = 0, uic_items_panel:ChildCount() - 1 do
		pulse_uicomponent(UIComponent(uic_items_panel:Find(i)), false, 3, true)
	end;
	
	core:show_fullscreen_highlight_around_components(20, false, false, uic_traits_panel);
	pulse_uicomponent(uic_traits_panel, true, 3, true);
	
	local traits_size_x, traits_size_y = uic_traits_panel:Dimensions();
	local traits_pos_x, traits_pos_y = uic_traits_panel:Position();
	
	-- set up text pointers
	local tp_traits = text_pointer:new("tp_traits", "bottom", 100, traits_pos_x + (traits_size_x / 1.5), traits_pos_y + 10);
	tp_traits:set_layout("text_pointer_text_only");
	tp_traits:add_component_text("text", "ui_text_replacements_localised_text_wh2_intro_campaign_traits");
	tp_traits:set_style("semitransparent_highlight_dont_close");
	tp_traits:set_label_offset(0, 0);
	tp_traits:set_topmost();
	
	tp_traits:set_close_button_callback(
		function()
			tp_traits:hide();
			start_character_info_advice();
		end
	);
	
	cm:callback(function()
		tp_traits:show();
	end, 1);
	cm:callback(function()
		pulse_uicomponent(uic_traits_panel, false, 3, true);
	end, 3);
end

function start_character_info_advice()
	out("#### start_character_info_advice() ####");
	
	core:hide_fullscreen_highlight();
	
	-- get a handle to the character info panel
	local uic_character_details_panel = find_uicomponent(core:get_ui_root(), "character_details_panel");
	if not uic_character_details_panel then
		script_error("ERROR: start_character_info_advice() can't find uic_character_details_panel, how can this be?");
		return;
	end
	-- get a handle to the info panel
	local uic_info_panel = find_uicomponent(uic_character_details_panel, "details_traits_effects_holder");
	if not uic_info_panel then
		script_error("ERROR: start_character_info_advice() can't find uic_info_panel, how can this be?");
		return;
	end
	
	core:show_fullscreen_highlight_around_components(20, false, false, uic_info_panel);
	pulse_uicomponent(uic_info_panel, true, 3, true);
	
	local info_size_x, info_size_y = uic_info_panel:Dimensions();
	local info_pos_x, info_pos_y = uic_info_panel:Position();
	
	local info_type = "wh2_intro_campaign_character_info_1";
	local info_width = 400;
	if character_skill_point_tour.is_general then
		info_type = "wh2_intro_campaign_character_info_2";
		-- info_width = 800;
	end
	
	-- set up text pointers
	local tp_info_1 = text_pointer:new("tp_info_1", "bottom", 100, info_pos_x + (info_size_x / 1.5), info_pos_y);
	tp_info_1:set_layout("text_pointer_text_only");
	tp_info_1:add_component_text("text", "ui_text_replacements_localised_text_"..info_type);
	tp_info_1:set_style("semitransparent_highlight_dont_close");
	tp_info_1:set_label_offset(0, 0);
	tp_info_1:set_topmost();
	tp_info_1:set_panel_width(info_width);
		
	local uic_loyalty = find_uicomponent(uic_info_panel, "tx_loyalty");
		
	if uic_loyalty and uic_loyalty:Visible() == true then
		local loyalty_size_x, loyalty_size_y = uic_loyalty:Dimensions();
		local loyalty_pos_x, loyalty_pos_y = uic_loyalty:Position();
		
		local tp_info_2 = text_pointer:new("tp_info_2", "left", 200, loyalty_pos_x + loyalty_size_x, loyalty_pos_y + (loyalty_size_y / 2));
		tp_info_2:set_layout("text_pointer_text_only");
		tp_info_2:add_component_text("text", "ui_text_replacements_localised_text_wh2_intro_campaign_character_info_3");
		tp_info_2:set_style("semitransparent_highlight_dont_close");
		tp_info_2:set_label_offset(0, 0);
		tp_info_2:set_topmost();
		tp_info_2:set_panel_width(400);
		
		tp_info_1:set_close_button_callback(
			function()
				tp_info_2:show();
			end
		);
		tp_info_2:set_close_button_callback(
			function()
				tp_info_1:hide();
				tp_info_2:hide();
				complete_character_details_tour();
			end
		);
	else
		out("\tSkipping loyalty advice...");
		tp_info_1:set_close_button_callback(
			function()
				tp_info_1:hide();
				complete_character_details_tour();
			end
		);
	end
	
	cm:callback(function() tp_info_1:show() end, 1);
end

function complete_character_details_tour()
	out("#### complete_character_details_tour() ####");
	
	cm:override_ui("disable_selection_change", false);
	
	core:hide_fullscreen_highlight();
	
	-- get a handle to the character info panel
	local uic_character_details_panel = find_uicomponent(core:get_ui_root(), "character_details_panel");
	if not uic_character_details_panel then
		script_error("ERROR: complete_character_details_tour() can't find uic_character_details_panel, how can this be?");
		return;
	end
	-- get a handle to the info panel
	local uic_info_panel = find_uicomponent(uic_character_details_panel, "details_traits_effects_holder");
	if not uic_info_panel then
		script_error("ERROR: complete_character_details_tour() can't find uic_info_panel, how can this be?");
		return;
	end
	
	pulse_uicomponent(uic_info_panel, false, 3, true);
	
	cm:set_objective("wh2.camp.close_details_panel.001");
	
	highlight_component(true, false, "character_details_panel", "button_ok");
	
	-- re-enable UI
	character_skills_tour_enable_character_details_panel_close_button(true);
	character_skills_tour_enable_character_details_panel_details_tab_button(true);
	character_skills_tour_enable_character_details_panel_skills_tab_button(true);	
	character_skills_tour_enable_character_details_panel_quests_tab_button(true);	
	character_skills_tour_enable_character_details_panel_replace_lord_button(true);
	character_skills_tour_enable_character_details_panel_rename_button(true);
	character_skills_tour_enable_character_details_panel_save_button(true);
	
	character_skill_points_tour_lock_ui(false);
	
	core:add_listener(
		"skill_point_panel_closed",
		"PanelClosedCampaign",
		function(context) return context.string == "character_details_panel" end,
		function(context)

			-- make the character info panel visible again
			find_uicomponent(core:get_ui_root(), "hud_campaign", "secondary_info_panel_holder"):SetVisible(true);

			cm:complete_objective("wh2.camp.close_details_panel.001");
			highlight_component(false, false, "character_details_panel", "button_ok");
			cm:callback(function() cm:remove_objective("wh2.camp.close_details_panel.001") end, 1);
			character_skill_point_tour:complete();
			
			-- show advisor close button
			cm:modify_advice(true);
		end,
		false
	);
end






--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- Flesh Lab Tour
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

in_flesh_lab_tour = intervention:new(
	"in_flesh_lab_tour",			 									-- string name
	5, 																	-- cost
	function() 															-- trigger callback
		--dismiss the advisor to get him out of the tour
		cm:dismiss_advice()
		trigger_flesh_lab_scripted_tour() 
	end,					
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);


in_flesh_lab_tour:add_advice_key_precondition("wh2_dlc16.camp.advice.skv.flesh_lab.004.augmentation");

in_flesh_lab_tour:set_wait_for_fullscreen_panel_dismissed(true);

in_flesh_lab_tour:add_trigger_condition(
	"ScriptEventCampaignIntroComplete",
	true
);


function flesh_lab_tour_lock_ui(value)

	local uim = cm:get_campaign_ui_manager();

	value = not not value;

	CampaignUI.ClearSelection();
	
	local overrides_to_lock = {
		"selection_change",
		"stances",
		"radar_rollout_buttons",
		"recruit_units",
		"disband_unit",
		"diplomacy",
		"technology",
		"rituals",
		"finance",
		"tactical_map",
		"faction_button",
		"missions",
		"intrigue_at_the_court",
		"geomantic_web",
		"slaves",
		"skaven_corruption",
		"esc_menu",
		"help_panel_button",
		"spell_browser",
		"camera_settings",
		"end_turn_options",
		"mortuary_cult",
		"books_of_nagash",
		"regiments_of_renown",
		"sword_of_khaine"
	};
	
	cm:override_ui("disable_fullscreen_panel_closing", value);
	
	if value then
		for i = 1, #overrides_to_lock do
			uim:override(overrides_to_lock[i]):lock();
		end;
	else
		for i = 1, #overrides_to_lock do
			uim:override(overrides_to_lock[i]):unlock();			
		end;
		-- lift fullscreen highlight
		core:hide_fullscreen_highlight();
		cm:dismiss_advice();
		in_flesh_lab_tour:complete();
	end;
end;


function trigger_flesh_lab_scripted_tour()
	

	-- Move advice topmost
	core:cache_and_set_advisor_priority(1500, true);
	cm:show_advice("wh2_dlc16.camp.advice.skv.flesh_lab.004.augmentation");


	if cm:get_campaign_ui_manager():is_panel_open("augment_panel") then
		local uic_panel = find_child_uicomponent(core:get_ui_root(), "augment_panel");
		if not uic_panel then
			script_error("ERROR: flesh_lab_scripted_tour_open_panel() could not find the flesh lab panel, how can this be?");
			flesh_lab_tour_lock_ui(false);
			return false;
		end;
		flesh_lab_scripted_tour_tabs_advice(uic_panel)

	else

		local uic_flesh_lab_button = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_group_management", "button_flesh_lab");
		if not uic_flesh_lab_button then
			script_error("ERROR: trigger_flesh_lab_scripted_tour() could not find the flesh lab button, how can this be?");
			return false;
		end;
		
		-- lock ui
		flesh_lab_tour_lock_ui(true);
		
		-- show fullscreen highlight around the flesh lab button
		core:show_fullscreen_highlight_around_components(25, false, false, uic_flesh_lab_button);
		
		-- pulse the button
		pulse_uicomponent(uic_flesh_lab_button, true, 5);
		
		-- set up button text pointer
		local uic_flesh_lab_button_size_x, uic_flesh_lab_button_size_y = uic_flesh_lab_button:Dimensions();
		local uic_flesh_lab_button_pos_x, uic_flesh_lab_button_pos_y = uic_flesh_lab_button:Position();
		
		local tp_flesh_lab_button = text_pointer:new("flesh_lab_button", "right", 100, uic_flesh_lab_button_pos_x + uic_flesh_lab_button_size_x / 5, uic_flesh_lab_button_pos_y + (uic_flesh_lab_button_size_y / 2));
		tp_flesh_lab_button:set_layout("text_pointer_text_only");
		tp_flesh_lab_button:add_component_text("text", "ui_text_replacements_localised_text_dlc16_text_pointer_flesh_lab_button");
		tp_flesh_lab_button:set_style("semitransparent_highlight");
		tp_flesh_lab_button:set_panel_width(300);
		
		tp_flesh_lab_button:set_close_button_callback(
			function()
				-- hide text pointer
				tp_flesh_lab_button:hide();

				-- stop pulsing button
				pulse_uicomponent(uic_flesh_lab_button, false, 5);

				flesh_lab_scripted_tour_open_panel(uic_flesh_lab_button)
			end
		);
		
		cm:callback(
			function()
				tp_flesh_lab_button:show();
			end,
			0.5
		);
	end

end;

function flesh_lab_scripted_tour_open_panel(uic_flesh_lab_button)
	
	local event_name = "flesh_lab_scripted_tour";		
				
	-- lift fullscreen highlight
	core:hide_fullscreen_highlight();

	-- establish listener for the flesh lab panel opening						
	core:add_listener(
		event_name,
		"PanelOpenedCampaign",
		function(context)
			return context.string == "augment_panel"
		end,
		function(context)
			out("%%%%% Flesh Lab panel opened");
		
			cm:remove_callback(event_name);
			
			local uic_panel = find_uicomponent(core:get_ui_root(), "augment_panel");
			if not uic_panel then
				script_error("ERROR: flesh_lab_scripted_tour_open_panel() could not find the flesh lab panel, how can this be?");
				flesh_lab_tour_lock_ui(false);
				return false;
			end;
			
			-- wait for the panel to finish animating
			core:progress_on_uicomponent_animation(
				event_name, 
				uic_panel, 
				function()	
					flesh_lab_scripted_tour_tabs_advice(uic_panel)
				end
			);
		end,
		false
	);
	-- failsafe: panel hasn't opened for some reason, exit
	cm:callback(
		function()
			script_error("WARNING: flesh_lab_scripted_tour_open_panel() attempted to open the Flesh Lab panel but it didn't open, exiting");
			core:remove_listener(event_name);
			flesh_lab_tour_lock_ui(false);
			return false;
		end,
		0.5,
		event_name
	);			
	
	-- simulate click on flesh lab button to open the flesh lab panel
	uic_flesh_lab_button:SimulateLClick();

end

function flesh_lab_scripted_tour_tabs_advice(uic_panel)
	
	--uic_panel:StealShortcutKey(false);

	local uic_flesh_lab_tabs = find_uicomponent(uic_panel, "top_bar_holder", "button_tab_holder");
	local uic_augment_inf_button = find_uicomponent(uic_flesh_lab_tabs, "button_infantry_augments");
	local uic_augment_mon_button = find_uicomponent(uic_flesh_lab_tabs, "button_monster_augments");
	
	if not uic_flesh_lab_tabs then
		script_error("WARNING: flesh_lab_scripted_tour_tabs_advice() could not find the button_tab_holder uicomponent in the flesh lab, how can this be?");
		flesh_lab_tour_lock_ui(false);
		return false;
	end;

	if not uic_augment_inf_button then
		script_error("WARNING: trigger_flesh_lab_flesh_lab_scripted_tour_tabs_advicescripted_tour() could not find the infantry augment button uicomponent in the flesh lab, how can this be?");
		flesh_lab_tour_lock_ui(false);
		return false;
	end;

	if not uic_augment_mon_button then
		script_error("WARNING: flesh_lab_scripted_tour_tabs_advice() could not find the monster augment button uicomponent in the flesh lab, how can this be?");
		flesh_lab_tour_lock_ui(false);
		return false;
	end;

	-- show fullscreen highlight over the tabs
	core:show_fullscreen_highlight_around_components(25, false, false, uic_flesh_lab_tabs);
	
	-- pulse each of the augment tabs
	pulse_uicomponent(uic_augment_inf_button, true, 5, true);
	pulse_uicomponent(uic_augment_mon_button, true, 5, true);
	
	-- set up text pointer
	local uic_flesh_lab_tabs_size_x, uic_flesh_lab_tabs_size_y = uic_flesh_lab_tabs:Dimensions();
	local uic_flesh_lab_tabs_pos_x, uic_flesh_lab_tabs_pos_y = uic_flesh_lab_tabs:Position();
	
	local tp_flesh_lab_tabs = text_pointer:new("flesh_lab_tabs", "top", 100, uic_flesh_lab_tabs_pos_x + 7 * (uic_flesh_lab_tabs_size_x / 48), uic_flesh_lab_tabs_pos_y + uic_flesh_lab_tabs_size_y);
	tp_flesh_lab_tabs:set_layout("text_pointer_text_only");
	tp_flesh_lab_tabs:add_component_text("text", "ui_text_replacements_localised_text_dlc16_text_pointer_flesh_lab_tabs");
	tp_flesh_lab_tabs:set_style("semitransparent_highlight");
	tp_flesh_lab_tabs:set_panel_width(300);
	
	tp_flesh_lab_tabs:set_close_button_callback(
		function()
			-- hide text pointer
			tp_flesh_lab_tabs:hide();

			-- stop pulsing highlight of augment tabs
			pulse_uicomponent(uic_augment_inf_button, false, 5, true);
			pulse_uicomponent(uic_augment_mon_button, false, 5, true);
			
			-- lift fullscreen highlight
			core:hide_fullscreen_highlight();
		
			flesh_lab_scripted_tour_augment_hex_advice(uic_panel)
		
		end
	);

	cm:callback(
		function()
			tp_flesh_lab_tabs:show();
		end,
		0.5
	);

end

function flesh_lab_scripted_tour_augment_hex_advice(uic_panel)
	
	--dismiss the advisor to get him out of the tour
	cm:dismiss_advice()

	local uic_augments_hex = find_uicomponent(uic_panel, "augment_holder", "augment_upgrades_holder", "upgrades_holder", "hex_map_holder");

	if not uic_augments_hex then
		script_error("WARNING: flesh_lab_scripted_tour_augment_hex_advice() could not find the uic_augments_hex uicomponent in the flesh lab, how can this be?");
		flesh_lab_tour_lock_ui(false);
		return false;
	end;
	
	local uic_inf_augment_3 = find_uicomponent(uic_augments_hex, "hex_map", "3_INFANTRY", "hex_item");

	if not uic_inf_augment_3 then
		script_error("WARNING: flesh_lab_scripted_tour_augment_hex_advice() could not find the uic_inf_augment_3 uicomponent in the flesh lab, how can this be?");
		flesh_lab_tour_lock_ui(false);
		return false;
	end;

	-- simulate click on the third infantry hex to see its effects during tour
	uic_inf_augment_3:SimulateLClick();

	-- show fullscreen highlight over the map
	core:show_fullscreen_highlight_around_components(25, false, false, uic_augments_hex);
	
	-- pulse the hex grid
	pulse_uicomponent(uic_augments_hex, true, 5, true);
	
	-- set up text pointer
	local uic_augments_hex_size_x, uic_augments_hex_size_y = uic_augments_hex:Dimensions();
	local uic_augments_hex_pos_x, uic_augments_hex_pos_y = uic_augments_hex:Position();
	
	local tp_augments_hex = text_pointer:new("augment_hex", "left", 50, uic_augments_hex_pos_x + uic_augments_hex_size_x, uic_augments_hex_pos_y + (uic_augments_hex_size_y / 2));
	tp_augments_hex:set_layout("text_pointer_text_only");
	tp_augments_hex:add_component_text("text", "ui_text_replacements_localised_text_dlc16_text_pointer_flesh_lab_augment_hex");
	tp_augments_hex:set_style("semitransparent_highlight");
	tp_augments_hex:set_panel_width(350);

	tp_augments_hex:set_close_button_callback(
		function()
			-- hide text pointer
			tp_augments_hex:hide();
			
			-- stop pulsing the hex grid
			pulse_uicomponent(uic_augments_hex, false, 5, true);
			
			-- lift fullscreen highlight
			core:hide_fullscreen_highlight();

			flesh_lab_scripted_tour_augment_effects_advice(uic_panel)
		end
	);	
	
	cm:callback(
		function()
			tp_augments_hex:show();
		end,
		0.5
	);

end

function flesh_lab_scripted_tour_augment_effects_advice(uic_panel)
	
	
	local uic_augments_effects = find_uicomponent(uic_panel, "augment_holder", "augment_upgrades_holder", "upgrades_holder", "upgrade_info_holder");

	if not uic_augments_effects then
		script_error("WARNING: flesh_lab_scripted_tour_augment_effects_advice() could not find the upgrade_info_holder uicomponent in the flesh lab, how can this be?");
		flesh_lab_tour_lock_ui(false);
		return false;
	end;
	
	-- show fullscreen highlight over the map
	core:show_fullscreen_highlight_around_components(25, false, false, uic_augments_effects);
	
	-- pulse the augment effects holder
	pulse_uicomponent(uic_augments_effects, true, 5, true);
	
	-- set up text pointer
	local uic_augments_effects_size_x, uic_augments_effects_size_y = uic_augments_effects:Dimensions();
	local uic_augments_effects_pos_x, uic_augments_effects_pos_y = uic_augments_effects:Position();
	
	local tp_augments_effects = text_pointer:new("augment_effects", "right", 50, uic_augments_effects_pos_x, uic_augments_effects_pos_y + (uic_augments_effects_size_y / 2));
	tp_augments_effects:set_layout("text_pointer_text_only");
	tp_augments_effects:add_component_text("text", "ui_text_replacements_localised_text_dlc16_text_pointer_flesh_lab_augment_effects");
	tp_augments_effects:set_style("semitransparent_highlight");
	tp_augments_effects:set_panel_width(350);

	tp_augments_effects:set_close_button_callback(
		function()
			-- hide text pointer
			tp_augments_effects:hide();
			
			-- stop pulsing highlight of the augment effects holder
			pulse_uicomponent(uic_augments_effects, false, 5, true);
			
			-- lift fullscreen highlight
			core:hide_fullscreen_highlight();	
			
			flesh_lab_scripted_tour_units_holder_advice(uic_panel)
		end
	);

	cm:callback(
		function()
			tp_augments_effects:show();
		end,
		0.5
	);

end

function flesh_lab_scripted_tour_units_holder_advice(uic_panel)

	-- Move advice topmost
	core:cache_and_set_advisor_priority(1500, true);
	--show the instability advice
	cm:show_advice("wh2_dlc16.camp.advice.skv.flesh_lab.006.instability")
	
	local uic_units = find_uicomponent(uic_panel, "augment_tab", "units_holder");

	if not uic_units then
		script_error("WARNING: flesh_lab_scripted_tour_units_holder_advice() could not find the units_holder uicomponent in the flesh lab, how can this be?");
		flesh_lab_tour_lock_ui(false);
		return false;
	end;
	
	-- show fullscreen highlight over the map
	core:show_fullscreen_highlight_around_components(25, false, false, uic_units);
	
	-- set up text pointer
	local uic_units_size_x, uic_units_size_y = uic_units:Dimensions();
	local uic_units_pos_x, uic_units_pos_y = uic_units:Position();
	
	local tp_units = text_pointer:new("unit_holder", "bottom", 100, uic_units_pos_x + (uic_units_size_x/2), uic_units_pos_y + (uic_units_size_y/5));
	tp_units:set_layout("text_pointer_text_only");
	tp_units:add_component_text("text", "ui_text_replacements_localised_text_dlc16_text_pointer_flesh_lab_unit_holder");
	tp_units:set_style("semitransparent_highlight");
	tp_units:set_panel_width(500);

	tp_units:set_close_button_callback(
		function()	
			-- hide text pointer
			tp_units:hide();
			
			-- lift fullscreen highlight
			core:hide_fullscreen_highlight();

			flesh_lab_scripted_tour_growth_vat_advice(uic_panel);
		end
	);

	cm:callback(
		function()
			tp_units:show();
		end,
		0.5
	);

end

function flesh_lab_scripted_tour_growth_vat_advice(uic_panel)																		

	--dismiss the advisor to get him out of the tour
	cm:dismiss_advice()

	local uic_growth_vat = find_uicomponent(uic_panel, "growth_vat_bar_holder", "growth_vat_bar");

	if not uic_growth_vat then
		script_error("WARNING: flesh_lab_scripted_tour_growth_vat_advice() could not find the growth_vat_bar uicomponent in the flesh lab, how can this be?");
		flesh_lab_tour_lock_ui(false);
		return false;
	end;
	
	-- show fullscreen highlight over the map
	core:show_fullscreen_highlight_around_components(40, false, false, uic_growth_vat);
	
	-- pulse the growth vat
	pulse_uicomponent(uic_growth_vat, true, 5, true);
	
	-- set up text pointer
	local uic_growth_vat_size_x, uic_growth_vat_size_y = uic_growth_vat:Dimensions();
	local uic_growth_vat_pos_x, uic_growth_vat_pos_y = uic_growth_vat:Position();
	
	local tp_growth_vat = text_pointer:new("growth_vat", "top", 50, uic_growth_vat_pos_x + (uic_growth_vat_size_x/2), uic_growth_vat_pos_y + uic_growth_vat_size_y);
	tp_growth_vat:set_layout("text_pointer_text_only");
	tp_growth_vat:add_component_text("text", "ui_text_replacements_localised_text_dlc16_text_pointer_flesh_lab_growth_vat");
	tp_growth_vat:set_style("semitransparent_highlight");
	tp_growth_vat:set_panel_width(400);
	tp_growth_vat:set_close_button_callback(
		function()
			-- hide text pointer
			tp_growth_vat:hide();

			-- stop pulsing highlight of the growth vat
			pulse_uicomponent(uic_growth_vat, false, 5, true);

			-- lift fullscreen highlight
			core:hide_fullscreen_highlight();

			flesh_lab_scripted_tour_lab_upgrades_advice(uic_panel)
		end
	);
	cm:callback(
		function()
			tp_growth_vat:show();
		end,
		0.5
	);
end

function flesh_lab_scripted_tour_lab_upgrades_advice(uic_panel)	

	local event_name = "flesh_lab_scripted_tour_lab";	
	local uic_augment_lab_button = find_uicomponent(uic_panel, "top_bar_holder", "button_tab_holder", "button_lab");

	if not uic_augment_lab_button then
		script_error("WARNING: flesh_lab_scripted_tour_lab_upgrades_advice() could not find the lab upgrades button uicomponent in the flesh lab, how can this be?");
		flesh_lab_tour_lock_ui(false);
		return false;
	end;

	-- show fullscreen highlight over the map
	core:show_fullscreen_highlight_around_components(25, false, false, uic_augment_lab_button);

	--this was declared earlier, pulse highlight the lab upgrade tab
	pulse_uicomponent(uic_augment_lab_button, true, 5, true);

	local uic_augment_lab_button_size_x, uic_augment_lab_button_size_y = uic_augment_lab_button:Dimensions();
	local uic_augment_lab_button_pos_x, uic_augment_lab_button_pos_y = uic_augment_lab_button:Position();
	
	local tp_lab_upgrades = text_pointer:new("lab_upgrades_tab", "top", 30, uic_augment_lab_button_pos_x + (uic_augment_lab_button_size_x/2), uic_augment_lab_button_pos_y + uic_augment_lab_button_size_y);
	tp_lab_upgrades:set_layout("text_pointer_text_only");
	tp_lab_upgrades:add_component_text("text", "ui_text_replacements_localised_text_dlc16_text_pointer_flesh_lab_upgrades_tab");
	tp_lab_upgrades:set_style("semitransparent_highlight");
	tp_lab_upgrades:set_panel_width(300);
	tp_lab_upgrades:set_close_button_callback(
		function()	

			-- establish listener for the flesh lab panel opening						
			core:add_listener(
				event_name,
				"ComponentLClickUp", 
				function(context) 
					return UIComponent(context.component) == find_uicomponent(uic_augment_lab_button);
				end, 
				function(context)
					out("%%%%% Lab Upgrades tab opened");
				
					cm:remove_callback(event_name);

					-- wait for the panel to finish animating
					core:progress_on_uicomponent_animation(
						event_name, 
						uic_augment_lab_button, 
						function()
							-- hide text pointer
							tp_lab_upgrades:hide();
							
							-- stop pulsing highlight of the units holder
							pulse_uicomponent(uic_augment_lab_button, false, 5, true);
							
							-- lift fullscreen highlight
							core:hide_fullscreen_highlight();

							flesh_lab_scripted_tour_upgrades_holder_advice(uic_panel)
						end
					);
				end, 
				false
			);
			-- failsafe: tab hasn't opened for some reason, exit
			cm:callback(
				function()
					script_error("WARNING: flesh_lab_scripted_tour_lab_upgrades_advice() attempted to open Lab Upgrades tab but it didn't open, exiting");
					core:remove_listener(event_name);
					flesh_lab_tour_lock_ui(false);
					return false;
				end,
				0.5,
				event_name
			);						
			
			-- simulate click on lab upgrades tab to open it in the flesh lab panel
			uic_augment_lab_button:SimulateLClick();							
				
		end
	);
	cm:callback(
		function()
			tp_lab_upgrades:show();
		end,
		0.5
	);
end

function flesh_lab_scripted_tour_upgrades_holder_advice(uic_panel)

	local uic_upgrades_holder = find_uicomponent(uic_panel, "laboratory_tab", "upgrades_holder", "ritual_upgrades_holder", "listview", "list_clip");

	if not uic_upgrades_holder then
		script_error("WARNING: trigger_flesh_lab_scripted_tour() could not find the upgrades_holder uicomponent in the flesh lab, how can this be?");
		flesh_lab_tour_lock_ui(false);
		return false;
	end;
	
	-- show fullscreen highlight over the map
	core:show_fullscreen_highlight_around_components(25, false, false, uic_upgrades_holder);
	
	-- pulse the growth vat
	pulse_uicomponent(uic_upgrades_holder, true, 5, true);
	
	-- set up text pointer
	local uic_upgrades_holder_size_x, uic_upgrades_holder_size_y = uic_upgrades_holder:Dimensions();
	local uic_upgrades_holder_pos_x, uic_upgrades_holder_pos_y = uic_upgrades_holder:Position();
	
	local tp_upgrades_holder = text_pointer:new("upgrades", "right", 50, uic_upgrades_holder_pos_x, uic_upgrades_holder_pos_y + (uic_upgrades_holder_size_y / 2));
	tp_upgrades_holder:set_layout("text_pointer_text_only");
	tp_upgrades_holder:add_component_text("text", "ui_text_replacements_localised_text_dlc16_text_pointer_flesh_lab_upgrades");
	tp_upgrades_holder:set_style("semitransparent_highlight");
	tp_upgrades_holder:set_panel_width(325);
	tp_upgrades_holder:set_close_button_callback(
		function()
			
			-- hide text pointer
			tp_upgrades_holder:hide();
			
			-- stop pulsing highlight of book icons
			pulse_uicomponent(uic_upgrades_holder, false, 5, true);
			
			-- lift fullscreen highlight
			core:hide_fullscreen_highlight();
			
			--end the tour
			flesh_lab_tour_lock_ui(false);
			
		end
	);
	cm:callback(
		function()
			tp_upgrades_holder:show();
		end,
		0.5
	);

end


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- Beastmen Panel Tour
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

in_beastmen_panel_tour = intervention:new(
	"in_beastmen_panel_tour",			 								-- string name
	0, 																	-- cost
	function() 															-- trigger callback
		--dismiss the advisor to get him out of the tour
		cm:dismiss_advice()
		trigger_beastmen_panel_scripted_tour() 
	end,					
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
);

in_beastmen_panel_tour:add_advice_key_precondition("wh2.dlc17.camp.advice.bst.panel.001.open");

in_beastmen_panel_tour:set_wait_for_fullscreen_panel_dismissed(true);

in_beastmen_panel_tour:add_trigger_condition(
	"ScriptEventCampaignIntroComplete",
	true
);

function beastmen_panel_tour_lock_ui(value)
	--dismiss the advisor to get him out of the tour
	cm:dismiss_advice()

	local uim = cm:get_campaign_ui_manager();

	value = not not value;

	CampaignUI.ClearSelection();
	
	local overrides_to_lock = {
		"selection_change",
		"stances",
		"radar_rollout_buttons",
		"recruit_units",
		"disband_unit",
		"diplomacy",
		"technology",
		"rituals",
		"finance",
		"tactical_map",
		"faction_button",
		"missions",
		"intrigue_at_the_court",
		"geomantic_web",
		"slaves",
		"skaven_corruption",
		"esc_menu",
		"help_panel_button",
		"spell_browser",
		"camera_settings",
		"end_turn_options",
		"mortuary_cult",
		"books_of_nagash",
		"regiments_of_renown",
		"sword_of_khaine"
	};
	
	cm:override_ui("disable_fullscreen_panel_closing", value);
	
	if value then
		for i = 1, #overrides_to_lock do
			uim:override(overrides_to_lock[i]):lock();
		end;
	else
		for i = 1, #overrides_to_lock do
			uim:override(overrides_to_lock[i]):unlock();			
		end;
		-- lift fullscreen highlight
		core:hide_fullscreen_highlight();
		cm:dismiss_advice();
		in_beastmen_panel_tour:complete();
	end;
end;

function trigger_beastmen_panel_scripted_tour()
	if cm:get_campaign_ui_manager():is_panel_open("beastmen_panel") then
		local uic_panel = find_child_uicomponent(core:get_ui_root(), "beastmen_panel");
		if not uic_panel then
			script_error("ERROR: beastmen_panel_scripted_tour_open_panel() could not find the beastmen panel, how can this be?");
			beastmen_panel_tour_lock_ui(false);
			return false;
		end;
		beastmen_panel_scripted_tour_tabs_advice(uic_panel)

	else

		local uic_beastmen_panel_button = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_group_management", "button_beastmen_panel");
		if not uic_beastmen_panel_button then
			script_error("ERROR: trigger_beastmen_panel_scripted_tour() could not find the beastmen panel button, how can this be?");
			return false;
		end;
		
		-- lock ui
		beastmen_panel_tour_lock_ui(true);
		
		-- show fullscreen highlight around the beastmen panel button
		core:show_fullscreen_highlight_around_components(25, false, false, uic_beastmen_panel_button);
		
		-- pulse the button
		pulse_uicomponent(uic_beastmen_panel_button, true, 5);
		
		-- set up button text pointer
		local uic_beastmen_panel_button_size_x, uic_beastmen_panel_button_size_y = uic_beastmen_panel_button:Dimensions();
		local uic_beastmen_panel_button_pos_x, uic_beastmen_panel_button_pos_y = uic_beastmen_panel_button:Position();
		
		local tp_beastmen_panel_button = text_pointer:new("beastmen_panel_button", "right", 100, uic_beastmen_panel_button_pos_x + uic_beastmen_panel_button_size_x / 5, uic_beastmen_panel_button_pos_y + (uic_beastmen_panel_button_size_y / 2));
		tp_beastmen_panel_button:set_layout("text_pointer_text_only");
		tp_beastmen_panel_button:add_component_text("text", "ui_text_replacements_localised_text_dlc17_text_pointer_beastmen_panel_button");
		tp_beastmen_panel_button:set_style("semitransparent_highlight");
		tp_beastmen_panel_button:set_panel_width(300);
		
		tp_beastmen_panel_button:set_close_button_callback(
			function()
				-- hide text pointer
				tp_beastmen_panel_button:hide();

				-- stop pulsing button
				pulse_uicomponent(uic_beastmen_panel_button, false, 5);
				beastmen_panel_scripted_tour_open_panel(uic_beastmen_panel_button);
			end
		);
		
		cm:callback(
			function()
				tp_beastmen_panel_button:show();
			end,
			0.5
		);
	end
end;

function beastmen_panel_scripted_tour_open_panel(uic_beastmen_panel_button)
	
	local event_name = "beastmen_panel_scripted_tour";		
				
	-- lift fullscreen highlight
	core:hide_fullscreen_highlight();

	-- establish listener for the beastmen panel opening						
	core:add_listener(
		event_name,
		"PanelOpenedCampaign",
		function(context)
			return context.string == "beastmen_panel"
		end,
		function(context)
			out("%%%%% Beastmen panel opened");

			cm:remove_callback(event_name);
			
			local uic_panel = find_uicomponent(core:get_ui_root(), "beastmen_panel");
			if not uic_panel then
				script_error("ERROR: beastmen_panel_scripted_tour_open_panel() could not find the beastmen panel, how can this be?");
				beastmen_panel_tour_lock_ui(false);
				return false;
			end;
			
			-- wait for the panel to finish animating
			core:progress_on_uicomponent_animation(
				event_name, 
				uic_panel, 
				function()	
					beastmen_panel_scripted_tour_tabs_advice(uic_panel)
				end
			);
		end,
		false
	);
	-- failsafe: panel hasn't opened for some reason, exit
	cm:callback(
		function()
			script_error("WARNING: beastmen_panel_scripted_tour_open_panel() attempted to open the beastmen panel but it didn't open, exiting");
			core:remove_listener(event_name);
			beastmen_panel_tour_lock_ui(false);
			return false;
		end,
		0.5,
		event_name
	);						

	-- simulate click on beastmen button to open the beastmen panel
	uic_beastmen_panel_button:SimulateLClick();
end

function beastmen_panel_scripted_tour_tabs_advice(uic_panel)
	-- Move advice topmost
	core:cache_and_set_advisor_priority(1500, true);
	cm:show_advice("wh2.dlc17.camp.advice.bst.panel.001.open");

	--uic_panel:StealShortcutKey(false);

	local uic_beastmen_panel_tabs = find_uicomponent(uic_panel, "tab_holder", "button_tab_holder");
	local uic_unit_caps_button = find_uicomponent(uic_beastmen_panel_tabs, "unit_caps");
	local uic_lords_and_heroes_button = find_uicomponent(uic_beastmen_panel_tabs, "lords_and_heroes");
	local uic_upgrades_button = find_uicomponent(uic_beastmen_panel_tabs, "upgrades");
	local uic_items_button = find_uicomponent(uic_beastmen_panel_tabs, "items");
	
	if not uic_beastmen_panel_tabs then
		script_error("WARNING: beastmen_panel_scripted_tour_tabs_advice() could not find the button_tab_holder uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;

	if not uic_unit_caps_button then
		script_error("WARNING: beastmen_panel_scripted_tour_tabs_advice() could not find the unit caps button uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;

	if not uic_lords_and_heroes_button then
		script_error("WARNING: beastmen_panel_scripted_tour_tabs_advice() could not find the lords and heroes button uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;

	if not uic_upgrades_button then
		script_error("WARNING: beastmen_panel_scripted_tour_tabs_advice() could not find the upgrades button uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;

	if not uic_items_button then
		script_error("WARNING: beastmen_panel_scripted_tour_tabs_advice() could not find the items button uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;

	-- show fullscreen highlight over the tabs
	core:show_fullscreen_highlight_around_components(25, false, false, uic_beastmen_panel_tabs);
	
	-- pulse each of the augment tabs
	pulse_uicomponent(uic_unit_caps_button, true, 5, true);
	pulse_uicomponent(uic_lords_and_heroes_button, true, 5, true);
	pulse_uicomponent(uic_upgrades_button, true, 5, true);
	pulse_uicomponent(uic_items_button, true, 5, true);
	
	-- set up text pointer
	local uic_beastmen_panel_tabs_size_x, uic_beastmen_panel_tabs_size_y = uic_beastmen_panel_tabs:Dimensions();
	local uic_beastmen_panel_tabs_pos_x, uic_beastmen_panel_tabs_pos_y = uic_beastmen_panel_tabs:Position();
	
	local tp_beastmen_panel_tabs = text_pointer:new("beastmen_panel_tabs", "top", 100, uic_beastmen_panel_tabs_pos_x + (uic_beastmen_panel_tabs_size_x / 2), uic_beastmen_panel_tabs_pos_y + (uic_beastmen_panel_tabs_size_y / 3));
	tp_beastmen_panel_tabs:set_layout("text_pointer_text_only");
	tp_beastmen_panel_tabs:add_component_text("text", "ui_text_replacements_localised_text_dlc17_text_pointer_beastmen_panel_tabs");
	tp_beastmen_panel_tabs:set_style("semitransparent_highlight");
	tp_beastmen_panel_tabs:set_panel_width(300);
	
	tp_beastmen_panel_tabs:set_close_button_callback(
		function()
			-- hide text pointer
			tp_beastmen_panel_tabs:hide();
			
			-- lift fullscreen highlight
			core:hide_fullscreen_highlight();
		
			beastmen_panel_scripted_tour_unit_cap_advice(uic_panel);
		end
	);

	cm:callback(
		function()
			tp_beastmen_panel_tabs:show();
		end,
		0.5
	);

end

function beastmen_panel_scripted_tour_unit_cap_advice(uic_panel)
	local uic_beastmen_panel_tabs = find_uicomponent(uic_panel, "tab_holder", "button_tab_holder");
	
	if not uic_beastmen_panel_tabs then
		script_error("WARNING: beastmen_panel_scripted_tour_unit_cap_advice() could not find the button_tab_holder uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;
	
	local uic_unit_caps_button = find_uicomponent(uic_beastmen_panel_tabs, "unit_caps");
	local uic_lords_and_heroes_button = find_uicomponent(uic_beastmen_panel_tabs, "lords_and_heroes");
	local uic_upgrades_button = find_uicomponent(uic_beastmen_panel_tabs, "upgrades");
	local uic_items_button = find_uicomponent(uic_beastmen_panel_tabs, "items");

	if not uic_unit_caps_button then
		script_error("WARNING: beastmen_panel_scripted_tour_unit_cap_advice() could not find the unit caps button uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;

	if not uic_lords_and_heroes_button then
		script_error("WARNING: beastmen_panel_scripted_tour_unit_cap_advice() could not find the lords and heroes button uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;

	if not uic_upgrades_button then
		script_error("WARNING: beastmen_panel_scripted_tour_unit_cap_advice() could not find the upgrades button uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;

	if not uic_items_button then
		script_error("WARNING: beastmen_panel_scripted_tour_unit_cap_advice() could not find the items button uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;
	
	-- stop pulsing highlight of augment tabs
	pulse_uicomponent(uic_unit_caps_button, false, 5, true);
	pulse_uicomponent(uic_lords_and_heroes_button, false, 5, true);
	pulse_uicomponent(uic_upgrades_button, false, 5, true);
	pulse_uicomponent(uic_items_button, false, 5, true);
	
	--dismiss the advisor to get him out of the tour
	cm:dismiss_advice()
	-- Move advice topmost
	core:cache_and_set_advisor_priority(1500, true);
	cm:show_advice("wh2.dlc17.camp.advice.bst.panel.002.units")

	local uic_unit_caps_holder = find_uicomponent(uic_panel, "mid_colum", "unit_caps");

	if not uic_unit_caps_holder then
		script_error("WARNING: beastmen_panel_scripted_tour_unit_cap_advice() could not find the uic_unit_caps_holder uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;
	
	local uic_ungor_unit_cap = find_uicomponent(uic_unit_caps_holder, "CcoCampaignRitual" .. tostring(cm:get_local_faction(true):command_queue_index()) .."wh2_dlc17_bst_ritual_unit_cap_ungor_herd_spearmen_herd");

	if not uic_ungor_unit_cap then
		script_error("WARNING: beastmen_panel_scripted_tour_unit_cap_advice() could not find the uic_ungor_unit_cap uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;

	-- show fullscreen highlight over uic_ungor_unit_cap
	core:show_fullscreen_highlight_around_components(25, false, false, uic_ungor_unit_cap);
	
	-- pulse uic_ungor_unit_cap
	pulse_uicomponent(uic_ungor_unit_cap, true, 5, true);
	
	-- set up text pointer
	local uic_unit_caps_holder_size_x, uic_unit_caps_holder_size_y = uic_unit_caps_holder:Dimensions();
	local uic_unit_caps_holder_pos_x, uic_unit_caps_holder_pos_y = uic_unit_caps_holder:Position();
	
	local tp_unit_caps_holder = text_pointer:new("unit_caps_holder", "left", 125, uic_unit_caps_holder_pos_x + (uic_unit_caps_holder_size_x / 5), uic_unit_caps_holder_pos_y + (uic_unit_caps_holder_size_y / 5));
	tp_unit_caps_holder:set_layout("text_pointer_text_only");
	tp_unit_caps_holder:add_component_text("text", "ui_text_replacements_localised_text_dlc17_text_pointer_beastmen_panel_unit_caps_holder");
	tp_unit_caps_holder:set_style("semitransparent_highlight");
	tp_unit_caps_holder:set_panel_width(350);

	tp_unit_caps_holder:set_close_button_callback(
		function()
			-- hide text pointer
			tp_unit_caps_holder:hide();
			
			-- lift fullscreen highlight
			core:hide_fullscreen_highlight();

			beastmen_panel_scripted_tour_unit_caps_dread_advice(uic_panel)
		end
	);	
	
	cm:callback(
		function()
			tp_unit_caps_holder:show();
		end,
		0.5
	);

end

function beastmen_panel_scripted_tour_unit_caps_dread_advice(uic_panel)
	local uic_unit_caps_holder = find_uicomponent(uic_panel, "mid_colum", "unit_caps");

	if not uic_unit_caps_holder then
		script_error("WARNING: beastmen_panel_scripted_tour_unit_caps_dread_advice() could not find the uic_unit_caps_holder uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;
	
	local uic_ungor_unit_cap = find_uicomponent(uic_unit_caps_holder, "CcoCampaignRitual" .. tostring(cm:get_local_faction(true):command_queue_index()) .."wh2_dlc17_bst_ritual_unit_cap_ungor_herd_spearmen_herd");

	if not uic_ungor_unit_cap then
		script_error("WARNING: beastmen_panel_scripted_tour_unit_caps_dread_advice() could not find the uic_ungor_unit_cap uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;
	
	-- stop pulsing the ungor unit group
	pulse_uicomponent(uic_ungor_unit_cap, false, 5, true);

	--dismiss the advisor to get him out of the tour
	cm:dismiss_advice();

	local uic_unit_caps_button = find_uicomponent(uic_ungor_unit_cap, "cost_and_button_holder");

	if not uic_unit_caps_button then
		script_error("WARNING: beastmen_panel_scripted_tour_unit_caps_dread_advice() could not find the cost_and_button_holder uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;
	
	-- show fullscreen highlight over the map
	core:show_fullscreen_highlight_around_components(15, false, false, uic_unit_caps_button);
	
	-- pulse the augment effects holder
	pulse_uicomponent(uic_unit_caps_button, true, 5, true);
	
	-- set up text pointer
	local uic_unit_caps_button_size_x, uic_unit_caps_button_size_y = uic_unit_caps_button:Dimensions();
	local uic_unit_caps_button_pos_x, uic_unit_caps_button_pos_y = uic_unit_caps_button:Position();
	
	local tp_unit_caps_button = text_pointer:new("unit_caps_button", "top", 100, uic_unit_caps_button_pos_x + (uic_unit_caps_button_size_x / 2), uic_unit_caps_button_pos_y + uic_unit_caps_button_size_y);
	tp_unit_caps_button:set_layout("text_pointer_text_only");
	tp_unit_caps_button:add_component_text("text", "ui_text_replacements_localised_text_dlc17_text_pointer_beastmen_panel_unit_caps_dread");
	tp_unit_caps_button:set_style("semitransparent_highlight");
	tp_unit_caps_button:set_panel_width(350);
	
	tp_unit_caps_button:set_close_button_callback(
		function()
			-- hide text pointer
			tp_unit_caps_button:hide();
			
			-- lift fullscreen highlight
			core:hide_fullscreen_highlight();	
			
			beastmen_panel_scripted_tour_unit_caps_marks_advice(uic_panel)
		end
	);

	cm:callback(
		function()
			tp_unit_caps_button:show();
		end,
		0.5
	);

end

function beastmen_panel_scripted_tour_unit_caps_marks_advice(uic_panel)
	local uic_unit_caps_holder = find_uicomponent(uic_panel, "mid_colum", "unit_caps");

	if not uic_unit_caps_holder then
		script_error("WARNING: beastmen_panel_scripted_tour_unit_caps_marks_advice() could not find the uic_unit_caps_holder uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;
	
	local uic_ungor_unit_cap = find_uicomponent(uic_unit_caps_holder, "CcoCampaignRitual" .. tostring(cm:get_local_faction(true):command_queue_index()) .."wh2_dlc17_bst_ritual_unit_cap_ungor_herd_spearmen_herd");

	if not uic_ungor_unit_cap then
		script_error("WARNING: beastmen_panel_scripted_tour_unit_caps_marks_advice() could not find the uic_ungor_unit_cap uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;
	
	local uic_unit_caps_button = find_uicomponent(uic_ungor_unit_cap, "cost_and_button_holder");

	if not uic_unit_caps_button then
		script_error("WARNING: beastmen_panel_scripted_tour_unit_caps_dread_advice() could not find the cost_and_button_holder uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;
	
	-- stop pulsing highlight of the augment effects holder
	pulse_uicomponent(uic_unit_caps_button, false, 5, true);
	
	local uic_bestigor_unit_cap = find_uicomponent(uic_unit_caps_holder, "CcoCampaignRitual" .. tostring(cm:get_local_faction(true):command_queue_index()) .."wh2_dlc17_bst_ritual_unit_cap_bestigor_herd");

	if not uic_bestigor_unit_cap then
		script_error("WARNING: beastmen_panel_scripted_tour_unit_caps_marks_advice() could not find the uic_bestigor_unit_cap uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;

	local uic_bestigor_marks = find_uicomponent(uic_bestigor_unit_cap, "locked_requirement");

	if not uic_bestigor_marks then
		script_error("WARNING: beastmen_panel_scripted_tour_unit_caps_marks_advice() could not find the uic_bestigor_marks uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;
	
	-- show fullscreen highlight over the map
	core:show_fullscreen_highlight_around_components(25, false, false, uic_bestigor_unit_cap);
	
	-- pulse the augment effects holder
	pulse_uicomponent(uic_bestigor_marks, true, 5, true);
	
	-- set up text pointer
	local uic_bestigor_marks_size_x, uic_bestigor_marks_size_y = uic_bestigor_marks:Dimensions();
	local uic_bestigor_marks_pos_x, uic_bestigor_marks_pos_y = uic_bestigor_marks:Position();
	
	local tp_bestigor_marks = text_pointer:new("bestigor_marks", "right", 50, uic_bestigor_marks_pos_x, uic_bestigor_marks_pos_y + (uic_bestigor_marks_size_y / 2));
	tp_bestigor_marks:set_layout("text_pointer_text_only");
	tp_bestigor_marks:add_component_text("text", "ui_text_replacements_localised_text_dlc17_text_pointer_beastmen_panel_unit_caps_marks");
	tp_bestigor_marks:set_style("semitransparent_highlight");
	tp_bestigor_marks:set_panel_width(350);

	tp_bestigor_marks:set_close_button_callback(
		function()
			-- hide text pointer
			tp_bestigor_marks:hide();
			
			-- lift fullscreen highlight
			core:hide_fullscreen_highlight();
			
			beastmen_panel_scripted_tour_unit_caps_pooled_resources_advice(uic_panel)
		end
	);

	cm:callback(
		function()
			tp_bestigor_marks:show();
		end,
		0.5
	);

end

function beastmen_panel_scripted_tour_unit_caps_pooled_resources_advice(uic_panel)
	local uic_unit_caps_holder = find_uicomponent(uic_panel, "mid_colum", "unit_caps");

	if not uic_unit_caps_holder then
		script_error("WARNING: beastmen_panel_scripted_tour_unit_caps_pooled_resources_advice() could not find the uic_unit_caps_holder uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;
	
	local uic_bestigor_unit_cap = find_uicomponent(uic_unit_caps_holder, "CcoCampaignRitual" .. tostring(cm:get_local_faction(true):command_queue_index()) .."wh2_dlc17_bst_ritual_unit_cap_bestigor_herd");

	if not uic_bestigor_unit_cap then
		script_error("WARNING: beastmen_panel_scripted_tour_unit_caps_pooled_resources_advice() could not find the uic_bestigor_unit_cap uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;
	
	local uic_bestigor_marks = find_uicomponent(uic_bestigor_unit_cap, "locked_requirement");

	if not uic_bestigor_marks then
		script_error("WARNING: beastmen_panel_scripted_tour_unit_caps_pooled_resources_advice() could not find the uic_bestigor_marks uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;
	
	-- stop pulsing highlight of the augment effects holder
	pulse_uicomponent(uic_bestigor_marks, false, 5, true);

	local uic_marks_holder = find_uicomponent(uic_panel, "header_parent", "marks_of_ruination_holder");
	local uic_treasury_holder = find_uicomponent(uic_panel, "header_parent", "dy_treasury");
	local uic_dread_holder = find_uicomponent(uic_panel, "header_parent", "dy_dread");

	if not uic_marks_holder then
		script_error("WARNING: beastmen_panel_scripted_tour_unit_caps_pooled_resources_advice() could not find the uic_marks_holder uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;

	if not uic_treasury_holder then
		script_error("WARNING: beastmen_panel_scripted_tour_unit_caps_pooled_resources_advice() could not find the uic_treasury_holder uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;

	if not uic_dread_holder then
		script_error("WARNING: beastmen_panel_scripted_tour_unit_caps_pooled_resources_advice() could not find the uic_dread_holder uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;

	-- show fullscreen highlight over the holders
	core:show_fullscreen_highlight_around_components(25, false, false, uic_marks_holder, uic_treasury_holder, uic_dread_holder);
	
	-- pulse the holders
	pulse_uicomponent(uic_marks_holder, true, 5, true);
	pulse_uicomponent(uic_treasury_holder, true, 5, true);
	pulse_uicomponent(uic_dread_holder, true, 5, true);
	
	-- set up text pointer
	local uic_marks_holder_size_x, uic_marks_holder_size_y = uic_marks_holder:Dimensions();
	local uic_marks_holder_pos_x, uic_marks_holder_pos_y = uic_marks_holder:Position();
	
	local tp_marks_holder = text_pointer:new("marks_holder", "top", 100, uic_marks_holder_pos_x + (uic_marks_holder_size_x / 2), uic_marks_holder_pos_y + uic_marks_holder_size_y);
	tp_marks_holder:set_layout("text_pointer_text_only");
	tp_marks_holder:add_component_text("text", "ui_text_replacements_localised_text_dlc17_text_pointer_beastmen_panel_pooled_resources");
	tp_marks_holder:set_style("semitransparent_highlight");
	tp_marks_holder:set_panel_width(350);

	tp_marks_holder:set_close_button_callback(
		function()
			-- hide text pointer
			tp_marks_holder:hide();
			
			-- lift fullscreen highlight
			core:hide_fullscreen_highlight();	
			
			beastmen_panel_scripted_tour_lords_and_heroes_tab_advice(uic_panel)
		end
	);

	cm:callback(
		function()
			tp_marks_holder:show();
		end,
		0.5
	);

end

function beastmen_panel_scripted_tour_lords_and_heroes_tab_advice(uic_panel)
	local uic_marks_holder = find_uicomponent(uic_panel, "header_parent", "marks_of_ruination_holder");
	local uic_treasury_holder = find_uicomponent(uic_panel, "header_parent", "dy_treasury");
	local uic_dread_holder = find_uicomponent(uic_panel, "header_parent", "dy_dread");

	if not uic_marks_holder then
		script_error("WARNING: beastmen_panel_scripted_tour_lords_and_heroes_tab_advice() could not find the uic_marks_holder uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;

	if not uic_treasury_holder then
		script_error("WARNING: beastmen_panel_scripted_tour_lords_and_heroes_tab_advice() could not find the uic_treasury_holder uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;

	if not uic_dread_holder then
		script_error("WARNING: beastmen_panel_scripted_tour_lords_and_heroes_tab_advice() could not find the uic_dread_holder uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;
	
	-- stop pulsing highlight of the augment effects holder
	pulse_uicomponent(uic_marks_holder, false, 5, true);
	pulse_uicomponent(uic_treasury_holder, false, 5, true);
	pulse_uicomponent(uic_dread_holder, false, 5, true);

	local event_name = "beastmen_panel_scripted_tour";
	local uic_lords_and_heroes_tab = find_uicomponent(uic_panel, "tab_holder", "button_tab_holder", "lords_and_heroes");

	if not uic_lords_and_heroes_tab then
		script_error("WARNING: beastmen_panel_scripted_tour_lords_and_heroes_tab_advice() could not find the uic_lords_and_heroes_tab uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;

	-- show fullscreen highlight over the button
	core:show_fullscreen_highlight_around_components(25, false, false, uic_lords_and_heroes_tab);
	
	-- pulse the holders
	pulse_uicomponent(uic_lords_and_heroes_tab, true, 5, true);
	
	-- set up text pointer
	local uic_lords_and_heroes_tab_size_x, uic_lords_and_heroes_tab_size_y = uic_lords_and_heroes_tab:Dimensions();
	local uic_lords_and_heroes_tab_pos_x, uic_lords_and_heroes_tab_pos_y = uic_lords_and_heroes_tab:Position();
	
	local tp_lords_and_heroes_tab = text_pointer:new("lords_and_heroes_tab", "top", 50, uic_lords_and_heroes_tab_pos_x + (uic_lords_and_heroes_tab_size_x / 2), uic_lords_and_heroes_tab_pos_y + (uic_lords_and_heroes_tab_size_y / 2));
	tp_lords_and_heroes_tab:set_layout("text_pointer_text_only");
	tp_lords_and_heroes_tab:add_component_text("text", "ui_text_replacements_localised_text_dlc17_text_pointer_beastmen_panel_lords_and_heroes_tab");
	tp_lords_and_heroes_tab:set_style("semitransparent_highlight");
	tp_lords_and_heroes_tab:set_panel_width(350);

	tp_lords_and_heroes_tab:set_close_button_callback(
		function()
			-- establish listener for the Lords and Heroes tab opening						
			core:add_listener(
				event_name,
				"ComponentLClickUp", 
				function(context) 
					return UIComponent(context.component) == uic_lords_and_heroes_tab;
				end, 
				function(context)
					out("%%%%% Lords and Heroes tab opened");
				
					cm:remove_callback(event_name);

					-- wait for the panel to finish animating
					core:progress_on_uicomponent_animation(
						event_name, 
						uic_lords_and_heroes_tab, 
						function()
							-- hide text pointer
							tp_lords_and_heroes_tab:hide();
							
							-- lift fullscreen highlight
							core:hide_fullscreen_highlight();

							beastmen_panel_scripted_tour_legendary_lords_advice(uic_panel)
						end
					);
				end, 
				false
			);
			-- failsafe: tab hasn't opened for some reason, exit
			cm:callback(
				function()
					script_error("WARNING: beastmen_panel_scripted_tour_lords_and_heroes_tab_advice() attempted to open Lords and Heroes tab but it didn't open, exiting");
					core:remove_listener(event_name);
					beastmen_panel_tour_lock_ui(false);
					return false;
				end,
				0.5,
				event_name
			);						
			
			-- simulate click on lords and heroes tab to open it in the beastmen panel
			uic_lords_and_heroes_tab:SimulateLClick();	
							
		end
	);
	cm:callback(
		function()
			tp_lords_and_heroes_tab:show();
		end,
		0.5
	);
end

function beastmen_panel_scripted_tour_legendary_lords_advice(uic_panel)
	local uic_lords_and_heroes_tab = find_uicomponent(uic_panel, "tab_holder", "button_tab_holder", "lords_and_heroes");

	if not uic_lords_and_heroes_tab then
		script_error("WARNING: beastmen_panel_scripted_tour_legendary_lords_advice() could not find the uic_lords_and_heroes_tab uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;

	-- stop pulsing highlight of the lords and heroes holder
	pulse_uicomponent(uic_lords_and_heroes_tab, false, 5, true);

	-- Move advice topmost
	core:cache_and_set_advisor_priority(1500, true);	
	cm:show_advice("wh2.dlc17.camp.advice.bst.panel.003.lords")

	local uic_lords_holder = find_uicomponent(uic_panel, "lords_and_heroes", "lords_list");

	if not uic_lords_holder then
		script_error("WARNING: beastmen_panel_scripted_tour_legendary_lords_advice() could not find the uic_lords_holder uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;

	-- show fullscreen highlight over the holders
	core:show_fullscreen_highlight_around_components(25, false, false, uic_lords_holder);
	
	-- pulse the holders
	pulse_uicomponent(uic_lords_holder, true, 5, true);
	
	-- set up text pointer
	local uic_lords_holder_size_x, uic_lords_holder_size_y = uic_lords_holder:Dimensions();
	local uic_lords_holder_pos_x, uic_lords_holder_pos_y = uic_lords_holder:Position();
	
	local tp_lords_holder = text_pointer:new("lords_holder", "left", 50, uic_lords_holder_pos_x + uic_lords_holder_size_x, uic_lords_holder_pos_y + (uic_lords_holder_size_y / 2));
	tp_lords_holder:set_layout("text_pointer_text_only");
	tp_lords_holder:add_component_text("text", "ui_text_replacements_localised_text_dlc17_text_pointer_beastmen_panel_lords");
	tp_lords_holder:set_style("semitransparent_highlight");
	tp_lords_holder:set_panel_width(350);

	tp_lords_holder:set_close_button_callback(
		function()
			-- hide text pointer
			tp_lords_holder:hide();
			
			-- lift fullscreen highlight
			core:hide_fullscreen_highlight();	
			
			beastmen_panel_scripted_tour_heroes_advice(uic_panel)
		end
	);

	cm:callback(
		function()
			tp_lords_holder:show();
		end,
		0.5
	);

end

function beastmen_panel_scripted_tour_heroes_advice(uic_panel)
	local uic_lords_holder = find_uicomponent(uic_panel, "lords_and_heroes", "lords_list");

	if not uic_lords_holder then
		script_error("WARNING: beastmen_panel_scripted_tour_heroes_advice() could not find the uic_lords_holder uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;

	-- stop pulsing highlight of the augment effects holder
	pulse_uicomponent(uic_lords_holder, false, 5, true);

	--dismiss the advisor to get him out of the tour
	cm:dismiss_advice()

	local uic_hero_holder = find_uicomponent(uic_panel, "lords_and_heroes", "character_list_parent");

	if not uic_hero_holder then
		script_error("WARNING: beastmen_panel_scripted_tour_heroes_advice() could not find the uic_hero_holder uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;

	-- show fullscreen highlight over the holders
	core:show_fullscreen_highlight_around_components(25, false, false, uic_hero_holder);
	
	-- pulse the holders
	pulse_uicomponent(uic_hero_holder, true, 5, true);
	
	-- set up text pointer
	local uic_hero_holder_size_x, uic_hero_holder_size_y = uic_hero_holder:Dimensions();
	local uic_hero_holder_pos_x, uic_hero_holder_pos_y = uic_hero_holder:Position();
	
	local tp_hero_holder = text_pointer:new("hero_holder", "right", 50, uic_hero_holder_pos_x, uic_hero_holder_pos_y + (uic_hero_holder_size_y / 2));
	tp_hero_holder:set_layout("text_pointer_text_only");
	tp_hero_holder:add_component_text("text", "ui_text_replacements_localised_text_dlc17_text_pointer_beastmen_panel_heroes");
	tp_hero_holder:set_style("semitransparent_highlight");
	tp_hero_holder:set_panel_width(350);

	tp_hero_holder:set_close_button_callback(
		function()
			-- hide text pointer
			tp_hero_holder:hide();
			
			-- lift fullscreen highlight
			core:hide_fullscreen_highlight();	
			
			beastmen_panel_scripted_tour_upgrades_tab_advice(uic_panel)
		end
	);

	cm:callback(
		function()
			tp_hero_holder:show();
		end,
		0.5
	);

end

function beastmen_panel_scripted_tour_upgrades_tab_advice(uic_panel)
	local uic_hero_holder = find_uicomponent(uic_panel, "lords_and_heroes", "character_list_parent");

	if not uic_hero_holder then
		script_error("WARNING: beastmen_panel_scripted_tour_upgrades_tab_advice() could not find the uic_hero_holder uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;

	-- stop pulsing highlight of the augment effects holder
	pulse_uicomponent(uic_hero_holder, false, 5, true);
	
	local event_name = "beastmen_panel_scripted_tour";
	
	local uic_upgrades_tab = find_uicomponent(uic_panel, "tab_holder", "button_tab_holder", "upgrades");

	if not uic_upgrades_tab then
		script_error("WARNING: beastmen_panel_scripted_tour_herdstone_upgrades_advice() could not find the uic_upgrades_tab uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;

	-- show fullscreen highlight over the button
	core:show_fullscreen_highlight_around_components(25, false, false, uic_upgrades_tab);
	
	-- pulse the holders
	pulse_uicomponent(uic_upgrades_tab, true, 5, true);
	
	-- set up text pointer
	local uic_upgrades_tab_size_x, uic_upgrades_tab_size_y = uic_upgrades_tab:Dimensions();
	local uic_upgrades_tab_pos_x, uic_upgrades_tab_pos_y = uic_upgrades_tab:Position();
	
	local tp_upgrades_tab = text_pointer:new("upgrades_tab", "top", 50, uic_upgrades_tab_pos_x + (uic_upgrades_tab_size_x / 2), uic_upgrades_tab_pos_y + (uic_upgrades_tab_size_y / 2));
	tp_upgrades_tab:set_layout("text_pointer_text_only");
	tp_upgrades_tab:add_component_text("text", "ui_text_replacements_localised_text_dlc17_text_pointer_beastmen_panel_upgrades_tab");
	tp_upgrades_tab:set_style("semitransparent_highlight");
	tp_upgrades_tab:set_panel_width(350);

	tp_upgrades_tab:set_close_button_callback(
		function()
			-- establish listener for the flesh lab panel opening						
			core:add_listener(
				event_name,
				"ComponentLClickUp", 
				function(context) 
					return UIComponent(context.component) == uic_upgrades_tab;
				end, 
				function(context)
					out("%%%%% Upgrades tab opened");
				
					cm:remove_callback(event_name);

					-- wait for the panel to finish animating
					core:progress_on_uicomponent_animation(
						event_name, 
						uic_upgrades_tab, 
						function()
							-- hide text pointer
							tp_upgrades_tab:hide();
													
							-- lift fullscreen highlight
							core:hide_fullscreen_highlight();

							beastmen_panel_scripted_tour_herdstone_upgrades_advice(uic_panel)
						end
					);
				end, 
				false
			);
			-- failsafe: tab hasn't opened for some reason, exit
			cm:callback(
				function()
					script_error("WARNING: beastmen_panel_scripted_tour_upgrades_tab_advice() attempted to open Upgrades tab but it didn't open, exiting");
					core:remove_listener(event_name);
					beastmen_panel_tour_lock_ui(false);
					return false;
				end,
				0.5,
				event_name
			);						
			
			-- simulate click on lords and heroes tab to open it in the beastmen panel
			uic_upgrades_tab:SimulateLClick();							
				
		end
	);
	cm:callback(
		function()
			tp_upgrades_tab:show();
		end,
		0.5
	);
end

function beastmen_panel_scripted_tour_herdstone_upgrades_advice(uic_panel)
	local uic_upgrades_tab = find_uicomponent(uic_panel, "tab_holder", "button_tab_holder", "upgrades");

	if not uic_upgrades_tab then
		script_error("WARNING: beastmen_panel_scripted_tour_herdstone_upgrades_advice() could not find the uic_upgrades_tab uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;

	-- stop pulsing highlight of the units holder
	pulse_uicomponent(uic_upgrades_tab, false, 5, true);

	-- Move advice topmost
	core:cache_and_set_advisor_priority(1500, true);	
	cm:show_advice("wh2.dlc17.camp.advice.bst.panel.005.upgrades")

	local uic_herdstone = find_uicomponent(uic_panel, "herdstone_upgrades_content_holder", "herdtsone_upgrades_list");

	if not uic_herdstone then
		script_error("WARNING: beastmen_panel_scripted_tour_herdstone_upgrades_advice() could not find the uic_herdstone uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;

	-- show fullscreen highlight over the holders
	core:show_fullscreen_highlight_around_components(25, false, false, uic_herdstone);
	
	-- pulse the holders
	pulse_uicomponent(uic_herdstone, true, 5, true);
	
	-- set up text pointer
	local uic_herdstone_size_x, uic_herdstone_size_y = uic_herdstone:Dimensions();
	local uic_herdstone_pos_x, uic_herdstone_pos_y = uic_herdstone:Position();
	
	local tp_herdstone = text_pointer:new("herdstone", "left", 50, uic_herdstone_pos_x + uic_herdstone_size_x, uic_herdstone_pos_y + (uic_herdstone_size_y / 2));
	tp_herdstone:set_layout("text_pointer_text_only");
	tp_herdstone:add_component_text("text", "ui_text_replacements_localised_text_dlc17_text_pointer_beastmen_panel_herdstone_upgrades");
	tp_herdstone:set_style("semitransparent_highlight");
	tp_herdstone:set_panel_width(350);

	tp_herdstone:set_close_button_callback(
		function()
			-- hide text pointer
			tp_herdstone:hide();
			
			-- lift fullscreen highlight
			core:hide_fullscreen_highlight();	
			
			beastmen_panel_scripted_tour_faction_upgrades_advice(uic_panel)
		end
	);

	cm:callback(
		function()
			tp_herdstone:show();
		end,
		0.5
	);

end

function beastmen_panel_scripted_tour_faction_upgrades_advice(uic_panel)
	local uic_herdstone = find_uicomponent(uic_panel, "herdstone_upgrades_content_holder", "herdtsone_upgrades_list");

	if not uic_herdstone then
		script_error("WARNING: beastmen_panel_scripted_tour_faction_upgrades_advice() could not find the uic_herdstone uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;
	
	-- stop pulsing highlight of the herdstone holder
	pulse_uicomponent(uic_herdstone, false, 5, true);

	--dismiss the advisor to get him out of the tour
	cm:dismiss_advice()

	local uic_faction_upgrades = find_uicomponent(uic_panel, "faction_upgrades_content_holder", "herdtsone_upgrades_list");

	if not uic_faction_upgrades then
		script_error("WARNING: beastmen_panel_scripted_tour_faction_upgrades_advice() could not find the uic_faction_upgrades uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;

	-- show fullscreen highlight over the holders
	core:show_fullscreen_highlight_around_components(75, false, false, uic_faction_upgrades);
	
	-- pulse the holders
	pulse_uicomponent(uic_faction_upgrades, true, 5, true);
	
	-- set up text pointer
	local uic_faction_upgrades_size_x, uic_faction_upgrades_size_y = uic_faction_upgrades:Dimensions();
	local uic_faction_upgrades_pos_x, uic_faction_upgrades_pos_y = uic_faction_upgrades:Position();
	
	local tp_faction_upgrades = text_pointer:new("faction_upgrades", "right", 50, uic_faction_upgrades_pos_x, uic_faction_upgrades_pos_y + (uic_faction_upgrades_size_y / 2));
	tp_faction_upgrades:set_layout("text_pointer_text_only");
	tp_faction_upgrades:add_component_text("text", "ui_text_replacements_localised_text_dlc17_text_pointer_beastmen_panel_faction_upgrades");
	tp_faction_upgrades:set_style("semitransparent_highlight");
	tp_faction_upgrades:set_panel_width(350);

	tp_faction_upgrades:set_close_button_callback(
		function()
			-- hide text pointer
			tp_faction_upgrades:hide();
			
			-- lift fullscreen highlight
			core:hide_fullscreen_highlight();	
			
			beastmen_panel_scripted_tour_items_tab_advice(uic_panel)
		end
	);

	cm:callback(
		function()
			tp_faction_upgrades:show();
		end,
		0.5
	);

end

function beastmen_panel_scripted_tour_items_tab_advice(uic_panel)
	local uic_faction_upgrades = find_uicomponent(uic_panel, "faction_upgrades_content_holder", "herdtsone_upgrades_list");

	if not uic_faction_upgrades then
		script_error("WARNING: beastmen_panel_scripted_tour_items_tab_advice() could not find the uic_faction_upgrades uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;
	
	-- stop pulsing highlight of the herdstone holder
	pulse_uicomponent(uic_faction_upgrades, false, 5, true);
	
	local event_name = "beastmen_panel_scripted_tour";
	local uic_items_tabs = find_uicomponent(uic_panel, "tab_holder", "button_tab_holder", "items");

	if not uic_items_tabs then
		script_error("WARNING: beastmen_panel_scripted_tour_items_tab_advice() could not find the uic_items_tabs uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;

	-- show fullscreen highlight over the button
	core:show_fullscreen_highlight_around_components(25, false, false, uic_items_tabs);
	
	-- pulse the holders
	pulse_uicomponent(uic_items_tabs, true, 5, true);
	
	-- set up text pointer
	local uic_items_tabs_size_x, uic_items_tabs_size_y = uic_items_tabs:Dimensions();
	local uic_items_tabs_pos_x, uic_items_tabs_pos_y = uic_items_tabs:Position();
	
	local tp_items_tab = text_pointer:new("items_tab", "top", 50, uic_items_tabs_pos_x + (uic_items_tabs_size_x / 2), uic_items_tabs_pos_y + (uic_items_tabs_size_y / 2));
	tp_items_tab:set_layout("text_pointer_text_only");
	tp_items_tab:add_component_text("text", "ui_text_replacements_localised_text_dlc17_text_pointer_beastmen_panel_items_tab");
	tp_items_tab:set_style("semitransparent_highlight");
	tp_items_tab:set_panel_width(350);

	tp_items_tab:set_close_button_callback(
		function()
			-- establish listener for the flesh lab panel opening						
			core:add_listener(
				event_name,
				"ComponentLClickUp", 
				function(context) 
					return UIComponent(context.component) == find_uicomponent(uic_items_tabs);
				end, 
				function(context)
					out("%%%%% Items tab opened");
				
					cm:remove_callback(event_name);

					-- wait for the panel to finish animating
					core:progress_on_uicomponent_animation(
						event_name, 
						uic_items_tabs, 
						function()
							-- hide text pointer
							tp_items_tab:hide();
														
							-- lift fullscreen highlight
							core:hide_fullscreen_highlight();

							beastmen_panel_scripted_tour_items_advice(uic_panel)
						end
					);
				end, 
				false
			);
			-- failsafe: tab hasn't opened for some reason, exit
			cm:callback(
				function()
					script_error("WARNING: beastmen_panel_scripted_tour_items_tab_advice() attempted to open Iems tab but it didn't open, exiting");
					core:remove_listener(event_name);
					beastmen_panel_tour_lock_ui(false);
					return false;
				end,
				0.5,
				event_name
			);						
			
			-- simulate click on lords and heroes tab to open it in the beastmen panel
			uic_items_tabs:SimulateLClick();
		end
	);
	cm:callback(
		function()
			tp_items_tab:show();
		end,
		0.5
	);
end

function beastmen_panel_scripted_tour_items_advice(uic_panel)
	local uic_items_tabs = find_uicomponent(uic_panel, "tab_holder", "button_tab_holder", "items");

	if not uic_items_tabs then
		script_error("WARNING: beastmen_panel_scripted_tour_items_advice() could not find the uic_items_tabs uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;
	
	-- stop pulsing highlight of the units holder
	pulse_uicomponent(uic_items_tabs, false, 5, true);
	
	-- Move advice topmost
	core:cache_and_set_advisor_priority(1500, true);
	
	cm:show_advice("wh2.dlc17.camp.advice.bst.panel.004.items")

	local uic_items = find_uicomponent(uic_panel, "mid_colum", "tab_contents", "item_central_docker", "items");

	if not uic_items then
		script_error("WARNING: beastmen_panel_scripted_tour_items_advice() could not find the uic_items uicomponent in the beastmen panel, how can this be?");
		beastmen_panel_tour_lock_ui(false);
		return false;
	end;

	-- show fullscreen highlight over the holders
	core:show_fullscreen_highlight_around_components(25, false, false, uic_items);
	
	-- pulse the holders
	pulse_uicomponent(uic_items, true, 5, true);
	
	-- set up text pointer
	local uic_items_size_x, uic_items_size_y = uic_items:Dimensions();
	local uic_items_pos_x, uic_items_pos_y = uic_items:Position();
	
	local tp_items = text_pointer:new("items", "top", 25, uic_items_pos_x + (uic_items_size_x / 2), uic_items_pos_y + 49 * (uic_items_size_y / 50));
	tp_items:set_layout("text_pointer_text_only");
	tp_items:add_component_text("text", "ui_text_replacements_localised_text_dlc17_text_pointer_beastmen_panel_items");
	tp_items:set_style("semitransparent_highlight");
	tp_items:set_panel_width(800);

	tp_items:set_close_button_callback(
		function()
			-- hide text pointer
			tp_items:hide();
			
			-- stop pulsing highlight of the herdstone holder
			pulse_uicomponent(uic_items, false, 5, true);
			
			-- lift fullscreen highlight
			core:hide_fullscreen_highlight();	
			
			--end the tour
			beastmen_panel_tour_lock_ui(false);
		end
	);

	cm:callback(
		function()
			tp_items:show();
		end,
		0.5
	);
end





--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- CHD Minor Occupation
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

in_chd_minor_occupation_tour = intervention:new(
	"in_chd_minor_occupation_tour",			 							-- string name
	0, 																	-- cost
	function() 															-- trigger callback
		out("#### "..scripted_chd_minor_occupation_tour.id.." ####")
		ui_scripted_tour:display_stage(scripted_chd_minor_occupation_tour, 1, in_chd_minor_occupation_tour)
	end,					
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
)

in_chd_minor_occupation_tour:add_advice_key_precondition("wh3.dlc23.camp.advice.chd.occupation_minor.001")
in_chd_minor_occupation_tour:set_wait_for_fullscreen_panel_dismissed(true)
in_chd_minor_occupation_tour:set_wait_for_battle_complete(false)
in_chd_minor_occupation_tour:set_should_lock_ui()
in_chd_minor_occupation_tour:add_trigger_condition(
	"PanelOpenedCampaign",
	function(context)
		if context.string == "settlement_captured" then
			if find_uicomponent(core:get_ui_root(), "settlement_captured", "222165943") and not find_uicomponent(core:get_ui_root(), "settlement_captured", "309401646") then
				return true
			end
		end
	end
)

scripted_chd_minor_occupation_tour = {
	id = "in_chd_minor_occupation_tour",
	advice_string = "wh3.dlc23.camp.advice.chd.occupation_minor.001",
	{
		id = "chd_minor_overview",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "settlement_captured", "222165943") end, 
			function() return find_uicomponent(core:get_ui_root(), "settlement_captured", "1899472825") end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_occupation_minor_overview",
			direction = "bottom",
			size = 350,
			length = 50
		}
	},
	{
		id = "chd_minor_outposts",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "settlement_captured", "222165943") end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_occupation_outpost",
			direction = "bottom",
			size = 350,
			length = 50
		}
	},
	{
		id = "chd_minor_factories",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "settlement_captured", "1899472825") end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_occupation_factory",
			direction = "bottom",
			size = 350,
			length = 50
		}
	},
	{
		id = "chd_minor_switch_types",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "settlement_captured", "222165943") end, 
			function() return find_uicomponent(core:get_ui_root(), "settlement_captured", "1899472825") end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_occupation_conversion",
			direction = "bottom",
			size = 350,
			length = 50
		}
	}
}



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- CHD Major Occupation
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

in_chd_major_occupation_tour = intervention:new(
	"in_chd_major_occupation_tour",			 							-- string name
	0, 																	-- cost
	function() 															-- trigger callback
		out("#### "..scripted_chd_major_occupation_tour.id.." ####")
		ui_scripted_tour:display_stage(scripted_chd_major_occupation_tour, 1, in_chd_major_occupation_tour)
	end,					
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
)

in_chd_major_occupation_tour:add_advice_key_precondition("wh3.dlc23.camp.advice.chd.occupation_major.001")
in_chd_major_occupation_tour:set_wait_for_fullscreen_panel_dismissed(true)
in_chd_major_occupation_tour:set_wait_for_battle_complete(false)
in_chd_major_occupation_tour:set_should_lock_ui()
in_chd_major_occupation_tour:add_trigger_condition(
	"PanelOpenedCampaign",
	function(context)
		if context.string == "settlement_captured" then
			if find_uicomponent(core:get_ui_root(), "settlement_captured", "309401646") then
				return true
			end
		end
	end
)

scripted_chd_major_occupation_tour = {
	id = "in_chd_major_occupation_tour",
	advice_string = "wh3.dlc23.camp.advice.chd.occupation_major.001",
	{
		id = "chd_major_overview",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "settlement_captured", "309401646") end,
			function() return find_uicomponent(core:get_ui_root(), "settlement_captured", "222165943") end,
			function() return find_uicomponent(core:get_ui_root(), "settlement_captured", "1899472825") end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_occupation_major_overview",
			direction = "bottom",
			size = 350,
			length = 50
		}
	},
	{
		id = "chd_major_tower",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "settlement_captured", "309401646") end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_occupation_factory_tower",
			direction = "bottom",
			size = 350,
			length = 50
		}
	},
	{
		id = "chd_major_purchase",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "settlement_captured", "309401646", "purchase_settlement_level") end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_occupation_factory_tower_cost",
			direction = "bottom",
			size = 350,
			length = 50
		}
	},
	{
		id = "chd_major_conversion",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "settlement_captured", "309401646") end,
			function() return find_uicomponent(core:get_ui_root(), "settlement_captured", "222165943") end,
			function() return find_uicomponent(core:get_ui_root(), "settlement_captured", "1899472825") end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_occupation_conversion",
			direction = "bottom",
			size = 350,
			length = 50
		}
	}
}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- CHD Tower of Zharr
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

in_chd_toz_tour = intervention:new(
	"in_chd_toz_tour",			 										-- string name
	0, 																	-- cost
	function() 
		cm:callback(function()
			out("#### "..scripted_chd_toz_tour.id.." ####")
			ui_scripted_tour:display_stage(scripted_chd_toz_tour, 1, in_chd_toz_tour)
		end,
		0.2)															-- trigger callback
	end,					
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
)

in_chd_toz_tour:add_advice_key_precondition("wh3.dlc23.camp.advice.chd.toz.001")
in_chd_toz_tour:set_wait_for_fullscreen_panel_dismissed(false)
in_chd_toz_tour:set_should_lock_ui()
in_chd_toz_tour:add_trigger_condition(
	"PanelOpenedCampaign",
	function(context)
		if context.string == "tower_of_zharr" then
			if find_uicomponent(core:get_ui_root(), "tower_of_zharr", "tier_listview") then
				return true
			end
		end
	end
)
		
scripted_chd_toz_tour = {
	id = "in_chd_toz_tour",
	advice_string = "wh3.dlc23.camp.advice.chd.toz.001",
	{
		id = "chd_toz_overview",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "tower_of_zharr", "CcoRitualCategoryGroupRecordtoz_tier_1") end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_toz_1",
			direction = "right",
			size = 250,
			length = 50,
			x_offset = 70
		}
	},
	{
		id = "chd_toz_seat",
		highlight = {
			function() return find_uicomponent(get_toz_ritual_parent_component(), "seat") end,
		},
		text_box = {
			text = "dlc23_text_pointer_chd_toz_2",
			direction = "right",
			size = 250,
			length = 50
		},
		highlight_size_mod = 20
	},
	{
		id = "chd_toz_seat_cost",
		highlight = {
			function() return find_uicomponent(get_toz_ritual_parent_component(), "seat") end,
		},
		text_box = {
			text = "dlc23_text_pointer_chd_toz_3",
			direction = "left",
			size = 350,
			length = 50,
			x_offset = 30,
			y_offset = 25
		},
		pulse = {
			function() return find_uicomponent(get_toz_ritual_parent_component(), "dy_influence_right") end,
			function() return find_uicomponent(get_toz_ritual_parent_component(), "influence_icon") end
		},
		highlight_size_mod = 20
	},
	{
		id = "chd_toz_districts",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "tower_of_zharr", "CcoRitualCategoryRecordDISTRICTS_SORCERY_T1") end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_toz_4",
			direction = "right",
			size = 250,
			length = 50,
			x_offset = 100
		},
		pulse = {
			function() return find_uicomponent(core:get_ui_root(), "tower_of_zharr", "CcoRitualCategoryRecordDISTRICTS_SORCERY_T1", "district_title") end
		}
	},
	{
		id = "chd_toz_district_rewards",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "tower_of_zharr", "CcoRitualCategoryRecordDISTRICTS_SORCERY_T1", "seat_effects_list") end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_toz_5",
			direction = "top",
			size = 350,
			length = 50
		}
	},
	{
		id = "chd_toz_rewards_unlocked",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "tower_of_zharr", "effects_panel") end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_toz_6",
			direction = "right",
			size = 350,
			length = 50,
			y_offset = -250
		},
		pulse = {
			function() return find_uicomponent(core:get_ui_root(), "tower_of_zharr", "effects_panel", "tabs_holder") end
		}
	},
	{
		id = "chd_toz_navigation",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "tower_of_zharr", "side_nav_bar") end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_toz_7",
			direction = "left",
			size = 350,
			length = 50
		},
		click = function() return find_uicomponent(core:get_ui_root(), "tower_of_zharr", "side_nav_bar", "CcoRitualCategoryGroupRecordtoz_tier_2") end,
		confirmation = function() return find_uicomponent(core:get_ui_root(), "tower_of_zharr", "side_nav_bar", "CcoRitualCategoryGroupRecordtoz_tier_2") end
	},
	{
		id = "chd_toz_locked_tiers",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "tower_of_zharr", "CcoRitualCategoryGroupRecordtoz_tier_2") end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_toz_8",
			direction = "right",
			size = 250,
			length = 50,
			x_offset = 100
		},
		click = function() return find_uicomponent(core:get_ui_root(), "tower_of_zharr", "side_nav_bar", "CcoRitualCategoryGroupRecordtoz_tier_1") end
	}
}

function get_toz_ritual_parent_component()
	local parent = find_uicomponent(core:get_ui_root(), "tower_of_zharr", "CcoRitualCategoryRecordDISTRICTS_SORCERY_T1", "seats_list")
	return find_child_uicomponent_by_index(parent, 1)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- CHD Province Info Industry
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

in_chd_industry_tour = intervention:new(
	"in_chd_industry_tour",
	0,
	function() 
		cm:callback(function()
			-- need to check if industry frame is visible after a small delay as there's a small animation when opening this panel where it's not visible at first.
			if find_uicomponent(core:get_ui_root(), "frame_industry"):VisibleFromRoot() then
				out("#### "..scripted_chd_industry_tour.id.." ####")
				ui_scripted_tour:display_stage(scripted_chd_industry_tour, 1, in_chd_industry_tour)
			else
				in_chd_industry_tour:cancel()
			end
		end, 0.2)
	end,					
	BOOL_INTERVENTIONS_DEBUG
)

in_chd_industry_tour:add_advice_key_precondition("wh3.dlc23.camp.advice.chd.industry.001")
in_chd_industry_tour:set_wait_for_fullscreen_panel_dismissed(false)
in_chd_industry_tour:set_wait_for_battle_complete(false)
in_chd_industry_tour:set_should_lock_ui()
in_chd_industry_tour:add_trigger_condition(
	"PanelOpenedCampaign",
	function(context)
		if context.string == "settlement_panel" then
			if find_uicomponent(core:get_ui_root(), "frame_industry") then
				return true
			end
			return false
		end
	end
)

scripted_chd_industry_tour = {
	id = "in_chd_industry_tour",
	advice_string = "wh3.dlc23.camp.advice.chd.industry.001",
	{
		id = "chd_industry_overview",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "frame_industry") end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_industry_overview",
			direction = "left", 
			size = 350,
			length = 50
		}
	},
	{
		id = "chd_industry_workload",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "frame_industry", "efficiency_ratio", "workload_tracker") end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_industry_workload",
			direction = "left",
			size = 350,
			length = 50
		}
	},
	{
		id = "chd_industry_raw_materials",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "frame_industry", "efficiency_ratio") end,
			function() return find_uicomponent(core:get_ui_root(), "frame_industry", "efficiency_output") end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_industry_raw_materials",
			direction = "left",
			size = 350,
			length = 50
		}
	},
	{
		id = "chd_industry_labour",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "frame_industry", "efficiency_ratio", "labour_tracker") end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_industry_labour",
			direction = "left",
			size = 350, 
			length = 50
		}
	},
	{
		id = "chd_industry_intake",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "frame_industry", "new_labour_holder") end,
			function() return find_uicomponent(core:get_ui_root(), "frame_industry", "new_labour_holder", "label_txt") end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_industry_new_intake",
			direction = "left", 
			size = 350,
			length = 50
		}
	},
	{
		id = "chd_industry_labour_actions",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "frame_labour") end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_industry_labour_actions",
			direction = "left",
			size = 350,
			length = 50
		}
	},
	{
		id = "chd_industry_rush_construction",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "settlement_list") end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_industry_rush_construction",
			direction = "bottom",
			size = 350,
			length = 50
		}
	}
}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- CHD Hell-Forge Armoury
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

in_chd_hellforge_armoury_tour = intervention:new(
	"in_chd_hellforge_armoury_tour",			 						-- string name
	0, 																	-- cost
	function() 
		cm:callback(function()
			out("#### "..scripted_chd_hellforge_armoury_tour.id.." ####")
			ui_scripted_tour:display_stage(scripted_chd_hellforge_armoury_tour, 1, in_chd_hellforge_armoury_tour)
		end,
		0.2)															-- trigger callback
	end,					
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
)

in_chd_hellforge_armoury_tour:add_advice_key_precondition("wh3.dlc23.camp.advice.chd.hellforge_armoury.001")
in_chd_hellforge_armoury_tour:set_wait_for_fullscreen_panel_dismissed(false)
in_chd_hellforge_armoury_tour:set_should_lock_ui()
in_chd_hellforge_armoury_tour:add_trigger_condition(
	"PanelOpenedCampaign",
	function(context)
		if context.string == "hellforge_panel_main" then
			local armoury_tab = find_uicomponent(core:get_ui_root(), "hellforge_panel_main", "tab_unit_caps")
			if armoury_tab and armoury_tab:Visible() then
				return true
			end
		end
	end
)

scripted_chd_hellforge_armoury_tour = {
	id = "in_chd_hellforge_armoury_tour",
	advice_string = "wh3.dlc23.camp.advice.chd.hellforge_armoury.001",

	{
		id = "chd_hellforge_overview",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "hellforge_panel_main", "header") end,
			function() return find_uicomponent(core:get_ui_root(), "hellforge_panel_main", "tx_category_customisation") end,
			function() return find_uicomponent(core:get_ui_root(), "hellforge_panel_main", "tx_unit_caps") end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_hellforge_armoury_1",
			direction = "top",
			size = 280,
			length = 50
		}
	},
	{
		id = "chd_hellforge_armoury",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "hellforge_panel_main", "tx_unit_caps") end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_hellforge_armoury_2",
			direction = "top",
			size = 250,
			length = 50
		}
	},
	{
		id = "chd_hellforge_shared_cap",
		highlight = {
			function() return find_uicomponent(get_hellforge_shared_unit_cap_component()) end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_hellforge_armoury_3",
			direction = "left",
			size = 300,
			length = 80
		},
		pulse = {
			function() return find_uicomponent(get_hellforge_shared_unit_cap_component(), "cap_value_holder") end
		}
	},
	{
		id = "chd_hellforge_cap_increase",
		highlight = {
			function() return find_uicomponent(get_hellforge_shared_unit_cap_component(), "increase_cap_holder") end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_hellforge_armoury_4",
			direction = "left",
			size = 300,
			length = 100
		}
	},
	{
		id = "chd_hellforge_upgrade_bar",
		highlight = {
			function() return find_uicomponent(get_hellforge_shared_unit_cap_title_component()) end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_hellforge_armoury_5",
			direction = "left",
			size = 300,
			length = 50
		}
	},
	{
		id = "chd_hellforge_manufactory_locked",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "hellforge_panel_main", "tx_category_customisation") end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_hellforge_armoury_6",
			direction = "top",
			size = 250,
			length = 50
		}
	},
}

function get_hellforge_shared_unit_cap_component()
	local parent = find_uicomponent(core:get_ui_root(), "hellforge_panel_main", "CcoRitualCategoryRecordHELLFORGE_CAPS_MELEE_INFANTRY", "unit_entries_items")
	if parent then
		for i = 1, parent:ChildCount() do
			local child = find_child_uicomponent_by_index(parent, i)
			if child ~= nil and child:Visible() then return child end
		end
	end
	return false
end

function get_hellforge_shared_unit_cap_title_component()
	local parent = find_uicomponent(core:get_ui_root(), "hellforge_panel_main", "CcoRitualCategoryRecordHELLFORGE_CAPS_MELEE_INFANTRY", "group_title", "unlock_bar_holder")
	if parent then
		for i = 1, parent:ChildCount() do
			local child = find_child_uicomponent_by_index(parent, i)
			if child ~= nil and child:Visible() then return child end
		end
	end
	return false
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- CHD Hell-Forge Manufactory
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

in_chd_hellforge_manufactory_tour = intervention:new(
	"in_chd_hellforge_manufactory_tour",			 						-- string name
	0, 																	-- cost
	function() 
		cm:callback(function()
			out("#### "..scripted_chd_hellforge_manufactory_tour.id.." ####")
			
			ui_scripted_tour:display_stage(scripted_chd_hellforge_manufactory_tour, 1, in_chd_hellforge_manufactory_tour)
		end,
		0.2)															-- trigger callback
	end,					
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
)

in_chd_hellforge_manufactory_tour:add_advice_key_precondition("wh3.dlc23.camp.advice.chd.hellforge_manufactory.001")
in_chd_hellforge_manufactory_tour:set_wait_for_fullscreen_panel_dismissed(false)
in_chd_hellforge_manufactory_tour:set_should_lock_ui()
in_chd_hellforge_manufactory_tour:add_trigger_condition(
	"ComponentLClickUp",
	function(context)
		local manufactory_tab = find_uicomponent(core:get_ui_root(), "hellforge_panel_main", "tab_categories")
		if manufactory_tab and manufactory_tab:Visible() then
			return true
		end
	end
)

scripted_chd_hellforge_manufactory_tour = {
	id = "in_chd_hellforge_manufactory_tour",
	advice_string = "wh3.dlc23.camp.advice.chd.hellforge_manufactory.001",

	{
		id = "chd_hellforge_manufactory",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "hellforge_panel_main", "tx_category_customisation") end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_hellforge_manufactory_1",
			direction = "top",
			size = 250,
			length = 50
		},
		click = function() return find_uicomponent(get_active_hellforge_manufactory_quick_move_component()) end,
		confirmation = function() return find_uicomponent(get_active_hellforge_manufactory_category_component()) end
	},
	{
		id = "chd_hellforge_categories",
		highlight = {
			function() return find_uicomponent(get_active_hellforge_manufactory_category_component(), "content_holder") end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_hellforge_manufactory_2",
			direction = "left",
			size = 250,
			length = 80,
			y_offset = -200
		},
		click = function() return is_side_panel_active() end,
		confirmation = function() return find_uicomponent(get_active_hellforge_manufactory_category_component(), "content_holder") end
	},
	{
		id = "chd_hellforge_side_panel",
		highlight = {
			function() return find_uicomponent("customisation_panel_container", "trait_list") end,
			function() return find_uicomponent("customisation_panel_container", "cost_container") end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_hellforge_manufactory_3",
			direction = "right",
			size = 250,
			length = 100,
			y_offset = -100
		}
	},
	{
		id = "chd_hellforge_category_upkeep",
		highlight = {
			function() return find_uicomponent(get_active_hellforge_manufactory_category_component(), "category_units") end,
			function() return find_uicomponent(get_active_hellforge_manufactory_category_component(), "category_upkeep") end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_hellforge_manufactory_4",
			direction = "left",
			size = 250,
			length = 80,
			x_offset = -40
		},
		pulse = {
			function() return find_uicomponent(get_active_hellforge_manufactory_category_component(), "category_upkeep", "cost_holder") end
		}
	},
}

function get_active_hellforge_manufactory_category_component()
	local parent = find_uicomponent(core:get_ui_root(), "hellforge_panel_category_tab", "category_list", "list_box")
	if parent ~= nil then
		local count = parent:ChildCount()
		for i = 1, parent:ChildCount() do
			local child = find_child_uicomponent_by_index(parent, i)
			if child ~= nil then
				if child:CurrentState() == "active" or child:CurrentState() == "selected" then
					return child
				end
			end
		end
	end
	return false
end

function get_active_hellforge_manufactory_quick_move_component()
	local parent = find_uicomponent(core:get_ui_root(), "hellforge_panel_category_tab", "button_list")
	if parent ~= nil then
		for i = 1, parent:ChildCount() do
			local child = find_child_uicomponent_by_index(parent, i)
			if child ~= nil then
				if child:CurrentState() == "active" or child:CurrentState() == "selected" then
					return child
				end
			end
		end
	end
	return false
end

function is_side_panel_active()
	local side_panel_component = find_uicomponent(core:get_ui_root(), "hellforge_panel_main", "hellforge_panel_category_tab", "category_title_container")
	if side_panel_component and side_panel_component:Visible() then
		return "skip_click"
	else
		return find_uicomponent(get_active_hellforge_manufactory_quick_move_component())
	end
end



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- CHD Labour Economy Panel
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

in_chd_labour_economy_tour = intervention:new(
	"in_chd_labour_economy_tour",			 						-- string name
	0, 																	-- cost
	function() 
		cm:callback(function()
			out("#### "..scripted_chd_labour_economy_tour.id.." ####")
			
			ui_scripted_tour:display_stage(scripted_chd_labour_economy_tour, 1, in_chd_labour_economy_tour)
		end,
		0.2)															-- trigger callback
	end,					
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
)

in_chd_labour_economy_tour:add_advice_key_precondition("wh3.dlc23.camp.advice.chd.labour_panel.001")
in_chd_labour_economy_tour:set_wait_for_fullscreen_panel_dismissed(false)
in_chd_labour_economy_tour:set_should_lock_ui()
in_chd_labour_economy_tour:add_trigger_condition(
	"ComponentLClickUp",
	function(context)
		local labour_panel = find_uicomponent(core:get_ui_root(), "labour_economy_panel")
		if labour_panel and labour_panel:Visible() then
			return true
		end
	end
)

scripted_chd_labour_economy_tour = {
	id = "in_chd_labour_economy_tour",
	advice_string = "wh3.dlc23.camp.advice.chd.labour_panel.001",

	{
		id = "chd_labour_intro",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "list_labour_provinces") end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_labour_panel_1",
			direction = "top",
			size = 350,
			length = 50
		}
	},
	{
		id = "chd_labour_intake",
		highlight = {
			function() return find_uicomponent(get_labour_economy_first_province(), "checkbox_overlay") end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_labour_panel_2",
			direction = "top",
			size = 250,
			length = 50
		}
	},
	{
		id = "chd_labour_actions",
		highlight = {
			function() return find_uicomponent(get_labour_economy_first_province(), "labour_buttonset") end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_labour_panel_3",
			direction = "top",
			size = 250,
			length = 50
		}
	},
	{
		id = "chd_labour_po",
		highlight = {
			function() return find_uicomponent(get_labour_economy_first_province(), "public_order_holder", "icon_public_order") end,
			function() return find_uicomponent(get_labour_economy_first_province(), "public_order_holder", "dy_growth") end,
			function() return find_uicomponent(get_labour_economy_first_province(), "public_order_holder", "dy_change") end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_labour_panel_4",
			direction = "top",
			size = 250,
			length = 50
		}
	},
	{
		id = "chd_labour_move",
		highlight = {
			function() return find_uicomponent(get_labour_economy_first_province(), "holder_labour_workload") end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_labour_panel_6",
			direction = "top",
			size = 250,
			length = 50
		}
	},
	{
		id = "chd_labour_buttons",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "labour_economy_panel", "holder_panel_buttons") end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_labour_panel_7",
			direction = "bottom",
			size = 250,
			length = 50
		}
	},
	{
		id = "chd_labour_output",
		highlight = {
			function() return find_uicomponent(get_labour_economy_first_province(), "dy_efficiency") end,
			function() return find_uicomponent(get_labour_economy_first_province(), "dy_raw_materials") end,
		},
		text_box = {
			text = "dlc23_text_pointer_chd_labour_panel_5",
			direction = "top",
			size = 250,
			length = 50
		}
	}
}

function get_labour_economy_first_province()
	local parent = find_uicomponent(core:get_ui_root(), "list_labour_provinces", "list_box")
	return find_child_uicomponent_by_index(parent, 1)
end

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- Common Functions
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ui_scripted_tour = {}

function ui_scripted_tour:check_components_exist(component_paths, id, intervention)
	component_paths.components = {}

	for k, component in ipairs(component_paths) do
		comp = component()
		
		if comp ~= nil and is_uicomponent(comp) == false then
			script_error("WARNING: "..id.." could not find component: "..k..", exiting tour prematurely")
			intervention:cancel()
			cm:steal_escape_key(false)
			self:toggle_shortcuts(true)
			return false
		end

		table.insert(component_paths.components, comp)
	end

	return true
end

function ui_scripted_tour:get_highlighted_size_and_position(component_list)
	-- get the overall position/size of 1 or more highlighted components in order to help try find a central anchor of them all.
	local coords = {}
	local size_and_pos = {}
	local top = 0
	local bottom = 0
	local left = 0
	local right = 0
	local width = 0
	local height = 0
	
	for k, component in ipairs(component_list) do
		-- tl = top left, br = bottom right
		local tl_x, tl_y = component:Position()
		local comp_width, comp_height = component:Dimensions()
		local br_x = tl_x + comp_width
		local br_y = tl_y + comp_height
		table.insert(coords, {tl_x = tl_x, tl_y = tl_y, br_x = br_x, br_y = br_y})
	end

	for k, coord in ipairs(coords) do
		if top == 0 or top > coord.tl_y  then
			top = coord.tl_y
		end
		if left == 0 or left > coord.tl_x  then
			left = coord.tl_x
		end
		if bottom == 0 or bottom < coord.br_y  then
			bottom = coord.br_y
		end
		if right == 0 or right < coord.br_x  then
			right = coord.br_x
		end
	end

	width = right - left
	height = bottom - top

	local pos = {x = left, y = top}
	return pos, width, height
end

function ui_scripted_tour:display_text_pointer(ui_text_replacement, direction, box_size, length, pos, width, height, x_offset, y_offset)
	x_offset = x_offset or 0
	y_offset = y_offset or 0
	local x, y

	if direction == "top"  then
		x = pos.x + (width / 2)
		y = pos.y + height
	elseif direction == "bottom"  then
		x = pos.x + (width / 2)
		y = pos.y
	elseif direction == "left"  then
		x = pos.x + width
		y = pos.y + (height / 2)
	elseif direction == "right"  then
		x = pos.x
		y = pos.y + (height / 2)
	end

	local tp_box = text_pointer:new("tp_box", direction, length, x + x_offset, y + y_offset);
	tp_box:set_layout("text_pointer_text_only");
	tp_box:add_component_text("text", "ui_text_replacements_localised_text_"..ui_text_replacement);
	tp_box:set_style("semitransparent_highlight");
	tp_box:set_panel_width(box_size);

	cm:callback(
		function()
			tp_box:show()
		end,
		0.5
	)

	return tp_box
end

function ui_scripted_tour:display_stage(tour, stage_number, intervention)
	local stage = tour[stage_number]
	local advice_level = common.get_advice_level()
	local highlight_size_mod = stage.highlight_size_mod or 0
	out("\tAdvice: "..advice_level)

	-- calling steal escape at the start of every slide seems to stop panels being closed down with escape spam accidently. Calling it once at the start of the tour doesn't seem to work.
	cm:steal_escape_key(true)
	self:toggle_shortcuts(false)

	cm:dismiss_advice()
	comp_exists = self:check_components_exist(stage.highlight, stage.id, intervention)
	
	if comp_exists then
		core:show_fullscreen_highlight_around_components(15 + highlight_size_mod, false, false, unpack(stage.highlight.components))

		self:pulse_components(stage.pulse, true)

		local pos, width, height = ui_scripted_tour:get_highlighted_size_and_position(stage.highlight.components)
		local tp_box = ui_scripted_tour:display_text_pointer(stage.text_box.text, stage.text_box.direction, stage.text_box.size, stage.text_box.length, pos, width, height, stage.text_box.x_offset, stage.text_box.y_offset)

		if #tour > stage_number then
			local next_stage = stage_number + 1
			ui_scripted_tour:advance_tour(tour, next_stage, tp_box, intervention, stage.pulse, stage.click, stage.confirmation)
		else
			ui_scripted_tour:complete_tour(tour, intervention, tp_box, stage.pulse, stage.click)
		end
	end
end

function ui_scripted_tour:advance_tour(tour, stage, text_pointer, intervention, pulse_components, click_component, confirmation_component)
	text_pointer:set_close_button_callback(function()	
		text_pointer:hide() 
		core:hide_fullscreen_highlight()
		self:pulse_components(pulse_components, false)

		if click_component then
			click_component = click_component()
			if click_component == "skip_click" then
				self:display_stage(tour, stage, intervention)
			else
				if confirmation_component then
					click_component:SimulateLClick()
					self:progress_on_confirmation_component(confirmation_component, tour, stage, intervention)
				else
					click_component:SimulateLClick()
				end
			end
		else
			self:display_stage(tour, stage, intervention)
		end
	end)
end

function ui_scripted_tour:progress_on_confirmation_component(component, tour, stage, intervention, duration_checked)
	local max_check_duration = 1 -- seconds
	local check_rate = 0.1 -- seconds
	local duration_checked = duration_checked or 0
	cm:steal_escape_key(true)
	self:toggle_shortcuts(false)

	cm:callback(
		function()
			confirmation_component = component()

			if confirmation_component ~= nil and confirmation_component:VisibleFromRoot() == true then
				core:progress_on_uicomponent_animation(
					tour.id, 
					confirmation_component, 
					function()	
						self:display_stage(tour, stage, intervention)
					end
				)
			elseif duration_checked < max_check_duration then
				duration_checked = duration_checked + check_rate
				self:progress_on_confirmation_component(component, tour, stage, intervention, duration_checked)
			else
				script_error("WARNING: attempted to click during scripted tour but confirmation component wasn't found. Ending tour.")
				core:hide_fullscreen_highlight()
				cm:dismiss_advice()
				intervention:complete()
				cm:steal_escape_key(false)
				self:toggle_shortcuts(true)
				return false
			end
		end,
		check_rate
	)
end

function ui_scripted_tour:complete_tour(tour, intervention, text_pointer, pulse_components, click_component)
	text_pointer:set_close_button_callback(function()
		self:pulse_components(pulse_components, false)
		text_pointer:hide() 
		core:hide_fullscreen_highlight()

		if click_component then
			click_component = click_component()
			click_component:SimulateLClick()
		end

		intervention:complete()
		cm:steal_escape_key(false)
		self:toggle_shortcuts(true)
		cm:show_advice(tour.advice_string, true)
	end)
end

function ui_scripted_tour:pulse_components(components_table, turn_on)
	if components_table then
		for _, component in pairs(components_table) do
			component = component()
			pulse_uicomponent(component, turn_on, 5, true)
		end
	end
end

function ui_scripted_tour:toggle_shortcuts(enable)
	-- keep this function up to date with campaign shortcuts from: working_data/text/default_keys.xml
	common.enable_shortcut("step_l", enable)
	common.enable_shortcut("step_r", enable)
	common.enable_shortcut("step_fwd", enable)
	common.enable_shortcut("step_bck", enable)
	common.enable_shortcut("cam_up", enable)
	common.enable_shortcut("cam_down", enable)
	common.enable_shortcut("rot_l", enable)
	common.enable_shortcut("rot_r", enable)
	common.enable_shortcut("rot_u", enable)
	common.enable_shortcut("rot_d", enable)
	common.enable_shortcut("default_camera_rotation", enable)
	common.enable_shortcut("show_gov", enable)
	common.enable_shortcut("end_turn", enable)
	common.enable_shortcut("end_turn_skip_warnings", enable)
	common.enable_shortcut("end_turn_notification_zoom", enable)
	common.enable_shortcut("show_campaign_overlay_options", enable)
	common.enable_shortcut("zoom_to_strategic", enable)
	common.enable_shortcut("toggle_move_speed", enable)
	common.enable_shortcut("toggle_show_cpu_moves", enable)
	common.enable_shortcut("quick_save", enable)
	common.enable_shortcut("quick_load", enable)
	common.enable_shortcut("select_next", enable)
	common.enable_shortcut("select_prev", enable)
	common.enable_shortcut("show_technologies", enable)
	common.enable_shortcut("show_diplomacy", enable)
	common.enable_shortcut("show_book_of_grudges", enable)
	common.enable_shortcut("show_rituals_panel", enable)
	common.enable_shortcut("show_offices_panel", enable)
	common.enable_shortcut("show_slaves_panel", enable)
	common.enable_shortcut("show_geomantic_web", enable)
	common.enable_shortcut("show_intrigue_panel", enable)
	common.enable_shortcut("show_skaven_corruption", enable)
	common.enable_shortcut("show_spawn_special_agent", enable)
	common.enable_shortcut("show_mortuary_cults", enable)
	common.enable_shortcut("show_treasure_hunts", enable)
	common.enable_shortcut("show_bloodlines", enable)
	common.enable_shortcut("show_clan", enable)
	common.enable_shortcut("show_finance", enable)
	common.enable_shortcut("show_objectives", enable)
	common.enable_shortcut("show_overview", enable)
	common.enable_shortcut("show_building_browser", enable)
	common.enable_shortcut("show_recruitment_units", enable)
	common.enable_shortcut("show_recruitment_agents", enable)
	common.enable_shortcut("button_group_management_1", enable)
	common.enable_shortcut("button_group_management_2", enable)
	common.enable_shortcut("button_group_management_3", enable)
	common.enable_shortcut("button_group_management_4", enable)
	common.enable_shortcut("button_group_management_5", enable)
	common.enable_shortcut("button_group_management_6", enable)
	common.enable_shortcut("show_garrison", enable)
	common.enable_shortcut("home_zoom", enable)
	common.enable_shortcut("current_selection_order_cancel", enable)
	common.enable_shortcut("toggle_labels", enable)
	common.enable_shortcut("current_selection_disband", enable)
	common.enable_shortcut("auto_merge_units", enable)
end