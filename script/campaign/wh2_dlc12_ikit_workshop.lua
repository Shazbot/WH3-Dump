local ikit_faction_cqi = 0;
local ikit_faction = "wh2_main_skv_clan_skryre";
local ikit_subtype = "wh2_dlc12_skv_ikit_claw";
local engineer_subtype = "wh2_main_skv_warlock_engineer";
local master_engineer_subtype = "wh2_dlc12_skv_warlock_master";

-- key, progress_threshold, progress_reward
local workshop_category_keys = {
	weapon_team = "weapon_team",
	doom_wheel = "doom_wheel",
	doom_flayer = "doom_flayer"
};

local workshop_category_detail = {
	-- Rewards are keyed by the index of the progress bar at which they unlock. i.e. you do 2 Weapons Team upgrades and then get the reward at index [2].
	-- Worried about Key-Value-Pair iteration and desynchs? It should be fine, as only one of these reward entries should ever be accessed and used
	-- in a given upgrade. There's no chance of accidentally looking up items in the wrong order and causing a desych.
	[workshop_category_keys.weapon_team] =
	{
		rewards = {
			[2] = {ancillary = "wh2_dlc12_anc_magic_standard_incendiary_rounds"},
			[4] = {ancillary = "wh2_dlc12_anc_magic_standard_cape_of_sniper"},
			[5] = {unit = "wh2_dlc12_skv_inf_warpfire_thrower_ror_tech_lab_0"},
			[6] = {unit = "wh2_dlc12_skv_art_warplock_jezzails_ror_tech_lab_0"},
			[7] = {unit = "wh2_dlc12_skv_inf_ratling_gun_ror_tech_lab_0"},
		}
	},
	[workshop_category_keys.doom_wheel] =
	{
		rewards = {
			[2] = {ancillary = "wh2_dlc12_anc_talisman_warp_field_generator"},
			[4] = {ancillary = "wh2_dlc12_anc_weapon_thing_zapper"},
			[6] = {ancillary = "wh2_dlc12_anc_enchanted_item_modulated_doomwheel_assembly_kit"},
			[7] = {ancillary = "wh2_dlc12_anc_enchanted_item_warp_lightning_battery"},
			[8] = {unit = "wh2_dlc12_skv_veh_doomwheel_ror_tech_lab_0"},
		}
	},
	[workshop_category_keys.doom_flayer] =
	{
		rewards = {
			[2] = {ancillary = "wh2_dlc12_anc_armour_alloy_shield"},
			[4] = {ancillary = "wh2_dlc12_anc_weapon_retractable_fistblade"},
			[6] = {ancillary = "wh2_dlc12_anc_weapon_mechanical_arm"},
			[7] = {ancillary = "wh2_dlc12_anc_armour_power_armour"},
			[8] = {unit = "wh2_dlc12_skv_veh_doom_flayer_ror_tech_lab_0"},
		}
	},
};

local workshop_category_progress = {
	[workshop_category_keys.weapon_team] = 0,
	[workshop_category_keys.doom_wheel] = 0,
	[workshop_category_keys.doom_flayer] = 0
};

local workshop_upgrade_incidents = {
	"",
	"wh2_dlc12_incident_skv_workshop_upgrade_2",
	"wh2_dlc12_incident_skv_workshop_upgrade_3",
	"wh2_dlc12_incident_skv_workshop_upgrade_4"
};

local workshop_nuke_rite_keys = {
	"wh2_dlc12_ikit_workshop_nuke_part_0",
	"wh2_dlc12_ikit_workshop_nuke_part_1",
	"wh2_dlc12_ikit_workshop_nuke_part_2",
	"wh2_dlc12_ikit_workshop_nuke_part_3",
	"wh2_dlc12_ikit_workshop_nuke_part_4",
	"wh2_dlc12_ikit_workshop_nuke_part_5"
};

local workshop_rite_details = {
	["wh2_dlc12_ikit_workshop_gatling_part_1"] = {category = workshop_category_keys.weapon_team, researched = false},
	["wh2_dlc12_ikit_workshop_jezail_part_0"] = {category = workshop_category_keys.weapon_team, researched = false},
	["wh2_dlc12_ikit_workshop_warpfire_part_2"] = {category = workshop_category_keys.weapon_team, researched = false},
	["wh2_dlc12_ikit_workshop_poison_wind_globaldier_0"] = {category = workshop_category_keys.weapon_team, researched = false}, 
	["wh2_dlc12_ikit_workshop_poison_wind_mortar_0"] = {category = workshop_category_keys.weapon_team, researched = false}, 
	["wh2_dlc12_ikit_workshop_warpgrinder_0"] = {category = workshop_category_keys.weapon_team, researched = false}, 
	["wh2_dlc12_ikit_workshop_doomwheel_part_0"] = {category = workshop_category_keys.doom_wheel, researched = false},
	["wh2_dlc12_ikit_workshop_doomwheel_part_2"] = {category = workshop_category_keys.doom_wheel, researched = false},
	["wh2_dlc12_ikit_workshop_doomwheel_part_6"] = {category = workshop_category_keys.doom_wheel, researched = false},
	["wh2_dlc12_ikit_workshop_doomwheel_part_9"] = {category = workshop_category_keys.doom_wheel, researched = false},
	["wh2_dlc12_ikit_workshop_doomflayer_part_1"] = {category = workshop_category_keys.doom_flayer, researched = false},
	["wh2_dlc12_ikit_workshop_doomflayer_part_5"] = {category = workshop_category_keys.doom_flayer, researched = false},
	["wh2_dlc12_ikit_workshop_doomflayer_part_6"] = {category = workshop_category_keys.doom_flayer, researched = false},
	["wh2_dlc12_ikit_workshop_doomflayer_part_9"] = {category = workshop_category_keys.doom_flayer, researched = false},
	["wh2_dlc12_ikit_workshop_gatling_part_2"] = {category = workshop_category_keys.weapon_team, researched = false},
	["wh2_dlc12_ikit_workshop_jezail_part_2"] = {category = workshop_category_keys.weapon_team, researched = false},
	["wh2_dlc12_ikit_workshop_warpfire_part_1"] = {category = workshop_category_keys.weapon_team, researched = false},
	["wh2_dlc12_ikit_workshop_poison_wind_globaldier_1"] = {category = workshop_category_keys.weapon_team, researched = false}, 
	["wh2_dlc12_ikit_workshop_poison_wind_mortar_1"] = {category = workshop_category_keys.weapon_team, researched = false}, 
	["wh2_dlc12_ikit_workshop_warpgrinder_1"] = {category = workshop_category_keys.weapon_team, researched = false}, 
	["wh2_dlc12_ikit_workshop_doomwheel_part_1"] = {category = workshop_category_keys.doom_wheel, researched = false},
	["wh2_dlc12_ikit_workshop_doomwheel_part_4"] = {category = workshop_category_keys.doom_wheel, researched = false},
	["wh2_dlc12_ikit_workshop_doomwheel_part_8"] = {category = workshop_category_keys.doom_wheel, researched = false},
	["wh2_dlc12_ikit_workshop_doomflayer_part_0"] = {category = workshop_category_keys.doom_flayer, researched = false},
	["wh2_dlc12_ikit_workshop_doomflayer_part_2"] = {category = workshop_category_keys.doom_flayer, researched = false},
	["wh2_dlc12_ikit_workshop_doomflayer_part_7"] = {category = workshop_category_keys.doom_flayer, researched = false},
	["wh2_dlc12_ikit_workshop_gatling_part_0"] = {category = workshop_category_keys.weapon_team, researched = false},
	["wh2_dlc12_ikit_workshop_jezail_part_1"] = {category = workshop_category_keys.weapon_team, researched = false},
	["wh2_dlc12_ikit_workshop_warpfire_part_0"] = {category = workshop_category_keys.weapon_team, researched = false},
	["wh2_dlc12_ikit_workshop_poison_wind_globaldier_2"] = {category = workshop_category_keys.weapon_team, researched = false}, 
	["wh2_dlc12_ikit_workshop_poison_wind_mortar_2"] = {category = workshop_category_keys.weapon_team, researched = false}, 
	["wh2_dlc12_ikit_workshop_warpgrinder_2"] = {category = workshop_category_keys.weapon_team, researched = false}, 
	["wh2_dlc12_ikit_workshop_doomwheel_part_5"] = {category = workshop_category_keys.doom_wheel, researched = false},
	["wh2_dlc12_ikit_workshop_doomwheel_part_7"] = {category = workshop_category_keys.doom_wheel, researched = false},
	["wh2_dlc12_ikit_workshop_doomflayer_part_3"] = {category = workshop_category_keys.doom_flayer, researched = false},
	["wh2_dlc12_ikit_workshop_doomflayer_part_8"] = {category = workshop_category_keys.doom_flayer, researched = false},
	["wh2_dlc12_ikit_workshop_doomwheel_part_3"] = {category = workshop_category_keys.doom_wheel, researched = false},
	["wh2_dlc12_ikit_workshop_doomflayer_part_4"] = {category = workshop_category_keys.doom_flayer, researched = false},
	["wh2_dlc12_ikit_workshop_nuke_part_0"] = {category = "", researched = false},
	["wh2_dlc12_ikit_workshop_nuke_part_1"] = {category = "", researched = false},
	["wh2_dlc12_ikit_workshop_nuke_part_2"] = {category = "", researched = false},
	["wh2_dlc12_ikit_workshop_nuke_part_3"] = {category = "", researched = false},
	["wh2_dlc12_ikit_workshop_nuke_part_4"] = {category = "", researched = false},
	["wh2_dlc12_ikit_workshop_nuke_part_5"] = {category = "", researched = false}
};

-- Each upgrade requires a workshop level of the corresponding index to be researched.
local workshop_rite_keys = {
	{	"wh2_dlc12_ikit_workshop_gatling_part_1", 
		"wh2_dlc12_ikit_workshop_jezail_part_0",  
		"wh2_dlc12_ikit_workshop_warpfire_part_2", 
		"wh2_dlc12_ikit_workshop_doomwheel_part_0", 
		"wh2_dlc12_ikit_workshop_doomwheel_part_2", 
		"wh2_dlc12_ikit_workshop_doomwheel_part_6", 
		"wh2_dlc12_ikit_workshop_doomwheel_part_9", 
		"wh2_dlc12_ikit_workshop_doomflayer_part_1", 
		"wh2_dlc12_ikit_workshop_doomflayer_part_5", 
		"wh2_dlc12_ikit_workshop_doomflayer_part_6",
		"wh2_dlc12_ikit_workshop_doomflayer_part_9",
		"wh2_dlc12_ikit_workshop_poison_wind_globaldier_0",
		"wh2_dlc12_ikit_workshop_poison_wind_mortar_0",
		"wh2_dlc12_ikit_workshop_warpgrinder_0"
	},
	{	"wh2_dlc12_ikit_workshop_gatling_part_2",
		"wh2_dlc12_ikit_workshop_jezail_part_2", 
		"wh2_dlc12_ikit_workshop_warpfire_part_1",
		"wh2_dlc12_ikit_workshop_doomwheel_part_1",
		"wh2_dlc12_ikit_workshop_doomwheel_part_4",
		"wh2_dlc12_ikit_workshop_doomwheel_part_8",
		"wh2_dlc12_ikit_workshop_doomflayer_part_0",
		"wh2_dlc12_ikit_workshop_doomflayer_part_2",
		"wh2_dlc12_ikit_workshop_doomflayer_part_7",
		"wh2_dlc12_ikit_workshop_poison_wind_globaldier_1",
		"wh2_dlc12_ikit_workshop_poison_wind_mortar_1",
		"wh2_dlc12_ikit_workshop_warpgrinder_1"
	},
	{	"wh2_dlc12_ikit_workshop_gatling_part_0", 
		"wh2_dlc12_ikit_workshop_jezail_part_1", 
		"wh2_dlc12_ikit_workshop_warpfire_part_0", 
		"wh2_dlc12_ikit_workshop_doomwheel_part_5", 
		"wh2_dlc12_ikit_workshop_doomwheel_part_7", 
		"wh2_dlc12_ikit_workshop_doomflayer_part_3",
		"wh2_dlc12_ikit_workshop_doomflayer_part_8",
		"wh2_dlc12_ikit_workshop_poison_wind_globaldier_2",
		"wh2_dlc12_ikit_workshop_poison_wind_mortar_2",
		"wh2_dlc12_ikit_workshop_warpgrinder_2"
	},
	{	"wh2_dlc12_ikit_workshop_doomwheel_part_3", 
		"wh2_dlc12_ikit_workshop_doomflayer_part_4"
	}
};

local nuke_resource_key = "skv_nuke";
local nuke_rite_key = "wh2_dlc12_ikit_nuke_rite";

local nuke_resource_factor_key = {
	["add"] = "workshop_production",
	["negative"] = "consumed_in_battle"
};

local nuke_limit_default = 5;
local nuke_limit_improved = 8;
local nuke_limit = 5;

local additional_nuke_chance = 25;

local nuke_effect_bundle_key = {
	"wh2_dlc12_nuke_ability_enable",
	"wh2_dlc12_nuke_ability_upgrade_enable"
};

local nuke_ability_key = "wh2_dlc12_army_abilities_warpstorm_doomrocket";
local nuke_ability_upgrade_key = "wh2_dlc12_army_abilities_warpstorm_doomrocket_upgraded";

local nuke_drop_chance_current = 0;
local nuke_replenish_effect_bundle = "wh2_dlc12_force_temporary_replenish";

local reactor_resource_key = "skv_reactor_core";

local reactor_resource_factor_key = {
	["add"] = "discovered_in_battle",
	["add_alt"] = "hero_actions",
	["add_mission"] = "workshop_upgrade",
	["negative"] = "workshop_research"
};

local reactor_add_chances = {
	[ikit_subtype] = {40, 1, 0},
	[master_engineer_subtype] = {20, 1, 0},
	[engineer_subtype] = {30, 1, 0},
	["extra_loot"] = {12, 1, 0}
};

local workshop_level_dummy_effect_bundle = {
	"wh2_dlc12_workshop_level_0_dummy",
	"wh2_dlc12_workshop_level_1_dummy",
	"wh2_dlc12_workshop_level_2_dummy",
	"wh2_dlc12_workshop_level_3_dummy"
};

local workshop_level_reactor_core_reward = 5;

local workshop_lvl_missions = {
	{"wh2_dlc12_ikit_workshop_tier_1_0", "wh2_dlc12_ikit_workshop_tier_1_1", "wh2_dlc12_ikit_workshop_tier_1_2"},
	{"wh2_dlc12_ikit_workshop_tier_2_0", "wh2_dlc12_ikit_workshop_tier_2_1", "wh2_dlc12_ikit_workshop_tier_2_2"},
	{"wh2_dlc12_ikit_workshop_tier_3_1", "wh2_dlc12_ikit_workshop_tier_3_2"},
	{}
};

local workshop_lvl_missions_scripted = {
	"wh2_dlc12_ikit_workshop_tier_1_2",
	"wh2_dlc12_ikit_workshop_tier_2_0",
	"wh2_dlc12_ikit_workshop_tier_2_1",
	"wh2_dlc12_ikit_workshop_tier_3_1"
};

local workshop_lvl_missions_scripted_listener = {
	["wh2_dlc12_ikit_workshop_tier_1_2"] = false,
	["wh2_dlc12_ikit_workshop_tier_2_0"] = false,
	["wh2_dlc12_ikit_workshop_tier_2_1"] = false,
	["wh2_dlc12_ikit_workshop_tier_3_0"] = false,
	["wh2_dlc12_ikit_workshop_tier_3_1"] = false
};

local workshop_lvl_missions_scripted_listener_default = {
	["wh2_dlc12_ikit_workshop_tier_1_2"] = false,
	["wh2_dlc12_ikit_workshop_tier_2_0"] = false,
	["wh2_dlc12_ikit_workshop_tier_2_1"] = false,
	["wh2_dlc12_ikit_workshop_tier_3_0"] = false,
	["wh2_dlc12_ikit_workshop_tier_3_1"] = false
};

local workshop_lvl_progress = {
	{false, false, false},
	{false, false, false},
	{false, false},
	{}
};
 
local current_workshop_lvl = 1;

local initialized = false;

local script_contexts = { --decides which of the paths the AI should go down
	"cai_faction_script_context_alpha", --doomwheels and doomflayers
	"cai_faction_script_context_beta", --weapons teams
};

local script_context_chosen = "cai_faction_script_context_beta" --fallback in case something goes wrong

cm:add_faction_turn_start_listener_by_name(
	"faction_turn_start_ikit_initialisation",
	ikit_faction,
	function(context)
		check_and_update_rite_details();
	end,
	true
);

function check_and_update_rite_details()
	for i = 1, current_workshop_lvl do
		unlock_rites(i);
	end
end

-- mission control
-- upgrading workshop
core:add_listener(
	"mission_succeeded_ikit_upgrading_workshop",
	"MissionSucceeded",
	function()
		return current_workshop_lvl < #workshop_lvl_missions;
	end,
	function(context)
		for i = 1, #workshop_lvl_missions[current_workshop_lvl] do
			if context:mission():mission_record_key() == workshop_lvl_missions[current_workshop_lvl][i] then
				workshop_lvl_progress[current_workshop_lvl][i] = true;
				cm:disable_event_feed_events(true, "", "wh_event_subcategory_faction_missions_objectives", "");
				cm:callback(function() cm:disable_event_feed_events(false, "", "wh_event_subcategory_faction_missions_objectives", "") end, 1);
			end;
		end;
		
		if check_workshop_upgrade(current_workshop_lvl) then
			core:trigger_event("ScriptEventPlayerWorkshopUpgraded");
			upgrade_workshop();
		end;
	end,
	true
);

function check_workshop_upgrade(lvl)
	if lvl <= #workshop_lvl_progress then
		for i = 1, #workshop_lvl_progress[lvl] do
			if not workshop_lvl_progress[lvl][i] then
				return false;
			end;
		end;
		
		return true;
	end;
end;

function unlock_rites(lvl) 
	if lvl <= #workshop_rite_keys then
		local ikit_faction_interface = cm:model():world():faction_by_key(ikit_faction);
		for i=1, #workshop_rite_keys[lvl] do
			cm:unlock_ritual(ikit_faction_interface, workshop_rite_keys[lvl][i]);
		end
	end
end

function upgrade_workshop()
	local local_faction_name = cm:get_local_faction_name(true);
	current_workshop_lvl = current_workshop_lvl + 1;
	
	unlock_rites(current_workshop_lvl);
	
	cm:callback(function() issue_missions(current_workshop_lvl) end, 0.1);
	
	cm:faction_add_pooled_resource(ikit_faction, reactor_resource_key, reactor_resource_factor_key["add_mission"], workshop_level_reactor_core_reward);
	
	if local_faction_name and local_faction_name == ikit_faction then
		find_uicomponent(core:get_ui_root(), "hud_campaign"):InterfaceFunction("ShowPooledResourceAnimation", reactor_resource_key, workshop_level_reactor_core_reward);
	end
	
	if workshop_upgrade_incidents[current_workshop_lvl] then
		cm:trigger_incident(ikit_faction, workshop_upgrade_incidents[current_workshop_lvl], true);
	end;
end;

function issue_missions(current_workshop_lvl)
	for i = 1, #workshop_level_dummy_effect_bundle do
		cm:remove_effect_bundle(workshop_level_dummy_effect_bundle[i], ikit_faction);
	end;
	
	cm:apply_effect_bundle(workshop_level_dummy_effect_bundle[current_workshop_lvl], ikit_faction, -1);
	
	if cm:get_faction(ikit_faction):is_human() then
		cm:disable_event_feed_events(true, "", "wh_event_subcategory_faction_missions_objectives", "");
		
		for i = 1, #workshop_lvl_missions[current_workshop_lvl] do
			local set_scripted_mission = false;
			
			for j = 1, #workshop_lvl_missions_scripted do
				if workshop_lvl_missions_scripted[j] == workshop_lvl_missions[current_workshop_lvl][i] then
					set_scripted_mission = true;
					
					setup_scripted_mission(workshop_lvl_missions[current_workshop_lvl][i]);
				end;
			end;
			
			if not set_scripted_mission then
				cm:trigger_mission(ikit_faction, workshop_lvl_missions[current_workshop_lvl][i], true);
			end;
		end;
		
		cm:callback(function() cm:disable_event_feed_events(false, "", "wh_event_subcategory_faction_missions_objectives", "") end, 1);
	end;
end;

function setup_scripted_mission(mission_key)
	local mm = mission_manager:new(ikit_faction, mission_key);
	mm:add_new_objective("SCRIPTED");
	mm:add_condition("script_key " .. mission_key);
	mm:add_condition("override_text mission_text_text_wh2_dlc12_objective_override_" .. mission_key);

	mm:add_payload("money 1500");
	mm:set_should_whitelist(false);
	mm:trigger();
	
	setup_scripted_mission_listener(mission_key);
	
	if not workshop_lvl_missions_scripted_listener[mission_key] then
		workshop_lvl_missions_scripted_listener[mission_key] = true;
	end;
end;

function setup_scripted_mission_listener(mission_key)
	for i = 1, #workshop_lvl_missions_scripted do
		if mission_key == workshop_lvl_missions_scripted[i] then
			if i == 2 then
				test_scripted_mission_result(mission_key, engineer_subtype, 15);
			elseif i == 3 then
				test_scripted_mission_result(mission_key, master_engineer_subtype, 15);
			elseif i == 4 then
				test_scripted_mission_result(mission_key, ikit_subtype, 25);
			end;
		end;
	end;
end;

function test_scripted_mission_result(mission_key, subtype, rank)
	local mission_completed = false;
	local faction = cm:get_faction(ikit_faction);
	local char_list = faction:character_list()
	
	for i = 0, char_list:num_items() - 1 do
		local current_char = char_list:item_at(i);
		if current_char:rank() >= rank and current_char:character_subtype_key() == subtype then
			mission_completed = true;
		end;
	end;
	
	if mission_completed then
		cm:complete_scripted_mission_objective(ikit_faction, mission_key, mission_key, true);
		workshop_lvl_missions_scripted_listener[mission_key] = false;
	else
		core:add_listener(
			mission_key,
			"CharacterRankUp", 
			function(context)
				local character = context:character();
				
				return character:faction():name() == ikit_faction and character:character_subtype_key() == subtype and character:rank() >= rank;
			end,
			function()
				cm:complete_scripted_mission_objective(ikit_faction, mission_key, mission_key, true);
				workshop_lvl_missions_scripted_listener[mission_key] = false;
			end,
			false
		);
	end;
end;

-- nuke control
-- producing nuke
core:add_listener(
	"ritual_started_ikit_producing_nuke",
	"RitualStartedEvent",
	function(context)
		return context:ritual():ritual_key() == nuke_rite_key;
	end,
	function()
		cm:faction_add_pooled_resource(ikit_faction, nuke_resource_key, nuke_resource_factor_key["add"], 1);
		
		if workshop_rite_details[workshop_nuke_rite_keys[5]].researched and additional_nuke_chance > cm:random_number(100) then
			cm:faction_add_pooled_resource(ikit_faction, nuke_resource_key, nuke_resource_factor_key["add"], 1);
		end;
		
		updated_nuke_functions_based_on_nuke_resource();
	end,
	true
);

-- reducing nuke
core:add_listener(
	"battle_completed_ikit_reducing_nuke",
	"BattleCompleted",
	function(context)
		local pb = cm:model():pending_battle();
		return pb:has_been_fought() and cm:pending_battle_cache_faction_is_involved(ikit_faction) and (pb:get_how_many_times_ability_has_been_used_in_battle(ikit_faction_cqi, nuke_ability_key) > 0 or pb:get_how_many_times_ability_has_been_used_in_battle(ikit_faction_cqi, nuke_ability_upgrade_key) > 0);
	end,
	function()
		cm:faction_add_pooled_resource(ikit_faction, nuke_resource_key, nuke_resource_factor_key["negative"], -1);
		updated_nuke_functions_based_on_nuke_resource();
		
		--checking scripted missions
		if workshop_lvl_missions_scripted_listener[workshop_lvl_missions_scripted[1]] then
			cm:complete_scripted_mission_objective(ikit_faction, workshop_lvl_missions_scripted[1], workshop_lvl_missions_scripted[1], true);
			workshop_lvl_missions_scripted_listener[workshop_lvl_missions_scripted[1]] = false;
		end;
		
		--checking if nuke parts researched, additional reward
		if workshop_rite_details[workshop_nuke_rite_keys[3]].researched then
			cm:faction_add_pooled_resource(ikit_faction, reactor_resource_key, reactor_resource_factor_key["add"], 1);
		end;
		
		--checking if nuke parts researched, additional replenish
		if workshop_rite_details[workshop_nuke_rite_keys[4]].researched then
			if cm:pending_battle_cache_num_attackers() >= 1 then
				for i = 1, cm:pending_battle_cache_num_attackers() do
					local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_attacker(i);
					local character = cm:get_character_by_cqi(this_char_cqi);
					
					if character and character:faction():name() == ikit_faction then
						cm:apply_effect_bundle_to_characters_force(nuke_replenish_effect_bundle, this_char_cqi, 5);
					end;
				end;
			end;
			
			if cm:pending_battle_cache_num_defenders() >= 1 then
				for i = 1, cm:pending_battle_cache_num_defenders() do
					local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_defender(i);
					local character = cm:get_character_by_cqi(this_char_cqi);
					
					if character and character:faction():name() == ikit_faction then
						cm:apply_effect_bundle_to_characters_force(nuke_replenish_effect_bundle, this_char_cqi, 5);
					end;
				end;
			end;
		end;
		
		local ikit_pooled_resource_manager = cm:get_faction(ikit_faction):pooled_resource_manager();
		
		if ikit_pooled_resource_manager:resource(nuke_resource_key):value() == 0 and ikit_pooled_resource_manager:resource(reactor_resource_key):value() > 3 then
			core:trigger_event("ScriptEventPlayerNukeReadyToBuy");
		end;
	end,
	true
);

-- controlling nuke and rite availability
function updated_nuke_functions_based_on_nuke_resource()
	local ikit_faction_interface = cm:model():world():faction_by_key(ikit_faction);
	local nuke_resource          = ikit_faction_interface:pooled_resource_manager():resource(nuke_resource_key);
	local nuke_resource_amount   = nuke_resource:value();

	if nuke_resource_amount == 0 then
		--nuke is 0 and remove effect bundle
		cm:remove_effect_bundle(nuke_effect_bundle_key[1], ikit_faction);
		
		if workshop_rite_details[workshop_nuke_rite_keys[6]].researched then
			cm:remove_effect_bundle(nuke_effect_bundle_key[2], ikit_faction);
		end;
	else
		-- nuke is higher than 0 and apply effect bundle
		cm:apply_effect_bundle(nuke_effect_bundle_key[1], ikit_faction, 0);
		
		if workshop_rite_details[workshop_nuke_rite_keys[6]].researched then
			cm:remove_effect_bundle(nuke_effect_bundle_key[1], ikit_faction);
			cm:apply_effect_bundle(nuke_effect_bundle_key[2], ikit_faction, 0);
		end

		if nuke_resource_amount == nuke_resource:maximum_value() then
			--nuke is max
			--lock rite
			cm:lock_ritual(ikit_faction_interface, nuke_rite_key);
		else 
			cm:unlock_ritual(ikit_faction_interface, nuke_rite_key);
		end
	end
end

-- progress reward
core:add_listener(
	"ritual_completed_ikit_progress_reward",
	"RitualCompletedEvent",
	function(context)
		return workshop_rite_details[context:ritual():ritual_key()];
	end,
	function(context)
		--check if that's the proper rite
		local faction = context:performing_faction();
		local ritual = context:ritual();
		local ritual_key = ritual:ritual_key();
		if workshop_rite_details[ritual_key] ~= nil then
			local rite_details = workshop_rite_details[ritual_key];

			rite_details.researched = true;
			updated_nuke_functions_based_on_nuke_resource();
			if workshop_category_progress[rite_details.category] ~= nil then
				workshop_category_progress[rite_details.category] = workshop_category_progress[rite_details.category]+1;
				local total_count = 0;
				--intervention events--
				for key, value in pairs(workshop_category_keys) do
					total_count = total_count + workshop_category_progress[value];
				end

				if total_count >= 5 then
					core:trigger_event("ScriptEventPlayer5WorkshopUpgrades");
				elseif total_count >= 2 then
					core:trigger_event("ScriptEventPlayer2WorkshopUpgrades");
				end 
				if ritual_key == workshop_nuke_rite_keys[2] then
					--increase stockpile
					nuke_limit = nuke_limit_improved;
				end
				if ritual_key == workshop_nuke_rite_keys[6] then
					updated_nuke_functions_based_on_nuke_resource();
				end
				
				local category_rewards = workshop_category_detail[rite_details.category].rewards;
				local category_progress = workshop_category_progress[rite_details.category];
				local reward = category_rewards[category_progress];

				if reward ~= nil then
					local reward_found = false;
					if reward.ancillary ~= nil then
						reward_found = true;

						--give ancillary
						out("Ikit Workshop: Unlocking ancillary " .. reward.ancillary);
						cm:add_ancillary_to_faction(faction, reward.ancillary, false);
					end
					if reward.unit ~= nil then
						reward_found = true;

						--give unit
						out("Ikit Workshop: Unlocking unit " .. reward.unit);
						cm:remove_event_restricted_unit_record_for_faction(reward.unit, ikit_faction);
						cm:trigger_incident(ikit_faction, reward.unit, true);
					end

					if not reward_found then
						script_error(string.format("Ikit Workshop upgrades of category '%s' had a reward item unlocked at workshop progress '%i', but this category had no reward type of the expected keys. An 'ancillary' or 'unit' is needed as a reward.",
							rite_details.category, category_progress));
					end
				end
			end
		end
	end,
	true
);


-- reactor core control
-- post battle loot
core:add_listener(
	"battle_completed_ikit_post_battle_loot",
	"BattleCompleted",
	function()
		return cm:pending_battle_cache_faction_is_involved(ikit_faction);
	end,
	function(context)
		local engineers_in_battle = {
			[ikit_subtype] = {},
			[master_engineer_subtype] = {}
		};
		
		if cm:pending_battle_cache_num_attackers() >= 1 then
			for i = 1, cm:pending_battle_cache_num_attackers() do
				local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_attacker(i);
				local character = cm:get_character_by_cqi(this_char_cqi);
				
				if character then
					local subtype = character:character_subtype_key();
					
					if character:faction():name() == ikit_faction and character:won_battle() and (subtype == ikit_subtype or subtype == master_engineer_subtype) then
						table.insert(engineers_in_battle[subtype], this_char_cqi);
					end;
				end;
			end;
		end;
		
		if cm:pending_battle_cache_num_defenders() >= 1 then
			for i = 1, cm:pending_battle_cache_num_defenders() do
				local this_char_cqi, this_mf_cqi, current_faction_name = cm:pending_battle_cache_get_defender(i);
				local character = cm:get_character_by_cqi(this_char_cqi);
				
				if character then
					local subtype = character:character_subtype_key();
					
					if character and character:faction():name() == ikit_faction and character:won_battle() and (subtype == ikit_subtype or subtype == master_engineer_subtype) then
						table.insert(engineers_in_battle[subtype], this_char_cqi);
					end;
				end;
			end;
		end;
		
		-- generate loot tables and check skills and other factors that affects loot chance
		local loot_rolls_ikit = {};
		local loot_rolls_master_engineer = {};
		local loot_rolls_extra = {};
		
		for i = 1, #engineers_in_battle[ikit_subtype] do
			table.insert(loot_rolls_ikit, reactor_add_chances[ikit_subtype]);
			
			if cm:get_character_by_cqi(engineers_in_battle[ikit_subtype][i]):has_skill("wh2_dlc12_skill_skv_ikit_unique_2") then
				table.insert(loot_rolls_extra, reactor_add_chances["extra_loot"]);
			end;
		end;
		
		for i = 1, #engineers_in_battle[master_engineer_subtype] do
			table.insert(loot_rolls_master_engineer, reactor_add_chances[master_engineer_subtype]);
		end;
		
		-- process loot
		process_reactor_loot_rolls(#loot_rolls_ikit, ikit_subtype);
		process_reactor_loot_rolls(#loot_rolls_master_engineer, master_engineer_subtype);
		process_reactor_loot_rolls(#loot_rolls_extra, "extra_loot");
	end,
	true
);

function process_reactor_loot_rolls(loot_rolls, index)
	local local_faction_name = cm:get_local_faction_name(true);
	
	for i = 1, loot_rolls do
		if reactor_add_chances[index][1] * (reactor_add_chances[index][3] + 1) > cm:random_number(100) then
			if index == engineer_subtype then
				cm:faction_add_pooled_resource(ikit_faction, reactor_resource_key, reactor_resource_factor_key["add_alt"], reactor_add_chances[index][2]);
				
				if local_faction_name and local_faction_name == ikit_faction then
					find_uicomponent(core:get_ui_root(), "hud_campaign"):InterfaceFunction("ShowPooledResourceAnimation", reactor_resource_key, reactor_add_chances[index][2]);
				end
			else
				cm:faction_add_pooled_resource(ikit_faction, reactor_resource_key, reactor_resource_factor_key["add"], reactor_add_chances[index][2]);
				
				if local_faction_name and local_faction_name == ikit_faction then
					find_uicomponent(core:get_ui_root(), "hud_campaign"):InterfaceFunction("ShowPooledResourceAnimation", reactor_resource_key, reactor_add_chances[index][2]);
				end;
			end;
			
			if local_faction_name and local_faction_name == ikit_faction then
				find_uicomponent(core:get_ui_root(), "cores_icon"):TriggerAnimation("play");
			end;
			
			reactor_add_chances[index][3] = 0; 
		else
			reactor_add_chances[index][3] = reactor_add_chances[index][3] + 1;
		end;
	end;
end;

-- agent action loot
core:add_listener(
	"character_character_target_action_ikit_agent_action_loot",
	"CharacterCharacterTargetAction",
	function(context)
		local character = context:character();
		return (context:mission_result_critial_success() or context:mission_result_success()) and character:character_subtype_key() == engineer_subtype and character:faction():name() == ikit_faction and context:target_character():faction():name() ~= ikit_faction;
	end,
	function()
		process_reactor_loot_rolls(1, engineer_subtype);
	end,
	true
);

core:add_listener(
	"character_garrison_target_action_ikit_agent_action_loot",
	"CharacterGarrisonTargetAction",
	function(context)
		local character = context:character();
		return (context:mission_result_critial_success() or context:mission_result_success()) and character:character_subtype_key() == engineer_subtype and character:faction():name() == ikit_faction;
	end,
	function()
		process_reactor_loot_rolls(1, engineer_subtype);
	end,
	true
);

-- New game initialisation, as well as loading a saved game, are handled here.
function initialize_workshop_listeners()
	local ikit_faction_interface = cm:get_faction(ikit_faction);
	ikit_faction_cqi = ikit_faction_interface:command_queue_index();

	if not ikit_faction_interface:is_human() then --Bypasses the mission unlock requirements for the AI and picks one of the two script contexts
		current_workshop_lvl = 4
		if cm:is_new_game() == true then 
			local r_num = cm:random_number(#script_contexts);
			script_context_chosen = script_contexts[r_num];
		end
	end
	cm:cai_set_faction_script_context(ikit_faction, script_context_chosen);
	out.design("============== This faction: "..ikit_faction.." is now using this context: "..cm:cai_get_faction_script_context(ikit_faction)..", defining AI behaviour for faction feature ==============");
	
	check_and_update_rite_details();

	if not initialized then
		issue_missions(current_workshop_lvl);
		initialized = true;
		unlock_rites(1);
		updated_nuke_functions_based_on_nuke_resource();
		
		-- This is pretty much the only time we need to worry about the order of traversal with Workshop rewards, so we sort the units alphabetically before
		-- sending them to the game model to ensure we don't get desynchs.
		local units_to_unlock = {};
		for key, value in pairs(workshop_category_detail) do
			for reward_key, reward_table in pairs(value.rewards) do
				if reward_table.unit ~= nil then
					table.insert(units_to_unlock, reward_table.unit);
				end
			end
		end
		table.sort(units_to_unlock);
		for u = 1, #units_to_unlock do
			out(units_to_unlock[u]);
			cm:add_event_restricted_unit_record_for_faction(units_to_unlock[u], ikit_faction);
		end
	end;
	
	for i = 1, #workshop_lvl_missions_scripted do
		if workshop_lvl_missions_scripted_listener[workshop_lvl_missions_scripted[i]] then
			setup_scripted_mission_listener(workshop_lvl_missions_scripted[i]);
		end;
	end;
end;

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("workshop_lvl_missions_scripted_listener", workshop_lvl_missions_scripted_listener, context);
		cm:save_named_value("workshop_lvl_progress", workshop_lvl_progress, context);
		cm:save_named_value("current_workshop_lvl", current_workshop_lvl, context);
		cm:save_named_value("nuke_limit", nuke_limit, context);
		cm:save_named_value("workshop_category_progress", workshop_category_progress, context);
		cm:save_named_value("initialized", initialized, context);
		cm:save_named_value("nuke_drop_chance_current", nuke_drop_chance_current, context);
		cm:save_named_value("reactor_add_chances", reactor_add_chances, context);
		cm:save_named_value("workshop_rite_details", workshop_rite_details, context);
		cm:save_named_value("ikit_script_context", script_context_chosen, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			workshop_lvl_missions_scripted_listener = cm:load_named_value("workshop_lvl_missions_scripted_listener", workshop_lvl_missions_scripted_listener_default, context);
			workshop_lvl_progress = cm:load_named_value("workshop_lvl_progress", workshop_lvl_progress, context);
			current_workshop_lvl = cm:load_named_value("current_workshop_lvl", 1, context);
			nuke_limit = cm:load_named_value("nuke_limit", nuke_limit_default, context);
			workshop_category_progress = cm:load_named_value("workshop_category_progress", workshop_category_progress, context);
			initialized = cm:load_named_value("initialized", false, context);
			nuke_drop_chance_current = cm:load_named_value("nuke_drop_chance_current", 0, context);
			workshop_rite_details = cm:load_named_value("workshop_rite_details", workshop_rite_details, context);
			script_context_chosen = cm:load_named_value("ikit_script_context", script_context_chosen, context);
		end;
	end
);