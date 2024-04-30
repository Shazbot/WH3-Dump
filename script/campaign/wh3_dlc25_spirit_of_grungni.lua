-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	SPIRIT OF GRUNGNI - HORDE BUILDING
--	SPHERE OF INFLUENCE RADIUS MODIFICATION
--	This script modifies sphere of influence radius for target force
--	This needs to be applied every turn and on loading save games
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
 
---------------------------------------------------
---------------------- Data -----------------------
---------------------------------------------------
 
spirit_of_grungni = {
	faction_key = "wh3_dlc25_dwf_malakai",
	radius_size = 25,
	building_required_1 = "wh3_dlc25_dwarf_spirit_of_grungni_support_radius_1",
	building_required_2 = "wh3_dlc25_dwarf_spirit_of_grungni_support_radius_2",
	building_built = false,
	is_malakai_confederated = false
}
 
 
---------------------------------------------------
------------------- Functions ---------------------
---------------------------------------------------
 
function spirit_of_grungni:initialise()
	-- Setup trigger
	core:add_listener(
		"horde_building_completed_spirit_of_grungni_" .. self.faction_key,
		"MilitaryForceBuildingCompleteEvent",
		function(context)
			return context:building() == self.building_required_1 or context:building() == self.building_required_2
		end,
		function(context)
			self.building_built = true
			if context:building() == self.building_required_2 then
				self.radius_size = 50
			end
			self:setup_spirit_of_grungni_change()
		end,
		true
	)
 
	core:add_listener(
		"malakai_confederated",
		"FactionJoinsConfederation",
		function(context)
			return context:faction():name() == self.faction_key
		end,
		function(context)
			self.faction_key = context:confederation():name()
			self.is_malakai_confederated = true
		end,
		true
	)
 
	if not cm:is_new_game() and self.building_built then
		self:setup_spirit_of_grungni_change()
	end
end
 
 
function spirit_of_grungni:reapply_spirit_of_grungni_modification(faction_leader_force_cqi)
	core:add_listener(
		"modify_spirit_of_grungni_" .. self.faction_key,
		"FactionTurnStart",
		function(context)
			local faction_key = context:faction():name()
			return faction_key == self.faction_key and self.building_built
		end,
		function()
			cm:set_force_sphere_of_influence_radius(faction_leader_force_cqi, self.radius_size)
		end,
		true
	)
end
 
 
function spirit_of_grungni:setup_spirit_of_grungni_change()
	local faction_interface = cm:get_faction(self.faction_key)
	local faction_leader_force_cqi
	if not self.is_malakai_confederated then
		faction_leader_force_cqi = faction_interface:faction_leader():military_force():command_queue_index()
	else
		local character_list = faction_interface:character_list()
		for i = 1, character_list:num_items() do
			local character_item = character_list:item_at(i)
			if character_item:forename("names_name_1197662411") then
				if character_item:has_military_force() then
					faction_leader_force_cqi = character_item:military_force():command_queue_index()
				end
			end
		end
	end
	
	cm:set_force_sphere_of_influence_radius(faction_leader_force_cqi, self.radius_size)
	self:reapply_spirit_of_grungni_modification(faction_leader_force_cqi)
end
 
--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
 
cm:add_saving_game_callback(
    function(context)
		cm:save_named_value("sphere_of_influence_building_built", spirit_of_grungni.building_built, context)
		cm:save_named_value("sphere_of_influence_radius_size", spirit_of_grungni.radius_size, context)
		cm:save_named_value("sphere_of_influence_faction_name", spirit_of_grungni.faction_key, context)
	end
)
 
cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			spirit_of_grungni.building_built = cm:load_named_value("sphere_of_influence_building_built", spirit_of_grungni.building_built, context)
			spirit_of_grungni.radius_size = cm:load_named_value("sphere_of_influence_radius_size", spirit_of_grungni.radius_size, context)
			spirit_of_grungni.faction_key = cm:load_named_value("sphere_of_influence_faction_name", spirit_of_grungni.faction_key, context)
		end
	end
)