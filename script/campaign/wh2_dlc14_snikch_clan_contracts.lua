local contract_faction = "wh2_main_skv_clan_eshin";
local contract_clans = {
	{key = "mors", level = 1, last_contract = 0},
	{key = "moulder", level = 1, last_contract = 0},
	{key = "pestilens", level = 1, last_contract = 0},
	{key = "skryre", level = 1, last_contract = 0}
};
local contract_ritual_categories = {
	"ESHIN_MORS_RITUAL",
	"ESHIN_MOULDER_RITUAL",
	"ESHIN_PESTILENS_RITUAL",
	"ESHIN_SKYRE_RITUAL"
}
local contract_council_countdown_start = 3;
local contract_council_countdown_reset = 10; -- The turns between every council meeting
local contract_per_turn_chance = 5;
local contract_timeout_after_issue = 10; -- The turns each contract is active for
local contract_level_2_unlock = 1;
local contract_level_3_unlock = 20;
local contract_level_weights = {50, 40, 30};
local dust_xp_gain = 1200;

function add_clan_contracts_listeners()
	out("#### Adding Clan Contracts Listeners ####");
	
	local contract_council_countdown = cm:get_saved_value("contract_council_countdown") or contract_council_countdown_start;
	common.set_context_value("contract_council_counter", contract_council_countdown);
	
	cm:add_faction_turn_start_listener_by_name(
		"contract_FactionTurnStart",
		contract_faction,
		function(context)
			local faction = context:faction();
			local possible_clans = weighted_list:new();
			local turn_number = cm:model():turn_number();
			local generate_chance = contract_per_turn_chance;
			
			if contract_council_countdown > 1 then
				contract_council_countdown = contract_council_countdown - 1;
			else
				generate_chance = 100;
				contract_council_countdown = contract_council_countdown_reset;
			end
			
			cm:set_saved_value("contract_council_countdown", contract_council_countdown);
			common.set_context_value("contract_council_counter", contract_council_countdown);
			
			for i = 1, #contract_clans do
				local clan = contract_clans[i];
				local reputation = faction:pooled_resource_manager():resource("skv_clan_" .. clan.key);
				
				if not reputation:is_null_interface() then
					local reputation_value = reputation:value();
					
					if clan.level < 2 and reputation_value >= contract_level_2_unlock then
						clan.level = 2;
					end
					
					if clan.level < 3 and reputation_value >= contract_level_3_unlock then
						clan.level = 3;
					end
					
					if turn_number > clan.last_contract then
						if cm:model():random_percent(generate_chance) then
							for j = 1, clan.level do
								for k = 1, #contract_clans do
									if contract_clans[k].key ~= clan.key then
										possible_clans:add_item({clan = clan.key, target = contract_clans[k].key, level = j}, contract_level_weights[j]);
									end
								end
							end
						end
					end
				end
			end
			
			if #possible_clans.items > 0 then
				local contract = possible_clans:weighted_select();
				local ritual_key = "wh2_dlc14_eshin_contracts_" .. contract.clan .. "_" .. contract.target .. "_" .. contract.level;
				
				cm:unlock_ritual(faction, ritual_key, contract_council_countdown_reset);
				cm:trigger_incident(faction:name(), "wh2_dlc14_incident_skv_new_contract_" .. contract.clan, true, true);
				
				for i = 1, #contract_clans do
					if contract.clan == contract_clans[i].key then
						contract_clans[i].last_contract = turn_number + contract_council_countdown_reset;
						break;
					end
				end
			end
		end,
		true
	);
	
	core:add_listener(
		"contract_RitualCompletedEvent",
		"RitualCompletedEvent",
		function(context)
			local ritual_category = context:ritual():ritual_category();
			
			if context:performing_faction():name() == contract_faction then
				for i = 1, #contract_ritual_categories do
					if ritual_category == contract_ritual_categories[i] then
						return true
					end
				end
			end
		end,
		function(context)
			local faction = context:performing_faction();
			
			cm:lock_rituals_in_category(faction, context:ritual():ritual_category());
			
			for i = 1, #contract_clans do
				local clan = contract_clans[i];
				local reputation = faction:pooled_resource_manager():resource("skv_clan_" .. clan.key);
				
				if not reputation:is_null_interface() then
					if reputation:value() > 0 then
						cm:make_diplomacy_available(contract_faction, "wh2_main_skv_clan_" .. clan.key)
					end
				end
			end
		end,
		true
	);
	
	-- Lock all rituals at the start
	if cm:is_new_game() then
		local faction = cm:get_faction(contract_faction);
		
		if faction then
			for i = 1, #contract_ritual_categories do
				cm:lock_rituals_in_category(faction, contract_ritual_categories[i]);
			end
		end
	end
end

-- Debug
function contract(clan1, clan2, level)
	local faction = cm:get_faction(contract_faction)
	
	if faction:is_factions_turn() then
		cm:unlock_ritual(faction, "wh2_dlc14_eshin_contracts_" .. clan1 .. "_" .. clan2 .. "_" .. level, contract_council_countdown_reset);
		cm:trigger_incident(contract_faction, "wh2_dlc14_incident_skv_new_contract_" .. clan1, true, true);
	end
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("contract_clans", contract_clans, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			contract_clans = cm:load_named_value("contract_clans", contract_clans, context);
		end
	end
);