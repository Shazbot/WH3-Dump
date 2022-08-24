chivalry = {

	thresholds = {
		2000, 4000, 6000, 8000, 10000
	},

	battle_result_values = {
		heroic_victory = 50,
		decisive_victory = 20,
		close_victory = 10,
		pyrrhic_victory = 5,
		valiant_defeat = -2,
		close_defeat = -5,
		decisive_defeat = -10,
		crushing_defeat = -20
	},

	tech_flat_bonus = {
		wh_dlc07_tech_brt_economy_other_4 = 200,
		tech_dlc14_brt_code_of_conduct = 100,
		wh2_dlc12_tech_brt_chivalry_start = 50,
		wh_dlc07_tech_brt_heraldry_artois = 100,
		wh_dlc07_tech_brt_heraldry_bastonne = 100,
		wh_dlc07_tech_brt_heraldry_bordeleaux = 100,
		wh_dlc07_tech_brt_heraldry_bretonnia = 100,
		wh_dlc07_tech_brt_heraldry_carcassonne = 100,
		wh_dlc07_tech_brt_heraldry_lyonesse = 100,
		wh_dlc07_tech_brt_heraldry_parravon = 100,
		wh3_main_tech_brt_heraldry_aquitaine = 100,
		tech_dlc14_brt_heroic_duties = 100,
		tech_dlc14_brt_prayer_of_fortitude = 100,
		tech_dlc14_brt_rally_the_peasants = 200,
		tech_dlc14_brt_righteous_strength = 100,
		wh_dlc07_tech_brt_heraldry_errantry = 100,
		wh_dlc07_tech_brt_economy_other_tithes = 200,
		wh_dlc07_tech_brt_heraldry_start = 50,
		tech_dlc14_brt_the_ladys_favour = 100,
		wh_dlc07_tech_brt_heraldry_unification = 200
	},

	subcultures_to_bonus_values = {
		wh_dlc03_sc_bst_beastmen = "chivalry_from_battles_beastmen",
		wh_main_sc_grn_greenskins = "chivalry_from_battles_greenskins",
		wh_main_sc_grn_savage_orcs = "chivalry_from_battles_greenskins",
		wh_main_sc_chs_chaos = "chivalry_from_battles_greenskins",
		wh3_main_sc_dae_daemons = "chivalry_from_battles_chaos",
		wh3_main_sc_kho_khorne = "chivalry_from_battles_chaos",
		wh3_main_sc_nur_nurgle = "chivalry_from_battles_chaos",
		wh3_main_sc_sla_slaanesh = "chivalry_from_battles_chaos",
		wh3_main_sc_tze_tzeentch = "chivalry_from_battles_chaos",
		wh_dlc08_sc_nor_norsca = "chivalry_from_battles_norsca",
		wh_main_sc_vmp_vampire_counts = "chivalry_from_battles_vampire_counts",
		wh_dlc05_sc_wef_wood_elves = "chivalry_from_battles_wood_elves",
		wh2_main_sc_def_dark_elves = "chivalry_from_battles_dark_elves",
		wh2_main_sc_skv_skaven = "chivalry_from_battles_skaven",
		wh2_dlc09_sc_tmb_tomb_kings = "chivalry_from_battles_tomb_kings",
		wh2_dlc11_sc_cst_vampire_coast = "chivalry_from_battles_vampire_coast",
	},


	--- used in virtues_and_traits.lua for checking for trait removal
	bad_traits = {
		wh_dlc07_trait_brt_lord_bad_abducter = {
			levels = {
				{level = 1, points = 5}
			}
		},
		wh_dlc07_trait_brt_lord_bad_attacker = {
			levels = {
				{level = 1, points = 4},
				{level = 2, points = 7},
				{level = 3, points = 10}
			}
		},
		wh_dlc07_trait_brt_lord_bad_coward = {
			levels = {
				{level = 1, points = 5}
			}
		},
		wh_dlc07_trait_brt_lord_bad_defeat = {
			levels = {
				{level = 1, points = 1},
				{level = 2, points = 3}
			}
		},
		wh_dlc07_trait_brt_lord_bad_defender = {
			levels = {
				{level = 1, points = 3},
				{level = 2, points = 5},
				{level = 3, points = 7}
			}
		},
		wh_dlc07_trait_brt_lord_bad_kingslayer = {
			levels = {
				{level = 1, points = 1}
			}
		},
		wh_dlc07_trait_brt_lord_bad_lazy = {
			levels = {
				{level = 1, points = 1},
				{level = 2, points = 2}
			}
		},
		wh_dlc07_trait_brt_lord_bad_perverted = {
			levels = {
				{level = 1, points = 3}
			}
		},
		wh_dlc07_trait_brt_lord_bad_raider = {
			levels = {
				{level = 1, points = 5}
			}
		},
		wh_dlc07_trait_brt_lord_bad_renegade = {
			levels = {
				{level = 1, points = 3}
			}
		},
		wh_dlc07_trait_brt_lord_bad_sacking = {
			levels = {
				{level = 1, points = 3},
				{level = 2, points = 6},
				{level = 3, points = 9}
			}
		},
		wh_dlc07_trait_brt_lord_bad_scared_of_beastmen = {
			levels = {
				{level = 1, points = 4}
			}
		},
		wh_dlc07_trait_brt_lord_bad_scared_of_chaos = {
			levels = {
				{level = 1, points = 4}
			}
		},
		wh_dlc07_trait_brt_lord_bad_scared_of_greenskins = {
			levels = {
				{level = 1, points = 4}
			}
		},
		wh_dlc07_trait_brt_lord_bad_scared_of_vampires = {
			levels = {
				{level = 1, points = 4}
			}
		},
		wh_dlc07_trait_brt_lord_bad_sieging = {
			levels = {
				{level = 1, points = 3},
				{level = 2, points = 5},
				{level = 3, points = 7}
			}
		},
		wh_dlc07_trait_brt_lord_bad_traitor = {
			levels = {
				{level = 1, points = 1}
			}
		},
		wh_dlc07_trait_brt_lord_bad_villain = {
			levels = {
				{level = 1, points = 3}
			}
		}
	},

	pooled_resource = "brt_chivalry",

	battle_factor = "battles",
	tech_factor = "technology",

	bretonnian_war_factor = "declared_war_on_bretonnia",
	bretonnian_war_value = -200,
};

function Add_Chivalry_Listeners()
	out("#### Adding Chivalry Listeners ####");
	core:add_listener(
		"ChivalryBattleCompleted",
		"BattleCompleted",
		function() return cm:model():pending_battle():has_been_fought() end,
		function(context) chivalry:BattleCompleted(context) end,
		true
	);
	core:add_listener(
		"ChivalryVariationMonitor",
		"ScriptEventHumanFactionTurnStart",
		true,
		function(context) chivalry:VariationMonitor(context) end,
		true
	);
	core:add_listener(
		"ChivalryNegativeDiplomaticEvent",
		"NegativeDiplomaticEvent",
		true,
		function(context) chivalry:NegativeDiplomaticEvent(context) end,
		true
	);
	core:add_listener(
		"ChivalryResearchCompleted",
		"ResearchCompleted",
		true,
		function(context) chivalry:ResearchCompleted(context) end,
		true
	);
end

function chivalry:ResearchCompleted(context)
	local faction = context:faction();
	local tech_key = context:technology();
	if faction:culture() == "wh_main_brt_bretonnia" and self.tech_flat_bonus[tech_key] then
		local tech_bonus = self.tech_flat_bonus[tech_key]
		self:ModifyChivalry(faction:name(), self.tech_factor, tech_bonus)
	end
end


-- BATTLES
function chivalry:BattleCompleted(context)
	local num_attackers = cm:pending_battle_cache_num_attackers();
	local num_defenders = cm:pending_battle_cache_num_defenders();
	
	if num_attackers < 1 or num_defenders < 1 then
		return false;
	end
	
	--------------------------------------------------
	---- MAKE A LIST OF BRETONNIANS IN THE BATTLE ----
	--------------------------------------------------
	local bret_attackers = {};
	local bret_defenders = {};
	
	for i = 1, num_attackers do
		local attacker_cqi, attacker_force_cqi, attacker_name = cm:pending_battle_cache_get_attacker(i);
		local attacker = cm:get_faction(attacker_name);
		
		if attacker and attacker:culture() == "wh_main_brt_bretonnia" then
			table.insert(bret_attackers, attacker_name);
		end
	end

	for i = 1, num_defenders do
		local defender_cqi, defender_force_cqi, defender_name = cm:pending_battle_cache_get_defender(i);
		local defender = cm:get_faction(defender_name);
		
		if defender and defender:culture() == "wh_main_brt_bretonnia" then
			table.insert(bret_defenders, defender_name);
		end
	end
	
	---------------------------------------------------
	---- GIVE chivalry TO ALL RELEVANT BRETONNIANS ----
	---------------------------------------------------
	local primary_attacker_cqi, primary_attacker_force_cqi, primary_attacker_name = cm:pending_battle_cache_get_attacker(1);
	local primary_defender_cqi, primary_defender_force_cqi, primary_defender_name = cm:pending_battle_cache_get_defender(1);
	local primary_attacker = cm:get_faction(primary_attacker_name);
	local primary_defender = cm:get_faction(primary_defender_name);
	
	local attacker_result = cm:model():pending_battle():attacker_battle_result();
	local defender_result = cm:model():pending_battle():defender_battle_result();
	
	for i = 1, #bret_attackers do
		local attacker = cm:model():world():faction_by_key(bret_attackers[i]);
	
		if attacker:is_null_interface() == false and attacker:is_dead() == false then
			local attacker_name = attacker:name();
			out("\tAttacker: "..attacker_name);
			local chivalry_value = self.battle_result_values[attacker_result];
						
			local chivalry_bonus = 0;
			if primary_defender then
				chivalry_bonus = self:GetTechBonusForFaction(attacker_name, primary_defender:subculture());
				out("\tChivalry Reward: "..tostring(chivalry_value)..", and "..chivalry_bonus.." bonus from tech for fighting "..primary_defender:subculture());
			end
			
			if chivalry_value ~= nil then
				out("\tChivalry Factor: "..self.battle_factor);
							
				local change = chivalry_value + chivalry_bonus;
				out("\tNew chivalry: "..change);
				self:ModifyChivalry(attacker_name, self.battle_factor, change)
				
			end
		end
	end
	
	for i = 1, #bret_defenders do
		local defender = cm:model():world():faction_by_key(bret_defenders[i]);
	
		if defender:is_null_interface() == false and defender:is_dead() == false then
			local defender_name = defender:name();
			out("\tDefender: "..defender_name);
			local chivalry_value = self.battle_result_values[defender_result];
			out("\tChivalry Reward: "..tostring(chivalry_value));
			
			local chivalry_bonus = 0;
			if primary_attacker then
				chivalry_bonus = self:GetTechBonusForFaction(defender_name, primary_attacker:subculture());
			end
			out("\tBonus chivalry: "..chivalry_bonus);
			
			if chivalry_value ~= nil then
				out("\tChivalry Factor: "..self.battle_factor..defender_result);
				
				local change = chivalry_value + chivalry_bonus
				out("\tNew chivalry: "..change);
				self:ModifyChivalry(defender_name, self.battle_factor, change)
				
			end
			
		end
	end
end

--Update the chivalry pooled resource for a faction
function chivalry:ModifyChivalry(faction_key, factor, value)
	out("\tChanging chivalry for "..faction_key..": "..value.." from "..factor.."!");
	cm:faction_add_pooled_resource(faction_key, self.pooled_resource, factor, value);
	Check_Chivalry_Win_Condition(cm:get_faction(faction_key))
end


-- DECLARING WAR
function chivalry:NegativeDiplomaticEvent(context)
	if context:proposer():subculture() == "wh_main_sc_brt_bretonnia" and context:recipient():subculture() == "wh_main_sc_brt_bretonnia" then
		if context:is_war() == true and context:proposer():is_human() == true then
			out("BRETONNIAN WAR ("..context:proposer():name().." vs "..context:recipient():name()..") = "..(self.bretonnian_war_value));
			self:ModifyChivalry(context:proposer():name(), self.bretonnian_war_factor, self.bretonnian_war_value)
		end
	end
end

function chivalry:VariationMonitor(context)
	if context:faction():subculture() == "wh_main_sc_brt_bretonnia" then
		local fac_name = context:faction():name();
		local previous_chivalry = cm:get_saved_value("ScriptPreviousChivalryValue_"..fac_name);
		local current_chivalry = context:faction():pooled_resource_manager():resource(self.pooled_resource):value()
		
		if previous_chivalry ~= nil then
			if current_chivalry > previous_chivalry then
				core:trigger_event("ScriptEventChivalryValueUp");
			elseif current_chivalry < previous_chivalry then
				core:trigger_event("ScriptEventChivalryValueDown");
			end
		else 
			previous_chivalry = 0;
		end
		-- ignore the last threshold as it's the max value (used elsewhere)
		for i = 1, #self.thresholds - 1 do
			if previous_chivalry < self.thresholds[i] and current_chivalry >= self.thresholds[i] then
				core:trigger_event("ScriptEventChivalryLevelUp");
			elseif previous_chivalry > self.thresholds[i] and current_chivalry <= self.thresholds[i] then
				core:trigger_event("ScriptEventChivalryLevelDown");
			end
		end
		cm:set_saved_value("ScriptPreviousChivalryValue_"..fac_name, context:faction():pooled_resource_manager():resource(self.pooled_resource):value());
	end
end

function chivalry:GetTechBonusForFaction(faction_key, fighting_subculture)
	local faction = cm:model():world():faction_by_key(faction_key);
	local bonus_val = 0;
	
	if faction:is_null_interface() == false and self.subcultures_to_bonus_values[fighting_subculture] then
	 	bonus_val = bonus_val + cm:get_factions_bonus_value(faction, self.subcultures_to_bonus_values[fighting_subculture])	
	end

	return bonus_val;
end