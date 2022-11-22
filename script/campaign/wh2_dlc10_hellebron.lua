death_night = {
	faction_key = "wh2_main_def_har_ganeth",
	ulthuan_defender_key = "wh2_main_hef_avelorn",
	har_ganeth_key = "wh3_main_combi_region_har_ganeth",

	resource_cap = 25,
	current_resource = 20,

	slave_resource_key = "def_slaves",
	slave_resource_factor = "rites",

	current_level = 0,
	min_level_missions = {},
	mortathi_text = "wh2_dlc10_death_night_lock_morathi",
	alarielle_text = "wh2_dlc10_death_night_lock_alarielle",
	mission_config = {
		morathi = {
			mission_key = "wh2_dlc10_death_night_morathi_mission", 
			event_key = "ScriptEventDeathMorathiDefeated",
			objective = "CAPTURE_REGIONS",
			issuer = "CLAN_ELDERS",
			conditions = {
				"region wh3_main_combi_region_ancient_city_of_quintex",
				"ignore_allies"
			},
			payloads = {
				"effect_bundle{bundle_key wh2_dlc10_bundle_death_night_morathi;turns 0;}",
				"effect_bundle{bundle_key wh2_dlc10_bundle_death_night_morathi_untainted;turns 20;}"
			}
		},
		alarielle = {
			mission_key = "wh2_dlc10_death_night_alarielle_mission", 
			event_key = "ScriptEventDeathAlarielleDefeated",
			objective = "CAPTURE_REGIONS",
			issuer = "CLAN_ELDERS",
			conditions = {
				"region wh3_main_combi_region_gaean_vale",
				"ignore_allies"
			},
			payloads = {
				"effect_bundle{bundle_key wh2_dlc10_bundle_death_night_alarielle;turns 0;}"
			}
		}
	},

	level_effects = {
		"wh2_dlc10_death_night_effect_1",
		"wh2_dlc10_death_night_effect_2",
		"wh2_dlc10_death_night_effect_3",
		"wh2_dlc10_death_night_effect_4",
		"wh2_dlc10_death_night_effect_5"
	},
	missions_launched = false,

	cost = {
		current = 500,
		increase = 50,
		cap = 1000
	},

	triggered_this_turn = false,

	slaves_freed = false;

	blood_voyage = {
		faction_key = "wh2_dlc10_def_blood_voyage",
		
		base_loot_value = 1000,
		gathered_loot_value = 0,

		active = false,
		cooldown = 25,

		spawn_pos= {x = 229, y = 816},

		warning_region = "wh3_main_combi_region_sea_of_malice", -- Made visible when warning other factions of an incoming Blood Voyage.

		current_target = "",
		possible_targets = {
			-- OUTER
			["wh3_main_combi_region_lothern"] = true,
			["wh3_main_combi_region_vauls_anvil_ulthuan"] = true,
			["wh3_main_combi_region_tor_sethai"] = true,
			["wh3_main_combi_region_whitepeak"] = true,
			["wh3_main_combi_region_tor_anroc"] = true,
			["wh3_main_combi_region_tor_dranil"] = true,
			["wh3_main_combi_region_tor_anlec"] = true,
			["wh3_main_combi_region_shrine_of_khaine"] = true,
			["wh3_main_combi_region_tor_achare"] = true,
			["wh3_main_combi_region_elisia"] = true,
			["wh3_main_combi_region_mistnar"] = true,
			["wh3_main_combi_region_tor_koruali"] = true,
			["wh3_main_combi_region_tor_yvresse"] = true,
			["wh3_main_combi_region_elessaeli"] = true,
			-- INNER
			["wh3_main_combi_region_tower_of_lysean"] = true,
			["wh3_main_combi_region_tor_elyr"] = true,
			["wh3_main_combi_region_eagle_gate"] = true,
			["wh3_main_combi_region_whitefire_tor"] = true,
			["wh3_main_combi_region_griffon_gate"] = true,
			["wh3_main_combi_region_evershale"] = true,
			["wh3_main_combi_region_unicorn_gate"] = true,
			["wh3_main_combi_region_phoenix_gate"] = true,
			["wh3_main_combi_region_tor_saroir"] = true,
			["wh3_main_combi_region_gaean_vale"] = true,
			["wh3_main_combi_region_tor_finu"] = true,
			["wh3_main_combi_region_white_tower_of_hoeth"] = true,
			["wh3_main_combi_region_port_elistor"] = true,
			["wh3_main_combi_region_angerrial"] = true,
			["wh3_main_combi_region_shrine_of_asuryan"] = true
		}
	},
	
	vfx_key = "scripted_effect6",

	army_key_1 = "death_night_army_1",
	army_key_2 = "death_night_army_2",
	army_key_player = "death_night_army_player"
}

function death_night:add_hellebron_listeners()
	out("#### Adding Hellebron Listeners ####")
	local hellebron = cm:get_faction(self.faction_key)
	local alarielle = cm:get_faction(self.ulthuan_defender_key)
	
	if hellebron:is_human() == true then
		local bv_faction = cm:get_faction(self.blood_voyage.faction_key)

		self:trigger_death_night_listener()
		self:turn_start_updates()
		self:mission_rewards()
		self:gather_loot()
		self:update_ui()
		
	elseif alarielle:is_human() == true then
		self:ai_turn_start_updates()
	end
	
	self:setup_army()
end

function death_night:trigger_death_night()
	local slaves_capped = false;
	local bv_faction = cm:get_faction(self.blood_voyage.faction_key)
	local faction = cm:get_faction(self.faction_key)
	
	self.triggered_this_turn = true;
	self.current_resource = self.resource_cap;
	
	-- Remove the slave cost from the factions slave pool
	cm:faction_add_pooled_resource(self.faction_key, self.slave_resource_key, self.slave_resource_factor, -self.cost.current);
	self.cost.current = self.cost.current + self.cost.increase;
	
	if self.cost.current > self.cost.cap then
		self.cost.current = self.cost.cap;
		slaves_capped = true;
	end
	
	if bv_faction ~= false then
		self:apply_effects(bv_faction);
	end
	
	self:apply_effects(faction);
	self:update_ui();
	self:trigger_incident(faction, slaves_capped);
end

function death_night:trigger_incident(faction, slaves_capped)
	local har_ganeth = cm:get_region(self.har_ganeth_key);
	local garrison_residence_cqi = har_ganeth:garrison_residence():command_queue_index();
	local local_faction = cm:get_local_faction_name(true);
	local death_night_event_key = "wh2_dlc10_incident_def_death_night"; -- Trigger an event for the owner of Death Night

	if self.blood_voyage.active == true then
		death_night_event_key = death_night_event_key.."_no_voyage";
	end
	if slaves_capped == true then
		death_night_event_key = death_night_event_key.."_no_slaves";
	end
	
	cm:add_garrison_residence_vfx(garrison_residence_cqi, self.vfx_key, true);
	
	cm:trigger_incident_with_targets(faction:command_queue_index(), death_night_event_key, 0, 0, 0, 0, har_ganeth:cqi(), har_ganeth:settlement():cqi());

	core:trigger_event("ScriptEventDeathNightTriggered");
end

function death_night:blood_voyage_update()
	local turn_number = cm:turn_number();
	local unit_list, blood_voyage_inv
	local faction = cm:get_faction(self.faction_key);
	local hellebron = faction:faction_leader();
	local ulthuan_target, ulthuan_target_faction, human_high_elves = self:generate_ulthuan_target();
	local force_player_blood_voyage = false; -- Debug
	
	if turn_number <= 30 then
		unit_list = random_army_manager:generate_force(self.army_key_1);
	else
		unit_list = random_army_manager:generate_force(self.army_key_2, 19);
	end

	local spawn_x, spawn_y = death_night:get_blood_voyage_spawn();
	local spawn = nil;
	if spawn_x ~= nil then
		spawn = { x = spawn_x, y = spawn_y };
	else
		spawn = self.spawn_pos;
	end

	blood_voyage_inv = invasion_manager:new_invasion("blood_voyage_inv_"..turn_number, self.blood_voyage.faction_key, unit_list, spawn);
	if ulthuan_target then
		blood_voyage_inv:set_target("REGION", ulthuan_target, ulthuan_target_faction);
		self.blood_voyage.current_target = ulthuan_target_faction;
	end

	if not faction:is_human() then
		local difficulty = cm:get_difficulty(true);

		if difficulty == "very hard" then
			blood_voyage_inv:add_unit_experience(1);
		elseif difficulty == "legendary" then
			blood_voyage_inv:add_unit_experience(3);
		end
	end
	
	if hellebron and hellebron:is_null_interface() == false and hellebron:has_skill("wh2_dlc10_skill_def_crone_unique_blood_queen") == true then
		blood_voyage_inv:add_unit_experience(3);
	end
	
	blood_voyage_inv:apply_effect("wh2_dlc10_bundle_blood_voyage", 0);
	
	blood_voyage_inv:abort_on_target_owner_change(true);
	blood_voyage_inv:start_invasion(
		function(self)
			local force_leader = self:get_general();
			
			death_night.blood_voyage.active = true;
			death_night.blood_voyage.gathered_loot_value = 300 + cm:random_number(600);
			
			cm:force_make_vassal(death_night.faction_key, death_night.blood_voyage.faction_key);
			cm:add_character_vfx(force_leader:command_queue_index(), death_night.vfx_key, false);
		end,
		true, 
		false, 
		false
	);

	core:trigger_event("ScriptEventDeathBloodVoyage");
	cm:force_diplomacy("all", "faction:"..self.blood_voyage.faction_key, "all", false, false, true);
	cm:force_diplomacy("faction:"..self.faction_key, "faction:"..self.blood_voyage.faction_key, "join war", true, true, false);
	cm:force_diplomacy("all", "faction:"..self.blood_voyage.faction_key, "war", true, true, false);
	cm:force_diplomacy("faction:"..self.faction_key, "faction:"..self.blood_voyage.faction_key, "war", false, false, true);

	if (faction:is_null_interface() == false) then
		cm:show_message_event_located(
			faction:name(),
			"event_feed_strings_text_wh_dlc10_event_feed_string_scripted_event_blood_voyage_title",
			"event_feed_strings_text_wh_dlc10_event_feed_string_scripted_event_blood_voyage_primary_detail",
			"event_feed_strings_text_wh_dlc10_event_feed_string_scripted_event_blood_voyage_secondary_detail",
			spawn.x,
			spawn.y,
			true,
			1011
		);
	end
	
	for elf, value in pairs(human_high_elves) do
		if value then
			self:trigger_warning_event(elf);
		end
	end
	
	cm:apply_effect_bundle("wh2_dlc10_bundle_blood_voyage_active", self.ulthuan_defender_key, 0);
end

-- Get the sea location nearest the Hellebron faction's home region (which is probably, but not necessarily, Har Ganeth).
function death_night:get_blood_voyage_spawn()
	local blood_voyage_faction = cm:get_faction(self.faction_key);

	if not blood_voyage_faction:has_home_region() then
		out(string.format("WARNING: Cannot create blood voyage for faction '%s' as it has no home region.", self.faction_key));
		return nil;
	end

	local home_settlement = blood_voyage_faction:home_region():settlement();
	local home_x, home_y = home_settlement:logical_position_x(), home_settlement:logical_position_y();

	local spawn_x, spawn_y;
	local spawn_region_key = home_settlement:region():name();
	spawn_x, spawn_y = cm:find_nearest_standable_position(home_x, home_y, false);
	
	if spawn_x == -1 then
		script_error(string.format("ERROR: Was unable to find a valid spawn point for blood voyage for faction '%s', near settlement '%s'.", self.faction_key, spawn_region_key));
		return nil;
	end
	
	return spawn_x, spawn_y;
end

function death_night:generate_ulthuan_target()
	local possible_targets = {};
	local human_high_elves = {};
	
	for region_key, value in pairs(self.blood_voyage.possible_targets) do
		local region = cm:get_region(region_key);
		
		if region:is_abandoned() == false and region:owning_faction():culture() == "wh2_main_hef_high_elves" then
			table.insert(possible_targets, region);
			
			if region:owning_faction():is_human() == true then
				human_high_elves[region:owning_faction():name()] = true;
			end
		end
	end
	
	if #possible_targets > 0 then
		local har_ganeth = cm:get_region(self.har_ganeth_key);
		
		local hgx = har_ganeth:settlement():logical_position_x();
		local hgy = har_ganeth:settlement():logical_position_y();
		local target = nil;
		local closest = 999999;
		
		for i = 1, #possible_targets do
			local possible_target = possible_targets[i];
			local x = possible_target:settlement():logical_position_x();
			local y = possible_target:settlement():logical_position_y();
			local distance = distance_squared(x, y, hgx, hgy);
			
			if distance <= closest then
				target = possible_target;
				closest = distance;
			end
		end
		
		if target ~= nil then
			return target:name(), target:owning_faction():name(), human_high_elves;
		end
	end

	return nil, nil, human_high_elves;
end

function death_night:gather_loot()
	core:add_listener(
		"blood_voyage_battle_completed",
		"CharacterCompletedBattle",
		true,
		function(context)
			local character = context:character();
			local faction = character:faction();
			
			if faction:name() == self.blood_voyage.faction_key and character:won_battle() == true then
				out.design("Blood Voyage: Increasing Loot!");
				self.blood_voyage.gathered_loot_value = self.blood_voyage.gathered_loot_value + self.blood_voyage.base_loot_value + cm:random_number(self.blood_voyage.base_loot_value);
			end
		end,
		true
	);
end

function death_night:apply_effects(faction)
	local faction_key = faction:name()
	local bar_effect = "";
	local percent = self.current_resource / self.resource_cap;
	local lock_percent = self.current_level * 0.2;
	
	if percent < lock_percent then
		percent = lock_percent;
	end
	
	if percent >= 0.8 then
		bar_effect = self.level_effects[5];
	elseif percent >= 0.6 then
		bar_effect = self.level_effects[4];
	elseif percent >= 0.4 then
		bar_effect = self.level_effects[3];
		core:trigger_event("ScriptEventDeathNightLevel3");
	elseif percent >= 0.2 then
		bar_effect = self.level_effects[2];
	else
		bar_effect = self.level_effects[1];
		core:trigger_event("ScriptEventDeathNightLevel1");
		
		if self.slaves_freed == false and faction:is_human() == true then
			cm:trigger_incident(self.faction_key, "wh2_dlc10_death_night_free_slave", true);
			self.slaves_freed = true;
		end
	end
	
	out.design("\tCurrent death night level: "..bar_effect.." ("..tostring(percent * 100)..")");
	
	if faction:has_effect_bundle(bar_effect) then
		return;
	end
	
	for _, effect_bundle in ipairs(self.level_effects) do
		if faction:has_effect_bundle(effect_bundle) then
			cm:remove_effect_bundle(effect_bundle, faction_key);
		end
	end
	
	cm:apply_effect_bundle(bar_effect, faction_key, 0);
end

function death_night:update_ui()
	local local_faction = cm:get_local_faction_name(true);
	
	if local_faction == self.faction_key then
		local ui_root = core:get_ui_root();
		local death_night_holder = find_uicomponent(ui_root, "death_night_holder");
		
		if death_night_holder and death_night_holder:Visible() == true then
			local percent = self.current_resource / self.resource_cap;
			local lock_percent = self.current_level * 0.2;
			
			if percent < lock_percent then
				percent = lock_percent;
			end
			
			out.design("\tSetBarLevel: "..tostring(percent).." ("..self.current_resource..")");
			death_night_holder:InterfaceFunction("SetBarLevel", percent);
			
			out.design("\tSetBarLock: "..tostring(self.current_level));
			if self.current_level > 0 then
				death_night_holder:InterfaceFunction("SetBarLock", self.current_level, table.unpack(self.min_level_missions));
			else
				death_night_holder:InterfaceFunction("SetBarLock", 0);
			end
			
			local death_night_button = find_uicomponent(death_night_holder, "death_night_button");
			
			if death_night_button and death_night_button:Visible() == true then
				out.design("\tSetProperty - slaves_needed: "..tostring(self.cost.current));
				cm:set_script_state("death_night_slave_requirement", self.cost.current)
				
				if self.triggered_this_turn == true then
					-- Death Night was triggered this turn
					out.design("\tSetStateFlag - inactive_used");
					death_night_holder:InterfaceFunction("SetStateFlag", "inactive_used");
				else
					out.design("\tSetStateFlag - active");
					death_night_holder:InterfaceFunction("SetStateFlag", "active");
				end
			end
		end
	end
end

function death_night:setup_army()
	-- First army spawned by Death Night
	random_army_manager:new_force(self.army_key_1);
	
	random_army_manager:add_mandatory_unit(self.army_key_1, "wh2_main_def_inf_har_ganeth_executioners_0", 2);
	random_army_manager:add_mandatory_unit(self.army_key_1, "wh2_dlc10_def_inf_sisters_of_slaughter", 2);
	random_army_manager:add_mandatory_unit(self.army_key_1, "wh2_main_def_cav_cold_one_knights_1", 2);
	random_army_manager:add_mandatory_unit(self.army_key_1, "wh2_main_def_mon_black_dragon", 1);
	random_army_manager:add_mandatory_unit(self.army_key_1, "wh2_main_def_mon_war_hydra", 1);
	random_army_manager:add_mandatory_unit(self.army_key_1, "wh2_main_def_inf_bleakswords_0", 4);
	random_army_manager:add_mandatory_unit(self.army_key_1, "wh2_main_def_inf_dreadspears_0", 4);
	random_army_manager:add_mandatory_unit(self.army_key_1, "wh2_main_def_inf_witch_elves_0", 2);
	
	-- Any army spawned after the first Death Night
	random_army_manager:new_force(self.army_key_2);
	
	random_army_manager:add_mandatory_unit(self.army_key_2, "wh2_main_def_inf_har_ganeth_executioners_0", 4);
	random_army_manager:add_mandatory_unit(self.army_key_2, "wh2_dlc10_def_inf_sisters_of_slaughter", 4);
	random_army_manager:add_mandatory_unit(self.army_key_2, "wh2_main_def_cav_cold_one_knights_1", 2);
	random_army_manager:add_mandatory_unit(self.army_key_2, "wh2_main_def_inf_witch_elves_0", 5);
	random_army_manager:add_mandatory_unit(self.army_key_2, "wh2_main_def_mon_war_hydra", 1);
	
	random_army_manager:add_unit(self.army_key_2, "wh2_main_def_mon_black_dragon", 1);
	random_army_manager:add_unit(self.army_key_2, "wh2_main_def_mon_war_hydra", 1);
	random_army_manager:add_unit(self.army_key_2, "wh2_main_def_inf_bleakswords_0", 2);
	random_army_manager:add_unit(self.army_key_2, "wh2_main_def_inf_shades_1", 2);
	random_army_manager:add_unit(self.army_key_2, "wh2_main_def_inf_black_guard_0", 2);
	
	-- Player controlled army
	random_army_manager:new_force(self.army_key_player);
	
	random_army_manager:add_mandatory_unit(self.army_key_player, "wh2_dlc10_def_inf_sisters_of_slaughter", 4);
	random_army_manager:add_mandatory_unit(self.army_key_player, "wh2_main_def_cav_cold_one_knights_1", 2);
	random_army_manager:add_mandatory_unit(self.army_key_player, "wh2_main_def_mon_black_dragon", 1);
	random_army_manager:add_mandatory_unit(self.army_key_player, "wh2_main_def_mon_war_hydra", 1);
	random_army_manager:add_mandatory_unit(self.army_key_player, "wh2_main_def_inf_bleakswords_0", 5);
	random_army_manager:add_mandatory_unit(self.army_key_player, "wh2_main_def_inf_dreadspears_0", 4);
	random_army_manager:add_mandatory_unit(self.army_key_player, "wh2_main_def_inf_witch_elves_0", 2);
end

function death_night:trigger_warning_event(faction_name)
	cm:add_faction_turn_start_listener_by_name(
		"blood_voyage_warning_event",
		faction_name,
		function(context)
			local blood_voyage_fac = cm:get_faction(self.blood_voyage.faction_key);
			local blood_voyage_leader = blood_voyage_fac:faction_leader();
			local bx = blood_voyage_leader:logical_position_x();
			local by = blood_voyage_leader:logical_position_y();
			local bdx = blood_voyage_leader:display_position_x();
			local bdy = blood_voyage_leader:display_position_y();
			local local_faction = cm:get_local_faction_name(true);
		
			cm:show_message_event_located(
				context:faction():name(),
				"event_feed_strings_text_wh_dlc10_event_feed_string_scripted_event_blood_voyage_target_title",
				"event_feed_strings_text_wh_dlc10_event_feed_string_scripted_event_blood_voyage_target_primary_detail",
				"event_feed_strings_text_wh_dlc10_event_feed_string_scripted_event_blood_voyage_target_secondary_detail",
				bx,
				by,
				true,
				1015
			);
			
			cm:make_region_visible_in_shroud(context:faction():name(), self.blood_voyage.warning_region);
			
			if local_faction == context:faction():name() then
				cm:scroll_camera_from_current(true, 3, {bdx, bdy, 10.5, 0.0, 6.8});
			end
		end,
		false
	);
end

function death_night:mission_rewards()
	core:add_listener(
		"death_night:mission_rewards",
		"MissionSucceeded",
		function(context)
			return context:faction():name() == self.faction_key;
		end,
		function(context)
			local mission_key = context:mission():mission_record_key();
	
			if mission_key == self.mission_config.morathi.mission_key then
				self.current_level = self.current_level + 1;
				table.insert(self.min_level_missions, self.mortathi_text);
				core:trigger_event(self.mission_config.morathi.event_key);
			elseif mission_key == self.mission_config.alarielle.mission_key then
				self.current_level = self.current_level + 1;
				table.insert(self.min_level_missions, self.alarielle_text);
				core:trigger_event(self.mission_config.alarielle.event_key);
			end
			
			self:apply_effects(context:faction());

			local bv_faction = cm:get_faction(self.blood_voyage.faction_key);
			if bv_faction then
				self:apply_effects(bv_faction);
			end

			self:update_ui();
		end,
		true
	);
end

function death_night:launch_level_raising_missions()
	if not (missions_launched) then
		local turn_number = cm:turn_number()
		missions_launched = true

		if turn_number == 2 then
			local mm1 = mission_manager:new(self.faction_key, self.mission_config.alarielle.mission_key);
			mm1:add_new_objective(self.mission_config.alarielle.objective);
			mm1:set_mission_issuer(self.mission_config.alarielle.issuer);
			for _, objective in ipairs(self.mission_config.alarielle.conditions) do
				mm1:add_condition(objective);
			end
			for _, payload in ipairs(self.mission_config.alarielle.payloads) do
				mm1:add_condition(payload);
			end
			mm1:set_should_whitelist(false);
			mm1:trigger();


			local mm2 = mission_manager:new(self.faction_key, self.mission_config.morathi.mission_key);
			mm2:add_new_objective(self.mission_config.morathi.objective);
			mm2:set_mission_issuer(self.mission_config.morathi.issuer);
			for _, objective in ipairs(self.mission_config.morathi.conditions) do
				mm2:add_condition(objective);
			end
			for _, payload in ipairs(self.mission_config.morathi.payloads) do
				mm2:add_condition(payload);
			end
			mm2:set_should_whitelist(false);
			mm2:trigger();
		end
	end
end

function death_night:turn_start_updates()
	cm:add_faction_turn_start_listener_by_name(
		"death_night_turn_start",
		self.faction_key,
		function(context)
			local bv_faction = cm:get_faction(self.blood_voyage.faction_key)
			local hellebron = cm:get_faction(self.faction_key)

			if self.triggered_this_turn == true then
				self.triggered_this_turn = false;
				
				cm:remove_garrison_residence_vfx(cm:get_region(self.har_ganeth_key):garrison_residence():command_queue_index(), self.vfx_key);
				
				if self.blood_voyage.active == false then
					death_night:blood_voyage_update()
				else
					out.design("Blood Voyage is already active, not spawning new one!");
				end
			end
			
			if self.current_resource > 0 then
				self.current_resource = self.current_resource - 1;
			end
		
			if bv_faction ~= false then
				self:apply_effects(bv_faction);
			end

			self:apply_effects(hellebron);
			self:update_ui();

			if self.blood_voyage.active == true then
				if bv_faction:is_null_interface() == true or bv_faction:is_dead() == true then
					cm:trigger_custom_incident(self.faction_key, "wh2_dlc10_incident_hef_blood_voyage_ends", true, "payload{money "..self.blood_voyage.gathered_loot_value..";}");
					core:trigger_event("ScriptEventDeathBloodVoyageDead");
					out.design("++1++ Blood Voyage Active False!");
					self.blood_voyage.active = false;
					self.blood_voyage.current_target = "";
				elseif self.blood_voyage.current_target ~= "" then
					local bv_target = cm:get_faction(self.blood_voyage.current_target);
					
					if bv_target:is_null_interface() == true or bv_target:is_dead() == true then
						local ulthuan_target, ulthuan_target_faction, human_high_elves = self:generate_ulthuan_target();
						
						if ulthuan_target ~= nil then
							cm:force_declare_war(self.blood_voyage.faction_key, ulthuan_target_faction, true, true);
						end
					end
				end
			end
			
			self:launch_level_raising_missions()
		end,
		true
	);
end

function death_night:ai_turn_start_updates()
	cm:add_faction_turn_start_listener_by_name(
		"death_night_turn_start_ai",
		self.faction_key,
		function(context)
			
			out.design("DEATH NIGHT: ai_turn_start_updates()");
			out.design("\tblood_voyage.active: "..tostring(self.blood_voyage.active));
			out.design("\tblood_voyage.loot: "..tostring(self.blood_voyage.gathered_loot_value));
			out.design("\tblood_voyage.target: "..tostring(self.blood_voyage.current_target));
			out.design("\tblood_voyage.cooldown: "..tostring(self.blood_voyage.cooldown));

			local har_ganeth = cm:get_region(self.har_ganeth_key);
			
			if har_ganeth ~= nil and har_ganeth:is_null_interface() == false and har_ganeth:owning_faction():name() == self.faction_key then
				cm:apply_effect_bundle("wh2_dlc10_death_night_effect_4", self.blood_voyage.faction_key, 0);
				if self.blood_voyage.active == false and self.blood_voyage.cooldown <= 0 then
					death_night:blood_voyage_update()
					self.blood_voyage.cooldown = -1;
				elseif self.blood_voyage.active == false and self.blood_voyage.cooldown > 0 then
					self.blood_voyage.cooldown = self.blood_voyage.cooldown - 1;
				elseif self.blood_voyage.active == true then
				
					local blood_voyage_fac = cm:get_faction(self.blood_voyage.faction_key);
					out.design("\tStatus: "..tostring(blood_voyage_fac).." / "..tostring(blood_voyage_fac:is_null_interface()).." / "..tostring(blood_voyage_fac:is_dead()));
					
					if blood_voyage_fac:is_null_interface() == true or blood_voyage_fac:is_dead() == true then
						core:trigger_event("ScriptEventDeathBloodVoyageDead");
						out.design("++3++ Blood Voyage Active False!");
						self.blood_voyage.active = false;
						self.blood_voyage.current_target = "";
						self.blood_voyage.cooldown = 30;
						cm:remove_effect_bundle("wh2_dlc10_bundle_blood_voyage_active", self.ulthuan_defender_key);
					elseif self.blood_voyage.current_target ~= "" then
						local bv_target = cm:get_faction(self.blood_voyage.current_target);
						
						if bv_target:is_null_interface() == true or bv_target:is_dead() == true then
							local ulthuan_target, ulthuan_target_faction, human_high_elves = self:generate_ulthuan_target();
							
							if ulthuan_target ~= nil then
								cm:force_declare_war(self.blood_voyage.faction_key, ulthuan_target_faction, true, true);
							end
						end
					end
				end
			end
		end,
		true
	);
end

function death_night:trigger_death_night_listener()
	core:add_listener(
		"death_night_button_pressed",
		"ComponentLClickUp",
		function(context)
			return context.string == "death_night_button";
		end,
		function(context)
			CampaignUI.TriggerCampaignScriptEvent(0, "death_night_event");
		end,
		true
	);

	core:add_listener(
		"trigger_death_night",
		"UITrigger",
		function(context)
			return context:trigger() == "death_night_event";
		end,
		function(context)
			death_night:trigger_death_night();
		end,
		true
	);
end


--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------


cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("death_night.current_resource", death_night.current_resource, context);
		cm:save_named_value("death_night.current_level", death_night.current_level, context);
		cm:save_named_value("death_night.min_level_missions", death_night.min_level_missions, context);
		cm:save_named_value("death_night.cost", death_night.cost, context);
		cm:save_named_value("death_night.triggered_this_turn", death_night.triggered_this_turn, context);
		cm:save_named_value("death_night.slaves_freed", death_night.slaves_freed, context);
		cm:save_named_value("death_night.blood_voyage.gathered_loot_value", death_night.blood_voyage.gathered_loot_value, context);
		cm:save_named_value("death_night.blood_voyage.active", death_night.blood_voyage.active, context);
		cm:save_named_value("death_night.blood_voyage.cooldown", death_night.blood_voyage.cooldown, context);
		cm:save_named_value("death_night.blood_voyage.current_target", death_night.blood_voyage.current_target, context);
		cm:save_named_value("death_night.blood_voyage.possible_targets", death_night.blood_voyage.possible_targets, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			death_night.current_resource = cm:load_named_value("death_night.current_resource", death_night.current_resource, context);
			death_night.current_level = cm:load_named_value("death_night.current_level", death_night.current_level, context);
			death_night.min_level_missions = cm:load_named_value("death_night.min_level_missions", death_night.min_level_missions, context);
			death_night.cost = cm:load_named_value("death_night.cost", death_night.cost, context);
			death_night.triggered_this_turn = cm:load_named_value("death_night.triggered_this_turn", death_night.triggered_this_turn, context);
			death_night.slaves_freed = cm:load_named_value("death_night.slaves_freed", death_night.slaves_freed, context);
			death_night.blood_voyage.gathered_loot_value = cm:load_named_value("death_night.blood_voyage.gathered_loot_value", death_night.blood_voyage.gathered_loot_value, context);
			death_night.blood_voyage.active = cm:load_named_value("death_night.blood_voyage.active", death_night.blood_voyage.active, context);
			death_night.blood_voyage.cooldown = cm:load_named_value("death_night.blood_voyage.cooldown", death_night.blood_voyage.cooldown, context);
			death_night.blood_voyage.current_target = cm:load_named_value("death_night.blood_voyage.current_target", death_night.blood_voyage.current_target, context);
			death_night.blood_voyage.possible_targets = cm:load_named_value("death_night.blood_voyage.possible_targets", death_night.blood_voyage.possible_targets, context);
		end
	end
);