roving_pirates = {
	pirate_details = {
		-- The order of these is important, this dictates their order in the infamy page. 1st = bottom, last = top of the list.
		{
			faction_key = "wh2_dlc11_cst_rogue_boyz_of_the_forbidden_coast",
			spawn_pos = {x = 339, y = 288},
			has_spawned = false,
			effect = "wh_main_reduced_movement_range_20",
			xp = 0,
			level = 20,
			item_owned = "piece_of_eight",
			behaviour = "roving",	-- Piece of Eight
			patrol_route = {"start", {x = 298, y = 150}, {x = 369, y = 76}, {x = 543, y = 113}, {x = 384, y = 296}}
		},
		{
			faction_key = "wh2_dlc11_cst_rogue_freebooters_of_port_royale",
			spawn_pos = {x = 249, y = 525},
			has_spawned = false,
			effect = "wh_main_reduced_movement_range_20",
			xp = 0,
			level = 20,
			item_owned = "piece_of_eight",
			behaviour = "roving",	-- Piece of Eight
			patrol_route = {"start", {x = 165, y = 438}, {x = 236, y = 361}, {x = 236, y = 361}, {x = 351, y = 469}}
		},
		{
			faction_key = "wh2_dlc11_cst_rogue_the_churning_gulf_raiders",
			spawn_pos = {x = 399, y = 413},
			has_spawned = false,
			effect = "wh_main_reduced_movement_range_20",
			xp = 1,
			level = 20,
			item_owned = "piece_of_eight",
			behaviour = "roving",	-- Piece of Eight
			patrol_route = {"start", {x = 412, y = 350}, {x = 526, y = 349}, {x = 467, y = 403}}
		},
		{
			faction_key = "wh2_dlc11_cst_shanty_middle_sea_brigands",
			spawn_pos = {x = 432, y = 395},
			has_spawned = false,
			effect = "wh2_dlc11_bundle_shanty_pirate_01",
			xp = 1,
			level = 25,
			item_owned = "sea_shanty",
			shanty_held = true,
			shanty_level = 1,
			cqi = nil,
			behaviour = "shanty"	-- Sea Shanty
		},
		{
			faction_key = "wh2_dlc11_cst_rogue_bleak_coast_buccaneers",
			spawn_pos = {x = 657, y = 508},
			has_spawned = false,
			effect = "wh_main_reduced_movement_range_20",
			xp = 2,
			level = 25,
			item_owned = "piece_of_eight",
			behaviour = "roving",	-- Piece of Eight
			patrol_route = {"start", {x = 611, y = 474}, {x = 563, y = 404}}
		},
		{
			faction_key = "wh2_dlc11_cst_rogue_grey_point_scuttlers",
			spawn_pos = {x = 412, y = 507},
			has_spawned = false,
			effect = "wh_main_reduced_movement_range_20",
			xp = 2,
			level = 30,
			item_owned = "piece_of_eight",
			behaviour = "roving",	-- Piece of Eight
			patrol_route = {"start", {x = 379, y = 574}, {x = 328, y = 524}, {x = 350, y = 461}}
		},
		{
			faction_key = "wh2_dlc11_cst_shanty_dragon_spine_privateers",
			spawn_pos = {x = 378, y = 510},
			has_spawned = false,
			effect = "wh2_dlc11_bundle_shanty_pirate_02",
			xp = 3,
			level = 30,
			item_owned = "sea_shanty",
			shanty_held = true,
			shanty_level = 2,
			cqi = nil,
			behaviour = "shanty"	-- Sea Shanty
		},
		{
			faction_key = "wh2_dlc11_cst_rogue_tyrants_of_the_black_ocean",
			spawn_pos = {x = 190, y = 642},
			has_spawned = false,
			effect = "wh_main_reduced_movement_range_20",
			xp = 3,
			level = 35,
			item_owned = "piece_of_eight",
			behaviour = "roving",	-- Piece of Eight
			patrol_route = {"start", {x = 198, y = 678}, {x = 256, y = 705}, {x = 333, y = 699}, {x = 366, y = 705}, {x = 267, y = 656}}
		},
		{
			faction_key = "wh2_dlc11_cst_rogue_terrors_of_the_dark_straights",
			spawn_pos = {x = 312, y = 734},
			has_spawned = false,
			effect = "wh_main_reduced_movement_range_20",
			xp = 4,
			level = 35,
			item_owned = "piece_of_eight",
			behaviour = "roving",	-- Piece of Eight
			patrol_route = {"start", {x = 284, y = 747}, {x = 300, y = 814}, {x = 359, y = 806}}
		},
		{
			faction_key = "wh2_dlc11_cst_shanty_shark_straight_seadogs",
			spawn_pos = {x = 302, y = 700},
			has_spawned = false,
			effect = "wh2_dlc11_bundle_shanty_pirate_03",
			xp = 4,
			level = 40,
			item_owned = "sea_shanty",
			shanty_held = true,
			shanty_level = 3,
			cqi = nil,
			behaviour = "shanty"	-- Sea Shanty
		}	
	},

	aggro_radius = 300,
	aggro_cooldown = 5,
	aggro_abort = 3,

	ror_mission_unlocks = {
		["wh3_main_ie_qb_cst_harkon_quest_for_slann_gold"] = "wh2_dlc11_cst_mon_necrofex_colossus_ror_0",
		["wh3_main_ie_qb_cst_noctilus_captain_roths_moondial"] = "wh2_dlc11_cst_mon_necrofex_colossus_ror_0",
		["wh3_main_ie_qb_cst_aranessa_krakens_bane"] = "wh2_dlc11_cst_mon_necrofex_colossus_ror_0",
		["wh3_main_ie_qb_cst_cylostra_the_bordeleaux_flabellum"] = "wh2_dlc11_cst_mon_necrofex_colossus_ror_0"
	},
	ror_mission_winners = {},
	ror_keys = {
		"wh2_dlc11_cst_inf_zombie_deckhands_mob_ror_0",
		"wh2_dlc11_cst_inf_zombie_gunnery_mob_ror_0",
		"wh2_dlc11_cst_cav_deck_droppers_ror_0",
		"wh2_dlc11_cst_mon_mournguls_ror_0",
		"wh2_dlc11_cst_mon_rotting_prometheans_gunnery_mob_ror",
		"wh2_dlc11_cst_inf_deck_gunners_ror_0",
		"wh2_dlc11_cst_inf_depth_guard_ror_0",
		"wh2_dlc11_cst_mon_necrofex_colossus_ror_0"
	}
}


function roving_pirates:add_roving_pirates_listeners()
	out("#### Adding Roving Pirates Listeners ####")
	
	self:faction_turn_start_listener()

	-- setup count for how many pieces of eight have been collected in sp
	if not cm:is_multiplayer() and not cm:get_saved_value("pieces_of_eight_collected_sp") then
		cm:set_saved_value("pieces_of_eight_collected_sp", 0)
	end
	
	if cm:is_new_game() == true then
		roving_pirates:setup_roving_pirates()
		
		-- Lock all ROR
		local faction_list = cm:model():world():faction_list()
		
		for _, current_faction in model_pairs(faction_list) do
			if infamy:is_faction_playable_vampire_coast(current_faction) then
				for j = 1, #roving_pirates.ror_keys do
					cm:add_event_restricted_unit_record_for_faction(roving_pirates.ror_keys[j], current_faction:name(), "dlc11_ror_unlock_reason_"..j)
				end
			end
		end
	end
	
	-- Add mission unlocks for ROR
	for i = 1, 7 do
		roving_pirates.ror_mission_unlocks["wh2_dlc11_mission_piece_of_eight_"..i] = roving_pirates.ror_keys[i]
	end
	
	core:add_listener(
		"PieceOfEight_MissionSucceeded",
		"MissionSucceeded",
		true,
		function(context)
			roving_pirates:piece_of_eight_completed(context)
		end,
		true
	)
	
	-- Add listener for a Pirate being respawned, so we can restart missions for those who haven't completed them
	core:add_listener(
		"PieceOfEight_Respawn",
		"ScriptEventInvasionManagerRespawn",
		true,
		function(context)
			roving_pirates:piece_of_eight_respawn(context)
		end,
		true
	)
end

function roving_pirates:setup_roving_pirates()
	local piece_of_eight_mission_count = 1
	local human_factions = cm:get_human_factions()

	cm:disable_event_feed_events(true, "", "wh_event_subcategory_faction_missions_objectives", "")
	
	for i = 1, #roving_pirates.pirate_details do
		local pirate = roving_pirates.pirate_details[i]
		local invasion_key = pirate.faction_key.."_PIRATE"
		
		-- Spawn force and create patrol route invasion
		if pirate.behaviour == "roving" then
			pirate.has_spawned = true

			cm:spawn_rogue_army(pirate.faction_key, pirate.spawn_pos.x, pirate.spawn_pos.y)
			cm:force_diplomacy("all", "faction:"..pirate.faction_key, "all", false, false, true)
			cm:force_diplomacy("all", "faction:"..pirate.faction_key, "payments", false, false, true)

			for j = 1, #human_factions do
				local faction_key = human_factions[j]
				cm:force_diplomacy("faction:"..faction_key, "faction:"..pirate.faction_key, "war", true, true, false)
				cm:force_diplomacy("faction:"..pirate.faction_key, "faction:"..faction_key, "war", false, false, false)
			end

			local rogue_force = cm:get_faction(pirate.faction_key):faction_leader():military_force()
			local roving_pirate = invasion_manager:new_invasion_from_existing_force(invasion_key, rogue_force)
			
			roving_pirate:set_target("PATROL", pirate.patrol_route)
			roving_pirate:add_aggro_radius(roving_pirates.aggro_radius, human_factions, roving_pirates.aggro_cooldown, roving_pirates.aggro_abort)
			
			if pirate.effect ~= nil and pirate.effect ~= "" then
				roving_pirate:apply_effect(pirate.effect, -1)
			end
			if pirate.xp ~= nil and pirate.xp > 0 then
				roving_pirate:add_unit_experience(pirate.xp)
			end
			if pirate.level ~= nil and pirate.level > 0 then
				roving_pirate:add_character_experience(pirate.level, true)
			end
			
			roving_pirate:should_maintain_army(true, 50)
			roving_pirate:start_invasion()
		end
		
		-- Trigger Piece of Eight missions
		if pirate.item_owned == "piece_of_eight" and cm:are_any_factions_human(nil, "wh2_dlc11_cst_vampire_coast") then
			local faction_list = cm:model():world():faction_list()
			
			for _, current_faction in model_pairs(faction_list) do
				if infamy:is_faction_playable_vampire_coast(current_faction) then
					if current_faction:is_human() then
						local faction_key = current_faction:name()
						local mission_key = "wh2_dlc11_mission_piece_of_eight_"..piece_of_eight_mission_count
						local mm = mission_manager:new(faction_key, mission_key)
						mm:set_mission_issuer("CLAN_ELDERS")
						
						mm:add_new_objective("ENGAGE_FORCE")
						mm:add_condition("cqi "..cm:get_faction(pirate.faction_key):faction_leader():military_force():command_queue_index())
						mm:add_condition("requires_victory")
						
						mm:add_payload("effect_bundle{bundle_key wh2_dlc11_ror_reward_"..piece_of_eight_mission_count..";turns 0;}")
						mm:trigger()
						roving_pirates.ror_mission_winners[faction_key] = {}
						roving_pirates.ror_mission_winners[faction_key][mission_key] = false
					end
				end
			end
			pirate.item_num = piece_of_eight_mission_count
			piece_of_eight_mission_count = piece_of_eight_mission_count + 1
		end
	end

	cm:disable_event_feed_events(false, "", "wh_event_subcategory_faction_missions_objectives", "")
end


function roving_pirates:spawn_shanty_army(roving_pirate_details)
	roving_pirate_details.has_spawned = true

	cm:spawn_rogue_army(roving_pirate_details.faction_key, roving_pirate_details.spawn_pos.x, roving_pirate_details.spawn_pos.y)
	
	local rogue_force = cm:get_faction(roving_pirate_details.faction_key):faction_leader():military_force()
	local rogue_pirate = invasion_manager:new_invasion_from_existing_force(roving_pirate_details.faction_key.."_PIRATE", rogue_force)

	-- save force cqi for future use in missions.
	roving_pirate_details.cqi = rogue_force:command_queue_index()
	
	if roving_pirate_details.effect ~= nil and roving_pirate_details.effect ~= "" then
		rogue_pirate:apply_effect(roving_pirate_details.effect, -1)
	end
	if roving_pirate_details.xp ~= nil and roving_pirate_details.xp > 0 then
		rogue_pirate:add_unit_experience(roving_pirate_details.xp)
	end
	if roving_pirate_details.level ~= nil and roving_pirate_details.level > 0 then
		rogue_pirate:add_character_experience(roving_pirate_details.level, true)
	end
	
	rogue_pirate:set_target("NONE", nil, player)

	rogue_pirate:start_invasion(function() 
		cm:force_diplomacy("all", "faction:"..roving_pirate_details.faction_key, "all", false, false, true)
	end, true, false, false)
end


function roving_pirates:faction_turn_start_listener()
	core:add_listener(
		"infamy_faction_turn_start",
		"FactionTurnStart",
		function(context)
			local faction = context:faction()
			return faction:is_human() and infamy:is_faction_playable_vampire_coast(faction)
		end,
		function(context) 
			local faction = context:faction()
			local faction_key = faction:name()
			local player_infamy = faction:pooled_resource_manager():resource("cst_infamy"):value()

			for _, roving_pirate in ipairs(self.pirate_details) do
				if roving_pirate.behaviour == "shanty" and roving_pirate.shanty_held and infamy.player_shanty_levels[faction_key] + 1 == roving_pirate.shanty_level and infamy.player_shanty_missions_active[roving_pirate.shanty_level][faction_key] == false then
					if player_infamy > roving_pirate.infamy then
						-- player has gained more infamy, they can now try to take this shanty

						if roving_pirate.has_spawned == false then
							-- This is the first player to reach this point, spawning the army
							roving_pirates:spawn_shanty_army(roving_pirate)
							cm:force_declare_war(roving_pirate.faction_key, faction_key, false, false)
						else
							-- trigger war between the existing army and the player
							cm:force_declare_war(roving_pirate.faction_key, faction_key, false, false)
						end
						infamy:launch_shanty_mission(faction_key, roving_pirate, false, roving_pirate.shanty_level)
					end
				end
			end

			infamy:update_ui()
		end, 
		true
	)
end


function roving_pirates:piece_of_eight_respawn(context)
	local invasion_general = context:character()
	
	if invasion_general:is_null_interface() == false then
		local general_cqi = invasion_general:family_member():command_queue_index()
		
		-- Go through all pirates until we find the one relating to this invasion
		for i = 1, #roving_pirates.pirate_details do
			local pirate = roving_pirates.pirate_details[i]
			
			if invasion_general:faction():name() == pirate.faction_key and pirate.item_owned == "piece_of_eight" then
				
				-- Go through all human pirates, and if they aren't in the complete table give them the mission
				local faction_list = cm:model():world():faction_list()
				
				for _, current_faction in model_pairs(faction_list) do
					if infamy:is_faction_playable_vampire_coast(current_faction) then
						if current_faction:is_human() then
							local faction_key = current_faction:name()
							local mission_key = "wh2_dlc11_mission_piece_of_eight_"..pirate.item_num
							
							if roving_pirates.ror_mission_winners[faction_key][mission_key] == false then
								local mm = mission_manager:new(faction_key, mission_key)
								mm:set_mission_issuer("CLAN_ELDERS")
								mm:add_new_objective("KILL_CHARACTER_BY_ANY_MEANS")
								mm:add_condition("family_member "..general_cqi)
								mm:add_payload("effect_bundle{bundle_key wh2_dlc11_ror_reward_"..pirate.item_num..";turns 0;}")
								mm:trigger()
							end
						end
					end
				end
				
				-- Stop diplomacy again
				cm:force_diplomacy("all", "faction:"..pirate.faction_key, "all", false, false, true)
				cm:force_diplomacy("all", "faction:"..pirate.faction_key, "war", true, true, true)
				break
			end
		end
	end
end

function roving_pirates:piece_of_eight_completed(context)
	local mission_key = context:mission():mission_record_key()
	local faction = context:faction()
	local faction_key = faction:name()
	
	if roving_pirates.ror_mission_unlocks[mission_key] ~= nil then
		if roving_pirates.ror_mission_winners[faction_key] then
			roving_pirates.ror_mission_winners[faction_key][mission_key] = true
		end
		cm:remove_event_restricted_unit_record_for_faction(roving_pirates.ror_mission_unlocks[mission_key], faction_key)
		
		cm:callback(function()
			for i = 1, 8 do
				if faction:has_effect_bundle("wh2_dlc11_ror_reward_"..i) then
					cm:remove_effect_bundle("wh2_dlc11_ror_reward_"..i, faction_key)
				end
			end
		end, 1)
		
		-- Trigger script event for advice
		local pieces_of_eight_collected_sp = cm:get_saved_value("pieces_of_eight_collected_sp")			-- only for use in singleplayer
		if not cm:is_multiplayer() then
			pieces_of_eight_collected_sp = pieces_of_eight_collected_sp + 1
			core:trigger_event("ScriptEventPieceOfEightCollected", pieces_of_eight_collected_sp)
		end
	end
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("roving_pirates", roving_pirates.pirate_details, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			roving_pirates.pirate_details = cm:load_named_value("roving_pirates", roving_pirates.pirate_details, context)
		end
	end
)