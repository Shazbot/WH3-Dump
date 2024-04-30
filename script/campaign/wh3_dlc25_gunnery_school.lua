gunnery_school = {
	faction_key = "wh_main_emp_wissenland",
	artillery = {
		factor = "consumed_in_battle",
		{ability_key = "wh3_dlc25_army_abilities_bjuna_bombard", pooled_resource_key = "wh3_dlc25_emp_bjuna_bombard_charges", depleted_incident = "wh3_dlc25_incident_gunnery_school_bombard_depleted"},
		{ability_key = "wh3_dlc25_army_abilities_spirit_barrage", pooled_resource_key = "wh3_dlc25_emp_spirit_barrage_charges", depleted_incident = "wh3_dlc25_incident_gunnery_school_barrage_depleted"},
		{ability_key = "wh3_dlc25_army_abilities_purple_eclipse", pooled_resource_key = "wh3_dlc25_emp_purple_eclipse_charges", depleted_incident = "wh3_dlc25_incident_gunnery_school_eclipse_depleted"}
	},
	artillery_mission_abilities = {
		-- Use bjuna bombard ability
		["wh3_dlc25_gunnery_school_tier_3_3"] = "wh3_dlc25_army_abilities_bjuna_bombard",
		-- Use spirit barrage ability
		["wh3_dlc25_gunnery_school_tier_4_3"] = "wh3_dlc25_army_abilities_spirit_barrage"
	},
	current_stage = 1,
	progression_events = {
		"wh3_dlc25_incident_gunnery_school_tier_1",
		"wh3_dlc25_incident_gunnery_school_tier_2",
		"wh3_dlc25_incident_gunnery_school_tier_3",
		"wh3_dlc25_incident_gunnery_school_tier_4"
	},
	locked_states = {
		["wh3_dlc25_emp_cav_outriders_morr"] = "state_troop_lock_tooltip_elspeth_t2",
		["wh3_dlc25_emp_inf_nuln_ironsides_morr"] = "state_troop_lock_tooltip_elspeth_t2",
		["wh3_dlc25_emp_art_helstorm_rocket_battery_morr"] = "state_troop_lock_tooltip_elspeth_t3",
		["wh3_dlc25_emp_veh_marienburg_land_ship_morr"] = "state_troop_lock_tooltip_elspeth"
	},
	progression_unlocks = {
		{
			-- Stage 1
			mission_keys = {
				"wh3_dlc25_gunnery_school_tier_1_1",
				"wh3_dlc25_gunnery_school_tier_1_2",
				"wh3_dlc25_gunnery_school_tier_1_3"
			},
			scripted_mission = {
				["wh3_dlc25_gunnery_school_tier_1_1"] = false,
				["wh3_dlc25_gunnery_school_tier_1_2"] = false,
				["wh3_dlc25_gunnery_school_tier_1_3"] = false
			},
			rituals = {
				"wh3_dlc25_ritual_emp_don_cannons_2",
				"wh3_dlc25_ritual_emp_don_cav_guns_2",
				"wh3_dlc25_ritual_emp_don_helblasters_2",
				"wh3_dlc25_ritual_emp_don_helstorm_2",
				"wh3_dlc25_ritual_emp_don_inf_guns_2",
				"wh3_dlc25_ritual_emp_don_land_ship_2",
				"wh3_dlc25_ritual_emp_don_mortors_2",
				"wh3_dlc25_ritual_emp_don_steam_tank_2"
			},
			ancillary = "wh3_dlc25_anc_weapon_experimental_explosive",
		},
		{
			mission_keys = {
				"wh3_dlc25_gunnery_school_tier_2_1",
				"wh3_dlc25_gunnery_school_tier_2_2",
				"wh3_dlc25_gunnery_school_tier_2_3"
			},
			-- Stage 2
			scripted_mission = {
				["wh3_dlc25_gunnery_school_tier_2_1"] = false,
				["wh3_dlc25_gunnery_school_tier_2_2"] = false,
				["wh3_dlc25_gunnery_school_tier_2_3"] = false
			},
			rituals = {
				"wh3_dlc25_ritual_emp_don_amethyst_ironsides_1",
				"wh3_dlc25_ritual_emp_don_amethyst_ironsides_2",
				"wh3_dlc25_ritual_emp_don_amethyst_ironsides_3",
				"wh3_dlc25_ritual_emp_don_amethyst_ironsides_4",
				"wh3_dlc25_ritual_emp_don_amethyst_ironsides_cap",
				"wh3_dlc25_ritual_emp_don_bjuna_bombard",
				"wh3_dlc25_ritual_emp_don_buckshot_reaper_1",
				"wh3_dlc25_ritual_emp_don_buckshot_reaper_2",
				"wh3_dlc25_ritual_emp_don_buckshot_reaper_3",
				"wh3_dlc25_ritual_emp_don_buckshot_reaper_4",
				"wh3_dlc25_ritual_emp_don_buckshot_reaper_cap"
			},
			ancillary = "wh3_dlc25_anc_talisman_enhanced_scope",
			unit = {
				"wh3_dlc25_emp_cav_outriders_morr",
				"wh3_dlc25_emp_inf_nuln_ironsides_morr"
			}
		},
		{
			-- Stage 3
			mission_keys = {
				"wh3_dlc25_gunnery_school_tier_3_1",
				"wh3_dlc25_gunnery_school_tier_3_2",
				"wh3_dlc25_gunnery_school_tier_3_3"
			},
			scripted_mission = {
				["wh3_dlc25_gunnery_school_tier_3_1"] = false,
				["wh3_dlc25_gunnery_school_tier_3_2"] = false,
				["wh3_dlc25_gunnery_school_tier_3_3"] = true
			},
			rituals = {
				"wh3_dlc25_ritual_emp_don_deathstorm_battery_1",
				"wh3_dlc25_ritual_emp_don_deathstorm_battery_2",
				"wh3_dlc25_ritual_emp_don_deathstorm_battery_3",
				"wh3_dlc25_ritual_emp_don_deathstorm_battery_4",
				"wh3_dlc25_ritual_emp_don_deathstorm_battery_cap",
				"wh3_dlc25_ritual_emp_don_spirit_barrage",
				"wh3_dlc25_ritual_emp_don_cannons_3",
				"wh3_dlc25_ritual_emp_don_cav_guns_3",
				"wh3_dlc25_ritual_emp_don_helblasters_3",
				"wh3_dlc25_ritual_emp_don_helstorm_3",
				"wh3_dlc25_ritual_emp_don_inf_guns_3",
				"wh3_dlc25_ritual_emp_don_land_ship_3",
				"wh3_dlc25_ritual_emp_don_mortors_3",
				"wh3_dlc25_ritual_emp_don_steam_tank_3"
			},
			ancillary = "wh3_dlc25_anc_enchanted_item_ominous_powder",
			unit = {
				"wh3_dlc25_emp_art_helstorm_rocket_battery_morr"
			}
		},
		{
			-- Stage 4
			mission_keys = {
				"wh3_dlc25_gunnery_school_tier_4_1",
				"wh3_dlc25_gunnery_school_tier_4_2",
				"wh3_dlc25_gunnery_school_tier_4_3"
			},
			scripted_mission = {
				["wh3_dlc25_gunnery_school_tier_4_1"] = false,
				["wh3_dlc25_gunnery_school_tier_4_2"] = false,
				["wh3_dlc25_gunnery_school_tier_4_3"] = true
			},
			rituals = {
				"wh3_dlc25_ritual_emp_don_black_rose_1",
				"wh3_dlc25_ritual_emp_don_black_rose_2",
				"wh3_dlc25_ritual_emp_don_black_rose_3",
				"wh3_dlc25_ritual_emp_don_black_rose_4",
				"wh3_dlc25_ritual_emp_don_black_rose_cap",
				"wh3_dlc25_ritual_emp_don_purple_eclipse"
			},
			unit = {
				"wh3_dlc25_emp_veh_marienburg_land_ship_morr"
			}
		},
		{
			-- Stage 5
			mission_keys = {},
			scripted_mission = {},
			rituals = {}
		}
	}
}

function gunnery_school:initialise()
	self:spend_artillery_charges()
	self:unlock_panel_progression()
	self:campaign_victory_condition_check()

	for mission_key, _ in pairs(self.artillery_mission_abilities) do
		--relaunch any active scripted artillery mission listeners after loading
		if cm:mission_is_active_for_faction(cm:get_faction(self.faction_key), mission_key) then
			self:scripted_artillery_mission_completion_listener(mission_key)
		end
	end

	if cm:is_new_game() then
		core:add_listener(
			"GunnerySchoolInitialise",
			"FactionTurnStart",
			function(context)
				return context:faction():name() == self.faction_key and context:faction():is_human()
			end,
			function(context)
				self:trigger_state_missions(1)

				for unit, tooltip in pairs(self.locked_states) do
					cm:add_event_restricted_unit_record_for_faction(unit, self.faction_key, tooltip)
				end
			end,
			false
		);
	end

	self:setup_incidents()
end

function gunnery_school:setup_incidents()
	for k, incident_key in pairs(self.progression_events) do
		core:add_listener(
			"GunnerySchoolIncidents",
			"GunnerySchoolTierComplete"..k,
			true,
			function(context)
				cm:trigger_incident(self.faction_key, incident_key, true)				
			end,
			true
		)
	end
end

function gunnery_school:spend_artillery_charges()
	core:add_listener(
		"gunnery_school_artillery_charges",
		"BattleCompleted",
		function(context)
			return cm:pending_battle_cache_faction_is_involved(self.faction_key)
		end,
		function()
			local pb = cm:model():pending_battle()
			if pb:has_been_fought() then
				local faction = cm:get_faction(self.faction_key)
				local faction_cqi = faction:command_queue_index()

				for _, artillery in ipairs(self.artillery) do
					local ability_use_number = pb:get_how_many_times_ability_has_been_used_in_battle(faction_cqi, artillery.ability_key)
					out.design("Ability: "..artillery.ability_key.." was used: "..ability_use_number.." times")

					if ability_use_number > 0 then
						-- ability has been used, remove charges equal to number of uses
						cm:faction_add_pooled_resource(self.faction_key, artillery.pooled_resource_key, self.artillery.factor, -ability_use_number)

						if faction:pooled_resource_manager():resource(artillery.pooled_resource_key):value() <= 0 then
							-- charges is back to 0 inform the player
							cm:trigger_incident(self.faction_key, artillery.depleted_incident, true)
						end
					end
				end
			end
		end,
		true
	)
end

function gunnery_school:unlock_panel_progression()
	core:add_listener(
		"gunnery_school_panel_progression",
		"MissionSucceeded",
		function(context)
			local mission_key = context:mission():mission_record_key()
			local current_stage_data = self.progression_unlocks[self.current_stage]

			if current_stage_data.scripted_mission[mission_key] ~= nil then
				local faction = cm:get_faction(self.faction_key)

				for _, mission in ipairs(current_stage_data.mission_keys) do
					if cm:mission_is_active_for_faction(faction, mission) then
						-- there's other missions in this tier that aren't complete. Don't unlock the rituals
						return false
					end
				end

				return true
			end

			return false
		end,
		function(context)
			local faction = cm:get_faction(self.faction_key)
			local current_stage_data = self.progression_unlocks[self.current_stage]

			core:trigger_event("GunnerySchoolTierComplete"..self.current_stage)

			self.current_stage = self.current_stage + 1
			gunnery_school:trigger_state_missions(self.current_stage)

			for _, ritual_key in ipairs(current_stage_data.rituals) do
				out.design("unlocking ritual: "..ritual_key)
				cm:unlock_ritual(faction, ritual_key, 0)
			end

			if current_stage_data.ancillary ~= nil then
				cm:add_ancillary_to_faction(faction, current_stage_data.ancillary, false) 
			end

			if current_stage_data.unit then
				for _, unit in ipairs(current_stage_data.unit) do
					cm:remove_event_restricted_unit_record_for_faction(unit, self.faction_key)
				end
			end
		end,
		true
	)
end


-- Elspeth Gunnery School check for victory conditions 
function gunnery_school:campaign_victory_condition_check()
	local is_elspeth_human = cm:get_faction(self.faction_key):is_human()
	local campaign_name = cm:get_campaign_name() 

	if is_elspeth_human and campaign_name  == "main_warhammer"  then
		core:add_listener(
			"IEVictoryConditionShortVictoryGunnerySchool",
			"GunnerySchoolTierComplete2",
			true,
			function()
				cm:complete_scripted_mission_objective(self.faction_key, "wh_main_short_victory", "gunnery_school_level_3_victory", true)
			end,
			true
			)
	elseif is_elspeth_human and campaign_name == "wh3_main_chaos" then
		core:add_listener(
			"VictoryConditionVictoryLongGunnerySchool",
			"GunnerySchoolTierComplete3",
			true,
			function()
				cm:complete_scripted_mission_objective(self.faction_key, "wh_main_long_victory", "gunnery_school_level_5_victory", true)
			end,
			true
			)
	end
end


function gunnery_school:trigger_state_missions(stage_number)
	for _, key in ipairs(self.progression_unlocks[stage_number].mission_keys) do
		local scripted = self.progression_unlocks[stage_number].scripted_mission[key]
		out.design("trigger_mission: "..key)
		if scripted then
			self:trigger_scripted_artillery_mission(key)
		else
			cm:trigger_mission(self.faction_key, key, true)
		end
	end
end


function gunnery_school:trigger_scripted_artillery_mission(mission_key)
	local mm = mission_manager:new(self.faction_key, mission_key)
	mm:add_new_objective("SCRIPTED")

	mm:add_condition("script_key " .. mission_key)
	mm:add_condition("override_text mission_text_text_mis_" .. mission_key)

	mm:add_payload("money 1500")

	mm:set_should_whitelist(false)
	
	mm:trigger()

	self:scripted_artillery_mission_completion_listener(mission_key)
end

function gunnery_school:scripted_artillery_mission_completion_listener(mission_key)
	core:add_listener(
		"gunnery_school_artillery_objective_ability_used",
		"BattleCompleted",
		function(context)
			local pb = cm:model():pending_battle()
			if pb:has_been_fought() then
				local faction_cqi = cm:get_faction(self.faction_key):command_queue_index()

				local ability_use_number = pb:get_how_many_times_ability_has_been_used_in_battle(faction_cqi, self.artillery_mission_abilities[mission_key])

				if ability_use_number > 0 then
					-- ability for the currently active ability usage mission has been used
					return true
				end

				return false
			end
		end,
		function(context)
			cm:complete_scripted_mission_objective(self.faction_key, mission_key, mission_key, true)
		end,
		false
	)
end





--------------------- SAVE/LOAD ---------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("gunnery_school.current_stage", gunnery_school.current_stage, context)
	end
)
cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			gunnery_school.current_stage = cm:load_named_value("gunnery_school.current_stage", gunnery_school.current_stage, context)
		end
	end
)