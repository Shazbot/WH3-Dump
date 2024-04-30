emp_techs = {
	culture_key = "wh_main_emp_empire"
}

emp_techs.scripted_techs = {
	["wh3_dlc25_tech_emp_elspeth_4"] = function(faction) emp_techs:grant_vision_of_empire_capitals(faction) end
}

function emp_techs:initialise()
	core:add_listener(
		"EmpTechResearched",
		"ResearchCompleted",
		function(context)
			local tech = context:technology()

			return self.scripted_techs[tech] ~= nil
		end,
		function(context)
			local tech = context:technology()

			self.scripted_techs[tech](context:faction())
		end,
		true
	)
end

function emp_techs:grant_vision_of_empire_capitals(faction)
	local faction_name = faction:name()

	self:grant_vision_of_culture_capitals(self.culture_key, faction_name)

	core:add_listener(
		"EmpTechVision"..faction_name,
		"FactionTurnStart",
		function(context)
			return context:faction():name() == faction_name
		end,
		function(context)
			self:grant_vision_of_culture_capitals(self.culture_key, faction_name)
		end,
		true
	)
end

function emp_techs:grant_vision_of_culture_capitals(culture_key, faction_key)
	local factions = cm:get_factions_by_culture(culture_key)

	for _, faction in ipairs(factions) do
		if faction:at_war_with(cm:get_faction(faction_key)) == false then
			if faction:has_home_region() then
				cm:make_region_visible_in_shroud(faction_key, faction:home_region():name())
			end
		end
	end
end