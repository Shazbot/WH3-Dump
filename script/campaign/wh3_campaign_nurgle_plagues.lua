
-- dev ui for adding symptons
core:add_listener(
	"dev_ui_button_pressed_add_symptoms",
	"ComponentLClickUp",
	function(context)
		return context.string == "dev_button_simulate_spread"
	end,
	function(context)
		local uic = UIComponent(context.component);
		local uic_parent = UIComponent(uic:Parent());
		local plague_key = string.match(uic_parent:Id(), "+(.*)")
		out.design(plague_key);
		
		local faction_name = "wh3_main_nur_poxmakers_of_nurgle"
		local counter_name = nil
		
		if plague_key == "wh3_main_nur_base_Ague" then
			counter_name = "Ague_spread_counter_"..faction_name
		elseif plague_key == "wh3_main_nur_base_Buboes" then
			counter_name = "Buboes_spread_counter_"..faction_name
		elseif plague_key == "wh3_main_nur_base_Pox" then
			counter_name = "Pox_spread_counter_"..faction_name
		elseif plague_key == "wh3_main_nur_base_Rot" then
			counter_name = "Rot_spread_counter_"..faction_name
		elseif plague_key == "wh3_main_nur_base_Shakes" then
			counter_name = "Shakes_spread_counter_"..faction_name
		end
		
		local spread_count = cm:model():shared_states_manager():get_state_as_float_value(counter_name);
		
		tick_plague_counter(spread_count, counter_name, faction_name, 5);
	end,
	true
);

local unlocks = {
				["wh3_nur_plague_component_3"] = {["base_key"] = "wh3_main_nur_base_Ague",["spread_count"] = 5},
				["wh3_nur_plague_component_8"] = {["base_key"] = "wh3_main_nur_base_Ague",["spread_count"] = 25},
				["wh3_nur_plague_component_13"] = {["base_key"] = "wh3_main_nur_base_Ague",["spread_count"] = 50},
				["wh3_nur_plague_component_2"] = {["base_key"] = "wh3_main_nur_base_Buboes",["spread_count"] = 5},
				["wh3_nur_plague_component_7"] = {["base_key"] = "wh3_main_nur_base_Buboes",["spread_count"] = 25},
				["wh3_nur_plague_component_12"] = {["base_key"] = "wh3_main_nur_base_Buboes",["spread_count"] = 50},
				["wh3_nur_plague_component_1"] = {["base_key"] = "wh3_main_nur_base_Pox",["spread_count"] = 5},
				["wh3_nur_plague_component_6"] = {["base_key"] = "wh3_main_nur_base_Pox",["spread_count"] = 25},
				["wh3_nur_plague_component_11"] = {["base_key"] = "wh3_main_nur_base_Pox",["spread_count"] = 50},
				["wh3_nur_plague_component_4"] = {["base_key"] = "wh3_main_nur_base_Rot",["spread_count"] = 5},
				["wh3_nur_plague_component_9"] = {["base_key"] = "wh3_main_nur_base_Rot",["spread_count"] = 25},
				["wh3_nur_plague_component_14"] = {["base_key"] = "wh3_main_nur_base_Rot",["spread_count"] = 50},
				["wh3_nur_plague_component_5"] = {["base_key"] = "wh3_main_nur_base_Shakes",["spread_count"] = 5},
				["wh3_nur_plague_component_10"] = {["base_key"] = "wh3_main_nur_base_Shakes",["spread_count"] = 25},
				["wh3_nur_plague_component_15"] = {["base_key"] = "wh3_main_nur_base_Shakes",["spread_count"] = 50}
				};

--Initialise the counters for the different plague types
cm:add_first_tick_callback_new(
	function()
		local faction_list = cm:model():world():faction_list();
		for i = 0, faction_list:num_items() - 1 do
			local faction = faction_list:item_at(i);
			
			if faction:subculture() == "wh3_main_sc_nur_nurgle" or faction:name() == "wh3_dlc20_chs_festus" then
				local faction_name = faction:name();
				out.design("Initialise plague counters for " .. faction_name);
				
				cm:set_script_state("Ague_spread_counter_" .. faction_name, 0);
				cm:set_script_state("Buboes_spread_counter_" .. faction_name, 0);
				cm:set_script_state("Pox_spread_counter_" .. faction_name, 0);
				cm:set_script_state("Rot_spread_counter_" .. faction_name, 0);
				cm:set_script_state("Shakes_spread_counter_" .. faction_name, 0);

			end
		end
	end
);

cm:add_first_tick_callback(
	function()
		local faction_list = cm:model():world():faction_list();
		for i = 0, faction_list:num_items() - 1 do
			local faction = faction_list:item_at(i);
			
			if faction:subculture() == "wh3_main_sc_nur_nurgle" or faction:name() == "wh3_dlc20_chs_festus" then
				local faction_name = faction:name();
				out.design("Set plague nurgle unlock context value for " .. faction_name);
				common.set_context_value("plague_component_unlocks_"..faction_name, unlocks);
			end
		end
	end
);

core:add_listener(
	"PlagueInfectionForce",
	"MilitaryForceInfectionEvent",
	true,
	function(context)
		local plague_interface = context:plague();
		local is_created = context:is_creation();
		
		local plague_owner = context:faction();
		local target_force = context:target_force();
		
		add_plague_counter(plague_interface, plague_owner);
	end,
	true
);

core:add_listener(
	"PlagueInfectionRegion",
	"RegionInfectionEvent",
	true,
	function(context)
		local plague_interface = context:plague();
		local is_created = context:is_creation();
		
		local plague_owner = context:faction();
		local target_region = context:target_region();
		
		add_plague_counter(plague_interface, plague_owner);
	end,
	true
);

function add_plague_counter(plague_interface, faction)
	local faction_name = faction:name();

	local counter_name = plague_to_script_state_name(plague_interface, faction_name);
	local spread_count = cm:model():shared_states_manager():get_state_as_float_value(counter_name);

	-- Notify other scripts of plague spreading
	core:trigger_custom_event("ScriptEventPlagueSpreading", {plague = plague_interface, faction = faction, count = spread_count});
	
	tick_plague_counter(spread_count, counter_name, faction_name);
	
	--Debug out
	local spread_count_new = cm:model():shared_states_manager():get_state_as_float_value(counter_name);
	out.design(counter_name..": "..tostring(spread_count_new));
end

function tick_plague_counter(spread_count, counter_name, faction_name, debug_count)
	if spread_count then
		local increment = debug_count or 1;
		cm:set_script_state(counter_name, spread_count + increment);
		update_plague_unlocks(faction_name);
	end
end


local base_key_to_base_plague_mapping_cache = {};
local component_name_to_number_mapping_cache = {};

function update_plague_unlocks(faction_name)
	--apply effect bundles to unlock
	local component_unlocks_bundle = cm:create_new_custom_effect_bundle("wh3_main_scripted_custom_effect_bundle_nur_component_unlocks");
	component_unlocks_bundle:set_duration(0);
	
	local ague_count = cm:model():shared_states_manager():get_state_as_float_value("Ague_spread_counter_" .. faction_name)			-- these are all nil?
	local buboes_count = cm:model():shared_states_manager():get_state_as_float_value("Buboes_spread_counter_" .. faction_name)
	local pox_count = cm:model():shared_states_manager():get_state_as_float_value("Pox_spread_counter_" .. faction_name)
	local rot_count = cm:model():shared_states_manager():get_state_as_float_value("Rot_spread_counter_" .. faction_name)
	local shakes_count = cm:model():shared_states_manager():get_state_as_float_value("Shakes_spread_counter_" .. faction_name)
	
	for component_name, record in pairs(unlocks) do

		-- Attempt to derive the base_plague (e.g. "Ague") from the base_key (e.g. "wh3_main_nur_base_Ague"). Look it up first in
		-- a cache and if it isn't there, do some string operations to extract it and then add it to the cache so future lookups
		-- are much quicker.
		local base_key = record["base_key"];
		local base_plague = base_key_to_base_plague_mapping_cache[base_key];

		if not base_plague then
			base_plague = string.match(base_key, "_[^_]+$");
			base_plague = base_plague:gsub('_', '');
			base_key_to_base_plague_mapping_cache[base_key] = base_plague;
		end;
		--out.design("base_key is " .. base_key .. ", base_plague is " .. base_plague)

		--get the count for the base plague
		local this_count = cm:model():shared_states_manager():get_state_as_float_value(base_plague.."_spread_counter_" .. faction_name)
		
		--test the count against the spread_count
		if this_count >= record["spread_count"] then
			--get the component number from the component name
			--"wh3_nur_plague_component_3" -> "3"

			-- Attempt to derive the component_number (e.g. "3") from the component_name (e.g. "wh3_nur_plague_component_3").
			-- Look it up first in a cache, and write it to the cache if it's not there.
			local component_number = component_name_to_number_mapping_cache[component_name];
			if not component_number then
				component_number = string.match(component_name, "_[^_]+$");
				component_number = component_number:gsub('_', '');
				component_name_to_number_mapping_cache[component_name] = component_number;
			end;
			component_unlocks_bundle:add_effect("wh3_main_effect_unlock_plague_components_nur_"..component_number, "faction_to_faction_own_unseen", 1);
			
			out.design("Unlock plague component "..component_name);

			-- If we haven't unlocked this plague component/symptom before for this faction then do so, and send a script event
			if not cm:get_saved_value("plague_symptom_" .. component_number .. "_unlocked_" .. faction_name) then
				cm:set_saved_value("plague_symptom_" .. component_number .. "_unlocked_" .. faction_name, true);

				-- Update a value in the savegame of how many symptoms this faction has unlocked
				local symptoms_unlocked = cm:get_saved_value("plague_symptoms_unlocked_" .. faction_name) or 0;
				cm:set_saved_value("plague_symptoms_unlocked_" .. faction_name, symptoms_unlocked + 1);

				-- Trigger a script event for narrative missions
				core:trigger_custom_event("ScriptEventPlagueSymptomUnlocked", {faction = cm:get_faction(faction_name), symptom = component_name});
			end;
		end
	end
	
	--Apply the custom bundle
	local faction = cm:get_faction(faction_name);
	if faction:has_effect_bundle("wh3_main_nur_component_unlocks") then
		cm:remove_effect_bundle("wh3_main_nur_component_unlocks", faction_name);
	end;
	cm:apply_custom_effect_bundle_to_faction(component_unlocks_bundle, faction);
end;

function plague_to_script_state_name(plague_interface, faction_name)
	local record = plague_interface:plague_record();
	
	out.design(record);
	
	if record == "wh3_main_nur_base_Ague" then
		return "Ague_spread_counter_"..faction_name
	elseif record == "wh3_main_nur_base_Buboes" then
		return "Buboes_spread_counter_"..faction_name
	elseif record == "wh3_main_nur_base_Pox" then
		return "Pox_spread_counter_"..faction_name
	elseif record == "wh3_main_nur_base_Rot" then
		return "Rot_spread_counter_"..faction_name
	elseif record == "wh3_main_nur_base_Shakes" then
		return "Shakes_spread_counter_"..faction_name
	end
	
	out.design("No matching Plague for counter");
	return "we_failed";
end

function are_all_plague_components_unlocked(faction)
	if faction:is_human() and faction:culture() == "wh3_main_nur_nurgle" then
		local ssm = cm:model():shared_states_manager();
		local faction_name = faction:name();
		
		--test all conditions for unlocking components
		return  ssm:get_state_as_float_value("Ague_spread_counter_"..faction_name)   >= 50 and
				ssm:get_state_as_float_value("Buboes_spread_counter_"..faction_name) >= 50 and
				ssm:get_state_as_float_value("Pox_spread_counter_"..faction_name)    >= 50 and
				ssm:get_state_as_float_value("Rot_spread_counter_"..faction_name)    >= 50 and
				ssm:get_state_as_float_value("Shakes_spread_counter_"..faction_name) >= 50 and
				faction:has_technology("wh3_main_tech_nur_7")  and
				faction:has_technology("wh3_main_tech_nur_12") and
				faction:has_technology("wh3_main_tech_nur_19") and
				faction:has_technology("wh3_main_tech_nur_22") and
				faction:has_technology("wh3_main_tech_nur_29")
	end
	
	return false
end

-- add ap when plague cultist spawns
core:add_listener(
	"plague_cultist_created",
	"CharacterCreated",
	function(context)
		return context:character():character_subtype("wh3_main_nur_cultist_plague_ritual");
	end,
	function(context)
		local character = cm:char_lookup_str(context:character():cqi());
		cm:callback(function() cm:replenish_action_points(character) end, 0.2);
	end,
	true
);