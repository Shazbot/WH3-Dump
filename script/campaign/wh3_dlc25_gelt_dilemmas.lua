gelt_dilemmas = {
	faction_key = "wh2_dlc13_emp_golden_order",
	ally_faction_key = "wh3_main_cth_the_western_provinces",
	enemy_faction_key = "wh3_main_cth_burning_wind_nomads",
	regions = {
		temple = "wh3_main_combi_region_temple_of_elemental_winds",
		village = "wh3_main_combi_region_village_of_the_tigermen",
		capitol = "wh3_main_combi_region_fu_hung",
		altdorf = "wh3_main_combi_region_altdorf"
	},
	dilemmas = {
		settlement_taken = "wh3_dlc25_emp_gelt_cathay_intro",
		province_taken = "wh3_dlc25_emp_gelt_cathay_province",
		faction_destroyed = "wh3_dlc25_emp_gelt_cathay_enemy_defeated",
		faction_destroyed_alt = "wh3_dlc25_emp_gelt_cathay_enemy_defeated_alt"
	},
	choice_1 = 0,
	choice_2 = 0,
	choice_3 = 0,
	remove_trespass_immunity_turn = 0
}

function gelt_dilemmas:initialise()

	if cm:is_new_game() then
		-- setting the default variables to -1 here rather than at the top so that old gelt saves don't have these dilemmas declared
		self.choice_1 = -1
		self.choice_2 = -1
		self.choice_3 = -1
	end

	-- don't launch dilemmas if a player is Zhao Ming, let them just play their own narrative
	if cm:get_faction(self.faction_key):is_human() and cm:get_faction(self.ally_faction_key):is_human() == false then

		if self.choice_1 < 0 then
			self:setup_intro_dilemma()
		end
		if self.choice_2 < 0 then
			self:setup_middle_dilemma()
		end
		if self.choice_3 < 0 then
			self:setup_final_dilemma()
		end
	end

	self:remove_trepass_immunity()
end

function gelt_dilemmas:setup_intro_dilemma()
	core:add_listener(
		"geltDilemmasIntro",
		"RegionFactionChangeEvent",
		function(context)
			local region = context:region()
			local region_name = region:name()
			local previous_faction_name = context:previous_faction():name()
			local new_owner_name = region:owning_faction():name()
			return previous_faction_name == self.enemy_faction_key and new_owner_name == self.faction_key and (region_name == self.regions.temple or region_name == self.regions.village or region_name == self.regions.capitol)
		end,
		function(context)
			cm:callback(function()
				local player = cm:get_faction(self.faction_key)
				local enemy = cm:get_faction(self.enemy_faction_key)
				local ally = cm:get_faction(self.ally_faction_key)

				if player:at_war_with(ally) == false and enemy:is_dead() == false then
					local faction_cqi = player:command_queue_index()
					local ally_cqi = ally:command_queue_index()
					local ally_faction_leader_cqi = ally:faction_leader():command_queue_index()
					local enemy_cqi = enemy:command_queue_index()

					cm:trigger_dilemma_with_targets(
						faction_cqi,
						self.dilemmas.settlement_taken,
						ally_cqi,
						enemy_cqi,
						ally_faction_leader_cqi,
						0,
						0,
						0,
						function() end
					)

					core:add_listener(
						"emp_DilemmaChoiceMadeEvent",
						"DilemmaChoiceMadeEvent",
						function(context)
							return context:dilemma() == self.dilemmas.settlement_taken
						end,
						function(context) 
							local choice = context:choice()

							self.choice_1 = choice

							if choice == 0 then
								-- handled in data
							elseif choice == 1 then
								cm:add_building_to_settlement(self.regions.temple, "wh_main_emp_settlement_minor_2")
							elseif choice == 2 then
								-- handled in data
							end
						end,
						false
					)
				end
			end, 0.1)
		end,
		false
	)
end

function gelt_dilemmas:setup_middle_dilemma()
	core:add_listener(
		"geltDilemmasMiddle",
		"RegionFactionChangeEvent",
		function(context)
			local temple_owner = cm:get_region(self.regions.temple):owning_faction():name()
			local village_owner = cm:get_region(self.regions.village):owning_faction():name()
			local capitol_owner = cm:get_region(self.regions.capitol):owning_faction():name()
			return temple_owner == self.faction_key and village_owner == self.faction_key and capitol_owner == self.faction_key
		end,
		function(context)
			cm:callback(function()
				local player = cm:get_faction(self.faction_key)
				local enemy = cm:get_faction(self.enemy_faction_key)
				local ally = cm:get_faction(self.ally_faction_key)
	
				if player:at_war_with(ally) == false and enemy:is_dead() == false then
					local faction_cqi = player:command_queue_index()
					local ally_cqi = ally:command_queue_index()
					local ally_faction_leader_cqi = ally:faction_leader():command_queue_index()
					local enemy_cqi = enemy:command_queue_index()
	
					cm:trigger_dilemma_with_targets(
						faction_cqi,
						self.dilemmas.province_taken,
						ally_cqi,
						enemy_cqi,
						ally_faction_leader_cqi,
						0,
						0,
						0,
						function() end
					)
	
					core:add_listener(
						"emp_DilemmaChoiceMadeEvent",
						"DilemmaChoiceMadeEvent",
						function(context)
							return context:dilemma() == self.dilemmas.province_taken
						end,
						function(context) 
							self.choice_2 = context:choice()
						end,
						false
					)
				end
			end, 0.1)
		end,
		false
	)
end

function gelt_dilemmas:setup_final_dilemma()
	core:add_listener(
		"geltDilemmasFinal",
		"FactionDeath",
		function(context)
			local faction = cm:get_faction(self.enemy_faction_key)
			return faction:is_dead()
		end,
		function(context)
			local player = cm:get_faction(self.faction_key)
			local enemy = cm:get_faction(self.enemy_faction_key)
			local ally = cm:get_faction(self.ally_faction_key)

			if player:at_war_with(ally) == false then
				local faction_cqi = player:command_queue_index()
				local ally_cqi = ally:command_queue_index()
				local ally_faction_leader_cqi = ally:faction_leader():command_queue_index()
				local enemy_cqi = enemy:command_queue_index()
				local final_dilemma = self.dilemmas.faction_destroyed

				if self.choice_1 == 2 and self.choice_2 == 2 then
					final_dilemma = self.dilemmas.faction_destroyed_alt
				end

				cm:trigger_dilemma_with_targets(
					faction_cqi,
					final_dilemma,
					ally_cqi,
					enemy_cqi,
					ally_faction_leader_cqi,
					0,
					0,
					0,
					function() end
				)

				core:add_listener(
					"emp_DilemmaChoiceMadeEvent",
					"DilemmaChoiceMadeEvent",
					function(context)
						return context:dilemma() == final_dilemma
					end,
					function(context)
						local choice = context:choice()
						self.choice_3 = choice

						if choice == 0 then
							cm:force_alliance(self.faction_key, self.ally_faction_key, false)
						elseif choice == 2 then
							local gelt_faction = cm:get_faction(self.faction_key)
							local gelt_characters = gelt_faction:character_list()
							local gelt_regions = gelt_faction:region_list()
							local moved_forces = {}

							self:enable_trespass_immunity()
							self.remove_trespass_immunity_turn = cm:turn_number() + 10

							local altdorf_owner = cm:get_region(self.regions.altdorf):owning_faction()
							local spawn_at_altdorf = true
							
							if altdorf_owner:is_human() or altdorf_owner:culture() ~= "wh_main_emp_empire" or altdorf_owner:at_war_with(gelt_faction) then
								spawn_at_altdorf = false
							end

							-- Teleport armies/characters
							for i = 0, gelt_characters:num_items() - 1 do
								local character = gelt_characters:item_at(i)
								local x, y

								if spawn_at_altdorf then
									x, y = cm:find_valid_spawn_location_for_character_from_settlement(self.faction_key, self.regions.altdorf, false, true, 10)
								else
									x, y = cm:find_valid_spawn_location_for_character_from_position(self.faction_key, 436, 723, true, 5)
								end

								if character:has_military_force() then
									local mf = character:military_force()
									local mf_cqi = mf:command_queue_index()
									
									if moved_forces[mf_cqi] ~= true then
										moved_forces[mf_cqi] = true

										cm:heal_military_force(mf)
										cm:teleport_military_force_to(mf, x, y)
									end
								elseif character:is_embedded_in_military_force() == false then
									cm:teleport_to("character_cqi:"..character:command_queue_index(), x, y)
								end

							end

							-- Give all Cathay regions to Zhao Ming
							for i = 0, gelt_regions:num_items() - 1 do
								local region = gelt_regions:item_at(i)
								if region:is_contained_in_region_group("cai_region_hint_area_cathay") then
									cm:transfer_region_to_faction(region:name(), self.ally_faction_key)
								end
							end
						elseif choice == 3 then
							cm:force_declare_war(self.faction_key, self.ally_faction_key, false, true)
						end

						cm:position_camera_at_primary_military_force(self.faction_key)
					end,
					false
				)
			end
		end,
		false
	)
end


function gelt_dilemmas:enable_trespass_immunity()
	local emp_factions = cm:get_factions_by_culture("wh_main_emp_empire")
	local gelt_cqi = cm:get_faction(self.faction_key):command_queue_index()

	for _, faction in ipairs(emp_factions) do
		cm:add_trespass_permission(gelt_cqi, faction:command_queue_index())
	end
	
end

function gelt_dilemmas:remove_trepass_immunity()
	if self.remove_trespass_immunity_turn >= 0  then

		core:add_listener(
			"GeltRemoveTrespassImmune",
			"FactionTurnStart",
			function(context)
				local faction = context:faction()
				local turn_no = cm:turn_number()
				return turn_no > 0 and turn_no >= self.remove_trespass_immunity_turn and faction:is_human() and faction:name() == self.faction_key
			end,
			function(context)
				local emp_factions = cm:get_factions_by_culture("wh_main_emp_empire")
				local gelt_cqi = context:faction():command_queue_index()

				for _, faction in ipairs(emp_factions) do
					cm:remove_trespass_permission(gelt_cqi, faction:command_queue_index())
					self.remove_trespass_immunity_turn = -1
				end
			end,
			false
		)
	end
end


--------------------- SAVE/LOAD ---------------------

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("gelt_dilemmas.choice_1", gelt_dilemmas.choice_1, context)
		cm:save_named_value("gelt_dilemmas.choice_2", gelt_dilemmas.choice_2, context)
		cm:save_named_value("gelt_dilemmas.choice_3", gelt_dilemmas.choice_3, context)
		cm:save_named_value("gelt_dilemmas.remove_trespass_immunity_turn", gelt_dilemmas.remove_trespass_immunity_turn, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			gelt_dilemmas.choice_1 = cm:load_named_value("gelt_dilemmas.choice_1", gelt_dilemmas.choice_1, context)
			gelt_dilemmas.choice_2 = cm:load_named_value("gelt_dilemmas.choice_2", gelt_dilemmas.choice_2, context)
			gelt_dilemmas.choice_3 = cm:load_named_value("gelt_dilemmas.choice_3", gelt_dilemmas.choice_3, context)
			gelt_dilemmas.remove_trespass_immunity_turn = cm:load_named_value("gelt_dilemmas.remove_trespass_immunity_turn", gelt_dilemmas.remove_trespass_immunity_turn, context)
		end
	end
)