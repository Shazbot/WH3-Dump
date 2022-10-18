local vampire_coast_lord_tech_prefix = "wh2_dlc11_tech_cst_admirals";
local vampire_coast_lord_techs = {
	["wh2_dlc11_tech_cst_admirals_01"] = {forename = "names_name_471943374", surname = "", subtype = "wh2_dlc11_cst_admiral_tech_01"},
	["wh2_dlc11_tech_cst_admirals_02"] = {forename = "names_name_119593724", surname = "", subtype = "wh2_dlc11_cst_admiral_tech_02"},
	["wh2_dlc11_tech_cst_admirals_03"] = {forename = "names_name_1954332184", surname = "", subtype = "wh2_dlc11_cst_admiral_tech_03"},
	["wh2_dlc11_tech_cst_admirals_04"] = {forename = "names_name_1995028532", surname = "", subtype = "wh2_dlc11_cst_admiral_tech_04"}
};

function add_vampire_coast_tech_tree_listeners()
	out("#### Adding Vampire Coast Tech Tree Listeners ####");
	core:add_listener(
		"VampireCoast_ResearchCompleted",
		"ResearchCompleted",
		true,
		function(context)
			local faction = context:faction();
			local tech_key = context:technology();
			
			if faction:is_human() == true and faction:culture() == "wh2_dlc11_cst_vampire_coast" then
				-- SPAWN LORDS
				if tech_key:starts_with(vampire_coast_lord_tech_prefix) then
					local lord = vampire_coast_lord_techs[tech_key];
					
					if lord ~= nil then
						cm:spawn_character_to_pool(faction:name(), lord.forename, lord.surname, "", "", 50, true, "general", lord.subtype, false, "");
					end
				end
			end
		end,
		true
	);
end