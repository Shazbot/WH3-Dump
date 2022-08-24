local personality_swaps = {
	{faction = "wh2_main_hef_nagarythe", turn = 25, campaign = "wh2_main_great_vortex", personality = "wh2_highelf_early_major_secondary_easy", difficulties = {"easy", "normal", "hard"}};
	{faction = "wh2_main_hef_nagarythe", turn = 25, campaign = "main_warhammer", personality = "wh2_highelf_early_major_secondary_easy", difficulties = {"easy", "normal", "hard"}};
	{faction = "wh2_main_hef_nagarythe", turn = 25, campaign = "wh2_main_great_vortex", personality = "wh2_highelf_early_major_secondary_hard", difficulties = {"very hard", "legendary"}};
	{faction = "wh2_main_hef_nagarythe", turn = 25, campaign = "main_warhammer", personality = "wh2_highelf_early_major_secondary_hard", difficulties = {"very hard", "legendary"}};
	{faction = "wh2_main_lzd_xlanhuapec", turn = 25, campaign = "wh2_main_great_vortex", personality = "wh2_group_lizardmen_default", difficulties = {"easy", "normal", "hard"}};
	{faction = "wh2_main_lzd_xlanhuapec", turn = 25, campaign = "main_warhammer", personality = "wh2_group_lizardmen_default", difficulties = {"easy", "normal", "hard"}};
	{faction = "wh2_main_lzd_xlanhuapec", turn = 25, campaign = "wh2_main_great_vortex", personality = "wh2_group_lizardmen_default_hard", difficulties = {"very hard", "legendary"}};
	{faction = "wh2_main_lzd_xlanhuapec", turn = 25, campaign = "main_warhammer", personality = "wh2_group_lizardmen_default_hard", difficulties = {"very hard", "legendary"}}
};

-- Difficulties: "easy", "normal", "hard", "very hard", "legendary"

-- build a list of faction keys that may have their personality swapped
local eligible_factions = {};
for i = 1, #personality_swaps do
	eligible_factions[personality_swaps[i].faction] = true
end;

-- start a FactionTurnStart listener for each
for faction_name in pairs(eligible_factions) do
	cm:add_faction_turn_start_listener_by_name(
		"campaign_personality_swap",
		faction_name,
		function(context)
			check_personality_swaps(context)
		end,
		true
	);
end;

function check_personality_swaps(context)
	local faction_key = context:faction():name();
	local turn_number = cm:model():turn_number();
	local difficulty = cm:get_difficulty(true);
	
	for i = 1, #personality_swaps do
		local swap = personality_swaps[i];
	
		if faction_key == swap.faction then
			if turn_number == swap.turn then
				if cm:model():campaign_name(swap.campaign) then
					for j = 1, #swap.difficulties do
						if difficulty == swap.difficulties[j] then
							out("---- Switching personality to "..tostring(swap.personality).." for "..faction_key.." at turn "..turn_number.." on difficulty "..tostring(difficulty));
							cm:force_change_cai_faction_personality(faction_key, swap.personality);
							break;
						end
					end
				end
			end
		end
	end
end