local subtype_to_mount_list = {
	["wh2_dlc12_lzd_tlaqua_skink_chief"] = {
		skill = 		"wh2_dlc12_skill_lzd_tlaqua_skink_chief_terradon",
		ancillary =		"wh2_dlc12_anc_mount_lzd_tlaqua_skink_chief_terradon"
	},
	["wh2_dlc12_lzd_tlaqua_skink_priest_beasts"] = {
		skill = 		"wh2_dlc12_skill_lzd_tlaqua_skink_priest_beasts_terradon",
		ancillary =		"wh2_dlc12_anc_mount_lzd_tlaqua_skink_priest_beasts_terradon"
	},
	["wh2_dlc12_lzd_tlaqua_skink_priest_heavens"] = {
		skill = 		"wh2_dlc12_skill_lzd_tlaqua_skink_priest_heavens_terradon",
		ancillary =		"wh2_dlc12_anc_mount_lzd_tlaqua_skink_priest_heavens_terradon"
	},
	["wh2_dlc11_cst_ghost_paladin"] = {
		skill = 		"wh2_dlc11_skill_brt_champion_unique_paladin_damned_barded_warhorse",
		ancillary =		"wh2_dlc11_anc_mount_brt_damned_paladin_barded_warhorse"
	},
	["wh_main_brt_paladin"] = {
		skill = 		"wh_main_skill_brt_champion_unique_paladin_barded_warhorse",
		ancillary =		"wh_main_anc_mount_brt_paladin_barded_warhorse"
	},
	["wh_main_brt_lord"] = {
		skill = 		"wh_main_skill_brt_lord_unique_general_barded_warhorse",
		ancillary =		"wh_main_anc_mount_brt_general_barded_warhorse"
	},
	["wh_dlc07_brt_alberic"] = {
		skill = 		"wh_dlc07_skill_brt_alberic_unique_general_barded_warhorse",
		ancillary =		"wh_dlc07_anc_mount_brt_alberic_barbed_warhorse"
	}
};

function add_mount_upgrade_listeners()
	out("#### Adding Mount Upgrade Listeners ####");
	
	-- listen for a character being created	
	core:add_listener(
		"Faction_MountListener",
		"CharacterCreated",
		function(context)
			local character = context:character();
			local faction = character:faction();
			local culture = faction:culture();
			
			return faction:name() == "wh2_main_lzd_tlaqua" or culture == "wh2_dlc11_cst_vampire_coast" or culture == "wh_main_brt_bretonnia";
		end,
		function(context)
			Faction_AttemptToAddMount(context:character());
		end,
		true
	);
	
	if cm:is_new_game() then
		local faction_list = cm:model():world():faction_list();
		
		for i = 0, faction_list:num_items() - 1 do
			local current_faction = faction_list:item_at(i);
			local current_faction_culture = current_faction:culture();
			
			if current_faction:name() == "wh2_main_lzd_tlaqua" or current_faction_culture == "wh2_dlc11_cst_vampire_coast" or current_faction_culture == "wh_main_brt_bretonnia" then
				local character_list = current_faction:character_list();
				
				for j = 0, character_list:num_items() - 1 do
					Faction_AttemptToAddMount(character_list:item_at(j));
				end;
			end;
		end;
	end;
end;

function Faction_AttemptToAddMount(character)
	local subtype_key = character:character_subtype_key();
	

	if subtype_to_mount_list[subtype_key] and character:character_type_key() ~= "colonel" then
		out("* Faction_AttemptToAddMount is adding skill " .. subtype_to_mount_list[subtype_key].skill .. " and ancillary " .. subtype_to_mount_list[subtype_key].ancillary .. " to character with subtype " .. subtype_key .. ", forename " .. tostring(character:get_forename()) .. ", surname " .. tostring(character:get_surname()) .. ", position [" .. character:logical_position_x() .. ", " .. character:logical_position_y() .. "], faction " .. character:faction():name() .. ", cqi " .. tostring(character:cqi()));
		cm:force_add_skill(cm:char_lookup_str(character), subtype_to_mount_list[subtype_key].skill);
		cm:force_add_ancillary(character, subtype_to_mount_list[subtype_key].ancillary, true, true);
	end;
end;