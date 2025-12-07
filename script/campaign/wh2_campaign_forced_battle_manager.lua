---Forced Battle manager
---handler for dealing with forced battles.
---can be used to (semi-safely) force existing armies to fight, or can handle spawning new armies and cleaning them up afterwards

Forced_Battle_Manager = {
	forced_battles_list ={},
	active_battle = ""
}

forced_battle = {}


---wrapper function for the most basic type of forced battle. If you want to do something more elaborate you can construct it out of the other functions below.
function Forced_Battle_Manager:trigger_forced_battle_with_generated_army(
	target_force_cqi,
	generated_force_faction,
	generated_force_template,
	generated_force_size,
	generated_force_power,
	generated_force_is_attacker,
	destroy_generated_force_after_battle,
	is_ambush,
	opt_player_victory_incident,
	opt_player_defeat_incident,
	opt_general_subtype,
	opt_general_level,
	opt_effect_bundle,
	opt_player_is_generated_force,
	opt_forced_battle_key_override,
	opt_use_pre_generated_template
	)
	
	local forced_battle_key = opt_forced_battle_key_override or generated_force_template.."_forced_battle"
	local forced_battle = Forced_Battle_Manager:setup_new_battle(forced_battle_key)
	
	local generated_force
	
	-- Check if we use previously generated force template or we want to generate
	if opt_use_pre_generated_template then
		local ram = random_army_manager
		if ram:get_force_by_key(generated_force_template) then
			generated_force = ram:generate_force(generated_force_template, generated_force_size, false)
		else
			script_error("Error: trying to generate a force with a previously generated template but no such template exists.")
			return false
		end
	else
		generated_force =  WH_Random_Army_Generator:generate_random_army(forced_battle_key, generated_force_template, generated_force_size, generated_force_power, true, false)
	end

	forced_battle:add_new_force(forced_battle_key, generated_force, generated_force_faction, destroy_generated_force_after_battle, opt_effect_bundle, opt_general_subtype,opt_general_level)

	local attacker = target_force_cqi
	local defender = forced_battle_key
	local attacker_victory_incident = opt_player_victory_incident
	local defender_victory_incident = opt_player_defeat_incident
	if generated_force_is_attacker then
		defender = target_force_cqi
		attacker = forced_battle_key
		attacker_victory_incident = opt_player_defeat_incident
		defender_victory_incident = opt_player_victory_incident
	end
	local opt_player_is_generated_force = opt_player_is_generated_force or nil
	if opt_player_is_generated_force then
		cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
	end

	if attacker_victory_incident ~= nil then
		forced_battle:add_post_battle_event("incident",attacker_victory_incident,"attacker_victory")
	end

	if defender_victory_incident ~= nil then
		forced_battle:add_post_battle_event("incident",defender_victory_incident,"defender_victory")
	end

	if not cm:get_character_by_mf_cqi(target_force_cqi)then
		script_error("Error: trying to create a new forced battle, but supplied force CQI doesn't seem to have an associated general")
		return false
	end

	local player_force_general_cqi = cm:get_character_by_mf_cqi(target_force_cqi):command_queue_index()

	local x,y = cm:find_valid_spawn_location_for_character_from_character(generated_force_faction,"character_cqi:"..player_force_general_cqi,true, 6)

	forced_battle:trigger_battle(attacker, defender, x, y, is_ambush)
end

--- the battle will persist so you can call the same battle several times.
function Forced_Battle_Manager:setup_new_battle(key)
	if not is_string(key) then
		script_error("ERROR:Trying to create a new forced battle but provided key is not a string!")
		return false
	end

	out.design("Forced Battle Manager: Creating New Forced Battle with key [" .. key .. "]");
	

	for i = 1, #self.forced_battles_list do
		if key == self.forced_battles_list[i].key then
			script_error("ERROR:Forced Battle with key [" .. key .. "] already exists!");
			return false;
		end
	end

	local new_forced_battle = forced_battle:new()
	new_forced_battle.key = key
	new_forced_battle.force_list = {}
	
	out.design("\tForced Battle with key [" .. key .. "] created!");
	self.forced_battles_list[key] = new_forced_battle

	return new_forced_battle;

end

--get an existing forced battle by its key
function Forced_Battle_Manager:get_battle(key)
	if key ~= nil then
		if self.forced_battles_list[key] ~= nil then
			return self.forced_battles_list[key]
		else 
			script_error("ERROR: Forced Battle Manager - trying to get Forced Battle "..key.." but this marker cannot be found")
			return false
		end
	end
end

---assigns a force to the forced battle manager.
---the force is generated via the Invasion Manager system.
---force needs a unique ref
---if opt_destroy_after_battle is set to false, the force will persist if it survives the forced battle.
---an effect bundle can be assigned to the force that will be applied on spawn
function forced_battle:add_new_force(force_key, unit_list, faction_key, destroy_after_battle, opt_effect_bundle,opt_general_subtype,opt_general_level, opt_general_forename, opt_general_surname)
	local force_list = self.force_list
	
	if not is_string(force_key) then
		script_error("ERROR: Forced Battle Manager: Trying to add a new force to forced battle"..self.key.." but provided force key is not a string!")
		return false
	end

	if force_list[force_key] ~= nil then
		script_error("ERROR: Forced Battle Manager: Forced Battle with key [" .. force_key .. "] already exists!");
		return false;
	end

	local new_force = {}
	new_force.key = force_key


	if not is_string(faction_key) then
		script_error("ERROR: Forced Battle Manager: Trying to assign a faction to force"..force_key.." for forced battle "..self.key.." but provided faction_key is not a string!")
		return false
	end
	if cm:get_faction(faction_key) == false then
		script_error("ERROR: Forced Battle Manager: Trying to assign a faction with string"..faction_key.." to force"..force_key.." for forced battle "..self.key.." but this faction_doesn't exist")
		return false
	end

	new_force.faction_key = faction_key

	new_force.destroy_after_battle = destroy_after_battle

	if not is_boolean(new_force.destroy_after_battle) then
		script_error("ERROR: Forced Battle Manager: new forced battle force "..force_key.." destroy_after battle is not a bool")
		return false
	end

	new_force.effect_bundle = opt_effect_bundle or nil

	if new_force.effect_bundle ~= nil and not is_string(new_force.effect_bundle) then
		script_error("ERROR: Forced Battle Manager: new forced battle force "..force_key.." has been given an effect_bundle parameter, but parameter is not a string")
		return false
	end

	new_force.general_subtype = opt_general_subtype or nil
	new_force.general_forename = opt_general_forename or ""
	new_force.general_surname = opt_general_surname or ""

	if new_force.general_subtype  ~= nil and not is_string(new_force.general_subtype ) then
		script_error("ERROR: Forced Battle Manager: new forced battle force "..force_key.." has been given an general_subtype parameter, but parameter is not a string")
		return false
	end

	new_force.general_level = opt_general_level or nil

	if new_force.general_level  ~= nil and not is_number(new_force.general_level) then
		script_error("ERROR: Forced Battle Manager: new forced battle force "..force_key.." has been given an general_level parameter, but parameter is not a string")
		return false
	end

	new_force.unit_list = unit_list

	force_list[force_key]= new_force
end

--- immediately trigger a forced battle between two forces
--- this will force a war if one doesn't already exist!
--- this can use CQIs of existing forces or new forces created within the manager
--- x/y coordinates only required if target force is a created force
--- attacking forces must be able to attack (not garrisoned or in a stance)
--- defaults to not an ambush. Be wary of using ambushes if they can occur on tiles without the correct ambush setup (e.g. sea tiles, settlement maps)
--- opt_force_regular_battle will trigger an attack of opportunity but make the pre-battle UI display it as a regular battle
function forced_battle:trigger_battle(attacker_force, target_force, opt_target_x, opt_target_y, opt_is_ambush, opt_force_regular_battle)

	self.target = {}
	self.attacker = {}

	--set up the defender first
	---if a number is given, we assume it's a cqi
	if is_number(target_force) then
		local target_force_interface = cm:model():military_force_for_command_queue_index(target_force)
		if target_force_interface:is_null_interface() then
			script_error("ERROR: Force Battle Manager: trying to trigger forced battle "..self.key.." with an invalid attacker CQI!")
			return false
		end
		self.target.cqi = target_force
		self.target.is_existing = true
	---if a key is given, then we try and generate a force from the stored forces
	elseif is_string(target_force) then
		if self.force_list[target_force] == nil then
			script_error("ERROR: Force Battle Manager: trying to trigger forced battle with a generated force, but cannot find force with key "..target_force..". Has it been defined yet?")
			return false
		end
		
		if opt_target_x == nil or opt_target_y == nil then
			script_error("ERROR: Force Battle Manager: trying to trigger forced battle with generated defender "..target_force..", but we haven't been given x/y coords")
			return false
		end

		self.battle_location_x = opt_target_x
		self.battle_location_y = opt_target_y
		self.target.force_key = target_force
		self.target.is_existing = false
		self.target.destroy_after_battle = self.force_list[target_force].destroy_after_battle	
	else
		script_error("ERROR: Force Battle Manager: trying to trigger forced battle but supplied target_force: "..target_force.." is not number or string")
		return false
	end

	---now do all the same with the attacker
	if is_number(attacker_force) then
		local attacker_force_interface = cm:model():military_force_for_command_queue_index(attacker_force)
		if attacker_force_interface:is_null_interface() then
			script_error("ERROR: Force Battle Manager: trying to trigger forced battle "..self.key.." with an invalid attacker CQI!")
			return false
		end
		self.attacker.cqi = attacker_force
		self.attacker.is_existing = true
	elseif is_string(attacker_force) then
		if self.force_list[attacker_force] == nil then
			script_error("ERROR: Force Battle Manager: trying to trigger forced battle with a generated force, but cannot find force with key "..attacker_force..". Has it been defined yet?")
			return false
		end
		
		if opt_target_x == nil or opt_target_y == nil then
			script_error("ERROR: Force Battle Manager: trying to trigger forced battle with generated attacker "..attacker_force..", but we haven't been given x/y coords")
			return false
		end
		self.battle_location_x = opt_target_x
		self.battle_location_y = opt_target_y
		self.attacker.force_key = attacker_force
		self.attacker.is_existing  = false
		self.attacker.destroy_after_battle = self.force_list[attacker_force].destroy_after_battle
	else
		script_error("ERROR: Force Battle Manager: trying to trigger forced battle but supplied attacker_force: "..attacker_force.." is not number or string")
		return false
	end

	self.is_ambush = opt_is_ambush or false
	self.force_regular_battle = opt_force_regular_battle or false



	if not self.attacker.is_existing then 
		self:spawn_generated_force(self.attacker.force_key, self.battle_location_x, self.battle_location_y )
	end

	if not self.target.is_existing then
		self:spawn_generated_force(self.target.force_key, self.battle_location_x, self.battle_location_y )
	end

	Forced_Battle_Manager.active_battle = self.key
	Forced_Battle_Manager:setup_battle_completion_listener()
end




---define a custom event to fire if the battle fails due to things we can't control for in the script, e.g. can't force attacker into correct stance
---the defined event will include the context of the attacker force
--- this allows you to define a custom response (e.g. an incident telling the player to change stance) 
function forced_battle:add_battle_failed_script_event(script_event)
	if not is_string(script_event) then
		script_error("ERROR: Forced Battle Manager: Trying to assign a a failure event for forced battle "..self.key.." but provided script_event is not a string!")
		return false
	end
	self.failure_event = script_event
end



---	assign a CDIR event to be fired after the battle is resolved.
----event type can be "dilemma" or "incident"
--- event_key refers to a DB event. This must match the type specified.
--- opt_side can be either "attacker_victory", "defender_victory", or "retreat". If not specified, will fire in either case.
--- A battle can have separate events for attacker/defender victory, but not more than one for each.
function forced_battle:add_post_battle_event(event_type,event_key,opt_trigger_condition)
	local event_to_modify = opt_trigger_condition or "both"
	
	if event_type ~= "dilemma" and event_type ~= "incident"  then
		script_error("ERROR: Forced Battle Manager: Trying to assign an event for forced battle "..self.key.." but provided event_type is not 'dilemma' or  'incident'")
		return false
	end
	
	if not is_string(event_key) then
		script_error("ERROR: Forced Battle Manager: Trying to assign an event for forced battle "..self.key.." but provided event_key is not a string")
		return false
	end


	if event_to_modify == "attacker_victory" or event_to_modify == "both" then
		self.attacker_victory_event = {}
		self.attacker_victory_event.event_type = event_type		
		self.attacker_victory_event.event_key = event_key

	end

	if event_to_modify == "defender_victory" or event_to_modify == "both" then
		self.defender_victory_event = {}
		self.defender_victory_event.event_type = event_type		
		self.defender_victory_event.event_key= event_key
	end

	
end

------------------------
----internal functions
------------------------

--called on load
function Forced_Battle_Manager:load_listeners()
	if is_string(self.active_battle) and self.active_battle ~= "" then
		self:setup_battle_completion_listener()
	end
end

function Forced_Battle_Manager:setup_battle_completion_listener()
	out("Setting up Forced Battle Completion Listener")
	core:add_listener(
		"ForcedBattleCompleted",
		"BattleCompleted",
		true,
		function() 
			local attacker_won = false

			local uim = cm:get_campaign_ui_manager();
			uim:override("retreat"):unlock();

			if cm:model():pending_battle():has_been_fought() and cm:pending_battle_cache_attacker_victory() then
				attacker_won = true;
			end

			local active_forced_battle = self:get_battle(self.active_battle)
			if active_forced_battle ~= false then
				active_forced_battle:trigger_post_battle_events(attacker_won)

				-- Re-enable character event messages after battle has been completed
				local callback_delay = 0.2
				cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_character", "", "") end, callback_delay)

				active_forced_battle:clear_up_forced_battle()
			end
		end,
		false
	)
end


---this is fired from the invasion manager callback. Contains all actions that can't take place until after the forces are spawned
function forced_battle:forced_battle_stage_2()
		--- if we spawned the forces, we don't have CQIs or interfaces for them, so get them here using the invasion keys assigned earlier
		local attacker_invasion_object
		local attacker_force
		local attacker_faction
		local target_invasion_object
		local target_force
		local target_faction

		if(self.attacker.force_key) then
			attacker_invasion_object = invasion_manager:get_invasion(self.attacker.force_key)
			attacker_force = attacker_invasion_object:get_force()
			attacker_faction = attacker_force:faction()
			self.attacker.cqi = attacker_force:command_queue_index()
		else
			attacker_force = cm:get_military_force_by_cqi(self.attacker.cqi)
			attacker_faction = attacker_force:faction()
		end

		if(self.target.force_key) then
			target_invasion_object = invasion_manager:get_invasion(self.target.force_key)
			target_force = target_invasion_object:get_force()
			target_faction = target_force:faction()
			self.target.cqi = target_force:command_queue_index()
		else
			target_force = cm:get_military_force_by_cqi(self.target.cqi)
			target_faction = target_force:faction()
		end

		-- can't ambush a garrisoned force
		if target_force:has_garrison_residence() then
			self.is_ambush = false
		end
		
		-- lock the retreat button is if the attacker is in a stance that can't retreat - if they try to they instantly die.
		if attacker_force:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_DOUBLE_TIME" or attacker_force:active_stance() ==  "MILITARY_FORCE_ACTIVE_STANCE_TYPE_MARCH" then
			local uim = cm:get_campaign_ui_manager();
			uim:override("retreat"):lock();
		end

		---declare war if needed. Can't use standard invasion manager behaviour here because it doesn't kick in in time for the attack
		if not attacker_faction:at_war_with(target_faction) then
			cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "");
			cm:disable_event_feed_events(true, "wh_event_category_character", "", "");
			
			local callback_delay = 0.2
			cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "") end, callback_delay);
			cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_character", "", "") end, callback_delay);
			
			core:add_listener(
			"FactionLeaderDeclaresWarInvasionFactionDeclaresWar",
			"FactionLeaderDeclaresWar",
			true,
				function()
					cm:callback(function()
						cm:force_attack_of_opportunity(self.attacker.cqi, self.target.cqi, self.is_ambush, self.force_regular_battle)
					end, 0.05)
				end,
			false
			)

			self.attacker.faction = attacker_faction:name()
			
			cm:force_declare_war(attacker_faction:name(), target_faction:name(),false,false)
		else
			cm:callback(function()
				cm:force_attack_of_opportunity(self.attacker.cqi, self.target.cqi, self.is_ambush, self.force_regular_battle)
			end, 0.05)
		end
	
end


---spawn a force that has been defined within the manager
function forced_battle:spawn_generated_force(force_key, x, y)
	local force = self.force_list[force_key]
	
	local new_x,new_y = cm:find_valid_spawn_location_for_character_from_position(force.faction_key,x,y,true,7)

	---remove any invasions with the same key just in case
	invasion_manager:remove_invasion(force.key)

	self.invasion_key = force.key..new_x..new_y

	local forced_battle_force = invasion_manager:new_invasion(force.key,force.faction_key, force.unit_list,{new_x, new_y})
	if force.general_subtype ~= nil then
		forced_battle_force:create_general(false, force.general_subtype, force.general_forename or "", "", force.general_surname or "")
	end
	if force.general_level ~= nil then
		forced_battle_force:add_character_experience(force.general_level, true)
	end

	if force.effect_bundle ~=nil then
		local bundle_duration = -1
		forced_battle_force:apply_effect(force.effect_bundle, bundle_duration)
	end

	--- here we target the spawned invasion at the force they're attacking, if it already exists, otherwise it'll just mooch around post-battle
	local invasion_target_cqi
	local invasion_target_faction_key

	if self.target.is_existing then
		invasion_target_cqi = cm:get_character_by_mf_cqi(self.target.cqi):command_queue_index()
		invasion_target_faction_key = cm:get_character_by_mf_cqi(self.target.cqi):faction():name()
	end

	if self.attacker.is_existing then
		invasion_target_cqi = cm:get_character_by_mf_cqi(self.attacker.cqi):command_queue_index()
		invasion_target_faction_key = cm:get_character_by_mf_cqi(self.attacker.cqi):faction():name()
	end

	if self.target.existing or self.attacker.is_existing then
		forced_battle_force:set_target("CHARACTER", invasion_target_cqi, invasion_target_faction_key)
		forced_battle_force:add_aggro_radius(25, {invasion_target_faction_key}, 1)
	end

	forced_battle_force:start_invasion(
		function()
			self:forced_battle_stage_2()
		end,
		false,false,false)
	force.spawned = true
end


function forced_battle:trigger_post_battle_events(attacker_victory)

	local event_type = ""
	local event_key = ""

	if attacker_victory and self.attacker_victory_event~= nil then
		event_type = self.attacker_victory_event.event_type
		event_key = self.attacker_victory_event.event_key
	elseif not attacker_victory and self.defender_victory_event ~= nil then
		event_type = self.defender_victory_event.event_type
		event_key = self.defender_victory_event.event_key
	else 
		-- supressing events here so that the player doesn't get a bunch of "faction/army destroyed events for an army they didn't even fight"
		local callback_delay = 0.2
		cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "")
		cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
		cm:callback(function() 
			cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "") end, callback_delay)
			cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_character", "", "") end, callback_delay)
		end, callback_delay)
		return
	end

	if self.attacker.faction then
		if event_type == "incident" then
			cm:trigger_incident(self.attacker.faction, event_key, true)
		elseif event_type == "dilemma" then
			cm:trigger_dilemma(self.attacker.faction, event_key)
		end
	end
end


forced_battle.__index = forced_battle;


local function forced_battle_set_metatable(fb)
	setmetatable(fb, forced_battle);
end;


---creates the forced battle object
function forced_battle:new(o)
	o = o or {};
	forced_battle_set_metatable(o);
	return o;
end

function forced_battle:clear_up_forced_battle()
	if self.attacker.is_existing ~= true then
		local forced_battle_spawned_force = invasion_manager:get_invasion(self.attacker.force_key)

		if self.attacker.destroy_after_battle then
			forced_battle_spawned_force:kill(false)
			invasion_manager:remove_invasion(self.attacker.force_key)
		end
	end

	

	if self.target.is_existing ~= true then
		local forced_battle_spawned_force = invasion_manager:get_invasion(self.target.force_key)

		if self.target.destroy_after_battle then
			forced_battle_spawned_force:kill(false)
			invasion_manager:remove_invasion(self.target.force_key)
		end
	end
	
	

	Forced_Battle_Manager.active_battle = ""
	self.attacker = {}
	self.target = {}	
end



-----save/load

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("SAVED_FORCED_BATTLES", Forced_Battle_Manager.forced_battles_list, context);
		cm:save_named_value("ACTIVE_FORCED_BATTLE", Forced_Battle_Manager.active_battle, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			Forced_Battle_Manager.forced_battles_list = cm:load_named_value("SAVED_FORCED_BATTLES", {}, context);
			Forced_Battle_Manager.active_battle = cm:load_named_value("ACTIVE_FORCED_BATTLE", "", context);

			-- fixup forced_battle objects loaded from savegame
			for current_key, current_forced_battle in pairs(Forced_Battle_Manager.forced_battles_list) do
				forced_battle_set_metatable(current_forced_battle);
			end;
		end
	end
);