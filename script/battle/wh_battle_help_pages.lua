

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	HELP PAGE SCRIPTS
--	Battle help pages are defined here
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function setup_battle_help_pages(bm)

	out.help_pages("");
	out.help_pages("***");
	out.help_pages("*** setup_battle_help_pages() called");
	out.help_pages("***");

	--	Setup link parser
	--	This parses [[sl:link]]text[[/sl]] links in help page records	
	local parser = get_link_parser();	
	
	-- Set up help page to info button mapping
	-- (this is for the ? button on each panel)
	local hpm = get_help_page_manager();
	
	-- first argument is the help page link name, second is a unique parent name of the button (doesn't have to be immediate parent)
	-- optional third argument is a component to test if visible, as it seems that unique parent is not enough of a test >:0(
	--[[
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_army_panel", "main_units_panel");
	]]


	-- battle index page
	hpm:register_hyperlink_click_listener("script_link_battle_index", function() hpm:show_index() end);
	parser:add_record("battle_index", "script_link_battle_index", "tooltip_battle_index");

	local script_feature_name = "";

	-------------------------------------------------------------------------------------------------------------------------
	--
	-- battle contents
	--
	-------------------------------------------------------------------------------------------------------------------------

	hp_contents = help_page:new(
		"script_link_battle_contents",
		hpr_right_aligned("war.battle.hp.contents.001"),

		hpr_section("battle_game"),
		hpr_title("war.battle.hp.contents.002", "battle_game"),
		hpr_image("war.battle.hp.contents.003", "UI/help_images/campaign_game.png", "battle_game"),
		hpr_normal("war.battle.hp.contents.004", "battle_game"),
		hpr_section_index("battle_game", "battle_deployment"),

		hpr_section("battle_interface"),
		hpr_title("war.battle.hp.contents.005", "battle_interface"),
		hpr_image("war.battle.hp.contents.006", "UI/help_images/norsca.png", "battle_interface"),
		hpr_normal("war.battle.hp.contents.007", "battle_interface"),
		hpr_section_index("battle_interface", "battle_camera_controls"),

		hpr_section("armies"),
		hpr_title("war.battle.hp.contents.011", "armies"),
		hpr_image("war.battle.hp.contents.012", "UI/help_images/armies.png", "armies"),
		hpr_normal("war.battle.hp.contents.013", "armies"),
		hpr_section_index("armies", "battle_the_general", "battle_murderous_prowess"),
		hpr_section_index("armies", "battle_murderous_prowess", nil, false, "random_localisation_strings_string_help_pages_expand_racial_mechanics"),

		hpr_section("units"),
		hpr_title("war.battle.hp.contents.014", "units"),
		hpr_image("war.battle.hp.contents.015", "UI/help_images/units.png", "units"),
		hpr_normal("war.battle.hp.contents.016", "units"),
		hpr_section_index("units", "battle_unit_types"),

		hpr_section("siege_battles"),
		hpr_title("war.battle.hp.contents.017", "siege_battles"),
		hpr_image("war.battle.hp.contents.018", "UI/help_images/ogre_camps.png", "siege_battles"),
		hpr_normal("war.battle.hp.contents.019", "siege_battles"),
		hpr_section_index("siege_battles", "battle_minor_settlement_battles")
	);
	parser:add_record("battle_contents", "script_link_battle_contents", "tooltip_battle_contents");
	

	core:add_listener(
		"help_page_show_contents",
		"HelpPageShowContents",
		true,
		function()
			out.ui("***");
			out.ui("***");
			out.ui("***");
			hp_contents:link_clicked();
		end,
		true
	);















	--
	-- advanced_controls
	--
	
	hp_advanced_controls = help_page:new(
		"script_link_battle_advanced_controls",
		hpr_title("war.battle.hp.advanced_controls.001"),
		hpr_leader("war.battle.hp.advanced_controls.002"),
		hpr_normal("war.battle.hp.advanced_controls.003"),
		hpr_normal("war.battle.hp.advanced_controls.004"),
		hpr_normal("war.battle.hp.advanced_controls.005"),
		hpr_normal("war.battle.hp.advanced_controls.006"),
		hpr_normal("war.battle.hp.advanced_controls.007")
	);
	parser:add_record("battle_advanced_controls", "script_link_battle_advanced_controls", "tooltip_battle_advanced_controls");
	tp_advanced_controls = tooltip_patcher:new("tooltip_battle_advanced_controls");
	tp_advanced_controls:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_advanced_controls", "ui_text_replacements_localised_text_hp_battle_description_advanced_controls");
	
	
	
	--
	-- advice_history_buttons
	--

	parser:add_record("battle_advice_history_buttons", "script_link_battle_advice_history_buttons", "tooltip_battle_advice_history_buttons");
	tp_advice_history_buttons = tooltip_patcher:new("tooltip_battle_advice_history_buttons");
	tp_advice_history_buttons:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_advice_history_buttons");
	
	tl_advisor_history_buttons = tooltip_listener:new(
		"tooltip_battle_advice_history_buttons", 
		function() 
			buim:highlight_advice_history_buttons(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);

	
	--
	-- advisor
	--
	
	hp_advisor = help_page:new(
		"script_link_battle_advisor",
		hpr_title("war.battle.hp.advisor.001"),
		hpr_leader("war.battle.hp.advisor.002"),
		hpr_normal("war.battle.hp.advisor.003"),
		hpr_normal("war.battle.hp.advisor.004")
	);
	parser:add_record("battle_advisor", "script_link_battle_advisor", "tooltip_battle_advisor");
	tp_advisor = tooltip_patcher:new("tooltip_battle_advisor");
	tp_advisor:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_advisor", "ui_text_replacements_localised_text_hp_battle_description_advisor");
	
	tl_advisor = tooltip_listener:new(
		"tooltip_battle_advisor", 
		function() 
			buim:highlight_advisor(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- advisor_link
	--
	
	parser:add_record("battle_advisor_link", "script_link_battle_advisor_link", "tooltip_battle_advisor_link");
	tp_advisor_link = tooltip_patcher:new("tooltip_battle_advisor_link");
	tp_advisor_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_title_advisor_link");
	
	tl_advisor_link = tooltip_listener:new(
		"tooltip_battle_advisor_link", 
		function() 
			buim:highlight_advisor(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
		
	

	--
	-- ambush_battles
	--
	
	hp_ambush_battles = help_page:new(
		"script_link_battle_ambush_battles",
		hpr_title("war.battle.hp.ambush_battles.001"),
		hpr_leader("war.battle.hp.ambush_battles.002"),
		hpr_normal("war.battle.hp.ambush_battles.003")
	);
	parser:add_record("battle_ambush_battles", "script_link_battle_ambush_battles", "tooltip_battle_ambush_battles");
	tp_ambush_battles = tooltip_patcher:new("tooltip_battle_ambush_battles");
	tp_ambush_battles:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_ambush_battles", "ui_text_replacements_localised_text_hp_battle_description_ambush_battles");
	
	
	--
	-- armies
	--
	
	hp_armies = help_page:new(
		"script_link_battle_armies",
		hpr_title("war.battle.hp.armies.001"),
		hpr_leader("war.battle.hp.armies.002"),
		hpr_normal("war.battle.hp.armies.003"),
		hpr_normal("war.battle.hp.armies.004"),
		hpr_normal("war.battle.hp.armies.005"),
		hpr_normal("war.battle.hp.armies.006"),
		hpr_normal("war.battle.hp.armies.007")
	);
	parser:add_record("battle_armies", "script_link_battle_armies", "tooltip_battle_armies");
	tp_armies = tooltip_patcher:new("tooltip_battle_armies");
	tp_armies:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_armies", "ui_text_replacements_localised_text_hp_battle_description_armies");


	--
	-- armour
	--
	
	hp_armour = help_page:new(
		"script_link_battle_armour",
		hpr_title("war.battle.hp.armour.001"),
		hpr_leader("war.battle.hp.armour.002"),
		hpr_normal("war.battle.hp.armour.003"),
		hpr_normal("war.battle.hp.armour.004"),
		hpr_normal("war.battle.hp.armour.005"),

		hpr_section("armour_piercing"),
		hpr_normal_unfaded("war.battle.hp.armour.006", "armour_piercing"),
		hpr_normal("war.battle.hp.armour.007", "armour_piercing"),
		hpr_normal("war.battle.hp.armour.008", "armour_piercing"),
		hpr_normal("war.battle.hp.armour.009", "armour_piercing"),
		
		hpr_section("shields"),
		hpr_normal_unfaded("war.battle.hp.armour.010", "armour_piercing"),
		hpr_normal("war.battle.hp.armour.011", "armour_piercing")
	);
	parser:add_record("battle_armour", "script_link_battle_armour", "tooltip_battle_armour");
	tp_armour = tooltip_patcher:new("tooltip_battle_armour");
	tp_armour:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_armour", "ui_text_replacements_localised_text_hp_battle_description_armour");
	
	
	
	
	--
	-- army_abilities
	--
	
	hp_army_abilities = help_page:new(
		"script_link_battle_army_abilities",
		hpr_title("war.battle.hp.army_abilities.001"),
		hpr_leader("war.battle.hp.army_abilities.002"),
		hpr_normal("war.battle.hp.army_abilities.003")
	);
	parser:add_record("battle_army_abilities", "script_link_battle_army_abilities", "tooltip_battle_army_abilities");
	tp_army_abilities = tooltip_patcher:new("tooltip_battle_army_abilities");
	tp_army_abilities:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_army_abilities", "ui_text_replacements_localised_text_hp_battle_description_army_abilities");
	
	tl_army_abilities = tooltip_listener:new(
		"tooltip_battle_army_abilities", 
		function() 
			buim:highlight_army_abilities(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- army_abilities_link
	--
	
	parser:add_record("battle_army_abilities_link", "script_link_battle_army_abilities_link", "tooltip_battle_army_abilities_link");
	tp_army_abilities_link = tooltip_patcher:new("tooltip_battle_army_abilities_link");
	tp_army_abilities_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_army_abilities_title_link");
	
	tl_army_abilities_link = tooltip_listener:new(
		"tooltip_battle_army_abilities_link", 
		function() 
			buim:highlight_army_abilities(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- army_abilities_panel
	--
	
	parser:add_record("battle_army_abilities_panel", "script_link_battle_army_abilities_panel", "tooltip_battle_army_abilities_panel");
	tp_army_abilities_panel = tooltip_patcher:new("tooltip_battle_army_abilities_panel");
	tp_army_abilities_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_description_army_abilities_panel");
	
	tl_army_abilities_panel = tooltip_listener:new(
		"tooltip_battle_army_abilities_panel", 
		function() 
			buim:highlight_army_abilities(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- army_panel
	--

	parser:add_record("battle_army_panel", "script_link_battle_army_panel", "tooltip_battle_army_panel");
	tp_army_panel = tooltip_patcher:new("tooltip_battle_army_panel");
	tp_army_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_title_bottom_panel");
	
	tl_army_panel = tooltip_listener:new(
		"tooltip_battle_army_panel", 
		function() 
			buim:highlight_army_panel(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- artillery
	--
	
	hp_artillery = help_page:new(
		"script_link_battle_artillery",
		hpr_title("war.battle.hp.artillery.001"),
		hpr_leader("war.battle.hp.artillery.002"),
		hpr_normal("war.battle.hp.artillery.003"),
		hpr_normal("war.battle.hp.artillery.004"),
		hpr_normal("war.battle.hp.artillery.005")
	);
	parser:add_record("battle_artillery", "script_link_battle_artillery", "tooltip_battle_artillery");
	tp_artillery = tooltip_patcher:new("tooltip_battle_artillery");
	tp_artillery:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_artillery", "ui_text_replacements_localised_text_hp_battle_description_artillery");
	
	
	
	--
	-- balance_of_power
	--

	parser:add_record("battle_balance_of_power", "script_link_battle_balance_of_power", "tooltip_battle_balance_of_power");
	tp_balance_of_power = tooltip_patcher:new("tooltip_battle_balance_of_power");
	tp_balance_of_power:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_title_top_item");
	
	tl_balance_of_power = tooltip_listener:new(
		"tooltip_battle_balance_of_power", 
		function() 
			buim:highlight_balance_of_power(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);

	

	--
	-- battle_game
	--
	
	hp_battle_game = help_page:new(
		"script_link_battle_battle_game",
		hpr_title("war.battle.hp.battle_game.001"),
		hpr_leader("war.battle.hp.battle_game.002"),
		hpr_normal("war.battle.hp.battle_game.003"),
		hpr_normal("war.battle.hp.battle_game.004"),
		hpr_normal("war.battle.hp.battle_game.005"),
		hpr_normal("war.battle.hp.battle_game.006"),
		hpr_normal("war.battle.hp.battle_game.007")
	);
	parser:add_record("battle_battle_game", "script_link_battle_battle_game", "tooltip_battle_battle_game");
	tp_battle_game = tooltip_patcher:new("tooltip_battle_battle_game");
	tp_battle_game:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_battle_game", "ui_text_replacements_localised_text_hp_battle_description_battle_game");
	
	
	

	--
	-- battle_interface
	--
	
	hp_battle_interface = help_page:new(
		"script_link_battle_battle_interface",
		hpr_title("war.battle.hp.battle_interface.001"),
		hpr_leader("war.battle.hp.battle_interface.002"),
		hpr_normal("war.battle.hp.battle_interface.003"),
		hpr_normal("war.battle.hp.battle_interface.004"),
		hpr_normal("war.battle.hp.battle_interface.005"),
		hpr_normal("war.battle.hp.battle_interface.006"),
		hpr_normal("war.battle.hp.battle_interface.007")
	);
	parser:add_record("battle_battle_interface", "script_link_battle_battle_interface", "tooltip_battle_battle_interface");
	tp_battle_interface = tooltip_patcher:new("tooltip_battle_battle_interface");
	tp_battle_interface:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_battle_interface", "ui_text_replacements_localised_text_hp_battle_description_battle_interface");
	


	--
	-- blood_for_the_blood_god
	--
	
	hp_blood_for_the_blood_god = help_page:new(
		"script_link_battle_blood_for_the_blood_god",
		hpr_title("war.battle.hp.blood_for_the_blood_god.001"),
		hpr_leader("war.battle.hp.blood_for_the_blood_god.002"),
		hpr_normal("war.battle.hp.blood_for_the_blood_god.003"),
		hpr_normal("war.battle.hp.blood_for_the_blood_god.004"),
		hpr_normal("war.battle.hp.blood_for_the_blood_god.005")
	);
	parser:add_record("battle_blood_for_the_blood_god", "script_link_battle_blood_for_the_blood_god", "tooltip_battle_blood_for_the_blood_god");
	tp_blood_for_the_blood_god = tooltip_patcher:new("tooltip_battle_blood_for_the_blood_god");
	tp_blood_for_the_blood_god:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_blood_for_the_blood_god", "ui_text_replacements_localised_text_hp_battle_description_blood_for_the_blood_god");

	tp_blood_for_the_blood_god = tooltip_listener:new(
		"tooltip_battle_blood_for_the_blood_god",
		function()
			buim:highlight_army_abilities(true);
		end,
		function()
			buim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- blood_for_the_blood_god_link
	--
	script_feature_name = "blood_for_the_blood_god";
	parser:add_record("battle_"..script_feature_name.."_link", "script_link_battle_"..script_feature_name.."_link", "tooltip_battle_"..script_feature_name.."_link");
	tp_blood_for_the_blood_god_link = tooltip_patcher:new("tooltip_battle_"..script_feature_name.."_link");
	tp_blood_for_the_blood_god_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_title_"..script_feature_name.."_link");

	tl_blood_for_the_blood_god_link = tooltip_listener:new(
		"tooltip_battle_"..script_feature_name.."_link",
		function() 
			buim:highlight_army_abilities(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- blood_for_the_blood_god_meter
	--

	parser:add_record("battle_blood_for_the_blood_god_meter", "script_link_battle_blood_for_the_blood_god_meter", "tooltip_battle_blood_for_the_blood_god_meter");
	tp_blood_for_the_blood_god_meter = tooltip_patcher:new("tooltip_battle_blood_for_the_blood_god_meter");
	tp_blood_for_the_blood_god_meter:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_description_blood_for_the_blood_god_meter");

	tp_blood_for_the_blood_god_meter = tooltip_listener:new(
		"tooltip_battle_blood_for_the_blood_god_meter",
		function()
			buim:highlight_army_abilities_meter(true);
		end,
		function()
			buim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- camera_controls
	--
	
	hp_camera_controls = help_page:new(
		"script_link_battle_camera_controls",
		hpr_title("war.battle.hp.camera_controls.001"),
		hpr_battle_camera_controls("war.battle.hp.camera_controls.003"),
		hpr_battle_camera_facing_controls("war.battle.hp.camera_controls.004"),
		hpr_battle_camera_altitude_controls("war.battle.hp.camera_controls.005"),
		hpr_battle_camera_speed_controls("war.battle.hp.camera_controls.006"),
		hpr_normal("war.battle.hp.camera_controls.007")
	);
	parser:add_record("battle_camera_controls", "script_link_battle_camera_controls", "tooltip_battle_camera_controls");
	tp_camera_controls = tooltip_patcher:new("tooltip_battle_camera_controls");
	tp_camera_controls:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_camera_controls", "ui_text_replacements_localised_text_hp_battle_description_camera_controls");
	


	--
	-- capture_location_icons
	--
	
	parser:add_record("battle_capture_location_icons", "script_link_battle_capture_location_icons", "tooltip_battle_capture_location_icons");
	tp_capture_location_icons = tooltip_patcher:new("tooltip_battle_capture_location_icons");
	tp_capture_location_icons:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_description_capture_location_icons");
	
	tl_capture_location_icons = tooltip_listener:new(
		"tooltip_battle_capture_location_icons", 
		function() 
			buim:highlight_victory_locations(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- capture_locations
	--
	
	hp_capture_locations = help_page:new(
		"script_link_battle_capture_locations",
		hpr_title("war.battle.hp.capture_locations.001"),
		hpr_leader("war.battle.hp.capture_locations.002"),

		hpr_section("gates"),
		hpr_normal_unfaded("war.battle.hp.capture_locations.003", "gates"),
		hpr_normal("war.battle.hp.capture_locations.004", "gates"),
		
		hpr_section("supply_locations"),
		hpr_normal_unfaded("war.battle.hp.capture_locations.005", "supply_locations"),
		hpr_normal("war.battle.hp.capture_locations.006", "supply_locations"),
		hpr_normal("war.battle.hp.capture_locations.007", "supply_locations"),
		hpr_normal("war.battle.hp.capture_locations.015", "supply_locations"),

		hpr_section("victory_locations"),
		hpr_normal_unfaded("war.battle.hp.capture_locations.008", "victory_locations"),
		hpr_normal("war.battle.hp.capture_locations.009", "victory_locations"),
		hpr_normal("war.battle.hp.capture_locations.010", "victory_locations"),

		hpr_section("capturing"),
		hpr_normal_unfaded("war.battle.hp.capture_locations.011", "capturing"),
		hpr_normal("war.battle.hp.capture_locations.012", "capturing"),
		hpr_normal("war.battle.hp.capture_locations.013", "capturing"),
		hpr_normal("war.battle.hp.capture_locations.014", "capturing")
	);
	parser:add_record("battle_capture_locations", "script_link_battle_capture_locations", "tooltip_battle_capture_locations");
	tp_capture_locations = tooltip_patcher:new("tooltip_battle_capture_locations");
	tp_capture_locations:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_capture_locations", "ui_text_replacements_localised_text_hp_battle_description_capture_locations");



	--
	-- capture_locations_link
	--
	script_feature_name = "capture_locations";
	parser:add_record("battle_"..script_feature_name.."_link", "script_link_battle_"..script_feature_name.."_link", "tooltip_battle_"..script_feature_name.."_link");
	tp_capture_locations_link = tooltip_patcher:new("tooltip_battle_"..script_feature_name.."_link");
	tp_capture_locations_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_title_"..script_feature_name.."_link");

	tl_capture_locations_link = tooltip_listener:new(
		"tooltip_battle_"..script_feature_name.."_link",
		function()
			buim:highlight_victory_locations(true);
		end,
		function()
			buim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- constructed_defences
	--
	
	hp_constructed_defences = help_page:new(
		"script_link_battle_constructed_defences",
		hpr_title("war.battle.hp.constructed_defences.001"),
		hpr_leader("war.battle.hp.constructed_defences.002"),
		hpr_normal("war.battle.hp.constructed_defences.003"),
		hpr_normal("war.battle.hp.constructed_defences.004"),
		hpr_normal("war.battle.hp.constructed_defences.005")
	);
	parser:add_record("battle_constructed_defences", "script_link_battle_constructed_defences", "tooltip_battle_constructed_defences");
	tp_constructed_defences = tooltip_patcher:new("tooltip_battle_constructed_defences");
	tp_constructed_defences:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_constructed_defences", "ui_text_replacements_localised_text_hp_battle_description_constructed_defences");



	--
	-- controls_cheat_sheet
	--
	
	hp_controls_cheat_sheet = help_page:new(
		"script_link_battle_controls_cheat_sheet",
		hpr_title("war.battle.hp.controls_cheat_sheet.001"),
		hpr_battle_camera_controls("war.battle.hp.controls_cheat_sheet.002"),
		hpr_battle_camera_facing_controls("war.battle.hp.controls_cheat_sheet.003"),
		hpr_battle_camera_altitude_controls("war.battle.hp.controls_cheat_sheet.004")
		
		--[[
		hpr_battle_camera_speed_controls("war.battle.hp.controls_cheat_sheet.005")
		hpr_title("war.battle.hp.controls_cheat_sheet.006"),
		hpr_battle_selection_controls("war.battle.hp.controls_cheat_sheet.007"),
		hpr_battle_multiple_selection_controls("war.battle.hp.controls_cheat_sheet.008"),
		hpr_title("war.battle.hp.controls_cheat_sheet.009"),
		hpr_battle_movement_controls("war.battle.hp.controls_cheat_sheet.010"),
		hpr_battle_drag_out_formation_controls("war.battle.hp.controls_cheat_sheet.011"),
		hpr_battle_unit_destination_controls("war.battle.hp.controls_cheat_sheet.012"),
		hpr_battle_halt_controls("war.battle.hp.controls_cheat_sheet.013"),
		hpr_battle_attack_controls("war.battle.hp.controls_cheat_sheet.014")
		]]
	);
	parser:add_record("battle_controls_cheat_sheet", "script_link_battle_controls_cheat_sheet", "tooltip_battle_controls_cheat_sheet");
	-- tp_controls_cheat_sheet = tooltip_patcher:new("tooltip_battle_controls_cheat_sheet");
	-- tp_controls_cheat_sheet:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_controls_cheat_sheet", "ui_text_replacements_localised_text_hp_battle_description_controls_cheat_sheet");



	--
	-- deployment
	--
	
	hp_deployment = help_page:new(
		"script_link_battle_deployment",
		hpr_title("war.battle.hp.deployment.001"),
		hpr_leader("war.battle.hp.deployment.002"),
		hpr_normal("war.battle.hp.deployment.003"),
		hpr_normal("war.battle.hp.deployment.004"),
		hpr_normal("war.battle.hp.deployment.005"),
		hpr_normal("war.battle.hp.deployment.006")
	);
	parser:add_record("battle_deployment", "script_link_battle_deployment", "tooltip_battle_deployment");
	tp_deployment = tooltip_patcher:new("tooltip_battle_deployment");
	tp_deployment:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_deployment", "ui_text_replacements_localised_text_hp_battle_description_deployment");



	--
	-- dragon_transformation
	--
	
	hp_dragon_transformation = help_page:new(
		"script_link_battle_dragon_transformation",
		hpr_title("war.battle.hp.dragon_transformation.001"),
		hpr_leader("war.battle.hp.dragon_transformation.002"),
		hpr_normal("war.battle.hp.dragon_transformation.003"),
		hpr_normal("war.battle.hp.dragon_transformation.004")
	);
	parser:add_record("battle_dragon_transformation", "script_link_battle_dragon_transformation", "tooltip_battle_dragon_transformation");
	tp_dragon_transformation = tooltip_patcher:new("tooltip_battle_dragon_transformation");
	tp_dragon_transformation:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_dragon_transformation", "ui_text_replacements_localised_text_hp_battle_description_dragon_transformation");
	
	
	
	--
	-- drop_equipment_button
	--

	parser:add_record("battle_drop_equipment_button", "script_link_battle_drop_equipment_button", "tooltip_battle_drop_equipment_button");
	tp_drop_equipment_button = tooltip_patcher:new("tooltip_battle_drop_equipment_button");
	tp_drop_equipment_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_description_drop_siege_equipment_button");
	
	tl_drop_equipment_button = tooltip_listener:new(
		"tooltip_battle_drop_equipment_button", 
		function() 
			buim:highlight_drop_equipment_button(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	
	--
	-- extra_powder
	--
	
	hp_extra_powder = help_page:new(
		"script_link_battle_extra_powder",
		hpr_title("war.battle.hp.extra_powder.001"),
		hpr_leader("war.battle.hp.extra_powder.002"),
		hpr_normal("war.battle.hp.extra_powder.003"),
		hpr_normal("war.battle.hp.extra_powder.004"),
		hpr_normal("war.battle.hp.extra_powder.005")
	);
	parser:add_record("battle_extra_powder", "script_link_battle_extra_powder", "tooltip_battle_extra_powder");
	tp_extra_powder = tooltip_patcher:new("tooltip_battle_extra_powder");
	tp_extra_powder:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_extra_powder", "ui_text_replacements_localised_text_hp_battle_description_extra_powder");


	--
	-- eye_of_tzeentch
	--
	
	hp_eye_of_tzeentch = help_page:new(
		"script_link_battle_eye_of_tzeentch",
		hpr_title("war.battle.hp.eye_of_tzeentch.001"),
		hpr_leader("war.battle.hp.eye_of_tzeentch.002"),
		hpr_normal("war.battle.hp.eye_of_tzeentch.003"),
		hpr_normal("war.battle.hp.eye_of_tzeentch.004"),
		hpr_normal("war.battle.hp.eye_of_tzeentch.005")
	);
	parser:add_record("battle_eye_of_tzeentch", "script_link_battle_eye_of_tzeentch", "tooltip_battle_eye_of_tzeentch");
	tp_eye_of_tzeentch = tooltip_patcher:new("tooltip_battle_eye_of_tzeentch");
	tp_eye_of_tzeentch:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_eye_of_tzeentch", "ui_text_replacements_localised_text_hp_battle_description_eye_of_tzeentch");

	tp_eye_of_tzeentch = tooltip_listener:new(
		"tooltip_battle_eye_of_tzeentch", 
		function()
			buim:highlight_army_abilities(true);
		end,
		function()
			buim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- eye_of_tzeentch_link
	--
	script_feature_name = "eye_of_tzeentch";
	parser:add_record("battle_"..script_feature_name.."_link", "script_link_battle_"..script_feature_name.."_link", "tooltip_battle_"..script_feature_name.."_link");
	tp_eye_of_tzeentch_link = tooltip_patcher:new("tooltip_battle_"..script_feature_name.."_link");
	tp_eye_of_tzeentch_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_title_"..script_feature_name.."_link");

	tl_eye_of_tzeentch_link = tooltip_listener:new(
		"tooltip_battle_"..script_feature_name.."_link",
		function()
			buim:highlight_army_abilities(true);
		end,
		function()
			buim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- eye_of_tzeentch_meter
	--
	
	parser:add_record("battle_eye_of_tzeentch_meter", "script_link_battle_eye_of_tzeentch_meter", "tooltip_battle_eye_of_tzeentch_meter");
	tp_eye_of_tzeentch_meter = tooltip_patcher:new("tooltip_battle_eye_of_tzeentch_meter");
	tp_eye_of_tzeentch_meter:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_description_eye_of_tzeentch_meter");

	tp_eye_of_tzeentch_meter = tooltip_listener:new(
		"tooltip_battle_eye_of_tzeentch_meter", 
		function() 
			buim:highlight_army_abilities_meter(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);

	
	--
	-- fire_at_will
	--
	
	hp_fire_at_will = help_page:new(
		"script_link_battle_fire_at_will",
		hpr_title("war.battle.hp.fire_at_will.001"),
		hpr_leader("war.battle.hp.fire_at_will.002"),
		hpr_normal("war.battle.hp.fire_at_will.003"),
		hpr_normal("war.battle.hp.fire_at_will.004")
	);
	parser:add_record("battle_fire_at_will", "script_link_battle_fire_at_will", "tooltip_battle_fire_at_will");
	tp_fire_at_will = tooltip_patcher:new("tooltip_battle_fire_at_will");
	tp_fire_at_will:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_fire_at_will", "ui_text_replacements_localised_text_hp_battle_description_fire_at_will");
	
	tl_fire_at_will = tooltip_listener:new(
		"tooltip_battle_fire_at_will", 
		function() 
			buim:highlight_fire_at_will_button(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- fire_at_will_link
	--
	
	parser:add_record("battle_fire_at_will_link", "script_link_battle_fire_at_will_link", "tooltip_battle_fire_at_will_link");
	tp_fire_at_will_link = tooltip_patcher:new("tooltip_battle_fire_at_will_link");
	tp_fire_at_will_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_title_fire_at_will_link");
	
	tl_fire_at_will_link = tooltip_listener:new(
		"tooltip_battle_fire_at_will_link", 
		function() 
			buim:highlight_fire_at_will_button(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- fire_at_will_button
	--

	parser:add_record("battle_fire_at_will_button", "script_link_battle_fire_at_will_button", "tooltip_battle_fire_at_will_button");
	tp_fire_at_will_button = tooltip_patcher:new("tooltip_battle_fire_at_will_button");
	tp_fire_at_will_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_description_fire_at_will_button");
	
	tl_fire_at_will_button = tooltip_listener:new(
		"tooltip_battle_fire_at_will_button", 
		function() 
			buim:highlight_fire_at_will_button(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	

	--
	-- flanking
	--
	
	hp_flanking = help_page:new(
		"script_link_battle_flanking",
		hpr_title("war.battle.hp.flanking.001"),
		hpr_leader("war.battle.hp.flanking.002"),
		hpr_normal("war.battle.hp.flanking.003"),
		hpr_normal("war.battle.hp.flanking.004")
	);
	parser:add_record("battle_flanking", "script_link_battle_flanking", "tooltip_battle_flanking");
	tp_flanking = tooltip_patcher:new("tooltip_battle_flanking");
	tp_flanking:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_flanking", "ui_text_replacements_localised_text_hp_battle_description_flanking");
	
	
	
	--
	-- flying_units
	--
	
	hp_flying_units = help_page:new(
		"script_link_battle_flying_units",
		hpr_title("war.battle.hp.flying_units.001"),
		hpr_leader("war.battle.hp.flying_units.002"),
		hpr_normal("war.battle.hp.flying_units.003"),
		hpr_normal("war.battle.hp.flying_units.004"),
		hpr_normal("war.battle.hp.flying_units.005"),
		hpr_normal("war.battle.hp.flying_units.006")
	);
	parser:add_record("battle_flying_units", "script_link_battle_flying_units", "tooltip_battle_flying_units");
	tp_flying_units = tooltip_patcher:new("tooltip_battle_flying_units");
	tp_flying_units:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_flying_units", "ui_text_replacements_localised_text_hp_battle_description_flying_units");
	
	
	
	--
	-- formations
	--
	
	hp_formations = help_page:new(
		"script_link_battle_formations",
		hpr_title("war.battle.hp.formations.001"),
		hpr_leader("war.battle.hp.formations.002"),
		hpr_normal("war.battle.hp.formations.003"),
		hpr_normal("war.battle.hp.formations.004"),
		hpr_normal("war.battle.hp.formations.005")
	);
	parser:add_record("battle_formations", "script_link_battle_formations", "tooltip_battle_formations");
	tp_formations = tooltip_patcher:new("tooltip_battle_formations");
	tp_formations:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_formations", "ui_text_replacements_localised_text_hp_battle_description_formations");
	
	tl_formations = tooltip_listener:new(
		"tooltip_battle_formations", 
		function() 
			buim:highlight_formations_button(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- formations_link
	--
	
	parser:add_record("battle_formations_link", "script_link_battle_formations_link", "tooltip_battle_formations_link");
	tp_formations_link = tooltip_patcher:new("tooltip_battle_formations_link");
	tp_formations_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_title_formations_link");
	
	tl_formations_link = tooltip_listener:new(
		"tooltip_battle_formations_link", 
		function() 
			buim:highlight_formations_button(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
		
	
	
	--
	-- formations_button
	--

	parser:add_record("battle_formations_button", "script_link_battle_formations_button", "tooltip_battle_formations_button");
	tp_formations_button = tooltip_patcher:new("tooltip_battle_formations_button");
	tp_formations_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_description_formations_button");
	
	tl_formations_button = tooltip_listener:new(
		"tooltip_battle_formations_button", 
		function() 
			buim:highlight_formations_button(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- gates
	--
	
	hp_gates = help_page:new(
		"script_link_battle_gates",
		hpr_title("war.battle.hp.gates.001"),
		hpr_leader("war.battle.hp.gates.002"),
		hpr_normal("war.battle.hp.gates.003"),
		hpr_normal("war.battle.hp.gates.004"),
		hpr_normal("war.battle.hp.gates.005")
	);
	parser:add_record("battle_gates", "script_link_battle_gates", "tooltip_battle_gates");
	tp_gates = tooltip_patcher:new("tooltip_battle_gates");
	tp_gates:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_gates", "ui_text_replacements_localised_text_hp_battle_description_gates");
	

	
	--
	-- grouping
	--
	
	hp_grouping = help_page:new(
		"script_link_battle_grouping",
		hpr_title("war.battle.hp.grouping.001"),
		hpr_leader("war.battle.hp.grouping.002"),
		hpr_normal("war.battle.hp.grouping.003"),
		hpr_normal("war.battle.hp.grouping.004"),
		hpr_normal("war.battle.hp.grouping.005"),
		hpr_normal("war.battle.hp.grouping.006")
	);
	parser:add_record("battle_grouping", "script_link_battle_grouping", "tooltip_battle_grouping");
	tp_grouping = tooltip_patcher:new("tooltip_battle_grouping");
	tp_grouping:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_grouping", "ui_text_replacements_localised_text_hp_battle_description_grouping");
	
	tl_grouping = tooltip_listener:new(
		"tooltip_battle_grouping", 
		function() 
			buim:highlight_group_button(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- grouping_link
	--
	
	parser:add_record("battle_grouping_link", "script_link_battle_grouping_link", "tooltip_battle_grouping_link");
	tp_grouping_link = tooltip_patcher:new("tooltip_battle_grouping_link");
	tp_grouping_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_title_grouping_link");
	
	tl_grouping_link = tooltip_listener:new(
		"tooltip_battle_grouping_link", 
		function() 
			buim:highlight_group_button(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- group_button
	--

	parser:add_record("battle_group_button", "script_link_battle_group_button", "tooltip_battle_group_button");
	tp_group_button = tooltip_patcher:new("tooltip_battle_group_button");
	tp_group_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_description_group_button");
	
	tl_group_button = tooltip_listener:new(
		"tooltip_battle_group_button", 
		function() 
			buim:highlight_group_button(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- guard_button
	--

	parser:add_record("battle_guard_button", "script_link_battle_guard_button", "tooltip_battle_guard_button");
	tp_guard_button = tooltip_patcher:new("tooltip_battle_guard_button");
	tp_guard_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_description_guard_button");
	
	tl_guard_button = tooltip_listener:new(
		"tooltip_battle_guard_button", 
		function() 
			buim:highlight_guard_button(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- harmony
	--
	
	hp_harmony = help_page:new(
		"script_link_battle_harmony",
		hpr_title("war.battle.hp.harmony.001"),
		hpr_leader("war.battle.hp.harmony.002"),
		hpr_normal("war.battle.hp.harmony.003"),
		hpr_normal("war.battle.hp.harmony.004"),
		hpr_normal("war.battle.hp.harmony.005")
	);
	parser:add_record("battle_harmony", "script_link_battle_harmony", "tooltip_battle_harmony");
	tp_harmony = tooltip_patcher:new("tooltip_battle_harmony");
	tp_harmony:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_harmony", "ui_text_replacements_localised_text_hp_battle_description_harmony");


	
	--
	-- infantry
	--
	
	hp_infantry = help_page:new(
		"script_link_battle_infantry",
		hpr_title("war.battle.hp.infantry.001"),
		hpr_leader("war.battle.hp.infantry.002"),
		hpr_normal("war.battle.hp.infantry.003"),
		hpr_normal("war.battle.hp.infantry.004"),
		hpr_normal("war.battle.hp.infantry.005"),
		hpr_normal("war.battle.hp.infantry.006")
	);
	parser:add_record("battle_infantry", "script_link_battle_infantry", "tooltip_battle_infantry");
	tp_infantry = tooltip_patcher:new("tooltip_battle_infantry");
	tp_infantry:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_infantry", "ui_text_replacements_localised_text_hp_battle_description_infantry");
	
	
	
	--
	-- leadership
	--
	
	hp_leadership = help_page:new(
		"script_link_battle_leadership",
		hpr_title("war.battle.hp.leadership.001"),
		hpr_leader("war.battle.hp.leadership.002"),
		hpr_normal("war.battle.hp.leadership.003"),
		hpr_normal("war.battle.hp.leadership.004"),
		hpr_normal("war.battle.hp.leadership.005"),
		hpr_normal("war.battle.hp.leadership.006"),
		hpr_normal("war.battle.hp.leadership.007")
	);
	parser:add_record("battle_leadership", "script_link_battle_leadership", "tooltip_battle_leadership");
	tp_leadership = tooltip_patcher:new("tooltip_battle_leadership");
	tp_leadership:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_leadership", "ui_text_replacements_localised_text_hp_battle_description_leadership");
	
	
	
	--
	-- lore_panel
	--

	parser:add_record("battle_lore_panel", "script_link_battle_lore_panel", "tooltip_battle_lore_panel");
	tp_lore_panel = tooltip_patcher:new("tooltip_battle_lore_panel");
	tp_lore_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_title_lore_panel");
	
	tl_lore_panel = tooltip_listener:new(
		"tooltip_battle_lore_panel", 
		function() 
			buim:highlight_lore_panel(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- magic_barriers
	--
	
	hp_magic_barriers = help_page:new(
		"script_link_battle_magic_barriers",
		hpr_title("war.battle.hp.magic_barriers.001"),
		hpr_leader("war.battle.hp.magic_barriers.002"),
		hpr_normal("war.battle.hp.magic_barriers.003"),
		hpr_normal("war.battle.hp.magic_barriers.004"),
		hpr_normal("war.battle.hp.magic_barriers.005")
	);
	parser:add_record("battle_magic_barriers", "script_link_battle_magic_barriers", "tooltip_battle_magic_barriers");
	tp_magic_barriers = tooltip_patcher:new("tooltip_battle_magic_barriers");
	tp_magic_barriers:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_magic_barriers", "ui_text_replacements_localised_text_hp_battle_description_magic_barriers");


	--
	-- major_siege_battles
	--
	
	hp_major_siege_battles = help_page:new(
		"script_link_battle_major_siege_battles",
		hpr_title("war.battle.hp.major_siege_battles.001"),
		hpr_leader("war.battle.hp.major_siege_battles.002"),
		hpr_normal("war.battle.hp.major_siege_battles.003"),

		hpr_section("attacking"),
		hpr_normal_unfaded("war.battle.hp.major_siege_battles.004", "attacking"),
		hpr_normal("war.battle.hp.major_siege_battles.005", "attacking"),
		hpr_normal("war.battle.hp.major_siege_battles.006", "attacking"),
		hpr_normal("war.battle.hp.major_siege_battles.007", "attacking"),
		hpr_normal("war.battle.hp.major_siege_battles.008", "attacking"),
		
		hpr_section("defending"),
		hpr_normal_unfaded("war.battle.hp.major_siege_battles.009", "defending"),
		hpr_normal("war.battle.hp.major_siege_battles.010", "defending"),
		hpr_normal("war.battle.hp.major_siege_battles.011", "defending"),
		hpr_normal("war.battle.hp.major_siege_battles.012", "defending"),
		hpr_normal("war.battle.hp.major_siege_battles.013", "defending"),
		hpr_normal("war.battle.hp.major_siege_battles.014", "defending"),

		hpr_normal("war.battle.hp.major_siege_battles.015"),
		hpr_normal("war.battle.hp.major_siege_battles.016")
	);
	parser:add_record("battle_major_siege_battles", "script_link_battle_major_siege_battles", "tooltip_battle_major_siege_battles");
	tp_major_siege_battles = tooltip_patcher:new("tooltip_battle_major_siege_battles");
	tp_major_siege_battles:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_major_siege_battles", "ui_text_replacements_localised_text_hp_battle_description_major_siege_battles");



	--
	-- mastery_of_the_elemental_winds
	--
	
	hp_mastery_of_the_elemental_winds = help_page:new(
		"script_link_battle_mastery_of_the_elemental_winds",
		hpr_title("war.battle.hp.mastery_of_the_elemental_winds.001"),
		hpr_leader("war.battle.hp.mastery_of_the_elemental_winds.002"),
		hpr_normal("war.battle.hp.mastery_of_the_elemental_winds.003")
	);
	parser:add_record("battle_mastery_of_the_elemental_winds", "script_link_battle_mastery_of_the_elemental_winds", "tooltip_battle_mastery_of_the_elemental_winds");
	tp_mastery_of_the_elemental_winds = tooltip_patcher:new("tooltip_battle_mastery_of_the_elemental_winds");
	tp_mastery_of_the_elemental_winds:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_mastery_of_the_elemental_winds", "ui_text_replacements_localised_text_hp_battle_description_mastery_of_the_elemental_winds");



	--
	-- melee_combat
	--
	
	hp_melee_combat = help_page:new(
		"script_link_battle_melee_combat",
		hpr_title("war.battle.hp.melee_combat.001"),
		hpr_leader("war.battle.hp.melee_combat.002"),

		hpr_section("panel"),
		hpr_normal_unfaded("war.battle.hp.melee_combat.003", "panel"),
		hpr_normal("war.battle.hp.melee_combat.004", "panel"),
		
		hpr_section("armour"),
		hpr_normal_unfaded("war.battle.hp.melee_combat.005", "armour"),
		hpr_normal("war.battle.hp.melee_combat.006", "armour"),
		
		hpr_section("weapon_strength"),
		hpr_normal_unfaded("war.battle.hp.melee_combat.007", "weapon_strength"),
		hpr_normal("war.battle.hp.melee_combat.008", "weapon_strength"),
		hpr_normal("war.battle.hp.melee_combat.009", "weapon_strength"),
		
		hpr_section("melee_attack"),
		hpr_normal_unfaded("war.battle.hp.melee_combat.010", "melee_attack"),
		hpr_normal("war.battle.hp.melee_combat.011", "melee_attack"),
		hpr_normal("war.battle.hp.melee_combat.012", "melee_attack"),

		hpr_section("charging"),
		hpr_normal_unfaded("war.battle.hp.melee_combat.013", "charging"),
		hpr_normal("war.battle.hp.melee_combat.014", "charging")
	);
	parser:add_record("battle_melee_combat", "script_link_battle_melee_combat", "tooltip_battle_melee_combat");
	tp_melee_combat = tooltip_patcher:new("tooltip_battle_melee_combat");
	tp_melee_combat:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_melee_combat", "ui_text_replacements_localised_text_hp_battle_description_melee_combat");
		
	
	
	--
	-- melee_mode_button
	--

	parser:add_record("battle_melee_mode_button", "script_link_battle_melee_mode_button", "tooltip_battle_melee_mode_button");
	tp_melee_mode_button = tooltip_patcher:new("tooltip_battle_melee_mode_button");
	tp_melee_mode_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_description_melee_mode_button");
	
	tl_melee_mode_button = tooltip_listener:new(
		"tooltip_battle_melee_mode_button", 
		function() 
			buim:highlight_melee_mode_button(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- minor_settlement_battles
	--
	
	hp_minor_settlement_battles = help_page:new(
		"script_link_battle_minor_settlement_battles",
		hpr_title("war.battle.hp.minor_settlement_battles.001"),
		hpr_leader("war.battle.hp.minor_settlement_battles.002"),
		hpr_normal("war.battle.hp.minor_settlement_battles.003"),
		hpr_normal("war.battle.hp.minor_settlement_battles.004"),
		hpr_normal("war.battle.hp.minor_settlement_battles.005")
	);
	parser:add_record("battle_minor_settlement_battles", "script_link_battle_minor_settlement_battles", "tooltip_battle_minor_settlement_battles");
	tp_minor_settlement_battles = tooltip_patcher:new("tooltip_battle_minor_settlement_battles");
	tp_minor_settlement_battles:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_minor_settlement_battles", "ui_text_replacements_localised_text_hp_battle_description_minor_settlement_battles");

	
	
	--
	-- missile_units
	--
	
	hp_missile_units = help_page:new(
		"script_link_battle_missile_units",
		hpr_title("war.battle.hp.missile_units.001"),
		hpr_leader("war.battle.hp.missile_units.002"),
		hpr_normal("war.battle.hp.missile_units.003"),
		hpr_normal("war.battle.hp.missile_units.004"),
		hpr_normal("war.battle.hp.missile_units.005"),
		hpr_normal("war.battle.hp.missile_units.006")
	);
	parser:add_record("battle_missile_units", "script_link_battle_missile_units", "tooltip_battle_missile_units");
	tp_missile_units = tooltip_patcher:new("tooltip_battle_missile_units");
	tp_missile_units:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_missile_units", "ui_text_replacements_localised_text_hp_battle_description_missile_units");
	
	

	--
	-- monsters
	--
	
	hp_monsters = help_page:new(
		"script_link_battle_monsters",
		hpr_title("war.battle.hp.monsters.001"),
		hpr_leader("war.battle.hp.monsters.002"),
		hpr_normal("war.battle.hp.monsters.003"),
		hpr_normal("war.battle.hp.monsters.004")
	);
	parser:add_record("battle_monsters", "script_link_battle_monsters", "tooltip_battle_monsters");
	tp_monsters = tooltip_patcher:new("tooltip_battle_monsters");
	tp_monsters:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_monsters", "ui_text_replacements_localised_text_hp_battle_description_monsters");
	
	
	
	--
	-- mounted_units
	--
	
	hp_mounted_units = help_page:new(
		"script_link_battle_mounted_units",
		hpr_title("war.battle.hp.mounted_units.001"),
		hpr_leader("war.battle.hp.mounted_units.002"),
		hpr_normal("war.battle.hp.mounted_units.003"),
		hpr_normal("war.battle.hp.mounted_units.004"),
		hpr_normal("war.battle.hp.mounted_units.005"),
		hpr_normal("war.battle.hp.mounted_units.006")
	);
	parser:add_record("battle_mounted_units", "script_link_battle_mounted_units", "tooltip_battle_mounted_units");
	tp_mounted_units = tooltip_patcher:new("tooltip_battle_mounted_units");
	tp_mounted_units:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_mounted_units", "ui_text_replacements_localised_text_hp_battle_description_mounted_units");
	
	
	
	--
	-- murderous_prowess
	--
	
	hp_murderous_prowess = help_page:new(
		"script_link_battle_murderous_prowess",
		hpr_title("war.battle.hp.murderous_prowess.001"),
		hpr_leader("war.battle.hp.murderous_prowess.002"),
		hpr_normal("war.battle.hp.murderous_prowess.003")
	);
	parser:add_record("battle_murderous_prowess", "script_link_battle_murderous_prowess", "tooltip_battle_murderous_prowess");
	tp_murderous_prowess = tooltip_patcher:new("tooltip_battle_murderous_prowess");
	tp_murderous_prowess:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_murderous_prowess", "ui_text_replacements_localised_text_hp_battle_description_murderous_prowess");



	--
	-- plague_lords_blessings
	--

	hp_plague_lords_blessings = help_page:new(
		"script_link_battle_plague_lords_blessings",
		hpr_title("war.battle.hp.plague_lords_blessings.001"),
		hpr_leader("war.battle.hp.plague_lords_blessings.002"),
		hpr_normal("war.battle.hp.plague_lords_blessings.003"),
		hpr_normal("war.battle.hp.plague_lords_blessings.004"),
		hpr_normal("war.battle.hp.plague_lords_blessings.005")
	);
	parser:add_record("battle_plague_lords_blessings", "script_link_battle_plague_lords_blessings", "tooltip_battle_plague_lords_blessings");
	tp_plague_lords_blessings = tooltip_patcher:new("tooltip_battle_plague_lords_blessings");
	tp_plague_lords_blessings:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_plague_lords_blessings", "ui_text_replacements_localised_text_hp_battle_description_plague_lords_blessings");

	tp_plague_lords_blessings = tooltip_listener:new(
		"tooltip_battle_plague_lords_blessings",
		function()
			buim:highlight_army_abilities(true);
		end,
		function()
			buim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- plague_lords_blessings_link
	--
	script_feature_name = "plague_lords_blessings";
	parser:add_record("battle_"..script_feature_name.."_link", "script_link_battle_"..script_feature_name.."_link", "tooltip_battle_"..script_feature_name.."_link");
	tp_plague_lords_blessings_link = tooltip_patcher:new("tooltip_battle_"..script_feature_name.."_link");
	tp_plague_lords_blessings_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_title_"..script_feature_name.."_link");

	tl_plague_lords_blessings_link = tooltip_listener:new(
		"tooltip_battle_"..script_feature_name.."_link",
		function()
			script_error("mouse cursor placed over "..script_feature_name.." link but no highlight function has been created - todo");
		end,
		function()
			buim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- plague_lords_blessings_meter
	--
	
	parser:add_record("battle_plague_lords_blessings_meter", "script_link_battle_plague_lords_blessings_meter", "tooltip_battle_plague_lords_blessings_meter");
	tp_plague_lords_blessings_meter = tooltip_patcher:new("tooltip_battle_plague_lords_blessings_meter");
	tp_plague_lords_blessings_meter:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_description_plague_lords_blessings_meter");

	tp_plague_lords_blessings_meter = tooltip_listener:new(
		"tooltip_battle_plague_lords_blessings_meter", 
		function() 
			buim:highlight_army_abilities_meter(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);

	
	
	--
	-- power_reserve_bar
	--

	parser:add_record("battle_power_reserve_bar", "script_link_battle_power_reserve_bar", "tooltip_battle_power_reserve_bar");
	tp_power_reserve_bar = tooltip_patcher:new("tooltip_battle_power_reserve_bar");
	tp_power_reserve_bar:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_title_power_reserve_bar");
	
	tl_power_reserve_bar = tooltip_listener:new(
		"tooltip_battle_power_reserve_bar", 
		function() 
			buim:highlight_power_reserve_bar(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	

	--
	-- radar_map
	--

	parser:add_record("battle_radar_map", "script_link_battle_radar_map", "tooltip_battle_radar_map");
	tp_radar_map = tooltip_patcher:new("tooltip_battle_radar_map");
	tp_radar_map:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_title_top_item");
	
	tl_radar_map = tooltip_listener:new(
		"tooltip_battle_radar_map", 
		function() 
			buim:highlight_radar_map(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- rallying
	--
	
	hp_rallying = help_page:new(
		"script_link_battle_rallying",
		hpr_title("war.battle.hp.rallying.001"),
		hpr_leader("war.battle.hp.rallying.002"),
		hpr_normal("war.battle.hp.rallying.003"),
		hpr_normal("war.battle.hp.rallying.004"),
		hpr_normal("war.battle.hp.rallying.005")
	);
	parser:add_record("battle_rallying", "script_link_battle_rallying", "tooltip_battle_rallying");
	tp_rallying = tooltip_patcher:new("tooltip_battle_rallying");
	tp_rallying:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_rallying", "ui_text_replacements_localised_text_hp_battle_description_rallying");
	
	
	
	--
	-- rampaging
	--
	
	hp_rampaging = help_page:new(
		"script_link_battle_rampaging",
		hpr_title("war.battle.hp.rampaging.001"),
		hpr_leader("war.battle.hp.rampaging.002"),
		hpr_normal("war.battle.hp.rampaging.003")
	);
	parser:add_record("battle_rampaging", "script_link_battle_rampaging", "tooltip_battle_rampaging");
	tp_rampaging = tooltip_patcher:new("tooltip_battle_rampaging");
	tp_rampaging:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_rampaging", "ui_text_replacements_localised_text_hp_battle_description_rampaging");
	
	
	
	--
	-- realm_of_souls
	--
	
	hp_realm_of_souls = help_page:new(
		"script_link_battle_realm_of_souls",
		hpr_title("war.battle.hp.realm_of_souls.001"),
		hpr_leader("war.battle.hp.realm_of_souls.002"),
		hpr_normal("war.battle.hp.realm_of_souls.003"),
		hpr_normal("war.battle.hp.realm_of_souls.004"),
		hpr_normal("war.battle.hp.realm_of_souls.005")
	);
	parser:add_record("battle_realm_of_souls", "script_link_battle_realm_of_souls", "tooltip_battle_realm_of_souls");
	tp_realm_of_souls = tooltip_patcher:new("tooltip_battle_realm_of_souls");
	tp_realm_of_souls:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_realm_of_souls", "ui_text_replacements_localised_text_hp_battle_description_realm_of_souls");
	
	tl_realm_of_souls = tooltip_listener:new(
		"tooltip_battle_realm_of_souls", 
		function() 
			buim:highlight_realm_of_souls(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- realm_of_souls_link
	--
	
	parser:add_record("battle_realm_of_souls_link", "script_link_battle_realm_of_souls_link", "tooltip_battle_realm_of_souls_link");
	tp_realm_of_souls_link = tooltip_patcher:new("tooltip_battle_realm_of_souls_link");
	tp_realm_of_souls_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_title_realm_of_souls_link");
	
	tl_realm_of_souls_link = tooltip_listener:new(
		"tooltip_battle_realm_of_souls_link", 
		function() 
			buim:highlight_realm_of_souls(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	

	--
	-- reign_of_chaos
	--

	hp_reign_of_chaos = help_page:new(
		"script_link_battle_reign_of_chaos",
		hpr_title("war.battle.hp.reign_of_chaos.001"),
		hpr_leader("war.battle.hp.reign_of_chaos.002"),
		hpr_normal("war.battle.hp.reign_of_chaos.003"),
		hpr_normal("war.battle.hp.reign_of_chaos.004")
	);
	parser:add_record("battle_reign_of_chaos", "script_link_battle_reign_of_chaos", "tooltip_battle_reign_of_chaos");
	tp_reign_of_chaos = tooltip_patcher:new("tooltip_battle_reign_of_chaos");
	tp_reign_of_chaos:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_reign_of_chaos", "ui_text_replacements_localised_text_hp_battle_description_reign_of_chaos");

	tp_reign_of_chaos = tooltip_listener:new(
		"tooltip_battle_reign_of_chaos", 
		function() 
			buim:highlight_army_abilities(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- reign_of_chaos_link
	--
	script_feature_name = "reign_of_chaos";
	parser:add_record("battle_"..script_feature_name.."_link", "script_link_battle_"..script_feature_name.."_link", "tooltip_battle_"..script_feature_name.."_link");
	tp_reign_of_chaos_link = tooltip_patcher:new("tooltip_battle_"..script_feature_name.."_link");
	tp_reign_of_chaos_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_title_"..script_feature_name.."_link");

	tl_reign_of_chaos_link = tooltip_listener:new(
		"tooltip_battle_"..script_feature_name.."_link",
		function()
			buim:highlight_army_abilities(true);
		end,
		function()
			buim:unhighlight_all_for_tooltips();
		end
	);




	--
	-- reign_of_chaos_meter
	--
	
	parser:add_record("battle_reign_of_chaos_meter", "script_link_battle_reign_of_chaos_meter", "tooltip_battle_reign_of_chaos_meter");
	tp_reign_of_chaos_meter = tooltip_patcher:new("tooltip_battle_reign_of_chaos_meter");
	tp_reign_of_chaos_meter:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_description_reign_of_chaos_meter");
	
	tp_reign_of_chaos_meter = tooltip_listener:new(
		"tooltip_battle_reign_of_chaos_meter",
		function() 
			buim:highlight_army_abilities_meter(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- reinforcements
	--
	
	hp_reinforcements = help_page:new(
		"script_link_battle_reinforcements",
		hpr_title("war.battle.hp.reinforcements.001"),
		hpr_leader("war.battle.hp.reinforcements.002"),
		hpr_normal("war.battle.hp.reinforcements.003")
	);
	parser:add_record("battle_reinforcements", "script_link_battle_reinforcements", "tooltip_battle_reinforcements");
	tp_reinforcements = tooltip_patcher:new("tooltip_battle_reinforcements");
	tp_reinforcements:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_reinforcements", "ui_text_replacements_localised_text_hp_battle_description_reinforcements");



	--
	-- sensuous_seductions
	--
	
	hp_sensuous_seductions = help_page:new(
		"script_link_battle_sensuous_seductions",
		hpr_title("war.battle.hp.sensuous_seductions.001"),
		hpr_leader("war.battle.hp.sensuous_seductions.002"),
		hpr_normal("war.battle.hp.sensuous_seductions.003"),
		hpr_normal("war.battle.hp.sensuous_seductions.004"),
		hpr_normal("war.battle.hp.sensuous_seductions.005")
	);
	parser:add_record("battle_sensuous_seductions", "script_link_battle_sensuous_seductions", "tooltip_battle_sensuous_seductions");
	tp_sensuous_seductions = tooltip_patcher:new("tooltip_battle_sensuous_seductions");
	tp_sensuous_seductions:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_sensuous_seductions", "ui_text_replacements_localised_text_hp_battle_description_sensuous_seductions");
	
	tp_sensuous_seductions = tooltip_listener:new(
		"tooltip_battle_sensuous_seductions", 
		function() 
			buim:highlight_army_abilities(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- sensuous_seductions_link
	--
	script_feature_name = "sensuous_seductions";
	parser:add_record("battle_"..script_feature_name.."_link", "script_link_battle_"..script_feature_name.."_link", "tooltip_battle_"..script_feature_name.."_link");
	tp_sensuous_seductions_link = tooltip_patcher:new("tooltip_battle_"..script_feature_name.."_link");
	tp_sensuous_seductions_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_title_"..script_feature_name.."_link");

	tl_sensuous_seductions_link = tooltip_listener:new(
		"tooltip_battle_"..script_feature_name.."_link",
		function()
			buim:highlight_army_abilities(true);
		end,
		function()
			buim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- sensuous_seductions_meter
	--
	
	parser:add_record("battle_sensuous_seductions_meter", "script_link_battle_sensuous_seductions_meter", "tooltip_battle_sensuous_seductions_meter");
	tp_sensuous_seductions_meter = tooltip_patcher:new("tooltip_battle_sensuous_seductions_meter");
	tp_sensuous_seductions_meter:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_description_sensuous_seductions_meter");

	tp_sensuous_seductions_meter = tooltip_listener:new(
		"tooltip_battle_sensuous_seductions_meter", 
		function() 
			buim:highlight_army_abilities_meter(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	
	--
	-- siege_weapons
	--
	
	hp_siege_weapons = help_page:new(
		"script_link_battle_siege_weapons",
		hpr_title("war.battle.hp.siege_weapons.001"),
		hpr_leader("war.battle.hp.siege_weapons.002"),
		hpr_normal("war.battle.hp.siege_weapons.003"),
		hpr_normal("war.battle.hp.siege_weapons.004"),

		hpr_section("rams"),
		hpr_normal_unfaded("war.battle.hp.siege_weapons.005", "rams"),
		hpr_normal("war.battle.hp.siege_weapons.006", "rams"),

		hpr_section("towers"),
		hpr_normal_unfaded("war.battle.hp.siege_weapons.007", "towers"),
		hpr_normal("war.battle.hp.siege_weapons.008", "towers")
	);
	parser:add_record("battle_siege_weapons", "script_link_battle_siege_weapons", "tooltip_battle_siege_weapons");
	tp_siege_weapons = tooltip_patcher:new("tooltip_battle_siege_weapons");
	tp_siege_weapons:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_siege_weapons", "ui_text_replacements_localised_text_hp_battle_description_siege_weapons");
	
	
	
	--
	-- skirmishing
	--
	
	hp_skirmishing = help_page:new(
		"script_link_battle_skirmishing",
		hpr_title("war.battle.hp.skirmishing.001"),
		hpr_leader("war.battle.hp.skirmishing.002"),
		hpr_normal("war.battle.hp.skirmishing.003"),
		hpr_normal("war.battle.hp.skirmishing.004")
	);
	parser:add_record("battle_skirmishing", "script_link_battle_skirmishing", "tooltip_battle_skirmishing");
	tp_skirmishing = tooltip_patcher:new("tooltip_battle_skirmishing");
	tp_skirmishing:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_skirmishing", "ui_text_replacements_localised_text_hp_battle_description_skirmishing");
	
	tl_skirmishing = tooltip_listener:new(
		"tooltip_battle_skirmishing", 
		function() 
			buim:highlight_skirmish_button(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- skirmishing_link
	--
	
	parser:add_record("battle_skirmishing_link", "script_link_battle_skirmishing_link", "tooltip_battle_skirmishing_link");
	tp_skirmishing_link = tooltip_patcher:new("tooltip_battle_skirmishing_link");
	tp_skirmishing_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_title_skirmishing_link");
	
	tl_skirmishing_link = tooltip_listener:new(
		"tooltip_battle_skirmishing_link", 
		function() 
			buim:highlight_skirmish_button(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- skirmish_button
	--

	parser:add_record("battle_skirmish_button", "script_link_battle_skirmish_button", "tooltip_battle_skirmish_button");
	tp_skirmish_button = tooltip_patcher:new("tooltip_battle_skirmish_button");
	tp_skirmish_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_description_skirmish_button");
	
	tl_skirmish_button = tooltip_listener:new(
		"tooltip_battle_skirmish_button", 
		function() 
			buim:highlight_skirmish_button(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- spells
	--
	
	hp_spells = help_page:new(
		"script_link_battle_spells",
		hpr_title("war.battle.hp.spells.001"),
		hpr_leader("war.battle.hp.spells.002"),
		hpr_normal("war.battle.hp.spells.003"),
		hpr_normal("war.battle.hp.spells.004"),
		hpr_normal("war.battle.hp.spells.005"),
		hpr_normal("war.battle.hp.spells.006"),
		hpr_normal("war.battle.hp.spells.007")
	);
	parser:add_record("battle_spells", "script_link_battle_spells", "tooltip_battle_spells");
	tp_spells = tooltip_patcher:new("tooltip_battle_spells");
	tp_spells:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_spells", "ui_text_replacements_localised_text_hp_battle_description_spells");
	
	tl_spells = tooltip_listener:new(
		"tooltip_battle_spells", 
		function() 
			buim:highlight_spells(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- spells_link
	--
	
	parser:add_record("battle_spells_link", "script_link_battle_spells_link", "tooltip_battle_spells_link");
	tp_spells_link = tooltip_patcher:new("tooltip_battle_spells_link");
	tp_spells_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_title_winds_of_magic_link");
	
	tl_spells_link = tooltip_listener:new(
		"tooltip_battle_spells_link", 
		function() 
			buim:highlight_spells(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- supplies
	--
	
	hp_supplies = help_page:new(
		"script_link_battle_supplies",
		hpr_title("war.battle.hp.supplies.001"),
		hpr_leader("war.battle.hp.supplies.002"),
		hpr_normal("war.battle.hp.supplies.003"),
		hpr_normal("war.battle.hp.supplies.004"),
		hpr_normal("war.battle.hp.supplies.005")
	);
	parser:add_record("battle_supplies", "script_link_battle_supplies", "tooltip_battle_supplies");
	tp_supplies = tooltip_patcher:new("tooltip_battle_supplies");
	tp_supplies:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_supplies", "ui_text_replacements_localised_text_hp_battle_description_supplies");

	tl_supplies = tooltip_listener:new(
		"tooltip_battle_supplies", 
		function() 
			buim:highlight_supplies(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- supplies_link
	--
	
	parser:add_record("battle_supplies_link", "script_link_battle_supplies_link", "tooltip_battle_supplies_link");
	tp_supplies_link = tooltip_patcher:new("tooltip_battle_supplies_link");
	tp_supplies_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_title_supplies_link");
	
	tl_supplies_link = tooltip_listener:new(
		"tooltip_battle_supplies_link", 
		function() 
			buim:highlight_supplies(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);


	
	--
	-- survival_battles
	--
	
	hp_survival_battles = help_page:new(
		"script_link_battle_survival_battles",
		hpr_title("war.battle.hp.survival_battles.001"),
		hpr_leader("war.battle.hp.survival_battles.002"),
		hpr_normal("war.battle.hp.survival_battles.003"),
		hpr_normal("war.battle.hp.survival_battles.004"),
		hpr_normal("war.battle.hp.survival_battles.005")
	);
	parser:add_record("battle_survival_battles", "script_link_battle_survival_battles", "tooltip_battle_survival_battles");
	tp_survival_battles = tooltip_patcher:new("tooltip_battle_survival_battles");
	tp_survival_battles:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_survival_battles", "ui_text_replacements_localised_text_hp_battle_description_survival_battles");



	--
	-- storm_of_magic_battles
	--
	
	hp_storm_of_magic_battles = help_page:new(
		"script_link_battle_storm_of_magic_battles",
		hpr_title("war.battle.hp.storm_of_magic_battles.001"),
		hpr_leader("war.battle.hp.storm_of_magic_battles.002"),
		hpr_normal("war.battle.hp.storm_of_magic_battles.003"),
		hpr_normal("war.battle.hp.storm_of_magic_battles.004")
	);
	parser:add_record("battle_storm_of_magic_battles", "script_link_battle_storm_of_magic_battles", "tooltip_battle_storm_of_magic_battles");
	tp_storm_of_magic_battles = tooltip_patcher:new("tooltip_battle_storm_of_magic_battles");
	tp_storm_of_magic_battles:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_storm_of_magic_battles", "ui_text_replacements_localised_text_hp_battle_description_storm_of_magic_battles");
	
	

	--
	-- tactical_map
	--
	
	hp_tactical_map = help_page:new(
		"script_link_battle_tactical_map",
		hpr_title("war.battle.hp.tactical_map.001"),
		hpr_leader("war.battle.hp.tactical_map.002"),
		hpr_normal("war.battle.hp.tactical_map.003"),
		hpr_normal("war.battle.hp.tactical_map.004"),
		hpr_normal("war.battle.hp.tactical_map.005"),
		hpr_normal("war.battle.hp.tactical_map.006")
	);
	parser:add_record("battle_tactical_map", "script_link_battle_tactical_map", "tooltip_battle_tactical_map");
	tp_tactical_map = tooltip_patcher:new("tooltip_battle_tactical_map");
	tp_tactical_map:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_tactical_map", "ui_text_replacements_localised_text_hp_battle_description_tactical_map");
	
	tl_tactical_map = tooltip_listener:new(
		"tooltip_battle_tactical_map", 
		function() 
			buim:highlight_tactical_map_button(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- tactical_map_link
	--
	
	parser:add_record("battle_tactical_map_link", "script_link_battle_tactical_map_link", "tooltip_battle_tactical_map_link");
	tp_tactical_map_link = tooltip_patcher:new("tooltip_battle_tactical_map_link");
	tp_tactical_map_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_title_tactical_map_link");
	
	tl_tactical_map_link = tooltip_listener:new(
		"tooltip_battle_tactical_map_link", 
		function() 
			buim:highlight_tactical_map_button(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- terrain
	--
	
	hp_terrain = help_page:new(
		"script_link_battle_terrain",
		hpr_title("war.battle.hp.terrain.001"),
		hpr_leader("war.battle.hp.terrain.002"),
		hpr_normal("war.battle.hp.terrain.003"),
		hpr_normal("war.battle.hp.terrain.004"),
		hpr_normal("war.battle.hp.terrain.005"),
		hpr_normal("war.battle.hp.terrain.006")
	);
	parser:add_record("battle_terrain", "script_link_battle_terrain", "tooltip_battle_terrain");
	tp_terrain = tooltip_patcher:new("tooltip_battle_terrain");
	tp_terrain:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_terrain", "ui_text_replacements_localised_text_hp_battle_description_terrain");
	
	
	
	--
	-- the_general
	--
	
	hp_the_general = help_page:new(
		"script_link_battle_the_general",
		hpr_title("war.battle.hp.the_general.001"),
		hpr_leader("war.battle.hp.the_general.002"),
		hpr_normal("war.battle.hp.the_general.003"),
		hpr_normal("war.battle.hp.the_general.004"),
		hpr_normal("war.battle.hp.the_general.005")
	);
	parser:add_record("battle_the_general", "script_link_battle_the_general", "tooltip_battle_the_general");
	tp_the_general = tooltip_patcher:new("tooltip_battle_the_general");
	tp_the_general:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_the_general", "ui_text_replacements_localised_text_hp_battle_description_the_general");
	
	
	
	--
	-- time_controls
	--

	parser:add_record("battle_time_controls", "script_link_battle_time_controls", "tooltip_battle_time_controls");
	tp_time_controls = tooltip_patcher:new("tooltip_battle_time_controls");
	tp_time_controls:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_title_top_item");
	
	tl_time_controls = tooltip_listener:new(
		"tooltip_battle_time_controls", 
		function() 
			buim:highlight_time_controls(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- time_limit
	--

	parser:add_record("battle_time_limit", "script_link_battle_time_limit", "tooltip_battle_time_limit");
	tp_time_limit = tooltip_patcher:new("tooltip_battle_time_limit");
	tp_time_limit:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_description_time_limit");
	
	tl_time_limit = tooltip_listener:new(
		"tooltip_battle_time_limit", 
		function() 
			buim:highlight_time_limit(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- towers
	--
	
	hp_towers = help_page:new(
		"script_link_battle_towers",
		hpr_title("war.battle.hp.towers.001"),
		hpr_leader("war.battle.hp.towers.002"),
		hpr_normal("war.battle.hp.towers.003"),
		hpr_normal("war.battle.hp.towers.004"),
		hpr_normal("war.battle.hp.towers.005"),
		hpr_normal("war.battle.hp.towers.006")
	);
	parser:add_record("battle_towers", "script_link_battle_towers", "tooltip_battle_towers");
	tp_towers = tooltip_patcher:new("tooltip_battle_towers");
	tp_towers:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_towers", "ui_text_replacements_localised_text_hp_battle_description_towers");
	
	
	

	--
	-- unit_abilities
	--
	
	hp_unit_abilities = help_page:new(
		"script_link_battle_unit_abilities",
		hpr_title("war.battle.hp.unit_abilities.001"),
		hpr_leader("war.battle.hp.unit_abilities.002"),
		hpr_normal("war.battle.hp.unit_abilities.003"),
		hpr_normal("war.battle.hp.unit_abilities.004"),
		hpr_normal("war.battle.hp.unit_abilities.005")
	);
	parser:add_record("battle_unit_abilities", "script_link_battle_unit_abilities", "tooltip_battle_unit_abilities");
	tp_unit_abilities = tooltip_patcher:new("tooltip_battle_unit_abilities");
	tp_unit_abilities:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_unit_abilities", "ui_text_replacements_localised_text_hp_battle_description_unit_abilities");
	
	tl_unit_abilities = tooltip_listener:new(
		"tooltip_battle_unit_abilities", 
		function() 
			buim:highlight_unit_abilities(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- unit_abilities_link
	--
	
	parser:add_record("battle_unit_abilities_link", "script_link_battle_unit_abilities_link", "tooltip_battle_unit_abilities_link");
	tp_unit_abilities_link = tooltip_patcher:new("tooltip_battle_unit_abilities_link");
	tp_unit_abilities_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_title_unit_abilities_link");
	
	tl_unit_abilities_link = tooltip_listener:new(
		"tooltip_battle_unit_abilities_link", 
		function() 
			buim:highlight_unit_abilities(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	

	--
	-- unit_cards
	--
	
	hp_unit_cards = help_page:new(
		"script_link_battle_unit_cards",
		hpr_title("war.battle.hp.unit_cards.001"),
		hpr_leader("war.battle.hp.unit_cards.002"),
		hpr_normal("war.battle.hp.unit_cards.003"),
		hpr_normal("war.battle.hp.unit_cards.004"),
		hpr_normal("war.battle.hp.unit_cards.005"),
		hpr_normal("war.battle.hp.unit_cards.006"),
		hpr_normal("war.battle.hp.unit_cards.007")
	);
	parser:add_record("battle_unit_cards", "script_link_battle_unit_cards", "tooltip_battle_unit_cards");
	tp_unit_cards = tooltip_patcher:new("tooltip_battle_unit_cards");
	tp_unit_cards:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_unit_cards", "ui_text_replacements_localised_text_hp_battle_description_unit_cards");
	
	tl_unit_cards = tooltip_listener:new(
		"tooltip_battle_unit_cards", 
		function() 
			buim:highlight_unit_cards(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- unit_cards_link
	--
	
	parser:add_record("battle_unit_cards_link", "script_link_battle_unit_cards_link", "tooltip_battle_unit_cards_link");
	tp_unit_cards_link = tooltip_patcher:new("tooltip_battle_unit_cards_link");
	tp_unit_cards_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_title_unit_cards_link");
	
	tl_unit_cards_link = tooltip_listener:new(
		"tooltip_battle_unit_cards_link", 
		function() 
			buim:highlight_unit_cards(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	
	--
	-- unit_details_button
	--

	parser:add_record("battle_unit_details_button", "script_link_battle_unit_details_button", "tooltip_battle_unit_details_button");
	tp_unit_details_button = tooltip_patcher:new("tooltip_battle_unit_details_button");
	tp_unit_details_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_title_bottom_button");
	
	tl_unit_details_button = tooltip_listener:new(
		"tooltip_battle_unit_details_button", 
		function() 
			buim:highlight_unit_details_button(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- unit_details_panel
	--
	
	hp_unit_details_panel = help_page:new(
		"script_link_battle_unit_details_panel",
		hpr_title("war.battle.hp.unit_details_panel.001"),
		hpr_leader("war.battle.hp.unit_details_panel.002"),
		hpr_normal("war.battle.hp.unit_details_panel.003"),
		hpr_normal("war.battle.hp.unit_details_panel.004")
	);
	parser:add_record("battle_unit_details_panel", "script_link_battle_unit_details_panel", "tooltip_battle_unit_details_panel");
	tp_unit_details_panel = tooltip_patcher:new("tooltip_battle_unit_details_panel");
	tp_unit_details_panel:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_unit_details_panel", "ui_text_replacements_localised_text_hp_battle_description_unit_details_panel");
	
	tl_unit_details_panel = tooltip_listener:new(
		"tooltip_battle_unit_details_panel", 
		function() 
			buim:highlight_unit_details_panel(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	
	--
	-- unit_details_panel_link
	--
	
	parser:add_record("battle_unit_details_panel_link", "script_link_battle_unit_details_panel_link", "tooltip_battle_unit_details_panel_link");
	tp_unit_details_panel_link = tooltip_patcher:new("tooltip_battle_unit_details_panel_link");
	tp_unit_details_panel_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_title_unit_details_panel_link");
	
	tl_unit_details_panel_link = tooltip_listener:new(
		"tooltip_battle_unit_details_panel_link", 
		function() 
			buim:highlight_unit_details_panel(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	

	--
	-- unit_movement
	--
	
	hp_unit_movement = help_page:new(
		"script_link_battle_unit_movement",
		hpr_title("war.battle.hp.unit_movement.001"),
		hpr_leader("war.battle.hp.unit_movement.002"),
		hpr_normal("war.battle.hp.unit_movement.003"),
		hpr_normal("war.battle.hp.unit_movement.004"),
		hpr_normal("war.battle.hp.unit_movement.005")
	);
	parser:add_record("battle_unit_movement", "script_link_battle_unit_movement", "tooltip_battle_unit_movement");
	tp_unit_movement = tooltip_patcher:new("tooltip_battle_unit_movement");
	tp_unit_movement:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_unit_movement", "ui_text_replacements_localised_text_hp_battle_description_unit_movement");
	
	
	
	--
	-- unit_portrait_panel
	--

	parser:add_record("battle_unit_portrait_panel", "script_link_battle_unit_portrait_panel", "tooltip_battle_unit_portrait_panel");
	tp_unit_portrait_panel = tooltip_patcher:new("tooltip_battle_unit_portrait_panel");
	tp_unit_portrait_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_title_bottom_panel");
	
	tl_unit_portrait_panel = tooltip_listener:new(
		"tooltip_battle_unit_portrait_panel", 
		function() 
			buim:highlight_unit_portrait_panel(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- unit_selection
	--
	
	hp_unit_selection = help_page:new(
		"script_link_battle_unit_selection",
		hpr_title("war.battle.hp.unit_selection.001"),
		hpr_leader("war.battle.hp.unit_selection.002"),
		hpr_normal("war.battle.hp.unit_selection.003"),
		hpr_normal("war.battle.hp.unit_selection.004"),
		hpr_normal("war.battle.hp.unit_selection.005"),
		hpr_normal("war.battle.hp.unit_selection.006")
	);
	parser:add_record("battle_unit_selection", "script_link_battle_unit_selection", "tooltip_battle_unit_selection");
	tp_unit_selection = tooltip_patcher:new("tooltip_battle_unit_selection");
	tp_unit_selection:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_unit_selection", "ui_text_replacements_localised_text_hp_battle_description_unit_selection");
	
	
	

	--
	-- unit_types
	--
	
	hp_unit_types = help_page:new(
		"script_link_battle_unit_types",
		hpr_title("war.battle.hp.unit_types.001"),
		hpr_leader("war.battle.hp.unit_types.002"),
		hpr_normal("war.battle.hp.unit_types.003"),
		hpr_normal("war.battle.hp.unit_types.004"),
		hpr_normal("war.battle.hp.unit_types.005"),
		hpr_normal("war.battle.hp.unit_types.006"),
		hpr_normal("war.battle.hp.unit_types.007")
	);
	parser:add_record("battle_unit_types", "script_link_battle_unit_types", "tooltip_battle_unit_types");
	tp_unit_types = tooltip_patcher:new("tooltip_battle_unit_types");
	tp_unit_types:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_unit_types", "ui_text_replacements_localised_text_hp_battle_description_unit_types");
	
	
	

	--
	-- units
	--
	
	hp_units = help_page:new(
		"script_link_battle_units",
		hpr_title("war.battle.hp.units.001"),
		hpr_leader("war.battle.hp.units.002"),
		hpr_normal("war.battle.hp.units.003"),
		hpr_normal("war.battle.hp.units.004"),
		hpr_normal("war.battle.hp.units.005"),
		hpr_normal("war.battle.hp.units.006"),
		hpr_normal("war.battle.hp.units.007")
	);
	parser:add_record("battle_units", "script_link_battle_units", "tooltip_battle_units");
	tp_units = tooltip_patcher:new("tooltip_battle_units");
	tp_units:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_units", "ui_text_replacements_localised_text_hp_battle_description_units");
	
	tl_units = tooltip_listener:new(
		"tooltip_battle_units", 
		function() 
			buim:highlight_unit_cards(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- units_link
	--
	
	parser:add_record("battle_units_link", "script_link_battle_units_link", "tooltip_battle_units_link");
	tp_units_link = tooltip_patcher:new("tooltip_battle_units_link");
	tp_units_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_title_units_link");
	
	tl_units_link = tooltip_listener:new(
		"tooltip_battle_units_link", 
		function() 
			buim:highlight_unit_cards(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	

	--
	-- victory_locations
	--
	
	hp_victory_locations = help_page:new(
		"script_link_battle_victory_locations",
		hpr_title("war.battle.hp.victory_locations.001"),
		hpr_leader("war.battle.hp.victory_locations.002"),
		hpr_normal("war.battle.hp.victory_locations.003"),
		hpr_normal("war.battle.hp.victory_locations.004"),
		
		hpr_section("victory"),
		hpr_normal_unfaded("war.battle.hp.victory_locations.005", "victory"),
		hpr_normal("war.battle.hp.victory_locations.006", "victory"),

		hpr_section("key_building"),
		hpr_normal_unfaded("war.battle.hp.victory_locations.007", "key_building"),
		hpr_normal("war.battle.hp.victory_locations.008", "key_building"),
		hpr_normal("war.battle.hp.victory_locations.009", "key_building")
	);
	parser:add_record("battle_victory_locations", "script_link_battle_victory_locations", "tooltip_battle_victory_locations");
	tp_victory_locations = tooltip_patcher:new("tooltip_battle_victory_locations");
	tp_victory_locations:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_victory_locations", "ui_text_replacements_localised_text_hp_battle_description_victory_locations");

	tl_units = tooltip_listener:new(
		"tooltip_battle_units", 
		function() 
			buim:highlight_victory_locations(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- victory_tickets
	--
	
	parser:add_record("battle_victory_tickets", "script_link_battle_victory_tickets", "tooltip_battle_victory_tickets");
	tp_victory_tickets = tooltip_patcher:new("tooltip_battle_victory_tickets");
	tp_victory_tickets:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_description_victory_tickets");

	tl_victory_tickets = tooltip_listener:new(
		"tooltip_battle_victory_tickets", 
		function() 
			buim:highlight_victory_tickets(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- vigour
	--
	
	hp_vigour = help_page:new(
		"script_link_battle_vigour",
		hpr_title("war.battle.hp.vigour.001"),
		hpr_leader("war.battle.hp.vigour.002"),
		hpr_normal("war.battle.hp.vigour.003"),
		hpr_normal("war.battle.hp.vigour.004")
	);
	parser:add_record("battle_vigour", "script_link_battle_vigour", "tooltip_battle_vigour");
	tp_vigour = tooltip_patcher:new("tooltip_battle_vigour");
	tp_vigour:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_vigour", "ui_text_replacements_localised_text_hp_battle_description_vigour");
	
	
	
	--
	-- visibility
	--
	
	hp_visibility = help_page:new(
		"script_link_battle_visibility",
		hpr_title("war.battle.hp.visibility.001"),
		hpr_leader("war.battle.hp.visibility.002"),
		hpr_normal("war.battle.hp.visibility.003"),
		hpr_normal("war.battle.hp.visibility.004"),
		hpr_normal("war.battle.hp.visibility.005"),
		hpr_normal("war.battle.hp.visibility.006")
	);
	parser:add_record("battle_visibility", "script_link_battle_visibility", "tooltip_battle_visibility");
	tp_visibility = tooltip_patcher:new("tooltip_battle_visibility");
	tp_visibility:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_visibility", "ui_text_replacements_localised_text_hp_battle_description_visibility");

	

	--
	-- walls
	--
	
	hp_walls = help_page:new(
		"script_link_battle_walls",
		hpr_title("war.battle.hp.walls.001"),
		hpr_leader("war.battle.hp.walls.002"),
		hpr_normal("war.battle.hp.walls.003"),
		hpr_bulleted("war.battle.hp.walls.004"),
		hpr_bulleted("war.battle.hp.walls.005"),
		hpr_bulleted("war.battle.hp.walls.006"),
		hpr_normal("war.battle.hp.walls.007"),
		hpr_normal("war.battle.hp.walls.008")
	);
	parser:add_record("battle_walls", "script_link_battle_walls", "tooltip_battle_walls");
	tp_walls = tooltip_patcher:new("tooltip_battle_walls");
	tp_walls:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_walls", "ui_text_replacements_localised_text_hp_battle_description_walls");
	
	

	--
	-- weapon_types
	--
	
	hp_weapon_types = help_page:new(
		"script_link_battle_weapon_types",
		hpr_title("war.battle.hp.weapon_types.001"),
		hpr_leader("war.battle.hp.weapon_types.002"),
		hpr_normal("war.battle.hp.weapon_types.003"),
		hpr_normal("war.battle.hp.weapon_types.004"),
		hpr_normal("war.battle.hp.weapon_types.005")
	);
	parser:add_record("battle_weapon_types", "script_link_battle_weapon_types", "tooltip_battle_weapon_types");
	tp_weapon_types = tooltip_patcher:new("tooltip_battle_weapon_types");
	tp_weapon_types:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_weapon_types", "ui_text_replacements_localised_text_hp_battle_description_weapon_types");
	
	
	
	
	--
	-- winds_of_magic
	--
	
	hp_winds_of_magic = help_page:new(
		"script_link_battle_winds_of_magic",
		hpr_title("war.battle.hp.winds_of_magic.001"),
		hpr_leader("war.battle.hp.winds_of_magic.002"),
		hpr_normal("war.battle.hp.winds_of_magic.003"),
		hpr_normal("war.battle.hp.winds_of_magic.004"),
		hpr_normal("war.battle.hp.winds_of_magic.005"),
		hpr_normal("war.battle.hp.winds_of_magic.006")
	);
	parser:add_record("battle_winds_of_magic", "script_link_battle_winds_of_magic", "tooltip_battle_winds_of_magic");
	tp_winds_of_magic = tooltip_patcher:new("tooltip_battle_winds_of_magic");
	tp_winds_of_magic:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_winds_of_magic", "ui_text_replacements_localised_text_hp_battle_description_winds_of_magic");
	
	tl_winds_of_magic = tooltip_listener:new(
		"tooltip_battle_winds_of_magic", 
		function() 
			buim:highlight_winds_of_magic_panel(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- winds_of_magic_link
	--
	
	parser:add_record("battle_winds_of_magic_link", "script_link_battle_winds_of_magic_link", "tooltip_battle_winds_of_magic_link");
	tp_winds_of_magic_link = tooltip_patcher:new("tooltip_battle_winds_of_magic_link");
	tp_winds_of_magic_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_title_winds_of_magic_link");
	
	tl_winds_of_magic_link = tooltip_listener:new(
		"tooltip_battle_winds_of_magic_link", 
		function() 
			buim:highlight_winds_of_magic_panel(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- winds_of_magic_panel
	--

	parser:add_record("battle_winds_of_magic_panel", "script_link_battle_winds_of_magic_panel", "tooltip_battle_winds_of_magic_panel");
	tp_winds_of_magic_panel = tooltip_patcher:new("tooltip_battle_winds_of_magic_panel");
	tp_winds_of_magic_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_battle_title_bottom_panel");
	
	tl_winds_of_magic_panel = tooltip_listener:new(
		"tooltip_battle_winds_of_magic_panel", 
		function() 
			buim:highlight_winds_of_magic_panel(true);
		end,
		function() 
			buim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	
	--
	-- wizards
	--
	
	hp_wizards = help_page:new(
		"script_link_battle_wizards",
		hpr_title("war.battle.hp.wizards.001"),
		hpr_leader("war.battle.hp.wizards.002"),
		hpr_normal("war.battle.hp.wizards.003"),
		hpr_normal("war.battle.hp.wizards.004"),
		hpr_normal("war.battle.hp.wizards.005")
	);
	parser:add_record("battle_wizards", "script_link_battle_wizards", "tooltip_battle_wizards");
	wizards = tooltip_patcher:new("tooltip_battle_wizards");
	wizards:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_battle_title_wizards", "ui_text_replacements_localised_text_hp_battle_description_wizards");
end;








----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- infotext state mapping
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------


do
	local infotext = get_infotext_manager();
	
	-- camera
	infotext:set_state_override("wh2.battle.intro.info_201", "battle_controls_camera");
	infotext:set_state_override("wh2.battle.intro.info_202", "battle_controls_camera_facing");
	infotext:set_state_override("wh2.battle.intro.info_203", "battle_controls_camera_altitude");
	-- infotext:set_state_override("wh2.battle.intro.info_204", "battle_controls_camera_speed");
	
	-- selection
	infotext:set_state_override("wh2.battle.intro.info_021", "battle_controls_selection");
	infotext:set_state_override("wh2.battle.intro.info_022", "battle_controls_multiple_selection");
	
	-- movement
	infotext:set_state_override("wh2.battle.intro.info_031", "battle_controls_unit_movement");
	infotext:set_state_override("wh2.battle.intro.info_051", "battle_controls_unit_destinations");
	infotext:set_state_override("wh2.battle.intro.info_052", "battle_controls_drag_out_formation");
	infotext:set_state_override("wh2.battle.intro.info_053", "battle_controls_halt");
	
	-- attacking
	infotext:set_state_override("wh2.battle.intro.info_061", "battle_controls_attacking");
	
end;



----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- cheat sheet functions
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------


function show_battle_controls_cheat_sheet(show_help_panel_close_button)
	core:call_once(
		"battle_controls_cheat_sheet",
		function()
			hp_controls_cheat_sheet:link_clicked();
			local hpm = get_help_page_manager();
			hpm:set_max_height(800);
			hpm:show_title_bar_buttons(false, show_help_panel_close_button);
		end	
	);
end;


function append_single_selection_controls_to_cheat_sheet()
	core:call_once(
		"append_single_selection_controls_to_cheat_sheet",
		function()
			hp_controls_cheat_sheet:append_help_page_record(hpr_title("war.battle.hp.controls_cheat_sheet.006"));
			hp_controls_cheat_sheet:append_help_page_record(hpr_battle_selection_controls("war.battle.hp.controls_cheat_sheet.007"));
		end	
	);
end;


function append_multiple_selection_controls_to_cheat_sheet()
	core:call_once(
		"append_multiple_selection_controls_to_cheat_sheet",
		function()
			hp_controls_cheat_sheet:append_help_page_record(hpr_battle_multiple_selection_controls("war.battle.hp.controls_cheat_sheet.008"));
		end	
	);
end;


function append_single_movement_controls_to_cheat_sheet()
	core:call_once(
		"append_single_movement_controls_to_cheat_sheet",
		function()
			hp_controls_cheat_sheet:append_help_page_record(hpr_title("war.battle.hp.controls_cheat_sheet.009"));
			hp_controls_cheat_sheet:append_help_page_record(hpr_battle_movement_controls("war.battle.hp.controls_cheat_sheet.010"));
		end	
	);
end;


function append_selection_controls_to_cheat_sheet()
	append_single_selection_controls_to_cheat_sheet();
	append_multiple_selection_controls_to_cheat_sheet();
	append_movement_controls_to_cheat_sheet();
end;


function append_movement_controls_to_cheat_sheet()
	core:call_once(
		"append_movement_controls_to_cheat_sheet",
		function()
			hp_controls_cheat_sheet:append_help_page_record(hpr_battle_drag_out_formation_controls("war.battle.hp.controls_cheat_sheet.011"));
			hp_controls_cheat_sheet:append_help_page_record(hpr_battle_unit_destination_controls("war.battle.hp.controls_cheat_sheet.012"));
			-- hp_controls_cheat_sheet:append_help_page_record(hpr_battle_halt_controls("war.battle.hp.controls_cheat_sheet.013"));
		end	
	);
end;

function append_movement_dragging_controls_to_cheat_sheet_to_cheat_sheet()
	core:call_once(
		"append_movement_dragging_controls_to_cheat_sheet",
		function()
			hp_controls_cheat_sheet:append_help_page_record(hpr_battle_drag_out_formation_controls("war.battle.hp.controls_cheat_sheet.011"))
		end	
	)
end;

function append_unit_destination_controls_to_cheat_sheet()
	core:call_once(
		"append_unit_destination_to_cheat_sheet",
		function()
			hp_controls_cheat_sheet:append_help_page_record(hpr_battle_unit_destination_controls("war.battle.hp.controls_cheat_sheet.012"))
		end	
	);
end;


function append_attack_controls_to_cheat_sheet()
	core:call_once(
		"append_attack_controls_to_cheat_sheet",
		function()
			hp_controls_cheat_sheet:append_help_page_record(hpr_battle_attack_controls("war.battle.hp.controls_cheat_sheet.014"));
		end	
	);
end;
