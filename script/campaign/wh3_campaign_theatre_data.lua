local theatre_names = {
	"naggaroth",
	"norsca",
	"ulthuan",
	"bretonnia",
	"empire",
	"badlands",
	"darklands",
	"cathay",
	"lustria",
	"w_southlands",
	"e_southlands"
}

THEATRE_DATA = {
	names = {
		theatre_names[1],
		theatre_names[2],
		theatre_names[3],
		theatre_names[4],
		theatre_names[5],
		theatre_names[6],
		theatre_names[7],
		theatre_names[8],
		theatre_names[9],
		theatre_names[10],
		theatre_names[11]
	},
	attitude_effect_bundle_keys = {
		[theatre_names[1]] = "",
		[theatre_names[2]] = "",
		[theatre_names[3]] = "wh3_main_ie_ulthuan_attitude_shifts",
		[theatre_names[4]] = "",
		[theatre_names[5]] = "",
		[theatre_names[6]] = "",
		[theatre_names[7]] = "",
		[theatre_names[8]] = "",
		[theatre_names[9]] = "",
		[theatre_names[10]] = "",
		[theatre_names[11]] = ""
	},
	faction_keys = {
		-- the table keys for each faction name should match up with the end of the attitude effect keys. for example ["tyrion"] and wh3_main_ie_faction_political_diplomacy_mod_tyrion
		[theatre_names[1]] = {
	
		},
		[theatre_names[2]] = {
			
		},
		[theatre_names[3]] = {
			["tyrion"] = "wh2_main_hef_eataine",
			["alarielle"] = "wh2_main_hef_avelorn",
			["morathi"] = "wh2_main_def_cult_of_pleasure",
			["wulfrik"] = "wh_dlc08_nor_norsca",
			["noctilus"] = "wh2_dlc11_cst_noctilus",
			["grom"] = "wh2_dlc15_grn_broken_axe",
			["nkari"] = "wh3_main_sla_seducers_of_slaanesh"
		},
		[theatre_names[4]] = {
			
		},
		[theatre_names[5]] = {
			
		},
		[theatre_names[6]] = {
			
		},
		[theatre_names[7]] = {
			
		},
		[theatre_names[8]] = {
			
		},
		[theatre_names[9]] = {
			
		},
		[theatre_names[10]] = {
			
		},
		[theatre_names[11]] = {
			
		}
	},
	region_keys = {
		[theatre_names[1]] = {
	
		},
		[theatre_names[2]] = {
			
		},
		[theatre_names[3]] = {
			"wh3_main_combi_region_hag_hall",
			"wh3_main_combi_region_vauls_anvil_3",
			"wh3_main_combi_region_temple_of_addaioth",

			"wh3_main_combi_region_ice_rock_gorge",
			"wh3_main_combi_region_plain_of_dogs",
			
			"wh3_main_combi_region_the_witchwood",

			"wh3_main_combi_region_grey_rock_point",
			"wh3_main_combi_region_ancient_city_of_quintex",
			"wh3_main_combi_region_ironspike",
			"wh3_main_combi_region_ssildra_tor",

			"wh3_main_combi_region_the_moon_shard",
			"wh3_main_combi_region_arnheim",
			"wh3_main_combi_region_bleak_hold_fortress",
			"wh3_main_combi_region_forest_of_arnheim",

			"wh3_main_combi_region_tyrant_peak",
			"wh3_main_combi_region_scarpels_lair",
			"wh3_main_combi_region_sulpharets",

			"wh3_main_combi_region_the_galleons_graveyard",

			"wh3_main_combi_region_vauls_anvil_2",
			"wh3_main_combi_region_tor_sethai",
			
			"wh3_main_combi_region_lothern",
			"wh3_main_combi_region_angerrial",
			"wh3_main_combi_region_tower_of_lysean",
			"wh3_main_combi_region_shrine_of_asuryan",

			"wh3_main_combi_region_tor_anroc",
			"wh3_main_combi_region_whitepeak",
			"wh3_main_combi_region_avethir",

			"wh3_main_combi_region_tor_anlec",
			"wh3_main_combi_region_tor_dranil",
			"wh3_main_combi_region_shrine_of_khaine",

			"wh3_main_combi_region_shrine_of_kurnous",
			"wh3_main_combi_region_tor_achare",
			"wh3_main_combi_region_elisia",

			"wh3_main_combi_region_tor_koruali",
			"wh3_main_combi_region_mistnar",

			"wh3_main_combi_region_tor_yvresse",
			"wh3_main_combi_region_tralinia",

			"wh3_main_combi_region_elessaeli",
			"wh3_main_combi_region_shrine_of_loec",
			"wh3_main_combi_region_cairn_thel",

			"wh3_main_combi_region_eagle_gate",

			"wh3_main_combi_region_griffon_gate",

			"wh3_main_combi_region_unicorn_gate",

			"wh3_main_combi_region_phoenix_gate",

			"wh3_main_combi_region_tor_elyr",
			"wh3_main_combi_region_whitefire_tor",

			"wh3_main_combi_region_gaean_vale",
			"wh3_main_combi_region_evershale",
			"wh3_main_combi_region_tor_saroir",

			"wh3_main_combi_region_white_tower_of_hoeth",
			"wh3_main_combi_region_port_elistor",
			"wh3_main_combi_region_tor_finu"
		},
		[theatre_names[4]] = {
			
		},
		[theatre_names[5]] = {
			
		},
		[theatre_names[6]] = {
			
		},
		[theatre_names[7]] = {
			
		},
		[theatre_names[8]] = {
			
		},
		[theatre_names[9]] = {
			
		},
		[theatre_names[10]] = {
			
		},
		[theatre_names[11]] = {
			
		}
	},
	pooled_resource_keys = {
		-- the pooled resource keys for each theatre's control levels
		[theatre_names[1]] = "",
		[theatre_names[2]] = "",
		[theatre_names[3]] = "wh3_main_ie_ulthuan_control",
		[theatre_names[4]] = "",
		[theatre_names[5]] = "",
		[theatre_names[6]] = "",
		[theatre_names[7]] = "",
		[theatre_names[8]] = "",
		[theatre_names[9]] = "",
		[theatre_names[10]] = "",
		[theatre_names[11]] = ""
	},
	bracket_ranges = {
		{min = 1, max = 29},
		{min = 30, max = 54},
		{min = 55, max = 74},
		{min = 75, max = 89},
		{min = 90, max = 100}
	},
	attitude_shift_values = {
		increase = {
			{small = 3, large = 5},
			{small = 7, large = 10},
			{small = 10, large = 15},
			{small = 15, large = 30},
			{small = 25, large = 50}
		},
		decrease = {
			{small = -3, large = -5},
			{small = -7, large = -10},
			{small = -10, large = -15},
			{small = -15, large = -30},
			{small = -25, large = -50}
		}
	},
	attitudes = {
		-- The keys of this table are faction culture keys (found in the cultures table) or faction keys (found in the factions table), 
		-- the script will first search for a faction key to see if it exists, if it exists that means that faction is an exemption to its cultures usual relations, 
		-- if it doesnt exist it defaults back to the culture.
		["wh_main_brt_bretonnia"] = {
			[theatre_names[1]] = {
	
			},
			[theatre_names[2]] = {
				
			},
			[theatre_names[3]] = {
				["tyrion"] = {"increase", "small"},
				["alarielle"] = {"increase", "small"},
				["morathi"] = {"decrease", "large"},
				["wulfrik"] = {"decrease", "large"},
				["noctilus"] = {"decrease", "large"},
				["grom"] = {"decrease", "large"},
				["nkari"] = {"decrease", "large"}
			},
			[theatre_names[4]] = {
				
			},
			[theatre_names[5]] = {
				
			},
			[theatre_names[6]] = {
				
			},
			[theatre_names[7]] = {
				
			},
			[theatre_names[8]] = {
				
			},
			[theatre_names[9]] = {
				
			},
			[theatre_names[10]] = {
				
			},
			[theatre_names[11]] = {
				
			}
		},
		["wh3_main_cth_cathay"] = {
			[theatre_names[1]] = {
	
			},
			[theatre_names[2]] = {
				
			},
			[theatre_names[3]] = {
				["tyrion"] = {"increase", "small"},
				["alarielle"] = {"increase", "small"},
				["morathi"] = {"decrease", "small"},
				["wulfrik"] = {"decrease", "large"},
				["noctilus"] = {"decrease", "large"},
				["grom"] = {"decrease", "large"},
				["nkari"] = {"decrease", "large"}
			},
			[theatre_names[4]] = {
				
			},
			[theatre_names[5]] = {
				
			},
			[theatre_names[6]] = {
				
			},
			[theatre_names[7]] = {
				
			},
			[theatre_names[8]] = {
				
			},
			[theatre_names[9]] = {
				
			},
			[theatre_names[10]] = {
				
			},
			[theatre_names[11]] = {
				
			}
		},
		["wh_main_dwf_dwarfs"] = {
			[theatre_names[1]] = {
	
			},
			[theatre_names[2]] = {
				
			},
			[theatre_names[3]] = {
				["tyrion"] = {"decrease", "small"},
				["alarielle"] = {"decrease", "small"},
				["morathi"] = {"decrease", "large"},
				["wulfrik"] = {"decrease", "large"},
				["noctilus"] = {"decrease", "large"},
				["grom"] = {"decrease", "large"},
				["nkari"] = {"decrease", "large"}
			},
			[theatre_names[4]] = {
				
			},
			[theatre_names[5]] = {
				
			},
			[theatre_names[6]] = {
				
			},
			[theatre_names[7]] = {
				
			},
			[theatre_names[8]] = {
				
			},
			[theatre_names[9]] = {
				
			},
			[theatre_names[10]] = {
				
			},
			[theatre_names[11]] = {
				
			}
		},
		["wh_main_emp_empire"] = {
			[theatre_names[1]] = {
	
			},
			[theatre_names[2]] = {
				
			},
			[theatre_names[3]] = {
				["tyrion"] = {"increase", "small"},
				["alarielle"] = {"increase", "small"},
				["morathi"] = {"decrease", "large"},
				["wulfrik"] = {"decrease", "large"},
				["noctilus"] = {"decrease", "large"},
				["grom"] = {"decrease", "small"},
				["nkari"] = {"decrease", "large"}
			},
			[theatre_names[4]] = {
				
			},
			[theatre_names[5]] = {
				
			},
			[theatre_names[6]] = {
				
			},
			[theatre_names[7]] = {
				
			},
			[theatre_names[8]] = {
				
			},
			[theatre_names[9]] = {
				
			},
			[theatre_names[10]] = {
				
			},
			[theatre_names[11]] = {
				
			}
		},
		["wh2_main_hef_high_elves"] = {
			[theatre_names[1]] = {
	
			},
			[theatre_names[2]] = {
				
			},
			[theatre_names[3]] = {
				["tyrion"] = {"increase", "large"},
				["alarielle"] = {"increase", "large"},
				["morathi"] = {"decrease", "large"},
				["wulfrik"] = {"decrease", "large"},
				["noctilus"] = {"decrease", "large"},
				["grom"] = {"decrease", "large"},
				["nkari"] = {"decrease", "large"}
			},
			[theatre_names[4]] = {
				
			},
			[theatre_names[5]] = {
				
			},
			[theatre_names[6]] = {
				
			},
			[theatre_names[7]] = {
				
			},
			[theatre_names[8]] = {
				
			},
			[theatre_names[9]] = {
				
			},
			[theatre_names[10]] = {
				
			},
			[theatre_names[11]] = {
				
			}
		},
		["wh3_main_ksl_kislev"] = {
			[theatre_names[1]] = {
	
			},
			[theatre_names[2]] = {
				
			},
			[theatre_names[3]] = {
				["tyrion"] = {"increase", "small"},
				["alarielle"] = {"increase", "small"},
				["morathi"] = {"decrease", "large"},
				["wulfrik"] = {"decrease", "large"},
				["noctilus"] = {"decrease", "large"},
				["grom"] = {"decrease", "small"},
				["nkari"] = {"decrease", "large"}
			},
			[theatre_names[4]] = {
				
			},
			[theatre_names[5]] = {
				
			},
			[theatre_names[6]] = {
				
			},
			[theatre_names[7]] = {
				
			},
			[theatre_names[8]] = {
				
			},
			[theatre_names[9]] = {
				
			},
			[theatre_names[10]] = {
				
			},
			[theatre_names[11]] = {
				
			}
		},
		["wh2_main_lzd_lizardmen"] = {
			[theatre_names[1]] = {
	
			},
			[theatre_names[2]] = {
				
			},
			[theatre_names[3]] = {
				["tyrion"] = false,
				["alarielle"] = false,
				["morathi"] = {"decrease", "large"},
				["wulfrik"] = {"decrease", "large"},
				["noctilus"] = {"decrease", "large"},
				["grom"] = {"decrease", "small"},
				["nkari"] = {"decrease", "large"}
			},
			[theatre_names[4]] = {
				
			},
			[theatre_names[5]] = {
				
			},
			[theatre_names[6]] = {
				
			},
			[theatre_names[7]] = {
				
			},
			[theatre_names[8]] = {
				
			},
			[theatre_names[9]] = {
				
			},
			[theatre_names[10]] = {
				
			},
			[theatre_names[11]] = {
				
			}
		},
		["wh_dlc05_wef_wood_elves"] = {
			[theatre_names[1]] = {
	
			},
			[theatre_names[2]] = {
				
			},
			[theatre_names[3]] = {
				["tyrion"] = false,
				["alarielle"] = false,
				["morathi"] = {"decrease", "large"},
				["wulfrik"] = {"decrease", "large"},
				["noctilus"] = {"decrease", "large"},
				["grom"] = {"decrease", "large"},
				["nkari"] = {"decrease", "large"}
			},
			[theatre_names[4]] = {
				
			},
			[theatre_names[5]] = {
				
			},
			[theatre_names[6]] = {
				
			},
			[theatre_names[7]] = {
				
			},
			[theatre_names[8]] = {
				
			},
			[theatre_names[9]] = {
				
			},
			[theatre_names[10]] = {
				
			},
			[theatre_names[11]] = {
				
			}
		},
		["wh_dlc03_bst_beastmen"] = {
			[theatre_names[1]] = {
	
			},
			[theatre_names[2]] = {
				
			},
			[theatre_names[3]] = {
				["tyrion"] = {"decrease", "large"},
				["alarielle"] = {"decrease", "large"},
				["morathi"] = {"decrease", "small"},
				["wulfrik"] = {"decrease", "small"},
				["noctilus"] = {"decrease", "large"},
				["grom"] = {"decrease", "small"},
				["nkari"] = {"increase", "small"}
			},
			[theatre_names[4]] = {
				
			},
			[theatre_names[5]] = {
				
			},
			[theatre_names[6]] = {
				
			},
			[theatre_names[7]] = {
				
			},
			[theatre_names[8]] = {
				
			},
			[theatre_names[9]] = {
				
			},
			[theatre_names[10]] = {
				
			},
			[theatre_names[11]] = {
				
			}
		},
		["wh3_main_dae_daemons"] = {
			[theatre_names[1]] = {
	
			},
			[theatre_names[2]] = {
				
			},
			[theatre_names[3]] = {
				["tyrion"] = {"decrease", "large"},
				["alarielle"] = {"decrease", "large"},
				["morathi"] = {"increase", "small"},
				["wulfrik"] = {"increase", "small"},
				["noctilus"] = {"decrease", "large"},
				["grom"] = {"decrease", "large"},
				["nkari"] = {"increase", "small"}
			},
			[theatre_names[4]] = {
				
			},
			[theatre_names[5]] = {
				
			},
			[theatre_names[6]] = {
				
			},
			[theatre_names[7]] = {
				
			},
			[theatre_names[8]] = {
				
			},
			[theatre_names[9]] = {
				
			},
			[theatre_names[10]] = {
				
			},
			[theatre_names[11]] = {
				
			}
		},
		["wh3_main_kho_khorne"] = {
			[theatre_names[1]] = {
	
			},
			[theatre_names[2]] = {
				
			},
			[theatre_names[3]] = {
				["tyrion"] = {"decrease", "large"},
				["alarielle"] = {"decrease", "large"},
				["morathi"] = {"decrease", "large"},
				["wulfrik"] = {"increase", "small"},
				["noctilus"] = {"decrease", "large"},
				["grom"] = {"decrease", "large"},
				["nkari"] = {"decrease", "large"}
			},
			[theatre_names[4]] = {
				
			},
			[theatre_names[5]] = {
				
			},
			[theatre_names[6]] = {
				
			},
			[theatre_names[7]] = {
				
			},
			[theatre_names[8]] = {
				
			},
			[theatre_names[9]] = {
				
			},
			[theatre_names[10]] = {
				
			},
			[theatre_names[11]] = {
				
			}
		},
		["wh_dlc08_nor_norsca"] = {
			[theatre_names[1]] = {
	
			},
			[theatre_names[2]] = {
				
			},
			[theatre_names[3]] = {
				["tyrion"] = {"decrease", "large"},
				["alarielle"] = {"decrease", "large"},
				["morathi"] = {"increase", "small"},
				["wulfrik"] = {"increase", "large"},
				["noctilus"] = {"decrease", "large"},
				["grom"] = {"decrease", "small"},
				["nkari"] = {"increase", "small"}
			},
			[theatre_names[4]] = {
				
			},
			[theatre_names[5]] = {
				
			},
			[theatre_names[6]] = {
				
			},
			[theatre_names[7]] = {
				
			},
			[theatre_names[8]] = {
				
			},
			[theatre_names[9]] = {
				
			},
			[theatre_names[10]] = {
				
			},
			[theatre_names[11]] = {
				
			}
		},
		["wh3_main_nur_nurgle"] = {
			[theatre_names[1]] = {
	
			},
			[theatre_names[2]] = {
				
			},
			[theatre_names[3]] = {
				["tyrion"] = {"decrease", "large"},
				["alarielle"] = {"decrease", "large"},
				["morathi"] = false,
				["wulfrik"] = {"increase", "small"},
				["noctilus"] = {"decrease", "large"},
				["grom"] = {"decrease", "small"},
				["nkari"] = false
			},
			[theatre_names[4]] = {
				
			},
			[theatre_names[5]] = {
				
			},
			[theatre_names[6]] = {
				
			},
			[theatre_names[7]] = {
				
			},
			[theatre_names[8]] = {
				
			},
			[theatre_names[9]] = {
				
			},
			[theatre_names[10]] = {
				
			},
			[theatre_names[11]] = {
				
			}
		},
		["wh3_main_sla_slaanesh"] = {
			[theatre_names[1]] = {
	
			},
			[theatre_names[2]] = {
				
			},
			[theatre_names[3]] = {
				["tyrion"] = {"decrease", "large"},
				["alarielle"] = {"decrease", "large"},
				["morathi"] = {"increase", "large"},
				["wulfrik"] = {"increase", "small"},
				["noctilus"] = {"decrease", "large"},
				["grom"] = {"decrease", "small"},
				["nkari"] = {"increase", "large"}
			},
			[theatre_names[4]] = {
				
			},
			[theatre_names[5]] = {
				
			},
			[theatre_names[6]] = {
				
			},
			[theatre_names[7]] = {
				
			},
			[theatre_names[8]] = {
				
			},
			[theatre_names[9]] = {
				
			},
			[theatre_names[10]] = {
				
			},
			[theatre_names[11]] = {
				
			}
		},
		["wh3_main_tze_tzeentch"] = {
			[theatre_names[1]] = {
	
			},
			[theatre_names[2]] = {
				
			},
			[theatre_names[3]] = {
				["tyrion"] = {"decrease", "large"},
				["alarielle"] = {"decrease", "large"},
				["morathi"] = false,
				["wulfrik"] = {"increase", "small"},
				["noctilus"] = {"decrease", "small"},
				["grom"] = {"decrease", "small"},
				["nkari"] = false
			},
			[theatre_names[4]] = {
				
			},
			[theatre_names[5]] = {
				
			},
			[theatre_names[6]] = {
				
			},
			[theatre_names[7]] = {
				
			},
			[theatre_names[8]] = {
				
			},
			[theatre_names[9]] = {
				
			},
			[theatre_names[10]] = {
				
			},
			[theatre_names[11]] = {
				
			}
		},
		["wh_main_chs_chaos"] = {
			[theatre_names[1]] = {
	
			},
			[theatre_names[2]] = {
				
			},
			[theatre_names[3]] = {
				["tyrion"] = {"decrease", "large"},
				["alarielle"] = {"decrease", "large"},
				["morathi"] = {"increase", "small"},
				["wulfrik"] = {"increase", "large"},
				["noctilus"] = {"decrease", "large"},
				["grom"] = {"decrease", "small"},
				["nkari"] = {"increase", "small"}
			},
			[theatre_names[4]] = {
				
			},
			[theatre_names[5]] = {
				
			},
			[theatre_names[6]] = {
				
			},
			[theatre_names[7]] = {
				
			},
			[theatre_names[8]] = {
				
			},
			[theatre_names[9]] = {
				
			},
			[theatre_names[10]] = {
				
			},
			[theatre_names[11]] = {
				
			}
		},
		["wh2_main_def_dark_elves"] = {
			[theatre_names[1]] = {
	
			},
			[theatre_names[2]] = {
				
			},
			[theatre_names[3]] = {
				["tyrion"] = {"decrease", "large"},
				["alarielle"] = {"decrease", "large"},
				["morathi"] = {"increase", "small"},
				["wulfrik"] = {"decrease", "small"},
				["noctilus"] = {"decrease", "large"},
				["grom"] = {"decrease", "large"},
				["nkari"] = {"decrease", "large"}
			},
			[theatre_names[4]] = {
				
			},
			[theatre_names[5]] = {
				
			},
			[theatre_names[6]] = {
				
			},
			[theatre_names[7]] = {
				
			},
			[theatre_names[8]] = {
				
			},
			[theatre_names[9]] = {
				
			},
			[theatre_names[10]] = {
				
			},
			[theatre_names[11]] = {
				
			}
		},
		["wh2_main_skv_skaven"] = {
			[theatre_names[1]] = {
	
			},
			[theatre_names[2]] = {
				
			},
			[theatre_names[3]] = {
				["tyrion"] = {"decrease", "large"},
				["alarielle"] = {"decrease", "large"},
				["morathi"] = {"decrease", "small"},
				["wulfrik"] = false,
				["noctilus"] = {"decrease", "large"},
				["grom"] = {"decrease", "large"},
				["nkari"] = false
			},
			[theatre_names[4]] = {
				
			},
			[theatre_names[5]] = {
				
			},
			[theatre_names[6]] = {
				
			},
			[theatre_names[7]] = {
				
			},
			[theatre_names[8]] = {
				
			},
			[theatre_names[9]] = {
				
			},
			[theatre_names[10]] = {
				
			},
			[theatre_names[11]] = {
				
			}
		},
		["wh_main_grn_greenskins"] = {
			[theatre_names[1]] = {
	
			},
			[theatre_names[2]] = {
				
			},
			[theatre_names[3]] = {
				["tyrion"] = {"decrease", "large"},
				["alarielle"] = {"decrease", "large"},
				["morathi"] = {"decrease", "large"},
				["wulfrik"] = {"decrease", "small"},
				["noctilus"] = {"decrease", "small"},
				["grom"] = {"increase", "large"},
				["nkari"] = {"decrease", "small"}
			},
			[theatre_names[4]] = {
				
			},
			[theatre_names[5]] = {
				
			},
			[theatre_names[6]] = {
				
			},
			[theatre_names[7]] = {
				
			},
			[theatre_names[8]] = {
				
			},
			[theatre_names[9]] = {
				
			},
			[theatre_names[10]] = {
				
			},
			[theatre_names[11]] = {
				
			}
		},
		["wh2_dlc11_cst_vampire_coast"] = {
			[theatre_names[1]] = {
	
			},
			[theatre_names[2]] = {
				
			},
			[theatre_names[3]] = {
				["tyrion"] = {"decrease", "large"},
				["alarielle"] = {"decrease", "large"},
				["morathi"] = {"decrease", "large"},
				["wulfrik"] = {"decrease", "large"},
				["noctilus"] = {"increase", "large"},
				["grom"] = {"decrease", "small"},
				["nkari"] = {"decrease", "large"}
			},
			[theatre_names[4]] = {
				
			},
			[theatre_names[5]] = {
				
			},
			[theatre_names[6]] = {
				
			},
			[theatre_names[7]] = {
				
			},
			[theatre_names[8]] = {
				
			},
			[theatre_names[9]] = {
				
			},
			[theatre_names[10]] = {
				
			},
			[theatre_names[11]] = {
				
			}
		},
		["wh_main_vmp_vampire_counts"] = {
			[theatre_names[1]] = {
	
			},
			[theatre_names[2]] = {
				
			},
			[theatre_names[3]] = {
				["tyrion"] = {"decrease", "large"},
				["alarielle"] = {"decrease", "large"},
				["morathi"] = {"decrease", "large"},
				["wulfrik"] = {"decrease", "large"},
				["noctilus"] = {"increase", "large"},
				["grom"] = {"decrease", "small"},
				["nkari"] = {"decrease", "large"}
			},
			[theatre_names[4]] = {
				
			},
			[theatre_names[5]] = {
				
			},
			[theatre_names[6]] = {
				
			},
			[theatre_names[7]] = {
				
			},
			[theatre_names[8]] = {
				
			},
			[theatre_names[9]] = {
				
			},
			[theatre_names[10]] = {
				
			},
			[theatre_names[11]] = {
				
			}
		},
		["wh2_dlc09_tmb_tomb_kings"] = {
			[theatre_names[1]] = {
	
			},
			[theatre_names[2]] = {
				
			},
			[theatre_names[3]] = {
				["tyrion"] = false,
				["alarielle"] = false,
				["morathi"] = {"decrease", "large"},
				["wulfrik"] = {"decrease", "small"},
				["noctilus"] = {"decrease", "large"},
				["grom"] = {"decrease", "small"},
				["nkari"] = {"decrease", "large"}
			},
			[theatre_names[4]] = {
				
			},
			[theatre_names[5]] = {
				
			},
			[theatre_names[6]] = {
				
			},
			[theatre_names[7]] = {
				
			},
			[theatre_names[8]] = {
				
			},
			[theatre_names[9]] = {
				
			},
			[theatre_names[10]] = {
				
			},
			[theatre_names[11]] = {
				
			}
		},
		["wh3_main_ogr_ogre_kingdoms"] = {
			[theatre_names[1]] = {
	
			},
			[theatre_names[2]] = {
				
			},
			[theatre_names[3]] = {
				["tyrion"] = {"decrease", "small"},
				["alarielle"] = {"decrease", "small"},
				["morathi"] = {"decrease", "small"},
				["wulfrik"] = false,
				["noctilus"] = {"decrease", "large"},
				["grom"] = false,
				["nkari"] = {"decrease", "small"}
			},
			[theatre_names[4]] = {
				
			},
			[theatre_names[5]] = {
				
			},
			[theatre_names[6]] = {
				
			},
			[theatre_names[7]] = {
				
			},
			[theatre_names[8]] = {
				
			},
			[theatre_names[9]] = {
				
			},
			[theatre_names[10]] = {
				
			},
			[theatre_names[11]] = {
				
			}
		},
		["wh2_main_def_cult_of_pleasure"] = {
			[theatre_names[1]] = {
	
			},
			[theatre_names[2]] = {
				
			},
			[theatre_names[3]] = {
				["tyrion"] = {"decrease", "large"},
				["alarielle"] = {"decrease", "large"},
				["morathi"] = false,
				["wulfrik"] = {"increase", "small"},
				["noctilus"] = {"decrease", "large"},
				["grom"] = {"decrease", "large"},
				["nkari"] = {"increase", "large"}
			},
			[theatre_names[4]] = {
				
			},
			[theatre_names[5]] = {
				
			},
			[theatre_names[6]] = {
				
			},
			[theatre_names[7]] = {
				
			},
			[theatre_names[8]] = {
				
			},
			[theatre_names[9]] = {
				
			},
			[theatre_names[10]] = {
				
			},
			[theatre_names[11]] = {
				
			}
		}
	}
}