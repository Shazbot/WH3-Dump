local vampire_coast_lord_tech_prefix = "wh2_dlc11_tech_cst_admirals";
local vampire_coast_lord_techs = {
	["wh2_dlc11_tech_cst_admirals_01"] = {forename = "names_name_471943374", surname = "", subtype = "wh2_dlc11_cst_admiral_tech_01"},
	["wh2_dlc11_tech_cst_admirals_02"] = {forename = "names_name_119593724", surname = "", subtype = "wh2_dlc11_cst_admiral_tech_02"},
	["wh2_dlc11_tech_cst_admirals_03"] = {forename = "names_name_1954332184", surname = "", subtype = "wh2_dlc11_cst_admiral_tech_03"},
	["wh2_dlc11_tech_cst_admirals_04"] = {forename = "names_name_1995028532", surname = "", subtype = "wh2_dlc11_cst_admiral_tech_04"}
};

local vampire_coast_ancillary_tech_prefix = "wh2_dlc11_tech_cst";
local vampire_coast_ancillary_techs = {
	["wh2_dlc11_tech_cst_firearms_07"] = "wh2_dlc11_anc_follower_cst_powder_monkey",
	["wh2_dlc11_tech_cst_firearms_08"] = "wh2_dlc11_anc_follower_cst_master_gunner",
	["wh2_dlc11_tech_cst_firearms_09"] = "wh2_dlc11_anc_magic_standard_throwing_bombs",
	["wh2_dlc11_tech_cst_vampiric_10"] = "wh2_dlc11_anc_magic_standard_spell_of_the_necromancers_apprentice",
	["wh2_dlc11_tech_cst_vampiric_11"] = "wh2_dlc11_anc_magic_standard_skull_and_crossbones",
	["wh2_dlc11_tech_cst_vampiric_12"] = "wh2_dlc11_anc_follower_cst_carpenter",
	["wh2_dlc11_tech_cst_command_10"] = "wh2_dlc11_anc_follower_cst_quartermaster",
	["wh2_dlc11_tech_cst_command_11"] = "wh2_dlc11_anc_follower_cst_first_mate",
	["wh2_dlc11_tech_cst_command_12"] = "wh2_dlc11_anc_follower_cst_sea_artist",
};

function add_vampire_coast_tech_tree_listeners()
	out("#### Adding Vampire Coast Tech Tree Listeners ####");
	core:add_listener(
		"VampireCoast_ResearchCompleted",
		"ResearchCompleted",
		true,
		function(context)
			VampireCoast_ResearchCompleted(context);
		end,
		true
	);
end

function VampireCoast_ResearchCompleted(context)
	local faction = context:faction();
	local tech_key = context:technology();
	
	if faction:is_human() == true and faction:culture() == "wh2_dlc11_cst_vampire_coast" then
		-- SPAWN LORDS
		if tech_key:starts_with(vampire_coast_lord_tech_prefix) then
			local lord = vampire_coast_lord_techs[tech_key];
			
			if lord ~= nil then
				cm:spawn_character_to_pool(faction:name(), lord.forename, lord.surname, "", "", 50, true, "general", lord.subtype, false, "");
			end
		-- GIVE ANCILLARIES
		elseif tech_key:starts_with(vampire_coast_ancillary_tech_prefix) then
			local ancillary = vampire_coast_ancillary_techs[tech_key];
			
			if ancillary ~= nil then
				cm:add_ancillary_to_faction(faction, ancillary, false);
			end
		end
	end
end