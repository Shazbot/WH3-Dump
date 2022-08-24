blessed_spawnings = {
	ai_start_turn = 15,
	ai_spawn_chance = 10, -- spawn chance each turn
	current_spawn_timer = 0,
	max_spawn_timer = 15,
	nakai_faction_key = "wh2_dlc13_lzd_spirits_of_the_jungle",

	spawns = {
		{unit_key = "wh2_main_lzd_inf_chameleon_skinks_blessed_0", count = 3},
		{unit_key = "wh2_main_lzd_inf_saurus_spearmen_blessed_1", count = 3},
		{unit_key = "wh2_main_lzd_inf_saurus_warriors_blessed_1", count = 3},
		{unit_key = "wh2_main_lzd_inf_skink_skirmishers_blessed_0", count = 3},
		{unit_key = "wh2_main_lzd_cav_cold_one_spearriders_blessed_0", count = 2},
		{unit_key = "wh2_main_lzd_cav_terradon_riders_blessed_1", count = 2},
		{unit_key = "wh2_main_lzd_inf_temple_guards_blessed", count = 2},
		{unit_key = "wh2_main_lzd_mon_kroxigors_blessed", count = 2},
		{unit_key = "wh2_main_lzd_cav_horned_ones_blessed_0", count = 1},
		{unit_key = "wh2_main_lzd_mon_bastiladon_blessed_2", count = 1},
		{unit_key = "wh2_main_lzd_mon_carnosaur_blessed_0", count = 1},
		{unit_key = "wh2_main_lzd_mon_stegadon_blessed_1", count = 1}
	},

	mission_difficulty_turns = {
		early = 5,
		mid = 50,
		late = 100
	},

	mission_keys = {
		prefix = "wh2_main_spawning", -- use this to check the mission is one of the below keys
		early = {
			"wh2_main_spawning_capture_x_battle_captives",
			"wh2_main_spawning_defeat_n_armies_of_faction",
			"wh2_main_spawning_kill_x_entities",
			"wh2_main_spawning_raze_or_sack_n_different_settlements_including"
		},
		mid = {
			"wh2_main_spawning_capture_x_battle_captives_mid",
			"wh2_main_spawning_defeat_n_armies_of_faction_mid",
			"wh2_main_spawning_kill_x_entities_mid",
			"wh2_main_spawning_raze_or_sack_n_different_settlements_including_mid"
		},
		late = {
			"wh2_main_spawning_capture_x_battle_captives_late",
			"wh2_main_spawning_defeat_n_armies_of_faction_late",
			"wh2_main_spawning_kill_x_entities_late",
			"wh2_main_spawning_raze_or_sack_n_different_settlements_including_late"
		}
	},

	active_missions = {}
}


function blessed_spawnings:setup_blessed_spawnings()
	core:add_listener(
		"StartBlessedSpawnings",
		"WorldStartRound",
		function(context)
			return cm:turn_number() >= self.mission_difficulty_turns.early
		end,
		function(context)
			cm:add_faction_turn_start_listener_by_culture(
				"AwardBlessedSpawnings",
				"wh2_main_lzd_lizardmen",
				function(context)
					local faction = context:faction()
					local is_human = faction:is_human()
					local faction_name = faction:name()

					if is_human then
						-- Player
						if faction_name ~= self.nakai_faction_key then
							self:generate_missions(faction_name)
						end
					else
						-- AI
						if cm:turn_number() >= self.ai_start_turn then
							if cm:random_number(100) <= self.ai_spawn_chance then
								local unit = self.spawns[cm:random_number(#self.spawns)]		
								cm:add_units_to_faction_mercenary_pool(faction:command_queue_index(), unit.unit_key, unit.count)
							end
						end
					end
				end,
				true
			)
		end,
		false
	)
end

function blessed_spawnings:generate_missions(faction_name)
	self.current_spawn_timer = self.current_spawn_timer - 1

	if self.current_spawn_timer <= 0 then
		core:remove_listener("BlessedSpawningsMissionsIssued")
		core:add_listener(
			"BlessedSpawningsMissionsIssued",
			"MissionIssued",
			function(context)
				return context:mission():mission_record_key():starts_with(self.mission_keys.prefix)
			end,
			function(context)
				out.design("Blessed Spawning: Mission Launch Successful: Resetting timer")
				self.active_missions[context:faction():name()] = context:mission():mission_record_key()
				self.current_spawn_timer = self.max_spawn_timer
			end,
			false
		)

		local turn_number = cm:turn_number()
		local mission_list

		if turn_number >= self.mission_difficulty_turns.early and turn_number < self.mission_difficulty_turns.mid then
			mission_list = self.mission_keys.early
		elseif turn_number >= self.mission_difficulty_turns.mid and turn_number < self.mission_difficulty_turns.late then
			mission_list = self.mission_keys.mid
		elseif turn_number >= self.mission_difficulty_turns.late then
			mission_list = self.mission_keys.late
		else
			-- too early for missions
			return
		end

		local mission_key = mission_list[cm:random_number(#mission_list)]
		local rare_roll = cm:random_number(100)

		if rare_roll > 80 then
			-- upgrade the mission to the rare version
			mission_key = mission_key.."_rare"
		end

		out.design("Blessed Spawning: Attempting to start mission "..tostring(mission_key).." for "..tostring(faction_name))	
		cm:trigger_mission(faction_name, mission_key, true, true)
	end
end



--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("blessed_spawnings.current_spawn_timer", blessed_spawnings.current_spawn_timer, context)
		cm:save_named_value("blessed_spawnings.active_missions", blessed_spawnings.active_missions, context)
	end	
)

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			blessed_spawnings.current_spawn_timer = cm:load_named_value("blessed_spawnings.current_spawn_timer", blessed_spawnings.current_spawn_timer, context)
			blessed_spawnings.active_missions = cm:load_named_value("blessed_spawnings.active_missions", blessed_spawnings.active_missions, context)
		end
	end
)