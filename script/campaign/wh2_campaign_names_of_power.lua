core:add_listener(
	"award_name_of_power",
	"CharacterSkillPointAllocated",
	function(context)
		return not context:character():faction():is_human() and context:skill_point_spent_on():find("wh2_main_skill_def_names_of_power");
	end,
	function(context)
		local traits = nil;
		local skill = context:skill_point_spent_on();
		
		if skill == "wh2_main_skill_def_names_of_power_1" then
			traits = {
				"wh2_main_trait_def_name_of_power_co_01_blackstone",
				"wh2_main_trait_def_name_of_power_co_02_wyrmscale",
				"wh2_main_trait_def_name_of_power_co_03_poisonblade",
				"wh2_main_trait_def_name_of_power_co_04_headreaper",
				"wh2_main_trait_def_name_of_power_co_05_spiteheart",
				"wh2_main_trait_def_name_of_power_co_06_soulblaze",
				"wh2_main_trait_def_name_of_power_co_07_bloodscourge",
				"wh2_main_trait_def_name_of_power_co_08_griefbringer",
				"wh2_main_trait_def_name_of_power_co_09_the_hand_of_wrath",
				"wh2_main_trait_def_name_of_power_co_10_fatedshield",
				"wh2_main_trait_def_name_of_power_co_11_drakecleaver",
				"wh2_main_trait_def_name_of_power_co_12_hydrablood"
			};
		elseif skill == "wh2_main_skill_def_names_of_power_2" then
			traits = {
				"wh2_main_trait_def_name_of_power_ar_01_lifequencher",
				"wh2_main_trait_def_name_of_power_ar_02_the_tempest_of_talons",
				"wh2_main_trait_def_name_of_power_ar_03_shadowdart",
				"wh2_main_trait_def_name_of_power_ar_04_barbstorm",
				"wh2_main_trait_def_name_of_power_ar_05_beastbinder",
				"wh2_main_trait_def_name_of_power_ar_06_fangshield",
				"wh2_main_trait_def_name_of_power_ar_07_wrathbringer",
				"wh2_main_trait_def_name_of_power_ar_08_moonshadow",
				"wh2_main_trait_def_name_of_power_ar_09_granitestance",
				"wh2_main_trait_def_name_of_power_ar_10_the_grey_vanquisher",
				"wh2_main_trait_def_name_of_power_ar_11_krakenclaw",
				"wh2_main_trait_def_name_of_power_ar_12_grimgaze"
			};
		else
			traits = {
				"wh2_main_trait_def_name_of_power_ca_01_dreadtongue",
				"wh2_main_trait_def_name_of_power_ca_02_darkpath",
				"wh2_main_trait_def_name_of_power_ca_03_khainemarked",
				"wh2_main_trait_def_name_of_power_ca_04_the_black_conqueror",
				"wh2_main_trait_def_name_of_power_ca_05_leviathanrage",
				"wh2_main_trait_def_name_of_power_ca_06_emeraldeye",
				"wh2_main_trait_def_name_of_power_ca_07_barbedlash",
				"wh2_main_trait_def_name_of_power_ca_08_pathguard",
				"wh2_main_trait_def_name_of_power_ca_09_the_dark_marshall",
				"wh2_main_trait_def_name_of_power_ca_10_the_dire_overseer",
				"wh2_main_trait_def_name_of_power_ca_11_gatesmiter",
				"wh2_main_trait_def_name_of_power_ca_12_the_tormentor"
			};
		end;
		
		cm:force_add_trait(cm:char_lookup_str(context:character():cqi()), traits[cm:random_number(#traits)]);
	end,
	true
);