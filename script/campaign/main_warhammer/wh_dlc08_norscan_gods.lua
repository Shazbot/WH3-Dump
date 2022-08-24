NORSCA_REWARD_CHARACTER_TYPES = {
	agent = "agent",
	general = "general"
}

NORSCAN_REWARDS = {
	khorne = {
		character = {
			type = NORSCA_REWARD_CHARACTER_TYPES.agent,
			subtype = "wh3_main_ie_nor_killgore_slaymaim",
			spawn_rank = 25
		}
	},
	slaanesh = {
		character = {
			type = NORSCA_REWARD_CHARACTER_TYPES.agent,
			subtype = "wh_dlc08_nor_kihar",
			spawn_rank = 25,
			ancillaries = {
				"wh_dlc08_anc_mount_nor_kihar_chaos_dragon",
			}
		}
	},
	tzeentch = {
		character = {
			type = NORSCA_REWARD_CHARACTER_TYPES.general,
			ids = {
				wh_dlc08_nor_norsca = "1641404268",
				wh_dlc08_nor_wintertooth = "136640584",
			},
			subtype = "wh_dlc08_nor_arzik",
			spawn_rank = 25
		}
	},
	nurgle = {
		character = {
			type = NORSCA_REWARD_CHARACTER_TYPES.general,
			ids = {
				wh_dlc08_nor_norsca = "1666706152",
				wh_dlc08_nor_wintertooth = "1373379564",
			},
			subtype = "wh3_main_ie_nor_burplesmirk_spewpit",
			spawn_rank = 25
		}
	}
}

NORSCAN_GODS = {
	--[[
	["wh_dlc08_nor_norsca"] = {
		["khorne"] = {favour = 0, aligned = false, spawned = false, defeated = false, final = false, challenger_cqi = -1, challenger_force_cqi = -1}
	}
	]]
}

NORSCAN_FAVOUR_GAIN = 6
CHAPTER_1_FAVOUR_REQUIREMENT = 30
CHAPTER_2_FAVOUR_REQUIREMENT = 60
CHAPTER_3_FAVOUR_REQUIREMENT = 100
NORSCAN_CHALLENGER_FACTION_PREFIX = "wh_dlc08_chs_chaos_challenger_"
NORSCA_AVAILABLE_SPAWN_LOCATIONS = {}	-- Runtime tracker of available spawn locations, as spawn locations are made unavailable once something has spawned on them.

NORSCA_SPAWN_LOCATIONS = {	-- Startup config of spawn locations. On a new game, this is copied into the runtime NORSCA_AVAILABLE_SPAWN_LOCATIONS.
	{398, 824},
	{472, 869},
	{646, 870},
	{771, 801},
}

GOD_KEY_TO_POOLED_RESOURCE = {
	khorne = "nor_progress_hound",
	slaanesh = "nor_progress_serpent",
	tzeentch = "nor_progress_eagle",
	nurgle = "nor_progress_crow",
}

GOD_KEY_TO_CHALLENGER_DETAILS = {
	["khorne"] = {agent_subtype = "wh_dlc08_chs_challenger_khorne", forename = "names_name_635561999", clan_name = "", family_name = "", other_name = "", effect_bundle = "wh_main_bundle_military_upkeep_free_force_special_character_unbreakable"},
	["slaanesh"] = {agent_subtype = "wh_dlc08_chs_challenger_slaanesh", forename = "names_name_1572470675", clan_name = "", family_name = "", other_name = "", effect_bundle = "wh_main_bundle_military_upkeep_free_force_special_character_unbreakable"},
	["nurgle"] = {agent_subtype = "wh_dlc08_chs_challenger_nurgle", forename = "names_name_327875186", clan_name = "", family_name = "", other_name = "", effect_bundle = "wh_main_bundle_military_upkeep_free_force_special_character_unbreakable"},
	["tzeentch"] = {agent_subtype = "wh_dlc08_nor_arzik", forename = "names_name_1019189048", clan_name = "", family_name = "", other_name = "", effect_bundle = "wh_main_bundle_military_upkeep_free_force_special_character_unbreakable"}
}

CHAOS_CHALLENGER_FACTION_KEY_LOOKUP = {
	"wh_dlc08_chs_chaos_challenger_khorne",
	"wh_dlc08_chs_chaos_challenger_nurgle",
	"wh_dlc08_chs_chaos_challenger_slaanesh",
	"wh_dlc08_chs_chaos_challenger_tzeentch"
}

function Add_Norscan_Gods_Listeners()
	out("#### Adding Norscan Gods Listeners ####")
	
	for i = 1, #CHAOS_CHALLENGER_FACTION_KEY_LOOKUP do
		cm:add_faction_turn_start_listener_by_name(
			"Norsca_ChallengerTurnStart",
			CHAOS_CHALLENGER_FACTION_KEY_LOOKUP[i],
			function(context)
				cm:force_diplomacy("faction:" .. context:faction():name(), "all", "all", false, false, true)
			end,
			true
		)
	end

	local human_factions = cm:get_human_factions()
	
	for i = 1, #human_factions do
		local faction_key = human_factions[i]
		local faction = cm:get_faction(faction_key)
		
		if faction:subculture() == "wh_dlc08_sc_nor_norsca" then
			out("\t\t" .. faction_key .. ":")

			if NORSCAN_GODS[faction_key] == nil then
				NORSCAN_GODS[faction_key] = {}
			end
				
			for god_key, pooled_resource in pairs(GOD_KEY_TO_POOLED_RESOURCE) do
				if NORSCAN_GODS[faction_key][god_key] == nil then
					NORSCAN_GODS[faction_key][god_key] = {
						aligned = false,
						spawned = false,
						defeated = false,
						final = false,
						challenger_cqi = -1,
						challenger_force_cqi = -1,
						mission_record = "",
					}
				end
			end
			
			cm:add_pooled_resource_changed_listener_by_faction(
				"NorscaPRChanged",
				faction_key,
				function(context)
					for god_key, pooled_resource in pairs(GOD_KEY_TO_POOLED_RESOURCE) do
						if context:resource():key() == pooled_resource then
							Check_God_Favour_Win_Conditions(faction_key, god_key)
						end
					end
				end,
				true
			)
		end
	end
	
	core:add_listener(
		"mission_succeeded_norsca_challenger_mission_check",
		"MissionSucceeded",
		true,
		function(context)
			ChallengerMissionCheck(context:faction():name(), context:mission():mission_record_key())
		end,
		true
	)
	
	core:add_listener(
		"mission_cancelled_norsca_challenger_mission_check",
		"MissionCancelled",
		true,
		function(context)
			-- Player can kill coop partners challengers, aborting the mission
			ChallengerMissionCheck(context:faction():name(), context:mission():mission_record_key())
		end,
		true
	)
	
	-- Uses random army manager
	Setup_Challenger_Armies()
	
	-- Remove the challenger armies
	if cm:is_new_game() then
		-- Challenger spawn locations
		NORSCA_AVAILABLE_SPAWN_LOCATIONS = table.copy(NORSCA_SPAWN_LOCATIONS)
	
		Remove_Norscan_Challengers()
		Norsca_SetupRewardGenerals()
		
		-- Norsca Monster Hunt Rewards
		---only lock the frost wyrm for Throgg and the Mammoth for Wulfrik if there's a human Norsca faction, otherwise let the AI recruit them freely.
		if cm:are_any_factions_human(nil, "wh_dlc08_nor_norsca") then
			cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1", "wh_dlc08_nor_norsca", "norsca_monster_hunt_ror_unlock")
			cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", "wh_dlc08_nor_wintertooth", "norsca_monster_hunt_ror_unlock")
		end

		cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1", "wh_dlc08_nor_wintertooth", "norsca_monster_hunt_ror_unlock")
		cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", "wh_dlc08_nor_norsca", "norsca_monster_hunt_ror_unlock")

		NorscaChallengersSpawned:start()
	end
end

-- Lock recruitment, and do other startup operations to the generals that you can unlock with Devotion to the Gods.
function Norsca_SetupRewardGenerals()
	-- When locking the generals, do so in an alphabetically ordered way to avoid desynchs.
	local sorted_general_ids = {}
	for _, reward_table in pairs(NORSCAN_REWARDS) do
		if reward_table.character ~= nil and reward_table.character.type == NORSCA_REWARD_CHARACTER_TYPES.general then
			for faction_key, general_id in pairs(reward_table.character.ids) do
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

function Trigger_God_Challengers(faction_key, god_key)
	if Has_Aligned_With_God(faction_key) then
		return false
	end

	local lowest_god = god_key
	local lowest_value = 999999

	for key, data in pairs(NORSCAN_GODS[faction_key]) do
		if key == god_key then
			-- This is your chosen god!
			data.aligned = true
		else
			-- This is an enemy god!
			data.aligned = false
			
			local favour = cm:get_faction(faction_key):pooled_resource_manager():resource(GOD_KEY_TO_POOLED_RESOURCE[key]):value()	
			
			if favour <= lowest_value then
				lowest_god = key
				lowest_value = favour
			end
		end
	end
	
	-- The God with the worst relation becomes the final quest battle
	NORSCAN_GODS[faction_key][lowest_god].final = true
		
	local wars_to_do = {}
	local challengers_spawned = {}
	local missions_to_spawn = {}
	local is_mp = cm:is_multiplayer()

	if #NORSCA_AVAILABLE_SPAWN_LOCATIONS < 1 then
		out("There were no Norsca spawn locations?! Adding some...")
		NORSCA_AVAILABLE_SPAWN_LOCATIONS = table.copy(NORSCA_SPAWN_LOCATIONS)
	end
	
	for key, data in pairs(NORSCAN_GODS[faction_key]) do
		if data.aligned == false then
			if data.final == false then
				out("\n#######################################################\n Spawn_Challenger("..faction_key..", "..key..", "..tostring(is_mp)..")\n#######################################################\n")
				local spawn_pos, mission_key = Spawn_Challenger(faction_key, key, is_mp)
				table.insert(wars_to_do, key)
				table.insert(challengers_spawned, spawn_pos)
				table.insert(missions_to_spawn, mission_key)
				data.spawned = true
			end
		end
	end
	
	out("MP Challenger missions to spawn: "..#missions_to_spawn)
	
	if is_mp then
		cm:force_declare_war(NORSCAN_CHALLENGER_FACTION_PREFIX..wars_to_do[1], faction_key, false, false)
		
		core:add_listener(
			"Norsca_FactionLeaderDeclaresWar",
			"FactionLeaderDeclaresWar",
			function(context) return context:character():faction():name() == NORSCAN_CHALLENGER_FACTION_PREFIX..wars_to_do[1] end,
			function(context)
				cm:force_declare_war(NORSCAN_CHALLENGER_FACTION_PREFIX..wars_to_do[2], faction_key, false, false)
			end,
			false
		)
	end
	
	if #challengers_spawned > 0 then
		if cm:is_multiplayer() == false then
			out("++++ TRIGGER: ScriptEventNorscaChallengersSpawned")
			
			if not NorscaChallengersSpawned.is_started then
				NorscaChallengersSpawned:start()
			end
			
			NorscaChallengersSpawned.faction_key = faction_key
			NorscaChallengersSpawned.god_key = god_key
			NorscaChallengersSpawned.challengers_spawned = challengers_spawned
			NorscaChallengersSpawned.missions_to_spawn = missions_to_spawn
			core:trigger_event("ScriptEventNorscaChallengersSpawned")
		else
			cm:callback(
				function()
					for i = 1, #missions_to_spawn do
						out("Triggering MP Challenger mission: "..missions_to_spawn[i])
						cm:trigger_mission(faction_key, missions_to_spawn[i], true)
					end
				end,
				1
			)
		end
	end
end

NorscaChallengersSpawned = intervention:new("NorscaChallengersSpawned", 0, function() ChallengerCutscenePlay() end, BOOL_INTERVENTIONS_DEBUG)
NorscaChallengersSpawned:add_trigger_condition("ScriptEventNorscaChallengersSpawned", true)
NorscaChallengersSpawned:set_should_lock_ui(true)

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

function Spawn_Challenger(faction_key, god_key, is_mp)
	local invasion_key = "invasion_"..faction_key.."_"..god_key
	local random_spawn_num = cm:random_number(#NORSCA_AVAILABLE_SPAWN_LOCATIONS)
	local random_spawn = NORSCA_AVAILABLE_SPAWN_LOCATIONS[random_spawn_num]
	local mission_spawn = nil
	table.remove(NORSCA_AVAILABLE_SPAWN_LOCATIONS, random_spawn_num)
	
	local ram = random_army_manager
	local unit_list = ram:generate_force("challenger_"..god_key, 19)
	
	local target_faction = cm:model():world():faction_by_key(faction_key)
	local challenger_invasion = invasion_manager:new_invasion(invasion_key, NORSCAN_CHALLENGER_FACTION_PREFIX..god_key, unit_list, random_spawn)
	
	if not is_mp then
		if target_faction:is_null_interface() == false and target_faction:has_faction_leader() == true then
			local faction_leader = target_faction:faction_leader()
			if faction_leader:is_null_interface() == false and faction_leader:has_military_force() == true then
				local faction_leader_cqi = faction_leader:command_queue_index()
				challenger_invasion:set_target("CHARACTER", faction_leader_cqi, faction_key)
			else
				challenger_invasion:set_target("NONE", nil, faction_key)
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
	challenger_invasion:create_general(false, GOD_KEY_TO_CHALLENGER_DETAILS[god_key].agent_subtype, GOD_KEY_TO_CHALLENGER_DETAILS[god_key].forename, GOD_KEY_TO_CHALLENGER_DETAILS[god_key].clan_name, GOD_KEY_TO_CHALLENGER_DETAILS[god_key].family_name, GOD_KEY_TO_CHALLENGER_DETAILS[god_key].other_name)
	
	challenger_invasion:add_character_experience(30, true) -- Level 30
	
	challenger_invasion:apply_effect(GOD_KEY_TO_CHALLENGER_DETAILS[god_key].effect_bundle, -1)
	
	challenger_invasion:start_invasion(
		function(self)
			local force = self:get_force()
			local force_cqi = force:command_queue_index()
			local force_leader_cqi = force:general_character():command_queue_index()
		
			NORSCAN_GODS[faction_key][god_key].challenger_cqi = force_cqi
			NORSCAN_GODS[faction_key][god_key].challenger_force_cqi = force_leader_cqi
			NORSCAN_GODS[faction_key][god_key].mission_record = "wh_dlc08_kill_challenger_"..god_key
			
			out("Preventing "..NORSCAN_CHALLENGER_FACTION_PREFIX..god_key.." diplomacy [all] with [all]")
			cm:force_diplomacy("faction:"..NORSCAN_CHALLENGER_FACTION_PREFIX..god_key, "all", "all", false, false, true)
		end,
		not is_mp
	)
	return random_spawn, "wh_dlc08_kill_challenger_"..god_key
end

function Trigger_Final_Challenger(faction_key)
	if NORSCAN_GODS[faction_key] ~= nil then
		for key, data in pairs(NORSCAN_GODS[faction_key]) do
			if data.final == true then
				cm:trigger_mission(faction_key, "wh_dlc08_qb_chs_final_battle_"..key, true)
				Play_Norsca_Advice("dlc08.camp.advice.nor.champions.002")
				data.spawned = true
				break
			end
		end
	end
end

function ChallengerMissionCheck(faction_key, mission_key)
	----------------------------------------------------
	---- ALLEGIANCE TO THE GODS - VICTORY CONDITION ----
	----------------------------------------------------
	if mission_key == "wh_dlc08_qb_chs_final_battle_khorne" or mission_key == "wh_dlc08_qb_chs_final_battle_nurgle" or mission_key == "wh_dlc08_qb_chs_final_battle_slaanesh" or mission_key == "wh_dlc08_qb_chs_final_battle_tzeentch" then
		if cm:is_multiplayer() == false then
			cm:complete_scripted_mission_objective(faction_key, "wh_main_short_victory", "defeat_chaos_gods_challengers", true)
			cm:complete_scripted_mission_objective(faction_key, "wh_main_long_victory", "defeat_chaos_gods_challengers", true)
		end
	--------------------------------------------------------
	---- DEFEATED CHAOS CHALLENGERS - VICTORY CONDITION ----
	--------------------------------------------------------
	elseif NORSCAN_GODS[faction_key] ~= nil then
		for god_key, data in pairs(NORSCAN_GODS[faction_key]) do
			if data.mission_record == mission_key then
				data.defeated = true
				local defeated_challengers = Has_Defeated_All_Challengers(faction_key)
				
				if defeated_challengers == true then
					Trigger_Final_Challenger(faction_key)
				end
				break
			end
		end
	end
end

function Give_Final_God_Reward(faction_key, god_key)
	local reward_table = NORSCAN_REWARDS[god_key].character
	local faction_cqi = cm:get_faction(faction_key):command_queue_index()

	if reward_table.type == NORSCA_REWARD_CHARACTER_TYPES.general then
		if reward_table.ids[faction_key] == nil then
			script_error(string.format("ERROR: Could not give final reward (a general) for devotion to god '%s' to faction '%s' because this faction did not have character start pos ID of this general. All playable Norsca factions must have each unlockable general given to them in start_pos_characters, the ID of which must be specified in this script.",
				god_key, faction_key))
		else
			cm:unlock_starting_character_recruitment(reward_table.ids[faction_key], faction_key)
		end
	elseif reward_table.type == NORSCA_REWARD_CHARACTER_TYPES.agent then
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
	end
end

function Has_Defeated_All_Challengers(faction_key)
	local at_least_one_spawned = false
	if NORSCAN_GODS[faction_key] ~= nil then
		for god_key, data in pairs(NORSCAN_GODS[faction_key]) do
			if data.spawned == true then
				if data.defeated == false then
					return false
				else
					at_least_one_spawned = true
				end
			end
		end
	end
	return at_least_one_spawned
end

function Has_Aligned_With_God(faction_key)
	if NORSCAN_GODS[faction_key] ~= nil then
		for god_key, data in pairs(NORSCAN_GODS[faction_key]) do
			if data.aligned == true then
				return true
			end
		end
	end
	return false
end

function Setup_Challenger_Armies()
	local ram = random_army_manager
	
	for god_key, pooled_resource in pairs(GOD_KEY_TO_POOLED_RESOURCE) do
		ram:new_force("challenger_"..god_key)
		
		ram:add_unit("challenger_"..god_key, "wh_main_chs_inf_chaos_warriors_0", 1)
		ram:add_mandatory_unit("challenger_"..god_key, "wh_main_chs_inf_chaos_warriors_0", 4)
		ram:add_mandatory_unit("challenger_"..god_key, "wh_main_chs_inf_chaos_warriors_1", 2)
		
		ram:add_mandatory_unit("challenger_"..god_key, "wh_main_chs_inf_chosen_0", 2)
		ram:add_mandatory_unit("challenger_"..god_key, "wh_main_chs_inf_chosen_1", 2)
		
		ram:add_mandatory_unit("challenger_"..god_key, "wh_main_chs_cav_chaos_knights_0", 2)
		ram:add_mandatory_unit("challenger_"..god_key, "wh_main_chs_art_hellcannon", 2)
		
		ram:add_mandatory_unit("challenger_"..god_key, "wh_main_chs_mon_chaos_spawn", 2)
		ram:add_mandatory_unit("challenger_"..god_key, "wh_main_chs_mon_trolls", 2)
		ram:add_mandatory_unit("challenger_"..god_key, "wh_main_chs_mon_giant", 1)
	end
end

function Remove_Norscan_Challengers()
	cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "")
	
	for god_key, pooled_resource in pairs(GOD_KEY_TO_POOLED_RESOURCE) do
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

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("NORSCAN_GODS", NORSCAN_GODS, context)
		cm:save_named_value("NORSCA_AVAILABLE_SPAWN_LOCATIONS", NORSCA_AVAILABLE_SPAWN_LOCATIONS, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		NORSCAN_GODS = cm:load_named_value("NORSCAN_GODS", {}, context)
		NORSCA_AVAILABLE_SPAWN_LOCATIONS = cm:load_named_value("NORSCA_AVAILABLE_SPAWN_LOCATIONS", {}, context)
	end
)