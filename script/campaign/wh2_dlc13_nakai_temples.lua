nakai_temples = {
	faction_key = "wh2_dlc13_lzd_spirits_of_the_jungle",
	vassal_key = "wh2_dlc13_lzd_defenders_of_the_great_plan",

	temples = {
		quetzl = {count = 0, completed = false},
		xholankha = {count = 0, completed = false},
		itzl = {count = 0, completed = false},
		"quetzl",
		"xholankha",
		"itzl"
	},

	occupation_ids = {
		["696983577"] = "quetzl",
		["2006277474"] = "itzl",
		["1211561161"] = "xholankha"
	},

	ritual_keys = {
		hunters_gaze = "wh2_dlc13_ritual_temple_itzl_0_hunters_gaze",
		stalward_defenders = "wh2_dlc13_ritual_temple_quetzl_0_stalwart_defenders",
		allegiance = "wh2_dlc13_rituals_lzd_allegiance",
		rebirth = "wh2_dlc13_rituals_lzd_rebirth"
	},

	effect_prefixes = {
		"wh2_dlc13_nakai_temple_quetzl_",
		"wh2_dlc13_nakai_temple_xholankha_",
		"wh2_dlc13_nakai_temple_itzl_"
	},

	force_id = "lzd_rite_spawn",

	defence_army = {
		{unit_key = "wh2_main_lzd_inf_saurus_spearmen_blessed_1", amount = 4},
		{unit_key = "wh2_main_lzd_inf_saurus_warriors_blessed_1", amount = 4},
		{unit_key = "wh2_main_lzd_inf_chameleon_skinks_blessed_0", amount = 4},
		{unit_key = "wh2_main_lzd_cav_horned_ones_blessed_0", amount = 2},
		{unit_key = "wh2_main_lzd_mon_carnosaur_blessed_0", amount = 2},
		{unit_key = "wh2_main_lzd_mon_stegadon_blessed_1", amount = 2},
		{unit_key = "wh2_main_lzd_mon_bastiladon_blessed_2", amount = 1},
	},

	building_prefix = {
		land = "wh2_dlc13_lzd_nakai_",
		port = "wh2_dlc13_lzd_port_nakai_"
	},

	temple_bonus = {
		standard = 1,
		capitol = 3
	}
}

function nakai_temples:nakai_occupation_options()
	core:add_listener(
		"nakai_CharacterPerformsSettlementOccupationDecision",
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			return context:character():faction():name() == self.faction_key
		end,
		function(context)
			local character = context:character()
			
			if character:is_null_interface() == false then
				local occupation_decision = tostring(context:occupation_decision())				
				local temple_key = self.occupation_ids[occupation_decision]

				out("Nakai Temple - ")
				out("\toccupation_decision - "..occupation_decision)
				
				if temple_key then
					local region = context:garrison_residence():region()
					local defenders_faction = cm:get_faction(self.vassal_key)

					out("\ttemple_key - "..temple_key)	
					
					nakai_temples:create_region_temple(region, temple_key)		
					
					if defenders_faction:is_vassal() == false then
						cm:force_make_vassal(self.faction_key, self.vassal_key)
						cm:force_diplomacy("faction:"..self.vassal_key, "all", "all", false, false, false)
						cm:force_diplomacy("faction:"..self.faction_key, "faction:"..self.vassal_key, "war", false, false, true)
						cm:force_diplomacy("faction:"..self.faction_key, "faction:"..self.vassal_key, "break vassal", false, false, true)
						cm:force_diplomacy("faction:"..self.vassal_key, "all", "war", false, true, false)
						cm:force_diplomacy("faction:"..self.vassal_key, "all", "peace", false, true, false)
					end
				end
			end
			
			self:count_defenders_temples()
		end,
		true
	)
end

function nakai_temples:grant_vision_of_vassal_regions()
	local faction = cm:get_faction(self.vassal_key) 

	if faction:is_null_interface() == false and faction:is_dead() == false then
		local region_list = faction:region_list()

		for i = 0, region_list:num_items() - 1 do
			local current_region = region_list:item_at(i)
			local region_key = current_region:name()

			cm:make_region_visible_in_shroud(self.faction_key, region_key)
		end
	end
end



function nakai_temples:spawn_defensive_army()
	local faction = cm:get_faction(self.vassal_key) 

	if faction:is_null_interface() == false and faction:is_dead() == false then
		if faction:has_home_region() then
			local home_region = faction:home_region()

			if home_region:garrison_residence():is_under_siege() then
				local region_list = faction:region_list()

				for i = 0, region_list:num_items() - 1 do
					local current_region = region_list:item_at(i)
					if current_region:garrison_residence():is_under_siege() == false then
						home_region = current_region
						break
					end
				end

				if home_region == faction:home_region() then
					script_error("ERROR: attempted to spawn army for "..self.vassal_key.." but no suitable regions could be found")
				end
			end
			
			local home_key = home_region:name()
			local pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_settlement(self.vassal_key, home_key, false, true, 3)

			if pos_x > -1 then
				local ram = random_army_manager
				ram:remove_force(self.force_id)
				ram:new_force(self.force_id)

				for k, v in ipairs (self.defence_army) do
					ram:add_mandatory_unit(self.force_id, v.unit_key, v.amount)
				end

				local unit_count = random_army_manager:mandatory_unit_count(self.force_id)
				local spawn_units = random_army_manager:generate_force(self.force_id, unit_count, false)

				cm:create_force(self.vassal_key, spawn_units, home_key, pos_x,	pos_y, true,
					function(cqi)
						cm:apply_effect_bundle_to_characters_force("wh2_dlc13_bundle_lzd_defender_army", cqi, 0)
					end
				)
			else
				script_error("ERROR: attempted to spawn army for "..self.vassal_key.." but couldn not find valid coordinates for region: "..home_key)
			end
		end
	else
		script_error("ERROR: attempted to spawn army for "..self.vassal_key.." but faction was dead or didn't exist")
	end
end

function nakai_temples:apply_ritual_effects()
	core:add_listener(
		"nakai_RitualCompletedEvent",
		"RitualCompletedEvent",
		function(context)
			return context:performing_faction():name() == self.faction_key
		end,
		function(context)
			local ritual = context:ritual():ritual_key()
			
			if ritual == self.ritual_keys.hunters_gaze then
				-- Make Vassal Regions Visible
				nakai_temples:grant_vision_of_vassal_regions()
			elseif ritual == self.ritual_keys.stalward_defenders then
				-- Siege holdout and stats when defending in a siege
				cm:apply_effect_bundle(self.ritual_keys.stalward_defenders, self.vassal_key, 5)
			elseif ritual == self.ritual_keys.allegiance then
				-- Apply Attrition effect
				cm:apply_effect_bundle("wh2_dlc13_bundle_lzd_defender_attrition", self.vassal_key, 5)
			elseif ritual == self.ritual_keys.rebirth then
				-- Spawn army for Defenders
				nakai_temples:spawn_defensive_army()
			end
		end,
		true
	)
end

function nakai_temples:add_nakai_temples_listeners()
	out("#### Adding Nakai Temples Listeners ####")

	self:nakai_occupation_options()
	self:apply_ritual_effects()
	
	cm:add_faction_turn_start_listener_by_name(
		"nakai_FactionTurnStart",
		self.faction_key,
		function(context)
			self:count_defenders_temples()

			local faction = context:faction()
			local favour_amount = (self.temples.quetzl.count) + (self.temples.xholankha.count) + (self.temples.itzl.count)
	
			cm:faction_add_pooled_resource(self.faction_key, "lzd_old_ones_favour", "defenders_of_the_great_plan", favour_amount * 2)

			if faction:has_effect_bundle(self.ritual_keys.hunters_gaze) then
				self:grant_vision_of_vassal_regions()
			end
		end,
		true
	)
end

function nakai_temples:create_region_temple(region, temple_key)
	local settlement = region:settlement()
	local slot, temple

	if temple_key == nil then
		local t = {"quetzl", "itzl", "xholankha"}
		local r = cm:random_number(3)

		temple_key = t[r]
	end
	
	cm:instantly_set_settlement_primary_slot_level(settlement, 1)

	if settlement:is_port() then
		slot = settlement:port_slot()
		temple = self.building_prefix.port .. temple_key
	else
		slot = settlement:active_secondary_slots():item_at(0)
		temple = self.building_prefix.land .. temple_key
	end

	cm:region_slot_instantly_upgrade_building(slot, temple)
	cm:callback(function() 
		cm:heal_garrison(region:cqi()) 
	end, 0.5)
end

function nakai_temples:count_defenders_temples()
	local defenders_faction = cm:get_faction(self.vassal_key)
	
	if defenders_faction then
		local region_list = defenders_faction:region_list()
		local nakai_faction = cm:get_faction(self.faction_key)

		self.temples.quetzl.count = 0
		self.temples.xholankha.count = 0
		self.temples.itzl.count = 0
		
		for i = 0, region_list:num_items() - 1 do
			local current_region = region_list:item_at(i)
			local current_settlement = current_region:settlement()
			local temple_bonus = self.temple_bonus.standard

			if current_region:is_province_capital() then
				temple_bonus = self.temple_bonus.capitol
			end
			
			if current_settlement:is_port() then
				local port_slot = current_settlement:port_slot()
				
				if port_slot:has_building() then
					local building_name = port_slot:building():name()
					
					for k, temple_type in ipairs(self.temples) do
						local building_key = self.building_prefix.port..temple_type

						if building_name == building_key then
							self.temples[temple_type].count = self.temples[temple_type].count + temple_bonus
						end
					end
				end
			else
				local active_secondary_slots = current_settlement:active_secondary_slots()
				
				for j = 0, active_secondary_slots:num_items() - 1 do
					local current_slot = active_secondary_slots:item_at(j)
					
					if current_slot:is_null_interface() == false and current_slot:has_building() then
						
						local building_name = current_slot:building():name()
						
						for k, temple_type in ipairs(self.temples) do
							local building_key = self.building_prefix.land..temple_type

							if building_name == building_key then
								self.temples[temple_type].count = self.temples[temple_type].count + temple_bonus
							end
						end
					end
				end
			end
		end

		for k, v in ipairs(self.effect_prefixes) do
			for i = 1, 5 do
				local effect_key = v..i
				if nakai_faction:has_effect_bundle(effect_key) then
					cm:remove_effect_bundle(effect_key, self.faction_key)
				end
			end
		end

		for _, temple_type in ipairs(self.temples) do
			local temple = self.temples[temple_type]
			if(temple.count >= 5) then
				local suffix = 0

				if(temple.count >= 25) then
					suffix = 5

					core:trigger_event("ScriptEventDotGPGodCompleted")
					cm:set_saved_value(temple_type.."_completed", true)
				elseif temple.count >= 20 then
					suffix = 4
				elseif temple.count >= 15 then
					suffix = 3
				elseif temple.count >= 10 then
					suffix = 2
				else
					suffix = 1

					core:trigger_event("ScriptEventDotGP5Temples")
				end

				cm:apply_effect_bundle("wh2_dlc13_nakai_temple_"..temple_type.."_"..suffix, self.faction_key, -1)
			end
		end
	end
end

--save/load functions
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("quetzl_completed", nakai_temples.temples.quetzl.completed, context)
		cm:save_named_value("xholankha_completed", nakai_temples.temples.xholankha.completed, context)
		cm:save_named_value("itzl_completed", nakai_temples.temples.itzl.completed, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			nakai_temples.temples.quetzl.completed = cm:load_named_value("quetzl_completed", nakai_temples.temples.quetzl.completed, context)
			nakai_temples.temples.xholankha.completed = cm:load_named_value("xholankha_completed", nakai_temples.temples.xholankha.completed, context)
			nakai_temples.temples.itzl.completed = cm:load_named_value("itzl_completed", nakai_temples.temples.itzl.completed, context)
		end
	end
)