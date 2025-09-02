--[[--- WORLDROOTS ---]]--

-------------
--VARIABLES--
-------------
Worldroots = {
	primary_player_key = "",
	
	-- POOLED RESOURCE VALUES
	-- adjacent regions
	pacified_value = 1,
	hostile_value = -1,
	razing_value = 5, -- needs to match dummy display in db
	battle_value = 2,
	-- corruption
	corruption_threshold = 50, -- amount of total corruption that a province must have to add the penalty each turn
	corruption_penalty = -1,
	-- markers
	peaceful_resolution_value = 10, -- needs to match dummy display in db
	battle_resolution_value = 10, -- needs to match dummy display in db
	
	-- CAMPAIGN VARIABLES
	primary_forest = "athel_loren", -- used in various places e.g. to define central glade for vfx
	marker_cooldown = 5, -- cooldown between markers. note this will tick twice as fast in MP
	turns_since_last_marker = 5,
	debug_ignore_marker_cooldown = false, -- set to true to cause a marker to spawn every turn, ignorning first-turn restrictions
	avelorn_invasion_turn = 45,
	avelorn_invasion_duration = 5, -- after this many turns the game will release control of the spawned Avelorn invasion and re-allow CAI targeting of the ruins
	ritual_resource_required_default = 100, -- standard amount of pooled resource required to trigger the Ritual of Rebirth. Used to check if we should fire an incident saying it's ready.
	
	-- INVASION VARIABLES
	invasion_power_modifier = 1, -- modfier for calculating composition of spawned armies. will update as campaign goes on.
	invasion_force_strength = 20, -- how big the forces that spawn are
	invasion_force_interruption_modifiers = { -- modifier to army size if invasion interrupted before spawning
		["invasion_marker_3"] = -10,
		["invasion_marker_2"] = -5,
		["invasion_marker_1"] = -3
	},
	invasion_force_interrupted_effect_bundle  = "wh2_dlc16_bundle_scripted_wood_elf_encounter", -- effect bundle to apply to interrupted invasion spawns
	
	-- VFX VARIABLES
	ritual_vfx_key = "wh2_dlc16_wef_healing_ritual",
	teleport_vfx_key = "wh2_dlc16_wef_worldroots_teleport",
	ritual_finished_vfx_key = "wh2_dlc16_wef_worldroots_teleport"
}

----------------
--FORESTS DATA--
----------------
Worldroots.forests = {
	athel_loren = {
		key = "athel_loren",
		pooled_resource = "wef_worldroots_athel_loren",
		glade_region_key = "wh3_main_combi_region_the_oak_of_ages",
		additional_regions = { -- optional - if we have extra regions we want to check for the presence of buildings etc.
			"wh3_main_combi_region_crag_halls_of_findol",
			"wh3_main_combi_region_kings_glade",
			"wh3_main_combi_region_vauls_anvil_loren",
			"wh3_main_combi_region_waterfall_palace",
		},
		rite_key = "wh2_dlc16_ritual_rebirth_athel_loren",
		invasion_faction = "wh2_dlc13_bst_beastmen_invasion",
		invasion_force_key  = "athel_loren_beastmen_invasion",
		invasion_spawn_coords = {{547, 516}, {467, 517}, {423, 577}, {461, 547}},
		rite_completed = false,
		rite_active = false,
		locked_building = "wh_dlc05_wef_oak_of_ages_5",
		region_group = "wh2_dlc16_forest_region_group_main_1",
		custom_ritual_completion_callback = -- optional
			function(faction_key)
				cm:trigger_mission(faction_key, "wh_dlc05_qb_wef_grand_defense_of_the_oak", true, true)
			end,
		ritual_resource_required_override = 500
	},
	laurelorn = {
		key = "laurelorn",
		pooled_resource = "wef_worldroots_laurelorn",
		glade_region_key = "wh3_main_combi_region_laurelorn_forest",
		rite_key = "wh2_dlc16_ritual_rebirth_laurelorn",
		invasion_faction = "wh2_dlc13_nor_norsca_invasion",
		invasion_force_key = "laurelorn_norscan_invasion",
		invasion_spawn_coords = {{489, 748}, {513, 751}, {567, 763}},
		locked_building = "wh2_main_special_salzenmund_laurelorn_wef_1",
		rite_completed = false,
		rite_active = false,
		region_group = "wh2_dlc16_forest_region_group_main_2"
	},
	gaean_vale = {
		key = "gaean_vale",
		pooled_resource = "wef_worldroots_gaean_vale",
		glade_region_key = "wh3_main_combi_region_gaean_vale",
		rite_key = "wh2_dlc16_ritual_rebirth_gaean_vale",
		invasion_faction = "wh2_dlc16_chs_acolytes_of_the_keeper",
		invasion_force_key = "gaean_vale_chaos_invasion",
		invasion_spawn_coords = {{245, 629}, {207, 574}, {297, 575}},
		locked_building = "wh2_main_special_everqueen_court_wef",
		rite_completed = false,
		rite_active = false,
		region_group = "wh2_dlc16_forest_region_group_main_6"
	},
	heart_of_the_jungle = {
		key = "heart_of_the_jungle",
		pooled_resource = "wef_worldroots_heart_of_the_jungle", 
		glade_region_key = "wh3_main_combi_region_oreons_camp",
		rite_key = "wh2_dlc16_ritual_rebirth_heart_of_the_jungle", 
		invasion_faction = "wh2_dlc16_grn_savage_invasion",
		invasion_force_key = "heart_of_the_jungle_greenskins_invasion",
		invasion_spawn_coords = {{606, 208}, {600, 236}, {641, 238}},
		locked_building = "wh_dlc05_wef_temple_kurnous_1",
		rite_completed = false,
		rite_active = false,
		region_group = "wh2_dlc16_forest_region_group_main_8"
	},
	gryphon_wood = {
		key = "gryphon_wood",
		pooled_resource = "wef_worldroots_gryphon_wood",
		glade_region_key = "wh3_main_combi_region_gryphon_wood",
		rite_key = "wh2_dlc16_ritual_rebirth_gryphon_wood",
		invasion_faction = "wh2_dlc16_wef_drycha",
		invasion_faction_alternate = "wh2_dlc16_emp_empire_invasion",
		invasion_force_key = "gryphon_wood_invasion",
		invasion_spawn_coords = {{694, 697}, {644, 663}, {706, 657}},
		locked_building = "wh_dlc05_wef_temple_ereth_khial_1",
		rite_completed = false,
		rite_active = false,
		region_group = "wh2_dlc16_forest_region_group_main_3"
	},
	forest_of_gloom = {
		key = "forest_of_gloom",
		pooled_resource = "wef_worldroots_vale_of_webs",
		glade_region_key = "wh3_main_combi_region_forest_of_gloom",
		rite_key = "wh2_dlc16_ritual_rebirth_vale_of_webs",
		invasion_faction = "wh2_dlc13_grn_greenskins_invasion",
		invasion_force_key = "vale_of_webs_forest_goblin_invasion",
		invasion_spawn_coords = {{721, 531}, {695, 536}, {673, 549}},
		locked_building = "wh2_dlc16_special_forest_of_gloom_shadow_groves_of_loec",
		rite_completed = false,
		rite_active = false,
		region_group = "wh2_dlc16_forest_region_group_main_4"
	},
	witchwood = {
		key = "witchwood",
		pooled_resource = "wef_worldroots_naggarond_glade",
		glade_region_key = "wh3_main_combi_region_the_witchwood",
		rite_key = "wh2_dlc16_ritual_rebirth_naggarond_glade",
		invasion_faction = "wh2_main_skv_clan_moulder",
		invasion_faction_alternate = "wh2_dlc13_skv_skaven_invasion",
		invasion_force_key = "naggaroth_glade_skaven_invasion",
		invasion_spawn_coords = {{81, 676}, {88, 651}, {45, 648}},
		locked_building = "wh_dlc05_wef_temple_anath_raema_1",
		rite_completed = false,
		rite_active = false,
		region_group = "wh2_dlc16_forest_region_group_main_7",
		ritual_resource_required_override = 300
	},
	emerald_pools = {
		key = "emerald_pools",
		pooled_resource = "wef_worldroots_emerald_pools",
		glade_region_key = "wh3_main_combi_region_the_sacred_pools",
		rite_key = "wh2_dlc16_ritual_rebirth_emerald_pools",
		invasion_faction = "wh2_dlc16_emp_colonist_invasion",
		invasion_force_key = "emerald_pools_colonists_invasion",
		invasion_spawn_coords = {{155, 247}, {173, 267}, {132, 268}},
		locked_building = "wh2_dlc16_special_sacred_pools_wef",
		rite_completed = false,
		rite_active = false,
		region_group = "wh2_dlc16_forest_region_group_main_5"
	},
	jungles_of_chian = {
		key = "jungles_of_chian",
		pooled_resource = "wef_worldroots_jungles_of_chian",
		glade_region_key = "wh3_main_combi_region_jungles_of_chian",
		rite_key = "wh2_dlc16_ritual_rebirth_jungles_of_chian",
		invasion_faction = "wh3_main_tze_tzeentch_invasion",
		invasion_force_key = "wh3_main_sc_tze_tzeentch",
		invasion_spawn_coords = {{1260, 392}, {1345, 366}, {1278, 414}},
		locked_building = "wh3_main_ie_special_jungles_of_chian_bamboo_grove",
		rite_completed = false,
		rite_active = false,
		region_group = "wh2_dlc16_forest_region_group_main_9"
	},
	the_haunted_forest = {
		key = "the_haunted_forest",
		pooled_resource = "wef_worldroots_the_haunted_forest",
		glade_region_key = "wh3_main_combi_region_the_haunted_forest",
		rite_key = "wh2_dlc16_ritual_rebirth_the_haunted_forest",
		invasion_faction = "wh3_main_ogr_ogre_kingdoms_invasion",
		invasion_force_key = "wh3_main_sc_ogr_ogre_kingdoms",
		invasion_spawn_coords = {{1086, 445}, {991, 444}, {964, 446}},
		locked_building = "wh3_main_ie_special_the_haunted_forest_gnoblar_outpost",
		rite_completed = false,
		rite_active = false,
		region_group = "wh2_dlc16_forest_region_group_main_10"
	}
}

Worldroots.completed_encounters = {}
Worldroots.encounters = {
	["kings_glade_beastmen_invaders_intro"] = {
		spawn_turn = 1,
		forest = "athel_loren",
		spawn_incident = "wh2_dlc16_incident_wef_beastmen_threaten_kings_glade",
		faction_filter = "wh_dlc05_wef_wood_elves",
		region = "wh3_main_combi_region_kings_glade",
		setup = function()
			local glade_owner = cm:get_region("wh3_main_combi_region_kings_glade"):owning_faction():name()
			local countdown_markers = Interactive_Marker_Manager:create_countdown(
				"kings_glade_beastmen_invaders_intro",
				"ScriptEventWEFIntroMarkerBattleTriggered",
				"ScriptEventWEFEncounterMarkerExpired",
				{"invasion_marker_3", "invasion_marker_2", "invasion_marker_1"},
				Worldroots.primary_player_key
			)
			
			countdown_markers[1]:add_spawn_event_feed_event(
				"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_forest_encounter_title",
				"incidents_localised_title_wh2_dlc16_incident_wef_beastmen_threaten_kings_glade",
				"incidents_localised_description_wh2_dlc16_incident_wef_beastmen_threaten_kings_glade",
				554,
				glade_owner
			)
			
			countdown_markers[1]:spawn_at_location(538, 516)
			
			countdown_markers[3]:add_spawn_event_feed_event(
				"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_title",
				"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_imminent_primary_detail",
				"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_imminent_secondary_detail", 
				554,
				glade_owner
			)
			
			countdown_markers[3]:add_despawn_event_feed_event(
				"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_title",
				"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_spawned_primary_detail",
				"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_spawned_secondary_detail", 
				554,
				glade_owner
			)
		end,
		on_battle_trigger_callback = function(self, character, marker_info) 
			Worldroots:set_up_generic_encounter_forced_battle(character, "wh2_dlc13_bst_beastmen_invasion", "wh_dlc03_sc_bst_beastmen", true, 10 + cm:turn_number(), "wh_dlc03_bst_beastlord")		
		end,
		on_expiry_callback = function(self, marker_info)
			local x, y = Interactive_Marker_Manager:get_coords_from_instance_ref(marker_info.instance_ref)
			Worldroots:trigger_invasion(Worldroots.forests["athel_loren"], x, y, 16)
		end
	},
	
	["argwylon_dwarf_invaders_intro"] = {
		spawn_turn = 1,
		forest = "athel_loren",
		spawn_incident = "wh2_dlc16_incident_wef_dwarfs_threaten_waterfall_palace",
		faction_filter = "wh_dlc05_wef_argwylon",
		region = "wh3_main_combi_region_waterfall_palace",
		setup = function()
			local glade_owner = cm:get_region("wh3_main_combi_region_waterfall_palace"):owning_faction():name()
			local countdown_markers = Interactive_Marker_Manager:create_countdown(
				"argwylon_dwarf_invaders_intro",
				"ScriptEventWEFIntroMarkerBattleTriggered",
				"ScriptEventWEFEncounterMarkerExpired",
				{"invasion_marker_3", "invasion_marker_2", "invasion_marker_1"},
				Worldroots.primary_player_key
			)
			
			countdown_markers[1]:add_spawn_event_feed_event(
				"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_forest_encounter_title",
				"incidents_localised_title_wh2_dlc16_incident_wef_dwarfs_threaten_waterfall_palace",
				"incidents_localised_description_wh2_dlc16_incident_wef_dwarfs_threaten_waterfall_palace",
				554,
				glade_owner
			)
			
			countdown_markers[3]:add_spawn_event_feed_event(
				"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_title",
				"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_imminent_primary_detail",
				"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_imminent_secondary_detail", 
				554,
				glade_owner
			)
			
			countdown_markers[3]:add_despawn_event_feed_event(
				"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_title",
				"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_spawned_primary_detail",
				"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_spawned_secondary_detail", 
				554,
				glade_owner
			)
			
			countdown_markers[1]:spawn_at_location(490, 570)
		end,
		on_battle_trigger_callback = function(self, character, marker_info)
			Worldroots:set_up_generic_encounter_forced_battle(character, "wh_main_dwf_karak_norn", "wh_main_sc_dwf_dwarfs", true, 8 + cm:turn_number())
		end,
		on_expiry_callback = function(self, marker_info)
			local x, y = Interactive_Marker_Manager:get_coords_from_instance_ref(marker_info.instance_ref)
			Worldroots:trigger_invasion(Worldroots.forests["athel_loren"], x, y, 14, "wh_main_dwf_karak_norn", "wh_main_sc_dwf_dwarfs")
		end
	},
	
	["sisters_skaven_invaders_intro_me"] = {
		spawn_turn = 6,
		forest = "witchwood",
		spawn_incident = "wh2_dlc16_incident_wef_sisters_intro_invasion",
		faction_filter = "wh2_dlc16_wef_sisters_of_twilight",
		region = "wh3_main_combi_region_the_witchwood",
		setup = function() 
			local glade_owner = cm:get_region("wh3_main_combi_region_the_witchwood"):owning_faction():name()
			
			local countdown_markers = Interactive_Marker_Manager:create_countdown(
				"sisters_skaven_invaders_intro_me",
				"ScriptEventWEFIntroMarkerBattleTriggered",
				"ScriptEventWEFEncounterMarkerExpired",
				{"invasion_marker_3", "invasion_marker_2", "invasion_marker_1"},
				Worldroots.primary_player_key
			)
			
			countdown_markers[1]:add_spawn_event_feed_event(
				"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_forest_encounter_title",
				"incidents_localised_title_wh2_dlc16_incident_wef_sisters_intro_invasion",
				"incidents_localised_description_wh2_dlc16_incident_wef_sisters_intro_invasion",
				554,
				glade_owner
			)
			
			countdown_markers[3]:add_spawn_event_feed_event(
				"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_title",
				"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_imminent_primary_detail",
				"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_imminent_secondary_detail", 
				554,
				glade_owner
			)
			
			countdown_markers[3]:add_despawn_event_feed_event(
				"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_title",
				"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_spawned_primary_detail",
				"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_spawned_secondary_detail", 
				554,
				glade_owner
			)
			
			countdown_markers[1]:spawn_at_location(95, 646)
		end,
		on_battle_trigger_callback = function(self, character, marker_info) 
			Worldroots:set_up_generic_encounter_forced_battle(character, "wh2_dlc13_skv_skaven_invasion", "wh2_main_sc_skv_skaven", true, 8 + cm:turn_number(), "wh2_main_skv_grey_seer_plague")
		end,
		on_expiry_callback = function(self, marker_info)
			local x, y = Interactive_Marker_Manager:get_coords_from_instance_ref(marker_info.instance_ref)
			Worldroots:trigger_invasion(Worldroots.forests["witchwood"], x, y, 16)
		end
	},
	
	["drycha_human_invaders_intro"] = {
		spawn_turn = 2,
		forest = "gryphon_wood",
		spawn_incident = "wh2_dlc16_incident_wef_drycha_intro_invasion",
		faction_filter = "wh2_dlc16_wef_drycha",
		region = "wh3_main_combi_region_gryphon_wood",
		setup = function()
			local glade_owner = cm:get_region("wh3_main_combi_region_gryphon_wood"):owning_faction():name()
			
			local countdown_markers = Interactive_Marker_Manager:create_countdown(
				"drycha_human_invaders_intro",
				"ScriptEventWEFIntroMarkerBattleTriggered",
				"ScriptEventWEFEncounterMarkerExpired",
				{"invasion_marker_3", "invasion_marker_2", "invasion_marker_1"},
				Worldroots.primary_player_key
			)
			
			countdown_markers[1]:add_spawn_event_feed_event(
				"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_forest_encounter_title",
				"incidents_localised_title_wh2_dlc16_incident_wef_drycha_intro_invasion",
				"incidents_localised_description_wh2_dlc16_incident_wef_drycha_intro_invasion",
				554,
				glade_owner
			)
			
			countdown_markers[3]:add_spawn_event_feed_event(
				"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_title",
				"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_imminent_primary_detail",
				"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_imminent_secondary_detail", 
				554,
				glade_owner
			)
			
			countdown_markers[3]:add_despawn_event_feed_event(
				"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_title",
				"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_spawned_primary_detail",
				"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_spawned_secondary_detail", 
				554,
				glade_owner
			)
			
			countdown_markers[1]:spawn_at_location(652, 682)
		end,
		on_battle_trigger_callback = function(self, character, marker_info)
			Worldroots:set_up_generic_encounter_forced_battle(character, "wh2_dlc16_emp_empire_invasion", "wh_main_sc_emp_empire", true, 6 + cm:turn_number())
		end,
		on_expiry_callback = function(self, marker_info)
			local x, y = Interactive_Marker_Manager:get_coords_from_instance_ref(marker_info.instance_ref)
			Worldroots:trigger_invasion(Worldroots.forests["gryphon_wood"], x, y, 14)
		end
	},
	
	["wydrioth_greenskin_invaders"] = {
		spawn_turn = 8,
		forest = "athel_loren",
		spawn_incident = "wh2_dlc16_incident_wef_new_encounter_available",
		region = "wh3_main_combi_region_crag_halls_of_findol",
		setup = function()
			Worldroots:set_up_generic_encounter_marker("wydrioth_greenskin_invaders", "wh2_dlc16_dilemma_wef_encounter_athel_loren_greenskins", 525, 554, "athel_loren")
		end,
		on_battle_trigger_callback = function(self, character, marker_info)
			Worldroots:set_up_generic_encounter_forced_battle(character, "wh2_dlc13_grn_greenskins_invasion", "wh_main_sc_grn_greenskins", true)
		end
	},
	
	["torgovann_bretonnian_invaders"] = {
		spawn_turn = 8,
		forest = "athel_loren",
		spawn_incident = "wh2_dlc16_incident_wef_new_encounter_available",
		region = "wh3_main_combi_region_vauls_anvil_loren",
		setup = function()
			Worldroots:set_up_generic_encounter_marker("torgovann_bretonnian_invaders", "wh2_dlc16_dilemma_wef_encounter_athel_loren_bretonnians", 501, 535, "athel_loren")
		end,
		on_battle_trigger_callback = function(self, character, marker_info)
			Worldroots:set_up_generic_encounter_forced_battle(character, "wh_main_brt_bretonnia_qb1", "wh_main_sc_brt_bretonnia", true)
		end
	},
	
	["argwylon_dwarf_invaders"] = {
		spawn_turn = 12,
		forest = "athel_loren",
		spawn_incident = "wh2_dlc16_incident_wef_new_encounter_available",
		region = "wh3_main_combi_region_waterfall_palace",
		setup = function()
			Worldroots:set_up_generic_encounter_marker("argwylon_dwarf_invaders", "wh2_dlc16_dilemma_wef_encounter_athel_loren_dwarfs", 502, 570, "athel_loren")
		end,
		on_battle_trigger_callback = function(self, character, marker_info) 
			Worldroots:set_up_generic_encounter_forced_battle(character, "wh_main_dwf_dwarfs_qb1", "wh_main_sc_dwf_dwarfs", false)
		end
	},
	
	["talsyn_tree_spirit_invaders"] = {
		spawn_turn = 12,
		forest = "athel_loren",
		spawn_incident = "wh2_dlc16_incident_wef_new_encounter_available",
		region = "wh3_main_combi_region_kings_glade",
		setup = 
		function()
			Worldroots:set_up_generic_encounter_marker("talsyn_tree_spirit_invaders", "wh2_dlc16_dilemma_wef_encounter_athel_loren_tree_spirits", 521, 527, "athel_loren")
		end,
		on_battle_trigger_callback =
		function(self, character, marker_info)
			Worldroots:set_up_generic_encounter_forced_battle(character, "wh_dlc05_wef_wood_elves_qb2", "wef_forest_spirits", false, nil, "wh_dlc05_wef_ancient_treeman")
		end
	},
	
	["laurelorn_empire_invaders"] = {
		spawn_turn = 12,
		forest = "laurelorn",
		spawn_incident = "wh2_dlc16_incident_wef_new_encounter_available",
		region = "wh3_main_combi_region_laurelorn_forest",
		setup = function()
			Worldroots:set_up_generic_encounter_marker("laurelorn_empire_invaders", "wh2_dlc16_dilemma_wef_encounter_laurelorn_empire", 540, 721, "laurelorn")
		end,
		on_battle_trigger_callback = function(self, character, marker_info)
			Worldroots:set_up_generic_encounter_forced_battle(character, "wh_main_emp_empire_qb1", "wh_main_sc_emp_empire", false)
		end
	},
	
	["heart_of_the_jungle_tomb_king_invaders_me"] = {
		spawn_turn = 12,
		forest = "heart_of_the_jungle",
		spawn_incident = "wh2_dlc16_incident_wef_new_encounter_available",
		region = "wh3_main_combi_region_oreons_camp",
		setup = function() 
			Worldroots:set_up_generic_encounter_marker("heart_of_the_jungle_tomb_king_invaders_me", "wh2_dlc16_dilemma_wef_encounter_heart_of_the_jungle_tomb_kings", 633, 221, "heart_of_the_jungle")
		end,
		on_battle_trigger_callback = function(self, character, marker_info)
			Worldroots:set_up_generic_encounter_forced_battle(character, "wh2_dlc09_tmb_tombking_qb1", "wh2_dlc09_sc_tmb_tomb_kings", false)
		end
	},
	
	["gaean_vale_high_elf_invaders_me"] = {
		spawn_turn = 12,
		forest = "gaean_vale",
		spawn_incident = "wh2_dlc16_incident_wef_new_encounter_available",
		custom_condition = function()
			return not cm:get_faction("wh2_main_hef_avelorn"):is_dead()
		end,
		region = "wh3_main_combi_region_gaean_vale",
		setup = function() 
			Worldroots:set_up_generic_encounter_marker("gaean_vale_high_elf_invaders_me", "wh2_dlc16_dilemma_wef_encounter_gaean_vale_high_elves", 280, 587, "gaean_vale")
		end,
		on_battle_trigger_callback = function(self, character, marker_info)
			Worldroots:set_up_generic_encounter_forced_battle(character, "wh2_main_hef_high_elves_qb1", "wh2_main_sc_hef_high_elves", false)
		end,
		second_option_callback = function(self, character, marker_info)
			local faction_to_gain = "wh2_main_hef_avelorn"
			
			if cm:get_faction("wh2_main_hef_avelorn"):is_dead() then
				faction_to_gain = "wh2_main_hef_eataine"
			end
			
			cm:transfer_region_to_faction("wh3_main_combi_region_gaean_vale", faction_to_gain)
		end
	},
	
	["naggaroth_glade_dark_elf_invaders_me"] = {
		spawn_turn = 12,
		forest = "witchwood",
		spawn_incident = "wh2_dlc16_incident_wef_new_encounter_available",
		region = "wh3_main_combi_region_the_witchwood",
		setup = function() 
			Worldroots:set_up_generic_encounter_marker("naggaroth_glade_dark_elf_invaders_me", "wh2_dlc16_dilemma_wef_encounter_naggarond_dark_elves", 90, 641, "witchwood")
		end,
		on_battle_trigger_callback = function(self, character, marker_info)
			Worldroots:set_up_generic_encounter_forced_battle(character, "wh2_main_def_dark_elves_qb1", "wh2_main_sc_def_dark_elves", false, nil, "wh2_dlc10_def_supreme_sorceress_dark")
		end
	},
	
	["gryphon_wood_vampire_invaders"] = {
		spawn_turn = 8,
		forest = "gryphon_wood",
		spawn_incident = "wh2_dlc16_incident_wef_new_encounter_available",
		region = "wh3_main_combi_region_gryphon_wood",
		setup = function() 
			Worldroots:set_up_generic_encounter_marker("gryphon_wood_vampire_invaders", "wh2_dlc16_dilemma_wef_encounter_gryphon_wood_vampires", 685, 689, "gryphon_wood")
		end,
		on_battle_trigger_callback = function(self, character, marker_info)
			Worldroots:set_up_generic_encounter_forced_battle(character, "wh_main_vmp_vampire_counts_qb1", "vmp_ghoul_horde", false, nil, "wh_dlc04_vmp_strigoi_ghoul_king")
		end
	},
	
	["emerald_pools_lizardmen_invaders_me"] = {
		spawn_turn = 12,
		forest = "emerald_pools",
		spawn_incident = "wh2_dlc16_incident_wef_new_encounter_available",
		region = "wh3_main_combi_region_the_sacred_pools",
		setup = function() 
			Worldroots:set_up_generic_encounter_marker("emerald_pools_lizardmen_invaders_me", "wh2_dlc16_dilemma_wef_encounter_lustria_lizardmen", 164, 246, "emerald_pools")
		end,
		on_battle_trigger_callback = function(self, character, marker_info)
			Worldroots:set_up_generic_encounter_forced_battle(character, "wh2_main_lzd_lizardmen_qb1", "wh2_main_sc_lzd_lizardmen", false)
		end
	},
	
	["vale_of_webs_goblin_invaders"] = {
		spawn_turn = 12,
		forest = "forest_of_gloom",
		spawn_incident = "wh2_dlc16_incident_wef_new_encounter_available",
		region = "wh3_main_combi_region_forest_of_gloom",
		setup = function()
			Worldroots:set_up_generic_encounter_marker("vale_of_webs_goblin_invaders", "wh2_dlc16_dilemma_wef_encounter_vale_of_webs_spiders", 696, 540, "forest_of_gloom")
		end,
		on_battle_trigger_callback = function(self, character, marker_info)
			Worldroots:set_up_generic_encounter_forced_battle(character, "wh2_dlc13_grn_greenskins_invasion", "grn_spider_cult", false)
		end
	},
	
	["laurelorn_norsca"] = {
		spawn_turn = 15,
		spawn_incident = "wh2_dlc16_incident_wef_new_confed_encounter_available",
		region = "wh3_main_combi_region_laurelorn_forest",
		setup = function() 
			Worldroots:set_up_generic_encounter_marker("laurelorn_norsca", "wh2_dlc16_dilemma_wef_encounter_laurelorn_norsca", 510, 723, "laurelorn")
			cm:make_region_seen_in_shroud(Worldroots.primary_player_key, "wh3_main_combi_region_laurelorn_forest")
			cm:make_region_seen_in_shroud(Worldroots.primary_player_key, "wh3_main_combi_region_dietershafen")
			cm:make_diplomacy_available(Worldroots.primary_player_key, "wh3_main_wef_laurelorn")
			
			if confed_missions:is_mission_valid_for_faction(Worldroots.primary_player_key, "wood_elves_laurelorn") then
				cm:callback(function() confed_missions:trigger_mission(Worldroots.primary_player_key, "wood_elves_laurelorn") end, 1)
			end
		end,
		on_battle_trigger_callback = function(self, character, marker_info)
			Worldroots:set_up_generic_encounter_forced_battle(character, "wh2_dlc13_nor_norsca_invasion", "wh_dlc08_sc_nor_norsca", false, 20, nil, 2)
		end,
		second_option_callback = function(self, character, marker_info)
			Worldroots:set_up_generic_encounter_forced_battle(character, "wh2_dlc13_nor_norsca_invasion", "nor_fimir", false, 10)
		end
	},
	
	["special_the_blood_fane"] = {
		spawn_turn = 1,
		spawn_incident = "wh2_dlc16_incident_wef_new_encounter_available",
		region = "wh3_main_combi_region_gryphon_wood",
		custom_condition = function()
			return #Worldroots.completed_encounters > 7
		end,
		setup = function() 
			Worldroots:set_up_generic_encounter_marker("special_the_blood_fane", "wh2_dlc16_dilemma_wef_encounter_special_the_blood_fane", 651, 723, false, {0})
		end,
		second_option_callback = function(self, character, marker_info)
			Worldroots:set_up_generic_encounter_forced_battle(character, "wh2_dlc13_bst_beastmen_invasion", "wh_dlc03_sc_bst_beastmen", false, 20, nil, 5)
			local character_faction = character:faction():name()
			Worldroots:add_pooled_resource_to_all_wood_elves(Worldroots.forests["athel_loren"], "wh2_dlc16_resource_factor_worldroots_healed", Worldroots.battle_resolution_value, character_faction, true)
			Worldroots:add_pooled_resource_to_all_wood_elves(Worldroots.forests["laurelorn"], "wh2_dlc16_resource_factor_worldroots_healed", Worldroots.battle_resolution_value, character_faction, true)
			Worldroots:add_pooled_resource_to_all_wood_elves(Worldroots.forests["gryphon_wood"], "wh2_dlc16_resource_factor_worldroots_healed", Worldroots.battle_resolution_value, character_faction, true)
		end
	},
	
	["witchwood_greenskins_v_druchii_me"] = {
		spawn_turn = 15,
		forest = "witchwood",
		spawn_incident = "wh2_dlc16_incident_wef_new_encounter_available",
		region = "wh3_main_combi_region_the_witchwood",
		setup = function()
			Worldroots:set_up_generic_encounter_marker("witchwood_greenskins_v_druchii_me", "wh2_dlc16_dilemma_wef_encounter_witchwood_greenskins_v_druchii", 92, 683, "witchwood")
		end,
		on_battle_trigger_callback = function(self, character, marker_info)
			Worldroots:set_up_generic_encounter_forced_battle(character, "wh2_main_def_dark_elves_qb1", "wh2_main_sc_def_dark_elves", false, 18, "wh2_dlc14_def_high_beastmaster", 1)
		end,
		second_option_callback = function(self, character, marker_info)
			Worldroots:set_up_generic_encounter_forced_battle(character, "wh2_dlc13_grn_greenskins_invasion", "grn_greenskins_orcs_only", false, nil, "wh_main_grn_orc_warboss")
		end
	},
	
	["sacred_pools_pestilens_me"] = {
		spawn_turn = 1,
		forest = "emerald_pools",
		spawn_incident = "wh2_dlc16_incident_wef_new_encounter_available",
		region = "wh3_main_combi_region_the_sacred_pools",
		setup = function()
			Worldroots:set_up_generic_encounter_marker("sacred_pools_pestilens_me", "wh2_dlc16_dilemma_wef_encounter_sacred_pools_pestilens", 173, 250, "emerald_pools")
		end,
		on_battle_trigger_callback = function(self, character, marker_info)
			Worldroots:set_up_generic_encounter_forced_battle(character, "wh2_dlc13_skv_skaven_invasion", "skv_pestilens_and_rats", false, nil, "wh2_main_skv_grey_seer_plague")
		end,
		second_option_callback = function(self, character, marker_info)
			Worldroots:set_up_generic_encounter_forced_battle(character, "wh2_dlc13_skv_skaven_invasion", "skv_pestilens_and_rats", false, nil, "wh2_main_skv_grey_seer_plague")
		end
	},
	
	["gaean_vale_druchii_vs_moulder_me"] = {
		spawn_turn = 1,
		forest = "gaean_vale",
		spawn_incident = "wh2_dlc16_incident_wef_new_encounter_available",
		region = "wh3_main_combi_region_gaean_vale",
		setup = function()
			Worldroots:set_up_generic_encounter_marker("gaean_vale_druchii_vs_moulder_me", "wh2_dlc16_dilemma_wef_encounter_gaean_vale_druchii_v_moulder", 247, 634, "gaean_vale")
		end,
		on_battle_trigger_callback = function(self, character, marker_info)
			Worldroots:set_up_generic_encounter_forced_battle(character, "wh2_main_def_dark_elves_qb1", "def_corsairs", false, 18, "wh2_main_def_dreadlord", 1)
		end,
		second_option_callback = function(self, character, marker_info)
			Worldroots:set_up_generic_encounter_forced_battle(character, "wh2_dlc13_skv_skaven_invasion", "skv_moulder", false, 12, "wh2_main_skv_grey_seer_plague")
		end
	},
	
	["heart_of_the_jungle_bowmen_v_dinosaurs_me"] = {
		spawn_turn = 15,
		spawn_incident = "wh2_dlc16_incident_wef_new_confed_encounter_available",
		region = "wh3_main_combi_region_oreons_camp",
		setup = function()
			if cm:get_faction("wh2_main_wef_bowmen_of_oreon"):is_dead() then
				return false
			end
			
			Worldroots:set_up_generic_encounter_marker("heart_of_the_jungle_bowmen_v_dinosaurs_me", "wh2_dlc16_dilemma_wef_encounter_heart_of_the_jungle_bowmen_v_dinosaurs", 631, 209, "heart_of_the_jungle")
			
			cm:make_region_seen_in_shroud(Worldroots.primary_player_key, "wh3_main_combi_region_oreons_camp")
			cm:make_diplomacy_available(Worldroots.primary_player_key, "wh2_main_wef_bowmen_of_oreon")
			
			cm:callback(
				function()
					if confed_missions:is_mission_valid_for_faction(Worldroots.primary_player_key, "wood_elves_oreons_camp") then
						confed_missions:trigger_mission(Worldroots.primary_player_key, "wood_elves_oreons_camp")
					end
				end,
				1
			)
		end,
		on_battle_trigger_callback = function(self, character, marker_info)
			Worldroots:set_up_generic_encounter_forced_battle(character, "wh2_main_wef_bowmen_of_oreon", "wh_dlc05_sc_wef_wood_elves", false, nil, "wh_dlc05_wef_glade_lord", 1, true)
		end,
		second_option_callback = function(self, character, marker_info)
			cm:force_confederation(character:faction():name(), "wh2_main_wef_bowmen_of_oreon")
		end
	},
	
	["jungles_of_chian_invaders"] = {
		spawn_turn = 12,
		spawn_incident = "wh2_dlc16_incident_wef_new_encounter_available",
		region = "wh3_main_combi_region_jungles_of_chian",
		setup = function()
			Worldroots:set_up_generic_encounter_marker("jungles_of_chian_invaders", "wh2_dlc16_dilemma_wef_encounter_jungles_of_chian", 1324, 387, "jungles_of_chian")
			
			cm:make_region_seen_in_shroud(Worldroots.primary_player_key, "wh3_main_combi_region_jungles_of_chian")
			cm:make_diplomacy_available(Worldroots.primary_player_key, "wh3_dlc21_wef_spirits_of_shanlin")
			
			cm:callback(
				function()
					if confed_missions:is_mission_valid_for_faction(Worldroots.primary_player_key, "wood_elves_shanlin") then
						confed_missions:trigger_mission(Worldroots.primary_player_key, "wood_elves_shanlin")
					end
				end,
				1
			)
		end,
		on_battle_trigger_callback = function(self, character, marker_info)
			Worldroots:set_up_generic_encounter_forced_battle(character, "wh3_main_tze_tzeentch_invasion", "wh3_main_sc_tze_tzeentch", false)
		end
	},
	
	["the_haunted_forest_invaders"] = {
		spawn_turn = 12,
		forest = "the_haunted_forest",
		spawn_incident = "wh2_dlc16_incident_wef_new_encounter_available",
		region = "wh3_main_combi_region_the_haunted_forest",
		setup = function()
			Worldroots:set_up_generic_encounter_marker("the_haunted_forest_invaders", "wh2_dlc16_dilemma_wef_encounter_the_haunted_forest", 1040, 429, "the_haunted_forest")
		end,
		on_battle_trigger_callback = function(self, character, marker_info)
			Worldroots:set_up_generic_encounter_forced_battle(character, "wh3_main_ogr_ogre_kingdoms_invasion", "wh3_main_sc_ogr_ogre_kingdoms", false)
		end
	}
}

Worldroots.teleport_rituals_to_regions =  {
	["wh2_dlc16_worldroots_teleport_athel_loren"] =					"wh3_main_combi_region_the_oak_of_ages",
	["wh2_dlc16_worldroots_teleport_emerald_pools_main"] =			"wh3_main_combi_region_the_sacred_pools",
	["wh2_dlc16_worldroots_teleport_gaean_vale_main"] =				"wh3_main_combi_region_gaean_vale",
	["wh2_dlc16_worldroots_teleport_gryphon_wood"] =				"wh3_main_combi_region_gryphon_wood",
	["wh2_dlc16_worldroots_teleport_heart_of_the_jungle_main"] =	"wh3_main_combi_region_oreons_camp",
	["wh2_dlc16_worldroots_teleport_laurelorn"] =					"wh3_main_combi_region_laurelorn_forest",
	["wh2_dlc16_worldroots_teleport_witchwood_main"] =				"wh3_main_combi_region_the_witchwood",
	["wh2_dlc16_worldroots_teleport_forest_of_gloom"] =				"wh3_main_combi_region_forest_of_gloom",
	["wh2_dlc16_worldroots_teleport_jungles_of_chian"] =			"wh3_main_combi_region_jungles_of_chian",
	["wh2_dlc16_worldroots_teleport_the_haunted_forest"] =			"wh3_main_combi_region_the_haunted_forest"
}

-------------
--FUNCTIONS--
-------------

-- VFX
-- functions for showing the Worldroots VFX
function Worldroots:pulse_worldroots_beam(starting_region, ending_region, opt_ignore_start_scene, opt_ignore_end_scene)
	local starting_settlement = cm:get_region(starting_region):settlement()
	local ending_settlement = cm:get_region(ending_region):settlement()
	local starting_x = starting_settlement:logical_position_x()
	local starting_y = starting_settlement:logical_position_y()
	local ending_x = ending_settlement:logical_position_x()
	local ending_y = ending_settlement:logical_position_y()
	
	local dx = starting_x - ending_x
  	local dy = starting_y - ending_y
	local distance = math.sqrt(dx * dx + dy * dy)
	
	local beams_required = math.floor(distance/ 90) + 1
	
	local beam_division_x = (ending_x - starting_x) / beams_required
	local beam_division_y = (ending_y - starting_y) / beams_required
	
	if not opt_ignore_start_scene then
		cm:add_scripted_composite_scene_to_logical_position(
			"worldroot_end" .. starting_region,
			"campaign_worldroots_beam_end",
			starting_x,
			starting_y,
			ending_x,
			ending_y,
			true,
			true,
			true
		)
	end
	
	if not opt_ignore_end_scene then
		cm:add_scripted_composite_scene_to_logical_position(
			"worldroot_end" .. ending_region,
			"campaign_worldroots_beam_end",
			ending_x,
			ending_y,
			ending_x,
			ending_y,
			true,
			true,
			true
		)
	end
	
	for i = 1, beams_required - 1 do  
		cm:add_scripted_composite_scene_to_logical_position(
			"campaign_worldroots_beam" .. starting_region .. ending_region .. i,
			"campaign_worldroots_beam",
			starting_x + beam_division_x * i,
			starting_y + beam_division_y * i,
			ending_x,
			ending_y,
			true,
			true,
			true
		)
	end
end

function Worldroots:add_worldroots_listeners()
	out("#####Adding Worldroots Listeners#####")
	
	-- Automatically Upgrade AI Units at set intervals
	cm:add_faction_turn_start_listener_by_subculture(
		"aspect_upgrade",
		"wh_dlc05_sc_wef_wood_elves",
		function(context)
			local faction = context:faction()
			local faction_name = faction:name()
			
			if cm:model():turn_number() % 10 == 0 and not faction:is_human() and faction_name ~= "wh2_dlc16_wef_drycha" and faction_name ~= "wh_dlc05_wef_argwylon" then
				local wef_force_list = faction:military_force_list()
				
				for i = 0, wef_force_list:num_items() - 1 do
					local wef_force = wef_force_list:item_at(i)
					if not wef_force:is_armed_citizenry() == false then
						local unit_list = wef_force:unit_list()
					
						for j = 0, unit_list:num_items() - 1 do
							local unit_interface = unit_list:item_at(j)
							local unit_purchasable_effect_list = unit_interface:get_unit_purchasable_effects()
							
							if not unit_purchasable_effect_list:is_empty() then
								cm:faction_purchase_unit_effect(faction, unit_interface, unit_purchasable_effect_list:item_at(cm:random_number(unit_purchasable_effect_list:num_items()) - 1))
							end
						end
					end
				end
			end
		end,
		true
	)
	
	-- find the first human wood elf and define them as the primary
	self.primary_player_key = false
	
	local human_factions = cm:get_human_factions()
	
	for i = 1, #human_factions do
		if cm:get_faction(human_factions[i]):culture() == "wh_dlc05_wef_wood_elves" then
			self.primary_player_key = human_factions[i]
			break
		end
	end
	
	-- Drycha can never confederate with anyone but Durthu
	cm:force_diplomacy("faction:wh2_dlc16_wef_drycha", "culture:wh_dlc05_wef_wood_elves", "form confederation", false, false)
	cm:force_diplomacy("faction:wh2_dlc16_wef_drycha", "faction:wh_dlc05_wef_argwylon", "form confederation", true, true)
	
	if not self.primary_player_key then
		out("No human Wood Elves found")		
		return -- Nothing after this point should fire if there aren't any human Wood Elves
	end
	
	out("Primary Wood Elf Faction is " .. tostring(self.primary_player_key))
	
	-- update the invasion power
	Worldroots:calculate_invasion_power()
	
	-- only player(s) - excluding Drycha - can confederate
	cm:force_diplomacy("culture:wh_dlc05_wef_wood_elves", "culture:wh_dlc05_wef_wood_elves", "form confederation", false, false)
	
	for i = 1, #human_factions do
		if cm:get_faction(human_factions[i]):culture() == "wh_dlc05_wef_wood_elves" and human_factions[i] ~= "wh2_dlc16_wef_drycha" then
			cm:force_diplomacy("faction:" .. human_factions[i], "culture:wh_dlc05_wef_wood_elves", "form confederation", true, true)
		end
	end
	
	if cm:is_new_game() then
		for forest_ref, forest in pairs(Worldroots.forests) do
			-- we start the Worldroots health rituals locked then unlock them here, otherwise the AI will use them!
			for i = 1, #human_factions do
				local current_human_faction = cm:get_faction(human_factions[i])
				
				if current_human_faction:culture() == "wh_dlc05_wef_wood_elves" then
					cm:unlock_ritual(current_human_faction, forest.rite_key, -1)
				end
			end
			
			-- make the forest regions visible for the owner
			local forest_owner_key = cm:get_region(forest.glade_region_key):owning_faction():name()
			
			local region_list = cm:model():world():lookup_regions_from_region_group(forest.region_group)
			
			for i = 0, region_list:num_items() - 1 do
				cm:make_region_seen_in_shroud(forest_owner_key, region_list:item_at(i):name())
			end
			
			if forest.additional_regions then
				for i = 1, #forest.additional_regions do
					cm:make_region_seen_in_shroud(forest_owner_key, forest.additional_regions[i])
				end
			end
		end
		
		cm:faction_add_pooled_resource("wh2_dlc16_wef_drycha", "wef_amber", "wh2_dlc16_resource_factor_worldroots_healed", 1)
		
	end
	
	-- setup ritual listeners
	core:add_listener(
		"ForestRitualStartedEvent",
		"RitualStartedEvent",
		function(context)
			return self:get_forest_by_rite(context:ritual():ritual_key())
		end,
		function(context)
			self:set_up_ritual(self:get_forest_by_rite(context:ritual():ritual_key()), context:performing_faction():name())
		end,
		true
	)
	
	core:add_listener(
		"ForestRitualCompletedEvent",
		"RitualCompletedEvent",
		function(context)
			return self:get_forest_by_rite(context:ritual():ritual_key())
		end,
		function(context)
			self:complete_ritual(self:get_forest_by_rite(context:ritual():ritual_key()), context:performing_faction():name())
		end,
		true
	)
	
	core:add_listener(
		"ScriptEventWEFInvasionMarkerExpired",
		"ScriptEventWEFInvasionMarkerExpired",
		true,
		function(context)
			local marker_ref = context.stored_table.marker_ref
			local instance_ref = context.stored_table.instance_ref
			-- we get cheeky here, the forest key is part of the marker ref, so we can strip out the standardised marker part to get the forest
			local forest_key = string.gsub(marker_ref, "_invasion_marker_%d", "")
			
			-- use the instance ref to grab the x-y-coords so we know where to spawn
			local x, y = Interactive_Marker_Manager:get_coords_from_instance_ref(instance_ref)
			
			Worldroots:trigger_invasion(Worldroots.forests[forest_key], x, y, self.invasion_force_strength)
		end,
		true
	)
	
	core:add_listener(
		"ScriptEventWEFInvasionMarkerInteraction",
		"ScriptEventWEFInvasionMarkerInteraction",
		true,
		function(context)
			local area_info = context.stored_table
			local marker_ref = area_info.marker_ref
			local forest_key = string.gsub(marker_ref, "_invasion_marker_%d", "")
			local forest = Worldroots.forests[forest_key]
			local invasion_faction = forest.invasion_faction
			
			if cm:get_faction(invasion_faction):is_human() and forest.invasion_faction_alternate then
				invasion_faction = forest.invasion_faction_alternate
			end
			
			Forced_Battle_Manager:trigger_forced_battle_with_generated_army(
				context:character():military_force():command_queue_index(),
				invasion_faction,
				cm:get_faction(invasion_faction):subculture(),
				self.invasion_force_strength + self.invasion_force_interruption_modifiers[string.gsub(marker_ref, forest_key .. "_", "")],
				self.invasion_power_modifier,
				false,
				false,
				true,
				nil,
				nil,
				nil,
				nil,
				self.invasion_force_interrupted_effect_bundle
			)
		end,
		true
	)
	
	-- variant listener for the intro battles
	core:add_listener(
		"ScriptEventWEFIntroMarkerBattleTriggered",
		"ScriptEventWEFIntroMarkerBattleTriggered",
		true,
		function(context)
			local marker_info = context.stored_table
			local marker_ref = string.gsub(marker_info.marker_ref,"_invasion_marker_%d","")
			local encounter = Worldroots.encounters[marker_ref]
			
			if not is_table(encounter) then
				script_error("Worldroots: Received an event trigger for a marker "..marker_ref.." that cannot be found")
			end
			
			if is_function(encounter.on_battle_trigger_callback) then
				encounter:on_battle_trigger_callback(context:character(), marker_info)
			end
		end,
		true
	)
	
	core:add_listener(
		"ScriptEventWEFEncounterMarkerBattleTriggered",
		"ScriptEventWEFEncounterMarkerBattleTriggered",
		true,
		function(context)
			local character = context:character()
			local marker_info = context.stored_table
			local marker_ref = marker_info.marker_ref
			local encounter = Worldroots.encounters[marker_ref]
			
			if not is_table(encounter) then
				script_error("Worldroots: Received an event trigger for a marker "..marker_ref.." that cannot be found")
			end
			
			if encounter.forest then
				local forest = Worldroots.forests[encounter.forest]
				
				Worldroots:add_pooled_resource_to_all_wood_elves(forest, "wh2_dlc16_resource_factor_completed_encounters", Worldroots.battle_resolution_value, character:faction():name(), true)
			end
			
			if is_function(encounter.on_battle_trigger_callback) then
				encounter:on_battle_trigger_callback(character, marker_info)
			end
		end,
		true
	)
	
	core:add_listener(
		"ScriptEventWEFEncounterMarkerPeacefullyResolved",
		"ScriptEventWEFEncounterMarkerPeacefullyResolved",
		true,
		function(context)
			local character = context:character()
			local marker_info = context.stored_table
			local marker_ref = marker_info.marker_ref
			
			local encounter = Worldroots.encounters[marker_ref]
			if not is_table(encounter) then
				script_error("Worldroots: Received an event trigger for a marker "..marker_ref.." that cannot be found")
			end
			
			if encounter.forest then
				local forest = Worldroots.forests[encounter.forest]
				
				Worldroots:add_pooled_resource_to_all_wood_elves(forest, "wh2_dlc16_resource_factor_completed_encounters", Worldroots.peaceful_resolution_value, character:faction():name(), true)
			end
			
			if is_function(encounter.second_option_callback) then
				encounter:second_option_callback(character, marker_info)
			end
		end,
		true
	)
	
	core:add_listener(
		"ScriptEventWEFEncounterMarkerExpired",
		"ScriptEventWEFEncounterMarkerExpired",
		true,
		function(context)
			local marker_info = context.stored_table
			local marker_ref = string.gsub(marker_info.marker_ref,"_invasion_marker_%d", "")
			local encounter = Worldroots.encounters[marker_ref]
			
			if not encounter then
				script_error("Worldroots: Received an event trigger for a marker " .. marker_ref .. " that cannot be found")
			end
			
			if is_function(encounter.on_expiry_callback) then
				encounter:on_expiry_callback(marker_info)
			end
		end,
		true
	)
	
	-- lock the buildings
	local function lock_forest_buildings()
		local forests_list = self.forests
		local button_world_roots = find_uicomponent(core:get_ui_root(), "hud_campaign", "world_roots")
		
		if button_world_roots then
			for forest_key, forest in pairs(forests_list) do
				if forest.locked_building then
					local building_to_lock = forest.locked_building
					
					if forest_key ~= self.primary_forest then
						button_world_roots:InterfaceFunction("AddBuildingRecordForRegion", forest.glade_region_key, building_to_lock, false)
					end
					
					if cm:is_new_game() then
						cm:add_event_restricted_building_record(building_to_lock, "building_lock_rite_of_rebirth")
					end
				end
			end
			
			-- do the primary glade last as we need to signal to the UI that we're done
			local primary_locked_building = forests_list[self.primary_forest].locked_building
			local primary_region = forests_list[self.primary_forest].glade_region_key
			
			button_world_roots:InterfaceFunction("AddBuildingRecordForRegion", primary_region, primary_locked_building, true)
		end
	end
	
	lock_forest_buildings()
	
	core:add_listener(
		"lock_forest_buildings_after_ui_reload",
		"UIReloaded",
		true,
		function()
			lock_forest_buildings()
		end,
		true
	)
	
	-- setup battle listeners
		core:add_listener(
		"CharacterPerformsSettlementOccupationDecisionRazeForestBorders",
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			return context:occupation_decision() == "1598549406" and context:character():faction():is_human()
		end,
		function(context)
			local forest_to_benefit = self:is_adjacent_to_forest(context:garrison_residence():region():name())
			
			if forest_to_benefit then
				Worldroots:add_pooled_resource_to_all_wood_elves(forest_to_benefit, "wh2_dlc16_resource_factor_razing_and_battles", self.razing_value + cm:get_factions_bonus_value(context:character():faction(), "additional_worldroots_health_from_razing"), nil, true)
			end
		end,
		true
	)
	
	core:add_listener(
		"WoodElfCharacterCompletedBattle",
		"CharacterCompletedBattle",
		function(context)
			local character = context:character()
			local faction = character:faction()
			
			return faction:is_human() and faction:culture() == "wh_dlc05_wef_wood_elves" and character:won_battle() and character:has_region()
		end,
		function(context)
			local character = context:character()
			local region_key = character:region():name()
			local forest_to_benefit = self:is_adjacent_to_forest(region_key)
			
			if not forest_to_benefit then 
				forest_to_benefit = self:is_part_of_forest(region_key)
			end
			
			if forest_to_benefit then
				Worldroots:add_pooled_resource_to_all_wood_elves(forest_to_benefit, "wh2_dlc16_resource_factor_razing_and_battles", self.battle_value + cm:get_factions_bonus_value(character:faction(), "additional_worldroots_health_from_battles") + cm:get_forces_bonus_value(character:military_force(), "additional_worldroots_health_from_battles"), nil, true)
			end
		end,
		true
	)
	
	-- things we do every player turn can go inside this listener
	core:add_listener(
		"WorldrootsUpdateFactionTurnStart",
		"FactionTurnStart",
		function(context)
			local faction = context:faction()
			
			return faction:is_human() and faction:culture() == "wh_dlc05_wef_wood_elves"
		end,
		function(context)
			local faction = context:faction()
			local faction_name = faction:name()
			
			if cm:get_factions_bonus_value(faction, "provides_vision_on_all_glade_regions") > 0 then
				for forest_ref, forest in pairs(self.forests) do
					cm:make_region_visible_in_shroud(faction_name, forest.glade_region_key)
				end
			end
			
			Worldroots:generate_encounter(faction)
			
			if cm:get_faction("wh2_main_wef_bowmen_of_oreon"):is_dead() then
				Worldroots:remove_encounter("heart_of_the_jungle_bowmen_v_dinosaurs_me")
			end
			
			if faction_name == Worldroots.primary_player_key then
				Worldroots:update_worldroots_health()
				Worldroots:calculate_invasion_power()
				local turn_number = cm:turn_number()
				
				if turn_number == 10 then
					local human_factions = cm:get_human_factions()
					
					for i = 1, #human_factions do
						local current_human_faction = cm:get_faction(human_factions[i])
						
						if current_human_faction:culture() == "wh_dlc05_wef_wood_elves" then
							cm:unlock_rituals_in_category(current_human_faction, "WORLDROOTS_TELEPORTATION", -1)
							
							cm:trigger_incident(human_factions[i], "wh3_main_incident_wef_deeproots_available")
						end
					end
					
					core:trigger_event("ScriptEventDeeprootsUnlocked")
				end
				
				if turn_number == Worldroots.avelorn_invasion_turn then
					Worldroots:launch_avelorn_invasion()
				elseif turn_number == Worldroots.avelorn_invasion_turn + Worldroots.avelorn_invasion_duration then
					Worldroots:end_avelorn_invasion()
				end
			end
		end,
		true
	)
	
	core:add_listener(
		"MissionSucceededDrychaQuest",
		"MissionSucceeded",
		function(context)
			return context:mission():mission_record_key():starts_with("wh3_main_ie_qb_wef_drycha_coeddil_unchained")
		end,
		function(context)
			cm:spawn_unique_agent(context:faction():command_queue_index(), "wh2_dlc16_wef_coeddil", true)
		end,
		false
	)
	
	core:add_listener(
		"AspectUnitEffectPurchased",
		"UnitEffectPurchased",
		function(context)
			return context:effect():record_key():starts_with("wh2_dlc16_wef_upgrade_aspect_")
		end,
		function(context)
			local unit = context:unit()
			local unit_current_effects = unit:get_unit_purchased_effects()
			
			for i = 0, unit_current_effects:num_items() - 1 do
				local current_upgrade = unit_current_effects:item_at(i)
				
				if current_upgrade:record_key() ~= context:effect():record_key() then
					cm:faction_unpurchase_unit_effect(unit, current_upgrade)
				end
			end
		end,
		true
	)
	
	-- edge case handling if the player confederates the Bowmen between the marker spawning and interacting with it
	if not cm:get_faction("wh2_main_wef_bowmen_of_oreon"):is_dead() then
		core:add_listener(
			"BowmenJoinConfederation",
			"FactionJoinsConfederation",
			function(context)
				return context:faction():name() == "wh2_main_wef_bowmen_of_oreon"
			end,
			function()
				Worldroots:remove_encounter("heart_of_the_jungle_bowmen_v_dinosaurs_me")
			end,
			true
		)
	end
	
	-- make the magical forest panel disappear on click, reappear when you click the worldroots button
	local uic_root = core:get_ui_root()
	local magical_forest_info = find_uicomponent(uic_root, "hud_campaign", "magical_forest_info")
	
	if magical_forest_info then
		magical_forest_info:SetInteractive(true)
	end
	
	core:add_listener(
		"MagicalForestLClickUp_listener",
		"ComponentLClickUp",
		function(context)
			return context.string == "magical_forest_info"
		end,
		function()
			Worldroots:set_magic_forest_panel_visibility(false)
		end,
		true
	)
	
	-- VFX listeners
	-- show the roots when you click the worldroots button
	core:add_listener(
		"WorldrootsButtonLClickUp_listener",
		"ComponentLClickUp",
		function(context)
			return context.string == "button_world_roots" and not Worldroots.vfx_active
		end,
		function()
			-- pulse the worldroots beams
			local primary_forest_key = Worldroots.forests[Worldroots.primary_forest].glade_region_key
			local ignore_primary_glade_vfx = false
			
			for forest_ref, forest in pairs(Worldroots.forests) do
				if forest.glade_region_key ~= primary_forest_key then
					self:pulse_worldroots_beam(primary_forest_key, forest.glade_region_key, ignore_primary_glade_vfx)
					ignore_primary_glade_vfx = true
				end
			end
			
			Worldroots.vfx_active = true
			
			cm:callback(function() Worldroots.vfx_active = false end, 4)
			
			magical_forest_info:SetInteractive(true)
		end,
		true
	)
	
	-- apply VFX when teleporting
	core:add_listener(
		"TelportationRitualStartedEvent",
		"RitualStartedEvent",
		function(context)
			return context:ritual():ritual_category() == "WORLDROOTS_TELEPORTATION"
		end,
		function(context)
			local teleported_force = context:ritual():ritual_target():get_target_force()
			local force_x = teleported_force:general_character():logical_position_x()
			local force_y = teleported_force:general_character():logical_position_y()
			local force_target_region_key = Worldroots.teleport_rituals_to_regions[context:ritual():ritual_key()]
			
			if not is_string(force_target_region_key) then
				script_error("Worldroots: teleporting to a region but don't have a valid target region for VFX, so no VFX will be fired")
				return
			end
			
			Worldroots:pulse_worldroots_beam(teleported_force:general_character():region():name(), force_target_region_key, true, true)
			
			cm:add_scripted_composite_scene_to_logical_position(
				"teleport_vfx",
				Worldroots.teleport_vfx_key,
				force_x,
				force_y,
				force_x + 1,
				force_y + 1,
				true,
				true,
				true
			)
			
			cm:callback(
				function()
					local force_x = teleported_force:general_character():logical_position_x()
					local force_y = teleported_force:general_character():logical_position_y()
					
					cm:add_scripted_composite_scene_to_logical_position(
						"teleport_vfx",
						Worldroots.teleport_vfx_key,
						force_x,
						force_y,
						force_x + 1,
						force_y + 1,
						true,
						true,
						true
					)
				end,
				0.2
			)
		end,
		true
	)
end

function Worldroots:set_magic_forest_panel_visibility(is_visible, opt_opacity)
	local magical_forest_info = find_uicomponent(core:get_ui_root(), "hud_campaign", "magical_forest_info")
	
	if not magical_forest_info then
		return
	end
	
	local opacity = opt_opacity or 255
	
	if not is_visible then 
		opacity = 0
	end
	
	magical_forest_info:SetOpacity(opacity)
	magical_forest_info:PropagateOpacity(opacity)
	magical_forest_info:SetVisible(is_visible)
	magical_forest_info:PropagateVisibility(is_visible)
end

function Worldroots:set_up_generic_encounter_marker(key, dilemma, loc_x, loc_y, forest_key, override_dilemma_options)
	local marker = Interactive_Marker_Manager:new_marker_type(key, "worldroots_encounter", nil, 1, nil, "wh_dlc05_sc_wef_wood_elves")
	marker:add_interaction_event("ScriptEventWEFEncounterMarkerPeacefullyResolved", 0)
	marker:add_interaction_event("ScriptEventWEFEncounterMarkerBattleTriggered", 1)
	marker:despawn_on_interaction(true, override_dilemma_options or {0, 1})
	marker:add_dilemma(dilemma)
	
	if self.encounters[key].spawn_incident then
		marker:add_spawn_event_feed_event(
			"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_forest_encounter_title",
			"incidents_localised_title_" .. self.encounters[key].spawn_incident,
			"incidents_localised_description_" .. self.encounters[key].spawn_incident,
			554,
			false,
			"wh_dlc05_sc_wef_wood_elves"
		)
	end
	
	marker:is_persistent(false)
	marker:spawn_at_location(loc_x, loc_y)
end

function Worldroots:set_up_generic_encounter_forced_battle(character, target_faction_key, force_template_key, is_ambush, army_size_override, opt_general_subtype, opt_power_modifier, opt_ignore_effect_bundle)
	local power_modifier = opt_power_modifier or 0
	local effect_bundle = nil
	
	if not opt_ignore_effect_bundle then
		effect_bundle = self.invasion_force_interrupted_effect_bundle
	end
	
	Forced_Battle_Manager:trigger_forced_battle_with_generated_army(
		character:military_force():command_queue_index(),
		target_faction_key,
		force_template_key,
		army_size_override or Worldroots:calculate_enemy_force_size_from_player_force(character, 0),
		Worldroots.invasion_power_modifier + power_modifier,
		false,
		false,
		is_ambush,
		nil,
		nil,
		opt_general_subtype or nil,
		Worldroots.invasion_power_modifier + power_modifier,
		effect_bundle
	)
end

function Worldroots:generate_encounter(faction_interface)
	self.turns_since_last_marker = self.turns_since_last_marker + 1
	
	if self.turns_since_last_marker < self.marker_cooldown and not Worldroots.debug_ignore_marker_cooldown then
		return
	end
	
	local valid_encounters = Worldroots:generate_valid_encounter_list_for_faction(faction_interface:name())
	
	if valid_encounters then
		local random_encounter = valid_encounters[cm:random_number(#valid_encounters, 1)]
		local encounter_to_trigger = Worldroots.encounters[random_encounter]
		
		encounter_to_trigger:setup()
		if encounter_to_trigger.can_reoccur ~= true then
			table.insert(Worldroots.completed_encounters, random_encounter)
			Worldroots.completed_encounters[random_encounter] = true
		end
		
		self.turns_since_last_marker = 0
	end
end

-- functions for controlling the rituals and invasions
function Worldroots:set_up_ritual(forest, performing_faction)
	forest.rite_active = true
	
	local region = cm:get_region(forest.glade_region_key)
	
	-- apply some vfx
	cm:add_scripted_composite_scene_to_settlement("healing_ritual_" .. forest.key, self.ritual_vfx_key, region, 0, 0, false, true, true)
	
	local human_factions = cm:get_human_factions()
	
	for i = 1, #human_factions do
		local current_human_faction = cm:get_faction(human_factions[i])
		
		if current_human_faction:culture() == "wh_dlc05_wef_wood_elves" then
			local incident_key = "wh2_dlc16_incident_wef_ritual_begun_" .. forest.key
			
			-- different incident for drycha in gryphon wood
			if forest.key == "gryphon_wood" and performing_faction == "wh2_dlc16_wef_drycha" then
				incident_key = "wh2_dlc16_incident_wef_ritual_begun_gryphon_wood_drycha"
			end
			
			if performing_faction ~= human_factions[i] then
				incident_key = "wh2_dlc16_incident_wef_ritual_begun"
			end
			
			cm:trigger_incident_with_targets(current_human_faction:command_queue_index(), incident_key, 0, 0, 0, 0, region:cqi(), 0)
		end
	end
	
	-- use the marker manager to spawn a series of invasion markers, with an event that fires when they expire
	local marker_base_key = forest.key
	
	local countdown_markers = Interactive_Marker_Manager:create_countdown(
		marker_base_key,
		"ScriptEventWEFInvasionMarkerInteraction",
		"ScriptEventWEFInvasionMarkerExpired",
		{"invasion_marker_3", "invasion_marker_2", "invasion_marker_1"}
	)
	
	local countdown_marker_stage_1 = countdown_markers[1]
	local countdown_marker_stage_2 = countdown_markers[2]
	local countdown_marker_stage_3 = countdown_markers[3]
	
	local glade_owner = cm:get_region(forest.glade_region_key):owning_faction():name()
	
	countdown_marker_stage_1:add_spawn_event_feed_event(
		"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_title",
		"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_mustering_primary_detail",
		"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_mustering_secondary_detail", 
		554,
		glade_owner
	)
	
	countdown_marker_stage_3:add_spawn_event_feed_event(
		"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_title",
		"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_imminent_primary_detail",
		"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_imminent_secondary_detail", 
		554,
		glade_owner
	)
	
	countdown_marker_stage_3:add_despawn_event_feed_event(
		"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_title",
		"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_spawned_primary_detail",
		"event_feed_strings_text_wh2_dlc16_event_feed_string_scripted_event_invasion_spawned_secondary_detail", 
		554,
		glade_owner
	)
	
	local invasion_coord_list = forest.invasion_spawn_coords
	
	for i = 1, #invasion_coord_list do
		local x = invasion_coord_list[i][1]
		local y = invasion_coord_list[i][2]
		local random_duration = cm:random_number(3, 1)
		
		if random_duration == 3 then 
			countdown_marker_stage_1:spawn_at_location(x, y, false)
		elseif random_duration == 2 then
			countdown_marker_stage_2:spawn_at_location(x, y, false)
		else
			countdown_marker_stage_1:spawn_at_location(x, y, false)
		end
	end
end

function Worldroots:trigger_invasion(forest, x, y, force_size, opt_faction_override, opt_template_override)
	out("triggering invasion of" .. forest.glade_region_key)
	
	local invasion_target = forest.glade_region_key
	local glade_owner_key = cm:get_region(invasion_target):owning_faction():name()
	local invasion_faction = opt_faction_override or forest.invasion_faction
	
	if cm:get_faction(invasion_faction):is_human() then
		invasion_faction = forest.invasion_faction_alternate
	end
	
	local invasion_army_template = opt_template_override or cm:get_faction(invasion_faction):subculture()
	
	if not opt_template_override and forest.invasion_army_template_override then
		invasion_army_template = forest.invasion_army_template_override
	end
	
	local unit_list = WH_Random_Army_Generator:generate_random_army(forest.invasion_force_key, invasion_army_template, force_size, self.invasion_power_modifier, true, false)
	
	if x and y then
		local invasion_key = forest.rite_key .. "_invasion_" .. x .. y
		local spawn_location_x, spawn_location_y = cm:find_valid_spawn_location_for_character_from_position(glade_owner_key, x, y, true)
		local invasion_object = invasion_manager:new_invasion(invasion_key, invasion_faction,unit_list, {spawn_location_x, spawn_location_y})
		invasion_object:apply_effect("wh2_dlc16_bundle_military_upkeep_free_force_immune_to_regionless_attrition", -1)
		invasion_object:set_target("REGION", invasion_target,glade_owner_key)
		invasion_object:add_aggro_radius(25, {glade_owner_key}, 1)
		invasion_object:start_invasion(true, true, false, false)
	end
end

-- all the tidy-up we need to do once a ritual is completed
function Worldroots:complete_ritual(forest, faction_key)
	-- clean up vfx
	local function clear_forest_csc()
		cm:remove_scripted_composite_scene("healing_ritual_" .. forest.key)
		cm:add_scripted_composite_scene_to_settlement("ritual_finished", self.ritual_finished_vfx_key, cm:get_region(forest.glade_region_key), 0, 0, true, true, true)
	end
	
	if not cm:is_multiplayer() and cm:get_local_faction_name(true) == faction_key then
		cm:scroll_camera_with_cutscene_to_settlement(
			3,
			function()
				clear_forest_csc()
			end,
			forest.glade_region_key
		)
	else
		clear_forest_csc()
	end
	
	Interactive_Marker_Manager:clear_marker_type(forest.key .. "_invasion_marker_1")
	Interactive_Marker_Manager:clear_marker_type(forest.key .. "_invasion_marker_2")
	Interactive_Marker_Manager:clear_marker_type(forest.key .. "_invasion_marker_3")
	
	local invasion_coord_list = forest.invasion_spawn_coords
	
	for i = 1, #invasion_coord_list do
		local invasion_key = forest.rite_key .. "_invasion_" .. invasion_coord_list[i][1] .. invasion_coord_list[i][2]
		invasion_manager:kill_invasion_by_key(invasion_key)
	end
	
	self:grant_ritual_rewards(forest, faction_key)
	
	forest.rite_active = false
end

function Worldroots:grant_ritual_rewards(forest, completing_faction_key)
	local region_cqi = cm:get_region(forest.glade_region_key):cqi()
	local human_factions = cm:get_human_factions()
	
	forest.rite_completed = true
	
	if forest.locked_building then
		cm:remove_event_restricted_building_record(forest.locked_building)
	end
	
	if forest.custom_ritual_completion_callback then
		forest.custom_ritual_completion_callback(completing_faction_key)
	end
	
	for i = 1, #human_factions do
		local current_human_faction = cm:get_faction(human_factions[i])
		
		if current_human_faction:culture() == "wh_dlc05_wef_wood_elves" then
			cm:lock_ritual(current_human_faction, forest.rite_key)
		end
	end
	
	if forest.rite_key == "wh2_dlc16_ritual_rebirth_athel_loren" then
		cm:complete_scripted_mission_objective(completing_faction_key, "wh_main_short_victory", "athel_healed", true)
		cm:complete_scripted_mission_objective(completing_faction_key, "wh_main_long_victory", "athel_healed", true)
	end
	
	if self:human_wood_elf_controls_glade(forest) and not cm:get_region(forest.glade_region_key):owning_faction():at_war_with(cm:get_faction(completing_faction_key)) then
		for i = 1, #human_factions do
			local current_human_faction = cm:get_faction(human_factions[i])
			
			if current_human_faction:culture() == "wh_dlc05_wef_wood_elves" then
				local incident_key = "wh2_dlc16_incident_wef_ritual_succeeded_" .. forest.key
				
				if forest.key == "gryphon_wood" and completing_faction_key == "wh2_dlc16_wef_drycha" then
					incident_key = "wh2_dlc16_incident_wef_ritual_succeeded_gryphon_wood_drycha"
				end
				
				if completing_faction_key ~= human_factions[i] then
					incident_key = "wh2_dlc16_incident_wef_ritual_succeeded"
				end
				
				cm:trigger_incident_with_targets(current_human_faction:command_queue_index(), incident_key, 0, 0, 0, 0, region_cqi, 0)
			end
		end
	else
		for i = 1, #human_factions do
			local current_human_faction = cm:get_faction(human_factions[i])
			
			if current_human_faction:culture() == "wh_dlc05_wef_wood_elves" then
				local incident_key = "wh2_dlc16_incident_wef_ritual_failed_other"
				
				if cm:get_region(forest.glade_region_key):owning_faction():name() == human_factions[i] then
					incident_key = "wh2_dlc16_incident_wef_ritual_failed_other_pvp"
				elseif human_factions[i] == completing_faction_key then
					incident_key = "wh2_dlc16_incident_wef_ritual_failed"
				end
				
				cm:trigger_incident_with_targets(current_human_faction:command_queue_index(), incident_key, 0, 0, 0, 0, region_cqi, 0)
			end
		end
	end
	
	core:trigger_event("ScriptEventForestRitualCompletedEvent")
end

function Worldroots:ritual_ready_check(forest)
	local glade_owner_faction_interface = cm:get_region(forest.glade_region_key):owning_faction()
	
	if not Worldroots:faction_is_human_wood_elf(glade_owner_faction_interface:name()) then
		return false
	end
	
	local healing_amount = glade_owner_faction_interface:pooled_resource_manager():resource(forest.pooled_resource):value()
	local ritual_resource_required = Worldroots.ritual_resource_required_default
	
	if is_number(forest.ritual_resource_required_override) then
		ritual_resource_required = forest.ritual_resource_required_override
	end
	
	if not forest.rite_completed and not forest.rite_active and healing_amount > (ritual_resource_required - 1) then
		cm:trigger_incident_with_targets(glade_owner_faction_interface:command_queue_index(), "wh2_dlc16_incident_wef_ritual_rebirth_available_" .. forest.key, 0, 0, 0, 0, cm:get_region(forest.glade_region_key):cqi(), 0)	
		core:trigger_event("ScriptEventForestRitualAvailable", forest.glade_region_key)
	end
end

-- High-level function for updating pooled resources
function Worldroots:update_worldroots_health()
	out("updating worldroots_health")
	local forests_list = self.forests
	local rites_completed = 0
	
	for forest_ref, forest in pairs(forests_list) do
		local glade_region_interface = cm:get_region(forest.glade_region_key)
		local primary_building_level = glade_region_interface:settlement():primary_slot():building():building_level()
		
		-- only go further if a player owns the glade
		if self:human_wood_elf_controls_glade(forest) and not forest.rite_completed and not forest.rite_active and not cm:is_new_game() then
			-- n.b. all negative factors need to go first otherwise you can be prevented from maxing out the bar!
			
			-- corruption
			if cm:get_total_corruption_value_in_region(glade_region_interface) >= self.corruption_threshold then
				Worldroots:add_pooled_resource_to_all_wood_elves(forest, "wh2_dlc16_resource_factor_corruption", self.corruption_penalty)
			end
			
			-- pacification
			local pacification_count, hostile_count = self:check_pacification(forest)
			
			Worldroots:add_pooled_resource_to_all_wood_elves(forest, "wh2_dlc16_resource_factor_hostile_regions", hostile_count)
			Worldroots:add_pooled_resource_to_all_wood_elves(forest, "wh2_dlc16_resource_factor_pacified_regions", pacification_count)
			
			-- technology
			local human_factions = cm:get_human_factions()
			
			for i = 1, #human_factions do
				local current_human_faction = cm:get_faction(human_factions[i])
				
				if current_human_faction:culture() == "wh_dlc05_wef_wood_elves" then
					local bv = cm:get_factions_bonus_value(current_human_faction, "worldroots_health_per_turn_all_regions")
					Worldroots:add_pooled_resource_to_all_wood_elves(forest, "events", bv)
				end
			end
			
			-- buildings
			local health_to_gain_from_buildings = cm:get_regions_bonus_value(cm:get_region(forest.glade_region_key), "world_roots_local_per_turn")
			
			if forest.additional_regions then
				for i = 1, #forest.additional_regions do
					health_to_gain_from_buildings = health_to_gain_from_buildings + cm:get_regions_bonus_value(cm:get_region(forest.additional_regions[i]), "world_roots_local_per_turn")
				end
			end
			
			Worldroots:add_pooled_resource_to_all_wood_elves(forest, "buildings", health_to_gain_from_buildings)
			
			local healing_amount = cm:get_faction(Worldroots.primary_player_key):pooled_resource_manager():resource(forest.pooled_resource):value()
			
			-- If the health goes below 0, we bump it back up. This allows us to display transactions that otherwise wouldn't show up if we hard-capped at 0
			if healing_amount < 0 then
				local correction = 0 - healing_amount
				Worldroots:add_pooled_resource_to_all_wood_elves(forest, "wh2_dlc16_resource_factor_hidden", correction)
			end
			
			self:ritual_ready_check(forest)
		end
	end
end

-- adds the pooled resource to all playable wood elf factions who are present in the campaign. 
-- Can exclude a specified faction (e.g. they're getting it from a different source and we want to mirror that gain to everyone else
-- If marked as 'in turn gain', will pulse VFX and check to see if ritual is ready
function Worldroots:add_pooled_resource_to_all_wood_elves(forest, factor, amount, excluded_faction_key, in_turn_gain)
	if amount > 0 and in_turn_gain then
		if cm:is_processing_battle() then
			cm:progress_on_battle_completed(
				"healing_vfx_pending_battle_delay",
				function()
					self:pulse_heal_vfx_for_forest(forest)
					cm:cancel_progress_on_battle_completed("healing_vfx_pending_battle_delay")
				end
			)
		else
			self:pulse_heal_vfx_for_forest(forest)
		end
	end
	
	local human_factions = cm:get_human_factions()
	
	for i = 1, #human_factions do
		local current_human_faction = cm:get_faction(human_factions[i])
		
		if current_human_faction:culture() == "wh_dlc05_wef_wood_elves" and human_factions[i] ~= excluded_faction_key then
			cm:faction_add_pooled_resource(human_factions[i], forest.pooled_resource, factor, amount)
		end
	end
	
	if in_turn_gain then
		self:ritual_ready_check(forest)
	end
end

function Worldroots:pulse_heal_vfx_for_forest(forest)
	cm:add_scripted_composite_scene_to_settlement("healing_pulse_" .. forest.key, self.ritual_vfx_key, cm:get_region(forest.glade_region_key), 0, 0, false, true, true)
	
	cm:callback(function() cm:remove_scripted_composite_scene("healing_pulse_" .. forest.key) end, 4)
end

function Worldroots:remove_encounter(encounter_key)
	local encounter_marker_object = Interactive_Marker_Manager:get_marker(encounter_key)
	
	if encounter_marker_object then
		encounter_marker_object:despawn_all()
	end
end

--------------------
---ONE-OFF EVENTS---
--------------------
function Worldroots:launch_avelorn_invasion()
	local gaean_vale_key = Worldroots.forests["gaean_vale"].glade_region_key
	local gaean_vale_region = cm:get_region(gaean_vale_key)
	local gaean_vale_invasion_faction = Worldroots.forests["gaean_vale"].invasion_faction
	
	local gaean_vale_owner_interface = gaean_vale_region:owning_faction()
	local gaean_vale_owner_key = gaean_vale_owner_interface:name()
	
	if gaean_vale_owner_interface:is_null_interface() or gaean_vale_owner_interface:is_human() or gaean_vale_owner_interface:subculture() ~= "wh2_main_sc_hef_high_elves" then
		return
	end
	
	cm:set_region_abandoned(gaean_vale_key)
	
	local spawn_x, spawn_y = cm:find_valid_spawn_location_for_character_from_settlement(gaean_vale_invasion_faction, gaean_vale_key, false, true, 3)
	local patrol_point_x, patrol_point_y = cm:find_valid_spawn_location_for_character_from_settlement(gaean_vale_invasion_faction, gaean_vale_key, false, true, 8)
	local unit_list = WH_Random_Army_Generator:generate_random_army("gaean_vale_invasion", "wh_main_sc_chs_chaos", 20, self.invasion_power_modifier, true)
	local gaean_vale_invasion = invasion_manager:new_invasion("gaean_vale_invasion",gaean_vale_invasion_faction, unit_list, {spawn_x, spawn_y})
	
	gaean_vale_invasion:apply_effect("wh_main_bundle_military_upkeep_free_force", -1)
	gaean_vale_invasion:should_maintain_army(true, 0.2)
	gaean_vale_invasion:set_target("PATROL", {{x = spawn_x, y = spawn_y}, {x = patrol_point_x, y = patrol_point_y}}, gaean_vale_owner_key)
	gaean_vale_invasion:add_aggro_radius(100, self.playable_wood_elf_factions, 1)
	gaean_vale_invasion:start_invasion(true)
	
	cm:cai_disable_targeting_against_settlement("settlement:" .. gaean_vale_key)
	
	local human_factions = cm:get_human_factions()
	
	for i = 1, #human_factions do
		local current_human_faction = cm:get_faction(human_factions[i])
		
		if current_human_faction:culture() == "wh_dlc05_wef_wood_elves" then
			cm:trigger_incident_with_targets(current_human_faction:command_queue_index(), "wh2_dlc16_incident_wef_avelorn_invaded", 0, 0, 0, 0, gaean_vale_region:cqi(), 0)
			cm:make_region_visible_in_shroud(human_factions[i], gaean_vale_key)
		end
	end
end

function Worldroots:end_avelorn_invasion()
	local gaean_vale_key = Worldroots.forests["gaean_vale"].glade_region_key
	
	local gaean_vale_invasion = invasion_manager:get_invasion("gaean_vale_invasion")
	if gaean_vale_invasion then
		gaean_vale_invasion:release()
		cm:cai_enable_targeting_against_settlement("settlement:" .. gaean_vale_key)
	end 
end

----------------------
---Helper functions---
----------------------

-- is a specified region adjacent to any forest? if so, return that forest table
function Worldroots:is_adjacent_to_forest(region_key)
	for forest_key, forest in pairs(self.forests) do
		local region_list = cm:model():world():lookup_regions_from_region_group(forest.region_group)
		
		for i = 0, region_list:num_items() - 1 do
			if region_key == region_list:item_at(i):name() then
				return forest
			end
		end
	end
end

function Worldroots:faction_is_human_wood_elf(faction_to_check)
	if is_string(faction_to_check) then
		faction_to_check = cm:get_faction(faction_to_check)
	end
	
	return faction_to_check and faction_to_check:is_human() and faction_to_check:subculture() == "wh_dlc05_sc_wef_wood_elves"
end

-- is a specified region part of any forest? if so, return that forest table
function Worldroots:is_part_of_forest(region_key)
	for forest_key, forest in pairs(self.forests) do
		if forest.glade_region_key == region_key then
			return forest
		end
		
		if forest.additional_regions then
			for i = 1, #forest.additional_regions do
				if region_key == forest.additional_regions[i] then
					return forest
				end
			end
		end
	end
end

function Worldroots:generate_valid_encounter_list_for_faction(faction_key)
	local valid_encounters = {}
	
	for encounter_key, encounter_info in pairs(self.encounters) do
		local is_valid = true
		
		if encounter_info.faction_filter and encounter_info.faction_filter ~= faction_key then
			is_valid = false
		end
		
		if not cm:get_region(encounter_info.region) then
			is_valid = false
		end
		
		local forest = Worldroots.forests[encounter_info.forest]
		
		if forest and not Worldroots:human_wood_elf_controls_glade(forest) then
			is_valid = false
		end
		
		if encounter_info.spawn_turn and encounter_info.spawn_turn >= cm:turn_number() and not Worldroots.debug_ignore_marker_cooldown then
			is_valid = false
		end
		
		if is_function(encounter_info.custom_condition) and not encounter_info:custom_condition() then
			is_valid = false
		end 
		
		if self.completed_encounters[encounter_key] then
			is_valid = false
		end
		
		if is_valid then
			table.insert(valid_encounters, encounter_key)
			valid_encounters[encounter_key] = true
		end
	end
	
	if #valid_encounters > 0 then
		return valid_encounters
	end
end

function Worldroots:calculate_invasion_power()
	local turn_number = cm:turn_number()
	local turn_mod = 0
	local difficulty_mod = 0
	local rituals_completed = self:count_completed_rituals()
	local ritual_mod = 0
	
	if turn_number <= 10 then
		turn_mod = 1
	elseif turn_number <= 20 then
		turn_mod = 2
	elseif turn_number <= 40 then
		turn_mod = 3
	elseif turn_number <= 50 then
		turn_mod = 4
	elseif turn_number <= 75 then
		turn_mod = 5
	elseif turn_number < 100 then
		turn_mod = 6
	else
		turn_mod = 7
	end
	
	if cm:get_difficulty() < 2 then
		difficulty_mod = 0
	elseif cm:get_difficulty() >= 3 then
		difficulty_mod = 2
	else
		difficulty_mod = 1
	end
	
	if rituals_completed >= 4 then
		ritual_mod = 2
	elseif rituals_completed >= 2 then
		ritual_mod = 1
	end
	
	Worldroots.invasion_power_modifier = turn_mod + difficulty_mod + ritual_mod
end

function Worldroots:count_completed_rituals()
	local completed_ritual_count = 0
	
	for k, v in pairs(Worldroots.forests) do
		if v.rite_completed then
			completed_ritual_count = completed_ritual_count + 1
		end
	end
	
	return completed_ritual_count
end

function Worldroots:human_wood_elf_controls_glade(forest)
	return Worldroots:faction_is_human_wood_elf(cm:get_region(forest.glade_region_key):owning_faction())
end

-- find a forest by rite. Used in listeners where we listen for the rite
function Worldroots:get_forest_by_rite(string_rite_key)
	for forest_ref, forest in pairs(Worldroots.forests) do
		if forest.rite_key == string_rite_key then 
			return forest 
		end
	end
end

function Worldroots:calculate_enemy_force_size_from_player_force(player_character_interface, modifier)
	local enemy_force_size = player_character_interface:military_force():unit_list():num_items()
	
	if enemy_force_size < 5 then
		enemy_force_size = 5
	end
	
	enemy_force_size = enemy_force_size + modifier
	
	if enemy_force_size > 19 then
		enemy_force_size = 19
	end
	
	return enemy_force_size
end

-- returns the number of pacified and hostile regions adjacent to a forest's glade region
function Worldroots:check_pacification(forest)
	local hostile_count = 0
	local pacified_count = 0
	local glade_owner = cm:get_region(forest.glade_region_key):owning_faction()
	local region_list = cm:model():world():lookup_regions_from_region_group(forest.region_group)
	
	for i = 0, region_list:num_items() - 1 do
		local adjacent_region = region_list:item_at(i)
		
		if forest.glade_region_key ~= adjacent_region:name() then
			local adjacent_region_owning_faction = adjacent_region:owning_faction()
			
			if adjacent_region:is_abandoned() then
				pacified_count = pacified_count + self.pacified_value
			elseif Worldroots:faction_is_human_wood_elf(adjacent_region_owning_faction) then
				pacified_count = pacified_count + self.pacified_value
			elseif adjacent_region_owning_faction:is_ally_vassal_or_client_state_of(glade_owner) then
				pacified_count = pacified_count + self.pacified_value
			elseif glade_owner:at_war_with(adjacent_region_owning_faction) then
				hostile_count = hostile_count + self.hostile_value
			end
		end
	end
	
	return pacified_count, hostile_count
end

---------------------
------save/load------
---------------------
cm:add_saving_game_callback(
	function(context)
		for k, v in pairs(Worldroots.forests) do
			cm:save_named_value("Worldroots" .. k .. "_rite_completed", v.rite_completed, context)
			cm:save_named_value("Worldroots" .. k .. "rite_active", v.rite_active,context)
		end
		
		cm:save_named_value("WorldrootsCompletedEncounters", Worldroots.completed_encounters, context)
		cm:save_named_value("WorldrootsTurnsSinceLastMarker", Worldroots.turns_since_last_marker, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			for k, v in pairs(Worldroots.forests) do
				v.rite_completed = cm:load_named_value("Worldroots" .. k .. "_rite_completed", false, context)
				v.rite_active = cm:load_named_value("Worldroots" .. k .. "rite_active", false, context)
			end
			
			Worldroots.completed_encounters = cm:load_named_value("WorldrootsCompletedEncounters", {}, context)
			Worldroots.turns_since_last_marker = cm:load_named_value("WorldrootsTurnsSinceLastMarker", 0, context)
		end
	end
)