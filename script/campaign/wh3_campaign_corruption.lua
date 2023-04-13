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