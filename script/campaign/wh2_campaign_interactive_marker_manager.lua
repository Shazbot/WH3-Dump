--System for controlling campaign markers. Allows you to create a marker 'type' then spawn specified instances of that marker.


Interactive_Marker_Manager = {
	marker_list = {
	}
}

marker = {}

-----------------------
---MARKER MANAGEMENT-------
-----------------------

-- creates a new marker manager type object
function Interactive_Marker_Manager:new_marker_type(key, marker_info, opt_duration, opt_radius, opt_faction_filter, opt_subculture_filter, opt_lord_only)
	out.design("Interactive Marker Manager: Creating New Marker Type with key [" .. key .. "]");
	

	for i = 1, #self.marker_list do
		if key == self.marker_list[i].key then
			out.design("\tMarker type with key [" .. key .. "] already exists!");
			return false;
		end
	end

	local new_marker = marker:new()
	new_marker.key = key
	new_marker.marker_info = marker_info
	new_marker.persistent = true
	new_marker.allow_loaned_characters = true
	new_marker.radius = opt_radius or 1
	new_marker.faction_filter = opt_faction_filter or ""
	new_marker.subculture_filter = opt_subculture_filter or ""
	new_marker.despawn_settings = {
		should_despawn = true,
		dilemma_choices = nil
	}
	new_marker.instances = {}
	new_marker.duration = opt_duration or -1
	new_marker.listeners_set_up = false
	new_marker.lord_only = true or opt_lord_only
	new_marker.dilemma_choice_events = {}
	out.design("\tMarker with key [" .. key .. "] created!");
	self.marker_list[key] = new_marker

	return new_marker;
end

---return a marker type object by its unique key
function Interactive_Marker_Manager:get_marker(key)
	if key ~= nil then
		if self.marker_list[key] ~= nil then
			return self.marker_list[key];
		else 
			return false
		end
	end
end



---------------------------
---INTERACTION BEHAVIOUR---
---------------------------

--should the marker disappear when a valid force interacts with it? defaults to true if this function not called
--if dilemma choices not provided, will despawn immediately on interaction, regardless of dilemma choices
-- if dilemma choices are given will only despawn when one of those choices is made.
--dilemma choices takes a value corresponding to a dilemma choice (0-1-2-3) or a table of those values
function marker:despawn_on_interaction(should_despawn, opt_dilemma_choices)
	if not is_boolean(should_despawn) then
		script_error("Marker Manager - trying to add despawn condition for marker "..self.key.." but should_despawn is not a bool")
		return false
	end

	local opt_dilemma_choices = opt_dilemma_choices or nil

	if not opt_dilemma_choices == nil and (not is_number(opt_dilemma_choices) or not is_table(opt_dilemma_choices)) then
		script_error("Marker Manager - received dilemma choices parameter for marker "..self.key.." but dilemma choices is not a table or number")
		return false
	end

	if is_number(opt_dilemma_choices) then
		opt_dilemma_choices = {opt_dilemma_choices}
	end
	
	self.despawn_settings = {should_despawn = true, dilemma_choices = opt_dilemma_choices}
end

---add a dilemma to trigger when interacting with the marker
--- by default only interactable by lords, but you can enable this for heroes too.
function marker:add_dilemma(dilemma_key, opt_lord_only)
	if not is_string(dilemma_key) then
		script_error("Marker Manager - trying to add a dilemma for marker "..self.key.." but dilemma_key is not a string")
		return false
	end

	self.dilemma_key = dilemma_key
	self.dilemma_lord_only = true or opt_lord_only
end

--define the event that will fire when the marker despawns because it has reached the end of its duration
--event will have the following context objects: context.stored_table.marker_ref, context.stored_table.instance_ref
--you can then use this event to fire listeners
--you can also add a new marker that will
function marker:add_timeout_event(string_event_name, followup_marker_key)

	if not is_string(string_event_name) then
		script_error("Marker Manager - trying to add a despawn event for marker "..self.key.." but string_event_name is not a string")
		return false
	end
	self.timeout_event = string_event_name

	if is_string(followup_marker_key) then
		self.followup_marker = followup_marker_key
	end
end

--define event to fire when valid force interacts with marker
--event will return with the character who interacted (context:character) and a custom context table
--dilemma choices takes a value corresponding to a dilemma choice (0-1-2-3)
--if dilemma choice(s) specified, will only fire if those specific choices are made
--by default only fires for lords
function marker:add_interaction_event(string_event_name, opt_dilemma_choice, opt_lord_only)
	if not is_string(string_event_name) then
		script_error("Marker Manager - trying to add interaction event for marker "..self.key.." but string_event_name is not a function")
		return false
	end

	local dilemma_choice = opt_dilemma_choice or nil

	self.interaction_event_lord_only = true or opt_lord_only

	if dilemma_choice == nil then 
		self.interaction_event =  string_event_name
		return
	end

	if not is_number(dilemma_choice) and not is_table(dilemma_choice)then
		script_error("Marker Manager - received dilemma choices parameter for marker "..self.key.." but dilemma choices is not a table or number")
		return false
	end

	---add 1 because dilemma choices start at 0 but lua arrays start at 1...
	table.insert(self.dilemma_choice_events, dilemma_choice+1, string_event_name)
	

end

function marker:add_spawn_event_feed_event(title, detail_1, detail_2, picture, opt_faction_filter, opt_subculture_filter)
	self.event_feed_event = {}
	self.event_feed_event.title = title or ""
	self.event_feed_event.detail_1 = detail_1 or ""
	self.event_feed_event.detail_2 = detail_2 or ""
	self.event_feed_event.picture = picture or 0
	self.event_feed_event.faction_filter = opt_faction_filter or false
	self.event_feed_event.subculture_filter = opt_subculture_filter or false
end

--- despawn event feed to fire if the marker expires naturally (i.e. not via interaction)
function marker:add_despawn_event_feed_event(title, detail_1, detail_2, picture, opt_faction_filter, opt_subculture_filter)
	self.despawn_event_feed_event = {}
	self.despawn_event_feed_event.title = title or ""
	self.despawn_event_feed_event.detail_1 = detail_1 or ""
	self.despawn_event_feed_event.detail_2 = detail_2 or ""
	self.despawn_event_feed_event.picture = picture or 0
	self.despawn_event_feed_event.faction_filter = opt_faction_filter or false
	self.despawn_event_feed_event.subculture_filter = opt_subculture_filter or false
end	



-------------------------
---SPAWN/DESPAWN BEHAVIOUR
-------------------------
---spawning options. You currently cannot spawn multiple markers of the same type at a single region, character or location
function marker:spawn_at_character(character_cqi, is_despawn, opt_same_region, opt_prefered_distance)
	local marker_instance_ref = self.key..character_cqi
	local character = cm:get_character_by_cqi(character_cqi)
	local same_region = opt_same_region or true 
	local prefered_distance = opt_prefered_distance or 0

	if character == false then
		script_error("Marker Manager - trying to spawn a marker at a character with cqi "..character_cqi.." but this character can't be found")
		return false
	end

	local faction = character:faction():name()
	local x,y = cm:find_valid_spawn_location_for_character_from_character(faction,"character_cqi:"..character_cqi,same_region,prefered_distance)

	if is_despawn then
		return self:despawn(marker_instance_ref)
	else
		return self:spawn(marker_instance_ref,x,y)
	end
end

---spawning options. You currently cannot spawn multiple markers of the same type at a single region, character or location
function marker:spawn_at_region(region_key, is_despawn, opt_on_sea, opt_same_region, opt_prefered_distance, opt_faction_key)
	local marker_instance_ref = self.key..region_key
	local region_interface = cm:get_region(region_key)

	local on_sea = opt_on_sea or false
	local same_region = opt_same_region or true 
	local prefered_distance = opt_prefered_distance or 0


	if region_interface == false then
		script_error("Marker Manager - trying to spawn a marker at a region with key "..region_key.." but this region can't be found")
		return false
	end

	local faction_key

	if region_interface:is_abandoned() then
		if not opt_faction_key then
			script_error(string.format("Marker Manager - Region '%s' was abandoned, so you must provide an opt_faction when spawning marker '%s'.", region_key, self.key))
		else
			faction_key = opt_faction_key
		end
	else
		faction_key = region_interface:owning_faction():name()
	end

	local x,y = cm:find_valid_spawn_location_for_character_from_settlement(faction_key, region_key, on_sea, same_region, prefered_distance)

	if is_despawn then
		return self:despawn(marker_instance_ref)
	else
		return self:spawn(marker_instance_ref,x,y)
	end
end

---spawning options. You currently cannot spawn multiple markers of the same type at a single region, character or location
function marker:spawn_at_location(x,y, is_despawn,opt_same_region,opt_prefered_distance)
	local marker_instance_ref = self.key..x..y
	local faction = cm:whose_turn_is_it():item_at(0):name()
	local same_region = opt_same_region or true 
	local prefered_distance = opt_prefered_distance or 0
	local new_x,new_y = cm:find_valid_spawn_location_for_character_from_position(faction,x,y,same_region,prefered_distance)

	if is_despawn then
		return self:despawn(marker_instance_ref)
	else
		return self:spawn(marker_instance_ref,new_x,new_y)
	end
end



---by default, marker types will be saved even if the instances are despawned. If you want to clear out the marker type after an instance is despawned, use this
function marker:is_persistent(bool)
	self.persistent = bool
end

---by default, markers will allow loaned characters to trigger the AreaEntered event. Set this to false to exclude them
function marker:set_loaned_characters_allowed(bool)
	self.allow_loaned_characters = bool
end

-----------------
---SPECIAL-------
-----------------
function Interactive_Marker_Manager:create_countdown(base_key,interaction_event,expiry_event,array_of_campaign_marker_interactable_infos,faction_turn)

	local table_of_markers = {}
	local faction_turn = faction_turn or nil

	for i =1, #array_of_campaign_marker_interactable_infos do
		local marker_type = array_of_campaign_marker_interactable_infos[i]
		local countdown_marker = self:new_marker_type(base_key.."_"..marker_type, marker_type,1,1)
		if i == #array_of_campaign_marker_interactable_infos then 
			countdown_marker:add_timeout_event(expiry_event)
		else
			local next_marker_key = base_key.."_"..array_of_campaign_marker_interactable_infos[i+1]
			countdown_marker:add_timeout_event("ScriptEventMarkerCountdown"..base_key..i.."TurnsRemaining", next_marker_key)
		end		
		countdown_marker:add_interaction_event(interaction_event)
		table.insert(table_of_markers, countdown_marker)
	end

	return table_of_markers
end
---------------
---INTERNAL------
---------------
---puts together all the marker objects and their listeners based on saved marker data. Called during campaign setup
function Interactive_Marker_Manager:reconstruct_markers()
	out("reconstructing markers and listeners from saved data")
	for key, value in pairs(self.marker_list) do
		local loaded_marker = marker:new(value)
		self.marker_list[key] = loaded_marker
		out.design("Interactive Marker Manager: Loading marker with key "..key)
		if loaded_marker.listeners_set_up then
			loaded_marker:set_up_listeners()
		end
	end
end

function marker:new(o)
	o = o or {};
	setmetatable(o, self);
	self.__index = self;
	return o;
end

---use this to grab the x/y coordinates of a spawned marker. Useful for listeners as they don't get this info directly from the context
function Interactive_Marker_Manager:get_coords_from_instance_ref(string_instance_ref)
	if not is_string(string_instance_ref) then
		script_error("Marker manager - trying to get coords from a marker instance reference, but supplied reference is not a string!")
		return false
	end
	local found_instance = false
	local found_instance_x
	local found_instance_y
	for key, marker in pairs(self.marker_list) do
		local instances = marker.instances
		if instances[string_instance_ref] ~= nil then
			found_instance = true
			found_instance_x = instances[string_instance_ref].stored_x
			found_instance_y = instances[string_instance_ref].stored_y
			break
		end
	end

	if not found_instance then
		script_error("Marker manager - trying to get coords from a marker instance reference, but supplied reference "..string_instance_ref.." cannot be found!")
		return false
	end

	return found_instance_x,found_instance_y
end

---set up all the listeners for this marker. 
--Called the first time a marker of a type is spawned, but can be called separately if you want to add new listeners
function marker:set_up_listeners()
	self:set_up_interaction_listener()
	
	if self.dilemma_key ~= nil then
		self:set_up_dilemma_choice_listener()
	end

	if self.duration > 0 then
		self:set_up_duration_listener()
	end
	
end

--listens for a character entering the marker and acts if it has any follow-ups that aren't linked to dilemmas
function marker:set_up_interaction_listener()
	core:add_listener(
		self.key.."AreaEntered",
		"AreaEntered",
		function(context)
			return self.key == string.match(context:area_key(),self.key);
		end,
		function(context)
			local character = context:family_member():character();
			if character:is_null_interface() then
				return;
			end;

			local faction = character:faction()
			local faction_key = faction:name()
			local has_military_force = character:has_military_force()

			if not faction:is_human() then
				return
			end

			if not self.allow_loaned_characters and character:is_loaned() then
				return
			end

			-- check to make sure there's not already a dilemma triggered character stored as it probably means the player has managed to enter the marker twice in the same go
			if self.dilemma_key ~= nil and not (not has_military_force and self.dilemma_lord_only) and not self.dilemma_triggered_character then
				cm:trigger_dilemma(faction_key, self.dilemma_key)
				---save the area that triggered the dilemma now as we can't get it from the dilemma choice listener
				self.dilemma_triggered_area = context:area_key()
				self.dilemma_triggered_character = character
				
			end

			---stop here if this is a lord-only event
			if not has_military_force and self.interaction_event_lord_only then
				return
			end

			if self.interaction_event ~= nil then 
				local area_info = {
					instance_ref = context:area_key(),
					marker_ref = self.key}

				core:trigger_event(self.interaction_event, area_info, character)
			end

			if self.despawn_settings.should_despawn == true and self.despawn_settings.dilemma_choices == nil then 
				self:despawn(context:area_key(), true)
			end
		end,
		true
	);
end

--listens for assigned dilemma and checks whether the choice should trigger a response
function marker:set_up_dilemma_choice_listener()
	core:add_listener(
		self.key.."DilemmaChoiceMadeEvent",
		"DilemmaChoiceMadeEvent",
		function(context)
			return self.dilemma_key == context:dilemma();
		end,
		function(context)

			local choice = context:choice()

			--- was the dilemma choice marked as one that should trigger a followup?
			--- add one to the choice here as dilemma choices start at 0, but lua arrays start at 1.
			if self.dilemma_choice_events[choice+1] ~= nil then 
					local area_info = {
						instance_ref = self.dilemma_triggered_area,
						marker_ref = self.key}
					local character = self.dilemma_triggered_character

					core:trigger_event(self.dilemma_choice_events[choice+1], area_info, character)
			end

			--- was the dilemma choice marked as one that should cause a despawn?
			if self.despawn_settings.dilemma_choices ~= nil then 
				local dilemma_despawn_valid_choices = self.despawn_settings.dilemma_choices
				local choice_was_valid = false

				for i=1, #dilemma_despawn_valid_choices do 
					if choice == dilemma_despawn_valid_choices[i] then
						choice_was_valid = true
						break
					end
				end

				if choice_was_valid then
					self:despawn(self.dilemma_triggered_area, true)
					
				end
			end


			---IMPORTANT - purge the character data here as if the game tries to save with it then it can mess up the stored marker data
			self.dilemma_triggered_character = nil
			self.dilemma_triggered_area = nil
		end,
		true
	);
end

--creates a listener for the duration countdown finished event
function marker:set_up_duration_listener()
	core:add_listener(
		"ScriptEventMarkerCountdownCompleted"..self.key,
		"ScriptEventMarkerCountdownCompleted"..self.key,
		function(context)
			local instance_ref = context.string
			if self.instances[instance_ref] ~= nil then
				return true
			end
		end,
		function(context)
			local instance_ref = context.string
			local area_info = {
				instance_ref =  instance_ref,
				marker_ref = self.key
			}
			local x, y = Interactive_Marker_Manager:get_coords_from_instance_ref(instance_ref)

			if self.timeout_event ~= nil then
				core:trigger_event(self.timeout_event, area_info)
			end

			self:despawn(instance_ref, false)

			if self.followup_marker ~= nil then
				local next_marker = Interactive_Marker_Manager:get_marker(self.followup_marker)
				next_marker:spawn_at_location(x,y,false,true,0)
			end
		end,
		true
	);
end


---spawns a marker, and sets up all the listeners
---can be used in place of spawn_at_location if you want to define a specific instance ref, but won't check for valid pathfinding.
function marker:spawn(marker_instance_ref,x,y)

	if self.instances ~= nil then
		for i = 1, #self.instances do
			if marker_instance_ref == self.instances[i] then
				script_error("Marker Manager - trying to spawn two markers with the reference "..marker_instance_ref.." - this shouldn't happen");
				return false;
			end
		end
	else	
		self.instances = {}
	end

	if x == -1 then
		script_error("Marker Manager - trying to spawn "..marker_instance_ref.." at an invalid coordinate, something has gone wrong");
			return false;
	end

	if self.duration > 0 then
		local faction = cm:whose_turn_is_it():item_at(0):name()
		cm:add_turn_countdown_event(faction,self.duration,"ScriptEventMarkerCountdownCompleted"..self.key,marker_instance_ref)
	end

	cm:add_interactable_campaign_marker(marker_instance_ref, self.marker_info, x, y, self.radius, self.faction_filter, self.subculture_filter)
	
	local stored_instance_data = {spawned = true,stored_x = x,stored_y = y}
	self.instances[marker_instance_ref] = stored_instance_data
	
	if not self.listeners_set_up then
		self:set_up_listeners()
		self.listeners_set_up = true
	end

	local coords = {x,y}
	
	core:trigger_event("ScriptEventMarkerSpawned", coords, marker_instance_ref)

	if self.event_feed_event ~= nil then
		local human_players = cm:get_human_factions()
		for i = 1, #human_players do
			local player_interface = cm:get_faction(human_players[i])
			local is_valid_for_event = true
			if self.event_feed_event.faction_filter ~= false and player_interface:name() ~= self.event_feed_event.faction_filter then
				is_valid_for_event = false
			end

			if self.event_feed_event.subculture_filter ~= false and player_interface:subculture() ~= self.event_feed_event.subculture_filter then
				is_valid_for_event = false
			end

			if is_valid_for_event then 
				cm:show_message_event_located(
						human_players[i],
						self.event_feed_event.title,
						self.event_feed_event.detail_1,
						self.event_feed_event.detail_2,
						x,
						y,
						true,
						self.event_feed_event.picture
					)
			end
		end
	end
end

--despawns the specified marker
function marker:despawn(marker_instance_ref, suppress_events)
	if not is_string(marker_instance_ref) then
		script_error("Marker Manager - trying to despawn a marker, but the provided reference isn't a string")
		return
	end

	if not is_table(self.instances[marker_instance_ref]) then
		script_error("Marker Manager - trying to despawn a marker with ref "..marker_instance_ref.." but that marker instance doesn't exist. We've asked the code to remove a marker with that name, but follow-up events won't trigger ")
		cm:remove_interactable_campaign_marker(marker_instance_ref)
		return
	end

	local x,y = Interactive_Marker_Manager:get_coords_from_instance_ref(marker_instance_ref)

	if self.despawn_event_feed_event ~= nil and not suppress_events then
		local human_players = cm:get_human_factions()
		for i = 1, #human_players do
			local player_interface = cm:get_faction(human_players[i])
			local is_valid_for_event = true

			if self.event_feed_event.faction_filter ~= false and player_interface:name() ~= self.event_feed_event.faction_filter then
				is_valid_for_event = false
			end

			if self.event_feed_event.subculture_filter ~= false and player_interface:subculture() ~= self.event_feed_event.subculture_filter then
				is_valid_for_event = false
			end

			if is_valid_for_event then 
				cm:show_message_event_located(
						human_players[i],
						self.despawn_event_feed_event.title,
						self.despawn_event_feed_event.detail_1,
						self.despawn_event_feed_event.detail_2,
						x,
						y,
						true,
						self.despawn_event_feed_event.picture
					)
			end
		end
	end

	self.instances[marker_instance_ref] = nil
	cm:remove_interactable_campaign_marker(marker_instance_ref)
	
	--- if this is a one-off, delete the marker type data
	if self.persistent == false then
		Interactive_Marker_Manager:clear_marker_type(self.key)
	end
end

--- force all markers of a type created by the manager to despawn
function marker:despawn_all()
	local instances_to_remove= self.instances

	for k,v in pairs(instances_to_remove) do
		self:despawn(k, true)
	end
end


function Interactive_Marker_Manager:clear_marker_type(marker_type_key)
	if self.marker_list[marker_type_key] ~= nil then
		if #self.marker_list[marker_type_key].instances > 0 then
			self.marker_list[marker_type_key]:despawn_all()
		end
		self.marker_list[marker_type_key] = nil
	end
end
-------------------------
---SAVE/LOAD BEHAVIOUR
-------------------------
cm:add_saving_game_callback(
	function(context)
		--- because we cannot save a script interface without tanking the whole system, double-check to make sure any such data been properly purged before saving.
		for marker_key, marker in pairs(Interactive_Marker_Manager.marker_list) do 
			if marker.dilemma_triggered_character ~= nil then
				script_error("Marker Manager - Trying to save the marker list while it still contains character script interfaces! Please inform Will W!")
				marker.dilemma_triggered_character = nil
			end
		end

		cm:save_named_value("ACTIVE_MARKERS", Interactive_Marker_Manager.marker_list, context);

	end
);


cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			Interactive_Marker_Manager.marker_list = cm:load_named_value("ACTIVE_MARKERS", {}, context);
		end
	end
);