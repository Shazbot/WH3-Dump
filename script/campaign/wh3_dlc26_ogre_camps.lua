ogre_camps = {
	max_camps = 3,
	camp_base_cost = 250,
	transfer_threshold = 500,
	alternative_meat_resource = "wh3_dlc26_ogr_meat_CAI",
	meat_resource = "wh3_main_ogr_meat",
	camp_cost_key = "wh3_main_ogre_camp_CAI",
	camp_tech = {"wh3_main_tech_ogr_1_11_0", "wh3_main_tech_ogr_0_2_0"},

	factions = {
		wh3_main_ogr_disciples_of_the_maw = {
			faction_key = "wh3_main_ogr_disciples_of_the_maw",
			unit_list = "wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_ogres_0,wh3_main_ogr_inf_gnoblars_1,wh3_main_ogr_mon_sabretusk_pack_0",
		},
		wh3_main_ogr_goldtooth = {
			faction_key = "wh3_main_ogr_goldtooth",
			unit_list = "wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_ogres_0,wh3_main_ogr_inf_gnoblars_1,wh3_main_ogr_mon_sabretusk_pack_0",
		},
		wh3_dlc26_ogr_golgfag = {
			faction_key = "wh3_dlc26_ogr_golgfag",
			unit_list = "wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_ogres_0,wh3_main_ogr_inf_gnoblars_1,wh3_main_ogr_mon_sabretusk_pack_0",
		}, 
		wh3_main_ogr_sons_of_the_mountain = {
			faction_key = "wh3_main_ogr_sons_of_the_mountain",
			unit_list = "wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_ogres_0,wh3_main_ogr_inf_gnoblars_1,wh3_main_ogr_mon_sabretusk_pack_0",
		},
		wh3_main_ogr_thunderguts = {
			faction_key = "wh3_main_ogr_thunderguts",
			unit_list = "wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_ogres_0,wh3_main_ogr_inf_gnoblars_1,wh3_main_ogr_mon_sabretusk_pack_0",
		},
		wh3_main_ogr_rock_skulls = {
			faction_key = "wh3_main_ogr_rock_skulls",
			unit_list = "wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_ogres_0,wh3_main_ogr_inf_gnoblars_1,wh3_main_ogr_mon_sabretusk_pack_0",
		},
		wh3_main_ogr_lazarghs = {
			faction_key = "wh3_main_ogr_lazarghs",
			unit_list = "wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_ogres_0,wh3_main_ogr_inf_gnoblars_1,wh3_main_ogr_mon_sabretusk_pack_0",
		},
		wh3_main_ogr_sabreskin = {
			faction_key = "wh3_main_ogr_sabreskin",
			unit_list = "wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_ogres_0,wh3_main_ogr_inf_gnoblars_1,wh3_main_ogr_mon_sabretusk_pack_0",
		},
		wh3_main_ogr_fulg = {
			faction_key = "wh3_main_ogr_fulg",
			unit_list = "wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_ogres_0,wh3_main_ogr_inf_gnoblars_1,wh3_main_ogr_mon_sabretusk_pack_0",
		},
		wh3_main_ogr_blood_guzzlers = {
			faction_key = "wh3_main_ogr_blood_guzzlers",
			unit_list = "wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_ogres_0,wh3_main_ogr_inf_gnoblars_1,wh3_main_ogr_mon_sabretusk_pack_0",
		},
		wh3_main_ogr_crossed_clubs = {
			faction_key = "wh3_main_ogr_crossed_clubs",
			unit_list = "wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_ogres_0,wh3_main_ogr_inf_gnoblars_1,wh3_main_ogr_mon_sabretusk_pack_0",
		},
		wh3_main_ogr_fleshgreeders = {
			faction_key = "wh3_main_ogr_fleshgreeders",
			unit_list = "wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_ogres_0,wh3_main_ogr_inf_gnoblars_1,wh3_main_ogr_mon_sabretusk_pack_0",
		},
		wh3_main_ogr_mountaineaters = {
			faction_key = "wh3_main_ogr_mountaineaters",
			unit_list = "wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_ogres_0,wh3_main_ogr_inf_gnoblars_1,wh3_main_ogr_mon_sabretusk_pack_0",
		},
	},

	starting_camp_meat = {
		-- grant bonus meat to starting camps based on faction key
		["wh3_dlc26_ogr_golgfag"] = 250 
	}
}

function ogre_camps:initialise()
	-- We spawn camps on turn end
	core:add_listener(
		"OgreCampsSpawn",
		"FactionTurnEnd",
		function(context)
			local faction = context:faction()
			return ogre_camps.factions[faction:name()] and not faction:is_human()
		end,
		function(context)
			local faction = context:faction()
			local faction_data = nil
			local mil_forces = faction:military_force_list()

			-- Set up our faction_data
			faction_data = ogre_camps.factions[faction:name()]
			if faction_data == nil then 
				return
			end

			local current_camps = 0
			local possible_camp = 1

			-- How many camps do we currently have ? 
			for i = 0, mil_forces:num_items() - 1 do
				if mil_forces:item_at(i):force_type():key() == "OGRE_CAMP" then 
					current_camps = current_camps + 1
				end
			end
			
			-- How many camps can we build 
			for j = 1, #ogre_camps.camp_tech do
				if faction:has_technology(ogre_camps.camp_tech[j]) then 
					possible_camp = possible_camp + 1
				end
			end

			if current_camps >= possible_camp then 
				return
			end 

			local faction_alternative_meat = faction:pooled_resource_manager():resource(ogre_camps.alternative_meat_resource) 
			if faction_alternative_meat:value() < ogre_camps.camp_base_cost then 
				return 
			end

			-- We need a military force position to spawn the camp
			local force = ogre_camps:get_non_garrisoned_force(faction) 

			if force == nil then 
				return
			end

			-- Once we have both a force and a pooled resource manager, spawn the camp
			if current_camps <= 0 then 
				ogre_camps:spawn_camp(true, faction_data, force)
			else
				ogre_camps:spawn_camp(false, faction_data, force)
			end
			current_camps = current_camps + 1
		end,
		true
	)

	-- We want Ogres to spawn a camp earlly on, this 25 meat revenu will ensure we can spawn one before turn 10
	core:add_listener(
		"OgreCampsFirstCampHelper",
		"FactionTurnStart",
		function(context)
			return context:faction():subculture() == "wh3_main_sc_ogr_ogre_kingdoms" and cm:turn_number() < 11 and not context:faction():is_human()
		end,
		function(context)
			local pooled_res_manager = context:faction():pooled_resource_manager()
			cm:pooled_resource_transaction(pooled_res_manager, "wh3_dlc26_ogr_meat_camp_building_CAI_first_camp_helper")
		end,
		true
	)

	-- When an army reaches more then a threshold of meat, transfer the difference to camp
	core:add_listener(
		"OgreCampsTransfer",
		"FactionTurnStart",
		function(context)
			return context:faction():subculture() == "wh3_main_sc_ogr_ogre_kingdoms" and not context:faction():is_human()
		end,
		function(context)
			local faction = context:faction()
			local mf = faction:military_force_list()
			local camp = nil 

			if ogre_camps:has_a_camp(faction) == false then 
				return
			end
			
			camp = ogre_camps:get_random_camp(mf)

			if camp == nil then
				return
			end

			for i = 0, mf:num_items() - 1 do
				local force_meat = mf:item_at(i):pooled_resource_manager():resource(ogre_camps.meat_resource) 

				if not force_meat:is_null_interface() and force_meat:value() > ogre_camps.transfer_threshold then 
					local amount = force_meat:value() - ogre_camps.transfer_threshold
					local times = math.floor(amount / 10)

					if times <= 0 then
						return
					end

					for j = 1, times do 
						cm:pooled_resource_transaction(mf:item_at(i):pooled_resource_manager(), "wh3_main_ogre_camp_CAI_transfer_to_camp")
						cm:pooled_resource_transaction(camp:pooled_resource_manager(), "wh3_main_ogre_camp_CAI_transfer_from_army")
					end
				end
			end
		end,
		true
	)

	core:add_listener(
		"OgreCampsStartingMeat",
		"FactionTurnStart",
		function(context)
			return context:faction():subculture() == "wh3_main_sc_ogr_ogre_kingdoms" and cm:turn_number() == 1
		end,
		function(context)
			-- This only works if factions start with 1 camp max. If we ever start a faction with more than 1 camp in the future we'll need to change this to target character names or something.
			local faction = context:faction()

			for faction_key, amount in pairs(self.starting_camp_meat) do
				if faction:name() == faction_key then
					local mf_list = faction:military_force_list()

					for i = 0, mf_list:num_items() - 1 do
						local mf = mf_list:item_at(i)

						if mf and mf:force_type():key() == "OGRE_CAMP" then
							local resource = mf:pooled_resource_manager():resource(ogre_camps.meat_resource)
							
							cm:pooled_resource_factor_transaction(resource, "camps", amount)

							return true
						end
					end
				end
			end
		end,
		true
	)

	-- track which characters recruit mercenaries from which camps in order to show incidents to the player
	local merc_tracker = cm:get_saved_value("merc_tracker") or {}

	-- save the total amount of money each character has spent
	core:add_listener(
		"mercenary_recruited",
		"UnitTrained",
		function(context)
			local unit = context:unit()
			return unit:recruitment_source_key() == "ogre_mercenaries" and unit:military_force():has_general()
		end,
		function(context)
			local unit = context:unit()
			local camp_character = unit:origin_character()

			if not camp_character:is_null_interface() then
				local camp_faction = camp_character:faction():name()
				local camp_cqi = camp_character:military_force():command_queue_index()
				local purchaser_cqi = unit:military_force():general_character():command_queue_index()

				-- lookup previous value, build the table if there isn't a value
				if not merc_tracker[camp_faction] then merc_tracker[camp_faction] = {} end
				if not merc_tracker[camp_faction][camp_cqi] then merc_tracker[camp_faction][camp_cqi] = {} end
				if not merc_tracker[camp_faction][camp_cqi][purchaser_cqi] then merc_tracker[camp_faction][camp_cqi][purchaser_cqi] = {} end

				local unit_list = merc_tracker[camp_faction][camp_cqi][purchaser_cqi][1] or ""

				unit_list = unit_list .. "\n[[img:bullet_point_white]][[/img]] " .. cco("CcoCampaignUnit", unit:command_queue_index()):Call("Name")

				merc_tracker[camp_faction][camp_cqi][purchaser_cqi][1] = unit_list

				local total_money_spent = merc_tracker[camp_faction][camp_cqi][purchaser_cqi][2] or 0

				total_money_spent = total_money_spent + cco("CcoCampaignUnit", unit:command_queue_index()):Call("Cost")

				merc_tracker[camp_faction][camp_cqi][purchaser_cqi][2] = total_money_spent

				cm:set_saved_value("merc_tracker", merc_tracker)
			end
		end,
		true
	)

	-- display events for each character that's recruited mercenaries
	core:add_listener(
		"send_merc_events",
		"FactionTurnStart",
		function(context)
			return context:faction():is_human()
		end,
		function(context)
			local faction = context:faction()
			local faction_name = faction:name()
			local faction_cqi = faction:command_queue_index()
			local factions_merc_tracker = merc_tracker[faction_name]

			if factions_merc_tracker then
				for camp_cqi, recruitment_details in pairs(factions_merc_tracker) do
					for recruiting_cqi, unit_details in pairs(recruitment_details) do
						if unit_details and unit_details[2] and unit_details[2] > 0 and cm:get_character_by_cqi(recruiting_cqi) then
							common.set_context_value("merc_units_recruited_" .. recruiting_cqi, unit_details[1])
							
							cm:trigger_custom_incident_with_targets(
								faction_cqi,
								"wh3_dlc26_incident_ogre_mercenaries_sold",
								true,
								"payload{money " .. unit_details[2] .. ";}",
								0,
								0,
								recruiting_cqi,
								camp_cqi,
								0,
								0
							)
						end
					end
				end
			end

			-- now we've shown all the events, clear the tracker
			merc_tracker[faction_name] = {}
			cm:set_saved_value("merc_tracker", merc_tracker)
		end,
		true
	)


	if cm:is_new_game() == true then
		-- In order to increase the Camp Tyrant leveling we do give away a Ogre mercenary units discount to every CAI 
		-- Only if the user is playing as Ogre 
		local human_ogr = cm:get_human_factions_of_subculture("wh3_main_sc_ogr_ogre_kingdoms");
		
		if #human_ogr == 0 then 
			return; -- There are no human Ogres
		end 

		local factions = cm:model():world():faction_list();
	
		for i = 0, factions:num_items() - 1 do
			local faction = factions:item_at(i);

			if faction:is_human() == false then
				cm:apply_effect_bundle("wh3_dlc26_cai_ogr_mercenaries_discount", faction:name(), 0);
			end
		end
	end
end

function ogre_camps:spawn_camp(is_first_camp, faction_data, force)
	local pos_x = force:general_character():logical_position_x()
	local pos_y = force:general_character():logical_position_y()
	local region = force:general_character():region()

	if region:is_null_interface() or cm:is_region_owned_by_faction(region:name(), faction_data.faction_key) == false then 
		return
	end

	local region_key = region:name()
	
	-- if first camp, spawn near capital, except for Golgfag 
	if is_first_camp and capital or not faction_data.faction_key == "wh3_dlc26_ogr_golgfag" then 
		local capital = cm:get_faction(faction_data.faction_key):home_region():settlement()
		local cap_x = capital:logical_position_x()
		local cap_y = capital:logical_position_y()
		pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_position(faction_data.faction_key, cap_x, cap_y, true, 6)
	else
		pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_position(faction_data.faction_key, pos_x, pos_y, true, 10)
	end

	-- Deduce the cost of a camp 
	cm:pooled_resource_transaction(cm:get_faction(faction_data.faction_key):pooled_resource_manager(), ogre_camps.camp_cost_key)

	-- Spawn an army + force specific stance to make it a camp  
	cm:create_force_with_general(
			faction_data.faction_key,
			faction_data.unit_list,
			region_key,
			pos_x,
			pos_y,
			"general",
			"wh3_main_ogr_tyrant_camp",
			"",
			"",
			"",
			"",
			false,
			function(cqi)
				local mf_interface = cm:get_character_by_cqi(cqi):military_force()
				cm:force_character_force_into_stance(cm:char_lookup_str(cqi), "MILITARY_FORCE_ACTIVE_STANCE_TYPE_FIXED_CAMP")
				cm:set_force_sphere_of_influence_radius(cqi, 35)
				
				cm:add_growth_points_to_horde(mf_interface, 50)
				cm:add_building_to_force(mf_interface:command_queue_index(), 
					{"wh3_main_ogr_camp_town_centre_2",
					"wh3_main_ogr_camp_hunting_1",
					"wh3_main_ogr_camp_growth_1"
					}
				)
			end
		);
end

function ogre_camps:get_non_garrisoned_force(faction)
	local mil_forces = faction:military_force_list()
	for i = 0, mil_forces:num_items() - 1 do
		local force = mil_forces:item_at(i)
		if force:garrison_residence():is_null_interface() == true 
		and force:general_character():is_null_interface() == false 
		and (force:force_type():key() == "OGRE_CAMP") == false then 
			return force
		end
	end
end

function ogre_camps:has_a_camp(faction)
	local mil_forces = faction:military_force_list()
	for i = 0, mil_forces:num_items() - 1 do
		local force = mil_forces:item_at(i)
		if force:force_type():key() == "OGRE_CAMP" then 
			return true
		end
	end
	return false
end

function ogre_camps:get_random_camp(mil_force)
	local camp = unique_table:new();

	for i = 0, mil_force:num_items() - 1 do
		local force = mil_force:item_at(i)

		if force:force_type():key() == "OGRE_CAMP" then 
			camp:insert(force)
		end
	end 

	if #camp < 0 then 
		return nil
	else
		return camp.items[cm:model():random_int(1, #camp.items)]
	end
end