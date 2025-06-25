wh3_campaign_achievements = {
	long_victory = { --The unique string component of the winning achievements in IE, see achievements table in dave
		wh2_dlc09_tmb_tomb_kings = "TOMB_KINGS",
		wh2_dlc11_cst_vampire_coast = "vAMPIRE_COAST",
		wh2_main_def_dark_elves = "DARK_ELVES",
		wh2_main_hef_high_elves = "HIGH_ELVES",
		wh2_main_lzd_lizardmen = "LIZARDMEN",
		wh2_main_skv_skaven = "SKAVEN",
		wh3_dlc23_chd_chaos_dwarfs = "CHAOS_DWARFS",
		wh3_main_cth_cathay = "CATHAY",
		wh3_main_dae_daemons = "DAEMON_PRINCE",
		wh3_main_kho_khorne = "KHORNE",
		wh3_main_ksl_kislev = "KISLEV",
		wh3_main_nur_nurgle = "NURGLE",
		wh3_main_ogr_ogre_kingdoms = "OGRES",
		wh3_main_sla_slaanesh = "SLAANESH",
		wh3_main_tze_tzeentch = "TZEENTCH",
		wh_dlc03_bst_beastmen = "BEASTMEN",
		wh_dlc05_wef_wood_elves = "WOOD_ELVES",
		wh_dlc08_nor_norsca = "NORSCA",
		wh_main_brt_bretonnia = "BRETONNIA",
		wh_main_chs_chaos = "CHAOS",
		wh_main_dwf_dwarfs = "DWARFS",
		wh_main_emp_empire = "EMPIRE",
		wh_main_grn_greenskins = "GREENSKINS",
		wh_main_vmp_vampire_counts = "VAMPIRE_COUNTS"
	},
}

WH3_ACHIEVEMENT_TZEENTCH_UNLOCK_ALL_COTW = {
	wh3_dlc24_tze_the_deceivers = {
		"wh3_main_tech_tze_0_8",
		"wh3_main_tech_tze_1_9",
		"wh3_main_tech_tze_2_3",
		"wh3_main_tech_tze_2_9",
		"wh3_main_tech_tze_3_7",
		"wh3_main_tech_tze_4_1",
		"wh3_main_tech_tze_4_9",
		"wh3_main_tech_tze_3_5",
	},
	wh3_main_tze_oracles_of_tzeentch = {
		"wh3_main_tech_tze_0_8",
		"wh3_main_tech_tze_1_1",
		"wh3_main_tech_tze_2_3",
		"wh3_main_tech_tze_2_9",
		"wh3_main_tech_tze_3_5",
		"wh3_main_tech_tze_3_7",
		"wh3_main_tech_tze_4_1",
		"wh3_main_tech_tze_4_9",
		"wh3_main_tech_tze_1_9",
	}
}

function award_achievement_to_faction(faction_key, achievement_key)
	if cm:get_local_faction_name(true) == faction_key then
		cm:award_achievement(achievement_key);
	end;
end;


function start_achievement_listeners()
	if cm:is_multiplayer() then
		cm:award_achievement("WH3_ACHIEVEMENT_MP_CAMPAIGN_START");
	end;
	
	core:add_listener(
		"WH3_ACHIEVEMENT_ENTER_REALM",
		"ScriptEventPlayerOpensRealm",
		true,
		function(context)
			award_achievement_to_faction(context:faction():name(), "WH3_ACHIEVEMENT_ENTER_REALM");
		end,
		true
	);

	core:add_listener(
		"WH3_ACHIEVEMENT_COMPLETE_X_REALM",
		"ScriptEventPlayerCompletesRealm",
		true,
		function(context)
			local key = string.upper(context:realm());
			
			if key then
				award_achievement_to_faction(context:faction():name(), "WH3_ACHIEVEMENT_COMPLETE_" .. key .. "_REALM");
			end;
		end,
		true
	);

	core:add_listener(
		"WH3_ACHIEVEMENT_DAEMON_PRINCE_ASCEND",
		"RitualCompletedEvent",
		true,
		function(context)
			local faction = context:performing_faction();
			local faction_name = faction:name();
			
			if faction:is_human() and faction_name == "wh3_main_dae_daemon_prince" then
				if context:ritual():ritual_key() == "wh3_main_ritual_dae_ascend_undivided" then
					award_achievement_to_faction(faction_name, "WH3_ACHIEVEMENT_DAEMON_PRINCE_ASCEND_UNDIVIDED");
				else
					award_achievement_to_faction(faction_name, "WH3_ACHIEVEMENT_DAEMON_PRINCE_ASCEND");
				end;
			end;
		end,
		true
	);

	core:add_listener(
		"WH3_ACHIEVEMENT_KISLEV_MOTHERLAND",
		"IncidentOccuredEvent",
		true,
		function(context)
			local faction = context:faction();
			
			if faction:is_human() and context:dilemma() == "wh3_main_incident_ksl_boon_cost" then
				award_achievement_to_faction(faction:name(), "WH3_ACHIEVEMENT_KISLEV_MOTHERLAND");
			end;
		end,
		true
	);

	core:add_listener(
		"WH3_ACHIEVEMENT_CATHAY_COMPLETE_CARAVAN",
		"CaravanCompleted",
		true,
		function(context)
			local faction = context:faction();
			
			if faction:is_human() and faction:culture() == "wh3_main_cth_cathay" then
				award_achievement_to_faction(faction:name(), "WH3_ACHIEVEMENT_CATHAY_COMPLETE_CARAVAN");
			end;
		end,
		true
	);

	core:add_listener(
		"WH3_ACHIEVEMENT_X_REPLACE_HERALD",
		"ScriptEventPlayerReplacesHerald",
		function(context)
			return context:faction():culture() ~= "wh3_main_dae_daemons";
		end,
		function(context)
			local god = "KHORNE";
			local race = context:race();
			
			if race == "nur" then
				god = "NURGLE";
			elseif race == "sla" then
				god = "SLAANESH";
			elseif race == "tze" then
				god = "TZEENTCH";
			end;
			
			award_achievement_to_faction(context:faction():name(), "WH3_ACHIEVEMENT_" .. god .. "_REPLACE_HERALD");
		end,
		true
	);

	core:add_listener(
		"WH3_ACHIEVEMENT_OGRES_OFFER_TRIBUTE",
		"CharacterInitiativeActivationChangedEvent",
		function(context)
			return context:initiative():record_key():starts_with("wh3_dlc26_character_initiative_ogr_maw_offering")
		end,
		function(context)
			local faction = context:character():faction()
			
			if faction:is_human() and faction:culture() == "wh3_main_ogr_ogre_kingdoms" then
				award_achievement_to_faction(faction:name(), "WH3_ACHIEVEMENT_OGRES_OFFER_TRIBUTE");
			end;
		end,
		true
	);

	core:add_listener(
		"WH3_ACHIEVEMENT_SLAANESH_SPREAD_GIFT",
		"FactionCharacterTagAddedEvent",
		true,
		function(context)
			local faction = context:tagging_faction();
			
			if faction:is_human() and faction:culture() == "wh3_main_sla_slaanesh" then
				award_achievement_to_faction(faction:name(), "WH3_ACHIEVEMENT_SLAANESH_SPREAD_GIFT");
			end;
		end,
		true
	);

	core:add_listener(
		"WH3_ACHIEVEMENT_LOAN_ARMY",
		"CharacterLoanedEvent",
		true,
		function(context)
			local faction = context:character():faction();
			
			if faction:is_human() then
				award_achievement_to_faction(faction:name(), "WH3_ACHIEVEMENT_LOAN_ARMY");
			end;
		end,
		true
	);

	core:add_listener(
		"WH3_ACHIEVEMENT_DAEMON_PRINCE_GIFTS",
		"CharacterArmoryItemUnlocked",
		true,
		function(context)
			local faction = context:character():faction();
			local faction_name = faction:name();
			
			if faction:is_human() and faction_name == "wh3_main_dae_daemon_prince" then
				local count = cm:get_saved_value("wh3_achievement_daemon_prince_gifts_count") or 0;
				
				count = count + 1;
				
				if count == 5 then
					award_achievement_to_faction(faction_name, "WH3_ACHIEVEMENT_DAEMON_PRINCE_GIFTS_5");
				elseif count == 15 then
					award_achievement_to_faction(faction_name, "WH3_ACHIEVEMENT_DAEMON_PRINCE_GIFTS_15");
				end;
				
				cm:set_saved_value("wh3_achievement_daemon_prince_gifts_count", count);
			end;
		end,
		true
	);

	core:add_listener(
		"WH3_ACHIEVEMENT_TZEENTCH_COTW_SETTLEMENT",
		"DiplomacyManipulationExecutedEvent",
		true,
		function(context)
			local faction = context:performing_faction();
			
			if faction == context:diplomacy_target_faction() and faction:is_human() and context:diplomacy_manipulation_category() == "transfer_settlement" then
				award_achievement_to_faction(faction:name(), "WH3_ACHIEVEMENT_TZEENTCH_COTW_SETTLEMENT");
			end;
		end,
		true
	);

	core:add_listener(
		"WH3_ACHIEVEMENT_SLAANESH_SUMMON_DISCIPLE_ARMY",
		"SpawnableForceCreatedEvent",
		true,
		function(context)
			local p_char = context:parent_character()
			if p_char:is_null_interface() == false then
				local faction = p_char:faction()
				if faction:is_null_interface() == false then
					if faction:is_human() and faction:culture() == "wh3_main_sla_slaanesh" then
						award_achievement_to_faction(faction:name(), "WH3_ACHIEVEMENT_SLAANESH_SUMMON_DISCIPLE_ARMY");
					end
				end
			end
		end,
		true
	);

	core:add_listener(
		"WH3_ACHIEVEMENT_OGRES_DEPLOY_CAMPS",
		"SpawnableForceCreatedEvent",
		true,
		function(context)
			local p_char = context:parent_character()
			if p_char:is_null_interface() == false then
				local faction = p_char:faction()
				if faction:is_null_interface() == false then
			
					if faction:is_human() and faction:culture() == "wh3_main_ogr_ogre_kingdoms" then
						local faction_name = faction:name();
						local camp_count = cm:get_saved_value(faction_name .. "wh3_achievement_ogre_camps_count") or 0;
						
						camp_count = camp_count + 1;
						
						if camp_count == 5 then
							award_achievement_to_faction(faction_name, "WH3_ACHIEVEMENT_OGRES_DEPLOY_CAMPS");
						end;
						
						cm:set_saved_value(faction_name .. "wh3_achievement_ogre_camps_count", camp_count);
					end
				end
			end
		end,
		true
	);

	core:add_listener(
		"WH3_ACHIEVEMENT_CONSTRUCT_ALLIED_OUTPOST",
		"ForeignSlotManagerCreatedEvent",
		true,
		function(context)
			local faction = context:requesting_faction();
			
			if context:is_allied() and faction:is_human() then
				award_achievement_to_faction(faction:name(), "WH3_ACHIEVEMENT_CONSTRUCT_ALLIED_OUTPOST");
			end;
		end,
		true
	);

	core:add_listener(
		"WH3_ACHIEVEMENT_NURGLE_SPREAD_PLAGUE_force",
		"MilitaryForceInfectionEvent",
		true,
		function(context)
			local faction = context:faction();
			
			if context:is_creation() and faction:is_human() and faction:culture() == "wh3_main_nur_nurgle" then
				award_achievement_to_faction(faction:name(), "WH3_ACHIEVEMENT_NURGLE_SPREAD_PLAGUE");
			end;
		end,
		true
	);

	core:add_listener(
		"WH3_ACHIEVEMENT_NURGLE_SPREAD_PLAGUE_settlement",
		"RegionInfectionEvent",
		true,
		function(context)
			local faction = context:faction();
			
			if context:is_creation() and faction:is_human() and faction:culture() == "wh3_main_nur_nurgle" then
				award_achievement_to_faction(faction:name(), "WH3_ACHIEVEMENT_NURGLE_SPREAD_PLAGUE");
			end;
		end,
		true
	);

	if cm:get_campaign_name() ~= "wh3_main_prologue" then
		core:add_listener(
			"WH3_ACHIEVEMENT_NURGLE_UNLOCK_PLAGUE_INGREDIENTS",
			"ScriptEvent_AllPlagueComponentsUnlocked",
			true,
			function(context)
				local faction_key = context:faction():name()
				award_achievement_to_faction(faction_key, "WH3_ACHIEVEMENT_NURGLE_UNLOCK_PLAGUE_INGREDIENTS");
			end,
			true
		);
	end;

	core:add_listener(
		"WH3_ACHIEVEMENT_KHORNE_BLOODLETTING",
		"StreakEffectLevelsEntered",
		true,
		function(context)
			local faction = context:military_force():faction();
			
			if context:streak_effect_record() == "wh3_main_khorne_win_streak_3" and faction:is_human() and faction:culture() == "wh3_main_kho_khorne" then
				award_achievement_to_faction(faction:name(), "WH3_ACHIEVEMENT_KHORNE_BLOODLETTING");
			end;
		end,
		true
	);

	core:add_listener(
		"WH3_ACHIEVEMENT_OGRES_DESTROY_CARAVAN",
		"CharacterCompletedBattle",
		true,
		function(context)
			local pb = context:pending_battle();
			
			if pb:has_attacker() then
				local defender_family_member = cm:get_family_member_by_cqi(cm:pending_battle_cache_get_defender_fm_cqi(1));
				
				if defender_family_member and defender_family_member:character_details():character_subtype_key() == "wh3_main_cth_lord_caravan_master" then
					local faction = pb:attacker():faction();
					
					if faction:is_human() and faction:culture() == "wh3_main_ogr_ogre_kingdoms" then
						award_achievement_to_faction(faction:name(), "WH3_ACHIEVEMENT_OGRES_DESTROY_CARAVAN");
					end;
				end;
			end;
		end,
		true
	);

	core:add_listener(
		"WH3_ACHIEVEMENT_LONG_VICTORY_COMPLETE",
		"MissionSucceeded",
		function(context)
			return context:mission():mission_record_key() == "wh_main_long_victory"
		end,
		function(context)
			local faction_interface = context:faction()
			local faction = faction_interface:name()
			local culture = faction_interface:culture()

			if wh3_campaign_achievements.long_victory[culture] then
				award_achievement_to_faction(faction, "WH3_ACHIEVEMENT_WINNING_"..wh3_campaign_achievements.long_victory[culture].."_1") ---always grant regular victory
				if cm:get_difficulty() > 3 then
					award_achievement_to_faction(faction, "WH3_ACHIEVEMENT_WINNING_"..wh3_campaign_achievements.long_victory[culture].."_2") --- Achievement for victory on very hard or above
				end	
			end

		end,
		true
	);
	
	core:add_listener(
		"WH3_ACHIEVEMENT_CATHAY_OCCUPY_GREAT_BASTION",
		"RegionFactionChangeEvent",
		function(context)
			return not context:region():is_abandoned();
		end,
		function(context)
			local region = context:region();
			local owning_faction = region:owning_faction();
			
			if owning_faction:is_human() and owning_faction:culture() == "wh3_main_cth_cathay" then
				local regions = {
					wh3_main_combi_region_dragon_gate = true,
					wh3_main_combi_region_snake_gate = true,
					wh3_main_combi_region_turtle_gate = true
				};
				
				if cm:get_campaign_name() == "wh3_main_chaos" then
					regions = {
						wh3_main_chaos_region_dragon_gate = true,
						wh3_main_chaos_region_snake_gate = true,
						wh3_main_chaos_region_turtle_gate = true
					}
				end;
				
				if regions[region:name()] then
					for region, _ in pairs(regions) do
						local current_region = cm:get_region(region);
						
						if current_region:is_abandoned() or current_region:owning_faction() ~= owning_faction then
							return;
						end;
					end;
					
					award_achievement_to_faction(owning_faction:name(), "WH3_ACHIEVEMENT_CATHAY_OCCUPY_GREAT_BASTION");
				end;
			end;
		end,
		true
	);
	
	core:add_listener(
		"WH3_ACHIEVEMENT_CATHAY_OCCUPY_WEI_JIN",
		"RegionFactionChangeEvent",
		function(context)
			local region = context:region();
			
			if not region:is_abandoned() then
				local owning_faction = region:owning_faction();
				local region_name = region:name();
				
				return (region_name == "wh3_main_chaos_region_wei_jin" or region_name == "wh3_main_combi_region_wei_jin") and owning_faction:is_human() and owning_faction:culture() == "wh3_main_cth_cathay";
			end;
		end,
		function(context)
			award_achievement_to_faction(context:region():owning_faction():name(), "WH3_ACHIEVEMENT_CATHAY_OCCUPY_WEI_JIN");
		end,
		true
	);
	
	core:add_listener(
		"WH3_ACHIEVEMENT_KISLEV_OCCUPY_3_CITIES",
		"RegionFactionChangeEvent",
		function(context)
			return not context:region():is_abandoned();
		end,
		function(context)
			local region = context:region();
			local owning_faction = region:owning_faction();
			
			if owning_faction:is_human() and owning_faction:culture() == "wh3_main_ksl_kislev" then
				local regions = {
					wh3_main_combi_region_erengrad = true,
					wh3_main_combi_region_kislev = true,
					wh3_main_combi_region_praag = true
				};
				
				if cm:get_campaign_name() == "wh3_main_chaos" then
					regions = {
						wh3_main_chaos_region_erengrad = true,
						wh3_main_chaos_region_kislev = true,
						wh3_main_chaos_region_praag = true
					}
				end;
				
				if regions[region:name()] then
					for region, _ in pairs(regions) do
						local current_region = cm:get_region(region);
						
						if current_region:is_abandoned() or current_region:owning_faction() ~= owning_faction then
							return;
						end;
					end;
					
					award_achievement_to_faction(owning_faction:name(), "WH3_ACHIEVEMENT_KISLEV_OCCUPY_3_CITIES");
				end;
			end;
		end,
		true
	);

	core:add_listener(
		"WH3_ACHIEVEMENT_TZEENTCH_UNLOCK_ALL_COTW",
		"ResearchCompleted",
		function(context)
			local curr_faction = context:faction()
			return curr_faction:is_human() and WH3_ACHIEVEMENT_TZEENTCH_UNLOCK_ALL_COTW[curr_faction:name()]
		end,
		function(context)
			local faction_name = context:faction():name()
			for i = 1, #WH3_ACHIEVEMENT_TZEENTCH_UNLOCK_ALL_COTW[faction_name] do
				local tech = WH3_ACHIEVEMENT_TZEENTCH_UNLOCK_ALL_COTW[faction_name][i]
				if not context:faction():has_technology(tech) then
					return
				end
			end
			award_achievement_to_faction(faction_name, "WH3_ACHIEVEMENT_TZEENTCH_UNLOCK_ALL_COTW")
		end,
		true
	);
end;