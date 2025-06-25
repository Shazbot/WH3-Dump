chance_per_battle_to_gain_rare_item = 3;
rare_items = {
	{
		item = "wh3_main_anc_armour_helm_of_draesca",
		weight = 5,
		culture_requirement = nil,
		culture_restriction = nil,
		item_restriction = nil
	},
	{
		item = "wh3_main_anc_enchanted_item_aldreds_casket",
		weight = 5,
		culture_requirement = nil,
		culture_restriction = nil,
		item_restriction = nil
	},
	{
		item = "wh3_main_anc_enchanted_item_idol_zak_aloooog",
		weight = 5,
		culture_requirement = "wh_main_grn_greenskins",
		culture_restriction = nil,
		item_restriction = nil
	},
	{
		item = "wh3_main_anc_enchanted_item_maads_map",
		weight = 5,
		culture_requirement = nil,
		culture_restriction = nil,
		item_restriction = nil
	},
	{
		item = "wh3_main_anc_weapon_cynatcian",
		weight = 5,
		culture_requirement = nil,
		culture_restriction = nil,
		item_restriction = nil
	},
	{
		item = "wh3_main_anc_weapon_elthraician",
		weight = 5,
		culture_requirement = nil,
		culture_restriction = nil,
		item_restriction = nil
	},
	{
		item = "wh3_main_anc_armour_accursed_armour",
		weight = 5,
		culture_requirement = nil,
		culture_restriction = nil,
		item_restriction = nil
	},
	{
		item = "wh3_main_anc_armour_briarsheath",
		weight = 5,
		culture_requirement = nil,
		culture_restriction = nil,
		item_restriction = nil
	},
	{
		item = "wh3_main_anc_armour_scintillating_shield",
		weight = 5,
		culture_requirement = nil,
		culture_restriction = nil,
		item_restriction = nil
	},
	{
		item = "wh3_main_anc_weapon_wyrmslayer_sword",
		weight = 5,
		culture_requirement = nil,
		culture_restriction = nil,
		item_restriction = nil
	},
	{
		item = "wh3_main_anc_arcane_item_chalice_of_malfleur",
		weight = 3,
		culture_requirement = nil,
		culture_restriction = nil,
		item_restriction = nil
	},
	{
		item = "wh3_main_anc_enchanted_item_book_of_khorne_1",
		weight = 3,
		culture_requirement = nil,
		culture_restriction = "wh3_main_kho_khorne",
		item_restriction = "wh3_main_anc_enchanted_item_book_of_khorne_1_k"
	},
	{
		item = "wh3_main_anc_enchanted_item_book_of_khorne_1_k",
		weight = 3,
		culture_requirement = "wh3_main_kho_khorne",
		culture_restriction = nil,
		item_restriction = "wh3_main_anc_enchanted_item_book_of_khorne_1"
	},
	{
		item = "wh2_main_anc_weapon_the_fellblade",
		weight = 1,
		culture_requirement = nil,
		culture_restriction = nil,
		item_restriction = nil
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
				return false; -- We don't reward random items after quest battles
			end

			local character = context:character();
			return character:won_battle() and character:faction():is_human();
		end,
		function(context)
			local character = context:character();
			
			if character:character_type("colonel") == false and character:character_subtype("wh_dlc07_brt_green_knight") == false and character:character_subtype("wh2_dlc10_hef_shadow_walker") == false then
				local book_of_khorne_dropped = drop_book_of_khorne(context);

				if book_of_khorne_dropped == false and character:battles_won() > 5 then
					if cm:model():random_percent(chance_per_battle_to_gain_rare_item) then
						attempt_drop_rare_item(character);
					end
				end
			end
		end,
		true
	);

	add_books_of_khorne_listeners();
end

function attempt_drop_rare_item_for_faction(faction)
	local possible_items = weighted_list:new();
	
	for i = 1, #rare_items do
		if cm:model():world():ancillary_exists(rare_items[i].item) == false then -- Rares can only exist once
			if rare_items[i].item_restriction == nil or cm:model():world():ancillary_exists(rare_items[i].item_restriction) == false then -- Make sure the item that may restrict this item doesn't exist
				if rare_items[i].culture_requirement == nil or faction:culture() == rare_items[i].culture_requirement then
					if rare_items[i].culture_restriction == nil or faction:culture() ~= rare_items[i].culture_restriction then
						possible_items:add_item(rare_items[i].item, rare_items[i].weight);
					end
				end
			end
		end
	end

	if #possible_items.items > 0 then
		out("attempt_drop_rare_item_for_faction - "..#possible_items.items);
		local selected_item, index = possible_items:weighted_select();
		cm:add_ancillary_to_faction(faction, selected_item, false);
		return selected_item;
	end
	return "";
end

function attempt_drop_rare_item(character)
	attempt_drop_rare_item_for_faction(character:faction());
end

function add_books_of_khorne_listeners()
	core:add_listener(
		"book_of_khorne_turnstart",
		"CharacterTurnStart",
		function(context)
			local bv = cm:get_characters_bonus_value(context:character(), "book_of_khorne");
			return bv == 4;
		end,
		function(context)
			local character = context:character();
			local faction = character:faction();

			if character:has_ancillary("wh3_main_anc_enchanted_item_book_of_khorne_4") then
				for i = 1, 3 do
					if faction:ancillary_exists("wh3_main_anc_enchanted_item_book_of_khorne_"..i) == false then
						return false;
					end
				end
				for i = 1, 4 do
					cm:force_remove_ancillary_from_faction(faction, "wh3_main_anc_enchanted_item_book_of_khorne_"..i);
				end
				cm:trigger_dilemma(faction:name(), "wh3_main_dilemma_book_of_khorne");
			elseif character:has_ancillary("wh3_main_anc_enchanted_item_book_of_khorne_4_k") then
				for i = 1, 3 do
					if faction:ancillary_exists("wh3_main_anc_enchanted_item_book_of_khorne_"..i.."_k") == false then
						return false;
					end
				end
				for i = 1, 4 do
					cm:force_remove_ancillary_from_faction(faction, "wh3_main_anc_enchanted_item_book_of_khorne_"..i.."_k");
				end
				cm:trigger_dilemma(faction:name(), "wh3_main_dilemma_book_of_khorne_k");
			end
		end,
		true
	);
	core:add_listener(
		"book_of_khorne_raze",
		"CharacterRazedSettlement",
		function(context)
			local bv = cm:get_characters_bonus_value(context:character(), "make_region_unoccupiable_when_razed");
			return bv > 0;
		end,
		function(context)
			local character = context:character();
			local region = context:garrison_residence():region();
			cm:apply_effect_bundle_to_region("wh3_main_book_of_khorne_block_occupation", region:name(), 0);
			cm:remove_effect_bundle_from_region("wh3_dlc26_block_occupation_khorne", region:name());
			cm:remove_effect_bundle_from_region("wh3_dlc26_block_occupation_beastmen", region:name());
		end,
		true
	);
end

book_of_khorne_drop_chance = 50;

function drop_book_of_khorne(context)
	local character = context:character();
	local book_volume_equipped = cm:get_characters_bonus_value(character, "book_of_khorne");

	if book_volume_equipped > 0 and book_volume_equipped < 4 then
		if cm:model():random_percent(book_of_khorne_drop_chance) then
			local next_volume = book_volume_equipped + 1;
			local next_volume_key = "wh3_main_anc_enchanted_item_book_of_khorne_"..next_volume;

			if character:faction():culture() == "wh3_main_kho_khorne" then
				next_volume_key = next_volume_key.."_k";
			end

			if cm:model():world():ancillary_exists(next_volume_key) == false then
				common.ancillary(next_volume_key, 100, context);
			end
			return true;
		end
	end
	return false;
end