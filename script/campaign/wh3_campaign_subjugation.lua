subjugation = {
	cultures = {
		["wh_main_grn_greenskins"] = true,
		["wh3_main_ogr_ogre_kingdoms"] = true,
		["wh2_dlc09_tmb_tomb_kings"] = true,
	},
	dilemmas = {
		execute = {
			["wh_dlc08_nor_norsca"] = "wh2_dlc08_nor_confederate_generic",
			["wh_main_grn_greenskins"] = "wh2_main_grn_confederate_wh2_dlc15_grn_generic",
			["wh3_main_ogr_ogre_kingdoms"] = "wh3_dlc26_ogr_confederate_generic",
			["wh2_dlc09_tmb_tomb_kings"] = "wh3_main_tmb_execution"
		},
		no_execute = {
			["wh_dlc08_nor_norsca"] = "wh2_dlc08_nor_confederate_generic_no_execution",
			["wh_main_grn_greenskins"] = "wh2_main_grn_confederate_wh2_dlc15_grn_generic_no_execution",
			["wh3_main_ogr_ogre_kingdoms"] = "wh3_dlc26_ogr_confederate_generic_no_execution",
			["wh2_dlc09_tmb_tomb_kings"] = "wh3_main_tmb_confederate"
		}
	},

	norsca_setup = {
		wound_time = 10,
		norsca_culture = "wh_dlc08_nor_norsca",
	},

	norsca_chaos_dilemmas = {
		execute = {
		["wh_dlc08_nor_norsca"] = "wh3_dlc27_nor_alliance_woc",
		},
		no_execute = {
		["wh_dlc08_nor_norsca"] = "wh3_dlc27_nor_alliance_woc_no_execution",
		}
	},

	chaos_culture = "wh_main_chs_chaos",

	invalid_factions = {
		wh2_dlc13_nor_norsca_invasion = true,
		wh2_main_nor_hung_incursion_def = true,
		wh2_main_nor_hung_incursion_hef = true,
		wh2_main_nor_hung_incursion_lzd = true,
		wh2_main_nor_hung_incursion_skv = true,
		wh_main_nor_norsca_separatists = true,
		wh_main_nor_norsca_separatists_sorcerer_lord = true,
		wh2_dlc13_grn_greenskins_invasion = true,
		wh3_main_ogr_ogre_kingdoms_invasion = true,
		wh2_dlc09_tmb_khemri = true,
		wh2_dlc09_tmb_followers_of_nagash = true,
		wh2_dlc09_tmb_numas = true,
		wh2_dlc09_tmb_the_sentinels = true,
		wh2_dlc09_tmb_rakaph_dynasty = true,
		wh2_dlc09_tmb_dune_kingdoms = true,
		wh2_dlc09_tmb_tombking_qb1 = true,
		wh2_dlc09_tmb_tombking_qb2 = true,
		wh2_dlc09_tmb_tombking_qb3 = true,
		wh2_dlc09_tmb_tombking_qb4 = true,
		wh2_dlc09_tmb_tombking_qb_exiles_of_nehek = true,
		wh2_dlc09_tmb_tombking_qb_followers_of_nagash = true,
		wh2_dlc09_tmb_tombking_qb_khemri = true,
		wh2_dlc09_tmb_tombking_qb_lybaras = true
	}
}

function subjugation:initialise()

	cm:add_immortal_character_defeated_listener(
		"SubjugationBattleComplete",
		function(context)
			for culture, _ in pairs(self.cultures) do
				if cm:pending_battle_cache_culture_is_attacker(culture) and cm:pending_battle_cache_culture_is_defender(culture) then
					return true
				end
			end

			return false
		end,
		function(winner_fm, loser_fm)
			if winner_fm:character_details():faction():culture() == loser_fm:character_details():faction():culture() then
				self:trigger_confederation_dilemma(winner_fm, loser_fm)
			end
		end,
		true
	)

	cm:add_immortal_character_defeated_listener(
		"SubjugationBattleComplete_Norsca",
		function(context)
			return cm:pending_battle_cache_culture_is_attacker(subjugation.norsca_setup.norsca_culture) and cm:pending_battle_cache_culture_is_defender(subjugation.norsca_setup.norsca_culture) 
		end,
		function(winner_fm, loser_fm)
			if winner_fm:character_details():faction():culture() == subjugation.norsca_setup.norsca_culture and loser_fm:character_details():faction():culture() == subjugation.norsca_setup.norsca_culture then
				if loser_fm:character_details():is_unique() then
					self:trigger_norsca_confederation_dilemma(winner_fm, loser_fm, false)
				else
					self:trigger_norsca_confederation_dilemma(winner_fm, loser_fm, true)
				end
			end
		end,
		true
	)

	cm:add_immortal_character_defeated_listener(
		"SubjugationBattleComplete_Norsca_Chaos",
		function(context)
			return cm:pending_battle_cache_culture_is_attacker(subjugation.norsca_setup.norsca_culture) and cm:pending_battle_cache_culture_is_defender(subjugation.chaos_culture)
		end,
		function(winner_fm, loser_fm)
			if winner_fm:character_details():faction():culture() == subjugation.norsca_setup.norsca_culture and loser_fm:character_details():faction():culture() == subjugation.chaos_culture then
				if loser_fm:character_details():is_unique() then
					subjugation:trigger_chaos_lord_dilemma(winner_fm, loser_fm, false)
				else
					subjugation:trigger_chaos_lord_dilemma(winner_fm, loser_fm, true)
				end
			end
		end,
		true
	)
end

function subjugation:trigger_confederation_dilemma(winner_fm, loser_fm)
	local loser_character = loser_fm:character()
	
	if loser_character ~= nil and loser_character:is_null_interface() == false then
		local loser_faction = loser_character:faction()
		local human_factions = cm:get_human_factions()

		-- vassals of player factions are not valid targets
		for i = 1, #human_factions do
			if loser_faction:is_vassal_of(cm:get_faction(human_factions[i])) then
				return
			end
		end
		
		local loser_faction_name = loser_faction:name()

		if self.invalid_factions[loser_faction_name] or loser_faction:is_human() or loser_character:is_faction_leader() == false or self:is_valid_confederation_target(loser_faction) == false then
			-- not a valid confederation target
			return
		end

		local winner_faction = winner_fm:character_details():faction()
		local culture = winner_faction:culture()
		local dilemma = self.dilemmas.execute[culture]

		if loser_faction:can_be_human() then
			dilemma = self.dilemmas.no_execute[culture]
		end

		if winner_faction:is_human() then
			local winner_name = winner_faction:name()
			if merc_contracts and merc_contracts.active_contracts[winner_name] then
				for _, target_faction in pairs(merc_contracts.active_contracts[winner_name].targets) do
					if target_faction == loser_faction_name then
						-- don't launch subjugation dilemma if losing faction was a contract target.
						return false
					end
				end
			end

			cm:trigger_dilemma_with_targets(
				winner_faction:command_queue_index(),
				dilemma,
				loser_faction:command_queue_index(),
				0,
				loser_character:command_queue_index(),
				0,
				0,
				0,
				function()
					core:add_listener(
						"Norsca_Confed_DilemmaChoiceMadeEvent",
						"DilemmaChoiceMadeEvent",
						function(context)
							local dilemma = context:dilemma()

							for _, type in pairs(self.dilemmas) do
								for _, key in pairs(type) do
									if dilemma == key then
										return true
									end
								end
							end

							return false						
						end,
						function(context)
							-- Autosave on ironman.
							if cm:model():manual_saves_disabled() and not cm:is_multiplayer() then
								cm:callback(function() cm:autosave_at_next_opportunity() end, 0.5)
							end

							if context:choice() == 2 then
								-- Execute (only available on execute dilemmas)
								self:execute_lord(loser_fm)
							end
						end,
						false
					)
				end
			)
		else
			cm:force_confederation(winner_faction:name(), loser_faction_name)
		end
	end
end

function subjugation:trigger_military_alliance_dilemma(winner_fm, loser_fm)
	--copy of trigger_confederation_dilemma, but for military alliances
	local loser_character = loser_fm:character()
	
	if loser_character ~= nil and loser_character:is_null_interface() == false then
		local loser_faction = loser_character:faction()
		local human_factions = cm:get_human_factions()

		-- vassals of player factions are not valid targets
		for i = 1, #human_factions do
			if loser_faction:is_vassal_of(cm:get_faction(human_factions[i])) then
				return
			end
		end
		
		local loser_faction_name = loser_faction:name()
		local winner_faction = winner_fm:character_details():faction()
		local winner_culture = winner_faction:culture()
		local loser_culture = loser_faction:culture()
		local dilemma = self.dilemmas_pairs[winner_culture] and self.dilemmas_pairs[winner_culture][loser_culture] or nil
		if not dilemma then
			return
		end

		if winner_faction:is_human() then
			local winner_name = winner_faction:name()
			if merc_contracts and merc_contracts.active_contracts[winner_name] then
				for _, target_faction in pairs(merc_contracts.active_contracts[winner_name].targets) do
					if target_faction == loser_faction_name then
						-- don't launch subjugation dilemma if losing faction was a contract target.
						return false
					end
				end
			end

			cm:trigger_dilemma_with_targets(
				winner_faction:command_queue_index(),
				dilemma,
				loser_faction:command_queue_index(),
				0,
				loser_character:command_queue_index(),
				0,
				0,
				0,
				function()
					core:add_listener(
						"Norsca_Confed_DilemmaChoiceMadeEvent",
						"DilemmaChoiceMadeEvent",
						function(context)
							local dilemma = context:dilemma()

							for _, key in pairs(self.dilemmas_pairs[winner_culture]) do
								if dilemma == key then
									return true
								end
							end

							return false						
						end,
						function(context)
							-- Autosave on ironman.
							if cm:model():manual_saves_disabled() and not cm:is_multiplayer() then
								cm:callback(function() cm:autosave_at_next_opportunity() end, 0.5)
							end

							if context:choice() == 0 then
								-- Execute (only available on execute dilemmas)
								cm:force_alliance(winner_name, loser_faction_name , true)
							end
						end,
						false
					)
				end
			)
		end
	end
end

function subjugation:is_valid_confederation_target(faction_interface)
	if not faction_interface then return false end	
	if faction_interface ~= nil then
		-- Check if WoC Vassal
		local vassal_master = faction_interface:master()

		if not vassal_master:is_null_interface() then
			if vassal_master:subculture() == "wh_main_sc_chs_chaos" then

				return false
			end
		end

		return true
	end

	return false
end

function subjugation:execute_lord(character_fm)
	local character = character_fm:character()
	local faction_name = character:faction():name()
	local character_cqi = character:command_queue_index();

	core:add_listener(
		"SubjugationNewLeader",
		"CharacterBecomesFactionLeader",
		function(context)
			return context:character():faction():name() == faction_name
		end,
		function(context)
			cm:set_character_immortality("character_cqi:"..context:character():command_queue_index(), true)
		end,
		false
	)

	cm:set_character_immortality("character_cqi:"..character_cqi, false)
	cm:kill_character(character_cqi, false)
end

function subjugation:wound_lord(character_fm, wound_time)
	local character = character_fm
	local fm_character_cqi = character:family_member():command_queue_index()
	local character_cqi = cm:get_family_member_by_cqi(fm_character_cqi):character():command_queue_index()
	local character_name = cm:get_family_member_by_cqi(fm_character_cqi):character()
	local convalescence_time = math.max(self.norsca_setup.wound_time, character_name:compute_convalesence_time());
	if character and not character:is_null_interface() then
		if character:is_wounded() == false then			
			cm:wound_character(cm:char_lookup_str(character_cqi), convalescence_time);
		elseif character:is_wounded() == true then
			cm:stop_character_convalescing(character_cqi)
			cm:wound_character(cm:char_lookup_str(character_cqi), convalescence_time);
		end
	end
end

function subjugation:trigger_norsca_confederation_dilemma(winner_fm, loser_fm, execute)
	local loser_character = loser_fm:character()
	
	if loser_character ~= nil and loser_character:is_null_interface() == false then
		local loser_faction = loser_character:faction()
		local human_factions = cm:get_human_factions()

		-- vassals of player factions are not valid targets
		for i = 1, #human_factions do
			if loser_faction:is_vassal_of(cm:get_faction(human_factions[i])) then
				return
			end
		end
		
		local loser_faction_name = loser_faction:name()

		if self.invalid_factions[loser_faction_name] or loser_faction:is_human() or loser_character:is_faction_leader() == false or self:is_valid_confederation_target(loser_faction) == false then
			-- not a valid confederation target
			return
		end

		local winner_faction = winner_fm:character_details():faction()
		local culture = winner_faction:culture()
		local dilemma = self.dilemmas.execute["wh_dlc08_nor_norsca"]

		if loser_faction:can_be_human() then
			dilemma = self.dilemmas.no_execute["wh_dlc08_nor_norsca"]
		end

		if winner_faction:is_human() then
			local winner_name = winner_faction:name()
			if merc_contracts and merc_contracts.active_contracts[winner_name] then
				for _, target_faction in pairs(merc_contracts.active_contracts[winner_name].targets) do
					if target_faction == loser_faction_name then
						-- don't launch subjugation dilemma if losing faction was a contract target.
						return false
					end
				end
			end

			cm:trigger_dilemma_with_targets(
				winner_faction:command_queue_index(),
				dilemma,
				loser_faction:command_queue_index(),
				0,
				loser_character:command_queue_index(),
				0,
				0,
				0,
				function()
					core:add_listener(
						"Norsca_Confed_DilemmaChoiceMadeEvent",
						"DilemmaChoiceMadeEvent",
						function(context)
							local dilemma = context:dilemma()

							for _, type in pairs(self.dilemmas) do
								for _, key in pairs(type) do
									if dilemma == key then
										return true
									end
								end
							end

							return false						
						end,
						function(context)
							-- Autosave on ironman.
							if cm:model():manual_saves_disabled() and not cm:is_multiplayer() then
								cm:callback(function() cm:autosave_at_next_opportunity() end, 0.5)
							end

							if context:choice() == 2 then
								cm:force_alliance(winner_faction:name(), loser_faction_name, true)								
							end
							
							if context:choice() == 3 then
								if execute == true then
									self:execute_lord(loser_fm) 
								else
									self:wound_lord(loser_character, subjugation.norsca_setup.wound_time);
								end							
							end											
						end,
						false
					)
				end
			)
		else
			cm:force_confederation(winner_faction:name(), loser_faction_name)
		end
	end
end

function subjugation:trigger_chaos_lord_dilemma(winner_fm, loser_fm, execute)
	--copy of trigger_confederation_dilemma, but for military alliances
	local loser_character = loser_fm:character()
	
	if loser_character ~= nil and loser_character:is_null_interface() == false then
		local loser_faction = loser_character:faction()
		local human_factions = cm:get_human_factions()

		-- vassals of player factions are not valid targets
		for i = 1, #human_factions do
			if loser_faction:is_vassal_of(cm:get_faction(human_factions[i])) then
				return
			end
		end


		local loser_faction_name = loser_faction:name()
		local winner_faction = winner_fm:character_details():faction()
		local winner_culture = winner_faction:culture()
		local loser_culture = loser_faction:culture()
		local dilemma = self.norsca_chaos_dilemmas.execute["wh_dlc08_nor_norsca"]

		if loser_faction:can_be_human() then
			dilemma = self.norsca_chaos_dilemmas.no_execute["wh_dlc08_nor_norsca"]
		end

		if winner_faction:is_human() then
			local winner_name = winner_faction:name()
			if merc_contracts and merc_contracts.active_contracts[winner_name] then
				for _, target_faction in pairs(merc_contracts.active_contracts[winner_name].targets) do
					if target_faction == loser_faction_name then
						-- don't launch subjugation dilemma if losing faction was a contract target.
						return false
					end
				end
			end

			cm:trigger_dilemma_with_targets(
				winner_faction:command_queue_index(),
				dilemma,
				loser_faction:command_queue_index(),
				0,
				loser_character:command_queue_index(),
				0,
				0,
				0,
				function()
					core:add_listener(
						"Norsca_Confed_DilemmaChoiceMadeEvent",
						"DilemmaChoiceMadeEvent",
						function(context)
							local dilemma = context:dilemma()
							for _, type in pairs(self.norsca_chaos_dilemmas) do
								for _, key in pairs(type) do
									if dilemma == key then
										return true
									end
								end
							end
							return false						
						end,
						function(context)
							-- Autosave on ironman.
							if cm:model():manual_saves_disabled() and not cm:is_multiplayer() then
								cm:callback(function() cm:autosave_at_next_opportunity() end, 0.5)
							end

							if context:choice() == 0 then
								if execute == true then
									self:execute_lord(loser_fm)
								else
									self:wound_lord(loser_character, subjugation.norsca_setup.wound_time);
								end
							end
						end,
						false
					)
				end
			)
		end
	end
end