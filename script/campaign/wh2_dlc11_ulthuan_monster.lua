local ulthuan_monster_owner = "";
local ulthuan_monster_cooldown = 20;
local ulthuan_monster_attacked_cqi = 0;
local ulthuan_monster_attacked_on = 0;
local ulthuan_monster_prefix = "wh2_dlc11_event_feed_string_scripted_event_ulthuan_monster";
local ulthuan_monster_storm_chance = 50; -- The chance that the monster creates a storm in a region instead of attacking a coastal settlement
local ulthuan_monster_building_damage = 70;

local vampire_coast_faction_key_lookup = {
	["wh2_dlc11_cst_noctilus"] 				= true,
	["wh2_dlc11_cst_pirates_of_sartosa"]	= true,
	["wh2_dlc11_cst_the_drowned"] 			= true,
	["wh2_dlc11_cst_vampire_coast"] 		= true
};

-- start a faction turn start listener for the current monster owner, if any
local function start_ulthuan_monster_owner_turn_start_listener()
	cm:remove_faction_turn_start_listener_by_name("ulthuan_monster_owner");

	if is_string(ulthuan_monster_owner) and #ulthuan_monster_owner > 0 then
		cm:add_faction_turn_start_listener_by_name(
			"ulthuan_monster_owner",
			ulthuan_monster_owner, 
			function(context) UlthuanMonsterFactionTurnStart(context) end,
			true
		);
	end;
end;

function add_ulthuan_monster_listeners()
	out("#### Adding Ulthuan Monster Listeners ####");
	core:add_listener(
		"UlthuanMonsterFactionTurnStart",
		"ScriptEventHumanFactionTurnStart",
		true,
		function(context) UlthuanMonsterFactionTurnStart(context) end,
		true
	);

	start_ulthuan_monster_owner_turn_start_listener();

	core:add_listener(
		"UlthuanMonsterMissionSucceeded",
		"MissionSucceeded",
		function(context) return context:mission():mission_record_key() == "wh2_dlc11_cst_final_battle" end,
		function(context) UlthuanMonsterMissionSucceeded(context) end,
		false
	);
	
	if cm:is_new_game() == true then
		ulthuan_monster_cooldown = 11 + cm:random_number(3);
		out("\tUlthuan Monster First Turn: "..ulthuan_monster_cooldown);
		
		-- initialise this value at the start of a new sp campaign
		if not cm:is_multiplayer() then
			cm:set_saved_value("num_ulthuan_monster_attacks", 0);
		end;
	end
end

function UlthuanMonsterFactionTurnStart(context)
	local faction = context:faction();
	local turn_number = cm:model():turn_number();
	local faction_key = faction:name();
	
	if ulthuan_monster_attacked_cqi > 0 and turn_number >= (ulthuan_monster_attacked_on + 10) then
		cm:remove_garrison_residence_vfx(ulthuan_monster_attacked_cqi, "scripted_effect10");
		ulthuan_monster_attacked_cqi = 0;
	end
	
	-- If the player controls the monster then we do it on their turn
	-- Otherwise we try do it on any human Vampire Coast players turn
	local is_vampire_coast = vampire_coast_faction_key_lookup[faction_key];
	local do_monster = faction:is_human() == true and is_vampire_coast == true;
	
	if ulthuan_monster_owner ~= "" then
		-- Only do the monster on the players turn if they own it
		do_monster = faction:name() == ulthuan_monster_owner;
	end
	
	if do_monster == true and (turn_number >= ulthuan_monster_cooldown or (core:is_tweaker_set("SKIP_SCRIPTED_CONTENT_7") and cm:turn_number() > 1)) then
		local key = ulthuan_monster_prefix;
		local coastal = cm:model():random_percent(100 - ulthuan_monster_storm_chance);
		local monster_faction = nil;
		
		local target_region = false;
		
		if ulthuan_monster_owner ~= "" then
			monster_faction = cm:model():world():faction_by_key(ulthuan_monster_owner);
		end
		
		-- if this is a sp game where the monster is not owned and hasn't attacked before, and the Ulthuan Monster advice has not been heard before, then force the target to be a coastal region close to the player
		if cm:is_multiplayer() or cm:get_saved_value("ulthuan_monster_has_attacked_before" or monster_faction) or not in_ulthuan_monster_first_attack.is_started then
			if coastal == true and monster_faction == nil and cm:model():random_percent(50) then
				target_region = UlthuanMonsterFindTargetVisibleToPlayer();
			else
				target_region = UlthuanMonsterFindTarget(coastal, monster_faction);
			end
		else
			target_region = UlthuanMonsterFindTargetVisibleToPlayer();
			coastal = true;
		end
		
		if coastal == true then
			key = key.."_coastal";
		else
			key = key.."_sea";
		end
		
		if monster_faction ~= nil then
			key = key.."_player";
		end
		
		if target_region ~= nil and target_region:is_null_interface() == false then
			local x = 0;
			local y = 0;
			
			-- increment attack counter
			local num_ulthuan_monster_attacks = -1;
			if not cm:is_multiplayer() then
				num_ulthuan_monster_attacks = cm:get_saved_value("num_ulthuan_monster_attacks") or 0;
				num_ulthuan_monster_attacks = num_ulthuan_monster_attacks + 1;
				cm:set_saved_value("num_ulthuan_monster_attacks", num_ulthuan_monster_attacks);
			end;
			
			local region_key = "";
			
			if coastal == true then
				-- Coastal Attack
				region_key = target_region:name();
				out("Ulthuan Monster: Attacking coastal region - "..tostring(region_key));
				-- Apply region effect
				cm:apply_effect_bundle_to_region("wh2_dlc11_bundle_amanar_attack", region_key, 10);
				ulthuan_monster_attacked_on = turn_number;
				-- Apply region VFX
				local garrison_residence = target_region:garrison_residence();
				ulthuan_monster_attacked_cqi = garrison_residence:command_queue_index();
				cm:add_garrison_residence_vfx(ulthuan_monster_attacked_cqi, "scripted_effect10", true);
				x = target_region:settlement():logical_position_x();
				y = target_region:settlement():logical_position_y();
				-- Damage Buildings
				UlthuanMonsterDamageRegion(target_region);
				
				local display_x, display_y = cm:log_to_dis(x, y);
				
				-- notify advice scripts
				if not cm:is_multiplayer() then
					core:trigger_event("ScriptEventUlthuanMonsterAttacksSettlement", num_ulthuan_monster_attacks, v(display_x, display_y), region_key);
				end;
			else
				-- Sea Storm
				region_key = target_region:key();
				out("Ulthuan Monster: Creating storm in region - "..tostring(region_key));
				cm:create_storm_for_region(region_key, 1, 10, "vampire_coast_sea_monster_storm");
				local box_x, box_y, box_width, box_height = target_region:get_bounds();
				out("\t"..tostring(box_x)..", "..tostring(box_y)..", "..tostring(box_width)..", "..tostring(box_height));
				x = box_x + ((box_width - box_x) / 2);
				y = box_y + ((box_height - box_y) / 2);
				
				out("X: "..tostring(x).." / ".."Y: "..tostring(y));
				
				-- notify advice scripts
				if not cm:is_multiplayer() then
					core:trigger_event("ScriptEventUlthuanMonsterAttacksSea", num_ulthuan_monster_attacks, v(x, y), region_key);
				end;
			end
			
			cm:set_saved_value("ulthuan_monster_has_attacked_before", true);
			
			cm:show_message_event_located(
				faction:name(),
				"event_feed_strings_text_"..ulthuan_monster_prefix.."_title",
				"regions_onscreen_" .. region_key,
				"event_feed_strings_text_"..key.."_secondary_detail",
				x, y,
				true,
				1100
			);
			ulthuan_monster_cooldown = turn_number + 12 + cm:random_number(4);
		end
	end
end

function UlthuanMonsterFindTarget(coastal, player)
	local possible_targets = {};
	
	if coastal == true then
		local region_list = cm:model():world():region_manager():region_list();
		
		for i = 0, region_list:num_items() - 1 do
			local region = region_list:item_at(i);
			
			-- Region must not be abandoned and must be coastal
			if region:is_abandoned() == false and region:settlement():is_port() == true then
				if player == nil then
					-- Player doesn't own monster
					table.insert(possible_targets, region);
				else
					-- Player owns monster
					local owner = region:owning_faction();
					
					if player:name() ~= owner:name() then
						-- This region owner is not the player
						if player:at_war_with(owner) == true then
							-- The region owner is the players enemy
							table.insert(possible_targets, region);
						end
					end
				end
			end
		end
	else
		local region_list = cm:model():world():sea_region_data();
		
		for i = 0, region_list:num_items() - 1 do
			local sea_region = region_list:item_at(i);
			local sea_region_key = sea_region:key();
			
			if sea_region_key ~= "wh3_main_combi_region_river_reik" and sea_region_key ~= "wh_main_riv_talabec" and sea_region_key ~= "wh3_main_combi_region_lake" then
				table.insert(possible_targets, sea_region);
			end
		end
	end
	
	if #possible_targets > 0 then
		local rand = cm:random_number(#possible_targets);
		local target = possible_targets[rand];
		return target;
	end
	return nil;
end


-- This should only be called once per-game when the Ulthuan monster first appears
-- It picks a coastal target in a region the player can see
function UlthuanMonsterFindTargetVisibleToPlayer()
	out("* UlthuanMonsterFindTargetVisibleToPlayer() called, picking a region the player can see to spawn the monster in");

	local player_faction_name = cm:get_local_faction_name();						-- should not be calling this in mp
	local region_list = cm:model():world():region_manager():region_list();
	local eligible_regions = {};

	for i = 0, region_list:num_items() - 1 do
		local region = region_list:item_at(i);
		
		-- Region must be coastal, not abandoned, and not owned by the player
		if region:settlement():is_port() and not region:is_abandoned() and region:owning_faction():name() ~= player_faction_name then
			local garrison_army = cm:get_armed_citizenry_from_garrison(region:garrison_residence());
			if garrison_army and garrison_army:has_general() and garrison_army:general_character():is_visible_to_faction(player_faction_name) then
				-- the garrison commander of this settlement is visible to the player, so add it to the eligible targets list
				table.insert(eligible_regions, region);
			end;
		end
	end
	
	if #eligible_regions > 0 then
		local rand = cm:random_number(#eligible_regions);
		out("\tpicking region " .. eligible_regions[rand]:name());
		return eligible_regions[rand];
	else
		out("\tcouldn't find an eligible region");
	end;
end



function UlthuanMonsterDamageRegion(region)
	local slot_list = region:slot_list();
	
	for i = 0, slot_list:num_items() - 1 do
		local current_slot = slot_list:item_at(i);
		
		if current_slot:has_building() == true then
			cm:instant_set_building_health_percent(region:name(), current_slot:building():chain(), 100 - ulthuan_monster_building_damage);
		end
	end
end

function UlthuanMonsterMissionSucceeded(context)
	ulthuan_monster_owner = context:mission():faction():name();
	start_ulthuan_monster_owner_turn_start_listener();
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("ulthuan_monster_owner", ulthuan_monster_owner, context);
		cm:save_named_value("ulthuan_monster_cooldown", ulthuan_monster_cooldown, context);
		cm:save_named_value("ulthuan_monster_attacked_cqi", ulthuan_monster_attacked_cqi, context);
		cm:save_named_value("ulthuan_monster_attacked_on", ulthuan_monster_attacked_on, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		ulthuan_monster_owner = cm:load_named_value("ulthuan_monster_owner", ulthuan_monster_owner, context);
		ulthuan_monster_cooldown = cm:load_named_value("ulthuan_monster_cooldown", ulthuan_monster_cooldown, context);
		ulthuan_monster_attacked_cqi = cm:load_named_value("ulthuan_monster_attacked_cqi", ulthuan_monster_attacked_cqi, context);
		ulthuan_monster_attacked_on = cm:load_named_value("ulthuan_monster_attacked_on", ulthuan_monster_attacked_on, context);
	end
);