

-------------------------------------------------------
-------------------------------------------------------
--	Export Helpers
--	Add functions here that replace massive conditional
--	tests that would otherwise be added to the db
-------------------------------------------------------
-------------------------------------------------------

function char_can_recruit_unit(character, unit)
	return character:has_military_force() and character:military_force():can_recruit_unit(unit);
end;



function char_army_has_unit(character, unit)
	-- allow a table of units to be passed in as a parameter
	if type(unit) == "table" then
		if not character:has_military_force() and not character:is_embedded_in_military_force() then
			return false;
		end;
		
		for i = 1, #unit do
			if char_army_has_unit(character, unit[i]) then
				return true;
			end;
		end;
		return false;
	end;
	
	if character:has_military_force() then
		return character:military_force():unit_list():has_unit(unit);
	elseif character:is_embedded_in_military_force() then
		return character:embedded_in_military_force():unit_list():has_unit(unit);
	end;
end;



function count_char_army_has_unit(character, unit)
	local count = 0;
	local unit_list = false;
	
	if character:has_military_force() then
		unit_list = character:military_force():unit_list();
	elseif character:is_embedded_in_military_force() then
		unit_list = character:embedded_in_military_force():unit_list();
	end;
	
	if unit_list then
		for i = 0, unit_list:num_items() - 1 do
			if type(unit) == "table" then
				for j = 1, #unit do
					if unit_list:item_at(i):unit_key() == unit[j] then
						count = count + 1;
					end;
				end;
			elseif unit_list:item_at(i):unit_key() == unit then
				count = count + 1;
			end;
		end;
	end;
	
	return count;
end;



function char_army_has_unit_category(character, unit_category)
	-- allow a table of unit categories to be passed in as a parameter
	if type(unit_category) == "table" then
		if not character:has_military_force() and not character:is_embedded_in_military_force() then
			return false;
		end;
		
		for i = 1, #unit_category do
			if char_army_has_unit_category(character, unit_category[i]) then
				return true;
			end;
		end;
		return false;
	end;
	
	local unit_list = false;
	
	if character:has_military_force() then
		unit_list = character:military_force():unit_list();
	elseif character:is_embedded_in_military_force() then
		return character:embedded_in_military_force():unit_list();
	end;
	
	if unit_list then
		for i = 0, unit_list:num_items() - 1 do
			if unit_list:item_at(i):unit_category() == unit_category then
				return true;
			end;
		end;
	end;
	
	return false;
end;



function count_char_army_has_unit_category(character, unit_category)
	local count = 0;
	local unit_list = false;
	
	if character:has_military_force() then
		unit_list = character:military_force():unit_list();
	elseif character:is_embedded_in_military_force() then
		unit_list = character:embedded_in_military_force():unit_list();
	end;
	
	if unit_list then
		for i = 0, unit_list:num_items() - 1 do
			if type(unit_category) == "table" then
				for j = 1, #unit_category do
					if unit_list:item_at(i):unit_category() == unit_category[j] then
						count = count + 1;
					end;
				end;
			elseif unit_list:item_at(i):unit_category() == unit_category then
				count = count + 1;
			end;
		end;
	end;
	
	return count;
end;


function region_has_chain_or_superchain(region, superchain)
	local slot_list = region:slot_list();
	
	for i = 0, slot_list:num_items() - 1 do
		current_slot = slot_list:item_at(i);
		if current_slot:has_building() and (current_slot:building():superchain() == superchain or current_slot:building():chain() == superchain) then
			return true;
		end;
	end;
	
	return false;
end;



function general_has_caster_embedded_in_army(character)
	if character:has_military_force() then
		local character_list = character:military_force():character_list();
		
		for i = 0, character_list:num_items() - 1 do
			if character_list:item_at(i):is_caster() then
				return true;
			end;
		end;
	end;
	
	return false;
end;



function character_won_battle_against_culture(character, culture)
	if character:won_battle() then
		local character_faction_name = character:faction():name();
		local target_faction_name = false;
		
		local defender_char_cqi, defender_mf_cqi, defender_faction_name = cm:pending_battle_cache_get_defender(1);
		local attacker_char_cqi, attacker_mf_cqi, attacker_faction_name = cm:pending_battle_cache_get_attacker(1);
		
		if defender_faction_name == character_faction_name then
			target_faction_name = attacker_faction_name;
		elseif attacker_faction_name == character_faction_name then
			target_faction_name = defender_faction_name;
		end;
		
		if target_faction_name and target_faction_name ~= "rebels" then
			local enemy_culture = cm:get_faction(target_faction_name):culture();
			
			-- allow a table of cultures to be passed in as a parameter
			if type(culture) == "table" then
				for i = 1, #culture do
					if enemy_culture == culture[i] then
						return true;
					end;
				end;
			else
				return enemy_culture == culture;
			end;
		end;
	end;
	
	return false;
end;



function character_won_battle_against_unit(character, unit)
	if type(unit) == "table" then
		for i = 1, #unit do
			if character_won_battle_against_unit(character, unit[i]) then
				return true;
			end;
		end;
		
		return false;
	end;

	if character:won_battle() then
		local pb = cm:model():pending_battle();
		local character_faction_name = character:faction():name();
		
		local defender_char_cqi, defender_mf_cqi, defender_faction_name = cm:pending_battle_cache_get_defender(1);
		local attacker_char_cqi, attacker_mf_cqi, attacker_faction_name = cm:pending_battle_cache_get_attacker(1);
		
		if attacker_faction_name == character_faction_name then
			return cm:pending_battle_cache_unit_key_exists_in_defenders(unit);
		elseif defender_faction_name == character_faction_name then
			return cm:pending_battle_cache_unit_key_exists_in_attackers(unit);
		end;
	end;
	
	return false;
end;



function character_reinforced_alongside_culture(character, culture)
	if cm:char_is_general_with_army(character) then
		local character_is_attacker = false;
		local pb = cm:model():pending_battle();
		
		-- determine if the character is on the attacking side
		if pb:attacker() == character then
			character_is_attacker = true;
		else
			local secondary_attackers = pb:secondary_attackers();
			for i = 0, secondary_attackers:num_items() - 1 do
				if secondary_attackers:item_at(i) == character then
					character_is_attacker = true;
					break;
				end;
			end;
		end;
		
		local num_attackers = cm:pending_battle_cache_num_attackers();
		local num_defenders = cm:pending_battle_cache_num_defenders();
		
		if character_is_attacker then
			if num_attackers > 1 then
				for i = 1, num_attackers do
					local current_attacker_cqi, current_attacker_mf_cqi, current_attacker_faction_name = cm:pending_battle_cache_get_attacker(i);
					
					if character:cqi() ~= current_attacker_cqi then
						local current_attacker_faction = cm:get_faction(current_attacker_faction_name);
						
						if current_attacker_faction and current_attacker_faction:culture() == culture then
							-- found a reinforcing army that matches the supplied culture
							return true;
						end;
					end;
				end;
			end;
		elseif num_defenders > 1 then
			for i = 1, num_defenders do
				local current_defender_cqi, current_defender_mf_cqi, current_defender_faction_name = cm:pending_battle_cache_get_defender(i);
				
				if character:cqi() ~= current_defender_cqi then
					local current_defender_faction = cm:get_faction(current_defender_faction_name);
					
					if current_defender_faction and current_defender_faction:culture() == culture then
						-- found a reinforcing army that matches the supplied culture
						return true;
					end;
				end;
			end;
		end;
	end;
end;