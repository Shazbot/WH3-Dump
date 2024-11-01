local m_eltharion_faction_key = "wh2_main_hef_yvresse"
local m_hef_culture = "wh2_main_hef_high_elves"

m_mist_regions = {
	-- regions to apply mist to
	level_1 = {
		"wh3_main_combi_region_tor_yvresse"
	},
	-- northern and southern yvresse
	level_2 = {
		"wh3_main_combi_region_tor_yvresse",
		"wh3_main_combi_region_elessaeli",
		"wh3_main_combi_region_tralinia",
		"wh3_main_combi_region_shrine_of_loec",
		"wh3_main_combi_region_cairn_thel"
	},
	-- outer ring
	level_3 = {
		"wh3_main_combi_region_vauls_anvil_ulthuan",
		"wh3_main_combi_region_tor_sethai",
		"wh3_main_combi_region_avethir",
		"wh3_main_combi_region_whitepeak",
		"wh3_main_combi_region_tor_anroc",
		"wh3_main_combi_region_tor_dranil",
		"wh3_main_combi_region_tor_anlec",
		"wh3_main_combi_region_shrine_of_khaine",
		"wh3_main_combi_region_tor_achare",
		"wh3_main_combi_region_shrine_of_kurnous",
		"wh3_main_combi_region_elisia",
		"wh3_main_combi_region_mistnar",
		"wh3_main_combi_region_tor_koruali",
		"wh3_main_combi_region_tor_yvresse",
		"wh3_main_combi_region_elessaeli",
		"wh3_main_combi_region_tralinia",
		"wh3_main_combi_region_shrine_of_loec",
		"wh3_main_combi_region_cairn_thel"
	}
}

local m_mist_effects = {
	level_1 = "wh2_dlc15_hef_mist_of_yvresse_1",
	level_2 = "wh2_dlc15_hef_mist_of_yvresse_2",
	level_3 = "wh2_dlc15_hef_mist_of_yvresse_3"
}

local function purge_mists_of_yvresse()
	out("wh2_dlc15_eltharion_mist: clearing Mists of Yvresse regional effect bundles")
	
	for i = 1, #m_mist_regions.level_3 do
		local region = cm:get_region(m_mist_regions.level_3[i])
		
		for k, effect in pairs(m_mist_effects) do
			if region:has_effect_bundle(effect) then
				cm:remove_effect_bundle_from_region(effect, m_mist_regions.level_3[i])
			end
		end
	end
end

local function purge_mists_if_dead_listener()
	-- Only start the eltharion-dead-check listener on script start if the faction is not thought to be dead
	core:add_listener(
		"mist_of_yvresse_monitor",
		"FactionTurnStart",
		function()
			return cm:get_faction(m_eltharion_faction_key):is_dead()
		end,
		function()
			-- Purge the mists if Eltharion is dead
			purge_mists_of_yvresse()
			cm:set_saved_value("eltharion_faction_is_dead", true)
		end,
		false
	)
end

local function apply_mists_of_yvresse_effects(region_key)
	-- checks relevant conditions (Mists upgrades and active Rites) and applies the appropriate effect bundles
	local region = cm:get_region(region_key)
	local yvresse_faction = cm:get_faction(m_eltharion_faction_key)
	
	if not region:is_null_interface() and not region:is_abandoned() then
		local owning_faction = region:owning_faction()
		
		if owning_faction:culture() == m_hef_culture and (owning_faction:name() == m_eltharion_faction_key or owning_faction:allied_with(yvresse_faction)) then
			cm:create_storm_for_region(region_key, 1, 1, "hef_mist_storm")
			
			local m_mist_ritual = cm:get_saved_value("m_mist_ritual") or 0
			
			if m_mist_ritual == 3 then
				cm:apply_effect_bundle_to_region(m_mist_effects.level_3, region_key, 0)
			elseif m_mist_ritual == 2 then
				cm:apply_effect_bundle_to_region(m_mist_effects.level_2, region_key, 0)
			elseif m_mist_ritual == 1 then
				cm:apply_effect_bundle_to_region(m_mist_effects.level_1, region_key, 0)
			end
			
			if yvresse_faction:has_effect_bundle("wh2_dlc15_ritual_hef_ladrielle") then
				cm:apply_effect_bundle_to_region("wh2_dlc15_hef_mist_of_yvresse_rite_empowered", region_key, 0)
			elseif region:has_effect_bundle("wh2_dlc15_hef_mist_of_yvresse_rite_empowered") then
				cm:remove_effect_bundle_from_region("wh2_dlc15_hef_mist_of_yvresse_rite_empowered", region_key)
			end
		end
	end
end

local function update_mists_of_yvresse()
	--purge existing mist, then check which regions should be misty and loop through them to apply effects
	purge_mists_of_yvresse()
	
	local yvresse_faction = cm:get_faction(m_eltharion_faction_key)
	local yvresse_defence = yvresse_faction:pooled_resource_manager():resource("yvresse_defence"):value()
	
	out("wh2_dlc15_eltharion_mist: updating Mists of Yvresse regional effect bundles")
	if yvresse_defence >= 25 and yvresse_defence <= 49 then
		core:trigger_event("ScriptEventYvresseDefenceOne")
		
		for i = 1, #m_mist_regions.level_1 do
			local region = m_mist_regions.level_1[i]
			apply_mists_of_yvresse_effects(region)
		end
	elseif yvresse_defence >= 50 and yvresse_defence <= 74 then
		core:trigger_event("ScriptEventYvresseDefenceTwo")
		
		for i = 1, #m_mist_regions.level_2 do
			local region = m_mist_regions.level_2[i]
			apply_mists_of_yvresse_effects(region)
		end
	elseif yvresse_defence >= 75 and yvresse_faction:is_human() then
		core:trigger_event("ScriptEventYvresseDefenceThree")
		
		for i = 1, #m_mist_regions.level_3 do
			local region = m_mist_regions.level_3[i]			
			apply_mists_of_yvresse_effects(region)
		end
	elseif yvresse_defence >= 75 then
		-- AI maintains level 2 bonuses
		for i = 1, #m_mist_regions.level_2 do
			local region = m_mist_regions.level_2[i]			
			apply_mists_of_yvresse_effects(region)
		end
	end
end

function add_eltharion_mist_listeners()
	-- update straight away so mists persist when saving/loading
	update_mists_of_yvresse() 
	
	out("#### Adding Eltharion Mist Listeners ####")
	
	-- Update the mists at the start of Yvresse's turn
	cm:add_faction_turn_start_listener_by_name(
		"mist_of_yvresse_monitor",
		m_eltharion_faction_key,
		function(context)
			if cm:get_saved_value("eltharion_faction_is_dead") then
				-- if the eltharion-is thought to be dead check listener is not running then start it (eltharion's faction has come back to life?)
				cm:set_saved_value("eltharion_faction_is_dead", false)
				purge_mists_if_dead_listener()
			end
			
			update_mists_of_yvresse()
		end,
		true
	)
	
	-- listen for the Rite of Ladrielle/Athel Tamarha rituals and force an update so boosted effects appear immediately, or determine which level of the athel tamarha mist ritual is unlocked
	core:add_listener(
		"mist_ritual_unlock",
		"RitualCompletedEvent",
		function(context)
			local ritual = context:ritual()
			
			return ritual:ritual_key() == "wh2_dlc15_ritual_hef_ladrielle" or ritual:ritual_chain_key() == "wh2_dlc15_athel_tamarha_mist"
		end,
		function(context)
			local ritual = context:ritual():ritual_key()
			
			if ritual == "wh2_dlc15_athel_tamarha_mist_3" then
				cm:set_saved_value("m_mist_ritual", 3)
			elseif ritual == "wh2_dlc15_athel_tamarha_mist_2" then
				cm:set_saved_value("m_mist_ritual", 2)
			elseif ritual == "wh2_dlc15_athel_tamarha_mist_1" then
				cm:set_saved_value("m_mist_ritual", 1)
			end
			
			update_mists_of_yvresse()
		end,
		true
	)
	
	-- Update every time Eltharion occupies/loses a settlement
	core:add_listener(
		"mist_region_captured_update",
		"GarrisonOccupiedEvent",
		function(context)
			return context:garrison_residence():faction():name() == m_eltharion_faction_key or context:character():faction():name() == m_eltharion_faction_key
		end,
		function()
			update_mists_of_yvresse()
		end,
		true
	)
	
	-- update when the Yvresse Defence level increases
	core:add_listener(
		"mist_yvresse_defence_update",
		"PooledResourceEffectChangedEvent",
		function(context) 
			return context:resource():key() == "yvresse_defence"
		end,
		function()
			update_mists_of_yvresse()
		end,
		true
	)
	
	if not cm:get_saved_value("eltharion_faction_is_dead") then
		purge_mists_if_dead_listener()
	end
end