item_fusing_pairings = {
	{
		item1 = "wh3_main_anc_enchanted_item_scrap",
		item2 = "wh3_main_anc_enchanted_item_scrap",
		result = "wh3_main_anc_enchanted_item_scrap_upgraded"
	},
	{
		item1 = "wh3_main_anc_enchanted_item_scrap_upgraded",
		item2 = "wh3_main_anc_enchanted_item_scrap_upgraded",
		result = "RANDOM_UNIQUE"
	}
};
base_chance_to_fuse_unique_item = 10;
local fuse_fail_item = "wh3_main_anc_enchanted_item_scrap";

function item_fusing_listener()
	core:add_listener(
        "item_fusing_listener",
        "AncillariesFused",
        true,
		function(context)
			local faction = context:faction();
			local item1_key = context:first_ancillary_key();
			local item2_key = context:second_ancillary_key();
			local ancillary_category_key = context:ancillary_category_key();
			local ancillary_uniqueness_group_key = context:ancillary_uniqueness_group_key();

			out("Fusing Ancillaries:");
			out("\tFaction: "..faction:name());
			out("\tAncillary 1: "..item1_key);
			out("\tAncillary 2: "..item2_key);
			out("\tAncillary Category: "..ancillary_category_key);
			out("\tAncillary Uniqueness: "..ancillary_uniqueness_group_key);

			for _, pairing in ipairs(item_fusing_pairings) do
				if (item1_key == pairing.item1 and item2_key == pairing.item2) or (item1_key == pairing.item2 and item2_key == pairing.item1) then
					local item_result = pairing.result;
					out("Fusing Pairing Found: "..item_result);

					if item_result == "RANDOM_UNIQUE" then
						item_result = attempt_drop_rare_item_for_faction(faction);
						out("\tNew Unique: "..item_result);
					else
						cm:add_ancillary_to_faction(faction, item_result, false);
					end

					cm:trigger_ancillary_fused_report(faction, item_result, item1_key, item2_key);
					return true;
				end
			end

			local next_uniqueness = next_rarity_level(ancillary_uniqueness_group_key);
			out("\tNext Uniqueness: "..next_uniqueness);

			if next_uniqueness == "unique" and faction:is_human() == true then
				local fusing_chance = cm:get_factions_bonus_value(faction, "unique_item_fusing_chance");
				fusing_chance = fusing_chance + base_chance_to_fuse_unique_item;
				
				if cm:model():random_percent(fusing_chance) then
					local rare_item = attempt_drop_rare_item_for_faction(faction);
					cm:trigger_ancillary_fused_report(faction, rare_item, item1_key, item2_key);
					out("Fusing Success - "..rare_item);
				else
					cm:add_ancillary_to_faction(faction, fuse_fail_item, false);
					cm:trigger_ancillary_fused_report(faction, fuse_fail_item, item1_key, item2_key);
					out("Fusing Failed, giving scrap: "..fuse_fail_item);
				end
			else
				local new_ancillary = get_random_ancillary_key_for_faction(faction:name(), ancillary_category_key, next_uniqueness);
				cm:add_ancillary_to_faction(faction, new_ancillary, false);
				cm:trigger_ancillary_fused_report(faction, new_ancillary, item1_key, item2_key);
				out("Spawning Ancillary: "..new_ancillary);
			end
        end,
        true
    );
end

function next_rarity_level(rarity)
	if rarity == "wh_main_anc_group_common" then
		return "uncommon";
	elseif rarity == "wh_main_anc_group_uncommon" then
		return "rare";
	elseif rarity == "wh_main_anc_group_rare" then
		return "unique";
	elseif rarity == "wh_main_anc_group_unique" then
		return "unique";
	end
	return "";
end