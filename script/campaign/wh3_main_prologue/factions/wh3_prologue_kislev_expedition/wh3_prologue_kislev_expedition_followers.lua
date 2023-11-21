-- The listeners that are commented out reference reward ancillaries that reference mechanics we do not introduce. Or, they require factions that aren't part of the prologue currently.

local followers = {
	--------------------
	-- HUMANS/GENERIC --
	--------------------
	--[[
	{
		["follower"] = "wh_main_anc_follower_all_hedge_wizard",
		["event"] = "HeroCharacterParticipatedInBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and character:character_type("wizard");
			end,
		["chance"] = 20
	},
	]]
	--[[ 
	{
		["follower"] = "wh_main_anc_follower_all_men_bailiff",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:turns_in_own_regions() >= 1 and character:region():public_order() < -20;
			end,
		["chance"] = 8
	},
	--]]
	--[[ 
	{
		["follower"] = "wh_main_anc_follower_all_men_boatman",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				if character:has_region() then
					local region = character:region():name();
					return (region == "wh3_main_combi_region_marienburg" or region == "wh3_main_chaos_region_marienburg") and cm:model():turn_number() % 5 == 0;
				end;
			end,
		["chance"] = 15
	},
	--]]
	{
		["follower"] = "wh3_prologue_anc_follower_all_men_bodyguard",
		["event"] = "CharacterCharacterTargetAction",
		["condition"] =
			function(context)
				return context:mission_result_failure() and context:ability() ~= "assist_army";
			end,
		["chance"] = 13
	},
	--[[
	{
		["follower"] = "wh_main_anc_follower_all_men_fisherman",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				if character:has_region() then
					local region = character:region():name();
					return region == "wh3_main_combi_region_marienburg" or region == "wh3_main_chaos_region_marienburg";
				end;
			end,
		["chance"] = 8
	},
	--]]
	--[[
	{
		["follower"] = "wh_main_anc_follower_all_men_grave_robber",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				local pb = context:pending_battle();
				return cm:char_is_general(character) and not character:won_battle() and (pb:attacker() == character and pb:defender():faction():culture() == "wh_main_vmp_vampire_counts") or (pb:defender() == character and pb:attacker():faction():culture() == "wh_main_vmp_vampire_counts");
			end,
		["chance"] = 25
	},
	--]]
	--[[
	{
		["follower"] = "wh_main_anc_follower_all_men_initiate",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:region():owning_faction():culture() == "wh_main_vmp_vampire_counts";
			end,
		["chance"] = 5
	},
	--]]
	{
		["follower"] = "wh3_prologue_anc_follower_all_men_kislevite_kossar",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character()
				return character:has_region() and character:region():owning_faction():culture() == "wh3_main_pro_ksl_kislev";
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh3_prologue_anc_follower_all_men_mercenary",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return not context:character():won_battle();
			end,
		["chance"] = 8
	},
	{
		["follower"] = "wh3_prologue_anc_follower_all_men_ogres_pit_fighter",
		["event"] = "CharacterPostBattleCaptureOption",
		["condition"] =
			function(context)
				return context:get_outcome_key() == "kill" and cm:char_is_general_with_army(context:character());
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh3_prologue_anc_follower_all_men_outlaw",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_military_force() and (character:military_force():active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_SET_CAMP_RAIDING" or character:military_force():active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID");
			end,
		["chance"] = 8
	},
	{
		["follower"] = "wh3_prologue_anc_follower_all_men_outrider",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:faction():started_war_this_turn() and character:offensive_battles_won() > 3;
			end,
		["chance"] = 14
	},
	{
		["follower"] = "wh3_prologue_anc_follower_all_men_protagonist",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return not context:character():won_battle();
			end,
		["chance"] = 4
	},
	{
		["follower"] = "wh3_prologue_anc_follower_all_men_rogue",
		["event"] = "CharacterCharacterTargetAction",
		["condition"] =
			function(context)
				return cm:model():turn_number() % 2 == 0 and context:character():faction():is_human() and (context:mission_result_success() or context:mission_result_critial_success()) and context:ability() ~= "assist_army";
			end,
		["chance"] = 8
	},
	{
		["follower"] = "wh3_prologue_anc_follower_all_men_servant",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():rank() > 21;
			end,
		["chance"] = 5
	},
	--[[
	{
		["follower"] = "wh_main_anc_follower_all_men_smuggler",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				local turn = cm:model():turn_number();
				return character:faction():trade_value_percent() > 40 and turn > 5 and turn % 5 == 0 and character:can_equip_ancillary("wh_main_anc_follower_all_men_smuggler");
			end,
		["chance"] = 7
	},
	--]]
	{
		["follower"] = "wh3_prologue_anc_follower_all_men_soldier",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				return not context:character():won_battle();
			end,
		["chance"] = 2
	},
	{
		["follower"] = "wh3_prologue_anc_follower_all_men_thug",
		["event"] = "CharacterCharacterTargetAction",
		["condition"] =
			function(context)
				local character = context:character();
				return not (cm:model():turn_number() % 2 == 0) and character:faction():is_human() and (context:mission_result_success() or context:mission_result_critial_success()) and context:ability() ~= "assist_army";
			end,
		["chance"] = 8
	},
	{
		["follower"] = "wh3_prologue_anc_follower_all_men_tollkeeper",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():rank() < 11;
			end,
		["chance"] = 1
	},
	--[[
	{
		["follower"] = "wh_main_anc_follower_all_men_tomb_robber",
		["event"] = "CharacterLootedSettlement",
		["condition"] =
			function(context)
				return context:garrison_residence():faction():culture() == "wh_main_vmp_vampire_counts";
			end,
		["chance"] = 20
	},
	--]]
	{
		["follower"] = "wh3_prologue_anc_follower_all_men_vagabond",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():rank() > 21;
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh3_prologue_anc_follower_all_men_valet",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():offensive_battles_won() > 5;
			end,
		["chance"] = 5
	},
	--[[
	{
		["follower"] = "wh_main_anc_follower_all_men_zealot",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:region():owning_faction():culture() == "wh_main_vmp_vampire_counts";
			end,
		["chance"] = 5
	},
	--]]
	{
		["follower"] = "wh3_prologue_anc_follower_all_student",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return cm:get_saved_value("tech_researched_this_turn_" .. context:character():faction():name());
			end,
		["chance"] = 13
	},
	
	------------
	-- KISLEV --
	------------
	{
		["follower"] = "wh3_prologue_anc_follower_ksl_akshina_informant",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():turns_in_enemy_regions() > 0;
			end,
		["chance"] = 8
	},
	{
		["follower"] = "wh3_prologue_anc_follower_ksl_atamans_administrator",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:region():owning_faction() == character:faction();
			end,
		["chance"] = 5
	},
	{
		["follower"] = "wh3_prologue_anc_follower_ksl_knights_squire",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and cm:char_army_has_unit(character, {"wh3_main_pro_ksl_inf_tzar_guard_0"});
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh3_prologue_anc_follower_ksl_knights_ward",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and character == context:pending_battle():defender();
			end,
		["chance"] = 8
	},
	--[[
	{
		["follower"] = "wh3_main_anc_follower_ksl_kvas_deye",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and character:region():owning_faction():military_allies_with(character:faction());
			end,
		["chance"] = 10
	},
	--]]
	{
		["follower"] = "wh3_prologue_anc_follower_ksl_nomad_riding_master",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and (cm:count_char_army_has_unit_category(character, "cavalry") > 3 or cm:count_char_army_has_unit_category(character, "war_beast") > 3);
			end,
		["chance"] = 30
	},
	{
		["follower"] = "wh3_prologue_anc_follower_ksl_old_crone",
		["event"] = "CharacterCharacterTargetAction",
		["condition"] =
			function(context)
				return context:character():character_type("wizard") and (context:mission_result_success() or context:mission_result_critial_success()) and context:ability() ~= "assist_army";
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh3_prologue_anc_follower_ksl_orthodoxy_cleric",
		["event"] = "CharacterCharacterTargetAction",
		["condition"] =
			function(context)
				return context:character():character_type("dignitary") and (context:mission_result_success() or context:mission_result_critial_success()) and context:ability() ~= "assist_army";
			end,
		["chance"] = 10
	},
	--TODO: change these
	--[[{
		["follower"] = "wh3_main_anc_follower_ksl_priest_of_dazh",
		["event"] = "REPLACE",
		["condition"] =
			function(context)
				return true;
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh3_main_anc_follower_ksl_priest_of_taal",
		["event"] = "REPLACE",
		["condition"] =
			function(context)
				return true;
			end,
		["chance"] = 10
	},
	{
		["follower"] = "wh3_main_anc_follower_ksl_priest_of_ursun",
		["event"] = "REPLACE",
		["condition"] =
			function(context)
				return true;
			end,
		["chance"] = 10
	},]]
	--[[
	{
		["follower"] = "wh3_main_anc_follower_ksl_ritual_enforcer",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				return character:has_region() and cm:get_total_corruption_value_in_region(character:region()) > 15;
			end,
		["chance"] = 25
	},
	--]]
	{
		["follower"] = "wh3_prologue_anc_follower_ksl_tax_collector",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and character:faction():losing_money();
			end,
		["chance"] = 40
	},
	--[[
	{
		["follower"] = "wh3_prologue_anc_follower_ksl_veteran_warrior",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:won_battle() and (cm:count_char_army_has_unit_category(character, "inf_melee") + cm:count_char_army_has_unit_category(character, "inf_ranged")) > 7;
			end,
		["chance"] = 20
	}
	]]
	--[[
	{
		["follower"] = "wh3_main_anc_follower_ksl_vodka_distiller",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				local character = context:character();
				if character:has_region() then
					local region = character:region();
					return region:owning_faction() == character:faction() and region:public_order() < -20;
				end;
			end,
		["chance"] = 15
	}
	]]
};



function load_followers()
	for i = 1, #followers do
		core:add_listener(
			followers[i].follower,
			followers[i].event,
			followers[i].condition,
			function(context)
				if prologue_check_progression["item_generation"] == false or prologue_check_progression["open_world"] == false then
					return
				end

				local character = context:character();
				local chance = followers[i].chance;
				if core:is_tweaker_set("SCRIPTED_TWEAKER_13") then
					chance = 100;
				end;
				
				if not character:character_type("colonel") and not character:character_subtype("wh_dlc07_brt_green_knight") and not character:character_subtype("wh2_dlc10_hef_shadow_walker") and cm:random_number(100) <= chance then
					cm:force_add_ancillary(context:character(), followers[i].follower, false, false);
				end;
			end,
			true
		);
	end;
end;

load_followers()