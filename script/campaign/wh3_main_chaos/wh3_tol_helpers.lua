-------------------------------------------------------
--	helper functions  ---------------------------------
-------------------------------------------------------

function tol_shared_setup()
	cm:toggle_dilemma_generation(false)
	common.call_context_command("CcoCampaignPendingActionNotificationQueue", "", "ToggleSupressNotificationType('ALLIED_BUILDINGS_CONSTRUCTION_AVAILABLE', true)")
end



--pass this function a region(string) and faction(string)
function region_change(region_name, faction_name, buildings, surplus)
	--check the region key is a string
	if not is_string(region_name) then
		script_error("ERROR: region_change() called but supplied target region key [" .. tostring(region_name) .. "] is not a string");
		return false;
	end;
	
	--check the faction key is a string
	if not is_string(faction_name) then
		script_error("ERROR: region_change() called but supplied target faction key [" .. tostring(faction_name) .. "] is not a string");
		return false;
	end;
	
	cm:disable_event_feed_events(true, "wh_event_category_conquest", "", "")
	cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "")
	cm:disable_event_feed_events(true, "wh_event_category_provinces", "", "")
	cm:transfer_region_to_faction(region_name, faction_name);
	
	if buildings then
		for i = 1, #buildings do
			cm:add_building_to_settlement(region_name, buildings[i]);
		end;
	end;
	
	if surplus then
		cm:add_development_points_to_region(region_name, surplus);
	end;
	
	cm:callback(
		function()
			cm:heal_garrison(cm:get_region(region_name):cqi());
			cm:disable_event_feed_events(false, "wh_event_category_conquest", "", "");
			cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "");
			cm:disable_event_feed_events(false, "wh_event_category_provinces", "", "");
		end,
		0.5
	);
end;

function region_change_faction_to_faction(source_faction, target_faction)
	local region_list = cm:get_faction(source_faction):region_list();
	
	for i = 0, region_list:num_items() - 1 do
		region_change(region_list:item_at(i):name(), target_faction);
	end;
end;

function teleport_character_faction_leader(faction_key, target_x, target_y)
	local faction = cm:get_faction(faction_key);
	
	if faction then
		cm:teleport_to(cm:char_lookup_str(faction:faction_leader()), target_x, target_y, false);
	end;
end;

function teleport_character_by_forename(faction_key, forename, target_x, target_y)
	local faction = cm:get_faction(faction_key);
	
	if faction then
		local char_list = faction:character_list();
		
		for i = 0, char_list:num_items() - 1 do
			local current_char = char_list:item_at(i);
			
			if current_char:get_forename() == forename then
				cm:teleport_to(cm:char_lookup_str(current_char), target_x, target_y, false);
				return true;
			end;
		end;
	end;
end;

--pass the faction key(string)
function kill_faction(faction_key)
	--check the faction key is a string
	if not is_string(faction_key) then
		script_error("ERROR: kill_faction() called but supplied region key [" .. tostring(faction_key) .. "] is not a string");
		return false;
	end;
	
	local faction = cm:model():world():faction_by_key(faction_key); 
	
	if faction:is_null_interface() == false then
		cm:disable_event_feed_events(true, "wh_event_category_conquest", "", "")
		cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "")
		
		cm:kill_all_armies_for_faction(faction);
		
		local region_list = faction:region_list();
		
		for j = 0, region_list:num_items() - 1 do
			local region = region_list:item_at(j):name();
			cm:set_region_abandoned(region);
		end;
		
		cm:callback(
			function() 
				cm:disable_event_feed_events(false, "wh_event_category_conquest", "", "");
				cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "");
			end,
			0.5
		);
	end;
end;
