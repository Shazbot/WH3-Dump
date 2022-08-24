local tech_tree_lords = {
	-- Raknik Spiderclaw
	["tech_grn_mid_1_1"] = {forename = "names_name_1478382266", surname = "names_name_618498202", subtype = "wh2_dlc15_grn_goblin_great_shaman_raknik", immortal = true},
	-- Oglok the 'Orrible
	["tech_grn_mid_2_1"] = {forename = "names_name_221373666", surname = "names_name_651577131", subtype = "wh2_dlc15_grn_orc_warboss_oglok", immortal = true}
};

function add_tech_tree_lords_listeners()
	out("#### Adding Tech Tree Lords Listeners ####");
	core:add_listener(
		"TechTreeLords_ResearchCompleted",
		"ResearchCompleted",
		function(context)
			return tech_tree_lords[context:technology()] ~= nil and context:faction():is_human()
		end,
		function(context)
			local lord = tech_tree_lords[context:technology()];
			cm:spawn_character_to_pool(context:faction():name(), lord.forename, lord.surname, "", "", 30, true, "general", lord.subtype, lord.immortal, "");
		end,
		true
	);
end