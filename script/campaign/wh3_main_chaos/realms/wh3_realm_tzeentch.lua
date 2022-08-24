local teleportal_ai_layout = {
	{{486, 621}, {416, 613}},
	{{389, 657}, {443, 636}},
	{{369, 657}, {394, 645}},
	{{353, 666}, {408, 591}},
	{{369, 700}, {437, 609}},
	{{401, 702}, {464, 613}}
};

local ai_faction = "ai";

local final_teleportal_dest = {387, 613};

local teleportals = {};
local marker_teleports = {};

local final_ai_dest = {373, 596};

local tzeentch_realm_initialised = false;

local ai_used_tzeentch_teleportals = {};

function faction_or_ai(faction)
	local faction_or_ai = faction:name()
	if not faction:is_human() then
		faction_or_ai = ai_faction
	end
	return faction_or_ai
end

function setup_realm_tzeentch(entering_faction)
	local entering_faction_name = false;
	local entering_faction_is_human = false;

	if entering_faction then
		entering_faction_name = entering_faction:name();
		entering_faction_is_human = entering_faction:is_human();

		if entering_faction_is_human then
			attempt_to_trigger_realm_final_battle_pre_cindyscene(entering_faction:name(), "tzeentch");
		end;

		-- Teleport entering faction to cutscene starting island
		if entering_faction:has_faction_leader() then
			local character_cqi = entering_faction:faction_leader():command_queue_index();
			local char_str = cm:char_lookup_str(character_cqi);
			teleport_to_faction_starting_island(entering_faction_name, char_str, true);
		end
	end;

	-- reset used teleportal count for the entering AI faction
	if not entering_faction_is_human then
		local ai_used_tzeentch_teleportals = cm:get_saved_value("ai_used_tzeentch_teleportals") or {};

		local factions_list = Tzeentch_Realm_Data.teleportal_info.faction_to_starting_island;
		for k,_ in pairs(factions_list) do
			if not ai_used_tzeentch_teleportals[k] then
				ai_used_tzeentch_teleportals[k] = 0;
			end
		end

		cm:set_saved_value("ai_used_tzeentch_teleportals", ai_used_tzeentch_teleportals);
	end

	if not tzeentch_realm_initialised then
		-- Listener that listens for the end of the narrative cutscene
		core:add_listener(
			"tzeentch_realm_cutscene_finished",
			"ScriptEventRealmIntroCompleted",
			function(context)
				return context:realm() == "tzeentch" and context:faction():name() == entering_faction_name;
			end,
			function(context)
				-- Moves Lord to correct starting location and moves the camera to the lords new position
				out("Tzeentch's realm intro has been completed, teleporting lord and moving camera")
				-- Teleport entering faction to relevant starting island
				local faction = context:faction()
				local faction_name = faction:name();
				if faction:has_faction_leader() then
					local character = faction:faction_leader();
					local character_cqi = character:command_queue_index();
					if character:has_region() then
						local char_region_name = character:region():name();
					end
					local char_str = cm:char_lookup_str(character_cqi);
					cm:callback(
						function()
							teleport_to_faction_starting_island(faction_name, char_str);
						end,
						0.5
					);
				end
			end,
			true
		)

		local layout_set = {};
		local faction_name = entering_faction_name;
		if not entering_faction_is_human then
			faction_name = ai_faction
		end

		-- monitor the AI completing the realm
		cm:remove_hex_area_trigger("ai_tzeentch_end");
		cm:add_hex_area_trigger("ai_tzeentch_end", final_ai_dest[1], final_ai_dest[2], 3);

		-- Choose teleportal layout set for player factions
		layout_set = cm:get_saved_value("chosen_teleportals_layout") or {};
		local factions_list = Tzeentch_Realm_Data.teleportal_info.faction_to_starting_island;
		for k,_ in pairs(factions_list) do
			if not layout_set[k] then
				local faction_start_loc = Tzeentch_Realm_Data.teleportal_info.faction_to_starting_island[k];
				layout_set[k] = cm:random_number(#Tzeentch_Realm_Data.teleportal_layout_sets[faction_start_loc]);
			end
		end
		layout_set[ai_faction] = 1;
		cm:set_saved_value("chosen_teleportals_layout", layout_set);

		if entering_faction then
			-- Setup creep armies
			setup_creep_army_comp(Tzeentch_Realm_Data.creep_armies, Tzeentch_Realm_Data.ai_army_setups);

			deploy_creep_armies(Tzeentch_Realm_Data.creep_armies, true, 400, -1, 2, true);
			cm:set_saved_value("teleportal_final_added", false);

			-- Setup teleport listeners with marker destinations
			local faction_or_ai = faction_or_ai(entering_faction);
			setup_marker_destinations(faction_or_ai);
			if entering_faction_is_human then
				setup_sigil_reveals(faction_or_ai)
			end
		end
		local exiting_teleportal = false;
		setup_poi_dilemma_choices();

		-- Setup listeners
		setup_teleportals_listeners(exiting_teleportal);
		setup_poi_listeners();
		setup_post_battle_option_listener();

		core:add_listener(
			"final_teleportal_entered",
			"AreaEntered",
			function(context)
				local character = context:family_member():character();
				if not character:is_null_interface() then
					return context:area_key() == "final_teleportal" and not exiting_teleportal and cm:char_is_general_with_army(character);
				end;
			end,
			function(context)
				local character = context:family_member():character();
				if character:is_null_interface() then
					return;
				end;

				local char_str = cm:char_lookup_str(character:command_queue_index());
				local faction = character:faction();
				local faction_name = faction:name();

				exiting_teleportal = true;

				-- when exiting a teleportal, this listener will fire again, so don't allow it for a tick
				cm:callback(function() exiting_teleportal = false end, 0.2);

				-- teleport the character back to the very first position
				local x, y = teleportals[1][1][1], teleportals[1][1][2];

				local final_x, final_y = cm:find_valid_spawn_location_for_character_from_position(faction_name, x, y, true);

				out.chaos("\tCalculating teleport destination: " .. x .. ", " .. y .. " -> " .. final_x .. ", " .. final_y);

				if final_x ~= -1 then
					local display_x, display_y = cm:log_to_dis(final_x, final_y);
					cm:draw_text("Teleporting...", display_x, display_y, 15, 2, 0, 255, 255);

					out.chaos("Entered teleportal [final_teleportal] - teleporting to " .. final_x .. ", " .. final_y);

					cm:teleport_to(char_str, final_x, final_y);
					cm:zero_action_points(char_str);

					if faction:is_human() and cm:get_local_faction_name(true) == faction_name then
						local cached_x, cached_y, cached_d, cached_b, cached_h = cm:get_camera_position();
						cm:scroll_camera_from_current(false, 1, {display_x, display_y, cached_d, cached_b, cached_h});
					end;
				else
					script_error("Couldn't find position");
				end;
			end,
			true
		);

		setup_ai_behaviour(
			function(context)
				local faction = context:faction();
				local faction_name = faction:name();
				local character = faction:faction_leader();
				local x = character:logical_position_x();
				local y = character:logical_position_y();
				local character_region = character:region_data();
				
				if character:has_military_force() and not character_region:is_null_interface() then
					local character_region_key = character_region:key();
					
					local desired_position = {};
					
					local teleport_info = Tzeentch_Realm_Data.teleportal_info;
					local teleport_ai_layout = teleport_info.teleportal_ai_layout
					
					if character_region_key == "wh3_main_chaos_region_realm_of_the_sorcerer_1" then
						desired_position.x = final_ai_dest[1];
						desired_position.y = final_ai_dest[2];
					else
						local movement_coordinates = {};
						
						for j = 1, #teleport_ai_layout do
							for k = 1, #teleport_ai_layout[j] do
								table.insert(movement_coordinates, Tzeentch_Realm_Data.teleportal_info.marker_loc[teleport_ai_layout[j][k]]);
							end;
						end;
						
						local last_teleportal = cm:get_saved_value(faction_name .. "_exited_teleportal");
						
						for j = 1, #movement_coordinates do
							local testing_x, testing_y = movement_coordinates[j][1], movement_coordinates[j][2];
							local current_distance = distance_squared(x, y, testing_x, testing_y);
							
							if x ~= testing_x or y ~= testing_y then
								
								if current_distance > 3 and character_region_key == cm:model():world():region_data_at_position(testing_x, testing_y):key() then
									if last_teleportal ~= testing_x .. "," .. testing_y then
										local valid_x, valid_y = cm:find_valid_spawn_location_for_character_from_position(faction_name, testing_x, testing_y, true);
										
										-- if the valid position is too far away from the teleportal, then we won't get teleported - so it's being blocked by something which we can attack instead
										local range_deviation = 3;
										
										if is_within_range(valid_x, testing_x, range_deviation) and is_within_range(valid_y, testing_y, range_deviation) then
											desired_position.x = testing_x;
											desired_position.y = testing_y;
											break;
										end;
									end;
								end;
							end;
						end;
					end;
					
					if desired_position.x then
						attempt_to_move_realm_character_to_desired_location(faction_name, character, desired_position);
					-- as in the previous comment, we couldn't find a valid position to move to, so attacking the nearest enemy
					elseif not find_target_and_attack(character) then
						-- there is a very small chance we're stuck on a teleport point but haven't been teleported, so move a bit to try and get unstuck :(
						local valid_x, valid_y = cm:find_valid_spawn_location_for_character_from_position(faction_name, x, y - 3, true);
						
						if valid_x > 0 then
							out.chaos("Moving slightly to try and get unstuck");
							cm:move_to_queued(cm:char_lookup_str(character), valid_x, valid_y);
						else
							script_error("Tried to move in the Tzeentch realm, but character in " .. faction_name .. " seems to be well and truly stuck");
						end;
					end;
				else
					out.chaos("\tCharacter : " .. character:get_forename() .. " has no region to move for AI behaviour in Tzeentch realm");
				end;
			end,
			"tzeentch"
		);

		core:add_listener(
			"ai_reaches_end_of_tzeentch_realm",
			"AreaEntered",
			function(context)
				local character = context:family_member():character();
				if not character:is_null_interface() then
					local faction = character:faction();
					return context:area_key() == "ai_tzeentch_end" and not faction:is_human() and not faction:pooled_resource_manager():resource("wh3_main_realm_complete_khorne"):is_null_interface() and cm:char_is_general_with_army(character) and can_ai_army_complete_final_battle(character:military_force());
				end;
			end,
			function(context)
				close_realm(context:family_member():character_details():faction():name(), "tzeentch");
			end,
			false
		);
	else
		if entering_faction then
			-- Teleport entering faction to relevant starting island
			local faction_name = entering_faction:name();
			if entering_faction:has_faction_leader() then
				local character_cqi = entering_faction:faction_leader():command_queue_index();
				local char_str = cm:char_lookup_str(character_cqi);
				teleport_to_faction_starting_island(faction_name, char_str);
			end

			-- Update marker to destinations list for newly entered factions
			local faction_or_ai = entering_faction_name
			if not entering_faction_is_human then
				faction_or_ai = ai_faction
			else
				setup_sigil_reveals(faction_or_ai)
			end
			setup_marker_destinations(faction_or_ai)
		end
	end;

	-- listeners have been established, only set them up again if a save is loaded
	tzeentch_realm_initialised = true;

	if entering_faction then
		if entering_faction_is_human then
			-- show the sigil on the final teleportal
			handle_revealing_sigils(true, entering_faction_name, "final_teleportal_dest")
		else
			toggle_faction_leader_ai(entering_faction, false);
		end;
	end;

	cm:set_saved_value("tzeentch_realm_active", true);
end;

-- Teleport army to starting island for faction
function teleport_to_faction_starting_island(faction_name, char_str, starting_cutscene)
	local teleport_loc = Tzeentch_Realm_Data.teleportal_info.faction_to_starting_island[faction_name]
	if starting_cutscene then
		teleport_loc = "iron_knight_1"
	end
	local loc_data = Tzeentch_Realm_Data.teleportal_info.rift_loc[teleport_loc]
	local x, y = unpack(loc_data)
	local final_x, final_y = cm:find_valid_spawn_location_for_character_from_position(faction_name, x, y, true);
	cm:teleport_to(char_str, final_x, final_y);

	local display_x, display_y = cm:log_to_dis(final_x, final_y);
	local faction = cm:get_faction(faction_name)
	if faction:is_human() and cm:get_local_faction_name(true) == faction_name then
		local cached_x, cached_y, cached_d, cached_b, cached_h = cm:get_camera_position();
		cm:scroll_camera_from_current(false, 0.3, {display_x, display_y, cached_d, 0, cached_h});
	end;
end

-- Setup a marker list where each marker has a list of destinations each linked to a specific faction
function setup_marker_destinations(faction_or_ai)
	-- Go through the list of markers and add destination links
	local layout_set = cm:get_saved_value("chosen_teleportals_layout");
	marker_teleports = cm:get_saved_value("marker_to_teleport_values");
	for i = 1, #Tzeentch_Realm_Data.teleportal_info.marker_id do
		if not marker_teleports then
			marker_teleports = {};
		end
		if not marker_teleports[Tzeentch_Realm_Data.teleportal_info.marker_id[i]] then
			marker_teleports[Tzeentch_Realm_Data.teleportal_info.marker_id[i]] = {};
		end
		if not marker_teleports[Tzeentch_Realm_Data.teleportal_info.marker_id[i]][faction_or_ai] then
			marker_teleports[Tzeentch_Realm_Data.teleportal_info.marker_id[i]][faction_or_ai] = {};
		end

		-- Go through the layout_set chosen and add the corresponding link to the marker destination with the faction name
		local factions_layout
		if faction_or_ai == ai_faction then
			factions_layout = Tzeentch_Realm_Data.teleportal_info.teleportal_ai_layout

			for j = 1, #factions_layout do
				if factions_layout[j][1] == Tzeentch_Realm_Data.teleportal_info.marker_id[i] then
					table.insert(marker_teleports[Tzeentch_Realm_Data.teleportal_info.marker_id[i]][faction_or_ai], factions_layout[j][2]);
				elseif factions_layout[j][2] == Tzeentch_Realm_Data.teleportal_info.marker_id[i] then
					table.insert(marker_teleports[Tzeentch_Realm_Data.teleportal_info.marker_id[i]][faction_or_ai], factions_layout[j][1]);
				end
			end
		else
			local faction_start_loc = Tzeentch_Realm_Data.teleportal_info.faction_to_starting_island[faction_or_ai]
			factions_layout = Tzeentch_Realm_Data.teleportal_layout_sets[faction_start_loc][layout_set[faction_or_ai]]

			for j = 1, #factions_layout do
				if factions_layout[j]["coordinates"][1] == Tzeentch_Realm_Data.teleportal_info.marker_id[i] then
					table.insert(marker_teleports[Tzeentch_Realm_Data.teleportal_info.marker_id[i]][faction_or_ai], factions_layout[j].coordinates[2]);
				elseif factions_layout[j]["coordinates"][2] == Tzeentch_Realm_Data.teleportal_info.marker_id[i] then
					table.insert(marker_teleports[Tzeentch_Realm_Data.teleportal_info.marker_id[i]][faction_or_ai], factions_layout[j].coordinates[1]);
				end
			end
		end
	end
	cm:set_saved_value("marker_to_teleport_values", marker_teleports);
end

-- Setup the teleportals listeners
function setup_teleportals_listeners(exiting_teleportal)
	local marker_id = Tzeentch_Realm_Data.teleportal_info.marker_id;
	
	for i = 1, #marker_id do
		local start_teleportal = marker_id[i];
		local x, y = unpack(Tzeentch_Realm_Data.teleportal_info.marker_loc[start_teleportal]);
		
		cm:add_interactable_campaign_marker(start_teleportal, "wh3_main_tze_waystone", x, y, 2);
		
		local display_x, display_y = cm:log_to_dis(x, y);
		cm:draw_line(display_x, display_y, 10, display_x, display_y, 25, 9999, 0, 0, 255);
		
		core:add_listener(
			start_teleportal,
			"AreaEntered",
			function(context)
				local character = context:family_member():character();
				if not character:is_null_interface() then
					local faction = character:faction();
					return context:area_key() == start_teleportal and exiting_teleportal ~= character:command_queue_index() and cm:char_is_general_with_army(character) and not faction:pooled_resource_manager():resource("wh3_main_realm_complete_khorne"):is_null_interface();
				end;
			end,
			function(context)
				local character = context:family_member():character();
				if character:is_null_interface() then
					return;
				end;

				local character_cqi = character:command_queue_index();
				local char_str = cm:char_lookup_str(character_cqi);
				local faction = character:faction();
				local faction_name = faction:name();
				local faction_name_to_track = faction_name;
				local final_area_entered = false;
				local faction_is_human = faction:is_human()
				
				if not faction_is_human then
					faction_name_to_track = ai_faction
				end
				
				exiting_teleportal = character_cqi;
				
				-- when exiting a teleportal, this listener will fire again, so don't allow it for a half second
				cm:callback(function() exiting_teleportal = false end, 0.5);
				
				-- Get teleport destination coordinates based on faction
				marker_teleports = cm:get_saved_value("marker_to_teleport_values");
				-- If faction does not have a destination set setup for that faction
				if not marker_teleports or not marker_teleports[start_teleportal] or not marker_teleports[start_teleportal][faction_name_to_track] then
					setup_marker_destinations(faction_name_to_track);
					marker_teleports = cm:get_saved_value("marker_to_teleport_values");
				end
				local destination_marker_name = marker_teleports[start_teleportal][faction_name_to_track][1]
				local marker_info = Tzeentch_Realm_Data.teleportal_info.marker_loc[destination_marker_name]
				x = marker_info[1];
				y = marker_info[2];
				
				local line_end_point_x, line_end_point_y = cm:log_to_dis(x, y);
				cm:draw_line(display_x, display_y, 25, line_end_point_x, line_end_point_y, 25, 9999, 255, 255, 255, 100);
				
				-- Track how many teleports AI faction has done
				-- Set destination to final island if the AI has reached the specified amount
				if not faction_is_human then
					ai_used_tzeentch_teleportals = cm:get_saved_value("ai_used_tzeentch_teleportals") or {};
					local faction_used_teleportals = ai_used_tzeentch_teleportals[faction_name] or 0;
					faction_used_teleportals = faction_used_teleportals + 1;
					ai_used_tzeentch_teleportals[faction_name] = faction_used_teleportals;
					cm:set_saved_value("ai_used_tzeentch_teleportals", ai_used_tzeentch_teleportals);
					
					if ai_used_tzeentch_teleportals[faction_name] >= Tzeentch_Realm_Data.teleportal_info.ai_teleports_to_reach_end then
						-- Teleport to final island
						x, y = unpack(final_teleportal_dest);
						final_area_entered = true;
					end
				end
				
				local final_x, final_y = cm:find_valid_spawn_location_for_character_from_position(faction_name, x, y, true);
				
				-- Check if player has entered final area
				local fin_x, fin_y = unpack(final_teleportal_dest);
				if x == fin_x and y == fin_y then
					final_area_entered = true;
				end
				
				out.chaos("\tCalculating teleport destination: " .. x .. ", " .. y .. " -> " .. final_x .. ", " .. final_y);
				
				if final_x ~= -1 then
					local display_x, display_y = cm:log_to_dis(final_x, final_y);
					cm:draw_text("Teleporting...", display_x, display_y, 15, 2, 0, 255, 255);
					
					cm:set_saved_value(faction_name .. "_exited_teleportal", x .. "," .. y);
					
					cm:teleport_to(char_str, final_x, final_y);
					
					cm:callback(
						function()
							cm:add_scripted_composite_scene_to_logical_position("teleport_vfx", "wh3_main_tze_teleporting_start", final_x,final_y, final_x + 1, final_y + 1, true, true, true)
							cm:add_scripted_composite_scene_to_logical_position("teleport_vfx", "wh3_main_tze_teleporting_stop", final_x,final_y, final_x + 1, final_y + 1, true, true, true)
						end,
						0.2
					);
					
					cm:zero_action_points(char_str);
					
					if faction_is_human then
						out.chaos("Entered teleportal [" .. start_teleportal .. "] - teleporting to " .. final_x .. ", " .. final_y);
						
						handle_revealing_sigils(true, faction_name, context:area_key());
						handle_revealing_sigils(true, faction_name, destination_marker_name);
						
						if final_area_entered and not cm:get_saved_value("teleportal_final_added") then
							cm:add_interactable_campaign_marker("final_teleportal", "wh3_main_tze_waystone", final_teleportal_dest[1], final_teleportal_dest[2], 2);
							
							cm:set_saved_value("teleportal_final_added", true);
						end;
						
						if cm:get_local_faction_name(true) == faction_name then
							local cached_x, cached_y, cached_d, cached_b, cached_h = cm:get_camera_position();
							cm:scroll_camera_from_current(false, 1, {display_x, display_y, cached_d, cached_b, cached_h});
						end;
					else
						out.chaos("Entered teleportal [" .. start_teleportal .. "] - teleporting to " .. final_x .. ", " .. final_y .. ". Teleports done: " .. ai_used_tzeentch_teleportals[faction_name] .. " / " .. Tzeentch_Realm_Data.teleportal_info.ai_teleports_to_reach_end);
					end;
				else
					script_error("Couldn't find position");
				end;
			end,
			true
		);
	end;
end;

-- Setup a table with POI rewards linked to dilemma options
function setup_poi_dilemma_choices()
	local dilemma_choices = cm:get_saved_value("dilemma_choice_per_poi") or {};
	local completed_poi_list = cm:get_saved_value("completed_poi_list") or nil;
	if not dilemma_choices then
		dilemma_choices = {};
	end

	if not completed_poi_list or next(completed_poi_list) == nil then
		-- Determine the amount of powerful rewards dilemmas to add to the pool
		local dilemma_options = {};
		local chance_of_powerful_rewards = cm:random_number(100);
		if chance_of_powerful_rewards <= 50 then
			table.insert(dilemma_options, Tzeentch_Realm_Data.teleportal_info.reward_dilemma);
		elseif chance_of_powerful_rewards > 50 and chance_of_powerful_rewards <= 80 then
			table.insert(dilemma_options, Tzeentch_Realm_Data.teleportal_info.reward_dilemma);
			table.insert(dilemma_options, Tzeentch_Realm_Data.teleportal_info.reward_dilemma);
		elseif chance_of_powerful_rewards > 80 then
			table.insert(dilemma_options, Tzeentch_Realm_Data.teleportal_info.reward_dilemma);
			table.insert(dilemma_options, Tzeentch_Realm_Data.teleportal_info.reward_dilemma);
			table.insert(dilemma_options, Tzeentch_Realm_Data.teleportal_info.reward_dilemma);
		end
		-- Fill remaining slots with the generic dilemma
		local remaining = 6 - #dilemma_options
		for _ = 1, remaining do
			table.insert(dilemma_options, Tzeentch_Realm_Data.teleportal_info.generic_dilemma);
		end

		-- Link a random dilemma choice to a corresponding POI
		local poi_markers = Tzeentch_Realm_Data.teleportal_info.poi_marker_locs;
		for k, _ in pairs(poi_markers) do
			local reward_choice = cm:random_number(#dilemma_options);
			if not dilemma_choices[k] then
				dilemma_choices[k] = {};
			end
			table.insert(dilemma_choices[k], dilemma_options[reward_choice]);
			table.remove(dilemma_options, reward_choice);
		end
		cm:set_saved_value("dilemma_choice_per_poi", dilemma_choices);
	end
end

function setup_poi_listeners()
	local poi_markers = Tzeentch_Realm_Data.teleportal_info.poi_marker_locs;
	local poi_to_dilemma_choice = cm:get_saved_value("dilemma_choice_per_poi");
	local completed_poi_list = cm:get_saved_value("completed_poi_list") or {};
	if not completed_poi_list then
		completed_poi_list = {};
	end;

	for marker_key, marker_pos in pairs(poi_markers) do
		if not completed_poi_list[marker_key] then
			-- Setup the interactable markers
			local x = marker_pos[1];
			local y = marker_pos[2];
			cm:remove_interactable_campaign_marker(marker_key);
			cm:add_interactable_campaign_marker(marker_key, "tzeentch_poi_marker_"..marker_key, x, y, 2);

			core:add_listener(
				marker_key,
				"AreaEntered",
				function(context)
					local character = context:family_member():character();
					if not character:is_null_interface() then
						local faction = character:faction();
						return context:area_key() == marker_key and faction:is_human() and cm:char_is_general_with_army(character);
					end;
				end,
				function(context)
					out.chaos("Entered POI [" .. context:area_key() .. "]");
					
					local family_member = context:family_member();
					local character = family_member:character();
					
					if character:is_null_interface() then
						return;
					end;

					local character_cqi = character:command_queue_index();
					local char_str = cm:char_lookup_str(character_cqi);
					local faction = character:faction();
					local faction_cqi = faction:command_queue_index();

					-- Trigger the dilemma
					if not poi_to_dilemma_choice or poi_to_dilemma_choice == {} then
						setup_poi_dilemma_choices();
						poi_to_dilemma_choice = cm:get_saved_value("dilemma_choice_per_poi");
					end;
					local dilemma_choice = poi_to_dilemma_choice[marker_key][1]
					
					local function trigger_poi_dilemma()
						local aoi_dilemma = cm:create_dilemma_builder(dilemma_choice);
						local aoi_dilemma_payload_1 = cm:create_payload();
						
						local recruitment_bundle = "wh3_main_tzeentch_realm_dilemma_global_recruit";
						
						if faction:culture() == "wh3_main_nur_nurgle" then
							recruitment_bundle = "wh3_main_tzeentch_realm_dilemma_recruit_cost_reduction";
						end;
						
						local payload_1_effect_bundle = cm:create_new_custom_effect_bundle(recruitment_bundle);
						payload_1_effect_bundle:set_duration(2);
						aoi_dilemma_payload_1:effect_bundle_to_faction(payload_1_effect_bundle);
						aoi_dilemma_payload_1:text_display("dummy_wh3_main_tzeentch_realm_replenishment_dilemma_payload");
						
						local aoi_dilemma_payload_2 = cm:create_payload();
							
						aoi_dilemma_payload_2:text_display("dummy_wh3_main_tzeentch_realm_reveal_icon_pair");
						aoi_dilemma_payload_2:text_display("dummy_wh3_main_tzeentch_realm_replenishment_dilemma_payload");
						
						aoi_dilemma:add_choice_payload("FIRST", aoi_dilemma_payload_1);
						aoi_dilemma:add_choice_payload("SECOND", aoi_dilemma_payload_2);
						
						if dilemma_choice == "wh3_main_realm_tzeentch_strong_effect_dilemma" then
							local effect_bundle_payloads = {
								{"wh3_main_tzeentch_realm_dilemma_reward_1", 9},
								{"wh3_main_tzeentch_realm_dilemma_reward_2", 9},
								{"wh3_main_tzeentch_realm_dilemma_reward_3", 1},
								{"wh3_main_tzeentch_realm_dilemma_reward_4", 9},
								{"wh3_main_tzeentch_realm_dilemma_reward_5", 9},
								{"wh3_main_tzeentch_realm_dilemma_reward_6", 9},
								{"wh3_main_tzeentch_realm_dilemma_reward_7", 9},
								{"wh3_main_tzeentch_realm_dilemma_reward_8", 9},
								{"wh3_main_tzeentch_realm_dilemma_reward_9", 9},
								{"wh3_main_tzeentch_realm_dilemma_reward_10", 9},
							};
							local aoi_dilemma_payload_3 = cm:create_payload();
							
							local selected_effect_bundle = effect_bundle_payloads[cm:random_number(#effect_bundle_payloads)];
							local payload_3_effect_bundle = cm:create_new_custom_effect_bundle(selected_effect_bundle[1]);
							payload_3_effect_bundle:set_duration(selected_effect_bundle[2]);
							aoi_dilemma_payload_3:effect_bundle_to_faction(payload_3_effect_bundle);
							aoi_dilemma_payload_3:text_display("dummy_wh3_main_tzeentch_realm_replenishment_dilemma_payload");
							
							aoi_dilemma:add_choice_payload("THIRD", aoi_dilemma_payload_3);
						end;
						
						aoi_dilemma:add_target("default", family_member);
						aoi_dilemma:add_target("default", faction);
						
						cm:launch_custom_dilemma_from_builder(aoi_dilemma, faction);
					end;
					
					if cm:model():pending_battle():is_active() then
						core:add_listener(
							"resolve_tzeentch_realm_dilemma_post_battle",
							"BattleCompleted",
							true,
							function()
								trigger_poi_dilemma();
							end,
							false
						);
					else
						trigger_poi_dilemma();
					end;
					
					-- Choice made effect listener
					core:add_listener(
						dilemma_choice,
						"DilemmaChoiceMadeEvent",
						function(context)
							return context:dilemma():starts_with(dilemma_choice);
						end,
						function(context)
							local faction = context:faction();
							local unit_list = faction:faction_leader():military_force():unit_list();
							
							if context:choice() == 1 then
								-- Reveal dual sigils
								handle_revealing_sigils(false, faction:name());
							end
							
							-- Replenish units in army to full
							for i = 0, unit_list:num_items() - 1 do
								cm:set_unit_hp_to_unary_of_maximum(unit_list:item_at(i), 1);
							end;
						end,
						false
					);
					
					-- Disable campaign marker and related listener
					cm:remove_interactable_campaign_marker(marker_key);
					core:remove_listener(marker_key);
					completed_poi_list[marker_key] = true;
					
					cm:set_saved_value("completed_poi_list", completed_poi_list);
					cm:set_saved_value("dilemma_choice_per_poi", poi_to_dilemma_choice);
				end,
				true
			);
		end;
	end
end

function setup_post_battle_option_listener()
	core:add_listener(
		"captive_option_reveal_tzeentch",
		"CharacterPostBattleCaptureOption",
		function(context)
			return context:get_outcome_key() == "kill" and cm:char_is_general_with_army(context:character()) and context:get_record_key() == "400532370";
		end,
		function(context)
			local faction_name = context:character():faction():name();
			handle_revealing_sigils(true, faction_name);
		end,
		true
	);
end

function setup_sigil_reveals(faction)
	local layout_set_chosen = cm:get_saved_value("chosen_teleportals_layout");
	local faction_start_loc = Tzeentch_Realm_Data.teleportal_info.faction_to_starting_island[faction];
	local layout_for_faction = Tzeentch_Realm_Data.teleportal_layout_sets[faction_start_loc][layout_set_chosen[faction]];
	
	local sigil_reveal_to_faction = cm:get_saved_value("sigil_reveal_to_faction") or {};
	if not sigil_reveal_to_faction[faction] then
		sigil_reveal_to_faction[faction] = {};
	end
	
	for i = 1, #layout_for_faction do
		local sigil = layout_for_faction[i].icon_pair
		local sigil_data_1 = {Tzeentch_Realm_Data.teleportal_info.icon[sigil], 1, layout_for_faction[i].coordinates[1]};
		local sigil_data_2 = {Tzeentch_Realm_Data.teleportal_info.icon[sigil], 2, layout_for_faction[i].coordinates[2]};
		table.insert(sigil_reveal_to_faction[faction], sigil_data_1);
		table.insert(sigil_reveal_to_faction[faction], sigil_data_2);
	end
	
	cm:set_saved_value("sigil_reveal_to_faction", sigil_reveal_to_faction);
end

-- Reveal a single sigil at specified position for given faction
-- Optional final parameter to prevent camera movement
function reveal_sigil(single_sigil_only, scene_name, composite_scene_key, position, faction_name, opt_sigil_pair_reveal, dont_pan_camera)
	local faction_script_interface = cm:get_faction(faction_name);
	local marker_info = Tzeentch_Realm_Data.teleportal_info.marker_loc[position]
	local x = marker_info[1];
	local y = marker_info[2];
	-- string name, string composite scene, number x, number x, number facing x, number facing y, boolean one shot, boolean show in seen shroud, boolean show in unseen shroud
	cm:add_scripted_composite_scene_to_logical_position(scene_name, composite_scene_key, x, y, 0, 0, false, true, true, faction_script_interface);
	
	out.chaos("Adding sigil " .. scene_name .. " to " .. x .. ", " .. y);
	
	-- Move camera to revealed sigil if not prevented
	local cached_x, cached_y, cached_d, cached_b, cached_h = cm:get_camera_position();
	
	local display_x, display_y = cm:log_to_dis(x, y);
	local delay_before_panning = 0.4
	local pan_duration = 1.5
	local hold_time = 2
	
	if opt_sigil_pair_reveal then
		delay_before_panning = delay_before_panning + pan_duration + hold_time
	end
	
	if not dont_pan_camera then
		local is_local_faction = cm:get_local_faction_name(true) == faction_name
		
		cm:callback(
			function()
				if not cm:model():pending_battle():is_active() and is_local_faction then
					cm:scroll_camera_from_current(true, pan_duration, {display_x, display_y, 6, 0, 6});
				end
			end,
			delay_before_panning
		)
		
		if single_sigil_only or opt_sigil_pair_reveal then
			if single_sigil_only then
				delay_before_panning = delay_before_panning + pan_duration + hold_time
			else
				delay_before_panning = delay_before_panning * 2
			end
			
			cm:callback(
				function()
					if not cm:model():pending_battle():is_active() and is_local_faction then
						cm:scroll_camera_from_current(true, pan_duration, {cached_x, cached_y, cached_d, cached_b, cached_h})
					end
				end,
				delay_before_panning
			)
		end
	end
end

-- Handles finding a valid single or dual sigil to reveal
function handle_revealing_sigils(single_sigil_only, faction_name, location)
	local sigil_reveal_to_faction = cm:get_saved_value("sigil_reveal_to_faction");
	local sigils_revealed = cm:get_saved_value("sigils_revealed_per_faction") or {};
	local total_sigils_available = #sigil_reveal_to_faction[faction_name];
	local sigil_index = 0;
	
	if location then
		for i = 1, #sigil_reveal_to_faction[faction_name] do
			if sigil_reveal_to_faction[faction_name][i][3] == location then
				sigil_index = i
				break;
			end
		end
	else
		sigil_index = cm:random_number(total_sigils_available);
	end
	
	local sigil_to_reveal = sigil_reveal_to_faction[faction_name][sigil_index];
	local sigil_name = sigil_to_reveal[1];
	local sigil_number = sigil_to_reveal[2];
	local sigil_coords = sigil_to_reveal[3];
	local scence_name = "sigil_reveal_" .. faction_name .. "_" .. sigil_name;
	
	reveal_sigil(single_sigil_only, scence_name .. "_" .. sigil_number, sigil_name, sigil_coords, faction_name, false, not not location);
	
	-- Revealed sigil moved to revealed list
	table.remove(sigil_reveal_to_faction[faction_name], sigil_index);
	
	if not sigils_revealed[faction_name] then
		sigils_revealed[faction_name] = {};
	end
	
	table.insert(sigils_revealed[faction_name], {sigil_name, sigil_number})
	
	-- Find pair sigil if revealing pair
	if not single_sigil_only then
		-- Find pair sigil, if its available, and reveal it as well
		for i = 1, total_sigils_available do
			local sigil_2 = sigil_reveal_to_faction[faction_name][i]
			
			if sigil_2 and sigil_2[1] == sigil_name then
				local sigil_2_name = sigil_2[1];
				local sigil_2_number = sigil_2[2];
				local sigil_2_coords = sigil_2[3];
				local scence_name = "sigil_reveal_" .. faction_name .. "_" .. sigil_2_name;
				
				reveal_sigil(single_sigil_only, scence_name .. "_" .. sigil_2_number, sigil_2_name, sigil_2_coords, faction_name, true, not not location);
				
				-- Move revealed sigil to revealed list
				table.remove(sigil_reveal_to_faction[faction_name], i);
				table.insert(sigils_revealed[faction_name], {sigil_2_name, sigil_2_number})
				break;
			end
		end
	end
	
	cm:set_saved_value("sigil_reveal_to_faction", sigil_reveal_to_faction);
	cm:set_saved_value("sigils_revealed_per_faction", sigils_revealed);
end

function close_tzeentch_realm()
	kill_realm_armies(Tzeentch_Realm_Data.creep_armies);
	
	tzeentch_realm_initialised = false;
	
	cm:remove_hex_area_trigger("ai_tzeentch_end");
	cm:remove_interactable_campaign_marker("final_teleportal");
	
	core:remove_listener("repeat_movement_tzeentch_realm");
	core:remove_listener("ai_reaches_end_of_tzeentch_realm");
	core:remove_listener("final_teleportal_entered");
	core:remove_listener("captive_option_reveal_tzeentch");
	
	cm:set_saved_value("teleportal_final_added", false);
	
	for i = 1, #Tzeentch_Realm_Data.teleportal_info.marker_id do
		cm:remove_interactable_campaign_marker(Tzeentch_Realm_Data.teleportal_info.marker_id[i]);
		core:remove_listener(Tzeentch_Realm_Data.teleportal_info.marker_id[i]);
	end
	
	for marker_key, _ in pairs(Tzeentch_Realm_Data.teleportal_info.poi_marker_locs) do
		cm:remove_interactable_campaign_marker(marker_key);
		core:remove_listener(marker_key);
	end;
	
	local sigils_revealed = cm:get_saved_value("sigils_revealed_per_faction") or {};
	for faction_name, sigils in pairs(sigils_revealed) do
		for i = 1, #sigils do
			local scene_name = "sigil_reveal_" .. faction_name .. "_" .. sigils[i][1] .. "_" .. sigils[i][2];
			cm:remove_scripted_composite_scene(scene_name);
		end
	end
	
	cm:set_saved_value("sigils_revealed_per_faction", false);
	cm:set_saved_value("sigil_reveal_to_faction", false);
	cm:set_saved_value("dilemma_choice_per_poi", false);
	cm:set_saved_value("ai_used_tzeentch_teleportals", false);
	cm:set_saved_value("marker_to_teleport_values", false);
	cm:set_saved_value("chosen_teleportals_layout", false);
	cm:set_saved_value("tzeentch_realm_active", false);
	cm:set_saved_value("completed_poi_list", false);
end;

-- Returns if base value falls within a given range of target value
function is_within_range(target_value, base_value, range_deviation)
	return target_value <= (base_value + range_deviation) and target_value >= (base_value - range_deviation);
end;