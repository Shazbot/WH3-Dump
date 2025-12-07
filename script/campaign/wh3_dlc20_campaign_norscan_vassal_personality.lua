

---- Contains various listeners to force-update Norscan factions personalities linked to WoC feature: Norscan Homelands

norscan_homeland = {
	norsca_subculture = "wh_dlc08_sc_nor_norsca",
	warriors_subculture = "wh_main_sc_chs_chaos",
	warriors_faction_set_key = "warriors_factions", -- DB faction set that contains Warriors of Chaos subculture
	norscan_homeland_faction_set_key = "norscan_homeland_factions", -- DB faction set that contains Norscans that have homelands
}

norscan_homeland.personalities = {
	wh3_main_chaos = {
		vassal_personality_key = "wh3_norsca_vassal",
		base_personality_key_default = "wh3_norsca_minor",
		base_personality_key = {}
	},
	wh3_main_combi = {
		vassal_personality_key = "wh3_combi_norsca_vassal",
		base_personality_key_default = "wh3_combi_norsca_minor",
		base_personality_key = {
			["wh3_dlc27_nor_sayl"] = "wh3_combi_norsca_dolgan",
			["wh_dlc08_nor_wintertooth"] = "wh3_combi_norsca_throgg",
			["wh_dlc08_nor_norsca"] = "wh3_combi_norsca_wulfrik",
		}
	},
}


-- Sets up the listeners for Norscan Homelands.
function norscan_homeland:initialise()
	local woc_factions = {}
	local norscan_homeland_factions = {}
	local nor_lookup_table = {}

	woc_factions = cm:model():world():lookup_factions_from_faction_set(self.warriors_faction_set_key)
	norscan_homeland_factions = cm:model():world():lookup_factions_from_faction_set(self.norscan_homeland_faction_set_key)
	for _, faction in model_pairs(norscan_homeland_factions) do
		nor_lookup_table[faction:name()] = true
	end

	-- Check if norscan homeland faction is vassal of WoC faction
	core:add_listener(
		"norscan_vassal_personality_change",
		"FactionBecomesVassal",
		function(context)
			return nor_lookup_table[context:vassal():name()] ~= nil and context:faction():subculture() == self.warriors_subculture
		end,
		function(context)
			self:change_personality(context:vassal():name(), true)
		end,
		true
	)
	
	-- Check if norscan is no longer a vassal
	core:add_listener(
		"norscan_vassal_personality_change_revert",
		"FactionTurnEnd",
		function(context)
			local faction = context:faction()
			local faction_name = faction:name()
			return nor_lookup_table[faction_name] and not faction:is_vassal()
		end,
		function(context)
			local is_vassal = false
			self:change_personality(context:faction():name(), is_vassal)
		end,
		true
	)
end


--- Changes the persionality of the given faction. Personality changed to is based on if is a vassal or not
function norscan_homeland:change_personality(faction_name, is_vassal)
	local campaign_name = cm:model():campaign_name_key()
	if not self.personalities[campaign_name] then
		script_error("ERROR: norscan vassal personalities: no personalities have been setup for the loaded campaign")
		return
	end

	if is_vassal then
		cm:force_change_cai_faction_personality(faction_name, self.personalities[campaign_name].vassal_personality_key)
	else
		local personality_key = self.personalities[campaign_name].base_personality_key[faction_name]
		if not personality_key or personality_key == "" then
			personality_key = self.personalities[campaign_name].base_personality_key_default
		end
		cm:force_change_cai_faction_personality(faction_name, personality_key)
	end
end