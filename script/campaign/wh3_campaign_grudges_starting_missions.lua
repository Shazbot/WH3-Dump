-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	THE GREAT SCRIPT OF GRUDGES - STARTING MISSIONS
--	This script handles the starting missions
--	The triggering, tracking and completion
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------

---------------------------------------------------
---------------------- Data -----------------------
---------------------------------------------------

starting_grudge_missions = {
	dwarf_culture = "wh_main_dwf_dwarfs",

	-- Starting grudges for Legendary Lords
	faction_missions = {
		main_warhammer = {
			wh_main_dwf_dwarfs = {
				"wh2_dlc17_grudge_legendary_enemy_skarsnik",
				"wh2_dlc17_grudge_legendary_enemy_queek",
			},
			wh_main_dwf_karak_kadrin = {
				"wh3_dlc21_grudge_legendary_enemy_throt",
			},
			wh_main_dwf_karak_izor = {
				"wh_dlc06_grudge_belegar_eight_peaks",
				"wh_main_grudge_the_dragonback_grudge",
				"wh2_dlc17_grudge_legendary_enemy_skarsnik",
				"wh2_dlc17_grudge_legendary_enemy_queek",
			},
			wh3_main_dwf_the_ancestral_throng = {
				"wh3_main_grudge_legendary_grombrindal",
				"wh2_dlc17_grudge_legendary_enemy_high_elves",
				"wh2_dlc17_grudge_legendary_enemy_dark_elves",
			},
			wh2_dlc17_dwf_thorek_ironbrow = {
				"wh2_dlc17_main_grudge_legendary_artefact_beard_rings_of_grimnir",
				"wh2_dlc17_main_grudge_legendary_artefact_blessed_pick_of_grungni",
				"wh2_dlc17_main_grudge_legendary_artefact_keepsake_of_gazuls_favoured",
				"wh2_dlc17_main_grudge_legendary_artefact_lost_gifts_of_valaya",
				"wh2_dlc17_main_grudge_legendary_artefact_morgrims_gears_of_war",
				"wh2_dlc17_main_grudge_legendary_artefact_ratons_collar_of_bestial_control",
				"wh2_dlc17_main_grudge_legendary_artefact_smednirs_metallurgy_cipher",
				"wh2_dlc17_main_grudge_legendary_artefact_thungnis_tongs_of_the_runesmith",
			},
			wh3_dlc25_dwf_malakai = {
				"wh3_dlc25_grudge_legendary_settlement_karak_dum_ie"
			},
		},
		wh3_main_chaos = {
			wh3_dlc25_dwf_malakai = {
				"wh3_dlc25_grudge_legendary_settlement_karak_dum",
			},
		}
	},
}


function starting_grudge_missions:initialise()
	if cm:is_new_game() then
		local campaign = cm:get_campaign_name()
		local playable_dwarf_factions = cm:get_human_factions_of_culture(self.dwarf_culture)

		local mission_list = self.faction_missions[campaign]
		for _,faction in ipairs(playable_dwarf_factions) do
			local missions_for_faction = mission_list[faction]
			for j = 1, #missions_for_faction do
				cm:trigger_mission(faction, missions_for_faction[j])
			end
		end
	end
end