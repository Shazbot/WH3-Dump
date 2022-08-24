
BRET_LORDS_RECORDS = {};
LOUEN_SUBTYPE = "wh_main_brt_louen_leoncouer";

function Add_Virtues_and_Traits_Listeners()
	out("#### Adding Virtues and Traits Listeners ####");
	
	if BRET_LORDS_RECORDS ~= nil then
		for key,value in pairs(BRET_LORDS_RECORDS) do
			out("\t\t"..tostring(key).." = "..tostring(value));
		end
	else
		BRET_LORDS_RECORDS = {};
	end
end

function is_reinforcer(character)
	if cm:pending_battle_cache_num_attackers() > 1 then
		for i = 2, cm:pending_battle_cache_num_attackers() do
			local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_attacker(i);
			if character:command_queue_index() == this_char_cqi then
				return true;
			end
		end
	end
	if cm:pending_battle_cache_num_defenders() > 1 then
		for i = 2, cm:pending_battle_cache_num_defenders() do
			local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_defender(i);
			if character:command_queue_index() == this_char_cqi then
				return true;
			end
		end
	end
	return false;
end

function is_attacker(character)
	for i = 1, cm:pending_battle_cache_num_attackers() do
		local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_attacker(i);
		
		if character:command_queue_index() == this_char_cqi then
			return true;
		end
	end
	return false;
end

function is_defender(character)
	for i = 1, cm:pending_battle_cache_num_defenders() do
		local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_defender(i);
		
		if character:command_queue_index() == this_char_cqi then
			return true;
		end
	end
	return false;
end

function is_LL_in_enemy(character, subtype)
	if is_attacker(character) then
		for i = 1, cm:pending_battle_cache_num_defenders() do
			local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_defender(i);
			local defender = cm:get_character_by_cqi(this_char_cqi);
			
			if defender and defender:character_subtype_key() == subtype then
				return true, "defender";
			end
		end
	elseif is_defender(character) then
		for i = 1, cm:pending_battle_cache_num_attackers() do
			local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_attacker(i);
			local attacker = cm:get_character_by_cqi(this_char_cqi);
			
			if attacker and attacker:character_subtype_key() == subtype then
				return true, "attacker";
			end
		end
	end
	return false, "none";
end

function is_peasant_army(character)
	local force = character:military_force():unit_list();
	local counter = 0;

	for i = 0, force:num_items() - 1 do
		local unit = force:item_at(i);
		
		if Is_Peasant_Unit(unit:unit_key()) == true and unit:unit_class() ~= "com" then
			counter = counter + 1;
		end
	end
	return counter > 15;
end

function is_knightly_army(character)
	local force = character:military_force():unit_list();
	local counter = 0;
	
	for i = 0, force:num_items() - 1 do
		local unit = force:item_at(i);
		
		if Is_Peasant_Unit(unit:unit_key()) == false and unit:unit_class() ~= "com" then
			counter = counter + 1;
		end
	end
	return counter > 15;
end

function region_has_chain(region, chain)
	local slot_list = region:slot_list();
	
	for i = 0, slot_list:num_items() - 1 do
		local current_slot = slot_list:item_at(i);
		if current_slot:has_building() and current_slot:building():chain() == chain then
			return true;
		end
	end
	return false;
end

--Winrate Traits
core:add_listener(
	"character_completed_battle_winrate_traits",
	"CharacterCompletedBattle",
	true,
	function(context)
		if context:character():battles_fought()>10 and cm:char_is_general_with_army(context:character()) and context:character():faction():culture() == "wh_main_brt_bretonnia" then
			if (context:character():battles_won() / context:character():battles_fought()) >= 0.8 then
				cm:force_add_trait("character_cqi:"..context:character():command_queue_index(),"wh_dlc07_trait_brt_lord_good_victory",true);
				if (context:character():has_trait("wh_dlc07_trait_brt_lord_bad_defeat")) then
					cm:force_remove_trait("character_cqi:"..context:character():command_queue_index(),"wh_dlc07_trait_brt_lord_bad_defeat");
				end
			elseif (context:character():battles_won() / context:character():battles_fought()) <= 0.5 then
				cm:force_add_trait("character_cqi:"..context:character():command_queue_index(),"wh_dlc07_trait_brt_lord_bad_defeat",true);
				if (context:character():has_trait("wh_dlc07_trait_brt_lord_bad_defeat")) then
					cm:force_remove_trait("character_cqi:"..context:character():command_queue_index(),"wh_dlc07_trait_brt_lord_good_victory");
				end
			else
				cm:force_remove_trait("character_cqi:"..context:character():command_queue_index(),"wh_dlc07_trait_brt_lord_bad_defeat");
				cm:force_remove_trait("character_cqi:"..context:character():command_queue_index(),"wh_dlc07_trait_brt_lord_good_victory");
			end
		end

		if cm:char_is_general_with_army(context:character()) and context:character():faction():culture() == "wh_main_brt_bretonnia" then
			if context:character():won_battle() and is_attacker(context:character()) then
				Give_Trait(context:character(), "wh_dlc07_trait_brt_lord_good_attacker", 1, 100);
			elseif context:character():won_battle()==false and is_attacker(context:character()) then
				Give_Trait(context:character(), "wh_dlc07_trait_brt_lord_bad_attacker", 2, 100);
			end
		end	
		
		if cm:char_is_general_with_army(context:character()) and context:character():faction():culture() == "wh_main_brt_bretonnia" then
			if context:character():won_battle() and is_defender(context:character()) then
				Give_Trait(context:character(), "wh_dlc07_trait_brt_lord_good_defender", 1, 100);
			elseif context:character():won_battle()==false and is_defender(context:character()) then
				Give_Trait(context:character(), "wh_dlc07_trait_brt_lord_bad_defender", 2, 100);
			end
		end	
	end,
	true
);


-- Kingslayer
core:add_listener(
	"battle_completed_kingslayer_trait",
	"BattleCompleted",
	true,
	function(context)
		local faction = cm:model():world():faction_by_key("wh_main_brt_bretonnia");
		local Bret_are_there = false;
		local Bret_are_attacking = false; 

		if (faction:is_null_interface() == true or faction:is_dead()) then 
			if cm:pending_battle_cache_num_attackers() >= 1 then
				for i = 1, cm:pending_battle_cache_num_attackers() do
					local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_attacker(i);
					if current_faction_name == "wh_main_brt_bretonnia" then
						Bret_are_there = true;
						Bret_are_attacking =  true;
					end
				end
			end
			
			if cm:pending_battle_cache_num_defenders() >= 1 then
				for i = 1, cm:pending_battle_cache_num_defenders() do
					local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_defender(i);
					if current_faction_name == "wh_main_brt_bretonnia" then
						Bret_are_there = true;
					end
				end
			end
			
			if Bret_are_there and Bret_are_attacking then
				local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_defender(1);
				if (cm:model():character_for_command_queue_index(this_char_cqi):has_trait("wh_dlc07_trait_brt_lord_bad_kingslayer") == false and cm:model():character_for_command_queue_index(this_char_cqi):faction():culture()=="wh_main_brt_bretonnia") then
					cm:force_add_trait("character_cqi:"..this_char_cqi,"wh_dlc07_trait_brt_lord_bad_kingslayer",true);
				end
			elseif Bret_are_there and Bret_are_attacking == false then
				local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_attacker(1);
				if (cm:model():character_for_command_queue_index(this_char_cqi):has_trait("wh_dlc07_trait_brt_lord_bad_kingslayer") == false and cm:model():character_for_command_queue_index(this_char_cqi):faction():culture()=="wh_main_brt_bretonnia") then
					cm:force_add_trait("character_cqi:"..this_char_cqi,"wh_dlc07_trait_brt_lord_bad_kingslayer",true);
				end
			end
		end
	end,
	true
);


-- Villain
core:add_listener(
	"character_completed_battle_villain_trait",
	"CharacterCompletedBattle",
	true,
	function(context)
		if cm:char_is_general_with_army(context:character()) and context:character():faction():culture() == "wh_main_brt_bretonnia" then
			if (is_attacker(context:character()) and context:pending_battle():defender():faction():culture() == "wh_main_brt_bretonnia") or
			(is_defender(context:character()) and context:pending_battle():attacker():faction():culture() == "wh_main_brt_bretonnia") then
			
				Give_Trait(context:character(), "wh_dlc07_trait_brt_lord_bad_villain", 1, 100);
			end
		end
	end,
	true
);


-- Renegade
core:add_listener(
	"character_completed_battle_renegade_trait",
	"CharacterCompletedBattle",
	true,
	function(context)
		if cm:char_is_general_with_army(context:character()) and context:character():faction():culture() == "wh_main_brt_bretonnia" then
			if (is_attacker(context:character()) and context:pending_battle():defender():faction():culture() == "wh_main_emp_empire" and (not context:pending_battle():defender():faction():name()=="wh_main_teb_estalia") and (not context:pending_battle():defender():faction():name()=="wh_main_teb_tilea")) or
			(is_defender(context:character()) and context:pending_battle():attacker():faction():culture() == "wh_main_emp_empire" and (not context:pending_battle():attacker():faction():name()=="wh_main_teb_estalia") and (not context:pending_battle():attacker():faction():name()=="wh_main_teb_tilea")) then
			
				Give_Trait(context:character(), "wh_dlc07_trait_brt_lord_bad_renegade", 1, 100);
			end
		end
	end,
	true
);


-- Low-Born
core:add_listener(
	"character_completed_battle_low_born_trait",
	"CharacterCompletedBattle",
	true,
	function(context)
		if cm:char_is_general_with_army(context:character()) and context:character():faction():culture() == "wh_main_brt_bretonnia" and context:character():won_battle() and is_peasant_army(context:character()) and (not context:character():has_trait("wh_dlc07_trait_brt_lord_good_knightly")) then
			Give_Trait(context:character(), "wh_dlc07_trait_brt_lord_good_peasants", 1, 100);
		end
	end,
	true
);


-- Nobleman
core:add_listener(
	"character_completed_battle_nobleman_trait",
	"CharacterCompletedBattle",
	true,
	function(context)
		if cm:char_is_general_with_army(context:character()) and context:character():faction():culture() == "wh_main_brt_bretonnia" and context:character():won_battle() and is_knightly_army(context:character()) and (not context:character():has_trait("wh_dlc07_trait_brt_lord_good_peasants")) then
			Give_Trait(context:character(), "wh_dlc07_trait_brt_lord_good_knightly", 1, 100);
		end
	end,
	true
);


-- Saviour
core:add_listener(
	"character_completed_battle_saviour_trait",
	"CharacterCompletedBattle",
	true,
	function(context)
		if cm:char_is_general_with_army(context:character()) and context:character():faction():culture() == "wh_main_brt_bretonnia" then
			if cm:pending_battle_cache_num_attackers() > 1 then
				for i = 2, cm:pending_battle_cache_num_attackers() do
					local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_attacker(i);
					local this_char = cm:model():character_for_command_queue_index(this_char_cqi);
					if cm:char_is_general_with_army(this_char) and this_char:faction():culture() == "wh_main_brt_bretonnia" then
						cm:force_add_trait("character_cqi:"..this_char:command_queue_index(), "wh_dlc07_trait_brt_lord_good_reinforcing", true);
					end
				end
			end
			if cm:pending_battle_cache_num_defenders() > 1 then
				for i = 2, cm:pending_battle_cache_num_defenders() do
					local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_defender(i);
					local this_char = cm:model():character_for_command_queue_index(this_char_cqi);
					if cm:char_is_general_with_army(this_char) and this_char:faction():culture() == "wh_main_brt_bretonnia" then
						cm:force_add_trait("character_cqi:"..this_char:command_queue_index(), "wh_dlc07_trait_brt_lord_good_reinforcing", true);
					end
				end
			end
		end
	end,
	true
);
	

-- Traitor
core:add_listener(
	"character_completed_battle_traitor_trait",
	"CharacterCompletedBattle",
	true,
	function(context)
		local louen_present, LL_role = is_LL_in_enemy(context:character(), LOUEN_SUBTYPE);
		
		if cm:char_is_general_with_army(context:character()) and context:character():faction():culture() == "wh_main_brt_bretonnia" and (louen_present == true and LL_role == "defender") then
			Give_Trait(context:character(), "wh_dlc07_trait_brt_lord_bad_traitor", 1, 100);
		end
	end,
	true
);


-- Crusader
core:add_listener(
	"character_completed_battle_crusader_trait",
	"CharacterCompletedBattle",
	true,
	function(context)
		if cm:char_is_general_with_army(context:character()) and context:character():faction():culture() == "wh_main_brt_bretonnia" and context:character():faction():has_home_region() then
			local home = context:character():faction():home_region():settlement();
			local distance = distance_squared(context:character():logical_position_x(), context:character():logical_position_y(), home:logical_position_x(), home:logical_position_y());
			out("Bretonnia battle distance: "..distance);
			
			if distance >= 100000 then 
				Give_Trait(context:character(), "wh_dlc07_trait_brt_lord_good_far_from_capital", 1, 100);
			end
		end
	end,
	true
);


-- Coward
core:add_listener(
	"character_completed_battle_coward_trait",
	"CharacterCompletedBattle",
	true,
	function(context)
		if cm:char_is_general_with_army(context:character()) and context:character():faction():culture() == "wh_main_brt_bretonnia" and context:character():routed_in_battle() and context:character():won_battle() == false then
			Give_Trait(context:character(), "wh_dlc07_trait_brt_lord_bad_coward", 1, 100);
		end
	end,
	true
);


-- Abducter
core:add_listener(
	"character_post_battle_release_abducter_trait",
	"CharacterPostBattleCaptureOption",
	true,
	function(context)
		if context:get_outcome_key() == "release" and cm:char_is_general_with_army(context:character()) and context:character():faction():culture() == "wh_main_brt_bretonnia" then
			Give_Trait(context:character(), "wh_dlc07_trait_brt_lord_bad_abducter", 1, 100);
		end
	end,
	true
);


-- Purifier
core:add_listener(
	"character_post_battle_slaughter_purifier_trait",
	"CharacterPostBattleCaptureOption",
	true,
	function (context)
		if context:get_outcome_key() == "kill" and cm:char_is_general_with_army(context:character()) and context:character():faction():culture() == "wh_main_brt_bretonnia" then
			Give_Trait(context:character(), "wh_dlc07_trait_brt_lord_good_executing", 1, 100);
		end
	end,
	true
);


-- Looter, Butcher, Destroyer
core:add_listener(
	"character_sacked_settlement_looter_butcher_destroyer_trait",
	"CharacterSackedSettlement",
	true,
	function (context)
		if cm:char_is_general_with_army(context:character()) and context:character():faction():culture() == "wh_main_brt_bretonnia" then
			Give_Trait(context:character(), "wh_dlc07_trait_brt_lord_bad_sacking", 1, 100);
		end
	end,
	true
);


-- Raider
core:add_listener(
	"character_turn_start_raider_trait",
	"CharacterTurnStart",
	true,
	function (context)
		if cm:char_is_general_with_army(context:character()) and context:character():faction():culture() == "wh_main_brt_bretonnia" then
			if context:character():has_military_force() and context:character():military_force():active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID" then
				Give_Trait(context:character(), "wh_dlc07_trait_brt_lord_bad_raider", 1, 100);
			end
		end
	end,
	true
);


-- Perverted
core:add_listener(
	"character_turn_start_perverted_trait",
	"CharacterTurnStart",
	true,
	function (context)
		if cm:char_is_general_with_army(context:character()) and context:character():faction():culture() == "wh_main_brt_bretonnia" and context:character():has_region() then
			if context:character():in_settlement() and context:character():region():building_exists("wh_main_brt_tavern_4") then
				Give_Trait(context:character(), "wh_dlc07_trait_brt_lord_bad_perverted", 1, 100);
			end
		end
	end,
	true
);


-- Authoritarian
core:add_listener(
	"character_turn_start_authoritarian_trait",
	"CharacterTurnStart",
	true,
	function(context)
		if cm:char_is_general_with_army(context:character()) and context:character():has_region() and context:character():faction():culture() == "wh_main_brt_bretonnia" and context:character():region():public_order() <= -50 then
			Give_Trait(context:character(), "wh_dlc07_trait_brt_lord_good_public_order", 1, 100);
		end
	end,
	true
);


-- Independent, Lone Wolf
core:add_listener(
	"character_turn_start_lone_wolf_trait",
	"CharacterTurnStart",
	true,
	function(context)
		if cm:char_is_general_with_army(context:character()) and context:character():faction():culture() == "wh_main_brt_bretonnia" and context:character():has_region() and context:character():turns_in_enemy_regions() >= 20 and context:character():model():turn_number() > 1 then
			Give_Trait(context:character(), "wh_dlc07_trait_brt_lord_good_lone_wolf", 1, 100);
		elseif cm:char_is_general_with_army(context:character()) and context:character():faction():culture() == "wh_main_brt_bretonnia" and context:character():has_region() and context:character():turns_in_enemy_regions() >= 10 and context:character():model():turn_number() > 1 then
			if context:character():has_trait("wh_dlc07_trait_brt_lord_good_lone_wolf") == false then
				Give_Trait(context:character(), "wh_dlc07_trait_brt_lord_good_lone_wolf", 1, 100);
			end
		end
	end,
	true
);


-- Agriculturalist
core:add_listener(
	"building_completed_agriculturalist_trait",
	"BuildingCompleted",
	true,
	function(context)
		if context:building():chain() == "wh_main_BRETONNIA_farm_basic" or context:building():chain() == "wh_main_BRETONNIA_farm_extra" then
			local builder_fac = context:building():faction();
			
			if builder_fac:is_null_interface() == false and context:building():faction():character_list():num_items() > 1 then
				for i = 0, builder_fac:character_list():num_items() - 1 do
					local builder = builder_fac:character_list():item_at(i)
					
					if builder:is_null_interface() == false and builder:has_region() and cm:char_is_general_with_army(builder) and builder:region():name() == context:building():region():name() then
						cm:force_add_trait("character_cqi:"..builder:command_queue_index(), "wh_dlc07_trait_brt_lord_good_farming", true);
					end
				end
			end
		end
	end,
	true
);


-- Industrialist
core:add_listener(
	"building_completed_industrialist_trait",
	"BuildingCompleted",
	true,
	function(context)
		if (context:building():chain() == "wh_main_BRETONNIA_industry_basic" or context:building():chain() == "wh_main_BRETONNIA_industry_extra") and context:building():faction():character_list():num_items() > 1 then
			for i = 0, context:building():faction():character_list():num_items() - 1 do
				local builder = context:building():faction():character_list():item_at(i);
				
				if builder:has_region() and cm:char_is_general_with_army(builder) and builder:region():name() == context:building():region():name() and builder:faction():culture() == "wh_main_brt_bretonnia" then
					cm:force_add_trait("character_cqi:"..builder:command_queue_index(), "wh_dlc07_trait_brt_lord_good_industry", true);
				end
			end
		end
	end,
	true
);


-- Devoted
core:add_listener(
	"character_turn_end_devoted_trait",
	"CharacterTurnEnd",
	true,
	function(context)
		if cm:char_is_general_with_army(context:character()) and context:character():faction():culture() == "wh_main_brt_bretonnia" then
			if context:character():has_region() and context:character():in_settlement() and region_has_chain(context:character():region(), "wh_main_BRETONNIA_worship") then
				local char_cqi = tostring(context:character():command_queue_index()).."_praying";
				local char_turns_praying = BRET_LORDS_RECORDS[char_cqi] or 0;
				char_turns_praying = char_turns_praying + 1;
				local char_bad_traits = {};

				for i = 1, #chivalry.bad_traits do
					local current_trait = chivalry.bad_traits[i]
					if context:character():has_trait(current_trait) and context:character():trait_points(current_trait) >= chivalry[current_trait].levels[1].points then
						table.insert(char_bad_traits, current_trait);
					end
				end
				
				if #char_bad_traits > 0 then
					-- Displayed 30% - Actual 40%
					if context:character():region():building_exists("wh_main_brt_worship_3") and cm:model():random_percent(40) then
						cm:force_remove_trait("character_cqi:"..context:character():command_queue_index(), char_bad_traits[cm:random_number(#char_bad_traits)]);
					-- Displayed 20% - Actual 30%
					elseif context:character():region():building_exists("wh_main_brt_worship_2") and cm:model():random_percent(30) then
						cm:force_remove_trait("character_cqi:"..context:character():command_queue_index(), char_bad_traits[cm:random_number(#char_bad_traits)]);
					-- Displayed 10% - Actual 20%
					elseif context:character():region():building_exists("wh_main_brt_worship_1") and cm:model():random_percent(20) then
						cm:force_remove_trait("character_cqi:"..context:character():command_queue_index(), char_bad_traits[cm:random_number(#char_bad_traits)]);
					end
				end
				
				if char_turns_praying >= 5 and context:character():has_trait("wh_dlc07_trait_brt_lord_good_praying") == false then
					Give_Trait(context:character(), "wh_dlc07_trait_brt_lord_good_praying", 1, 100);
					BRET_LORDS_RECORDS[char_cqi] = nil; -- Reset
				else
					BRET_LORDS_RECORDS[char_cqi] = char_turns_praying;
				end
			end
		end
	end,
	true
);

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("BRET_LORDS_RECORDS", BRET_LORDS_RECORDS, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		BRET_LORDS_RECORDS = cm:load_named_value("BRET_LORDS_RECORDS", {}, context);
	end
);