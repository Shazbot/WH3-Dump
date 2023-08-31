local cult_creation_cooldown_turns = 15;
local chance_of_cult_creation = 25;

-- Also read by mission scripts
CORRUPTION_THRESHOLD_CHAOS_CULTS_CAN_SPAWN = 75;
TURN_THRESHOLD_CHAOS_CULTS_CAN_SPAWN = 10;
CHAOS_CULTURE_TO_CORRUPTION_TYPE_MAPPING = {
	["wh3_main_kho_khorne"] = "wh3_main_corruption_khorne",
	["wh3_main_nur_nurgle"] = "wh3_main_corruption_nurgle",
	["wh3_main_sla_slaanesh"] = "wh3_main_corruption_slaanesh",
	["wh3_main_tze_tzeentch"] = "wh3_main_corruption_tzeentch"
};
CHAOS_CULTURE_TO_CULT_FOREIGN_SLOT_TYPE_MAPPING = {
	["wh3_main_kho_khorne"] = "wh3_main_slot_set_kho_cult",
	["wh3_main_nur_nurgle"] = "wh3_main_slot_set_nur_cult",
	["wh3_main_sla_slaanesh"] = "wh3_main_slot_set_sla_cult",
	["wh3_main_tze_tzeentch"] = "wh3_main_slot_set_tze_cult"
};

local function construct_cult_data_on_setup()
	local cult_data = {};
	for chaos_culture, corruption_type in pairs(CHAOS_CULTURE_TO_CORRUPTION_TYPE_MAPPING) do
		local record = {};
		table.insert(record, corruption_type);
		table.insert(record, CHAOS_CULTURE_TO_CULT_FOREIGN_SLOT_TYPE_MAPPING[chaos_culture]);
		table.insert(record, {});
		cult_data[chaos_culture] = record;
	end;

	-- cult_data table looks like this
	--[[
	local cult_data = {
		["wh3_main_kho_khorne"] =	{"wh3_main_corruption_khorne",		"wh3_main_slot_set_kho_cult", {}},
		["wh3_main_nur_nurgle"] =	{"wh3_main_corruption_nurgle",		"wh3_main_slot_set_nur_cult", {}},
		["wh3_main_sla_slaanesh"] = {"wh3_main_corruption_slaanesh",	"wh3_main_slot_set_sla_cult", {}},
		["wh3_main_tze_tzeentch"] = {"wh3_main_corruption_tzeentch",	"wh3_main_slot_set_tze_cult", {}}
	};
	]]

	return cult_data;
end;

function setup_daemon_cults()
	
	local cult_data = construct_cult_data_on_setup();	
	
	-- get the human factions that are daemons
	local human_factions = cm:get_human_factions();
	local human_daemon_factions = {};
	
	for i = 1, #human_factions do
		if cult_data[cm:get_faction(human_factions[i]):culture()] and human_factions[i] ~= "wh3_dlc24_tze_the_deceivers" then
			table.insert(human_daemon_factions, human_factions[i]);
		end;
	end;
	
	if #human_daemon_factions > 0 then
		core:add_listener(
			"create_daemon_cults",
			"EndOfRound",
			function()
				-- don't continue if we're not past turn 10
				if cm:model():turn_number() < TURN_THRESHOLD_CHAOS_CULTS_CAN_SPAWN then
					return false;
				end;
				
				-- only continue if a faction isn't on cooldown
				for i = 1, #human_daemon_factions do
					if not cm:get_saved_value(human_daemon_factions[i] .. "_create_cult_on_cooldown") then
						return true;
					end;
				end;
				
				-- don't continue if every faction is on cooldown
				return false;
			end,
			function(context)
				-- collect the valid regions that can have a cult created
				local region_list = cm:model():world():region_manager():region_list();
				
				for i = 0, region_list:num_items() - 1 do
					local current_region = region_list:item_at(i);
					local current_region_owner = current_region:owning_faction();
					
					-- exclude any abandoned regions and regions owned by human daemon factions
					if not current_region:is_abandoned() and not current_region_owner:is_rebel() and current_region:foreign_slot_managers():is_empty() and not (current_region_owner:is_human() and cult_data[current_region_owner:culture()]) then
						for k, v in pairs(cult_data) do
							if cm:get_corruption_value_in_region(current_region, v[1]) >= CORRUPTION_THRESHOLD_CHAOS_CULTS_CAN_SPAWN then
								table.insert(v[3], current_region:cqi());
							end;
						end;
					end;
				end;
				
				-- for each available faction, create a cult in a random valid region
				for i = 1, #human_daemon_factions do
					if cm:random_number(100) <= chance_of_cult_creation then
						local current_faction_name = human_daemon_factions[i];
						local current_faction = cm:get_faction(current_faction_name);
						local current_faction_cult_data = cult_data[current_faction:culture()];
						local available_regions = current_faction_cult_data[3];
						
						if #available_regions > 0 and not cm:get_saved_value(current_faction_name .. "_create_cult_on_cooldown") then
							fs = cm:add_foreign_slot_set_to_region_for_faction(current_faction:command_queue_index(), available_regions[cm:random_number(#available_regions)], current_faction_cult_data[2])
							local region = fs:region();
							
							cm:trigger_incident_with_targets(current_faction:command_queue_index(), "wh3_main_incident_cult_manifests", 0, 0, 0, 0, region:cqi(), region:settlement():cqi());
							
							cm:set_saved_value(current_faction_name .. "_create_cult_on_cooldown", true);
							cm:add_turn_countdown_event(current_faction_name, cult_creation_cooldown_turns, "ScriptEventResetCultCreationCooldown", current_faction_name);
						end;
					end;
				end;
				
				-- clear out the collected regions for next time
				for k, v in pairs(cult_data) do
					v[3] = {};
				end;
			end,
			true
		);
		
		-- reset cooldowns
		core:add_listener(
			"reset_cult_creation_cooldown",
			"ScriptEventResetCultCreationCooldown",
			true,
			function(context)
				cm:set_saved_value(context.string .. "_create_cult_on_cooldown", false);
			end,
			true
		);
	end;
end;