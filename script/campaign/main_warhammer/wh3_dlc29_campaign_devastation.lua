cataclysmic_events = {
	config = {
		-- Every region in the game may belong to a *campaign map event area*. Each area supports a specific type of cataclysmic event.
		-- Currently, the UX involves always targeting a particular region but when a cataclysmic event is invoked, it will affect all regions
		-- in the same area as the targeted region. The cataclysmic events happen in the following way:

		-- 1. A player or an AI performs an instant culture-dependent *initiating ritual*, targeted at a region.
		-- 2. A script listener detects the completion of the initiating ritual and spawns an *invoking character* in or close to the targeted region.
		--    The spawnable force containing the invoking character is culture-dependent, configured below. Killing that force will cancel the invocation.
		-- 3. The invocation is associated with a counter. When it runs out, an instant finishing ritual is automaticaly performed on the targeted region.
		-- 4. A script listener detects the completion of the finishing ritual and applies the cataclysmic event to all regions in the area.

		-- Why don't we just target provinces: the boundaries of the desctructible areas on the campaign map do not always match
		-- the province boundaries because of large unsplittable objects such as mountains that have to be contained in a single area.

		-- This table maps the event area types to the finishing rituals that are performed when the cataclysmic events are invoked.
		-- TODO: Replace with the actual rituals for all cataclysmic events when they have been set up in the database.
		finishing_rituals = {
			chasm  = "wh3_dlc29_ritual_cataclysmic_events_devastate_province_chasm",
			crater = "wh3_dlc29_ritual_cataclysmic_events_devastate_province_crater",
			fire   = "wh3_dlc29_ritual_cataclysmic_events_devastate_province_volcano",
			sunk   = "wh3_dlc29_ritual_cataclysmic_events_devastate_province_volcano",
		},

		-- This table maps the event area types to the effect bundles that are applied to the regions affected by the cataclysmic events.
		-- TODO: Replace with the actual effect bundles for all cataclysmic events when they have been set up in the database.
		effect_bundles = {
			chasm  = "wh3_dlc29_devastation_chasm_disable_resources",
			crater = "wh3_dlc29_devastation_crater_disable_resources",
			fire   = "wh3_dlc29_devastation_volcano_disable_resources",
			sunk   = "wh3_dlc29_devastation_volcano_disable_resources",
		},

		-- This table maps the event area types to the climates that are applied to the regions affected by the cataclysmic events.
		-- TODO: Replace with the actual climates for all cataclysmic events when they have been set up in the database.
		climates = {
			chasm  = "climate_devastated_chasm",
			crater = "climate_devastated_crater",
			fire   = "climate_devastated_volcano",
			sunk   = "climate_devastated_volcano",
		},

		-- This table defines the culture-specific types of invoking forces spawned by the initiating rituals.
		-- TODO: Create the actual configuration for each culture after the spawnable forces have been set up in the database.
		invoking_forces = {
			-- <culture_key> = "spawnable_force_key",
			wh2_main_lzd_lizardmen = "wh2_main_ritual_lzd_primeval_glory",
		},

		-- TODO: replace the following with the actual casting times from the database (?)
		invocation_turns = 1, -- The number of turns it takes for the cataclysmic event to be invoked after the ritual is completed.

		-- Script state keys used to store information about the invoking character and the completion turn of a cataclysmic event.
		-- The ones stored on the invoking character are the ground truth for the ongoing cataclysmic event invocations.
		-- The ones stored on the targeted regions are used to display the information in the UI and allow zooming to the invoking character.
		-- If an area is targeted by several ongoing invocations, its regions will store info about only the most imminent invocation.
		script_state_key_target_region   = "cataclysmic_events_target_region",
		script_state_key_completion_turn = "cataclysmic_events_completion_turn",
		script_state_key_invoker_cqi     = "cataclysmic_events_invoker_cqi",
	},

	-- Run-time data about the ongoing invocations for each event area. Recreated on each game start from the saved script states.
	-- Used for easier tracking of the invocations in the script, UI, and debugging.
	invocations_cache = {
		-- Example:
		-- ["wh3_main_combi_province_the_red_wastes_chasm"] =
		-- { { target_region_key = "region_key", invoking_character_cqi = 12345, completion_turn = 10 }, ... },
	}
}


function cataclysmic_events:populate_invocations_cache()
	-- This function populates the invocations cache from the script states stored on the regions and characters.
	-- It should be called at the start of the game to restore the ongoing invocations from the saved script states.
	-- We use the script states stored on characters because the ones stored on regions reflect only the most imminent
	-- invocation in their area, while there may be multiple characters targeting a single area.

	self.invocations_cache = {}

	-- Iterate through all characters in the game and check their script states for ongoing invocations.
	local faction_list = cm:get_faction_list()
	for i = 0, faction_list:num_items() - 1 do
		local faction = faction_list:item_at(i)
		local character_list = faction:character_list()
		for j = 0, character_list:num_items() - 1 do
			local character = character_list:item_at(j)
			local target_region_key = cm:model():shared_states_manager():get_state_as_string_value(character, self.config.script_state_key_target_region)
			if target_region_key and target_region_key ~= "" then
				local completion_turn = cm:model():shared_states_manager():get_state_as_float_value(character, self.config.script_state_key_completion_turn)
				if completion_turn then
					local target_region = cm:get_region(target_region_key)
					local event_area_key = target_region:event_area_name()
					self.invocations_cache[event_area_key] = self.invocations_cache[event_area_key] or {}
					table.insert(self.invocations_cache[event_area_key], {
						target_region_key = target_region_key,
						invoking_character_cqi = character:cqi(),
						completion_turn = completion_turn
					})
				end
			end
		end
	end

	self:print_invocations_cache()
end


function cataclysmic_events:register_invoking_character(character_cqi, target_region_key)
	-- Set the script states on the character to remember the target region and the completion turn, then update the invocations cache.
	local character = cm:get_character_by_cqi(character_cqi)
	local target_region = cm:get_region(target_region_key)
	local completion_turn = cm:model():turn_number() + self.config.invocation_turns
	local event_area_key = target_region:event_area_name()

	cm:set_script_state(character, self.config.script_state_key_target_region, target_region_key)
	cm:set_script_state(character, self.config.script_state_key_completion_turn, completion_turn)

	self.invocations_cache[event_area_key] = self.invocations_cache[event_area_key] or {}
	table.insert(self.invocations_cache[event_area_key], {
		target_region_key = target_region_key,
		invoking_character_cqi = character_cqi,
		completion_turn = completion_turn
	})

	self:print_invocations_cache()

	self:update_region_script_states_in_area_for_region(target_region)
end


function cataclysmic_events:unregister_invoking_character(character)
	-- Remove the cataclysmic event script states from a killed invoking character and update the invocations cache.
	local invoking_character_cqi = character:cqi()
	local target_region_key = cm:model():shared_states_manager():get_state_as_string_value(character, self.config.script_state_key_target_region)

	if not target_region_key or target_region_key == "" then
		return
	end

	local target_region = cm:get_region(target_region_key)
	local event_area_key = target_region:event_area_name()

	cm:remove_script_state(character, self.config.script_state_key_target_region)
	cm:remove_script_state(character, self.config.script_state_key_completion_turn)

	local cached_invocations_for_area = self.invocations_cache[event_area_key] -- Cannot be empty as the character was invoking an event.

	for i = #cached_invocations_for_area, 1, -1 do
		if cached_invocations_for_area[i].invoking_character_cqi == invoking_character_cqi then
			table.remove(cached_invocations_for_area, i)
			break
		end
	end

	if #cached_invocations_for_area == 0 then
		self.invocations_cache[event_area_key] = nil
	end

	self:print_invocations_cache()

	self:update_region_script_states_in_area_for_region(target_region)
end


function cataclysmic_events:update_region_script_states_in_area_for_region(region)
	-- This updates the script states of the regions in the same event area as the given region.
	-- They are mainly for UI purposes, to show a counter of the most imminent invocation for the area and allow zooming to its invoking character.
	-- For now, all regions in the area will have the same script states set, so that the UI will show the same information for all of them.
	-- If necessary, additional logic may be added later to have different UX related to multiple invocations in the same area.

	-- Among all invocations targeting regions in the area, find the one that would be completed at the earliest turn.
	local event_area_key = region:event_area_name()
	local cached_invocations_for_area = self.invocations_cache[event_area_key]
	local most_imminent_invocation = nil
	
	if cached_invocations_for_area then
		for i = #cached_invocations_for_area, 1, -1 do
			local invocation = cached_invocations_for_area[i]
			if not most_imminent_invocation or invocation.completion_turn < most_imminent_invocation.completion_turn then
				most_imminent_invocation = invocation
			end
		end
	end

	local regions = region:regions_in_same_event_area()

	-- Store the most imminent invocation in the script state of the regions in the area. Clear the states if there is no imminent invocation.
	if most_imminent_invocation then
		for i = 0, regions:num_items() - 1 do
			local area_region = regions:item_at(i)
			cm:set_script_state(area_region, self.config.script_state_key_invoker_cqi,     most_imminent_invocation.invoking_character_cqi)
			cm:set_script_state(area_region, self.config.script_state_key_completion_turn, most_imminent_invocation.completion_turn)
		end
	else
		for i = 0, regions:num_items() - 1 do
			local area_region = regions:item_at(i)
			cm:remove_script_state(area_region, self.config.script_state_key_invoker_cqi)
			cm:remove_script_state(area_region, self.config.script_state_key_completion_turn)
		end
	end

	-- Update the UI to reflect the changes.
	CampaignUI.UpdateAllCityInfoBars()
end


function cataclysmic_events:print_invocations_cache()
	-- Prints the current invocations cache in the console.
	out("Cataclysmic Events: current invocations cache:")
	for event_area_key, invocations in pairs(self.invocations_cache) do
		out("Event area: " .. event_area_key)
		for i, invocation in ipairs(invocations) do
			local invoking_character = cm:get_character_by_cqi(invocation.invoking_character_cqi)
			out(string.format("  %d. Target region: %s, Invoking character CQI: %d, Faction: %s, Completion turn: %d",
				i,
				invocation.target_region_key,
				invocation.invoking_character_cqi,
				invoking_character:faction():name(),
				invocation.completion_turn))
		end
	end
end


function cataclysmic_events:perform_finishing_ritual(ritual_key, target_region_key, performing_faction_key)
	local ritual_setup = cm:create_new_ritual_setup(cm:get_faction(performing_faction_key), ritual_key)
	local ritual_target = ritual_setup:target()
	ritual_target:set_target_region(cm:get_region(target_region_key))
	cm:perform_ritual_with_setup(ritual_setup)
end


function cataclysmic_events:complete_invocation(invocation_entry)
	-- Given an entry from the invocations cache, perform the finishing ritual for the cataclysmic event.
	local target_region = cm:get_region(invocation_entry.target_region_key)
	local event_area_type = target_region:event_area_type()
	local finishing_ritual_key = self.config.finishing_rituals[event_area_type]
	local invoking_character = cm:get_character_by_cqi(invocation_entry.invoking_character_cqi)
	local invoking_faction = invoking_character:faction()
	local invoking_faction_key = invoking_faction:name()

	self:perform_finishing_ritual(finishing_ritual_key, invocation_entry.target_region_key, invoking_faction_key)
end


function cataclysmic_events:initialise()
	-- Populate the invocations cache from the script states stored on the characters.	
	self:populate_invocations_cache()

	-- Listener for completion of the initiating rituals. Creates the invoking armies for the cataclysmic events and stores ongoing invocation data.
	core:add_listener(
		"cataclysmic_events_initiating_ritual_complete",
		"RitualCompletedEvent",
		function(context)
			-- React only to initiating rituals that are part of the cataclysmic events.
			-- TODO: Replace with an actual check (by ritual category?) when the initial rituals are set up in the database.
			return context:succeeded() and
				context:ritual():ritual_key() == "wh3_dlc29_lzd_ritual_cataclysmic_events_crater_initiate"
				-- context:ritual():ritual_category_key() == "CATACLYSMIC_EVENTS_INITIATING"
		end,
		function(context)
			local ritual = context:ritual()
			local target_region = context:ritual_target_region()
			local faction = context:performing_faction()
			local culture = faction:culture()

			-- Check if the culture has a configured force to spawn
			if not cataclysmic_events.config.invoking_forces[culture] then
				script_error(
					"ERROR: Cataclysmic Events: no configured invoking force for culture " ..
						culture .. " to spawn for ritual " .. ritual:ritual_key() .. "."
				)
				return
			end

			-- Get a suitable spawn position, spawn the force and register the invoking character.
			local x, y =
				cm:find_valid_spawn_location_for_character_from_settlement(
				faction:name(),
				target_region:name(),
				false, -- Don't allow water
				true, -- Be in the same region as the settlement (Should it be mandatory? Best not to count on it for now.)
				10 -- Minimum distance from the settlement. TODO: tie this to the ritual range!
			)

			cm:create_spawnable_force(
				faction:name(),
				cataclysmic_events.config.invoking_forces[culture],
				target_region:name(),
				x, y,
				function(cqi)
					cataclysmic_events:register_invoking_character(cqi, target_region:name())
				end
			)
		end,
		true
	)

	-- Listener for the faction turn start event. Handles completion of invocations.
	core:add_listener(
		"cataclysmic_events_turn_start",
		"FactionTurnStart",
		true,
		function(context)
			local current_turn = cm:model():turn_number()
			local faction_name = context:faction():name()
			-- Iterate the invocations cache for any invocations associated to this faction's characters that should complete this turn.
			for event_area_key, invocations in pairs(cataclysmic_events.invocations_cache) do
				for i = #invocations, 1, -1 do
					local invocation = invocations[i]
					local invoking_character = cm:get_character_by_cqi(invocation.invoking_character_cqi)
					if invocation.completion_turn <= current_turn and invoking_character:faction():name() == faction_name then
						cataclysmic_events:complete_invocation(invocation)
						break -- Each area can be destroyed only once. Pending invocations are cleared when the area is destroyed.
					end
				end
			end
		end,
		true
	)

	-- Listener for completion of the finishing rituals. This is where the actual cataclysmic events are applied to the regions.	
	core:add_listener(
		"cataclysmic_events_finishing_ritual_complete",
		"RitualCompletedEvent",
		function(context)
			-- React only to successful finishing rituals for cataclysmic events.
			if not context:succeeded() then
				return false
			end
			-- The ritual must have a target region and its key should match the configured finishing ritual for the event area type of the region.
			local target_region = context:ritual_target_region()
			if not target_region or target_region:is_null_interface() then
				return false
			end
			local event_area_type = target_region:event_area_type()
			local ritual_key = context:ritual():ritual_key()
			return ritual_key == cataclysmic_events.config.finishing_rituals[event_area_type]
		end,
		function(context)
			local faction = context:performing_faction()
			local target_region = context:ritual_target_region()
			cataclysmic_events:devastate_region(target_region:name(), faction)
		end,
		true
	)

	-- Listener for deaths of invoking characters. Killing the character will remove the invocation and any script states related to it.
	core:add_listener(
		"cataclysmic_events_invoker_killed",
		"CharacterConvalescedOrKilled",
		function(context)
			local character = context:character()
			local target_region_key = cm:model():shared_states_manager():get_state_as_string_value(character, cataclysmic_events.config.script_state_key_target_region)
			return target_region_key ~= ""
		end,
		function(context)
			cataclysmic_events:unregister_invoking_character(context:character())
		end,
		true
	)
end


function cataclysmic_events:debug_create_ritual(finishing_ritual_key, preforming_faction_key, target_region_key)
	-- When calling this, take care to use the correct ritual key for the event area type of the target region.
	self:perform_finishing_ritual(finishing_ritual_key, target_region_key, preforming_faction_key)
end

function cataclysmic_events:devastate_region(target_region_key, devastating_faction)
	local target_region = cm:get_region(target_region_key)
	local event_area_type = target_region:event_area_type()
	local event_area_key = target_region:event_area_name()

	-- Activate the campaign map event area containing the targeted region.
	cm:activate_campaign_map_event_area(event_area_key, devastating_faction:culture())

	local regions = target_region:regions_in_same_event_area()
	for i = 0, regions:num_items() - 1 do
		-- get region and corresponding settlement
		local current_region = regions:item_at(i)
		local current_region_key = current_region:name()

		cm:set_region_abandoned(current_region_key)

		cm:apply_effect_bundle_to_region(cataclysmic_events.config.effect_bundles[event_area_type], current_region_key, 0);

		local current_settlement = current_region:settlement()

		-- set type
		cm:reset_settlement_type(current_settlement, "wh3_dlc29_devastated", 1)

		-- set climate
		cm:override_settlement_climate(current_settlement, cataclysmic_events.config.climates[event_area_type])

		-- set building devastation state
		-- todo: nagash can devastate provinces he still occupies, in that case devastated state should be devastated_occupied
		cm:set_settlement_devastated_state(current_settlement, "devastated")

		-- replace primary building
		--cm:replace_settlement_primary_building(current_region_key, "wh3_dlc23_chd_settlement_outpost_ruin") broken????

		-- Kill all characters in the region.
		local characters_in_region = current_region:characters_in_region()
		for ii = 0, characters_in_region:num_items() - 1 do
			local current_character = characters_in_region:item_at(ii)
			-- TODO: (code) check for devastation resistance
			-- Design asked for some devastations to not kill all characters (chaos)
			cm:kill_character(current_character:cqi(), true)
		end
	end

	self:print_invocations_cache()
	out("Cataclysmic Events: Finished applying the cataclysmic event to all regions in the area: " .. event_area_key)

	-- Cancel any further ongoing invocations for the event area.
	if cataclysmic_events.invocations_cache[event_area_key] then
		for i = #cataclysmic_events.invocations_cache[event_area_key], 1, -1 do
			local invocation = cataclysmic_events.invocations_cache[event_area_key][i]
			-- Make sure the invoking character is killed (we don't rely on it being in one of the regions).
			local invoking_character = cm:get_character_by_cqi(invocation.invoking_character_cqi)
			if invoking_character then
				cm:remove_script_state(invoking_character, cataclysmic_events.config.script_state_key_target_region)
				cm:remove_script_state(invoking_character, cataclysmic_events.config.script_state_key_completion_turn)
				cm:kill_character(invocation.invoking_character_cqi, true)
			end
			table.remove(cataclysmic_events.invocations_cache[event_area_key], i)
		end
		cataclysmic_events.invocations_cache[event_area_key] = nil
	end

	self:print_invocations_cache()

	-- Refresh the settlement info bars to reflect all changes done to the regions/settlements.
	CampaignUI.UpdateAllCityInfoBars()
end