chd_labour_raid = {
	culture_key = "wh3_dlc23_chd_chaos_dwarfs",
	pooled_resource_key = "wh3_dlc23_chd_labour_global_temp",
	local_resource_key = "wh3_dlc23_chd_labour"
}
 
function chd_labour_raid:start_listeners()
	-- set the amount of labour to provide when raiding for ui display
	local human_factions = cm:get_human_factions();
		for i = 1, #human_factions do
		local current_human_faction = cm:get_faction(human_factions[i]);
		
		if current_human_faction:culture() == self.culture_key then
			local mf_list = current_human_faction:military_force_list();
			
			for j = 0, mf_list:num_items() - 1 do
				local current_mf = mf_list:item_at(j);
				
				if current_mf:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID" then
					self:calculate_labour(current_mf);
				end;
			end;
		end;
	end;
		
	-- set the amonut of labour to provide when channeling for ui display when an army enters the raiding stance
	core:add_listener(
		"def_raiding_calculate_labour",
		"ForceAdoptsStance",
		function(context)
			local faction = context:military_force():faction();
			
			return faction:is_human() and faction:culture() == self.culture_key;
		end,
		function(context)
			local mf = context:military_force();
			
			if context:stance_adopted() == 3 then
				self:calculate_labour(mf);
			else
				common.set_context_value("raiding_labour_value_" .. mf:command_queue_index(), 0);
			end;
		end,
		true
	);
		
	-- update the amount of labour if the character moves in raiding stance
	core:add_listener(
		"def_raiding_calculate_labour_post_movement",
		"CharacterFinishedMovingEvent",
		function(context)
			local character = context:character();
			local faction = character:faction();
			
			return faction:is_human() and faction:culture() == self.culture_key and cm:char_is_general_with_army(character) and character:military_force():active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID";
		end,
		function(context)
			self:calculate_labour(context:character():military_force());
		end,
		true
	);
 
	--add the labour for the armies in raiding stance
	core:add_listener(
		"def_raiding_add_labour",
		"FactionTurnStart",
		function(context)	
			return context:faction():culture() == self.culture_key;
		end,
		function(context)
			local faction = context:faction();
			local mf_list = faction:military_force_list();
 
			for i =0, mf_list:num_items()- 1 do
				local mf = mf_list:item_at(i);
 
				if mf:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID" then
					local labour_to_add = self:calculate_labour(mf);
					
					if labour_to_add > 0 then
						local faction_cqi = faction:command_queue_index()
						local provinces = faction:provinces()
						new_province_list = {}
						local labour_factor = "raiding"
					
						for i = 0, provinces:num_items() - 1 do
							local faction_province = provinces:item_at(i)
					
							if cm:is_pooled_resource_distribution_enabled(faction_cqi, self.pooled_resource_key, faction_province) then
								table.insert(new_province_list, faction_province)
							end
						end
						
						if #new_province_list > 0 then
							local labour_split = labour_to_add / #new_province_list
					
							for _, faction_province in ipairs(new_province_list) do
								local new_labour = faction_province:pooled_resource_manager():resource(self.local_resource_key)

								out.design("adding "..labour_split.." labour to "..#new_province_list.." provinces")
								cm:pooled_resource_factor_transaction(new_labour, labour_factor, labour_split)
							end
						end
					end;
				end;
			end;
		end,
		true
	);
end;
 
function chd_labour_raid:calculate_labour(force)
	local value = 0

	if force:has_general() then
		local general = force:general_character()
		local region = general:region()

		if general:faction():name() ~= region:owning_faction():name() then
			local strength = force:strength()
			local gdp = region:gdp()
			local unit_count = force:unit_list():num_items()

			-- gpd*unit_count generates a nice base number for how much labour we'd want to get each turn, however the number is too high so /100 brings it down to the ranges we'd like while making it scale nicely with army size/region wealth.
			-- It felt bad sometimes having a 20 stack in a poor region and only getting 1-2 so I re-add the unit_count to the final value so that the min labour a 20 stack can get is 20, the min labour a 1 stack can get is 1.
			-- It also felt bad for a 20 stack of labourers to get the same raid value as a 20 stack of destroyers, so we then finally add strength/200000 on the end to provide a small amount of scaling based off unit choice.
			value = math.floor((gdp*unit_count/100)+unit_count+(strength/200000))
		end
	end;

	if force:faction():is_human() then
		common.set_context_value("raiding_labour_value_" .. force:command_queue_index(), value)
	end

	return value
end;