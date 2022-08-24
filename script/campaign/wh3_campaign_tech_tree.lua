local wh3_ancillary_techs = {
	["wh3_main_tech_cth_2"] = "wh3_main_anc_magic_standard_banner_of_feng_shi",
	["wh3_main_tech_cth_22"] = "wh3_main_anc_magic_standard_banner_of_the_moon_empress",
	["wh3_main_tech_cth_50"] = "wh3_main_anc_magic_standard_the_great_celestial_banner",
	["wh3_main_tech_cth_65"] = "wh3_main_anc_magic_standard_banner_of_the_empress_eye",
	["wh3_main_tech_kho_1_5"] = "wh3_main_anc_magic_standard_blood_feasters_banner",
	["wh3_main_tech_kho_3_5"] = "wh3_main_anc_magic_standard_trophy_of_killers",
	["wh3_main_tech_kho_4_3"] = "wh3_main_anc_magic_standard_khornes_gift",
	["wh3_main_tech_kho_6_2"] = "wh3_main_anc_magic_standard_lifetaker_banner",
	["wh3_main_tech_ksl_4_14"] = "wh3_main_anc_magic_standard_banner_of_the_orthodoxy"
};

core:add_listener(
	"tech_researched_ancillary_provided",
	"ResearchCompleted",
	function(context)
		return context:faction():is_human();
	end,
	function(context)
		local ancillary = wh3_ancillary_techs[context:technology()];
			
		if ancillary then
			cm:add_ancillary_to_faction(context:faction(), ancillary, false);
		end;
	end,
	true
);