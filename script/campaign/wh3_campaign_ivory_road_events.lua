
out.design("*** Ivory Road script loaded ***");


-- Data --


--Inital carvan forces

local rough_rider = {
	"wh3_main_cth_inf_peasant_archers_0",
	"wh3_main_cth_inf_peasant_archers_0",
	"wh3_main_cth_inf_peasant_spearmen_1",
	"wh3_main_cth_inf_peasant_spearmen_1",
	"wh3_main_cth_inf_jade_warriors_0",
	"wh3_main_cth_inf_jade_warriors_0",
	"wh3_main_cth_cav_jade_lancers_0",
	"wh3_main_cth_cav_jade_lancers_0",
	"wh3_main_cth_cav_jade_lancers_0",
	"wh3_main_cth_cav_jade_lancers_0"
	};
	
local inventor = {
	"wh3_main_cth_inf_peasant_archers_0",
	"wh3_main_cth_inf_peasant_archers_0",
	"wh3_main_cth_inf_peasant_spearmen_1",
	"wh3_main_cth_inf_peasant_spearmen_1",
	"wh3_main_cth_inf_peasant_spearmen_1",
	"wh3_main_cth_inf_jade_warriors_0",
	"wh3_main_cth_inf_jade_warriors_0",
	"wh3_main_cth_veh_sky_lantern_0",
	"wh3_main_cth_veh_sky_lantern_0"
	};
	
local clandestine = {
	"wh3_main_cth_inf_peasant_archers_0",
	"wh3_main_cth_inf_peasant_archers_0",
	"wh3_main_cth_inf_peasant_spearmen_1",
	"wh3_main_cth_inf_peasant_spearmen_1",
	"wh3_main_cth_inf_jade_warriors_0",
	"wh3_main_cth_inf_jade_warriors_0",
	"wh3_main_cth_inf_jade_warriors_1",
	"wh3_main_cth_inf_jade_warrior_crossbowmen_1",
	"wh3_main_cth_inf_jade_warrior_crossbowmen_1"
	};
	
local favoured = {
	"wh3_main_cth_inf_peasant_archers_0",
	"wh3_main_cth_inf_peasant_archers_0",
	"wh3_main_cth_inf_peasant_spearmen_1",
	"wh3_main_cth_inf_peasant_spearmen_1",
	"wh3_main_cth_inf_jade_warriors_1",
	"wh3_main_cth_inf_jade_warriors_1",
	"wh3_main_cth_inf_jade_warriors_0",
	"wh3_main_cth_inf_jade_warriors_0",
	"wh3_main_cth_inf_iron_hail_gunners_0",
	"wh3_main_cth_inf_iron_hail_gunners_0",
	"wh3_main_cth_cav_jade_lancers_0"
	};
	
local Dragon_Blooded = {
	"wh3_main_cth_inf_peasant_archers_0",
	"wh3_main_cth_inf_peasant_archers_0",
	"wh3_main_cth_inf_peasant_spearmen_1",
	"wh3_main_cth_inf_peasant_spearmen_1",
	"wh3_main_cth_inf_jade_warriors_1",
	"wh3_main_cth_inf_jade_warriors_1",
	"wh3_main_cth_inf_dragon_guard_0",
	"wh3_main_cth_inf_dragon_guard_crossbowmen_0"
	};
	
local Former_Artillery_Officer = {
	"wh3_main_cth_inf_peasant_archers_0",
	"wh3_main_cth_inf_peasant_archers_0",
	"wh3_main_cth_inf_peasant_spearmen_1",
	"wh3_main_cth_inf_peasant_spearmen_1",
	"wh3_main_cth_inf_jade_warriors_1",
	"wh3_main_cth_inf_jade_warriors_1",
	"wh3_main_cth_art_grand_cannon_0",
	"wh3_main_cth_art_grand_cannon_0"
	};
	
local Humble_Born = {
	"wh3_main_cth_inf_peasant_archers_0",
	"wh3_main_cth_inf_peasant_archers_0",
	"wh3_main_cth_inf_peasant_archers_0",
	"wh3_main_cth_inf_peasant_archers_0",
	"wh3_main_cth_inf_peasant_archers_0",
	"wh3_main_cth_inf_peasant_spearmen_1",
	"wh3_main_cth_inf_peasant_spearmen_1",
	"wh3_main_cth_inf_peasant_spearmen_1",
	"wh3_main_cth_inf_peasant_spearmen_1",
	"wh3_main_cth_inf_peasant_spearmen_1",
	"wh3_main_cth_inf_jade_warriors_1",
	"wh3_main_cth_inf_jade_warriors_1"
	};
	
local Longma_Whisperer = {
	"wh3_main_cth_inf_peasant_archers_0",
	"wh3_main_cth_inf_peasant_archers_0",
	"wh3_main_cth_inf_peasant_spearmen_1",
	"wh3_main_cth_inf_peasant_spearmen_1",
	"wh3_main_cth_inf_jade_warriors_1",
	"wh3_main_cth_inf_jade_warriors_1",
	"wh3_main_cth_cav_jade_longma_riders_0",
	"wh3_main_cth_cav_jade_longma_riders_0"
	
	};
	
local Nan_Gau = {
	"wh3_main_cth_inf_peasant_archers_0",
	"wh3_main_cth_inf_peasant_archers_0",
	"wh3_main_cth_inf_peasant_spearmen_1",
	"wh3_main_cth_inf_peasant_spearmen_1",
	"wh3_main_cth_inf_jade_warriors_1",
	"wh3_main_cth_inf_jade_warriors_1",
	"wh3_main_cth_inf_crane_gunners_0",
	"wh3_main_cth_inf_crane_gunners_0",
	"wh3_main_cth_art_fire_rain_rocket_battery_0"
	};
	
local Ogre_Ally = {
	"wh3_main_cth_inf_peasant_archers_0",
	"wh3_main_cth_inf_peasant_archers_0",
	"wh3_main_cth_inf_peasant_spearmen_1",
	"wh3_main_cth_inf_peasant_spearmen_1",
	"wh3_main_cth_inf_jade_warriors_1",
	"wh3_main_cth_inf_jade_warriors_1",
	"wh3_main_ogr_inf_maneaters_0",
	"wh3_main_ogr_inf_maneaters_1"
	
	};
	
local Shang_Yang = {
	"wh3_main_cth_cha_alchemist_0",
	"wh3_main_cth_inf_peasant_archers_0",
	"wh3_main_cth_inf_peasant_spearmen_1",
	"wh3_main_cth_inf_peasant_spearmen_1",
	"wh3_main_cth_inf_jade_warriors_1",
	"wh3_main_cth_inf_jade_warriors_1",
	"wh3_main_cth_inf_jade_warriors_1",
	"wh3_main_cth_inf_jade_warriors_1",
	"wh3_main_cth_inf_jade_warriors_0",
	"wh3_main_cth_inf_jade_warriors_0",
	"wh3_main_cth_inf_jade_warriors_0"
	};
	
local Western_Idealist = {
	"wh3_main_cth_inf_peasant_archers_0",
	"wh3_main_cth_inf_peasant_archers_0",
	"wh3_main_cth_inf_peasant_spearmen_1",
	"wh3_main_cth_inf_peasant_spearmen_1",
	"wh3_main_cth_inf_jade_warriors_1",
	"wh3_main_cth_inf_jade_warriors_1",
	"wh_main_emp_inf_halberdiers",
	"wh_main_emp_inf_halberdiers",
	"wh_main_emp_inf_handgunners",
	"wh_main_emp_inf_crossbowmen"
	};

local item_data = {}
local item_data_chaos = {
	["wh3_main_chaos_region_frozen_landing"]      = "wh3_main_anc_caravan_frost_wyrm_skull",
	["wh3_main_chaos_region_shattered_stone_bay"] = "wh3_main_anc_caravan_sky_titan_relic",
	["wh3_main_chaos_region_novchozy"]            = "wh3_main_anc_caravan_frozen_pendant",
	["wh3_main_chaos_region_erengrad"]            = "wh3_main_anc_caravan_gryphon_legion_lance",
	["wh3_main_chaos_region_castle_drakenhof"]    = "wh3_main_anc_caravan_von_carstein_blade",
	["wh3_main_chaos_region_altdorf"]             = "wh3_main_anc_caravan_luminark_lens",
	["wh3_main_chaos_region_marienburg"]          = "wh3_main_anc_caravan_warrant_of_trade",
	["wh3_main_chaos_region_zharr_naggrund"]      = "wh3_main_anc_caravan_statue_of_zharr",
	["wh3_main_chaos_region_ind"]                 = "wh3_main_anc_caravan_bejewelled_dagger",
	["wh3_main_chaos_region_tilea"]               = "wh3_main_anc_caravan_grant_of_land",
	["wh3_main_chaos_region_estalia"]             = "wh3_main_anc_caravan_spy_in_court"
}
local item_data_combi = {
	["wh3_main_combi_region_frozen_landing"]		= "wh3_main_anc_caravan_Frost_Wyrm_Skull",
	["wh3_main_combi_region_altdorf"]				= "wh3_main_anc_caravan_Luminark_Lens",
	["wh3_main_combi_region_marienburg"]			= "wh3_main_anc_caravan_Warrant_of_Trade",
	["wh3_main_combi_region_erengrad"]				= "wh3_main_anc_caravan_Gryphon_Legion_Lance",
	["wh3_main_combi_region_castle_drakenhof"]		= "wh3_main_anc_caravan_Von_Carstein_Blade",
	["wh3_main_combi_region_myrmidens"]				= "wh3_main_anc_caravan_Grant_of_Land",
	["wh3_main_combi_region_karaz_a_karak"]			= "wh3_main_anc_caravan_Statue_of_Zharr",
	["wh3_main_combi_region_estalia"]				= "wh3_main_anc_caravan_Spy_in_Court",
	["wh3_main_combi_region_Ind"]					= "wh3_main_anc_caravan_Bejewelled_Dagger",
	["wh3_main_combi_region_shattered_stone_bay"]	= "wh3_main_anc_caravan_Sky_Titan_Relic",
	["wh3_main_combi_region_novchozy"]				= "wh3_main_anc_caravan_Frozen_Pendant"
}

local region_to_incident = {}
local region_to_incident_chaos = {
	["wh3_main_chaos_region_altdorf"]				="wh3_main_cth_caravan_completed_altdorf",
	["wh3_main_chaos_region_castle_drakenhof"]		="wh3_main_cth_caravan_completed_castle_drakenhof",
	["wh3_main_chaos_region_erengrad"]				="wh3_main_cth_caravan_completed_erengrad",
	["wh3_main_chaos_region_estalia"]				="wh3_main_cth_caravan_completed_estalia",
	["wh3_main_chaos_region_frozen_landing"]		="wh3_main_cth_caravan_completed_frozen_landing",
	["wh3_main_chaos_region_Ind"]					="wh3_main_cth_caravan_completed_ind",
	["wh3_main_chaos_region_marienburg"]			="wh3_main_cth_caravan_completed_marienburg",
	["wh3_main_chaos_region_novchozy"]				="wh3_main_cth_caravan_completed_novchozy",
	["wh3_main_chaos_region_shattered_stone_bay"]	="wh3_main_cth_caravan_completed_stone_bay",
	["wh3_main_chaos_region_tilea"]					="wh3_main_cth_caravan_completed_tilea",
	["wh3_main_chaos_region_Zharr_naggrund"]		="wh3_main_cth_caravan_completed_zharr_nagrund"
}
local region_to_incident_combi = {
	["wh3_main_combi_region_frozen_landing"]		="wh3_main_cth_caravan_completed_frozen_landing",
	["wh3_main_combi_region_altdorf"]				="wh3_main_cth_caravan_completed_altdorf",
	["wh3_main_combi_region_marienburg"]			="wh3_main_cth_caravan_completed_marienburg",
	["wh3_main_combi_region_erengrad"]				="wh3_main_cth_caravan_completed_erengrad",
	["wh3_main_combi_region_castle_drakenhof"]		="wh3_main_cth_caravan_completed_castle_drakenhof",
	["wh3_main_combi_region_myrmidens"]				="wh3_main_cth_caravan_completed_tilea",
	["wh3_main_combi_region_karaz_a_karak"]			="wh3_main_cth_caravan_completed_zharr_nagrund",
	["wh3_main_combi_region_estalia"]				="wh3_main_cth_caravan_completed_estalia",
	["wh3_main_combi_region_Ind"]					="wh3_main_cth_caravan_completed_ind",
	["wh3_main_combi_region_shattered_stone_bay"]	="wh3_main_cth_caravan_completed_stone_bay",
	["wh3_main_combi_region_novchozy"]				="wh3_main_cth_caravan_completed_novchozy"
}

local region_reward_list = {}
local region_reward_list_chaos = {
	"wh3_main_chaos_region_estalia", 
	"wh3_main_chaos_region_Ind", 
	"wh3_main_chaos_region_tilea", 
	"wh3_main_chaos_region_Zharr_naggrund"
}
local region_reward_list_combi = {
	"wh3_main_combi_region_estalia", 
	"wh3_main_combi_region_Ind", 
	"wh3_main_combi_region_shattered_stone_bay",
	"wh3_main_combi_region_novchozy"
}

-- Ogre Bandit force A - low (5)
random_army_manager:new_force("ogre_bandit_low_a");
random_army_manager:add_mandatory_unit("ogre_bandit_low_a", "wh3_main_ogr_inf_ogres_0", 1);
random_army_manager:add_mandatory_unit("ogre_bandit_low_a", "wh3_main_ogr_inf_gnoblars_0", 2);
random_army_manager:add_mandatory_unit("ogre_bandit_low_a", "wh3_main_ogr_mon_sabretusk_pack_0", 1);

random_army_manager:add_unit("ogre_bandit_low_a", "wh3_main_ogr_inf_gnoblars_0", 1);
random_army_manager:add_unit("ogre_bandit_low_a", "wh3_main_ogr_mon_sabretusk_pack_0", 1);

-- Ogre Bandit force A - low (5)
random_army_manager:new_force("ogre_bandit_low_b");
random_army_manager:add_mandatory_unit("ogre_bandit_low_b", "wh3_main_ogr_inf_maneaters_0", 1);
random_army_manager:add_mandatory_unit("ogre_bandit_low_b", "wh3_main_ogr_inf_gnoblars_0", 2);

random_army_manager:add_unit("ogre_bandit_low_b", "wh3_main_ogr_inf_gnoblars_0", 1);
random_army_manager:add_unit("ogre_bandit_low_b", "wh3_main_ogr_mon_sabretusk_pack_0", 1);

-- Ogre Bandit force A - medium (8)
random_army_manager:new_force("ogre_bandit_med_a");
random_army_manager:add_mandatory_unit("ogre_bandit_med_a", "wh3_main_ogr_inf_ogres_0", 2);
random_army_manager:add_mandatory_unit("ogre_bandit_med_a", "wh3_main_ogr_inf_gnoblars_0", 3);
random_army_manager:add_mandatory_unit("ogre_bandit_med_a", "wh3_main_ogr_mon_sabretusk_pack_0", 1);
random_army_manager:add_mandatory_unit("ogre_bandit_med_a", "wh3_main_ogr_cav_mournfang_cavalry_0", 1);

random_army_manager:add_unit("ogre_bandit_med_a", "wh3_main_ogr_inf_gnoblars_0", 1);
random_army_manager:add_unit("ogre_bandit_med_a", "wh3_main_ogr_mon_sabretusk_pack_0", 1);

-- Ogre Bandit force B - medium (8)
random_army_manager:new_force("ogre_bandit_med_b");
random_army_manager:add_mandatory_unit("ogre_bandit_med_b", "wh3_main_ogr_inf_ogres_0", 2);
random_army_manager:add_mandatory_unit("ogre_bandit_med_b", "wh3_main_ogr_inf_gnoblars_0", 2);
random_army_manager:add_mandatory_unit("ogre_bandit_med_b", "wh3_main_ogr_inf_gnoblars_1", 2);
random_army_manager:add_mandatory_unit("ogre_bandit_med_b", "wh3_main_ogr_inf_leadbelchers_0", 1);

random_army_manager:add_unit("ogre_bandit_med_b", "wh3_main_ogr_inf_gnoblars_0", 1);
random_army_manager:add_unit("ogre_bandit_med_b", "wh3_main_ogr_mon_sabretusk_pack_0", 1);

-- Ogre Bandit force A - High (10)
random_army_manager:new_force("ogre_bandit_high_a");
random_army_manager:add_mandatory_unit("ogre_bandit_high_a", "wh3_main_ogr_cha_hunter_0", 1);
random_army_manager:add_mandatory_unit("ogre_bandit_high_a", "wh3_main_ogr_inf_ogres_0", 2);
random_army_manager:add_mandatory_unit("ogre_bandit_high_a", "wh3_main_ogr_inf_gnoblars_1", 3);
random_army_manager:add_mandatory_unit("ogre_bandit_high_a", "wh3_main_ogr_cav_mournfang_cavalry_0", 2);

random_army_manager:add_unit("ogre_bandit_high_a", "wh3_main_ogr_inf_gnoblars_0", 1);
random_army_manager:add_unit("ogre_bandit_high_a", "wh3_main_ogr_mon_sabretusk_pack_0", 1);

-- Ogre Bandit force B - High (10)
random_army_manager:new_force("ogre_bandit_high_b");
random_army_manager:add_mandatory_unit("ogre_bandit_high_b", "wh3_main_ogr_inf_maneaters_0", 1);
random_army_manager:add_mandatory_unit("ogre_bandit_high_b", "wh3_main_ogr_inf_ogres_0", 1);
random_army_manager:add_mandatory_unit("ogre_bandit_high_b", "wh3_main_ogr_inf_gnoblars_0", 2);
random_army_manager:add_mandatory_unit("ogre_bandit_high_b", "wh3_main_ogr_inf_gnoblars_1", 3);
random_army_manager:add_mandatory_unit("ogre_bandit_high_b", "wh3_main_ogr_veh_gnoblar_scraplauncher_0", 1);
random_army_manager:add_mandatory_unit("ogre_bandit_high_b", "wh3_main_ogr_inf_leadbelchers_0", 1);

random_army_manager:add_unit("ogre_bandit_high_b", "wh3_main_ogr_inf_gnoblars_0", 1);
random_army_manager:add_unit("ogre_bandit_high_b", "wh3_main_ogr_mon_sabretusk_pack_0", 1);

-- Daemon Army
random_army_manager:new_force("daemon_incursion");
random_army_manager:add_mandatory_unit("daemon_incursion", "wh3_main_kho_inf_bloodletters_0", 3);
random_army_manager:add_mandatory_unit("daemon_incursion", "wh3_main_kho_inf_chaos_warhounds_0", 4);
random_army_manager:add_mandatory_unit("daemon_incursion", "wh3_main_kho_cav_gorebeast_chariot", 1);

-- Greenskin force - low
random_army_manager:new_force("greenskin_low");
random_army_manager:add_mandatory_unit("greenskin_low", "wh_main_grn_cav_goblin_wolf_riders_0", 3);
random_army_manager:add_mandatory_unit("greenskin_low", "wh_main_grn_inf_goblin_spearmen", 4);
random_army_manager:add_mandatory_unit("greenskin_low", "wh_main_grn_mon_trolls", 1);

-- Greenskin force - Medium
random_army_manager:new_force("greenskin_medium");
random_army_manager:add_mandatory_unit("greenskin_medium", "wh_main_grn_cav_goblin_wolf_riders_0", 3);
random_army_manager:add_mandatory_unit("greenskin_medium", "wh_main_grn_inf_goblin_archers", 2);
random_army_manager:add_mandatory_unit("greenskin_medium", "wh_main_grn_inf_orc_boyz", 4);
random_army_manager:add_mandatory_unit("greenskin_medium", "wh_main_grn_cav_orc_boar_chariot", 2);

--Events

local event_table = {

	["banditExtort"] = 
	--returns its probability [1]
	{function(world_conditions)
		
		local bandit_threat = world_conditions["bandit_threat"];
		local probability = math.floor(bandit_threat/10) +3;
		
		local event_region = world_conditions["event_region"];
		local enemy_faction = event_region:owning_faction();
		
		local enemy_faction_name = enemy_faction:name();
		if enemy_faction_name == "rebels" then
			enemy_faction_name = "wh3_main_ogr_ogre_kingdoms_qb1";
		end
		
		local eventname = "banditExtort".."?"
			..event_region:name().."*"
			..enemy_faction_name.."*"
			..tostring(bandit_threat).."*";
		
		local caravan_faction = world_conditions["faction"];
		if enemy_faction:name() == caravan_faction:name() then
			probability = 0;
		end;
		
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,caravan_handle)
	
		out.design("banditExtort action called")
		local dilemma_name = "wh3_main_dilemma_cth_caravan_battle_1A";
		local caravan = caravan_handle;
		
		--Decode the string into arguments-- read_out_event_params explains encoding
		local decoded_args = read_out_event_params(event_conditions,3);
		
		local is_ambush = false;
		local target_faction = decoded_args[2];
		local enemy_faction;
		local target_region = decoded_args[1];
		local custom_option = nil;
		
		local bandit_threat = tonumber(decoded_args[3]);
	
		local attacking_force = generate_attackers(bandit_threat, "");
		
		local cargo_amount = caravan_handle:cargo();
		
		--Dilemma option to remove cargo
		function remove_cargo()
			cm:set_caravan_cargo(caravan_handle, cargo_amount - 200)
		end
		
		custom_option = remove_cargo;
		
		--Handles the custom options for the dilemmas, such as battles (only?)
		local enemy_cqi = attach_battle_to_dilemma(
												dilemma_name,
												caravan,
												attacking_force,
												is_ambush,
												target_faction,
												enemy_faction,
												target_region,
												custom_option
												);
		out.design(enemy_cqi);
		
		local target_faction_object = cm:get_faction(target_faction);
		
		--Trigger dilemma to be handled by above function
		local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
		local faction_key = caravan_handle:caravan_force():faction():name();
		
		local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
		local payload_builder = cm:create_payload();
		
		dilemma_builder:add_choice_payload("FIRST", payload_builder);
		payload_builder:clear();
		
		local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
		cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", -200);
		cargo_bundle:set_duration(0);
		
		payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);
		local own_faction = caravan_handle:caravan_force():faction();
		if target_faction_object:subculture()=="wh3_main_sc_ogr_ogre_kingdoms" and not target_faction_object:name() == "wh3_main_ogr_ogre_kingdoms_qb1" then
			--for anyone searching for diplomatic_attitude_adjustment: the int ranges from -6 -> 6, and selects a value set in the DC
			payload_builder:diplomatic_attitude_adjustment(target_faction_object, 6);
		else
			out.design("Use best ogre faction "..get_best_ogre_faction(own_faction:name()):name() )
			payload_builder:diplomatic_attitude_adjustment(get_best_ogre_faction(own_faction:name()), 6);
		end
		dilemma_builder:add_choice_payload("SECOND", payload_builder);
		
		dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
		dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
		
		out.design("Triggering dilemma:"..dilemma_name)
		cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
	end,
	true},
	
	["banditAmbush"] = 
	--returns its probability [1]
	{function(world_conditions)
	
		local bandit_threat = world_conditions["bandit_threat"];
		local event_region = world_conditions["event_region"];
		local enemy_faction = event_region:owning_faction();
	
		local enemy_faction_name = enemy_faction:name();
		if enemy_faction_name == "rebels" then
			enemy_faction_name = "wh3_main_ogr_ogre_kingdoms_qb1";
		end
		
		local eventname = "banditAmbush".."?"
			..event_region:name().."*"
			..enemy_faction_name.."*"
			..tostring(bandit_threat).."*";
		
		local probability = math.floor(bandit_threat/20) +3;
		
		local caravan_faction = world_conditions["faction"];
		if enemy_faction:name() == caravan_faction:name() then
			probability = 0;
		end;
		
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,caravan_handle)
		
		out.design("banditAmbush action called")
		local dilemma_name = "wh3_main_dilemma_cth_caravan_battle_2A";
		local caravan = caravan_handle;
		
		--Decode the string into arguments-- Need to specify the argument encoding
		local decoded_args = read_out_event_params(event_conditions,3);
		
		local is_ambush = true;
		local target_faction = decoded_args[2];
		local enemy_faction;
		local target_region = decoded_args[1];
		local custom_option;
		
		local bandit_threat = tonumber(decoded_args[3]);
		local attacking_force = generate_attackers(bandit_threat)
		
		
		--If anti ambush skill, then roll for detected event, if passed trigger event with battle
		-- else just ambush
		if caravan:caravan_master():character_details():has_skill("wh3_main_skill_cth_caravan_master_scouts") or cm:random_number(3,0) == 3 then
			local enemy_cqi = attach_battle_to_dilemma(
													dilemma_name,
													caravan,
													attacking_force,
													false,
													target_faction,
													enemy_faction,
													target_region,
													custom_option
													);
			
			--Trigger dilemma to be handled by aboove function
			local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
			local settlement_target = cm:get_region(target_region):settlement();
			
			out.design("Triggering dilemma:"..dilemma_name)
				
			--Trigger dilemma to be handled by above function
			local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
			local payload_builder = cm:create_payload();
			
			dilemma_builder:add_choice_payload("FIRST", payload_builder);

			payload_builder:treasury_adjustment(-1000);
			
			dilemma_builder:add_choice_payload("SECOND", payload_builder);
			
			dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
			dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
			
			out.design("Triggering dilemma:"..dilemma_name)
			cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
		else
			--Immidiately ambush
			--create_caravan_battle(caravan, attacking_force, target_region, true)
			spawn_caravan_battle_force(caravan, attacking_force, target_region, true, true);
		end;
	end,
	true},
	
	["banditHungryOgres"] = 
	--returns its probability [1]
	{function(world_conditions)
		
		local bandit_threat = world_conditions["bandit_threat"];
		local event_region = world_conditions["event_region"];
		local enemy_faction_name = event_region:owning_faction():name();
		
		if enemy_faction_name == "rebels" then
			enemy_faction_name = "wh3_main_ogr_ogre_kingdoms_qb1";
		end
		local enemy_faction = cm:get_faction(enemy_faction_name);
		
		local random_unit ="NONE";
		local caravan_force_unit_list = world_conditions["caravan"]:caravan_force():unit_list()
		
		if caravan_force_unit_list:num_items() > 1 then
			random_unit = caravan_force_unit_list:item_at(cm:random_number(caravan_force_unit_list:num_items()-1,1)):unit_key();
			
			if random_unit == "wh3_main_cth_cha_lord_caravan_master" or random_unit == "wh3_main_cth_cha_lord_magistrate_0" then
				random_unit = "NONE";
			end
			out.design("Random unit to be eaten: "..random_unit);
		end;
		
		--Construct targets
		local eventname = "banditHungryOgres".."?"
			..event_region:name().."*"
			..random_unit.."*"
			..tostring(bandit_threat).."*"
			..enemy_faction_name.."*";
			
		
		--Calculate probability
		local probability = 0;
		
		if random_unit == "NONE" then
			probability = 0;
		else
			probability = math.min(bandit_threat,10);
			
			if enemy_faction:subculture() == "wh3_main_sc_ogr_ogre_kingdoms" then
				probability = probability + 3;
			end
		end
		local caravan_faction = world_conditions["faction"];
		if enemy_faction:name() == caravan_faction:name() then
			probability = 0;
		end;
		
		return {probability,eventname}
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,caravan_handle)
		
		out.design("banditHungryOgres action called")
		local dilemma_name = "wh3_main_dilemma_cth_caravan_battle_3";
		local caravan = caravan_handle;
		
		--Decode the string into arguments-- Need to specify the argument encoding
		local decoded_args = read_out_event_params(event_conditions,3);
		
		local is_ambush = true;
		local target_faction = decoded_args[4];
		local enemy_faction;
		local target_region = decoded_args[1];
		local custom_option = nil;
		
		local random_unit = decoded_args[2];
		local bandit_threat = tonumber(decoded_args[3]);
		local attacking_force = generate_attackers(bandit_threat,"ogres")
		
		
		--Eat unit to option 2
		function eat_unit_outcome()
			if random_unit ~= nil then
				local caravan_master_lookup = cm:char_lookup_str(caravan:caravan_force():general_character():command_queue_index())
				cm:remove_unit_from_character(
				caravan_master_lookup,
				random_unit);

			else
				out("Script error - should have a unit to eat?")
			end
		end
		
		custom_option = nil; --eat_unit_outcome;
		
		--Battle to option 1, eat unit to 2
		local enemy_force_cqi = attach_battle_to_dilemma(
													dilemma_name,
													caravan,
													attacking_force,
													false,
													target_faction,
													enemy_faction,
													target_region,
													custom_option
													);
	
		--Trigger dilemma to be handled by above function
		
		local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
		local payload_builder = cm:create_payload();
		
		dilemma_builder:add_choice_payload("FIRST", payload_builder);
		
		local target_faction_object =  cm:get_faction(target_faction);
		local own_faction = caravan_handle:caravan_force():faction();
		if target_faction_object:subculture()=="wh3_main_sc_ogr_ogre_kingdoms" and not target_faction_object:name() == "wh3_main_ogr_ogre_kingdoms_qb1" then
			--for anyone searching for diplomatic_attitude_adjustment: the int ranges from -6 -> 6, and selects a value set in the DC
			payload_builder:diplomatic_attitude_adjustment(target_faction_object, 6);
		else
			out.design("Use best ogre faction "..get_best_ogre_faction(own_faction:name()):name() )
			payload_builder:diplomatic_attitude_adjustment(get_best_ogre_faction(own_faction:name()), 6);
		end
		payload_builder:remove_unit(caravan:caravan_force(), random_unit);
		dilemma_builder:add_choice_payload("SECOND", payload_builder);
		
		out.design("Triggering dilemma:"..dilemma_name)
		dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_force_cqi));
		
		dilemma_builder:add_target("target_military_1", caravan:caravan_force());
		
		cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
		
	end,
	true},
	
	["genericShortcut"] = 
	--returns its probability [1]
	{function(world_conditions)
		
		local eventname = "genericShortcut".."?";
		local probability = 2;
		
		local has_scouting = world_conditions["caravan_master"]:character_details():has_skill(
			"wh3_main_skill_cth_caravan_master_wheelwright");
		
		if has_scouting == true then
			probability = probability + 6
		end
		
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,caravan_handle)
		
		out.design("genericShortcut action called")
		local dilemma_list = {"wh3_main_dilemma_cth_caravan_1A", "wh3_main_dilemma_cth_caravan_1B"}
		local dilemma_name = dilemma_list[cm:random_number(2,1)];
		
		--Decode the string into arguments-- Need to specify the argument encoding
		--none to decode

		--Trigger dilemma to be handled by aboove function
		local faction_key = caravan_handle:caravan_force():faction():name();
		local force_cqi = caravan_handle:caravan_force():command_queue_index();
		
		function extra_move()
			--check if more than 1 move from the end
			out.design(force_cqi);
			cm:move_caravan(caravan_handle);
		end
		custom_option = extra_move;
		
		attach_battle_to_dilemma(
			dilemma_name,
			caravan_handle,
			nil,
			false,
			nil,
			nil,
			nil,
			custom_option);
		
		local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
		local payload_builder = cm:create_payload();
		
		local scout_skill = caravan_handle:caravan_master():character_details():character():bonus_values():scripted_value("caravan_scouting", "value");
		dilemma_builder:add_choice_payload("FIRST", payload_builder);
		payload_builder:clear();
		
		payload_builder:treasury_adjustment(math.floor(-500*((100+scout_skill)/100)));
		dilemma_builder:add_choice_payload("SECOND", payload_builder);
		
		dilemma_builder:add_target("default", caravan_handle:caravan_force());
		
		out.design("Triggering dilemma:"..dilemma_name)
		cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
		
	end,
	false},
	
	["genericCharacter"] = 
	--returns its probability [1]
	{function(world_conditions)
		
		local eventname = "genericCharacter".."?";
		
		local probability = 1;
		
		local caravan_force = world_conditions["caravan"]:caravan_force();
		local hero_list = {"wh3_main_ogr_cha_hunter_0","wh_main_emp_cha_captain_0","wh2_main_hef_cha_noble_0"}
		
		if not cm:military_force_contains_unit_type_from_list(caravan_force, hero_list) then
			out.design("No characters - increase probability")
			probability = 5;
		end
		
		local caravan_force_unit_list = world_conditions["caravan"]:caravan_force():unit_list()
		
		if caravan_force_unit_list:num_items() >= 19 then
			probability = 0;
		end
		
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,caravan_handle)
		
		out.design("genericCharacter action called")
		
		local AorB = {"A","B"};
		local choice = AorB[cm:random_number(#AorB,1)]
		
		local dilemma_name = "wh3_main_dilemma_cth_caravan_3"..choice;
		
		--Decode the string into arguments-- Need to specify the argument encoding
		--none to decode

		--Trigger dilemma to be handled by aboove function
		local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
		local force_cqi = caravan_handle:caravan_force():command_queue_index();
		local hero_list = {"wh3_main_ogr_cha_hunter_0","wh_main_emp_cha_captain_0","wh2_main_hef_cha_noble_0"};
		
		
		local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
		local payload_builder = cm:create_payload();
		
		dilemma_builder:add_choice_payload("FIRST", payload_builder);
		
		if choice == "B" then
			payload_builder:treasury_adjustment(-500);
		end
		payload_builder:add_unit(caravan_handle:caravan_force(), hero_list[cm:random_number(#hero_list,1)], 1, 0);
		dilemma_builder:add_choice_payload("SECOND", payload_builder);
		payload_builder:clear();
		
		dilemma_builder:add_target("default", caravan_handle:caravan_force());
		
		out.design("Triggering dilemma:"..dilemma_name)
		cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
		
	end,
	false},
	
	["genericCargoReplenish"] = 
	--returns its probability [1]
	{function(world_conditions)
		
		local eventname = "genericCargoReplenish".."?";
		local caravan_force = world_conditions["caravan"]:caravan_force();
		
		local probability = 4;
		
		if cm:military_force_average_strength(caravan_force) == 100 and world_conditions["caravan"]:cargo() >= 1000 then
			probability = 0
		end
		
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,caravan_handle)
		
		out.design("genericCargoReplenish action called")
		local dilemma_name = "wh3_main_dilemma_cth_caravan_2B";
		
		--Decode the string into arguments-- Need to specify the argument encoding
		--none to decode

		--Trigger dilemma to be handled by aboove function
		local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
		local force_cqi = caravan_handle:caravan_force():command_queue_index();
		
		function add_cargo()
			local cargo = caravan_handle:cargo();
			cm:set_caravan_cargo(caravan_handle, cargo+200)
		end
		custom_option = add_cargo;
		
		attach_battle_to_dilemma(
			dilemma_name,
			caravan_handle,
			nil,
			false,
			nil,
			nil,
			nil,
			custom_option);
			
		local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
		local payload_builder = cm:create_payload();
		
		local replenish = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2");
		replenish:add_effect("wh_main_effect_force_all_campaign_replenishment_rate", "force_to_force_own", 8);
		replenish:add_effect("wh_main_effect_force_army_campaign_enable_replenishment_in_foreign_territory", "force_to_force_own", 1);
		replenish:set_duration(2);
		
		payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), replenish);
		dilemma_builder:add_choice_payload("FIRST", payload_builder);
		payload_builder:clear();
		
		local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
		cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", 200);
		cargo_bundle:set_duration(0);
		
		payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);
		dilemma_builder:add_choice_payload("SECOND", payload_builder);
		
		dilemma_builder:add_target("default", caravan_handle:caravan_force());
		
		out.design("Triggering dilemma:"..dilemma_name)
		cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
		
	end,
	false},
	
	["recruitmentChoiceA"] = 
	--returns its probability [1]
	{function(world_conditions)
		
		local eventname = "recruitmentChoiceA".."?";
		local army_size = world_conditions["caravan"]:caravan_force():unit_list():num_items()
		
		local probability = math.floor((20 - army_size)/2);
		
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,caravan_handle)
		
		out.design("recruitmentChoiceA action called")
		local dilemma_name = "wh3_main_dilemma_cth_caravan_4A";
		
		--Decode the string into arguments-- Need to specify the argument encoding
		--none to decode
		
		attach_battle_to_dilemma(
					dilemma_name,
					caravan_handle,
					nil,
					false,
					nil,
					nil,
					nil,
					nil);
		
		local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
		local payload_builder = cm:create_payload();
		
		local ranged_list = {"wh3_main_cth_inf_jade_warrior_crossbowmen_0","wh3_main_cth_inf_jade_warrior_crossbowmen_1","wh3_main_cth_inf_peasant_archers_0","wh3_main_ksl_inf_streltsi_0"};
		local melee_list = {"wh3_main_cth_inf_jade_warriors_0","wh3_main_cth_inf_jade_warriors_1","wh3_main_cth_inf_peasant_spearmen_1"};
		
		payload_builder:add_unit(caravan_handle:caravan_force(), ranged_list[cm:random_number(#ranged_list,1)], 2, 0);
		dilemma_builder:add_choice_payload("FIRST", payload_builder);
		payload_builder:clear();
		
		payload_builder:add_unit(caravan_handle:caravan_force(), melee_list[cm:random_number(#melee_list,1)], 3, 0);
		dilemma_builder:add_choice_payload("SECOND", payload_builder);
		
		dilemma_builder:add_target("default", caravan_handle:caravan_force());
		
		out.design("Triggering dilemma:"..dilemma_name)
		cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
		
	end,
	false},
	
	["recruitmentChoiceB"] = 
	--returns its probability [1]
	{function(world_conditions)
		
		local eventname = "recruitmentChoiceB".."?";
		local army_size = world_conditions["caravan"]:caravan_force():unit_list():num_items()
		
		local probability = math.floor((20 - army_size)/2);
		
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,caravan_handle)
		
		out.design("recruitmentChoiceB action called")
		local dilemma_name = "wh3_main_dilemma_cth_caravan_4B";
		
		--Decode the string into arguments-- Need to specify the argument encoding
		--none to decode
		
		attach_battle_to_dilemma(
					dilemma_name,
					caravan_handle,
					nil,
					false,
					nil,
					nil,
					nil,
					nil);
		
		local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
		local payload_builder = cm:create_payload();
		
		local ranged_list = {"wh3_main_cth_inf_jade_warrior_crossbowmen_0","wh3_main_cth_inf_jade_warrior_crossbowmen_1","wh3_main_cth_inf_peasant_archers_0"};
		local melee_list = {"wh3_main_cth_inf_jade_warriors_0","wh3_main_cth_inf_jade_warriors_1","wh3_main_cth_inf_peasant_spearmen_1","wh3_main_ogr_inf_ogres_0"};
		
		payload_builder:add_unit(caravan_handle:caravan_force(), ranged_list[cm:random_number(#ranged_list,1)], 3, 0);
		dilemma_builder:add_choice_payload("SECOND", payload_builder);
		payload_builder:clear();
		
		payload_builder:add_unit(caravan_handle:caravan_force(), melee_list[cm:random_number(#melee_list,1)], 2, 0);
		dilemma_builder:add_choice_payload("FIRST", payload_builder);
		
		dilemma_builder:add_target("default", caravan_handle:caravan_force());
		
		out.design("Triggering dilemma:"..dilemma_name)
		cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
		
	end,
	false},
	
	["giftFromInd"] = 
	--returns its probability [1]
	{function(world_conditions)
		
		local eventname = "giftFromInd".."?";
		local turn_number = cm:turn_number();
		
		local probability = 1 + math.floor(turn_number / 100);
		
		if turn_number < 25 then
			probability = 0;
		end
		
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,caravan_handle)
		
		out.design("giftFromInd action called")
		local dilemma_name = "wh3_main_dilemma_cth_caravan_5";
		
		--Decode the string into arguments-- Need to specify the argument encoding
		--none to decode
		
		attach_battle_to_dilemma(
					dilemma_name,
					caravan_handle,
					nil,
					false,
					nil,
					nil,
					nil,
					nil);
		
		local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
		local payload_builder = cm:create_payload();
		
		--FIRST double cargo capacity and value, and additional cargo
		payload_builder:character_trait_change(caravan_handle:caravan_master():character_details():character(),"wh3_main_trait_blessed_by_ind_riches",false)
		
		local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
		cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", 1000);
		cargo_bundle:set_duration(0);
		payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);

		dilemma_builder:add_choice_payload("FIRST", payload_builder);
		payload_builder:clear();
		
		--SECOND trait and free units
		payload_builder:character_trait_change(caravan_handle:caravan_master():character_details():character(),"wh3_main_trait_blessed_by_ind_blades",false)
		local num_units = caravan_handle:caravan_force():unit_list():num_items()
		
		if num_units < 20 then
			payload_builder:add_unit(caravan_handle:caravan_force(), "wh3_main_cth_inf_dragon_guard_0", math.min(3, 20 - num_units), 9);
		end
		
		dilemma_builder:add_choice_payload("SECOND", payload_builder);
		
		dilemma_builder:add_target("default", caravan_handle:caravan_force());
		
		out.design("Triggering dilemma:"..dilemma_name)
		cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
		
	end,
	false},
	
	["daemonIncursion"] = 
	--returns its probability [1]
	{function(world_conditions)
		
		--Pick random unit
		local caravan_force_unit_list = world_conditions["caravan"]:caravan_force():unit_list()
		
		local random_unit ="NONE";
		if caravan_force_unit_list:num_items() > 1 then
			random_unit = caravan_force_unit_list:item_at(cm:random_number(caravan_force_unit_list:num_items()-1,0)):unit_key();
			
			if random_unit == "wh3_main_cth_cha_lord_caravan_master" then
				random_unit ="NONE";
			end
			out.design("Random unit to be killed: "..random_unit);
		end;
		
		local bandit_threat = world_conditions["bandit_threat"];
		local event_region = world_conditions["event_region"];
		
		--Construct targets
		local eventname = "daemonIncursion".."?"
			..event_region:name().."*"
			..random_unit.."*"
			..tostring(bandit_threat).."*";
			
		
		--Calculate probability
		local probability = 1 + math.floor(cm:model():turn_number() / 100);
		
		local turn_number = cm:turn_number();
		if turn_number < 25 then
			probability = 0;
		end
		
		return {probability,eventname}
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,caravan_handle)
		
		out.design("daemonIncursion action called")
		local dilemma_name = "wh3_main_dilemma_cth_caravan_battle_4";
		local caravan = caravan_handle;
		
		--Decode the string into arguments-- Need to specify the argument encoding
		local decoded_args = read_out_event_params(event_conditions,3);
		
		local is_ambush = true;
		local target_faction;
		local enemy_faction = "wh3_main_kho_khorne_qb1";
		local target_region = decoded_args[1];
		local custom_option = nil;
		
		local bandit_threat = tonumber(decoded_args[3]);
		local attacking_force = generate_attackers(bandit_threat,"daemon_incursion")
		
		
		--Battle to option 1, eat unit to 2
		local enemy_force_cqi = attach_battle_to_dilemma(
													dilemma_name,
													caravan,
													attacking_force,
													false,
													target_faction,
													enemy_faction,
													target_region,
													custom_option
													);
	
		--Trigger dilemma to be handled by above function
		local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
		local payload_builder = cm:create_payload();
		
		--Battle the daemons - need a custom trait for winning this
		payload_builder:character_trait_change(caravan_handle:caravan_master():character_details():character(),"wh3_main_trait_caravan_daemon_hunter",false)
		
		local daemon_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_daemon_hunter");
		daemon_bundle:add_effect("wh3_main_effect_attribute_enable_causes_fear_vs_dae","faction_to_force_own",1);
		daemon_bundle:set_duration(0);
		payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), daemon_bundle);
		
		dilemma_builder:add_choice_payload("FIRST", payload_builder);
		
		payload_builder:clear();
		
		--Lose soldiers - coward trait?
		local random_unit = decoded_args[2];
		payload_builder:remove_unit(caravan:caravan_force(), random_unit);
		dilemma_builder:add_choice_payload("SECOND", payload_builder);
		
		out.design("Triggering dilemma:"..dilemma_name)
		dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_force_cqi));
		dilemma_builder:add_target("target_military_1", caravan:caravan_force());
		
		cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
		
	end,
	true}
	
};


-- Logic --
--Setup
cm:add_first_tick_callback_new(
	function()
		recruit_starter_caravan();
		initalise_end_node_values();
		cm:set_script_state("caravan_camera_x",590);
		cm:set_script_state("caravan_camera_y",305);

		local all_factions = cm:model():world():faction_list();
		local faction = nil;
		for i=0, all_factions:num_items()-1 do
			faction = all_factions:item_at(i)
			if not faction:is_human() and faction:subculture() == "wh3_main_sc_cth_cathay" then
				cm:apply_effect_bundle("wh3_main_caravan_AI_threat_reduction", faction:name(),0)
			end
		end
	end
);

cm:add_first_tick_callback(
	function ()
		-- Setup event and region data for each campaign
		if cm:get_campaign_name() == "main_warhammer" then
			region_to_incident = region_to_incident_combi;
			item_data = item_data_combi;
			region_reward_list = region_reward_list_combi;
		elseif cm:get_campaign_name() == "wh3_main_chaos" then
			region_to_incident = region_to_incident_chaos;
			item_data = item_data_chaos;
			region_reward_list = region_reward_list_chaos;
		end
	end
);
--Listeners
core:add_listener(
	"caravan_waylay_query",
	"QueryShouldWaylayCaravan",
	function(context)
		return context:faction():is_human()
	end,
	function(context)
		out.design("Roll for Ivory Road Event");
		if ivory_road_event_handler(context) == false then
			out.design("Caravan not valid for event");
		end;
	end,
	true
);

core:add_listener(
	"caravan_waylaid",
	"CaravanWaylaid",
	true,
	function(context)
		out.design("Handle a waylaid caravan");
		waylaid_caravan_handler(context);
	end,
	true
);

core:add_listener(
	"add_inital_force",
	"CaravanRecruited",
	true,
	function(context)
		out.design("*** Caravan recruited ***");
		if context:caravan():caravan_force():unit_list():num_items() < 2 then
			local caravan = context:caravan();
			add_inital_force(caravan);
			cm:set_character_excluded_from_trespassing(context:caravan():caravan_master():character(), true)
		end;
	end,
	true
);

core:add_listener(
	"add_inital_bundles",
	"CaravanSpawned",
	true,
	function(context)
		out.design("*** Caravan deployed ***");
		local caravan = context:caravan();
		add_effectbundle(caravan);
		cm:set_saved_value("caravans_dispatched_" .. context:faction():name(), true);
	end,
	true
);

core:add_listener(
	"caravan_finished",
	"CaravanCompleted",
	true,
	function(context)
		-- store a total value of goods moved for this faction and then trigger an onwards event, narrative scripts use this
		local node = context:complete_position():node()
		local region_name = node:region_key()
		local region_owner = node:region_data():region():owning_faction();
		
		out.design("Caravan (player) arrived in: "..region_name)
		
		local faction = context:faction()
		local faction_key = faction:name();
		local prev_total_goods_moved = cm:get_saved_value("caravan_goods_moved_" .. faction_key) or 0;
		local num_caravans_completed = cm:get_saved_value("caravans_completed_" .. faction_key) or 0;
		cm:set_saved_value("caravan_goods_moved_" .. faction_key, prev_total_goods_moved + context:cargo());
		cm:set_saved_value("caravans_completed_" .. faction_key, num_caravans_completed + 1);
		core:trigger_event("ScriptEventCaravanCompleted", context);
		
		if faction:is_human() then
			reward_item_check(faction, region_name,	context:caravan_master())
		end
			
		if not region_owner:is_null_interface() then
			
			local region_owner_key = region_owner:name()
			out.design("Inserting a diplomatic event for caravan arriving. Factions: "..region_owner_key..", "..faction_key)
			cm:cai_insert_caravan_diplomatic_event(region_owner_key,faction_key)

			if region_owner:is_human() and faction_key ~= region_owner_key then
				cm:trigger_incident_with_targets(
					region_owner:command_queue_index(),
					"wh3_main_cth_caravan_completed_received",
					0,
					0,
					context:caravan_master():character():command_queue_index(),
					0,
					0,
					0
				)
			end
		
		end
		
		--Reduce demand
		local cargo = context:caravan():cargo()
		local value = math.floor(-cargo/18);
		out.design("Reduce "..region_name)
		
		cm:callback(function()adjust_end_node_value(region_name, value, "add") end, 5);
					
	end,
	true
);

core:add_listener(
	"caravans_increase_demand",
	"WorldStartRound",
	true,
	function(context)
		adjust_end_node_values_for_demand();
	end,
	true
);

core:add_listener(
	"caravan_master_heal",
	"CaravanMoved",
	function(context)
		return not context:caravan():is_null_interface();
	end,
	function(context)
		--Heal Lord
		local caravan_force_list = context:caravan_master():character():military_force():unit_list();
		local unit = nil;
		for i=0, caravan_force_list:num_items()-1 do
			unit = caravan_force_list:item_at(i);
			if unit:unit_key() == "wh3_main_cth_cha_lord_caravan_master" then
				cm:set_unit_hp_to_unary_of_maximum(unit, 1);
			end
		end
		--Spread out caravans
		local caravan_lookup = cm:char_lookup_str(context:caravan():caravan_force():general_character():command_queue_index())
		local x,y = cm:find_valid_spawn_location_for_character_from_character(
			context:faction():name(),
			caravan_lookup,
			true,
			cm:random_number(15,5)
			)
		cm:teleport_to(caravan_lookup,  x,  y);
	end,
	true
);

core:add_listener(
	"clean_up_attacker",
	"FactionTurnStart",
	function(context)
		return context:faction():name() == "wh3_main_ogr_ogre_kingdoms_qb1"
	end,
	function(context)
		cm:disable_event_feed_events(true, "", "", "diplomacy_faction_destroyed");

		cm:kill_all_armies_for_faction(context:faction());

		cm:callback(function() cm:disable_event_feed_events(false, "", "", "diplomacy_faction_destroyed") end, 0.2);
	end,
	true
);

core:add_listener(
	"unlock_retreat_caravan",
	"CharacterCompletedBattle",
	function(context)
		local character = context:character();
		local caravan_system = cm:model():world():caravans_system():faction_caravans(character:faction())
		
		if not caravan_system:is_null_interface() then
			local active_caravans = caravan_system:active_caravans()
			return not active_caravans:is_empty() and character:command_queue_index() == active_caravans:item_at(0):caravan_master():character():command_queue_index()
		end
	end,
	function(context)
		out.design("Move caravan from the generic listener")
		cm:move_caravan(cm:model():world():caravans_system():faction_caravans(context:character():faction()):active_caravans():item_at(0))
		
		uim:override("retreat"):unlock()
		out.design("Enable retreat button")
	end,
	true
);

core:add_listener(
	"reenable_event_feed_post_caravan_battle",
	"BattleCompleted",
	function()
		return cm:pending_battle_cache_faction_is_involved("wh3_main_ogr_ogre_kingdoms_qb1")
	end,
	function()
		cm:callback(
			function()
				cm:disable_event_feed_events(false, "", "", "diplomacy_war_declared")
				cm:disable_event_feed_events(false, "", "", "diplomacy_faction_destroyed")
				cm:disable_event_feed_events(false, "", "", "character_dies_battle")
			end,
			0.2
		)
	end,
	true
);

--Functions

function ivory_road_event_handler(context)
	
	--package up some world state
	--generate an event
	
	local caravan_master = context:caravan_master();
	local faction = context:faction();
	
	if context:from():is_null_interface() or context:to():is_null_interface() then
		return false
	end;
	
	local from_node = context:caravan():position():network():node_for_position(context:from());
	local to_node = context:caravan():position():network():node_for_position(context:to());
	
	local route_segment = context:caravan():position():network():segment_between_nodes(
	from_node, to_node);
	
	if route_segment:is_null_interface() then
		return false
	end
	
	local list_of_regions = route_segment:regions();
	
	local num_regions;
	local event_region;
	--pick a region from the route at random - don't crash the game if empty
	if list_of_regions:is_empty() ~= true then
		num_regions = list_of_regions:num_items()
		event_region = list_of_regions:item_at(cm:random_number(num_regions-1,0)):region();
	else
		out.design("*** No Regions in an Ivory Road segment - Need to fix data in DaVE: campaign_map_route_segments ***")
		out.design("*** Rest of this script will fail ***")
	end;
	
	local bandit_list_of_regions = {};
	
	--override region if one is at war
	for i = 0,num_regions-1 do
		out.design("iterate regions: "..i)
		table.insert(bandit_list_of_regions,list_of_regions:item_at(i):region():name())
		
		out.design("Bandit for region: ")
		out.design(cm:model():world():caravans_system():banditry_for_region_by_key(
		list_of_regions:item_at(i):region():name()))
		
		if list_of_regions:item_at(i):region():owning_faction():at_war_with(context:faction()) then
			event_region=list_of_regions:item_at(i):region()
		end;
	end
	
	
	local bandit_threat = math.floor( cm:model():world():caravans_system():total_banditry_for_regions_by_key(bandit_list_of_regions) / num_regions);
	out.design("Average bandit threat: "..tostring(bandit_threat));
	
	local conditions = {
		["caravan"]=context:caravan(),
		["caravan_master"]=caravan_master,
		["list_of_regions"]=list_of_regions,
		["event_region"]=event_region,
		["bandit_threat"]=bandit_threat,
		["faction"]=faction
		};
	
	out.design("Call generate event")
	local contextual_event, is_battle = generate_event(conditions);
	
	--if battle then waylay
	
	if is_battle == true and contextual_event ~= nil then
		out.design("Generated event "..contextual_event..". Waylay a caravan")
		context:flag_for_waylay(contextual_event);
	elseif is_battle == false and contextual_event ~= nil then
		out.design("Generated event "..contextual_event)
		context:flag_for_waylay(contextual_event);
		--needs to survive a save load at this point
	elseif is_battle == nil and contextual_event == nil then
		out.design("No caravan event this turn");
	end;
	
	
	
end


function generate_event(conditions)
	
	--look throught the events table and create a table for weighted roll
	--pick one and return the event name
	
	local weighted_random_list = {};
	local total_probability = 0;
	local i = 0;
	
	--build table for weighted roll
	for key, val in pairs(event_table) do
		
		i = i + 1;
		
		--Returns the probability of the event 
		local args = val[1](conditions)
		local prob = args[1];
		total_probability = prob + total_probability;
		--Returns the name and target of the event
		local name_args = args[2];
		
		--Returns if a battle is possible from this event
		--i.e. does it need to waylay
		local is_battle = val[3];
		
		out.design("Adding "..name_args.." with probability: "..prob)
		weighted_random_list[i] = {total_probability,name_args,is_battle}

	end
	
	--check all the probabilites until matched
	local no_event_chance = 25;
	local random_int = cm:random_number(total_probability + no_event_chance,1);
	local is_battle = nil;
	local contextual_event_name = nil;
	
	out.design("********")
	out.design("Caravan Event -> Random number: "..random_int.." out of: "..total_probability)
	out.design("********")
	for j=1,i do
		if weighted_random_list[j][1] >= random_int then
			
			--out.design(tostring(weighted_random_list[j][1]).." is greater than "..tostring(random_int))
			contextual_event_name = weighted_random_list[j][2];
			is_battle = weighted_random_list[j][3];
			break;
		end
	end
	
	if cm:tol_campaign_key() then
		contextual_event_name = nil;
	end;
	
	return contextual_event_name, is_battle
end;


function waylaid_caravan_handler(context)
	
	local event_name_formatted = context:context();
	local caravan_handle = context:caravan();
	
	out.design("Formatted string caught by handler: "..event_name_formatted);
	
	local event_key = read_out_event_key(event_name_formatted);
	out.design(tostring(event_key));
	
	--call the action side of the event
	event_table[event_key][2](event_name_formatted,caravan_handle);
	
end


function read_out_event_key(event_string)
	
	t = {}
	s = event_string          --format is "banditAttack?first*second*third*"
	for v in string.gmatch(s, "(%a+)?") do
		table.insert(t, v)
	end
	
	return(t[1])
end;

function read_out_event_params(event_string,num_args)
	
	local arg_table = {};
	
	local i = 0;
	for v in string.gmatch(event_string, "[_%w]+*") do
		i=i+1;
		
		local substring = v:sub(1, #v - 1)
		arg_table[i] = substring;
		
	end
	
	return(arg_table)
end;


function find_battle_coords_from_region(faction_key, region_key)
	
	local x,y = cm:find_valid_spawn_location_for_character_from_settlement(
		faction_key,
		region_key,
		false,
		true,
		20
		);
	
	if cm:get_campaign_name() == "wh3_main_chaos" then

		local no_spawn_list = build_list_of_nodes();
			
		if is_pair_in_list({x,y},no_spawn_list) then
			x,y = cm:find_valid_spawn_location_for_character_from_settlement(
				faction_key,
				region_key,
				false,
				true,
				30
				);
		end

	end
	
	return x,y
end

function spawn_caravan_battle_force(caravan, attacking_force, region, is_ambush, immediate_battle, optional_faction)

	out.design("Battle created");
	
	local enemy_faction = optional_faction or "wh3_main_ogr_ogre_kingdoms_qb1"
	local caravan_faction = caravan:caravan_force():faction();
	local enemy_force_cqi = 0;
	
	local x,y = find_battle_coords_from_region(caravan_faction:name(), region);
	
	--spawn enemy army
	--ideal solution is that the owner of the force are the regions rebel faction
	cm:create_force(
		enemy_faction,
		attacking_force,
		region,
		x,
		y,
		true,
		function(char_cqi,force_cqi)
			enemy_force_cqi = force_cqi;
			
			cm:disable_event_feed_events(true, "", "", "diplomacy_war_declared");
			cm:force_declare_war(enemy_faction, caravan_faction:name(), false, false);	
			cm:callback(function() cm:disable_event_feed_events(false, "", "", "diplomacy_war_declared") end, 0.2);
			cm:disable_movement_for_character(cm:char_lookup_str(char_cqi));
			cm:set_force_has_retreated_this_turn(cm:get_military_force_by_cqi(force_cqi));
		end
	);

	if immediate_battle == true then
		if cm:is_multiplayer() then
			create_caravan_battle(caravan, enemy_force_cqi, x, y, is_ambush)
		else
			cm:trigger_transient_intervention(
				"spawn_caravan_battle_force",
				function(inv)
					create_caravan_battle(caravan, enemy_force_cqi, x, y, is_ambush)
					inv:complete()
				end
			);
		end
	elseif immediate_battle == false then 
		return enemy_force_cqi, x, y
	end
end

function create_caravan_battle(caravan, enemy_force_cqi, x, y, is_ambush)
	out.design("Move armies for battle")
	local caravan_faction = caravan:caravan_force():faction();
	
	--find caravan army spawn
	--find move coords for caravan
	local caravan_x, caravan_y = cm:find_valid_spawn_location_for_character_from_position(
		caravan_faction:name(),
		x,
		y,
		false
	);
	
	local caravan_teleport_cqi = caravan:caravan_force():general_character():command_queue_index();
	local caravan_lookup = cm:char_lookup_str(caravan_teleport_cqi)
	out.design(caravan_lookup);
	
	--move the carvan here
	cm:teleport_to(caravan_lookup,  caravan_x,  caravan_y);
	
	out.design("Attack opportunity:");
	out.design("1 Passed CQI "..tostring(enemy_force_cqi));
	out.design("2 Passed CQI "..tostring(caravan:caravan_master():command_queue_index()));
	out.design("Ambush: "..tostring(is_ambush));
	
	--add callack to delete enemy force after battle
	local uim = cm:get_campaign_ui_manager();
	uim:override("retreat"):lock();
	out.design("Disable retreat button");
	
	--suppress events
	cm:disable_event_feed_events(true, "", "", "diplomacy_faction_destroyed");
	cm:disable_event_feed_events(true, "", "", "character_dies_battle");
	
	--attack of opportunity
	cm:force_attack_of_opportunity(
		enemy_force_cqi, 
		caravan:caravan_force():command_queue_index(),
		is_ambush
	);
end;


--Handles battles for dilemmas

function attach_battle_to_dilemma(
			dilemma_name,
			caravan,
			attacking_force,
			is_ambush,
			target_faction,
			enemy_faction,
			target_region,
			custom_option)
	
	--Create the enemy force
	local enemy_force_cqi = nil;
	local x = nil;
	local y = nil;
	
	if attacking_force ~= nil then
		out.design("Create enemy force")
		enemy_force_cqi, x, y = spawn_caravan_battle_force(caravan, attacking_force, target_region, is_ambush, false, enemy_faction)
	end
	
	function ivory_road_dilemma_choice(context)
		local dilemma = context:dilemma();
		local choice = context:choice();
		local faction = context:faction();
		local faction_key = faction:name();
		out.design("Caught a dilemma: "..dilemma);
		out.design("Choice made: "..tostring(choice));
		
		if dilemma == dilemma_name then
			--if battle option is chosen
			core:remove_listener("cth_DilemmaChoiceMadeEvent_"..faction_key);
			
			if choice == 0 and attacking_force ~= nil then
				create_caravan_battle(caravan, enemy_force_cqi, x, y, is_ambush);
				out.design("Battle option chosen in dilemma "..dilemma_name)
			end
			
			if custom_option ~= nil and choice == 1 then
				custom_option();
			end
			
			if choice ~= 0 then
				out.design("Complete the carvan move");
				cm:move_caravan(caravan);
			end;
			
			if choice == 0 and attacking_force == nil then
				out.design("Complete the carvan move");
				cm:move_caravan(caravan)
			end
			
		
		else
			out.design("Wrong dilemma...");
		end
	end
	
	local faction_key = caravan:caravan_master():character():faction():name()

	core:add_listener(
		"cth_DilemmaChoiceMadeEvent_"..faction_key,
		"DilemmaChoiceMadeEvent",
		true,
		function(context)
			ivory_road_dilemma_choice(context) 
		end,
		true
	);
	
	return enemy_force_cqi
end;

--Generate first so can be used as target
function generate_character()
	
	out.design("Generate a hero/agent + trait")
	--Pick a unit type
	local heroes = {"wizard","engineer"};
	local hero_pick = heroes[cm:random_number(#heroes,1)];
	
	--Pick a trait traits
	local traits = {"wh3_main_trait_dummy_caravan_ex_bandit","wh3_main_trait_dummy_caravan_con_artist","wh3_main_trait_dummy_caravan_soldier"};
	local trait_pick = traits[cm:random_number(#traits,1)];
	
	
	return hero_pick, trait_pick;
end

function add_character_to_caravan(caravan, hero_pick, trait_pick)
	
	out.design("Attempt to spawn and embed hero/agent")
	
	local force = caravan:caravan_force();
	local faction = caravan:caravan_force():faction();
	
	local x = force:general_character():logical_position_x() + 1;
	local y = force:general_character():logical_position_y() + 1;
	
	local agent = cm.game_interface:spawn_agent_at_position(faction, x, y, hero_pick);
	
	if not agent:is_null_interface() then
		out.design("agent = "..tostring(agent));
		CampaignUI.ClearSelection();
		
		out.design("attempt to embed agent with this cqi "..tostring(agent:cqi()));
		
		cm:embed_agent_in_force(agent, force);
			
		local lookup_str = cm:char_lookup_str(agent:command_queue_index());
		cm:force_add_trait(lookup_str, trait_pick,1);
		
		out.design("Spawned and embedded hero/agent");
	else
	out.design("Error: Agent did not spawn");
	end
end;

--[[
function initalise_bandity()

	--only fire for a new game

	--get network handled
	cm:world()
	
	--loop over regions and add small bandity randomly
	cm:random
	cm:set_region_caravan_banditry(REGION_DATA_SCRIPT_INTERFACE region, int value);
end

]]

function add_inital_force(caravan)
	
	out.design("Try to add inital force to caravan, based on trait")
	
	local force_cqi = caravan:caravan_force():command_queue_index();
	local lord_cqi = caravan:caravan_force():general_character():command_queue_index();
	local lord_str = cm:char_lookup_str(lord_cqi);
	
	if caravan:caravan_master():character_details():has_skill("wh3_main_skill_innate_cth_caravan_master_cavalry") then
		for i=1, #rough_rider do
			cm:grant_unit_to_character(lord_str, rough_rider[i]);
		end
		--fully heal when returning
	elseif caravan:caravan_master():character_details():has_skill("wh3_main_skill_innate_cth_caravan_master_gunner") then
		for i=1, #inventor do
			cm:grant_unit_to_character(lord_str, inventor[i]);
		end
	elseif caravan:caravan_master():character_details():has_skill("wh3_main_skill_innate_cth_caravan_master_royalty") then
		for i=1, #favoured do
			cm:grant_unit_to_character(lord_str, favoured[i]); --should have xp/t innate skill
		end
	elseif caravan:caravan_master():character_details():has_skill("wh3_main_skill_innate_cth_caravan_master_stealth") then
		for i=1, #clandestine do
			cm:grant_unit_to_character(lord_str, clandestine[i]);
		end
		cm:add_experience_to_units_commanded_by_character(lord_str, 4)
	elseif caravan:caravan_master():character_details():has_skill("wh3_main_skill_innate_cth_caravan_master_Dragon-Blooded") then
		for i=1, #Dragon_Blooded do
			cm:grant_unit_to_character(lord_str, Dragon_Blooded[i]);
		end
	elseif caravan:caravan_master():character_details():has_skill("wh3_main_skill_innate_cth_caravan_master_Former-Artillery-Officer") then
		for i=1, #Former_Artillery_Officer do
			cm:grant_unit_to_character(lord_str, Former_Artillery_Officer[i]);
		end
	elseif caravan:caravan_master():character_details():has_skill("wh3_main_skill_innate_cth_caravan_master_Humble-Born") then
		for i=1, #Humble_Born do
			cm:grant_unit_to_character(lord_str, Humble_Born[i]);
		end
	elseif caravan:caravan_master():character_details():has_skill("wh3_main_skill_innate_cth_caravan_master_Longma-Whisperer") then
		for i=1, #Longma_Whisperer do
			cm:grant_unit_to_character(lord_str, Longma_Whisperer[i]);
		end
	elseif caravan:caravan_master():character_details():has_skill("wh3_main_skill_innate_cth_caravan_master_Nan-Gau") then
		for i=1, #Nan_Gau do
			cm:grant_unit_to_character(lord_str, Nan_Gau[i]);
		end
	elseif caravan:caravan_master():character_details():has_skill("wh3_main_skill_innate_cth_caravan_master_Ogre-Ally") then
		for i=1, #Ogre_Ally do
			cm:grant_unit_to_character(lord_str, Ogre_Ally[i]);
		end
	elseif caravan:caravan_master():character_details():has_skill("wh3_main_skill_innate_cth_caravan_master_Shang-Yang") then
		for i=1, #Shang_Yang do
			cm:grant_unit_to_character(lord_str, Shang_Yang[i]);
		end
	elseif caravan:caravan_master():character_details():has_skill("wh3_main_skill_innate_cth_caravan_master_Western-Idealist") then
		for i=1, #Western_Idealist do
			cm:grant_unit_to_character(lord_str, Western_Idealist[i]);
		end
	else
		out("*** Unknown Caravan Master ??? ***")
	end
end


function add_effectbundle(caravan)
	--local force_cqi = caravan:caravan_force():command_queue_index();
	local caravan_master_lookup = cm:char_lookup_str(caravan:caravan_force():general_character():command_queue_index())
	
	cm:force_character_force_into_stance(caravan_master_lookup, "MILITARY_FORCE_ACTIVE_STANCE_TYPE_FIXED_CAMP")
	--cm:apply_effect_bundle_to_character("wh3_main_caravan_post_battle_loot_bonus_bundle",caravan:caravan_force():general_character(),-1)
end;

function recruit_starter_caravan()
	out.design("Recruit a starter caravan");
	local model = cm:model();
	local faction_list = model:world():faction_list();
	for i=0, faction_list:num_items()-1 do
		local faction = faction_list:item_at(i)
		if faction:is_human() and faction:subculture() == "wh3_main_sc_cth_cathay" then
			
			out.design("Passed tests")
			out.design(faction:name())
			
			local available_caravans = 
				model:world():caravans_system():faction_caravans(faction):available_caravan_recruitment_items();
			
			if available_caravans:is_empty() then
				out.design("No caravans in the pool! Needs one at this point to start the player with one")
			else
				local temp_caravan = available_caravans:item_at(0);
				if temp_caravan:is_null_interface() then
					out.design("***Caravan is null interface***")
					break
				end
				--[[
				core:add_listener(
					"starter_caravan_skills_"..tostring(faction:name()),
					"CaravanRecruited",
					function(context)
						return context:faction():name() == faction:name();
					end,
					function(context)
						out.design("*** Starter Caravan skill swap ***");
						local fm_cqi = "family_member_cqi:".. context:caravan_master():command_queue_index();
						cm:remove_all_background_skills(fm_cqi);
						campaign_manager:force_add_skill(fm_cqi,"wh3_main_skill_innate_cth_caravan_master_starter");
					end,
					false
				);
				]]
				--Recruit the caravan
				out.design("Try and recruit")
				local starter_caravan = cm:recruit_caravan(faction, temp_caravan);
				CampaignUI.ClearSelection();
				break;
			end;
		end;
	end;
	
end;

function initalise_end_node_values()

	--randomise the end node values
	local end_nodes = {}

			if cm:get_campaign_name() == "main_warhammer" then
				end_nodes = {
					["wh3_main_combi_region_frozen_landing"]		=75-cm:random_number(50,0),
					["wh3_main_combi_region_myrmidens"]				=75-cm:random_number(50,0),
					["wh3_main_combi_region_erengrad"]				=75-cm:random_number(50,0),
					["wh3_main_combi_region_karaz_a_karak"]			=cm:random_number(150,60),
					["wh3_main_combi_region_castle_drakenhof"]		=cm:random_number(150,60),
					["wh3_main_combi_region_altdorf"]				=cm:random_number(150,60),
					["wh3_main_combi_region_marienburg"]			=cm:random_number(150,60)
				};
			elseif cm:get_campaign_name() == "wh3_main_chaos" then
				end_nodes = {
					["wh3_main_chaos_region_frozen_landing"]		=75-cm:random_number(50,0),
					["wh3_main_chaos_region_shattered_stone_bay"]	=75-cm:random_number(50,0),
					["wh3_main_chaos_region_novchozy"]				=75-cm:random_number(50,0),
					["wh3_main_chaos_region_erengrad"]				=cm:random_number(150,60),
					["wh3_main_chaos_region_castle_drakenhof"]		=cm:random_number(150,60),
					["wh3_main_chaos_region_altdorf"]				=cm:random_number(150,60),
					["wh3_main_chaos_region_marienburg"]			=cm:random_number(150,60)
				};
			end
	
	--save them
	cm:set_saved_value("ivory_road_demand", end_nodes);
	local temp_end_nodes = safe_get_saved_value_ivory_road_demand()
	
	--apply the effect bundles
	for key, val in pairs(temp_end_nodes) do
		out.design("Key: "..key.." and value: "..val)
		adjust_end_node_value(key, val, "replace")
	end
end

function adjust_end_node_values_for_demand()
	local temp_end_nodes = safe_get_saved_value_ivory_road_demand()
	
	for key, val in pairs(temp_end_nodes) do
		out.design("Key: "..key.." and value: "..val.." for passive demand increase.")
		adjust_end_node_value(key, 2, "add")
	end
end


function adjust_end_node_value(region_name, value, operation)
	
	local region = cm:get_region(region_name);
	local cargo_value_bundle = cm:create_new_custom_effect_bundle("wh3_main_ivory_road_end_node_value");
	cargo_value_bundle:set_duration(0);
	
	if operation == "replace" then
		local temp_end_nodes = safe_get_saved_value_ivory_road_demand()
		cargo_value_bundle:add_effect("wh3_main_effect_caravan_cargo_value_regions", "region_to_region_own", value);
		
		temp_end_nodes[region_name]=value;
		cm:set_saved_value("ivory_road_demand", temp_end_nodes);
		out.design("Change trade to "..value.." demand for caravans in "..region_name)
		
	elseif operation == "add" then
		local temp_end_nodes = safe_get_saved_value_ivory_road_demand()
		local old_value = temp_end_nodes[region_name];
		
		if old_value == nil then
			out.design("*******   Error in ivory road script    *********")
			return 0;
		end
		
		local new_value = math.min(old_value+value,200)
		new_value = math.max(old_value+value,-60)
		
		out.design("new value is "..new_value)
		cargo_value_bundle:add_effect("wh3_main_effect_caravan_cargo_value_regions", "region_to_region_own", new_value);
		
		temp_end_nodes[region_name]=new_value;
		cm:set_saved_value("ivory_road_demand", temp_end_nodes);
		out.design("Change trade to "..new_value.." demand for caravans in "..region_name)
	end
	
	if region:has_effect_bundle("wh3_main_ivory_road_end_node_value") then
		cm:remove_effect_bundle_from_region("wh3_main_ivory_road_end_node_value", region_name);
	end;
	
	cm:apply_custom_effect_bundle_to_region(cargo_value_bundle,region);
end

function safe_get_saved_value_ivory_road_demand()
	
	local ivory_road_demand = cm:get_saved_value("ivory_road_demand");
	
	if ivory_road_demand ~= nil then
		return ivory_road_demand
	else
		initalise_end_node_values()
		ivory_road_demand = cm:get_saved_value("ivory_road_demand");
		if ivory_road_demand ~= nil then
			return ivory_road_demand
		else
			script_error("Cannot load the caravan supply/demand list")
		end
	end
end

function generate_attackers(bandit_threat, force_name)
	
	local difficulty = cm:get_difficulty(false);
	local turn_number = cm:turn_number();
	
	out.design("Generate caravan attackers for banditry: "..bandit_threat)
	
	if force_name == "daemon_incursion" then
		return random_army_manager:generate_force(force_name, 5, false);
	end
	
	if force_name == "critters" then
		return random_army_manager:generate_force(force_name, 5, false);
	end
	
	if bandit_threat < 50 then
			force_name = {"ogre_bandit_low_a","ogre_bandit_low_b"}
			return random_army_manager:generate_force(force_name[cm:random_number(#force_name,1)], 5, false);
		elseif bandit_threat >= 50 and bandit_threat < 70 then
			force_name = {"ogre_bandit_med_a","ogre_bandit_med_b"}
			return random_army_manager:generate_force(force_name[cm:random_number(#force_name,1)], 8, false);
		elseif bandit_threat >= 70 then
			force_name = {"ogre_bandit_high_a","ogre_bandit_high_b"}
			return random_army_manager:generate_force(force_name[cm:random_number(#force_name,1)], 10, false);
	end
	--[[
	if bandit_threat < 50 then
		force_name = {"ogre_bandit_low_a","ogre_bandit_low_b","greenskin_low"}
		return random_army_manager:generate_force(force_name[cm:random_number(#force_name,1)], 5, false);
	elseif bandit_threat >= 50 and bandit_threat < 70 then
		force_name = {"ogre_bandit_med_a","ogre_bandit_med_b","greenskin_medium"}
		return random_army_manager:generate_force(force_name[cm:random_number(#force_name,1)], 8, false);
	elseif bandit_threat >= 70 then
		force_name = {"ogre_bandit_high_a","ogre_bandit_high_b"}
		return random_army_manager:generate_force(force_name[cm:random_number(#force_name,1)], 10, false);
	end
	]]
end

function is_pair_in_list(pair, list)
	for i,v in ipairs(list) do
		if (v[1] == pair[1] and v[2] == pair[2]) then
			return true
		end
	end
	return false
end

function build_list_of_nodes()
	
	local teleporter = cm:model():world():teleportation_network_system():lookup_network("wh3_main_teleportation_network_chaos");
	
	local open_nodes = teleporter:open_nodes()
	local closed_nodes = teleporter:closed_nodes()
	
	all_nodes = {}
	local n = 0
	local x,y;
	
	for i=0, closed_nodes:num_items()-1 do n=n+1; x,y = closed_nodes:item_at(i):position(); all_nodes[n]={x,y}; end
	for i=0,   open_nodes:num_items()-1 do n=n+1; x,y =   open_nodes:item_at(i):position(); all_nodes[n]={x,y}; end

	
	return all_nodes
end

function reward_item_check(faction,region_key,caravan_master)
	
	local reward = item_data[region_key]
	
	if not faction:ancillary_exists(reward) then
		
		cm:trigger_incident_with_targets(
			faction:command_queue_index(),
			region_to_incident[region_key],
			0,
			0,
			caravan_master:character():command_queue_index(),
			0,
			0,
			0
			)
		
		return 0
	end
	
	if cm:random_number(10,1) == 1 then
		return reward_item_check(faction,region_reward_list[cm:random_number(#region_reward_list,1)],caravan_master)
	end
end

function get_random_ogre_faction()
	local factions = cm:model():world():faction_list();
	local faction = nil;
	
	out.design("call get_random_ogre_faction()")
	if not factions:is_empty() then
		out.design("list is not empty")
		for i=0, factions:num_items() -1 do
			faction = factions:item_at(i);
			if faction:subculture()=="wh3_main_sc_ogr_ogre_kingdoms" and faction:name()~="wh3_main_ogr_ogre_kingdoms_qb1" then
				return faction
			end
		end
	end
	
	return false
end

function get_best_ogre_faction(self_faction)
	local factions = cm:get_faction(self_faction):factions_met(); --cm:model():world():faction_list();
	local faction = nil;
	
	local high_score = -500;
	local high_score_faction = nil;
	local max_score = 200
	
	out.design("call get_best_ogre_faction()")
	if not factions:is_empty() then
		for i=0, factions:num_items() -1 do
			faction = factions:item_at(i);
			if faction:subculture()=="wh3_main_sc_ogr_ogre_kingdoms" and faction:name()~="wh3_main_ogr_ogre_kingdoms_qb1" then
				if faction:diplomatic_standing_with(self_faction) > high_score and faction:diplomatic_standing_with(self_faction) <= max_score then
					high_score = faction:diplomatic_standing_with(self_faction);
					high_score_faction = faction;
				end
			end
		end
	end
	return high_score_faction
end

--Test Harmony

core:add_listener(
	"harmony_character_on_map",
	"CharacterRecruited",
	function(context)
		local faction = context:character():faction();
		return faction:is_human() and faction:subculture() == "wh3_main_sc_cth_cathay"
	end,
	function(context)
		out.design("Recalc harmony - spawned");
		local faction_pooled_resource = context:character():faction():pooled_resource_manager();
		cm:apply_regular_reset_income(faction_pooled_resource);
	end,
	true
);

core:add_listener(
	"harmony_character_dead",
	"CharacterConvalescedOrKilled",
	function(context)
		local faction = context:character():faction();
		return faction:is_human() and faction:subculture() == "wh3_main_sc_cth_cathay"
	end,
	function(context)
		out.design("Recalc harmony - dead");
		local faction_pooled_resource = context:character():faction():pooled_resource_manager();
		cm:apply_regular_reset_income(faction_pooled_resource);
	end,
	true
);

core:add_listener(
	"settlement_captured",
	"RegionFactionChangeEvent",
	function(context)
		local old_owner = context:previous_faction()
		local new_owner = context:region():owning_faction()
		
		return (old_owner:is_human() and old_owner:subculture() == "wh3_main_sc_cth_cathay") or (new_owner:is_human() and new_owner:subculture() == "wh3_main_sc_cth_cathay")
	end,
	function(context)
		out.design("Recalc harmony - region change");
		local old_owner = context:previous_faction()
		local new_owner = context:region():owning_faction()
		
		cm:apply_regular_reset_income(old_owner:pooled_resource_manager())
		cm:apply_regular_reset_income(new_owner:pooled_resource_manager())
	end,
	true
);

