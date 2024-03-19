

-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	HELP PAGE SCRIPTS
--	Campaign help pages are defined here
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

function setup_campaign_help_pages()

	out.help_pages("");
	out.help_pages("***");
	out.help_pages("*** setup_campaign_help_pages() called");
	out.help_pages("***");
	
	local ui_root = core:get_ui_root();

	local campaign_name = cm:get_campaign_name();
	
	local local_faction = cm:get_local_faction_name(true);
	
	--	Setup link parser
	--	This parses [[sl:link]]text[[/sl]] links in help page records	
	local parser = get_link_parser();	
	
	-- Set up help page to info button mapping
	-- (this is for the ? button on each panel)
	local hpm = get_help_page_manager();

	local script_feature_name = "";
	
	-- first argument is the help page link name, second is a unique parent name of the button (doesn't have to be immediate parent)
	-- Supply an optional third parameter - this should be a function that returns true or false
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_province_overview_panel", "settlement_panel");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_war_coordination", "war_coordination_panel");		-- needs to be above "diplomacy_dropdown"
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_faction_summary_screen", "clan");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_treasury_panel", "finance_screen");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_missions", "objectives_screen");	
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_pre_battle_panel", "battle_information_panel");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_siege_panel", "siege_information_panel");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_post_battle_panel", "battle_results");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_slaves", "slaves_panel");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_the_menace_below", "ability_charge_panel");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_banners_and_marks", "ancillary_banners_background");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_character_details_panel", "character_details_panel");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_geomantic_web", "key_geomantic_web");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_winds_of_magic", "key_winds_of_magic");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_settlement_climates", "key_climate_suitability");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_skaven_corruption", "CcoCorruptionTypeRecordSKAVEN");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_vampiric_corruption", "CcoCorruptionTypeRecordVAMPIRE");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_chaos_corruption", "CcoCorruptionTypeRecordKHORNE");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_chaos_corruption", "CcoCorruptionTypeRecordNURGLE");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_chaos_corruption", "CcoCorruptionTypeRecordSLAANESH");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_chaos_corruption", "CcoCorruptionTypeRecordTZEENTCH");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_chaos_corruption", "CcoCorruptionTypeRecordCHAOS");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_growth", "key_region_growth");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_income", "key_region_wealth");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_public_order", "key_region_happiness");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_diplomacy", "key_diplomacy_status");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_diplomacy", "key_diplomacy_attitude_faction");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_diplomacy_screen", "diplomacy_dropdown");			-- needs to come after key_*
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_rituals", "chain_ritual_details");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_intervention_armies", "interrupt_options");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_books_of_nagash", "books_of_nagash");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_bloodlines", "bloodlines_panel");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_infamy", "infamy_tooltip");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_sacrifice_to_sotek", "sotek_sacrifice_panel");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_forbidden_workshop", "ikit_workshop_panel");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_defence_great_plan", "nakai_temples_panel");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_wulfharts_hunters", "hunters_panel");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_summon_elector_counts", "elector_counts");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_athel_tamarha", "athel_tamarha_dungeon");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_groms_cauldron", "groms_cauldron");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_flesh_lab", "augment_panel");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_forge_of_daith", "forge_of_daith_panel");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_rampage", "rampage_panel");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_dread", "beastmen_panel");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_oxyotl_visions", "threat_map_panel");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_changing_of_the_ways", "tzeentch_changing_of_ways");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_daemonic_glory", "daemonic_progression");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_plagues_of_nurgle", "nurgle_plagues");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_ice_court", "kislev_ice_court");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_motherland", "kislev_winter");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_atamans", "kislev_atamans");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_contracts", "ogre_contracts");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_meat", "ogre_great_maw");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_compass", "cathay_compass");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_compass", "dlc24_jade_compass");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_ivory_road", "cathay_caravans");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_military_convoys", "military_convoys");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_chaos_rifts", "rifts_panel");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_chaos_rifts", "teleport_panel");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_unholy_manifestations", "great_game_rituals");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_rites", "rituals_panel");				-- needs to come after unholy_manifestations
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_sea_lanes", "sea_lanes_panel");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_grudges", "book_of_grudges");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_hellforge", "hellforge_panel_main");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_matters_of_state", "dlc24_matters_of_state");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_schemes", "dlc24_schemes");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_witchs_hut", "dlc24_witches_hut");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_witchs_hut", "brews_holder");
	hpm:register_help_page_to_info_button_mapping("script_link_campaign_hexes", "dlc24_hex_rituals");
	
	hpm:register_help_page_to_info_button_mapping(
		"script_link_campaign_intrigue_at_the_court",
		"intrigue_panel",
		function()
			local faction = cm:get_faction(local_faction);
			return faction and faction:culture() == "wh2_main_hef_high_elves";
		end
	);
	
	hpm:register_help_page_to_info_button_mapping(
		"script_link_campaign_imperial_authority",
		"intrigue_panel",
		function()
			local faction = cm:get_faction(local_faction);
			return faction and faction:culture() == "wh_main_emp_empire";
		end
	);

	hpm:register_help_page_to_info_button_mapping(
		"script_link_campaign_meat", 
		"purchasable_effects",
		function()
			local faction = cm:get_faction(local_faction);
			return faction and faction:culture() == "wh3_main_ogr_ogre_kingdoms";
		end
	);
	
	hpm:register_help_page_to_info_button_mapping(
		"script_link_campaign_technology", 
		"technology_panel",
		function()
			local faction = cm:get_faction(local_faction);
			return faction and faction:culture() ~= "wh2_dlc09_tmb_tomb_kings";
		end
	);
	
	hpm:register_help_page_to_info_button_mapping(
		"script_link_campaign_dynasties", 
		"technology_panel",
		function()
			local faction = cm:get_faction(local_faction);
			return faction and faction:culture() == "wh2_dlc09_tmb_tomb_kings";
		end
	);
	
	hpm:register_help_page_to_info_button_mapping(
		"script_link_campaign_elven_council", 
		"offices",
		function()
			local faction = cm:get_faction(local_faction);
			return faction and faction:culture() == "wh_dlc05_wef_wood_elves";
		end
	);
	
	hpm:register_help_page_to_info_button_mapping(
		"script_link_campaign_fleet_office", 
		"offices",
		function()
			local faction = cm:get_faction(local_faction);
			local culture = faction:culture();
			return faction and faction:culture() == "wh2_dlc11_cst_vampire_coast";
		end
	);
	
	hpm:register_help_page_to_info_button_mapping(
		"script_link_campaign_offices", 
		"offices",
		function()
			local faction = cm:get_faction(local_faction);
			local culture = faction:culture();
			return faction and culture ~= "wh_dlc05_wef_wood_elves" and culture ~= "wh2_dlc11_cst_vampire_coast";
		end
	);
	
	hpm:register_help_page_to_info_button_mapping(
		"script_link_campaign_unit_recruitment",
		"recruitment_options",
		function()
			local uic_recruitment = find_uicomponent(ui_root, "hud_center", "button_group_army", "button_recruitment");
			
			return cm:get_local_faction_culture(true) ~= "wh3_main_nur_nurgle" and uic_recruitment and uic_recruitment:CurrentState() == "selected";
		end
	);

	hpm:register_help_page_to_info_button_mapping(
		"script_link_campaign_warbands", 
		"warband_upgrades", 
		function()
			return true
		end
	);
	
	hpm:register_help_page_to_info_button_mapping(
		"script_link_campaign_raising_dead",
		"recruitment_options",
		function()
			local uic_raise_dead = find_uicomponent(ui_root, "hud_center", "button_group_army", "button_mercenary_recruit_raise_dead");
			
			return uic_raise_dead and uic_raise_dead:CurrentState() == "selected";
		end
	);
	
	hpm:register_help_page_to_info_button_mapping(
		"script_link_campaign_summon_elector_counts",
		"recruitment_options",
		function()
			local uic_imperial_supply = find_uicomponent(ui_root, "hud_center", "button_group_army", "button_mercenary_recruit_imperial_supply");
			local faction = cm:get_faction(local_faction);
			return faction and faction:name() ~= "wh2_dlc13_emp_the_huntmarshals_expedition" and uic_imperial_supply and uic_imperial_supply:CurrentState() == "selected";
		end
	);
	
	hpm:register_help_page_to_info_button_mapping(
		"script_link_campaign_emperors_mandate",
		"recruitment_options",
		function()
			local uic_imperial_supply = find_uicomponent(ui_root, "hud_center", "button_group_army", "button_mercenary_recruit_imperial_supply");
			local faction = cm:get_faction(local_faction);
			return faction and faction:name() == "wh2_dlc13_emp_the_huntmarshals_expedition" and uic_imperial_supply and uic_imperial_supply:CurrentState() == "selected";
		end
	);
	
	hpm:register_help_page_to_info_button_mapping(
		"script_link_campaign_blessed_spawnings",
		"recruitment_options",
		function()
			local uic_blessed_spawning = find_uicomponent(ui_root, "hud_center", "button_group_army", "button_mercenary_recruit_blessed_spawning");
			
			return uic_blessed_spawning and uic_blessed_spawning:CurrentState() == "selected";
		end
	);
	
	hpm:register_help_page_to_info_button_mapping(
		"script_link_campaign_flesh_lab",
		"recruitment_options",
		function()
			local uic_flesh_lab = find_uicomponent(ui_root, "hud_center", "button_group_army", "button_mercenary_recruit_flesh_lab");
			
			return uic_flesh_lab and uic_flesh_lab:CurrentState() == "selected";
		end
	);
	
	hpm:register_help_page_to_info_button_mapping(
		"script_link_campaign_regiments_of_renown",
		"recruitment_options",
		function()
			local uic_regiments_of_renown = find_uicomponent(ui_root, "hud_center", "button_group_army", "button_mercenary_recruit_renown");
			
			return uic_regiments_of_renown and uic_regiments_of_renown:CurrentState() == "selected";
		end
	);

	hpm:register_help_page_to_info_button_mapping(
		"script_link_campaign_monster_pens",
		"recruitment_options",
		function()
			local uic_monster_pens = find_uicomponent(ui_root, "hud_center", "button_group_army", "button_mercenary_recruit_monster_pen");
			
			return uic_monster_pens and uic_monster_pens:CurrentState() == "selected";
		end
	);

	hpm:register_help_page_to_info_button_mapping(
		"script_link_campaign_nurgle",
		"recruitment_options",
		function()
			local uic_recruitment = find_uicomponent(ui_root, "hud_center", "button_group_army", "button_recruitment");
			
			return cm:get_local_faction_culture(true) == "wh3_main_nur_nurgle" and uic_recruitment and uic_recruitment:CurrentState() == "selected";
		end
	);

	hpm:register_help_page_to_info_button_mapping(
		"script_link_campaign_ogre_camps",
		"recruitment_options",
		function()
			local uic_mercenaries = find_uicomponent(ui_root, "hud_center", "button_group_army", "button_mercenary_recruit_mercenary_recruitment");
			
			return uic_mercenaries and uic_mercenaries:CurrentState() == "selected";
		end
	);
	
	hpm:register_help_page_to_info_button_mapping(
		"script_link_campaign_forest_spirits_animals",
		"main_units_panel",
		function()
			local uic_scrap = find_uicomponent(ui_root, "main_units_panel", "scrap_upgrades");
			return uic_scrap and uic_scrap:Visible(true) and cm:get_local_faction_culture(true) == "wh_dlc05_wef_wood_elves";
		end
	);
	
	hpm:register_help_page_to_info_button_mapping(
		"script_link_campaign_salvage",
		"main_units_panel",
		function()
			local uic_scrap = find_uicomponent(ui_root, "main_units_panel", "scrap_upgrades");
			return uic_scrap and uic_scrap:Visible(true) and cm:get_local_faction_culture(true) == "wh_main_grn_greenskins";
		end
	);

	hpm:register_help_page_to_info_button_mapping(
		"script_link_campaign_building_panel", 
		"main_units_panel", 
		function()
			local force_type = cuim:get_mf_selected_type();
			return force_type == "HORDE";
		end
	);

	hpm:register_help_page_to_info_button_mapping(
		"script_link_campaign_disciple_armies", 
		"main_units_panel", 
		function()
			local force_type = cuim:get_mf_selected_type();
			return force_type == "DISCIPLE_ARMY";
		end
	);

	hpm:register_help_page_to_info_button_mapping(
		"script_link_campaign_ogre_camps", 
		"main_units_panel", 
		function()
			local force_type = cuim:get_mf_selected_type();
			return force_type == "OGRE_CAMP";
		end
	);

	hpm:register_help_page_to_info_button_mapping(
		"script_link_campaign_army_panel", 
		"main_units_panel", 
		function()
			local force_type = cuim:get_mf_selected_type();
			return force_type ~= "HORDE" and force_type ~= "DISCIPLE_ARMY" and force_type ~= "OGRE_CAMP" 
		end
	);

	
	hpm:register_help_page_to_info_button_mapping(
		"script_link_campaign_raising_forces", 
		"character_panel",
		function()		
			local uic_settlement = find_uicomponent(ui_root, "hud_center", "button_group_settlement", "button_create_army");
			
			if uic_settlement and uic_settlement:CurrentState() == "selected" then
				return true;
			end;
		
			-- horde army
			local uic_horde_army = find_uicomponent(ui_root, "hud_center", "button_group_army_settled", "button_create_army");
			
			if uic_horde_army and uic_horde_army:CurrentState() == "selected" then
				return true;
			end;
			
			return false;
		end
	);
	
	hpm:register_help_page_to_info_button_mapping(
		"script_link_campaign_recruit_hero_panel", 
		"character_panel", 
		function()		
			local uic_settlement = find_uicomponent(ui_root, "hud_center", "button_group_settlement", "button_agents");
			
			if uic_settlement and uic_settlement:CurrentState() == "selected" then
				return true;
			end;
		
			-- horde army
			local uic_horde_army = find_uicomponent(ui_root, "hud_center", "button_group_army_settled", "button_agents");
			
			if uic_horde_army and uic_horde_army:CurrentState() == "selected" then
				return true;
			end;
			
			return false;
		end
	);
	
	hpm:register_help_page_to_info_button_mapping(
		"script_link_campaign_black_arks", 
		"character_panel", 
		function()		
			local uic_recruit_black_ark = find_uicomponent(ui_root, "hud_center", "button_group_settlement", "button_sea_locked_general");
			
			if uic_recruit_black_ark and uic_recruit_black_ark:CurrentState() == "selected" then
				return true;
			end;
			
			return false;
		end
	);

	hpm:register_help_page_to_info_button_mapping(
		"script_link_campaign_military_convoys", 
		"character_panel",
		function()		
			local uic_military_convoys_button = find_uicomponent(ui_root, "military_convoys", "header_container", "button_info");
			
			if uic_military_convoys_button and uic_military_convoys_button:CurrentState() == "selected" then
				return true;
			end;
			
			return false;
		end
	);
	
	hpm:register_help_page_to_info_button_mapping(
		"script_link_campaign_ivory_road", 
		"character_panel",
		function()		
			local uic_ivory_road_button = find_uicomponent(ui_root, "button_caravan");
			
			if uic_ivory_road_button and uic_ivory_road_button:CurrentState() == "selected" then
				return true;
			end;
			
			return false;
		end
	);

	hpm:register_help_page_to_info_button_mapping(
		"script_link_campaign_mortuary_cult", 
		"mortuary_cult",
		function()
			local faction = cm:get_faction(local_faction);
			return faction and faction:culture() == "wh2_dlc09_tmb_tomb_kings";
		end
	);
	
	hpm:register_help_page_to_info_button_mapping(
		"script_link_campaign_forging_magic_items", 
		"mortuary_cult",
		function()
			local faction = cm:get_faction(local_faction);
			return faction and faction:culture() ~= "wh2_dlc09_tmb_tomb_kings";
		end
	);

	hpm:register_help_page_to_info_button_mapping(
		"script_link_campaign_intrigue_at_the_court", 
		"intrigue_panel",
		function()
			local faction = cm:get_faction(local_faction);
			return faction and faction:culture() == "wh2_main_hef_high_elves";
		end
	);

	hpm:register_help_page_to_info_button_mapping(
		"script_link_campaign_empire",										-- replace me - electoral_machinations
		"intrigue_panel",
		function()
			local faction = cm:get_faction(local_faction);
			return faction and faction:culture() == "wh_main_emp_empire";
		end
	);
	
	hpm:register_help_page_to_info_button_mapping(
		"script_link_campaign_treasure_maps", 
		"treasure_hunts", 
		function()
			local uic = find_uicomponent(ui_root, "treasure_hunts", "hunts");
			return uic and uic:CurrentState() == "selected";
		end
	);
	hpm:register_help_page_to_info_button_mapping(
		"script_link_campaign_pieces_of_eight", 
		"treasure_hunts", 
		function()
			local uic = find_uicomponent(ui_root, "treasure_hunts", "pieces");
			return uic and uic:CurrentState() == "selected";
		end
	);

	hpm:register_help_page_to_info_button_mapping(
		"script_link_campaign_drill_of_hashut", 
		"chd_narrative_panel", 
		function()
			local uic = find_uicomponent(ui_root, "chd_narrative_panel");
			local state = uic:CurrentState();
			return uic and uic:CurrentState() == "NewState";
		end
	);


	-------------------------------------------------------------------------------------------------------------------------
	--
	-- Context Visibility Monitor
	--
	-- This script listens for events from the context system that are set up to trigger when component visibility/state/context etc
	-- changes and activates the link parser over certain component paths. This allows [[sl]] tags to be parsed on event panels and
	-- other bits of UI.
	-------------------------------------------------------------------------------------------------------------------------

	local cvm = context_visibility_monitor:new();

	-- event panels
	cvm:add_map_parse_for_tooltips("event_quest_details_visibility_changed", 				{"events", "event_layouts", "mission_review", "dy_details_text"});
	cvm:add_map_parse_for_tooltips("event_quest_details_visibility_changed", 				{"events", "event_layouts", "mission_review", "description_view"});
	cvm:add_map_parse_for_tooltips("event_building_constructed_visibility_changed", 		{"events", "event_layouts", "building_constructed", "dy_details_text"});
	cvm:add_map_parse_for_tooltips("event_technology_advances_visibility_changed", 			{"events", "event_layouts", "technology_advances", "dy_short_descr"});
	cvm:add_map_parse_for_tooltips("event_incident_visibility_changed", 					{"events", "event_layouts", "incident", "dy_details_text"});
	cvm:add_map_parse_for_tooltips("event_incident_large_visibility_changed", 				{"events", "event_layouts", "incident_large", "dy_description"});
	cvm:add_map_parse_for_tooltips("event_recruitment_visibility_changed", 					{"events", "event_layouts", "recruitment", "dy_description"});
	cvm:add_map_parse_for_tooltips("event_winds_of_magic_visibility_changed", 				{"events", "event_layouts", "winds_of_magic", "dy_details_text"});
	cvm:add_map_parse_for_tooltips("event_mercenary_unit_unlock_visibility_changed", 		{"events", "event_layouts", "mercenary_unit_unlock", "dy_description"});
	cvm:add_map_parse_for_tooltips("event_agent_targets_settlement_visibility_changed", 	{"events", "event_layouts", "agent_targets_settlement", "dy_details_text"});
	cvm:add_map_parse_for_tooltips("event_agent_targets_character_visibility_changed", 		{"events", "event_layouts", "agent_targets_character", "dy_details_text"});
	cvm:add_map_parse_for_tooltips("event_rank_gained_visibility_changed", 					{"events", "event_layouts", "rank_gained", "dy_details_text"});
	cvm:add_map_parse_for_tooltips("event_faction_visibility_changed", 						{"events", "event_layouts", "faction", "dy_details_text"});
	cvm:add_map_parse_for_tooltips("event_battle_result_visibility_changed", 				{"events", "event_layouts", "battle_result", "dy_details_text"});
	cvm:add_map_parse_for_tooltips("event_pop_surplus_visibility_changed", 					{"events", "event_layouts", "pop_surplus", "dy_details_text"});
	cvm:add_map_parse_for_tooltips("event_hostile_action_visibility_changed", 				{"events", "event_layouts", "hostile_action", "dy_details_text"});
	cvm:add_map_parse_for_tooltips("event_dilemma_review_visibility_changed", 				{"events", "event_layouts", "dilemma_review", "dy_details_text"});
	cvm:add_map_parse_for_tooltips("event_training_dilemma_visibility_changed", 			{"events", "event_layouts", "training_dilemma_available", "dy_details_text"});
	cvm:add_map_parse_for_tooltips("event_standard_visibility_changed", 					{"events", "event_layouts", "standard", "description_view"});

	-- objectives screen
	cvm:add_map_parse_for_tooltips("objectives_panel_context_changed", 						{"objectives_screen", "mission_details_list", "tab_details_child", "dy_description"});

	core:add_listener(
		"context_visibility_monitor_full_events_update",
		"EventMessageOpenedCampaign",
		true,
		function()
			cvm:event_triggered("event_quest_details_visibility_changed");
			cvm:event_triggered("event_building_constructed_visibility_changed");
			cvm:event_triggered("event_technology_advances_visibility_changed");
			cvm:event_triggered("event_incident_visibility_changed");
			cvm:event_triggered("event_incident_large_visibility_changed");
			cvm:event_triggered("event_recruitment_visibility_changed");
			cvm:event_triggered("event_winds_of_magic_visibility_changed");
			cvm:event_triggered("event_mercenary_unit_unlock_visibility_changed");
			cvm:event_triggered("event_agent_targets_settlement_visibility_changed");
			cvm:event_triggered("event_agent_targets_character_visibility_changed");
			cvm:event_triggered("event_rank_gained_visibility_changed");
			cvm:event_triggered("event_faction_visibility_changed");
			cvm:event_triggered("event_battle_result_visibility_changed");
			cvm:event_triggered("event_pop_surplus_visibility_changed");
			cvm:event_triggered("event_hostile_action_visibility_changed");
			cvm:event_triggered("event_dilemma_review_visibility_changed");
			cvm:event_triggered("event_training_dilemma_visibility_changed");
			cvm:event_triggered("event_standard_visibility_changed");
		end,
		true
	);


	core:add_listener(
		"context_visibility_monitor_full_update",
		"ComponentLClickUp",
		function(context)
			return uicomponent_descended_from(UIComponent(context.component), "pinned_missions_list");
		end,
		function()
			cvm:event_triggered("objectives_panel_context_changed");
		end,
		true
	);









	
	-- campaign index page
	hpm:register_hyperlink_click_listener("script_link_campaign_index", function() hpm:show_index() end);
	parser:add_record("campaign_index", "script_link_campaign_index", "tooltip_campaign_index");
		







	-------------------------------------------------------------------------------------------------------------------------
	--
	-- campaign_contents
	--
	-------------------------------------------------------------------------------------------------------------------------

	hp_contents = help_page:new(
		"script_link_campaign_contents",
		hpr_right_aligned("war.camp.hp.contents.001"),

		hpr_section("campaign_game"),
		hpr_title("war.camp.hp.contents.010", "campaign_game"),
		hpr_image("war.camp.hp.contents.011", "UI/help_images/campaign_game.png", "campaign_game"),
		hpr_normal("war.camp.hp.contents.012", "campaign_game"),
		hpr_section_index("campaign_game", "campaign_campaign_map"),

		hpr_section("realm_of_chaos"),
		hpr_title("war.camp.hp.contents.020", "realm_of_chaos"),
		hpr_image("war.camp.hp.contents.021", "UI/help_images/realm_of_chaos.png", "realm_of_chaos"),
		hpr_normal("war.camp.hp.contents.022", "realm_of_chaos"),
		hpr_section_index("realm_of_chaos", "campaign_ursun"),

		hpr_section("chaos"),
		hpr_title("war.camp.hp.contents.030", "chaos"),
		hpr_image("war.camp.hp.contents.031", "UI/help_images/chaos.png", "chaos"),
		hpr_normal("war.camp.hp.contents.032", "chaos"),
		hpr_section_index("chaos", "campaign_the_great_game"),

		hpr_section("races"),
		hpr_title("war.camp.hp.contents.040", "races"),
		hpr_image("war.camp.hp.contents.041", "UI/help_images/races.png", "races"),
		hpr_normal("war.camp.hp.contents.042", "races"),
		hpr_section_index("races", "campaign_daemons_of_chaos", "campaign_high_elves", false, "random_localisation_strings_string_help_pages_expand_warhammer_3_races"),
		hpr_section_index("races", "campaign_high_elves", "campaign_empire", false, "random_localisation_strings_string_help_pages_expand_warhammer_2_races"),
		hpr_section_index("races", "campaign_empire", nil, false, "random_localisation_strings_string_help_pages_expand_warhammer_1_races"),

		hpr_section("factions"),
		hpr_title("war.camp.hp.contents.050", "factions"),
		hpr_image("war.camp.hp.contents.051", "UI/help_images/factions.png", "factions"),
		hpr_normal("war.camp.hp.contents.052", "factions"),
		hpr_section_index("factions", "campaign_money"),

		hpr_section("diplomacy"),
		hpr_title("war.camp.hp.contents.060", "diplomacy"),
		hpr_image("war.camp.hp.contents.061", "UI/help_images/diplomacy.png", "diplomacy"),
		hpr_normal("war.camp.hp.contents.062", "diplomacy"),
		hpr_section_index("diplomacy", "campaign_alliances"),

		hpr_section("provinces"),
		hpr_title("war.camp.hp.contents.070", "provinces"),
		hpr_image("war.camp.hp.contents.071", "UI/help_images/provinces.png", "provinces"),
		hpr_normal("war.camp.hp.contents.072", "provinces"),
		hpr_section_index("provinces", "campaign_province_management"),

		hpr_section("characters"),
		hpr_title("war.camp.hp.contents.090", "characters"),
		hpr_image("war.camp.hp.contents.091", "UI/help_images/characters.png", "characters"),
		hpr_normal("war.camp.hp.contents.092", "characters"),
		hpr_section_index("characters", "campaign_heroes"),

		hpr_section("armies"),
		hpr_title("war.camp.hp.contents.100", "armies"),
		hpr_image("war.camp.hp.contents.101", "UI/help_images/armies.png", "armies"),
		hpr_normal("war.camp.hp.contents.102", "armies"),
		hpr_section_index("armies", "campaign_army_movement"),
		
		hpr_section("battles"),
		hpr_title("war.camp.hp.contents.120", "battles"),
		hpr_image("war.camp.hp.contents.121", "UI/help_images/battles.png", "battles"),
		hpr_normal("war.camp.hp.contents.122", "battles"),
		hpr_section_index("battles", "campaign_pre_battle_options")
	);
	parser:add_record("campaign_contents", "script_link_campaign_contents", "tooltip_campaign_contents");
	

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
	-- advice_history_buttons
	--

	parser:add_record("campaign_advice_history_buttons", "script_link_campaign_advice_history_buttons", "tooltip_campaign_advice_history_buttons");
	tp_advice_history_buttons = tooltip_patcher:new("tooltip_campaign_advice_history_buttons");
	tp_advice_history_buttons:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_advice_history_buttons");
	
	tl_advice_history_buttons = tooltip_listener:new(
		"tooltip_campaign_advice_history_buttons", 
		function() 
			uim:highlight_advice_history_buttons(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);

	
	--
	-- advisor
	--

	hp_advisor = help_page:new(
		"script_link_campaign_advisor",
		hpr_title("war.camp.hp.advisor.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/advisor.png"),
		hpr_leader("war.camp.hp.advisor.002"),
		hpr_normal("war.camp.hp.advisor.003"),
		hpr_normal("war.camp.hp.advisor.004"),
		hpr_normal("war.camp.hp.advisor.005"),
		hpr_normal("war.camp.hp.advisor.007")
	);

	parser:add_record("campaign_advisor", "script_link_campaign_advisor", "tooltip_campaign_advisor");
	tp_advisor = tooltip_patcher:new("tooltip_campaign_advisor");
	tp_advisor:set_layout_data(
		"tooltip_title_text_and_image", 
		"ui_text_replacements_localised_text_hp_campaign_title_advisor", 
		"ui_text_replacements_localised_text_hp_campaign_description_advisor",
		"UI/help_images/advisor.png"
	);
	
	tl_advisor = tooltip_listener:new(
		"tooltip_campaign_advisor", 
		function() 
			uim:highlight_advisor(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- advisor_link
	--
	
	parser:add_record("campaign_advisor_link", "script_link_campaign_advisor_link", "tooltip_campaign_advisor_link");
	tp_advisor = tooltip_patcher:new("tooltip_campaign_advisor_link");
	tp_advisor:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_advisor_link");
	
	tl_advisor_link = tooltip_listener:new(
		"tooltip_campaign_advisor_link", 
		function() 
			uim:highlight_advisor(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- advisor_button
	--

	parser:add_record("campaign_advisor_button", "script_link_campaign_advisor_button", "tooltip_campaign_advisor_button");
	tp_advisor_button = tooltip_patcher:new("tooltip_campaign_advisor_button");
	tp_advisor_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_advisor_button");
	
	tl_advisor_button = tooltip_listener:new(
		"tooltip_campaign_advisor_button", 
		function() 
			uim:highlight_advisor_button(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- allegiance
	--

	hp_allegiance = help_page:new(
		"script_link_campaign_allegiance",
		-- hpr_small("war.camp.hp.allegiance.path"),
		hpr_title("war.camp.hp.allegiance.001"),
		hpr_leader("war.camp.hp.allegiance.002"),
		hpr_normal("war.camp.hp.allegiance.003"),

		hpr_section("earning"),
		hpr_normal_unfaded("war.camp.hp.allegiance.004", "earning"),
		hpr_normal("war.camp.hp.allegiance.005", "earning"),

		hpr_section("using"),
		hpr_normal_unfaded("war.camp.hp.allegiance.006", "using"),
		hpr_normal("war.camp.hp.allegiance.007", "using"),
		hpr_normal("war.camp.hp.allegiance.008", "using")
	);
	parser:add_record("campaign_allegiance", "script_link_campaign_allegiance", "tooltip_campaign_allegiance");
	tp_allegiance = tooltip_patcher:new("tooltip_campaign_allegiance");
	tp_allegiance:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_allegiance", "ui_text_replacements_localised_text_hp_campaign_description_allegiance");
	
	
	--
	-- alliances
	--

	hp_alliances = help_page:new(
		"script_link_campaign_alliances",
		hpr_title("war.camp.hp.alliances.001"),
		hpr_leader("war.camp.hp.alliances.002"),
		hpr_normal("war.camp.hp.alliances.003"),
		hpr_normal("war.camp.hp.alliances.004"),

		hpr_section("defensive"),
		hpr_normal_unfaded("war.camp.hp.alliances.005", "defensive"),
		hpr_normal("war.camp.hp.alliances.006", "defensive"),

		hpr_section("military"),
		hpr_normal_unfaded("war.camp.hp.alliances.007", "military"),
		hpr_normal("war.camp.hp.alliances.008", "military"),

		hpr_normal("war.camp.hp.alliances.009"),
		hpr_normal("war.camp.hp.alliances.010")
	);
	parser:add_record("campaign_alliances", "script_link_campaign_alliances", "tooltip_campaign_alliances");
	tp_alliances = tooltip_patcher:new("tooltip_campaign_alliances");
	tp_alliances:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_alliances", "ui_text_replacements_localised_text_hp_campaign_description_alliances");



	--
	-- allied_recruitment_panel
	--

	parser:add_record("campaign_allied_recruitment_panel", "script_link_campaign_allied_recruitment_panel", "tooltip_campaign_allied_recruitment_panel");
	tp_allied_recruitment_panel = tooltip_patcher:new("tooltip_campaign_allied_recruitment_panel");
	tp_allied_recruitment_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_allied_recruitment_panel");
	
	tl_allied_recruitment_panel = tooltip_listener:new(
		"tooltip_campaign_allied_recruitment_panel", 
		function() 
			uim:highlight_allied_recruitment(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- amanar
	--

	hp_amanar = help_page:new(
		"script_link_campaign_amanar",
		hpr_title("war.camp.hp.amanar.001"),
		hpr_leader("war.camp.hp.amanar.002"),
		hpr_normal("war.camp.hp.amanar.003"),
		hpr_normal("war.camp.hp.amanar.004"),
		hpr_normal("war.camp.hp.amanar.005")
	);
	parser:add_record("campaign_amanar", "script_link_campaign_amanar", "tooltip_campaign_amanar");
	tp_amanar = tooltip_patcher:new("tooltip_campaign_amanar");
	tp_amanar:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_amanar", "ui_text_replacements_localised_text_hp_campaign_description_amanar");
	
	
	
	--
	-- amber
	--

	hp_amber = help_page:new(
		"script_link_campaign_amber",
		hpr_title("war.camp.hp.amber.001"),
		hpr_leader("war.camp.hp.amber.002"),
		hpr_normal("war.camp.hp.amber.003"),
		hpr_normal("war.camp.hp.amber.004")
	);
	parser:add_record("campaign_amber", "script_link_campaign_amber", "tooltip_campaign_amber");
	tp_amber = tooltip_patcher:new("tooltip_campaign_amber");
	tp_amber:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_amber", "ui_text_replacements_localised_text_hp_campaign_description_amber");
	
	tl_amber = tooltip_listener:new(
		"tooltip_campaign_amber", 
		function()
			uim:highlight_food(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	


	--
	-- ambushes
	--

	hp_ambushes = help_page:new(
		"script_link_campaign_ambushes",
		hpr_title("war.camp.hp.ambushes.001"),
		hpr_leader("war.camp.hp.ambushes.002"),
		hpr_normal("war.camp.hp.ambushes.003"),
		hpr_normal("war.camp.hp.ambushes.004"),
		hpr_normal("war.camp.hp.ambushes.005"),
		hpr_normal("war.camp.hp.ambushes.006"),
		hpr_normal("war.camp.hp.ambushes.007")
	);
	parser:add_record("campaign_ambushes", "script_link_campaign_ambushes", "tooltip_campaign_ambushes");
	tp_ambushes = tooltip_patcher:new("tooltip_campaign_ambushes");
	tp_ambushes:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_ambushes", "ui_text_replacements_localised_text_hp_campaign_description_ambushes");
	
	
	
	--
	-- ariel
	--
	
	hp_armies = help_page:new(
		"script_link_campaign_ariel",
		hpr_title("war.camp.hp.wood_elves_ariel.001"),
		hpr_leader("war.camp.hp.wood_elves_ariel.002"),
		hpr_normal("war.camp.hp.wood_elves_ariel.003"),
		hpr_normal("war.camp.hp.wood_elves_ariel.004")
	);
	parser:add_record("campaign_ariel", "script_link_campaign_ariel", "tooltip_campaign_ariel");
	tp_ariel = tooltip_patcher:new("tooltip_campaign_ariel");
	tp_ariel:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_wood_elves_ariel", "ui_text_replacements_localised_text_hp_campaign_description_wood_elves_ariel");


	--
	-- armies
	--

	hp_armies = help_page:new(
		"script_link_campaign_armies",
		hpr_title("war.camp.hp.armies.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/armies.png"),
		hpr_leader("war.camp.hp.armies.002"),

		hpr_section("movement"),
		hpr_normal_unfaded("war.camp.hp.armies.003", "movement"),
		hpr_normal("war.camp.hp.armies.004", "movement"),
		hpr_normal("war.camp.hp.armies.005", "movement"),

		hpr_section("battles"),
		hpr_normal_unfaded("war.camp.hp.armies.006", "battles"),
		hpr_normal("war.camp.hp.armies.007", "battles"),
		hpr_normal("war.camp.hp.armies.008", "battles"),

		hpr_section("recruitment"),
		hpr_normal_unfaded("war.camp.hp.armies.009", "recruitment"),
		hpr_normal("war.camp.hp.armies.010", "recruitment"),

		hpr_section("lords"),
		hpr_normal_unfaded("war.camp.hp.armies.011", "lords"),
		hpr_normal("war.camp.hp.armies.012", "lords"),

		hpr_section("garrisons"),
		hpr_normal_unfaded("war.camp.hp.armies.013", "garrisons"),
		hpr_normal("war.camp.hp.armies.014", "garrisons"),

		hpr_section("raising_armies"),
		hpr_normal_unfaded("war.camp.hp.armies.015", "raising_armies"),
		hpr_normal("war.camp.hp.armies.016", "raising_armies"),

		hpr_normal("war.camp.hp.armies.017")
	);
	parser:add_record("campaign_armies", "script_link_campaign_armies", "tooltip_campaign_armies");
	tp_armies = tooltip_patcher:new("tooltip_campaign_armies");
	tp_armies:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_armies",
		"ui_text_replacements_localised_text_hp_campaign_description_armies", 
		"UI/help_images/armies.png"
	);
	
	tl_armies = tooltip_listener:new(
		"tooltip_campaign_armies", 
		function() uim:highlight_armies(true) end,
		function() uim:unhighlight_all_for_tooltips() end
	);


	--
	-- armies_at_sea
	--

	hp_armies_at_sea = help_page:new(
		"script_link_campaign_armies_at_sea",
		hpr_title("war.camp.hp.armies_at_sea.001"),
		hpr_leader("war.camp.hp.armies_at_sea.002"),
		hpr_normal("war.camp.hp.armies_at_sea.003"),
		hpr_normal("war.camp.hp.armies_at_sea.004"),
		hpr_normal("war.camp.hp.armies_at_sea.005"),
		
		hpr_section("battles"),
		hpr_normal_unfaded("war.camp.hp.armies_at_sea.006", "battles"),
		hpr_normal("war.camp.hp.armies_at_sea.007", "battles"),

		hpr_section("encounters"),
		hpr_normal_unfaded("war.camp.hp.armies_at_sea.008", "encounters"),
		hpr_normal("war.camp.hp.armies_at_sea.009", "encounters"),

		hpr_section("sea_lanes"),
		hpr_normal_unfaded("war.camp.hp.armies_at_sea.010", "sea_lanes"),
		hpr_normal("war.camp.hp.armies_at_sea.011", "sea_lanes")
	);
	parser:add_record("campaign_armies_at_sea", "script_link_campaign_armies_at_sea", "tooltip_campaign_armies_at_sea");
	tp_armies_at_sea = tooltip_patcher:new("tooltip_campaign_armies_at_sea");
	tp_armies_at_sea:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_armies_at_sea", "ui_text_replacements_localised_text_hp_campaign_description_armies_at_sea");
	
	tl_armies_at_sea = tooltip_listener:new(
		"tooltip_campaign_armies_at_sea", 
		function() 
			uim:highlight_armies_at_sea(true) 
		end,
		function() 
			uim:unhighlight_all_for_tooltips() 
		end
	);
	
	
	
	--
	-- armies_at_sea_link
	--
	
	parser:add_record("campaign_armies_at_sea_link", "script_link_campaign_armies_at_sea_link", "tooltip_campaign_armies_at_sea_link");
	tp_armies_at_sea = tooltip_patcher:new("tooltip_campaign_armies_at_sea_link");
	tp_armies_at_sea:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_armies_at_sea_link");
	
	tl_armies_at_sea_link = tooltip_listener:new(
		"tooltip_campaign_armies_at_sea_link",
		function()
			uim:highlight_armies_at_sea(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- armies_link
	--
	
	parser:add_record("campaign_armies_link", "script_link_campaign_armies_link", "tooltip_campaign_armies_link");
	tp_armies = tooltip_patcher:new("tooltip_campaign_armies_link");
	tp_armies:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_armies_link");
	
	tl_armies = tooltip_listener:new(
		"tooltip_campaign_armies_link",
		function()
			uim:highlight_armies(true)
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	


	--
	-- army_movement
	--

	hp_army_movement = help_page:new(
		"script_link_campaign_army_movement",
		hpr_title("war.camp.hp.army_movement.001"),
		hpr_leader("war.camp.hp.army_movement.002"),
		hpr_normal("war.camp.hp.army_movement.003"),
		hpr_normal("war.camp.hp.army_movement.004"),

		hpr_section("zoc"),
		hpr_normal_unfaded("war.camp.hp.army_movement.005", "zoc"),
		hpr_normal("war.camp.hp.army_movement.006", "zoc"),

		hpr_section("stances"),
		hpr_normal_unfaded("war.camp.hp.army_movement.007", "stances"),
		hpr_normal("war.camp.hp.army_movement.008", "stances"),
		hpr_normal("war.camp.hp.army_movement.009", "stances"),

		hpr_section("sea"),
		hpr_normal_unfaded("war.camp.hp.army_movement.010", "sea"),
		hpr_normal("war.camp.hp.army_movement.011", "sea")
	);
	parser:add_record("campaign_army_movement", "script_link_campaign_army_movement", "tooltip_campaign_army_movement");
	tp_army_movement = tooltip_patcher:new("tooltip_campaign_army_movement");
	tp_army_movement:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_army_movement", "ui_text_replacements_localised_text_hp_campaign_description_army_movement");



	--
	-- army_panel
	--

	hp_army_panel = help_page:new(
		"script_link_campaign_army_panel",
		hpr_title("war.camp.hp.army_panel.001"),
		hpr_leader("war.camp.hp.army_panel.002"),
		hpr_normal("war.camp.hp.army_panel.003"),
		hpr_normal("war.camp.hp.army_panel.004"),
		hpr_normal("war.camp.hp.army_panel.005"),
		hpr_normal("war.camp.hp.army_panel.006"),
		hpr_normal("war.camp.hp.army_panel.007")
	);
	parser:add_record("campaign_army_panel", "script_link_campaign_army_panel", "tooltip_campaign_army_panel");
	tp_army_panel = tooltip_patcher:new("tooltip_campaign_army_panel");
	tp_army_panel:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_army_panel", "ui_text_replacements_localised_text_hp_campaign_description_army_panel");

	tl_army_panel = tooltip_listener:new(
		"tooltip_campaign_army_panel", 
		function() 
			uim:highlight_army_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- army_panel_link
	--
	
	parser:add_record("campaign_army_panel_link", "script_link_campaign_army_panel_link", "tooltip_campaign_army_panel_link");
	tp_army_panel = tooltip_patcher:new("tooltip_campaign_army_panel_link");
	tp_army_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_army_panel_link");
	
	tl_army_panel_link = tooltip_listener:new(
		"tooltip_campaign_army_panel_link",
		function()
			uim:highlight_army_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);


	
	--
	-- artefact vault
	--

	hp_artefact_vault = help_page:new(
		"script_link_campaign_artefact_vault",
		hpr_title("war.camp.hp.thorek_artefacts.001"),
		hpr_leader("war.camp.hp.thorek_artefacts.002"),
		hpr_normal("war.camp.hp.thorek_artefacts.003"),
		hpr_normal("war.camp.hp.thorek_artefacts.004"),
		hpr_normal("war.camp.hp.thorek_artefacts.005")
	);
	parser:add_record("campaign_artefact_vault", "script_link_campaign_artefact_vault", "tooltip_campaign_artefact_vault");
	tp_artefact_vault = tooltip_patcher:new("tooltip_campaign_artefact_vault");
	tp_artefact_vault:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_thorek_artefacts", "ui_text_replacements_localised_text_hp_campaign_description_thorek_artefacts");
	
	tl_artefact_vault = tooltip_listener:new(
		"tooltip_campaign_artefact_vault", 
		function()
			uim:highlight_forging_magic_items_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- asrai lookouts
	--

	hp_asrai_lookouts = help_page:new(
		"script_link_campaign_asrai_lookouts",
		hpr_title("war.camp.hp.asrai_lookouts.001"),
		hpr_leader("war.camp.hp.asrai_lookouts.002"),
		hpr_normal("war.camp.hp.asrai_lookouts.003")
	);
	parser:add_record("campaign_asrai_lookouts", "script_link_campaign_asrai_lookouts", "tooltip_campaign_asrai_lookouts");
	tp_asrai_lookouts = tooltip_patcher:new("tooltip_campaign_asrai_lookouts");
	tp_asrai_lookouts:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_asrai_lookouts", "ui_text_replacements_localised_text_hp_campaign_description_asrai_lookouts");
	
	
	
	--
	-- astromancy
	--

	hp_astromancy = help_page:new(
		"script_link_campaign_astromancy",
		hpr_title("war.camp.hp.astromancy.001"),
		hpr_leader("war.camp.hp.astromancy.002"),
		hpr_normal("war.camp.hp.astromancy.003"),
		hpr_normal("war.camp.hp.astromancy.004"),
		hpr_normal("war.camp.hp.astromancy.005"),
		hpr_normal("war.camp.hp.astromancy.006")
	);
	parser:add_record("campaign_astromancy", "script_link_campaign_astromancy", "tooltip_campaign_astromancy");
	tp_astromancy = tooltip_patcher:new("tooltip_campaign_astromancy");
	tp_astromancy:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_astromancy", "ui_text_replacements_localised_text_hp_campaign_description_astromancy");



	--
	-- atamans
	--

	hp_atamans = help_page:new(
		"script_link_campaign_atamans",
		hpr_title("war.camp.hp.atamans.001"),
		hpr_leader("war.camp.hp.atamans.002"),
		hpr_normal("war.camp.hp.atamans.003"),
		hpr_normal("war.camp.hp.atamans.004"),
		hpr_normal("war.camp.hp.atamans.005"),
		hpr_normal("war.camp.hp.atamans.006")
	);
	parser:add_record("campaign_atamans", "script_link_campaign_atamans", "tooltip_campaign_atamans");
	tp_atamans = tooltip_patcher:new("tooltip_campaign_atamans");
	tp_atamans:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_atamans", "ui_text_replacements_localised_text_hp_campaign_description_atamans");

	tl_atamans = tooltip_listener:new(
		"tooltip_campaign_atamans", 
		function() 
			uim:highlight_atamans(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- atamans_link
	--
	script_feature_name = "atamans";
	parser:add_record("campaign_"..script_feature_name.."_link", "script_link_campaign_"..script_feature_name.."_link", "tooltip_campaign_"..script_feature_name.."_link");
	tp_atamans_link = tooltip_patcher:new("tooltip_campaign_"..script_feature_name.."_link");
	tp_atamans_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_"..script_feature_name.."_link");
	
	tl_atamans_link = tooltip_listener:new(
		"tooltip_campaign_"..script_feature_name.."_link",
		function()
			uim:highlight_atamans(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- atamans_button
	--

	parser:add_record("campaign_atamans_button", "script_link_campaign_atamans_button", "tooltip_campaign_atamans_button");
	tp_atamans_button = tooltip_patcher:new("tooltip_campaign_atamans_button");
	tp_atamans_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_atamans_button");
	
	tl_atamans_button = tooltip_listener:new(
		"tooltip_campaign_atamans_button", 
		function() 
			uim:highlight_ataman_button(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- atamans_panel
	--

	parser:add_record("campaign_atamans_panel", "script_link_campaign_atamans_panel", "tooltip_campaign_atamans_panel");
	tp_atamans_panel = tooltip_patcher:new("tooltip_campaign_atamans_panel");
	tp_atamans_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_atamans_panel");
	
	tl_atamans_panel = tooltip_listener:new(
		"tooltip_campaign_atamans_panel", 
		function() 
			uim:highlight_atamans(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- athel tamarha
	--
	
	hp_athel_tamarha = help_page:new(
		"script_link_campaign_athel_tamarha",
		hpr_title("war.camp.hp.high_elves_athel_tamarha.001"),
		hpr_leader("war.camp.hp.high_elves_athel_tamarha.002"),
		hpr_normal("war.camp.hp.high_elves_athel_tamarha.003"),
		hpr_normal("war.camp.hp.high_elves_athel_tamarha.004"),
		hpr_normal("war.camp.hp.high_elves_athel_tamarha.005"),
		hpr_normal("war.camp.hp.high_elves_athel_tamarha.006"),
		hpr_normal("war.camp.hp.high_elves_athel_tamarha.007")
	);
	parser:add_record("campaign_athel_tamarha", "script_link_campaign_athel_tamarha", "tooltip_campaign_athel_tamarha");
	tp_athel_tamarha = tooltip_patcher:new("tooltip_campaign_athel_tamarha");
	tp_athel_tamarha:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_high_elves_athel_tamarha", "ui_text_replacements_localised_text_hp_campaign_description_high_elves_athel_tamarha");
	

	
	--
	-- attrition
	--

	hp_attrition = help_page:new(
		"script_link_campaign_attrition",
		hpr_title("war.camp.hp.attrition.001"),
		hpr_leader("war.camp.hp.attrition.002"),
		hpr_normal("war.camp.hp.attrition.003"),
		hpr_normal("war.camp.hp.attrition.004"),
		hpr_normal("war.camp.hp.attrition.005"),
		hpr_normal("war.camp.hp.attrition.006"),
		hpr_normal("war.camp.hp.attrition.007")
	);
	parser:add_record("campaign_attrition", "script_link_campaign_attrition", "tooltip_campaign_attrition");
	tp_attrition = tooltip_patcher:new("tooltip_campaign_attrition");
	tp_attrition:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_attrition", "ui_text_replacements_localised_text_hp_campaign_description_attrition");


	
	--
	-- autoresolve_button
	--
	
	parser:add_record("campaign_autoresolve_button", "script_link_campaign_autoresolve_button", "tooltip_campaign_autoresolve_button");
	tp_autoresolve_button = tooltip_patcher:new("tooltip_campaign_autoresolve_button");
	tp_autoresolve_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_autoresolve_button");
	
	tl_autoresolve_button = tooltip_listener:new(
		"tooltip_campaign_autoresolve_button",
		function()
			uim:highlight_autoresolve_button(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- autoresolving
	--

	hp_autoresolving = help_page:new(
		"script_link_campaign_autoresolving",
		hpr_title("war.camp.hp.autoresolving.001"),
		hpr_leader("war.camp.hp.autoresolving.002"),
		hpr_normal("war.camp.hp.autoresolving.003"),
		hpr_normal("war.camp.hp.autoresolving.004")
	);
	parser:add_record("campaign_autoresolving", "script_link_campaign_autoresolving", "tooltip_campaign_autoresolving");
	tp_autoresolving = tooltip_patcher:new("tooltip_campaign_autoresolving");
	tp_autoresolving:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_autoresolving", "ui_text_replacements_localised_text_hp_campaign_description_autoresolving");

	tl_autoresolving = tooltip_listener:new(
		"tooltip_campaign_autoresolving",
		function()
			uim:highlight_autoresolve_button(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- balance_of_power_bar
	--

	parser:add_record("campaign_balance_of_power_bar", "script_link_campaign_balance_of_power_bar", "tooltip_campaign_balance_of_power_bar");
	tp_balance_of_power_bar = tooltip_patcher:new("tooltip_campaign_balance_of_power_bar");
	tp_balance_of_power_bar:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_balance_of_power_bar");
	
	tl_balance_of_power_bar = tooltip_listener:new(
		"tooltip_campaign_balance_of_power_bar", 
		function() 
			uim:highlight_balance_of_power_bar(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	--
	-- bankruptcy
	--

	hp_bankruptcy = help_page:new(
		"script_link_campaign_bankruptcy",
		hpr_title("war.camp.hp.bankruptcy.001"),
		hpr_leader("war.camp.hp.bankruptcy.002"),
		hpr_normal("war.camp.hp.bankruptcy.003"),
		hpr_normal("war.camp.hp.bankruptcy.004"),
		hpr_normal("war.camp.hp.bankruptcy.005")
	);
	parser:add_record("campaign_bankruptcy", "script_link_campaign_bankruptcy", "tooltip_campaign_bankruptcy");
	tp_bankruptcy = tooltip_patcher:new("tooltip_campaign_bankruptcy");
	tp_bankruptcy:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_bankruptcy", "ui_text_replacements_localised_text_hp_campaign_description_bankruptcy");



	--
	-- banners and marks
	--

	hp_banners_and_marks = help_page:new(
		"script_link_campaign_banners_and_marks",
		hpr_title("war.camp.hp.banners_and_marks.001"),
		hpr_leader("war.camp.hp.banners_and_marks.002"),
		hpr_normal("war.camp.hp.banners_and_marks.003"),
		hpr_normal("war.camp.hp.banners_and_marks.004"),
		hpr_normal("war.camp.hp.banners_and_marks.005")
	);
	parser:add_record("campaign_banners_and_marks", "script_link_campaign_banners_and_marks", "tooltip_campaign_banners_and_marks");
	tp_banners_and_marks = tooltip_patcher:new("tooltip_campaign_banners_and_marks");
	tp_banners_and_marks:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_banners_and_marks", "ui_text_replacements_localised_text_hp_campaign_description_banners_and_marks");
	
	tl_banners_and_marks = tooltip_listener:new(
		"tooltip_campaign_banners_and_marks",
		function()
			uim:highlight_banners_and_marks(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- banners_and_marks_link
	--
	
	parser:add_record("campaign_banners_and_marks_link", "script_link_campaign_banners_and_marks_link", "tooltip_campaign_banners_and_marks_link");
	tp_banners_and_marks = tooltip_patcher:new("tooltip_campaign_banners_and_marks_link");
	tp_banners_and_marks:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_banners_and_marks_link");
	
	tl_banners_and_marks = tooltip_listener:new(
		"tooltip_campaign_banners_and_marks_link",
		function()
			uim:highlight_banners_and_marks(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- battles
	--

	hp_battles = help_page:new(
		"script_link_campaign_battles",
		hpr_title("war.camp.hp.battles.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/battles.png"),
		hpr_leader("war.camp.hp.battles.002"),
		hpr_normal("war.camp.hp.battles.003"),
		hpr_normal("war.camp.hp.battles.004"),
		hpr_normal("war.camp.hp.battles.005"),
		hpr_normal("war.camp.hp.battles.006"),
		hpr_normal("war.camp.hp.battles.007"),
		hpr_normal("war.camp.hp.battles.009")
	);
	parser:add_record("campaign_battles", "script_link_campaign_battles", "tooltip_campaign_battles");
	tp_battles = tooltip_patcher:new("tooltip_campaign_battles");
	tp_battles:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_battles",
		"ui_text_replacements_localised_text_hp_campaign_description_battles", 
		"UI/help_images/battles.png"
	);
	
	
	
	--
	-- bestial_rage
	--

	hp_bestial_rage = help_page:new(
		"script_link_campaign_bestial_rage",
		hpr_title("war.camp.hp.bestial_rage.001"),
		hpr_leader("war.camp.hp.bestial_rage.002"),
		hpr_normal("war.camp.hp.bestial_rage.003"),
		hpr_normal("war.camp.hp.bestial_rage.004"),
		hpr_normal("war.camp.hp.bestial_rage.005"),
		hpr_normal("war.camp.hp.bestial_rage.006")
	);
	parser:add_record("campaign_bestial_rage", "script_link_campaign_bestial_rage", "tooltip_campaign_bestial_rage");
	tp_bestial_rage = tooltip_patcher:new("tooltip_campaign_bestial_rage");
	tp_bestial_rage:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_bestial_rage", "ui_text_replacements_localised_text_hp_campaign_description_bestial_rage");
	
	tl_bestial_rage = tooltip_listener:new(
		"tooltip_campaign_bestial_rage", 
		function()
			if local_faction and cm:get_faction(local_faction):culture() == "wh_dlc03_bst_beastmen" then
				uim:highlight_fightiness_bar(true);
			end;
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	--
	-- bestial_rage_link
	--

	parser:add_record("campaign_bestial_rage_link", "script_link_campaign_bestial_rage_link", "tooltip_campaign_bestial_rage_link");
	tp_bestial_rage_link = tooltip_patcher:new("tooltip_campaign_bestial_rage_link");
	tp_bestial_rage_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_bestial_rage_link");

	tl_bestial_rage_link = tooltip_listener:new(
		"tooltip_campaign_bestial_rage_link", 
		function()
			if local_faction and cm:get_faction(local_faction):culture() == "wh_dlc03_bst_beastmen" then
				uim:highlight_fightiness_bar(true);
			end;
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
		
	
	
	--
	-- beast_paths
	--

	hp_beast_paths = help_page:new(
		"script_link_campaign_beast_paths",
		hpr_title("war.camp.hp.beast_paths.001"),
		hpr_leader("war.camp.hp.beast_paths.002"),
		hpr_normal("war.camp.hp.beast_paths.003"),
		hpr_normal("war.camp.hp.beast_paths.004"),
		hpr_normal("war.camp.hp.beast_paths.005"),
		hpr_normal("war.camp.hp.beast_paths.006")
	);
	parser:add_record("campaign_beast_paths", "script_link_campaign_beast_paths", "tooltip_campaign_beast_paths");
	tp_beast_paths = tooltip_patcher:new("tooltip_campaign_beast_paths");
	tp_beast_paths:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_beast_paths", "ui_text_replacements_localised_text_hp_campaign_description_beast_paths");
	
	
	
	--
	-- beastmen
	--

	hp_beastmen = help_page:new(
		"script_link_campaign_beastmen",
		hpr_title("war.camp.hp.beastmen.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/beastmen.png"),
		hpr_leader("war.camp.hp.beastmen.002"),
		hpr_normal("war.camp.hp.beastmen.003"),
		hpr_normal("war.camp.hp.beastmen.004"),
		hpr_normal("war.camp.hp.beastmen.005"),
		hpr_normal("war.camp.hp.beastmen.006"),
		hpr_normal("war.camp.hp.beastmen.007")
	);
	parser:add_record("campaign_beastmen", "script_link_campaign_beastmen", "tooltip_campaign_beastmen");
	tp_beastmen = tooltip_patcher:new("tooltip_campaign_beastmen");
	tp_beastmen:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_beastmen", "ui_text_replacements_localised_text_hp_campaign_description_beastmen");
	tp_beastmen:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_beastmen",
		"ui_text_replacements_localised_text_hp_campaign_description_beastmen", 
		"UI/help_images/beastmen.png"
	);



	--
	-- big_names
	--

	hp_big_names = help_page:new(
		"script_link_campaign_big_names",
		hpr_title("war.camp.hp.big_names.001"),
		hpr_leader("war.camp.hp.big_names.002"),
		hpr_normal("war.camp.hp.big_names.003"),
		hpr_normal("war.camp.hp.big_names.004"),
		hpr_normal("war.camp.hp.big_names.005")
	);
	parser:add_record("campaign_big_names", "script_link_campaign_big_names", "tooltip_campaign_big_names");
	tp_big_names = tooltip_patcher:new("tooltip_campaign_big_names");
	tp_big_names:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_big_names", "ui_text_replacements_localised_text_hp_campaign_description_big_names");
	


	--
	-- big_names_link
	--
	script_feature_name = "big_names";
	parser:add_record("campaign_"..script_feature_name.."_link", "script_link_campaign_"..script_feature_name.."_link", "tooltip_campaign_"..script_feature_name.."_link");
	tp_big_names = tooltip_patcher:new("tooltip_campaign_"..script_feature_name.."_link");
	tp_big_names:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_"..script_feature_name.."_link");
	
	tl_big_names_link = tooltip_listener:new(
		"tooltip_campaign_"..script_feature_name.."_link",
		function()
			uim:highlight_big_names(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	--
	-- black_arks
	--

	hp_black_arks = help_page:new(
		"script_link_campaign_black_arks",
		hpr_title("war.camp.hp.black_arks.001"),
		hpr_leader("war.camp.hp.black_arks.002"),
		hpr_normal("war.camp.hp.black_arks.003"),
		hpr_normal("war.camp.hp.black_arks.004"),
		hpr_normal("war.camp.hp.black_arks.008"),
		hpr_normal("war.camp.hp.black_arks.005"),
		hpr_normal("war.camp.hp.black_arks.006"),
		hpr_normal("war.camp.hp.black_arks.007")
	);
	parser:add_record("campaign_black_arks", "script_link_campaign_black_arks", "tooltip_campaign_black_arks");
	tp_black_arks = tooltip_patcher:new("tooltip_campaign_black_arks");
	tp_black_arks:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_black_arks", "ui_text_replacements_localised_text_hp_campaign_description_black_arks");
	
	
	
	--
	-- blessed_spawnings
	--

	hp_blessed_spawnings = help_page:new(
		"script_link_campaign_blessed_spawnings",
		hpr_title("war.camp.hp.blessed_spawnings.001"),
		hpr_leader("war.camp.hp.blessed_spawnings.002"),
		hpr_normal("war.camp.hp.blessed_spawnings.003"),
		hpr_normal("war.camp.hp.blessed_spawnings.004")
	);
	parser:add_record("campaign_blessed_spawnings", "script_link_campaign_blessed_spawnings", "tooltip_campaign_blessed_spawnings");
	tp_blessed_spawnings = tooltip_patcher:new("tooltip_campaign_blessed_spawnings");
	tp_blessed_spawnings:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_blessed_spawnings", "ui_text_replacements_localised_text_hp_campaign_description_blessed_spawnings");
	
	
	
	--
	-- blessed_spawnings_button
	--
	
	parser:add_record("campaign_blessed_spawnings_button", "script_link_campaign_blessed_spawnings_button", "tooltip_campaign_blessed_spawnings_button");
	tp_blessed_spawnings_button = tooltip_patcher:new("tooltip_campaign_blessed_spawnings_button");
	tp_blessed_spawnings_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_blessed_spawnings_button");
	
	tl_blessed_spawnings_button = tooltip_listener:new(
		"tooltip_campaign_blessed_spawnings_button",
		function()
			uim:highlight_blessed_spawnings_button(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- blessing of the lady
	--

	hp_blessing_lady = help_page:new(
		"script_link_campaign_blessing_lady",
		hpr_title("war.camp.hp.blessing_lady.001"),
		hpr_leader("war.camp.hp.blessing_lady.002"),
		hpr_normal("war.camp.hp.blessing_lady.003"),
		hpr_normal("war.camp.hp.blessing_lady.004")
	);
	parser:add_record("campaign_blessing_lady", "script_link_campaign_blessing_lady", "tooltip_campaign_blessing_lady");
	tp_blessing_lady = tooltip_patcher:new("tooltip_campaign_blessing_lady");
	tp_blessing_lady:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_blessing_lady", "ui_text_replacements_localised_text_hp_campaign_description_blessing_lady");	
	
	
	--
	-- blood_kiss
	--
	
	parser:add_record("campaign_blood_kiss", "script_link_campaign_blood_kiss", "tooltip_campaign_blood_kiss");
	tp_blood_kiss = tooltip_patcher:new("tooltip_campaign_blood_kiss");
	tp_blood_kiss:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_blood_kiss");
	
	tl_blood_kiss = tooltip_listener:new(
		"tooltip_campaign_blood_kiss",
		function()
			uim:highlight_blood_kiss(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	--
	-- blood_voyage
	--

	hp_blood_voyage = help_page:new(
		"script_link_campaign_blood_voyage",
		hpr_title("war.camp.hp.blood_voyage.001"),
		hpr_leader("war.camp.hp.blood_voyage.002"),
		hpr_normal("war.camp.hp.blood_voyage.003"),
		hpr_normal("war.camp.hp.blood_voyage.004"),
		hpr_normal("war.camp.hp.blood_voyage.005")
	);
	parser:add_record("campaign_blood_voyage", "script_link_campaign_blood_voyage", "tooltip_campaign_blood_voyage");
	tp_blood_voyage = tooltip_patcher:new("tooltip_campaign_blood_voyage");
	tp_blood_voyage:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_blood_voyage", "ui_text_replacements_localised_text_hp_campaign_description_blood_voyage");


	--
	-- bloodletting
	--

	hp_bloodletting = help_page:new(
		"script_link_campaign_bloodletting",
		hpr_title("war.camp.hp.bloodletting.001"),
		hpr_leader("war.camp.hp.bloodletting.002"),
		hpr_normal("war.camp.hp.bloodletting.003"),
		hpr_normal("war.camp.hp.bloodletting.004"),
		hpr_normal("war.camp.hp.bloodletting.005"),
		hpr_normal("war.camp.hp.bloodletting.006"),
		hpr_normal("war.camp.hp.bloodletting.007")
	);
	parser:add_record("campaign_bloodletting", "script_link_campaign_bloodletting", "tooltip_campaign_bloodletting");
	tp_bloodletting = tooltip_patcher:new("tooltip_campaign_bloodletting");
	tp_bloodletting:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_bloodletting", "ui_text_replacements_localised_text_hp_campaign_description_bloodletting");
	
	tl_bloodletting = tooltip_listener:new(
		"tooltip_campaign_blood_kiss",
		function()
			uim:highlight_bloodletting(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- bloodletting_link
	--
	script_feature_name = "bloodletting";
	parser:add_record("campaign_"..script_feature_name.."_link", "script_link_campaign_"..script_feature_name.."_link", "tooltip_campaign_"..script_feature_name.."_link");
	tp_bloodletting_link = tooltip_patcher:new("tooltip_campaign_"..script_feature_name.."_link");
	tp_bloodletting_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_"..script_feature_name.."_link");
	
	tl_bloodletting_link = tooltip_listener:new(
		"tooltip_campaign_"..script_feature_name.."_link",
		function()
			uim:highlight_bloodletting(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	--
	-- bloodlines
	--

	hp_bloodlines = help_page:new(
		"script_link_campaign_bloodlines",
		hpr_title("war.camp.hp.bloodlines.001"),
		hpr_leader("war.camp.hp.bloodlines.002"),
		hpr_normal("war.camp.hp.bloodlines.003"),
		hpr_normal("war.camp.hp.bloodlines.004"),
		hpr_normal("war.camp.hp.bloodlines.005"),
		hpr_normal("war.camp.hp.bloodlines.006"),
		hpr_normal("war.camp.hp.bloodlines.007")
	);
	parser:add_record("campaign_bloodlines", "script_link_campaign_bloodlines", "tooltip_campaign_bloodlines");
	tp_bloodlines = tooltip_patcher:new("tooltip_campaign_bloodlines");
	tp_bloodlines:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_bloodlines", "ui_text_replacements_localised_text_hp_campaign_description_bloodlines");
	
	tl_bloodlines = tooltip_listener:new(
		"tooltip_campaign_bloodlines", 
		function() 
			uim:highlight_bloodlines_button(true) 
		end,
		function() 
			uim:unhighlight_all_for_tooltips() 
		end
	);
	
	
	--
	-- bloodlines_panel
	--
	
	parser:add_record("campaign_bloodlines_panel", "script_link_campaign_bloodlines_panel", "tooltip_campaign_bloodlines_panel");
	tp_bloodlines_panel = tooltip_patcher:new("tooltip_campaign_bloodlines_panel");
	tp_bloodlines_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_bloodlines_panel");
	
	tl_bloodlines_panel = tooltip_listener:new(
		"tooltip_campaign_bloodlines_panel",
		function()
			uim:highlight_bloodlines_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	--
	-- books_of_nagash
	--

	hp_books_of_nagash = help_page:new(
		"script_link_campaign_books_of_nagash",
		hpr_title("war.camp.hp.books_of_nagash.001"),
		hpr_leader("war.camp.hp.books_of_nagash.002"),
		hpr_normal("war.camp.hp.books_of_nagash.003"),
		hpr_normal("war.camp.hp.books_of_nagash.004"),
		hpr_normal("war.camp.hp.books_of_nagash.005")
	);
	parser:add_record("campaign_books_of_nagash", "script_link_campaign_books_of_nagash", "tooltip_campaign_books_of_nagash");
	tp_books_of_nagash = tooltip_patcher:new("tooltip_campaign_books_of_nagash");
	tp_books_of_nagash:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_books_of_nagash", "ui_text_replacements_localised_text_hp_campaign_description_books_of_nagash");
	
	tl_books_of_nagash = tooltip_listener:new(
		"tooltip_campaign_books_of_nagash",
		function()
			uim:highlight_books_of_nagash(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- books_of_nagash_link
	--

	parser:add_record("campaign_books_of_nagash_link", "script_link_campaign_books_of_nagash_link", "tooltip_campaign_books_of_nagash_link");
	tp_books_of_nagash_link = tooltip_patcher:new("tooltip_campaign_books_of_nagash_link");
	tp_books_of_nagash_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_books_of_nagash_link");

	tl_books_of_nagash_link = tooltip_listener:new(
		"tooltip_campaign_books_of_nagash_link",
		function()
			uim:highlight_books_of_nagash(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- books_of_nagash_panel
	--

	parser:add_record("campaign_books_of_nagash_panel", "script_link_campaign_books_of_nagash_panel", "tooltip_campaign_books_of_nagash_panel");
	tp_books_of_nagash_panel = tooltip_patcher:new("tooltip_campaign_books_of_nagash_panel");
	tp_books_of_nagash_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_books_of_nagash_panel");

	tl_books_of_nagash_panel = tooltip_listener:new(
		"tooltip_campaign_books_of_nagash_panel",
		function()
			uim:highlight_books_of_nagash_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- bloodgrounds
	--

	hp_bloodgrounds = help_page:new(
		"script_link_campaign_bloodgrounds",
		hpr_title("war.camp.hp.bloodgrounds.001"),
		hpr_leader("war.camp.hp.bloodgrounds.002"),
		hpr_normal("war.camp.hp.bloodgrounds.003"),
		hpr_normal("war.camp.hp.bloodgrounds.004"),
		hpr_normal("war.camp.hp.bloodgrounds.005"),
		hpr_normal("war.camp.hp.bloodgrounds.006"),
		hpr_normal("war.camp.hp.bloodgrounds.007")
	);
	parser:add_record("campaign_bloodgrounds", "script_link_campaign_bloodgrounds", "tooltip_campaign_bloodgrounds");
	tp_bloodgrounds = tooltip_patcher:new("tooltip_campaign_bloodgrounds");
	tp_bloodgrounds:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_bloodgrounds", "ui_text_replacements_localised_text_hp_campaign_description_bloodgrounds");


	
	--
	-- bretonnia
	--

	hp_bretonnia = help_page:new(
		"script_link_campaign_bretonnia",
		hpr_title("war.camp.hp.bretonnia.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/bretonnia.png"),
		hpr_leader("war.camp.hp.bretonnia.002"),
		hpr_normal("war.camp.hp.bretonnia.003"),
		hpr_normal("war.camp.hp.bretonnia.004"),
		hpr_normal("war.camp.hp.bretonnia.005"),
		hpr_normal("war.camp.hp.bretonnia.006"),
		hpr_normal("war.camp.hp.bretonnia.007")
	);
	parser:add_record("campaign_bretonnia", "script_link_campaign_bretonnia", "tooltip_campaign_bretonnia");
	tp_bretonnia = tooltip_patcher:new("tooltip_campaign_bretonnia");
	tp_bretonnia:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_bretonnia", "ui_text_replacements_localised_text_hp_campaign_description_bretonnia");
	tp_bretonnia:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_bretonnia",
		"ui_text_replacements_localised_text_hp_campaign_description_bretonnia", 
		"UI/help_images/bretonnia.png"
	);
	
	
	--
	-- bretonnian vows
	--

	hp_bretonnian_vows = help_page:new(
		"script_link_campaign_bretonnian_vows",
		hpr_title("war.camp.hp.bretonnian_vows.001"),
		hpr_leader("war.camp.hp.bretonnian_vows.002"),
		hpr_normal("war.camp.hp.bretonnian_vows.003"),
		hpr_normal("war.camp.hp.bretonnian_vows.004"),
		hpr_normal("war.camp.hp.bretonnian_vows.005"),
		hpr_normal("war.camp.hp.bretonnian_vows.006")
	);
	parser:add_record("campaign_bretonnian_vows", "script_link_campaign_bretonnian_vows", "tooltip_campaign_bretonnian_vows");
	tp_bretonnian_vows = tooltip_patcher:new("tooltip_campaign_bretonnian_vows");
	tp_bretonnian_vows:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_bretonnian_vows", "ui_text_replacements_localised_text_hp_campaign_description_bretonnian_vows");
	
	
	
	--
	-- building_browser
	--
	
	parser:add_record("campaign_building_browser", "script_link_campaign_building_browser", "tooltip_campaign_building_browser");
	tp_building_browser = tooltip_patcher:new("tooltip_campaign_building_browser");
	tp_building_browser:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_building_browser");
	
	tl_building_browser = tooltip_listener:new(
		"tooltip_campaign_building_browser",
		function()
			uim:highlight_building_browser(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- building_panel
	--

	hp_building_panel = help_page:new(
		"script_link_campaign_building_panel",
		hpr_title("war.camp.hp.building_panel.001"),
		hpr_leader("war.camp.hp.building_panel.002"),
		hpr_normal("war.camp.hp.building_panel.003"),
		hpr_normal("war.camp.hp.building_panel.004")
	);
	parser:add_record("campaign_building_panel", "script_link_campaign_building_panel", "tooltip_campaign_building_panel");
	tp_building_panel = tooltip_patcher:new("tooltip_campaign_building_panel");
	tp_building_panel:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_building_panel", "ui_text_replacements_localised_text_hp_campaign_description_building_panel");

	tl_building_panel = tooltip_listener:new(
		"tooltip_campaign_building_panel",
		function()
			uim:highlight_building_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	--
	-- building_panel_link
	--

	parser:add_record("campaign_building_panel_link", "script_link_campaign_building_panel_link", "tooltip_campaign_building_panel_link");
	tp_building_panel_link = tooltip_patcher:new("tooltip_campaign_building_panel_link");
	tp_building_panel_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_building_panel_link");

	tl_building_panel_link = tooltip_listener:new(
		"tooltip_campaign_building_panel_link",
		function()
			uim:highlight_building_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	--
	-- building_panel_tab
	--

	parser:add_record("campaign_building_panel_tab", "script_link_campaign_building_panel_tab", "tooltip_campaign_building_panel_tab");
	tp_building_panel_tab = tooltip_patcher:new("tooltip_campaign_building_panel_tab");
	tp_building_panel_tab:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_building_panel_tab");

	tl_building_panel_tab = tooltip_listener:new(
		"tooltip_campaign_building_panel_tab",
		function()
			uim:highlight_building_panel_tab(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);	
	
	
	--
	-- building_slots
	--

	hp_building_slots = help_page:new(
		"script_link_campaign_building_slots",
		hpr_title("war.camp.hp.building_slots.001"),
		hpr_leader("war.camp.hp.building_slots.002"),
		hpr_normal("war.camp.hp.building_slots.003"),
		hpr_normal("war.camp.hp.building_slots.004"),
		hpr_normal("war.camp.hp.building_slots.005"),
		hpr_normal("war.camp.hp.building_slots.006")
	);
	parser:add_record("campaign_building_slots", "script_link_campaign_building_slots", "tooltip_campaign_building_slots");
	tp_building_slots = tooltip_patcher:new("tooltip_campaign_building_slots");
	tp_building_slots:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_building_slots", "ui_text_replacements_localised_text_hp_campaign_description_building_slots");
	
	tl_building_slots = tooltip_listener:new(
		"tooltip_campaign_building_slots", 
		function() 
			uim:highlight_buildings(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- building_slots_link
	--
	
	parser:add_record("campaign_building_slots_link", "script_link_campaign_building_slots_link", "tooltip_campaign_building_slots_link");
	tp_building_slots = tooltip_patcher:new("tooltip_campaign_building_slots_link");
	tp_building_slots:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_building_slots_link");
	
	tl_building_slots_link = tooltip_listener:new(
		"tooltip_campaign_building_slots_link",
		function()
			uim:highlight_buildings(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- buildings
	--

	hp_buildings = help_page:new(
		"script_link_campaign_buildings",
		hpr_title("war.camp.hp.buildings.001"),
		hpr_leader("war.camp.hp.buildings.002"),
		hpr_normal("war.camp.hp.buildings.003"),
		hpr_normal("war.camp.hp.buildings.004"),
		hpr_normal("war.camp.hp.buildings.005"),
		hpr_normal("war.camp.hp.buildings.006"),
		hpr_normal("war.camp.hp.buildings.007")
	);
	parser:add_record("campaign_buildings", "script_link_campaign_buildings", "tooltip_campaign_buildings");
	tp_buildings = tooltip_patcher:new("tooltip_campaign_buildings");
	tp_buildings:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_buildings", "ui_text_replacements_localised_text_hp_campaign_description_buildings");
	
	tl_buildings = tooltip_listener:new(
		"tooltip_campaign_buildings", 
		function() 
			uim:highlight_buildings(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	--
	-- buildings_link
	--
	
	parser:add_record("campaign_buildings_link", "script_link_campaign_buildings_link", "tooltip_campaign_buildings_link");
	tp_buildings = tooltip_patcher:new("tooltip_campaign_buildings_link");
	tp_buildings:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_buildings_link");
	
	tl_buildings_link = tooltip_listener:new(
		"tooltip_campaign_buildings_link",
		function()
			uim:highlight_buildings(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);

	
	--
	-- campaign_controls
	--

	hp_campaign_controls = help_page:new(
		"script_link_campaign_campaign_controls",
		hpr_title("war.camp.hp.campaign_controls.001"),

		hpr_section("camera_controls"),
		hpr_normal_unfaded("war.camp.hp.campaign_controls.002", "camera_controls"),
		hpr_campaign_camera_controls("war.camp.hp.campaign_controls.004", "camera_controls"),
		hpr_campaign_camera_controls_alt("war.camp.hp.campaign_controls.005", "camera_controls"),
		hpr_campaign_camera_altitude_controls("war.camp.hp.campaign_controls.006", "camera_controls"),
		hpr_campaign_camera_facing_controls("war.camp.hp.campaign_controls.007", "camera_controls"),
		
		hpr_section("selection_and_movement"),
		hpr_normal_unfaded("war.camp.hp.campaign_controls.008", "selection_and_movement"),
		hpr_normal("war.camp.hp.campaign_controls.009", "selection_and_movement"),
		hpr_campaign_selection_controls("war.camp.hp.campaign_controls.010", "selection_and_movement"),
		hpr_campaign_army_movement_controls("war.camp.hp.campaign_controls.011", "selection_and_movement")
	);
	parser:add_record("campaign_campaign_controls", "script_link_campaign_campaign_controls", "tooltip_campaign_campaign_controls");
	tp_campaign_controls = tooltip_patcher:new("tooltip_campaign_campaign_controls");
	tp_campaign_controls:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_campaign_controls", "ui_text_replacements_localised_text_hp_campaign_description_campaign_controls");



	--
	-- campaign_game
	--

	hp_campaign_game = help_page:new(
		"script_link_campaign_campaign_game",
		hpr_title("war.camp.hp.campaign_game.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/campaign_game.png"),
		hpr_leader("war.camp.hp.campaign_game.002"),

		hpr_section("controls"),
		hpr_normal_unfaded("war.camp.hp.campaign_game.003", "controls"),
		hpr_normal("war.camp.hp.campaign_game.004", "controls"),

		hpr_section("factions"),
		hpr_normal_unfaded("war.camp.hp.campaign_game.005", "factions"),
		hpr_normal("war.camp.hp.campaign_game.006", "factions"),
		hpr_normal("war.camp.hp.campaign_game.007", "factions"),

		hpr_section("saving"),
		hpr_normal_unfaded("war.camp.hp.campaign_game.008", "saving"),
		hpr_normal("war.camp.hp.campaign_game.009", "saving"),

		hpr_section("turns"),
		hpr_normal_unfaded("war.camp.hp.campaign_game.010", "turns"),
		hpr_normal("war.camp.hp.campaign_game.011", "turns"),

		hpr_section("battles"),
		hpr_normal_unfaded("war.camp.hp.campaign_game.012", "battles"),
		hpr_normal("war.camp.hp.campaign_game.013", "battles"),

		hpr_normal("war.camp.hp.campaign_game.014")
	);
	parser:add_record("campaign_campaign_game", "script_link_campaign_campaign_game", "tooltip_campaign_campaign_game");
	tp_campaign_game = tooltip_patcher:new("tooltip_campaign_campaign_game");
	tp_campaign_game:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_campaign_game",
		"ui_text_replacements_localised_text_hp_campaign_description_campaign_game", 
		"ui/help_images/campaign_game.png"
	);



	--
	-- campaign_map
	--

	hp_campaign_map = help_page:new(
		"script_link_campaign_campaign_map",
		hpr_title("war.camp.hp.campaign_map.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/campaign_map.png"),
		hpr_leader("war.camp.hp.campaign_map.002"),

		hpr_section("provinces"),
		hpr_normal_unfaded("war.camp.hp.campaign_map.003", "provinces"),
		hpr_normal("war.camp.hp.campaign_map.004", "provinces"),

		hpr_section("terrain"),
		hpr_normal_unfaded("war.camp.hp.campaign_map.005", "terrain"),
		hpr_normal("war.camp.hp.campaign_map.006", "terrain"),

		hpr_section("sea"),
		hpr_normal_unfaded("war.camp.hp.campaign_map.007", "sea"),
		hpr_normal("war.camp.hp.campaign_map.008", "sea"),

		hpr_section("fog"),
		hpr_normal_unfaded("war.camp.hp.campaign_map.009", "fog"),
		hpr_normal("war.camp.hp.campaign_map.010", "fog"),

		hpr_section("winds"),
		hpr_normal_unfaded("war.camp.hp.campaign_map.011", "winds"),
		hpr_normal("war.camp.hp.campaign_map.012", "winds")
	);
	parser:add_record("campaign_campaign_map", "script_link_campaign_campaign_map", "tooltip_campaign_campaign_map");
	tp_campaign_map = tooltip_patcher:new("tooltip_campaign_campaign_map");
	tp_campaign_map:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_campaign_map",
		"ui_text_replacements_localised_text_hp_campaign_description_campaign_map",
		"ui/help_images/campaign_map.png"
	);


	
	--
	-- canopic_jars
	--

	hp_canopic_jars = help_page:new(
		"script_link_campaign_canopic_jars",
		hpr_title("war.camp.hp.canopic_jars.001"),
		hpr_leader("war.camp.hp.canopic_jars.002"),
		hpr_normal("war.camp.hp.canopic_jars.003"),
		hpr_normal("war.camp.hp.canopic_jars.004"),
		hpr_normal("war.camp.hp.canopic_jars.005"),
		hpr_normal("war.camp.hp.canopic_jars.006")
	);
	parser:add_record("campaign_canopic_jars", "script_link_campaign_canopic_jars", "tooltip_campaign_canopic_jars");
	tp_canopic_jars = tooltip_patcher:new("tooltip_campaign_canopic_jars");
	tp_canopic_jars:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_canopic_jars", "ui_text_replacements_localised_text_hp_campaign_description_canopic_jars");
	
	tl_canopic_jars = tooltip_listener:new(
		"tooltip_campaign_canopic_jars",
		function()
			uim:highlight_canopic_jars(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- canopic_jars_link
	--

	parser:add_record("campaign_canopic_jars_link", "script_link_campaign_canopic_jars_link", "tooltip_campaign_canopic_jars_link");
	tp_canopic_jars_link = tooltip_patcher:new("tooltip_campaign_canopic_jars_link");
	tp_canopic_jars_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_canopic_jars_link");

	tl_canopic_jars_link = tooltip_listener:new(
		"tooltip_campaign_canopic_jars_link",
		function()
			uim:highlight_canopic_jars(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- cathay
	--

	hp_cathay = help_page:new(
		"script_link_campaign_cathay",
		hpr_title("war.camp.hp.cathay.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/cathay.png"),
		hpr_leader("war.camp.hp.cathay.002"),

		hpr_section("harmony"),
		hpr_normal_unfaded("war.camp.hp.cathay.003", "harmony"),
		hpr_normal("war.camp.hp.cathay.004", "harmony"),

		hpr_section("compass"),
		hpr_normal_unfaded("war.camp.hp.cathay.005", "compass"),
		hpr_normal("war.camp.hp.cathay.006", "compass"),

		hpr_section("caravans"),
		hpr_normal_unfaded("war.camp.hp.cathay.007", "caravans"),
		hpr_normal("war.camp.hp.cathay.008", "caravans"),

		hpr_section("battle"),
		hpr_normal_unfaded("war.camp.hp.cathay.009", "battle"),
		hpr_normal("war.camp.hp.cathay.010", "battle"),
		hpr_normal("war.camp.hp.cathay.011", "battle"),

		hpr_normal("war.camp.hp.cathay.012")
	);
	parser:add_record("campaign_cathay", "script_link_campaign_cathay", "tooltip_campaign_cathay");
	tp_cathay = tooltip_patcher:new("tooltip_campaign_cathay");
	tp_cathay:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_cathay",
		"ui_text_replacements_localised_text_hp_campaign_description_cathay", 
		"UI/help_images/cathay.png"
	);



	--
	-- changing_of_the_ways
	--

	hp_changing_of_the_ways = help_page:new(
		"script_link_campaign_changing_of_the_ways",
		hpr_title("war.camp.hp.changing_of_the_ways.001"),
		hpr_leader("war.camp.hp.changing_of_the_ways.002"),
		hpr_normal("war.camp.hp.changing_of_the_ways.003"),
		hpr_normal("war.camp.hp.changing_of_the_ways.004")
	);
	parser:add_record("campaign_changing_of_the_ways", "script_link_campaign_changing_of_the_ways", "tooltip_campaign_changing_of_the_ways");
	tp_changing_of_the_ways = tooltip_patcher:new("tooltip_campaign_changing_of_the_ways");
	tp_changing_of_the_ways:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_changing_of_the_ways", "ui_text_replacements_localised_text_hp_campaign_description_changing_of_the_ways");

	tl_changing_of_the_ways = tooltip_listener:new(
		"tooltip_campaign_changing_of_the_ways", 
		function() 
			uim:highlight_changing_of_the_ways(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- changing_of_the_ways_link
	--
	
	parser:add_record("campaign_changing_of_the_ways_link", "script_link_campaign_changing_of_the_ways_link", "tooltip_campaign_changing_of_the_ways_link");
	tp_changing_of_the_ways_link = tooltip_patcher:new("tooltip_campaign_changing_of_the_ways_link");
	tp_changing_of_the_ways_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_changing_of_the_ways_link");
	
	tl_changing_of_the_ways_link = tooltip_listener:new(
		"tooltip_campaign_changing_of_the_ways_link",
		function()
			uim:highlight_changing_of_the_ways(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- changing_of_the_ways_panel
	--

	parser:add_record("campaign_changing_of_the_ways_panel", "script_link_campaign_changing_of_the_ways_panel", "tooltip_campaign_changing_of_the_ways_panel");
	tp_changing_of_the_ways_panel = tooltip_patcher:new("tooltip_campaign_changing_of_the_ways_panel");
	tp_changing_of_the_ways_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_changing_of_the_ways_panel");
	
	tl_changing_of_the_ways_panel = tooltip_listener:new(
		"tooltip_campaign_changing_of_the_ways_panel", 
		function() 
			uim:highlight_changing_of_the_ways(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- chaos
	--

	hp_chaos = help_page:new(
		"script_link_campaign_chaos",
		hpr_title("war.camp.hp.chaos.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/chaos.png"),
		hpr_leader("war.camp.hp.chaos.002"),

		hpr_section("daemons"),
		hpr_normal_unfaded("war.camp.hp.chaos.003", "daemons"),
		hpr_normal("war.camp.hp.chaos.004", "daemons"),
		hpr_normal("war.camp.hp.chaos.005", "daemons"),
		hpr_normal("war.camp.hp.chaos.006", "daemons"),
		hpr_normal("war.camp.hp.chaos.007", "daemons"),
		hpr_normal("war.camp.hp.chaos.008", "daemons"),
		hpr_normal("war.camp.hp.chaos.009", "daemons"),
		
		hpr_section("mortals"),
		hpr_normal_unfaded("war.camp.hp.chaos.010", "mortals"),
		hpr_normal("war.camp.hp.chaos.011", "mortals"),

		hpr_normal("war.camp.hp.chaos.012"),
		hpr_normal("war.camp.hp.chaos.013")
	);
	parser:add_record("campaign_chaos", "script_link_campaign_chaos", "tooltip_campaign_chaos");
	tp_chaos = tooltip_patcher:new("tooltip_campaign_chaos");
	tp_chaos:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_chaos",
		"ui_text_replacements_localised_text_hp_campaign_description_chaos", 
		"UI/help_images/chaos.png"
	);
	
	
	
	--
	-- chaos_artefacts
	--

	hp_chaos_artefacts = help_page:new(
		"script_link_campaign_chaos_artefacts",
		hpr_title("war.camp.hp.chaos_artefacts.001"),
		hpr_leader("war.camp.hp.chaos_artefacts.002"),
		hpr_normal("war.camp.hp.chaos_artefacts.003"),
		hpr_normal("war.camp.hp.chaos_artefacts.004")
	);
	parser:add_record("campaign_chaos_artefacts", "script_link_campaign_chaos_artefacts", "tooltip_campaign_chaos_artefacts");
	tp_chaos_artefacts = tooltip_patcher:new("tooltip_campaign_chaos_artefacts");
	tp_chaos_artefacts:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_chaos_artefacts", "ui_text_replacements_localised_text_hp_campaign_description_chaos_artefacts");
	
	
	
	--
	-- chaos_corruption
	--

	hp_chaos_corruption = help_page:new(
		"script_link_campaign_chaos_corruption",
		hpr_title("war.camp.hp.chaos_corruption.001"),
		hpr_leader("war.camp.hp.chaos_corruption.002"),
		hpr_section("variants"),
		hpr_normal_unfaded("war.camp.hp.chaos_corruption.003", "variants"),
		hpr_normal("war.camp.hp.chaos_corruption.004", "variants"),
		hpr_normal("war.camp.hp.chaos_corruption.005", "variants"),
		hpr_normal("war.camp.hp.chaos_corruption.006", "variants"),
		hpr_section("undivided"),
		hpr_normal_unfaded("war.camp.hp.chaos_corruption.007", "undivided"),
		hpr_normal("war.camp.hp.chaos_corruption.008", "undivided"),
		hpr_normal("war.camp.hp.chaos_corruption.009", "undivided"),
		hpr_normal("war.camp.hp.chaos_corruption.010", "undivided"),
		hpr_normal("war.camp.hp.chaos_corruption.011"),
		hpr_normal("war.camp.hp.chaos_corruption.012"),
		hpr_normal("war.camp.hp.chaos_corruption.013")
	);
	parser:add_record("campaign_chaos_corruption", "script_link_campaign_chaos_corruption", "tooltip_campaign_chaos_corruption");
	tp_chaos_corruption = tooltip_patcher:new("tooltip_campaign_chaos_corruption");
	tp_chaos_corruption:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_chaos_corruption", "ui_text_replacements_localised_text_hp_campaign_description_chaos_corruption");



	--
	-- chaos_cults
	--

	hp_chaos_cults = help_page:new(
		"script_link_campaign_chaos_cults",
		hpr_title("war.camp.hp.chaos_cults.001"),
		hpr_leader("war.camp.hp.chaos_cults.002"),
		hpr_normal("war.camp.hp.chaos_cults.003"),
		hpr_normal("war.camp.hp.chaos_cults.004"),
		hpr_normal("war.camp.hp.chaos_cults.005"),
		hpr_normal("war.camp.hp.chaos_cults.006"),

		hpr_section("slaanesh"),
		hpr_normal_unfaded("war.camp.hp.chaos_cults.007", "slaanesh"),
		hpr_normal("war.camp.hp.chaos_cults.008", "slaanesh")
	);
	parser:add_record("campaign_chaos_cults", "script_link_campaign_chaos_cults", "tooltip_campaign_chaos_cults");
	tp_chaos_cults = tooltip_patcher:new("tooltip_campaign_chaos_cults");
	tp_chaos_cults:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_chaos_cults", "ui_text_replacements_localised_text_hp_campaign_description_chaos_cults");


	--
	-- chaos_dwarfs
	--

	hp_chaos_dwarfs = help_page:new(
		"script_link_campaign_chaos_dwarfs",
		hpr_title("war.camp.hp.chaos_dwarfs.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/chaos_dwarfs.png"),
		hpr_leader("war.camp.hp.chaos_dwarfs.002"),

		hpr_section("chd_economy"),
		hpr_normal_unfaded("war.camp.hp.chaos_dwarfs.003", "chd_economy"),
		hpr_normal("war.camp.hp.chaos_dwarfs.004", "chd_economy"),
		
		hpr_section("military_convoys"),
		hpr_normal_unfaded("war.camp.hp.chaos_dwarfs.005", "military_convoys"),
		hpr_normal("war.camp.hp.chaos_dwarfs.006", "military_convoys"),
		
		hpr_section("tower_of_zharr"),
		hpr_normal_unfaded("war.camp.hp.chaos_dwarfs.007", "tower_of_zharr"),
		hpr_normal("war.camp.hp.chaos_dwarfs.008", "tower_of_zharr"),

		hpr_normal("war.camp.hp.chaos_dwarfs.009")
	);
	parser:add_record("campaign_chaos_dwarfs", "script_link_campaign_chaos_dwarfs", "tooltip_campaign_chaos_dwarfs");
	tp_chaos_dwarfs = tooltip_patcher:new("tooltip_campaign_chaos_dwarfs");
	tp_chaos_dwarfs:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_chaos_dwarfs",
		"ui_text_replacements_localised_text_hp_campaign_description_chaos_dwarfs",
		"UI/help_images/chaos_dwarfs.png"
	);


	--
	-- chaos gifts
	--

	hp_chaos_gifts = help_page:new(
		"script_link_campaign_chaos_gifts",
		hpr_title("war.camp.hp.chaos_gifts.001"),
		hpr_leader("war.camp.hp.chaos_gifts.002"),
		hpr_normal("war.camp.hp.chaos_gifts.003"),
		hpr_normal("war.camp.hp.chaos_gifts.004"),
		hpr_normal("war.camp.hp.chaos_gifts.005"),
		hpr_normal("war.camp.hp.chaos_gifts.006")
	);
	parser:add_record("campaign_chaos_gifts", "script_link_campaign_chaos_gifts", "tooltip_campaign_chaos_gifts");
	tp_chaos_gifts = tooltip_patcher:new("tooltip_campaign_chaos_gifts");
	tp_chaos_gifts:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_chaos_gifts", "ui_text_replacements_localised_text_hp_campaign_description_chaos_gifts");



	--
	-- chaos_rifts
	--

	hp_chaos_rifts = help_page:new(
		"script_link_campaign_chaos_rifts",
		hpr_title("war.camp.hp.chaos_rifts.001"),
		hpr_leader("war.camp.hp.chaos_rifts.002"),
		hpr_normal("war.camp.hp.chaos_rifts.003"),
		hpr_normal("war.camp.hp.chaos_rifts.004"),
		hpr_normal("war.camp.hp.chaos_rifts.005"),

		hpr_section("usage"),
		hpr_normal_unfaded("war.camp.hp.chaos_rifts.006", "usage"),
		hpr_normal("war.camp.hp.chaos_rifts.007", "usage"),
		hpr_normal("war.camp.hp.chaos_rifts.008", "usage"),

		hpr_section("daemons"),
		hpr_normal_unfaded("war.camp.hp.chaos_rifts.009", "daemons"),
		hpr_normal("war.camp.hp.chaos_rifts.010", "daemons")
	);
	parser:add_record("campaign_chaos_rifts", "script_link_campaign_chaos_rifts", "tooltip_campaign_chaos_rifts");
	tp_chaos_rifts = tooltip_patcher:new("tooltip_campaign_chaos_rifts");
	tp_chaos_rifts:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_chaos_rifts", "ui_text_replacements_localised_text_hp_campaign_description_chaos_rifts");
	
	
	
	--
	-- chapter_objectives
	--

	parser:add_record("campaign_chapter_objectives", "script_link_campaign_chapter_objectives", "tooltip_campaign_chapter_objectives");
	tp_chapter_objectives = tooltip_patcher:new("tooltip_campaign_chapter_objectives");
	tp_chapter_objectives:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_chapter_objectives");
	
	tl_chapter_objectives = tooltip_listener:new(
		"tooltip_campaign_chapter_objectives", 
		function() 
			uim:highlight_objectives_panel_chapter_missions(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);


	
	--
	-- character_available_skill_points
	--
	
	parser:add_record("campaign_character_available_skill_points", "script_link_campaign_character_available_skill_points", "tooltip_campaign_character_available_skill_points");
	tp_character_available_skill_points = tooltip_patcher:new("tooltip_campaign_character_available_skill_points");
	tp_character_available_skill_points:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_character_available_skill_points");
	
	tl_character_available_skill_points = tooltip_listener:new(
		"tooltip_campaign_character_available_skill_points",
		function()
			uim:highlight_character_available_skill_points(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- character_details
	--

	hp_character_details = help_page:new(
		"script_link_campaign_character_details",
		hpr_title("war.camp.hp.character_details.001"),
		hpr_leader("war.camp.hp.character_details.002"),

		hpr_section("panel"),
		hpr_normal_unfaded("war.camp.hp.character_details.003", "panel"),
		hpr_normal("war.camp.hp.character_details.004", "panel"),

		hpr_section("skills"),
		hpr_normal_unfaded("war.camp.hp.character_details.005", "skills"),
		hpr_normal("war.camp.hp.character_details.006", "skills"),

		hpr_section("items"),
		hpr_normal_unfaded("war.camp.hp.character_details.007", "items"),
		hpr_normal("war.camp.hp.character_details.008", "items"),
		hpr_normal("war.camp.hp.character_details.009", "items"),

		hpr_section("banners"),
		hpr_normal_unfaded("war.camp.hp.character_details.010", "banners"),
		hpr_normal("war.camp.hp.character_details.011", "banners"),
		hpr_normal("war.camp.hp.character_details.012", "banners"),

		hpr_section("traits"),
		hpr_normal_unfaded("war.camp.hp.character_details.013", "traits"),
		hpr_normal("war.camp.hp.character_details.014", "traits"),
		hpr_normal("war.camp.hp.character_details.015", "traits"),
		hpr_normal("war.camp.hp.character_details.016", "traits")
	);
	parser:add_record("campaign_character_details", "script_link_campaign_character_details", "tooltip_campaign_character_details");
	tp_character_details = tooltip_patcher:new("tooltip_campaign_character_details");
	tp_character_details:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_character_details", "ui_text_replacements_localised_text_hp_campaign_description_character_details");
	
	tl_character_details = tooltip_listener:new(
		"tooltip_campaign_character_details",
		function()
			uim:highlight_character_details(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);

	
	--
	-- character_details_button
	--
	
	parser:add_record("campaign_character_details_button", "script_link_campaign_character_details_button", "tooltip_campaign_character_details_button");
	tp_character_details_button = tooltip_patcher:new("tooltip_campaign_character_details_button");
	tp_character_details_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_character_details_button");
	
	tl_character_details_button = tooltip_listener:new(
		"tooltip_campaign_character_details_button",
		function()
			uim:highlight_character_details_button(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- character_details_link
	--
	
	parser:add_record("campaign_character_details_link", "script_link_campaign_character_details_link", "tooltip_campaign_character_details_link");
	tp_character_details = tooltip_patcher:new("tooltip_campaign_character_details_link");
	tp_character_details:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_character_details_link");
	
	tl_character_details_link = tooltip_listener:new(
		"tooltip_campaign_character_details_link",
		function()
			uim:highlight_character_details(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- character_details_panel
	--

	hp_character_details_panel = help_page:new(
		"script_link_campaign_character_details_panel",
		hpr_title("war.camp.hp.character_details_panel.001"),
		hpr_leader("war.camp.hp.character_details_panel.002"),

		hpr_section("stats"),
		hpr_normal_unfaded("war.camp.hp.character_details_panel.003", "stats"),
		hpr_normal("war.camp.hp.character_details_panel.004", "stats"),

		hpr_section("abilities"),
		hpr_normal_unfaded("war.camp.hp.character_details_panel.005", "abilities"),
		hpr_normal("war.camp.hp.character_details_panel.006", "abilities"),

		hpr_section("traits"),
		hpr_normal_unfaded("war.camp.hp.character_details_panel.007", "traits"),
		hpr_normal("war.camp.hp.character_details_panel.008", "traits"),

		hpr_section("details_tab"),
		hpr_normal_unfaded("war.camp.hp.character_details_panel.009", "details_tab"),
		hpr_normal("war.camp.hp.character_details_panel.010", "details_tab"),

		hpr_section("skills_tab"),
		hpr_normal_unfaded("war.camp.hp.character_details_panel.011", "skills_tab"),
		hpr_normal("war.camp.hp.character_details_panel.012", "skills_tab"),

		hpr_section("quests_tab"),
		hpr_normal_unfaded("war.camp.hp.character_details_panel.013", "quests_tab"),
		hpr_normal("war.camp.hp.character_details_panel.014", "quests_tab"),
		hpr_normal("war.camp.hp.character_details_panel.015", "quests_tab")
	);
	parser:add_record("campaign_character_details_panel", "script_link_campaign_character_details_panel", "tooltip_campaign_character_details_panel");
	tp_character_details_panel = tooltip_patcher:new("tooltip_campaign_character_details_panel");
	tp_character_details_panel:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_character_details_panel", "ui_text_replacements_localised_text_hp_campaign_description_character_details_panel");
	
	tl_character_details_panel = tooltip_listener:new(
		"tooltip_campaign_character_details_panel",
		function()
			uim:highlight_character_details_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- character_details_panel_abilities
	--
	
	parser:add_record("campaign_character_details_panel_abilities", "script_link_campaign_character_details_panel_abilities", "tooltip_campaign_character_details_panel_abilities");
	tp_character_details_panel_abilities = tooltip_patcher:new("tooltip_campaign_character_details_panel_abilities");
	tp_character_details_panel_abilities:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_character_details_panel_abilities");
	
	tl_character_details_panel_abilities = tooltip_listener:new(
		"tooltip_campaign_character_details_panel_abilities",
		function()
			uim:highlight_character_details_panel_abilities(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- character_details_panel_details_button
	--
	
	parser:add_record("campaign_character_details_panel_details_button", "script_link_campaign_character_details_panel_details_button", "tooltip_campaign_character_details_panel_details_button");
	tp_character_details_panel_details_button = tooltip_patcher:new("tooltip_campaign_character_details_panel_details_button");
	tp_character_details_panel_details_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_character_details_panel_details_button");
	
	tl_character_details_panel_details_button = tooltip_listener:new(
		"tooltip_campaign_character_details_panel_details_button",
		function()
			uim:highlight_character_details_panel_details_button(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- character_details_panel_character_stats
	--
	
	parser:add_record("campaign_character_details_panel_character_stats", "script_link_campaign_character_details_panel_character_stats", "tooltip_campaign_character_details_panel_character_stats");
	tp_character_details_panel_character_stats = tooltip_patcher:new("tooltip_campaign_character_details_panel_character_stats");
	tp_character_details_panel_character_stats:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_character_details_panel_character_stats");
	
	tl_character_details_panel_character_stats = tooltip_listener:new(
		"tooltip_campaign_character_details_panel_character_stats",
		function()
			uim:highlight_character_details_panel_character_stats(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- character_details_panel_details_traits_and_effects
	--
	
	parser:add_record("campaign_character_details_panel_details_traits_and_effects", "script_link_campaign_character_details_panel_details_traits_and_effects", "tooltip_campaign_character_details_panel_details_traits_and_effects");
	tp_character_details_panel_details_traits_and_effects = tooltip_patcher:new("tooltip_campaign_character_details_panel_details_traits_and_effects");
	tp_character_details_panel_details_traits_and_effects:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_character_details_panel_details_traits_and_effects");
	
	tl_character_details_panel_details_traits_and_effects = tooltip_listener:new(
		"tooltip_campaign_character_details_panel_details_traits_and_effects",
		function()
			uim:highlight_character_details_panel_details_traits_and_effects(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	--
	-- character_details_panel_link
	--
	
	parser:add_record("campaign_character_details_panel_link", "script_link_campaign_character_details_panel_link", "tooltip_campaign_character_details_panel_link");
	tp_character_details_panel_link = tooltip_patcher:new("tooltip_campaign_character_details_panel_link");
	tp_character_details_panel_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_character_details_panel_link");
	
	tl_character_details_panel_link = tooltip_listener:new(
		"tooltip_campaign_character_details_panel_link",
		function()
			uim:highlight_character_details_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	


	--
	-- character_details_panel_quests_button
	--
	
	parser:add_record("campaign_character_details_panel_quests_button", "script_link_campaign_character_details_panel_quests_button", "tooltip_campaign_character_details_panel_quests_button");
	tp_character_details_panel_quests_button = tooltip_patcher:new("tooltip_campaign_character_details_panel_quests_button");
	tp_character_details_panel_quests_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_character_details_panel_quests_button");
	
	tl_character_details_panel_quests_button = tooltip_listener:new(
		"tooltip_campaign_character_details_panel_quests_button",
		function()
			uim:highlight_character_details_panel_quests_button(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- character_details_panel_skills_button
	--
	
	parser:add_record("campaign_character_details_panel_skills_button", "script_link_campaign_character_details_panel_skills_button", "tooltip_campaign_character_details_panel_skills_button");
	tp_character_details_panel_skills_button = tooltip_patcher:new("tooltip_campaign_character_details_panel_skills_button");
	tp_character_details_panel_skills_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_character_details_panel_skills_button");
	
	tl_character_details_panel_skills_button = tooltip_listener:new(
		"tooltip_campaign_character_details_panel_skills_button",
		function()
			uim:highlight_character_details_panel_skills_button(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- character_info_panel
	--
	
	hp_character_info_panel = help_page:new(
		"script_link_campaign_character_info_panel",
		hpr_title("war.camp.hp.character_info_panel.001"),
		hpr_leader("war.camp.hp.character_info_panel.002"),
		hpr_normal("war.camp.hp.character_info_panel.003"),
		hpr_normal("war.camp.hp.character_info_panel.004"),
		hpr_normal("war.camp.hp.character_info_panel.005")--[[,
		hpr_normal("war.camp.hp.character_info_panel.006"),
		hpr_normal("war.camp.hp.character_info_panel.007")]]
	);
	parser:add_record("campaign_character_info_panel", "script_link_campaign_character_info_panel", "tooltip_campaign_character_info_panel");
	tp_character_info_panel = tooltip_patcher:new("tooltip_campaign_character_info_panel");
	tp_character_info_panel:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_character_info_panel", "ui_text_replacements_localised_text_hp_campaign_description_character_info_panel");
	
	tl_character_info_panel = tooltip_listener:new(
		"tooltip_campaign_character_info_panel", 
		function() 
			uim:highlight_character_info_panel(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- character_info_panel_link
	--
	
	parser:add_record("campaign_character_info_panel_link", "script_link_campaign_character_info_panel_link", "tooltip_campaign_character_info_panel_link");
	tp_character_info_panel = tooltip_patcher:new("tooltip_campaign_character_info_panel_link");
	tp_character_info_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_character_info_panel_link");
	
	tl_character_info_panel_link = tooltip_listener:new(
		"tooltip_campaign_character_info_panel_link",
		function()
			uim:highlight_character_info_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
		
	
	
	--
	-- character_skills
	--

	hp_character_skills = help_page:new(
		"script_link_campaign_character_skills",
		hpr_title("war.camp.hp.character_skills.001"),
		hpr_leader("war.camp.hp.character_skills.002"),
		hpr_normal("war.camp.hp.character_skills.003"),
		hpr_normal("war.camp.hp.character_skills.004"),
		hpr_normal("war.camp.hp.character_skills.005"),
		hpr_normal("war.camp.hp.character_skills.006")
	);
	parser:add_record("campaign_character_skills", "script_link_campaign_character_skills", "tooltip_campaign_character_skills");
	tp_character_skills = tooltip_patcher:new("tooltip_campaign_character_skills");
	tp_character_skills:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_character_skills", "ui_text_replacements_localised_text_hp_campaign_description_character_skills");

	tl_character_skills = tooltip_listener:new(
		"tooltip_campaign_character_skills",
		function()
			uim:highlight_character_skills(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- character_skills_link
	--
	
	parser:add_record("campaign_character_skills_link", "script_link_campaign_character_skills_link", "tooltip_campaign_character_skills_link");
	tp_character_skills = tooltip_patcher:new("tooltip_campaign_character_skills_link");
	tp_character_skills:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_character_skills_link");
	
	tl_character_skills_link = tooltip_listener:new(
		"tooltip_campaign_character_skills_link",
		function()
			uim:highlight_character_skills(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	

	
	--
	-- character_traits
	--
	
	parser:add_record("campaign_character_traits", "script_link_campaign_character_traits", "tooltip_campaign_character_traits");
	tp_character_traits = tooltip_patcher:new("tooltip_campaign_character_traits");
	tp_character_traits:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_character_traits");
	
	tl_character_traits = tooltip_listener:new(
		"tooltip_campaign_character_traits",
		function()
			uim:highlight_character_traits(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- characters
	--

	hp_characters = help_page:new(
		"script_link_campaign_characters",
		hpr_title("war.camp.hp.characters.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/characters.png"),
		hpr_leader("war.camp.hp.characters.002"),
		hpr_normal("war.camp.hp.characters.003"),
		hpr_normal("war.camp.hp.characters.004")
	);
	parser:add_record("campaign_characters", "script_link_campaign_characters", "tooltip_campaign_characters");
	tp_characters = tooltip_patcher:new("tooltip_campaign_characters");
	tp_characters:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_characters",
		"ui_text_replacements_localised_text_hp_campaign_description_characters", 
		"UI/help_images/characters.png"
	);

	
	--
	-- chivalry
	--

	hp_chivalry = help_page:new(
		"script_link_campaign_chivalry",
		hpr_title("war.camp.hp.chivalry.001"),
		hpr_leader("war.camp.hp.chivalry.002"),
		hpr_normal("war.camp.hp.chivalry.003"),
		hpr_normal("war.camp.hp.chivalry.004"),
		hpr_normal("war.camp.hp.chivalry.005"),
		hpr_normal("war.camp.hp.chivalry.006"),
		hpr_normal("war.camp.hp.chivalry.007")
	);
	parser:add_record("campaign_chivalry", "script_link_campaign_chivalry", "tooltip_campaign_chivalry");
	tp_chivalry = tooltip_patcher:new("tooltip_campaign_chivalry");
	tp_chivalry:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_chivalry", "ui_text_replacements_localised_text_hp_campaign_description_chivalry");
	
	tl_chivalry = tooltip_listener:new(
		"tooltip_campaign_chivalry", 
		function() 
			uim:highlight_chivalry(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- chivalry_link
	--
	
	parser:add_record("campaign_chivalry_link", "script_link_campaign_chivalry_link", "tooltip_campaign_chivalry_link");
	tp_chivalry_link = tooltip_patcher:new("tooltip_campaign_chivalry_link");
	tp_chivalry_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_chivalry_link");
	
	tl_chivalry_link = tooltip_listener:new(
		"tooltip_campaign_chivalry_link", 
		function() 
			uim:highlight_chivalry(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- conclave_influence_link
	--
	script_feature_name = "conclave_influence";
	parser:add_record("campaign_"..script_feature_name.."_link", "script_link_campaign_"..script_feature_name.."_link", "tooltip_campaign_"..script_feature_name.."_link");
	tp_conclave_influence = tooltip_patcher:new("tooltip_campaign_"..script_feature_name.."_link");
	tp_conclave_influence:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_"..script_feature_name.."_link");


	--
	-- commandments
	--

	hp_commandments = help_page:new(
		"script_link_campaign_commandments",
		hpr_title("war.camp.hp.commandments.001"),
		hpr_leader("war.camp.hp.commandments.002"),
		hpr_normal("war.camp.hp.commandments.003"),
		hpr_normal("war.camp.hp.commandments.004"),
		hpr_normal("war.camp.hp.commandments.005"),
		hpr_normal("war.camp.hp.commandments.006"),
		hpr_normal("war.camp.hp.commandments.008")
	);
	parser:add_record("campaign_commandments", "script_link_campaign_commandments", "tooltip_campaign_commandments");
	tp_edicts = tooltip_patcher:new("tooltip_campaign_commandments");
	tp_edicts:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_commandments", "ui_text_replacements_localised_text_hp_campaign_description_commandments");
	
	tl_commandments = tooltip_listener:new(
		"tooltip_campaign_commandments", 
		function() 
			uim:highlight_commandments(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- commandments_link
	--
	
	parser:add_record("campaign_commandments_link", "script_link_campaign_commandments_link", "tooltip_campaign_commandments_link");
	tp_commandments = tooltip_patcher:new("tooltip_campaign_commandments_link");
	tp_commandments:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_commandments_link");
	
	tl_commandments_link = tooltip_listener:new(
		"tooltip_campaign_commandments_link",
		function()
			uim:highlight_commandments(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- commandments_rollout
	--
	
	parser:add_record("campaign_commandments_rollout", "script_link_campaign_commandments_rollout", "tooltip_campaign_commandments_rollout");
	tp_commandments_rollout = tooltip_patcher:new("tooltip_campaign_commandments_rollout");
	tp_commandments_rollout:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_commandments_link");
	
	tp_commandments_rollout = tooltip_listener:new(
		"tooltip_campaign_commandments_rollout",
		function()
			uim:highlight_commandments(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- compass
	--

	hp_compass = help_page:new(
		"script_link_campaign_compass",
		hpr_title("war.camp.hp.compass.001"),
		hpr_leader("war.camp.hp.compass.002"),
		hpr_normal("war.camp.hp.compass.003"),
		hpr_normal("war.camp.hp.compass.004"),
		hpr_normal("war.camp.hp.compass.005"),
		hpr_normal("war.camp.hp.compass.006")
	);
	parser:add_record("campaign_compass", "script_link_campaign_compass", "tooltip_campaign_compass");
	tp_compass = tooltip_patcher:new("tooltip_campaign_compass");
	tp_compass:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_compass", "ui_text_replacements_localised_text_hp_campaign_description_compass");

	tl_compass = tooltip_listener:new(
		"tooltip_campaign_compass", 
		function() 
			uim:highlight_cathay_compass(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- compass_link
	--
	
	parser:add_record("campaign_compass_link", "script_link_campaign_compass_link", "tooltip_campaign_compass_link");
	tp_compass_link = tooltip_patcher:new("tooltip_campaign_compass_link");
	tp_compass_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_compass_link");
	
	tl_compass_link = tooltip_listener:new(
		"tooltip_campaign_compass_link",
		function()
			uim:highlight_cathay_compass(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- compass_panel
	--

	parser:add_record("campaign_compass_panel", "script_link_campaign_compass_panel", "tooltip_campaign_compass_panel");
	tp_compass_panel = tooltip_patcher:new("tooltip_campaign_compass_panel");
	tp_compass_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_compass_panel");
	
	tl_compass_panel = tooltip_listener:new(
		"tooltip_campaign_compass_panel", 
		function() 
			uim:highlight_cathay_compass(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);

	
	
	--
	-- confederation
	--

	hp_confederation = help_page:new(
		"script_link_campaign_confederation",
		hpr_title("war.camp.hp.confederation.001"),
		hpr_leader("war.camp.hp.confederation.002"),
		hpr_normal("war.camp.hp.confederation.003"),
		hpr_normal("war.camp.hp.confederation.004"),
		hpr_normal("war.camp.hp.confederation.005")
	);
	parser:add_record("campaign_confederation", "script_link_campaign_confederation", "tooltip_campaign_confederation");
	tp_confederation = tooltip_patcher:new("tooltip_campaign_confederation");
	tp_confederation:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_confederation", "ui_text_replacements_localised_text_hp_campaign_description_confederation");



	--
	-- confederation_link
	--
	script_feature_name = "confederation";
	parser:add_record("campaign_"..script_feature_name.."_link", "script_link_campaign_"..script_feature_name.."_link", "tooltip_campaign_"..script_feature_name.."_link");
	tp_confederation_link = tooltip_patcher:new("tooltip_campaign_"..script_feature_name.."_link");
	tp_confederation_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_"..script_feature_name.."_link");
	
	tl_confederation_link = tooltip_listener:new(
		"tooltip_campaign_"..script_feature_name.."_link",
		function()
			uim:highlight_confederation(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- contracts
	--

	hp_contracts = help_page:new(
		"script_link_campaign_contracts",
		hpr_title("war.camp.hp.contracts.001"),
		hpr_leader("war.camp.hp.contracts.002"),
		hpr_normal("war.camp.hp.contracts.003"),
		hpr_normal("war.camp.hp.contracts.004"),
		hpr_normal("war.camp.hp.contracts.005")
	);
	parser:add_record("campaign_contracts", "script_link_campaign_contracts", "tooltip_campaign_contracts");
	tp_contracts = tooltip_patcher:new("tooltip_campaign_contracts");
	tp_contracts:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_contracts", "ui_text_replacements_localised_text_hp_campaign_description_contracts");



	--
	-- contracts_link
	--
	script_feature_name = "contracts";
	parser:add_record("campaign_"..script_feature_name.."_link", "script_link_campaign_"..script_feature_name.."_link", "tooltip_campaign_"..script_feature_name.."_link");
	tp_contracts = tooltip_patcher:new("tooltip_campaign_"..script_feature_name.."_link");
	tp_contracts:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_"..script_feature_name.."_link");
	
	tl_contracts_link = tooltip_listener:new(
		"tooltip_campaign_"..script_feature_name.."_link",
		function()
			uim:highlight_ogre_contracts(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- contracts_panel
	--

	parser:add_record("campaign_contracts_panel", "script_link_campaign_contracts_panel", "tooltip_campaign_contracts_panel");
	tp_contracts_panel = tooltip_patcher:new("tooltip_campaign_contracts_panel");
	tp_contracts_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_contracts_panel");
	
	tl_contracts_panel = tooltip_listener:new(
		"tooltip_campaign_contracts_panel", 
		function() 
			uim:highlight_ogre_contracts(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- controls_cheat_sheet
	--
	
	hp_controls_cheat_sheet = help_page:new(
		"script_link_campaign_controls_cheat_sheet",
		hpr_title("war.camp.hp.controls_cheat_sheet.001"),
		hpr_campaign_camera_controls("war.camp.hp.controls_cheat_sheet.002"),
		hpr_campaign_camera_controls_alt("war.camp.hp.controls_cheat_sheet.003"),
		hpr_campaign_camera_altitude_controls("war.camp.hp.controls_cheat_sheet.004")--[[,
		hpr_campaign_camera_facing_controls("war.camp.hp.controls_cheat_sheet.005")
		]]
	);
	parser:add_record("campaign_controls_cheat_sheet", "script_link_campaign_controls_cheat_sheet", "tooltip_campaign_controls_cheat_sheet");

	
	
	--
	-- corruption
	--

	hp_corruption = help_page:new(
		"script_link_campaign_corruption",
		hpr_title("war.camp.hp.corruption.001"),
		hpr_leader("war.camp.hp.corruption.002"),
		hpr_normal("war.camp.hp.corruption.003"),
		hpr_normal("war.camp.hp.corruption.004"),
		hpr_normal("war.camp.hp.corruption.005"),
		hpr_normal("war.camp.hp.corruption.006"),
		hpr_normal("war.camp.hp.corruption.007"),
		hpr_normal("war.camp.hp.corruption.009")
	);
	parser:add_record("campaign_corruption", "script_link_campaign_corruption", "tooltip_campaign_corruption");
	tp_corruption = tooltip_patcher:new("tooltip_campaign_corruption");
	tp_corruption:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_corruption", "ui_text_replacements_localised_text_hp_campaign_description_corruption");
	
	tl_corruption = tooltip_listener:new(
		"tooltip_campaign_corruption", 
		function()
			uim:highlight_corruption(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- corruption_link
	--
	
	parser:add_record("campaign_corruption_link", "script_link_campaign_corruption_link", "tooltip_campaign_corruption_link");
	tp_corruption = tooltip_patcher:new("tooltip_campaign_corruption_link");
	tp_corruption:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_corruption_link");
	
	tl_corruption_link = tooltip_listener:new(
		"tooltip_campaign_corruption_link",
		function()
			uim:highlight_corruption(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- cyclical_buildings
	--

	hp_cyclical_buildings = help_page:new(
		"script_link_campaign_cyclical_buildings",
		hpr_title("war.camp.hp.cyclical_buildings.001"),
		hpr_leader("war.camp.hp.cyclical_buildings.002"),
		hpr_normal("war.camp.hp.cyclical_buildings.003"),
		hpr_normal("war.camp.hp.cyclical_buildings.004"),
		hpr_normal("war.camp.hp.cyclical_buildings.005")
	);
	parser:add_record("campaign_cyclical_buildings", "script_link_campaign_cyclical_buildings", "tooltip_campaign_cyclical_buildings");
	tp_cyclical_buildings = tooltip_patcher:new("tooltip_campaign_cyclical_buildings");
	tp_cyclical_buildings:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_cyclical_buildings", "ui_text_replacements_localised_text_hp_campaign_description_cyclical_buildings");


	--
	-- daemonic_gifts
	--

	parser:add_record("campaign_daemonic_gifts", "script_link_campaign_daemonic_gifts", "tooltip_campaign_daemonic_gifts");
	tp_daemonic_gifts = tooltip_patcher:new("tooltip_campaign_daemonic_gifts");
	tp_daemonic_gifts:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_daemonic_gifts");
	
	tl_daemonic_gifts = tooltip_listener:new(
		"tooltip_campaign_daemonic_gifts", 
		function() 
			uim:highlight_daemonic_glory_panel(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- daemonic_glory
	--

	hp_daemonic_glory = help_page:new(
		"script_link_campaign_daemonic_glory",
		hpr_title("war.camp.hp.daemonic_glory.001"),
		hpr_leader("war.camp.hp.daemonic_glory.002"),
		hpr_normal("war.camp.hp.daemonic_glory.003"),
		hpr_normal("war.camp.hp.daemonic_glory.004"),
		hpr_normal("war.camp.hp.daemonic_glory.005"),
		hpr_normal("war.camp.hp.daemonic_glory.006"),
		hpr_normal("war.camp.hp.daemonic_glory.007")
	);
	parser:add_record("campaign_daemonic_glory", "script_link_campaign_daemonic_glory", "tooltip_campaign_daemonic_glory");
	tp_daemonic_glory = tooltip_patcher:new("tooltip_campaign_daemonic_glory");
	tp_daemonic_glory:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_daemonic_glory", "ui_text_replacements_localised_text_hp_campaign_description_daemonic_glory");
	
	tl_daemonic_glory = tooltip_listener:new(
		"tooltip_campaign_daemonic_glory",
		function()
			uim:highlight_daemonic_glory_counters(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- daemonic_glory_link
	--
	script_feature_name = "daemonic_glory";
	parser:add_record("campaign_"..script_feature_name.."_link", "script_link_campaign_"..script_feature_name.."_link", "tooltip_campaign_"..script_feature_name.."_link");
	tp_daemonic_glory_link = tooltip_patcher:new("tooltip_campaign_"..script_feature_name.."_link");
	tp_daemonic_glory_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_"..script_feature_name.."_link");
	
	tl_daemonic_glory_link = tooltip_listener:new(
		"tooltip_campaign_"..script_feature_name.."_link",
		function()
			uim:highlight_daemonic_glory_counters(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);

	--
	-- daemonic_glory_panel
	--

	parser:add_record("campaign_daemonic_glory_panel", "script_link_campaign_daemonic_glory_panel", "tooltip_campaign_daemonic_glory_panel");
	tp_daemonic_glory_panel = tooltip_patcher:new("tooltip_campaign_daemonic_glory_panel");
	tp_daemonic_glory_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_daemonic_glory_panel");
	
	tl_daemonic_glory_panel = tooltip_listener:new(
		"tooltip_campaign_daemonic_glory_panel", 
		function() 
			uim:highlight_daemonic_glory_panel(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- daemons_of_chaos
	--

	hp_daemons_of_chaos = help_page:new(
		"script_link_campaign_daemons_of_chaos",
		hpr_title("war.camp.hp.daemons_of_chaos.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/daemons_of_chaos.png"),
		hpr_leader("war.camp.hp.daemons_of_chaos.002"),
		hpr_normal("war.camp.hp.daemons_of_chaos.003"),

		hpr_section("glory"),
		hpr_normal_unfaded("war.camp.hp.daemons_of_chaos.004", "glory"),
		hpr_normal("war.camp.hp.daemons_of_chaos.005", "glory"),
		hpr_normal("war.camp.hp.daemons_of_chaos.006", "glory"),

		hpr_section("dedication"),
		hpr_normal_unfaded("war.camp.hp.daemons_of_chaos.007", "dedication"),
		hpr_normal("war.camp.hp.daemons_of_chaos.008", "dedication")
	);
	parser:add_record("campaign_daemons_of_chaos", "script_link_campaign_daemons_of_chaos", "tooltip_campaign_daemons_of_chaos");
	tp_daemons_of_chaos = tooltip_patcher:new("tooltip_campaign_daemons_of_chaos");
	tp_daemons_of_chaos:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_daemons_of_chaos",
		"ui_text_replacements_localised_text_hp_campaign_description_daemons_of_chaos", 
		"UI/help_images/daemons_of_chaos.png"
	);
	
	--
	-- dark authority
	--

	hp_dark_authority = help_page:new(
		"script_link_campaign_dark_authority",
		hpr_title("war.camp.hp.dark_authority.001"),
		hpr_leader("war.camp.hp.dark_authority.002"),
		hpr_normal("war.camp.hp.dark_authority.003"),
		hpr_normal("war.camp.hp.dark_authority.004"),
		hpr_normal("war.camp.hp.dark_authority.005")
	);
	parser:add_record("campaign_dark_authority", "script_link_campaign_dark_authority", "tooltip_campaign_dark_authority");
	tp_dark_authority = tooltip_patcher:new("tooltip_campaign_dark_authority");
	tp_dark_authority:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_dark_authority", "ui_text_replacements_localised_text_hp_campaign_description_dark_authority");

	--
	-- dark fortress
	--

	hp_dark_fortress = help_page:new(
		"script_link_campaign_dark_fortress",
		hpr_title("war.camp.hp.dark_fortress.001"),
		hpr_leader("war.camp.hp.dark_fortress.002"),
		hpr_normal("war.camp.hp.dark_fortress.003"),
		hpr_normal("war.camp.hp.dark_fortress.004")
	);
	parser:add_record("campaign_dark_fortress", "script_link_campaign_dark_fortress", "tooltip_campaign_dark_fortress");
	tp_dark_fortress = tooltip_patcher:new("tooltip_campaign_dark_fortress");
	tp_dark_fortress:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_dark_fortress", "ui_text_replacements_localised_text_hp_campaign_description_dark_fortress");


	--
	-- dark_elf_loyalty
	--

	hp_dark_elf_loyalty = help_page:new(
		"script_link_campaign_dark_elf_loyalty",
		hpr_title("war.camp.hp.dark_elf_loyalty.001"),
		hpr_leader("war.camp.hp.dark_elf_loyalty.002"),
		hpr_normal("war.camp.hp.dark_elf_loyalty.003"),
		hpr_normal("war.camp.hp.dark_elf_loyalty.004"),
		hpr_normal("war.camp.hp.dark_elf_loyalty.005")
	);
	parser:add_record("campaign_dark_elf_loyalty", "script_link_campaign_dark_elf_loyalty", "tooltip_campaign_dark_elf_loyalty");
	tp_dark_elf_loyalty = tooltip_patcher:new("tooltip_campaign_dark_elf_loyalty");
	tp_dark_elf_loyalty:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_dark_elf_loyalty", "ui_text_replacements_localised_text_hp_campaign_description_dark_elf_loyalty");
	
	
	--
	-- dark_elves
	--

	hp_dark_elves = help_page:new(
		"script_link_campaign_dark_elves",
		hpr_title("war.camp.hp.dark_elves.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/dark_elves.png"),
		hpr_leader("war.camp.hp.dark_elves.002"),

		hpr_section("slaves"),
		hpr_normal_unfaded("war.camp.hp.dark_elves.003", "slaves"),
		hpr_normal("war.camp.hp.dark_elves.004", "slaves"),
		hpr_normal("war.camp.hp.dark_elves.005", "slaves"),

		hpr_section("black_arks"),
		hpr_normal_unfaded("war.camp.hp.dark_elves.006", "black_arks"),
		hpr_normal("war.camp.hp.dark_elves.007", "black_arks"),

		hpr_section("loyalty"),
		hpr_normal_unfaded("war.camp.hp.dark_elves.008", "loyalty"),
		hpr_normal("war.camp.hp.dark_elves.009", "loyalty")
	);
	parser:add_record("campaign_dark_elves", "script_link_campaign_dark_elves", "tooltip_campaign_dark_elves");
	tp_dark_elves = tooltip_patcher:new("tooltip_campaign_dark_elves");
	tp_dark_elves:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_dark_elves",
		"ui_text_replacements_localised_text_hp_campaign_description_dark_elves", 
		"UI/help_images/dark_elves.png"
	);


	
	--
	-- day_of_awakening
	--

	hp_day_of_awakening = help_page:new(
		"script_link_campaign_day_of_awakening",
		hpr_title("war.camp.hp.day_of_awakening.001"),
		hpr_leader("war.camp.hp.day_of_awakening.002"),
		hpr_normal("war.camp.hp.day_of_awakening.003"),
		hpr_normal("war.camp.hp.day_of_awakening.004"),
		hpr_normal("war.camp.hp.day_of_awakening.005"),
		hpr_normal("war.camp.hp.day_of_awakening.006")
	);
	parser:add_record("campaign_day_of_awakening", "script_link_campaign_day_of_awakening", "tooltip_campaign_day_of_awakening");
	tp_day_of_awakening = tooltip_patcher:new("tooltip_campaign_day_of_awakening");
	tp_day_of_awakening:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_day_of_awakening", "ui_text_replacements_localised_text_hp_campaign_description_day_of_awakening");

	
	
	--
	-- death_night
	--

	hp_death_night = help_page:new(
		"script_link_campaign_death_night",
		hpr_title("war.camp.hp.death_night.001"),
		hpr_leader("war.camp.hp.death_night.002"),
		hpr_normal("war.camp.hp.death_night.003"),
		hpr_normal("war.camp.hp.death_night.004"),
		hpr_normal("war.camp.hp.death_night.005"),
		hpr_normal("war.camp.hp.death_night.006"),
		hpr_normal("war.camp.hp.death_night.007")
	);
	parser:add_record("campaign_death_night", "script_link_campaign_death_night", "tooltip_campaign_death_night");
	tp_death_night = tooltip_patcher:new("tooltip_campaign_death_night");
	tp_death_night:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_death_night", "ui_text_replacements_localised_text_hp_campaign_description_death_night");
	
	
	--
	-- death_night_bar
	--
	
	parser:add_record("campaign_death_night_bar", "script_link_campaign_death_night_bar", "tooltip_campaign_death_night_bar");
	tp_death_night_bar = tooltip_patcher:new("tooltip_campaign_death_night_bar");
	tp_death_night_bar:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_death_night_button");
	
	
	--
	-- death_night_button
	--
	
	parser:add_record("campaign_death_night_button", "script_link_campaign_death_night_button", "tooltip_campaign_death_night_button");
	tp_death_night_button = tooltip_patcher:new("tooltip_campaign_death_night_button");
	tp_death_night_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_death_night_button");
	
	
	--
	-- death_night_link
	--
	
	parser:add_record("campaign_death_night_link", "script_link_campaign_death_night_link", "tooltip_campaign_death_night_link");
	tp_death_night = tooltip_patcher:new("tooltip_campaign_death_night_link");
	tp_death_night:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_death_night_button");


	--
	-- dedication
	--

	hp_dedication = help_page:new(
		"script_link_campaign_dedication",
		hpr_title("war.camp.hp.dedication.001"),
		hpr_leader("war.camp.hp.dedication.002"),
		hpr_normal("war.camp.hp.dedication.003"),
		hpr_normal("war.camp.hp.dedication.004"),
		hpr_normal("war.camp.hp.dedication.005")
	);
	parser:add_record("campaign_dedication", "script_link_campaign_dedication", "tooltip_campaign_dedication");
	tp_dedication = tooltip_patcher:new("tooltip_campaign_dedication");
	tp_dedication:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_dedication", "ui_text_replacements_localised_text_hp_campaign_description_dedication");
	
	tl_daemonic_gifts = tooltip_listener:new(
		"tooltip_campaign_dedication", 
		function() 
			uim:highlight_daemonic_glory_panel(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- dedication_link
	--
	script_feature_name = "dedication";
	parser:add_record("campaign_"..script_feature_name.."_link", "script_link_campaign_"..script_feature_name.."_link", "tooltip_campaign_"..script_feature_name.."_link");
	tp_dedication_link = tooltip_patcher:new("tooltip_campaign_"..script_feature_name.."_link");
	tp_dedication_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_"..script_feature_name.."_link");
	
	tl_dedication_link = tooltip_listener:new(
		"tooltip_campaign_"..script_feature_name.."_link",
		function()
			uim:highlight_daemonic_dedication(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	--
	-- defence of the great plan
	--

	hp_defence_great_plan = help_page:new(
		"script_link_campaign_defence_great_plan",
		hpr_title("war.camp.hp.lizardmen_defence_great_plan.001"),
		hpr_leader("war.camp.hp.lizardmen_defence_great_plan.002"),
		hpr_normal("war.camp.hp.lizardmen_defence_great_plan.003"),
		hpr_normal("war.camp.hp.lizardmen_defence_great_plan.004"),
		hpr_normal("war.camp.hp.lizardmen_defence_great_plan.005"),
		hpr_normal("war.camp.hp.lizardmen_defence_great_plan.006"),
		hpr_normal("war.camp.hp.lizardmen_defence_great_plan.007")
	);
	parser:add_record("campaign_defence_great_plan", "script_link_campaign_defence_great_plan", "tooltip_campaign_defence_great_plan");
	tp_defence_great_plan = tooltip_patcher:new("tooltip_campaign_defence_great_plan");
	tp_defence_great_plan:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_lizardmen_defence_great_plan", "ui_text_replacements_localised_text_hp_campaign_description_lizardmen_defence_great_plan");
	
	--
	-- defender_of_ulthuan
	--

	hp_defender_of_ulthuan = help_page:new(
		"script_link_campaign_defender_of_ulthuan",
		hpr_title("war.camp.hp.defender_of_ulthuan.001"),
		hpr_leader("war.camp.hp.defender_of_ulthuan.002"),
		hpr_normal("war.camp.hp.defender_of_ulthuan.003"),
		hpr_normal("war.camp.hp.defender_of_ulthuan.004"),
		hpr_normal("war.camp.hp.defender_of_ulthuan.005"),
		hpr_normal("war.camp.hp.defender_of_ulthuan.006"),
		hpr_normal("war.camp.hp.defender_of_ulthuan.007")
	
	);
	parser:add_record("campaign_defender_of_ulthuan", "script_link_campaign_defender_of_ulthuan", "tooltip_campaign_defender_of_ulthuan");
	tp_defender_of_ulthuan = tooltip_patcher:new("tooltip_campaign_defender_of_ulthuan");
	tp_defender_of_ulthuan:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_defender_of_ulthuan", "ui_text_replacements_localised_text_hp_campaign_description_defender_of_ulthuan");
	
	
	
	--
	-- defender_of_ulthuan_link
	--
	
	parser:add_record("campaign_defender_of_ulthuan_link", "script_link_campaign_defender_of_ulthuan_link", "tooltip_campaign_defender_of_ulthuan_link");
	tp_defender_of_ulthuan = tooltip_patcher:new("tooltip_campaign_defender_of_ulthuan_link");
	tp_defender_of_ulthuan:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_defender_of_ulthuan_link");
	
	
	
	--
	-- defender_of_ulthuan_button
	--
	
	parser:add_record("campaign_defender_of_ulthuan_button", "script_link_campaign_defender_of_ulthuan_button", "tooltip_campaign_defender_of_ulthuan_button");
	tp_defender_of_ulthuan_button = tooltip_patcher:new("tooltip_campaign_defender_of_ulthuan_button");
	tp_defender_of_ulthuan_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_defender_of_ulthuan_button");

	
	
	--
	-- desert_thirst
	--

	hp_bretonnian_desert_thirst = help_page:new(
		"script_link_campaign_bretonnian_desert_thirst", 
		hpr_title("war.camp.hp.bretonnian_desert_thirst.001"),
		hpr_leader("war.camp.hp.bretonnian_desert_thirst.002"),
		hpr_normal("war.camp.hp.bretonnian_desert_thirst.003"),
		hpr_normal("war.camp.hp.bretonnian_desert_thirst.004"),
		hpr_normal("war.camp.hp.bretonnian_desert_thirst.005")
	);
	parser:add_record("campaign_bretonnian_desert_thirst", "script_link_campaign_bretonnian_desert_thirst", "tooltip_campaign_bretonnian_desert_thirst");
	tp_bretonnian_desert_thirst = tooltip_patcher:new("tooltip_campaign_bretonnian_desert_thirst");
	tp_bretonnian_desert_thirst:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_bretonnian_desert_thirst", "ui_text_replacements_localised_text_hp_campaign_description_bretonnian_desert_thirst");
	
	

	--
	-- devotees
	--

	hp_devotees = help_page:new(
		"script_link_campaign_devotees",
		hpr_title("war.camp.hp.devotees.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/devotees.png"),
		hpr_leader("war.camp.hp.devotees.002"),
		hpr_normal("war.camp.hp.devotees.003"),

		hpr_section("gaining_devotees"),
		hpr_normal_unfaded("war.camp.hp.devotees.004", "gaining_devotees"),
		hpr_normal("war.camp.hp.devotees.005", "gaining_devotees"),

		hpr_section("disciple_armies"),
		hpr_normal_unfaded("war.camp.hp.devotees.006", "disciple_armies"),
		hpr_normal("war.camp.hp.devotees.007", "disciple_armies"),

		hpr_section("chaos_cults"),
		hpr_normal_unfaded("war.camp.hp.devotees.008", "chaos_cults"),
		hpr_normal("war.camp.hp.devotees.009", "chaos_cults"),

		hpr_section("seductive_influence"),
		hpr_normal_unfaded("war.camp.hp.devotees.010", "seductive_influence"),
		hpr_normal("war.camp.hp.devotees.011", "seductive_influence"),

		hpr_section("pleasurable_acts"),
		hpr_normal_unfaded("war.camp.hp.devotees.012", "pleasurable_acts"),
		hpr_normal("war.camp.hp.devotees.013", "pleasurable_acts")
	);
	parser:add_record("campaign_devotees", "script_link_campaign_devotees", "tooltip_campaign_devotees");
	tp_devotees = tooltip_patcher:new("tooltip_campaign_devotees");
	tp_devotees:set_layout_data(
		"tooltip_title_text_and_image", 
		"ui_text_replacements_localised_text_hp_campaign_title_devotees", 
		"ui_text_replacements_localised_text_hp_campaign_description_devotees",
		"UI/help_images/devotees.png"
	);

	tl_devotees = tooltip_listener:new(
		"tooltip_campaign_devotees", 
		function() 
			uim:highlight_devotees(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- devotees_link
	--
	
	parser:add_record("campaign_devotees_link", "script_link_campaign_devotees_link", "tooltip_campaign_devotees_link");
	tp_devotees_link = tooltip_patcher:new("tooltip_campaign_devotees_link");
	tp_devotees_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_devotees_link");
	
	tl_devotees_link = tooltip_listener:new(
		"tooltip_campaign_devotees_link",
		function()
			uim:highlight_devotees(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- devotees_counter
	--

	parser:add_record("campaign_devotees_counter", "script_link_campaign_devotees_counter", "tooltip_campaign_devotees_counter");
	tp_devotees_counter = tooltip_patcher:new("tooltip_campaign_devotees_counter");
	tp_devotees_counter:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_devotees_counter");
	
	tl_devotees_counter = tooltip_listener:new(
		"tooltip_campaign_devotees_counter", 
		function() 
			uim:highlight_devotees(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	

	--
	-- devotion
	--

	hp_devotion = help_page:new(
		"script_link_campaign_devotion",
		hpr_title("war.camp.hp.devotion.001"),
		hpr_leader("war.camp.hp.devotion.002"),
		hpr_normal("war.camp.hp.devotion.003"),
		hpr_normal("war.camp.hp.devotion.004"),
		hpr_normal("war.camp.hp.devotion.005"),
		hpr_normal("war.camp.hp.devotion.006")
	
	);
	parser:add_record("campaign_devotion", "script_link_campaign_devotion", "tooltip_campaign_devotion");
	tp_devotion = tooltip_patcher:new("tooltip_campaign_devotion");
	tp_devotion:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_devotion", "ui_text_replacements_localised_text_hp_campaign_description_devotion");

	tl_devotion = tooltip_listener:new(
		"tooltip_campaign_devotion", 
		function() 
			uim:highlight_devotion(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- devotion_link
	--
	script_feature_name = "devotion";
	parser:add_record("campaign_"..script_feature_name.."_link", "script_link_campaign_"..script_feature_name.."_link", "tooltip_campaign_"..script_feature_name.."_link");
	tp_devotion_link = tooltip_patcher:new("tooltip_campaign_"..script_feature_name.."_link");
	tp_devotion_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_"..script_feature_name.."_link");
	
	tl_devotion_link = tooltip_listener:new(
		"tooltip_campaign_"..script_feature_name.."_link",
		function()
			uim:highlight_devotion(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- devotion_icon
	--

	parser:add_record("campaign_devotion_icon", "script_link_campaign_devotion_icon", "tooltip_campaign_devotion_icon");
	tp_devotion_icon = tooltip_patcher:new("tooltip_campaign_devotion_icon");
	tp_devotion_icon:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_devotion_icon");
	
	tl_devotion_icon = tooltip_listener:new(
		"tooltip_campaign_devotion_icon", 
		function() 
			uim:highlight_devotion(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- devotion_value
	--

	parser:add_record("campaign_devotion_value", "script_link_campaign_devotion_value", "tooltip_campaign_devotion_value");
	tp_devotion_value = tooltip_patcher:new("tooltip_campaign_devotion_value");
	tp_devotion_value:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_devotion_value");
	
	
	--
	-- diplomacy
	--

	hp_diplomacy = help_page:new(
		"script_link_campaign_diplomacy",
		hpr_title("war.camp.hp.diplomacy.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/diplomacy.png"),
		hpr_leader("war.camp.hp.diplomacy.002"),
		hpr_normal("war.camp.hp.diplomacy.003"),
		hpr_normal("war.camp.hp.diplomacy.004"),
		hpr_normal("war.camp.hp.diplomacy.005"),

		hpr_section("standing"),
		hpr_normal_unfaded("war.camp.hp.diplomacy.006", "standing"),
		hpr_normal("war.camp.hp.diplomacy.007", "standing"),
		hpr_normal("war.camp.hp.diplomacy.008", "standing"),

		hpr_section("alliances"),
		hpr_normal_unfaded("war.camp.hp.diplomacy.009", "alliances"),
		hpr_normal("war.camp.hp.diplomacy.010", "alliances"),

		hpr_section("confederation"),
		hpr_normal_unfaded("war.camp.hp.diplomacy.011", "confederation"),
		hpr_normal("war.camp.hp.diplomacy.012", "confederation"),
		hpr_normal("war.camp.hp.diplomacy.013", "confederation")
	);
	parser:add_record("campaign_diplomacy", "script_link_campaign_diplomacy", "tooltip_campaign_diplomacy");
	tp_diplomacy = tooltip_patcher:new("tooltip_campaign_diplomacy");
	tp_diplomacy:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_diplomacy",
		"ui_text_replacements_localised_text_hp_campaign_description_diplomacy",
		"UI/help_images/diplomacy.png"
	);
	
	
	--
	-- diplomacy_attitude_icons
	--
	
	parser:add_record("campaign_diplomacy_attitude_icons", "script_link_campaign_diplomacy_attitude_icons", "tooltip_campaign_diplomacy_attitude_icons");
	tp_diplomacy_attitude_icons = tooltip_patcher:new("tooltip_campaign_diplomacy_attitude_icons");
	tp_diplomacy_attitude_icons:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_diplomacy_attitude_icons");
	
	tl_diplomacy_attitude_icons = tooltip_listener:new(
		"tooltip_campaign_diplomacy_attitude_icons",
		function()
			uim:highlight_diplomacy_attitude_icons(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- diplomacy_buttton
	--
	
	parser:add_record("campaign_diplomacy_button", "script_link_campaign_diplomacy_button", "tooltip_campaign_diplomacy_button");
	tp_diplomacy_button = tooltip_patcher:new("tooltip_campaign_diplomacy_button");
	tp_diplomacy_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_diplomacy_button");
	
	tl_diplomacy_button = tooltip_listener:new(
		"tooltip_campaign_diplomacy_button", 
		function() 
			uim:highlight_diplomacy_button(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- diplomacy_centre_panel
	--
	
	parser:add_record("campaign_diplomacy_centre_panel", "script_link_campaign_diplomacy_centre_panel", "tooltip_campaign_diplomacy_centre_panel");
	tp_diplomacy_centre_panel = tooltip_patcher:new("tooltip_campaign_diplomacy_centre_panel");
	tp_diplomacy_centre_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_diplomacy_centre_panel");
	
	tl_diplomacy_centre_panel = tooltip_listener:new(
		"tooltip_campaign_diplomacy_centre_panel",
		function()
			uim:highlight_diplomacy_centre_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- diplomacy_screen
	--

	hp_diplomacy_screen = help_page:new(
		"script_link_campaign_diplomacy_screen",
		hpr_title("war.camp.hp.diplomacy_screen.001"),
		hpr_leader("war.camp.hp.diplomacy_screen.002"),
		hpr_normal("war.camp.hp.diplomacy_screen.003"),
		hpr_normal("war.camp.hp.diplomacy_screen.004"),
		hpr_normal("war.camp.hp.diplomacy_screen.005"),
		hpr_normal("war.camp.hp.diplomacy_screen.006"),
		hpr_normal("war.camp.hp.diplomacy_screen.007")
	);
	parser:add_record("campaign_diplomacy_screen", "script_link_campaign_diplomacy_screen", "tooltip_campaign_diplomacy_screen");
	tp_diplomacy_screen = tooltip_patcher:new("tooltip_campaign_diplomacy_screen");
	tp_diplomacy_screen:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_diplomacy_screen", "ui_text_replacements_localised_text_hp_campaign_description_diplomacy_screen");

	tl_diplomacy_screen = tooltip_listener:new(
		"tooltip_campaign_diplomacy_screen", 
		function() 
			uim:highlight_diplomacy_screen(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- diplomacy_screen_link
	--
	
	parser:add_record("campaign_diplomacy_screen_link", "script_link_campaign_diplomacy_screen_link", "tooltip_campaign_diplomacy_screen_link");
	tp_diplomacy_screen = tooltip_patcher:new("tooltip_campaign_diplomacy_screen_link");
	tp_diplomacy_screen:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_diplomacy_screen_link");
	
	tl_diplomacy_screen_link = tooltip_listener:new(
		"tooltip_campaign_diplomacy_screen_link",
		function()
			uim:highlight_diplomacy_screen(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- disciple_armies
	--

	hp_disciple_armies = help_page:new(
		"script_link_campaign_disciple_armies",
		hpr_title("war.camp.hp.disciple_armies.001"),
		hpr_leader("war.camp.hp.disciple_armies.002"),
		hpr_normal("war.camp.hp.disciple_armies.003"),
		hpr_normal("war.camp.hp.disciple_armies.004"),
		hpr_normal("war.camp.hp.disciple_armies.005"),
		hpr_normal("war.camp.hp.disciple_armies.006")
	);
	parser:add_record("campaign_disciple_armies", "script_link_campaign_disciple_armies", "tooltip_campaign_disciple_armies");
	tp_disciple_armies = tooltip_patcher:new("tooltip_campaign_disciple_armies");
	tp_disciple_armies:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_disciple_armies", "ui_text_replacements_localised_text_hp_campaign_description_disciple_armies");

	tl_disciple_armies = tooltip_listener:new(
		"tooltip_campaign_disciple_armies",
		function()
			uim:highlight_summon_disciple_army(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- dragon taming
	--
	
	hp_dragon_taming = help_page:new(
		"script_link_campaign_dragon_taming",
		hpr_title("war.camp.hp.high_elves_dragon_taming.001"),
		hpr_leader("war.camp.hp.high_elves_dragon_taming.002"),
		hpr_normal("war.camp.hp.high_elves_dragon_taming.003"),
		hpr_normal("war.camp.hp.high_elves_dragon_taming.004"),
		hpr_normal("war.camp.hp.high_elves_dragon_taming.005"),
		hpr_normal("war.camp.hp.high_elves_dragon_taming.006"),
		hpr_normal("war.camp.hp.high_elves_dragon_taming.007")
	);
	parser:add_record("campaign_dragon_taming", "script_link_campaign_dragon_taming", "tooltip_campaign_dragon_taming");
	tp_dragon_taming = tooltip_patcher:new("tooltip_campaign_dragon_taming");
	tp_dragon_taming:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_high_elves_dragon_taming", "ui_text_replacements_localised_text_hp_campaign_description_high_elves_dragon_taming");


	--
	-- drawn_to_destruction
	--

	hp_drawn_to_destruction = help_page:new(
		"script_link_campaign_drawn_to_destruction",
		hpr_title("war.camp.hp.drawn_to_destruction.001"),
		hpr_leader("war.camp.hp.drawn_to_destruction.002"),
		hpr_normal("war.camp.hp.drawn_to_destruction.003"),
		hpr_normal("war.camp.hp.drawn_to_destruction.004"),
		hpr_normal("war.camp.hp.drawn_to_destruction.005")
	);
	parser:add_record("campaign_drawn_to_destruction", "script_link_campaign_drawn_to_destruction", "tooltip_campaign_drawn_to_destruction");
	tp_drawn_to_destruction = tooltip_patcher:new("tooltip_campaign_drawn_to_destruction");
	tp_drawn_to_destruction:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_drawn_to_destruction", "ui_text_replacements_localised_text_hp_campaign_description_drawn_to_destruction");

	
	
	--
	-- dread
	--

	hp_dread_panel = help_page:new(
		"script_link_campaign_dread",
		hpr_title("war.camp.hp.dread_panel.001"),
		hpr_leader("war.camp.hp.dread_panel.002"),
		hpr_normal("war.camp.hp.dread_panel.003"),
		hpr_normal("war.camp.hp.dread_panel.004"),
		hpr_normal("war.camp.hp.dread_panel.005"),
		hpr_normal("war.camp.hp.dread_panel.006"),
		hpr_normal("war.camp.hp.dread_panel.007")
	);
	parser:add_record("campaign_dread", "script_link_campaign_dread", "tooltip_campaign_dread");
	tp_dread_panel = tooltip_patcher:new("tooltip_campaign_dread");
	tp_dread_panel:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_dread_panel", "ui_text_replacements_localised_text_hp_campaign_description_dread_panel");



	--
	-- drill_of_hashut
	--
	script_feature_name = "drill_of_hashut";
	hp_drill_of_hashut = help_page:new(
		"script_link_campaign_"..script_feature_name,
		hpr_title("war.camp.hp.drill_of_hashut.001"),
		hpr_leader("war.camp.hp.drill_of_hashut.002"),
		
		hpr_section("building_drill_structure"),
		hpr_normal_unfaded("war.camp.hp.drill_of_hashut.003", "building_drill_structure"),
		hpr_normal("war.camp.hp.drill_of_hashut.004", "building_drill_structure"),

		hpr_section("gathering_drill_relics"),
		hpr_normal_unfaded("war.camp.hp.drill_of_hashut.005", "gathering_drill_relics"),
		hpr_normal("war.camp.hp.drill_of_hashut.006", "gathering_drill_relics")
	);
	parser:add_record("campaign_"..script_feature_name, "script_link_campaign_"..script_feature_name, "tooltip_campaign_"..script_feature_name);
	tp_drill_of_hashut = tooltip_patcher:new("tooltip_campaign_"..script_feature_name);
	tp_drill_of_hashut:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_"..script_feature_name, "ui_text_replacements_localised_text_hp_campaign_description_"..script_feature_name);
	

	--
	-- drill_of_hashut_link
	--
	script_feature_name = "drill_of_hashut";
	parser:add_record("campaign_"..script_feature_name.."_link", "script_link_campaign_"..script_feature_name.."_link", "tooltip_campaign_"..script_feature_name.."_link");
	tp_drill_of_hashut = tooltip_patcher:new("tooltip_campaign_"..script_feature_name.."_link");
	tp_drill_of_hashut:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_"..script_feature_name.."_link");
	
	tl_drill_of_hashut_link = tooltip_listener:new(
		"tooltip_campaign_"..script_feature_name.."_link",
		function()
			uim:highlight_drill_of_hashut(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);

	

	--
	-- drop_down_lists
	--

	hp_drop_down_lists = help_page:new(
		"script_link_campaign_drop_down_lists",
		hpr_title("war.camp.hp.drop_down_lists.001"),
		hpr_leader("war.camp.hp.drop_down_lists.002"),
		hpr_normal("war.camp.hp.drop_down_lists.003"),
		hpr_normal("war.camp.hp.drop_down_lists.004"),
		hpr_normal("war.camp.hp.drop_down_lists.005")
	);
	parser:add_record("campaign_drop_down_lists", "script_link_campaign_drop_down_lists", "tooltip_campaign_drop_down_lists");
	tp_drop_down_lists = tooltip_patcher:new("tooltip_campaign_drop_down_lists");
	tp_drop_down_lists:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_drop_down_lists", "ui_text_replacements_localised_text_hp_campaign_description_drop_down_lists");

	tl_drop_down_lists = tooltip_listener:new(
		"tooltip_campaign_drop_down_lists", 
		function() 
			uim:highlight_drop_down_list_buttons(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- drop_down_lists_link
	--
	
	parser:add_record("campaign_drop_down_lists_link", "script_link_campaign_drop_down_lists_link", "tooltip_campaign_drop_down_lists_link");
	tp_drop_down_lists = tooltip_patcher:new("tooltip_campaign_drop_down_lists_link");
	tp_drop_down_lists:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_drop_down_lists_link");
	
	tl_drop_down_lists_link = tooltip_listener:new(
		"tooltip_campaign_drop_down_lists_link",
		function()
			uim:highlight_drop_down_list_buttons(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	


	--
	-- dwarfs
	--
	
	hp_dwarfs = help_page:new(
		"script_link_campaign_dwarfs",
		hpr_title("war.camp.hp.dwarfs.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/dwarfs.png"),
		hpr_leader("war.camp.hp.dwarfs.002"),
		hpr_normal("war.camp.hp.dwarfs.003"),
		hpr_normal("war.camp.hp.dwarfs.004"),
		hpr_normal("war.camp.hp.dwarfs.005")
	);
	parser:add_record("campaign_dwarfs", "script_link_campaign_dwarfs", "tooltip_campaign_dwarfs");
	tp_dwarfs = tooltip_patcher:new("tooltip_campaign_dwarfs");
	tp_dwarfs:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_dwarfs",
		"ui_text_replacements_localised_text_hp_campaign_description_dwarfs",
		"UI/help_images/dwarfs.png"
	);
	
	
	--
	-- dynasties
	--
	
	hp_dynasties = help_page:new(
		"script_link_campaign_dynasties",
		hpr_title("war.camp.hp.dynasties.001"),
		hpr_leader("war.camp.hp.dynasties.002"),
		hpr_normal("war.camp.hp.dynasties.003"),
		hpr_normal("war.camp.hp.dynasties.004"),
		hpr_normal("war.camp.hp.dynasties.005")
	);
	parser:add_record("campaign_dynasties", "script_link_campaign_dynasties", "tooltip_campaign_dynasties");
	tp_dynasties = tooltip_patcher:new("tooltip_campaign_dynasties");
	tp_dynasties:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_dynasties", "ui_text_replacements_localised_text_hp_campaign_description_dynasties");
	
	tl_dynasties = tooltip_listener:new(
		"tooltip_campaign_dynasties",
		function()
			uim:highlight_dynasties(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- dynasties_link
	--

	parser:add_record("campaign_dynasties_link", "script_link_campaign_dynasties_link", "tooltip_campaign_dynasties_link");
	tp_dynasties_link = tooltip_patcher:new("tooltip_campaign_dynasties_link");
	tp_dynasties_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_dynasties_link");

	tl_dynasties_link = tooltip_listener:new(
		"tooltip_campaign_dynasties_link",
		function()
			uim:highlight_dynasties(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- dynasties_panel
	--

	parser:add_record("campaign_dynasties_panel", "script_link_campaign_dynasties_panel", "tooltip_campaign_dynasties_panel");
	tp_dynasties_panel = tooltip_patcher:new("tooltip_campaign_dynasties_panel");
	tp_dynasties_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_dynasties_panel");

	tl_dynasties_panel = tooltip_listener:new(
		"tooltip_campaign_dynasties_panel",
		function()
			uim:highlight_dynasties_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- elf glamouring
	--

	hp_armies = help_page:new(
		"script_link_campaign_elf_glamouring",
		hpr_title("war.camp.hp.wood_elves_elf_glamouring.001"),
		hpr_leader("war.camp.hp.wood_elves_elf_glamouring.002"),
		hpr_normal("war.camp.hp.wood_elves_elf_glamouring.003"),
		hpr_normal("war.camp.hp.wood_elves_elf_glamouring.004"),
		hpr_normal("war.camp.hp.wood_elves_elf_glamouring.005")
	);
	parser:add_record("campaign_elf_glamouring", "script_link_campaign_elf_glamouring", "tooltip_campaign_elf_glamouring");
	tp_elf_glamouring = tooltip_patcher:new("tooltip_campaign_elf_glamouring");
	tp_elf_glamouring:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_wood_elves_elf_glamouring", "ui_text_replacements_localised_text_hp_campaign_description_wood_elves_elf_glamouring");

	
	
	--
	-- elven council
	--

	hp_elven_council = help_page:new(
		"script_link_campaign_elven_council",
		hpr_title("war.camp.hp.elven_council.001"),
		hpr_leader("war.camp.hp.elven_council.002"),
		hpr_normal("war.camp.hp.elven_council.003"),
		hpr_normal("war.camp.hp.elven_council.004"),
		hpr_normal("war.camp.hp.elven_council.005"),
		hpr_normal("war.camp.hp.elven_council.006")
	);
	parser:add_record("campaign_elven_council", "script_link_campaign_elven_council", "tooltip_campaign_elven_council");
	tp_elven_council = tooltip_patcher:new("tooltip_campaign_elven_council");
	tp_elven_council:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_elven_council", "ui_text_replacements_localised_text_hp_campaign_description_elven_council");
	
	tl_elven_council = tooltip_listener:new(
		"tooltip_campaign_elven_council", 
		function()
			uim:highlight_offices(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- elven halls
	--

	hp_elven_halls = help_page:new(
		"script_link_campaign_elven_halls",
		hpr_title("war.camp.hp.elven_halls.001"),
		hpr_leader("war.camp.hp.elven_halls.002"),
		hpr_normal("war.camp.hp.elven_halls.003"),
		hpr_normal("war.camp.hp.elven_halls.004")
	);
	parser:add_record("campaign_elven_halls", "script_link_campaign_elven_halls", "tooltip_campaign_elven_halls");
	tp_elven_halls = tooltip_patcher:new("tooltip_campaign_elven_halls");
	tp_elven_halls:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_elven_halls", "ui_text_replacements_localised_text_hp_campaign_description_elven_halls");
	
	
	--
	-- emperors mandate
	--

	hp_emperors_mandate = help_page:new(
		"script_link_campaign_emperors_mandate",
		hpr_title("war.camp.hp.empire_emperors_mandate.001"),
		hpr_leader("war.camp.hp.empire_emperors_mandate.002"),
		hpr_normal("war.camp.hp.empire_emperors_mandate.003"),
		hpr_normal("war.camp.hp.empire_emperors_mandate.004"),
		hpr_normal("war.camp.hp.empire_emperors_mandate.005"),
		hpr_normal("war.camp.hp.empire_emperors_mandate.006"),
		hpr_normal("war.camp.hp.empire_emperors_mandate.007"),
		hpr_normal("war.camp.hp.empire_emperors_mandate.008"),
		hpr_normal("war.camp.hp.empire_emperors_mandate.009")
	);
	parser:add_record("campaign_emperors_mandate", "script_link_campaign_emperors_mandate", "tooltip_campaign_emperors_mandate");
	tp_emperors_mandate = tooltip_patcher:new("tooltip_campaign_emperors_mandate");
	tp_emperors_mandate:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_empire_emperors_mandate", "ui_text_replacements_localised_text_hp_campaign_description_empire_emperors_mandate");
		
	
	--
	-- empire
	--
	
	hp_empire = help_page:new(
		"script_link_campaign_empire",
		hpr_title("war.camp.hp.empire.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/empire.png"),
		hpr_leader("war.camp.hp.empire.002"),
		hpr_normal("war.camp.hp.empire.003"),
		hpr_normal("war.camp.hp.empire.004"),
		hpr_normal("war.camp.hp.empire.005"),
		hpr_normal("war.camp.hp.empire.007")
	);
	parser:add_record("campaign_empire", "script_link_campaign_empire", "tooltip_campaign_empire");
	tp_empire = tooltip_patcher:new("tooltip_campaign_empire");
	tp_empire:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_empire",
		"ui_text_replacements_localised_text_hp_campaign_description_empire",
		"UI/help_images/empire.png"
	);

	
	
	--
	-- empowering the compass
	--

	hp_empowering_the_compass = help_page:new(
		"script_link_campaign_empowering_the_compass",
		hpr_title("war.camp.hp.empowering_the_compass.001"),
		hpr_leader("war.camp.hp.empowering_the_compass.002"),
		hpr_normal("war.camp.hp.empowering_the_compass.003"),
		hpr_normal("war.camp.hp.empowering_the_compass.004"),
		hpr_normal("war.camp.hp.empowering_the_compass.005"),
		hpr_normal("war.camp.hp.empowering_the_compass.006")
	);
	parser:add_record("campaign_empowering_the_compass", "script_link_campaign_empowering_the_compass", "tooltip_campaign_empowering_the_compass");
	tp_empowering_the_compass = tooltip_patcher:new("tooltip_campaign_empowering_the_compass");
	tp_empowering_the_compass:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_empowering_the_compass", "ui_text_replacements_localised_text_hp_campaign_description_empowering_the_compass");
	
	
	--
	-- encounters_at_sea
	--

	hp_encounters_at_sea = help_page:new(
		"script_link_campaign_encounters_at_sea",
		hpr_title("war.camp.hp.encounters_at_sea.001"),
		hpr_leader("war.camp.hp.encounters_at_sea.002"),
		hpr_normal("war.camp.hp.encounters_at_sea.003"),
		hpr_normal("war.camp.hp.encounters_at_sea.004")
	);
	parser:add_record("campaign_encounters_at_sea", "script_link_campaign_encounters_at_sea", "tooltip_campaign_encounters_at_sea");
	tp_encounters_at_sea = tooltip_patcher:new("tooltip_campaign_encounters_at_sea");
	tp_encounters_at_sea:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_encounters_at_sea", "ui_text_replacements_localised_text_hp_campaign_description_encounters_at_sea");
	
	
	
	--
	-- end_turn_button
	--

	parser:add_record("campaign_end_turn_button", "script_link_campaign_end_turn_button", "tooltip_campaign_end_turn_button");
	tp_end_turn_button = tooltip_patcher:new("tooltip_campaign_end_turn_button");
	tp_end_turn_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_end_turn_button");
	
	tl_end_turn_button = tooltip_listener:new(
		"tooltip_campaign_end_turn_button", 
		function() 
			uim:highlight_end_turn_button(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- espionage
	--

	hp_espionage = help_page:new(
		"script_link_campaign_espionage",
		hpr_title("war.camp.hp.espionage.001"),
		hpr_leader("war.camp.hp.espionage.002"),
		hpr_normal("war.camp.hp.espionage.003")
	);
	parser:add_record("campaign_espionage", "script_link_campaign_espionage", "tooltip_campaign_espionage");
	tp_espionage = tooltip_patcher:new("tooltip_campaign_espionage");
	tp_espionage:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_espionage", "ui_text_replacements_localised_text_hp_campaign_description_espionage");
	
	
	
	--
	-- events_list
	--
	
	parser:add_record("campaign_events_list", "script_link_campaign_events_list", "tooltip_campaign_events_list");
	tp_events_list = tooltip_patcher:new("tooltip_campaign_events_list");
	tp_events_list:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_events_list");
	
	tl_events_list = tooltip_listener:new(
		"tooltip_campaign_events_list",
		function()
			uim:highlight_events_list(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- exalted_greater_daemons
	--

	hp_exalted_greater_daemons = help_page:new(
		"script_link_campaign_exalted_greater_daemons",
		hpr_title("war.camp.hp.exalted_greater_daemons.001"),
		hpr_leader("war.camp.hp.exalted_greater_daemons.002"),
		hpr_normal("war.camp.hp.exalted_greater_daemons.003"),
		hpr_normal("war.camp.hp.exalted_greater_daemons.004"),
		hpr_normal("war.camp.hp.exalted_greater_daemons.005"),
		hpr_normal("war.camp.hp.exalted_greater_daemons.006")
	);
	parser:add_record("campaign_exalted_greater_daemons", "script_link_campaign_exalted_greater_daemons", "tooltip_campaign_exalted_greater_daemons");
	tp_exalted_greater_daemons = tooltip_patcher:new("tooltip_campaign_exalted_greater_daemons");
	tp_exalted_greater_daemons:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_exalted_greater_daemons", "ui_text_replacements_localised_text_hp_campaign_description_exalted_greater_daemons");
	
	
	
	--
	-- faction_interfaces
	--

	hp_faction_interfaces = help_page:new(
		"script_link_campaign_faction_interfaces",
		hpr_title("war.camp.hp.faction_interfaces.001"),
		hpr_leader("war.camp.hp.faction_interfaces.002"),
		hpr_normal("war.camp.hp.faction_interfaces.003"),
		hpr_normal("war.camp.hp.faction_interfaces.004"),
		hpr_normal("war.camp.hp.faction_interfaces.005"),
		hpr_normal("war.camp.hp.faction_interfaces.006"),
		hpr_normal("war.camp.hp.faction_interfaces.007"),
		hpr_normal("war.camp.hp.faction_interfaces.009")
	);
	parser:add_record("campaign_faction_interfaces", "script_link_campaign_faction_interfaces", "tooltip_campaign_faction_interfaces");
	tp_faction_interfaces = tooltip_patcher:new("tooltip_campaign_faction_interfaces");
	tp_faction_interfaces:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_faction_interfaces", "ui_text_replacements_localised_text_hp_campaign_description_faction_interfaces");



	--
	-- faction_management
	--

	hp_faction_management = help_page:new(
		"script_link_campaign_faction_management",
		hpr_title("war.camp.hp.faction_management.001"),
		hpr_leader("war.camp.hp.faction_management.002"),
		hpr_normal("war.camp.hp.faction_management.003"),
		hpr_normal("war.camp.hp.faction_management.004"),
		hpr_normal("war.camp.hp.faction_management.005"),
		hpr_normal("war.camp.hp.faction_management.006")
	);
	parser:add_record("campaign_faction_management", "script_link_campaign_faction_management", "tooltip_campaign_faction_management");
	tp_faction_management = tooltip_patcher:new("tooltip_campaign_faction_management");
	tp_faction_management:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_faction_management", "ui_text_replacements_localised_text_hp_campaign_description_faction_management");


	
	--
	-- faction_summary_button
	--
	
	parser:add_record("campaign_faction_summary_button", "script_link_campaign_faction_summary_button", "tooltip_campaign_faction_summary_button");
	tp_faction_summary_button = tooltip_patcher:new("tooltip_campaign_faction_summary_button");
	tp_faction_summary_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_faction_summary_button");
	
	tl_faction_summary_button = tooltip_listener:new(
		"tooltip_campaign_faction_summary_button",
		function()
			uim:highlight_faction_summary_button(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- faction_summary_records_tab
	--
	
	parser:add_record("campaign_faction_summary_records_tab", "script_link_campaign_faction_summary_records_tab", "tooltip_campaign_faction_summary_records_tab");
	tp_faction_summary_records_tab = tooltip_patcher:new("tooltip_campaign_faction_summary_records_tab");
	tp_faction_summary_records_tab:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_faction_summary_records_tab");
	
	tl_faction_summary_records_tab = tooltip_listener:new(
		"tooltip_campaign_faction_summary_records_tab",
		function()
			uim:highlight_faction_summary_records_tab(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- faction_summary_screen
	--

	hp_faction_summary_screen = help_page:new(
		"script_link_campaign_faction_summary_screen",
		hpr_title("war.camp.hp.faction_summary_screen.001"),
		hpr_leader("war.camp.hp.faction_summary_screen.002"),
		hpr_normal("war.camp.hp.faction_summary_screen.003"),
		hpr_normal("war.camp.hp.faction_summary_screen.004"),
		hpr_normal("war.camp.hp.faction_summary_screen.005"),
		hpr_normal("war.camp.hp.faction_summary_screen.006"),
		hpr_normal("war.camp.hp.faction_summary_screen.008")
	);
	parser:add_record("campaign_faction_summary_screen", "script_link_campaign_faction_summary_screen", "tooltip_campaign_faction_summary_screen");
	tp_faction_summary_screen = tooltip_patcher:new("tooltip_campaign_faction_summary_screen");
	tp_faction_summary_screen:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_faction_summary_screen", "ui_text_replacements_localised_text_hp_campaign_description_faction_summary_screen");
	
	tl_faction_summary_screen = tooltip_listener:new(
		"tooltip_campaign_faction_summary_screen",
		function()
			uim:highlight_faction_summary_screen(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- faction_summary_screen_link
	--
	
	parser:add_record("campaign_faction_summary_screen_link", "script_link_campaign_faction_summary_screen_link", "tooltip_campaign_faction_summary_screen_link");
	tp_faction_summary_screen = tooltip_patcher:new("tooltip_campaign_faction_summary_screen_link");
	tp_faction_summary_screen:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_faction_summary_screen_link");
	
	tl_faction_summary_screen_link = tooltip_listener:new(
		"tooltip_campaign_faction_summary_screen_link",
		function()
			uim:highlight_faction_summary_screen(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
		
	--
	-- faction_summary_statistics_tab
	--
	
	parser:add_record("campaign_faction_summary_statistics_tab", "script_link_campaign_faction_summary_statistics_tab", "tooltip_campaign_faction_summary_statistics_tab");
	tp_faction_summary_statistics_tab = tooltip_patcher:new("tooltip_campaign_faction_summary_statistics_tab");
	tp_faction_summary_statistics_tab:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_faction_summary_statistics_tab");
	
	tl_faction_summary_statistics_tab = tooltip_listener:new(
		"tooltip_campaign_faction_summary_statistics_tab",
		function()
			uim:highlight_faction_summary_statistics_tab(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- faction_summary_summary_tab
	--
	
	parser:add_record("campaign_faction_summary_summary_tab", "script_link_campaign_faction_summary_summary_tab", "tooltip_campaign_faction_summary_summary_tab");
	tp_faction_summary_summary_tab = tooltip_patcher:new("tooltip_campaign_faction_summary_summary_tab");
	tp_faction_summary_summary_tab:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_faction_summary_summary_tab");
	
	tl_faction_summary_summary_tab = tooltip_listener:new(
		"tooltip_campaign_faction_summary_summary_tab",
		function()
			uim:highlight_faction_summary_summary_tab(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- factions
	--

	hp_factions = help_page:new(
		"script_link_campaign_factions",
		hpr_title("war.camp.hp.factions.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/factions.png"),
		hpr_leader("war.camp.hp.factions.002"),
		hpr_normal("war.camp.hp.factions.003"),
		hpr_normal("war.camp.hp.factions.004"),
		hpr_normal("war.camp.hp.factions.005"),
		hpr_normal("war.camp.hp.factions.006"),
		hpr_normal("war.camp.hp.factions.008")
	);
	parser:add_record("campaign_factions", "script_link_campaign_factions", "tooltip_campaign_factions");
	tp_factions = tooltip_patcher:new("tooltip_campaign_factions");
	tp_factions:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_factions",
		"ui_text_replacements_localised_text_hp_campaign_description_factions",
		"UI/help_images/factions.png"
	);

	
	--
	-- factions_list
	--
	
	parser:add_record("campaign_factions_list", "script_link_campaign_factions_list", "tooltip_campaign_factions_list");
	tp_factions_list = tooltip_patcher:new("tooltip_campaign_factions_list");
	tp_factions_list:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_factions_list");
	
	tl_factions_list = tooltip_listener:new(
		"tooltip_campaign_factions_list",
		function()
			uim:highlight_factions_list(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	--
	-- fleet_office
	--

	hp_fleet_office = help_page:new(
		"script_link_campaign_fleet_office",
		hpr_title("war.camp.hp.fleet_office.001"),
		hpr_leader("war.camp.hp.fleet_office.002"),
		hpr_normal("war.camp.hp.fleet_office.003"),
		hpr_normal("war.camp.hp.fleet_office.004"),
		hpr_normal("war.camp.hp.fleet_office.005"),
		hpr_normal("war.camp.hp.fleet_office.006")
	);
	parser:add_record("campaign_fleet_office", "script_link_campaign_fleet_office", "tooltip_campaign_fleet_office");
	tp_fleet_office = tooltip_patcher:new("tooltip_campaign_fleet_office");
	tp_fleet_office:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_fleet_office", "ui_text_replacements_localised_text_hp_campaign_description_fleet_office");
	
	
	tl_fleet_office = tooltip_listener:new(
		"tooltip_campaign_fleet_office", 
		function() 
			uim:highlight_fleet_office_button(true) 
		end,
		function() 
			uim:unhighlight_all_for_tooltips() 
		end
	);
	
	
	--
	-- fleet_office_link
	--
	
	parser:add_record("campaign_fleet_office_link", "script_link_campaign_fleet_office_link", "tooltip_campaign_fleet_office_link");
	tp_fleet_office_link = tooltip_patcher:new("tooltip_campaign_fleet_office_link");
	tp_fleet_office_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_fleet_office_link");
	
	tl_fleet_office_link = tooltip_listener:new(
		"tooltip_campaign_fleet_office_link",
		function()
			uim:highlight_fleet_office_button(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	--
	-- fleet_office_panel
	--
	
	parser:add_record("campaign_fleet_office_panel", "script_link_campaign_fleet_office_panel", "tooltip_campaign_fleet_office_panel");
	tp_fleet_office_panel = tooltip_patcher:new("tooltip_campaign_fleet_office_panel");
	tp_fleet_office_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_fleet_office_panel");
	
	tl_fleet_office_panel = tooltip_listener:new(
		"tooltip_campaign_fleet_office_panel",
		function()
			uim:highlight_fleet_office_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- flesh_lab
	--

	hp_flesh_lab = help_page:new(
		"script_link_campaign_flesh_lab",
		hpr_title("war.camp.hp.skaven_flesh_lab.001"),
		hpr_leader("war.camp.hp.skaven_flesh_lab.002"),
		hpr_normal("war.camp.hp.skaven_flesh_lab.003"),
		hpr_normal("war.camp.hp.skaven_flesh_lab.004"),
		hpr_normal("war.camp.hp.skaven_flesh_lab.005"),
		hpr_normal("war.camp.hp.skaven_flesh_lab.006"),
		hpr_normal("war.camp.hp.skaven_flesh_lab.007")
	);
	parser:add_record("campaign_flesh_lab", "script_link_campaign_flesh_lab", "tooltip_campaign_flesh_lab");
	tp_flesh_lab = tooltip_patcher:new("tooltip_campaign_flesh_lab");
	tp_flesh_lab:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_skaven_flesh_lab", "ui_text_replacements_localised_text_hp_campaign_description_skaven_flesh_lab");



	--
	-- followers
	--
	
	parser:add_record("campaign_followers", "script_link_campaign_followers", "tooltip_campaign_followers");
	tp_followers = tooltip_patcher:new("tooltip_campaign_followers");
	tp_followers:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_followers");
	
	tl_followers = tooltip_listener:new(
		"tooltip_campaign_followers",
		function()
			uim:highlight_ancillaries(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);

	
	
	--
	-- forbidden workshop
	--
	
	hp_forbidden_workshop = help_page:new(
		"script_link_campaign_forbidden_workshop",
		hpr_title("war.camp.hp.skaven_forbidden_workshop.001"),
		hpr_leader("war.camp.hp.skaven_forbidden_workshop.002"),
		hpr_normal("war.camp.hp.skaven_forbidden_workshop.003"),
		hpr_normal("war.camp.hp.skaven_forbidden_workshop.004"),
		hpr_normal("war.camp.hp.skaven_forbidden_workshop.005"),
		hpr_normal("war.camp.hp.skaven_forbidden_workshop.006"),
		hpr_normal("war.camp.hp.skaven_forbidden_workshop.007"),
		hpr_normal("war.camp.hp.skaven_forbidden_workshop.008"),
		hpr_normal("war.camp.hp.skaven_forbidden_workshop.009"),
		hpr_normal("war.camp.hp.skaven_forbidden_workshop.010"),
		hpr_normal("war.camp.hp.skaven_forbidden_workshop.011"),
		hpr_normal("war.camp.hp.skaven_forbidden_workshop.012")
	);
	parser:add_record("campaign_forbidden_workshop", "script_link_campaign_forbidden_workshop", "tooltip_campaign_forbidden_workshop");
	tp_forbidden_workshop = tooltip_patcher:new("tooltip_campaign_forbidden_workshop");
	tp_forbidden_workshop:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_skaven_forbidden_workshop", "ui_text_replacements_localised_text_hp_campaign_description_skaven_forbidden_workshop");
	
	tl_forbidden_workshop = tooltip_listener:new(
		"tooltip_campaign_forbidden_workshop", 
		function()
			-- script_error("WARNING: forbidden_workshop help page link tooltip shown but no highlight script created for it");
			-- uim:highlight_forbidden_workshop_button(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips() 
		end
	);	
	
	
	
	--
	-- forbidden workshop panel
	--
	
	parser:add_record("campaign_forbidden_workshop_panel", "script_link_campaign_forbidden_workshop_panel", "tooltip_campaign_forbidden_workshop_panel");
	tp_forbidden_workshop_panel = tooltip_patcher:new("tooltip_campaign_forbidden_workshop_panel");
	tp_forbidden_workshop_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_skaven_forbidden_workshop_panel");
	
	tl_forbidden_workshop_panel = tooltip_listener:new(
		"tooltip_campaign_forbidden_workshop_panel",
		function()
			uim:highlight_forbidden_workshop_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- fog_of_war
	--

	hp_fog_of_war = help_page:new(
		"script_link_campaign_fog_of_war",
		hpr_title("war.camp.hp.fog_of_war.001"),
		hpr_leader("war.camp.hp.fog_of_war.002"),
		hpr_normal("war.camp.hp.fog_of_war.003"),
		hpr_normal("war.camp.hp.fog_of_war.004"),
		hpr_normal("war.camp.hp.fog_of_war.005"),
		hpr_normal("war.camp.hp.fog_of_war.006")
	);
	parser:add_record("campaign_fog_of_war", "script_link_campaign_fog_of_war", "tooltip_campaign_fog_of_war");
	tp_fog_of_war = tooltip_patcher:new("tooltip_campaign_fog_of_war");
	tp_fog_of_war:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_fog_of_war", "ui_text_replacements_localised_text_hp_campaign_description_fog_of_war");
	
	
	
	--
	-- forest spirits & animals
	--

	hp_armies = help_page:new(
		"script_link_campaign_forest_spirits_animals",
		hpr_title("war.camp.hp.wood_elves_forest_spirits_animals.001"),
		hpr_leader("war.camp.hp.wood_elves_forest_spirits_animals.002"),
		hpr_normal("war.camp.hp.wood_elves_forest_spirits_animals.003"),
		hpr_normal("war.camp.hp.wood_elves_forest_spirits_animals.004"),
		hpr_normal("war.camp.hp.wood_elves_forest_spirits_animals.005"),
		hpr_normal("war.camp.hp.wood_elves_forest_spirits_animals.006"),
		hpr_normal("war.camp.hp.wood_elves_forest_spirits_animals.007")
	);
	parser:add_record("campaign_forest_spirits_animals", "script_link_campaign_forest_spirits_animals", "tooltip_campaign_forest_spirits_animals");
	tp_forest_spirits_animals = tooltip_patcher:new("tooltip_campaign_forest_spirits_animals");
	tp_forest_spirits_animals:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_wood_elves_forest_spirits_animals", "ui_text_replacements_localised_text_hp_campaign_description_wood_elves_forest_spirits_animals");
	
	
	
	--
	-- forge of daith
	--

	hp_armies = help_page:new(
		"script_link_campaign_forge_of_daith",
		hpr_title("war.camp.hp.wood_elves_forge_of_daith.001"),
		hpr_leader("war.camp.hp.wood_elves_forge_of_daith.002"),
		hpr_normal("war.camp.hp.wood_elves_forge_of_daith.003"),
		hpr_normal("war.camp.hp.wood_elves_forge_of_daith.004"),
		hpr_normal("war.camp.hp.wood_elves_forge_of_daith.005"),
		hpr_normal("war.camp.hp.wood_elves_forge_of_daith.006"),
		hpr_normal("war.camp.hp.wood_elves_forge_of_daith.007")
	);
	parser:add_record("campaign_forge_of_daith", "script_link_campaign_forge_of_daith", "tooltip_campaign_forge_of_daith");
	tp_forge_of_daith = tooltip_patcher:new("tooltip_campaign_forge_of_daith");
	tp_forge_of_daith:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_wood_elves_forge_of_daith", "ui_text_replacements_localised_text_hp_campaign_description_wood_elves_forge_of_daith");
	
	
	
	--
	-- forging_magic_items
	--

	hp_forging_magic_items = help_page:new(
		"script_link_campaign_forging_magic_items",
		hpr_title("war.camp.hp.forging_magic_items.001"),
		hpr_leader("war.camp.hp.forging_magic_items.002"),
		hpr_normal("war.camp.hp.forging_magic_items.003"),
		hpr_normal("war.camp.hp.forging_magic_items.005"),
		hpr_normal("war.camp.hp.forging_magic_items.006")
	);
	parser:add_record("campaign_forging_magic_items", "script_link_campaign_forging_magic_items", "tooltip_campaign_forging_magic_items");
	tp_forging_magic_items = tooltip_patcher:new("tooltip_campaign_forging_magic_items");
	tp_forging_magic_items:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_forging_magic_items", "ui_text_replacements_localised_text_hp_campaign_description_forging_magic_items");
	
	tl_forging_magic_items = tooltip_listener:new(
		"tooltip_campaign_forging_magic_items",
		function()
			uim:highlight_forging_magic_items_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	--
	-- forging_magic_items_button
	--

	parser:add_record("campaign_forging_magic_items_button", "script_link_campaign_forging_magic_items_button", "tooltip_campaign_forging_magic_items_button");
	tp_forging_magic_items_button = tooltip_patcher:new("tooltip_campaign_forging_magic_items_button");
	tp_forging_magic_items_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_forging_magic_items_button");

	tl_forging_magic_items_button = tooltip_listener:new(
		"tooltip_campaign_forging_magic_items_button",
		function()
			uim:highlight_forging_magic_items_button(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- forging_magic_items_link
	--

	parser:add_record("campaign_forging_magic_items_link", "script_link_campaign_forging_magic_items_link", "tooltip_campaign_forging_magic_items_link");
	tp_forging_magic_items_link = tooltip_patcher:new("tooltip_campaign_forging_magic_items_link");
	tp_forging_magic_items_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_forging_magic_items_link");

	tl_forging_magic_items_link = tooltip_listener:new(
		"tooltip_campaign_forging_magic_items_link",
		function()
			uim:highlight_forging_magic_items_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- forging_magic_items_panel
	--

	parser:add_record("campaign_forging_magic_items_panel", "script_link_campaign_forging_magic_items_panel", "tooltip_campaign_forging_magic_items_panel");
	tp_forging_magic_items_panel = tooltip_patcher:new("tooltip_campaign_forging_magic_items_panel");
	tp_forging_magic_items_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_forging_magic_items_link");

	tl_forging_magic_items_panel = tooltip_listener:new(
		"tooltip_campaign_forging_magic_items_panel",
		function()
			uim:highlight_forging_magic_items_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	--
	-- food
	--

	hp_food = help_page:new(
		"script_link_campaign_food",
		hpr_title("war.camp.hp.food.001"),
		hpr_leader("war.camp.hp.food.002"),
		hpr_normal("war.camp.hp.food.003"),
		hpr_normal("war.camp.hp.food.004"),
		hpr_normal("war.camp.hp.food.005"),
		hpr_normal("war.camp.hp.food.006"),
		hpr_normal("war.camp.hp.food.007")
	);
	parser:add_record("campaign_food", "script_link_campaign_food", "tooltip_campaign_food");
	tp_food = tooltip_patcher:new("tooltip_campaign_food");
	tp_food:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_food", "ui_text_replacements_localised_text_hp_campaign_description_food");
	
	
	
	--
	-- food_bar
	--
	
	parser:add_record("campaign_food_bar", "script_link_campaign_food_bar", "tooltip_campaign_food_bar");
	tp_food_bar = tooltip_patcher:new("tooltip_campaign_food_bar");
	tp_food_bar:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_food_bar");
	
	tl_food_bar = tooltip_listener:new(
		"tooltip_campaign_food_bar",
		function()
			uim:highlight_food_bar(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- food_link
	--
	
	parser:add_record("campaign_food_link", "script_link_campaign_food_link", "tooltip_campaign_food_link");
	tp_food_link = tooltip_patcher:new("tooltip_campaign_food_link");
	tp_food_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_food_bar");
	
	tl_food_link = tooltip_listener:new(
		"tooltip_campaign_food_link",
		function()
			uim:highlight_food_bar(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);


	
	--
	-- forces_list
	--
	
	parser:add_record("campaign_forces_list", "script_link_campaign_forces_list", "tooltip_campaign_forces_list");
	tp_forces_list = tooltip_patcher:new("tooltip_campaign_forces_list");
	tp_forces_list:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_forces_list");
	
	tl_forces_list = tooltip_listener:new(
		"tooltip_campaign_forces_list",
		function()
			uim:highlight_forces_list(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- forge_of_souls
	--

	hp_forge_of_souls = help_page:new(
		"script_link_campaign_forge_of_souls",
		hpr_title("war.camp.hp.forge_of_souls.001"),
		hpr_leader("war.camp.hp.forge_of_souls.002"),
		hpr_normal("war.camp.hp.forge_of_souls.003"),
		hpr_normal("war.camp.hp.forge_of_souls.004"),
		hpr_normal("war.camp.hp.forge_of_souls.005"),
		hpr_normal("war.camp.hp.forge_of_souls.006"),
		hpr_normal("war.camp.hp.forge_of_souls.007")
	);
	parser:add_record("campaign_forge_of_souls", "script_link_campaign_forge_of_souls", "tooltip_campaign_forge_of_souls");
	tp_forge_of_souls = tooltip_patcher:new("tooltip_campaign_forge_of_souls");
	tp_forge_of_souls:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_forge_of_souls", "ui_text_replacements_localised_text_hp_campaign_description_forge_of_souls");

	
	
	
	--
	-- fortifications
	--

	hp_fortifications = help_page:new(
		"script_link_campaign_fortifications",
		hpr_title("war.camp.hp.fortifications.001"),
		hpr_leader("war.camp.hp.fortifications.002"),
		hpr_normal("war.camp.hp.fortifications.003"),
		hpr_normal("war.camp.hp.fortifications.004")--[[,
		hpr_normal("war.camp.hp.fortifications.005"),
		hpr_normal("war.camp.hp.fortifications.006")]]
	);
	parser:add_record("campaign_fortifications", "script_link_campaign_fortifications", "tooltip_campaign_fortifications");
	tp_fortifications = tooltip_patcher:new("tooltip_campaign_fortifications");
	tp_fortifications:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_fortifications", "ui_text_replacements_localised_text_hp_campaign_description_fortifications");
	
	
	
	--
	-- fortifications_link
	--
	
	parser:add_record("campaign_fortifications_link", "script_link_campaign_fortifications_link", "tooltip_campaign_fortifications_link");
	tp_fortifications = tooltip_patcher:new("tooltip_campaign_fortifications_link");
	tp_fortifications:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_fortifications_link");
	
	tl_fortifications = tooltip_listener:new(
		"tooltip_campaign_fortifications_link",
		function()
			uim:highlight_settlements(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	


	--
	-- garrison_armies
	--

	hp_garrison_armies = help_page:new(
		"script_link_campaign_garrison_armies",
		hpr_title("war.camp.hp.garrison_armies.001"),
		hpr_leader("war.camp.hp.garrison_armies.002"),
		hpr_normal("war.camp.hp.garrison_armies.003"),
		hpr_normal("war.camp.hp.garrison_armies.004"),
		hpr_normal("war.camp.hp.garrison_armies.005"),
		hpr_normal("war.camp.hp.garrison_armies.006")
	);
	parser:add_record("campaign_garrison_armies", "script_link_campaign_garrison_armies", "tooltip_campaign_garrison_armies");
	tp_garrison_armies = tooltip_patcher:new("tooltip_campaign_garrison_armies");
	tp_garrison_armies:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_garrison_armies", "ui_text_replacements_localised_text_hp_campaign_description_garrison_armies");
	
	tl_garrison_armies = tooltip_listener:new(
		"tooltip_campaign_garrison_armies",
		function()
			uim:highlight_garrison_armies(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- garrison_armies_link
	--
	
	parser:add_record("campaign_garrison_armies_link", "script_link_campaign_garrison_armies_link", "tooltip_campaign_garrison_armies_link");
	tp_garrison_armies_link = tooltip_patcher:new("tooltip_campaign_garrison_armies_link");
	tp_garrison_armies_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_garrison_armies_link");
	
	tl_garrison_armies_link = tooltip_listener:new(
		"tooltip_campaign_garrison_armies_link",
		function()
			uim:highlight_garrison_armies(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- garrison_details_button
	--
	
	parser:add_record("campaign_garrison_details_button", "script_link_campaign_garrison_details_button", "tooltip_campaign_garrison_details_button");
	tp_garrison_details_button = tooltip_patcher:new("tooltip_campaign_garrison_details_button");
	tp_garrison_details_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_garrison_details_button");
	
	tl_garrison_details_button = tooltip_listener:new(
		"tooltip_campaign_garrison_details_button",
		function()
			uim:highlight_garrison_details_button(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- gathering_of_the_ancients
	--[[

	hp_gathering_of_the_ancients = help_page:new(
		"script_link_campaign_gathering_of_the_ancients",
		hpr_title("war.camp.hp.gathering_of_the_ancients.001"),
		hpr_leader("war.camp.hp.gathering_of_the_ancients.002"),
		hpr_normal("war.camp.hp.gathering_of_the_ancients.003"),
		hpr_normal("war.camp.hp.gathering_of_the_ancients.004"),
		hpr_normal("war.camp.hp.gathering_of_the_ancients.005"),
		hpr_normal("war.camp.hp.gathering_of_the_ancients.006"),
		hpr_normal("war.camp.hp.gathering_of_the_ancients.007")
	);
	parser:add_record("campaign_gathering_of_the_ancients", "script_link_campaign_gathering_of_the_ancients", "tooltip_campaign_gathering_of_the_ancients");
	tp_gathering_of_the_ancients = tooltip_patcher:new("tooltip_campaign_gathering_of_the_ancients");
	tp_gathering_of_the_ancients:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_gathering_of_the_ancients", "ui_text_replacements_localised_text_hp_campaign_description_gathering_of_the_ancients");
	
	tl_gathering_of_the_ancients = tooltip_listener:new(
		"tooltip_campaign_gathering_of_the_ancients", 
		function()
			uim:highlight_offices(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- gathering_of_the_ancients_link
	--
	
	parser:add_record("campaign_gathering_of_the_ancients_link", "script_link_campaign_gathering_of_the_ancients_link", "tooltip_campaign_gathering_of_the_ancients_link");
	tp_gathering_of_the_ancients_link = tooltip_patcher:new("tooltip_campaign_gathering_of_the_ancients_link");
	tp_gathering_of_the_ancients_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_gathering_of_the_ancients_link");
	
	tl_gathering_of_the_ancients_link = tooltip_listener:new(
		"tooltip_campaign_gathering_of_the_ancients_link", 
		function()
			uim:highlight_offices(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- gathering_of_the_ancients_panel
	--
	
	parser:add_record("campaign_gathering_of_the_ancients_panel", "script_link_campaign_gathering_of_the_ancients_panel", "tooltip_campaign_gathering_of_the_ancients_panel");
	tp_gathering_of_the_ancients_panel = tooltip_patcher:new("tooltip_campaign_gathering_of_the_ancients_panel");
	tp_gathering_of_the_ancients_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_gathering_of_the_ancients_link");
	
	tl_gathering_of_the_ancients_panel = tooltip_listener:new(
		"tooltip_campaign_gathering_of_the_ancients_panel", 
		function()
			uim:highlight_offices(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	]]--
	
	--
	-- geomantic_web
	--

	hp_geomantic_web = help_page:new(
		"script_link_campaign_geomantic_web",
		hpr_title("war.camp.hp.geomantic_web.001"),
		hpr_leader("war.camp.hp.geomantic_web.002"),
		hpr_normal("war.camp.hp.geomantic_web.003"),
		hpr_normal("war.camp.hp.geomantic_web.004"),
		hpr_normal("war.camp.hp.geomantic_web.005"),
		hpr_normal("war.camp.hp.geomantic_web.006")
	);
	parser:add_record("campaign_geomantic_web", "script_link_campaign_geomantic_web", "tooltip_campaign_geomantic_web");
	tp_geomantic_web = tooltip_patcher:new("tooltip_campaign_geomantic_web");
	tp_geomantic_web:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_geomantic_web", "ui_text_replacements_localised_text_hp_campaign_description_geomantic_web");
	
	
	
	--
	-- geomantic_web_button
	--
	
	parser:add_record("campaign_geomantic_web_button", "script_link_campaign_geomantic_web_button", "tooltip_campaign_geomantic_web_button");
	tp_geomantic_web_button = tooltip_patcher:new("tooltip_campaign_geomantic_web_button");
	tp_geomantic_web_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_geomantic_web_button");
	
	tl_geomantic_web_button = tooltip_listener:new(
		"tooltip_campaign_geomantic_web_button",
		function()
			uim:highlight_geomantic_web_button(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- geomantic_web_link
	--
	
	parser:add_record("campaign_geomantic_web_link", "script_link_campaign_geomantic_web_link", "tooltip_campaign_geomantic_web_link");
	tp_geomantic_web_link = tooltip_patcher:new("tooltip_campaign_geomantic_web_link");
	tp_geomantic_web_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_geomantic_web_button");
	
	tl_geomantic_web_link = tooltip_listener:new(
		"tooltip_campaign_geomantic_web_link",
		function()
			uim:highlight_geomantic_web_button(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- gifts_of_slaanesh
	--

	hp_gifts_of_slaanesh = help_page:new(
		"script_link_campaign_gifts_of_slaanesh",
		hpr_title("war.camp.hp.gifts_of_slaanesh.001"),
		hpr_leader("war.camp.hp.gifts_of_slaanesh.002"),
		hpr_normal("war.camp.hp.gifts_of_slaanesh.003"),
		hpr_normal("war.camp.hp.gifts_of_slaanesh.004"),
		hpr_normal("war.camp.hp.gifts_of_slaanesh.005")
	);
	parser:add_record("campaign_gifts_of_slaanesh", "script_link_campaign_gifts_of_slaanesh", "tooltip_campaign_gifts_of_slaanesh");
	tp_gifts_of_slaanesh = tooltip_patcher:new("tooltip_campaign_gifts_of_slaanesh");
	tp_gifts_of_slaanesh:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_gifts_of_slaanesh", "ui_text_replacements_localised_text_hp_campaign_description_gifts_of_slaanesh");


	--
	-- global_item_pool
	--

	parser:add_record("campaign_global_item_pool", "script_link_campaign_global_item_pool", "tooltip_campaign_global_item_pool");
	tp_global_item_pool = tooltip_patcher:new("tooltip_campaign_global_item_pool");
	tp_global_item_pool:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_global_item_pool");
	
	tl_global_item_pool = tooltip_listener:new(
		"tooltip_campaign_global_item_pool", 
		function() 
			uim:highlight_global_item_pool(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	--
	-- global_recruitment_pool
	--
	
	parser:add_record("campaign_global_recruitment_pool", "script_link_campaign_global_recruitment_pool", "tooltip_campaign_global_recruitment_pool");
	tp_global_recruitment_pool = tooltip_patcher:new("tooltip_campaign_global_recruitment_pool");
	tp_global_recruitment_pool:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_global_recruitment_pool");
	
	tl_global_recruitment_pool = tooltip_listener:new(
		"tooltip_campaign_global_recruitment_pool",
		function()
			uim:highlight_global_recruitment_pool(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- gods
	--

	hp_gods = help_page:new(
		"script_link_campaign_gods",
		hpr_title("war.camp.hp.gods.001"),
		hpr_leader("war.camp.hp.gods.002"),
		hpr_normal("war.camp.hp.gods.003"),
		hpr_normal("war.camp.hp.gods.004"),
		hpr_normal("war.camp.hp.gods.005"),
		hpr_normal("war.camp.hp.gods.006")
	);
	parser:add_record("campaign_gods", "script_link_campaign_gods", "tooltip_campaign_gods");
	tp_gods = tooltip_patcher:new("tooltip_campaign_gods");
	tp_gods:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_gods", "ui_text_replacements_localised_text_hp_campaign_description_gods");
	
	tl_gods = tooltip_listener:new(
		"tooltip_campaign_gods", 
		function() 
			uim:highlight_gods_bar(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- gods_link
	--
	
	parser:add_record("campaign_gods_link", "script_link_campaign_gods_link", "tooltip_campaign_gods_link");
	tp_gods_link = tooltip_patcher:new("tooltip_campaign_gods_link");
	tp_gods_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_gods_link");
	
	tl_gods_link = tooltip_listener:new(
		"tooltip_campaign_gods_link",
		function()
			uim:highlight_gods_bar(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	--
	-- Gotrek & Felix
	--
	
	hp_gotrek_and_felix = help_page:new(
		"script_link_campaign_gotrek_and_felix",
		hpr_title("war.camp.hp.gotrek_and_felix.001"),
		hpr_leader("war.camp.hp.gotrek_and_felix.002"),
		hpr_normal("war.camp.hp.gotrek_and_felix.003"),
		hpr_normal("war.camp.hp.gotrek_and_felix.004"),
		hpr_normal("war.camp.hp.gotrek_and_felix.005"),
		hpr_normal("war.camp.hp.gotrek_and_felix.006"),
		hpr_normal("war.camp.hp.gotrek_and_felix.007"),
		hpr_normal("war.camp.hp.gotrek_and_felix.008")
	);
	parser:add_record("campaign_gotrek_and_felix", "script_link_campaign_gotrek_and_felix", "tooltip_campaign_gotrek_and_felix");
	tp_gotrek_and_felix = tooltip_patcher:new("tooltip_campaign_gotrek_and_felix");
	tp_gotrek_and_felix:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_gotrek_and_felix", "ui_text_replacements_localised_text_hp_campaign_description_gotrek_and_felix");


	--
	-- great_bastion
	--

	hp_great_bastion = help_page:new(
		"script_link_campaign_great_bastion",
		hpr_title("war.camp.hp.great_bastion.001"),
		hpr_leader("war.camp.hp.great_bastion.002"),
		hpr_normal("war.camp.hp.great_bastion.003"),
		hpr_normal("war.camp.hp.great_bastion.004"),
		hpr_normal("war.camp.hp.great_bastion.005"),
		hpr_normal("war.camp.hp.great_bastion.006"),
		hpr_normal("war.camp.hp.great_bastion.007")
	);
	parser:add_record("campaign_great_bastion", "script_link_campaign_great_bastion", "tooltip_campaign_great_bastion");
	tp_great_bastion = tooltip_patcher:new("tooltip_campaign_great_bastion");
	tp_great_bastion:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_great_bastion", "ui_text_replacements_localised_text_hp_campaign_description_great_bastion");

	tl_great_bastion = tooltip_listener:new(
		"tooltip_campaign_great_bastion", 
		function() 
			uim:highlight_great_bastion(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	

	--
	-- great_bastion_link
	--
	script_feature_name = "great_bastion";
	parser:add_record("campaign_"..script_feature_name.."_link", "script_link_campaign_"..script_feature_name.."_link", "tooltip_campaign_"..script_feature_name.."_link");
	tp_great_bastion_link = tooltip_patcher:new("tooltip_campaign_"..script_feature_name.."_link");
	tp_great_bastion_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_"..script_feature_name.."_link");
	
	tl_great_bastion_link = tooltip_listener:new(
		"tooltip_campaign_"..script_feature_name.."_link",
		function()
			uim:highlight_great_bastion(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);

	--
	-- great_bastion_threat_meter
	--

	parser:add_record("campaign_great_bastion_threat_meter", "script_link_campaign_great_bastion_threat_meter", "tooltip_campaign_great_bastion_threat_meter");
	tp_great_bastion_threat_meter = tooltip_patcher:new("tooltip_campaign_great_bastion_threat_meter");
	tp_great_bastion_threat_meter:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_great_bastion_threat_meter");
	
	tl_great_bastion_threat_meter = tooltip_listener:new(
		"tooltip_campaign_great_bastion_threat_meter", 
		function() 
			uim:highlight_great_bastion(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	--
	-- green_knight
	--
	
	green_knight = help_page:new(
		"script_link_campaign_green_knight",
		hpr_title("war.camp.hp.green_knight.001"),
		hpr_leader("war.camp.hp.green_knight.002"),
		hpr_normal("war.camp.hp.green_knight.003"),
		hpr_normal("war.camp.hp.green_knight.004"),
		hpr_normal("war.camp.hp.green_knight.005")
	);
	parser:add_record("campaign_green_knight", "script_link_campaign_green_knight", "tooltip_campaign_green_knight");
	tp_green_knight = tooltip_patcher:new("tooltip_campaign_green_knight");
	tp_green_knight:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_green_knight", "ui_text_replacements_localised_text_hp_campaign_description_green_knight");
	
	tl_green_knight = tooltip_listener:new(
		"tooltip_campaign_green_knight",
		function()
			uim:highlight_legendary_knight_button(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- green_knight_link
	--
	
	parser:add_record("campaign_green_knight_link", "script_link_campaign_green_knight_link", "tooltip_campaign_green_knight_link");
	tp_green_knight_link = tooltip_patcher:new("tooltip_campaign_green_knight_link");
	tp_green_knight_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_green_knight_link");
	
	tl_green_knight_link = tooltip_listener:new(
		"tooltip_campaign_green_knight_link",
		function()
			uim:highlight_legendary_knight_button(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
		
	
	--
	-- greenskins
	--
	
	hp_greenskins = help_page:new(
		"script_link_campaign_greenskins",
		hpr_title("war.camp.hp.greenskins.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/greenskins.png"),
		hpr_leader("war.camp.hp.greenskins.002"),
		hpr_normal("war.camp.hp.greenskins.003"),
		hpr_normal("war.camp.hp.greenskins.004"),
		hpr_normal("war.camp.hp.greenskins.005"),
		hpr_normal("war.camp.hp.greenskins.006")
	);
	parser:add_record("campaign_greenskins", "script_link_campaign_greenskins", "tooltip_campaign_greenskins");
	tp_greenskins = tooltip_patcher:new("tooltip_campaign_greenskins");
	tp_greenskins:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_greenskins",
		"ui_text_replacements_localised_text_hp_campaign_description_greenskins",
		"UI/help_images/greenskins.png"
	);



	--
	-- grimoires
	--

	hp_grimoires = help_page:new(
		"script_link_campaign_grimoires",
		hpr_title("war.camp.hp.grimoires.001"),
		hpr_leader("war.camp.hp.grimoires.002"),
		hpr_normal("war.camp.hp.grimoires.003"),
		hpr_normal("war.camp.hp.grimoires.004"),
		hpr_normal("war.camp.hp.grimoires.005")
	);
	parser:add_record("campaign_grimoires", "script_link_campaign_grimoires", "tooltip_campaign_grimoires");
	tp_grimoires = tooltip_patcher:new("tooltip_campaign_grimoires");
	tp_grimoires:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_grimoires", "ui_text_replacements_localised_text_hp_campaign_description_grimoires");

	tl_grimoires = tooltip_listener:new(
		"tooltip_campaign_grimoires", 
		function() 
			uim:highlight_grimoires(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- grimoires_link
	--
	script_feature_name = "grimoires";
	parser:add_record("campaign_"..script_feature_name.."_link", "script_link_campaign_"..script_feature_name.."_link", "tooltip_campaign_"..script_feature_name.."_link");
	tp_grimoires_link = tooltip_patcher:new("tooltip_campaign_"..script_feature_name.."_link");
	tp_grimoires_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_"..script_feature_name.."_link");
	
	tl_grimoires_link = tooltip_listener:new(
		"tooltip_campaign_"..script_feature_name.."_link",
		function()
			uim:highlight_grimoires(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- grimoires_counter
	--

	parser:add_record("campaign_grimoires_counter", "script_link_campaign_grimoires_counter", "tooltip_campaign_grimoires_counter");
	tp_grimoires_counter = tooltip_patcher:new("tooltip_campaign_grimoires_counter");
	tp_grimoires_counter:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_grimoires_counter");
	
	tl_grimoires_counter = tooltip_listener:new(
		"tooltip_campaign_grimoires_counter", 
		function() 
			uim:highlight_grimoires(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- groms cauldron
	--
	
	hp_groms_cauldron = help_page:new(
		"script_link_campaign_groms_cauldron",
		hpr_title("war.camp.hp.greenskins_groms_cauldron.001"),
		hpr_leader("war.camp.hp.greenskins_groms_cauldron.002"),
		hpr_normal("war.camp.hp.greenskins_groms_cauldron.003"),
		hpr_normal("war.camp.hp.greenskins_groms_cauldron.004"),
		hpr_normal("war.camp.hp.greenskins_groms_cauldron.005"),
		hpr_normal("war.camp.hp.greenskins_groms_cauldron.007")
	);
	parser:add_record("campaign_groms_cauldron", "script_link_campaign_groms_cauldron", "tooltip_campaign_groms_cauldron");
	tp_groms_cauldron = tooltip_patcher:new("tooltip_campaign_groms_cauldron");
	tp_groms_cauldron:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_greenskins_groms_cauldron", "ui_text_replacements_localised_text_hp_campaign_description_greenskins_groms_cauldron");
	
	
	
	--
	-- growth
	--

	hp_growth = help_page:new(
		"script_link_campaign_growth",
		hpr_title("war.camp.hp.growth.001"),
		hpr_leader("war.camp.hp.growth.002"),
		hpr_normal("war.camp.hp.growth.003"),
		hpr_normal("war.camp.hp.growth.004"),
		hpr_normal("war.camp.hp.growth.005"),
		hpr_normal("war.camp.hp.growth.006"),
		hpr_normal("war.camp.hp.growth.007"),
		hpr_normal("war.camp.hp.growth.009")
	);
	parser:add_record("campaign_growth", "script_link_campaign_growth", "tooltip_campaign_growth");
	tp_growth = tooltip_patcher:new("tooltip_campaign_growth");
	tp_growth:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_growth", "ui_text_replacements_localised_text_hp_campaign_description_growth");
	
	tl_growth = tooltip_listener:new(
		"tooltip_campaign_growth", 
		function()
			uim:highlight_growth(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- growth_link
	--
	
	parser:add_record("campaign_growth_link", "script_link_campaign_growth_link", "tooltip_campaign_growth_link");
	tp_growth = tooltip_patcher:new("tooltip_campaign_growth_link");
	tp_growth:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_growth_link");
	
	tl_growth_link = tooltip_listener:new(
		"tooltip_campaign_growth_link",
		function()
			uim:highlight_growth(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- grudges
	--

	hp_grudges = help_page:new(
		"script_link_campaign_grudges",
		hpr_title("war.camp.hp.grudges.001"),
		hpr_leader("war.camp.hp.grudges.002"),
		hpr_normal("war.camp.hp.grudges.003"),
		hpr_normal("war.camp.hp.grudges.004"),
		hpr_normal("war.camp.hp.grudges.005"),
		hpr_normal("war.camp.hp.grudges.006")
	);
	parser:add_record("campaign_grudges", "script_link_campaign_grudges", "tooltip_campaign_grudges");
	tp_grudges = tooltip_patcher:new("tooltip_campaign_grudges");
	tp_grudges:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_grudges", "ui_text_replacements_localised_text_hp_campaign_description_grudges");
	
	tl_grudges = tooltip_listener:new(
		"tooltip_campaign_grudges", 
		function()
			uim:highlight_grudges_bar(true);
			uim:highlight_grudges_button(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- grudges_bar
	--
	
	parser:add_record("campaign_grudges_bar", "script_link_campaign_grudges_bar", "tooltip_campaign_grudges_bar");
	tp_grudges_bar = tooltip_patcher:new("tooltip_campaign_grudges_bar");
	tp_grudges_bar:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_grudges_bar");
	
	tl_grudges_bar = tooltip_listener:new(
		"tooltip_campaign_grudges_bar", 
		function()
			uim:highlight_grudges_bar(true);
			uim:highlight_book_of_grudges_bar(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- grudges_button
	--
	
	parser:add_record("campaign_grudges_button", "script_link_campaign_grudges_button", "tooltip_campaign_grudges_button");
	tp_grudges_button = tooltip_patcher:new("tooltip_campaign_grudges_button");
	tp_grudges_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_grudges_button");
	
	tl_grudges_button = tooltip_listener:new(
		"tooltip_campaign_grudges_button", 
		function()
			uim:highlight_grudges_button(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- grudges_link
	--
	
	parser:add_record("campaign_grudges_link", "script_link_campaign_grudges_link", "tooltip_campaign_grudges_link");
	tp_grudges = tooltip_patcher:new("tooltip_campaign_grudges_link");
	tp_grudges:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_grudges_link");
	
	tl_grudges = tooltip_listener:new(
		"tooltip_campaign_grudges_link",
		function()
			uim:highlight_grudges_bar(true);
			uim:highlight_grudges_button(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- harmony
	--

	hp_harmony = help_page:new(
		"script_link_campaign_harmony",
		hpr_title("war.camp.hp.harmony.001"),
		hpr_leader("war.camp.hp.harmony.002"),
		hpr_normal("war.camp.hp.harmony.003"),
		hpr_normal("war.camp.hp.harmony.004"),
		hpr_normal("war.camp.hp.harmony.005"),
		hpr_normal("war.camp.hp.harmony.006")
	);
	parser:add_record("campaign_harmony", "script_link_campaign_harmony", "tooltip_campaign_harmony");
	tp_harmony = tooltip_patcher:new("tooltip_campaign_harmony");
	tp_harmony:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_harmony", "ui_text_replacements_localised_text_hp_campaign_description_harmony");

	tl_harmony = tooltip_listener:new(
		"tooltip_campaign_harmony", 
		function() 
			uim:highlight_harmony(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- harmony_link
	--

	parser:add_record("campaign_harmony_link", "script_link_campaign_harmony_link", "tooltip_campaign_harmony_link");
	tp_harmony_link = tooltip_patcher:new("tooltip_campaign_harmony_link");
	tp_harmony_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_harmony_link");
	
	tl_harmony_link = tooltip_listener:new(
		"tooltip_campaign_harmony_link",
		function()
			uim:highlight_harmony(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- harmony_lotus_indicator
	--

	parser:add_record("campaign_harmony_lotus_indicator", "script_link_campaign_harmony_lotus_indicator", "tooltip_campaign_harmony_lotus_indicator");
	tp_harmony_lotus_indicator = tooltip_patcher:new("tooltip_campaign_harmony_lotus_indicator");
	tp_harmony_lotus_indicator:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_harmony_lotus_indicator");
	
	tl_harmony_lotus_indicator = tooltip_listener:new(
		"tooltip_campaign_harmony_lotus_indicator", 
		function() 
			uim:highlight_harmony(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- hellforge
	--

	hp_hellforge = help_page:new(
		"script_link_campaign_hellforge",
		hpr_title("war.camp.hp.hellforge.001"),
		hpr_leader("war.camp.hp.hellforge.002"),
		hpr_normal("war.camp.hp.hellforge.003"),
		hpr_normal("war.camp.hp.hellforge.004"),
		hpr_normal("war.camp.hp.hellforge.005")
	);
	parser:add_record("campaign_hellforge", "script_link_campaign_hellforge", "tooltip_campaign_hellforge");
	tp_hellforge = tooltip_patcher:new("tooltip_campaign_hellforge");
	tp_hellforge:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_hellforge", "ui_text_replacements_localised_text_hp_campaign_description_hellforge");
	
	tl_hellforge = tooltip_listener:new(
		"tooltip_campaign_hellforge", 
		function() 
			uim:highlight_hellforge(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);

	
	
	--
	-- help_pages_button
	--

	parser:add_record("campaign_help_pages_button", "script_link_campaign_help_pages_button", "tooltip_campaign_help_pages_button");
	tp_help_pages_button = tooltip_patcher:new("tooltip_campaign_help_pages_button");
	tp_help_pages_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_help_pages_button");
	
	tl_help_pages_button = tooltip_listener:new(
		"tooltip_campaign_help_pages_button", 
		function() 
			uim:highlight_help_pages_button(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	

	--
	-- hero_actions
	--

	hp_hero_actions = help_page:new(
		"script_link_campaign_hero_actions",
		hpr_title("war.camp.hp.hero_actions.001"),
		hpr_leader("war.camp.hp.hero_actions.002"),
		hpr_normal("war.camp.hp.hero_actions.003"),
		hpr_normal("war.camp.hp.hero_actions.004"),
		hpr_normal("war.camp.hp.hero_actions.005"),
		hpr_normal("war.camp.hp.hero_actions.006"),
		hpr_normal("war.camp.hp.hero_actions.007")
	);
	parser:add_record("campaign_hero_actions", "script_link_campaign_hero_actions", "tooltip_campaign_hero_actions");
	tp_hero_actions = tooltip_patcher:new("tooltip_campaign_hero_actions");
	tp_hero_actions:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_hero_actions", "ui_text_replacements_localised_text_hp_campaign_description_hero_actions");



	--
	-- heroes
	--

	hp_heroes = help_page:new(
		"script_link_campaign_heroes",
		hpr_title("war.camp.hp.heroes.001"),
		hpr_leader("war.camp.hp.heroes.002"),
		hpr_normal("war.camp.hp.heroes.003"),
		hpr_normal("war.camp.hp.heroes.004"),
		hpr_normal("war.camp.hp.heroes.005"),
		hpr_normal("war.camp.hp.heroes.006")
	);
	parser:add_record("campaign_heroes", "script_link_campaign_heroes", "tooltip_campaign_heroes");
	tp_heroes = tooltip_patcher:new("tooltip_campaign_heroes");
	tp_heroes:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_heroes", "ui_text_replacements_localised_text_hp_campaign_description_heroes");
	
	tl_heroes = tooltip_listener:new(
		"tooltip_campaign_heroes",
		function()
			uim:highlight_heroes(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- heroes_link
	--
	
	parser:add_record("campaign_heroes_link", "script_link_campaign_heroes_link", "tooltip_campaign_heroes_link");
	tp_heroes = tooltip_patcher:new("tooltip_campaign_heroes_link");
	tp_heroes:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_heroes_link");
	
	tl_heroes_link = tooltip_listener:new(
		"tooltip_campaign_heroes_link",
		function()
			uim:highlight_heroes(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- hero_deployment_button
	--
	
	parser:add_record("campaign_hero_deployment_button", "script_link_campaign_hero_deployment_button", "tooltip_campaign_hero_deployment_button");
	tp_hero_deployment_button = tooltip_patcher:new("tooltip_campaign_hero_deployment_button");
	tp_hero_deployment_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_hero_deployment_button");
	
	tl_hero_deployment_button = tooltip_listener:new(
		"tooltip_campaign_hero_deployment_button",
		function()
			uim:highlight_hero_deployment_button(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- hero_recruitment_button
	--
	
	parser:add_record("campaign_hero_recruitment_button", "script_link_campaign_hero_recruitment_button", "tooltip_campaign_hero_recruitment_button");
	tp_hero_recruitment_button = tooltip_patcher:new("tooltip_campaign_hero_recruitment_button");
	tp_hero_recruitment_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_hero_recruitment_button");
	
	tl_hero_recruitment_button = tooltip_listener:new(
		"tooltip_campaign_hero_recruitment_button",
		function()
			uim:highlight_recruit_hero_button(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- hero_recruitment_panel_tab_buttons
	--
	
	parser:add_record("campaign_hero_recruitment_panel_tab_buttons", "script_link_campaign_hero_recruitment_panel_tab_buttons", "tooltip_campaign_hero_recruitment_panel_tab_buttons");
	tp_hero_recruitment_panel_tab_buttons = tooltip_patcher:new("tooltip_campaign_hero_recruitment_panel_tab_buttons");
	tp_hero_recruitment_panel_tab_buttons:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_hero_recruitment_panel_tab_buttons");
	
	tl_hero_recruitment_panel_tab_buttons = tooltip_listener:new(
		"tooltip_campaign_hero_recruitment_panel_tab_buttons",
		function()
			uim:highlight_hero_recruitment_panel_tab_buttons(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);

	
	
	--
	-- hexes
	--

	hp_hexes = help_page:new(
		"script_link_campaign_hexes",
		hpr_title("war.camp.hp.hexes.001"),
		hpr_leader("war.camp.hp.hexes.002"),
		hpr_normal("war.camp.hp.hexes.003"),
		hpr_normal("war.camp.hp.hexes.004"),
		hpr_normal("war.camp.hp.hexes.005"),
		hpr_normal("war.camp.hp.hexes.006"),
		hpr_normal("war.camp.hp.hexes.007")
	);
	parser:add_record("campaign_hexes", "script_link_campaign_hexes", "tooltip_campaign_hexes");
	tp_hexes = tooltip_patcher:new("tooltip_campaign_hexes");
	tp_hexes:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_hexes", "ui_text_replacements_localised_text_hp_campaign_description_hexes");
	
	
	
	--
	-- high_elves
	--

	hp_high_elves = help_page:new(
		"script_link_campaign_high_elves",
		hpr_title("war.camp.hp.high_elves.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/high_elves.png"),
		hpr_leader("war.camp.hp.high_elves.002"),
		hpr_normal("war.camp.hp.high_elves.003"),
		hpr_normal("war.camp.hp.high_elves.004"),
		hpr_normal("war.camp.hp.high_elves.005"),
		hpr_normal("war.camp.hp.high_elves.006"),
		hpr_normal("war.camp.hp.high_elves.007")
	);
	parser:add_record("campaign_high_elves", "script_link_campaign_high_elves", "tooltip_campaign_high_elves");
	tp_high_elves = tooltip_patcher:new("tooltip_campaign_high_elves");
	tp_high_elves:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_high_elves",
		"ui_text_replacements_localised_text_hp_campaign_description_high_elves",
		"UI/help_images/high_elves.png"
	);
	
	
	
	--
	-- horde_growth
	--

	hp_horde_growth = help_page:new(
		"script_link_campaign_horde_growth",
		hpr_title("war.camp.hp.horde_growth.001"),
		hpr_leader("war.camp.hp.horde_growth.002"),
		hpr_normal("war.camp.hp.horde_growth.003"),
		hpr_normal("war.camp.hp.horde_growth.004"),
		hpr_normal("war.camp.hp.horde_growth.005"),
		hpr_normal("war.camp.hp.horde_growth.006"),
		hpr_normal("war.camp.hp.horde_growth.007"),
		hpr_normal("war.camp.hp.horde_growth.009")
	);
	parser:add_record("campaign_horde_growth", "script_link_campaign_horde_growth", "tooltip_campaign_horde_growth");
	tp_horde_growth = tooltip_patcher:new("tooltip_campaign_horde_growth");
	tp_horde_growth:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_horde_growth", "ui_text_replacements_localised_text_hp_campaign_description_horde_growth");
	
	tl_horde_growth = tooltip_listener:new(
		"tooltip_campaign_horde_growth", 
		function()
			uim:highlight_horde_growth(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- horde_growth_link
	--
	
	parser:add_record("campaign_horde_growth_link", "script_link_campaign_horde_growth_link", "tooltip_campaign_horde_growth_link");
	tp_growth = tooltip_patcher:new("tooltip_campaign_horde_growth_link");
	tp_growth:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_horde_growth_link");
	
	tl_growth = tooltip_listener:new(
		"tooltip_campaign_horde_growth_link",
		function()
			uim:highlight_horde_growth(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- hordes
	--

	hp_hordes = help_page:new(
		"script_link_campaign_hordes",
		hpr_title("war.camp.hp.hordes.001"),
		hpr_normal("war.camp.hp.hordes.002"),
		hpr_bulleted("war.camp.hp.hordes.003"),
		hpr_bulleted("war.camp.hp.hordes.004"),
		hpr_bulleted("war.camp.hp.hordes.005"),
		hpr_bulleted("war.camp.hp.hordes.006"),
		hpr_bulleted("war.camp.hp.hordes.007")
	);
	parser:add_record("campaign_hordes", "script_link_campaign_hordes", "tooltip_campaign_hordes");
	tp_hordes = tooltip_patcher:new("tooltip_campaign_hordes");
	tp_hordes:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_hordes", "ui_text_replacements_localised_text_hp_campaign_description_hordes");


	--
	-- hostility
	--

	hp_hostility = help_page:new(
		"script_link_campaign_hostility",
		hpr_title("war.camp.hp.empire_hostility.001"),
		hpr_leader("war.camp.hp.empire_hostility.002"),
		hpr_normal("war.camp.hp.empire_hostility.003"),
		hpr_normal("war.camp.hp.empire_hostility.004"),
		hpr_normal("war.camp.hp.empire_hostility.005"),
		hpr_normal("war.camp.hp.empire_hostility.006"),
		hpr_normal("war.camp.hp.empire_hostility.007")
	);
	parser:add_record("campaign_hostility", "script_link_campaign_hostility", "tooltip_campaign_hostility");
	tp_hostility = tooltip_patcher:new("tooltip_campaign_hostility");
	tp_hostility:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_empire_hostility", "ui_text_replacements_localised_text_hp_campaign_description_empire_hostility");


	--
	-- ice_court
	--

	hp_ice_court = help_page:new(
		"script_link_campaign_ice_court",
		hpr_title("war.camp.hp.ice_court.001"),
		hpr_leader("war.camp.hp.ice_court.002"),
		hpr_normal("war.camp.hp.ice_court.003"),
		hpr_normal("war.camp.hp.ice_court.004"),
		hpr_normal("war.camp.hp.ice_court.005"),
		hpr_normal("war.camp.hp.ice_court.006")
	);
	parser:add_record("campaign_ice_court", "script_link_campaign_ice_court", "tooltip_campaign_ice_court");
	tp_ice_court = tooltip_patcher:new("tooltip_campaign_ice_court");
	tp_ice_court:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_ice_court", "ui_text_replacements_localised_text_hp_campaign_description_ice_court");

	tl_ice_court = tooltip_listener:new(
		"tooltip_campaign_ice_court", 
		function() 
			uim:highlight_ice_court(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- ice_court_link
	--

	parser:add_record("campaign_ice_court_link", "script_link_campaign_ice_court_link", "tooltip_campaign_ice_court_link");
	tp_ice_court_link = tooltip_patcher:new("tooltip_campaign_ice_court_link");
	tp_ice_court_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_ice_court_link");
	
	tl_ice_court_link = tooltip_listener:new(
		"tooltip_campaign_ice_court_link",
		function()
			uim:highlight_ice_court(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- ice_court_button
	--

	parser:add_record("campaign_ice_court_button", "script_link_campaign_ice_court_button", "tooltip_campaign_ice_court_button");
	tp_ice_court_button = tooltip_patcher:new("tooltip_campaign_ice_court_button");
	tp_ice_court_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_ice_court_button");
	
	tl_ice_court_button = tooltip_listener:new(
		"tooltip_campaign_ice_court_button", 
		function() 
			uim:highlight_ice_court(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- ice_court_panel
	--

	parser:add_record("campaign_ice_court_panel", "script_link_campaign_ice_court_panel", "tooltip_campaign_ice_court_panel");
	tp_ice_court_panel = tooltip_patcher:new("tooltip_campaign_ice_court_panel");
	tp_ice_court_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_ice_court_panel");
	
	tl_ice_court_panel = tooltip_listener:new(
		"tooltip_campaign_ice_court_panel", 
		function() 
			uim:highlight_ice_court(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);

		
	--
	-- imperial authority & prestige
	--

	hp_imperial_authority = help_page:new(
		"script_link_campaign_imperial_authority",
		hpr_title("war.camp.hp.empire_imperial_authority.001"),
		hpr_leader("war.camp.hp.empire_imperial_authority.002"),
		hpr_normal("war.camp.hp.empire_imperial_authority.003"),
		hpr_normal("war.camp.hp.empire_imperial_authority.004"),
		hpr_normal("war.camp.hp.empire_imperial_authority.005"),
		hpr_normal("war.camp.hp.empire_imperial_authority.006"),
		hpr_normal("war.camp.hp.empire_imperial_authority.007")
	);
	parser:add_record("campaign_imperial_authority", "script_link_campaign_imperial_authority", "tooltip_campaign_imperial_authority");
	tp_imperial_authority = tooltip_patcher:new("tooltip_campaign_imperial_authority");
	tp_imperial_authority:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_empire_imperial_authority", "ui_text_replacements_localised_text_hp_campaign_description_empire_imperial_authority");
	

	--
	-- income
	--

	hp_income = help_page:new(
		"script_link_campaign_income",
		hpr_title("war.camp.hp.income.001"),
		hpr_normal("war.camp.hp.income.002"),
		hpr_normal("war.camp.hp.income.003"),
		hpr_normal("war.camp.hp.income.004"),
		hpr_normal("war.camp.hp.income.005")
	);
	parser:add_record("campaign_income", "script_link_campaign_income", "tooltip_campaign_income");
	tp_income = tooltip_patcher:new("tooltip_campaign_income");
	tp_income:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_income", "ui_text_replacements_localised_text_hp_campaign_description_income");
	
	tl_income = tooltip_listener:new(
		"tooltip_campaign_income", 
		function() 
			uim:highlight_per_turn_income(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- income_link
	--
	
	parser:add_record("campaign_income_link", "script_link_campaign_income_link", "tooltip_campaign_income_link");
	tp_income_link = tooltip_patcher:new("tooltip_campaign_income_link");
	tp_income_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_income_link");
	
	tl_income_link = tooltip_listener:new(
		"tooltip_campaign_income_link",
		function()
			uim:highlight_per_turn_income(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- income_per_turn
	--
	
	parser:add_record("campaign_income_per_turn", "script_link_campaign_income_per_turn", "tooltip_campaign_income_per_turn");
	tp_income_per_turn = tooltip_patcher:new("tooltip_campaign_income_per_turn");
	tp_income_per_turn:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_income_per_turn");
	
	tl_income_per_turn = tooltip_listener:new(
		"tooltip_campaign_income_per_turn", 
		function() 
			uim:highlight_per_turn_income(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);

	--
	-- chd_economy
	--

	hp_chd_economy = help_page:new(
		"script_link_campaign_chd_economy",
		hpr_title("war.camp.hp.chd_economy.001"),
		hpr_leader("war.camp.hp.chd_economy.002"),
		hpr_normal("war.camp.hp.chd_economy.003"),
		hpr_normal("war.camp.hp.chd_economy.004"),
		hpr_normal("war.camp.hp.chd_economy.005"),
		hpr_normal("war.camp.hp.chd_economy.006"),
		hpr_normal("war.camp.hp.chd_economy.007")
	);
	parser:add_record("campaign_chd_economy", "script_link_campaign_chd_economy", "tooltip_campaign_chd_economy");
	tp_chd_economy = tooltip_patcher:new("tooltip_campaign_chd_economy");
	tp_chd_economy:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_chd_economy", "ui_text_replacements_localised_text_hp_campaign_description_chd_economy");
	
	
	--
	-- labour
	--

	hp_infamy = help_page:new(
		"script_link_campaign_labour",
		hpr_title("war.camp.hp.labour.001"),
		hpr_leader("war.camp.hp.labour.002"),
		hpr_normal("war.camp.hp.labour.003"),
		hpr_normal("war.camp.hp.labour.004"),
		hpr_normal("war.camp.hp.labour.005"),
		hpr_normal("war.camp.hp.labour.006"),
		hpr_normal("war.camp.hp.labour.007")
	);
	parser:add_record("campaign_labour", "script_link_campaign_labour", "tooltip_campaign_labour");
	tp_infamy = tooltip_patcher:new("tooltip_campaign_labour");
	tp_infamy:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_labour", "ui_text_replacements_localised_text_hp_campaign_description_labour");
	
	
	--
	-- infamy
	--

	hp_infamy = help_page:new(
		"script_link_campaign_infamy",
		hpr_title("war.camp.hp.infamy.001"),
		hpr_leader("war.camp.hp.infamy.002"),
		hpr_normal("war.camp.hp.infamy.003"),
		hpr_normal("war.camp.hp.infamy.004"),
		hpr_normal("war.camp.hp.infamy.005"),
		hpr_normal("war.camp.hp.infamy.006")
	);
	parser:add_record("campaign_infamy", "script_link_campaign_infamy", "tooltip_campaign_infamy");
	tp_infamy = tooltip_patcher:new("tooltip_campaign_infamy");
	tp_infamy:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_infamy", "ui_text_replacements_localised_text_hp_campaign_description_infamy");
	
	tl_infamy = tooltip_listener:new(
		"tooltip_campaign_infamy", 
		function() 
			uim:highlight_infamy(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	--
	-- infamy_link
	--
	
	parser:add_record("campaign_infamy_link", "script_link_campaign_infamy_link", "tooltip_campaign_infamy_link");
	tp_infamy_link = tooltip_patcher:new("tooltip_campaign_infamy_link");
	tp_infamy_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_infamy_link");
	
	tl_infamy_link = tooltip_listener:new(
		"tooltip_campaign_infamy_link",
		function()
			uim:highlight_infamy(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- infections
	--

	parser:add_record("campaign_infections", "script_link_campaign_infections", "tooltip_campaign_infections");
	tp_infections = tooltip_patcher:new("tooltip_campaign_infections");
	tp_infections:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_infections");
	
	tl_infections = tooltip_listener:new(
		"tooltip_campaign_infections", 
		function() 
			uim:highlight_infections(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	--
	-- influence
	--

	hp_influence = help_page:new(
		"script_link_campaign_influence",
		hpr_title("war.camp.hp.influence.001"),
		hpr_leader("war.camp.hp.influence.002"),
		hpr_normal("war.camp.hp.influence.003"),
		hpr_normal("war.camp.hp.influence.004"),
		hpr_normal("war.camp.hp.influence.005")
	);
	parser:add_record("campaign_influence", "script_link_campaign_influence", "tooltip_campaign_influence");
	tp_influence = tooltip_patcher:new("tooltip_campaign_influence");
	tp_influence:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_influence", "ui_text_replacements_localised_text_hp_campaign_description_influence");
	
	tl_influence = tooltip_listener:new(
		"tooltip_campaign_influence", 
		function() 
			uim:highlight_influence(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- influence_link
	--
	
	parser:add_record("campaign_influence_link", "script_link_campaign_influence_link", "tooltip_campaign_influence_link");
	tp_influence_link = tooltip_patcher:new("tooltip_campaign_influence_link");
	tp_influence_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_influence_link");
	
	tl_influence_link = tooltip_listener:new(
		"tooltip_campaign_influence_link", 
		function() 
			uim:highlight_influence(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- intervention_armies
	--

	hp_intervention_armies = help_page:new(
		"script_link_campaign_intervention_armies",
		hpr_title("war.camp.hp.intervention_armies.001"),
		hpr_leader("war.camp.hp.intervention_armies.002"),
		hpr_normal("war.camp.hp.intervention_armies.003"),
		hpr_normal("war.camp.hp.intervention_armies.004"),
		hpr_normal("war.camp.hp.intervention_armies.005"),
		hpr_normal("war.camp.hp.intervention_armies.006")
	);
	parser:add_record("campaign_intervention_armies", "script_link_campaign_intervention_armies", "tooltip_campaign_intervention_armies");
	tp_intervention_armies = tooltip_patcher:new("tooltip_campaign_intervention_armies");
	tp_intervention_armies:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_intervention_armies", "ui_text_replacements_localised_text_hp_campaign_description_intervention_armies");
	
	
	
	--
	-- interventions_button
	--
	
	parser:add_record("campaign_interventions_button", "script_link_campaign_interventions_button", "tooltip_campaign_interventions_button");
	tp_interventions_button = tooltip_patcher:new("tooltip_campaign_interventions_button");
	tp_interventions_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_interventions_button");
	
	tl_interventions_button = tooltip_listener:new(
		"tooltip_campaign_interventions_button",
		function()
			uim:highlight_interventions(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- intrigue_at_the_court
	--

	hp_intrigue_at_the_court = help_page:new(
		"script_link_campaign_intrigue_at_the_court",
		hpr_title("war.camp.hp.intrigue_at_the_court.001"),
		hpr_leader("war.camp.hp.intrigue_at_the_court.002"),
		hpr_normal("war.camp.hp.intrigue_at_the_court.003"),
		hpr_normal("war.camp.hp.intrigue_at_the_court.004"),
		hpr_normal("war.camp.hp.intrigue_at_the_court.005"),
		hpr_normal("war.camp.hp.intrigue_at_the_court.006")
	);
	parser:add_record("campaign_intrigue_at_the_court", "script_link_campaign_intrigue_at_the_court", "tooltip_campaign_intrigue_at_the_court");
	tp_intrigue_at_the_court = tooltip_patcher:new("tooltip_campaign_intrigue_at_the_court");
	tp_intrigue_at_the_court:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_intrigue_at_the_court", "ui_text_replacements_localised_text_hp_campaign_description_intrigue_at_the_court");
	
	intrigue_at_the_court = tooltip_listener:new(
		"tooltip_campaign_intrigue_at_the_court",
		function()
			uim:highlight_intrigue_at_the_court_button(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- intrigue_at_the_court_button
	--
	
	parser:add_record("campaign_intrigue_at_the_court_button", "script_link_campaign_intrigue_at_the_court_button", "tooltip_campaign_intrigue_at_the_court_button");
	tp_intrigue_at_the_court_button = tooltip_patcher:new("tooltip_campaign_intrigue_at_the_court_button");
	tp_intrigue_at_the_court_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_intrigue_at_the_court_panel");
	
	intrigue_at_the_court_button = tooltip_listener:new(
		"tooltip_campaign_intrigue_at_the_court_button",
		function()
			uim:highlight_intrigue_at_the_court_button(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- intrigue_at_the_court_panel
	--
	
	parser:add_record("campaign_intrigue_at_the_court_panel", "script_link_campaign_intrigue_at_the_court_panel", "tooltip_campaign_intrigue_at_the_court_panel");
	tp_intrigue_at_the_court_panel = tooltip_patcher:new("tooltip_campaign_intrigue_at_the_court_panel");
	tp_intrigue_at_the_court_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_intrigue_at_the_court_panel");
	
	tl_intrigue_at_the_court_panel = tooltip_listener:new(
		"tooltip_campaign_intrigue_at_the_court_panel",
		function()
			uim:highlight_intrigue_at_the_court_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	--
	-- island_black_ark_battle
	--
	
	hp_island_black_ark_battle = help_page:new(
		"script_link_campaign_island_black_ark_battle",
		hpr_title("war.camp.hp.island_black_ark_battle.001"),
		hpr_leader("war.camp.hp.island_black_ark_battle.002"),
		hpr_normal("war.camp.hp.island_black_ark_battle.003"),
		hpr_normal("war.camp.hp.island_black_ark_battle.004"),
		hpr_normal("war.camp.hp.island_black_ark_battle.005")
	);
	parser:add_record("campaign_island_black_ark_battle", "script_link_campaign_island_black_ark_battle", "tooltip_campaign_island_black_ark_battle");
	tp_island_black_ark_battle = tooltip_patcher:new("tooltip_campaign_island_black_ark_battle");
	tp_island_black_ark_battle:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_island_black_ark_battle", "ui_text_replacements_localised_text_hp_campaign_description_island_black_ark_battle");



	--
	-- ivory_road
	--

	hp_ivory_road = help_page:new(
		"script_link_campaign_ivory_road",
		hpr_title("war.camp.hp.ivory_road.001"),
		hpr_leader("war.camp.hp.ivory_road.002"),
		hpr_normal("war.camp.hp.ivory_road.003"),
		hpr_normal("war.camp.hp.ivory_road.004"),
		hpr_normal("war.camp.hp.ivory_road.005"),
		hpr_normal("war.camp.hp.ivory_road.006"),
		hpr_normal("war.camp.hp.ivory_road.007")
	);
	parser:add_record("campaign_ivory_road", "script_link_campaign_ivory_road", "tooltip_campaign_ivory_road");
	tp_ivory_road = tooltip_patcher:new("tooltip_campaign_ivory_road");
	tp_ivory_road:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_ivory_road", "ui_text_replacements_localised_text_hp_campaign_description_ivory_road");

	tl_ivory_road = tooltip_listener:new(
		"tooltip_campaign_ivory_road", 
		function() 
			uim:highlight_ivory_road(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- ivory_road_link
	--

	parser:add_record("campaign_ivory_road_link", "script_link_campaign_ivory_road_link", "tooltip_campaign_ivory_road_link");
	tp_ivory_road_link = tooltip_patcher:new("tooltip_campaign_ivory_road_link");
	tp_ivory_road_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_ivory_road_link");
	
	tl_ivory_road_link = tooltip_listener:new(
		"tooltip_campaign_ivory_road_link",
		function()
			uim:highlight_ivory_road(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- ivory_road_panel
	--

	parser:add_record("campaign_ivory_road_panel", "script_link_campaign_ivory_road_panel", "tooltip_campaign_ivory_road_panel");
	tp_ivory_road_panel = tooltip_patcher:new("tooltip_campaign_ivory_road_panel");
	tp_ivory_road_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_ivory_road_panel");
	
	tl_ivory_road_panel = tooltip_listener:new(
		"tooltip_campaign_ivory_road_panel", 
		function() 
			uim:highlight_ivory_road(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	

	--
	-- jungle nexus
	--

	hp_jungle_nexus = help_page:new(
		"script_link_campaign_jungle_nexus",
		hpr_title("war.camp.hp.lizardmen_jungle_nexus.001"),
		hpr_leader("war.camp.hp.lizardmen_jungle_nexus.002"),
		hpr_normal("war.camp.hp.lizardmen_jungle_nexus.003"),
		hpr_normal("war.camp.hp.lizardmen_jungle_nexus.004")
	);
	parser:add_record("campaign_jungle_nexus", "script_link_campaign_jungle_nexus", "tooltip_campaign_jungle_nexus");
	tp_jungle_nexus = tooltip_patcher:new("tooltip_campaign_jungle_nexus");
	tp_jungle_nexus:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_lizardmen_jungle_nexus", "ui_text_replacements_localised_text_hp_campaign_description_lizardmen_jungle_nexus");


	--
	-- khorne
	--

	hp_khorne = help_page:new(
		"script_link_campaign_khorne",
		hpr_title("war.camp.hp.khorne.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/khorne.png"),
		hpr_leader("war.camp.hp.khorne.002"),
		hpr_normal("war.camp.hp.khorne.003"),

		hpr_section("skulls"),
		hpr_normal_unfaded("war.camp.hp.khorne.004", "skulls"),
		hpr_normal("war.camp.hp.khorne.005", "skulls"),
		hpr_normal("war.camp.hp.khorne.006", "skulls"),

		hpr_section("destruction"),
		hpr_normal_unfaded("war.camp.hp.khorne.007", "destruction"),
		hpr_normal("war.camp.hp.khorne.008", "destruction"),
		hpr_normal("war.camp.hp.khorne.009", "destruction"),
		hpr_normal("war.camp.hp.khorne.010", "destruction"),

		hpr_section("bloodletting"),
		hpr_normal_unfaded("war.camp.hp.khorne.011", "bloodletting"),
		hpr_normal("war.camp.hp.khorne.012", "bloodletting"),

		hpr_section("great_game"),
		hpr_normal_unfaded("war.camp.hp.khorne.013", "great_game"),
		hpr_normal("war.camp.hp.khorne.014", "great_game"),
		hpr_normal("war.camp.hp.khorne.015", "great_game")
	);
	parser:add_record("campaign_khorne", "script_link_campaign_khorne", "tooltip_campaign_khorne");
	tp_khorne = tooltip_patcher:new("tooltip_campaign_khorne");
	tp_khorne:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_khorne",
		"ui_text_replacements_localised_text_hp_campaign_description_khorne", 
		"UI/help_images/khorne.png"
	);


	--
	-- kislev
	--

	hp_kislev = help_page:new(
		"script_link_campaign_kislev",
		hpr_title("war.camp.hp.kislev.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/kislev.png"),
		hpr_leader("war.camp.hp.kislev.002"),
		hpr_normal("war.camp.hp.kislev.003"),

		hpr_section("devotion"),
		hpr_normal_unfaded("war.camp.hp.kislev.004", "devotion"),
		hpr_normal("war.camp.hp.kislev.005", "devotion"),
		
		hpr_section("atamans"),
		hpr_normal_unfaded("war.camp.hp.kislev.006", "atamans"),
		hpr_normal("war.camp.hp.kislev.007", "atamans"),

		hpr_section("ice_court"),
		hpr_normal_unfaded("war.camp.hp.kislev.008", "ice_court"),
		hpr_normal("war.camp.hp.kislev.009", "ice_court"),

		hpr_normal("war.camp.hp.kislev.010")
	);
	parser:add_record("campaign_kislev", "script_link_campaign_kislev", "tooltip_campaign_kislev");
	tp_kislev = tooltip_patcher:new("tooltip_campaign_kislev");
	tp_kislev:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_kislev",
		"ui_text_replacements_localised_text_hp_campaign_description_kislev",
		"UI/help_images/kislev.png"
	);


	--
	-- lizardmen
	--

	hp_lizardmen = help_page:new(
		"script_link_campaign_lizardmen",
		hpr_title("war.camp.hp.lizardmen.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/lizardmen.png"),
		hpr_leader("war.camp.hp.lizardmen.002"),
		hpr_normal("war.camp.hp.lizardmen.003"),
		hpr_normal("war.camp.hp.lizardmen.004"),
		hpr_normal("war.camp.hp.lizardmen.005"),
		hpr_normal("war.camp.hp.lizardmen.006"),
		hpr_normal("war.camp.hp.lizardmen.007")
	);
	parser:add_record("campaign_lizardmen", "script_link_campaign_lizardmen", "tooltip_campaign_lizardmen");
	tp_lizardmen = tooltip_patcher:new("tooltip_campaign_lizardmen");
	tp_lizardmen:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_lizardmen",
		"ui_text_replacements_localised_text_hp_campaign_description_lizardmen",
		"UI/help_images/lizardmen.png"
	);
	
	
	
	--
	-- local_recruitment_pool
	--
	
	parser:add_record("campaign_local_recruitment_pool", "script_link_campaign_local_recruitment_pool", "tooltip_campaign_local_recruitment_pool");
	tp_local_recruitment_pool = tooltip_patcher:new("tooltip_campaign_local_recruitment_pool");
	tp_local_recruitment_pool:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_local_recruitment_pool");
	
	tl_local_recruitment_pool = tooltip_listener:new(
		"tooltip_campaign_local_recruitment_pool",
		function()
			uim:highlight_local_recruitment_pool(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);

	--
	-- lords
	--

	hp_lords = help_page:new(
		"script_link_campaign_lords",
		hpr_title("war.camp.hp.lords.001"),
		hpr_leader("war.camp.hp.lords.002"),
		hpr_normal("war.camp.hp.lords.003"),
		hpr_normal("war.camp.hp.lords.004"),
		hpr_normal("war.camp.hp.lords.005"),

		hpr_section("legendary_lords"),
		hpr_normal_unfaded("war.camp.hp.lords.006", "legendary_lords"),
		hpr_normal("war.camp.hp.lords.007", "legendary_lords"),
		hpr_normal("war.camp.hp.lords.008", "legendary_lords"),
		hpr_normal("war.camp.hp.lords.009", "legendary_lords"),
		hpr_normal("war.camp.hp.lords.010", "legendary_lords")
	);
	parser:add_record("campaign_lords", "script_link_campaign_lords", "tooltip_campaign_lords");
	tp_lords = tooltip_patcher:new("tooltip_campaign_lords");
	tp_lords:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_lords", "ui_text_replacements_localised_text_hp_campaign_description_lords");
	
	tl_lords = tooltip_listener:new(
		"tooltip_campaign_lords",
		function()
			uim:highlight_lords(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	--
	-- lord kroak
	--

	hp_lord_kroak = help_page:new(
		"script_link_campaign_lord_kroak",
		hpr_title("war.camp.hp.lizardmen_lord_kroak.001"),
		hpr_leader("war.camp.hp.lizardmen_lord_kroak.002"),
		hpr_normal("war.camp.hp.lizardmen_lord_kroak.003"),
		hpr_normal("war.camp.hp.lizardmen_lord_kroak.004"),
		hpr_normal("war.camp.hp.lizardmen_lord_kroak.005"),

		hpr_section("gor_rok"),
		hpr_normal_unfaded("war.camp.hp.lizardmen_lord_kroak.006", "gor_rok"),
		hpr_normal("war.camp.hp.lizardmen_lord_kroak.007", "gor_rok")
	);
	parser:add_record("campaign_lord_kroak", "script_link_campaign_lord_kroak", "tooltip_campaign_lord_kroak");
	tp_lord_kroak = tooltip_patcher:new("tooltip_campaign_lord_kroak");
	tp_lord_kroak:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_lizardmen_lord_kroak", "ui_text_replacements_localised_text_hp_campaign_description_lizardmen_lord_kroak");
	
	
	--
	-- loyalty
	--

	hp_loyalty = help_page:new(
		"script_link_campaign_loyalty",
		hpr_title("war.camp.hp.loyalty.001"),
		hpr_leader("war.camp.hp.loyalty.002"),
		hpr_normal("war.camp.hp.loyalty.003"),
		hpr_normal("war.camp.hp.loyalty.004"),
		hpr_normal("war.camp.hp.loyalty.005"),
		hpr_normal("war.camp.hp.loyalty.006"),
		hpr_normal("war.camp.hp.loyalty.007")
	);
	parser:add_record("campaign_loyalty", "script_link_campaign_loyalty", "tooltip_campaign_loyalty");
	tp_loyalty = tooltip_patcher:new("tooltip_campaign_loyalty");
	tp_loyalty:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_loyalty", "ui_text_replacements_localised_text_hp_campaign_description_loyalty");



	--
	-- magic_items
	--

	hp_magic_items = help_page:new(
		"script_link_campaign_magic_items",
		hpr_title("war.camp.hp.magic_items.001"),
		hpr_leader("war.camp.hp.magic_items.002"),
		hpr_normal("war.camp.hp.magic_items.003"),
		hpr_normal("war.camp.hp.magic_items.004"),
		hpr_normal("war.camp.hp.magic_items.005"),
		hpr_normal("war.camp.hp.magic_items.006"),
		hpr_normal("war.camp.hp.magic_items.007"),

		hpr_section("fusing"),
		hpr_normal_unfaded("war.camp.hp.magic_items.008", "fusing"),
		hpr_normal("war.camp.hp.magic_items.009", "fusing")
	);
	parser:add_record("campaign_magic_items", "script_link_campaign_magic_items", "tooltip_campaign_magic_items");
	tp_magic_items = tooltip_patcher:new("tooltip_campaign_magic_items");
	tp_magic_items:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_magic_items", "ui_text_replacements_localised_text_hp_campaign_description_magic_items");

	tl_magic_items = tooltip_listener:new(
		"tooltip_campaign_magic_items",
		function()
			uim:highlight_character_magic_items(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- marked_for_death
	--

	hp_marked_for_death = help_page:new(
		"script_link_campaign_marked_for_death",
		hpr_title("war.camp.hp.marked_for_death.001"),
		hpr_leader("war.camp.hp.marked_for_death.002"),
		hpr_normal("war.camp.hp.marked_for_death.003"),
		hpr_normal("war.camp.hp.marked_for_death.004"),
		hpr_normal("war.camp.hp.marked_for_death.005"),
		hpr_normal("war.camp.hp.marked_for_death.006"),
		hpr_normal("war.camp.hp.marked_for_death.007")
	);
	parser:add_record("campaign_marked_for_death", "script_link_campaign_marked_for_death", "tooltip_campaign_marked_for_death");
	tp_marked_for_death = tooltip_patcher:new("tooltip_campaign_marked_for_death");
	tp_marked_for_death:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_marked_for_death", "ui_text_replacements_localised_text_hp_campaign_description_marked_for_death");
	
	
	
	--
	-- marked_for_death_link
	--
	
	parser:add_record("campaign_marked_for_death_link", "script_link_campaign_marked_for_death_link", "tooltip_campaign_marked_for_death_link");
	tp_marked_for_death = tooltip_patcher:new("tooltip_campaign_marked_for_death_link");
	tp_marked_for_death:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_marked_for_death_link");
	
	
	
	--
	-- marked_for_death_button
	--
	
	parser:add_record("campaign_marked_for_death_button", "script_link_campaign_marked_for_death_button", "tooltip_campaign_marked_for_death_button");
	tp_marked_for_death_button = tooltip_patcher:new("tooltip_campaign_marked_for_death_button");
	tp_marked_for_death_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_marked_for_death_button");
	
	
	
	--
	-- Marks of Ruination
	--

	hp_marks_of_ruination = help_page:new(
		"script_link_campaign_marks_of_ruination",
		hpr_title("war.camp.hp.marks_of_ruination.001"),
		hpr_leader("war.camp.hp.marks_of_ruination.002"),
		hpr_normal("war.camp.hp.marks_of_ruination.003"),
		hpr_normal("war.camp.hp.marks_of_ruination.004"),
		hpr_normal("war.camp.hp.marks_of_ruination.005"),
		hpr_normal("war.camp.hp.marks_of_ruination.006"),
		hpr_normal("war.camp.hp.marks_of_ruination.007")
	);
	parser:add_record("campaign_marks_of_ruination", "script_link_campaign_marks_of_ruination", "tooltip_campaign_marks_of_ruination");
	tp_marks_of_ruination = tooltip_patcher:new("tooltip_campaign_marks_of_ruination");
	tp_marks_of_ruination:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_marks_of_ruination", "ui_text_replacements_localised_text_hp_campaign_description_marks_of_ruination");

	
	
	--
	-- matters of state
	--

	hp_matters_of_state = help_page:new(
		"script_link_campaign_matters_of_state",
		hpr_title("war.camp.hp.matters_of_state.001"),
		hpr_leader("war.camp.hp.matters_of_state.002"),
		hpr_normal("war.camp.hp.matters_of_state.003"),
		hpr_normal("war.camp.hp.matters_of_state.004"),
		hpr_normal("war.camp.hp.matters_of_state.005"),
		hpr_normal("war.camp.hp.matters_of_state.006"),
		hpr_normal("war.camp.hp.matters_of_state.007")
	);
	parser:add_record("campaign_matters_of_state", "script_link_campaign_matters_of_state", "tooltip_campaign_matters_of_state");
	tp_matters_of_state = tooltip_patcher:new("tooltip_campaign_matters_of_state");
	tp_matters_of_state:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_matters_of_state", "ui_text_replacements_localised_text_hp_campaign_description_matters_of_state");

	
	
	--
	-- meat
	--

	hp_meat = help_page:new(
		"script_link_campaign_meat",
		hpr_title("war.camp.hp.meat.001"),
		hpr_leader("war.camp.hp.meat.002"),
		hpr_normal("war.camp.hp.meat.003"),
		hpr_normal("war.camp.hp.meat.004"),
		hpr_normal("war.camp.hp.meat.005"),
		hpr_normal("war.camp.hp.meat.006"),
		hpr_normal("war.camp.hp.meat.007")
	);
	parser:add_record("campaign_meat", "script_link_campaign_meat", "tooltip_campaign_meat");
	tp_meat = tooltip_patcher:new("tooltip_campaign_meat");
	tp_meat:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_meat", "ui_text_replacements_localised_text_hp_campaign_description_meat");



	--
	-- meat_link
	--
	script_feature_name = "meat";
	parser:add_record("campaign_"..script_feature_name.."_link", "script_link_campaign_"..script_feature_name.."_link", "tooltip_campaign_"..script_feature_name.."_link");
	tp_meat_link = tooltip_patcher:new("tooltip_campaign_"..script_feature_name.."_link");
	tp_meat_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_"..script_feature_name.."_link");
	
	tl_meat_link = tooltip_listener:new(
		"tooltip_campaign_"..script_feature_name.."_link",
		function()
			uim:highlight_ogre_meat(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- military_convoys
	--
	script_feature_name = "military_convoys";
	hp_military_convoys = help_page:new(
		"script_link_campaign_military_convoys",
		hpr_title("war.camp.hp.military_convoys.001"),
		hpr_leader("war.camp.hp.military_convoys.002"),
		hpr_normal("war.camp.hp.military_convoys.003"),
		hpr_normal("war.camp.hp.military_convoys.004"),
		hpr_normal("war.camp.hp.military_convoys.005"),
		hpr_normal("war.camp.hp.military_convoys.006")
	);
	parser:add_record("campaign_military_convoys", "script_link_campaign_military_convoys", "tooltip_campaign_military_convoys");
	tp_military_convoys = tooltip_patcher:new("tooltip_campaign_military_convoys");
	tp_military_convoys:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_military_convoys", "ui_text_replacements_localised_text_hp_campaign_description_military_convoys");
	
	tl_military_convoys = tooltip_listener:new(
		"tooltip_campaign_military_convoys",
		function()
			uim:highlight_military_convoys(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- missions
	--

	hp_missions = help_page:new(
		"script_link_campaign_missions",
		hpr_title("war.camp.hp.missions.001"),
		hpr_leader("war.camp.hp.missions.002"),

		hpr_section("objectives_panel"),
		hpr_normal_unfaded("war.camp.hp.missions.003", "objectives_panel"),
		hpr_normal("war.camp.hp.missions.004", "objectives_panel"),
		hpr_normal("war.camp.hp.missions.005", "objectives_panel"),

		hpr_section("quests"),
		hpr_normal_unfaded("war.camp.hp.missions.006", "quests"),
		hpr_normal("war.camp.hp.missions.007", "quests"),
		
		hpr_section("grudges"),
		hpr_normal_unfaded("war.camp.hp.missions.008", "grudges"),
		hpr_normal("war.camp.hp.missions.009", "grudges"),

		hpr_normal("war.camp.hp.missions.010")
	);
	parser:add_record("campaign_missions", "script_link_campaign_missions", "tooltip_campaign_missions");
	tp_missions = tooltip_patcher:new("tooltip_campaign_missions");
	tp_missions:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_missions", "ui_text_replacements_localised_text_hp_campaign_description_missions");

	tl_missions = tooltip_listener:new(
		"tooltip_campaign_missions",
		function()
			uim:highlight_objectives_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- money
	--

	hp_money = help_page:new(
		"script_link_campaign_money",
		hpr_title("war.camp.hp.money.001"),
		hpr_leader("war.camp.hp.money.002"),
		hpr_normal("war.camp.hp.money.003"),
		hpr_normal("war.camp.hp.money.004"),
		hpr_normal("war.camp.hp.money.005"),
		hpr_normal("war.camp.hp.money.006"),
		hpr_normal("war.camp.hp.money.008")
	);
	parser:add_record("campaign_money", "script_link_campaign_money", "tooltip_campaign_money");
	tp_money = tooltip_patcher:new("tooltip_campaign_money");
	tp_money:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_money", "ui_text_replacements_localised_text_hp_campaign_description_money");
	
	
	
	--
	-- monster_pens
	--

	hp_monster_pens = help_page:new(
		"script_link_campaign_monster_pens",
		hpr_title("war.camp.hp.rakarth.001"),
		hpr_leader("war.camp.hp.rakarth.002"),
		hpr_normal("war.camp.hp.rakarth.003"),
		hpr_normal("war.camp.hp.rakarth.004"),
		hpr_normal("war.camp.hp.rakarth.005")
	);
	parser:add_record("campaign_monster_pens", "script_link_campaign_monster_pens", "tooltip_campaign_monster_pens");
	tp_monster_pens = tooltip_patcher:new("tooltip_campaign_monster_pens");
	tp_monster_pens:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_monster_pens", "ui_text_replacements_localised_text_hp_campaign_description_monster_pens");
	
	
	
	--
	-- monsters
	--

	hp_monsters = help_page:new(
		"script_link_campaign_monsters",
		hpr_title("war.camp.hp.monsters.001"),
		hpr_leader("war.camp.hp.monsters.002"),
		hpr_normal("war.camp.hp.monsters.003"),
		hpr_normal("war.camp.hp.monsters.004"),
		hpr_normal("war.camp.hp.monsters.005"),
		hpr_normal("war.camp.hp.monsters.006")
	);
	parser:add_record("campaign_monsters", "script_link_campaign_monsters", "tooltip_campaign_monsters");
	tp_monsters = tooltip_patcher:new("tooltip_campaign_monsters");
	tp_monsters:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_monsters", "ui_text_replacements_localised_text_hp_campaign_description_monsters");
	
	tl_monsters = tooltip_listener:new(
		"tooltip_campaign_monsters", 
		function() 
			uim:highlight_monstrous_arcanum_button(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- monsters_link
	--
	
	parser:add_record("campaign_monsters_link", "script_link_campaign_monsters_link", "tooltip_campaign_monsters_link");
	tp_monsters_link = tooltip_patcher:new("tooltip_campaign_monsters_link");
	tp_monsters_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_monsters_link");
	
	tl_monsters_link = tooltip_listener:new(
		"tooltip_campaign_monsters_link",
		function()
			uim:highlight_monstrous_arcanum_button(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	--
	-- mortal_worlds_torment
	--

	hp_mortal_worlds_torment = help_page:new(
		"script_link_campaign_mortal_worlds_torment",
		hpr_title("war.camp.hp.mortal_worlds_torment.001"),
		hpr_leader("war.camp.hp.mortal_worlds_torment.002"),
		hpr_normal("war.camp.hp.mortal_worlds_torment.003"),
		hpr_normal("war.camp.hp.mortal_worlds_torment.004")
	);
	parser:add_record("campaign_mortal_worlds_torment", "script_link_campaign_mortal_worlds_torment", "tooltip_campaign_mortal_worlds_torment");
	tp_mortal_worlds_torment = tooltip_patcher:new("tooltip_campaign_mortal_worlds_torment");
	tp_mortal_worlds_torment:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_mortal_worlds_torment", "ui_text_replacements_localised_text_hp_campaign_description_mortal_worlds_torment");
	
	
	
	--
	-- mortal_worlds_torment_link
	--
	
	parser:add_record("campaign_mortal_worlds_torment_link", "script_link_campaign_mortal_worlds_torment_link", "tooltip_campaign_mortal_worlds_torment_link");
	tp_mortal_worlds_torment = tooltip_patcher:new("tooltip_campaign_mortal_worlds_torment_link");
	tp_mortal_worlds_torment:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_mortal_worlds_torment_link");
	
	
	
	--
	-- mortuary_cult
	--

	hp_mortuary_cult = help_page:new(
		"script_link_campaign_mortuary_cult",
		hpr_title("war.camp.hp.mortuary_cult.001"),
		hpr_leader("war.camp.hp.mortuary_cult.002"),
		hpr_normal("war.camp.hp.mortuary_cult.003"),
		hpr_normal("war.camp.hp.mortuary_cult.004"),
		hpr_normal("war.camp.hp.mortuary_cult.005")
	);
	parser:add_record("campaign_mortuary_cult", "script_link_campaign_mortuary_cult", "tooltip_campaign_mortuary_cult");
	tp_mortuary_cult = tooltip_patcher:new("tooltip_campaign_mortuary_cult");
	tp_mortuary_cult:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_mortuary_cult", "ui_text_replacements_localised_text_hp_campaign_description_mortuary_cult");
	
	tl_mortuary_cult = tooltip_listener:new(
		"tooltip_campaign_mortuary_cult",
		function()
			uim:highlight_mortuary_cult_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- mortuary_cult_button
	--

	parser:add_record("campaign_mortuary_cult_button", "script_link_campaign_mortuary_cult_button", "tooltip_campaign_mortuary_cult_button");
	tp_mortuary_cult_button = tooltip_patcher:new("tooltip_campaign_mortuary_cult_button");
	tp_mortuary_cult_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_mortuary_cult_button");

	tl_mortuary_cult_button = tooltip_listener:new(
		"tooltip_campaign_mortuary_cult_button",
		function()
			uim:highlight_mortuary_cult_button(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- mortuary_cult_link
	--

	parser:add_record("campaign_mortuary_cult_link", "script_link_campaign_mortuary_cult_link", "tooltip_campaign_mortuary_cult_link");
	tp_mortuary_cult_link = tooltip_patcher:new("tooltip_campaign_mortuary_cult_link");
	tp_mortuary_cult_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_mortuary_cult_link");

	tl_mortuary_cult_link = tooltip_listener:new(
		"tooltip_campaign_mortuary_cult_link",
		function()
			uim:highlight_mortuary_cult_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- mortuary_cult_panel
	--

	parser:add_record("campaign_mortuary_cult_panel", "script_link_campaign_mortuary_cult_panel", "tooltip_campaign_mortuary_cult_panel");
	tp_mortuary_cult_panel = tooltip_patcher:new("tooltip_campaign_mortuary_cult_panel");
	tp_mortuary_cult_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_mortuary_cult_panel");

	tl_mortuary_cult_panel = tooltip_listener:new(
		"tooltip_campaign_mortuary_cult_panel",
		function()
			uim:highlight_mortuary_cult_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- motherland
	--

	hp_motherland = help_page:new(
		"script_link_campaign_motherland",
		hpr_title("war.camp.hp.motherland.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/motherland.png"),
		hpr_leader("war.camp.hp.motherland.002"),
		hpr_normal("war.camp.hp.motherland.003"),

		hpr_normal_unfaded("war.camp.hp.motherland.004"),
		hpr_normal("war.camp.hp.motherland.005"),
		hpr_normal_unfaded("war.camp.hp.motherland.006"),
		hpr_normal("war.camp.hp.motherland.007"),
		hpr_normal_unfaded("war.camp.hp.motherland.008"),
		hpr_normal("war.camp.hp.motherland.009"),
		hpr_normal_unfaded("war.camp.hp.motherland.010"),
		hpr_normal("war.camp.hp.motherland.011"),
		
		hpr_section("followers"),
		hpr_normal_unfaded("war.camp.hp.motherland.012", "followers"),
		hpr_normal("war.camp.hp.motherland.013", "followers"),
		hpr_normal("war.camp.hp.motherland.014", "followers"),
		hpr_normal("war.camp.hp.motherland.015", "followers"),
		hpr_normal("war.camp.hp.motherland.016", "followers"),
		hpr_normal("war.camp.hp.motherland.017", "followers")
	);
	parser:add_record("campaign_motherland", "script_link_campaign_motherland", "tooltip_campaign_motherland");
	tp_motherland = tooltip_patcher:new("tooltip_campaign_motherland");
	tp_motherland:set_layout_data(
		"tooltip_title_text_and_image", 
		"ui_text_replacements_localised_text_hp_campaign_title_motherland",
		"ui_text_replacements_localised_text_hp_campaign_description_motherland",
		"UI/help_images/motherland.png"
	);

	tl_motherland = tooltip_listener:new(
		"tooltip_campaign_motherland",
		function()
			uim:highlight_motherland(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- motherland_link
	--

	parser:add_record("campaign_motherland_link", "script_link_campaign_motherland_link", "tooltip_campaign_motherland_link");
	tp_motherland_link = tooltip_patcher:new("tooltip_campaign_motherland_link");
	tp_motherland_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_motherland_link");
	
	tl_motherland_link = tooltip_listener:new(
		"tooltip_campaign_motherland_link",
		function()
			uim:highlight_motherland(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- motherland_panel
	--
	
	parser:add_record("campaign_motherland_panel", "script_link_campaign_motherland_panel", "tooltip_campaign_motherland_panel");
	tp_motherland_panel = tooltip_patcher:new("tooltip_campaign_motherland_panel");
	tp_motherland_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_motherland_panel");

	tl_motherland_panel = tooltip_listener:new(
		"tooltip_campaign_motherland_panel",
		function()
			uim:highlight_motherland(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);

	
	--
	-- movement_range
	--
	
	parser:add_record("campaign_movement_range", "script_link_campaign_movement_range", "tooltip_campaign_movement_range");
	tp_movement_range = tooltip_patcher:new("tooltip_campaign_movement_range");
	tp_movement_range:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_movement_range");
	
	tl_movement_range = tooltip_listener:new(
		"tooltip_campaign_movement_range",
		function()
			uim:highlight_movement_range(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- non_aggression_pacts
	--
	
	hp_non_aggression_pacts = help_page:new(
		"script_link_campaign_non_aggression_pacts",
		hpr_title("war.camp.hp.non_aggression_pacts.001"),
		hpr_leader("war.camp.hp.non_aggression_pacts.002"),
		hpr_normal("war.camp.hp.non_aggression_pacts.003"),
		hpr_normal("war.camp.hp.non_aggression_pacts.004")
	);
	parser:add_record("campaign_non_aggression_pacts", "script_link_campaign_non_aggression_pacts", "tooltip_campaign_non_aggression_pacts");
	tp_non_aggression_pacts = tooltip_patcher:new("tooltip_campaign_non_aggression_pacts");
	tp_non_aggression_pacts:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_non_aggression_pacts", "ui_text_replacements_localised_text_hp_campaign_description_non_aggression_pacts");
	


	--
	-- non_aggression_pacts_link
	--
	script_feature_name = "non_aggression_pacts";
	parser:add_record("campaign_"..script_feature_name.."_link", "script_link_campaign_"..script_feature_name.."_link", "tooltip_campaign_"..script_feature_name.."_link");
	tp_non_aggression_pacts = tooltip_patcher:new("tooltip_campaign_"..script_feature_name.."_link");
	tp_non_aggression_pacts:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_"..script_feature_name.."_link");
	
	tl_non_aggression_pacts = tooltip_listener:new(
		"tooltip_campaign_"..script_feature_name.."_link",
		function()
			uim:highlight_non_aggression(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	--
	-- norsca
	--

	hp_norsca = help_page:new(
		"script_link_campaign_norsca",
		hpr_title("war.camp.hp.norsca.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/norsca.png"),
		hpr_leader("war.camp.hp.norsca.002"),
		hpr_normal("war.camp.hp.norsca.003"),
		hpr_normal("war.camp.hp.norsca.004"),
		hpr_normal("war.camp.hp.norsca.005")
	);
	parser:add_record("campaign_norsca", "script_link_campaign_norsca", "tooltip_campaign_norsca");
	tp_norsca = tooltip_patcher:new("tooltip_campaign_norsca");
	tp_norsca:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_norsca",
		"ui_text_replacements_localised_text_hp_campaign_description_norsca",
		"UI/help_images/norsca.png"
	);
	
	--
	-- norscan homelands
	--

	hp_norscan_homelands = help_page:new(
		"script_link_campaign_norscan_homelands",
		hpr_title("war.camp.hp.norscan_homelands.001"),
		hpr_leader("war.camp.hp.norscan_homelands.002"),
		hpr_normal("war.camp.hp.norscan_homelands.003"),
		hpr_normal("war.camp.hp.norscan_homelands.004"),
		hpr_normal("war.camp.hp.norscan_homelands.005"),
		hpr_normal("war.camp.hp.norscan_homelands.006")
	);
	parser:add_record("campaign_norscan_homelands", "script_link_campaign_norscan_homelands", "tooltip_campaign_norscan_homelands");
	tp_norscan_homelands = tooltip_patcher:new("tooltip_campaign_norscan_homelands");
	tp_norscan_homelands:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_norscan_homelands", "ui_text_replacements_localised_text_hp_campaign_description_norscan_homelands");

	--
	-- nurgle
	--

	hp_nurgle = help_page:new(
		"script_link_campaign_nurgle",
		hpr_title("war.camp.hp.nurgle.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/nurgle.png"),
		hpr_leader("war.camp.hp.nurgle.002"),
		hpr_normal("war.camp.hp.nurgle.003"),

		hpr_section("plagues"),
		hpr_normal_unfaded("war.camp.hp.nurgle.004", "plagues"),
		hpr_normal("war.camp.hp.nurgle.005", "plagues"),

		hpr_section("recruitment"),
		hpr_normal_unfaded("war.camp.hp.nurgle.006", "recruitment"),
		hpr_normal("war.camp.hp.nurgle.007", "recruitment"),
		hpr_normal("war.camp.hp.nurgle.008", "recruitment"),
		
		hpr_section("growth"),
		hpr_normal_unfaded("war.camp.hp.nurgle.009", "growth"),
		hpr_normal("war.camp.hp.nurgle.010", "growth"),

		hpr_section("great_game"),
		hpr_normal_unfaded("war.camp.hp.nurgle.011", "great_game"),
		hpr_normal("war.camp.hp.nurgle.012", "great_game"),
		hpr_normal("war.camp.hp.nurgle.013", "great_game")
	);
	parser:add_record("campaign_nurgle", "script_link_campaign_nurgle", "tooltip_campaign_nurgle");
	tp_nurgle = tooltip_patcher:new("tooltip_campaign_nurgle");
	tp_nurgle:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_nurgle",
		"ui_text_replacements_localised_text_hp_campaign_description_nurgle",
		"UI/help_images/nurgle.png"
	);
	
	
	--
	-- oak of ages
	--

	hp_oak_of_ages = help_page:new(
		"script_link_campaign_oak_of_ages",
		hpr_title("war.camp.hp.oak_of_ages.001"),
		hpr_leader("war.camp.hp.oak_of_ages.002"),
		hpr_normal("war.camp.hp.oak_of_ages.003")
	);
	parser:add_record("campaign_oak_of_ages", "script_link_campaign_oak_of_ages", "tooltip_campaign_oak_of_ages");
	tp_oak_of_ages = tooltip_patcher:new("tooltip_campaign_oak_of_ages");
	tp_oak_of_ages:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_oak_of_ages", "ui_text_replacements_localised_text_hp_campaign_description_oak_of_ages");
	
	
	--
	-- oathgold
	--

	hp_oathgold = help_page:new(
		"script_link_campaign_oathgold",
		hpr_title("war.camp.hp.oathgold.001"),
		hpr_leader("war.camp.hp.oathgold.002"),
		hpr_normal("war.camp.hp.oathgold.003"),
		hpr_normal("war.camp.hp.oathgold.004"),
		hpr_normal("war.camp.hp.oathgold.005"),
		hpr_normal("war.camp.hp.oathgold.006")
	);
	parser:add_record("campaign_oathgold", "script_link_campaign_oathgold", "tooltip_campaign_oathgold");
	tp_oathgold = tooltip_patcher:new("tooltip_campaign_oathgold");
	tp_oathgold:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_oathgold", "ui_text_replacements_localised_text_hp_campaign_description_oathgold");
	
	tl_oathgold = tooltip_listener:new(
		"tooltip_campaign_oathgold",
		function()
			uim:highlight_oathgold(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- oathgold_link
	--

	parser:add_record("campaign_oathgold_link", "script_link_campaign_oathgold_link", "tooltip_campaign_oathgold_link");
	tp_oathgold_link = tooltip_patcher:new("tooltip_campaign_oathgold_link");
	tp_oathgold_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_oathgold_link");

	tl_oathgold_link = tooltip_listener:new(
		"tooltip_campaign_oathgold_link",
		function()
			uim:highlight_oathgold(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	--
	-- objectives_button
	--
	
	parser:add_record("campaign_objectives_button", "script_link_campaign_objectives_button", "tooltip_campaign_objectives_button");
	tp_objectives_button = tooltip_patcher:new("tooltip_campaign_objectives_button");
	tp_objectives_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_objectives_button");
	
	tl_objectives_button = tooltip_listener:new(
		"tooltip_campaign_objectives_button",
		function()
			uim:highlight_objectives_button(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- objectives_chapter_missions_tab
	--
	
	parser:add_record("campaign_objectives_chapter_missions_tab", "script_link_campaign_objectives_chapter_missions_tab", "tooltip_campaign_objectives_chapter_missions_tab");
	tp_objectives_chapter_missions_tab = tooltip_patcher:new("tooltip_campaign_objectives_chapter_missions_tab");
	tp_objectives_chapter_missions_tab:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_objectives_chapter_missions_tab");
	
	tl_objectives_chapter_missions_tab = tooltip_listener:new(
		"tooltip_campaign_objectives_chapter_missions_tab",
		function()
			uim:highlight_objectives_chapter_missions_tab(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
		
	
	--
	-- objectives_victory_conditions_tab
	--
	
	parser:add_record("campaign_objectives_victory_conditions_tab", "script_link_campaign_objectives_victory_conditions_tab", "tooltip_campaign_objectives_victory_conditions_tab");
	tp_objectives_victory_conditions_tab = tooltip_patcher:new("tooltip_campaign_objectives_victory_conditions_tab");
	tp_objectives_victory_conditions_tab:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_objectives_victory_conditions_tab");
	
	tl_objectives_victory_conditions_tab = tooltip_listener:new(
		"tooltip_campaign_objectives_victory_conditions_tab",
		function()
			uim:highlight_objectives_victory_conditions_tab(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- offer_to_the_great_maw_panel
	--

	parser:add_record("campaign_offer_to_the_great_maw_panel", "script_link_campaign_offer_to_the_great_maw_panel", "tooltip_campaign_offer_to_the_great_maw_panel");
	tp_offer_to_the_great_maw_panel = tooltip_patcher:new("tooltip_campaign_offer_to_the_great_maw_panel");
	tp_offer_to_the_great_maw_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_offer_to_the_great_maw_panel");
	
	tl_offer_to_the_great_maw_panel = tooltip_listener:new(
		"tooltip_campaign_offer_to_the_great_maw_panel", 
		function() 
			uim:highlight_offer_to_the_great_maw(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- offices
	--

	hp_offices = help_page:new(
		"script_link_campaign_offices",
		hpr_title("war.camp.hp.offices.001"),
		hpr_leader("war.camp.hp.offices.002"),
		hpr_normal("war.camp.hp.offices.003"),
		hpr_normal("war.camp.hp.offices.004"),
		hpr_normal("war.camp.hp.offices.005")
	);
	parser:add_record("campaign_offices", "script_link_campaign_offices", "tooltip_campaign_offices");
	tp_offices = tooltip_patcher:new("tooltip_campaign_offices");
	tp_offices:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_offices", "ui_text_replacements_localised_text_hp_campaign_description_offices");
	
	tl_offices = tooltip_listener:new(
		"tooltip_campaign_offices", 
		function()
			uim:highlight_offices(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- offices_button
	--
	
	parser:add_record("campaign_offices_button", "script_link_campaign_offices_button", "tooltip_campaign_offices_button");
	tp_offices_button = tooltip_patcher:new("tooltip_campaign_offices_button");
	tp_offices_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_offices_button");
	
	tl_offices_button = tooltip_listener:new(
		"tooltip_campaign_offices_button", 
		function()
			uim:highlight_offices_button(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- offices_link
	--
	
	parser:add_record("campaign_offices_link", "script_link_campaign_offices_link", "tooltip_campaign_offices_link");
	tp_offices = tooltip_patcher:new("tooltip_campaign_offices_link");
	tp_offices:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_offices_link");
	
	tl_offices = tooltip_listener:new(
		"tooltip_campaign_offices_link",
		function()
			uim:highlight_offices(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- ogre_camps
	--

	hp_ogre_camps = help_page:new(
		"script_link_campaign_ogre_camps",
		hpr_title("war.camp.hp.ogre_camps.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/ogre_camps.png"),
		hpr_leader("war.camp.hp.ogre_camps.002"),

		hpr_section("reqs"),
		hpr_normal_unfaded("war.camp.hp.ogre_camps.003", "reqs"),
		hpr_normal("war.camp.hp.ogre_camps.004", "reqs"),

		hpr_section("construction"),
		hpr_normal_unfaded("war.camp.hp.ogre_camps.005", "construction"),
		hpr_normal("war.camp.hp.ogre_camps.006", "construction"),

		hpr_section("benefits"),
		hpr_normal_unfaded("war.camp.hp.ogre_camps.007", "benefits"),
		hpr_normal("war.camp.hp.ogre_camps.008", "benefits"),

		hpr_section("buildings"),
		hpr_normal_unfaded("war.camp.hp.ogre_camps.009", "buildings"),
		hpr_normal("war.camp.hp.ogre_camps.010", "buildings"),
		hpr_normal("war.camp.hp.ogre_camps.011", "buildings"),

		hpr_section("mercs"),
		hpr_normal_unfaded("war.camp.hp.ogre_camps.012", "mercs"),
		hpr_normal("war.camp.hp.ogre_camps.013", "mercs")
	);
	parser:add_record("campaign_ogre_camps", "script_link_campaign_ogre_camps", "tooltip_campaign_ogre_camps");
	tp_ogre_camps = tooltip_patcher:new("tooltip_campaign_ogre_camps");
	tp_ogre_camps:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_ogre_camps",
		"ui_text_replacements_localised_text_hp_campaign_description_ogre_camps", 
		"UI/help_images/ogre_camps.png"
	);


	--
	-- ogre_kingdoms
	--

	hp_ogre_kingdoms = help_page:new(
		"script_link_campaign_ogre_kingdoms",
		hpr_title("war.camp.hp.ogre_kingdoms.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/ogre_kingdoms.png"),
		hpr_leader("war.camp.hp.ogre_kingdoms.002"),

		hpr_section("meat"),
		hpr_normal_unfaded("war.camp.hp.ogre_kingdoms.003", "meat"),
		hpr_normal("war.camp.hp.ogre_kingdoms.004", "meat"),

		hpr_section("camps"),
		hpr_normal_unfaded("war.camp.hp.ogre_kingdoms.005", "camps"),
		hpr_normal("war.camp.hp.ogre_kingdoms.006", "camps"),
		hpr_normal("war.camp.hp.ogre_kingdoms.007", "camps"),

		hpr_section("contracts"),
		hpr_normal_unfaded("war.camp.hp.ogre_kingdoms.008", "contracts"),
		hpr_normal("war.camp.hp.ogre_kingdoms.009", "contracts"),

		hpr_section("big_names"),
		hpr_normal_unfaded("war.camp.hp.ogre_kingdoms.010", "big_names"),
		hpr_normal("war.camp.hp.ogre_kingdoms.011", "big_names"),

		hpr_normal("war.camp.hp.ogre_kingdoms.012")
	);
	parser:add_record("campaign_ogre_kingdoms", "script_link_campaign_ogre_kingdoms", "tooltip_campaign_ogre_kingdoms");
	tp_ogre_kingdoms = tooltip_patcher:new("tooltip_campaign_ogre_kingdoms");
	tp_ogre_kingdoms:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_ogre_kingdoms",
		"ui_text_replacements_localised_text_hp_campaign_description_ogre_kingdoms", 
		"UI/help_images/ogre_kingdoms.png"
	);


	--
	-- outposts
	--

	hp_outposts = help_page:new(
		"script_link_campaign_outposts",
		hpr_title("war.camp.hp.outposts.001"),
		hpr_leader("war.camp.hp.outposts.002"),
		hpr_normal("war.camp.hp.outposts.003"),
		hpr_normal("war.camp.hp.outposts.004"),
		hpr_normal("war.camp.hp.outposts.005"),
		hpr_normal("war.camp.hp.outposts.006")
	);
	parser:add_record("campaign_outposts", "script_link_campaign_outposts", "tooltip_campaign_outposts");
	tp_outposts = tooltip_patcher:new("tooltip_campaign_outposts");
	tp_outposts:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_outposts", "ui_text_replacements_localised_text_hp_campaign_description_outposts");
	
	
	
	--
	-- oxyotl_visions
	--

	hp_oxyotl_visions = help_page:new(
		"script_link_campaign_oxyotl_visions",
		hpr_title("war.camp.hp.oxyotl_visions.001"),
		hpr_leader("war.camp.hp.oxyotl_visions.002"),
		hpr_normal("war.camp.hp.oxyotl_visions.003"),
		hpr_normal("war.camp.hp.oxyotl_visions.004"),
		hpr_normal("war.camp.hp.oxyotl_visions.005"),
		hpr_normal("war.camp.hp.oxyotl_visions.006"),
		hpr_normal("war.camp.hp.oxyotl_visions.007")
	);
	parser:add_record("campaign_oxyotl_visions", "script_link_campaign_oxyotl_visions", "tooltip_campaign_oxyotl_visions");
	tp_oxyotl_visions = tooltip_patcher:new("tooltip_campaign_oxyotl_visions");
	tp_oxyotl_visions:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_oxyotl_visions_title", "ui_text_replacements_localised_text_hp_campaign_oxyotl_visions_description");

	--
	-- path to glory
	--

	hp_path_to_glory = help_page:new(
		"script_link_campaign_path_to_glory",
		hpr_title("war.camp.hp.path_to_glory.001"),
		hpr_leader("war.camp.hp.path_to_glory.002"),
		hpr_normal("war.camp.hp.path_to_glory.003"),
		hpr_normal("war.camp.hp.path_to_glory.004"),
		hpr_normal("war.camp.hp.path_to_glory.005")
	);
	parser:add_record("campaign_path_to_glory", "script_link_campaign_path_to_glory", "tooltip_campaign_path_to_glory");
	tp_path_to_glory = tooltip_patcher:new("tooltip_campaign_path_to_glory");
	tp_path_to_glory:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_path_to_glory", "ui_text_replacements_localised_text_hp_campaign_description_path_to_glory");


	--
	-- peasants
	--
	
	hp_peasants = help_page:new(
		"script_link_campaign_peasants",
		hpr_title("war.camp.hp.peasants.001"),
		hpr_leader("war.camp.hp.peasants.002"),
		hpr_normal("war.camp.hp.peasants.003"),
		hpr_normal("war.camp.hp.peasants.004"),
		hpr_normal("war.camp.hp.peasants.005")
	);
	parser:add_record("campaign_peasants", "script_link_campaign_peasants", "tooltip_campaign_peasants");
	tp_peasants = tooltip_patcher:new("tooltip_campaign_peasants");
	tp_peasants:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_peasants", "ui_text_replacements_localised_text_hp_campaign_description_peasants");
	
	tl_peasants = tooltip_listener:new(
		"tooltip_campaign_peasants", 
		function()
			uim:highlight_peasants(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- peasants_link
	--
	
	parser:add_record("campaign_peasants_link", "script_link_campaign_peasants_link", "tooltip_campaign_peasants_link");
	tp_peasants_link = tooltip_patcher:new("tooltip_campaign_peasants_link");
	tp_peasants_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_peasants_link");
	
	tl_peasants_link = tooltip_listener:new(
		"tooltip_campaign_peasants_link", 
		function()
			uim:highlight_peasants(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	--
	-- pieces_of_eight
	--

	hp_pieces_of_eight = help_page:new(
		"script_link_campaign_pieces_of_eight",
		hpr_title("war.camp.hp.pieces_of_eight.001"),
		hpr_leader("war.camp.hp.pieces_of_eight.002"),
		hpr_normal("war.camp.hp.pieces_of_eight.003"),
		hpr_normal("war.camp.hp.pieces_of_eight.004"),
		hpr_normal("war.camp.hp.pieces_of_eight.005"),
		hpr_normal("war.camp.hp.pieces_of_eight.006"),
		hpr_normal("war.camp.hp.pieces_of_eight.007")
	);
	parser:add_record("campaign_pieces_of_eight", "script_link_campaign_pieces_of_eight", "tooltip_campaign_pieces_of_eight");
	tp_pieces_of_eight = tooltip_patcher:new("tooltip_campaign_pieces_of_eight");
	tp_pieces_of_eight:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_pieces_of_eight", "ui_text_replacements_localised_text_hp_campaign_description_pieces_of_eight");
	
	tl_pieces_of_eight = tooltip_listener:new(
		"tooltip_campaign_pieces_of_eight", 
		function()
			uim:highlight_pieces_of_eight_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end	
	);
	
	
	--
	-- pieces_of_eight_link
	--
	
	parser:add_record("campaign_pieces_of_eight_link", "script_link_campaign_pieces_of_eight_link", "tooltip_campaign_pieces_of_eight_link");
	tp_pieces_of_eight_link = tooltip_patcher:new("tooltip_campaign_pieces_of_eight_link");
	tp_pieces_of_eight_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_pieces_of_eight_link");
	
	tl_pieces_of_eight_link = tooltip_listener:new(
		"tooltip_campaign_pieces_of_eight_link",
		function()
			uim:highlight_pieces_of_eight_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- pirate_coves
	--

	hp_pirate_coves = help_page:new(
		"script_link_campaign_pirate_coves",
		hpr_title("war.camp.hp.pirate_coves.001"),
		hpr_leader("war.camp.hp.pirate_coves.002"),
		hpr_normal("war.camp.hp.pirate_coves.003"),
		hpr_normal("war.camp.hp.pirate_coves.004"),
		hpr_normal("war.camp.hp.pirate_coves.005"), 
		hpr_normal("war.camp.hp.pirate_coves.006"), 
		hpr_normal("war.camp.hp.pirate_coves.007") 
	);
	parser:add_record("campaign_pirate_coves", "script_link_campaign_pirate_coves", "tooltip_campaign_pirate_coves");
	tp_pirate_coves = tooltip_patcher:new("tooltip_campaign_pirate_coves");
	tp_pirate_coves:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_pirate_coves", "ui_text_replacements_localised_text_hp_campaign_description_pirate_coves");
	
	
	tl_pirate_coves = tooltip_listener:new(
		"tooltip_campaign_pirate_coves", 
		function()
			uim:highlight_pirate_coves(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end	
	);
	
	
	--
	-- pirate_coves_link
	--
	
	parser:add_record("campaign_pirate_coves_link", "script_link_campaign_pirate_coves_link", "tooltip_campaign_pirate_coves_link");
	tp_pirate_coves_link = tooltip_patcher:new("tooltip_campaign_pirate_coves_link");
	tp_pirate_coves_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_pirate_coves_link");
	
	tl_pirate_coves_link = tooltip_listener:new(
		"tooltip_campaign_pirate_coves_link",
		function()
			uim:highlight_pirate_coves(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	--
	-- plagues
	--

	hp_plagues = help_page:new(
		"script_link_campaign_plagues",
		hpr_title("war.camp.hp.plagues.001"),
		hpr_leader("war.camp.hp.plagues.002"),
		hpr_normal("war.camp.hp.plagues.003"),
		hpr_normal("war.camp.hp.plagues.004"),
		hpr_normal("war.camp.hp.plagues.005"),
		hpr_normal("war.camp.hp.plagues.006"),
		hpr_normal("war.camp.hp.plagues.007")
	);
	parser:add_record("campaign_plagues", "script_link_campaign_plagues", "tooltip_campaign_plagues");
	tp_plagues = tooltip_patcher:new("tooltip_campaign_plagues");
	tp_plagues:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_plagues", "ui_text_replacements_localised_text_hp_campaign_description_plagues");



	--
	-- plague_cauldron_panel
	--

	parser:add_record("campaign_plague_cauldron_panel", "script_link_campaign_plague_cauldron_panel", "tooltip_campaign_plague_cauldron_panel");
	tp_plague_cauldron_panel = tooltip_patcher:new("tooltip_campaign_plague_cauldron_panel");
	tp_plague_cauldron_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_plague_cauldron_panel");
	
	tl_plague_cauldron_panel = tooltip_listener:new(
		"tooltip_campaign_plague_cauldron_panel", 
		function() 
			uim:highlight_plagues_of_nurgle(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- plagues_of_nurgle
	--

	hp_plagues_of_nurgle = help_page:new(
		"script_link_campaign_plagues_of_nurgle",
		hpr_title("war.camp.hp.plagues_of_nurgle.001"),
		hpr_leader("war.camp.hp.plagues_of_nurgle.002"),
		hpr_normal("war.camp.hp.plagues_of_nurgle.003"),
		hpr_normal("war.camp.hp.plagues_of_nurgle.004"),
		hpr_normal("war.camp.hp.plagues_of_nurgle.005"),
		hpr_normal("war.camp.hp.plagues_of_nurgle.006"),
		hpr_normal("war.camp.hp.plagues_of_nurgle.007")
	);
	parser:add_record("campaign_plagues_of_nurgle", "script_link_campaign_plagues_of_nurgle", "tooltip_campaign_plagues_of_nurgle");
	tp_plagues_of_nurgle = tooltip_patcher:new("tooltip_campaign_plagues_of_nurgle");
	tp_plagues_of_nurgle:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_plagues_of_nurgle", "ui_text_replacements_localised_text_hp_campaign_description_plagues_of_nurgle");

	tl_plagues_of_nurgle = tooltip_listener:new(
		"tooltip_campaign_plagues_of_nurgle", 
		function() 
			uim:highlight_plagues_of_nurgle(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- plagues_of_nurgle_link
	--
	script_feature_name = "plagues_of_nurgle";
	parser:add_record("campaign_"..script_feature_name.."_link", "script_link_campaign_"..script_feature_name.."_link", "tooltip_campaign_"..script_feature_name.."_link");
	tp_plagues_of_nurgle_link = tooltip_patcher:new("tooltip_campaign_"..script_feature_name.."_link");
	tp_plagues_of_nurgle_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_"..script_feature_name.."_link");
	
	tl_plagues_of_nurgle_link = tooltip_listener:new(
		"tooltip_campaign_"..script_feature_name.."_link",
		function()
			uim:highlight_plagues_of_nurgle(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- plague_recipes
	--

	parser:add_record("campaign_plague_recipes", "script_link_campaign_plague_recipes", "tooltip_campaign_plague_recipes");
	tp_plague_recipes = tooltip_patcher:new("tooltip_campaign_plague_recipes");
	tp_plague_recipes:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_plague_recipes");
	
	tl_plague_recipes = tooltip_listener:new(
		"tooltip_campaign_plague_recipes",
		function()
			uim:highlight_plague_recipes(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- pleasurable_acts
	--

	hp_pleasurable_acts = help_page:new(
		"script_link_campaign_pleasurable_acts",
		hpr_title("war.camp.hp.pleasurable_acts.001"),
		hpr_leader("war.camp.hp.pleasurable_acts.002"),
		hpr_normal("war.camp.hp.pleasurable_acts.003"),
		hpr_normal("war.camp.hp.pleasurable_acts.004")
	);
	parser:add_record("campaign_pleasurable_acts", "script_link_campaign_pleasurable_acts", "tooltip_campaign_pleasurable_acts");
	tp_pleasurable_acts = tooltip_patcher:new("tooltip_campaign_pleasurable_acts");
	tp_pleasurable_acts:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_pleasurable_acts", "ui_text_replacements_localised_text_hp_campaign_description_pleasurable_acts");

	tl_pleasurable_acts = tooltip_listener:new(
		"tooltip_campaignpleasurable_acts", 
		function() 
			uim:highlight_pleasurable_acts(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- pleasurable_acts_link
	--
	script_feature_name = "pleasurable_acts";
	parser:add_record("campaign_"..script_feature_name.."_link", "script_link_campaign_"..script_feature_name.."_link", "tooltip_campaign_"..script_feature_name.."_link");
	tp_pleasurable_acts_link = tooltip_patcher:new("tooltip_campaign_"..script_feature_name.."_link");
	tp_pleasurable_acts_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_"..script_feature_name.."_link");
	
	tl_pleasurable_acts_link = tooltip_listener:new(
		"tooltip_campaign_"..script_feature_name.."_link",
		function()
			uim:highlight_pleasurable_acts(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- pleasurable_acts_buttons
	--

	parser:add_record("campaign_pleasurable_acts_buttons", "script_link_campaign_pleasurable_acts_buttons", "tooltip_campaign_pleasurable_acts_buttons");
	tp_pleasurable_acts = tooltip_patcher:new("tooltip_campaign_pleasurable_acts_buttons");
	tp_pleasurable_acts:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_pleasurable_acts_buttons");

	tl_pleasurable_acts_buttons = tooltip_listener:new(
		"tooltip_campaign_pleasurable_acts_buttons", 
		function() 
			uim:highlight_pleasurable_acts(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- ports
	--

	hp_ports = help_page:new(
		"script_link_campaign_ports",
		hpr_title("war.camp.hp.ports.001"),
		hpr_leader("war.camp.hp.ports.002"),
		hpr_normal("war.camp.hp.ports.003"),
		hpr_normal("war.camp.hp.ports.004"),
		hpr_normal("war.camp.hp.ports.005")
	);
	parser:add_record("campaign_ports", "script_link_campaign_ports", "tooltip_campaign_ports");
	tp_ports = tooltip_patcher:new("tooltip_campaign_ports");
	tp_ports:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_ports", "ui_text_replacements_localised_text_hp_campaign_description_ports");

	tl_ports = tooltip_listener:new(
		"tooltip_campaign_ports", 
		function()
			uim:highlight_ports(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- ports_link
	--
	
	parser:add_record("campaign_ports_link", "script_link_campaign_ports_link", "tooltip_campaign_ports_link");
	tp_ports = tooltip_patcher:new("tooltip_campaign_ports_link");
	tp_ports:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_ports_link");
	
	tl_ports_link = tooltip_listener:new(
		"tooltip_campaign_ports_link",
		function()
			uim:highlight_ports(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- possession_tzarkan
	--
	
	hp_possession_tzarkan = help_page:new(
		"script_link_campaign_dark_elves_possession_tzarkan",
		hpr_title("war.camp.hp.possession_tzarkan.001"),
		hpr_leader("war.camp.hp.possession_tzarkan.002"),
		hpr_normal("war.camp.hp.possession_tzarkan.003"),
		hpr_normal("war.camp.hp.possession_tzarkan.004"),
		hpr_normal("war.camp.hp.possession_tzarkan.005"),
		hpr_normal("war.camp.hp.possession_tzarkan.006"),
		hpr_normal("war.camp.hp.possession_tzarkan.007")
	);
	parser:add_record("campaign_dark_elves_possession_tzarkan", "script_link_campaign_dark_elves_possession_tzarkan", "tooltip_campaign_dark_elves_possession_tzarkan");
	tp_possession_tzarkan = tooltip_patcher:new("tooltip_campaign_dark_elves_possession_tzarkan");
	tp_possession_tzarkan:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_possession_tzarkan", "ui_text_replacements_localised_text_hp_campaign_description_possession_tzarkan");
	
	

	--
	-- post_battle_options
	--

	hp_post_battle_options = help_page:new(
		"script_link_campaign_post_battle_options",
		hpr_title("war.camp.hp.post_battle_options.001"),
		hpr_leader("war.camp.hp.post_battle_options.002"),
		hpr_normal("war.camp.hp.post_battle_options.003"),
		hpr_normal("war.camp.hp.post_battle_options.004"),
		hpr_normal("war.camp.hp.post_battle_options.005"),
		hpr_normal("war.camp.hp.post_battle_options.006")
	);
	parser:add_record("campaign_post_battle_options", "script_link_campaign_post_battle_options", "tooltip_campaign_post_battle_options");
	tp_post_battle_options = tooltip_patcher:new("tooltip_campaign_post_battle_options");
	tp_post_battle_options:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_post_battle_options", "ui_text_replacements_localised_text_hp_campaign_description_post_battle_options");

	tl_post_battle_options = tooltip_listener:new(
		"tooltip_campaign_post_battle_options", 
		function() 
			uim:highlight_post_battle_options(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- post_battle_options_link
	--
	
	parser:add_record("campaign_post_battle_options_link", "script_link_campaign_post_battle_options_link", "tooltip_campaign_post_battle_options_link");
	tp_post_battle_options = tooltip_patcher:new("tooltip_campaign_post_battle_options_link");
	tp_post_battle_options:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_post_battle_options_link");
	
	tl_post_battle_options_link = tooltip_listener:new(
		"tooltip_campaign_post_battle_options_link",
		function()
			uim:highlight_post_battle_options(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	


	--
	-- post_battle_panel
	--

	hp_post_battle_panel = help_page:new(
		"script_link_campaign_post_battle_panel",
		hpr_title("war.camp.hp.post_battle_panel.001"),
		hpr_leader("war.camp.hp.post_battle_panel.002"),
		hpr_normal("war.camp.hp.post_battle_panel.003"),
		hpr_normal("war.camp.hp.post_battle_panel.004"),
		hpr_normal("war.camp.hp.post_battle_panel.006")
	);
	parser:add_record("campaign_post_battle_panel", "script_link_campaign_post_battle_panel", "tooltip_campaign_post_battle_panel");
	tp_post_battle_panel = tooltip_patcher:new("tooltip_campaign_post_battle_panel");
	tp_post_battle_panel:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_post_battle_panel", "ui_text_replacements_localised_text_hp_campaign_description_post_battle_panel");

	tl_post_battle_panel = tooltip_listener:new(
		"tooltip_campaign_post_battle_panel", 
		function() 
			uim:highlight_post_battle_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- post_battle_panel_link
	--
	
	parser:add_record("campaign_post_battle_panel_link", "script_link_campaign_post_battle_panel_link", "tooltip_campaign_post_battle_panel_link");
	tp_post_battle_panel = tooltip_patcher:new("tooltip_campaign_post_battle_panel_link");
	tp_post_battle_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_post_battle_panel_link");
	
	tl_post_battle_panel_link = tooltip_listener:new(
		"tooltip_campaign_post_battle_panel_link",
		function()
			uim:highlight_post_battle_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
    --
	-- power_of_nature
	--

	hp_power_of_nature = help_page:new(
		"script_link_campaign_power_of_nature",
		hpr_title("war.camp.hp.power_of_nature.001"),
		hpr_leader("war.camp.hp.power_of_nature.002"),
		hpr_normal("war.camp.hp.power_of_nature.003"),
		hpr_normal("war.camp.hp.power_of_nature.004"),
		hpr_normal("war.camp.hp.power_of_nature.005")
	);
	parser:add_record("campaign_power_of_nature", "script_link_campaign_power_of_nature", "tooltip_campaign_power_of_nature");
	tp_power_of_nature = tooltip_patcher:new("tooltip_campaign_power_of_nature");
	tp_power_of_nature:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_power_of_nature", "ui_text_replacements_localised_text_hp_campaign_description_power_of_nature");
	
	

	--
	-- power_of_nature_link
	--
	
	parser:add_record("campaign_power_of_nature_link", "script_link_campaign_power_of_nature_link", "tooltip_campaign_power_of_nature_link");
	tp_power_of_nature = tooltip_patcher:new("tooltip_campaign_power_of_nature_link");
	tp_power_of_nature:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_power_of_nature_link");
	
	
	--
	-- pre_battle_options
	--

	hp_pre_battle_options = help_page:new(
		"script_link_campaign_pre_battle_options",
		hpr_title("war.camp.hp.pre_battle_options.001"),
		hpr_leader("war.camp.hp.pre_battle_options.002"),
		hpr_normal("war.camp.hp.pre_battle_options.003"),
		hpr_normal("war.camp.hp.pre_battle_options.004"),
		hpr_normal("war.camp.hp.pre_battle_options.005"),
		hpr_normal("war.camp.hp.pre_battle_options.006"),
		hpr_normal("war.camp.hp.pre_battle_options.007")
	);
	parser:add_record("campaign_pre_battle_options", "script_link_campaign_pre_battle_options", "tooltip_campaign_pre_battle_options");
	tp_pre_battle_options = tooltip_patcher:new("tooltip_campaign_pre_battle_options");
	tp_pre_battle_options:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_pre_battle_options", "ui_text_replacements_localised_text_hp_campaign_description_pre_battle_options");

	tl_pre_battle_options = tooltip_listener:new(
		"tooltip_campaign_pre_battle_options", 
		function() 
			uim:highlight_pre_battle_options(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- pre_battle_options_link
	--
	
	parser:add_record("campaign_pre_battle_options_link", "script_link_campaign_pre_battle_options_link", "tooltip_campaign_pre_battle_options_link");
	tp_pre_battle_options = tooltip_patcher:new("tooltip_campaign_pre_battle_options_link");
	tp_pre_battle_options:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_pre_battle_options_link");
	
	tl_pre_battle_options_link = tooltip_listener:new(
		"tooltip_campaign_pre_battle_options_link",
		function()
			uim:highlight_pre_battle_options(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- pre_battle_panel
	--

	hp_pre_battle_panel = help_page:new(
		"script_link_campaign_pre_battle_panel",
		hpr_title("war.camp.hp.pre_battle_panel.001"),
		hpr_leader("war.camp.hp.pre_battle_panel.002"),
		hpr_normal("war.camp.hp.pre_battle_panel.003"),
		hpr_normal("war.camp.hp.pre_battle_panel.004"),
		hpr_normal("war.camp.hp.pre_battle_panel.005"),
		hpr_normal("war.camp.hp.pre_battle_panel.006"),
		hpr_normal("war.camp.hp.pre_battle_panel.007"),
		hpr_normal("war.camp.hp.pre_battle_panel.009")
	);
	parser:add_record("campaign_pre_battle_panel", "script_link_campaign_pre_battle_panel", "tooltip_campaign_pre_battle_panel");
	tp_pre_battle_panel = tooltip_patcher:new("tooltip_campaign_pre_battle_panel");
	tp_pre_battle_panel:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_pre_battle_panel", "ui_text_replacements_localised_text_hp_campaign_description_pre_battle_panel");
	
	tl_pre_battle_panel = tooltip_listener:new(
		"tooltip_campaign_pre_battle_panel", 
		function() 
			uim:highlight_pre_battle_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- pre_battle_panel_link
	--
	
	parser:add_record("campaign_pre_battle_panel_link", "script_link_campaign_pre_battle_panel_link", "tooltip_campaign_pre_battle_panel_link");
	tp_pre_battle_panel = tooltip_patcher:new("tooltip_campaign_pre_battle_panel_link");
	tp_pre_battle_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_pre_battle_panel_link");
	
	tl_pre_battle_panel_link = tooltip_listener:new(
		"tooltip_campaign_pre_battle_panel_link",
		function()
			uim:highlight_pre_battle_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- proliferate_cults_button
	--

	parser:add_record("campaign_proliferate_cults_button", "script_link_campaign_proliferate_cults_button", "tooltip_campaign_proliferate_cults_button");
	tp_proliferate_cults_button = tooltip_patcher:new("tooltip_campaign_proliferate_cults_button");
	tp_proliferate_cults_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_proliferate_cults_button");
	
	tl_proliferate_cults_button = tooltip_listener:new(
		"tooltip_campaign_proliferate_cults_button", 
		function() 
			uim:highlight_proliferate_cults(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- province_info_panel
	--

	hp_province_info_panel = help_page:new(
		"script_link_campaign_province_info_panel",
		hpr_title("war.camp.hp.province_info_panel.001"),
		hpr_leader("war.camp.hp.province_info_panel.002"),
		hpr_normal("war.camp.hp.province_info_panel.003"),
		hpr_normal("war.camp.hp.province_info_panel.004"),
		hpr_normal("war.camp.hp.province_info_panel.005"),
		hpr_normal("war.camp.hp.province_info_panel.007")
	);
	parser:add_record("campaign_province_info_panel", "script_link_campaign_province_info_panel", "tooltip_campaign_province_info_panel");
	tp_province_info_panel = tooltip_patcher:new("tooltip_campaign_province_info_panel");
	tp_province_info_panel:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_province_info_panel", "ui_text_replacements_localised_text_hp_campaign_description_province_info_panel");
	
	tl_province_info_panel = tooltip_listener:new(
		"tooltip_campaign_province_info_panel", 
		function()
			uim:highlight_province_info_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end	
	);
	
	
	
	--
	-- province_info_panel_link
	--
	
	parser:add_record("campaign_province_info_panel_link", "script_link_campaign_province_info_panel_link", "tooltip_campaign_province_info_panel_link");
	tp_province_info_panel = tooltip_patcher:new("tooltip_campaign_province_info_panel_link");
	tp_province_info_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_province_info_panel_link");
	
	tl_province_info_panel_link = tooltip_listener:new(
		"tooltip_campaign_province_info_panel_link",
		function()
			uim:highlight_province_info_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- provinces_list
	--
	
	parser:add_record("campaign_provinces_list", "script_link_campaign_provinces_list", "tooltip_campaign_provinces_list");
	tp_provinces_list = tooltip_patcher:new("tooltip_campaign_provinces_list");
	tp_provinces_list:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_provinces_list");
	
	tl_provinces_list = tooltip_listener:new(
		"tooltip_campaign_provinces_list",
		function()
			uim:highlight_provinces_list(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	


	--
	-- province_management
	--

	hp_province_management = help_page:new(
		"script_link_campaign_province_management",
		hpr_title("war.camp.hp.province_management.001"),
		hpr_leader("war.camp.hp.province_management.002"),
		hpr_normal("war.camp.hp.province_management.003"),
		hpr_normal("war.camp.hp.province_management.004"),
		hpr_normal("war.camp.hp.province_management.005"),
		hpr_normal("war.camp.hp.province_management.006"),
		hpr_normal("war.camp.hp.province_management.007"),
		hpr_normal("war.camp.hp.province_management.009")
	);
	parser:add_record("campaign_province_management", "script_link_campaign_province_management", "tooltip_campaign_province_management");
	tp_province_management = tooltip_patcher:new("tooltip_campaign_province_management");
	tp_province_management:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_province_management", "ui_text_replacements_localised_text_hp_campaign_description_province_management");


	--
	-- province_overview_panel
	--

	hp_province_overview_panel = help_page:new(
		"script_link_campaign_province_overview_panel",
		hpr_title("war.camp.hp.province_overview_panel.001"),
		hpr_leader("war.camp.hp.province_overview_panel.002"),
		hpr_normal("war.camp.hp.province_overview_panel.003"),
		hpr_normal("war.camp.hp.province_overview_panel.004"),
		hpr_normal("war.camp.hp.province_overview_panel.005")
	);
	parser:add_record("campaign_province_overview_panel", "script_link_campaign_province_overview_panel", "tooltip_campaign_province_overview_panel");
	tp_province_overview_panel = tooltip_patcher:new("tooltip_campaign_province_overview_panel");
	tp_province_overview_panel:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_province_overview_panel", "ui_text_replacements_localised_text_hp_campaign_description_province_overview_panel");
	
	tl_province_overview_panel = tooltip_listener:new(
		"tooltip_campaign_province_overview_panel", 
		function() 
			uim:highlight_province_overview_panel(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- province_overview_panel_link
	--
	
	parser:add_record("campaign_province_overview_panel_link", "script_link_campaign_province_overview_panel_link", "tooltip_campaign_province_overview_panel_link");
	tp_province_overview_panel = tooltip_patcher:new("tooltip_campaign_province_overview_panel_link");
	tp_province_overview_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_province_overview_panel_link");
	
	tl_province_overview_panel_link = tooltip_listener:new(
		"tooltip_campaign_province_overview_panel_link",
		function()
			uim:highlight_province_overview_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- provinces
	--

	hp_provinces = help_page:new(
		"script_link_campaign_provinces",
		hpr_title("war.camp.hp.provinces.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/provinces.png"),
		hpr_leader("war.camp.hp.provinces.002"),
		hpr_normal("war.camp.hp.provinces.003"),
		hpr_normal("war.camp.hp.provinces.004"),
		hpr_normal("war.camp.hp.provinces.005"),
		hpr_normal("war.camp.hp.provinces.006")
	);
	parser:add_record("campaign_provinces", "script_link_campaign_provinces", "tooltip_campaign_provinces");
	tp_provinces = tooltip_patcher:new("tooltip_campaign_provinces");
	tp_provinces:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_provinces",
		"ui_text_replacements_localised_text_hp_campaign_description_provinces",
		"UI/help_images/provinces.png"
	);



	--
	-- public_order
	--

	hp_public_order = help_page:new(
		"script_link_campaign_public_order",
		hpr_title("war.camp.hp.public_order.001"),
		hpr_leader("war.camp.hp.public_order.002"),
		hpr_normal("war.camp.hp.public_order.003"),
		hpr_normal("war.camp.hp.public_order.004"),
		hpr_normal("war.camp.hp.public_order.005"),
		hpr_normal("war.camp.hp.public_order.006")
	);
	parser:add_record("campaign_public_order", "script_link_campaign_public_order", "tooltip_campaign_public_order");
	tp_public_order = tooltip_patcher:new("tooltip_campaign_public_order");
	tp_public_order:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_public_order", "ui_text_replacements_localised_text_hp_campaign_description_public_order");
	
	tl_public_order = tooltip_listener:new(
		"tooltip_campaign_public_order", 
		function() 
			uim:highlight_public_order(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- public_order_bar
	--

	parser:add_record("campaign_public_order_bar", "script_link_campaign_public_order_bar", "tooltip_campaign_public_order_bar");
	tp_public_order_bar = tooltip_patcher:new("tooltip_campaign_public_order_bar");
	tp_public_order_bar:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_public_order_bar");
	
	tl_public_order_bar = tooltip_listener:new(
		"tooltip_campaign_public_order_bar", 
		function() 
			uim:highlight_public_order_bar(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- public_order_icon
	--

	parser:add_record("campaign_public_order_icon", "script_link_campaign_public_order_icon", "tooltip_campaign_public_order_icon");
	tp_public_order_icon = tooltip_patcher:new("tooltip_campaign_public_order_icon");
	tp_public_order_icon:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_public_order_icon");
	
	tl_public_order_icon = tooltip_listener:new(
		"tooltip_campaign_public_order_icon", 
		function() 
			uim:highlight_public_order_icon(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);	
	
	
	--
	-- public_order_link
	--
	
	parser:add_record("campaign_public_order_link", "script_link_campaign_public_order_link", "tooltip_campaign_public_order_link");
	tp_public_order = tooltip_patcher:new("tooltip_campaign_public_order_link");
	tp_public_order:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_public_order_link");
	
	tl_public_order_link = tooltip_listener:new(
		"tooltip_campaign_public_order_link",
		function()
			uim:highlight_public_order(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- quests
	--

	hp_quests = help_page:new(
		"script_link_campaign_quests",
		hpr_title("war.camp.hp.quests.001"),
		hpr_leader("war.camp.hp.quests.002"),
		hpr_normal("war.camp.hp.quests.003"),
		hpr_normal("war.camp.hp.quests.004"),
		hpr_normal("war.camp.hp.quests.005"),
		hpr_normal("war.camp.hp.quests.006")
	);
	
	parser:add_record("campaign_quests", "script_link_campaign_quests", "tooltip_campaign_quests");
	tp_quests = tooltip_patcher:new("tooltip_campaign_quests");
	tp_quests:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_quests", "ui_text_replacements_localised_text_hp_campaign_description_quests");

	tl_quests = tooltip_listener:new(
		"tooltip_campaign_quests",
		function()
			uim:highlight_character_details_panel_quests_button(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);


	
	--
	-- races
	--

	hp_races = help_page:new(
		"script_link_campaign_races",
		hpr_title("war.camp.hp.races.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/races.png"),
		hpr_leader("war.camp.hp.races.002"),
		hpr_normal("war.camp.hp.races.003"),
		hpr_normal("war.camp.hp.races.004"),
		hpr_normal("war.camp.hp.races.005")
	);
	parser:add_record("campaign_races", "script_link_campaign_races", "tooltip_campaign_races");
	tp_races = tooltip_patcher:new("tooltip_campaign_races");
	tp_races:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_races",
		"ui_text_replacements_localised_text_hp_campaign_description_races",
		"UI/help_images/races.png"
	);



	--
	-- raiding
	--

	hp_raiding = help_page:new(
		"script_link_campaign_raiding",
		hpr_title("war.camp.hp.raiding.001"),
		hpr_leader("war.camp.hp.raiding.002"),
		hpr_normal("war.camp.hp.raiding.003"),
		hpr_normal("war.camp.hp.raiding.004")
	);
	parser:add_record("campaign_raiding", "script_link_campaign_raiding", "tooltip_campaign_raiding");
	tp_raiding = tooltip_patcher:new("tooltip_campaign_raiding");
	tp_raiding:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_raiding", "ui_text_replacements_localised_text_hp_campaign_description_raiding");


	
	--
	-- raise_forces_button
	--

	parser:add_record("campaign_raise_forces_button", "script_link_campaign_raise_forces_button", "tooltip_campaign_raise_forces_button");
	tp_raise_forces_button = tooltip_patcher:new("tooltip_campaign_raise_forces_button");
	tp_raise_forces_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_raise_forces_button");
	
	tl_raise_forces_button = tooltip_listener:new(
		"tooltip_campaign_raise_forces_button", 
		function() 
			uim:highlight_raise_forces_button(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- raise_dead_button
	--
	
	parser:add_record("campaign_raise_dead_button", "script_link_campaign_raise_dead_button", "tooltip_campaign_raise_dead_button");
	tp_raise_dead_button = tooltip_patcher:new("tooltip_campaign_raise_dead_button");
	tp_raise_dead_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_raise_dead_button");
	
	tl_raise_dead_button = tooltip_listener:new(
		"tooltip_campaign_raise_dead_button",
		function()
			uim:highlight_raise_dead_button(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- raise_forces_panel
	--
	
	parser:add_record("campaign_raise_forces_panel", "script_link_campaign_raise_forces_panel", "tooltip_campaign_raise_forces_panel");
	tp_raise_forces_panel = tooltip_patcher:new("tooltip_campaign_raise_forces_panel");
	tp_raise_forces_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_raise_forces_panel");
	
	tl_raise_forces_panel = tooltip_listener:new(
		"tooltip_campaign_raise_forces_panel",
		function()
			uim:highlight_raise_forces_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- raising_forces
	--

	hp_raising_forces = help_page:new(
		"script_link_campaign_raising_forces",
		hpr_title("war.camp.hp.raising_forces.001"),
		hpr_leader("war.camp.hp.raising_forces.002"),
		hpr_normal("war.camp.hp.raising_forces.003"),
		hpr_normal("war.camp.hp.raising_forces.004"),
		hpr_normal("war.camp.hp.raising_forces.005")
	);
	parser:add_record("campaign_raising_forces", "script_link_campaign_raising_forces", "tooltip_campaign_raising_forces");
	tp_raising_forces = tooltip_patcher:new("tooltip_campaign_raising_forces");
	tp_raising_forces:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_raising_forces", "ui_text_replacements_localised_text_hp_campaign_description_raising_forces");

	tl_raising_forces = tooltip_listener:new(
		"tooltip_campaign_raising_forces", 
		function() 
			uim:highlight_raise_forces_panel(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- raising_forces_link
	--
	
	parser:add_record("campaign_raising_forces_link", "script_link_campaign_raising_forces_link", "tooltip_campaign_raising_forces_link");
	tp_raising_forces = tooltip_patcher:new("tooltip_campaign_raising_forces_link");
	tp_raising_forces:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_raising_forces_link");
	
	tl_raising_forces_link = tooltip_listener:new(
		"tooltip_campaign_raising_forces_link",
		function()
			uim:highlight_raise_forces_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	


	--
	-- raising_dead
	--
	
	hp_raising_dead = help_page:new(
		"script_link_campaign_raising_dead",
		hpr_title("war.camp.hp.raising_dead.001"),
		hpr_leader("war.camp.hp.raising_dead.002"),
		hpr_normal("war.camp.hp.raising_dead.003"),
		hpr_normal("war.camp.hp.raising_dead.004"),
		hpr_normal("war.camp.hp.raising_dead.005"),
		hpr_normal("war.camp.hp.raising_dead.006"),
		hpr_normal("war.camp.hp.raising_dead.007")
	);
	parser:add_record("campaign_raising_dead", "script_link_campaign_raising_dead", "tooltip_campaign_raising_dead");
	tp_raising_dead = tooltip_patcher:new("tooltip_campaign_raising_dead");
	tp_raising_dead:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_raising_dead", "ui_text_replacements_localised_text_hp_campaign_description_raising_dead");
	
	tl_raising_dead = tooltip_listener:new(
		"tooltip_campaign_raising_dead", 
		function() 
			uim:highlight_raise_dead_panel(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- raising_dead_link
	--
	
	parser:add_record("campaign_raising_dead_link", "script_link_campaign_raising_dead_link", "tooltip_campaign_raising_dead_link");
	tp_raising_dead = tooltip_patcher:new("tooltip_campaign_raising_dead_link");
	tp_raising_dead:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_raising_dead_link");
	
	tl_raising_dead_link = tooltip_listener:new(
		"tooltip_campaign_raising_dead_link",
		function()
			uim:highlight_raise_dead_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- rampage
	--

	hp_rampage = help_page:new(
		"script_link_campaign_rampage",
		hpr_title("war.camp.hp.rampage.001"),
		hpr_leader("war.camp.hp.rampage.002"),
		hpr_normal("war.camp.hp.rampage.003"),
		hpr_normal("war.camp.hp.rampage.004"),
		hpr_normal("war.camp.hp.rampage.005"),
		hpr_normal("war.camp.hp.rampage.006"),
		hpr_normal("war.camp.hp.rampage.007")
	);
	parser:add_record("campaign_rampage", "script_link_campaign_rampage", "tooltip_campaign_rampage");
	tp_rampage = tooltip_patcher:new("tooltip_campaign_rampage");
	tp_rampage:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_rampage", "ui_text_replacements_localised_text_hp_campaign_description_rampage");

	
	--
	-- razing
	--
	
	hp_razing = help_page:new(
		"script_link_campaign_razing",
		hpr_title("war.camp.hp.razing.001"),
		hpr_leader("war.camp.hp.razing.002"),
		hpr_normal("war.camp.hp.razing.003"),
		hpr_normal("war.camp.hp.razing.004"),
		hpr_normal("war.camp.hp.razing.005"),
		hpr_normal("war.camp.hp.razing.007")
	);
	parser:add_record("campaign_razing", "script_link_campaign_razing", "tooltip_campaign_razing");
	tp_razing = tooltip_patcher:new("tooltip_campaign_razing");
	tp_razing:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_razing", "ui_text_replacements_localised_text_hp_campaign_description_razing");



	--
	-- realm_of_chaos
	--

	hp_realm_of_chaos = help_page:new(
		"script_link_campaign_realm_of_chaos",
		hpr_title("war.camp.hp.realm_of_chaos.001"),
		hpr_leader("war.camp.hp.realm_of_chaos.002"),
		hpr_normal("war.camp.hp.realm_of_chaos.003"),
		hpr_normal("war.camp.hp.realm_of_chaos.004"),
		hpr_normal("war.camp.hp.realm_of_chaos.005"),

		hpr_section("khorne"),
		hpr_normal_unfaded("war.camp.hp.realm_of_chaos.006", "khorne"),
		hpr_normal("war.camp.hp.realm_of_chaos.007", "khorne"),

		hpr_section("nurgle"),
		hpr_normal_unfaded("war.camp.hp.realm_of_chaos.008", "nurgle"),
		hpr_normal("war.camp.hp.realm_of_chaos.009", "nurgle"),
		hpr_normal("war.camp.hp.realm_of_chaos.010", "nurgle"),

		hpr_section("slaanesh"),
		hpr_normal_unfaded("war.camp.hp.realm_of_chaos.011", "slaanesh"),
		hpr_normal("war.camp.hp.realm_of_chaos.012", "slaanesh"),

		hpr_section("tzeentch"),
		hpr_normal_unfaded("war.camp.hp.realm_of_chaos.013", "tzeentch"),
		hpr_normal("war.camp.hp.realm_of_chaos.014", "tzeentch")
	);
	parser:add_record("campaign_realm_of_chaos", "script_link_campaign_realm_of_chaos", "tooltip_campaign_realm_of_chaos");
	tp_realm_of_chaos = tooltip_patcher:new("tooltip_campaign_realm_of_chaos");
	tp_realm_of_chaos:set_layout_data(
		"tooltip_title_and_text",
		"ui_text_replacements_localised_text_hp_campaign_title_realm_of_chaos",
		"ui_text_replacements_localised_text_hp_campaign_description_realm_of_chaos"
	);
	
	
	
	--
	-- recruit_black_ark_button
	--
	
	parser:add_record("campaign_recruit_black_ark_button", "script_link_campaign_recruit_black_ark_button", "tooltip_campaign_recruit_black_ark_button");
	tp_recruit_black_ark_button = tooltip_patcher:new("tooltip_campaign_recruit_black_ark_button");
	tp_recruit_black_ark_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_recruit_black_ark_button");
	
	tl_recruit_black_ark_button = tooltip_listener:new(
		"tooltip_campaign_recruit_black_ark_button",
		function()
			uim:highlight_recruit_black_ark_button(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- recruit_hero_panel
	--

	hp_recruit_hero_panel = help_page:new(
		"script_link_campaign_recruit_hero_panel",
		hpr_title("war.camp.hp.recruit_hero_panel.001"),
		hpr_leader("war.camp.hp.recruit_hero_panel.002"),
		hpr_normal("war.camp.hp.recruit_hero_panel.003"),
		hpr_normal("war.camp.hp.recruit_hero_panel.004"),
		hpr_normal("war.camp.hp.recruit_hero_panel.005")
	);
	parser:add_record("campaign_recruit_hero_panel", "script_link_campaign_recruit_hero_panel", "tooltip_campaign_recruit_hero_panel");
	tp_recruit_hero_panel = tooltip_patcher:new("tooltip_campaign_recruit_hero_panel");
	tp_recruit_hero_panel:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_recruit_hero_panel", "ui_text_replacements_localised_text_hp_campaign_description_recruit_hero_panel");

	tl_recruit_hero_panel = tooltip_listener:new(
		"tooltip_campaign_recruit_hero_panel",
		function()
			uim:highlight_hero_recruitment_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- recruit_hero_panel_link
	--
	
	parser:add_record("campaign_recruit_hero_panel_link", "script_link_campaign_recruit_hero_panel_link", "tooltip_campaign_recruit_hero_panel_link");
	tp_recruit_hero_panel = tooltip_patcher:new("tooltip_campaign_recruit_hero_panel_link");
	tp_recruit_hero_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_recruit_hero_panel_link");
	
	tl_recruit_hero_panel_link = tooltip_listener:new(
		"tooltip_campaign_recruit_hero_panel_link",
		function()
			uim:highlight_hero_recruitment_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	

	
	--
	-- recruitment_capacity
	--
	
	parser:add_record("campaign_recruitment_capacity", "script_link_campaign_recruitment_capacity", "tooltip_campaign_recruitment_capacity");
	tp_recruitment_capacity = tooltip_patcher:new("tooltip_campaign_recruitment_capacity");
	tp_recruitment_capacity:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_recruitment_capacity");
	
	tl_recruitment_capacity = tooltip_listener:new(
		"tooltip_campaign_recruitment_capacity",
		function()
			uim:highlight_recruitment_capacity(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- regiments_of_renown
	--

	hp_regiments_of_renown = help_page:new(
		"script_link_campaign_regiments_of_renown",
		hpr_title("war.camp.hp.regiments_of_renown.001"),
		hpr_leader("war.camp.hp.regiments_of_renown.002"),
		hpr_normal("war.camp.hp.regiments_of_renown.003"),
		hpr_normal("war.camp.hp.regiments_of_renown.004"),
		hpr_normal("war.camp.hp.regiments_of_renown.005")
	);
	parser:add_record("campaign_regiments_of_renown", "script_link_campaign_regiments_of_renown", "tooltip_campaign_regiments_of_renown");
	tp_regiments_of_renown = tooltip_patcher:new("tooltip_campaign_regiments_of_renown");
	tp_regiments_of_renown:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_regiments_of_renown", "ui_text_replacements_localised_text_hp_campaign_description_regiments_of_renown");
	
	tl_regiments_of_renown = tooltip_listener:new(
		"tooltip_campaign_regiments_of_renown", 
		function()
			uim:highlight_regiments_of_renown_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- regiments_of_renown_link
	--
	
	parser:add_record("campaign_regiments_of_renown_link", "script_link_campaign_regiments_of_renown_link", "tooltip_campaign_regiments_of_renown_link");
	tp_regiments_of_renown_link = tooltip_patcher:new("tooltip_campaign_regiments_of_renown_link");
	tp_regiments_of_renown_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_regiments_of_renown_panel_link");
	
	tl_regiments_of_renown_link = tooltip_listener:new(
		"tooltip_campaign_regiments_of_renown_link", 
		function()
			uim:highlight_regiments_of_renown_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- regiments_of_renown_panel
	--

	parser:add_record("campaign_regiments_of_renown_panel", "script_panel_campaign_regiments_of_renown_panel", "tooltip_campaign_regiments_of_renown_panel");
	tp_regiments_of_renown_panel = tooltip_patcher:new("tooltip_campaign_regiments_of_renown_panel");
	tp_regiments_of_renown_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_regiments_of_renown_panel_link");
	
	tl_regiments_of_renown_panel = tooltip_listener:new(
		"tooltip_campaign_regiments_of_renown_panel", 
		function()
			uim:highlight_regiments_of_renown_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- region_trading
	--

	hp_region_trading = help_page:new(
		"script_link_campaign_region_trading",
		hpr_title("war.camp.hp.region_trading.001"),
		hpr_leader("war.camp.hp.region_trading.002"),
		hpr_normal("war.camp.hp.region_trading.003"),
		hpr_normal("war.camp.hp.region_trading.004"),
		hpr_normal("war.camp.hp.region_trading.005")
	);
	parser:add_record("campaign_region_trading", "script_link_campaign_region_trading", "tooltip_campaign_region_trading");
	tp_region_trading = tooltip_patcher:new("tooltip_campaign_region_trading");
	tp_region_trading:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_region_trading", "ui_text_replacements_localised_text_hp_campaign_description_region_trading");

	tl_region_trading = tooltip_listener:new(
		"tooltip_campaign_region_trading",
		function()
			uim:highlight_region_trading(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
		
	
	
	--
	-- reinforcements
	--

	hp_reinforcements = help_page:new(
		"script_link_campaign_reinforcements",
		hpr_title("war.camp.hp.reinforcements.001"),
		hpr_leader("war.camp.hp.reinforcements.002"),
		hpr_normal("war.camp.hp.reinforcements.003"),
		hpr_normal("war.camp.hp.reinforcements.004"),
		hpr_normal("war.camp.hp.reinforcements.005")
	);
	parser:add_record("campaign_reinforcements", "script_link_campaign_reinforcements", "tooltip_campaign_reinforcements");
	tp_reinforcements = tooltip_patcher:new("tooltip_campaign_reinforcements");
	tp_reinforcements:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_reinforcements", "ui_text_replacements_localised_text_hp_campaign_description_reinforcements");
	
	tl_reinforcements = tooltip_listener:new(
		"tooltip_campaign_reinforcements", 
		function()
			uim:highlight_reinforcements(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- reinforcements_link
	--
	
	parser:add_record("campaign_reinforcements_link", "script_link_campaign_reinforcements_link", "tooltip_campaign_reinforcements_link");
	tp_reinforcements_link = tooltip_patcher:new("tooltip_campaign_reinforcements_link");
	tp_reinforcements_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_reinforcements_link");
	
	tl_reinforcements_link = tooltip_listener:new(
		"tooltip_campaign_reinforcements_link", 
		function()
			uim:highlight_reinforcements(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- resources
	--

	hp_resources = help_page:new(
		"script_link_campaign_resources",
		hpr_title("war.camp.hp.resources.001"),
		hpr_leader("war.camp.hp.resources.002"),
		hpr_normal("war.camp.hp.resources.003"),
		hpr_normal("war.camp.hp.resources.004"),
		hpr_normal("war.camp.hp.resources.005"),
		hpr_normal("war.camp.hp.resources.006"),
		hpr_normal("war.camp.hp.resources.007")
	);
	parser:add_record("campaign_resources", "script_link_campaign_resources", "tooltip_campaign_resources");
	tp_resources = tooltip_patcher:new("tooltip_campaign_resources");
	tp_resources:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_resources", "ui_text_replacements_localised_text_hp_campaign_description_resources");
	
	tl_treasury_panel = tooltip_listener:new(
		"tooltip_campaign_resources", 
		function()
			uim:highlight_treasury_panel_trade_tab(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- revolts
	--

	hp_revolts = help_page:new(
		"script_link_campaign_revolts",
		hpr_title("war.camp.hp.revolts.001"),
		hpr_leader("war.camp.hp.revolts.002"),
		hpr_normal("war.camp.hp.revolts.003"),
		hpr_normal("war.camp.hp.revolts.004"),
		hpr_normal("war.camp.hp.revolts.005"),
		hpr_normal("war.camp.hp.revolts.006"),
		hpr_normal("war.camp.hp.revolts.008")
	);
	parser:add_record("campaign_revolts", "script_link_campaign_revolts", "tooltip_campaign_revolts");
	tp_revolts = tooltip_patcher:new("tooltip_campaign_revolts");
	tp_revolts:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_revolts", "ui_text_replacements_localised_text_hp_campaign_description_revolts");
	
	
	
	--
	-- rites
	--

	hp_rites = help_page:new(
		"script_link_campaign_rites",
		hpr_title("war.camp.hp.rites.001"),
		hpr_leader("war.camp.hp.rites.002"),
		hpr_normal("war.camp.hp.rites.003"),
		hpr_normal("war.camp.hp.rites.004")
	);
	parser:add_record("campaign_rites", "script_link_campaign_rites", "tooltip_campaign_rites");
	tp_rites = tooltip_patcher:new("tooltip_campaign_rites");
	tp_rites:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_rites", "ui_text_replacements_localised_text_hp_campaign_description_rites");
	
	
	
	--
	-- rites_button
	--
	
	parser:add_record("campaign_rites_button", "script_link_campaign_rites_button", "tooltip_campaign_rites_button");
	tp_rites_button = tooltip_patcher:new("tooltip_campaign_rites_button");
	tp_rites_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_rites_button");
	
	tl_rites_button = tooltip_listener:new(
		"tooltip_campaign_rites",
		function()
			uim:highlight_rites_button(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- rites_panel
	--
	
	parser:add_record("campaign_rites_panel", "script_link_campaign_rites_panel", "tooltip_campaign_rites_panel");
	tp_rites_panel = tooltip_patcher:new("tooltip_campaign_rites_panel");
	tp_rites_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_rites_panel");
	
	tl_rites_panel = tooltip_listener:new(
		"tooltip_campaign_rites_panel",
		function()
			uim:highlight_rites_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- ritual_buttons
	--
	
	parser:add_record("campaign_ritual_buttons", "script_link_campaign_ritual_buttons", "tooltip_campaign_ritual_buttons");
	tp_ritual_buttons = tooltip_patcher:new("tooltip_campaign_ritual_buttons");
	tp_ritual_buttons:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_ritual_buttons");
	
	tl_ritual_buttons = tooltip_listener:new(
		"tooltip_campaign_ritual_buttons",
		function()
			uim:highlight_ritual_buttons(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- ritual_currency
	--

	hp_ritual_currency = help_page:new(
		"script_link_campaign_ritual_currency",
		hpr_title("war.camp.hp.ritual_currency.001"),
		hpr_leader("war.camp.hp.ritual_currency.002"),
		hpr_normal("war.camp.hp.ritual_currency.003"),
		hpr_normal("war.camp.hp.ritual_currency.004"),
		hpr_normal("war.camp.hp.ritual_currency.005"),
		hpr_normal("war.camp.hp.ritual_currency.006"),
		hpr_normal("war.camp.hp.ritual_currency.007")
	);
	parser:add_record("campaign_ritual_currency", "script_link_campaign_ritual_currency", "tooltip_campaign_ritual_currency");
	tp_ritual_currency = tooltip_patcher:new("tooltip_campaign_ritual_currency");
	tp_ritual_currency:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_ritual_currency", "ui_text_replacements_localised_text_hp_campaign_description_ritual_currency");
	
	
	
	--
	-- ritual_resource_sites
	--

	hp_ritual_resource_sites = help_page:new(
		"script_link_campaign_ritual_resource_sites",
		hpr_title("war.camp.hp.ritual_resource_sites.001"),
		hpr_normal("war.camp.hp.ritual_resource_sites.002"),
		hpr_bulleted("war.camp.hp.ritual_resource_sites.003")
	);
	parser:add_record("campaign_ritual_resource_sites", "script_link_campaign_ritual_resource_sites", "tooltip_campaign_ritual_resource_sites");
	tp_ritual_resource_sites = tooltip_patcher:new("tooltip_campaign_ritual_resource_sites");
	tp_ritual_resource_sites:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_ritual_resource_sites", "ui_text_replacements_localised_text_hp_campaign_description_ritual_resource_sites");
	
	
	
	--
	-- ritual_rival_icons
	--
	
	parser:add_record("campaign_ritual_rival_icons", "script_link_campaign_ritual_rival_icons", "tooltip_campaign_ritual_rival_icons");
	tp_ritual_rival_icons = tooltip_patcher:new("tooltip_campaign_ritual_rival_icons");
	tp_ritual_rival_icons:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_ritual_rival_icons");
	
	tl_ritual_rival_icons = tooltip_listener:new(
		"tooltip_campaign_ritual_rival_icons",
		function()
			uim:highlight_ritual_rival_icons(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- rituals
	--

	hp_rituals = help_page:new(
		"script_link_campaign_rituals",
		hpr_title("war.camp.hp.rituals.001"),
		hpr_leader("war.camp.hp.rituals.002"),
		hpr_normal("war.camp.hp.rituals.003"),
		hpr_normal("war.camp.hp.rituals.004"),
		hpr_normal("war.camp.hp.rituals.005"),
		hpr_normal("war.camp.hp.rituals.006"),
		hpr_normal("war.camp.hp.rituals.007")
	);
	parser:add_record("campaign_rituals", "script_link_campaign_rituals", "tooltip_campaign_rituals");
	tp_rituals = tooltip_patcher:new("tooltip_campaign_rituals");
	tp_rituals:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_rituals", "ui_text_replacements_localised_text_hp_campaign_description_rituals");
	
	
	
	--
	-- rituals_bar
	--

	hp_rituals_bar = help_page:new(
		"script_link_campaign_rituals_bar",
		hpr_title("war.camp.hp.rituals_bar.001"),
		hpr_leader("war.camp.hp.rituals_bar.002"),
		hpr_normal("war.camp.hp.rituals_bar.003"),
		hpr_normal("war.camp.hp.rituals_bar.004"),
		hpr_normal("war.camp.hp.rituals_bar.005"),
		hpr_normal("war.camp.hp.rituals_bar.006"),
		hpr_normal("war.camp.hp.rituals_bar.007")
	);
	parser:add_record("campaign_rituals_bar", "script_link_campaign_rituals_bar", "tooltip_campaign_rituals_bar");
	tp_rituals_bar = tooltip_patcher:new("tooltip_campaign_rituals_bar");
	tp_rituals_bar:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_rituals_bar", "ui_text_replacements_localised_text_hp_campaign_description_rituals_bar");

	tl_rituals_bar = tooltip_listener:new(
		"tooltip_campaign_rituals_bar",
		function()
			uim:highlight_rituals_bar(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);

	
	
	--
	-- rituals_bar_link
	--
	
	parser:add_record("campaign_rituals_bar_link", "script_link_campaign_rituals_bar_link", "tooltip_campaign_rituals_bar_link");
	tp_rituals_bar_link = tooltip_patcher:new("tooltip_campaign_rituals_bar_link");
	tp_rituals_bar_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_rituals_bar_link");
	
	tl_rituals_bar_link = tooltip_listener:new(
		"tooltip_campaign_rituals_bar_link",
		function()
			uim:highlight_rituals_bar(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- rogue_armies
	--

	hp_rogue_armies = help_page:new(
		"script_link_campaign_rogue_armies",
		hpr_title("war.camp.hp.rogue_armies.001"),
		hpr_leader("war.camp.hp.rogue_armies.002"),
		hpr_normal("war.camp.hp.rogue_armies.003"),
		hpr_normal("war.camp.hp.rogue_armies.004")
	);
	parser:add_record("campaign_rogue_armies", "script_link_campaign_rogue_armies", "tooltip_campaign_rogue_armies");
	tp_rogue_armies = tooltip_patcher:new("tooltip_campaign_rogue_armies");
	tp_rogue_armies:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_rogue_armies", "ui_text_replacements_localised_text_hp_campaign_description_rogue_armies");


	--
	-- rogue_pirates
	--

	hp_rogue_pirates = help_page:new(
		"script_link_campaign_rogue_pirates",
		hpr_title("war.camp.hp.rogue_pirates.001"),
		hpr_leader("war.camp.hp.rogue_pirates.002"),
		hpr_normal("war.camp.hp.rogue_pirates.003"),
		hpr_normal("war.camp.hp.rogue_pirates.004"),
		hpr_normal("war.camp.hp.rogue_pirates.005"), 
		hpr_normal("war.camp.hp.rogue_pirates.006") 
	);
	parser:add_record("campaign_rogue_pirates", "script_link_campaign_rogue_pirates", "tooltip_campaign_rogue_pirates");
	tp_rogue_pirates = tooltip_patcher:new("tooltip_campaign_rogue_pirates");
	tp_rogue_pirates:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_rogue_pirates", "ui_text_replacements_localised_text_hp_campaign_description_rogue_pirates")

	
	--
	-- ruins
	--

	hp_ruins = help_page:new(
		"script_link_campaign_ruins",
		hpr_title("war.camp.hp.ruins.001"),
		hpr_leader("war.camp.hp.ruins.002"),
		hpr_normal("war.camp.hp.ruins.003"),
		hpr_normal("war.camp.hp.ruins.004"),
		hpr_normal("war.camp.hp.ruins.005")
	);
	parser:add_record("campaign_ruins", "script_link_campaign_ruins", "tooltip_campaign_ruins");
	tp_ruins = tooltip_patcher:new("tooltip_campaign_ruins");
	tp_ruins:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_ruins", "ui_text_replacements_localised_text_hp_campaign_description_ruins");
	

	--
	-- Sacrifice to Sotek
	--
	
	hp_sacrifice_to_sotek = help_page:new(
		"script_link_campaign_sacrifice_to_sotek",
		hpr_title("war.camp.hp.lizardmen_sacrifice_to_sotek.001"),
		hpr_leader("war.camp.hp.lizardmen_sacrifice_to_sotek.002"),
		hpr_normal("war.camp.hp.lizardmen_sacrifice_to_sotek.003"),
		hpr_normal("war.camp.hp.lizardmen_sacrifice_to_sotek.004"),
		hpr_normal("war.camp.hp.lizardmen_sacrifice_to_sotek.005"),
		hpr_normal("war.camp.hp.lizardmen_sacrifice_to_sotek.006"),
		hpr_normal("war.camp.hp.lizardmen_sacrifice_to_sotek.007")
	);
	parser:add_record("campaign_sacrifice_to_sotek", "script_link_campaign_sacrifice_to_sotek", "tooltip_campaign_sacrifice_to_sotek");
	tp_sacrifice_to_sotek = tooltip_patcher:new("tooltip_campaign_sacrifice_to_sotek");
	tp_sacrifice_to_sotek:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_lizardmen_sacrifice_to_sotek", "ui_text_replacements_localised_text_hp_campaign_description_lizardmen_sacrifice_to_sotek");
	
	tl_sacrifice_to_sotek = tooltip_listener:new(
		"tooltip_campaign_sacrifice_to_sotek", 
		function()
			-- script_error("WARNING: sacrifice_to_sotek help page link tooltip shown but no highlight script created for it");
			-- uim:highlight_sacrifice_to_sotek_button(true) 
		end,
		function() 
			uim:unhighlight_all_for_tooltips() 
		end
	);	
	
	--
	-- Sacrifice to Sotek Panel
	--
	
	parser:add_record("campaign_sacrifice_to_sotek_panel", "script_link_campaign_sacrifice_to_sotek_panel", "tooltip_campaign_sacrifice_to_sotek_panel");
	tp_sacrifice_to_sotek_panel = tooltip_patcher:new("tooltip_campaign_sacrifice_to_sotek_panel");
	tp_sacrifice_to_sotek_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_lizardmen_sacrifice_to_sotek_panel");
	
	tl_sacrifice_to_sotek_panel = tooltip_listener:new(
		"tooltip_campaign_sacrifice_to_sotek_panel",
		function()
			-- uim:highlight_sacrifice_to_sotek_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- salvage
	--
	
	hp_salvage = help_page:new(
		"script_link_campaign_salvage",
		hpr_title("war.camp.hp.greenskins_salvage.001"),
		hpr_leader("war.camp.hp.greenskins_salvage.002"),
		hpr_normal("war.camp.hp.greenskins_salvage.003"),
		hpr_normal("war.camp.hp.greenskins_salvage.004"),
		hpr_normal("war.camp.hp.greenskins_salvage.005")
	);
	parser:add_record("campaign_salvage", "script_link_campaign_salvage", "tooltip_campaign_salvage");
	tp_salvage = tooltip_patcher:new("tooltip_campaign_salvage");
	tp_salvage:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_greenskins_salvage", "ui_text_replacements_localised_text_hp_campaign_description_greenskins_salvage");
	
	
	
	--
	-- saving_and_loading
	--

	hp_saving_and_loading = help_page:new(
		"script_link_campaign_saving_and_loading",
		hpr_title("war.camp.hp.saving_and_loading.001"),
		hpr_leader("war.camp.hp.saving_and_loading.002"),
		hpr_normal("war.camp.hp.saving_and_loading.003"),
		hpr_normal("war.camp.hp.saving_and_loading.004"),
		hpr_normal("war.camp.hp.saving_and_loading.006")
	);
	parser:add_record("campaign_saving_and_loading", "script_link_campaign_saving_and_loading", "tooltip_campaign_saving_and_loading");
	tp_saving_and_loading = tooltip_patcher:new("tooltip_campaign_saving_and_loading");
	tp_saving_and_loading:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_saving_and_loading", "ui_text_replacements_localised_text_hp_campaign_description_saving_and_loading");

	
	
	--
	-- schemes
	--

	hp_schemes = help_page:new(
		"script_link_campaign_schemes",
		hpr_title("war.camp.hp.schemes.001"),
		hpr_leader("war.camp.hp.schemes.002"),
		hpr_normal("war.camp.hp.schemes.003"),
		hpr_normal("war.camp.hp.schemes.004"),
		hpr_normal("war.camp.hp.schemes.005"),
		hpr_normal("war.camp.hp.schemes.006")
	);
	parser:add_record("campaign_schemes", "script_link_campaign_schemes", "tooltip_campaign_schemes");
	tp_schemes = tooltip_patcher:new("tooltip_campaign_schemes");
	tp_schemes:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_schemes", "ui_text_replacements_localised_text_hp_campaign_description_schemes");



	--
	-- sea
	--

	hp_sea = help_page:new(
		"script_link_campaign_sea",
		hpr_title("war.camp.hp.sea.001"),
		hpr_leader("war.camp.hp.sea.002"),
		hpr_normal("war.camp.hp.sea.003"),
		hpr_normal("war.camp.hp.sea.004"),
		hpr_normal("war.camp.hp.sea.005"),
		hpr_normal("war.camp.hp.sea.006"),
		hpr_normal("war.camp.hp.sea.007"),
		hpr_normal("war.camp.hp.sea.008")
	);
	parser:add_record("campaign_sea", "script_link_campaign_sea", "tooltip_campaign_sea");
	tp_sea = tooltip_patcher:new("tooltip_campaign_sea");
	tp_sea:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_sea", "ui_text_replacements_localised_text_hp_campaign_description_sea");
	
	
	--
	-- sea lanes
	--

	hp_sea_lane = help_page:new(
		"script_link_campaign_sea_lanes",
		hpr_title("war.camp.hp.sea_lane.001"),
		hpr_leader("war.camp.hp.sea_lane.002"),
		hpr_normal("war.camp.hp.sea_lane.003"),
		hpr_normal("war.camp.hp.sea_lane.004")
	);
	parser:add_record("campaign_sea_lanes", "script_link_campaign_sea_lanes", "tooltip_campaign_sea_lanes");
	tp_sea_lane = tooltip_patcher:new("tooltip_campaign_sea_lanes");
	tp_sea_lane:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_sea_lanes", "ui_text_replacements_localised_text_hp_campaign_description_sea_lanes");

	
	--
	-- sea_shanties
	--

	hp_sea_shanties = help_page:new(
		"script_link_campaign_sea_shanties",
		hpr_title("war.camp.hp.sea_shanties.001"),
		hpr_leader("war.camp.hp.sea_shanties.002"),
		hpr_normal("war.camp.hp.sea_shanties.003"),
		hpr_normal("war.camp.hp.sea_shanties.004"),
		hpr_normal("war.camp.hp.sea_shanties.005"),
		hpr_normal("war.camp.hp.sea_shanties.006")
	);
	parser:add_record("campaign_sea_shanties", "script_link_campaign_sea_shanties", "tooltip_campaign_sea_shanties");
	tp_sea_shanties = tooltip_patcher:new("tooltip_campaign_sea_shanties");
	tp_sea_shanties:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_sea_shanties", "ui_text_replacements_localised_text_hp_campaign_description_sea_shanties");


	--
	-- seduce_units_button
	--

	parser:add_record("campaign_seduce_units_button", "script_link_campaign_seduce_units_button", "tooltip_campaign_seduce_units_button");
	tp_seduce_units_button = tooltip_patcher:new("tooltip_campaign_seduce_units_button");
	tp_seduce_units_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_seduce_units_button");
	
	tl_seduce_units_button = tooltip_listener:new(
		"tooltip_campaign_seduce_units_button", 
		function() 
			uim:highlight_seduce_units_button(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- seduction
	--

	hp_seduction = help_page:new(
		"script_link_campaign_seduction",
		hpr_title("war.camp.hp.seduction.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/seduction.png"),
		hpr_leader("war.camp.hp.seduction.002"),
		hpr_normal("war.camp.hp.seduction.003"),
		hpr_normal("war.camp.hp.seduction.004"),
		hpr_normal("war.camp.hp.seduction.005"),
		hpr_normal("war.camp.hp.seduction.006")
	);
	parser:add_record("campaign_seduction", "script_link_campaign_seduction", "tooltip_campaign_seduction");
	tp_seduction = tooltip_patcher:new("tooltip_campaign_seduction");
	tp_seduction:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_seduction",
		"ui_text_replacements_localised_text_hp_campaign_description_seduction",
		"UI/help_images/seduction.png"
	);

	tl_seduction = tooltip_listener:new(
		"tooltip_campaign_seduction", 
		function() 
			uim:highlight_seduce_units_button(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- seduction_link
	--

	parser:add_record("campaign_seduction_link", "script_link_campaign_seduction_link", "tooltip_campaign_seduction_link");
	tp_seduction_link = tooltip_patcher:new("tooltip_campaign_seduction_link");
	tp_seduction_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_seduction_link");
	
	tl_seduction_link = tooltip_listener:new(
		"tooltip_campaign_seduction_link",
		function()
			uim:highlight_seduce_units_button(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- seductive_influence
	--

	hp_seductive_influence = help_page:new(
		"script_link_campaign_seductive_influence",
		hpr_title("war.camp.hp.seductive_influence.001"),
		hpr_leader("war.camp.hp.seductive_influence.002"),
		hpr_normal("war.camp.hp.seductive_influence.003"),
		hpr_bulleted("war.camp.hp.seductive_influence.004"),
		hpr_bulleted("war.camp.hp.seductive_influence.005"),
		hpr_bulleted("war.camp.hp.seductive_influence.006"),
		hpr_bulleted("war.camp.hp.seductive_influence.007"),
		hpr_bulleted("war.camp.hp.seductive_influence.008"),
		hpr_normal("war.camp.hp.seductive_influence.009"),
		hpr_normal("war.camp.hp.seductive_influence.010"),
		hpr_normal("war.camp.hp.seductive_influence.011"),

		hpr_section("liberation"),
		hpr_normal_unfaded("war.camp.hp.seductive_influence.012", "liberation"),
		hpr_normal("war.camp.hp.seductive_influence.013", "liberation"),
		hpr_normal("war.camp.hp.seductive_influence.014", "liberation")
	);
	parser:add_record("campaign_seductive_influence", "script_link_campaign_seductive_influence", "tooltip_campaign_seductive_influence");
	tp_seductive_influence = tooltip_patcher:new("tooltip_campaign_seductive_influence");
	tp_seductive_influence:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_seductive_influence", "ui_text_replacements_localised_text_hp_campaign_description_seductive_influence");

	tp_seductive_influence = tooltip_listener:new(
		"tooltip_campaign_seductive_influence_link",
		function()
			uim:highlight_seductive_influence(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- seductive_influence_link
	--
	script_feature_name = "seductive_influence";
	parser:add_record("campaign_"..script_feature_name.."_link", "script_link_campaign_"..script_feature_name.."_link", "tooltip_campaign_"..script_feature_name.."_link");
	tp_seductive_influence_link = tooltip_patcher:new("tooltip_campaign_"..script_feature_name.."_link");
	tp_seductive_influence_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_"..script_feature_name.."_link");
	
	tl_seductive_influence_link = tooltip_listener:new(
		"tooltip_campaign_"..script_feature_name.."_link",
		function()
			uim:highlight_seductive_influence(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	--
	-- settlement_bars
	--
	
	parser:add_record("campaign_settlement_bars", "script_link_campaign_settlement_bars", "tooltip_campaign_settlement_bars");
	tp_settlement_bars = tooltip_patcher:new("tooltip_campaign_settlement_bars");
	tp_settlement_bars:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_settlement_bars");
	
	tl_settlement_bars = tooltip_listener:new(
		"tooltip_campaign_settlement_bars",
		function()
			-- uim:highlight_settlement_bars(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- settlement_climates
	--

	hp_settlement_climates = help_page:new(
		"script_link_campaign_settlement_climates",
		hpr_title("war.camp.hp.settlement_climates.001"),
		hpr_leader("war.camp.hp.settlement_climates.002"),
		hpr_normal("war.camp.hp.settlement_climates.003"),
		hpr_normal("war.camp.hp.settlement_climates.004")
	);
	parser:add_record("campaign_settlement_climates", "script_link_campaign_settlement_climates", "tooltip_campaign_settlement_climates");
	tp_settlement_climates = tooltip_patcher:new("tooltip_campaign_settlement_climates");
	tp_settlement_climates:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_settlement_climates", "ui_text_replacements_localised_text_hp_campaign_description_settlement_climates");



	--
	-- settlements
	--

	hp_settlements = help_page:new(
		"script_link_campaign_settlements",
		hpr_title("war.camp.hp.settlements.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/settlements.png"),
		hpr_leader("war.camp.hp.settlements.002"),
		hpr_normal("war.camp.hp.settlements.003"),
		hpr_normal("war.camp.hp.settlements.004"),
		hpr_normal("war.camp.hp.settlements.005"),
		hpr_normal("war.camp.hp.settlements.006"),
		hpr_normal("war.camp.hp.settlements.007"),
		hpr_normal("war.camp.hp.settlements.009")
	);
		
	parser:add_record("campaign_settlements", "script_link_campaign_settlements", "tooltip_campaign_settlements");
	tp_settlements = tooltip_patcher:new("tooltip_campaign_settlements");
	tp_settlements:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_settlements",
		"ui_text_replacements_localised_text_hp_campaign_description_settlements",
		"UI/help_images/settlements.png"
	);
	
	tl_settlements = tooltip_listener:new(
		"tooltip_campaign_settlements", 
		function()
			uim:highlight_settlements(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- settlements_link
	--
	
	parser:add_record("campaign_settlements_link", "script_link_campaign_settlements_link", "tooltip_campaign_settlements_link");
	tp_settlements_link = tooltip_patcher:new("tooltip_campaign_settlements_link");
	tp_settlements_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_settlements_link");
	
	tl_settlements_link = tooltip_listener:new(
		"tooltip_campaign_settlements_link",
		function()
			uim:highlight_settlements(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- settlement_types_link
	--
	
	parser:add_record("campaign_settlement_types_link", "script_link_campaign_settlement_types_link", "tooltip_campaign_settlement_types_link");
	tp_settlement_types = tooltip_patcher:new("tooltip_campaign_settlement_types_link");
	tp_settlement_types:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_settlement_types_link");
	
	tl_settlement_types = tooltip_listener:new(
		"tooltip_campaign_settlement_types_link",
		function()
			uim:highlight_settlements(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- shadowy_dealings
	--
	
	hp_shadowy_dealings = help_page:new(
		"script_link_campaign_skaven_shadowy_dealings",
		hpr_title("war.camp.hp.shadowy_dealings.001"),
		hpr_leader("war.camp.hp.shadowy_dealings.002"),
		hpr_normal("war.camp.hp.shadowy_dealings.003"),
		hpr_normal("war.camp.hp.shadowy_dealings.004"),
		hpr_normal("war.camp.hp.shadowy_dealings.005"),

		hpr_section("contracts"),
		hpr_normal_unfaded("war.camp.hp.shadowy_dealings.006", "contracts"),
		hpr_normal("war.camp.hp.shadowy_dealings.007", "contracts"),
		hpr_normal("war.camp.hp.shadowy_dealings.008", "contracts")
	);
	parser:add_record("campaign_skaven_shadowy_dealings", "script_link_campaign_skaven_shadowy_dealings", "tooltip_campaign_skaven_shadowy_dealings");
	tp_shadowy_dealings = tooltip_patcher:new("tooltip_campaign_skaven_shadowy_dealings");
	tp_shadowy_dealings:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_shadowy_dealings", "ui_text_replacements_localised_text_hp_campaign_description_shadowy_dealings");
	
	
	
	--
	-- ship_building
	--

	hp_ship_building = help_page:new(
		"script_link_campaign_ship_building",
		hpr_title("war.camp.hp.ship_building.001"),
		hpr_leader("war.camp.hp.ship_building.002"),
		hpr_normal("war.camp.hp.ship_building.003"),
		hpr_normal("war.camp.hp.ship_building.004"),
		hpr_normal("war.camp.hp.ship_building.005")
	);
	parser:add_record("campaign_ship_building", "script_link_campaign_ship_building", "tooltip_campaign_ship_building");
	tp_ship_building = tooltip_patcher:new("tooltip_campaign_ship_building");
	tp_ship_building:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_ship_building", "ui_text_replacements_localised_text_hp_campaign_description_ship_building");
	
	
	tl_ship_building = tooltip_listener:new(
		"tooltip_campaign_ship_building", 
		function()
			uim:highlight_ship_building_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end	
	);
	
	
	--
	-- ship_building_link
	--
	
	parser:add_record("campaign_ship_building_link", "script_link_campaign_ship_building_link", "tooltip_campaign_ship_building_link");
	tp_ship_building_link = tooltip_patcher:new("tooltip_campaign_ship_building_link");
	tp_ship_building_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_ship_building_link");
	
	tl_ship_building_link = tooltip_listener:new(
		"tooltip_campaign_ship_building_link",
		function()
			uim:highlight_ship_building_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	

	--
	-- siege_panel
	--

	hp_siege_panel = help_page:new(
		"script_link_campaign_siege_panel",
		hpr_title("war.camp.hp.siege_panel.001"),
		hpr_leader("war.camp.hp.siege_panel.002"),
		hpr_normal("war.camp.hp.siege_panel.003"),
		hpr_normal("war.camp.hp.siege_panel.004"),
		hpr_normal("war.camp.hp.siege_panel.005"),
		hpr_normal("war.camp.hp.siege_panel.006"),
		hpr_normal("war.camp.hp.siege_panel.007"),
		hpr_normal("war.camp.hp.siege_panel.009")
	);
	parser:add_record("campaign_siege_panel", "script_link_campaign_siege_panel", "tooltip_campaign_siege_panel");
	tp_siege_panel = tooltip_patcher:new("tooltip_campaign_siege_panel");
	tp_siege_panel:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_siege_panel", "ui_text_replacements_localised_text_hp_campaign_description_siege_panel");

	tl_siege_panel = tooltip_listener:new(
		"tooltip_campaign_siege_panel", 
		function() 
			uim:highlight_siege_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- siege_panel_link
	--
	
	parser:add_record("campaign_siege_panel_link", "script_link_campaign_siege_panel_link", "tooltip_campaign_siege_panel_link");
	tp_siege_panel = tooltip_patcher:new("tooltip_campaign_siege_panel_link");
	tp_siege_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_siege_panel_link");
	
	tl_siege_panel_link = tooltip_listener:new(
		"tooltip_campaign_siege_panel_link",
		function()
			uim:highlight_siege_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	


	--
	-- siege_warfare
	--

	hp_siege_warfare = help_page:new(
		"script_link_campaign_siege_warfare",
		hpr_title("war.camp.hp.siege_warfare.001"),
		hpr_leader("war.camp.hp.siege_warfare.002"),
		hpr_normal("war.camp.hp.siege_warfare.003"),
		hpr_normal("war.camp.hp.siege_warfare.004"),
		hpr_normal("war.camp.hp.siege_warfare.007"),
		hpr_normal("war.camp.hp.siege_warfare.005"),
		hpr_normal("war.camp.hp.siege_warfare.006")
	);
	parser:add_record("campaign_siege_warfare", "script_link_campaign_siege_warfare", "tooltip_campaign_siege_warfare");
	tp_siege_warfare = tooltip_patcher:new("tooltip_campaign_siege_warfare");
	tp_siege_warfare:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_siege_warfare", "ui_text_replacements_localised_text_hp_campaign_description_siege_warfare");



	--
	-- siege_weapons
	--

	hp_siege_weapons = help_page:new(
		"script_link_campaign_siege_weapons",
		hpr_title("war.camp.hp.siege_weapons.001"),
		hpr_leader("war.camp.hp.siege_weapons.002"),
		hpr_normal("war.camp.hp.siege_weapons.003"),
		hpr_normal("war.camp.hp.siege_weapons.004"),
		hpr_normal("war.camp.hp.siege_weapons.005"),
		hpr_normal("war.camp.hp.siege_weapons.006")
	);
	parser:add_record("campaign_siege_weapons", "script_link_campaign_siege_weapons", "tooltip_campaign_siege_weapons");
	tp_siege_weapons = tooltip_patcher:new("tooltip_campaign_siege_weapons");
	tp_siege_weapons:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_siege_weapons", "ui_text_replacements_localised_text_hp_campaign_description_siege_weapons");

	tl_siege_weapons = tooltip_listener:new(
		"tooltip_campaign_siege_weapons", 
		function() 
			uim:highlight_siege_weapons(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	--
	-- silent_sanctums
	--

	hp_silent_sanctums = help_page:new(
		"script_link_campaign_silent_sanctums",
		hpr_title("war.camp.hp.lizardmen_silent_sanctums.001"),
		hpr_leader("war.camp.hp.lizardmen_silent_sanctums.002"),
		hpr_normal("war.camp.hp.lizardmen_silent_sanctums.003"),
		hpr_normal("war.camp.hp.lizardmen_silent_sanctums.004"),
		hpr_normal("war.camp.hp.lizardmen_silent_sanctums.005"),
		hpr_normal("war.camp.hp.lizardmen_silent_sanctums.006"),
		hpr_normal("war.camp.hp.lizardmen_silent_sanctums.007")
	);
	parser:add_record("campaign_silent_sanctums", "script_link_campaign_silent_sanctums", "tooltip_campaign_silent_sanctums");
	tp_silent_sanctums = tooltip_patcher:new("tooltip_campaign_silent_sanctums");
	tp_silent_sanctums:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_silent_sanctums_title", "ui_text_replacements_localised_text_hp_campaign_silent_sanctums_description");
	
	
	
	--
	-- skaven
	--

	hp_skaven = help_page:new(
		"script_link_campaign_skaven",
		hpr_title("war.camp.hp.skaven.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/skaven.png"),
		hpr_leader("war.camp.hp.skaven.002"),
		hpr_normal("war.camp.hp.skaven.003"),
		hpr_normal("war.camp.hp.skaven.004"),
		hpr_normal("war.camp.hp.skaven.005"),
		hpr_normal("war.camp.hp.skaven.006"),
		hpr_normal("war.camp.hp.skaven.007"),
		hpr_normal("war.camp.hp.skaven.009")
	);
	parser:add_record("campaign_skaven", "script_link_campaign_skaven", "tooltip_campaign_skaven");
	tp_skaven = tooltip_patcher:new("tooltip_campaign_skaven");
	tp_skaven:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_skaven",
		"ui_text_replacements_localised_text_hp_campaign_description_skaven",
		"UI/help_images/skaven.png"
	);
	
	
	
	--
	-- skaven_corruption
	--

	hp_skaven_corruption = help_page:new(
		"script_link_campaign_skaven_corruption",
		hpr_title("war.camp.hp.skaven_corruption.001"),
		hpr_leader("war.camp.hp.skaven_corruption.002"),
		hpr_normal("war.camp.hp.skaven_corruption.003"),
		hpr_normal("war.camp.hp.skaven_corruption.004"),
		hpr_normal("war.camp.hp.skaven_corruption.005"),
		hpr_normal("war.camp.hp.skaven_corruption.007")
	);
	parser:add_record("campaign_skaven_corruption", "script_link_campaign_skaven_corruption", "tooltip_campaign_skaven_corruption");
	tp_skaven_corruption = tooltip_patcher:new("tooltip_campaign_skaven_corruption");
	tp_skaven_corruption:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_skaven_corruption", "ui_text_replacements_localised_text_hp_campaign_description_skaven_corruption");
	
	
	--
	-- skaven_loyalty
	--

	hp_skaven_loyalty = help_page:new(
		"script_link_campaign_skaven_loyalty",
		hpr_title("war.camp.hp.skaven_loyalty.001"),
		hpr_leader("war.camp.hp.skaven_loyalty.002"),
		hpr_normal("war.camp.hp.skaven_loyalty.003"),
		hpr_normal("war.camp.hp.skaven_loyalty.004"),
		hpr_normal("war.camp.hp.skaven_loyalty.005")
	);
	parser:add_record("campaign_skaven_loyalty", "script_link_campaign_skaven_loyalty", "tooltip_campaign_skaven_loyalty");
	tp_skaven_loyalty = tooltip_patcher:new("tooltip_campaign_skaven_loyalty");
	tp_skaven_loyalty:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_skaven_loyalty", "ui_text_replacements_localised_text_hp_campaign_description_skaven_loyalty");
	
	
	--
	-- skaven_underworld
	--

	hp_skaven_underworld = help_page:new(
		"script_link_campaign_skaven_underworld",
		hpr_title("war.camp.hp.skaven_underworld.001"),
		hpr_leader("war.camp.hp.skaven_underworld.002"),
		hpr_normal("war.camp.hp.skaven_underworld.003"),
		hpr_normal("war.camp.hp.skaven_underworld.004"),
		hpr_normal("war.camp.hp.skaven_underworld.005"),
		hpr_normal("war.camp.hp.skaven_underworld.006"),
		hpr_normal("war.camp.hp.skaven_underworld.007"),
		hpr_normal("war.camp.hp.skaven_underworld.008")
	);
	parser:add_record("campaign_skaven_underworld", "script_link_campaign_skaven_underworld", "tooltip_campaign_skaven_underworld");
	tp_skaven_underworld = tooltip_patcher:new("tooltip_campaign_skaven_underworld");
	tp_skaven_underworld:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_skaven_underworld", "ui_text_replacements_localised_text_hp_campaign_description_skaven_underworld");



	--
	-- skull_throne
	--

	parser:add_record("campaign_skull_throne", "script_link_campaign_skull_throne", "tooltip_campaign_skull_throne");
	tp_skull_throne = tooltip_patcher:new("tooltip_campaign_skull_throne");
	tp_skull_throne:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_skull_throne");
	
	tl_skull_throne = tooltip_listener:new(
		"tooltip_campaign_skull_throne", 
		function() 
			uim:highlight_skull_throne(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- skulls
	--

	hp_skulls = help_page:new(
		"script_link_campaign_skulls",
		hpr_title("war.camp.hp.skulls.001"),
		hpr_leader("war.camp.hp.skulls.002"),
		hpr_normal("war.camp.hp.skulls.003"),
		hpr_normal("war.camp.hp.skulls.004"),
		hpr_normal("war.camp.hp.skulls.005"),
		hpr_normal("war.camp.hp.skulls.006"),
		hpr_normal("war.camp.hp.skulls.007")
	);
	parser:add_record("campaign_skulls", "script_link_campaign_skulls", "tooltip_campaign_skulls");
	tp_skulls = tooltip_patcher:new("tooltip_campaign_skulls");
	tp_skulls:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_skulls", "ui_text_replacements_localised_text_hp_campaign_description_skulls");

	tl_skulls = tooltip_listener:new(
		"tooltip_campaign_skulls", 
		function() 
			uim:highlight_skulls_count(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- skulls_link
	--

	parser:add_record("campaign_skulls_link", "script_link_campaign_skulls_link", "tooltip_campaign_skulls_link");
	tp_skulls_link = tooltip_patcher:new("tooltip_campaign_skulls_link");
	tp_skulls_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_skulls_link");
	
	tl_skulls_link = tooltip_listener:new(
		"tooltip_campaign_skulls_link",
		function()
			uim:highlight_skulls_count(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- skulls_counter
	--

	parser:add_record("campaign_skulls_counter", "script_link_campaign_skulls_counter", "tooltip_campaign_skulls_counter");
	tp_skulls_counter = tooltip_patcher:new("tooltip_campaign_skulls_counter");
	tp_skulls_counter:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_skulls_counter");
	
	tl_skulls_counter = tooltip_listener:new(
		"tooltip_campaign_skulls_counter", 
		function() 
			uim:highlight_skulls_count(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- slaanesh
	--

	hp_slaanesh = help_page:new(
		"script_link_campaign_slaanesh",
		hpr_title("war.camp.hp.slaanesh.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/slaanesh.png"),
		hpr_leader("war.camp.hp.slaanesh.002"),

		hpr_section("seductive_influence"),
		hpr_normal_unfaded("war.camp.hp.slaanesh.003", "seductive_influence"),
		hpr_normal("war.camp.hp.slaanesh.004", "seductive_influence"),
		
		hpr_section("devotees"),
		hpr_normal_unfaded("war.camp.hp.slaanesh.005", "devotees"),
		hpr_normal("war.camp.hp.slaanesh.006", "devotees"),

		hpr_section("seduction"),
		hpr_normal_unfaded("war.camp.hp.slaanesh.007", "seduction"),
		hpr_normal("war.camp.hp.slaanesh.008", "seduction"),

		hpr_section("gifts"),
		hpr_normal_unfaded("war.camp.hp.slaanesh.009", "gifts"),
		hpr_normal("war.camp.hp.slaanesh.010", "gifts"),

		hpr_section("cults"),
		hpr_normal_unfaded("war.camp.hp.slaanesh.011", "cults"),
		hpr_normal("war.camp.hp.slaanesh.012", "cults"),

		hpr_section("great_game"),
		hpr_normal_unfaded("war.camp.hp.slaanesh.013", "great_game"),
		hpr_normal("war.camp.hp.slaanesh.014", "great_game"),
		hpr_normal("war.camp.hp.slaanesh.015", "great_game")
	);
	parser:add_record("campaign_slaanesh", "script_link_campaign_slaanesh", "tooltip_campaign_slaanesh");
	tp_slaanesh = tooltip_patcher:new("tooltip_campaign_slaanesh");
	tp_slaanesh:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_slaanesh",
		"ui_text_replacements_localised_text_hp_campaign_description_slaanesh",
		"UI/help_images/slaanesh.png"
	);
	
	
	
	--
	-- slaves
	--

	hp_slaves = help_page:new(
		"script_link_campaign_slaves",
		hpr_title("war.camp.hp.slaves.001"),
		hpr_leader("war.camp.hp.slaves.002"),
		hpr_normal("war.camp.hp.slaves.003"),
		hpr_normal("war.camp.hp.slaves.004"),
		hpr_normal("war.camp.hp.slaves.005"),
		hpr_normal("war.camp.hp.slaves.006"),
		hpr_normal("war.camp.hp.slaves.007"),
		hpr_normal("war.camp.hp.slaves.008")
	);
	parser:add_record("campaign_slaves", "script_link_campaign_slaves", "tooltip_campaign_slaves");
	tp_slaves = tooltip_patcher:new("tooltip_campaign_slaves");
	tp_slaves:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_slaves", "ui_text_replacements_localised_text_hp_campaign_description_slaves");
	
		
	
	--
	-- slaves_button
	--
	
	parser:add_record("campaign_slaves_button", "script_link_campaign_slaves_button", "tooltip_campaign_slaves_button");
	tp_slaves_button = tooltip_patcher:new("tooltip_campaign_slaves_button");
	tp_slaves_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_slaves_buttons");
	
	tl_slaves_button = tooltip_listener:new(
		"tooltip_campaign_slaves_button",
		function()
			uim:highlight_slaves_button(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- slaves_buttons
	--
	
	parser:add_record("campaign_slaves_buttons", "script_link_campaign_slaves_buttons", "tooltip_campaign_slaves_buttons");
	tp_slaves_buttons = tooltip_patcher:new("tooltip_campaign_slaves_buttons");
	tp_slaves_buttons:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_slaves_buttons");
	
	tl_slaves_buttons = tooltip_listener:new(
		"tooltip_campaign_slaves_buttons",
		function()
			uim:highlight_slaves_buttons(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- slaves_link
	--
	
	parser:add_record("campaign_slaves_link", "script_link_campaign_slaves_link", "tooltip_campaign_slaves_link");
	tp_slaves_link = tooltip_patcher:new("tooltip_campaign_slaves_link");
	tp_slaves_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_slaves_buttons");
	
	tl_slaves_link = tooltip_listener:new(
		"tooltip_campaign_slaves_link",
		function()
			uim:highlight_slaves_button(true);
			uim:highlight_slaves_buttons(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	--
	-- souls resource
	--

	hp_souls_resource = help_page:new(
		"script_link_campaign_souls_resource",
		hpr_title("war.camp.hp.souls_resource.001"),
		hpr_leader("war.camp.hp.souls_resource.002"),
		hpr_normal("war.camp.hp.souls_resource.003"),
		hpr_normal("war.camp.hp.souls_resource.004")
	);
	parser:add_record("campaign_souls_resource", "script_link_campaign_souls_resource", "tooltip_campaign_souls_resource");
	tp_souls_resource = tooltip_patcher:new("tooltip_campaign_souls_resource");
	tp_souls_resource:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_souls_resource", "ui_text_replacements_localised_text_hp_campaign_description_souls_resource");

	
	--
	-- stances
	--

	hp_stances = help_page:new(
		"script_link_campaign_stances",
		hpr_title("war.camp.hp.stances.001"),
		hpr_leader("war.camp.hp.stances.002"),
		hpr_normal("war.camp.hp.stances.003"),
		hpr_normal("war.camp.hp.stances.004"),

		hpr_section("rollout"),
		hpr_normal_unfaded("war.camp.hp.stances.005", "rollout"),
		hpr_normal("war.camp.hp.stances.006", "rollout"),
		hpr_normal("war.camp.hp.stances.007", "rollout"),

		hpr_section("march"),
		hpr_normal_unfaded("war.camp.hp.stances.008", "march"),
		hpr_normal("war.camp.hp.stances.009", "march"),

		hpr_section("instant"),
		hpr_normal_unfaded("war.camp.hp.stances.010", "instant"),
		hpr_normal("war.camp.hp.stances.011", "instant"),
		hpr_bulleted("war.camp.hp.stances.012", "instant"),
		hpr_bulleted("war.camp.hp.stances.013", "instant"),
		hpr_bulleted("war.camp.hp.stances.014", "instant"),
		hpr_bulleted("war.camp.hp.stances.015", "instant"),

		hpr_section("encamp"),
		hpr_normal_unfaded("war.camp.hp.stances.016", "encamp"),
		hpr_normal("war.camp.hp.stances.017", "encamp"),
		hpr_normal("war.camp.hp.stances.018", "encamp"),

		hpr_section("channelling"),
		hpr_normal_unfaded("war.camp.hp.stances.019", "channelling"),
		hpr_normal("war.camp.hp.stances.020", "channelling"),

		hpr_normal("war.camp.hp.stances.021")
	);
	parser:add_record("campaign_stances", "script_link_campaign_stances", "tooltip_campaign_stances");
	tp_stances = tooltip_patcher:new("tooltip_campaign_stances");
	tp_stances:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_stances", "ui_text_replacements_localised_text_hp_campaign_description_stances");

	tl_stances = tooltip_listener:new(
		"tooltip_campaign_stances", 
		function() 
			uim:highlight_stances(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- stances_link
	--
	
	parser:add_record("campaign_stances_link", "script_link_campaign_stances_link", "tooltip_campaign_stances_link");
	tp_stances_link = tooltip_patcher:new("tooltip_campaign_stances_link");
	tp_stances_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_stances_link");
	
	tl_stances_link = tooltip_listener:new(
		"tooltip_campaign_stances_link",
		function()
			uim:highlight_stances(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	


	--
	-- stances_rollout
	--
	
	parser:add_record("campaign_stances_rollout", "script_link_campaign_stances_rollout", "tooltip_campaign_stances_rollout");
	tp_stances_rollout = tooltip_patcher:new("tooltip_campaign_stances_rollout");
	tp_stances_rollout:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_stances_rollout");
	
	tl_stances_rollout = tooltip_listener:new(
		"tooltip_campaign_stances_rollout",
		function()
			uim:highlight_stances(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);

	

	--
	-- strategic_map
	--

	hp_strategic_map = help_page:new(
		"script_link_campaign_strategic_map",
		hpr_title("war.camp.hp.strategic_map.001"),
		hpr_leader("war.camp.hp.strategic_map.002"),
		hpr_normal("war.camp.hp.strategic_map.003"),
		hpr_normal("war.camp.hp.strategic_map.004"),
		hpr_normal("war.camp.hp.strategic_map.006")
	);
	parser:add_record("campaign_strategic_map", "script_link_campaign_strategic_map", "tooltip_campaign_strategic_map");
	tp_strategic_map = tooltip_patcher:new("tooltip_campaign_strategic_map");
	tp_strategic_map:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_strategic_map", "ui_text_replacements_localised_text_hp_campaign_description_strategic_map");

	tl_strategic_map = tooltip_listener:new(
		"tooltip_campaign_strategic_map", 
		function() 
			uim:highlight_strat_map_button(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
		
	--
	-- strategic_map_button
	--
	
	parser:add_record("campaign_strategic_map_button", "script_link_campaign_strategic_map_button", "tooltip_campaign_strategic_map_button");
	tp_strategic_map_button = tooltip_patcher:new("tooltip_campaign_strategic_map_button");
	tp_strategic_map_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_strategic_map_button");

	tl_strategic_map_button = tooltip_listener:new(
		"tooltip_campaign_strategic_map_button", 
		function() 
			uim:highlight_strat_map_button(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- strategic_map_link
	--
	
	parser:add_record("campaign_strategic_map_link", "script_link_campaign_strategic_map_link", "tooltip_campaign_strategic_map_link");
	tp_strategic_map = tooltip_patcher:new("tooltip_campaign_strategic_map_link");
	tp_strategic_map:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_strategic_map_link");
	
	tl_strategic_map = tooltip_listener:new(
		"tooltip_campaign_strategic_map_link",
		function()
			uim:highlight_strat_map_button(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- strategic_map_layer_buttons
	--
	
	parser:add_record("campaign_strategic_map_layer_buttons", "script_link_campaign_strategic_map_layer_buttons", "tooltip_campaign_strategic_map_layer_buttons");
	tp_strategic_map_layer_buttons = tooltip_patcher:new("tooltip_campaign_strategic_map_layer_buttons");
	tp_strategic_map_layer_buttons:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_strategic_map_layer_buttons");
	
	tl_strategic_map_layer_buttons = tooltip_listener:new(
		"tooltip_campaign_strategic_map_layer_buttons",
		function()
			uim:highlight_strategic_map_layer_buttons(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- summon_disciple_army_button
	--

	parser:add_record("campaign_summon_disciple_army_button", "script_link_campaign_summon_disciple_army_button", "tooltip_campaign_summon_disciple_army_button");
	tp_summon_disciple_army_button = tooltip_patcher:new("tooltip_campaign_summon_disciple_army_button");
	tp_summon_disciple_army_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_summon_disciple_army_button");
	
	tl_summon_disciple_army_button = tooltip_listener:new(
		"tooltip_campaign_summon_disciple_army_button", 
		function() 
			uim:highlight_summon_disciple_army(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- summon_disciple_army_link
	--
	script_feature_name = "disciple_armies";
	parser:add_record("campaign_"..script_feature_name.."_link", "script_link_campaign_"..script_feature_name.."_link", "tooltip_campaign_"..script_feature_name.."_link");
	tp_disciple_armies_link = tooltip_patcher:new("tooltip_campaign_"..script_feature_name.."_link");
	tp_disciple_armies_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_"..script_feature_name.."_link");
	
	tl_disciple_armies_link = tooltip_listener:new(
		"tooltip_campaign_"..script_feature_name.."_link",
		function()
			uim:highlight_summon_disciple_army(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);

	
	--
	-- summon the elector counts
	--

	hp_summon_elector_counts = help_page:new(
		"script_link_campaign_summon_elector_counts",
		hpr_title("war.camp.hp.empire_summon_elector_counts.001"),
		hpr_leader("war.camp.hp.empire_summon_elector_counts.002"),
		hpr_normal("war.camp.hp.empire_summon_elector_counts.003"),
		hpr_normal("war.camp.hp.empire_summon_elector_counts.004"),
		hpr_normal("war.camp.hp.empire_summon_elector_counts.005"),
		hpr_normal("war.camp.hp.empire_summon_elector_counts.006"),
		hpr_normal("war.camp.hp.empire_summon_elector_counts.007")
	);
	parser:add_record("campaign_summon_elector_counts", "script_link_campaign_summon_elector_counts", "tooltip_campaign_summon_elector_counts");
	tp_summon_elector_counts = tooltip_patcher:new("tooltip_campaign_summon_elector_counts");
	tp_summon_elector_counts:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_empire_summon_elector_counts", "ui_text_replacements_localised_text_hp_campaign_description_empire_summon_elector_counts");


	--
	-- supporters_track
	--
	
	parser:add_record("campaign_supporters_track", "script_link_campaign_supporters_track", "tooltip_campaign_supporters_track");
	tp_supporters_track = tooltip_patcher:new("tooltip_campaign_supporters_track");
	tp_supporters_track:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_supporters_track");

	tl_supporters_track = tooltip_listener:new(
		"tooltip_campaign_supporters_track",
		function()
			uim:highlight_kislev_supporters(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	--
	-- sword_of_khaine
	--

	hp_sword_of_khaine = help_page:new(
		"script_link_campaign_sword_of_khaine",
		hpr_title("war.camp.hp.sword_of_khaine.001"),
		hpr_leader("war.camp.hp.sword_of_khaine.002"),
		hpr_normal("war.camp.hp.sword_of_khaine.003"),
		hpr_normal("war.camp.hp.sword_of_khaine.004"),
		hpr_normal("war.camp.hp.sword_of_khaine.005"),
		hpr_normal("war.camp.hp.sword_of_khaine.006")
	);
	parser:add_record("campaign_sword_of_khaine", "script_link_campaign_sword_of_khaine", "tooltip_campaign_sword_of_khaine");
	tp_sword_of_khaine = tooltip_patcher:new("tooltip_campaign_sword_of_khaine");
	tp_sword_of_khaine:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_sword_of_khaine", "ui_text_replacements_localised_text_hp_campaign_description_sword_of_khaine");
	
	
	
	--
	-- sword_of_khaine_link
	--
	
	parser:add_record("campaign_sword_of_khaine_link", "script_link_campaign_sword_of_khaine_link", "tooltip_campaign_sword_of_khaine_link");
	tp_sword_of_khaine = tooltip_patcher:new("tooltip_campaign_sword_of_khaine_link");
	tp_sword_of_khaine:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_sword_of_khaine_link");



	--
	-- symptoms
	--

	parser:add_record("campaign_symptoms", "script_link_campaign_symptoms", "tooltip_campaign_symptoms");
	tp_symptoms = tooltip_patcher:new("tooltip_campaign_symptoms");
	tp_symptoms:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_symptoms");
	
	tl_symptoms = tooltip_listener:new(
		"tooltip_campaign_symptoms", 
		function() 
			uim:highlight_symptoms(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- tax
	--

	hp_tax = help_page:new(
		"script_link_campaign_tax",
		hpr_title("war.camp.hp.tax.001"),
		hpr_leader("war.camp.hp.tax.002"),
		hpr_normal("war.camp.hp.tax.003"),
		hpr_normal("war.camp.hp.tax.004"),
		hpr_normal("war.camp.hp.tax.005"),
		hpr_normal("war.camp.hp.tax.006")
	);
	parser:add_record("campaign_tax", "script_link_campaign_tax", "tooltip_campaign_tax");
	tp_tax = tooltip_patcher:new("tooltip_campaign_tax");
	tp_tax:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_tax", "ui_text_replacements_localised_text_hp_campaign_description_tax");
	
	tl_tax_link = tooltip_listener:new(
		"tooltip_campaign_tax", 
		function() 
			uim:highlight_tax(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- tax_link
	--
	
	parser:add_record("campaign_tax_link", "script_link_campaign_tax_link", "tooltip_campaign_tax_link");
	tp_tax = tooltip_patcher:new("tooltip_campaign_tax_link");
	tp_tax:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_tax_link");
	
	tl_tax = tooltip_listener:new(
		"tooltip_campaign_tax_link",
		function()
			uim:highlight_tax(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	


	--
	-- technology
	--

	hp_technology = help_page:new(
		"script_link_campaign_technology",
		hpr_title("war.camp.hp.technology.001"),
		hpr_leader("war.camp.hp.technology.002"),
		hpr_normal("war.camp.hp.technology.003"),
		hpr_normal("war.camp.hp.technology.004"),
		hpr_normal("war.camp.hp.technology.006")
	);
	parser:add_record("campaign_technology", "script_link_campaign_technology", "tooltip_campaign_technology");
	tp_technology = tooltip_patcher:new("tooltip_campaign_technology");
	tp_technology:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_technology", "ui_text_replacements_localised_text_hp_campaign_description_technology");
	
	tl_technology = tooltip_listener:new(
		"tooltip_campaign_technology",
		function()
			uim:highlight_technologies(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	--
	-- technology_button
	--
	
	parser:add_record("campaign_technology_button", "script_link_campaign_technology_button", "tooltip_campaign_technology_button");
	tp_technology_button = tooltip_patcher:new("tooltip_campaign_technology_button");
	tp_technology_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_technology_button");
	
	tl_technology_button = tooltip_listener:new(
		"tooltip_campaign_technology_button",
		function()
			uim:highlight_technology_button(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- technology_link
	--
	
	parser:add_record("campaign_technology_link", "script_link_campaign_technology_link", "tooltip_campaign_technology_link");
	tp_technology = tooltip_patcher:new("tooltip_campaign_technology_link");
	tp_technology:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_technology_link");
	
	tl_technology_link = tooltip_listener:new(
		"tooltip_campaign_technology_link",
		function()
			uim:highlight_technologies(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- technology_panel
	--

	parser:add_record("campaign_technology_panel", "script_link_campaign_technology_panel", "tooltip_campaign_technology_panel");
	tp_technology_panel = tooltip_patcher:new("tooltip_campaign_technology_panel");
	tp_technology_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_technology_panel");
	
	tl_technology_panel = tooltip_listener:new(
		"tooltip_campaign_technology_panel",
		function()
			uim:highlight_technology_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- teleport_stance
	--

	hp_teleport_stance = help_page:new(
		"script_link_campaign_teleport_stance",
		hpr_title("war.camp.hp.teleport_stance.001"),
		hpr_leader("war.camp.hp.teleport_stance.002"),
		hpr_normal("war.camp.hp.teleport_stance.004"),
		hpr_normal("war.camp.hp.teleport_stance.005"),
		hpr_normal("war.camp.hp.teleport_stance.006")
	);
	parser:add_record("campaign_teleport_stance", "script_link_campaign_teleport_stance", "tooltip_campaign_teleport_stance");
	tp_teleport_stance = tooltip_patcher:new("tooltip_campaign_teleport_stance");
	tp_teleport_stance:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_teleport_stance", "ui_text_replacements_localised_text_hp_campaign_description_teleport_stance");
	


	--
	-- teleport_stance_link
	--
	script_feature_name = "teleport_stance";
	parser:add_record("campaign_"..script_feature_name.."_link", "script_link_campaign_"..script_feature_name.."_link", "tooltip_campaign_"..script_feature_name.."_link");
	tp_teleport_stance_link = tooltip_patcher:new("tooltip_campaign_"..script_feature_name.."_link");
	tp_teleport_stance_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_"..script_feature_name.."_link");
	
	tl_teleport_stance_link = tooltip_listener:new(
		"tooltip_campaign_"..script_feature_name.."_link",
		function()
			uim:highlight_stances(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- terrain_types
	--

	hp_terrain_types = help_page:new(
		"script_link_campaign_terrain_types",
		hpr_title("war.camp.hp.terrain_types.001"),
		hpr_leader("war.camp.hp.terrain_types.002"),
		hpr_normal("war.camp.hp.terrain_types.003"),
		hpr_normal("war.camp.hp.terrain_types.004"),
		hpr_normal("war.camp.hp.terrain_types.005"),
		hpr_normal("war.camp.hp.terrain_types.006"),
		hpr_normal("war.camp.hp.terrain_types.007")
	);
	parser:add_record("campaign_terrain_types", "script_link_campaign_terrain_types", "tooltip_campaign_terrain_types");
	tp_terrain_types = tooltip_patcher:new("tooltip_campaign_terrain_types");
	tp_terrain_types:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_terrain_types", "ui_text_replacements_localised_text_hp_campaign_description_terrain_types");



	--
	-- the_great_game
	--

	hp_the_great_game = help_page:new(
		"script_link_campaign_the_great_game",
		hpr_title("war.camp.hp.the_great_game.001"),
		hpr_leader("war.camp.hp.the_great_game.002"),
		hpr_normal("war.camp.hp.the_great_game.003"),
		hpr_normal("war.camp.hp.the_great_game.004"),
		hpr_normal("war.camp.hp.the_great_game.005"),
		hpr_normal("war.camp.hp.the_great_game.006")
	);
	parser:add_record("campaign_the_great_game", "script_link_campaign_the_great_game", "tooltip_campaign_the_great_game");
	tp_the_great_game = tooltip_patcher:new("tooltip_campaign_the_great_game");
	tp_the_great_game:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_the_great_game", "ui_text_replacements_localised_text_hp_campaign_description_the_great_game");
	
	
	
	--
	-- the_menace_below
	--

	hp_the_menace_below = help_page:new(
		"script_link_campaign_the_menace_below",
		hpr_title("war.camp.hp.the_menace_below.001"),
		hpr_leader("war.camp.hp.the_menace_below.002"),
		hpr_normal("war.camp.hp.the_menace_below.003"),
		hpr_normal("war.camp.hp.the_menace_below.004")
	);
	parser:add_record("campaign_the_menace_below", "script_link_campaign_the_menace_below", "tooltip_campaign_the_menace_below");
	tp_the_menace_below = tooltip_patcher:new("tooltip_campaign_the_menace_below");
	tp_the_menace_below:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_the_menace_below", "ui_text_replacements_localised_text_hp_campaign_description_the_menace_below");
	
	
	
	--
	-- tomb_kings
	--

	hp_tomb_kings = help_page:new(
		"script_link_campaign_tomb_kings",
		hpr_title("war.camp.hp.tomb_kings.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/tomb_kings.png"),
		hpr_leader("war.camp.hp.tomb_kings.002"),
		hpr_normal("war.camp.hp.tomb_kings.003"),
		hpr_normal("war.camp.hp.tomb_kings.004"),
		hpr_normal("war.camp.hp.tomb_kings.005"),
		hpr_normal("war.camp.hp.tomb_kings.006")
	);
	parser:add_record("campaign_tomb_kings", "script_link_campaign_tomb_kings", "tooltip_campaign_tomb_kings");
	tp_tomb_kings = tooltip_patcher:new("tooltip_campaign_tomb_kings");
	tp_tomb_kings:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_tomb_kings",
		"ui_text_replacements_localised_text_hp_campaign_description_tomb_kings",
		"UI/help_images/tomb_kings.png"
	);



	--
	-- tower_of_zharr
	--
	
	hp_tower_of_zharr = help_page:new(
		"script_link_campaign_tower_of_zharr",
		hpr_title("war.camp.hp.tower_of_zharr.001"),
		hpr_leader("war.camp.hp.tower_of_zharr.002"),
		hpr_normal("war.camp.hp.tower_of_zharr.003"),
		hpr_normal("war.camp.hp.tower_of_zharr.004"),
		hpr_normal("war.camp.hp.tower_of_zharr.005"),
		hpr_normal("war.camp.hp.tower_of_zharr.006"),
		hpr_normal("war.camp.hp.tower_of_zharr.007")
	);
	parser:add_record("campaign_tower_of_zharr", "script_link_campaign_tower_of_zharr", "tooltip_campaign_tower_of_zharr");
	tp_tower_of_zharr = tooltip_patcher:new("tooltip_campaign_tower_of_zharr");
	tp_tower_of_zharr:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_tower_of_zharr", "ui_text_replacements_localised_text_hp_campaign_description_tower_of_zharr");
	
	tl_tower_of_zharr = tooltip_listener:new(
		"tooltip_campaign_tower_of_zharr",
		function()
			uim:highlight_tower_of_zharr(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- trade
	--

	hp_trade = help_page:new(
		"script_link_campaign_trade",
		hpr_title("war.camp.hp.trade.001"),
		hpr_leader("war.camp.hp.trade.002"),
		hpr_normal("war.camp.hp.trade.003"),
		hpr_normal("war.camp.hp.trade.004"),
		hpr_normal("war.camp.hp.trade.005"),
		hpr_normal("war.camp.hp.trade.006")
	);
	parser:add_record("campaign_trade", "script_link_campaign_trade", "tooltip_campaign_trade");
	tp_trade = tooltip_patcher:new("tooltip_campaign_trade");
	tp_trade:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_trade", "ui_text_replacements_localised_text_hp_campaign_description_trade");
	
	
	
	--
	-- trade_link
	--
	
	parser:add_record("campaign_trade_link", "script_link_campaign_trade_link", "tooltip_campaign_trade_link");
	tp_trade = tooltip_patcher:new("tooltip_campaign_trade_link");
	tp_trade:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_trade_link");
	
	tl_trade = tooltip_listener:new(
		"tooltip_campaign_trade_link",
		function()
			uim:highlight_can_trade_icons(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- treasure_maps
	--

	hp_treasure_maps = help_page:new(
		"script_link_campaign_treasure_maps",
		hpr_title("war.camp.hp.treasure_maps.001"),
		hpr_leader("war.camp.hp.treasure_maps.002"),
		hpr_normal("war.camp.hp.treasure_maps.003"),
		hpr_normal("war.camp.hp.treasure_maps.004"),
		hpr_normal("war.camp.hp.treasure_maps.005"), 
		hpr_normal("war.camp.hp.treasure_maps.006"), 
		hpr_normal("war.camp.hp.treasure_maps.007") 
	);
	parser:add_record("campaign_treasure_maps", "script_link_campaign_treasure_maps", "tooltip_campaign_treasure_maps");
	tp_treasure_maps = tooltip_patcher:new("tooltip_campaign_treasure_maps");
	tp_treasure_maps:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_treasure_maps", "ui_text_replacements_localised_text_hp_campaign_description_treasure_maps");
	
	tl_treasure_maps = tooltip_listener:new(
		"tooltip_campaign_treasure_maps", 
		function()
			uim:highlight_treasure_map_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end	
	);
	
	
	--
	-- treasure_maps_panel
	--
	
	parser:add_record("campaign_treasure_maps_panel", "script_link_campaign_treasure_maps_panel", "tooltip_campaign_treasure_maps_panel");
	tp_treasure_maps_panel = tooltip_patcher:new("tooltip_campaign_treasure_maps_panel");
	tp_treasure_maps_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_treasure_maps_panel");
	
	tl_treasure_maps_panel = tooltip_listener:new(
		"tooltip_campaign_treasure_maps_panel",
		function()
			uim:highlight_treasure_map_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- treasury
	--

	parser:add_record("campaign_treasury", "script_link_campaign_treasury", "tooltip_campaign_treasury");
	tp_treasury = tooltip_patcher:new("tooltip_campaign_treasury");
	tp_treasury:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_treasury");
	
	tl_treasury = tooltip_listener:new(
		"tooltip_campaign_treasury", 
		function() 
			uim:highlight_treasury(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);
	

	
	--
	-- treasury_button
	--
	
	parser:add_record("campaign_treasury_button", "script_link_campaign_treasury_button", "tooltip_campaign_treasury_button");
	tp_treasury_button = tooltip_patcher:new("tooltip_campaign_treasury_button");
	tp_treasury_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_treasury_button");
	
	tl_treasury_button = tooltip_listener:new(
		"tooltip_campaign_treasury_button", 
		function()
			uim:highlight_treasury_button(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- treasury_panel
	--
	
	hp_treasury_panel = help_page:new(
		"script_link_campaign_treasury_panel",
		hpr_title("war.camp.hp.treasury_panel.001"),
		hpr_leader("war.camp.hp.treasury_panel.002"),
		hpr_normal("war.camp.hp.treasury_panel.003"),
		hpr_normal("war.camp.hp.treasury_panel.004"),
		hpr_normal("war.camp.hp.treasury_panel.005")
	);
	parser:add_record("campaign_treasury_panel", "script_link_campaign_treasury_panel", "tooltip_campaign_treasury_panel");
	tp_treasury_panel = tooltip_patcher:new("tooltip_campaign_treasury_panel");
	tp_treasury_panel:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_treasury_panel", "ui_text_replacements_localised_text_hp_campaign_description_treasury_panel");
	
	tl_treasury_panel = tooltip_listener:new(
		"tooltip_campaign_treasury_panel", 
		function()
			uim:highlight_treasury_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- treasury_panel_details_tab
	--

	parser:add_record("campaign_treasury_panel_details_tab", "script_link_campaign_treasury_panel_details_tab", "tooltip_campaign_treasury_panel_details_tab");
	tp_treasury_panel = tooltip_patcher:new("tooltip_campaign_treasury_panel_details_tab");
	tp_treasury_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_treasury_panel_details_tab");
	
	tl_treasury_details_tab = tooltip_listener:new(
		"tooltip_campaign_treasury_panel_details_tab", 
		function()
			uim:highlight_treasury_panel_details_tab(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- treasury_panel_link
	--
	
	parser:add_record("campaign_treasury_panel_link", "script_link_campaign_treasury_panel_link", "tooltip_campaign_treasury_panel_link");
	tp_treasury_panel = tooltip_patcher:new("tooltip_campaign_treasury_panel_link");
	tp_treasury_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_treasury_panel_link");
	
	tl_treasury_panel_link = tooltip_listener:new(
		"tooltip_campaign_treasury_panel_link",
		function()
			uim:highlight_treasury_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- treasury_panel_summary_tab
	--

	parser:add_record("campaign_treasury_panel_summary_tab", "script_link_campaign_treasury_panel_summary_tab", "tooltip_campaign_treasury_panel_summary_tab");
	tp_treasury_panel = tooltip_patcher:new("tooltip_campaign_treasury_panel_summary_tab");
	tp_treasury_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_treasury_panel_summary_tab");
	
	tl_treasury_panel_summary_tab = tooltip_listener:new(
		"tooltip_campaign_treasury_panel_summary_tab", 
		function()
			uim:highlight_treasury_panel_summary_tab(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- treasury_panel_trade_tab
	--

	parser:add_record("campaign_treasury_panel_trade_tab", "script_link_campaign_treasury_panel_trade_tab", "tooltip_campaign_treasury_panel_trade_tab");
	tp_treasury_panel = tooltip_patcher:new("tooltip_campaign_treasury_panel_trade_tab");
	tp_treasury_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_treasury_panel_trade_tab");
	
	tl_treasury_panel_trade_tab = tooltip_listener:new(
		"tooltip_campaign_treasury_panel_trade_tab", 
		function()
			uim:highlight_treasury_panel_trade_tab(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- tribal_confederation
	--

	hp_tribal_confederation = help_page:new(
		"script_link_campaign_tribal_confederation",
		hpr_title("war.camp.hp.tribal_confederation.001"),
		hpr_leader("war.camp.hp.tribal_confederation.002"),
		hpr_normal("war.camp.hp.tribal_confederation.003"),
		hpr_normal("war.camp.hp.tribal_confederation.004")
	);
	parser:add_record("campaign_tribal_confederation", "script_link_campaign_tribal_confederation", "tooltip_campaign_tribal_confederation");
	tp_tribal_confederation = tooltip_patcher:new("tooltip_campaign_tribal_confederation");
	tp_tribal_confederation:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_tribal_confederation", "ui_text_replacements_localised_text_hp_campaign_description_tribal_confederation");

	
	
	--
	-- trickster cults
	--

	hp_trickster_cults = help_page:new(
		"script_link_campaign_trickster_cults",
		hpr_title("war.camp.hp.trickster_cults.001"),
		hpr_leader("war.camp.hp.trickster_cults.002"),
		hpr_normal("war.camp.hp.trickster_cults.003"),
		hpr_normal("war.camp.hp.trickster_cults.004"),
		hpr_normal("war.camp.hp.trickster_cults.005"),
		hpr_normal("war.camp.hp.trickster_cults.006"),
		hpr_normal("war.camp.hp.trickster_cults.007")
	);
	parser:add_record("campaign_trickster_cults", "script_link_campaign_trickster_cults", "tooltip_campaign_trickster_cults");
	tp_trickster_cults = tooltip_patcher:new("tooltip_campaign_trickster_cults");
	tp_trickster_cults:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_trickster_cults", "ui_text_replacements_localised_text_hp_campaign_description_trickster_cults");
	
	
	
	--
	-- turns
	--

	hp_turns = help_page:new(
		"script_link_campaign_turns",
		hpr_title("war.camp.hp.turns.001"),
		hpr_leader("war.camp.hp.turns.002"),
		hpr_normal("war.camp.hp.turns.003"),
		hpr_normal("war.camp.hp.turns.005")
	);
	parser:add_record("campaign_turns", "script_link_campaign_turns", "tooltip_campaign_turns");
	tp_turns = tooltip_patcher:new("tooltip_campaign_turns");
	tp_turns:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_turns", "ui_text_replacements_localised_text_hp_campaign_description_turns");



	--
	-- tzeentch
	--

	hp_tzeentch = help_page:new(
		"script_link_campaign_tzeentch",
		hpr_title("war.camp.hp.tzeentch.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/tzeentch.png"),
		hpr_leader("war.camp.hp.tzeentch.002"),
		hpr_normal("war.camp.hp.tzeentch.003"),

		hpr_section("magic"),
		hpr_normal_unfaded("war.camp.hp.tzeentch.004", "magic"),
		hpr_normal("war.camp.hp.tzeentch.005", "magic"),
		hpr_normal("war.camp.hp.tzeentch.006", "magic"),
		
		hpr_section("grimoires"),
		hpr_normal_unfaded("war.camp.hp.tzeentch.007", "grimoires"),
		hpr_normal("war.camp.hp.tzeentch.008", "grimoires"),

		hpr_section("teleport"),
		hpr_normal_unfaded("war.camp.hp.tzeentch.009", "teleport"),
		hpr_normal("war.camp.hp.tzeentch.010", "teleport"),

		hpr_section("great_game"),
		hpr_normal_unfaded("war.camp.hp.tzeentch.011", "great_game"),
		hpr_normal("war.camp.hp.tzeentch.012", "great_game"),
		hpr_normal("war.camp.hp.tzeentch.013", "great_game")
	);
	parser:add_record("campaign_tzeentch", "script_link_campaign_tzeentch", "tooltip_campaign_tzeentch");
	tp_tzeentch = tooltip_patcher:new("tooltip_campaign_tzeentch");
	tp_tzeentch:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_tzeentch",
		"ui_text_replacements_localised_text_hp_campaign_description_tzeentch",
		"UI/help_images/tzeentch.png"
	);



	--
	-- underway
	--

	hp_underway = help_page:new(
		"script_link_campaign_underway",
		hpr_title("war.camp.hp.underway.001"),
		hpr_leader("war.camp.hp.underway.002"),
		hpr_normal("war.camp.hp.underway.003"),
		hpr_normal("war.camp.hp.underway.004"),
		hpr_normal("war.camp.hp.underway.005"),
		hpr_normal("war.camp.hp.underway.006"),
		hpr_normal("war.camp.hp.underway.007")
	);
	parser:add_record("campaign_underway", "script_link_campaign_underway", "tooltip_campaign_underway");
	tp_underway = tooltip_patcher:new("tooltip_campaign_underway");
	tp_underway:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_underway", "ui_text_replacements_localised_text_hp_campaign_description_underway");



	--
	-- unholy_manifestations
	--

	hp_unholy_manifestations = help_page:new(
		"script_link_campaign_unholy_manifestations",
		hpr_title("war.camp.hp.unholy_manifestations.001"),
		hpr_leader("war.camp.hp.unholy_manifestations.002"),
		hpr_normal("war.camp.hp.unholy_manifestations.003"),
		hpr_normal("war.camp.hp.unholy_manifestations.004"),
		hpr_normal("war.camp.hp.unholy_manifestations.005"),
		hpr_normal("war.camp.hp.unholy_manifestations.006")
	);
	parser:add_record("campaign_unholy_manifestations", "script_link_campaign_unholy_manifestations", "tooltip_campaign_unholy_manifestations");
	tp_unholy_manifestations = tooltip_patcher:new("tooltip_campaign_unholy_manifestations");
	tp_unholy_manifestations:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_unholy_manifestations", "ui_text_replacements_localised_text_hp_campaign_description_unholy_manifestations");

	tl_unholy_manifestations = tooltip_listener:new(
		"tooltip_campaign_unholy_manifestations", 
		function() 
			uim:highlight_unholy_manifestations(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- unholy_manifestations_link
	--
	
	parser:add_record("campaign_unholy_manifestations_link", "script_link_campaign_unholy_manifestations_link", "tooltip_campaign_unholy_manifestations_link");
	tp_unholy_manifestations_link = tooltip_patcher:new("tooltip_campaign_unholy_manifestations_link");
	tp_unholy_manifestations_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_unholy_manifestations_link");
	
	tl_unholy_manifestations_link = tooltip_listener:new(
		"tooltip_campaign_unholy_manifestations_link", 
		function() 
			uim:highlight_unholy_manifestations(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);


	--
	-- unholy_manifestations_panel
	--

	parser:add_record("campaign_unholy_manifestations_panel", "script_link_campaign_unholy_manifestations_panel", "tooltip_campaign_unholy_manifestations_panel");
	tp_unholy_manifestations_panel = tooltip_patcher:new("tooltip_campaign_unholy_manifestations_panel");
	tp_unholy_manifestations_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_unholy_manifestations_panel");
	
	tl_unholy_manifestations_panel = tooltip_listener:new(
		"tooltip_campaign_unholy_manifestations_panel", 
		function() 
			uim:highlight_unholy_manifestations(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);


	
	--
	-- unit_cards
	--

	hp_unit_cards = help_page:new(
		"script_link_campaign_unit_cards",
		hpr_title("war.camp.hp.unit_cards.001"),
		hpr_leader("war.camp.hp.unit_cards.002"),
		hpr_normal("war.camp.hp.unit_cards.003"),
		hpr_normal("war.camp.hp.unit_cards.004"),
		hpr_normal("war.camp.hp.unit_cards.005"),
		hpr_normal("war.camp.hp.unit_cards.006"),
		hpr_normal("war.camp.hp.unit_cards.007")
	);
	parser:add_record("campaign_unit_cards", "script_link_campaign_unit_cards", "tooltip_campaign_unit_cards");
	tp_unit_cards = tooltip_patcher:new("tooltip_campaign_unit_cards");
	tp_unit_cards:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_unit_cards", "ui_text_replacements_localised_text_hp_campaign_description_unit_cards");
	
	tl_unit_cards = tooltip_listener:new(
		"tooltip_campaign_unit_cards", 
		function() 
			uim:highlight_unit_cards(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- unit_cards_link
	--
	
	parser:add_record("campaign_unit_cards_link", "script_link_campaign_unit_cards_link", "tooltip_campaign_unit_cards_link");
	tp_unit_cards = tooltip_patcher:new("tooltip_campaign_unit_cards_link");
	tp_unit_cards:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_unit_cards_link");
	
	tl_unit_cards_link = tooltip_listener:new(
		"tooltip_campaign_unit_cards_link",
		function()
			uim:highlight_unit_cards(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);

	

	--
	-- unit_exchange
	--

	hp_unit_exchange = help_page:new(
		"script_link_campaign_unit_exchange",
		hpr_title("war.camp.hp.unit_exchange.001"),
		hpr_leader("war.camp.hp.unit_exchange.002"),
		hpr_normal("war.camp.hp.unit_exchange.003"),
		hpr_normal("war.camp.hp.unit_exchange.004"),
		hpr_normal("war.camp.hp.unit_exchange.005")
	);
	parser:add_record("campaign_unit_exchange", "script_link_campaign_unit_exchange", "tooltip_campaign_unit_exchange");
	tp_unit_exchange = tooltip_patcher:new("tooltip_campaign_unit_exchange");
	tp_unit_exchange:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_unit_exchange", "ui_text_replacements_localised_text_hp_campaign_description_unit_exchange");
	
	
	
	--
	-- unit_exchange_panel
	--
	
	parser:add_record("campaign_unit_exchange_panel", "script_link_campaign_unit_exchange_panel", "tooltip_campaign_unit_exchange_panel");
	tp_unit_exchange_panel = tooltip_patcher:new("tooltip_campaign_unit_exchange_panel");
	tp_unit_exchange_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_unit_exchange_panel");
	
	tl_unit_exchange_panel = tooltip_listener:new(
		"tooltip_campaign_unit_exchange_panel",
		function()
			uim:highlight_unit_exchange_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- unit_experience
	--

	hp_unit_experience = help_page:new(
		"script_link_campaign_unit_experience",
		hpr_title("war.camp.hp.unit_experience.001"),
		hpr_leader("war.camp.hp.unit_experience.002"),
		hpr_normal("war.camp.hp.unit_experience.003"),
		hpr_normal("war.camp.hp.unit_experience.004"),
		hpr_normal("war.camp.hp.unit_experience.005"),
		hpr_normal("war.camp.hp.unit_experience.006")
	);
	parser:add_record("campaign_unit_experience", "script_link_campaign_unit_experience", "tooltip_campaign_unit_experience");
	tp_unit_experience = tooltip_patcher:new("tooltip_campaign_unit_experience");
	tp_unit_experience:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_unit_experience", "ui_text_replacements_localised_text_hp_campaign_description_unit_experience");

	tl_unit_experience = tooltip_listener:new(
		"tooltip_campaign_unit_experience",
		function()
			uim:highlight_unit_experience(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- unit_experience_link
	--
	
	parser:add_record("campaign_unit_experience_link", "script_link_campaign_unit_experience_link", "tooltip_campaign_unit_experience_link");
	tp_unit_experience = tooltip_patcher:new("tooltip_campaign_unit_experience_link");
	tp_unit_experience:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_unit_experience_link");
	
	tl_unit_experience_link = tooltip_listener:new(
		"tooltip_campaign_unit_experience_link",
		function()
			uim:highlight_unit_experience(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	


	--
	-- unit_info_panel
	--

	hp_unit_info_panel = help_page:new(
		"script_link_campaign_unit_info_panel",
		hpr_title("war.camp.hp.unit_info_panel.001"),
		hpr_leader("war.camp.hp.unit_info_panel.002"),
		hpr_normal("war.camp.hp.unit_info_panel.003")
	);
	parser:add_record("campaign_unit_info_panel", "script_link_campaign_unit_info_panel", "tooltip_campaign_unit_info_panel");
	tp_unit_info_panel = tooltip_patcher:new("tooltip_campaign_unit_info_panel");
	tp_unit_info_panel:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_unit_info_panel", "ui_text_replacements_localised_text_hp_campaign_description_unit_info_panel");
	
	tl_unit_info_panel = tooltip_listener:new(
		"tooltip_campaign_unit_info_panel",
		function()
			uim:highlight_unit_information_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	--
	-- unit_info_panel_link
	--
	
	parser:add_record("campaign_unit_info_panel_link", "script_link_campaign_unit_info_panel_link", "tooltip_campaign_unit_info_panel_link");
	tp_unit_info_panel = tooltip_patcher:new("tooltip_campaign_unit_info_panel_link");
	tp_unit_info_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_unit_info_panel_link");
	
	tl_unit_info_panel_link = tooltip_listener:new(
		"tooltip_campaign_unit_info_panel_link",
		function()
			uim:highlight_unit_information_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- unit_merging_and_disbanding
	--
	
	hp_unit_merging_and_disbanding = help_page:new(
		"script_link_campaign_unit_merging_and_disbanding",
		hpr_title("war.camp.hp.unit_merging_and_disbanding.001"),
		hpr_leader("war.camp.hp.unit_merging_and_disbanding.002"),
		hpr_normal("war.camp.hp.unit_merging_and_disbanding.003"),
		hpr_normal("war.camp.hp.unit_merging_and_disbanding.004"),
		hpr_normal("war.camp.hp.unit_merging_and_disbanding.005")
	);
	parser:add_record("campaign_unit_merging_and_disbanding", "script_link_campaign_unit_merging_and_disbanding", "tooltip_campaign_unit_merging_and_disbanding");
	tp_unit_merging_and_disbanding = tooltip_patcher:new("tooltip_campaign_unit_merging_and_disbanding");
	tp_unit_merging_and_disbanding:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_unit_merging_and_disbanding", "ui_text_replacements_localised_text_hp_campaign_description_unit_merging_and_disbanding");



	--
	-- unit_recruitment
	--

	hp_unit_recruitment = help_page:new(
		"script_link_campaign_unit_recruitment",
		hpr_title("war.camp.hp.unit_recruitment.001"),
		hpr_leader("war.camp.hp.unit_recruitment.002"),
		hpr_normal("war.camp.hp.unit_recruitment.003"),

		hpr_section("local"),
		hpr_normal_unfaded("war.camp.hp.unit_recruitment.004", "local"),
		hpr_normal("war.camp.hp.unit_recruitment.005", "local"),
		hpr_normal("war.camp.hp.unit_recruitment.006", "local"),

		hpr_section("global"),
		hpr_normal_unfaded("war.camp.hp.unit_recruitment.007", "global"),
		hpr_normal("war.camp.hp.unit_recruitment.008", "global"),
		hpr_normal("war.camp.hp.unit_recruitment.009", "global"),

		hpr_section("mustering"),
		hpr_normal_unfaded("war.camp.hp.unit_recruitment.010", "mustering"),
		hpr_normal("war.camp.hp.unit_recruitment.011", "mustering"),

		hpr_section("nurgle"),
		hpr_normal_unfaded("war.camp.hp.unit_recruitment.012", "nurgle"),
		hpr_normal("war.camp.hp.unit_recruitment.013", "nurgle"),

		hpr_normal("war.camp.hp.unit_recruitment.014")
	);
	parser:add_record("campaign_unit_recruitment", "script_link_campaign_unit_recruitment", "tooltip_campaign_unit_recruitment");
	tp_unit_recruitment = tooltip_patcher:new("tooltip_campaign_unit_recruitment");
	tp_unit_recruitment:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_unit_recruitment", "ui_text_replacements_localised_text_hp_campaign_description_unit_recruitment");
	
	tl_unit_recruitment = tooltip_listener:new(
		"tooltip_campaign_unit_recruitment",
		function()
			uim:highlight_unit_recruitment_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	


	--
	-- unit_recruitment_button
	--
	
	parser:add_record("campaign_unit_recruitment_button", "script_link_campaign_unit_recruitment_button", "tooltip_campaign_unit_recruitment_button");
	tp_unit_recruitment_button = tooltip_patcher:new("tooltip_campaign_unit_recruitment_button");
	tp_unit_recruitment_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_unit_recruitment_button");

	tl_unit_recruitment_button = tooltip_listener:new(
		"tooltip_campaign_unit_recruitment_button", 
		function() 
			uim:highlight_recruitment_button(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- unit_recruitment_link
	--
	
	parser:add_record("campaign_unit_recruitment_link", "script_link_campaign_unit_recruitment_link", "tooltip_campaign_unit_recruitment_link");
	tp_unit_recruitment_link = tooltip_patcher:new("tooltip_campaign_unit_recruitment_link");
	tp_unit_recruitment_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_unit_recruitment_link");
	
	tl_unit_recruitment_link = tooltip_listener:new(
		"tooltip_campaign_unit_recruitment_link",
		function()
			uim:highlight_unit_recruitment_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- unit_recruitment_panel
	--

	hp_unit_recruitment_panel = help_page:new(
		"script_link_campaign_unit_recruitment_panel",
		hpr_title("war.camp.hp.unit_recruitment_panel.001"),
		hpr_leader("war.camp.hp.unit_recruitment_panel.002"),
		hpr_normal("war.camp.hp.unit_recruitment_panel.003"),
		hpr_normal("war.camp.hp.unit_recruitment_panel.004")
	);
	parser:add_record("campaign_unit_recruitment_panel", "script_link_campaign_unit_recruitment_panel", "tooltip_campaign_unit_recruitment_panel");
	tp_unit_recruitment_panel = tooltip_patcher:new("tooltip_campaign_unit_recruitment_panel");
	tp_unit_recruitment_panel:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_unit_recruitment_panel", "ui_text_replacements_localised_text_hp_campaign_description_unit_recruitment_panel");

	tl_unit_recruitment_panel = tooltip_listener:new(
		"tooltip_campaign_unit_recruitment_panel", 
		function() 
			uim:highlight_unit_recruitment_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- unit_recruitment_panel_link
	--
	
	parser:add_record("campaign_unit_recruitment_panel_link", "script_link_campaign_unit_recruitment_panel_link", "tooltip_campaign_unit_recruitment_panel_link");
	tp_unit_recruitment_panel = tooltip_patcher:new("tooltip_campaign_unit_recruitment_panel_link");
	tp_unit_recruitment_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_unit_recruitment_panel_link");
	
	tl_unit_recruitment_panel_link = tooltip_listener:new(
		"tooltip_campaign_unit_recruitment_panel_link",
		function()
			uim:highlight_unit_recruitment_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- unit_replenishment
	--

	hp_unit_replenishment = help_page:new(
		"script_link_campaign_unit_replenishment",
		hpr_title("war.camp.hp.unit_replenishment.001"),
		hpr_leader("war.camp.hp.unit_replenishment.002"),
		hpr_normal("war.camp.hp.unit_replenishment.003"),
		hpr_normal("war.camp.hp.unit_replenishment.004"),
		hpr_normal("war.camp.hp.unit_replenishment.005")
	);
	parser:add_record("campaign_unit_replenishment", "script_link_campaign_unit_replenishment", "tooltip_campaign_unit_replenishment");
	tp_unit_replenishment = tooltip_patcher:new("tooltip_campaign_unit_replenishment");
	tp_unit_replenishment:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_unit_replenishment", "ui_text_replacements_localised_text_hp_campaign_description_unit_replenishment");
	


	--
	-- unit_types
	--

	hp_unit_types = help_page:new(
		"script_link_campaign_unit_types",
		hpr_title("war.camp.hp.unit_types.001"),
		hpr_leader("war.camp.hp.unit_types.002"),
		hpr_bulleted("war.camp.hp.unit_types.003"),
		hpr_bulleted("war.camp.hp.unit_types.004"),
		hpr_bulleted("war.camp.hp.unit_types.005"),
		hpr_normal("war.camp.hp.unit_types.006"),
		hpr_normal("war.camp.hp.unit_types.008")
	);
	parser:add_record("campaign_unit_types", "script_link_campaign_unit_types", "tooltip_campaign_unit_types");
	tp_unit_types = tooltip_patcher:new("tooltip_campaign_unit_types");
	tp_unit_types:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_unit_types", "ui_text_replacements_localised_text_hp_campaign_description_unit_types");
	
	tl_unit_types = tooltip_listener:new(
		"tooltip_campaign_unit_types",
		function()
			uim:highlight_unit_types(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- unit_types_link
	--
	
	parser:add_record("campaign_unit_types_link", "script_link_campaign_unit_types_link", "tooltip_campaign_unit_types_link");
	tp_unit_types = tooltip_patcher:new("tooltip_campaign_unit_types_link");
	tp_unit_types:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_unit_types_link");
	
	tl_unit_types_link = tooltip_listener:new(
		"tooltip_campaign_unit_types_link",
		function()
			uim:highlight_unit_types(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- units
	--

	hp_units = help_page:new(
		"script_link_campaign_units",
		hpr_title("war.camp.hp.units.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/units.png"),
		hpr_leader("war.camp.hp.units.002"),
		hpr_normal("war.camp.hp.units.003"),
		hpr_normal("war.camp.hp.units.004"),
		hpr_normal("war.camp.hp.units.005"),
		hpr_normal("war.camp.hp.units.006"),
		hpr_normal("war.camp.hp.units.007"),
		hpr_normal("war.camp.hp.units.009")
	);
	parser:add_record("campaign_units", "script_link_campaign_units", "tooltip_campaign_units");
	tp_units = tooltip_patcher:new("tooltip_campaign_units");
	tp_units:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_units",
		"ui_text_replacements_localised_text_hp_campaign_description_units",
		"UI/help_images/units.png"
	);



	--
	-- ursun
	--

	hp_ursun = help_page:new(
		"script_link_campaign_ursun",
		hpr_title("war.camp.hp.ursun.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/ursun.png"),
		hpr_leader("war.camp.hp.ursun.002"),
		hpr_normal("war.camp.hp.ursun.003"),
		hpr_normal("war.camp.hp.ursun.004")
	);
	parser:add_record("campaign_ursun", "script_link_campaign_ursun", "tooltip_campaign_ursun");
	tp_ursun = tooltip_patcher:new("tooltip_campaign_ursun");
	tp_ursun:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_ursun",
		"ui_text_replacements_localised_text_hp_campaign_description_ursun",
		"UI/help_images/ursun.png"
	);



	--
	-- vampire_coast
	--

	hp_vampire_coast = help_page:new(
		"script_link_campaign_vampire_coast",
		hpr_title("war.camp.hp.vampire_coast.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/vampire_coast.png"),
		hpr_leader("war.camp.hp.vampire_coast.002"),
		hpr_normal("war.camp.hp.vampire_coast.003"),
		hpr_normal("war.camp.hp.vampire_coast.004"),
		hpr_normal("war.camp.hp.vampire_coast.005"),
		hpr_normal("war.camp.hp.vampire_coast.006"),
		hpr_normal("war.camp.hp.vampire_coast.008")
	);
	parser:add_record("campaign_vampire_coast", "script_link_campaign_vampire_coast", "tooltip_campaign_vampire_coast");
	tp_vampire_coast = tooltip_patcher:new("tooltip_campaign_vampire_coast");
	tp_vampire_coast:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_vampire_coast", "ui_text_replacements_localised_text_hp_campaign_description_vampire_coast");
	tp_vampire_coast:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_vampire_coast",
		"ui_text_replacements_localised_text_hp_campaign_description_vampire_coast",
		"UI/help_images/vampire_coast.png"
	);


	
	--
	-- vampires
	--

	hp_vampires = help_page:new(
		"script_link_campaign_vampires",
		hpr_title("war.camp.hp.vampires.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/vampire_counts.png"),
		hpr_leader("war.camp.hp.vampires.002"),
		hpr_normal("war.camp.hp.vampires.003"),
		hpr_normal("war.camp.hp.vampires.004"),
		hpr_normal("war.camp.hp.vampires.005")
	);
	parser:add_record("campaign_vampires", "script_link_campaign_vampires", "tooltip_campaign_vampires");
	tp_vampires = tooltip_patcher:new("tooltip_campaign_vampires");
	tp_vampires:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_vampires",
		"ui_text_replacements_localised_text_hp_campaign_description_vampires",
		"UI/help_images/vampire_counts.png"
	);
	
	
	
	--
	-- vampiric_corruption
	--

	hp_vampiric_corruption = help_page:new(
		"script_link_campaign_vampiric_corruption",
		hpr_title("war.camp.hp.vampiric_corruption.001"),
		hpr_leader("war.camp.hp.vampiric_corruption.002"),
		hpr_normal("war.camp.hp.vampiric_corruption.003"),
		hpr_normal("war.camp.hp.vampiric_corruption.004"),
		hpr_normal("war.camp.hp.vampiric_corruption.005"),
		hpr_normal("war.camp.hp.vampiric_corruption.006"),
		hpr_normal("war.camp.hp.vampiric_corruption.008")
	);
	parser:add_record("campaign_vampiric_corruption", "script_link_campaign_vampiric_corruption", "tooltip_campaign_vampiric_corruption");
	tp_vampiric_corruption = tooltip_patcher:new("tooltip_campaign_vampiric_corruption");
	tp_vampiric_corruption:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_vampiric_corruption", "ui_text_replacements_localised_text_hp_campaign_description_vampiric_corruption");
	
	
	--
	-- vampiric_loyalty
	--

	hp_vampiric_loyalty = help_page:new(
		"script_link_campaign_vampiric_loyalty",
		hpr_title("war.camp.hp.vampiric_loyalty.001"),
		hpr_leader("war.camp.hp.vampiric_loyalty.002"),
		hpr_normal("war.camp.hp.vampiric_loyalty.003"),
		hpr_normal("war.camp.hp.vampiric_loyalty.004"),
		hpr_normal("war.camp.hp.vampiric_loyalty.005"),
		hpr_normal("war.camp.hp.vampiric_loyalty.006")
	);
	parser:add_record("campaign_vampiric_loyalty", "script_link_campaign_vampiric_loyalty", "tooltip_campaign_vampiric_loyalty");
	tp_vampiric_loyalty = tooltip_patcher:new("tooltip_campaign_vampiric_loyalty");
	tp_vampiric_loyalty:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_vampiric_loyalty", "ui_text_replacements_localised_text_hp_campaign_description_vampiric_loyalty");
	
	
	--
	-- vassalage
	--

	hp_vassalage = help_page:new(
		"script_link_campaign_vassalage",
		hpr_title("war.camp.hp.vassalage.001"),
		hpr_leader("war.camp.hp.vassalage.002"),
		hpr_normal("war.camp.hp.vassalage.003"),
		hpr_normal("war.camp.hp.vassalage.004"),
		hpr_normal("war.camp.hp.vassalage.005"),
		hpr_normal("war.camp.hp.vassalage.006"),
		hpr_normal("war.camp.hp.vassalage.007")
	);
	parser:add_record("campaign_vassalage", "script_link_campaign_vassalage", "tooltip_campaign_vassalage");
	tp_vassalage = tooltip_patcher:new("tooltip_campaign_vassalage");
	tp_vassalage:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_vassalage", "ui_text_replacements_localised_text_hp_campaign_description_vassalage");
	
	
	
	--
	-- victory_conditions
	--

	hp_victory_conditions = help_page:new(
		"script_link_campaign_victory_conditions",
		hpr_title("war.camp.hp.victory_conditions.001"),
		hpr_leader("war.camp.hp.victory_conditions.002"),
		hpr_normal("war.camp.hp.victory_conditions.003"),
		hpr_normal("war.camp.hp.victory_conditions.004"),
		hpr_normal("war.camp.hp.victory_conditions.006")
	);
	parser:add_record("campaign_victory_conditions", "script_link_campaign_victory_conditions", "tooltip_campaign_victory_conditions");
	tp_victory_conditions = tooltip_patcher:new("tooltip_campaign_victory_conditions");
	tp_victory_conditions:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_victory_conditions", "ui_text_replacements_localised_text_hp_campaign_description_victory_conditions");
	
	tl_victory_conditions = tooltip_listener:new(
		"tooltip_campaign_victory_conditions",
		function()
			uim:highlight_objectives_panel_victory_conditions(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- victory_conditions_link
	--
	
	parser:add_record("campaign_victory_conditions_link", "script_link_campaign_victory_conditions_link", "tooltip_campaign_victory_conditions_link");
	tp_victory_conditions = tooltip_patcher:new("tooltip_campaign_victory_conditions_link");
	tp_victory_conditions:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_victory_conditions_link");
	
	tl_victory_conditions_link = tooltip_listener:new(
		"tooltip_campaign_victory_conditions_link",
		function()
			uim:highlight_objectives_panel_victory_conditions(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	


	--
	-- waaagh
	--

	hp_waaagh = help_page:new(
		"script_link_campaign_waaagh",
		hpr_title("war.camp.hp.waaagh.001"),
		hpr_leader("war.camp.hp.waaagh.002"),
		hpr_normal("war.camp.hp.waaagh.003"),
		hpr_normal("war.camp.hp.waaagh.004"),
		hpr_normal("war.camp.hp.waaagh.005"),
		hpr_normal("war.camp.hp.waaagh.006"),
		hpr_normal("war.camp.hp.waaagh.007")
	);
	parser:add_record("campaign_waaagh", "script_link_campaign_waaagh", "tooltip_campaign_waaagh");
	tp_waaagh = tooltip_patcher:new("tooltip_campaign_waaagh");
	tp_waaagh:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_waaagh", "ui_text_replacements_localised_text_hp_campaign_description_waaagh");

	--
	-- warbands
	--

	hp_warbands = help_page:new(
		"script_link_campaign_warbands",
		hpr_title("war.camp.hp.warbands.001"),
		hpr_leader("war.camp.hp.warbands.002"),
		hpr_normal("war.camp.hp.warbands.003"),
		hpr_normal("war.camp.hp.warbands.004"),
		hpr_normal("war.camp.hp.warbands.005")
	);
	parser:add_record("campaign_warbands", "script_link_campaign_warbands", "tooltip_campaign_warbands");
	tp_warbands = tooltip_patcher:new("tooltip_campaign_warbands");
	tp_warbands:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_warbands", "ui_text_replacements_localised_text_hp_campaign_description_warbands");


	--
	-- warmblood invaders
	--

	hp_warmblood_invaders = help_page:new(
		"script_link_campaign_warmblood_invaders",
		hpr_title("war.camp.hp.lizardmen_warmblood_invaders.001"),
		hpr_leader("war.camp.hp.lizardmen_warmblood_invaders.002"),
		hpr_normal("war.camp.hp.lizardmen_warmblood_invaders.003"),
		hpr_normal("war.camp.hp.lizardmen_warmblood_invaders.004")
	);
	parser:add_record("campaign_warmblood_invaders", "script_link_campaign_warmblood_invaders", "tooltip_campaign_warmblood_invaders");
	tp_warmblood_invaders = tooltip_patcher:new("tooltip_campaign_warmblood_invaders");
	tp_warmblood_invaders:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_lizardmen_warmblood_invaders", "ui_text_replacements_localised_text_hp_campaign_description_lizardmen_warmblood_invaders");
		

	--
	-- war
	--

	hp_war = help_page:new(
		"script_link_campaign_war",
		hpr_title("war.camp.hp.war.001"),
		hpr_leader("war.camp.hp.war.002"),
		hpr_normal("war.camp.hp.war.003"),
		hpr_normal("war.camp.hp.war.004"),
		hpr_normal("war.camp.hp.war.006")
	);
	parser:add_record("campaign_war", "script_link_campaign_war", "tooltip_campaign_war");
	tp_war = tooltip_patcher:new("tooltip_campaign_war");
	tp_war:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_war", "ui_text_replacements_localised_text_hp_campaign_description_war");



	--
	-- war_coordination
	--

	hp_war_coordination = help_page:new(
		"script_link_campaign_war_coordination",
		hpr_title("war.camp.hp.war_coordination.001"),
		hpr_leader("war.camp.hp.war_coordination.002"),

		hpr_section("allegiance"),
		hpr_normal_unfaded("war.camp.hp.war_coordination.003", "allegiance"),
		hpr_normal("war.camp.hp.war_coordination.004", "allegiance"),

		hpr_section("panel"),
		hpr_normal_unfaded("war.camp.hp.war_coordination.005", "panel"),
		hpr_normal("war.camp.hp.war_coordination.006", "panel"),

		hpr_section("targets"),
		hpr_normal_unfaded("war.camp.hp.war_coordination.007", "targets"),
		hpr_normal("war.camp.hp.war_coordination.008", "targets"),

		hpr_section("request_control"),
		hpr_normal_unfaded("war.camp.hp.war_coordination.009", "request_control"),
		hpr_normal("war.camp.hp.war_coordination.010", "request_control"),
		hpr_normal("war.camp.hp.war_coordination.011", "request_control"),

		hpr_section("outposts"),
		hpr_normal_unfaded("war.camp.hp.war_coordination.012", "outposts"),
		hpr_normal("war.camp.hp.war_coordination.013", "outposts"),

		hpr_section("missions"),
		hpr_normal_unfaded("war.camp.hp.war_coordination.014", "missions"),
		hpr_normal("war.camp.hp.war_coordination.015", "missions")
	);
	parser:add_record("campaign_war_coordination", "script_link_campaign_war_coordination", "tooltip_campaign_war_coordination");
	tp_war_coordination = tooltip_patcher:new("tooltip_campaign_war_coordination");
	tp_war_coordination:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_war_coordination", "ui_text_replacements_localised_text_hp_campaign_description_war_coordination");

	tl_war_coordination = tooltip_listener:new(
		"tooltip_campaign_war_coordination", 
		function() 
			uim:highlight_war_coordination(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- war_coordination_ally_missions_tab
	--

	parser:add_record("campaign_war_coordination_ally_missions_tab", "script_link_campaign_war_coordination_ally_missions_tab", "tooltip_campaign_war_coordination_ally_missions_tab");
	tp_war_coordination_ally_missions_tab = tooltip_patcher:new("tooltip_campaign_war_coordination_ally_missions_tab");
	tp_war_coordination_ally_missions_tab:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_war_coordination_ally_missions_tab");
	
	tl_war_coordination_ally_missions_tab = tooltip_listener:new(
		"tooltip_campaign_war_coordination_ally_missions_tab", 
		function() 
			uim:highlight_war_coordination_ally_missions(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- war_coordination_button
	--

	parser:add_record("campaign_war_coordination_button", "script_link_campaign_war_coordination_button", "tooltip_campaign_war_coordination_button");
	tp_war_coordination_button = tooltip_patcher:new("tooltip_campaign_war_coordination_button");
	tp_war_coordination_button:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_war_coordination_button");
	
	tl_war_coordination_button = tooltip_listener:new(
		"tooltip_campaign_war_coordination_button", 
		function() 
			uim:highlight_war_coordination(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- war_coordination_link
	--

	parser:add_record("campaign_war_coordination_link", "script_link_campaign_war_coordination_link", "tooltip_campaign_war_coordination_link");
	tp_war_coordination_link = tooltip_patcher:new("tooltip_campaign_war_coordination_link");
	tp_war_coordination_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_war_coordination_link");
	
	tl_war_coordination_link = tooltip_listener:new(
		"tooltip_campaign_war_coordination_link",
		function()
			uim:highlight_war_coordination(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- war_coordination_panel
	--

	parser:add_record("campaign_war_coordination_panel", "script_link_campaign_war_coordination_panel", "tooltip_campaign_war_coordination_panel");
	tp_war_coordination_panel = tooltip_patcher:new("tooltip_campaign_war_coordination_panel");
	tp_war_coordination_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_war_coordination_panel");
	
	tl_war_coordination_panel = tooltip_listener:new(
		"tooltip_campaign_war_coordination_panel", 
		function() 
			uim:highlight_war_coordination(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- war_coordination_outpost_tab
	--

	parser:add_record("campaign_war_coordination_outpost_tab", "script_link_campaign_war_coordination_outpost_tab", "tooltip_campaign_war_coordination_outpost_tab");
	tp_war_coordination_outpost_tab = tooltip_patcher:new("tooltip_campaign_war_coordination_outpost_tab");
	tp_war_coordination_outpost_tab:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_war_coordination_outpost_tab");
	
	tl_war_coordination_outpost_tab = tooltip_listener:new(
		"tooltip_campaign_war_coordination_outpost_tab", 
		function() 
			uim:highlight_war_coordination_outpost(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- war_coordination_request_army_tab
	--

	parser:add_record("campaign_war_coordination_request_army_tab", "script_link_campaign_war_coordination_request_army_tab", "tooltip_campaign_war_coordination_request_army_tab");
	tp_war_coordination_request_army_tab = tooltip_patcher:new("tooltip_campaign_war_coordination_request_army_tab");
	tp_war_coordination_request_army_tab:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_war_coordination_request_army_tab");
	
	tl_war_coordination_request_army_tab = tooltip_listener:new(
		"tooltip_campaign_war_coordination_request_army_tab", 
		function() 
			uim:highlight_war_coordination_request_army(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- war_coordination_set_target_tab
	--

	parser:add_record("campaign_war_coordination_set_target_tab", "script_link_campaign_war_coordination_set_target_tab", "tooltip_campaign_war_coordination_set_target_tab");
	tp_war_coordination_set_target_tab = tooltip_patcher:new("tooltip_campaign_war_coordination_set_target_tab");
	tp_war_coordination_set_target_tab:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_war_coordination_set_target_tab");
	
	tl_war_coordination_set_target_tab = tooltip_listener:new(
		"tooltip_campaign_war_coordination_set_target_tab", 
		function() 
			uim:highlight_war_coordination_set_target(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);


	
	--
	-- warriors_of_chaos
	--

	hp_warriors_of_chaos = help_page:new(
		"script_link_campaign_warriors_of_chaos",
		hpr_title("war.camp.hp.warriors_of_chaos.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/warriors_of_chaos.png"),
		hpr_leader("war.camp.hp.warriors_of_chaos.002"),
		hpr_normal("war.camp.hp.warriors_of_chaos.003"),

		hpr_section("dark_fortress"),
		hpr_normal_unfaded("war.camp.hp.warriors_of_chaos.004", "dark_fortress"),
		hpr_normal("war.camp.hp.warriors_of_chaos.005", "dark_fortress"),
		
		hpr_section("souls_resource"),
		hpr_normal_unfaded("war.camp.hp.warriors_of_chaos.006", "souls_resource"),
		hpr_normal("war.camp.hp.warriors_of_chaos.007", "souls_resource"),

		hpr_section("warbands"),
		hpr_normal_unfaded("war.camp.hp.warriors_of_chaos.008", "warbands"),
		hpr_normal("war.camp.hp.warriors_of_chaos.009", "warbands"),

		hpr_normal("war.camp.hp.warriors_of_chaos.010")
	);
	parser:add_record("campaign_warriors_of_chaos", "script_link_campaign_warriors_of_chaos", "tooltip_campaign_warriors_of_chaos");
	tp_warriors_of_chaos = tooltip_patcher:new("tooltip_campaign_warriors_of_chaos");
	tp_warriors_of_chaos:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_warriors_of_chaos",
		"ui_text_replacements_localised_text_hp_campaign_description_warriors_of_chaos",
		"UI/help_images/warriors_of_chaos.png"
	);
	
	
	
	--
	-- winds_of_magic
	--
	
	hp_winds_of_magic = help_page:new(
		"script_link_campaign_winds_of_magic",
		hpr_title("war.camp.hp.winds_of_magic.001"),
		hpr_leader("war.camp.hp.winds_of_magic.002"),
		hpr_normal("war.camp.hp.winds_of_magic.003"),
		hpr_normal("war.camp.hp.winds_of_magic.004"),
		hpr_normal("war.camp.hp.winds_of_magic.005"),

		hpr_section("chaos"),
		hpr_normal_unfaded("war.camp.hp.winds_of_magic.006", "chaos"),
		hpr_normal("war.camp.hp.winds_of_magic.007", "chaos"),
		hpr_normal("war.camp.hp.winds_of_magic.008", "chaos"),

		hpr_section("manipulation"),
		hpr_normal_unfaded("war.camp.hp.winds_of_magic.009", "manipulation"),
		hpr_normal("war.camp.hp.winds_of_magic.010", "manipulation"),

		hpr_section("storms_of_magic"),
		hpr_normal_unfaded("war.camp.hp.winds_of_magic.011", "storms_of_magic"),
		hpr_normal("war.camp.hp.winds_of_magic.012", "storms_of_magic")
	);
	parser:add_record("campaign_winds_of_magic", "script_link_campaign_winds_of_magic", "tooltip_campaign_winds_of_magic");
	tp_winds_of_magic = tooltip_patcher:new("tooltip_campaign_winds_of_magic");
	tp_winds_of_magic:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_winds_of_magic", "ui_text_replacements_localised_text_hp_campaign_description_winds_of_magic");
	
	tl_winds_of_magic = tooltip_listener:new(
		"tooltip_campaign_winds_of_magic",
		function()
			uim:highlight_winds_of_magic(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	--
	-- winds_of_magic_link
	--
	
	parser:add_record("campaign_winds_of_magic_link", "script_link_campaign_winds_of_magic_link", "tooltip_campaign_winds_of_magic_link");
	tp_winds_of_magic = tooltip_patcher:new("tooltip_campaign_winds_of_magic_link");
	tp_winds_of_magic:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_winds_of_magic_link");
	
	tl_winds_of_magic_link = tooltip_listener:new(
		"tooltip_campaign_winds_of_magic_link",
		function()
			uim:highlight_winds_of_magic(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- winds_of_magic_manipulation
	--

	hp_winds_of_magic_manipulation = help_page:new(
		"script_link_campaign_winds_of_magic_manipulation",
		hpr_title("war.camp.hp.winds_of_magic_manipulation.001"),
		hpr_leader("war.camp.hp.winds_of_magic_manipulation.002"),
		hpr_normal("war.camp.hp.winds_of_magic_manipulation.003"),
		hpr_normal("war.camp.hp.winds_of_magic_manipulation.004"),
		hpr_normal("war.camp.hp.winds_of_magic_manipulation.005")
	);
	parser:add_record("campaign_winds_of_magic_manipulation", "script_link_campaign_winds_of_magic_manipulation", "tooltip_campaign_winds_of_magic_manipulation");
	tp_winds_of_magic_manipulation = tooltip_patcher:new("tooltip_campaign_winds_of_magic_manipulation");
	tp_winds_of_magic_manipulation:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_winds_of_magic_manipulation", "ui_text_replacements_localised_text_hp_campaign_description_winds_of_magic_manipulation");

	tl_winds_of_magic_manipulation = tooltip_listener:new(
		"tooltip_campaign_winds_of_magic_manipulation", 
		function() 
			uim:highlight_winds_of_magic_manipulation(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- winds_of_magic_manipulation_link
	--

	parser:add_record("campaign_winds_of_magic_manipulation_link", "script_link_campaign_winds_of_magic_manipulation_link", "tooltip_campaign_winds_of_magic_manipulation_link");
	tp_winds_of_magic_manipulation_link = tooltip_patcher:new("tooltip_campaign_winds_of_magic_manipulation_link");
	tp_winds_of_magic_manipulation_link:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_winds_of_magic_manipulation_link");
	
	tl_winds_of_magic_manipulation_link = tooltip_listener:new(
		"tooltip_campaign_winds_of_magic_manipulation_link",
		function()
			uim:highlight_winds_of_magic_manipulation(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- winds_of_magic_manipulation_panel
	--

	parser:add_record("campaign_winds_of_magic_manipulation_panel", "script_link_campaign_winds_of_magic_manipulation_panel", "tooltip_campaign_winds_of_magic_manipulation_panel");
	tp_winds_of_magic_manipulation_panel = tooltip_patcher:new("tooltip_campaign_winds_of_magic_manipulation_panel");
	tp_winds_of_magic_manipulation_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_winds_of_magic_manipulation_panel");
	
	tl_winds_of_magic_manipulation_panel = tooltip_listener:new(
		"tooltip_campaign_winds_of_magic_manipulation_panel", 
		function() 
			uim:highlight_winds_of_magic_manipulation(true);
		end,
		function() 
			uim:unhighlight_all_for_tooltips();
		end
	);



	--
	-- winds_of_magic_power_reserve_bar
	--
	
	parser:add_record("campaign_winds_of_magic_power_reserve_bar", "script_link_campaign_winds_of_magic_power_reserve_bar", "tooltip_campaign_winds_of_magic_power_reserve_bar");
	tp_winds_of_magic_power_reserve_bar = tooltip_patcher:new("tooltip_campaign_winds_of_magic_power_reserve_bar");
	tp_winds_of_magic_power_reserve_bar:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_description_winds_of_magic_power_reserve_bar");
	
	tl_winds_of_magic_power_reserve_bar = tooltip_listener:new(
		"tooltip_campaign_winds_of_magic_power_reserve_bar",
		function()
			uim:highlight_winds_of_magic(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);

	
	
	--
	-- witchs hut
	--

	hp_witchs_hut = help_page:new(
		"script_link_campaign_witchs_hut",
		hpr_title("war.camp.hp.witchs_hut.001"),
		hpr_leader("war.camp.hp.witchs_hut.002"),
		hpr_normal("war.camp.hp.witchs_hut.003"),
		hpr_normal("war.camp.hp.witchs_hut.004"),
		hpr_normal("war.camp.hp.witchs_hut.005"),
		hpr_normal("war.camp.hp.witchs_hut.006"),
		hpr_normal("war.camp.hp.witchs_hut.007")
	);
	parser:add_record("campaign_witchs_hut", "script_link_campaign_witchs_hut", "tooltip_campaign_witchs_hut");
	tp_witchs_hut = tooltip_patcher:new("tooltip_campaign_witchs_hut");
	tp_witchs_hut:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_witchs_hut", "ui_text_replacements_localised_text_hp_campaign_description_witchs_hut");



	--
	-- witchs_hut_panel
	--

	parser:add_record("campaign_witchs_hut_panel", "script_link_campaign_witchs_hut_panel", "tooltip_campaign_witchs_hut_panel");
	tp_witchs_hut_panel = tooltip_patcher:new("tooltip_campaign_witchs_hut_panel");
	tp_witchs_hut_panel:set_layout_data("tooltip_text_only", "ui_text_replacements_localised_text_hp_campaign_title_witchs_hut_panel");
	
	tl_witchs_hut_panel = tooltip_listener:new(
		"tooltip_campaign_witchs_hut_panel",
		function()
			uim:highlight_witchs_hut_panel(true);
		end,
		function()
			uim:unhighlight_all_for_tooltips();
		end
	);
	
	
	
	--
	-- wood elves
	--
	
	hp_wood_elves = help_page:new(
		"script_link_campaign_wood_elves",
		hpr_title("war.camp.hp.wood_elves.001"),
		hpr_image("war.camp.hp.image", "UI/help_images/wood_elves.png"),
		hpr_leader("war.camp.hp.wood_elves.002"),
		hpr_normal("war.camp.hp.wood_elves.003"),
		hpr_normal("war.camp.hp.wood_elves.004"),
		hpr_normal("war.camp.hp.wood_elves.005"),
		hpr_normal("war.camp.hp.wood_elves.006"),
		hpr_normal("war.camp.hp.wood_elves.007")
	);
	parser:add_record("campaign_wood_elves", "script_link_campaign_wood_elves", "tooltip_campaign_wood_elves");
	tp_wood_elves = tooltip_patcher:new("tooltip_campaign_wood_elves");
	tp_wood_elves:set_layout_data(
		"tooltip_title_text_and_image",
		"ui_text_replacements_localised_text_hp_campaign_title_wood_elves",
		"ui_text_replacements_localised_text_hp_campaign_description_wood_elves",
		"UI/help_images/wood_elves.png"
	);

	
	
	--
	-- worldroots [NEW]
	--

	hp_worldroots = help_page:new(
		"script_link_campaign_worldroots",
		hpr_title("war.camp.hp.wood_elves_new_worldroots.001"),
		hpr_leader("war.camp.hp.wood_elves_new_worldroots.002"),
		hpr_normal("war.camp.hp.wood_elves_new_worldroots.003"),
		hpr_normal("war.camp.hp.wood_elves_new_worldroots.004"),
		hpr_normal("war.camp.hp.wood_elves_new_worldroots.005"),
		hpr_normal("war.camp.hp.wood_elves_new_worldroots.006"),
		hpr_normal("war.camp.hp.wood_elves_new_worldroots.007")
	);
	parser:add_record("campaign_worldroots", "script_link_campaign_worldroots", "tooltip_campaign_worldroots");
	tp_worldroots = tooltip_patcher:new("tooltip_campaign_worldroots");
	tp_worldroots:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_wood_elves_new_worldroots", "ui_text_replacements_localised_text_hp_campaign_description_wood_elves_new_worldroots");
	
	

	--
	-- wulfharts hunters
	--

	hp_wulfharts_hunters = help_page:new(
		"script_link_campaign_wulfharts_hunters",
		hpr_title("war.camp.hp.empire_wulfharts_hunters.001"),
		hpr_leader("war.camp.hp.empire_wulfharts_hunters.002"),
		hpr_normal("war.camp.hp.empire_wulfharts_hunters.003"),
		hpr_normal("war.camp.hp.empire_wulfharts_hunters.004")
	);
	parser:add_record("campaign_wulfharts_hunters", "script_link_campaign_wulfharts_hunters", "tooltip_campaign_wulfharts_hunters");
	tp_wulfharts_hunters = tooltip_patcher:new("tooltip_campaign_wulfharts_hunters");
	tp_wulfharts_hunters:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_empire_wulfharts_hunters", "ui_text_replacements_localised_text_hp_campaign_description_empire_wulfharts_hunters");
		
	
	--
	-- zones_of_control
	--

	hp_zones_of_control = help_page:new(
		"script_link_campaign_zones_of_control",
		hpr_title("war.camp.hp.zones_of_control.001"),
		hpr_leader("war.camp.hp.zones_of_control.002"),
		hpr_normal("war.camp.hp.zones_of_control.003"),
		hpr_normal("war.camp.hp.zones_of_control.004"),
		hpr_normal("war.camp.hp.zones_of_control.006")
	);
	parser:add_record("campaign_zones_of_control", "script_link_campaign_zones_of_control", "tooltip_campaign_zones_of_control");
	tp_zones_of_control = tooltip_patcher:new("tooltip_campaign_zones_of_control");
	tp_zones_of_control:set_layout_data("tooltip_title_and_text", "ui_text_replacements_localised_text_hp_campaign_title_zones_of_control", "ui_text_replacements_localised_text_hp_campaign_description_zones_of_control");

	
end;


----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------
-- cheat sheet functions
----------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------


function show_campaign_controls_cheat_sheet()
	hp_controls_cheat_sheet:link_clicked();
	local hpm = get_help_page_manager();
	hpm:set_max_height(600);
	hpm:show_title_bar_buttons(false, false);
	
	local uic_panel = hpm:get_uicomponent();
	local uic_listview = find_uicomponent(uic_panel, "listview");
	
	uic_listview:SetCanResizeWidth(true);
	uic_panel:SetCanResizeWidth(true);
	uic_panel:Resize(260, uic_panel:Height());
	uic_panel:SetCanResizeWidth(false);
	uic_listview:SetCanResizeWidth(false);
	
	local screen_x, screen_y = core:get_screen_resolution();
	local panel_x, panel_y = uic_panel:Position();
	local panel_size_x, panel_size_y = uic_panel:Bounds();
	
	uic_panel:MoveTo(screen_x - panel_size_x, 1);
end;





-- don't run the setup function until the UI is created
cm:add_pre_first_tick_callback(function() setup_campaign_help_pages() end);