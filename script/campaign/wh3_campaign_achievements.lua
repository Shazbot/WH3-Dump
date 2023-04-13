



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
		"RitualStartedEvent",
		true,
		function(context)
			local faction = context:performing_faction();
			
			if faction:is_human() and faction:culture() == "wh3_main_ksl_kislev" then
				local faction_name = faction:name();
				local ritual_key = context:ritual():ritual_key():gsub("_upgraded", "");
				
				cm:set_saved_value(faction_name .. ritual_key, true);
				
				local rituals = {
					"wh3_main_ritual_ksl_winter_dazh",
					"wh3_main_ritual_ksl_winter_salyak",
					"wh3_main_ritual_ksl_winter_tor",
					"wh3_main_ritual_ksl_winter_ursun"
				};
				
				for i = 1, #rituals do
					if not cm:get_saved_value(faction_name .. rituals[i]) then
						return false;
					end;
				end;
				
				award_achievement_to_faction(faction_name, "WH3_ACHIEVEMENT_KISLEV_MOTHERLAND");
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
		"RitualCompletedEvent",
		true,
		function(context)
			local faction = context:performing_faction();
			
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
			"FactionTurnStart",
			true,
			function(context)
				if are_all_plague_components_unlocked ~= nil then
					local faction = context:faction();
					
					if are_all_plague_components_unlocked(faction) then
						award_achievement_to_faction(faction:name(), "WH3_ACHIEVEMENT_NURGLE_UNLOCK_PLAGUE_INGREDIENTS");
					end;
				end;
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
end;