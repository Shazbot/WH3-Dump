local data = {
	load_order = 0,
	-- UI to hide when zooming into the map.
	map_ui = {"campaign_3d_ui", "parchment_overlay", "campaign_flags", "campaign_flags_strength_bars"},
	-- Any faction in here has its Lord's ID used as a variant key when getting intro data. These are usually factions that have multiple LLs, each requiring a unique intro.
	factions_using_lord_as_variant_key = {
		wh_main_vmp_schwartzhafen = true,
	}
}

-- Conditions by which a faction can provide a variant key are defined here. You may want to use the presence of a given effect bundle as a reason to have a particular intro to play, for example.
-- Criteria are executed in priority of first to last: if an earlier getter is satisfied and provides a non-nil variant key, then later getters will not be consulted.
data.variant_key_getters = {
	-- In the case of factions with multiple possible lords, the find the current general of the faction's starting army and use their unit subtype as the variant key.
	function(faction_interface)
		local variant_key = nil
		if data.factions_using_lord_as_variant_key[faction_interface:name()] then
			local mobile_mfs = cm:get_mobile_force_interface_list(faction_interface:military_force_list(), non_standard_army_types);
			if #mobile_mfs > 1 then
				script_error(string.format("ERROR: Could not set up faction intro. Faction '%s' was marked as using its lord as a variant key, but has multiple armies on the map. Cannot determine which general to use as the variant key (normally, the only one leading an army is selected).", faction_interface:name()))
			elseif #mobile_mfs == 0 then
				script_error(string.format("ERROR: Could not set up faction intro. Faction '%s' was marked as using its lord as a variant key, but has no armies on the map. Cannot determine which general to use as the variant key (normally, the only one leading an army is selected).", faction_interface:name()))
			else
				variant_key = mobile_mfs[1]:general_character():character_subtype_key()
			end
		end
		return variant_key
	end
}

data.intro_presets = {
	standard = {
		how_they_play = true,
	}
}

data.cutscene_styles = {
	zoom_in_and_speak = function(self)
		local valid, missing_fields = data.validate_data_for_style(self, { "cam_cutscene_start", "advice_line" })
		if not valid then
			script_error("ERROR: Not all data required to use the zoom_in_and_speak cutscene style was present on this faciton intro table. Missing fields: " .. missing_fields)
			return false, missing_fields
		end

		local new_configurator = function(cutscene)
            cutscene:set_relative_mode(true)
            cutscene:action_fade_scene(0, 1, 2)
            cutscene:action_override_ui_visibility(0, false, data.map_ui)
            -- Other functions take xydbk coords but this one takes enumerated ones. Need to translate from one to the other.
            cutscene:action_set_camera_position(0, { self.cam_cutscene_start.x, self.cam_cutscene_start.y, self.cam_cutscene_start.d, self.cam_cutscene_start.b, self.cam_cutscene_start.h })
            cutscene:action_scroll_camera_to_position(1, 8, true, { self.cam_gameplay_start.x, self.cam_gameplay_start.y, self.cam_gameplay_start.d, self.cam_gameplay_start.b, self.cam_gameplay_start.h })
            cutscene:action_show_advice(5, self.advice_line)
            -- Wait for the advisor to finish before proceeding, and then wait 2 seconds to smooth UI transition.
            cutscene:action(
                function()
                    cutscene:wait_for_advisor()
                end,
                2
            );
            cutscene:action_end_cutscene(0)
            -- Clear UI on end or on skip.
            -- The faction intro system already loads up the end-cutscene with other stuff ('How They Play', etc.) before this is called, so we need to prepend the end-cutscene rather than set it outright.
            cutscene:prepend_end_cutscene(
                function()
                    for u = 1, #data.map_ui do
                        cm:get_campaign_ui_manager():override(data.map_ui[u]):set_allowed(true);
                    end;
                end
            )
        end

		return new_configurator
	end
}

data.validate_data_for_style = function(data, required_fields)
	local missing_fields_string = ""

	for f = 1, #required_fields do
		if data[required_fields[f]] == nil then
			local comma_prefix
			if #missing_fields_string > 0 then
				comma_prefix = ", '"
			else
				comma_prefix = "'"
			end
			missing_fields_string = missing_fields_string .. comma_prefix .. required_fields[f] .. "'"

		end
	end

	if #missing_fields_string > 0 then
		return false, missing_fields_string
	else
		return true, nil
	end
end

data.faction_intros = {

-- --- THIS IS AN EXAMPLE OF THE CUSTSCENE CONFIG OPENED OUT TO BE ABLE TO CUSTOMISE IT
-- --- USED FOR SPECIFIC TIMINGS AND ADDITIONAL CAMERA MOVEMENTS IF NEEDED 

-- 	wh2_main_def_naggarond = faction_intro_data:new{
-- 		preset = data.intro_presets.standard,
-- 		cam_gameplay_start = {
-- 			x = 66,
-- 			y = 645,
-- 			d = 6.965149,
-- 			b = 0,
-- 			h = 8.008892,
-- 		},
-- 		cutscene_configurator = function(cutscene)
-- 			cutscene:set_relative_mode(true)
-- 			cutscene:action_fade_scene(0, 1, 2)
-- 			cutscene:action_override_ui_visibility(0, false, data.map_ui)
-- 			cutscene:action_set_camera_position(0, {66, 645, 20.705231, 0.0, 65.031822})
-- 			cutscene:action_scroll_camera_to_position(1, 8, true, {66, 645, 6.965149, 0.0, 8.008892})
-- 			cutscene:action_show_advice(6, "wh3_flyby_dummy_KF")
-- 			cutscene:action_override_ui_visibility(7, true, data.map_ui)
-- 			cutscene:action_end_cutscene(0)
-- 		end
-- 	},
-- --- END OF EXAMPLE ---

	--------------------
	------NAGGAROTH-----
	--------------------
	wh2_main_def_naggarond = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 66, y = 645,	d = 20.705231, b = 0,	h = 65.031822,},
		cam_gameplay_start = {x = 66, y = 645,	d = 6.965149, b = 0, h = 8.008892,},
		advice_line = "wh3_dlc21_ie_camp_def_malekith_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh2_main_def_har_ganeth = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 134, y = 641,	d = 20.705231, b = 0,	h = 65.031822,},
		cam_gameplay_start = {x = 134, y = 641,	d = 6.965149, b = 0, h = 8.008892,},
		advice_line = "wh3_dlc21_ie_camp_def_hellebron_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh2_dlc17_bst_taurox = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 71.712395, y = 566.19928,	d = 28.576233, b = 0,	h = 63.119427,},
		cam_gameplay_start = {x = 71.71244, y = 560.182983,	d = 8.776794, b = 0, h = 6.939139,},
		advice_line = "wh3_dlc21_ie_camp_bst_taurox_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh2_dlc09_tmb_exiles_of_nehek = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 17, y = 508,	d = 20.705231, b = 0,	h = 65.031822,},
		cam_gameplay_start = {x = 17, y = 508,	d = 6.965149, b = 0, h = 8.008892,},
		advice_line = "wh3_dlc21_ie_camp_tmb_khatep_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh2_dlc16_wef_sisters_of_twilight = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 57, y = 521,	d = 20.705231, b = 0,	h = 65.031822,},
		cam_gameplay_start = {x = 57, y = 521,	d = 6.965149, b = 0, h = 8.008892,},
		advice_line = "wh3_dlc21_ie_camp_wef_sisters_of_twilight_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh2_main_hef_nagarythe = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 145.563339, y = 588.410889,	d = 29.625549, b = 0.0,	h = 66.128632,},
		cam_gameplay_start = {x = 145.563339, y = 588.410889,	d = 7.662231, b = 0, h = 5.733928,},
		advice_line = "wh3_dlc21_ie_camp_hef_alith_anar_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh3_dlc20_chs_valkia = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 77, y = 696,	d = 20.705231, b = 0.0,	h = 65.031822,},
		cam_gameplay_start = {x = 79.222656, y = 696.11615,	d = 10.62439, b = 0, h = 8.38524,},
		advice_line = "wh3_dlc21_ie_camp_chs_valkia_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh3_main_dwf_the_ancestral_throng = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 10.999999, y = 615.677734, d = 8.123718, b = 0.0,	h = 9.444157,},
		cam_gameplay_start = {x = 11, y = 612.481201,	d = 10.585083, b = 0, h = 8.148836,},
		advice_line = "wh3_dlc21_ie_camp_dwf_grombrindal_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh2_dlc11_cst_the_drowned = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 133, y = 547,	d = 20.705231, b = 0.0,	h = 65.031822,},
		cam_gameplay_start = {x = 129.988617, y = 549.122742,	d = 11.520569, b = 0, h = 8.827258,},
		advice_line = "wh3_dlc21_ie_camp_cst_cylostra_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},
	
	wh3_dlc24_ksl_daughters_of_the_forest = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 64.5, y = 472.8,	d = 21.561523, b = 0.0,	h = 62.004826,},
		cam_gameplay_start = {x = 64.5, y = 472.8,	d = 7.926331, b = 0, h = 12.026555,},
		advice_line = "wh3_dlc24_ie_camp_ksl_mother_ostankya_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak,
		fullscreen_movie = "warhammer3/ksl/mother_ostankya_intro"
	},



	--------------------
	----CHAOS WASTES----
	--------------------
	wh3_dlc20_chs_sigvald = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 248, y = 683,	d = 20.705231, b = 0.0,	h = 65.031822,},
		cam_gameplay_start = {x = 248, y = 680.564331,	d = 9.318115, b = 0, h = 10.90763,},
		advice_line = "wh3_dlc21_ie_camp_chs_sigvald_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh3_dlc20_chs_kholek = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 687, y = 558,	d = 20.705231, b = 0.0,	h = 65.031822,},
		cam_gameplay_start = {x = 687, y = 570.425964,	d = 10.321045, b = 0, h = 12.500605,},
		advice_line = "wh3_dlc21_ie_camp_chs_kholek_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh2_main_def_hag_graef = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 393, y = 715,	d = 20.705231, b = 0.0,	h = 65.031822,},
		cam_gameplay_start = {x = 393.503754, y = 719.28479, d = 7.077576, b = 0, h = 8.11406,},
		advice_line = "wh3_dlc21_ie_camp_def_malus_darkblade_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh3_main_ksl_ursun_revivalists = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 515.24, y = 666.03,	d = 20.705231, b = 0.0,	h = 65.031822,},
		cam_gameplay_start = {x = 515.24, y = 666.03,	d = 6.965149, b = 0, h = 8.008892,},
		advice_line = "wh3_dlc21_ie_camp_ksl_boris_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh_main_chs_chaos = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 607, y = 674,	d = 20.705231, b = 0.0,	h = 65.031822,},
		cam_gameplay_start = {x = 607, y = 674,	d = 6.965149, b = 0, h = 8.008892,},
		advice_line = "wh3_dlc21_ie_camp_chs_archaon_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh3_main_dae_daemon_prince = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 436.466309, y = 722.225769,	d = 22.638367, b = 0.0,	h = 64.875122,},
		cam_gameplay_start = {x = 436.466309, y = 719.910156,	d = 9.694824, b = 0, h = 11.417195,},
		advice_line = "wh3_dlc21_ie_camp_dae_daemon_prince_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},


	--------------------
	-------NORSCA-------
	--------------------
	wh_dlc08_nor_norsca = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 292.087036, y = 613.246582, d = 22.373718, b = 0.0, h = 62.854267,},
		cam_gameplay_start = {x = 292.087036, y = 609.878967, d = 5.863022, b = 0, h = 7.007546,},
		advice_line = "wh3_dlc21_ie_camp_nor_wulfrik_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh_dlc08_nor_wintertooth = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 426, y = 677,	d = 20.705231, b = 0.0,	h = 65.031822,},
		cam_gameplay_start = {x = 426, y = 677,	d = 6.965149, b = 0, h = 8.008892,},
		advice_line = "wh3_dlc21_ie_camp_nor_throgg_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh3_dlc20_chs_azazel = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 415, y = 640,	d = 20.705231, b = 0.0,	h = 65.031822,},
		cam_gameplay_start = {x = 415, y = 637.852112,	d = 8.55603, b = 0, h = 9.996096,},
		advice_line = "wh3_dlc21_ie_camp_chs_azazel_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh3_dlc20_chs_festus = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 392.915039, y = 555.453613, d = 22.807007, b = 0.0,	h = 64.60685,},
		cam_gameplay_start = {x = 392.915039, y = 554.021301, d = 8.170898, b = 0, h = 9.542639,},
		advice_line = "wh3_dlc21_ie_camp_chs_festus_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh2_main_skv_clan_moulder = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 462, y = 619,	d = 20.705231, b = 0.0,	h = 65.031822,},
		cam_gameplay_start = {x = 458.319489, y = 620.507507,	d = 6.772766, b = 0, h = 7.828623,},
		advice_line = "wh3_dlc21_ie_camp_skv_throt_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh3_main_ksl_the_ice_court = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 467, y = 564,	d = 20.705231, b = 0.0,	h = 65.031822,},
		cam_gameplay_start = {x = 467, y = 564,	d = 6.965149, b = 0, h = 8.008892,},
		advice_line = "wh3_dlc21_ie_camp_ksl_katarin_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh3_main_ksl_the_great_orthodoxy = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 421, y = 605,	d = 20.705231, b = 0.0,	h = 65.031822,},
		cam_gameplay_start = {x = 422, y = 605.674072, d = 6.358704, b = 0, h = 7.254923,},
		advice_line = "wh3_dlc21_ie_camp_ksl_kostaltyn_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh3_main_chs_shadow_legion = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 235, y = 565,	d = 20.705231, b = 0.0,	h = 65.031822,},
		cam_gameplay_start = {x = 236.674316, y = 565.571716, d = 9.102661, b = 0, h = 10.597362,},
		advice_line = "wh3_dlc21_ie_camp_dae_belakor_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},


	--------------------
	-------EMPIRE-------
	--------------------
	wh_main_emp_empire = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 355.687042, y = 499.462219,	d = 22.456482, b = 0.0,	h = 65.031822,},
		cam_gameplay_start = {x = 355.687042, y = 487.026276,	d = 6.965149, b = 0, h = 8.008892,},
		advice_line = "wh3_dlc21_ie_camp_emp_karl_franz_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh2_dlc13_emp_golden_order = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 399.372192, y = 437.864746,	d = 20.705231, b = 0.0,	h = 65.031822,},
		cam_gameplay_start = {x = 399.372192, y = 434.674164,	d = 7.694366, b = 0, h = 9.052497,},
		advice_line = "wh3_dlc21_ie_camp_emp_balthasar_gelt_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh_dlc03_bst_beastmen = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 350.951904, y = 563.344727,	d = 22.007202, b = 0.0,	h = 63.605217,},
		cam_gameplay_start = {x = 351.415283, y = 557.318481,	d = 8.019348, b = 0.0,	h = 9.410876,},
		advice_line = "wh3_dlc21_ie_camp_bst_khazrak_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh2_dlc16_wef_drycha = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 448.789307, y = 521.071411,	d = 22.276367, b = 0.0,	h = 66.703285,},
		cam_gameplay_start = {x = 448.789307, y = 517.902344,	d = 8.168488, b = 0, h = 9.489678,},
		advice_line = "wh3_dlc21_ie_camp_wef_drycha_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh_main_vmp_schwartzhafen = {
		wh_dlc04_vmp_vlad_con_carstein = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 483.219208, y = 486.664215,	d = 21.561523, b = 0.0,	h = 62.004826,},
		cam_gameplay_start = {x = 479.425568, y = 477.427551,	d = 8.30011, b = 0, h = 9.739759,},
		advice_line = "wh3_dlc21_ie_camp_vmp_vlad_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
		},
		wh_pro02_vmp_isabella_von_carstein = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 483.219208, y = 486.664215,	d = 21.561523, b = 0.0,	h = 62.004826,},
		cam_gameplay_start = {x = 479.425568, y = 477.427551,	d = 8.30011, b = 0, h = 9.739759,},
		advice_line = "wh3_dlc21_ie_camp_vmp_vlad_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
		},
	},

	wh2_dlc15_grn_bonerattlaz = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 528.952576, y = 530.087646,	d = 19.733612, b = 0.0,	h = 57.401836,},
		cam_gameplay_start = {x = 528.952576, y = 532.794678,	d = 7.590027, b = 0, h = 9.176775,},
		advice_line = "wh3_dlc21_ie_camp_grn_azhag_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},
	
	wh3_dlc24_tze_the_deceivers = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 424.9, y = 489.8,	d = 21.561523, b = 0.0,	h = 62.004826,},
		cam_gameplay_start = {x = 424.9, y = 489.8,	d = 14, b = 0, h = 18,},
		advice_line = "wh3_dlc24_ie_camp_tze_the_changeling_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak,
		fullscreen_movie = "warhammer3/tze/the_changeling_intro"
	},
	
	
	--------------------
	-------ULTHUAN------
	--------------------
	wh2_main_hef_eataine = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 169.323624, y = 399.421021,	d = 22.776184, b = 0.0,	h = 64.580856,},
		cam_gameplay_start = {x = 166, y = 395.970886,	d = 6.469513, b = 0, h = 7.389846,},
		advice_line = "wh3_dlc21_ie_camp_hef_tyrion_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh2_main_hef_avelorn = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 181.447647, y = 446.354462,	d = 22.670227, b = 0.0,	h = 64.932167,},
		cam_gameplay_start = {x = 178.266434, y = 449.685333,	d = 6.470276, b = 0, h = 8.008892,},
		advice_line = "wh3_dlc21_ie_camp_hef_alarielle_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh3_main_sla_seducers_of_slaanesh = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 189.327164, y = 487.072174,	d = 21.184387, b = 0.0,	h = 59.456924,},
		cam_gameplay_start = {x = 189.327164, y = 482.086884,	d = 4.809784, b = 0, h = 5.60068,},
		advice_line = "wh3_dlc21_ie_camp_sla_nkari_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh2_dlc11_cst_noctilus = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 127.05687, y = 394.545166,	d = 22.580475, b = 0.0,	h = 65.362694,},
		cam_gameplay_start = {x = 127.05687, y = 396.63858,	d = 9.462006, b = 0, h = 11.12604,},
		advice_line = "wh3_dlc21_ie_camp_cst_noctilus_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh2_main_hef_yvresse = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 387.606537, y = 309.653656,	d = 22.432037, b = 0.0,	h = 65.245163,},
		cam_gameplay_start = {x = 388.415863, y = 313.213654,	d = 6.660156, b = 0, h = 7.6633,},
		advice_line = "wh3_dlc21_ie_camp_hef_eltharion_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},


	--------------------
	------BRETONNIA-----
	--------------------
	wh_main_brt_bretonnia = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 270.50824, y = 512.784729,	d = 22.389313, b = 0.0,	h = 62.902775,},
		cam_gameplay_start = {x = 270.186188, y = 512.725403,	d = 6.432648, b = 0, h = 7.483283,},
		advice_line = "wh3_dlc21_ie_camp_brt_louen_leoncour_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh_main_brt_carcassonne = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 304.47345, y = 390.137848, d = 21.09317, b = 0.0,	h = 62.474281,},
		cam_gameplay_start = {x = 304.47345, y = 393.478943,	d = 9.355164, b = 0, h = 11.078936,},
		advice_line = "wh3_dlc21_ie_camp_brt_fay_enchantress_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh2_dlc11_vmp_the_barrow_legion = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 302.568115, y = 473.052795,	d = 22.177826, b = 0.0,	h = 62.876984,},
		cam_gameplay_start = {x = 302.568115, y = 475.910431,	d = 8.755585, b = 0, h = 10.461603,},
		advice_line = "wh3_dlc21_ie_camp_vmp_kemmler_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh_dlc05_wef_wood_elves = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 318.634247, y = 402.222961,	d = 21.173523, b = 0,	h = 62.488998,},
		cam_gameplay_start = {x = 318.634247, y = 398.895996,	d = 7.779846, b = 0, h = 9.203243,},
		advice_line = "wh3_dlc21_ie_camp_wef_orion_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh_dlc05_wef_argwylon = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 355.406952, y = 452.072052,	d = 20.517517, b = 0.0,	h = 59.694164,},
		cam_gameplay_start = {x = 354.861176, y = 447.953522,	d = 7.298492, b = 0, h = 8.792109,},
		advice_line = "wh3_dlc21_ie_camp_wef_durthu_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh2_dlc15_grn_broken_axe = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 290.86972, y = 428.89624,	d = 22.129669, b = 0.0,	h = 65.820564,},
		cam_gameplay_start = {x = 292.215088, y = 426.483307,	d = 7.382202, b = 0, h = 8.567543,},
		advice_line = "wh3_dlc21_ie_camp_grn_grom_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},


	--------------------
	---BORDER PRINCES---
	--------------------
	wh2_main_skv_clan_skryre = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 313.059265, y = 352.136627, d = 22.50946, b = 0.0,	h = 65.617203,},
		cam_gameplay_start = {x = 313.059265, y = 341.50766, d = 7.673431, b = 0, h = 8.841416,},
		advice_line = "wh3_dlc21_ie_camp_skv_ikit_claw_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh_main_dwf_karak_izor = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 347.409088, y = 370.409912, d = 22.681915, b = 0.0,	h = 63.901283,},
		cam_gameplay_start = {x = 349.528625, y = 368.810059, d = 7.056396, b = 0, h = 8.312189,},
		advice_line = "wh3_dlc21_ie_camp_dwf_belegar_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh2_dlc11_cst_pirates_of_sartosa = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 342.984894, y = 304.329956, d = 23.059906, b = 0.0,	h = 64.752098,},
		cam_gameplay_start = {x = 339.60791, y = 305.003143, d = 6.23761, b = 0, h = 7.10297,},
		advice_line = "wh3_dlc21_ie_camp_cst_aranessa_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh3_main_ogr_disciples_of_the_maw = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 427.641541, y = 403.10611, d = 22.167816, b = 0.0,	h = 66.498634,},
		cam_gameplay_start = {x = 427.641541, y = 403.10611, d = 8.717041, b = 0, h = 10.132499,},
		advice_line = "wh3_dlc21_ie_camp_ogr_skragg_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh_dlc05_bst_morghur_herd = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 274.81366, y = 354.782471, d = 22.50647, b = 0.0,	h = 67.190697,},
		cam_gameplay_start = {x = 274.81366, y = 348.80722,	d = 8.298676, b = 0, h = 9.632097,},
		advice_line = "wh3_dlc21_ie_camp_bst_morghur_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},


	--------------------
	----THE ISTHMUS-----
	--------------------
	wh2_main_lzd_hexoatl = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 36.596851, y = 391.168793,	d = 22.094147, b = 0.0,	h = 63.628464,},
		cam_gameplay_start = {x = 36.596851, y = 381.037628,	d = 8.891541, b = 0, h = 10.450596,},
		advice_line = "wh3_dlc21_ie_camp_lzd_mazdamundi_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh2_main_def_cult_of_pleasure = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 52, y = 441,	d = 21.561523, b = 0.0,	h = 62.004826,},
		cam_gameplay_start = {x = 52, y = 441,	d = 7.926331, b = 0, h = 11.630013,},
		advice_line = "wh3_dlc21_ie_camp_def_morathi_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},
	
	wh3_dlc24_cth_the_celestial_court = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 46.9, y = 305,	d = 21.561523, b = 0.0,	h = 62.004826,},
		cam_gameplay_start = {x = 46.9, y = 305,	d = 7.926331, b = 0, h = 12.026555,},
		advice_line = "wh3_dlc24_ie_camp_cth_yuan_bo_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak,
		fullscreen_movie = "warhammer3/cth/yuan_bo_intro"
	},


	--------------------
	------BADLANDS------
	--------------------
	wh_main_grn_orcs_of_the_bloody_hand = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 428.481445, y = 338.935181,	d = 22.126953, b = 0.0,	h = 64.061188,},
		cam_gameplay_start = {x = 428.481445, y = 336.249146,	d = 9.03183, b = 0, h = 10.620801,},
		advice_line = "wh3_dlc21_ie_camp_grn_wurrzag_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh3_main_kho_exiles_of_khorne = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 462.971191, y = 247.862244,	d = 21.887283, b = 0.0,	h = 65.773239,},
		cam_gameplay_start = {x = 459.347443, y = 252.015839,	d = 10.073624, b = 0, h = 11.982787,},
		advice_line = "wh3_dlc21_ie_camp_kho_skarbrand_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh2_dlc17_bst_malagor = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 438.66684, y = 279.60199,	d = 22.431458, b = 0.0,	h = 64.711349,},
		cam_gameplay_start = {x = 438.66684, y = 278.236084,	d = 6.849304, b = 0, h = 7.866285,},
		advice_line = "wh3_dlc21_ie_camp_bst_malagor_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},


	--------------------
	-------LUSTRIA------
	--------------------
	wh2_main_lzd_itza = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 102.054115, y = 183.303284,	d = 27.950439, b = 0.0,	h = 62.634327,},
		cam_gameplay_start = {x = 102.607315, y = 187.388443,	d = 9.983963, b = 0, h = 7.721539,},
		advice_line = "wh3_dlc21_ie_camp_lzd_gorok_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh_main_brt_bordeleaux = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 139.644348, y = 258.975647,	d = 29.460403, b = 0.0,	h = 65.481071,},
		cam_gameplay_start = {x = 141.985397, y = 250.289948,	d = 5.752747, b = 0, h = 4.323912,},
		advice_line = "wh3_dlc21_ie_camp_brt_alberic_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh2_dlc13_emp_the_huntmarshals_expedition = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 84.329788, y = 289.764618,	d = 28.659973, b = 0.0,	h = 68.371284,},
		cam_gameplay_start = {x = 85.913696, y = 278.533844,	d = 5.582733, b = 0, h = 4.220685,},
		advice_line = "wh3_dlc21_ie_camp_emp_wulfhart_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh2_dlc11_cst_vampire_coast = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 190.175247, y = 213.756622,	d = 29.82515, b = 0.0,	h = 63.979568,},
		cam_gameplay_start = {x = 190.975647, y = 208.980286,	d = 7.330948, b = 0, h = 5.480612,},
		advice_line = "wh3_dlc21_ie_camp_cst_harkon_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh2_twa03_def_rakarth = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 25.793474, y = 213.400711, d = 29.760147, b = 0.0,	h = 64.082985,},
		cam_gameplay_start = {x = 24.763008, y = 206.435257, d = 11.60318, b = 0, h = 9.049785,},
		advice_line = "wh3_dlc21_ie_camp_def_rakarth_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh2_dlc12_lzd_cult_of_sotek = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 142.469177, y = 93.129486,  d = 29.676231, b = 0.0,	h = 64.164238,},
		cam_gameplay_start = {x = 142.075485, y = 88.355629, d = 9.508026, b = 0, h = 7.238492,},
		advice_line = "wh3_dlc21_ie_camp_lzd_tehenhauin_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh2_main_skv_clan_pestilens = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 124.94455, y = 133.398178,	d = 28.640884, b = 0.0,	h = 62.461643,},
		cam_gameplay_start = {x = 125.670151, y = 130.636841,	d = 11.932541, b = 0, h = 9.387771,},
		advice_line = "wh3_dlc21_ie_camp_skv_skrolk_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},


	--------------------
	-------KHEMRI-------
	--------------------
	wh2_dlc09_tmb_khemri = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 422.768188, y = 234.568436,	d = 29.147995, b = 0.0,	h = 62.812737,},
		cam_gameplay_start = {x = 419.862549, y = 226.254272,	d = 8.765854, b = 0, h = 6.639018,},
		advice_line = "wh3_dlc21_ie_camp_tmb_settra_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh2_dlc09_tmb_followers_of_nagash = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 298.286987, y = 241.790985,	d = 29.696548, b = 0.0,	h = 63.792007,},
		cam_gameplay_start = {x = 301.315826, y = 232.769196,	d = 5.47316, b = 0, h = 4.156006,},
		advice_line = "wh3_dlc21_ie_camp_tmb_arkhan_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh_main_vmp_vampire_counts = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 418.364288, y = 188.468384,	d = 27.860077, b = 0.0,	h = 63.547024,},
		cam_gameplay_start = {x = 415.192017, y = 190.223404,	d = 9.022354, b = 0, h = 6.856233,},
		advice_line = "wh3_dlc21_ie_camp_vmp_mannfred_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh2_dlc14_brt_chevaliers_de_lyonesse = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 324.493317, y = 269.866547,	d = 28.020233, b = 0.0,	h = 63.76722,},
		cam_gameplay_start = {x = 326.47171, y = 259.662262,	d = 8.091064, b = 0, h = 6.100232,},
		advice_line = "wh3_dlc21_ie_camp_brt_repanse_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh3_main_emp_cult_of_sigmar = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 376.260376, y = 197.685577,	d = 22.515228, b = 0.0,	h = 67.663887,},
		cam_gameplay_start = {x = 376.260376, y = 186.33992,	d = 6.600632, b = 0, h = 7.506077,},
		advice_line = "wh3_dlc21_ie_camp_emp_volkmar_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},


	--------------------
	---MANGROVE COAST---
	--------------------
	wh2_dlc09_tmb_lybaras = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 538.749146, y = 246.543991,	d = 29.10675, b = 0.0,	h = 64.37059,},
		cam_gameplay_start = {x = 537.702332, y = 234.181244,	d = 7.194778, b = 0, h = 5.442069,},
		advice_line = "wh3_dlc21_ie_camp_tmb_khalida_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh2_main_lzd_last_defenders = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 485.819763, y = 149.48143, d = 28.866051, b = 0.0,	h = 66.726608,},
		cam_gameplay_start = {x = 484.256195, y = 145.180817, d = 8.132431, b = 0, h = 6.167998,},
		advice_line = "wh3_dlc21_ie_camp_lzd_kroqgar_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh2_dlc17_dwf_thorek_ironbrow = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 461.663818, y = 175.973541, d = 20.993698, b = 0.0,	h = 60.301125,},
		cam_gameplay_start = {x = 461.663818, y = 173.86554, d = 5.612106, b = 0, h = 6.887808,},
		advice_line = "wh3_dlc21_ie_camp_dwf_thorek_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},


	--------------------
	-----SOUTHLANDS-----
	--------------------
	wh2_main_hef_order_of_loremasters = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 394.142914, y = 67.169632,	d = 29.414574, b = 0.0,	h = 67.004333,},
		cam_gameplay_start = {x = 393.39859, y = 55.529987,	d = 9.271904, b = 0, h = 6.993069,},
		advice_line = "wh3_dlc21_ie_camp_hef_teclis_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh3_main_tze_oracles_of_tzeentch = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 378.39859, y = 20.529987,	d = 22.414574, b = 0.0,	h = 67.004333,},
		cam_gameplay_start = {x = 378.39859, y = 20.529987,	d = 11.573801, b = 0, h = 6.993069,},
		advice_line = "wh3_dlc21_ie_camp_tze_kairos_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh2_main_lzd_tlaqua = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 344.542603, y = 165.958466,	d = 29.522827, b = 0.0,	h = 67.411301,},
		cam_gameplay_start = {x = 345.023987, y = 162.555237,	d = 8.344208, b = 0, h = 6.299114,},
		advice_line = "wh3_dlc21_ie_camp_lzd_tiktaqto_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},


	--------------------
	--SOUTHERN WASTES---
	--------------------
	wh2_dlc17_lzd_oxyotl = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 177.224121, y = 30.095407,	d = 21.674421, b = 0.0,	h = 62.365181,},
		cam_gameplay_start = {x = 176.263412, y = 21.594929,	d = 6.755452, b = 0, h = 7.944565,},
		advice_line = "wh3_dlc21_ie_camp_lzd_oxyotl_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},


	--------------------
	----DWARF HOLDS-----
	--------------------
	wh_main_dwf_dwarfs = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 502.730377, y = 415.443634,	d = 19.965881, b = 0.0,	h = 59.838516,},
		cam_gameplay_start = {x = 506.858673, y = 417.999573,	d = 8.944824, b = 0, h = 11.124744,},
		advice_line = "wh3_dlc21_ie_camp_dwf_thorgrim_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh_main_dwf_karak_kadrin = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 521.0448, y = 488.163696, d = 19.702667, b = 0.0,	h = 59.075737,},
		cam_gameplay_start = {x = 520.123108, y = 488.549469,	d = 5.366455, b = 0, h = 6.525187,},
		advice_line = "wh3_dlc21_ie_camp_dwf_ungrim_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh2_main_skv_clan_mors = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 507.283722, y = 310.390472,	d = 26.165802, b = 0.0,	h = 59.142414,},
		cam_gameplay_start = {x = 507.283722, y = 294.667297,	d = 7.441467, b = 0, h = 9.040249,},
		advice_line = "wh3_dlc21_ie_camp_skv_queek_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh_main_grn_crooked_moon = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 536.96936, y = 429.885162, d = 19.475952, b = 0.0, h = 57.516453,},
		cam_gameplay_start = {x = 536.3703, y = 431.673462,	d = 6.451813, b = 0, h = 7.808351,},
		advice_line = "wh3_dlc21_ie_camp_grn_skarsnik_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},


	--------------------
	-----DARK LANDS-----
	--------------------
	wh2_dlc15_hef_imrik = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 573.586609, y = 318.349304,	d = 22.438477, b = 0.0,	h = 64.89315,},
		cam_gameplay_start = {x = 573.586609, y = 330.326599,	d = 7.173035, b = 0, h = 8.244475,},
		advice_line = "wh3_dlc21_ie_camp_hef_imrik_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh2_dlc09_skv_clan_rictus = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 556.286682, y = 403.177338,	d = 21.683289, b = 0,	h = 62.642727,},
		cam_gameplay_start = {x = 556.286682, y = 408.42395,	d = 10.237366, b = 0,	h = 12.305203,},
		advice_line = "wh3_dlc21_ie_camp_skv_tretch_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh3_main_nur_poxmakers_of_nurgle = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 668.102417, y = 280.396606,	d = 22.669464, b = 0.0,	h = 64.90081,},
		cam_gameplay_start = {x = 668.102417, y = 288.452148,	d = 9.320435, b = 0, h = 10.921711,},
		advice_line = "wh3_dlc21_ie_camp_nur_kugath_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh3_dlc23_chd_legion_of_azgorh = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 633.726074, y = 370.075836,	d = 22.588837, b = 0, h = 65.854897,},
		cam_gameplay_start = {x = 631.343689, y = 378.437561,	d = 9.927307, b = 0, h = 11.699169,},
		advice_line = "wh3_dlc23_ie_camp_chd_drazhoath_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh3_dlc23_chd_astragoth = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 575.663635, y = 553.59668,	d = 22.207275, b = 0.0,	h = 63.392048,},
		cam_gameplay_start = {x = 570.808533, y = 544.421692,	d = 10.354736, b = 0, h = 12.399276,},
		advice_line = "wh3_dlc23_ie_camp_chd_astragoth_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	--------------------
	---MOURN MOUNTAINS--
	--------------------
	wh3_main_ogr_goldtooth = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 695.019775, y = 394.347137,	d = 21.301208, b = 0.0,	h = 60.872715,},
		cam_gameplay_start = {x = 695.019775, y = 386.524506,	d = 4.307526, b = 0, h = 5.278111,},
		advice_line = "wh3_dlc21_ie_camp_ogr_greasus_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh_main_grn_greenskins = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 652.135742, y = 517.871216,	d = 21.604187, b = 0.0,	h = 61.502235,},
		cam_gameplay_start = {x = 650.005737, y = 519.96936,	d = 7.357117, b = 0, h = 9.003818,},
		advice_line = "wh3_dlc21_ie_camp_grn_grimgor_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh3_main_vmp_caravan_of_blue_roses = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 704.543762, y = 342.065613,	d = 22.695648, b = 0.0,	h = 64.956429,},
		cam_gameplay_start = {x = 704.543762, y = 342.065613,	d = 9.299866, b = 0, h = 10.896576,},
		advice_line = "wh3_dlc21_ie_camp_vmp_ghorst_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},
	
	wh3_dlc23_chd_zhatan = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 767.19342, y = 540.643677,	d = 22.669464, b = 0.0,	h = 64.90081,},
		cam_gameplay_start = {x = 767.19342, y = 540.643677,	d = 9.320435, b = 0, h = 10.921711,},
		advice_line = "wh3_dlc23_ie_camp_chd_zhatan_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},


	--------------------
	--NORTHERN CATHAY---
	--------------------
	wh3_main_cth_the_northern_provinces = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 761.141541, y = 493.039307,	d = 22.17981, b = 0.0,	h = 65.836021,},
		cam_gameplay_start = {x = 761.141541, y = 493.68573,	d = 9.219788, b = 0, h = 10.925922,},
		advice_line = "wh3_dlc21_ie_camp_cth_miao_ying_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh3_dlc20_chs_vilitch = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 891.811401, y = 515.81958,	d = 22.906464, b = 0.0,	h = 65.142982,},
		cam_gameplay_start = {x = 891.811401, y = 514.125793,	d = 9.34314, b = 0, h = 10.925215,},
		advice_line = "wh3_dlc21_ie_camp_woc_vilitch_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh2_main_skv_clan_eshin = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 826.896118, y = 427.611542,	d = 22.392303, b = 0.0,	h = 67.477608,},
		cam_gameplay_start = {x = 826.896118, y = 423.044128,	d = 8.713928, b = 0, h = 10.142816,},
		advice_line = "wh3_dlc21_ie_camp_skv_snikch_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh2_dlc11_def_the_blessed_dread = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 896.872742, y = 461.99585,	d = 21.002869, b = 0.0,	h = 61.002804,},
		cam_gameplay_start = {x = 896.872742, y = 458.441681,	d = 7.772278, b = 0, h = 8.9452,},
		advice_line = "wh3_dlc21_ie_camp_def_lokhir_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},


	--------------------
	--SOUTHERN CATHAY---
	--------------------
	wh3_main_cth_the_western_provinces = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 738.351685, y = 383.537323,	d = 21.33252, b = 0.0,	h = 64.150696,},
		cam_gameplay_start = {x = 738.351685, y = 379.588745,	d = 7.776306, b = 0, h = 9.045765,},
		advice_line = "wh3_dlc21_ie_camp_cth_zhao_ming_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},

	wh2_dlc13_lzd_spirits_of_the_jungle = faction_intro_data:new{
		preset = data.intro_presets.standard,
		cam_cutscene_start = {x = 881.691956, y = 283.149445,	d = 20.938446, b = 0.0,	h = 59.247318,},
		cam_gameplay_start = {x = 886.934021, y = 282.235626,	d = 8.666168, b = 0, h = 10.348305,},
		advice_line = "wh3_dlc21_ie_camp_lzd_nakai_intro_01",
		cutscene_style = data.cutscene_styles.zoom_in_and_speak
	},
}

return data