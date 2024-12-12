chance_per_battle_to_gain_rare_item = 2;
rare_items = {
	{
		item = "wh3_main_anc_armour_helm_of_draesca",
		weight = 5,
		culture_restriction = nil
	},
	{
		item = "wh3_main_anc_enchanted_item_aldreds_casket",
		weight = 5,
		culture_restriction = nil
	},
	{
		item = "wh3_main_anc_enchanted_item_idol_zak_aloooog",
		weight = 5,
		culture_restriction = "wh_main_grn_greenskins"
	},
	{
		item = "wh3_main_anc_enchanted_item_maads_map",
		weight = 5,
		culture_restriction = nil
	},
	{
		item = "wh3_main_anc_weapon_cynatcian",
		weight = 3,
		culture_restriction = nil
	},
	{
		item = "wh3_main_anc_weapon_elthraician",
		weight = 3,
		culture_restriction = nil
	}
};

function load_rare_items()
	core:add_listener(
		"RareItemDropChance",
		"CharacterCompletedBattle",
		function(context)
			local a_char_cqi, a_mf_cqi, a_faction_name = cm:pending_battle_cache_get_attacker(1);
			local d_char_cqi, d_mf_cqi, d_faction_name = cm:pending_battle_cache_get_defender(1);
			
			local attacker = cm:get_faction(a_faction_name);
			local defender = cm:get_faction(d_faction_name);
			
			if (attacker and attacker:is_quest_battle_faction()) or (defender and defender:is_quest_battle_faction()) then
				-- We don't reward random items after quest battles
				return false;
			end

			local character = context:character();
			return character:won_battle() and character:battles_won() > 5;
		end,
		function(context)
			local character = context:character();
			
			if not character:character_type("colonel") and not character:character_subtype("wh_dlc07_brt_green_knight") and not character:character_subtype("wh2_dlc10_hef_shadow_walker") then
				if cm:model():random_percent(chance_per_battle_to_gain_rare_item) then
					local possible_items = weighted_list:new();
					
					for i = 1, #rare_items do
						if cm:model():world():ancillary_exists(rare_items[i].item) == false then -- Rares can only exist once
							if rare_items[i].culture_restriction == nil or character:faction():culture() == rare_items[i].culture_restriction then
								possible_items:add_item(rare_items[i].item, rare_items[i].weight);
							end
						end
					end

					if #possible_items.items > 0 then
						local selected_item, index = possible_items:weighted_select();
						--cm:force_add_ancillary(character, selected_item, false, false);
						cm:add_ancillary_to_faction(character:faction(), selected_item, false);
					end
				end
			end
		end,
		true
	);
end