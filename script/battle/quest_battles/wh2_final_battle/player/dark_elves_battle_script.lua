load_script_libraries();

local file_name, file_path = get_file_name_and_path();
package.path = file_path .. "/?.lua;" .. package.path;
require("battle_declarations");

loading_screen_key = "wh2_main_final_battle_victory_def_malekith";

speech = {};

if ga_player:are_unit_types_in_army("wh2_main_def_cha_malekith_0", "wh2_main_def_cha_malekith_1", "wh2_main_def_cha_malekith_2", "wh2_main_def_cha_malekith_3") then
	speech = {
		{"Play_wh2_main_qb_def_malekith_final_battle_pt_01", "wh2_main_qb_def_malekith_final_battle_pt_01"},
		{"Play_wh2_main_qb_def_malekith_final_battle_pt_02", "wh2_main_qb_def_malekith_final_battle_pt_02"},
		{"Play_wh2_main_qb_def_malekith_final_battle_pt_03", "wh2_main_qb_def_malekith_final_battle_pt_03"},
		{"Play_wh2_main_qb_def_malekith_final_battle_pt_04", "wh2_main_qb_def_malekith_final_battle_pt_04"}
	};
elseif ga_player:are_unit_types_in_army("wh2_dlc10_def_cha_crone_0", "wh2_dlc10_def_cha_crone_1", "wh2_dlc10_def_cha_crone_4", "wh2_dlc10_def_cha_crone_5") then
	speech = {
		{"Play_wh2_dlc10_DEF_Hellebron_QB_Final_Battle_001", "wh2_dlc10_qb_def_hellebron_final_battle_pt_01"},
		{"Play_wh2_dlc10_DEF_Hellebron_QB_Final_Battle_002", "wh2_dlc10_qb_def_hellebron_final_battle_pt_02"},
		{"Play_wh2_dlc10_DEF_Hellebron_QB_Final_Battle_003", "wh2_dlc10_qb_def_hellebron_final_battle_pt_03"},
		{"Play_wh2_dlc10_DEF_Hellebron_QB_Final_Battle_004", "wh2_dlc10_qb_def_hellebron_final_battle_pt_04"}
	};	
elseif ga_player:are_unit_types_in_army("wh2_dlc11_def_cha_lokhir_fellheart_0", "wh2_dlc11_def_cha_lokhir_fellheart_1") then
	speech = {
		{"Play_wh2_dlc11_lokhir_fellheart_vortex_final_battle_pt_01", "wh2_dlc11_qb_def_lokhir_final_battle_pt_01"},
		{"Play_wh2_dlc11_lokhir_fellheart_vortex_final_battle_pt_02", "wh2_dlc11_qb_def_lokhir_final_battle_pt_02"},
		{"Play_wh2_dlc11_lokhir_fellheart_vortex_final_battle_pt_03", "wh2_dlc11_qb_def_lokhir_final_battle_pt_03"},
		{"Play_wh2_dlc11_lokhir_fellheart_vortex_final_battle_pt_04", "wh2_dlc11_qb_def_lokhir_final_battle_pt_04"}
	};	
elseif ga_player:are_unit_types_in_army("wh2_main_def_cha_morathi_0", "wh2_main_def_cha_morathi_1") then
	speech = {
		{"Play_wh2_main_qb_def_morathi_final_battle_pt_01", "wh2_main_qb_def_morathi_final_battle_pt_01"},
		{"Play_wh2_main_qb_def_morathi_final_battle_pt_02", "wh2_main_qb_def_morathi_final_battle_pt_02"},
		{"Play_wh2_main_qb_def_morathi_final_battle_pt_03", "wh2_main_qb_def_morathi_final_battle_pt_03"},
		{"Play_wh2_main_qb_def_morathi_final_battle_pt_04", "wh2_main_qb_def_morathi_final_battle_pt_04"}
	};
	
	loading_screen_key = "wh2_main_final_battle_victory_def_morathi";
end;

--------HORNED RAT VO----------
horned_rat_vo = {
	new_sfx("Play_FinalQ_Horned_Rat_DEF_01"),
	new_sfx("Play_FinalQ_Horned_Rat_DEF_02"),
	new_sfx("Play_FinalQ_Horned_Rat_DEF_03"),
	new_sfx("Play_FinalQ_Horned_Rat_DEF_04"),
	new_sfx("Play_FinalQ_Horned_Rat_DEF_05"),
	new_sfx("Play_FinalQ_Horned_Rat_DEF_06"),
	new_sfx("Play_FinalQ_Horned_Rat_DEF_07"),
	new_sfx("Play_FinalQ_Horned_Rat_DEF_08"),
	new_sfx("Play_FinalQ_Horned_Rat_DEF_09"),
	new_sfx("Play_FinalQ_Horned_Rat_DEF_10"),
	new_sfx("Play_FinalQ_Horned_Rat_DEF_11"),
	new_sfx("Play_FinalQ_Horned_Rat_DEF_12"),
	new_sfx("Play_FinalQ_Horned_Rat_DEF_13"),
	new_sfx("Play_FinalQ_Horned_Rat_DEF_14")
};

require("battle_core");