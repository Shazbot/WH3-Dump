function Add_Amber_Listeners()
	out("#### Adding Amber Listeners ####");
	
	--if cm:is_new_game() == true then
		if cm:model():world():faction_exists("wh_dlc05_wef_wood_elves") then 
			AmberUpdateForFaction("wh_dlc05_wef_wood_elves");
		end
		if cm:model():world():faction_exists("wh_dlc05_wef_wood_elves") then 
			AmberUpdateForFaction("wh_dlc05_wef_argwylon");
		end
		if cm:model():world():faction_exists("wh_dlc05_wef_mini_wood_elves") then 
			AmberUpdateForFaction("wh_dlc05_wef_mini_wood_elves");
		end
		if cm:model():world():faction_exists("wh_dlc05_wef_mini_argwylon") then 
			AmberUpdateForFaction("wh_dlc05_wef_mini_argwylon");
		end
	--end
	
	cm:add_faction_turn_start_listener_by_culture(
		"Amber_FactionTurnStart",
		"wh_dlc05_wef_wood_elves",
		function(context)
			Amber_FactionTurnStart(context)
		end,
		true
	);
	
	core:add_listener(
		"Amber_GarrisonOccupiedEvent",
		"GarrisonOccupiedEvent",
		function(context)
			return context:character():faction():is_human();
		end,
		function()
			local human_factions = cm:get_human_factions();
			
			for i = 1, #human_factions do
				local faction = cm:get_faction(human_factions[i]);
				
				if faction:has_effect_bundle("wh_dlc05_occupation_wood_elves_dummy_gain_amber") then
					cm:remove_effect_bundle("wh_dlc05_occupation_wood_elves_dummy_gain_amber", human_factions[i]);
				end;
				
				CalculateAmberFromAllies(faction);
			end;
		end,
		true
	);
	core:add_listener(
		"Amber_PositiveDiplomaticEvent",
		"PositiveDiplomaticEvent",
		true,
		function(context) Amber_PositiveDiplomaticEvent(context) end,
		true
	);
	core:add_listener(
		"Amber_NegativeDiplomaticEvent",
		"NegativeDiplomaticEvent",
		true,
		function(context) Amber_NegativeDiplomaticEvent(context) end,
		true
	);
	core:add_listener(
		"Amber_FactionSubjugatesOtherFaction",
		"FactionSubjugatesOtherFaction",
		true,
		function(context) Amber_FactionSubjugatesOtherFaction(context) end,
		true
	);
	core:add_listener(
		"Amber_FactionJoinsConfederation",
		"FactionJoinsConfederation",
		true,
		function(context) Amber_FactionJoinsConfederation(context) end,
		true
	);
end

function AmberUpdateForFaction(faction_key)
	local faction_obj = cm:model():world():faction_by_key(faction_key);
	CalculateAmberFromAllies(faction_obj);
end

function Amber_FactionTurnStart(context)
	if context:faction():is_human() == false then
		local turn_number = cm:model():turn_number();
		cm:faction_set_food_factor_value(context:faction():name(), "wh_dlc05_amber_regions", (turn_number / 4) + 5);
	else
		CalculateAmberFromAllies(context:faction());
	end
end

function Amber_PositiveDiplomaticEvent(context)
	local proposer = context:proposer();
	local recipient = context:recipient();

	if (proposer:is_human() and proposer:culture() == "wh_dlc05_wef_wood_elves") or (recipient:is_human() and recipient:culture() == "wh_dlc05_wef_wood_elves") then
		if context:is_military_alliance() and not context:is_vassalage() then
			cm:callback(function()
				CalculateAmberFromAllies(proposer);
			end, 1);
		end
	end
end

function Amber_NegativeDiplomaticEvent(context)
	local proposer = context:proposer();
	local recipient = context:recipient();

	if (proposer:is_human() and proposer:culture() == "wh_dlc05_wef_wood_elves") or (recipient:is_human() and recipient:culture() == "wh_dlc05_wef_wood_elves") then
		if context:was_military_alliance() or context:was_vassalage() then
			cm:callback(function()
				CalculateAmberFromAllies(proposer);
				CalculateAmberFromAllies(recipient);
			end, 1);
		end
	end
end

function Amber_FactionSubjugatesOtherFaction(context)
	local faction = cm:model():world():whose_turn_is_it();
	CalculateAmberFromAllies(faction, context:other_faction());
end

function Amber_FactionJoinsConfederation(context)
	if context:confederation():is_null_interface() == false then
		CalculateAmberFromAllies(context:confederation(), context:faction());
	end
end

function CalculateAmberFromAllies(faction, subjugated_faction)
	if faction ~= nil and faction:is_null_interface() == false and faction:culture() == "wh_dlc05_wef_wood_elves" then
		local amber = 0;
		local faction_list = cm:model():world():faction_list();
		
		-- Check all factions, see if they are allied to this faction
		for i = 0, faction_list:num_items() - 1 do
			local current_faction = faction_list:item_at(i);
			
			if current_faction:military_allies_with(faction) or current_faction:is_vassal_of(faction) then
				amber = amber + current_faction:region_list():num_items();
			end
		end
		
		if subjugated_faction ~= nil and subjugated_faction:is_null_interface() == false then
			amber = amber + subjugated_faction:region_list():num_items();
		end
		
		cm:faction_set_food_factor_value(faction:name(), "wh_dlc05_amber_allies", amber);
		
		-- Return the amber amount here for checks that follow this function
		return amber;
	end
	return 0;
end