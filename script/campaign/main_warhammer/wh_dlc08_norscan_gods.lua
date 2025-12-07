--[[
###	STILL TO DO ###
	- rework victory conditions
	- add cutscenes for the invasions?
	- add special reward bundle if rejecting all champions
]]--

norscan_gods = {
	allegiance_factions = {
		["wh_dlc08_nor_norsca"] 		= {crow_dilemma_spawned = false, eagle_dilemma_spawned = false, hound_dilemma_spawned = false, serpent_dilemma_spawned = false, champion_spawned = false},
		["wh_dlc08_nor_wintertooth"] 	= {crow_dilemma_spawned = false, eagle_dilemma_spawned = false, hound_dilemma_spawned = false, serpent_dilemma_spawned = false, champion_spawned = false},

	},
	allegiance_gods_pooled_resources = {
		crow 	= "nor_progress_crow",
		eagle 	= "nor_progress_eagle",
		hound 	= "nor_progress_hound",
		serpent = "nor_progress_serpent",
	},
	allegiance_factor = "buildings",
	--THESE NEED TO MATCH THE DATA THRESHOLDS
	allegiance_thresholds = {5, 10, 15},	
	allegiance_advice_prefix = "dlc08.camp.advice.nor.",
	allegiance_advice_tracker = {
		["wh_dlc08_nor_norsca"] = {
			["general"] 	= {first_altar_advice 	= false, champion_advice  = false},
			["khorne"] 		= {advice_one_heard 	= false, advice_two_heard = false, advice_three_heard = false},
			["nurgle"] 		= {advice_one_heard 	= false, advice_two_heard = false, advice_three_heard = false},
			["slaanesh"] 	= {advice_one_heard 	= false, advice_two_heard = false, advice_three_heard = false},
			["tzeentch"] 	= {advice_one_heard 	= false, advice_two_heard = false, advice_three_heard = false},
		},
		["wh_dlc08_nor_wintertooth"] = {
			["general"] 	= {first_altar_advice 	= false, champion_advice  = false},
			["khorne"] 		= {advice_one_heard 	= false, advice_two_heard = false, advice_three_heard = false},
			["nurgle"] 		= {advice_one_heard 	= false, advice_two_heard = false, advice_three_heard = false},
			["slaanesh"] 	= {advice_one_heard 	= false, advice_two_heard = false, advice_three_heard = false},
			["tzeentch"] 	= {advice_one_heard 	= false, advice_two_heard = false, advice_three_heard = false},
		},
	},


	dilemma_key_prefix = "wh3_dlc27_nor_champion_",
	dilemma_champion_agent_type = {
		agent = "agent",
		general = "general"
	},
	dilemma_champion_reward = {
		crow = {
			character = {
				type = "general",
				ids = {
					wh_dlc08_nor_norsca = "1666706152",
					wh_dlc08_nor_wintertooth = "1373379564",
				},
				subtype = "wh3_main_ie_nor_burplesmirk_spewpit",
				spawn_rank = 25
			}
		},
		eagle = {
			character = {
				type = "general",
				ids = {
					wh_dlc08_nor_norsca = "1641404268",
					wh_dlc08_nor_wintertooth = "136640584",
				},
				subtype = "wh_dlc08_nor_arzik",
				spawn_rank = 25
			}
		},
		hound = {
			character = {
				type = "agent",
				subtype = "wh3_main_ie_nor_killgore_slaymaim",
				spawn_rank = 25
			}
		},
		serpent = {
			character = {
				type = "agent",
				subtype = "wh_dlc08_nor_kihar",
				spawn_rank = 25,
			}
		},
		
	},

	challenger_faction_prefix = "wh_dlc08_chs_chaos_challenger_",
	challenger_faction_keys = {
		"wh_dlc08_chs_chaos_challenger_khorne",
		"wh_dlc08_chs_chaos_challenger_nurgle",
		"wh_dlc08_chs_chaos_challenger_slaanesh",
		"wh_dlc08_chs_chaos_challenger_tzeentch"
	},
	challenger_details = {
		["khorne"] = {agent_subtype = "wh_dlc08_chs_challenger_khorne", forename = "names_name_635561999", clan_name = "", family_name = "", other_name = "", effect_bundle = "wh_main_bundle_military_upkeep_free_force_special_character_unbreakable"},
		["nurgle"] = {agent_subtype = "wh_dlc08_chs_challenger_nurgle", forename = "names_name_327875186", clan_name = "", family_name = "", other_name = "", effect_bundle = "wh_main_bundle_military_upkeep_free_force_special_character_unbreakable"},
		["slaanesh"] = {agent_subtype = "wh_dlc08_chs_challenger_slaanesh", forename = "names_name_1572470675", clan_name = "", family_name = "", other_name = "", effect_bundle = "wh_main_bundle_military_upkeep_free_force_special_character_unbreakable"},
		["tzeentch"] = {agent_subtype = "wh_dlc08_nor_arzik", forename = "names_name_1019189048", clan_name = "", family_name = "", other_name = "", effect_bundle = "wh_main_bundle_military_upkeep_free_force_special_character_unbreakable"}
	},
	challenger_units = {
		["khorne"] 		= 	{chosen_shield = "wh3_dlc20_chs_inf_chosen_mkho", chosen_special = "wh3_dlc20_chs_inf_chosen_mkho_dualweapons", 	knight = "wh3_dlc20_chs_cav_chaos_knights_mkho", 	spawn = "wh3_main_kho_mon_spawn_of_khorne_0", 			daemon = "wh3_main_kho_inf_bloodletters_0"},
		["nurgle"] 		= 	{chosen_shield = "wh3_dlc20_chs_inf_chosen_mnur", chosen_special = "wh3_dlc20_chs_inf_chosen_mnur_greatweapons", 	knight = "wh3_dlc20_chs_cav_chaos_knights_mnur", 	spawn = "wh3_main_nur_mon_spawn_of_nurgle_0_warriors", 	daemon = "wh3_main_nur_inf_plaguebearers_0"},
		["slaanesh"] 	= 	{chosen_shield = "wh3_dlc20_chs_inf_chosen_msla", chosen_special = "wh3_dlc20_chs_inf_chosen_msla_hellscourges", 	knight = "wh3_dlc20_chs_cav_chaos_knights_msla", 	spawn = "wh3_main_sla_mon_spawn_of_slaanesh_0", 		daemon = "wh3_main_sla_inf_daemonette_0"},
		["tzeentch"] 	= 	{chosen_shield = "wh3_dlc20_chs_inf_chosen_mtze", chosen_special = "wh3_dlc20_chs_inf_chosen_mtze_halberds", 		knight = "wh3_main_tze_cav_chaos_knights_0", 		spawn = "wh3_main_tze_mon_spawn_of_tzeentch_0", 		daemon = "wh3_main_tze_inf_blue_horrors_0"},
	},
	challenger_spawn_distance_min_key = "nor_allegiance_challenger_spawn_distance_min",
	challenger_spawn_distance_max_key = "nor_allegiance_challenger_spawn_distance_max",

	god_conversion_table = {
		crow 	= "nurgle",
		eagle 	= "tzeentch",
		hound 	= "khorne",
		serpent = "slaanesh",
	},
	rivalry_conversion_table = {
		nurgle 		= "tzeentch",
		tzeentch 	= "nurgle",
		khorne 		= "slaanesh",
		slaanesh 	= "khorne",
	},

	allegiance_ultimate_refusal_mission = "wh3_dlc27_nor_allegiance_ultimate_refusal",
	allegiance_challenger_destroy_mission = "wh3_dlc27_nor_allegiance_challenger_destroy",
	allegiance_increase_dedication_to_norscan_god_mission = "wh3_dlc27_nor_allegiance_increase_dedication_to_god",
	allegiance_increase_dedication_to_norscan_god_mission_turn = 2,
	allegiance_increase_dedication_to_norscan_god_mission_pool_res_requirement = 2,
}






function norscan_gods:initialise()


	if cm:is_new_game() then
		self:setup_champion_locks()
	end


	core:add_listener(
		"AllegianceTracker_CharacterPerformsSettlementOccupationDecision",
		"CharacterPerformsSettlementOccupationDecision",
		true,
		function(context)
			local character_faction_name = context:character():faction():name()
			local previous_owner_name = context:previous_owner()

			if self.allegiance_factions[previous_owner_name] then
				self:update_allegiance_pooled_resources(previous_owner_name)
				self:process_allegiance(previous_owner_name)
			end

			if self.allegiance_factions[character_faction_name] then
				self:update_allegiance_pooled_resources(character_faction_name)
				self:process_allegiance(character_faction_name)	
			end
				
		end,
		true
	)

	core:add_listener(
		"AllegianceTracker_FactionAboutToStartTurn",
		"FactionAboutToStartTurn",
		function(context)
			return self.allegiance_factions[context:faction():name()] ~= nil
		end,
		function(context)
			self:update_allegiance_pooled_resources(context:faction():name())
		end,
		true
	)

	core:add_listener(
		"AllegianceTracker_FactionTurnStart",
		"FactionTurnStart",
		function(context)
			return self.allegiance_factions[context:faction():name()] ~= nil
		end,
		function(context)
			self:process_allegiance(context:faction():name())
		end,
		true
	)

	core:add_listener(
		"AllegianceChampion_DilemmaChoiceMadeEvent",
		"DilemmaChoiceMadeEvent",
		function(context)
			return string.find(context:dilemma(), self.dilemma_key_prefix)
		end,
		function(context)
			self:champion_dilemma_handler(context:faction():name(), context:dilemma(), context:choice())	
		end,
		true
	)

	core:add_listener(
		"AllegianceChampionMaxTierReachedCheat_ContextTriggerEvent",
		"ContextTriggerEvent",
		true,
		function(context)
			if not context.string:starts_with("norsca_god_favour_max_tier_reached_cheat") then
				return
			end

			local faction_key = cm:get_local_faction_name(true)
			self:update_allegiance_pooled_resources(faction_key, true)
			self:process_allegiance(faction_key)
		end,
		true
	)

end


function norscan_gods:update_allegiance_pooled_resources(faction_name, cheat_forced)
	local faction = cm:get_faction(faction_name)
	if faction == nil or faction:is_null_interface() then
		return
	end

	for _, res_key in dpairs(self.allegiance_gods_pooled_resources) do
		self:update_allegiance_pooled_resource(faction, res_key, cheat_forced)
	end
end

function norscan_gods:process_allegiance(faction_name)
	local faction = cm:get_faction(faction_name)
	if faction == nil or faction:is_null_interface() then
		return
	end

	for god, res_key in dpairs(self.allegiance_gods_pooled_resources) do
		local god_favour = self:get_pooled_resource_value(faction, res_key)

		self:trigger_allegiance_advice_dilemma(faction_name, god, god_favour)
	end
end

function norscan_gods:update_allegiance_pooled_resource(faction, resource_key, cheat_forced)
	local bonus_value = resource_key .. "_count"

	-- for cheats we query the pooled resource of the corresponding god
	local god_favour = cheat_forced and self:get_pooled_resource_value(faction, resource_key) or cm:get_factions_bonus_value(faction, bonus_value)
	if not cheat_forced then
		local faction_key = faction:name()
		cm:faction_add_pooled_resource(faction_key, resource_key, self.allegiance_factor, -99999)
		cm:faction_add_pooled_resource(faction_key, resource_key, self.allegiance_factor, god_favour)
	end

	return self:get_pooled_resource_value(faction, resource_key)
end

function norscan_gods:get_pooled_resource_value(faction, resource_key)
	if faction == nil or faction:is_null_interface() then
		return 0
	end

	return faction:pooled_resource_manager():resource(resource_key):value()
end

function norscan_gods:trigger_allegiance_advice_dilemma(faction_name, god, god_favour)
	local advice_faction = self.allegiance_advice_tracker[faction_name]
	local dilemma_faction = self.allegiance_factions[faction_name]
	local chaos_god = self.god_conversion_table[god]

	--check if god_favour reaches the upper allegiance limit and that no champion has already been selected
	if god_favour >= self.allegiance_thresholds[3] and dilemma_faction.champion_spawned == false then
		self:spawn_top_tier_allegiance_dilemma(faction_name, god, chaos_god)
	elseif god_favour >= self.allegiance_thresholds[2] and advice_faction[chaos_god].advice_two_heard == false then
		--play advice for threshold two for correct god
		self:advice_handler(faction_name, 2, chaos_god)

	elseif god_favour >= self.allegiance_thresholds[1] and advice_faction[chaos_god].advice_one_heard == false then
		--play advice for threshold one for correct god
		self:advice_handler(faction_name, 1, chaos_god)
	elseif god_favour >= 1 and advice_faction["general"].first_altar_advice == false then
		local advice_key = self.allegiance_advice_prefix .. "gods.002"
		--call function in wh_dlc08_norsca.lua
		Play_Norsca_Advice(advice_key, norsca_info_text_gods, true)
		advice_faction["general"].first_altar_advice = true
	end
end

function norscan_gods:spawn_top_tier_allegiance_dilemma(faction_name, god, chaos_god)
	local dilemma_faction = self.allegiance_factions[faction_name]

	-- check if current god dilemma has already been spawned
	local dilemma_spawned_key = god .. "_dilemma_spawned"
	if dilemma_faction[dilemma_spawned_key] then
		return
	end

	-- dont need to check if advice heard before as the dilemma check ensures this only runs once
	-- play advice for threshold three for correct god
	self:advice_handler(faction_name, 3, chaos_god)

	local dilemma_key = self.dilemma_key_prefix .. god
	cm:trigger_dilemma(faction_name, dilemma_key)

	-- mark dilemma as spawned
	if string.find(dilemma_key, god) then
		dilemma_faction[dilemma_spawned_key] = true
	end
end

function norscan_gods:champion_dilemma_handler(faction_name, dilemma_key, choice)

	local dilemma_god = nil
	local dilemma_faction = self.allegiance_factions[faction_name] 

	for god, _ in dpairs(self.dilemma_champion_reward) do
		if string.find(dilemma_key, god) then
			dilemma_god = god
		end
	end

	--spawn champion, set champion spawned to true and trigger invasion
	if choice == 0 then
		if dilemma_god ~= nil then
			self:spawn_champion(faction_name, dilemma_god)
			dilemma_faction.champion_spawned = true
			
			--trigger invasion of rival god's followers
			local chaos_god = self.god_conversion_table[dilemma_god]
			local rival_god = self.rivalry_conversion_table[chaos_god]

			self:spawn_champion_invasion(faction_name, rival_god)
			self:destroy_single_challenger_mission(faction_name, rival_god)
		end
	else

		--check if all dilemmas have been rejected
		local champion_rejected_count = 0	
		if dilemma_faction.crow_dilemma_spawned then
			champion_rejected_count = champion_rejected_count + 1
		end
		if dilemma_faction.eagle_dilemma_spawned then
			champion_rejected_count = champion_rejected_count + 1
		end
		if dilemma_faction.hound_dilemma_spawned then
			champion_rejected_count = champion_rejected_count + 1
		end
		if dilemma_faction.serpent_dilemma_spawned then
			champion_rejected_count = champion_rejected_count + 1
		end
		
		--if all 4 dilemma champions rejected then trigger all invasions
		if champion_rejected_count >= 4 then
			--trigger invasions from all chaos gods
			for chaos_god, _ in dpairs(self.rivalry_conversion_table) do
				self:spawn_champion_invasion(faction_name, chaos_god)
			end
			self:destroy_challenger_forces_mission(faction_name)
		end

	end

end

-- Lock recruitment, and do other startup operations to the generals that you can unlock with Devotion to the Gods.
function norscan_gods:setup_champion_locks()
	-- When locking the generals, do so in an alphabetically ordered way to avoid desynchs.
	local sorted_general_ids = {}
	for _, reward_table in dpairs(self.dilemma_champion_reward) do
		if reward_table.character ~= nil and reward_table.character.type == self.dilemma_champion_agent_type.general then
			for faction_key, general_id in dpairs(reward_table.character.ids) do
				table.insert(sorted_general_ids, { id = general_id, faction_key = faction_key, raw_table = reward_table.character })
			end
		end
	end
	table.sort(sorted_general_ids,
		function (general_table_a, general_table_b)
			return general_table_a.id > general_table_b.id
		end
	)

	-- Lock Recruitment
	for g = 1, #sorted_general_ids do
		cm:lock_starting_character_recruitment(sorted_general_ids[g].id, sorted_general_ids[g].faction_key)
	end
end

-- Spawn agent or unlock general
function norscan_gods:spawn_champion(faction_name, god_key)
	local reward_table = self.dilemma_champion_reward[god_key].character
	local faction_cqi = cm:get_faction(faction_name):command_queue_index()

	if reward_table.type == self.dilemma_champion_agent_type.general then
		if reward_table.ids[faction_name] == nil then
			script_error(string.format("ERROR: Could not give final reward (a general) for devotion to god '%s' to faction '%s' because this faction did not have character start pos ID of this general. All playable Norsca factions must have each unlockable general given to them in start_pos_characters, the ID of which must be specified in this script.",
				god_key, faction_name))
		else
			cm:unlock_starting_character_recruitment(reward_table.ids[faction_name], faction_name)
		end
	elseif reward_table.type == self.dilemma_champion_agent_type.agent then
		core:add_listener(
			"Norsca_UniqueAgentSpawned",
			"UniqueAgentSpawned",
			true,
			function(context)
				local character_interface = context:unique_agent_details():character()
				local char_lookup_str = cm:char_lookup_str(character_interface)
				local spawn_rank = reward_table.spawn_rank or 0
				
				if character_interface:rank() < spawn_rank then
					cm:add_agent_experience(char_lookup_str, spawn_rank, true)
				end
				
				if reward_table.ancillaries ~= nil then
					for a = 1, #reward_table.ancillaries do
						cm:force_add_ancillary(character_interface, reward_table.ancillaries[a], false, true)
					end
				end
				
				cm:replenish_action_points(char_lookup_str)
				CampaignUI.ClearSelection()
			end,
			false
		)
		
		cm:spawn_unique_agent(faction_cqi, reward_table.subtype, false)

		local advice_faction = self.allegiance_advice_tracker[faction_name]
		if advice_faction["general"].champion_advice == false then
			local advice_key = self.allegiance_advice_prefix .. "champions.001"
			--call function in wh_dlc08_norsca.lua
			Play_Norsca_Advice(advice_key, nil, true)
			advice_faction["general"].champion_advice = true
		end
	end
end

function norscan_gods:spawn_champion_invasion(target_faction_key, chaos_god)
	local invasion_key = "invasion_"..target_faction_key.."_"..chaos_god
	local unit_list = self:create_challenger_force(chaos_god)


	local target_faction = cm:model():world():faction_by_key(target_faction_key)
	local target_faction_leader = target_faction:faction_leader()
	local target_faction_capital_key = target_faction:home_region():name()

	local x,y
	local challenger_spawn_distance_min = cm:campaign_var_int_value(self.challenger_spawn_distance_min_key)
	local challenger_spawn_distance_max = cm:campaign_var_int_value(self.challenger_spawn_distance_max_key)
	local challenger_spawn_distance = cm:random_number(challenger_spawn_distance_max, challenger_spawn_distance_min)
	if target_faction_leader:is_null_interface() == false and target_faction_leader:has_military_force() == true and target_faction_leader:has_region() then
		x, y = cm:find_valid_spawn_location_for_character_from_character(target_faction_key, cm:char_lookup_str(target_faction_leader), false, challenger_spawn_distance)
	else
		x,y = cm:find_valid_spawn_location_for_character_from_settlement(target_faction_key, target_faction_capital_key, false, true, challenger_spawn_distance)
	end
	local coordinates = {x, y}	
	local challenger_invasion = invasion_manager:new_invasion(invasion_key, self.challenger_faction_prefix..chaos_god, unit_list, coordinates)

	if not cm:is_multiplayer() then
		if target_faction:is_null_interface() == false and target_faction:has_faction_leader() == true then
			if target_faction_leader:is_null_interface() == false and target_faction_leader:has_military_force() == true then
				local target_faction_leader_cqi = target_faction_leader:command_queue_index()
				challenger_invasion:set_target("CHARACTER", target_faction_leader_cqi, target_faction_key)
			else
				challenger_invasion:set_target("NONE", nil, target_faction_key)
			end
		end
		
		-- Add army XP based on difficulty in SP
		local difficulty = cm:model():difficulty_level()
		
		if difficulty == -1 then
			-- Hard
			challenger_invasion:add_unit_experience(1)
		elseif difficulty == -2 then
			-- Very Hard
			challenger_invasion:add_unit_experience(2)
		elseif difficulty == -3 then
			-- Legendary
			challenger_invasion:add_unit_experience(3)
		end
	end
	
	-- Set up the General
	local challenger_details = self.challenger_details
	challenger_invasion:create_general(false, challenger_details[chaos_god].agent_subtype, challenger_details[chaos_god].forename, challenger_details[chaos_god].clan_name, challenger_details[chaos_god].family_name, challenger_details[chaos_god].other_name)
	challenger_invasion:add_character_experience(30, true) -- Level 30
	challenger_invasion:apply_effect(challenger_details[chaos_god].effect_bundle, -1)
	challenger_invasion:start_invasion(true, true, false, false)

end

-- Setup challenger forces based on god connection
function norscan_gods:create_challenger_force(chaos_god)

	local ram = random_army_manager
	local ram_name = "challenger_"..chaos_god
	ram:remove_force(ram_name)
	ram:new_force(ram_name)
		
	--add 5 shared units regardless of which god is called
	ram:add_mandatory_unit(ram_name, "wh_main_chs_mon_giant", 2)	
	ram:add_mandatory_unit(ram_name, "wh_dlc01_chs_mon_dragon_ogre_shaggoth", 1)
	ram:add_mandatory_unit(ram_name, "wh_main_chs_art_hellcannon", 2)

	--add 14 aligned units based on which chaos god is selected
	local god_units = self.challenger_units

	ram:add_mandatory_unit(ram_name, god_units[chaos_god].chosen_shield, 3)
	ram:add_mandatory_unit(ram_name, god_units[chaos_god].chosen_special, 2)
	ram:add_mandatory_unit(ram_name, god_units[chaos_god].knight, 3)
	ram:add_mandatory_unit(ram_name, god_units[chaos_god].spawn, 3)
	ram:add_mandatory_unit(ram_name, god_units[chaos_god].daemon, 3)

	return ram:generate_force(ram_name, 19, false)
end

-- Play the correct advice based on Allegiance threshold and Chaos God
function norscan_gods:advice_handler(faction_name, threshold_level, chaos_god)

	local advice_faction = self.allegiance_advice_tracker[faction_name]
	local advice_key = self.allegiance_advice_prefix .. "gods_" .. chaos_god ..".00" .. threshold_level
	
	--set advice booleans to true
	if threshold_level == 3 then
		advice_faction[chaos_god].advice_three_heard = true
	elseif threshold_level == 2 then
		advice_faction[chaos_god].advice_two_heard = true
	elseif threshold_level == 1 then
		advice_faction[chaos_god].advice_one_heard = true
	end

	--call function in wh_dlc08_norsca.lua
	Play_Norsca_Advice(advice_key, nil, true)
end

function norscan_gods:destroy_challenger_forces_mission(faction_name)
	local mm = mission_manager:new(faction_name, self.allegiance_ultimate_refusal_mission)
				
	mm:add_new_objective("DESTROY_FACTION")

	mm:add_condition("faction wh_dlc08_chs_chaos_challenger_khorne")
	mm:add_condition("faction wh_dlc08_chs_chaos_challenger_nurgle")
	mm:add_condition("faction wh_dlc08_chs_chaos_challenger_slaanesh")
	mm:add_condition("faction wh_dlc08_chs_chaos_challenger_tzeentch")
	mm:add_condition("confederation_valid")

	mm:add_payload("effect_bundle{bundle_key wh3_dlc27_bundle_nor_allegiance_ultimate_refusal;turns 0;}");
	mm:add_payload("text_display dummy_wh3_dlc27_nor_allegiance_ultimate_refusal_mission");

	mm:set_mission_issuer("CLAN_ELDERS")

	mm:trigger()
end

function norscan_gods:destroy_single_challenger_mission(faction_name, rival_god)
	local mm = mission_manager:new(faction_name, self.allegiance_challenger_destroy_mission)
				
	mm:add_new_objective("DESTROY_FACTION")

	mm:add_condition("faction wh_dlc08_chs_chaos_challenger_" .. rival_god)
	mm:add_condition("confederation_valid")

	mm:add_payload("effect_bundle{bundle_key wh3_dlc27_bundle_nor_allegiance_victory_against_rival;turns 0;}");

	mm:set_mission_issuer("CLAN_ELDERS")

	mm:trigger()
end

function norscan_gods:mission_increase_dedication_to_norscan_god(faction_name)
	local mm = mission_manager:new(faction_name, self.allegiance_increase_dedication_to_norscan_god_mission)				
	mm:set_mission_issuer("CLAN_ELDERS");
	mm:add_new_objective("SCRIPTED");
	mm:add_condition("script_key " .. "wh3_dlc27_nor_allegiance_increase_dedication_to_god")
	mm:add_condition("override_text mission_text_text_wh3_dlc27_nor_allegiance_increase_dedication_to_god");
	mm:add_payload("money 1000");
	mm:trigger();
end

core:add_listener(
	"Norsca_God_Dedication_Mission_Start",
	"FactionTurnStart",
	function(context)
		return norscan_gods.allegiance_factions[context:faction():name()] ~= nil
	end,
	function(context)
		local faction = context:faction()
		local faction_is_human = faction:is_human()
		if faction_is_human and cm:model():turn_number() == norscan_gods.allegiance_increase_dedication_to_norscan_god_mission_turn then 
			norscan_gods:mission_increase_dedication_to_norscan_god(context:faction():name())
		end
	end,
	true
)

core:add_listener(
	"Norsca_God_Dedication_Mission_Completion",
	"PooledResourceChanged",
	function(context)
    local faction = context:faction();
		return string.find(context:resource():key(), "nor_progress_") and context:resource():value() >= norscan_gods.allegiance_increase_dedication_to_norscan_god_mission_pool_res_requirement and faction:is_human()
    end,
	function(context)
		local faction = context:faction()
		if faction:active_missions(norscan_gods.allegiance_increase_dedication_to_norscan_god_mission) then
			cm:complete_scripted_mission_objective(faction:name(), norscan_gods.allegiance_increase_dedication_to_norscan_god_mission, norscan_gods.allegiance_increase_dedication_to_norscan_god_mission, true)	
		end
	end,
	true
);

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("AllegianceFactions", norscan_gods.allegiance_factions, context)
		cm:save_named_value("AllegianceAdvice", norscan_gods.allegiance_advice_tracker, context)
	end
)
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			norscan_gods.allegiance_factions = cm:load_named_value("AllegianceFactions", norscan_gods.allegiance_factions, context)
			norscan_gods.allegiance_advice_tracker = cm:load_named_value("AllegianceAdvice", norscan_gods.allegiance_advice_tracker, context)
		end
	end
)


--[[

function Check_God_Favour_Win_Conditions(faction_key, god_key)
	if NORSCAN_GODS[faction_key] ~= nil and cm:get_faction(faction_key) then
		local current_favour = cm:get_faction(faction_key):pooled_resource_manager():resource(GOD_KEY_TO_POOLED_RESOURCE[god_key]):value()		
		
		if current_favour >= CHAPTER_3_FAVOUR_REQUIREMENT and not cm:get_saved_value("norscan_favour_lvl_3_reached_" .. faction_key) then
			cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "attain_chaos_god_favour", true)
			Give_Final_God_Reward(faction_key, god_key)
			Trigger_God_Challengers(faction_key, god_key)
			cm:set_saved_value("norscan_favour_lvl_3_reached_" .. faction_key, true)
		elseif current_favour >= CHAPTER_2_FAVOUR_REQUIREMENT then
			Play_Norsca_Advice("dlc08.camp.advice.nor.gods_"..god_key..".002", norsca_info_text_gods)
			cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "attain_chaos_god_favour_lvl_2", true)
		elseif current_favour >= CHAPTER_1_FAVOUR_REQUIREMENT then
			Play_Norsca_Advice("dlc08.camp.advice.nor.gods_"..god_key..".001", norsca_info_text_gods)
		end
		
		if current_favour>= (CHAPTER_3_FAVOUR_REQUIREMENT - NORSCAN_FAVOUR_GAIN) and current_favour < CHAPTER_3_FAVOUR_REQUIREMENT and NORSCA_ADVICE["dlc08.camp.advice.nor.gods_"..god_key..".002"] == true then
			Play_Norsca_Advice("dlc08.camp.advice.nor.gods.004", norsca_info_text_gods)
		end
	end	
end

function ChallengerCutscenePlay()
	local god_key = NorscaChallengersSpawned.god_key
	local challengers_spawned = NorscaChallengersSpawned.challengers_spawned
	
	local advice_to_play = {}
	advice_to_play[1] = "dlc08.camp.advice.nor.champions.001"
	advice_to_play[2] = "dlc08.camp.advice.nor.gods_"..god_key..".003"
	
	local cam_skip_x, cam_skip_y, cam_skip_d, cam_skip_b, cam_skip_h = cm:get_camera_position()
	NorscaChallengersSpawned.cam_skip_x = cam_skip_x
	NorscaChallengersSpawned.cam_skip_y = cam_skip_y
	NorscaChallengersSpawned.cam_skip_d = cam_skip_d
	NorscaChallengersSpawned.cam_skip_b = cam_skip_b
	NorscaChallengersSpawned.cam_skip_h = cam_skip_h
	cm:take_shroud_snapshot()
	
	local challenger_cutscene = campaign_cutscene:new(
		"challenger_cutscene",
		23,
		function()
			cm:modify_advice(true)
			ChallengerCutsceneEnd()
		end
	)

	challenger_cutscene:set_skippable(true, function() ChallengerCutsceneSkipped(advice_to_play) end)
	challenger_cutscene:set_skip_camera(cam_skip_x, cam_skip_y, cam_skip_d, cam_skip_b, cam_skip_h)
	challenger_cutscene:set_disable_settlement_labels(false)
	challenger_cutscene:set_dismiss_advice_on_end(true)
	
	challenger_cutscene:action(
		function()
			cm:fade_scene(0, 3)
			cm:clear_infotext()
		end,
		0
	)
	
	challenger_cutscene:action(
		function()
			cm:show_shroud(false)
			cm:show_advice(advice_to_play[1])
			
			local x_pos, y_pos = cm:log_to_dis(challengers_spawned[1][1], challengers_spawned[1][2])
			cm:set_camera_position(x_pos, y_pos, cam_skip_d, cam_skip_b, cam_skip_h)
			cm:fade_scene(1, 2)
		end,
		3
	)
	
	challenger_cutscene:action(
		function()
			challenger_cutscene:wait_for_advisor()
		end,
		11
	)
	
	challenger_cutscene:action(
		function()
			cm:fade_scene(0, 1)
		end,
		12
	)
	
	challenger_cutscene:action(
		function()
			cm:show_advice(advice_to_play[2])
			
			local x_pos, y_pos = cm:log_to_dis(challengers_spawned[2][1], challengers_spawned[2][2])
			cm:set_camera_position(x_pos, y_pos, cam_skip_d, cam_skip_b, cam_skip_h)
			cm:fade_scene(1, 1)
		end,
		13
	)
		
	challenger_cutscene:action(
		function()
			challenger_cutscene:wait_for_advisor()
		end,
		21
	)
		
	challenger_cutscene:action(
		function()
			cm:fade_scene(0, 1)
		end,
		22
	)
		
	challenger_cutscene:action(
		function()
			cm:set_camera_position(cam_skip_x, cam_skip_y, cam_skip_d, cam_skip_b, cam_skip_h)
			cm:fade_scene(1, 1)
		end,
		23
	)
	
	challenger_cutscene:start()
end

function ChallengerCutsceneSkipped(advice_to_play)
	cm:override_ui("disable_advice_audio", true)
	
	common.clear_advice_session_history()
	
	for i = 1, #advice_to_play do
		cm:show_advice(advice_to_play[i])
	end
	
	cm:callback(function() cm:override_ui("disable_advice_audio", false) end, 0.5)
	cm:restore_shroud_from_snapshot()
end

function ChallengerCutsceneEnd()
	local faction_key = NorscaChallengersSpawned.faction_key
	local missions_to_spawn = NorscaChallengersSpawned.missions_to_spawn
	local cam_skip_x = NorscaChallengersSpawned.cam_skip_x
	local cam_skip_y = NorscaChallengersSpawned.cam_skip_y
	local cam_skip_d = NorscaChallengersSpawned.cam_skip_d
	local cam_skip_b = NorscaChallengersSpawned.cam_skip_b
	local cam_skip_h = NorscaChallengersSpawned.cam_skip_h
	
	cm:set_camera_position(cam_skip_x, cam_skip_y, cam_skip_d, cam_skip_b, cam_skip_h)
	cm:restore_shroud_from_snapshot()
	cm:fade_scene(1, 1)
	
	for i = 1, #missions_to_spawn do
		cm:trigger_mission(faction_key, missions_to_spawn[i], true)
	end

	NorscaChallengersSpawned:complete()
end

function Remove_Norscan_Challengers()
	cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "")
	
	for god_key, pooled_resource in dpairs(GOD_KEY_TO_POOLED_RESOURCE) do
		local target_faction = cm:model():world():faction_by_key(NORSCAN_CHALLENGER_FACTION_PREFIX..god_key)
		
		if target_faction:is_null_interface() == false and target_faction:has_faction_leader() == true then
			local faction_leader_cqi = target_faction:faction_leader():command_queue_index()
			cm:kill_character(faction_leader_cqi, true)
		end
	end
	
	cm:callback(
		function()
			cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "")
		end,
		1
	)
end

]]