
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	CAMPAIGN SCRIPT
--	This file gets loaded before any of the faction scripts
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------


-------------------------------------------------------
--	Game Startup Callbacks - These callbacks perform various first-tick tasks, such as invoking all other feature managers, and beggining the faction intro cutscenes.
-------------------------------------------------------
cm:add_pre_first_tick_callback(
	function()
		-- load the rite unlock listeners when the ui is loaded
		rite_unlock_listeners();
		
		initiative_unlock_listeners();
		faction_initiatives_unlocker:initiatives_unlocker_listeners()
		
		load_followers();
	end
);

cm:add_first_tick_callback_new(
	function()
		-- Either run the campaign benchmark if in benchmark mode, or load and perform the faction intro.
		cm:show_benchmark_if_required(
			function()
				-- Perform the start-of-campaign dressing for all players.
				local human_factions = cm:get_human_factions();
				if #human_factions > 0 then
					for i = 1, #human_factions do
						faction_intro:perform_intro("main_warhammer", human_factions[i]);
					end;
				end;
			end, 
			"campaign_benchmark_ie_01"
		);
	end
);

cm:add_first_tick_callback(
	function()
		-- call the start_game_all_factions() function if it exists
		if is_function(start_game_all_factions) then
			start_game_all_factions();
		end;
	end
);

function start_game_all_factions()
	out("start_game_all_factions() called");
	out.inc_tab();
	
	-- start all scripted behaviours that should apply across all campaigns
	setup_wh_campaign();
	
	-- load the quests script
	q_setup();
	
	-- load the campaign quest battle listners script
	set_piece_battle_abilities:initialise();

	-- load the Grudges script
	attempt_to_load_grudges_script();
	
	-- load the horde reemergence script
	add_horde_reemergence_listeners();
	
	add_slann_selection_listeners();
	add_tech_tree_lords_listeners();
	confed_missions:setup();
	
	Forced_Battle_Manager:load_listeners();
	
	-- add campaign map feature listeners
	add_great_desert_sandstorm_listener();

	-- disable tax and public order for fortress gates
	disable_tax_and_public_order_for_regions(
		{
			"wh3_main_combi_region_eagle_gate",
			"wh3_main_combi_region_griffon_gate",
			"wh3_main_combi_region_phoenix_gate",
			"wh3_main_combi_region_unicorn_gate",
			"wh3_main_combi_region_fort_bergbres",
			"wh3_main_combi_region_helmgart",
			"wh3_main_combi_region_fort_soll",
			"wh3_main_combi_region_the_oak_of_ages"
		}
	);
	
	if cm:is_new_game() then
		-- setup subculture-specific diplomacy option exclusions
		apply_default_diplomacy();
		award_faction_trait_effect_bundles_for_vampires();
		award_faction_trait_effect_bundles_for_vlad();
		-- save the chosen legendary lords so we do not unlock them later on
		store_starting_generals();
		-- Give Belegar and his agents start exp
		belegar_start_experience();
		-- If player is a DLC06 faction setup Eight Peaks
		eight_peaks_setup();
		-- add warhorse to louen - adding in start pos has issues
		local bretonnia = cm:get_faction("wh_main_brt_bretonnia");
		if bretonnia then
			cm:force_add_ancillary(bretonnia:faction_leader(), "wh_main_anc_mount_brt_louen_barded_warhorse", true, true);
		end;
		local varg = cm:get_faction("wh_main_nor_varg");
		if varg then
			cm:force_add_ancillary(varg:faction_leader(), "wh_dlc10_anc_mount_nor_surtha_ek_marauder_chariot", true, true);
		end;
		-- Starting Vows
		add_starting_vows();
		-- Add Ungrim start mission
		local karak_kadrin = cm:get_faction("wh_main_dwf_karak_kadrin");
		if karak_kadrin and karak_kadrin:is_human() then
			local mm = mission_manager:new("wh_main_dwf_karak_kadrin", "wh2_main_dwf_ungrim_start_mission");
			mm:add_new_objective("CAPTURE_REGIONS");
			mm:add_condition("region wh3_main_combi_region_gnashraks_lair");
			mm:add_condition("ignore_allies");
			mm:add_payload("money 1000");
			mm:add_payload("faction_pooled_resource_transaction{resource dwf_oathgold;factor grudges;amount 30;context absolute;}");
			mm:set_should_whitelist(false);
			mm:trigger();
		end;
		
		--Campaign Custom Starts
		out("==== Custom Starts ====");
		custom_starts:add_campaign_custom_start_listeners();

		add_starting_corruption();
	end
	
	start_narrative_events();

	-- Corruption Swing
	out("==== Corruption Swing ====")
	corruption_swing:setup();
	
	-- DLC03 Beastmen Features
	out("==== Beastman ====");
	beastmen_moon:add_moon_phase_listeners();
	add_beastmen_final_battle_listener();
	
	-- DLC06 Karak Features
	out("==== Karak ====");
	apply_karak_diplomacy();
	add_grombrindal_listeners();
	
	-- DLC05 Wood Elves Features
	out("==== Wood Elves ====");
	Add_Wood_Elves_Listeners();

	-- DLC06 Karak Eight Peaks Features
	Add_Karak_Eight_Peaks_Listeners();
	
	-- DLC07 Bretonnia Features
	out("==== Bretonnia ====");
	Add_Bretonnia_Listeners();
	Add_Lady_Blessing_Listeners();
	Add_Bretonnia_Technology_Listeners();
	Add_Peasant_Economy_Listeners();
	Add_Virtues_and_Traits_Listeners();
	Add_Chivalry_Listeners();
	add_green_knight_listeners();
	vlad_isabella:initialize_vlad_isabella();
	
	-- DLC08 Norsca Features
	out("==== Norsca ====");
	Add_Norsca_Listeners();
	Add_Norscan_Gods_Listeners();
	Add_Nurgle_Plague_Listeners();
	
	-- DLC09 Tomb Kings Features
	out("==== Tomb Kings ====");
	add_tomb_kings_listeners();
	add_nagash_books_listeners();
	add_nagash_books_effects_listeners();
	add_dynasty_tree_listeners();
	
	-- DLC10 Queen & Crone Features
	out("==== Queen & Crone ====");
	add_alarielle_listeners();
	death_night:add_hellebron_listeners();
	add_alith_anar_listeners();
	sword_of_khaine:initialise();
	
	-- DLC11 Vampire Coast Features
	out("==== Vampire Coast ====");
	add_vampire_coast_listeners();
	infamy:add_infamy_listeners();
	add_vampire_coast_tech_tree_listeners();
	add_treasure_maps_listeners();
	roving_pirates:add_roving_pirates_listeners();
	lohkir_arks:add_lokhir_listeners()
	add_ship_upgrade_listeners();
	setup_encounters_at_sea_listeners();
	vampire_bloodlines:add_bloodlines_listeners();
	
	-- DLC12 Prophet & Warlock Features
	out("==== Prophet & Warlock ====");
	add_under_empire_listeners();
	initialize_workshop_listeners();
	cult_of_sotek:add_tehenhauin_listeners();
	
	-- DLC13 Hunter & Beast Features
	out("==== Hunter & Beast ====");
	add_empire_politics_listeners();
	add_wulfhart_imperial_supply_listeners();
	add_wulfhart_hunters_listeners();
	nakai_temples:add_nakai_temples_listeners();
	
	-- PRO08 Gotrek & Felix Features
	add_gotrek_felix_listeners();
	
	-- DLC14 The Shadow & The Blade
	out("==== Shadow & Blade ====");
	malus_favour:add_malus_malekiths_favour_listeners()
	malus_sanity:add_malus_sanity_listeners()
	add_tzarkans_whispers_listeners();
	add_shadowy_dealings_listeners();
	add_clan_contracts_listeners();
	add_repanse_confederation_listeners();
	add_snikch_revitalizing_listeners();

	-- DLC15 The Warden & The Paunch
	out("==== Warden & Paunch ====");
	add_eltharion_lair_listeners();
	add_eltharion_mist_listeners();
	add_eltharion_yvresse_defence_listeners();
	Eltharion_Duo_Start_Dilemma:add_yvresse_region_change_listeners();
	add_dragon_encounters_listeners();
	add_grom_food_listeners();
	add_grom_story_listeners();
	salvage:initialise()
	waaagh:add_waaagh_listeners();


	---DLC16 The Twisted & the Twilight
	out("==== Twisted & Twilight ====");
	Worldroots:add_worldroots_listeners();
	add_sisters_forge_listeners();
	add_flesh_lab_listeners();
	add_drycha_coeddil_unchained_listeners();

	---TWA03 Rakarth----
	out("==== Rakarth ====");
	RakarthBeastHunts:setup_rakarth_listeners()

	---DLC17 - The Silence and the Fury
	out("==== Silence & Fury =====")
	thorek:initialise();
	add_oxyotl_sanctum_listeners();
	add_oxyotl_threat_map_listeners();
	add_beast_tech_lock_listeners();
	Bloodgrounds:setup();
	add_taurox_rampage_listeners();
	Ruination:add_ruination_listeners();

	-- WH2
	blessed_spawnings:setup_blessed_spawnings();
	def_slaves:start_listeners();

	-- WH3
	setup_ogre_contracts();
	setup_khorne_skulls();
	setup_ice_court_ai();
	setup_kislev_devotion();
	setup_slaanesh_devotees();
	recruited_unit_health:initialise()
	Seductive_Influence:initialise()
	setup_daemon_cults();
	greater_daemons:setup_greater_daemons();
	great_game_start();
	Bastion:great_bastion_start();
	sea_lanes:initiate_sea_lanes();
	belakor_daemon_prince_creation:start();
	add_volkmar_elector_count_units_listener();
	victory_objectives_ie:add_scripted_victory_listeners()
	scripted_occupation_options:initialise()
	scripted_technology_tree:start_technology_listeners()
	caravans:initialise()
	harmony:initialise()
	campaign_ai_script:setup_listeners()


	---Champions of Chaos
	CUS:initialise()
	norscan_homeland:initialise()
	vassal_dilemmas:initialise()
	dark_authority:initialise()
	eye_of_the_gods:initialise()

	-- Chaos Dwarfs
	chaos_dwarf_labour_loss:labour_loss()
	chaos_dwarf_efficiency:set_efficiency()
	tower_of_zharr:initialise()
	character_unlocking:setup_legendary_hero_unlocking()
	hellforge:setup_listeners()
	chaos_dwarf_labour_move:setup_listeners()
	chd_labour_raid:start_listeners()
	chaos_dwarf_relics_ie:initialise()
	
	-- dlc24
	jade_dragon_start:initialise()
	mother_ostankya_features:initialise()
	matters_of_state:initialise()
	the_changeling_features:initialise()
	
	out.dec_tab();
end;

core:add_listener(
	"default_diplomacy_listener",
	"ScriptEventAllDiplomacyEnabled",
	true,
	function(context) apply_default_diplomacy() end,
	true
);

function is_major_port(region)
	return region:is_province_capital() and not region:is_abandoned() and region:settlement():is_port() and not region:owning_faction():is_rebel();
end;

function show_benchmark_camera_pan_if_required(callback)
	if not is_function(callback) then
		script_error("ERROR: show_benchmark_camera_pan_if_required() called but supplied callback [" .. tostring(callback) .. "] is not a function");
		return false;
	end;
	
	if not cm:is_benchmark_mode() then
		-- don't do benchmark camera pan
		callback();
		return;
	end;
	
	local ui_root = core:get_ui_root();
	
	core:svr_save_bool("sbool_should_run_campaign_benchmark", false);
	
	cm:set_camera_position(487.6, 111.0, 24.5, 0.0, 24.0);
	cm:show_shroud(false);
	CampaignUI.ToggleCinematicBorders(true);
	ui_root:LockPriority(50)
	--cm:steal_user_input(true);
	cm:override_ui("disable_settlement_labels", true);
	cm:cindy_playback("script/campaign_demo/scenes/camp_demo_cam_pan_01.CindyScene", 0, 5);
	
	cm:callback(
		function()
			--cm:steal_user_input(false);
			ui_root:UnLockPriority()
			ui_root:InterfaceFunction("QuitForScript");
		end,
		74.3
	);
end;



function award_faction_trait_effect_bundles_for_vampires()
	local player_faction = cm:get_faction("wh_main_vmp_vampire_counts");
	
	if player_faction:is_human() then
		local helman_name = "names_name_2147358044";
		local character_list = player_faction:character_list();
		cm:disable_event_feed_events(true, "wh_event_category_traits_ancillaries", "", "");
		
		for i = 0, character_list:num_items() - 1 do
			local current_char = character_list:item_at(i);
			
			if current_char:get_forename() == helman_name then
				cm:force_add_trait("character_cqi:" .. current_char:cqi(), "wh_trait_dlc04_helman_not_shown", true);
			end;
		end;
		
		cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_traits_ancillaries", "", "") end, 1);
	end;
end;


function award_faction_trait_effect_bundles_for_vlad()
	local player_faction = cm:get_faction("wh_main_vmp_schwartzhafen");
	
	if player_faction:is_human() then
		local vlad_name = "names_name_2147345130";
		local character_list = player_faction:character_list();
		cm:disable_event_feed_events(true, "wh_event_category_traits_ancillaries", "", "");
		
		for i = 0, character_list:num_items() - 1 do
			local current_char = character_list:item_at(i);
			
			if current_char:get_forename() == vlad_name then
				cm:force_add_trait("character_cqi:" .. current_char:cqi(), "wh_trait_dlc04_vlad_vanguard_not_shown", true);
			end;
		end;
		
		cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_traits_ancillaries", "", "") end, 1);
	end;
end;



function add_beastmen_final_battle_listener()
	if not cm:get_saved_value("bst_final_battle_quest") then
		core:add_listener(
			"Beastmen_Final_Battle",
			"ScriptEventHumanFactionTurnStart",
			function(context)
				return context:faction():name() == "wh_dlc03_bst_beastmen" and are_all_beastmen_final_battle_factions_dead();
			end,
			function()
				cm:trigger_mission("wh_dlc03_bst_beastmen", "wh_dlc03_qb_bst_the_final_battle", true);
				cm:set_saved_value("bst_final_battle_quest", true);
			end,
			false
		);
	end;
end;

function are_all_beastmen_final_battle_factions_dead()
	local factions = {
		"wh_main_emp_averland",
		"wh_main_emp_hochland",
		"wh_main_emp_middenland",
		"wh_main_emp_nordland",
		"wh_main_emp_ostland",
		"wh_main_emp_ostermark",
		"wh_main_emp_stirland",
		"wh_main_emp_talabecland",
		"wh_main_emp_wissenland",
		"wh_main_emp_empire",
		"wh_main_brt_bretonnia"
	};
	
	for i = 1, #factions do
		if not cm:get_faction(factions[i]):is_dead() then
			return false;
		end;
	end;
	
	return true;
end;

cm:add_first_tick_callback_new(function()
	-- sets up the starting seduction influence for nkari/saphery
	local saphery_faction_key = "wh2_main_hef_saphery"
	local faction_cqi = cm:get_faction("wh3_main_sla_seducers_of_slaanesh"):command_queue_index()
	local region_cqi = cm:get_region("wh3_main_combi_region_white_tower_of_hoeth"):cqi()
	local foreign_slot = cm:add_foreign_slot_set_to_region_for_faction(faction_cqi, region_cqi, "wh3_main_slot_set_sla_cult")
	local slot = foreign_slot:slots():item_at(0)
	local hef_trait = cm:create_new_custom_effect_bundle("wh2_main_faction_trait_high_elves")

	cm:foreign_slot_instantly_upgrade_building(slot, "wh3_main_sla_cult_2")

	cm:faction_add_pooled_resource(saphery_faction_key, "wh3_main_sla_seductive_influence", "cults", 175)

	-- removes the -5 natural high elf resistance from this faction.
	hef_trait:remove_effect_by_key("wh3_main_effect_pooled_resource_seductive_influence_culture")
	cm:apply_custom_effect_bundle_to_faction(hef_trait, cm:get_faction(saphery_faction_key))
end)

--- Great desert of araby permanent sandstorm===
function add_great_desert_sandstorm_listener()
	core:add_listener(
		"great_desert_sandstorm_listener",
		"FactionRoundStart",
		function(context)
			local region = cm:get_region("wh3_main_combi_region_great_desert_of_araby")
			if region:has_active_storm() == false then
				return true
			end
			return false
		end,
		function(context)
			cm:create_storm_for_region("wh3_main_combi_region_great_desert_of_araby",1,0,"land_storm")
		end,
		true
	);
end
