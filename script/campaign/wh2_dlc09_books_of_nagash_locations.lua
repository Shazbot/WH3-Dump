patrol_me_black_creek_raiders = {{x = 177, y = 283}, {x = 201, y = 298}, {x = 214, y = 282}};
patrol_me_eyes_of_the_jungle = {{x = 568, y = 291}, {x = 534, y = 304}, {x = 500, y = 255}};
patrol_me_dwellers_of_zardok = {{x = 113, y = 800}, {x = 88, y = 843}, {x = 64, y = 800}};
patrol_me_dwellers_of_zardok_settra = {{x = 676, y = 655}, {x = 623, y = 612}, {x = 659, y = 574}};
patrol_me_dwellers_of_zardok_khalida = {{x = 640, y = 443}, {x = 688, y = 423}};
patrol_ie_pilgrims_of_myrmidia_khalida = {{x = 363, y = 574}, {x = 259, y = 468}, {x = 158, y = 572}, {x = 276, y = 679}};
patrol_me_pilgrims_of_myrmidia = {{x = 896, y = 300}, {x = 259, y = 468}, {x = 158, y = 572}, {x = 276, y = 679}};
patrol_ie_shrouded_wanderers_of_undead = {{x = 650, y = 200}, {x = 600, y = 200}, {x = 650, y = 200}, {x = 600, y = 200}};

book_objective_list_faction_grand = {
	----------------------------
	---------- SETTRA ----------
	----------------------------
	["wh2_dlc09_tmb_khemri"] = {
		{objective = "CAPTURE_REGIONS", target = "wh3_main_combi_region_lahmia"},
		{objective = "CAPTURE_REGIONS", target = "wh3_main_combi_region_skavenblight"},
		{objective = "CAPTURE_REGIONS", target = "wh3_main_combi_region_karak_eight_peaks"},
		{objective = "CAPTURE_REGIONS", target = "wh3_main_combi_region_black_pyramid_of_nagash"},
		{objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_black_creek_raiders", pos = {x = 191, y = 275}, patrol = patrol_me_black_creek_raiders},
		{objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_eyes_of_the_jungle", pos = {x = 500, y = 255}, patrol = patrol_me_eyes_of_the_jungle},
		{objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_dwellers_of_zardok", pos = {x = 698, y = 611}, patrol = patrol_me_dwellers_of_zardok_settra},
		{objective = "ENGAGE_FORCE", target = "wh3_main_rogue_shrouded_wanderers_of_undead", pos = {x = 650, y = 200}, patrol = patrol_ie_shrouded_wanderers_of_undead}
	},
	----------------------------
	---------- ARKHAN ----------
	----------------------------
	["wh2_dlc09_tmb_followers_of_nagash"] = {
		{objective = "CAPTURE_REGIONS", target = "wh3_main_combi_region_temple_of_skulls"},
		{objective = "CAPTURE_REGIONS", target = "wh3_main_combi_region_skavenblight"},
		{objective = "CAPTURE_REGIONS", target = "wh3_main_combi_region_karak_eight_peaks"},
		{objective = "CAPTURE_REGIONS", target = "wh3_main_combi_region_black_pyramid_of_nagash"},
		{objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_black_creek_raiders", pos = {x = 191, y = 275}, patrol = patrol_me_black_creek_raiders},
		{objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_eyes_of_the_jungle", pos = {x = 500, y = 255}, patrol = patrol_me_eyes_of_the_jungle},
		{objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_dwellers_of_zardok", pos = {x = 698, y = 611}, patrol = patrol_me_dwellers_of_zardok_settra},
		{objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_pilgrims_of_myrmidia", pos = {x = 276, y = 679}, patrol = patrol_me_pilgrims_of_myrmidia}
	},
	-----------------------------
	---------- KHALIDA ----------
	-----------------------------
	["wh2_dlc09_tmb_lybaras"] = {
		{objective = "CAPTURE_REGIONS", target = "wh3_main_combi_region_lost_plateau"},
		{objective = "CAPTURE_REGIONS", target = "wh3_main_combi_region_sartosa"},
		{objective = "CAPTURE_REGIONS", target = "wh3_main_combi_region_castle_drakenhof"},
		{objective = "CAPTURE_REGIONS", target = "wh3_main_combi_region_black_pyramid_of_nagash"},
		{objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_black_creek_raiders", pos = {x = 191, y = 275}, patrol = patrol_me_black_creek_raiders},
		{objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_eyes_of_the_jungle", pos = {x = 500, y = 255}, patrol = patrol_me_eyes_of_the_jungle},
		{objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_dwellers_of_zardok", pos = {x = 741, y = 463}, patrol = patrol_me_dwellers_of_zardok_khalida},
		{objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_pilgrims_of_myrmidia", pos = {x = 896, y = 375}, patrol = patrol_ie_pilgrims_of_myrmidia_khalida}
	},
	----------------------------
	---------- KHATEP ----------
	----------------------------
	["wh2_dlc09_tmb_exiles_of_nehek"] = {
		{objective = "CAPTURE_REGIONS", target = "wh3_main_combi_region_couronne"},
		{objective = "CAPTURE_REGIONS", target = "wh3_main_combi_region_hexoatl"},
		{objective = "CAPTURE_REGIONS", target = "wh3_main_combi_region_ancient_city_of_quintex"},
		{objective = "CAPTURE_REGIONS", target = "wh3_main_combi_region_white_tower_of_hoeth"},
		{objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_black_creek_raiders", pos = {x = 191, y = 275}, patrol = patrol_me_black_creek_raiders},
		{objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_eyes_of_the_jungle", pos = {x = 500, y = 255}, patrol = patrol_me_eyes_of_the_jungle},
		{objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_dwellers_of_zardok", pos = {x = 108, y = 796}, patrol = patrol_me_dwellers_of_zardok},
		{objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_pilgrims_of_myrmidia", pos = {x = 276, y = 679}, patrol = patrol_me_pilgrims_of_myrmidia}
	},

	----------------------------
	--------- MANNFRED ---------
	----------------------------
	["wh_main_vmp_vampire_counts"] = {
		{objective = "CAPTURE_REGIONS", target = "wh3_main_combi_region_lahmia"},
		{objective = "CAPTURE_REGIONS", target = "wh3_main_combi_region_skavenblight"},
		{objective = "CAPTURE_REGIONS", target = "wh3_main_combi_region_karak_eight_peaks"},
		{objective = "CAPTURE_REGIONS", target = "wh3_main_combi_region_white_tower_of_hoeth"},
		{objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_black_creek_raiders", pos = {x = 191, y = 275}, patrol = patrol_me_black_creek_raiders},
		{objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_eyes_of_the_jungle", pos = {x = 500, y = 255}, patrol = patrol_me_eyes_of_the_jungle},
		{objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_dwellers_of_zardok", pos = {x = 698, y = 611}, patrol = patrol_me_dwellers_of_zardok_settra},
		{objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_pilgrims_of_myrmidia", pos = {x = 276, y = 679}, patrol = patrol_me_pilgrims_of_myrmidia}
	},

	----------------------------
	---------- VOLKMAR ---------
	----------------------------
	["wh3_main_emp_cult_of_sigmar"] = {
		{objective = "CAPTURE_REGIONS", target = "wh3_main_combi_region_lahmia"},
		{objective = "CAPTURE_REGIONS", target = "wh3_main_combi_region_skavenblight"},
		{objective = "CAPTURE_REGIONS", target = "wh3_main_combi_region_karak_eight_peaks"},
		{objective = "CAPTURE_REGIONS", target = "wh3_main_combi_region_black_pyramid_of_nagash"},
		{objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_black_creek_raiders", pos = {x = 191, y = 275}, patrol = patrol_me_black_creek_raiders},
		{objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_eyes_of_the_jungle", pos = {x = 500, y = 255}, patrol = patrol_me_eyes_of_the_jungle},
		{objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_dwellers_of_zardok", pos = {x = 698, y = 611}, patrol = patrol_me_dwellers_of_zardok_settra},
		{objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_pilgrims_of_myrmidia", pos = {x = 276, y = 679}, patrol = patrol_me_pilgrims_of_myrmidia}
	},
};

---------------------------------
---------- MULTIPLAYER ----------
---------------------------------
book_objective_list_grand = {
	{objective = "CAPTURE_REGIONS", target = "wh3_main_combi_region_altdorf"},
	{objective = "CAPTURE_REGIONS", target = "wh3_main_combi_region_hexoatl"},
	{objective = "CAPTURE_REGIONS", target = "wh3_main_combi_region_karaz_a_karak"},
	{objective = "CAPTURE_REGIONS", target = "wh3_main_combi_region_white_tower_of_hoeth"},
	{objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_black_creek_raiders", pos = {x = 214, y = 282}, patrol = patrol_me_black_creek_raiders},
	{objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_eyes_of_the_jungle", pos = {x = 500, y = 255}, patrol = patrol_me_eyes_of_the_jungle},
	{objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_dwellers_of_zardok", pos = {x = 108, y = 796}, patrol = patrol_me_dwellers_of_zardok},
	{objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_pilgrims_of_myrmidia", pos = {x = 276, y = 679}, patrol = patrol_me_pilgrims_of_myrmidia}
};