NURGLE_PLAGUE_KEY = "wh_dlc08_bundle_nurgle_plague";

NURGLE_PLAGUE_LIST = {
	--[[
	["plague_key"] = {
		owner = "faction",
		effect = "",
		regions = {
			["region_key"] = {
				life = 0,
				spread = 0
			}
		}
	}
	]]--
};

NURGLE_PLAGUE_LIST_COOLDOWNS = {};
NURGLE_PLAGUE_EVENT_COOLDOWN = 0;

MIN_TRANSFER_REGIONS = 1; 			-- Minimum number of times the plague will try to spread from an infected region to an uninfected one
MAX_TRANSFER_REGIONS = 2; 			-- Maximum number of times the plague will spread from an infected region to an uninfected one
PLAGUE_MIN_LIFETIME = 5; 			-- Minimum number of turns the plague will stay in a settlement for
PLAGUE_MAX_LIFETIME = 8; 			-- Maximum number of turns the plague will stay in a settlement for
PLAGUE_SPREAD_CHANCE = 25;			-- The chance each turn that a plague in a region will spread to an adjacent region
PLAGUE_COOLDOWN = 12;				-- The number of turns a region has to wait before it can catch the plague a second time

-- plague_log = {};
-- logTxt = "";

local function Start_Nurgle_Plague_Faction_Turn_Start_Listener(faction_name)
	cm:add_faction_turn_start_listener_by_name(
		"Plague_" .. faction_name,
		faction_name,
		Plague_TurnStart,
		true
	);
end;

function Add_Nurgle_Plague_Listeners()
	out("#### Adding Nurgle Plague Listeners ####");

	-- build a list of all factions that own a plague from NURGLE_PLAGUE_LIST, and start a faction turn start listener for each
	local plague_factions = {};
	for _, plague_data in pairs(NURGLE_PLAGUE_LIST) do
		plague_factions[plague_data.owner] = true;
	end

	for faction_name in pairs(plague_factions) do
		Start_Nurgle_Plague_Faction_Turn_Start_Listener(faction_name);
	end;
end

local function Stop_Nurgle_Plague_Faction_Turn_Start_Listener(faction_name)
	cm:remove_faction_turn_start_listener_by_name("Plague_" .. faction_name);
end;

function StartPlagueNearPosition(plague_key, owner, effect, x, y)
	out("StartPlagueNearPosition("..plague_key..", "..owner..", "..effect..", "..x..", "..y..")");
	if NURGLE_PLAGUE_LIST[plague_key] ~= nil then
		out("Error: Plague with a key of '"..plague_key.."' has already started!");
		return false;
	end
	
	local region_list = cm:model():world():region_manager():region_list();
	local shortest_distance = 999999;
	local closest_region = "";
	local closest_pos = {x = 0, y = 0};
	
	for i = 0, region_list:num_items() - 1 do
		local region = region_list:item_at(i);
		if region:is_null_interface() == false and region:settlement():is_null_interface() == false and region:is_abandoned() == false then
			local region_key = region:name();
			local distance = distance_squared(x, y, region:settlement():logical_position_x(), region:settlement():logical_position_y());
			
			if distance < shortest_distance then
				shortest_distance = distance;
				closest_region = region_key;
				closest_pos = {x = x, y = y};
			end
		end
	end
	
	NURGLE_PLAGUE_LIST[plague_key] = {};
	NURGLE_PLAGUE_LIST[plague_key].owner = owner;
	NURGLE_PLAGUE_LIST[plague_key].effect = effect;
	NURGLE_PLAGUE_LIST[plague_key].regions = {};

	Stop_Nurgle_Plague_Faction_Turn_Start_Listener(owner);
	Start_Nurgle_Plague_Faction_Turn_Start_Listener(owner);
	
	GiveRegionPlague(plague_key, closest_region, false);
	
	Show_Plague_Event(owner, closest_pos.x, closest_pos.y, true);
	NURGLE_PLAGUE_EVENT_COOLDOWN = PLAGUE_MAX_LIFETIME + 1;
	return true;
end

function GetRegionXY(reg)
	local region = cm:model():world():region_manager():region_by_key(reg);
	
	if region:is_null_interface() == false then
		if region:settlement():is_null_interface() == false then
			return region:settlement():logical_position_x(), region:settlement():logical_position_y();
		end
	end
	return 0, 0;
end

function Plague_TurnStart(context)
	-- logTxt = "";
	
	for plague_key, plague_data in pairs(NURGLE_PLAGUE_LIST) do
		if plague_data.owner == context:faction():name() then
			UpdatePlague(plague_key);
		end
	end
	
	-- table.insert(plague_log, logTxt);
end

function UpdatePlague(plague_key)
	local plague = NURGLE_PLAGUE_LIST[plague_key];
	
	if plague ~= nil then
		print("-------------------------------------------------------------");
		print("----- UpdatePlague ("..plague_key..") -----");
		print("-------------------------------------------------------------");
		if NURGLE_PLAGUE_EVENT_COOLDOWN > 0 then
			NURGLE_PLAGUE_EVENT_COOLDOWN = NURGLE_PLAGUE_EVENT_COOLDOWN - 1;
		end
		
		for region_key, region_plague in pairs(plague.regions) do
			if region_plague ~= nil then
				local x, y = GetRegionXY(region_key);
				-- logTxt = logTxt..x..","..y..","..region_plague.life..";";
			
				if region_plague.life > 0 then
					print("Region: "..region_key.." (Life: "..region_plague.life..", Spread: "..region_plague.spread..")");
					-- This region has the plague!
					cm:remove_effect_bundle_from_region(plague.effect, region_key);
					cm:apply_effect_bundle_to_region(plague.effect, region_key, 0);
					CampaignUI.UpdateSettlementEffectIcons();
					region_plague.life = region_plague.life - 1;
					
					if region_plague.spread > 0 then
						local spread_chance = PLAGUE_SPREAD_CHANCE;
						
						if region_plague.life <= 0 then
							-- Last chance for this plague to spread
							spread_chance = 100;
						end
						
						print("\tSpread: "..region_plague.spread.." (Chance: "..spread_chance.."%)");
						if cm:model():random_percent(spread_chance) then
							local adjacent_region = GetAdjacentRegionForPlague(plague_key, region_key, true);
							
							if adjacent_region ~= nil then
								print("\t\tSuccess! - Spreading to region: "..adjacent_region);
								GiveRegionPlague(plague_key, adjacent_region, false);
								region_plague.spread = region_plague.spread - 1;
								
								if NURGLE_PLAGUE_EVENT_COOLDOWN < 1 then
									Show_Plague_Event(plague.owner, x, y, false);
									NURGLE_PLAGUE_EVENT_COOLDOWN = PLAGUE_MAX_LIFETIME + 1;
								end
							end
						else
							print("\t\tFailed!");
						end
					else
						print("\tCannot spread!");
					end
				elseif region_plague.life == 0 then
					-- Plague has died out in this region
					cm:remove_effect_bundle_from_region(plague.effect, region_key);
					Remove_Plague_VFX(region_key);
					CampaignUI.UpdateSettlementEffectIcons();
					plague.regions[region_key] = nil;
					Add_Region_Cooldown(plague_key, region_key, PLAGUE_COOLDOWN);
					print("Region: "..region_key.." - Removing Plague!");
				end
			end
		end
		print("-------------------------------------------------------------");
		print("");
	end
	
	-- Update Cooldowns
	if NURGLE_PLAGUE_LIST_COOLDOWNS[plague_key] ~= nil then
		print("---- Cooldowns ----");
		for region_key, cooldown in pairs(NURGLE_PLAGUE_LIST_COOLDOWNS[plague_key]) do
			NURGLE_PLAGUE_LIST_COOLDOWNS[plague_key][region_key] = NURGLE_PLAGUE_LIST_COOLDOWNS[plague_key][region_key] - 1;
			
			if NURGLE_PLAGUE_LIST_COOLDOWNS[plague_key][region_key] == 0 then
				NURGLE_PLAGUE_LIST_COOLDOWNS[plague_key][region_key] = nil;
			end
		end
		print("----------------------");
		print("");
	end
end

function GiveRegionPlague(plague_key, region_key, is_abandoned_check)
	if NURGLE_PLAGUE_LIST[plague_key] ~= nil then
		out("Giving plague "..plague_key.." to region: "..region_key);
		is_abandoned_check = is_abandoned_check or false;
		local region = cm:model():world():region_manager():region_by_key(region_key);
		
		if region:is_null_interface() == false then
			if not (is_abandoned_check == true and region:is_abandoned() == true) then
				local turns = cm:random_number(PLAGUE_MAX_LIFETIME, PLAGUE_MIN_LIFETIME);
				
				cm:remove_effect_bundle_from_region(NURGLE_PLAGUE_KEY, region_key);
				cm:apply_effect_bundle_to_region(NURGLE_PLAGUE_KEY, region_key, 0);
				CampaignUI.UpdateSettlementEffectIcons();
				
				NURGLE_PLAGUE_LIST[plague_key].regions[region_key] = {};
				NURGLE_PLAGUE_LIST[plague_key].regions[region_key].life = turns;
				NURGLE_PLAGUE_LIST[plague_key].regions[region_key].spread = cm:random_number(MAX_TRANSFER_REGIONS, MIN_TRANSFER_REGIONS);
				print("#### Infecting Region: "..region_key.." (Life: "..turns..") (Spread: "..NURGLE_PLAGUE_LIST[plague_key].regions[region_key].spread..") ####");
				
				Add_Plague_VFX(region_key);
			end
		end
	end
end

function GetAdjacentRegionForPlague(plague_key, region_name, is_abandoned_check)
	local region = cm:model():world():region_manager():region_by_key(region_name);
	local adjacent_region_list = region:adjacent_region_list();
	local uninfected_adjacent_regions = {};
	local adjacent_region = nil;
	
	for i = 0, adjacent_region_list:num_items() - 1 do
		local cur_region = adjacent_region_list:item_at(i);
		
		if is_abandoned_check == true and cur_region:is_abandoned() == false then
			local region_name = cur_region:name();
			local is_infected = false;
			
			if NURGLE_PLAGUE_LIST[plague_key].regions[region_name] ~= nil then
				if NURGLE_PLAGUE_LIST[plague_key].regions[region_name].life > 0 then
					is_infected = true;
				end
			end
			
			if Is_Region_In_Cooldown(plague_key, region_name) == true then
				is_infected = true;
			end
			
			if is_infected == false then
				table.insert(uninfected_adjacent_regions, region_name);
			end
		end
	end
	
	if #uninfected_adjacent_regions > 0 then
		return uninfected_adjacent_regions[cm:random_number(#uninfected_adjacent_regions)];
	else
		if is_abandoned_check == true then
			GetAdjacentRegionForPlague(plague_key, region_name, false)
		else
			return nil;
		end
	end
end

function Kill_Plague(plague_key)
	local plague = NURGLE_PLAGUE_LIST[plague_key];
	
	if plague ~= nil then
		for region_key, region_data in pairs(plague.regions) do
			local region_plague = region_data;
			
			if region_plague ~= nil then
				cm:remove_effect_bundle_from_region(plague.effect, region_key);
				Remove_Plague_VFX(region_key);
				CampaignUI.UpdateSettlementEffectIcons();
			end
		end
	end

	NURGLE_PLAGUE_LIST[plague_key] = nil;

	local plague_owner = plague.owner;

	-- if the faction owning the plague that just got purged owns no other plagues then remove its FactionTurnStart listener
	for _, current_plague_data in pairs(NURGLE_PLAGUE_LIST) do
		if current_plague_data.owner == plague_owner then
			return;
		end
	end

	Stop_Nurgle_Plague_Faction_Turn_Start_Listener(plague_owner);
end

function Add_Region_Cooldown(plague_key, region_key, cooldown)
	if NURGLE_PLAGUE_LIST_COOLDOWNS[plague_key] == nil then
		NURGLE_PLAGUE_LIST_COOLDOWNS[plague_key] = {};
	end
	NURGLE_PLAGUE_LIST_COOLDOWNS[plague_key][region_key] = cooldown;
end

function Is_Region_In_Cooldown(plague_key, region_key)
	if NURGLE_PLAGUE_LIST_COOLDOWNS[plague_key] ~= nil then
		if NURGLE_PLAGUE_LIST_COOLDOWNS[plague_key][region_key] ~= nil then
			if NURGLE_PLAGUE_LIST_COOLDOWNS[plague_key][region_key] > 0 then
				return true;
			end
		end
	end
	return false;
end

function Add_Plague_VFX(region_key)
	local region = cm:model():world():region_manager():region_by_key(region_key);
	
	local garrison_residence = region:garrison_residence();
	local garrison_residence_CQI = garrison_residence:command_queue_index();
	cm:add_garrison_residence_vfx(garrison_residence_CQI, "scripted_effect2", true);
end

function Remove_Plague_VFX(region_key)
	local garrison_residence = cm:model():world():region_manager():region_by_key(region_key):garrison_residence();
	local garrison_residence_CQI = garrison_residence:command_queue_index();
	cm:remove_garrison_residence_vfx(garrison_residence_CQI, "scripted_effect2");
end

function Show_Plague_Event(faction_key, x, y, is_start)
	if is_start == true then
		cm:show_message_event_located(
			faction_key,
			"event_feed_strings_text_wh_dlc08_event_feed_string_scripted_event_nurgle_plague_start_title",
			"event_feed_strings_text_wh_dlc08_event_feed_string_scripted_event_nurgle_plague_start_primary_detail",
			"event_feed_strings_text_wh_dlc08_event_feed_string_scripted_event_nurgle_plague_start_secondary_detail",
			x,
			y,
			true,
			881
		);
	else
		cm:show_message_event_located(
			faction_key,
			"event_feed_strings_text_wh_dlc08_event_feed_string_scripted_event_nurgle_plague_title",
			"event_feed_strings_text_wh_dlc08_event_feed_string_scripted_event_nurgle_plague_primary_detail",
			"event_feed_strings_text_wh_dlc08_event_feed_string_scripted_event_nurgle_plague_secondary_detail",
			x,
			y,
			true,
			882
		);
	end
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("NURGLE_PLAGUE_LIST", NURGLE_PLAGUE_LIST, context);
		cm:save_named_value("NURGLE_PLAGUE_LIST_COOLDOWNS", NURGLE_PLAGUE_LIST_COOLDOWNS, context);
		cm:save_named_value("NURGLE_PLAGUE_EVENT_COOLDOWN", NURGLE_PLAGUE_EVENT_COOLDOWN, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		NURGLE_PLAGUE_LIST = cm:load_named_value("NURGLE_PLAGUE_LIST", {}, context);
		NURGLE_PLAGUE_LIST_COOLDOWNS = cm:load_named_value("NURGLE_PLAGUE_LIST_COOLDOWNS", {}, context);
		NURGLE_PLAGUE_EVENT_COOLDOWN = cm:load_named_value("NURGLE_PLAGUE_EVENT_COOLDOWN", 0, context);
	end
);