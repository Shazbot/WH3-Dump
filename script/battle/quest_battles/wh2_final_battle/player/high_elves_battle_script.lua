load_script_libraries();

local file_name, file_path = get_file_name_and_path();
package.path = file_path .. "/?.lua;" .. package.path;
require("battle_declarations");

loading_screen_key = "wh2_main_final_battle_victory_hef";

speech = {};

if ga_player:are_unit_types_in_army("wh2_main_hef_cha_tyrion_0", "wh2_main_hef_cha_tyrion_1") then
	speech = {
		{"Play_wh2_main_qb_hef_tyrion_final_battle_pt_01", "wh2_main_qb_hef_tyrion_final_battle_pt_01"},
		{"Play_wh2_main_qb_hef_tyrion_final_battle_pt_02", "wh2_main_qb_hef_tyrion_final_battle_pt_02"},
		{"Play_wh2_main_qb_hef_tyrion_final_battle_pt_03", "wh2_main_qb_hef_tyrion_final_battle_pt_03"},
		{"Play_wh2_main_qb_hef_tyrion_final_battle_pt_04", "wh2_main_qb_hef_tyrion_final_battle_pt_04"}
	};
elseif ga_player:are_unit_types_in_army("wh2_main_hef_cha_teclis_0", "wh2_main_hef_cha_teclis_1") then
	speech = {
		{"Play_wh2_main_qb_hef_teclis_final_battle_pt_01", "wh2_main_qb_hef_teclis_final_battle_pt_01"},
		{"Play_wh2_main_qb_hef_teclis_final_battle_pt_02", "wh2_main_qb_hef_teclis_final_battle_pt_02"},
		{"Play_wh2_main_qb_hef_teclis_final_battle_pt_03", "wh2_main_qb_hef_teclis_final_battle_pt_03"},
		{"Play_wh2_main_qb_hef_teclis_final_battle_pt_04", "wh2_main_qb_hef_teclis_final_battle_pt_04"}
	};
elseif ga_player:are_unit_types_in_army("wh2_dlc10_hef_cha_alith_anar_0") then
	speech = {
		{"Play_wh2_dlc10_HEF_Alith_Anar_QB_Final_Battle_pt_1", "wh2_dlc10_qb_hef_alith_anar_final_battle_pt_01"},
		{"Play_wh2_dlc10_HEF_Alith_Anar_QB_Final_Battle_pt_2", "wh2_dlc10_qb_hef_alith_anar_final_battle_pt_02"},
		{"Play_wh2_dlc10_HEF_Alith_Anar_QB_Final_Battle_pt_3", "wh2_dlc10_qb_hef_alith_anar_final_battle_pt_03"},
		{"Play_wh2_dlc10_HEF_Alith_Anar_QB_Final_Battle_pt_4", "wh2_dlc10_qb_hef_alith_anar_final_battle_pt_04"}
	};
elseif ga_player:are_unit_types_in_army("wh2_dlc10_hef_cha_alarielle_the_radiant_0", "wh2_dlc10_hef_cha_alarielle_the_radiant_1", "wh2_dlc10_hef_cha_alarielle_the_radiant_2", "wh2_dlc10_hef_cha_alarielle_the_radiant_3") then
	speech = {
		{"Play_wh2_dlc10_HEF_Alarielle_QB_Final_Battle_pt_01", "wh2_dlc10_qb_hef_alarielle_final_battle_pt_01"},
		{"Play_wh2_dlc10_HEF_Alarielle_QB_Final_Battle_pt_02", "wh2_dlc10_qb_hef_alarielle_final_battle_pt_02"},
		{"Play_wh2_dlc10_HEF_Alarielle_QB_Final_Battle_pt_03", "wh2_dlc10_qb_hef_alarielle_final_battle_pt_03"},
		{"Play_wh2_dlc10_HEF_Alarielle_QB_Final_Battle_pt_04", "wh2_dlc10_qb_hef_alarielle_final_battle_pt_04"}
	};	
end;

--------HORNED RAT VO----------
horned_rat_vo = {
	new_sfx("Play_FinalQ_Horned_Rat_HEF_01"),
	new_sfx("Play_FinalQ_Horned_Rat_HEF_02"),
	new_sfx("Play_FinalQ_Horned_Rat_HEF_03"),
	new_sfx("Play_FinalQ_Horned_Rat_HEF_04"),
	new_sfx("Play_FinalQ_Horned_Rat_HEF_05"),
	new_sfx("Play_FinalQ_Horned_Rat_HEF_06"),
	new_sfx("Play_FinalQ_Horned_Rat_HEF_07"),
	new_sfx("Play_FinalQ_Horned_Rat_HEF_08"),
	new_sfx("Play_FinalQ_Horned_Rat_HEF_09"),
	new_sfx("Play_FinalQ_Horned_Rat_HEF_10"),
	new_sfx("Play_FinalQ_Horned_Rat_HEF_11"),
	new_sfx("Play_FinalQ_Horned_Rat_HEF_12"),
	new_sfx("Play_FinalQ_Horned_Rat_HEF_13"),
	new_sfx("Play_FinalQ_Horned_Rat_HEF_14")
};

require("battle_core");