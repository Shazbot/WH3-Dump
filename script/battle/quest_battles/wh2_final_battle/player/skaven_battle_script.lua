load_script_libraries();

local file_name, file_path = get_file_name_and_path();
package.path = file_path .. "/?.lua;" .. package.path;
require("battle_declarations");

loading_screen_key = "wh2_main_final_battle_victory_skv";

speech = {};

if ga_player:are_unit_types_in_army("wh2_main_skv_cha_queek_headtaker") then
	speech = {
		{"Play_wh2_main_qb_skv_queek_headtaker_final_battle_pt_01", "wh2_main_qb_skv_queek_headtaker_final_battle_pt_01"},
		{"Play_wh2_main_qb_skv_queek_headtaker_final_battle_pt_02", "wh2_main_qb_skv_queek_headtaker_final_battle_pt_02"},
		{"Play_wh2_main_qb_skv_queek_headtaker_final_battle_pt_03", "wh2_main_qb_skv_queek_headtaker_final_battle_pt_03"},
		{"Play_wh2_main_qb_skv_queek_headtaker_final_battle_pt_04", "wh2_main_qb_skv_queek_headtaker_final_battle_pt_04"},
		{"Play_wh2_main_qb_skv_queek_headtaker_final_battle_pt_05", "wh2_main_qb_skv_queek_headtaker_final_battle_pt_05"}
	};
elseif ga_player:are_unit_types_in_army("wh2_main_skv_cha_lord_skrolk") then
	speech = {
		{"Play_wh2_main_qb_skv_skrolk_final_battle_pt_01", "wh2_main_qb_skv_skrolk_final_battle_pt_01"},
		{"Play_wh2_main_qb_skv_skrolk_final_battle_pt_02", "wh2_main_qb_skv_skrolk_final_battle_pt_02"},
		{"Play_wh2_main_qb_skv_skrolk_final_battle_pt_03", "wh2_main_qb_skv_skrolk_final_battle_pt_03"},
		{"Play_wh2_main_qb_skv_skrolk_final_battle_pt_04", "wh2_main_qb_skv_skrolk_final_battle_pt_04"}
	};
elseif ga_player:are_unit_types_in_army("wh2_dlc09_skv_cha_tretch_craventail") then
	speech = {
		{"Play_wh2_dlc09_qb_skv_tretch_craventail_final_battle_pt_01", "wh2_dlc09_qb_skv_tretch_craventail_final_battle_pt_01"},
		{"Play_wh2_dlc09_qb_skv_tretch_craventail_final_battle_pt_02", "wh2_dlc09_qb_skv_tretch_craventail_final_battle_pt_02"},
		{"Play_wh2_dlc09_qb_skv_tretch_craventail_final_battle_pt_03", "wh2_dlc09_qb_skv_tretch_craventail_final_battle_pt_03"},
		{"Play_wh2_dlc09_qb_skv_tretch_craventail_final_battle_pt_04", "wh2_dlc09_qb_skv_tretch_craventail_final_battle_pt_04"}
	};
elseif ga_player:are_unit_types_in_army("wh2_dlc12_skv_cha_ikit_claw_0","wh2_dlc12_skv_cha_ikit_claw_1", "wh2_dlc12_skv_cha_ikit_claw_2") then
	speech = {
		{"Play_wh2_dlc12_skv_ikit_claw_qb_final_battle_pt_01", "wh2_dlc12_skv_ikit_claw_qb_final_battle_pt_01"},
		{"Play_wh2_dlc12_skv_ikit_claw_qb_final_battle_pt_02", "wh2_dlc12_skv_ikit_claw_qb_final_battle_pt_02"},
		{"Play_wh2_dlc12_skv_ikit_claw_qb_final_battle_pt_03", "wh2_dlc12_skv_ikit_claw_qb_final_battle_pt_03"},
		{"Play_wh2_dlc12_skv_ikit_claw_qb_final_battle_pt_04", "wh2_dlc12_skv_ikit_claw_qb_final_battle_pt_04"},
		{"Play_wh2_dlc12_skv_ikit_claw_qb_final_battle_pt_05", "wh2_dlc12_skv_ikit_claw_qb_final_battle_pt_04"}
	};
end;

--------HORNED RAT VO----------
horned_rat_vo = {
	new_sfx("Play_FinalQ_Horned_Rat_SKV_01"),
	new_sfx("Play_FinalQ_Horned_Rat_SKV_02"),
	new_sfx("Play_FinalQ_Horned_Rat_SKV_03"),
	new_sfx("Play_FinalQ_Horned_Rat_SKV_04"),
	new_sfx("Play_FinalQ_Horned_Rat_SKV_05"),
	new_sfx("Play_FinalQ_Horned_Rat_SKV_06"),
	new_sfx("Play_FinalQ_Horned_Rat_SKV_07"),
	new_sfx("Play_FinalQ_Horned_Rat_SKV_08"),
	new_sfx("Play_FinalQ_Horned_Rat_SKV_09"),
	new_sfx("Play_FinalQ_Horned_Rat_SKV_10"),
	new_sfx("Play_FinalQ_Horned_Rat_SKV_11"),
	new_sfx("Play_FinalQ_Horned_Rat_SKV_12"),
	new_sfx("Play_FinalQ_Horned_Rat_SKV_13"),
	new_sfx("Play_FinalQ_Horned_Rat_SKV_14"),
	new_sfx("Play_FinalQ_Horned_Rat_SKV_15")
};

is_player_skaven = true;

require("battle_core");