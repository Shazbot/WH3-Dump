norsca_tech = {
	region_mapping = {
		wh3_main_combi_region_naggarond =			"wh_dlc08_tech_nor_nw_03",
		wh3_main_combi_region_lothern =				"wh_dlc08_tech_nor_nw_05",
		wh3_main_combi_region_hexoatl =				"wh_dlc08_tech_nor_nw_07",
		wh3_main_combi_region_skavenblight =		"wh_dlc08_tech_nor_nw_09",
		wh3_main_combi_region_khemri =				"wh_dlc08_tech_nor_nw_11",
		wh3_main_combi_region_the_awakening = 		"wh_dlc08_tech_nor_nw_21",
		wh3_main_combi_region_couronne = 			"wh_dlc08_tech_nor_other_08",
		wh3_main_combi_region_miragliano =			"wh_dlc08_tech_nor_other_10",
		wh3_main_combi_region_karaz_a_karak =		"wh_dlc08_tech_nor_other_12",
		wh3_main_combi_region_altdorf =				"wh_dlc08_tech_nor_other_15",
		wh3_main_combi_region_castle_drakenhof =	"wh_dlc08_tech_nor_other_17",
		wh3_main_combi_region_black_crag =			"wh_dlc08_tech_nor_other_19",
		wh3_main_combi_region_kislev =				"wh3_main_ie_tech_nor_oldworld_kislev_capital",
		wh3_main_combi_region_wei_jin =				"wh3_main_ie_tech_nor_darklands_cathay_capital"
	},
	norsca_culture_key = "wh_dlc08_nor_norsca"
}

function norsca_tech:add_region_change_listener()
	if cm:is_new_game() then
		for region, technology_key in pairs(self.region_mapping) do
			self:toggle_technology(technology_key)
		end
	end
	
	core:add_listener(
		"norsca_tech_unlock",
		"RegionFactionChangeEvent",
		function(context)
			return self.region_mapping[context:region():name()]
		end,
		function(context)
			local region = context:region()
			local technology_key = self.region_mapping[region:name()]
			local owning_faction = false
			
			if not region:is_abandoned() then
				owning_faction = region:owning_faction()
			end
			
			self:toggle_technology(technology_key, owning_faction)
		end,
		true
	)
end

function norsca_tech:toggle_technology(technology_key, faction)
	-- unlock the technology for the new owner if they are norsca
	if faction and faction:culture() == self.norsca_culture_key then
		cm:unlock_technology(faction:name(), technology_key)
	end
	
	-- lock the technology for every other norsca faction
	local faction_list = cm:model():world():faction_list()
	
	for _, current_faction in model_pairs(faction_list) do
		if current_faction:culture() == self.norsca_culture_key and faction ~= current_faction then
			cm:lock_technology(current_faction:name(), technology_key)
		end
	end
end