-- HOW TO USE
-- 1) For every technology that can be locked you need to add an entry in the DB in the table technology_script_lock_reasons
-- 2) Add as many entries in the Lua table below as is required (in the correct subculture table), every entry assumes all techs listed together are mutually exclusive with eachother, the table can handle any number of techs
-- 3) Optional but highly suggested: Add dummy effects to your technologies to indicate mutual exclusivity

mutually_exclusive_techs = {
	data = {
		["wh_main_sc_vmp_vampire_counts"] = {
			{"wh3_main_tech_vmp_necromancers_misc_4", "wh3_main_tech_vmp_necromancers_misc_5"},
			{"wh3_main_tech_vmp_necromancers_misc_9", "wh3_main_tech_vmp_necromancers_misc_10"},
			{"wh3_main_tech_vmp_units_zombies_3a", "wh3_main_tech_vmp_units_zombies_3b", "wh3_main_tech_vmp_units_zombies_3c"}
		}
	}
};

function mutually_exclusive_techs:initialise()
	-- Build hash tables, this is done for easier lookup and optimization, also so design doesn't need to add a lot more data
	self.hash_tables = {};

	for _, subculture in pairs(self.data) do
		for _, tech_lock_list in ipairs(subculture) do
			for _, tech_key in ipairs(tech_lock_list) do
				self.hash_tables[tech_key] = {};
				
				for _, tech_to_lock in ipairs(tech_lock_list) do
					if tech_key ~= tech_to_lock then
						table.insert(self.hash_tables[tech_key], tech_to_lock);
					end
				end
			end
		end
	end
	self:add_listeners();
end

function mutually_exclusive_techs:add_listeners()
	core:add_listener(
		"ResearchCompletedMutuallyExclusiveTechs",
		"ResearchCompleted",
		true,
		function(context)
			local faction = context:faction();
			local subculture = faction:subculture();

			-- Tiny optimization to first check if this subculture even uses mutually exclusive technologies
			if self.data[subculture] then
				local tech_key = context:technology();

				if self.hash_tables[tech_key] then
					local faction_key = faction:name();

					for _, tech_to_lock in ipairs(self.hash_tables[tech_key]) do
						cm:lock_technology(faction_key, tech_to_lock);
					end
				end
			end
		end,
		true
	);
end