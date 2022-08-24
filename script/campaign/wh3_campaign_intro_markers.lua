intro_markers = {
	"ulthuan",

	ulthuan = {
		"tyrion",
		"nkari",

		tyrion = {
			{marker_key = "ie_intro_tyrion_marker_alarielle", x = 258, y = 583, region_key = "wh3_main_combi_region_gaean_vale"},
			{marker_key = "ie_intro_tyrion_marker_caledor", x = 202, y = 517, region_key = "wh3_main_combi_region_vauls_anvil_2"},
			{marker_key = "ie_intro_tyrion_marker_grom", x = 306, y = 511, region_key = "wh3_main_combi_region_shrine_of_loec"},
			{marker_key = "ie_intro_tyrion_marker_nkari", x = 277, y = 637, region_key = "wh3_main_combi_region_shrine_of_kurnous"},
			{marker_key = "ie_intro_tyrion_marker_saphery", x = 292, y = 555, region_key = "wh3_main_combi_region_white_tower_of_hoeth"}
		},
		nkari = {
			{marker_key = "ie_intro_nkari_marker_saphery", x = 296, y = 573, region_key = "wh3_main_combi_region_white_tower_of_hoeth"},
			{marker_key = "ie_intro_nkari_marker_alarielle", x = 258, y = 583, region_key = "wh3_main_combi_region_gaean_vale"},
			{marker_key = "ie_intro_nkari_marker_grom", x = 306, y = 511, region_key = "wh3_main_combi_region_shrine_of_loec"},
			{marker_key = "ie_intro_nkari_marker_tyrion", x = 251, y = 517, region_key = "wh3_main_combi_region_lothern"},
		}
	}
}

function intro_markers:setup_intro_markers()
	for _, theatre_id in ipairs(intro_markers) do
		local faction_markers = intro_markers[theatre_id]

		for _, faction_id in ipairs(faction_markers) do
			local marker_list = faction_markers[faction_id]

			for _, marker_log in ipairs(marker_list) do
				core:add_listener(
					"create_intro_markers",
					"FactionTurnStart",
					function(context)
						local faction_key = THEATRE_DATA.faction_keys[theatre_id][faction_id]
						return context:faction():name() == faction_key and cm:turn_number() == 1
					end,
					function(context)
						local faction_key = THEATRE_DATA.faction_keys[theatre_id][faction_id]
						cm:make_region_seen_in_shroud(faction_key, marker_log.region_key)
						cm:add_interactable_campaign_marker(marker_log.marker_key, marker_log.marker_key, marker_log.x, marker_log.y, 2, faction_key)
					end,
					true
				)
			end
		end
	end
end


function intro_markers:remove_all_markers()
	for _, theatre_id in ipairs(intro_markers) do
		local faction_markers = intro_markers[theatre_id]

		for _, faction_id in ipairs(faction_markers) do
			local marker_list = faction_markers[faction_id]

			for _, marker_log in ipairs(marker_list) do
				core:add_listener(
					"remove_intro_markers",
					"FactionTurnStart",
					function(context)
						local faction_key = THEATRE_DATA.faction_keys[theatre_id][faction_id] 
						return context:faction():name() == faction_key and cm:turn_number() == 3
					end,
					function(context)
						cm:remove_interactable_campaign_marker(marker_log.marker_key)
					end,
					true
				)
			end
		end
	end
end


intro_markers:setup_intro_markers()
intro_markers:remove_all_markers()