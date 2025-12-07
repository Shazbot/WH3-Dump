-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--
--	DRAGONSHIP - HORDE BUILDING
--	SPHERE OF INFLUENCE RADIUS MODIFICATION
--	This script modifies sphere of influence radius for target force
--	This needs to be applied every turn and on loading save games
--
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
 
---------------------------------------------------
---------------------- Data -----------------------
---------------------------------------------------
 
dragonships = {
	faction_key = "wh3_dlc27_hef_aislinn",
	radius_size = 20,
	buildings_upgrades = {
		["wh3_dlc27_hef_dragonship_aoe_1"] = 24,
		["wh3_dlc27_hef_dragonship_aoe_2"] = 30,
		["wh3_dlc27_hef_dragonship_aoe_3a"] = 40,
		["wh3_dlc27_hef_dragonship_aoe_3b"] = 30,
	},
	building_built = false,
	data_to_save = {}
}

function dragonships:initialise()
	-- Setup trigger
	core:add_listener(
		"dragonship_building_completed",
		"MilitaryForceBuildingCompleteEvent",
		function(context)
			return dragonships.buildings_upgrades[context:building()]
		end,
		function(context)
			local mf_cqi = context:character():military_force():command_queue_index()
			self.building_built = true
			local upgrade_value = dragonships.buildings_upgrades[context:building()]
			self:apply_dragonship_change(mf_cqi, upgrade_value)
		end,
		true
	)
 
	if not cm:is_new_game() and self.data_to_save and next(self.data_to_save) then
		for i, entry in ipairs(self.data_to_save) do
			self:apply_dragonship_change(entry.mf_cqi, entry.radius_size)
		end
	end
end

function dragonships:reapply_dragonship_modification(mf_cqi,radius_size)
	core:add_listener(
		"dragonship_reapply_modification",
		"FactionTurnStart",
		function(context)
			local faction_key = context:faction():name()
			return faction_key == self.faction_key and self.building_built
		end,
		function(context)
			local mf = cm:get_military_force_by_cqi(mf_cqi)
			if mf and not mf:is_null_interface() and not mf:is_armed_citizenry() then
				cm:set_force_sphere_of_influence_radius(mf_cqi, radius_size)
			end
		end,
		true
	)
end

function dragonships:apply_dragonship_change(mf_cqi, radius_size)

	cm:set_force_sphere_of_influence_radius(mf_cqi, radius_size)
	local saved_cqi = nil

	if next(self.data_to_save) then
		for i, entry in ipairs(self.data_to_save) do
			if entry.mf_cqi == mf_cqi then
				saved_cqi = entry
			end
		end
	end

	if not saved_cqi then 
		table.insert(self.data_to_save, {mf_cqi = mf_cqi, radius_size = radius_size})
	else
		saved_cqi.radius_size = radius_size 
	end

	dragonships:reapply_dragonship_modification(mf_cqi,radius_size)
end
 
--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
 
cm:add_saving_game_callback(
    function(context)
		cm:save_named_value("sphere_of_influence_building_built", dragonships.data_to_save, context)
		
	end
)
 
cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			dragonships.data_to_save = cm:load_named_value("sphere_of_influence_building_built", dragonships.data_to_save, context)
		end
	end
)