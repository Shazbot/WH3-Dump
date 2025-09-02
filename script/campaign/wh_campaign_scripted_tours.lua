

enable_scripted_tours = not (core:is_tweaker_set("DISABLE_FULL_SCRIPTED_TOURS") or core:is_tweaker_set("DISABLE_PRELUDE_CAMPAIGN_SCRIPTS"));
-- enable_scripted_tours = false;


function start_scripted_tours()
	if enable_scripted_tours then
		out("#### start_scripted_tours() ####");
		character_skill_point_tour:start();
		in_settlement_sieged_tour:start();

		-- cultures

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
		
		if cm:are_any_factions_human(nil, "wh3_main_nur_nurgle") then
			in_nur_plagues_tour:start()
		end

		if cm:are_any_factions_human(nil, "wh_main_dwf_dwarfs") then
			in_dwf_book_of_grudges:start()
		end

		if cm:are_any_factions_human(nil, "wh3_main_kho_khorne") then
			in_kho_skull_throne_tour:start()
		end

		if cm:are_any_factions_human(nil, "wh3_main_ogr_ogre_kingdoms") then
			in_ogr_meat_transfer_tour:start()
			in_ogr_camps_tour:start()
		end


		-- factions

		--Starting Chieftains Scripted tour in here instead of early_game.lua so it is used in both campaigns
		local tamurkhan_interface = cm:get_faction("wh3_dlc25_nur_tamurkhan")
		if tamurkhan_interface and tamurkhan_interface:is_human() then
			in_nur_tamurkhans_chieftains_tour:start()
		end

		--Starting Malakai's Adventures Scripted tour in here instead of early_game.lua so it is used in both campaigns
		local malakai_interface = cm:get_faction("wh3_dlc25_dwf_malakai");
		if malakai_interface and malakai_interface:is_human() then
			in_dwf_malakai_adventures_unlocked_tour:start();
			in_dwf_malakai_adventures_started_adventure:start();
		end

		local elspeth_interface = cm:get_faction("wh_main_emp_wissenland");
		if elspeth_interface and elspeth_interface:is_human() then
			in_emp_gunnery_school_tour:start();
		end

		local balthasar_interface = cm:get_faction("wh2_dlc13_emp_golden_order");
		if balthasar_interface and balthasar_interface:is_human() then
			in_emp_college_of_magic_tour:start();
		end

		local karl_franz_interface = cm:get_faction("wh_main_emp_empire");
		if karl_franz_interface and karl_franz_interface:is_human() then
			in_emp_electoral_machinations_tour:start();
		end

		local skulltaker_interface = cm:get_faction("wh3_dlc26_kho_skulltaker");
		if skulltaker_interface and skulltaker_interface:is_human() then
			in_kho_cloak_of_skulls_tour:start();
			in_kho_cloak_of_skulls_teleport_tour:start();
		end

		local arbaal_interface = cm:get_faction("wh3_dlc26_kho_arbaal");
		if arbaal_interface and arbaal_interface:is_human() then
			in_kho_wrath_of_khorne_tour:start();
		end

		local greasus_interface = cm:get_faction("wh3_main_ogr_goldtooth");
		if greasus_interface and greasus_interface:is_human() then
			in_ogr_tyrants_demands_tour:start();
		end

		local golgfag_interface = cm:get_faction("wh3_dlc26_ogr_golgfag")
		if golgfag_interface and golgfag_interface:is_human() then
			in_ogr_contracts_tour:start()
		end

		local gorbad_interface = cm:get_faction("wh3_dlc26_grn_gorbad_ironclaw")
		if gorbad_interface and gorbad_interface:is_human() then
			in_grn_da_plan_tour:start()
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
	
	if 	character and 
		advice_level == 2 and 
		(character_skill_point_tour.is_general or not character:is_embedded_in_military_force()) and 
		not character:is_governor() and
		not character_skill_point_tour.has_fixed_camp and not character:character_subtype("wh3_main_dae_daemon_prince") and 
		character_skill_point_tour.military_force then
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
	
	-- disable pinned missions buttons from opening the objectives panel
	local uic_pinned_mission_list = find_uicomponent(core:get_ui_root(), "mission_list");
	
	if uic_pinned_mission_list then
		for i = 0, uic_pinned_mission_list:ChildCount() - 1 do
			local uic_pinned_mission = UIComponent(uic_pinned_mission_list:Find(i));
			local uic_button = find_uicomponent(uic_pinned_mission, "header_frame", "flyer_holder", "button_show_objectives");
			if uic_button then
				uic_button:SetDisabled(value);
			end;
		end;
	end;
	
	-- disable character movement
	if value then
		cm:disable_movement_for_character(cm:char_lookup_str(character_skill_point_tour.char_cqi));
	else
		cm:enable_movement_for_character(cm:char_lookup_str(character_skill_point_tour.char_cqi));
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
	
    local character_stats = find_uicomponent(core:get_ui_root(), "character_details_panel", "character_context_parent", "tab_panels", "stats_effects_holder", "unit_information_listview", "list_clip", "list_box", "row_header_stats")
	if character_stats:CurrentState() == "selected" then 
		character_stats:SimulateLClick();
	end 

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
	local already_selected_skill = false;

	for i = 1, #uic_table do
		-- For each component name, find the corresponding component 
		local component = find_uicomponent(uic_character_details_panel, uic_table[i]);
		local card = UIComponent(component:Find("card"));
		
		-- Check if it is in the available state
		if card ~= nil then
			if card:CurrentState() == "available" then
				pulse_uicomponent(component, true, 3, true);
				table.insert(available_skills_cards, card);
			elseif card:CurrentState() == "maxed" or card:CurrentState() == "maxed_hover" then
				already_selected_skill = true;
				break;
			end
		end
	end;
	
	-- if there are no available skill points, then complete immediately
	if #available_skills_cards == 0 or already_selected_skill then
		skill_point_task_complete();
		return;
	end;
	
	cm:set_objective("wh2.camp.spend_skill_point.001");
	
	local skill_point_applied = false;

	core:add_listener(
		"skill_point_task",
		"ComponentLClickUp", 
		function(context)
			if skill_point_applied then
				return false;
			end
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
			skill_point_applied = true;
		end,
		false
	);

	core:add_listener(
		"skill_entry_state_change",
		"ContextTriggerEvent",
		function(context)
			return skill_point_applied == false and context.string == "skill_point_used";
		end,
		function(context)
			skill_point_task_complete(true);
			skill_point_applied = true;
		end,
		true
	)
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
	
	local character_stats = find_uicomponent(core:get_ui_root(), "character_details_panel", "character_context_parent", "tab_panels", "stats_effects_holder", "unit_information_listview", "list_clip", "list_box", "row_header_stats")
    if character_stats:CurrentState() ~= "selected" then
        character_stats:SimulateLClick();
    end

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
		ui_scripted_tour:construct_tour(scripted_chd_minor_occupation_tour, in_chd_minor_occupation_tour)
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
	localised_name = "ui_text_replacements_localised_text_hp_campaign_title_chd_economy",
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
		ui_scripted_tour:construct_tour(scripted_chd_major_occupation_tour, in_chd_major_occupation_tour)
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
	localised_name = "ui_text_replacements_localised_text_hp_campaign_title_chd_economy",
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
			ui_scripted_tour:construct_tour(scripted_chd_toz_tour, in_chd_toz_tour)
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
	localised_name = "ui_text_replacements_localised_text_hp_campaign_title_tower_of_zharr",
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
		},
		click_on_navigate = function() return find_uicomponent(core:get_ui_root(), "tower_of_zharr", "side_nav_bar", "CcoRitualCategoryGroupRecordtoz_tier_1") end
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
		click_on_navigate = function() return find_uicomponent(core:get_ui_root(), "tower_of_zharr", "side_nav_bar", "CcoRitualCategoryGroupRecordtoz_tier_2") end,
		navigation_delay = 0.5
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
		navigation_delay = 0.5
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
			if find_uicomponent(core:get_ui_root(), "hud_campaign", "info_panel_holder", "frame_industry"):VisibleFromRoot() then
				out("#### "..scripted_chd_industry_tour.id.." ####")
				ui_scripted_tour:construct_tour(scripted_chd_industry_tour, in_chd_industry_tour)
			else
				in_chd_industry_tour:cancel()
			end
		end, 0.5)
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
			if find_uicomponent(core:get_ui_root(), "hud_campaign", "info_panel_holder", "frame_industry") then
				return true
			end
			return false
		end
	end
)

scripted_chd_industry_tour = {
	id = "in_chd_industry_tour",
	localised_name = "ui_text_replacements_localised_text_hp_campaign_title_chd_economy",
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
			ui_scripted_tour:construct_tour(scripted_chd_hellforge_armoury_tour, in_chd_hellforge_armoury_tour)
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
			local chaos_dwarfs_forge_back_button = find_uicomponent("hellforge_panel_main", "button_close_holder", "button_ok");
			local armoury_tab = find_uicomponent(core:get_ui_root(), "hellforge_panel_main", "tab_unit_caps")
			if armoury_tab and armoury_tab:Visible() then
				chaos_dwarfs_forge_back_button:SetState("inactive")	
				return true
			end
		end
	end
)

scripted_chd_hellforge_armoury_tour = {
	id = "in_chd_hellforge_armoury_tour",
	localised_name = "ui_text_replacements_localised_text_hp_campaign_title_hellforge",
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
			function() return find_uicomponent(ui_scripted_tour:find_valid_child_component(find_uicomponent(core:get_ui_root(), "hellforge_panel_main", "CcoRitualCategoryRecordHELLFORGE_CAPS_MELEE_INFANTRY", "unit_entries_items"))) end
		},
		text_box = {
			text = "dlc23_text_pointer_chd_hellforge_armoury_3",
			direction = "left",
			size = 300,
			length = 80
		},
		pulse = {
			function() return find_uicomponent(ui_scripted_tour:find_valid_child_component(find_uicomponent(core:get_ui_root(), "hellforge_panel_main", "CcoRitualCategoryRecordHELLFORGE_CAPS_MELEE_INFANTRY", "unit_entries_items")), "cap_value_holder") end
		}
	},
	{
		id = "chd_hellforge_cap_increase",
		highlight = {
			function() return find_uicomponent(ui_scripted_tour:find_valid_child_component(find_uicomponent(core:get_ui_root(), "hellforge_panel_main", "CcoRitualCategoryRecordHELLFORGE_CAPS_MELEE_INFANTRY", "unit_entries_items")), "increase_cap_holder") end
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
			function() return find_uicomponent(ui_scripted_tour:find_valid_child_component(find_uicomponent(core:get_ui_root(), "hellforge_panel_main", "CcoRitualCategoryRecordHELLFORGE_CAPS_MELEE_INFANTRY", "group_title", "unlock_bar_holder"))) end
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
			
			ui_scripted_tour:construct_tour(scripted_chd_hellforge_manufactory_tour, in_chd_hellforge_manufactory_tour)
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
	localised_name = "ui_text_replacements_localised_text_hp_campaign_title_hellforge",
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
		click_on_navigate = function() return find_uicomponent(get_active_hellforge_manufactory_quick_move_component()) end
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
		click_on_navigate = function() if is_hellforge_side_panel_active() then return find_uicomponent(get_active_hellforge_manufactory_quick_move_component()) end end,
		navigation_delay = 0.5
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
	}
}

function get_active_hellforge_manufactory_category_component()
	local parent = find_uicomponent(core:get_ui_root(), "hellforge_panel_category_tab", "category_list", "list_box")
	if parent then
		local count = parent:ChildCount()
		for i = 0, parent:ChildCount() - 1 do
			local child = find_child_uicomponent_by_index(parent, i)
			if child and child:Visible() and (child:CurrentState() == "active" or child:CurrentState() == "selected") then
				return child
			end
		end
	end
	return false
end

function get_active_hellforge_manufactory_quick_move_component()
	local parent = find_uicomponent(core:get_ui_root(), "hellforge_panel_category_tab", "button_list")
	if parent then
		for i = 0, parent:ChildCount() - 1 do
			local child = find_child_uicomponent_by_index(parent, i)
			if child and child:Visible() and (child:CurrentState() == "active" or child:CurrentState() == "selected") then
				return child
			end
		end
	end
	return false
end

function is_hellforge_side_panel_active()
	local side_panel_component = find_uicomponent(core:get_ui_root(), "hellforge_panel_main", "hellforge_panel_category_tab", "category_title_container")
	return not (side_panel_component and side_panel_component:Visible())
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
			
			ui_scripted_tour:construct_tour(scripted_chd_labour_economy_tour, in_chd_labour_economy_tour)
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
	localised_name = "ui_text_replacements_localised_text_hp_campaign_title_labour",
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
---- NUR Plagues Panel
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

in_nur_plagues_tour = intervention:new(
	"in_nur_plagues_tour",			 						-- string name
	0, 														-- cost
	function() 
		cm:callback(function()
			out("#### "..scripted_nur_plagues_tour.id.." ####")
			
			ui_scripted_tour:construct_tour(scripted_nur_plagues_tour, in_nur_plagues_tour)
		end,
		0.2)												-- trigger callback
	end,					
	BOOL_INTERVENTIONS_DEBUG	 							-- show debug output
)

in_nur_plagues_tour:add_advice_key_precondition("wh3.dlc25.camp.advice.nur.plagues_panel.001")
in_nur_plagues_tour:set_wait_for_fullscreen_panel_dismissed(false)
in_nur_plagues_tour:set_should_lock_ui()
in_nur_plagues_tour:add_trigger_condition(
	"ComponentLClickUp",
	function(context)
		local plagues_panel = find_uicomponent(core:get_ui_root(), "dlc25_nurgle_plagues")
		if plagues_panel and plagues_panel:Visible() then
			return true
		end
	end
)

scripted_nur_plagues_tour = {
	id = "in_nur_plagues_tour",
	localised_name = "ui_text_replacements_localised_text_hp_campaign_title_plagues",
	advice_string = "wh3.dlc25.camp.advice.nur.plagues_panel.001",

	{
		id = "nur_plagues_intro",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "tab_plague_builder") end
		},
		text_box = {
			text = "dlc25_text_pointer_nur_plagues_panel_1",
			direction = "right",
			size = 350,
			length = 50
		}
	},
	{
		id = "nur_plagues_start",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "tab_plague_builder") end
		},
		text_box = {
			text = "dlc25_text_pointer_nur_plagues_panel_2",
			direction = "right",
			size = 350,
			length = 50
		},
		pulse = {
			function() return find_uicomponent(core:get_ui_root(), "slot_parent", "CcoPlagueComponentUiDataRecord10", "plague_ingredient") end
		},
	},
	{
		id = "nur_plagues_adjacency",
		highlight = {
			function() 
				local symptom = find_uicomponent(core:get_ui_root(), "slot_parent", "CcoPlagueComponentUiDataRecord10", "slot_item")
				symptom:SimulateLClick()
			end,
			function() return find_uicomponent(core:get_ui_root(), "tab_plague_builder") end
		},
		text_box = {
			text = "dlc25_text_pointer_nur_plagues_panel_3",
			direction = "right",
			size = 350,
			length = 50
		}
	},
	{
		id = "nur_plagues_blessed",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "tab_plague_builder") end
		},
		text_box = {
			text = "dlc25_text_pointer_nur_plagues_panel_4",
			direction = "right",
			size = 350,
			length = 50
		},
		pulse = {
			function() return find_uicomponent(core:get_ui_root(), "slot_parent", "CcoPlagueComponentUiDataRecord6", "plague_ingredient") end
		},
	},
	{
		id = "nur_plagues_effects",
		highlight = {
			function() 
				local symptom = find_uicomponent(core:get_ui_root(), "slot_parent", "CcoPlagueComponentUiDataRecord6", "slot_item")
				symptom:SimulateLClick()
			end,
			function() return find_uicomponent(core:get_ui_root(), "list_plague_options") end,
			function() return find_uicomponent(core:get_ui_root(), "holder_plague_effects") end
		},
		text_box = {
			text = "dlc25_text_pointer_nur_plagues_panel_5",
			direction = "left",
			size = 350,
			length = 50
		}
	},
	{
		id = "nur_plagues_factors",
		highlight = {
			function() 
				local symptom = find_uicomponent(core:get_ui_root(), "slot_parent", "CcoPlagueComponentUiDataRecord12", "slot_item")
				symptom:SimulateLClick()
			end,
			function() return find_uicomponent(core:get_ui_root(), "holder_mutations") end
		},
		text_box = {
			text = "dlc25_text_pointer_nur_plagues_panel_6",
			direction = "left",
			size = 350,
			length = 50
		}
	},
	{
		id = "nur_plagues_factors_immunity",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "holder_mutations") end
		},
		text_box = {
			text = "dlc25_text_pointer_nur_plagues_panel_7",
			direction = "left",
			size = 350,
			length = 50
		},
		pulse = {
			function() return find_uicomponent(core:get_ui_root(), "mutations_list", "CcoPlagueMutationUiDataRecordimmunity") end
		},
	},
	{
		id = "nur_plagues_targetting",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "holder_target_action") end,
			function() return find_uicomponent(core:get_ui_root(), "holder_helper_text") end,
		},
		text_box = {
			text = "dlc25_text_pointer_nur_plagues_panel_8",
			direction = "left",
			size = 350,
			length = 50
		}
	},
	{
		id = "nur_plagues_infecting",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "holder_buttons") end,
			function() return find_uicomponent(core:get_ui_root(), "holder_total_cost") end,
		},
		text_box = {
			text = "dlc25_text_pointer_nur_plagues_panel_9",
			direction = "bottom",
			size = 500,
			length = 50
		}
	},
	{
		id = "nur_plagues_randomisation",
		highlight = {
			function() 
				local symptom = find_uicomponent(core:get_ui_root(), "slot_parent", "CcoPlagueComponentUiDataRecord10", "slot_item")
				symptom:SimulateLClick()
			end,
			function() return find_uicomponent(core:get_ui_root(), "instability_holder", "holder_description") end
		},
		text_box = {
			text = "dlc25_text_pointer_nur_plagues_panel_10",
			direction = "top",
			size = 350,
			length = 50
		}
	},
	{
		id = "nur_plagues_new_starts",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "tab_plague_builder") end
		},
		text_box = {
			text = "dlc25_text_pointer_nur_plagues_panel_11",
			direction = "right",
			size = 350,
			length = 50
		}
	}
}
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- NUR TAMURKHAN'S CHIEFTAINS PANEL
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

in_nur_tamurkhans_chieftains_tour = intervention:new(
	"in_nur_tamurkhans_chieftains_tour",			 				-- string name
	0, 																	-- cost
	function() 
		cm:callback(function()
			out("#### "..scripted_tamurkhans_chieftains_tour.id.." ####")
			ui_scripted_tour:construct_tour(scripted_tamurkhans_chieftains_tour, in_nur_tamurkhans_chieftains_tour)
		end,
		0.2)															-- trigger callback
	end,					
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
)

in_nur_tamurkhans_chieftains_tour:add_advice_key_precondition("wh3.dlc25.camp.advice.nur.tamurkhan_chieftains.001")
in_nur_tamurkhans_chieftains_tour:set_wait_for_fullscreen_panel_dismissed(false)
in_nur_tamurkhans_chieftains_tour:set_should_lock_ui()
in_nur_tamurkhans_chieftains_tour:add_trigger_condition(
	"PanelOpenedCampaign",
	function(context)
		if context.string == "dlc25_tamurkhan_chieftains" then
			local feature_tab = find_uicomponent(core:get_ui_root(), "dlc25_tamurkhan_chieftains", "content_clipper")
			if feature_tab and feature_tab:Visible() then
				return true
			end
		end
	end
)

scripted_tamurkhans_chieftains_tour = {
	id = "in_nur_tamurkhans_chieftains_tour",
	localised_name = "ui_text_replacements_localised_text_hp_campaign_title_chieftains",
	advice_string = "wh3.dlc25.camp.advice.nur.tamurkhan_chieftains.001",

	{
		id = "tamurkhans_chieftains_chieftain_tabs",
		highlight = {
			function() return find_uicomponent(ui_scripted_tour:find_valid_child_component(find_uicomponent(core:get_ui_root(), "dlc25_tamurkhan_chieftains", "panel_chieftain_stats"), "holder_content"), "list_box") end
		},
		text_box = {
			text = "wh3_dlc25_text_pointer_nur_tamurkhans_chieftains_1",
			direction = "top",
			size = 250,
			length = 50
		},
	},
	{
		id = "tamurkhans_chieftains_recruit",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_tamurkhan_chieftains", "progression_list", "button_unlock") end
		},
		text_box = {
			text = "wh3_dlc25_text_pointer_nur_tamurkhans_chieftains_2",
			direction = "bottom",
			size = 250,
			length = 50
		},
	},
	{
		id = "tamurkhans_chieftains_portrait",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_tamurkhan_chieftains", "character_holder") end
		},
		text_box = {
			text = "wh3_dlc25_text_pointer_nur_tamurkhans_chieftains_3",
			direction = "left",
			size = 250,
			length = 50
		},
	},
	{
		id = "tamurkhans_chieftains_fealty",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_tamurkhan_chieftains", "content") end,
		},
		text_box = {
			text = "wh3_dlc25_text_pointer_nur_tamurkhans_chieftains_4",
			direction = "bottom",
			size = 250,
			length = 50
		},
	},
	{
		id = "tamurkhans_chieftains_units",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_tamurkhan_chieftains", "chieftain_units") end
		},
		text_box = {
			text = "wh3_dlc25_text_pointer_nur_tamurkhans_chieftains_5",
			direction = "top",
			size = 250,
			length = 50
		}
	},
	{
		id = "tamurkhans_chieftains_abilities",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_tamurkhan_chieftains", "holder_special_abilities") end
		},
		text_box = {
			text = "wh3_dlc25_text_pointer_nur_tamurkhans_chieftains_6",
			direction = "right",
			size = 250,
			length = 50
		}
	},
	{
		id = "tamurkhans_chieftains_unlock",
		highlight = {
			function() return find_uicomponent(ui_scripted_tour:find_valid_child_component(find_uicomponent(core:get_ui_root(), "dlc25_tamurkhan_chieftains", "panel_chieftain_stats"), "holder_content"), "list_box") end
		},
		text_box = {
			text = "wh3_dlc25_text_pointer_nur_tamurkhans_chieftains_7",
			direction = "top",
			size = 250,
			length = 50
		},
	},
	{
		id = "tamurkhans_chieftains_devote",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_tamurkhan_chieftains", "CcoEffectBundlewh3_dlc25_chieftain_deference_kazyk_tier_4_0") end,
			function() return find_uicomponent(core:get_ui_root(), "dlc25_tamurkhan_chieftains", "CcoEffectBundlewh3_dlc25_chieftain_deference_kazyk_tier_4_0", "deference_icon") end
		},
		text_box = {
			text = "wh3_dlc25_text_pointer_nur_tamurkhans_chieftains_8",
			direction = "right",
			size = 250,
			length = 50
		},
	},
}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- DWF Malakai's Adventures Panel Unlocked
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

in_dwf_malakai_adventures_unlocked_tour = intervention:new(
	"in_dwf_malakai_adventures_unlocked_tour",			 				-- string name
	0, 																	-- cost
	function() 
		cm:callback(function()
			out("#### "..scripted_dwf_malakai_adventures_unlocked_tour.id.." ####")
			ui_scripted_tour:construct_tour(scripted_dwf_malakai_adventures_unlocked_tour, in_dwf_malakai_adventures_unlocked_tour)
		end,
		0.2)															-- trigger callback
	end,					
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
)

in_dwf_malakai_adventures_unlocked_tour:add_advice_key_precondition("wh3.dlc25.camp.advice.dwf.malakai_adventures.001")
in_dwf_malakai_adventures_unlocked_tour:set_wait_for_fullscreen_panel_dismissed(false)
in_dwf_malakai_adventures_unlocked_tour:set_should_lock_ui()
in_dwf_malakai_adventures_unlocked_tour:add_trigger_condition(
	"PanelOpenedCampaign",
	function(context)
		if context.string == "dlc25_malakai_oaths" then
			local feature_tab = find_uicomponent(core:get_ui_root(), "dlc25_malakai_oaths", "list_mission_tabs")
			if feature_tab and feature_tab:Visible() then
				return true
			end
		end
	end
)

scripted_dwf_malakai_adventures_unlocked_tour = {
	id = "in_dwf_malakai_adventures_unlocked_tour",
	localised_name = "ui_text_replacements_localised_text_hp_campaign_title_malakais_adventures",
	advice_string = "wh3.dlc25.camp.advice.dwf.malakai_adventures.001",

	{
		id = "malakai_adventures_adventure_tabs",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_malakai_oaths", "list_mission_tabs") end
		},
		text_box = {
			text = "dlc25_text_pointer_dwf_malakai_adventures_opened_1",
			direction = "left",
			size = 400,
			length = 80
		}
	},
	{
		id = "malakai_adventures_mission_buttons",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_malakai_oaths", "holder_part_tabs") end
		},
		text_box = {
			text = "dlc25_text_pointer_dwf_malakai_adventures_opened_2",
			direction = "top",
			size = 500,
			length = 80
		}
	},
	{
		id = "malakai_adventures_main_description",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_malakai_oaths", "dy_adventure_description") end,
			function() return find_uicomponent(core:get_ui_root(), "dlc25_malakai_oaths", "dy_bullet_point_text") end
		},
		text_box = {
			text = "dlc25_text_pointer_dwf_malakai_adventures_opened_3",
			direction = "top",
			size = 400,
			length = 80
		}
	},
	{
		id = "malakai_adventures_battle_information",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_malakai_oaths", "holder_left_section") end
		},
		text_box = {
			text = "dlc25_text_pointer_dwf_malakai_adventures_opened_4",
			direction = "left",
			size = 400,
			length = 80
		}
	},
	{
		id = "malakai_adventures_battle_information_2",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_malakai_oaths", "holder_right_section") end
		},
		text_box = {
			text = "dlc25_text_pointer_dwf_malakai_adventures_opened_5",
			direction = "right",
			size = 400,
			length = 80
		}
	},
	{
		id = "malakai_adventures_start_adventure",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_malakai_oaths", "holder_activate_ritual", "header_adventure_start") end,
			function() return find_uicomponent(core:get_ui_root(), "dlc25_malakai_oaths", "holder_activate_ritual", "txt_activate") end,
			function() return find_uicomponent(core:get_ui_root(), "dlc25_malakai_oaths", "holder_activate_ritual", "unit_list") end,
			function() return find_uicomponent(core:get_ui_root(), "dlc25_malakai_oaths", "button_activate") end
		},
		text_box = {
			text = "dlc25_text_pointer_dwf_malakai_adventures_opened_6",
			direction = "bottom",
			size = 500,
			length = 80
		},
		pulse = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_malakai_oaths", "button_activate") end
		}
	}
}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- DWF Malakai's Adventures Started Adventure
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

in_dwf_malakai_adventures_started_adventure = intervention:new(
	"in_dwf_malakai_adventures_started_adventure",			 			-- string name
	0, 																	-- cost
	function() 
		cm:callback(function()
			out("#### "..scripted_dwf_malakai_adventures_started_adventure.id.." ####")
			ui_scripted_tour:construct_tour(scripted_dwf_malakai_adventures_started_adventure, in_dwf_malakai_adventures_started_adventure)
		end,
		0.2)															-- trigger callback
	end,					
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
)

in_dwf_malakai_adventures_started_adventure:add_advice_key_precondition("wh3.dlc25.camp.advice.dwf.malakai_adventures.002")
in_dwf_malakai_adventures_started_adventure:set_wait_for_fullscreen_panel_dismissed(false)
in_dwf_malakai_adventures_started_adventure:set_should_lock_ui()
in_dwf_malakai_adventures_started_adventure:add_trigger_condition(
	"ComponentLClickUp",
	function(context)
		local feature_tab = find_uicomponent(core:get_ui_root(), "dlc25_malakai_oaths", "list_mission_tabs")
		if feature_tab and feature_tab:Visible() and context.string == "button_activate" then
			return true
		end
	end
)

scripted_dwf_malakai_adventures_started_adventure = {
	localised_name = "ui_text_replacements_localised_text_hp_campaign_title_malakais_adventures",
	id = "in_dwf_malakai_adventures_started_adventure",
	advice_string = "wh3.dlc25.camp.advice.dwf.malakai_adventures.002",

	{
		id = "malakai_adventures_missions",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_malakai_oaths", "holder_part_tabs") end
		},
		text_box = {
			text = "dlc25_text_pointer_dwf_malakai_adventures_started_1",
			direction = "top",
			size = 400,
			length = 80
		},
		pulse = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_malakai_oaths", "button_activate") end
		}
	},
	{
		id = "malakai_adventures_mission_info",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_malakai_oaths", "holder_middle_section", "tab_objective_holder") end
		},
		text_box = {
			text = "dlc25_text_pointer_dwf_malakai_adventures_started_2",
			direction = "right",
			size = 300,
			length = 80
		}
	},
	{
		id = "malakai_adventures_final_battle",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_malakai_oaths", "holder_middle_section", "holder_progrssion") end
		},
		text_box = {
			text = "dlc25_text_pointer_dwf_malakai_adventures_started_3",
			direction = "top",
			size = 400,
			length = 80
		},
		pulse = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_malakai_oaths", "holder_middle_section", "list_part_tabs") end
		}
	},
	{
		id = "malakai_adventures_top_bar_info",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dwf_malakai_adventures", "holder_frame") end
		},
		text_box = {
			text = "dlc25_text_pointer_dwf_malakai_adventures_started_4",
			direction = "top",
			size = 400,
			length = 80
		},
		pulse = {
			function() return find_uicomponent(core:get_ui_root(), "dwf_malakai_adventures", "mission_list_left") end,
			function() return find_uicomponent(core:get_ui_root(), "dwf_malakai_adventures", "mission_list_right") end
		}
	},
	{
		id = "malakai_adventures_pin_button",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_malakai_oaths", "holder_middle_section", "holder_switch_ritual") end
		},
		text_box = {
			text = "dlc25_text_pointer_dwf_malakai_adventures_started_5",
			direction = "top",
			size = 500,
			length = 80
		},
		pulse = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_malakai_oaths", "holder_middle_section", "holder_switch_ritual", "round_small_button_toggle") end
		}
	}
}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- DWF Book of Grudges
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

in_dwf_book_of_grudges = intervention:new(
	"in_dwf_book_of_grudges",			 			-- string name
	0, 																	-- cost
	function() 
		cm:callback(function()
			out("#### "..scripted_dwf_book_of_grudges.id.." ####")
			ui_scripted_tour:construct_tour(scripted_dwf_book_of_grudges, in_dwf_book_of_grudges)
		end,
		0.2)															-- trigger callback
	end,					
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
)

in_dwf_book_of_grudges:add_advice_key_precondition("wh3.dlc25.camp.advice.dwf.book_of_grudges.001")
in_dwf_book_of_grudges:set_wait_for_fullscreen_panel_dismissed(false)
in_dwf_book_of_grudges:set_should_lock_ui()
in_dwf_book_of_grudges:add_trigger_condition(
	"PanelOpenedCampaign",
	function(context)
		if context.string == "dlc25_bog_main" then
			local feature_tab = find_uicomponent(core:get_ui_root(), "dlc25_bog_main", "legendary_grudges_tab")
			if feature_tab and feature_tab:Visible() then
				return true
			end
		end
	end
)

scripted_dwf_book_of_grudges = {
	id = "in_dwf_book_of_grudges",
	localised_name = "ui_text_replacements_localised_text_hp_campaign_title_grudges",
	advice_string = "wh3.dlc25.camp.advice.dwf.book_of_grudges.001",
	reposition_controls = function() return find_uicomponent(core:get_ui_root(), "dlc25_bog_main", "header_frame") end,

	{
		id = "BoG_1",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_bog_main", "tab_list", "unit_pack_tab") end,
			function() return find_uicomponent(core:get_ui_root(), "dlc25_bog_main", "tab_list", "confederation_tab") end,
			function() return find_uicomponent(core:get_ui_root(), "dlc25_bog_main", "tab_list", "legendary_grudges_tab") end
		},
		text_box = {
			text = "dlc25_text_pointer_dwf_book_of_grudges_1",
			direction = "left",
			size = 400,
			length = 120
		}
	},
	{
		id = "BoG_2",
		highlight = {
			function() return ui_scripted_tour:find_valid_child_component(find_uicomponent(core:get_ui_root(), "dlc25_bog_main", "tab_legendary_grudges", "misison_list")) end,
		},
		text_box = {
			text = "dlc25_text_pointer_dwf_book_of_grudges_2",
			direction = "left",
			size = 400,
			length = 80
		},
		click_on_navigate = function() return find_uicomponent(core:get_ui_root(), "dlc25_bog_main", "legendary_grudges_tab") end
	},
	{
		id = "BoG_3",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_bog_main", "page cycle") end,
			function() return find_uicomponent(core:get_ui_root(), "dlc25_bog_main", "button_l") end,
			function() return find_uicomponent(core:get_ui_root(), "dlc25_bog_main", "button_r") end
		},
		text_box = {
			text = "dlc25_text_pointer_dwf_book_of_grudges_3",
			direction = "bottom",
			size = 400,
			length = 60
		},
		click_on_navigate = function() return find_uicomponent(core:get_ui_root(), "dlc25_bog_main", "confederation_tab") end,
		navigation_delay = 1
	},
	{
		id = "BoG_4",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "holder_confederate_content") end,
			function() return find_uicomponent(core:get_ui_root(), "button_confederate") end,
			function() return find_uicomponent(core:get_ui_root(), "dlc25_bog_confederate", "holder_feature_description") end,
		},
		text_box = {
			text = "dlc25_text_pointer_dwf_book_of_grudges_4",
			direction = "left",
			size = 400,
			length = 80
		},
		click_on_navigate = function() return find_uicomponent(core:get_ui_root(), "dlc25_bog_main", "unit_pack_tab") end,
		navigation_delay = 1
	},
	{
		id = "BoG_5",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_bog_main", "dlc25_bog_unit_packs", "holder_unit_packs") end
		},
		text_box = {
			text = "dlc25_text_pointer_dwf_book_of_grudges_5",
			direction = "left",
			size = 400,
			length = 80
		},
		pulse = {
			function() return find_uicomponent(ui_scripted_tour:find_valid_child_component(find_uicomponent(core:get_ui_root(), "dlc25_bog_main", "dlc25_bog_unit_packs", "holder_unit_packs")), "unlock_tier") end
		},
		navigation_delay = 1
	},
}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- EMP Gunnery School
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

in_emp_gunnery_school_tour = intervention:new(
	"in_emp_gunnery_school_tour",			 						-- string name
	0, 																	-- cost
	function() 
		cm:callback(function()
			out("#### "..scripted_emp_gunnery_school_tour.id.." ####")
			
			ui_scripted_tour:construct_tour(scripted_emp_gunnery_school_tour, in_emp_gunnery_school_tour)
		end,
		0.2)															-- trigger callback
	end,					
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
)

in_emp_gunnery_school_tour:add_advice_key_precondition("wh3.dlc25.camp.advice.emp.gunnery_school.001")
in_emp_gunnery_school_tour:set_wait_for_fullscreen_panel_dismissed(false)
in_emp_gunnery_school_tour:set_should_lock_ui()
in_emp_gunnery_school_tour:add_trigger_condition(
	"ComponentLClickUp",
	function(context)
		local panel = find_uicomponent(core:get_ui_root(), "dlc25_don_main")
		if panel and panel:Visible() then
			cm:steal_user_input(true)
			return true
		end
	end
)

scripted_emp_gunnery_school_tour = {
	id = "in_emp_gunnery_school_tour",
	localised_name = "ui_text_replacements_localised_text_hp_campaign_title_imperial_gunnery_school",
	advice_string = "wh3.dlc25.camp.advice.emp.gunnery_school.001",
	reposition_controls = function() return find_uicomponent(core:get_ui_root(), "dlc25_don_main", "bar_holder") end,

	{
		id = "emp_gunnery_school_intro",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_don_main", "panel_title") end,
			function() return find_uicomponent(core:get_ui_root(), "dlc25_don_main", "buttons_container") end
		},
		text_box = {
			text = "dlc25_text_pointer_emp_gunnery_school_1",
			direction = "top",
			size = 350,
			length = 50
		}
	},
	{
		id = "emp_gunnery_school_buttons",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_don_main", "units_list") end
		},
		text_box = {
			text = "dlc25_text_pointer_emp_gunnery_school_2",
			direction = "left",
			size = 350,
			length = 50
		}
	},
	{
		id = "emp_gunnery_school_units",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_don_main", "card_holder") end
		},
		text_box = {
			text = "dlc25_text_pointer_emp_gunnery_school_3",
			direction = "right",
			size = 350,
			length = 50
		}
	},
	{
		id = "emp_gunnery_school_upgrades",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_don_main", "upgrades_container") end
		},
		text_box = {
			text = "dlc25_text_pointer_emp_gunnery_school_4",
			direction = "right",
			size = 350,
			length = 50
		}
	},
	{
		id = "emp_gunnery_school_upgrade_purchase",
		highlight = {
			function() return find_uicomponent(get_gunnery_upgrade_comp(1), "upgrade_details_container") end,
		},
		text_box = {
			text = "dlc25_text_pointer_emp_gunnery_school_5",
			direction = "right",
			size = 350,
			length = 50
		}
	},
	{
		id = "emp_gunnery_school_upgrade_locks",
		highlight = {
			function() return find_uicomponent(get_gunnery_upgrade_comp(2), "upgrade_level") end,
			function() return find_uicomponent(get_gunnery_upgrade_comp(3), "upgrade_level") end,
		},
		text_box = {
			text = "dlc25_text_pointer_emp_gunnery_school_6",
			direction = "right",
			size = 350,
			length = 50
		}
	},
	{
		id = "emp_gunnery_school_tiers",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_don_main", "workshop_level_context") end
		},
		text_box = {
			text = "dlc25_text_pointer_emp_gunnery_school_7",
			direction = "top",
			size = 350,
			length = 50
		}
	},
	{
		id = "emp_gunnery_school_amethyst_armory",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_don_main", "tab_armoury") end
		},
		text_box = {
			text = "dlc25_text_pointer_emp_gunnery_school_8",
			direction = "top",
			size = 350,
			length = 50
		}
	},
}

function get_gunnery_upgrade_comp(child_no)
	local parent = find_uicomponent(core:get_ui_root(), "dlc25_don_main", "gun_school_creator", "upgrade_content")
	return find_child_uicomponent_by_index(parent, child_no)
end


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- EMP Electoral Machinations
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

in_emp_electoral_machinations_tour = intervention:new(
	"in_emp_electoral_machinations_tour",			 						-- string name
	0, 																	-- cost
	function() 
		cm:callback(function()
			out("#### "..scripted_emp_electoral_machinations_tour.id.." ####")
			
			ui_scripted_tour:construct_tour(scripted_emp_electoral_machinations_tour, in_emp_electoral_machinations_tour)
		end,
		0.2)															-- trigger callback
	end,					
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
)

in_emp_electoral_machinations_tour:add_advice_key_precondition("wh3.dlc25.camp.advice.emp.electoral_machinations.001")
in_emp_electoral_machinations_tour:set_wait_for_fullscreen_panel_dismissed(false)
in_emp_electoral_machinations_tour:set_should_lock_ui()
in_emp_electoral_machinations_tour:add_trigger_condition(
	"ComponentLClickUp",
	function(context)
		local panel = find_uicomponent(core:get_ui_root(), "dlc25_electoral_machinations")
		if panel and panel:Visible() then
			return true
		end
	end
)

scripted_emp_electoral_machinations_tour = {
	id = "in_emp_electoral_machinations_tour",
	localised_name = "ui_text_replacements_localised_text_dlc25_college_of_magic_title_wh_main_emp_empire",
	advice_string = "wh3.dlc25.camp.advice.emp.electoral_machinations.001",

	{
		id = "emp_electoral_machinations_1",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_electoral_machinations") end
		},
		text_box = {
			text = "dlc25_text_pointer_emp_electoral_machinations_1",
			direction = "bottom",
			size = 350,
			length = 50
		}
	},
	{
		id = "emp_electoral_machinations_2",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_electoral_machinations", "category_button") end
		},
		text_box = {
			text = "dlc25_text_pointer_emp_electoral_machinations_2",
			direction = "top",
			size = 350,
			length = 50
		}
	},
	{
		id = "emp_electoral_machinations_3",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_electoral_machinations", "repeatable_rituals_list") end
		},
		text_box = {
			text = "dlc25_text_pointer_emp_electoral_machinations_3",
			direction = "left",
			size = 350,
			length = 50
		}
	},
	{
		id = "emp_electoral_machinations_4",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_electoral_machinations", "ritual_info") end
		},
		text_box = {
			text = "dlc25_text_pointer_emp_electoral_machinations_4",
			direction = "right",
			size = 350,
			length = 50
		}
	},
	{
		id = "emp_electoral_machinations_5",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_electoral_machinations", "button_perform") end
		},
		text_box = {
			text = "dlc25_text_pointer_emp_electoral_machinations_5",
			direction = "bottom",
			size = 350,
			length = 50
		},
		click_on_navigate = function() return find_uicomponent(core:get_ui_root(), "dlc25_electoral_machinations", "category_button") end
	},
	{
		id = "emp_electoral_machinations_6",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_electoral_machinations", "button_electoral_machinations") end
		},
		text_box = {
			text = "dlc25_text_pointer_emp_electoral_machinations_6",
			direction = "top",
			size = 350,
			length = 50
		},
		click_on_navigate = function() return find_uicomponent(core:get_ui_root(), "dlc25_electoral_machinations", "button_electoral_machinations") end
	},
	{
		id = "emp_electoral_machinations_7",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_electoral_machinations", "dropdown_button") end
		},
		text_box = {
			text = "dlc25_text_pointer_emp_electoral_machinations_7",
			direction = "bottom",
			size = 350,
			length = 50
		}
	},
	{
		id = "emp_electoral_machinations_8",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_electoral_machinations", "button_improve") end,
			function() return find_uicomponent(core:get_ui_root(), "dlc25_electoral_machinations", "button_decrease") end
		},
		text_box = {
			text = "dlc25_text_pointer_emp_electoral_machinations_8",
			direction = "bottom",
			size = 350,
			length = 50
		}
	},
}


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- EMP College of Magic
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

in_emp_college_of_magic_tour = intervention:new(
	"in_emp_college_of_magic_tour",			 						-- string name
	0, 																	-- cost
	function() 
		cm:callback(function()
			out("#### "..scripted_emp_college_of_magic_tour.id.." ####")
			
			ui_scripted_tour:construct_tour(scripted_emp_college_of_magic_tour, in_emp_college_of_magic_tour)
		end,
		0.2)															-- trigger callback
	end,					
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
)

in_emp_college_of_magic_tour:add_advice_key_precondition("wh3.dlc25.camp.advice.emp.college_of_magic.001")
in_emp_college_of_magic_tour:set_wait_for_fullscreen_panel_dismissed(false)
in_emp_college_of_magic_tour:set_should_lock_ui()
in_emp_college_of_magic_tour:add_trigger_condition(
	"ComponentLClickUp",
	function(context)
		local panel = find_uicomponent(core:get_ui_root(), "dlc25_college_of_magic")
		if panel and panel:Visible() then
			return true
		end
	end
)

scripted_emp_college_of_magic_tour = {
	id = "in_emp_college_of_magic_tour",
	localised_name = "ui_text_replacements_localised_text_dlc25_college_of_magic_title",
	advice_string = "wh3.dlc25.camp.advice.emp.college_of_magic.001",

	{
		id = "emp_college_of_magic_intro",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_college_of_magic", "panel_container") end
		},
		text_box = {
			text = "dlc25_text_pointer_emp_college_of_magic_1",
			direction = "bottom",
			size = 350,
			length = 50
		}
	},
	{
		id = "emp_college_of_magic_tabs",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_college_of_magic", "category_group_list") end
		},
		text_box = {
			text = "dlc25_text_pointer_emp_college_of_magic_2",
			direction = "top",
			size = 350,
			length = 50
		}
	},
	{
		id = "emp_college_of_magic_repeatable",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_college_of_magic", "repeatable_rituals_list") end
		},
		text_box = {
			text = "dlc25_text_pointer_emp_college_of_magic_3",
			direction = "bottom",
			size = 350,
			length = 50
		}
	},
	{
		id = "emp_college_of_magic_unlocks",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_college_of_magic", "oneshot_rituals_list") end
		},
		text_box = {
			text = "dlc25_text_pointer_emp_college_of_magic_4",
			direction = "bottom",
			size = 350,
			length = 50
		}
	},
	{
		id = "emp_college_of_magic_info",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_college_of_magic", "ritual_info") end
		},
		text_box = {
			text = "dlc25_text_pointer_emp_college_of_magic_5",
			direction = "right",
			size = 350,
			length = 50
		}
	},
	{
		id = "emp_college_of_magic_purchase",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc25_college_of_magic", "button_perform") end
		},
		text_box = {
			text = "dlc25_text_pointer_emp_college_of_magic_6",
			direction = "bottom",
			size = 350,
			length = 50
		}
	}
}





--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- Khorne Skull Throne
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

in_kho_skull_throne_tour = intervention:new(
	"in_kho_skull_throne_tour",			 								-- string name
	0, 																	-- cost
	function()
		cm:callback(function()
			local uic = find_uicomponent("dlc26_skull_throne", "body", "rituals_holder")
			if uic and uic:Visible() then
				out("#### "..scripted_kho_skull_throne_tour.id.." ####")
				ui_scripted_tour:construct_tour(scripted_kho_skull_throne_tour, in_kho_skull_throne_tour)
				in_kho_skull_throne_tour:set_should_lock_ui()
			elseif not uic or not uic:Visible() then
				in_kho_skull_throne_tour:cancel()
			end
		end,	0.1)													-- trigger callback
	end,					
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
)

in_kho_skull_throne_tour:add_advice_key_precondition("wh3.dlc26.camp.advice.kho.skull_throne.001")
in_kho_skull_throne_tour:set_wait_for_fullscreen_panel_dismissed(false)
in_kho_skull_throne_tour:set_should_lock_ui()
in_kho_skull_throne_tour:add_trigger_condition(
	"PanelOpenedCampaign",
	function(context)
		return context.string == "dlc26_skull_throne"
	end
)

scripted_kho_skull_throne_tour = {
	id = "in_kho_skull_throne_tour",
	localised_name = "ui_text_replacements_localised_text_hp_campaign_title_skull_throne",
	advice_string = "wh3.dlc26.camp.advice.kho.skull_throne.001",
	{
		id = "kho_skull_throne_rituals",
		highlight = {
			function() return find_uicomponent("dlc26_skull_throne", "rituals_holder") end
		},
		text_box = {
			text = "dlc26_text_pointer_kho_skull_throne_1",
			direction = "top",
			size = 350,
			length = 25
		}
	},
	{
		id = "kho_skull_throne_ritual_button",
		highlight = {
			function() return find_uicomponent(ui_scripted_tour:find_valid_child_component(find_uicomponent("dlc26_skull_throne", "t1_rituals_holder"))) end
		},
		text_box = {
			text = "dlc26_text_pointer_kho_skull_throne_2",
			direction = "left",
			size = 350,
			length = 50
		}
	},
	{
		id = "kho_skull_throne_skulls_bar",
		highlight = {
			function() return find_uicomponent("dlc26_skull_throne", "skull_throne_progress_bar", "bar") end
		},
		highlight_size_mod = 40,
		text_box = {
			text = "dlc26_text_pointer_kho_skull_throne_3",
			direction = "left",
			size = 350,
			length = 50
		}
	},
	{
		id = "kho_skull_throne_skulls_tier",
		highlight = {
			function() return find_uicomponent("dlc26_skull_throne", "CcoPooledResourceThresholdOperationSetRecordwh3_dlc26_operation_set_kho_skull_throne_progress_1") end
		},
		highlight_size_mod = 40,
		text_box = {
			text = "dlc26_text_pointer_kho_skull_throne_4",
			direction = "left",
			size = 350,
			length = 50,
			x_offset = 50
		}
	}
}





--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- Khorne Cloak of Skulls
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

in_kho_cloak_of_skulls_tour = intervention:new(
	"in_kho_cloak_of_skulls_tour",			 							-- string name
	0, 																	-- cost
	function() 															-- trigger callback
		out("#### "..scripted_kho_cloak_of_skulls_tour.id.." ####")
		ui_scripted_tour:construct_tour(scripted_kho_cloak_of_skulls_tour, in_kho_cloak_of_skulls_tour)
	end,					
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
)

in_kho_cloak_of_skulls_tour:add_advice_key_precondition("wh3.dlc26.camp.advice.kho.cloak_of_skulls.001")
in_kho_cloak_of_skulls_tour:set_wait_for_fullscreen_panel_dismissed(false)
in_kho_cloak_of_skulls_tour:set_should_lock_ui()
in_kho_cloak_of_skulls_tour:add_trigger_condition(
	"PanelOpenedCampaign",
	function(context)
		return context.string == "dlc26_cloak_of_skulls"
	end
)

scripted_kho_cloak_of_skulls_tour = {
	id = "in_kho_cloak_of_skulls_tour",
	localised_name = "ui_text_replacements_localised_text_hp_campaign_title_cloak_of_skulls",
	advice_string = "wh3.dlc26.camp.advice.kho.cloak_of_skulls.001",
	{
		id = "kho_cloak_of_skulls_cloak",
		highlight = {
			function() return find_uicomponent("dlc26_cloak_of_skulls", "skulls", "links") end
		},
		text_box = {
			text = "dlc26_text_pointer_kho_cloak_of_skulls_1",
			direction = "bottom",
			size = 350,
			length = 25
		}
	},
	{
		id = "kho_cloak_of_skulls_skull",
		highlight = {
			function() return find_uicomponent("dlc26_cloak_of_skulls", "row_1", "1") end
		},
		text_box = {
			text = "dlc26_text_pointer_kho_cloak_of_skulls_2",
			direction = "bottom",
			size = 350,
			length = 50
		},
		click_on_navigate = function()
			local uic = find_uicomponent("dlc26_cloak_of_skulls", "skull_info_holder", "button_enchant")

			if not uic or not uic:Visible() then
				return find_uicomponent("dlc26_cloak_of_skulls", "row_1", "1", "dlc26_cloak_skull_template", "content_holder")
			end
		end
	},
	{
		id = "kho_cloak_of_skulls_skull_details",
		highlight = {
			function() return find_uicomponent("dlc26_cloak_of_skulls", "skull_info_holder", "tier_list") end
		},
		text_box = {
			text = "dlc26_text_pointer_kho_cloak_of_skulls_3",
			direction = "left",
			size = 350,
			length = 50
		}
	},
	{
		id = "kho_cloak_of_skulls_empower",
		highlight = {
			function() return find_uicomponent("dlc26_cloak_of_skulls", "skull_info_holder", "button_enchant") end
		},
		text_box = {
			text = "dlc26_text_pointer_kho_cloak_of_skulls_4",
			direction = "left",
			size = 350,
			length = 50
		}
	},
	{
		id = "kho_cloak_of_skulls_effects",
		highlight = {
			function() return find_uicomponent("dlc26_cloak_of_skulls", "active_effects_holder") end
		},
		text_box = {
			text = "dlc26_text_pointer_kho_cloak_of_skulls_5",
			direction = "right",
			size = 350,
			length = 50
		}
	}
}





--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- Khorne Cloak of Skulls Teleport
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

in_kho_cloak_of_skulls_teleport_tour = intervention:new(
	"in_kho_cloak_of_skulls_teleport_tour",			 					-- string name
	0, 																	-- cost
	function() 															-- trigger callback
		out("#### "..scripted_kho_cloak_of_skulls_teleport_tour.id.." ####")
		ui_scripted_tour:construct_tour(scripted_kho_cloak_of_skulls_teleport_tour, in_kho_cloak_of_skulls_teleport_tour)
	end,					
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
)

in_kho_cloak_of_skulls_teleport_tour:add_advice_key_precondition("wh3.dlc26.camp.advice.kho.cloak_of_skulls_teleport.001")
in_kho_cloak_of_skulls_teleport_tour:set_wait_for_fullscreen_panel_dismissed(false)
in_kho_cloak_of_skulls_teleport_tour:set_should_lock_ui()
in_kho_cloak_of_skulls_teleport_tour:add_trigger_condition(
	"CharacterSelected",
	function(context)
		local character = context:character()

		return character:character_subtype_key() == "wh3_dlc26_kho_skulltaker" and not character:faction():rituals():ritual_status("wh3_dlc26_skulltaker_teleport"):script_locked()
	end
)

in_kho_cloak_of_skulls_teleport_tour:add_trigger_condition(
	"PanelOpenedCampaign",
	function(context)
		if context.string == "units_panel" then

			local skulltaker = find_uicomponent("units_panel", "units", "LandUnit 0")
			if skulltaker then
				local cco_skull = skulltaker:GetContextObject("CcoCampaignUnit"):Call("UnitRecordContext"):Call("Key")

				if cco_skull and cco_skull == "wh3_dlc26_kho_cha_skulltaker" then
					local skulltaker_faction = cm:get_faction("wh3_dlc26_kho_skulltaker")
					return not skulltaker_faction:rituals():ritual_status("wh3_dlc26_skulltaker_teleport"):script_locked()
				end
			end
		end

		return false
	end
)


scripted_kho_cloak_of_skulls_teleport_tour = {
	id = "in_kho_cloak_of_skulls_teleport_tour",
	localised_name = "rituals_display_name_wh3_dlc26_skulltaker_teleport",
	advice_string = "wh3.dlc26.camp.advice.kho.cloak_of_skulls_teleport.001",
	{
		id = "kho_cloak_of_skulls_teleport_cloak",
		highlight = {
			function() return find_uicomponent("character_info_parent", "dlc26_cloak_of_skulls_teleport_holder") end
		},
		text_box = {
			text = "dlc26_text_pointer_kho_cloak_of_skulls_teleport_1",
			direction = "left",
			size = 350,
			length = 60
		}
	}
}





--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- Khorne Wrath of Khorne
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

in_kho_wrath_of_khorne_tour = intervention:new(
	"in_kho_wrath_of_khorne_tour",			 							-- string name
	0, 																	-- cost
	function() 															-- trigger callback
		out("#### "..scripted_kho_wrath_of_khorne_tour.id.." ####")
		ui_scripted_tour:construct_tour(scripted_kho_wrath_of_khorne_tour, in_kho_wrath_of_khorne_tour)
	end,					
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
)

in_kho_wrath_of_khorne_tour:add_advice_key_precondition("wh3.dlc26.camp.advice.kho.wrath_of_khorne.001")
in_kho_wrath_of_khorne_tour:set_wait_for_fullscreen_panel_dismissed(false)
in_kho_wrath_of_khorne_tour:set_should_lock_ui()
in_kho_wrath_of_khorne_tour:add_trigger_condition(
	"PanelOpenedCampaign",
	function(context)
		return context.string == "dlc26_wrath_of_khorne"
	end
)

scripted_kho_wrath_of_khorne_tour = {
	id = "in_kho_wrath_of_khorne_tour",
	localised_name = "ui_text_replacements_localised_text_hp_campaign_title_wrath_of_khorne",
	advice_string = "wh3.dlc26.camp.advice.kho.wrath_of_khorne.001",
	{
		id = "kho_wrath_of_khorne_challenges",
		highlight = {
			function() return find_uicomponent("dlc26_wrath_of_khorne", "map") end
		},
		text_box = {
			text = "dlc26_text_pointer_kho_wrath_of_khorne_1",
			direction = "bottom",
			size = 350,
			length = 25
		},
		click_on_navigate = function()
			local uic = find_uicomponent("dlc26_wrath_of_khorne", "mission_selected")

			if uic and uic:Visible() then
				return find_uicomponent("dlc26_wrath_of_khorne", "map_overlay", "wh3_dlc26_arbaal_wrath_of_khorne_mission_weak_1")
			end
		end
	},
	{
		id = "kho_wrath_of_khorne_challenge_types",
		highlight = {
			function() return find_uicomponent("dlc26_wrath_of_khorne", "no_marker_selected") end
		},
		text_box = {
			text = "dlc26_text_pointer_kho_wrath_of_khorne_2",
			direction = "left",
			size = 350,
			length = 50
		}
	},
	{
		id = "kho_wrath_of_khorne_map",
		highlight = {
			function() return find_uicomponent("dlc26_wrath_of_khorne", "map_overlay", "wh3_dlc26_arbaal_wrath_of_khorne_mission_weak_1") end
		},
		text_box = {
			text = "dlc26_text_pointer_kho_wrath_of_khorne_3",
			direction = "bottom",
			size = 350,
			length = 50
		},
		click_on_navigate = function()
			local uic = find_uicomponent("dlc26_wrath_of_khorne", "mission_selected")

			if not uic or not uic:Visible() then
				return find_uicomponent("dlc26_wrath_of_khorne", "map_overlay", "wh3_dlc26_arbaal_wrath_of_khorne_mission_weak_1")
			end
		end
	},
	{
		id = "kho_wrath_of_khorne_travel",
		highlight = {
			function() return find_uicomponent("dlc26_wrath_of_khorne", "travel_button") end
		},
		text_box = {
			text = "dlc26_text_pointer_kho_wrath_of_khorne_4",
			direction = "left",
			size = 350,
			length = 50
		}
	},
	{
		id = "kho_wrath_of_khorne_capital",
		highlight = {
			function() return find_uicomponent("dlc26_wrath_of_khorne", "map_overlay", "capital") end
		},
		text_box = {
			text = "dlc26_text_pointer_kho_wrath_of_khorne_5",
			direction = "bottom",
			size = 350,
			length = 50
		}
	},
	{
		id = "kho_wrath_of_khorne_boons",
		highlight = {
			function()
				local uic = find_uicomponent("dlc26_wrath_of_khorne", "panel_right_low_res")

				if uic and uic:Visible() then
					return uic
				else
					return find_uicomponent("dlc26_wrath_of_khorne", "panel_right_high_res")
				end
			end
		},
		text_box = {
			text = "dlc26_text_pointer_kho_wrath_of_khorne_6",
			direction = "right",
			size = 350,
			length = 50
		}
	}
}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- OGR Meat Transfer
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

in_ogr_meat_transfer_tour = intervention:new(
	"in_ogr_meat_transfer_tour",			 						-- string name
	0, 																	-- cost
	function()
		cm:callback(function()
			local uic = find_uicomponent(core:get_ui_root(), "units_panel", "main_units_panel", "meat_transfer_docker", "dlc26_ogr_meat_transfer")
			if uic and uic:Visible() then
				out("#### "..scripted_ogr_meat_transfer_tour.id.." ####")
				ui_scripted_tour:construct_tour(scripted_ogr_meat_transfer_tour, in_ogr_meat_transfer_tour)
				in_ogr_meat_transfer_tour:set_should_lock_ui()
				cm:steal_escape_key(true) 
			elseif not uic or not uic:Visible() then
				in_ogr_meat_transfer_tour:cancel()
			end
		end,	0.1)					
	end,					
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
)

in_ogr_meat_transfer_tour:add_advice_key_precondition("wh3.dlc26.camp.advice.ogr.meat_transfer.001")
in_ogr_meat_transfer_tour:set_wait_for_fullscreen_panel_dismissed(false)
in_ogr_meat_transfer_tour:set_should_lock_ui()
in_ogr_meat_transfer_tour:add_trigger_condition(
	"ComponentLClickUp",
	function(context)
		local panel = find_uicomponent(core:get_ui_root(), "dlc26_ogr_meat_transfer")
		if panel and panel:Visible() then
			return true
		end
	end
)

scripted_ogr_meat_transfer_tour = {
	id = "in_ogr_meat_transfer_tour",
	localised_name = "ui_text_replacements_localised_text_dlc26_meat_transfer_title",
	advice_string = "wh3.dlc26.camp.advice.ogr.meat_transfer.001",

	{
		id = "ogr_meat_transfer_1",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc26_ogr_meat_transfer", "panel_main") end
		},
		text_box = {
			text = "dlc26_text_pointer_ogr_meat_transfer_1",
			direction = "bottom",
			size = 350,
			length = 50
		}
	},
	{
		id = "ogr_meat_transfer_2",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc26_ogr_meat_transfer", "holder_armies_list") end
		},
		text_box = {
			text = "dlc26_text_pointer_ogr_meat_transfer_2",
			direction = "bottom",
			size = 350,
			length = 50
		}
	},
	{
		id = "ogr_meat_transfer_3",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc26_ogr_meat_transfer", "holder_camps_list") end
		},
		text_box = {
			text = "dlc26_text_pointer_ogr_meat_transfer_3",
			direction = "bottom",
			size = 350,
			length = 50
		}
	},
	{
		id = "ogr_meat_transfer_4",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc26_ogr_meat_transfer", "holder_transfer_controls") end
		},
		text_box = {
			text = "dlc26_text_pointer_ogr_meat_transfer_4",
			direction = "bottom",
			size = 350,
			length = 50
		}
	},
	{
		id = "ogr_meat_transfer_5",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc26_ogr_meat_transfer", "section_buttons")  end
		},
		text_box = {
			text = "dlc26_text_pointer_ogr_meat_transfer_5",
			direction = "bottom",
			size = 350,
			length = 50
		},
	},
}





--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- Ogre Kingdoms Tyrant's Demands
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

in_ogr_tyrants_demands_tour = intervention:new(
	"in_ogr_tyrants_demands_tour",			 							-- string name
	0, 																	-- cost
	function() 															-- trigger callback
		out("#### "..scripted_ogr_tyrants_demands_tour.id.." ####")
		ui_scripted_tour:construct_tour(scripted_ogr_tyrants_demands_tour, in_ogr_tyrants_demands_tour)
	end,					
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
)

in_ogr_tyrants_demands_tour:add_advice_key_precondition("wh3.dlc26.camp.advice.ogr_tyrants_demands.001")
in_ogr_tyrants_demands_tour:set_wait_for_fullscreen_panel_dismissed(false)
in_ogr_tyrants_demands_tour:set_should_lock_ui()
in_ogr_tyrants_demands_tour:add_trigger_condition(
	"PanelOpenedCampaign",
	function(context)
		return context.string == "dlc26_tyrants_demands"
	end
)

scripted_ogr_tyrants_demands_tour = {
	id = "in_ogr_tyrants_demands_tour",
	localised_name = "ui_text_replacements_localised_text_hp_campaign_title_tyrants_demands",
	advice_string = "wh3.dlc26.camp.advice.ogr_tyrants_demands.001",
	{
		id = "ogr_tyrants_demands_panel",
		highlight = {
			function() return find_uicomponent("dlc26_tyrants_demands", "panel_container") end
		},
		text_box = {
			text = "dlc26_text_pointer_ogr_tyrants_demands_1",
			direction = "bottom",
			size = 350,
			length = 50,
			y_offset = -10
		}
	},
	{
		id = "ogr_tyrants_demands_actions",
		highlight = {
			function() return find_uicomponent("dlc26_tyrants_demands", "actions_list") end
		},
		text_box = {
			text = "dlc26_text_pointer_ogr_tyrants_demands_2",
			direction = "bottom",
			size = 350,
			length = 50
		}
	},
	{
		id = "ogr_tyrants_demands_action_details",
		highlight = {
			function() return find_uicomponent("dlc26_tyrants_demands", "perform_target_holder") end
		},
		text_box = {
			text = "dlc26_text_pointer_ogr_tyrants_demands_3",
			direction = "right",
			size = 350,
			length = 50
		}
	},
	{
		id = "ogr_tyrants_demands_perform",
		highlight = {
			function() return find_uicomponent("dlc26_tyrants_demands", "button_perform") end
		},
		text_box = {
			text = "dlc26_text_pointer_ogr_tyrants_demands_4",
			direction = "bottom",
			size = 350,
			length = 50
		}
	}
}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- OGR Contracts
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

in_ogr_contracts_tour = intervention:new(
	"in_ogr_contracts_tour",			 						-- string name
	0, 																	-- cost
	function() 
		cm:callback(function()
			if find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_group_management", "button_ogre_war_contracts"):VisibleFromRoot() then
			cm:steal_user_input(true)
			out("#### "..scripted_ogr_contracts_tour.id.." ####")
			ui_scripted_tour:toggle_shortcuts(false)
			ui_scripted_tour:construct_tour(scripted_ogr_contracts_tour, in_ogr_contracts_tour)

			else 
				in_ogr_contracts_tour:cancel()

			end
		end, 0.1)															-- trigger callback
	end,					
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
)
in_ogr_contracts_tour:add_advice_key_precondition("wh3.dlc26.camp.advice.ogr.contracts.001")
in_ogr_contracts_tour:set_wait_for_fullscreen_panel_dismissed(false)
in_ogr_contracts_tour:set_should_lock_ui()
in_ogr_contracts_tour:add_trigger_condition(
	"ScriptEventCampaignIntroComplete",
	function(context)
		ui_scripted_tour:toggle_shortcuts(false)
		cm:steal_user_input(true)
		return true
	end 
)

scripted_ogr_contracts_tour = {
	id = "in_ogr_contracts_tour",
	localised_name = "ui_text_replacements_localised_text_dlc26_ogre_contracts_title",
	advice_string = "wh3.dlc26.camp.advice.ogr.contracts.001",

	{
		id = "ogr_contracts_1",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "button_ogre_war_contracts") end
		},
		text_box = {
			text = "dlc26_text_pointer_ogre_contracts_1",
			direction = "right",
			size = 350,
			length = 50
		},
		navigation_delay = 0.5,
		click_on_navigate = function() 
				if find_uicomponent(core:get_ui_root(), "dlc26_ogre_war_contracts") == false then
					return find_uicomponent(core:get_ui_root(), "button_ogre_war_contracts")
				else
					return false
				end
			end,
	},
	{
		id = "ogr_contracts_2",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc26_ogre_war_contracts", "panel_main", "list_box") end
		},
		text_box = {
			text = "dlc26_text_pointer_ogre_contracts_2",
			direction = "left",
			size = 350,
			length = 50
		},
		navigation_delay = 0.5
	},
	{
		id = "ogr_contracts_3",
		highlight = {
			function()
				local uic = find_uicomponent(core:get_ui_root(), "dlc26_ogre_war_contracts", "panel_main", "list_box", "available_contracts_list")
				
				for i = 0, uic:ChildCount() - 1 do
					local child = find_child_uicomponent_by_index(uic, i)
					if child and child:Visible() and string.find(child:Id(), "CcoCampaignWarContract") then
						return child
					end
				end
			end
		},
		text_box = {
			text = "dlc26_text_pointer_ogre_contracts_3",
			direction = "left",
			size = 350,
			length = 50
		},
		click_on_navigate = function()
			if find_uicomponent(core:get_ui_root(), "dlc26_ogre_war_contracts", "selected_contract"):VisibleFromRoot() == false then
				local uic = find_uicomponent(core:get_ui_root(), "dlc26_ogre_war_contracts", "panel_main", "list_box", "available_contracts_list")
					
				for i = 0, uic:ChildCount() - 1 do
					local child = find_child_uicomponent_by_index(uic, i)
					if child and child:Visible() and string.find(child:Id(), "CcoCampaignWarContract") then
						return child
					end
				end
			end
		end,
	},
	{
		id = "ogr_contracts_4",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc26_ogre_war_contracts", "selected_contract", "client_emblem")  end
		},
		text_box = {
			text = "dlc26_text_pointer_ogre_contracts_4",
			direction = "left",
			size = 350,
			length = 50
		},
		navigation_delay = 0.5
	},
	{
		id = "ogr_contracts_5",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc26_ogre_war_contracts", "selected_contract", "objectives_holder")  end
		},
		text_box = {
			text = "dlc26_text_pointer_ogre_contracts_5",
			direction = "bottom",
			size = 350,
			length = 50
		},
	},
	{
		id = "ogr_contracts_6",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc26_ogre_war_contracts", "selected_contract", "requirements_holder")  end
		},
		text_box = {
			text = "dlc26_text_pointer_ogre_contracts_6",
			direction = "bottom",
			size = 350,
			length = 50
		},
	},
	{
		id = "ogr_contracts_7",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc26_ogre_war_contracts", "selected_contract", "actions_list")  end
		},
		text_box = {
			text = "dlc26_text_pointer_ogre_contracts_7",
			direction = "bottom",
			size = 350,
			length = 50
		},
	},
	{
		id = "ogr_contracts_8",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc26_ogre_war_contracts", "panel_selected_contract", "rewards_list")  end
		},
		text_box = {
			text = "dlc26_text_pointer_ogre_contracts_8",
			direction = "bottom",
			size = 350,
			length = 50
		},
	},
	{
		id = "ogr_contracts_9",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc26_ogre_war_contracts", "panel_selected_contract", "btn_stamp_holder", "accept_contract_btn")  end
		},
		text_box = {
			text = "dlc26_text_pointer_ogre_contracts_9",
			direction = "bottom",
			size = 350,
			length = 50
		},
	},
}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- OGR Camps
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
in_ogr_camps_tour = intervention:new(
	"in_ogr_camps_tour",			 						-- string name
	0, 																	-- cost
	function() 
		cm:callback(function()
			if find_uicomponent(core:get_ui_root(), "hud_campaign", "info_panel_holder", "primary_info_panel_holder", "info_panel_background", "CharacterInfoPopup", "character_info_parent", "camp_teleport_holder", "camp_teleport_button"):VisibleFromRoot() then

				out("#### "..scripted_ogr_camp_tour.id.." ####")
			
				ui_scripted_tour:construct_tour(scripted_ogr_camp_tour, in_ogr_camps_tour)
			else 
				in_ogr_camps_tour:cancel()

			end
		end,	0.2)															-- trigger callback
	end,					
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
)
in_ogr_camps_tour:add_advice_key_precondition("wh3.dlc26.camp.advice.ogr.camp.001")
in_ogr_camps_tour:set_wait_for_fullscreen_panel_dismissed(false)
in_ogr_camps_tour:set_should_lock_ui()
in_ogr_camps_tour:add_trigger_condition(
	"CharacterSelected",
	function(context)
		return context:character():character_subtype_key() == "wh3_main_ogr_tyrant_camp"
	end
)

scripted_ogr_camp_tour = {
	id = "in_ogr_camps_tour",
	localised_name = "ui_text_replacements_localised_text_hp_campaign_title_ogre_camps",
	advice_string = "wh3.dlc26.camp.advice.ogr.camp.001",

	{
		id = "ogr_camps_1",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "CharacterInfoPopup", "icon_meat") end
		},
		text_box = {
			text = "dlc26_text_pointer_ogre_camps_1",
			direction = "bottom",
			size = 350,
			length = 50
		},
	},
	{
		id = "ogr_camps_2",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "CharacterInfoPopup", "icon_meat") end
		},
		text_box = {
			text = "dlc26_text_pointer_ogre_camps_2",
			direction = "bottom",
			size = 350,
			length = 50
		},
		navigation_delay = 0.5
	},
	{
		id = "ogr_camps_3",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "CharacterInfoPopup", "camp_teleport_button") end
		},
		text_box = {
			text = "dlc26_text_pointer_ogre_camps_3",
			direction = "bottom",
			size = 350,
			length = 50,
			label_offset_x = 100
		},
	},
}



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- GRN Da Plan
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

in_grn_da_plan_tour = intervention:new(
	"in_grn_da_plan_tour",			 						-- string name
	0, 																	-- cost
	function() 
		cm:callback(function()
			if find_uicomponent(core:get_ui_root(), "parent_army_slots"):VisibleFromRoot() then

				out("#### "..scripted_grn_da_plan_tour.id.." ####")
			
				ui_scripted_tour:construct_tour(scripted_grn_da_plan_tour, in_grn_da_plan_tour)
			else 
				in_grn_da_plan_tour:cancel()
			end
		end, 0.1)															-- trigger callback
	end,					
	BOOL_INTERVENTIONS_DEBUG	 										-- show debug output
)
in_grn_da_plan_tour:add_advice_key_precondition("wh3.dlc26.camp.advice.grn.da_plan.001")
in_grn_da_plan_tour:set_wait_for_fullscreen_panel_dismissed(false)
in_grn_da_plan_tour:set_should_lock_ui()
in_grn_da_plan_tour:add_trigger_condition(
	"PanelOpenedCampaign",
	function(context)
		if context.string == "units_panel" then
			cm:steal_escape_key(true)
			return true
		end 
	end 
)

scripted_grn_da_plan_tour = {
	id = "in_grn_da_plan_tour",
	localised_name = "ui_text_replacements_localised_text_hp_campaign_title_da_plan",
	advice_string = "wh3.dlc26.camp.advice.grn.da_plan.001",

	{
		id = "grn_da_plan_1",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc26_da_plan", "parent_army_slots") end
		},
		text_box = {
			text = "dlc26_text_pointer_grn_da_plan_1",
			direction = "bottom",
			size = 350,
			length = 50
		}
	},
	{
		id = "grn_da_plan_2",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "grn_da_plan_planz") end
		},
		text_box = {
			text = "dlc26_text_pointer_grn_da_plan_2",
			direction = "top",
			size = 350,
			length = 50
		}
	},
	{
		id = "grn_da_plan_3",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc26_da_plan", "parent_army_slots") end
		},
		text_box = {
			text = "dlc26_text_pointer_grn_da_plan_3",
			direction = "bottom",
			size = 350,
			length = 50
		},
		click_on_navigate = function() return find_uicomponent(core:get_ui_root(), "CcoCampaignInitiativeSet146wh3_dlc26_force_initiative_grn_da_plan")	end,
	},
	{
		id = "grn_da_plan_4",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "da_plan_docker", "panel_main") end
		},
		text_box = {
			text = "dlc26_text_pointer_grn_da_plan_4",
			direction = "top",
			size = 350,
			length = 50
		},
		navigation_delay = 0.5
	},
	{
		id = "grn_da_plan_5",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "listview_tactiks") end
		},
		text_box = {
			text = "dlc26_text_pointer_grn_da_plan_5",
			direction = "top",
			size = 350,
			length = 50
		}
	},
	{
		id = "grn_da_plan_6",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "holder_top_detail", "holder_req_units") end
		},
		text_box = {
			text = "dlc26_text_pointer_grn_da_plan_6",
			direction = "right",
			size = 350,
			length = 50
		}
	},
	{
		id = "grn_da_plan_7",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "holder_effects") end
		},
		text_box = {
			text = "dlc26_text_pointer_grn_da_plan_7",
			direction = "bottom",
			size = 350,
			length = 50
		}
	},
	{
		id = "grn_da_plan_8",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "button_equip_tactik") end
		},
		text_box = {
			text = "dlc26_text_pointer_grn_da_plan_8",
			direction = "bottom",
			size = 350,
			length = 50
		}
	},
	{
		id = "grn_da_plan_9",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "dlc26_da_plan", "parent_army_slots") end
		},
		text_box = {
			text = "dlc26_text_pointer_grn_da_plan_9",
			direction = "bottom",
			size = 350,
			length = 50
		}
	},
	{
		id = "grn_da_plan_10",
		highlight = {
			function() return find_uicomponent(core:get_ui_root(), "section_tactik_list", "holder_list_tabs") end
		},
		text_box = {
			text = "dlc26_text_pointer_grn_da_plan_10",
			direction = "top",
			size = 350,
			length = 50
		}
	}
}



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---- Common Functions
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

ui_scripted_tour = {}

function ui_scripted_tour:construct_tour(tour, intervention)
	local infotext = get_infotext_manager()
	
	local nt = navigable_tour:new(
		tour.id, -- unique name 																
		function() end, -- end callback
		tour.localised_name -- title string
	)
	
	if tour.reposition_controls then
		nt:set_interval_before_tour_controls_visible(0)
	end
	
	nt:start_action(
		function()
			-- Dismiss advice.
			cm:dismiss_advice()
			
			infotext:attach_to_advisor(false) -- Unattach infotext to advisor
			nt:set_tour_controls_above_infotext(true) -- This must be called after infotext is unattached
			infotext:cache_and_set_detached_infotext_priority(1500, true)
			nt:cache_and_set_scripted_tour_controls_priority(1500, true)
			
			-- Re-position the controls if needed
			if tour.reposition_controls then
				-- Get components
				local uic_scripted_tour_controls = find_uicomponent("under_advisor_docker", "scripted_tour_controls")
				local uic_target = tour.reposition_controls()
				
				if not uic_target then
					script_error("ERROR: Attempted to re-position scripted tour controls, but could not find ui component - check the calling function")
					return false
				end
				
				-- Get positions
				local uic_target_pos_x, uic_target_pos_y = uic_target:Position()

				-- Get dimensions
				local uic_target_width, uic_target_height = uic_target:Dimensions()

				-- Move beside target component
				uic_scripted_tour_controls:MoveTo((uic_target_pos_x + uic_target_width), uic_target_pos_y)
			end
			
			-- Disable escape key and shortcuts.
			cm:steal_escape_key(true)
			self:toggle_shortcuts(false)
		end,
		0
	)
	nt:end_action( -- Called when the tour ends
		function() 
			infotext:attach_to_advisor(true) -- Reattach infotext to advisor
			infotext:restore_detatched_infotext_priority()
			
			-- Clean up escape key steal and shortcuts.
			cm:steal_escape_key(false)
			self:toggle_shortcuts(true)
			cm:steal_user_input(false)
			
			-- Show advice - this can be hidden to ensure the tour does not repeat until advice is reset
			if tour.advice_string then
				cm:show_advice(tour.advice_string, true)
			end

			local chaos_dwarfs_forge_back_button = find_uicomponent("hellforge_panel_main", "button_close_holder", "button_ok");
			if chaos_dwarfs_forge_back_button and chaos_dwarfs_forge_back_button:Visible() == true then
				chaos_dwarfs_forge_back_button:SetState("active")	
			end 

			nt:restore_scripted_tour_controls_priority()
			intervention:complete()
		end,
		0
	)
	
	for i = 1, #tour do
		local stage = tour[i]
		
		-- Create navigable tour section.
		local nts_stage = navigable_tour_section:new(
			stage.id, -- name of tour section
			false -- activate controls on start
		)
		
		-- Create action of section
		nts_stage:action(
			function()
				-- Build a table of the valid ui components to highlight
				local comp_exists = self:check_components_exist(stage.highlight, stage.id, intervention)
						
				if not comp_exists then return end

				-- Unlock input
				cm:steal_user_input(false)
				
				local highlight_size_mod = stage.highlight_size_mod or 0
				
				core:show_fullscreen_highlight_around_components(15 + highlight_size_mod, false, false, unpack(stage.highlight.components))

				self:pulse_components(stage.pulse, true)

				local pos, width, height = ui_scripted_tour:get_highlighted_size_and_position(stage.highlight.components)
				local tp = ui_scripted_tour:display_text_pointer(stage.text_box.text, stage.text_box.direction, stage.text_box.size, stage.text_box.length, pos, width, height, stage.text_box.x_offset, stage.text_box.y_offset, stage.text_box.label_offset_x, stage.text_box.label_offset_y)

				-- Responsible for cleaning up the action after the player moves forward.
				nts_stage:add_skip_action(
					function(is_tour_ending, is_skipping_backwards)
						core:hide_fullscreen_highlight()
						tp:hide(true)
						
						self:pulse_components(stage.pulse, false)
						
						-- Open the relevant panel when skipping forwards
						if stage.click_on_navigate and not is_skipping_backwards then
							local result = stage.click_on_navigate()
							if result then
								result:SimulateLClick()
							end
						-- Open the relevant panel when skipping backwards
						elseif is_skipping_backwards and tour[i - 2] and tour[i - 2].click_on_navigate then
							local result = tour[i - 2].click_on_navigate()
							if result then
								result:SimulateLClick()
							end
						end
						
						-- Steal input to block actions during transition.
						cm:steal_user_input(true)
					end
				)
			end,
			stage.navigation_delay or 0 -- Interval to start action after section starts.
		)
		
		nt:add_navigable_section(nts_stage)
	end
	
	nt:start()
end

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

function ui_scripted_tour:display_text_pointer(ui_text_replacement, direction, box_size, length, pos, width, height, x_offset, y_offset, label_offset_x, label_offset_y)
	x_offset = x_offset or 0
	y_offset = y_offset or 0
	label_offset_x = label_offset_x or 0
	label_offset_y = label_offset_y or 0
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
	tp_box:set_label_offset(label_offset_x, label_offset_y)
	tp_box:do_not_release_escape_key(true);

	tp_box:show()

	return tp_box
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

function ui_scripted_tour:find_valid_child_component(parent_component, ignore_component)
	if parent_component then
		for i = 0, parent_component:ChildCount() - 1 do
			local child = find_child_uicomponent_by_index(parent_component, i)
			if child and child:Visible() and child:Id() ~= ignore_component then return child end
		end
	end
	return false
end