function add_green_knight_listeners()
	out("#### Adding Green Knight Listeners ####")
	
	if not cm:are_any_factions_human(nil, "wh_main_brt_bretonnia") then
		core:add_listener(
			"Bret_Green_Knight_FactionTurnStart",
			"FactionTurnStart",
			function(context)
				local faction = context:faction()
				return faction:can_be_human() and faction:culture() == "wh_main_brt_bretonnia"
			end,
			function(context)
				local faction = context:faction()
				
				for _, unique_agent in model_pairs(faction:unique_agents()) do
					if unique_agent:agent_subtype_key() == "wh_dlc07_brt_green_knight" and unique_agent:valid() then
						out("Attempting to spawn AI Green Knight for faction " .. faction:name())
						cm:spawn_unique_agent(faction:command_queue_index(), "wh_dlc07_brt_green_knight", false)
						break
					end
				end
			end,
			true
		)
	end
	
	core:add_listener(
		"Bret_UniqueAgentSpawned",
		"UniqueAgentSpawned",
		function(context)
			local character = context:unique_agent_details():character()
			
			return not character:is_null_interface() and character:character_subtype("wh_dlc07_brt_green_knight")
		end,
		function(context)
			out("#### Green Knight Spawned ####")
			local character = context:unique_agent_details():character()
			local faction = character:faction()
			
			if faction:is_human() and cm:get_local_faction(true) == faction then
				-- fly camera to Green Knight
				cm:scroll_camera_from_current(false, 1, {character:display_position_x(), character:display_position_y(), 14.7, 0.0, 12.0})
			end
		end,
		true
	)
	
	core:add_listener(
		"Bret_UniqueAgentDespawned",
		"UniqueAgentDespawned",
		function(context)
			local character = context:unique_agent_details():character()
			
			return not character:is_null_interface() and character:character_subtype("wh_dlc07_brt_green_knight") and character:faction():is_human()
		end,
		function(context)
			local character = context:unique_agent_details():character()
			
			cm:show_message_event_located(
				character:faction():name(),
				"event_feed_strings_text_wh_event_feed_string_legendary_hero_departed_title",
				"event_feed_strings_text_wh_event_feed_string_legendary_hero_departed_primary_detail",
				"event_feed_strings_text_wh_event_feed_string_legendary_hero_departed_secondary_detail",
				character:logical_position_x(),
				character:logical_position_y(),
				false,
				702
			)
		end,
		true
	)
end