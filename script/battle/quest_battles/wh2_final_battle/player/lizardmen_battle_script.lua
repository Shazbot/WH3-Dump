load_script_libraries();

local file_name, file_path = get_file_name_and_path();
package.path = file_path .. "/?.lua;" .. package.path;
require("battle_declarations");

loading_screen_key = "wh2_main_final_battle_victory_lzd";

speech = {};

if ga_player:are_unit_types_in_army("wh2_main_lzd_cha_lord_mazdamundi_0", "wh2_main_lzd_cha_lord_mazdamundi_1") then
	speech = {
		{"Play_wh2_main_qb_lzd_mazdamundi_final_battle_pt_01", "wh2_main_qb_lzd_mazdamundi_final_battle_pt_01"},
		{"Play_wh2_main_qb_lzd_mazdamundi_final_battle_pt_02", "wh2_main_qb_lzd_mazdamundi_final_battle_pt_02"},
		{"Play_wh2_main_qb_lzd_mazdamundi_final_battle_pt_03", "wh2_main_qb_lzd_mazdamundi_final_battle_pt_03"},
		{"Play_wh2_main_qb_lzd_mazdamundi_final_battle_pt_04", "wh2_main_qb_lzd_mazdamundi_final_battle_pt_04"},
		{"Play_wh2_main_qb_lzd_mazdamundi_final_battle_pt_05", "wh2_main_qb_lzd_mazdamundi_final_battle_pt_05"}
	};
elseif ga_player:are_unit_types_in_army("wh2_main_lzd_cha_kroq_gar_0", "wh2_main_lzd_cha_kroq_gar_1", "wh2_main_lzd_cha_kroq_gar_2", "wh2_main_lzd_cha_kroq_gar_3", "wh2_main_lzd_cha_kroq_gar_4") then
	speech = {
		{"Play_wh2_main_qb_lzd_kroqgar_final_battle_pt_01", "wh2_main_qb_lzd_kroqgar_final_battle_pt_01"},
		{"Play_wh2_main_qb_lzd_kroqgar_final_battle_pt_02", "wh2_main_qb_lzd_kroqgar_final_battle_pt_02"},
		{"Play_wh2_main_qb_lzd_kroqgar_final_battle_pt_03", "wh2_main_qb_lzd_kroqgar_final_battle_pt_03"},
		{"Play_wh2_main_qb_lzd_kroqgar_final_battle_pt_04", "wh2_main_qb_lzd_kroqgar_final_battle_pt_04"}
	};
elseif ga_player:are_unit_types_in_army("wh2_dlc12_lzd_cha_tehenhauin_0", "wh2_dlc12_lzd_cha_tehenhauin_1", "wh2_dlc12_lzd_cha_tehenhauin_2", "wh2_dlc12_lzd_cha_tehenhauin_3") then
	speech = {
		{"Play_wh2_dlc12_lzd_tehenhauin_final_battle_pt_01", "wh2_dlc12_lzd_tehenhauin_final_battle_pt_01"},
		{"Play_wh2_dlc12_lzd_tehenhauin_final_battle_pt_02", "wh2_dlc12_lzd_tehenhauin_final_battle_pt_02"},
		{"Play_wh2_dlc12_lzd_tehenhauin_final_battle_pt_03", "wh2_dlc12_lzd_tehenhauin_final_battle_pt_03"},
		{"Play_wh2_dlc12_lzd_tehenhauin_final_battle_pt_04", "wh2_dlc12_lzd_tehenhauin_final_battle_pt_04"},
		{"Play_wh2_dlc12_lzd_tehenhauin_final_battle_pt_05", "wh2_dlc12_lzd_tehenhauin_final_battle_pt_05"},
	};
elseif ga_player:are_unit_types_in_army("wh2_dlc12_lzd_cha_tiktaqto_0", "wh2_dlc12_lzd_cha_tiktaqto_1") then
	speech = {
		{"Play_wh2_dlc12_lzd_tiktaqto_final_battle_pt_01", "wh2_dlc12_lzd_tiktaqto_final_battle_pt_01"},
		{"Play_wh2_dlc12_lzd_tiktaqto_final_battle_pt_02", "wh2_dlc12_lzd_tiktaqto_final_battle_pt_02"},
		{"Play_wh2_dlc12_lzd_tiktaqto_final_battle_pt_03", "wh2_dlc12_lzd_tiktaqto_final_battle_pt_03"},
		{"Play_wh2_dlc12_lzd_tiktaqto_final_battle_pt_04", "wh2_dlc12_lzd_tiktaqto_final_battle_pt_04"}
	};
end;

gc:force_on_subtitles();

--------HORNED RAT VO----------
horned_rat_vo = {
	new_sfx("Play_FinalQ_Horned_Rat_LZD_01"),
	new_sfx("Play_FinalQ_Horned_Rat_LZD_02"),
	new_sfx("Play_FinalQ_Horned_Rat_LZD_03"),
	new_sfx("Play_FinalQ_Horned_Rat_LZD_04"),
	new_sfx("Play_FinalQ_Horned_Rat_LZD_05"),
	new_sfx("Play_FinalQ_Horned_Rat_LZD_06"),
	--new_sfx("Play_FinalQ_Horned_Rat_LZD_07"),
	new_sfx("Play_FinalQ_Horned_Rat_LZD_08"),
	new_sfx("Play_FinalQ_Horned_Rat_LZD_09"),
	new_sfx("Play_FinalQ_Horned_Rat_LZD_10"),
	new_sfx("Play_FinalQ_Horned_Rat_LZD_11"),
	new_sfx("Play_FinalQ_Horned_Rat_LZD_12"),
	new_sfx("Play_FinalQ_Horned_Rat_LZD_13")
};

require("battle_core");