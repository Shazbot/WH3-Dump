dragon_graves = {
	location_groups = {
		{"wh3_main_special_dragon_grave_1", "wh3_main_special_dragon_grave_2", "wh3_main_special_dragon_grave_3"},
		{"wh3_main_special_dragon_grave_4", "wh3_main_special_dragon_grave_5", "wh3_main_special_dragon_grave_6"},
		{"wh3_main_special_dragon_grave_7", "wh3_main_special_dragon_grave_8", "wh3_main_special_dragon_grave_9"},
		{"wh3_main_special_dragon_grave_10", "wh3_main_special_dragon_grave_11", "wh3_main_special_dragon_grave_12"},
		{"wh3_main_special_dragon_grave_13", "wh3_main_special_dragon_grave_14", "wh3_main_special_dragon_grave_15"},
		{"wh3_main_special_dragon_grave_16", "wh3_main_special_dragon_grave_17", "wh3_main_special_dragon_grave_18"}
	}
};

function dragon_graves:initialise()
	-- This locks every building apart from one in every group
	if cm:is_new_game() == true then
		local faction_list = cm:model():world():lookup_factions_from_faction_set("wh3_main_vampire_counts_and_nagash");

		for group_index = 1, #self.location_groups do
			if #self.location_groups[group_index] > 1 then
				cm:shuffle_table(self.location_groups[group_index]);

				for building_index = 2, #self.location_groups[group_index] do
					for _, faction in model_pairs(faction_list) do
						local faction_key = faction:name();
						cm:add_event_restricted_building_record_for_faction(self.location_groups[group_index][building_index], faction_key, "");
					end
				end
			end
		end
	end
end