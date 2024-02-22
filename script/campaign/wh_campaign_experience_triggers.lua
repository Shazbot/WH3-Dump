
campaign_experience_triggers = {

-- high-level variables
	xp_per_gold_value_killed_exponent				= 0.88,		-- exponent applied to the rough value of enemy units killed.
	battle_xp_base									= 300,		-- base value granted for any battle. This is modified by the portion of the enemy army actually killed.
	battle_xp_max 									= 10000	,	-- absolute max, just in case

-- additional multpliers to apply after result is calculated
	xp_battle_modifier_survival						= 0.5,		-- this is the modifier to the above values when the battle was a survival battle
	xp_battle_modifier_hero							= 0.75,		-- this is the modifier to the above values when the participating character is a Hero
	xp_battle_modifier_secondary_general			= 0.5,		-- this is the modifier to the above values when the participating character is a reinforcing Lord


	-- amount of experience to give Lords
	xp_general_completes_horde_building 			= 200,
	xp_general_occupies_settlement					= 200,
	xp_general_razes_settlement						= 200,
	xp_general_completes_caravan_route				= 2000,

	-- amount of experience to give Heroes
	xp_hero_is_active	 							= 50,

	xp_hero_target_settlement_fail_critical			= 200,
	xp_hero_target_settlement_fail					= 400,
	xp_hero_target_settlement_fail_opportune		= 600,
	xp_hero_target_settlement_success				= 1200,

	xp_hero_target_army_fail_critical				= 200,
	xp_hero_target_army_fail						= 400,
	xp_hero_target_army_fail_opportune				= 600,
	xp_hero_target_army_success						= 1200,

	xp_hero_target_character_fail_critical			= 200,
	xp_hero_target_character_fail					= 400,
	xp_hero_target_character_fail_opportune			= 600,
	xp_hero_target_character_success				= 1000,
	xp_hero_target_character_success_critical		= 1600,
	xp_hero_target_character_success_bonus_10		= 300,		-- this is added if the assassination target is > rank 10
	xp_hero_target_character_success_bonus_20		= 600,		-- this is added if the assassination target is > rank 20

	subtype_groups = {
		"hef_casters",
		"def_casters",
		"chs_undivided",
		"chs_slaanesh",
		"chs_tzeentch",
		"chs_nurgle",
		"chs_khorne",
		"saurus",
		"chd_convoy"
	},

	---bonus values that modify the xp gain from all sources
	xp_groups_to_xp_mod_bonus_values = {
		chs_khorne = "experience_mod_chs_khorne",
		chs_nurgle = "experience_mod_chs_nurgle",
		chs_slaanesh = "experience_mod_chs_slaanesh",
		chs_tzeentch = "experience_mod_chs_tzeentch",
		chs_undivided = "experience_mod_chs_undivided",
		def_casters = "experience_mod_for_def_casters",
		hef_casters = "experience_mod_for_hef_casters",
		saurus = "experience_mod_for_saurus_characters"
	},

	---bonus values that add a flat XP amount per turn
	xp_groups_to_xp_add_bonus_values = {
		def_casters = "experience_for_def_casters",
		hef_casters = "experience_for_hef_casters",
		chd_convoy = "experience_for_convoy_masters",
	}
}
function campaign_experience_triggers:setup_experience_triggers()
	core:add_listener(
		"CharacterTurnStart_experience",
		"CharacterTurnStart",
		function()
			return cm:model():turn_number() > 1;
		end,
		function(context)
			local character = context:character();

			-- agent is active
			if not character:is_wounded() and cm:char_is_agent(character) then
				self:add_experience(context, false, self.xp_hero_is_active);
			end;

			-- bonus values
			local bv = character:bonus_values();

			-- generic
			local experience_bonus = bv:scripted_value("experience", "value");
			if experience_bonus > 0 then
				self:add_experience(context, false, experience_bonus);
			end;

			---specific
			local agent_xp_groups = self:get_xp_groups_for_character(character)

			local xp_group_bonus = 0

			if agent_xp_groups then
				for i = 1, #agent_xp_groups do
					local agent_group = agent_xp_groups[i]
					if self.xp_groups_to_xp_add_bonus_values[agent_group] then
						xp_group_bonus = xp_group_bonus + bv:scripted_value(self.xp_groups_to_xp_add_bonus_values[agent_group], "value");
					end
				end
			end

			self:add_experience(context, false, xp_group_bonus, true);

		end,
		true
	);
	
	core:add_listener(
		"GarrisonOccupiedEvent_experience",
		"GarrisonOccupiedEvent",
		true,
		function(context)
			-- general captures and occupies a settlement
			self:add_experience(context, true, self.xp_general_occupies_settlement);
		end,
		true
	);
	
	core:add_listener(
		"CharacterRazedSettlement_experience",
		"CharacterRazedSettlement",
		true,
		function(context)
			-- general captures and razes a settlement
			self:add_experience(context, true, self.xp_general_razes_settlement);
		end,
		true
	);
	
	core:add_listener(
		"CaravanCompleted_experience",
		"CaravanCompleted",
		true,
		function(context)
			-- caravan master completes caravan route
			local character = context:caravan_master():character();
			
			if not character:is_null_interface() then
				self:add_experience(character, true, self.xp_general_completes_caravan_route);
			end;
		end,
		true
	);
	
	core:add_listener(
		"MilitaryForceBuildingCompleteEvent_experience",
		"MilitaryForceBuildingCompleteEvent",
		true,
		function(context)
			-- horde general constructs a building
			self:add_experience(context, true, self.xp_general_completes_horde_building);
		end,
		true
	);
	
	core:add_listener(
		"CharacterGarrisonTargetAction_experience",
		"CharacterGarrisonTargetAction",
		true,
		function(context)
			-- agent targets a settlement
			-- ignore if an agent is scouting ruins
			if context:agent_action_key():find("scout_settlement") and context:garrison_residence():faction():culture() ~= "wh2_main_skv_skaven" then
				return;
			end;
			
			local value = self.xp_hero_target_settlement_success;
			
			if context:mission_result_critial_failure() then
				value = self.xp_hero_target_settlement_fail_critical;
			elseif context:mission_result_failure() then
				value = self.xp_hero_target_settlement_fail;
			elseif context:mission_result_opportune_failure() then
				value = self.xp_hero_target_settlement_fail_opportune;
			end;
			
			self:add_experience(context, false, value);
		end,
		true
	);
	
	core:add_listener(
		"CharacterCharacterTargetAction_experience",
		"CharacterCharacterTargetAction",
		true,
		function(context)
			local ability = context:ability();
			
			-- agent targets an army
			if ability == "hinder_army" then
				local value = self.xp_hero_target_army_success;
				
				if context:mission_result_critial_failure() then
					value = self.xp_hero_target_army_fail_critical;
				elseif context:mission_result_failure() then
					value = self.xp_hero_target_army_fail;
				elseif context:mission_result_opportune_failure() then
					value = self.xp_hero_target_army_fail_opportune;
				end;
				
				self:add_experience(context, false, value);
				
			-- agent targets a character (assassination)
			elseif ability == "hinder_character" or ability == "hinder_agent" then
				local value = self.xp_hero_target_character_fail;
				local target_rank = context:target_character():rank();
				
				if context:mission_result_critial_failure() then
					value = self.xp_hero_target_character_fail_critical;
				elseif context:mission_result_opportune_failure() then
					value = self.xp_hero_target_character_fail_opportune;
				elseif context:mission_result_critial_success() then
					value = self.xp_hero_target_character_success_critical + self:add_assassination_bonus(target_rank);
				elseif context:mission_result_success() then
					value = self.xp_hero_target_character_success + self:add_assassination_bonus(target_rank);
				end;
				
				self:add_experience(context, false, value);
			end;
		end,
		true
	);
	
	core:add_listener(
		"CharacterCompletedBattle_experience",
		"CharacterCompletedBattle",
		true,
		function(context)
			-- general completes a battle
			self:calculate_battle_result_experience(context, true, false);
		end,
		true
	);
	
	core:add_listener(
		"HeroCharacterParticipatedInBattle_experience",
		"HeroCharacterParticipatedInBattle",
		true,
		function(context)
			-- embedded agent completes a battle
			self:calculate_battle_result_experience(context, false, false);
		end,
		true
	);
	
	core:add_listener(
		"CharacterParticipatedAsSecondaryGeneralInBattle_experience",
		"CharacterParticipatedAsSecondaryGeneralInBattle",
		true,
		function(context)
			-- reinforcing general completes a battle
			self:calculate_battle_result_experience(context, true, true);
		end,
		true
	);
end;

function campaign_experience_triggers:add_assassination_bonus(target_rank)
	if target_rank > 10 and target_rank < 21 then
		return self.xp_hero_target_character_success_bonus_10;
	elseif target_rank > 20 then
		return self.xp_hero_target_character_success_bonus_20;
	else
		return 0;
	end;
end;

function campaign_experience_triggers:calculate_battle_result_experience(context, is_general, is_secondary_general)
	local value = 0;
	local pb = cm:model():pending_battle();
	local character = context:character();
	local is_attacker = false;

	if pb:ended_with_withdraw() then
		-- don't award XP if the battle ended with withdraw
		return false;
	end;

	for i = 1, cm:pending_battle_cache_num_attackers() do
		local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_attacker(i);
		
		if character:faction():name() == current_faction_name then
			is_attacker = true;
			break;
		end;
	end;
	
	local enemy_value = 0
	local enemy_proportion_killed = 1

	if is_attacker then
		enemy_value =  cm:pending_battle_cache_defender_value()
		enemy_proportion_killed = pb:percentage_of_defender_killed()
	else
		enemy_value = cm:pending_battle_cache_attacker_value() 
		enemy_proportion_killed =  pb:percentage_of_attacker_killed()
	end;

	local modified_base =  self.battle_xp_base * enemy_proportion_killed
	local modified_enemy_value = enemy_value*enemy_proportion_killed

	local value = math.min(modified_base + modified_enemy_value ^ self.xp_per_gold_value_killed_exponent, self.battle_xp_max)

	
	if not is_general then
		value = value * self.xp_battle_modifier_hero;
	elseif is_secondary_general then
		value = value * self.xp_battle_modifier_secondary_general;
	end;
	
	if pb:battle_type() == "survival" then
		value = value * self.xp_battle_modifier_survival;
	end;
	
	-- faction tracker mod (used by nkari)
	local experience_mod_for_new_factions = character:bonus_values():scripted_value("experience_mod_for_new_factions", "value");
	local mod = false;
	
	if experience_mod_for_new_factions > 0 then
		local save_value_name = character:command_queue_index() .. "_faction_history";
		local faction_history = cm:get_saved_value(save_value_name) or {};
		local faction_fought = false;
		
		local char_cqi, mf_cqi, faction_key = false, false, false;
		
		if is_attacker then
			char_cqi, mf_cqi, faction_key = cm:pending_battle_cache_get_defender(1);
		else
			char_cqi, mf_cqi, faction_key = cm:pending_battle_cache_get_attacker(1);
		end;
		
		for i = 1, #faction_history do
			if faction_key == faction_history[i] then
				faction_fought = true;
				break;
			end;
		end;
		
		if not faction_fought then
			table.insert(faction_history, faction_key);
			
			cm:set_saved_value(save_value_name, faction_history);
			
			mod = 1 + experience_mod_for_new_factions / 100;
		end;
	end;
	
	self:add_experience(context, is_general, math.round(value), false, mod);
end;


function campaign_experience_triggers:add_experience(context, is_general, value, ignore_xp_mod_bonuses, mod)
	local character = false;
	
	if is_character(context) then
		character = context;
	else
		character = context:character();
	end;
	
	-- bonus values --
	local bv = character:bonus_values();
	local faction = character:faction();
	local character_subtype = character:character_subtype_key();
	local mod = mod or 1;
	
	mod = mod + bv:scripted_value("experience_mod", "value") / 100;
	
	if character:is_caster() then
		mod = mod + bv:scripted_value("experience_mod_for_spellcasters", "value") / 100;
	end;
	
	-- xp_group bonus mods

	if not ignore_xp_mod_bonuses then
		local agent_xp_groups = self:get_xp_groups_for_character(character)

		if agent_xp_groups then
			for i = 1, #agent_xp_groups do
				local agent_group = agent_xp_groups[i]
				if self.xp_groups_to_xp_mod_bonus_values[agent_group] then
					mod = mod + bv:scripted_value(self.xp_groups_to_xp_mod_bonus_values[agent_group], "value")/100;
				end
			end
		end
	end
	
	local amount_to_add = value * mod
	
	if amount_to_add > 0 then
		cm:get_game_interface():add_agent_experience(cm:char_lookup_str(character), amount_to_add);
	end;
end;

function campaign_experience_triggers:get_xp_groups_for_character(character_interface)
	local groups = {}
	local groups_found = false

	for i = 1, #self.subtype_groups do
		if character_interface:is_part_of_subtype_set(self.subtype_groups[i]) then
			table.insert(groups, self.subtype_groups[i])
			groups_found = true
		end
	end
	if groups_found == false then
		return false
	end

	return groups
end