local tomb_king_max_crafted_armies = 25;
local tomb_king_difficulty_modifiers = {
	["HUMAN"] = {
		["easy"] = "wh2_dlc09_tomb_king_difficulty_player_easy",
		["normal"] = "wh2_dlc09_tomb_king_difficulty_player_normal",
		["hard"] = "wh2_dlc09_tomb_king_difficulty_player_hard",
		["very hard"] = "wh2_dlc09_tomb_king_difficulty_player_very_hard",
		["legendary"] = "wh2_dlc09_tomb_king_difficulty_player_legendary"
	},
	["AI"] = {
		["easy"] = "wh2_dlc09_tomb_king_difficulty_AI_easy",
		["normal"] = "wh2_dlc09_tomb_king_difficulty_AI_normal",
		["hard"] = "wh2_dlc09_tomb_king_difficulty_AI_hard",
		["very hard"] = "wh2_dlc09_tomb_king_difficulty_AI_very_hard",
		["legendary"] = "wh2_dlc09_tomb_king_difficulty_AI_legendary"
	},
	-- Faction Specific
	["wh2_dlc09_tmb_the_sentinels"] = "wh2_main_negative_research_speed_50"
};

local book_rogue_armies = {
	["wh2_dlc09_rogue_black_creek_raiders"] = true,
	["wh2_dlc09_rogue_eyes_of_the_jungle"] = true,
	["wh2_dlc09_rogue_dwellers_of_zardok"] = true,
	["wh2_dlc09_rogue_pilgrims_of_myrmidia"] = true
};

function add_tomb_kings_listeners()
	out("#### Adding Tomb Kings Listeners ####");
	-- Tomb King difficulty modifiers
	setup_tomb_king_difficulty_modifiers();

	-- Mortuary Cult army crafting
	core:add_listener(
		"TK_RitualCompletedEvent",
		"RitualCompletedEvent",
		function(context)
			return context:succeeded() and context:ritual():ritual_key() == "wh2_dlc09_ritual_crafting_tmb_army_capacity";
		end,
		function(context)
			tomb_king_dynasty_crafted(context:performing_faction():name());
		end,
		true
	);
	core:add_listener(
		"TK_Books_War",
		"NegativeDiplomaticEvent",
		true,
		function(context) books_of_nagash_war_declared(context) end,
		true
	);
	
	-- Khatep's agent starts with XP
	if cm:is_new_game() then
		cm:add_agent_experience("faction:wh2_dlc09_tmb_exiles_of_nehek,forename:1825567976", 3000);
	end
end

function books_of_nagash_war_declared(context)
	-- Failsafe: If a rogue army ends up in war with an AI faction then we stop it
	-- to prevent the book being lost and becoming unavailable to the player
	local proposer_name = context:proposer():name();
	local recipient_name = context:recipient():name();
	local rogue_book_army_involved = false;
	local other_party_is_human = false;
	local proposer_human = false;
	local rogue_army_key = "";

	if book_rogue_armies[proposer_name] then
		-- Rogue army declared war
		rogue_book_army_involved = true;
		other_party_is_human = context:recipient():is_human();
		
		if other_party_is_human then
			rogue_army_key = proposer_name;
		else
			rogue_army_key = recipient_name;
		end
	elseif book_rogue_armies[recipient_name] then
		-- Someone declared war on a Rogue army
		rogue_book_army_involved = true;
		other_party_is_human = context:proposer():is_human();
		
		if other_party_is_human then
			proposer_human = true;
			rogue_army_key = recipient_name;
		else
			rogue_army_key = proposer_name;
		end
	end
	
	if rogue_book_army_involved == true and other_party_is_human == false then
		cm:force_make_peace(proposer_name, recipient_name);
		cm:force_diplomacy("faction:"..proposer_name, "faction:"..recipient_name, "all", false, false, true);
	elseif rogue_book_army_involved == true and other_party_is_human == true then
		local im = invasion_manager;
		local book_invasion_key = "BOOK_PATROL_"..rogue_army_key;
		out("Player declared war on Book Rogue Army - Releasing that army! ["..book_invasion_key.."]");
		
		local book_invasion = im:get_invasion(book_invasion_key);
		
		if book_invasion ~= nil then
			book_invasion:release();
		end
	end
end

function setup_tomb_king_difficulty_modifiers()
	local faction_list = cm:model():world():faction_list();
	
	for i = 0, faction_list:num_items() - 1 do
		local faction = faction_list:item_at(i);
		
		if faction:culture() == "wh2_dlc09_tmb_tomb_kings" then
			local fac_type = "AI";
			local difficulty_str = cm:get_difficulty(true);
			
			if faction:is_human() then
				fac_type = "HUMAN";
			end
			
			if tomb_king_difficulty_modifiers[faction:name()] ~= nil then
				local difficulty_effect = tomb_king_difficulty_modifiers[faction:name()];
				
				if faction:has_effect_bundle(difficulty_effect) == false then
					cm:apply_effect_bundle(difficulty_effect, faction:name(), 0);
				end
			end
			if tomb_king_difficulty_modifiers[fac_type][difficulty_str] ~= nil and tomb_king_difficulty_modifiers[fac_type][difficulty_str] ~= "" then
				local difficulty_effect = tomb_king_difficulty_modifiers[fac_type][difficulty_str];
				
				if faction:is_quest_battle_faction() == false and faction:has_effect_bundle(difficulty_effect) == false then
					cm:apply_effect_bundle(difficulty_effect, faction:name(), 0);
				end
			end
		end
	end
end

function tomb_king_dynasty_crafted(faction_name)
	local count = cm:get_saved_value(faction_name.."_craft_number") or 1;
	
	if count > tomb_king_max_crafted_armies then
		return;
	end
	
	cm:apply_effect_bundle("wh2_dlc09_ritual_crafting_tmb_army_capacity_"..count, faction_name, 0);
	cm:set_saved_value(faction_name.."_craft_number", count + 1);
end

function tomb_king_army_cap(faction)
	local turn_number = cm:model():turn_number();
	local current, cap = get_tomb_king_army_count(faction);
	local decrease_effect = "wh2_dlc09_decrease_army_cap_";
end

function get_tomb_king_army_count(faction)
	local current = faction:military_force_list():num_items();
	local cap = 1;

	local dynasty_techs = {
		"wh2_dlc09_tech_tmb_dynasty_1",
		"wh2_dlc09_tech_tmb_dynasty_2",
		"wh2_dlc09_tech_tmb_dynasty_3",
		"wh2_dlc09_tech_tmb_dynasty_4",
		"wh2_dlc09_tech_tmb_dynasty_5",
		"wh2_dlc09_tech_tmb_dynasty_6"
	};
	
	for i = 1, #dynasty_techs do
		if faction:has_technology(dynasty_techs[i]) then
			cap = cap + 1;
		end
	end
	
	for i = 1, tomb_king_max_crafted_armies do
		local effect_key = "wh2_dlc09_ritual_crafting_tmb_army_capacity_"..i;
		
		if faction:has_effect_bundle(effect_key) then
			cap = cap + 1;
		end
	end
	
	return current, cap;
end