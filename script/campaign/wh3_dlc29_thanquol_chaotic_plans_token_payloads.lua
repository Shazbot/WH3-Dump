thanquol_chaotic_plans_token_payloads_config = {
	faction_key = "wh3_dlc29_skv_clan_scruten",
	undercity_slot_limit = 4,
}


thanquol_chaotic_plans_summon_verminlord_armies_config = {
	summon_verminlord_tokens = {
		wh3_dlc29_skv_verminlord_corruptor = 
		{
			-- For each verminlord token assign the ranks added by the corresponding head token
			wh3_dlc29_magic_summon_verminlord_corruptor_1 = 1,
			wh3_dlc29_magic_summon_verminlord_corruptor_2 = 3,
			wh3_dlc29_magic_summon_verminlord_corruptor_3 = 5,
			wh3_dlc29_magic_summon_verminlord_corruptor_4 = 7,
			wh3_dlc29_magic_summon_verminlord_corruptor_5 = 10,
		},
		wh3_dlc29_skv_verminlord_deceiver =
		{
			wh3_dlc29_magic_summon_verminlord_deceiver_1 = 1,
			wh3_dlc29_magic_summon_verminlord_deceiver_2 = 3,
			wh3_dlc29_magic_summon_verminlord_deceiver_3 = 5,
			wh3_dlc29_magic_summon_verminlord_deceiver_4 = 7,
			wh3_dlc29_magic_summon_verminlord_deceiver_5 = 10,
		},
		wh3_dlc29_skv_verminlord_warpseer =
		{
			wh3_dlc29_magic_summon_verminlord_warpseer_1 = 1,
			wh3_dlc29_magic_summon_verminlord_warpseer_2 = 3,
			wh3_dlc29_magic_summon_verminlord_warpseer_3 = 5,
			wh3_dlc29_magic_summon_verminlord_warpseer_4 = 7,
			wh3_dlc29_magic_summon_verminlord_warpseer_5 = 10,
		},
		wh3_dlc29_skv_verminlord_warbringer =
		{
			wh3_dlc29_magic_summon_verminlord_warbringer_1 = 1,
			wh3_dlc29_magic_summon_verminlord_warbringer_2 = 3,
			wh3_dlc29_magic_summon_verminlord_warbringer_3 = 5,
			wh3_dlc29_magic_summon_verminlord_warbringer_4 = 7,
			wh3_dlc29_magic_summon_verminlord_warbringer_5 = 10,
		},
	},
	verminlord_rank_up_tokens = {
		-- For each filler token assign the ranks added by it
		wh3_dlc29_magic_verminlord_rank_up = 1,
	},
	subtype_to_choice_mapping = {
		"wh3_dlc29_skv_verminlord_corruptor",
		"wh3_dlc29_skv_verminlord_deceiver",
		"wh3_dlc29_skv_verminlord_warpseer", 
		"wh3_dlc29_skv_verminlord_warbringer"
	},
	verminlord_names = {
		"1331680621",
		"1361676261",
		"495268925",
		"467538040",
		"239326550",
		"1726557368",
		"575323163",
		"592894079",
		"2081252232",
		"1820342110",
		"501304911"
	},
	empty_family_name = "names_name_2147360514",
	agent_type = "general",
	max_distance = 20,
	min_distance = 10,
	-- TODO: replace this when the actual faction is ready
	faction_key = "wh3_dlc29_skv_clan_scruten_separatists",
}

thanquol_chaotic_plans_summon_negative_verminlord_armies_config = {
	summon_verminlord_tokens = {
		["wh3_dlc29_magic_red_enemy_verminlord_corruptor_1"] = "wh3_dlc29_skv_verminlord_corruptor",
		["wh3_dlc29_magic_red_enemy_verminlord_deceiver_1"] = "wh3_dlc29_skv_verminlord_deceiver",
		["wh3_dlc29_magic_red_enemy_verminlord_warpseer_1"] = "wh3_dlc29_skv_verminlord_warpseer",
		["wh3_dlc29_magic_red_enemy_verminlord_warbringer_1"] = "wh3_dlc29_skv_verminlord_warbringer",
	},
	subtype_to_choice_mapping = {
		"wh3_dlc29_skv_verminlord_corruptor",
		"wh3_dlc29_skv_verminlord_deceiver",
		"wh3_dlc29_skv_verminlord_warpseer", 
		"wh3_dlc29_skv_verminlord_warbringer"
	},
	verminlord_names = {
		"1331680621",
		"1361676261",
		"495268925",
		"467538040",
		"239326550",
		"1726557368",
		"575323163",
		"592894079",
		"2081252232",
		"1820342110",
		"501304911"
	},
	empty_family_name = "names_name_2147360514",
	agent_type = "general",
	units = {
		["wh3_dlc29_magic_red_enemy_verminlord_corruptor_1"] = 
			{
				wh2_main_skv_inf_plague_monk_censer_bearer = 3,
				wh2_main_skv_inf_gutter_runners_1 = 5,
				wh2_main_skv_inf_plague_monks = 6,
				wh2_main_skv_art_plagueclaw_catapult = 4
			},
		["wh3_dlc29_magic_red_enemy_verminlord_deceiver_1"] = 
			{
				wh2_main_skv_inf_stormvermin_1 = 5,
				wh2_main_skv_inf_gutter_runners_1 = 3,
				wh2_main_skv_inf_gutter_runner_slingers_1 = 3,
				wh2_main_skv_inf_death_runners_0 = 4,
				wh2_main_skv_inf_death_globe_bombardiers = 4
			},
		["wh3_dlc29_magic_red_enemy_verminlord_warpseer_1"] = 
			{
				wh2_main_skv_inf_stormvermin_0 = 3,
				wh2_main_skv_inf_stormvermin_1 = 3,
				wh2_main_skv_inf_warpfire_thrower = 4,
				wh2_dlc12_skv_inf_ratling_gun_0 = 3,
				wh2_main_skv_art_warp_lightning_cannon = 3,
				wh3_dlc29_skv_mon_stormfiend_ratling_cannons = 3
			},
		["wh3_dlc29_magic_red_enemy_verminlord_warbringer_1"] = 
			{
				wh2_main_skv_inf_stormvermin_0 = 4,
				wh2_main_skv_inf_stormvermin_1 = 4,
				wh2_main_skv_inf_gutter_runners_0 = 4,
				wh2_main_skv_mon_rat_ogres = 4,
				wh2_main_skv_veh_doomwheel = 3
			},			
	},
	max_distance = 20,
	min_distance = 10,
	faction_key = "wh3_dlc29_summoned_verminlord",
}

thanquol_chaotic_plans_summon_daemon_armies_config = {
	faction_key = "wh3_main_kho_khorne",
	max_distance = 20,
	min_distance = 10,
	summon_daemon_tokens = {
		["wh3_dlc29_magic_res_activated_negative_daemon_nurgle"] = "wh3_main_nur_exalted_great_unclean_one_nurgle",
		["wh3_dlc29_magic_res_activated_negative_daemon_slaanesh"] = "wh3_main_sla_exalted_keeper_of_secrets_slaanesh",
		["wh3_dlc29_magic_res_activated_negative_daemon_tzeentch"] = "wh3_main_tze_exalted_lord_of_change_tzeentch",
		["wh3_dlc29_magic_res_activated_negative_daemon_khorne"] = "wh3_main_kho_exalted_bloodthirster",
	},
	subtype_to_choice_mapping = {
		"wh3_main_nur_exalted_great_unclean_one_nurgle",
		"wh3_main_sla_exalted_keeper_of_secrets_slaanesh",
		"wh3_main_tze_exalted_lord_of_change_tzeentch", 
		"wh3_main_kho_exalted_bloodthirster"
	},
	daemon_names = {
		["wh3_dlc29_magic_res_activated_negative_daemon_nurgle"] = 
			{1041722221,1048634847,1058399806,1117262580,1146821074,1155075923,1158054600,1158980230,1220269935,126484145,1272369641,1277416052,1279696766,
			1301479672,1342742205,1410519463,141404364,1419686083,1461228909,146820448,1468905053,1485129498,1543749130,1550236332,1581004732,1614138643,
			164865508,1676760136,1687905010,1690306112,169069454,1693558948,1696020736,1697413012,1706435170,1726815296,1729674067,1739130089,1768394748,
			1777509525,1802476420,1809005381,1824259958,1825700179,1832369744,184507106,1845764573,1854094776,1872948112,1887616450,1941208828,1941372945,
			1952473050,2042750768,2053793852,2060407667,2100543488,2133464690,2147149915,227901750,240347032,245453348,26020292,26736793,292550410,315078753,
			315958292,333760128,339705996,35282421,403337922,419839653,447970060,460405039,462918524,505573757,510183225,534884410,602113376,611130735,
			626290435,631995795,646530321,683260326,683786097,696043982,6973844,697467029,700193812,702518360,74853548,749984123,751336671,765907531,786859374,
			814273585,835427095,837189797,87968823,882430640,883607214,883685783,900380766,929529210,93312933,935184755,958551147,97906604,98543091},
		["wh3_dlc29_magic_res_activated_negative_daemon_slaanesh"]=
			{1003570063,1044606327,1071742272,1094536533,1111604197,113311814,1169535557,1171481069,1174434981,1176696726,1184887071,1205058568,1247391473,1260587383,
			1276720228,1302458463,1306336135,1322302001,1335633947,1340893058,1358983699,1359407136,137564635,1378207799,1403346510,1429411013,1436925109,1451385718,
			1461664172,1499812345,1500349485,1515761141,1560358506,1580899337,1599101598,1604494277,1637034428,1642276693,1643776460,1650714498,1725723511,1733371972,
			1765116996,1778985916,178741957,1799264903,1819491779,1835209665,186615171,1879570651,1884711425,189038051,1892659659,193059083,1971478501,2000223402,2023882439,
			2027195000,2031988222,2032277572,2055626370,2055737119,207208673,2095478109,2097038321,2100680881,2132488781,24205910,246735968,265777088,277989842,301138135,
			307070033,344490521,366105360,37700146,383682616,390587630,40528466,440144013,454713189,472340626,478257066,486587842,518707680,60809367,637271452,642670866,
			654135863,655300530,666181442,669632896,674211516,716475066,719885552,734811286,785067943,793259891,805174334,811767222,854442452,899808332,92086328,948976323,949946798},
		["wh3_dlc29_magic_res_activated_negative_daemon_tzeentch"] = 
			{1002451869,1024060622,1030867864,1036120912,1040488644,1050658588,1076925295,1077906017,1136460275,1184632660,1192755646,1192758760,1194836815,1220527248,
			1224506994,1273837962,1283674471,1297516951,1303673237,1307375226,1374460003,140805735,1437019510,1452294047,1465175722,1480784342,1529719546,1536654005,
			1593033890,164401636,1644177779,1648865445,1678872553,1697287924,1712222134,1718161292,1742014251,1745117799,1745294911,186676589,1886694057,1903404705,1930715453,
			194298615,1977343547,2030010291,2095227539,2109505223,2132721311,231591404,241292625,256948675,26355175,26948047,275608316,284572263,297630277,298546749,320318362,
			321905872,32889503,361732805,370918923,375073171,376061187,386098422,433233643,442417882,482708443,495277719,504104611,506679539,517072280,517751924,518629927,
			540670966,572469472,581740850,615980044,632276645,642702136,647894028,650680901,65526490,661244876,681172561,701975330,773442573,788889193,81342988,821982948,
			836250253,84114030,869162900,903439616,905017912,908883315,91901797,924903214,937250949,949469164,954864157,956574438,965255994,974669488,990169742},
		["wh3_dlc29_magic_res_activated_negative_daemon_khorne"] = 
			{926370943,1334937573,911921736,1691743093,1582345394,28510023,886615990,1044876956,1530597171,172052703,1428848438,338625485,1458932592,456974769,1942287479,
			122084442,1817779017,2071518600,466747112,650427209,434277176,252139156,767776221,140485317,1622847289,1803749741,532339017,115343401,1654026861,2026088101,
			1534040637,825757436,1032718743,1427105939,243552988,192047710,1632727215,1009133847,538519609,1265321536,1533102725,1706452329,849323588,884781527,610456062,
			919418744,1728112450,1902969313,1124153715,278725170,1768149675,1020411399,1668647968,455543707,1280482057,1622646838,46811824,842314770,1393578111,1922596162,
			831067150,1303163904,1927471694,441625049,1076963931,599891755,447634099,2107327075,532202602,971667224,339222298,1496996494,1559022106,268320447,1676396340,
			104668218,98112620,1374932976,2147066798,1528225132,2018673636,867707068,807233052,1335504612,854532202,1833108542,1550640326,2044807886,1562012629,805896631,
			1848830606,153618613,1369888557,656091817,501119504,1720182748,1920325930,570535837,145240824,2035537503,690499081,1960446480,756623522,1162131827,1362694374,
			405812804,371764953,387626843}
	},
	empty_family_name = "names_name_2147360514",
	agent_type = "general",
	units = {
		["wh3_dlc29_magic_res_activated_negative_daemon_nurgle"] = 
			{
				wh3_main_nur_inf_nurglings_0 = 5,
				wh3_main_nur_inf_plaguebearers_0 = 3,
				wh3_main_nur_mon_rot_flies_0 = 2,
				wh3_main_nur_mon_beast_of_nurgle_0 = 2
			},
		["wh3_dlc29_magic_res_activated_negative_daemon_slaanesh"] = 
			{
				wh3_main_sla_inf_daemonette_0 = 4,
				wh3_main_sla_cav_hellstriders_0 = 3,
				wh3_main_sla_cav_seekers_of_slaanesh_0 = 3,
				wh3_main_sla_veh_hellflayer_0 = 1
		},
		["wh3_dlc29_magic_res_activated_negative_daemon_tzeentch"] = 
			{
				wh3_main_tze_inf_blue_horrors_0 = 4,
				wh3_main_tze_inf_pink_horrors_0 = 3,
				wh3_main_tze_mon_flamers_0 = 2,
				wh3_main_tze_mon_screamers_0 = 3
		},
		["wh3_dlc29_magic_res_activated_negative_daemon_khorne"] = 
			{
				wh3_main_kho_inf_bloodletters_0 = 4,
				wh3_main_kho_veh_blood_shrine_0 = 1,
				wh3_main_kho_inf_bloodletters_1 = 3,
				wh3_main_kho_mon_khornataurs_0 = 3
		},	
	},
}

thanquol_chaotic_plans_undercity_config = {
	undercity_tokens = {
		"wh3_dlc29_magic_create_undercity_1",
	},
	-- List token : building_key
	-- Can be combo or filler tokens
	building_tokens =
	{
		wh3_dlc29_magic_create_undercity_filler_token_assassins = "wh2_dlc12_under_empire_discovery_assassins_1",
		wh3_dlc29_magic_create_undercity_filler_token_kidnappers = "wh2_dlc12_under_empire_food_kidnappers_1",
		wh3_dlc29_magic_create_undercity_filler_token_crafting = "wh2_dlc12_under_empire_money_crafting_1",
		wh3_dlc29_magic_create_undercity_filler_token_refinery = "wh2_dlc12_under_empire_warpstone_refinery_1",
	}
}

thanquol_chaotic_plans_teleport_daemon_lord_config = {
	teleport_legendary_lord_tokens = {
		["wh3_dlc29_skv_red_teleport_daemon_lord"] = true,
	},
	teleport_legendary_lord_factions = {
		"wh3_main_kho_exiles_of_khorne",
		"wh3_dlc26_kho_arbaal",
		"wh3_dlc26_kho_skulltaker",
		"wh3_dlc24_tze_the_deceivers",
		"wh3_dlc25_nur_epidemius",
		"wh3_main_nur_nurgle",
		"wh3_dlc29_chs_host_of_the_triplets",
		"wh3_main_tze_oracles_of_tzeentch",
		"wh3_dlc27_sla_masque_of_slaanesh",
		"wh3_dlc27_sla_the_tormentors",
		"wh_main_chs_chaos",
		"wh3_dlc20_chs_azazel",
		"wh3_dlc20_chs_festus",
		"wh3_dlc20_chs_kholek",
		"wh3_dlc20_chs_sigvald",
		"wh3_dlc20_chs_valkia",
		"wh3_dlc20_chs_vilitch",
	},
	max_distance = 20,
	min_distance = 10,
}

thanquol_chaotic_plans_sack_and_explode_region = {
	tokens = {
		["wh3_dlc29_magic_res_activated_negative_test_1"] = true,
	},
	resource_cost_to_region_level = {
		[1] = "resource_cost_key",
		[2] = "resource_cost_key",
		[3] = "resource_cost_key",
		[4] = "resource_cost_key",
		[5] = "resource_cost_key"
		-- if there is no setup for the region's level, we use the highest level found
	}
}

thanquol_chaotic_plans_explode_region_and_schemer = {
	tokens = {
		["wh3_dlc29_magic_res_activated_negative_test_2"] = true,
	},
}

thanquol_chaotic_plans_devastate_region = {
	tokens = {
		"wh3_dlc29_magic_pull_moon_1",
	},

	climates = {
		devastation_chasm  = "climate_devastated_chasm",
		devastation_crater = "climate_devastated_crater",
		devastation_fire   = "climate_devastated_volcano",
		devastation_sunk   = "climate_devastated_volcano",
	},

	effect_bundles = {
		devastation_chasm  = "wh3_dlc29_devastation_chasm_disable_resources",
		devastation_crater = "wh3_dlc29_devastation_crater_disable_resources",
		devastation_fire   = "wh3_dlc29_devastation_volcano_disable_resources",
		devastation_sunk   = "wh3_dlc29_devastation_volcano_disable_resources",
	},
	climate_type = "vermintide_devastation",
	effect_bundle = "wh3_dlc29_episodes_skaven_devastated_province",
	settlement_type = "wh3_dlc29_devastated",
	settlement_state = "devastated",
	raze_delay = 0.1,
}

thanquol_chaotic_plans_add_schemer_traits = {
	tokens = {
		-- token_key = "trait_key",
	}
}

------------------
------DATA--------
------------------
thanquol_chaotic_plans_token_payloads = {}
thanquol_chaotic_plans_token_payloads.config = thanquol_chaotic_plans_token_payloads_config

------------------
----FUNCTIONS-----
------------------
function thanquol_chaotic_plans_token_payloads:initialise()
	local faction_interface = cm:get_faction(thanquol_chaotic_plans_missions_config.faction_key)
	if faction_interface and faction_interface:is_null_interface() == false and faction_interface:is_human() then
		self:setup_scripted_payload_listeners()
	end
end

--listen to all the mission events so that we can remove the internal mission data
function thanquol_chaotic_plans_token_payloads:setup_scripted_payload_listeners()
	
	core:add_listener(
		"Thanquol_TokenScriptedPayload",
		"ChaoticPlanTokenScriptedPayloadEvent",
		function(context)
			if context:plan():is_null_interface() == false 
			 and context:plan():faction():is_null_interface() == false 
			 and context:plan():faction():name() == thanquol_chaotic_plans_token_payloads_config.faction_key then
				return true
			end
		end,
		function(context)
			local verminlord_token, verminlord_level = self:get_verminlord_from_token(context:token_record_key(), context:plan())
			if verminlord_token then
				self:spawn_verminlord_army(context:plan(), verminlord_token, verminlord_level)
				return
			elseif thanquol_chaotic_plans_summon_negative_verminlord_armies_config.summon_verminlord_tokens[context:token_record_key()] then
				self:spawn_negative_verminlord_army(context:plan(), thanquol_chaotic_plans_summon_negative_verminlord_armies_config.summon_verminlord_tokens[context:token_record_key()], thanquol_chaotic_plans_summon_negative_verminlord_armies_config.units[context:token_record_key()], 1)
				return
			elseif thanquol_chaotic_plans_summon_daemon_armies_config.summon_daemon_tokens[context:token_record_key()] then
				self:spawn_daemon_army(context:plan(), thanquol_chaotic_plans_summon_daemon_armies_config.summon_daemon_tokens[context:token_record_key()], thanquol_chaotic_plans_summon_daemon_armies_config.units[context:token_record_key()])
				return
			elseif table.find(thanquol_chaotic_plans_undercity_config.undercity_tokens, context:token_record_key()) then
				self:spawn_undercity(context:plan())
			elseif table.find(thanquol_chaotic_plans_devastate_region.tokens, context:token_record_key()) then
				self:devastate_region(context:plan())
			elseif thanquol_chaotic_plans_teleport_daemon_lord_config.teleport_legendary_lord_tokens[context:token_record_key()] then
				self:teleport_legendary_daemon_lord_to_settlement(context:plan())
				return
			elseif thanquol_chaotic_plans_sack_and_explode_region.tokens[context:token_record_key()] then
				self:sack_and_explode_region(context:plan())
				return
			elseif thanquol_chaotic_plans_explode_region_and_schemer.tokens[context:token_record_key()] then
				self:explode_region_and_schemer(context:plan())
				return
			elseif thanquol_chaotic_plans_add_schemer_traits.tokens[context:token_record_key()] then
				self:add_schemer_trait(context:plan(), thanquol_chaotic_plans_add_schemer_traits.tokens[context:token_record_key()])
				return
			end
		end,
		true
	)
end

function thanquol_chaotic_plans_token_payloads:get_verminlord_from_token(token_key, plan)
	local verminlord_level = 0

	local verminlord_key = nil
	for current_verminlord_key, verminlord_tokens in dpairs(thanquol_chaotic_plans_summon_verminlord_armies_config.summon_verminlord_tokens) do
		if verminlord_key then
			break
		end
		for verminlord_token_key, level in dpairs(verminlord_tokens) do
			if verminlord_token_key == token_key then
				verminlord_level = level
				verminlord_key = current_verminlord_key
				break
			end
		end
	end

	local drawn_tokens = plan:drawn_token_keys()
	for _, token_key in ipairs(drawn_tokens) do
		local level = thanquol_chaotic_plans_summon_verminlord_armies_config.verminlord_rank_up_tokens[token_key]
		if is_number(level) then
			verminlord_level = verminlord_level + level
		end
	end

	return verminlord_key, verminlord_level
end

function thanquol_chaotic_plans_token_payloads:get_units_string(units_table)
    local units_string = ""
    for unit_key, amount in dpairs(units_table) do
        for i = 1, amount do
            units_string = units_string .. unit_key .. ","
		end
    end
    return units_string
end

function thanquol_chaotic_plans_token_payloads:spawn_verminlord_army(chaotic_plan, verminlord_agent_sub_type, level)
	local same_region = true
	local at_sea = false
	local region = chaotic_plan:region()
	local spawn_distance = cm:random_number(thanquol_chaotic_plans_summon_verminlord_armies_config.max_distance, thanquol_chaotic_plans_summon_verminlord_armies_config.min_distance)
	local x, y = cm:find_valid_spawn_location_for_character_from_settlement(thanquol_chaotic_plans_token_payloads_config.faction_key, region:name(), at_sea, same_region, spawn_distance)

	if x < 0 or y < 0 then
		out("****CHAOTIC PLANS: Could not find valid position to spawn Verminlord!")
		return
	end

	local verminlord_cqi = 0
	-- Units will be added by combo token payloads
	cm:create_force_with_general(
		thanquol_chaotic_plans_token_payloads_config.faction_key,
		"",
		region:name(),
		x,
		y,
		thanquol_chaotic_plans_summon_verminlord_armies_config.agent_type,
		verminlord_agent_sub_type,
		"names_name_" .. thanquol_chaotic_plans_summon_verminlord_armies_config.verminlord_names[cm:random_number(#thanquol_chaotic_plans_summon_verminlord_armies_config.verminlord_names)],
		"",
		thanquol_chaotic_plans_summon_verminlord_armies_config.empty_family_name,
		"",
		false,
		function(cqi)
			cm:replenish_action_points(cm:char_lookup_str(cqi))
			verminlord_cqi = cqi
		end
	)

	cm:chaotic_magic_plan_add_units(chaotic_plan, verminlord_cqi)

	local xp = cm.character_xp_per_level[level]
	cm:add_agent_experience(cm:char_lookup_str(verminlord_cqi), xp)
end

function thanquol_chaotic_plans_token_payloads:spawn_negative_verminlord_army(chaotic_plan, verminlord_agent_sub_type, units)
		local same_region = true
		local at_sea = false
		local region = chaotic_plan:region()
		local spawn_distance = cm:random_number(thanquol_chaotic_plans_summon_negative_verminlord_armies_config.max_distance, thanquol_chaotic_plans_summon_negative_verminlord_armies_config.min_distance)
		local x, y = cm:find_valid_spawn_location_for_character_from_settlement(thanquol_chaotic_plans_summon_negative_verminlord_armies_config.faction_key, region:name(), at_sea, same_region, spawn_distance)

		if x < 0 or y < 0 then
			out("****CHAOTIC PLANS: Could not find valid position to spawn Verminlord!")
			return
		end

		cm:create_force_with_general(
			thanquol_chaotic_plans_summon_negative_verminlord_armies_config.faction_key,
			self:get_units_string(units),
			region:name(),
			x,
			y,
			thanquol_chaotic_plans_summon_negative_verminlord_armies_config.agent_type,
			verminlord_agent_sub_type,--thanquol_chaotic_plans_summon_negative_verminlord_armies_config.subtype_to_choice_mapping[cm:random_number(#thanquol_chaotic_plans_summon_negative_verminlord_armies_config.subtype_to_choice_mapping)],
			"names_name_" .. thanquol_chaotic_plans_summon_negative_verminlord_armies_config.verminlord_names[cm:random_number(#thanquol_chaotic_plans_summon_negative_verminlord_armies_config.verminlord_names)],
			"",
			thanquol_chaotic_plans_summon_negative_verminlord_armies_config.empty_family_name,
			"",
			false,
			function(cqi)
				cm:replenish_action_points(cm:char_lookup_str(cqi))
				cm:apply_effect_bundle_to_characters_force("wh3_dlc29_skv_chaotic_plans_enemy_spawned_army_bundle", cqi, 0)
			end
		)
		self:declare_war_for_summoned_army(thanquol_chaotic_plans_summon_negative_verminlord_armies_config.faction_key)
end

function thanquol_chaotic_plans_token_payloads:spawn_daemon_army(chaotic_plan, daemon_agent_sub_type, units)
		local same_region = true
		local at_sea = false
		local region = chaotic_plan:region()
		local spawn_distance = cm:random_number(thanquol_chaotic_plans_summon_daemon_armies_config.max_distance, thanquol_chaotic_plans_summon_daemon_armies_config.min_distance)
		local x, y = cm:find_valid_spawn_location_for_character_from_settlement(thanquol_chaotic_plans_summon_daemon_armies_config.faction_key, region:name(), at_sea, same_region, spawn_distance)

		cm:create_force_with_general(
			thanquol_chaotic_plans_summon_daemon_armies_config.faction_key,
			self:get_units_string(units),
			region,
			x,
			y,
			thanquol_chaotic_plans_summon_daemon_armies_config.agent_type,
			daemon_agent_sub_type,--thanquol_chaotic_plans_summon_daemon_armies_config.subtype_to_choice_mapping[cm:random_number(#thanquol_chaotic_plans_summon_daemon_armies_config.subtype_to_choice_mapping)],
			"names_name_" .. thanquol_chaotic_plans_summon_daemon_armies_config.daemon_names[cm:random_number(#thanquol_chaotic_plans_summon_daemon_armies_config.daemon_names.daemon_agent_sub_type)],
			"",
			thanquol_chaotic_plans_summon_daemon_armies_config.empty_family_name,
			"",
			false,
			function(cqi)
				cm:replenish_action_points(cm:char_lookup_str(cqi))
				cm:apply_effect_bundle_to_characters_force("wh3_dlc29_skv_chaotic_plans_enemy_spawned_army_bundle", cqi, 0)
			end
		)
		self:declare_war_for_summoned_army(thanquol_chaotic_plans_summon_daemon_armies_config.faction_key)
end

function thanquol_chaotic_plans_token_payloads:spawn_undercity(plan)
	local region = plan:region()
	if not region or region:is_null_interface() or region:is_abandoned() then
		return
	end

	local thanquol_faction = cm:get_faction(thanquol_chaotic_plans_token_payloads_config.faction_key)
	if not thanquol_faction then
		return
	end

	local under_empire = region:foreign_slot_manager_for_faction(thanquol_chaotic_plans_token_payloads_config.faction_key)
	if under_empire:is_null_interface() then
		cm:add_foreign_slot_set_to_region_for_faction(thanquol_faction:command_queue_index(), region:cqi(), "wh2_dlc12_slot_set_underempire")
		under_empire = region:foreign_slot_manager_for_faction(thanquol_chaotic_plans_token_payloads_config.faction_key)
	end
	
	local slots = under_empire:slots()
	local slot_counter = 0
	local drawn_tokens = plan:drawn_token_keys()
	cm:shuffle_table(drawn_tokens)

	local slot_nums = thanquol_chaotic_plans_token_payloads_config.undercity_slot_limit
	for _, token_key in ipairs(drawn_tokens) do
		local building_key = thanquol_chaotic_plans_undercity_config.building_tokens[token_key]
		if building_key then
			-- There could be a pre-existing undercity, skip filled slots
			while slot_counter < slot_nums and slots:item_at(slot_counter):has_building() do
				slot_counter = slot_counter + 1
			end

			if slot_counter >= slot_nums then
				break
			end

			local slot = slots:item_at(slot_counter)
			if slot and not slot:is_null_interface() then
				cm:foreign_slot_instantly_upgrade_building(slot, building_key)
				slot_counter = slot_counter + 1
			end
		end
	end
end

function thanquol_chaotic_plans_token_payloads:declare_war_for_summoned_army(declaring_faction)
	local declaring_faction_obj = cm:get_faction(declaring_faction)
	cm:postpone_cai_analysis()
	local factions_met = declaring_faction_obj:factions_met()
	for i = 0, factions_met:num_items() - 1 do
		local other_faction = factions_met:item_at(i)
		local other_faction_key = other_faction:name()
		if declaring_faction_obj:at_war_with(other_faction_key) == false then
			if other_faction_key == declaring_faction
				or other_faction:is_ally_vassal_or_client_state_of(declaring_faction_obj)
				or other_faction:is_dead()
			then
				return
			end
			if other_faction:at_war_with(declaring_faction) then
				return
			end
			if other_faction:is_vassal() == false then
				-- If this faction is not a vassal, declare war on them
				cm:force_declare_war(declaring_faction, other_faction_key, false, false)
			else
				-- otherwise declare war on their master to avoid issues
				local master_faction = other_faction:master()
				if master_faction:at_war_with(declaring_faction) == false and master_faction:is_dead() == false then
					local master_faction_key = other_faction:master():name()
					cm:force_declare_war(declaring_faction, master_faction_key, false, false)
				end
			end
		end
	end
	local thanquol_faction = cm:get_faction(thanquol_chaotic_plans_token_payloads_config.faction_key)
	if not thanquol_faction:at_war_with(declaring_faction) then
		cm:force_declare_war(declaring_faction, thanquol_chaotic_plans_token_payloads_config.faction_key, false, false)
	end
	cm:resume_cai_analysis()
	-- No diplomacy with the summoned army's faction
	cm:force_diplomacy("all", "faction:"..declaring_faction, "all", false, false, true)
	cm:force_diplomacy("faction:"..declaring_faction, "all", "all", false, false, true)
end

function thanquol_chaotic_plans_token_payloads:devastate_region(plan)
	local region_obj = plan:region()
	if region_obj:is_null_interface() then
		return false
	end

	local region_key = region_obj:name()
	if devastation_manager:is_region_devastated(region_key) then
		return false
	end

	-- Endgame-style climate / event-area / region bundle (does not raze settlements).
	local devastation_successful = devastation_manager:devastate_region(
		region_key,
		plan:faction():culture(),
		thanquol_chaotic_plans_devastate_region.climate_type,
		thanquol_chaotic_plans_devastate_region.effect_bundle
	)

	if not devastation_successful then
		return false
	end

	-- Defer abandon/raze so chaotic-plan execute/remove can finish before ownership changes.
	cm:callback(
		function()
			self:raze_event_area_settlements(region_key)
		end,
		thanquol_chaotic_plans_devastate_region.raze_delay
	)

	return true
end

function thanquol_chaotic_plans_token_payloads:raze_event_area_settlements(region_key)
	local region_obj = cm:get_region(region_key)
	if not is_region(region_obj) then
		return
	end

	local config = thanquol_chaotic_plans_devastate_region
	local regions = region_obj:regions_in_same_event_area()
	if regions and not regions:is_null_interface() then
		for i = 0, regions:num_items() - 1 do
			self:raze_devastated_settlement(regions:item_at(i), config)
		end
	else
		self:raze_devastated_settlement(region_obj, config)
	end

	CampaignUI.UpdateAllCityInfoBars()
end

function thanquol_chaotic_plans_token_payloads:raze_devastated_settlement(region_obj, config)
	if not is_region(region_obj) then
		return
	end

	-- Snapshot CQIs before mutating the region; kill generals (whole force) then lone agents.
	local general_cqis = {}
	local agent_cqis = {}
	for _, character in model_pairs(region_obj:characters_in_region()) do
		if character:has_military_force()
			and character:military_force():has_general()
			and character:military_force():general_character():cqi() == character:cqi()
		then
			table.insert(general_cqis, character:cqi())
		elseif not character:is_embedded_in_military_force() then
			table.insert(agent_cqis, character:cqi())
		end
	end

	for _, cqi in ipairs(general_cqis) do
		cm:kill_character(cqi, true)
	end
	for _, cqi in ipairs(agent_cqis) do
		cm:kill_character(cqi, true)
	end

	local current_region_key = region_obj:name()
	cm:set_region_abandoned(current_region_key)

	local settlement_obj = region_obj:settlement()
	if settlement_obj and not settlement_obj:is_null_interface() then
		cm:reset_settlement_type(settlement_obj, config.settlement_type, 1)
		cm:set_settlement_devastated_state(settlement_obj, config.settlement_state)
	end
end


function thanquol_chaotic_plans_token_payloads:find_legendary_daemons_to_teleport()
	local daemon_lords = {}
	local config = thanquol_chaotic_plans_teleport_daemon_lord_config
	for _, faction_key in ipairs(config.teleport_legendary_lord_factions) do
		local faction = cm:get_faction(faction_key)
		if faction and not faction:is_null_interface() then
			local character = faction:faction_leader()
			if character 
				and not character:is_null_interface() 
				and character:is_alive() 
				and not character:is_wounded() 
				and not character:is_besieging() 
				and not character:is_embedded_in_military_force() 
				and character:has_military_force() 
				and character:has_region() 
			then
				table.insert(daemon_lords, character)
			end
		end
	end
	return daemon_lords
end

function thanquol_chaotic_plans_token_payloads:teleport_legendary_daemon_lord_to_settlement(chaotic_plan)
	local region = chaotic_plan:region()
	if region:is_null_interface() then
		return
	end

	local available_daemon_lords = self:find_legendary_daemons_to_teleport()

	if #available_daemon_lords == 0 then
		local mapping = thanquol_chaotic_plans_summon_daemon_armies_config.subtype_to_choice_mapping
		local daemon_subtype = mapping[cm:random_number(#mapping)]
		self:spawn_daemon_army(chaotic_plan, daemon_subtype)
		return
	end

	local config = thanquol_chaotic_plans_teleport_daemon_lord_config
	local character = available_daemon_lords[cm:random_number(#available_daemon_lords)]
	local same_region = true
	local at_sea = false
	local spawn_distance = cm:random_number(config.max_distance, config.min_distance)
	local x, y = cm:find_valid_spawn_location_for_character_from_settlement(character:faction():name(), region:name(), at_sea, same_region, spawn_distance)

	if x > -1 and y > -1 then
		cm:teleport_to(cm:char_lookup_str(character), x, y)
	else
		self:spawn_fallback_generic_daemon_army(chaotic_plan)
	end
end

function thanquol_chaotic_plans_token_payloads:sack_and_explode_region(chaotic_plan)
	local region = chaotic_plan:region()
	if region:is_null_interface() then
		return
	end

	local planner_faction = cm:get_faction(thanquol_chaotic_plans_token_payloads_config.faction_key)
	if not planner_faction or planner_faction:is_null_interface() then
		return
	end

	local config = thanquol_chaotic_plans_sack_and_explode_region
	local region_level = region:settlement():primary_slot():building():building_level();
	local cost_key = config.resource_cost_to_region_level[region_level] or config.resource_cost_to_region_level[#config.resource_cost_to_region_level]
	if cost_key then
		cm:pooled_resource_transaction(planner_faction:pooled_resource_manager(), cost_key)
	end
	cm:set_region_abandoned(region:name())
end

function thanquol_chaotic_plans_token_payloads:explode_region_and_schemer(chaotic_plan)
	local region = chaotic_plan:region()
	if region:is_null_interface() then
		return
	end

	local schemer = chaotic_plan:schemer()
	if not schemer:is_null_interface() then
		cm:kill_character(cm:char_lookup_str(schemer:character():command_queue_index()), true)
	end

	cm:set_region_abandoned(region:name())
end

function thanquol_chaotic_plans_token_payloads:add_schemer_trait(chaotic_plan, trait_key)
	local schemer = chaotic_plan:schemer()
	if schemer:is_null_interface() then
		return
	end

	cm:force_add_trait(cm:char_lookup_str(schemer:character():command_queue_index()), trait_key)
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
		end
	end
)