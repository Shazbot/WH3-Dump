-- Handles the shifts in corruption that occur as a result of battles won/lost against daemonic, skaven, and vampiric forces.
-- Also handles crackdown, where an army in friendly territory reduces all corruptions that aren't your favoured type.
corruption_swing = {
	corruption_per_defeated_unit = 0.5,	-- Base corruption shift earned for any given unit defeated, whether it's a Gnoblar or a Dragon
	corruption_per_defeated_enemy_value = 0.001,	-- Multiplier of extra corruption shift earned based on the value of the defeated unit, so that higher value units yield a little more corruption.
	-- If not nil, the corruption earned in a battle will never exceed this value
	-- (keep in mind total corruption val is split between your gain and their loss, so in practice this is like twice the max val a given faction can gain per battle).
	max_corruption_swing_per_battle = nil,

	-- swing_modifier - Applied to gained corruption if when a faction of this type wins, and to lost corruption when they lose.
	favoured_corruptions = {
		FavouredCorruptionNone = {
			resource = nil,
			swing_modifier = 1,
			-- Decreasing untainted basically means increasing all other corruptions all at once. We don't want to do that. So instead, when an untainted army loses
			-- take the 'corruption' they'd lose and tack it onto the victor's corruption as a further bonus.
			-- This way, when you beat untainted you basically get double the corruption reward to make up for untainted not directly being decreased.
			prevent_decrease_on_loss = true,
			crackdown_effect_key = "wh3_main_effect_corruption_reduction_crackdown_untainted",
		},
		FavouredCorruptionKhorne = {
			resource = "wh3_main_corruption_khorne",
			swing_modifier = 1,
			crackdown_effect_key = "wh3_main_effect_corruption_reduction_crackdown_khorne",
		},
		FavouredCorruptionSlaanesh = {
			resource = "wh3_main_corruption_slaanesh",
			swing_modifier = 1,
			crackdown_effect_key = "wh3_main_effect_corruption_reduction_crackdown_slaanesh",
		},
		FavouredCorruptionTzeentch = {
			resource = "wh3_main_corruption_tzeentch",
			swing_modifier = 1,
			crackdown_effect_key = "wh3_main_effect_corruption_reduction_crackdown_tzeentch",
		},
		FavouredCorruptionNurgle = {
			resource = "wh3_main_corruption_nurgle",
			swing_modifier = 1,
			crackdown_effect_key = "wh3_main_effect_corruption_reduction_crackdown_nurgle",
		},
		FavouredCorruptionUndivided = {
			resource = "wh3_main_corruption_chaos",
			swing_modifier = 1,
			crackdown_effect_key = "wh3_main_effect_corruption_reduction_crackdown_chaos",
		},
		FavouredCorruptionSkaven = { 
			resource = "wh3_main_corruption_skaven",
			swing_modifier = 1,
			crackdown_effect_key = "wh3_main_effect_corruption_reduction_crackdown_skaven",
		},
		FavouredCorruptionVampiric = {
			resource = "wh3_main_corruption_vampiric",
			swing_modifier = 1,
			crackdown_effect_key = "wh3_main_effect_corruption_reduction_crackdown_vampiric",
		},
	},
	swing_resource_factor = "post_battle_corruption_swing",
	victor_army_corruption_gain = 0.5,	-- This portion of the calculated casualty value will be given to the victor's favoured corruption.
	defeated_army_corruption_loss = 0.5,	-- This portion of the calculated casualty value will be given to the loser's favoured corruption.

	crackdown_bundle_key = "wh3_main_bundle_force_crackdown_corruption",
	crackdown_effect_scope = "force_to_province_own",

	crackdown_per_unit = 0.1, -- Base enemy-corruption decrement from any given unit cracking down on a province, be it a Gnoblar or a Dragon
	crackdown_per_army_value = 0.0001,	-- Multiplier for extra enemy-corruption decrement based on the value of the unit cracking down, so that higher-value units decrease enemy corruptions moreso.
	-- If not nil, the max amount a given corruption can decrease each turn due to the crackdown of a single army.
	max_crackdown_reduction_per_army = nil,

	debug_log = false,
}


function corruption_swing:out(string)
	if self.debug_log then
		out("Corruption Swing: " .. string)
	end
end


function corruption_swing:setup()
	-- Corruption swing listeners
	core:add_listener(
		"corruption_swing_BattleCompleted",
		"BattleCompleted",
		true,
		function()
			self:handle_post_battle()
		end,
		true
	)

	-- Crackdown recalculation listeners
	-- We do this only once at the start of the game, to calculate values for all armies now placed on the map. After this, recalculation is done on turn-end instead of turn-start.
	if cm:is_new_game() then
		core:add_listener("corruption_crackdown_WorldStartRound",
			"WorldStartRound",
			true,
			function()
				local faction_list = cm:model():world():faction_list()
				for f = 0, faction_list:num_items() - 1 do
					self:set_all_crackdown_effects_for_faction(faction_list:item_at(f))
				end
			end,
			false
		)
	end

	---We don't do mid-turn adjustments during AI turns, as these are only really relevant for the UI previews and the actual effects get updated at turn end anyway
	core:add_listener(
		"corruption_crackdown_MilitaryForceCreated",
		"MilitaryForceCreated",
		function(context)
			return context:military_force_created():faction():is_human()
		end,
		function(context)
			self:set_crackdown_effect(context:military_force_created())
		end,
		true
	)

	core:add_listener(
		"corruption_crackdown_UnitTrained",
		"UnitTrained",
		function(context)
			return context:unit():faction():is_human()
		end,
		function(context)
			self:set_crackdown_effect(context:unit():military_force())
		end,
		true
	)

	core:add_listener(
		"corruption_crackdown_UnitDisbanded",
		"UnitDisbanded",
		function(context)
			return context:unit():faction():is_human()
		end,
		function(context)
			self:set_crackdown_effect(context:unit():military_force())
		end,
		true
	)
	
	core:add_listener(
		"corruption_crackdown_BattleCompleted",
		"BattleCompleted",
		function()
			return cm:pending_battle_cache_human_is_involved()
		end,
		function()
			for a = 1, cm:pending_battle_cache_num_attackers() do
				local char_cqi, mf_cqi, faction_key = cm:pending_battle_cache_get_attacker(a)
				self:set_crackdown_effect(mf_cqi)
			end
			for d = 1, cm:pending_battle_cache_num_defenders() do
				local char_cqi, mf_cqi, faction_key = cm:pending_battle_cache_get_defender(d)
				self:set_crackdown_effect(mf_cqi)
			end
		end,
		true
	)

	core:add_listener(
		"corruption_crackdown_FactionTurnEnd",
		"FactionTurnEnd",
		true,
		function(context)
			self:set_all_crackdown_effects_for_faction(context:faction())
		end,
		true
	)
end


-- After a battle, determine the casualties and preferred corruptions of both armies, and apply the corruption to that province.
function corruption_swing:handle_post_battle()
	local attacker_victory = false
	if cm:pending_battle_cache_attacker_victory() then
		attacker_victory = true
	elseif not cm:pending_battle_cache_defender_victory() then
		-- If not attacker or defender victory, this was likely a retreat or some sort of stalemate that invalidates the calculation. Since nobody won, we won't award corruption.
		return
	end

	local defeated_army_value = 0
	local defeated_army_unit_count = 0
	if attacker_victory then
		defeated_army_value = cm:pending_battle_cache_defender_value()
		defeated_army_unit_count = cm:pending_battle_cache_num_defender_units()
	else
		defeated_army_value = cm:pending_battle_cache_attacker_value()
		defeated_army_unit_count = cm:pending_battle_cache_num_attacker_units()
	end
	
	local victor_faction = nil
	local defeated_faction = nil
	if attacker_victory then
		victor_faction = cm:get_faction(cm:pending_battle_cache_get_attacker_faction_name(1))
		defeated_faction = cm:get_faction(cm:pending_battle_cache_get_defender_faction_name(1))
	else
		victor_faction = cm:get_faction(cm:pending_battle_cache_get_defender_faction_name(1))
		defeated_faction = cm:get_faction(cm:pending_battle_cache_get_attacker_faction_name(1))
	end

	-- If either faction is nil or false, we're probably dealing with rebels and can't go any further.
	if not (victor_faction and defeated_faction) then
		return
	end

	local victor_corruption = self:favoured_corruption_for_faction(victor_faction)
	local defeated_corruption = self:favoured_corruption_for_faction(defeated_faction)

	-- Two factions of the same corruption beating each other does nothing.
	if victor_corruption == defeated_corruption then
		return
	end

	local from_unit_count = defeated_army_unit_count * self.corruption_per_defeated_unit
	local from_value = defeated_army_value * self.corruption_per_defeated_enemy_value
	local corruption_value = from_unit_count + from_value
	if self.max_corruption_swing_per_battle then
		corruption_value = math.min(corruption_value, self.max_corruption_swing_per_battle)
	end
	self:out(string.format(
		"Value of defeated faction %s: %f. Evaluating to base corruption value: %f: %f from defeated unit count, %f from defeated army value (this will be further modified and split between winner/loser). Max corruption swing is %s.",
		defeated_faction:name(),
		defeated_army_value,
		corruption_value,
		from_unit_count,
		from_value,
		tostring(self.max_corruption_swing_per_battle)
	))

	local x, y = cm:model():pending_battle():logical_position()
	local province = cm:get_province_at_position(x, y)
	-- Probably on a sea region or an oddball chaos-waste map area with no province.
	if province == false then
		return
	end

	local victor_corruption_val = corruption_value * (victor_corruption.swing_multiplier or 1) * self.victor_army_corruption_gain
	local defeated_corruption_val = corruption_value * (defeated_corruption.swing_multiplier or 1) * self.defeated_army_corruption_loss

	-- For corruption types where we don't want the loser's corruption to decrease on battle loss, instead take the value that would be taken from the loser, and give it to the winner.
	if defeated_corruption.prevent_decrease_on_loss then
		victor_corruption_val = victor_corruption_val + defeated_corruption_val
		defeated_corruption_val = 0
	end

	cm:change_corruption_in_province_by(province, victor_corruption.resource, victor_corruption_val, self.swing_resource_factor)
	cm:change_corruption_in_province_by(province, defeated_corruption.resource, -defeated_corruption_val, self.swing_resource_factor)

	self:out(string.format(
		"Applied %f '%s' corruption and '%f' %s corruption in province '%s'.",
		victor_corruption_val,
		victor_corruption.resource or "untainted",
		-defeated_corruption_val,
		defeated_corruption.resource or "untainted",
		province:key()
	))
end


-- Get the corruption settings table for a given faction, based on which faction set that faction appears in.
function corruption_swing:favoured_corruption_for_faction(faction)
	local valid_corruptions_count = 0
	local corruption_settings = nil
	local valid_corruptions_string = ""

	for set_key, set_value in pairs(self.favoured_corruptions) do
		if faction:is_contained_in_faction_set(set_key) then
			valid_corruptions_count = valid_corruptions_count + 1
			corruption_settings = set_value
			valid_corruptions_string = valid_corruptions_string .. set_key .. ", "
		end
	end

	if valid_corruptions_count > 1 then
		script_error(string.format(
			"ERROR: Faction '%s' was found to be valid in multiple preferred corruption sets: {%s}. A faction should only ever be contained within one of these sets. Cannot apply post-battle corruption swing.",
			faction:name(), valid_corruptions_string))
		return
	elseif valid_corruptions_count == 0 then
		script_error(string.format(
			"ERROR: Faction '%s' wasn't valid for any preferred corruption set. Check that the faction sets for corruption preference cover this faction. Cannot apply post-battle corruption swing.",
			faction:name(), valid_corruptions_string))
		return
	end

	return corruption_settings
end


-- Update the crackdown values of all mobile armies in the specified faction.
function corruption_swing:set_all_crackdown_effects_for_faction(faction_interface)
	local mf_list = faction_interface:military_force_list()
	for mf = 0, mf_list:num_items() - 1 do
		local military_force = mf_list:item_at(mf)
		if not military_force:has_garrison_residence() then
			self:set_crackdown_effect(military_force)
		end
	end
end


-- Set (or update) the crackdown value of the specified military force.
function corruption_swing:set_crackdown_effect(military_force)
	local mf_interface
	if not is_militaryforce(military_force) then
		if is_number(military_force) then
			mf_interface = cm:get_military_force_by_cqi(military_force)
			-- If the MF CQI was invalid, it's probably because the army in question was just destroyed, in which case we don't need to recalculate its crackdown effect.
			if mf_interface == false then
				return
			end
		else
			script_error(string.format("ERROR: set_crackdown_effect() called but supplied military force [%s] wasn't a military force interface or a cqi", tostring(military_force)))
			return
		end
	else
		mf_interface = military_force
	end

	-- Rebels do not have a preferred corruption and get no crackdown effect.
	if mf_interface:faction():name() == "rebels" then
		return
	end

	local faction = mf_interface:faction()
	local favoured_corruption = self:favoured_corruption_for_faction(faction)
	local crackdown_value = self:get_crackdown_value(mf_interface)
	if self.max_crackdown_reduction_per_army ~= nil then
		crackdown_value = math.min(crackdown_value, self.max_crackdown_reduction_per_army)
	end

	local is_update = mf_interface:has_effect_bundle(self.crackdown_bundle_key)
	if is_update then
		cm:remove_effect_bundle_from_force(self.crackdown_bundle_key, mf_interface:command_queue_index())
	end

	local crackdown_effect_bundle = cm:create_new_custom_effect_bundle(self.crackdown_bundle_key)
	if crackdown_effect_bundle == nil then -- WAITING FOR FIX TO THIS INTERFACE: or crackdown_effect_bundle:is_null_interface() then
		script_error(string.format("ERROR: Unable to set crackdown effect for force of faction '%s'. Failed to create effect bundle using key '%s'.", faction:name(), self.crackdown_bundle_key))
		return
	end

	crackdown_effect_bundle:set_duration(0)

	if favoured_corruption.crackdown_effect_key then
		crackdown_effect_bundle:add_effect(favoured_corruption.crackdown_effect_key , self.crackdown_effect_scope, crackdown_value)
	end
	
	cm:apply_custom_effect_bundle_to_force(crackdown_effect_bundle, mf_interface)

	local application_phrase = "Applied"
	if is_update then
		application_phrase = "Updated"
	end
	self:out(string.format(
		"%s effect bundle with effect '%s' with corruption reduction value '%f to army of faction '%s'",
		application_phrase,
		favoured_corruption.crackdown_effect_key,
		crackdown_value,
		mf_interface:faction():name()
	))
end


-- Get the crackdown value for the provided military force, accounting for that force's total value and its number of units.
function corruption_swing:get_crackdown_value(mf_interface)
	local num_units, army_value = mf_interface:unit_list():num_items(), cm:force_gold_value(mf_interface)
	value = -(num_units * self.crackdown_per_unit + army_value * self.crackdown_per_army_value)
	self:out(string.format(
		"Crackdown value for army '%s' of faction '%s':\n\t\tUnits [%i] * Per Unit CD [%f] + Force Value [%f] * Per Value CD [%f] = [%f]",
		mf_interface:command_queue_index(),
		mf_interface:faction():name(),
		num_units,
		self.crackdown_per_unit,
		army_value,
		self.crackdown_per_army_value,
		value
	))
	return value
end