def_slaves = {

	culture_key = "wh2_main_def_dark_elves",
	subculture_key = "wh2_main_sc_def_dark_elves",
	pooled_resource_key = "def_slaves",
	pooled_resource_factor_key = "raiding",

}

function def_slaves:start_listeners()

	-- set the amount of slaves to provide when raiding for ui display
	local human_factions = cm:get_human_factions();
		for i = 1, #human_factions do
		local current_human_faction = cm:get_faction(human_factions[i]);
		
		if current_human_faction:culture() == self.culture_key then
			local mf_list = current_human_faction:military_force_list();
			
			for j = 0, mf_list:num_items() - 1 do
				local current_mf = mf_list:item_at(j);
				
				if current_mf:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID" then
					self:calculate_slaves(current_mf);
				end;
			end;
		end;
	end;
		
	-- set the amonut of slaves to provide when channeling for ui display when an army enters the raiding stance
	core:add_listener(
		"def_raiding_calculate_slaves",
		"ForceAdoptsStance",
		function(context)
			local faction = context:military_force():faction();
			
			return faction:is_human() and faction:culture() == self.culture_key;
		end,
		function(context)
			local mf = context:military_force();
			
			if context:stance_adopted() == 3 then
				self:calculate_slaves(mf);
			else
				common.set_context_value("raiding_slaves_value_" .. mf:command_queue_index(), 0);
			end;
		end,
		true
	);
		
	-- update the amount of slaves if the character moves in raiding stance
	core:add_listener(
		"def_raiding_calculate_slaves_post_movement",
		"CharacterFinishedMovingEvent",
		function(context)
			local character = context:character();
			local faction = character:faction();
			
			return faction:is_human() and faction:culture() == self.culture_key and cm:char_is_general_with_army(character) and character:military_force():active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID";
		end,
		function(context)
			self:calculate_slaves(context:character():military_force());
		end,
		true
	);

	--add the slaves for the armies in raiding stance
	core:add_listener(
		"def_raiding_add_slaves",
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
					local slaves_to_add = self:calculate_slaves(mf);

					if slaves_to_add > 0 then
						cm:faction_add_pooled_resource(faction:name(), self.pooled_resource_key, self.pooled_resource_factor_key, slaves_to_add);
					end;
				end;
			end;
		end,
		true
	);

end;

function def_slaves:calculate_slaves(force)
	local value = 0

	if force:has_general() then
		local strength = force:strength();
		local gdp = force:general_character():region():gdp();
		value = math.floor((strength/200000) * (gdp/50))
	end;

	if force:faction():is_human() and value > 0 then
		common.set_context_value("raiding_slaves_value_" .. force:command_queue_index(), value);
	end;

	return value;
end;
