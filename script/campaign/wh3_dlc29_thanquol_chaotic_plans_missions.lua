CHAOTIC_PLAN_TYPES = {
	ECONOMIC_PLAN = "economic",
	MAGIC_PLAN = "magic",
	MILITARY_PLAN = "military",
	ANY = "any"
}

CHAOTIC_MISSION_DIFFICULTY_TYPES = {
	EASY = "easy",
	MEDIUM = "medium",
	HARD = "hard",
}

thanquol_chaotic_plans_missions_config = {
	faction_key = "wh3_dlc29_skv_clan_scruten",
	number_of_concurent_missions = 2,
	max_allowed_concurrent_missions_of_same_type = 2, -- for now keep this to 2, if you want more make sure you contact a programmer to add the handling of selecting the appropriate mission key
	missions_initiating_turn = 500,
	objective_type_treasury = "treasury",
	--this is how many turns a mission of each difficulty wil be available for
	mission_avialability_in_turns_per_difficulty = {
		[CHAOTIC_MISSION_DIFFICULTY_TYPES.EASY] = 7,
		[CHAOTIC_MISSION_DIFFICULTY_TYPES.MEDIUM] = 10,
		[CHAOTIC_MISSION_DIFFICULTY_TYPES.HARD] = 13,
	},
	mission_script_key = "chaotic_plan_mission_script",
	narrative_mission_script_key = "chaotic_plan_narrative_mission_script",
	mission_keys = {
		[CHAOTIC_PLAN_TYPES.ANY] = "wh3_dlc29_skv_chaotic_plans_mission_any",
		[CHAOTIC_PLAN_TYPES.ECONOMIC_PLAN] = "wh3_dlc29_skv_chaotic_plans_mission_economic",
		[CHAOTIC_PLAN_TYPES.MILITARY_PLAN] = "wh3_dlc29_skv_chaotic_plans_mission_military",
		[CHAOTIC_PLAN_TYPES.MAGIC_PLAN] = "wh3_dlc29_skv_chaotic_plans_mission_magic",
	},
	mission_reward_payloads_per_difficulty = {
		[CHAOTIC_MISSION_DIFFICULTY_TYPES.EASY] = {
			type = "wh3_dlc29_skv_warpstone",
			min_amount = 200,
			max_amount = 300
		},
		[CHAOTIC_MISSION_DIFFICULTY_TYPES.MEDIUM] = {
			type = "wh3_dlc29_skv_warpstone",
			min_amount = 400,
			max_amount = 600
		},
		[CHAOTIC_MISSION_DIFFICULTY_TYPES.HARD] = {
			type = "wh3_dlc29_skv_warpstone",
			min_amount = 800,
			max_amount = 1200
		},
	},
	number_of_mission_objectives_per_plan_type = {
		[CHAOTIC_PLAN_TYPES.ECONOMIC_PLAN] = {
			min_objectives = 1,
			max_objectives = 2, -- more than 2 will not show on the text for now
		},
		[CHAOTIC_PLAN_TYPES.MAGIC_PLAN] = {
			min_objectives = 1,
			max_objectives = 2,-- more than 2 will not show on the text for now
		},
		[CHAOTIC_PLAN_TYPES. MILITARY_PLAN] = {
			min_objectives = 1,
			max_objectives = 1,-- more than 2 will not show on the text for now
		},
		[CHAOTIC_PLAN_TYPES.ANY] = {
			min_objectives = 1,
			max_objectives = 1,-- more than 2 will not show on the text for now
		},
	},
	mission_issuer = "CLAN_ELDERS",
	mission_plan_types = {
		CHAOTIC_PLAN_TYPES.ECONOMIC_PLAN,
		--CHAOTIC_PLAN_TYPES.MAGIC_PLAN,
		CHAOTIC_PLAN_TYPES.MILITARY_PLAN,
		CHAOTIC_PLAN_TYPES.ANY,
	},
	mission_difficulty_types = {
		CHAOTIC_MISSION_DIFFICULTY_TYPES.EASY,
		CHAOTIC_MISSION_DIFFICULTY_TYPES.MEDIUM,
		CHAOTIC_MISSION_DIFFICULTY_TYPES.HARD,
	},
	token_amount_objectives_per_difficulty = {
		[CHAOTIC_MISSION_DIFFICULTY_TYPES.EASY] = {
			min_number_of_tokens = 7,
			max_number_of_tokens = 7,
		},
		[CHAOTIC_MISSION_DIFFICULTY_TYPES.MEDIUM] = {
			min_number_of_tokens = 11,
			max_number_of_tokens = 11,
		},
		[CHAOTIC_MISSION_DIFFICULTY_TYPES.HARD] = {
			min_number_of_tokens = 15,
			max_number_of_tokens = 15,
		},
	},
	military_plan_objectives_per_difficulty = {
		[CHAOTIC_MISSION_DIFFICULTY_TYPES.EASY] = {
			min_number_of_units = 5,
			max_number_of_units = 7,
		},
		[CHAOTIC_MISSION_DIFFICULTY_TYPES.MEDIUM] = {
			min_number_of_units = 10,
			max_number_of_units = 12
		},
		[CHAOTIC_MISSION_DIFFICULTY_TYPES.HARD] = {
			min_number_of_units = 15,
			max_number_of_units = 15
		},

	},
	magic_plan_objectives_per_difficulty = {

		[CHAOTIC_MISSION_DIFFICULTY_TYPES.EASY] = {
			{
				type = "magic_power",
				min_amount = 100,
				max_amount = 100
			},
		},
		[CHAOTIC_MISSION_DIFFICULTY_TYPES.MEDIUM] = {
			{
				type = "magic_power",
				min_amount = 150,
				max_amount = 150
			},
		},
		[CHAOTIC_MISSION_DIFFICULTY_TYPES.HARD] = {
			{
				type = "magic_power",
				min_amount = 200,
				max_amount = 200
			},
		},
	},
	economic_plan_objectives_per_difficulty = {
		[CHAOTIC_MISSION_DIFFICULTY_TYPES.EASY] = {
			{
				type = "treasury",
				min_amount = 2000,
				max_amount = 2000
			},
			{
				type = "warpstone",
				min_amount = 200,
				max_amount = 200
			},
			{
				type = "food",
				min_amount = 20,
				max_amount = 20
			},
		},
		[CHAOTIC_MISSION_DIFFICULTY_TYPES.MEDIUM] = {
			{
				type = "treasury",
				min_amount = 3000,
				max_amount = 3000
			},
			{
				type = "warpstone",
				min_amount = 300,
				max_amount = 300
			},
			{
				type = "food",
				min_amount = 30,
				max_amount = 30
			},
		},
		[CHAOTIC_MISSION_DIFFICULTY_TYPES.HARD] = {
			{
				type = "treasury",
				min_amount = 4000,
				max_amount = 4000
			},
			{
				type = "warpstone",
				min_amount = 400,
				max_amount = 400
			},
			{
				type = "food",
				min_amount = 40,
				max_amount = 40
			},
		},
	},
}




------------------
------DATA--------
------------------
thanquol_chaotic_plans_missions = {}
thanquol_chaotic_plans_missions.config = thanquol_chaotic_plans_missions_config
thanquol_chaotic_plans_active_missions = {}
thanquol_chaotic_plans_active_narrative_missions = {}
------------------
----FUNCTIONS-----
------------------
function thanquol_chaotic_plans_missions:initialise()
	local faction_interface = cm:get_faction(thanquol_chaotic_plans_missions_config.faction_key);
	if faction_interface and faction_interface:is_null_interface() == false and faction_interface:is_human() then
		self:setup_mission_listeners()
		self:setup_chaotic_plan_mission_listeners()
	end
end

--listen to all the mission events so that we can remove the internal mission data
function thanquol_chaotic_plans_missions:setup_mission_listeners()
	
	core:add_listener(
		"Thanquol_MissionSucceeded",
		"MissionSucceeded",
		function(context)
			if context:faction():is_null_interface() == false and context:faction():name() == thanquol_chaotic_plans_missions_config.faction_key then
				return true
			end
		end,
		function(context)
			self:erase_mission_with_key(context:mission():mission_record_key())
			self:erase_narrative_mission_with_key(context:mission():mission_record_key())
		end,
		true
	)

	core:add_listener(
		"Thanquol_MissionFailed",
		"MissionFailed",
		function(context)
			if context:faction():is_null_interface() == false and context:faction():name() == thanquol_chaotic_plans_missions_config.faction_key then
				return true
			end
		end,
		function(context)
			self:erase_mission_with_key(context:mission():mission_record_key())
			self:erase_narrative_mission_with_key(context:mission():mission_record_key())
		end,
		true
	)

	core:add_listener(
		"Thanquol_MissionCancelled",
		"MissionCancelled",
		function(context)
			if context:faction():is_null_interface() == false and context:faction():name() == thanquol_chaotic_plans_missions_config.faction_key then
				return true
			end
		end,
		function(context)
			self:erase_mission_with_key(context:mission():mission_record_key())
			self:erase_narrative_mission_with_key(context:mission():mission_record_key())
		end,
		true
	)
	
	core:add_listener(
		"Thanquol_MissionGenerationFailed",
		"MissionGenerationFailed",
		function(context)
			return true
		end,
		function(context)
			self:erase_mission_with_key(context:mission())
			self:erase_narrative_mission_with_key(context:mission())
		end,
		true
	)
end

--essentially the way this works is that on each turn start we check if we have less than the amount of concurrent missions we've set and if so create the amount missing
function thanquol_chaotic_plans_missions:setup_chaotic_plan_mission_listeners()
	core:add_listener(
		"Thanquol_StartRepeatableMissions",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == thanquol_chaotic_plans_missions_config.faction_key and cm:turn_number() >= thanquol_chaotic_plans_missions_config.missions_initiating_turn
		end,
		function(context)
			if #thanquol_chaotic_plans_active_missions < thanquol_chaotic_plans_missions_config.number_of_concurent_missions then
				local amount_of_missing_missions = thanquol_chaotic_plans_missions_config.number_of_concurent_missions - #thanquol_chaotic_plans_active_missions
				self:create_missions(context:faction(), amount_of_missing_missions)
			end
		end,
		true
	)

	-- this listener is SUPER important as it is repsonsible for handling the mission completion logic
	-- in these missions the objectives dont listen for events to complete them but rather get completed if an event like this gets triggered in the region they are being performed in
	core:add_listener(
		"plan_completed_listener",
		"ChaoticPlanApplyAccumulatedPayloadsEvent",
		function(context)
			return context:plan() and context:was_successful()
		end,
		function(context)
			local plan = context:plan()
			local plan_region = plan:region()
			local payloads_manager = plan:payloads_manager()
			if plan == nil or plan_region == nil then
				return
			end
			for i = 1, #thanquol_chaotic_plans_active_missions do
				local mission_data = thanquol_chaotic_plans_active_missions[i]
				if mission_data.region_key == plan_region:name() then
					local plan_key = plan:type_key()
					if plan_key == mission_data.mission_type then
						if mission_data.mission_type == CHAOTIC_PLAN_TYPES.MILITARY_PLAN then
							local schemer_family_member = context:plan():schemer()
							if schemer_family_member:is_null_interface() == false then
								local schemer_character = schemer_family_member:character()
								if schemer_character:is_null_interface() == false and schemer_character:military_force():unit_list():num_items() >= mission_data.objective.military_objective then
									cm:set_active_mission_status_for_faction(cm:get_faction(thanquol_chaotic_plans_missions_config.faction_key), mission_data.mission_key, "SUCCEEDED")
								end
							end
						elseif mission_data.mission_type == CHAOTIC_PLAN_TYPES.ECONOMIC_PLAN and payloads_manager:is_null_interface() == false then
							self:check_economic_plan_success(payloads_manager, mission_data)
						elseif mission_data.mission_type == CHAOTIC_PLAN_TYPES.MAGIC_PLAN and payloads_manager:is_null_interface() == false then
							self:check_magic_plan_success(payloads_manager, mission_data)
						elseif mission_data.mission_type == CHAOTIC_PLAN_TYPES.ANY then
							if plan:num_of_drawn_tokens() >= mission_data.objective.token_number_objective then
								cm:set_active_mission_status_for_faction(cm:get_faction(thanquol_chaotic_plans_missions_config.faction_key), mission_data.mission_key, "SUCCEEDED")
							end
						end
						return --since missions are unique per region
					end
				end
			end
			--check the narrative missions now
			for i = 1, #thanquol_chaotic_plans_active_narrative_missions do
				local mission_data = thanquol_chaotic_plans_active_narrative_missions[i]
				if mission_data.region_key == plan_region:name() then
					local plan_key = plan:type_key()
					if plan_key == mission_data.mission_type then
						cm:set_active_mission_status_for_faction(cm:get_faction(thanquol_chaotic_plans_missions_config.faction_key), mission_data.mission_key, "SUCCEEDED")
					else
						return --since missions are unique per region
					end
				end
			end
		end,
		true
	)
end

function thanquol_chaotic_plans_missions:check_economic_plan_success(payloads_manager, mission_data)
	for i = 1, #mission_data.objective.economic_objectives do
		local economic_objective = mission_data.objective.economic_objectives[i]
		if economic_objective.type == thanquol_chaotic_plans_missions_config.objective_type_treasury then
			if economic_objective.amount >  payloads_manager:accumulated_resources():total_treasury_change() then
				return
			end
		else
			local resources = payloads_manager:accumulated_resources()
			if resources:absolute_resource_change(economic_objective.type) < economic_objective.amount then
				return
			end
		end
	end
	cm:set_active_mission_status_for_faction(cm:get_faction(thanquol_chaotic_plans_missions_config.faction_key), mission_data.mission_key, "SUCCEEDED")
end

function thanquol_chaotic_plans_missions:check_magic_plan_success(payloads_manager, mission_data)
	for i = 1, #mission_data.objective.magic_objectives do
			local magic_objective = mission_data.objective.magic_objectives[i]
			local resources = payloads_manager:accumulated_resources()
			if resources:absolute_resource_change(magic_objective.type) < magic_objective.amount then
				return
			end
	end
	cm:set_active_mission_status_for_faction(cm:get_faction(thanquol_chaotic_plans_missions_config.faction_key), mission_data.mission_key, "SUCCEEDED")
end

function thanquol_chaotic_plans_missions:erase_mission_with_key(mission_key)
	for i = 1, #thanquol_chaotic_plans_active_missions do
		if mission_key == thanquol_chaotic_plans_active_missions[i].mission_key then
			table.remove(thanquol_chaotic_plans_active_missions, i)
			return
		end
	end
end

function thanquol_chaotic_plans_missions:erase_narrative_mission_with_key(mission_key)
	for i = 1, #thanquol_chaotic_plans_active_narrative_missions do
		if mission_key == thanquol_chaotic_plans_active_narrative_missions[i].mission_key then
			table.remove(thanquol_chaotic_plans_active_narrative_missions, i)
			return
		end
	end
end

function thanquol_chaotic_plans_missions:create_missions(faction, number_of_missions)
	local plans_manager = cm:model():chaotic_plans_manager()
	if faction ~= nil and plans_manager ~= nil then
		local eligible_regions = plans_manager:get_eligible_regions_for_plan_mission(faction)
		if eligible_regions ~= nil then
			local eligible_regions_list_copy = unique_table:region_list_to_unique_table(eligible_regions):to_table()
			for j = 1, number_of_missions do
				local selected_region = cm:random_number(#eligible_regions_list_copy)
				local new_mission_data = {}
				new_mission_data.region_key = eligible_regions_list_copy[selected_region]
				self:select_mission_type(new_mission_data)
				self:create_mission_key(new_mission_data)
				local current_turn =  cm:turn_number()
				if current_turn > thanquol_chaotic_plans_missions_config.missions_initiating_turn then
					self:select_mission_difficulty_type(new_mission_data)
				elseif current_turn ==  thanquol_chaotic_plans_missions_config.missions_initiating_turn then
					new_mission_data.mission_difficulty_type = CHAOTIC_MISSION_DIFFICULTY_TYPES.EASY --make the first 3 missions easy
				else
					return
				end
				self:select_mission_payload_for_difficulty_type(new_mission_data)
				new_mission_data.mission_script_key = thanquol_chaotic_plans_missions_config.mission_script_key
				self:create_new_mission_objectives_data(new_mission_data)
				self:add_mission_to_mission_manager(faction, new_mission_data)
				table.insert(thanquol_chaotic_plans_active_missions, new_mission_data)
				table.remove(eligible_regions_list_copy, selected_region)
			end
		end
	end
end


function thanquol_chaotic_plans_missions:create_narrative_missions(faction, selected_region, mission_plan_type)
	local plans_manager = cm:model():chaotic_plans_manager()
	if faction ~= nil and selected_region:is_null_interface() == false and plans_manager ~= nil then
		local new_mission_data = {}
		new_mission_data.region_key = selected_region:name()
		new_mission_data.mission_type = mission_plan_type --check select_mission_type to see how the current mission types work
		self:create_mission_key(new_mission_data)
		new_mission_data.mission_difficulty_type = CHAOTIC_MISSION_DIFFICULTY_TYPES.EASY -- this is probably not useful for you
		self:select_mission_payload_for_difficulty_type(new_mission_data) -- here you wanna create new logic for the narrative missions
		new_mission_data.mission_script_key = thanquol_chaotic_plans_missions_config.narrative_mission_script_key
		self:create_new_mission_objectives_data(new_mission_data) -- here you wanna create new logic for the narrative missions
		self:add_mission_to_mission_manager(faction, new_mission_data)
		table.insert(thanquol_chaotic_plans_active_narrative_missions, new_mission_data)
	end
end


--select the mission type based on the fact that you cant have more than x amount of concurrent missions of the same type
function thanquol_chaotic_plans_missions:select_mission_type(new_mission_data)
	local existing_missions_of_type = {
		[CHAOTIC_PLAN_TYPES.ANY] = 0,
		[CHAOTIC_PLAN_TYPES.ECONOMIC_PLAN] = 0,
		[CHAOTIC_PLAN_TYPES.MILITARY_PLAN] = 0,
		[CHAOTIC_PLAN_TYPES.MAGIC_PLAN] = 0,
	}
	local available_mission_types = table.copy(thanquol_chaotic_plans_missions_config.mission_plan_types)
	--eliminate maxed out mission types
	for i = 1, #thanquol_chaotic_plans_active_missions do
		local cur_mission_type = thanquol_chaotic_plans_active_missions[i].mission_type
		existing_missions_of_type[cur_mission_type] = existing_missions_of_type[cur_mission_type] + 1
		if existing_missions_of_type[cur_mission_type] >= thanquol_chaotic_plans_missions_config.max_allowed_concurrent_missions_of_same_type then
			for j = 1, #available_mission_types do
				if available_mission_types[j] == cur_mission_type then
					table.remove(available_mission_types, j)
					break
				end
			end
		end
	end
	local selected_plan_type = cm:random_number(#available_mission_types)
	new_mission_data.mission_type = available_mission_types[selected_plan_type]
end

--create the mission key based on the fact that each mission must have a unique key to the manager. If you want more than 2 concurrent missions of the same type you have to make logic here to handle adding a 3
function thanquol_chaotic_plans_missions:create_mission_key(new_mission_data)
	for i = 1, #thanquol_chaotic_plans_active_missions do
		local cur_mission_type = thanquol_chaotic_plans_active_missions[i].mission_type
		if cur_mission_type == new_mission_data.mission_type then
			local found_pos = string.find(thanquol_chaotic_plans_active_missions[i].mission_key, tostring(1))
			if found_pos then
				new_mission_data.mission_key = thanquol_chaotic_plans_missions_config.mission_keys[new_mission_data.mission_type] .. "_" .. tostring(2)
				return
			end
		end
	end
	new_mission_data.mission_key = thanquol_chaotic_plans_missions_config.mission_keys[new_mission_data.mission_type] .. "_" .. tostring(1)
end

--select the difficulty type 
function thanquol_chaotic_plans_missions:select_mission_difficulty_type(new_mission_data)
	local selected_difficulty_index = cm:random_number(#thanquol_chaotic_plans_missions_config.mission_difficulty_types)
	new_mission_data.mission_difficulty_type = thanquol_chaotic_plans_missions_config.mission_difficulty_types[selected_difficulty_index]
end

function thanquol_chaotic_plans_missions:select_mission_payload_for_difficulty_type(new_mission_data)
	local payload_amount = cm:random_number(thanquol_chaotic_plans_missions_config.mission_reward_payloads_per_difficulty[new_mission_data.mission_difficulty_type].max_amount
											, thanquol_chaotic_plans_missions_config.mission_reward_payloads_per_difficulty[new_mission_data.mission_difficulty_type].min_amount)
	new_mission_data.payload = {}
	new_mission_data.payload.type = thanquol_chaotic_plans_missions_config.mission_reward_payloads_per_difficulty[new_mission_data.mission_difficulty_type].type
	new_mission_data.payload.amount = payload_amount - (payload_amount % 10)
end

--create the objectives in the mission data for each plan type (make sure to respect maximum objectives)
function thanquol_chaotic_plans_missions:create_new_mission_objectives_data(new_mission_data)
	local selected_number_of_objectives = cm:random_number(thanquol_chaotic_plans_missions_config.number_of_mission_objectives_per_plan_type[new_mission_data.mission_type].max_objectives
														, thanquol_chaotic_plans_missions_config.number_of_mission_objectives_per_plan_type[new_mission_data.mission_type].min_objectives)
	new_mission_data.objective = {}

	if new_mission_data.mission_type == CHAOTIC_PLAN_TYPES.ANY then
		self:create_universal_plan_objectives(new_mission_data)
	elseif new_mission_data.mission_type == CHAOTIC_PLAN_TYPES.MILITARY_PLAN then
		self:create_military_plan_objectives(new_mission_data)
	elseif new_mission_data.mission_type == CHAOTIC_PLAN_TYPES.ECONOMIC_PLAN then
		self:create_econmic_plan_objectives(new_mission_data, selected_number_of_objectives)
	elseif new_mission_data.mission_type == CHAOTIC_PLAN_TYPES.MAGIC_PLAN then
		self:create_magic_plan_objectives(new_mission_data, selected_number_of_objectives)
	end
end

function thanquol_chaotic_plans_missions:create_econmic_plan_objectives(new_mission_data, number_of_objectives)
	new_mission_data.objective.economic_objectives = {}
	local current_difficulty_objectives = table.copy(thanquol_chaotic_plans_missions_config.economic_plan_objectives_per_difficulty[new_mission_data.mission_difficulty_type])
	for j = 1, number_of_objectives do 
		local selected_economic_resource_index =  cm:random_number(#current_difficulty_objectives)
		local selected_economic_resource_type = current_difficulty_objectives[selected_economic_resource_index]
		local new_objective = {}
		new_objective.type = selected_economic_resource_type.type
		new_objective.amount = cm:random_number(selected_economic_resource_type.max_amount
												, selected_economic_resource_type.min_amount)
		new_objective.amount = new_objective.amount - (new_objective.amount % 10)
		table.insert(new_mission_data.objective.economic_objectives, new_objective)
		table.remove(current_difficulty_objectives, selected_economic_resource_index)
	end
end

function thanquol_chaotic_plans_missions:create_magic_plan_objectives(new_mission_data, number_of_objectives)
	new_mission_data.objective.magic_objectives = {}
	local current_difficulty_objectives = table.copy(thanquol_chaotic_plans_missions_config.magic_plan_objectives_per_difficulty[new_mission_data.mission_difficulty_type])
	for j = 1, number_of_objectives do 
		local selected_magic_resource_index =  cm:random_number(#current_difficulty_objectives)
		local selected_magic_resource_type = current_difficulty_objectives[selected_magic_resource_index]
		local new_objective = {}
		new_objective.type = selected_magic_resource_type.type
		new_objective.amount = cm:random_number(selected_magic_resource_type.max_amount
												, selected_magic_resource_type.min_amount)
		new_objective.amount = new_objective.amount - (new_objective.amount % 10)
		table.insert(new_mission_data.objective.magic_objectives, new_objective)
		table.remove(current_difficulty_objectives, selected_magic_resource_index)
	end
end

function thanquol_chaotic_plans_missions:create_military_plan_objectives(new_mission_data)
	new_mission_data.objective.military_objective = cm:random_number(thanquol_chaotic_plans_missions_config.military_plan_objectives_per_difficulty[new_mission_data.mission_difficulty_type].max_number_of_units
																	, thanquol_chaotic_plans_missions_config.military_plan_objectives_per_difficulty[new_mission_data.mission_difficulty_type].min_number_of_units)
end

function thanquol_chaotic_plans_missions:create_universal_plan_objectives(new_mission_data)
	new_mission_data.objective.token_number_objective = cm:random_number(thanquol_chaotic_plans_missions_config.token_amount_objectives_per_difficulty[new_mission_data.mission_difficulty_type].max_number_of_tokens
																		, thanquol_chaotic_plans_missions_config.token_amount_objectives_per_difficulty[new_mission_data.mission_difficulty_type].min_number_of_tokens)
end

function thanquol_chaotic_plans_missions:add_mission_to_mission_manager(faction, mission_data)
	local objective_override = {}
	objective_override.values = {}
	--make an objective key and add the values in a table to replace them in the override string later
	local objective_key_from_mission = thanquol_chaotic_plans_missions_config.mission_keys[mission_data.mission_type]
	if mission_data.mission_type == CHAOTIC_PLAN_TYPES.MILITARY_PLAN then
		table.insert(objective_override.values, mission_data.objective.military_objective)
		objective_override.key = "mission_text_text_scripted_chaotic_plans_mission_" .. objective_key_from_mission
	elseif mission_data.mission_type == CHAOTIC_PLAN_TYPES.ECONOMIC_PLAN then
		objective_override.key = "mission_text_text_scripted_chaotic_plans_mission_" .. objective_key_from_mission
		for i = 1, #mission_data.objective.economic_objectives do
			local economic_objective = mission_data.objective.economic_objectives[i]
			table.insert(objective_override.values, economic_objective.amount)
			objective_override.key =  objective_override.key .. "_" .. economic_objective.type
		end
	elseif mission_data.mission_type == CHAOTIC_PLAN_TYPES.MAGIC_PLAN then
		objective_override.key = "mission_text_text_scripted_chaotic_plans_mission_" .. objective_key_from_mission
		for i = 1, #mission_data.objective.magic_objectives do
			local magic_objective = mission_data.objective.magic_objectives[i]
			table.insert(objective_override.values, magic_objective.amount)
			objective_override.key =  objective_override.key .. "_" .. magic_objective.type
		end
	elseif mission_data.mission_type == CHAOTIC_PLAN_TYPES.ANY then
		table.insert(objective_override.values, mission_data.objective.token_number_objective)
		objective_override.key = "mission_text_text_scripted_chaotic_plans_mission_" .. objective_key_from_mission

	end
	local mm = mission_manager:new(faction:name(), mission_data.mission_key)

	mm:set_mission_issuer(thanquol_chaotic_plans_missions_config.mission_issuer)
	mm:add_new_objective("SCRIPTED")
	mm:add_condition("script_key " .. mission_data.mission_script_key)
	mm:add_condition("override_text " .. objective_override.key)
	self:setup_mission_payload(mm, mission_data)
	
	mm:set_turn_limit(thanquol_chaotic_plans_missions_config.mission_avialability_in_turns_per_difficulty[mission_data.mission_difficulty_type])
	mm:set_should_whitelist(false)
	mm:trigger()
	--These have to happen after the mission is triggered
	--replace the value for each objective in the translated string
	if #objective_override.values > 1 then
		cm:set_scripted_mission_text(mission_data.mission_key, mission_data.mission_script_key, objective_override.key, objective_override.values[1],  objective_override.values[2])
	else
		cm:set_scripted_mission_text(mission_data.mission_key, mission_data.mission_script_key, objective_override.key, objective_override.values[1])
	end
	
	--add the region as an entity since all missions are reliant on one
	local region = cm:get_region(mission_data.region_key)
	cm:set_scripted_mission_entity_completion_states(mission_data.mission_key, mission_data.mission_script_key, {{region, false}})
end


function thanquol_chaotic_plans_missions:setup_mission_payload(mission_manager, mission_data)
	mission_manager:add_payload("faction_pooled_resource_transaction{resource " .. mission_data.payload.type .. ";factor other;amount " .. tostring(mission_data.payload.amount) .. ";context absolute;}");
end


--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("thanquol_chaotic_plans_active_missions", thanquol_chaotic_plans_active_missions, context)
		cm:save_named_value("thanquol_chaotic_plans_active_narrative_missions", thanquol_chaotic_plans_active_narrative_missions, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			thanquol_chaotic_plans_active_missions = cm:load_named_value("thanquol_chaotic_plans_active_missions", thanquol_chaotic_plans_active_missions, context)
			thanquol_chaotic_plans_active_narrative_missions = cm:load_named_value("thanquol_chaotic_plans_active_narrative_missions", thanquol_chaotic_plans_active_narrative_missions, context)
		end
	end
)