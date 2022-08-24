cm:whitelist_event_feed_event_type("character_trait_gainedevent_feed_target_character_faction")
cm:whitelist_event_feed_event_type("character_trait_lostevent_feed_target_character_faction")

local TRAIT_EXCLUSIONS = {
	["culture"] = {
		["wh2_main_trait_pacifist"] = {"wh_dlc08_nor_norsca", "wh3_main_kho_khorne", "wh3_main_tze_tzeentch"},
		["wh2_main_trait_defeats_against_chaos"] = {"wh_dlc08_nor_norsca", "wh3_main_kho_khorne", "wh3_main_tze_tzeentch"},
		["wh2_main_trait_defeats_against_daemons"] = {"wh_dlc08_nor_norsca", "wh3_main_kho_khorne", "wh3_main_tze_tzeentch"},
		["wh2_main_trait_agent_actions_against_chaos"] = {"wh_dlc08_nor_norsca", "wh3_main_kho_khorne", "wh3_main_tze_tzeentch"},
		["wh2_main_trait_agent_actions_against_daemons"] = {"wh_dlc08_nor_norsca", "wh3_main_kho_khorne", "wh3_main_tze_tzeentch"},
		["wh2_main_trait_wins_against_chaos"] = {"wh_dlc08_nor_norsca", "wh3_main_kho_khorne", "wh3_main_tze_tzeentch"},
		["wh2_main_trait_wins_against_daemons"] = {"wh_dlc08_nor_norsca", "wh3_main_kho_khorne", "wh3_main_tze_tzeentch"},
		["wh2_main_trait_def_favoured"] = {"wh_dlc08_nor_norsca", "wh3_main_kho_khorne", "wh3_main_tze_tzeentch", "wh3_main_pro_ksl_kislev"},
		["wh2_main_trait_post_battle_execute"] = {"wh_dlc08_nor_norsca", "wh3_main_kho_khorne", "wh3_main_tze_tzeentch", "wh3_main_pro_ksl_kislev"},
		["wh2_main_trait_public_order"] = {"wh_dlc08_nor_norsca", "wh3_main_kho_khorne", "wh3_main_tze_tzeentch", "wh3_main_pro_ksl_kislev"},
		["wh3_main_trait_ataman_bolsterer"] = {"wh_dlc08_nor_norsca", "wh3_main_kho_khorne", "wh3_main_tze_tzeentch", "wh3_main_pro_ksl_kislev"},
		["wh3_main_trait_ataman_province_first"] = {"wh_dlc08_nor_norsca", "wh3_main_kho_khorne", "wh3_main_tze_tzeentch", "wh3_main_pro_ksl_kislev"},
		["wh2_dlc11_trait_incentive_counter"] = {"wh_dlc08_nor_norsca", "wh3_main_kho_khorne", "wh3_main_tze_tzeentch", "wh3_main_pro_ksl_kislev"},
		["wh3_main_trait_ice_court_court_controller"] = {"wh_dlc08_nor_norsca", "wh3_main_kho_khorne", "wh3_main_tze_tzeentch", "wh3_main_pro_ksl_kislev"},
	},
	["subculture"] = {
	},
	["faction"] = {
	}
};

local SUBCULTURES_TRAIT_KEYS = {
	["wh_dlc08_sc_nor_norsca"] = "chaos",
	["wh3_main_sc_kho_khorne"] = "khorne",
	["h3_main_pro_sc_kho_khorne"] = "khorne",
	["wh3_main_sc_ksl_kislev"] = "kislev",
	["wh3_main_pro_sc_ksl_kislev"] = "kislev",
	["wh3_main_sc_tze_tzeentch"] = "tzeentch",
	["wh3_main_pro_sc_tze_tzeentch"] = "tzeentch"
};

local ACTION_KEY_TO_ACTION = {
	["wh2_main_agent_action_champion_hinder_agent_assassinate"] = "Assassinate",
	["wh2_main_agent_action_engineer_hinder_agent_assassinate"] = "Assassinate",
	["wh2_main_agent_action_spy_hinder_agent_assassinate"] = "Assassinate",
	["wh2_main_agent_action_spy_hinder_character_assassinate"] = "Assassinate",
	["wh2_main_agent_action_wizard_hinder_agent_assassinate"] = "Assassinate",
	["wh3_main_agent_action_dignitary_hinder_agent_assassinate"] = "Assassinate",
	["wh2_main_agent_action_champion_hinder_settlement_assault_garrison"] = "Assault Garrison",
	["wh2_main_agent_action_dignitary_hinder_settlement_assault_garrison"] = "Assault Garrison",
	["wh2_main_agent_action_engineer_hinder_settlement_assault_garrison"] = "Assault Garrison",
	["wh2_main_agent_action_spy_hinder_settlement_assault_garrison"] = "Assault Garrison",
	["wh2_main_agent_action_wizard_hinder_settlement_assault_garrison"] = "Assault Garrison",
	["wh2_main_agent_action_champion_hinder_army_assault_units"] = "Assault Units",
	["wh2_main_agent_action_dignitary_hinder_army_assault_units"] = "Assault Units",
	["wh2_main_agent_action_engineer_hinder_army_assault_units"] = "Assault Units",
	["wh2_main_agent_action_spy_hinder_army_assault_units"] = "Assault Units",
	["wh2_main_agent_action_wizard_hinder_army_assault_units"] = "Assault Units",
	["wh2_main_agent_action_wizard_hinder_army_assault_unit"] = "Assault Unit",
	["wh2_main_agent_action_champion_hinder_army_block_army"] = "Block Army",
	["wh2_main_agent_action_engineer_hinder_army_block_army"] = "Block Army",
	["wh2_main_agent_action_spy_hinder_army_block_army"] = "Block Army",
	["wh2_main_agent_action_wizard_hinder_army_block_army"] = "Block Army",
	["wh3_main_agent_action_dignitary_hinder_army_block_army"] = "Block Army",
	["wh2_main_agent_action_champion_hinder_settlement_damage_building"] = "Damage Building",
	["wh2_main_agent_action_dignitary_hinder_settlement_damage_building"] = "Damage Building",
	["wh2_main_agent_action_engineer_hinder_settlement_damage_building"] = "Damage Building",
	["wh2_main_agent_action_wizard_hinder_settlement_damage_building"] = "Damage Building",
	["wh2_main_agent_action_champion_hinder_settlement_damage_walls"] = "Damage Walls",
	["wh2_main_agent_action_dignitary_hinder_settlement_damage_walls"] = "Damage Walls",
	["wh2_main_agent_action_engineer_hinder_settlement_damage_walls"] = "Damage Walls",
	["wh2_main_agent_action_runesmith_hinder_settlement_damage_walls"] = "Damage Walls",
	["wh2_main_agent_action_spy_hinder_settlement_damage_walls"] = "Damage Walls",
	["wh2_main_agent_action_wizard_hinder_settlement_damage_walls"] = "Damage Walls",
	["wh2_main_agent_action_champion_hinder_army_hinder_replenishment"] = "Hinder Replenishment",
	["wh2_main_agent_action_dignitary_hinder_army_hinder_replenishment"] = "Hinder Replenishment",
	["wh2_main_agent_action_engineer_hinder_army_hinder_replenishment"] = "Hinder Replenishment",
	["wh2_main_agent_action_runesmith_hinder_army_hinder_replenishment"] = "Hinder Replenishment",
	["wh2_main_agent_action_spy_hinder_army_hinder_replenishment"] = "Hinder Replenishment",
	["wh2_main_agent_action_wizard_hinder_army_hinder_replenishment"] = "Hinder Replenishment",
	["wh2_main_agent_action_engineer_hinder_settlement_steal_technology"] = "Steal Technology",
	["wh2_main_agent_action_wizard_hinder_settlement_steal_technology"] = "Steal Technology",
	["wh2_main_agent_action_champion_hinder_agent_wound"] = "Wound",
	["wh2_main_agent_action_dignitary_hinder_agent_wound"] = "Wound",
	["wh2_main_agent_action_engineer_hinder_agent_wound"] = "Wound",
	["wh2_main_agent_action_runesmith_hinder_agent_wound"] = "Wound",
	["wh2_main_agent_action_spy_hinder_agent_wound"] = "Wound",
	["wh2_main_agent_action_wizard_hinder_agent_wound"] = "Wound"
};

local ACTION_TO_TRAIT = {
	["Assassinate"] = "wh2_main_trait_agent_action_assassinate",
	["Assault Garrison"] = "wh2_main_trait_agent_action_assault_garrison",
	["Assault Unit"] = "wh2_main_trait_agent_action_assault_unit",
	["Assault Units"] = "wh2_main_trait_agent_action_assault_units",
	["Block Army"] = "wh2_main_trait_agent_action_block_army",
	["Damage Building"] = "wh2_main_trait_agent_action_damage_building",
	["Damage Walls"] = "wh2_main_trait_agent_action_damage_walls",
	["Hinder Replenishment"] = "wh2_main_trait_agent_action_hinder_replenishment",
	["Steal Technology"] = "wh2_main_trait_agent_action_steal_technology",
	["Wound"] = "wh2_main_trait_agent_action_wound"
};

------------------------------------------------------------------------------
---- Function: Gives points in a trait to a Lord, with an optional chance ----
------------------------------------------------------------------------------
function Give_Trait(character, trait, _points, _chance, give_yuri)
	local chance = _chance or 100;
	local points = _points or 1;

	if give_yuri then
		character = cm:model():world():faction_by_key(prologue_player_faction):faction_leader()
	end
	
	if character == nil then
		out("TRAIT ERROR: Tried to give trait to a character that was not specified!");
		return false;
	end

	if character:is_null_interface() == true then
		out("TRAIT ERROR: Tried to give trait to a character that was a null interface!");
		return false;
	end
	
	if Check_Exclusion(trait, character) then
		return false;
	end
	
	if cm:model():random_percent(chance) == false then
		return false;
	end
	
	cm:force_add_trait("character_cqi:"..character:cqi(), trait, true, points);
	return true;
end

function Remove_Trait(character, trait)
	if character == nil then
		return false;
	end

	if character:is_null_interface() == true then
		return false;
	end

	cm:force_remove_trait("character_cqi:"..character:cqi(), trait);
	return true;
end

function Check_Exclusion(trait, character)
	local char_faction = character:faction();
	local char_culture = char_faction:culture();
	local char_subculture = char_faction:subculture();
	local char_faction_name = char_faction:name();

	local culture_exclusions = TRAIT_EXCLUSIONS["culture"][trait];
	local subculture_exclusions = TRAIT_EXCLUSIONS["subculture"][trait];
	local faction_exclusions = TRAIT_EXCLUSIONS["faction"][trait];
	
	if culture_exclusions ~= nil then
		for i = 1, #culture_exclusions do
			if culture_exclusions[i] == char_culture then
				return true;
			end
		end
	end
	if subculture_exclusions ~= nil then
		for i = 1, #subculture_exclusions do
			if subculture_exclusions[i] == char_subculture then
				return true;
			end
		end
	end
	if faction_exclusions ~= nil then
		for i = 1, #faction_exclusions do
			if faction_exclusions[i] == char_faction_name then
				return true;
			end
		end
	end
	if character:character_type("colonel") or char_faction:is_quest_battle_faction() then
		return true;
	end

	-- Block AI from getting traits until player enters open world segment.
	if character:faction():name() ~= "wh3_prologue_kislev_expedition" and prologue_check_progression["item_generation"] == false then
		return true
	end
	return false;
end

-------------------------------------------------------------------
---- Function: Retrieves a piece of recorded data about a Lord ----
-------------------------------------------------------------------
function Get_Lord_Record(character, stat_key)
	if character:is_null_interface() == false then
		local char_cqi = character:cqi();
		local val = TRAIT_LORDS_RECORDS[tostring(char_cqi).."_"..stat_key];
		return val;
	end
end

-------------------------------------------------------------------------
---- Function: Records a piece of custom data associated with a Lord ----
-------------------------------------------------------------------------
function Set_Lord_Record(character, stat_key, value)
	if character:is_null_interface() == false then
		local char_cqi = character:cqi();
		TRAIT_LORDS_RECORDS[tostring(char_cqi).."_"..stat_key] = value;
	end
end

-------------------------------------------
---- AGENT ACTIONS AGAINST SUBCULTURES ----
-------------------------------------------
events.CharacterCharacterTargetAction[#events.CharacterCharacterTargetAction+1] =
function (context)
	if context:ability() ~= "assist_army" and (context:mission_result_success() or context:mission_result_critial_success()) then
		local subculture = context:target_character():faction():subculture();
		local own_subculture = context:character():faction():subculture();
		
		if subculture ~= own_subculture and SUBCULTURES_TRAIT_KEYS[subculture] ~= nil then
			Give_Trait(context:character(), "wh2_main_trait_agent_actions_against_"..SUBCULTURES_TRAIT_KEYS[subculture]);
		end
	end
end

events.CharacterGarrisonTargetAction[#events.CharacterGarrisonTargetAction+1] =
function (context)
	if context:mission_result_success() or context:mission_result_critial_success() then
		local subculture = context:garrison_residence():faction():subculture();
		
		if SUBCULTURES_TRAIT_KEYS[subculture] ~= nil then
			Give_Trait(context:character(), "wh2_main_trait_agent_actions_against_"..SUBCULTURES_TRAIT_KEYS[subculture]);
		end
	end
end

------------------------
---- BATTLES FOUGHT ----
------------------------
events.CharacterCompletedBattle[#events.CharacterCompletedBattle+1] =
function (context)
	local character = context:character();
	local side = Get_Character_Side_In_Last_Battle(character);
	local result = "defeat";
	
	if character:won_battle() == true then
		result = "victory";
	end
	
	if context:pending_battle():siege_battle() == true and context:pending_battle():battle_type() == "settlement_standard" then
		Give_Trait(character, "wh2_main_trait_siege_"..result);
	else
		if side == "Attacker" then
			Give_Trait(character, "wh2_main_trait_attacking_"..result);
		elseif side == "Defender" then
			Give_Trait(character, "wh2_main_trait_defending_"..result);
		end
	end
end

-------------------------------------
---- BATTLES AGAINST SUBCULTURES ----
-------------------------------------
events.CharacterCompletedBattle[#events.CharacterCompletedBattle+1] =
function (context)
	GeneralCompletedBattle(context);
end
events.CharacterParticipatedAsSecondaryGeneralInBattle[#events.CharacterParticipatedAsSecondaryGeneralInBattle+1] =
function (context)
	GeneralCompletedBattle(context);
end

function GeneralCompletedBattle(context)
	local character = context:character();
	local side = Get_Character_Side_In_Last_Battle(character);
	local enemy_culture = "";
	local enemy_subculture = "";
	
	if side == "Attacker" then
		local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_defender(1);
		local world = cm:model():world();
		
		if world:faction_exists(faction_name) then
			local faction = world:faction_by_key(faction_name);
			enemy_culture = faction:culture();
			enemy_subculture = faction:subculture();	
		end;
	elseif side == "Defender" then
		local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_attacker(1);
		local world = cm:model():world();
		
		if world:faction_exists(faction_name) then
			local faction = world:faction_by_key(faction_name);
			enemy_culture = faction:culture();
			enemy_subculture = faction:subculture();	
		end;
	end
	
	if character:faction():subculture() ~= enemy_subculture and SUBCULTURES_TRAIT_KEYS[enemy_subculture] ~= nil then
		if character:won_battle() == true then
			Give_Trait(context:character(), "wh2_main_trait_wins_against_"..SUBCULTURES_TRAIT_KEYS[enemy_subculture]);
		else
			Give_Trait(context:character(), "wh2_main_trait_defeats_against_"..SUBCULTURES_TRAIT_KEYS[enemy_subculture]);
		end
		
	elseif enemy_culture == "wh2_main_rogue" then
		Give_Trait(context:character(), "wh2_main_trait_wins_against_rogue_armies");
	end
end

function Get_Character_Side_In_Last_Battle(character)
	for i = 1, cm:pending_battle_cache_num_attackers() do
		local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_attacker(i);
		
		if char_cqi == character:cqi() then
			return "Attacker";
		end
	end
	for i = 1, cm:pending_battle_cache_num_defenders() do
		local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_defender(i);
		
		if char_cqi == character:cqi() then
			return "Defender";
		end
	end
	return "";
end

---------------------------------
---- REINFORCING SUBCULTURES ----
---------------------------------
events.CharacterCompletedBattle[#events.CharacterCompletedBattle+1] =
function (context)
	if cm:char_is_general_with_army(context:character()) then
		local primary_attacker_char_cqi, primary_attacker_mf_cqi, primary_attacker_faction_name = cm:pending_battle_cache_get_attacker(1);
		local primary_attacker = cm:model():character_for_command_queue_index(primary_attacker_char_cqi);
		
		if primary_attacker:is_null_interface() == false then
			if primary_attacker:command_queue_index() ~= context:character():command_queue_index() then -- We don't check reinforcement for this battle if this is the primary character
				if cm:pending_battle_cache_num_attackers() > 1 then
					local primary_attacker_subculture = primary_attacker:faction():subculture();
					
					for i = 2, cm:pending_battle_cache_num_attackers() do
						local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_attacker(i);
						local char_obj = cm:model():character_for_command_queue_index(char_cqi);
						
						if char_obj:is_null_interface() == false then
							local char_subculture = char_obj:faction():subculture();
							
							if char_subculture == primary_attacker_subculture then
								-- Reinforced Yourself
								Give_Trait(char_obj, "wh2_main_trait_reinforcing");
							elseif SUBCULTURES_TRAIT_KEYS[primary_attacker_subculture] ~= nil then
								-- Reinforced Others
								local trait = "wh2_main_trait_reinforcing_"..SUBCULTURES_TRAIT_KEYS[primary_attacker_subculture];
								Give_Trait(char_obj, trait);
							end
						end
					end
				end
			end
		end
		
		local primary_defender_char_cqi, primary_defender_mf_cqi, primary_defender_faction_name = cm:pending_battle_cache_get_defender(1);
		local primary_defender = cm:model():character_for_command_queue_index(primary_defender_char_cqi);
		
		if primary_defender:is_null_interface() == false then
			if primary_defender:command_queue_index() ~= context:character():command_queue_index() then -- We don't check reinforcement for this battle if this is the primary character
				if cm:pending_battle_cache_num_defenders() > 1 then
					local primary_defender_subculture = primary_defender:faction():subculture();
					
					for i = 2, cm:pending_battle_cache_num_defenders() do
						local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_defender(i);
						local char_obj = cm:model():character_for_command_queue_index(char_cqi);
						
						if char_obj:is_null_interface() == false then
							local char_subculture = char_obj:faction():subculture();
							
							if char_subculture == primary_defender_subculture then
								-- Reinforced Yourself
								Give_Trait(char_obj, "wh2_main_trait_reinforcing");
							elseif SUBCULTURES_TRAIT_KEYS[primary_defender_subculture] ~= nil then
								-- Reinforced Others
								local trait = "wh2_main_trait_reinforcing_"..SUBCULTURES_TRAIT_KEYS[primary_defender_subculture];
								Give_Trait(char_obj, trait);
							end
						end
					end
				end
			end
		end
	end
end

--------------------------------
---- TURNS IN ENEMY REGIONS ----
--------------------------------
events.CharacterTurnStart[#events.CharacterTurnStart+1] =
function (context)
	local character = context:character();

	if character:is_null_interface() == false then
		if cm:char_is_general_with_army(character) and character:has_region() and not character:region():is_abandoned() then
			if character:turns_in_enemy_regions() >= 20 then
				if character:trait_points("wh2_main_trait_lone_wolf") == 2 then
					Give_Trait(character, "wh2_main_trait_lone_wolf");
				end
			elseif character:turns_in_enemy_regions() >= 15 then
				if character:trait_points("wh2_main_trait_lone_wolf") == 1 then
					Give_Trait(character, "wh2_main_trait_lone_wolf");
				end
			elseif character:turns_in_enemy_regions() >= 10 then
				if character:trait_points("wh2_main_trait_lone_wolf") == 0 then
					Give_Trait(character, "wh2_main_trait_lone_wolf");
				end
			end
		end
	end
end

-------------------------
---- TIME IN STANCES ----
-------------------------
events.CharacterTurnEnd[#events.CharacterTurnEnd+1] =
function (context)
	local character = context:character();
	
	if cm:char_is_general_with_army(character) then
		local stance = character:military_force():active_stance();
		local culture = character:faction():culture();
		
		-- RAIDING
		if stance == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID" or stance == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_SET_CAMP_RAIDING" then
			Give_Trait(character, "wh2_main_trait_stance_raiding");
		-- AMBUSHING
		elseif stance == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_AMBUSH" then
			Give_Trait(character, "wh2_main_trait_stance_ambushing");
		-- TUNNELING
		elseif stance == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_TUNNELING" then
			Give_Trait(character, "wh2_main_trait_stance_tunneling");
		-- FORCED MARCH
		elseif stance == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_MARCH" then
			Give_Trait(character, "wh2_main_trait_stance_forced_march");
		-- RECRUITING
		elseif stance == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_MUSTER" then
			Give_Trait(character, "wh2_main_trait_stance_recruiting");
		-- STALKING
		elseif stance == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_STALKING" and culture == "wh2_main_skv_skaven" then
			Give_Trait(character, "wh2_main_trait_stance_stalking");
		-- LILEATH
		elseif stance == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_CHANNELING" and culture == "wh2_main_hef_high_elves" then
			Give_Trait(character, "wh2_main_trait_stance_channeling");
		-- ASTROMANCY
		elseif stance == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_ASTROMANCY" and culture == "wh2_main_lzd_lizardmen" then
			Give_Trait(character, "wh2_main_trait_stance_astromancy");
		end
	end
end

-----------------------------
---- SACKING SETTLEMENTS ----
-----------------------------
events.CharacterSackedSettlement[#events.CharacterSackedSettlement+1] =
function (context)
	if cm:char_is_general_with_army(context:character()) then
		Give_Trait(context:character(), "wh2_main_trait_sacking");
	end
end

-----------------------------
---- RAZING SETTLEMENTS ----
-----------------------------
events.CharacterRazedSettlement[#events.CharacterRazedSettlement+1] =
function (context)
	if cm:char_is_general_with_army(context:character()) then
		Give_Trait(context:character(), "wh2_main_trait_razing");
	end
end

--------------------------
---- ROUTED IN BATTLE ----
--------------------------
events.CharacterCompletedBattle[#events.CharacterCompletedBattle+1] =
function (context)
	if cm:char_is_general_with_army(context:character()) then
		if context:character():routed_in_battle() and context:character():won_battle() == false then
			Give_Trait(context:character(), "wh2_main_trait_routed");
		elseif context:character():routed_in_battle() == false and context:character():won_battle() == true and context:character():fought_in_battle() then
			Give_Trait(context:character(), "wh2_main_trait_fighter");
		end
	end
end

-------------------------------
---- POST-BATTLE RANSOMING ----
-------------------------------
events.CharacterPostBattleCaptureOption[#events.CharacterPostBattleCaptureOption+1] =
function (context)
	if context:get_outcome_key() == "release" and cm:char_is_general_with_army(context:character()) then
		Give_Trait(context:character(), "wh2_main_trait_post_battle_ransom", 2);
	end
end

-------------------------------
---- POST-BATTLE EXECUTING ----
-------------------------------
events.CharacterPostBattleCaptureOption[#events.CharacterPostBattleCaptureOption+1] =
function (context)
	if context:get_outcome_key() == "kill" and cm:char_is_general_with_army(context:character()) then
		Give_Trait(context:character(), "wh3_main_prologue_trait_post_battle_execute", 2);
	end
end

--------------------------------------
---- IN OWNED SETTLEMENT TOO LONG ----
--------------------------------------
events.CharacterTurnStart[#events.CharacterTurnStart+1] =
function (context)
	local character = context:character();
	
	if character:faction():is_human() and character:has_region() and character:faction():is_allowed_to_capture_territory() and cm:char_is_general_with_army(character) then
		if character:in_settlement() and character:military_force():active_stance() ~= "MILITARY_FORCE_ACTIVE_STANCE_TYPE_MUSTER" then
			local char_turns_being_lazy = Get_Lord_Record(character, "turns_lazy") or 0;
			char_turns_being_lazy = char_turns_being_lazy + 1;
			
			if char_turns_being_lazy >= 20 then
				Give_Trait(character, "wh2_main_trait_lazy");
				Set_Lord_Record(character, "turns_lazy", 0);
			else
				Set_Lord_Record(character, "turns_lazy", char_turns_being_lazy);
			end
		else
			Set_Lord_Record(character, "turns_lazy", 0);
		end
	end;
end

--------------------------------------------
---- IN REGION WHEN BUILDINGS ARE BUILT ----
--------------------------------------------
events.BuildingCompleted[#events.BuildingCompleted+1] =
function (context)
	local building = context:building();
	local faction = building:faction()

	if faction:character_list():num_items() > 1 then
		for i = 0, faction:character_list():num_items() - 1 do
			local builder = faction:character_list():item_at(i);
			
			if builder:has_region() and cm:char_is_general_with_army(builder) and builder:region():name() == building:region():name() then
				Give_Trait(builder, "wh2_main_trait_builder");
			end
		end
	end
end

------------------------------------------------
---- ARMY SUFFERS HIGH CASUALTIES IN BATTLE ----
------------------------------------------------
events.CharacterCompletedBattle[#events.CharacterCompletedBattle+1] =
function (context)
	local character = context:character();
	
	if cm:char_is_general_with_army(character) then
		local losses = character:percentage_of_own_alliance_killed();
		
		if losses >= 0.6 then
			Give_Trait(character, "wh2_main_trait_casualties");
		end
	end
end

-----------------------------------------
---- AGENT ACTIONS AGAINST CHARACTER ----
-----------------------------------------
events.CharacterCharacterTargetAction[#events.CharacterCharacterTargetAction+1] =
function (context)
	local target = context:target_character();
	
	if context:ability() == "assist_army" or context:ability() == "assist_province" or context:ability() == "command_force" or context:ability() == "passive_ability" then
		return false;
	end
	
	if context:mission_result_success() == true or context:mission_result_critial_success() == true then
	
		if target:is_null_interface() == false then
			Give_Trait(target, "wh2_main_trait_agent_target_success");
			
			if context:agent_action_key() == "wh2_main_agent_action_champion_hinder_agent_assassinate" or context:agent_action_key() == "wh2_main_agent_action_spy_hinder_agent_assassinate" then
				Give_Trait(target, "wh2_main_trait_wounded");
			end
		end
	elseif context:mission_result_opportune_failure() == true or context:mission_result_failure() == true or context:mission_result_critial_failure() == true then
		if target:is_null_interface() == false then
			Give_Trait(target, "wh2_main_trait_agent_target_fail");
		end
	end
end

-----------------------------
---- AGENT ACTION TRAITS ----
-----------------------------
events.CharacterCharacterTargetAction[#events.CharacterCharacterTargetAction+1] =
function (context)
	if context:mission_result_critial_success() or context:mission_result_success() then
		local trait_key = ACTION_TO_TRAIT[ACTION_KEY_TO_ACTION[context:agent_action_key()]];
		if trait_key ~= nil then
			Give_Trait(context:character(), trait_key);
		end
	end
end

events.CharacterGarrisonTargetAction[#events.CharacterGarrisonTargetAction+1] =
function (context)
	if context:mission_result_critial_success() or context:mission_result_success() then
		local trait_key = ACTION_TO_TRAIT[ACTION_KEY_TO_ACTION[context:agent_action_key()]];
		if trait_key ~= nil then
			Give_Trait(context:character(), trait_key);
		end
	end
end