-- initiative unlocking system
initiative_unlock = {
	cm = false,
	initiative_key = "",
	event = "",
	condition = false
};

initiative_cultures = {
	wh3_main_ogr_ogre_kingdoms = true,
	wh_main_chs_chaos = true
}

local all_ror_units = {}

initiative_templates = {

	-- OGRE BIG NAMES - LEGENDARY CHARACTERS
	-- GREASUS - GATECRASHER - Win a siege battle.
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_greasus_gatecrasher",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return context:character():won_battle() and cm:model():pending_battle():battle_type() == "settlement_standard"
			end,
		["grant_immediately"] = true
	},
	-- GREASUS - HOARDMASTER - End your turn 5k+ per turn income.
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_greasus_hoardmaster",
		["event"] = "CharacterTurnStart",
		["condition"] =
			function(context)
				return context:character():faction():net_income() > 5000
			end,
		["grant_immediately"] = true
	},
	-- GREASUS - SHOCKINGLY OBESE - End your turn with over 1000 meat.
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_greasus_shockingly_obese",
		["event"] = "CharacterTurnEnd",
		["condition"] =
			function(context)
				local character = context:character()
				local mf = false
				if character:has_military_force() then 
					local meat = character:military_force():pooled_resource_manager():resource("wh3_main_ogr_meat")
					return not meat:is_null_interface() and meat:value() > 1000
				end
			end,
		["grant_immediately"] = true
	},
	-- GREASUS - DRAKECRUSH - Win a battle against an army with a dragon.
	{
		["initiative_key"] = "wh3_dlc26_character_initiative_ogr_big_name_greasus_drakecrush",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character()	
				local units_to_defeat = {
					"wh2_main_hef_mon_moon_dragon",
					"wh2_main_hef_mon_star_dragon",
					"wh2_main_hef_mon_sun_dragon",
					"wh_dlc05_wef_forest_dragon_0",
					"wh2_main_def_mon_black_dragon",
					"wh2_dlc15_grn_mon_wyvern_waaagh_0",
					"wh_dlc08_nor_mon_frost_wyrm_0",
					"wh_dlc08_nor_mon_frost_wyrm_ror_0",
					--mounts
					"wh2_dlc10_def_cha_supreme_sorceress_beasts_5",
					"wh2_dlc10_def_cha_supreme_sorceress_dark_5",
					"wh2_dlc10_def_cha_supreme_sorceress_death_5",
					"wh2_dlc10_def_cha_supreme_sorceress_fire_5",
					"wh2_dlc10_def_cha_supreme_sorceress_shadow_5",
					"wh2_dlc11_def_cha_lokhir_fellheart_1",
					"wh2_dlc11_vmp_cha_bloodline_blood_dragon_lord_1",
					"wh2_dlc11_vmp_cha_bloodline_blood_dragon_lord_3",
					"wh2_dlc11_vmp_cha_bloodline_lahmian_lord_3",
					"wh2_dlc11_vmp_cha_bloodline_necrarch_lord_3",
					"wh2_dlc11_vmp_cha_bloodline_von_carstein_lord_3",
					"wh2_dlc15_hef_cha_imrik_2",
					"wh2_dlc15_hef_cha_mage_fire_3",
					"wh2_main_def_cha_dreadlord_4",
					"wh2_main_def_cha_dreadlord_female_4",
					"wh2_main_def_cha_malekith_3",
					"wh2_main_hef_cha_alastar_4",
					"wh2_main_hef_cha_alastar_5",
					"wh2_main_hef_cha_prince_4",
					"wh2_main_hef_cha_prince_5",
					"wh2_main_hef_cha_princess_4",
					"wh2_main_hef_cha_princess_5",
					"wh_dlc01_chs_cha_chaos_lord_2",
					"wh_dlc01_chs_cha_chaos_sorcerer_lord_death_10",
					"wh_dlc01_chs_cha_chaos_sorcerer_lord_fire_10",
					"wh_dlc01_chs_cha_chaos_sorcerer_lord_metal_10",
					"wh_dlc01_chs_cha_chaos_sorcerer_lord_shadows_4",
					"wh_dlc05_vmp_cha_red_duke_3",
					"wh_dlc05_wef_cha_female_glade_lord_3",
					"wh_dlc05_wef_cha_glade_lord_3",
					"wh_dlc08_chs_cha_chaos_lord_2_qb",
					"wh_dlc08_nor_cha_kihar_0",
					"wh_main_vmp_cha_mannfred_von_carstein_3",
					"wh_main_vmp_cha_vampire_lord_3",
					"wh2_dlc15_hef_cha_archmage_beasts_4",
					"wh2_dlc15_hef_cha_archmage_death_4",
					"wh2_dlc15_hef_cha_archmage_fire_4",
					"wh2_dlc15_hef_cha_archmage_heavens_4",
					"wh2_dlc15_hef_cha_archmage_high_4",
					"wh2_dlc15_hef_cha_archmage_life_4",
					"wh2_dlc15_hef_cha_archmage_light_4",
					"wh2_dlc15_hef_cha_archmage_metal_4",
					"wh2_dlc15_hef_cha_archmage_shadows_4",
					"wh_main_grn_cha_azhag_the_slaughterer_1",
					"wh_main_grn_cha_orc_warboss_1",
					"wh2_dlc16_wef_cha_sisters_of_twilight_1",
					"wh2_twa03_def_cha_rakarth_3",
					"wh3_main_cth_cha_iron_dragon_0",
					"wh3_main_cth_cha_iron_dragon_1",
					"wh3_main_cth_cha_storm_dragon_0",
					"wh3_main_cth_cha_storm_dragon_1",
					"wh3_dlc24_cth_cha_yuan_bo_dragon",
					"wh3_dlc24_cth_cha_yuan_bo_human"
				}
				return character:won_battle() and cm:character_won_battle_against_unit(character, units_to_defeat)
			end,
		["grant_immediately"] = true
	},
	-- SKRAG - EVER-FAMISHED - End your turn with Starving Hunger level
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_skrag_ever_famished",
		["event"] = "CharacterTurnEnd",
		["condition"] =
			function(context)
				local character = context:character()
				local mf = false
				if character:has_military_force() then 
					local active_effect = character:military_force():pooled_resource_manager():resource("wh3_main_ogr_meat"):active_effect(0)
					return active_effect == "wh3_dlc26_bundle_ogr_hunger_1"
				end

			end,
		["grant_immediately"] = true
	},
	-- SKRAG - GORE-HARVESTER - Win a battle against an army with trolls.
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_skrag_gore_harvester",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character()	
				local units_to_defeat = {
					"wh2_dlc15_grn_cha_river_troll_hag_0",
					"wh2_dlc15_grn_mon_river_trolls_0",
					"wh2_dlc15_grn_mon_river_trolls_ror_0",
					"wh2_dlc15_grn_mon_stone_trolls_0",
					"wh3_dlc25_nur_mon_bile_trolls",
					"wh_dlc01_chs_mon_trolls_1",
					"wh_dlc08_nor_cha_throgg_0",
					"wh_dlc08_nor_mon_norscan_ice_trolls_0",
					"wh_main_chs_mon_trolls",
					"wh_main_grn_mon_trolls",
					"wh_main_nor_mon_chaos_trolls",
				}
				return character:won_battle() and cm:character_won_battle_against_unit(character, units_to_defeat)
			end,
		["grant_immediately"] = true
	},
	-- SKRAG - MAW-THAT-WALKS - Have all 4 Offerings to Maw active at once.
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_skrag_maw_that_walks",
		["event"] = "CharacterTurnEnd",
		["condition"] =
			function(context)
				local character_details = context:character():family_member():character_details()
				local offerrings_count = 0
				for i = 1, 4 do
					local initiative_set = character_details:lookup_character_initiative_set_by_key("wh3_dlc26_character_initiative_set_ogr_maw_offering_" .. i)
					if not initiative_set:is_null_interface() and initiative_set:active_initiatives():num_items() >= 1 then
						offerrings_count = offerrings_count + 1
					end
				end
				return offerrings_count >= 4
			end,
		["grant_immediately"] = true
	},
	-- SKRAG - WORLD-SWALLOWER - Use the "Maw" spell 3 times in a single battle.
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_skrag_world_swallower",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local pb = cm:model():pending_battle()
				local character = context:character()
				local character_faction_cqi = character:faction():command_queue_index()

				local maw_count = pb:get_how_many_times_ability_has_been_used_in_battle(character_faction_cqi, "wh3_main_spell_great_maw_the_maw")
				local maw_upgraded_count = pb:get_how_many_times_ability_has_been_used_in_battle(character_faction_cqi, "wh3_main_spell_great_maw_the_maw_upgraded")

				return (maw_count + maw_upgraded_count) >= 3
			end,
		["grant_immediately"] = true
	},
	-- GOLGFAG - BARRELCRUSHER - Win a battle in a region with Wine resource.
	{
		["initiative_key"] = "wh3_dlc26_character_initiative_ogr_big_name_golgfag_01",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character()

				return character:won_battle() and character:has_region() and character:region():resource_exists("res_rom_wine")
			end,
		["grant_immediately"] = true
	},
	-- GOLGFAG - GLOBETROTTER - End turn in Full Speed stance
	{
		["initiative_key"] = "wh3_dlc26_character_initiative_ogr_big_name_golgfag_02",
		["event"] = "CharacterTurnEnd",
		["condition"] =
			function(context)
				local character = context:character()
				
				return character:has_military_force() and character:military_force():active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_DOUBLE_TIME"				
			end,
		["grant_immediately"] = true
	},
	-- GOLGFAG - MANEATER - Win a battle against human factions.
	{
		["initiative_key"] = "wh3_dlc26_character_initiative_ogr_big_name_golgfag_03",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return cm:character_won_battle_against_culture(context:character(), {"wh_main_emp_empire", "wh_main_brt_bretonnia", "wh3_main_ksl_kislev", "wh3_main_cth_cathay"})
			end,
		["grant_immediately"] = true
	},
	-- GOLGFAG - TALE SPINNER - Win a battle with 4 Regiments of Renown.
	{
		["initiative_key"] = "wh3_dlc26_character_initiative_ogr_big_name_golgfag_04",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character()
				return character:won_battle() and cm:count_char_army_has_unit(character, all_ror_units) >= 4
			end,
		["grant_immediately"] = true
	},
	-- BRAGG - GUTSMAN - End your turn as highest ranking character in force.
	{
		["initiative_key"] = "wh3_dlc26_character_initiative_ogr_big_name_bragg_01",
		["event"] = "CharacterTurnEnd",
		["condition"] =
			function(context)
				local character = context:character()
				local character_rank = context:character():rank()
				local highest_rank = true
				if character:is_embedded_in_military_force() then 
					local character_list = character:embedded_in_military_force():character_list()
					for i = 0, character_list:num_items() - 1 do
						if not (character_list:item_at(i) == character) then
							if character_list:item_at(i):rank() >= character_rank then
								highest_rank = false
							end
						end
					end
				else
					highest_rank = false
				end
				return highest_rank
			end,
		["grant_immediately"] = true
	},
	-- BRAGG - EXECUTIONER - Win a battle against an army with 3 characters.
	{
		["initiative_key"] = "wh3_dlc26_character_initiative_ogr_big_name_bragg_02",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				
				if character:won_battle() then
					local character_faction_name = character:faction():name();
					local pb = cm:model():pending_battle();
					
					local defender_char_cqi, defender_mf_cqi, defender_faction_name = cm:pending_battle_cache_get_defender(1);
					local attacker_char_cqi, attacker_mf_cqi, attacker_faction_name = cm:pending_battle_cache_get_attacker(1);

					if defender_faction_name == character_faction_name then
						return cm:pending_battle_cache_num_attacker_embedded_characters() > 1
					elseif attacker_faction_name == character_faction_name then
						return cm:pending_battle_cache_num_defender_embedded_characters() > 1
					end
				end;
			end,
		["grant_immediately"] = true
	},
	-- BRAGG - KIN FEARED - Win a battle against Ogre Kingdoms.
	{
		["initiative_key"] = "wh3_dlc26_character_initiative_ogr_big_name_bragg_03",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return cm:character_won_battle_against_culture(context:character(), "wh3_main_ogr_ogre_kingdoms", "_ogr_")
			end,
		["grant_immediately"] = true
	},
	-- BRAGG - HEROSLAYER - Critically Succeed at Assassinating a character
	{
		["initiative_key"] = "wh3_dlc26_character_initiative_ogr_big_name_bragg_04",
		["event"] = "CharacterCharacterTargetAction",
		["condition"] =
			function(context)
				return ( context:mission_result_critial_success() and context:agent_action_key() == "wh2_main_agent_action_champion_hinder_agent_assassinate")
			end,
		["grant_immediately"] = true
	},
	-- OGRE BIG NAMES - GENERIC CHARACTERS
	-- ARSEBELCHER - Occupy a settlement with a Chaotic Wasteland climate.
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_arsebelcher",
		["event"] = "GarrisonOccupiedEvent",
		["condition"] =
			function(context)
				return context:garrison_residence():region():settlement():get_climate() == "climate_chaotic";
			end,
		["grant_immediately"] = true
	},
	-- BEASTKILLER - Win a battle against an army containing 3 monster units.
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_beastkiller",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character()
				local monster_count = 0
				if character:won_battle() then
					local defender_char_cqi, defender_mf_cqi, defender_faction_name = cm:pending_battle_cache_get_defender(1)
					local attacker_char_cqi, attacker_mf_cqi, attacker_faction_name = cm:pending_battle_cache_get_attacker(1)
					local character_faction_name = character:faction():name()
					local is_attacker = attacker_faction_name == character_faction_name
					local is_defender = defender_faction_name == character_faction_name
					
					if is_attacker or is_defender then
						local num_participants = 0
						local monster_count = 0
						if is_attacker then
							num_participants = cm:pending_battle_cache_num_defenders()
						else
							num_participants = cm:pending_battle_cache_num_attackers()
						end						
						
						for i = 1, num_participants do
							local units = {}
							
							if is_attacker then
								units = cm:pending_battle_cache_get_defender_units(i)
							else
								units = cm:pending_battle_cache_get_attacker_units(i)
							end
							
							for j = 1, #units do
								if common.get_context_value("CcoMainUnitRecord", units[j].unit_key, "CategoryName") == "Monster" then
									monster_count = monster_count + 1									
									if monster_count > 0 then
										return true
									end
								end
							end
						end
					end
				end
			end,
		["grant_immediately"] = true
	},
	-- BELLYSLAPPER - Reach rank 15.
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_bellyslapper",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():rank() >= 15
			end,
		["grant_immediately"] = true
	},
	-- BIGBELLOWER - Win a battle whilst being reinforced.
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_bigbellower",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character()
				local faction_name = character:faction():name()
				return character:won_battle() and ((cm:pending_battle_cache_faction_is_attacker(faction_name) and cm:pending_battle_cache_num_attackers() > 1) or (cm:pending_battle_cache_faction_is_defender(faction_name) and cm:pending_battle_cache_num_defenders() > 1))
			end,
		["grant_immediately"] = true
	},
	-- BONECHEWER - Win a battle with 5 units of Sabretusks in your army.
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_bonechewer",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character()				
				return character:won_battle() and cm:count_char_army_has_unit(character, "wh3_main_ogr_mon_sabretusk_pack_0") > 4
			end,
		["grant_immediately"] = true
	},
	-- BOOMMAKER - Win a battle with 5 units of Leadbelchers in your army.
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_boommaker",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character()				
				return character:won_battle() and cm:count_char_army_has_unit(character, "wh3_main_ogr_inf_leadbelchers_0") > 4
			end,
		["grant_immediately"] = true
	},
	-- BRAWLERGUTS - Win 5 battles.
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_brawlerguts",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character()				
				return character:won_battle() and character:battles_won() > 4
			end,
		["grant_immediately"] = true
	},
	-- CAMPMAKER - Deploy a camp from this character.
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_campmaker",
		["event"] = "SpawnableForceCreatedEvent",
		["condition"] =
			function(context)
				return true
			end,
		["grant_immediately"] = true
	},
	-- COIN COUNTER - End your turn with over 3000 upkeep for this army.
	{
		["initiative_key"] = "wh3_dlc26_character_initiative_ogr_big_name_coin_counter",
		["event"] = "CharacterTurnEnd",
		["condition"] =
			function(context)
				local character = context:character()
				if character:has_military_force() then
					return character:military_force():upkeep() > 3000
				end
			end,
		["grant_immediately"] = true
	},
	-- DAEMONBREAKER - Win a battle against any Daemon race.
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_daemonbreaker",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character()				
				return cm:character_won_battle_against_culture(character, {"wh3_main_kho_khorne", "wh3_main_nur_nurgle", "wh3_main_tze_tzeentch", "wh3_main_sla_slaanesh", "wh3_main_dae_daemons"})
			end,
		["grant_immediately"] = true
	},
	-- DEATHCHEATER - Win a battle against multiple armies.
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_deathcheater",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character()				
				return character:won_battle() and ((cm:pending_battle_cache_faction_is_attacker(character:faction():name()) and cm:pending_battle_cache_num_defenders() > 1) or cm:pending_battle_cache_num_attackers() > 1)
			end,
		["grant_immediately"] = true
	},
	-- DWARFSQUASHER - Win a battle against Dwarfs.
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_dwarfsquasher",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return cm:character_won_battle_against_culture(context:character(), "wh_main_dwf_dwarfs", "_dwf_")
			end,
		["grant_immediately"] = true
	},
	-- ELFMULCHER - Win a battle against Wood Elves, High Elves or Dark Elves.
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_elfmulcher",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return cm:character_won_battle_against_culture(context:character(), {"wh2_main_hef_high_elves", "wh_dlc05_wef_wood_elves", "wh2_main_def_dark_elves"})
			end,
		["grant_immediately"] = true
	},
	-- GNOBLARKICKER - Win a battle with 10 Gnoblar units in your army.
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_gnoblarkicker",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character()	
				local gnoblars = {
					"wh3_main_ogr_inf_gnoblars_0","wh3_main_ogr_inf_gnoblars_1","wh3_twa10_ogr_inf_gnoblars_ror","wh3_main_ogr_inf_gnoblars_flingers",
					"wh3_dlc26_ogr_inf_pigback_riders","wh3_dlc26_ogr_inf_pigback_riders_ror"
				}
				return character:won_battle() and cm:count_char_army_has_unit(character, gnoblars) > 9
			end,
		["grant_immediately"] = true
	},
	-- GOLDHOARDER - Sack a settlement with this character.
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_goldhoarder",
		["event"] = "CharacterSackedSettlement",
		["condition"] =
			function()
				return true
			end,
		["grant_immediately"] = true
	},
	-- GRANDFEASTER - Raze a settlement with this character.
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_grandfeaster",
		["event"] = "CharacterRazedSettlement",
		["condition"] =
			function()
				return true
			end,
		["grant_immediately"] = true
	},
	-- GROUNDBREAKER - Rank-up in Raiding stance.
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_groundbreaker",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character()
				if character:has_military_force() then
					local mf = character:military_force()
					return (mf:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_SET_CAMP_RAIDING" or mf:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID")
				end;
			end,
		["grant_immediately"] = true
	},
	-- GROUNDSHAKER - Win a battle with 5 Crushers units in your army.
	{
		["initiative_key"] = "wh3_dlc26_character_initiative_ogr_big_name_groundshaker",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character()		
				local crushers = {
					"wh3_main_ogr_cav_crushers_0","wh3_main_ogr_cav_crushers_1","wh3_twa07_ogr_cav_crushers_ror_0",
				}		
				return character:won_battle() and cm:count_char_army_has_unit(character, crushers) > 4
			end,
		["grant_immediately"] = true
	},
	-- GORE-DRENCHED - Win a battle with a Pyrric victory.
	{
		["initiative_key"] = "wh3_dlc26_character_initiative_ogr_big_name_gore_drenched",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				if context:character():won_battle() then
					local pb = cm:model():pending_battle()					
					return (pb:attacker_won() and pb:attacker_battle_result() == "pyrrhic_victory") or  (pb:defender_won() and pb:defender_battle_result() == "pyrrhic_victory")
				end
			end,
		["grant_immediately"] = true
	},
	-- GORGER HERDER - Win a battle with 5 Gorgers units in your army.
	{
		["initiative_key"] = "wh3_dlc26_character_initiative_ogr_big_name_gorger_herder",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character()		
				return character:won_battle() and cm:count_char_army_has_unit(character, "wh3_main_ogr_mon_gorgers_0") > 4
			end,
		["grant_immediately"] = true
	},
	-- GUTCRUSHER - Win a battle with 2500 kills.
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_gutcrusher",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character()
				
				if character:won_battle() then
					local character_faction_name = character:faction():name()
					local pb = cm:model():pending_battle()					
					local defender_char_cqi, defender_mf_cqi, defender_faction_name = cm:pending_battle_cache_get_defender(1)
					local attacker_char_cqi, attacker_mf_cqi, attacker_faction_name = cm:pending_battle_cache_get_attacker(1)
					
					if attacker_faction_name == character_faction_name then
						return pb:attacker_kills() > 2500
					elseif defender_faction_name == character_faction_name then
						return pb:defender_kills() > 2500
					end
				end
			end,
		["grant_immediately"] = true
	},
	-- IMPENETRABLE GUT - Win a battle against an army containing 5 missile units.
	{
		["initiative_key"] = "wh3_dlc26_character_initiative_ogr_big_name_impenetrable_gut",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character()
				
				if character:won_battle() then
					local defender_char_cqi, defender_mf_cqi, defender_faction_name = cm:pending_battle_cache_get_defender(1)
					local attacker_char_cqi, attacker_mf_cqi, attacker_faction_name = cm:pending_battle_cache_get_attacker(1)
					local character_faction_name = character:faction():name()
					local is_attacker = attacker_faction_name == character_faction_name
					local is_defender = defender_faction_name == character_faction_name
					
					if is_attacker or is_defender then
						local unit_class_inf_localised = common.get_localised_string("unit_class_onscreen_inf_mis")
						local unit_class_cav_localised = common.get_localised_string("unit_class_onscreen_cav_mis")
						local unit_class_art_localised = common.get_localised_string("unit_class_onscreen_art_fld")
						local num_participants = 0
						
						if is_attacker then
							num_participants = cm:pending_battle_cache_num_defenders()
						else
							num_participants = cm:pending_battle_cache_num_attackers()
						end
						
						local count = 0
						
						for i = 1, num_participants do
							local units = {}
							
							if is_attacker then
								units = cm:pending_battle_cache_get_defender_units(i)
							else
								units = cm:pending_battle_cache_get_attacker_units(i)
							end
							
							for j = 1, #units do
								local unit_class = common.get_context_value("CcoMainUnitRecord", units[j].unit_key, "ClassName")
								if unit_class == unit_class_inf_localised  or unit_class == unit_class_cav_localised or unit_class == unit_class_art_localised then
									count = count + 1
									
									if count > 4 then
										return true
									end
								end
							end
						end
					end
				end
			end,
		["grant_immediately"] = true
	},
	-- KINEATER - End your turn in a friendly region with less than -50 Control.
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_kineater",
		["event"] = "CharacterTurnEnd",
		["condition"] =
			function(context)
				local character = context:character()
				local region = character:region()
				
				if region:is_null_interface() == false then
					local region_faction = region:owning_faction()

					if region_faction:is_null_interface() == false then
						if region_faction:is_faction(character:faction()) then
							return region:public_order() < -50
						end
					end
				else
					return false
				end

			end,
		["grant_immediately"] = true
	},
	-- KIN-GUARD - Win a battle with another hero in your army.
	{
		["initiative_key"] = "wh3_dlc26_character_initiative_ogr_big_name_kin_guard",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character()
				
				if character:won_battle() then
					local character_faction_name = character:faction():name()
					local pb = cm:model():pending_battle()					
					local defender_char_cqi, defender_mf_cqi, defender_faction_name = cm:pending_battle_cache_get_defender(1)
					local attacker_char_cqi, attacker_mf_cqi, attacker_faction_name = cm:pending_battle_cache_get_attacker(1)
					
					if defender_faction_name == character_faction_name and pb:has_defender() then
						defender_char_list = pb:defender():military_force():character_list()

						for i = 0, defender_char_list:num_items() - 1 do
							local temp_character = defender_char_list:item_at(i)
							if not (temp_character == character) and not (temp_character:character_type("general") or temp_character:character_type("colonel")) then
								return true
							end
						end
						
					elseif attacker_faction_name == character_faction_name and pb:has_attacker() then
						
						attacker_char_list = pb:attacker():military_force():character_list()

						for i = 0, attacker_char_list:num_items() - 1 do
							local temp_character = attacker_char_list:item_at(i)
							if not (temp_character == character) and not (temp_character:character_type("general") or temp_character:character_type("colonel")) then
								return true
							end
						end
					end
				end
			end,
		["grant_immediately"] = true
	},
	-- LONGSTRIDER - Successfully use a Hero action with this character.
	{
		["initiative_key"] = 
			{
				"wh3_main_character_initiative_ogr_big_name_longstrider_bruiser", "wh3_main_character_initiative_ogr_big_name_longstrider_butcher", 
				"wh3_main_character_initiative_ogr_big_name_longstrider_firebelly", "wh3_main_character_initiative_ogr_big_name_longstrider_hunter",
			},
		["event"] = {"CharacterCharacterTargetAction", "CharacterGarrisonTargetAction"},
		["condition"] =
			function(context)
				return (context:mission_result_success() or context:mission_result_critial_success()) and not (context:ability() == "assist_army")
			end,
		["grant_immediately"] = true
	},
	-- MAGIC FEASTER - Win a battle against an army led by a spellcaster.
	{
		["initiative_key"] = "wh3_dlc26_character_initiative_ogr_big_name_magic_feaster",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character()
				
				if character:won_battle() then
					local pb = cm:model():pending_battle()
					return (pb:has_attacker() and pb:attacker() == character and cm:get_saved_value("big_name_defender_spellcaster")) or (pb:has_defender() and pb:defender() == character and cm:get_saved_value("big_name_attacker_spellcaster"))
				end
			end,
		["grant_immediately"] = true
	},
	-- MARROW MUNCHER - End your turn with over 80 Winds of Magic reserves.
	{
		["initiative_key"] = 
			{
				"wh3_dlc26_character_initiative_ogr_big_name_marrow_muncher", "wh3_dlc26_character_initiative_ogr_big_name_firebelly_marrow_muncher", 
			},
		["event"] = "CharacterTurnEnd",
		["condition"] =
			function(context)
				local character = context:character()
				local mf = false
				
				if character:has_military_force() then 
					mf = character:military_force()
				elseif not character:embedded_in_military_force():is_null_interface() then
					mf = character:embedded_in_military_force()
				end
			
				if mf then
					local wom = mf:pooled_resource_manager():resource("wh3_main_winds_of_magic")					
					return not wom:is_null_interface() and wom:value() > 80
				end
			end,
		["grant_immediately"] = true
	},
	-- MOUNTAINEATER - Win a battle with 3 units of Stonehorns or Thundertusks in your army.
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_mountaineater",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character()		
				local stonehorns_thundertusks = {
					"wh3_main_ogr_mon_stonehorn_0","wh3_main_ogr_mon_stonehorn_1","wh3_twa08_ogr_mon_stonehorn_0_ror","wh3_dlc26_ogr_mon_thundertusk"
				}		
				return character:won_battle() and cm:count_char_army_has_unit(character, stonehorns_thundertusks) > 2
			end,
		["grant_immediately"] = true
	},
	-- MOUNTAINTALKER - Win an ambush battle.
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_mountaintalker",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return context:character():won_battle() and cm:model():pending_battle():ambush_battle()
			end,
		["grant_immediately"] = true
	},
	-- ORCSPLITTER - Win a battle against Greenskins.
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_orcsplitter",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return cm:character_won_battle_against_culture(context:character(), "wh_main_grn_greenskins", "_grn_")
			end,
		["grant_immediately"] = true
	},
	-- RATKILLER - Win a battle against Skaven.
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_ratkiller",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return cm:character_won_battle_against_culture(context:character(), "wh2_main_skv_skaven", "_skv_")
			end,
		["grant_immediately"] = true
	},
	-- STAYDEADER - Win a battle against Vampire Counts, Vampire Coast or Tomb Kings.
	{
		["initiative_key"] = "wh3_main_character_initiative_ogr_big_name_staydeader",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return cm:character_won_battle_against_culture(context:character(), {"wh_main_vmp_vampire_counts", "wh2_dlc09_tmb_tomb_kings", "wh2_dlc11_cst_vampire_coast"})
			end,
		["grant_immediately"] = true
	},
	-- UNSTOPPABLE - Win a battle with a Heroic victory.
	{
		["initiative_key"] = "wh3_dlc26_character_initiative_ogr_big_name_unstoppable",
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				if context:character():won_battle() then
					local pb = cm:model():pending_battle()					
					return (pb:attacker_won() and pb:attacker_battle_result() == "heroic_victory") or  (pb:defender_won() and pb:defender_battle_result() == "heroic_victory")
				end
			end,
		["grant_immediately"] = true
	},

	-----------------------------------------------
	---	CHAOS PATH TO GLORY	- MARKS/ASCESNSION	---    
	-----------------------------------------------
	-- Daemon Princes
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_ascend_lord_to_daemon_prince_khorne", "wh3_dlc20_character_initiative_ascend_lord_to_daemon_prince_nurgle",				-- Khorne & Nurgle
				"wh3_dlc20_character_initiative_ascend_lord_to_daemon_prince_tzeentch", "wh3_dlc20_character_initiative_ascend_lord_to_daemon_prince_slaanesh",			-- Tzeentch & Slaanesh
			},
		["event"] = {"CharacterRankUp", "CharacterRecruited"},
		["condition"] =
			function(context)
				return context:character():rank() >= 20
			end
	},

	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_ascend_lord_to_daemon_prince_undivided", 
				"wh3_dlc20_character_initiative_ascend_lord_to_daemon_prince_khorne_from_und",
				"wh3_dlc20_character_initiative_ascend_lord_to_daemon_prince_nurgle_from_und",
				"wh3_dlc20_character_initiative_ascend_lord_to_daemon_prince_slaanesh_from_und",
				"wh3_dlc20_character_initiative_ascend_lord_to_daemon_prince_tzeentch_from_und"
			},
		["event"] = {"CharacterRankUp", "CharacterRecruited"},
		["condition"] =
			function(context)
				return context:character():rank() >= 30
			end
	},
	-- Lords and Heroes
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_devote_exalted_hero_to_khorne",																							-- 	Exalted Hero - Khorne
				"wh3_dlc20_character_initiative_devote_exalted_hero_to_nurgle",																							-- 	Exalted Hero - Nurgle
				"wh3_dlc24_character_initiative_devote_exalted_hero_to_tzeentch",																						-- 	Exalted Hero - Tzeentch
				"wh3_dlc27_character_initiative_devote_exalted_hero_to_slaanesh",																						-- 	Exalted Hero - Slaanesh
				"wh3_dlc20_character_initiative_devote_lord_to_khorne",																									-- 	Chaos Lord - Khorne
				"wh3_dlc20_character_initiative_devote_lord_to_slaanesh",																								-- 	Chaos Lord - Slaanesh
				"wh3_dlc24_character_initiative_devote_lord_to_tzeentch",																								-- 	Chaos Lord - Tzeentch
				"wh3_dlc20_character_initiative_devote_lord_to_nurgle",																								-- 	Chaos Lord - Nurgle
				"wh3_dlc20_character_initiative_devote_sorceror_to_tzeentch_tzeentch", 																					--	Sorceror - Tzeentch (Tzeentch) 
				"wh3_dlc20_character_initiative_devote_sorceror_lord_to_tzeentch_tzeentch",																				--	Sorceror Lord - Tzeentch (Tzeentch)
				"wh3_dlc20_character_initiative_devote_sorceror_to_slaanesh_slaanesh",																					--	Sorceror - Slaanesh (Slaanesh) 
				"wh3_dlc20_character_initiative_devote_sorceror_lord_to_nurgle_nurgle", 																				--	Sorceror Lord - Nurgle (Nurgle) 
				"wh3_dlc27_character_initiative_devote_sorceror_lord_to_slaanesh_slaanesh",																				--	Sorceror Lord - Slaanesh (Slaanesh) 
				"wh3_dlc25_character_initiative_devote_sorceror_to_nurgle_nurgle", 																				--	Sorceror - Nurgle (Nurgle) 
			},
		["event"] = {"CharacterRankUp", "CharacterRecruited"},
		["condition"] =
			function(context)
				return context:character():rank() >= 5
			end
	},
	-- Lords and Heroes (Alternate spell lores; these are split from the above to avoid duplicate events in the Event Feed)
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_devote_sorceror_to_tzeentch_metal",																						--	Sorceror - Tzeentch  (Metal)
				"wh3_dlc20_character_initiative_devote_sorceror_lord_to_tzeentch_metal", 																				--	Sorceror Lord - Tzeentch (Metal)
				"wh3_dlc20_character_initiative_devote_sorceror_to_slaanesh_shadows", 																					--	Sorceror - Slaanesh (Shadows)
				"wh3_dlc20_character_initiative_devote_sorceror_lord_to_nurgle_death",	 																				--	Sorceror Lord - Nurgle (Death)
				"wh3_dlc27_character_initiative_devote_sorceror_lord_to_slaanesh_shadows",																				--	Sorceror Lord - Slaanesh (Shadows)
				"wh3_dlc25_character_initiative_devote_sorceror_to_nurgle_death",	 																				--	Sorceror - Nurgle (Death)
			},
		["event"] = {"CharacterRankUp", "CharacterRecruited"},
		["condition"] =
			function(context)
				return context:character():rank() >= 5
			end
		},
	-----------------------------------------------
	---	CHAOS PATH TO GLORY	- 		BOONS		---
	-----------------------------------------------
	-- Winning a battle with 2000 kills (Attack buff Boon)
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_exalted_hero_und_03", "wh3_dlc20_character_initiative_chs_chaos_lord_und_02", "wh3_dlc20_character_initiative_chs_daemon_prince_und_03",	-- 	Undivided (Exalted Hero, Chaos Lord, Daemon Prince)
				"wh3_dlc20_character_initiative_chs_exalted_hero_kho_05", "wh3_dlc20_character_initiative_chs_chaos_lord_kho_03", "wh3_dlc20_character_initiative_chs_daemon_prince_kho_03",	-- 	Khorne (Exalted Hero, Chaos Lord, Daemon Prince)
				"wh3_dlc20_character_initiative_chs_exalted_hero_nur_03", "wh3_dlc20_character_initiative_chs_daemon_prince_nur_03", "wh3_dlc25_character_initiative_chs_chaos_lord_nur_03",	-- 	Nurgle (Exalted Hero, Daemon Prince, Chaos Lord)
				"wh3_dlc20_character_initiative_chs_chaos_lord_sla_03", "wh3_dlc20_character_initiative_chs_daemon_prince_sla_03", "wh3_dlc27_character_initiative_chs_exalted_hero_sla_05",	-- 	Slaanesh (Exalted Hero, Chaos Lord, Daemon Prince)
				"wh3_dlc24_character_initiative_chs_exalted_hero_tze_05", "wh3_dlc24_character_initiative_chs_chaos_lord_tze_03",																--	Tzeentch (Chaos Lord, Exalted Hero)
			},
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				
				if character:won_battle() then
					local character_faction_name = character:faction():name();
					local pb = cm:model():pending_battle();
					
					local defender_char_cqi, defender_mf_cqi, defender_faction_name = cm:pending_battle_cache_get_defender(1);
					local attacker_char_cqi, attacker_mf_cqi, attacker_faction_name = cm:pending_battle_cache_get_attacker(1);
					
					if attacker_faction_name == character_faction_name then
						return pb:attacker_kills() > 2000;
					elseif defender_faction_name == character_faction_name then
						return pb:defender_kills() > 2000;
					end;
				end;
			end,
		["grant_immediately"] = true
	},
	-- Win 5 Battles (Defence buff Boon)
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_exalted_hero_und_01", "wh3_dlc20_character_initiative_chs_exalted_hero_kho_01",	"wh3_dlc27_character_initiative_chs_exalted_hero_sla_01",						-- Exalted Heroes
				"wh3_dlc20_character_initiative_chs_exalted_hero_nur_01", "wh3_dlc24_character_initiative_chs_exalted_hero_tze_01",																					-- Exalted Heroes
				"wh3_dlc20_character_initiative_chs_chaos_lord_und_01", "wh3_dlc20_character_initiative_chs_chaos_lord_kho_01", "wh3_dlc20_character_initiative_chs_chaos_lord_sla_01", 							-- Chaos Lords
				"wh3_dlc24_character_initiative_chs_chaos_lord_tze_01", "wh3_dlc25_character_initiative_chs_chaos_lord_nur_01",																						-- Chaos Lords
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_und_01", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_sla_01", 																			-- Chaos Sorcerers
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_tze_01", "wh3_dlc25_character_initiative_chs_chaos_sorcerer_nur_01",																				-- Chaos Sorcerers
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_und_01", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_nur_01", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_tze_01", 	-- Chaos Sorcerer Lords
				"wh3_dlc27_character_initiative_chs_chaos_sorcerer_lord_sla_01",																																	-- Chaos Sorcerer Lords
				"wh3_dlc20_character_initiative_chs_daemon_prince_und_01", "wh3_dlc20_character_initiative_chs_daemon_prince_kho_01", "wh3_dlc20_character_initiative_chs_daemon_prince_nur_01", 					-- Daemon Princes
				"wh3_dlc20_character_initiative_chs_daemon_prince_sla_01", "wh3_dlc20_character_initiative_chs_daemon_prince_tze_01",  																				-- Daemon Princes
			},
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				
				return character:won_battle() and character:battles_won() > 4;
			end,
		["grant_immediately"] = true
	},
	-- Reaching Rank 15 (Indisputable Champion)
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_chaos_lord_und_08", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_und_09", "wh3_dlc20_character_initiative_chs_daemon_prince_und_08",	-- 	Undivided (Chaos Lord, Chaos Sorcerer Lord, Daemon Prince)
				"wh3_dlc20_character_initiative_chs_chaos_lord_kho_08", "wh3_dlc20_character_initiative_chs_daemon_prince_kho_08",																	-- 	Khorne (Chaos Lord, Daemon Prince)
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_nur_09", "wh3_dlc20_character_initiative_chs_daemon_prince_nur_08",	"wh3_dlc25_character_initiative_chs_chaos_lord_nur_08",	-- 	Nurgle (Chaos Sorcerer Lord, Daemon Prince, Lord)
				"wh3_dlc20_character_initiative_chs_chaos_lord_sla_08", "wh3_dlc20_character_initiative_chs_daemon_prince_sla_08",																	-- 	Slaanesh (Chaos Lord, Daemon Prince)
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_tze_09", "wh3_dlc20_character_initiative_chs_daemon_prince_tze_08", "wh3_dlc24_character_initiative_chs_chaos_lord_tze_08",	-- 	Tzeentch (Chaos Lord, Chaos Sorcerer Lord, Daemon Prince)
			},
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():rank() >= 15
			end,
		["grant_immediately"] = true
	},
	-- Win a battle against Nurgle 
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_nur_04", "wh3_dlc20_character_initiative_chs_exalted_hero_nur_06", 																-- Nurgle - Corruption
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_nur_06", "wh3_dlc20_character_initiative_chs_daemon_prince_nur_06",	"wh3_dlc25_character_initiative_chs_chaos_sorcerer_nur_05",	-- Favoured by Nurgle
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_und_05", 																														-- Tempted by Decay
			},
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return cm:character_won_battle_against_culture(context:character(), "wh3_main_nur_nurgle", "_nur_");
			end,
		["grant_immediately"] = true
	},
	-- Win a battle against Slaanesh 
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_sla_07", "wh3_dlc20_character_initiative_chs_daemon_prince_sla_06",				-- Favoured by Slaanesh
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_und_05", 																		-- Tempted by Excess
			},
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return cm:character_won_battle_against_culture(context:character(), "wh3_main_sla_slaanesh", "_sla_");
			end,
		["grant_immediately"] = true
	},
	-- Win a battle against Tzeentch 
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_tze_07", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_tze_08", "wh3_dlc20_character_initiative_chs_daemon_prince_tze_06",		-- Favoured by Tzeentch
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_und_04", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_und_06", 																-- Tempted by Change
			},
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return cm:character_won_battle_against_culture(context:character(), "wh3_main_tze_tzeentch", "_tze_");
			end,
		["grant_immediately"] = true
	},
	-- Win a battle against Daemons of Chaos.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_exalted_hero_kho_09", "wh3_dlc20_character_initiative_chs_exalted_hero_nur_09", "wh3_dlc20_character_initiative_chs_exalted_hero_und_08", "wh3_dlc24_character_initiative_chs_exalted_hero_tze_09",			-- Mortal Champion (Exalted Hero)
				"wh3_dlc27_character_initiative_chs_exalted_hero_sla_09",																																														-- Mortal Champion (Exalted Hero)
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_und_10", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_tze_10", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_sla_10", "wh3_dlc25_character_initiative_chs_chaos_sorcerer_nur_09",	-- Mortal Prophet (Chaos Sorcerer)
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_und_08", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_nur_08", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_tze_08", 												-- Mortal Supremacy (Chaos Sorcerer Lord)
				"wh3_dlc20_character_initiative_chs_chaos_lord_und_07", "wh3_dlc20_character_initiative_chs_chaos_lord_kho_07", "wh3_dlc20_character_initiative_chs_chaos_lord_sla_07",																			-- Mortal Supremacy (Chaos Lord)
				"wh3_dlc24_character_initiative_chs_chaos_lord_tze_07",	"wh3_dlc25_character_initiative_chs_chaos_lord_nur_07", 																																-- Mortal Supremacy (Chaos Lord)
				"wh3_dlc20_character_initiative_chs_daemon_prince_und_04", "wh3_dlc20_character_initiative_chs_daemon_prince_tze_04", "wh3_dlc20_character_initiative_chs_daemon_prince_sla_04", 																-- Mortal Supremacy (Daemon Prince)
				"wh3_dlc20_character_initiative_chs_daemon_prince_nur_04", "wh3_dlc20_character_initiative_chs_daemon_prince_kho_04", 																															-- Mortal Supremacy (Daemon Prince)
			},
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				
				return cm:character_won_battle_against_culture(character, {"wh3_main_kho_khorne", "wh3_main_nur_nurgle", "wh3_main_tze_tzeentch", "wh3_main_sla_slaanesh", "wh3_main_dae_daemons"})
			end,
		["grant_immediately"] = true
	},
	-- Use the Sacrifice Captives post-battle captive option.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_chaos_lord_kho_09", "wh3_dlc20_character_initiative_chs_chaos_lord_sla_09", "wh3_dlc20_character_initiative_chs_chaos_lord_und_09", 							-- Soul Harvester (Chaos Lord)
				"wh3_dlc24_character_initiative_chs_chaos_lord_tze_09",	"wh3_dlc25_character_initiative_chs_chaos_lord_nur_09",																						-- Soul Harvester (Chaos Lord)
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_nur_10", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_tze_10", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_und_10", 	-- Soul Harvester (Chaos Sorcerer Lord)
				"wh3_dlc27_character_initiative_chs_chaos_sorcerer_lord_sla_06",																																	-- Soul Harvester (Chaos Sorcerer Lord)
				"wh3_dlc20_character_initiative_chs_daemon_prince_und_09", "wh3_dlc20_character_initiative_chs_daemon_prince_nur_09", "wh3_dlc20_character_initiative_chs_daemon_prince_kho_09",				 	-- Soul Harvester (Daemon Prince) 
				"wh3_dlc20_character_initiative_chs_daemon_prince_sla_09", "wh3_dlc20_character_initiative_chs_daemon_prince_tze_09", 																				-- Soul Harvester (Daemon Prince) 
			},
		["event"] = "CharacterPostBattleCaptureOption",
		["condition"] =
			function(context)
				return context:get_outcome_key() == "release";
			end,
		["grant_immediately"] = true
	},
	-- Use the Sacrifice Captives post-battle captive option.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_daemon_prince_und_05", "wh3_dlc20_character_initiative_chs_daemon_prince_sla_05", "wh3_dlc20_character_initiative_chs_daemon_prince_nur_05",				 	-- Power Hungry (Daemon Prince) 
				"wh3_dlc20_character_initiative_chs_daemon_prince_kho_05", "wh3_dlc20_character_initiative_chs_daemon_prince_tze_05", 																				-- Power Hungry (Daemon Prince) 
			},
		["event"] = "CharacterPostBattleCaptureOption",
		["condition"] =
			function(context)
				return context:get_outcome_key() == "kill";
			end,
		["grant_immediately"] = true
	},
	-- Win a battle against multiple armies.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_daemon_prince_kho_02", "wh3_dlc20_character_initiative_chs_chaos_lord_kho_02", "wh3_dlc20_character_initiative_chs_exalted_hero_kho_04", -- Slaughterlord
			},
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				
				return character:won_battle() and ((cm:pending_battle_cache_faction_is_attacker(character:faction():name()) and cm:pending_battle_cache_num_defenders() > 1) or cm:pending_battle_cache_num_attackers() > 1);
			end,
		["grant_immediately"] = true
	},
	-- Win a battle against an army led by a spellcaster.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_sla_04", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_tze_04", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_und_04", "wh3_dlc25_character_initiative_chs_chaos_sorcerer_nur_03",	-- Mage Hunter (Chaos Sorcerer)
				"wh3_dlc20_character_initiative_chs_exalted_hero_kho_06", "wh3_dlc20_character_initiative_chs_exalted_hero_nur_04", "wh3_dlc20_character_initiative_chs_exalted_hero_und_04", "wh3_dlc24_character_initiative_chs_exalted_hero_tze_06",	"wh3_dlc27_character_initiative_chs_exalted_hero_sla_06",		-- Mage Hunter (Exalted Hero)
				"wh3_dlc27_character_initiative_chs_chaos_sorcerer_lord_sla_09",																																												-- Mage Hunter (Sorcerer Lord)
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_tze_04", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_tze_03", "wh3_dlc20_character_initiative_chs_daemon_prince_tze_03", 														-- Master Sorcerer
				"wh3_dlc20_character_initiative_chs_daemon_prince_und_06",  																																													-- Pyromancer
			},
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				
				if character:won_battle() then
					local character_faction_name = character:faction():name();
					local pb = cm:model():pending_battle();
					
					local defender_char_cqi, defender_mf_cqi, defender_faction_name = cm:pending_battle_cache_get_defender(1);
					local attacker_char_cqi, attacker_mf_cqi, attacker_faction_name = cm:pending_battle_cache_get_attacker(1);
					
					if defender_faction_name == character_faction_name and pb:has_attacker() then
						return pb:attacker():is_caster() and pb:attacker():faction():subculture() ~= "wh_main_sc_dwf_dwarfs"
					elseif attacker_faction_name == character_faction_name and pb:has_defender() then
						return pb:defender():is_caster() and pb:defender():faction():subculture() ~= "wh_main_sc_dwf_dwarfs"
					end;
				end;
			end,
		["grant_immediately"] = true
	},
	-- Win a battle with another spellcaster in your army.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_sla_02", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_tze_02", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_und_02", 					-- Partners in Chaos (Chaos Sorcerer)
				"wh3_dlc25_character_initiative_chs_chaos_sorcerer_nur_02",																																				-- Partners in Chaos (Chaos Sorcerer)
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_nur_02", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_tze_02", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_und_02", 		-- Partners in Chaos (Chaos Sorcerer Lord)
				"wh3_dlc27_character_initiative_chs_chaos_sorcerer_lord_sla_07",																																		-- Partners in Chaos (Chaos Sorcerer Lord)
				"wh3_dlc20_character_initiative_chs_daemon_prince_und_02", "wh3_dlc20_character_initiative_chs_daemon_prince_tze_02", 																					-- Partners in Chaos (Daemon Prince)
				"wh3_dlc20_character_initiative_chs_daemon_prince_sla_02", "wh3_dlc20_character_initiative_chs_daemon_prince_nur_02", 																					-- Partners in Chaos (Daemon Prince)
			},
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				
				if character:won_battle() then
					local character_faction_name = character:faction():name();
					local pb = cm:model():pending_battle();
					
					local defender_char_cqi, defender_mf_cqi, defender_faction_name = cm:pending_battle_cache_get_defender(1);
					local attacker_char_cqi, attacker_mf_cqi, attacker_faction_name = cm:pending_battle_cache_get_attacker(1);
					
					local num_friendly_casters = 0

					if defender_faction_name == character_faction_name and pb:has_attacker() then
						defender_char_list = pb:defender():military_force():character_list()

						for i = 0, defender_char_list:num_items() - 1 do
							local temp_character = defender_char_list:item_at(i)
							if temp_character:is_caster() then
								num_friendly_casters = num_friendly_casters + 1
							end
						end
						
					elseif attacker_faction_name == character_faction_name and pb:has_defender() then
						attacker_char_list = pb:attacker():military_force():character_list()

						for i = 0, attacker_char_list:num_items() - 1 do
							local temp_character = attacker_char_list:item_at(i)
							if temp_character:is_caster() then
								num_friendly_casters = num_friendly_casters + 1
							end
						end

					end;

					return num_friendly_casters > 1
				end;
			end,
		["grant_immediately"] = true
	},
	-- Win a battle against an army with 3 characters.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_chaos_lord_kho_04", "wh3_dlc20_character_initiative_chs_chaos_lord_und_03", -- Slayer of Champions
			},
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				
				if character:won_battle() then
					local character_faction_name = character:faction():name();
					local pb = cm:model():pending_battle();
					
					local defender_char_cqi, defender_mf_cqi, defender_faction_name = cm:pending_battle_cache_get_defender(1);
					local attacker_char_cqi, attacker_mf_cqi, attacker_faction_name = cm:pending_battle_cache_get_attacker(1);
					
					local num_enemy_characters = 0

					if defender_faction_name == character_faction_name and pb:has_attacker() then
						attacker_char_list = pb:attacker():military_force():character_list()

						for i = 0, attacker_char_list:num_items() - 1 do
							local temp_character = attacker_char_list:item_at(i)
							if temp_character:is_caster() then
								num_enemy_characters = num_enemy_characters + 1
							end
						end
						
					elseif attacker_faction_name == character_faction_name and pb:has_defender() then
						defender_char_list = pb:defender():military_force():character_list()

						for i = 0, defender_char_list:num_items() - 1 do
							local temp_character = defender_char_list:item_at(i)
							if temp_character:is_caster() then
								num_enemy_characters = num_enemy_characters + 1
							end
						end
					end;

					return num_enemy_characters >2
				end;
			end,
		["grant_immediately"] = true
	},
	-- Lose a battle and survive.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_exalted_hero_kho_07", "wh3_dlc20_character_initiative_chs_exalted_hero_nur_07", "wh3_dlc20_character_initiative_chs_exalted_hero_und_06", "wh3_dlc24_character_initiative_chs_exalted_hero_tze_07", "wh3_dlc27_character_initiative_chs_exalted_hero_sla_07",	-- Survivor (Exalted Hero)
				"wh3_dlc20_character_initiative_chs_chaos_lord_kho_06", "wh3_dlc20_character_initiative_chs_chaos_lord_sla_06", "wh3_dlc20_character_initiative_chs_chaos_lord_und_06", 																-- Survivor (Chaos Lord)				
				"wh3_dlc24_character_initiative_chs_chaos_lord_tze_06", "wh3_dlc25_character_initiative_chs_chaos_lord_nur_06",																															-- Survivor (Chaos Lord)
				"wh3_dlc27_character_initiative_chs_chaos_sorcerer_lord_sla_05",																																										-- Survivor (Chaos Sorcerer Lord)		
				"wh3_dlc20_character_initiative_chs_daemon_prince_kho_07", "wh3_dlc20_character_initiative_chs_daemon_prince_nur_07", "wh3_dlc20_character_initiative_chs_daemon_prince_tze_07", 														-- Survivor (Daemon Prince)
				"wh3_dlc20_character_initiative_chs_daemon_prince_und_07", "wh3_dlc20_character_initiative_chs_daemon_prince_sla_07",  																													-- Survivor (Daemon Prince)
			},
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return not context:character():won_battle();
			end,
		["grant_immediately"] = true
	},
	-- Win an ambush battle.
	{
		["initiative_key"] = "wh3_dlc20_character_initiative_chs_chaos_sorcerer_tze_06", -- Shrouded in Chaos
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				return context:character():won_battle() and cm:model():pending_battle():ambush_battle()
			end,
		["grant_immediately"] = true
	},
	-- Win a battle with 2 Chaos Knights units in your army.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_exalted_hero_und_02", "wh3_dlc20_character_initiative_chs_exalted_hero_kho_02", "wh3_dlc20_character_initiative_chs_exalted_hero_nur_02", "wh3_dlc24_character_initiative_chs_exalted_hero_tze_02", "wh3_dlc27_character_initiative_chs_exalted_hero_sla_02",	-- Chaos Knight Leader
			},
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				local chaos_knights = {
					"wh_main_chs_cav_chaos_knights_0", "wh_main_chs_cav_chaos_knights_1", "wh_pro04_chs_cav_chaos_knights_ror_0",
					"wh3_dlc20_chs_cav_chaos_knights_mkho", "wh3_dlc20_chs_cav_chaos_knights_mkho_lances",
					"wh3_dlc20_chs_cav_chaos_knights_mnur", "wh3_dlc20_chs_cav_chaos_knights_mnur_lances",
					"wh3_dlc20_chs_cav_chaos_knights_msla", "wh3_dlc20_chs_cav_chaos_knights_msla_lances",
					"wh3_main_tze_cav_chaos_knights_0", "wh3_dlc20_chs_cav_chaos_knights_mtze_lances",
				}
				return character:won_battle() and cm:count_char_army_has_unit(character, chaos_knights) > 1;
			end,
		["grant_immediately"] = true
	},
	-- Win a battle with 2 Hellstriders of Slaanesh units in your army.
	{
		["initiative_key"] = "wh3_dlc20_character_initiative_chs_chaos_sorcerer_sla_03", "wh3_dlc27_character_initiative_chs_chaos_sorcerer_lord_sla_08",								-- Hellstrider Leader
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();

				return character:won_battle() and cm:count_char_army_has_unit(character, {"wh3_main_sla_cav_hellstriders_0", "wh3_main_sla_cav_hellstriders_1"}) > 1
			end,
		["grant_immediately"] = true
	},
	-- Win a battle with 3 Chosen units in your army.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_exalted_hero_und_07", "wh3_dlc20_character_initiative_chs_exalted_hero_kho_08", "wh3_dlc20_character_initiative_chs_exalted_hero_nur_08", "wh3_dlc24_character_initiative_chs_exalted_hero_tze_08", "wh3_dlc27_character_initiative_chs_exalted_hero_sla_08", -- Chosen Leader
			},
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				local chosen = {
					"wh_main_chs_inf_chosen_0", "wh_main_chs_inf_chosen_1", "wh_dlc01_chs_inf_chosen_2",
					"wh3_dlc20_chs_inf_chosen_mkho", "wh3_dlc20_chs_inf_chosen_mkho_dualweapons",
					"wh3_dlc20_chs_inf_chosen_mnur", "wh3_dlc20_chs_inf_chosen_mnur_greatweapons",
					"wh3_dlc20_chs_inf_chosen_msla", "wh3_dlc20_chs_inf_chosen_msla_hellscourges",
					"wh3_dlc20_chs_inf_chosen_mtze", "wh3_dlc20_chs_inf_chosen_mtze_halberds",
				}
				return character:won_battle() and cm:count_char_army_has_unit(character, chosen) > 2;
			end,
		["grant_immediately"] = true
	},
	-- Win a battle with a unit of Aspiring Champions in your army.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_nur_03", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_tze_03", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_und_03", 	-- Aspiring Leader
			},
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				
				return character:won_battle() and cm:char_army_has_unit(character, {"wh_dlc06_chs_inf_aspiring_champions_0","wh3_dlc20_chs_inf_aspiring_champions_mtze_ror"})
			end,
		["grant_immediately"] = true
	},
	-- Win a battle with a unit of Skullcrushers in your army.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_exalted_hero_kho_03", 						-- Skullcrusher Leader
			},
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				
				return character:won_battle() and cm:char_army_has_unit(character, {"wh3_main_kho_cav_skullcrushers_0","wh3_dlc20_kho_cav_skullcrushers_mkho_ror"})
			end,
		["grant_immediately"] = true
	},
	-- Win a battle with a unit of Fiends of Slaanesh in your army.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_chaos_lord_sla_02", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_sla_06", "wh3_dlc20_character_initiative_chs_exalted_hero_nur_08", "wh3_dlc27_character_initiative_chs_chaos_sorcerer_lord_sla_02",	-- Fiend Leader
			},
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();
				
				return character:won_battle() and cm:char_army_has_unit(character, "wh3_main_sla_mon_fiends_of_slaanesh_0")
			end,
		["grant_immediately"] = true
	},
	-- Win a battle against an army containing 5 missile units.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_chaos_lord_kho_05", "wh3_dlc20_character_initiative_chs_chaos_lord_sla_05", "wh3_dlc27_character_initiative_chs_chaos_sorcerer_lord_sla_04",	-- Impenetrable
				"wh3_dlc20_character_initiative_chs_chaos_lord_und_05", "wh3_dlc20_character_initiative_chs_daemon_prince_kho_06", "wh3_dlc27_character_initiative_chs_exalted_hero_sla_03", -- Impenetrable
				"wh3_dlc24_character_initiative_chs_chaos_lord_tze_05",	 "wh3_dlc25_character_initiative_chs_chaos_lord_nur_05",	-- Impenetrable
			},
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character()
				
				if character:won_battle() then
					local defender_char_cqi, defender_mf_cqi, defender_faction_name = cm:pending_battle_cache_get_defender(1)
					local attacker_char_cqi, attacker_mf_cqi, attacker_faction_name = cm:pending_battle_cache_get_attacker(1)
					local character_faction_name = character:faction():name()
					local is_attacker = attacker_faction_name == character_faction_name
					local is_defender = defender_faction_name == character_faction_name
					
					if is_attacker or is_defender then
						local unit_class_localised = common.get_localised_string("unit_class_onscreen_inf_mis")
						local num_participants = 0
						
						if is_attacker then
							num_participants = cm:pending_battle_cache_num_defenders()
						else
							num_participants = cm:pending_battle_cache_num_attackers()
						end
						
						local count = 0
						
						for i = 1, num_participants do
							local units = {}
							
							if is_attacker then
								units = cm:pending_battle_cache_get_defender_units(i)
							else
								units = cm:pending_battle_cache_get_attacker_units(i)
							end
							
							for j = 1, #units do
								if common.get_context_value("CcoMainUnitRecord", units[j].unit_key, "ClassName") == unit_class_localised then
									count = count + 1
									
									if count > 4 then
										return true
									end
								end
							end
						end
					end
				end
			end,
		["grant_immediately"] = true
	},
	-- Successfully use an Agent Action with this character.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_exalted_hero_kho_10", "wh3_dlc20_character_initiative_chs_exalted_hero_nur_10", "wh3_dlc20_character_initiative_chs_exalted_hero_und_09", "wh3_dlc24_character_initiative_chs_exalted_hero_tze_10",	"wh3_dlc27_character_initiative_chs_exalted_hero_sla_10",		-- Chaos Assassin
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_und_09", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_tze_09", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_sla_09", "wh3_dlc25_character_initiative_chs_chaos_sorcerer_nur_08",	-- Oppressive Force
			},
		["event"] = {"CharacterCharacterTargetAction", "CharacterGarrisonTargetAction"},
		["condition"] =
			function(context)
				return (context:mission_result_success() or context:mission_result_critial_success()) and not (context:ability() == "assist_army")
			end,
		["grant_immediately"] = true
	},
	-- Rank-up in Raiding stance.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_chaos_lord_sla_04", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_sla_05", "wh3_dlc27_character_initiative_chs_chaos_sorcerer_lord_sla_03", "wh3_dlc27_character_initiative_chs_exalted_hero_sla_04",	-- Living Nightmare
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_nur_05", "wh3_dlc20_character_initiative_chs_exalted_hero_nur_05",		-- Aura of Atrophy
				"wh3_dlc25_character_initiative_chs_chaos_sorcerer_nur_06", "wh3_dlc25_character_initiative_chs_chaos_lord_nur_02",				-- Aura of Atrophy
			},
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				if character:has_military_force() then
					local mf = character:military_force();
					return (mf:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_SET_CAMP_RAIDING" or mf:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID");
				elseif not character:embedded_in_military_force():is_null_interface() then
					local mf = character:embedded_in_military_force();
					return (mf:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_SET_CAMP_RAIDING" or mf:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID");
				end;
			end,
		["grant_immediately"] = true
	},
	-- Rank-up in Channelling stance.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_tze_05", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_tze_05", "wh3_dlc24_character_initiative_chs_exalted_hero_tze_03", "wh3_dlc24_character_initiative_chs_chaos_lord_tze_02",	-- Arcane Exemplar
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_tze_06", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_und_06", "wh3_dlc24_character_initiative_chs_chaos_lord_tze_04",														-- Attuned to Chamon (Chaos Sorcerer Lord)
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_tze_07", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_und_07", 																														-- Attuned to Chamon (Chaos Sorcerer)
				"wh3_dlc24_character_initiative_chs_exalted_hero_tze_04", 																																														-- Attuned to Chamon (Exalted Hero)
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_nur_07", 																																												-- Attuned to Shyish	
			},
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				if character:has_military_force() then
					local mf = character:military_force();
					return (mf:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_CHANNELING" or mf:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_CHANNELING");
				elseif not character:embedded_in_military_force():is_null_interface() then
					local mf = character:embedded_in_military_force()
					return (mf:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_CHANNELING" or mf:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_CHANNELING");
				end;
			end,
		["grant_immediately"] = true
	},
	-- End your turn with over 80 Winds of Magic reserves.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_tze_03", "wh3_dlc20_character_initiative_chs_daemon_prince_tze_03", "wh3_dlc25_character_initiative_chs_chaos_sorcerer_nur_07",			-- Master Sorcerer
				"wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_und_07", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_sla_08", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_und_08",	-- Attuned to Ulgu
			},
		["event"] = "CharacterTurnEnd",
		["condition"] =
			function(context)
				local character = context:character();
				local mf = false;
				
				if character:has_military_force() then 
					mf = character:military_force();
				elseif not character:embedded_in_military_force():is_null_interface() then
					mf = character:embedded_in_military_force();
				end;
			
				if mf then
					local wom = mf:pooled_resource_manager():resource("wh3_main_winds_of_magic");
					
					return not wom:is_null_interface() and wom:value() > 80;
				end;
			end,
		["grant_immediately"] = true
	},
	-- End your turn with less than 30 Winds of Magic reserves.
	{
		["initiative_key"] = 
			{
				-- Nothing to see here
			},
		["event"] = "CharacterTurnEnd",
		["condition"] =
			function(context)
				local character = context:character();
				local mf = false;
				
				if character:has_military_force() then 
					mf = character:military_force();
				elseif not character:embedded_in_military_force():is_null_interface() then
					mf = character:embedded_in_military_force();
				end;
			
				if mf then
					local wom = mf:pooled_resource_manager():resource("wh3_main_winds_of_magic");
					
					return not wom:is_null_interface() and wom:value() < 30;
				end;
			end,
		["grant_immediately"] = true
	},
	-- End turn in a friendly region with less than -50 Control.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_chaos_lord_und_04", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_und_03", "wh3_dlc20_character_initiative_chs_exalted_hero_und_05", -- Undivided - Corruption
			},
		["event"] = "CharacterTurnEnd",
		["condition"] =
			function(context)
				local character = context:character()
				local region = character:region()
				
				if region:is_null_interface() == false then
					local region_faction = region:owning_faction()

					if region_faction:is_null_interface() == false then
						if region_faction:is_faction(character:faction()) then
							return region:public_order() < -50
						end
					end
				else
					return false
				end

			end,
		["grant_immediately"] = true
	},
	-- Occupy a settlement with a Chaotic Wasteland climate.
	{
		["initiative_key"] = 
			{
				"wh3_dlc20_character_initiative_chs_exalted_hero_nur_06", "wh3_dlc20_character_initiative_chs_chaos_sorcerer_lord_nur_04", 	-- Nurgle - Corruption
				"wh3_dlc25_character_initiative_chs_chaos_lord_nur_04", "wh3_dlc25_character_initiative_chs_chaos_sorcerer_nur_04", 		-- Nurgle - Corruption
			},
		["event"] = "GarrisonOccupiedEvent",
		["condition"] =
			function(context)
				return context:garrison_residence():region():settlement():get_climate() == "climate_chaotic";
			end
	},
	-- Harald Hammerstorm Boons
	-- Kill Karl Franz
	{
		["initiative_key"] = "wh3_pro11_character_initiative_chs_harald_hammerstorm_01",																										-- Hellstrider Leader
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();

				local karl_is_participating = false
				for i = 0, 4 do
					local is_character = cm:pending_battle_cache_unit_key_exists("wh_main_emp_cha_karl_franz_" .. i)
					if is_character then
						karl_is_participating = true
						break
					end
				end
				
				return character:won_battle() and karl_is_participating
			end,
		["grant_immediately"] = true
	},
	-- Kill Legendary Undead character
	{
		["initiative_key"] = "wh3_pro11_character_initiative_chs_harald_hammerstorm_02",																										-- Hellstrider Leader
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();

				local legendary_undead_is_participating = false
				local undead_character_list = {
					"wh_main_vmp_cha_mannfred_von_carstein_0",
					"wh_main_vmp_cha_mannfred_von_carstein_2",
					"wh_main_vmp_cha_mannfred_von_carstein_3",
					"wh_main_vmp_cha_mannfred_von_carstein_4",
					"wh2_dlc11_vmp_cha_heinrich_kemmler_1",
					"wh_main_vmp_cha_heinrich_kemmler",
					"wh_dlc04_vmp_cha_vlad_von_carstein_0",
					"wh_pro02_vmp_cha_isabella_von_carstein_0",
					"wh_pro02_vmp_cha_isabella_von_carstein_2",
					"wh_pro02_vmp_cha_isabella_von_carstein_4",
					"wh_dlc04_vmp_cha_helman_ghorst_0",
					"wh_dlc04_vmp_cha_helman_ghorst_1",
					"wh2_dlc09_tmb_cha_settra_0",
					"wh2_dlc09_tmb_cha_settra_1",
					"wh2_dlc09_tmb_cha_settra_2",
					"wh2_dlc09_tmb_cha_settra_3",
					"wh2_dlc09_tmb_cha_khatep_0",
					"wh2_dlc09_tmb_cha_khatep_1",
					"wh2_dlc09_tmb_cha_khatep_2",
					"wh2_dlc09_tmb_cha_khatep_3",
					"wh2_dlc09_tmb_cha_khalida_0",
					"wh2_dlc09_tmb_cha_khalida_1",
					"wh2_dlc09_tmb_cha_khalida_2",
					"wh2_dlc09_tmb_cha_arkhan_0",
					"wh2_dlc09_tmb_cha_arkhan_1",
					"wh2_dlc09_tmb_cha_arkhan_2",
					"wh2_dlc11_cst_cha_luthor_harkon_0",
					"wh2_dlc11_cst_cha_luthor_harkon_1",
					"wh2_dlc11_cst_cha_count_noctilus_0",
					"wh2_dlc11_cst_cha_count_noctilus_1",
					"wh2_dlc11_cst_cha_aranessa_0",
					"wh2_dlc11_cst_cha_aranessa_1",
					"wh2_dlc11_cst_cha_cylostra_0",
					"wh2_dlc11_cst_cha_cylostra_1"
				}
				for i = 1, #undead_character_list do
					local is_character = cm:pending_battle_cache_unit_key_exists(undead_character_list[i])
					if is_character then
						legendary_undead_is_participating = true
						break
					end
				end
				
				return character:won_battle() and legendary_undead_is_participating
			end,
		["grant_immediately"] = true
	},
	-- Kill a Greater Daemon lord
	{
		["initiative_key"] = "wh3_pro11_character_initiative_chs_harald_hammerstorm_03",																										-- Hellstrider Leader
		["event"] = {"CharacterCompletedBattle", "HeroCharacterParticipatedInBattle"},
		["condition"] =
			function(context)
				local character = context:character();

				local found_character_is_participating = false
				local exalted_daemon_lord_character_list = {
					"wh3_main_ie_nor_cha_exalted_great_unclean_one_burplesmirk_spewpit",
					"wh3_main_kho_cha_exalted_bloodthirster_0",
					"wh3_main_nur_cha_exalted_great_unclean_one_death_0",
					"wh3_main_nur_cha_exalted_great_unclean_one_nurgle_0",
					"wh3_main_sla_cha_exalted_keeper_of_secrets_shadow_0",
					"wh3_main_sla_cha_exalted_keeper_of_secrets_slaanesh_0",
					"wh3_main_tze_cha_exalted_lord_of_change_metal_0",
					"wh3_main_tze_cha_exalted_lord_of_change_tzeentch_0",
					"wh_dlc08_nor_cha_arzik_0",
					"wh3_main_kho_cha_skarbrand_0",
					"wh3_main_nur_cha_ku_gath_plaguefather_0",
					"wh3_main_sla_cha_nkari_0",
					"wh3_main_tze_cha_kairos_fateweaver_0",
					"wh_dlc01_chs_cha_qb_lord_of_change_0"
				}
				for i = 1, #exalted_daemon_lord_character_list do
					local is_character = cm:pending_battle_cache_unit_key_exists(exalted_daemon_lord_character_list[i])
					if is_character then
						found_character_is_participating = true
						break
					end
				end
				
				return character:won_battle() and found_character_is_participating
			end,
		["grant_immediately"] = true
	},
	["grant_immediately"] = true
};

function initiative_unlock_listeners()
	local factions = cm:model():world():faction_list();
	
	for _, current_faction in model_pairs(factions) do
		if initiative_cultures[current_faction:culture()]then
			initiative_faction_exists = true;
			local character_list = current_faction:character_list();
			
			for j = 0, character_list:num_items() - 1 do
				local current_character = character_list:item_at(j);
				
				if not current_character:character_type("colonel") and not current_character:character_details():character_initiative_sets():is_empty() then
					collect_initiatives(current_character);
				end;
			end;
		end;
	end;
	
	if initiative_faction_exists then
		core:add_listener(
			"initiative_character_created",
			"CharacterCreated",
			function(context)
				local character = context:character();
				local faction = character:faction();
				
				return initiative_cultures[faction:culture()] and not character:character_type("colonel") and not character:character_details():character_initiative_sets():is_empty();
			end,
			function(context)
				collect_initiatives(context:character());
			end,
			true
		);
	end;
end;

function collect_initiatives(character)
	local character_initiative_sets = character:character_details():character_initiative_sets();
	
	for k, initiative_set in model_pairs(character_initiative_sets) do
		for l, initiative in model_pairs(initiative_set:all_initiatives()) do
			local current_initiative_key = initiative:record_key();
			if initiative:is_script_locked() then
				for i = 1, #initiative_templates do
					local current_initiative_template = initiative_templates[i]
					if is_string(current_initiative_template.initiative_key) then
						current_initiative_template.initiative_key = {current_initiative_template.initiative_key}
					end
					if is_string(current_initiative_template.event) then
						current_initiative_template.event = {current_initiative_template.event}
					end
					
					for j = 1, #current_initiative_template.initiative_key do
						if current_initiative_key == current_initiative_template.initiative_key[j] then
							local initiative = initiative_unlock:new(
								current_initiative_template.initiative_key[j],
								current_initiative_template.event,
								current_initiative_template.condition,
								current_initiative_template.grant_immediately
							);

							initiative:start(character:command_queue_index());
						end;
					end
				end;
			end;
		end;
	end
end;

function initiative_unlock:new(initiative_key, event, condition, grant_immediately)


	if not is_string(initiative_key) then
		script_error("ERROR: initiative_unlock:new() called but supplied initiative_key [" .. tostring(initiative_key) .."] is not a string");
		return false;
	elseif not is_table(event) then
		script_error("ERROR: initiative_unlock:new() called but supplied event [" .. tostring(event) .."] is not a table");
		return false;
	elseif not is_function(condition) then
		script_error("ERROR: initiative_unlock:new() called but supplied condition [" .. tostring(condition) .."] is not a function");
		return false;
	end;
	
	local initiative = {};
	setmetatable(initiative, self);
	self.__index = self;
	
	initiative.cm = get_cm();
	initiative.initiative_key = initiative_key;
	initiative.event = event;
	initiative.condition = condition;
	initiative.grant_immediately = grant_immediately;
	
	return initiative;
end;

function initiative_unlock:start(cqi)
	local cm = self.cm;
		
	for i = 1, #self.event do
		--out.design("Initiatives -- Starting listener for Initiative with key [" .. self.initiative_key .. "] for character with cqi [" .. cqi .. "]");
		
		core:add_listener(
			self.initiative_key .. "_" .. cqi .. "_listener",
			self.event[i],
			function(context)
				local character_cqi = false;
				
				-- get the characters cqi from the event
				if is_function(context.character) and context:character() and not context:character():is_null_interface() then
					character_cqi = context:character():command_queue_index();
				elseif is_function(context.parent_character) and context:parent_character() and not context:parent_character():is_null_interface() then
					character_cqi = context:parent_character():command_queue_index();
				end;
				
				return character_cqi and character_cqi == cqi and self.condition(context);
			end,
			function()
				out.design("Initiatives -- Conditions met for event [" .. self.event[i] .. "], unlocking Initiative with key [" .. self.initiative_key .. "] for character with cqi [" .. cqi .. "]");
				
				local character = cm:get_character_by_cqi(cqi);

				for k, initiative_set in model_pairs(character:character_details():character_initiative_sets()) do
					local initiative = initiative_set:lookup_initiative_by_key(self.initiative_key)
					
					if not initiative:is_null_interface() and initiative:is_script_locked() then
						cm:toggle_initiative_script_locked(initiative_set, self.initiative_key, false);
						if self.grant_immediately then
							cm:toggle_initiative_active(initiative_set, self.initiative_key, true);
						end
					end
				end
				
				core:remove_listener(self.initiative_key .. "_" .. cqi .. "_listener");

				-- Save number of Initiatives unlocked by this faction, and trigger an event for narrative scripts
				local saved_value_name = "num_big_names_unlocked_" .. character:faction():name();
				local num_big_names_unlocked = cm:get_saved_value(saved_value_name) or 0;
				cm:set_saved_value(saved_value_name, num_big_names_unlocked + 1);
				core:trigger_custom_event("ScriptEventBigNameUnlocked", {character = character, initiative_key = self.initiative_key});
			end,
			false
		);
	end;

	-- helper functions for certain big names
	for _, units in pairs(regiments_of_renown) do
		for i = 1, #units do
			table.insert(all_ror_units, units[i])
		end
	end
	
	core:add_listener(
		"big_name_pending_battle",
		"PendingBattle",
		true,
		function(context)
			cm:set_saved_value("big_name_attacker_spellcaster", false)
			cm:set_saved_value("big_name_defender_spellcaster", false)

			local pb = cm:model():pending_battle()
			if pb:has_attacker() then
				local attacker = pb:attacker()
				
				if attacker:is_caster() and attacker:faction():subculture() ~= "wh_main_sc_dwf_dwarfs" then
					cm:set_saved_value("big_name_attacker_spellcaster", true)
				end
			end

			if pb:has_defender() then
				local defender = pb:defender()
				
				if defender:is_caster() and defender:faction():subculture() ~= "wh_main_sc_dwf_dwarfs" then
					cm:set_saved_value("big_name_defender_spellcaster", true)
				end
			end
		end,
		true
	)
end;