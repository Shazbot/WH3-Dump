beastmen_moon = {
	debug_dilemmas = false,	-- Enable this to test all possible moon dilemma configurations on turn 1.

	moon_phase = 1,
	moon_max_phase = 8,	-- The Moon dilemma will also fire on this phase.
	selected_moon_type = nil,
	previous_moon_effect = nil,
	current_moon_effect = "wh_dlc03_bundle_moon_1",
	round_handled = 0,

	moon_effect_prefix = "wh_dlc03_bundle_moon_",
	enable_log = false,
	beastmen_culture = "wh_dlc03_bst_beastmen",

	--Create a guaranteed Solar Eclipse for Tuarox's Rampage reward
	solar_eclipse_guaranteed = false,

	-- This table defines the types of rewards and the tiers of those rewards (e.g low, medium, high unit replenishment) that can appear on moon dilemma choices.
	-- All possible choices for a dilemma must be defined in the database, and 'choice_key' must correspond to the choice key that an effect bundle is attached to
	-- for a given dilemma.
	dilemma_payloads = {
		replenishment = {
			duration = 2,
			effect_bundles = {
				"wh_dlc03_bundle_prep_moon_replenishment_low",
				"wh_dlc03_bundle_prep_moon_replenishment_medium",
				"wh_dlc03_bundle_prep_moon_replenishment_high",
			},
			debug_name = "When One Falls…",
			choice_key = "SCRIPTED_1",
		},
		bestial_rage = {
			duration = 3,
			effect_bundles = {
				"wh_dlc03_bundle_prep_moon_bestial_rage_low",
				"wh_dlc03_bundle_prep_moon_bestial_rage_medium",
				"wh_dlc03_bundle_prep_moon_bestial_rage_high",
			},
			debug_name = "Ruinous Incentive",
			choice_key = "SCRIPTED_2",
		},
		movement = {
			duration = 3,
			effect_bundles = {
				"wh_dlc03_bundle_prep_moon_movement_low",
				"wh_dlc03_bundle_prep_moon_movement_medium",
				"wh_dlc03_bundle_prep_moon_movement_high",
			},
			debug_name = "No Matter How Far",
			choice_key = "SCRIPTED_3",
		},
		unit_exp = {
			duration = 5,
			effect_bundles = {
				"wh_dlc03_bundle_prep_moon_unit_exp_low",
				"wh_dlc03_bundle_prep_moon_unit_exp_medium",
				"wh_dlc03_bundle_prep_moon_unit_exp_high",
			},
			debug_name = "The Cost of Skill",
			choice_key = "SCRIPTED_4",
		},
		unit_stats = {
			duration = 3,
			effect_bundles = {
				"wh_dlc03_bundle_prep_moon_unit_stats_low",
				"wh_dlc03_bundle_prep_moon_unit_stats_medium",
				"wh_dlc03_bundle_prep_moon_unit_stats_high",
			},
			debug_name = "Beastly Inclination",
			choice_key = "SCRIPTED_5",
		},
		growth = {
			duration = 6,
			effect_bundles = {
				"wh_dlc03_bundle_prep_moon_growth_low",
				"wh_dlc03_bundle_prep_moon_growth_medium",
				"wh_dlc03_bundle_prep_moon_growth_high",
			},
			debug_name = "Endless Herd",
			choice_key = "SCRIPTED_6",
		},
		recruit_cost = {
			duration = 3,
			effect_bundles = {
				"wh_dlc03_bundle_prep_moon_recruit_cost_low",
				"wh_dlc03_bundle_prep_moon_recruit_cost_medium",
				"wh_dlc03_bundle_prep_moon_recruit_cost_high",
			},
			debug_name = "All Must Fight",
			choice_key = "SCRIPTED_7",
		},
	},

	-- This table defines the main moon-dilemma types (full moon, solar eclipse, lunar eclipse ...) as well as their possible choice payloads.
	-- The choice payloads are defined by referencing a 'type' and 'level' in the dilemma_payloads table.
	moon_dilemma_settings = {
		full_moon = {
			chance = 35,
			effect = "wh_dlc03_bundle_moon_event_full_moon_success",
			base_dilemma = "wh_dlc03_full_moon_preparations_full_moon",
			choice_preset_groups = {
				{
					{ chance = 100, type = "replenishment", level = 1 }
				},
				{
					{ chance = 50, type = "bestial_rage", level = 1 },
					{ chance = 30, type = "movement", level = 1 },
					{ chance = 15, type = "unit_exp", level = 1 },
					{ chance = 5, type = "unit_stats", level = 1 },
				},
				{
					{ chance = 30, type = "unit_stats", level = 1 },
					{ chance = 30, type = "unit_exp", level = 1 },
					{ chance = 20, type = "movement", level = 1 },
					{ chance = 20, type = "growth", level = 1 },
				},
				{
					{ chance = 50, type = "recruit_cost", level = 1 },
					{ chance = 30, type = "growth", level = 1 },
					{ chance = 15, type = "unit_stats", level = 1 },
					{ chance = 5, type = "unit_exp", level = 1 },
				},
			},
		},
		lunar_eclipse = {
			chance = 35,
			effect = "wh_dlc03_bundle_moon_event_lunar_eclipse",
			base_dilemma = "wh_dlc03_full_moon_preparations_lunar_eclipse",
			choice_preset_groups = {
				{
					{ chance = 100, type = "replenishment", level = 2 }
				},
				{
					{ chance = 50, type = "bestial_rage", level = 2 },
					{ chance = 30, type = "movement", level = 2 },
					{ chance = 15, type = "unit_exp", level = 2 },
					{ chance = 5, type = "unit_stats", level = 2 },
				},
				{
					{ chance = 30, type = "unit_stats", level = 2 },
					{ chance = 30, type = "unit_exp", level = 2 },
					{ chance = 20, type = "movement", level = 2 },
					{ chance = 20, type = "growth", level = 2 },
				},
				{
					{ chance = 50, type = "recruit_cost", level = 2 },
					{ chance = 30, type = "growth", level = 2 },
					{ chance = 15, type = "unit_stats", level = 2 },
					{ chance = 5, type = "unit_exp", level = 2 },
				},
			},
		},
		solar_eclipse = {
			chance = 30,
			effect = "wh_dlc03_bundle_moon_event_solar_eclipse",
			base_dilemma = "wh_dlc03_full_moon_preparations_solar_eclipse",
			choice_preset_groups = {
				{
					{ chance = 100, type = "replenishment", level = 3 }
				},
				{
					{ chance = 50, type = "bestial_rage", level = 3 },
					{ chance = 30, type = "movement", level = 3 },
					{ chance = 15, type = "unit_exp", level = 3 },
					{ chance = 5, type = "unit_stats", level = 3 },
				},
				{
					{ chance = 30, type = "unit_stats", level = 3 },
					{ chance = 30, type = "unit_exp", level = 3 },
					{ chance = 20, type = "movement", level = 3 },
					{ chance = 20, type = "growth", level = 3 },
				},
				{
					{ chance = 50, type = "recruit_cost", level = 3 },
					{ chance = 30, type = "growth", level = 3 },
					{ chance = 15, type = "unit_stats", level = 3 },
					{ chance = 5, type = "unit_exp", level = 3 },
				},
			},
		},
	},
}


function beastmen_moon:out(string)
	if self.enable_log then
		out(string);
	end;
end;


-- Initialisation for listeners of this feature.
function beastmen_moon:add_moon_phase_listeners()	
	out("#### Adding Moon Phase Listeners ####");

	-- After the Moon phase is determined at WorldRoundStart, update all playable beastmen factions with the moon's effects.
	-- Note that we do them all at once, so that if an earlier beastmen faction attacks one that has yet to have its turn, both have the appropriate moon effect.
	core:add_listener(
		"BeastmenMoonRoundStart",
		"FactionRoundStart",
		function(context)
			local faction = context:faction();
			return faction:is_human() and faction:culture() == self.beastmen_culture;
		end,
		function(context)
			-- Once per round, advance the Moon turn counter.
			-- Need to track the round-handled and update in this way since WorldRoundStart is called after FactionRoundStart, and I need the Moon phase determined
			-- when FactionRoundStart begins.
			if cm:turn_number() > self.round_handled then
				self:update_moon_phase(context);
				self.round_handled = cm:turn_number();
			end;

			local faction_key = context:faction():name();

			self:apply_moon_effect(faction_key);

			-- If this is the full-moon turn, fire a moon dilemma based on what type has been selected.
			if self.moon_phase == self.moon_max_phase then
				self:trigger_moon_dilemma(faction_key, self.selected_moon_type);
			end;
		end,
		true
	);

	--this listener is for Taurox Rampage Moon reward
	core:add_listener(
		"TauroxMoon_RitualCompletedEvent",
		"RitualCompletedEvent", 
		function(context)
			return context:ritual():ritual_key() == "wh2_dlc17_taurox_bst_rampage_tier_2_option_3";
		end,
		function(context) 
			--this guarantees next turn a moon dilemma will trigger
			self.moon_phase = self.moon_max_phase - 1;
			self.solar_eclipse_guaranteed = true
		end,
		true
	);

	if self.debug_dilemmas then
		self:debug_moon_dilemmas();
	end;
end

-- Runs all possible moon dilemmas, dilemma payloads, and a few random dilemmas.
function beastmen_moon:debug_moon_dilemmas()
	out.inc_tab();
	self:out("Testing Beastmen Moon Dilemmas ...");

	local human_beastmen = cm:get_human_factions_of_parameters(self.beastmen_culture);
	if #human_beastmen == 0 then
		self:out("No players are playing beastmen factions. Will not run debug_moon_dilemmas()");
		out.dec_tab();
		return;
	end;

	for h = 1, #human_beastmen do
		human_beastmen[h] = cm:get_faction(human_beastmen[h]);
	end;

	self:out("Exhaustively testing all beastmen moon dilemma configurations ...");
	for moon_type, moon_settings in pairs(self.moon_dilemma_settings) do
		local possible_payloads = {};
		local most_options = 0;
		local choice_preset_groups = moon_settings.choice_preset_groups;
		for c = 1, #choice_preset_groups do
			table.insert(possible_payloads, #choice_preset_groups[c]);
			if most_options < #choice_preset_groups[c] then
				most_options = #choice_preset_groups[c];
			end;
		end;

		for i = 1, most_options do
			local choice_preset_overrides = {};
			-- If we have 3 possible payloads for choice 1, but 2 for the remaining choices, then the choice configurations will become:
			-- { 1, 1, 1, 1 }
			-- { 2, 2, 2, 2 }
			-- { 3, 2, 2, 2 }
			for c = 1, #choice_preset_groups do
				table.insert(choice_preset_overrides, math.min(i, #choice_preset_groups[c]));
			end;
			local test_dilemma = self:create_moon_dilemma(moon_type, choice_preset_overrides);

			for h = 1, #human_beastmen do
				cm:launch_custom_dilemma_from_builder(test_dilemma, human_beastmen[h]);
			end
		end;
	end;
	self:out("Testing a 3 randomised dilemmas ...");
	local rand_a = beastmen_moon:create_moon_dilemma();
	local rand_b = beastmen_moon:create_moon_dilemma();
	local rand_c = beastmen_moon:create_moon_dilemma();
	for h = 1, #human_beastmen do
		cm:launch_custom_dilemma_from_builder(rand_a, human_beastmen[h]);
		cm:launch_custom_dilemma_from_builder(rand_b, human_beastmen[h]);
		cm:launch_custom_dilemma_from_builder(rand_c, human_beastmen[h]);
	end

	self:out("Done testing Beastmen Moon Dilemmas.");
	out.dec_tab();
end;

-- Create a new beastmen moon dilemma with dynamic choice payloads, based on a provided 'moon type' (e.g. 'full_moon', 'solar_eclipse').
-- The dilemma_moon_type may be nil, in which case one is selected randomly.
-- A payload_index_override may be specified. e.g. [1, 1, 1, 3] means the Choices 1, 2, and 3 get their 1st defined payload preset, while Choice 4 gets its 3rd.
function beastmen_moon:create_moon_dilemma(dilemma_moon_type, payload_index_overrides)
	if dilemma_moon_type == nil then
		dilemma_moon_type = self:select_item_by_chance(self.moon_dilemma_settings)
	end;

	if not (payload_index_overrides == nil or is_table(payload_index_overrides)) then
		script_error("ERROR: Couldn't execute create_moon_dilemma(): 'payload_index_overrides' must be table of numeric indices, or nil.");
		return;
	end;

	local moon_dilemma_data = self.moon_dilemma_settings[dilemma_moon_type];
	if moon_dilemma_data == nil then
		script_error(string.format("ERROR: '%s' did not have an entry in the moon_dilemma_settings table. Cannot launch Beastmen Moon Dilemma using this dilemma type.", dilemma_moon_type));
		return;
	end;

	local dilemma_builder = cm:create_dilemma_builder(moon_dilemma_data.base_dilemma);
	if dilemma_builder == nil then
		script_error(string.format("ERROR: Failed to create a dilemma builder based on the base dilemma '%s'. Beastmen moon dilemma will not launch.", moon_dilemma_data.base_dilemma));
		return;
	end;

	local payload_indices_string = "";
	if payload_index_overrides ~= nil then
		for p = 1, #payload_index_overrides do
			payload_indices_string = payload_indices_string .. tostring(payload_index_overrides[p]) .. ", ";
		end;
	end;

	self:out(string.format("Attempting to create Beastmen Moon Dilemma of type '%s', using specified choice payload indices: %s",
		dilemma_moon_type, payload_indices_string));
	
	-- Get the effect bundle of the moon, so that we can add it to the payload of every choice in the dilemma.
	-- We do this even though the effect will already have been applied at this point, since it lets the player read what the effect the current moon will give.
	local moon_custom_effect_bundle = cm:create_new_custom_effect_bundle(moon_dilemma_data.effect);

	local payload_types_in_use = {};
	for p = 1, #moon_dilemma_data.choice_preset_groups do
		-- The table of all possible payload presets this choice can yield on this dilemma.
		local choice_preset_group = moon_dilemma_data.choice_preset_groups[p];
		local choice_preset = nil;

		if payload_index_overrides and payload_index_overrides[p] ~= nil then
			-- If array '[1, 2, 1, 1]' was provided as the index override, use the 1st, 2nd, 1st, and 1st possible payloads for each moon Choice outcome.
			choice_preset = choice_preset_group[payload_index_overrides[p]];
			if choice_preset == nil then
				script_error(string.format("ERROR: Payload index overrides for the '%i'th choice were specified for moon dilemma of type '%s'. But the dilemma settings table does not have a '%i'th possible payload for this choice. Beastmen moon dilemma will not launch.",
					p, dilemma_moon_type, payload_index_overrides[p]));
				return;
			end;
		else
			-- Select one at (weighted) random.
			-- Exclude any payload types that are already in use.
			local choice_index = self:select_item_by_chance(choice_preset_group,
				function(preset)
					return payload_types_in_use[preset.type] ~= nil;
				end
			);
			choice_preset = choice_preset_group[choice_index];
			if choice_preset == nil then
				script_error(string.format("ERROR: Failed to select random choice preset for moon dilemma type '%s', and choice index '%i'. Cannot fire moon dilemma.",
					dilemma_moon_type, p));
				return;
			end;
		end;

		payload_types_in_use[choice_preset.type] = true;

		-- Get the effect bundle specified by the choice preset's 'type' and 'level' (e.g. recruitment, level 3).
		local payload_definition = self.dilemma_payloads[choice_preset.type];
		if payload_definition == nil then
			script_error(string.format("ERROR: No Beastmen Moon Dilemma type named '%s' has been defined in dilemma_payloads.", tostring(choice_preset.type)));
			return;
		end;
		local choice_payload = cm:create_new_custom_effect_bundle(payload_definition.effect_bundles[choice_preset.level]);
		choice_payload:set_duration(payload_definition.duration);

		local payload_builder = cm:create_payload();
		payload_builder:effect_bundle_to_faction(choice_payload);
		
		-- Mention the moon effect too, which will already have been applied before the dilemma even launched. But this allows the player to read what the moon is doing.
		payload_builder:effect_bundle_to_faction(moon_custom_effect_bundle);

		self:out(string.format("Attempting to add payload created from preset '%s' ('%s'), level '%i', using choice key '%s'.",
				choice_preset.type,
				payload_definition.debug_name,
				choice_preset.level,
				payload_definition.choice_key));
		
		-- Each payload type has an associated choice key. 'Ruinous Incentive' is always 'SCRIPTED_2', for example. Choices are enabled/disabled by this key,
		-- so that we can configure which of the 7 possible options we want to appear on our moon dilemma.
		dilemma_builder:add_choice_payload(payload_definition.choice_key, payload_builder);
	end;

	return dilemma_builder;
end;

-- From a table of items containing values 'chance', randomly select one item according to that item's 'chance' out of the total chances.
function beastmen_moon:select_item_by_chance(table_of_items, disallow_condition)
	table_of_items = table.copy(table_of_items);

	if disallow_condition ~= nil then
		for key, value in pairs(table_of_items) do
			if disallow_condition(value) then
				table_of_items[key] = nil;
			end;
		end;
	end;

	if is_empty_table(table_of_items) and disallow_condition ~= nil then
		script_error("ERROR: Attempted to select items by chance, but the table of items is empty. Was this table cleared by the disallow_condition parameter?");
		return;
	end;

	local sum_chance = 0;
	for key, value in pairs(table_of_items) do
		sum_chance = sum_chance + value.chance;
	end;

	if sum_chance <= 0 then
		script_error(string.format("ERROR: select_item_by_chance summed all chances in the provided table_of_items to a value of '%i', which is less than or equal to zero. Do any items in the table have a numeric 'chance' element? Are all of these elements positive?", sum_chance));
		return;
	end;

	local random_number = cm:random_number(sum_chance);
	local cumulative_chance = 0;

	for key, value in pairs(table_of_items) do
		if value.chance ~= nil then
			cumulative_chance = cumulative_chance + value.chance;
			if random_number <= cumulative_chance then
				return key;
			end;
		end;
	end;

	script_error("ERROR: select_item_by_chance() passed through all items but did not select an item. This should not be possible.");
end;

-- Each turn, update the phase of the moon and select its current effect.
function beastmen_moon:update_moon_phase(context)
	-- Get phases 1 to 8, inclusive. Phases 1-7 have associated dark-moon effects, while 8 is the 'full moon' and does a special event.
	self.moon_phase = 1 + ((cm:turn_number() - 1) % self.moon_max_phase);
	self.previous_moon_effect = self.current_moon_effect;

	if self.moon_phase < self.moon_max_phase then
		-- Apply the current Moon Phase effect
		self.current_moon_effect = self.moon_effect_prefix..self.moon_phase;
	else
		if cm:model():turn_number() <= self.moon_max_phase then
			-- THIS WILL ALWAYS BE THE FIRST MOON
			self.selected_moon_type = "solar_eclipse";
		else
			self.selected_moon_type = self:select_item_by_chance(self.moon_dilemma_settings);
		end

		self.current_moon_effect = self.moon_dilemma_settings[self.selected_moon_type].effect;
	end
end

function beastmen_moon:trigger_moon_dilemma(faction_key, dilemma_type)
	local moon_dilemma = self:create_moon_dilemma(dilemma_type);
	if moon_dilemma == nil then
		script_error(string.format("ERROR: Failed to create a Beastmen Moon dilemma for faction '%s", faction_key));
		return;
	end;

	cm:launch_custom_dilemma_from_builder(moon_dilemma, cm:get_faction(faction_key));
end

function beastmen_moon:apply_moon_effect(faction_key)
	self:out(string.format("Applying effect '%s' for '%s'. Removing previous effect '%s'.",
		faction_key,
		self.current_moon_effect,
		tostring(self.previous_moon_effect)));
	cm:remove_effect_bundle(self.previous_moon_effect, faction_key);
	cm:apply_effect_bundle(self.current_moon_effect, faction_key, 0);
end


--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("solar_eclipse_guaranteed", beastmen_moon.solar_eclipse_guaranteed, context);
		cm:save_named_value("moon_phase", beastmen_moon.moon_phase, context);
		cm:save_named_value("selected_moon_type", beastmen_moon.selected_moon_type, context, true);
		cm:save_named_value("previous_moon_effect", beastmen_moon.previous_moon_effect, context, true);
		cm:save_named_value("current_moon_effect", beastmen_moon.current_moon_effect, context);
		cm:save_named_value("round_handled", beastmen_moon.round_handled, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			beastmen_moon.solar_eclipse_guaranteed = cm:load_named_value("solar_eclipse_guaranteed", beastmen_moon.solar_eclipse_guaranteed, context);
			beastmen_moon.moon_phase = cm:load_named_value("moon_phase", 1, context);
			beastmen_moon.selected_moon_type = cm:load_named_value("selected_moon_type", beastmen_moon.selected_moon_type, context, true);
			beastmen_moon.previous_moon_effect = cm:load_named_value("previous_moon_effect", beastmen_moon.previous_moon_effect, context, true);
			beastmen_moon.current_moon_effect = cm:load_named_value("current_moon_effect", beastmen_moon.current_moon_effect, context);
			beastmen_moon.round_handled = cm:load_named_value("round_handled", beastmen_moon.round_handled, context);
		end;
	end
);