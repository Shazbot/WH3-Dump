-- All current objective types, not all gauenteed to work.
--"CAPTURE_REGIONS",
--"CONSTRUCT_BUILDING",
--"CONSTRUCT_BUILDINGS",
--"CONSTRUCT_N_BUILDINGS_FROM",
--"CONSTRUCT_N_BUILDINGS_INCLUDING",
--"CONSTRUCT_BUILDING_IN_PROVINCES",
--"CONSTRUCT_NO_BUILDINGS_OF_TYPE",
--"ENSURE_FACTIONS_HAVE_NO_MILITARY_PRESENCE",
--"RECRUIT_UNIT",
--"MAKE_ALLIANCE",
--"MAKE_PEACE",
--"BLOCKADE_PORT",
--"RESEARCH_TECHNOLOGY",
--"ASSASSINATE_CHARACTER",
--"ELIMINATE_CHARACTER_IN_BATTLE",
--"MAKE_TRADE_AGREEMENT",
--"END_REBELLION",
--"DECLARE_WAR",
--"ENGAGE_FORCE",
--"BRIBE_FORCE",
--"SABOTAGE_FORCE",
--"DEMORALISE_FORCE",
--"SABOTAGE_BUILDING",
--"RECRUIT_AGENT",
--"LIFT_BLOCKADE",
--"CONVERT_REGION",
--"INCITE_REVOLT",
--"BRIBE_GARRISON",
--"ATTAIN_FACTION_LEVEL",
--"CONTROL_N_REGIONS_INCLUDING",
--"CONTROL_N_PROVINCES_INCLUDING",
--"OWN_N_UNITS",
--"RESEARCH_N_TECHS_OF_TYPE_X",
--"OWN_N_PROVINCES_WITH_CULTURAL_DOMINANCE",
--"MAINTAIN_TRADE_WITH_N_FACTIONS",
--"OWN_AT_LEAST_ONE_SOURCE_OF_EACH_RESOURCE",
--"INCOME_AT_LEAST_X",
--"OWN_N_PORTS_INCLUDING",
--"HOLD_ENTIRETY_OF_N_PROVINCES_INCLUDING",
--"OWN_N_REGIONS_INCLUDING",
--"OWN_A_REGION_IN_N_PROVINCES_INCLUDING",
--"MAKE_CLIENT_STATE_OF_FACTION",
--"BE_AT_WAR_WITH_FACTION",
--"OWN_N_NAVAL_UNITS",
--"CONTROL_N_PORTS_INCLUDING",
--"HAVE_AT_LEAST_X_MONEY",
--"FULLY_OWN_N_SEA_REGIONS",
--"OWN_A_PORT_ADJOINING_SEA_REGIONS_INCLUDING",
--"MAINTAIN_N_CLIENT_STATES",
--"BE_AT_WAR_WITH_N_FACTIONS",
--"MAINTAIN_N_ALLIANCES",
--"CONFEDERATE_FACTIONS",
--"SUBJUGATE_FACTIONS",
--"RAZE_OR_SACK_N_DIFFERENT_SETTLEMENTS_INCLUDING",
--"ACHIEVE_VICTORY",
--"MP_COMPETITIVE",
--"RAISE_FORCE",
--"RAID_REGION",
--"END_CIVIL_WAR",
--"HAVE_N_AGENTS_OF_TYPE",
--"RESEARCH_N_TECHS_INCLUDING",
--"STAY_HORDE",
--"KEEP_ARMY_IN_PROVINCE",
--"EARN_X_AMOUNT_FROM_RAIDING",
--"EARN_X_AMOUNT_FROM_BUILDING_WEALTH",
--"AT_LEAST_X_PUBLIC_ORDER_IN_ALL_PROVINCES",
--"ACHIEVE_GLOBAL_FOOD_SURPLUS",
--"CONSTRUCT_N_OF_A_BUILDING",
--"AT_LEAST_X_PUBLIC_ORDER_IN_PROVINCES",
--"REACH_SPECIFIED_DATE",
--"CONSTRUCT_BUILDING_CHAIN_IN_PROVINCES",
--"CONSTRUCT_N_OF_A_BUILDING_CHAIN",
--"CONSTRUCT_NO_BUILDINGS_OF_CHAIN",
--"LOOT_OR_SACK_N_DIFFERENT_SETTLEMENTS_INCLUDING",
--"GIVE_TRIBUTE",
--"DEMAND_TRIBUTE",
--"ABANDON_N_REGIONS_INCLUDING",
--"FIGHT_SET_PIECE_BATTLE",
--"DEPLOY_N_AGENTS_TO_REGIONS",
--"RECRUIT_N_UNITS_FROM",
--"HAVE_N_UNITS_IN_ARMY",
--"DEPLOY_X_AGENTS_TO_Y_REGIONS_OWNED_BY_Z",
--"DEPLOY_AGENT_TYPE_IN_PROVINCE",
--"DEFEAT_N_ARMIES_OF_FACTION",
--"ASSASSINATE_X_CHARACTERS",
--"HAVE_RESOURCES",
--"MOVE_TO_REGION",
--"OWN_N_PROVINCES",
--"EMBED_AGENT",
--"ARMY_CONTAINS_N_UNITS_OF_TYPE",
--"LIBERATE_N_REGIONS_TO_FACTION",
--"TRADE_INCOME_AT_LEAST_X",
--"BLOCKADE_X_SETTLEMENTS",
--"RAID_X_REGIONS",
--"TRIGGER_WAAAGH",
--"LIMIT_FACTION_TO_REGIONS",
--"HAVE_NO_ACTIVE_MISSIONS_OF_CATEGORY",
--"HAVE_CHARACTER_WOUNDED",
--"HINDER_SETTLEMENT",
--"ASSIGN_CHARACTER_TO_OFFICE",
--"ACHIEVE_CHARACTER_RANK",
--"COMPLETE_N_MISSIONS_OF_CATEGORY",
--"COMPLETE_N_QUEST_CHAINS",
--"DESTROY_FACTION",
--"RAZE_OR_SACK_N_DIFFERENT_SETTLEMENTS_OF_SUBCULTURE",
--"RAID_SUB_CULTURE",
--"AQUIRE_MISSION_CATEGORY_WEIGHT",
--"ALL_PLAYERS_RAZE_OR_OWN_X_SETTLEMENTS",
--"RAZE_OR_OWN_X_SETTLEMENTS",
--"OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS",
--"MEET_ALL_OTHER_OBJECTIVES_WITHIN_X_TURNS",
--"DO_NOT_ALLY_WITH_X",
--"DO_NOT_LOSE_REGION",
--"RAZE_OR_OWN_SETTLEMENTS",
--"PERFORM_RITUAL",
--"COMPLETE_RITUAL_CHAIN",
--"SCRIPTED",
--"SEARCH_RUINS",
--"AMBUSH_ARMY",
--"DEFEAT_ROGUE_ARMY",
--"ISSUE_PROVINCE_INITIATIVE",
--"KILL_X_ENTITIES",
--"PERFORM_ANY_AGENT_ACTION",
--"CAPTURE_X_BATTLE_CAPTIVES",
--"HAVE_AT_LEAST_X_RITUAL_CURRENCY",
--"MOVE_TO_PROVINCE",
--"HAVE_AT_LEAST_X_INFLUENCE",
--"SIGN_NON_AGGRESSION_PACT",
--"MOVE_X_AGENTS_TO_Y_REGIONS_OWNED_BY_Z",
--"DO_NOT_LOSE_SET_PIECE_BATTLE",
--"CONTROL_N_REGIONS_FROM",
--"HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE",
--"KILL_CHARACTER_BY_ANY_MEANS",
--"HAVE_CHARACTER_WITHIN_RANGE_OF_POSITION",
--"VASSALS_OWN_BUILDINGS",
--"__DEPRECATED__AT_LEAST_X_RELIGION_IN_PROVINCES"



CAMPAIGN_MISSION = {}

local unique_mission_id = 0

local function get_effect_bundle_payload_string(effect_bundle, duration)
	-- Set a duration of 0 for infinite duration (effect bundle can be removed manually)
	return "effect_bundle{bundle_key "..effect_bundle..";turns "..duration..";}"
end

local function set_mission_payloads(faction_key, mission_manager, mission_key, rewards_table)
	for _, payload in ipairs(rewards_table) do
		if(payload.type == "effect_bundle") then
			local effect_bundle_string = get_effect_bundle_payload_string(payload.key, payload.duration)
			mission_manager:add_payload(effect_bundle_string)
		elseif(payload.type == "money") then
			mission_manager:add_payload("money "..tostring(payload.amount))
		elseif(payload.type == "influence") then
			mission_manager:add_payload("influence "..tostring(payload.amount))
		elseif(payload.type == "text_display") then
			mission_manager:add_payload("text_display "..payload.key)
		elseif(payload.type == "slaves") then
			mission_manager:add_payload("faction_slaves_change "..tostring(payload.amount))
		elseif(payload.type == "ancillary") then
			mission_manager:add_payload("add_ancillary_to_faction_pool{ancillary_key "..payload.key..";}")
		elseif(payload.type == "pooled_resource") then
			mission_manager:add_payload("faction_pooled_resource_transaction{resource "..payload.key..";factor "..payload.factor..";amount "..payload.amount..";context absolute;}")
		end
	end
end

local function set_payload_dilemma_option_listener(faction_key, dilemma_key, choice_table)
	core:add_listener(
		"campaign_mission_dilemma_option",
		"DilemmaChoiceMadeEvent",
		function(context)
			local dilemma_key = context:dilemma()
			return context:dilemma() == dilemma_key
		end,
		function(context)
			-- we do choice - 1 as choice() counts from 0+ but it's more streamlined to feed 1+ into this function
			for choice, payload in ipairs(choice_table) do
				-- if an option has no payloads, or the payloads are handled from the db set that entry as false/nil, make sure to include to the correct number of choices in the table though in the correct order.
				if context:choice() == choice - 1 then 
					if payload.type == "confederation" then
						cm:force_confederation(faction_key, payload.target_faction)
					elseif(payload.type == "god_favour") then
						Add_God_Favour(faction_key, payload.god_key, payload.amount, payload.amount_others)
					end
				end
			end	
		end,
		false
	)
end

local function set_mission_payload_callbacks(faction_key, mission_key, rewards_table)
	-- this function triggers the rewards which need to be handled by callbacks rather than the "add_payload" function
	-- using these types of payloads (callbacks) will make the mission persistent, meaning it will need to be declared from root rather than dynamically or it won't save/load properly.
	for _, payload in ipairs(rewards_table) do
		if(payload.type == "agent") then
			rite_agent_spawn(faction_key, payload.agent_type, payload.key)
		elseif(payload.type == "dilemma") then
			set_payload_dilemma_option_listener(faction_key, payload.key, payload.choices)
			cm:trigger_dilemma_raw(faction_key, payload.key, true)
		end
	end
end

function CAMPAIGN_MISSION:destroy_faction(faction_key, mission_key, target_faction_key, allow_confederation, rewards_table)
	allow_confederation = allow_confederation or false
	local mm = mission_manager:new(faction_key, mission_key, 
		function()
			set_mission_payload_callbacks(faction_key, mission_key, rewards_table)
		end
	)

	mm:add_new_objective("DESTROY_FACTION")
	mm:add_condition("confederation_valid "..tostring(allow_confederation))
	mm:add_condition("faction "..target_faction_key)
	
	set_mission_payloads(faction_key, mm, mission_key, rewards_table)
	
	return mm
end

function CAMPAIGN_MISSION:control_n_provinces(faction_key, mission_key, no_of_provinces, req_province, rewards_table)
	local mm = mission_manager:new(faction_key, mission_key, 
		function()
			set_mission_payload_callbacks(faction_key, mission_key, rewards_table)
		end
	)

	mm:add_new_objective("CONTROL_N_PROVINCES_INCLUDING")
	mm:add_condition("total "..tostring(no_of_provinces))

	if(is_table(req_province)) then
		for _, rp in ipairs(req_province) do
			mm:add_condition("province "..rp)
		end
	elseif(is_string(req_province)) then
		mm:add_condition("province "..req_province)
	end

	set_mission_payloads(faction_key, mm, mission_key, rewards_table)

	return mm
end

-- This currently doesn't work as intended, control_n_provinces let's you state a lower number of provinces than your required list in order to 
-- say control 3/5 of these provinces etc. This function currently forces you to own them all.
function CAMPAIGN_MISSION:control_n_regions(faction_key, mission_key, no_of_reg, req_reg, rewards_table)
	local mm = mission_manager:new(faction_key, mission_key, 
		function()
			set_mission_payload_callbacks(faction_key, mission_key, rewards_table)
		end
	)
	mm:add_new_objective("CONTROL_N_REGIONS_INCLUDING")
	mm:add_condition("total "..tostring(no_of_reg))

	if(is_table(req_reg)) then
		for _, rr in ipairs(req_reg) do
			mm:add_condition("region "..rr)
		end
	elseif(is_string(req_reg)) then
		mm:add_condition("region "..req_reg)
	end

	set_mission_payloads(faction_key, mm, mission_key, rewards_table)

	return mm
end

function CAMPAIGN_MISSION:control_region(faction_key, mission_key, region_keys, rewards_table)
	local mm = mission_manager:new(faction_key, mission_key, 
		function()
			set_mission_payload_callbacks(faction_key, mission_key, rewards_table)
		end
	)

	mm:add_new_objective("CAPTURE_REGIONS");

	if(is_table(region_keys)) then
		for _, rk in ipairs(region_keys) do
			mm:add_condition("region "..rk);
		end
	elseif(is_string(region_keys)) then
		mm:add_condition("region "..region_keys);
	end

	set_mission_payloads(faction_key, mm, mission_key, rewards_table)
	
	return mm
end

function CAMPAIGN_MISSION:control_n_ports(faction_key, mission_key, no_of_ports, region_keys, rewards_table)
	local mm = mission_manager:new(faction_key, mission_key, 
		function()
			set_mission_payload_callbacks(faction_key, mission_key, rewards_table)
		end
	)

	mm:add_new_objective("CONTROL_N_PORTS_INCLUDING");
	mm:add_condition("total "..tostring(no_of_ports))

	if(is_table(region_keys)) then
		for _, rk in ipairs(region_keys) do
			mm:add_condition("region "..rk);
		end
	elseif(is_string(region_keys)) then
		mm:add_condition("region "..region_keys);
	end

	set_mission_payloads(faction_key, mm, mission_key, rewards_table)
	
	return mm
end

function CAMPAIGN_MISSION:move_to_province(faction_key, mission_key, province_key, rewards_table)
	local mm = mission_manager:new(faction_key, mission_key, 
		function()
			set_mission_payload_callbacks(faction_key, mission_key, rewards_table)
		end
	)

	mm:add_new_objective("MOVE_TO_PROVINCE");

	if(is_string(province_key)) then
		mm:add_condition("province "..province_key)
	end

	set_mission_payloads(faction_key, mm, mission_key, rewards_table)
	
	return mm
end

function CAMPAIGN_MISSION:peform_ritual(faction_key, mission_key, ritual_key, ritual_category_key, ritual_count, rewards_table)
	local mm = mission_manager:new(faction_key, mission_key, 
		function()
			set_mission_payload_callbacks(faction_key, mission_key, rewards_table)
		end
	)

	mm:add_new_objective("PERFORM_RITUAL")

	if(is_string(ritual_key)) then
		mm:add_condition("ritual "..ritual_key)
	elseif(is_string(ritual_category_key)) then
		mm:add_condition("ritual_category "..ritual_category_key)
	else
		out.design("CAMPAIGN_MISSION:peform_ritual called, but no valid ritual or ritual category keys supplied")
	end

	mm:add_condition("total "..ritual_count)

	set_mission_payloads(faction_key, mm, mission_key, rewards_table)

	return mm
end