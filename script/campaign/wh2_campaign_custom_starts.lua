----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
--
--	CAMPAIGN_CUSTOM_STARTS
--
---	@set_environment campaign
--- @data_interface custom_starts Campaign Custom Starts
--- @desc Allows tweaks to be made to a faction's starting circumstances based on other conditions.
--- @desc This script is to be used when creating a custom start that differs from the start_pos.
--- @desc Please use this instead of editing a faction's unique start/prelude scripts - editing that file with start pos changes can only be done in SP as MP changes cause desync issues.
---
----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------


----------------------------------------------------------------------------
--- @section How to Use
--- @desc To use the custom start functions you need to declare a set of changes to enact in the <code>custom_start</code> table.
--- @desc Within a custom start, a set of changes to the campaign map can be specified. For example, <code>region_change</code> can give a region to a particular faction.
--- @desc The conditions under which a certain custom start executes can be defined with the <code>is_human</code> and <code>is_ai</code> values. These may be a faction string, or a list of faction strings, and ALL factions must be human, or AI, for <code>is_human</code> and <code>is_ai</code> respectively.
--- @new_example Custom Start
--- @desc For Cult of Sotek, if Pestilens is AI then start war between Sotek and Pestilens, and give Pestilens the Shrine of Sotek. If Itza and Cult of Sotek are AI, they cannot declare war.
--- @example {
--- @example 	if_human = "wh2_dlc12_lzd_cult_of_sotek",
--- @example 	if_ai = "wh2_main_skv_clan_pestilens",
--- @example 	changes = {
--- @example 		{"region_change", "wh3_main_combi_region_shrine_of_sotek", "wh2_main_skv_clan_pestilens"},
--- @example 		{"force_diplomacy", "wh2_dlc12_lzd_cult_of_sotek", "wh2_main_skv_clan_pestilens", "war"},
--- @example 	}
--- @example }
--- @example {
--- @example 	if_ai = { "wh2_dlc12_lzd_cult_of_sotek", "wh2_main_lzd_itza" }
--- @example 	changes = {
--- @example 		{"block_diplomacy", "wh2_dlc12_lzd_cult_of_sotek", "wh2_main_lzd_itza", "war", false, false},
--- @example 	}
--- @example }

custom_starts =
{
	start_data = {};
}

--Chaos Realms Changes
custom_starts.start_data.chs_custom_start_factions = {

	--------------------
	----- Azazel -------
	--------------------
	{
		if_human = "wh3_dlc20_chs_azazel",
		if_ai = nil,
		changes = {
			-- Add seductive influence to Imperial Wardens Cathay faction
			{"adjust_pooled_resource", "wh3_main_cth_imperial_wardens", "wh3_main_sla_seductive_influence", "other", 200}
		}
	},

};

--Immortal Empires Changes
custom_starts.start_data.me_custom_start_factions = {


	--------------------
	----   DURTHU   ----
	--------------------
	{
		if_human = "wh_dlc05_wef_argwylon",
		if_ai = {"wh_dlc05_wef_wood_elves"},
		changes = {
			{"region_change", "wh3_main_combi_region_the_oak_of_ages", "wh_dlc05_wef_argwylon"},
		}
	},

	--------------------
	----   SISTERS   ----
	--------------------
	{
		if_human = "wh2_dlc16_wef_sisters_of_twilight",
		if_ai = {"wh_dlc05_wef_wood_elves", "wh_dlc05_wef_argwylon"},
		changes = {
			{"region_change", "wh3_main_combi_region_the_oak_of_ages", "wh2_dlc16_wef_sisters_of_twilight"},
		}
	},

	--------------------
	----   TYRION   ----
	--------------------
	{
		if_human = "wh2_main_hef_eataine",
		if_ai = nil,
		changes = {
			{"add_xp_to_unit", "wh2_main_hef_eataine", "wh2_main_hef_inf_lothern_sea_guard_1", 3},
		}
	},


	--------------------
	------ LOUEN -------
	--------------------
	{
		if_human = "wh_main_brt_bretonnia",
		if_ai = nil,
		changes = {
			{"create_army", "wh_main_vmp_mousillon", "wh_main_vmp_inf_zombie,wh_main_vmp_inf_zombie,wh_main_vmp_inf_zombie,wh_main_vmp_inf_zombie,wh_main_vmp_inf_zombie,wh_main_vmp_inf_crypt_ghouls,wh_main_vmp_inf_crypt_ghouls,wh_main_vmp_cav_black_knights_0,wh_main_vmp_cav_black_knights_0",
			"wh3_main_combi_region_languille", 392, 666, "wh_main_vmp_lord", false}
		}
	},
	
	
	--------------------
	------ KHAZRAK -----
	--------------------
	{
		if_human = "wh_dlc03_bst_beastmen",
		if_ai = {"wh_main_emp_empire", "wh2_dlc16_wef_sisters_of_twilight", "wh2_dlc16_wef_drycha", "wh_dlc05_wef_wood_elves", "wh_dlc05_wef_argwylon"},
		changes = {
			{"create_army", "wh3_main_wef_laurelorn", "wh_dlc05_wef_inf_dryads_0,wh_dlc05_wef_inf_dryads_0,wh_dlc05_wef_inf_eternal_guard_0,wh_dlc05_wef_inf_eternal_guard_0,wh_dlc05_wef_inf_waywatchers_0,wh_dlc05_wef_inf_waywatchers_0", 
				"wh3_main_combi_region_middenheim", 530, 720, "wh_dlc05_wef_glade_lord", false
			},
			{"force_diplomacy", "wh_dlc03_bst_beastmen", "wh3_main_wef_laurelorn", "war"},
			{"teleport_character", "wh_dlc03_bst_beastmen", 543, 741, 519, 717, true},
			{"teleport_character", "wh_dlc03_bst_beastmen", 555, 731, 516, 725, true},
		}
	},

	---------------------------
	------ VLAD/ISABELLA -----
	---------------------------
	{
		if_human = "wh_main_vmp_schwartzhafen",
		if_ai = nil,
		changes = {
			-- vlad 
			{"modify_units_in_army", "wh_main_vmp_schwartzhafen", 718, 622, {"wh_main_vmp_inf_grave_guard_0", "wh_dlc02_vmp_cav_blood_knights_0"}, {}, "names_name_2147345130", "names_name_2147343895"},
			-- isabella
			{"modify_units_in_army", "wh_main_vmp_schwartzhafen", 718, 622, {"wh_main_vmp_inf_crypt_ghouls", "wh_main_vmp_mon_varghulf"}, {}, "names_name_2147345124", "names_name_2147343895"}
		}
	},
	
	---------------------------
	-------- THORGRIM ---------
	---------------------------
	{
		if_human = "wh_main_dwf_dwarfs",
		if_ai = nil,
		changes = {
			{"force_change_faction_cai_personality", "wh_main_grn_bloody_spearz", "wh_script_foolishly_brave" },
		}
	},



	---------------------------
	-------- ELTHARION --------
	---------------------------
	{
		if_human = "wh2_main_hef_yvresse",
		if_ai = nil,
		changes = {
			{"teleport_character", "wh2_main_hef_yvresse", 328, 570, 573, 407, true},
			{"teleport_character", "wh2_main_hef_yvresse", 327, 569, 569, 407, false},
			{"teleport_character", "wh2_main_hef_yvresse", 316, 574, 327, 569, true},
			{"force_diplomacy", "wh2_main_hef_yvresse", "wh_main_grn_top_knotz", "war"},
		}
	},
	{ --Remove the units in the extra army from AI Eltharion to stop him curbstopping N'kari
		if_ai = "wh2_main_hef_yvresse",
		changes = {
			{"modify_units_in_army", "wh2_main_hef_yvresse", 316, 574, {}, {"wh2_main_hef_cav_ellyrian_reavers_0","wh2_dlc15_hef_inf_mistwalkers_spireguard_0","wh2_main_hef_inf_archers_0","wh2_main_hef_inf_archers_0"}, nil, nil }
		}
	},

	-----------------------
	------ KARL FRANZ -----
	-----------------------
	-- In any game where Karl Franz is AI-controlled, give Reikland all of the separatist lands.
	{
		if_ai = "wh_main_emp_empire",
		changes = {
			{"replace_faction", "wh_main_emp_empire_separatists", "wh_main_emp_empire"},
		}
	},


	---------------------------
	----- MANNFRED/GHORST -----
	---------------------------
	{
		if_human = "wh_main_vmp_vampire_counts",
		if_ai = nil,
		changes = {
			{"force_change_cai_faction_personality", "wh_main_vmp_rival_sylvanian_vamps", "wh_script_foolishly_brave"}
		}
	},


	--------------------
	------ ORION ------
	--------------------
	{
		if_human = "wh_dlc05_wef_wood_elves",
		if_ai = nil,
		changes = {
			{"force_diplomacy", "wh_dlc05_wef_wood_elves", "wh_dlc03_bst_redhorn", "peace"},
			{"teleport_character", "wh_dlc05_wef_wood_elves", 503, 518, 471, 517, true},
			{"teleport_character", "wh_dlc05_wef_wood_elves", 515, 516, 467, 518, false},
		}
	},

	
	--------------------
	------ DURTHU ------
	--------------------
	{
		if_human = "wh_dlc05_wef_argwylon",
		if_ai = nil,
		changes = {
			{"force_diplomacy", "wh_dlc05_wef_argwylon", "wh_dlc03_bst_redhorn", "peace"}
		}
	}
}

function custom_starts:add_campaign_custom_start_listeners()
	out("#### Add Campaign Custom Start Listeners ####");

	local custom_table = nil;
		
	if cm:get_campaign_name() == "main_warhammer" then
		custom_table = self.start_data.me_custom_start_factions;
	else
		custom_table = self.start_data.chs_custom_start_factions;
	end

	for c = 1, #custom_table do
		local custom_config = custom_table[c]

		local if_human_list = custom_config.if_human
		local if_ai_list = custom_config.if_ai

		if custom_config.if_human ~= nil and is_string(custom_config.if_human) then
			if_human_list = { custom_config.if_human }
		end
		if custom_config.if_ai ~= nil and is_string(custom_config.if_ai) then
			if_ai_list = { custom_config.if_ai }
		end

		if if_human_list == nil or cm:are_all_factions_human(if_human_list) then
			if if_ai_list == nil or cm:are_all_factions_ai(if_ai_list) then
				local custom_changes = custom_config.changes;
				for l = 1, #custom_changes do
					local changes = custom_changes[l];
					if cm:is_new_game() == true then
						cm:disable_event_feed_events(true,"all","","")
						if changes[1] == "region_change" then
							self:region_change(changes[2], changes[3]);
						elseif changes[1] == "primary_slot_change" then 
							self:primary_slot_change(changes[2], changes[3]);
						elseif changes[1] == "port_slot_change" then 
							self:port_slot_change(changes[2], changes[3]);
						elseif changes[1] == "secondary_slot_change" then 
							self:secondary_slot_change(changes[2], changes[3], changes[4]);
						elseif changes[1] == "create_army" then 
							self:create_army(changes[2], changes[3], changes[4], changes[5], changes[6], changes[7], changes[8], changes[9]);
						elseif changes[1] == "create_army_for_leader" then
							self:create_army_for_faction_leader(changes[2], changes[3], changes[4], changes[5], changes[6]);
						elseif changes[1] == "teleport_character" then 
							self:teleport_character(changes[2], changes[3], changes[4], changes[5], changes[6], changes[7]);
						elseif changes[1] == "teleport_character_faction_leader" then
							self:teleport_character_faction_leader(changes[2], changes[3], changes[4]);
						elseif changes[1] == "hide_faction_leader" then
							self:hide_faction_leader(changes[2], changes[3], changes[4]);
						elseif changes[1] == "modify_units_in_army" then
							self:modify_units_in_army(changes[2], changes[3], changes[4], changes[5], changes[6], changes[7], changes[8])
						elseif changes[1] == "add_xp_to_unit" then
							self:add_xp_to_units(changes[2], changes[3], changes[4]);
						elseif changes[1] == "force_diplomacy" then 
							self:force_diplomacy_change(changes[2], changes[3], changes[4]);
						elseif changes[1] == "abandon_region" then 
							self:abandon_region(changes[2]);
						elseif changes[1] == "kill_faction" then 
							self:kill_faction(changes[2]);
						elseif changes[1] == "replace_faction" then 
							self:replace_faction(changes[2], changes[3]);
						elseif changes[1] == "char_effect_bundle" then 
							self:apply_effect_bundle_character(changes[2], changes[3], changes[4], changes[5], changes[6]);
						elseif changes[1] == "adjust_pooled_resource" then
							self:adjust_pooled_resource_to_faction(changes[2], changes[3], changes[4], changes[5])
						end
						cm:callback(function() 
							cm:disable_event_feed_events(false, "all", "", "");
						end, 0.5);
					end
					if changes[1] == "block_diplomacy" then 
						self:block_diplomacy(changes[2], changes[3], changes[4], changes[5], changes[6]);
					end
				end
			end
		end
	end

	self:set_all_non_playable_armies_as_retreated()
end


function custom_starts:set_all_non_playable_armies_as_retreated()
	local faction_list = cm:model():world():faction_list()
		
	for i = 0, faction_list:num_items() - 1 do
		local faction = faction_list:item_at(i)

		if faction:can_be_human() == false then
			local army_list = faction:military_force_list()

			for i = 0, army_list:num_items() - 1 do
				local army = army_list:item_at(i)

				cm:set_force_has_retreated_this_turn(army)
			end
		end
	end
end

--- @function region_change
--- @desc Give a region to the specified faction.
--- @p @string region key, The key of the region to be transferred.
--- @p @string faction_name, The key of the faction to receive the region.
function custom_starts:region_change(region_name, faction_name)
	--check the region key is a string
	if not is_string(region_name) then
		script_error("ERROR: region_change() called but supplied target region key [" .. tostring(region_name) .. "] is not a string");
		return false;
	end;
	
	--check the faction key is a string
	if not is_string(faction_name) then
		script_error("ERROR: region_change() called but supplied target faction key [" .. tostring(faction_name) .. "] is not a string");
		return false;
	end


	cm:transfer_region_to_faction(region_name, faction_name);

	cm:callback(function() 
		cm:heal_garrison(cm:get_region(region_name):cqi());
	end, 0.5);
end

--- @function absorb_other_faction
--- @desc Give all regions of the absorbed faction to the absorbing faction, and kill all absorbed faction's characters.
--- @p @string absorbing faction key, The key of the faction to absorb the other faction.
--- @p @string absorbed_faction_key, The key of the faction to be absorbed.
function custom_starts:absorb_other_faction(absorbing_faction_key, absorbed_faction_key)
	local absorbed_faction = cm:get_faction(absorbed_faction_key)
	
	local absorbed_character_list = absorbed_faction:character_list();
	local absorbed_region_list = absorbed_faction:region_list();
	
	for i = 0, absorbed_character_list:num_items() - 1 do
		local cur_char = absorbed_character_list:item_at(i);
		
		if cur_char:is_null_interface() == false then
			cm:kill_character(cur_char:command_queue_index(), true);
		end
	end;
	
	for i = 0, absorbed_region_list:num_items() - 1 do
		local region_key = absorbed_region_list:item_at(i):name()
		cm:transfer_region_to_faction(region_key, absorbing_faction_key);
		cm:callback(function() 
			cm:heal_garrison(cm:get_region(region_key):cqi());
		end, 0.5);
	end;
end

--- @function primary_slot_change
--- @desc Change the primary building at the specified region to the specified building.
--- @p @string region, The region at which the building should be changed.
--- @p @string building, The building to set the primary slot of the region to.
--- @r @boolean Returns <code>true</code> of the primary slot successfully changed to the specified building key, otherwise returns <code>false</code>.
function custom_starts:primary_slot_change(region, building)
	--check the region key is a string
	if not is_string(region) then
		script_error("ERROR: primary_slot_change() called but supplied target region key [" .. tostring(region) .. "] is not a string");
		return false;
	end;
	
	--check the region key is a string
	if not is_string(building) then
		script_error("ERROR: primary_slot_change() called but supplied target building key [" .. tostring(building) .. "] is not a string");
		return false;
	end;

	local region_interface = cm:get_region(region);
	if region_interface:is_null_interface() then
		script_error("ERROR: primary_slot_change() called but supplied target region key [" .. region .. "] is not present in the campaign");
		return false;
	end;

	local result_building = cm:region_slot_instantly_upgrade_building(region_interface:settlement():primary_slot(), building);
	cm:callback(function() cm:heal_garrison(cm:get_region(region):cqi()) end, 0.5);
	
	return not result_building:is_null_interface() and result_building:name() == building;
end

--- @function port_slot_change
--- @desc Change the port slot at the specified region to the specified building.
--- @p @string region, The key of the region at which the port slot will change.
--- @p @string building, The key of the building to change the slot to.
--- @r @boolean Returns <code>true</code> of the primary slot successfully changed to the specified building key, otherwise returns <code>false</code>.
function custom_starts:port_slot_change(region, building)
	--check the region key is a string
	if not is_string(region) then
		script_error("ERROR: port_slot_change() called but supplied target region key [" .. tostring(region) .. "] is not a string");
		return false;
	end;
	
	--check the region key is a string
	if not is_string(building) then
		script_error("ERROR: port_slot_change() called but supplied target building key [" .. tostring(building) .. "] is not a string");
		return false;
	end;

	local region_interface = cm:get_region(region);
	if region_interface:is_null_interface() then
		script_error("ERROR: port_slot_change() called but supplied target region key [" .. region .. "] is not present in the campaign");
		return false;
	end;

	local port_slot = region_interface:settlement():port_slot();
	if port_slot:is_null_interface() then
		script_error("ERROR: port_slot_change() called but supplied target region [" .. region .. "] does not have a port");
		return false;
	end;

	local result_building = cm:region_slot_instantly_upgrade_building(port_slot, building);
	cm:callback(function() cm:heal_garrison(cm:get_region(region):cqi()) end, 0.5);
	
	return not result_building:is_null_interface() and result_building:name() == building;
end

--- @function secondary_slot_change
--- @desc Change the secondary slot at the given index of a specified region to a building.
--- @p @string region, The key of the region at which to change the building.
--- @p @number slot_index, The zero-based index of the secondary slot at which to change the building.
--- @p @string building, The key of the building to which the slot should change.
--- @r @boolean Returns <code>true</code> of the primary slot successfully changed to the specified building key, otherwise returns <code>false</code>.
function custom_starts:secondary_slot_change(region, slot_index, building)
	--check the region key is a string
	if not is_string(region) then
		script_error("ERROR: secondary_slot_change() called but supplied target region key [" .. tostring(region) .. "] is not a string");
		return false;
	end;
	
	-- check the slot index is a number
	if not is_number(slot_index) then
		script_error("ERROR: secondary_slot_change() called but the supplied slot index [" .. tostring(slot_index) .. "] is not a number or nil");
		return false;
	end;
	
	--check the region key is a string
	if not is_string(building) then
		script_error("ERROR: secondary_slot_change() called but supplied target building key [" .. tostring(building) .. "] is not a string");
		return false;
	end;

	local region_interface = cm:get_region(region);
	if region_interface:is_null_interface() then
		script_error("ERROR: secondary_slot_change() called but supplied target region key [" .. region .. "] is not present in the campaign");
		return false;
	end;

	local active_secondary_slots = region_interface:settlement():active_secondary_slots();
	if not (active_secondary_slots:num_items() > slot_index) then
		script_error("ERROR: secondary_slot_change() called but the supplied active slot index of [" .. tostring(slot_index) .. "] is out of bounds");
		return false;
	end;

	local result_building = cm:region_slot_instantly_upgrade_building(active_secondary_slots:item_at(slot_index), building);
	cm:callback(function() cm:heal_garrison(cm:get_region(region):cqi()) end, 0.5);
	
	return not result_building:is_null_interface() and result_building:name() == building;
end

--- @function create_army
--- @desc Spawn an army on the map for a certain faction using either a quantity of units, or a random army template key.
--- @p @string faction_name, The key of the faction the army will belong to.
--- @p @number or @string unit_list, The quantity of units to be spawned (in which case random units are created) or the key of the random army template to be used.
--- @p @string region_name, The key of the region the army will spawn in.
--- @p @number x_pos, The x coordinate the army will spawn at.
--- @p @number y_pos, The y coordinate the army will spawn at.
--- @p @string agent_subtype, Character subtype of character at the head of the army.
--- @p @boolean is_leader, Make the spawned character the faction leader.
--- @p @table name_table, An array of 4 names, corresponding to the forename, clan name, family name, and other name of the general. Unfilled names must be empty strings. These should be given in the localised text lookup format i.e. a key from the <code>names</code> table with "names_name_" prepended.
function custom_starts:create_army(faction_name, unit_list, region_name, x_pos, y_pos, agent_subtype, is_leader, name_table)
	--check the faction key is a string
	if not is_string(faction_name) then
		script_error("ERROR: create_army() called but supplied target faction key [" .. tostring(faction_name) .. "] is not a string");
		return false;
	end
	
	--check the unit_list is a list of strings or nil (if nil then we will generate a random army)
	if is_number(unit_list) then
		local num_units = unit_list; 
		if num_units > 19 then
			num_units = 19;
		end
		unit_list = self:generate_random_army(cm:get_faction(faction_name):subculture(), num_units);
	elseif not is_string(unit_list) then
		script_error("ERROR: create_army() called but supplied unit_list [" .. tostring(unit_list) .. "] is not a number or table");
		return false;
	end;
	
	--check the region key is a string
	if not is_string(region_name) then
		script_error("ERROR: create_army() called but supplied target region key [" .. tostring(region_name) .. "] is not a string");
		return false;
	end;
	
	--check the x position is a number
	if not is_number(x_pos) then
		script_error("ERROR: create_army() called but supplied x position [" .. tostring(x_pos) .. "] is not a number");
		return false;
	end;
	
	--check the y position is a number
	if not is_number(y_pos) then
		script_error("ERROR: create_army() called but supplied y position [" .. tostring(y_pos) .. "] is not a number");
		return false;
	end;
	
	--check the agent subtype is a string
	if not is_string(agent_subtype) then
		script_error("ERROR: create_army() called but supplied agent subtype [" .. tostring(agent_subtype) .. "] is not a string");
		return false;
	end
	
	--check the faction leader boolean is a boolean
	if not is_boolean(is_leader) then
		script_error("ERROR: create_army() called but supplied faction leader boolean [" .. tostring(is_leader) .. "] is not a boolean");
		return false;
	end
	
	local forename = "";
	local clan_name = "";
	local family_name = "";
	local other_name = "";
	
	if name_table and is_table(name_table) and #name_table == 4 then
		forename = name_table[1];
		clan_name = name_table[2];
		family_name = name_table[3];
		other_name = name_table[4];
	end
	
	cm:create_force_with_general(
		-- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, make_faction_leader, success_callback
		faction_name,
		unit_list,
		region_name,
		x_pos,
		y_pos,
		"general",
		agent_subtype,
		forename,			-- Felix
		clan_name,
		family_name,		-- Hellborg
		other_name,
		is_leader
	);
end

--- @function create_army_for_faction_leader
--- @desc Create an army for the leader of the specified faction.
--- @p @string faction_name, The key of the faction whose leader gets an army.
--- @p @string region_name, The key of the region the army will spawn in.
--- @p @number x_pos, The x coordinate at which the army will spawn.
--- @p @number y_pos, The y coordinate at which the army will spawn.
--- @p @number or @string unit_list, The quantity of units to be spawned (in which case random units are created) or the key of the random army template to be used.
function custom_starts:create_army_for_faction_leader(faction_name, region_name, x_pos, y_pos, unit_list)
	--check the faction key is a string
	if not is_string(faction_name) then
		script_error("ERROR: create_army_for_faction_leader() called but supplied target faction key [" .. tostring(faction_name) .. "] is not a string");
		return false;
	end
	
	--check the region key is a string
	if not is_string(region_name) then
		script_error("ERROR: create_army_for_faction_leader() called but supplied target region key [" .. tostring(region_name) .. "] is not a string");
		return false;
	end;
	
	--check the x position is a number
	if not is_number(x_pos) then
		script_error("ERROR: create_army_for_faction_leader() called but supplied x position [" .. tostring(x_pos) .. "] is not a number");
		return false;
	end;
	
	--check the y position is a number
	if not is_number(y_pos) then
		script_error("ERROR: create_army_for_faction_leader() called but supplied y position [" .. tostring(y_pos) .. "] is not a number");
		return false;
	end;
	
	--check the unit_list is a list of strings or nil (if nil then we will generate a random army)
	if is_number(unit_list) then
		local num_units = unit_list; 
		if num_units > 19 then
			num_units = 19;
		end
		unit_list = self:generate_random_army(cm:get_faction(faction_name):subculture(), num_units);
	elseif not is_string(unit_list) then
		script_error("ERROR: create_army_for_faction_leader() called but supplied unit_list [" .. tostring(region_name) .. "] is not a number or table");
		return false;
	end	
	
	cm:create_force_with_existing_general(
		"character_cqi:" .. cm:get_faction(faction_name):faction_leader():command_queue_index(),
		faction_name,
		unit_list,
		region_name,
		x_pos,
		y_pos
	);
end

--- @function teleport_character
--- @desc Teleport a character of a given faction, whichever character is closest to the provided start coordinates.
--- @p @string faction_name, The key of the faction the teleported character belongs to.
--- @p @number start_x, The starting x coordinate - the closest character of the given faction to this position will be teleported.
--- @p @number start_y, The starting y coordinate - the closest character of the given faction to this position will be teleported.
--- @p @number end_x, The teleport x coordinate.
--- @p @number end_y, The teleport y coordinate.
--- @p @boolean is_general, Whether or not the target character is a general. This informs which character nearest the starting coord is selected.
function custom_starts:teleport_character(faction_name, start_x, start_y, end_x, end_y, is_general)
	--check the faction key is a string
	if not is_string(faction_name) then
		script_error("ERROR: teleport_character() called but supplied target faction key [" .. tostring(faction_name) .. "] is not a string");
		return false;
	end;
	
	--check the starting x co-ordinate is a number
	if not is_number(start_x) then
		script_error("ERROR: teleport_character() called but supplied starting x co-ordinate [" .. tostring(start_x) .. "] is not a number");
		return false;
	end;
	
	--check the starting y co-ordinate is a number
	if not is_number(start_y) then
		script_error("ERROR: teleport_character() called but supplied starting y co-ordinate [" .. tostring(start_y) .. "] is not a number");
		return false;
	end;
	
	--check the end x co-ordinate is a number
	if not is_number(end_x) then
		script_error("ERROR: teleport_character() called but supplied end x co-ordinate [" .. tostring(end_x) .. "] is not a number");
		return false;
	end;

	--check the end y co-ordinate is a number
	if not is_number(end_y) then
		script_error("ERROR: teleport_character() called but supplied end y co-ordinate [" .. tostring(end_y) .. "] is not a number");
		return false;
	end;
	
	--check the end y co-ordinate is a number
	if not is_boolean(is_general) then
		script_error("ERROR: teleport_character() called but supplied  is_general [" .. tostring(is_general) .. "] is not a boolean");
		return false;
	end;
	
	local custom_start_char = cm:get_closest_character_to_position_from_faction(faction_name, start_x, start_y, is_general, false);
		
	if custom_start_char then
		cm:teleport_to(cm:char_lookup_str(custom_start_char), end_x, end_y);
	end
end

--- @function teleport_character_faction_leader
--- @desc Teleport the leader of the specified faction to these coordinates.
--- @p @string faction_key, The name of the faction whose leader is to be teleported.
--- @p @number target_x, The x coordinate to teleport to.
--- @p @number target_y, The y coordinate to teleport to.
function custom_starts:teleport_character_faction_leader(faction_key, target_x, target_y)
	local faction = cm:model():world():faction_by_key(faction_key); 

	if faction:is_null_interface() == false then
		local leader = faction:faction_leader();
		cm:teleport_to(cm:char_lookup_str(leader), target_x, target_y);
	end
end

--- @function hide_faction_leader
--- @desc Hide the leader of the faction by killing them and restricting their recruitment.
--- @p @string faction_key, The key of the faction whose leader will be hidden.
--- @p @number startpos_ID, The startpos ID of the general to have their recruitment locked. This ought to match the leader of the specified faction.
--- @p @boolean kill_army, Kill the faction leader's entire army, if true.
function custom_starts:hide_faction_leader(faction_key, startpos_ID, kill_army)
	cm:callback(function()
		local faction = cm:model():world():faction_by_key(faction_key);

		if faction:is_null_interface() == false then
			local leader = faction:faction_leader();
			local leader_cqi = leader:command_queue_index();
			cm:kill_character(leader_cqi, kill_army);
			cm:lock_starting_character_recruitment(startpos_ID, faction_key);
		end
	end, 0.5);
end

--- @function modify_units_in_army
--- @desc Add and remove the provided lists of units (removals occur per-instance, so three consecutive unit keys results in the removal of 3 units), to the factions' army found closest to the provided coordinate.
--- @p @string faction_name, The key of the faction for which armies close to the coordinates will be considered.
--- @p @number pos_x, The x coordinate close to the target army.
--- @p @number pos_y, The y coordinate close to the target army.
--- @p @table add_units_table, A list of unit keys to be added. Provide an empty table if no units wanted.
--- @p @table remove_units_table, A list of unit keys to be removed, per-instance of that unit. Provide an empty table if no units wanted.
--- @p [opt=nil] @string general_forename, The forename of the general whose army will be adjusted. Can be used to handle different starting generals for the same faction receiving different starting units. Otherwise can be left blank.
--- @p [opt=nil] @string general_surname, The surname of the general whose army will be adjusted.
function custom_starts:modify_units_in_army(faction_name, pos_x, pos_y, add_units_table, remove_units_table, general_forename, general_surname)	
	local remove_units_table = remove_units_table or {}
	local add_units_table = add_units_table or {}

	--check the faction key is a string
	if not is_string(faction_name) then
		script_error("ERROR: modify_units_in_army() called but supplied target faction key [" .. tostring(faction_name) .. "] is not a string");
		return false;
	end;

	--check the starting x co-ordinate is a number
	if not is_number(pos_x) then
		script_error("ERROR: modify_units_in_army() called but supplied x co-ordinate [" .. tostring(pos_x) .. "] is not a number");
		return false;
	end;

	--check the starting y co-ordinate is a number
	if not is_number(pos_y) then
		script_error("ERROR: modify_units_in_army() called but supplied y co-ordinate [" .. tostring(pos_y) .. "] is not a number");
		return false;
	end;

	--check the add_units_table is a table
	if not is_table(add_units_table) then
		script_error("ERROR: modify_units_in_army() called but supplied units to add [" .. tostring(add_units_table) .. "] is not a table");
		return false;
	end;

	--check the remove_units_table is a table
	if not is_table(remove_units_table) then
		script_error("ERROR: modify_units_in_army() called but supplied units to remove [" .. tostring(remove_units_table) .. "] is not a table");
		return false;
	end;

	--check the forename is a string
	if general_forename ~= nil and is_string(general_forename) == false then
		script_error("ERROR: modify_units_in_army() called but supplied target general_forename [" .. tostring(general_forename) .. "] is not a string");
		return false;
	end;

	--check the surname is a string or nil
	if general_surname ~= nil and is_string(general_surname) == false then
		script_error("ERROR: modify_units_in_army() called but supplied target general_surname [" .. tostring(general_surname) .. "] is not a string");
		return false;
	end;

	local general = cm:get_closest_general_to_position_from_faction(faction_name, pos_x, pos_y, false);

	if((general_forename == nil and general_surname == nil) or (general:get_forename() == general_forename and general:get_surname() == general_surname)) then
		local general_lookup_str = cm:char_lookup_str(general)

		for i = 1, #remove_units_table do
			-- Remove units before we add them to avoid going over any army/unit caps.
			cm:remove_unit_from_character(general_lookup_str, remove_units_table[i])
		end

		for i = 1, #add_units_table do
			cm:grant_unit_to_character(general_lookup_str, add_units_table[i]);
		end
	end
end

--- @function add_xp_to_units
--- @desc Add XP to each instance of the given unit key in all of a faction's armies.
--- @p @string faction_name, The faction for which all units of a type will receive XP.
--- @p @string unit_key, The key of the unit type to receive XP.
--- @p @number experience, The amount of XP given to each unit.
function custom_starts:add_xp_to_units(faction_name, unit_key, experience)
	--check the faction key is a string
	if not is_string(faction_name) then
		script_error("ERROR: add_xp_to_units() called but supplied target faction key [" .. tostring(faction_name) .. "] is not a string");
		return false;
	end;
	
	--check the unit key is a string
	if not is_string(faction_name) then
		script_error("ERROR: add_xp_to_units() called but supplied target unit key [" .. tostring(unit_key) .. "] is not a string");
		return false;
	end;
	
	--check the starting y co-ordinate is a number
	if not is_number(experience) then
		script_error("ERROR: add_xp_to_units() called but supplied experience [" .. tostring(experience) .. "] is not a number");
		return false;
	end;
		
	local military_force_list = cm:get_faction(faction_name):military_force_list();
	for i = 0, military_force_list:num_items() - 1 do
		local mf = military_force_list:item_at(i);
		local ul = mf:unit_list();

		for j = 0, ul:num_items() - 1 do
			local unit = ul:item_at(j);	
			
			if unit:unit_key() == unit_key then
				cm:add_experience_to_unit(unit, experience);
			end
		end
	end
end

--- @function force_diplomacy_change
--- @desc Force a change in diplomacy between the two factions.
--- @p @string s_faction, The source faction.
--- @p @string t_faction, The target faction.
--- @p @string d_type, The type of diplomacy to enforce. This is currently limited to 'peace' or 'war'. Allies are not invited to war.
function custom_starts:force_diplomacy_change(s_faction, t_faction, d_type)
	--check the region key is a string
	if not is_string(s_faction) then
		script_error("ERROR: force_diplomacy_change() called but supplied source faction key [" .. tostring(s_faction) .. "] is not a string");
		return false;
	end;
	
	--check the slot number is a number
	if not is_string(t_faction) then
		script_error("ERROR: force_diplomacy_change() called but supplied target faction key [" .. tostring(t_faction) .. "] is not a string");
		return false;
	end;
	
	--check the region key is a string
	if not is_string(d_type) then
		script_error("ERROR: force_diplomacy_change() called but supplied diplomacy type [" .. tostring(d_type) .. "] is not a string");
		return false;
	end
	
	if d_type == "war" then
		cm:force_declare_war(s_faction, t_faction, false, false);
	elseif d_type == "peace" then
		cm:force_make_peace(s_faction, t_faction);
	else
		script_error("ERROR: force_diplomacy_change() called but supplied diplomacy type [" .. tostring(d_type) .. "] is not a valid type or has not been implemented");
	end
end

--- @function block_diplomacy
--- @desc Restricts or unrestricts diplomacy types between two factions, using the diplomacy types available in <code>campaign_manager:force_diplomacy</code>. Groups of factions may be specified with the strings <code>"all"</code>, <code>"faction:faction_key"</code>, <code>"subculture:subculture_key"</code> or <code>"culture:culture_key"</code>.
--- @p @string s_faction, The source faction.
--- @p @string t_faction, The target faction.
--- @p @string diplomacy, The diplomacy type being restricted or allowed, as specified in <code>campaign_manager:force_diplomacy</code>.
--- @p @boolean can_offer, If the source faction can offer this diplomatic relationship to the target.
--- @p @boolean can_offer, If the source faction can accept this diplomatic relationship to the target.
function custom_starts:block_diplomacy(source, target, diplomacy, can_offer, can_accept)
	--check the source is a string
	if not is_string(source) then
		script_error("ERROR: block_diplomacy() called but supplied source [" .. tostring(source) .. "] is not a string");
		return false;
	end;
	
	--check the target is a string
	if not is_string(target) then
		script_error("ERROR: block_diplomacy() called but supplied target [" .. tostring(target) .. "] is not a string");
		return false;
	end;
	
	--check the diplomacy is a string
	if not is_string(diplomacy) then
		script_error("ERROR: block_diplomacy() called but supplied diplomacy [" .. tostring(diplomacy) .. "] is not a string");
		return false;
	end;
	
	--check the can_offer flag is a boolean
	if not is_boolean(can_offer) then
		script_error("ERROR: block_diplomacy() called but supplied can_offer flag is a boolean [" .. tostring(can_offer) .. "] is not a boolean");
		return false;
	end
	
	--check the can_accept flag is a boolean
	if not is_boolean(can_accept) then
		script_error("ERROR: block_diplomacy() called but supplied can_accept flag is a boolean [" .. tostring(can_accept) .. "] is not a boolean");
		return false;
	end
	
	cm:force_diplomacy(source, target, diplomacy, can_offer, can_accept);
end

--- @function abandon_region
--- @desc Abandon the specified region key, turning it to ruins.
--- @p @string region_key, The key of the region to be abandoned.
function custom_starts:abandon_region(region_key)
	--check the region key is a string
	if not is_string(region_key) then
		script_error("ERROR: abandon_region() called but supplied region key [" .. tostring(region_key) .. "] is not a string");
		return false;
	end
	
	cm:set_region_abandoned(region_key);

	cm:callback(function()
		cm:heal_garrison(cm:get_region(region_key):cqi());
	end, 0.5);
end

--- @function kill_faction
--- @desc Kills the specified faction key, abandoning all its regions and killing all armies.
--- @p @string faction_key, The key of the faction to be killed.
function custom_starts:kill_faction(faction_key)
	--check the faction key is a string
	if not is_string(faction_key) then
		script_error("ERROR: kill_faction() called but supplied region key [" .. tostring(faction_key) .. "] is not a string");
		return false;
	end;
	
	local faction = cm:model():world():faction_by_key(faction_key); 

	if faction:is_null_interface() == false then
		cm:kill_all_armies_for_faction(faction);

		local region_list = faction:region_list();

		for j = 0, region_list:num_items() - 1 do
			local region = region_list:item_at(j):name();
			cm:set_region_abandoned(region);
		end
	end
end

function custom_starts:replace_faction(faction_key, replace_with_faction_key)
	local existing_faction = cm:get_faction(faction_key);
	
	cm:disable_event_feed_events(true, "wh_event_category_conquest", "", "");
	cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "");
	
	local existing_character_list = existing_faction:character_list();
	local existing_region_list = existing_faction:region_list();
	
	for i = 0, existing_character_list:num_items() - 1 do
		local cur_char = existing_character_list:item_at(i);
		
		if cur_char:is_null_interface() == false then
			cm:kill_character(cur_char:command_queue_index(), true);
		end
	end;
	
	for i = 0, existing_region_list:num_items() - 1 do
		local region_key = existing_region_list:item_at(i):name()
		cm:transfer_region_to_faction(region_key, replace_with_faction_key);
		cm:callback(function() 
			cm:heal_garrison(cm:get_region(region_key):cqi());
		end, 0.5);
	end;

	cm:disable_event_feed_events(false, "wh_event_category_conquest", "", "");
	cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "");
end

--pass the faction(string), x position(number), y position(number), effect bundle key(string), bundle duration(number)
--- @function apply_effect_bundle_character
--- @desc Apply an effect bundle to the character of the specified faction nearest the provided location.
--- @p @string faction_name, The key name of the faction for which characters will be considered.
--- @p @number x_pos, The x coordinate from which the target character is searched.
--- @p @number y_pos, The y coordinate from which the target character is searched.
--- @p @number bundle, The key of the bundle to apply.
--- @p @number duration, The turn duration the bundle will last for, 0 being infinite turns.
function custom_starts:apply_effect_bundle_character(faction_name, x_pos, y_pos, bundle, duration)
	--check the faction key is a string
	if not is_string(faction_name) then
		script_error("ERROR: apply_effect_bundle_character() called but supplied target faction key [" .. tostring(faction_name) .. "] is not a string");
		return false;
	end;
	
	--check the x co-ordinate is a number
	if not is_number(x_pos) then
		script_error("ERROR: apply_effect_bundle_character() called but supplied x co-ordinate [" .. tostring(x_pos) .. "] is not a number");
		return false;
	end;
	
	--check the y co-ordinate is a number
	if not is_number(y_pos) then
		script_error("ERROR: apply_effect_bundle_character() called but supplied y co-ordinate [" .. tostring(y_pos) .. "] is not a number");
		return false;
	end;
	
	--check the effetc bundle key is a string
	if not is_string(bundle) then
		script_error("ERROR: apply_effect_bundle_character() called but supplied effect bundle key [" .. tostring(bundle) .. "] is not a string");
		return false;
	end;
	
	--check the effect bundle duration is a number
	if not is_number(duration) then
		script_error("ERROR: apply_effect_bundle_character() called but supplied effect bundle duration [" .. tostring(duration) .. "] is not a number");
		return false;
	end;
	
	local custom_start_char = cm:get_closest_character_to_position_from_faction(faction_name, x_pos, y_pos, true, false);
		
	if custom_start_char then
		cm:apply_effect_bundle_to_characters_force(bundle, custom_start_char:cqi(), duration);
	end
end

--- @function force_change_faction_cai_personality
--- @desc Force the specified faction to adopt the specified AI personality.
--- @p @string faction_key, Faction key
--- @p @string personality_key, Personality key
function custom_starts:force_change_faction_cai_personality(faction_key, personality_key)
	if validate.is_string(faction_key) and validate.is_string(personality_key) then
		cm:force_change_cai_faction_personality(faction_key, personality_key);
	end
end

--- @function add_pooled_resource_to_faction
--- @desc Adjusts specified pooled resource to target faction.
--- @p @string faction_name, The faction name to adjust the specified pooled resource for.
--- @p @string pooled_resource_key, The pooled resource to adjust values for.
--- @p @string pooled_resource_factor_key, The factor through which the resource is adjusted for the faction
--- @p @number, the amount to adjust by
function custom_starts:adjust_pooled_resource_to_faction(faction_name, pooled_resource, pooled_resource_factor, amount)

	--check the faction key is a string
	validate.is_string(faction_name)

	--check the faction key is a string
	validate.is_string(pooled_resource)

	--check the faction key is a string
	validate.is_string(pooled_resource_factor)

	--check the starting x co-ordinate is a number
	validate.is_number(amount)

	cm:faction_add_pooled_resource(faction_name, pooled_resource, pooled_resource_factor, amount)
end

--- @function generate_random_army
--- @desc Generate a random army using pre-defined army sets per subculture.
--- @p @string subculture, The subculture of the army to be generated: each subculture has a particular 'standard' army template in this function.
--- @p @number num_units, The size of the army to be generated.
--- @r @string Returns a table of unit keys representing the army that was generated.
function custom_starts:generate_random_army(subculture, num_units)
	local ram = random_army_manager;
	ram:remove_force("custom_start_random_army");
	ram:new_force("custom_start_random_army");
	
	if subculture == "wh_main_sc_emp_empire" then
		--Infantry
		ram:add_unit("custom_start_random_army", "wh_main_emp_inf_swordsmen", 20);
		ram:add_unit("custom_start_random_army", "wh_main_emp_inf_spearmen_0", 12);
		ram:add_unit("custom_start_random_army", "wh_main_emp_inf_spearmen_1", 9);
		ram:add_unit("custom_start_random_army", "wh_main_emp_inf_halberdiers", 2);
		ram:add_unit("custom_start_random_army", "wh_main_emp_inf_greatswords", 1);
		ram:add_unit("custom_start_random_army", "wh_dlc04_emp_inf_flagellants_0", 6);
		ram:add_unit("custom_start_random_army", "wh_main_emp_inf_crossbowmen", 8);
		ram:add_unit("custom_start_random_army", "wh_dlc04_emp_inf_free_company_militia_0", 4);
		ram:add_unit("custom_start_random_army", "wh_main_emp_inf_handgunners", 2);
		
		--Cavalry
		ram:add_unit("custom_start_random_army", "wh_main_emp_cav_empire_knights", 6);
		ram:add_unit("custom_start_random_army", "wh_main_emp_cav_reiksguard", 2);
		ram:add_unit("custom_start_random_army", "wh_main_emp_cav_pistoliers_1", 7);
		ram:add_unit("custom_start_random_army", "wh_main_emp_cav_outriders_0", 2);
		ram:add_unit("custom_start_random_army", "wh_main_emp_cav_outriders_1", 2);
		ram:add_unit("custom_start_random_army", "wh_dlc04_emp_cav_knights_blazing_sun_0", 1);
		ram:add_unit("custom_start_random_army", "wh_main_emp_cav_demigryph_knights_0", 1);
		ram:add_unit("custom_start_random_army", "wh_main_emp_cav_demigryph_knights_1", 1);
		
		--Artillery
		ram:add_unit("custom_start_random_army", "wh_main_emp_art_mortar", 6);
		ram:add_unit("custom_start_random_army", "wh_main_emp_art_great_cannon", 4);
		ram:add_unit("custom_start_random_army", "wh_main_emp_art_helblaster_volley_gun", 1);
		ram:add_unit("custom_start_random_army", "wh_main_emp_art_helstorm_rocket_battery", 1);
		
		--Vehicles
		ram:add_unit("custom_start_random_army", "wh_main_emp_veh_steam_tank", 1);
		ram:add_unit("custom_start_random_army", "wh_main_emp_veh_luminark_of_hysh_0", 1);		
		
	elseif subculture == "wh_main_sc_dwf_dwarfs" then
		--Infantry
		ram:add_unit("custom_start_random_army", "wh_main_dwf_inf_miners_0", 18);
		ram:add_unit("custom_start_random_army", "wh_main_dwf_inf_miners_1", 6);
		ram:add_unit("custom_start_random_army", "wh_main_dwf_inf_dwarf_warrior_0", 15);
		ram:add_unit("custom_start_random_army", "wh_main_dwf_inf_dwarf_warrior_1", 10);
		ram:add_unit("custom_start_random_army", "wh_main_dwf_inf_hammerers", 1);
		ram:add_unit("custom_start_random_army", "wh_main_dwf_inf_ironbreakers", 1);
		ram:add_unit("custom_start_random_army", "wh_main_dwf_inf_longbeards", 4);
		ram:add_unit("custom_start_random_army", "wh_main_dwf_inf_longbeards_1", 2);
		ram:add_unit("custom_start_random_army", "wh_main_dwf_inf_slayers", 3);
		ram:add_unit("custom_start_random_army", "wh2_dlc10_dwf_inf_giant_slayers", 1);
		ram:add_unit("custom_start_random_army", "wh_main_dwf_inf_quarrellers_0", 10);
		ram:add_unit("custom_start_random_army", "wh_main_dwf_inf_quarrellers_1", 4);
		ram:add_unit("custom_start_random_army", "wh_main_dwf_inf_thunderers_0", 3);
		ram:add_unit("custom_start_random_army", "wh_main_dwf_inf_irondrakes_0", 1);
		ram:add_unit("custom_start_random_army", "wh_main_dwf_inf_irondrakes_2", 1);
		ram:add_unit("custom_start_random_army", "wh_dlc06_dwf_inf_rangers_0", 2);
		ram:add_unit("custom_start_random_army", "wh_dlc06_dwf_inf_rangers_1", 2);
		ram:add_unit("custom_start_random_army", "wh_dlc06_dwf_inf_bugmans_rangers_0", 1);
		
		--Artillery
		ram:add_unit("custom_start_random_army", "wh_main_dwf_art_grudge_thrower", 8);
		ram:add_unit("custom_start_random_army", "wh_main_dwf_art_cannon", 2);
		ram:add_unit("custom_start_random_army", "wh_main_dwf_art_organ_gun", 1);
		ram:add_unit("custom_start_random_army", "wh_main_dwf_art_flame_cannon", 1);
		
		--Vehicles
		ram:add_unit("custom_start_random_army", "wh_main_dwf_veh_gyrocopter_0", 1);
		ram:add_unit("custom_start_random_army", "wh_main_dwf_veh_gyrocopter_1", 1);
		ram:add_unit("custom_start_random_army", "wh_main_dwf_veh_gyrobomber", 1);
		
	elseif subculture == "wh_main_sc_vmp_vampire_counts" then
		--Infantry
		ram:add_unit("custom_start_random_army", "wh_main_vmp_inf_zombie", 18);
		ram:add_unit("custom_start_random_army", "wh_main_vmp_inf_skeleton_warriors_0", 18);
		ram:add_unit("custom_start_random_army", "wh_main_vmp_inf_skeleton_warriors_1", 16);
		ram:add_unit("custom_start_random_army", "wh_main_vmp_inf_crypt_ghouls", 8);
		ram:add_unit("custom_start_random_army", "wh_main_vmp_inf_cairn_wraiths", 4);
		ram:add_unit("custom_start_random_army", "wh_main_vmp_inf_grave_guard_0", 1);
		ram:add_unit("custom_start_random_army", "wh_main_vmp_inf_grave_guard_1", 1);
		
		--Cavalry
		ram:add_unit("custom_start_random_army", "wh_main_vmp_cav_black_knights_0", 2);
		ram:add_unit("custom_start_random_army", "wh_main_vmp_cav_black_knights_3", 2);
		ram:add_unit("custom_start_random_army", "wh_main_vmp_cav_hexwraiths", 1);
		ram:add_unit("custom_start_random_army", "wh_dlc02_vmp_cav_blood_knights_0", 1);
		
		--Monsters
		ram:add_unit("custom_start_random_army", "wh_main_vmp_mon_fell_bats", 8);
		ram:add_unit("custom_start_random_army", "wh_main_vmp_mon_dire_wolves", 8);
		ram:add_unit("custom_start_random_army", "wh_main_vmp_mon_crypt_horrors", 2);
		ram:add_unit("custom_start_random_army", "wh_main_vmp_mon_vargheists", 2);
		ram:add_unit("custom_start_random_army", "wh_main_vmp_mon_varghulf", 1);
		ram:add_unit("custom_start_random_army", "wh_main_vmp_mon_terrorgheist", 1);
		
		--Vehicles
		ram:add_unit("custom_start_random_army", "wh_dlc04_vmp_veh_corpse_cart_0", 2);
		ram:add_unit("custom_start_random_army", "wh_dlc04_vmp_veh_corpse_cart_1", 1);
		ram:add_unit("custom_start_random_army", "wh_dlc04_vmp_veh_corpse_cart_2", 1);
		ram:add_unit("custom_start_random_army", "wh_main_vmp_veh_black_coach", 1);
		ram:add_unit("custom_start_random_army", "wh_dlc04_vmp_veh_mortis_engine_0", 1);
		
	elseif subculture == "wh_main_sc_grn_greenskins" then
		--Infantry
		ram:add_unit("custom_start_random_army", "wh_main_grn_inf_goblin_spearmen", 10);
		ram:add_unit("custom_start_random_army", "wh_dlc06_grn_inf_nasty_skulkers_0", 4);
		ram:add_unit("custom_start_random_army", "wh_main_grn_inf_night_goblins", 2);
		ram:add_unit("custom_start_random_army", "wh_main_grn_inf_night_goblin_fanatics", 1);
		ram:add_unit("custom_start_random_army", "wh_main_grn_inf_night_goblin_fanatics_1", 1);
		ram:add_unit("custom_start_random_army", "wh_main_grn_inf_orc_boyz", 16);
		ram:add_unit("custom_start_random_army", "wh_main_grn_inf_orc_big_uns", 4);
		ram:add_unit("custom_start_random_army", "wh_main_grn_inf_savage_orcs", 3);
		ram:add_unit("custom_start_random_army", "wh_main_grn_inf_savage_orc_big_uns", 2);
		ram:add_unit("custom_start_random_army", "wh_main_grn_inf_black_orcs", 1);
		ram:add_unit("custom_start_random_army", "wh_main_grn_inf_goblin_archers", 10);
		ram:add_unit("custom_start_random_army", "wh_main_grn_inf_night_goblin_archers", 4);
		ram:add_unit("custom_start_random_army", "wh_main_grn_inf_orc_arrer_boyz", 6);
		ram:add_unit("custom_start_random_army", "wh_main_grn_inf_savage_orc_arrer_boyz", 2);
		
		--Cavalry
		ram:add_unit("custom_start_random_army", "wh_main_grn_cav_goblin_wolf_riders_0", 5);
		ram:add_unit("custom_start_random_army", "wh_main_grn_cav_goblin_wolf_riders_1", 2);
		ram:add_unit("custom_start_random_army", "wh_main_grn_cav_goblin_wolf_chariot", 1);
		ram:add_unit("custom_start_random_army", "wh_main_grn_cav_forest_goblin_spider_riders_0", 2);
		ram:add_unit("custom_start_random_army", "wh_main_grn_cav_forest_goblin_spider_riders_1", 2);
		ram:add_unit("custom_start_random_army", "wh_dlc06_grn_inf_squig_herd_0", 1);
		ram:add_unit("custom_start_random_army", "wh_dlc06_grn_cav_squig_hoppers_0", 1);
		ram:add_unit("custom_start_random_army", "wh_main_grn_cav_orc_boar_boyz", 3);
		ram:add_unit("custom_start_random_army", "wh_main_grn_cav_orc_boar_boy_big_uns", 2);
		ram:add_unit("custom_start_random_army", "wh_main_grn_cav_orc_boar_chariot", 1);
		ram:add_unit("custom_start_random_army", "wh_main_grn_cav_savage_orc_boar_boyz", 1);
		ram:add_unit("custom_start_random_army", "wh_main_grn_cav_savage_orc_boar_boy_big_uns", 1);
		
		--Monsters
		ram:add_unit("custom_start_random_army", "wh_dlc06_grn_inf_squig_herd_0", 2);
		ram:add_unit("custom_start_random_army", "wh_main_grn_mon_trolls", 3);
		ram:add_unit("custom_start_random_army", "wh_main_grn_mon_giant", 1);
		ram:add_unit("custom_start_random_army", "wh_main_grn_mon_arachnarok_spider_0", 1);
		
		--Artillery
		ram:add_unit("custom_start_random_army", "wh_main_grn_art_goblin_rock_lobber", 4);
		ram:add_unit("custom_start_random_army", "wh_main_grn_art_doom_diver_catapult", 1);
		
	elseif subculture == "wh_main_sc_chs_chaos" then
		--Infantry
		ram:add_unit("custom_start_random_army", "wh_main_chs_inf_chaos_marauders_0", 18);
		ram:add_unit("custom_start_random_army", "wh_main_chs_inf_chaos_marauders_1", 13);
		ram:add_unit("custom_start_random_army", "wh_main_chs_inf_chaos_warriors_0", 8);
		ram:add_unit("custom_start_random_army", "wh_main_chs_inf_chaos_warriors_1", 3);
		ram:add_unit("custom_start_random_army", "wh_dlc01_chs_inf_chaos_warriors_2", 2);
		ram:add_unit("custom_start_random_army", "wh_dlc01_chs_inf_forsaken_0", 3);
		ram:add_unit("custom_start_random_army", "wh_dlc06_chs_inf_aspiring_champions_0", 2);
		ram:add_unit("custom_start_random_army", "wh_main_chs_inf_chosen_0", 1);
		ram:add_unit("custom_start_random_army", "wh_main_chs_inf_chosen_1", 1);
		ram:add_unit("custom_start_random_army", "wh_dlc01_chs_inf_chosen_2", 1);
		
		--Cavalry
		ram:add_unit("custom_start_random_army", "wh_main_chs_cav_marauder_horsemen_0", 8);
		ram:add_unit("custom_start_random_army", "wh_main_chs_cav_marauder_horsemen_1", 4);
		ram:add_unit("custom_start_random_army", "wh_dlc06_chs_cav_marauder_horsemasters_0", 2);
		ram:add_unit("custom_start_random_army", "wh_main_chs_cav_chaos_chariot", 1);
		ram:add_unit("custom_start_random_army", "wh_dlc01_chs_cav_gorebeast_chariot", 1);
		ram:add_unit("custom_start_random_army", "wh_main_chs_cav_chaos_knights_0", 1);
		ram:add_unit("custom_start_random_army", "wh_main_chs_cav_chaos_knights_1", 1);
		
		--Monsters
		ram:add_unit("custom_start_random_army", "wh_main_chs_mon_chaos_warhounds_0", 12);
		ram:add_unit("custom_start_random_army", "wh_main_chs_mon_chaos_warhounds_1", 6);
		ram:add_unit("custom_start_random_army", "wh_main_chs_mon_trolls", 3);
		ram:add_unit("custom_start_random_army", "wh_dlc01_chs_mon_trolls_1", 1);
		ram:add_unit("custom_start_random_army", "wh_main_chs_mon_chaos_spawn", 2);
		ram:add_unit("custom_start_random_army", "wh_dlc06_chs_feral_manticore", 2);
		ram:add_unit("custom_start_random_army", "wh_main_chs_mon_giant", 1);
		ram:add_unit("custom_start_random_army", "wh_dlc01_chs_mon_dragon_ogre", 1);
		ram:add_unit("custom_start_random_army", "wh_dlc01_chs_mon_dragon_ogre_shaggoth", 1);
		
		--Artillery
		ram:add_unit("custom_start_random_army", "wh_main_chs_art_hellcannon", 1);
		
	elseif subculture == "wh_dlc03_sc_bst_beastmen" then
		--Infantry
		ram:add_unit("custom_start_random_army", "wh_dlc03_bst_inf_ungor_herd_1", 16);
		ram:add_unit("custom_start_random_army", "wh_dlc03_bst_inf_ungor_spearmen_0", 16);
		ram:add_unit("custom_start_random_army", "wh_dlc03_bst_inf_ungor_spearmen_1", 8);
		ram:add_unit("custom_start_random_army", "wh_dlc03_bst_inf_gor_herd_0", 6);
		ram:add_unit("custom_start_random_army", "wh_dlc03_bst_inf_gor_herd_1", 2);
		ram:add_unit("custom_start_random_army", "wh_dlc03_bst_inf_bestigor_herd_0", 1);
		ram:add_unit("custom_start_random_army", "wh_dlc03_bst_inf_ungor_raiders_0", 10);
		
		--Cavalry
		ram:add_unit("custom_start_random_army", "wh_dlc03_bst_cav_razorgor_chariot_0", 1);
		ram:add_unit("custom_start_random_army", "wh_dlc03_bst_inf_centigors_0", 4);
		ram:add_unit("custom_start_random_army", "wh_dlc03_bst_inf_centigors_1", 2);
		ram:add_unit("custom_start_random_army", "wh_dlc03_bst_inf_centigors_2", 2);
		
		--Monsters
		ram:add_unit("custom_start_random_army", "wh_dlc03_bst_inf_chaos_warhounds_0", 10);
		ram:add_unit("custom_start_random_army", "wh_dlc03_bst_inf_chaos_warhounds_1", 6);
		ram:add_unit("custom_start_random_army", "wh_dlc03_bst_inf_razorgor_herd_0", 2);
		ram:add_unit("custom_start_random_army", "wh_dlc05_bst_mon_harpies_0", 8);
		ram:add_unit("custom_start_random_army", "wh_dlc03_bst_mon_chaos_spawn_0", 2);
		ram:add_unit("custom_start_random_army", "wh_dlc03_bst_inf_minotaurs_0", 2);
		ram:add_unit("custom_start_random_army", "wh_dlc03_bst_inf_minotaurs_1", 1);
		ram:add_unit("custom_start_random_army", "wh_dlc03_bst_inf_minotaurs_2", 1);
		ram:add_unit("custom_start_random_army", "wh_dlc03_bst_mon_giant_0", 1);
		ram:add_unit("custom_start_random_army", "wh_dlc03_bst_inf_cygor_0", 1);
		
	elseif subculture == "wh_dlc05_sc_wef_wood_elves" then
		--Infantry
		ram:add_unit("custom_start_random_army", "wh_dlc05_wef_inf_eternal_guard_0", 16);
		ram:add_unit("custom_start_random_army", "wh_dlc05_wef_inf_eternal_guard_1", 12);
		ram:add_unit("custom_start_random_army", "wh_dlc05_wef_inf_dryads_0", 10);
		ram:add_unit("custom_start_random_army", "wh_dlc05_wef_inf_wardancers_0", 3);
		ram:add_unit("custom_start_random_army", "wh_dlc05_wef_inf_wardancers_1", 1);
		ram:add_unit("custom_start_random_army", "wh_dlc05_wef_inf_wildwood_rangers_0", 1);
		ram:add_unit("custom_start_random_army", "wh_dlc05_wef_inf_glade_guard_0", 10);
		ram:add_unit("custom_start_random_army", "wh_dlc05_wef_inf_glade_guard_1", 6);
		ram:add_unit("custom_start_random_army", "wh_dlc05_wef_inf_glade_guard_2", 5);
		ram:add_unit("custom_start_random_army", "wh_dlc05_wef_inf_deepwood_scouts_0", 4);
		ram:add_unit("custom_start_random_army", "wh_dlc05_wef_inf_deepwood_scouts_1", 2);
		ram:add_unit("custom_start_random_army", "wh_dlc05_wef_inf_waywatchers_0", 1);
		
		--Cavalry
		ram:add_unit("custom_start_random_army", "wh_dlc05_wef_cav_wild_riders_0", 8);
		ram:add_unit("custom_start_random_army", "wh_dlc05_wef_cav_wild_riders_1", 6);
		ram:add_unit("custom_start_random_army", "wh_dlc05_wef_cav_glade_riders_0", 6);
		ram:add_unit("custom_start_random_army", "wh_dlc05_wef_cav_glade_riders_1", 2);
		ram:add_unit("custom_start_random_army", "wh_dlc05_wef_cav_hawk_riders_0", 1);
		ram:add_unit("custom_start_random_army", "wh_dlc05_wef_cav_sisters_thorn_0", 1);
		
		--Monsters
		ram:add_unit("custom_start_random_army", "wh_dlc05_wef_mon_treekin_0", 2);
		ram:add_unit("custom_start_random_army", "wh_dlc05_wef_mon_treeman_0", 1);
		ram:add_unit("custom_start_random_army", "wh_dlc05_wef_mon_great_eagle_0", 1);
		ram:add_unit("custom_start_random_army", "wh_dlc05_wef_forest_dragon_0", 1);
		
	elseif subculture == "wh_main_sc_brt_bretonnia" then
		--Infantry
		ram:add_unit("custom_start_random_army", "wh_dlc07_brt_peasant_mob_0", 12);
		ram:add_unit("custom_start_random_army", "wh_main_brt_inf_spearmen_at_arms", 8);
		ram:add_unit("custom_start_random_army", "wh_dlc07_brt_inf_spearmen_at_arms_1", 3);
		ram:add_unit("custom_start_random_army", "wh_main_brt_inf_men_at_arms", 8);
		ram:add_unit("custom_start_random_army", "wh_dlc07_brt_inf_men_at_arms_1", 4);
		ram:add_unit("custom_start_random_army", "wh_dlc07_brt_inf_men_at_arms_2", 1);
		ram:add_unit("custom_start_random_army", "wh_dlc07_brt_inf_foot_squires_0", 2);
		ram:add_unit("custom_start_random_army", "wh_dlc07_brt_inf_battle_pilgrims_0", 1);
		ram:add_unit("custom_start_random_army", "wh_dlc07_brt_inf_grail_reliquae_0", 1);
		ram:add_unit("custom_start_random_army", "wh_main_brt_inf_peasant_bowmen", 10);
		ram:add_unit("custom_start_random_army", "wh_dlc07_brt_inf_peasant_bowmen_1", 3);
		ram:add_unit("custom_start_random_army", "wh_dlc07_brt_inf_peasant_bowmen_2", 3);
		
		--Cavalry
		ram:add_unit("custom_start_random_army", "wh_dlc07_brt_cav_knights_errant_0", 12);
		ram:add_unit("custom_start_random_army", "wh_main_brt_cav_knights_of_the_realm", 8);
		ram:add_unit("custom_start_random_army", "wh_dlc07_brt_cav_questing_knights_0", 2);
		ram:add_unit("custom_start_random_army", "wh_main_brt_cav_grail_knights", 1);
		ram:add_unit("custom_start_random_army", "wh_dlc07_brt_cav_grail_guardians_0", 1);
		ram:add_unit("custom_start_random_army", "wh_main_brt_cav_mounted_yeomen_0", 4);
		ram:add_unit("custom_start_random_army", "wh_main_brt_cav_mounted_yeomen_1", 8);
		ram:add_unit("custom_start_random_army", "wh_main_brt_cav_pegasus_knights", 1);
		ram:add_unit("custom_start_random_army", "wh_dlc07_brt_cav_royal_pegasus_knights_0", 1);
		ram:add_unit("custom_start_random_army", "wh_dlc07_brt_cav_royal_hippogryph_knights_0", 1);
		
		--Artillery
		ram:add_unit("custom_start_random_army", "wh_main_brt_art_field_trebuchet", 4);
		ram:add_unit("custom_start_random_army", "wh_dlc07_brt_art_blessed_field_trebuchet_0", 1);
		
	elseif subculture == "wh_dlc08_sc_nor_norsca" then
		--Infantry
		ram:add_unit("custom_start_random_army", "wh_main_nor_inf_chaos_marauders_0", 14);
		ram:add_unit("custom_start_random_army", "wh_main_nor_inf_chaos_marauders_1", 10);
		ram:add_unit("custom_start_random_army", "wh_dlc08_nor_inf_marauder_spearman_0", 10);
		ram:add_unit("custom_start_random_army", "wh_dlc08_nor_inf_marauder_berserkers_0", 4);
		ram:add_unit("custom_start_random_army", "wh_dlc08_nor_inf_marauder_hunters_0", 3);
		ram:add_unit("custom_start_random_army", "wh_dlc08_nor_inf_marauder_hunters_1", 1);
		ram:add_unit("custom_start_random_army", "wh_dlc08_nor_inf_marauder_champions_0", 1);
		ram:add_unit("custom_start_random_army", "wh_dlc08_nor_inf_marauder_champions_1", 1);
		
		--Cavalry
		ram:add_unit("custom_start_random_army", "wh_main_nor_cav_marauder_horsemen_0", 10);
		ram:add_unit("custom_start_random_army", "wh_main_nor_cav_marauder_horsemen_1", 4);
		ram:add_unit("custom_start_random_army", "wh_dlc08_nor_cav_marauder_horsemasters_0", 2);
		ram:add_unit("custom_start_random_army", "wh_main_nor_cav_chaos_chariot", 2);
		ram:add_unit("custom_start_random_army", "wh_dlc08_nor_veh_marauder_warwolves_chariot_0", 1);
		
		--Monsters
		ram:add_unit("custom_start_random_army", "wh_main_nor_mon_chaos_warhounds_0", 6);
		ram:add_unit("custom_start_random_army", "wh_dlc08_nor_mon_warwolves_0", 4);
		ram:add_unit("custom_start_random_army", "wh_dlc08_nor_mon_skinwolves_0", 6);
		ram:add_unit("custom_start_random_army", "wh_dlc08_nor_mon_skinwolves_1", 4);
		ram:add_unit("custom_start_random_army", "wh_main_nor_mon_chaos_trolls", 6);
		ram:add_unit("custom_start_random_army", "wh_dlc08_nor_mon_norscan_ice_trolls_0", 2);
		ram:add_unit("custom_start_random_army", "wh_dlc08_nor_mon_norscan_giant_0", 1);
		ram:add_unit("custom_start_random_army", "wh_dlc08_nor_mon_fimir_0", 1);
		ram:add_unit("custom_start_random_army", "wh_dlc08_nor_mon_fimir_1", 1);
		ram:add_unit("custom_start_random_army", "wh_dlc08_nor_feral_manticore", 1);
		ram:add_unit("custom_start_random_army", "wh_dlc08_nor_mon_frost_wyrm_0", 1);
		ram:add_unit("custom_start_random_army", "wh_dlc08_nor_mon_war_mammoth_0", 2);
		ram:add_unit("custom_start_random_army", "wh_dlc08_nor_mon_war_mammoth_1", 1);
		ram:add_unit("custom_start_random_army", "wh_dlc08_nor_mon_war_mammoth_2", 1);
		
	elseif subculture == "wh2_main_sc_def_dark_elves" then
		--Infantry
		ram:add_unit("custom_start_random_army", "wh2_main_def_inf_dreadspears_0", 10);
		ram:add_unit("custom_start_random_army", "wh2_main_def_inf_bleakswords_0", 12);
		ram:add_unit("custom_start_random_army", "wh2_main_def_inf_witch_elves_0", 2);
		ram:add_unit("custom_start_random_army", "wh2_dlc10_def_inf_sisters_of_slaughter", 2);
		ram:add_unit("custom_start_random_army", "wh2_main_def_inf_har_ganeth_executioners_0", 1);
		ram:add_unit("custom_start_random_army", "wh2_main_def_inf_black_guard_0", 1);
		ram:add_unit("custom_start_random_army", "wh2_main_def_inf_black_ark_corsairs_0", 6);
		ram:add_unit("custom_start_random_army", "wh2_main_def_inf_black_ark_corsairs_1", 4);
		ram:add_unit("custom_start_random_army", "wh2_main_def_inf_darkshards_0", 10);
		ram:add_unit("custom_start_random_army", "wh2_main_def_inf_darkshards_1", 8);
		ram:add_unit("custom_start_random_army", "wh2_main_def_inf_shades_0", 4);
		ram:add_unit("custom_start_random_army", "wh2_main_def_inf_shades_1", 2);
		ram:add_unit("custom_start_random_army", "wh2_main_def_inf_shades_2", 1);
		
		--Cavalry
		ram:add_unit("custom_start_random_army", "wh2_main_def_cav_dark_riders_0", 7);
		ram:add_unit("custom_start_random_army", "wh2_main_def_cav_dark_riders_1", 3);
		ram:add_unit("custom_start_random_army", "wh2_main_def_cav_dark_riders_2", 4);
		ram:add_unit("custom_start_random_army", "wh2_dlc10_def_cav_doomfire_warlocks_0", 2);
		ram:add_unit("custom_start_random_army", "wh2_main_def_cav_cold_one_knights_0", 1);
		ram:add_unit("custom_start_random_army", "wh2_main_def_cav_cold_one_knights_1", 1);
		ram:add_unit("custom_start_random_army", "wh2_main_def_cav_cold_one_chariot", 1);
		
		--Monsters
		ram:add_unit("custom_start_random_army", "wh2_main_def_inf_harpies", 6);
		ram:add_unit("custom_start_random_army", "wh2_dlc10_def_mon_feral_manticore_0", 2);
		ram:add_unit("custom_start_random_army", "wh2_main_def_mon_war_hydra", 1);
		ram:add_unit("custom_start_random_army", "wh2_dlc10_def_mon_kharibdyss_0", 1);
		ram:add_unit("custom_start_random_army", "wh2_main_def_mon_black_dragon", 1);
		
		--Artillery
		ram:add_unit("custom_start_random_army", "wh2_main_def_art_reaper_bolt_thrower", 5);
		
	elseif subculture == "wh2_main_sc_hef_high_elves" then
		--Infantry
		ram:add_unit("custom_start_random_army", "wh2_main_hef_inf_spearmen_0", 16);
		ram:add_unit("custom_start_random_army", "wh2_main_hef_inf_white_lions_of_chrace_0", 8);
		ram:add_unit("custom_start_random_army", "wh2_main_hef_inf_swordmasters_of_hoeth_0", 1);
		ram:add_unit("custom_start_random_army", "wh2_main_hef_inf_phoenix_guard", 1);
		ram:add_unit("custom_start_random_army", "wh2_main_hef_inf_archers_0", 18);
		ram:add_unit("custom_start_random_army", "wh2_main_hef_inf_archers_1", 12);
		ram:add_unit("custom_start_random_army", "wh2_main_hef_inf_lothern_sea_guard_0", 8);
		ram:add_unit("custom_start_random_army", "wh2_main_hef_inf_lothern_sea_guard_1", 4);
		ram:add_unit("custom_start_random_army", "wh2_dlc10_hef_inf_shadow_warriors_0", 1);
		ram:add_unit("custom_start_random_army", "wh2_dlc10_hef_inf_sisters_of_avelorn_0", 1);
		
		--Cavalry
		ram:add_unit("custom_start_random_army", "wh2_main_hef_cav_ellyrian_reavers_0", 6);
		ram:add_unit("custom_start_random_army", "wh2_main_hef_cav_ellyrian_reavers_1", 4);
		ram:add_unit("custom_start_random_army", "wh2_main_hef_cav_silver_helms_0", 2);
		ram:add_unit("custom_start_random_army", "wh2_main_hef_cav_silver_helms_1", 1);
		ram:add_unit("custom_start_random_army", "wh2_main_hef_cav_dragon_princes", 1);
		ram:add_unit("custom_start_random_army", "wh2_main_hef_cav_ithilmar_chariot", 2);
		ram:add_unit("custom_start_random_army", "wh2_main_hef_cav_tiranoc_chariot", 1);
		
		--Monsters
		ram:add_unit("custom_start_random_army", "wh2_main_hef_mon_great_eagle", 3);
		ram:add_unit("custom_start_random_army", "wh2_main_hef_mon_moon_dragon", 1);
		ram:add_unit("custom_start_random_army", "wh2_main_hef_mon_sun_dragon", 1);
		ram:add_unit("custom_start_random_army", "wh2_main_hef_mon_star_dragon", 1);
		ram:add_unit("custom_start_random_army", "wh2_main_hef_mon_phoenix_flamespyre", 2);
		ram:add_unit("custom_start_random_army", "wh2_main_hef_mon_phoenix_frostheart", 1);
		
		--Artillery
		ram:add_unit("custom_start_random_army", "wh2_main_hef_art_eagle_claw_bolt_thrower", 4);
		
	elseif subculture == "wh2_main_sc_lzd_lizardmen" then
		--Infantry
		ram:add_unit("custom_start_random_army", "wh2_main_lzd_inf_skink_cohort_0", 12);
		ram:add_unit("custom_start_random_army", "wh2_dlc12_lzd_inf_skink_red_crested_0", 7);
		ram:add_unit("custom_start_random_army", "wh2_main_lzd_inf_saurus_spearmen_0", 12);
		ram:add_unit("custom_start_random_army", "wh2_main_lzd_inf_saurus_spearmen_1", 6);
		ram:add_unit("custom_start_random_army", "wh2_main_lzd_inf_saurus_warriors_0", 12);
		ram:add_unit("custom_start_random_army", "wh2_main_lzd_inf_saurus_warriors_1", 6);
		ram:add_unit("custom_start_random_army", "wh2_main_lzd_inf_temple_guards", 1);
		ram:add_unit("custom_start_random_army", "wh2_main_lzd_inf_skink_cohort_1", 7);
		ram:add_unit("custom_start_random_army", "wh2_main_lzd_inf_skink_skirmishers_0", 6);
		ram:add_unit("custom_start_random_army", "wh2_main_lzd_inf_chameleon_skinks_0", 1);
		
		--Cavalry
		ram:add_unit("custom_start_random_army", "wh2_main_lzd_cav_cold_ones_feral_0", 6);
		ram:add_unit("custom_start_random_army", "wh2_main_lzd_cav_cold_ones_0", 5);
		ram:add_unit("custom_start_random_army", "wh2_main_lzd_cav_cold_ones_1", 5);
		ram:add_unit("custom_start_random_army", "wh2_main_lzd_cav_horned_ones_0", 1);
		ram:add_unit("custom_start_random_army", "wh2_main_lzd_cav_terradon_riders_0", 8);
		ram:add_unit("custom_start_random_army", "wh2_main_lzd_cav_terradon_riders_1", 4);
		ram:add_unit("custom_start_random_army", "wh2_dlc12_lzd_cav_ripperdactyl_riders_0", 1);
		
		--Monsters
		ram:add_unit("custom_start_random_army", "wh2_main_lzd_mon_kroxigors", 2);
		ram:add_unit("custom_start_random_army", "wh2_dlc12_lzd_mon_salamander_pack_0", 4);
		ram:add_unit("custom_start_random_army", "wh2_dlc12_lzd_mon_ancient_salamander_0", 1);
		ram:add_unit("custom_start_random_army", "wh2_main_lzd_mon_bastiladon_0", 4);
		ram:add_unit("custom_start_random_army", "wh2_main_lzd_mon_bastiladon_1", 1);
		ram:add_unit("custom_start_random_army", "wh2_main_lzd_mon_bastiladon_2", 1);
		ram:add_unit("custom_start_random_army", "wh2_dlc12_lzd_mon_bastiladon_3", 1);
		ram:add_unit("custom_start_random_army", "wh2_main_lzd_mon_stegadon_0", 1);
		ram:add_unit("custom_start_random_army", "wh2_main_lzd_mon_stegadon_1", 1);
		ram:add_unit("custom_start_random_army", "wh2_main_lzd_mon_ancient_stegadon", 1);
		ram:add_unit("custom_start_random_army", "wh2_dlc12_lzd_mon_ancient_stegadon_1", 1);
		ram:add_unit("custom_start_random_army", "wh2_main_lzd_mon_carnosaur_0", 1);
		
	elseif subculture == "wh2_main_sc_skv_skaven" then
		--Infantry
		ram:add_unit("custom_start_random_army", "wh2_main_skv_inf_skavenslaves_0", 10);
		ram:add_unit("custom_start_random_army", "wh2_main_skv_inf_skavenslave_spearmen_0", 10);
		ram:add_unit("custom_start_random_army", "wh2_main_skv_inf_clanrats_0", 12);
		ram:add_unit("custom_start_random_army", "wh2_main_skv_inf_clanrats_1", 6);
		ram:add_unit("custom_start_random_army", "wh2_main_skv_inf_clanrat_spearmen_0", 12);
		ram:add_unit("custom_start_random_army", "wh2_main_skv_inf_clanrat_spearmen_1", 6);
		ram:add_unit("custom_start_random_army", "wh2_main_skv_inf_death_runners_0", 2);
		ram:add_unit("custom_start_random_army", "wh2_main_skv_inf_stormvermin_0", 1);
		ram:add_unit("custom_start_random_army", "wh2_main_skv_inf_stormvermin_1", 1);
		ram:add_unit("custom_start_random_army", "wh2_main_skv_inf_plague_monks", 4);
		ram:add_unit("custom_start_random_army", "wh2_main_skv_inf_plague_monk_censer_bearer", 1);
		ram:add_unit("custom_start_random_army", "wh2_main_skv_inf_skavenslave_slingers_0", 6);
		ram:add_unit("custom_start_random_army", "wh2_main_skv_inf_night_runners_0", 4);
		ram:add_unit("custom_start_random_army", "wh2_main_skv_inf_night_runners_1", 1);
		ram:add_unit("custom_start_random_army", "wh2_main_skv_inf_gutter_runners_0", 2);
		ram:add_unit("custom_start_random_army", "wh2_main_skv_inf_gutter_runners_1", 1);
		ram:add_unit("custom_start_random_army", "wh2_main_skv_inf_gutter_runner_slingers_0", 1);
		ram:add_unit("custom_start_random_army", "wh2_main_skv_inf_gutter_runner_slingers_1", 1);
		ram:add_unit("custom_start_random_army", "wh2_main_skv_inf_death_globe_bombardiers", 1);
		ram:add_unit("custom_start_random_army", "wh2_main_skv_inf_poison_wind_globadiers", 1);
		ram:add_unit("custom_start_random_army", "wh2_dlc12_skv_inf_ratling_gun_0", 1);
		ram:add_unit("custom_start_random_army", "wh2_main_skv_inf_warpfire_thrower", 2);
		ram:add_unit("custom_start_random_army", "wh2_dlc12_skv_inf_warplock_jezzails_0", 1);
		
		--Vehicles
		ram:add_unit("custom_start_random_army", "wh2_main_skv_veh_doomwheel", 1);
		ram:add_unit("custom_start_random_army", "wh2_dlc12_skv_veh_doom_flayer_0", 2);
		
		--Monsters
		ram:add_unit("custom_start_random_army", "wh2_main_skv_mon_rat_ogres", 3);
		ram:add_unit("custom_start_random_army", "wh2_main_skv_mon_hell_pit_abomination", 1);
		
		--Artillery
		ram:add_unit("custom_start_random_army", "wh2_main_skv_art_plagueclaw_catapult", 4);
		ram:add_unit("custom_start_random_army", "wh2_main_skv_art_warp_lightning_cannon", 2);
		
	elseif subculture == "wh2_dlc09_sc_tmb_tomb_kings" then
		--Infantry
		ram:add_unit("custom_start_random_army", "wh2_dlc09_tmb_inf_skeleton_warriors_0", 14);
		ram:add_unit("custom_start_random_army", "wh2_dlc09_tmb_inf_skeleton_spearmen_0", 12);
		ram:add_unit("custom_start_random_army", "wh2_dlc09_tmb_inf_tomb_guard_0", 2);
		ram:add_unit("custom_start_random_army", "wh2_dlc09_tmb_inf_tomb_guard_1", 2);
		ram:add_unit("custom_start_random_army", "wh2_dlc09_tmb_inf_nehekhara_warriors_0", 5);
		ram:add_unit("custom_start_random_army", "wh2_dlc09_tmb_inf_skeleton_archers_0", 14);
		
		--Cavalry
		ram:add_unit("custom_start_random_army", "wh2_dlc09_tmb_cav_skeleton_horsemen_0", 8);
		ram:add_unit("custom_start_random_army", "wh2_dlc09_tmb_cav_nehekhara_horsemen_0", 2);
		ram:add_unit("custom_start_random_army", "wh2_dlc09_tmb_veh_skeleton_chariot_0", 2);
		ram:add_unit("custom_start_random_army", "wh2_dlc09_tmb_veh_skeleton_archer_chariot_0", 3);
		ram:add_unit("custom_start_random_army", "wh2_dlc09_tmb_cav_skeleton_horsemen_archers_0", 6);
		ram:add_unit("custom_start_random_army", "wh2_dlc09_tmb_mon_sepulchral_stalkers_0", 3);
		ram:add_unit("custom_start_random_army", "wh2_dlc09_tmb_cav_necropolis_knights_0", 1);
		ram:add_unit("custom_start_random_army", "wh2_dlc09_tmb_cav_necropolis_knights_1", 1);
		
		--Monsters
		ram:add_unit("custom_start_random_army", "wh2_dlc09_tmb_mon_carrion_0", 8);
		ram:add_unit("custom_start_random_army", "wh2_dlc09_tmb_mon_ushabti_0", 4);
		ram:add_unit("custom_start_random_army", "wh2_dlc09_tmb_mon_ushabti_1", 1);
		ram:add_unit("custom_start_random_army", "wh2_dlc09_tmb_veh_khemrian_warsphinx_0", 1);
		ram:add_unit("custom_start_random_army", "wh2_dlc09_tmb_mon_tomb_scorpion_0", 2);
		ram:add_unit("custom_start_random_army", "wh2_dlc09_tmb_mon_heirotitan_0", 1);
		ram:add_unit("custom_start_random_army", "wh2_dlc09_tmb_mon_necrosphinx_0", 1);
		ram:add_unit("custom_start_random_army", "wh2_pro06_tmb_mon_bone_giant_0", 2);
		
		--Artillery
		ram:add_unit("custom_start_random_army", "wh2_dlc09_tmb_art_screaming_skull_catapult_0", 5);
		ram:add_unit("custom_start_random_army", "wh2_dlc09_tmb_art_casket_of_souls_0", 1);
		
	elseif subculture == "wh2_dlc11_sc_cst_vampire_coast" then
		--Infantry
		ram:add_unit("custom_start_random_army", "wh2_dlc11_cst_inf_zombie_deckhands_mob_0", 20);
		ram:add_unit("custom_start_random_army", "wh2_dlc11_cst_inf_zombie_deckhands_mob_1", 10);
		ram:add_unit("custom_start_random_army", "wh2_dlc11_cst_inf_syreens", 3);
		ram:add_unit("custom_start_random_army", "wh2_dlc11_cst_inf_depth_guard_0", 1);
		ram:add_unit("custom_start_random_army", "wh2_dlc11_cst_inf_depth_guard_1", 1);
		ram:add_unit("custom_start_random_army", "wh2_dlc11_cst_inf_zombie_gunnery_mob_0", 10);
		ram:add_unit("custom_start_random_army", "wh2_dlc11_cst_inf_zombie_gunnery_mob_1", 2);
		ram:add_unit("custom_start_random_army", "wh2_dlc11_cst_inf_zombie_gunnery_mob_2", 1);
		ram:add_unit("custom_start_random_army", "wh2_dlc11_cst_inf_zombie_gunnery_mob_3", 1);
		ram:add_unit("custom_start_random_army", "wh2_dlc11_cst_inf_deck_gunners_0", 1);
				
		--Monsters
		ram:add_unit("custom_start_random_army", "wh2_dlc11_cst_cav_deck_droppers_0", 5);
		ram:add_unit("custom_start_random_army", "wh2_dlc11_cst_cav_deck_droppers_1", 1);
		ram:add_unit("custom_start_random_army", "wh2_dlc11_cst_cav_deck_droppers_2", 1);
		ram:add_unit("custom_start_random_army", "wh2_dlc11_cst_mon_fell_bats", 7);
		ram:add_unit("custom_start_random_army", "wh2_dlc11_cst_mon_scurvy_dogs", 6);
		ram:add_unit("custom_start_random_army", "wh2_dlc11_cst_mon_mournguls_0", 2);
		ram:add_unit("custom_start_random_army", "wh2_dlc11_cst_mon_bloated_corpse_0", 10);
		ram:add_unit("custom_start_random_army", "wh2_dlc11_cst_mon_animated_hulks_0", 2);
		ram:add_unit("custom_start_random_army", "wh2_dlc11_cst_mon_rotting_prometheans_0", 1);
		ram:add_unit("custom_start_random_army", "wh2_dlc11_cst_mon_rotting_prometheans_gunnery_mob_0", 1);
		ram:add_unit("custom_start_random_army", "wh2_dlc11_cst_mon_terrorgheist", 1);
		ram:add_unit("custom_start_random_army", "wh2_dlc11_cst_mon_rotting_leviathan_0", 1);
		ram:add_unit("custom_start_random_army", "wh2_dlc11_cst_mon_necrofex_colossus_0", 1);
		
		--Artillery
		ram:add_unit("custom_start_random_army", "wh2_dlc11_cst_art_mortar", 7);
		ram:add_unit("custom_start_random_army", "wh2_dlc11_cst_art_carronade", 4);
		
	else
		script_error("ERROR: generate_random_army() called but supplied subculture [" .. subculture .. "] is not supported");
		return false;
	end
	
	return ram:generate_force("custom_start_random_army", num_units, true);
end