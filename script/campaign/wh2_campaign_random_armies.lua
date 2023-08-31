-- a one-stop-shop for generating random but relatively sensible armies. Use pre-existing tempaltes or add your own so that everyone can use it!

WH_Random_Army_Generator = {}

--generates a random army based for the relevant faction template_key. 
--currently has armies stored for each template_key, but technically we can use any key here. So feel free to add custom armies with unique rosters using the existing format.
--Use the 'power' modifier to increase the likeliness of high-tier units appearing. this is clamped between 1 and 10.
--if 'use thresholds' is true, high tier units will *never* appear at low power levels, and vice versa. These thresholds are defined within the function
function WH_Random_Army_Generator:generate_random_army(key, template_key, num_units, power, use_thresholds, generate_as_table)
	local unit_list = {};
	local ram = random_army_manager;

	--clamp the range
	if power < 1 then
		power = 1
	elseif power > 10 then
		power = 10
	end

	--the formulae we use for each tier
	local low_tier_modifier = 1
	local mid_tier_modifier = power
	local high_tier_modifier  = power*2

	-- thresholds at which certain tiers of units will start/stop appearing if use_thresholds is enabled
	-- these can be adjusted, but there should always be some overlap
	
	local mid_tier_lower_threshold = 2
	local mid_tier_upper_threshold = 10

	local high_tier_lower_threshold = 6

	local low_tier_upper_threshold = 7
	

	--formulae for the weighting
	if use_thresholds then
		if power <= mid_tier_lower_threshold then
			mid_tier_modifier = 0
		end

		if power <= high_tier_lower_threshold then
			high_tier_modifier = 0
		end
		
		if power >= low_tier_upper_threshold then
			low_tier_modifier = 0
		end

		if power >= mid_tier_upper_threshold then
			mid_tier_modifier = 0
		end

	end

	ram:new_force(key);
	
	if template_key == "wh_main_sc_emp_empire" then

		--low tier
		local weighting_modifier = low_tier_modifier
		ram:add_unit(key, "wh_main_emp_inf_swordsmen", 20*weighting_modifier);
		ram:add_unit(key, "wh_main_emp_inf_spearmen_0", 12*weighting_modifier);
		ram:add_unit(key, "wh_main_emp_inf_spearmen_1", 12*weighting_modifier);
		ram:add_unit(key, "wh_dlc04_emp_inf_flagellants_0", 6*weighting_modifier);
		ram:add_unit(key, "wh_main_emp_inf_crossbowmen", 8*weighting_modifier);
		ram:add_unit(key, "wh_dlc04_emp_inf_free_company_militia_0", 4*weighting_modifier);
		ram:add_unit(key, "wh_main_emp_inf_handgunners", 2*weighting_modifier);
		ram:add_unit(key, "wh_main_emp_cav_pistoliers_1", 4*weighting_modifier);
		ram:add_unit(key, "wh_main_emp_art_mortar", 4*weighting_modifier);

		---mid tier
		local weighting_modifier = mid_tier_modifier
		ram:add_unit(key, "wh_main_emp_cav_empire_knights", 4*weighting_modifier);
		ram:add_unit(key, "wh_main_emp_cav_reiksguard", 2*weighting_modifier);
		ram:add_unit(key, "wh_main_emp_cav_outriders_0", 2*weighting_modifier);
		ram:add_unit(key, "wh_main_emp_cav_outriders_1", 2*weighting_modifier);
		ram:add_unit(key, "wh_dlc04_emp_cav_knights_blazing_sun_0", 1*weighting_modifier);
		ram:add_unit(key, "wh_main_emp_inf_halberdiers", 4*weighting_modifier);
		ram:add_unit(key, "wh_main_emp_art_great_cannon", 4*weighting_modifier);

		--high tier
		local weighting_modifier = high_tier_modifier
		ram:add_unit(key, "wh_main_emp_inf_greatswords", 2*weighting_modifier)
		ram:add_unit(key, "wh_main_emp_art_helblaster_volley_gun", 1*weighting_modifier)
		ram:add_unit(key, "wh_main_emp_art_helstorm_rocket_battery", 1*weighting_modifier)
		ram:add_unit(key, "wh_main_emp_veh_steam_tank", 1*weighting_modifier)
		ram:add_unit(key, "wh_main_emp_veh_luminark_of_hysh_0", 1*weighting_modifier)
		ram:add_unit(key, "wh_main_emp_cav_demigryph_knights_0", 1*weighting_modifier)
		ram:add_unit(key, "wh_main_emp_cav_demigryph_knights_1", 1*weighting_modifier)	
		
	elseif template_key == "wh_main_sc_dwf_dwarfs" then
		local weighting_modifier = low_tier_modifier
		ram:add_unit(key, "wh_main_dwf_inf_miners_0", 18*weighting_modifier);
		ram:add_unit(key, "wh_main_dwf_inf_miners_1", 6*weighting_modifier);
		ram:add_unit(key, "wh_main_dwf_inf_dwarf_warrior_0", 15*weighting_modifier);
		ram:add_unit(key, "wh_main_dwf_inf_dwarf_warrior_1", 10*weighting_modifier);
		ram:add_unit(key, "wh_main_dwf_inf_quarrellers_0", 10*weighting_modifier);
		ram:add_unit(key, "wh_main_dwf_inf_quarrellers_1", 4*weighting_modifier);
		
		local weighting_modifier = mid_tier_modifier
		ram:add_unit(key, "wh_main_dwf_inf_thunderers_0", 3*weighting_modifier);
		ram:add_unit(key, "wh_main_dwf_inf_longbeards", 4*weighting_modifier);
		ram:add_unit(key, "wh_main_dwf_inf_longbeards_1", 2*weighting_modifier);
		ram:add_unit(key, "wh_main_dwf_inf_slayers", 3*weighting_modifier);
		ram:add_unit(key, "wh_main_dwf_art_grudge_thrower", 4*weighting_modifier);
		ram:add_unit(key, "wh_main_dwf_art_cannon", 2*weighting_modifier);
		ram:add_unit(key, "wh_main_dwf_art_organ_gun", 1*weighting_modifier);
		ram:add_unit(key, "wh_main_dwf_art_flame_cannon", 1*weighting_modifier);
		ram:add_unit(key, "wh_dlc06_dwf_inf_rangers_0", 2*weighting_modifier);
		ram:add_unit(key, "wh_dlc06_dwf_inf_rangers_1", 2*weighting_modifier);
		
		local weighting_modifier = high_tier_modifier
		ram:add_unit(key, "wh_main_dwf_inf_hammerers", 1*weighting_modifier);
		ram:add_unit(key, "wh_main_dwf_inf_ironbreakers", 1*weighting_modifier);
		ram:add_unit(key, "wh2_dlc10_dwf_inf_giant_slayers", 1*weighting_modifier);
		ram:add_unit(key, "wh_main_dwf_inf_irondrakes_0", 1*weighting_modifier);
		ram:add_unit(key, "wh_main_dwf_inf_irondrakes_2", 1*weighting_modifier);
		ram:add_unit(key, "wh_main_dwf_veh_gyrocopter_0", 1*weighting_modifier);
		ram:add_unit(key, "wh_main_dwf_veh_gyrocopter_1", 1*weighting_modifier);
		ram:add_unit(key, "wh_main_dwf_veh_gyrobomber", 1*weighting_modifier);
		ram:add_unit(key, "wh_dlc06_dwf_inf_bugmans_rangers_0", 1*weighting_modifier);
		
	elseif template_key == "wh_main_sc_vmp_vampire_counts" then
		
		--Low Tier
		local weighting_modifier = low_tier_modifier
		ram:add_unit(key, "wh_main_vmp_inf_zombie", 18*weighting_modifier);
		ram:add_unit(key, "wh_main_vmp_inf_skeleton_warriors_0", 18*weighting_modifier);
		ram:add_unit(key, "wh_main_vmp_inf_skeleton_warriors_1", 16*weighting_modifier);
		ram:add_unit(key, "wh_main_vmp_inf_crypt_ghouls", 8*weighting_modifier);
		ram:add_unit(key, "wh_main_vmp_mon_fell_bats", 8*weighting_modifier);
		ram:add_unit(key, "wh_main_vmp_mon_dire_wolves", 8*weighting_modifier);
		
		--Mid Tier
		local weighting_modifier = mid_tier_modifier
		ram:add_unit(key, "wh_main_vmp_cav_black_knights_0", 2*weighting_modifier);
		ram:add_unit(key, "wh_main_vmp_cav_black_knights_3", 2*weighting_modifier);
		ram:add_unit(key, "wh_dlc04_vmp_veh_corpse_cart_0", 1*weighting_modifier);
		ram:add_unit(key, "wh_dlc04_vmp_veh_corpse_cart_1", 1*weighting_modifier);
		ram:add_unit(key, "wh_dlc04_vmp_veh_corpse_cart_2", 1*weighting_modifier);
		ram:add_unit(key, "wh_main_vmp_inf_grave_guard_0", 4*weighting_modifier);
		ram:add_unit(key, "wh_main_vmp_inf_grave_guard_1", 4*weighting_modifier);
		ram:add_unit(key, "wh_main_vmp_mon_crypt_horrors", 2*weighting_modifier);
		ram:add_unit(key, "wh_main_vmp_mon_vargheists", 2*weighting_modifier);
		ram:add_unit(key, "wh_main_vmp_inf_cairn_wraiths", 2*weighting_modifier);
		
		--High Tier
		local weighting_modifier = high_tier_modifier
		ram:add_unit(key, "wh_main_vmp_mon_varghulf", 1*weighting_modifier);
		ram:add_unit(key, "wh_main_vmp_mon_terrorgheist", 1*weighting_modifier);
		ram:add_unit(key, "wh_main_vmp_cav_hexwraiths", 1*weighting_modifier);
		ram:add_unit(key, "wh_dlc02_vmp_cav_blood_knights_0", 1*weighting_modifier);
		ram:add_unit(key, "wh_main_vmp_veh_black_coach", 1*weighting_modifier);
		ram:add_unit(key, "wh_dlc04_vmp_veh_mortis_engine_0", 1*weighting_modifier);
		
	elseif template_key == "wh_main_sc_grn_greenskins" then
		local weighting_modifier = low_tier_modifier
		ram:add_unit(key, "wh_main_grn_inf_goblin_spearmen", 10*weighting_modifier);
		ram:add_unit(key, "wh_dlc06_grn_inf_nasty_skulkers_0", 4*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_inf_night_goblins", 2*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_inf_orc_boyz", 16*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_mon_trolls", 3*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_inf_savage_orcs", 3*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_inf_goblin_archers", 10*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_inf_orc_arrer_boyz", 6*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_inf_savage_orc_arrer_boyz", 2*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_cav_orc_boar_boyz", 3*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_cav_goblin_wolf_riders_0", 5*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_cav_goblin_wolf_riders_1", 2*weighting_modifier);
		ram:add_unit(key, "wh2_dlc15_grn_veh_snotling_pump_wagon_0", 2*weighting_modifier);
		
		local weighting_modifier = mid_tier_modifier
		ram:add_unit(key, "wh_main_grn_art_goblin_rock_lobber", 2*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_inf_orc_big_uns", 4*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_cav_goblin_wolf_chariot", 1*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_cav_forest_goblin_spider_riders_0", 2*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_cav_forest_goblin_spider_riders_1", 2*weighting_modifier);
		ram:add_unit(key, "wh_dlc06_grn_inf_squig_herd_0", 1*weighting_modifier);
		ram:add_unit(key, "wh_dlc06_grn_cav_squig_hoppers_0", 1*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_inf_savage_orc_big_uns", 2*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_cav_orc_boar_boy_big_uns", 2*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_cav_orc_boar_chariot", 1*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_inf_night_goblin_archers", 4*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_cav_savage_orc_boar_boyz", 1*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_cav_savage_orc_boar_boy_big_uns", 1*weighting_modifier);
		ram:add_unit(key, "wh2_dlc15_grn_mon_stone_trolls_0", 1*weighting_modifier);
		ram:add_unit(key, "wh2_dlc15_grn_mon_river_trolls_0", 1*weighting_modifier);
		ram:add_unit(key, "wh2_dlc15_grn_veh_snotling_pump_wagon_flappas_0", 1*weighting_modifier);
		ram:add_unit(key, "wh2_dlc15_grn_veh_snotling_pump_wagon_roller_0", 1*weighting_modifier);
		
		local weighting_modifier = high_tier_modifier
		ram:add_unit(key, "wh_main_grn_inf_night_goblin_fanatics", 2*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_inf_night_goblin_fanatics_1", 2*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_mon_giant", 1*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_mon_arachnarok_spider_0", 1*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_inf_black_orcs", 2*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_art_doom_diver_catapult", 1*weighting_modifier);
		ram:add_unit(key, "wh2_dlc15_grn_mon_rogue_idol_0", 1*weighting_modifier);

	elseif template_key == "wh_main_sc_grn_savage_orcs" then
		local weighting_modifier = low_tier_modifier
		ram:add_unit(key, "wh_main_grn_mon_trolls", 2*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_inf_savage_orcs", 12*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_inf_savage_orc_arrer_boyz", 6*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_cav_savage_orc_boar_boyz", 2*weighting_modifier);
		
		local weighting_modifier = mid_tier_modifier
		ram:add_unit(key, "wh_main_grn_inf_savage_orc_big_uns", 6*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_cav_savage_orc_boar_boyz", 4*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_cav_savage_orc_boar_boy_big_uns", 2*weighting_modifier);
		ram:add_unit(key, "wh2_dlc15_grn_mon_stone_trolls_0", 1*weighting_modifier);
		ram:add_unit(key, "wh2_dlc15_grn_mon_river_trolls_0", 1*weighting_modifier);
		
		local weighting_modifier = high_tier_modifier
		ram:add_unit(key, "wh_main_grn_mon_giant", 1*weighting_modifier);
		ram:add_unit(key, "wh2_dlc15_grn_mon_rogue_idol_0", 1*weighting_modifier);
		
	elseif template_key == "wh_main_sc_chs_chaos" then
		local weighting_modifier = low_tier_modifier
		ram:add_unit(key, "wh_main_chs_inf_chaos_marauders_0", 18*weighting_modifier);
		ram:add_unit(key, "wh_main_chs_inf_chaos_marauders_1", 13*weighting_modifier);
		ram:add_unit(key, "wh_main_chs_cav_marauder_horsemen_0", 8*weighting_modifier);
		ram:add_unit(key, "wh_main_chs_cav_marauder_horsemen_1", 4*weighting_modifier);
		ram:add_unit(key, "wh_main_chs_mon_chaos_warhounds_0", 12*weighting_modifier);
		ram:add_unit(key, "wh_main_chs_mon_chaos_warhounds_1", 6*weighting_modifier);
		
		local weighting_modifier = mid_tier_modifier
		ram:add_unit(key, "wh_main_chs_mon_trolls", 3*weighting_modifier);
		ram:add_unit(key, "wh_dlc01_chs_mon_trolls_1", 1*weighting_modifier);
		ram:add_unit(key, "wh_dlc06_chs_cav_marauder_horsemasters_0", 2*weighting_modifier);
		ram:add_unit(key, "wh_main_chs_cav_chaos_chariot", 1*weighting_modifier);
		ram:add_unit(key, "wh_main_chs_inf_chaos_warriors_0", 8*weighting_modifier);
		ram:add_unit(key, "wh_main_chs_inf_chaos_warriors_1", 3*weighting_modifier);
		ram:add_unit(key, "wh_dlc01_chs_inf_chaos_warriors_2", 2*weighting_modifier);
		ram:add_unit(key, "wh_dlc01_chs_inf_forsaken_0", 3*weighting_modifier);
		ram:add_unit(key, "wh_dlc06_chs_inf_aspiring_champions_0", 2*weighting_modifier);
		ram:add_unit(key, "wh_main_chs_mon_chaos_spawn", 2*weighting_modifier);
		ram:add_unit(key, "wh_dlc06_chs_feral_manticore", 2*weighting_modifier);
		ram:add_unit(key, "wh_main_chs_art_hellcannon", 1*weighting_modifier);
		
		
		local weighting_modifier = high_tier_modifier
		ram:add_unit(key, "wh_main_chs_inf_chosen_0", 1*weighting_modifier);
		ram:add_unit(key, "wh_main_chs_inf_chosen_1", 1*weighting_modifier);
		ram:add_unit(key, "wh_dlc01_chs_inf_chosen_2", 1*weighting_modifier);
		ram:add_unit(key, "wh_main_chs_cav_chaos_knights_0", 1*weighting_modifier);
		ram:add_unit(key, "wh_main_chs_cav_chaos_knights_1", 1*weighting_modifier);
		ram:add_unit(key, "wh_main_chs_mon_giant", 1*weighting_modifier);
		ram:add_unit(key, "wh_dlc01_chs_mon_dragon_ogre", 1*weighting_modifier);
		ram:add_unit(key, "wh_dlc01_chs_mon_dragon_ogre_shaggoth", 1*weighting_modifier);
		ram:add_unit(key, "wh_dlc01_chs_cav_gorebeast_chariot", 1*weighting_modifier);		
		
	elseif template_key == "wh_dlc03_sc_bst_beastmen" then
	
		--low_tier 
		local weighting_modifier = low_tier_modifier
		ram:add_unit(key, "wh_dlc03_bst_inf_ungor_herd_1", 16*weighting_modifier);
		ram:add_unit(key, "wh_dlc03_bst_inf_ungor_spearmen_0", 16*weighting_modifier);
		ram:add_unit(key, "wh_dlc03_bst_inf_ungor_spearmen_1", 8*weighting_modifier);
		ram:add_unit(key, "wh_dlc03_bst_inf_ungor_raiders_0", 10*weighting_modifier);
		ram:add_unit(key, "wh_dlc03_bst_inf_chaos_warhounds_0", 4*weighting_modifier);
		ram:add_unit(key, "wh_dlc03_bst_inf_chaos_warhounds_1", 2*weighting_modifier);
		ram:add_unit(key, "wh_dlc03_bst_inf_gor_herd_0", 6*weighting_modifier);
		ram:add_unit(key, "wh_dlc05_bst_mon_harpies_0", 6*weighting_modifier);
		ram:add_unit(key, "wh_dlc03_bst_inf_razorgor_herd_0", 2*weighting_modifier);
		
		--mid_tier
		local weighting_modifier = mid_tier_modifier
		ram:add_unit(key, "wh_dlc03_bst_inf_ungor_raiders_0", 4*weighting_modifier);
		ram:add_unit(key, "wh2_dlc17_bst_cav_tuskgor_chariot_0", 2*weighting_modifier);
		ram:add_unit(key, "wh_dlc03_bst_cav_razorgor_chariot_0", 2*weighting_modifier);
		ram:add_unit(key, "wh_dlc03_bst_inf_centigors_0", 2*weighting_modifier);
		ram:add_unit(key, "wh_dlc03_bst_inf_centigors_1", 2*weighting_modifier);
		ram:add_unit(key, "wh_dlc03_bst_inf_centigors_2", 2*weighting_modifier);
		ram:add_unit(key, "wh_dlc03_bst_inf_gor_herd_0", 8*weighting_modifier);
		ram:add_unit(key, "wh_dlc03_bst_inf_gor_herd_1", 6*weighting_modifier);
		ram:add_unit(key, "wh_dlc03_bst_mon_chaos_spawn_0", 2*weighting_modifier);
		ram:add_unit(key, "wh_dlc03_bst_mon_giant_0", 1*weighting_modifier);
		
		--high_tier
		local weighting_modifier = high_tier_modifier
		ram:add_unit(key, "wh_dlc03_bst_inf_bestigor_herd_0", 3*weighting_modifier);
		ram:add_unit(key, "wh_dlc03_bst_inf_minotaurs_0", 2*weighting_modifier);
		ram:add_unit(key, "wh_dlc03_bst_inf_minotaurs_1", 2*weighting_modifier);
		ram:add_unit(key, "wh_dlc03_bst_inf_minotaurs_2", 2*weighting_modifier);
		ram:add_unit(key, "wh2_dlc17_bst_mon_jabberslythe_0", 1*weighting_modifier);
		ram:add_unit(key, "wh2_dlc17_bst_mon_ghorgon_0", 1*weighting_modifier);
		ram:add_unit(key, "wh_dlc03_bst_inf_cygor_0", 1*weighting_modifier);
		
	elseif template_key == "wh_dlc05_sc_wef_wood_elves" then
		local weighting_modifier = low_tier_modifier
		ram:add_unit(key, "wh_dlc05_wef_inf_eternal_guard_0", 16*weighting_modifier);
		ram:add_unit(key, "wh_dlc05_wef_inf_eternal_guard_1", 12*weighting_modifier);
		ram:add_unit(key, "wh_dlc05_wef_inf_dryads_0", 10*weighting_modifier);
		ram:add_unit(key, "wh_dlc05_wef_inf_glade_guard_0", 10*weighting_modifier);
		ram:add_unit(key, "wh_dlc05_wef_inf_glade_guard_1", 6*weighting_modifier);
		ram:add_unit(key, "wh_dlc05_wef_inf_glade_guard_2", 5*weighting_modifier);
		ram:add_unit(key, "wh_dlc05_wef_cav_glade_riders_0", 6*weighting_modifier);
		ram:add_unit(key, "wh_dlc05_wef_cav_glade_riders_1", 2*weighting_modifier);
		
		local weighting_modifier = mid_tier_modifier
		ram:add_unit(key, "wh_dlc05_wef_cav_wild_riders_0", 8*weighting_modifier);
		ram:add_unit(key, "wh_dlc05_wef_cav_wild_riders_1", 6*weighting_modifier);
		ram:add_unit(key, "wh_dlc05_wef_cav_hawk_riders_0", 1*weighting_modifier);
		ram:add_unit(key, "wh_dlc05_wef_mon_great_eagle_0", 1*weighting_modifier);
		ram:add_unit(key, "wh_dlc05_wef_inf_wardancers_0", 3*weighting_modifier);
		ram:add_unit(key, "wh_dlc05_wef_inf_wardancers_1", 1*weighting_modifier);
		ram:add_unit(key, "wh_dlc05_wef_mon_treekin_0", 2*weighting_modifier);
		ram:add_unit(key, "wh_dlc05_wef_inf_deepwood_scouts_0", 4*weighting_modifier);
		ram:add_unit(key, "wh_dlc05_wef_inf_deepwood_scouts_1", 2*weighting_modifier);
		
		local weighting_modifier = high_tier_modifier
		ram:add_unit(key, "wh_dlc05_wef_inf_waywatchers_0", 1*weighting_modifier);
		ram:add_unit(key, "wh_dlc05_wef_mon_treeman_0", 1*weighting_modifier);
		ram:add_unit(key, "wh_dlc05_wef_inf_wildwood_rangers_0", 2*weighting_modifier);
		ram:add_unit(key, "wh_dlc05_wef_forest_dragon_0", 1*weighting_modifier);
		ram:add_unit(key, "wh_dlc05_wef_cav_sisters_thorn_0", 1*weighting_modifier);
		
	elseif template_key == "wh_main_sc_brt_bretonnia" then
		local weighting_modifier = low_tier_modifier
		ram:add_unit(key, "wh_dlc07_brt_peasant_mob_0", 12*weighting_modifier);
		ram:add_unit(key, "wh_main_brt_inf_spearmen_at_arms", 8*weighting_modifier);
		ram:add_unit(key, "wh_dlc07_brt_inf_spearmen_at_arms_1", 3*weighting_modifier);
		ram:add_unit(key, "wh_main_brt_inf_men_at_arms", 8*weighting_modifier);
		ram:add_unit(key, "wh_dlc07_brt_inf_men_at_arms_1", 4*weighting_modifier);
		ram:add_unit(key, "wh_dlc07_brt_inf_men_at_arms_2", 1*weighting_modifier);
		ram:add_unit(key, "wh_main_brt_inf_peasant_bowmen", 10*weighting_modifier);
		ram:add_unit(key, "wh_dlc07_brt_inf_peasant_bowmen_1", 3*weighting_modifier);
		ram:add_unit(key, "wh_dlc07_brt_inf_peasant_bowmen_2", 3*weighting_modifier);
		ram:add_unit(key, "wh_main_brt_cav_mounted_yeomen_0", 4*weighting_modifier);
		ram:add_unit(key, "wh_main_brt_cav_mounted_yeomen_1", 8*weighting_modifier);
		ram:add_unit(key, "wh_dlc07_brt_cav_knights_errant_0", 12*weighting_modifier);

		local weighting_modifier = mid_tier_modifier
		ram:add_unit(key, "wh_main_brt_cav_knights_of_the_realm", 8*weighting_modifier);
		ram:add_unit(key, "wh_dlc07_brt_cav_questing_knights_0", 2*weighting_modifier);
		ram:add_unit(key, "wh_main_brt_cav_pegasus_knights", 1*weighting_modifier);
		ram:add_unit(key, "wh_dlc07_brt_inf_foot_squires_0", 4*weighting_modifier);
		ram:add_unit(key, "wh_dlc07_brt_inf_battle_pilgrims_0", 4*weighting_modifier);
		ram:add_unit(key, "wh_dlc07_brt_inf_grail_reliquae_0", 1*weighting_modifier);
		ram:add_unit(key, "wh_main_brt_art_field_trebuchet", 2*weighting_modifier);
		
		local weighting_modifier = high_tier_modifier
		ram:add_unit(key, "wh_main_brt_cav_grail_knights", 1*weighting_modifier);
		ram:add_unit(key, "wh_dlc07_brt_cav_grail_guardians_0", 1*weighting_modifier);
		ram:add_unit(key, "wh_dlc07_brt_cav_royal_pegasus_knights_0", 1*weighting_modifier);
		ram:add_unit(key, "wh_dlc07_brt_cav_royal_hippogryph_knights_0", 1*weighting_modifier);
		ram:add_unit(key, "wh_dlc07_brt_art_blessed_field_trebuchet_0", 1*weighting_modifier);
		
	elseif template_key == "wh_dlc08_sc_nor_norsca" then
		local weighting_modifier = low_tier_modifier
		ram:add_unit(key, "wh_main_nor_inf_chaos_marauders_0", 18*weighting_modifier);
		ram:add_unit(key, "wh_main_nor_inf_chaos_marauders_1", 10*weighting_modifier);
		ram:add_unit(key, "wh_dlc08_nor_inf_marauder_spearman_0", 12*weighting_modifier);
		ram:add_unit(key, "wh_main_nor_cav_marauder_horsemen_0", 10*weighting_modifier);
		ram:add_unit(key, "wh_main_nor_cav_marauder_horsemen_1", 4*weighting_modifier);
		ram:add_unit(key, "wh_dlc08_nor_inf_marauder_hunters_0", 3*weighting_modifier);
		ram:add_unit(key, "wh_dlc08_nor_inf_marauder_hunters_1", 1*weighting_modifier);
		ram:add_unit(key, "wh_main_nor_mon_chaos_warhounds_0", 6*weighting_modifier);
		ram:add_unit(key, "wh_dlc08_nor_mon_warwolves_0", 4*weighting_modifier);
		
		local weighting_modifier = mid_tier_modifier
		ram:add_unit(key, "wh_dlc08_nor_cav_marauder_horsemasters_0", 2*weighting_modifier);
		ram:add_unit(key, "wh_main_nor_cav_chaos_chariot", 1*weighting_modifier);
		ram:add_unit(key, "wh_dlc08_nor_veh_marauder_warwolves_chariot_0", 1*weighting_modifier);
		ram:add_unit(key, "wh_dlc08_nor_inf_marauder_berserkers_0", 3*weighting_modifier);
		ram:add_unit(key, "wh_dlc08_nor_feral_manticore", 1*weighting_modifier);
		ram:add_unit(key, "wh_main_nor_mon_chaos_trolls", 2*weighting_modifier);
		ram:add_unit(key, "wh_dlc08_nor_mon_norscan_ice_trolls_0", 1*weighting_modifier);

		local weighting_modifier = high_tier_modifier
		ram:add_unit(key, "wh_dlc08_nor_inf_marauder_champions_0", 4*weighting_modifier);
		ram:add_unit(key, "wh_dlc08_nor_inf_marauder_champions_1", 2*weighting_modifier);
		ram:add_unit(key, "wh_dlc08_nor_mon_skinwolves_0", 2*weighting_modifier);
		ram:add_unit(key, "wh_dlc08_nor_mon_skinwolves_1", 1*weighting_modifier);
		ram:add_unit(key, "wh_dlc08_nor_mon_norscan_giant_0", 1*weighting_modifier);
		ram:add_unit(key, "wh_dlc08_nor_mon_fimir_0", 1*weighting_modifier);
		ram:add_unit(key, "wh_dlc08_nor_mon_fimir_1", 1*weighting_modifier);
		ram:add_unit(key, "wh_dlc08_nor_mon_frost_wyrm_0", 1*weighting_modifier);
		ram:add_unit(key, "wh_dlc08_nor_mon_war_mammoth_0", 2*weighting_modifier);
		ram:add_unit(key, "wh_dlc08_nor_mon_war_mammoth_1", 1*weighting_modifier);
		ram:add_unit(key, "wh_dlc08_nor_mon_war_mammoth_2", 1*weighting_modifier);
		
	elseif template_key == "wh2_main_sc_def_dark_elves" then
		--Infantry
		local weighting_modifier = low_tier_modifier
		ram:add_unit(key, "wh2_main_def_inf_dreadspears_0", 10*weighting_modifier);
		ram:add_unit(key, "wh2_main_def_inf_bleakswords_0", 12*weighting_modifier);
		ram:add_unit(key, "wh2_main_def_inf_harpies", 6*weighting_modifier);
		ram:add_unit(key, "wh2_main_def_inf_darkshards_0", 10*weighting_modifier);
		ram:add_unit(key, "wh2_main_def_inf_darkshards_1", 8*weighting_modifier);
		ram:add_unit(key, "wh2_main_def_cav_dark_riders_0", 7*weighting_modifier);
		ram:add_unit(key, "wh2_main_def_cav_dark_riders_1", 3*weighting_modifier);
		ram:add_unit(key, "wh2_main_def_cav_dark_riders_2", 4*weighting_modifier);
		
		local weighting_modifier = mid_tier_modifier
		ram:add_unit(key, "wh2_main_def_inf_witch_elves_0", 2*weighting_modifier);
		ram:add_unit(key, "wh2_dlc10_def_inf_sisters_of_slaughter", 2*weighting_modifier);
		ram:add_unit(key, "wh2_main_def_inf_shades_0", 2*weighting_modifier);
		ram:add_unit(key, "wh2_main_def_inf_shades_1", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_def_inf_shades_2", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_def_art_reaper_bolt_thrower", 2*weighting_modifier);
		ram:add_unit(key, "wh2_dlc10_def_cav_doomfire_warlocks_0", 2*weighting_modifier);
		ram:add_unit(key, "wh2_main_def_cav_cold_one_knights_1", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_def_cav_cold_one_chariot", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_def_inf_black_ark_corsairs_0", 4*weighting_modifier);
		ram:add_unit(key, "wh2_main_def_inf_black_ark_corsairs_1", 2*weighting_modifier)
		ram:add_unit(key, "wh2_dlc14_def_cav_scourgerunner_chariot_0", 1*weighting_modifier)

		local weighting_modifier = high_tier_modifier
		ram:add_unit(key, "wh2_dlc14_def_mon_bloodwrack_medusa_0", 1*weighting_modifier)
		ram:add_unit(key, "wh2_main_def_inf_har_ganeth_executioners_0", 2*weighting_modifier);
		ram:add_unit(key, "wh2_main_def_inf_black_guard_0", 3*weighting_modifier);		
		ram:add_unit(key, "wh2_main_def_mon_war_hydra", 1*weighting_modifier);
		ram:add_unit(key, "wh2_dlc10_def_mon_kharibdyss_0", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_def_mon_black_dragon", 1*weighting_modifier);
		ram:add_unit(key, "wh2_dlc14_def_veh_bloodwrack_shrine_0", 1*weighting_modifier)
		
	elseif template_key == "wh2_main_sc_hef_high_elves" then
		local weighting_modifier = low_tier_modifier
		ram:add_unit(key, "wh2_main_hef_inf_spearmen_0", 16*weighting_modifier);
		ram:add_unit(key, "wh2_main_hef_inf_archers_0", 18*weighting_modifier);
		ram:add_unit(key, "wh2_main_hef_inf_archers_1", 12*weighting_modifier);
		ram:add_unit(key, "wh2_dlc15_hef_inf_rangers_0", 12*weighting_modifier);
		ram:add_unit(key, "wh2_main_hef_cav_ellyrian_reavers_0", 6*weighting_modifier);
		ram:add_unit(key, "wh2_main_hef_cav_ellyrian_reavers_1", 4*weighting_modifier);

		local weighting_modifier = mid_tier_modifier
		ram:add_unit(key, "wh2_main_hef_inf_white_lions_of_chrace_0", 8*weighting_modifier);
		ram:add_unit(key, "wh2_main_hef_inf_lothern_sea_guard_0", 8*weighting_modifier);
		ram:add_unit(key, "wh2_main_hef_inf_lothern_sea_guard_1", 4*weighting_modifier);
		ram:add_unit(key, "wh2_dlc10_hef_inf_shadow_warriors_0", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_hef_cav_silver_helms_0", 2*weighting_modifier);
		ram:add_unit(key, "wh2_main_hef_cav_silver_helms_1", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_hef_mon_great_eagle", 3*weighting_modifier);
		ram:add_unit(key, "wh2_main_hef_cav_ithilmar_chariot", 2*weighting_modifier);
		ram:add_unit(key, "wh2_main_hef_cav_tiranoc_chariot", 1*weighting_modifier);
		ram:add_unit(key, "wh2_dlc15_hef_inf_silverin_guard_0", 8*weighting_modifier);
		ram:add_unit(key, "wh2_main_hef_mon_sun_dragon", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_hef_mon_phoenix_flamespyre", 2*weighting_modifier);
		ram:add_unit(key, "wh2_main_hef_art_eagle_claw_bolt_thrower", 4*weighting_modifier);

		local weighting_modifier = high_tier_modifier
		ram:add_unit(key, "wh2_dlc10_hef_inf_sisters_of_avelorn_0", 2*weighting_modifier);
		ram:add_unit(key, "wh2_main_hef_cav_dragon_princes", 2*weighting_modifier);
		ram:add_unit(key, "wh2_main_hef_inf_swordmasters_of_hoeth_0", 2*weighting_modifier);
		ram:add_unit(key, "wh2_main_hef_inf_phoenix_guard", 2*weighting_modifier);
		ram:add_unit(key, "wh2_dlc15_hef_veh_lion_chariot_of_chrace_0", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_hef_mon_moon_dragon", 2*weighting_modifier);
		ram:add_unit(key, "wh2_main_hef_mon_star_dragon", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_hef_mon_phoenix_frostheart", 2*weighting_modifier);
		ram:add_unit(key, "wh2_dlc15_hef_mon_arcane_phoenix_0", 1*weighting_modifier);

	elseif template_key == "wh2_main_sc_lzd_lizardmen" then
		local weighting_modifier = low_tier_modifier
		ram:add_unit(key, "wh2_main_lzd_inf_skink_cohort_0", 12*weighting_modifier);
		ram:add_unit(key, "wh2_dlc12_lzd_inf_skink_red_crested_0", 7*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_inf_saurus_spearmen_0", 12*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_inf_saurus_warriors_0", 12*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_inf_skink_cohort_1", 7*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_inf_skink_skirmishers_0", 6*weighting_modifier);
		
		
		local weighting_modifier = mid_tier_modifier
		ram:add_unit(key, "wh2_main_lzd_inf_saurus_warriors_1", 8*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_inf_saurus_spearmen_1", 8*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_cav_cold_ones_feral_0", 4*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_cav_cold_ones_1", 4*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_cav_horned_ones_0", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_cav_terradon_riders_0", 2*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_cav_terradon_riders_1", 2*weighting_modifier);
		ram:add_unit(key, "wh2_dlc12_lzd_cav_ripperdactyl_riders_0", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_inf_chameleon_skinks_0", 4*weighting_modifier);
		ram:add_unit(key, "wh2_dlc17_lzd_inf_chameleon_stalkers_0", 3*weighting_modifier);
		ram:add_unit(key, "wh2_dlc12_lzd_mon_salamander_pack_0", 2*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_mon_bastiladon_0", 2*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_mon_stegadon_0", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_mon_kroxigors", 2*weighting_modifier);
		ram:add_unit(key, "wh2_dlc13_lzd_mon_razordon_pack_0", 2*weighting_modifier);

		local weighting_modifier = high_tier_modifier
		ram:add_unit(key, "wh2_main_lzd_inf_temple_guards", 4*weighting_modifier);
		ram:add_unit(key, "wh2_dlc13_lzd_mon_sacred_kroxigors_0", 2*weighting_modifier);
		ram:add_unit(key, "wh2_dlc12_lzd_mon_ancient_salamander_0", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_mon_bastiladon_1", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_mon_bastiladon_2", 1*weighting_modifier);
		ram:add_unit(key, "wh2_dlc12_lzd_mon_bastiladon_3", 1*weighting_modifier);
		ram:add_unit(key, "wh2_dlc17_lzd_mon_troglodon_0", 1*weighting_modifier);
		ram:add_unit(key, "wh2_dlc17_lzd_mon_coatl_0", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_mon_stegadon_1", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_mon_ancient_stegadon", 1*weighting_modifier);
		ram:add_unit(key, "wh2_dlc12_lzd_mon_ancient_stegadon_1", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_mon_carnosaur_0", 1*weighting_modifier);
		
	elseif template_key == "wh2_main_sc_skv_skaven" then
		--
		local weighting_modifier = low_tier_modifier
		ram:add_unit(key, "wh2_main_skv_inf_skavenslaves_0", 10*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_inf_skavenslave_spearmen_0", 10*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_inf_clanrats_0", 12*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_inf_clanrat_spearmen_0", 12*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_inf_skavenslave_slingers_0", 6*weighting_modifier);
		ram:add_unit(key, "wh2_dlc16_skv_mon_wolf_rats_0", 3*weighting_modifier);
		ram:add_unit(key, "wh2_dlc16_skv_mon_wolf_rats_1", 3*weighting_modifier);
	
		local weighting_modifier = mid_tier_modifier
		ram:add_unit(key, "wh2_main_skv_inf_clanrat_spearmen_1", 6*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_inf_clanrats_1", 6*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_inf_plague_monks", 4*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_inf_night_runners_0", 4*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_inf_night_runners_1", 1*weighting_modifier);
		ram:add_unit(key, "wh2_dlc12_skv_veh_doom_flayer_0", 2*weighting_modifier);
		ram:add_unit(key, "wh2_dlc12_skv_inf_ratling_gun_0", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_inf_warpfire_thrower", 2*weighting_modifier);
		ram:add_unit(key, "wh2_dlc12_skv_inf_warplock_jezzails_0", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_inf_gutter_runners_0", 2*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_inf_gutter_runners_1", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_inf_gutter_runner_slingers_0", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_inf_gutter_runner_slingers_1", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_inf_death_globe_bombardiers", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_inf_poison_wind_globadiers", 1*weighting_modifier);
		ram:add_unit(key, "wh2_dlc14_skv_inf_poison_wind_mortar_0", 1*weighting_modifier);
		ram:add_unit(key, "wh2_dlc14_skv_inf_warp_grinder_0", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_mon_rat_ogres", 3*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_art_plagueclaw_catapult", 2*weighting_modifier);
		ram:add_unit(key, "wh2_dlc16_skv_mon_rat_ogre_mutant", 2*weighting_modifier);
		ram:add_unit(key, "wh2_dlc16_skv_mon_brood_horror_0", 2*weighting_modifier);
		
		local weighting_modifier = high_tier_modifier
		ram:add_unit(key, "wh2_main_skv_veh_doomwheel", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_mon_hell_pit_abomination", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_inf_death_runners_0", 2*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_inf_stormvermin_0", 6*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_inf_stormvermin_1", 3*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_inf_plague_monk_censer_bearer", 2*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_art_warp_lightning_cannon", 2*weighting_modifier);
		ram:add_unit(key, "wh2_dlc14_skv_inf_eshin_triads_0", 2*weighting_modifier);
		
	elseif template_key == "wh2_dlc09_sc_tmb_tomb_kings" then

		local weighting_modifier = low_tier_modifier
		ram:add_unit(key, "wh2_dlc09_tmb_inf_skeleton_warriors_0", 14*weighting_modifier);
		ram:add_unit(key, "wh2_dlc09_tmb_inf_skeleton_spearmen_0", 12*weighting_modifier);
		ram:add_unit(key, "wh2_dlc09_tmb_inf_skeleton_archers_0", 14*weighting_modifier);
		ram:add_unit(key, "wh2_dlc09_tmb_mon_carrion_0", 8*weighting_modifier);
		ram:add_unit(key, "wh2_dlc09_tmb_cav_skeleton_horsemen_0", 8*weighting_modifier);
		ram:add_unit(key, "wh2_dlc09_tmb_cav_skeleton_horsemen_archers_0", 6*weighting_modifier);
		
		local weighting_modifier = mid_tier_modifier
		ram:add_unit(key, "wh2_dlc09_tmb_inf_nehekhara_warriors_0", 5*weighting_modifier);
		ram:add_unit(key, "wh2_dlc09_tmb_cav_nehekhara_horsemen_0", 2*weighting_modifier);
		ram:add_unit(key, "wh2_dlc09_tmb_veh_skeleton_chariot_0", 2*weighting_modifier);
		ram:add_unit(key, "wh2_dlc09_tmb_veh_skeleton_archer_chariot_0", 3*weighting_modifier);
		ram:add_unit(key, "wh2_dlc09_tmb_mon_sepulchral_stalkers_0", 3*weighting_modifier);
		ram:add_unit(key, "wh2_dlc09_tmb_mon_ushabti_0", 4*weighting_modifier);
		ram:add_unit(key, "wh2_dlc09_tmb_mon_ushabti_1", 1*weighting_modifier)
		ram:add_unit(key, "wh2_dlc09_tmb_mon_tomb_scorpion_0", 2*weighting_modifier);
		ram:add_unit(key, "wh2_dlc09_tmb_art_screaming_skull_catapult_0", 2*weighting_modifier);
			
		local weighting_modifier = high_tier_modifier
		ram:add_unit(key, "wh2_dlc09_tmb_cav_necropolis_knights_0", 1*weighting_modifier);
		ram:add_unit(key, "wh2_dlc09_tmb_cav_necropolis_knights_1", 1*weighting_modifier);
		ram:add_unit(key, "wh2_dlc09_tmb_veh_khemrian_warsphinx_0", 1*weighting_modifier);
		ram:add_unit(key, "wh2_dlc09_tmb_inf_tomb_guard_0", 6*weighting_modifier);
		ram:add_unit(key, "wh2_dlc09_tmb_inf_tomb_guard_1", 3*weighting_modifier);
		ram:add_unit(key, "wh2_dlc09_tmb_mon_heirotitan_0", 1*weighting_modifier);
		ram:add_unit(key, "wh2_dlc09_tmb_mon_necrosphinx_0", 1*weighting_modifier);
		ram:add_unit(key, "wh2_pro06_tmb_mon_bone_giant_0", 2*weighting_modifier);
		ram:add_unit(key, "wh2_dlc09_tmb_art_casket_of_souls_0", 1*weighting_modifier);
		
		
	elseif template_key == "wh2_dlc11_sc_cst_vampire_coast" then
		local weighting_modifier = low_tier_modifier
		ram:add_unit(key, "wh2_dlc11_cst_inf_zombie_deckhands_mob_0", 20*weighting_modifier);
		ram:add_unit(key, "wh2_dlc11_cst_mon_fell_bats", 7*weighting_modifier);
		ram:add_unit(key, "wh2_dlc11_cst_inf_zombie_gunnery_mob_0", 10*weighting_modifier);	
		ram:add_unit(key, "wh2_dlc11_cst_mon_scurvy_dogs", 6*weighting_modifier);
				
		local weighting_modifier = mid_tier_modifier
		ram:add_unit(key, "wh2_dlc11_cst_inf_zombie_deckhands_mob_1", 10*weighting_modifier);
		ram:add_unit(key, "wh2_dlc11_cst_inf_zombie_gunnery_mob_1", 6*weighting_modifier);
		ram:add_unit(key, "wh2_dlc11_cst_inf_zombie_gunnery_mob_2", 1*weighting_modifier);
		ram:add_unit(key, "wh2_dlc11_cst_inf_zombie_gunnery_mob_3", 1*weighting_modifier);
		ram:add_unit(key, "wh2_dlc11_cst_art_mortar", 7*weighting_modifier);
		ram:add_unit(key, "wh2_dlc11_cst_art_carronade", 4*weighting_modifier);
		ram:add_unit(key, "wh2_dlc11_cst_inf_deck_gunners_0", 1*weighting_modifier);
		ram:add_unit(key, "wh2_dlc11_cst_inf_syreens", 3*weighting_modifier);
		ram:add_unit(key, "wh2_dlc11_cst_cav_deck_droppers_0", 5*weighting_modifier);
		ram:add_unit(key, "wh2_dlc11_cst_cav_deck_droppers_1", 1*weighting_modifier);
		ram:add_unit(key, "wh2_dlc11_cst_cav_deck_droppers_2", 1*weighting_modifier);
		ram:add_unit(key, "wh2_dlc11_cst_mon_mournguls_0", 2*weighting_modifier);
		ram:add_unit(key, "wh2_dlc11_cst_mon_bloated_corpse_0", 4*weighting_modifier);
		ram:add_unit(key, "wh2_dlc11_cst_mon_animated_hulks_0", 2*weighting_modifier);
		ram:add_unit(key, "wh2_dlc11_cst_mon_rotting_prometheans_0", 1*weighting_modifier);
		ram:add_unit(key, "wh2_dlc11_cst_mon_rotting_prometheans_gunnery_mob_0", 1*weighting_modifier);
		
		local weighting_modifier = high_tier_modifier
		ram:add_unit(key, "wh2_dlc11_cst_inf_depth_guard_0", 2*weighting_modifier);
		ram:add_unit(key, "wh2_dlc11_cst_inf_depth_guard_1", 2*weighting_modifier);
		ram:add_unit(key, "wh2_dlc11_cst_mon_terrorgheist", 1*weighting_modifier);
		ram:add_unit(key, "wh2_dlc11_cst_mon_rotting_leviathan_0", 1*weighting_modifier);
		ram:add_unit(key, "wh2_dlc11_cst_mon_necrofex_colossus_0", 1*weighting_modifier);

	elseif template_key == "wef_forest_spirits" then
		local weighting_modifier = low_tier_modifier
		ram:add_unit(key, "wh_dlc05_wef_inf_dryads_0", 20*weighting_modifier);
				
		local weighting_modifier = mid_tier_modifier
		ram:add_unit(key, "wh_dlc05_wef_inf_dryads_0", 10*weighting_modifier);
		ram:add_unit(key, "wh_dlc05_wef_mon_treekin_0", 10*weighting_modifier);
		ram:add_unit(key, "wh_dlc05_wef_mon_treeman_0", 1*weighting_modifier);
	
		local weighting_modifier = high_tier_modifier
		ram:add_unit(key, "wh_dlc05_wef_inf_dryads_0", 5*weighting_modifier);
		ram:add_unit(key, "wh_dlc05_wef_mon_treekin_0", 5*weighting_modifier);
		ram:add_unit(key, "wh_dlc05_wef_mon_treeman_0", 2*weighting_modifier);
	
	elseif template_key == "grn_spider_cult" then
		local weighting_modifier = low_tier_modifier
		ram:add_unit(key, "wh_dlc06_grn_mon_spider_hatchlings_0", 20*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_inf_goblin_spearmen", 20*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_cav_forest_goblin_spider_riders_0", 10*weighting_modifier);
				
		local weighting_modifier = mid_tier_modifier
		ram:add_unit(key, "wh_dlc06_grn_mon_spider_hatchlings_0", 5*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_inf_goblin_spearmen", 5*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_cav_forest_goblin_spider_riders_0", 4*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_cav_forest_goblin_spider_riders_1", 4*weighting_modifier);
	
		local weighting_modifier = high_tier_modifier
		ram:add_unit(key, "wh_dlc06_grn_mon_spider_hatchlings_0", 4*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_inf_goblin_spearmen", 2*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_cav_forest_goblin_spider_riders_0", 2*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_cav_forest_goblin_spider_riders_1", 2*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_mon_arachnarok_spider_0", 2*weighting_modifier);

	elseif template_key == "vmp_ghoul_horde" then
		local weighting_modifier = low_tier_modifier
		ram:add_unit(key, "wh_main_vmp_inf_crypt_ghouls", 20*weighting_modifier);
		ram:add_unit(key, "wh_main_vmp_mon_fell_bats", 4*weighting_modifier);
		ram:add_unit(key, "wh_main_vmp_mon_dire_wolves", 4*weighting_modifier);
		ram:add_unit(key, "wh_main_vmp_mon_crypt_horrors", 2*weighting_modifier);
				
		local weighting_modifier = mid_tier_modifier
		ram:add_unit(key, "wh_main_vmp_inf_crypt_ghouls", 4*weighting_modifier);
		ram:add_unit(key, "wh_main_vmp_mon_fell_bats", 2*weighting_modifier);
		ram:add_unit(key, "wh_main_vmp_mon_dire_wolves", 2*weighting_modifier);
		ram:add_unit(key, "wh_main_vmp_mon_crypt_horrors", 2*weighting_modifier);
		ram:add_unit(key, "wh_main_vmp_mon_vargheists", 2*weighting_modifier);
	
		local weighting_modifier = high_tier_modifier
		ram:add_unit(key, "wh_main_vmp_inf_crypt_ghouls", 4*weighting_modifier);
		ram:add_unit(key, "wh_main_vmp_mon_crypt_horrors", 4*weighting_modifier);
		ram:add_unit(key, "wh_main_vmp_mon_vargheists", 2*weighting_modifier);
		ram:add_unit(key, "wh_main_vmp_mon_varghulf", 2*weighting_modifier);
		ram:add_unit(key, "wh_main_vmp_mon_terrorgheist", 2*weighting_modifier);
	
	elseif template_key == "nor_fimir" then
		local weighting_modifier = low_tier_modifier
		ram:add_unit(key, "wh_main_nor_inf_chaos_marauders_0", 4*weighting_modifier);
		ram:add_unit(key, "wh_dlc08_nor_mon_fimir_0", 6*weighting_modifier);
		ram:add_unit(key, "wh_dlc08_nor_mon_fimir_1", 4*weighting_modifier);
		ram:add_unit(key, "wh_dlc08_nor_inf_marauder_hunters_0", 2*weighting_modifier);
		ram:add_unit(key, "wh_dlc08_nor_mon_warwolves_0", 2*weighting_modifier);
		
		local weighting_modifier = mid_tier_modifier
		ram:add_unit(key, "wh_dlc08_nor_mon_fimir_0", 4*weighting_modifier);
		ram:add_unit(key, "wh_dlc08_nor_mon_fimir_1", 4*weighting_modifier);
		ram:add_unit(key, "wh_dlc08_nor_cav_marauder_horsemasters_0", 2*weighting_modifier);
		ram:add_unit(key, "wh_dlc08_nor_inf_marauder_berserkers_0", 3*weighting_modifier);

		local weighting_modifier = high_tier_modifier
		ram:add_unit(key, "wh_dlc08_nor_mon_skinwolves_0", 2*weighting_modifier);
		ram:add_unit(key, "wh_dlc08_nor_mon_norscan_giant_0", 1*weighting_modifier);
		ram:add_unit(key, "wh_dlc08_nor_mon_fimir_0", 6*weighting_modifier);
		ram:add_unit(key, "wh_dlc08_nor_mon_fimir_1", 6*weighting_modifier);
		
	
	elseif template_key == "skv_moulder" then
		--
		local weighting_modifier = low_tier_modifier
		ram:add_unit(key, "wh2_main_skv_inf_skavenslaves_0", 2*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_inf_skavenslave_slingers_0", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_mon_rat_ogres", 3*weighting_modifier);
		ram:add_unit(key, "wh2_dlc16_skv_mon_wolf_rats_0", 3*weighting_modifier);
		ram:add_unit(key, "wh2_dlc16_skv_mon_wolf_rats_1", 3*weighting_modifier);
		
		local weighting_modifier = mid_tier_modifier
		ram:add_unit(key, "wh2_main_skv_inf_clanrats_1", 6*weighting_modifier);
		ram:add_unit(key, "wh2_dlc16_skv_mon_rat_ogre_mutant", 2*weighting_modifier);
		ram:add_unit(key, "wh2_dlc16_skv_mon_brood_horror_0", 2*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_mon_rat_ogres", 6*weighting_modifier);
		
		local weighting_modifier = high_tier_modifier
		ram:add_unit(key, "wh2_main_skv_mon_hell_pit_abomination", 2*weighting_modifier);


	elseif template_key == "skv_pestilens_and_rats" then
		--
		local weighting_modifier = low_tier_modifier
		ram:add_unit(key, "wh2_main_skv_inf_skavenslaves_0", 4*weighting_modifier);
		ram:add_unit(key, "wh2_dlc16_skv_mon_wolf_rats_0", 3*weighting_modifier);
		ram:add_unit(key, "wh2_dlc16_skv_mon_wolf_rats_1", 3*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_inf_plague_monks", 5*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_art_plagueclaw_catapult", 1*weighting_modifier);
	
		local weighting_modifier = mid_tier_modifier
		ram:add_unit(key, "wh2_main_skv_inf_plague_monks", 8*weighting_modifier);
		ram:add_unit(key, "wh2_dlc16_skv_mon_brood_horror_0", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_art_plagueclaw_catapult", 3*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_inf_plague_monk_censer_bearer", 2*weighting_modifier);

		
		local weighting_modifier = high_tier_modifier
		ram:add_unit(key, "wh2_dlc16_skv_mon_brood_horror_0", 3*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_inf_plague_monk_censer_bearer", 4*weighting_modifier);


	elseif template_key == "skv_skryre_drill_team" then
		--
		local weighting_modifier = low_tier_modifier
		ram:add_unit(key, "wh2_main_skv_inf_skavenslaves_0", 5*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_inf_skavenslave_spearmen_0", 5*weighting_modifier);
		ram:add_unit(key, "wh2_dlc14_skv_inf_warp_grinder_0",10*weighting_modifier);

		local weighting_modifier = mid_tier_modifier
		ram:add_unit(key, "wh2_main_skv_inf_clanrat_spearmen_1", 6*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_inf_clanrats_1", 6*weighting_modifier);
		ram:add_unit(key, "wh2_dlc12_skv_veh_doom_flayer_0", 2*weighting_modifier);
		ram:add_unit(key, "wh2_dlc12_skv_inf_ratling_gun_0", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_inf_warpfire_thrower", 2*weighting_modifier);
		ram:add_unit(key, "wh2_dlc12_skv_inf_warplock_jezzails_0", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_inf_death_globe_bombardiers", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_inf_poison_wind_globadiers", 1*weighting_modifier);
		ram:add_unit(key, "wh2_dlc14_skv_inf_poison_wind_mortar_0", 1*weighting_modifier);
		ram:add_unit(key, "wh2_dlc14_skv_inf_warp_grinder_0", 10*weighting_modifier);

		
		local weighting_modifier = high_tier_modifier
		ram:add_unit(key, "wh2_main_skv_veh_doomwheel", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_inf_stormvermin_0", 4*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_inf_stormvermin_1", 2*weighting_modifier);
		ram:add_unit(key, "wh2_main_skv_art_warp_lightning_cannon", 2*weighting_modifier);


	elseif template_key == "grn_greenskins_orcs_only" then
		--
		local weighting_modifier = low_tier_modifier	
		ram:add_unit(key, "wh_main_grn_inf_orc_boyz", 16*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_inf_orc_arrer_boyz", 6*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_cav_orc_boar_boyz", 3*weighting_modifier);

		
		local weighting_modifier = mid_tier_modifier

		ram:add_unit(key, "wh_main_grn_inf_orc_big_uns", 4*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_cav_orc_boar_boy_big_uns", 2*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_cav_orc_boar_chariot", 1*weighting_modifier);


		
		local weighting_modifier = high_tier_modifier
		ram:add_unit(key, "wh_main_grn_mon_giant", 1*weighting_modifier);
		ram:add_unit(key, "wh_main_grn_inf_black_orcs", 2*weighting_modifier);

	elseif template_key == "def_corsairs" then
		
		local weighting_modifier = low_tier_modifier
		ram:add_unit(key, "wh2_main_def_inf_dreadspears_0", 10*weighting_modifier);
		ram:add_unit(key, "wh2_main_def_inf_bleakswords_0", 12*weighting_modifier);
		ram:add_unit(key, "wh2_main_def_inf_harpies", 6*weighting_modifier);
		ram:add_unit(key, "wh2_main_def_inf_black_ark_corsairs_0", 4*weighting_modifier);
		ram:add_unit(key, "wh2_main_def_inf_black_ark_corsairs_1", 2*weighting_modifier)

		local weighting_modifier = mid_tier_modifier
		ram:add_unit(key, "wh2_main_def_inf_shades_0", 2*weighting_modifier);
		ram:add_unit(key, "wh2_main_def_inf_shades_1", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_def_inf_shades_2", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_def_art_reaper_bolt_thrower", 2*weighting_modifier);
		ram:add_unit(key, "wh2_main_def_inf_black_ark_corsairs_0", 8*weighting_modifier);
		ram:add_unit(key, "wh2_main_def_inf_black_ark_corsairs_1", 4*weighting_modifier)
		ram:add_unit(key, "wh2_dlc14_def_cav_scourgerunner_chariot_0", 1*weighting_modifier)

		local weighting_modifier = high_tier_modifier	
		ram:add_unit(key, "wh2_dlc10_def_mon_kharibdyss_0", 3*weighting_modifier);

	elseif template_key == "lzd_dino_rampage" then
		
		local weighting_modifier = low_tier_modifier
		ram:add_unit(key, "wh2_main_lzd_cav_cold_ones_feral_0", 6*weighting_modifier)
		ram:add_unit(key, "wh2_dlc12_lzd_mon_salamander_pack_0", 2*weighting_modifier);
		ram:add_unit(key, "wh2_dlc13_lzd_mon_razordon_pack_0", 2*weighting_modifier);
		
		local weighting_modifier = mid_tier_modifier
		ram:add_unit(key, "wh2_main_lzd_mon_bastiladon_0", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_mon_stegadon_0", 1*weighting_modifier);
		
		
		local weighting_modifier = high_tier_modifier
		ram:add_unit(key, "wh2_main_lzd_mon_carnosaur_0", 1*weighting_modifier);
		ram:add_unit(key, "wh2_dlc13_lzd_mon_dread_saurian_0", 1*weighting_modifier);
	
	elseif template_key == "lzd_sanctum_ambush" then
		local weighting_modifier = low_tier_modifier
		ram:add_unit(key, "wh2_main_lzd_inf_skink_cohort_0", 12*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_inf_saurus_spearmen_0", 12*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_inf_saurus_warriors_0", 12*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_inf_skink_cohort_1", 7*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_inf_skink_skirmishers_0", 6*weighting_modifier);

		local weighting_modifier = mid_tier_modifier
		ram:add_unit(key, "wh2_main_lzd_inf_saurus_warriors_1", 8*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_inf_saurus_spearmen_1", 8*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_cav_cold_ones_feral_0", 4*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_cav_cold_ones_1", 4*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_cav_horned_ones_0", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_cav_terradon_riders_0", 2*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_cav_terradon_riders_1", 2*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_inf_chameleon_skinks_0", 4*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_mon_bastiladon_0", 2*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_mon_stegadon_0", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_mon_kroxigors", 2*weighting_modifier);

		local weighting_modifier = high_tier_modifier
		ram:add_unit(key, "wh2_main_lzd_inf_temple_guards", 4*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_mon_bastiladon_1", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_mon_bastiladon_2", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_mon_stegadon_1", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_mon_ancient_stegadon", 1*weighting_modifier);
		ram:add_unit(key, "wh2_main_lzd_mon_carnosaur_0", 1*weighting_modifier);


	elseif template_key == "khorne_spawned_armies" then
		
		local weighting_modifier = low_tier_modifier
		ram:add_unit(key, "wh3_main_kho_inf_bloodletters_0", 30*weighting_modifier);
		ram:add_unit(key, "wh3_main_kho_inf_chaos_furies_0", 10*weighting_modifier);
		ram:add_unit(key, "wh3_main_kho_inf_flesh_hounds_of_khorne_0", 10*weighting_modifier);

		local weighting_modifier = mid_tier_modifier
		ram:add_unit(key, "wh3_main_kho_mon_spawn_of_khorne_0", 4*weighting_modifier);
		ram:add_unit(key, "wh3_main_kho_veh_skullcannon_0", 3*weighting_modifier);
		ram:add_unit(key, "wh3_main_kho_veh_blood_shrine_0", 3*weighting_modifier);
		ram:add_unit(key, "wh3_main_kho_inf_bloodletters_1", 10*weighting_modifier);

		local weighting_modifier = high_tier_modifier	
		ram:add_unit(key, "wh3_main_kho_mon_bloodthirster_0", 1*weighting_modifier);
		ram:add_unit(key, "wh3_main_kho_cav_bloodcrushers_0", 1*weighting_modifier);

	elseif template_key == "wh3_main_sc_ogr_ogre_kingdoms" then
		--
		local weighting_modifier = low_tier_modifier
		ram:add_unit(key, "wh3_main_ogr_inf_gnoblars_0", 10*weighting_modifier);
		ram:add_unit(key, "wh3_main_ogr_inf_gnoblars_1", 5*weighting_modifier);
		ram:add_unit(key, "wh3_main_ogr_inf_ogres_0", 5*weighting_modifier);

		local weighting_modifier = mid_tier_modifier
		ram:add_unit(key, "wh3_main_ogr_inf_ogres_1", 6*weighting_modifier);
		ram:add_unit(key, "wh3_main_ogr_inf_ogres_2", 6*weighting_modifier);
		ram:add_unit(key, "wh3_main_ogr_mon_sabretusk_pack_0", 2*weighting_modifier);
		ram:add_unit(key, "wh3_main_ogr_inf_leadbelchers_0", 1*weighting_modifier);
		ram:add_unit(key, "wh3_main_ogr_inf_maneaters_3", 2*weighting_modifier);
		ram:add_unit(key, "wh3_main_ogr_mon_gorgers_0", 1*weighting_modifier);
		ram:add_unit(key, "wh3_main_ogr_mon_giant_0", 1*weighting_modifier);
		ram:add_unit(key, "wh3_main_ogr_veh_gnoblar_scraplauncher_0", 1*weighting_modifier);
		ram:add_unit(key, "wh3_main_ogr_cav_mournfang_cavalry_2", 4*weighting_modifier);

		local weighting_modifier = high_tier_modifier
		ram:add_unit(key, "wh3_main_ogr_cav_crushers_1", 2*weighting_modifier);
		ram:add_unit(key, "wh3_main_ogr_inf_ironguts_0", 4*weighting_modifier);
		ram:add_unit(key, "wh3_main_ogr_inf_maneaters_3", 2*weighting_modifier);
		ram:add_unit(key, "wh3_main_ogr_mon_stonehorn_1", 1*weighting_modifier);


	elseif template_key == "wh3_main_sc_nur_nurgle" then
		local weighting_modifier = low_tier_modifier
		ram:add_unit(key, "wh3_main_nur_inf_plaguebearers_0", 12*weighting_modifier);
		ram:add_unit(key, "wh3_main_nur_inf_forsaken_0", 12*weighting_modifier);
		ram:add_unit(key, "wh3_main_nur_mon_plague_toads_0", 5*weighting_modifier);
		ram:add_unit(key, "wh3_main_nur_inf_chaos_furies_0", 7*weighting_modifier);
		ram:add_unit(key, "wh3_main_nur_inf_nurglings_0", 10*weighting_modifier);
		ram:add_unit(key, "wh3_main_nur_mon_beast_of_nurgle_0", 4*weighting_modifier);

		local weighting_modifier = mid_tier_modifier
		ram:add_unit(key, "wh3_main_nur_inf_plaguebearers_1", 5*weighting_modifier);
		ram:add_unit(key, "wh3_main_nur_mon_spawn_of_nurgle_0", 1*weighting_modifier);
		ram:add_unit(key, "wh3_main_nur_cav_pox_riders_of_nurgle_0", 2*weighting_modifier);
		ram:add_unit(key, "wh3_main_nur_mon_rot_flies_0", 1*weighting_modifier);
		ram:add_unit(key, "wh3_main_nur_cav_plague_drones_0", 2*weighting_modifier);
		ram:add_unit(key, "wh3_main_nur_cav_plague_drones_1", 1*weighting_modifier);
		
		local weighting_modifier = high_tier_modifier
		ram:add_unit(key, "wh3_main_nur_mon_soul_grinder_0", 1*weighting_modifier);
		ram:add_unit(key, "wh3_main_nur_mon_great_unclean_one_0", 1*weighting_modifier);


	elseif template_key == "wh3_main_sc_kho_khorne" then
		local weighting_modifier = low_tier_modifier
		ram:add_unit(key, "wh3_main_kho_inf_bloodletters_0", 12*weighting_modifier);
		ram:add_unit(key, "wh3_main_kho_inf_chaos_warriors_0", 12*weighting_modifier);
		ram:add_unit(key, "wh3_main_kho_inf_chaos_warhounds_0", 4*weighting_modifier);
		ram:add_unit(key, "wh3_main_kho_inf_chaos_furies_0", 7*weighting_modifier);

		local weighting_modifier = mid_tier_modifier
		ram:add_unit(key, "wh3_main_kho_inf_flesh_hounds_of_khorne_0", 1*weighting_modifier);
		ram:add_unit(key, "wh3_main_kho_mon_spawn_of_khorne_0", 1*weighting_modifier);
		ram:add_unit(key, "wh3_main_kho_inf_chaos_warriors_1", 3*weighting_modifier);
		ram:add_unit(key, "wh3_main_kho_inf_chaos_warriors_2", 3*weighting_modifier);
		ram:add_unit(key, "wh3_main_kho_inf_bloodletters_1", 2*weighting_modifier);
		ram:add_unit(key, "wh3_main_kho_veh_blood_shrine_0", 1*weighting_modifier);
		ram:add_unit(key, "wh3_main_kho_veh_skullcannon_0", 2*weighting_modifier);
		ram:add_unit(key, "wh3_main_kho_cav_gorebeast_chariot", 1*weighting_modifier);
		ram:add_unit(key, "wh3_main_kho_cav_bloodcrushers_0", 2*weighting_modifier);

		local weighting_modifier = high_tier_modifier
		ram:add_unit(key, "wh3_main_kho_mon_khornataurs_0", 2*weighting_modifier);
		ram:add_unit(key, "wh3_main_kho_cav_skullcrushers_0", 1*weighting_modifier);
		ram:add_unit(key, "wh3_main_kho_mon_khornataurs_1", 1*weighting_modifier);
		ram:add_unit(key, "wh3_main_kho_mon_bloodthirster_0", 1*weighting_modifier);
		ram:add_unit(key, "wh3_main_kho_mon_soul_grinder_0", 2*weighting_modifier);


	elseif template_key == "wh3_main_sc_tze_tzeentch" then
		local weighting_modifier = low_tier_modifier
		ram:add_unit(key, "wh3_main_tze_inf_blue_horrors_0", 12*weighting_modifier);
		ram:add_unit(key, "wh3_main_tze_inf_chaos_furies_0", 12*weighting_modifier);
		ram:add_unit(key, "wh3_main_tze_inf_pink_horrors_0", 10*weighting_modifier);
		ram:add_unit(key, "wh3_main_tze_mon_screamers_0", 8*weighting_modifier);

		local weighting_modifier = mid_tier_modifier
		ram:add_unit(key, "wh3_main_tze_inf_forsaken_0", 5*weighting_modifier);
		ram:add_unit(key, "wh3_main_tze_inf_pink_horrors_1", 3*weighting_modifier);
		ram:add_unit(key, "wh3_main_tze_mon_spawn_of_tzeentch_0", 1*weighting_modifier);
		ram:add_unit(key, "wh3_main_tze_mon_flamers_0", 3*weighting_modifier);
		ram:add_unit(key, "wh3_main_tze_cav_chaos_knights_0", 2*weighting_modifier);
		ram:add_unit(key, "wh3_main_tze_mon_exalted_flamer_0", 1*weighting_modifier);
		
		local weighting_modifier = high_tier_modifier
		ram:add_unit(key, "wh3_main_tze_cav_doom_knights_0", 1*weighting_modifier);
		ram:add_unit(key, "wh3_main_tze_veh_burning_chariot_0", 1*weighting_modifier);
		ram:add_unit(key, "wh3_main_tze_mon_lord_of_change_0", 2*weighting_modifier);
		ram:add_unit(key, "wh3_main_tze_mon_soul_grinder_0", 1*weighting_modifier);


	elseif template_key == "wh3_main_sc_sla_slaanesh" then
		local weighting_modifier = low_tier_modifier
		ram:add_unit(key, "wh3_main_sla_inf_daemonette_0", 16*weighting_modifier);
		ram:add_unit(key, "wh3_main_sla_inf_marauders_0", 12*weighting_modifier);
		ram:add_unit(key, "wh3_main_sla_inf_marauders_1", 10*weighting_modifier);
		ram:add_unit(key, "wh3_main_sla_inf_marauders_2", 7*weighting_modifier);
		ram:add_unit(key, "wh3_main_sla_cav_hellstriders_0", 4*weighting_modifier);
		ram:add_unit(key, "wh3_main_sla_inf_chaos_furies_0", 5*weighting_modifier);
		ram:add_unit(key, "wh3_main_sla_cav_hellstriders_1", 1*weighting_modifier);
		ram:add_unit(key, "wh3_main_sla_veh_seeker_chariot_0", 2*weighting_modifier);

		local weighting_modifier = mid_tier_modifier
		ram:add_unit(key, "wh3_main_sla_cav_seekers_of_slaanesh_0", 2*weighting_modifier);
		ram:add_unit(key, "wh3_main_sla_cav_heartseekers_of_slaanesh_0", 1*weighting_modifier);
		ram:add_unit(key, "wh3_main_sla_inf_daemonette_1", 4*weighting_modifier);
		ram:add_unit(key, "wh3_main_sla_mon_spawn_of_slaanesh_0", 1*weighting_modifier);
		ram:add_unit(key, "wh3_main_sla_veh_hellflayer_0", 1*weighting_modifier);
		ram:add_unit(key, "wh3_main_sla_veh_exalted_seeker_chariot_0", 1*weighting_modifier);
		ram:add_unit(key, "wh3_main_sla_mon_fiends_of_slaanesh_0", 1*weighting_modifier);
		
		local weighting_modifier = high_tier_modifier
		ram:add_unit(key, "wh3_main_sla_mon_keeper_of_secrets_0", 2*weighting_modifier);
		ram:add_unit(key, "wh3_main_sla_mon_soul_grinder_0", 1*weighting_modifier);


	else
		script_error("ERROR: generate_random_army() called but supplied template_key [" .. template_key .. "] is not supported");
		return false;
	end
	
	return ram:generate_force(key, num_units, generate_as_table);
end