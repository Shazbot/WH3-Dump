local corruption_province_overrides = {
	["wh3_dlc20_combi_province_middle_mountains"] =
		{
			["nurgle"] = 25
		},
	["wh3_main_combi_province_saphery"] =
		{
			["slaanesh"] = 75
		},
	["wh3_main_combi_province_titan_peaks"] =
		{
			["slaanesh"] = 50
		},
	["wh3_main_combi_province_crater_of_the_waking_dead"] = 
	{
		["vampiric"] = 50
	},
	["wh3_main_combi_province_the_gwangee_valley"] = 
	{
		["tzeentch"] = 10,
		["khorne"] = 10
	},
	["wh3_main_combi_province_river_qurveza"] = 
	{
		["nurgle"] = 25,
	},
	["wh3_main_combi_province_isthmus_of_lustria"] = 
	{
		["slaanesh"] = 10,
	},
	["wh3_main_combi_province_marches_of_couronne"] = 
	{
		["vampiric"] = 10,
	},
	["wh3_main_combi_province_serpent_estuary"] = 
	{
		["chaos"] = 30,
	},
	["wh3_main_combi_province_coast_of_araby"] = 
	{
		["vampiric"] = 30,
	},
	["wh3_main_combi_province_marshes_of_madness"] = 
	{
		["vampiric"] = 30,
	},
	["wh3_main_combi_province_plains_of_xen"] = 
	{
		["vampiric"] = 10,
	},
	["wh3_main_combi_province_gnoblar_country"] = 
	{
		["vampiric"] = 10,
	},
	["wh3_main_combi_province_the_red_wastes"] =
	{
		["chaos"] = 30,
	},
	["wh3_main_combi_province_the_bleak_coast"] =
	{
		["chaos"] = 30,
	}
};

function add_starting_corruption()
	local corruption_mapping = {
		["wh_main_chs_chaos"] = "chaos",
		["wh_dlc08_nor_norsca"] = "chaos",
		["wh_dlc03_bst_beastmen"] = "chaos",
		["wh3_main_dae_daemons"] = "chaos",
		["wh2_main_skv_skaven"] = "skaven",
		["wh_main_vmp_vampire_counts"] = "vampiric",
		["wh2_dlc11_cst_vampire_coast"] = "vampiric",
		["wh3_main_kho_khorne"] = "khorne",
		["wh3_main_nur_nurgle"] = "nurgle",
		["wh3_main_sla_slaanesh"] = "slaanesh",
		["wh3_main_tze_tzeentch"] = "tzeentch",
		["wh3_dlc23_chd_chaos_dwarfs"] = "chaos"
	};
	local province_list = cm:model():world():province_list();
	
	for i = 0, province_list:num_items() - 1 do
		local current_province = province_list:item_at(i);
		local corruption_province_overrides_mapped = corruption_province_overrides[current_province:key()];
		local prm = current_province:pooled_resource_manager();
		
		-- add the overridden starting corruption, if it's specified
		if corruption_province_overrides_mapped then
			for corruption, amount_to_add in pairs(corruption_province_overrides_mapped) do
				cm:pooled_resource_factor_transaction(prm:resource("wh3_main_corruption_" .. corruption), "local_populace", amount_to_add);
			end;
		-- otherwise add corruption based on the province owners
		else
			local regions = current_province:regions();
			local num_regions = regions:num_items();
			local amount_to_add_per_region = 20;
			local skaven_amount_to_add_per_region = 5
			
			if num_regions == 1 then
				amount_to_add_per_region = 75;
				skaven_amount_to_add_per_region = 40
			elseif num_regions == 2 then
				amount_to_add_per_region = 35;
				skaven_amount_to_add_per_region = 20
			elseif num_regions == 3 then
				amount_to_add_per_region = 25;
				skaven_amount_to_add_per_region = 10
			end;
			
			for j = 0, num_regions - 1 do
				local current_region = regions:item_at(j);
				local corruption_mapped = corruption_mapping[current_region:owning_faction():culture()];
				local amount

				if(corruption_mapped == "skaven") then
					amount = skaven_amount_to_add_per_region
				else
					amount = amount_to_add_per_region
				end

				if not current_region:is_abandoned() and corruption_mapped then
					cm:pooled_resource_factor_transaction(prm:resource("wh3_main_corruption_" .. corruption_mapped), "local_populace", amount);
				end;
			end;
		end;
	end;
end;

-- The point of this is to add a dummy effect bundle to provinces so we can use model safe CCOs in absence of model safe corruption detection for building context effects
-- Probably a good idea in future to add this functionality directly in CCOs, some work already done there
function add_high_corruption_dummy_effect_listeners()
	core:add_listener(
		"CorruptuonRegionTurnStart",
		"RegionTurnStart",
		true,
		function(context)
			local region = context:region();
			local province = region:province();
			check_region_corruption_effect(province, region, "wh3_main_corruption_chaos",
			{
				{threshold = 100, key = "wh3_main_max_corruption_chaos_dummy"},
				{threshold = 75, key = "wh3_main_high_corruption_chaos_dummy"},
				{threshold = 50, key = "wh3_main_mid_corruption_chaos_dummy"}
			});
			check_region_corruption_effect(province, region, "wh3_main_corruption_khorne",
			{
				{threshold = 100, key = "wh3_main_max_corruption_kho_dummy"},
				{threshold = 75, key = "wh3_main_high_corruption_kho_dummy"},
				{threshold = 50, key = "wh3_main_mid_corruption_kho_dummy"}
			});
			check_region_corruption_effect(province, region, "wh3_main_corruption_nurgle",
			{
				{threshold = 100, key = "wh3_main_max_corruption_nur_dummy"},
				{threshold = 75, key = "wh3_main_high_corruption_nur_dummy"},
				{threshold = 50, key = "wh3_main_mid_corruption_nur_dummy"}
			});
			check_region_corruption_effect(province, region, "wh3_main_corruption_slaanesh",
			{
				{threshold = 100, key = "wh3_main_max_corruption_sla_dummy"},
				{threshold = 75, key = "wh3_main_high_corruption_sla_dummy"},
				{threshold = 50, key = "wh3_main_mid_corruption_sla_dummy"}
			});
			check_region_corruption_effect(province, region, "wh3_main_corruption_tzeentch",
			{
				{threshold = 100, key = "wh3_main_max_corruption_tze_dummy"},
				{threshold = 75, key = "wh3_main_high_corruption_tze_dummy"},
				{threshold = 50, key = "wh3_main_mid_corruption_tze_dummy"}
			});
			check_region_corruption_effect(province, region, "wh3_main_corruption_vampiric",
			{
				{threshold = 100, key = "wh3_main_max_corruption_vmp_dummy"},
				{threshold = 75, key = "wh3_main_high_corruption_vmp_dummy"},
				{threshold = 50, key = "wh3_main_mid_corruption_vmp_dummy"}
			});
			check_region_corruption_effect(province, region, "wh3_main_corruption_skaven",
			{
				{threshold = 100, key = "wh3_main_max_corruption_skv_dummy"},
				{threshold = 75, key = "wh3_main_high_corruption_skv_dummy"},
				{threshold = 50, key = "wh3_main_mid_corruption_skv_dummy"}
			});
		end,
		true
	);
end

function check_region_corruption_effect(province, region, corruption_key, levels)
	local prm = province:pooled_resource_manager();
	local corruption_pr = prm:resource(corruption_key);

	if corruption_pr:is_null_interface() == false then
		local effect_applied = false;

		for i = 1, #levels do
			if corruption_pr:value() >= levels[i].threshold and effect_applied == false then
				cm:apply_effect_bundle_to_region(levels[i].key, region:name(), 0);
				effect_applied = true;
			else
				cm:remove_effect_bundle_from_region(levels[i].key, region:name());
			end
		end
	end
end

function add_plague_indicator_dummy_effect_listeners()
	core:add_listener(
		"DummyRegionInfectionEvent1",
		"RegionInfectionEvent",
		true,
		function(context)
			if context:is_creation() then
				if context:target_region():has_effect_bundle("wh3_main_plague_present_dummy") == false then
					cm:apply_effect_bundle_to_region("wh3_main_plague_present_dummy", context:target_region():name(), 0);
				end
			elseif context:is_removed() then
				cm:remove_effect_bundle_from_region("wh3_main_plague_present_dummy", context:target_region():name());
			else
			end
		end,
		true
	);
	core:add_listener(
		"DummyRegionInfectionEvent2",
		"RegionPlagueStateChanged",
		true,
		function(context)
			if context:is_infected() then
				if context:region():has_effect_bundle("wh3_main_plague_present_dummy") == false then
					cm:apply_effect_bundle_to_region("wh3_main_plague_present_dummy", context:region():name(), 0);
				end
			else
				cm:remove_effect_bundle_from_region("wh3_main_plague_present_dummy", context:region():name());
			end
		end,
		true
	);
	core:add_listener(
		"DummyRegionInfectionEvent3",
		"RegionTurnStart",
		true,
		function(context)
			local region = context:region();
			local plague = region:get_plague_if_infected();

			if plague:is_null_interface() == false then
				if region:has_effect_bundle("wh3_main_plague_present_dummy") == false then
					cm:apply_effect_bundle_to_region("wh3_main_plague_present_dummy", region:name(), 0);
				end
			else
				cm:remove_effect_bundle_from_region("wh3_main_plague_present_dummy", region:name());
			end
		end,
		true
	);
end