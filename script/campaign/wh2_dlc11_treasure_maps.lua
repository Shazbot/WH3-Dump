local active_treasure = 1
local level3_missions = 1
local map_chance = 15
local map_chance_increase_per_turn = 0

local initial_treasure_map_missions = {
	["wh2_dlc11_cst_vampire_coast"] =		"wh2_dlc11_cst_treasure_map_starting_treasure_luthor_me",
	["wh2_dlc11_cst_pirates_of_sartosa"] =	"wh2_dlc11_cst_treasure_map_starting_treasure_aranessa_me",
	["wh2_dlc11_cst_noctilus"] =			"wh2_dlc11_cst_treasure_map_starting_treasure_noctilus_me",
	["wh2_dlc11_cst_the_drowned"] =			"wh2_dlc11_cst_treasure_map_starting_treasure_cylostra_me"
}

local treasure_map_list = {
	["island"] =	{false, 8}, -- is mission active, amount of missions
	["volcano"] =	{false, 8},
	["animal"] =	{false, 8},
	["skull"] =		{false, 8},
	["structure"] =	{false, 8},
	["lake"] =		{false, 9},
	["symbols"] =	{false, 8},
	["river"] =		{false, 8},
	["unique"] =	{false, 8}
}

local pirate_factions = {
	"wh2_dlc11_cst_rogue_bleak_coast_buccaneers",
	"wh2_dlc11_cst_rogue_boyz_of_the_forbidden_coast",
	"wh2_dlc11_cst_rogue_freebooters_of_port_royale",
	"wh2_dlc11_cst_rogue_grey_point_scuttlers",
	"wh2_dlc11_cst_rogue_terrors_of_the_dark_straights",
	"wh2_dlc11_cst_rogue_the_churning_gulf_raiders",
	"wh2_dlc11_cst_rogue_tyrants_of_the_black_ocean",
	"wh2_dlc11_cst_shanty_dragon_spine_privateers",
	"wh2_dlc11_cst_shanty_middle_sea_brigands",
	"wh2_dlc11_cst_shanty_shark_straight_seadogs"
}

local treasure_map_payload_mapping = {
	reward_5 = {
		["wh2_dlc11_cst_treasure_map_structure_treasure_me_1_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_symbols_treasure_me_7_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_lake_treasure_me_9_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_river_treasure_me_5_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_river_treasure_me_6_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_volcano_treasure_me_4_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_volcano_treasure_me_1_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_volcano_treasure_me_2_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_volcano_treasure_me_3_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_skull_treasure_me_8_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_skull_treasure_me_6_level_2"] = true
	},
	reward_4 = {
		["wh2_dlc11_cst_treasure_map_animal_treasure_me_5_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_island_treasure_me_6_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_lake_treasure_me_8_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_volcano_treasure_me_6_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_volcano_treasure_me_5_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_skull_treasure_me_3_level_2"] = true
	},
	reward_3 = {
		["wh2_dlc11_cst_treasure_map_animal_treasure_me_6_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_structure_treasure_me_2_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_island_treasure_me_4_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_island_treasure_me_4_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_symbols_treasure_me_5_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_lake_treasure_me_4_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_lake_treasure_me_6_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_skull_treasure_me_1_level_2"] = true,
		["wh2_dlc11_cst_treasure_map_skull_treasure_me_7_level_2"] = true
	},
	reward_2 = {
		["wh2_dlc11_cst_treasure_map_animal_treasure_me_4_level_1"] = true,
		["wh2_dlc11_cst_treasure_map_animal_treasure_me_7_level_2" ] = true,
		["wh2_dlc11_cst_treasure_map_structure_treasure_me_5_level_2"] = true
	},
	reward_1 = {
		["wh2_dlc11_cst_treasure_map_animal_treasure_me_4_level_1"] = true,
		["wh2_dlc11_cst_treasure_map_structure_treasure_me_6_level_1"] = true,
		["wh2_dlc11_cst_treasure_map_structure_treasure_me_3_level_1"] = true,
		["wh2_dlc11_cst_treasure_map_structure_treasure_me_4_level_1"] = true,
		["wh2_dlc11_cst_treasure_map_lake_treasure_me_7_level_1"] = true,
		["wh2_dlc11_cst_treasure_map_river_treasure_me_8_level_1"] = true,
		["wh2_dlc11_cst_treasure_map_river_treasure_me_7_level_1"] = true,
		["wh2_dlc11_cst_treasure_map_volcano_treasure_me_7_level_1"] = true,
		["wh2_dlc11_cst_treasure_map_volcano_treasure_me_8_level_1"] = true,
		["wh2_dlc11_cst_treasure_map_skull_treasure_me_4_level_1"] = true,
		["wh2_dlc11_cst_treasure_map_skull_treasure_me_2_level_1"] = true,
		["wh2_dlc11_cst_treasure_map_skull_treasure_me_5_level_1"] = true
	}
}

local vampire_coast_culture = "wh2_dlc11_cst_vampire_coast"

function add_treasure_maps_listeners()
	-- start the treasure maps listeners if any of the vampire coast factions are controlled by a human
	if cm:are_any_factions_human(nil, vampire_coast_culture) then
		treasure_map_listeners()
	end
end

function treasure_map_listeners()
	out("#### Adding Treasure Maps Listeners ####")
	
	if cm:is_new_game() then
		local human_factions = cm:get_human_factions()
		
		cm:disable_event_feed_events(true, "", "wh_event_subcategory_faction_missions_objectives", "")
		
		for i = 1, #human_factions do
			if initial_treasure_map_missions[human_factions[i]] then
				cm:trigger_mission(human_factions[i], initial_treasure_map_missions[human_factions[i]], true)
			end
		end
		
		cm:callback(function() cm:disable_event_feed_events(false, "", "wh_event_subcategory_faction_missions_objectives", "") end, 0.2)
		
		-- initialise this value at the start of a new singleplayer campaign - it's used by advice
		if not cm:get_saved_value("num_treasure_missions_succeeded_sp") then
			cm:set_saved_value("num_treasure_missions_succeeded_sp", 0)
		end
	end
	
	core:add_listener(
		"EndOfRound_Treasure_Map",
		"EndOfRound",
		true,
		function()
			if active_treasure < 6 then
				map_chance_increase_per_turn = map_chance_increase_per_turn + 5
			end
		end,
		true
	)
	
	core:add_listener( 
		"BattleCompleted_Treasure_Map",
		"BattleCompleted",
		function() 
			return cm:pending_battle_cache_human_is_involved()
		end,
		function()
			local main_attacker_faction_key = cm:pending_battle_cache_get_attacker_faction_name(1)
			local main_defender_faction_key = cm:pending_battle_cache_get_defender_faction_name(1)
			local main_attacker_faction = cm:get_faction(main_attacker_faction_key)
			local main_defender_faction = cm:get_faction(main_defender_faction_key)
			local main_attacker_faction_is_vampire_coast = main_attacker_faction and main_attacker_faction:culture() == vampire_coast_culture
			local main_defender_faction_is_vampire_coast = main_defender_faction and main_defender_faction:culture() == vampire_coast_culture
			
			-- human won against a pirate faction
			for i = 1, #pirate_factions do
				if main_attacker_faction_key == pirate_factions[i] and cm:pending_battle_cache_defender_victory() and main_defender_faction_is_vampire_coast then
					trigger_treasure_map_mission(main_defender_faction_key, 30)
					return
				elseif main_defender_faction_key == pirate_factions[i] and cm:pending_battle_cache_attacker_victory() and main_attacker_faction_is_vampire_coast then
					trigger_treasure_map_mission(main_attacker_faction_key, 30)
					return
				end
			end
			
			-- human won against any other faction
			if main_attacker_faction and main_attacker_faction:is_human() and main_attacker_faction_is_vampire_coast and cm:pending_battle_cache_attacker_victory() then
				trigger_treasure_map_mission(main_attacker_faction_key, 0)
			elseif main_defender_faction and main_defender_faction:is_human() and main_defender_faction_is_vampire_coast and cm:pending_battle_cache_defender_victory() then
				trigger_treasure_map_mission(main_defender_faction_key, 0)
			end	
		end,
		true
	)
	 
	core:add_listener(
		"MissionSucceeded_Treasure_Map",
		"MissionSucceeded",
		function(context)
			return context:faction():culture() == vampire_coast_culture
		end,
		function(context)
			local current_mission = context:mission():mission_record_key()
			local faction = context:faction()
			local faction_name = faction:name()
			
			if is_treasure_map_mission(current_mission) then
				set_treasure_map_end_variables(get_treasure_map_mission_category(current_mission))
				
				-- mission success advice
				if not cm:is_multiplayer() then
					local num_treasure_missions_succeeded_sp = cm:get_saved_value("num_treasure_missions_succeeded_sp") + 1
					
					cm:set_saved_value("num_treasure_missions_succeeded_sp", num_treasure_missions_succeeded_sp)
					
					if num_treasure_missions_succeeded_sp >= 1 and num_treasure_missions_succeeded_sp <= 2 then
						core:trigger_event("ScriptEventFirstTreasureMapMissionSucceeded")
					elseif num_treasure_missions_succeeded_sp >= 5 and num_treasure_missions_succeeded_sp <= 8 then
						core:trigger_event("ScriptEventFifthTreasureMapMissionSucceeded")
					end
				end
				
				-- generate the incident and its payload
				local incident_payload = cm:create_payload();
				
				if get_treasure_map_mission_category(current_mission) == "starting" then
					incident_payload:treasury_adjustment(2000)
					incident_payload:faction_pooled_resource_transaction("cst_infamy", "missions", 150, false)
				elseif get_treasure_map_mission_category(current_mission) == "unique" then
					incident_payload:treasury_adjustment(5000)
					incident_payload:faction_pooled_resource_transaction("cst_infamy", "missions", 150, false)
					incident_payload:faction_ancillary_gain(faction, get_random_ancillary_key_for_faction(faction_name, false, "rare"))
				elseif treasure_map_payload_mapping.reward_5[current_mission] then
					incident_payload:treasury_adjustment(4000)
					incident_payload:faction_ancillary_gain(faction, get_random_ancillary_key_for_faction(faction_name, false, "rare"))
				elseif treasure_map_payload_mapping.reward_4[current_mission] then
					incident_payload:treasury_adjustment(3000)
					incident_payload:faction_ancillary_gain(faction, get_random_ancillary_key_for_faction(faction_name, false, "uncommon"))
				elseif treasure_map_payload_mapping.reward_3[current_mission] then
					incident_payload:treasury_adjustment(2500)
					incident_payload:faction_ancillary_gain(faction, get_random_ancillary_key_for_faction(faction_name, false, "uncommon"))
				elseif treasure_map_payload_mapping.reward_2[current_mission] then
					incident_payload:treasury_adjustment(2000)
					incident_payload:faction_ancillary_gain(faction, get_random_ancillary_key_for_faction(faction_name, false, "common"))
				elseif treasure_map_payload_mapping.reward_1[current_mission] then
					incident_payload:treasury_adjustment(1500)
				else
					incident_payload:treasury_adjustment(1000)
				end
				
				cm:trigger_custom_incident(faction_name, "wh2_dlc11_incident_cst_found_treasure", true, incident_payload)
				
				-- delay triggering the next mission for a small period to give mission-success/hoard-uncovered event messages a chance to show
				cm:callback(function() trigger_treasure_map_mission(faction_name, 0) end, 0.5)
			end	
			
			if current_mission == "wh2_dlc11_noctilus_declare_war" and faction:has_effect_bundle("wh2_dlc11_award_treasure_map") then
				cm:callback(
					function()
						trigger_treasure_map_mission(faction_name, 100)
						cm:remove_effect_bundle("wh2_dlc11_award_treasure_map", faction_name)
					end,
					0.5
				)
			end
		end,
		true
	)
	
	core:add_listener(
		"MissionCancelled_Treasure_Map",
		"MissionCancelled",
		function(context)
			return is_treasure_map_mission(context:mission():mission_record_key())
		end,
		function(context)
			set_treasure_map_end_variables(get_treasure_map_mission_category(context:mission():mission_record_key()))
		end,
		true
	)
	
	-- listen for treasure searches being failed
	local num_treasure_hunt_missions_succeeded = 0
	local num_treasure_hunt_missions_failed = 0
	
	core:add_listener(
		"treasure_not_found_listener",
		"HaveCharacterWithinRangeOfPositionMissionEvaluationResultEvent",
		function(context)
			-- we don't test for the search being successful here as it allows the first instance of the trigger callback (which is triggered for each active treasure hunt mission) 
			-- to cancel subsequent failure tests - if the first is a success we don't want any failure events showing, and in this way they will be cancelled.
			return is_treasure_map_mission(context:mission_key()) and context:character():faction():culture() == vampire_coast_culture
		end,
		function(context)
			if context:was_successful() then
				num_treasure_hunt_missions_succeeded = num_treasure_hunt_missions_succeeded + 1
			else
				num_treasure_hunt_missions_failed = num_treasure_hunt_missions_failed + 1
			end
			
			local faction = context:character():faction()
			local faction_key = faction:name()
			
			cm:callback(
				function()
					if not faction:is_factions_turn() then
						return
					end
				
					if num_treasure_hunt_missions_succeeded == 0 and num_treasure_hunt_missions_failed > 0 then
						cm:show_message_event(
							faction_key,						-- assumes that factions can only generate these failure events on their turn
							"event_feed_strings_text_wh2_scripted_event_treasure_hunt_search_failed_title",
							"factions_screen_name_" .. faction_key,
							"event_feed_strings_text_wh2_scripted_event_treasure_hunt_search_failed_secondary_detail",
							true,
							786
						)
					end
					
					num_treasure_hunt_missions_succeeded = 0
					num_treasure_hunt_missions_failed = 0
				end,
				0.3
			)
		end,
		true
	)
end

function is_treasure_map_mission(current_mission)
	return current_mission:starts_with("wh2_dlc11_cst_treasure_map_")
end

function get_treasure_map_mission_category(current_mission)
	local mission_key = "wh2_dlc11_cst_treasure_map_"
	local position_of_final_underscore = string.find(current_mission, "_", string.len(mission_key) + 1)
	
	return string.sub(current_mission, string.len(mission_key) + 1, position_of_final_underscore - 1)
end

-- triggering a treasure map mission
function trigger_treasure_map_mission(faction_key, chance)
	-- check if player has 6 active treasure missions
	if active_treasure < 6 then
		chance = chance + cm:get_factions_bonus_value(faction_key, "treasure_map_find_chance")
		
		if (active_treasure == 0 and cm:random_number(100) <= map_chance + chance + 50) or (cm:random_number(100) <= map_chance + chance + map_chance_increase_per_turn) then
			local mission_category = false
			
			-- get a list of categories that are not active
			local inactive_mission_categories = {}
			
			if level3_missions < 2 and cm:random_number(100) <= 40 then
				mission_category = "unique"
			else
				for category, active in pairs(treasure_map_list) do
					if not active[1] then
						table.insert(inactive_mission_categories, category)
					end
				end
				
				mission_category = inactive_mission_categories[cm:random_number(#inactive_mission_categories)]
			end
			
			local random_mission = cm:random_number(treasure_map_list[mission_category][2])
			local mission_categories_with_levels = {
				["island"] = {1, 1, 1, 2, 2, 2, 1, 1},
				["volcano"] = {2, 2, 2, 2, 2, 2, 1, 1},
				["animal"] = {1, 1, 1, 1, 2, 2, 2, 1},
				["skull"] = {2, 1, 2, 1, 1, 2, 2, 2},
				["structure"] = {2, 2, 1, 1, 2, 1, 1, 1},
				["lake"] = {1, 1, 1, 2, 1, 2, 1, 2, 2},
				["symbols"] = {1, 1, 1, 1, 2, 1, 2, 1},
				["river"] = {1, 1, 1, 1, 2, 2, 1, 1},
				["unique"] = {3, 3, 3, 3, 3, 3, 3, 3}
			}
			
			local mission_level = mission_categories_with_levels[mission_category][random_mission]
			
			if mission_level == 3 then
				level3_missions = level3_missions + 1
			else
				treasure_map_list[mission_category][1] = true
			end
			
			active_treasure = active_treasure + 1
			
			if not cm:is_multiplayer() and faction_key == cm:get_local_faction_name(true) then
				-- if we can trigger advice about our first treasure map mission then do so
				if in_treasure_map_mission and in_treasure_map_mission.is_started and in_treasure_map_mission:passes_precondition_check() then
					core:trigger_event("ScriptEventIssueTreasureMapMission")
				-- if we can trigger advice about having six treasure maps then do so
				elseif active_treasure == 6 and in_full_treasure_map_log and in_full_treasure_map_log.is_started and in_full_treasure_map_log:passes_precondition_check() then
					core:trigger_event("ScriptEventIssueTreasureMapMissionFullLog")
				end
			end
			
			cm:trigger_mission(faction_key, "wh2_dlc11_cst_treasure_map_" .. mission_category .. "_treasure_me_" .. random_mission .. "_level_" .. mission_level, true)
			
			map_chance_increase_per_turn = 0
		end
	end
end

function set_treasure_map_end_variables(mission_category)
	if mission_category == "unique" or mission_category == "starting" then
		level3_missions = level3_missions - 1
	else
		treasure_map_list[mission_category][1] = false
	end
	
	active_treasure = active_treasure - 1
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("treasure_map_list", treasure_map_list, context)
		cm:save_named_value("map_chance", map_chance, context)
		cm:save_named_value("active_treasure", active_treasure, context)
		cm:save_named_value("level3_missions", level3_missions, context)
		cm:save_named_value("map_chance_increase_per_turn", map_chance_increase_per_turn, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		treasure_map_list = cm:load_named_value("treasure_map_list", treasure_map_list, context)
		map_chance = cm:load_named_value("map_chance", 15, context)
		active_treasure = cm:load_named_value("active_treasure", 1, context)
		level3_missions = cm:load_named_value("level3_missions", 1, context)
		map_chance_increase_per_turn = cm:load_named_value("map_chance_increase_per_turn", 0, context)
	end
)