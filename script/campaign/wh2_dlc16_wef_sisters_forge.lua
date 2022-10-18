local m_sisters_faction_key = "wh2_dlc16_wef_sisters_of_twilight"
local m_favour_on_cooldown = false

local m_forge_items = {
    -- item_table_keys
    "dragon_cuirass",
    "eagle_vambraces",
    "dreaming_boots",
    "twilight_helm",
    "dragon_pendant",
    "dreaming_cloak",
    "eagle_quiver",
    "twilight_standard",
    "dragon_mask",
    "dreaming_ring",
    "eagle_mask",
    "twilight_horn",
    "dragon_spear",
    "dreaming_bow",
    "eagle_bow",
    "twilight_spear",

    -- level 0 = unowned
    ["dragon_cuirass"] =	{level = 0, upgrade_level = 0, type = "armour",			key = "wh2_dlc16_anc_armour_dragon_cuirass_",				reforge_timer = 0},
    ["eagle_vambraces"] =	{level = 0, upgrade_level = 0, type = "armour",			key = "wh2_dlc16_anc_armour_eagle_vambraces_",				reforge_timer = 0},
    ["dreaming_boots"] =	{level = 0, upgrade_level = 0, type = "armour",			key = "wh2_dlc16_anc_armour_dreaming_boots_",				reforge_timer = 0},
    ["twilight_helm"] =		{level = 0, upgrade_level = 0, type = "armour",			key = "wh2_dlc16_anc_armour_twilight_helm_",				reforge_timer = 0},

    ["dragon_pendant"] =	{level = 0, upgrade_level = 0, type = "enchanted_item",	key = "wh2_dlc16_anc_enchanted_item_dragon_pendant_",		reforge_timer = 0},
    ["dreaming_cloak"] =	{level = 0, upgrade_level = 0, type = "enchanted_item",	key = "wh2_dlc16_anc_enchanted_item_dreaming_cloak_",		reforge_timer = 0},
    ["eagle_quiver"] =		{level = 0, upgrade_level = 0, type = "enchanted_item",	key = "wh2_dlc16_anc_enchanted_item_eagle_quiver_",			reforge_timer = 0},
    ["twilight_standard"] =	{level = 0, upgrade_level = 0, type = "enchanted_item",	key = "wh2_dlc16_anc_enchanted_item_twilight_standard_",	reforge_timer = 0},

    ["dragon_mask"] =		{level = 0, upgrade_level = 0, type = "talisman",		key = "wh2_dlc16_anc_talisman_dragon_mask_",				reforge_timer = 0},
    ["dreaming_ring"] =		{level = 0, upgrade_level = 0, type = "talisman",		key = "wh2_dlc16_anc_talisman_dreaming_ring_",				reforge_timer = 0},
    ["eagle_mask"] =		{level = 0, upgrade_level = 0, type = "talisman",		key = "wh2_dlc16_anc_talisman_eagle_mask_",					reforge_timer = 0},
    ["twilight_horn"] =		{level = 0, upgrade_level = 0, type = "talisman",		key = "wh2_dlc16_anc_talisman_twilight_horn_",				reforge_timer = 0},

    ["dragon_spear"] =		{level = 0, upgrade_level = 0, type = "weapon",			key = "wh2_dlc16_anc_weapon_dragon_spear_",					reforge_timer = 0},
    ["dreaming_bow"] =		{level = 0, upgrade_level = 0, type = "weapon",			key = "wh2_dlc16_anc_weapon_dreaming_bow_",					reforge_timer = 0},
    ["eagle_bow"] =			{level = 0, upgrade_level = 0, type = "weapon",			key = "wh2_dlc16_anc_weapon_eagle_bow_",					reforge_timer = 0},
    ["twilight_spear"] =	{level = 0, upgrade_level = 0, type = "weapon",			key = "wh2_dlc16_anc_weapon_twilight_spear_",				reforge_timer = 0}
}

local m_script_contexts = { --These control which of the 4 item sets the AI will go for
	"cai_faction_script_context_alpha", --dragon
	"cai_faction_script_context_beta",  --dreaming
	"cai_faction_script_context_delta", --eagle
	"cai_faction_script_context_gamma"  --twilight
};

local m_script_context_chosen = "cai_faction_script_context_alpha" --Default to this one in case something goes wrong later on

local function update_reforge_icons()
    -- Items need to be cleared each time, then sorted based on remaining cooldown so they display in a consistent order.
    if cm:get_faction(m_sisters_faction_key):is_human() == true and cm:get_local_faction(true) == m_sisters_faction_key then --This is to prevent UI errors flooding the console when the AI uses the feature
		local temp = {}
		
		for k, v in ipairs(m_forge_items) do
			local val = m_forge_items[v]
			
			if(val.reforge_timer > 0) then
				local temp_values = {v, val.reforge_timer}
				table.insert(temp, temp_values)
			end
		end
	
		-- Sorts temp based off the remaining forge timer of each item.
		table.sort(
			temp, 
			function(a, b)
				return a[2] < b[2]
			end
		)
	
		local uic_forge_button = UIComponent(core:get_ui_root():Find("forge_of_daith"))
		if uic_forge_button then
			uic_forge_button:InterfaceFunction("ClearItems")
		
			for k, v in ipairs(temp) do
				local table_key = v[1]
				local item_key = m_forge_items[table_key].key..m_forge_items[table_key].level
				local reforge_timer = m_forge_items[table_key].reforge_timer
			
				uic_forge_button:InterfaceFunction("AddItem", item_key, reforge_timer)
			end
		end
	end
end

local function add_daiths_favour()
	m_favour_on_cooldown = true
	
	local amount = 1
	local bonus_value = cm:get_faction(m_sisters_faction_key):bonus_values():scripted_value("increase_daiths_favour_chance", "value")
	
	if bonus_value > 0 and cm:random_number(100) <= bonus_value then
		amount = 2
	end
	
	cm:faction_add_pooled_resource(m_sisters_faction_key, "wef_forge_daiths_favour", "battles", amount)
end

local function remove_forge_item(item_key)
    -- remove item from faction/character, if removed from a character it returns that character's script interface
    local character_with_item = false
	local faction = cm:get_faction(m_sisters_faction_key)
    local character_list = faction:character_list()
	
    for i = 0, character_list:num_items() - 1 do
		local current_character = character_list:item_at(i)
		
		if current_character:has_ancillary(item_key) then
			character_with_item = current_character
            break
        end
    end
	
	cm:force_remove_ancillary_from_faction(faction, item_key)
	
	return character_with_item
end

local function replace_forge_item(item_key, new_item_key)
    -- removes an item, and replaces it back onto the character it was on, or back to the item pool if unequipped.
	local character = remove_forge_item(item_key)
	
	-- remove the version of the item that was added from the dilemma.
	remove_forge_item(new_item_key)

	if character and not character:is_wounded() then
        cm:force_add_ancillary(character, new_item_key, false, true)
	else
        cm:add_ancillary_to_faction(cm:get_faction(m_sisters_faction_key), new_item_key, true)
    end
end

local function upgrade_forge_item(item_table_id)
    local item = m_forge_items[item_table_id]
	
    if item.level <= 2 then
        replace_forge_item(item.key .. item.level, item.key .. (item.level + 1))
		item.level = item.level + 1
		item.upgrade_level = item.level
    end
end

function add_sisters_forge_listeners()
	local function sisters_won_battle(character)
		return character:won_battle() and character:faction():name() == m_sisters_faction_key and character:is_faction_leader() and not m_favour_on_cooldown
	end
	
	if cm:is_new_game() == true then		-- Picks one of the 4 AI script contexts randomly at the start of the game
		if cm:get_faction(m_sisters_faction_key):is_human() == false then 
			local r_num = cm:random_number(#m_script_contexts);
			m_script_context_chosen = m_script_contexts[r_num];
		end
	end
	cm:cai_set_faction_script_context(m_sisters_faction_key, m_script_context_chosen);
	out.design("============== This faction: "..m_sisters_faction_key.." is now using this context: "..cm:cai_get_faction_script_context(m_sisters_faction_key).." ==============")
	
	update_reforge_icons()
	
	core:add_listener(
		"Sisters_BattleFavourGain",
		"CharacterCompletedBattle",
		function(context)
			return sisters_won_battle(context:character())
		end,
		function()
			add_daiths_favour()
		end,
		true
	)
	
	core:add_listener(
		"Sisters_ReinforcementFavourGain",
		"CharacterParticipatedAsSecondaryGeneralInBattle",
		function(context)
			return sisters_won_battle(context:character())
		end,
		function()
			add_daiths_favour()
		end,
		true
	)
	
	core:add_listener(
		"Sisters_ForgeRitualCompleted",
		"RitualCompletedEvent",
		function(context)
			return context:ritual():ritual_key():starts_with("wh2_dlc16_ritual_wef_forge")
		end,
		function(context)
			local ritual_key = context:ritual():ritual_key()
			local item_table_key = string.match(ritual_key, "forge_(.*)_level")
			local ritual_level = string.match(ritual_key, "level_(.*)")
			
			cm:callback(
				function()
					if ritual_level == "2" or ritual_level == "3" then
						upgrade_forge_item(item_table_key)
					elseif ritual_level == "4" then
						local item = m_forge_items[item_table_key]
						
						if item.level ~= 4 then
							replace_forge_item(item.key .. item.level, item.key .. "4")
							item.upgrade_level = item.level
							item.level = 4
						end
						
						item.reforge_timer = 5
						
						update_reforge_icons()
					elseif ritual_level == "1" then
						cm:unlock_ritual(cm:get_faction(m_sisters_faction_key), "wh2_dlc16_ritual_wef_forge_" .. item_table_key .. "_level_4", 0)
						m_forge_items[item_table_key].level = 1
					end
				end,
				0.5
			)
		end,
		true
	)
	
	-- Unlock forge at the end of each turn, so that if the sisters are attacked during the turn cycle the forge can be active as the new turn starts.
	core:add_listener(
		"Sisters_FavourGainUnlock",
		"FactionTurnEnd",
		function(context)
			return context:faction():name() == m_sisters_faction_key
		end,
		function()
			m_favour_on_cooldown = false
		end,
		true
	)
	
	core:add_listener(
		"Sisters_ReforgeTimer",
		"FactionTurnStart",
		function(context)
			return context:faction():name() == m_sisters_faction_key
		end,
		function()
			for k, item_table_id in ipairs(m_forge_items) do
				local val = m_forge_items[item_table_id]
				-- checks if item is currently reforged & timed out before removing status
				if(val.reforge_timer > 0) then
					val.reforge_timer = val.reforge_timer - 1
				end
				
				local item = m_forge_items[item_table_id]

				if item.level == 4 and item.reforge_timer == 0 then
					item.level = item.upgrade_level
					replace_forge_item(item.key .. "4", item.key .. item.level)
				end
			end

			update_reforge_icons()
		end,
		true
	)

end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------

cm:add_saving_game_callback(
    function(context)
		cm:save_named_value("sisters_forge_items", m_forge_items, context)
        cm:save_named_value("sisters_current_forge_cooldown", m_favour_on_cooldown, context)
		cm:save_named_value("sisters_script_context", m_script_context_chosen, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
            m_forge_items = cm:load_named_value("sisters_forge_items", m_forge_items, context)
            m_favour_on_cooldown = cm:load_named_value("sisters_current_forge_cooldown", m_favour_on_cooldown, context)
			m_script_context_chosen = cm:load_named_value("sisters_script_context", m_script_context_chosen, context)
		end
	end
)